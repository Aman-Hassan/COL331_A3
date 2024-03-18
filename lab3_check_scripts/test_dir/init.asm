
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 24             	sub    $0x24,%esp
  int fd = open("console", O_RDWR);
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 90 03 00 00       	push   $0x390
  1b:	e8 f2 00 00 00       	call   112 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	89 45 e8             	mov    %eax,-0x18(%ebp)
  printf(fd, "Hello COL%d from init.c!\n", 331);
  26:	83 ec 04             	sub    $0x4,%esp
  29:	68 4b 01 00 00       	push   $0x14b
  2e:	68 98 03 00 00       	push   $0x398
  33:	ff 75 e8             	push   -0x18(%ebp)
  36:	e8 c3 01 00 00       	call   1fe <printf>
  3b:	83 c4 10             	add    $0x10,%esp
  
  int ret = get_sched_policy();
  3e:	e8 df 00 00 00       	call   122 <get_sched_policy>
  43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  printf(fd, "Set sched policy of process to : %d \n", ret);
  46:	83 ec 04             	sub    $0x4,%esp
  49:	ff 75 e4             	push   -0x1c(%ebp)
  4c:	68 b4 03 00 00       	push   $0x3b4
  51:	ff 75 e8             	push   -0x18(%ebp)
  54:	e8 a5 01 00 00       	call   1fe <printf>
  59:	83 c4 10             	add    $0x10,%esp

  int num_iterations = 15;
  5c:	c7 45 f4 0f 00 00 00 	movl   $0xf,-0xc(%ebp)
    if (ret == 1) {
  63:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  67:	75 07                	jne    70 <main+0x70>
        num_iterations = 1;
  69:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    }

  for (int j = 0; j < num_iterations; j++) {
  70:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  77:	eb 30                	jmp    a9 <main+0xa9>
    int i = 0;
  79:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(i < 100000000) {i++;}   
  80:	eb 04                	jmp    86 <main+0x86>
  82:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  86:	81 7d ec ff e0 f5 05 	cmpl   $0x5f5e0ff,-0x14(%ebp)
  8d:	7e f3                	jle    82 <main+0x82>
    printf(fd, "Task done by process with sched policy %d ... \n", ret);
  8f:	83 ec 04             	sub    $0x4,%esp
  92:	ff 75 e4             	push   -0x1c(%ebp)
  95:	68 dc 03 00 00       	push   $0x3dc
  9a:	ff 75 e8             	push   -0x18(%ebp)
  9d:	e8 5c 01 00 00       	call   1fe <printf>
  a2:	83 c4 10             	add    $0x10,%esp
  for (int j = 0; j < num_iterations; j++) {
  a5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  af:	7c c8                	jl     79 <main+0x79>
  }

    if (ret == 0) {
  b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  b5:	75 15                	jne    cc <main+0xcc>
        printf(fd, "Hurray Foreground Process Exited\n");
  b7:	83 ec 08             	sub    $0x8,%esp
  ba:	68 0c 04 00 00       	push   $0x40c
  bf:	ff 75 e8             	push   -0x18(%ebp)
  c2:	e8 37 01 00 00       	call   1fe <printf>
  c7:	83 c4 10             	add    $0x10,%esp
  ca:	eb 13                	jmp    df <main+0xdf>
    } else {
        printf(fd, "Hurray Background Process Exited\n");
  cc:	83 ec 08             	sub    $0x8,%esp
  cf:	68 30 04 00 00       	push   $0x430
  d4:	ff 75 e8             	push   -0x18(%ebp)
  d7:	e8 22 01 00 00       	call   1fe <printf>
  dc:	83 c4 10             	add    $0x10,%esp
    }


  close(fd);
  df:	83 ec 0c             	sub    $0xc,%esp
  e2:	ff 75 e8             	push   -0x18(%ebp)
  e5:	e8 18 00 00 00       	call   102 <close>
  ea:	83 c4 10             	add    $0x10,%esp
  ed:	b8 00 00 00 00       	mov    $0x0,%eax

  f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  f5:	c9                   	leave  
  f6:	8d 61 fc             	lea    -0x4(%ecx),%esp
  f9:	c3                   	ret    

000000fa <write>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(write)
  fa:	b8 02 00 00 00       	mov    $0x2,%eax
  ff:	cd 40                	int    $0x40
 101:	c3                   	ret    

00000102 <close>:
SYSCALL(close)
 102:	b8 03 00 00 00       	mov    $0x3,%eax
 107:	cd 40                	int    $0x40
 109:	c3                   	ret    

0000010a <exec>:
SYSCALL(exec)
 10a:	b8 04 00 00 00       	mov    $0x4,%eax
 10f:	cd 40                	int    $0x40
 111:	c3                   	ret    

00000112 <open>:
SYSCALL(open)
 112:	b8 01 00 00 00       	mov    $0x1,%eax
 117:	cd 40                	int    $0x40
 119:	c3                   	ret    

0000011a <set_sched_policy>:
SYSCALL(set_sched_policy)
 11a:	b8 05 00 00 00       	mov    $0x5,%eax
 11f:	cd 40                	int    $0x40
 121:	c3                   	ret    

00000122 <get_sched_policy>:
SYSCALL(get_sched_policy)
 122:	b8 06 00 00 00       	mov    $0x6,%eax
 127:	cd 40                	int    $0x40
 129:	c3                   	ret    

0000012a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 12a:	55                   	push   %ebp
 12b:	89 e5                	mov    %esp,%ebp
 12d:	83 ec 18             	sub    $0x18,%esp
 130:	8b 45 0c             	mov    0xc(%ebp),%eax
 133:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 136:	83 ec 04             	sub    $0x4,%esp
 139:	6a 01                	push   $0x1
 13b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 13e:	50                   	push   %eax
 13f:	ff 75 08             	push   0x8(%ebp)
 142:	e8 b3 ff ff ff       	call   fa <write>
 147:	83 c4 10             	add    $0x10,%esp
}
 14a:	90                   	nop
 14b:	c9                   	leave  
 14c:	c3                   	ret    

