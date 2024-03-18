#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"

struct {
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void trapret(void);

int
cpuid() {
  return 0;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  return &cpus[0];
}

// Read proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c = mycpu();
  return c->proc;
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  if((p->offset = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  p->sz = PGSIZE - KSTACKSIZE;

  sp = (char*)(p->offset + PGSIZE);

  // Allocate kernel stack.
  p->kstack = sp - KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)trapret;

  return p;
}

// Set up first process.
void
pinit(int pol)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;

  memmove(p->offset, _binary_initcode_start, (int)_binary_initcode_size);
  memset(p->tf, 0, sizeof(*p->tf));

  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;

  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE - KSTACKSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;
  p->policy = pol;
}

// process scheduler.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
// void
// scheduler(void)
// {
//   struct proc *p;
//   struct cpu *c = mycpu();
//   c->proc = 0;
  
//   for(;;){
//     // Enable interrupts on this processor.
//     sti();

//     // Loop over process table looking for process to run.
//     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//       if(p->state != RUNNABLE)
//         continue;

//       // Switch to chosen process. 
//       c->proc = p;
//       p->state = RUNNING;

//       switchuvm(p);
//       swtch(&(c->scheduler), p->context);
//     }
//   }
// }

void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  int fg_run = 0;
  int bg_run = 0;
  struct proc *fg_queue[NPROC];
  struct proc *bg_queue[NPROC];
  int fg_index = 0;
  int bg_index = 0;

  for (;;){
  // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run and add to respective queues.
    int fg_count = 0;
    int bg_count = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      if(p->policy == 0){
        fg_queue[fg_count % NPROC] = p;
        fg_count++;
      } else {
        bg_queue[bg_count % NPROC] = p;
        bg_count++;
      }
    }

    if(fg_count > 0 && (bg_count == 0 || fg_run < 9 || (bg_run > 0 && fg_run < 9 * bg_run))){ // there is a fg process to run and either fg has not run 9 times or there is no bg process to run or fg has run less than 9 times bg has run
      p = fg_queue[fg_index % fg_count];
      fg_index = (fg_index + 1) % fg_count;
      fg_run++;
    } else if(bg_count > 0){
      p = bg_queue[bg_index % bg_count];
      bg_index = (bg_index + 1) % bg_count;
      bg_run++;
    } else {
      continue;
    }

    c->proc = p;
    p->state = RUNNING;

    switchuvm(p);
    swtch(&(c->scheduler), p->context);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct cpu* c = mycpu();
  struct proc *p = myproc();

  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = c->intena;
  swtch(&p->context, c->scheduler);
  c->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  myproc()->state = RUNNABLE;
  sched();
}

void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  };
  struct proc *p;
  char *state;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    cprintf("\n");
  }
}