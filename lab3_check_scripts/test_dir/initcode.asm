
initcode.o:     file format elf32-i386


Disassembly of section .text:

00000000 <start>:


# exec(init, argv)
.globl start
start:
  pushl $init
   0:	68 0e 00 00 00       	push   $0xe
  pushl $0  // where caller pc would be
   5:	6a 00                	push   $0x0
  movl $SYS_exec, %eax
   7:	b8 04 00 00 00       	mov    $0x4,%eax
  int $T_SYSCALL
   c:	cd 40                	int    $0x40

0000000e <init>:
   e:	2f                   	das    
   f:	69                   	.byte 0x69
  10:	6e                   	outsb  %ds:(%esi),(%dx)
  11:	69                   	.byte 0x69
  12:	74 00                	je     14 <init+0x6>
	...