0000014d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 14d:	55                   	push   %ebp
 14e:	89 e5                	mov    %esp,%ebp
 150:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 153:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 15a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 15e:	74 17                	je     177 <printint+0x2a>
 160:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 164:	79 11                	jns    177 <printint+0x2a>
    neg = 1;
 166:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 16d:	8b 45 0c             	mov    0xc(%ebp),%eax
 170:	f7 d8                	neg    %eax
 172:	89 45 ec             	mov    %eax,-0x14(%ebp)
 175:	eb 06                	jmp    17d <printint+0x30>
  } else {
    x = xx;
 177:	8b 45 0c             	mov    0xc(%ebp),%eax
 17a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 17d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 184:	8b 4d 10             	mov    0x10(%ebp),%ecx
 187:	8b 45 ec             	mov    -0x14(%ebp),%eax
 18a:	ba 00 00 00 00       	mov    $0x0,%edx
 18f:	f7 f1                	div    %ecx
 191:	89 d1                	mov    %edx,%ecx
 193:	8b 45 f4             	mov    -0xc(%ebp),%eax
 196:	8d 50 01             	lea    0x1(%eax),%edx
 199:	89 55 f4             	mov    %edx,-0xc(%ebp)
 19c:	0f b6 91 00 05 00 00 	movzbl 0x500(%ecx),%edx
 1a3:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 1a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1ad:	ba 00 00 00 00       	mov    $0x0,%edx
 1b2:	f7 f1                	div    %ecx
 1b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 1b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 1bb:	75 c7                	jne    184 <printint+0x37>
  if(neg)
 1bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c1:	74 2d                	je     1f0 <printint+0xa3>
    buf[i++] = '-';
 1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c6:	8d 50 01             	lea    0x1(%eax),%edx
 1c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 1d1:	eb 1d                	jmp    1f0 <printint+0xa3>
    putc(fd, buf[i]);
 1d3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d9:	01 d0                	add    %edx,%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f be c0             	movsbl %al,%eax
 1e1:	83 ec 08             	sub    $0x8,%esp
 1e4:	50                   	push   %eax
 1e5:	ff 75 08             	push   0x8(%ebp)
 1e8:	e8 3d ff ff ff       	call   12a <putc>
 1ed:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 1f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 1f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f8:	79 d9                	jns    1d3 <printint+0x86>
}
 1fa:	90                   	nop
 1fb:	90                   	nop
 1fc:	c9                   	leave  
 1fd:	c3                   	ret    

