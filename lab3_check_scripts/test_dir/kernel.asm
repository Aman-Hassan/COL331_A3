
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot_header>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4                   	.byte 0xe4

0010000c <_start>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
  10000c:	bc d0 fa 10 00       	mov    $0x10fad0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
  100011:	b8 6f 08 10 00       	mov    $0x10086f,%eax
  jmp *%eax
  100016:	ff e0                	jmp    *%eax

00100018 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
  100018:	55                   	push   %ebp
  100019:	89 e5                	mov    %esp,%ebp
  10001b:	83 ec 08             	sub    $0x8,%esp
  10001e:	8b 55 08             	mov    0x8(%ebp),%edx
  100021:	8b 45 0c             	mov    0xc(%ebp),%eax
  100024:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
  100028:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10002c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100030:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100034:	66 ef                	out    %ax,(%dx)
}
  100036:	90                   	nop
  100037:	c9                   	leave  
  100038:	c3                   	ret    

00100039 <cli>:
  return eflags;
}

static inline void
cli(void)
{
  100039:	55                   	push   %ebp
  10003a:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
  10003c:	fa                   	cli    
}
  10003d:	90                   	nop
  10003e:	5d                   	pop    %ebp
  10003f:	c3                   	ret    

00100040 <printint>:

static int panicked = 0;

static void
printint(int xx, int base, int sign)
{
  100040:	55                   	push   %ebp
  100041:	89 e5                	mov    %esp,%ebp
  100043:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
  100046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10004a:	74 1c                	je     100068 <printint+0x28>
  10004c:	8b 45 08             	mov    0x8(%ebp),%eax
  10004f:	c1 e8 1f             	shr    $0x1f,%eax
  100052:	0f b6 c0             	movzbl %al,%eax
  100055:	89 45 10             	mov    %eax,0x10(%ebp)
  100058:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10005c:	74 0a                	je     100068 <printint+0x28>
    x = -xx;
  10005e:	8b 45 08             	mov    0x8(%ebp),%eax
  100061:	f7 d8                	neg    %eax
  100063:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100066:	eb 06                	jmp    10006e <printint+0x2e>
  else
    x = xx;
  100068:	8b 45 08             	mov    0x8(%ebp),%eax
  10006b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
  10006e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
  100075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10007b:	ba 00 00 00 00       	mov    $0x0,%edx
  100080:	f7 f1                	div    %ecx
  100082:	89 d1                	mov    %edx,%ecx
  100084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100087:	8d 50 01             	lea    0x1(%eax),%edx
  10008a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10008d:	0f b6 91 00 60 10 00 	movzbl 0x106000(%ecx),%edx
  100094:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
  100098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10009b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10009e:	ba 00 00 00 00       	mov    $0x0,%edx
  1000a3:	f7 f1                	div    %ecx
  1000a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1000a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1000ac:	75 c7                	jne    100075 <printint+0x35>

  if(sign)
  1000ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1000b2:	74 2a                	je     1000de <printint+0x9e>
    buf[i++] = '-';
  1000b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000b7:	8d 50 01             	lea    0x1(%eax),%edx
  1000ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1000bd:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
  1000c2:	eb 1a                	jmp    1000de <printint+0x9e>
    consputc(buf[i]);
  1000c4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1000c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000ca:	01 d0                	add    %edx,%eax
  1000cc:	0f b6 00             	movzbl (%eax),%eax
  1000cf:	0f be c0             	movsbl %al,%eax
  1000d2:	83 ec 0c             	sub    $0xc,%esp
  1000d5:	50                   	push   %eax
  1000d6:	e8 5f 02 00 00       	call   10033a <consputc>
  1000db:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
  1000de:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1000e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1000e6:	79 dc                	jns    1000c4 <printint+0x84>
}
  1000e8:	90                   	nop
  1000e9:	90                   	nop
  1000ea:	c9                   	leave  
  1000eb:	c3                   	ret    

001000ec <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  1000ec:	55                   	push   %ebp
  1000ed:	89 e5                	mov    %esp,%ebp
  1000ef:	83 ec 18             	sub    $0x18,%esp
  int i, c;
  uint *argp;
  char *s;

  if (fmt == 0)
  1000f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000f5:	85 c0                	test   %eax,%eax
  1000f7:	0f 84 63 01 00 00    	je     100260 <cprintf+0x174>
    // panic("null fmt");
    return;

  argp = (uint*)(void*)(&fmt + 1);
  1000fd:	8d 45 0c             	lea    0xc(%ebp),%eax
  100100:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100103:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10010a:	e9 2f 01 00 00       	jmp    10023e <cprintf+0x152>
    if(c != '%'){
  10010f:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
  100113:	74 13                	je     100128 <cprintf+0x3c>
      consputc(c);
  100115:	83 ec 0c             	sub    $0xc,%esp
  100118:	ff 75 e8             	push   -0x18(%ebp)
  10011b:	e8 1a 02 00 00       	call   10033a <consputc>
  100120:	83 c4 10             	add    $0x10,%esp
      continue;
  100123:	e9 12 01 00 00       	jmp    10023a <cprintf+0x14e>
    }
    c = fmt[++i] & 0xff;
  100128:	8b 55 08             	mov    0x8(%ebp),%edx
  10012b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100132:	01 d0                	add    %edx,%eax
  100134:	0f b6 00             	movzbl (%eax),%eax
  100137:	0f be c0             	movsbl %al,%eax
  10013a:	25 ff 00 00 00       	and    $0xff,%eax
  10013f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(c == 0)
  100142:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  100146:	0f 84 17 01 00 00    	je     100263 <cprintf+0x177>
      break;
    switch(c){
  10014c:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
  100150:	74 5e                	je     1001b0 <cprintf+0xc4>
  100152:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
  100156:	0f 8f c2 00 00 00    	jg     10021e <cprintf+0x132>
  10015c:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
  100160:	74 6b                	je     1001cd <cprintf+0xe1>
  100162:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
  100166:	0f 8f b2 00 00 00    	jg     10021e <cprintf+0x132>
  10016c:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
  100170:	74 3e                	je     1001b0 <cprintf+0xc4>
  100172:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
  100176:	0f 8f a2 00 00 00    	jg     10021e <cprintf+0x132>
  10017c:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
  100180:	0f 84 89 00 00 00    	je     10020f <cprintf+0x123>
  100186:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
  10018a:	0f 85 8e 00 00 00    	jne    10021e <cprintf+0x132>
    case 'd':
      printint(*argp++, 10, 1);
  100190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100193:	8d 50 04             	lea    0x4(%eax),%edx
  100196:	89 55 f0             	mov    %edx,-0x10(%ebp)
  100199:	8b 00                	mov    (%eax),%eax
  10019b:	83 ec 04             	sub    $0x4,%esp
  10019e:	6a 01                	push   $0x1
  1001a0:	6a 0a                	push   $0xa
  1001a2:	50                   	push   %eax
  1001a3:	e8 98 fe ff ff       	call   100040 <printint>
  1001a8:	83 c4 10             	add    $0x10,%esp
      break;
  1001ab:	e9 8a 00 00 00       	jmp    10023a <cprintf+0x14e>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
  1001b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1001b3:	8d 50 04             	lea    0x4(%eax),%edx
  1001b6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1001b9:	8b 00                	mov    (%eax),%eax
  1001bb:	83 ec 04             	sub    $0x4,%esp
  1001be:	6a 00                	push   $0x0
  1001c0:	6a 10                	push   $0x10
  1001c2:	50                   	push   %eax
  1001c3:	e8 78 fe ff ff       	call   100040 <printint>
  1001c8:	83 c4 10             	add    $0x10,%esp
      break;
  1001cb:	eb 6d                	jmp    10023a <cprintf+0x14e>
    case 's':
      if((s = (char*)*argp++) == 0)
  1001cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1001d0:	8d 50 04             	lea    0x4(%eax),%edx
  1001d3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1001d6:	8b 00                	mov    (%eax),%eax
  1001d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1001db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1001df:	75 22                	jne    100203 <cprintf+0x117>
        s = "(null)";
  1001e1:	c7 45 ec 2c 56 10 00 	movl   $0x10562c,-0x14(%ebp)
      for(; *s; s++)
  1001e8:	eb 19                	jmp    100203 <cprintf+0x117>
        consputc(*s);
  1001ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1001ed:	0f b6 00             	movzbl (%eax),%eax
  1001f0:	0f be c0             	movsbl %al,%eax
  1001f3:	83 ec 0c             	sub    $0xc,%esp
  1001f6:	50                   	push   %eax
  1001f7:	e8 3e 01 00 00       	call   10033a <consputc>
  1001fc:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
  1001ff:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100206:	0f b6 00             	movzbl (%eax),%eax
  100209:	84 c0                	test   %al,%al
  10020b:	75 dd                	jne    1001ea <cprintf+0xfe>
      break;
  10020d:	eb 2b                	jmp    10023a <cprintf+0x14e>
    case '%':
      consputc('%');
  10020f:	83 ec 0c             	sub    $0xc,%esp
  100212:	6a 25                	push   $0x25
  100214:	e8 21 01 00 00       	call   10033a <consputc>
  100219:	83 c4 10             	add    $0x10,%esp
      break;
  10021c:	eb 1c                	jmp    10023a <cprintf+0x14e>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
  10021e:	83 ec 0c             	sub    $0xc,%esp
  100221:	6a 25                	push   $0x25
  100223:	e8 12 01 00 00       	call   10033a <consputc>
  100228:	83 c4 10             	add    $0x10,%esp
      consputc(c);
  10022b:	83 ec 0c             	sub    $0xc,%esp
  10022e:	ff 75 e8             	push   -0x18(%ebp)
  100231:	e8 04 01 00 00       	call   10033a <consputc>
  100236:	83 c4 10             	add    $0x10,%esp
      break;
  100239:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10023a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10023e:	8b 55 08             	mov    0x8(%ebp),%edx
  100241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100244:	01 d0                	add    %edx,%eax
  100246:	0f b6 00             	movzbl (%eax),%eax
  100249:	0f be c0             	movsbl %al,%eax
  10024c:	25 ff 00 00 00       	and    $0xff,%eax
  100251:	89 45 e8             	mov    %eax,-0x18(%ebp)
  100254:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  100258:	0f 85 b1 fe ff ff    	jne    10010f <cprintf+0x23>
  10025e:	eb 04                	jmp    100264 <cprintf+0x178>
    return;
  100260:	90                   	nop
  100261:	eb 01                	jmp    100264 <cprintf+0x178>
      break;
  100263:	90                   	nop
    }
  }
}
  100264:	c9                   	leave  
  100265:	c3                   	ret    

00100266 <halt>:

void
halt(void)
{
  100266:	55                   	push   %ebp
  100267:	89 e5                	mov    %esp,%ebp
  100269:	83 ec 08             	sub    $0x8,%esp
  cprintf("Bye COL%d!\n\0", 331);
  10026c:	83 ec 08             	sub    $0x8,%esp
  10026f:	68 4b 01 00 00       	push   $0x14b
  100274:	68 33 56 10 00       	push   $0x105633
  100279:	e8 6e fe ff ff       	call   1000ec <cprintf>
  10027e:	83 c4 10             	add    $0x10,%esp
  outw(0x602, 0x2000);
  100281:	83 ec 08             	sub    $0x8,%esp
  100284:	68 00 20 00 00       	push   $0x2000
  100289:	68 02 06 00 00       	push   $0x602
  10028e:	e8 85 fd ff ff       	call   100018 <outw>
  100293:	83 c4 10             	add    $0x10,%esp
  // For older versions of QEMU, 
  outw(0xB002, 0x2000);
  100296:	83 ec 08             	sub    $0x8,%esp
  100299:	68 00 20 00 00       	push   $0x2000
  10029e:	68 02 b0 00 00       	push   $0xb002
  1002a3:	e8 70 fd ff ff       	call   100018 <outw>
  1002a8:	83 c4 10             	add    $0x10,%esp
  for(;;);
  1002ab:	eb fe                	jmp    1002ab <halt+0x45>

001002ad <panic>:
}

void
panic(char *s)
{
  1002ad:	55                   	push   %ebp
  1002ae:	89 e5                	mov    %esp,%ebp
  1002b0:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
  1002b3:	e8 81 fd ff ff       	call   100039 <cli>
  cprintf("lapicid %d: panic: ", lapicid());
  1002b8:	e8 68 05 00 00       	call   100825 <lapicid>
  1002bd:	83 ec 08             	sub    $0x8,%esp
  1002c0:	50                   	push   %eax
  1002c1:	68 40 56 10 00       	push   $0x105640
  1002c6:	e8 21 fe ff ff       	call   1000ec <cprintf>
  1002cb:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	83 ec 0c             	sub    $0xc,%esp
  1002d4:	50                   	push   %eax
  1002d5:	e8 12 fe ff ff       	call   1000ec <cprintf>
  1002da:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
  1002dd:	83 ec 0c             	sub    $0xc,%esp
  1002e0:	68 54 56 10 00       	push   $0x105654
  1002e5:	e8 02 fe ff ff       	call   1000ec <cprintf>
  1002ea:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
  1002ed:	83 ec 08             	sub    $0x8,%esp
  1002f0:	8d 45 cc             	lea    -0x34(%ebp),%eax
  1002f3:	50                   	push   %eax
  1002f4:	8d 45 08             	lea    0x8(%ebp),%eax
  1002f7:	50                   	push   %eax
  1002f8:	e8 4a 13 00 00       	call   101647 <getcallerpcs>
  1002fd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
  100300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100307:	eb 1c                	jmp    100325 <panic+0x78>
    cprintf(" %p", pcs[i]);
  100309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10030c:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
  100310:	83 ec 08             	sub    $0x8,%esp
  100313:	50                   	push   %eax
  100314:	68 56 56 10 00       	push   $0x105656
  100319:	e8 ce fd ff ff       	call   1000ec <cprintf>
  10031e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
  100321:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100325:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  100329:	7e de                	jle    100309 <panic+0x5c>
  panicked = 1; // freeze other CPU
  10032b:	c7 05 ec 64 10 00 01 	movl   $0x1,0x1064ec
  100332:	00 00 00 
  halt();
  100335:	e8 2c ff ff ff       	call   100266 <halt>

0010033a <consputc>:

#define BACKSPACE 0x100

void
consputc(int c)
{
  10033a:	55                   	push   %ebp
  10033b:	89 e5                	mov    %esp,%ebp
  10033d:	83 ec 08             	sub    $0x8,%esp
  if(c == BACKSPACE){
  100340:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
  100347:	75 29                	jne    100372 <consputc+0x38>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  100349:	83 ec 0c             	sub    $0xc,%esp
  10034c:	6a 08                	push   $0x8
  10034e:	e8 b1 0a 00 00       	call   100e04 <uartputc>
  100353:	83 c4 10             	add    $0x10,%esp
  100356:	83 ec 0c             	sub    $0xc,%esp
  100359:	6a 20                	push   $0x20
  10035b:	e8 a4 0a 00 00       	call   100e04 <uartputc>
  100360:	83 c4 10             	add    $0x10,%esp
  100363:	83 ec 0c             	sub    $0xc,%esp
  100366:	6a 08                	push   $0x8
  100368:	e8 97 0a 00 00       	call   100e04 <uartputc>
  10036d:	83 c4 10             	add    $0x10,%esp
  } else
    uartputc(c);
}
  100370:	eb 0e                	jmp    100380 <consputc+0x46>
    uartputc(c);
  100372:	83 ec 0c             	sub    $0xc,%esp
  100375:	ff 75 08             	push   0x8(%ebp)
  100378:	e8 87 0a 00 00       	call   100e04 <uartputc>
  10037d:	83 c4 10             	add    $0x10,%esp
}
  100380:	90                   	nop
  100381:	c9                   	leave  
  100382:	c3                   	ret    

00100383 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  100383:	55                   	push   %ebp
  100384:	89 e5                	mov    %esp,%ebp
  100386:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump=0;
  100389:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  while((c = getc()) >= 0){
  100390:	e9 39 01 00 00       	jmp    1004ce <consoleintr+0x14b>
    switch(c){
  100395:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
  100399:	0f 84 81 00 00 00    	je     100420 <consoleintr+0x9d>
  10039f:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
  1003a3:	0f 8f a9 00 00 00    	jg     100452 <consoleintr+0xcf>
  1003a9:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
  1003ad:	74 43                	je     1003f2 <consoleintr+0x6f>
  1003af:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
  1003b3:	0f 8f 99 00 00 00    	jg     100452 <consoleintr+0xcf>
  1003b9:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003bd:	74 61                	je     100420 <consoleintr+0x9d>
  1003bf:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
  1003c3:	0f 85 89 00 00 00    	jne    100452 <consoleintr+0xcf>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
  1003c9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
  1003d0:	e9 f9 00 00 00       	jmp    1004ce <consoleintr+0x14b>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  1003d5:	a1 e8 64 10 00       	mov    0x1064e8,%eax
  1003da:	83 e8 01             	sub    $0x1,%eax
  1003dd:	a3 e8 64 10 00       	mov    %eax,0x1064e8
        consputc(BACKSPACE);
  1003e2:	83 ec 0c             	sub    $0xc,%esp
  1003e5:	68 00 01 00 00       	push   $0x100
  1003ea:	e8 4b ff ff ff       	call   10033a <consputc>
  1003ef:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
  1003f2:	8b 15 e8 64 10 00    	mov    0x1064e8,%edx
  1003f8:	a1 e4 64 10 00       	mov    0x1064e4,%eax
  1003fd:	39 c2                	cmp    %eax,%edx
  1003ff:	0f 84 c9 00 00 00    	je     1004ce <consoleintr+0x14b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  100405:	a1 e8 64 10 00       	mov    0x1064e8,%eax
  10040a:	83 e8 01             	sub    $0x1,%eax
  10040d:	83 e0 7f             	and    $0x7f,%eax
  100410:	0f b6 80 60 64 10 00 	movzbl 0x106460(%eax),%eax
      while(input.e != input.w &&
  100417:	3c 0a                	cmp    $0xa,%al
  100419:	75 ba                	jne    1003d5 <consoleintr+0x52>
      }
      break;
  10041b:	e9 ae 00 00 00       	jmp    1004ce <consoleintr+0x14b>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
  100420:	8b 15 e8 64 10 00    	mov    0x1064e8,%edx
  100426:	a1 e4 64 10 00       	mov    0x1064e4,%eax
  10042b:	39 c2                	cmp    %eax,%edx
  10042d:	0f 84 9b 00 00 00    	je     1004ce <consoleintr+0x14b>
        input.e--;
  100433:	a1 e8 64 10 00       	mov    0x1064e8,%eax
  100438:	83 e8 01             	sub    $0x1,%eax
  10043b:	a3 e8 64 10 00       	mov    %eax,0x1064e8
        consputc(BACKSPACE);
  100440:	83 ec 0c             	sub    $0xc,%esp
  100443:	68 00 01 00 00       	push   $0x100
  100448:	e8 ed fe ff ff       	call   10033a <consputc>
  10044d:	83 c4 10             	add    $0x10,%esp
      }
      break;
  100450:	eb 7c                	jmp    1004ce <consoleintr+0x14b>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  100452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100456:	74 75                	je     1004cd <consoleintr+0x14a>
  100458:	a1 e8 64 10 00       	mov    0x1064e8,%eax
  10045d:	8b 15 e0 64 10 00    	mov    0x1064e0,%edx
  100463:	29 d0                	sub    %edx,%eax
  100465:	83 f8 7f             	cmp    $0x7f,%eax
  100468:	77 63                	ja     1004cd <consoleintr+0x14a>
        c = (c == '\r') ? '\n' : c;
  10046a:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10046e:	74 05                	je     100475 <consoleintr+0xf2>
  100470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100473:	eb 05                	jmp    10047a <consoleintr+0xf7>
  100475:	b8 0a 00 00 00       	mov    $0xa,%eax
  10047a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
  10047d:	a1 e8 64 10 00       	mov    0x1064e8,%eax
  100482:	8d 50 01             	lea    0x1(%eax),%edx
  100485:	89 15 e8 64 10 00    	mov    %edx,0x1064e8
  10048b:	83 e0 7f             	and    $0x7f,%eax
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	88 90 60 64 10 00    	mov    %dl,0x106460(%eax)
        consputc(c);
  100497:	83 ec 0c             	sub    $0xc,%esp
  10049a:	ff 75 f0             	push   -0x10(%ebp)
  10049d:	e8 98 fe ff ff       	call   10033a <consputc>
  1004a2:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1004a5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1004a9:	74 18                	je     1004c3 <consoleintr+0x140>
  1004ab:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  1004af:	74 12                	je     1004c3 <consoleintr+0x140>
  1004b1:	a1 e8 64 10 00       	mov    0x1064e8,%eax
  1004b6:	8b 15 e0 64 10 00    	mov    0x1064e0,%edx
  1004bc:	83 ea 80             	sub    $0xffffff80,%edx
  1004bf:	39 d0                	cmp    %edx,%eax
  1004c1:	75 0a                	jne    1004cd <consoleintr+0x14a>
          // call myproc with the buf
          input.w = input.e;
  1004c3:	a1 e8 64 10 00       	mov    0x1064e8,%eax
  1004c8:	a3 e4 64 10 00       	mov    %eax,0x1064e4
        }
      }
      break;
  1004cd:	90                   	nop
  while((c = getc()) >= 0){
  1004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d1:	ff d0                	call   *%eax
  1004d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1004d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1004da:	0f 89 b5 fe ff ff    	jns    100395 <consoleintr+0x12>
    }
  }
  if(doprocdump) {
  1004e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e4:	74 05                	je     1004eb <consoleintr+0x168>
    procdump();
  1004e6:	e8 ae 10 00 00       	call   101599 <procdump>
  }
}
  1004eb:	90                   	nop
  1004ec:	c9                   	leave  
  1004ed:	c3                   	ret    

001004ee <consoleread>:


int
consoleread(struct inode *ip, char *dst, int n)
{
  1004ee:	55                   	push   %ebp
  1004ef:	89 e5                	mov    %esp,%ebp
  1004f1:	83 ec 10             	sub    $0x10,%esp
  uint target;
  int c;

  target = n;
  1004f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n > 0){
  1004fa:	eb 63                	jmp    10055f <consoleread+0x71>
    while(input.r == input.w);
  1004fc:	90                   	nop
  1004fd:	8b 15 e0 64 10 00    	mov    0x1064e0,%edx
  100503:	a1 e4 64 10 00       	mov    0x1064e4,%eax
  100508:	39 c2                	cmp    %eax,%edx
  10050a:	74 f1                	je     1004fd <consoleread+0xf>
    c = input.buf[input.r++ % INPUT_BUF];
  10050c:	a1 e0 64 10 00       	mov    0x1064e0,%eax
  100511:	8d 50 01             	lea    0x1(%eax),%edx
  100514:	89 15 e0 64 10 00    	mov    %edx,0x1064e0
  10051a:	83 e0 7f             	and    $0x7f,%eax
  10051d:	0f b6 80 60 64 10 00 	movzbl 0x106460(%eax),%eax
  100524:	0f be c0             	movsbl %al,%eax
  100527:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(c == C('D')){  // EOF
  10052a:	83 7d f8 04          	cmpl   $0x4,-0x8(%ebp)
  10052e:	75 17                	jne    100547 <consoleread+0x59>
      if(n < target){
  100530:	8b 45 10             	mov    0x10(%ebp),%eax
  100533:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100536:	76 2f                	jbe    100567 <consoleread+0x79>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
  100538:	a1 e0 64 10 00       	mov    0x1064e0,%eax
  10053d:	83 e8 01             	sub    $0x1,%eax
  100540:	a3 e0 64 10 00       	mov    %eax,0x1064e0
      }
      break;
  100545:	eb 20                	jmp    100567 <consoleread+0x79>
    }
    *dst++ = c;
  100547:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054a:	8d 50 01             	lea    0x1(%eax),%edx
  10054d:	89 55 0c             	mov    %edx,0xc(%ebp)
  100550:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100553:	88 10                	mov    %dl,(%eax)
    --n;
  100555:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
  100559:	83 7d f8 0a          	cmpl   $0xa,-0x8(%ebp)
  10055d:	74 0b                	je     10056a <consoleread+0x7c>
  while(n > 0){
  10055f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  100563:	7f 97                	jg     1004fc <consoleread+0xe>
  100565:	eb 04                	jmp    10056b <consoleread+0x7d>
      break;
  100567:	90                   	nop
  100568:	eb 01                	jmp    10056b <consoleread+0x7d>
      break;
  10056a:	90                   	nop
  }

  return target - n;
  10056b:	8b 55 10             	mov    0x10(%ebp),%edx
  10056e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100571:	29 d0                	sub    %edx,%eax
}
  100573:	c9                   	leave  
  100574:	c3                   	ret    

00100575 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
  100575:	55                   	push   %ebp
  100576:	89 e5                	mov    %esp,%ebp
  100578:	83 ec 18             	sub    $0x18,%esp
  int i;
  for(i = 0; i < n; i++)
  10057b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100582:	eb 21                	jmp    1005a5 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  100584:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100587:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058a:	01 d0                	add    %edx,%eax
  10058c:	0f b6 00             	movzbl (%eax),%eax
  10058f:	0f be c0             	movsbl %al,%eax
  100592:	0f b6 c0             	movzbl %al,%eax
  100595:	83 ec 0c             	sub    $0xc,%esp
  100598:	50                   	push   %eax
  100599:	e8 9c fd ff ff       	call   10033a <consputc>
  10059e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
  1005a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1005a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005a8:	3b 45 10             	cmp    0x10(%ebp),%eax
  1005ab:	7c d7                	jl     100584 <consolewrite+0xf>
  return n;
  1005ad:	8b 45 10             	mov    0x10(%ebp),%eax
}
  1005b0:	c9                   	leave  
  1005b1:	c3                   	ret    

001005b2 <consoleinit>:

void
consoleinit(void)
{
  1005b2:	55                   	push   %ebp
  1005b3:	89 e5                	mov    %esp,%ebp
  devsw[CONSOLE].write = consolewrite;
  1005b5:	c7 05 0c e2 10 00 75 	movl   $0x100575,0x10e20c
  1005bc:	05 10 00 
  devsw[CONSOLE].read = consoleread;
  1005bf:	c7 05 08 e2 10 00 ee 	movl   $0x1004ee,0x10e208
  1005c6:	04 10 00 
  1005c9:	90                   	nop
  1005ca:	5d                   	pop    %ebp
  1005cb:	c3                   	ret    

001005cc <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
  1005cc:	55                   	push   %ebp
  1005cd:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1005cf:	a1 f0 64 10 00       	mov    0x1064f0,%eax
  1005d4:	8b 55 08             	mov    0x8(%ebp),%edx
  1005d7:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
  1005d9:	a1 f0 64 10 00       	mov    0x1064f0,%eax
  1005de:	8b 40 10             	mov    0x10(%eax),%eax
}
  1005e1:	5d                   	pop    %ebp
  1005e2:	c3                   	ret    

001005e3 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  1005e3:	55                   	push   %ebp
  1005e4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1005e6:	a1 f0 64 10 00       	mov    0x1064f0,%eax
  1005eb:	8b 55 08             	mov    0x8(%ebp),%edx
  1005ee:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  1005f0:	a1 f0 64 10 00       	mov    0x1064f0,%eax
  1005f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1005f8:	89 50 10             	mov    %edx,0x10(%eax)
}
  1005fb:	90                   	nop
  1005fc:	5d                   	pop    %ebp
  1005fd:	c3                   	ret    

001005fe <ioapicinit>:

void
ioapicinit(void)
{
  1005fe:	55                   	push   %ebp
  1005ff:	89 e5                	mov    %esp,%ebp
  100601:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  100604:	c7 05 f0 64 10 00 00 	movl   $0xfec00000,0x1064f0
  10060b:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  10060e:	6a 01                	push   $0x1
  100610:	e8 b7 ff ff ff       	call   1005cc <ioapicread>
  100615:	83 c4 04             	add    $0x4,%esp
  100618:	c1 e8 10             	shr    $0x10,%eax
  10061b:	25 ff 00 00 00       	and    $0xff,%eax
  100620:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
  100623:	6a 00                	push   $0x0
  100625:	e8 a2 ff ff ff       	call   1005cc <ioapicread>
  10062a:	83 c4 04             	add    $0x4,%esp
  10062d:	c1 e8 18             	shr    $0x18,%eax
  100630:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
  100633:	0f b6 05 64 6a 10 00 	movzbl 0x106a64,%eax
  10063a:	0f b6 c0             	movzbl %al,%eax
  10063d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  100640:	74 10                	je     100652 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  100642:	83 ec 0c             	sub    $0xc,%esp
  100645:	68 5c 56 10 00       	push   $0x10565c
  10064a:	e8 9d fa ff ff       	call   1000ec <cprintf>
  10064f:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  100652:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100659:	eb 3f                	jmp    10069a <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  10065b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10065e:	83 c0 20             	add    $0x20,%eax
  100661:	0d 00 00 01 00       	or     $0x10000,%eax
  100666:	89 c2                	mov    %eax,%edx
  100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066b:	83 c0 08             	add    $0x8,%eax
  10066e:	01 c0                	add    %eax,%eax
  100670:	83 ec 08             	sub    $0x8,%esp
  100673:	52                   	push   %edx
  100674:	50                   	push   %eax
  100675:	e8 69 ff ff ff       	call   1005e3 <ioapicwrite>
  10067a:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
  10067d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100680:	83 c0 08             	add    $0x8,%eax
  100683:	01 c0                	add    %eax,%eax
  100685:	83 c0 01             	add    $0x1,%eax
  100688:	83 ec 08             	sub    $0x8,%esp
  10068b:	6a 00                	push   $0x0
  10068d:	50                   	push   %eax
  10068e:	e8 50 ff ff ff       	call   1005e3 <ioapicwrite>
  100693:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
  100696:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10069a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1006a0:	7e b9                	jle    10065b <ioapicinit+0x5d>
  }
}
  1006a2:	90                   	nop
  1006a3:	90                   	nop
  1006a4:	c9                   	leave  
  1006a5:	c3                   	ret    

001006a6 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  1006a6:	55                   	push   %ebp
  1006a7:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  1006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ac:	83 c0 20             	add    $0x20,%eax
  1006af:	89 c2                	mov    %eax,%edx
  1006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b4:	83 c0 08             	add    $0x8,%eax
  1006b7:	01 c0                	add    %eax,%eax
  1006b9:	52                   	push   %edx
  1006ba:	50                   	push   %eax
  1006bb:	e8 23 ff ff ff       	call   1005e3 <ioapicwrite>
  1006c0:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  1006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c6:	c1 e0 18             	shl    $0x18,%eax
  1006c9:	89 c2                	mov    %eax,%edx
  1006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ce:	83 c0 08             	add    $0x8,%eax
  1006d1:	01 c0                	add    %eax,%eax
  1006d3:	83 c0 01             	add    $0x1,%eax
  1006d6:	52                   	push   %edx
  1006d7:	50                   	push   %eax
  1006d8:	e8 06 ff ff ff       	call   1005e3 <ioapicwrite>
  1006dd:	83 c4 08             	add    $0x8,%esp
}
  1006e0:	90                   	nop
  1006e1:	c9                   	leave  
  1006e2:	c3                   	ret    

001006e3 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1006e3:	55                   	push   %ebp
  1006e4:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  1006e6:	8b 15 f4 64 10 00    	mov    0x1064f4,%edx
  1006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ef:	c1 e0 02             	shl    $0x2,%eax
  1006f2:	01 c2                	add    %eax,%edx
  1006f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f7:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
  1006f9:	a1 f4 64 10 00       	mov    0x1064f4,%eax
  1006fe:	83 c0 20             	add    $0x20,%eax
  100701:	8b 00                	mov    (%eax),%eax
}
  100703:	90                   	nop
  100704:	5d                   	pop    %ebp
  100705:	c3                   	ret    

00100706 <lapicinit>:

void
lapicinit(void)
{
  100706:	55                   	push   %ebp
  100707:	89 e5                	mov    %esp,%ebp
  if(!lapic)
  100709:	a1 f4 64 10 00       	mov    0x1064f4,%eax
  10070e:	85 c0                	test   %eax,%eax
  100710:	0f 84 0c 01 00 00    	je     100822 <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
  100716:	68 3f 01 00 00       	push   $0x13f
  10071b:	6a 3c                	push   $0x3c
  10071d:	e8 c1 ff ff ff       	call   1006e3 <lapicw>
  100722:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  100725:	6a 0b                	push   $0xb
  100727:	68 f8 00 00 00       	push   $0xf8
  10072c:	e8 b2 ff ff ff       	call   1006e3 <lapicw>
  100731:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
  100734:	68 20 00 02 00       	push   $0x20020
  100739:	68 c8 00 00 00       	push   $0xc8
  10073e:	e8 a0 ff ff ff       	call   1006e3 <lapicw>
  100743:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
  100746:	68 80 96 98 00       	push   $0x989680
  10074b:	68 e0 00 00 00       	push   $0xe0
  100750:	e8 8e ff ff ff       	call   1006e3 <lapicw>
  100755:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  100758:	68 00 00 01 00       	push   $0x10000
  10075d:	68 d4 00 00 00       	push   $0xd4
  100762:	e8 7c ff ff ff       	call   1006e3 <lapicw>
  100767:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
  10076a:	68 00 00 01 00       	push   $0x10000
  10076f:	68 d8 00 00 00       	push   $0xd8
  100774:	e8 6a ff ff ff       	call   1006e3 <lapicw>
  100779:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10077c:	a1 f4 64 10 00       	mov    0x1064f4,%eax
  100781:	83 c0 30             	add    $0x30,%eax
  100784:	8b 00                	mov    (%eax),%eax
  100786:	c1 e8 10             	shr    $0x10,%eax
  100789:	25 fc 00 00 00       	and    $0xfc,%eax
  10078e:	85 c0                	test   %eax,%eax
  100790:	74 12                	je     1007a4 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
  100792:	68 00 00 01 00       	push   $0x10000
  100797:	68 d0 00 00 00       	push   $0xd0
  10079c:	e8 42 ff ff ff       	call   1006e3 <lapicw>
  1007a1:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
  1007a4:	6a 33                	push   $0x33
  1007a6:	68 dc 00 00 00       	push   $0xdc
  1007ab:	e8 33 ff ff ff       	call   1006e3 <lapicw>
  1007b0:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  1007b3:	6a 00                	push   $0x0
  1007b5:	68 a0 00 00 00       	push   $0xa0
  1007ba:	e8 24 ff ff ff       	call   1006e3 <lapicw>
  1007bf:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
  1007c2:	6a 00                	push   $0x0
  1007c4:	68 a0 00 00 00       	push   $0xa0
  1007c9:	e8 15 ff ff ff       	call   1006e3 <lapicw>
  1007ce:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  1007d1:	6a 00                	push   $0x0
  1007d3:	6a 2c                	push   $0x2c
  1007d5:	e8 09 ff ff ff       	call   1006e3 <lapicw>
  1007da:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  1007dd:	6a 00                	push   $0x0
  1007df:	68 c4 00 00 00       	push   $0xc4
  1007e4:	e8 fa fe ff ff       	call   1006e3 <lapicw>
  1007e9:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  1007ec:	68 00 85 08 00       	push   $0x88500
  1007f1:	68 c0 00 00 00       	push   $0xc0
  1007f6:	e8 e8 fe ff ff       	call   1006e3 <lapicw>
  1007fb:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
  1007fe:	90                   	nop
  1007ff:	a1 f4 64 10 00       	mov    0x1064f4,%eax
  100804:	05 00 03 00 00       	add    $0x300,%eax
  100809:	8b 00                	mov    (%eax),%eax
  10080b:	25 00 10 00 00       	and    $0x1000,%eax
  100810:	85 c0                	test   %eax,%eax
  100812:	75 eb                	jne    1007ff <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  100814:	6a 00                	push   $0x0
  100816:	6a 20                	push   $0x20
  100818:	e8 c6 fe ff ff       	call   1006e3 <lapicw>
  10081d:	83 c4 08             	add    $0x8,%esp
  100820:	eb 01                	jmp    100823 <lapicinit+0x11d>
    return;
  100822:	90                   	nop
}
  100823:	c9                   	leave  
  100824:	c3                   	ret    

00100825 <lapicid>:

int
lapicid(void)
{
  100825:	55                   	push   %ebp
  100826:	89 e5                	mov    %esp,%ebp
  if (!lapic)
  100828:	a1 f4 64 10 00       	mov    0x1064f4,%eax
  10082d:	85 c0                	test   %eax,%eax
  10082f:	75 07                	jne    100838 <lapicid+0x13>
    return 0;
  100831:	b8 00 00 00 00       	mov    $0x0,%eax
  100836:	eb 0d                	jmp    100845 <lapicid+0x20>
  return lapic[ID] >> 24;
  100838:	a1 f4 64 10 00       	mov    0x1064f4,%eax
  10083d:	83 c0 20             	add    $0x20,%eax
  100840:	8b 00                	mov    (%eax),%eax
  100842:	c1 e8 18             	shr    $0x18,%eax
}
  100845:	5d                   	pop    %ebp
  100846:	c3                   	ret    

00100847 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  100847:	55                   	push   %ebp
  100848:	89 e5                	mov    %esp,%ebp
  if(lapic)
  10084a:	a1 f4 64 10 00       	mov    0x1064f4,%eax
  10084f:	85 c0                	test   %eax,%eax
  100851:	74 0c                	je     10085f <lapiceoi+0x18>
    lapicw(EOI, 0);
  100853:	6a 00                	push   $0x0
  100855:	6a 2c                	push   $0x2c
  100857:	e8 87 fe ff ff       	call   1006e3 <lapicw>
  10085c:	83 c4 08             	add    $0x8,%esp
}
  10085f:	90                   	nop
  100860:	c9                   	leave  
  100861:	c3                   	ret    

00100862 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  100862:	55                   	push   %ebp
  100863:	89 e5                	mov    %esp,%ebp
  100865:	90                   	nop
  100866:	5d                   	pop    %ebp
  100867:	c3                   	ret    

00100868 <sti>:


static inline void
sti(void)
{
  100868:	55                   	push   %ebp
  100869:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
  10086b:	fb                   	sti    
}
  10086c:	90                   	nop
  10086d:	5d                   	pop    %ebp
  10086e:	c3                   	ret    

0010086f <main>:
extern char end[]; // first address after kernel loaded from ELF file

// Bootstrap processor starts running C code here.
int
main(void)
{
  10086f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  100873:	83 e4 f0             	and    $0xfffffff0,%esp
  100876:	ff 71 fc             	push   -0x4(%ecx)
  100879:	55                   	push   %ebp
  10087a:	89 e5                	mov    %esp,%ebp
  10087c:	51                   	push   %ecx
  10087d:	83 ec 54             	sub    $0x54,%esp
  kinit(end, P2V(PHYSTOP)); // phys page allocator
  100880:	83 ec 08             	sub    $0x8,%esp
  100883:	68 00 00 00 0e       	push   $0xe000000
  100888:	68 d0 fa 10 00       	push   $0x10fad0
  10088d:	e8 21 43 00 00       	call   104bb3 <kinit>
  100892:	83 c4 10             	add    $0x10,%esp
  mpinit();        // detect other processors
  100895:	e8 b7 02 00 00       	call   100b51 <mpinit>
  lapicinit();     // interrupt controller
  10089a:	e8 67 fe ff ff       	call   100706 <lapicinit>
  picinit();       // disable pic
  10089f:	e8 14 04 00 00       	call   100cb8 <picinit>
  ioapicinit();    // another interrupt controller
  1008a4:	e8 55 fd ff ff       	call   1005fe <ioapicinit>
  consoleinit();   // console hardware
  1008a9:	e8 04 fd ff ff       	call   1005b2 <consoleinit>
  uartinit();      // serial port
  1008ae:	e8 6a 04 00 00       	call   100d1d <uartinit>
  ideinit();       // disk 
  1008b3:	e8 d6 1e 00 00       	call   10278e <ideinit>
  tvinit();        // trap vectors
  1008b8:	e8 19 0f 00 00       	call   1017d6 <tvinit>
  binit();         // buffer cache
  1008bd:	e8 19 1c 00 00       	call   1024db <binit>
  idtinit();       // load idt register
  1008c2:	e8 70 10 00 00       	call   101937 <idtinit>
  sti();           // enable interrupts
  1008c7:	e8 9c ff ff ff       	call   100868 <sti>
  iinit(ROOTDEV);  // Read superblock to start reading inodes
  1008cc:	83 ec 0c             	sub    $0xc,%esp
  1008cf:	6a 01                	push   $0x1
  1008d1:	e8 9b 24 00 00       	call   102d71 <iinit>
  1008d6:	83 c4 10             	add    $0x10,%esp
  initlog(ROOTDEV);  // Initialize log
  1008d9:	83 ec 0c             	sub    $0xc,%esp
  1008dc:	6a 01                	push   $0x1
  1008de:	e8 06 3a 00 00       	call   1042e9 <initlog>
  1008e3:	83 c4 10             	add    $0x10,%esp

  struct inode console;
  mknod(&console, "console", CONSOLE, CONSOLE);
  1008e6:	6a 01                	push   $0x1
  1008e8:	6a 01                	push   $0x1
  1008ea:	68 8e 56 10 00       	push   $0x10568e
  1008ef:	8d 45 a8             	lea    -0x58(%ebp),%eax
  1008f2:	50                   	push   %eax
  1008f3:	e8 53 39 00 00       	call   10424b <mknod>
  1008f8:	83 c4 10             	add    $0x10,%esp
  seginit();       // segment descriptors
  1008fb:	e8 e6 3d 00 00       	call   1046e6 <seginit>
  pinit(0);        // first process
  100900:	83 ec 0c             	sub    $0xc,%esp
  100903:	6a 00                	push   $0x0
  100905:	e8 8b 09 00 00       	call   101295 <pinit>
  10090a:	83 c4 10             	add    $0x10,%esp
  pinit(1);        // second process 
  10090d:	83 ec 0c             	sub    $0xc,%esp
  100910:	6a 01                	push   $0x1
  100912:	e8 7e 09 00 00       	call   101295 <pinit>
  100917:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
  10091a:	e8 6b 0a 00 00       	call   10138a <scheduler>

0010091f <inb>:
{
  10091f:	55                   	push   %ebp
  100920:	89 e5                	mov    %esp,%ebp
  100922:	83 ec 14             	sub    $0x14,%esp
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10092c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100930:	89 c2                	mov    %eax,%edx
  100932:	ec                   	in     (%dx),%al
  100933:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  100936:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  10093a:	c9                   	leave  
  10093b:	c3                   	ret    

0010093c <outb>:
{
  10093c:	55                   	push   %ebp
  10093d:	89 e5                	mov    %esp,%ebp
  10093f:	83 ec 08             	sub    $0x8,%esp
  100942:	8b 45 08             	mov    0x8(%ebp),%eax
  100945:	8b 55 0c             	mov    0xc(%ebp),%edx
  100948:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  10094c:	89 d0                	mov    %edx,%eax
  10094e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100951:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100955:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100959:	ee                   	out    %al,(%dx)
}
  10095a:	90                   	nop
  10095b:	c9                   	leave  
  10095c:	c3                   	ret    

0010095d <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
  10095d:	55                   	push   %ebp
  10095e:	89 e5                	mov    %esp,%ebp
  100960:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
  100963:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
  10096a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100971:	eb 15                	jmp    100988 <sum+0x2b>
    sum += addr[i];
  100973:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100976:	8b 45 08             	mov    0x8(%ebp),%eax
  100979:	01 d0                	add    %edx,%eax
  10097b:	0f b6 00             	movzbl (%eax),%eax
  10097e:	0f b6 c0             	movzbl %al,%eax
  100981:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
  100984:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10098b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10098e:	7c e3                	jl     100973 <sum+0x16>
  return sum;
  100990:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  100993:	c9                   	leave  
  100994:	c3                   	ret    

00100995 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
  100995:	55                   	push   %ebp
  100996:	89 e5                	mov    %esp,%ebp
  100998:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  // addr = P2V(a);
  addr = (uchar*) a;
  10099b:	8b 45 08             	mov    0x8(%ebp),%eax
  10099e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
  1009a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1009a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009a7:	01 d0                	add    %edx,%eax
  1009a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
  1009ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009b2:	eb 36                	jmp    1009ea <mpsearch1+0x55>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1009b4:	83 ec 04             	sub    $0x4,%esp
  1009b7:	6a 04                	push   $0x4
  1009b9:	68 98 56 10 00       	push   $0x105698
  1009be:	ff 75 f4             	push   -0xc(%ebp)
  1009c1:	e8 9f 05 00 00       	call   100f65 <memcmp>
  1009c6:	83 c4 10             	add    $0x10,%esp
  1009c9:	85 c0                	test   %eax,%eax
  1009cb:	75 19                	jne    1009e6 <mpsearch1+0x51>
  1009cd:	83 ec 08             	sub    $0x8,%esp
  1009d0:	6a 10                	push   $0x10
  1009d2:	ff 75 f4             	push   -0xc(%ebp)
  1009d5:	e8 83 ff ff ff       	call   10095d <sum>
  1009da:	83 c4 10             	add    $0x10,%esp
  1009dd:	84 c0                	test   %al,%al
  1009df:	75 05                	jne    1009e6 <mpsearch1+0x51>
      return (struct mp*)p;
  1009e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e4:	eb 11                	jmp    1009f7 <mpsearch1+0x62>
  for(p = addr; p < e; p += sizeof(struct mp))
  1009e6:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
  1009ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1009f0:	72 c2                	jb     1009b4 <mpsearch1+0x1f>
  return 0;
  1009f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1009f7:	c9                   	leave  
  1009f8:	c3                   	ret    

001009f9 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
  1009f9:	55                   	push   %ebp
  1009fa:	89 e5                	mov    %esp,%ebp
  1009fc:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  // bda = (uchar *) P2V(0x400);
  bda = (uchar *) 0x400;
  1009ff:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
  100a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a09:	83 c0 0f             	add    $0xf,%eax
  100a0c:	0f b6 00             	movzbl (%eax),%eax
  100a0f:	0f b6 c0             	movzbl %al,%eax
  100a12:	c1 e0 08             	shl    $0x8,%eax
  100a15:	89 c2                	mov    %eax,%edx
  100a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a1a:	83 c0 0e             	add    $0xe,%eax
  100a1d:	0f b6 00             	movzbl (%eax),%eax
  100a20:	0f b6 c0             	movzbl %al,%eax
  100a23:	09 d0                	or     %edx,%eax
  100a25:	c1 e0 04             	shl    $0x4,%eax
  100a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100a2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a2f:	74 21                	je     100a52 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
  100a31:	83 ec 08             	sub    $0x8,%esp
  100a34:	68 00 04 00 00       	push   $0x400
  100a39:	ff 75 f0             	push   -0x10(%ebp)
  100a3c:	e8 54 ff ff ff       	call   100995 <mpsearch1>
  100a41:	83 c4 10             	add    $0x10,%esp
  100a44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100a47:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100a4b:	74 51                	je     100a9e <mpsearch+0xa5>
      return mp;
  100a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a50:	eb 61                	jmp    100ab3 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
  100a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a55:	83 c0 14             	add    $0x14,%eax
  100a58:	0f b6 00             	movzbl (%eax),%eax
  100a5b:	0f b6 c0             	movzbl %al,%eax
  100a5e:	c1 e0 08             	shl    $0x8,%eax
  100a61:	89 c2                	mov    %eax,%edx
  100a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a66:	83 c0 13             	add    $0x13,%eax
  100a69:	0f b6 00             	movzbl (%eax),%eax
  100a6c:	0f b6 c0             	movzbl %al,%eax
  100a6f:	09 d0                	or     %edx,%eax
  100a71:	c1 e0 0a             	shl    $0xa,%eax
  100a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
  100a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a7a:	2d 00 04 00 00       	sub    $0x400,%eax
  100a7f:	83 ec 08             	sub    $0x8,%esp
  100a82:	68 00 04 00 00       	push   $0x400
  100a87:	50                   	push   %eax
  100a88:	e8 08 ff ff ff       	call   100995 <mpsearch1>
  100a8d:	83 c4 10             	add    $0x10,%esp
  100a90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100a93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100a97:	74 05                	je     100a9e <mpsearch+0xa5>
      return mp;
  100a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a9c:	eb 15                	jmp    100ab3 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
  100a9e:	83 ec 08             	sub    $0x8,%esp
  100aa1:	68 00 00 01 00       	push   $0x10000
  100aa6:	68 00 00 0f 00       	push   $0xf0000
  100aab:	e8 e5 fe ff ff       	call   100995 <mpsearch1>
  100ab0:	83 c4 10             	add    $0x10,%esp
}
  100ab3:	c9                   	leave  
  100ab4:	c3                   	ret    

00100ab5 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
  100ab5:	55                   	push   %ebp
  100ab6:	89 e5                	mov    %esp,%ebp
  100ab8:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  100abb:	e8 39 ff ff ff       	call   1009f9 <mpsearch>
  100ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ac7:	74 0a                	je     100ad3 <mpconfig+0x1e>
  100ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acc:	8b 40 04             	mov    0x4(%eax),%eax
  100acf:	85 c0                	test   %eax,%eax
  100ad1:	75 07                	jne    100ada <mpconfig+0x25>
    return 0;
  100ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  100ad8:	eb 75                	jmp    100b4f <mpconfig+0x9a>
  // conf = (struct mpconf*) P2V((uint) mp->physaddr);
  conf = (struct mpconf*) (uint) mp->physaddr;
  100ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100add:	8b 40 04             	mov    0x4(%eax),%eax
  100ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
  100ae3:	83 ec 04             	sub    $0x4,%esp
  100ae6:	6a 04                	push   $0x4
  100ae8:	68 9d 56 10 00       	push   $0x10569d
  100aed:	ff 75 f0             	push   -0x10(%ebp)
  100af0:	e8 70 04 00 00       	call   100f65 <memcmp>
  100af5:	83 c4 10             	add    $0x10,%esp
  100af8:	85 c0                	test   %eax,%eax
  100afa:	74 07                	je     100b03 <mpconfig+0x4e>
    return 0;
  100afc:	b8 00 00 00 00       	mov    $0x0,%eax
  100b01:	eb 4c                	jmp    100b4f <mpconfig+0x9a>
  if(conf->version != 1 && conf->version != 4)
  100b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b06:	0f b6 40 06          	movzbl 0x6(%eax),%eax
  100b0a:	3c 01                	cmp    $0x1,%al
  100b0c:	74 12                	je     100b20 <mpconfig+0x6b>
  100b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b11:	0f b6 40 06          	movzbl 0x6(%eax),%eax
  100b15:	3c 04                	cmp    $0x4,%al
  100b17:	74 07                	je     100b20 <mpconfig+0x6b>
    return 0;
  100b19:	b8 00 00 00 00       	mov    $0x0,%eax
  100b1e:	eb 2f                	jmp    100b4f <mpconfig+0x9a>
  if(sum((uchar*)conf, conf->length) != 0)
  100b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b23:	0f b7 40 04          	movzwl 0x4(%eax),%eax
  100b27:	0f b7 c0             	movzwl %ax,%eax
  100b2a:	83 ec 08             	sub    $0x8,%esp
  100b2d:	50                   	push   %eax
  100b2e:	ff 75 f0             	push   -0x10(%ebp)
  100b31:	e8 27 fe ff ff       	call   10095d <sum>
  100b36:	83 c4 10             	add    $0x10,%esp
  100b39:	84 c0                	test   %al,%al
  100b3b:	74 07                	je     100b44 <mpconfig+0x8f>
    return 0;
  100b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  100b42:	eb 0b                	jmp    100b4f <mpconfig+0x9a>
  *pmp = mp;
  100b44:	8b 45 08             	mov    0x8(%ebp),%eax
  100b47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b4a:	89 10                	mov    %edx,(%eax)
  return conf;
  100b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100b4f:	c9                   	leave  
  100b50:	c3                   	ret    

00100b51 <mpinit>:

void
mpinit(void)
{
  100b51:	55                   	push   %ebp
  100b52:	89 e5                	mov    %esp,%ebp
  100b54:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
  100b57:	83 ec 0c             	sub    $0xc,%esp
  100b5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100b5d:	50                   	push   %eax
  100b5e:	e8 52 ff ff ff       	call   100ab5 <mpconfig>
  100b63:	83 c4 10             	add    $0x10,%esp
  100b66:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100b69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100b6d:	75 0d                	jne    100b7c <mpinit+0x2b>
    panic("Expect to run on an SMP");
  100b6f:	83 ec 0c             	sub    $0xc,%esp
  100b72:	68 a2 56 10 00       	push   $0x1056a2
  100b77:	e8 31 f7 ff ff       	call   1002ad <panic>
  ismp = 1;
  100b7c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
  100b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100b86:	8b 40 24             	mov    0x24(%eax),%eax
  100b89:	a3 f4 64 10 00       	mov    %eax,0x1064f4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100b91:	83 c0 2c             	add    $0x2c,%eax
  100b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100b9a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
  100b9e:	0f b7 d0             	movzwl %ax,%edx
  100ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100ba4:	01 d0                	add    %edx,%eax
  100ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  100ba9:	e9 8c 00 00 00       	jmp    100c3a <mpinit+0xe9>
    switch(*p){
  100bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb1:	0f b6 00             	movzbl (%eax),%eax
  100bb4:	0f b6 c0             	movzbl %al,%eax
  100bb7:	83 f8 04             	cmp    $0x4,%eax
  100bba:	7f 76                	jg     100c32 <mpinit+0xe1>
  100bbc:	83 f8 03             	cmp    $0x3,%eax
  100bbf:	7d 6b                	jge    100c2c <mpinit+0xdb>
  100bc1:	83 f8 02             	cmp    $0x2,%eax
  100bc4:	74 4e                	je     100c14 <mpinit+0xc3>
  100bc6:	83 f8 02             	cmp    $0x2,%eax
  100bc9:	7f 67                	jg     100c32 <mpinit+0xe1>
  100bcb:	85 c0                	test   %eax,%eax
  100bcd:	74 07                	je     100bd6 <mpinit+0x85>
  100bcf:	83 f8 01             	cmp    $0x1,%eax
  100bd2:	74 58                	je     100c2c <mpinit+0xdb>
  100bd4:	eb 5c                	jmp    100c32 <mpinit+0xe1>
    case MPPROC:
      proc = (struct mpproc*)p;
  100bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
  100bdc:	a1 60 6a 10 00       	mov    0x106a60,%eax
  100be1:	83 f8 07             	cmp    $0x7,%eax
  100be4:	7f 28                	jg     100c0e <mpinit+0xbd>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  100be6:	8b 15 60 6a 10 00    	mov    0x106a60,%edx
  100bec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100bef:	0f b6 40 01          	movzbl 0x1(%eax),%eax
  100bf3:	69 d2 ac 00 00 00    	imul   $0xac,%edx,%edx
  100bf9:	81 c2 00 65 10 00    	add    $0x106500,%edx
  100bff:	88 02                	mov    %al,(%edx)
        ncpu++;
  100c01:	a1 60 6a 10 00       	mov    0x106a60,%eax
  100c06:	83 c0 01             	add    $0x1,%eax
  100c09:	a3 60 6a 10 00       	mov    %eax,0x106a60
      }
      p += sizeof(struct mpproc);
  100c0e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
  100c12:	eb 26                	jmp    100c3a <mpinit+0xe9>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
  100c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
  100c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100c1d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
  100c21:	a2 64 6a 10 00       	mov    %al,0x106a64
      p += sizeof(struct mpioapic);
  100c26:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
  100c2a:	eb 0e                	jmp    100c3a <mpinit+0xe9>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  100c2c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
  100c30:	eb 08                	jmp    100c3a <mpinit+0xe9>
    default:
      ismp = 0;
  100c32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
  100c39:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  100c40:	0f 82 68 ff ff ff    	jb     100bae <mpinit+0x5d>
    }
  }
  if(!ismp)
  100c46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c4a:	75 0d                	jne    100c59 <mpinit+0x108>
    panic("Didn't find a suitable machine");
  100c4c:	83 ec 0c             	sub    $0xc,%esp
  100c4f:	68 bc 56 10 00       	push   $0x1056bc
  100c54:	e8 54 f6 ff ff       	call   1002ad <panic>

  if(mp->imcrp){
  100c59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100c5c:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
  100c60:	84 c0                	test   %al,%al
  100c62:	74 30                	je     100c94 <mpinit+0x143>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
  100c64:	83 ec 08             	sub    $0x8,%esp
  100c67:	6a 70                	push   $0x70
  100c69:	6a 22                	push   $0x22
  100c6b:	e8 cc fc ff ff       	call   10093c <outb>
  100c70:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  100c73:	83 ec 0c             	sub    $0xc,%esp
  100c76:	6a 23                	push   $0x23
  100c78:	e8 a2 fc ff ff       	call   10091f <inb>
  100c7d:	83 c4 10             	add    $0x10,%esp
  100c80:	83 c8 01             	or     $0x1,%eax
  100c83:	0f b6 c0             	movzbl %al,%eax
  100c86:	83 ec 08             	sub    $0x8,%esp
  100c89:	50                   	push   %eax
  100c8a:	6a 23                	push   $0x23
  100c8c:	e8 ab fc ff ff       	call   10093c <outb>
  100c91:	83 c4 10             	add    $0x10,%esp
  }
}
  100c94:	90                   	nop
  100c95:	c9                   	leave  
  100c96:	c3                   	ret    

00100c97 <outb>:
{
  100c97:	55                   	push   %ebp
  100c98:	89 e5                	mov    %esp,%ebp
  100c9a:	83 ec 08             	sub    $0x8,%esp
  100c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  100ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
  100ca3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  100ca7:	89 d0                	mov    %edx,%eax
  100ca9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100cac:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100cb0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100cb4:	ee                   	out    %al,(%dx)
}
  100cb5:	90                   	nop
  100cb6:	c9                   	leave  
  100cb7:	c3                   	ret    

00100cb8 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
  100cb8:	55                   	push   %ebp
  100cb9:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  100cbb:	68 ff 00 00 00       	push   $0xff
  100cc0:	6a 21                	push   $0x21
  100cc2:	e8 d0 ff ff ff       	call   100c97 <outb>
  100cc7:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
  100cca:	68 ff 00 00 00       	push   $0xff
  100ccf:	68 a1 00 00 00       	push   $0xa1
  100cd4:	e8 be ff ff ff       	call   100c97 <outb>
  100cd9:	83 c4 08             	add    $0x8,%esp
  100cdc:	90                   	nop
  100cdd:	c9                   	leave  
  100cde:	c3                   	ret    

00100cdf <inb>:
{
  100cdf:	55                   	push   %ebp
  100ce0:	89 e5                	mov    %esp,%ebp
  100ce2:	83 ec 14             	sub    $0x14,%esp
  100ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100cec:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100cf0:	89 c2                	mov    %eax,%edx
  100cf2:	ec                   	in     (%dx),%al
  100cf3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  100cf6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  100cfa:	c9                   	leave  
  100cfb:	c3                   	ret    

00100cfc <outb>:
{
  100cfc:	55                   	push   %ebp
  100cfd:	89 e5                	mov    %esp,%ebp
  100cff:	83 ec 08             	sub    $0x8,%esp
  100d02:	8b 45 08             	mov    0x8(%ebp),%eax
  100d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  100d08:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  100d0c:	89 d0                	mov    %edx,%eax
  100d0e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100d11:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100d15:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100d19:	ee                   	out    %al,(%dx)
}
  100d1a:	90                   	nop
  100d1b:	c9                   	leave  
  100d1c:	c3                   	ret    

00100d1d <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
  100d1d:	55                   	push   %ebp
  100d1e:	89 e5                	mov    %esp,%ebp
  100d20:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
  100d23:	6a 00                	push   $0x0
  100d25:	68 fa 03 00 00       	push   $0x3fa
  100d2a:	e8 cd ff ff ff       	call   100cfc <outb>
  100d2f:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
  100d32:	68 80 00 00 00       	push   $0x80
  100d37:	68 fb 03 00 00       	push   $0x3fb
  100d3c:	e8 bb ff ff ff       	call   100cfc <outb>
  100d41:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
  100d44:	6a 0c                	push   $0xc
  100d46:	68 f8 03 00 00       	push   $0x3f8
  100d4b:	e8 ac ff ff ff       	call   100cfc <outb>
  100d50:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
  100d53:	6a 00                	push   $0x0
  100d55:	68 f9 03 00 00       	push   $0x3f9
  100d5a:	e8 9d ff ff ff       	call   100cfc <outb>
  100d5f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  100d62:	6a 03                	push   $0x3
  100d64:	68 fb 03 00 00       	push   $0x3fb
  100d69:	e8 8e ff ff ff       	call   100cfc <outb>
  100d6e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
  100d71:	6a 00                	push   $0x0
  100d73:	68 fc 03 00 00       	push   $0x3fc
  100d78:	e8 7f ff ff ff       	call   100cfc <outb>
  100d7d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
  100d80:	6a 01                	push   $0x1
  100d82:	68 f9 03 00 00       	push   $0x3f9
  100d87:	e8 70 ff ff ff       	call   100cfc <outb>
  100d8c:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
  100d8f:	68 fd 03 00 00       	push   $0x3fd
  100d94:	e8 46 ff ff ff       	call   100cdf <inb>
  100d99:	83 c4 04             	add    $0x4,%esp
  100d9c:	3c ff                	cmp    $0xff,%al
  100d9e:	74 61                	je     100e01 <uartinit+0xe4>
    return;
  uart = 1;
  100da0:	c7 05 68 6a 10 00 01 	movl   $0x1,0x106a68
  100da7:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  100daa:	68 fa 03 00 00       	push   $0x3fa
  100daf:	e8 2b ff ff ff       	call   100cdf <inb>
  100db4:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
  100db7:	68 f8 03 00 00       	push   $0x3f8
  100dbc:	e8 1e ff ff ff       	call   100cdf <inb>
  100dc1:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
  100dc4:	83 ec 08             	sub    $0x8,%esp
  100dc7:	6a 00                	push   $0x0
  100dc9:	6a 04                	push   $0x4
  100dcb:	e8 d6 f8 ff ff       	call   1006a6 <ioapicenable>
  100dd0:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  100dd3:	c7 45 f4 db 56 10 00 	movl   $0x1056db,-0xc(%ebp)
  100dda:	eb 19                	jmp    100df5 <uartinit+0xd8>
    uartputc(*p);
  100ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ddf:	0f b6 00             	movzbl (%eax),%eax
  100de2:	0f be c0             	movsbl %al,%eax
  100de5:	83 ec 0c             	sub    $0xc,%esp
  100de8:	50                   	push   %eax
  100de9:	e8 16 00 00 00       	call   100e04 <uartputc>
  100dee:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
  100df1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100df8:	0f b6 00             	movzbl (%eax),%eax
  100dfb:	84 c0                	test   %al,%al
  100dfd:	75 dd                	jne    100ddc <uartinit+0xbf>
  100dff:	eb 01                	jmp    100e02 <uartinit+0xe5>
    return;
  100e01:	90                   	nop
}
  100e02:	c9                   	leave  
  100e03:	c3                   	ret    

00100e04 <uartputc>:

void
uartputc(int c)
{
  100e04:	55                   	push   %ebp
  100e05:	89 e5                	mov    %esp,%ebp
  100e07:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
  100e0a:	a1 68 6a 10 00       	mov    0x106a68,%eax
  100e0f:	85 c0                	test   %eax,%eax
  100e11:	74 40                	je     100e53 <uartputc+0x4f>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++);
  100e13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100e1a:	eb 04                	jmp    100e20 <uartputc+0x1c>
  100e1c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100e20:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  100e24:	7f 17                	jg     100e3d <uartputc+0x39>
  100e26:	68 fd 03 00 00       	push   $0x3fd
  100e2b:	e8 af fe ff ff       	call   100cdf <inb>
  100e30:	83 c4 04             	add    $0x4,%esp
  100e33:	0f b6 c0             	movzbl %al,%eax
  100e36:	83 e0 20             	and    $0x20,%eax
  100e39:	85 c0                	test   %eax,%eax
  100e3b:	74 df                	je     100e1c <uartputc+0x18>
  outb(COM1+0, c);
  100e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  100e40:	0f b6 c0             	movzbl %al,%eax
  100e43:	50                   	push   %eax
  100e44:	68 f8 03 00 00       	push   $0x3f8
  100e49:	e8 ae fe ff ff       	call   100cfc <outb>
  100e4e:	83 c4 08             	add    $0x8,%esp
  100e51:	eb 01                	jmp    100e54 <uartputc+0x50>
    return;
  100e53:	90                   	nop
}
  100e54:	c9                   	leave  
  100e55:	c3                   	ret    

00100e56 <uartgetc>:


static int
uartgetc(void)
{
  100e56:	55                   	push   %ebp
  100e57:	89 e5                	mov    %esp,%ebp
  if(!uart)
  100e59:	a1 68 6a 10 00       	mov    0x106a68,%eax
  100e5e:	85 c0                	test   %eax,%eax
  100e60:	75 07                	jne    100e69 <uartgetc+0x13>
    return -1;
  100e62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100e67:	eb 2e                	jmp    100e97 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
  100e69:	68 fd 03 00 00       	push   $0x3fd
  100e6e:	e8 6c fe ff ff       	call   100cdf <inb>
  100e73:	83 c4 04             	add    $0x4,%esp
  100e76:	0f b6 c0             	movzbl %al,%eax
  100e79:	83 e0 01             	and    $0x1,%eax
  100e7c:	85 c0                	test   %eax,%eax
  100e7e:	75 07                	jne    100e87 <uartgetc+0x31>
    return -1;
  100e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100e85:	eb 10                	jmp    100e97 <uartgetc+0x41>
  return inb(COM1+0);
  100e87:	68 f8 03 00 00       	push   $0x3f8
  100e8c:	e8 4e fe ff ff       	call   100cdf <inb>
  100e91:	83 c4 04             	add    $0x4,%esp
  100e94:	0f b6 c0             	movzbl %al,%eax
}
  100e97:	c9                   	leave  
  100e98:	c3                   	ret    

00100e99 <uartintr>:

void
uartintr(void)
{
  100e99:	55                   	push   %ebp
  100e9a:	89 e5                	mov    %esp,%ebp
  100e9c:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
  100e9f:	83 ec 0c             	sub    $0xc,%esp
  100ea2:	68 56 0e 10 00       	push   $0x100e56
  100ea7:	e8 d7 f4 ff ff       	call   100383 <consoleintr>
  100eac:	83 c4 10             	add    $0x10,%esp
  100eaf:	90                   	nop
  100eb0:	c9                   	leave  
  100eb1:	c3                   	ret    

00100eb2 <stosb>:
{
  100eb2:	55                   	push   %ebp
  100eb3:	89 e5                	mov    %esp,%ebp
  100eb5:	57                   	push   %edi
  100eb6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  100eb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100eba:	8b 55 10             	mov    0x10(%ebp),%edx
  100ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ec0:	89 cb                	mov    %ecx,%ebx
  100ec2:	89 df                	mov    %ebx,%edi
  100ec4:	89 d1                	mov    %edx,%ecx
  100ec6:	fc                   	cld    
  100ec7:	f3 aa                	rep stos %al,%es:(%edi)
  100ec9:	89 ca                	mov    %ecx,%edx
  100ecb:	89 fb                	mov    %edi,%ebx
  100ecd:	89 5d 08             	mov    %ebx,0x8(%ebp)
  100ed0:	89 55 10             	mov    %edx,0x10(%ebp)
}
  100ed3:	90                   	nop
  100ed4:	5b                   	pop    %ebx
  100ed5:	5f                   	pop    %edi
  100ed6:	5d                   	pop    %ebp
  100ed7:	c3                   	ret    

00100ed8 <stosl>:
{
  100ed8:	55                   	push   %ebp
  100ed9:	89 e5                	mov    %esp,%ebp
  100edb:	57                   	push   %edi
  100edc:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
  100edd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100ee0:	8b 55 10             	mov    0x10(%ebp),%edx
  100ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ee6:	89 cb                	mov    %ecx,%ebx
  100ee8:	89 df                	mov    %ebx,%edi
  100eea:	89 d1                	mov    %edx,%ecx
  100eec:	fc                   	cld    
  100eed:	f3 ab                	rep stos %eax,%es:(%edi)
  100eef:	89 ca                	mov    %ecx,%edx
  100ef1:	89 fb                	mov    %edi,%ebx
  100ef3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  100ef6:	89 55 10             	mov    %edx,0x10(%ebp)
}
  100ef9:	90                   	nop
  100efa:	5b                   	pop    %ebx
  100efb:	5f                   	pop    %edi
  100efc:	5d                   	pop    %ebp
  100efd:	c3                   	ret    

00100efe <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  100efe:	55                   	push   %ebp
  100eff:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
  100f01:	8b 45 08             	mov    0x8(%ebp),%eax
  100f04:	83 e0 03             	and    $0x3,%eax
  100f07:	85 c0                	test   %eax,%eax
  100f09:	75 43                	jne    100f4e <memset+0x50>
  100f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  100f0e:	83 e0 03             	and    $0x3,%eax
  100f11:	85 c0                	test   %eax,%eax
  100f13:	75 39                	jne    100f4e <memset+0x50>
    c &= 0xFF;
  100f15:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  100f1c:	8b 45 10             	mov    0x10(%ebp),%eax
  100f1f:	c1 e8 02             	shr    $0x2,%eax
  100f22:	89 c2                	mov    %eax,%edx
  100f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f27:	c1 e0 18             	shl    $0x18,%eax
  100f2a:	89 c1                	mov    %eax,%ecx
  100f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f2f:	c1 e0 10             	shl    $0x10,%eax
  100f32:	09 c1                	or     %eax,%ecx
  100f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f37:	c1 e0 08             	shl    $0x8,%eax
  100f3a:	09 c8                	or     %ecx,%eax
  100f3c:	0b 45 0c             	or     0xc(%ebp),%eax
  100f3f:	52                   	push   %edx
  100f40:	50                   	push   %eax
  100f41:	ff 75 08             	push   0x8(%ebp)
  100f44:	e8 8f ff ff ff       	call   100ed8 <stosl>
  100f49:	83 c4 0c             	add    $0xc,%esp
  100f4c:	eb 12                	jmp    100f60 <memset+0x62>
  } else
    stosb(dst, c, n);
  100f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  100f51:	50                   	push   %eax
  100f52:	ff 75 0c             	push   0xc(%ebp)
  100f55:	ff 75 08             	push   0x8(%ebp)
  100f58:	e8 55 ff ff ff       	call   100eb2 <stosb>
  100f5d:	83 c4 0c             	add    $0xc,%esp
  return dst;
  100f60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100f63:	c9                   	leave  
  100f64:	c3                   	ret    

00100f65 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  100f65:	55                   	push   %ebp
  100f66:	89 e5                	mov    %esp,%ebp
  100f68:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
  100f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  100f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
  100f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f74:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
  100f77:	eb 30                	jmp    100fa9 <memcmp+0x44>
    if(*s1 != *s2)
  100f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f7c:	0f b6 10             	movzbl (%eax),%edx
  100f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f82:	0f b6 00             	movzbl (%eax),%eax
  100f85:	38 c2                	cmp    %al,%dl
  100f87:	74 18                	je     100fa1 <memcmp+0x3c>
      return *s1 - *s2;
  100f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f8c:	0f b6 00             	movzbl (%eax),%eax
  100f8f:	0f b6 d0             	movzbl %al,%edx
  100f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f95:	0f b6 00             	movzbl (%eax),%eax
  100f98:	0f b6 c8             	movzbl %al,%ecx
  100f9b:	89 d0                	mov    %edx,%eax
  100f9d:	29 c8                	sub    %ecx,%eax
  100f9f:	eb 1a                	jmp    100fbb <memcmp+0x56>
    s1++, s2++;
  100fa1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fa5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
  100fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  100fac:	8d 50 ff             	lea    -0x1(%eax),%edx
  100faf:	89 55 10             	mov    %edx,0x10(%ebp)
  100fb2:	85 c0                	test   %eax,%eax
  100fb4:	75 c3                	jne    100f79 <memcmp+0x14>
  }

  return 0;
  100fb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100fbb:	c9                   	leave  
  100fbc:	c3                   	ret    

00100fbd <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  100fbd:	55                   	push   %ebp
  100fbe:	89 e5                	mov    %esp,%ebp
  100fc0:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
  100fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
  100fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  100fcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
  100fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fd2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100fd5:	73 54                	jae    10102b <memmove+0x6e>
  100fd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100fda:	8b 45 10             	mov    0x10(%ebp),%eax
  100fdd:	01 d0                	add    %edx,%eax
  100fdf:	39 45 f8             	cmp    %eax,-0x8(%ebp)
  100fe2:	73 47                	jae    10102b <memmove+0x6e>
    s += n;
  100fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  100fe7:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
  100fea:	8b 45 10             	mov    0x10(%ebp),%eax
  100fed:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
  100ff0:	eb 13                	jmp    101005 <memmove+0x48>
      *--d = *--s;
  100ff2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100ff6:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  100ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ffd:	0f b6 10             	movzbl (%eax),%edx
  101000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101003:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
  101005:	8b 45 10             	mov    0x10(%ebp),%eax
  101008:	8d 50 ff             	lea    -0x1(%eax),%edx
  10100b:	89 55 10             	mov    %edx,0x10(%ebp)
  10100e:	85 c0                	test   %eax,%eax
  101010:	75 e0                	jne    100ff2 <memmove+0x35>
  if(s < d && s + n > d){
  101012:	eb 24                	jmp    101038 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
  101014:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101017:	8d 42 01             	lea    0x1(%edx),%eax
  10101a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10101d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101020:	8d 48 01             	lea    0x1(%eax),%ecx
  101023:	89 4d f8             	mov    %ecx,-0x8(%ebp)
  101026:	0f b6 12             	movzbl (%edx),%edx
  101029:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
  10102b:	8b 45 10             	mov    0x10(%ebp),%eax
  10102e:	8d 50 ff             	lea    -0x1(%eax),%edx
  101031:	89 55 10             	mov    %edx,0x10(%ebp)
  101034:	85 c0                	test   %eax,%eax
  101036:	75 dc                	jne    101014 <memmove+0x57>

  return dst;
  101038:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10103b:	c9                   	leave  
  10103c:	c3                   	ret    

0010103d <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  10103d:	55                   	push   %ebp
  10103e:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
  101040:	ff 75 10             	push   0x10(%ebp)
  101043:	ff 75 0c             	push   0xc(%ebp)
  101046:	ff 75 08             	push   0x8(%ebp)
  101049:	e8 6f ff ff ff       	call   100fbd <memmove>
  10104e:	83 c4 0c             	add    $0xc,%esp
}
  101051:	c9                   	leave  
  101052:	c3                   	ret    

00101053 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  101053:	55                   	push   %ebp
  101054:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
  101056:	eb 0c                	jmp    101064 <strncmp+0x11>
    n--, p++, q++;
  101058:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10105c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  101060:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
  101064:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  101068:	74 1a                	je     101084 <strncmp+0x31>
  10106a:	8b 45 08             	mov    0x8(%ebp),%eax
  10106d:	0f b6 00             	movzbl (%eax),%eax
  101070:	84 c0                	test   %al,%al
  101072:	74 10                	je     101084 <strncmp+0x31>
  101074:	8b 45 08             	mov    0x8(%ebp),%eax
  101077:	0f b6 10             	movzbl (%eax),%edx
  10107a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10107d:	0f b6 00             	movzbl (%eax),%eax
  101080:	38 c2                	cmp    %al,%dl
  101082:	74 d4                	je     101058 <strncmp+0x5>
  if(n == 0)
  101084:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  101088:	75 07                	jne    101091 <strncmp+0x3e>
    return 0;
  10108a:	b8 00 00 00 00       	mov    $0x0,%eax
  10108f:	eb 16                	jmp    1010a7 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
  101091:	8b 45 08             	mov    0x8(%ebp),%eax
  101094:	0f b6 00             	movzbl (%eax),%eax
  101097:	0f b6 d0             	movzbl %al,%edx
  10109a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10109d:	0f b6 00             	movzbl (%eax),%eax
  1010a0:	0f b6 c8             	movzbl %al,%ecx
  1010a3:	89 d0                	mov    %edx,%eax
  1010a5:	29 c8                	sub    %ecx,%eax
}
  1010a7:	5d                   	pop    %ebp
  1010a8:	c3                   	ret    

001010a9 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  1010a9:	55                   	push   %ebp
  1010aa:	89 e5                	mov    %esp,%ebp
  1010ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  1010af:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
  1010b5:	90                   	nop
  1010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1010b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1010bc:	89 55 10             	mov    %edx,0x10(%ebp)
  1010bf:	85 c0                	test   %eax,%eax
  1010c1:	7e 2c                	jle    1010ef <strncpy+0x46>
  1010c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1010c6:	8d 42 01             	lea    0x1(%edx),%eax
  1010c9:	89 45 0c             	mov    %eax,0xc(%ebp)
  1010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cf:	8d 48 01             	lea    0x1(%eax),%ecx
  1010d2:	89 4d 08             	mov    %ecx,0x8(%ebp)
  1010d5:	0f b6 12             	movzbl (%edx),%edx
  1010d8:	88 10                	mov    %dl,(%eax)
  1010da:	0f b6 00             	movzbl (%eax),%eax
  1010dd:	84 c0                	test   %al,%al
  1010df:	75 d5                	jne    1010b6 <strncpy+0xd>
    ;
  while(n-- > 0)
  1010e1:	eb 0c                	jmp    1010ef <strncpy+0x46>
    *s++ = 0;
  1010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e6:	8d 50 01             	lea    0x1(%eax),%edx
  1010e9:	89 55 08             	mov    %edx,0x8(%ebp)
  1010ec:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
  1010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1010f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1010f5:	89 55 10             	mov    %edx,0x10(%ebp)
  1010f8:	85 c0                	test   %eax,%eax
  1010fa:	7f e7                	jg     1010e3 <strncpy+0x3a>
  return os;
  1010fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1010ff:	c9                   	leave  
  101100:	c3                   	ret    

00101101 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  101101:	55                   	push   %ebp
  101102:	89 e5                	mov    %esp,%ebp
  101104:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  101107:	8b 45 08             	mov    0x8(%ebp),%eax
  10110a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
  10110d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  101111:	7f 05                	jg     101118 <safestrcpy+0x17>
    return os;
  101113:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101116:	eb 32                	jmp    10114a <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
  101118:	90                   	nop
  101119:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  101121:	7e 1e                	jle    101141 <safestrcpy+0x40>
  101123:	8b 55 0c             	mov    0xc(%ebp),%edx
  101126:	8d 42 01             	lea    0x1(%edx),%eax
  101129:	89 45 0c             	mov    %eax,0xc(%ebp)
  10112c:	8b 45 08             	mov    0x8(%ebp),%eax
  10112f:	8d 48 01             	lea    0x1(%eax),%ecx
  101132:	89 4d 08             	mov    %ecx,0x8(%ebp)
  101135:	0f b6 12             	movzbl (%edx),%edx
  101138:	88 10                	mov    %dl,(%eax)
  10113a:	0f b6 00             	movzbl (%eax),%eax
  10113d:	84 c0                	test   %al,%al
  10113f:	75 d8                	jne    101119 <safestrcpy+0x18>
    ;
  *s = 0;
  101141:	8b 45 08             	mov    0x8(%ebp),%eax
  101144:	c6 00 00             	movb   $0x0,(%eax)
  return os;
  101147:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10114a:	c9                   	leave  
  10114b:	c3                   	ret    

0010114c <strlen>:

int
strlen(const char *s)
{
  10114c:	55                   	push   %ebp
  10114d:	89 e5                	mov    %esp,%ebp
  10114f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  101152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101159:	eb 04                	jmp    10115f <strlen+0x13>
  10115b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10115f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101162:	8b 45 08             	mov    0x8(%ebp),%eax
  101165:	01 d0                	add    %edx,%eax
  101167:	0f b6 00             	movzbl (%eax),%eax
  10116a:	84 c0                	test   %al,%al
  10116c:	75 ed                	jne    10115b <strlen+0xf>
    ;
  return n;
  10116e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101171:	c9                   	leave  
  101172:	c3                   	ret    

00101173 <readeflags>:
{
  101173:	55                   	push   %ebp
  101174:	89 e5                	mov    %esp,%ebp
  101176:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  101179:	9c                   	pushf  
  10117a:	58                   	pop    %eax
  10117b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
  10117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101181:	c9                   	leave  
  101182:	c3                   	ret    

00101183 <sti>:
{
  101183:	55                   	push   %ebp
  101184:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
  101186:	fb                   	sti    
}
  101187:	90                   	nop
  101188:	5d                   	pop    %ebp
  101189:	c3                   	ret    

0010118a <cpuid>:

int nextpid = 1;
extern void trapret(void);

int
cpuid() {
  10118a:	55                   	push   %ebp
  10118b:	89 e5                	mov    %esp,%ebp
  return 0;
  10118d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101192:	5d                   	pop    %ebp
  101193:	c3                   	ret    

00101194 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  101194:	55                   	push   %ebp
  101195:	89 e5                	mov    %esp,%ebp
  return &cpus[0];
  101197:	b8 00 65 10 00       	mov    $0x106500,%eax
}
  10119c:	5d                   	pop    %ebp
  10119d:	c3                   	ret    

0010119e <myproc>:

// Read proc from the cpu structure
struct proc*
myproc(void) {
  10119e:	55                   	push   %ebp
  10119f:	89 e5                	mov    %esp,%ebp
  1011a1:	83 ec 10             	sub    $0x10,%esp
  struct cpu *c = mycpu();
  1011a4:	e8 eb ff ff ff       	call   101194 <mycpu>
  1011a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return c->proc;
  1011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1011af:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
}
  1011b5:	c9                   	leave  
  1011b6:	c3                   	ret    

001011b7 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  1011b7:	55                   	push   %ebp
  1011b8:	89 e5                	mov    %esp,%ebp
  1011ba:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1011bd:	c7 45 f4 80 6a 10 00 	movl   $0x106a80,-0xc(%ebp)
  1011c4:	eb 0e                	jmp    1011d4 <allocproc+0x1d>
    if(p->state == UNUSED)
  1011c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1011c9:	8b 40 0c             	mov    0xc(%eax),%eax
  1011cc:	85 c0                	test   %eax,%eax
  1011ce:	74 17                	je     1011e7 <allocproc+0x30>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1011d0:	83 45 f4 78          	addl   $0x78,-0xc(%ebp)
  1011d4:	81 7d f4 80 88 10 00 	cmpl   $0x108880,-0xc(%ebp)
  1011db:	72 e9                	jb     1011c6 <allocproc+0xf>
      goto found;

  return 0;
  1011dd:	b8 00 00 00 00       	mov    $0x0,%eax
  1011e2:	e9 ac 00 00 00       	jmp    101293 <allocproc+0xdc>
      goto found;
  1011e7:	90                   	nop

found:
  p->state = EMBRYO;
  1011e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1011eb:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
  1011f2:	a1 14 60 10 00       	mov    0x106014,%eax
  1011f7:	8d 50 01             	lea    0x1(%eax),%edx
  1011fa:	89 15 14 60 10 00    	mov    %edx,0x106014
  101200:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101203:	89 42 10             	mov    %eax,0x10(%edx)

  if((p->offset = kalloc()) == 0){
  101206:	e8 59 3a 00 00       	call   104c64 <kalloc>
  10120b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10120e:	89 42 04             	mov    %eax,0x4(%edx)
  101211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101214:	8b 40 04             	mov    0x4(%eax),%eax
  101217:	85 c0                	test   %eax,%eax
  101219:	75 11                	jne    10122c <allocproc+0x75>
    p->state = UNUSED;
  10121b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10121e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
  101225:	b8 00 00 00 00       	mov    $0x0,%eax
  10122a:	eb 67                	jmp    101293 <allocproc+0xdc>
  }
  p->sz = PGSIZE - KSTACKSIZE;
  10122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10122f:	c7 00 00 f0 0f 00    	movl   $0xff000,(%eax)

  sp = (char*)(p->offset + PGSIZE);
  101235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101238:	8b 40 04             	mov    0x4(%eax),%eax
  10123b:	05 00 00 10 00       	add    $0x100000,%eax
  101240:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Allocate kernel stack.
  p->kstack = sp - KSTACKSIZE;
  101243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101246:	8d 90 00 f0 ff ff    	lea    -0x1000(%eax),%edx
  10124c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10124f:	89 50 08             	mov    %edx,0x8(%eax)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  101252:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
  101256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101259:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10125c:	89 50 18             	mov    %edx,0x18(%eax)

  sp -= sizeof *p->context;
  10125f:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
  101263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101266:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101269:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
  10126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10126f:	8b 40 1c             	mov    0x1c(%eax),%eax
  101272:	83 ec 04             	sub    $0x4,%esp
  101275:	6a 14                	push   $0x14
  101277:	6a 00                	push   $0x0
  101279:	50                   	push   %eax
  10127a:	e8 7f fc ff ff       	call   100efe <memset>
  10127f:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)trapret;
  101282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101285:	8b 40 1c             	mov    0x1c(%eax),%eax
  101288:	ba 90 17 10 00       	mov    $0x101790,%edx
  10128d:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
  101290:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101293:	c9                   	leave  
  101294:	c3                   	ret    

00101295 <pinit>:

// Set up first process.
void
pinit(int pol)
{
  101295:	55                   	push   %ebp
  101296:	89 e5                	mov    %esp,%ebp
  101298:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  10129b:	e8 17 ff ff ff       	call   1011b7 <allocproc>
  1012a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
  1012a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012a6:	a3 80 88 10 00       	mov    %eax,0x108880

  memmove(p->offset, _binary_initcode_start, (int)_binary_initcode_size);
  1012ab:	ba 15 00 00 00       	mov    $0x15,%edx
  1012b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012b3:	8b 40 04             	mov    0x4(%eax),%eax
  1012b6:	83 ec 04             	sub    $0x4,%esp
  1012b9:	52                   	push   %edx
  1012ba:	68 44 64 10 00       	push   $0x106444
  1012bf:	50                   	push   %eax
  1012c0:	e8 f8 fc ff ff       	call   100fbd <memmove>
  1012c5:	83 c4 10             	add    $0x10,%esp
  memset(p->tf, 0, sizeof(*p->tf));
  1012c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012cb:	8b 40 18             	mov    0x18(%eax),%eax
  1012ce:	83 ec 04             	sub    $0x4,%esp
  1012d1:	6a 4c                	push   $0x4c
  1012d3:	6a 00                	push   $0x0
  1012d5:	50                   	push   %eax
  1012d6:	e8 23 fc ff ff       	call   100efe <memset>
  1012db:	83 c4 10             	add    $0x10,%esp

  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1012de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012e1:	8b 40 18             	mov    0x18(%eax),%eax
  1012e4:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  1012ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012ed:	8b 40 18             	mov    0x18(%eax),%eax
  1012f0:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
  1012f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012f9:	8b 50 18             	mov    0x18(%eax),%edx
  1012fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012ff:	8b 40 18             	mov    0x18(%eax),%eax
  101302:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
  101306:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
  10130a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10130d:	8b 50 18             	mov    0x18(%eax),%edx
  101310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101313:	8b 40 18             	mov    0x18(%eax),%eax
  101316:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
  10131a:	66 89 50 48          	mov    %dx,0x48(%eax)

  p->tf->eflags = FL_IF;
  10131e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101321:	8b 40 18             	mov    0x18(%eax),%eax
  101324:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE - KSTACKSIZE;
  10132b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10132e:	8b 40 18             	mov    0x18(%eax),%eax
  101331:	c7 40 44 00 f0 0f 00 	movl   $0xff000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
  101338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10133b:	8b 40 18             	mov    0x18(%eax),%eax
  10133e:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
  101345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101348:	83 c0 64             	add    $0x64,%eax
  10134b:	83 ec 04             	sub    $0x4,%esp
  10134e:	6a 10                	push   $0x10
  101350:	68 e3 56 10 00       	push   $0x1056e3
  101355:	50                   	push   %eax
  101356:	e8 a6 fd ff ff       	call   101101 <safestrcpy>
  10135b:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
  10135e:	83 ec 0c             	sub    $0xc,%esp
  101361:	68 ec 56 10 00       	push   $0x1056ec
  101366:	e8 c3 26 00 00       	call   103a2e <namei>
  10136b:	83 c4 10             	add    $0x10,%esp
  10136e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101371:	89 42 60             	mov    %eax,0x60(%edx)

  p->state = RUNNABLE;
  101374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101377:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  p->policy = pol;
  10137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101381:	8b 55 08             	mov    0x8(%ebp),%edx
  101384:	89 50 74             	mov    %edx,0x74(%eax)
}
  101387:	90                   	nop
  101388:	c9                   	leave  
  101389:	c3                   	ret    

0010138a <scheduler>:
//   }
// }

void
scheduler(void)
{
  10138a:	55                   	push   %ebp
  10138b:	89 e5                	mov    %esp,%ebp
  10138d:	81 ec 28 02 00 00    	sub    $0x228,%esp
  struct proc *p;
  struct cpu *c = mycpu();
  101393:	e8 fc fd ff ff       	call   101194 <mycpu>
  101398:	89 45 d8             	mov    %eax,-0x28(%ebp)
  c->proc = 0;
  10139b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10139e:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  1013a5:	00 00 00 
  int fg_run = 0;
  1013a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int bg_run = 0;
  1013af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  struct proc *fg_queue[NPROC];
  struct proc *bg_queue[NPROC];
  int fg_index = 0;
  1013b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  int bg_index = 0;
  1013bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

  for (;;){
  // Enable interrupts on this processor.
    sti();
  1013c4:	e8 ba fd ff ff       	call   101183 <sti>

    // Loop over process table looking for process to run and add to respective queues.
    int fg_count = 0;
  1013c9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    int bg_count = 0;
  1013d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1013d7:	c7 45 f4 80 6a 10 00 	movl   $0x106a80,-0xc(%ebp)
  1013de:	eb 5a                	jmp    10143a <scheduler+0xb0>
      if(p->state != RUNNABLE)
  1013e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1013e3:	8b 40 0c             	mov    0xc(%eax),%eax
  1013e6:	83 f8 02             	cmp    $0x2,%eax
  1013e9:	75 4a                	jne    101435 <scheduler+0xab>
        continue;

      if(p->policy == 0){
  1013eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1013ee:	8b 40 74             	mov    0x74(%eax),%eax
  1013f1:	85 c0                	test   %eax,%eax
  1013f3:	75 20                	jne    101415 <scheduler+0x8b>
        fg_queue[fg_count % NPROC] = p;
  1013f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1013f8:	99                   	cltd   
  1013f9:	c1 ea 1a             	shr    $0x1a,%edx
  1013fc:	01 d0                	add    %edx,%eax
  1013fe:	83 e0 3f             	and    $0x3f,%eax
  101401:	29 d0                	sub    %edx,%eax
  101403:	89 c2                	mov    %eax,%edx
  101405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101408:	89 84 95 d8 fe ff ff 	mov    %eax,-0x128(%ebp,%edx,4)
        fg_count++;
  10140f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  101413:	eb 21                	jmp    101436 <scheduler+0xac>
      } else {
        bg_queue[bg_count % NPROC] = p;
  101415:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101418:	99                   	cltd   
  101419:	c1 ea 1a             	shr    $0x1a,%edx
  10141c:	01 d0                	add    %edx,%eax
  10141e:	83 e0 3f             	and    $0x3f,%eax
  101421:	29 d0                	sub    %edx,%eax
  101423:	89 c2                	mov    %eax,%edx
  101425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101428:	89 84 95 d8 fd ff ff 	mov    %eax,-0x228(%ebp,%edx,4)
        bg_count++;
  10142f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  101433:	eb 01                	jmp    101436 <scheduler+0xac>
        continue;
  101435:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  101436:	83 45 f4 78          	addl   $0x78,-0xc(%ebp)
  10143a:	81 7d f4 80 88 10 00 	cmpl   $0x108880,-0xc(%ebp)
  101441:	72 9d                	jb     1013e0 <scheduler+0x56>
      }
    }

    if(fg_count > 0 && (bg_count == 0 || fg_run < 9 || (bg_run > 0 && fg_run < 9 * bg_run))){ // there is a fg process to run and either fg has not run 9 times or there is no bg process to run or fg has run less than 9 times bg has run
  101443:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  101447:	7e 47                	jle    101490 <scheduler+0x106>
  101449:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10144d:	74 1b                	je     10146a <scheduler+0xe0>
  10144f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  101453:	7e 15                	jle    10146a <scheduler+0xe0>
  101455:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  101459:	7e 35                	jle    101490 <scheduler+0x106>
  10145b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10145e:	89 d0                	mov    %edx,%eax
  101460:	c1 e0 03             	shl    $0x3,%eax
  101463:	01 d0                	add    %edx,%eax
  101465:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  101468:	7d 26                	jge    101490 <scheduler+0x106>
      p = fg_queue[fg_index % fg_count];
  10146a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10146d:	99                   	cltd   
  10146e:	f7 7d e0             	idivl  -0x20(%ebp)
  101471:	89 d0                	mov    %edx,%eax
  101473:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
  10147a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      fg_index = (fg_index + 1) % fg_count;
  10147d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101480:	83 c0 01             	add    $0x1,%eax
  101483:	99                   	cltd   
  101484:	f7 7d e0             	idivl  -0x20(%ebp)
  101487:	89 55 e8             	mov    %edx,-0x18(%ebp)
      fg_run++;
  10148a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  10148e:	eb 2a                	jmp    1014ba <scheduler+0x130>
    } else if(bg_count > 0){
  101490:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  101494:	7e 66                	jle    1014fc <scheduler+0x172>
      p = bg_queue[bg_index % bg_count];
  101496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101499:	99                   	cltd   
  10149a:	f7 7d dc             	idivl  -0x24(%ebp)
  10149d:	89 d0                	mov    %edx,%eax
  10149f:	8b 84 85 d8 fd ff ff 	mov    -0x228(%ebp,%eax,4),%eax
  1014a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      bg_index = (bg_index + 1) % bg_count;
  1014a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1014ac:	83 c0 01             	add    $0x1,%eax
  1014af:	99                   	cltd   
  1014b0:	f7 7d dc             	idivl  -0x24(%ebp)
  1014b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      bg_run++;
  1014b6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    } else {
      continue;
    }

    c->proc = p;
  1014ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1014bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1014c0:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
    p->state = RUNNING;
  1014c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1014c9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

    switchuvm(p);
  1014d0:	83 ec 0c             	sub    $0xc,%esp
  1014d3:	ff 75 f4             	push   -0xc(%ebp)
  1014d6:	e8 ad 33 00 00       	call   104888 <switchuvm>
  1014db:	83 c4 10             	add    $0x10,%esp
    swtch(&(c->scheduler), p->context);
  1014de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1014e1:	8b 40 1c             	mov    0x1c(%eax),%eax
  1014e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1014e7:	83 c2 04             	add    $0x4,%edx
  1014ea:	83 ec 08             	sub    $0x8,%esp
  1014ed:	50                   	push   %eax
  1014ee:	52                   	push   %edx
  1014ef:	e8 9c 31 00 00       	call   104690 <swtch>
  1014f4:	83 c4 10             	add    $0x10,%esp
  1014f7:	e9 c8 fe ff ff       	jmp    1013c4 <scheduler+0x3a>
      continue;
  1014fc:	90                   	nop
  for (;;){
  1014fd:	e9 c2 fe ff ff       	jmp    1013c4 <scheduler+0x3a>

00101502 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  101502:	55                   	push   %ebp
  101503:	89 e5                	mov    %esp,%ebp
  101505:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct cpu* c = mycpu();
  101508:	e8 87 fc ff ff       	call   101194 <mycpu>
  10150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc *p = myproc();
  101510:	e8 89 fc ff ff       	call   10119e <myproc>
  101515:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(p->state == RUNNING)
  101518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10151b:	8b 40 0c             	mov    0xc(%eax),%eax
  10151e:	83 f8 03             	cmp    $0x3,%eax
  101521:	75 0d                	jne    101530 <sched+0x2e>
    panic("sched running");
  101523:	83 ec 0c             	sub    $0xc,%esp
  101526:	68 ee 56 10 00       	push   $0x1056ee
  10152b:	e8 7d ed ff ff       	call   1002ad <panic>
  if(readeflags()&FL_IF)
  101530:	e8 3e fc ff ff       	call   101173 <readeflags>
  101535:	25 00 02 00 00       	and    $0x200,%eax
  10153a:	85 c0                	test   %eax,%eax
  10153c:	74 0d                	je     10154b <sched+0x49>
    panic("sched interruptible");
  10153e:	83 ec 0c             	sub    $0xc,%esp
  101541:	68 fc 56 10 00       	push   $0x1056fc
  101546:	e8 62 ed ff ff       	call   1002ad <panic>
  intena = c->intena;
  10154b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10154e:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
  101554:	89 45 ec             	mov    %eax,-0x14(%ebp)
  swtch(&p->context, c->scheduler);
  101557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10155a:	8b 40 04             	mov    0x4(%eax),%eax
  10155d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101560:	83 c2 1c             	add    $0x1c,%edx
  101563:	83 ec 08             	sub    $0x8,%esp
  101566:	50                   	push   %eax
  101567:	52                   	push   %edx
  101568:	e8 23 31 00 00       	call   104690 <swtch>
  10156d:	83 c4 10             	add    $0x10,%esp
  c->intena = intena;
  101570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101573:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101576:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
  10157c:	90                   	nop
  10157d:	c9                   	leave  
  10157e:	c3                   	ret    

0010157f <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
  10157f:	55                   	push   %ebp
  101580:	89 e5                	mov    %esp,%ebp
  101582:	83 ec 08             	sub    $0x8,%esp
  myproc()->state = RUNNABLE;
  101585:	e8 14 fc ff ff       	call   10119e <myproc>
  10158a:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  101591:	e8 6c ff ff ff       	call   101502 <sched>
}
  101596:	90                   	nop
  101597:	c9                   	leave  
  101598:	c3                   	ret    

00101599 <procdump>:

void
procdump(void)
{
  101599:	55                   	push   %ebp
  10159a:	89 e5                	mov    %esp,%ebp
  10159c:	83 ec 18             	sub    $0x18,%esp
  [RUNNING]   "run   ",
  };
  struct proc *p;
  char *state;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  10159f:	c7 45 f4 80 6a 10 00 	movl   $0x106a80,-0xc(%ebp)
  1015a6:	eb 74                	jmp    10161c <procdump+0x83>
    if(p->state == UNUSED)
  1015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015ab:	8b 40 0c             	mov    0xc(%eax),%eax
  1015ae:	85 c0                	test   %eax,%eax
  1015b0:	74 65                	je     101617 <procdump+0x7e>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1015b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015b5:	8b 40 0c             	mov    0xc(%eax),%eax
  1015b8:	83 f8 03             	cmp    $0x3,%eax
  1015bb:	77 23                	ja     1015e0 <procdump+0x47>
  1015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015c0:	8b 40 0c             	mov    0xc(%eax),%eax
  1015c3:	8b 04 85 18 60 10 00 	mov    0x106018(,%eax,4),%eax
  1015ca:	85 c0                	test   %eax,%eax
  1015cc:	74 12                	je     1015e0 <procdump+0x47>
      state = states[p->state];
  1015ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015d1:	8b 40 0c             	mov    0xc(%eax),%eax
  1015d4:	8b 04 85 18 60 10 00 	mov    0x106018(,%eax,4),%eax
  1015db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1015de:	eb 07                	jmp    1015e7 <procdump+0x4e>
    else
      state = "???";
  1015e0:	c7 45 f0 10 57 10 00 	movl   $0x105710,-0x10(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
  1015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015ea:	8d 50 64             	lea    0x64(%eax),%edx
  1015ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015f0:	8b 40 10             	mov    0x10(%eax),%eax
  1015f3:	52                   	push   %edx
  1015f4:	ff 75 f0             	push   -0x10(%ebp)
  1015f7:	50                   	push   %eax
  1015f8:	68 14 57 10 00       	push   $0x105714
  1015fd:	e8 ea ea ff ff       	call   1000ec <cprintf>
  101602:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  101605:	83 ec 0c             	sub    $0xc,%esp
  101608:	68 1d 57 10 00       	push   $0x10571d
  10160d:	e8 da ea ff ff       	call   1000ec <cprintf>
  101612:	83 c4 10             	add    $0x10,%esp
  101615:	eb 01                	jmp    101618 <procdump+0x7f>
      continue;
  101617:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  101618:	83 45 f4 78          	addl   $0x78,-0xc(%ebp)
  10161c:	81 7d f4 80 88 10 00 	cmpl   $0x108880,-0xc(%ebp)
  101623:	72 83                	jb     1015a8 <procdump+0xf>
  }
  101625:	90                   	nop
  101626:	90                   	nop
  101627:	c9                   	leave  
  101628:	c3                   	ret    

00101629 <readeflags>:
{
  101629:	55                   	push   %ebp
  10162a:	89 e5                	mov    %esp,%ebp
  10162c:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  10162f:	9c                   	pushf  
  101630:	58                   	pop    %eax
  101631:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
  101634:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101637:	c9                   	leave  
  101638:	c3                   	ret    

00101639 <cli>:
{
  101639:	55                   	push   %ebp
  10163a:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
  10163c:	fa                   	cli    
}
  10163d:	90                   	nop
  10163e:	5d                   	pop    %ebp
  10163f:	c3                   	ret    

00101640 <sti>:
{
  101640:	55                   	push   %ebp
  101641:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
  101643:	fb                   	sti    
}
  101644:	90                   	nop
  101645:	5d                   	pop    %ebp
  101646:	c3                   	ret    

00101647 <getcallerpcs>:
#include "proc.h"

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  101647:	55                   	push   %ebp
  101648:	89 e5                	mov    %esp,%ebp
  10164a:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  10164d:	8b 45 08             	mov    0x8(%ebp),%eax
  101650:	83 e8 08             	sub    $0x8,%eax
  101653:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
  101656:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  10165d:	eb 2f                	jmp    10168e <getcallerpcs+0x47>
    // if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  10165f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  101663:	74 4a                	je     1016af <getcallerpcs+0x68>
  101665:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
  101669:	74 44                	je     1016af <getcallerpcs+0x68>
      break;
    pcs[i] = ebp[1];     // saved %eip
  10166b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10166e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101675:	8b 45 0c             	mov    0xc(%ebp),%eax
  101678:	01 c2                	add    %eax,%edx
  10167a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10167d:	8b 40 04             	mov    0x4(%eax),%eax
  101680:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
  101682:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101685:	8b 00                	mov    (%eax),%eax
  101687:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
  10168a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  10168e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
  101692:	7e cb                	jle    10165f <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
  101694:	eb 19                	jmp    1016af <getcallerpcs+0x68>
    pcs[i] = 0;
  101696:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101699:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1016a3:	01 d0                	add    %edx,%eax
  1016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
  1016ab:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  1016af:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
  1016b3:	7e e1                	jle    101696 <getcallerpcs+0x4f>
}
  1016b5:	90                   	nop
  1016b6:	90                   	nop
  1016b7:	c9                   	leave  
  1016b8:	c3                   	ret    

001016b9 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  1016b9:	55                   	push   %ebp
  1016ba:	89 e5                	mov    %esp,%ebp
  1016bc:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
  1016bf:	e8 65 ff ff ff       	call   101629 <readeflags>
  1016c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
  1016c7:	e8 6d ff ff ff       	call   101639 <cli>
  if(mycpu()->ncli == 0)
  1016cc:	e8 c3 fa ff ff       	call   101194 <mycpu>
  1016d1:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
  1016d7:	85 c0                	test   %eax,%eax
  1016d9:	75 14                	jne    1016ef <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
  1016db:	e8 b4 fa ff ff       	call   101194 <mycpu>
  1016e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1016e3:	81 e2 00 02 00 00    	and    $0x200,%edx
  1016e9:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
  mycpu()->ncli += 1;
  1016ef:	e8 a0 fa ff ff       	call   101194 <mycpu>
  1016f4:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  1016fa:	83 c2 01             	add    $0x1,%edx
  1016fd:	89 90 a0 00 00 00    	mov    %edx,0xa0(%eax)
}
  101703:	90                   	nop
  101704:	c9                   	leave  
  101705:	c3                   	ret    

00101706 <popcli>:

void
popcli(void)
{
  101706:	55                   	push   %ebp
  101707:	89 e5                	mov    %esp,%ebp
  101709:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
  10170c:	e8 18 ff ff ff       	call   101629 <readeflags>
  101711:	25 00 02 00 00       	and    $0x200,%eax
  101716:	85 c0                	test   %eax,%eax
  101718:	74 0d                	je     101727 <popcli+0x21>
    panic("popcli - interruptible");
  10171a:	83 ec 0c             	sub    $0xc,%esp
  10171d:	68 3b 57 10 00       	push   $0x10573b
  101722:	e8 86 eb ff ff       	call   1002ad <panic>
  if(--mycpu()->ncli < 0)
  101727:	e8 68 fa ff ff       	call   101194 <mycpu>
  10172c:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  101732:	83 ea 01             	sub    $0x1,%edx
  101735:	89 90 a0 00 00 00    	mov    %edx,0xa0(%eax)
  10173b:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
  101741:	85 c0                	test   %eax,%eax
  101743:	79 0d                	jns    101752 <popcli+0x4c>
    panic("popcli");
  101745:	83 ec 0c             	sub    $0xc,%esp
  101748:	68 52 57 10 00       	push   $0x105752
  10174d:	e8 5b eb ff ff       	call   1002ad <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
  101752:	e8 3d fa ff ff       	call   101194 <mycpu>
  101757:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
  10175d:	85 c0                	test   %eax,%eax
  10175f:	75 14                	jne    101775 <popcli+0x6f>
  101761:	e8 2e fa ff ff       	call   101194 <mycpu>
  101766:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
  10176c:	85 c0                	test   %eax,%eax
  10176e:	74 05                	je     101775 <popcli+0x6f>
    sti();
  101770:	e8 cb fe ff ff       	call   101640 <sti>
}
  101775:	90                   	nop
  101776:	c9                   	leave  
  101777:	c3                   	ret    

00101778 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
  101778:	1e                   	push   %ds
  pushl %es
  101779:	06                   	push   %es
  pushl %fs
  10177a:	0f a0                	push   %fs
  pushl %gs
  10177c:	0f a8                	push   %gs
  pushal
  10177e:	60                   	pusha  

  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax  
  10177f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
  101783:	8e d8                	mov    %eax,%ds
  movw %ax, %es
  101785:	8e c0                	mov    %eax,%es
  
  # Call trap(tf), where tf=%esp
  pushl %esp
  101787:	54                   	push   %esp
  call trap
  101788:	e8 c2 01 00 00       	call   10194f <trap>
  addl $4, %esp
  10178d:	83 c4 04             	add    $0x4,%esp

00101790 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  101790:	61                   	popa   
  popl %gs
  101791:	0f a9                	pop    %gs
  popl %fs
  101793:	0f a1                	pop    %fs
  popl %es
  101795:	07                   	pop    %es
  popl %ds
  101796:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
  101797:	83 c4 08             	add    $0x8,%esp
  iret
  10179a:	cf                   	iret   

0010179b <lidt>:
{
  10179b:	55                   	push   %ebp
  10179c:	89 e5                	mov    %esp,%ebp
  10179e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
  1017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1017a4:	83 e8 01             	sub    $0x1,%eax
  1017a7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
  1017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1017ae:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1017b5:	c1 e8 10             	shr    $0x10,%eax
  1017b8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
  1017bc:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1017bf:	0f 01 18             	lidtl  (%eax)
}
  1017c2:	90                   	nop
  1017c3:	c9                   	leave  
  1017c4:	c3                   	ret    

001017c5 <rcr2>:
  asm volatile("hlt");
}

static inline uint
rcr2(void)
{
  1017c5:	55                   	push   %ebp
  1017c6:	89 e5                	mov    %esp,%ebp
  1017c8:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  1017cb:	0f 20 d0             	mov    %cr2,%eax
  1017ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
  1017d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1017d4:	c9                   	leave  
  1017d5:	c3                   	ret    

001017d6 <tvinit>:
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
uint ticks;

void
tvinit(void)
{
  1017d6:	55                   	push   %ebp
  1017d7:	89 e5                	mov    %esp,%ebp
  1017d9:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
  1017dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1017e3:	e9 c3 00 00 00       	jmp    1018ab <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  1017e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017eb:	8b 04 85 28 60 10 00 	mov    0x106028(,%eax,4),%eax
  1017f2:	89 c2                	mov    %eax,%edx
  1017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017f7:	66 89 14 c5 a0 88 10 	mov    %dx,0x1088a0(,%eax,8)
  1017fe:	00 
  1017ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101802:	66 c7 04 c5 a2 88 10 	movw   $0x8,0x1088a2(,%eax,8)
  101809:	00 08 00 
  10180c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180f:	0f b6 14 c5 a4 88 10 	movzbl 0x1088a4(,%eax,8),%edx
  101816:	00 
  101817:	83 e2 e0             	and    $0xffffffe0,%edx
  10181a:	88 14 c5 a4 88 10 00 	mov    %dl,0x1088a4(,%eax,8)
  101821:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101824:	0f b6 14 c5 a4 88 10 	movzbl 0x1088a4(,%eax,8),%edx
  10182b:	00 
  10182c:	83 e2 1f             	and    $0x1f,%edx
  10182f:	88 14 c5 a4 88 10 00 	mov    %dl,0x1088a4(,%eax,8)
  101836:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101839:	0f b6 14 c5 a5 88 10 	movzbl 0x1088a5(,%eax,8),%edx
  101840:	00 
  101841:	83 e2 f0             	and    $0xfffffff0,%edx
  101844:	83 ca 0e             	or     $0xe,%edx
  101847:	88 14 c5 a5 88 10 00 	mov    %dl,0x1088a5(,%eax,8)
  10184e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101851:	0f b6 14 c5 a5 88 10 	movzbl 0x1088a5(,%eax,8),%edx
  101858:	00 
  101859:	83 e2 ef             	and    $0xffffffef,%edx
  10185c:	88 14 c5 a5 88 10 00 	mov    %dl,0x1088a5(,%eax,8)
  101863:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101866:	0f b6 14 c5 a5 88 10 	movzbl 0x1088a5(,%eax,8),%edx
  10186d:	00 
  10186e:	83 e2 9f             	and    $0xffffff9f,%edx
  101871:	88 14 c5 a5 88 10 00 	mov    %dl,0x1088a5(,%eax,8)
  101878:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187b:	0f b6 14 c5 a5 88 10 	movzbl 0x1088a5(,%eax,8),%edx
  101882:	00 
  101883:	83 ca 80             	or     $0xffffff80,%edx
  101886:	88 14 c5 a5 88 10 00 	mov    %dl,0x1088a5(,%eax,8)
  10188d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101890:	8b 04 85 28 60 10 00 	mov    0x106028(,%eax,4),%eax
  101897:	c1 e8 10             	shr    $0x10,%eax
  10189a:	89 c2                	mov    %eax,%edx
  10189c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189f:	66 89 14 c5 a6 88 10 	mov    %dx,0x1088a6(,%eax,8)
  1018a6:	00 
  for(i = 0; i < 256; i++)
  1018a7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018ab:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1018b2:	0f 8e 30 ff ff ff    	jle    1017e8 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  1018b8:	a1 28 61 10 00       	mov    0x106128,%eax
  1018bd:	66 a3 a0 8a 10 00    	mov    %ax,0x108aa0
  1018c3:	66 c7 05 a2 8a 10 00 	movw   $0x8,0x108aa2
  1018ca:	08 00 
  1018cc:	0f b6 05 a4 8a 10 00 	movzbl 0x108aa4,%eax
  1018d3:	83 e0 e0             	and    $0xffffffe0,%eax
  1018d6:	a2 a4 8a 10 00       	mov    %al,0x108aa4
  1018db:	0f b6 05 a4 8a 10 00 	movzbl 0x108aa4,%eax
  1018e2:	83 e0 1f             	and    $0x1f,%eax
  1018e5:	a2 a4 8a 10 00       	mov    %al,0x108aa4
  1018ea:	0f b6 05 a5 8a 10 00 	movzbl 0x108aa5,%eax
  1018f1:	83 c8 0f             	or     $0xf,%eax
  1018f4:	a2 a5 8a 10 00       	mov    %al,0x108aa5
  1018f9:	0f b6 05 a5 8a 10 00 	movzbl 0x108aa5,%eax
  101900:	83 e0 ef             	and    $0xffffffef,%eax
  101903:	a2 a5 8a 10 00       	mov    %al,0x108aa5
  101908:	0f b6 05 a5 8a 10 00 	movzbl 0x108aa5,%eax
  10190f:	83 c8 60             	or     $0x60,%eax
  101912:	a2 a5 8a 10 00       	mov    %al,0x108aa5
  101917:	0f b6 05 a5 8a 10 00 	movzbl 0x108aa5,%eax
  10191e:	83 c8 80             	or     $0xffffff80,%eax
  101921:	a2 a5 8a 10 00       	mov    %al,0x108aa5
  101926:	a1 28 61 10 00       	mov    0x106128,%eax
  10192b:	c1 e8 10             	shr    $0x10,%eax
  10192e:	66 a3 a6 8a 10 00    	mov    %ax,0x108aa6
}
  101934:	90                   	nop
  101935:	c9                   	leave  
  101936:	c3                   	ret    

00101937 <idtinit>:

void
idtinit(void)
{
  101937:	55                   	push   %ebp
  101938:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
  10193a:	68 00 08 00 00       	push   $0x800
  10193f:	68 a0 88 10 00       	push   $0x1088a0
  101944:	e8 52 fe ff ff       	call   10179b <lidt>
  101949:	83 c4 08             	add    $0x8,%esp
}
  10194c:	90                   	nop
  10194d:	c9                   	leave  
  10194e:	c3                   	ret    

0010194f <trap>:

void
trap(struct trapframe *tf)
{
  10194f:	55                   	push   %ebp
  101950:	89 e5                	mov    %esp,%ebp
  101952:	56                   	push   %esi
  101953:	53                   	push   %ebx
  if(tf->trapno == T_SYSCALL){
  101954:	8b 45 08             	mov    0x8(%ebp),%eax
  101957:	8b 40 30             	mov    0x30(%eax),%eax
  10195a:	83 f8 40             	cmp    $0x40,%eax
  10195d:	75 15                	jne    101974 <trap+0x25>
    myproc()->tf = tf;
  10195f:	e8 3a f8 ff ff       	call   10119e <myproc>
  101964:	8b 55 08             	mov    0x8(%ebp),%edx
  101967:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
  10196a:	e8 a3 34 00 00       	call   104e12 <syscall>
    return;
  10196f:	e9 ee 00 00 00       	jmp    101a62 <trap+0x113>
  }

  switch(tf->trapno){
  101974:	8b 45 08             	mov    0x8(%ebp),%eax
  101977:	8b 40 30             	mov    0x30(%eax),%eax
  10197a:	83 e8 20             	sub    $0x20,%eax
  10197d:	83 f8 1f             	cmp    $0x1f,%eax
  101980:	77 67                	ja     1019e9 <trap+0x9a>
  101982:	8b 04 85 b8 57 10 00 	mov    0x1057b8(,%eax,4),%eax
  101989:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    ticks++;
  10198b:	a1 a0 90 10 00       	mov    0x1090a0,%eax
  101990:	83 c0 01             	add    $0x1,%eax
  101993:	a3 a0 90 10 00       	mov    %eax,0x1090a0
    lapiceoi();
  101998:	e8 aa ee ff ff       	call   100847 <lapiceoi>
    break;
  10199d:	e9 9a 00 00 00       	jmp    101a3c <trap+0xed>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
  1019a2:	e8 05 10 00 00       	call   1029ac <ideintr>
    lapiceoi();
  1019a7:	e8 9b ee ff ff       	call   100847 <lapiceoi>
    break;
  1019ac:	e9 8b 00 00 00       	jmp    101a3c <trap+0xed>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
  1019b1:	e8 e3 f4 ff ff       	call   100e99 <uartintr>
    lapiceoi();
  1019b6:	e8 8c ee ff ff       	call   100847 <lapiceoi>
    break;
  1019bb:	eb 7f                	jmp    101a3c <trap+0xed>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  1019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c0:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
  1019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  1019ca:	0f b7 d8             	movzwl %ax,%ebx
  1019cd:	e8 b8 f7 ff ff       	call   10118a <cpuid>
  1019d2:	56                   	push   %esi
  1019d3:	53                   	push   %ebx
  1019d4:	50                   	push   %eax
  1019d5:	68 5c 57 10 00       	push   $0x10575c
  1019da:	e8 0d e7 ff ff       	call   1000ec <cprintf>
  1019df:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
  1019e2:	e8 60 ee ff ff       	call   100847 <lapiceoi>
    break;
  1019e7:	eb 53                	jmp    101a3c <trap+0xed>

  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
  1019e9:	e8 b0 f7 ff ff       	call   10119e <myproc>
  1019ee:	85 c0                	test   %eax,%eax
  1019f0:	74 11                	je     101a03 <trap+0xb4>
  1019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019f9:	0f b7 c0             	movzwl %ax,%eax
  1019fc:	83 e0 03             	and    $0x3,%eax
  1019ff:	85 c0                	test   %eax,%eax
  101a01:	75 39                	jne    101a3c <trap+0xed>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  101a03:	e8 bd fd ff ff       	call   1017c5 <rcr2>
  101a08:	89 c3                	mov    %eax,%ebx
  101a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0d:	8b 70 38             	mov    0x38(%eax),%esi
  101a10:	e8 75 f7 ff ff       	call   10118a <cpuid>
  101a15:	8b 55 08             	mov    0x8(%ebp),%edx
  101a18:	8b 52 30             	mov    0x30(%edx),%edx
  101a1b:	83 ec 0c             	sub    $0xc,%esp
  101a1e:	53                   	push   %ebx
  101a1f:	56                   	push   %esi
  101a20:	50                   	push   %eax
  101a21:	52                   	push   %edx
  101a22:	68 80 57 10 00       	push   $0x105780
  101a27:	e8 c0 e6 ff ff       	call   1000ec <cprintf>
  101a2c:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
  101a2f:	83 ec 0c             	sub    $0xc,%esp
  101a32:	68 b2 57 10 00       	push   $0x1057b2
  101a37:	e8 71 e8 ff ff       	call   1002ad <panic>
    }
  }

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
  101a3c:	e8 5d f7 ff ff       	call   10119e <myproc>
  101a41:	85 c0                	test   %eax,%eax
  101a43:	74 1d                	je     101a62 <trap+0x113>
  101a45:	e8 54 f7 ff ff       	call   10119e <myproc>
  101a4a:	8b 40 0c             	mov    0xc(%eax),%eax
  101a4d:	83 f8 03             	cmp    $0x3,%eax
  101a50:	75 10                	jne    101a62 <trap+0x113>
    tf->trapno == T_IRQ0+IRQ_TIMER) {
  101a52:	8b 45 08             	mov    0x8(%ebp),%eax
  101a55:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
  101a58:	83 f8 20             	cmp    $0x20,%eax
  101a5b:	75 05                	jne    101a62 <trap+0x113>
    yield();
  101a5d:	e8 1d fb ff ff       	call   10157f <yield>
  }
}
  101a62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  101a65:	5b                   	pop    %ebx
  101a66:	5e                   	pop    %esi
  101a67:	5d                   	pop    %ebp
  101a68:	c3                   	ret    

00101a69 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  101a69:	6a 00                	push   $0x0
  pushl $0
  101a6b:	6a 00                	push   $0x0
  jmp alltraps
  101a6d:	e9 06 fd ff ff       	jmp    101778 <alltraps>

00101a72 <vector1>:
.globl vector1
vector1:
  pushl $0
  101a72:	6a 00                	push   $0x0
  pushl $1
  101a74:	6a 01                	push   $0x1
  jmp alltraps
  101a76:	e9 fd fc ff ff       	jmp    101778 <alltraps>

00101a7b <vector2>:
.globl vector2
vector2:
  pushl $0
  101a7b:	6a 00                	push   $0x0
  pushl $2
  101a7d:	6a 02                	push   $0x2
  jmp alltraps
  101a7f:	e9 f4 fc ff ff       	jmp    101778 <alltraps>

00101a84 <vector3>:
.globl vector3
vector3:
  pushl $0
  101a84:	6a 00                	push   $0x0
  pushl $3
  101a86:	6a 03                	push   $0x3
  jmp alltraps
  101a88:	e9 eb fc ff ff       	jmp    101778 <alltraps>

00101a8d <vector4>:
.globl vector4
vector4:
  pushl $0
  101a8d:	6a 00                	push   $0x0
  pushl $4
  101a8f:	6a 04                	push   $0x4
  jmp alltraps
  101a91:	e9 e2 fc ff ff       	jmp    101778 <alltraps>

00101a96 <vector5>:
.globl vector5
vector5:
  pushl $0
  101a96:	6a 00                	push   $0x0
  pushl $5
  101a98:	6a 05                	push   $0x5
  jmp alltraps
  101a9a:	e9 d9 fc ff ff       	jmp    101778 <alltraps>

00101a9f <vector6>:
.globl vector6
vector6:
  pushl $0
  101a9f:	6a 00                	push   $0x0
  pushl $6
  101aa1:	6a 06                	push   $0x6
  jmp alltraps
  101aa3:	e9 d0 fc ff ff       	jmp    101778 <alltraps>

00101aa8 <vector7>:
.globl vector7
vector7:
  pushl $0
  101aa8:	6a 00                	push   $0x0
  pushl $7
  101aaa:	6a 07                	push   $0x7
  jmp alltraps
  101aac:	e9 c7 fc ff ff       	jmp    101778 <alltraps>

00101ab1 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ab1:	6a 08                	push   $0x8
  jmp alltraps
  101ab3:	e9 c0 fc ff ff       	jmp    101778 <alltraps>

00101ab8 <vector9>:
.globl vector9
vector9:
  pushl $0
  101ab8:	6a 00                	push   $0x0
  pushl $9
  101aba:	6a 09                	push   $0x9
  jmp alltraps
  101abc:	e9 b7 fc ff ff       	jmp    101778 <alltraps>

00101ac1 <vector10>:
.globl vector10
vector10:
  pushl $10
  101ac1:	6a 0a                	push   $0xa
  jmp alltraps
  101ac3:	e9 b0 fc ff ff       	jmp    101778 <alltraps>

00101ac8 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ac8:	6a 0b                	push   $0xb
  jmp alltraps
  101aca:	e9 a9 fc ff ff       	jmp    101778 <alltraps>

00101acf <vector12>:
.globl vector12
vector12:
  pushl $12
  101acf:	6a 0c                	push   $0xc
  jmp alltraps
  101ad1:	e9 a2 fc ff ff       	jmp    101778 <alltraps>

00101ad6 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ad6:	6a 0d                	push   $0xd
  jmp alltraps
  101ad8:	e9 9b fc ff ff       	jmp    101778 <alltraps>

00101add <vector14>:
.globl vector14
vector14:
  pushl $14
  101add:	6a 0e                	push   $0xe
  jmp alltraps
  101adf:	e9 94 fc ff ff       	jmp    101778 <alltraps>

00101ae4 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ae4:	6a 00                	push   $0x0
  pushl $15
  101ae6:	6a 0f                	push   $0xf
  jmp alltraps
  101ae8:	e9 8b fc ff ff       	jmp    101778 <alltraps>

00101aed <vector16>:
.globl vector16
vector16:
  pushl $0
  101aed:	6a 00                	push   $0x0
  pushl $16
  101aef:	6a 10                	push   $0x10
  jmp alltraps
  101af1:	e9 82 fc ff ff       	jmp    101778 <alltraps>

00101af6 <vector17>:
.globl vector17
vector17:
  pushl $17
  101af6:	6a 11                	push   $0x11
  jmp alltraps
  101af8:	e9 7b fc ff ff       	jmp    101778 <alltraps>

00101afd <vector18>:
.globl vector18
vector18:
  pushl $0
  101afd:	6a 00                	push   $0x0
  pushl $18
  101aff:	6a 12                	push   $0x12
  jmp alltraps
  101b01:	e9 72 fc ff ff       	jmp    101778 <alltraps>

00101b06 <vector19>:
.globl vector19
vector19:
  pushl $0
  101b06:	6a 00                	push   $0x0
  pushl $19
  101b08:	6a 13                	push   $0x13
  jmp alltraps
  101b0a:	e9 69 fc ff ff       	jmp    101778 <alltraps>

00101b0f <vector20>:
.globl vector20
vector20:
  pushl $0
  101b0f:	6a 00                	push   $0x0
  pushl $20
  101b11:	6a 14                	push   $0x14
  jmp alltraps
  101b13:	e9 60 fc ff ff       	jmp    101778 <alltraps>

00101b18 <vector21>:
.globl vector21
vector21:
  pushl $0
  101b18:	6a 00                	push   $0x0
  pushl $21
  101b1a:	6a 15                	push   $0x15
  jmp alltraps
  101b1c:	e9 57 fc ff ff       	jmp    101778 <alltraps>

00101b21 <vector22>:
.globl vector22
vector22:
  pushl $0
  101b21:	6a 00                	push   $0x0
  pushl $22
  101b23:	6a 16                	push   $0x16
  jmp alltraps
  101b25:	e9 4e fc ff ff       	jmp    101778 <alltraps>

00101b2a <vector23>:
.globl vector23
vector23:
  pushl $0
  101b2a:	6a 00                	push   $0x0
  pushl $23
  101b2c:	6a 17                	push   $0x17
  jmp alltraps
  101b2e:	e9 45 fc ff ff       	jmp    101778 <alltraps>

00101b33 <vector24>:
.globl vector24
vector24:
  pushl $0
  101b33:	6a 00                	push   $0x0
  pushl $24
  101b35:	6a 18                	push   $0x18
  jmp alltraps
  101b37:	e9 3c fc ff ff       	jmp    101778 <alltraps>

00101b3c <vector25>:
.globl vector25
vector25:
  pushl $0
  101b3c:	6a 00                	push   $0x0
  pushl $25
  101b3e:	6a 19                	push   $0x19
  jmp alltraps
  101b40:	e9 33 fc ff ff       	jmp    101778 <alltraps>

00101b45 <vector26>:
.globl vector26
vector26:
  pushl $0
  101b45:	6a 00                	push   $0x0
  pushl $26
  101b47:	6a 1a                	push   $0x1a
  jmp alltraps
  101b49:	e9 2a fc ff ff       	jmp    101778 <alltraps>

00101b4e <vector27>:
.globl vector27
vector27:
  pushl $0
  101b4e:	6a 00                	push   $0x0
  pushl $27
  101b50:	6a 1b                	push   $0x1b
  jmp alltraps
  101b52:	e9 21 fc ff ff       	jmp    101778 <alltraps>

00101b57 <vector28>:
.globl vector28
vector28:
  pushl $0
  101b57:	6a 00                	push   $0x0
  pushl $28
  101b59:	6a 1c                	push   $0x1c
  jmp alltraps
  101b5b:	e9 18 fc ff ff       	jmp    101778 <alltraps>

00101b60 <vector29>:
.globl vector29
vector29:
  pushl $0
  101b60:	6a 00                	push   $0x0
  pushl $29
  101b62:	6a 1d                	push   $0x1d
  jmp alltraps
  101b64:	e9 0f fc ff ff       	jmp    101778 <alltraps>

00101b69 <vector30>:
.globl vector30
vector30:
  pushl $0
  101b69:	6a 00                	push   $0x0
  pushl $30
  101b6b:	6a 1e                	push   $0x1e
  jmp alltraps
  101b6d:	e9 06 fc ff ff       	jmp    101778 <alltraps>

00101b72 <vector31>:
.globl vector31
vector31:
  pushl $0
  101b72:	6a 00                	push   $0x0
  pushl $31
  101b74:	6a 1f                	push   $0x1f
  jmp alltraps
  101b76:	e9 fd fb ff ff       	jmp    101778 <alltraps>

00101b7b <vector32>:
.globl vector32
vector32:
  pushl $0
  101b7b:	6a 00                	push   $0x0
  pushl $32
  101b7d:	6a 20                	push   $0x20
  jmp alltraps
  101b7f:	e9 f4 fb ff ff       	jmp    101778 <alltraps>

00101b84 <vector33>:
.globl vector33
vector33:
  pushl $0
  101b84:	6a 00                	push   $0x0
  pushl $33
  101b86:	6a 21                	push   $0x21
  jmp alltraps
  101b88:	e9 eb fb ff ff       	jmp    101778 <alltraps>

00101b8d <vector34>:
.globl vector34
vector34:
  pushl $0
  101b8d:	6a 00                	push   $0x0
  pushl $34
  101b8f:	6a 22                	push   $0x22
  jmp alltraps
  101b91:	e9 e2 fb ff ff       	jmp    101778 <alltraps>

00101b96 <vector35>:
.globl vector35
vector35:
  pushl $0
  101b96:	6a 00                	push   $0x0
  pushl $35
  101b98:	6a 23                	push   $0x23
  jmp alltraps
  101b9a:	e9 d9 fb ff ff       	jmp    101778 <alltraps>

00101b9f <vector36>:
.globl vector36
vector36:
  pushl $0
  101b9f:	6a 00                	push   $0x0
  pushl $36
  101ba1:	6a 24                	push   $0x24
  jmp alltraps
  101ba3:	e9 d0 fb ff ff       	jmp    101778 <alltraps>

00101ba8 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ba8:	6a 00                	push   $0x0
  pushl $37
  101baa:	6a 25                	push   $0x25
  jmp alltraps
  101bac:	e9 c7 fb ff ff       	jmp    101778 <alltraps>

00101bb1 <vector38>:
.globl vector38
vector38:
  pushl $0
  101bb1:	6a 00                	push   $0x0
  pushl $38
  101bb3:	6a 26                	push   $0x26
  jmp alltraps
  101bb5:	e9 be fb ff ff       	jmp    101778 <alltraps>

00101bba <vector39>:
.globl vector39
vector39:
  pushl $0
  101bba:	6a 00                	push   $0x0
  pushl $39
  101bbc:	6a 27                	push   $0x27
  jmp alltraps
  101bbe:	e9 b5 fb ff ff       	jmp    101778 <alltraps>

00101bc3 <vector40>:
.globl vector40
vector40:
  pushl $0
  101bc3:	6a 00                	push   $0x0
  pushl $40
  101bc5:	6a 28                	push   $0x28
  jmp alltraps
  101bc7:	e9 ac fb ff ff       	jmp    101778 <alltraps>

00101bcc <vector41>:
.globl vector41
vector41:
  pushl $0
  101bcc:	6a 00                	push   $0x0
  pushl $41
  101bce:	6a 29                	push   $0x29
  jmp alltraps
  101bd0:	e9 a3 fb ff ff       	jmp    101778 <alltraps>

00101bd5 <vector42>:
.globl vector42
vector42:
  pushl $0
  101bd5:	6a 00                	push   $0x0
  pushl $42
  101bd7:	6a 2a                	push   $0x2a
  jmp alltraps
  101bd9:	e9 9a fb ff ff       	jmp    101778 <alltraps>

00101bde <vector43>:
.globl vector43
vector43:
  pushl $0
  101bde:	6a 00                	push   $0x0
  pushl $43
  101be0:	6a 2b                	push   $0x2b
  jmp alltraps
  101be2:	e9 91 fb ff ff       	jmp    101778 <alltraps>

00101be7 <vector44>:
.globl vector44
vector44:
  pushl $0
  101be7:	6a 00                	push   $0x0
  pushl $44
  101be9:	6a 2c                	push   $0x2c
  jmp alltraps
  101beb:	e9 88 fb ff ff       	jmp    101778 <alltraps>

00101bf0 <vector45>:
.globl vector45
vector45:
  pushl $0
  101bf0:	6a 00                	push   $0x0
  pushl $45
  101bf2:	6a 2d                	push   $0x2d
  jmp alltraps
  101bf4:	e9 7f fb ff ff       	jmp    101778 <alltraps>

00101bf9 <vector46>:
.globl vector46
vector46:
  pushl $0
  101bf9:	6a 00                	push   $0x0
  pushl $46
  101bfb:	6a 2e                	push   $0x2e
  jmp alltraps
  101bfd:	e9 76 fb ff ff       	jmp    101778 <alltraps>

00101c02 <vector47>:
.globl vector47
vector47:
  pushl $0
  101c02:	6a 00                	push   $0x0
  pushl $47
  101c04:	6a 2f                	push   $0x2f
  jmp alltraps
  101c06:	e9 6d fb ff ff       	jmp    101778 <alltraps>

00101c0b <vector48>:
.globl vector48
vector48:
  pushl $0
  101c0b:	6a 00                	push   $0x0
  pushl $48
  101c0d:	6a 30                	push   $0x30
  jmp alltraps
  101c0f:	e9 64 fb ff ff       	jmp    101778 <alltraps>

00101c14 <vector49>:
.globl vector49
vector49:
  pushl $0
  101c14:	6a 00                	push   $0x0
  pushl $49
  101c16:	6a 31                	push   $0x31
  jmp alltraps
  101c18:	e9 5b fb ff ff       	jmp    101778 <alltraps>

00101c1d <vector50>:
.globl vector50
vector50:
  pushl $0
  101c1d:	6a 00                	push   $0x0
  pushl $50
  101c1f:	6a 32                	push   $0x32
  jmp alltraps
  101c21:	e9 52 fb ff ff       	jmp    101778 <alltraps>

00101c26 <vector51>:
.globl vector51
vector51:
  pushl $0
  101c26:	6a 00                	push   $0x0
  pushl $51
  101c28:	6a 33                	push   $0x33
  jmp alltraps
  101c2a:	e9 49 fb ff ff       	jmp    101778 <alltraps>

00101c2f <vector52>:
.globl vector52
vector52:
  pushl $0
  101c2f:	6a 00                	push   $0x0
  pushl $52
  101c31:	6a 34                	push   $0x34
  jmp alltraps
  101c33:	e9 40 fb ff ff       	jmp    101778 <alltraps>

00101c38 <vector53>:
.globl vector53
vector53:
  pushl $0
  101c38:	6a 00                	push   $0x0
  pushl $53
  101c3a:	6a 35                	push   $0x35
  jmp alltraps
  101c3c:	e9 37 fb ff ff       	jmp    101778 <alltraps>

00101c41 <vector54>:
.globl vector54
vector54:
  pushl $0
  101c41:	6a 00                	push   $0x0
  pushl $54
  101c43:	6a 36                	push   $0x36
  jmp alltraps
  101c45:	e9 2e fb ff ff       	jmp    101778 <alltraps>

00101c4a <vector55>:
.globl vector55
vector55:
  pushl $0
  101c4a:	6a 00                	push   $0x0
  pushl $55
  101c4c:	6a 37                	push   $0x37
  jmp alltraps
  101c4e:	e9 25 fb ff ff       	jmp    101778 <alltraps>

00101c53 <vector56>:
.globl vector56
vector56:
  pushl $0
  101c53:	6a 00                	push   $0x0
  pushl $56
  101c55:	6a 38                	push   $0x38
  jmp alltraps
  101c57:	e9 1c fb ff ff       	jmp    101778 <alltraps>

00101c5c <vector57>:
.globl vector57
vector57:
  pushl $0
  101c5c:	6a 00                	push   $0x0
  pushl $57
  101c5e:	6a 39                	push   $0x39
  jmp alltraps
  101c60:	e9 13 fb ff ff       	jmp    101778 <alltraps>

00101c65 <vector58>:
.globl vector58
vector58:
  pushl $0
  101c65:	6a 00                	push   $0x0
  pushl $58
  101c67:	6a 3a                	push   $0x3a
  jmp alltraps
  101c69:	e9 0a fb ff ff       	jmp    101778 <alltraps>

00101c6e <vector59>:
.globl vector59
vector59:
  pushl $0
  101c6e:	6a 00                	push   $0x0
  pushl $59
  101c70:	6a 3b                	push   $0x3b
  jmp alltraps
  101c72:	e9 01 fb ff ff       	jmp    101778 <alltraps>

00101c77 <vector60>:
.globl vector60
vector60:
  pushl $0
  101c77:	6a 00                	push   $0x0
  pushl $60
  101c79:	6a 3c                	push   $0x3c
  jmp alltraps
  101c7b:	e9 f8 fa ff ff       	jmp    101778 <alltraps>

00101c80 <vector61>:
.globl vector61
vector61:
  pushl $0
  101c80:	6a 00                	push   $0x0
  pushl $61
  101c82:	6a 3d                	push   $0x3d
  jmp alltraps
  101c84:	e9 ef fa ff ff       	jmp    101778 <alltraps>

00101c89 <vector62>:
.globl vector62
vector62:
  pushl $0
  101c89:	6a 00                	push   $0x0
  pushl $62
  101c8b:	6a 3e                	push   $0x3e
  jmp alltraps
  101c8d:	e9 e6 fa ff ff       	jmp    101778 <alltraps>

00101c92 <vector63>:
.globl vector63
vector63:
  pushl $0
  101c92:	6a 00                	push   $0x0
  pushl $63
  101c94:	6a 3f                	push   $0x3f
  jmp alltraps
  101c96:	e9 dd fa ff ff       	jmp    101778 <alltraps>

00101c9b <vector64>:
.globl vector64
vector64:
  pushl $0
  101c9b:	6a 00                	push   $0x0
  pushl $64
  101c9d:	6a 40                	push   $0x40
  jmp alltraps
  101c9f:	e9 d4 fa ff ff       	jmp    101778 <alltraps>

00101ca4 <vector65>:
.globl vector65
vector65:
  pushl $0
  101ca4:	6a 00                	push   $0x0
  pushl $65
  101ca6:	6a 41                	push   $0x41
  jmp alltraps
  101ca8:	e9 cb fa ff ff       	jmp    101778 <alltraps>

00101cad <vector66>:
.globl vector66
vector66:
  pushl $0
  101cad:	6a 00                	push   $0x0
  pushl $66
  101caf:	6a 42                	push   $0x42
  jmp alltraps
  101cb1:	e9 c2 fa ff ff       	jmp    101778 <alltraps>

00101cb6 <vector67>:
.globl vector67
vector67:
  pushl $0
  101cb6:	6a 00                	push   $0x0
  pushl $67
  101cb8:	6a 43                	push   $0x43
  jmp alltraps
  101cba:	e9 b9 fa ff ff       	jmp    101778 <alltraps>

00101cbf <vector68>:
.globl vector68
vector68:
  pushl $0
  101cbf:	6a 00                	push   $0x0
  pushl $68
  101cc1:	6a 44                	push   $0x44
  jmp alltraps
  101cc3:	e9 b0 fa ff ff       	jmp    101778 <alltraps>

00101cc8 <vector69>:
.globl vector69
vector69:
  pushl $0
  101cc8:	6a 00                	push   $0x0
  pushl $69
  101cca:	6a 45                	push   $0x45
  jmp alltraps
  101ccc:	e9 a7 fa ff ff       	jmp    101778 <alltraps>

00101cd1 <vector70>:
.globl vector70
vector70:
  pushl $0
  101cd1:	6a 00                	push   $0x0
  pushl $70
  101cd3:	6a 46                	push   $0x46
  jmp alltraps
  101cd5:	e9 9e fa ff ff       	jmp    101778 <alltraps>

00101cda <vector71>:
.globl vector71
vector71:
  pushl $0
  101cda:	6a 00                	push   $0x0
  pushl $71
  101cdc:	6a 47                	push   $0x47
  jmp alltraps
  101cde:	e9 95 fa ff ff       	jmp    101778 <alltraps>

00101ce3 <vector72>:
.globl vector72
vector72:
  pushl $0
  101ce3:	6a 00                	push   $0x0
  pushl $72
  101ce5:	6a 48                	push   $0x48
  jmp alltraps
  101ce7:	e9 8c fa ff ff       	jmp    101778 <alltraps>

00101cec <vector73>:
.globl vector73
vector73:
  pushl $0
  101cec:	6a 00                	push   $0x0
  pushl $73
  101cee:	6a 49                	push   $0x49
  jmp alltraps
  101cf0:	e9 83 fa ff ff       	jmp    101778 <alltraps>

00101cf5 <vector74>:
.globl vector74
vector74:
  pushl $0
  101cf5:	6a 00                	push   $0x0
  pushl $74
  101cf7:	6a 4a                	push   $0x4a
  jmp alltraps
  101cf9:	e9 7a fa ff ff       	jmp    101778 <alltraps>

00101cfe <vector75>:
.globl vector75
vector75:
  pushl $0
  101cfe:	6a 00                	push   $0x0
  pushl $75
  101d00:	6a 4b                	push   $0x4b
  jmp alltraps
  101d02:	e9 71 fa ff ff       	jmp    101778 <alltraps>

00101d07 <vector76>:
.globl vector76
vector76:
  pushl $0
  101d07:	6a 00                	push   $0x0
  pushl $76
  101d09:	6a 4c                	push   $0x4c
  jmp alltraps
  101d0b:	e9 68 fa ff ff       	jmp    101778 <alltraps>

00101d10 <vector77>:
.globl vector77
vector77:
  pushl $0
  101d10:	6a 00                	push   $0x0
  pushl $77
  101d12:	6a 4d                	push   $0x4d
  jmp alltraps
  101d14:	e9 5f fa ff ff       	jmp    101778 <alltraps>

00101d19 <vector78>:
.globl vector78
vector78:
  pushl $0
  101d19:	6a 00                	push   $0x0
  pushl $78
  101d1b:	6a 4e                	push   $0x4e
  jmp alltraps
  101d1d:	e9 56 fa ff ff       	jmp    101778 <alltraps>

00101d22 <vector79>:
.globl vector79
vector79:
  pushl $0
  101d22:	6a 00                	push   $0x0
  pushl $79
  101d24:	6a 4f                	push   $0x4f
  jmp alltraps
  101d26:	e9 4d fa ff ff       	jmp    101778 <alltraps>

00101d2b <vector80>:
.globl vector80
vector80:
  pushl $0
  101d2b:	6a 00                	push   $0x0
  pushl $80
  101d2d:	6a 50                	push   $0x50
  jmp alltraps
  101d2f:	e9 44 fa ff ff       	jmp    101778 <alltraps>

00101d34 <vector81>:
.globl vector81
vector81:
  pushl $0
  101d34:	6a 00                	push   $0x0
  pushl $81
  101d36:	6a 51                	push   $0x51
  jmp alltraps
  101d38:	e9 3b fa ff ff       	jmp    101778 <alltraps>

00101d3d <vector82>:
.globl vector82
vector82:
  pushl $0
  101d3d:	6a 00                	push   $0x0
  pushl $82
  101d3f:	6a 52                	push   $0x52
  jmp alltraps
  101d41:	e9 32 fa ff ff       	jmp    101778 <alltraps>

00101d46 <vector83>:
.globl vector83
vector83:
  pushl $0
  101d46:	6a 00                	push   $0x0
  pushl $83
  101d48:	6a 53                	push   $0x53
  jmp alltraps
  101d4a:	e9 29 fa ff ff       	jmp    101778 <alltraps>

00101d4f <vector84>:
.globl vector84
vector84:
  pushl $0
  101d4f:	6a 00                	push   $0x0
  pushl $84
  101d51:	6a 54                	push   $0x54
  jmp alltraps
  101d53:	e9 20 fa ff ff       	jmp    101778 <alltraps>

00101d58 <vector85>:
.globl vector85
vector85:
  pushl $0
  101d58:	6a 00                	push   $0x0
  pushl $85
  101d5a:	6a 55                	push   $0x55
  jmp alltraps
  101d5c:	e9 17 fa ff ff       	jmp    101778 <alltraps>

00101d61 <vector86>:
.globl vector86
vector86:
  pushl $0
  101d61:	6a 00                	push   $0x0
  pushl $86
  101d63:	6a 56                	push   $0x56
  jmp alltraps
  101d65:	e9 0e fa ff ff       	jmp    101778 <alltraps>

00101d6a <vector87>:
.globl vector87
vector87:
  pushl $0
  101d6a:	6a 00                	push   $0x0
  pushl $87
  101d6c:	6a 57                	push   $0x57
  jmp alltraps
  101d6e:	e9 05 fa ff ff       	jmp    101778 <alltraps>

00101d73 <vector88>:
.globl vector88
vector88:
  pushl $0
  101d73:	6a 00                	push   $0x0
  pushl $88
  101d75:	6a 58                	push   $0x58
  jmp alltraps
  101d77:	e9 fc f9 ff ff       	jmp    101778 <alltraps>

00101d7c <vector89>:
.globl vector89
vector89:
  pushl $0
  101d7c:	6a 00                	push   $0x0
  pushl $89
  101d7e:	6a 59                	push   $0x59
  jmp alltraps
  101d80:	e9 f3 f9 ff ff       	jmp    101778 <alltraps>

00101d85 <vector90>:
.globl vector90
vector90:
  pushl $0
  101d85:	6a 00                	push   $0x0
  pushl $90
  101d87:	6a 5a                	push   $0x5a
  jmp alltraps
  101d89:	e9 ea f9 ff ff       	jmp    101778 <alltraps>

00101d8e <vector91>:
.globl vector91
vector91:
  pushl $0
  101d8e:	6a 00                	push   $0x0
  pushl $91
  101d90:	6a 5b                	push   $0x5b
  jmp alltraps
  101d92:	e9 e1 f9 ff ff       	jmp    101778 <alltraps>

00101d97 <vector92>:
.globl vector92
vector92:
  pushl $0
  101d97:	6a 00                	push   $0x0
  pushl $92
  101d99:	6a 5c                	push   $0x5c
  jmp alltraps
  101d9b:	e9 d8 f9 ff ff       	jmp    101778 <alltraps>

00101da0 <vector93>:
.globl vector93
vector93:
  pushl $0
  101da0:	6a 00                	push   $0x0
  pushl $93
  101da2:	6a 5d                	push   $0x5d
  jmp alltraps
  101da4:	e9 cf f9 ff ff       	jmp    101778 <alltraps>

00101da9 <vector94>:
.globl vector94
vector94:
  pushl $0
  101da9:	6a 00                	push   $0x0
  pushl $94
  101dab:	6a 5e                	push   $0x5e
  jmp alltraps
  101dad:	e9 c6 f9 ff ff       	jmp    101778 <alltraps>

00101db2 <vector95>:
.globl vector95
vector95:
  pushl $0
  101db2:	6a 00                	push   $0x0
  pushl $95
  101db4:	6a 5f                	push   $0x5f
  jmp alltraps
  101db6:	e9 bd f9 ff ff       	jmp    101778 <alltraps>

00101dbb <vector96>:
.globl vector96
vector96:
  pushl $0
  101dbb:	6a 00                	push   $0x0
  pushl $96
  101dbd:	6a 60                	push   $0x60
  jmp alltraps
  101dbf:	e9 b4 f9 ff ff       	jmp    101778 <alltraps>

00101dc4 <vector97>:
.globl vector97
vector97:
  pushl $0
  101dc4:	6a 00                	push   $0x0
  pushl $97
  101dc6:	6a 61                	push   $0x61
  jmp alltraps
  101dc8:	e9 ab f9 ff ff       	jmp    101778 <alltraps>

00101dcd <vector98>:
.globl vector98
vector98:
  pushl $0
  101dcd:	6a 00                	push   $0x0
  pushl $98
  101dcf:	6a 62                	push   $0x62
  jmp alltraps
  101dd1:	e9 a2 f9 ff ff       	jmp    101778 <alltraps>

00101dd6 <vector99>:
.globl vector99
vector99:
  pushl $0
  101dd6:	6a 00                	push   $0x0
  pushl $99
  101dd8:	6a 63                	push   $0x63
  jmp alltraps
  101dda:	e9 99 f9 ff ff       	jmp    101778 <alltraps>

00101ddf <vector100>:
.globl vector100
vector100:
  pushl $0
  101ddf:	6a 00                	push   $0x0
  pushl $100
  101de1:	6a 64                	push   $0x64
  jmp alltraps
  101de3:	e9 90 f9 ff ff       	jmp    101778 <alltraps>

00101de8 <vector101>:
.globl vector101
vector101:
  pushl $0
  101de8:	6a 00                	push   $0x0
  pushl $101
  101dea:	6a 65                	push   $0x65
  jmp alltraps
  101dec:	e9 87 f9 ff ff       	jmp    101778 <alltraps>

00101df1 <vector102>:
.globl vector102
vector102:
  pushl $0
  101df1:	6a 00                	push   $0x0
  pushl $102
  101df3:	6a 66                	push   $0x66
  jmp alltraps
  101df5:	e9 7e f9 ff ff       	jmp    101778 <alltraps>

00101dfa <vector103>:
.globl vector103
vector103:
  pushl $0
  101dfa:	6a 00                	push   $0x0
  pushl $103
  101dfc:	6a 67                	push   $0x67
  jmp alltraps
  101dfe:	e9 75 f9 ff ff       	jmp    101778 <alltraps>

00101e03 <vector104>:
.globl vector104
vector104:
  pushl $0
  101e03:	6a 00                	push   $0x0
  pushl $104
  101e05:	6a 68                	push   $0x68
  jmp alltraps
  101e07:	e9 6c f9 ff ff       	jmp    101778 <alltraps>

00101e0c <vector105>:
.globl vector105
vector105:
  pushl $0
  101e0c:	6a 00                	push   $0x0
  pushl $105
  101e0e:	6a 69                	push   $0x69
  jmp alltraps
  101e10:	e9 63 f9 ff ff       	jmp    101778 <alltraps>

00101e15 <vector106>:
.globl vector106
vector106:
  pushl $0
  101e15:	6a 00                	push   $0x0
  pushl $106
  101e17:	6a 6a                	push   $0x6a
  jmp alltraps
  101e19:	e9 5a f9 ff ff       	jmp    101778 <alltraps>

00101e1e <vector107>:
.globl vector107
vector107:
  pushl $0
  101e1e:	6a 00                	push   $0x0
  pushl $107
  101e20:	6a 6b                	push   $0x6b
  jmp alltraps
  101e22:	e9 51 f9 ff ff       	jmp    101778 <alltraps>

00101e27 <vector108>:
.globl vector108
vector108:
  pushl $0
  101e27:	6a 00                	push   $0x0
  pushl $108
  101e29:	6a 6c                	push   $0x6c
  jmp alltraps
  101e2b:	e9 48 f9 ff ff       	jmp    101778 <alltraps>

00101e30 <vector109>:
.globl vector109
vector109:
  pushl $0
  101e30:	6a 00                	push   $0x0
  pushl $109
  101e32:	6a 6d                	push   $0x6d
  jmp alltraps
  101e34:	e9 3f f9 ff ff       	jmp    101778 <alltraps>

00101e39 <vector110>:
.globl vector110
vector110:
  pushl $0
  101e39:	6a 00                	push   $0x0
  pushl $110
  101e3b:	6a 6e                	push   $0x6e
  jmp alltraps
  101e3d:	e9 36 f9 ff ff       	jmp    101778 <alltraps>

00101e42 <vector111>:
.globl vector111
vector111:
  pushl $0
  101e42:	6a 00                	push   $0x0
  pushl $111
  101e44:	6a 6f                	push   $0x6f
  jmp alltraps
  101e46:	e9 2d f9 ff ff       	jmp    101778 <alltraps>

00101e4b <vector112>:
.globl vector112
vector112:
  pushl $0
  101e4b:	6a 00                	push   $0x0
  pushl $112
  101e4d:	6a 70                	push   $0x70
  jmp alltraps
  101e4f:	e9 24 f9 ff ff       	jmp    101778 <alltraps>

00101e54 <vector113>:
.globl vector113
vector113:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $113
  101e56:	6a 71                	push   $0x71
  jmp alltraps
  101e58:	e9 1b f9 ff ff       	jmp    101778 <alltraps>

00101e5d <vector114>:
.globl vector114
vector114:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $114
  101e5f:	6a 72                	push   $0x72
  jmp alltraps
  101e61:	e9 12 f9 ff ff       	jmp    101778 <alltraps>

00101e66 <vector115>:
.globl vector115
vector115:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $115
  101e68:	6a 73                	push   $0x73
  jmp alltraps
  101e6a:	e9 09 f9 ff ff       	jmp    101778 <alltraps>

00101e6f <vector116>:
.globl vector116
vector116:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $116
  101e71:	6a 74                	push   $0x74
  jmp alltraps
  101e73:	e9 00 f9 ff ff       	jmp    101778 <alltraps>

00101e78 <vector117>:
.globl vector117
vector117:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $117
  101e7a:	6a 75                	push   $0x75
  jmp alltraps
  101e7c:	e9 f7 f8 ff ff       	jmp    101778 <alltraps>

00101e81 <vector118>:
.globl vector118
vector118:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $118
  101e83:	6a 76                	push   $0x76
  jmp alltraps
  101e85:	e9 ee f8 ff ff       	jmp    101778 <alltraps>

00101e8a <vector119>:
.globl vector119
vector119:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $119
  101e8c:	6a 77                	push   $0x77
  jmp alltraps
  101e8e:	e9 e5 f8 ff ff       	jmp    101778 <alltraps>

00101e93 <vector120>:
.globl vector120
vector120:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $120
  101e95:	6a 78                	push   $0x78
  jmp alltraps
  101e97:	e9 dc f8 ff ff       	jmp    101778 <alltraps>

00101e9c <vector121>:
.globl vector121
vector121:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $121
  101e9e:	6a 79                	push   $0x79
  jmp alltraps
  101ea0:	e9 d3 f8 ff ff       	jmp    101778 <alltraps>

00101ea5 <vector122>:
.globl vector122
vector122:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $122
  101ea7:	6a 7a                	push   $0x7a
  jmp alltraps
  101ea9:	e9 ca f8 ff ff       	jmp    101778 <alltraps>

00101eae <vector123>:
.globl vector123
vector123:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $123
  101eb0:	6a 7b                	push   $0x7b
  jmp alltraps
  101eb2:	e9 c1 f8 ff ff       	jmp    101778 <alltraps>

00101eb7 <vector124>:
.globl vector124
vector124:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $124
  101eb9:	6a 7c                	push   $0x7c
  jmp alltraps
  101ebb:	e9 b8 f8 ff ff       	jmp    101778 <alltraps>

00101ec0 <vector125>:
.globl vector125
vector125:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $125
  101ec2:	6a 7d                	push   $0x7d
  jmp alltraps
  101ec4:	e9 af f8 ff ff       	jmp    101778 <alltraps>

00101ec9 <vector126>:
.globl vector126
vector126:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $126
  101ecb:	6a 7e                	push   $0x7e
  jmp alltraps
  101ecd:	e9 a6 f8 ff ff       	jmp    101778 <alltraps>

00101ed2 <vector127>:
.globl vector127
vector127:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $127
  101ed4:	6a 7f                	push   $0x7f
  jmp alltraps
  101ed6:	e9 9d f8 ff ff       	jmp    101778 <alltraps>

00101edb <vector128>:
.globl vector128
vector128:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $128
  101edd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  101ee2:	e9 91 f8 ff ff       	jmp    101778 <alltraps>

00101ee7 <vector129>:
.globl vector129
vector129:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $129
  101ee9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  101eee:	e9 85 f8 ff ff       	jmp    101778 <alltraps>

00101ef3 <vector130>:
.globl vector130
vector130:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $130
  101ef5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  101efa:	e9 79 f8 ff ff       	jmp    101778 <alltraps>

00101eff <vector131>:
.globl vector131
vector131:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $131
  101f01:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  101f06:	e9 6d f8 ff ff       	jmp    101778 <alltraps>

00101f0b <vector132>:
.globl vector132
vector132:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $132
  101f0d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  101f12:	e9 61 f8 ff ff       	jmp    101778 <alltraps>

00101f17 <vector133>:
.globl vector133
vector133:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $133
  101f19:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  101f1e:	e9 55 f8 ff ff       	jmp    101778 <alltraps>

00101f23 <vector134>:
.globl vector134
vector134:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $134
  101f25:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  101f2a:	e9 49 f8 ff ff       	jmp    101778 <alltraps>

00101f2f <vector135>:
.globl vector135
vector135:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $135
  101f31:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  101f36:	e9 3d f8 ff ff       	jmp    101778 <alltraps>

00101f3b <vector136>:
.globl vector136
vector136:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $136
  101f3d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  101f42:	e9 31 f8 ff ff       	jmp    101778 <alltraps>

00101f47 <vector137>:
.globl vector137
vector137:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $137
  101f49:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  101f4e:	e9 25 f8 ff ff       	jmp    101778 <alltraps>

00101f53 <vector138>:
.globl vector138
vector138:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $138
  101f55:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  101f5a:	e9 19 f8 ff ff       	jmp    101778 <alltraps>

00101f5f <vector139>:
.globl vector139
vector139:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $139
  101f61:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  101f66:	e9 0d f8 ff ff       	jmp    101778 <alltraps>

00101f6b <vector140>:
.globl vector140
vector140:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $140
  101f6d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  101f72:	e9 01 f8 ff ff       	jmp    101778 <alltraps>

00101f77 <vector141>:
.globl vector141
vector141:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $141
  101f79:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  101f7e:	e9 f5 f7 ff ff       	jmp    101778 <alltraps>

00101f83 <vector142>:
.globl vector142
vector142:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $142
  101f85:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  101f8a:	e9 e9 f7 ff ff       	jmp    101778 <alltraps>

00101f8f <vector143>:
.globl vector143
vector143:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $143
  101f91:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  101f96:	e9 dd f7 ff ff       	jmp    101778 <alltraps>

00101f9b <vector144>:
.globl vector144
vector144:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $144
  101f9d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  101fa2:	e9 d1 f7 ff ff       	jmp    101778 <alltraps>

00101fa7 <vector145>:
.globl vector145
vector145:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $145
  101fa9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  101fae:	e9 c5 f7 ff ff       	jmp    101778 <alltraps>

00101fb3 <vector146>:
.globl vector146
vector146:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $146
  101fb5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  101fba:	e9 b9 f7 ff ff       	jmp    101778 <alltraps>

00101fbf <vector147>:
.globl vector147
vector147:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $147
  101fc1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  101fc6:	e9 ad f7 ff ff       	jmp    101778 <alltraps>

00101fcb <vector148>:
.globl vector148
vector148:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $148
  101fcd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  101fd2:	e9 a1 f7 ff ff       	jmp    101778 <alltraps>

00101fd7 <vector149>:
.globl vector149
vector149:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $149
  101fd9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  101fde:	e9 95 f7 ff ff       	jmp    101778 <alltraps>

00101fe3 <vector150>:
.globl vector150
vector150:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $150
  101fe5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  101fea:	e9 89 f7 ff ff       	jmp    101778 <alltraps>

00101fef <vector151>:
.globl vector151
vector151:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $151
  101ff1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  101ff6:	e9 7d f7 ff ff       	jmp    101778 <alltraps>

00101ffb <vector152>:
.globl vector152
vector152:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $152
  101ffd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  102002:	e9 71 f7 ff ff       	jmp    101778 <alltraps>

00102007 <vector153>:
.globl vector153
vector153:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $153
  102009:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  10200e:	e9 65 f7 ff ff       	jmp    101778 <alltraps>

00102013 <vector154>:
.globl vector154
vector154:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $154
  102015:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  10201a:	e9 59 f7 ff ff       	jmp    101778 <alltraps>

0010201f <vector155>:
.globl vector155
vector155:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $155
  102021:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  102026:	e9 4d f7 ff ff       	jmp    101778 <alltraps>

0010202b <vector156>:
.globl vector156
vector156:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $156
  10202d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  102032:	e9 41 f7 ff ff       	jmp    101778 <alltraps>

00102037 <vector157>:
.globl vector157
vector157:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $157
  102039:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  10203e:	e9 35 f7 ff ff       	jmp    101778 <alltraps>

00102043 <vector158>:
.globl vector158
vector158:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $158
  102045:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  10204a:	e9 29 f7 ff ff       	jmp    101778 <alltraps>

0010204f <vector159>:
.globl vector159
vector159:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $159
  102051:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  102056:	e9 1d f7 ff ff       	jmp    101778 <alltraps>

0010205b <vector160>:
.globl vector160
vector160:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $160
  10205d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  102062:	e9 11 f7 ff ff       	jmp    101778 <alltraps>

00102067 <vector161>:
.globl vector161
vector161:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $161
  102069:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  10206e:	e9 05 f7 ff ff       	jmp    101778 <alltraps>

00102073 <vector162>:
.globl vector162
vector162:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $162
  102075:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  10207a:	e9 f9 f6 ff ff       	jmp    101778 <alltraps>

0010207f <vector163>:
.globl vector163
vector163:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $163
  102081:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  102086:	e9 ed f6 ff ff       	jmp    101778 <alltraps>

0010208b <vector164>:
.globl vector164
vector164:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $164
  10208d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  102092:	e9 e1 f6 ff ff       	jmp    101778 <alltraps>

00102097 <vector165>:
.globl vector165
vector165:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $165
  102099:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  10209e:	e9 d5 f6 ff ff       	jmp    101778 <alltraps>

001020a3 <vector166>:
.globl vector166
vector166:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $166
  1020a5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  1020aa:	e9 c9 f6 ff ff       	jmp    101778 <alltraps>

001020af <vector167>:
.globl vector167
vector167:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $167
  1020b1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  1020b6:	e9 bd f6 ff ff       	jmp    101778 <alltraps>

001020bb <vector168>:
.globl vector168
vector168:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $168
  1020bd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  1020c2:	e9 b1 f6 ff ff       	jmp    101778 <alltraps>

001020c7 <vector169>:
.globl vector169
vector169:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $169
  1020c9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  1020ce:	e9 a5 f6 ff ff       	jmp    101778 <alltraps>

001020d3 <vector170>:
.globl vector170
vector170:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $170
  1020d5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  1020da:	e9 99 f6 ff ff       	jmp    101778 <alltraps>

001020df <vector171>:
.globl vector171
vector171:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $171
  1020e1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  1020e6:	e9 8d f6 ff ff       	jmp    101778 <alltraps>

001020eb <vector172>:
.globl vector172
vector172:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $172
  1020ed:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  1020f2:	e9 81 f6 ff ff       	jmp    101778 <alltraps>

001020f7 <vector173>:
.globl vector173
vector173:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $173
  1020f9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  1020fe:	e9 75 f6 ff ff       	jmp    101778 <alltraps>

00102103 <vector174>:
.globl vector174
vector174:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $174
  102105:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  10210a:	e9 69 f6 ff ff       	jmp    101778 <alltraps>

0010210f <vector175>:
.globl vector175
vector175:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $175
  102111:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  102116:	e9 5d f6 ff ff       	jmp    101778 <alltraps>

0010211b <vector176>:
.globl vector176
vector176:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $176
  10211d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  102122:	e9 51 f6 ff ff       	jmp    101778 <alltraps>

00102127 <vector177>:
.globl vector177
vector177:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $177
  102129:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  10212e:	e9 45 f6 ff ff       	jmp    101778 <alltraps>

00102133 <vector178>:
.globl vector178
vector178:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $178
  102135:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  10213a:	e9 39 f6 ff ff       	jmp    101778 <alltraps>

0010213f <vector179>:
.globl vector179
vector179:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $179
  102141:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  102146:	e9 2d f6 ff ff       	jmp    101778 <alltraps>

0010214b <vector180>:
.globl vector180
vector180:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $180
  10214d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  102152:	e9 21 f6 ff ff       	jmp    101778 <alltraps>

00102157 <vector181>:
.globl vector181
vector181:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $181
  102159:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  10215e:	e9 15 f6 ff ff       	jmp    101778 <alltraps>

00102163 <vector182>:
.globl vector182
vector182:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $182
  102165:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  10216a:	e9 09 f6 ff ff       	jmp    101778 <alltraps>

0010216f <vector183>:
.globl vector183
vector183:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $183
  102171:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  102176:	e9 fd f5 ff ff       	jmp    101778 <alltraps>

0010217b <vector184>:
.globl vector184
vector184:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $184
  10217d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  102182:	e9 f1 f5 ff ff       	jmp    101778 <alltraps>

00102187 <vector185>:
.globl vector185
vector185:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $185
  102189:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  10218e:	e9 e5 f5 ff ff       	jmp    101778 <alltraps>

00102193 <vector186>:
.globl vector186
vector186:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $186
  102195:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  10219a:	e9 d9 f5 ff ff       	jmp    101778 <alltraps>

0010219f <vector187>:
.globl vector187
vector187:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $187
  1021a1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  1021a6:	e9 cd f5 ff ff       	jmp    101778 <alltraps>

001021ab <vector188>:
.globl vector188
vector188:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $188
  1021ad:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  1021b2:	e9 c1 f5 ff ff       	jmp    101778 <alltraps>

001021b7 <vector189>:
.globl vector189
vector189:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $189
  1021b9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  1021be:	e9 b5 f5 ff ff       	jmp    101778 <alltraps>

001021c3 <vector190>:
.globl vector190
vector190:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $190
  1021c5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  1021ca:	e9 a9 f5 ff ff       	jmp    101778 <alltraps>

001021cf <vector191>:
.globl vector191
vector191:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $191
  1021d1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  1021d6:	e9 9d f5 ff ff       	jmp    101778 <alltraps>

001021db <vector192>:
.globl vector192
vector192:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $192
  1021dd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  1021e2:	e9 91 f5 ff ff       	jmp    101778 <alltraps>

001021e7 <vector193>:
.globl vector193
vector193:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $193
  1021e9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  1021ee:	e9 85 f5 ff ff       	jmp    101778 <alltraps>

001021f3 <vector194>:
.globl vector194
vector194:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $194
  1021f5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  1021fa:	e9 79 f5 ff ff       	jmp    101778 <alltraps>

001021ff <vector195>:
.globl vector195
vector195:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $195
  102201:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  102206:	e9 6d f5 ff ff       	jmp    101778 <alltraps>

0010220b <vector196>:
.globl vector196
vector196:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $196
  10220d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  102212:	e9 61 f5 ff ff       	jmp    101778 <alltraps>

00102217 <vector197>:
.globl vector197
vector197:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $197
  102219:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  10221e:	e9 55 f5 ff ff       	jmp    101778 <alltraps>

00102223 <vector198>:
.globl vector198
vector198:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $198
  102225:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  10222a:	e9 49 f5 ff ff       	jmp    101778 <alltraps>

0010222f <vector199>:
.globl vector199
vector199:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $199
  102231:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  102236:	e9 3d f5 ff ff       	jmp    101778 <alltraps>

0010223b <vector200>:
.globl vector200
vector200:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $200
  10223d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  102242:	e9 31 f5 ff ff       	jmp    101778 <alltraps>

00102247 <vector201>:
.globl vector201
vector201:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $201
  102249:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  10224e:	e9 25 f5 ff ff       	jmp    101778 <alltraps>

00102253 <vector202>:
.globl vector202
vector202:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $202
  102255:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  10225a:	e9 19 f5 ff ff       	jmp    101778 <alltraps>

0010225f <vector203>:
.globl vector203
vector203:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $203
  102261:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  102266:	e9 0d f5 ff ff       	jmp    101778 <alltraps>

0010226b <vector204>:
.globl vector204
vector204:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $204
  10226d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  102272:	e9 01 f5 ff ff       	jmp    101778 <alltraps>

00102277 <vector205>:
.globl vector205
vector205:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $205
  102279:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  10227e:	e9 f5 f4 ff ff       	jmp    101778 <alltraps>

00102283 <vector206>:
.globl vector206
vector206:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $206
  102285:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  10228a:	e9 e9 f4 ff ff       	jmp    101778 <alltraps>

0010228f <vector207>:
.globl vector207
vector207:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $207
  102291:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  102296:	e9 dd f4 ff ff       	jmp    101778 <alltraps>

0010229b <vector208>:
.globl vector208
vector208:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $208
  10229d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  1022a2:	e9 d1 f4 ff ff       	jmp    101778 <alltraps>

001022a7 <vector209>:
.globl vector209
vector209:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $209
  1022a9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  1022ae:	e9 c5 f4 ff ff       	jmp    101778 <alltraps>

001022b3 <vector210>:
.globl vector210
vector210:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $210
  1022b5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  1022ba:	e9 b9 f4 ff ff       	jmp    101778 <alltraps>

001022bf <vector211>:
.globl vector211
vector211:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $211
  1022c1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  1022c6:	e9 ad f4 ff ff       	jmp    101778 <alltraps>

001022cb <vector212>:
.globl vector212
vector212:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $212
  1022cd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  1022d2:	e9 a1 f4 ff ff       	jmp    101778 <alltraps>

001022d7 <vector213>:
.globl vector213
vector213:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $213
  1022d9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  1022de:	e9 95 f4 ff ff       	jmp    101778 <alltraps>

001022e3 <vector214>:
.globl vector214
vector214:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $214
  1022e5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  1022ea:	e9 89 f4 ff ff       	jmp    101778 <alltraps>

001022ef <vector215>:
.globl vector215
vector215:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $215
  1022f1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  1022f6:	e9 7d f4 ff ff       	jmp    101778 <alltraps>

001022fb <vector216>:
.globl vector216
vector216:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $216
  1022fd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  102302:	e9 71 f4 ff ff       	jmp    101778 <alltraps>

00102307 <vector217>:
.globl vector217
vector217:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $217
  102309:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  10230e:	e9 65 f4 ff ff       	jmp    101778 <alltraps>

00102313 <vector218>:
.globl vector218
vector218:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $218
  102315:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  10231a:	e9 59 f4 ff ff       	jmp    101778 <alltraps>

0010231f <vector219>:
.globl vector219
vector219:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $219
  102321:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  102326:	e9 4d f4 ff ff       	jmp    101778 <alltraps>

0010232b <vector220>:
.globl vector220
vector220:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $220
  10232d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  102332:	e9 41 f4 ff ff       	jmp    101778 <alltraps>

00102337 <vector221>:
.globl vector221
vector221:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $221
  102339:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  10233e:	e9 35 f4 ff ff       	jmp    101778 <alltraps>

00102343 <vector222>:
.globl vector222
vector222:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $222
  102345:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  10234a:	e9 29 f4 ff ff       	jmp    101778 <alltraps>

0010234f <vector223>:
.globl vector223
vector223:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $223
  102351:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  102356:	e9 1d f4 ff ff       	jmp    101778 <alltraps>

0010235b <vector224>:
.globl vector224
vector224:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $224
  10235d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  102362:	e9 11 f4 ff ff       	jmp    101778 <alltraps>

00102367 <vector225>:
.globl vector225
vector225:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $225
  102369:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  10236e:	e9 05 f4 ff ff       	jmp    101778 <alltraps>

00102373 <vector226>:
.globl vector226
vector226:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $226
  102375:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  10237a:	e9 f9 f3 ff ff       	jmp    101778 <alltraps>

0010237f <vector227>:
.globl vector227
vector227:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $227
  102381:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  102386:	e9 ed f3 ff ff       	jmp    101778 <alltraps>

0010238b <vector228>:
.globl vector228
vector228:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $228
  10238d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  102392:	e9 e1 f3 ff ff       	jmp    101778 <alltraps>

00102397 <vector229>:
.globl vector229
vector229:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $229
  102399:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  10239e:	e9 d5 f3 ff ff       	jmp    101778 <alltraps>

001023a3 <vector230>:
.globl vector230
vector230:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $230
  1023a5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  1023aa:	e9 c9 f3 ff ff       	jmp    101778 <alltraps>

001023af <vector231>:
.globl vector231
vector231:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $231
  1023b1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  1023b6:	e9 bd f3 ff ff       	jmp    101778 <alltraps>

001023bb <vector232>:
.globl vector232
vector232:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $232
  1023bd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  1023c2:	e9 b1 f3 ff ff       	jmp    101778 <alltraps>

001023c7 <vector233>:
.globl vector233
vector233:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $233
  1023c9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  1023ce:	e9 a5 f3 ff ff       	jmp    101778 <alltraps>

001023d3 <vector234>:
.globl vector234
vector234:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $234
  1023d5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  1023da:	e9 99 f3 ff ff       	jmp    101778 <alltraps>

001023df <vector235>:
.globl vector235
vector235:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $235
  1023e1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  1023e6:	e9 8d f3 ff ff       	jmp    101778 <alltraps>

001023eb <vector236>:
.globl vector236
vector236:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $236
  1023ed:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  1023f2:	e9 81 f3 ff ff       	jmp    101778 <alltraps>

001023f7 <vector237>:
.globl vector237
vector237:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $237
  1023f9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  1023fe:	e9 75 f3 ff ff       	jmp    101778 <alltraps>

00102403 <vector238>:
.globl vector238
vector238:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $238
  102405:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  10240a:	e9 69 f3 ff ff       	jmp    101778 <alltraps>

0010240f <vector239>:
.globl vector239
vector239:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $239
  102411:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  102416:	e9 5d f3 ff ff       	jmp    101778 <alltraps>

0010241b <vector240>:
.globl vector240
vector240:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $240
  10241d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  102422:	e9 51 f3 ff ff       	jmp    101778 <alltraps>

00102427 <vector241>:
.globl vector241
vector241:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $241
  102429:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  10242e:	e9 45 f3 ff ff       	jmp    101778 <alltraps>

00102433 <vector242>:
.globl vector242
vector242:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $242
  102435:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  10243a:	e9 39 f3 ff ff       	jmp    101778 <alltraps>

0010243f <vector243>:
.globl vector243
vector243:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $243
  102441:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  102446:	e9 2d f3 ff ff       	jmp    101778 <alltraps>

0010244b <vector244>:
.globl vector244
vector244:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $244
  10244d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  102452:	e9 21 f3 ff ff       	jmp    101778 <alltraps>

00102457 <vector245>:
.globl vector245
vector245:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $245
  102459:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  10245e:	e9 15 f3 ff ff       	jmp    101778 <alltraps>

00102463 <vector246>:
.globl vector246
vector246:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $246
  102465:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  10246a:	e9 09 f3 ff ff       	jmp    101778 <alltraps>

0010246f <vector247>:
.globl vector247
vector247:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $247
  102471:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  102476:	e9 fd f2 ff ff       	jmp    101778 <alltraps>

0010247b <vector248>:
.globl vector248
vector248:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $248
  10247d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  102482:	e9 f1 f2 ff ff       	jmp    101778 <alltraps>

00102487 <vector249>:
.globl vector249
vector249:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $249
  102489:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  10248e:	e9 e5 f2 ff ff       	jmp    101778 <alltraps>

00102493 <vector250>:
.globl vector250
vector250:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $250
  102495:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  10249a:	e9 d9 f2 ff ff       	jmp    101778 <alltraps>

0010249f <vector251>:
.globl vector251
vector251:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $251
  1024a1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  1024a6:	e9 cd f2 ff ff       	jmp    101778 <alltraps>

001024ab <vector252>:
.globl vector252
vector252:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $252
  1024ad:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  1024b2:	e9 c1 f2 ff ff       	jmp    101778 <alltraps>

001024b7 <vector253>:
.globl vector253
vector253:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $253
  1024b9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  1024be:	e9 b5 f2 ff ff       	jmp    101778 <alltraps>

001024c3 <vector254>:
.globl vector254
vector254:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $254
  1024c5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  1024ca:	e9 a9 f2 ff ff       	jmp    101778 <alltraps>

001024cf <vector255>:
.globl vector255
vector255:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $255
  1024d1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  1024d6:	e9 9d f2 ff ff       	jmp    101778 <alltraps>

001024db <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
  1024db:	55                   	push   %ebp
  1024dc:	89 e5                	mov    %esp,%ebp
  1024de:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  1024e1:	c7 05 18 d0 10 00 08 	movl   $0x10d008,0x10d018
  1024e8:	d0 10 00 
  bcache.head.next = &bcache.head;
  1024eb:	c7 05 1c d0 10 00 08 	movl   $0x10d008,0x10d01c
  1024f2:	d0 10 00 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  1024f5:	c7 45 fc c0 90 10 00 	movl   $0x1090c0,-0x4(%ebp)
  1024fc:	eb 30                	jmp    10252e <binit+0x53>
    b->next = bcache.head.next;
  1024fe:	8b 15 1c d0 10 00    	mov    0x10d01c,%edx
  102504:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102507:	89 50 14             	mov    %edx,0x14(%eax)
    b->prev = &bcache.head;
  10250a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10250d:	c7 40 10 08 d0 10 00 	movl   $0x10d008,0x10(%eax)
    bcache.head.next->prev = b;
  102514:	a1 1c d0 10 00       	mov    0x10d01c,%eax
  102519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10251c:	89 50 10             	mov    %edx,0x10(%eax)
    bcache.head.next = b;
  10251f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102522:	a3 1c d0 10 00       	mov    %eax,0x10d01c
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  102527:	81 45 fc 1c 02 00 00 	addl   $0x21c,-0x4(%ebp)
  10252e:	b8 08 d0 10 00       	mov    $0x10d008,%eax
  102533:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  102536:	72 c6                	jb     1024fe <binit+0x23>
  }
}
  102538:	90                   	nop
  102539:	90                   	nop
  10253a:	c9                   	leave  
  10253b:	c3                   	ret    

0010253c <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  10253c:	55                   	push   %ebp
  10253d:	89 e5                	mov    %esp,%ebp
  10253f:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  102542:	a1 1c d0 10 00       	mov    0x10d01c,%eax
  102547:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10254a:	eb 33                	jmp    10257f <bget+0x43>
    if(b->dev == dev && b->blockno == blockno){
  10254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10254f:	8b 40 04             	mov    0x4(%eax),%eax
  102552:	39 45 08             	cmp    %eax,0x8(%ebp)
  102555:	75 1f                	jne    102576 <bget+0x3a>
  102557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10255a:	8b 40 08             	mov    0x8(%eax),%eax
  10255d:	39 45 0c             	cmp    %eax,0xc(%ebp)
  102560:	75 14                	jne    102576 <bget+0x3a>
      b->refcnt++;
  102562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102565:	8b 40 0c             	mov    0xc(%eax),%eax
  102568:	8d 50 01             	lea    0x1(%eax),%edx
  10256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10256e:	89 50 0c             	mov    %edx,0xc(%eax)
      return b;
  102571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102574:	eb 7b                	jmp    1025f1 <bget+0xb5>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  102576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102579:	8b 40 14             	mov    0x14(%eax),%eax
  10257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10257f:	81 7d f4 08 d0 10 00 	cmpl   $0x10d008,-0xc(%ebp)
  102586:	75 c4                	jne    10254c <bget+0x10>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  102588:	a1 18 d0 10 00       	mov    0x10d018,%eax
  10258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102590:	eb 49                	jmp    1025db <bget+0x9f>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
  102592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102595:	8b 40 0c             	mov    0xc(%eax),%eax
  102598:	85 c0                	test   %eax,%eax
  10259a:	75 36                	jne    1025d2 <bget+0x96>
  10259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10259f:	8b 00                	mov    (%eax),%eax
  1025a1:	83 e0 04             	and    $0x4,%eax
  1025a4:	85 c0                	test   %eax,%eax
  1025a6:	75 2a                	jne    1025d2 <bget+0x96>
      b->dev = dev;
  1025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1025ab:	8b 55 08             	mov    0x8(%ebp),%edx
  1025ae:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
  1025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1025b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1025b7:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
  1025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1025bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
  1025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1025c6:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
      return b;
  1025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1025d0:	eb 1f                	jmp    1025f1 <bget+0xb5>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  1025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1025d5:	8b 40 10             	mov    0x10(%eax),%eax
  1025d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1025db:	81 7d f4 08 d0 10 00 	cmpl   $0x10d008,-0xc(%ebp)
  1025e2:	75 ae                	jne    102592 <bget+0x56>
    }
  }
  panic("bget: no buffers");
  1025e4:	83 ec 0c             	sub    $0xc,%esp
  1025e7:	68 38 58 10 00       	push   $0x105838
  1025ec:	e8 bc dc ff ff       	call   1002ad <panic>
}
  1025f1:	c9                   	leave  
  1025f2:	c3                   	ret    

001025f3 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  1025f3:	55                   	push   %ebp
  1025f4:	89 e5                	mov    %esp,%ebp
  1025f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
  1025f9:	83 ec 08             	sub    $0x8,%esp
  1025fc:	ff 75 0c             	push   0xc(%ebp)
  1025ff:	ff 75 08             	push   0x8(%ebp)
  102602:	e8 35 ff ff ff       	call   10253c <bget>
  102607:	83 c4 10             	add    $0x10,%esp
  10260a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
  10260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102610:	8b 00                	mov    (%eax),%eax
  102612:	83 e0 02             	and    $0x2,%eax
  102615:	85 c0                	test   %eax,%eax
  102617:	75 0e                	jne    102627 <bread+0x34>
    iderw(b);
  102619:	83 ec 0c             	sub    $0xc,%esp
  10261c:	ff 75 f4             	push   -0xc(%ebp)
  10261f:	e8 17 04 00 00       	call   102a3b <iderw>
  102624:	83 c4 10             	add    $0x10,%esp
  }
  return b;
  102627:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10262a:	c9                   	leave  
  10262b:	c3                   	ret    

0010262c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  10262c:	55                   	push   %ebp
  10262d:	89 e5                	mov    %esp,%ebp
  10262f:	83 ec 08             	sub    $0x8,%esp
  b->flags |= B_DIRTY;
  102632:	8b 45 08             	mov    0x8(%ebp),%eax
  102635:	8b 00                	mov    (%eax),%eax
  102637:	83 c8 04             	or     $0x4,%eax
  10263a:	89 c2                	mov    %eax,%edx
  10263c:	8b 45 08             	mov    0x8(%ebp),%eax
  10263f:	89 10                	mov    %edx,(%eax)
  iderw(b);
  102641:	83 ec 0c             	sub    $0xc,%esp
  102644:	ff 75 08             	push   0x8(%ebp)
  102647:	e8 ef 03 00 00       	call   102a3b <iderw>
  10264c:	83 c4 10             	add    $0x10,%esp
}
  10264f:	90                   	nop
  102650:	c9                   	leave  
  102651:	c3                   	ret    

00102652 <brelse>:

// Release a buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  102652:	55                   	push   %ebp
  102653:	89 e5                	mov    %esp,%ebp
  b->refcnt--;
  102655:	8b 45 08             	mov    0x8(%ebp),%eax
  102658:	8b 40 0c             	mov    0xc(%eax),%eax
  10265b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10265e:	8b 45 08             	mov    0x8(%ebp),%eax
  102661:	89 50 0c             	mov    %edx,0xc(%eax)
  if (b->refcnt == 0) {
  102664:	8b 45 08             	mov    0x8(%ebp),%eax
  102667:	8b 40 0c             	mov    0xc(%eax),%eax
  10266a:	85 c0                	test   %eax,%eax
  10266c:	75 47                	jne    1026b5 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
  10266e:	8b 45 08             	mov    0x8(%ebp),%eax
  102671:	8b 40 14             	mov    0x14(%eax),%eax
  102674:	8b 55 08             	mov    0x8(%ebp),%edx
  102677:	8b 52 10             	mov    0x10(%edx),%edx
  10267a:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev->next = b->next;
  10267d:	8b 45 08             	mov    0x8(%ebp),%eax
  102680:	8b 40 10             	mov    0x10(%eax),%eax
  102683:	8b 55 08             	mov    0x8(%ebp),%edx
  102686:	8b 52 14             	mov    0x14(%edx),%edx
  102689:	89 50 14             	mov    %edx,0x14(%eax)
    b->next = bcache.head.next;
  10268c:	8b 15 1c d0 10 00    	mov    0x10d01c,%edx
  102692:	8b 45 08             	mov    0x8(%ebp),%eax
  102695:	89 50 14             	mov    %edx,0x14(%eax)
    b->prev = &bcache.head;
  102698:	8b 45 08             	mov    0x8(%ebp),%eax
  10269b:	c7 40 10 08 d0 10 00 	movl   $0x10d008,0x10(%eax)
    bcache.head.next->prev = b;
  1026a2:	a1 1c d0 10 00       	mov    0x10d01c,%eax
  1026a7:	8b 55 08             	mov    0x8(%ebp),%edx
  1026aa:	89 50 10             	mov    %edx,0x10(%eax)
    bcache.head.next = b;
  1026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1026b0:	a3 1c d0 10 00       	mov    %eax,0x10d01c
  }
  1026b5:	90                   	nop
  1026b6:	5d                   	pop    %ebp
  1026b7:	c3                   	ret    

001026b8 <inb>:
{
  1026b8:	55                   	push   %ebp
  1026b9:	89 e5                	mov    %esp,%ebp
  1026bb:	83 ec 14             	sub    $0x14,%esp
  1026be:	8b 45 08             	mov    0x8(%ebp),%eax
  1026c1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1026c5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1026c9:	89 c2                	mov    %eax,%edx
  1026cb:	ec                   	in     (%dx),%al
  1026cc:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  1026cf:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  1026d3:	c9                   	leave  
  1026d4:	c3                   	ret    

001026d5 <insl>:
{
  1026d5:	55                   	push   %ebp
  1026d6:	89 e5                	mov    %esp,%ebp
  1026d8:	57                   	push   %edi
  1026d9:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
  1026da:	8b 55 08             	mov    0x8(%ebp),%edx
  1026dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1026e0:	8b 45 10             	mov    0x10(%ebp),%eax
  1026e3:	89 cb                	mov    %ecx,%ebx
  1026e5:	89 df                	mov    %ebx,%edi
  1026e7:	89 c1                	mov    %eax,%ecx
  1026e9:	fc                   	cld    
  1026ea:	f3 6d                	rep insl (%dx),%es:(%edi)
  1026ec:	89 c8                	mov    %ecx,%eax
  1026ee:	89 fb                	mov    %edi,%ebx
  1026f0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1026f3:	89 45 10             	mov    %eax,0x10(%ebp)
}
  1026f6:	90                   	nop
  1026f7:	5b                   	pop    %ebx
  1026f8:	5f                   	pop    %edi
  1026f9:	5d                   	pop    %ebp
  1026fa:	c3                   	ret    

001026fb <outb>:
{
  1026fb:	55                   	push   %ebp
  1026fc:	89 e5                	mov    %esp,%ebp
  1026fe:	83 ec 08             	sub    $0x8,%esp
  102701:	8b 45 08             	mov    0x8(%ebp),%eax
  102704:	8b 55 0c             	mov    0xc(%ebp),%edx
  102707:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  10270b:	89 d0                	mov    %edx,%eax
  10270d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102710:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  102714:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  102718:	ee                   	out    %al,(%dx)
}
  102719:	90                   	nop
  10271a:	c9                   	leave  
  10271b:	c3                   	ret    

0010271c <outsl>:
{
  10271c:	55                   	push   %ebp
  10271d:	89 e5                	mov    %esp,%ebp
  10271f:	56                   	push   %esi
  102720:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
  102721:	8b 55 08             	mov    0x8(%ebp),%edx
  102724:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102727:	8b 45 10             	mov    0x10(%ebp),%eax
  10272a:	89 cb                	mov    %ecx,%ebx
  10272c:	89 de                	mov    %ebx,%esi
  10272e:	89 c1                	mov    %eax,%ecx
  102730:	fc                   	cld    
  102731:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  102733:	89 c8                	mov    %ecx,%eax
  102735:	89 f3                	mov    %esi,%ebx
  102737:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  10273a:	89 45 10             	mov    %eax,0x10(%ebp)
}
  10273d:	90                   	nop
  10273e:	5b                   	pop    %ebx
  10273f:	5e                   	pop    %esi
  102740:	5d                   	pop    %ebp
  102741:	c3                   	ret    

00102742 <noop>:

static inline void
noop(void)
{
  102742:	55                   	push   %ebp
  102743:	89 e5                	mov    %esp,%ebp
  asm volatile("nop");
  102745:	90                   	nop
}
  102746:	90                   	nop
  102747:	5d                   	pop    %ebp
  102748:	c3                   	ret    

00102749 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
  102749:	55                   	push   %ebp
  10274a:	89 e5                	mov    %esp,%ebp
  10274c:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY);
  10274f:	90                   	nop
  102750:	68 f7 01 00 00       	push   $0x1f7
  102755:	e8 5e ff ff ff       	call   1026b8 <inb>
  10275a:	83 c4 04             	add    $0x4,%esp
  10275d:	0f b6 c0             	movzbl %al,%eax
  102760:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102763:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102766:	25 c0 00 00 00       	and    $0xc0,%eax
  10276b:	83 f8 40             	cmp    $0x40,%eax
  10276e:	75 e0                	jne    102750 <idewait+0x7>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
  102770:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102774:	74 11                	je     102787 <idewait+0x3e>
  102776:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102779:	83 e0 21             	and    $0x21,%eax
  10277c:	85 c0                	test   %eax,%eax
  10277e:	74 07                	je     102787 <idewait+0x3e>
    return -1;
  102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102785:	eb 05                	jmp    10278c <idewait+0x43>
  return 0;
  102787:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10278c:	c9                   	leave  
  10278d:	c3                   	ret    

0010278e <ideinit>:

void
ideinit(void)
{
  10278e:	55                   	push   %ebp
  10278f:	89 e5                	mov    %esp,%ebp
  102791:	83 ec 18             	sub    $0x18,%esp
  int i;

  // initlock(&idelock, "ide");
  ioapicenable(IRQ_IDE, ncpu - 1);
  102794:	a1 60 6a 10 00       	mov    0x106a60,%eax
  102799:	83 e8 01             	sub    $0x1,%eax
  10279c:	83 ec 08             	sub    $0x8,%esp
  10279f:	50                   	push   %eax
  1027a0:	6a 0e                	push   $0xe
  1027a2:	e8 ff de ff ff       	call   1006a6 <ioapicenable>
  1027a7:	83 c4 10             	add    $0x10,%esp
  idewait(0);
  1027aa:	83 ec 0c             	sub    $0xc,%esp
  1027ad:	6a 00                	push   $0x0
  1027af:	e8 95 ff ff ff       	call   102749 <idewait>
  1027b4:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  1027b7:	83 ec 08             	sub    $0x8,%esp
  1027ba:	68 f0 00 00 00       	push   $0xf0
  1027bf:	68 f6 01 00 00       	push   $0x1f6
  1027c4:	e8 32 ff ff ff       	call   1026fb <outb>
  1027c9:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
  1027cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1027d3:	eb 24                	jmp    1027f9 <ideinit+0x6b>
    if(inb(0x1f7) != 0){
  1027d5:	83 ec 0c             	sub    $0xc,%esp
  1027d8:	68 f7 01 00 00       	push   $0x1f7
  1027dd:	e8 d6 fe ff ff       	call   1026b8 <inb>
  1027e2:	83 c4 10             	add    $0x10,%esp
  1027e5:	84 c0                	test   %al,%al
  1027e7:	74 0c                	je     1027f5 <ideinit+0x67>
      havedisk1 = 1;
  1027e9:	c7 05 28 d2 10 00 01 	movl   $0x1,0x10d228
  1027f0:	00 00 00 
      break;
  1027f3:	eb 0d                	jmp    102802 <ideinit+0x74>
  for(i=0; i<1000; i++){
  1027f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1027f9:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  102800:	7e d3                	jle    1027d5 <ideinit+0x47>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
  102802:	83 ec 08             	sub    $0x8,%esp
  102805:	68 e0 00 00 00       	push   $0xe0
  10280a:	68 f6 01 00 00       	push   $0x1f6
  10280f:	e8 e7 fe ff ff       	call   1026fb <outb>
  102814:	83 c4 10             	add    $0x10,%esp
}
  102817:	90                   	nop
  102818:	c9                   	leave  
  102819:	c3                   	ret    

0010281a <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  10281a:	55                   	push   %ebp
  10281b:	89 e5                	mov    %esp,%ebp
  10281d:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
  102820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102824:	75 0d                	jne    102833 <idestart+0x19>
    panic("idestart");
  102826:	83 ec 0c             	sub    $0xc,%esp
  102829:	68 49 58 10 00       	push   $0x105849
  10282e:	e8 7a da ff ff       	call   1002ad <panic>
  if(b->blockno >= FSSIZE)
  102833:	8b 45 08             	mov    0x8(%ebp),%eax
  102836:	8b 40 08             	mov    0x8(%eax),%eax
  102839:	3d e7 03 00 00       	cmp    $0x3e7,%eax
  10283e:	76 0d                	jbe    10284d <idestart+0x33>
    panic("incorrect blockno");
  102840:	83 ec 0c             	sub    $0xc,%esp
  102843:	68 52 58 10 00       	push   $0x105852
  102848:	e8 60 da ff ff       	call   1002ad <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
  10284d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
  102854:	8b 45 08             	mov    0x8(%ebp),%eax
  102857:	8b 50 08             	mov    0x8(%eax),%edx
  10285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10285d:	0f af c2             	imul   %edx,%eax
  102860:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  102863:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  102867:	75 07                	jne    102870 <idestart+0x56>
  102869:	b8 20 00 00 00       	mov    $0x20,%eax
  10286e:	eb 05                	jmp    102875 <idestart+0x5b>
  102870:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102875:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
  102878:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  10287c:	75 07                	jne    102885 <idestart+0x6b>
  10287e:	b8 30 00 00 00       	mov    $0x30,%eax
  102883:	eb 05                	jmp    10288a <idestart+0x70>
  102885:	b8 c5 00 00 00       	mov    $0xc5,%eax
  10288a:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
  10288d:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
  102891:	7e 0d                	jle    1028a0 <idestart+0x86>
  102893:	83 ec 0c             	sub    $0xc,%esp
  102896:	68 49 58 10 00       	push   $0x105849
  10289b:	e8 0d da ff ff       	call   1002ad <panic>

  idewait(0);
  1028a0:	83 ec 0c             	sub    $0xc,%esp
  1028a3:	6a 00                	push   $0x0
  1028a5:	e8 9f fe ff ff       	call   102749 <idewait>
  1028aa:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
  1028ad:	83 ec 08             	sub    $0x8,%esp
  1028b0:	6a 00                	push   $0x0
  1028b2:	68 f6 03 00 00       	push   $0x3f6
  1028b7:	e8 3f fe ff ff       	call   1026fb <outb>
  1028bc:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
  1028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028c2:	0f b6 c0             	movzbl %al,%eax
  1028c5:	83 ec 08             	sub    $0x8,%esp
  1028c8:	50                   	push   %eax
  1028c9:	68 f2 01 00 00       	push   $0x1f2
  1028ce:	e8 28 fe ff ff       	call   1026fb <outb>
  1028d3:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
  1028d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028d9:	0f b6 c0             	movzbl %al,%eax
  1028dc:	83 ec 08             	sub    $0x8,%esp
  1028df:	50                   	push   %eax
  1028e0:	68 f3 01 00 00       	push   $0x1f3
  1028e5:	e8 11 fe ff ff       	call   1026fb <outb>
  1028ea:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
  1028ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028f0:	c1 f8 08             	sar    $0x8,%eax
  1028f3:	0f b6 c0             	movzbl %al,%eax
  1028f6:	83 ec 08             	sub    $0x8,%esp
  1028f9:	50                   	push   %eax
  1028fa:	68 f4 01 00 00       	push   $0x1f4
  1028ff:	e8 f7 fd ff ff       	call   1026fb <outb>
  102904:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
  102907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10290a:	c1 f8 10             	sar    $0x10,%eax
  10290d:	0f b6 c0             	movzbl %al,%eax
  102910:	83 ec 08             	sub    $0x8,%esp
  102913:	50                   	push   %eax
  102914:	68 f5 01 00 00       	push   $0x1f5
  102919:	e8 dd fd ff ff       	call   1026fb <outb>
  10291e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  102921:	8b 45 08             	mov    0x8(%ebp),%eax
  102924:	8b 40 04             	mov    0x4(%eax),%eax
  102927:	c1 e0 04             	shl    $0x4,%eax
  10292a:	83 e0 10             	and    $0x10,%eax
  10292d:	89 c2                	mov    %eax,%edx
  10292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102932:	c1 f8 18             	sar    $0x18,%eax
  102935:	83 e0 0f             	and    $0xf,%eax
  102938:	09 d0                	or     %edx,%eax
  10293a:	83 c8 e0             	or     $0xffffffe0,%eax
  10293d:	0f b6 c0             	movzbl %al,%eax
  102940:	83 ec 08             	sub    $0x8,%esp
  102943:	50                   	push   %eax
  102944:	68 f6 01 00 00       	push   $0x1f6
  102949:	e8 ad fd ff ff       	call   1026fb <outb>
  10294e:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
  102951:	8b 45 08             	mov    0x8(%ebp),%eax
  102954:	8b 00                	mov    (%eax),%eax
  102956:	83 e0 04             	and    $0x4,%eax
  102959:	85 c0                	test   %eax,%eax
  10295b:	74 35                	je     102992 <idestart+0x178>
    outb(0x1f7, write_cmd);
  10295d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102960:	0f b6 c0             	movzbl %al,%eax
  102963:	83 ec 08             	sub    $0x8,%esp
  102966:	50                   	push   %eax
  102967:	68 f7 01 00 00       	push   $0x1f7
  10296c:	e8 8a fd ff ff       	call   1026fb <outb>
  102971:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
  102974:	8b 45 08             	mov    0x8(%ebp),%eax
  102977:	83 c0 1c             	add    $0x1c,%eax
  10297a:	83 ec 04             	sub    $0x4,%esp
  10297d:	68 80 00 00 00       	push   $0x80
  102982:	50                   	push   %eax
  102983:	68 f0 01 00 00       	push   $0x1f0
  102988:	e8 8f fd ff ff       	call   10271c <outsl>
  10298d:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
  102990:	eb 17                	jmp    1029a9 <idestart+0x18f>
    outb(0x1f7, read_cmd);
  102992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102995:	0f b6 c0             	movzbl %al,%eax
  102998:	83 ec 08             	sub    $0x8,%esp
  10299b:	50                   	push   %eax
  10299c:	68 f7 01 00 00       	push   $0x1f7
  1029a1:	e8 55 fd ff ff       	call   1026fb <outb>
  1029a6:	83 c4 10             	add    $0x10,%esp
}
  1029a9:	90                   	nop
  1029aa:	c9                   	leave  
  1029ab:	c3                   	ret    

001029ac <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
  1029ac:	55                   	push   %ebp
  1029ad:	89 e5                	mov    %esp,%ebp
  1029af:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  if((b = idequeue) == 0){
  1029b2:	a1 24 d2 10 00       	mov    0x10d224,%eax
  1029b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1029be:	74 78                	je     102a38 <ideintr+0x8c>
    return;
  }
  idequeue = b->qnext;
  1029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029c3:	8b 40 18             	mov    0x18(%eax),%eax
  1029c6:	a3 24 d2 10 00       	mov    %eax,0x10d224

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
  1029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ce:	8b 00                	mov    (%eax),%eax
  1029d0:	83 e0 04             	and    $0x4,%eax
  1029d3:	85 c0                	test   %eax,%eax
  1029d5:	75 27                	jne    1029fe <ideintr+0x52>
  1029d7:	6a 01                	push   $0x1
  1029d9:	e8 6b fd ff ff       	call   102749 <idewait>
  1029de:	83 c4 04             	add    $0x4,%esp
  1029e1:	85 c0                	test   %eax,%eax
  1029e3:	78 19                	js     1029fe <ideintr+0x52>
    insl(0x1f0, b->data, BSIZE/4);
  1029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e8:	83 c0 1c             	add    $0x1c,%eax
  1029eb:	68 80 00 00 00       	push   $0x80
  1029f0:	50                   	push   %eax
  1029f1:	68 f0 01 00 00       	push   $0x1f0
  1029f6:	e8 da fc ff ff       	call   1026d5 <insl>
  1029fb:	83 c4 0c             	add    $0xc,%esp

  b->flags |= B_VALID;
  1029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a01:	8b 00                	mov    (%eax),%eax
  102a03:	83 c8 02             	or     $0x2,%eax
  102a06:	89 c2                	mov    %eax,%edx
  102a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a0b:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
  102a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a10:	8b 00                	mov    (%eax),%eax
  102a12:	83 e0 fb             	and    $0xfffffffb,%eax
  102a15:	89 c2                	mov    %eax,%edx
  102a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a1a:	89 10                	mov    %edx,(%eax)

  // Start disk on next buf in queue.
  if(idequeue != 0)
  102a1c:	a1 24 d2 10 00       	mov    0x10d224,%eax
  102a21:	85 c0                	test   %eax,%eax
  102a23:	74 14                	je     102a39 <ideintr+0x8d>
    idestart(idequeue);
  102a25:	a1 24 d2 10 00       	mov    0x10d224,%eax
  102a2a:	83 ec 0c             	sub    $0xc,%esp
  102a2d:	50                   	push   %eax
  102a2e:	e8 e7 fd ff ff       	call   10281a <idestart>
  102a33:	83 c4 10             	add    $0x10,%esp
  102a36:	eb 01                	jmp    102a39 <ideintr+0x8d>
    return;
  102a38:	90                   	nop
}
  102a39:	c9                   	leave  
  102a3a:	c3                   	ret    

00102a3b <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
  102a3b:	55                   	push   %ebp
  102a3c:	89 e5                	mov    %esp,%ebp
  102a3e:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102a41:	8b 45 08             	mov    0x8(%ebp),%eax
  102a44:	8b 00                	mov    (%eax),%eax
  102a46:	83 e0 06             	and    $0x6,%eax
  102a49:	83 f8 02             	cmp    $0x2,%eax
  102a4c:	75 0d                	jne    102a5b <iderw+0x20>
    panic("iderw: nothing to do");
  102a4e:	83 ec 0c             	sub    $0xc,%esp
  102a51:	68 64 58 10 00       	push   $0x105864
  102a56:	e8 52 d8 ff ff       	call   1002ad <panic>
  if(b->dev != 0 && !havedisk1)
  102a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5e:	8b 40 04             	mov    0x4(%eax),%eax
  102a61:	85 c0                	test   %eax,%eax
  102a63:	74 16                	je     102a7b <iderw+0x40>
  102a65:	a1 28 d2 10 00       	mov    0x10d228,%eax
  102a6a:	85 c0                	test   %eax,%eax
  102a6c:	75 0d                	jne    102a7b <iderw+0x40>
    panic("iderw: ide disk 1 not present");
  102a6e:	83 ec 0c             	sub    $0xc,%esp
  102a71:	68 79 58 10 00       	push   $0x105879
  102a76:	e8 32 d8 ff ff       	call   1002ad <panic>

  // Append b to idequeue.
  b->qnext = 0;
  102a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
  102a85:	c7 45 f4 24 d2 10 00 	movl   $0x10d224,-0xc(%ebp)
  102a8c:	eb 0b                	jmp    102a99 <iderw+0x5e>
  102a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a91:	8b 00                	mov    (%eax),%eax
  102a93:	83 c0 18             	add    $0x18,%eax
  102a96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a9c:	8b 00                	mov    (%eax),%eax
  102a9e:	85 c0                	test   %eax,%eax
  102aa0:	75 ec                	jne    102a8e <iderw+0x53>
    ;
  *pp = b;
  102aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  102aa8:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
  102aaa:	a1 24 d2 10 00       	mov    0x10d224,%eax
  102aaf:	39 45 08             	cmp    %eax,0x8(%ebp)
  102ab2:	75 15                	jne    102ac9 <iderw+0x8e>
    idestart(b);
  102ab4:	83 ec 0c             	sub    $0xc,%esp
  102ab7:	ff 75 08             	push   0x8(%ebp)
  102aba:	e8 5b fd ff ff       	call   10281a <idestart>
  102abf:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102ac2:	eb 05                	jmp    102ac9 <iderw+0x8e>
  {
    // Warning: If we do not call noop(), compiler generates code that does not
    // read "b->flags" again and therefore never come out of this while loop. 
    // "b->flags" is modified by the trap handler in ideintr().  
    noop();
  102ac4:	e8 79 fc ff ff       	call   102742 <noop>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  102acc:	8b 00                	mov    (%eax),%eax
  102ace:	83 e0 06             	and    $0x6,%eax
  102ad1:	83 f8 02             	cmp    $0x2,%eax
  102ad4:	75 ee                	jne    102ac4 <iderw+0x89>
  }
}
  102ad6:	90                   	nop
  102ad7:	90                   	nop
  102ad8:	c9                   	leave  
  102ad9:	c3                   	ret    

00102ada <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
  102ada:	55                   	push   %ebp
  102adb:	89 e5                	mov    %esp,%ebp
  102add:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
  102ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae3:	83 ec 08             	sub    $0x8,%esp
  102ae6:	6a 01                	push   $0x1
  102ae8:	50                   	push   %eax
  102ae9:	e8 05 fb ff ff       	call   1025f3 <bread>
  102aee:	83 c4 10             	add    $0x10,%esp
  102af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
  102af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af7:	83 c0 1c             	add    $0x1c,%eax
  102afa:	83 ec 04             	sub    $0x4,%esp
  102afd:	6a 1c                	push   $0x1c
  102aff:	50                   	push   %eax
  102b00:	ff 75 0c             	push   0xc(%ebp)
  102b03:	e8 b5 e4 ff ff       	call   100fbd <memmove>
  102b08:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102b0b:	83 ec 0c             	sub    $0xc,%esp
  102b0e:	ff 75 f4             	push   -0xc(%ebp)
  102b11:	e8 3c fb ff ff       	call   102652 <brelse>
  102b16:	83 c4 10             	add    $0x10,%esp
}
  102b19:	90                   	nop
  102b1a:	c9                   	leave  
  102b1b:	c3                   	ret    

00102b1c <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
  102b1c:	55                   	push   %ebp
  102b1d:	89 e5                	mov    %esp,%ebp
  102b1f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
  102b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b25:	8b 45 08             	mov    0x8(%ebp),%eax
  102b28:	83 ec 08             	sub    $0x8,%esp
  102b2b:	52                   	push   %edx
  102b2c:	50                   	push   %eax
  102b2d:	e8 c1 fa ff ff       	call   1025f3 <bread>
  102b32:	83 c4 10             	add    $0x10,%esp
  102b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
  102b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b3b:	83 c0 1c             	add    $0x1c,%eax
  102b3e:	83 ec 04             	sub    $0x4,%esp
  102b41:	68 00 02 00 00       	push   $0x200
  102b46:	6a 00                	push   $0x0
  102b48:	50                   	push   %eax
  102b49:	e8 b0 e3 ff ff       	call   100efe <memset>
  102b4e:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
  102b51:	83 ec 0c             	sub    $0xc,%esp
  102b54:	ff 75 f4             	push   -0xc(%ebp)
  102b57:	e8 94 1a 00 00       	call   1045f0 <log_write>
  102b5c:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102b5f:	83 ec 0c             	sub    $0xc,%esp
  102b62:	ff 75 f4             	push   -0xc(%ebp)
  102b65:	e8 e8 fa ff ff       	call   102652 <brelse>
  102b6a:	83 c4 10             	add    $0x10,%esp
}
  102b6d:	90                   	nop
  102b6e:	c9                   	leave  
  102b6f:	c3                   	ret    

00102b70 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
  102b70:	55                   	push   %ebp
  102b71:	89 e5                	mov    %esp,%ebp
  102b73:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  102b76:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
  102b7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102b84:	e9 0b 01 00 00       	jmp    102c94 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
  102b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b8c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  102b92:	85 c0                	test   %eax,%eax
  102b94:	0f 48 c2             	cmovs  %edx,%eax
  102b97:	c1 f8 0c             	sar    $0xc,%eax
  102b9a:	89 c2                	mov    %eax,%edx
  102b9c:	a1 58 d2 10 00       	mov    0x10d258,%eax
  102ba1:	01 d0                	add    %edx,%eax
  102ba3:	83 ec 08             	sub    $0x8,%esp
  102ba6:	50                   	push   %eax
  102ba7:	ff 75 08             	push   0x8(%ebp)
  102baa:	e8 44 fa ff ff       	call   1025f3 <bread>
  102baf:	83 c4 10             	add    $0x10,%esp
  102bb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
  102bb5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102bbc:	e9 9e 00 00 00       	jmp    102c5f <balloc+0xef>
      m = 1 << (bi % 8);
  102bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bc4:	83 e0 07             	and    $0x7,%eax
  102bc7:	ba 01 00 00 00       	mov    $0x1,%edx
  102bcc:	89 c1                	mov    %eax,%ecx
  102bce:	d3 e2                	shl    %cl,%edx
  102bd0:	89 d0                	mov    %edx,%eax
  102bd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  102bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bd8:	8d 50 07             	lea    0x7(%eax),%edx
  102bdb:	85 c0                	test   %eax,%eax
  102bdd:	0f 48 c2             	cmovs  %edx,%eax
  102be0:	c1 f8 03             	sar    $0x3,%eax
  102be3:	89 c2                	mov    %eax,%edx
  102be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102be8:	0f b6 44 10 1c       	movzbl 0x1c(%eax,%edx,1),%eax
  102bed:	0f b6 c0             	movzbl %al,%eax
  102bf0:	23 45 e8             	and    -0x18(%ebp),%eax
  102bf3:	85 c0                	test   %eax,%eax
  102bf5:	75 64                	jne    102c5b <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
  102bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bfa:	8d 50 07             	lea    0x7(%eax),%edx
  102bfd:	85 c0                	test   %eax,%eax
  102bff:	0f 48 c2             	cmovs  %edx,%eax
  102c02:	c1 f8 03             	sar    $0x3,%eax
  102c05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c08:	0f b6 54 02 1c       	movzbl 0x1c(%edx,%eax,1),%edx
  102c0d:	89 d1                	mov    %edx,%ecx
  102c0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102c12:	09 ca                	or     %ecx,%edx
  102c14:	89 d1                	mov    %edx,%ecx
  102c16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c19:	88 4c 02 1c          	mov    %cl,0x1c(%edx,%eax,1)
        log_write(bp);
  102c1d:	83 ec 0c             	sub    $0xc,%esp
  102c20:	ff 75 ec             	push   -0x14(%ebp)
  102c23:	e8 c8 19 00 00       	call   1045f0 <log_write>
  102c28:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
  102c2b:	83 ec 0c             	sub    $0xc,%esp
  102c2e:	ff 75 ec             	push   -0x14(%ebp)
  102c31:	e8 1c fa ff ff       	call   102652 <brelse>
  102c36:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
  102c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c3f:	01 c2                	add    %eax,%edx
  102c41:	8b 45 08             	mov    0x8(%ebp),%eax
  102c44:	83 ec 08             	sub    $0x8,%esp
  102c47:	52                   	push   %edx
  102c48:	50                   	push   %eax
  102c49:	e8 ce fe ff ff       	call   102b1c <bzero>
  102c4e:	83 c4 10             	add    $0x10,%esp
        return b + bi;
  102c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c57:	01 d0                	add    %edx,%eax
  102c59:	eb 57                	jmp    102cb2 <balloc+0x142>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
  102c5b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102c5f:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
  102c66:	7f 17                	jg     102c7f <balloc+0x10f>
  102c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c6e:	01 d0                	add    %edx,%eax
  102c70:	89 c2                	mov    %eax,%edx
  102c72:	a1 40 d2 10 00       	mov    0x10d240,%eax
  102c77:	39 c2                	cmp    %eax,%edx
  102c79:	0f 82 42 ff ff ff    	jb     102bc1 <balloc+0x51>
      }
    }
    brelse(bp);
  102c7f:	83 ec 0c             	sub    $0xc,%esp
  102c82:	ff 75 ec             	push   -0x14(%ebp)
  102c85:	e8 c8 f9 ff ff       	call   102652 <brelse>
  102c8a:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
  102c8d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  102c94:	8b 15 40 d2 10 00    	mov    0x10d240,%edx
  102c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c9d:	39 c2                	cmp    %eax,%edx
  102c9f:	0f 87 e4 fe ff ff    	ja     102b89 <balloc+0x19>
  }
  panic("balloc: out of blocks");
  102ca5:	83 ec 0c             	sub    $0xc,%esp
  102ca8:	68 98 58 10 00       	push   $0x105898
  102cad:	e8 fb d5 ff ff       	call   1002ad <panic>
}
  102cb2:	c9                   	leave  
  102cb3:	c3                   	ret    

00102cb4 <bfree>:


// Free a disk block.
static void
bfree(int dev, uint b)
{
  102cb4:	55                   	push   %ebp
  102cb5:	89 e5                	mov    %esp,%ebp
  102cb7:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  102cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cbd:	c1 e8 0c             	shr    $0xc,%eax
  102cc0:	89 c2                	mov    %eax,%edx
  102cc2:	a1 58 d2 10 00       	mov    0x10d258,%eax
  102cc7:	01 c2                	add    %eax,%edx
  102cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccc:	83 ec 08             	sub    $0x8,%esp
  102ccf:	52                   	push   %edx
  102cd0:	50                   	push   %eax
  102cd1:	e8 1d f9 ff ff       	call   1025f3 <bread>
  102cd6:	83 c4 10             	add    $0x10,%esp
  102cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
  102cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cdf:	25 ff 0f 00 00       	and    $0xfff,%eax
  102ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
  102ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cea:	83 e0 07             	and    $0x7,%eax
  102ced:	ba 01 00 00 00       	mov    $0x1,%edx
  102cf2:	89 c1                	mov    %eax,%ecx
  102cf4:	d3 e2                	shl    %cl,%edx
  102cf6:	89 d0                	mov    %edx,%eax
  102cf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
  102cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cfe:	8d 50 07             	lea    0x7(%eax),%edx
  102d01:	85 c0                	test   %eax,%eax
  102d03:	0f 48 c2             	cmovs  %edx,%eax
  102d06:	c1 f8 03             	sar    $0x3,%eax
  102d09:	89 c2                	mov    %eax,%edx
  102d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d0e:	0f b6 44 10 1c       	movzbl 0x1c(%eax,%edx,1),%eax
  102d13:	0f b6 c0             	movzbl %al,%eax
  102d16:	23 45 ec             	and    -0x14(%ebp),%eax
  102d19:	85 c0                	test   %eax,%eax
  102d1b:	75 0d                	jne    102d2a <bfree+0x76>
    panic("freeing free block");
  102d1d:	83 ec 0c             	sub    $0xc,%esp
  102d20:	68 ae 58 10 00       	push   $0x1058ae
  102d25:	e8 83 d5 ff ff       	call   1002ad <panic>
  bp->data[bi/8] &= ~m;
  102d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d2d:	8d 50 07             	lea    0x7(%eax),%edx
  102d30:	85 c0                	test   %eax,%eax
  102d32:	0f 48 c2             	cmovs  %edx,%eax
  102d35:	c1 f8 03             	sar    $0x3,%eax
  102d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d3b:	0f b6 54 02 1c       	movzbl 0x1c(%edx,%eax,1),%edx
  102d40:	89 d1                	mov    %edx,%ecx
  102d42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d45:	f7 d2                	not    %edx
  102d47:	21 ca                	and    %ecx,%edx
  102d49:	89 d1                	mov    %edx,%ecx
  102d4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d4e:	88 4c 02 1c          	mov    %cl,0x1c(%edx,%eax,1)
  log_write(bp);
  102d52:	83 ec 0c             	sub    $0xc,%esp
  102d55:	ff 75 f4             	push   -0xc(%ebp)
  102d58:	e8 93 18 00 00       	call   1045f0 <log_write>
  102d5d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102d60:	83 ec 0c             	sub    $0xc,%esp
  102d63:	ff 75 f4             	push   -0xc(%ebp)
  102d66:	e8 e7 f8 ff ff       	call   102652 <brelse>
  102d6b:	83 c4 10             	add    $0x10,%esp
}
  102d6e:	90                   	nop
  102d6f:	c9                   	leave  
  102d70:	c3                   	ret    

00102d71 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
  102d71:	55                   	push   %ebp
  102d72:	89 e5                	mov    %esp,%ebp
  102d74:	57                   	push   %edi
  102d75:	56                   	push   %esi
  102d76:	53                   	push   %ebx
  102d77:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
  102d7a:	83 ec 08             	sub    $0x8,%esp
  102d7d:	68 40 d2 10 00       	push   $0x10d240
  102d82:	ff 75 08             	push   0x8(%ebp)
  102d85:	e8 50 fd ff ff       	call   102ada <readsb>
  102d8a:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
  102d8d:	a1 58 d2 10 00       	mov    0x10d258,%eax
  102d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d95:	8b 3d 54 d2 10 00    	mov    0x10d254,%edi
  102d9b:	8b 35 50 d2 10 00    	mov    0x10d250,%esi
  102da1:	8b 1d 4c d2 10 00    	mov    0x10d24c,%ebx
  102da7:	8b 0d 48 d2 10 00    	mov    0x10d248,%ecx
  102dad:	8b 15 44 d2 10 00    	mov    0x10d244,%edx
  102db3:	a1 40 d2 10 00       	mov    0x10d240,%eax
  102db8:	ff 75 e4             	push   -0x1c(%ebp)
  102dbb:	57                   	push   %edi
  102dbc:	56                   	push   %esi
  102dbd:	53                   	push   %ebx
  102dbe:	51                   	push   %ecx
  102dbf:	52                   	push   %edx
  102dc0:	50                   	push   %eax
  102dc1:	68 c4 58 10 00       	push   $0x1058c4
  102dc6:	e8 21 d3 ff ff       	call   1000ec <cprintf>
  102dcb:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
  102dce:	90                   	nop
  102dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  102dd2:	5b                   	pop    %ebx
  102dd3:	5e                   	pop    %esi
  102dd4:	5f                   	pop    %edi
  102dd5:	5d                   	pop    %ebp
  102dd6:	c3                   	ret    

00102dd7 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
  102dd7:	55                   	push   %ebp
  102dd8:	89 e5                	mov    %esp,%ebp
  102dda:	83 ec 28             	sub    $0x28,%esp
  102ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de0:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
  102de4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  102deb:	e9 9e 00 00 00       	jmp    102e8e <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
  102df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102df3:	c1 e8 03             	shr    $0x3,%eax
  102df6:	89 c2                	mov    %eax,%edx
  102df8:	a1 54 d2 10 00       	mov    0x10d254,%eax
  102dfd:	01 d0                	add    %edx,%eax
  102dff:	83 ec 08             	sub    $0x8,%esp
  102e02:	50                   	push   %eax
  102e03:	ff 75 08             	push   0x8(%ebp)
  102e06:	e8 e8 f7 ff ff       	call   1025f3 <bread>
  102e0b:	83 c4 10             	add    $0x10,%esp
  102e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
  102e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e14:	8d 50 1c             	lea    0x1c(%eax),%edx
  102e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e1a:	83 e0 07             	and    $0x7,%eax
  102e1d:	c1 e0 06             	shl    $0x6,%eax
  102e20:	01 d0                	add    %edx,%eax
  102e22:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
  102e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e28:	0f b7 00             	movzwl (%eax),%eax
  102e2b:	66 85 c0             	test   %ax,%ax
  102e2e:	75 4c                	jne    102e7c <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
  102e30:	83 ec 04             	sub    $0x4,%esp
  102e33:	6a 40                	push   $0x40
  102e35:	6a 00                	push   $0x0
  102e37:	ff 75 ec             	push   -0x14(%ebp)
  102e3a:	e8 bf e0 ff ff       	call   100efe <memset>
  102e3f:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
  102e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e45:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  102e49:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
  102e4c:	83 ec 0c             	sub    $0xc,%esp
  102e4f:	ff 75 f0             	push   -0x10(%ebp)
  102e52:	e8 99 17 00 00       	call   1045f0 <log_write>
  102e57:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
  102e5a:	83 ec 0c             	sub    $0xc,%esp
  102e5d:	ff 75 f0             	push   -0x10(%ebp)
  102e60:	e8 ed f7 ff ff       	call   102652 <brelse>
  102e65:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
  102e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e6b:	83 ec 08             	sub    $0x8,%esp
  102e6e:	50                   	push   %eax
  102e6f:	ff 75 08             	push   0x8(%ebp)
  102e72:	e8 64 01 00 00       	call   102fdb <iget>
  102e77:	83 c4 10             	add    $0x10,%esp
  102e7a:	eb 30                	jmp    102eac <ialloc+0xd5>
    }
    brelse(bp);
  102e7c:	83 ec 0c             	sub    $0xc,%esp
  102e7f:	ff 75 f0             	push   -0x10(%ebp)
  102e82:	e8 cb f7 ff ff       	call   102652 <brelse>
  102e87:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
  102e8a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  102e8e:	8b 15 48 d2 10 00    	mov    0x10d248,%edx
  102e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e97:	39 c2                	cmp    %eax,%edx
  102e99:	0f 87 51 ff ff ff    	ja     102df0 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
  102e9f:	83 ec 0c             	sub    $0xc,%esp
  102ea2:	68 17 59 10 00       	push   $0x105917
  102ea7:	e8 01 d4 ff ff       	call   1002ad <panic>
}
  102eac:	c9                   	leave  
  102ead:	c3                   	ret    

00102eae <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
  102eae:	55                   	push   %ebp
  102eaf:	89 e5                	mov    %esp,%ebp
  102eb1:	83 ec 18             	sub    $0x18,%esp
  if(ip->valid && ip->nlink == 0){
  102eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb7:	8b 40 0c             	mov    0xc(%eax),%eax
  102eba:	85 c0                	test   %eax,%eax
  102ebc:	74 4a                	je     102f08 <iput+0x5a>
  102ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  102ec5:	66 85 c0             	test   %ax,%ax
  102ec8:	75 3e                	jne    102f08 <iput+0x5a>
    int r = ip->ref;
  102eca:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecd:	8b 40 08             	mov    0x8(%eax),%eax
  102ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(r == 1){
  102ed3:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  102ed7:	75 2f                	jne    102f08 <iput+0x5a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
  102ed9:	83 ec 0c             	sub    $0xc,%esp
  102edc:	ff 75 08             	push   0x8(%ebp)
  102edf:	e8 c1 03 00 00       	call   1032a5 <itrunc>
  102ee4:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
  102ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eea:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
      iupdate(ip);
  102ef0:	83 ec 0c             	sub    $0xc,%esp
  102ef3:	ff 75 08             	push   0x8(%ebp)
  102ef6:	e8 1f 00 00 00       	call   102f1a <iupdate>
  102efb:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
  102efe:	8b 45 08             	mov    0x8(%ebp),%eax
  102f01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    }
  }
  ip->ref--;
  102f08:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0b:	8b 40 08             	mov    0x8(%eax),%eax
  102f0e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f11:	8b 45 08             	mov    0x8(%ebp),%eax
  102f14:	89 50 08             	mov    %edx,0x8(%eax)
}
  102f17:	90                   	nop
  102f18:	c9                   	leave  
  102f19:	c3                   	ret    

00102f1a <iupdate>:
// Copy a modified in-memory inode to disk.
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
void
iupdate(struct inode *ip)
{
  102f1a:	55                   	push   %ebp
  102f1b:	89 e5                	mov    %esp,%ebp
  102f1d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  102f20:	8b 45 08             	mov    0x8(%ebp),%eax
  102f23:	8b 40 04             	mov    0x4(%eax),%eax
  102f26:	c1 e8 03             	shr    $0x3,%eax
  102f29:	89 c2                	mov    %eax,%edx
  102f2b:	a1 54 d2 10 00       	mov    0x10d254,%eax
  102f30:	01 c2                	add    %eax,%edx
  102f32:	8b 45 08             	mov    0x8(%ebp),%eax
  102f35:	8b 00                	mov    (%eax),%eax
  102f37:	83 ec 08             	sub    $0x8,%esp
  102f3a:	52                   	push   %edx
  102f3b:	50                   	push   %eax
  102f3c:	e8 b2 f6 ff ff       	call   1025f3 <bread>
  102f41:	83 c4 10             	add    $0x10,%esp
  102f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  102f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f4a:	8d 50 1c             	lea    0x1c(%eax),%edx
  102f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f50:	8b 40 04             	mov    0x4(%eax),%eax
  102f53:	83 e0 07             	and    $0x7,%eax
  102f56:	c1 e0 06             	shl    $0x6,%eax
  102f59:	01 d0                	add    %edx,%eax
  102f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
  102f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f61:	0f b7 50 10          	movzwl 0x10(%eax),%edx
  102f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f68:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  102f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6e:	0f b7 50 12          	movzwl 0x12(%eax),%edx
  102f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f75:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  102f79:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7c:	0f b7 50 14          	movzwl 0x14(%eax),%edx
  102f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f83:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  102f87:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8a:	0f b7 50 16          	movzwl 0x16(%eax),%edx
  102f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f91:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  102f95:	8b 45 08             	mov    0x8(%ebp),%eax
  102f98:	8b 50 18             	mov    0x18(%eax),%edx
  102f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f9e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  102fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa4:	8d 50 1c             	lea    0x1c(%eax),%edx
  102fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102faa:	83 c0 0c             	add    $0xc,%eax
  102fad:	83 ec 04             	sub    $0x4,%esp
  102fb0:	6a 34                	push   $0x34
  102fb2:	52                   	push   %edx
  102fb3:	50                   	push   %eax
  102fb4:	e8 04 e0 ff ff       	call   100fbd <memmove>
  102fb9:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
  102fbc:	83 ec 0c             	sub    $0xc,%esp
  102fbf:	ff 75 f4             	push   -0xc(%ebp)
  102fc2:	e8 29 16 00 00       	call   1045f0 <log_write>
  102fc7:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102fca:	83 ec 0c             	sub    $0xc,%esp
  102fcd:	ff 75 f4             	push   -0xc(%ebp)
  102fd0:	e8 7d f6 ff ff       	call   102652 <brelse>
  102fd5:	83 c4 10             	add    $0x10,%esp
}
  102fd8:	90                   	nop
  102fd9:	c9                   	leave  
  102fda:	c3                   	ret    

00102fdb <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
struct inode*
iget(uint dev, uint inum)
{
  102fdb:	55                   	push   %ebp
  102fdc:	89 e5                	mov    %esp,%ebp
  102fde:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  // Is the inode already cached?
  empty = 0;
  102fe1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  102fe8:	c7 45 f4 60 d2 10 00 	movl   $0x10d260,-0xc(%ebp)
  102fef:	eb 4d                	jmp    10303e <iget+0x63>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  102ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ff4:	8b 40 08             	mov    0x8(%eax),%eax
  102ff7:	85 c0                	test   %eax,%eax
  102ff9:	7e 29                	jle    103024 <iget+0x49>
  102ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ffe:	8b 00                	mov    (%eax),%eax
  103000:	39 45 08             	cmp    %eax,0x8(%ebp)
  103003:	75 1f                	jne    103024 <iget+0x49>
  103005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103008:	8b 40 04             	mov    0x4(%eax),%eax
  10300b:	39 45 0c             	cmp    %eax,0xc(%ebp)
  10300e:	75 14                	jne    103024 <iget+0x49>
      ip->ref++;
  103010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103013:	8b 40 08             	mov    0x8(%eax),%eax
  103016:	8d 50 01             	lea    0x1(%eax),%edx
  103019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10301c:	89 50 08             	mov    %edx,0x8(%eax)
      return ip;
  10301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103022:	eb 64                	jmp    103088 <iget+0xad>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  103024:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103028:	75 10                	jne    10303a <iget+0x5f>
  10302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10302d:	8b 40 08             	mov    0x8(%eax),%eax
  103030:	85 c0                	test   %eax,%eax
  103032:	75 06                	jne    10303a <iget+0x5f>
      empty = ip;
  103034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103037:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  10303a:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
  10303e:	81 7d f4 00 e2 10 00 	cmpl   $0x10e200,-0xc(%ebp)
  103045:	72 aa                	jb     102ff1 <iget+0x16>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
  103047:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10304b:	75 0d                	jne    10305a <iget+0x7f>
    panic("iget: no inodes");
  10304d:	83 ec 0c             	sub    $0xc,%esp
  103050:	68 29 59 10 00       	push   $0x105929
  103055:	e8 53 d2 ff ff       	call   1002ad <panic>

  ip = empty;
  10305a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10305d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
  103060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103063:	8b 55 08             	mov    0x8(%ebp),%edx
  103066:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
  103068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10306b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10306e:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
  103071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103074:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
  10307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10307e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

  return ip;
  103085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103088:	c9                   	leave  
  103089:	c3                   	ret    

0010308a <iread>:

// Reads the inode from disk if necessary.
void
iread(struct inode *ip)
{
  10308a:	55                   	push   %ebp
  10308b:	89 e5                	mov    %esp,%ebp
  10308d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  103090:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103094:	74 0a                	je     1030a0 <iread+0x16>
  103096:	8b 45 08             	mov    0x8(%ebp),%eax
  103099:	8b 40 08             	mov    0x8(%eax),%eax
  10309c:	85 c0                	test   %eax,%eax
  10309e:	7f 0d                	jg     1030ad <iread+0x23>
    panic("iread");
  1030a0:	83 ec 0c             	sub    $0xc,%esp
  1030a3:	68 39 59 10 00       	push   $0x105939
  1030a8:	e8 00 d2 ff ff       	call   1002ad <panic>

  if(ip->valid == 0){
  1030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b0:	8b 40 0c             	mov    0xc(%eax),%eax
  1030b3:	85 c0                	test   %eax,%eax
  1030b5:	0f 85 cd 00 00 00    	jne    103188 <iread+0xfe>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  1030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030be:	8b 40 04             	mov    0x4(%eax),%eax
  1030c1:	c1 e8 03             	shr    $0x3,%eax
  1030c4:	89 c2                	mov    %eax,%edx
  1030c6:	a1 54 d2 10 00       	mov    0x10d254,%eax
  1030cb:	01 c2                	add    %eax,%edx
  1030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d0:	8b 00                	mov    (%eax),%eax
  1030d2:	83 ec 08             	sub    $0x8,%esp
  1030d5:	52                   	push   %edx
  1030d6:	50                   	push   %eax
  1030d7:	e8 17 f5 ff ff       	call   1025f3 <bread>
  1030dc:	83 c4 10             	add    $0x10,%esp
  1030df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  1030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030e5:	8d 50 1c             	lea    0x1c(%eax),%edx
  1030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030eb:	8b 40 04             	mov    0x4(%eax),%eax
  1030ee:	83 e0 07             	and    $0x7,%eax
  1030f1:	c1 e0 06             	shl    $0x6,%eax
  1030f4:	01 d0                	add    %edx,%eax
  1030f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
  1030f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030fc:	0f b7 10             	movzwl (%eax),%edx
  1030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103102:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
  103106:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103109:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  10310d:	8b 45 08             	mov    0x8(%ebp),%eax
  103110:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
  103114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103117:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  10311b:	8b 45 08             	mov    0x8(%ebp),%eax
  10311e:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
  103122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103125:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  103129:	8b 45 08             	mov    0x8(%ebp),%eax
  10312c:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
  103130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103133:	8b 50 08             	mov    0x8(%eax),%edx
  103136:	8b 45 08             	mov    0x8(%ebp),%eax
  103139:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  10313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10313f:	8d 50 0c             	lea    0xc(%eax),%edx
  103142:	8b 45 08             	mov    0x8(%ebp),%eax
  103145:	83 c0 1c             	add    $0x1c,%eax
  103148:	83 ec 04             	sub    $0x4,%esp
  10314b:	6a 34                	push   $0x34
  10314d:	52                   	push   %edx
  10314e:	50                   	push   %eax
  10314f:	e8 69 de ff ff       	call   100fbd <memmove>
  103154:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  103157:	83 ec 0c             	sub    $0xc,%esp
  10315a:	ff 75 f4             	push   -0xc(%ebp)
  10315d:	e8 f0 f4 ff ff       	call   102652 <brelse>
  103162:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
  103165:	8b 45 08             	mov    0x8(%ebp),%eax
  103168:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    if(ip->type == 0)
  10316f:	8b 45 08             	mov    0x8(%ebp),%eax
  103172:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103176:	66 85 c0             	test   %ax,%ax
  103179:	75 0d                	jne    103188 <iread+0xfe>
      panic("iread: no type");
  10317b:	83 ec 0c             	sub    $0xc,%esp
  10317e:	68 3f 59 10 00       	push   $0x10593f
  103183:	e8 25 d1 ff ff       	call   1002ad <panic>
  }
}
  103188:	90                   	nop
  103189:	c9                   	leave  
  10318a:	c3                   	ret    

0010318b <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
  10318b:	55                   	push   %ebp
  10318c:	89 e5                	mov    %esp,%ebp
  10318e:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  103191:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
  103195:	77 42                	ja     1031d9 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
  103197:	8b 45 08             	mov    0x8(%ebp),%eax
  10319a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10319d:	83 c2 04             	add    $0x4,%edx
  1031a0:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  1031a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031ab:	75 24                	jne    1031d1 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
  1031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b0:	8b 00                	mov    (%eax),%eax
  1031b2:	83 ec 0c             	sub    $0xc,%esp
  1031b5:	50                   	push   %eax
  1031b6:	e8 b5 f9 ff ff       	call   102b70 <balloc>
  1031bb:	83 c4 10             	add    $0x10,%esp
  1031be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1031c7:	8d 4a 04             	lea    0x4(%edx),%ecx
  1031ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031cd:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
  1031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031d4:	e9 ca 00 00 00       	jmp    1032a3 <bmap+0x118>
  }
  bn -= NDIRECT;
  1031d9:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
  1031dd:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
  1031e1:	0f 87 af 00 00 00    	ja     103296 <bmap+0x10b>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
  1031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ea:	8b 40 4c             	mov    0x4c(%eax),%eax
  1031ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031f4:	75 1d                	jne    103213 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
  1031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f9:	8b 00                	mov    (%eax),%eax
  1031fb:	83 ec 0c             	sub    $0xc,%esp
  1031fe:	50                   	push   %eax
  1031ff:	e8 6c f9 ff ff       	call   102b70 <balloc>
  103204:	83 c4 10             	add    $0x10,%esp
  103207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10320a:	8b 45 08             	mov    0x8(%ebp),%eax
  10320d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103210:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
  103213:	8b 45 08             	mov    0x8(%ebp),%eax
  103216:	8b 00                	mov    (%eax),%eax
  103218:	83 ec 08             	sub    $0x8,%esp
  10321b:	ff 75 f4             	push   -0xc(%ebp)
  10321e:	50                   	push   %eax
  10321f:	e8 cf f3 ff ff       	call   1025f3 <bread>
  103224:	83 c4 10             	add    $0x10,%esp
  103227:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  10322a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10322d:	83 c0 1c             	add    $0x1c,%eax
  103230:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
  103233:	8b 45 0c             	mov    0xc(%ebp),%eax
  103236:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10323d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103240:	01 d0                	add    %edx,%eax
  103242:	8b 00                	mov    (%eax),%eax
  103244:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10324b:	75 36                	jne    103283 <bmap+0xf8>
      a[bn] = addr = balloc(ip->dev);
  10324d:	8b 45 08             	mov    0x8(%ebp),%eax
  103250:	8b 00                	mov    (%eax),%eax
  103252:	83 ec 0c             	sub    $0xc,%esp
  103255:	50                   	push   %eax
  103256:	e8 15 f9 ff ff       	call   102b70 <balloc>
  10325b:	83 c4 10             	add    $0x10,%esp
  10325e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103261:	8b 45 0c             	mov    0xc(%ebp),%eax
  103264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10326b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10326e:	01 c2                	add    %eax,%edx
  103270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103273:	89 02                	mov    %eax,(%edx)
      log_write(bp);
  103275:	83 ec 0c             	sub    $0xc,%esp
  103278:	ff 75 f0             	push   -0x10(%ebp)
  10327b:	e8 70 13 00 00       	call   1045f0 <log_write>
  103280:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  103283:	83 ec 0c             	sub    $0xc,%esp
  103286:	ff 75 f0             	push   -0x10(%ebp)
  103289:	e8 c4 f3 ff ff       	call   102652 <brelse>
  10328e:	83 c4 10             	add    $0x10,%esp
    return addr;
  103291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103294:	eb 0d                	jmp    1032a3 <bmap+0x118>
  }

  panic("bmap: out of range");
  103296:	83 ec 0c             	sub    $0xc,%esp
  103299:	68 4e 59 10 00       	push   $0x10594e
  10329e:	e8 0a d0 ff ff       	call   1002ad <panic>
}
  1032a3:	c9                   	leave  
  1032a4:	c3                   	ret    

001032a5 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
  1032a5:	55                   	push   %ebp
  1032a6:	89 e5                	mov    %esp,%ebp
  1032a8:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  1032ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1032b2:	eb 45                	jmp    1032f9 <itrunc+0x54>
    if(ip->addrs[i]){
  1032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032ba:	83 c2 04             	add    $0x4,%edx
  1032bd:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  1032c1:	85 c0                	test   %eax,%eax
  1032c3:	74 30                	je     1032f5 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
  1032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032cb:	83 c2 04             	add    $0x4,%edx
  1032ce:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  1032d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1032d5:	8b 12                	mov    (%edx),%edx
  1032d7:	83 ec 08             	sub    $0x8,%esp
  1032da:	50                   	push   %eax
  1032db:	52                   	push   %edx
  1032dc:	e8 d3 f9 ff ff       	call   102cb4 <bfree>
  1032e1:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
  1032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032ea:	83 c2 04             	add    $0x4,%edx
  1032ed:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
  1032f4:	00 
  for(i = 0; i < NDIRECT; i++){
  1032f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1032f9:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
  1032fd:	7e b5                	jle    1032b4 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
  1032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103302:	8b 40 4c             	mov    0x4c(%eax),%eax
  103305:	85 c0                	test   %eax,%eax
  103307:	0f 84 a1 00 00 00    	je     1033ae <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  10330d:	8b 45 08             	mov    0x8(%ebp),%eax
  103310:	8b 50 4c             	mov    0x4c(%eax),%edx
  103313:	8b 45 08             	mov    0x8(%ebp),%eax
  103316:	8b 00                	mov    (%eax),%eax
  103318:	83 ec 08             	sub    $0x8,%esp
  10331b:	52                   	push   %edx
  10331c:	50                   	push   %eax
  10331d:	e8 d1 f2 ff ff       	call   1025f3 <bread>
  103322:	83 c4 10             	add    $0x10,%esp
  103325:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
  103328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10332b:	83 c0 1c             	add    $0x1c,%eax
  10332e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
  103331:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  103338:	eb 3c                	jmp    103376 <itrunc+0xd1>
      if(a[j])
  10333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10333d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103347:	01 d0                	add    %edx,%eax
  103349:	8b 00                	mov    (%eax),%eax
  10334b:	85 c0                	test   %eax,%eax
  10334d:	74 23                	je     103372 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
  10334f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103352:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103359:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10335c:	01 d0                	add    %edx,%eax
  10335e:	8b 00                	mov    (%eax),%eax
  103360:	8b 55 08             	mov    0x8(%ebp),%edx
  103363:	8b 12                	mov    (%edx),%edx
  103365:	83 ec 08             	sub    $0x8,%esp
  103368:	50                   	push   %eax
  103369:	52                   	push   %edx
  10336a:	e8 45 f9 ff ff       	call   102cb4 <bfree>
  10336f:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
  103372:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  103376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103379:	83 f8 7f             	cmp    $0x7f,%eax
  10337c:	76 bc                	jbe    10333a <itrunc+0x95>
    }
    brelse(bp);
  10337e:	83 ec 0c             	sub    $0xc,%esp
  103381:	ff 75 ec             	push   -0x14(%ebp)
  103384:	e8 c9 f2 ff ff       	call   102652 <brelse>
  103389:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
  10338c:	8b 45 08             	mov    0x8(%ebp),%eax
  10338f:	8b 40 4c             	mov    0x4c(%eax),%eax
  103392:	8b 55 08             	mov    0x8(%ebp),%edx
  103395:	8b 12                	mov    (%edx),%edx
  103397:	83 ec 08             	sub    $0x8,%esp
  10339a:	50                   	push   %eax
  10339b:	52                   	push   %edx
  10339c:	e8 13 f9 ff ff       	call   102cb4 <bfree>
  1033a1:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
  1033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a7:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
  1033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b1:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
  1033b8:	83 ec 0c             	sub    $0xc,%esp
  1033bb:	ff 75 08             	push   0x8(%ebp)
  1033be:	e8 57 fb ff ff       	call   102f1a <iupdate>
  1033c3:	83 c4 10             	add    $0x10,%esp
}
  1033c6:	90                   	nop
  1033c7:	c9                   	leave  
  1033c8:	c3                   	ret    

001033c9 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
  1033c9:	55                   	push   %ebp
  1033ca:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
  1033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1033cf:	8b 00                	mov    (%eax),%eax
  1033d1:	89 c2                	mov    %eax,%edx
  1033d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033d6:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
  1033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033dc:	8b 50 04             	mov    0x4(%eax),%edx
  1033df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e2:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
  1033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e8:	0f b7 50 10          	movzwl 0x10(%eax),%edx
  1033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ef:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
  1033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f5:	0f b7 50 16          	movzwl 0x16(%eax),%edx
  1033f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033fc:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
  103400:	8b 45 08             	mov    0x8(%ebp),%eax
  103403:	8b 50 18             	mov    0x18(%eax),%edx
  103406:	8b 45 0c             	mov    0xc(%ebp),%eax
  103409:	89 50 10             	mov    %edx,0x10(%eax)
}
  10340c:	90                   	nop
  10340d:	5d                   	pop    %ebp
  10340e:	c3                   	ret    

0010340f <readi>:

// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  10340f:	55                   	push   %ebp
  103410:	89 e5                	mov    %esp,%ebp
  103412:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  103415:	8b 45 08             	mov    0x8(%ebp),%eax
  103418:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  10341c:	66 83 f8 03          	cmp    $0x3,%ax
  103420:	75 5c                	jne    10347e <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  103422:	8b 45 08             	mov    0x8(%ebp),%eax
  103425:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  103429:	66 85 c0             	test   %ax,%ax
  10342c:	78 20                	js     10344e <readi+0x3f>
  10342e:	8b 45 08             	mov    0x8(%ebp),%eax
  103431:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  103435:	66 83 f8 09          	cmp    $0x9,%ax
  103439:	7f 13                	jg     10344e <readi+0x3f>
  10343b:	8b 45 08             	mov    0x8(%ebp),%eax
  10343e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  103442:	98                   	cwtl   
  103443:	8b 04 c5 00 e2 10 00 	mov    0x10e200(,%eax,8),%eax
  10344a:	85 c0                	test   %eax,%eax
  10344c:	75 0a                	jne    103458 <readi+0x49>
      return -1;
  10344e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103453:	e9 16 01 00 00       	jmp    10356e <readi+0x15f>
    return devsw[ip->major].read(ip, dst, n);
  103458:	8b 45 08             	mov    0x8(%ebp),%eax
  10345b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  10345f:	98                   	cwtl   
  103460:	8b 04 c5 00 e2 10 00 	mov    0x10e200(,%eax,8),%eax
  103467:	8b 55 14             	mov    0x14(%ebp),%edx
  10346a:	83 ec 04             	sub    $0x4,%esp
  10346d:	52                   	push   %edx
  10346e:	ff 75 0c             	push   0xc(%ebp)
  103471:	ff 75 08             	push   0x8(%ebp)
  103474:	ff d0                	call   *%eax
  103476:	83 c4 10             	add    $0x10,%esp
  103479:	e9 f0 00 00 00       	jmp    10356e <readi+0x15f>
  }

  if(off > ip->size || off + n < off || ip->nlink < 1)
  10347e:	8b 45 08             	mov    0x8(%ebp),%eax
  103481:	8b 40 18             	mov    0x18(%eax),%eax
  103484:	39 45 10             	cmp    %eax,0x10(%ebp)
  103487:	77 19                	ja     1034a2 <readi+0x93>
  103489:	8b 55 10             	mov    0x10(%ebp),%edx
  10348c:	8b 45 14             	mov    0x14(%ebp),%eax
  10348f:	01 d0                	add    %edx,%eax
  103491:	39 45 10             	cmp    %eax,0x10(%ebp)
  103494:	77 0c                	ja     1034a2 <readi+0x93>
  103496:	8b 45 08             	mov    0x8(%ebp),%eax
  103499:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  10349d:	66 85 c0             	test   %ax,%ax
  1034a0:	7f 0a                	jg     1034ac <readi+0x9d>
    return -1;
  1034a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1034a7:	e9 c2 00 00 00       	jmp    10356e <readi+0x15f>
  if(off + n > ip->size)
  1034ac:	8b 55 10             	mov    0x10(%ebp),%edx
  1034af:	8b 45 14             	mov    0x14(%ebp),%eax
  1034b2:	01 c2                	add    %eax,%edx
  1034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b7:	8b 40 18             	mov    0x18(%eax),%eax
  1034ba:	39 c2                	cmp    %eax,%edx
  1034bc:	76 0c                	jbe    1034ca <readi+0xbb>
    n = ip->size - off;
  1034be:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c1:	8b 40 18             	mov    0x18(%eax),%eax
  1034c4:	2b 45 10             	sub    0x10(%ebp),%eax
  1034c7:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1034ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1034d1:	e9 89 00 00 00       	jmp    10355f <readi+0x150>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  1034d6:	8b 45 10             	mov    0x10(%ebp),%eax
  1034d9:	c1 e8 09             	shr    $0x9,%eax
  1034dc:	83 ec 08             	sub    $0x8,%esp
  1034df:	50                   	push   %eax
  1034e0:	ff 75 08             	push   0x8(%ebp)
  1034e3:	e8 a3 fc ff ff       	call   10318b <bmap>
  1034e8:	83 c4 10             	add    $0x10,%esp
  1034eb:	8b 55 08             	mov    0x8(%ebp),%edx
  1034ee:	8b 12                	mov    (%edx),%edx
  1034f0:	83 ec 08             	sub    $0x8,%esp
  1034f3:	50                   	push   %eax
  1034f4:	52                   	push   %edx
  1034f5:	e8 f9 f0 ff ff       	call   1025f3 <bread>
  1034fa:	83 c4 10             	add    $0x10,%esp
  1034fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  103500:	8b 45 10             	mov    0x10(%ebp),%eax
  103503:	25 ff 01 00 00       	and    $0x1ff,%eax
  103508:	ba 00 02 00 00       	mov    $0x200,%edx
  10350d:	29 c2                	sub    %eax,%edx
  10350f:	8b 45 14             	mov    0x14(%ebp),%eax
  103512:	2b 45 f4             	sub    -0xc(%ebp),%eax
  103515:	39 c2                	cmp    %eax,%edx
  103517:	0f 46 c2             	cmovbe %edx,%eax
  10351a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
  10351d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103520:	8d 50 1c             	lea    0x1c(%eax),%edx
  103523:	8b 45 10             	mov    0x10(%ebp),%eax
  103526:	25 ff 01 00 00       	and    $0x1ff,%eax
  10352b:	01 d0                	add    %edx,%eax
  10352d:	83 ec 04             	sub    $0x4,%esp
  103530:	ff 75 ec             	push   -0x14(%ebp)
  103533:	50                   	push   %eax
  103534:	ff 75 0c             	push   0xc(%ebp)
  103537:	e8 81 da ff ff       	call   100fbd <memmove>
  10353c:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  10353f:	83 ec 0c             	sub    $0xc,%esp
  103542:	ff 75 f0             	push   -0x10(%ebp)
  103545:	e8 08 f1 ff ff       	call   102652 <brelse>
  10354a:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  10354d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103550:	01 45 f4             	add    %eax,-0xc(%ebp)
  103553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103556:	01 45 10             	add    %eax,0x10(%ebp)
  103559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10355c:	01 45 0c             	add    %eax,0xc(%ebp)
  10355f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103562:	3b 45 14             	cmp    0x14(%ebp),%eax
  103565:	0f 82 6b ff ff ff    	jb     1034d6 <readi+0xc7>
  }
  return n;
  10356b:	8b 45 14             	mov    0x14(%ebp),%eax
}
  10356e:	c9                   	leave  
  10356f:	c3                   	ret    

00103570 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  103570:	55                   	push   %ebp
  103571:	89 e5                	mov    %esp,%ebp
  103573:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  103576:	8b 45 08             	mov    0x8(%ebp),%eax
  103579:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  10357d:	66 83 f8 03          	cmp    $0x3,%ax
  103581:	75 5c                	jne    1035df <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  103583:	8b 45 08             	mov    0x8(%ebp),%eax
  103586:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  10358a:	66 85 c0             	test   %ax,%ax
  10358d:	78 20                	js     1035af <writei+0x3f>
  10358f:	8b 45 08             	mov    0x8(%ebp),%eax
  103592:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  103596:	66 83 f8 09          	cmp    $0x9,%ax
  10359a:	7f 13                	jg     1035af <writei+0x3f>
  10359c:	8b 45 08             	mov    0x8(%ebp),%eax
  10359f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  1035a3:	98                   	cwtl   
  1035a4:	8b 04 c5 04 e2 10 00 	mov    0x10e204(,%eax,8),%eax
  1035ab:	85 c0                	test   %eax,%eax
  1035ad:	75 0a                	jne    1035b9 <writei+0x49>
      return -1;
  1035af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1035b4:	e9 3b 01 00 00       	jmp    1036f4 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
  1035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1035bc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  1035c0:	98                   	cwtl   
  1035c1:	8b 04 c5 04 e2 10 00 	mov    0x10e204(,%eax,8),%eax
  1035c8:	8b 55 14             	mov    0x14(%ebp),%edx
  1035cb:	83 ec 04             	sub    $0x4,%esp
  1035ce:	52                   	push   %edx
  1035cf:	ff 75 0c             	push   0xc(%ebp)
  1035d2:	ff 75 08             	push   0x8(%ebp)
  1035d5:	ff d0                	call   *%eax
  1035d7:	83 c4 10             	add    $0x10,%esp
  1035da:	e9 15 01 00 00       	jmp    1036f4 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
  1035df:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e2:	8b 40 18             	mov    0x18(%eax),%eax
  1035e5:	39 45 10             	cmp    %eax,0x10(%ebp)
  1035e8:	77 0d                	ja     1035f7 <writei+0x87>
  1035ea:	8b 55 10             	mov    0x10(%ebp),%edx
  1035ed:	8b 45 14             	mov    0x14(%ebp),%eax
  1035f0:	01 d0                	add    %edx,%eax
  1035f2:	39 45 10             	cmp    %eax,0x10(%ebp)
  1035f5:	76 0a                	jbe    103601 <writei+0x91>
    return -1;
  1035f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1035fc:	e9 f3 00 00 00       	jmp    1036f4 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
  103601:	8b 55 10             	mov    0x10(%ebp),%edx
  103604:	8b 45 14             	mov    0x14(%ebp),%eax
  103607:	01 d0                	add    %edx,%eax
  103609:	3d 00 18 01 00       	cmp    $0x11800,%eax
  10360e:	76 0a                	jbe    10361a <writei+0xaa>
    return -1;
  103610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103615:	e9 da 00 00 00       	jmp    1036f4 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  10361a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103621:	e9 97 00 00 00       	jmp    1036bd <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  103626:	8b 45 10             	mov    0x10(%ebp),%eax
  103629:	c1 e8 09             	shr    $0x9,%eax
  10362c:	83 ec 08             	sub    $0x8,%esp
  10362f:	50                   	push   %eax
  103630:	ff 75 08             	push   0x8(%ebp)
  103633:	e8 53 fb ff ff       	call   10318b <bmap>
  103638:	83 c4 10             	add    $0x10,%esp
  10363b:	8b 55 08             	mov    0x8(%ebp),%edx
  10363e:	8b 12                	mov    (%edx),%edx
  103640:	83 ec 08             	sub    $0x8,%esp
  103643:	50                   	push   %eax
  103644:	52                   	push   %edx
  103645:	e8 a9 ef ff ff       	call   1025f3 <bread>
  10364a:	83 c4 10             	add    $0x10,%esp
  10364d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  103650:	8b 45 10             	mov    0x10(%ebp),%eax
  103653:	25 ff 01 00 00       	and    $0x1ff,%eax
  103658:	ba 00 02 00 00       	mov    $0x200,%edx
  10365d:	29 c2                	sub    %eax,%edx
  10365f:	8b 45 14             	mov    0x14(%ebp),%eax
  103662:	2b 45 f4             	sub    -0xc(%ebp),%eax
  103665:	39 c2                	cmp    %eax,%edx
  103667:	0f 46 c2             	cmovbe %edx,%eax
  10366a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
  10366d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103670:	8d 50 1c             	lea    0x1c(%eax),%edx
  103673:	8b 45 10             	mov    0x10(%ebp),%eax
  103676:	25 ff 01 00 00       	and    $0x1ff,%eax
  10367b:	01 d0                	add    %edx,%eax
  10367d:	83 ec 04             	sub    $0x4,%esp
  103680:	ff 75 ec             	push   -0x14(%ebp)
  103683:	ff 75 0c             	push   0xc(%ebp)
  103686:	50                   	push   %eax
  103687:	e8 31 d9 ff ff       	call   100fbd <memmove>
  10368c:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
  10368f:	83 ec 0c             	sub    $0xc,%esp
  103692:	ff 75 f0             	push   -0x10(%ebp)
  103695:	e8 56 0f 00 00       	call   1045f0 <log_write>
  10369a:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  10369d:	83 ec 0c             	sub    $0xc,%esp
  1036a0:	ff 75 f0             	push   -0x10(%ebp)
  1036a3:	e8 aa ef ff ff       	call   102652 <brelse>
  1036a8:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1036ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036ae:	01 45 f4             	add    %eax,-0xc(%ebp)
  1036b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036b4:	01 45 10             	add    %eax,0x10(%ebp)
  1036b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036ba:	01 45 0c             	add    %eax,0xc(%ebp)
  1036bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036c0:	3b 45 14             	cmp    0x14(%ebp),%eax
  1036c3:	0f 82 5d ff ff ff    	jb     103626 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
  1036c9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  1036cd:	74 22                	je     1036f1 <writei+0x181>
  1036cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1036d2:	8b 40 18             	mov    0x18(%eax),%eax
  1036d5:	39 45 10             	cmp    %eax,0x10(%ebp)
  1036d8:	76 17                	jbe    1036f1 <writei+0x181>
    ip->size = off;
  1036da:	8b 45 08             	mov    0x8(%ebp),%eax
  1036dd:	8b 55 10             	mov    0x10(%ebp),%edx
  1036e0:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
  1036e3:	83 ec 0c             	sub    $0xc,%esp
  1036e6:	ff 75 08             	push   0x8(%ebp)
  1036e9:	e8 2c f8 ff ff       	call   102f1a <iupdate>
  1036ee:	83 c4 10             	add    $0x10,%esp
  }
  return n;
  1036f1:	8b 45 14             	mov    0x14(%ebp),%eax
}
  1036f4:	c9                   	leave  
  1036f5:	c3                   	ret    

001036f6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  1036f6:	55                   	push   %ebp
  1036f7:	89 e5                	mov    %esp,%ebp
  1036f9:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
  1036fc:	83 ec 04             	sub    $0x4,%esp
  1036ff:	6a 0e                	push   $0xe
  103701:	ff 75 0c             	push   0xc(%ebp)
  103704:	ff 75 08             	push   0x8(%ebp)
  103707:	e8 47 d9 ff ff       	call   101053 <strncmp>
  10370c:	83 c4 10             	add    $0x10,%esp
}
  10370f:	c9                   	leave  
  103710:	c3                   	ret    

00103711 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  103711:	55                   	push   %ebp
  103712:	89 e5                	mov    %esp,%ebp
  103714:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
  103717:	8b 45 08             	mov    0x8(%ebp),%eax
  10371a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  10371e:	66 83 f8 01          	cmp    $0x1,%ax
  103722:	74 0d                	je     103731 <dirlookup+0x20>
    panic("dirlookup not DIR");
  103724:	83 ec 0c             	sub    $0xc,%esp
  103727:	68 61 59 10 00       	push   $0x105961
  10372c:	e8 7c cb ff ff       	call   1002ad <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
  103731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103738:	eb 7b                	jmp    1037b5 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10373a:	6a 10                	push   $0x10
  10373c:	ff 75 f4             	push   -0xc(%ebp)
  10373f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103742:	50                   	push   %eax
  103743:	ff 75 08             	push   0x8(%ebp)
  103746:	e8 c4 fc ff ff       	call   10340f <readi>
  10374b:	83 c4 10             	add    $0x10,%esp
  10374e:	83 f8 10             	cmp    $0x10,%eax
  103751:	74 0d                	je     103760 <dirlookup+0x4f>
      panic("dirlookup read");
  103753:	83 ec 0c             	sub    $0xc,%esp
  103756:	68 73 59 10 00       	push   $0x105973
  10375b:	e8 4d cb ff ff       	call   1002ad <panic>
    if(de.inum == 0)
  103760:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103764:	66 85 c0             	test   %ax,%ax
  103767:	74 47                	je     1037b0 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
  103769:	83 ec 08             	sub    $0x8,%esp
  10376c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10376f:	83 c0 02             	add    $0x2,%eax
  103772:	50                   	push   %eax
  103773:	ff 75 0c             	push   0xc(%ebp)
  103776:	e8 7b ff ff ff       	call   1036f6 <namecmp>
  10377b:	83 c4 10             	add    $0x10,%esp
  10377e:	85 c0                	test   %eax,%eax
  103780:	75 2f                	jne    1037b1 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
  103782:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103786:	74 08                	je     103790 <dirlookup+0x7f>
        *poff = off;
  103788:	8b 45 10             	mov    0x10(%ebp),%eax
  10378b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10378e:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
  103790:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103794:	0f b7 c0             	movzwl %ax,%eax
  103797:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
  10379a:	8b 45 08             	mov    0x8(%ebp),%eax
  10379d:	8b 00                	mov    (%eax),%eax
  10379f:	83 ec 08             	sub    $0x8,%esp
  1037a2:	ff 75 f0             	push   -0x10(%ebp)
  1037a5:	50                   	push   %eax
  1037a6:	e8 30 f8 ff ff       	call   102fdb <iget>
  1037ab:	83 c4 10             	add    $0x10,%esp
  1037ae:	eb 19                	jmp    1037c9 <dirlookup+0xb8>
      continue;
  1037b0:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
  1037b1:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
  1037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1037b8:	8b 40 18             	mov    0x18(%eax),%eax
  1037bb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1037be:	0f 82 76 ff ff ff    	jb     10373a <dirlookup+0x29>
    }
  }

  return 0;
  1037c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1037c9:	c9                   	leave  
  1037ca:	c3                   	ret    

001037cb <dirlink>:


// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
  1037cb:	55                   	push   %ebp
  1037cc:	89 e5                	mov    %esp,%ebp
  1037ce:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  1037d1:	83 ec 04             	sub    $0x4,%esp
  1037d4:	6a 00                	push   $0x0
  1037d6:	ff 75 0c             	push   0xc(%ebp)
  1037d9:	ff 75 08             	push   0x8(%ebp)
  1037dc:	e8 30 ff ff ff       	call   103711 <dirlookup>
  1037e1:	83 c4 10             	add    $0x10,%esp
  1037e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1037eb:	74 18                	je     103805 <dirlink+0x3a>
    iput(ip);
  1037ed:	83 ec 0c             	sub    $0xc,%esp
  1037f0:	ff 75 f0             	push   -0x10(%ebp)
  1037f3:	e8 b6 f6 ff ff       	call   102eae <iput>
  1037f8:	83 c4 10             	add    $0x10,%esp
    return -1;
  1037fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103800:	e9 9c 00 00 00       	jmp    1038a1 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  103805:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10380c:	eb 39                	jmp    103847 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103811:	6a 10                	push   $0x10
  103813:	50                   	push   %eax
  103814:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103817:	50                   	push   %eax
  103818:	ff 75 08             	push   0x8(%ebp)
  10381b:	e8 ef fb ff ff       	call   10340f <readi>
  103820:	83 c4 10             	add    $0x10,%esp
  103823:	83 f8 10             	cmp    $0x10,%eax
  103826:	74 0d                	je     103835 <dirlink+0x6a>
      panic("dirlink read");
  103828:	83 ec 0c             	sub    $0xc,%esp
  10382b:	68 82 59 10 00       	push   $0x105982
  103830:	e8 78 ca ff ff       	call   1002ad <panic>
    if(de.inum == 0)
  103835:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103839:	66 85 c0             	test   %ax,%ax
  10383c:	74 18                	je     103856 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
  10383e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103841:	83 c0 10             	add    $0x10,%eax
  103844:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103847:	8b 45 08             	mov    0x8(%ebp),%eax
  10384a:	8b 50 18             	mov    0x18(%eax),%edx
  10384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103850:	39 c2                	cmp    %eax,%edx
  103852:	77 ba                	ja     10380e <dirlink+0x43>
  103854:	eb 01                	jmp    103857 <dirlink+0x8c>
      break;
  103856:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
  103857:	83 ec 04             	sub    $0x4,%esp
  10385a:	6a 0e                	push   $0xe
  10385c:	ff 75 0c             	push   0xc(%ebp)
  10385f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103862:	83 c0 02             	add    $0x2,%eax
  103865:	50                   	push   %eax
  103866:	e8 3e d8 ff ff       	call   1010a9 <strncpy>
  10386b:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
  10386e:	8b 45 10             	mov    0x10(%ebp),%eax
  103871:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103878:	6a 10                	push   $0x10
  10387a:	50                   	push   %eax
  10387b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10387e:	50                   	push   %eax
  10387f:	ff 75 08             	push   0x8(%ebp)
  103882:	e8 e9 fc ff ff       	call   103570 <writei>
  103887:	83 c4 10             	add    $0x10,%esp
  10388a:	83 f8 10             	cmp    $0x10,%eax
  10388d:	74 0d                	je     10389c <dirlink+0xd1>
    panic("dirlink");
  10388f:	83 ec 0c             	sub    $0xc,%esp
  103892:	68 8f 59 10 00       	push   $0x10598f
  103897:	e8 11 ca ff ff       	call   1002ad <panic>

  return 0;
  10389c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1038a1:	c9                   	leave  
  1038a2:	c3                   	ret    

001038a3 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
  1038a3:	55                   	push   %ebp
  1038a4:	89 e5                	mov    %esp,%ebp
  1038a6:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
  1038a9:	eb 04                	jmp    1038af <skipelem+0xc>
    path++;
  1038ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
  1038af:	8b 45 08             	mov    0x8(%ebp),%eax
  1038b2:	0f b6 00             	movzbl (%eax),%eax
  1038b5:	3c 2f                	cmp    $0x2f,%al
  1038b7:	74 f2                	je     1038ab <skipelem+0x8>
  if(*path == 0)
  1038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1038bc:	0f b6 00             	movzbl (%eax),%eax
  1038bf:	84 c0                	test   %al,%al
  1038c1:	75 07                	jne    1038ca <skipelem+0x27>
    return 0;
  1038c3:	b8 00 00 00 00       	mov    $0x0,%eax
  1038c8:	eb 77                	jmp    103941 <skipelem+0x9e>
  s = path;
  1038ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1038cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
  1038d0:	eb 04                	jmp    1038d6 <skipelem+0x33>
    path++;
  1038d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
  1038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1038d9:	0f b6 00             	movzbl (%eax),%eax
  1038dc:	3c 2f                	cmp    $0x2f,%al
  1038de:	74 0a                	je     1038ea <skipelem+0x47>
  1038e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1038e3:	0f b6 00             	movzbl (%eax),%eax
  1038e6:	84 c0                	test   %al,%al
  1038e8:	75 e8                	jne    1038d2 <skipelem+0x2f>
  len = path - s;
  1038ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1038ed:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1038f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
  1038f3:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1038f7:	7e 15                	jle    10390e <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
  1038f9:	83 ec 04             	sub    $0x4,%esp
  1038fc:	6a 0e                	push   $0xe
  1038fe:	ff 75 f4             	push   -0xc(%ebp)
  103901:	ff 75 0c             	push   0xc(%ebp)
  103904:	e8 b4 d6 ff ff       	call   100fbd <memmove>
  103909:	83 c4 10             	add    $0x10,%esp
  10390c:	eb 26                	jmp    103934 <skipelem+0x91>
  else {
    memmove(name, s, len);
  10390e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103911:	83 ec 04             	sub    $0x4,%esp
  103914:	50                   	push   %eax
  103915:	ff 75 f4             	push   -0xc(%ebp)
  103918:	ff 75 0c             	push   0xc(%ebp)
  10391b:	e8 9d d6 ff ff       	call   100fbd <memmove>
  103920:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
  103923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103926:	8b 45 0c             	mov    0xc(%ebp),%eax
  103929:	01 d0                	add    %edx,%eax
  10392b:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
  10392e:	eb 04                	jmp    103934 <skipelem+0x91>
    path++;
  103930:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
  103934:	8b 45 08             	mov    0x8(%ebp),%eax
  103937:	0f b6 00             	movzbl (%eax),%eax
  10393a:	3c 2f                	cmp    $0x2f,%al
  10393c:	74 f2                	je     103930 <skipelem+0x8d>
  return path;
  10393e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103941:	c9                   	leave  
  103942:	c3                   	ret    

00103943 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  103943:	55                   	push   %ebp
  103944:	89 e5                	mov    %esp,%ebp
  103946:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  ip = iget(ROOTDEV, ROOTINO);
  103949:	83 ec 08             	sub    $0x8,%esp
  10394c:	6a 01                	push   $0x1
  10394e:	6a 01                	push   $0x1
  103950:	e8 86 f6 ff ff       	call   102fdb <iget>
  103955:	83 c4 10             	add    $0x10,%esp
  103958:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
  10395b:	e9 90 00 00 00       	jmp    1039f0 <namex+0xad>
    iread(ip);
  103960:	83 ec 0c             	sub    $0xc,%esp
  103963:	ff 75 f4             	push   -0xc(%ebp)
  103966:	e8 1f f7 ff ff       	call   10308a <iread>
  10396b:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
  10396e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103971:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103975:	66 83 f8 01          	cmp    $0x1,%ax
  103979:	74 18                	je     103993 <namex+0x50>
      iput(ip);
  10397b:	83 ec 0c             	sub    $0xc,%esp
  10397e:	ff 75 f4             	push   -0xc(%ebp)
  103981:	e8 28 f5 ff ff       	call   102eae <iput>
  103986:	83 c4 10             	add    $0x10,%esp
      return 0;
  103989:	b8 00 00 00 00       	mov    $0x0,%eax
  10398e:	e9 99 00 00 00       	jmp    103a2c <namex+0xe9>
    }
    if(nameiparent && *path == '\0'){
  103993:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103997:	74 12                	je     1039ab <namex+0x68>
  103999:	8b 45 08             	mov    0x8(%ebp),%eax
  10399c:	0f b6 00             	movzbl (%eax),%eax
  10399f:	84 c0                	test   %al,%al
  1039a1:	75 08                	jne    1039ab <namex+0x68>
      // Stop one level early.
      return ip;
  1039a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039a6:	e9 81 00 00 00       	jmp    103a2c <namex+0xe9>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  1039ab:	83 ec 04             	sub    $0x4,%esp
  1039ae:	6a 00                	push   $0x0
  1039b0:	ff 75 10             	push   0x10(%ebp)
  1039b3:	ff 75 f4             	push   -0xc(%ebp)
  1039b6:	e8 56 fd ff ff       	call   103711 <dirlookup>
  1039bb:	83 c4 10             	add    $0x10,%esp
  1039be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039c5:	75 15                	jne    1039dc <namex+0x99>
      iput(ip);
  1039c7:	83 ec 0c             	sub    $0xc,%esp
  1039ca:	ff 75 f4             	push   -0xc(%ebp)
  1039cd:	e8 dc f4 ff ff       	call   102eae <iput>
  1039d2:	83 c4 10             	add    $0x10,%esp
      return 0;
  1039d5:	b8 00 00 00 00       	mov    $0x0,%eax
  1039da:	eb 50                	jmp    103a2c <namex+0xe9>
    }
    iput(ip);
  1039dc:	83 ec 0c             	sub    $0xc,%esp
  1039df:	ff 75 f4             	push   -0xc(%ebp)
  1039e2:	e8 c7 f4 ff ff       	call   102eae <iput>
  1039e7:	83 c4 10             	add    $0x10,%esp
    ip = next;
  1039ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
  1039f0:	83 ec 08             	sub    $0x8,%esp
  1039f3:	ff 75 10             	push   0x10(%ebp)
  1039f6:	ff 75 08             	push   0x8(%ebp)
  1039f9:	e8 a5 fe ff ff       	call   1038a3 <skipelem>
  1039fe:	83 c4 10             	add    $0x10,%esp
  103a01:	89 45 08             	mov    %eax,0x8(%ebp)
  103a04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103a08:	0f 85 52 ff ff ff    	jne    103960 <namex+0x1d>
  }
  if(nameiparent){
  103a0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103a12:	74 15                	je     103a29 <namex+0xe6>
    iput(ip);
  103a14:	83 ec 0c             	sub    $0xc,%esp
  103a17:	ff 75 f4             	push   -0xc(%ebp)
  103a1a:	e8 8f f4 ff ff       	call   102eae <iput>
  103a1f:	83 c4 10             	add    $0x10,%esp
    return 0;
  103a22:	b8 00 00 00 00       	mov    $0x0,%eax
  103a27:	eb 03                	jmp    103a2c <namex+0xe9>
  }
  return ip;
  103a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103a2c:	c9                   	leave  
  103a2d:	c3                   	ret    

00103a2e <namei>:

struct inode*
namei(char *path)
{
  103a2e:	55                   	push   %ebp
  103a2f:	89 e5                	mov    %esp,%ebp
  103a31:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
  103a34:	83 ec 04             	sub    $0x4,%esp
  103a37:	8d 45 ea             	lea    -0x16(%ebp),%eax
  103a3a:	50                   	push   %eax
  103a3b:	6a 00                	push   $0x0
  103a3d:	ff 75 08             	push   0x8(%ebp)
  103a40:	e8 fe fe ff ff       	call   103943 <namex>
  103a45:	83 c4 10             	add    $0x10,%esp
}
  103a48:	c9                   	leave  
  103a49:	c3                   	ret    

00103a4a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
  103a4a:	55                   	push   %ebp
  103a4b:	89 e5                	mov    %esp,%ebp
  103a4d:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
  103a50:	83 ec 04             	sub    $0x4,%esp
  103a53:	ff 75 0c             	push   0xc(%ebp)
  103a56:	6a 01                	push   $0x1
  103a58:	ff 75 08             	push   0x8(%ebp)
  103a5b:	e8 e3 fe ff ff       	call   103943 <namex>
  103a60:	83 c4 10             	add    $0x10,%esp
}
  103a63:	c9                   	leave  
  103a64:	c3                   	ret    

00103a65 <filealloc>:
} ftable;

// Allocate a file structure.
struct file*
filealloc(void)
{
  103a65:	55                   	push   %ebp
  103a66:	89 e5                	mov    %esp,%ebp
  103a68:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  for(f = ftable.file; f < ftable.file + NFILE; f++){
  103a6b:	c7 45 fc 60 e2 10 00 	movl   $0x10e260,-0x4(%ebp)
  103a72:	eb 1d                	jmp    103a91 <filealloc+0x2c>
    if(f->ref == 0){
  103a74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103a77:	8b 40 04             	mov    0x4(%eax),%eax
  103a7a:	85 c0                	test   %eax,%eax
  103a7c:	75 0f                	jne    103a8d <filealloc+0x28>
      f->ref = 1;
  103a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103a81:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      return f;
  103a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103a8b:	eb 13                	jmp    103aa0 <filealloc+0x3b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
  103a8d:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
  103a91:	b8 30 ea 10 00       	mov    $0x10ea30,%eax
  103a96:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  103a99:	72 d9                	jb     103a74 <filealloc+0xf>
    }
  }
  return 0;
  103a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103aa0:	c9                   	leave  
  103aa1:	c3                   	ret    

00103aa2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  103aa2:	55                   	push   %ebp
  103aa3:	89 e5                	mov    %esp,%ebp
  103aa5:	83 ec 08             	sub    $0x8,%esp
  if(f->ref < 1)
  103aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  103aab:	8b 40 04             	mov    0x4(%eax),%eax
  103aae:	85 c0                	test   %eax,%eax
  103ab0:	7f 0d                	jg     103abf <filedup+0x1d>
    panic("filedup");
  103ab2:	83 ec 0c             	sub    $0xc,%esp
  103ab5:	68 97 59 10 00       	push   $0x105997
  103aba:	e8 ee c7 ff ff       	call   1002ad <panic>
  f->ref++;
  103abf:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac2:	8b 40 04             	mov    0x4(%eax),%eax
  103ac5:	8d 50 01             	lea    0x1(%eax),%edx
  103ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  103acb:	89 50 04             	mov    %edx,0x4(%eax)
  return f;
  103ace:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103ad1:	c9                   	leave  
  103ad2:	c3                   	ret    

00103ad3 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  103ad3:	55                   	push   %ebp
  103ad4:	89 e5                	mov    %esp,%ebp
  103ad6:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  if(f->ref < 1)
  103ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  103adc:	8b 40 04             	mov    0x4(%eax),%eax
  103adf:	85 c0                	test   %eax,%eax
  103ae1:	7f 0d                	jg     103af0 <fileclose+0x1d>
    panic("fileclose");
  103ae3:	83 ec 0c             	sub    $0xc,%esp
  103ae6:	68 9f 59 10 00       	push   $0x10599f
  103aeb:	e8 bd c7 ff ff       	call   1002ad <panic>
  if(--f->ref > 0){
  103af0:	8b 45 08             	mov    0x8(%ebp),%eax
  103af3:	8b 40 04             	mov    0x4(%eax),%eax
  103af6:	8d 50 ff             	lea    -0x1(%eax),%edx
  103af9:	8b 45 08             	mov    0x8(%ebp),%eax
  103afc:	89 50 04             	mov    %edx,0x4(%eax)
  103aff:	8b 45 08             	mov    0x8(%ebp),%eax
  103b02:	8b 40 04             	mov    0x4(%eax),%eax
  103b05:	85 c0                	test   %eax,%eax
  103b07:	7f 56                	jg     103b5f <fileclose+0x8c>
    return;
  }
  ff = *f;
  103b09:	8b 45 08             	mov    0x8(%ebp),%eax
  103b0c:	8b 10                	mov    (%eax),%edx
  103b0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103b11:	8b 50 04             	mov    0x4(%eax),%edx
  103b14:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103b17:	8b 50 08             	mov    0x8(%eax),%edx
  103b1a:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103b1d:	8b 50 0c             	mov    0xc(%eax),%edx
  103b20:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103b23:	8b 40 10             	mov    0x10(%eax),%eax
  103b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
  103b29:	8b 45 08             	mov    0x8(%ebp),%eax
  103b2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
  103b33:	8b 45 08             	mov    0x8(%ebp),%eax
  103b36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(ff.type == FD_INODE){
  103b3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b3f:	83 f8 01             	cmp    $0x1,%eax
  103b42:	75 1c                	jne    103b60 <fileclose+0x8d>
    begin_op();
  103b44:	e8 aa 09 00 00       	call   1044f3 <begin_op>
    iput(ff.ip);
  103b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b4c:	83 ec 0c             	sub    $0xc,%esp
  103b4f:	50                   	push   %eax
  103b50:	e8 59 f3 ff ff       	call   102eae <iput>
  103b55:	83 c4 10             	add    $0x10,%esp
    end_op();
  103b58:	e8 9c 09 00 00       	call   1044f9 <end_op>
  103b5d:	eb 01                	jmp    103b60 <fileclose+0x8d>
    return;
  103b5f:	90                   	nop
  }
}
  103b60:	c9                   	leave  
  103b61:	c3                   	ret    

00103b62 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  103b62:	55                   	push   %ebp
  103b63:	89 e5                	mov    %esp,%ebp
  103b65:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
  103b68:	8b 45 08             	mov    0x8(%ebp),%eax
  103b6b:	8b 00                	mov    (%eax),%eax
  103b6d:	83 f8 01             	cmp    $0x1,%eax
  103b70:	75 2e                	jne    103ba0 <filestat+0x3e>
    iread(f->ip);
  103b72:	8b 45 08             	mov    0x8(%ebp),%eax
  103b75:	8b 40 0c             	mov    0xc(%eax),%eax
  103b78:	83 ec 0c             	sub    $0xc,%esp
  103b7b:	50                   	push   %eax
  103b7c:	e8 09 f5 ff ff       	call   10308a <iread>
  103b81:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
  103b84:	8b 45 08             	mov    0x8(%ebp),%eax
  103b87:	8b 40 0c             	mov    0xc(%eax),%eax
  103b8a:	83 ec 08             	sub    $0x8,%esp
  103b8d:	ff 75 0c             	push   0xc(%ebp)
  103b90:	50                   	push   %eax
  103b91:	e8 33 f8 ff ff       	call   1033c9 <stati>
  103b96:	83 c4 10             	add    $0x10,%esp
    return 0;
  103b99:	b8 00 00 00 00       	mov    $0x0,%eax
  103b9e:	eb 05                	jmp    103ba5 <filestat+0x43>
  }
  return -1;
  103ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  103ba5:	c9                   	leave  
  103ba6:	c3                   	ret    

00103ba7 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
  103ba7:	55                   	push   %ebp
  103ba8:	89 e5                	mov    %esp,%ebp
  103baa:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
  103bad:	8b 45 08             	mov    0x8(%ebp),%eax
  103bb0:	0f b6 40 08          	movzbl 0x8(%eax),%eax
  103bb4:	84 c0                	test   %al,%al
  103bb6:	75 07                	jne    103bbf <fileread+0x18>
    return -1;
  103bb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103bbd:	eb 65                	jmp    103c24 <fileread+0x7d>
  if(f->type == FD_INODE){
  103bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  103bc2:	8b 00                	mov    (%eax),%eax
  103bc4:	83 f8 01             	cmp    $0x1,%eax
  103bc7:	75 4e                	jne    103c17 <fileread+0x70>
    iread(f->ip);
  103bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  103bcc:	8b 40 0c             	mov    0xc(%eax),%eax
  103bcf:	83 ec 0c             	sub    $0xc,%esp
  103bd2:	50                   	push   %eax
  103bd3:	e8 b2 f4 ff ff       	call   10308a <iread>
  103bd8:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  103bdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103bde:	8b 45 08             	mov    0x8(%ebp),%eax
  103be1:	8b 50 10             	mov    0x10(%eax),%edx
  103be4:	8b 45 08             	mov    0x8(%ebp),%eax
  103be7:	8b 40 0c             	mov    0xc(%eax),%eax
  103bea:	51                   	push   %ecx
  103beb:	52                   	push   %edx
  103bec:	ff 75 0c             	push   0xc(%ebp)
  103bef:	50                   	push   %eax
  103bf0:	e8 1a f8 ff ff       	call   10340f <readi>
  103bf5:	83 c4 10             	add    $0x10,%esp
  103bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103bfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103bff:	7e 11                	jle    103c12 <fileread+0x6b>
      f->off += r;
  103c01:	8b 45 08             	mov    0x8(%ebp),%eax
  103c04:	8b 50 10             	mov    0x10(%eax),%edx
  103c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c0a:	01 c2                	add    %eax,%edx
  103c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  103c0f:	89 50 10             	mov    %edx,0x10(%eax)
    return r;
  103c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c15:	eb 0d                	jmp    103c24 <fileread+0x7d>
  }
  panic("fileread");
  103c17:	83 ec 0c             	sub    $0xc,%esp
  103c1a:	68 a9 59 10 00       	push   $0x1059a9
  103c1f:	e8 89 c6 ff ff       	call   1002ad <panic>
}
  103c24:	c9                   	leave  
  103c25:	c3                   	ret    

00103c26 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
  103c26:	55                   	push   %ebp
  103c27:	89 e5                	mov    %esp,%ebp
  103c29:	53                   	push   %ebx
  103c2a:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
  103c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  103c30:	0f b6 40 09          	movzbl 0x9(%eax),%eax
  103c34:	84 c0                	test   %al,%al
  103c36:	75 0a                	jne    103c42 <filewrite+0x1c>
    return -1;
  103c38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103c3d:	e9 e2 00 00 00       	jmp    103d24 <filewrite+0xfe>
  if(f->type == FD_INODE){
  103c42:	8b 45 08             	mov    0x8(%ebp),%eax
  103c45:	8b 00                	mov    (%eax),%eax
  103c47:	83 f8 01             	cmp    $0x1,%eax
  103c4a:	0f 85 c7 00 00 00    	jne    103d17 <filewrite+0xf1>
    // write a few blocks at a time
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
  103c50:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
  103c57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
  103c5e:	e9 91 00 00 00       	jmp    103cf4 <filewrite+0xce>
      int n1 = n - i;
  103c63:	8b 45 10             	mov    0x10(%ebp),%eax
  103c66:	2b 45 f4             	sub    -0xc(%ebp),%eax
  103c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
  103c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c6f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103c72:	7e 06                	jle    103c7a <filewrite+0x54>
        n1 = max;
  103c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c77:	89 45 f0             	mov    %eax,-0x10(%ebp)

			begin_op();
  103c7a:	e8 74 08 00 00       	call   1044f3 <begin_op>
      iread(f->ip);
  103c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  103c82:	8b 40 0c             	mov    0xc(%eax),%eax
  103c85:	83 ec 0c             	sub    $0xc,%esp
  103c88:	50                   	push   %eax
  103c89:	e8 fc f3 ff ff       	call   10308a <iread>
  103c8e:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
  103c91:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103c94:	8b 45 08             	mov    0x8(%ebp),%eax
  103c97:	8b 50 10             	mov    0x10(%eax),%edx
  103c9a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103ca0:	01 c3                	add    %eax,%ebx
  103ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  103ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  103ca8:	51                   	push   %ecx
  103ca9:	52                   	push   %edx
  103caa:	53                   	push   %ebx
  103cab:	50                   	push   %eax
  103cac:	e8 bf f8 ff ff       	call   103570 <writei>
  103cb1:	83 c4 10             	add    $0x10,%esp
  103cb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103cb7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103cbb:	7e 11                	jle    103cce <filewrite+0xa8>
        f->off += r;
  103cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  103cc0:	8b 50 10             	mov    0x10(%eax),%edx
  103cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103cc6:	01 c2                	add    %eax,%edx
  103cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  103ccb:	89 50 10             	mov    %edx,0x10(%eax)
      end_op();
  103cce:	e8 26 08 00 00       	call   1044f9 <end_op>

      if(r < 0)
  103cd3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103cd7:	78 29                	js     103d02 <filewrite+0xdc>
        break;
      if(r != n1)
  103cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103cdc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103cdf:	74 0d                	je     103cee <filewrite+0xc8>
        panic("short filewrite");
  103ce1:	83 ec 0c             	sub    $0xc,%esp
  103ce4:	68 b2 59 10 00       	push   $0x1059b2
  103ce9:	e8 bf c5 ff ff       	call   1002ad <panic>
      i += r;
  103cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103cf1:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
  103cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cf7:	3b 45 10             	cmp    0x10(%ebp),%eax
  103cfa:	0f 8c 63 ff ff ff    	jl     103c63 <filewrite+0x3d>
  103d00:	eb 01                	jmp    103d03 <filewrite+0xdd>
        break;
  103d02:	90                   	nop
    }
    return i == n ? n : -1;
  103d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d06:	3b 45 10             	cmp    0x10(%ebp),%eax
  103d09:	75 05                	jne    103d10 <filewrite+0xea>
  103d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  103d0e:	eb 14                	jmp    103d24 <filewrite+0xfe>
  103d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103d15:	eb 0d                	jmp    103d24 <filewrite+0xfe>
  }
  panic("filewrite");
  103d17:	83 ec 0c             	sub    $0xc,%esp
  103d1a:	68 c2 59 10 00       	push   $0x1059c2
  103d1f:	e8 89 c5 ff ff       	call   1002ad <panic>
}
  103d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103d27:	c9                   	leave  
  103d28:	c3                   	ret    

00103d29 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
  103d29:	55                   	push   %ebp
  103d2a:	89 e5                	mov    %esp,%ebp
  103d2c:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  103d2f:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
  103d36:	eb 40                	jmp    103d78 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d3b:	6a 10                	push   $0x10
  103d3d:	50                   	push   %eax
  103d3e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  103d41:	50                   	push   %eax
  103d42:	ff 75 08             	push   0x8(%ebp)
  103d45:	e8 c5 f6 ff ff       	call   10340f <readi>
  103d4a:	83 c4 10             	add    $0x10,%esp
  103d4d:	83 f8 10             	cmp    $0x10,%eax
  103d50:	74 0d                	je     103d5f <isdirempty+0x36>
      panic("isdirempty: readi");
  103d52:	83 ec 0c             	sub    $0xc,%esp
  103d55:	68 cc 59 10 00       	push   $0x1059cc
  103d5a:	e8 4e c5 ff ff       	call   1002ad <panic>
    if(de.inum != 0)
  103d5f:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  103d63:	66 85 c0             	test   %ax,%ax
  103d66:	74 07                	je     103d6f <isdirempty+0x46>
      return 0;
  103d68:	b8 00 00 00 00       	mov    $0x0,%eax
  103d6d:	eb 1b                	jmp    103d8a <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  103d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d72:	83 c0 10             	add    $0x10,%eax
  103d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103d78:	8b 45 08             	mov    0x8(%ebp),%eax
  103d7b:	8b 50 18             	mov    0x18(%eax),%edx
  103d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d81:	39 c2                	cmp    %eax,%edx
  103d83:	77 b3                	ja     103d38 <isdirempty+0xf>
  }
  return 1;
  103d85:	b8 01 00 00 00       	mov    $0x1,%eax
}
  103d8a:	c9                   	leave  
  103d8b:	c3                   	ret    

00103d8c <unlink>:

int
unlink(char* path, char* name)
{
  103d8c:	55                   	push   %ebp
  103d8d:	89 e5                	mov    %esp,%ebp
  103d8f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *dp;
  struct dirent de;
  uint off;

	begin_op();
  103d92:	e8 5c 07 00 00       	call   1044f3 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
  103d97:	83 ec 08             	sub    $0x8,%esp
  103d9a:	ff 75 0c             	push   0xc(%ebp)
  103d9d:	ff 75 08             	push   0x8(%ebp)
  103da0:	e8 a5 fc ff ff       	call   103a4a <nameiparent>
  103da5:	83 c4 10             	add    $0x10,%esp
  103da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103dab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103daf:	75 0f                	jne    103dc0 <unlink+0x34>
    end_op();
  103db1:	e8 43 07 00 00       	call   1044f9 <end_op>
    return -1;
  103db6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103dbb:	e9 8c 01 00 00       	jmp    103f4c <unlink+0x1c0>
  }

  iread(dp);
  103dc0:	83 ec 0c             	sub    $0xc,%esp
  103dc3:	ff 75 f4             	push   -0xc(%ebp)
  103dc6:	e8 bf f2 ff ff       	call   10308a <iread>
  103dcb:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
  103dce:	83 ec 08             	sub    $0x8,%esp
  103dd1:	68 de 59 10 00       	push   $0x1059de
  103dd6:	ff 75 0c             	push   0xc(%ebp)
  103dd9:	e8 18 f9 ff ff       	call   1036f6 <namecmp>
  103dde:	83 c4 10             	add    $0x10,%esp
  103de1:	85 c0                	test   %eax,%eax
  103de3:	0f 84 47 01 00 00    	je     103f30 <unlink+0x1a4>
  103de9:	83 ec 08             	sub    $0x8,%esp
  103dec:	68 e0 59 10 00       	push   $0x1059e0
  103df1:	ff 75 0c             	push   0xc(%ebp)
  103df4:	e8 fd f8 ff ff       	call   1036f6 <namecmp>
  103df9:	83 c4 10             	add    $0x10,%esp
  103dfc:	85 c0                	test   %eax,%eax
  103dfe:	0f 84 2c 01 00 00    	je     103f30 <unlink+0x1a4>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
  103e04:	83 ec 04             	sub    $0x4,%esp
  103e07:	8d 45 dc             	lea    -0x24(%ebp),%eax
  103e0a:	50                   	push   %eax
  103e0b:	ff 75 0c             	push   0xc(%ebp)
  103e0e:	ff 75 f4             	push   -0xc(%ebp)
  103e11:	e8 fb f8 ff ff       	call   103711 <dirlookup>
  103e16:	83 c4 10             	add    $0x10,%esp
  103e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103e20:	0f 84 0d 01 00 00    	je     103f33 <unlink+0x1a7>
    goto bad;
  iread(ip);
  103e26:	83 ec 0c             	sub    $0xc,%esp
  103e29:	ff 75 f0             	push   -0x10(%ebp)
  103e2c:	e8 59 f2 ff ff       	call   10308a <iread>
  103e31:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
  103e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e37:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103e3b:	66 85 c0             	test   %ax,%ax
  103e3e:	7f 0d                	jg     103e4d <unlink+0xc1>
    panic("unlink: nlink < 1");
  103e40:	83 ec 0c             	sub    $0xc,%esp
  103e43:	68 e3 59 10 00       	push   $0x1059e3
  103e48:	e8 60 c4 ff ff       	call   1002ad <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
  103e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e50:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103e54:	66 83 f8 01          	cmp    $0x1,%ax
  103e58:	75 25                	jne    103e7f <unlink+0xf3>
  103e5a:	83 ec 0c             	sub    $0xc,%esp
  103e5d:	ff 75 f0             	push   -0x10(%ebp)
  103e60:	e8 c4 fe ff ff       	call   103d29 <isdirempty>
  103e65:	83 c4 10             	add    $0x10,%esp
  103e68:	85 c0                	test   %eax,%eax
  103e6a:	75 13                	jne    103e7f <unlink+0xf3>
    iput(ip);
  103e6c:	83 ec 0c             	sub    $0xc,%esp
  103e6f:	ff 75 f0             	push   -0x10(%ebp)
  103e72:	e8 37 f0 ff ff       	call   102eae <iput>
  103e77:	83 c4 10             	add    $0x10,%esp
    goto bad;
  103e7a:	e9 b5 00 00 00       	jmp    103f34 <unlink+0x1a8>
  }

  memset(&de, 0, sizeof(de));
  103e7f:	83 ec 04             	sub    $0x4,%esp
  103e82:	6a 10                	push   $0x10
  103e84:	6a 00                	push   $0x0
  103e86:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103e89:	50                   	push   %eax
  103e8a:	e8 6f d0 ff ff       	call   100efe <memset>
  103e8f:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103e92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103e95:	6a 10                	push   $0x10
  103e97:	50                   	push   %eax
  103e98:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103e9b:	50                   	push   %eax
  103e9c:	ff 75 f4             	push   -0xc(%ebp)
  103e9f:	e8 cc f6 ff ff       	call   103570 <writei>
  103ea4:	83 c4 10             	add    $0x10,%esp
  103ea7:	83 f8 10             	cmp    $0x10,%eax
  103eaa:	74 0d                	je     103eb9 <unlink+0x12d>
    panic("unlink: writei");
  103eac:	83 ec 0c             	sub    $0xc,%esp
  103eaf:	68 f5 59 10 00       	push   $0x1059f5
  103eb4:	e8 f4 c3 ff ff       	call   1002ad <panic>
  if(ip->type == T_DIR){
  103eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ebc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103ec0:	66 83 f8 01          	cmp    $0x1,%ax
  103ec4:	75 21                	jne    103ee7 <unlink+0x15b>
    dp->nlink--;
  103ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ec9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103ecd:	83 e8 01             	sub    $0x1,%eax
  103ed0:	89 c2                	mov    %eax,%edx
  103ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ed5:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
  103ed9:	83 ec 0c             	sub    $0xc,%esp
  103edc:	ff 75 f4             	push   -0xc(%ebp)
  103edf:	e8 36 f0 ff ff       	call   102f1a <iupdate>
  103ee4:	83 c4 10             	add    $0x10,%esp
  }
  iput(dp);
  103ee7:	83 ec 0c             	sub    $0xc,%esp
  103eea:	ff 75 f4             	push   -0xc(%ebp)
  103eed:	e8 bc ef ff ff       	call   102eae <iput>
  103ef2:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
  103ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ef8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103efc:	83 e8 01             	sub    $0x1,%eax
  103eff:	89 c2                	mov    %eax,%edx
  103f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f04:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
  103f08:	83 ec 0c             	sub    $0xc,%esp
  103f0b:	ff 75 f0             	push   -0x10(%ebp)
  103f0e:	e8 07 f0 ff ff       	call   102f1a <iupdate>
  103f13:	83 c4 10             	add    $0x10,%esp
  iput(ip);
  103f16:	83 ec 0c             	sub    $0xc,%esp
  103f19:	ff 75 f0             	push   -0x10(%ebp)
  103f1c:	e8 8d ef ff ff       	call   102eae <iput>
  103f21:	83 c4 10             	add    $0x10,%esp

  end_op();
  103f24:	e8 d0 05 00 00       	call   1044f9 <end_op>
  return 0;
  103f29:	b8 00 00 00 00       	mov    $0x0,%eax
  103f2e:	eb 1c                	jmp    103f4c <unlink+0x1c0>
    goto bad;
  103f30:	90                   	nop
  103f31:	eb 01                	jmp    103f34 <unlink+0x1a8>
    goto bad;
  103f33:	90                   	nop

bad:
  iput(dp);
  103f34:	83 ec 0c             	sub    $0xc,%esp
  103f37:	ff 75 f4             	push   -0xc(%ebp)
  103f3a:	e8 6f ef ff ff       	call   102eae <iput>
  103f3f:	83 c4 10             	add    $0x10,%esp
  end_op();
  103f42:	e8 b2 05 00 00       	call   1044f9 <end_op>
  return -1;
  103f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  103f4c:	c9                   	leave  
  103f4d:	c3                   	ret    

00103f4e <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
  103f4e:	55                   	push   %ebp
  103f4f:	89 e5                	mov    %esp,%ebp
  103f51:	83 ec 38             	sub    $0x38,%esp
  103f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  103f57:	8b 55 10             	mov    0x10(%ebp),%edx
  103f5a:	8b 45 14             	mov    0x14(%ebp),%eax
  103f5d:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
  103f61:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  103f65:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  103f69:	83 ec 08             	sub    $0x8,%esp
  103f6c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103f6f:	50                   	push   %eax
  103f70:	ff 75 08             	push   0x8(%ebp)
  103f73:	e8 d2 fa ff ff       	call   103a4a <nameiparent>
  103f78:	83 c4 10             	add    $0x10,%esp
  103f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103f7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103f82:	75 0a                	jne    103f8e <create+0x40>
    return 0;
  103f84:	b8 00 00 00 00       	mov    $0x0,%eax
  103f89:	e9 8e 01 00 00       	jmp    10411c <create+0x1ce>
  iread(dp);
  103f8e:	83 ec 0c             	sub    $0xc,%esp
  103f91:	ff 75 f4             	push   -0xc(%ebp)
  103f94:	e8 f1 f0 ff ff       	call   10308a <iread>
  103f99:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
  103f9c:	83 ec 04             	sub    $0x4,%esp
  103f9f:	6a 00                	push   $0x0
  103fa1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103fa4:	50                   	push   %eax
  103fa5:	ff 75 f4             	push   -0xc(%ebp)
  103fa8:	e8 64 f7 ff ff       	call   103711 <dirlookup>
  103fad:	83 c4 10             	add    $0x10,%esp
  103fb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103fb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103fb7:	74 50                	je     104009 <create+0xbb>
    iput(dp);
  103fb9:	83 ec 0c             	sub    $0xc,%esp
  103fbc:	ff 75 f4             	push   -0xc(%ebp)
  103fbf:	e8 ea ee ff ff       	call   102eae <iput>
  103fc4:	83 c4 10             	add    $0x10,%esp
    iread(ip);
  103fc7:	83 ec 0c             	sub    $0xc,%esp
  103fca:	ff 75 f0             	push   -0x10(%ebp)
  103fcd:	e8 b8 f0 ff ff       	call   10308a <iread>
  103fd2:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
  103fd5:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
  103fda:	75 15                	jne    103ff1 <create+0xa3>
  103fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103fdf:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103fe3:	66 83 f8 02          	cmp    $0x2,%ax
  103fe7:	75 08                	jne    103ff1 <create+0xa3>
      return ip;
  103fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103fec:	e9 2b 01 00 00       	jmp    10411c <create+0x1ce>
    iput(ip);
  103ff1:	83 ec 0c             	sub    $0xc,%esp
  103ff4:	ff 75 f0             	push   -0x10(%ebp)
  103ff7:	e8 b2 ee ff ff       	call   102eae <iput>
  103ffc:	83 c4 10             	add    $0x10,%esp
    return 0;
  103fff:	b8 00 00 00 00       	mov    $0x0,%eax
  104004:	e9 13 01 00 00       	jmp    10411c <create+0x1ce>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  104009:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
  10400d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104010:	8b 00                	mov    (%eax),%eax
  104012:	83 ec 08             	sub    $0x8,%esp
  104015:	52                   	push   %edx
  104016:	50                   	push   %eax
  104017:	e8 bb ed ff ff       	call   102dd7 <ialloc>
  10401c:	83 c4 10             	add    $0x10,%esp
  10401f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104022:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104026:	75 0d                	jne    104035 <create+0xe7>
    panic("create: ialloc");
  104028:	83 ec 0c             	sub    $0xc,%esp
  10402b:	68 04 5a 10 00       	push   $0x105a04
  104030:	e8 78 c2 ff ff       	call   1002ad <panic>

  iread(ip);
  104035:	83 ec 0c             	sub    $0xc,%esp
  104038:	ff 75 f0             	push   -0x10(%ebp)
  10403b:	e8 4a f0 ff ff       	call   10308a <iread>
  104040:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
  104043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104046:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
  10404a:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
  10404e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104051:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
  104055:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
  104059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10405c:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
  104062:	83 ec 0c             	sub    $0xc,%esp
  104065:	ff 75 f0             	push   -0x10(%ebp)
  104068:	e8 ad ee ff ff       	call   102f1a <iupdate>
  10406d:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
  104070:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
  104075:	75 6a                	jne    1040e1 <create+0x193>
    dp->nlink++;  // for ".."
  104077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10407a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  10407e:	83 c0 01             	add    $0x1,%eax
  104081:	89 c2                	mov    %eax,%edx
  104083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104086:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
  10408a:	83 ec 0c             	sub    $0xc,%esp
  10408d:	ff 75 f4             	push   -0xc(%ebp)
  104090:	e8 85 ee ff ff       	call   102f1a <iupdate>
  104095:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  104098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10409b:	8b 40 04             	mov    0x4(%eax),%eax
  10409e:	83 ec 04             	sub    $0x4,%esp
  1040a1:	50                   	push   %eax
  1040a2:	68 de 59 10 00       	push   $0x1059de
  1040a7:	ff 75 f0             	push   -0x10(%ebp)
  1040aa:	e8 1c f7 ff ff       	call   1037cb <dirlink>
  1040af:	83 c4 10             	add    $0x10,%esp
  1040b2:	85 c0                	test   %eax,%eax
  1040b4:	78 1e                	js     1040d4 <create+0x186>
  1040b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040b9:	8b 40 04             	mov    0x4(%eax),%eax
  1040bc:	83 ec 04             	sub    $0x4,%esp
  1040bf:	50                   	push   %eax
  1040c0:	68 e0 59 10 00       	push   $0x1059e0
  1040c5:	ff 75 f0             	push   -0x10(%ebp)
  1040c8:	e8 fe f6 ff ff       	call   1037cb <dirlink>
  1040cd:	83 c4 10             	add    $0x10,%esp
  1040d0:	85 c0                	test   %eax,%eax
  1040d2:	79 0d                	jns    1040e1 <create+0x193>
      panic("create dots");
  1040d4:	83 ec 0c             	sub    $0xc,%esp
  1040d7:	68 13 5a 10 00       	push   $0x105a13
  1040dc:	e8 cc c1 ff ff       	call   1002ad <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
  1040e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040e4:	8b 40 04             	mov    0x4(%eax),%eax
  1040e7:	83 ec 04             	sub    $0x4,%esp
  1040ea:	50                   	push   %eax
  1040eb:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1040ee:	50                   	push   %eax
  1040ef:	ff 75 f4             	push   -0xc(%ebp)
  1040f2:	e8 d4 f6 ff ff       	call   1037cb <dirlink>
  1040f7:	83 c4 10             	add    $0x10,%esp
  1040fa:	85 c0                	test   %eax,%eax
  1040fc:	79 0d                	jns    10410b <create+0x1bd>
    panic("create: dirlink");
  1040fe:	83 ec 0c             	sub    $0xc,%esp
  104101:	68 1f 5a 10 00       	push   $0x105a1f
  104106:	e8 a2 c1 ff ff       	call   1002ad <panic>

  iput(dp);
  10410b:	83 ec 0c             	sub    $0xc,%esp
  10410e:	ff 75 f4             	push   -0xc(%ebp)
  104111:	e8 98 ed ff ff       	call   102eae <iput>
  104116:	83 c4 10             	add    $0x10,%esp

  return ip;
  104119:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10411c:	c9                   	leave  
  10411d:	c3                   	ret    

0010411e <open>:


struct file*
open(char* path, int omode)
{
  10411e:	55                   	push   %ebp
  10411f:	89 e5                	mov    %esp,%ebp
  104121:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
  104124:	e8 ca 03 00 00       	call   1044f3 <begin_op>

  if(omode & O_CREATE){
  104129:	8b 45 0c             	mov    0xc(%ebp),%eax
  10412c:	25 00 02 00 00       	and    $0x200,%eax
  104131:	85 c0                	test   %eax,%eax
  104133:	74 29                	je     10415e <open+0x40>
    ip = create(path, T_FILE, 0, 0);
  104135:	6a 00                	push   $0x0
  104137:	6a 00                	push   $0x0
  104139:	6a 02                	push   $0x2
  10413b:	ff 75 08             	push   0x8(%ebp)
  10413e:	e8 0b fe ff ff       	call   103f4e <create>
  104143:	83 c4 10             	add    $0x10,%esp
  104146:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
  104149:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10414d:	75 73                	jne    1041c2 <open+0xa4>
      end_op();
  10414f:	e8 a5 03 00 00       	call   1044f9 <end_op>
      return 0;
  104154:	b8 00 00 00 00       	mov    $0x0,%eax
  104159:	e9 eb 00 00 00       	jmp    104249 <open+0x12b>
    }
  } else {
    if((ip = namei(path)) == 0){
  10415e:	83 ec 0c             	sub    $0xc,%esp
  104161:	ff 75 08             	push   0x8(%ebp)
  104164:	e8 c5 f8 ff ff       	call   103a2e <namei>
  104169:	83 c4 10             	add    $0x10,%esp
  10416c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10416f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104173:	75 0f                	jne    104184 <open+0x66>
      end_op();
  104175:	e8 7f 03 00 00       	call   1044f9 <end_op>
      return 0;
  10417a:	b8 00 00 00 00       	mov    $0x0,%eax
  10417f:	e9 c5 00 00 00       	jmp    104249 <open+0x12b>
    }
    iread(ip);
  104184:	83 ec 0c             	sub    $0xc,%esp
  104187:	ff 75 f4             	push   -0xc(%ebp)
  10418a:	e8 fb ee ff ff       	call   10308a <iread>
  10418f:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
  104192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104195:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  104199:	66 83 f8 01          	cmp    $0x1,%ax
  10419d:	75 23                	jne    1041c2 <open+0xa4>
  10419f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1041a3:	74 1d                	je     1041c2 <open+0xa4>
      iput(ip);
  1041a5:	83 ec 0c             	sub    $0xc,%esp
  1041a8:	ff 75 f4             	push   -0xc(%ebp)
  1041ab:	e8 fe ec ff ff       	call   102eae <iput>
  1041b0:	83 c4 10             	add    $0x10,%esp
      end_op();
  1041b3:	e8 41 03 00 00       	call   1044f9 <end_op>
      return 0;
  1041b8:	b8 00 00 00 00       	mov    $0x0,%eax
  1041bd:	e9 87 00 00 00       	jmp    104249 <open+0x12b>
    }
  }

  struct file* f;
  if((f = filealloc()) == 0) { 
  1041c2:	e8 9e f8 ff ff       	call   103a65 <filealloc>
  1041c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1041ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1041ce:	75 1a                	jne    1041ea <open+0xcc>
    iput(ip);
  1041d0:	83 ec 0c             	sub    $0xc,%esp
  1041d3:	ff 75 f4             	push   -0xc(%ebp)
  1041d6:	e8 d3 ec ff ff       	call   102eae <iput>
  1041db:	83 c4 10             	add    $0x10,%esp
    end_op();
  1041de:	e8 16 03 00 00       	call   1044f9 <end_op>
    return 0;
  1041e3:	b8 00 00 00 00       	mov    $0x0,%eax
  1041e8:	eb 5f                	jmp    104249 <open+0x12b>
  }

  f->type = FD_INODE;
  1041ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041ed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  f->ip = ip;
  1041f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1041f9:	89 50 0c             	mov    %edx,0xc(%eax)
  f->off = 0;
  1041fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041ff:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  f->readable = !(omode & O_WRONLY);
  104206:	8b 45 0c             	mov    0xc(%ebp),%eax
  104209:	83 e0 01             	and    $0x1,%eax
  10420c:	85 c0                	test   %eax,%eax
  10420e:	0f 94 c0             	sete   %al
  104211:	89 c2                	mov    %eax,%edx
  104213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104216:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104219:	8b 45 0c             	mov    0xc(%ebp),%eax
  10421c:	83 e0 01             	and    $0x1,%eax
  10421f:	85 c0                	test   %eax,%eax
  104221:	75 0a                	jne    10422d <open+0x10f>
  104223:	8b 45 0c             	mov    0xc(%ebp),%eax
  104226:	83 e0 02             	and    $0x2,%eax
  104229:	85 c0                	test   %eax,%eax
  10422b:	74 07                	je     104234 <open+0x116>
  10422d:	b8 01 00 00 00       	mov    $0x1,%eax
  104232:	eb 05                	jmp    104239 <open+0x11b>
  104234:	b8 00 00 00 00       	mov    $0x0,%eax
  104239:	89 c2                	mov    %eax,%edx
  10423b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10423e:	88 50 09             	mov    %dl,0x9(%eax)
  end_op();
  104241:	e8 b3 02 00 00       	call   1044f9 <end_op>
  return f;
  104246:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  104249:	c9                   	leave  
  10424a:	c3                   	ret    

0010424b <mknod>:

int
mknod(struct inode *ip, char* path, int major, int minor)
{
  10424b:	55                   	push   %ebp
  10424c:	89 e5                	mov    %esp,%ebp
  10424e:	83 ec 08             	sub    $0x8,%esp
  begin_op();
  104251:	e8 9d 02 00 00       	call   1044f3 <begin_op>
  if((ip = create(path, T_DEV, major, minor)) == 0){
  104256:	8b 45 14             	mov    0x14(%ebp),%eax
  104259:	0f bf d0             	movswl %ax,%edx
  10425c:	8b 45 10             	mov    0x10(%ebp),%eax
  10425f:	98                   	cwtl   
  104260:	52                   	push   %edx
  104261:	50                   	push   %eax
  104262:	6a 03                	push   $0x3
  104264:	ff 75 0c             	push   0xc(%ebp)
  104267:	e8 e2 fc ff ff       	call   103f4e <create>
  10426c:	83 c4 10             	add    $0x10,%esp
  10426f:	89 45 08             	mov    %eax,0x8(%ebp)
  104272:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104276:	75 0c                	jne    104284 <mknod+0x39>
    end_op();
  104278:	e8 7c 02 00 00       	call   1044f9 <end_op>
    return -1;
  10427d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104282:	eb 18                	jmp    10429c <mknod+0x51>
  }
  iput(ip);
  104284:	83 ec 0c             	sub    $0xc,%esp
  104287:	ff 75 08             	push   0x8(%ebp)
  10428a:	e8 1f ec ff ff       	call   102eae <iput>
  10428f:	83 c4 10             	add    $0x10,%esp
  end_op();
  104292:	e8 62 02 00 00       	call   1044f9 <end_op>
  return 0;
  104297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10429c:	c9                   	leave  
  10429d:	c3                   	ret    

0010429e <mkdir>:

int mkdir(char *path)
{
  10429e:	55                   	push   %ebp
  10429f:	89 e5                	mov    %esp,%ebp
  1042a1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
  1042a4:	e8 4a 02 00 00       	call   1044f3 <begin_op>
  if((ip = create(path, T_DIR, 0, 0)) == 0){
  1042a9:	6a 00                	push   $0x0
  1042ab:	6a 00                	push   $0x0
  1042ad:	6a 01                	push   $0x1
  1042af:	ff 75 08             	push   0x8(%ebp)
  1042b2:	e8 97 fc ff ff       	call   103f4e <create>
  1042b7:	83 c4 10             	add    $0x10,%esp
  1042ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1042bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042c1:	75 0c                	jne    1042cf <mkdir+0x31>
    end_op();
  1042c3:	e8 31 02 00 00       	call   1044f9 <end_op>
    return -1;
  1042c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1042cd:	eb 18                	jmp    1042e7 <mkdir+0x49>
  }
  iput(ip);
  1042cf:	83 ec 0c             	sub    $0xc,%esp
  1042d2:	ff 75 f4             	push   -0xc(%ebp)
  1042d5:	e8 d4 eb ff ff       	call   102eae <iput>
  1042da:	83 c4 10             	add    $0x10,%esp
  end_op();
  1042dd:	e8 17 02 00 00       	call   1044f9 <end_op>
  return 0;
  1042e2:	b8 00 00 00 00       	mov    $0x0,%eax
  1042e7:	c9                   	leave  
  1042e8:	c3                   	ret    

001042e9 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
  1042e9:	55                   	push   %ebp
  1042ea:	89 e5                	mov    %esp,%ebp
  1042ec:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  readsb(dev, &sb);
  1042ef:	83 ec 08             	sub    $0x8,%esp
  1042f2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1042f5:	50                   	push   %eax
  1042f6:	ff 75 08             	push   0x8(%ebp)
  1042f9:	e8 dc e7 ff ff       	call   102ada <readsb>
  1042fe:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
  104301:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104304:	a3 40 ea 10 00       	mov    %eax,0x10ea40
  log.size = sb.nlog;
  104309:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10430c:	a3 44 ea 10 00       	mov    %eax,0x10ea44
  log.dev = dev;
  104311:	8b 45 08             	mov    0x8(%ebp),%eax
  104314:	a3 4c ea 10 00       	mov    %eax,0x10ea4c
  recover_from_log();
  104319:	e8 b3 01 00 00       	call   1044d1 <recover_from_log>
}
  10431e:	90                   	nop
  10431f:	c9                   	leave  
  104320:	c3                   	ret    

00104321 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
  104321:	55                   	push   %ebp
  104322:	89 e5                	mov    %esp,%ebp
  104324:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
  104327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10432e:	e9 95 00 00 00       	jmp    1043c8 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
  104333:	8b 15 40 ea 10 00    	mov    0x10ea40,%edx
  104339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10433c:	01 d0                	add    %edx,%eax
  10433e:	83 c0 01             	add    $0x1,%eax
  104341:	89 c2                	mov    %eax,%edx
  104343:	a1 4c ea 10 00       	mov    0x10ea4c,%eax
  104348:	83 ec 08             	sub    $0x8,%esp
  10434b:	52                   	push   %edx
  10434c:	50                   	push   %eax
  10434d:	e8 a1 e2 ff ff       	call   1025f3 <bread>
  104352:	83 c4 10             	add    $0x10,%esp
  104355:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
  104358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10435b:	83 c0 04             	add    $0x4,%eax
  10435e:	8b 04 85 44 ea 10 00 	mov    0x10ea44(,%eax,4),%eax
  104365:	89 c2                	mov    %eax,%edx
  104367:	a1 4c ea 10 00       	mov    0x10ea4c,%eax
  10436c:	83 ec 08             	sub    $0x8,%esp
  10436f:	52                   	push   %edx
  104370:	50                   	push   %eax
  104371:	e8 7d e2 ff ff       	call   1025f3 <bread>
  104376:	83 c4 10             	add    $0x10,%esp
  104379:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
  10437c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10437f:	8d 50 1c             	lea    0x1c(%eax),%edx
  104382:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104385:	83 c0 1c             	add    $0x1c,%eax
  104388:	83 ec 04             	sub    $0x4,%esp
  10438b:	68 00 02 00 00       	push   $0x200
  104390:	52                   	push   %edx
  104391:	50                   	push   %eax
  104392:	e8 26 cc ff ff       	call   100fbd <memmove>
  104397:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
  10439a:	83 ec 0c             	sub    $0xc,%esp
  10439d:	ff 75 ec             	push   -0x14(%ebp)
  1043a0:	e8 87 e2 ff ff       	call   10262c <bwrite>
  1043a5:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
  1043a8:	83 ec 0c             	sub    $0xc,%esp
  1043ab:	ff 75 f0             	push   -0x10(%ebp)
  1043ae:	e8 9f e2 ff ff       	call   102652 <brelse>
  1043b3:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
  1043b6:	83 ec 0c             	sub    $0xc,%esp
  1043b9:	ff 75 ec             	push   -0x14(%ebp)
  1043bc:	e8 91 e2 ff ff       	call   102652 <brelse>
  1043c1:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
  1043c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1043c8:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  1043cd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1043d0:	0f 8c 5d ff ff ff    	jl     104333 <install_trans+0x12>
  }
}
  1043d6:	90                   	nop
  1043d7:	90                   	nop
  1043d8:	c9                   	leave  
  1043d9:	c3                   	ret    

001043da <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  1043da:	55                   	push   %ebp
  1043db:	89 e5                	mov    %esp,%ebp
  1043dd:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
  1043e0:	a1 40 ea 10 00       	mov    0x10ea40,%eax
  1043e5:	89 c2                	mov    %eax,%edx
  1043e7:	a1 4c ea 10 00       	mov    0x10ea4c,%eax
  1043ec:	83 ec 08             	sub    $0x8,%esp
  1043ef:	52                   	push   %edx
  1043f0:	50                   	push   %eax
  1043f1:	e8 fd e1 ff ff       	call   1025f3 <bread>
  1043f6:	83 c4 10             	add    $0x10,%esp
  1043f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
  1043fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ff:	83 c0 1c             	add    $0x1c,%eax
  104402:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
  104405:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104408:	8b 00                	mov    (%eax),%eax
  10440a:	a3 50 ea 10 00       	mov    %eax,0x10ea50
  for (i = 0; i < log.lh.n; i++) {
  10440f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104416:	eb 1b                	jmp    104433 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
  104418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10441b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10441e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
  104422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104425:	83 c2 04             	add    $0x4,%edx
  104428:	89 04 95 44 ea 10 00 	mov    %eax,0x10ea44(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
  10442f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104433:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  104438:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10443b:	7c db                	jl     104418 <read_head+0x3e>
  }
  brelse(buf);
  10443d:	83 ec 0c             	sub    $0xc,%esp
  104440:	ff 75 f0             	push   -0x10(%ebp)
  104443:	e8 0a e2 ff ff       	call   102652 <brelse>
  104448:	83 c4 10             	add    $0x10,%esp
}
  10444b:	90                   	nop
  10444c:	c9                   	leave  
  10444d:	c3                   	ret    

0010444e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  10444e:	55                   	push   %ebp
  10444f:	89 e5                	mov    %esp,%ebp
  104451:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
  104454:	a1 40 ea 10 00       	mov    0x10ea40,%eax
  104459:	89 c2                	mov    %eax,%edx
  10445b:	a1 4c ea 10 00       	mov    0x10ea4c,%eax
  104460:	83 ec 08             	sub    $0x8,%esp
  104463:	52                   	push   %edx
  104464:	50                   	push   %eax
  104465:	e8 89 e1 ff ff       	call   1025f3 <bread>
  10446a:	83 c4 10             	add    $0x10,%esp
  10446d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
  104470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104473:	83 c0 1c             	add    $0x1c,%eax
  104476:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
  104479:	8b 15 50 ea 10 00    	mov    0x10ea50,%edx
  10447f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104482:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
  104484:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10448b:	eb 1b                	jmp    1044a8 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
  10448d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104490:	83 c0 04             	add    $0x4,%eax
  104493:	8b 0c 85 44 ea 10 00 	mov    0x10ea44(,%eax,4),%ecx
  10449a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10449d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1044a0:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
  1044a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1044a8:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  1044ad:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1044b0:	7c db                	jl     10448d <write_head+0x3f>
  }
  bwrite(buf);
  1044b2:	83 ec 0c             	sub    $0xc,%esp
  1044b5:	ff 75 f0             	push   -0x10(%ebp)
  1044b8:	e8 6f e1 ff ff       	call   10262c <bwrite>
  1044bd:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
  1044c0:	83 ec 0c             	sub    $0xc,%esp
  1044c3:	ff 75 f0             	push   -0x10(%ebp)
  1044c6:	e8 87 e1 ff ff       	call   102652 <brelse>
  1044cb:	83 c4 10             	add    $0x10,%esp
}
  1044ce:	90                   	nop
  1044cf:	c9                   	leave  
  1044d0:	c3                   	ret    

001044d1 <recover_from_log>:

static void
recover_from_log(void)
{
  1044d1:	55                   	push   %ebp
  1044d2:	89 e5                	mov    %esp,%ebp
  1044d4:	83 ec 08             	sub    $0x8,%esp
  read_head();
  1044d7:	e8 fe fe ff ff       	call   1043da <read_head>
  install_trans(); // if committed, copy from log to disk
  1044dc:	e8 40 fe ff ff       	call   104321 <install_trans>
  log.lh.n = 0;
  1044e1:	c7 05 50 ea 10 00 00 	movl   $0x0,0x10ea50
  1044e8:	00 00 00 
  write_head(); // clear the log
  1044eb:	e8 5e ff ff ff       	call   10444e <write_head>
}
  1044f0:	90                   	nop
  1044f1:	c9                   	leave  
  1044f2:	c3                   	ret    

001044f3 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
  1044f3:	55                   	push   %ebp
  1044f4:	89 e5                	mov    %esp,%ebp
  
}
  1044f6:	90                   	nop
  1044f7:	5d                   	pop    %ebp
  1044f8:	c3                   	ret    

001044f9 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
  1044f9:	55                   	push   %ebp
  1044fa:	89 e5                	mov    %esp,%ebp
  1044fc:	83 ec 08             	sub    $0x8,%esp
  // call commit w/o holding locks, since not allowed
  // to sleep with locks.
  commit();
  1044ff:	e8 bc 00 00 00       	call   1045c0 <commit>
}
  104504:	90                   	nop
  104505:	c9                   	leave  
  104506:	c3                   	ret    

00104507 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
  104507:	55                   	push   %ebp
  104508:	89 e5                	mov    %esp,%ebp
  10450a:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
  10450d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104514:	e9 95 00 00 00       	jmp    1045ae <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
  104519:	8b 15 40 ea 10 00    	mov    0x10ea40,%edx
  10451f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104522:	01 d0                	add    %edx,%eax
  104524:	83 c0 01             	add    $0x1,%eax
  104527:	89 c2                	mov    %eax,%edx
  104529:	a1 4c ea 10 00       	mov    0x10ea4c,%eax
  10452e:	83 ec 08             	sub    $0x8,%esp
  104531:	52                   	push   %edx
  104532:	50                   	push   %eax
  104533:	e8 bb e0 ff ff       	call   1025f3 <bread>
  104538:	83 c4 10             	add    $0x10,%esp
  10453b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
  10453e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104541:	83 c0 04             	add    $0x4,%eax
  104544:	8b 04 85 44 ea 10 00 	mov    0x10ea44(,%eax,4),%eax
  10454b:	89 c2                	mov    %eax,%edx
  10454d:	a1 4c ea 10 00       	mov    0x10ea4c,%eax
  104552:	83 ec 08             	sub    $0x8,%esp
  104555:	52                   	push   %edx
  104556:	50                   	push   %eax
  104557:	e8 97 e0 ff ff       	call   1025f3 <bread>
  10455c:	83 c4 10             	add    $0x10,%esp
  10455f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
  104562:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104565:	8d 50 1c             	lea    0x1c(%eax),%edx
  104568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10456b:	83 c0 1c             	add    $0x1c,%eax
  10456e:	83 ec 04             	sub    $0x4,%esp
  104571:	68 00 02 00 00       	push   $0x200
  104576:	52                   	push   %edx
  104577:	50                   	push   %eax
  104578:	e8 40 ca ff ff       	call   100fbd <memmove>
  10457d:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
  104580:	83 ec 0c             	sub    $0xc,%esp
  104583:	ff 75 f0             	push   -0x10(%ebp)
  104586:	e8 a1 e0 ff ff       	call   10262c <bwrite>
  10458b:	83 c4 10             	add    $0x10,%esp
    brelse(from);
  10458e:	83 ec 0c             	sub    $0xc,%esp
  104591:	ff 75 ec             	push   -0x14(%ebp)
  104594:	e8 b9 e0 ff ff       	call   102652 <brelse>
  104599:	83 c4 10             	add    $0x10,%esp
    brelse(to);
  10459c:	83 ec 0c             	sub    $0xc,%esp
  10459f:	ff 75 f0             	push   -0x10(%ebp)
  1045a2:	e8 ab e0 ff ff       	call   102652 <brelse>
  1045a7:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
  1045aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1045ae:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  1045b3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1045b6:	0f 8c 5d ff ff ff    	jl     104519 <write_log+0x12>
  }
}
  1045bc:	90                   	nop
  1045bd:	90                   	nop
  1045be:	c9                   	leave  
  1045bf:	c3                   	ret    

001045c0 <commit>:

static void
commit()
{
  1045c0:	55                   	push   %ebp
  1045c1:	89 e5                	mov    %esp,%ebp
  1045c3:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
  1045c6:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  1045cb:	85 c0                	test   %eax,%eax
  1045cd:	7e 1e                	jle    1045ed <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
  1045cf:	e8 33 ff ff ff       	call   104507 <write_log>
    write_head();    // Write header to disk -- the real commit
  1045d4:	e8 75 fe ff ff       	call   10444e <write_head>
    install_trans(); // Now install writes to home locations
  1045d9:	e8 43 fd ff ff       	call   104321 <install_trans>
    log.lh.n = 0;
  1045de:	c7 05 50 ea 10 00 00 	movl   $0x0,0x10ea50
  1045e5:	00 00 00 
    write_head();    // Erase the transaction from the log
  1045e8:	e8 61 fe ff ff       	call   10444e <write_head>
  }
}
  1045ed:	90                   	nop
  1045ee:	c9                   	leave  
  1045ef:	c3                   	ret    

001045f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
  1045f0:	55                   	push   %ebp
  1045f1:	89 e5                	mov    %esp,%ebp
  1045f3:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
  1045f6:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  1045fb:	83 f8 1d             	cmp    $0x1d,%eax
  1045fe:	7f 12                	jg     104612 <log_write+0x22>
  104600:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  104605:	8b 15 44 ea 10 00    	mov    0x10ea44,%edx
  10460b:	83 ea 01             	sub    $0x1,%edx
  10460e:	39 d0                	cmp    %edx,%eax
  104610:	7c 0d                	jl     10461f <log_write+0x2f>
    panic("too big a transaction");
  104612:	83 ec 0c             	sub    $0xc,%esp
  104615:	68 2f 5a 10 00       	push   $0x105a2f
  10461a:	e8 8e bc ff ff       	call   1002ad <panic>

  for (i = 0; i < log.lh.n; i++) {
  10461f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104626:	eb 1d                	jmp    104645 <log_write+0x55>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
  104628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10462b:	83 c0 04             	add    $0x4,%eax
  10462e:	8b 04 85 44 ea 10 00 	mov    0x10ea44(,%eax,4),%eax
  104635:	89 c2                	mov    %eax,%edx
  104637:	8b 45 08             	mov    0x8(%ebp),%eax
  10463a:	8b 40 08             	mov    0x8(%eax),%eax
  10463d:	39 c2                	cmp    %eax,%edx
  10463f:	74 10                	je     104651 <log_write+0x61>
  for (i = 0; i < log.lh.n; i++) {
  104641:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104645:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  10464a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10464d:	7c d9                	jl     104628 <log_write+0x38>
  10464f:	eb 01                	jmp    104652 <log_write+0x62>
      break;
  104651:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
  104652:	8b 45 08             	mov    0x8(%ebp),%eax
  104655:	8b 40 08             	mov    0x8(%eax),%eax
  104658:	89 c2                	mov    %eax,%edx
  10465a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10465d:	83 c0 04             	add    $0x4,%eax
  104660:	89 14 85 44 ea 10 00 	mov    %edx,0x10ea44(,%eax,4)
  if (i == log.lh.n)
  104667:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  10466c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10466f:	75 0d                	jne    10467e <log_write+0x8e>
    log.lh.n++;
  104671:	a1 50 ea 10 00       	mov    0x10ea50,%eax
  104676:	83 c0 01             	add    $0x1,%eax
  104679:	a3 50 ea 10 00       	mov    %eax,0x10ea50
  b->flags |= B_DIRTY; // prevent eviction
  10467e:	8b 45 08             	mov    0x8(%ebp),%eax
  104681:	8b 00                	mov    (%eax),%eax
  104683:	83 c8 04             	or     $0x4,%eax
  104686:	89 c2                	mov    %eax,%edx
  104688:	8b 45 08             	mov    0x8(%ebp),%eax
  10468b:	89 10                	mov    %edx,(%eax)
  10468d:	90                   	nop
  10468e:	c9                   	leave  
  10468f:	c3                   	ret    

00104690 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
  104690:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
  104694:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
  104698:	55                   	push   %ebp
  pushl %ebx
  104699:	53                   	push   %ebx
  pushl %esi
  10469a:	56                   	push   %esi
  pushl %edi
  10469b:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
  10469c:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
  10469e:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
  1046a0:	5f                   	pop    %edi
  popl %esi
  1046a1:	5e                   	pop    %esi
  popl %ebx
  1046a2:	5b                   	pop    %ebx
  popl %ebp
  1046a3:	5d                   	pop    %ebp
  ret
  1046a4:	c3                   	ret    

001046a5 <lgdt>:
{
  1046a5:	55                   	push   %ebp
  1046a6:	89 e5                	mov    %esp,%ebp
  1046a8:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
  1046ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046ae:	83 e8 01             	sub    $0x1,%eax
  1046b1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
  1046b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1046b8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1046bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1046bf:	c1 e8 10             	shr    $0x10,%eax
  1046c2:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
  1046c6:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1046c9:	0f 01 10             	lgdtl  (%eax)
}
  1046cc:	90                   	nop
  1046cd:	c9                   	leave  
  1046ce:	c3                   	ret    

001046cf <ltr>:
{
  1046cf:	55                   	push   %ebp
  1046d0:	89 e5                	mov    %esp,%ebp
  1046d2:	83 ec 04             	sub    $0x4,%esp
  1046d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1046d8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
  1046dc:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  1046e0:	0f 00 d8             	ltr    %ax
}
  1046e3:	90                   	nop
  1046e4:	c9                   	leave  
  1046e5:	c3                   	ret    

001046e6 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  1046e6:	55                   	push   %ebp
  1046e7:	89 e5                	mov    %esp,%ebp
  1046e9:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  1046ec:	e8 99 ca ff ff       	call   10118a <cpuid>
  1046f1:	69 c0 ac 00 00 00    	imul   $0xac,%eax,%eax
  1046f7:	05 00 65 10 00       	add    $0x106500,%eax
  1046fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  1046ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104702:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
  104708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10470b:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
  104711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104714:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
  104718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10471b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
  10471f:	83 e2 f0             	and    $0xfffffff0,%edx
  104722:	83 ca 0a             	or     $0xa,%edx
  104725:	88 50 7d             	mov    %dl,0x7d(%eax)
  104728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10472b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
  10472f:	83 ca 10             	or     $0x10,%edx
  104732:	88 50 7d             	mov    %dl,0x7d(%eax)
  104735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104738:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
  10473c:	83 e2 9f             	and    $0xffffff9f,%edx
  10473f:	88 50 7d             	mov    %dl,0x7d(%eax)
  104742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104745:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
  104749:	83 ca 80             	or     $0xffffff80,%edx
  10474c:	88 50 7d             	mov    %dl,0x7d(%eax)
  10474f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104752:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
  104756:	83 ca 0f             	or     $0xf,%edx
  104759:	88 50 7e             	mov    %dl,0x7e(%eax)
  10475c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10475f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
  104763:	83 e2 ef             	and    $0xffffffef,%edx
  104766:	88 50 7e             	mov    %dl,0x7e(%eax)
  104769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10476c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
  104770:	83 e2 df             	and    $0xffffffdf,%edx
  104773:	88 50 7e             	mov    %dl,0x7e(%eax)
  104776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104779:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
  10477d:	83 ca 40             	or     $0x40,%edx
  104780:	88 50 7e             	mov    %dl,0x7e(%eax)
  104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104786:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
  10478a:	83 ca 80             	or     $0xffffff80,%edx
  10478d:	88 50 7e             	mov    %dl,0x7e(%eax)
  104790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104793:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  104797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10479a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
  1047a1:	ff ff 
  1047a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047a6:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
  1047ad:	00 00 
  1047af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047b2:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
  1047b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047bc:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
  1047c3:	83 e2 f0             	and    $0xfffffff0,%edx
  1047c6:	83 ca 02             	or     $0x2,%edx
  1047c9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
  1047cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047d2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
  1047d9:	83 ca 10             	or     $0x10,%edx
  1047dc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
  1047e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047e5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
  1047ec:	83 e2 9f             	and    $0xffffff9f,%edx
  1047ef:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
  1047f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047f8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
  1047ff:	83 ca 80             	or     $0xffffff80,%edx
  104802:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
  104808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10480b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
  104812:	83 ca 0f             	or     $0xf,%edx
  104815:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
  10481b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10481e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
  104825:	83 e2 ef             	and    $0xffffffef,%edx
  104828:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
  10482e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104831:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
  104838:	83 e2 df             	and    $0xffffffdf,%edx
  10483b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
  104841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104844:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
  10484b:	83 ca 40             	or     $0x40,%edx
  10484e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
  104854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104857:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
  10485e:	83 ca 80             	or     $0xffffff80,%edx
  104861:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
  104867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10486a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
  104871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104874:	83 c0 70             	add    $0x70,%eax
  104877:	83 ec 08             	sub    $0x8,%esp
  10487a:	6a 30                	push   $0x30
  10487c:	50                   	push   %eax
  10487d:	e8 23 fe ff ff       	call   1046a5 <lgdt>
  104882:	83 c4 10             	add    $0x10,%esp
}
  104885:	90                   	nop
  104886:	c9                   	leave  
  104887:	c3                   	ret    

00104888 <switchuvm>:

void
switchuvm(struct proc *p)
{
  104888:	55                   	push   %ebp
  104889:	89 e5                	mov    %esp,%ebp
  10488b:	56                   	push   %esi
  10488c:	53                   	push   %ebx
  10488d:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
  104890:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104894:	75 0d                	jne    1048a3 <switchuvm+0x1b>
    panic("switchuvm: no process");
  104896:	83 ec 0c             	sub    $0xc,%esp
  104899:	68 45 5a 10 00       	push   $0x105a45
  10489e:	e8 0a ba ff ff       	call   1002ad <panic>
  if(p->kstack == 0)
  1048a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a6:	8b 40 08             	mov    0x8(%eax),%eax
  1048a9:	85 c0                	test   %eax,%eax
  1048ab:	75 0d                	jne    1048ba <switchuvm+0x32>
    panic("switchuvm: no kstack");
  1048ad:	83 ec 0c             	sub    $0xc,%esp
  1048b0:	68 5b 5a 10 00       	push   $0x105a5b
  1048b5:	e8 f3 b9 ff ff       	call   1002ad <panic>

  pushcli();
  1048ba:	e8 fa cd ff ff       	call   1016b9 <pushcli>
  mycpu()->gdt[SEG_UCODE] = SEG(STA_X|STA_R, p->offset, (PROCSIZE << 12)-1, DPL_USER);
  1048bf:	e8 d0 c8 ff ff       	call   101194 <mycpu>
  1048c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1048c7:	8b 52 04             	mov    0x4(%edx),%edx
  1048ca:	89 d6                	mov    %edx,%esi
  1048cc:	8b 55 08             	mov    0x8(%ebp),%edx
  1048cf:	8b 52 04             	mov    0x4(%edx),%edx
  1048d2:	c1 ea 10             	shr    $0x10,%edx
  1048d5:	89 d3                	mov    %edx,%ebx
  1048d7:	8b 55 08             	mov    0x8(%ebp),%edx
  1048da:	8b 52 04             	mov    0x4(%edx),%edx
  1048dd:	c1 ea 18             	shr    $0x18,%edx
  1048e0:	89 d1                	mov    %edx,%ecx
  1048e2:	66 c7 80 88 00 00 00 	movw   $0xff,0x88(%eax)
  1048e9:	ff 00 
  1048eb:	66 89 b0 8a 00 00 00 	mov    %si,0x8a(%eax)
  1048f2:	88 98 8c 00 00 00    	mov    %bl,0x8c(%eax)
  1048f8:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
  1048ff:	83 e2 f0             	and    $0xfffffff0,%edx
  104902:	83 ca 0a             	or     $0xa,%edx
  104905:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
  10490b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
  104912:	83 ca 10             	or     $0x10,%edx
  104915:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
  10491b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
  104922:	83 ca 60             	or     $0x60,%edx
  104925:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
  10492b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
  104932:	83 ca 80             	or     $0xffffff80,%edx
  104935:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
  10493b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
  104942:	83 e2 f0             	and    $0xfffffff0,%edx
  104945:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
  10494b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
  104952:	83 e2 ef             	and    $0xffffffef,%edx
  104955:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
  10495b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
  104962:	83 e2 df             	and    $0xffffffdf,%edx
  104965:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
  10496b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
  104972:	83 ca 40             	or     $0x40,%edx
  104975:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
  10497b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
  104982:	83 ca 80             	or     $0xffffff80,%edx
  104985:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
  10498b:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)
  mycpu()->gdt[SEG_UDATA] = SEG(STA_W, p->offset, (PROCSIZE << 12)-1, DPL_USER);
  104991:	e8 fe c7 ff ff       	call   101194 <mycpu>
  104996:	8b 55 08             	mov    0x8(%ebp),%edx
  104999:	8b 52 04             	mov    0x4(%edx),%edx
  10499c:	89 d6                	mov    %edx,%esi
  10499e:	8b 55 08             	mov    0x8(%ebp),%edx
  1049a1:	8b 52 04             	mov    0x4(%edx),%edx
  1049a4:	c1 ea 10             	shr    $0x10,%edx
  1049a7:	89 d3                	mov    %edx,%ebx
  1049a9:	8b 55 08             	mov    0x8(%ebp),%edx
  1049ac:	8b 52 04             	mov    0x4(%edx),%edx
  1049af:	c1 ea 18             	shr    $0x18,%edx
  1049b2:	89 d1                	mov    %edx,%ecx
  1049b4:	66 c7 80 90 00 00 00 	movw   $0xff,0x90(%eax)
  1049bb:	ff 00 
  1049bd:	66 89 b0 92 00 00 00 	mov    %si,0x92(%eax)
  1049c4:	88 98 94 00 00 00    	mov    %bl,0x94(%eax)
  1049ca:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
  1049d1:	83 e2 f0             	and    $0xfffffff0,%edx
  1049d4:	83 ca 02             	or     $0x2,%edx
  1049d7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
  1049dd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
  1049e4:	83 ca 10             	or     $0x10,%edx
  1049e7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
  1049ed:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
  1049f4:	83 ca 60             	or     $0x60,%edx
  1049f7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
  1049fd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
  104a04:	83 ca 80             	or     $0xffffff80,%edx
  104a07:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
  104a0d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
  104a14:	83 e2 f0             	and    $0xfffffff0,%edx
  104a17:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
  104a1d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
  104a24:	83 e2 ef             	and    $0xffffffef,%edx
  104a27:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
  104a2d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
  104a34:	83 e2 df             	and    $0xffffffdf,%edx
  104a37:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
  104a3d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
  104a44:	83 ca 40             	or     $0x40,%edx
  104a47:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
  104a4d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
  104a54:	83 ca 80             	or     $0xffffff80,%edx
  104a57:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
  104a5d:	88 88 97 00 00 00    	mov    %cl,0x97(%eax)
  lgdt(mycpu()->gdt, sizeof(mycpu()->gdt));
  104a63:	e8 2c c7 ff ff       	call   101194 <mycpu>
  104a68:	83 c0 70             	add    $0x70,%eax
  104a6b:	83 ec 08             	sub    $0x8,%esp
  104a6e:	6a 30                	push   $0x30
  104a70:	50                   	push   %eax
  104a71:	e8 2f fc ff ff       	call   1046a5 <lgdt>
  104a76:	83 c4 10             	add    $0x10,%esp

  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
  104a79:	e8 16 c7 ff ff       	call   101194 <mycpu>
  104a7e:	89 c3                	mov    %eax,%ebx
  104a80:	e8 0f c7 ff ff       	call   101194 <mycpu>
  104a85:	83 c0 08             	add    $0x8,%eax
  104a88:	89 c6                	mov    %eax,%esi
  104a8a:	e8 05 c7 ff ff       	call   101194 <mycpu>
  104a8f:	83 c0 08             	add    $0x8,%eax
  104a92:	c1 e8 10             	shr    $0x10,%eax
  104a95:	88 45 f7             	mov    %al,-0x9(%ebp)
  104a98:	e8 f7 c6 ff ff       	call   101194 <mycpu>
  104a9d:	83 c0 08             	add    $0x8,%eax
  104aa0:	c1 e8 18             	shr    $0x18,%eax
  104aa3:	89 c2                	mov    %eax,%edx
  104aa5:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
  104aac:	67 00 
  104aae:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
  104ab5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  104ab9:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
  104abf:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
  104ac6:	83 e0 f0             	and    $0xfffffff0,%eax
  104ac9:	83 c8 09             	or     $0x9,%eax
  104acc:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
  104ad2:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
  104ad9:	83 c8 10             	or     $0x10,%eax
  104adc:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
  104ae2:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
  104ae9:	83 e0 9f             	and    $0xffffff9f,%eax
  104aec:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
  104af2:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
  104af9:	83 c8 80             	or     $0xffffff80,%eax
  104afc:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
  104b02:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
  104b09:	83 e0 f0             	and    $0xfffffff0,%eax
  104b0c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
  104b12:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
  104b19:	83 e0 ef             	and    $0xffffffef,%eax
  104b1c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
  104b22:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
  104b29:	83 e0 df             	and    $0xffffffdf,%eax
  104b2c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
  104b32:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
  104b39:	83 c8 40             	or     $0x40,%eax
  104b3c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
  104b42:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
  104b49:	83 e0 7f             	and    $0x7f,%eax
  104b4c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
  104b52:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  104b58:	e8 37 c6 ff ff       	call   101194 <mycpu>
  104b5d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
  104b64:	83 e2 ef             	and    $0xffffffef,%edx
  104b67:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  104b6d:	e8 22 c6 ff ff       	call   101194 <mycpu>
  104b72:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  104b78:	8b 45 08             	mov    0x8(%ebp),%eax
  104b7b:	8b 40 08             	mov    0x8(%eax),%eax
  104b7e:	89 c3                	mov    %eax,%ebx
  104b80:	e8 0f c6 ff ff       	call   101194 <mycpu>
  104b85:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
  104b8b:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  104b8e:	e8 01 c6 ff ff       	call   101194 <mycpu>
  104b93:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
  104b99:	83 ec 0c             	sub    $0xc,%esp
  104b9c:	6a 28                	push   $0x28
  104b9e:	e8 2c fb ff ff       	call   1046cf <ltr>
  104ba3:	83 c4 10             	add    $0x10,%esp
  popcli();
  104ba6:	e8 5b cb ff ff       	call   101706 <popcli>
  104bab:	90                   	nop
  104bac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  104baf:	5b                   	pop    %ebx
  104bb0:	5e                   	pop    %esi
  104bb1:	5d                   	pop    %ebp
  104bb2:	c3                   	ret    

00104bb3 <kinit>:
  struct run *freelist;
} kmem;

void
kinit(void *vstart, void *vend)
{
  104bb3:	55                   	push   %ebp
  104bb4:	89 e5                	mov    %esp,%ebp
  104bb6:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
  104bb9:	83 ec 08             	sub    $0x8,%esp
  104bbc:	ff 75 0c             	push   0xc(%ebp)
  104bbf:	ff 75 08             	push   0x8(%ebp)
  104bc2:	e8 06 00 00 00       	call   104bcd <freerange>
  104bc7:	83 c4 10             	add    $0x10,%esp
}
  104bca:	90                   	nop
  104bcb:	c9                   	leave  
  104bcc:	c3                   	ret    

00104bcd <freerange>:

void
freerange(void *vstart, void *vend)
{
  104bcd:	55                   	push   %ebp
  104bce:	89 e5                	mov    %esp,%ebp
  104bd0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  104bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  104bd6:	05 ff ff 0f 00       	add    $0xfffff,%eax
  104bdb:	25 00 00 f0 ff       	and    $0xfff00000,%eax
  104be0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
  104be3:	eb 15                	jmp    104bfa <freerange+0x2d>
    kfree(p);
  104be5:	83 ec 0c             	sub    $0xc,%esp
  104be8:	ff 75 f4             	push   -0xc(%ebp)
  104beb:	e8 1b 00 00 00       	call   104c0b <kfree>
  104bf0:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
  104bf3:	81 45 f4 00 00 10 00 	addl   $0x100000,-0xc(%ebp)
  104bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bfd:	05 00 00 10 00       	add    $0x100000,%eax
  104c02:	39 45 0c             	cmp    %eax,0xc(%ebp)
  104c05:	73 de                	jae    104be5 <freerange+0x18>
}
  104c07:	90                   	nop
  104c08:	90                   	nop
  104c09:	c9                   	leave  
  104c0a:	c3                   	ret    

00104c0b <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  104c0b:	55                   	push   %ebp
  104c0c:	89 e5                	mov    %esp,%ebp
  104c0e:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end) // || V2P(v) >= PHYSTOP)
  104c11:	8b 45 08             	mov    0x8(%ebp),%eax
  104c14:	25 ff ff 0f 00       	and    $0xfffff,%eax
  104c19:	85 c0                	test   %eax,%eax
  104c1b:	75 09                	jne    104c26 <kfree+0x1b>
  104c1d:	81 7d 08 d0 fa 10 00 	cmpl   $0x10fad0,0x8(%ebp)
  104c24:	73 0d                	jae    104c33 <kfree+0x28>
    panic("kfree");
  104c26:	83 ec 0c             	sub    $0xc,%esp
  104c29:	68 70 5a 10 00       	push   $0x105a70
  104c2e:	e8 7a b6 ff ff       	call   1002ad <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
  104c33:	83 ec 04             	sub    $0x4,%esp
  104c36:	68 00 00 10 00       	push   $0x100000
  104c3b:	6a 01                	push   $0x1
  104c3d:	ff 75 08             	push   0x8(%ebp)
  104c40:	e8 b9 c2 ff ff       	call   100efe <memset>
  104c45:	83 c4 10             	add    $0x10,%esp

  r = (struct run*)v;
  104c48:	8b 45 08             	mov    0x8(%ebp),%eax
  104c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
  104c4e:	8b 15 cc ea 10 00    	mov    0x10eacc,%edx
  104c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c57:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
  104c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c5c:	a3 cc ea 10 00       	mov    %eax,0x10eacc
}
  104c61:	90                   	nop
  104c62:	c9                   	leave  
  104c63:	c3                   	ret    

00104c64 <kalloc>:
// Allocate one PGSIZE page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  104c64:	55                   	push   %ebp
  104c65:	89 e5                	mov    %esp,%ebp
  104c67:	83 ec 10             	sub    $0x10,%esp
  struct run *r;

  r = kmem.freelist;
  104c6a:	a1 cc ea 10 00       	mov    0x10eacc,%eax
  104c6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(r)
  104c72:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  104c76:	74 0a                	je     104c82 <kalloc+0x1e>
    kmem.freelist = r->next;
  104c78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104c7b:	8b 00                	mov    (%eax),%eax
  104c7d:	a3 cc ea 10 00       	mov    %eax,0x10eacc
  return (char*)r;
  104c82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  104c85:	c9                   	leave  
  104c86:	c3                   	ret    

00104c87 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  104c87:	55                   	push   %ebp
  104c88:	89 e5                	mov    %esp,%ebp
  104c8a:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
  104c8d:	e8 0c c5 ff ff       	call   10119e <myproc>
  104c92:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz) {
  104c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c98:	8b 00                	mov    (%eax),%eax
  104c9a:	39 45 08             	cmp    %eax,0x8(%ebp)
  104c9d:	73 0f                	jae    104cae <fetchint+0x27>
  104c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  104ca2:	8d 50 04             	lea    0x4(%eax),%edx
  104ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ca8:	8b 00                	mov    (%eax),%eax
  104caa:	39 c2                	cmp    %eax,%edx
  104cac:	76 07                	jbe    104cb5 <fetchint+0x2e>
    return -1;
  104cae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104cb3:	eb 17                	jmp    104ccc <fetchint+0x45>
  }
  *ip = *(int*)(addr + curproc->offset);
  104cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cb8:	8b 50 04             	mov    0x4(%eax),%edx
  104cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  104cbe:	01 d0                	add    %edx,%eax
  104cc0:	8b 10                	mov    (%eax),%edx
  104cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  104cc5:	89 10                	mov    %edx,(%eax)
  return 0;
  104cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104ccc:	c9                   	leave  
  104ccd:	c3                   	ret    

00104cce <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
  104cce:	55                   	push   %ebp
  104ccf:	89 e5                	mov    %esp,%ebp
  104cd1:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
  104cd4:	e8 c5 c4 ff ff       	call   10119e <myproc>
  104cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
  104cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cdf:	8b 00                	mov    (%eax),%eax
  104ce1:	39 45 08             	cmp    %eax,0x8(%ebp)
  104ce4:	72 07                	jb     104ced <fetchstr+0x1f>
    return -1;
  104ce6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104ceb:	eb 51                	jmp    104d3e <fetchstr+0x70>
  *pp = (char*)(addr + curproc->offset);
  104ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cf0:	8b 50 04             	mov    0x4(%eax),%edx
  104cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  104cf6:	01 c2                	add    %eax,%edx
  104cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  104cfb:	89 10                	mov    %edx,(%eax)
  ep = (char*)(curproc->sz + curproc->offset);
  104cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d00:	8b 50 04             	mov    0x4(%eax),%edx
  104d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d06:	8b 00                	mov    (%eax),%eax
  104d08:	01 d0                	add    %edx,%eax
  104d0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
  104d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104d10:	8b 00                	mov    (%eax),%eax
  104d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104d15:	eb 1a                	jmp    104d31 <fetchstr+0x63>
    if(*s == 0)
  104d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d1a:	0f b6 00             	movzbl (%eax),%eax
  104d1d:	84 c0                	test   %al,%al
  104d1f:	75 0c                	jne    104d2d <fetchstr+0x5f>
      return s - *pp;
  104d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  104d24:	8b 10                	mov    (%eax),%edx
  104d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d29:	29 d0                	sub    %edx,%eax
  104d2b:	eb 11                	jmp    104d3e <fetchstr+0x70>
  for(s = *pp; s < ep; s++){
  104d2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d34:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104d37:	72 de                	jb     104d17 <fetchstr+0x49>
  }
  return -1;
  104d39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104d3e:	c9                   	leave  
  104d3f:	c3                   	ret    

00104d40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104d40:	55                   	push   %ebp
  104d41:	89 e5                	mov    %esp,%ebp
  104d43:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
  104d46:	e8 53 c4 ff ff       	call   10119e <myproc>
  104d4b:	8b 40 18             	mov    0x18(%eax),%eax
  104d4e:	8b 50 44             	mov    0x44(%eax),%edx
  104d51:	8b 45 08             	mov    0x8(%ebp),%eax
  104d54:	c1 e0 02             	shl    $0x2,%eax
  104d57:	01 d0                	add    %edx,%eax
  104d59:	83 c0 04             	add    $0x4,%eax
  104d5c:	83 ec 08             	sub    $0x8,%esp
  104d5f:	ff 75 0c             	push   0xc(%ebp)
  104d62:	50                   	push   %eax
  104d63:	e8 1f ff ff ff       	call   104c87 <fetchint>
  104d68:	83 c4 10             	add    $0x10,%esp
}
  104d6b:	c9                   	leave  
  104d6c:	c3                   	ret    

00104d6d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104d6d:	55                   	push   %ebp
  104d6e:	89 e5                	mov    %esp,%ebp
  104d70:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
  104d73:	e8 26 c4 ff ff       	call   10119e <myproc>
  104d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
  104d7b:	83 ec 08             	sub    $0x8,%esp
  104d7e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104d81:	50                   	push   %eax
  104d82:	ff 75 08             	push   0x8(%ebp)
  104d85:	e8 b6 ff ff ff       	call   104d40 <argint>
  104d8a:	83 c4 10             	add    $0x10,%esp
  104d8d:	85 c0                	test   %eax,%eax
  104d8f:	79 07                	jns    104d98 <argptr+0x2b>
    return -1;
  104d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104d96:	eb 3b                	jmp    104dd3 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
  104d98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104d9c:	78 1f                	js     104dbd <argptr+0x50>
  104d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104da1:	8b 00                	mov    (%eax),%eax
  104da3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104da6:	39 d0                	cmp    %edx,%eax
  104da8:	76 13                	jbe    104dbd <argptr+0x50>
  104daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dad:	89 c2                	mov    %eax,%edx
  104daf:	8b 45 10             	mov    0x10(%ebp),%eax
  104db2:	01 c2                	add    %eax,%edx
  104db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104db7:	8b 00                	mov    (%eax),%eax
  104db9:	39 c2                	cmp    %eax,%edx
  104dbb:	76 07                	jbe    104dc4 <argptr+0x57>
    return -1;
  104dbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104dc2:	eb 0f                	jmp    104dd3 <argptr+0x66>
  *pp = (char*)i;
  104dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dc7:	89 c2                	mov    %eax,%edx
  104dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  104dcc:	89 10                	mov    %edx,(%eax)
  return 0;
  104dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104dd3:	c9                   	leave  
  104dd4:	c3                   	ret    

00104dd5 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104dd5:	55                   	push   %ebp
  104dd6:	89 e5                	mov    %esp,%ebp
  104dd8:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104ddb:	83 ec 08             	sub    $0x8,%esp
  104dde:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104de1:	50                   	push   %eax
  104de2:	ff 75 08             	push   0x8(%ebp)
  104de5:	e8 56 ff ff ff       	call   104d40 <argint>
  104dea:	83 c4 10             	add    $0x10,%esp
  104ded:	85 c0                	test   %eax,%eax
  104def:	79 07                	jns    104df8 <argstr+0x23>
    return -1;
  104df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104df6:	eb 18                	jmp    104e10 <argstr+0x3b>
  int l = fetchstr(addr, pp);
  104df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dfb:	83 ec 08             	sub    $0x8,%esp
  104dfe:	ff 75 0c             	push   0xc(%ebp)
  104e01:	50                   	push   %eax
  104e02:	e8 c7 fe ff ff       	call   104cce <fetchstr>
  104e07:	83 c4 10             	add    $0x10,%esp
  104e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return l;
  104e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104e10:	c9                   	leave  
  104e11:	c3                   	ret    

00104e12 <syscall>:
[SYS_get_sched_policy] sys_get_sched_policy,
};

void
syscall(void)
{
  104e12:	55                   	push   %ebp
  104e13:	89 e5                	mov    %esp,%ebp
  104e15:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
  104e18:	e8 81 c3 ff ff       	call   10119e <myproc>
  104e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
  104e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e23:	8b 40 18             	mov    0x18(%eax),%eax
  104e26:	8b 40 1c             	mov    0x1c(%eax),%eax
  104e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
  104e2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e30:	7e 2f                	jle    104e61 <syscall+0x4f>
  104e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e35:	83 f8 06             	cmp    $0x6,%eax
  104e38:	77 27                	ja     104e61 <syscall+0x4f>
  104e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e3d:	8b 04 85 28 64 10 00 	mov    0x106428(,%eax,4),%eax
  104e44:	85 c0                	test   %eax,%eax
  104e46:	74 19                	je     104e61 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
  104e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e4b:	8b 04 85 28 64 10 00 	mov    0x106428(,%eax,4),%eax
  104e52:	ff d0                	call   *%eax
  104e54:	89 c2                	mov    %eax,%edx
  104e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e59:	8b 40 18             	mov    0x18(%eax),%eax
  104e5c:	89 50 1c             	mov    %edx,0x1c(%eax)
  104e5f:	eb 2c                	jmp    104e8d <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
  104e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e64:	8d 50 64             	lea    0x64(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
  104e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e6a:	8b 40 10             	mov    0x10(%eax),%eax
  104e6d:	ff 75 f0             	push   -0x10(%ebp)
  104e70:	52                   	push   %edx
  104e71:	50                   	push   %eax
  104e72:	68 76 5a 10 00       	push   $0x105a76
  104e77:	e8 70 b2 ff ff       	call   1000ec <cprintf>
  104e7c:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
  104e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e82:	8b 40 18             	mov    0x18(%eax),%eax
  104e85:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104e8c:	90                   	nop
  104e8d:	90                   	nop
  104e8e:	c9                   	leave  
  104e8f:	c3                   	ret    

00104e90 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  104e90:	55                   	push   %ebp
  104e91:	89 e5                	mov    %esp,%ebp
  104e93:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0) {
  104e96:	83 ec 08             	sub    $0x8,%esp
  104e99:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104e9c:	50                   	push   %eax
  104e9d:	ff 75 08             	push   0x8(%ebp)
  104ea0:	e8 9b fe ff ff       	call   104d40 <argint>
  104ea5:	83 c4 10             	add    $0x10,%esp
  104ea8:	85 c0                	test   %eax,%eax
  104eaa:	79 07                	jns    104eb3 <argfd+0x23>
    return -1;
  104eac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104eb1:	eb 4e                	jmp    104f01 <argfd+0x71>
  }
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
  104eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104eb6:	85 c0                	test   %eax,%eax
  104eb8:	78 1f                	js     104ed9 <argfd+0x49>
  104eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ebd:	83 f8 0f             	cmp    $0xf,%eax
  104ec0:	7f 17                	jg     104ed9 <argfd+0x49>
  104ec2:	e8 d7 c2 ff ff       	call   10119e <myproc>
  104ec7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104eca:	83 c2 08             	add    $0x8,%edx
  104ecd:	8b 04 90             	mov    (%eax,%edx,4),%eax
  104ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104ed3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104ed7:	75 07                	jne    104ee0 <argfd+0x50>
    return -1;
  104ed9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104ede:	eb 21                	jmp    104f01 <argfd+0x71>
  if(pfd)
  104ee0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104ee4:	74 08                	je     104eee <argfd+0x5e>
    *pfd = fd;
  104ee6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  104eec:	89 10                	mov    %edx,(%eax)
  if(pf)
  104eee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104ef2:	74 08                	je     104efc <argfd+0x6c>
    *pf = f;
  104ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  104ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104efa:	89 10                	mov    %edx,(%eax)
  return 0;
  104efc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104f01:	c9                   	leave  
  104f02:	c3                   	ret    

00104f03 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104f03:	55                   	push   %ebp
  104f04:	89 e5                	mov    %esp,%ebp
  104f06:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
  104f09:	e8 90 c2 ff ff       	call   10119e <myproc>
  104f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
  104f11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104f18:	eb 28                	jmp    104f42 <fdalloc+0x3f>
    if(curproc->ofile[fd] == 0){
  104f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f20:	83 c2 08             	add    $0x8,%edx
  104f23:	8b 04 90             	mov    (%eax,%edx,4),%eax
  104f26:	85 c0                	test   %eax,%eax
  104f28:	75 14                	jne    104f3e <fdalloc+0x3b>
      curproc->ofile[fd] = f;
  104f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f30:	8d 4a 08             	lea    0x8(%edx),%ecx
  104f33:	8b 55 08             	mov    0x8(%ebp),%edx
  104f36:	89 14 88             	mov    %edx,(%eax,%ecx,4)
      return fd;
  104f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f3c:	eb 0f                	jmp    104f4d <fdalloc+0x4a>
  for(fd = 0; fd < NOFILE; fd++){
  104f3e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104f42:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  104f46:	7e d2                	jle    104f1a <fdalloc+0x17>
    }
  }
  return -1;
  104f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104f4d:	c9                   	leave  
  104f4e:	c3                   	ret    

00104f4f <sys_read>:

int
sys_read(void)
{
  104f4f:	55                   	push   %ebp
  104f50:	89 e5                	mov    %esp,%ebp
  104f52:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104f55:	83 ec 04             	sub    $0x4,%esp
  104f58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104f5b:	50                   	push   %eax
  104f5c:	6a 00                	push   $0x0
  104f5e:	6a 00                	push   $0x0
  104f60:	e8 2b ff ff ff       	call   104e90 <argfd>
  104f65:	83 c4 10             	add    $0x10,%esp
  104f68:	85 c0                	test   %eax,%eax
  104f6a:	78 2e                	js     104f9a <sys_read+0x4b>
  104f6c:	83 ec 08             	sub    $0x8,%esp
  104f6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104f72:	50                   	push   %eax
  104f73:	6a 02                	push   $0x2
  104f75:	e8 c6 fd ff ff       	call   104d40 <argint>
  104f7a:	83 c4 10             	add    $0x10,%esp
  104f7d:	85 c0                	test   %eax,%eax
  104f7f:	78 19                	js     104f9a <sys_read+0x4b>
  104f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f84:	83 ec 04             	sub    $0x4,%esp
  104f87:	50                   	push   %eax
  104f88:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104f8b:	50                   	push   %eax
  104f8c:	6a 01                	push   $0x1
  104f8e:	e8 da fd ff ff       	call   104d6d <argptr>
  104f93:	83 c4 10             	add    $0x10,%esp
  104f96:	85 c0                	test   %eax,%eax
  104f98:	79 07                	jns    104fa1 <sys_read+0x52>
    return -1;
  104f9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104f9f:	eb 17                	jmp    104fb8 <sys_read+0x69>
  return fileread(f, p, n);
  104fa1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  104fa4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104faa:	83 ec 04             	sub    $0x4,%esp
  104fad:	51                   	push   %ecx
  104fae:	52                   	push   %edx
  104faf:	50                   	push   %eax
  104fb0:	e8 f2 eb ff ff       	call   103ba7 <fileread>
  104fb5:	83 c4 10             	add    $0x10,%esp
}
  104fb8:	c9                   	leave  
  104fb9:	c3                   	ret    

00104fba <sys_write>:

int
sys_write(void)
{
  104fba:	55                   	push   %ebp
  104fbb:	89 e5                	mov    %esp,%ebp
  104fbd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if((argfd(0, 0, &f) < 0) || (argstr(1, &p)) < 0 || (argint(2, &n)) < 0) {
  104fc0:	83 ec 04             	sub    $0x4,%esp
  104fc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104fc6:	50                   	push   %eax
  104fc7:	6a 00                	push   $0x0
  104fc9:	6a 00                	push   $0x0
  104fcb:	e8 c0 fe ff ff       	call   104e90 <argfd>
  104fd0:	83 c4 10             	add    $0x10,%esp
  104fd3:	85 c0                	test   %eax,%eax
  104fd5:	78 2a                	js     105001 <sys_write+0x47>
  104fd7:	83 ec 08             	sub    $0x8,%esp
  104fda:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104fdd:	50                   	push   %eax
  104fde:	6a 01                	push   $0x1
  104fe0:	e8 f0 fd ff ff       	call   104dd5 <argstr>
  104fe5:	83 c4 10             	add    $0x10,%esp
  104fe8:	85 c0                	test   %eax,%eax
  104fea:	78 15                	js     105001 <sys_write+0x47>
  104fec:	83 ec 08             	sub    $0x8,%esp
  104fef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104ff2:	50                   	push   %eax
  104ff3:	6a 02                	push   $0x2
  104ff5:	e8 46 fd ff ff       	call   104d40 <argint>
  104ffa:	83 c4 10             	add    $0x10,%esp
  104ffd:	85 c0                	test   %eax,%eax
  104fff:	79 07                	jns    105008 <sys_write+0x4e>
    return -1;
  105001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105006:	eb 17                	jmp    10501f <sys_write+0x65>
  }
  return filewrite(f, p, n);
  105008:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10500b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10500e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105011:	83 ec 04             	sub    $0x4,%esp
  105014:	51                   	push   %ecx
  105015:	52                   	push   %edx
  105016:	50                   	push   %eax
  105017:	e8 0a ec ff ff       	call   103c26 <filewrite>
  10501c:	83 c4 10             	add    $0x10,%esp
}
  10501f:	c9                   	leave  
  105020:	c3                   	ret    

00105021 <sys_close>:

int
sys_close(void)
{
  105021:	55                   	push   %ebp
  105022:	89 e5                	mov    %esp,%ebp
  105024:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
  105027:	83 ec 04             	sub    $0x4,%esp
  10502a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10502d:	50                   	push   %eax
  10502e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105031:	50                   	push   %eax
  105032:	6a 00                	push   $0x0
  105034:	e8 57 fe ff ff       	call   104e90 <argfd>
  105039:	83 c4 10             	add    $0x10,%esp
  10503c:	85 c0                	test   %eax,%eax
  10503e:	79 07                	jns    105047 <sys_close+0x26>
    return -1;
  105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105045:	eb 26                	jmp    10506d <sys_close+0x4c>
  myproc()->ofile[fd] = 0;
  105047:	e8 52 c1 ff ff       	call   10119e <myproc>
  10504c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10504f:	83 c2 08             	add    $0x8,%edx
  105052:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
  fileclose(f);
  105059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10505c:	83 ec 0c             	sub    $0xc,%esp
  10505f:	50                   	push   %eax
  105060:	e8 6e ea ff ff       	call   103ad3 <fileclose>
  105065:	83 c4 10             	add    $0x10,%esp
  return 0;
  105068:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10506d:	c9                   	leave  
  10506e:	c3                   	ret    

0010506f <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
  10506f:	55                   	push   %ebp
  105070:	89 e5                	mov    %esp,%ebp
  105072:	83 ec 38             	sub    $0x38,%esp
  105075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  105078:	8b 55 10             	mov    0x10(%ebp),%edx
  10507b:	8b 45 14             	mov    0x14(%ebp),%eax
  10507e:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
  105082:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  105086:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  10508a:	83 ec 08             	sub    $0x8,%esp
  10508d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  105090:	50                   	push   %eax
  105091:	ff 75 08             	push   0x8(%ebp)
  105094:	e8 b1 e9 ff ff       	call   103a4a <nameiparent>
  105099:	83 c4 10             	add    $0x10,%esp
  10509c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10509f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1050a3:	75 0a                	jne    1050af <create+0x40>
    return 0;
  1050a5:	b8 00 00 00 00       	mov    $0x0,%eax
  1050aa:	e9 8e 01 00 00       	jmp    10523d <create+0x1ce>
  iread(dp);
  1050af:	83 ec 0c             	sub    $0xc,%esp
  1050b2:	ff 75 f4             	push   -0xc(%ebp)
  1050b5:	e8 d0 df ff ff       	call   10308a <iread>
  1050ba:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
  1050bd:	83 ec 04             	sub    $0x4,%esp
  1050c0:	6a 00                	push   $0x0
  1050c2:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1050c5:	50                   	push   %eax
  1050c6:	ff 75 f4             	push   -0xc(%ebp)
  1050c9:	e8 43 e6 ff ff       	call   103711 <dirlookup>
  1050ce:	83 c4 10             	add    $0x10,%esp
  1050d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1050d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1050d8:	74 50                	je     10512a <create+0xbb>
    iput(dp);
  1050da:	83 ec 0c             	sub    $0xc,%esp
  1050dd:	ff 75 f4             	push   -0xc(%ebp)
  1050e0:	e8 c9 dd ff ff       	call   102eae <iput>
  1050e5:	83 c4 10             	add    $0x10,%esp
    iread(ip);
  1050e8:	83 ec 0c             	sub    $0xc,%esp
  1050eb:	ff 75 f0             	push   -0x10(%ebp)
  1050ee:	e8 97 df ff ff       	call   10308a <iread>
  1050f3:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
  1050f6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
  1050fb:	75 15                	jne    105112 <create+0xa3>
  1050fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105100:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  105104:	66 83 f8 02          	cmp    $0x2,%ax
  105108:	75 08                	jne    105112 <create+0xa3>
      return ip;
  10510a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10510d:	e9 2b 01 00 00       	jmp    10523d <create+0x1ce>
    iput(ip);
  105112:	83 ec 0c             	sub    $0xc,%esp
  105115:	ff 75 f0             	push   -0x10(%ebp)
  105118:	e8 91 dd ff ff       	call   102eae <iput>
  10511d:	83 c4 10             	add    $0x10,%esp
    return 0;
  105120:	b8 00 00 00 00       	mov    $0x0,%eax
  105125:	e9 13 01 00 00       	jmp    10523d <create+0x1ce>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  10512a:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
  10512e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105131:	8b 00                	mov    (%eax),%eax
  105133:	83 ec 08             	sub    $0x8,%esp
  105136:	52                   	push   %edx
  105137:	50                   	push   %eax
  105138:	e8 9a dc ff ff       	call   102dd7 <ialloc>
  10513d:	83 c4 10             	add    $0x10,%esp
  105140:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105143:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105147:	75 0d                	jne    105156 <create+0xe7>
    panic("create: ialloc");
  105149:	83 ec 0c             	sub    $0xc,%esp
  10514c:	68 92 5a 10 00       	push   $0x105a92
  105151:	e8 57 b1 ff ff       	call   1002ad <panic>

  iread(ip);
  105156:	83 ec 0c             	sub    $0xc,%esp
  105159:	ff 75 f0             	push   -0x10(%ebp)
  10515c:	e8 29 df ff ff       	call   10308a <iread>
  105161:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
  105164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105167:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
  10516b:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
  10516f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105172:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
  105176:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
  10517a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10517d:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
  105183:	83 ec 0c             	sub    $0xc,%esp
  105186:	ff 75 f0             	push   -0x10(%ebp)
  105189:	e8 8c dd ff ff       	call   102f1a <iupdate>
  10518e:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
  105191:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
  105196:	75 6a                	jne    105202 <create+0x193>
    dp->nlink++;  // for ".."
  105198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10519b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  10519f:	83 c0 01             	add    $0x1,%eax
  1051a2:	89 c2                	mov    %eax,%edx
  1051a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051a7:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
  1051ab:	83 ec 0c             	sub    $0xc,%esp
  1051ae:	ff 75 f4             	push   -0xc(%ebp)
  1051b1:	e8 64 dd ff ff       	call   102f1a <iupdate>
  1051b6:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1051b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051bc:	8b 40 04             	mov    0x4(%eax),%eax
  1051bf:	83 ec 04             	sub    $0x4,%esp
  1051c2:	50                   	push   %eax
  1051c3:	68 a1 5a 10 00       	push   $0x105aa1
  1051c8:	ff 75 f0             	push   -0x10(%ebp)
  1051cb:	e8 fb e5 ff ff       	call   1037cb <dirlink>
  1051d0:	83 c4 10             	add    $0x10,%esp
  1051d3:	85 c0                	test   %eax,%eax
  1051d5:	78 1e                	js     1051f5 <create+0x186>
  1051d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051da:	8b 40 04             	mov    0x4(%eax),%eax
  1051dd:	83 ec 04             	sub    $0x4,%esp
  1051e0:	50                   	push   %eax
  1051e1:	68 a3 5a 10 00       	push   $0x105aa3
  1051e6:	ff 75 f0             	push   -0x10(%ebp)
  1051e9:	e8 dd e5 ff ff       	call   1037cb <dirlink>
  1051ee:	83 c4 10             	add    $0x10,%esp
  1051f1:	85 c0                	test   %eax,%eax
  1051f3:	79 0d                	jns    105202 <create+0x193>
      panic("create dots");
  1051f5:	83 ec 0c             	sub    $0xc,%esp
  1051f8:	68 a6 5a 10 00       	push   $0x105aa6
  1051fd:	e8 ab b0 ff ff       	call   1002ad <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
  105202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105205:	8b 40 04             	mov    0x4(%eax),%eax
  105208:	83 ec 04             	sub    $0x4,%esp
  10520b:	50                   	push   %eax
  10520c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  10520f:	50                   	push   %eax
  105210:	ff 75 f4             	push   -0xc(%ebp)
  105213:	e8 b3 e5 ff ff       	call   1037cb <dirlink>
  105218:	83 c4 10             	add    $0x10,%esp
  10521b:	85 c0                	test   %eax,%eax
  10521d:	79 0d                	jns    10522c <create+0x1bd>
    panic("create: dirlink");
  10521f:	83 ec 0c             	sub    $0xc,%esp
  105222:	68 b2 5a 10 00       	push   $0x105ab2
  105227:	e8 81 b0 ff ff       	call   1002ad <panic>

  iput(dp);
  10522c:	83 ec 0c             	sub    $0xc,%esp
  10522f:	ff 75 f4             	push   -0xc(%ebp)
  105232:	e8 77 dc ff ff       	call   102eae <iput>
  105237:	83 c4 10             	add    $0x10,%esp

  return ip;
  10523a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10523d:	c9                   	leave  
  10523e:	c3                   	ret    

0010523f <sys_open>:

int
sys_open(void)
{
  10523f:	55                   	push   %ebp
  105240:	89 e5                	mov    %esp,%ebp
  105242:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if((argstr(0, &path) < 0) || (argint(1, &omode) < 0)) {
  105245:	83 ec 08             	sub    $0x8,%esp
  105248:	8d 45 e8             	lea    -0x18(%ebp),%eax
  10524b:	50                   	push   %eax
  10524c:	6a 00                	push   $0x0
  10524e:	e8 82 fb ff ff       	call   104dd5 <argstr>
  105253:	83 c4 10             	add    $0x10,%esp
  105256:	85 c0                	test   %eax,%eax
  105258:	78 15                	js     10526f <sys_open+0x30>
  10525a:	83 ec 08             	sub    $0x8,%esp
  10525d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  105260:	50                   	push   %eax
  105261:	6a 01                	push   $0x1
  105263:	e8 d8 fa ff ff       	call   104d40 <argint>
  105268:	83 c4 10             	add    $0x10,%esp
  10526b:	85 c0                	test   %eax,%eax
  10526d:	79 0a                	jns    105279 <sys_open+0x3a>
    return -1;
  10526f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105274:	e9 53 01 00 00       	jmp    1053cc <sys_open+0x18d>
  }

  begin_op();
  105279:	e8 75 f2 ff ff       	call   1044f3 <begin_op>

  if(omode & O_CREATE){
  10527e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105281:	25 00 02 00 00       	and    $0x200,%eax
  105286:	85 c0                	test   %eax,%eax
  105288:	74 2a                	je     1052b4 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
  10528a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10528d:	6a 00                	push   $0x0
  10528f:	6a 00                	push   $0x0
  105291:	6a 02                	push   $0x2
  105293:	50                   	push   %eax
  105294:	e8 d6 fd ff ff       	call   10506f <create>
  105299:	83 c4 10             	add    $0x10,%esp
  10529c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
  10529f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1052a3:	75 75                	jne    10531a <sys_open+0xdb>
      end_op();
  1052a5:	e8 4f f2 ff ff       	call   1044f9 <end_op>
      return -1;
  1052aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1052af:	e9 18 01 00 00       	jmp    1053cc <sys_open+0x18d>
    }
  } else {
    if((ip = namei(path)) == 0){
  1052b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052b7:	83 ec 0c             	sub    $0xc,%esp
  1052ba:	50                   	push   %eax
  1052bb:	e8 6e e7 ff ff       	call   103a2e <namei>
  1052c0:	83 c4 10             	add    $0x10,%esp
  1052c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1052c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1052ca:	75 0f                	jne    1052db <sys_open+0x9c>
      end_op();
  1052cc:	e8 28 f2 ff ff       	call   1044f9 <end_op>
      return -1;
  1052d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1052d6:	e9 f1 00 00 00       	jmp    1053cc <sys_open+0x18d>
    }
    iread(ip);
  1052db:	83 ec 0c             	sub    $0xc,%esp
  1052de:	ff 75 f4             	push   -0xc(%ebp)
  1052e1:	e8 a4 dd ff ff       	call   10308a <iread>
  1052e6:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
  1052e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052ec:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  1052f0:	66 83 f8 01          	cmp    $0x1,%ax
  1052f4:	75 24                	jne    10531a <sys_open+0xdb>
  1052f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052f9:	85 c0                	test   %eax,%eax
  1052fb:	74 1d                	je     10531a <sys_open+0xdb>
      iput(ip);
  1052fd:	83 ec 0c             	sub    $0xc,%esp
  105300:	ff 75 f4             	push   -0xc(%ebp)
  105303:	e8 a6 db ff ff       	call   102eae <iput>
  105308:	83 c4 10             	add    $0x10,%esp
      end_op();
  10530b:	e8 e9 f1 ff ff       	call   1044f9 <end_op>
      return -1;
  105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105315:	e9 b2 00 00 00       	jmp    1053cc <sys_open+0x18d>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  10531a:	e8 46 e7 ff ff       	call   103a65 <filealloc>
  10531f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105322:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105326:	74 17                	je     10533f <sys_open+0x100>
  105328:	83 ec 0c             	sub    $0xc,%esp
  10532b:	ff 75 f0             	push   -0x10(%ebp)
  10532e:	e8 d0 fb ff ff       	call   104f03 <fdalloc>
  105333:	83 c4 10             	add    $0x10,%esp
  105336:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105339:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10533d:	79 2e                	jns    10536d <sys_open+0x12e>
    if(f)
  10533f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105343:	74 0e                	je     105353 <sys_open+0x114>
      fileclose(f);
  105345:	83 ec 0c             	sub    $0xc,%esp
  105348:	ff 75 f0             	push   -0x10(%ebp)
  10534b:	e8 83 e7 ff ff       	call   103ad3 <fileclose>
  105350:	83 c4 10             	add    $0x10,%esp
    iput(ip);
  105353:	83 ec 0c             	sub    $0xc,%esp
  105356:	ff 75 f4             	push   -0xc(%ebp)
  105359:	e8 50 db ff ff       	call   102eae <iput>
  10535e:	83 c4 10             	add    $0x10,%esp
    end_op();
  105361:	e8 93 f1 ff ff       	call   1044f9 <end_op>
    return -1;
  105366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10536b:	eb 5f                	jmp    1053cc <sys_open+0x18d>
  }
  end_op();
  10536d:	e8 87 f1 ff ff       	call   1044f9 <end_op>

  f->type = FD_INODE;
  105372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105375:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  f->ip = ip;
  10537b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10537e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105381:	89 50 0c             	mov    %edx,0xc(%eax)
  f->off = 0;
  105384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105387:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  f->readable = !(omode & O_WRONLY);
  10538e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105391:	83 e0 01             	and    $0x1,%eax
  105394:	85 c0                	test   %eax,%eax
  105396:	0f 94 c0             	sete   %al
  105399:	89 c2                	mov    %eax,%edx
  10539b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10539e:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  1053a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053a4:	83 e0 01             	and    $0x1,%eax
  1053a7:	85 c0                	test   %eax,%eax
  1053a9:	75 0a                	jne    1053b5 <sys_open+0x176>
  1053ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053ae:	83 e0 02             	and    $0x2,%eax
  1053b1:	85 c0                	test   %eax,%eax
  1053b3:	74 07                	je     1053bc <sys_open+0x17d>
  1053b5:	b8 01 00 00 00       	mov    $0x1,%eax
  1053ba:	eb 05                	jmp    1053c1 <sys_open+0x182>
  1053bc:	b8 00 00 00 00       	mov    $0x0,%eax
  1053c1:	89 c2                	mov    %eax,%edx
  1053c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053c6:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
  1053c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  1053cc:	c9                   	leave  
  1053cd:	c3                   	ret    

001053ce <sys_exec>:

int
sys_exec(void)
{
  1053ce:	55                   	push   %ebp
  1053cf:	89 e5                	mov    %esp,%ebp
  1053d1:	83 ec 18             	sub    $0x18,%esp
  char *path;
  if(argstr(0, &path) < 0){
  1053d4:	83 ec 08             	sub    $0x8,%esp
  1053d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1053da:	50                   	push   %eax
  1053db:	6a 00                	push   $0x0
  1053dd:	e8 f3 f9 ff ff       	call   104dd5 <argstr>
  1053e2:	83 c4 10             	add    $0x10,%esp
  1053e5:	85 c0                	test   %eax,%eax
  1053e7:	79 07                	jns    1053f0 <sys_exec+0x22>
    return -1;
  1053e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1053ee:	eb 0f                	jmp    1053ff <sys_exec+0x31>
  }
  return exec(path);
  1053f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053f3:	83 ec 0c             	sub    $0xc,%esp
  1053f6:	50                   	push   %eax
  1053f7:	e8 6b 00 00 00       	call   105467 <exec>
  1053fc:	83 c4 10             	add    $0x10,%esp
  1053ff:	c9                   	leave  
  105400:	c3                   	ret    

00105401 <sys_set_sched_policy>:
#include "sysproc.h"

/* System Call Definitions */
int 
sys_set_sched_policy(void)
{
  105401:	55                   	push   %ebp
  105402:	89 e5                	mov    %esp,%ebp
  105404:	83 ec 18             	sub    $0x18,%esp
    int sched_policy;
    struct proc *curproc = myproc();
  105407:	e8 92 bd ff ff       	call   10119e <myproc>
  10540c:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if(argint(0, &sched_policy) < 0) {
  10540f:	83 ec 08             	sub    $0x8,%esp
  105412:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105415:	50                   	push   %eax
  105416:	6a 00                	push   $0x0
  105418:	e8 23 f9 ff ff       	call   104d40 <argint>
  10541d:	83 c4 10             	add    $0x10,%esp
  105420:	85 c0                	test   %eax,%eax
  105422:	79 07                	jns    10542b <sys_set_sched_policy+0x2a>
        return -22;
  105424:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
  105429:	eb 24                	jmp    10544f <sys_set_sched_policy+0x4e>
    }

    if(sched_policy != FG && sched_policy != BG){
  10542b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10542e:	85 c0                	test   %eax,%eax
  105430:	74 0f                	je     105441 <sys_set_sched_policy+0x40>
  105432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105435:	83 f8 01             	cmp    $0x1,%eax
  105438:	74 07                	je     105441 <sys_set_sched_policy+0x40>
        return -22;
  10543a:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
  10543f:	eb 0e                	jmp    10544f <sys_set_sched_policy+0x4e>
    }

    curproc->policy = sched_policy;
  105441:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105447:	89 50 74             	mov    %edx,0x74(%eax)
    return 0;
  10544a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10544f:	c9                   	leave  
  105450:	c3                   	ret    

00105451 <sys_get_sched_policy>:

int 
sys_get_sched_policy(void)
{
  105451:	55                   	push   %ebp
  105452:	89 e5                	mov    %esp,%ebp
  105454:	83 ec 18             	sub    $0x18,%esp
    struct proc *curproc = myproc();
  105457:	e8 42 bd ff ff       	call   10119e <myproc>
  10545c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return curproc->policy;
  10545f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105462:	8b 40 74             	mov    0x74(%eax),%eax
}
  105465:	c9                   	leave  
  105466:	c3                   	ret    

00105467 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path)
{
  105467:	55                   	push   %ebp
  105468:	89 e5                	mov    %esp,%ebp
  10546a:	53                   	push   %ebx
  10546b:	83 ec 74             	sub    $0x74,%esp
  int i, off;
  uint sp;
  struct elfhdr elf;
  struct inode *ip;
  struct proc *curproc = myproc();
  10546e:	e8 2b bd ff ff       	call   10119e <myproc>
  105473:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proghdr ph;

  begin_op();
  105476:	e8 78 f0 ff ff       	call   1044f3 <begin_op>

  // cprintf("exec: path %s\n", path);
  if((ip = namei(path)) == 0){
  10547b:	83 ec 0c             	sub    $0xc,%esp
  10547e:	ff 75 08             	push   0x8(%ebp)
  105481:	e8 a8 e5 ff ff       	call   103a2e <namei>
  105486:	83 c4 10             	add    $0x10,%esp
  105489:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10548c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105490:	75 0f                	jne    1054a1 <exec+0x3a>
    end_op();
  105492:	e8 62 f0 ff ff       	call   1044f9 <end_op>
    // cprintf("exec: fail\n");
    return -1;
  105497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10549c:	e9 86 01 00 00       	jmp    105627 <exec+0x1c0>
  }
  iread(ip);
  1054a1:	83 ec 0c             	sub    $0xc,%esp
  1054a4:	ff 75 e8             	push   -0x18(%ebp)
  1054a7:	e8 de db ff ff       	call   10308a <iread>
  1054ac:	83 c4 10             	add    $0x10,%esp

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
  1054af:	6a 34                	push   $0x34
  1054b1:	6a 00                	push   $0x0
  1054b3:	8d 45 b0             	lea    -0x50(%ebp),%eax
  1054b6:	50                   	push   %eax
  1054b7:	ff 75 e8             	push   -0x18(%ebp)
  1054ba:	e8 50 df ff ff       	call   10340f <readi>
  1054bf:	83 c4 10             	add    $0x10,%esp
  1054c2:	83 f8 34             	cmp    $0x34,%eax
  1054c5:	0f 85 2b 01 00 00    	jne    1055f6 <exec+0x18f>
    goto bad;
  if(elf.magic != ELF_MAGIC)
  1054cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1054ce:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  1054d3:	0f 85 20 01 00 00    	jne    1055f9 <exec+0x192>
    goto bad;

  // Fill with junk
  memset(curproc->offset, 1, curproc->sz);
  1054d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1054dc:	8b 10                	mov    (%eax),%edx
  1054de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1054e1:	8b 40 04             	mov    0x4(%eax),%eax
  1054e4:	83 ec 04             	sub    $0x4,%esp
  1054e7:	52                   	push   %edx
  1054e8:	6a 01                	push   $0x1
  1054ea:	50                   	push   %eax
  1054eb:	e8 0e ba ff ff       	call   100efe <memset>
  1054f0:	83 c4 10             	add    $0x10,%esp

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  1054f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1054fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1054fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105500:	e9 93 00 00 00       	jmp    105598 <exec+0x131>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  105505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105508:	6a 20                	push   $0x20
  10550a:	50                   	push   %eax
  10550b:	8d 45 90             	lea    -0x70(%ebp),%eax
  10550e:	50                   	push   %eax
  10550f:	ff 75 e8             	push   -0x18(%ebp)
  105512:	e8 f8 de ff ff       	call   10340f <readi>
  105517:	83 c4 10             	add    $0x10,%esp
  10551a:	83 f8 20             	cmp    $0x20,%eax
  10551d:	0f 85 d9 00 00 00    	jne    1055fc <exec+0x195>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  105523:	8b 45 90             	mov    -0x70(%ebp),%eax
  105526:	83 f8 01             	cmp    $0x1,%eax
  105529:	75 5f                	jne    10558a <exec+0x123>
      continue;
    if(ph.memsz < ph.filesz)
  10552b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10552e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105531:	39 c2                	cmp    %eax,%edx
  105533:	0f 82 c6 00 00 00    	jb     1055ff <exec+0x198>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
  105539:	8b 55 98             	mov    -0x68(%ebp),%edx
  10553c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10553f:	01 c2                	add    %eax,%edx
  105541:	8b 45 98             	mov    -0x68(%ebp),%eax
  105544:	39 c2                	cmp    %eax,%edx
  105546:	0f 82 b6 00 00 00    	jb     105602 <exec+0x19b>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
  10554c:	8b 45 98             	mov    -0x68(%ebp),%eax
  10554f:	25 ff ff 0f 00       	and    $0xfffff,%eax
  105554:	85 c0                	test   %eax,%eax
  105556:	0f 85 a9 00 00 00    	jne    105605 <exec+0x19e>
      goto bad;
    if(readi(ip, (char*)(curproc->offset + ph.vaddr), ph.off, ph.filesz) != ph.filesz)
  10555c:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10555f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105562:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105565:	8b 59 04             	mov    0x4(%ecx),%ebx
  105568:	8b 4d 98             	mov    -0x68(%ebp),%ecx
  10556b:	01 d9                	add    %ebx,%ecx
  10556d:	52                   	push   %edx
  10556e:	50                   	push   %eax
  10556f:	51                   	push   %ecx
  105570:	ff 75 e8             	push   -0x18(%ebp)
  105573:	e8 97 de ff ff       	call   10340f <readi>
  105578:	83 c4 10             	add    $0x10,%esp
  10557b:	89 c2                	mov    %eax,%edx
  10557d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105580:	39 c2                	cmp    %eax,%edx
  105582:	0f 85 80 00 00 00    	jne    105608 <exec+0x1a1>
  105588:	eb 01                	jmp    10558b <exec+0x124>
      continue;
  10558a:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  10558b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10558f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105592:	83 c0 20             	add    $0x20,%eax
  105595:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105598:	0f b7 45 dc          	movzwl -0x24(%ebp),%eax
  10559c:	0f b7 c0             	movzwl %ax,%eax
  10559f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1055a2:	0f 8c 5d ff ff ff    	jl     105505 <exec+0x9e>
      goto bad;
  }
  iput(ip);
  1055a8:	83 ec 0c             	sub    $0xc,%esp
  1055ab:	ff 75 e8             	push   -0x18(%ebp)
  1055ae:	e8 fb d8 ff ff       	call   102eae <iput>
  1055b3:	83 c4 10             	add    $0x10,%esp
  end_op();
  1055b6:	e8 3e ef ff ff       	call   1044f9 <end_op>
  ip = 0;
  1055bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

  sp = curproc->sz;
  1055c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055c5:	8b 00                	mov    (%eax),%eax
  1055c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  *(uint*)sp = 0xffffffff;
  1055ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055cd:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  sp -= 4;
  1055d3:	83 6d e4 04          	subl   $0x4,-0x1c(%ebp)

  curproc->tf->eip = elf.entry;  // main
  1055d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055da:	8b 40 18             	mov    0x18(%eax),%eax
  1055dd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1055e0:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
  1055e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055e6:	8b 40 18             	mov    0x18(%eax),%eax
  1055e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1055ec:	89 50 44             	mov    %edx,0x44(%eax)
  return 0;
  1055ef:	b8 00 00 00 00       	mov    $0x0,%eax
  1055f4:	eb 31                	jmp    105627 <exec+0x1c0>
    goto bad;
  1055f6:	90                   	nop
  1055f7:	eb 10                	jmp    105609 <exec+0x1a2>
    goto bad;
  1055f9:	90                   	nop
  1055fa:	eb 0d                	jmp    105609 <exec+0x1a2>
      goto bad;
  1055fc:	90                   	nop
  1055fd:	eb 0a                	jmp    105609 <exec+0x1a2>
      goto bad;
  1055ff:	90                   	nop
  105600:	eb 07                	jmp    105609 <exec+0x1a2>
      goto bad;
  105602:	90                   	nop
  105603:	eb 04                	jmp    105609 <exec+0x1a2>
      goto bad;
  105605:	90                   	nop
  105606:	eb 01                	jmp    105609 <exec+0x1a2>
      goto bad;
  105608:	90                   	nop

 bad:
  if(ip){
  105609:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10560d:	74 13                	je     105622 <exec+0x1bb>
    iput(ip);
  10560f:	83 ec 0c             	sub    $0xc,%esp
  105612:	ff 75 e8             	push   -0x18(%ebp)
  105615:	e8 94 d8 ff ff       	call   102eae <iput>
  10561a:	83 c4 10             	add    $0x10,%esp
    end_op();
  10561d:	e8 d7 ee ff ff       	call   1044f9 <end_op>
  }
  return -1;
  105622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10562a:	c9                   	leave  
  10562b:	c3                   	ret    
