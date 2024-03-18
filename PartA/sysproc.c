#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "sysproc.h"

/* System Call Definitions */
int 
sys_set_sched_policy(void)
{
    int sched_policy;
    struct proc *curproc = myproc();

    if(argint(0, &sched_policy) < 0) {
        return -22;
    }

    if(sched_policy != FG && sched_policy != BG){
        return -22;
    }

    curproc->policy = sched_policy;
    return 0;
}

int 
sys_get_sched_policy(void)
{
    struct proc *curproc = myproc();
    return curproc->policy;
}