000001fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 204:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 20b:	8d 45 0c             	lea    0xc(%ebp),%eax
 20e:	83 c0 04             	add    $0x4,%eax
 211:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 214:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 21b:	e9 59 01 00 00       	jmp    379 <printf+0x17b>
    c = fmt[i] & 0xff;
 220:	8b 55 0c             	mov    0xc(%ebp),%edx
 223:	8b 45 f0             	mov    -0x10(%ebp),%eax
 226:	01 d0                	add    %edx,%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	0f be c0             	movsbl %al,%eax
 22e:	25 ff 00 00 00       	and    $0xff,%eax
 233:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 236:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 23a:	75 2c                	jne    268 <printf+0x6a>
      if(c == '%'){
 23c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 240:	75 0c                	jne    24e <printf+0x50>
        state = '%';
 242:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 249:	e9 27 01 00 00       	jmp    375 <printf+0x177>
      } else {
        putc(fd, c);
 24e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 251:	0f be c0             	movsbl %al,%eax
 254:	83 ec 08             	sub    $0x8,%esp
 257:	50                   	push   %eax
 258:	ff 75 08             	push   0x8(%ebp)
 25b:	e8 ca fe ff ff       	call   12a <putc>
 260:	83 c4 10             	add    $0x10,%esp
 263:	e9 0d 01 00 00       	jmp    375 <printf+0x177>
      }
    } else if(state == '%'){
 268:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 26c:	0f 85 03 01 00 00    	jne    375 <printf+0x177>
      if(c == 'd'){
 272:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 276:	75 1e                	jne    296 <printf+0x98>
        printint(fd, *ap, 10, 1);
 278:	8b 45 e8             	mov    -0x18(%ebp),%eax
 27b:	8b 00                	mov    (%eax),%eax
 27d:	6a 01                	push   $0x1
 27f:	6a 0a                	push   $0xa
 281:	50                   	push   %eax
 282:	ff 75 08             	push   0x8(%ebp)
 285:	e8 c3 fe ff ff       	call   14d <printint>
 28a:	83 c4 10             	add    $0x10,%esp
        ap++;
 28d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 291:	e9 d8 00 00 00       	jmp    36e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 296:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 29a:	74 06                	je     2a2 <printf+0xa4>
 29c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 2a0:	75 1e                	jne    2c0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 2a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2a5:	8b 00                	mov    (%eax),%eax
 2a7:	6a 00                	push   $0x0
 2a9:	6a 10                	push   $0x10
 2ab:	50                   	push   %eax
 2ac:	ff 75 08             	push   0x8(%ebp)
 2af:	e8 99 fe ff ff       	call   14d <printint>
 2b4:	83 c4 10             	add    $0x10,%esp
        ap++;
 2b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 2bb:	e9 ae 00 00 00       	jmp    36e <printf+0x170>
      } else if(c == 's'){
 2c0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 2c4:	75 43                	jne    309 <printf+0x10b>
        s = (char*)*ap;
 2c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2c9:	8b 00                	mov    (%eax),%eax
 2cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 2ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 2d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2d6:	75 25                	jne    2fd <printf+0xff>
          s = "(null)";
 2d8:	c7 45 f4 52 04 00 00 	movl   $0x452,-0xc(%ebp)
        while(*s != 0){
 2df:	eb 1c                	jmp    2fd <printf+0xff>
          putc(fd, *s);
 2e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e4:	0f b6 00             	movzbl (%eax),%eax
 2e7:	0f be c0             	movsbl %al,%eax
 2ea:	83 ec 08             	sub    $0x8,%esp
 2ed:	50                   	push   %eax
 2ee:	ff 75 08             	push   0x8(%ebp)
 2f1:	e8 34 fe ff ff       	call   12a <putc>
 2f6:	83 c4 10             	add    $0x10,%esp
          s++;
 2f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 2fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 300:	0f b6 00             	movzbl (%eax),%eax
 303:	84 c0                	test   %al,%al
 305:	75 da                	jne    2e1 <printf+0xe3>
 307:	eb 65                	jmp    36e <printf+0x170>
        }
      } else if(c == 'c'){
 309:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 30d:	75 1d                	jne    32c <printf+0x12e>
        putc(fd, *ap);
 30f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 312:	8b 00                	mov    (%eax),%eax
 314:	0f be c0             	movsbl %al,%eax
 317:	83 ec 08             	sub    $0x8,%esp
 31a:	50                   	push   %eax
 31b:	ff 75 08             	push   0x8(%ebp)
 31e:	e8 07 fe ff ff       	call   12a <putc>
 323:	83 c4 10             	add    $0x10,%esp
        ap++;
 326:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 32a:	eb 42                	jmp    36e <printf+0x170>
      } else if(c == '%'){
 32c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 330:	75 17                	jne    349 <printf+0x14b>
        putc(fd, c);
 332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 335:	0f be c0             	movsbl %al,%eax
 338:	83 ec 08             	sub    $0x8,%esp
 33b:	50                   	push   %eax
 33c:	ff 75 08             	push   0x8(%ebp)
 33f:	e8 e6 fd ff ff       	call   12a <putc>
 344:	83 c4 10             	add    $0x10,%esp
 347:	eb 25                	jmp    36e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 349:	83 ec 08             	sub    $0x8,%esp
 34c:	6a 25                	push   $0x25
 34e:	ff 75 08             	push   0x8(%ebp)
 351:	e8 d4 fd ff ff       	call   12a <putc>
 356:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 359:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 35c:	0f be c0             	movsbl %al,%eax
 35f:	83 ec 08             	sub    $0x8,%esp
 362:	50                   	push   %eax
 363:	ff 75 08             	push   0x8(%ebp)
 366:	e8 bf fd ff ff       	call   12a <putc>
 36b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 36e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 375:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 379:	8b 55 0c             	mov    0xc(%ebp),%edx
 37c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 37f:	01 d0                	add    %edx,%eax
 381:	0f b6 00             	movzbl (%eax),%eax
 384:	84 c0                	test   %al,%al
 386:	0f 85 94 fe ff ff    	jne    220 <printf+0x22>
    }
  }
}
 38c:	90                   	nop
 38d:	90                   	nop
 38e:	c9                   	leave  
 38f:	c3                   	ret    
