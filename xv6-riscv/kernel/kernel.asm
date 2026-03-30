
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b2010113          	addi	sp,sp,-1248 # 80008b20 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdab77>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	e2a78793          	addi	a5,a5,-470 # 80000eae <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a6:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	7119                	addi	sp,sp,-128
    800000d6:	fc86                	sd	ra,120(sp)
    800000d8:	f8a2                	sd	s0,112(sp)
    800000da:	f4a6                	sd	s1,104(sp)
    800000dc:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while(i < n){
    800000de:	06c05b63          	blez	a2,80000154 <consolewrite+0x80>
    800000e2:	f0ca                	sd	s2,96(sp)
    800000e4:	ecce                	sd	s3,88(sp)
    800000e6:	e8d2                	sd	s4,80(sp)
    800000e8:	e4d6                	sd	s5,72(sp)
    800000ea:	e0da                	sd	s6,64(sp)
    800000ec:	fc5e                	sd	s7,56(sp)
    800000ee:	f862                	sd	s8,48(sp)
    800000f0:	f466                	sd	s9,40(sp)
    800000f2:	f06a                	sd	s10,32(sp)
    800000f4:	8b2a                	mv	s6,a0
    800000f6:	8bae                	mv	s7,a1
    800000f8:	8a32                	mv	s4,a2
  int i = 0;
    800000fa:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000fc:	02000c93          	li	s9,32
    80000100:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000104:	f8040a93          	addi	s5,s0,-128
    80000108:	5c7d                	li	s8,-1
    8000010a:	a025                	j	80000132 <consolewrite+0x5e>
    if(nn > n - i)
    8000010c:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000110:	86ce                	mv	a3,s3
    80000112:	01748633          	add	a2,s1,s7
    80000116:	85da                	mv	a1,s6
    80000118:	8556                	mv	a0,s5
    8000011a:	3b6020ef          	jal	800024d0 <either_copyin>
    8000011e:	03850d63          	beq	a0,s8,80000158 <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000122:	85ce                	mv	a1,s3
    80000124:	8556                	mv	a0,s5
    80000126:	7b4000ef          	jal	800008da <uartwrite>
    i += nn;
    8000012a:	009904bb          	addw	s1,s2,s1
  while(i < n){
    8000012e:	0144d963          	bge	s1,s4,80000140 <consolewrite+0x6c>
    if(nn > n - i)
    80000132:	409a07bb          	subw	a5,s4,s1
    80000136:	893e                	mv	s2,a5
    80000138:	fcfcdae3          	bge	s9,a5,8000010c <consolewrite+0x38>
    8000013c:	896a                	mv	s2,s10
    8000013e:	b7f9                	j	8000010c <consolewrite+0x38>
    80000140:	7906                	ld	s2,96(sp)
    80000142:	69e6                	ld	s3,88(sp)
    80000144:	6a46                	ld	s4,80(sp)
    80000146:	6aa6                	ld	s5,72(sp)
    80000148:	6b06                	ld	s6,64(sp)
    8000014a:	7be2                	ld	s7,56(sp)
    8000014c:	7c42                	ld	s8,48(sp)
    8000014e:	7ca2                	ld	s9,40(sp)
    80000150:	7d02                	ld	s10,32(sp)
    80000152:	a821                	j	8000016a <consolewrite+0x96>
  int i = 0;
    80000154:	4481                	li	s1,0
    80000156:	a811                	j	8000016a <consolewrite+0x96>
    80000158:	7906                	ld	s2,96(sp)
    8000015a:	69e6                	ld	s3,88(sp)
    8000015c:	6a46                	ld	s4,80(sp)
    8000015e:	6aa6                	ld	s5,72(sp)
    80000160:	6b06                	ld	s6,64(sp)
    80000162:	7be2                	ld	s7,56(sp)
    80000164:	7c42                	ld	s8,48(sp)
    80000166:	7ca2                	ld	s9,40(sp)
    80000168:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016a:	8526                	mv	a0,s1
    8000016c:	70e6                	ld	ra,120(sp)
    8000016e:	7446                	ld	s0,112(sp)
    80000170:	74a6                	ld	s1,104(sp)
    80000172:	6109                	addi	sp,sp,128
    80000174:	8082                	ret

0000000080000176 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000176:	711d                	addi	sp,sp,-96
    80000178:	ec86                	sd	ra,88(sp)
    8000017a:	e8a2                	sd	s0,80(sp)
    8000017c:	e4a6                	sd	s1,72(sp)
    8000017e:	e0ca                	sd	s2,64(sp)
    80000180:	fc4e                	sd	s3,56(sp)
    80000182:	f852                	sd	s4,48(sp)
    80000184:	f05a                	sd	s6,32(sp)
    80000186:	ec5e                	sd	s7,24(sp)
    80000188:	1080                	addi	s0,sp,96
    8000018a:	8b2a                	mv	s6,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000190:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000192:	00011517          	auipc	a0,0x11
    80000196:	98e50513          	addi	a0,a0,-1650 # 80010b20 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00011497          	auipc	s1,0x11
    800001a2:	98248493          	addi	s1,s1,-1662 # 80010b20 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00011917          	auipc	s2,0x11
    800001aa:	a1290913          	addi	s2,s2,-1518 # 80010bb8 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	758010ef          	jal	80001916 <myproc>
    800001c2:	194020ef          	jal	80002356 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	74f010ef          	jal	8000211a <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00011717          	auipc	a4,0x11
    800001e2:	94270713          	addi	a4,a4,-1726 # 80010b20 <cons>
    800001e6:	0017869b          	addiw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	andi	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	04da8663          	beq	s5,a3,8000024a <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	addi	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	855a                	mv	a0,s6
    80000210:	276020ef          	jal	80002486 <either_copyout>
    80000214:	57fd                	li	a5,-1
    80000216:	04f50663          	beq	a0,a5,80000262 <consoleread+0xec>
      break;

    dst++;
    8000021a:	0a05                	addi	s4,s4,1
    --n;
    8000021c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000021e:	47a9                	li	a5,10
    80000220:	04fa8b63          	beq	s5,a5,80000276 <consoleread+0x100>
    80000224:	7aa2                	ld	s5,40(sp)
    80000226:	b761                	j	800001ae <consoleread+0x38>
        release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	8f850513          	addi	a0,a0,-1800 # 80010b20 <cons>
    80000230:	28d000ef          	jal	80000cbc <release>
        return -1;
    80000234:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000236:	60e6                	ld	ra,88(sp)
    80000238:	6446                	ld	s0,80(sp)
    8000023a:	64a6                	ld	s1,72(sp)
    8000023c:	6906                	ld	s2,64(sp)
    8000023e:	79e2                	ld	s3,56(sp)
    80000240:	7a42                	ld	s4,48(sp)
    80000242:	7b02                	ld	s6,32(sp)
    80000244:	6be2                	ld	s7,24(sp)
    80000246:	6125                	addi	sp,sp,96
    80000248:	8082                	ret
      if(n < target){
    8000024a:	0179fa63          	bgeu	s3,s7,8000025e <consoleread+0xe8>
        cons.r--;
    8000024e:	00011717          	auipc	a4,0x11
    80000252:	96f72523          	sw	a5,-1686(a4) # 80010bb8 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	00011517          	auipc	a0,0x11
    80000268:	8bc50513          	addi	a0,a0,-1860 # 80010b20 <cons>
    8000026c:	251000ef          	jal	80000cbc <release>
  return target - n;
    80000270:	413b853b          	subw	a0,s7,s3
    80000274:	b7c9                	j	80000236 <consoleread+0xc0>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	b7f5                	j	80000264 <consoleread+0xee>

000000008000027a <consputc>:
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000282:	10000793          	li	a5,256
    80000286:	00f50863          	beq	a0,a5,80000296 <consputc+0x1c>
    uartputc_sync(c);
    8000028a:	6e4000ef          	jal	8000096e <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	6d6000ef          	jal	8000096e <uartputc_sync>
    8000029c:	02000513          	li	a0,32
    800002a0:	6ce000ef          	jal	8000096e <uartputc_sync>
    800002a4:	4521                	li	a0,8
    800002a6:	6c8000ef          	jal	8000096e <uartputc_sync>
    800002aa:	b7d5                	j	8000028e <consputc+0x14>

00000000800002ac <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ac:	1101                	addi	sp,sp,-32
    800002ae:	ec06                	sd	ra,24(sp)
    800002b0:	e822                	sd	s0,16(sp)
    800002b2:	e426                	sd	s1,8(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00011517          	auipc	a0,0x11
    800002bc:	86850513          	addi	a0,a0,-1944 # 80010b20 <cons>
    800002c0:	169000ef          	jal	80000c28 <acquire>

  switch(c){
    800002c4:	47d5                	li	a5,21
    800002c6:	08f48d63          	beq	s1,a5,80000360 <consoleintr+0xb4>
    800002ca:	0297c563          	blt	a5,s1,800002f4 <consoleintr+0x48>
    800002ce:	47a1                	li	a5,8
    800002d0:	0ef48263          	beq	s1,a5,800003b4 <consoleintr+0x108>
    800002d4:	47c1                	li	a5,16
    800002d6:	10f49363          	bne	s1,a5,800003dc <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800002da:	240020ef          	jal	8000251a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	00011517          	auipc	a0,0x11
    800002e2:	84250513          	addi	a0,a0,-1982 # 80010b20 <cons>
    800002e6:	1d7000ef          	jal	80000cbc <release>
}
    800002ea:	60e2                	ld	ra,24(sp)
    800002ec:	6442                	ld	s0,16(sp)
    800002ee:	64a2                	ld	s1,8(sp)
    800002f0:	6105                	addi	sp,sp,32
    800002f2:	8082                	ret
  switch(c){
    800002f4:	07f00793          	li	a5,127
    800002f8:	0af48e63          	beq	s1,a5,800003b4 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fc:	00011717          	auipc	a4,0x11
    80000300:	82470713          	addi	a4,a4,-2012 # 80010b20 <cons>
    80000304:	0a072783          	lw	a5,160(a4)
    80000308:	09872703          	lw	a4,152(a4)
    8000030c:	9f99                	subw	a5,a5,a4
    8000030e:	07f00713          	li	a4,127
    80000312:	fcf766e3          	bltu	a4,a5,800002de <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000316:	47b5                	li	a5,13
    80000318:	0cf48563          	beq	s1,a5,800003e2 <consoleintr+0x136>
      consputc(c);
    8000031c:	8526                	mv	a0,s1
    8000031e:	f5dff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000322:	00010717          	auipc	a4,0x10
    80000326:	7fe70713          	addi	a4,a4,2046 # 80010b20 <cons>
    8000032a:	0a072683          	lw	a3,160(a4)
    8000032e:	0016879b          	addiw	a5,a3,1
    80000332:	863e                	mv	a2,a5
    80000334:	0af72023          	sw	a5,160(a4)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	9736                	add	a4,a4,a3
    8000033e:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	ff648713          	addi	a4,s1,-10
    80000346:	c371                	beqz	a4,8000040a <consoleintr+0x15e>
    80000348:	14f1                	addi	s1,s1,-4
    8000034a:	c0e1                	beqz	s1,8000040a <consoleintr+0x15e>
    8000034c:	00011717          	auipc	a4,0x11
    80000350:	86c72703          	lw	a4,-1940(a4) # 80010bb8 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	00010717          	auipc	a4,0x10
    80000366:	7be70713          	addi	a4,a4,1982 # 80010b20 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	00010497          	auipc	s1,0x10
    80000376:	7ae48493          	addi	s1,s1,1966 # 80010b20 <cons>
    while(cons.e != cons.w &&
    8000037a:	4929                	li	s2,10
    8000037c:	02f70863          	beq	a4,a5,800003ac <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000380:	37fd                	addiw	a5,a5,-1
    80000382:	07f7f713          	andi	a4,a5,127
    80000386:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000388:	01874703          	lbu	a4,24(a4)
    8000038c:	03270263          	beq	a4,s2,800003b0 <consoleintr+0x104>
      cons.e--;
    80000390:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000394:	10000513          	li	a0,256
    80000398:	ee3ff0ef          	jal	8000027a <consputc>
    while(cons.e != cons.w &&
    8000039c:	0a04a783          	lw	a5,160(s1)
    800003a0:	09c4a703          	lw	a4,156(s1)
    800003a4:	fcf71ee3          	bne	a4,a5,80000380 <consoleintr+0xd4>
    800003a8:	6902                	ld	s2,0(sp)
    800003aa:	bf15                	j	800002de <consoleintr+0x32>
    800003ac:	6902                	ld	s2,0(sp)
    800003ae:	bf05                	j	800002de <consoleintr+0x32>
    800003b0:	6902                	ld	s2,0(sp)
    800003b2:	b735                	j	800002de <consoleintr+0x32>
    if(cons.e != cons.w){
    800003b4:	00010717          	auipc	a4,0x10
    800003b8:	76c70713          	addi	a4,a4,1900 # 80010b20 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00010717          	auipc	a4,0x10
    800003ce:	7ef72b23          	sw	a5,2038(a4) # 80010bc0 <cons+0xa0>
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	ea5ff0ef          	jal	8000027a <consputc>
    800003da:	b711                	j	800002de <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003dc:	f00481e3          	beqz	s1,800002de <consoleintr+0x32>
    800003e0:	bf31                	j	800002fc <consoleintr+0x50>
      consputc(c);
    800003e2:	4529                	li	a0,10
    800003e4:	e97ff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003e8:	00010797          	auipc	a5,0x10
    800003ec:	73878793          	addi	a5,a5,1848 # 80010b20 <cons>
    800003f0:	0a07a703          	lw	a4,160(a5)
    800003f4:	0017069b          	addiw	a3,a4,1
    800003f8:	8636                	mv	a2,a3
    800003fa:	0ad7a023          	sw	a3,160(a5)
    800003fe:	07f77713          	andi	a4,a4,127
    80000402:	97ba                	add	a5,a5,a4
    80000404:	4729                	li	a4,10
    80000406:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040a:	00010797          	auipc	a5,0x10
    8000040e:	7ac7a923          	sw	a2,1970(a5) # 80010bbc <cons+0x9c>
        wakeup(&cons.r);
    80000412:	00010517          	auipc	a0,0x10
    80000416:	7a650513          	addi	a0,a0,1958 # 80010bb8 <cons+0x98>
    8000041a:	54d010ef          	jal	80002166 <wakeup>
    8000041e:	b5c1                	j	800002de <consoleintr+0x32>

0000000080000420 <consoleinit>:

void
consoleinit(void)
{
    80000420:	1141                	addi	sp,sp,-16
    80000422:	e406                	sd	ra,8(sp)
    80000424:	e022                	sd	s0,0(sp)
    80000426:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000428:	00008597          	auipc	a1,0x8
    8000042c:	bd858593          	addi	a1,a1,-1064 # 80008000 <etext>
    80000430:	00010517          	auipc	a0,0x10
    80000434:	6f050513          	addi	a0,a0,1776 # 80010b20 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	00022797          	auipc	a5,0x22
    80000444:	6b078793          	addi	a5,a5,1712 # 80022af0 <devsw>
    80000448:	00000717          	auipc	a4,0x0
    8000044c:	d2e70713          	addi	a4,a4,-722 # 80000176 <consoleread>
    80000450:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000452:	00000717          	auipc	a4,0x0
    80000456:	c8270713          	addi	a4,a4,-894 # 800000d4 <consolewrite>
    8000045a:	ef98                	sd	a4,24(a5)
}
    8000045c:	60a2                	ld	ra,8(sp)
    8000045e:	6402                	ld	s0,0(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f04a                	sd	s2,32(sp)
    8000046c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000046e:	c219                	beqz	a2,80000474 <printint+0x10>
    80000470:	08054163          	bltz	a0,800004f2 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000474:	4301                	li	t1,0

  i = 0;
    80000476:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000047a:	86ca                	mv	a3,s2
  i = 0;
    8000047c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000047e:	00008817          	auipc	a6,0x8
    80000482:	4fa80813          	addi	a6,a6,1274 # 80008978 <digits>
    80000486:	88ba                	mv	a7,a4
    80000488:	0017061b          	addiw	a2,a4,1
    8000048c:	8732                	mv	a4,a2
    8000048e:	02b577b3          	remu	a5,a0,a1
    80000492:	97c2                	add	a5,a5,a6
    80000494:	0007c783          	lbu	a5,0(a5)
    80000498:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000049c:	87aa                	mv	a5,a0
    8000049e:	02b55533          	divu	a0,a0,a1
    800004a2:	0685                	addi	a3,a3,1
    800004a4:	feb7f1e3          	bgeu	a5,a1,80000486 <printint+0x22>

  if(sign)
    800004a8:	00030c63          	beqz	t1,800004c0 <printint+0x5c>
    buf[i++] = '-';
    800004ac:	fe060793          	addi	a5,a2,-32
    800004b0:	00878633          	add	a2,a5,s0
    800004b4:	02d00793          	li	a5,45
    800004b8:	fef60423          	sb	a5,-24(a2)
    800004bc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800004c0:	02e05463          	blez	a4,800004e8 <printint+0x84>
    800004c4:	f426                	sd	s1,40(sp)
    800004c6:	377d                	addiw	a4,a4,-1
    800004c8:	00e904b3          	add	s1,s2,a4
    800004cc:	197d                	addi	s2,s2,-1
    800004ce:	993a                	add	s2,s2,a4
    800004d0:	1702                	slli	a4,a4,0x20
    800004d2:	9301                	srli	a4,a4,0x20
    800004d4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004d8:	0004c503          	lbu	a0,0(s1)
    800004dc:	d9fff0ef          	jal	8000027a <consputc>
  while(--i >= 0)
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	ff249be3          	bne	s1,s2,800004d8 <printint+0x74>
    800004e6:	74a2                	ld	s1,40(sp)
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4305                	li	t1,1
    x = -xx;
    800004f8:	bfbd                	j	80000476 <printint+0x12>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	f0ca                	sd	s2,96(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	892a                	mv	s2,a0
    80000506:	e40c                	sd	a1,8(s0)
    80000508:	e810                	sd	a2,16(s0)
    8000050a:	ec14                	sd	a3,24(s0)
    8000050c:	f018                	sd	a4,32(s0)
    8000050e:	f41c                	sd	a5,40(s0)
    80000510:	03043823          	sd	a6,48(s0)
    80000514:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80000518:	00008797          	auipc	a5,0x8
    8000051c:	5dc7a783          	lw	a5,1500(a5) # 80008af4 <panicking>
    80000520:	cf9d                	beqz	a5,8000055e <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	00094503          	lbu	a0,0(s2)
    8000052e:	22050663          	beqz	a0,8000075a <printf+0x260>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	ecce                	sd	s3,88(sp)
    80000536:	e8d2                	sd	s4,80(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	fc5e                	sd	s7,56(sp)
    8000053e:	f862                	sd	s8,48(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4a01                	li	s4,0
    if(cx != '%'){
    80000546:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000054a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000054e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000552:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80000556:	4b29                	li	s6,10
    if(c0 == 'd'){
    80000558:	06400b93          	li	s7,100
    8000055c:	a015                	j	80000580 <printf+0x86>
    acquire(&pr.lock);
    8000055e:	00010517          	auipc	a0,0x10
    80000562:	66a50513          	addi	a0,a0,1642 # 80010bc8 <pr>
    80000566:	6c2000ef          	jal	80000c28 <acquire>
    8000056a:	bf65                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056c:	d0fff0ef          	jal	8000027a <consputc>
      continue;
    80000570:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000572:	2485                	addiw	s1,s1,1
    80000574:	8a26                	mv	s4,s1
    80000576:	94ca                	add	s1,s1,s2
    80000578:	0004c503          	lbu	a0,0(s1)
    8000057c:	1c050663          	beqz	a0,80000748 <printf+0x24e>
    if(cx != '%'){
    80000580:	ff3516e3          	bne	a0,s3,8000056c <printf+0x72>
    i++;
    80000584:	001a079b          	addiw	a5,s4,1
    80000588:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000058a:	00f90733          	add	a4,s2,a5
    8000058e:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000592:	200a8963          	beqz	s5,800007a4 <printf+0x2aa>
    80000596:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059a:	1e068c63          	beqz	a3,80000792 <printf+0x298>
    if(c0 == 'd'){
    8000059e:	037a8863          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800005a2:	f94a8713          	addi	a4,s5,-108
    800005a6:	00173713          	seqz	a4,a4
    800005aa:	f9c68613          	addi	a2,a3,-100
    800005ae:	ee05                	bnez	a2,800005e6 <printf+0xec>
    800005b0:	cb1d                	beqz	a4,800005e6 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005b2:	f8843783          	ld	a5,-120(s0)
    800005b6:	00878713          	addi	a4,a5,8
    800005ba:	f8e43423          	sd	a4,-120(s0)
    800005be:	4605                	li	a2,1
    800005c0:	85da                	mv	a1,s6
    800005c2:	6388                	ld	a0,0(a5)
    800005c4:	ea1ff0ef          	jal	80000464 <printint>
      i += 1;
    800005c8:	002a049b          	addiw	s1,s4,2
    800005cc:	b75d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005ce:	f8843783          	ld	a5,-120(s0)
    800005d2:	00878713          	addi	a4,a5,8
    800005d6:	f8e43423          	sd	a4,-120(s0)
    800005da:	4605                	li	a2,1
    800005dc:	85da                	mv	a1,s6
    800005de:	4388                	lw	a0,0(a5)
    800005e0:	e85ff0ef          	jal	80000464 <printint>
    800005e4:	b779                	j	80000572 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800005e6:	97ca                	add	a5,a5,s2
    800005e8:	8636                	mv	a2,a3
    800005ea:	0027c683          	lbu	a3,2(a5)
    800005ee:	a2c9                	j	800007b0 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    800005f0:	f8843783          	ld	a5,-120(s0)
    800005f4:	00878713          	addi	a4,a5,8
    800005f8:	f8e43423          	sd	a4,-120(s0)
    800005fc:	4605                	li	a2,1
    800005fe:	45a9                	li	a1,10
    80000600:	6388                	ld	a0,0(a5)
    80000602:	e63ff0ef          	jal	80000464 <printint>
      i += 2;
    80000606:	003a049b          	addiw	s1,s4,3
    8000060a:	b7a5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000060c:	f8843783          	ld	a5,-120(s0)
    80000610:	00878713          	addi	a4,a5,8
    80000614:	f8e43423          	sd	a4,-120(s0)
    80000618:	4601                	li	a2,0
    8000061a:	85da                	mv	a1,s6
    8000061c:	0007e503          	lwu	a0,0(a5)
    80000620:	e45ff0ef          	jal	80000464 <printint>
    80000624:	b7b9                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000626:	f8843783          	ld	a5,-120(s0)
    8000062a:	00878713          	addi	a4,a5,8
    8000062e:	f8e43423          	sd	a4,-120(s0)
    80000632:	4601                	li	a2,0
    80000634:	85da                	mv	a1,s6
    80000636:	6388                	ld	a0,0(a5)
    80000638:	e2dff0ef          	jal	80000464 <printint>
      i += 1;
    8000063c:	002a049b          	addiw	s1,s4,2
    80000640:	bf0d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000642:	f8843783          	ld	a5,-120(s0)
    80000646:	00878713          	addi	a4,a5,8
    8000064a:	f8e43423          	sd	a4,-120(s0)
    8000064e:	4601                	li	a2,0
    80000650:	45a9                	li	a1,10
    80000652:	6388                	ld	a0,0(a5)
    80000654:	e11ff0ef          	jal	80000464 <printint>
      i += 2;
    80000658:	003a049b          	addiw	s1,s4,3
    8000065c:	bf19                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	addi	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4601                	li	a2,0
    8000066c:	45c1                	li	a1,16
    8000066e:	0007e503          	lwu	a0,0(a5)
    80000672:	df3ff0ef          	jal	80000464 <printint>
    80000676:	bdf5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	45c1                	li	a1,16
    80000686:	6388                	ld	a0,0(a5)
    80000688:	dddff0ef          	jal	80000464 <printint>
      i += 1;
    8000068c:	002a049b          	addiw	s1,s4,2
    80000690:	b5cd                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000692:	f8843783          	ld	a5,-120(s0)
    80000696:	00878713          	addi	a4,a5,8
    8000069a:	f8e43423          	sd	a4,-120(s0)
    8000069e:	4601                	li	a2,0
    800006a0:	45c1                	li	a1,16
    800006a2:	6388                	ld	a0,0(a5)
    800006a4:	dc1ff0ef          	jal	80000464 <printint>
      i += 2;
    800006a8:	003a049b          	addiw	s1,s4,3
    800006ac:	b5d9                	j	80000572 <printf+0x78>
    800006ae:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006c0:	03000513          	li	a0,48
    800006c4:	bb7ff0ef          	jal	8000027a <consputc>
  consputc('x');
    800006c8:	07800513          	li	a0,120
    800006cc:	bafff0ef          	jal	8000027a <consputc>
    800006d0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	00008c97          	auipc	s9,0x8
    800006d6:	2a6c8c93          	addi	s9,s9,678 # 80008978 <digits>
    800006da:	03cad793          	srli	a5,s5,0x3c
    800006de:	97e6                	add	a5,a5,s9
    800006e0:	0007c503          	lbu	a0,0(a5)
    800006e4:	b97ff0ef          	jal	8000027a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e8:	0a92                	slli	s5,s5,0x4
    800006ea:	3a7d                	addiw	s4,s4,-1
    800006ec:	fe0a17e3          	bnez	s4,800006da <printf+0x1e0>
    800006f0:	7ca2                	ld	s9,40(sp)
    800006f2:	b541                	j	80000572 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    800006f4:	f8843783          	ld	a5,-120(s0)
    800006f8:	00878713          	addi	a4,a5,8
    800006fc:	f8e43423          	sd	a4,-120(s0)
    80000700:	4388                	lw	a0,0(a5)
    80000702:	b79ff0ef          	jal	8000027a <consputc>
    80000706:	b5b5                	j	80000572 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80000708:	f8843783          	ld	a5,-120(s0)
    8000070c:	00878713          	addi	a4,a5,8
    80000710:	f8e43423          	sd	a4,-120(s0)
    80000714:	0007ba03          	ld	s4,0(a5)
    80000718:	000a0d63          	beqz	s4,80000732 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000071c:	000a4503          	lbu	a0,0(s4)
    80000720:	e40509e3          	beqz	a0,80000572 <printf+0x78>
        consputc(*s);
    80000724:	b57ff0ef          	jal	8000027a <consputc>
      for(; *s; s++)
    80000728:	0a05                	addi	s4,s4,1
    8000072a:	000a4503          	lbu	a0,0(s4)
    8000072e:	f97d                	bnez	a0,80000724 <printf+0x22a>
    80000730:	b589                	j	80000572 <printf+0x78>
        s = "(null)";
    80000732:	00008a17          	auipc	s4,0x8
    80000736:	8d6a0a13          	addi	s4,s4,-1834 # 80008008 <etext+0x8>
      for(; *s; s++)
    8000073a:	02800513          	li	a0,40
    8000073e:	b7dd                	j	80000724 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80000740:	8556                	mv	a0,s5
    80000742:	b39ff0ef          	jal	8000027a <consputc>
    80000746:	b535                	j	80000572 <printf+0x78>
    80000748:	74a6                	ld	s1,104(sp)
    8000074a:	69e6                	ld	s3,88(sp)
    8000074c:	6a46                	ld	s4,80(sp)
    8000074e:	6aa6                	ld	s5,72(sp)
    80000750:	6b06                	ld	s6,64(sp)
    80000752:	7be2                	ld	s7,56(sp)
    80000754:	7c42                	ld	s8,48(sp)
    80000756:	7d02                	ld	s10,32(sp)
    80000758:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000075a:	00008797          	auipc	a5,0x8
    8000075e:	39a7a783          	lw	a5,922(a5) # 80008af4 <panicking>
    80000762:	c38d                	beqz	a5,80000784 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80000764:	4501                	li	a0,0
    80000766:	70e6                	ld	ra,120(sp)
    80000768:	7446                	ld	s0,112(sp)
    8000076a:	7906                	ld	s2,96(sp)
    8000076c:	6129                	addi	sp,sp,192
    8000076e:	8082                	ret
    80000770:	74a6                	ld	s1,104(sp)
    80000772:	69e6                	ld	s3,88(sp)
    80000774:	6a46                	ld	s4,80(sp)
    80000776:	6aa6                	ld	s5,72(sp)
    80000778:	6b06                	ld	s6,64(sp)
    8000077a:	7be2                	ld	s7,56(sp)
    8000077c:	7c42                	ld	s8,48(sp)
    8000077e:	7d02                	ld	s10,32(sp)
    80000780:	6de2                	ld	s11,24(sp)
    80000782:	bfe1                	j	8000075a <printf+0x260>
    release(&pr.lock);
    80000784:	00010517          	auipc	a0,0x10
    80000788:	44450513          	addi	a0,a0,1092 # 80010bc8 <pr>
    8000078c:	530000ef          	jal	80000cbc <release>
  return 0;
    80000790:	bfd1                	j	80000764 <printf+0x26a>
    if(c0 == 'd'){
    80000792:	e37a8ee3          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80000796:	f94a8713          	addi	a4,s5,-108
    8000079a:	00173713          	seqz	a4,a4
    8000079e:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007a0:	4781                	li	a5,0
    800007a2:	a00d                	j	800007c4 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800007a4:	f94a8713          	addi	a4,s5,-108
    800007a8:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007ac:	8656                	mv	a2,s5
    800007ae:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007b0:	f9460793          	addi	a5,a2,-108
    800007b4:	0017b793          	seqz	a5,a5
    800007b8:	8ff9                	and	a5,a5,a4
    800007ba:	f9c68593          	addi	a1,a3,-100
    800007be:	e199                	bnez	a1,800007c4 <printf+0x2ca>
    800007c0:	e20798e3          	bnez	a5,800005f0 <printf+0xf6>
    } else if(c0 == 'u'){
    800007c4:	e58a84e3          	beq	s5,s8,8000060c <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    800007c8:	f8b60593          	addi	a1,a2,-117
    800007cc:	e199                	bnez	a1,800007d2 <printf+0x2d8>
    800007ce:	e4071ce3          	bnez	a4,80000626 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800007d2:	f8b68593          	addi	a1,a3,-117
    800007d6:	e199                	bnez	a1,800007dc <printf+0x2e2>
    800007d8:	e60795e3          	bnez	a5,80000642 <printf+0x148>
    } else if(c0 == 'x'){
    800007dc:	e9aa81e3          	beq	s5,s10,8000065e <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    800007e0:	f8860613          	addi	a2,a2,-120
    800007e4:	e219                	bnez	a2,800007ea <printf+0x2f0>
    800007e6:	e80719e3          	bnez	a4,80000678 <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800007ea:	f8868693          	addi	a3,a3,-120
    800007ee:	e299                	bnez	a3,800007f4 <printf+0x2fa>
    800007f0:	ea0791e3          	bnez	a5,80000692 <printf+0x198>
    } else if(c0 == 'p'){
    800007f4:	ebba8de3          	beq	s5,s11,800006ae <printf+0x1b4>
    } else if(c0 == 'c'){
    800007f8:	06300793          	li	a5,99
    800007fc:	eefa8ce3          	beq	s5,a5,800006f4 <printf+0x1fa>
    } else if(c0 == 's'){
    80000800:	07300793          	li	a5,115
    80000804:	f0fa82e3          	beq	s5,a5,80000708 <printf+0x20e>
    } else if(c0 == '%'){
    80000808:	02500793          	li	a5,37
    8000080c:	f2fa8ae3          	beq	s5,a5,80000740 <printf+0x246>
    } else if(c0 == 0){
    80000810:	f60a80e3          	beqz	s5,80000770 <printf+0x276>
      consputc('%');
    80000814:	02500513          	li	a0,37
    80000818:	a63ff0ef          	jal	8000027a <consputc>
      consputc(c0);
    8000081c:	8556                	mv	a0,s5
    8000081e:	a5dff0ef          	jal	8000027a <consputc>
    80000822:	bb81                	j	80000572 <printf+0x78>

0000000080000824 <panic>:

void
panic(char *s)
{
    80000824:	1101                	addi	sp,sp,-32
    80000826:	ec06                	sd	ra,24(sp)
    80000828:	e822                	sd	s0,16(sp)
    8000082a:	e426                	sd	s1,8(sp)
    8000082c:	e04a                	sd	s2,0(sp)
    8000082e:	1000                	addi	s0,sp,32
    80000830:	892a                	mv	s2,a0
  panicking = 1;
    80000832:	4485                	li	s1,1
    80000834:	00008797          	auipc	a5,0x8
    80000838:	2c97a023          	sw	s1,704(a5) # 80008af4 <panicking>
  printf("panic: ");
    8000083c:	00007517          	auipc	a0,0x7
    80000840:	7d450513          	addi	a0,a0,2004 # 80008010 <etext+0x10>
    80000844:	cb7ff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000848:	85ca                	mv	a1,s2
    8000084a:	00007517          	auipc	a0,0x7
    8000084e:	7ce50513          	addi	a0,a0,1998 # 80008018 <etext+0x18>
    80000852:	ca9ff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000856:	00008797          	auipc	a5,0x8
    8000085a:	2897ad23          	sw	s1,666(a5) # 80008af0 <panicked>
  for(;;)
    8000085e:	a001                	j	8000085e <panic+0x3a>

0000000080000860 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000860:	1141                	addi	sp,sp,-16
    80000862:	e406                	sd	ra,8(sp)
    80000864:	e022                	sd	s0,0(sp)
    80000866:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000868:	00007597          	auipc	a1,0x7
    8000086c:	7b858593          	addi	a1,a1,1976 # 80008020 <etext+0x20>
    80000870:	00010517          	auipc	a0,0x10
    80000874:	35850513          	addi	a0,a0,856 # 80010bc8 <pr>
    80000878:	326000ef          	jal	80000b9e <initlock>
}
    8000087c:	60a2                	ld	ra,8(sp)
    8000087e:	6402                	ld	s0,0(sp)
    80000880:	0141                	addi	sp,sp,16
    80000882:	8082                	ret

0000000080000884 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000088c:	100007b7          	lui	a5,0x10000
    80000890:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000894:	10000737          	lui	a4,0x10000
    80000898:	f8000693          	li	a3,-128
    8000089c:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008a0:	468d                	li	a3,3
    800008a2:	10000637          	lui	a2,0x10000
    800008a6:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008aa:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008ae:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008b2:	8732                	mv	a4,a2
    800008b4:	461d                	li	a2,7
    800008b6:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ba:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800008be:	00007597          	auipc	a1,0x7
    800008c2:	76a58593          	addi	a1,a1,1898 # 80008028 <etext+0x28>
    800008c6:	00010517          	auipc	a0,0x10
    800008ca:	31a50513          	addi	a0,a0,794 # 80010be0 <tx_lock>
    800008ce:	2d0000ef          	jal	80000b9e <initlock>
}
    800008d2:	60a2                	ld	ra,8(sp)
    800008d4:	6402                	ld	s0,0(sp)
    800008d6:	0141                	addi	sp,sp,16
    800008d8:	8082                	ret

00000000800008da <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008da:	715d                	addi	sp,sp,-80
    800008dc:	e486                	sd	ra,72(sp)
    800008de:	e0a2                	sd	s0,64(sp)
    800008e0:	fc26                	sd	s1,56(sp)
    800008e2:	ec56                	sd	s5,24(sp)
    800008e4:	0880                	addi	s0,sp,80
    800008e6:	8aaa                	mv	s5,a0
    800008e8:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008ea:	00010517          	auipc	a0,0x10
    800008ee:	2f650513          	addi	a0,a0,758 # 80010be0 <tx_lock>
    800008f2:	336000ef          	jal	80000c28 <acquire>

  int i = 0;
  while(i < n){ 
    800008f6:	06905063          	blez	s1,80000956 <uartwrite+0x7c>
    800008fa:	f84a                	sd	s2,48(sp)
    800008fc:	f44e                	sd	s3,40(sp)
    800008fe:	f052                	sd	s4,32(sp)
    80000900:	e85a                	sd	s6,16(sp)
    80000902:	e45e                	sd	s7,8(sp)
    80000904:	8a56                	mv	s4,s5
    80000906:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80000908:	00008497          	auipc	s1,0x8
    8000090c:	1f448493          	addi	s1,s1,500 # 80008afc <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	00010997          	auipc	s3,0x10
    80000914:	2d098993          	addi	s3,s3,720 # 80010be0 <tx_lock>
    80000918:	00008917          	auipc	s2,0x8
    8000091c:	1e090913          	addi	s2,s2,480 # 80008af8 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80000920:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000924:	4b05                	li	s6,1
    80000926:	a005                	j	80000946 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80000928:	85ce                	mv	a1,s3
    8000092a:	854a                	mv	a0,s2
    8000092c:	7ee010ef          	jal	8000211a <sleep>
    while(tx_busy != 0){
    80000930:	409c                	lw	a5,0(s1)
    80000932:	fbfd                	bnez	a5,80000928 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80000934:	000a4783          	lbu	a5,0(s4)
    80000938:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000093c:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80000940:	0a05                	addi	s4,s4,1
    80000942:	015a0563          	beq	s4,s5,8000094c <uartwrite+0x72>
    while(tx_busy != 0){
    80000946:	409c                	lw	a5,0(s1)
    80000948:	f3e5                	bnez	a5,80000928 <uartwrite+0x4e>
    8000094a:	b7ed                	j	80000934 <uartwrite+0x5a>
    8000094c:	7942                	ld	s2,48(sp)
    8000094e:	79a2                	ld	s3,40(sp)
    80000950:	7a02                	ld	s4,32(sp)
    80000952:	6b42                	ld	s6,16(sp)
    80000954:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000956:	00010517          	auipc	a0,0x10
    8000095a:	28a50513          	addi	a0,a0,650 # 80010be0 <tx_lock>
    8000095e:	35e000ef          	jal	80000cbc <release>
}
    80000962:	60a6                	ld	ra,72(sp)
    80000964:	6406                	ld	s0,64(sp)
    80000966:	74e2                	ld	s1,56(sp)
    80000968:	6ae2                	ld	s5,24(sp)
    8000096a:	6161                	addi	sp,sp,80
    8000096c:	8082                	ret

000000008000096e <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000096e:	1101                	addi	sp,sp,-32
    80000970:	ec06                	sd	ra,24(sp)
    80000972:	e822                	sd	s0,16(sp)
    80000974:	e426                	sd	s1,8(sp)
    80000976:	1000                	addi	s0,sp,32
    80000978:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000097a:	00008797          	auipc	a5,0x8
    8000097e:	17a7a783          	lw	a5,378(a5) # 80008af4 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	00008797          	auipc	a5,0x8
    80000988:	16c7a783          	lw	a5,364(a5) # 80008af0 <panicked>
    8000098c:	ef85                	bnez	a5,800009c4 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000098e:	10000737          	lui	a4,0x10000
    80000992:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000994:	00074783          	lbu	a5,0(a4)
    80000998:	0207f793          	andi	a5,a5,32
    8000099c:	dfe5                	beqz	a5,80000994 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000099e:	0ff4f513          	zext.b	a0,s1
    800009a2:	100007b7          	lui	a5,0x10000
    800009a6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800009aa:	00008797          	auipc	a5,0x8
    800009ae:	14a7a783          	lw	a5,330(a5) # 80008af4 <panicking>
    800009b2:	cb91                	beqz	a5,800009c6 <uartputc_sync+0x58>
    pop_off();
}
    800009b4:	60e2                	ld	ra,24(sp)
    800009b6:	6442                	ld	s0,16(sp)
    800009b8:	64a2                	ld	s1,8(sp)
    800009ba:	6105                	addi	sp,sp,32
    800009bc:	8082                	ret
    push_off();
    800009be:	226000ef          	jal	80000be4 <push_off>
    800009c2:	b7c9                	j	80000984 <uartputc_sync+0x16>
    for(;;)
    800009c4:	a001                	j	800009c4 <uartputc_sync+0x56>
    pop_off();
    800009c6:	2a6000ef          	jal	80000c6c <pop_off>
}
    800009ca:	b7ed                	j	800009b4 <uartputc_sync+0x46>

00000000800009cc <uartgetc>:

// try to read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009cc:	1141                	addi	sp,sp,-16
    800009ce:	e406                	sd	ra,8(sp)
    800009d0:	e022                	sd	s0,0(sp)
    800009d2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800009d4:	100007b7          	lui	a5,0x10000
    800009d8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009dc:	8b85                	andi	a5,a5,1
    800009de:	cb89                	beqz	a5,800009f0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009e8:	60a2                	ld	ra,8(sp)
    800009ea:	6402                	ld	s0,0(sp)
    800009ec:	0141                	addi	sp,sp,16
    800009ee:	8082                	ret
    return -1;
    800009f0:	557d                	li	a0,-1
    800009f2:	bfdd                	j	800009e8 <uartgetc+0x1c>

00000000800009f4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009f4:	1101                	addi	sp,sp,-32
    800009f6:	ec06                	sd	ra,24(sp)
    800009f8:	e822                	sd	s0,16(sp)
    800009fa:	e426                	sd	s1,8(sp)
    800009fc:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009fe:	100007b7          	lui	a5,0x10000
    80000a02:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80000a06:	00010517          	auipc	a0,0x10
    80000a0a:	1da50513          	addi	a0,a0,474 # 80010be0 <tx_lock>
    80000a0e:	21a000ef          	jal	80000c28 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80000a12:	100007b7          	lui	a5,0x10000
    80000a16:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a1a:	0207f793          	andi	a5,a5,32
    80000a1e:	ef99                	bnez	a5,80000a3c <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80000a20:	00010517          	auipc	a0,0x10
    80000a24:	1c050513          	addi	a0,a0,448 # 80010be0 <tx_lock>
    80000a28:	294000ef          	jal	80000cbc <release>

  // read and process incoming characters, if any.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a2c:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a2e:	f9fff0ef          	jal	800009cc <uartgetc>
    if(c == -1)
    80000a32:	02950063          	beq	a0,s1,80000a52 <uartintr+0x5e>
      break;
    consoleintr(c);
    80000a36:	877ff0ef          	jal	800002ac <consoleintr>
  while(1){
    80000a3a:	bfd5                	j	80000a2e <uartintr+0x3a>
    tx_busy = 0;
    80000a3c:	00008797          	auipc	a5,0x8
    80000a40:	0c07a023          	sw	zero,192(a5) # 80008afc <tx_busy>
    wakeup(&tx_chan);
    80000a44:	00008517          	auipc	a0,0x8
    80000a48:	0b450513          	addi	a0,a0,180 # 80008af8 <tx_chan>
    80000a4c:	71a010ef          	jal	80002166 <wakeup>
    80000a50:	bfc1                	j	80000a20 <uartintr+0x2c>
  }
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret

0000000080000a5c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a5c:	1101                	addi	sp,sp,-32
    80000a5e:	ec06                	sd	ra,24(sp)
    80000a60:	e822                	sd	s0,16(sp)
    80000a62:	e426                	sd	s1,8(sp)
    80000a64:	e04a                	sd	s2,0(sp)
    80000a66:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a68:	00023797          	auipc	a5,0x23
    80000a6c:	22078793          	addi	a5,a5,544 # 80023c88 <end>
    80000a70:	00f53733          	sltu	a4,a0,a5
    80000a74:	47c5                	li	a5,17
    80000a76:	07ee                	slli	a5,a5,0x1b
    80000a78:	17fd                	addi	a5,a5,-1
    80000a7a:	00a7b7b3          	sltu	a5,a5,a0
    80000a7e:	8fd9                	or	a5,a5,a4
    80000a80:	ef95                	bnez	a5,80000abc <kfree+0x60>
    80000a82:	84aa                	mv	s1,a0
    80000a84:	03451793          	slli	a5,a0,0x34
    80000a88:	eb95                	bnez	a5,80000abc <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a8a:	6605                	lui	a2,0x1
    80000a8c:	4585                	li	a1,1
    80000a8e:	26a000ef          	jal	80000cf8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a92:	00010917          	auipc	s2,0x10
    80000a96:	16690913          	addi	s2,s2,358 # 80010bf8 <kmem>
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	18c000ef          	jal	80000c28 <acquire>
  r->next = kmem.freelist;
    80000aa0:	01893783          	ld	a5,24(s2)
    80000aa4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aa6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	210000ef          	jal	80000cbc <release>
}
    80000ab0:	60e2                	ld	ra,24(sp)
    80000ab2:	6442                	ld	s0,16(sp)
    80000ab4:	64a2                	ld	s1,8(sp)
    80000ab6:	6902                	ld	s2,0(sp)
    80000ab8:	6105                	addi	sp,sp,32
    80000aba:	8082                	ret
    panic("kfree");
    80000abc:	00007517          	auipc	a0,0x7
    80000ac0:	57450513          	addi	a0,a0,1396 # 80008030 <etext+0x30>
    80000ac4:	d61ff0ef          	jal	80000824 <panic>

0000000080000ac8 <freerange>:
{
    80000ac8:	7179                	addi	sp,sp,-48
    80000aca:	f406                	sd	ra,40(sp)
    80000acc:	f022                	sd	s0,32(sp)
    80000ace:	ec26                	sd	s1,24(sp)
    80000ad0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ad2:	6785                	lui	a5,0x1
    80000ad4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad8:	00e504b3          	add	s1,a0,a4
    80000adc:	777d                	lui	a4,0xfffff
    80000ade:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94be                	add	s1,s1,a5
    80000ae2:	0295e263          	bltu	a1,s1,80000b06 <freerange+0x3e>
    80000ae6:	e84a                	sd	s2,16(sp)
    80000ae8:	e44e                	sd	s3,8(sp)
    80000aea:	e052                	sd	s4,0(sp)
    80000aec:	892e                	mv	s2,a1
    kfree(p);
    80000aee:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af0:	89be                	mv	s3,a5
    kfree(p);
    80000af2:	01448533          	add	a0,s1,s4
    80000af6:	f67ff0ef          	jal	80000a5c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000afa:	94ce                	add	s1,s1,s3
    80000afc:	fe997be3          	bgeu	s2,s1,80000af2 <freerange+0x2a>
    80000b00:	6942                	ld	s2,16(sp)
    80000b02:	69a2                	ld	s3,8(sp)
    80000b04:	6a02                	ld	s4,0(sp)
}
    80000b06:	70a2                	ld	ra,40(sp)
    80000b08:	7402                	ld	s0,32(sp)
    80000b0a:	64e2                	ld	s1,24(sp)
    80000b0c:	6145                	addi	sp,sp,48
    80000b0e:	8082                	ret

0000000080000b10 <kinit>:
{
    80000b10:	1141                	addi	sp,sp,-16
    80000b12:	e406                	sd	ra,8(sp)
    80000b14:	e022                	sd	s0,0(sp)
    80000b16:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b18:	00007597          	auipc	a1,0x7
    80000b1c:	52058593          	addi	a1,a1,1312 # 80008038 <etext+0x38>
    80000b20:	00010517          	auipc	a0,0x10
    80000b24:	0d850513          	addi	a0,a0,216 # 80010bf8 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00023517          	auipc	a0,0x23
    80000b34:	15850513          	addi	a0,a0,344 # 80023c88 <end>
    80000b38:	f91ff0ef          	jal	80000ac8 <freerange>
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret

0000000080000b44 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b44:	1101                	addi	sp,sp,-32
    80000b46:	ec06                	sd	ra,24(sp)
    80000b48:	e822                	sd	s0,16(sp)
    80000b4a:	e426                	sd	s1,8(sp)
    80000b4c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b4e:	00010517          	auipc	a0,0x10
    80000b52:	0aa50513          	addi	a0,a0,170 # 80010bf8 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	00010497          	auipc	s1,0x10
    80000b5e:	0b64b483          	ld	s1,182(s1) # 80010c10 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	00010717          	auipc	a4,0x10
    80000b6a:	0af73523          	sd	a5,170(a4) # 80010c10 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	00010517          	auipc	a0,0x10
    80000b72:	08a50513          	addi	a0,a0,138 # 80010bf8 <kmem>
    80000b76:	146000ef          	jal	80000cbc <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7a:	6605                	lui	a2,0x1
    80000b7c:	4595                	li	a1,5
    80000b7e:	8526                	mv	a0,s1
    80000b80:	178000ef          	jal	80000cf8 <memset>
  return (void*)r;
}
    80000b84:	8526                	mv	a0,s1
    80000b86:	60e2                	ld	ra,24(sp)
    80000b88:	6442                	ld	s0,16(sp)
    80000b8a:	64a2                	ld	s1,8(sp)
    80000b8c:	6105                	addi	sp,sp,32
    80000b8e:	8082                	ret
  release(&kmem.lock);
    80000b90:	00010517          	auipc	a0,0x10
    80000b94:	06850513          	addi	a0,a0,104 # 80010bf8 <kmem>
    80000b98:	124000ef          	jal	80000cbc <release>
  if(r)
    80000b9c:	b7e5                	j	80000b84 <kalloc+0x40>

0000000080000b9e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b9e:	1141                	addi	sp,sp,-16
    80000ba0:	e406                	sd	ra,8(sp)
    80000ba2:	e022                	sd	s0,0(sp)
    80000ba4:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ba6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000ba8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bac:	00053823          	sd	zero,16(a0)
}
    80000bb0:	60a2                	ld	ra,8(sp)
    80000bb2:	6402                	ld	s0,0(sp)
    80000bb4:	0141                	addi	sp,sp,16
    80000bb6:	8082                	ret

0000000080000bb8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bb8:	411c                	lw	a5,0(a0)
    80000bba:	e399                	bnez	a5,80000bc0 <holding+0x8>
    80000bbc:	4501                	li	a0,0
  return r;
}
    80000bbe:	8082                	ret
{
    80000bc0:	1101                	addi	sp,sp,-32
    80000bc2:	ec06                	sd	ra,24(sp)
    80000bc4:	e822                	sd	s0,16(sp)
    80000bc6:	e426                	sd	s1,8(sp)
    80000bc8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bca:	691c                	ld	a5,16(a0)
    80000bcc:	84be                	mv	s1,a5
    80000bce:	529000ef          	jal	800018f6 <mycpu>
    80000bd2:	40a48533          	sub	a0,s1,a0
    80000bd6:	00153513          	seqz	a0,a0
}
    80000bda:	60e2                	ld	ra,24(sp)
    80000bdc:	6442                	ld	s0,16(sp)
    80000bde:	64a2                	ld	s1,8(sp)
    80000be0:	6105                	addi	sp,sp,32
    80000be2:	8082                	ret

0000000080000be4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000be4:	1101                	addi	sp,sp,-32
    80000be6:	ec06                	sd	ra,24(sp)
    80000be8:	e822                	sd	s0,16(sp)
    80000bea:	e426                	sd	s1,8(sp)
    80000bec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bee:	100027f3          	csrr	a5,sstatus
    80000bf2:	84be                	mv	s1,a5
    80000bf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bfa:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000bfe:	4f9000ef          	jal	800018f6 <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	4f1000ef          	jal	800018f6 <mycpu>
    80000c0a:	5d3c                	lw	a5,120(a0)
    80000c0c:	2785                	addiw	a5,a5,1
    80000c0e:	dd3c                	sw	a5,120(a0)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    mycpu()->intena = old;
    80000c1a:	4dd000ef          	jal	800018f6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c1e:	0014d793          	srli	a5,s1,0x1
    80000c22:	8b85                	andi	a5,a5,1
    80000c24:	dd7c                	sw	a5,124(a0)
    80000c26:	b7c5                	j	80000c06 <push_off+0x22>

0000000080000c28 <acquire>:
{
    80000c28:	1101                	addi	sp,sp,-32
    80000c2a:	ec06                	sd	ra,24(sp)
    80000c2c:	e822                	sd	s0,16(sp)
    80000c2e:	e426                	sd	s1,8(sp)
    80000c30:	1000                	addi	s0,sp,32
    80000c32:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c34:	fb1ff0ef          	jal	80000be4 <push_off>
  if(holding(lk))
    80000c38:	8526                	mv	a0,s1
    80000c3a:	f7fff0ef          	jal	80000bb8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3e:	4705                	li	a4,1
  if(holding(lk))
    80000c40:	e105                	bnez	a0,80000c60 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c42:	87ba                	mv	a5,a4
    80000c44:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c48:	2781                	sext.w	a5,a5
    80000c4a:	ffe5                	bnez	a5,80000c42 <acquire+0x1a>
  __sync_synchronize();
    80000c4c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c50:	4a7000ef          	jal	800018f6 <mycpu>
    80000c54:	e888                	sd	a0,16(s1)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("acquire");
    80000c60:	00007517          	auipc	a0,0x7
    80000c64:	3e050513          	addi	a0,a0,992 # 80008040 <etext+0x40>
    80000c68:	bbdff0ef          	jal	80000824 <panic>

0000000080000c6c <pop_off>:

void
pop_off(void)
{
    80000c6c:	1141                	addi	sp,sp,-16
    80000c6e:	e406                	sd	ra,8(sp)
    80000c70:	e022                	sd	s0,0(sp)
    80000c72:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c74:	483000ef          	jal	800018f6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c7c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c7e:	e39d                	bnez	a5,80000ca4 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c80:	5d3c                	lw	a5,120(a0)
    80000c82:	02f05763          	blez	a5,80000cb0 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c86:	37fd                	addiw	a5,a5,-1
    80000c88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c8a:	eb89                	bnez	a5,80000c9c <pop_off+0x30>
    80000c8c:	5d7c                	lw	a5,124(a0)
    80000c8e:	c799                	beqz	a5,80000c9c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("pop_off - interruptible");
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	3a450513          	addi	a0,a0,932 # 80008048 <etext+0x48>
    80000cac:	b79ff0ef          	jal	80000824 <panic>
    panic("pop_off");
    80000cb0:	00007517          	auipc	a0,0x7
    80000cb4:	3b050513          	addi	a0,a0,944 # 80008060 <etext+0x60>
    80000cb8:	b6dff0ef          	jal	80000824 <panic>

0000000080000cbc <release>:
{
    80000cbc:	1101                	addi	sp,sp,-32
    80000cbe:	ec06                	sd	ra,24(sp)
    80000cc0:	e822                	sd	s0,16(sp)
    80000cc2:	e426                	sd	s1,8(sp)
    80000cc4:	1000                	addi	s0,sp,32
    80000cc6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cc8:	ef1ff0ef          	jal	80000bb8 <holding>
    80000ccc:	c105                	beqz	a0,80000cec <release+0x30>
  lk->cpu = 0;
    80000cce:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cd2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cd6:	0310000f          	fence	rw,w
    80000cda:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cde:	f8fff0ef          	jal	80000c6c <pop_off>
}
    80000ce2:	60e2                	ld	ra,24(sp)
    80000ce4:	6442                	ld	s0,16(sp)
    80000ce6:	64a2                	ld	s1,8(sp)
    80000ce8:	6105                	addi	sp,sp,32
    80000cea:	8082                	ret
    panic("release");
    80000cec:	00007517          	auipc	a0,0x7
    80000cf0:	37c50513          	addi	a0,a0,892 # 80008068 <etext+0x68>
    80000cf4:	b31ff0ef          	jal	80000824 <panic>

0000000080000cf8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e406                	sd	ra,8(sp)
    80000cfc:	e022                	sd	s0,0(sp)
    80000cfe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d00:	ca19                	beqz	a2,80000d16 <memset+0x1e>
    80000d02:	87aa                	mv	a5,a0
    80000d04:	1602                	slli	a2,a2,0x20
    80000d06:	9201                	srli	a2,a2,0x20
    80000d08:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d10:	0785                	addi	a5,a5,1
    80000d12:	fee79de3          	bne	a5,a4,80000d0c <memset+0x14>
  }
  return dst;
}
    80000d16:	60a2                	ld	ra,8(sp)
    80000d18:	6402                	ld	s0,0(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret

0000000080000d1e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e406                	sd	ra,8(sp)
    80000d22:	e022                	sd	s0,0(sp)
    80000d24:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d26:	c61d                	beqz	a2,80000d54 <memcmp+0x36>
    80000d28:	1602                	slli	a2,a2,0x20
    80000d2a:	9201                	srli	a2,a2,0x20
    80000d2c:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000d30:	00054783          	lbu	a5,0(a0)
    80000d34:	0005c703          	lbu	a4,0(a1)
    80000d38:	00e79863          	bne	a5,a4,80000d48 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000d3c:	0505                	addi	a0,a0,1
    80000d3e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d40:	fed518e3          	bne	a0,a3,80000d30 <memcmp+0x12>
  }

  return 0;
    80000d44:	4501                	li	a0,0
    80000d46:	a019                	j	80000d4c <memcmp+0x2e>
      return *s1 - *s2;
    80000d48:	40e7853b          	subw	a0,a5,a4
}
    80000d4c:	60a2                	ld	ra,8(sp)
    80000d4e:	6402                	ld	s0,0(sp)
    80000d50:	0141                	addi	sp,sp,16
    80000d52:	8082                	ret
  return 0;
    80000d54:	4501                	li	a0,0
    80000d56:	bfdd                	j	80000d4c <memcmp+0x2e>

0000000080000d58 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e406                	sd	ra,8(sp)
    80000d5c:	e022                	sd	s0,0(sp)
    80000d5e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d60:	c205                	beqz	a2,80000d80 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d62:	02a5e363          	bltu	a1,a0,80000d88 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d66:	1602                	slli	a2,a2,0x20
    80000d68:	9201                	srli	a2,a2,0x20
    80000d6a:	00c587b3          	add	a5,a1,a2
{
    80000d6e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d70:	0585                	addi	a1,a1,1
    80000d72:	0705                	addi	a4,a4,1
    80000d74:	fff5c683          	lbu	a3,-1(a1)
    80000d78:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d7c:	feb79ae3          	bne	a5,a1,80000d70 <memmove+0x18>

  return dst;
}
    80000d80:	60a2                	ld	ra,8(sp)
    80000d82:	6402                	ld	s0,0(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret
  if(s < d && s + n > d){
    80000d88:	02061693          	slli	a3,a2,0x20
    80000d8c:	9281                	srli	a3,a3,0x20
    80000d8e:	00d58733          	add	a4,a1,a3
    80000d92:	fce57ae3          	bgeu	a0,a4,80000d66 <memmove+0xe>
    d += n;
    80000d96:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d98:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d9c:	1782                	slli	a5,a5,0x20
    80000d9e:	9381                	srli	a5,a5,0x20
    80000da0:	fff7c793          	not	a5,a5
    80000da4:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000da6:	177d                	addi	a4,a4,-1
    80000da8:	16fd                	addi	a3,a3,-1
    80000daa:	00074603          	lbu	a2,0(a4)
    80000dae:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000db2:	fee79ae3          	bne	a5,a4,80000da6 <memmove+0x4e>
    80000db6:	b7e9                	j	80000d80 <memmove+0x28>

0000000080000db8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000db8:	1141                	addi	sp,sp,-16
    80000dba:	e406                	sd	ra,8(sp)
    80000dbc:	e022                	sd	s0,0(sp)
    80000dbe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dc0:	f99ff0ef          	jal	80000d58 <memmove>
}
    80000dc4:	60a2                	ld	ra,8(sp)
    80000dc6:	6402                	ld	s0,0(sp)
    80000dc8:	0141                	addi	sp,sp,16
    80000dca:	8082                	ret

0000000080000dcc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dcc:	1141                	addi	sp,sp,-16
    80000dce:	e406                	sd	ra,8(sp)
    80000dd0:	e022                	sd	s0,0(sp)
    80000dd2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dd4:	ce11                	beqz	a2,80000df0 <strncmp+0x24>
    80000dd6:	00054783          	lbu	a5,0(a0)
    80000dda:	cf89                	beqz	a5,80000df4 <strncmp+0x28>
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	00f71a63          	bne	a4,a5,80000df4 <strncmp+0x28>
    n--, p++, q++;
    80000de4:	367d                	addiw	a2,a2,-1
    80000de6:	0505                	addi	a0,a0,1
    80000de8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dea:	f675                	bnez	a2,80000dd6 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dec:	4501                	li	a0,0
    80000dee:	a801                	j	80000dfe <strncmp+0x32>
    80000df0:	4501                	li	a0,0
    80000df2:	a031                	j	80000dfe <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000df4:	00054503          	lbu	a0,0(a0)
    80000df8:	0005c783          	lbu	a5,0(a1)
    80000dfc:	9d1d                	subw	a0,a0,a5
}
    80000dfe:	60a2                	ld	ra,8(sp)
    80000e00:	6402                	ld	s0,0(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e406                	sd	ra,8(sp)
    80000e0a:	e022                	sd	s0,0(sp)
    80000e0c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e0e:	87aa                	mv	a5,a0
    80000e10:	a011                	j	80000e14 <strncpy+0xe>
    80000e12:	8636                	mv	a2,a3
    80000e14:	02c05863          	blez	a2,80000e44 <strncpy+0x3e>
    80000e18:	fff6069b          	addiw	a3,a2,-1
    80000e1c:	8836                	mv	a6,a3
    80000e1e:	0785                	addi	a5,a5,1
    80000e20:	0005c703          	lbu	a4,0(a1)
    80000e24:	fee78fa3          	sb	a4,-1(a5)
    80000e28:	0585                	addi	a1,a1,1
    80000e2a:	f765                	bnez	a4,80000e12 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000e2c:	873e                	mv	a4,a5
    80000e2e:	01005b63          	blez	a6,80000e44 <strncpy+0x3e>
    80000e32:	9fb1                	addw	a5,a5,a2
    80000e34:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e36:	0705                	addi	a4,a4,1
    80000e38:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e3c:	40e786bb          	subw	a3,a5,a4
    80000e40:	fed04be3          	bgtz	a3,80000e36 <strncpy+0x30>
  return os;
}
    80000e44:	60a2                	ld	ra,8(sp)
    80000e46:	6402                	ld	s0,0(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e406                	sd	ra,8(sp)
    80000e50:	e022                	sd	s0,0(sp)
    80000e52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e54:	02c05363          	blez	a2,80000e7a <safestrcpy+0x2e>
    80000e58:	fff6069b          	addiw	a3,a2,-1
    80000e5c:	1682                	slli	a3,a3,0x20
    80000e5e:	9281                	srli	a3,a3,0x20
    80000e60:	96ae                	add	a3,a3,a1
    80000e62:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e64:	00d58963          	beq	a1,a3,80000e76 <safestrcpy+0x2a>
    80000e68:	0585                	addi	a1,a1,1
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff5c703          	lbu	a4,-1(a1)
    80000e70:	fee78fa3          	sb	a4,-1(a5)
    80000e74:	fb65                	bnez	a4,80000e64 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e76:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e7a:	60a2                	ld	ra,8(sp)
    80000e7c:	6402                	ld	s0,0(sp)
    80000e7e:	0141                	addi	sp,sp,16
    80000e80:	8082                	ret

0000000080000e82 <strlen>:

int
strlen(const char *s)
{
    80000e82:	1141                	addi	sp,sp,-16
    80000e84:	e406                	sd	ra,8(sp)
    80000e86:	e022                	sd	s0,0(sp)
    80000e88:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e8a:	00054783          	lbu	a5,0(a0)
    80000e8e:	cf91                	beqz	a5,80000eaa <strlen+0x28>
    80000e90:	00150793          	addi	a5,a0,1
    80000e94:	86be                	mv	a3,a5
    80000e96:	0785                	addi	a5,a5,1
    80000e98:	fff7c703          	lbu	a4,-1(a5)
    80000e9c:	ff65                	bnez	a4,80000e94 <strlen+0x12>
    80000e9e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000ea2:	60a2                	ld	ra,8(sp)
    80000ea4:	6402                	ld	s0,0(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eaa:	4501                	li	a0,0
    80000eac:	bfdd                	j	80000ea2 <strlen+0x20>

0000000080000eae <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eae:	1141                	addi	sp,sp,-16
    80000eb0:	e406                	sd	ra,8(sp)
    80000eb2:	e022                	sd	s0,0(sp)
    80000eb4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eb6:	22d000ef          	jal	800018e2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00008717          	auipc	a4,0x8
    80000ebe:	c4670713          	addi	a4,a4,-954 # 80008b00 <started>
  if(cpuid() == 0){
    80000ec2:	c51d                	beqz	a0,80000ef0 <main+0x42>
    while(started == 0)
    80000ec4:	431c                	lw	a5,0(a4)
    80000ec6:	2781                	sext.w	a5,a5
    80000ec8:	dff5                	beqz	a5,80000ec4 <main+0x16>
      ;
    __sync_synchronize();
    80000eca:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ece:	215000ef          	jal	800018e2 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	1b450513          	addi	a0,a0,436 # 80008088 <etext+0x88>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	389010ef          	jal	80002a6c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	000050ef          	jal	80005ee8 <plicinithart>
  }

  scheduler();        
    80000eec:	709000ef          	jal	80001df4 <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00007517          	auipc	a0,0x7
    80000efc:	1a050513          	addi	a0,a0,416 # 80008098 <etext+0x98>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00007517          	auipc	a0,0x7
    80000f08:	16c50513          	addi	a0,a0,364 # 80008070 <etext+0x70>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00007517          	auipc	a0,0x7
    80000f14:	18850513          	addi	a0,a0,392 # 80008098 <etext+0x98>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	2cc000ef          	jal	800011ec <kvminit>
    kvminithart();   // turn on paging
    80000f24:	03c000ef          	jal	80000f60 <kvminithart>
    procinit();      // process table
    80000f28:	111000ef          	jal	80001838 <procinit>
    trapinit();      // trap vectors
    80000f2c:	31d010ef          	jal	80002a48 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	33d010ef          	jal	80002a6c <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	79b040ef          	jal	80005ece <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	7b1040ef          	jal	80005ee8 <plicinithart>
    binit();         // buffer cache
    80000f3c:	406020ef          	jal	80003342 <binit>
    iinit();         // inode table
    80000f40:	159020ef          	jal	80003898 <iinit>
    fileinit();      // file table
    80000f44:	241030ef          	jal	80004984 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	090050ef          	jal	80005fd8 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	4fd000ef          	jal	80001c48 <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	00008717          	auipc	a4,0x8
    80000f5a:	baf72523          	sw	a5,-1110(a4) # 80008b00 <started>
    80000f5e:	b779                	j	80000eec <main+0x3e>

0000000080000f60 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f60:	1141                	addi	sp,sp,-16
    80000f62:	e406                	sd	ra,8(sp)
    80000f64:	e022                	sd	s0,0(sp)
    80000f66:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f68:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f6c:	00008797          	auipc	a5,0x8
    80000f70:	b9c7b783          	ld	a5,-1124(a5) # 80008b08 <kernel_pagetable>
    80000f74:	83b1                	srli	a5,a5,0xc
    80000f76:	577d                	li	a4,-1
    80000f78:	177e                	slli	a4,a4,0x3f
    80000f7a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f7c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f80:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f84:	60a2                	ld	ra,8(sp)
    80000f86:	6402                	ld	s0,0(sp)
    80000f88:	0141                	addi	sp,sp,16
    80000f8a:	8082                	ret

0000000080000f8c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f8c:	7139                	addi	sp,sp,-64
    80000f8e:	fc06                	sd	ra,56(sp)
    80000f90:	f822                	sd	s0,48(sp)
    80000f92:	f426                	sd	s1,40(sp)
    80000f94:	f04a                	sd	s2,32(sp)
    80000f96:	ec4e                	sd	s3,24(sp)
    80000f98:	e852                	sd	s4,16(sp)
    80000f9a:	e456                	sd	s5,8(sp)
    80000f9c:	e05a                	sd	s6,0(sp)
    80000f9e:	0080                	addi	s0,sp,64
    80000fa0:	84aa                	mv	s1,a0
    80000fa2:	89ae                	mv	s3,a1
    80000fa4:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80000fa6:	57fd                	li	a5,-1
    80000fa8:	83e9                	srli	a5,a5,0x1a
    80000faa:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fac:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80000fae:	04b7e263          	bltu	a5,a1,80000ff2 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fb2:	0149d933          	srl	s2,s3,s4
    80000fb6:	1ff97913          	andi	s2,s2,511
    80000fba:	090e                	slli	s2,s2,0x3
    80000fbc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fbe:	00093483          	ld	s1,0(s2)
    80000fc2:	0014f793          	andi	a5,s1,1
    80000fc6:	cf85                	beqz	a5,80000ffe <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fc8:	80a9                	srli	s1,s1,0xa
    80000fca:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000fcc:	3a5d                	addiw	s4,s4,-9
    80000fce:	ff5a12e3          	bne	s4,s5,80000fb2 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fd2:	00c9d513          	srli	a0,s3,0xc
    80000fd6:	1ff57513          	andi	a0,a0,511
    80000fda:	050e                	slli	a0,a0,0x3
    80000fdc:	9526                	add	a0,a0,s1
}
    80000fde:	70e2                	ld	ra,56(sp)
    80000fe0:	7442                	ld	s0,48(sp)
    80000fe2:	74a2                	ld	s1,40(sp)
    80000fe4:	7902                	ld	s2,32(sp)
    80000fe6:	69e2                	ld	s3,24(sp)
    80000fe8:	6a42                	ld	s4,16(sp)
    80000fea:	6aa2                	ld	s5,8(sp)
    80000fec:	6b02                	ld	s6,0(sp)
    80000fee:	6121                	addi	sp,sp,64
    80000ff0:	8082                	ret
    panic("walk");
    80000ff2:	00007517          	auipc	a0,0x7
    80000ff6:	0ae50513          	addi	a0,a0,174 # 800080a0 <etext+0xa0>
    80000ffa:	82bff0ef          	jal	80000824 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000ffe:	020b0263          	beqz	s6,80001022 <walk+0x96>
    80001002:	b43ff0ef          	jal	80000b44 <kalloc>
    80001006:	84aa                	mv	s1,a0
    80001008:	d979                	beqz	a0,80000fde <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    8000100a:	6605                	lui	a2,0x1
    8000100c:	4581                	li	a1,0
    8000100e:	cebff0ef          	jal	80000cf8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001012:	00c4d793          	srli	a5,s1,0xc
    80001016:	07aa                	slli	a5,a5,0xa
    80001018:	0017e793          	ori	a5,a5,1
    8000101c:	00f93023          	sd	a5,0(s2)
    80001020:	b775                	j	80000fcc <walk+0x40>
        return 0;
    80001022:	4501                	li	a0,0
    80001024:	bf6d                	j	80000fde <walk+0x52>

0000000080001026 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001026:	57fd                	li	a5,-1
    80001028:	83e9                	srli	a5,a5,0x1a
    8000102a:	00b7f463          	bgeu	a5,a1,80001032 <walkaddr+0xc>
    return 0;
    8000102e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001030:	8082                	ret
{
    80001032:	1141                	addi	sp,sp,-16
    80001034:	e406                	sd	ra,8(sp)
    80001036:	e022                	sd	s0,0(sp)
    80001038:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000103a:	4601                	li	a2,0
    8000103c:	f51ff0ef          	jal	80000f8c <walk>
  if(pte == 0)
    80001040:	c901                	beqz	a0,80001050 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    80001042:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001044:	0117f693          	andi	a3,a5,17
    80001048:	4745                	li	a4,17
    return 0;
    8000104a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000104c:	00e68663          	beq	a3,a4,80001058 <walkaddr+0x32>
}
    80001050:	60a2                	ld	ra,8(sp)
    80001052:	6402                	ld	s0,0(sp)
    80001054:	0141                	addi	sp,sp,16
    80001056:	8082                	ret
  pa = PTE2PA(*pte);
    80001058:	83a9                	srli	a5,a5,0xa
    8000105a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000105e:	bfcd                	j	80001050 <walkaddr+0x2a>

0000000080001060 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001060:	715d                	addi	sp,sp,-80
    80001062:	e486                	sd	ra,72(sp)
    80001064:	e0a2                	sd	s0,64(sp)
    80001066:	fc26                	sd	s1,56(sp)
    80001068:	f84a                	sd	s2,48(sp)
    8000106a:	f44e                	sd	s3,40(sp)
    8000106c:	f052                	sd	s4,32(sp)
    8000106e:	ec56                	sd	s5,24(sp)
    80001070:	e85a                	sd	s6,16(sp)
    80001072:	e45e                	sd	s7,8(sp)
    80001074:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001076:	03459793          	slli	a5,a1,0x34
    8000107a:	eba1                	bnez	a5,800010ca <mappages+0x6a>
    8000107c:	8a2a                	mv	s4,a0
    8000107e:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001080:	03461793          	slli	a5,a2,0x34
    80001084:	eba9                	bnez	a5,800010d6 <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    80001086:	ce31                	beqz	a2,800010e2 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001088:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000108c:	80060613          	addi	a2,a2,-2048
    80001090:	00b60933          	add	s2,a2,a1
  a = va;
    80001094:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001096:	4b05                	li	s6,1
    80001098:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000109c:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    8000109e:	865a                	mv	a2,s6
    800010a0:	85a6                	mv	a1,s1
    800010a2:	8552                	mv	a0,s4
    800010a4:	ee9ff0ef          	jal	80000f8c <walk>
    800010a8:	c929                	beqz	a0,800010fa <mappages+0x9a>
    if(*pte & PTE_V)
    800010aa:	611c                	ld	a5,0(a0)
    800010ac:	8b85                	andi	a5,a5,1
    800010ae:	e3a1                	bnez	a5,800010ee <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010b0:	013487b3          	add	a5,s1,s3
    800010b4:	83b1                	srli	a5,a5,0xc
    800010b6:	07aa                	slli	a5,a5,0xa
    800010b8:	0157e7b3          	or	a5,a5,s5
    800010bc:	0017e793          	ori	a5,a5,1
    800010c0:	e11c                	sd	a5,0(a0)
    if(a == last)
    800010c2:	05248863          	beq	s1,s2,80001112 <mappages+0xb2>
    a += PGSIZE;
    800010c6:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010c8:	bfd9                	j	8000109e <mappages+0x3e>
    panic("mappages: va not aligned");
    800010ca:	00007517          	auipc	a0,0x7
    800010ce:	fde50513          	addi	a0,a0,-34 # 800080a8 <etext+0xa8>
    800010d2:	f52ff0ef          	jal	80000824 <panic>
    panic("mappages: size not aligned");
    800010d6:	00007517          	auipc	a0,0x7
    800010da:	ff250513          	addi	a0,a0,-14 # 800080c8 <etext+0xc8>
    800010de:	f46ff0ef          	jal	80000824 <panic>
    panic("mappages: size");
    800010e2:	00007517          	auipc	a0,0x7
    800010e6:	00650513          	addi	a0,a0,6 # 800080e8 <etext+0xe8>
    800010ea:	f3aff0ef          	jal	80000824 <panic>
      panic("mappages: remap");
    800010ee:	00007517          	auipc	a0,0x7
    800010f2:	00a50513          	addi	a0,a0,10 # 800080f8 <etext+0xf8>
    800010f6:	f2eff0ef          	jal	80000824 <panic>
      return -1;
    800010fa:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010fc:	60a6                	ld	ra,72(sp)
    800010fe:	6406                	ld	s0,64(sp)
    80001100:	74e2                	ld	s1,56(sp)
    80001102:	7942                	ld	s2,48(sp)
    80001104:	79a2                	ld	s3,40(sp)
    80001106:	7a02                	ld	s4,32(sp)
    80001108:	6ae2                	ld	s5,24(sp)
    8000110a:	6b42                	ld	s6,16(sp)
    8000110c:	6ba2                	ld	s7,8(sp)
    8000110e:	6161                	addi	sp,sp,80
    80001110:	8082                	ret
  return 0;
    80001112:	4501                	li	a0,0
    80001114:	b7e5                	j	800010fc <mappages+0x9c>

0000000080001116 <kvmmap>:
{
    80001116:	1141                	addi	sp,sp,-16
    80001118:	e406                	sd	ra,8(sp)
    8000111a:	e022                	sd	s0,0(sp)
    8000111c:	0800                	addi	s0,sp,16
    8000111e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001120:	86b2                	mv	a3,a2
    80001122:	863e                	mv	a2,a5
    80001124:	f3dff0ef          	jal	80001060 <mappages>
    80001128:	e509                	bnez	a0,80001132 <kvmmap+0x1c>
}
    8000112a:	60a2                	ld	ra,8(sp)
    8000112c:	6402                	ld	s0,0(sp)
    8000112e:	0141                	addi	sp,sp,16
    80001130:	8082                	ret
    panic("kvmmap");
    80001132:	00007517          	auipc	a0,0x7
    80001136:	fd650513          	addi	a0,a0,-42 # 80008108 <etext+0x108>
    8000113a:	eeaff0ef          	jal	80000824 <panic>

000000008000113e <kvmmake>:
{
    8000113e:	1101                	addi	sp,sp,-32
    80001140:	ec06                	sd	ra,24(sp)
    80001142:	e822                	sd	s0,16(sp)
    80001144:	e426                	sd	s1,8(sp)
    80001146:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001148:	9fdff0ef          	jal	80000b44 <kalloc>
    8000114c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000114e:	6605                	lui	a2,0x1
    80001150:	4581                	li	a1,0
    80001152:	ba7ff0ef          	jal	80000cf8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001156:	4719                	li	a4,6
    80001158:	6685                	lui	a3,0x1
    8000115a:	10000637          	lui	a2,0x10000
    8000115e:	85b2                	mv	a1,a2
    80001160:	8526                	mv	a0,s1
    80001162:	fb5ff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001166:	4719                	li	a4,6
    80001168:	6685                	lui	a3,0x1
    8000116a:	10001637          	lui	a2,0x10001
    8000116e:	85b2                	mv	a1,a2
    80001170:	8526                	mv	a0,s1
    80001172:	fa5ff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001176:	4719                	li	a4,6
    80001178:	040006b7          	lui	a3,0x4000
    8000117c:	0c000637          	lui	a2,0xc000
    80001180:	85b2                	mv	a1,a2
    80001182:	8526                	mv	a0,s1
    80001184:	f93ff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001188:	4729                	li	a4,10
    8000118a:	80007697          	auipc	a3,0x80007
    8000118e:	e7668693          	addi	a3,a3,-394 # 8000 <_entry-0x7fff8000>
    80001192:	4605                	li	a2,1
    80001194:	067e                	slli	a2,a2,0x1f
    80001196:	85b2                	mv	a1,a2
    80001198:	8526                	mv	a0,s1
    8000119a:	f7dff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000119e:	4719                	li	a4,6
    800011a0:	00007697          	auipc	a3,0x7
    800011a4:	e6068693          	addi	a3,a3,-416 # 80008000 <etext>
    800011a8:	47c5                	li	a5,17
    800011aa:	07ee                	slli	a5,a5,0x1b
    800011ac:	40d786b3          	sub	a3,a5,a3
    800011b0:	00007617          	auipc	a2,0x7
    800011b4:	e5060613          	addi	a2,a2,-432 # 80008000 <etext>
    800011b8:	85b2                	mv	a1,a2
    800011ba:	8526                	mv	a0,s1
    800011bc:	f5bff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011c0:	4729                	li	a4,10
    800011c2:	6685                	lui	a3,0x1
    800011c4:	00006617          	auipc	a2,0x6
    800011c8:	e3c60613          	addi	a2,a2,-452 # 80007000 <_trampoline>
    800011cc:	040005b7          	lui	a1,0x4000
    800011d0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d2:	05b2                	slli	a1,a1,0xc
    800011d4:	8526                	mv	a0,s1
    800011d6:	f41ff0ef          	jal	80001116 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011da:	8526                	mv	a0,s1
    800011dc:	5c4000ef          	jal	800017a0 <proc_mapstacks>
}
    800011e0:	8526                	mv	a0,s1
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <kvminit>:
{
    800011ec:	1141                	addi	sp,sp,-16
    800011ee:	e406                	sd	ra,8(sp)
    800011f0:	e022                	sd	s0,0(sp)
    800011f2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011f4:	f4bff0ef          	jal	8000113e <kvmmake>
    800011f8:	00008797          	auipc	a5,0x8
    800011fc:	90a7b823          	sd	a0,-1776(a5) # 80008b08 <kernel_pagetable>
}
    80001200:	60a2                	ld	ra,8(sp)
    80001202:	6402                	ld	s0,0(sp)
    80001204:	0141                	addi	sp,sp,16
    80001206:	8082                	ret

0000000080001208 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001208:	1101                	addi	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001212:	933ff0ef          	jal	80000b44 <kalloc>
    80001216:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001218:	c509                	beqz	a0,80001222 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000121a:	6605                	lui	a2,0x1
    8000121c:	4581                	li	a1,0
    8000121e:	adbff0ef          	jal	80000cf8 <memset>
  return pagetable;
}
    80001222:	8526                	mv	a0,s1
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret

000000008000122e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000122e:	7139                	addi	sp,sp,-64
    80001230:	fc06                	sd	ra,56(sp)
    80001232:	f822                	sd	s0,48(sp)
    80001234:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001236:	03459793          	slli	a5,a1,0x34
    8000123a:	e38d                	bnez	a5,8000125c <uvmunmap+0x2e>
    8000123c:	f04a                	sd	s2,32(sp)
    8000123e:	ec4e                	sd	s3,24(sp)
    80001240:	e852                	sd	s4,16(sp)
    80001242:	e456                	sd	s5,8(sp)
    80001244:	e05a                	sd	s6,0(sp)
    80001246:	8a2a                	mv	s4,a0
    80001248:	892e                	mv	s2,a1
    8000124a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000124c:	0632                	slli	a2,a2,0xc
    8000124e:	00b609b3          	add	s3,a2,a1
    80001252:	6b05                	lui	s6,0x1
    80001254:	0535f963          	bgeu	a1,s3,800012a6 <uvmunmap+0x78>
    80001258:	f426                	sd	s1,40(sp)
    8000125a:	a015                	j	8000127e <uvmunmap+0x50>
    8000125c:	f426                	sd	s1,40(sp)
    8000125e:	f04a                	sd	s2,32(sp)
    80001260:	ec4e                	sd	s3,24(sp)
    80001262:	e852                	sd	s4,16(sp)
    80001264:	e456                	sd	s5,8(sp)
    80001266:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001268:	00007517          	auipc	a0,0x7
    8000126c:	ea850513          	addi	a0,a0,-344 # 80008110 <etext+0x110>
    80001270:	db4ff0ef          	jal	80000824 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001274:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001278:	995a                	add	s2,s2,s6
    8000127a:	03397563          	bgeu	s2,s3,800012a4 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000127e:	4601                	li	a2,0
    80001280:	85ca                	mv	a1,s2
    80001282:	8552                	mv	a0,s4
    80001284:	d09ff0ef          	jal	80000f8c <walk>
    80001288:	84aa                	mv	s1,a0
    8000128a:	d57d                	beqz	a0,80001278 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    8000128c:	611c                	ld	a5,0(a0)
    8000128e:	0017f713          	andi	a4,a5,1
    80001292:	d37d                	beqz	a4,80001278 <uvmunmap+0x4a>
    if(do_free){
    80001294:	fe0a80e3          	beqz	s5,80001274 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001298:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    8000129a:	00c79513          	slli	a0,a5,0xc
    8000129e:	fbeff0ef          	jal	80000a5c <kfree>
    800012a2:	bfc9                	j	80001274 <uvmunmap+0x46>
    800012a4:	74a2                	ld	s1,40(sp)
    800012a6:	7902                	ld	s2,32(sp)
    800012a8:	69e2                	ld	s3,24(sp)
    800012aa:	6a42                	ld	s4,16(sp)
    800012ac:	6aa2                	ld	s5,8(sp)
    800012ae:	6b02                	ld	s6,0(sp)
  }
}
    800012b0:	70e2                	ld	ra,56(sp)
    800012b2:	7442                	ld	s0,48(sp)
    800012b4:	6121                	addi	sp,sp,64
    800012b6:	8082                	ret

00000000800012b8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012b8:	1101                	addi	sp,sp,-32
    800012ba:	ec06                	sd	ra,24(sp)
    800012bc:	e822                	sd	s0,16(sp)
    800012be:	e426                	sd	s1,8(sp)
    800012c0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012c2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012c4:	00b67d63          	bgeu	a2,a1,800012de <uvmdealloc+0x26>
    800012c8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012ca:	6785                	lui	a5,0x1
    800012cc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ce:	00f60733          	add	a4,a2,a5
    800012d2:	76fd                	lui	a3,0xfffff
    800012d4:	8f75                	and	a4,a4,a3
    800012d6:	97ae                	add	a5,a5,a1
    800012d8:	8ff5                	and	a5,a5,a3
    800012da:	00f76863          	bltu	a4,a5,800012ea <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012de:	8526                	mv	a0,s1
    800012e0:	60e2                	ld	ra,24(sp)
    800012e2:	6442                	ld	s0,16(sp)
    800012e4:	64a2                	ld	s1,8(sp)
    800012e6:	6105                	addi	sp,sp,32
    800012e8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012ea:	8f99                	sub	a5,a5,a4
    800012ec:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012ee:	4685                	li	a3,1
    800012f0:	0007861b          	sext.w	a2,a5
    800012f4:	85ba                	mv	a1,a4
    800012f6:	f39ff0ef          	jal	8000122e <uvmunmap>
    800012fa:	b7d5                	j	800012de <uvmdealloc+0x26>

00000000800012fc <uvmalloc>:
  if(newsz < oldsz)
    800012fc:	0ab66163          	bltu	a2,a1,8000139e <uvmalloc+0xa2>
{
    80001300:	715d                	addi	sp,sp,-80
    80001302:	e486                	sd	ra,72(sp)
    80001304:	e0a2                	sd	s0,64(sp)
    80001306:	f84a                	sd	s2,48(sp)
    80001308:	f052                	sd	s4,32(sp)
    8000130a:	ec56                	sd	s5,24(sp)
    8000130c:	e45e                	sd	s7,8(sp)
    8000130e:	0880                	addi	s0,sp,80
    80001310:	8aaa                	mv	s5,a0
    80001312:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001314:	6785                	lui	a5,0x1
    80001316:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001318:	95be                	add	a1,a1,a5
    8000131a:	77fd                	lui	a5,0xfffff
    8000131c:	00f5f933          	and	s2,a1,a5
    80001320:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001322:	08c97063          	bgeu	s2,a2,800013a2 <uvmalloc+0xa6>
    80001326:	fc26                	sd	s1,56(sp)
    80001328:	f44e                	sd	s3,40(sp)
    8000132a:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    8000132c:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000132e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001332:	813ff0ef          	jal	80000b44 <kalloc>
    80001336:	84aa                	mv	s1,a0
    if(mem == 0){
    80001338:	c50d                	beqz	a0,80001362 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    8000133a:	864e                	mv	a2,s3
    8000133c:	4581                	li	a1,0
    8000133e:	9bbff0ef          	jal	80000cf8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001342:	875a                	mv	a4,s6
    80001344:	86a6                	mv	a3,s1
    80001346:	864e                	mv	a2,s3
    80001348:	85ca                	mv	a1,s2
    8000134a:	8556                	mv	a0,s5
    8000134c:	d15ff0ef          	jal	80001060 <mappages>
    80001350:	e915                	bnez	a0,80001384 <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001352:	994e                	add	s2,s2,s3
    80001354:	fd496fe3          	bltu	s2,s4,80001332 <uvmalloc+0x36>
  return newsz;
    80001358:	8552                	mv	a0,s4
    8000135a:	74e2                	ld	s1,56(sp)
    8000135c:	79a2                	ld	s3,40(sp)
    8000135e:	6b42                	ld	s6,16(sp)
    80001360:	a811                	j	80001374 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80001362:	865e                	mv	a2,s7
    80001364:	85ca                	mv	a1,s2
    80001366:	8556                	mv	a0,s5
    80001368:	f51ff0ef          	jal	800012b8 <uvmdealloc>
      return 0;
    8000136c:	4501                	li	a0,0
    8000136e:	74e2                	ld	s1,56(sp)
    80001370:	79a2                	ld	s3,40(sp)
    80001372:	6b42                	ld	s6,16(sp)
}
    80001374:	60a6                	ld	ra,72(sp)
    80001376:	6406                	ld	s0,64(sp)
    80001378:	7942                	ld	s2,48(sp)
    8000137a:	7a02                	ld	s4,32(sp)
    8000137c:	6ae2                	ld	s5,24(sp)
    8000137e:	6ba2                	ld	s7,8(sp)
    80001380:	6161                	addi	sp,sp,80
    80001382:	8082                	ret
      kfree(mem);
    80001384:	8526                	mv	a0,s1
    80001386:	ed6ff0ef          	jal	80000a5c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000138a:	865e                	mv	a2,s7
    8000138c:	85ca                	mv	a1,s2
    8000138e:	8556                	mv	a0,s5
    80001390:	f29ff0ef          	jal	800012b8 <uvmdealloc>
      return 0;
    80001394:	4501                	li	a0,0
    80001396:	74e2                	ld	s1,56(sp)
    80001398:	79a2                	ld	s3,40(sp)
    8000139a:	6b42                	ld	s6,16(sp)
    8000139c:	bfe1                	j	80001374 <uvmalloc+0x78>
    return oldsz;
    8000139e:	852e                	mv	a0,a1
}
    800013a0:	8082                	ret
  return newsz;
    800013a2:	8532                	mv	a0,a2
    800013a4:	bfc1                	j	80001374 <uvmalloc+0x78>

00000000800013a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013a6:	7179                	addi	sp,sp,-48
    800013a8:	f406                	sd	ra,40(sp)
    800013aa:	f022                	sd	s0,32(sp)
    800013ac:	ec26                	sd	s1,24(sp)
    800013ae:	e84a                	sd	s2,16(sp)
    800013b0:	e44e                	sd	s3,8(sp)
    800013b2:	1800                	addi	s0,sp,48
    800013b4:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013b6:	84aa                	mv	s1,a0
    800013b8:	6905                	lui	s2,0x1
    800013ba:	992a                	add	s2,s2,a0
    800013bc:	a811                	j	800013d0 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    800013be:	00007517          	auipc	a0,0x7
    800013c2:	d6a50513          	addi	a0,a0,-662 # 80008128 <etext+0x128>
    800013c6:	c5eff0ef          	jal	80000824 <panic>
  for(int i = 0; i < 512; i++){
    800013ca:	04a1                	addi	s1,s1,8
    800013cc:	03248163          	beq	s1,s2,800013ee <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013d0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013d2:	0017f713          	andi	a4,a5,1
    800013d6:	db75                	beqz	a4,800013ca <freewalk+0x24>
    800013d8:	00e7f713          	andi	a4,a5,14
    800013dc:	f36d                	bnez	a4,800013be <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800013de:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013e0:	00c79513          	slli	a0,a5,0xc
    800013e4:	fc3ff0ef          	jal	800013a6 <freewalk>
      pagetable[i] = 0;
    800013e8:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013ec:	bff9                	j	800013ca <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    800013ee:	854e                	mv	a0,s3
    800013f0:	e6cff0ef          	jal	80000a5c <kfree>
}
    800013f4:	70a2                	ld	ra,40(sp)
    800013f6:	7402                	ld	s0,32(sp)
    800013f8:	64e2                	ld	s1,24(sp)
    800013fa:	6942                	ld	s2,16(sp)
    800013fc:	69a2                	ld	s3,8(sp)
    800013fe:	6145                	addi	sp,sp,48
    80001400:	8082                	ret

0000000080001402 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001402:	1101                	addi	sp,sp,-32
    80001404:	ec06                	sd	ra,24(sp)
    80001406:	e822                	sd	s0,16(sp)
    80001408:	e426                	sd	s1,8(sp)
    8000140a:	1000                	addi	s0,sp,32
    8000140c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000140e:	e989                	bnez	a1,80001420 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001410:	8526                	mv	a0,s1
    80001412:	f95ff0ef          	jal	800013a6 <freewalk>
}
    80001416:	60e2                	ld	ra,24(sp)
    80001418:	6442                	ld	s0,16(sp)
    8000141a:	64a2                	ld	s1,8(sp)
    8000141c:	6105                	addi	sp,sp,32
    8000141e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001420:	6785                	lui	a5,0x1
    80001422:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001424:	95be                	add	a1,a1,a5
    80001426:	4685                	li	a3,1
    80001428:	00c5d613          	srli	a2,a1,0xc
    8000142c:	4581                	li	a1,0
    8000142e:	e01ff0ef          	jal	8000122e <uvmunmap>
    80001432:	bff9                	j	80001410 <uvmfree+0xe>

0000000080001434 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001434:	ca59                	beqz	a2,800014ca <uvmcopy+0x96>
{
    80001436:	715d                	addi	sp,sp,-80
    80001438:	e486                	sd	ra,72(sp)
    8000143a:	e0a2                	sd	s0,64(sp)
    8000143c:	fc26                	sd	s1,56(sp)
    8000143e:	f84a                	sd	s2,48(sp)
    80001440:	f44e                	sd	s3,40(sp)
    80001442:	f052                	sd	s4,32(sp)
    80001444:	ec56                	sd	s5,24(sp)
    80001446:	e85a                	sd	s6,16(sp)
    80001448:	e45e                	sd	s7,8(sp)
    8000144a:	0880                	addi	s0,sp,80
    8000144c:	8b2a                	mv	s6,a0
    8000144e:	8bae                	mv	s7,a1
    80001450:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001452:	4481                	li	s1,0
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001454:	6a05                	lui	s4,0x1
    80001456:	a021                	j	8000145e <uvmcopy+0x2a>
  for(i = 0; i < sz; i += PGSIZE){
    80001458:	94d2                	add	s1,s1,s4
    8000145a:	0554fc63          	bgeu	s1,s5,800014b2 <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    8000145e:	4601                	li	a2,0
    80001460:	85a6                	mv	a1,s1
    80001462:	855a                	mv	a0,s6
    80001464:	b29ff0ef          	jal	80000f8c <walk>
    80001468:	d965                	beqz	a0,80001458 <uvmcopy+0x24>
    if((*pte & PTE_V) == 0)
    8000146a:	00053983          	ld	s3,0(a0)
    8000146e:	0019f793          	andi	a5,s3,1
    80001472:	d3fd                	beqz	a5,80001458 <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    80001474:	ed0ff0ef          	jal	80000b44 <kalloc>
    80001478:	892a                	mv	s2,a0
    8000147a:	c11d                	beqz	a0,800014a0 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000147c:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80001480:	8652                	mv	a2,s4
    80001482:	05b2                	slli	a1,a1,0xc
    80001484:	8d5ff0ef          	jal	80000d58 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001488:	3ff9f713          	andi	a4,s3,1023
    8000148c:	86ca                	mv	a3,s2
    8000148e:	8652                	mv	a2,s4
    80001490:	85a6                	mv	a1,s1
    80001492:	855e                	mv	a0,s7
    80001494:	bcdff0ef          	jal	80001060 <mappages>
    80001498:	d161                	beqz	a0,80001458 <uvmcopy+0x24>
      kfree(mem);
    8000149a:	854a                	mv	a0,s2
    8000149c:	dc0ff0ef          	jal	80000a5c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014a0:	4685                	li	a3,1
    800014a2:	00c4d613          	srli	a2,s1,0xc
    800014a6:	4581                	li	a1,0
    800014a8:	855e                	mv	a0,s7
    800014aa:	d85ff0ef          	jal	8000122e <uvmunmap>
  return -1;
    800014ae:	557d                	li	a0,-1
    800014b0:	a011                	j	800014b4 <uvmcopy+0x80>
  return 0;
    800014b2:	4501                	li	a0,0
}
    800014b4:	60a6                	ld	ra,72(sp)
    800014b6:	6406                	ld	s0,64(sp)
    800014b8:	74e2                	ld	s1,56(sp)
    800014ba:	7942                	ld	s2,48(sp)
    800014bc:	79a2                	ld	s3,40(sp)
    800014be:	7a02                	ld	s4,32(sp)
    800014c0:	6ae2                	ld	s5,24(sp)
    800014c2:	6b42                	ld	s6,16(sp)
    800014c4:	6ba2                	ld	s7,8(sp)
    800014c6:	6161                	addi	sp,sp,80
    800014c8:	8082                	ret
  return 0;
    800014ca:	4501                	li	a0,0
}
    800014cc:	8082                	ret

00000000800014ce <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014ce:	1141                	addi	sp,sp,-16
    800014d0:	e406                	sd	ra,8(sp)
    800014d2:	e022                	sd	s0,0(sp)
    800014d4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014d6:	4601                	li	a2,0
    800014d8:	ab5ff0ef          	jal	80000f8c <walk>
  if(pte == 0)
    800014dc:	c901                	beqz	a0,800014ec <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014de:	611c                	ld	a5,0(a0)
    800014e0:	9bbd                	andi	a5,a5,-17
    800014e2:	e11c                	sd	a5,0(a0)
}
    800014e4:	60a2                	ld	ra,8(sp)
    800014e6:	6402                	ld	s0,0(sp)
    800014e8:	0141                	addi	sp,sp,16
    800014ea:	8082                	ret
    panic("uvmclear");
    800014ec:	00007517          	auipc	a0,0x7
    800014f0:	c4c50513          	addi	a0,a0,-948 # 80008138 <etext+0x138>
    800014f4:	b30ff0ef          	jal	80000824 <panic>

00000000800014f8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800014f8:	cac5                	beqz	a3,800015a8 <copyinstr+0xb0>
{
    800014fa:	715d                	addi	sp,sp,-80
    800014fc:	e486                	sd	ra,72(sp)
    800014fe:	e0a2                	sd	s0,64(sp)
    80001500:	fc26                	sd	s1,56(sp)
    80001502:	f84a                	sd	s2,48(sp)
    80001504:	f44e                	sd	s3,40(sp)
    80001506:	f052                	sd	s4,32(sp)
    80001508:	ec56                	sd	s5,24(sp)
    8000150a:	e85a                	sd	s6,16(sp)
    8000150c:	e45e                	sd	s7,8(sp)
    8000150e:	0880                	addi	s0,sp,80
    80001510:	8aaa                	mv	s5,a0
    80001512:	84ae                	mv	s1,a1
    80001514:	8bb2                	mv	s7,a2
    80001516:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001518:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000151a:	6a05                	lui	s4,0x1
    8000151c:	a82d                	j	80001556 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000151e:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80001522:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001524:	0017c793          	xori	a5,a5,1
    80001528:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000152c:	60a6                	ld	ra,72(sp)
    8000152e:	6406                	ld	s0,64(sp)
    80001530:	74e2                	ld	s1,56(sp)
    80001532:	7942                	ld	s2,48(sp)
    80001534:	79a2                	ld	s3,40(sp)
    80001536:	7a02                	ld	s4,32(sp)
    80001538:	6ae2                	ld	s5,24(sp)
    8000153a:	6b42                	ld	s6,16(sp)
    8000153c:	6ba2                	ld	s7,8(sp)
    8000153e:	6161                	addi	sp,sp,80
    80001540:	8082                	ret
    80001542:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001546:	9726                	add	a4,a4,s1
      --max;
    80001548:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    8000154c:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001550:	04e58463          	beq	a1,a4,80001598 <copyinstr+0xa0>
{
    80001554:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001556:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000155a:	85ca                	mv	a1,s2
    8000155c:	8556                	mv	a0,s5
    8000155e:	ac9ff0ef          	jal	80001026 <walkaddr>
    if(pa0 == 0)
    80001562:	cd0d                	beqz	a0,8000159c <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001564:	417906b3          	sub	a3,s2,s7
    80001568:	96d2                	add	a3,a3,s4
    if(n > max)
    8000156a:	00d9f363          	bgeu	s3,a3,80001570 <copyinstr+0x78>
    8000156e:	86ce                	mv	a3,s3
    while(n > 0){
    80001570:	ca85                	beqz	a3,800015a0 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80001572:	01750633          	add	a2,a0,s7
    80001576:	41260633          	sub	a2,a2,s2
    8000157a:	87a6                	mv	a5,s1
      if(*p == '\0'){
    8000157c:	8e05                	sub	a2,a2,s1
    while(n > 0){
    8000157e:	96a6                	add	a3,a3,s1
    80001580:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001582:	00f60733          	add	a4,a2,a5
    80001586:	00074703          	lbu	a4,0(a4)
    8000158a:	db51                	beqz	a4,8000151e <copyinstr+0x26>
        *dst = *p;
    8000158c:	00e78023          	sb	a4,0(a5)
      dst++;
    80001590:	0785                	addi	a5,a5,1
    while(n > 0){
    80001592:	fed797e3          	bne	a5,a3,80001580 <copyinstr+0x88>
    80001596:	b775                	j	80001542 <copyinstr+0x4a>
    80001598:	4781                	li	a5,0
    8000159a:	b769                	j	80001524 <copyinstr+0x2c>
      return -1;
    8000159c:	557d                	li	a0,-1
    8000159e:	b779                	j	8000152c <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    800015a0:	6b85                	lui	s7,0x1
    800015a2:	9bca                	add	s7,s7,s2
    800015a4:	87a6                	mv	a5,s1
    800015a6:	b77d                	j	80001554 <copyinstr+0x5c>
  int got_null = 0;
    800015a8:	4781                	li	a5,0
  if(got_null){
    800015aa:	0017c793          	xori	a5,a5,1
    800015ae:	40f0053b          	negw	a0,a5
}
    800015b2:	8082                	ret

00000000800015b4 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800015b4:	1141                	addi	sp,sp,-16
    800015b6:	e406                	sd	ra,8(sp)
    800015b8:	e022                	sd	s0,0(sp)
    800015ba:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800015bc:	4601                	li	a2,0
    800015be:	9cfff0ef          	jal	80000f8c <walk>
  if (pte == 0) {
    800015c2:	c119                	beqz	a0,800015c8 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    800015c4:	6108                	ld	a0,0(a0)
    800015c6:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800015c8:	60a2                	ld	ra,8(sp)
    800015ca:	6402                	ld	s0,0(sp)
    800015cc:	0141                	addi	sp,sp,16
    800015ce:	8082                	ret

00000000800015d0 <vmfault>:
{
    800015d0:	7179                	addi	sp,sp,-48
    800015d2:	f406                	sd	ra,40(sp)
    800015d4:	f022                	sd	s0,32(sp)
    800015d6:	e84a                	sd	s2,16(sp)
    800015d8:	e44e                	sd	s3,8(sp)
    800015da:	1800                	addi	s0,sp,48
    800015dc:	89aa                	mv	s3,a0
    800015de:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015e0:	336000ef          	jal	80001916 <myproc>
  if (va >= p->sz)
    800015e4:	653c                	ld	a5,72(a0)
    800015e6:	00f96a63          	bltu	s2,a5,800015fa <vmfault+0x2a>
    return 0;
    800015ea:	4981                	li	s3,0
}
    800015ec:	854e                	mv	a0,s3
    800015ee:	70a2                	ld	ra,40(sp)
    800015f0:	7402                	ld	s0,32(sp)
    800015f2:	6942                	ld	s2,16(sp)
    800015f4:	69a2                	ld	s3,8(sp)
    800015f6:	6145                	addi	sp,sp,48
    800015f8:	8082                	ret
    800015fa:	ec26                	sd	s1,24(sp)
    800015fc:	e052                	sd	s4,0(sp)
    800015fe:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80001600:	77fd                	lui	a5,0xfffff
    80001602:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80001606:	85d2                	mv	a1,s4
    80001608:	854e                	mv	a0,s3
    8000160a:	fabff0ef          	jal	800015b4 <ismapped>
    return 0;
    8000160e:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80001610:	c501                	beqz	a0,80001618 <vmfault+0x48>
    80001612:	64e2                	ld	s1,24(sp)
    80001614:	6a02                	ld	s4,0(sp)
    80001616:	bfd9                	j	800015ec <vmfault+0x1c>
  mem = (uint64) kalloc();
    80001618:	d2cff0ef          	jal	80000b44 <kalloc>
    8000161c:	892a                	mv	s2,a0
  if(mem == 0)
    8000161e:	c905                	beqz	a0,8000164e <vmfault+0x7e>
  mem = (uint64) kalloc();
    80001620:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80001622:	6605                	lui	a2,0x1
    80001624:	4581                	li	a1,0
    80001626:	ed2ff0ef          	jal	80000cf8 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    8000162a:	4759                	li	a4,22
    8000162c:	86ca                	mv	a3,s2
    8000162e:	6605                	lui	a2,0x1
    80001630:	85d2                	mv	a1,s4
    80001632:	68a8                	ld	a0,80(s1)
    80001634:	a2dff0ef          	jal	80001060 <mappages>
    80001638:	e501                	bnez	a0,80001640 <vmfault+0x70>
    8000163a:	64e2                	ld	s1,24(sp)
    8000163c:	6a02                	ld	s4,0(sp)
    8000163e:	b77d                	j	800015ec <vmfault+0x1c>
    kfree((void *)mem);
    80001640:	854a                	mv	a0,s2
    80001642:	c1aff0ef          	jal	80000a5c <kfree>
    return 0;
    80001646:	4981                	li	s3,0
    80001648:	64e2                	ld	s1,24(sp)
    8000164a:	6a02                	ld	s4,0(sp)
    8000164c:	b745                	j	800015ec <vmfault+0x1c>
    8000164e:	64e2                	ld	s1,24(sp)
    80001650:	6a02                	ld	s4,0(sp)
    80001652:	bf69                	j	800015ec <vmfault+0x1c>

0000000080001654 <copyout>:
  while(len > 0){
    80001654:	cad1                	beqz	a3,800016e8 <copyout+0x94>
{
    80001656:	711d                	addi	sp,sp,-96
    80001658:	ec86                	sd	ra,88(sp)
    8000165a:	e8a2                	sd	s0,80(sp)
    8000165c:	e4a6                	sd	s1,72(sp)
    8000165e:	e0ca                	sd	s2,64(sp)
    80001660:	fc4e                	sd	s3,56(sp)
    80001662:	f852                	sd	s4,48(sp)
    80001664:	f456                	sd	s5,40(sp)
    80001666:	f05a                	sd	s6,32(sp)
    80001668:	ec5e                	sd	s7,24(sp)
    8000166a:	e862                	sd	s8,16(sp)
    8000166c:	e466                	sd	s9,8(sp)
    8000166e:	e06a                	sd	s10,0(sp)
    80001670:	1080                	addi	s0,sp,96
    80001672:	8baa                	mv	s7,a0
    80001674:	8a2e                	mv	s4,a1
    80001676:	8b32                	mv	s6,a2
    80001678:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    8000167a:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    8000167c:	5cfd                	li	s9,-1
    8000167e:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001682:	6c05                	lui	s8,0x1
    80001684:	a005                	j	800016a4 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001686:	409a0533          	sub	a0,s4,s1
    8000168a:	0009061b          	sext.w	a2,s2
    8000168e:	85da                	mv	a1,s6
    80001690:	954e                	add	a0,a0,s3
    80001692:	ec6ff0ef          	jal	80000d58 <memmove>
    len -= n;
    80001696:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000169a:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000169c:	01848a33          	add	s4,s1,s8
  while(len > 0){
    800016a0:	040a8263          	beqz	s5,800016e4 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    800016a4:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    800016a8:	049ce263          	bltu	s9,s1,800016ec <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    800016ac:	85a6                	mv	a1,s1
    800016ae:	855e                	mv	a0,s7
    800016b0:	977ff0ef          	jal	80001026 <walkaddr>
    800016b4:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    800016b6:	e901                	bnez	a0,800016c6 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    800016b8:	4601                	li	a2,0
    800016ba:	85a6                	mv	a1,s1
    800016bc:	855e                	mv	a0,s7
    800016be:	f13ff0ef          	jal	800015d0 <vmfault>
    800016c2:	89aa                	mv	s3,a0
    800016c4:	c139                	beqz	a0,8000170a <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    800016c6:	4601                	li	a2,0
    800016c8:	85a6                	mv	a1,s1
    800016ca:	855e                	mv	a0,s7
    800016cc:	8c1ff0ef          	jal	80000f8c <walk>
    if((*pte & PTE_W) == 0)
    800016d0:	611c                	ld	a5,0(a0)
    800016d2:	8b91                	andi	a5,a5,4
    800016d4:	cf8d                	beqz	a5,8000170e <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    800016d6:	41448933          	sub	s2,s1,s4
    800016da:	9962                	add	s2,s2,s8
    if(n > len)
    800016dc:	fb2af5e3          	bgeu	s5,s2,80001686 <copyout+0x32>
    800016e0:	8956                	mv	s2,s5
    800016e2:	b755                	j	80001686 <copyout+0x32>
  return 0;
    800016e4:	4501                	li	a0,0
    800016e6:	a021                	j	800016ee <copyout+0x9a>
    800016e8:	4501                	li	a0,0
}
    800016ea:	8082                	ret
      return -1;
    800016ec:	557d                	li	a0,-1
}
    800016ee:	60e6                	ld	ra,88(sp)
    800016f0:	6446                	ld	s0,80(sp)
    800016f2:	64a6                	ld	s1,72(sp)
    800016f4:	6906                	ld	s2,64(sp)
    800016f6:	79e2                	ld	s3,56(sp)
    800016f8:	7a42                	ld	s4,48(sp)
    800016fa:	7aa2                	ld	s5,40(sp)
    800016fc:	7b02                	ld	s6,32(sp)
    800016fe:	6be2                	ld	s7,24(sp)
    80001700:	6c42                	ld	s8,16(sp)
    80001702:	6ca2                	ld	s9,8(sp)
    80001704:	6d02                	ld	s10,0(sp)
    80001706:	6125                	addi	sp,sp,96
    80001708:	8082                	ret
        return -1;
    8000170a:	557d                	li	a0,-1
    8000170c:	b7cd                	j	800016ee <copyout+0x9a>
      return -1;
    8000170e:	557d                	li	a0,-1
    80001710:	bff9                	j	800016ee <copyout+0x9a>

0000000080001712 <copyin>:
  while(len > 0){
    80001712:	c6c9                	beqz	a3,8000179c <copyin+0x8a>
{
    80001714:	715d                	addi	sp,sp,-80
    80001716:	e486                	sd	ra,72(sp)
    80001718:	e0a2                	sd	s0,64(sp)
    8000171a:	fc26                	sd	s1,56(sp)
    8000171c:	f84a                	sd	s2,48(sp)
    8000171e:	f44e                	sd	s3,40(sp)
    80001720:	f052                	sd	s4,32(sp)
    80001722:	ec56                	sd	s5,24(sp)
    80001724:	e85a                	sd	s6,16(sp)
    80001726:	e45e                	sd	s7,8(sp)
    80001728:	e062                	sd	s8,0(sp)
    8000172a:	0880                	addi	s0,sp,80
    8000172c:	8baa                	mv	s7,a0
    8000172e:	8aae                	mv	s5,a1
    80001730:	8932                	mv	s2,a2
    80001732:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001734:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80001736:	6b05                	lui	s6,0x1
    80001738:	a035                	j	80001764 <copyin+0x52>
    8000173a:	412984b3          	sub	s1,s3,s2
    8000173e:	94da                	add	s1,s1,s6
    if(n > len)
    80001740:	009a7363          	bgeu	s4,s1,80001746 <copyin+0x34>
    80001744:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001746:	413905b3          	sub	a1,s2,s3
    8000174a:	0004861b          	sext.w	a2,s1
    8000174e:	95aa                	add	a1,a1,a0
    80001750:	8556                	mv	a0,s5
    80001752:	e06ff0ef          	jal	80000d58 <memmove>
    len -= n;
    80001756:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000175a:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    8000175c:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001760:	020a0163          	beqz	s4,80001782 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001764:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001768:	85ce                	mv	a1,s3
    8000176a:	855e                	mv	a0,s7
    8000176c:	8bbff0ef          	jal	80001026 <walkaddr>
    if(pa0 == 0) {
    80001770:	f569                	bnez	a0,8000173a <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001772:	4601                	li	a2,0
    80001774:	85ce                	mv	a1,s3
    80001776:	855e                	mv	a0,s7
    80001778:	e59ff0ef          	jal	800015d0 <vmfault>
    8000177c:	fd5d                	bnez	a0,8000173a <copyin+0x28>
        return -1;
    8000177e:	557d                	li	a0,-1
    80001780:	a011                	j	80001784 <copyin+0x72>
  return 0;
    80001782:	4501                	li	a0,0
}
    80001784:	60a6                	ld	ra,72(sp)
    80001786:	6406                	ld	s0,64(sp)
    80001788:	74e2                	ld	s1,56(sp)
    8000178a:	7942                	ld	s2,48(sp)
    8000178c:	79a2                	ld	s3,40(sp)
    8000178e:	7a02                	ld	s4,32(sp)
    80001790:	6ae2                	ld	s5,24(sp)
    80001792:	6b42                	ld	s6,16(sp)
    80001794:	6ba2                	ld	s7,8(sp)
    80001796:	6c02                	ld	s8,0(sp)
    80001798:	6161                	addi	sp,sp,80
    8000179a:	8082                	ret
  return 0;
    8000179c:	4501                	li	a0,0
}
    8000179e:	8082                	ret

00000000800017a0 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800017a0:	715d                	addi	sp,sp,-80
    800017a2:	e486                	sd	ra,72(sp)
    800017a4:	e0a2                	sd	s0,64(sp)
    800017a6:	fc26                	sd	s1,56(sp)
    800017a8:	f84a                	sd	s2,48(sp)
    800017aa:	f44e                	sd	s3,40(sp)
    800017ac:	f052                	sd	s4,32(sp)
    800017ae:	ec56                	sd	s5,24(sp)
    800017b0:	e85a                	sd	s6,16(sp)
    800017b2:	e45e                	sd	s7,8(sp)
    800017b4:	e062                	sd	s8,0(sp)
    800017b6:	0880                	addi	s0,sp,80
    800017b8:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ba:	00010497          	auipc	s1,0x10
    800017be:	88e48493          	addi	s1,s1,-1906 # 80011048 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017c2:	8c26                	mv	s8,s1
    800017c4:	eeeef7b7          	lui	a5,0xeeeef
    800017c8:	eef78793          	addi	a5,a5,-273 # ffffffffeeeeeeef <end+0xffffffff6eecb267>
    800017cc:	02079993          	slli	s3,a5,0x20
    800017d0:	99be                	add	s3,s3,a5
    800017d2:	04000937          	lui	s2,0x4000
    800017d6:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800017d8:	0932                	slli	s2,s2,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017da:	4b99                	li	s7,6
    800017dc:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800017de:	00017a97          	auipc	s5,0x17
    800017e2:	06aa8a93          	addi	s5,s5,106 # 80018848 <tickslock>
    char *pa = kalloc();
    800017e6:	b5eff0ef          	jal	80000b44 <kalloc>
    800017ea:	862a                	mv	a2,a0
    if(pa == 0)
    800017ec:	c121                	beqz	a0,8000182c <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017ee:	418485b3          	sub	a1,s1,s8
    800017f2:	8595                	srai	a1,a1,0x5
    800017f4:	033585b3          	mul	a1,a1,s3
    800017f8:	05b6                	slli	a1,a1,0xd
    800017fa:	6789                	lui	a5,0x2
    800017fc:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017fe:	875e                	mv	a4,s7
    80001800:	86da                	mv	a3,s6
    80001802:	40b905b3          	sub	a1,s2,a1
    80001806:	8552                	mv	a0,s4
    80001808:	90fff0ef          	jal	80001116 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000180c:	1e048493          	addi	s1,s1,480
    80001810:	fd549be3          	bne	s1,s5,800017e6 <proc_mapstacks+0x46>
  }
}
    80001814:	60a6                	ld	ra,72(sp)
    80001816:	6406                	ld	s0,64(sp)
    80001818:	74e2                	ld	s1,56(sp)
    8000181a:	7942                	ld	s2,48(sp)
    8000181c:	79a2                	ld	s3,40(sp)
    8000181e:	7a02                	ld	s4,32(sp)
    80001820:	6ae2                	ld	s5,24(sp)
    80001822:	6b42                	ld	s6,16(sp)
    80001824:	6ba2                	ld	s7,8(sp)
    80001826:	6c02                	ld	s8,0(sp)
    80001828:	6161                	addi	sp,sp,80
    8000182a:	8082                	ret
      panic("kalloc");
    8000182c:	00007517          	auipc	a0,0x7
    80001830:	91c50513          	addi	a0,a0,-1764 # 80008148 <etext+0x148>
    80001834:	ff1fe0ef          	jal	80000824 <panic>

0000000080001838 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001838:	7139                	addi	sp,sp,-64
    8000183a:	fc06                	sd	ra,56(sp)
    8000183c:	f822                	sd	s0,48(sp)
    8000183e:	f426                	sd	s1,40(sp)
    80001840:	f04a                	sd	s2,32(sp)
    80001842:	ec4e                	sd	s3,24(sp)
    80001844:	e852                	sd	s4,16(sp)
    80001846:	e456                	sd	s5,8(sp)
    80001848:	e05a                	sd	s6,0(sp)
    8000184a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000184c:	00007597          	auipc	a1,0x7
    80001850:	90458593          	addi	a1,a1,-1788 # 80008150 <etext+0x150>
    80001854:	0000f517          	auipc	a0,0xf
    80001858:	3c450513          	addi	a0,a0,964 # 80010c18 <pid_lock>
    8000185c:	b42ff0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001860:	00007597          	auipc	a1,0x7
    80001864:	8f858593          	addi	a1,a1,-1800 # 80008158 <etext+0x158>
    80001868:	0000f517          	auipc	a0,0xf
    8000186c:	3c850513          	addi	a0,a0,968 # 80010c30 <wait_lock>
    80001870:	b2eff0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001874:	0000f497          	auipc	s1,0xf
    80001878:	7d448493          	addi	s1,s1,2004 # 80011048 <proc>
      initlock(&p->lock, "proc");
    8000187c:	00007b17          	auipc	s6,0x7
    80001880:	8ecb0b13          	addi	s6,s6,-1812 # 80008168 <etext+0x168>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001884:	8aa6                	mv	s5,s1
    80001886:	eeeef7b7          	lui	a5,0xeeeef
    8000188a:	eef78793          	addi	a5,a5,-273 # ffffffffeeeeeeef <end+0xffffffff6eecb267>
    8000188e:	02079993          	slli	s3,a5,0x20
    80001892:	99be                	add	s3,s3,a5
    80001894:	04000937          	lui	s2,0x4000
    80001898:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000189a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000189c:	00017a17          	auipc	s4,0x17
    800018a0:	faca0a13          	addi	s4,s4,-84 # 80018848 <tickslock>
      initlock(&p->lock, "proc");
    800018a4:	85da                	mv	a1,s6
    800018a6:	8526                	mv	a0,s1
    800018a8:	af6ff0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    800018ac:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018b0:	415487b3          	sub	a5,s1,s5
    800018b4:	8795                	srai	a5,a5,0x5
    800018b6:	033787b3          	mul	a5,a5,s3
    800018ba:	07b6                	slli	a5,a5,0xd
    800018bc:	6709                	lui	a4,0x2
    800018be:	9fb9                	addw	a5,a5,a4
    800018c0:	40f907b3          	sub	a5,s2,a5
    800018c4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018c6:	1e048493          	addi	s1,s1,480
    800018ca:	fd449de3          	bne	s1,s4,800018a4 <procinit+0x6c>
  }
}
    800018ce:	70e2                	ld	ra,56(sp)
    800018d0:	7442                	ld	s0,48(sp)
    800018d2:	74a2                	ld	s1,40(sp)
    800018d4:	7902                	ld	s2,32(sp)
    800018d6:	69e2                	ld	s3,24(sp)
    800018d8:	6a42                	ld	s4,16(sp)
    800018da:	6aa2                	ld	s5,8(sp)
    800018dc:	6b02                	ld	s6,0(sp)
    800018de:	6121                	addi	sp,sp,64
    800018e0:	8082                	ret

00000000800018e2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018e2:	1141                	addi	sp,sp,-16
    800018e4:	e406                	sd	ra,8(sp)
    800018e6:	e022                	sd	s0,0(sp)
    800018e8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018ea:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018ec:	2501                	sext.w	a0,a0
    800018ee:	60a2                	ld	ra,8(sp)
    800018f0:	6402                	ld	s0,0(sp)
    800018f2:	0141                	addi	sp,sp,16
    800018f4:	8082                	ret

00000000800018f6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018f6:	1141                	addi	sp,sp,-16
    800018f8:	e406                	sd	ra,8(sp)
    800018fa:	e022                	sd	s0,0(sp)
    800018fc:	0800                	addi	s0,sp,16
    800018fe:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001900:	2781                	sext.w	a5,a5
    80001902:	079e                	slli	a5,a5,0x7
  return c;
}
    80001904:	0000f517          	auipc	a0,0xf
    80001908:	34450513          	addi	a0,a0,836 # 80010c48 <cpus>
    8000190c:	953e                	add	a0,a0,a5
    8000190e:	60a2                	ld	ra,8(sp)
    80001910:	6402                	ld	s0,0(sp)
    80001912:	0141                	addi	sp,sp,16
    80001914:	8082                	ret

0000000080001916 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001916:	1101                	addi	sp,sp,-32
    80001918:	ec06                	sd	ra,24(sp)
    8000191a:	e822                	sd	s0,16(sp)
    8000191c:	e426                	sd	s1,8(sp)
    8000191e:	1000                	addi	s0,sp,32
  push_off();
    80001920:	ac4ff0ef          	jal	80000be4 <push_off>
    80001924:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001926:	2781                	sext.w	a5,a5
    80001928:	079e                	slli	a5,a5,0x7
    8000192a:	0000f717          	auipc	a4,0xf
    8000192e:	2ee70713          	addi	a4,a4,750 # 80010c18 <pid_lock>
    80001932:	97ba                	add	a5,a5,a4
    80001934:	7b9c                	ld	a5,48(a5)
    80001936:	84be                	mv	s1,a5
  pop_off();
    80001938:	b34ff0ef          	jal	80000c6c <pop_off>
  return p;
}
    8000193c:	8526                	mv	a0,s1
    8000193e:	60e2                	ld	ra,24(sp)
    80001940:	6442                	ld	s0,16(sp)
    80001942:	64a2                	ld	s1,8(sp)
    80001944:	6105                	addi	sp,sp,32
    80001946:	8082                	ret

0000000080001948 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001948:	7179                	addi	sp,sp,-48
    8000194a:	f406                	sd	ra,40(sp)
    8000194c:	f022                	sd	s0,32(sp)
    8000194e:	ec26                	sd	s1,24(sp)
    80001950:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001952:	fc5ff0ef          	jal	80001916 <myproc>
    80001956:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001958:	b64ff0ef          	jal	80000cbc <release>

  if (first) {
    8000195c:	00007797          	auipc	a5,0x7
    80001960:	1847a783          	lw	a5,388(a5) # 80008ae0 <first.1>
    80001964:	cf95                	beqz	a5,800019a0 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001966:	4505                	li	a0,1
    80001968:	3ec020ef          	jal	80003d54 <fsinit>

    first = 0;
    8000196c:	00007797          	auipc	a5,0x7
    80001970:	1607aa23          	sw	zero,372(a5) # 80008ae0 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80001974:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001978:	00006797          	auipc	a5,0x6
    8000197c:	7f878793          	addi	a5,a5,2040 # 80008170 <etext+0x170>
    80001980:	fcf43823          	sd	a5,-48(s0)
    80001984:	fc043c23          	sd	zero,-40(s0)
    80001988:	fd040593          	addi	a1,s0,-48
    8000198c:	853e                	mv	a0,a5
    8000198e:	76c030ef          	jal	800050fa <kexec>
    80001992:	6cbc                	ld	a5,88(s1)
    80001994:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001996:	6cbc                	ld	a5,88(s1)
    80001998:	7bb8                	ld	a4,112(a5)
    8000199a:	57fd                	li	a5,-1
    8000199c:	02f70d63          	beq	a4,a5,800019d6 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800019a0:	0e8010ef          	jal	80002a88 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800019a4:	68a8                	ld	a0,80(s1)
    800019a6:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019a8:	04000737          	lui	a4,0x4000
    800019ac:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019ae:	0732                	slli	a4,a4,0xc
    800019b0:	00005797          	auipc	a5,0x5
    800019b4:	6ec78793          	addi	a5,a5,1772 # 8000709c <userret>
    800019b8:	00005697          	auipc	a3,0x5
    800019bc:	64868693          	addi	a3,a3,1608 # 80007000 <_trampoline>
    800019c0:	8f95                	sub	a5,a5,a3
    800019c2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019c4:	577d                	li	a4,-1
    800019c6:	177e                	slli	a4,a4,0x3f
    800019c8:	8d59                	or	a0,a0,a4
    800019ca:	9782                	jalr	a5
}
    800019cc:	70a2                	ld	ra,40(sp)
    800019ce:	7402                	ld	s0,32(sp)
    800019d0:	64e2                	ld	s1,24(sp)
    800019d2:	6145                	addi	sp,sp,48
    800019d4:	8082                	ret
      panic("exec");
    800019d6:	00006517          	auipc	a0,0x6
    800019da:	7a250513          	addi	a0,a0,1954 # 80008178 <etext+0x178>
    800019de:	e47fe0ef          	jal	80000824 <panic>

00000000800019e2 <allocpid>:
{
    800019e2:	1101                	addi	sp,sp,-32
    800019e4:	ec06                	sd	ra,24(sp)
    800019e6:	e822                	sd	s0,16(sp)
    800019e8:	e426                	sd	s1,8(sp)
    800019ea:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019ec:	0000f517          	auipc	a0,0xf
    800019f0:	22c50513          	addi	a0,a0,556 # 80010c18 <pid_lock>
    800019f4:	a34ff0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    800019f8:	00007797          	auipc	a5,0x7
    800019fc:	0ec78793          	addi	a5,a5,236 # 80008ae4 <nextpid>
    80001a00:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a02:	0014871b          	addiw	a4,s1,1
    80001a06:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a08:	0000f517          	auipc	a0,0xf
    80001a0c:	21050513          	addi	a0,a0,528 # 80010c18 <pid_lock>
    80001a10:	aacff0ef          	jal	80000cbc <release>
}
    80001a14:	8526                	mv	a0,s1
    80001a16:	60e2                	ld	ra,24(sp)
    80001a18:	6442                	ld	s0,16(sp)
    80001a1a:	64a2                	ld	s1,8(sp)
    80001a1c:	6105                	addi	sp,sp,32
    80001a1e:	8082                	ret

0000000080001a20 <proc_pagetable>:
{
    80001a20:	1101                	addi	sp,sp,-32
    80001a22:	ec06                	sd	ra,24(sp)
    80001a24:	e822                	sd	s0,16(sp)
    80001a26:	e426                	sd	s1,8(sp)
    80001a28:	e04a                	sd	s2,0(sp)
    80001a2a:	1000                	addi	s0,sp,32
    80001a2c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a2e:	fdaff0ef          	jal	80001208 <uvmcreate>
    80001a32:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a34:	cd05                	beqz	a0,80001a6c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a36:	4729                	li	a4,10
    80001a38:	00005697          	auipc	a3,0x5
    80001a3c:	5c868693          	addi	a3,a3,1480 # 80007000 <_trampoline>
    80001a40:	6605                	lui	a2,0x1
    80001a42:	040005b7          	lui	a1,0x4000
    80001a46:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a48:	05b2                	slli	a1,a1,0xc
    80001a4a:	e16ff0ef          	jal	80001060 <mappages>
    80001a4e:	02054663          	bltz	a0,80001a7a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a52:	4719                	li	a4,6
    80001a54:	05893683          	ld	a3,88(s2)
    80001a58:	6605                	lui	a2,0x1
    80001a5a:	020005b7          	lui	a1,0x2000
    80001a5e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a60:	05b6                	slli	a1,a1,0xd
    80001a62:	8526                	mv	a0,s1
    80001a64:	dfcff0ef          	jal	80001060 <mappages>
    80001a68:	00054f63          	bltz	a0,80001a86 <proc_pagetable+0x66>
}
    80001a6c:	8526                	mv	a0,s1
    80001a6e:	60e2                	ld	ra,24(sp)
    80001a70:	6442                	ld	s0,16(sp)
    80001a72:	64a2                	ld	s1,8(sp)
    80001a74:	6902                	ld	s2,0(sp)
    80001a76:	6105                	addi	sp,sp,32
    80001a78:	8082                	ret
    uvmfree(pagetable, 0);
    80001a7a:	4581                	li	a1,0
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	985ff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001a82:	4481                	li	s1,0
    80001a84:	b7e5                	j	80001a6c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a86:	4681                	li	a3,0
    80001a88:	4605                	li	a2,1
    80001a8a:	040005b7          	lui	a1,0x4000
    80001a8e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a90:	05b2                	slli	a1,a1,0xc
    80001a92:	8526                	mv	a0,s1
    80001a94:	f9aff0ef          	jal	8000122e <uvmunmap>
    uvmfree(pagetable, 0);
    80001a98:	4581                	li	a1,0
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	967ff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001aa0:	4481                	li	s1,0
    80001aa2:	b7e9                	j	80001a6c <proc_pagetable+0x4c>

0000000080001aa4 <proc_freepagetable>:
{
    80001aa4:	1101                	addi	sp,sp,-32
    80001aa6:	ec06                	sd	ra,24(sp)
    80001aa8:	e822                	sd	s0,16(sp)
    80001aaa:	e426                	sd	s1,8(sp)
    80001aac:	e04a                	sd	s2,0(sp)
    80001aae:	1000                	addi	s0,sp,32
    80001ab0:	84aa                	mv	s1,a0
    80001ab2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ab4:	4681                	li	a3,0
    80001ab6:	4605                	li	a2,1
    80001ab8:	040005b7          	lui	a1,0x4000
    80001abc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001abe:	05b2                	slli	a1,a1,0xc
    80001ac0:	f6eff0ef          	jal	8000122e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ac4:	4681                	li	a3,0
    80001ac6:	4605                	li	a2,1
    80001ac8:	020005b7          	lui	a1,0x2000
    80001acc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ace:	05b6                	slli	a1,a1,0xd
    80001ad0:	8526                	mv	a0,s1
    80001ad2:	f5cff0ef          	jal	8000122e <uvmunmap>
  uvmfree(pagetable, sz);
    80001ad6:	85ca                	mv	a1,s2
    80001ad8:	8526                	mv	a0,s1
    80001ada:	929ff0ef          	jal	80001402 <uvmfree>
}
    80001ade:	60e2                	ld	ra,24(sp)
    80001ae0:	6442                	ld	s0,16(sp)
    80001ae2:	64a2                	ld	s1,8(sp)
    80001ae4:	6902                	ld	s2,0(sp)
    80001ae6:	6105                	addi	sp,sp,32
    80001ae8:	8082                	ret

0000000080001aea <freeproc>:
{
    80001aea:	1101                	addi	sp,sp,-32
    80001aec:	ec06                	sd	ra,24(sp)
    80001aee:	e822                	sd	s0,16(sp)
    80001af0:	e426                	sd	s1,8(sp)
    80001af2:	1000                	addi	s0,sp,32
    80001af4:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001af6:	6d28                	ld	a0,88(a0)
    80001af8:	c119                	beqz	a0,80001afe <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001afa:	f63fe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    80001afe:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b02:	68a8                	ld	a0,80(s1)
    80001b04:	c501                	beqz	a0,80001b0c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b06:	64ac                	ld	a1,72(s1)
    80001b08:	f9dff0ef          	jal	80001aa4 <proc_freepagetable>
  p->pagetable = 0;
    80001b0c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b10:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b14:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b18:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b1c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b20:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b24:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b28:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b2c:	0004ac23          	sw	zero,24(s1)
  p->energy_budget = 0;
    80001b30:	1604b823          	sd	zero,368(s1)
  p->energy_consumed = 0;
    80001b34:	1604bc23          	sd	zero,376(s1)
  p->last_scheduled_tick = 0;
    80001b38:	1804b023          	sd	zero,384(s1)
  p->waiting_for_lock = 0;
    80001b3c:	1804b423          	sd	zero,392(s1)
  p->deadlock_reports = 0;
    80001b40:	1804b823          	sd	zero,400(s1)
  p->in_deadlock = 0;
    80001b44:	1804ac23          	sw	zero,408(s1)
  for(int i = 0; i < NRES; i++)
    80001b48:	19c48793          	addi	a5,s1,412
    80001b4c:	1dc48713          	addi	a4,s1,476
    p->holding_res[i] = 0;
    80001b50:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < NRES; i++)
    80001b54:	0791                	addi	a5,a5,4
    80001b56:	fee79de3          	bne	a5,a4,80001b50 <freeproc+0x66>
  p->waiting_res = -1;
    80001b5a:	57fd                	li	a5,-1
    80001b5c:	1cf4ae23          	sw	a5,476(s1)
}
    80001b60:	60e2                	ld	ra,24(sp)
    80001b62:	6442                	ld	s0,16(sp)
    80001b64:	64a2                	ld	s1,8(sp)
    80001b66:	6105                	addi	sp,sp,32
    80001b68:	8082                	ret

0000000080001b6a <allocproc>:
{
    80001b6a:	1101                	addi	sp,sp,-32
    80001b6c:	ec06                	sd	ra,24(sp)
    80001b6e:	e822                	sd	s0,16(sp)
    80001b70:	e426                	sd	s1,8(sp)
    80001b72:	e04a                	sd	s2,0(sp)
    80001b74:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b76:	0000f497          	auipc	s1,0xf
    80001b7a:	4d248493          	addi	s1,s1,1234 # 80011048 <proc>
    80001b7e:	00017917          	auipc	s2,0x17
    80001b82:	cca90913          	addi	s2,s2,-822 # 80018848 <tickslock>
    acquire(&p->lock);
    80001b86:	8526                	mv	a0,s1
    80001b88:	8a0ff0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80001b8c:	4c9c                	lw	a5,24(s1)
    80001b8e:	cb91                	beqz	a5,80001ba2 <allocproc+0x38>
      release(&p->lock);
    80001b90:	8526                	mv	a0,s1
    80001b92:	92aff0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b96:	1e048493          	addi	s1,s1,480
    80001b9a:	ff2496e3          	bne	s1,s2,80001b86 <allocproc+0x1c>
  return 0;
    80001b9e:	4481                	li	s1,0
    80001ba0:	a8ad                	j	80001c1a <allocproc+0xb0>
  p->pid = allocpid();
    80001ba2:	e41ff0ef          	jal	800019e2 <allocpid>
    80001ba6:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001ba8:	4785                	li	a5,1
    80001baa:	cc9c                	sw	a5,24(s1)
  p-> waiting_tick = 0;
    80001bac:	1604a423          	sw	zero,360(s1)
  p->energy_budget = DEFAULT_ENERGY_BUDGET;
    80001bb0:	3e800793          	li	a5,1000
    80001bb4:	16f4b823          	sd	a5,368(s1)
  p->energy_consumed = 0;
    80001bb8:	1604bc23          	sd	zero,376(s1)
  p->last_scheduled_tick = 0;
    80001bbc:	1804b023          	sd	zero,384(s1)
  p->waiting_for_lock = 0;
    80001bc0:	1804b423          	sd	zero,392(s1)
  p->deadlock_reports = 0;
    80001bc4:	1804b823          	sd	zero,400(s1)
  p->in_deadlock = 0;
    80001bc8:	1804ac23          	sw	zero,408(s1)
  for(int i = 0; i < NRES; i++)
    80001bcc:	19c48793          	addi	a5,s1,412
    80001bd0:	1dc48713          	addi	a4,s1,476
    p->holding_res[i] = 0;
    80001bd4:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < NRES; i++)
    80001bd8:	0791                	addi	a5,a5,4
    80001bda:	fee79de3          	bne	a5,a4,80001bd4 <allocproc+0x6a>
  p->waiting_res = -1;
    80001bde:	57fd                	li	a5,-1
    80001be0:	1cf4ae23          	sw	a5,476(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001be4:	f61fe0ef          	jal	80000b44 <kalloc>
    80001be8:	892a                	mv	s2,a0
    80001bea:	eca8                	sd	a0,88(s1)
    80001bec:	cd15                	beqz	a0,80001c28 <allocproc+0xbe>
  p->pagetable = proc_pagetable(p);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	e31ff0ef          	jal	80001a20 <proc_pagetable>
    80001bf4:	892a                	mv	s2,a0
    80001bf6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001bf8:	c121                	beqz	a0,80001c38 <allocproc+0xce>
  memset(&p->context, 0, sizeof(p->context));
    80001bfa:	07000613          	li	a2,112
    80001bfe:	4581                	li	a1,0
    80001c00:	06048513          	addi	a0,s1,96
    80001c04:	8f4ff0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001c08:	00000797          	auipc	a5,0x0
    80001c0c:	d4078793          	addi	a5,a5,-704 # 80001948 <forkret>
    80001c10:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c12:	60bc                	ld	a5,64(s1)
    80001c14:	6705                	lui	a4,0x1
    80001c16:	97ba                	add	a5,a5,a4
    80001c18:	f4bc                	sd	a5,104(s1)
}
    80001c1a:	8526                	mv	a0,s1
    80001c1c:	60e2                	ld	ra,24(sp)
    80001c1e:	6442                	ld	s0,16(sp)
    80001c20:	64a2                	ld	s1,8(sp)
    80001c22:	6902                	ld	s2,0(sp)
    80001c24:	6105                	addi	sp,sp,32
    80001c26:	8082                	ret
    freeproc(p);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	ec1ff0ef          	jal	80001aea <freeproc>
    release(&p->lock);
    80001c2e:	8526                	mv	a0,s1
    80001c30:	88cff0ef          	jal	80000cbc <release>
    return 0;
    80001c34:	84ca                	mv	s1,s2
    80001c36:	b7d5                	j	80001c1a <allocproc+0xb0>
    freeproc(p);
    80001c38:	8526                	mv	a0,s1
    80001c3a:	eb1ff0ef          	jal	80001aea <freeproc>
    release(&p->lock);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	87cff0ef          	jal	80000cbc <release>
    return 0;
    80001c44:	84ca                	mv	s1,s2
    80001c46:	bfd1                	j	80001c1a <allocproc+0xb0>

0000000080001c48 <userinit>:
{
    80001c48:	1101                	addi	sp,sp,-32
    80001c4a:	ec06                	sd	ra,24(sp)
    80001c4c:	e822                	sd	s0,16(sp)
    80001c4e:	e426                	sd	s1,8(sp)
    80001c50:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c52:	f19ff0ef          	jal	80001b6a <allocproc>
    80001c56:	84aa                	mv	s1,a0
  initproc = p;
    80001c58:	00007797          	auipc	a5,0x7
    80001c5c:	eaa7bc23          	sd	a0,-328(a5) # 80008b10 <initproc>
  p->cwd = namei("/");
    80001c60:	00006517          	auipc	a0,0x6
    80001c64:	52050513          	addi	a0,a0,1312 # 80008180 <etext+0x180>
    80001c68:	626020ef          	jal	8000428e <namei>
    80001c6c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c70:	478d                	li	a5,3
    80001c72:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c74:	8526                	mv	a0,s1
    80001c76:	846ff0ef          	jal	80000cbc <release>
}
    80001c7a:	60e2                	ld	ra,24(sp)
    80001c7c:	6442                	ld	s0,16(sp)
    80001c7e:	64a2                	ld	s1,8(sp)
    80001c80:	6105                	addi	sp,sp,32
    80001c82:	8082                	ret

0000000080001c84 <growproc>:
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	e426                	sd	s1,8(sp)
    80001c8c:	e04a                	sd	s2,0(sp)
    80001c8e:	1000                	addi	s0,sp,32
    80001c90:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c92:	c85ff0ef          	jal	80001916 <myproc>
    80001c96:	892a                	mv	s2,a0
  sz = p->sz;
    80001c98:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c9a:	02905963          	blez	s1,80001ccc <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001c9e:	00b48633          	add	a2,s1,a1
    80001ca2:	020007b7          	lui	a5,0x2000
    80001ca6:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001ca8:	07b6                	slli	a5,a5,0xd
    80001caa:	02c7ea63          	bltu	a5,a2,80001cde <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001cae:	4691                	li	a3,4
    80001cb0:	6928                	ld	a0,80(a0)
    80001cb2:	e4aff0ef          	jal	800012fc <uvmalloc>
    80001cb6:	85aa                	mv	a1,a0
    80001cb8:	c50d                	beqz	a0,80001ce2 <growproc+0x5e>
  p->sz = sz;
    80001cba:	04b93423          	sd	a1,72(s2)
  return 0;
    80001cbe:	4501                	li	a0,0
}
    80001cc0:	60e2                	ld	ra,24(sp)
    80001cc2:	6442                	ld	s0,16(sp)
    80001cc4:	64a2                	ld	s1,8(sp)
    80001cc6:	6902                	ld	s2,0(sp)
    80001cc8:	6105                	addi	sp,sp,32
    80001cca:	8082                	ret
  } else if(n < 0){
    80001ccc:	fe04d7e3          	bgez	s1,80001cba <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001cd0:	00b48633          	add	a2,s1,a1
    80001cd4:	6928                	ld	a0,80(a0)
    80001cd6:	de2ff0ef          	jal	800012b8 <uvmdealloc>
    80001cda:	85aa                	mv	a1,a0
    80001cdc:	bff9                	j	80001cba <growproc+0x36>
      return -1;
    80001cde:	557d                	li	a0,-1
    80001ce0:	b7c5                	j	80001cc0 <growproc+0x3c>
      return -1;
    80001ce2:	557d                	li	a0,-1
    80001ce4:	bff1                	j	80001cc0 <growproc+0x3c>

0000000080001ce6 <kfork>:
{
    80001ce6:	7139                	addi	sp,sp,-64
    80001ce8:	fc06                	sd	ra,56(sp)
    80001cea:	f822                	sd	s0,48(sp)
    80001cec:	f426                	sd	s1,40(sp)
    80001cee:	e456                	sd	s5,8(sp)
    80001cf0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001cf2:	c25ff0ef          	jal	80001916 <myproc>
    80001cf6:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001cf8:	e73ff0ef          	jal	80001b6a <allocproc>
    80001cfc:	0e050a63          	beqz	a0,80001df0 <kfork+0x10a>
    80001d00:	e852                	sd	s4,16(sp)
    80001d02:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d04:	048ab603          	ld	a2,72(s5)
    80001d08:	692c                	ld	a1,80(a0)
    80001d0a:	050ab503          	ld	a0,80(s5)
    80001d0e:	f26ff0ef          	jal	80001434 <uvmcopy>
    80001d12:	04054863          	bltz	a0,80001d62 <kfork+0x7c>
    80001d16:	f04a                	sd	s2,32(sp)
    80001d18:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001d1a:	048ab783          	ld	a5,72(s5)
    80001d1e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001d22:	058ab683          	ld	a3,88(s5)
    80001d26:	87b6                	mv	a5,a3
    80001d28:	058a3703          	ld	a4,88(s4)
    80001d2c:	12068693          	addi	a3,a3,288
    80001d30:	6388                	ld	a0,0(a5)
    80001d32:	678c                	ld	a1,8(a5)
    80001d34:	6b90                	ld	a2,16(a5)
    80001d36:	e308                	sd	a0,0(a4)
    80001d38:	e70c                	sd	a1,8(a4)
    80001d3a:	eb10                	sd	a2,16(a4)
    80001d3c:	6f90                	ld	a2,24(a5)
    80001d3e:	ef10                	sd	a2,24(a4)
    80001d40:	02078793          	addi	a5,a5,32
    80001d44:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001d48:	fed794e3          	bne	a5,a3,80001d30 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001d4c:	058a3783          	ld	a5,88(s4)
    80001d50:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001d54:	0d0a8493          	addi	s1,s5,208
    80001d58:	0d0a0913          	addi	s2,s4,208
    80001d5c:	150a8993          	addi	s3,s5,336
    80001d60:	a831                	j	80001d7c <kfork+0x96>
    freeproc(np);
    80001d62:	8552                	mv	a0,s4
    80001d64:	d87ff0ef          	jal	80001aea <freeproc>
    release(&np->lock);
    80001d68:	8552                	mv	a0,s4
    80001d6a:	f53fe0ef          	jal	80000cbc <release>
    return -1;
    80001d6e:	54fd                	li	s1,-1
    80001d70:	6a42                	ld	s4,16(sp)
    80001d72:	a885                	j	80001de2 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001d74:	04a1                	addi	s1,s1,8
    80001d76:	0921                	addi	s2,s2,8
    80001d78:	01348963          	beq	s1,s3,80001d8a <kfork+0xa4>
    if(p->ofile[i])
    80001d7c:	6088                	ld	a0,0(s1)
    80001d7e:	d97d                	beqz	a0,80001d74 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d80:	487020ef          	jal	80004a06 <filedup>
    80001d84:	00a93023          	sd	a0,0(s2)
    80001d88:	b7f5                	j	80001d74 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001d8a:	150ab503          	ld	a0,336(s5)
    80001d8e:	49d010ef          	jal	80003a2a <idup>
    80001d92:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d96:	4641                	li	a2,16
    80001d98:	158a8593          	addi	a1,s5,344
    80001d9c:	158a0513          	addi	a0,s4,344
    80001da0:	8acff0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    80001da4:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001da8:	8552                	mv	a0,s4
    80001daa:	f13fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80001dae:	0000f517          	auipc	a0,0xf
    80001db2:	e8250513          	addi	a0,a0,-382 # 80010c30 <wait_lock>
    80001db6:	e73fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80001dba:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001dbe:	0000f517          	auipc	a0,0xf
    80001dc2:	e7250513          	addi	a0,a0,-398 # 80010c30 <wait_lock>
    80001dc6:	ef7fe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80001dca:	8552                	mv	a0,s4
    80001dcc:	e5dfe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    80001dd0:	478d                	li	a5,3
    80001dd2:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001dd6:	8552                	mv	a0,s4
    80001dd8:	ee5fe0ef          	jal	80000cbc <release>
  return pid;
    80001ddc:	7902                	ld	s2,32(sp)
    80001dde:	69e2                	ld	s3,24(sp)
    80001de0:	6a42                	ld	s4,16(sp)
}
    80001de2:	8526                	mv	a0,s1
    80001de4:	70e2                	ld	ra,56(sp)
    80001de6:	7442                	ld	s0,48(sp)
    80001de8:	74a2                	ld	s1,40(sp)
    80001dea:	6aa2                	ld	s5,8(sp)
    80001dec:	6121                	addi	sp,sp,64
    80001dee:	8082                	ret
    return -1;
    80001df0:	54fd                	li	s1,-1
    80001df2:	bfc5                	j	80001de2 <kfork+0xfc>

0000000080001df4 <scheduler>:
{
    80001df4:	711d                	addi	sp,sp,-96
    80001df6:	ec86                	sd	ra,88(sp)
    80001df8:	e8a2                	sd	s0,80(sp)
    80001dfa:	e4a6                	sd	s1,72(sp)
    80001dfc:	e0ca                	sd	s2,64(sp)
    80001dfe:	fc4e                	sd	s3,56(sp)
    80001e00:	f852                	sd	s4,48(sp)
    80001e02:	f456                	sd	s5,40(sp)
    80001e04:	f05a                	sd	s6,32(sp)
    80001e06:	ec5e                	sd	s7,24(sp)
    80001e08:	e862                	sd	s8,16(sp)
    80001e0a:	e466                	sd	s9,8(sp)
    80001e0c:	1080                	addi	s0,sp,96
    80001e0e:	8792                	mv	a5,tp
  int id = r_tp();
    80001e10:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001e12:	00779b93          	slli	s7,a5,0x7
    80001e16:	0000f717          	auipc	a4,0xf
    80001e1a:	e0270713          	addi	a4,a4,-510 # 80010c18 <pid_lock>
    80001e1e:	975e                	add	a4,a4,s7
    80001e20:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &chosen->context);
    80001e24:	0000f717          	auipc	a4,0xf
    80001e28:	e2c70713          	addi	a4,a4,-468 # 80010c50 <cpus+0x8>
    80001e2c:	9bba                	add	s7,s7,a4
      if(p->state == RUNNABLE &&
    80001e2e:	490d                	li	s2,3
         strncmp(p->parent->name, "schedtest", 16) == 0 &&
    80001e30:	06400a93          	li	s5,100
      c->proc = chosen;
    80001e34:	079e                	slli	a5,a5,0x7
    80001e36:	0000fb17          	auipc	s6,0xf
    80001e3a:	de2b0b13          	addi	s6,s6,-542 # 80010c18 <pid_lock>
    80001e3e:	9b3e                	add	s6,s6,a5
    80001e40:	a275                	j	80001fec <scheduler+0x1f8>
      release(&p->lock);
    80001e42:	8526                	mv	a0,s1
    80001e44:	e79fe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++){
    80001e48:	1e048493          	addi	s1,s1,480
    80001e4c:	05348363          	beq	s1,s3,80001e92 <scheduler+0x9e>
      acquire(&p->lock);
    80001e50:	8526                	mv	a0,s1
    80001e52:	dd7fe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE &&
    80001e56:	4c9c                	lw	a5,24(s1)
    80001e58:	ff2795e3          	bne	a5,s2,80001e42 <scheduler+0x4e>
         p->parent != 0 &&
    80001e5c:	7c88                	ld	a0,56(s1)
      if(p->state == RUNNABLE &&
    80001e5e:	d175                	beqz	a0,80001e42 <scheduler+0x4e>
         strncmp(p->parent->name, "schedtest", 16) == 0 &&
    80001e60:	8666                	mv	a2,s9
    80001e62:	85e2                	mv	a1,s8
    80001e64:	15850513          	addi	a0,a0,344
    80001e68:	f65fe0ef          	jal	80000dcc <strncmp>
         p->parent != 0 &&
    80001e6c:	f979                	bnez	a0,80001e42 <scheduler+0x4e>
         strncmp(p->parent->name, "schedtest", 16) == 0 &&
    80001e6e:	1704b783          	ld	a5,368(s1)
    80001e72:	fcfaf8e3          	bgeu	s5,a5,80001e42 <scheduler+0x4e>
        if(chosen == 0 || p->pid < chosen->pid){
    80001e76:	000a0c63          	beqz	s4,80001e8e <scheduler+0x9a>
    80001e7a:	5898                	lw	a4,48(s1)
    80001e7c:	030a2783          	lw	a5,48(s4)
    80001e80:	fcf751e3          	bge	a4,a5,80001e42 <scheduler+0x4e>
            release(&chosen->lock);
    80001e84:	8552                	mv	a0,s4
    80001e86:	e37fe0ef          	jal	80000cbc <release>
          chosen = p;
    80001e8a:	8a26                	mv	s4,s1
    80001e8c:	bf75                	j	80001e48 <scheduler+0x54>
    80001e8e:	8a26                	mv	s4,s1
    80001e90:	bf65                	j	80001e48 <scheduler+0x54>
    if(chosen == 0){
    80001e92:	020a0063          	beqz	s4,80001eb2 <scheduler+0xbe>
      for(p = proc; p < &proc[NPROC]; p++){
    80001e96:	0000f497          	auipc	s1,0xf
    80001e9a:	1b248493          	addi	s1,s1,434 # 80011048 <proc>
           strncmp(p->parent->name, "schedtest", 16) == 0)
    80001e9e:	4cc1                	li	s9,16
    80001ea0:	00006c17          	auipc	s8,0x6
    80001ea4:	2e8c0c13          	addi	s8,s8,744 # 80008188 <etext+0x188>
      for(p = proc; p < &proc[NPROC]; p++){
    80001ea8:	00017997          	auipc	s3,0x17
    80001eac:	9a098993          	addi	s3,s3,-1632 # 80018848 <tickslock>
    80001eb0:	a87d                	j	80001f6e <scheduler+0x17a>
      for(p = proc; p < &proc[NPROC]; p++){
    80001eb2:	0000f497          	auipc	s1,0xf
    80001eb6:	19648493          	addi	s1,s1,406 # 80011048 <proc>
           strncmp(p->parent->name, "schedtest", 16) == 0)
    80001eba:	4cc1                	li	s9,16
    80001ebc:	00006c17          	auipc	s8,0x6
    80001ec0:	2ccc0c13          	addi	s8,s8,716 # 80008188 <etext+0x188>
      for(p = proc; p < &proc[NPROC]; p++){
    80001ec4:	00017997          	auipc	s3,0x17
    80001ec8:	98498993          	addi	s3,s3,-1660 # 80018848 <tickslock>
    80001ecc:	a801                	j	80001edc <scheduler+0xe8>
        release(&p->lock);
    80001ece:	8526                	mv	a0,s1
    80001ed0:	dedfe0ef          	jal	80000cbc <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001ed4:	1e048493          	addi	s1,s1,480
    80001ed8:	03348f63          	beq	s1,s3,80001f16 <scheduler+0x122>
        acquire(&p->lock);
    80001edc:	8526                	mv	a0,s1
    80001ede:	d4bfe0ef          	jal	80000c28 <acquire>
        if(p->state == RUNNABLE &&
    80001ee2:	4c9c                	lw	a5,24(s1)
    80001ee4:	ff2795e3          	bne	a5,s2,80001ece <scheduler+0xda>
           p->parent != 0 &&
    80001ee8:	7c88                	ld	a0,56(s1)
        if(p->state == RUNNABLE &&
    80001eea:	d175                	beqz	a0,80001ece <scheduler+0xda>
           strncmp(p->parent->name, "schedtest", 16) == 0)
    80001eec:	8666                	mv	a2,s9
    80001eee:	85e2                	mv	a1,s8
    80001ef0:	15850513          	addi	a0,a0,344
    80001ef4:	ed9fe0ef          	jal	80000dcc <strncmp>
           p->parent != 0 &&
    80001ef8:	f979                	bnez	a0,80001ece <scheduler+0xda>
          if(chosen == 0 || p->pid < chosen->pid){
    80001efa:	000a0c63          	beqz	s4,80001f12 <scheduler+0x11e>
    80001efe:	5898                	lw	a4,48(s1)
    80001f00:	030a2783          	lw	a5,48(s4)
    80001f04:	fcf755e3          	bge	a4,a5,80001ece <scheduler+0xda>
              release(&chosen->lock);
    80001f08:	8552                	mv	a0,s4
    80001f0a:	db3fe0ef          	jal	80000cbc <release>
            chosen = p;
    80001f0e:	8a26                	mv	s4,s1
    80001f10:	b7d1                	j	80001ed4 <scheduler+0xe0>
    80001f12:	8a26                	mv	s4,s1
    80001f14:	b7c1                	j	80001ed4 <scheduler+0xe0>
    if(chosen == 0){
    80001f16:	f80a10e3          	bnez	s4,80001e96 <scheduler+0xa2>
      for(p = proc; p < &proc[NPROC]; p++){
    80001f1a:	0000fa17          	auipc	s4,0xf
    80001f1e:	12ea0a13          	addi	s4,s4,302 # 80011048 <proc>
    80001f22:	00017497          	auipc	s1,0x17
    80001f26:	92648493          	addi	s1,s1,-1754 # 80018848 <tickslock>
        acquire(&p->lock);
    80001f2a:	8552                	mv	a0,s4
    80001f2c:	cfdfe0ef          	jal	80000c28 <acquire>
        if(p->state == RUNNABLE){
    80001f30:	018a2783          	lw	a5,24(s4)
    80001f34:	f72781e3          	beq	a5,s2,80001e96 <scheduler+0xa2>
        release(&p->lock);
    80001f38:	8552                	mv	a0,s4
    80001f3a:	d83fe0ef          	jal	80000cbc <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001f3e:	1e0a0a13          	addi	s4,s4,480
    80001f42:	fe9a14e3          	bne	s4,s1,80001f2a <scheduler+0x136>
      if (timer_interval == 1000000) {
    80001f46:	00007717          	auipc	a4,0x7
    80001f4a:	ba273703          	ld	a4,-1118(a4) # 80008ae8 <timer_interval>
    80001f4e:	000f47b7          	lui	a5,0xf4
    80001f52:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x7ff0bdc0>
    80001f56:	0cf70063          	beq	a4,a5,80002016 <scheduler+0x222>
      asm volatile("wfi");
    80001f5a:	10500073          	wfi
    80001f5e:	a079                	j	80001fec <scheduler+0x1f8>
        release(&p->lock);
    80001f60:	8526                	mv	a0,s1
    80001f62:	d5bfe0ef          	jal	80000cbc <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001f66:	1e048493          	addi	s1,s1,480
    80001f6a:	03348963          	beq	s1,s3,80001f9c <scheduler+0x1a8>
        if(p == chosen)
    80001f6e:	fe9a0ce3          	beq	s4,s1,80001f66 <scheduler+0x172>
        acquire(&p->lock);
    80001f72:	8526                	mv	a0,s1
    80001f74:	cb5fe0ef          	jal	80000c28 <acquire>
        if(p->state == RUNNABLE &&
    80001f78:	4c9c                	lw	a5,24(s1)
    80001f7a:	ff2793e3          	bne	a5,s2,80001f60 <scheduler+0x16c>
           p->parent != 0 &&
    80001f7e:	7c88                	ld	a0,56(s1)
        if(p->state == RUNNABLE &&
    80001f80:	d165                	beqz	a0,80001f60 <scheduler+0x16c>
           strncmp(p->parent->name, "schedtest", 16) == 0)
    80001f82:	8666                	mv	a2,s9
    80001f84:	85e2                	mv	a1,s8
    80001f86:	15850513          	addi	a0,a0,344
    80001f8a:	e43fe0ef          	jal	80000dcc <strncmp>
           p->parent != 0 &&
    80001f8e:	f969                	bnez	a0,80001f60 <scheduler+0x16c>
          p->waiting_tick++;
    80001f90:	1684a783          	lw	a5,360(s1)
    80001f94:	2785                	addiw	a5,a5,1
    80001f96:	16f4a423          	sw	a5,360(s1)
    80001f9a:	b7d9                	j	80001f60 <scheduler+0x16c>
      if (timer_interval != 1000000) {
    80001f9c:	00007717          	auipc	a4,0x7
    80001fa0:	b4c73703          	ld	a4,-1204(a4) # 80008ae8 <timer_interval>
    80001fa4:	000f47b7          	lui	a5,0xf4
    80001fa8:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x7ff0bdc0>
    80001fac:	00f70f63          	beq	a4,a5,80001fca <scheduler+0x1d6>
        timer_interval = 1000000;
    80001fb0:	000f47b7          	lui	a5,0xf4
    80001fb4:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x7ff0bdc0>
    80001fb8:	00007717          	auipc	a4,0x7
    80001fbc:	b2f73823          	sd	a5,-1232(a4) # 80008ae8 <timer_interval>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001fc0:	c0102773          	rdtime	a4
        w_stimecmp(r_time() + timer_interval);
    80001fc4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001fc6:	14d79073          	csrw	stimecmp,a5
      chosen->state = RUNNING;
    80001fca:	4791                	li	a5,4
    80001fcc:	00fa2c23          	sw	a5,24(s4)
      chosen->last_scheduled_tick = 0;  // Reset tick counter for this scheduling period
    80001fd0:	180a3023          	sd	zero,384(s4)
      c->proc = chosen;
    80001fd4:	034b3823          	sd	s4,48(s6)
      swtch(&c->context, &chosen->context);
    80001fd8:	060a0593          	addi	a1,s4,96
    80001fdc:	855e                	mv	a0,s7
    80001fde:	201000ef          	jal	800029de <swtch>
      c->proc = 0;
    80001fe2:	020b3823          	sd	zero,48(s6)
      release(&chosen->lock);
    80001fe6:	8552                	mv	a0,s4
    80001fe8:	cd5fe0ef          	jal	80000cbc <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ff0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ff4:	10079073          	csrw	sstatus,a5
    struct proc *chosen = 0;
    80001ff8:	4a01                	li	s4,0
    for(p = proc; p < &proc[NPROC]; p++){
    80001ffa:	0000f497          	auipc	s1,0xf
    80001ffe:	04e48493          	addi	s1,s1,78 # 80011048 <proc>
         strncmp(p->parent->name, "schedtest", 16) == 0 &&
    80002002:	4cc1                	li	s9,16
    80002004:	00006c17          	auipc	s8,0x6
    80002008:	184c0c13          	addi	s8,s8,388 # 80008188 <etext+0x188>
    for(p = proc; p < &proc[NPROC]; p++){
    8000200c:	00017997          	auipc	s3,0x17
    80002010:	83c98993          	addi	s3,s3,-1988 # 80018848 <tickslock>
    80002014:	bd35                	j	80001e50 <scheduler+0x5c>
        timer_interval = 10000000;
    80002016:	009897b7          	lui	a5,0x989
    8000201a:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f676980>
    8000201e:	00007717          	auipc	a4,0x7
    80002022:	acf73523          	sd	a5,-1334(a4) # 80008ae8 <timer_interval>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002026:	c0102773          	rdtime	a4
        w_stimecmp(r_time() + timer_interval);
    8000202a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000202c:	14d79073          	csrw	stimecmp,a5
}
    80002030:	b72d                	j	80001f5a <scheduler+0x166>

0000000080002032 <sched>:
{
    80002032:	7179                	addi	sp,sp,-48
    80002034:	f406                	sd	ra,40(sp)
    80002036:	f022                	sd	s0,32(sp)
    80002038:	ec26                	sd	s1,24(sp)
    8000203a:	e84a                	sd	s2,16(sp)
    8000203c:	e44e                	sd	s3,8(sp)
    8000203e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002040:	8d7ff0ef          	jal	80001916 <myproc>
    80002044:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002046:	b73fe0ef          	jal	80000bb8 <holding>
    8000204a:	c935                	beqz	a0,800020be <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000204c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000204e:	2781                	sext.w	a5,a5
    80002050:	079e                	slli	a5,a5,0x7
    80002052:	0000f717          	auipc	a4,0xf
    80002056:	bc670713          	addi	a4,a4,-1082 # 80010c18 <pid_lock>
    8000205a:	97ba                	add	a5,a5,a4
    8000205c:	0a87a703          	lw	a4,168(a5)
    80002060:	4785                	li	a5,1
    80002062:	06f71463          	bne	a4,a5,800020ca <sched+0x98>
  if(p->state == RUNNING)
    80002066:	4c98                	lw	a4,24(s1)
    80002068:	4791                	li	a5,4
    8000206a:	06f70663          	beq	a4,a5,800020d6 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000206e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002072:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002074:	e7bd                	bnez	a5,800020e2 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002076:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002078:	0000f917          	auipc	s2,0xf
    8000207c:	ba090913          	addi	s2,s2,-1120 # 80010c18 <pid_lock>
    80002080:	2781                	sext.w	a5,a5
    80002082:	079e                	slli	a5,a5,0x7
    80002084:	97ca                	add	a5,a5,s2
    80002086:	0ac7a983          	lw	s3,172(a5)
    8000208a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000208c:	2781                	sext.w	a5,a5
    8000208e:	079e                	slli	a5,a5,0x7
    80002090:	07a1                	addi	a5,a5,8
    80002092:	0000f597          	auipc	a1,0xf
    80002096:	bb658593          	addi	a1,a1,-1098 # 80010c48 <cpus>
    8000209a:	95be                	add	a1,a1,a5
    8000209c:	06048513          	addi	a0,s1,96
    800020a0:	13f000ef          	jal	800029de <swtch>
    800020a4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020a6:	2781                	sext.w	a5,a5
    800020a8:	079e                	slli	a5,a5,0x7
    800020aa:	993e                	add	s2,s2,a5
    800020ac:	0b392623          	sw	s3,172(s2)
}
    800020b0:	70a2                	ld	ra,40(sp)
    800020b2:	7402                	ld	s0,32(sp)
    800020b4:	64e2                	ld	s1,24(sp)
    800020b6:	6942                	ld	s2,16(sp)
    800020b8:	69a2                	ld	s3,8(sp)
    800020ba:	6145                	addi	sp,sp,48
    800020bc:	8082                	ret
    panic("sched p->lock");
    800020be:	00006517          	auipc	a0,0x6
    800020c2:	0da50513          	addi	a0,a0,218 # 80008198 <etext+0x198>
    800020c6:	f5efe0ef          	jal	80000824 <panic>
    panic("sched locks");
    800020ca:	00006517          	auipc	a0,0x6
    800020ce:	0de50513          	addi	a0,a0,222 # 800081a8 <etext+0x1a8>
    800020d2:	f52fe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    800020d6:	00006517          	auipc	a0,0x6
    800020da:	0e250513          	addi	a0,a0,226 # 800081b8 <etext+0x1b8>
    800020de:	f46fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    800020e2:	00006517          	auipc	a0,0x6
    800020e6:	0e650513          	addi	a0,a0,230 # 800081c8 <etext+0x1c8>
    800020ea:	f3afe0ef          	jal	80000824 <panic>

00000000800020ee <yield>:
{
    800020ee:	1101                	addi	sp,sp,-32
    800020f0:	ec06                	sd	ra,24(sp)
    800020f2:	e822                	sd	s0,16(sp)
    800020f4:	e426                	sd	s1,8(sp)
    800020f6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020f8:	81fff0ef          	jal	80001916 <myproc>
    800020fc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020fe:	b2bfe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    80002102:	478d                	li	a5,3
    80002104:	cc9c                	sw	a5,24(s1)
  sched();
    80002106:	f2dff0ef          	jal	80002032 <sched>
  release(&p->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	bb1fe0ef          	jal	80000cbc <release>
}
    80002110:	60e2                	ld	ra,24(sp)
    80002112:	6442                	ld	s0,16(sp)
    80002114:	64a2                	ld	s1,8(sp)
    80002116:	6105                	addi	sp,sp,32
    80002118:	8082                	ret

000000008000211a <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000211a:	7179                	addi	sp,sp,-48
    8000211c:	f406                	sd	ra,40(sp)
    8000211e:	f022                	sd	s0,32(sp)
    80002120:	ec26                	sd	s1,24(sp)
    80002122:	e84a                	sd	s2,16(sp)
    80002124:	e44e                	sd	s3,8(sp)
    80002126:	1800                	addi	s0,sp,48
    80002128:	89aa                	mv	s3,a0
    8000212a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000212c:	feaff0ef          	jal	80001916 <myproc>
    80002130:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002132:	af7fe0ef          	jal	80000c28 <acquire>
  release(lk);
    80002136:	854a                	mv	a0,s2
    80002138:	b85fe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    8000213c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002140:	4789                	li	a5,2
    80002142:	cc9c                	sw	a5,24(s1)

  sched();
    80002144:	eefff0ef          	jal	80002032 <sched>

  // Tidy up.
  p->chan = 0;
    80002148:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000214c:	8526                	mv	a0,s1
    8000214e:	b6ffe0ef          	jal	80000cbc <release>
  acquire(lk);
    80002152:	854a                	mv	a0,s2
    80002154:	ad5fe0ef          	jal	80000c28 <acquire>
}
    80002158:	70a2                	ld	ra,40(sp)
    8000215a:	7402                	ld	s0,32(sp)
    8000215c:	64e2                	ld	s1,24(sp)
    8000215e:	6942                	ld	s2,16(sp)
    80002160:	69a2                	ld	s3,8(sp)
    80002162:	6145                	addi	sp,sp,48
    80002164:	8082                	ret

0000000080002166 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80002166:	7139                	addi	sp,sp,-64
    80002168:	fc06                	sd	ra,56(sp)
    8000216a:	f822                	sd	s0,48(sp)
    8000216c:	f426                	sd	s1,40(sp)
    8000216e:	f04a                	sd	s2,32(sp)
    80002170:	ec4e                	sd	s3,24(sp)
    80002172:	e852                	sd	s4,16(sp)
    80002174:	e456                	sd	s5,8(sp)
    80002176:	0080                	addi	s0,sp,64
    80002178:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000217a:	0000f497          	auipc	s1,0xf
    8000217e:	ece48493          	addi	s1,s1,-306 # 80011048 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002182:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002184:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002186:	00016917          	auipc	s2,0x16
    8000218a:	6c290913          	addi	s2,s2,1730 # 80018848 <tickslock>
    8000218e:	a801                	j	8000219e <wakeup+0x38>
      }
      release(&p->lock);
    80002190:	8526                	mv	a0,s1
    80002192:	b2bfe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002196:	1e048493          	addi	s1,s1,480
    8000219a:	03248263          	beq	s1,s2,800021be <wakeup+0x58>
    if(p != myproc()){
    8000219e:	f78ff0ef          	jal	80001916 <myproc>
    800021a2:	fe950ae3          	beq	a0,s1,80002196 <wakeup+0x30>
      acquire(&p->lock);
    800021a6:	8526                	mv	a0,s1
    800021a8:	a81fe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800021ac:	4c9c                	lw	a5,24(s1)
    800021ae:	ff3791e3          	bne	a5,s3,80002190 <wakeup+0x2a>
    800021b2:	709c                	ld	a5,32(s1)
    800021b4:	fd479ee3          	bne	a5,s4,80002190 <wakeup+0x2a>
        p->state = RUNNABLE;
    800021b8:	0154ac23          	sw	s5,24(s1)
    800021bc:	bfd1                	j	80002190 <wakeup+0x2a>
    }
  }
}
    800021be:	70e2                	ld	ra,56(sp)
    800021c0:	7442                	ld	s0,48(sp)
    800021c2:	74a2                	ld	s1,40(sp)
    800021c4:	7902                	ld	s2,32(sp)
    800021c6:	69e2                	ld	s3,24(sp)
    800021c8:	6a42                	ld	s4,16(sp)
    800021ca:	6aa2                	ld	s5,8(sp)
    800021cc:	6121                	addi	sp,sp,64
    800021ce:	8082                	ret

00000000800021d0 <reparent>:
{
    800021d0:	7179                	addi	sp,sp,-48
    800021d2:	f406                	sd	ra,40(sp)
    800021d4:	f022                	sd	s0,32(sp)
    800021d6:	ec26                	sd	s1,24(sp)
    800021d8:	e84a                	sd	s2,16(sp)
    800021da:	e44e                	sd	s3,8(sp)
    800021dc:	e052                	sd	s4,0(sp)
    800021de:	1800                	addi	s0,sp,48
    800021e0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021e2:	0000f497          	auipc	s1,0xf
    800021e6:	e6648493          	addi	s1,s1,-410 # 80011048 <proc>
      pp->parent = initproc;
    800021ea:	00007a17          	auipc	s4,0x7
    800021ee:	926a0a13          	addi	s4,s4,-1754 # 80008b10 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021f2:	00016997          	auipc	s3,0x16
    800021f6:	65698993          	addi	s3,s3,1622 # 80018848 <tickslock>
    800021fa:	a029                	j	80002204 <reparent+0x34>
    800021fc:	1e048493          	addi	s1,s1,480
    80002200:	01348b63          	beq	s1,s3,80002216 <reparent+0x46>
    if(pp->parent == p){
    80002204:	7c9c                	ld	a5,56(s1)
    80002206:	ff279be3          	bne	a5,s2,800021fc <reparent+0x2c>
      pp->parent = initproc;
    8000220a:	000a3503          	ld	a0,0(s4)
    8000220e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002210:	f57ff0ef          	jal	80002166 <wakeup>
    80002214:	b7e5                	j	800021fc <reparent+0x2c>
}
    80002216:	70a2                	ld	ra,40(sp)
    80002218:	7402                	ld	s0,32(sp)
    8000221a:	64e2                	ld	s1,24(sp)
    8000221c:	6942                	ld	s2,16(sp)
    8000221e:	69a2                	ld	s3,8(sp)
    80002220:	6a02                	ld	s4,0(sp)
    80002222:	6145                	addi	sp,sp,48
    80002224:	8082                	ret

0000000080002226 <kexit>:
{
    80002226:	7179                	addi	sp,sp,-48
    80002228:	f406                	sd	ra,40(sp)
    8000222a:	f022                	sd	s0,32(sp)
    8000222c:	ec26                	sd	s1,24(sp)
    8000222e:	e84a                	sd	s2,16(sp)
    80002230:	e44e                	sd	s3,8(sp)
    80002232:	e052                	sd	s4,0(sp)
    80002234:	1800                	addi	s0,sp,48
    80002236:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002238:	edeff0ef          	jal	80001916 <myproc>
    8000223c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000223e:	00007797          	auipc	a5,0x7
    80002242:	8d27b783          	ld	a5,-1838(a5) # 80008b10 <initproc>
    80002246:	0d050493          	addi	s1,a0,208
    8000224a:	15050913          	addi	s2,a0,336
    8000224e:	00a79b63          	bne	a5,a0,80002264 <kexit+0x3e>
    panic("init exiting");
    80002252:	00006517          	auipc	a0,0x6
    80002256:	f8e50513          	addi	a0,a0,-114 # 800081e0 <etext+0x1e0>
    8000225a:	dcafe0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000225e:	04a1                	addi	s1,s1,8
    80002260:	01248963          	beq	s1,s2,80002272 <kexit+0x4c>
    if(p->ofile[fd]){
    80002264:	6088                	ld	a0,0(s1)
    80002266:	dd65                	beqz	a0,8000225e <kexit+0x38>
      fileclose(f);
    80002268:	7e4020ef          	jal	80004a4c <fileclose>
      p->ofile[fd] = 0;
    8000226c:	0004b023          	sd	zero,0(s1)
    80002270:	b7fd                	j	8000225e <kexit+0x38>
  begin_op();
    80002272:	1fa020ef          	jal	8000446c <begin_op>
  iput(p->cwd);
    80002276:	1509b503          	ld	a0,336(s3)
    8000227a:	169010ef          	jal	80003be2 <iput>
  end_op();
    8000227e:	25e020ef          	jal	800044dc <end_op>
  p->cwd = 0;
    80002282:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002286:	0000f517          	auipc	a0,0xf
    8000228a:	9aa50513          	addi	a0,a0,-1622 # 80010c30 <wait_lock>
    8000228e:	99bfe0ef          	jal	80000c28 <acquire>
  reparent(p);
    80002292:	854e                	mv	a0,s3
    80002294:	f3dff0ef          	jal	800021d0 <reparent>
  wakeup(p->parent);
    80002298:	0389b503          	ld	a0,56(s3)
    8000229c:	ecbff0ef          	jal	80002166 <wakeup>
  acquire(&p->lock);
    800022a0:	854e                	mv	a0,s3
    800022a2:	987fe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    800022a6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800022aa:	4795                	li	a5,5
    800022ac:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800022b0:	0000f517          	auipc	a0,0xf
    800022b4:	98050513          	addi	a0,a0,-1664 # 80010c30 <wait_lock>
    800022b8:	a05fe0ef          	jal	80000cbc <release>
  sched();
    800022bc:	d77ff0ef          	jal	80002032 <sched>
  panic("zombie exit");
    800022c0:	00006517          	auipc	a0,0x6
    800022c4:	f3050513          	addi	a0,a0,-208 # 800081f0 <etext+0x1f0>
    800022c8:	d5cfe0ef          	jal	80000824 <panic>

00000000800022cc <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800022cc:	7179                	addi	sp,sp,-48
    800022ce:	f406                	sd	ra,40(sp)
    800022d0:	f022                	sd	s0,32(sp)
    800022d2:	ec26                	sd	s1,24(sp)
    800022d4:	e84a                	sd	s2,16(sp)
    800022d6:	e44e                	sd	s3,8(sp)
    800022d8:	1800                	addi	s0,sp,48
    800022da:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800022dc:	0000f497          	auipc	s1,0xf
    800022e0:	d6c48493          	addi	s1,s1,-660 # 80011048 <proc>
    800022e4:	00016997          	auipc	s3,0x16
    800022e8:	56498993          	addi	s3,s3,1380 # 80018848 <tickslock>
    acquire(&p->lock);
    800022ec:	8526                	mv	a0,s1
    800022ee:	93bfe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    800022f2:	589c                	lw	a5,48(s1)
    800022f4:	01278b63          	beq	a5,s2,8000230a <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800022f8:	8526                	mv	a0,s1
    800022fa:	9c3fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800022fe:	1e048493          	addi	s1,s1,480
    80002302:	ff3495e3          	bne	s1,s3,800022ec <kkill+0x20>
  }
  return -1;
    80002306:	557d                	li	a0,-1
    80002308:	a819                	j	8000231e <kkill+0x52>
      p->killed = 1;
    8000230a:	4785                	li	a5,1
    8000230c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000230e:	4c98                	lw	a4,24(s1)
    80002310:	4789                	li	a5,2
    80002312:	00f70d63          	beq	a4,a5,8000232c <kkill+0x60>
      release(&p->lock);
    80002316:	8526                	mv	a0,s1
    80002318:	9a5fe0ef          	jal	80000cbc <release>
      return 0;
    8000231c:	4501                	li	a0,0
}
    8000231e:	70a2                	ld	ra,40(sp)
    80002320:	7402                	ld	s0,32(sp)
    80002322:	64e2                	ld	s1,24(sp)
    80002324:	6942                	ld	s2,16(sp)
    80002326:	69a2                	ld	s3,8(sp)
    80002328:	6145                	addi	sp,sp,48
    8000232a:	8082                	ret
        p->state = RUNNABLE;
    8000232c:	478d                	li	a5,3
    8000232e:	cc9c                	sw	a5,24(s1)
    80002330:	b7dd                	j	80002316 <kkill+0x4a>

0000000080002332 <setkilled>:

void
setkilled(struct proc *p)
{
    80002332:	1101                	addi	sp,sp,-32
    80002334:	ec06                	sd	ra,24(sp)
    80002336:	e822                	sd	s0,16(sp)
    80002338:	e426                	sd	s1,8(sp)
    8000233a:	1000                	addi	s0,sp,32
    8000233c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000233e:	8ebfe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    80002342:	4785                	li	a5,1
    80002344:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002346:	8526                	mv	a0,s1
    80002348:	975fe0ef          	jal	80000cbc <release>
}
    8000234c:	60e2                	ld	ra,24(sp)
    8000234e:	6442                	ld	s0,16(sp)
    80002350:	64a2                	ld	s1,8(sp)
    80002352:	6105                	addi	sp,sp,32
    80002354:	8082                	ret

0000000080002356 <killed>:

int
killed(struct proc *p)
{
    80002356:	1101                	addi	sp,sp,-32
    80002358:	ec06                	sd	ra,24(sp)
    8000235a:	e822                	sd	s0,16(sp)
    8000235c:	e426                	sd	s1,8(sp)
    8000235e:	e04a                	sd	s2,0(sp)
    80002360:	1000                	addi	s0,sp,32
    80002362:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002364:	8c5fe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    80002368:	549c                	lw	a5,40(s1)
    8000236a:	893e                	mv	s2,a5
  release(&p->lock);
    8000236c:	8526                	mv	a0,s1
    8000236e:	94ffe0ef          	jal	80000cbc <release>
  return k;
}
    80002372:	854a                	mv	a0,s2
    80002374:	60e2                	ld	ra,24(sp)
    80002376:	6442                	ld	s0,16(sp)
    80002378:	64a2                	ld	s1,8(sp)
    8000237a:	6902                	ld	s2,0(sp)
    8000237c:	6105                	addi	sp,sp,32
    8000237e:	8082                	ret

0000000080002380 <kwait>:
{
    80002380:	715d                	addi	sp,sp,-80
    80002382:	e486                	sd	ra,72(sp)
    80002384:	e0a2                	sd	s0,64(sp)
    80002386:	fc26                	sd	s1,56(sp)
    80002388:	f84a                	sd	s2,48(sp)
    8000238a:	f44e                	sd	s3,40(sp)
    8000238c:	f052                	sd	s4,32(sp)
    8000238e:	ec56                	sd	s5,24(sp)
    80002390:	e85a                	sd	s6,16(sp)
    80002392:	e45e                	sd	s7,8(sp)
    80002394:	0880                	addi	s0,sp,80
    80002396:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002398:	d7eff0ef          	jal	80001916 <myproc>
    8000239c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000239e:	0000f517          	auipc	a0,0xf
    800023a2:	89250513          	addi	a0,a0,-1902 # 80010c30 <wait_lock>
    800023a6:	883fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    800023aa:	4a15                	li	s4,5
        havekids = 1;
    800023ac:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023ae:	00016997          	auipc	s3,0x16
    800023b2:	49a98993          	addi	s3,s3,1178 # 80018848 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800023b6:	0000fb17          	auipc	s6,0xf
    800023ba:	87ab0b13          	addi	s6,s6,-1926 # 80010c30 <wait_lock>
    800023be:	a075                	j	8000246a <kwait+0xea>
          printf("schedstats: pid=%d waiting_tick=%d\n", pp->pid, pp->waiting_tick);
    800023c0:	1684a603          	lw	a2,360(s1)
    800023c4:	588c                	lw	a1,48(s1)
    800023c6:	00006517          	auipc	a0,0x6
    800023ca:	e3a50513          	addi	a0,a0,-454 # 80008200 <etext+0x200>
    800023ce:	92cfe0ef          	jal	800004fa <printf>
          pid = pp->pid;
    800023d2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800023d6:	000b8c63          	beqz	s7,800023ee <kwait+0x6e>
    800023da:	4691                	li	a3,4
    800023dc:	02c48613          	addi	a2,s1,44
    800023e0:	85de                	mv	a1,s7
    800023e2:	05093503          	ld	a0,80(s2)
    800023e6:	a6eff0ef          	jal	80001654 <copyout>
    800023ea:	02054a63          	bltz	a0,8000241e <kwait+0x9e>
          freeproc(pp);
    800023ee:	8526                	mv	a0,s1
    800023f0:	efaff0ef          	jal	80001aea <freeproc>
          release(&pp->lock);
    800023f4:	8526                	mv	a0,s1
    800023f6:	8c7fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    800023fa:	0000f517          	auipc	a0,0xf
    800023fe:	83650513          	addi	a0,a0,-1994 # 80010c30 <wait_lock>
    80002402:	8bbfe0ef          	jal	80000cbc <release>
}
    80002406:	854e                	mv	a0,s3
    80002408:	60a6                	ld	ra,72(sp)
    8000240a:	6406                	ld	s0,64(sp)
    8000240c:	74e2                	ld	s1,56(sp)
    8000240e:	7942                	ld	s2,48(sp)
    80002410:	79a2                	ld	s3,40(sp)
    80002412:	7a02                	ld	s4,32(sp)
    80002414:	6ae2                	ld	s5,24(sp)
    80002416:	6b42                	ld	s6,16(sp)
    80002418:	6ba2                	ld	s7,8(sp)
    8000241a:	6161                	addi	sp,sp,80
    8000241c:	8082                	ret
            release(&pp->lock);
    8000241e:	8526                	mv	a0,s1
    80002420:	89dfe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    80002424:	0000f517          	auipc	a0,0xf
    80002428:	80c50513          	addi	a0,a0,-2036 # 80010c30 <wait_lock>
    8000242c:	891fe0ef          	jal	80000cbc <release>
            return -1;
    80002430:	59fd                	li	s3,-1
    80002432:	bfd1                	j	80002406 <kwait+0x86>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002434:	1e048493          	addi	s1,s1,480
    80002438:	03348063          	beq	s1,s3,80002458 <kwait+0xd8>
      if(pp->parent == p){
    8000243c:	7c9c                	ld	a5,56(s1)
    8000243e:	ff279be3          	bne	a5,s2,80002434 <kwait+0xb4>
        acquire(&pp->lock);
    80002442:	8526                	mv	a0,s1
    80002444:	fe4fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    80002448:	4c9c                	lw	a5,24(s1)
    8000244a:	f7478be3          	beq	a5,s4,800023c0 <kwait+0x40>
        release(&pp->lock);
    8000244e:	8526                	mv	a0,s1
    80002450:	86dfe0ef          	jal	80000cbc <release>
        havekids = 1;
    80002454:	8756                	mv	a4,s5
    80002456:	bff9                	j	80002434 <kwait+0xb4>
    if(!havekids || killed(p)){
    80002458:	cf19                	beqz	a4,80002476 <kwait+0xf6>
    8000245a:	854a                	mv	a0,s2
    8000245c:	efbff0ef          	jal	80002356 <killed>
    80002460:	e919                	bnez	a0,80002476 <kwait+0xf6>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002462:	85da                	mv	a1,s6
    80002464:	854a                	mv	a0,s2
    80002466:	cb5ff0ef          	jal	8000211a <sleep>
    havekids = 0;
    8000246a:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000246c:	0000f497          	auipc	s1,0xf
    80002470:	bdc48493          	addi	s1,s1,-1060 # 80011048 <proc>
    80002474:	b7e1                	j	8000243c <kwait+0xbc>
      release(&wait_lock);
    80002476:	0000e517          	auipc	a0,0xe
    8000247a:	7ba50513          	addi	a0,a0,1978 # 80010c30 <wait_lock>
    8000247e:	83ffe0ef          	jal	80000cbc <release>
      return -1;
    80002482:	59fd                	li	s3,-1
    80002484:	b749                	j	80002406 <kwait+0x86>

0000000080002486 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002486:	7179                	addi	sp,sp,-48
    80002488:	f406                	sd	ra,40(sp)
    8000248a:	f022                	sd	s0,32(sp)
    8000248c:	ec26                	sd	s1,24(sp)
    8000248e:	e84a                	sd	s2,16(sp)
    80002490:	e44e                	sd	s3,8(sp)
    80002492:	e052                	sd	s4,0(sp)
    80002494:	1800                	addi	s0,sp,48
    80002496:	84aa                	mv	s1,a0
    80002498:	8a2e                	mv	s4,a1
    8000249a:	89b2                	mv	s3,a2
    8000249c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000249e:	c78ff0ef          	jal	80001916 <myproc>
  if(user_dst){
    800024a2:	cc99                	beqz	s1,800024c0 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800024a4:	86ca                	mv	a3,s2
    800024a6:	864e                	mv	a2,s3
    800024a8:	85d2                	mv	a1,s4
    800024aa:	6928                	ld	a0,80(a0)
    800024ac:	9a8ff0ef          	jal	80001654 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024b0:	70a2                	ld	ra,40(sp)
    800024b2:	7402                	ld	s0,32(sp)
    800024b4:	64e2                	ld	s1,24(sp)
    800024b6:	6942                	ld	s2,16(sp)
    800024b8:	69a2                	ld	s3,8(sp)
    800024ba:	6a02                	ld	s4,0(sp)
    800024bc:	6145                	addi	sp,sp,48
    800024be:	8082                	ret
    memmove((char *)dst, src, len);
    800024c0:	0009061b          	sext.w	a2,s2
    800024c4:	85ce                	mv	a1,s3
    800024c6:	8552                	mv	a0,s4
    800024c8:	891fe0ef          	jal	80000d58 <memmove>
    return 0;
    800024cc:	8526                	mv	a0,s1
    800024ce:	b7cd                	j	800024b0 <either_copyout+0x2a>

00000000800024d0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024d0:	7179                	addi	sp,sp,-48
    800024d2:	f406                	sd	ra,40(sp)
    800024d4:	f022                	sd	s0,32(sp)
    800024d6:	ec26                	sd	s1,24(sp)
    800024d8:	e84a                	sd	s2,16(sp)
    800024da:	e44e                	sd	s3,8(sp)
    800024dc:	e052                	sd	s4,0(sp)
    800024de:	1800                	addi	s0,sp,48
    800024e0:	8a2a                	mv	s4,a0
    800024e2:	84ae                	mv	s1,a1
    800024e4:	89b2                	mv	s3,a2
    800024e6:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800024e8:	c2eff0ef          	jal	80001916 <myproc>
  if(user_src){
    800024ec:	cc99                	beqz	s1,8000250a <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800024ee:	86ca                	mv	a3,s2
    800024f0:	864e                	mv	a2,s3
    800024f2:	85d2                	mv	a1,s4
    800024f4:	6928                	ld	a0,80(a0)
    800024f6:	a1cff0ef          	jal	80001712 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024fa:	70a2                	ld	ra,40(sp)
    800024fc:	7402                	ld	s0,32(sp)
    800024fe:	64e2                	ld	s1,24(sp)
    80002500:	6942                	ld	s2,16(sp)
    80002502:	69a2                	ld	s3,8(sp)
    80002504:	6a02                	ld	s4,0(sp)
    80002506:	6145                	addi	sp,sp,48
    80002508:	8082                	ret
    memmove(dst, (char*)src, len);
    8000250a:	0009061b          	sext.w	a2,s2
    8000250e:	85ce                	mv	a1,s3
    80002510:	8552                	mv	a0,s4
    80002512:	847fe0ef          	jal	80000d58 <memmove>
    return 0;
    80002516:	8526                	mv	a0,s1
    80002518:	b7cd                	j	800024fa <either_copyin+0x2a>

000000008000251a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000251a:	715d                	addi	sp,sp,-80
    8000251c:	e486                	sd	ra,72(sp)
    8000251e:	e0a2                	sd	s0,64(sp)
    80002520:	fc26                	sd	s1,56(sp)
    80002522:	f84a                	sd	s2,48(sp)
    80002524:	f44e                	sd	s3,40(sp)
    80002526:	f052                	sd	s4,32(sp)
    80002528:	ec56                	sd	s5,24(sp)
    8000252a:	e85a                	sd	s6,16(sp)
    8000252c:	e45e                	sd	s7,8(sp)
    8000252e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002530:	00006517          	auipc	a0,0x6
    80002534:	b6850513          	addi	a0,a0,-1176 # 80008098 <etext+0x98>
    80002538:	fc3fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000253c:	0000f497          	auipc	s1,0xf
    80002540:	c6448493          	addi	s1,s1,-924 # 800111a0 <proc+0x158>
    80002544:	00016917          	auipc	s2,0x16
    80002548:	45c90913          	addi	s2,s2,1116 # 800189a0 <bcache+0xe0>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000254c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000254e:	00006997          	auipc	s3,0x6
    80002552:	cda98993          	addi	s3,s3,-806 # 80008228 <etext+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002556:	00006a97          	auipc	s5,0x6
    8000255a:	cdaa8a93          	addi	s5,s5,-806 # 80008230 <etext+0x230>
    printf("\n");
    8000255e:	00006a17          	auipc	s4,0x6
    80002562:	b3aa0a13          	addi	s4,s4,-1222 # 80008098 <etext+0x98>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002566:	00006b97          	auipc	s7,0x6
    8000256a:	42ab8b93          	addi	s7,s7,1066 # 80008990 <states.0>
    8000256e:	a829                	j	80002588 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002570:	ed86a583          	lw	a1,-296(a3)
    80002574:	8556                	mv	a0,s5
    80002576:	f85fd0ef          	jal	800004fa <printf>
    printf("\n");
    8000257a:	8552                	mv	a0,s4
    8000257c:	f7ffd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002580:	1e048493          	addi	s1,s1,480
    80002584:	03248263          	beq	s1,s2,800025a8 <procdump+0x8e>
    if(p->state == UNUSED)
    80002588:	86a6                	mv	a3,s1
    8000258a:	ec04a783          	lw	a5,-320(s1)
    8000258e:	dbed                	beqz	a5,80002580 <procdump+0x66>
      state = "???";
    80002590:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002592:	fcfb6fe3          	bltu	s6,a5,80002570 <procdump+0x56>
    80002596:	02079713          	slli	a4,a5,0x20
    8000259a:	01d75793          	srli	a5,a4,0x1d
    8000259e:	97de                	add	a5,a5,s7
    800025a0:	6390                	ld	a2,0(a5)
    800025a2:	f679                	bnez	a2,80002570 <procdump+0x56>
      state = "???";
    800025a4:	864e                	mv	a2,s3
    800025a6:	b7e9                	j	80002570 <procdump+0x56>
  }
}
    800025a8:	60a6                	ld	ra,72(sp)
    800025aa:	6406                	ld	s0,64(sp)
    800025ac:	74e2                	ld	s1,56(sp)
    800025ae:	7942                	ld	s2,48(sp)
    800025b0:	79a2                	ld	s3,40(sp)
    800025b2:	7a02                	ld	s4,32(sp)
    800025b4:	6ae2                	ld	s5,24(sp)
    800025b6:	6b42                	ld	s6,16(sp)
    800025b8:	6ba2                	ld	s7,8(sp)
    800025ba:	6161                	addi	sp,sp,80
    800025bc:	8082                	ret

00000000800025be <kps>:

int
kps(char *arguments)
{
    800025be:	7159                	addi	sp,sp,-112
    800025c0:	f486                	sd	ra,104(sp)
    800025c2:	f0a2                	sd	s0,96(sp)
    800025c4:	eca6                	sd	s1,88(sp)
    800025c6:	1880                	addi	s0,sp,112
    800025c8:	84aa                	mv	s1,a0
  int arg_length = 4;
  char *states[] = {"UNUSED", "USED", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE"};
    800025ca:	00006797          	auipc	a5,0x6
    800025ce:	3c678793          	addi	a5,a5,966 # 80008990 <states.0>
    800025d2:	0307b803          	ld	a6,48(a5)
    800025d6:	7f8c                	ld	a1,56(a5)
    800025d8:	63b0                	ld	a2,64(a5)
    800025da:	67b4                	ld	a3,72(a5)
    800025dc:	6bb8                	ld	a4,80(a5)
    800025de:	f9043823          	sd	a6,-112(s0)
    800025e2:	f8b43c23          	sd	a1,-104(s0)
    800025e6:	fac43023          	sd	a2,-96(s0)
    800025ea:	fad43423          	sd	a3,-88(s0)
    800025ee:	fae43823          	sd	a4,-80(s0)
    800025f2:	6fbc                	ld	a5,88(a5)
    800025f4:	faf43c23          	sd	a5,-72(s0)
  struct proc *p;
  // if user enter "-o" argument
  if (strncmp(arguments, "-o", arg_length) == 0)
    800025f8:	4611                	li	a2,4
    800025fa:	00006597          	auipc	a1,0x6
    800025fe:	c4658593          	addi	a1,a1,-954 # 80008240 <etext+0x240>
    80002602:	fcafe0ef          	jal	80000dcc <strncmp>
    80002606:	e535                	bnez	a0,80002672 <kps+0xb4>
    80002608:	e8ca                	sd	s2,80(sp)
    8000260a:	e4ce                	sd	s3,72(sp)
    8000260c:	e0d2                	sd	s4,64(sp)
    8000260e:	fc56                	sd	s5,56(sp)
    80002610:	0000f497          	auipc	s1,0xf
    80002614:	b9048493          	addi	s1,s1,-1136 # 800111a0 <proc+0x158>
    80002618:	00016a17          	auipc	s4,0x16
    8000261c:	388a0a13          	addi	s4,s4,904 # 800189a0 <bcache+0xe0>
  {
    for (p = proc; p < &proc[NPROC]; p++)
    {
      // skip/filter out printing the unused processes
      if (strncmp(p->name, "", arg_length) == 0)
    80002620:	4991                	li	s3,4
    80002622:	00006917          	auipc	s2,0x6
    80002626:	d7690913          	addi	s2,s2,-650 # 80008398 <etext+0x398>
      {
        continue;
      }
      printf("%s   ", p->name);
    8000262a:	00006a97          	auipc	s5,0x6
    8000262e:	c1ea8a93          	addi	s5,s5,-994 # 80008248 <etext+0x248>
    80002632:	a029                	j	8000263c <kps+0x7e>
    for (p = proc; p < &proc[NPROC]; p++)
    80002634:	1e048493          	addi	s1,s1,480
    80002638:	01448d63          	beq	s1,s4,80002652 <kps+0x94>
      if (strncmp(p->name, "", arg_length) == 0)
    8000263c:	864e                	mv	a2,s3
    8000263e:	85ca                	mv	a1,s2
    80002640:	8526                	mv	a0,s1
    80002642:	f8afe0ef          	jal	80000dcc <strncmp>
    80002646:	d57d                	beqz	a0,80002634 <kps+0x76>
      printf("%s   ", p->name);
    80002648:	85a6                	mv	a1,s1
    8000264a:	8556                	mv	a0,s5
    8000264c:	eaffd0ef          	jal	800004fa <printf>
    80002650:	b7d5                	j	80002634 <kps+0x76>
    }
    printf("\n");
    80002652:	00006517          	auipc	a0,0x6
    80002656:	a4650513          	addi	a0,a0,-1466 # 80008098 <etext+0x98>
    8000265a:	ea1fd0ef          	jal	800004fa <printf>
    8000265e:	6946                	ld	s2,80(sp)
    80002660:	69a6                	ld	s3,72(sp)
    80002662:	6a06                	ld	s4,64(sp)
    80002664:	7ae2                	ld	s5,56(sp)
  else
  {
    printf("Usage: ps [-o | -l]\n");
  }
  return 0;
}
    80002666:	4501                	li	a0,0
    80002668:	70a6                	ld	ra,104(sp)
    8000266a:	7406                	ld	s0,96(sp)
    8000266c:	64e6                	ld	s1,88(sp)
    8000266e:	6165                	addi	sp,sp,112
    80002670:	8082                	ret
  else if (strncmp(arguments, "-l", arg_length) == 0)
    80002672:	4611                	li	a2,4
    80002674:	00006597          	auipc	a1,0x6
    80002678:	bdc58593          	addi	a1,a1,-1060 # 80008250 <etext+0x250>
    8000267c:	8526                	mv	a0,s1
    8000267e:	f4efe0ef          	jal	80000dcc <strncmp>
    80002682:	e159                	bnez	a0,80002708 <kps+0x14a>
    80002684:	e8ca                	sd	s2,80(sp)
    80002686:	e4ce                	sd	s3,72(sp)
    80002688:	e0d2                	sd	s4,64(sp)
    printf("%s   %s       %s\n", "PID", "STATE", "NAME");
    8000268a:	00006697          	auipc	a3,0x6
    8000268e:	bce68693          	addi	a3,a3,-1074 # 80008258 <etext+0x258>
    80002692:	00006617          	auipc	a2,0x6
    80002696:	bce60613          	addi	a2,a2,-1074 # 80008260 <etext+0x260>
    8000269a:	00006597          	auipc	a1,0x6
    8000269e:	bce58593          	addi	a1,a1,-1074 # 80008268 <etext+0x268>
    800026a2:	00006517          	auipc	a0,0x6
    800026a6:	bce50513          	addi	a0,a0,-1074 # 80008270 <etext+0x270>
    800026aa:	e51fd0ef          	jal	800004fa <printf>
    printf("-------------------------\n");
    800026ae:	00006517          	auipc	a0,0x6
    800026b2:	bda50513          	addi	a0,a0,-1062 # 80008288 <etext+0x288>
    800026b6:	e45fd0ef          	jal	800004fa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800026ba:	0000f497          	auipc	s1,0xf
    800026be:	ae648493          	addi	s1,s1,-1306 # 800111a0 <proc+0x158>
    800026c2:	00016917          	auipc	s2,0x16
    800026c6:	2de90913          	addi	s2,s2,734 # 800189a0 <bcache+0xe0>
      printf("%d     %s    %s\n", p->pid, states[p->state], p->name);
    800026ca:	f9040a13          	addi	s4,s0,-112
    800026ce:	00006997          	auipc	s3,0x6
    800026d2:	bda98993          	addi	s3,s3,-1062 # 800082a8 <etext+0x2a8>
    800026d6:	a029                	j	800026e0 <kps+0x122>
    for (p = proc; p < &proc[NPROC]; p++)
    800026d8:	1e048493          	addi	s1,s1,480
    800026dc:	03248263          	beq	s1,s2,80002700 <kps+0x142>
      if (p->state == 0)
    800026e0:	ec04a783          	lw	a5,-320(s1)
    800026e4:	dbf5                	beqz	a5,800026d8 <kps+0x11a>
      printf("%d     %s    %s\n", p->pid, states[p->state], p->name);
    800026e6:	02079713          	slli	a4,a5,0x20
    800026ea:	01d75793          	srli	a5,a4,0x1d
    800026ee:	97d2                	add	a5,a5,s4
    800026f0:	86a6                	mv	a3,s1
    800026f2:	6390                	ld	a2,0(a5)
    800026f4:	ed84a583          	lw	a1,-296(s1)
    800026f8:	854e                	mv	a0,s3
    800026fa:	e01fd0ef          	jal	800004fa <printf>
    800026fe:	bfe9                	j	800026d8 <kps+0x11a>
    80002700:	6946                	ld	s2,80(sp)
    80002702:	69a6                	ld	s3,72(sp)
    80002704:	6a06                	ld	s4,64(sp)
    80002706:	b785                	j	80002666 <kps+0xa8>
    printf("Usage: ps [-o | -l]\n");
    80002708:	00006517          	auipc	a0,0x6
    8000270c:	bb850513          	addi	a0,a0,-1096 # 800082c0 <etext+0x2c0>
    80002710:	debfd0ef          	jal	800004fa <printf>
    80002714:	bf89                	j	80002666 <kps+0xa8>

0000000080002716 <res_acquire>:


// Acquire a resource for the current process (called when a process gets a lock/resource).
void
res_acquire(int res_id)
{
    80002716:	1101                	addi	sp,sp,-32
    80002718:	ec06                	sd	ra,24(sp)
    8000271a:	e822                	sd	s0,16(sp)
    8000271c:	e04a                	sd	s2,0(sp)
    8000271e:	1000                	addi	s0,sp,32
    80002720:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80002722:	9f4ff0ef          	jal	80001916 <myproc>
  if(res_id < 0 || res_id >= NRES)
    80002726:	47bd                	li	a5,15
    80002728:	0127f763          	bgeu	a5,s2,80002736 <res_acquire+0x20>
    return;
  acquire(&p->lock);
  p->holding_res[res_id] = 1;
  p->waiting_res = -1;  // no longer waiting
  release(&p->lock);
}
    8000272c:	60e2                	ld	ra,24(sp)
    8000272e:	6442                	ld	s0,16(sp)
    80002730:	6902                	ld	s2,0(sp)
    80002732:	6105                	addi	sp,sp,32
    80002734:	8082                	ret
    80002736:	e426                	sd	s1,8(sp)
    80002738:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000273a:	ceefe0ef          	jal	80000c28 <acquire>
  p->holding_res[res_id] = 1;
    8000273e:	00291793          	slli	a5,s2,0x2
    80002742:	19078793          	addi	a5,a5,400
    80002746:	97a6                	add	a5,a5,s1
    80002748:	4705                	li	a4,1
    8000274a:	c7d8                	sw	a4,12(a5)
  p->waiting_res = -1;  // no longer waiting
    8000274c:	57fd                	li	a5,-1
    8000274e:	1cf4ae23          	sw	a5,476(s1)
  release(&p->lock);
    80002752:	8526                	mv	a0,s1
    80002754:	d68fe0ef          	jal	80000cbc <release>
    80002758:	64a2                	ld	s1,8(sp)
    8000275a:	bfc9                	j	8000272c <res_acquire+0x16>

000000008000275c <res_release>:

// Release a resource held by the current process.
void
res_release(int res_id)
{
    8000275c:	1101                	addi	sp,sp,-32
    8000275e:	ec06                	sd	ra,24(sp)
    80002760:	e822                	sd	s0,16(sp)
    80002762:	e426                	sd	s1,8(sp)
    80002764:	1000                	addi	s0,sp,32
    80002766:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002768:	9aeff0ef          	jal	80001916 <myproc>
  if(res_id < 0 || res_id >= NRES)
    8000276c:	47bd                	li	a5,15
    8000276e:	0097f763          	bgeu	a5,s1,8000277c <res_release+0x20>
    return;
  acquire(&p->lock);
  p->holding_res[res_id] = 0;
  release(&p->lock);
}
    80002772:	60e2                	ld	ra,24(sp)
    80002774:	6442                	ld	s0,16(sp)
    80002776:	64a2                	ld	s1,8(sp)
    80002778:	6105                	addi	sp,sp,32
    8000277a:	8082                	ret
    8000277c:	e04a                	sd	s2,0(sp)
    8000277e:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002780:	ca8fe0ef          	jal	80000c28 <acquire>
  p->holding_res[res_id] = 0;
    80002784:	00249793          	slli	a5,s1,0x2
    80002788:	19078793          	addi	a5,a5,400
    8000278c:	854a                	mv	a0,s2
    8000278e:	97ca                	add	a5,a5,s2
    80002790:	0007a623          	sw	zero,12(a5)
  release(&p->lock);
    80002794:	d28fe0ef          	jal	80000cbc <release>
    80002798:	6902                	ld	s2,0(sp)
    8000279a:	bfe1                	j	80002772 <res_release+0x16>

000000008000279c <res_wait>:

// Mark that the current process is waiting for a resource.
void
res_wait(int res_id)
{
    8000279c:	1101                	addi	sp,sp,-32
    8000279e:	ec06                	sd	ra,24(sp)
    800027a0:	e822                	sd	s0,16(sp)
    800027a2:	e426                	sd	s1,8(sp)
    800027a4:	1000                	addi	s0,sp,32
    800027a6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800027a8:	96eff0ef          	jal	80001916 <myproc>
  if(res_id < 0 || res_id >= NRES)
    800027ac:	47bd                	li	a5,15
    800027ae:	0097f763          	bgeu	a5,s1,800027bc <res_wait+0x20>
    return;
  acquire(&p->lock);
  p->waiting_res = res_id;
  release(&p->lock);
}
    800027b2:	60e2                	ld	ra,24(sp)
    800027b4:	6442                	ld	s0,16(sp)
    800027b6:	64a2                	ld	s1,8(sp)
    800027b8:	6105                	addi	sp,sp,32
    800027ba:	8082                	ret
    800027bc:	e04a                	sd	s2,0(sp)
    800027be:	892a                	mv	s2,a0
  acquire(&p->lock);
    800027c0:	c68fe0ef          	jal	80000c28 <acquire>
  p->waiting_res = res_id;
    800027c4:	1c992e23          	sw	s1,476(s2)
  release(&p->lock);
    800027c8:	854a                	mv	a0,s2
    800027ca:	cf2fe0ef          	jal	80000cbc <release>
    800027ce:	6902                	ld	s2,0(sp)
    800027d0:	b7cd                	j	800027b2 <res_wait+0x16>

00000000800027d2 <check_deadlock>:

// 0  = no deadlock found
// pid of killed victim = deadlock was found and resolved
int
check_deadlock(void)
{
    800027d2:	bc010113          	addi	sp,sp,-1088
    800027d6:	42113c23          	sd	ra,1080(sp)
    800027da:	42813823          	sd	s0,1072(sp)
    800027de:	43213023          	sd	s2,1056(sp)
    800027e2:	44010413          	addi	s0,sp,1088
  struct proc *deadlocked[NPROC];
  int num_deadlocked = 0;

  // For each process that is waiting for a resource, follow the wait-for chain.
  // If we revisit a process, we've found a cycle = deadlock.
  for(p = proc; p < &proc[NPROC]; p++){
    800027e6:	0000f897          	auipc	a7,0xf
    800027ea:	86288893          	addi	a7,a7,-1950 # 80011048 <proc>
    800027ee:	bc040513          	addi	a0,s0,-1088
    800027f2:	00016e17          	auipc	t3,0x16
    800027f6:	056e0e13          	addi	t3,t3,86 # 80018848 <tickslock>
    800027fa:	a079                	j	80002888 <check_deadlock+0xb6>
      // Check if we've already visited this process (cycle detected)
      for(int i = 0; i < nvisited; i++){
        if(visited[i] == cur){
          // DEADLOCK DETECTED — collect all processes in the cycle
          num_deadlocked = 0;
          for(int j = i; j < nvisited; j++){
    800027fc:	10b75f63          	bge	a4,a1,8000291a <check_deadlock+0x148>
    80002800:	42913423          	sd	s1,1064(sp)
    80002804:	41313c23          	sd	s3,1048(sp)
    80002808:	00371793          	slli	a5,a4,0x3
    8000280c:	00f506b3          	add	a3,a0,a5
    80002810:	dc040493          	addi	s1,s0,-576
    80002814:	89ae                	mv	s3,a1
    80002816:	853a                	mv	a0,a4
    80002818:	9d99                	subw	a1,a1,a4
    8000281a:	02059793          	slli	a5,a1,0x20
    8000281e:	01d7d613          	srli	a2,a5,0x1d
    80002822:	9626                	add	a2,a2,s1
    80002824:	87a6                	mv	a5,s1
            deadlocked[num_deadlocked++] = visited[j];
    80002826:	6298                	ld	a4,0(a3)
    80002828:	e398                	sd	a4,0(a5)
          for(int j = i; j < nvisited; j++){
    8000282a:	06a1                	addi	a3,a3,8
    8000282c:	07a1                	addi	a5,a5,8
    8000282e:	fec79ce3          	bne	a5,a2,80002826 <check_deadlock+0x54>
    80002832:	892e                	mv	s2,a1

  // No deadlock found
  return 0;

found_deadlock:
  if(num_deadlocked == 0)
    80002834:	c19d                	beqz	a1,8000285a <check_deadlock+0x88>
    80002836:	41413823          	sd	s4,1040(sp)
    8000283a:	39fd                	addiw	s3,s3,-1
    8000283c:	40a989bb          	subw	s3,s3,a0
    return 0;

  // Among all deadlocked processes, pick the one with the HIGHEST energy_consumed.
  // killing the most energy-hungry process first reduces overall system
  // energy waste and breaks the deadlock in the most sustainable way.
  struct proc *victim = deadlocked[0];
    80002840:	dc043a03          	ld	s4,-576(s0)
  uint64 max_energy = deadlocked[0]->energy_consumed;

  for(int i = 1; i < num_deadlocked; i++){
    80002844:	4785                	li	a5,1
    80002846:	0ab7db63          	bge	a5,a1,800028fc <check_deadlock+0x12a>
    8000284a:	41513423          	sd	s5,1032(sp)
  uint64 max_energy = deadlocked[0]->energy_consumed;
    8000284e:	178a3503          	ld	a0,376(s4)
    80002852:	00848713          	addi	a4,s1,8
    80002856:	4781                	li	a5,0
    80002858:	a851                	j	800028ec <check_deadlock+0x11a>
    8000285a:	42813483          	ld	s1,1064(sp)
    8000285e:	41813983          	ld	s3,1048(sp)
    80002862:	aa91                	j	800029b6 <check_deadlock+0x1e4>
  for(p = proc; p < &proc[NPROC]; p++){
    80002864:	1e078793          	addi	a5,a5,480
    80002868:	00d78c63          	beq	a5,a3,80002880 <check_deadlock+0xae>
    if(p->state != UNUSED && p->holding_res[res_id])
    8000286c:	4f98                	lw	a4,24(a5)
    8000286e:	db7d                	beqz	a4,80002864 <check_deadlock+0x92>
    80002870:	00c78733          	add	a4,a5,a2
    80002874:	19c72703          	lw	a4,412(a4)
    80002878:	d775                	beqz	a4,80002864 <check_deadlock+0x92>
      visited[nvisited++] = cur;
    8000287a:	2585                	addiw	a1,a1,1
    8000287c:	0321                	addi	t1,t1,8
    8000287e:	a839                	j	8000289c <check_deadlock+0xca>
  for(p = proc; p < &proc[NPROC]; p++){
    80002880:	1e088893          	addi	a7,a7,480
    80002884:	05c88c63          	beq	a7,t3,800028dc <check_deadlock+0x10a>
    if(p->state == UNUSED || p->waiting_res < 0)
    80002888:	0188a783          	lw	a5,24(a7)
    8000288c:	dbf5                	beqz	a5,80002880 <check_deadlock+0xae>
    8000288e:	1dc8a783          	lw	a5,476(a7)
    80002892:	fe07c7e3          	bltz	a5,80002880 <check_deadlock+0xae>
    80002896:	832a                	mv	t1,a0
    struct proc *cur = p;
    80002898:	87c6                	mv	a5,a7
    int nvisited = 0;
    8000289a:	4581                	li	a1,0
    while(cur != 0 && cur->waiting_res >= 0){
    8000289c:	1dc7a803          	lw	a6,476(a5)
    800028a0:	fe0840e3          	bltz	a6,80002880 <check_deadlock+0xae>
      for(int i = 0; i < nvisited; i++){
    800028a4:	86aa                	mv	a3,a0
    800028a6:	4701                	li	a4,0
    800028a8:	00b05d63          	blez	a1,800028c2 <check_deadlock+0xf0>
        if(visited[i] == cur){
    800028ac:	6290                	ld	a2,0(a3)
    800028ae:	f4f607e3          	beq	a2,a5,800027fc <check_deadlock+0x2a>
      for(int i = 0; i < nvisited; i++){
    800028b2:	2705                	addiw	a4,a4,1
    800028b4:	06a1                	addi	a3,a3,8
    800028b6:	feb71be3          	bne	a4,a1,800028ac <check_deadlock+0xda>
      if(nvisited >= NPROC)
    800028ba:	03f00713          	li	a4,63
    800028be:	fcb741e3          	blt	a4,a1,80002880 <check_deadlock+0xae>
      visited[nvisited++] = cur;
    800028c2:	00f33023          	sd	a5,0(t1)
  for(p = proc; p < &proc[NPROC]; p++){
    800028c6:	00281613          	slli	a2,a6,0x2
    800028ca:	0000e797          	auipc	a5,0xe
    800028ce:	77e78793          	addi	a5,a5,1918 # 80011048 <proc>
    800028d2:	00016697          	auipc	a3,0x16
    800028d6:	f7668693          	addi	a3,a3,-138 # 80018848 <tickslock>
    800028da:	bf49                	j	8000286c <check_deadlock+0x9a>
  return 0;
    800028dc:	4901                	li	s2,0
    800028de:	a8e1                	j	800029b6 <check_deadlock+0x1e4>
  for(int i = 1; i < num_deadlocked; i++){
    800028e0:	0785                	addi	a5,a5,1
    800028e2:	0721                	addi	a4,a4,8
    800028e4:	0007869b          	sext.w	a3,a5
    800028e8:	0336db63          	bge	a3,s3,8000291e <check_deadlock+0x14c>
    if(deadlocked[i]->energy_consumed > max_energy){
    800028ec:	6314                	ld	a3,0(a4)
    800028ee:	1786b603          	ld	a2,376(a3)
    800028f2:	fec577e3          	bgeu	a0,a2,800028e0 <check_deadlock+0x10e>
      max_energy = deadlocked[i]->energy_consumed;
    800028f6:	8532                	mv	a0,a2
      victim = deadlocked[i];
    800028f8:	8a36                	mv	s4,a3
    800028fa:	b7dd                	j	800028e0 <check_deadlock+0x10e>
    }
  }

  // Print deadlock info
  printf("DEADLOCK DETECTED! %d processes in cycle:\n", num_deadlocked);
    800028fc:	00006517          	auipc	a0,0x6
    80002900:	9dc50513          	addi	a0,a0,-1572 # 800082d8 <etext+0x2d8>
    80002904:	bf7fd0ef          	jal	800004fa <printf>
  for(int i = 0; i < num_deadlocked; i++){
    80002908:	05205863          	blez	s2,80002958 <check_deadlock+0x186>
    8000290c:	41513423          	sd	s5,1032(sp)
    80002910:	a829                	j	8000292a <check_deadlock+0x158>
  for(int i = 0; i < NRES; i++)
    victim->holding_res[i] = 0;
  victim->waiting_res = -1;
  victim->killed = 1;
  if(victim->state == SLEEPING)
    victim->state = RUNNABLE;
    80002912:	478d                	li	a5,3
    80002914:	00fa2c23          	sw	a5,24(s4)
    80002918:	a061                	j	800029a0 <check_deadlock+0x1ce>
    return 0;
    8000291a:	4901                	li	s2,0
    8000291c:	a869                	j	800029b6 <check_deadlock+0x1e4>
  printf("DEADLOCK DETECTED! %d processes in cycle:\n", num_deadlocked);
    8000291e:	00006517          	auipc	a0,0x6
    80002922:	9ba50513          	addi	a0,a0,-1606 # 800082d8 <etext+0x2d8>
    80002926:	bd5fd0ef          	jal	800004fa <printf>
  for(int i = 0; i < num_deadlocked; i++){
    8000292a:	4901                	li	s2,0
    printf("  pid=%d name=%s energy_consumed=%ld waiting_res=%d\n",
    8000292c:	00006a97          	auipc	s5,0x6
    80002930:	9dca8a93          	addi	s5,s5,-1572 # 80008308 <etext+0x308>
           deadlocked[i]->pid,
    80002934:	609c                	ld	a5,0(s1)
    printf("  pid=%d name=%s energy_consumed=%ld waiting_res=%d\n",
    80002936:	1dc7a703          	lw	a4,476(a5)
    8000293a:	1787b683          	ld	a3,376(a5)
    8000293e:	15878613          	addi	a2,a5,344
    80002942:	5b8c                	lw	a1,48(a5)
    80002944:	8556                	mv	a0,s5
    80002946:	bb5fd0ef          	jal	800004fa <printf>
  for(int i = 0; i < num_deadlocked; i++){
    8000294a:	87ca                	mv	a5,s2
    8000294c:	2905                	addiw	s2,s2,1
    8000294e:	04a1                	addi	s1,s1,8
    80002950:	ff37c2e3          	blt	a5,s3,80002934 <check_deadlock+0x162>
    80002954:	40813a83          	ld	s5,1032(sp)
  printf("ENERGY-AWARE RECOVERY: Killing pid=%d (name=%s, energy=%ld) — highest energy consumer\n",
    80002958:	178a3683          	ld	a3,376(s4)
    8000295c:	158a0613          	addi	a2,s4,344
    80002960:	030a2583          	lw	a1,48(s4)
    80002964:	00006517          	auipc	a0,0x6
    80002968:	9dc50513          	addi	a0,a0,-1572 # 80008340 <etext+0x340>
    8000296c:	b8ffd0ef          	jal	800004fa <printf>
  acquire(&victim->lock);
    80002970:	84d2                	mv	s1,s4
    80002972:	8552                	mv	a0,s4
    80002974:	ab4fe0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NRES; i++)
    80002978:	19ca0793          	addi	a5,s4,412
    8000297c:	1dca0713          	addi	a4,s4,476
    victim->holding_res[i] = 0;
    80002980:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < NRES; i++)
    80002984:	0791                	addi	a5,a5,4
    80002986:	fee79de3          	bne	a5,a4,80002980 <check_deadlock+0x1ae>
  victim->waiting_res = -1;
    8000298a:	57fd                	li	a5,-1
    8000298c:	1cfa2e23          	sw	a5,476(s4)
  victim->killed = 1;
    80002990:	4785                	li	a5,1
    80002992:	02fa2423          	sw	a5,40(s4)
  if(victim->state == SLEEPING)
    80002996:	018a2703          	lw	a4,24(s4)
    8000299a:	4789                	li	a5,2
    8000299c:	f6f70be3          	beq	a4,a5,80002912 <check_deadlock+0x140>
  release(&victim->lock);
    800029a0:	8526                	mv	a0,s1
    800029a2:	b1afe0ef          	jal	80000cbc <release>

  return victim->pid;
    800029a6:	030a2903          	lw	s2,48(s4)
    800029aa:	42813483          	ld	s1,1064(sp)
    800029ae:	41813983          	ld	s3,1048(sp)
    800029b2:	41013a03          	ld	s4,1040(sp)
}
    800029b6:	854a                	mv	a0,s2
    800029b8:	43813083          	ld	ra,1080(sp)
    800029bc:	43013403          	ld	s0,1072(sp)
    800029c0:	42013903          	ld	s2,1056(sp)
    800029c4:	44010113          	addi	sp,sp,1088
    800029c8:	8082                	ret

00000000800029ca <deadlock_recover>:

// called periodically from the timer interrupt handler.
// runs the deadlock detection algorithm and recovers if needed.
void
deadlock_recover(void)
{
    800029ca:	1141                	addi	sp,sp,-16
    800029cc:	e406                	sd	ra,8(sp)
    800029ce:	e022                	sd	s0,0(sp)
    800029d0:	0800                	addi	s0,sp,16
  check_deadlock();
    800029d2:	e01ff0ef          	jal	800027d2 <check_deadlock>
}
    800029d6:	60a2                	ld	ra,8(sp)
    800029d8:	6402                	ld	s0,0(sp)
    800029da:	0141                	addi	sp,sp,16
    800029dc:	8082                	ret

00000000800029de <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800029de:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800029e2:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800029e6:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800029e8:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800029ea:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800029ee:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800029f2:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800029f6:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800029fa:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800029fe:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002a02:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002a06:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002a0a:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002a0e:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002a12:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002a16:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002a1a:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002a1c:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002a1e:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002a22:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002a26:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002a2a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002a2e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002a32:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002a36:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002a3a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002a3e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002a42:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002a46:	8082                	ret

0000000080002a48 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002a48:	1141                	addi	sp,sp,-16
    80002a4a:	e406                	sd	ra,8(sp)
    80002a4c:	e022                	sd	s0,0(sp)
    80002a4e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a50:	00006597          	auipc	a1,0x6
    80002a54:	9c058593          	addi	a1,a1,-1600 # 80008410 <etext+0x410>
    80002a58:	00016517          	auipc	a0,0x16
    80002a5c:	df050513          	addi	a0,a0,-528 # 80018848 <tickslock>
    80002a60:	93efe0ef          	jal	80000b9e <initlock>
}
    80002a64:	60a2                	ld	ra,8(sp)
    80002a66:	6402                	ld	s0,0(sp)
    80002a68:	0141                	addi	sp,sp,16
    80002a6a:	8082                	ret

0000000080002a6c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002a6c:	1141                	addi	sp,sp,-16
    80002a6e:	e406                	sd	ra,8(sp)
    80002a70:	e022                	sd	s0,0(sp)
    80002a72:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a74:	00003797          	auipc	a5,0x3
    80002a78:	3fc78793          	addi	a5,a5,1020 # 80005e70 <kernelvec>
    80002a7c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a80:	60a2                	ld	ra,8(sp)
    80002a82:	6402                	ld	s0,0(sp)
    80002a84:	0141                	addi	sp,sp,16
    80002a86:	8082                	ret

0000000080002a88 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002a88:	1141                	addi	sp,sp,-16
    80002a8a:	e406                	sd	ra,8(sp)
    80002a8c:	e022                	sd	s0,0(sp)
    80002a8e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002a90:	e87fe0ef          	jal	80001916 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a98:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a9a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002a9e:	04000737          	lui	a4,0x4000
    80002aa2:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002aa4:	0732                	slli	a4,a4,0xc
    80002aa6:	00004797          	auipc	a5,0x4
    80002aaa:	55a78793          	addi	a5,a5,1370 # 80007000 <_trampoline>
    80002aae:	00004697          	auipc	a3,0x4
    80002ab2:	55268693          	addi	a3,a3,1362 # 80007000 <_trampoline>
    80002ab6:	8f95                	sub	a5,a5,a3
    80002ab8:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002aba:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002abe:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ac0:	18002773          	csrr	a4,satp
    80002ac4:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002ac6:	6d38                	ld	a4,88(a0)
    80002ac8:	613c                	ld	a5,64(a0)
    80002aca:	6685                	lui	a3,0x1
    80002acc:	97b6                	add	a5,a5,a3
    80002ace:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002ad0:	6d3c                	ld	a5,88(a0)
    80002ad2:	00000717          	auipc	a4,0x0
    80002ad6:	13470713          	addi	a4,a4,308 # 80002c06 <usertrap>
    80002ada:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002adc:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002ade:	8712                	mv	a4,tp
    80002ae0:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ae2:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002ae6:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002aea:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aee:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002af2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002af4:	6f9c                	ld	a5,24(a5)
    80002af6:	14179073          	csrw	sepc,a5
}
    80002afa:	60a2                	ld	ra,8(sp)
    80002afc:	6402                	ld	s0,0(sp)
    80002afe:	0141                	addi	sp,sp,16
    80002b00:	8082                	ret

0000000080002b02 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002b02:	1101                	addi	sp,sp,-32
    80002b04:	ec06                	sd	ra,24(sp)
    80002b06:	e822                	sd	s0,16(sp)
    80002b08:	e426                	sd	s1,8(sp)
    80002b0a:	1000                	addi	s0,sp,32
  struct proc *p;
  
  if(cpuid() == 0){
    80002b0c:	dd7fe0ef          	jal	800018e2 <cpuid>
    80002b10:	c929                	beqz	a0,80002b62 <clockintr+0x60>
    wakeup(&ticks);
    release(&tickslock);
  }

  // Track energy consumption for the currently running process
  p = myproc();
    80002b12:	e05fe0ef          	jal	80001916 <myproc>
    80002b16:	84aa                	mv	s1,a0
  if(p != 0){
    80002b18:	c51d                	beqz	a0,80002b46 <clockintr+0x44>
    acquire(&p->lock);
    80002b1a:	90efe0ef          	jal	80000c28 <acquire>
    p->energy_consumed += ENERGY_PER_TICK;
    80002b1e:	1784b783          	ld	a5,376(s1)
    80002b22:	0785                	addi	a5,a5,1
    80002b24:	16f4bc23          	sd	a5,376(s1)
    
    // Deplete energy budget
    if(p->energy_budget >= ENERGY_PER_TICK){
    80002b28:	1704b783          	ld	a5,368(s1)
    80002b2c:	00f03733          	snez	a4,a5
    80002b30:	8f99                	sub	a5,a5,a4
    80002b32:	16f4b823          	sd	a5,368(s1)
      p->energy_budget -= ENERGY_PER_TICK;
    } else {
      p->energy_budget = 0;
    }
    
    p->last_scheduled_tick++;
    80002b36:	1804b783          	ld	a5,384(s1)
    80002b3a:	0785                	addi	a5,a5,1
    80002b3c:	18f4b023          	sd	a5,384(s1)
    release(&p->lock);
    80002b40:	8526                	mv	a0,s1
    80002b42:	97afe0ef          	jal	80000cbc <release>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002b46:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + timer_interval);
    80002b4a:	00006717          	auipc	a4,0x6
    80002b4e:	f9e73703          	ld	a4,-98(a4) # 80008ae8 <timer_interval>
    80002b52:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002b54:	14d79073          	csrw	stimecmp,a5
}
    80002b58:	60e2                	ld	ra,24(sp)
    80002b5a:	6442                	ld	s0,16(sp)
    80002b5c:	64a2                	ld	s1,8(sp)
    80002b5e:	6105                	addi	sp,sp,32
    80002b60:	8082                	ret
    acquire(&tickslock);
    80002b62:	00016517          	auipc	a0,0x16
    80002b66:	ce650513          	addi	a0,a0,-794 # 80018848 <tickslock>
    80002b6a:	8befe0ef          	jal	80000c28 <acquire>
    ticks++;
    80002b6e:	00006717          	auipc	a4,0x6
    80002b72:	faa70713          	addi	a4,a4,-86 # 80008b18 <ticks>
    80002b76:	431c                	lw	a5,0(a4)
    80002b78:	2785                	addiw	a5,a5,1
    80002b7a:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002b7c:	853a                	mv	a0,a4
    80002b7e:	de8ff0ef          	jal	80002166 <wakeup>
    release(&tickslock);
    80002b82:	00016517          	auipc	a0,0x16
    80002b86:	cc650513          	addi	a0,a0,-826 # 80018848 <tickslock>
    80002b8a:	932fe0ef          	jal	80000cbc <release>
    80002b8e:	b751                	j	80002b12 <clockintr+0x10>

0000000080002b90 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002b90:	1101                	addi	sp,sp,-32
    80002b92:	ec06                	sd	ra,24(sp)
    80002b94:	e822                	sd	s0,16(sp)
    80002b96:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b98:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002b9c:	57fd                	li	a5,-1
    80002b9e:	17fe                	slli	a5,a5,0x3f
    80002ba0:	07a5                	addi	a5,a5,9
    80002ba2:	00f70c63          	beq	a4,a5,80002bba <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002ba6:	57fd                	li	a5,-1
    80002ba8:	17fe                	slli	a5,a5,0x3f
    80002baa:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002bac:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002bae:	04f70863          	beq	a4,a5,80002bfe <devintr+0x6e>
  }
}
    80002bb2:	60e2                	ld	ra,24(sp)
    80002bb4:	6442                	ld	s0,16(sp)
    80002bb6:	6105                	addi	sp,sp,32
    80002bb8:	8082                	ret
    80002bba:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002bbc:	360030ef          	jal	80005f1c <plic_claim>
    80002bc0:	872a                	mv	a4,a0
    80002bc2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002bc4:	47a9                	li	a5,10
    80002bc6:	00f50963          	beq	a0,a5,80002bd8 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80002bca:	4785                	li	a5,1
    80002bcc:	00f50963          	beq	a0,a5,80002bde <devintr+0x4e>
    return 1;
    80002bd0:	4505                	li	a0,1
    } else if(irq){
    80002bd2:	eb09                	bnez	a4,80002be4 <devintr+0x54>
    80002bd4:	64a2                	ld	s1,8(sp)
    80002bd6:	bff1                	j	80002bb2 <devintr+0x22>
      uartintr();
    80002bd8:	e1dfd0ef          	jal	800009f4 <uartintr>
    if(irq)
    80002bdc:	a819                	j	80002bf2 <devintr+0x62>
      virtio_disk_intr();
    80002bde:	7d4030ef          	jal	800063b2 <virtio_disk_intr>
    if(irq)
    80002be2:	a801                	j	80002bf2 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80002be4:	85ba                	mv	a1,a4
    80002be6:	00006517          	auipc	a0,0x6
    80002bea:	83250513          	addi	a0,a0,-1998 # 80008418 <etext+0x418>
    80002bee:	90dfd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    80002bf2:	8526                	mv	a0,s1
    80002bf4:	348030ef          	jal	80005f3c <plic_complete>
    return 1;
    80002bf8:	4505                	li	a0,1
    80002bfa:	64a2                	ld	s1,8(sp)
    80002bfc:	bf5d                	j	80002bb2 <devintr+0x22>
    clockintr();
    80002bfe:	f05ff0ef          	jal	80002b02 <clockintr>
    return 2;
    80002c02:	4509                	li	a0,2
    80002c04:	b77d                	j	80002bb2 <devintr+0x22>

0000000080002c06 <usertrap>:
{
    80002c06:	1101                	addi	sp,sp,-32
    80002c08:	ec06                	sd	ra,24(sp)
    80002c0a:	e822                	sd	s0,16(sp)
    80002c0c:	e426                	sd	s1,8(sp)
    80002c0e:	e04a                	sd	s2,0(sp)
    80002c10:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c12:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002c16:	1007f793          	andi	a5,a5,256
    80002c1a:	eba5                	bnez	a5,80002c8a <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c1c:	00003797          	auipc	a5,0x3
    80002c20:	25478793          	addi	a5,a5,596 # 80005e70 <kernelvec>
    80002c24:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c28:	ceffe0ef          	jal	80001916 <myproc>
    80002c2c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c2e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c30:	14102773          	csrr	a4,sepc
    80002c34:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c36:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002c3a:	47a1                	li	a5,8
    80002c3c:	04f70d63          	beq	a4,a5,80002c96 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80002c40:	f51ff0ef          	jal	80002b90 <devintr>
    80002c44:	892a                	mv	s2,a0
    80002c46:	e945                	bnez	a0,80002cf6 <usertrap+0xf0>
    80002c48:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002c4c:	47bd                	li	a5,15
    80002c4e:	08f70863          	beq	a4,a5,80002cde <usertrap+0xd8>
    80002c52:	14202773          	csrr	a4,scause
    80002c56:	47b5                	li	a5,13
    80002c58:	08f70363          	beq	a4,a5,80002cde <usertrap+0xd8>
    80002c5c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002c60:	5890                	lw	a2,48(s1)
    80002c62:	00005517          	auipc	a0,0x5
    80002c66:	7f650513          	addi	a0,a0,2038 # 80008458 <etext+0x458>
    80002c6a:	891fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c6e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c72:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002c76:	00006517          	auipc	a0,0x6
    80002c7a:	81250513          	addi	a0,a0,-2030 # 80008488 <etext+0x488>
    80002c7e:	87dfd0ef          	jal	800004fa <printf>
    setkilled(p);
    80002c82:	8526                	mv	a0,s1
    80002c84:	eaeff0ef          	jal	80002332 <setkilled>
    80002c88:	a035                	j	80002cb4 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80002c8a:	00005517          	auipc	a0,0x5
    80002c8e:	7ae50513          	addi	a0,a0,1966 # 80008438 <etext+0x438>
    80002c92:	b93fd0ef          	jal	80000824 <panic>
    if(killed(p))
    80002c96:	ec0ff0ef          	jal	80002356 <killed>
    80002c9a:	ed15                	bnez	a0,80002cd6 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80002c9c:	6cb8                	ld	a4,88(s1)
    80002c9e:	6f1c                	ld	a5,24(a4)
    80002ca0:	0791                	addi	a5,a5,4
    80002ca2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ca4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002ca8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cac:	10079073          	csrw	sstatus,a5
    syscall();
    80002cb0:	2aa000ef          	jal	80002f5a <syscall>
  if(killed(p))
    80002cb4:	8526                	mv	a0,s1
    80002cb6:	ea0ff0ef          	jal	80002356 <killed>
    80002cba:	e139                	bnez	a0,80002d00 <usertrap+0xfa>
  prepare_return();
    80002cbc:	dcdff0ef          	jal	80002a88 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002cc0:	68a8                	ld	a0,80(s1)
    80002cc2:	8131                	srli	a0,a0,0xc
    80002cc4:	57fd                	li	a5,-1
    80002cc6:	17fe                	slli	a5,a5,0x3f
    80002cc8:	8d5d                	or	a0,a0,a5
}
    80002cca:	60e2                	ld	ra,24(sp)
    80002ccc:	6442                	ld	s0,16(sp)
    80002cce:	64a2                	ld	s1,8(sp)
    80002cd0:	6902                	ld	s2,0(sp)
    80002cd2:	6105                	addi	sp,sp,32
    80002cd4:	8082                	ret
      kexit(-1);
    80002cd6:	557d                	li	a0,-1
    80002cd8:	d4eff0ef          	jal	80002226 <kexit>
    80002cdc:	b7c1                	j	80002c9c <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002cde:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ce2:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002ce6:	164d                	addi	a2,a2,-13
    80002ce8:	00163613          	seqz	a2,a2
    80002cec:	68a8                	ld	a0,80(s1)
    80002cee:	8e3fe0ef          	jal	800015d0 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002cf2:	f169                	bnez	a0,80002cb4 <usertrap+0xae>
    80002cf4:	b7a5                	j	80002c5c <usertrap+0x56>
  if(killed(p))
    80002cf6:	8526                	mv	a0,s1
    80002cf8:	e5eff0ef          	jal	80002356 <killed>
    80002cfc:	c511                	beqz	a0,80002d08 <usertrap+0x102>
    80002cfe:	a011                	j	80002d02 <usertrap+0xfc>
    80002d00:	4901                	li	s2,0
    kexit(-1);
    80002d02:	557d                	li	a0,-1
    80002d04:	d22ff0ef          	jal	80002226 <kexit>
  if(which_dev == 2){
    80002d08:	4789                	li	a5,2
    80002d0a:	faf919e3          	bne	s2,a5,80002cbc <usertrap+0xb6>
    p->energy_consumed += ENERGY_PER_TICK;
    80002d0e:	1784b783          	ld	a5,376(s1)
    80002d12:	0785                	addi	a5,a5,1
    80002d14:	16f4bc23          	sd	a5,376(s1)
    if(p->energy_budget > 0)
    80002d18:	1704b783          	ld	a5,368(s1)
    80002d1c:	c781                	beqz	a5,80002d24 <usertrap+0x11e>
      p->energy_budget -= ENERGY_PER_TICK;
    80002d1e:	17fd                	addi	a5,a5,-1
    80002d20:	16f4b823          	sd	a5,368(s1)
    p->last_scheduled_tick++;
    80002d24:	1804b783          	ld	a5,384(s1)
    80002d28:	0785                	addi	a5,a5,1
    80002d2a:	18f4b023          	sd	a5,384(s1)
    acquire(&tickslock);
    80002d2e:	00016517          	auipc	a0,0x16
    80002d32:	b1a50513          	addi	a0,a0,-1254 # 80018848 <tickslock>
    80002d36:	ef3fd0ef          	jal	80000c28 <acquire>
    uint current_ticks = ticks;
    80002d3a:	00006697          	auipc	a3,0x6
    80002d3e:	dde6a683          	lw	a3,-546(a3) # 80008b18 <ticks>
    80002d42:	8936                	mv	s2,a3
    release(&tickslock);
    80002d44:	00016517          	auipc	a0,0x16
    80002d48:	b0450513          	addi	a0,a0,-1276 # 80018848 <tickslock>
    80002d4c:	f71fd0ef          	jal	80000cbc <release>
    if(current_ticks % DEADLOCK_CHECK_INTERVAL == 0){
    80002d50:	02091793          	slli	a5,s2,0x20
    80002d54:	9381                	srli	a5,a5,0x20
    80002d56:	51eb8737          	lui	a4,0x51eb8
    80002d5a:	51f70713          	addi	a4,a4,1311 # 51eb851f <_entry-0x2e147ae1>
    80002d5e:	02e787b3          	mul	a5,a5,a4
    80002d62:	9395                	srli	a5,a5,0x25
    80002d64:	06400713          	li	a4,100
    80002d68:	02f707bb          	mulw	a5,a4,a5
    80002d6c:	40f907bb          	subw	a5,s2,a5
    80002d70:	c781                	beqz	a5,80002d78 <usertrap+0x172>
    yield();
    80002d72:	b7cff0ef          	jal	800020ee <yield>
    80002d76:	b799                	j	80002cbc <usertrap+0xb6>
      deadlock_recover();
    80002d78:	c53ff0ef          	jal	800029ca <deadlock_recover>
    80002d7c:	bfdd                	j	80002d72 <usertrap+0x16c>

0000000080002d7e <kerneltrap>:
{
    80002d7e:	7179                	addi	sp,sp,-48
    80002d80:	f406                	sd	ra,40(sp)
    80002d82:	f022                	sd	s0,32(sp)
    80002d84:	ec26                	sd	s1,24(sp)
    80002d86:	e84a                	sd	s2,16(sp)
    80002d88:	e44e                	sd	s3,8(sp)
    80002d8a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d8c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d90:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d94:	142027f3          	csrr	a5,scause
    80002d98:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80002d9a:	1004f793          	andi	a5,s1,256
    80002d9e:	c795                	beqz	a5,80002dca <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002da0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002da4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002da6:	eb85                	bnez	a5,80002dd6 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80002da8:	de9ff0ef          	jal	80002b90 <devintr>
    80002dac:	c91d                	beqz	a0,80002de2 <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80002dae:	4789                	li	a5,2
    80002db0:	04f50a63          	beq	a0,a5,80002e04 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002db4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002db8:	10049073          	csrw	sstatus,s1
}
    80002dbc:	70a2                	ld	ra,40(sp)
    80002dbe:	7402                	ld	s0,32(sp)
    80002dc0:	64e2                	ld	s1,24(sp)
    80002dc2:	6942                	ld	s2,16(sp)
    80002dc4:	69a2                	ld	s3,8(sp)
    80002dc6:	6145                	addi	sp,sp,48
    80002dc8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002dca:	00005517          	auipc	a0,0x5
    80002dce:	6e650513          	addi	a0,a0,1766 # 800084b0 <etext+0x4b0>
    80002dd2:	a53fd0ef          	jal	80000824 <panic>
    panic("kerneltrap: interrupts enabled");
    80002dd6:	00005517          	auipc	a0,0x5
    80002dda:	70250513          	addi	a0,a0,1794 # 800084d8 <etext+0x4d8>
    80002dde:	a47fd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002de2:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002de6:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002dea:	85ce                	mv	a1,s3
    80002dec:	00005517          	auipc	a0,0x5
    80002df0:	70c50513          	addi	a0,a0,1804 # 800084f8 <etext+0x4f8>
    80002df4:	f06fd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80002df8:	00005517          	auipc	a0,0x5
    80002dfc:	72850513          	addi	a0,a0,1832 # 80008520 <etext+0x520>
    80002e00:	a25fd0ef          	jal	80000824 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002e04:	b13fe0ef          	jal	80001916 <myproc>
    80002e08:	d555                	beqz	a0,80002db4 <kerneltrap+0x36>
    yield();
    80002e0a:	ae4ff0ef          	jal	800020ee <yield>
    80002e0e:	b75d                	j	80002db4 <kerneltrap+0x36>

0000000080002e10 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002e10:	1101                	addi	sp,sp,-32
    80002e12:	ec06                	sd	ra,24(sp)
    80002e14:	e822                	sd	s0,16(sp)
    80002e16:	e426                	sd	s1,8(sp)
    80002e18:	1000                	addi	s0,sp,32
    80002e1a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002e1c:	afbfe0ef          	jal	80001916 <myproc>
  switch (n) {
    80002e20:	4795                	li	a5,5
    80002e22:	0497e163          	bltu	a5,s1,80002e64 <argraw+0x54>
    80002e26:	048a                	slli	s1,s1,0x2
    80002e28:	00006717          	auipc	a4,0x6
    80002e2c:	bc870713          	addi	a4,a4,-1080 # 800089f0 <states.0+0x60>
    80002e30:	94ba                	add	s1,s1,a4
    80002e32:	409c                	lw	a5,0(s1)
    80002e34:	97ba                	add	a5,a5,a4
    80002e36:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002e38:	6d3c                	ld	a5,88(a0)
    80002e3a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002e3c:	60e2                	ld	ra,24(sp)
    80002e3e:	6442                	ld	s0,16(sp)
    80002e40:	64a2                	ld	s1,8(sp)
    80002e42:	6105                	addi	sp,sp,32
    80002e44:	8082                	ret
    return p->trapframe->a1;
    80002e46:	6d3c                	ld	a5,88(a0)
    80002e48:	7fa8                	ld	a0,120(a5)
    80002e4a:	bfcd                	j	80002e3c <argraw+0x2c>
    return p->trapframe->a2;
    80002e4c:	6d3c                	ld	a5,88(a0)
    80002e4e:	63c8                	ld	a0,128(a5)
    80002e50:	b7f5                	j	80002e3c <argraw+0x2c>
    return p->trapframe->a3;
    80002e52:	6d3c                	ld	a5,88(a0)
    80002e54:	67c8                	ld	a0,136(a5)
    80002e56:	b7dd                	j	80002e3c <argraw+0x2c>
    return p->trapframe->a4;
    80002e58:	6d3c                	ld	a5,88(a0)
    80002e5a:	6bc8                	ld	a0,144(a5)
    80002e5c:	b7c5                	j	80002e3c <argraw+0x2c>
    return p->trapframe->a5;
    80002e5e:	6d3c                	ld	a5,88(a0)
    80002e60:	6fc8                	ld	a0,152(a5)
    80002e62:	bfe9                	j	80002e3c <argraw+0x2c>
  panic("argraw");
    80002e64:	00005517          	auipc	a0,0x5
    80002e68:	6cc50513          	addi	a0,a0,1740 # 80008530 <etext+0x530>
    80002e6c:	9b9fd0ef          	jal	80000824 <panic>

0000000080002e70 <fetchaddr>:
{
    80002e70:	1101                	addi	sp,sp,-32
    80002e72:	ec06                	sd	ra,24(sp)
    80002e74:	e822                	sd	s0,16(sp)
    80002e76:	e426                	sd	s1,8(sp)
    80002e78:	e04a                	sd	s2,0(sp)
    80002e7a:	1000                	addi	s0,sp,32
    80002e7c:	84aa                	mv	s1,a0
    80002e7e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002e80:	a97fe0ef          	jal	80001916 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002e84:	653c                	ld	a5,72(a0)
    80002e86:	02f4f663          	bgeu	s1,a5,80002eb2 <fetchaddr+0x42>
    80002e8a:	00848713          	addi	a4,s1,8
    80002e8e:	02e7e463          	bltu	a5,a4,80002eb6 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e92:	46a1                	li	a3,8
    80002e94:	8626                	mv	a2,s1
    80002e96:	85ca                	mv	a1,s2
    80002e98:	6928                	ld	a0,80(a0)
    80002e9a:	879fe0ef          	jal	80001712 <copyin>
    80002e9e:	00a03533          	snez	a0,a0
    80002ea2:	40a0053b          	negw	a0,a0
}
    80002ea6:	60e2                	ld	ra,24(sp)
    80002ea8:	6442                	ld	s0,16(sp)
    80002eaa:	64a2                	ld	s1,8(sp)
    80002eac:	6902                	ld	s2,0(sp)
    80002eae:	6105                	addi	sp,sp,32
    80002eb0:	8082                	ret
    return -1;
    80002eb2:	557d                	li	a0,-1
    80002eb4:	bfcd                	j	80002ea6 <fetchaddr+0x36>
    80002eb6:	557d                	li	a0,-1
    80002eb8:	b7fd                	j	80002ea6 <fetchaddr+0x36>

0000000080002eba <fetchstr>:
{
    80002eba:	7179                	addi	sp,sp,-48
    80002ebc:	f406                	sd	ra,40(sp)
    80002ebe:	f022                	sd	s0,32(sp)
    80002ec0:	ec26                	sd	s1,24(sp)
    80002ec2:	e84a                	sd	s2,16(sp)
    80002ec4:	e44e                	sd	s3,8(sp)
    80002ec6:	1800                	addi	s0,sp,48
    80002ec8:	89aa                	mv	s3,a0
    80002eca:	84ae                	mv	s1,a1
    80002ecc:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002ece:	a49fe0ef          	jal	80001916 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002ed2:	86ca                	mv	a3,s2
    80002ed4:	864e                	mv	a2,s3
    80002ed6:	85a6                	mv	a1,s1
    80002ed8:	6928                	ld	a0,80(a0)
    80002eda:	e1efe0ef          	jal	800014f8 <copyinstr>
    80002ede:	00054c63          	bltz	a0,80002ef6 <fetchstr+0x3c>
  return strlen(buf);
    80002ee2:	8526                	mv	a0,s1
    80002ee4:	f9ffd0ef          	jal	80000e82 <strlen>
}
    80002ee8:	70a2                	ld	ra,40(sp)
    80002eea:	7402                	ld	s0,32(sp)
    80002eec:	64e2                	ld	s1,24(sp)
    80002eee:	6942                	ld	s2,16(sp)
    80002ef0:	69a2                	ld	s3,8(sp)
    80002ef2:	6145                	addi	sp,sp,48
    80002ef4:	8082                	ret
    return -1;
    80002ef6:	557d                	li	a0,-1
    80002ef8:	bfc5                	j	80002ee8 <fetchstr+0x2e>

0000000080002efa <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002efa:	1101                	addi	sp,sp,-32
    80002efc:	ec06                	sd	ra,24(sp)
    80002efe:	e822                	sd	s0,16(sp)
    80002f00:	e426                	sd	s1,8(sp)
    80002f02:	1000                	addi	s0,sp,32
    80002f04:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f06:	f0bff0ef          	jal	80002e10 <argraw>
    80002f0a:	c088                	sw	a0,0(s1)
}
    80002f0c:	60e2                	ld	ra,24(sp)
    80002f0e:	6442                	ld	s0,16(sp)
    80002f10:	64a2                	ld	s1,8(sp)
    80002f12:	6105                	addi	sp,sp,32
    80002f14:	8082                	ret

0000000080002f16 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002f16:	1101                	addi	sp,sp,-32
    80002f18:	ec06                	sd	ra,24(sp)
    80002f1a:	e822                	sd	s0,16(sp)
    80002f1c:	e426                	sd	s1,8(sp)
    80002f1e:	1000                	addi	s0,sp,32
    80002f20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f22:	eefff0ef          	jal	80002e10 <argraw>
    80002f26:	e088                	sd	a0,0(s1)
}
    80002f28:	60e2                	ld	ra,24(sp)
    80002f2a:	6442                	ld	s0,16(sp)
    80002f2c:	64a2                	ld	s1,8(sp)
    80002f2e:	6105                	addi	sp,sp,32
    80002f30:	8082                	ret

0000000080002f32 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002f32:	1101                	addi	sp,sp,-32
    80002f34:	ec06                	sd	ra,24(sp)
    80002f36:	e822                	sd	s0,16(sp)
    80002f38:	e426                	sd	s1,8(sp)
    80002f3a:	e04a                	sd	s2,0(sp)
    80002f3c:	1000                	addi	s0,sp,32
    80002f3e:	892e                	mv	s2,a1
    80002f40:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002f42:	ecfff0ef          	jal	80002e10 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002f46:	8626                	mv	a2,s1
    80002f48:	85ca                	mv	a1,s2
    80002f4a:	f71ff0ef          	jal	80002eba <fetchstr>
}
    80002f4e:	60e2                	ld	ra,24(sp)
    80002f50:	6442                	ld	s0,16(sp)
    80002f52:	64a2                	ld	s1,8(sp)
    80002f54:	6902                	ld	s2,0(sp)
    80002f56:	6105                	addi	sp,sp,32
    80002f58:	8082                	ret

0000000080002f5a <syscall>:
[SYS_check_deadlock] sys_check_deadlock
};

void
syscall(void)
{
    80002f5a:	1101                	addi	sp,sp,-32
    80002f5c:	ec06                	sd	ra,24(sp)
    80002f5e:	e822                	sd	s0,16(sp)
    80002f60:	e426                	sd	s1,8(sp)
    80002f62:	e04a                	sd	s2,0(sp)
    80002f64:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002f66:	9b1fe0ef          	jal	80001916 <myproc>
    80002f6a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002f6c:	05853903          	ld	s2,88(a0)
    80002f70:	0a893783          	ld	a5,168(s2)
    80002f74:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002f78:	37fd                	addiw	a5,a5,-1
    80002f7a:	4765                	li	a4,25
    80002f7c:	00f76f63          	bltu	a4,a5,80002f9a <syscall+0x40>
    80002f80:	00369713          	slli	a4,a3,0x3
    80002f84:	00006797          	auipc	a5,0x6
    80002f88:	a8478793          	addi	a5,a5,-1404 # 80008a08 <syscalls>
    80002f8c:	97ba                	add	a5,a5,a4
    80002f8e:	639c                	ld	a5,0(a5)
    80002f90:	c789                	beqz	a5,80002f9a <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002f92:	9782                	jalr	a5
    80002f94:	06a93823          	sd	a0,112(s2)
    80002f98:	a829                	j	80002fb2 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002f9a:	15848613          	addi	a2,s1,344
    80002f9e:	588c                	lw	a1,48(s1)
    80002fa0:	00005517          	auipc	a0,0x5
    80002fa4:	59850513          	addi	a0,a0,1432 # 80008538 <etext+0x538>
    80002fa8:	d52fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002fac:	6cbc                	ld	a5,88(s1)
    80002fae:	577d                	li	a4,-1
    80002fb0:	fbb8                	sd	a4,112(a5)
  }
}
    80002fb2:	60e2                	ld	ra,24(sp)
    80002fb4:	6442                	ld	s0,16(sp)
    80002fb6:	64a2                	ld	s1,8(sp)
    80002fb8:	6902                	ld	s2,0(sp)
    80002fba:	6105                	addi	sp,sp,32
    80002fbc:	8082                	ret

0000000080002fbe <ensure_demo_locks_inited>:
static int demo_locks_inited = 0;

static void
ensure_demo_locks_inited(void)
{
  if(demo_locks_inited)
    80002fbe:	00006797          	auipc	a5,0x6
    80002fc2:	b5e7a783          	lw	a5,-1186(a5) # 80008b1c <demo_locks_inited>
    80002fc6:	c391                	beqz	a5,80002fca <ensure_demo_locks_inited+0xc>
    80002fc8:	8082                	ret
{
    80002fca:	1141                	addi	sp,sp,-16
    80002fcc:	e406                	sd	ra,8(sp)
    80002fce:	e022                	sd	s0,0(sp)
    80002fd0:	0800                	addi	s0,sp,16
    return;

  initsleeplock(&demo_locks[0], "demo_lock_0");
    80002fd2:	00005597          	auipc	a1,0x5
    80002fd6:	58658593          	addi	a1,a1,1414 # 80008558 <etext+0x558>
    80002fda:	00016517          	auipc	a0,0x16
    80002fde:	88650513          	addi	a0,a0,-1914 # 80018860 <demo_locks>
    80002fe2:	72a010ef          	jal	8000470c <initsleeplock>
  initsleeplock(&demo_locks[1], "demo_lock_1");
    80002fe6:	00005597          	auipc	a1,0x5
    80002fea:	58258593          	addi	a1,a1,1410 # 80008568 <etext+0x568>
    80002fee:	00016517          	auipc	a0,0x16
    80002ff2:	8a250513          	addi	a0,a0,-1886 # 80018890 <demo_locks+0x30>
    80002ff6:	716010ef          	jal	8000470c <initsleeplock>
  demo_locks_inited = 1;
    80002ffa:	4785                	li	a5,1
    80002ffc:	00006717          	auipc	a4,0x6
    80003000:	b2f72023          	sw	a5,-1248(a4) # 80008b1c <demo_locks_inited>
}
    80003004:	60a2                	ld	ra,8(sp)
    80003006:	6402                	ld	s0,0(sp)
    80003008:	0141                	addi	sp,sp,16
    8000300a:	8082                	ret

000000008000300c <sys_kps>:

uint64
sys_kps(void)
{
    8000300c:	1101                	addi	sp,sp,-32
    8000300e:	ec06                	sd	ra,24(sp)
    80003010:	e822                	sd	s0,16(sp)
    80003012:	1000                	addi	s0,sp,32
  int arg_length = 4;
  int first_argument = 0;
  int max_num_copy = 128;
  char kernal_buffer[arg_length];
  if (argstr(first_argument, kernal_buffer, max_num_copy) < 0)
    80003014:	08000613          	li	a2,128
    80003018:	fe840593          	addi	a1,s0,-24
    8000301c:	4501                	li	a0,0
    8000301e:	f15ff0ef          	jal	80002f32 <argstr>
    80003022:	87aa                	mv	a5,a0
  {
    // error
    return -1;
    80003024:	557d                	li	a0,-1
  if (argstr(first_argument, kernal_buffer, max_num_copy) < 0)
    80003026:	0007c663          	bltz	a5,80003032 <sys_kps+0x26>
  }
  return kps(kernal_buffer);
    8000302a:	fe840513          	addi	a0,s0,-24
    8000302e:	d90ff0ef          	jal	800025be <kps>

}
    80003032:	60e2                	ld	ra,24(sp)
    80003034:	6442                	ld	s0,16(sp)
    80003036:	6105                	addi	sp,sp,32
    80003038:	8082                	ret

000000008000303a <sys_exit>:

uint64
sys_exit(void)
{
    8000303a:	1101                	addi	sp,sp,-32
    8000303c:	ec06                	sd	ra,24(sp)
    8000303e:	e822                	sd	s0,16(sp)
    80003040:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003042:	fec40593          	addi	a1,s0,-20
    80003046:	4501                	li	a0,0
    80003048:	eb3ff0ef          	jal	80002efa <argint>
  kexit(n);
    8000304c:	fec42503          	lw	a0,-20(s0)
    80003050:	9d6ff0ef          	jal	80002226 <kexit>
  return 0;  // not reached
}
    80003054:	4501                	li	a0,0
    80003056:	60e2                	ld	ra,24(sp)
    80003058:	6442                	ld	s0,16(sp)
    8000305a:	6105                	addi	sp,sp,32
    8000305c:	8082                	ret

000000008000305e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000305e:	1141                	addi	sp,sp,-16
    80003060:	e406                	sd	ra,8(sp)
    80003062:	e022                	sd	s0,0(sp)
    80003064:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003066:	8b1fe0ef          	jal	80001916 <myproc>
}
    8000306a:	5908                	lw	a0,48(a0)
    8000306c:	60a2                	ld	ra,8(sp)
    8000306e:	6402                	ld	s0,0(sp)
    80003070:	0141                	addi	sp,sp,16
    80003072:	8082                	ret

0000000080003074 <sys_fork>:

uint64
sys_fork(void)
{
    80003074:	1141                	addi	sp,sp,-16
    80003076:	e406                	sd	ra,8(sp)
    80003078:	e022                	sd	s0,0(sp)
    8000307a:	0800                	addi	s0,sp,16
  return kfork();
    8000307c:	c6bfe0ef          	jal	80001ce6 <kfork>
}
    80003080:	60a2                	ld	ra,8(sp)
    80003082:	6402                	ld	s0,0(sp)
    80003084:	0141                	addi	sp,sp,16
    80003086:	8082                	ret

0000000080003088 <sys_wait>:

uint64
sys_wait(void)
{
    80003088:	1101                	addi	sp,sp,-32
    8000308a:	ec06                	sd	ra,24(sp)
    8000308c:	e822                	sd	s0,16(sp)
    8000308e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003090:	fe840593          	addi	a1,s0,-24
    80003094:	4501                	li	a0,0
    80003096:	e81ff0ef          	jal	80002f16 <argaddr>
  return kwait(p);
    8000309a:	fe843503          	ld	a0,-24(s0)
    8000309e:	ae2ff0ef          	jal	80002380 <kwait>
}
    800030a2:	60e2                	ld	ra,24(sp)
    800030a4:	6442                	ld	s0,16(sp)
    800030a6:	6105                	addi	sp,sp,32
    800030a8:	8082                	ret

00000000800030aa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800030aa:	7179                	addi	sp,sp,-48
    800030ac:	f406                	sd	ra,40(sp)
    800030ae:	f022                	sd	s0,32(sp)
    800030b0:	ec26                	sd	s1,24(sp)
    800030b2:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800030b4:	fd840593          	addi	a1,s0,-40
    800030b8:	4501                	li	a0,0
    800030ba:	e41ff0ef          	jal	80002efa <argint>
  argint(1, &t);
    800030be:	fdc40593          	addi	a1,s0,-36
    800030c2:	4505                	li	a0,1
    800030c4:	e37ff0ef          	jal	80002efa <argint>
  addr = myproc()->sz;
    800030c8:	84ffe0ef          	jal	80001916 <myproc>
    800030cc:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    800030ce:	fdc42703          	lw	a4,-36(s0)
    800030d2:	4785                	li	a5,1
    800030d4:	02f70763          	beq	a4,a5,80003102 <sys_sbrk+0x58>
    800030d8:	fd842783          	lw	a5,-40(s0)
    800030dc:	0207c363          	bltz	a5,80003102 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    800030e0:	97a6                	add	a5,a5,s1
      return -1;
    if(addr + n > TRAPFRAME)
    800030e2:	02000737          	lui	a4,0x2000
    800030e6:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    800030e8:	0736                	slli	a4,a4,0xd
    800030ea:	02f76a63          	bltu	a4,a5,8000311e <sys_sbrk+0x74>
    800030ee:	0297e863          	bltu	a5,s1,8000311e <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    800030f2:	825fe0ef          	jal	80001916 <myproc>
    800030f6:	fd842703          	lw	a4,-40(s0)
    800030fa:	653c                	ld	a5,72(a0)
    800030fc:	97ba                	add	a5,a5,a4
    800030fe:	e53c                	sd	a5,72(a0)
    80003100:	a039                	j	8000310e <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80003102:	fd842503          	lw	a0,-40(s0)
    80003106:	b7ffe0ef          	jal	80001c84 <growproc>
    8000310a:	00054863          	bltz	a0,8000311a <sys_sbrk+0x70>
  }
  return addr;
}
    8000310e:	8526                	mv	a0,s1
    80003110:	70a2                	ld	ra,40(sp)
    80003112:	7402                	ld	s0,32(sp)
    80003114:	64e2                	ld	s1,24(sp)
    80003116:	6145                	addi	sp,sp,48
    80003118:	8082                	ret
      return -1;
    8000311a:	54fd                	li	s1,-1
    8000311c:	bfcd                	j	8000310e <sys_sbrk+0x64>
      return -1;
    8000311e:	54fd                	li	s1,-1
    80003120:	b7fd                	j	8000310e <sys_sbrk+0x64>

0000000080003122 <sys_pause>:

uint64
sys_pause(void)
{
    80003122:	7139                	addi	sp,sp,-64
    80003124:	fc06                	sd	ra,56(sp)
    80003126:	f822                	sd	s0,48(sp)
    80003128:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000312a:	fcc40593          	addi	a1,s0,-52
    8000312e:	4501                	li	a0,0
    80003130:	dcbff0ef          	jal	80002efa <argint>
  if(n < 0)
    80003134:	fcc42783          	lw	a5,-52(s0)
    80003138:	0607c863          	bltz	a5,800031a8 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    8000313c:	00015517          	auipc	a0,0x15
    80003140:	70c50513          	addi	a0,a0,1804 # 80018848 <tickslock>
    80003144:	ae5fd0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80003148:	fcc42783          	lw	a5,-52(s0)
    8000314c:	c3b9                	beqz	a5,80003192 <sys_pause+0x70>
    8000314e:	f426                	sd	s1,40(sp)
    80003150:	f04a                	sd	s2,32(sp)
    80003152:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80003154:	00006997          	auipc	s3,0x6
    80003158:	9c49a983          	lw	s3,-1596(s3) # 80008b18 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000315c:	00015917          	auipc	s2,0x15
    80003160:	6ec90913          	addi	s2,s2,1772 # 80018848 <tickslock>
    80003164:	00006497          	auipc	s1,0x6
    80003168:	9b448493          	addi	s1,s1,-1612 # 80008b18 <ticks>
    if(killed(myproc())){
    8000316c:	faafe0ef          	jal	80001916 <myproc>
    80003170:	9e6ff0ef          	jal	80002356 <killed>
    80003174:	ed0d                	bnez	a0,800031ae <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80003176:	85ca                	mv	a1,s2
    80003178:	8526                	mv	a0,s1
    8000317a:	fa1fe0ef          	jal	8000211a <sleep>
  while(ticks - ticks0 < n){
    8000317e:	409c                	lw	a5,0(s1)
    80003180:	413787bb          	subw	a5,a5,s3
    80003184:	fcc42703          	lw	a4,-52(s0)
    80003188:	fee7e2e3          	bltu	a5,a4,8000316c <sys_pause+0x4a>
    8000318c:	74a2                	ld	s1,40(sp)
    8000318e:	7902                	ld	s2,32(sp)
    80003190:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003192:	00015517          	auipc	a0,0x15
    80003196:	6b650513          	addi	a0,a0,1718 # 80018848 <tickslock>
    8000319a:	b23fd0ef          	jal	80000cbc <release>
  return 0;
    8000319e:	4501                	li	a0,0
}
    800031a0:	70e2                	ld	ra,56(sp)
    800031a2:	7442                	ld	s0,48(sp)
    800031a4:	6121                	addi	sp,sp,64
    800031a6:	8082                	ret
    n = 0;
    800031a8:	fc042623          	sw	zero,-52(s0)
    800031ac:	bf41                	j	8000313c <sys_pause+0x1a>
      release(&tickslock);
    800031ae:	00015517          	auipc	a0,0x15
    800031b2:	69a50513          	addi	a0,a0,1690 # 80018848 <tickslock>
    800031b6:	b07fd0ef          	jal	80000cbc <release>
      return -1;
    800031ba:	557d                	li	a0,-1
    800031bc:	74a2                	ld	s1,40(sp)
    800031be:	7902                	ld	s2,32(sp)
    800031c0:	69e2                	ld	s3,24(sp)
    800031c2:	bff9                	j	800031a0 <sys_pause+0x7e>

00000000800031c4 <sys_kill>:

uint64
sys_kill(void)
{
    800031c4:	1101                	addi	sp,sp,-32
    800031c6:	ec06                	sd	ra,24(sp)
    800031c8:	e822                	sd	s0,16(sp)
    800031ca:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800031cc:	fec40593          	addi	a1,s0,-20
    800031d0:	4501                	li	a0,0
    800031d2:	d29ff0ef          	jal	80002efa <argint>
  return kkill(pid);
    800031d6:	fec42503          	lw	a0,-20(s0)
    800031da:	8f2ff0ef          	jal	800022cc <kkill>
}
    800031de:	60e2                	ld	ra,24(sp)
    800031e0:	6442                	ld	s0,16(sp)
    800031e2:	6105                	addi	sp,sp,32
    800031e4:	8082                	ret

00000000800031e6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800031e6:	1101                	addi	sp,sp,-32
    800031e8:	ec06                	sd	ra,24(sp)
    800031ea:	e822                	sd	s0,16(sp)
    800031ec:	e426                	sd	s1,8(sp)
    800031ee:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800031f0:	00015517          	auipc	a0,0x15
    800031f4:	65850513          	addi	a0,a0,1624 # 80018848 <tickslock>
    800031f8:	a31fd0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    800031fc:	00006797          	auipc	a5,0x6
    80003200:	91c7a783          	lw	a5,-1764(a5) # 80008b18 <ticks>
    80003204:	84be                	mv	s1,a5
  release(&tickslock);
    80003206:	00015517          	auipc	a0,0x15
    8000320a:	64250513          	addi	a0,a0,1602 # 80018848 <tickslock>
    8000320e:	aaffd0ef          	jal	80000cbc <release>
  return xticks;
}
    80003212:	02049513          	slli	a0,s1,0x20
    80003216:	9101                	srli	a0,a0,0x20
    80003218:	60e2                	ld	ra,24(sp)
    8000321a:	6442                	ld	s0,16(sp)
    8000321c:	64a2                	ld	s1,8(sp)
    8000321e:	6105                	addi	sp,sp,32
    80003220:	8082                	ret

0000000080003222 <sys_getenergy>:

// Get energy information for the current process
uint64
sys_getenergy(void)
{
    80003222:	7139                	addi	sp,sp,-64
    80003224:	fc06                	sd	ra,56(sp)
    80003226:	f822                	sd	s0,48(sp)
    80003228:	f426                	sd	s1,40(sp)
    8000322a:	0080                	addi	s0,sp,64
  uint64 addr;
  struct proc *p = myproc();
    8000322c:	eeafe0ef          	jal	80001916 <myproc>
    80003230:	84aa                	mv	s1,a0
  
  argaddr(0, &addr);
    80003232:	fd840593          	addi	a1,s0,-40
    80003236:	4501                	li	a0,0
    80003238:	cdfff0ef          	jal	80002f16 <argaddr>
  
  if(addr == 0)
    8000323c:	fd843783          	ld	a5,-40(s0)
    return -1;
    80003240:	557d                	li	a0,-1
  if(addr == 0)
    80003242:	cb9d                	beqz	a5,80003278 <sys_getenergy+0x56>
  
  // Create a temporary buffer to hold the energy info
  // We use a struct that matches the user-space definition
  uint64 energy_data[3];  // energy_budget, energy_consumed, pid
  
  acquire(&p->lock);
    80003244:	8526                	mv	a0,s1
    80003246:	9e3fd0ef          	jal	80000c28 <acquire>
  energy_data[0] = p->energy_budget;
    8000324a:	1704b783          	ld	a5,368(s1)
    8000324e:	fcf43023          	sd	a5,-64(s0)
  energy_data[1] = p->energy_consumed;
    80003252:	1784b783          	ld	a5,376(s1)
    80003256:	fcf43423          	sd	a5,-56(s0)
  energy_data[2] = p->pid;
    8000325a:	589c                	lw	a5,48(s1)
    8000325c:	fcf43823          	sd	a5,-48(s0)
  release(&p->lock);
    80003260:	8526                	mv	a0,s1
    80003262:	a5bfd0ef          	jal	80000cbc <release>
  
  // Copy the energy information to user space
  if(copyout(p->pagetable, addr, (char *)energy_data, sizeof(energy_data)) < 0)
    80003266:	46e1                	li	a3,24
    80003268:	fc040613          	addi	a2,s0,-64
    8000326c:	fd843583          	ld	a1,-40(s0)
    80003270:	68a8                	ld	a0,80(s1)
    80003272:	be2fe0ef          	jal	80001654 <copyout>
    80003276:	957d                	srai	a0,a0,0x3f
    return -1;
  
  return 0;
}
    80003278:	70e2                	ld	ra,56(sp)
    8000327a:	7442                	ld	s0,48(sp)
    8000327c:	74a2                	ld	s1,40(sp)
    8000327e:	6121                	addi	sp,sp,64
    80003280:	8082                	ret

0000000080003282 <sys_dlockacq>:

uint64
sys_dlockacq(void)
{
    80003282:	1101                	addi	sp,sp,-32
    80003284:	ec06                	sd	ra,24(sp)
    80003286:	e822                	sd	s0,16(sp)
    80003288:	1000                	addi	s0,sp,32
  int lockid;

  argint(0, &lockid);
    8000328a:	fec40593          	addi	a1,s0,-20
    8000328e:	4501                	li	a0,0
    80003290:	c6bff0ef          	jal	80002efa <argint>
  if(lockid < 0 || lockid > 1)
    80003294:	fec42703          	lw	a4,-20(s0)
    80003298:	4785                	li	a5,1
    return -1;
    8000329a:	557d                	li	a0,-1
  if(lockid < 0 || lockid > 1)
    8000329c:	02e7e263          	bltu	a5,a4,800032c0 <sys_dlockacq+0x3e>

  ensure_demo_locks_inited();
    800032a0:	d1fff0ef          	jal	80002fbe <ensure_demo_locks_inited>
  acquiresleep(&demo_locks[lockid]);
    800032a4:	fec42703          	lw	a4,-20(s0)
    800032a8:	00171793          	slli	a5,a4,0x1
    800032ac:	97ba                	add	a5,a5,a4
    800032ae:	0792                	slli	a5,a5,0x4
    800032b0:	00015517          	auipc	a0,0x15
    800032b4:	5b050513          	addi	a0,a0,1456 # 80018860 <demo_locks>
    800032b8:	953e                	add	a0,a0,a5
    800032ba:	488010ef          	jal	80004742 <acquiresleep>
  return 0;
    800032be:	4501                	li	a0,0
}
    800032c0:	60e2                	ld	ra,24(sp)
    800032c2:	6442                	ld	s0,16(sp)
    800032c4:	6105                	addi	sp,sp,32
    800032c6:	8082                	ret

00000000800032c8 <sys_dlockrel>:

uint64
sys_dlockrel(void)
{
    800032c8:	1101                	addi	sp,sp,-32
    800032ca:	ec06                	sd	ra,24(sp)
    800032cc:	e822                	sd	s0,16(sp)
    800032ce:	1000                	addi	s0,sp,32
  int lockid;

  argint(0, &lockid);
    800032d0:	fec40593          	addi	a1,s0,-20
    800032d4:	4501                	li	a0,0
    800032d6:	c25ff0ef          	jal	80002efa <argint>
  if(lockid < 0 || lockid > 1)
    800032da:	fec42703          	lw	a4,-20(s0)
    800032de:	4785                	li	a5,1
    return -1;
    800032e0:	557d                	li	a0,-1
  if(lockid < 0 || lockid > 1)
    800032e2:	04e7e263          	bltu	a5,a4,80003326 <sys_dlockrel+0x5e>

  ensure_demo_locks_inited();
    800032e6:	cd9ff0ef          	jal	80002fbe <ensure_demo_locks_inited>
  if(!holdingsleep(&demo_locks[lockid]))
    800032ea:	fec42703          	lw	a4,-20(s0)
    800032ee:	00171793          	slli	a5,a4,0x1
    800032f2:	97ba                	add	a5,a5,a4
    800032f4:	0792                	slli	a5,a5,0x4
    800032f6:	00015517          	auipc	a0,0x15
    800032fa:	56a50513          	addi	a0,a0,1386 # 80018860 <demo_locks>
    800032fe:	953e                	add	a0,a0,a5
    80003300:	63a010ef          	jal	8000493a <holdingsleep>
    80003304:	87aa                	mv	a5,a0
    return -1;
    80003306:	557d                	li	a0,-1
  if(!holdingsleep(&demo_locks[lockid]))
    80003308:	cf99                	beqz	a5,80003326 <sys_dlockrel+0x5e>

  releasesleep(&demo_locks[lockid]);
    8000330a:	fec42703          	lw	a4,-20(s0)
    8000330e:	00171793          	slli	a5,a4,0x1
    80003312:	97ba                	add	a5,a5,a4
    80003314:	0792                	slli	a5,a5,0x4
    80003316:	00015517          	auipc	a0,0x15
    8000331a:	54a50513          	addi	a0,a0,1354 # 80018860 <demo_locks>
    8000331e:	953e                	add	a0,a0,a5
    80003320:	5e2010ef          	jal	80004902 <releasesleep>
  return 0;
    80003324:	4501                	li	a0,0
}
    80003326:	60e2                	ld	ra,24(sp)
    80003328:	6442                	ld	s0,16(sp)
    8000332a:	6105                	addi	sp,sp,32
    8000332c:	8082                	ret

000000008000332e <sys_check_deadlock>:

// deadlock recovery system call
uint64
sys_check_deadlock(void)
{
    8000332e:	1141                	addi	sp,sp,-16
    80003330:	e406                	sd	ra,8(sp)
    80003332:	e022                	sd	s0,0(sp)
    80003334:	0800                	addi	s0,sp,16
  return check_deadlock();
    80003336:	c9cff0ef          	jal	800027d2 <check_deadlock>
}
    8000333a:	60a2                	ld	ra,8(sp)
    8000333c:	6402                	ld	s0,0(sp)
    8000333e:	0141                	addi	sp,sp,16
    80003340:	8082                	ret

0000000080003342 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003342:	7179                	addi	sp,sp,-48
    80003344:	f406                	sd	ra,40(sp)
    80003346:	f022                	sd	s0,32(sp)
    80003348:	ec26                	sd	s1,24(sp)
    8000334a:	e84a                	sd	s2,16(sp)
    8000334c:	e44e                	sd	s3,8(sp)
    8000334e:	e052                	sd	s4,0(sp)
    80003350:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003352:	00005597          	auipc	a1,0x5
    80003356:	22658593          	addi	a1,a1,550 # 80008578 <etext+0x578>
    8000335a:	00015517          	auipc	a0,0x15
    8000335e:	56650513          	addi	a0,a0,1382 # 800188c0 <bcache>
    80003362:	83dfd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003366:	0001d797          	auipc	a5,0x1d
    8000336a:	55a78793          	addi	a5,a5,1370 # 800208c0 <bcache+0x8000>
    8000336e:	0001d717          	auipc	a4,0x1d
    80003372:	7ba70713          	addi	a4,a4,1978 # 80020b28 <bcache+0x8268>
    80003376:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000337a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000337e:	00015497          	auipc	s1,0x15
    80003382:	55a48493          	addi	s1,s1,1370 # 800188d8 <bcache+0x18>
    b->next = bcache.head.next;
    80003386:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003388:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000338a:	00005a17          	auipc	s4,0x5
    8000338e:	1f6a0a13          	addi	s4,s4,502 # 80008580 <etext+0x580>
    b->next = bcache.head.next;
    80003392:	2b893783          	ld	a5,696(s2)
    80003396:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003398:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000339c:	85d2                	mv	a1,s4
    8000339e:	01048513          	addi	a0,s1,16
    800033a2:	36a010ef          	jal	8000470c <initsleeplock>
    bcache.head.next->prev = b;
    800033a6:	2b893783          	ld	a5,696(s2)
    800033aa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800033ac:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033b0:	45848493          	addi	s1,s1,1112
    800033b4:	fd349fe3          	bne	s1,s3,80003392 <binit+0x50>
  }
}
    800033b8:	70a2                	ld	ra,40(sp)
    800033ba:	7402                	ld	s0,32(sp)
    800033bc:	64e2                	ld	s1,24(sp)
    800033be:	6942                	ld	s2,16(sp)
    800033c0:	69a2                	ld	s3,8(sp)
    800033c2:	6a02                	ld	s4,0(sp)
    800033c4:	6145                	addi	sp,sp,48
    800033c6:	8082                	ret

00000000800033c8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800033c8:	7179                	addi	sp,sp,-48
    800033ca:	f406                	sd	ra,40(sp)
    800033cc:	f022                	sd	s0,32(sp)
    800033ce:	ec26                	sd	s1,24(sp)
    800033d0:	e84a                	sd	s2,16(sp)
    800033d2:	e44e                	sd	s3,8(sp)
    800033d4:	1800                	addi	s0,sp,48
    800033d6:	892a                	mv	s2,a0
    800033d8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800033da:	00015517          	auipc	a0,0x15
    800033de:	4e650513          	addi	a0,a0,1254 # 800188c0 <bcache>
    800033e2:	847fd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800033e6:	0001d497          	auipc	s1,0x1d
    800033ea:	7924b483          	ld	s1,1938(s1) # 80020b78 <bcache+0x82b8>
    800033ee:	0001d797          	auipc	a5,0x1d
    800033f2:	73a78793          	addi	a5,a5,1850 # 80020b28 <bcache+0x8268>
    800033f6:	02f48b63          	beq	s1,a5,8000342c <bread+0x64>
    800033fa:	873e                	mv	a4,a5
    800033fc:	a021                	j	80003404 <bread+0x3c>
    800033fe:	68a4                	ld	s1,80(s1)
    80003400:	02e48663          	beq	s1,a4,8000342c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80003404:	449c                	lw	a5,8(s1)
    80003406:	ff279ce3          	bne	a5,s2,800033fe <bread+0x36>
    8000340a:	44dc                	lw	a5,12(s1)
    8000340c:	ff3799e3          	bne	a5,s3,800033fe <bread+0x36>
      b->refcnt++;
    80003410:	40bc                	lw	a5,64(s1)
    80003412:	2785                	addiw	a5,a5,1
    80003414:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003416:	00015517          	auipc	a0,0x15
    8000341a:	4aa50513          	addi	a0,a0,1194 # 800188c0 <bcache>
    8000341e:	89ffd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80003422:	01048513          	addi	a0,s1,16
    80003426:	31c010ef          	jal	80004742 <acquiresleep>
      return b;
    8000342a:	a889                	j	8000347c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000342c:	0001d497          	auipc	s1,0x1d
    80003430:	7444b483          	ld	s1,1860(s1) # 80020b70 <bcache+0x82b0>
    80003434:	0001d797          	auipc	a5,0x1d
    80003438:	6f478793          	addi	a5,a5,1780 # 80020b28 <bcache+0x8268>
    8000343c:	00f48863          	beq	s1,a5,8000344c <bread+0x84>
    80003440:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003442:	40bc                	lw	a5,64(s1)
    80003444:	cb91                	beqz	a5,80003458 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003446:	64a4                	ld	s1,72(s1)
    80003448:	fee49de3          	bne	s1,a4,80003442 <bread+0x7a>
  panic("bget: no buffers");
    8000344c:	00005517          	auipc	a0,0x5
    80003450:	13c50513          	addi	a0,a0,316 # 80008588 <etext+0x588>
    80003454:	bd0fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80003458:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000345c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003460:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003464:	4785                	li	a5,1
    80003466:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003468:	00015517          	auipc	a0,0x15
    8000346c:	45850513          	addi	a0,a0,1112 # 800188c0 <bcache>
    80003470:	84dfd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80003474:	01048513          	addi	a0,s1,16
    80003478:	2ca010ef          	jal	80004742 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000347c:	409c                	lw	a5,0(s1)
    8000347e:	cb89                	beqz	a5,80003490 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003480:	8526                	mv	a0,s1
    80003482:	70a2                	ld	ra,40(sp)
    80003484:	7402                	ld	s0,32(sp)
    80003486:	64e2                	ld	s1,24(sp)
    80003488:	6942                	ld	s2,16(sp)
    8000348a:	69a2                	ld	s3,8(sp)
    8000348c:	6145                	addi	sp,sp,48
    8000348e:	8082                	ret
    virtio_disk_rw(b, 0);
    80003490:	4581                	li	a1,0
    80003492:	8526                	mv	a0,s1
    80003494:	50d020ef          	jal	800061a0 <virtio_disk_rw>
    b->valid = 1;
    80003498:	4785                	li	a5,1
    8000349a:	c09c                	sw	a5,0(s1)
  return b;
    8000349c:	b7d5                	j	80003480 <bread+0xb8>

000000008000349e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000349e:	1101                	addi	sp,sp,-32
    800034a0:	ec06                	sd	ra,24(sp)
    800034a2:	e822                	sd	s0,16(sp)
    800034a4:	e426                	sd	s1,8(sp)
    800034a6:	1000                	addi	s0,sp,32
    800034a8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034aa:	0541                	addi	a0,a0,16
    800034ac:	48e010ef          	jal	8000493a <holdingsleep>
    800034b0:	c911                	beqz	a0,800034c4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800034b2:	4585                	li	a1,1
    800034b4:	8526                	mv	a0,s1
    800034b6:	4eb020ef          	jal	800061a0 <virtio_disk_rw>
}
    800034ba:	60e2                	ld	ra,24(sp)
    800034bc:	6442                	ld	s0,16(sp)
    800034be:	64a2                	ld	s1,8(sp)
    800034c0:	6105                	addi	sp,sp,32
    800034c2:	8082                	ret
    panic("bwrite");
    800034c4:	00005517          	auipc	a0,0x5
    800034c8:	0dc50513          	addi	a0,a0,220 # 800085a0 <etext+0x5a0>
    800034cc:	b58fd0ef          	jal	80000824 <panic>

00000000800034d0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800034d0:	1101                	addi	sp,sp,-32
    800034d2:	ec06                	sd	ra,24(sp)
    800034d4:	e822                	sd	s0,16(sp)
    800034d6:	e426                	sd	s1,8(sp)
    800034d8:	e04a                	sd	s2,0(sp)
    800034da:	1000                	addi	s0,sp,32
    800034dc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034de:	01050913          	addi	s2,a0,16
    800034e2:	854a                	mv	a0,s2
    800034e4:	456010ef          	jal	8000493a <holdingsleep>
    800034e8:	c125                	beqz	a0,80003548 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800034ea:	854a                	mv	a0,s2
    800034ec:	416010ef          	jal	80004902 <releasesleep>

  acquire(&bcache.lock);
    800034f0:	00015517          	auipc	a0,0x15
    800034f4:	3d050513          	addi	a0,a0,976 # 800188c0 <bcache>
    800034f8:	f30fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    800034fc:	40bc                	lw	a5,64(s1)
    800034fe:	37fd                	addiw	a5,a5,-1
    80003500:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003502:	e79d                	bnez	a5,80003530 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003504:	68b8                	ld	a4,80(s1)
    80003506:	64bc                	ld	a5,72(s1)
    80003508:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000350a:	68b8                	ld	a4,80(s1)
    8000350c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000350e:	0001d797          	auipc	a5,0x1d
    80003512:	3b278793          	addi	a5,a5,946 # 800208c0 <bcache+0x8000>
    80003516:	2b87b703          	ld	a4,696(a5)
    8000351a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000351c:	0001d717          	auipc	a4,0x1d
    80003520:	60c70713          	addi	a4,a4,1548 # 80020b28 <bcache+0x8268>
    80003524:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003526:	2b87b703          	ld	a4,696(a5)
    8000352a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000352c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003530:	00015517          	auipc	a0,0x15
    80003534:	39050513          	addi	a0,a0,912 # 800188c0 <bcache>
    80003538:	f84fd0ef          	jal	80000cbc <release>
}
    8000353c:	60e2                	ld	ra,24(sp)
    8000353e:	6442                	ld	s0,16(sp)
    80003540:	64a2                	ld	s1,8(sp)
    80003542:	6902                	ld	s2,0(sp)
    80003544:	6105                	addi	sp,sp,32
    80003546:	8082                	ret
    panic("brelse");
    80003548:	00005517          	auipc	a0,0x5
    8000354c:	06050513          	addi	a0,a0,96 # 800085a8 <etext+0x5a8>
    80003550:	ad4fd0ef          	jal	80000824 <panic>

0000000080003554 <bpin>:

void
bpin(struct buf *b) {
    80003554:	1101                	addi	sp,sp,-32
    80003556:	ec06                	sd	ra,24(sp)
    80003558:	e822                	sd	s0,16(sp)
    8000355a:	e426                	sd	s1,8(sp)
    8000355c:	1000                	addi	s0,sp,32
    8000355e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003560:	00015517          	auipc	a0,0x15
    80003564:	36050513          	addi	a0,a0,864 # 800188c0 <bcache>
    80003568:	ec0fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    8000356c:	40bc                	lw	a5,64(s1)
    8000356e:	2785                	addiw	a5,a5,1
    80003570:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003572:	00015517          	auipc	a0,0x15
    80003576:	34e50513          	addi	a0,a0,846 # 800188c0 <bcache>
    8000357a:	f42fd0ef          	jal	80000cbc <release>
}
    8000357e:	60e2                	ld	ra,24(sp)
    80003580:	6442                	ld	s0,16(sp)
    80003582:	64a2                	ld	s1,8(sp)
    80003584:	6105                	addi	sp,sp,32
    80003586:	8082                	ret

0000000080003588 <bunpin>:

void
bunpin(struct buf *b) {
    80003588:	1101                	addi	sp,sp,-32
    8000358a:	ec06                	sd	ra,24(sp)
    8000358c:	e822                	sd	s0,16(sp)
    8000358e:	e426                	sd	s1,8(sp)
    80003590:	1000                	addi	s0,sp,32
    80003592:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003594:	00015517          	auipc	a0,0x15
    80003598:	32c50513          	addi	a0,a0,812 # 800188c0 <bcache>
    8000359c:	e8cfd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    800035a0:	40bc                	lw	a5,64(s1)
    800035a2:	37fd                	addiw	a5,a5,-1
    800035a4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035a6:	00015517          	auipc	a0,0x15
    800035aa:	31a50513          	addi	a0,a0,794 # 800188c0 <bcache>
    800035ae:	f0efd0ef          	jal	80000cbc <release>
}
    800035b2:	60e2                	ld	ra,24(sp)
    800035b4:	6442                	ld	s0,16(sp)
    800035b6:	64a2                	ld	s1,8(sp)
    800035b8:	6105                	addi	sp,sp,32
    800035ba:	8082                	ret

00000000800035bc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800035bc:	1101                	addi	sp,sp,-32
    800035be:	ec06                	sd	ra,24(sp)
    800035c0:	e822                	sd	s0,16(sp)
    800035c2:	e426                	sd	s1,8(sp)
    800035c4:	e04a                	sd	s2,0(sp)
    800035c6:	1000                	addi	s0,sp,32
    800035c8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800035ca:	00d5d79b          	srliw	a5,a1,0xd
    800035ce:	0001e597          	auipc	a1,0x1e
    800035d2:	9ce5a583          	lw	a1,-1586(a1) # 80020f9c <sb+0x1c>
    800035d6:	9dbd                	addw	a1,a1,a5
    800035d8:	df1ff0ef          	jal	800033c8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800035dc:	0074f713          	andi	a4,s1,7
    800035e0:	4785                	li	a5,1
    800035e2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800035e6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800035e8:	90d9                	srli	s1,s1,0x36
    800035ea:	00950733          	add	a4,a0,s1
    800035ee:	05874703          	lbu	a4,88(a4)
    800035f2:	00e7f6b3          	and	a3,a5,a4
    800035f6:	c29d                	beqz	a3,8000361c <bfree+0x60>
    800035f8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800035fa:	94aa                	add	s1,s1,a0
    800035fc:	fff7c793          	not	a5,a5
    80003600:	8f7d                	and	a4,a4,a5
    80003602:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003606:	000010ef          	jal	80004606 <log_write>
  brelse(bp);
    8000360a:	854a                	mv	a0,s2
    8000360c:	ec5ff0ef          	jal	800034d0 <brelse>
}
    80003610:	60e2                	ld	ra,24(sp)
    80003612:	6442                	ld	s0,16(sp)
    80003614:	64a2                	ld	s1,8(sp)
    80003616:	6902                	ld	s2,0(sp)
    80003618:	6105                	addi	sp,sp,32
    8000361a:	8082                	ret
    panic("freeing free block");
    8000361c:	00005517          	auipc	a0,0x5
    80003620:	f9450513          	addi	a0,a0,-108 # 800085b0 <etext+0x5b0>
    80003624:	a00fd0ef          	jal	80000824 <panic>

0000000080003628 <balloc>:
{
    80003628:	715d                	addi	sp,sp,-80
    8000362a:	e486                	sd	ra,72(sp)
    8000362c:	e0a2                	sd	s0,64(sp)
    8000362e:	fc26                	sd	s1,56(sp)
    80003630:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003632:	0001e797          	auipc	a5,0x1e
    80003636:	9527a783          	lw	a5,-1710(a5) # 80020f84 <sb+0x4>
    8000363a:	0e078263          	beqz	a5,8000371e <balloc+0xf6>
    8000363e:	f84a                	sd	s2,48(sp)
    80003640:	f44e                	sd	s3,40(sp)
    80003642:	f052                	sd	s4,32(sp)
    80003644:	ec56                	sd	s5,24(sp)
    80003646:	e85a                	sd	s6,16(sp)
    80003648:	e45e                	sd	s7,8(sp)
    8000364a:	e062                	sd	s8,0(sp)
    8000364c:	8baa                	mv	s7,a0
    8000364e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003650:	0001eb17          	auipc	s6,0x1e
    80003654:	930b0b13          	addi	s6,s6,-1744 # 80020f80 <sb>
      m = 1 << (bi % 8);
    80003658:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000365a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000365c:	6c09                	lui	s8,0x2
    8000365e:	a09d                	j	800036c4 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003660:	97ca                	add	a5,a5,s2
    80003662:	8e55                	or	a2,a2,a3
    80003664:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003668:	854a                	mv	a0,s2
    8000366a:	79d000ef          	jal	80004606 <log_write>
        brelse(bp);
    8000366e:	854a                	mv	a0,s2
    80003670:	e61ff0ef          	jal	800034d0 <brelse>
  bp = bread(dev, bno);
    80003674:	85a6                	mv	a1,s1
    80003676:	855e                	mv	a0,s7
    80003678:	d51ff0ef          	jal	800033c8 <bread>
    8000367c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000367e:	40000613          	li	a2,1024
    80003682:	4581                	li	a1,0
    80003684:	05850513          	addi	a0,a0,88
    80003688:	e70fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    8000368c:	854a                	mv	a0,s2
    8000368e:	779000ef          	jal	80004606 <log_write>
  brelse(bp);
    80003692:	854a                	mv	a0,s2
    80003694:	e3dff0ef          	jal	800034d0 <brelse>
}
    80003698:	7942                	ld	s2,48(sp)
    8000369a:	79a2                	ld	s3,40(sp)
    8000369c:	7a02                	ld	s4,32(sp)
    8000369e:	6ae2                	ld	s5,24(sp)
    800036a0:	6b42                	ld	s6,16(sp)
    800036a2:	6ba2                	ld	s7,8(sp)
    800036a4:	6c02                	ld	s8,0(sp)
}
    800036a6:	8526                	mv	a0,s1
    800036a8:	60a6                	ld	ra,72(sp)
    800036aa:	6406                	ld	s0,64(sp)
    800036ac:	74e2                	ld	s1,56(sp)
    800036ae:	6161                	addi	sp,sp,80
    800036b0:	8082                	ret
    brelse(bp);
    800036b2:	854a                	mv	a0,s2
    800036b4:	e1dff0ef          	jal	800034d0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800036b8:	015c0abb          	addw	s5,s8,s5
    800036bc:	004b2783          	lw	a5,4(s6)
    800036c0:	04faf863          	bgeu	s5,a5,80003710 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800036c4:	40dad59b          	sraiw	a1,s5,0xd
    800036c8:	01cb2783          	lw	a5,28(s6)
    800036cc:	9dbd                	addw	a1,a1,a5
    800036ce:	855e                	mv	a0,s7
    800036d0:	cf9ff0ef          	jal	800033c8 <bread>
    800036d4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036d6:	004b2503          	lw	a0,4(s6)
    800036da:	84d6                	mv	s1,s5
    800036dc:	4701                	li	a4,0
    800036de:	fca4fae3          	bgeu	s1,a0,800036b2 <balloc+0x8a>
      m = 1 << (bi % 8);
    800036e2:	00777693          	andi	a3,a4,7
    800036e6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800036ea:	41f7579b          	sraiw	a5,a4,0x1f
    800036ee:	01d7d79b          	srliw	a5,a5,0x1d
    800036f2:	9fb9                	addw	a5,a5,a4
    800036f4:	4037d79b          	sraiw	a5,a5,0x3
    800036f8:	00f90633          	add	a2,s2,a5
    800036fc:	05864603          	lbu	a2,88(a2)
    80003700:	00c6f5b3          	and	a1,a3,a2
    80003704:	ddb1                	beqz	a1,80003660 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003706:	2705                	addiw	a4,a4,1
    80003708:	2485                	addiw	s1,s1,1
    8000370a:	fd471ae3          	bne	a4,s4,800036de <balloc+0xb6>
    8000370e:	b755                	j	800036b2 <balloc+0x8a>
    80003710:	7942                	ld	s2,48(sp)
    80003712:	79a2                	ld	s3,40(sp)
    80003714:	7a02                	ld	s4,32(sp)
    80003716:	6ae2                	ld	s5,24(sp)
    80003718:	6b42                	ld	s6,16(sp)
    8000371a:	6ba2                	ld	s7,8(sp)
    8000371c:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000371e:	00005517          	auipc	a0,0x5
    80003722:	eaa50513          	addi	a0,a0,-342 # 800085c8 <etext+0x5c8>
    80003726:	dd5fc0ef          	jal	800004fa <printf>
  return 0;
    8000372a:	4481                	li	s1,0
    8000372c:	bfad                	j	800036a6 <balloc+0x7e>

000000008000372e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000372e:	7179                	addi	sp,sp,-48
    80003730:	f406                	sd	ra,40(sp)
    80003732:	f022                	sd	s0,32(sp)
    80003734:	ec26                	sd	s1,24(sp)
    80003736:	e84a                	sd	s2,16(sp)
    80003738:	e44e                	sd	s3,8(sp)
    8000373a:	1800                	addi	s0,sp,48
    8000373c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000373e:	47ad                	li	a5,11
    80003740:	02b7e363          	bltu	a5,a1,80003766 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003744:	02059793          	slli	a5,a1,0x20
    80003748:	01e7d593          	srli	a1,a5,0x1e
    8000374c:	00b509b3          	add	s3,a0,a1
    80003750:	0509a483          	lw	s1,80(s3)
    80003754:	e0b5                	bnez	s1,800037b8 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003756:	4108                	lw	a0,0(a0)
    80003758:	ed1ff0ef          	jal	80003628 <balloc>
    8000375c:	84aa                	mv	s1,a0
      if(addr == 0)
    8000375e:	cd29                	beqz	a0,800037b8 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003760:	04a9a823          	sw	a0,80(s3)
    80003764:	a891                	j	800037b8 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003766:	ff45879b          	addiw	a5,a1,-12
    8000376a:	873e                	mv	a4,a5
    8000376c:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    8000376e:	0ff00793          	li	a5,255
    80003772:	06e7e763          	bltu	a5,a4,800037e0 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003776:	08052483          	lw	s1,128(a0)
    8000377a:	e891                	bnez	s1,8000378e <bmap+0x60>
      addr = balloc(ip->dev);
    8000377c:	4108                	lw	a0,0(a0)
    8000377e:	eabff0ef          	jal	80003628 <balloc>
    80003782:	84aa                	mv	s1,a0
      if(addr == 0)
    80003784:	c915                	beqz	a0,800037b8 <bmap+0x8a>
    80003786:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003788:	08a92023          	sw	a0,128(s2)
    8000378c:	a011                	j	80003790 <bmap+0x62>
    8000378e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003790:	85a6                	mv	a1,s1
    80003792:	00092503          	lw	a0,0(s2)
    80003796:	c33ff0ef          	jal	800033c8 <bread>
    8000379a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000379c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800037a0:	02099713          	slli	a4,s3,0x20
    800037a4:	01e75593          	srli	a1,a4,0x1e
    800037a8:	97ae                	add	a5,a5,a1
    800037aa:	89be                	mv	s3,a5
    800037ac:	4384                	lw	s1,0(a5)
    800037ae:	cc89                	beqz	s1,800037c8 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800037b0:	8552                	mv	a0,s4
    800037b2:	d1fff0ef          	jal	800034d0 <brelse>
    return addr;
    800037b6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800037b8:	8526                	mv	a0,s1
    800037ba:	70a2                	ld	ra,40(sp)
    800037bc:	7402                	ld	s0,32(sp)
    800037be:	64e2                	ld	s1,24(sp)
    800037c0:	6942                	ld	s2,16(sp)
    800037c2:	69a2                	ld	s3,8(sp)
    800037c4:	6145                	addi	sp,sp,48
    800037c6:	8082                	ret
      addr = balloc(ip->dev);
    800037c8:	00092503          	lw	a0,0(s2)
    800037cc:	e5dff0ef          	jal	80003628 <balloc>
    800037d0:	84aa                	mv	s1,a0
      if(addr){
    800037d2:	dd79                	beqz	a0,800037b0 <bmap+0x82>
        a[bn] = addr;
    800037d4:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800037d8:	8552                	mv	a0,s4
    800037da:	62d000ef          	jal	80004606 <log_write>
    800037de:	bfc9                	j	800037b0 <bmap+0x82>
    800037e0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800037e2:	00005517          	auipc	a0,0x5
    800037e6:	dfe50513          	addi	a0,a0,-514 # 800085e0 <etext+0x5e0>
    800037ea:	83afd0ef          	jal	80000824 <panic>

00000000800037ee <iget>:
{
    800037ee:	7179                	addi	sp,sp,-48
    800037f0:	f406                	sd	ra,40(sp)
    800037f2:	f022                	sd	s0,32(sp)
    800037f4:	ec26                	sd	s1,24(sp)
    800037f6:	e84a                	sd	s2,16(sp)
    800037f8:	e44e                	sd	s3,8(sp)
    800037fa:	e052                	sd	s4,0(sp)
    800037fc:	1800                	addi	s0,sp,48
    800037fe:	892a                	mv	s2,a0
    80003800:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003802:	0001d517          	auipc	a0,0x1d
    80003806:	79e50513          	addi	a0,a0,1950 # 80020fa0 <itable>
    8000380a:	c1efd0ef          	jal	80000c28 <acquire>
  empty = 0;
    8000380e:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003810:	0001d497          	auipc	s1,0x1d
    80003814:	7a848493          	addi	s1,s1,1960 # 80020fb8 <itable+0x18>
    80003818:	0001f697          	auipc	a3,0x1f
    8000381c:	23068693          	addi	a3,a3,560 # 80022a48 <log>
    80003820:	a809                	j	80003832 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003822:	e781                	bnez	a5,8000382a <iget+0x3c>
    80003824:	00099363          	bnez	s3,8000382a <iget+0x3c>
      empty = ip;
    80003828:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000382a:	08848493          	addi	s1,s1,136
    8000382e:	02d48563          	beq	s1,a3,80003858 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003832:	449c                	lw	a5,8(s1)
    80003834:	fef057e3          	blez	a5,80003822 <iget+0x34>
    80003838:	4098                	lw	a4,0(s1)
    8000383a:	ff2718e3          	bne	a4,s2,8000382a <iget+0x3c>
    8000383e:	40d8                	lw	a4,4(s1)
    80003840:	ff4715e3          	bne	a4,s4,8000382a <iget+0x3c>
      ip->ref++;
    80003844:	2785                	addiw	a5,a5,1
    80003846:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003848:	0001d517          	auipc	a0,0x1d
    8000384c:	75850513          	addi	a0,a0,1880 # 80020fa0 <itable>
    80003850:	c6cfd0ef          	jal	80000cbc <release>
      return ip;
    80003854:	89a6                	mv	s3,s1
    80003856:	a015                	j	8000387a <iget+0x8c>
  if(empty == 0)
    80003858:	02098a63          	beqz	s3,8000388c <iget+0x9e>
  ip->dev = dev;
    8000385c:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003860:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003864:	4785                	li	a5,1
    80003866:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    8000386a:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000386e:	0001d517          	auipc	a0,0x1d
    80003872:	73250513          	addi	a0,a0,1842 # 80020fa0 <itable>
    80003876:	c46fd0ef          	jal	80000cbc <release>
}
    8000387a:	854e                	mv	a0,s3
    8000387c:	70a2                	ld	ra,40(sp)
    8000387e:	7402                	ld	s0,32(sp)
    80003880:	64e2                	ld	s1,24(sp)
    80003882:	6942                	ld	s2,16(sp)
    80003884:	69a2                	ld	s3,8(sp)
    80003886:	6a02                	ld	s4,0(sp)
    80003888:	6145                	addi	sp,sp,48
    8000388a:	8082                	ret
    panic("iget: no inodes");
    8000388c:	00005517          	auipc	a0,0x5
    80003890:	d6c50513          	addi	a0,a0,-660 # 800085f8 <etext+0x5f8>
    80003894:	f91fc0ef          	jal	80000824 <panic>

0000000080003898 <iinit>:
{
    80003898:	7179                	addi	sp,sp,-48
    8000389a:	f406                	sd	ra,40(sp)
    8000389c:	f022                	sd	s0,32(sp)
    8000389e:	ec26                	sd	s1,24(sp)
    800038a0:	e84a                	sd	s2,16(sp)
    800038a2:	e44e                	sd	s3,8(sp)
    800038a4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800038a6:	00005597          	auipc	a1,0x5
    800038aa:	d6258593          	addi	a1,a1,-670 # 80008608 <etext+0x608>
    800038ae:	0001d517          	auipc	a0,0x1d
    800038b2:	6f250513          	addi	a0,a0,1778 # 80020fa0 <itable>
    800038b6:	ae8fd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    800038ba:	0001d497          	auipc	s1,0x1d
    800038be:	70e48493          	addi	s1,s1,1806 # 80020fc8 <itable+0x28>
    800038c2:	0001f997          	auipc	s3,0x1f
    800038c6:	19698993          	addi	s3,s3,406 # 80022a58 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800038ca:	00005917          	auipc	s2,0x5
    800038ce:	d4690913          	addi	s2,s2,-698 # 80008610 <etext+0x610>
    800038d2:	85ca                	mv	a1,s2
    800038d4:	8526                	mv	a0,s1
    800038d6:	637000ef          	jal	8000470c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800038da:	08848493          	addi	s1,s1,136
    800038de:	ff349ae3          	bne	s1,s3,800038d2 <iinit+0x3a>
}
    800038e2:	70a2                	ld	ra,40(sp)
    800038e4:	7402                	ld	s0,32(sp)
    800038e6:	64e2                	ld	s1,24(sp)
    800038e8:	6942                	ld	s2,16(sp)
    800038ea:	69a2                	ld	s3,8(sp)
    800038ec:	6145                	addi	sp,sp,48
    800038ee:	8082                	ret

00000000800038f0 <ialloc>:
{
    800038f0:	7139                	addi	sp,sp,-64
    800038f2:	fc06                	sd	ra,56(sp)
    800038f4:	f822                	sd	s0,48(sp)
    800038f6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800038f8:	0001d717          	auipc	a4,0x1d
    800038fc:	69472703          	lw	a4,1684(a4) # 80020f8c <sb+0xc>
    80003900:	4785                	li	a5,1
    80003902:	06e7f063          	bgeu	a5,a4,80003962 <ialloc+0x72>
    80003906:	f426                	sd	s1,40(sp)
    80003908:	f04a                	sd	s2,32(sp)
    8000390a:	ec4e                	sd	s3,24(sp)
    8000390c:	e852                	sd	s4,16(sp)
    8000390e:	e456                	sd	s5,8(sp)
    80003910:	e05a                	sd	s6,0(sp)
    80003912:	8aaa                	mv	s5,a0
    80003914:	8b2e                	mv	s6,a1
    80003916:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003918:	0001da17          	auipc	s4,0x1d
    8000391c:	668a0a13          	addi	s4,s4,1640 # 80020f80 <sb>
    80003920:	00495593          	srli	a1,s2,0x4
    80003924:	018a2783          	lw	a5,24(s4)
    80003928:	9dbd                	addw	a1,a1,a5
    8000392a:	8556                	mv	a0,s5
    8000392c:	a9dff0ef          	jal	800033c8 <bread>
    80003930:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003932:	05850993          	addi	s3,a0,88
    80003936:	00f97793          	andi	a5,s2,15
    8000393a:	079a                	slli	a5,a5,0x6
    8000393c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000393e:	00099783          	lh	a5,0(s3)
    80003942:	cb9d                	beqz	a5,80003978 <ialloc+0x88>
    brelse(bp);
    80003944:	b8dff0ef          	jal	800034d0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003948:	0905                	addi	s2,s2,1
    8000394a:	00ca2703          	lw	a4,12(s4)
    8000394e:	0009079b          	sext.w	a5,s2
    80003952:	fce7e7e3          	bltu	a5,a4,80003920 <ialloc+0x30>
    80003956:	74a2                	ld	s1,40(sp)
    80003958:	7902                	ld	s2,32(sp)
    8000395a:	69e2                	ld	s3,24(sp)
    8000395c:	6a42                	ld	s4,16(sp)
    8000395e:	6aa2                	ld	s5,8(sp)
    80003960:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003962:	00005517          	auipc	a0,0x5
    80003966:	cb650513          	addi	a0,a0,-842 # 80008618 <etext+0x618>
    8000396a:	b91fc0ef          	jal	800004fa <printf>
  return 0;
    8000396e:	4501                	li	a0,0
}
    80003970:	70e2                	ld	ra,56(sp)
    80003972:	7442                	ld	s0,48(sp)
    80003974:	6121                	addi	sp,sp,64
    80003976:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003978:	04000613          	li	a2,64
    8000397c:	4581                	li	a1,0
    8000397e:	854e                	mv	a0,s3
    80003980:	b78fd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    80003984:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003988:	8526                	mv	a0,s1
    8000398a:	47d000ef          	jal	80004606 <log_write>
      brelse(bp);
    8000398e:	8526                	mv	a0,s1
    80003990:	b41ff0ef          	jal	800034d0 <brelse>
      return iget(dev, inum);
    80003994:	0009059b          	sext.w	a1,s2
    80003998:	8556                	mv	a0,s5
    8000399a:	e55ff0ef          	jal	800037ee <iget>
    8000399e:	74a2                	ld	s1,40(sp)
    800039a0:	7902                	ld	s2,32(sp)
    800039a2:	69e2                	ld	s3,24(sp)
    800039a4:	6a42                	ld	s4,16(sp)
    800039a6:	6aa2                	ld	s5,8(sp)
    800039a8:	6b02                	ld	s6,0(sp)
    800039aa:	b7d9                	j	80003970 <ialloc+0x80>

00000000800039ac <iupdate>:
{
    800039ac:	1101                	addi	sp,sp,-32
    800039ae:	ec06                	sd	ra,24(sp)
    800039b0:	e822                	sd	s0,16(sp)
    800039b2:	e426                	sd	s1,8(sp)
    800039b4:	e04a                	sd	s2,0(sp)
    800039b6:	1000                	addi	s0,sp,32
    800039b8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039ba:	415c                	lw	a5,4(a0)
    800039bc:	0047d79b          	srliw	a5,a5,0x4
    800039c0:	0001d597          	auipc	a1,0x1d
    800039c4:	5d85a583          	lw	a1,1496(a1) # 80020f98 <sb+0x18>
    800039c8:	9dbd                	addw	a1,a1,a5
    800039ca:	4108                	lw	a0,0(a0)
    800039cc:	9fdff0ef          	jal	800033c8 <bread>
    800039d0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800039d2:	05850793          	addi	a5,a0,88
    800039d6:	40d8                	lw	a4,4(s1)
    800039d8:	8b3d                	andi	a4,a4,15
    800039da:	071a                	slli	a4,a4,0x6
    800039dc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800039de:	04449703          	lh	a4,68(s1)
    800039e2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800039e6:	04649703          	lh	a4,70(s1)
    800039ea:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800039ee:	04849703          	lh	a4,72(s1)
    800039f2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800039f6:	04a49703          	lh	a4,74(s1)
    800039fa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800039fe:	44f8                	lw	a4,76(s1)
    80003a00:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003a02:	03400613          	li	a2,52
    80003a06:	05048593          	addi	a1,s1,80
    80003a0a:	00c78513          	addi	a0,a5,12
    80003a0e:	b4afd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    80003a12:	854a                	mv	a0,s2
    80003a14:	3f3000ef          	jal	80004606 <log_write>
  brelse(bp);
    80003a18:	854a                	mv	a0,s2
    80003a1a:	ab7ff0ef          	jal	800034d0 <brelse>
}
    80003a1e:	60e2                	ld	ra,24(sp)
    80003a20:	6442                	ld	s0,16(sp)
    80003a22:	64a2                	ld	s1,8(sp)
    80003a24:	6902                	ld	s2,0(sp)
    80003a26:	6105                	addi	sp,sp,32
    80003a28:	8082                	ret

0000000080003a2a <idup>:
{
    80003a2a:	1101                	addi	sp,sp,-32
    80003a2c:	ec06                	sd	ra,24(sp)
    80003a2e:	e822                	sd	s0,16(sp)
    80003a30:	e426                	sd	s1,8(sp)
    80003a32:	1000                	addi	s0,sp,32
    80003a34:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a36:	0001d517          	auipc	a0,0x1d
    80003a3a:	56a50513          	addi	a0,a0,1386 # 80020fa0 <itable>
    80003a3e:	9eafd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    80003a42:	449c                	lw	a5,8(s1)
    80003a44:	2785                	addiw	a5,a5,1
    80003a46:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a48:	0001d517          	auipc	a0,0x1d
    80003a4c:	55850513          	addi	a0,a0,1368 # 80020fa0 <itable>
    80003a50:	a6cfd0ef          	jal	80000cbc <release>
}
    80003a54:	8526                	mv	a0,s1
    80003a56:	60e2                	ld	ra,24(sp)
    80003a58:	6442                	ld	s0,16(sp)
    80003a5a:	64a2                	ld	s1,8(sp)
    80003a5c:	6105                	addi	sp,sp,32
    80003a5e:	8082                	ret

0000000080003a60 <ilock>:
{
    80003a60:	1101                	addi	sp,sp,-32
    80003a62:	ec06                	sd	ra,24(sp)
    80003a64:	e822                	sd	s0,16(sp)
    80003a66:	e426                	sd	s1,8(sp)
    80003a68:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003a6a:	cd19                	beqz	a0,80003a88 <ilock+0x28>
    80003a6c:	84aa                	mv	s1,a0
    80003a6e:	451c                	lw	a5,8(a0)
    80003a70:	00f05c63          	blez	a5,80003a88 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003a74:	0541                	addi	a0,a0,16
    80003a76:	4cd000ef          	jal	80004742 <acquiresleep>
  if(ip->valid == 0){
    80003a7a:	40bc                	lw	a5,64(s1)
    80003a7c:	cf89                	beqz	a5,80003a96 <ilock+0x36>
}
    80003a7e:	60e2                	ld	ra,24(sp)
    80003a80:	6442                	ld	s0,16(sp)
    80003a82:	64a2                	ld	s1,8(sp)
    80003a84:	6105                	addi	sp,sp,32
    80003a86:	8082                	ret
    80003a88:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003a8a:	00005517          	auipc	a0,0x5
    80003a8e:	ba650513          	addi	a0,a0,-1114 # 80008630 <etext+0x630>
    80003a92:	d93fc0ef          	jal	80000824 <panic>
    80003a96:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a98:	40dc                	lw	a5,4(s1)
    80003a9a:	0047d79b          	srliw	a5,a5,0x4
    80003a9e:	0001d597          	auipc	a1,0x1d
    80003aa2:	4fa5a583          	lw	a1,1274(a1) # 80020f98 <sb+0x18>
    80003aa6:	9dbd                	addw	a1,a1,a5
    80003aa8:	4088                	lw	a0,0(s1)
    80003aaa:	91fff0ef          	jal	800033c8 <bread>
    80003aae:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ab0:	05850593          	addi	a1,a0,88
    80003ab4:	40dc                	lw	a5,4(s1)
    80003ab6:	8bbd                	andi	a5,a5,15
    80003ab8:	079a                	slli	a5,a5,0x6
    80003aba:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003abc:	00059783          	lh	a5,0(a1)
    80003ac0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003ac4:	00259783          	lh	a5,2(a1)
    80003ac8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003acc:	00459783          	lh	a5,4(a1)
    80003ad0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ad4:	00659783          	lh	a5,6(a1)
    80003ad8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003adc:	459c                	lw	a5,8(a1)
    80003ade:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003ae0:	03400613          	li	a2,52
    80003ae4:	05b1                	addi	a1,a1,12
    80003ae6:	05048513          	addi	a0,s1,80
    80003aea:	a6efd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    80003aee:	854a                	mv	a0,s2
    80003af0:	9e1ff0ef          	jal	800034d0 <brelse>
    ip->valid = 1;
    80003af4:	4785                	li	a5,1
    80003af6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003af8:	04449783          	lh	a5,68(s1)
    80003afc:	c399                	beqz	a5,80003b02 <ilock+0xa2>
    80003afe:	6902                	ld	s2,0(sp)
    80003b00:	bfbd                	j	80003a7e <ilock+0x1e>
      panic("ilock: no type");
    80003b02:	00005517          	auipc	a0,0x5
    80003b06:	b3650513          	addi	a0,a0,-1226 # 80008638 <etext+0x638>
    80003b0a:	d1bfc0ef          	jal	80000824 <panic>

0000000080003b0e <iunlock>:
{
    80003b0e:	1101                	addi	sp,sp,-32
    80003b10:	ec06                	sd	ra,24(sp)
    80003b12:	e822                	sd	s0,16(sp)
    80003b14:	e426                	sd	s1,8(sp)
    80003b16:	e04a                	sd	s2,0(sp)
    80003b18:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003b1a:	c505                	beqz	a0,80003b42 <iunlock+0x34>
    80003b1c:	84aa                	mv	s1,a0
    80003b1e:	01050913          	addi	s2,a0,16
    80003b22:	854a                	mv	a0,s2
    80003b24:	617000ef          	jal	8000493a <holdingsleep>
    80003b28:	cd09                	beqz	a0,80003b42 <iunlock+0x34>
    80003b2a:	449c                	lw	a5,8(s1)
    80003b2c:	00f05b63          	blez	a5,80003b42 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003b30:	854a                	mv	a0,s2
    80003b32:	5d1000ef          	jal	80004902 <releasesleep>
}
    80003b36:	60e2                	ld	ra,24(sp)
    80003b38:	6442                	ld	s0,16(sp)
    80003b3a:	64a2                	ld	s1,8(sp)
    80003b3c:	6902                	ld	s2,0(sp)
    80003b3e:	6105                	addi	sp,sp,32
    80003b40:	8082                	ret
    panic("iunlock");
    80003b42:	00005517          	auipc	a0,0x5
    80003b46:	b0650513          	addi	a0,a0,-1274 # 80008648 <etext+0x648>
    80003b4a:	cdbfc0ef          	jal	80000824 <panic>

0000000080003b4e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003b4e:	7179                	addi	sp,sp,-48
    80003b50:	f406                	sd	ra,40(sp)
    80003b52:	f022                	sd	s0,32(sp)
    80003b54:	ec26                	sd	s1,24(sp)
    80003b56:	e84a                	sd	s2,16(sp)
    80003b58:	e44e                	sd	s3,8(sp)
    80003b5a:	1800                	addi	s0,sp,48
    80003b5c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003b5e:	05050493          	addi	s1,a0,80
    80003b62:	08050913          	addi	s2,a0,128
    80003b66:	a021                	j	80003b6e <itrunc+0x20>
    80003b68:	0491                	addi	s1,s1,4
    80003b6a:	01248b63          	beq	s1,s2,80003b80 <itrunc+0x32>
    if(ip->addrs[i]){
    80003b6e:	408c                	lw	a1,0(s1)
    80003b70:	dde5                	beqz	a1,80003b68 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003b72:	0009a503          	lw	a0,0(s3)
    80003b76:	a47ff0ef          	jal	800035bc <bfree>
      ip->addrs[i] = 0;
    80003b7a:	0004a023          	sw	zero,0(s1)
    80003b7e:	b7ed                	j	80003b68 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003b80:	0809a583          	lw	a1,128(s3)
    80003b84:	ed89                	bnez	a1,80003b9e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003b86:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003b8a:	854e                	mv	a0,s3
    80003b8c:	e21ff0ef          	jal	800039ac <iupdate>
}
    80003b90:	70a2                	ld	ra,40(sp)
    80003b92:	7402                	ld	s0,32(sp)
    80003b94:	64e2                	ld	s1,24(sp)
    80003b96:	6942                	ld	s2,16(sp)
    80003b98:	69a2                	ld	s3,8(sp)
    80003b9a:	6145                	addi	sp,sp,48
    80003b9c:	8082                	ret
    80003b9e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ba0:	0009a503          	lw	a0,0(s3)
    80003ba4:	825ff0ef          	jal	800033c8 <bread>
    80003ba8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003baa:	05850493          	addi	s1,a0,88
    80003bae:	45850913          	addi	s2,a0,1112
    80003bb2:	a021                	j	80003bba <itrunc+0x6c>
    80003bb4:	0491                	addi	s1,s1,4
    80003bb6:	01248963          	beq	s1,s2,80003bc8 <itrunc+0x7a>
      if(a[j])
    80003bba:	408c                	lw	a1,0(s1)
    80003bbc:	dde5                	beqz	a1,80003bb4 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003bbe:	0009a503          	lw	a0,0(s3)
    80003bc2:	9fbff0ef          	jal	800035bc <bfree>
    80003bc6:	b7fd                	j	80003bb4 <itrunc+0x66>
    brelse(bp);
    80003bc8:	8552                	mv	a0,s4
    80003bca:	907ff0ef          	jal	800034d0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003bce:	0809a583          	lw	a1,128(s3)
    80003bd2:	0009a503          	lw	a0,0(s3)
    80003bd6:	9e7ff0ef          	jal	800035bc <bfree>
    ip->addrs[NDIRECT] = 0;
    80003bda:	0809a023          	sw	zero,128(s3)
    80003bde:	6a02                	ld	s4,0(sp)
    80003be0:	b75d                	j	80003b86 <itrunc+0x38>

0000000080003be2 <iput>:
{
    80003be2:	1101                	addi	sp,sp,-32
    80003be4:	ec06                	sd	ra,24(sp)
    80003be6:	e822                	sd	s0,16(sp)
    80003be8:	e426                	sd	s1,8(sp)
    80003bea:	1000                	addi	s0,sp,32
    80003bec:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003bee:	0001d517          	auipc	a0,0x1d
    80003bf2:	3b250513          	addi	a0,a0,946 # 80020fa0 <itable>
    80003bf6:	832fd0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003bfa:	4498                	lw	a4,8(s1)
    80003bfc:	4785                	li	a5,1
    80003bfe:	02f70063          	beq	a4,a5,80003c1e <iput+0x3c>
  ip->ref--;
    80003c02:	449c                	lw	a5,8(s1)
    80003c04:	37fd                	addiw	a5,a5,-1
    80003c06:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c08:	0001d517          	auipc	a0,0x1d
    80003c0c:	39850513          	addi	a0,a0,920 # 80020fa0 <itable>
    80003c10:	8acfd0ef          	jal	80000cbc <release>
}
    80003c14:	60e2                	ld	ra,24(sp)
    80003c16:	6442                	ld	s0,16(sp)
    80003c18:	64a2                	ld	s1,8(sp)
    80003c1a:	6105                	addi	sp,sp,32
    80003c1c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c1e:	40bc                	lw	a5,64(s1)
    80003c20:	d3ed                	beqz	a5,80003c02 <iput+0x20>
    80003c22:	04a49783          	lh	a5,74(s1)
    80003c26:	fff1                	bnez	a5,80003c02 <iput+0x20>
    80003c28:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003c2a:	01048793          	addi	a5,s1,16
    80003c2e:	893e                	mv	s2,a5
    80003c30:	853e                	mv	a0,a5
    80003c32:	311000ef          	jal	80004742 <acquiresleep>
    release(&itable.lock);
    80003c36:	0001d517          	auipc	a0,0x1d
    80003c3a:	36a50513          	addi	a0,a0,874 # 80020fa0 <itable>
    80003c3e:	87efd0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003c42:	8526                	mv	a0,s1
    80003c44:	f0bff0ef          	jal	80003b4e <itrunc>
    ip->type = 0;
    80003c48:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003c4c:	8526                	mv	a0,s1
    80003c4e:	d5fff0ef          	jal	800039ac <iupdate>
    ip->valid = 0;
    80003c52:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003c56:	854a                	mv	a0,s2
    80003c58:	4ab000ef          	jal	80004902 <releasesleep>
    acquire(&itable.lock);
    80003c5c:	0001d517          	auipc	a0,0x1d
    80003c60:	34450513          	addi	a0,a0,836 # 80020fa0 <itable>
    80003c64:	fc5fc0ef          	jal	80000c28 <acquire>
    80003c68:	6902                	ld	s2,0(sp)
    80003c6a:	bf61                	j	80003c02 <iput+0x20>

0000000080003c6c <iunlockput>:
{
    80003c6c:	1101                	addi	sp,sp,-32
    80003c6e:	ec06                	sd	ra,24(sp)
    80003c70:	e822                	sd	s0,16(sp)
    80003c72:	e426                	sd	s1,8(sp)
    80003c74:	1000                	addi	s0,sp,32
    80003c76:	84aa                	mv	s1,a0
  iunlock(ip);
    80003c78:	e97ff0ef          	jal	80003b0e <iunlock>
  iput(ip);
    80003c7c:	8526                	mv	a0,s1
    80003c7e:	f65ff0ef          	jal	80003be2 <iput>
}
    80003c82:	60e2                	ld	ra,24(sp)
    80003c84:	6442                	ld	s0,16(sp)
    80003c86:	64a2                	ld	s1,8(sp)
    80003c88:	6105                	addi	sp,sp,32
    80003c8a:	8082                	ret

0000000080003c8c <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003c8c:	0001d717          	auipc	a4,0x1d
    80003c90:	30072703          	lw	a4,768(a4) # 80020f8c <sb+0xc>
    80003c94:	4785                	li	a5,1
    80003c96:	0ae7fe63          	bgeu	a5,a4,80003d52 <ireclaim+0xc6>
{
    80003c9a:	7139                	addi	sp,sp,-64
    80003c9c:	fc06                	sd	ra,56(sp)
    80003c9e:	f822                	sd	s0,48(sp)
    80003ca0:	f426                	sd	s1,40(sp)
    80003ca2:	f04a                	sd	s2,32(sp)
    80003ca4:	ec4e                	sd	s3,24(sp)
    80003ca6:	e852                	sd	s4,16(sp)
    80003ca8:	e456                	sd	s5,8(sp)
    80003caa:	e05a                	sd	s6,0(sp)
    80003cac:	0080                	addi	s0,sp,64
    80003cae:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003cb0:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003cb2:	0001da17          	auipc	s4,0x1d
    80003cb6:	2cea0a13          	addi	s4,s4,718 # 80020f80 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003cba:	00005b17          	auipc	s6,0x5
    80003cbe:	996b0b13          	addi	s6,s6,-1642 # 80008650 <etext+0x650>
    80003cc2:	a099                	j	80003d08 <ireclaim+0x7c>
    80003cc4:	85ce                	mv	a1,s3
    80003cc6:	855a                	mv	a0,s6
    80003cc8:	833fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003ccc:	85ce                	mv	a1,s3
    80003cce:	8556                	mv	a0,s5
    80003cd0:	b1fff0ef          	jal	800037ee <iget>
    80003cd4:	89aa                	mv	s3,a0
    brelse(bp);
    80003cd6:	854a                	mv	a0,s2
    80003cd8:	ff8ff0ef          	jal	800034d0 <brelse>
    if (ip) {
    80003cdc:	00098f63          	beqz	s3,80003cfa <ireclaim+0x6e>
      begin_op();
    80003ce0:	78c000ef          	jal	8000446c <begin_op>
      ilock(ip);
    80003ce4:	854e                	mv	a0,s3
    80003ce6:	d7bff0ef          	jal	80003a60 <ilock>
      iunlock(ip);
    80003cea:	854e                	mv	a0,s3
    80003cec:	e23ff0ef          	jal	80003b0e <iunlock>
      iput(ip);
    80003cf0:	854e                	mv	a0,s3
    80003cf2:	ef1ff0ef          	jal	80003be2 <iput>
      end_op();
    80003cf6:	7e6000ef          	jal	800044dc <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003cfa:	0485                	addi	s1,s1,1
    80003cfc:	00ca2703          	lw	a4,12(s4)
    80003d00:	0004879b          	sext.w	a5,s1
    80003d04:	02e7fd63          	bgeu	a5,a4,80003d3e <ireclaim+0xb2>
    80003d08:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003d0c:	0044d593          	srli	a1,s1,0x4
    80003d10:	018a2783          	lw	a5,24(s4)
    80003d14:	9dbd                	addw	a1,a1,a5
    80003d16:	8556                	mv	a0,s5
    80003d18:	eb0ff0ef          	jal	800033c8 <bread>
    80003d1c:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003d1e:	05850793          	addi	a5,a0,88
    80003d22:	00f9f713          	andi	a4,s3,15
    80003d26:	071a                	slli	a4,a4,0x6
    80003d28:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003d2a:	00079703          	lh	a4,0(a5)
    80003d2e:	c701                	beqz	a4,80003d36 <ireclaim+0xaa>
    80003d30:	00679783          	lh	a5,6(a5)
    80003d34:	dbc1                	beqz	a5,80003cc4 <ireclaim+0x38>
    brelse(bp);
    80003d36:	854a                	mv	a0,s2
    80003d38:	f98ff0ef          	jal	800034d0 <brelse>
    if (ip) {
    80003d3c:	bf7d                	j	80003cfa <ireclaim+0x6e>
}
    80003d3e:	70e2                	ld	ra,56(sp)
    80003d40:	7442                	ld	s0,48(sp)
    80003d42:	74a2                	ld	s1,40(sp)
    80003d44:	7902                	ld	s2,32(sp)
    80003d46:	69e2                	ld	s3,24(sp)
    80003d48:	6a42                	ld	s4,16(sp)
    80003d4a:	6aa2                	ld	s5,8(sp)
    80003d4c:	6b02                	ld	s6,0(sp)
    80003d4e:	6121                	addi	sp,sp,64
    80003d50:	8082                	ret
    80003d52:	8082                	ret

0000000080003d54 <fsinit>:
fsinit(int dev) {
    80003d54:	1101                	addi	sp,sp,-32
    80003d56:	ec06                	sd	ra,24(sp)
    80003d58:	e822                	sd	s0,16(sp)
    80003d5a:	e426                	sd	s1,8(sp)
    80003d5c:	e04a                	sd	s2,0(sp)
    80003d5e:	1000                	addi	s0,sp,32
    80003d60:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003d62:	4585                	li	a1,1
    80003d64:	e64ff0ef          	jal	800033c8 <bread>
    80003d68:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003d6a:	02000613          	li	a2,32
    80003d6e:	05850593          	addi	a1,a0,88
    80003d72:	0001d517          	auipc	a0,0x1d
    80003d76:	20e50513          	addi	a0,a0,526 # 80020f80 <sb>
    80003d7a:	fdffc0ef          	jal	80000d58 <memmove>
  brelse(bp);
    80003d7e:	8526                	mv	a0,s1
    80003d80:	f50ff0ef          	jal	800034d0 <brelse>
  if(sb.magic != FSMAGIC)
    80003d84:	0001d717          	auipc	a4,0x1d
    80003d88:	1fc72703          	lw	a4,508(a4) # 80020f80 <sb>
    80003d8c:	102037b7          	lui	a5,0x10203
    80003d90:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003d94:	02f71263          	bne	a4,a5,80003db8 <fsinit+0x64>
  initlog(dev, &sb);
    80003d98:	0001d597          	auipc	a1,0x1d
    80003d9c:	1e858593          	addi	a1,a1,488 # 80020f80 <sb>
    80003da0:	854a                	mv	a0,s2
    80003da2:	648000ef          	jal	800043ea <initlog>
  ireclaim(dev);
    80003da6:	854a                	mv	a0,s2
    80003da8:	ee5ff0ef          	jal	80003c8c <ireclaim>
}
    80003dac:	60e2                	ld	ra,24(sp)
    80003dae:	6442                	ld	s0,16(sp)
    80003db0:	64a2                	ld	s1,8(sp)
    80003db2:	6902                	ld	s2,0(sp)
    80003db4:	6105                	addi	sp,sp,32
    80003db6:	8082                	ret
    panic("invalid file system");
    80003db8:	00005517          	auipc	a0,0x5
    80003dbc:	8b850513          	addi	a0,a0,-1864 # 80008670 <etext+0x670>
    80003dc0:	a65fc0ef          	jal	80000824 <panic>

0000000080003dc4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003dc4:	1141                	addi	sp,sp,-16
    80003dc6:	e406                	sd	ra,8(sp)
    80003dc8:	e022                	sd	s0,0(sp)
    80003dca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003dcc:	411c                	lw	a5,0(a0)
    80003dce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003dd0:	415c                	lw	a5,4(a0)
    80003dd2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003dd4:	04451783          	lh	a5,68(a0)
    80003dd8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003ddc:	04a51783          	lh	a5,74(a0)
    80003de0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003de4:	04c56783          	lwu	a5,76(a0)
    80003de8:	e99c                	sd	a5,16(a1)
}
    80003dea:	60a2                	ld	ra,8(sp)
    80003dec:	6402                	ld	s0,0(sp)
    80003dee:	0141                	addi	sp,sp,16
    80003df0:	8082                	ret

0000000080003df2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003df2:	457c                	lw	a5,76(a0)
    80003df4:	0ed7e663          	bltu	a5,a3,80003ee0 <readi+0xee>
{
    80003df8:	7159                	addi	sp,sp,-112
    80003dfa:	f486                	sd	ra,104(sp)
    80003dfc:	f0a2                	sd	s0,96(sp)
    80003dfe:	eca6                	sd	s1,88(sp)
    80003e00:	e0d2                	sd	s4,64(sp)
    80003e02:	fc56                	sd	s5,56(sp)
    80003e04:	f85a                	sd	s6,48(sp)
    80003e06:	f45e                	sd	s7,40(sp)
    80003e08:	1880                	addi	s0,sp,112
    80003e0a:	8b2a                	mv	s6,a0
    80003e0c:	8bae                	mv	s7,a1
    80003e0e:	8a32                	mv	s4,a2
    80003e10:	84b6                	mv	s1,a3
    80003e12:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003e14:	9f35                	addw	a4,a4,a3
    return 0;
    80003e16:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003e18:	0ad76b63          	bltu	a4,a3,80003ece <readi+0xdc>
    80003e1c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003e1e:	00e7f463          	bgeu	a5,a4,80003e26 <readi+0x34>
    n = ip->size - off;
    80003e22:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e26:	080a8b63          	beqz	s5,80003ebc <readi+0xca>
    80003e2a:	e8ca                	sd	s2,80(sp)
    80003e2c:	f062                	sd	s8,32(sp)
    80003e2e:	ec66                	sd	s9,24(sp)
    80003e30:	e86a                	sd	s10,16(sp)
    80003e32:	e46e                	sd	s11,8(sp)
    80003e34:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e36:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003e3a:	5c7d                	li	s8,-1
    80003e3c:	a80d                	j	80003e6e <readi+0x7c>
    80003e3e:	020d1d93          	slli	s11,s10,0x20
    80003e42:	020ddd93          	srli	s11,s11,0x20
    80003e46:	05890613          	addi	a2,s2,88
    80003e4a:	86ee                	mv	a3,s11
    80003e4c:	963e                	add	a2,a2,a5
    80003e4e:	85d2                	mv	a1,s4
    80003e50:	855e                	mv	a0,s7
    80003e52:	e34fe0ef          	jal	80002486 <either_copyout>
    80003e56:	05850363          	beq	a0,s8,80003e9c <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003e5a:	854a                	mv	a0,s2
    80003e5c:	e74ff0ef          	jal	800034d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e60:	013d09bb          	addw	s3,s10,s3
    80003e64:	009d04bb          	addw	s1,s10,s1
    80003e68:	9a6e                	add	s4,s4,s11
    80003e6a:	0559f363          	bgeu	s3,s5,80003eb0 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003e6e:	00a4d59b          	srliw	a1,s1,0xa
    80003e72:	855a                	mv	a0,s6
    80003e74:	8bbff0ef          	jal	8000372e <bmap>
    80003e78:	85aa                	mv	a1,a0
    if(addr == 0)
    80003e7a:	c139                	beqz	a0,80003ec0 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003e7c:	000b2503          	lw	a0,0(s6)
    80003e80:	d48ff0ef          	jal	800033c8 <bread>
    80003e84:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e86:	3ff4f793          	andi	a5,s1,1023
    80003e8a:	40fc873b          	subw	a4,s9,a5
    80003e8e:	413a86bb          	subw	a3,s5,s3
    80003e92:	8d3a                	mv	s10,a4
    80003e94:	fae6f5e3          	bgeu	a3,a4,80003e3e <readi+0x4c>
    80003e98:	8d36                	mv	s10,a3
    80003e9a:	b755                	j	80003e3e <readi+0x4c>
      brelse(bp);
    80003e9c:	854a                	mv	a0,s2
    80003e9e:	e32ff0ef          	jal	800034d0 <brelse>
      tot = -1;
    80003ea2:	59fd                	li	s3,-1
      break;
    80003ea4:	6946                	ld	s2,80(sp)
    80003ea6:	7c02                	ld	s8,32(sp)
    80003ea8:	6ce2                	ld	s9,24(sp)
    80003eaa:	6d42                	ld	s10,16(sp)
    80003eac:	6da2                	ld	s11,8(sp)
    80003eae:	a831                	j	80003eca <readi+0xd8>
    80003eb0:	6946                	ld	s2,80(sp)
    80003eb2:	7c02                	ld	s8,32(sp)
    80003eb4:	6ce2                	ld	s9,24(sp)
    80003eb6:	6d42                	ld	s10,16(sp)
    80003eb8:	6da2                	ld	s11,8(sp)
    80003eba:	a801                	j	80003eca <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ebc:	89d6                	mv	s3,s5
    80003ebe:	a031                	j	80003eca <readi+0xd8>
    80003ec0:	6946                	ld	s2,80(sp)
    80003ec2:	7c02                	ld	s8,32(sp)
    80003ec4:	6ce2                	ld	s9,24(sp)
    80003ec6:	6d42                	ld	s10,16(sp)
    80003ec8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003eca:	854e                	mv	a0,s3
    80003ecc:	69a6                	ld	s3,72(sp)
}
    80003ece:	70a6                	ld	ra,104(sp)
    80003ed0:	7406                	ld	s0,96(sp)
    80003ed2:	64e6                	ld	s1,88(sp)
    80003ed4:	6a06                	ld	s4,64(sp)
    80003ed6:	7ae2                	ld	s5,56(sp)
    80003ed8:	7b42                	ld	s6,48(sp)
    80003eda:	7ba2                	ld	s7,40(sp)
    80003edc:	6165                	addi	sp,sp,112
    80003ede:	8082                	ret
    return 0;
    80003ee0:	4501                	li	a0,0
}
    80003ee2:	8082                	ret

0000000080003ee4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ee4:	457c                	lw	a5,76(a0)
    80003ee6:	0ed7eb63          	bltu	a5,a3,80003fdc <writei+0xf8>
{
    80003eea:	7159                	addi	sp,sp,-112
    80003eec:	f486                	sd	ra,104(sp)
    80003eee:	f0a2                	sd	s0,96(sp)
    80003ef0:	e8ca                	sd	s2,80(sp)
    80003ef2:	e0d2                	sd	s4,64(sp)
    80003ef4:	fc56                	sd	s5,56(sp)
    80003ef6:	f85a                	sd	s6,48(sp)
    80003ef8:	f45e                	sd	s7,40(sp)
    80003efa:	1880                	addi	s0,sp,112
    80003efc:	8aaa                	mv	s5,a0
    80003efe:	8bae                	mv	s7,a1
    80003f00:	8a32                	mv	s4,a2
    80003f02:	8936                	mv	s2,a3
    80003f04:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003f06:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003f0a:	00043737          	lui	a4,0x43
    80003f0e:	0cf76963          	bltu	a4,a5,80003fe0 <writei+0xfc>
    80003f12:	0cd7e763          	bltu	a5,a3,80003fe0 <writei+0xfc>
    80003f16:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f18:	0a0b0a63          	beqz	s6,80003fcc <writei+0xe8>
    80003f1c:	eca6                	sd	s1,88(sp)
    80003f1e:	f062                	sd	s8,32(sp)
    80003f20:	ec66                	sd	s9,24(sp)
    80003f22:	e86a                	sd	s10,16(sp)
    80003f24:	e46e                	sd	s11,8(sp)
    80003f26:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f28:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003f2c:	5c7d                	li	s8,-1
    80003f2e:	a825                	j	80003f66 <writei+0x82>
    80003f30:	020d1d93          	slli	s11,s10,0x20
    80003f34:	020ddd93          	srli	s11,s11,0x20
    80003f38:	05848513          	addi	a0,s1,88
    80003f3c:	86ee                	mv	a3,s11
    80003f3e:	8652                	mv	a2,s4
    80003f40:	85de                	mv	a1,s7
    80003f42:	953e                	add	a0,a0,a5
    80003f44:	d8cfe0ef          	jal	800024d0 <either_copyin>
    80003f48:	05850663          	beq	a0,s8,80003f94 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	6b8000ef          	jal	80004606 <log_write>
    brelse(bp);
    80003f52:	8526                	mv	a0,s1
    80003f54:	d7cff0ef          	jal	800034d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f58:	013d09bb          	addw	s3,s10,s3
    80003f5c:	012d093b          	addw	s2,s10,s2
    80003f60:	9a6e                	add	s4,s4,s11
    80003f62:	0369fc63          	bgeu	s3,s6,80003f9a <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003f66:	00a9559b          	srliw	a1,s2,0xa
    80003f6a:	8556                	mv	a0,s5
    80003f6c:	fc2ff0ef          	jal	8000372e <bmap>
    80003f70:	85aa                	mv	a1,a0
    if(addr == 0)
    80003f72:	c505                	beqz	a0,80003f9a <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003f74:	000aa503          	lw	a0,0(s5)
    80003f78:	c50ff0ef          	jal	800033c8 <bread>
    80003f7c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f7e:	3ff97793          	andi	a5,s2,1023
    80003f82:	40fc873b          	subw	a4,s9,a5
    80003f86:	413b06bb          	subw	a3,s6,s3
    80003f8a:	8d3a                	mv	s10,a4
    80003f8c:	fae6f2e3          	bgeu	a3,a4,80003f30 <writei+0x4c>
    80003f90:	8d36                	mv	s10,a3
    80003f92:	bf79                	j	80003f30 <writei+0x4c>
      brelse(bp);
    80003f94:	8526                	mv	a0,s1
    80003f96:	d3aff0ef          	jal	800034d0 <brelse>
  }

  if(off > ip->size)
    80003f9a:	04caa783          	lw	a5,76(s5)
    80003f9e:	0327f963          	bgeu	a5,s2,80003fd0 <writei+0xec>
    ip->size = off;
    80003fa2:	052aa623          	sw	s2,76(s5)
    80003fa6:	64e6                	ld	s1,88(sp)
    80003fa8:	7c02                	ld	s8,32(sp)
    80003faa:	6ce2                	ld	s9,24(sp)
    80003fac:	6d42                	ld	s10,16(sp)
    80003fae:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003fb0:	8556                	mv	a0,s5
    80003fb2:	9fbff0ef          	jal	800039ac <iupdate>

  return tot;
    80003fb6:	854e                	mv	a0,s3
    80003fb8:	69a6                	ld	s3,72(sp)
}
    80003fba:	70a6                	ld	ra,104(sp)
    80003fbc:	7406                	ld	s0,96(sp)
    80003fbe:	6946                	ld	s2,80(sp)
    80003fc0:	6a06                	ld	s4,64(sp)
    80003fc2:	7ae2                	ld	s5,56(sp)
    80003fc4:	7b42                	ld	s6,48(sp)
    80003fc6:	7ba2                	ld	s7,40(sp)
    80003fc8:	6165                	addi	sp,sp,112
    80003fca:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fcc:	89da                	mv	s3,s6
    80003fce:	b7cd                	j	80003fb0 <writei+0xcc>
    80003fd0:	64e6                	ld	s1,88(sp)
    80003fd2:	7c02                	ld	s8,32(sp)
    80003fd4:	6ce2                	ld	s9,24(sp)
    80003fd6:	6d42                	ld	s10,16(sp)
    80003fd8:	6da2                	ld	s11,8(sp)
    80003fda:	bfd9                	j	80003fb0 <writei+0xcc>
    return -1;
    80003fdc:	557d                	li	a0,-1
}
    80003fde:	8082                	ret
    return -1;
    80003fe0:	557d                	li	a0,-1
    80003fe2:	bfe1                	j	80003fba <writei+0xd6>

0000000080003fe4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003fe4:	1141                	addi	sp,sp,-16
    80003fe6:	e406                	sd	ra,8(sp)
    80003fe8:	e022                	sd	s0,0(sp)
    80003fea:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003fec:	4639                	li	a2,14
    80003fee:	ddffc0ef          	jal	80000dcc <strncmp>
}
    80003ff2:	60a2                	ld	ra,8(sp)
    80003ff4:	6402                	ld	s0,0(sp)
    80003ff6:	0141                	addi	sp,sp,16
    80003ff8:	8082                	ret

0000000080003ffa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ffa:	711d                	addi	sp,sp,-96
    80003ffc:	ec86                	sd	ra,88(sp)
    80003ffe:	e8a2                	sd	s0,80(sp)
    80004000:	e4a6                	sd	s1,72(sp)
    80004002:	e0ca                	sd	s2,64(sp)
    80004004:	fc4e                	sd	s3,56(sp)
    80004006:	f852                	sd	s4,48(sp)
    80004008:	f456                	sd	s5,40(sp)
    8000400a:	f05a                	sd	s6,32(sp)
    8000400c:	ec5e                	sd	s7,24(sp)
    8000400e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004010:	04451703          	lh	a4,68(a0)
    80004014:	4785                	li	a5,1
    80004016:	00f71f63          	bne	a4,a5,80004034 <dirlookup+0x3a>
    8000401a:	892a                	mv	s2,a0
    8000401c:	8aae                	mv	s5,a1
    8000401e:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004020:	457c                	lw	a5,76(a0)
    80004022:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004024:	fa040a13          	addi	s4,s0,-96
    80004028:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000402a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000402e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004030:	e39d                	bnez	a5,80004056 <dirlookup+0x5c>
    80004032:	a8b9                	j	80004090 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80004034:	00004517          	auipc	a0,0x4
    80004038:	65450513          	addi	a0,a0,1620 # 80008688 <etext+0x688>
    8000403c:	fe8fc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    80004040:	00004517          	auipc	a0,0x4
    80004044:	66050513          	addi	a0,a0,1632 # 800086a0 <etext+0x6a0>
    80004048:	fdcfc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000404c:	24c1                	addiw	s1,s1,16
    8000404e:	04c92783          	lw	a5,76(s2)
    80004052:	02f4fe63          	bgeu	s1,a5,8000408e <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004056:	874e                	mv	a4,s3
    80004058:	86a6                	mv	a3,s1
    8000405a:	8652                	mv	a2,s4
    8000405c:	4581                	li	a1,0
    8000405e:	854a                	mv	a0,s2
    80004060:	d93ff0ef          	jal	80003df2 <readi>
    80004064:	fd351ee3          	bne	a0,s3,80004040 <dirlookup+0x46>
    if(de.inum == 0)
    80004068:	fa045783          	lhu	a5,-96(s0)
    8000406c:	d3e5                	beqz	a5,8000404c <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    8000406e:	85da                	mv	a1,s6
    80004070:	8556                	mv	a0,s5
    80004072:	f73ff0ef          	jal	80003fe4 <namecmp>
    80004076:	f979                	bnez	a0,8000404c <dirlookup+0x52>
      if(poff)
    80004078:	000b8463          	beqz	s7,80004080 <dirlookup+0x86>
        *poff = off;
    8000407c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80004080:	fa045583          	lhu	a1,-96(s0)
    80004084:	00092503          	lw	a0,0(s2)
    80004088:	f66ff0ef          	jal	800037ee <iget>
    8000408c:	a011                	j	80004090 <dirlookup+0x96>
  return 0;
    8000408e:	4501                	li	a0,0
}
    80004090:	60e6                	ld	ra,88(sp)
    80004092:	6446                	ld	s0,80(sp)
    80004094:	64a6                	ld	s1,72(sp)
    80004096:	6906                	ld	s2,64(sp)
    80004098:	79e2                	ld	s3,56(sp)
    8000409a:	7a42                	ld	s4,48(sp)
    8000409c:	7aa2                	ld	s5,40(sp)
    8000409e:	7b02                	ld	s6,32(sp)
    800040a0:	6be2                	ld	s7,24(sp)
    800040a2:	6125                	addi	sp,sp,96
    800040a4:	8082                	ret

00000000800040a6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800040a6:	711d                	addi	sp,sp,-96
    800040a8:	ec86                	sd	ra,88(sp)
    800040aa:	e8a2                	sd	s0,80(sp)
    800040ac:	e4a6                	sd	s1,72(sp)
    800040ae:	e0ca                	sd	s2,64(sp)
    800040b0:	fc4e                	sd	s3,56(sp)
    800040b2:	f852                	sd	s4,48(sp)
    800040b4:	f456                	sd	s5,40(sp)
    800040b6:	f05a                	sd	s6,32(sp)
    800040b8:	ec5e                	sd	s7,24(sp)
    800040ba:	e862                	sd	s8,16(sp)
    800040bc:	e466                	sd	s9,8(sp)
    800040be:	e06a                	sd	s10,0(sp)
    800040c0:	1080                	addi	s0,sp,96
    800040c2:	84aa                	mv	s1,a0
    800040c4:	8b2e                	mv	s6,a1
    800040c6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800040c8:	00054703          	lbu	a4,0(a0)
    800040cc:	02f00793          	li	a5,47
    800040d0:	00f70f63          	beq	a4,a5,800040ee <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800040d4:	843fd0ef          	jal	80001916 <myproc>
    800040d8:	15053503          	ld	a0,336(a0)
    800040dc:	94fff0ef          	jal	80003a2a <idup>
    800040e0:	8a2a                	mv	s4,a0
  while(*path == '/')
    800040e2:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    800040e6:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800040e8:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800040ea:	4b85                	li	s7,1
    800040ec:	a879                	j	8000418a <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    800040ee:	4585                	li	a1,1
    800040f0:	852e                	mv	a0,a1
    800040f2:	efcff0ef          	jal	800037ee <iget>
    800040f6:	8a2a                	mv	s4,a0
    800040f8:	b7ed                	j	800040e2 <namex+0x3c>
      iunlockput(ip);
    800040fa:	8552                	mv	a0,s4
    800040fc:	b71ff0ef          	jal	80003c6c <iunlockput>
      return 0;
    80004100:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004102:	8552                	mv	a0,s4
    80004104:	60e6                	ld	ra,88(sp)
    80004106:	6446                	ld	s0,80(sp)
    80004108:	64a6                	ld	s1,72(sp)
    8000410a:	6906                	ld	s2,64(sp)
    8000410c:	79e2                	ld	s3,56(sp)
    8000410e:	7a42                	ld	s4,48(sp)
    80004110:	7aa2                	ld	s5,40(sp)
    80004112:	7b02                	ld	s6,32(sp)
    80004114:	6be2                	ld	s7,24(sp)
    80004116:	6c42                	ld	s8,16(sp)
    80004118:	6ca2                	ld	s9,8(sp)
    8000411a:	6d02                	ld	s10,0(sp)
    8000411c:	6125                	addi	sp,sp,96
    8000411e:	8082                	ret
      iunlock(ip);
    80004120:	8552                	mv	a0,s4
    80004122:	9edff0ef          	jal	80003b0e <iunlock>
      return ip;
    80004126:	bff1                	j	80004102 <namex+0x5c>
      iunlockput(ip);
    80004128:	8552                	mv	a0,s4
    8000412a:	b43ff0ef          	jal	80003c6c <iunlockput>
      return 0;
    8000412e:	8a4a                	mv	s4,s2
    80004130:	bfc9                	j	80004102 <namex+0x5c>
  len = path - s;
    80004132:	40990633          	sub	a2,s2,s1
    80004136:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000413a:	09ac5463          	bge	s8,s10,800041c2 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    8000413e:	8666                	mv	a2,s9
    80004140:	85a6                	mv	a1,s1
    80004142:	8556                	mv	a0,s5
    80004144:	c15fc0ef          	jal	80000d58 <memmove>
    80004148:	84ca                	mv	s1,s2
  while(*path == '/')
    8000414a:	0004c783          	lbu	a5,0(s1)
    8000414e:	01379763          	bne	a5,s3,8000415c <namex+0xb6>
    path++;
    80004152:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004154:	0004c783          	lbu	a5,0(s1)
    80004158:	ff378de3          	beq	a5,s3,80004152 <namex+0xac>
    ilock(ip);
    8000415c:	8552                	mv	a0,s4
    8000415e:	903ff0ef          	jal	80003a60 <ilock>
    if(ip->type != T_DIR){
    80004162:	044a1783          	lh	a5,68(s4)
    80004166:	f9779ae3          	bne	a5,s7,800040fa <namex+0x54>
    if(nameiparent && *path == '\0'){
    8000416a:	000b0563          	beqz	s6,80004174 <namex+0xce>
    8000416e:	0004c783          	lbu	a5,0(s1)
    80004172:	d7dd                	beqz	a5,80004120 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004174:	4601                	li	a2,0
    80004176:	85d6                	mv	a1,s5
    80004178:	8552                	mv	a0,s4
    8000417a:	e81ff0ef          	jal	80003ffa <dirlookup>
    8000417e:	892a                	mv	s2,a0
    80004180:	d545                	beqz	a0,80004128 <namex+0x82>
    iunlockput(ip);
    80004182:	8552                	mv	a0,s4
    80004184:	ae9ff0ef          	jal	80003c6c <iunlockput>
    ip = next;
    80004188:	8a4a                	mv	s4,s2
  while(*path == '/')
    8000418a:	0004c783          	lbu	a5,0(s1)
    8000418e:	01379763          	bne	a5,s3,8000419c <namex+0xf6>
    path++;
    80004192:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004194:	0004c783          	lbu	a5,0(s1)
    80004198:	ff378de3          	beq	a5,s3,80004192 <namex+0xec>
  if(*path == 0)
    8000419c:	cf8d                	beqz	a5,800041d6 <namex+0x130>
  while(*path != '/' && *path != 0)
    8000419e:	0004c783          	lbu	a5,0(s1)
    800041a2:	fd178713          	addi	a4,a5,-47
    800041a6:	cb19                	beqz	a4,800041bc <namex+0x116>
    800041a8:	cb91                	beqz	a5,800041bc <namex+0x116>
    800041aa:	8926                	mv	s2,s1
    path++;
    800041ac:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    800041ae:	00094783          	lbu	a5,0(s2)
    800041b2:	fd178713          	addi	a4,a5,-47
    800041b6:	df35                	beqz	a4,80004132 <namex+0x8c>
    800041b8:	fbf5                	bnez	a5,800041ac <namex+0x106>
    800041ba:	bfa5                	j	80004132 <namex+0x8c>
    800041bc:	8926                	mv	s2,s1
  len = path - s;
    800041be:	4d01                	li	s10,0
    800041c0:	4601                	li	a2,0
    memmove(name, s, len);
    800041c2:	2601                	sext.w	a2,a2
    800041c4:	85a6                	mv	a1,s1
    800041c6:	8556                	mv	a0,s5
    800041c8:	b91fc0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    800041cc:	9d56                	add	s10,s10,s5
    800041ce:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdb378>
    800041d2:	84ca                	mv	s1,s2
    800041d4:	bf9d                	j	8000414a <namex+0xa4>
  if(nameiparent){
    800041d6:	f20b06e3          	beqz	s6,80004102 <namex+0x5c>
    iput(ip);
    800041da:	8552                	mv	a0,s4
    800041dc:	a07ff0ef          	jal	80003be2 <iput>
    return 0;
    800041e0:	4a01                	li	s4,0
    800041e2:	b705                	j	80004102 <namex+0x5c>

00000000800041e4 <dirlink>:
{
    800041e4:	715d                	addi	sp,sp,-80
    800041e6:	e486                	sd	ra,72(sp)
    800041e8:	e0a2                	sd	s0,64(sp)
    800041ea:	f84a                	sd	s2,48(sp)
    800041ec:	ec56                	sd	s5,24(sp)
    800041ee:	e85a                	sd	s6,16(sp)
    800041f0:	0880                	addi	s0,sp,80
    800041f2:	892a                	mv	s2,a0
    800041f4:	8aae                	mv	s5,a1
    800041f6:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800041f8:	4601                	li	a2,0
    800041fa:	e01ff0ef          	jal	80003ffa <dirlookup>
    800041fe:	ed1d                	bnez	a0,8000423c <dirlink+0x58>
    80004200:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004202:	04c92483          	lw	s1,76(s2)
    80004206:	c4b9                	beqz	s1,80004254 <dirlink+0x70>
    80004208:	f44e                	sd	s3,40(sp)
    8000420a:	f052                	sd	s4,32(sp)
    8000420c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000420e:	fb040a13          	addi	s4,s0,-80
    80004212:	49c1                	li	s3,16
    80004214:	874e                	mv	a4,s3
    80004216:	86a6                	mv	a3,s1
    80004218:	8652                	mv	a2,s4
    8000421a:	4581                	li	a1,0
    8000421c:	854a                	mv	a0,s2
    8000421e:	bd5ff0ef          	jal	80003df2 <readi>
    80004222:	03351163          	bne	a0,s3,80004244 <dirlink+0x60>
    if(de.inum == 0)
    80004226:	fb045783          	lhu	a5,-80(s0)
    8000422a:	c39d                	beqz	a5,80004250 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000422c:	24c1                	addiw	s1,s1,16
    8000422e:	04c92783          	lw	a5,76(s2)
    80004232:	fef4e1e3          	bltu	s1,a5,80004214 <dirlink+0x30>
    80004236:	79a2                	ld	s3,40(sp)
    80004238:	7a02                	ld	s4,32(sp)
    8000423a:	a829                	j	80004254 <dirlink+0x70>
    iput(ip);
    8000423c:	9a7ff0ef          	jal	80003be2 <iput>
    return -1;
    80004240:	557d                	li	a0,-1
    80004242:	a83d                	j	80004280 <dirlink+0x9c>
      panic("dirlink read");
    80004244:	00004517          	auipc	a0,0x4
    80004248:	46c50513          	addi	a0,a0,1132 # 800086b0 <etext+0x6b0>
    8000424c:	dd8fc0ef          	jal	80000824 <panic>
    80004250:	79a2                	ld	s3,40(sp)
    80004252:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004254:	4639                	li	a2,14
    80004256:	85d6                	mv	a1,s5
    80004258:	fb240513          	addi	a0,s0,-78
    8000425c:	babfc0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    80004260:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004264:	4741                	li	a4,16
    80004266:	86a6                	mv	a3,s1
    80004268:	fb040613          	addi	a2,s0,-80
    8000426c:	4581                	li	a1,0
    8000426e:	854a                	mv	a0,s2
    80004270:	c75ff0ef          	jal	80003ee4 <writei>
    80004274:	1541                	addi	a0,a0,-16
    80004276:	00a03533          	snez	a0,a0
    8000427a:	40a0053b          	negw	a0,a0
    8000427e:	74e2                	ld	s1,56(sp)
}
    80004280:	60a6                	ld	ra,72(sp)
    80004282:	6406                	ld	s0,64(sp)
    80004284:	7942                	ld	s2,48(sp)
    80004286:	6ae2                	ld	s5,24(sp)
    80004288:	6b42                	ld	s6,16(sp)
    8000428a:	6161                	addi	sp,sp,80
    8000428c:	8082                	ret

000000008000428e <namei>:

struct inode*
namei(char *path)
{
    8000428e:	1101                	addi	sp,sp,-32
    80004290:	ec06                	sd	ra,24(sp)
    80004292:	e822                	sd	s0,16(sp)
    80004294:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004296:	fe040613          	addi	a2,s0,-32
    8000429a:	4581                	li	a1,0
    8000429c:	e0bff0ef          	jal	800040a6 <namex>
}
    800042a0:	60e2                	ld	ra,24(sp)
    800042a2:	6442                	ld	s0,16(sp)
    800042a4:	6105                	addi	sp,sp,32
    800042a6:	8082                	ret

00000000800042a8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800042a8:	1141                	addi	sp,sp,-16
    800042aa:	e406                	sd	ra,8(sp)
    800042ac:	e022                	sd	s0,0(sp)
    800042ae:	0800                	addi	s0,sp,16
    800042b0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800042b2:	4585                	li	a1,1
    800042b4:	df3ff0ef          	jal	800040a6 <namex>
}
    800042b8:	60a2                	ld	ra,8(sp)
    800042ba:	6402                	ld	s0,0(sp)
    800042bc:	0141                	addi	sp,sp,16
    800042be:	8082                	ret

00000000800042c0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800042c0:	1101                	addi	sp,sp,-32
    800042c2:	ec06                	sd	ra,24(sp)
    800042c4:	e822                	sd	s0,16(sp)
    800042c6:	e426                	sd	s1,8(sp)
    800042c8:	e04a                	sd	s2,0(sp)
    800042ca:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800042cc:	0001e917          	auipc	s2,0x1e
    800042d0:	77c90913          	addi	s2,s2,1916 # 80022a48 <log>
    800042d4:	01892583          	lw	a1,24(s2)
    800042d8:	02492503          	lw	a0,36(s2)
    800042dc:	8ecff0ef          	jal	800033c8 <bread>
    800042e0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800042e2:	02892603          	lw	a2,40(s2)
    800042e6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800042e8:	00c05f63          	blez	a2,80004306 <write_head+0x46>
    800042ec:	0001e717          	auipc	a4,0x1e
    800042f0:	78870713          	addi	a4,a4,1928 # 80022a74 <log+0x2c>
    800042f4:	87aa                	mv	a5,a0
    800042f6:	060a                	slli	a2,a2,0x2
    800042f8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800042fa:	4314                	lw	a3,0(a4)
    800042fc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800042fe:	0711                	addi	a4,a4,4
    80004300:	0791                	addi	a5,a5,4
    80004302:	fec79ce3          	bne	a5,a2,800042fa <write_head+0x3a>
  }
  bwrite(buf);
    80004306:	8526                	mv	a0,s1
    80004308:	996ff0ef          	jal	8000349e <bwrite>
  brelse(buf);
    8000430c:	8526                	mv	a0,s1
    8000430e:	9c2ff0ef          	jal	800034d0 <brelse>
}
    80004312:	60e2                	ld	ra,24(sp)
    80004314:	6442                	ld	s0,16(sp)
    80004316:	64a2                	ld	s1,8(sp)
    80004318:	6902                	ld	s2,0(sp)
    8000431a:	6105                	addi	sp,sp,32
    8000431c:	8082                	ret

000000008000431e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000431e:	0001e797          	auipc	a5,0x1e
    80004322:	7527a783          	lw	a5,1874(a5) # 80022a70 <log+0x28>
    80004326:	0cf05163          	blez	a5,800043e8 <install_trans+0xca>
{
    8000432a:	715d                	addi	sp,sp,-80
    8000432c:	e486                	sd	ra,72(sp)
    8000432e:	e0a2                	sd	s0,64(sp)
    80004330:	fc26                	sd	s1,56(sp)
    80004332:	f84a                	sd	s2,48(sp)
    80004334:	f44e                	sd	s3,40(sp)
    80004336:	f052                	sd	s4,32(sp)
    80004338:	ec56                	sd	s5,24(sp)
    8000433a:	e85a                	sd	s6,16(sp)
    8000433c:	e45e                	sd	s7,8(sp)
    8000433e:	e062                	sd	s8,0(sp)
    80004340:	0880                	addi	s0,sp,80
    80004342:	8b2a                	mv	s6,a0
    80004344:	0001ea97          	auipc	s5,0x1e
    80004348:	730a8a93          	addi	s5,s5,1840 # 80022a74 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000434c:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000434e:	00004c17          	auipc	s8,0x4
    80004352:	372c0c13          	addi	s8,s8,882 # 800086c0 <etext+0x6c0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004356:	0001ea17          	auipc	s4,0x1e
    8000435a:	6f2a0a13          	addi	s4,s4,1778 # 80022a48 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000435e:	40000b93          	li	s7,1024
    80004362:	a025                	j	8000438a <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80004364:	000aa603          	lw	a2,0(s5)
    80004368:	85ce                	mv	a1,s3
    8000436a:	8562                	mv	a0,s8
    8000436c:	98efc0ef          	jal	800004fa <printf>
    80004370:	a839                	j	8000438e <install_trans+0x70>
    brelse(lbuf);
    80004372:	854a                	mv	a0,s2
    80004374:	95cff0ef          	jal	800034d0 <brelse>
    brelse(dbuf);
    80004378:	8526                	mv	a0,s1
    8000437a:	956ff0ef          	jal	800034d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000437e:	2985                	addiw	s3,s3,1
    80004380:	0a91                	addi	s5,s5,4
    80004382:	028a2783          	lw	a5,40(s4)
    80004386:	04f9d563          	bge	s3,a5,800043d0 <install_trans+0xb2>
    if(recovering) {
    8000438a:	fc0b1de3          	bnez	s6,80004364 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000438e:	018a2583          	lw	a1,24(s4)
    80004392:	013585bb          	addw	a1,a1,s3
    80004396:	2585                	addiw	a1,a1,1
    80004398:	024a2503          	lw	a0,36(s4)
    8000439c:	82cff0ef          	jal	800033c8 <bread>
    800043a0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800043a2:	000aa583          	lw	a1,0(s5)
    800043a6:	024a2503          	lw	a0,36(s4)
    800043aa:	81eff0ef          	jal	800033c8 <bread>
    800043ae:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800043b0:	865e                	mv	a2,s7
    800043b2:	05890593          	addi	a1,s2,88
    800043b6:	05850513          	addi	a0,a0,88
    800043ba:	99ffc0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    800043be:	8526                	mv	a0,s1
    800043c0:	8deff0ef          	jal	8000349e <bwrite>
    if(recovering == 0)
    800043c4:	fa0b17e3          	bnez	s6,80004372 <install_trans+0x54>
      bunpin(dbuf);
    800043c8:	8526                	mv	a0,s1
    800043ca:	9beff0ef          	jal	80003588 <bunpin>
    800043ce:	b755                	j	80004372 <install_trans+0x54>
}
    800043d0:	60a6                	ld	ra,72(sp)
    800043d2:	6406                	ld	s0,64(sp)
    800043d4:	74e2                	ld	s1,56(sp)
    800043d6:	7942                	ld	s2,48(sp)
    800043d8:	79a2                	ld	s3,40(sp)
    800043da:	7a02                	ld	s4,32(sp)
    800043dc:	6ae2                	ld	s5,24(sp)
    800043de:	6b42                	ld	s6,16(sp)
    800043e0:	6ba2                	ld	s7,8(sp)
    800043e2:	6c02                	ld	s8,0(sp)
    800043e4:	6161                	addi	sp,sp,80
    800043e6:	8082                	ret
    800043e8:	8082                	ret

00000000800043ea <initlog>:
{
    800043ea:	7179                	addi	sp,sp,-48
    800043ec:	f406                	sd	ra,40(sp)
    800043ee:	f022                	sd	s0,32(sp)
    800043f0:	ec26                	sd	s1,24(sp)
    800043f2:	e84a                	sd	s2,16(sp)
    800043f4:	e44e                	sd	s3,8(sp)
    800043f6:	1800                	addi	s0,sp,48
    800043f8:	84aa                	mv	s1,a0
    800043fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800043fc:	0001e917          	auipc	s2,0x1e
    80004400:	64c90913          	addi	s2,s2,1612 # 80022a48 <log>
    80004404:	00004597          	auipc	a1,0x4
    80004408:	2dc58593          	addi	a1,a1,732 # 800086e0 <etext+0x6e0>
    8000440c:	854a                	mv	a0,s2
    8000440e:	f90fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    80004412:	0149a583          	lw	a1,20(s3)
    80004416:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    8000441a:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    8000441e:	8526                	mv	a0,s1
    80004420:	fa9fe0ef          	jal	800033c8 <bread>
  log.lh.n = lh->n;
    80004424:	4d30                	lw	a2,88(a0)
    80004426:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    8000442a:	00c05f63          	blez	a2,80004448 <initlog+0x5e>
    8000442e:	87aa                	mv	a5,a0
    80004430:	0001e717          	auipc	a4,0x1e
    80004434:	64470713          	addi	a4,a4,1604 # 80022a74 <log+0x2c>
    80004438:	060a                	slli	a2,a2,0x2
    8000443a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000443c:	4ff4                	lw	a3,92(a5)
    8000443e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004440:	0791                	addi	a5,a5,4
    80004442:	0711                	addi	a4,a4,4
    80004444:	fec79ce3          	bne	a5,a2,8000443c <initlog+0x52>
  brelse(buf);
    80004448:	888ff0ef          	jal	800034d0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000444c:	4505                	li	a0,1
    8000444e:	ed1ff0ef          	jal	8000431e <install_trans>
  log.lh.n = 0;
    80004452:	0001e797          	auipc	a5,0x1e
    80004456:	6007af23          	sw	zero,1566(a5) # 80022a70 <log+0x28>
  write_head(); // clear the log
    8000445a:	e67ff0ef          	jal	800042c0 <write_head>
}
    8000445e:	70a2                	ld	ra,40(sp)
    80004460:	7402                	ld	s0,32(sp)
    80004462:	64e2                	ld	s1,24(sp)
    80004464:	6942                	ld	s2,16(sp)
    80004466:	69a2                	ld	s3,8(sp)
    80004468:	6145                	addi	sp,sp,48
    8000446a:	8082                	ret

000000008000446c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000446c:	1101                	addi	sp,sp,-32
    8000446e:	ec06                	sd	ra,24(sp)
    80004470:	e822                	sd	s0,16(sp)
    80004472:	e426                	sd	s1,8(sp)
    80004474:	e04a                	sd	s2,0(sp)
    80004476:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004478:	0001e517          	auipc	a0,0x1e
    8000447c:	5d050513          	addi	a0,a0,1488 # 80022a48 <log>
    80004480:	fa8fc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    80004484:	0001e497          	auipc	s1,0x1e
    80004488:	5c448493          	addi	s1,s1,1476 # 80022a48 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    8000448c:	4979                	li	s2,30
    8000448e:	a029                	j	80004498 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80004490:	85a6                	mv	a1,s1
    80004492:	8526                	mv	a0,s1
    80004494:	c87fd0ef          	jal	8000211a <sleep>
    if(log.committing){
    80004498:	509c                	lw	a5,32(s1)
    8000449a:	fbfd                	bnez	a5,80004490 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    8000449c:	4cd8                	lw	a4,28(s1)
    8000449e:	2705                	addiw	a4,a4,1
    800044a0:	0027179b          	slliw	a5,a4,0x2
    800044a4:	9fb9                	addw	a5,a5,a4
    800044a6:	0017979b          	slliw	a5,a5,0x1
    800044aa:	5494                	lw	a3,40(s1)
    800044ac:	9fb5                	addw	a5,a5,a3
    800044ae:	00f95763          	bge	s2,a5,800044bc <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800044b2:	85a6                	mv	a1,s1
    800044b4:	8526                	mv	a0,s1
    800044b6:	c65fd0ef          	jal	8000211a <sleep>
    800044ba:	bff9                	j	80004498 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800044bc:	0001e797          	auipc	a5,0x1e
    800044c0:	5ae7a423          	sw	a4,1448(a5) # 80022a64 <log+0x1c>
      release(&log.lock);
    800044c4:	0001e517          	auipc	a0,0x1e
    800044c8:	58450513          	addi	a0,a0,1412 # 80022a48 <log>
    800044cc:	ff0fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    800044d0:	60e2                	ld	ra,24(sp)
    800044d2:	6442                	ld	s0,16(sp)
    800044d4:	64a2                	ld	s1,8(sp)
    800044d6:	6902                	ld	s2,0(sp)
    800044d8:	6105                	addi	sp,sp,32
    800044da:	8082                	ret

00000000800044dc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800044dc:	7139                	addi	sp,sp,-64
    800044de:	fc06                	sd	ra,56(sp)
    800044e0:	f822                	sd	s0,48(sp)
    800044e2:	f426                	sd	s1,40(sp)
    800044e4:	f04a                	sd	s2,32(sp)
    800044e6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800044e8:	0001e497          	auipc	s1,0x1e
    800044ec:	56048493          	addi	s1,s1,1376 # 80022a48 <log>
    800044f0:	8526                	mv	a0,s1
    800044f2:	f36fc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    800044f6:	4cdc                	lw	a5,28(s1)
    800044f8:	37fd                	addiw	a5,a5,-1
    800044fa:	893e                	mv	s2,a5
    800044fc:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800044fe:	509c                	lw	a5,32(s1)
    80004500:	e7b1                	bnez	a5,8000454c <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80004502:	04091e63          	bnez	s2,8000455e <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80004506:	0001e497          	auipc	s1,0x1e
    8000450a:	54248493          	addi	s1,s1,1346 # 80022a48 <log>
    8000450e:	4785                	li	a5,1
    80004510:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004512:	8526                	mv	a0,s1
    80004514:	fa8fc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004518:	549c                	lw	a5,40(s1)
    8000451a:	06f04463          	bgtz	a5,80004582 <end_op+0xa6>
    acquire(&log.lock);
    8000451e:	0001e517          	auipc	a0,0x1e
    80004522:	52a50513          	addi	a0,a0,1322 # 80022a48 <log>
    80004526:	f02fc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    8000452a:	0001e797          	auipc	a5,0x1e
    8000452e:	5207af23          	sw	zero,1342(a5) # 80022a68 <log+0x20>
    wakeup(&log);
    80004532:	0001e517          	auipc	a0,0x1e
    80004536:	51650513          	addi	a0,a0,1302 # 80022a48 <log>
    8000453a:	c2dfd0ef          	jal	80002166 <wakeup>
    release(&log.lock);
    8000453e:	0001e517          	auipc	a0,0x1e
    80004542:	50a50513          	addi	a0,a0,1290 # 80022a48 <log>
    80004546:	f76fc0ef          	jal	80000cbc <release>
}
    8000454a:	a035                	j	80004576 <end_op+0x9a>
    8000454c:	ec4e                	sd	s3,24(sp)
    8000454e:	e852                	sd	s4,16(sp)
    80004550:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004552:	00004517          	auipc	a0,0x4
    80004556:	19650513          	addi	a0,a0,406 # 800086e8 <etext+0x6e8>
    8000455a:	acafc0ef          	jal	80000824 <panic>
    wakeup(&log);
    8000455e:	0001e517          	auipc	a0,0x1e
    80004562:	4ea50513          	addi	a0,a0,1258 # 80022a48 <log>
    80004566:	c01fd0ef          	jal	80002166 <wakeup>
  release(&log.lock);
    8000456a:	0001e517          	auipc	a0,0x1e
    8000456e:	4de50513          	addi	a0,a0,1246 # 80022a48 <log>
    80004572:	f4afc0ef          	jal	80000cbc <release>
}
    80004576:	70e2                	ld	ra,56(sp)
    80004578:	7442                	ld	s0,48(sp)
    8000457a:	74a2                	ld	s1,40(sp)
    8000457c:	7902                	ld	s2,32(sp)
    8000457e:	6121                	addi	sp,sp,64
    80004580:	8082                	ret
    80004582:	ec4e                	sd	s3,24(sp)
    80004584:	e852                	sd	s4,16(sp)
    80004586:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004588:	0001ea97          	auipc	s5,0x1e
    8000458c:	4eca8a93          	addi	s5,s5,1260 # 80022a74 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004590:	0001ea17          	auipc	s4,0x1e
    80004594:	4b8a0a13          	addi	s4,s4,1208 # 80022a48 <log>
    80004598:	018a2583          	lw	a1,24(s4)
    8000459c:	012585bb          	addw	a1,a1,s2
    800045a0:	2585                	addiw	a1,a1,1
    800045a2:	024a2503          	lw	a0,36(s4)
    800045a6:	e23fe0ef          	jal	800033c8 <bread>
    800045aa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800045ac:	000aa583          	lw	a1,0(s5)
    800045b0:	024a2503          	lw	a0,36(s4)
    800045b4:	e15fe0ef          	jal	800033c8 <bread>
    800045b8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800045ba:	40000613          	li	a2,1024
    800045be:	05850593          	addi	a1,a0,88
    800045c2:	05848513          	addi	a0,s1,88
    800045c6:	f92fc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    800045ca:	8526                	mv	a0,s1
    800045cc:	ed3fe0ef          	jal	8000349e <bwrite>
    brelse(from);
    800045d0:	854e                	mv	a0,s3
    800045d2:	efffe0ef          	jal	800034d0 <brelse>
    brelse(to);
    800045d6:	8526                	mv	a0,s1
    800045d8:	ef9fe0ef          	jal	800034d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045dc:	2905                	addiw	s2,s2,1
    800045de:	0a91                	addi	s5,s5,4
    800045e0:	028a2783          	lw	a5,40(s4)
    800045e4:	faf94ae3          	blt	s2,a5,80004598 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800045e8:	cd9ff0ef          	jal	800042c0 <write_head>
    install_trans(0); // Now install writes to home locations
    800045ec:	4501                	li	a0,0
    800045ee:	d31ff0ef          	jal	8000431e <install_trans>
    log.lh.n = 0;
    800045f2:	0001e797          	auipc	a5,0x1e
    800045f6:	4607af23          	sw	zero,1150(a5) # 80022a70 <log+0x28>
    write_head();    // Erase the transaction from the log
    800045fa:	cc7ff0ef          	jal	800042c0 <write_head>
    800045fe:	69e2                	ld	s3,24(sp)
    80004600:	6a42                	ld	s4,16(sp)
    80004602:	6aa2                	ld	s5,8(sp)
    80004604:	bf29                	j	8000451e <end_op+0x42>

0000000080004606 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004606:	1101                	addi	sp,sp,-32
    80004608:	ec06                	sd	ra,24(sp)
    8000460a:	e822                	sd	s0,16(sp)
    8000460c:	e426                	sd	s1,8(sp)
    8000460e:	1000                	addi	s0,sp,32
    80004610:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004612:	0001e517          	auipc	a0,0x1e
    80004616:	43650513          	addi	a0,a0,1078 # 80022a48 <log>
    8000461a:	e0efc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000461e:	0001e617          	auipc	a2,0x1e
    80004622:	45262603          	lw	a2,1106(a2) # 80022a70 <log+0x28>
    80004626:	47f5                	li	a5,29
    80004628:	04c7cd63          	blt	a5,a2,80004682 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000462c:	0001e797          	auipc	a5,0x1e
    80004630:	4387a783          	lw	a5,1080(a5) # 80022a64 <log+0x1c>
    80004634:	04f05d63          	blez	a5,8000468e <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004638:	4781                	li	a5,0
    8000463a:	06c05063          	blez	a2,8000469a <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000463e:	44cc                	lw	a1,12(s1)
    80004640:	0001e717          	auipc	a4,0x1e
    80004644:	43470713          	addi	a4,a4,1076 # 80022a74 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80004648:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000464a:	4314                	lw	a3,0(a4)
    8000464c:	04b68763          	beq	a3,a1,8000469a <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80004650:	2785                	addiw	a5,a5,1
    80004652:	0711                	addi	a4,a4,4
    80004654:	fef61be3          	bne	a2,a5,8000464a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004658:	060a                	slli	a2,a2,0x2
    8000465a:	02060613          	addi	a2,a2,32
    8000465e:	0001e797          	auipc	a5,0x1e
    80004662:	3ea78793          	addi	a5,a5,1002 # 80022a48 <log>
    80004666:	97b2                	add	a5,a5,a2
    80004668:	44d8                	lw	a4,12(s1)
    8000466a:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000466c:	8526                	mv	a0,s1
    8000466e:	ee7fe0ef          	jal	80003554 <bpin>
    log.lh.n++;
    80004672:	0001e717          	auipc	a4,0x1e
    80004676:	3d670713          	addi	a4,a4,982 # 80022a48 <log>
    8000467a:	571c                	lw	a5,40(a4)
    8000467c:	2785                	addiw	a5,a5,1
    8000467e:	d71c                	sw	a5,40(a4)
    80004680:	a815                	j	800046b4 <log_write+0xae>
    panic("too big a transaction");
    80004682:	00004517          	auipc	a0,0x4
    80004686:	07650513          	addi	a0,a0,118 # 800086f8 <etext+0x6f8>
    8000468a:	99afc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    8000468e:	00004517          	auipc	a0,0x4
    80004692:	08250513          	addi	a0,a0,130 # 80008710 <etext+0x710>
    80004696:	98efc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    8000469a:	00279693          	slli	a3,a5,0x2
    8000469e:	02068693          	addi	a3,a3,32
    800046a2:	0001e717          	auipc	a4,0x1e
    800046a6:	3a670713          	addi	a4,a4,934 # 80022a48 <log>
    800046aa:	9736                	add	a4,a4,a3
    800046ac:	44d4                	lw	a3,12(s1)
    800046ae:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800046b0:	faf60ee3          	beq	a2,a5,8000466c <log_write+0x66>
  }
  release(&log.lock);
    800046b4:	0001e517          	auipc	a0,0x1e
    800046b8:	39450513          	addi	a0,a0,916 # 80022a48 <log>
    800046bc:	e00fc0ef          	jal	80000cbc <release>
}
    800046c0:	60e2                	ld	ra,24(sp)
    800046c2:	6442                	ld	s0,16(sp)
    800046c4:	64a2                	ld	s1,8(sp)
    800046c6:	6105                	addi	sp,sp,32
    800046c8:	8082                	ret

00000000800046ca <pid2proc>:

extern struct proc proc[NPROC];

static struct proc*
pid2proc(int pid)
{
    800046ca:	1141                	addi	sp,sp,-16
    800046cc:	e406                	sd	ra,8(sp)
    800046ce:	e022                	sd	s0,0(sp)
    800046d0:	0800                	addi	s0,sp,16
  struct proc *p;

  if(pid <= 0)
    800046d2:	02a05b63          	blez	a0,80004708 <pid2proc+0x3e>
    800046d6:	872a                	mv	a4,a0
    return 0;

  for(p = proc; p < &proc[NPROC]; p++){
    800046d8:	0000d517          	auipc	a0,0xd
    800046dc:	97050513          	addi	a0,a0,-1680 # 80011048 <proc>
    800046e0:	00014697          	auipc	a3,0x14
    800046e4:	16868693          	addi	a3,a3,360 # 80018848 <tickslock>
    800046e8:	a029                	j	800046f2 <pid2proc+0x28>
    800046ea:	1e050513          	addi	a0,a0,480
    800046ee:	00d50b63          	beq	a0,a3,80004704 <pid2proc+0x3a>
    if(p->pid == pid && p->state != UNUSED)
    800046f2:	591c                	lw	a5,48(a0)
    800046f4:	fee79be3          	bne	a5,a4,800046ea <pid2proc+0x20>
    800046f8:	4d1c                	lw	a5,24(a0)
    800046fa:	dbe5                	beqz	a5,800046ea <pid2proc+0x20>
      return p;
  }
  return 0;
}
    800046fc:	60a2                	ld	ra,8(sp)
    800046fe:	6402                	ld	s0,0(sp)
    80004700:	0141                	addi	sp,sp,16
    80004702:	8082                	ret
  return 0;
    80004704:	4501                	li	a0,0
    80004706:	bfdd                	j	800046fc <pid2proc+0x32>
    return 0;
    80004708:	4501                	li	a0,0
    8000470a:	bfcd                	j	800046fc <pid2proc+0x32>

000000008000470c <initsleeplock>:
  return -1;  // should not happen if a deadlock was truly detected
}

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000470c:	1101                	addi	sp,sp,-32
    8000470e:	ec06                	sd	ra,24(sp)
    80004710:	e822                	sd	s0,16(sp)
    80004712:	e426                	sd	s1,8(sp)
    80004714:	e04a                	sd	s2,0(sp)
    80004716:	1000                	addi	s0,sp,32
    80004718:	84aa                	mv	s1,a0
    8000471a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000471c:	00004597          	auipc	a1,0x4
    80004720:	01458593          	addi	a1,a1,20 # 80008730 <etext+0x730>
    80004724:	0521                	addi	a0,a0,8
    80004726:	c78fc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    8000472a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000472e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004732:	0204a423          	sw	zero,40(s1)
}
    80004736:	60e2                	ld	ra,24(sp)
    80004738:	6442                	ld	s0,16(sp)
    8000473a:	64a2                	ld	s1,8(sp)
    8000473c:	6902                	ld	s2,0(sp)
    8000473e:	6105                	addi	sp,sp,32
    80004740:	8082                	ret

0000000080004742 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004742:	711d                	addi	sp,sp,-96
    80004744:	ec86                	sd	ra,88(sp)
    80004746:	e8a2                	sd	s0,80(sp)
    80004748:	e4a6                	sd	s1,72(sp)
    8000474a:	e0ca                	sd	s2,64(sp)
    8000474c:	f852                	sd	s4,48(sp)
    8000474e:	1080                	addi	s0,sp,96
    80004750:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80004752:	9c4fd0ef          	jal	80001916 <myproc>
    80004756:	84aa                	mv	s1,a0

  acquire(&lk->lk);
    80004758:	00890a13          	addi	s4,s2,8
    8000475c:	8552                	mv	a0,s4
    8000475e:	ccafc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    80004762:	00092783          	lw	a5,0(s2)
    80004766:	12078563          	beqz	a5,80004890 <acquiresleep+0x14e>
    8000476a:	fc4e                	sd	s3,56(sp)
    8000476c:	f456                	sd	s5,40(sp)
    8000476e:	f05a                	sd	s6,32(sp)
    80004770:	ec5e                	sd	s7,24(sp)
    80004772:	e862                	sd	s8,16(sp)
    80004774:	e466                	sd	s9,8(sp)
    80004776:	e06a                	sd	s10,0(sp)
    p->waiting_for_lock = lk;
    if(would_create_deadlock(p, lk)){
      p->deadlock_reports++;
      printf("deadlock warning: pid %d waits for %s held by pid %d\n",
    80004778:	00004a97          	auipc	s5,0x4
    8000477c:	018a8a93          	addi	s5,s5,24 # 80008790 <etext+0x790>
  current_proc->in_deadlock = 1;
    80004780:	4985                	li	s3,1
    printf("deadlock recovery: killing pid %d (energy_consumed=%d) to break deadlock\n",
    80004782:	00004b17          	auipc	s6,0x4
    80004786:	fbeb0b13          	addi	s6,s6,-66 # 80008740 <etext+0x740>
    8000478a:	a855                	j	8000483e <acquiresleep+0xfc>
    next_lock = owner->waiting_for_lock;
    8000478c:	18853783          	ld	a5,392(a0)
    if(next_lock == 0 || next_lock->locked == 0)
    80004790:	cf95                	beqz	a5,800047cc <acquiresleep+0x8a>
    80004792:	4398                	lw	a4,0(a5)
    80004794:	cf05                	beqz	a4,800047cc <acquiresleep+0x8a>
    owner_pid = next_lock->pid;
    80004796:	5788                	lw	a0,40(a5)
    hops++;
    80004798:	001c079b          	addiw	a5,s8,1
    8000479c:	8c3e                	mv	s8,a5
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    8000479e:	00a02733          	sgtz	a4,a0
    800047a2:	40ab86b3          	sub	a3,s7,a0
    800047a6:	00d036b3          	snez	a3,a3
    800047aa:	8f75                	and	a4,a4,a3
    800047ac:	c305                	beqz	a4,800047cc <acquiresleep+0x8a>
    800047ae:	0407a793          	slti	a5,a5,64
    800047b2:	cf89                	beqz	a5,800047cc <acquiresleep+0x8a>
    struct proc *owner = pid2proc(owner_pid);
    800047b4:	f17ff0ef          	jal	800046ca <pid2proc>
    if(owner == 0)
    800047b8:	c911                	beqz	a0,800047cc <acquiresleep+0x8a>
    owner->in_deadlock = 1;
    800047ba:	19352c23          	sw	s3,408(a0)
    if(owner->energy_consumed > max_energy){
    800047be:	17853783          	ld	a5,376(a0)
    800047c2:	fcfcf5e3          	bgeu	s9,a5,8000478c <acquiresleep+0x4a>
      max_energy = owner->energy_consumed;
    800047c6:	8cbe                	mv	s9,a5
      victim = owner;
    800047c8:	8d2a                	mv	s10,a0
    800047ca:	b7c9                	j	8000478c <acquiresleep+0x4a>
  if(victim != 0){
    800047cc:	060d0263          	beqz	s10,80004830 <acquiresleep+0xee>
    printf("deadlock recovery: killing pid %d (energy_consumed=%d) to break deadlock\n",
    800047d0:	178d2603          	lw	a2,376(s10)
    800047d4:	030d2583          	lw	a1,48(s10)
    800047d8:	855a                	mv	a0,s6
    800047da:	d21fb0ef          	jal	800004fa <printf>
    victim->killed = 1;
    800047de:	033d2423          	sw	s3,40(s10)
    if(victim->state == SLEEPING){
    800047e2:	018d2703          	lw	a4,24(s10)
    800047e6:	4789                	li	a5,2
    800047e8:	08f70963          	beq	a4,a5,8000487a <acquiresleep+0x138>
    current_proc->in_deadlock = 0;
    800047ec:	1804ac23          	sw	zero,408(s1)
    owner_pid = target_lock->pid;
    800047f0:	02892503          	lw	a0,40(s2)
    while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    800047f4:	02a05e63          	blez	a0,80004830 <acquiresleep+0xee>
    800047f8:	02ab8c63          	beq	s7,a0,80004830 <acquiresleep+0xee>
    hops = 0;
    800047fc:	4c01                	li	s8,0
      struct proc *owner = pid2proc(owner_pid);
    800047fe:	ecdff0ef          	jal	800046ca <pid2proc>
      if(owner == 0)
    80004802:	c51d                	beqz	a0,80004830 <acquiresleep+0xee>
      owner->in_deadlock = 0;
    80004804:	18052c23          	sw	zero,408(a0)
      next_lock = owner->waiting_for_lock;
    80004808:	18853783          	ld	a5,392(a0)
      if(next_lock == 0 || next_lock->locked == 0)
    8000480c:	c395                	beqz	a5,80004830 <acquiresleep+0xee>
    8000480e:	4398                	lw	a4,0(a5)
    80004810:	c305                	beqz	a4,80004830 <acquiresleep+0xee>
      owner_pid = next_lock->pid;
    80004812:	5788                	lw	a0,40(a5)
      hops++;
    80004814:	001c079b          	addiw	a5,s8,1
    80004818:	8c3e                	mv	s8,a5
    while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    8000481a:	00a02733          	sgtz	a4,a0
    8000481e:	40ab86b3          	sub	a3,s7,a0
    80004822:	00d036b3          	snez	a3,a3
    80004826:	8f75                	and	a4,a4,a3
    80004828:	c701                	beqz	a4,80004830 <acquiresleep+0xee>
    8000482a:	0407a793          	slti	a5,a5,64
    8000482e:	fbe1                	bnez	a5,800047fe <acquiresleep+0xbc>
             p->pid, lk->name, lk->pid);
      // break the deadlock by killing the highest energy process in deadlock cycle
      energy_aware_deadlock_recovery(p, lk);
    }
    sleep(lk, &lk->lk);
    80004830:	85d2                	mv	a1,s4
    80004832:	854a                	mv	a0,s2
    80004834:	8e7fd0ef          	jal	8000211a <sleep>
  while (lk->locked) {
    80004838:	00092783          	lw	a5,0(s2)
    8000483c:	c3b9                	beqz	a5,80004882 <acquiresleep+0x140>
    p->waiting_for_lock = lk;
    8000483e:	1924b423          	sd	s2,392(s1)
  if(current_proc == 0 || target_lock == 0)
    80004842:	d4fd                	beqz	s1,80004830 <acquiresleep+0xee>
  owner_pid = target_lock->pid;
    80004844:	02892503          	lw	a0,40(s2)
  while(owner_pid > 0 && hops < NPROC){
    80004848:	fea054e3          	blez	a0,80004830 <acquiresleep+0xee>
  int hops = 0;
    8000484c:	4b81                	li	s7,0
    struct proc *owner = pid2proc(owner_pid);
    8000484e:	e7dff0ef          	jal	800046ca <pid2proc>
    if(owner == 0)
    80004852:	dd79                	beqz	a0,80004830 <acquiresleep+0xee>
    if(owner->pid == current_proc->pid)
    80004854:	5918                	lw	a4,48(a0)
    80004856:	589c                	lw	a5,48(s1)
    80004858:	06f70763          	beq	a4,a5,800048c6 <acquiresleep+0x184>
    next_lock = owner->waiting_for_lock;
    8000485c:	18853783          	ld	a5,392(a0)
    if(next_lock == 0 || next_lock->locked == 0)
    80004860:	dbe1                	beqz	a5,80004830 <acquiresleep+0xee>
    80004862:	4398                	lw	a4,0(a5)
    80004864:	d771                	beqz	a4,80004830 <acquiresleep+0xee>
    owner_pid = next_lock->pid;
    80004866:	5788                	lw	a0,40(a5)
    hops++;
    80004868:	001b879b          	addiw	a5,s7,1
    8000486c:	8bbe                	mv	s7,a5
  while(owner_pid > 0 && hops < NPROC){
    8000486e:	fca051e3          	blez	a0,80004830 <acquiresleep+0xee>
    80004872:	0407a793          	slti	a5,a5,64
    80004876:	ffe1                	bnez	a5,8000484e <acquiresleep+0x10c>
    80004878:	bf65                	j	80004830 <acquiresleep+0xee>
      victim->state = RUNNABLE;
    8000487a:	478d                	li	a5,3
    8000487c:	00fd2c23          	sw	a5,24(s10)
    80004880:	b7b5                	j	800047ec <acquiresleep+0xaa>
    80004882:	79e2                	ld	s3,56(sp)
    80004884:	7aa2                	ld	s5,40(sp)
    80004886:	7b02                	ld	s6,32(sp)
    80004888:	6be2                	ld	s7,24(sp)
    8000488a:	6c42                	ld	s8,16(sp)
    8000488c:	6ca2                	ld	s9,8(sp)
    8000488e:	6d02                	ld	s10,0(sp)
  }
  p->waiting_for_lock = 0;
    80004890:	1804b423          	sd	zero,392(s1)
  lk->locked = 1;
    80004894:	4785                	li	a5,1
    80004896:	00f92023          	sw	a5,0(s2)
  lk->pid = p->pid;
    8000489a:	589c                	lw	a5,48(s1)
    8000489c:	02f92423          	sw	a5,40(s2)
  release(&lk->lk);
    800048a0:	8552                	mv	a0,s4
    800048a2:	c1afc0ef          	jal	80000cbc <release>
}
    800048a6:	60e6                	ld	ra,88(sp)
    800048a8:	6446                	ld	s0,80(sp)
    800048aa:	64a6                	ld	s1,72(sp)
    800048ac:	6906                	ld	s2,64(sp)
    800048ae:	7a42                	ld	s4,48(sp)
    800048b0:	6125                	addi	sp,sp,96
    800048b2:	8082                	ret
  owner_pid = target_lock->pid;
    800048b4:	02892503          	lw	a0,40(s2)
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    800048b8:	00a05563          	blez	a0,800048c2 <acquiresleep+0x180>
    victim = current_proc;
    800048bc:	8d26                	mv	s10,s1
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    800048be:	05751063          	bne	a0,s7,800048fe <acquiresleep+0x1bc>
    victim = current_proc;
    800048c2:	8d26                	mv	s10,s1
    800048c4:	b731                	j	800047d0 <acquiresleep+0x8e>
      p->deadlock_reports++;
    800048c6:	1904b783          	ld	a5,400(s1)
    800048ca:	0785                	addi	a5,a5,1
    800048cc:	18f4b823          	sd	a5,400(s1)
      printf("deadlock warning: pid %d waits for %s held by pid %d\n",
    800048d0:	02892683          	lw	a3,40(s2)
    800048d4:	02093603          	ld	a2,32(s2)
    800048d8:	588c                	lw	a1,48(s1)
    800048da:	8556                	mv	a0,s5
    800048dc:	c1ffb0ef          	jal	800004fa <printf>
  int start_pid = current_proc->pid;
    800048e0:	0304ab83          	lw	s7,48(s1)
  current_proc->in_deadlock = 1;
    800048e4:	1934ac23          	sw	s3,408(s1)
  if(current_proc->energy_consumed > max_energy){
    800048e8:	1784bc83          	ld	s9,376(s1)
    800048ec:	fc0c94e3          	bnez	s9,800048b4 <acquiresleep+0x172>
  owner_pid = target_lock->pid;
    800048f0:	02892503          	lw	a0,40(s2)
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    800048f4:	f2ab8ee3          	beq	s7,a0,80004830 <acquiresleep+0xee>
  struct proc *victim = 0;
    800048f8:	4d01                	li	s10,0
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    800048fa:	f2a05be3          	blez	a0,80004830 <acquiresleep+0xee>
  int hops = 0;
    800048fe:	4c01                	li	s8,0
    80004900:	bd55                	j	800047b4 <acquiresleep+0x72>

0000000080004902 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004902:	1101                	addi	sp,sp,-32
    80004904:	ec06                	sd	ra,24(sp)
    80004906:	e822                	sd	s0,16(sp)
    80004908:	e426                	sd	s1,8(sp)
    8000490a:	e04a                	sd	s2,0(sp)
    8000490c:	1000                	addi	s0,sp,32
    8000490e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004910:	00850913          	addi	s2,a0,8
    80004914:	854a                	mv	a0,s2
    80004916:	b12fc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    8000491a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000491e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004922:	8526                	mv	a0,s1
    80004924:	843fd0ef          	jal	80002166 <wakeup>
  release(&lk->lk);
    80004928:	854a                	mv	a0,s2
    8000492a:	b92fc0ef          	jal	80000cbc <release>
}
    8000492e:	60e2                	ld	ra,24(sp)
    80004930:	6442                	ld	s0,16(sp)
    80004932:	64a2                	ld	s1,8(sp)
    80004934:	6902                	ld	s2,0(sp)
    80004936:	6105                	addi	sp,sp,32
    80004938:	8082                	ret

000000008000493a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000493a:	7179                	addi	sp,sp,-48
    8000493c:	f406                	sd	ra,40(sp)
    8000493e:	f022                	sd	s0,32(sp)
    80004940:	ec26                	sd	s1,24(sp)
    80004942:	e84a                	sd	s2,16(sp)
    80004944:	1800                	addi	s0,sp,48
    80004946:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004948:	00850913          	addi	s2,a0,8
    8000494c:	854a                	mv	a0,s2
    8000494e:	adafc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004952:	409c                	lw	a5,0(s1)
    80004954:	ef81                	bnez	a5,8000496c <holdingsleep+0x32>
    80004956:	4481                	li	s1,0
  release(&lk->lk);
    80004958:	854a                	mv	a0,s2
    8000495a:	b62fc0ef          	jal	80000cbc <release>
  return r;
}
    8000495e:	8526                	mv	a0,s1
    80004960:	70a2                	ld	ra,40(sp)
    80004962:	7402                	ld	s0,32(sp)
    80004964:	64e2                	ld	s1,24(sp)
    80004966:	6942                	ld	s2,16(sp)
    80004968:	6145                	addi	sp,sp,48
    8000496a:	8082                	ret
    8000496c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000496e:	0284a983          	lw	s3,40(s1)
    80004972:	fa5fc0ef          	jal	80001916 <myproc>
    80004976:	5904                	lw	s1,48(a0)
    80004978:	413484b3          	sub	s1,s1,s3
    8000497c:	0014b493          	seqz	s1,s1
    80004980:	69a2                	ld	s3,8(sp)
    80004982:	bfd9                	j	80004958 <holdingsleep+0x1e>

0000000080004984 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004984:	1141                	addi	sp,sp,-16
    80004986:	e406                	sd	ra,8(sp)
    80004988:	e022                	sd	s0,0(sp)
    8000498a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000498c:	00004597          	auipc	a1,0x4
    80004990:	e3c58593          	addi	a1,a1,-452 # 800087c8 <etext+0x7c8>
    80004994:	0001e517          	auipc	a0,0x1e
    80004998:	1fc50513          	addi	a0,a0,508 # 80022b90 <ftable>
    8000499c:	a02fc0ef          	jal	80000b9e <initlock>
}
    800049a0:	60a2                	ld	ra,8(sp)
    800049a2:	6402                	ld	s0,0(sp)
    800049a4:	0141                	addi	sp,sp,16
    800049a6:	8082                	ret

00000000800049a8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800049a8:	1101                	addi	sp,sp,-32
    800049aa:	ec06                	sd	ra,24(sp)
    800049ac:	e822                	sd	s0,16(sp)
    800049ae:	e426                	sd	s1,8(sp)
    800049b0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800049b2:	0001e517          	auipc	a0,0x1e
    800049b6:	1de50513          	addi	a0,a0,478 # 80022b90 <ftable>
    800049ba:	a6efc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049be:	0001e497          	auipc	s1,0x1e
    800049c2:	1ea48493          	addi	s1,s1,490 # 80022ba8 <ftable+0x18>
    800049c6:	0001f717          	auipc	a4,0x1f
    800049ca:	18270713          	addi	a4,a4,386 # 80023b48 <disk>
    if(f->ref == 0){
    800049ce:	40dc                	lw	a5,4(s1)
    800049d0:	cf89                	beqz	a5,800049ea <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049d2:	02848493          	addi	s1,s1,40
    800049d6:	fee49ce3          	bne	s1,a4,800049ce <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800049da:	0001e517          	auipc	a0,0x1e
    800049de:	1b650513          	addi	a0,a0,438 # 80022b90 <ftable>
    800049e2:	adafc0ef          	jal	80000cbc <release>
  return 0;
    800049e6:	4481                	li	s1,0
    800049e8:	a809                	j	800049fa <filealloc+0x52>
      f->ref = 1;
    800049ea:	4785                	li	a5,1
    800049ec:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800049ee:	0001e517          	auipc	a0,0x1e
    800049f2:	1a250513          	addi	a0,a0,418 # 80022b90 <ftable>
    800049f6:	ac6fc0ef          	jal	80000cbc <release>
}
    800049fa:	8526                	mv	a0,s1
    800049fc:	60e2                	ld	ra,24(sp)
    800049fe:	6442                	ld	s0,16(sp)
    80004a00:	64a2                	ld	s1,8(sp)
    80004a02:	6105                	addi	sp,sp,32
    80004a04:	8082                	ret

0000000080004a06 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a06:	1101                	addi	sp,sp,-32
    80004a08:	ec06                	sd	ra,24(sp)
    80004a0a:	e822                	sd	s0,16(sp)
    80004a0c:	e426                	sd	s1,8(sp)
    80004a0e:	1000                	addi	s0,sp,32
    80004a10:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a12:	0001e517          	auipc	a0,0x1e
    80004a16:	17e50513          	addi	a0,a0,382 # 80022b90 <ftable>
    80004a1a:	a0efc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004a1e:	40dc                	lw	a5,4(s1)
    80004a20:	02f05063          	blez	a5,80004a40 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004a24:	2785                	addiw	a5,a5,1
    80004a26:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a28:	0001e517          	auipc	a0,0x1e
    80004a2c:	16850513          	addi	a0,a0,360 # 80022b90 <ftable>
    80004a30:	a8cfc0ef          	jal	80000cbc <release>
  return f;
}
    80004a34:	8526                	mv	a0,s1
    80004a36:	60e2                	ld	ra,24(sp)
    80004a38:	6442                	ld	s0,16(sp)
    80004a3a:	64a2                	ld	s1,8(sp)
    80004a3c:	6105                	addi	sp,sp,32
    80004a3e:	8082                	ret
    panic("filedup");
    80004a40:	00004517          	auipc	a0,0x4
    80004a44:	d9050513          	addi	a0,a0,-624 # 800087d0 <etext+0x7d0>
    80004a48:	dddfb0ef          	jal	80000824 <panic>

0000000080004a4c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004a4c:	7139                	addi	sp,sp,-64
    80004a4e:	fc06                	sd	ra,56(sp)
    80004a50:	f822                	sd	s0,48(sp)
    80004a52:	f426                	sd	s1,40(sp)
    80004a54:	0080                	addi	s0,sp,64
    80004a56:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004a58:	0001e517          	auipc	a0,0x1e
    80004a5c:	13850513          	addi	a0,a0,312 # 80022b90 <ftable>
    80004a60:	9c8fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004a64:	40dc                	lw	a5,4(s1)
    80004a66:	04f05a63          	blez	a5,80004aba <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004a6a:	37fd                	addiw	a5,a5,-1
    80004a6c:	c0dc                	sw	a5,4(s1)
    80004a6e:	06f04063          	bgtz	a5,80004ace <fileclose+0x82>
    80004a72:	f04a                	sd	s2,32(sp)
    80004a74:	ec4e                	sd	s3,24(sp)
    80004a76:	e852                	sd	s4,16(sp)
    80004a78:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004a7a:	0004a903          	lw	s2,0(s1)
    80004a7e:	0094c783          	lbu	a5,9(s1)
    80004a82:	89be                	mv	s3,a5
    80004a84:	689c                	ld	a5,16(s1)
    80004a86:	8a3e                	mv	s4,a5
    80004a88:	6c9c                	ld	a5,24(s1)
    80004a8a:	8abe                	mv	s5,a5
  f->ref = 0;
    80004a8c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004a90:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004a94:	0001e517          	auipc	a0,0x1e
    80004a98:	0fc50513          	addi	a0,a0,252 # 80022b90 <ftable>
    80004a9c:	a20fc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    80004aa0:	4785                	li	a5,1
    80004aa2:	04f90163          	beq	s2,a5,80004ae4 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004aa6:	ffe9079b          	addiw	a5,s2,-2
    80004aaa:	4705                	li	a4,1
    80004aac:	04f77563          	bgeu	a4,a5,80004af6 <fileclose+0xaa>
    80004ab0:	7902                	ld	s2,32(sp)
    80004ab2:	69e2                	ld	s3,24(sp)
    80004ab4:	6a42                	ld	s4,16(sp)
    80004ab6:	6aa2                	ld	s5,8(sp)
    80004ab8:	a00d                	j	80004ada <fileclose+0x8e>
    80004aba:	f04a                	sd	s2,32(sp)
    80004abc:	ec4e                	sd	s3,24(sp)
    80004abe:	e852                	sd	s4,16(sp)
    80004ac0:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004ac2:	00004517          	auipc	a0,0x4
    80004ac6:	d1650513          	addi	a0,a0,-746 # 800087d8 <etext+0x7d8>
    80004aca:	d5bfb0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    80004ace:	0001e517          	auipc	a0,0x1e
    80004ad2:	0c250513          	addi	a0,a0,194 # 80022b90 <ftable>
    80004ad6:	9e6fc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004ada:	70e2                	ld	ra,56(sp)
    80004adc:	7442                	ld	s0,48(sp)
    80004ade:	74a2                	ld	s1,40(sp)
    80004ae0:	6121                	addi	sp,sp,64
    80004ae2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004ae4:	85ce                	mv	a1,s3
    80004ae6:	8552                	mv	a0,s4
    80004ae8:	36a000ef          	jal	80004e52 <pipeclose>
    80004aec:	7902                	ld	s2,32(sp)
    80004aee:	69e2                	ld	s3,24(sp)
    80004af0:	6a42                	ld	s4,16(sp)
    80004af2:	6aa2                	ld	s5,8(sp)
    80004af4:	b7dd                	j	80004ada <fileclose+0x8e>
    begin_op();
    80004af6:	977ff0ef          	jal	8000446c <begin_op>
    iput(ff.ip);
    80004afa:	8556                	mv	a0,s5
    80004afc:	8e6ff0ef          	jal	80003be2 <iput>
    end_op();
    80004b00:	9ddff0ef          	jal	800044dc <end_op>
    80004b04:	7902                	ld	s2,32(sp)
    80004b06:	69e2                	ld	s3,24(sp)
    80004b08:	6a42                	ld	s4,16(sp)
    80004b0a:	6aa2                	ld	s5,8(sp)
    80004b0c:	b7f9                	j	80004ada <fileclose+0x8e>

0000000080004b0e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004b0e:	715d                	addi	sp,sp,-80
    80004b10:	e486                	sd	ra,72(sp)
    80004b12:	e0a2                	sd	s0,64(sp)
    80004b14:	fc26                	sd	s1,56(sp)
    80004b16:	f052                	sd	s4,32(sp)
    80004b18:	0880                	addi	s0,sp,80
    80004b1a:	84aa                	mv	s1,a0
    80004b1c:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004b1e:	df9fc0ef          	jal	80001916 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004b22:	409c                	lw	a5,0(s1)
    80004b24:	37f9                	addiw	a5,a5,-2
    80004b26:	4705                	li	a4,1
    80004b28:	04f76263          	bltu	a4,a5,80004b6c <filestat+0x5e>
    80004b2c:	f84a                	sd	s2,48(sp)
    80004b2e:	f44e                	sd	s3,40(sp)
    80004b30:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004b32:	6c88                	ld	a0,24(s1)
    80004b34:	f2dfe0ef          	jal	80003a60 <ilock>
    stati(f->ip, &st);
    80004b38:	fb840913          	addi	s2,s0,-72
    80004b3c:	85ca                	mv	a1,s2
    80004b3e:	6c88                	ld	a0,24(s1)
    80004b40:	a84ff0ef          	jal	80003dc4 <stati>
    iunlock(f->ip);
    80004b44:	6c88                	ld	a0,24(s1)
    80004b46:	fc9fe0ef          	jal	80003b0e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004b4a:	46e1                	li	a3,24
    80004b4c:	864a                	mv	a2,s2
    80004b4e:	85d2                	mv	a1,s4
    80004b50:	0509b503          	ld	a0,80(s3)
    80004b54:	b01fc0ef          	jal	80001654 <copyout>
    80004b58:	41f5551b          	sraiw	a0,a0,0x1f
    80004b5c:	7942                	ld	s2,48(sp)
    80004b5e:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004b60:	60a6                	ld	ra,72(sp)
    80004b62:	6406                	ld	s0,64(sp)
    80004b64:	74e2                	ld	s1,56(sp)
    80004b66:	7a02                	ld	s4,32(sp)
    80004b68:	6161                	addi	sp,sp,80
    80004b6a:	8082                	ret
  return -1;
    80004b6c:	557d                	li	a0,-1
    80004b6e:	bfcd                	j	80004b60 <filestat+0x52>

0000000080004b70 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004b70:	7179                	addi	sp,sp,-48
    80004b72:	f406                	sd	ra,40(sp)
    80004b74:	f022                	sd	s0,32(sp)
    80004b76:	e84a                	sd	s2,16(sp)
    80004b78:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004b7a:	00854783          	lbu	a5,8(a0)
    80004b7e:	cfd1                	beqz	a5,80004c1a <fileread+0xaa>
    80004b80:	ec26                	sd	s1,24(sp)
    80004b82:	e44e                	sd	s3,8(sp)
    80004b84:	84aa                	mv	s1,a0
    80004b86:	892e                	mv	s2,a1
    80004b88:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b8a:	411c                	lw	a5,0(a0)
    80004b8c:	4705                	li	a4,1
    80004b8e:	04e78363          	beq	a5,a4,80004bd4 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b92:	470d                	li	a4,3
    80004b94:	04e78763          	beq	a5,a4,80004be2 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b98:	4709                	li	a4,2
    80004b9a:	06e79a63          	bne	a5,a4,80004c0e <fileread+0x9e>
    ilock(f->ip);
    80004b9e:	6d08                	ld	a0,24(a0)
    80004ba0:	ec1fe0ef          	jal	80003a60 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004ba4:	874e                	mv	a4,s3
    80004ba6:	5094                	lw	a3,32(s1)
    80004ba8:	864a                	mv	a2,s2
    80004baa:	4585                	li	a1,1
    80004bac:	6c88                	ld	a0,24(s1)
    80004bae:	a44ff0ef          	jal	80003df2 <readi>
    80004bb2:	892a                	mv	s2,a0
    80004bb4:	00a05563          	blez	a0,80004bbe <fileread+0x4e>
      f->off += r;
    80004bb8:	509c                	lw	a5,32(s1)
    80004bba:	9fa9                	addw	a5,a5,a0
    80004bbc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004bbe:	6c88                	ld	a0,24(s1)
    80004bc0:	f4ffe0ef          	jal	80003b0e <iunlock>
    80004bc4:	64e2                	ld	s1,24(sp)
    80004bc6:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004bc8:	854a                	mv	a0,s2
    80004bca:	70a2                	ld	ra,40(sp)
    80004bcc:	7402                	ld	s0,32(sp)
    80004bce:	6942                	ld	s2,16(sp)
    80004bd0:	6145                	addi	sp,sp,48
    80004bd2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004bd4:	6908                	ld	a0,16(a0)
    80004bd6:	3fe000ef          	jal	80004fd4 <piperead>
    80004bda:	892a                	mv	s2,a0
    80004bdc:	64e2                	ld	s1,24(sp)
    80004bde:	69a2                	ld	s3,8(sp)
    80004be0:	b7e5                	j	80004bc8 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004be2:	02451783          	lh	a5,36(a0)
    80004be6:	03079693          	slli	a3,a5,0x30
    80004bea:	92c1                	srli	a3,a3,0x30
    80004bec:	4725                	li	a4,9
    80004bee:	02d76963          	bltu	a4,a3,80004c20 <fileread+0xb0>
    80004bf2:	0792                	slli	a5,a5,0x4
    80004bf4:	0001e717          	auipc	a4,0x1e
    80004bf8:	efc70713          	addi	a4,a4,-260 # 80022af0 <devsw>
    80004bfc:	97ba                	add	a5,a5,a4
    80004bfe:	639c                	ld	a5,0(a5)
    80004c00:	c78d                	beqz	a5,80004c2a <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80004c02:	4505                	li	a0,1
    80004c04:	9782                	jalr	a5
    80004c06:	892a                	mv	s2,a0
    80004c08:	64e2                	ld	s1,24(sp)
    80004c0a:	69a2                	ld	s3,8(sp)
    80004c0c:	bf75                	j	80004bc8 <fileread+0x58>
    panic("fileread");
    80004c0e:	00004517          	auipc	a0,0x4
    80004c12:	bda50513          	addi	a0,a0,-1062 # 800087e8 <etext+0x7e8>
    80004c16:	c0ffb0ef          	jal	80000824 <panic>
    return -1;
    80004c1a:	57fd                	li	a5,-1
    80004c1c:	893e                	mv	s2,a5
    80004c1e:	b76d                	j	80004bc8 <fileread+0x58>
      return -1;
    80004c20:	57fd                	li	a5,-1
    80004c22:	893e                	mv	s2,a5
    80004c24:	64e2                	ld	s1,24(sp)
    80004c26:	69a2                	ld	s3,8(sp)
    80004c28:	b745                	j	80004bc8 <fileread+0x58>
    80004c2a:	57fd                	li	a5,-1
    80004c2c:	893e                	mv	s2,a5
    80004c2e:	64e2                	ld	s1,24(sp)
    80004c30:	69a2                	ld	s3,8(sp)
    80004c32:	bf59                	j	80004bc8 <fileread+0x58>

0000000080004c34 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004c34:	00954783          	lbu	a5,9(a0)
    80004c38:	10078f63          	beqz	a5,80004d56 <filewrite+0x122>
{
    80004c3c:	711d                	addi	sp,sp,-96
    80004c3e:	ec86                	sd	ra,88(sp)
    80004c40:	e8a2                	sd	s0,80(sp)
    80004c42:	e0ca                	sd	s2,64(sp)
    80004c44:	f456                	sd	s5,40(sp)
    80004c46:	f05a                	sd	s6,32(sp)
    80004c48:	1080                	addi	s0,sp,96
    80004c4a:	892a                	mv	s2,a0
    80004c4c:	8b2e                	mv	s6,a1
    80004c4e:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c50:	411c                	lw	a5,0(a0)
    80004c52:	4705                	li	a4,1
    80004c54:	02e78a63          	beq	a5,a4,80004c88 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c58:	470d                	li	a4,3
    80004c5a:	02e78b63          	beq	a5,a4,80004c90 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c5e:	4709                	li	a4,2
    80004c60:	0ce79f63          	bne	a5,a4,80004d3e <filewrite+0x10a>
    80004c64:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004c66:	0ac05a63          	blez	a2,80004d1a <filewrite+0xe6>
    80004c6a:	e4a6                	sd	s1,72(sp)
    80004c6c:	fc4e                	sd	s3,56(sp)
    80004c6e:	ec5e                	sd	s7,24(sp)
    80004c70:	e862                	sd	s8,16(sp)
    80004c72:	e466                	sd	s9,8(sp)
    int i = 0;
    80004c74:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004c76:	6b85                	lui	s7,0x1
    80004c78:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004c7c:	6785                	lui	a5,0x1
    80004c7e:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004c82:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004c84:	4c05                	li	s8,1
    80004c86:	a8ad                	j	80004d00 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004c88:	6908                	ld	a0,16(a0)
    80004c8a:	23c000ef          	jal	80004ec6 <pipewrite>
    80004c8e:	a04d                	j	80004d30 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004c90:	02451783          	lh	a5,36(a0)
    80004c94:	03079693          	slli	a3,a5,0x30
    80004c98:	92c1                	srli	a3,a3,0x30
    80004c9a:	4725                	li	a4,9
    80004c9c:	0ad76f63          	bltu	a4,a3,80004d5a <filewrite+0x126>
    80004ca0:	0792                	slli	a5,a5,0x4
    80004ca2:	0001e717          	auipc	a4,0x1e
    80004ca6:	e4e70713          	addi	a4,a4,-434 # 80022af0 <devsw>
    80004caa:	97ba                	add	a5,a5,a4
    80004cac:	679c                	ld	a5,8(a5)
    80004cae:	cbc5                	beqz	a5,80004d5e <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80004cb0:	4505                	li	a0,1
    80004cb2:	9782                	jalr	a5
    80004cb4:	a8b5                	j	80004d30 <filewrite+0xfc>
      if(n1 > max)
    80004cb6:	2981                	sext.w	s3,s3
      begin_op();
    80004cb8:	fb4ff0ef          	jal	8000446c <begin_op>
      ilock(f->ip);
    80004cbc:	01893503          	ld	a0,24(s2)
    80004cc0:	da1fe0ef          	jal	80003a60 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004cc4:	874e                	mv	a4,s3
    80004cc6:	02092683          	lw	a3,32(s2)
    80004cca:	016a0633          	add	a2,s4,s6
    80004cce:	85e2                	mv	a1,s8
    80004cd0:	01893503          	ld	a0,24(s2)
    80004cd4:	a10ff0ef          	jal	80003ee4 <writei>
    80004cd8:	84aa                	mv	s1,a0
    80004cda:	00a05763          	blez	a0,80004ce8 <filewrite+0xb4>
        f->off += r;
    80004cde:	02092783          	lw	a5,32(s2)
    80004ce2:	9fa9                	addw	a5,a5,a0
    80004ce4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004ce8:	01893503          	ld	a0,24(s2)
    80004cec:	e23fe0ef          	jal	80003b0e <iunlock>
      end_op();
    80004cf0:	fecff0ef          	jal	800044dc <end_op>

      if(r != n1){
    80004cf4:	02999563          	bne	s3,s1,80004d1e <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004cf8:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004cfc:	015a5963          	bge	s4,s5,80004d0e <filewrite+0xda>
      int n1 = n - i;
    80004d00:	414a87bb          	subw	a5,s5,s4
    80004d04:	89be                	mv	s3,a5
      if(n1 > max)
    80004d06:	fafbd8e3          	bge	s7,a5,80004cb6 <filewrite+0x82>
    80004d0a:	89e6                	mv	s3,s9
    80004d0c:	b76d                	j	80004cb6 <filewrite+0x82>
    80004d0e:	64a6                	ld	s1,72(sp)
    80004d10:	79e2                	ld	s3,56(sp)
    80004d12:	6be2                	ld	s7,24(sp)
    80004d14:	6c42                	ld	s8,16(sp)
    80004d16:	6ca2                	ld	s9,8(sp)
    80004d18:	a801                	j	80004d28 <filewrite+0xf4>
    int i = 0;
    80004d1a:	4a01                	li	s4,0
    80004d1c:	a031                	j	80004d28 <filewrite+0xf4>
    80004d1e:	64a6                	ld	s1,72(sp)
    80004d20:	79e2                	ld	s3,56(sp)
    80004d22:	6be2                	ld	s7,24(sp)
    80004d24:	6c42                	ld	s8,16(sp)
    80004d26:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004d28:	034a9d63          	bne	s5,s4,80004d62 <filewrite+0x12e>
    80004d2c:	8556                	mv	a0,s5
    80004d2e:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004d30:	60e6                	ld	ra,88(sp)
    80004d32:	6446                	ld	s0,80(sp)
    80004d34:	6906                	ld	s2,64(sp)
    80004d36:	7aa2                	ld	s5,40(sp)
    80004d38:	7b02                	ld	s6,32(sp)
    80004d3a:	6125                	addi	sp,sp,96
    80004d3c:	8082                	ret
    80004d3e:	e4a6                	sd	s1,72(sp)
    80004d40:	fc4e                	sd	s3,56(sp)
    80004d42:	f852                	sd	s4,48(sp)
    80004d44:	ec5e                	sd	s7,24(sp)
    80004d46:	e862                	sd	s8,16(sp)
    80004d48:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004d4a:	00004517          	auipc	a0,0x4
    80004d4e:	aae50513          	addi	a0,a0,-1362 # 800087f8 <etext+0x7f8>
    80004d52:	ad3fb0ef          	jal	80000824 <panic>
    return -1;
    80004d56:	557d                	li	a0,-1
}
    80004d58:	8082                	ret
      return -1;
    80004d5a:	557d                	li	a0,-1
    80004d5c:	bfd1                	j	80004d30 <filewrite+0xfc>
    80004d5e:	557d                	li	a0,-1
    80004d60:	bfc1                	j	80004d30 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80004d62:	557d                	li	a0,-1
    80004d64:	7a42                	ld	s4,48(sp)
    80004d66:	b7e9                	j	80004d30 <filewrite+0xfc>

0000000080004d68 <peterson_acquire>:

// Peterson's lock acquire
// id = 0 for writer, id = 1 for reader
static void
peterson_acquire(struct pipe *pi, int id)
{
    80004d68:	1141                	addi	sp,sp,-16
    80004d6a:	e406                	sd	ra,8(sp)
    80004d6c:	e022                	sd	s0,0(sp)
    80004d6e:	0800                	addi	s0,sp,16
  int other = 1 - id;
    80004d70:	4705                	li	a4,1
    80004d72:	9f0d                	subw	a4,a4,a1
    80004d74:	863a                	mv	a2,a4
  pi->flag[id] = 1;        // I want to enter
    80004d76:	058a                	slli	a1,a1,0x2
    80004d78:	95aa                	add	a1,a1,a0
    80004d7a:	4785                	li	a5,1
    80004d7c:	c19c                	sw	a5,0(a1)
  pi->turn = other;        // But I give the other process a chance first
    80004d7e:	c518                	sw	a4,8(a0)

  // Memory fence to ensure the above stores are visible before the while check
  __sync_synchronize();
    80004d80:	0330000f          	fence	rw,rw

  // Busy-wait while the OTHER process also wants in AND it's the other's turn
  while(pi->flag[other] == 1 && pi->turn == other)
    80004d84:	070a                	slli	a4,a4,0x2
    80004d86:	972a                	add	a4,a4,a0
    80004d88:	86be                	mv	a3,a5
    80004d8a:	431c                	lw	a5,0(a4)
    80004d8c:	2781                	sext.w	a5,a5
    80004d8e:	00d79663          	bne	a5,a3,80004d9a <peterson_acquire+0x32>
    80004d92:	451c                	lw	a5,8(a0)
    80004d94:	2781                	sext.w	a5,a5
    80004d96:	fec78ae3          	beq	a5,a2,80004d8a <peterson_acquire+0x22>
    ;
}
    80004d9a:	60a2                	ld	ra,8(sp)
    80004d9c:	6402                	ld	s0,0(sp)
    80004d9e:	0141                	addi	sp,sp,16
    80004da0:	8082                	ret

0000000080004da2 <pipealloc>:
  pi->flag[id] = 0;       // I no longer want to be in the critical section
}

int
pipealloc(struct file **f0, struct file **f1)
{
    80004da2:	1101                	addi	sp,sp,-32
    80004da4:	ec06                	sd	ra,24(sp)
    80004da6:	e822                	sd	s0,16(sp)
    80004da8:	e426                	sd	s1,8(sp)
    80004daa:	e04a                	sd	s2,0(sp)
    80004dac:	1000                	addi	s0,sp,32
    80004dae:	84aa                	mv	s1,a0
    80004db0:	892e                	mv	s2,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004db2:	0005b023          	sd	zero,0(a1)
    80004db6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004dba:	befff0ef          	jal	800049a8 <filealloc>
    80004dbe:	e088                	sd	a0,0(s1)
    80004dc0:	cd35                	beqz	a0,80004e3c <pipealloc+0x9a>
    80004dc2:	be7ff0ef          	jal	800049a8 <filealloc>
    80004dc6:	00a93023          	sd	a0,0(s2)
    80004dca:	c52d                	beqz	a0,80004e34 <pipealloc+0x92>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004dcc:	d79fb0ef          	jal	80000b44 <kalloc>
    80004dd0:	cd39                	beqz	a0,80004e2e <pipealloc+0x8c>
    goto bad;
  pi->readopen = 1;
    80004dd2:	4785                	li	a5,1
    80004dd4:	20f52a23          	sw	a5,532(a0)
  pi->writeopen = 1;
    80004dd8:	20f52c23          	sw	a5,536(a0)
  pi->nwrite = 0;
    80004ddc:	20052823          	sw	zero,528(a0)
  pi->nread = 0;
    80004de0:	20052623          	sw	zero,524(a0)

  // Initialize Peterson's variables (instead of initlock)
  pi->flag[0] = 0;
    80004de4:	00052023          	sw	zero,0(a0)
  pi->flag[1] = 0;
    80004de8:	00052223          	sw	zero,4(a0)
  pi->turn = 0;
    80004dec:	00052423          	sw	zero,8(a0)

  (*f0)->type = FD_PIPE;
    80004df0:	6098                	ld	a4,0(s1)
    80004df2:	c31c                	sw	a5,0(a4)
  (*f0)->readable = 1;
    80004df4:	6098                	ld	a4,0(s1)
    80004df6:	00f70423          	sb	a5,8(a4)
  (*f0)->writable = 0;
    80004dfa:	6098                	ld	a4,0(s1)
    80004dfc:	000704a3          	sb	zero,9(a4)
  (*f0)->pipe = pi;
    80004e00:	6098                	ld	a4,0(s1)
    80004e02:	eb08                	sd	a0,16(a4)
  (*f1)->type = FD_PIPE;
    80004e04:	00093703          	ld	a4,0(s2)
    80004e08:	c31c                	sw	a5,0(a4)
  (*f1)->readable = 0;
    80004e0a:	00093703          	ld	a4,0(s2)
    80004e0e:	00070423          	sb	zero,8(a4)
  (*f1)->writable = 1;
    80004e12:	00093703          	ld	a4,0(s2)
    80004e16:	00f704a3          	sb	a5,9(a4)
  (*f1)->pipe = pi;
    80004e1a:	00093783          	ld	a5,0(s2)
    80004e1e:	eb88                	sd	a0,16(a5)
  return 0;
    80004e20:	4501                	li	a0,0
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
    80004e22:	60e2                	ld	ra,24(sp)
    80004e24:	6442                	ld	s0,16(sp)
    80004e26:	64a2                	ld	s1,8(sp)
    80004e28:	6902                	ld	s2,0(sp)
    80004e2a:	6105                	addi	sp,sp,32
    80004e2c:	8082                	ret
  if(*f0)
    80004e2e:	6088                	ld	a0,0(s1)
    80004e30:	e501                	bnez	a0,80004e38 <pipealloc+0x96>
    80004e32:	a029                	j	80004e3c <pipealloc+0x9a>
    80004e34:	6088                	ld	a0,0(s1)
    80004e36:	cd01                	beqz	a0,80004e4e <pipealloc+0xac>
    fileclose(*f0);
    80004e38:	c15ff0ef          	jal	80004a4c <fileclose>
  if(*f1)
    80004e3c:	00093783          	ld	a5,0(s2)
  return -1;
    80004e40:	557d                	li	a0,-1
  if(*f1)
    80004e42:	d3e5                	beqz	a5,80004e22 <pipealloc+0x80>
    fileclose(*f1);
    80004e44:	853e                	mv	a0,a5
    80004e46:	c07ff0ef          	jal	80004a4c <fileclose>
  return -1;
    80004e4a:	557d                	li	a0,-1
    80004e4c:	bfd9                	j	80004e22 <pipealloc+0x80>
    80004e4e:	557d                	li	a0,-1
    80004e50:	bfc9                	j	80004e22 <pipealloc+0x80>

0000000080004e52 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e52:	7179                	addi	sp,sp,-48
    80004e54:	f406                	sd	ra,40(sp)
    80004e56:	f022                	sd	s0,32(sp)
    80004e58:	ec26                	sd	s1,24(sp)
    80004e5a:	e84a                	sd	s2,16(sp)
    80004e5c:	e44e                	sd	s3,8(sp)
    80004e5e:	1800                	addi	s0,sp,48
    80004e60:	84aa                	mv	s1,a0
    80004e62:	89ae                	mv	s3,a1
  // Determine our process id for Peterson's: writer = 0, reader = 1
  int id = writable ? 0 : 1;
    80004e64:	0015b913          	seqz	s2,a1

  peterson_acquire(pi, id);
    80004e68:	85ca                	mv	a1,s2
    80004e6a:	effff0ef          	jal	80004d68 <peterson_acquire>
  if(writable){
    80004e6e:	02098b63          	beqz	s3,80004ea4 <pipeclose+0x52>
    pi->writeopen = 0;
    80004e72:	2004ac23          	sw	zero,536(s1)
    wakeup(&pi->nread);
    80004e76:	20c48513          	addi	a0,s1,524
    80004e7a:	aecfd0ef          	jal	80002166 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e7e:	2144a783          	lw	a5,532(s1)
    80004e82:	e781                	bnez	a5,80004e8a <pipeclose+0x38>
    80004e84:	2184a783          	lw	a5,536(s1)
    80004e88:	c78d                	beqz	a5,80004eb2 <pipeclose+0x60>
  __sync_synchronize();
    80004e8a:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004e8e:	090a                	slli	s2,s2,0x2
    80004e90:	94ca                	add	s1,s1,s2
    80004e92:	0004a023          	sw	zero,0(s1)
    peterson_release(pi, id);
    kfree((char*)pi);
  } else
    peterson_release(pi, id);
}
    80004e96:	70a2                	ld	ra,40(sp)
    80004e98:	7402                	ld	s0,32(sp)
    80004e9a:	64e2                	ld	s1,24(sp)
    80004e9c:	6942                	ld	s2,16(sp)
    80004e9e:	69a2                	ld	s3,8(sp)
    80004ea0:	6145                	addi	sp,sp,48
    80004ea2:	8082                	ret
    pi->readopen = 0;
    80004ea4:	2004aa23          	sw	zero,532(s1)
    wakeup(&pi->nwrite);
    80004ea8:	21048513          	addi	a0,s1,528
    80004eac:	abafd0ef          	jal	80002166 <wakeup>
    80004eb0:	b7f9                	j	80004e7e <pipeclose+0x2c>
  __sync_synchronize();
    80004eb2:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004eb6:	090a                	slli	s2,s2,0x2
    80004eb8:	9926                	add	s2,s2,s1
    80004eba:	00092023          	sw	zero,0(s2)
    kfree((char*)pi);
    80004ebe:	8526                	mv	a0,s1
    80004ec0:	b9dfb0ef          	jal	80000a5c <kfree>
    80004ec4:	bfc9                	j	80004e96 <pipeclose+0x44>

0000000080004ec6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004ec6:	7159                	addi	sp,sp,-112
    80004ec8:	f486                	sd	ra,104(sp)
    80004eca:	f0a2                	sd	s0,96(sp)
    80004ecc:	eca6                	sd	s1,88(sp)
    80004ece:	e8ca                	sd	s2,80(sp)
    80004ed0:	e4ce                	sd	s3,72(sp)
    80004ed2:	e0d2                	sd	s4,64(sp)
    80004ed4:	fc56                	sd	s5,56(sp)
    80004ed6:	1880                	addi	s0,sp,112
    80004ed8:	84aa                	mv	s1,a0
    80004eda:	8aae                	mv	s5,a1
    80004edc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004ede:	a39fc0ef          	jal	80001916 <myproc>
    80004ee2:	89aa                	mv	s3,a0

  // Writer is process 0 in Peterson's algorithm
  peterson_acquire(pi, 0);
    80004ee4:	4581                	li	a1,0
    80004ee6:	8526                	mv	a0,s1
    80004ee8:	e81ff0ef          	jal	80004d68 <peterson_acquire>
  while(i < n){
    80004eec:	0d405c63          	blez	s4,80004fc4 <pipewrite+0xfe>
    80004ef0:	f85a                	sd	s6,48(sp)
    80004ef2:	f45e                	sd	s7,40(sp)
    80004ef4:	f062                	sd	s8,32(sp)
    80004ef6:	ec66                	sd	s9,24(sp)
    80004ef8:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004efa:	4901                	li	s2,0
      sleep(&pi->nwrite, 0);
      // Re-acquire Peterson's lock after waking up
      peterson_acquire(pi, 0);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004efc:	f9f40c13          	addi	s8,s0,-97
    80004f00:	4b85                	li	s7,1
    80004f02:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004f04:	20c48d13          	addi	s10,s1,524
      sleep(&pi->nwrite, 0);
    80004f08:	21048c93          	addi	s9,s1,528
    80004f0c:	a0b1                	j	80004f58 <pipewrite+0x92>
  __sync_synchronize();
    80004f0e:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004f12:	0004a023          	sw	zero,0(s1)
      return -1;
    80004f16:	597d                	li	s2,-1
}
    80004f18:	7b42                	ld	s6,48(sp)
    80004f1a:	7ba2                	ld	s7,40(sp)
    80004f1c:	7c02                	ld	s8,32(sp)
    80004f1e:	6ce2                	ld	s9,24(sp)
    80004f20:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  peterson_release(pi, 0);

  return i;
}
    80004f22:	854a                	mv	a0,s2
    80004f24:	70a6                	ld	ra,104(sp)
    80004f26:	7406                	ld	s0,96(sp)
    80004f28:	64e6                	ld	s1,88(sp)
    80004f2a:	6946                	ld	s2,80(sp)
    80004f2c:	69a6                	ld	s3,72(sp)
    80004f2e:	6a06                	ld	s4,64(sp)
    80004f30:	7ae2                	ld	s5,56(sp)
    80004f32:	6165                	addi	sp,sp,112
    80004f34:	8082                	ret
      wakeup(&pi->nread);
    80004f36:	856a                	mv	a0,s10
    80004f38:	a2efd0ef          	jal	80002166 <wakeup>
  __sync_synchronize();
    80004f3c:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004f40:	0004a023          	sw	zero,0(s1)
      sleep(&pi->nwrite, 0);
    80004f44:	4581                	li	a1,0
    80004f46:	8566                	mv	a0,s9
    80004f48:	9d2fd0ef          	jal	8000211a <sleep>
      peterson_acquire(pi, 0);
    80004f4c:	4581                	li	a1,0
    80004f4e:	8526                	mv	a0,s1
    80004f50:	e19ff0ef          	jal	80004d68 <peterson_acquire>
  while(i < n){
    80004f54:	05495a63          	bge	s2,s4,80004fa8 <pipewrite+0xe2>
    if(pi->readopen == 0 || killed(pr)){
    80004f58:	2144a783          	lw	a5,532(s1)
    80004f5c:	dbcd                	beqz	a5,80004f0e <pipewrite+0x48>
    80004f5e:	854e                	mv	a0,s3
    80004f60:	bf6fd0ef          	jal	80002356 <killed>
    80004f64:	f54d                	bnez	a0,80004f0e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004f66:	20c4a783          	lw	a5,524(s1)
    80004f6a:	2104a703          	lw	a4,528(s1)
    80004f6e:	2007879b          	addiw	a5,a5,512
    80004f72:	fcf702e3          	beq	a4,a5,80004f36 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f76:	86de                	mv	a3,s7
    80004f78:	01590633          	add	a2,s2,s5
    80004f7c:	85e2                	mv	a1,s8
    80004f7e:	0509b503          	ld	a0,80(s3)
    80004f82:	f90fc0ef          	jal	80001712 <copyin>
    80004f86:	05650163          	beq	a0,s6,80004fc8 <pipewrite+0x102>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f8a:	2104a783          	lw	a5,528(s1)
    80004f8e:	0017871b          	addiw	a4,a5,1
    80004f92:	20e4a823          	sw	a4,528(s1)
    80004f96:	1ff7f793          	andi	a5,a5,511
    80004f9a:	97a6                	add	a5,a5,s1
    80004f9c:	f9f44703          	lbu	a4,-97(s0)
    80004fa0:	00e78623          	sb	a4,12(a5)
      i++;
    80004fa4:	2905                	addiw	s2,s2,1
    80004fa6:	b77d                	j	80004f54 <pipewrite+0x8e>
    80004fa8:	7b42                	ld	s6,48(sp)
    80004faa:	7ba2                	ld	s7,40(sp)
    80004fac:	7c02                	ld	s8,32(sp)
    80004fae:	6ce2                	ld	s9,24(sp)
    80004fb0:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004fb2:	20c48513          	addi	a0,s1,524
    80004fb6:	9b0fd0ef          	jal	80002166 <wakeup>
  __sync_synchronize();
    80004fba:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004fbe:	0004a023          	sw	zero,0(s1)
}
    80004fc2:	b785                	j	80004f22 <pipewrite+0x5c>
  int i = 0;
    80004fc4:	4901                	li	s2,0
    80004fc6:	b7f5                	j	80004fb2 <pipewrite+0xec>
    80004fc8:	7b42                	ld	s6,48(sp)
    80004fca:	7ba2                	ld	s7,40(sp)
    80004fcc:	7c02                	ld	s8,32(sp)
    80004fce:	6ce2                	ld	s9,24(sp)
    80004fd0:	6d42                	ld	s10,16(sp)
    80004fd2:	b7c5                	j	80004fb2 <pipewrite+0xec>

0000000080004fd4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004fd4:	711d                	addi	sp,sp,-96
    80004fd6:	ec86                	sd	ra,88(sp)
    80004fd8:	e8a2                	sd	s0,80(sp)
    80004fda:	e4a6                	sd	s1,72(sp)
    80004fdc:	e0ca                	sd	s2,64(sp)
    80004fde:	fc4e                	sd	s3,56(sp)
    80004fe0:	f852                	sd	s4,48(sp)
    80004fe2:	f456                	sd	s5,40(sp)
    80004fe4:	f05a                	sd	s6,32(sp)
    80004fe6:	1080                	addi	s0,sp,96
    80004fe8:	84aa                	mv	s1,a0
    80004fea:	892e                	mv	s2,a1
    80004fec:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004fee:	929fc0ef          	jal	80001916 <myproc>
    80004ff2:	8a2a                	mv	s4,a0
  char ch;

  // Reader is process 1 in Peterson's algorithm
  peterson_acquire(pi, 1);
    80004ff4:	4585                	li	a1,1
    80004ff6:	8526                	mv	a0,s1
    80004ff8:	d71ff0ef          	jal	80004d68 <peterson_acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ffc:	20c4a703          	lw	a4,524(s1)
    80005000:	2104a783          	lw	a5,528(s1)
      return -1;
    }
    // Release Peterson's lock before sleeping so the writer can acquire it
    peterson_release(pi, 1);
    // Sleep on nread — the writer will wake us when it writes
    sleep(&pi->nread, 0);
    80005004:	20c48b13          	addi	s6,s1,524
    // Re-acquire Peterson's lock after waking up
    peterson_acquire(pi, 1);
    80005008:	4985                	li	s3,1
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000500a:	02f71e63          	bne	a4,a5,80005046 <piperead+0x72>
    8000500e:	2184a783          	lw	a5,536(s1)
    80005012:	c3b9                	beqz	a5,80005058 <piperead+0x84>
    if(killed(pr)){
    80005014:	8552                	mv	a0,s4
    80005016:	b40fd0ef          	jal	80002356 <killed>
    8000501a:	e90d                	bnez	a0,8000504c <piperead+0x78>
  __sync_synchronize();
    8000501c:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80005020:	0004a223          	sw	zero,4(s1)
    sleep(&pi->nread, 0);
    80005024:	4581                	li	a1,0
    80005026:	855a                	mv	a0,s6
    80005028:	8f2fd0ef          	jal	8000211a <sleep>
    peterson_acquire(pi, 1);
    8000502c:	85ce                	mv	a1,s3
    8000502e:	8526                	mv	a0,s1
    80005030:	d39ff0ef          	jal	80004d68 <peterson_acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005034:	20c4a703          	lw	a4,524(s1)
    80005038:	2104a783          	lw	a5,528(s1)
    8000503c:	fcf709e3          	beq	a4,a5,8000500e <piperead+0x3a>
    80005040:	ec5e                	sd	s7,24(sp)
    80005042:	e862                	sd	s8,16(sp)
    80005044:	a821                	j	8000505c <piperead+0x88>
    80005046:	ec5e                	sd	s7,24(sp)
    80005048:	e862                	sd	s8,16(sp)
    8000504a:	a809                	j	8000505c <piperead+0x88>
  __sync_synchronize();
    8000504c:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80005050:	0004a223          	sw	zero,4(s1)
      return -1;
    80005054:	59fd                	li	s3,-1
}
    80005056:	a09d                	j	800050bc <piperead+0xe8>
    80005058:	ec5e                	sd	s7,24(sp)
    8000505a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000505c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    8000505e:	faf40c13          	addi	s8,s0,-81
    80005062:	4b85                	li	s7,1
    80005064:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005066:	05505163          	blez	s5,800050a8 <piperead+0xd4>
    if(pi->nread == pi->nwrite)
    8000506a:	20c4a783          	lw	a5,524(s1)
    8000506e:	2104a703          	lw	a4,528(s1)
    80005072:	02f70b63          	beq	a4,a5,800050a8 <piperead+0xd4>
    ch = pi->data[pi->nread % PIPESIZE];
    80005076:	1ff7f793          	andi	a5,a5,511
    8000507a:	97a6                	add	a5,a5,s1
    8000507c:	00c7c783          	lbu	a5,12(a5)
    80005080:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80005084:	86de                	mv	a3,s7
    80005086:	8662                	mv	a2,s8
    80005088:	85ca                	mv	a1,s2
    8000508a:	050a3503          	ld	a0,80(s4)
    8000508e:	dc6fc0ef          	jal	80001654 <copyout>
    80005092:	05650063          	beq	a0,s6,800050d2 <piperead+0xfe>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80005096:	20c4a783          	lw	a5,524(s1)
    8000509a:	2785                	addiw	a5,a5,1
    8000509c:	20f4a623          	sw	a5,524(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050a0:	2985                	addiw	s3,s3,1
    800050a2:	0905                	addi	s2,s2,1
    800050a4:	fd3a93e3          	bne	s5,s3,8000506a <piperead+0x96>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800050a8:	21048513          	addi	a0,s1,528
    800050ac:	8bafd0ef          	jal	80002166 <wakeup>
  __sync_synchronize();
    800050b0:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    800050b4:	0004a223          	sw	zero,4(s1)
    800050b8:	6be2                	ld	s7,24(sp)
    800050ba:	6c42                	ld	s8,16(sp)
  peterson_release(pi, 1);
  return i;
}
    800050bc:	854e                	mv	a0,s3
    800050be:	60e6                	ld	ra,88(sp)
    800050c0:	6446                	ld	s0,80(sp)
    800050c2:	64a6                	ld	s1,72(sp)
    800050c4:	6906                	ld	s2,64(sp)
    800050c6:	79e2                	ld	s3,56(sp)
    800050c8:	7a42                	ld	s4,48(sp)
    800050ca:	7aa2                	ld	s5,40(sp)
    800050cc:	7b02                	ld	s6,32(sp)
    800050ce:	6125                	addi	sp,sp,96
    800050d0:	8082                	ret
      if(i == 0)
    800050d2:	fc099be3          	bnez	s3,800050a8 <piperead+0xd4>
        i = -1;
    800050d6:	89aa                	mv	s3,a0
    800050d8:	bfc1                	j	800050a8 <piperead+0xd4>

00000000800050da <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    800050da:	1141                	addi	sp,sp,-16
    800050dc:	e406                	sd	ra,8(sp)
    800050de:	e022                	sd	s0,0(sp)
    800050e0:	0800                	addi	s0,sp,16
    800050e2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800050e4:	0035151b          	slliw	a0,a0,0x3
    800050e8:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800050ea:	8b89                	andi	a5,a5,2
    800050ec:	c399                	beqz	a5,800050f2 <flags2perm+0x18>
      perm |= PTE_W;
    800050ee:	00456513          	ori	a0,a0,4
    return perm;
}
    800050f2:	60a2                	ld	ra,8(sp)
    800050f4:	6402                	ld	s0,0(sp)
    800050f6:	0141                	addi	sp,sp,16
    800050f8:	8082                	ret

00000000800050fa <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800050fa:	de010113          	addi	sp,sp,-544
    800050fe:	20113c23          	sd	ra,536(sp)
    80005102:	20813823          	sd	s0,528(sp)
    80005106:	20913423          	sd	s1,520(sp)
    8000510a:	21213023          	sd	s2,512(sp)
    8000510e:	1400                	addi	s0,sp,544
    80005110:	892a                	mv	s2,a0
    80005112:	dea43823          	sd	a0,-528(s0)
    80005116:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000511a:	ffcfc0ef          	jal	80001916 <myproc>
    8000511e:	84aa                	mv	s1,a0

  begin_op();
    80005120:	b4cff0ef          	jal	8000446c <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80005124:	854a                	mv	a0,s2
    80005126:	968ff0ef          	jal	8000428e <namei>
    8000512a:	cd21                	beqz	a0,80005182 <kexec+0x88>
    8000512c:	fbd2                	sd	s4,496(sp)
    8000512e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005130:	931fe0ef          	jal	80003a60 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005134:	04000713          	li	a4,64
    80005138:	4681                	li	a3,0
    8000513a:	e5040613          	addi	a2,s0,-432
    8000513e:	4581                	li	a1,0
    80005140:	8552                	mv	a0,s4
    80005142:	cb1fe0ef          	jal	80003df2 <readi>
    80005146:	04000793          	li	a5,64
    8000514a:	00f51a63          	bne	a0,a5,8000515e <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    8000514e:	e5042703          	lw	a4,-432(s0)
    80005152:	464c47b7          	lui	a5,0x464c4
    80005156:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000515a:	02f70863          	beq	a4,a5,8000518a <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000515e:	8552                	mv	a0,s4
    80005160:	b0dfe0ef          	jal	80003c6c <iunlockput>
    end_op();
    80005164:	b78ff0ef          	jal	800044dc <end_op>
  }
  return -1;
    80005168:	557d                	li	a0,-1
    8000516a:	7a5e                	ld	s4,496(sp)
}
    8000516c:	21813083          	ld	ra,536(sp)
    80005170:	21013403          	ld	s0,528(sp)
    80005174:	20813483          	ld	s1,520(sp)
    80005178:	20013903          	ld	s2,512(sp)
    8000517c:	22010113          	addi	sp,sp,544
    80005180:	8082                	ret
    end_op();
    80005182:	b5aff0ef          	jal	800044dc <end_op>
    return -1;
    80005186:	557d                	li	a0,-1
    80005188:	b7d5                	j	8000516c <kexec+0x72>
    8000518a:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000518c:	8526                	mv	a0,s1
    8000518e:	893fc0ef          	jal	80001a20 <proc_pagetable>
    80005192:	8b2a                	mv	s6,a0
    80005194:	26050f63          	beqz	a0,80005412 <kexec+0x318>
    80005198:	ffce                	sd	s3,504(sp)
    8000519a:	f7d6                	sd	s5,488(sp)
    8000519c:	efde                	sd	s7,472(sp)
    8000519e:	ebe2                	sd	s8,464(sp)
    800051a0:	e7e6                	sd	s9,456(sp)
    800051a2:	e3ea                	sd	s10,448(sp)
    800051a4:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051a6:	e8845783          	lhu	a5,-376(s0)
    800051aa:	0e078963          	beqz	a5,8000529c <kexec+0x1a2>
    800051ae:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800051b2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051b4:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800051b6:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800051ba:	6c85                	lui	s9,0x1
    800051bc:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800051c0:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800051c4:	6a85                	lui	s5,0x1
    800051c6:	a085                	j	80005226 <kexec+0x12c>
      panic("loadseg: address should exist");
    800051c8:	00003517          	auipc	a0,0x3
    800051cc:	64050513          	addi	a0,a0,1600 # 80008808 <etext+0x808>
    800051d0:	e54fb0ef          	jal	80000824 <panic>
    if(sz - i < PGSIZE)
    800051d4:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800051d6:	874a                	mv	a4,s2
    800051d8:	009b86bb          	addw	a3,s7,s1
    800051dc:	4581                	li	a1,0
    800051de:	8552                	mv	a0,s4
    800051e0:	c13fe0ef          	jal	80003df2 <readi>
    800051e4:	22a91b63          	bne	s2,a0,8000541a <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    800051e8:	009a84bb          	addw	s1,s5,s1
    800051ec:	0334f263          	bgeu	s1,s3,80005210 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    800051f0:	02049593          	slli	a1,s1,0x20
    800051f4:	9181                	srli	a1,a1,0x20
    800051f6:	95e2                	add	a1,a1,s8
    800051f8:	855a                	mv	a0,s6
    800051fa:	e2dfb0ef          	jal	80001026 <walkaddr>
    800051fe:	862a                	mv	a2,a0
    if(pa == 0)
    80005200:	d561                	beqz	a0,800051c8 <kexec+0xce>
    if(sz - i < PGSIZE)
    80005202:	409987bb          	subw	a5,s3,s1
    80005206:	893e                	mv	s2,a5
    80005208:	fcfcf6e3          	bgeu	s9,a5,800051d4 <kexec+0xda>
    8000520c:	8956                	mv	s2,s5
    8000520e:	b7d9                	j	800051d4 <kexec+0xda>
    sz = sz1;
    80005210:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005214:	2d05                	addiw	s10,s10,1
    80005216:	e0843783          	ld	a5,-504(s0)
    8000521a:	0387869b          	addiw	a3,a5,56
    8000521e:	e8845783          	lhu	a5,-376(s0)
    80005222:	06fd5e63          	bge	s10,a5,8000529e <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005226:	e0d43423          	sd	a3,-504(s0)
    8000522a:	876e                	mv	a4,s11
    8000522c:	e1840613          	addi	a2,s0,-488
    80005230:	4581                	li	a1,0
    80005232:	8552                	mv	a0,s4
    80005234:	bbffe0ef          	jal	80003df2 <readi>
    80005238:	1db51f63          	bne	a0,s11,80005416 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    8000523c:	e1842783          	lw	a5,-488(s0)
    80005240:	4705                	li	a4,1
    80005242:	fce799e3          	bne	a5,a4,80005214 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80005246:	e4043483          	ld	s1,-448(s0)
    8000524a:	e3843783          	ld	a5,-456(s0)
    8000524e:	1ef4e463          	bltu	s1,a5,80005436 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005252:	e2843783          	ld	a5,-472(s0)
    80005256:	94be                	add	s1,s1,a5
    80005258:	1ef4e263          	bltu	s1,a5,8000543c <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    8000525c:	de843703          	ld	a4,-536(s0)
    80005260:	8ff9                	and	a5,a5,a4
    80005262:	1e079063          	bnez	a5,80005442 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005266:	e1c42503          	lw	a0,-484(s0)
    8000526a:	e71ff0ef          	jal	800050da <flags2perm>
    8000526e:	86aa                	mv	a3,a0
    80005270:	8626                	mv	a2,s1
    80005272:	85ca                	mv	a1,s2
    80005274:	855a                	mv	a0,s6
    80005276:	886fc0ef          	jal	800012fc <uvmalloc>
    8000527a:	dea43c23          	sd	a0,-520(s0)
    8000527e:	1c050563          	beqz	a0,80005448 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005282:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005286:	00098863          	beqz	s3,80005296 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000528a:	e2843c03          	ld	s8,-472(s0)
    8000528e:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005292:	4481                	li	s1,0
    80005294:	bfb1                	j	800051f0 <kexec+0xf6>
    sz = sz1;
    80005296:	df843903          	ld	s2,-520(s0)
    8000529a:	bfad                	j	80005214 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000529c:	4901                	li	s2,0
  iunlockput(ip);
    8000529e:	8552                	mv	a0,s4
    800052a0:	9cdfe0ef          	jal	80003c6c <iunlockput>
  end_op();
    800052a4:	a38ff0ef          	jal	800044dc <end_op>
  p = myproc();
    800052a8:	e6efc0ef          	jal	80001916 <myproc>
    800052ac:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800052ae:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800052b2:	6985                	lui	s3,0x1
    800052b4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800052b6:	99ca                	add	s3,s3,s2
    800052b8:	77fd                	lui	a5,0xfffff
    800052ba:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800052be:	4691                	li	a3,4
    800052c0:	6609                	lui	a2,0x2
    800052c2:	964e                	add	a2,a2,s3
    800052c4:	85ce                	mv	a1,s3
    800052c6:	855a                	mv	a0,s6
    800052c8:	834fc0ef          	jal	800012fc <uvmalloc>
    800052cc:	8a2a                	mv	s4,a0
    800052ce:	e105                	bnez	a0,800052ee <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    800052d0:	85ce                	mv	a1,s3
    800052d2:	855a                	mv	a0,s6
    800052d4:	fd0fc0ef          	jal	80001aa4 <proc_freepagetable>
  return -1;
    800052d8:	557d                	li	a0,-1
    800052da:	79fe                	ld	s3,504(sp)
    800052dc:	7a5e                	ld	s4,496(sp)
    800052de:	7abe                	ld	s5,488(sp)
    800052e0:	7b1e                	ld	s6,480(sp)
    800052e2:	6bfe                	ld	s7,472(sp)
    800052e4:	6c5e                	ld	s8,464(sp)
    800052e6:	6cbe                	ld	s9,456(sp)
    800052e8:	6d1e                	ld	s10,448(sp)
    800052ea:	7dfa                	ld	s11,440(sp)
    800052ec:	b541                	j	8000516c <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800052ee:	75f9                	lui	a1,0xffffe
    800052f0:	95aa                	add	a1,a1,a0
    800052f2:	855a                	mv	a0,s6
    800052f4:	9dafc0ef          	jal	800014ce <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800052f8:	800a0b93          	addi	s7,s4,-2048
    800052fc:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80005300:	e0043783          	ld	a5,-512(s0)
    80005304:	6388                	ld	a0,0(a5)
  sp = sz;
    80005306:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80005308:	4481                	li	s1,0
    ustack[argc] = sp;
    8000530a:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    8000530e:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005312:	cd21                	beqz	a0,8000536a <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80005314:	b6ffb0ef          	jal	80000e82 <strlen>
    80005318:	0015079b          	addiw	a5,a0,1
    8000531c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005320:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005324:	13796563          	bltu	s2,s7,8000544e <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005328:	e0043d83          	ld	s11,-512(s0)
    8000532c:	000db983          	ld	s3,0(s11)
    80005330:	854e                	mv	a0,s3
    80005332:	b51fb0ef          	jal	80000e82 <strlen>
    80005336:	0015069b          	addiw	a3,a0,1
    8000533a:	864e                	mv	a2,s3
    8000533c:	85ca                	mv	a1,s2
    8000533e:	855a                	mv	a0,s6
    80005340:	b14fc0ef          	jal	80001654 <copyout>
    80005344:	10054763          	bltz	a0,80005452 <kexec+0x358>
    ustack[argc] = sp;
    80005348:	00349793          	slli	a5,s1,0x3
    8000534c:	97e6                	add	a5,a5,s9
    8000534e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb378>
  for(argc = 0; argv[argc]; argc++) {
    80005352:	0485                	addi	s1,s1,1
    80005354:	008d8793          	addi	a5,s11,8
    80005358:	e0f43023          	sd	a5,-512(s0)
    8000535c:	008db503          	ld	a0,8(s11)
    80005360:	c509                	beqz	a0,8000536a <kexec+0x270>
    if(argc >= MAXARG)
    80005362:	fb8499e3          	bne	s1,s8,80005314 <kexec+0x21a>
  sz = sz1;
    80005366:	89d2                	mv	s3,s4
    80005368:	b7a5                	j	800052d0 <kexec+0x1d6>
  ustack[argc] = 0;
    8000536a:	00349793          	slli	a5,s1,0x3
    8000536e:	f9078793          	addi	a5,a5,-112
    80005372:	97a2                	add	a5,a5,s0
    80005374:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005378:	00349693          	slli	a3,s1,0x3
    8000537c:	06a1                	addi	a3,a3,8
    8000537e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005382:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005386:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005388:	f57964e3          	bltu	s2,s7,800052d0 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000538c:	e9040613          	addi	a2,s0,-368
    80005390:	85ca                	mv	a1,s2
    80005392:	855a                	mv	a0,s6
    80005394:	ac0fc0ef          	jal	80001654 <copyout>
    80005398:	f2054ce3          	bltz	a0,800052d0 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    8000539c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800053a0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800053a4:	df043783          	ld	a5,-528(s0)
    800053a8:	0007c703          	lbu	a4,0(a5)
    800053ac:	cf11                	beqz	a4,800053c8 <kexec+0x2ce>
    800053ae:	0785                	addi	a5,a5,1
    if(*s == '/')
    800053b0:	02f00693          	li	a3,47
    800053b4:	a029                	j	800053be <kexec+0x2c4>
  for(last=s=path; *s; s++)
    800053b6:	0785                	addi	a5,a5,1
    800053b8:	fff7c703          	lbu	a4,-1(a5)
    800053bc:	c711                	beqz	a4,800053c8 <kexec+0x2ce>
    if(*s == '/')
    800053be:	fed71ce3          	bne	a4,a3,800053b6 <kexec+0x2bc>
      last = s+1;
    800053c2:	def43823          	sd	a5,-528(s0)
    800053c6:	bfc5                	j	800053b6 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    800053c8:	4641                	li	a2,16
    800053ca:	df043583          	ld	a1,-528(s0)
    800053ce:	158a8513          	addi	a0,s5,344
    800053d2:	a7bfb0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    800053d6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800053da:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800053de:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    800053e2:	058ab783          	ld	a5,88(s5)
    800053e6:	e6843703          	ld	a4,-408(s0)
    800053ea:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800053ec:	058ab783          	ld	a5,88(s5)
    800053f0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800053f4:	85ea                	mv	a1,s10
    800053f6:	eaefc0ef          	jal	80001aa4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800053fa:	0004851b          	sext.w	a0,s1
    800053fe:	79fe                	ld	s3,504(sp)
    80005400:	7a5e                	ld	s4,496(sp)
    80005402:	7abe                	ld	s5,488(sp)
    80005404:	7b1e                	ld	s6,480(sp)
    80005406:	6bfe                	ld	s7,472(sp)
    80005408:	6c5e                	ld	s8,464(sp)
    8000540a:	6cbe                	ld	s9,456(sp)
    8000540c:	6d1e                	ld	s10,448(sp)
    8000540e:	7dfa                	ld	s11,440(sp)
    80005410:	bbb1                	j	8000516c <kexec+0x72>
    80005412:	7b1e                	ld	s6,480(sp)
    80005414:	b3a9                	j	8000515e <kexec+0x64>
    80005416:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000541a:	df843583          	ld	a1,-520(s0)
    8000541e:	855a                	mv	a0,s6
    80005420:	e84fc0ef          	jal	80001aa4 <proc_freepagetable>
  if(ip){
    80005424:	79fe                	ld	s3,504(sp)
    80005426:	7abe                	ld	s5,488(sp)
    80005428:	7b1e                	ld	s6,480(sp)
    8000542a:	6bfe                	ld	s7,472(sp)
    8000542c:	6c5e                	ld	s8,464(sp)
    8000542e:	6cbe                	ld	s9,456(sp)
    80005430:	6d1e                	ld	s10,448(sp)
    80005432:	7dfa                	ld	s11,440(sp)
    80005434:	b32d                	j	8000515e <kexec+0x64>
    80005436:	df243c23          	sd	s2,-520(s0)
    8000543a:	b7c5                	j	8000541a <kexec+0x320>
    8000543c:	df243c23          	sd	s2,-520(s0)
    80005440:	bfe9                	j	8000541a <kexec+0x320>
    80005442:	df243c23          	sd	s2,-520(s0)
    80005446:	bfd1                	j	8000541a <kexec+0x320>
    80005448:	df243c23          	sd	s2,-520(s0)
    8000544c:	b7f9                	j	8000541a <kexec+0x320>
  sz = sz1;
    8000544e:	89d2                	mv	s3,s4
    80005450:	b541                	j	800052d0 <kexec+0x1d6>
    80005452:	89d2                	mv	s3,s4
    80005454:	bdb5                	j	800052d0 <kexec+0x1d6>

0000000080005456 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005456:	7179                	addi	sp,sp,-48
    80005458:	f406                	sd	ra,40(sp)
    8000545a:	f022                	sd	s0,32(sp)
    8000545c:	ec26                	sd	s1,24(sp)
    8000545e:	e84a                	sd	s2,16(sp)
    80005460:	1800                	addi	s0,sp,48
    80005462:	892e                	mv	s2,a1
    80005464:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005466:	fdc40593          	addi	a1,s0,-36
    8000546a:	a91fd0ef          	jal	80002efa <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000546e:	fdc42703          	lw	a4,-36(s0)
    80005472:	47bd                	li	a5,15
    80005474:	02e7ea63          	bltu	a5,a4,800054a8 <argfd+0x52>
    80005478:	c9efc0ef          	jal	80001916 <myproc>
    8000547c:	fdc42703          	lw	a4,-36(s0)
    80005480:	00371793          	slli	a5,a4,0x3
    80005484:	0d078793          	addi	a5,a5,208
    80005488:	953e                	add	a0,a0,a5
    8000548a:	611c                	ld	a5,0(a0)
    8000548c:	c385                	beqz	a5,800054ac <argfd+0x56>
    return -1;
  if(pfd)
    8000548e:	00090463          	beqz	s2,80005496 <argfd+0x40>
    *pfd = fd;
    80005492:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005496:	4501                	li	a0,0
  if(pf)
    80005498:	c091                	beqz	s1,8000549c <argfd+0x46>
    *pf = f;
    8000549a:	e09c                	sd	a5,0(s1)
}
    8000549c:	70a2                	ld	ra,40(sp)
    8000549e:	7402                	ld	s0,32(sp)
    800054a0:	64e2                	ld	s1,24(sp)
    800054a2:	6942                	ld	s2,16(sp)
    800054a4:	6145                	addi	sp,sp,48
    800054a6:	8082                	ret
    return -1;
    800054a8:	557d                	li	a0,-1
    800054aa:	bfcd                	j	8000549c <argfd+0x46>
    800054ac:	557d                	li	a0,-1
    800054ae:	b7fd                	j	8000549c <argfd+0x46>

00000000800054b0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800054b0:	1101                	addi	sp,sp,-32
    800054b2:	ec06                	sd	ra,24(sp)
    800054b4:	e822                	sd	s0,16(sp)
    800054b6:	e426                	sd	s1,8(sp)
    800054b8:	1000                	addi	s0,sp,32
    800054ba:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800054bc:	c5afc0ef          	jal	80001916 <myproc>
    800054c0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800054c2:	0d050793          	addi	a5,a0,208
    800054c6:	4501                	li	a0,0
    800054c8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800054ca:	6398                	ld	a4,0(a5)
    800054cc:	cb19                	beqz	a4,800054e2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800054ce:	2505                	addiw	a0,a0,1
    800054d0:	07a1                	addi	a5,a5,8
    800054d2:	fed51ce3          	bne	a0,a3,800054ca <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800054d6:	557d                	li	a0,-1
}
    800054d8:	60e2                	ld	ra,24(sp)
    800054da:	6442                	ld	s0,16(sp)
    800054dc:	64a2                	ld	s1,8(sp)
    800054de:	6105                	addi	sp,sp,32
    800054e0:	8082                	ret
      p->ofile[fd] = f;
    800054e2:	00351793          	slli	a5,a0,0x3
    800054e6:	0d078793          	addi	a5,a5,208
    800054ea:	963e                	add	a2,a2,a5
    800054ec:	e204                	sd	s1,0(a2)
      return fd;
    800054ee:	b7ed                	j	800054d8 <fdalloc+0x28>

00000000800054f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800054f0:	715d                	addi	sp,sp,-80
    800054f2:	e486                	sd	ra,72(sp)
    800054f4:	e0a2                	sd	s0,64(sp)
    800054f6:	fc26                	sd	s1,56(sp)
    800054f8:	f84a                	sd	s2,48(sp)
    800054fa:	f44e                	sd	s3,40(sp)
    800054fc:	f052                	sd	s4,32(sp)
    800054fe:	ec56                	sd	s5,24(sp)
    80005500:	e85a                	sd	s6,16(sp)
    80005502:	0880                	addi	s0,sp,80
    80005504:	892e                	mv	s2,a1
    80005506:	8a2e                	mv	s4,a1
    80005508:	8ab2                	mv	s5,a2
    8000550a:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000550c:	fb040593          	addi	a1,s0,-80
    80005510:	d99fe0ef          	jal	800042a8 <nameiparent>
    80005514:	84aa                	mv	s1,a0
    80005516:	10050763          	beqz	a0,80005624 <create+0x134>
    return 0;

  ilock(dp);
    8000551a:	d46fe0ef          	jal	80003a60 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000551e:	4601                	li	a2,0
    80005520:	fb040593          	addi	a1,s0,-80
    80005524:	8526                	mv	a0,s1
    80005526:	ad5fe0ef          	jal	80003ffa <dirlookup>
    8000552a:	89aa                	mv	s3,a0
    8000552c:	c131                	beqz	a0,80005570 <create+0x80>
    iunlockput(dp);
    8000552e:	8526                	mv	a0,s1
    80005530:	f3cfe0ef          	jal	80003c6c <iunlockput>
    ilock(ip);
    80005534:	854e                	mv	a0,s3
    80005536:	d2afe0ef          	jal	80003a60 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000553a:	4789                	li	a5,2
    8000553c:	02f91563          	bne	s2,a5,80005566 <create+0x76>
    80005540:	0449d783          	lhu	a5,68(s3)
    80005544:	37f9                	addiw	a5,a5,-2
    80005546:	17c2                	slli	a5,a5,0x30
    80005548:	93c1                	srli	a5,a5,0x30
    8000554a:	4705                	li	a4,1
    8000554c:	00f76d63          	bltu	a4,a5,80005566 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005550:	854e                	mv	a0,s3
    80005552:	60a6                	ld	ra,72(sp)
    80005554:	6406                	ld	s0,64(sp)
    80005556:	74e2                	ld	s1,56(sp)
    80005558:	7942                	ld	s2,48(sp)
    8000555a:	79a2                	ld	s3,40(sp)
    8000555c:	7a02                	ld	s4,32(sp)
    8000555e:	6ae2                	ld	s5,24(sp)
    80005560:	6b42                	ld	s6,16(sp)
    80005562:	6161                	addi	sp,sp,80
    80005564:	8082                	ret
    iunlockput(ip);
    80005566:	854e                	mv	a0,s3
    80005568:	f04fe0ef          	jal	80003c6c <iunlockput>
    return 0;
    8000556c:	4981                	li	s3,0
    8000556e:	b7cd                	j	80005550 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005570:	85ca                	mv	a1,s2
    80005572:	4088                	lw	a0,0(s1)
    80005574:	b7cfe0ef          	jal	800038f0 <ialloc>
    80005578:	892a                	mv	s2,a0
    8000557a:	cd15                	beqz	a0,800055b6 <create+0xc6>
  ilock(ip);
    8000557c:	ce4fe0ef          	jal	80003a60 <ilock>
  ip->major = major;
    80005580:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80005584:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005588:	4785                	li	a5,1
    8000558a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000558e:	854a                	mv	a0,s2
    80005590:	c1cfe0ef          	jal	800039ac <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005594:	4705                	li	a4,1
    80005596:	02ea0463          	beq	s4,a4,800055be <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8000559a:	00492603          	lw	a2,4(s2)
    8000559e:	fb040593          	addi	a1,s0,-80
    800055a2:	8526                	mv	a0,s1
    800055a4:	c41fe0ef          	jal	800041e4 <dirlink>
    800055a8:	06054263          	bltz	a0,8000560c <create+0x11c>
  iunlockput(dp);
    800055ac:	8526                	mv	a0,s1
    800055ae:	ebefe0ef          	jal	80003c6c <iunlockput>
  return ip;
    800055b2:	89ca                	mv	s3,s2
    800055b4:	bf71                	j	80005550 <create+0x60>
    iunlockput(dp);
    800055b6:	8526                	mv	a0,s1
    800055b8:	eb4fe0ef          	jal	80003c6c <iunlockput>
    return 0;
    800055bc:	bf51                	j	80005550 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800055be:	00492603          	lw	a2,4(s2)
    800055c2:	00003597          	auipc	a1,0x3
    800055c6:	26658593          	addi	a1,a1,614 # 80008828 <etext+0x828>
    800055ca:	854a                	mv	a0,s2
    800055cc:	c19fe0ef          	jal	800041e4 <dirlink>
    800055d0:	02054e63          	bltz	a0,8000560c <create+0x11c>
    800055d4:	40d0                	lw	a2,4(s1)
    800055d6:	00003597          	auipc	a1,0x3
    800055da:	25a58593          	addi	a1,a1,602 # 80008830 <etext+0x830>
    800055de:	854a                	mv	a0,s2
    800055e0:	c05fe0ef          	jal	800041e4 <dirlink>
    800055e4:	02054463          	bltz	a0,8000560c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800055e8:	00492603          	lw	a2,4(s2)
    800055ec:	fb040593          	addi	a1,s0,-80
    800055f0:	8526                	mv	a0,s1
    800055f2:	bf3fe0ef          	jal	800041e4 <dirlink>
    800055f6:	00054b63          	bltz	a0,8000560c <create+0x11c>
    dp->nlink++;  // for ".."
    800055fa:	04a4d783          	lhu	a5,74(s1)
    800055fe:	2785                	addiw	a5,a5,1
    80005600:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005604:	8526                	mv	a0,s1
    80005606:	ba6fe0ef          	jal	800039ac <iupdate>
    8000560a:	b74d                	j	800055ac <create+0xbc>
  ip->nlink = 0;
    8000560c:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005610:	854a                	mv	a0,s2
    80005612:	b9afe0ef          	jal	800039ac <iupdate>
  iunlockput(ip);
    80005616:	854a                	mv	a0,s2
    80005618:	e54fe0ef          	jal	80003c6c <iunlockput>
  iunlockput(dp);
    8000561c:	8526                	mv	a0,s1
    8000561e:	e4efe0ef          	jal	80003c6c <iunlockput>
  return 0;
    80005622:	b73d                	j	80005550 <create+0x60>
    return 0;
    80005624:	89aa                	mv	s3,a0
    80005626:	b72d                	j	80005550 <create+0x60>

0000000080005628 <sys_dup>:
{
    80005628:	7179                	addi	sp,sp,-48
    8000562a:	f406                	sd	ra,40(sp)
    8000562c:	f022                	sd	s0,32(sp)
    8000562e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005630:	fd840613          	addi	a2,s0,-40
    80005634:	4581                	li	a1,0
    80005636:	4501                	li	a0,0
    80005638:	e1fff0ef          	jal	80005456 <argfd>
    return -1;
    8000563c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000563e:	02054363          	bltz	a0,80005664 <sys_dup+0x3c>
    80005642:	ec26                	sd	s1,24(sp)
    80005644:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005646:	fd843483          	ld	s1,-40(s0)
    8000564a:	8526                	mv	a0,s1
    8000564c:	e65ff0ef          	jal	800054b0 <fdalloc>
    80005650:	892a                	mv	s2,a0
    return -1;
    80005652:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005654:	00054d63          	bltz	a0,8000566e <sys_dup+0x46>
  filedup(f);
    80005658:	8526                	mv	a0,s1
    8000565a:	bacff0ef          	jal	80004a06 <filedup>
  return fd;
    8000565e:	87ca                	mv	a5,s2
    80005660:	64e2                	ld	s1,24(sp)
    80005662:	6942                	ld	s2,16(sp)
}
    80005664:	853e                	mv	a0,a5
    80005666:	70a2                	ld	ra,40(sp)
    80005668:	7402                	ld	s0,32(sp)
    8000566a:	6145                	addi	sp,sp,48
    8000566c:	8082                	ret
    8000566e:	64e2                	ld	s1,24(sp)
    80005670:	6942                	ld	s2,16(sp)
    80005672:	bfcd                	j	80005664 <sys_dup+0x3c>

0000000080005674 <sys_read>:
{
    80005674:	7179                	addi	sp,sp,-48
    80005676:	f406                	sd	ra,40(sp)
    80005678:	f022                	sd	s0,32(sp)
    8000567a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000567c:	fd840593          	addi	a1,s0,-40
    80005680:	4505                	li	a0,1
    80005682:	895fd0ef          	jal	80002f16 <argaddr>
  argint(2, &n);
    80005686:	fe440593          	addi	a1,s0,-28
    8000568a:	4509                	li	a0,2
    8000568c:	86ffd0ef          	jal	80002efa <argint>
  if(argfd(0, 0, &f) < 0)
    80005690:	fe840613          	addi	a2,s0,-24
    80005694:	4581                	li	a1,0
    80005696:	4501                	li	a0,0
    80005698:	dbfff0ef          	jal	80005456 <argfd>
    8000569c:	87aa                	mv	a5,a0
    return -1;
    8000569e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800056a0:	0007ca63          	bltz	a5,800056b4 <sys_read+0x40>
  return fileread(f, p, n);
    800056a4:	fe442603          	lw	a2,-28(s0)
    800056a8:	fd843583          	ld	a1,-40(s0)
    800056ac:	fe843503          	ld	a0,-24(s0)
    800056b0:	cc0ff0ef          	jal	80004b70 <fileread>
}
    800056b4:	70a2                	ld	ra,40(sp)
    800056b6:	7402                	ld	s0,32(sp)
    800056b8:	6145                	addi	sp,sp,48
    800056ba:	8082                	ret

00000000800056bc <sys_write>:
{
    800056bc:	7179                	addi	sp,sp,-48
    800056be:	f406                	sd	ra,40(sp)
    800056c0:	f022                	sd	s0,32(sp)
    800056c2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800056c4:	fd840593          	addi	a1,s0,-40
    800056c8:	4505                	li	a0,1
    800056ca:	84dfd0ef          	jal	80002f16 <argaddr>
  argint(2, &n);
    800056ce:	fe440593          	addi	a1,s0,-28
    800056d2:	4509                	li	a0,2
    800056d4:	827fd0ef          	jal	80002efa <argint>
  if(argfd(0, 0, &f) < 0)
    800056d8:	fe840613          	addi	a2,s0,-24
    800056dc:	4581                	li	a1,0
    800056de:	4501                	li	a0,0
    800056e0:	d77ff0ef          	jal	80005456 <argfd>
    800056e4:	87aa                	mv	a5,a0
    return -1;
    800056e6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800056e8:	0007ca63          	bltz	a5,800056fc <sys_write+0x40>
  return filewrite(f, p, n);
    800056ec:	fe442603          	lw	a2,-28(s0)
    800056f0:	fd843583          	ld	a1,-40(s0)
    800056f4:	fe843503          	ld	a0,-24(s0)
    800056f8:	d3cff0ef          	jal	80004c34 <filewrite>
}
    800056fc:	70a2                	ld	ra,40(sp)
    800056fe:	7402                	ld	s0,32(sp)
    80005700:	6145                	addi	sp,sp,48
    80005702:	8082                	ret

0000000080005704 <sys_close>:
{
    80005704:	1101                	addi	sp,sp,-32
    80005706:	ec06                	sd	ra,24(sp)
    80005708:	e822                	sd	s0,16(sp)
    8000570a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000570c:	fe040613          	addi	a2,s0,-32
    80005710:	fec40593          	addi	a1,s0,-20
    80005714:	4501                	li	a0,0
    80005716:	d41ff0ef          	jal	80005456 <argfd>
    return -1;
    8000571a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000571c:	02054163          	bltz	a0,8000573e <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80005720:	9f6fc0ef          	jal	80001916 <myproc>
    80005724:	fec42783          	lw	a5,-20(s0)
    80005728:	078e                	slli	a5,a5,0x3
    8000572a:	0d078793          	addi	a5,a5,208
    8000572e:	953e                	add	a0,a0,a5
    80005730:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005734:	fe043503          	ld	a0,-32(s0)
    80005738:	b14ff0ef          	jal	80004a4c <fileclose>
  return 0;
    8000573c:	4781                	li	a5,0
}
    8000573e:	853e                	mv	a0,a5
    80005740:	60e2                	ld	ra,24(sp)
    80005742:	6442                	ld	s0,16(sp)
    80005744:	6105                	addi	sp,sp,32
    80005746:	8082                	ret

0000000080005748 <sys_fstat>:
{
    80005748:	1101                	addi	sp,sp,-32
    8000574a:	ec06                	sd	ra,24(sp)
    8000574c:	e822                	sd	s0,16(sp)
    8000574e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005750:	fe040593          	addi	a1,s0,-32
    80005754:	4505                	li	a0,1
    80005756:	fc0fd0ef          	jal	80002f16 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000575a:	fe840613          	addi	a2,s0,-24
    8000575e:	4581                	li	a1,0
    80005760:	4501                	li	a0,0
    80005762:	cf5ff0ef          	jal	80005456 <argfd>
    80005766:	87aa                	mv	a5,a0
    return -1;
    80005768:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000576a:	0007c863          	bltz	a5,8000577a <sys_fstat+0x32>
  return filestat(f, st);
    8000576e:	fe043583          	ld	a1,-32(s0)
    80005772:	fe843503          	ld	a0,-24(s0)
    80005776:	b98ff0ef          	jal	80004b0e <filestat>
}
    8000577a:	60e2                	ld	ra,24(sp)
    8000577c:	6442                	ld	s0,16(sp)
    8000577e:	6105                	addi	sp,sp,32
    80005780:	8082                	ret

0000000080005782 <sys_link>:
{
    80005782:	7169                	addi	sp,sp,-304
    80005784:	f606                	sd	ra,296(sp)
    80005786:	f222                	sd	s0,288(sp)
    80005788:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000578a:	08000613          	li	a2,128
    8000578e:	ed040593          	addi	a1,s0,-304
    80005792:	4501                	li	a0,0
    80005794:	f9efd0ef          	jal	80002f32 <argstr>
    return -1;
    80005798:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000579a:	0c054e63          	bltz	a0,80005876 <sys_link+0xf4>
    8000579e:	08000613          	li	a2,128
    800057a2:	f5040593          	addi	a1,s0,-176
    800057a6:	4505                	li	a0,1
    800057a8:	f8afd0ef          	jal	80002f32 <argstr>
    return -1;
    800057ac:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057ae:	0c054463          	bltz	a0,80005876 <sys_link+0xf4>
    800057b2:	ee26                	sd	s1,280(sp)
  begin_op();
    800057b4:	cb9fe0ef          	jal	8000446c <begin_op>
  if((ip = namei(old)) == 0){
    800057b8:	ed040513          	addi	a0,s0,-304
    800057bc:	ad3fe0ef          	jal	8000428e <namei>
    800057c0:	84aa                	mv	s1,a0
    800057c2:	c53d                	beqz	a0,80005830 <sys_link+0xae>
  ilock(ip);
    800057c4:	a9cfe0ef          	jal	80003a60 <ilock>
  if(ip->type == T_DIR){
    800057c8:	04449703          	lh	a4,68(s1)
    800057cc:	4785                	li	a5,1
    800057ce:	06f70663          	beq	a4,a5,8000583a <sys_link+0xb8>
    800057d2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800057d4:	04a4d783          	lhu	a5,74(s1)
    800057d8:	2785                	addiw	a5,a5,1
    800057da:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057de:	8526                	mv	a0,s1
    800057e0:	9ccfe0ef          	jal	800039ac <iupdate>
  iunlock(ip);
    800057e4:	8526                	mv	a0,s1
    800057e6:	b28fe0ef          	jal	80003b0e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800057ea:	fd040593          	addi	a1,s0,-48
    800057ee:	f5040513          	addi	a0,s0,-176
    800057f2:	ab7fe0ef          	jal	800042a8 <nameiparent>
    800057f6:	892a                	mv	s2,a0
    800057f8:	cd21                	beqz	a0,80005850 <sys_link+0xce>
  ilock(dp);
    800057fa:	a66fe0ef          	jal	80003a60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800057fe:	854a                	mv	a0,s2
    80005800:	00092703          	lw	a4,0(s2)
    80005804:	409c                	lw	a5,0(s1)
    80005806:	04f71263          	bne	a4,a5,8000584a <sys_link+0xc8>
    8000580a:	40d0                	lw	a2,4(s1)
    8000580c:	fd040593          	addi	a1,s0,-48
    80005810:	9d5fe0ef          	jal	800041e4 <dirlink>
    80005814:	02054b63          	bltz	a0,8000584a <sys_link+0xc8>
  iunlockput(dp);
    80005818:	854a                	mv	a0,s2
    8000581a:	c52fe0ef          	jal	80003c6c <iunlockput>
  iput(ip);
    8000581e:	8526                	mv	a0,s1
    80005820:	bc2fe0ef          	jal	80003be2 <iput>
  end_op();
    80005824:	cb9fe0ef          	jal	800044dc <end_op>
  return 0;
    80005828:	4781                	li	a5,0
    8000582a:	64f2                	ld	s1,280(sp)
    8000582c:	6952                	ld	s2,272(sp)
    8000582e:	a0a1                	j	80005876 <sys_link+0xf4>
    end_op();
    80005830:	cadfe0ef          	jal	800044dc <end_op>
    return -1;
    80005834:	57fd                	li	a5,-1
    80005836:	64f2                	ld	s1,280(sp)
    80005838:	a83d                	j	80005876 <sys_link+0xf4>
    iunlockput(ip);
    8000583a:	8526                	mv	a0,s1
    8000583c:	c30fe0ef          	jal	80003c6c <iunlockput>
    end_op();
    80005840:	c9dfe0ef          	jal	800044dc <end_op>
    return -1;
    80005844:	57fd                	li	a5,-1
    80005846:	64f2                	ld	s1,280(sp)
    80005848:	a03d                	j	80005876 <sys_link+0xf4>
    iunlockput(dp);
    8000584a:	854a                	mv	a0,s2
    8000584c:	c20fe0ef          	jal	80003c6c <iunlockput>
  ilock(ip);
    80005850:	8526                	mv	a0,s1
    80005852:	a0efe0ef          	jal	80003a60 <ilock>
  ip->nlink--;
    80005856:	04a4d783          	lhu	a5,74(s1)
    8000585a:	37fd                	addiw	a5,a5,-1
    8000585c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005860:	8526                	mv	a0,s1
    80005862:	94afe0ef          	jal	800039ac <iupdate>
  iunlockput(ip);
    80005866:	8526                	mv	a0,s1
    80005868:	c04fe0ef          	jal	80003c6c <iunlockput>
  end_op();
    8000586c:	c71fe0ef          	jal	800044dc <end_op>
  return -1;
    80005870:	57fd                	li	a5,-1
    80005872:	64f2                	ld	s1,280(sp)
    80005874:	6952                	ld	s2,272(sp)
}
    80005876:	853e                	mv	a0,a5
    80005878:	70b2                	ld	ra,296(sp)
    8000587a:	7412                	ld	s0,288(sp)
    8000587c:	6155                	addi	sp,sp,304
    8000587e:	8082                	ret

0000000080005880 <sys_unlink>:
{
    80005880:	7151                	addi	sp,sp,-240
    80005882:	f586                	sd	ra,232(sp)
    80005884:	f1a2                	sd	s0,224(sp)
    80005886:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005888:	08000613          	li	a2,128
    8000588c:	f3040593          	addi	a1,s0,-208
    80005890:	4501                	li	a0,0
    80005892:	ea0fd0ef          	jal	80002f32 <argstr>
    80005896:	14054d63          	bltz	a0,800059f0 <sys_unlink+0x170>
    8000589a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000589c:	bd1fe0ef          	jal	8000446c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800058a0:	fb040593          	addi	a1,s0,-80
    800058a4:	f3040513          	addi	a0,s0,-208
    800058a8:	a01fe0ef          	jal	800042a8 <nameiparent>
    800058ac:	84aa                	mv	s1,a0
    800058ae:	c955                	beqz	a0,80005962 <sys_unlink+0xe2>
  ilock(dp);
    800058b0:	9b0fe0ef          	jal	80003a60 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800058b4:	00003597          	auipc	a1,0x3
    800058b8:	f7458593          	addi	a1,a1,-140 # 80008828 <etext+0x828>
    800058bc:	fb040513          	addi	a0,s0,-80
    800058c0:	f24fe0ef          	jal	80003fe4 <namecmp>
    800058c4:	10050b63          	beqz	a0,800059da <sys_unlink+0x15a>
    800058c8:	00003597          	auipc	a1,0x3
    800058cc:	f6858593          	addi	a1,a1,-152 # 80008830 <etext+0x830>
    800058d0:	fb040513          	addi	a0,s0,-80
    800058d4:	f10fe0ef          	jal	80003fe4 <namecmp>
    800058d8:	10050163          	beqz	a0,800059da <sys_unlink+0x15a>
    800058dc:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800058de:	f2c40613          	addi	a2,s0,-212
    800058e2:	fb040593          	addi	a1,s0,-80
    800058e6:	8526                	mv	a0,s1
    800058e8:	f12fe0ef          	jal	80003ffa <dirlookup>
    800058ec:	892a                	mv	s2,a0
    800058ee:	0e050563          	beqz	a0,800059d8 <sys_unlink+0x158>
    800058f2:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800058f4:	96cfe0ef          	jal	80003a60 <ilock>
  if(ip->nlink < 1)
    800058f8:	04a91783          	lh	a5,74(s2)
    800058fc:	06f05863          	blez	a5,8000596c <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005900:	04491703          	lh	a4,68(s2)
    80005904:	4785                	li	a5,1
    80005906:	06f70963          	beq	a4,a5,80005978 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    8000590a:	fc040993          	addi	s3,s0,-64
    8000590e:	4641                	li	a2,16
    80005910:	4581                	li	a1,0
    80005912:	854e                	mv	a0,s3
    80005914:	be4fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005918:	4741                	li	a4,16
    8000591a:	f2c42683          	lw	a3,-212(s0)
    8000591e:	864e                	mv	a2,s3
    80005920:	4581                	li	a1,0
    80005922:	8526                	mv	a0,s1
    80005924:	dc0fe0ef          	jal	80003ee4 <writei>
    80005928:	47c1                	li	a5,16
    8000592a:	08f51863          	bne	a0,a5,800059ba <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    8000592e:	04491703          	lh	a4,68(s2)
    80005932:	4785                	li	a5,1
    80005934:	08f70963          	beq	a4,a5,800059c6 <sys_unlink+0x146>
  iunlockput(dp);
    80005938:	8526                	mv	a0,s1
    8000593a:	b32fe0ef          	jal	80003c6c <iunlockput>
  ip->nlink--;
    8000593e:	04a95783          	lhu	a5,74(s2)
    80005942:	37fd                	addiw	a5,a5,-1
    80005944:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005948:	854a                	mv	a0,s2
    8000594a:	862fe0ef          	jal	800039ac <iupdate>
  iunlockput(ip);
    8000594e:	854a                	mv	a0,s2
    80005950:	b1cfe0ef          	jal	80003c6c <iunlockput>
  end_op();
    80005954:	b89fe0ef          	jal	800044dc <end_op>
  return 0;
    80005958:	4501                	li	a0,0
    8000595a:	64ee                	ld	s1,216(sp)
    8000595c:	694e                	ld	s2,208(sp)
    8000595e:	69ae                	ld	s3,200(sp)
    80005960:	a061                	j	800059e8 <sys_unlink+0x168>
    end_op();
    80005962:	b7bfe0ef          	jal	800044dc <end_op>
    return -1;
    80005966:	557d                	li	a0,-1
    80005968:	64ee                	ld	s1,216(sp)
    8000596a:	a8bd                	j	800059e8 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000596c:	00003517          	auipc	a0,0x3
    80005970:	ecc50513          	addi	a0,a0,-308 # 80008838 <etext+0x838>
    80005974:	eb1fa0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005978:	04c92703          	lw	a4,76(s2)
    8000597c:	02000793          	li	a5,32
    80005980:	f8e7f5e3          	bgeu	a5,a4,8000590a <sys_unlink+0x8a>
    80005984:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005986:	4741                	li	a4,16
    80005988:	86ce                	mv	a3,s3
    8000598a:	f1840613          	addi	a2,s0,-232
    8000598e:	4581                	li	a1,0
    80005990:	854a                	mv	a0,s2
    80005992:	c60fe0ef          	jal	80003df2 <readi>
    80005996:	47c1                	li	a5,16
    80005998:	00f51b63          	bne	a0,a5,800059ae <sys_unlink+0x12e>
    if(de.inum != 0)
    8000599c:	f1845783          	lhu	a5,-232(s0)
    800059a0:	ebb1                	bnez	a5,800059f4 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800059a2:	29c1                	addiw	s3,s3,16
    800059a4:	04c92783          	lw	a5,76(s2)
    800059a8:	fcf9efe3          	bltu	s3,a5,80005986 <sys_unlink+0x106>
    800059ac:	bfb9                	j	8000590a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800059ae:	00003517          	auipc	a0,0x3
    800059b2:	ea250513          	addi	a0,a0,-350 # 80008850 <etext+0x850>
    800059b6:	e6ffa0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    800059ba:	00003517          	auipc	a0,0x3
    800059be:	eae50513          	addi	a0,a0,-338 # 80008868 <etext+0x868>
    800059c2:	e63fa0ef          	jal	80000824 <panic>
    dp->nlink--;
    800059c6:	04a4d783          	lhu	a5,74(s1)
    800059ca:	37fd                	addiw	a5,a5,-1
    800059cc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800059d0:	8526                	mv	a0,s1
    800059d2:	fdbfd0ef          	jal	800039ac <iupdate>
    800059d6:	b78d                	j	80005938 <sys_unlink+0xb8>
    800059d8:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800059da:	8526                	mv	a0,s1
    800059dc:	a90fe0ef          	jal	80003c6c <iunlockput>
  end_op();
    800059e0:	afdfe0ef          	jal	800044dc <end_op>
  return -1;
    800059e4:	557d                	li	a0,-1
    800059e6:	64ee                	ld	s1,216(sp)
}
    800059e8:	70ae                	ld	ra,232(sp)
    800059ea:	740e                	ld	s0,224(sp)
    800059ec:	616d                	addi	sp,sp,240
    800059ee:	8082                	ret
    return -1;
    800059f0:	557d                	li	a0,-1
    800059f2:	bfdd                	j	800059e8 <sys_unlink+0x168>
    iunlockput(ip);
    800059f4:	854a                	mv	a0,s2
    800059f6:	a76fe0ef          	jal	80003c6c <iunlockput>
    goto bad;
    800059fa:	694e                	ld	s2,208(sp)
    800059fc:	69ae                	ld	s3,200(sp)
    800059fe:	bff1                	j	800059da <sys_unlink+0x15a>

0000000080005a00 <sys_open>:

uint64
sys_open(void)
{
    80005a00:	7131                	addi	sp,sp,-192
    80005a02:	fd06                	sd	ra,184(sp)
    80005a04:	f922                	sd	s0,176(sp)
    80005a06:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005a08:	f4c40593          	addi	a1,s0,-180
    80005a0c:	4505                	li	a0,1
    80005a0e:	cecfd0ef          	jal	80002efa <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005a12:	08000613          	li	a2,128
    80005a16:	f5040593          	addi	a1,s0,-176
    80005a1a:	4501                	li	a0,0
    80005a1c:	d16fd0ef          	jal	80002f32 <argstr>
    80005a20:	87aa                	mv	a5,a0
    return -1;
    80005a22:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005a24:	0a07c363          	bltz	a5,80005aca <sys_open+0xca>
    80005a28:	f526                	sd	s1,168(sp)

  begin_op();
    80005a2a:	a43fe0ef          	jal	8000446c <begin_op>

  if(omode & O_CREATE){
    80005a2e:	f4c42783          	lw	a5,-180(s0)
    80005a32:	2007f793          	andi	a5,a5,512
    80005a36:	c3dd                	beqz	a5,80005adc <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80005a38:	4681                	li	a3,0
    80005a3a:	4601                	li	a2,0
    80005a3c:	4589                	li	a1,2
    80005a3e:	f5040513          	addi	a0,s0,-176
    80005a42:	aafff0ef          	jal	800054f0 <create>
    80005a46:	84aa                	mv	s1,a0
    if(ip == 0){
    80005a48:	c549                	beqz	a0,80005ad2 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005a4a:	04449703          	lh	a4,68(s1)
    80005a4e:	478d                	li	a5,3
    80005a50:	00f71763          	bne	a4,a5,80005a5e <sys_open+0x5e>
    80005a54:	0464d703          	lhu	a4,70(s1)
    80005a58:	47a5                	li	a5,9
    80005a5a:	0ae7ee63          	bltu	a5,a4,80005b16 <sys_open+0x116>
    80005a5e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005a60:	f49fe0ef          	jal	800049a8 <filealloc>
    80005a64:	892a                	mv	s2,a0
    80005a66:	c561                	beqz	a0,80005b2e <sys_open+0x12e>
    80005a68:	ed4e                	sd	s3,152(sp)
    80005a6a:	a47ff0ef          	jal	800054b0 <fdalloc>
    80005a6e:	89aa                	mv	s3,a0
    80005a70:	0a054b63          	bltz	a0,80005b26 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005a74:	04449703          	lh	a4,68(s1)
    80005a78:	478d                	li	a5,3
    80005a7a:	0cf70363          	beq	a4,a5,80005b40 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005a7e:	4789                	li	a5,2
    80005a80:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005a84:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005a88:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005a8c:	f4c42783          	lw	a5,-180(s0)
    80005a90:	0017f713          	andi	a4,a5,1
    80005a94:	00174713          	xori	a4,a4,1
    80005a98:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005a9c:	0037f713          	andi	a4,a5,3
    80005aa0:	00e03733          	snez	a4,a4
    80005aa4:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005aa8:	4007f793          	andi	a5,a5,1024
    80005aac:	c791                	beqz	a5,80005ab8 <sys_open+0xb8>
    80005aae:	04449703          	lh	a4,68(s1)
    80005ab2:	4789                	li	a5,2
    80005ab4:	08f70d63          	beq	a4,a5,80005b4e <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005ab8:	8526                	mv	a0,s1
    80005aba:	854fe0ef          	jal	80003b0e <iunlock>
  end_op();
    80005abe:	a1ffe0ef          	jal	800044dc <end_op>

  return fd;
    80005ac2:	854e                	mv	a0,s3
    80005ac4:	74aa                	ld	s1,168(sp)
    80005ac6:	790a                	ld	s2,160(sp)
    80005ac8:	69ea                	ld	s3,152(sp)
}
    80005aca:	70ea                	ld	ra,184(sp)
    80005acc:	744a                	ld	s0,176(sp)
    80005ace:	6129                	addi	sp,sp,192
    80005ad0:	8082                	ret
      end_op();
    80005ad2:	a0bfe0ef          	jal	800044dc <end_op>
      return -1;
    80005ad6:	557d                	li	a0,-1
    80005ad8:	74aa                	ld	s1,168(sp)
    80005ada:	bfc5                	j	80005aca <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80005adc:	f5040513          	addi	a0,s0,-176
    80005ae0:	faefe0ef          	jal	8000428e <namei>
    80005ae4:	84aa                	mv	s1,a0
    80005ae6:	c11d                	beqz	a0,80005b0c <sys_open+0x10c>
    ilock(ip);
    80005ae8:	f79fd0ef          	jal	80003a60 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005aec:	04449703          	lh	a4,68(s1)
    80005af0:	4785                	li	a5,1
    80005af2:	f4f71ce3          	bne	a4,a5,80005a4a <sys_open+0x4a>
    80005af6:	f4c42783          	lw	a5,-180(s0)
    80005afa:	d3b5                	beqz	a5,80005a5e <sys_open+0x5e>
      iunlockput(ip);
    80005afc:	8526                	mv	a0,s1
    80005afe:	96efe0ef          	jal	80003c6c <iunlockput>
      end_op();
    80005b02:	9dbfe0ef          	jal	800044dc <end_op>
      return -1;
    80005b06:	557d                	li	a0,-1
    80005b08:	74aa                	ld	s1,168(sp)
    80005b0a:	b7c1                	j	80005aca <sys_open+0xca>
      end_op();
    80005b0c:	9d1fe0ef          	jal	800044dc <end_op>
      return -1;
    80005b10:	557d                	li	a0,-1
    80005b12:	74aa                	ld	s1,168(sp)
    80005b14:	bf5d                	j	80005aca <sys_open+0xca>
    iunlockput(ip);
    80005b16:	8526                	mv	a0,s1
    80005b18:	954fe0ef          	jal	80003c6c <iunlockput>
    end_op();
    80005b1c:	9c1fe0ef          	jal	800044dc <end_op>
    return -1;
    80005b20:	557d                	li	a0,-1
    80005b22:	74aa                	ld	s1,168(sp)
    80005b24:	b75d                	j	80005aca <sys_open+0xca>
      fileclose(f);
    80005b26:	854a                	mv	a0,s2
    80005b28:	f25fe0ef          	jal	80004a4c <fileclose>
    80005b2c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005b2e:	8526                	mv	a0,s1
    80005b30:	93cfe0ef          	jal	80003c6c <iunlockput>
    end_op();
    80005b34:	9a9fe0ef          	jal	800044dc <end_op>
    return -1;
    80005b38:	557d                	li	a0,-1
    80005b3a:	74aa                	ld	s1,168(sp)
    80005b3c:	790a                	ld	s2,160(sp)
    80005b3e:	b771                	j	80005aca <sys_open+0xca>
    f->type = FD_DEVICE;
    80005b40:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005b44:	04649783          	lh	a5,70(s1)
    80005b48:	02f91223          	sh	a5,36(s2)
    80005b4c:	bf35                	j	80005a88 <sys_open+0x88>
    itrunc(ip);
    80005b4e:	8526                	mv	a0,s1
    80005b50:	ffffd0ef          	jal	80003b4e <itrunc>
    80005b54:	b795                	j	80005ab8 <sys_open+0xb8>

0000000080005b56 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005b56:	7175                	addi	sp,sp,-144
    80005b58:	e506                	sd	ra,136(sp)
    80005b5a:	e122                	sd	s0,128(sp)
    80005b5c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005b5e:	90ffe0ef          	jal	8000446c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005b62:	08000613          	li	a2,128
    80005b66:	f7040593          	addi	a1,s0,-144
    80005b6a:	4501                	li	a0,0
    80005b6c:	bc6fd0ef          	jal	80002f32 <argstr>
    80005b70:	02054363          	bltz	a0,80005b96 <sys_mkdir+0x40>
    80005b74:	4681                	li	a3,0
    80005b76:	4601                	li	a2,0
    80005b78:	4585                	li	a1,1
    80005b7a:	f7040513          	addi	a0,s0,-144
    80005b7e:	973ff0ef          	jal	800054f0 <create>
    80005b82:	c911                	beqz	a0,80005b96 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b84:	8e8fe0ef          	jal	80003c6c <iunlockput>
  end_op();
    80005b88:	955fe0ef          	jal	800044dc <end_op>
  return 0;
    80005b8c:	4501                	li	a0,0
}
    80005b8e:	60aa                	ld	ra,136(sp)
    80005b90:	640a                	ld	s0,128(sp)
    80005b92:	6149                	addi	sp,sp,144
    80005b94:	8082                	ret
    end_op();
    80005b96:	947fe0ef          	jal	800044dc <end_op>
    return -1;
    80005b9a:	557d                	li	a0,-1
    80005b9c:	bfcd                	j	80005b8e <sys_mkdir+0x38>

0000000080005b9e <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b9e:	7135                	addi	sp,sp,-160
    80005ba0:	ed06                	sd	ra,152(sp)
    80005ba2:	e922                	sd	s0,144(sp)
    80005ba4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005ba6:	8c7fe0ef          	jal	8000446c <begin_op>
  argint(1, &major);
    80005baa:	f6c40593          	addi	a1,s0,-148
    80005bae:	4505                	li	a0,1
    80005bb0:	b4afd0ef          	jal	80002efa <argint>
  argint(2, &minor);
    80005bb4:	f6840593          	addi	a1,s0,-152
    80005bb8:	4509                	li	a0,2
    80005bba:	b40fd0ef          	jal	80002efa <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005bbe:	08000613          	li	a2,128
    80005bc2:	f7040593          	addi	a1,s0,-144
    80005bc6:	4501                	li	a0,0
    80005bc8:	b6afd0ef          	jal	80002f32 <argstr>
    80005bcc:	02054563          	bltz	a0,80005bf6 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005bd0:	f6841683          	lh	a3,-152(s0)
    80005bd4:	f6c41603          	lh	a2,-148(s0)
    80005bd8:	458d                	li	a1,3
    80005bda:	f7040513          	addi	a0,s0,-144
    80005bde:	913ff0ef          	jal	800054f0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005be2:	c911                	beqz	a0,80005bf6 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005be4:	888fe0ef          	jal	80003c6c <iunlockput>
  end_op();
    80005be8:	8f5fe0ef          	jal	800044dc <end_op>
  return 0;
    80005bec:	4501                	li	a0,0
}
    80005bee:	60ea                	ld	ra,152(sp)
    80005bf0:	644a                	ld	s0,144(sp)
    80005bf2:	610d                	addi	sp,sp,160
    80005bf4:	8082                	ret
    end_op();
    80005bf6:	8e7fe0ef          	jal	800044dc <end_op>
    return -1;
    80005bfa:	557d                	li	a0,-1
    80005bfc:	bfcd                	j	80005bee <sys_mknod+0x50>

0000000080005bfe <sys_chdir>:

uint64
sys_chdir(void)
{
    80005bfe:	7135                	addi	sp,sp,-160
    80005c00:	ed06                	sd	ra,152(sp)
    80005c02:	e922                	sd	s0,144(sp)
    80005c04:	e14a                	sd	s2,128(sp)
    80005c06:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005c08:	d0ffb0ef          	jal	80001916 <myproc>
    80005c0c:	892a                	mv	s2,a0
  
  begin_op();
    80005c0e:	85ffe0ef          	jal	8000446c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005c12:	08000613          	li	a2,128
    80005c16:	f6040593          	addi	a1,s0,-160
    80005c1a:	4501                	li	a0,0
    80005c1c:	b16fd0ef          	jal	80002f32 <argstr>
    80005c20:	04054363          	bltz	a0,80005c66 <sys_chdir+0x68>
    80005c24:	e526                	sd	s1,136(sp)
    80005c26:	f6040513          	addi	a0,s0,-160
    80005c2a:	e64fe0ef          	jal	8000428e <namei>
    80005c2e:	84aa                	mv	s1,a0
    80005c30:	c915                	beqz	a0,80005c64 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005c32:	e2ffd0ef          	jal	80003a60 <ilock>
  if(ip->type != T_DIR){
    80005c36:	04449703          	lh	a4,68(s1)
    80005c3a:	4785                	li	a5,1
    80005c3c:	02f71963          	bne	a4,a5,80005c6e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005c40:	8526                	mv	a0,s1
    80005c42:	ecdfd0ef          	jal	80003b0e <iunlock>
  iput(p->cwd);
    80005c46:	15093503          	ld	a0,336(s2)
    80005c4a:	f99fd0ef          	jal	80003be2 <iput>
  end_op();
    80005c4e:	88ffe0ef          	jal	800044dc <end_op>
  p->cwd = ip;
    80005c52:	14993823          	sd	s1,336(s2)
  return 0;
    80005c56:	4501                	li	a0,0
    80005c58:	64aa                	ld	s1,136(sp)
}
    80005c5a:	60ea                	ld	ra,152(sp)
    80005c5c:	644a                	ld	s0,144(sp)
    80005c5e:	690a                	ld	s2,128(sp)
    80005c60:	610d                	addi	sp,sp,160
    80005c62:	8082                	ret
    80005c64:	64aa                	ld	s1,136(sp)
    end_op();
    80005c66:	877fe0ef          	jal	800044dc <end_op>
    return -1;
    80005c6a:	557d                	li	a0,-1
    80005c6c:	b7fd                	j	80005c5a <sys_chdir+0x5c>
    iunlockput(ip);
    80005c6e:	8526                	mv	a0,s1
    80005c70:	ffdfd0ef          	jal	80003c6c <iunlockput>
    end_op();
    80005c74:	869fe0ef          	jal	800044dc <end_op>
    return -1;
    80005c78:	557d                	li	a0,-1
    80005c7a:	64aa                	ld	s1,136(sp)
    80005c7c:	bff9                	j	80005c5a <sys_chdir+0x5c>

0000000080005c7e <sys_exec>:

uint64
sys_exec(void)
{
    80005c7e:	7105                	addi	sp,sp,-480
    80005c80:	ef86                	sd	ra,472(sp)
    80005c82:	eba2                	sd	s0,464(sp)
    80005c84:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005c86:	e2840593          	addi	a1,s0,-472
    80005c8a:	4505                	li	a0,1
    80005c8c:	a8afd0ef          	jal	80002f16 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005c90:	08000613          	li	a2,128
    80005c94:	f3040593          	addi	a1,s0,-208
    80005c98:	4501                	li	a0,0
    80005c9a:	a98fd0ef          	jal	80002f32 <argstr>
    80005c9e:	87aa                	mv	a5,a0
    return -1;
    80005ca0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005ca2:	0e07c063          	bltz	a5,80005d82 <sys_exec+0x104>
    80005ca6:	e7a6                	sd	s1,456(sp)
    80005ca8:	e3ca                	sd	s2,448(sp)
    80005caa:	ff4e                	sd	s3,440(sp)
    80005cac:	fb52                	sd	s4,432(sp)
    80005cae:	f756                	sd	s5,424(sp)
    80005cb0:	f35a                	sd	s6,416(sp)
    80005cb2:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005cb4:	e3040a13          	addi	s4,s0,-464
    80005cb8:	10000613          	li	a2,256
    80005cbc:	4581                	li	a1,0
    80005cbe:	8552                	mv	a0,s4
    80005cc0:	838fb0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005cc4:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005cc6:	89d2                	mv	s3,s4
    80005cc8:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005cca:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005cce:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005cd0:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005cd4:	00391513          	slli	a0,s2,0x3
    80005cd8:	85d6                	mv	a1,s5
    80005cda:	e2843783          	ld	a5,-472(s0)
    80005cde:	953e                	add	a0,a0,a5
    80005ce0:	990fd0ef          	jal	80002e70 <fetchaddr>
    80005ce4:	02054663          	bltz	a0,80005d10 <sys_exec+0x92>
    if(uarg == 0){
    80005ce8:	e2043783          	ld	a5,-480(s0)
    80005cec:	c7a1                	beqz	a5,80005d34 <sys_exec+0xb6>
    argv[i] = kalloc();
    80005cee:	e57fa0ef          	jal	80000b44 <kalloc>
    80005cf2:	85aa                	mv	a1,a0
    80005cf4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005cf8:	cd01                	beqz	a0,80005d10 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005cfa:	865a                	mv	a2,s6
    80005cfc:	e2043503          	ld	a0,-480(s0)
    80005d00:	9bafd0ef          	jal	80002eba <fetchstr>
    80005d04:	00054663          	bltz	a0,80005d10 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80005d08:	0905                	addi	s2,s2,1
    80005d0a:	09a1                	addi	s3,s3,8
    80005d0c:	fd7914e3          	bne	s2,s7,80005cd4 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d10:	100a0a13          	addi	s4,s4,256
    80005d14:	6088                	ld	a0,0(s1)
    80005d16:	cd31                	beqz	a0,80005d72 <sys_exec+0xf4>
    kfree(argv[i]);
    80005d18:	d45fa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d1c:	04a1                	addi	s1,s1,8
    80005d1e:	ff449be3          	bne	s1,s4,80005d14 <sys_exec+0x96>
  return -1;
    80005d22:	557d                	li	a0,-1
    80005d24:	64be                	ld	s1,456(sp)
    80005d26:	691e                	ld	s2,448(sp)
    80005d28:	79fa                	ld	s3,440(sp)
    80005d2a:	7a5a                	ld	s4,432(sp)
    80005d2c:	7aba                	ld	s5,424(sp)
    80005d2e:	7b1a                	ld	s6,416(sp)
    80005d30:	6bfa                	ld	s7,408(sp)
    80005d32:	a881                	j	80005d82 <sys_exec+0x104>
      argv[i] = 0;
    80005d34:	0009079b          	sext.w	a5,s2
    80005d38:	e3040593          	addi	a1,s0,-464
    80005d3c:	078e                	slli	a5,a5,0x3
    80005d3e:	97ae                	add	a5,a5,a1
    80005d40:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005d44:	f3040513          	addi	a0,s0,-208
    80005d48:	bb2ff0ef          	jal	800050fa <kexec>
    80005d4c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d4e:	100a0a13          	addi	s4,s4,256
    80005d52:	6088                	ld	a0,0(s1)
    80005d54:	c511                	beqz	a0,80005d60 <sys_exec+0xe2>
    kfree(argv[i]);
    80005d56:	d07fa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d5a:	04a1                	addi	s1,s1,8
    80005d5c:	ff449be3          	bne	s1,s4,80005d52 <sys_exec+0xd4>
  return ret;
    80005d60:	854a                	mv	a0,s2
    80005d62:	64be                	ld	s1,456(sp)
    80005d64:	691e                	ld	s2,448(sp)
    80005d66:	79fa                	ld	s3,440(sp)
    80005d68:	7a5a                	ld	s4,432(sp)
    80005d6a:	7aba                	ld	s5,424(sp)
    80005d6c:	7b1a                	ld	s6,416(sp)
    80005d6e:	6bfa                	ld	s7,408(sp)
    80005d70:	a809                	j	80005d82 <sys_exec+0x104>
  return -1;
    80005d72:	557d                	li	a0,-1
    80005d74:	64be                	ld	s1,456(sp)
    80005d76:	691e                	ld	s2,448(sp)
    80005d78:	79fa                	ld	s3,440(sp)
    80005d7a:	7a5a                	ld	s4,432(sp)
    80005d7c:	7aba                	ld	s5,424(sp)
    80005d7e:	7b1a                	ld	s6,416(sp)
    80005d80:	6bfa                	ld	s7,408(sp)
}
    80005d82:	60fe                	ld	ra,472(sp)
    80005d84:	645e                	ld	s0,464(sp)
    80005d86:	613d                	addi	sp,sp,480
    80005d88:	8082                	ret

0000000080005d8a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005d8a:	7139                	addi	sp,sp,-64
    80005d8c:	fc06                	sd	ra,56(sp)
    80005d8e:	f822                	sd	s0,48(sp)
    80005d90:	f426                	sd	s1,40(sp)
    80005d92:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005d94:	b83fb0ef          	jal	80001916 <myproc>
    80005d98:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005d9a:	fd840593          	addi	a1,s0,-40
    80005d9e:	4501                	li	a0,0
    80005da0:	976fd0ef          	jal	80002f16 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005da4:	fc840593          	addi	a1,s0,-56
    80005da8:	fd040513          	addi	a0,s0,-48
    80005dac:	ff7fe0ef          	jal	80004da2 <pipealloc>
    return -1;
    80005db0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005db2:	0a054763          	bltz	a0,80005e60 <sys_pipe+0xd6>
  fd0 = -1;
    80005db6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005dba:	fd043503          	ld	a0,-48(s0)
    80005dbe:	ef2ff0ef          	jal	800054b0 <fdalloc>
    80005dc2:	fca42223          	sw	a0,-60(s0)
    80005dc6:	08054463          	bltz	a0,80005e4e <sys_pipe+0xc4>
    80005dca:	fc843503          	ld	a0,-56(s0)
    80005dce:	ee2ff0ef          	jal	800054b0 <fdalloc>
    80005dd2:	fca42023          	sw	a0,-64(s0)
    80005dd6:	06054263          	bltz	a0,80005e3a <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005dda:	4691                	li	a3,4
    80005ddc:	fc440613          	addi	a2,s0,-60
    80005de0:	fd843583          	ld	a1,-40(s0)
    80005de4:	68a8                	ld	a0,80(s1)
    80005de6:	86ffb0ef          	jal	80001654 <copyout>
    80005dea:	00054e63          	bltz	a0,80005e06 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005dee:	4691                	li	a3,4
    80005df0:	fc040613          	addi	a2,s0,-64
    80005df4:	fd843583          	ld	a1,-40(s0)
    80005df8:	95b6                	add	a1,a1,a3
    80005dfa:	68a8                	ld	a0,80(s1)
    80005dfc:	859fb0ef          	jal	80001654 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e00:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e02:	04055f63          	bgez	a0,80005e60 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80005e06:	fc442783          	lw	a5,-60(s0)
    80005e0a:	078e                	slli	a5,a5,0x3
    80005e0c:	0d078793          	addi	a5,a5,208
    80005e10:	97a6                	add	a5,a5,s1
    80005e12:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005e16:	fc042783          	lw	a5,-64(s0)
    80005e1a:	078e                	slli	a5,a5,0x3
    80005e1c:	0d078793          	addi	a5,a5,208
    80005e20:	97a6                	add	a5,a5,s1
    80005e22:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005e26:	fd043503          	ld	a0,-48(s0)
    80005e2a:	c23fe0ef          	jal	80004a4c <fileclose>
    fileclose(wf);
    80005e2e:	fc843503          	ld	a0,-56(s0)
    80005e32:	c1bfe0ef          	jal	80004a4c <fileclose>
    return -1;
    80005e36:	57fd                	li	a5,-1
    80005e38:	a025                	j	80005e60 <sys_pipe+0xd6>
    if(fd0 >= 0)
    80005e3a:	fc442783          	lw	a5,-60(s0)
    80005e3e:	0007c863          	bltz	a5,80005e4e <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80005e42:	078e                	slli	a5,a5,0x3
    80005e44:	0d078793          	addi	a5,a5,208
    80005e48:	97a6                	add	a5,a5,s1
    80005e4a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005e4e:	fd043503          	ld	a0,-48(s0)
    80005e52:	bfbfe0ef          	jal	80004a4c <fileclose>
    fileclose(wf);
    80005e56:	fc843503          	ld	a0,-56(s0)
    80005e5a:	bf3fe0ef          	jal	80004a4c <fileclose>
    return -1;
    80005e5e:	57fd                	li	a5,-1
}
    80005e60:	853e                	mv	a0,a5
    80005e62:	70e2                	ld	ra,56(sp)
    80005e64:	7442                	ld	s0,48(sp)
    80005e66:	74a2                	ld	s1,40(sp)
    80005e68:	6121                	addi	sp,sp,64
    80005e6a:	8082                	ret
    80005e6c:	0000                	unimp
	...

0000000080005e70 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005e70:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005e72:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005e74:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005e76:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005e78:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005e7a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80005e7c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80005e7e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005e80:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005e82:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005e84:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005e86:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005e88:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005e8a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80005e8c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80005e8e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005e90:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005e92:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005e94:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005e96:	ee9fc0ef          	jal	80002d7e <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005e9a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80005e9c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80005e9e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005ea0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005ea2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005ea4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005ea6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005ea8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005eaa:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80005eac:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80005eae:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005eb0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005eb2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005eb4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005eb6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005eb8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005eba:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80005ebc:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80005ebe:	10200073          	sret
    80005ec2:	00000013          	nop
    80005ec6:	00000013          	nop
    80005eca:	00000013          	nop

0000000080005ece <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005ece:	1141                	addi	sp,sp,-16
    80005ed0:	e406                	sd	ra,8(sp)
    80005ed2:	e022                	sd	s0,0(sp)
    80005ed4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005ed6:	0c000737          	lui	a4,0xc000
    80005eda:	4785                	li	a5,1
    80005edc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005ede:	c35c                	sw	a5,4(a4)
}
    80005ee0:	60a2                	ld	ra,8(sp)
    80005ee2:	6402                	ld	s0,0(sp)
    80005ee4:	0141                	addi	sp,sp,16
    80005ee6:	8082                	ret

0000000080005ee8 <plicinithart>:

void
plicinithart(void)
{
    80005ee8:	1141                	addi	sp,sp,-16
    80005eea:	e406                	sd	ra,8(sp)
    80005eec:	e022                	sd	s0,0(sp)
    80005eee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005ef0:	9f3fb0ef          	jal	800018e2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005ef4:	0085171b          	slliw	a4,a0,0x8
    80005ef8:	0c0027b7          	lui	a5,0xc002
    80005efc:	97ba                	add	a5,a5,a4
    80005efe:	40200713          	li	a4,1026
    80005f02:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005f06:	00d5151b          	slliw	a0,a0,0xd
    80005f0a:	0c2017b7          	lui	a5,0xc201
    80005f0e:	97aa                	add	a5,a5,a0
    80005f10:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005f14:	60a2                	ld	ra,8(sp)
    80005f16:	6402                	ld	s0,0(sp)
    80005f18:	0141                	addi	sp,sp,16
    80005f1a:	8082                	ret

0000000080005f1c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005f1c:	1141                	addi	sp,sp,-16
    80005f1e:	e406                	sd	ra,8(sp)
    80005f20:	e022                	sd	s0,0(sp)
    80005f22:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f24:	9bffb0ef          	jal	800018e2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005f28:	00d5151b          	slliw	a0,a0,0xd
    80005f2c:	0c2017b7          	lui	a5,0xc201
    80005f30:	97aa                	add	a5,a5,a0
  return irq;
}
    80005f32:	43c8                	lw	a0,4(a5)
    80005f34:	60a2                	ld	ra,8(sp)
    80005f36:	6402                	ld	s0,0(sp)
    80005f38:	0141                	addi	sp,sp,16
    80005f3a:	8082                	ret

0000000080005f3c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005f3c:	1101                	addi	sp,sp,-32
    80005f3e:	ec06                	sd	ra,24(sp)
    80005f40:	e822                	sd	s0,16(sp)
    80005f42:	e426                	sd	s1,8(sp)
    80005f44:	1000                	addi	s0,sp,32
    80005f46:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005f48:	99bfb0ef          	jal	800018e2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005f4c:	00d5179b          	slliw	a5,a0,0xd
    80005f50:	0c201737          	lui	a4,0xc201
    80005f54:	97ba                	add	a5,a5,a4
    80005f56:	c3c4                	sw	s1,4(a5)
}
    80005f58:	60e2                	ld	ra,24(sp)
    80005f5a:	6442                	ld	s0,16(sp)
    80005f5c:	64a2                	ld	s1,8(sp)
    80005f5e:	6105                	addi	sp,sp,32
    80005f60:	8082                	ret

0000000080005f62 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005f62:	1141                	addi	sp,sp,-16
    80005f64:	e406                	sd	ra,8(sp)
    80005f66:	e022                	sd	s0,0(sp)
    80005f68:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005f6a:	479d                	li	a5,7
    80005f6c:	04a7ca63          	blt	a5,a0,80005fc0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005f70:	0001e797          	auipc	a5,0x1e
    80005f74:	bd878793          	addi	a5,a5,-1064 # 80023b48 <disk>
    80005f78:	97aa                	add	a5,a5,a0
    80005f7a:	0187c783          	lbu	a5,24(a5)
    80005f7e:	e7b9                	bnez	a5,80005fcc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005f80:	00451693          	slli	a3,a0,0x4
    80005f84:	0001e797          	auipc	a5,0x1e
    80005f88:	bc478793          	addi	a5,a5,-1084 # 80023b48 <disk>
    80005f8c:	6398                	ld	a4,0(a5)
    80005f8e:	9736                	add	a4,a4,a3
    80005f90:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005f94:	6398                	ld	a4,0(a5)
    80005f96:	9736                	add	a4,a4,a3
    80005f98:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005f9c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005fa0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005fa4:	97aa                	add	a5,a5,a0
    80005fa6:	4705                	li	a4,1
    80005fa8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005fac:	0001e517          	auipc	a0,0x1e
    80005fb0:	bb450513          	addi	a0,a0,-1100 # 80023b60 <disk+0x18>
    80005fb4:	9b2fc0ef          	jal	80002166 <wakeup>
}
    80005fb8:	60a2                	ld	ra,8(sp)
    80005fba:	6402                	ld	s0,0(sp)
    80005fbc:	0141                	addi	sp,sp,16
    80005fbe:	8082                	ret
    panic("free_desc 1");
    80005fc0:	00003517          	auipc	a0,0x3
    80005fc4:	8b850513          	addi	a0,a0,-1864 # 80008878 <etext+0x878>
    80005fc8:	85dfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    80005fcc:	00003517          	auipc	a0,0x3
    80005fd0:	8bc50513          	addi	a0,a0,-1860 # 80008888 <etext+0x888>
    80005fd4:	851fa0ef          	jal	80000824 <panic>

0000000080005fd8 <virtio_disk_init>:
{
    80005fd8:	1101                	addi	sp,sp,-32
    80005fda:	ec06                	sd	ra,24(sp)
    80005fdc:	e822                	sd	s0,16(sp)
    80005fde:	e426                	sd	s1,8(sp)
    80005fe0:	e04a                	sd	s2,0(sp)
    80005fe2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005fe4:	00003597          	auipc	a1,0x3
    80005fe8:	8b458593          	addi	a1,a1,-1868 # 80008898 <etext+0x898>
    80005fec:	0001e517          	auipc	a0,0x1e
    80005ff0:	c8450513          	addi	a0,a0,-892 # 80023c70 <disk+0x128>
    80005ff4:	babfa0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ff8:	100017b7          	lui	a5,0x10001
    80005ffc:	4398                	lw	a4,0(a5)
    80005ffe:	2701                	sext.w	a4,a4
    80006000:	747277b7          	lui	a5,0x74727
    80006004:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006008:	14f71863          	bne	a4,a5,80006158 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000600c:	100017b7          	lui	a5,0x10001
    80006010:	43dc                	lw	a5,4(a5)
    80006012:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006014:	4709                	li	a4,2
    80006016:	14e79163          	bne	a5,a4,80006158 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000601a:	100017b7          	lui	a5,0x10001
    8000601e:	479c                	lw	a5,8(a5)
    80006020:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006022:	12e79b63          	bne	a5,a4,80006158 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006026:	100017b7          	lui	a5,0x10001
    8000602a:	47d8                	lw	a4,12(a5)
    8000602c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000602e:	554d47b7          	lui	a5,0x554d4
    80006032:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006036:	12f71163          	bne	a4,a5,80006158 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000603a:	100017b7          	lui	a5,0x10001
    8000603e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006042:	4705                	li	a4,1
    80006044:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006046:	470d                	li	a4,3
    80006048:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000604a:	10001737          	lui	a4,0x10001
    8000604e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006050:	c7ffe6b7          	lui	a3,0xc7ffe
    80006054:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdaad7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006058:	8f75                	and	a4,a4,a3
    8000605a:	100016b7          	lui	a3,0x10001
    8000605e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006060:	472d                	li	a4,11
    80006062:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006064:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006068:	439c                	lw	a5,0(a5)
    8000606a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000606e:	8ba1                	andi	a5,a5,8
    80006070:	0e078a63          	beqz	a5,80006164 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006074:	100017b7          	lui	a5,0x10001
    80006078:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000607c:	43fc                	lw	a5,68(a5)
    8000607e:	2781                	sext.w	a5,a5
    80006080:	0e079863          	bnez	a5,80006170 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006084:	100017b7          	lui	a5,0x10001
    80006088:	5bdc                	lw	a5,52(a5)
    8000608a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000608c:	0e078863          	beqz	a5,8000617c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80006090:	471d                	li	a4,7
    80006092:	0ef77b63          	bgeu	a4,a5,80006188 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80006096:	aaffa0ef          	jal	80000b44 <kalloc>
    8000609a:	0001e497          	auipc	s1,0x1e
    8000609e:	aae48493          	addi	s1,s1,-1362 # 80023b48 <disk>
    800060a2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800060a4:	aa1fa0ef          	jal	80000b44 <kalloc>
    800060a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800060aa:	a9bfa0ef          	jal	80000b44 <kalloc>
    800060ae:	87aa                	mv	a5,a0
    800060b0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800060b2:	6088                	ld	a0,0(s1)
    800060b4:	0e050063          	beqz	a0,80006194 <virtio_disk_init+0x1bc>
    800060b8:	0001e717          	auipc	a4,0x1e
    800060bc:	a9873703          	ld	a4,-1384(a4) # 80023b50 <disk+0x8>
    800060c0:	cb71                	beqz	a4,80006194 <virtio_disk_init+0x1bc>
    800060c2:	cbe9                	beqz	a5,80006194 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800060c4:	6605                	lui	a2,0x1
    800060c6:	4581                	li	a1,0
    800060c8:	c31fa0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    800060cc:	0001e497          	auipc	s1,0x1e
    800060d0:	a7c48493          	addi	s1,s1,-1412 # 80023b48 <disk>
    800060d4:	6605                	lui	a2,0x1
    800060d6:	4581                	li	a1,0
    800060d8:	6488                	ld	a0,8(s1)
    800060da:	c1ffa0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    800060de:	6605                	lui	a2,0x1
    800060e0:	4581                	li	a1,0
    800060e2:	6888                	ld	a0,16(s1)
    800060e4:	c15fa0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800060e8:	100017b7          	lui	a5,0x10001
    800060ec:	4721                	li	a4,8
    800060ee:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800060f0:	4098                	lw	a4,0(s1)
    800060f2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800060f6:	40d8                	lw	a4,4(s1)
    800060f8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800060fc:	649c                	ld	a5,8(s1)
    800060fe:	0007869b          	sext.w	a3,a5
    80006102:	10001737          	lui	a4,0x10001
    80006106:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000610a:	9781                	srai	a5,a5,0x20
    8000610c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006110:	689c                	ld	a5,16(s1)
    80006112:	0007869b          	sext.w	a3,a5
    80006116:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000611a:	9781                	srai	a5,a5,0x20
    8000611c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006120:	4785                	li	a5,1
    80006122:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006124:	00f48c23          	sb	a5,24(s1)
    80006128:	00f48ca3          	sb	a5,25(s1)
    8000612c:	00f48d23          	sb	a5,26(s1)
    80006130:	00f48da3          	sb	a5,27(s1)
    80006134:	00f48e23          	sb	a5,28(s1)
    80006138:	00f48ea3          	sb	a5,29(s1)
    8000613c:	00f48f23          	sb	a5,30(s1)
    80006140:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006144:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006148:	07272823          	sw	s2,112(a4)
}
    8000614c:	60e2                	ld	ra,24(sp)
    8000614e:	6442                	ld	s0,16(sp)
    80006150:	64a2                	ld	s1,8(sp)
    80006152:	6902                	ld	s2,0(sp)
    80006154:	6105                	addi	sp,sp,32
    80006156:	8082                	ret
    panic("could not find virtio disk");
    80006158:	00002517          	auipc	a0,0x2
    8000615c:	75050513          	addi	a0,a0,1872 # 800088a8 <etext+0x8a8>
    80006160:	ec4fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006164:	00002517          	auipc	a0,0x2
    80006168:	76450513          	addi	a0,a0,1892 # 800088c8 <etext+0x8c8>
    8000616c:	eb8fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80006170:	00002517          	auipc	a0,0x2
    80006174:	77850513          	addi	a0,a0,1912 # 800088e8 <etext+0x8e8>
    80006178:	eacfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    8000617c:	00002517          	auipc	a0,0x2
    80006180:	78c50513          	addi	a0,a0,1932 # 80008908 <etext+0x908>
    80006184:	ea0fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80006188:	00002517          	auipc	a0,0x2
    8000618c:	7a050513          	addi	a0,a0,1952 # 80008928 <etext+0x928>
    80006190:	e94fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80006194:	00002517          	auipc	a0,0x2
    80006198:	7b450513          	addi	a0,a0,1972 # 80008948 <etext+0x948>
    8000619c:	e88fa0ef          	jal	80000824 <panic>

00000000800061a0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800061a0:	711d                	addi	sp,sp,-96
    800061a2:	ec86                	sd	ra,88(sp)
    800061a4:	e8a2                	sd	s0,80(sp)
    800061a6:	e4a6                	sd	s1,72(sp)
    800061a8:	e0ca                	sd	s2,64(sp)
    800061aa:	fc4e                	sd	s3,56(sp)
    800061ac:	f852                	sd	s4,48(sp)
    800061ae:	f456                	sd	s5,40(sp)
    800061b0:	f05a                	sd	s6,32(sp)
    800061b2:	ec5e                	sd	s7,24(sp)
    800061b4:	e862                	sd	s8,16(sp)
    800061b6:	1080                	addi	s0,sp,96
    800061b8:	89aa                	mv	s3,a0
    800061ba:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800061bc:	00c52b83          	lw	s7,12(a0)
    800061c0:	001b9b9b          	slliw	s7,s7,0x1
    800061c4:	1b82                	slli	s7,s7,0x20
    800061c6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800061ca:	0001e517          	auipc	a0,0x1e
    800061ce:	aa650513          	addi	a0,a0,-1370 # 80023c70 <disk+0x128>
    800061d2:	a57fa0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    800061d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800061d8:	0001ea97          	auipc	s5,0x1e
    800061dc:	970a8a93          	addi	s5,s5,-1680 # 80023b48 <disk>
  for(int i = 0; i < 3; i++){
    800061e0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800061e2:	5c7d                	li	s8,-1
    800061e4:	a095                	j	80006248 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800061e6:	00fa8733          	add	a4,s5,a5
    800061ea:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800061ee:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800061f0:	0207c563          	bltz	a5,8000621a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    800061f4:	2905                	addiw	s2,s2,1
    800061f6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800061f8:	05490c63          	beq	s2,s4,80006250 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800061fc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800061fe:	0001e717          	auipc	a4,0x1e
    80006202:	94a70713          	addi	a4,a4,-1718 # 80023b48 <disk>
    80006206:	4781                	li	a5,0
    if(disk.free[i]){
    80006208:	01874683          	lbu	a3,24(a4)
    8000620c:	fee9                	bnez	a3,800061e6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8000620e:	2785                	addiw	a5,a5,1
    80006210:	0705                	addi	a4,a4,1
    80006212:	fe979be3          	bne	a5,s1,80006208 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80006216:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8000621a:	01205d63          	blez	s2,80006234 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000621e:	fa042503          	lw	a0,-96(s0)
    80006222:	d41ff0ef          	jal	80005f62 <free_desc>
      for(int j = 0; j < i; j++)
    80006226:	4785                	li	a5,1
    80006228:	0127d663          	bge	a5,s2,80006234 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000622c:	fa442503          	lw	a0,-92(s0)
    80006230:	d33ff0ef          	jal	80005f62 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006234:	0001e597          	auipc	a1,0x1e
    80006238:	a3c58593          	addi	a1,a1,-1476 # 80023c70 <disk+0x128>
    8000623c:	0001e517          	auipc	a0,0x1e
    80006240:	92450513          	addi	a0,a0,-1756 # 80023b60 <disk+0x18>
    80006244:	ed7fb0ef          	jal	8000211a <sleep>
  for(int i = 0; i < 3; i++){
    80006248:	fa040613          	addi	a2,s0,-96
    8000624c:	4901                	li	s2,0
    8000624e:	b77d                	j	800061fc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006250:	fa042503          	lw	a0,-96(s0)
    80006254:	00451693          	slli	a3,a0,0x4

  if(write)
    80006258:	0001e797          	auipc	a5,0x1e
    8000625c:	8f078793          	addi	a5,a5,-1808 # 80023b48 <disk>
    80006260:	00451713          	slli	a4,a0,0x4
    80006264:	0a070713          	addi	a4,a4,160
    80006268:	973e                	add	a4,a4,a5
    8000626a:	01603633          	snez	a2,s6
    8000626e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006270:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006274:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006278:	6398                	ld	a4,0(a5)
    8000627a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000627c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006280:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006282:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006284:	6390                	ld	a2,0(a5)
    80006286:	00d60833          	add	a6,a2,a3
    8000628a:	4741                	li	a4,16
    8000628c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006290:	4585                	li	a1,1
    80006292:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80006296:	fa442703          	lw	a4,-92(s0)
    8000629a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000629e:	0712                	slli	a4,a4,0x4
    800062a0:	963a                	add	a2,a2,a4
    800062a2:	05898813          	addi	a6,s3,88
    800062a6:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800062aa:	0007b883          	ld	a7,0(a5)
    800062ae:	9746                	add	a4,a4,a7
    800062b0:	40000613          	li	a2,1024
    800062b4:	c710                	sw	a2,8(a4)
  if(write)
    800062b6:	001b3613          	seqz	a2,s6
    800062ba:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800062be:	8e4d                	or	a2,a2,a1
    800062c0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800062c4:	fa842603          	lw	a2,-88(s0)
    800062c8:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800062cc:	00451813          	slli	a6,a0,0x4
    800062d0:	02080813          	addi	a6,a6,32
    800062d4:	983e                	add	a6,a6,a5
    800062d6:	577d                	li	a4,-1
    800062d8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800062dc:	0612                	slli	a2,a2,0x4
    800062de:	98b2                	add	a7,a7,a2
    800062e0:	03068713          	addi	a4,a3,48
    800062e4:	973e                	add	a4,a4,a5
    800062e6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800062ea:	6398                	ld	a4,0(a5)
    800062ec:	9732                	add	a4,a4,a2
    800062ee:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800062f0:	4689                	li	a3,2
    800062f2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800062f6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800062fa:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    800062fe:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006302:	6794                	ld	a3,8(a5)
    80006304:	0026d703          	lhu	a4,2(a3)
    80006308:	8b1d                	andi	a4,a4,7
    8000630a:	0706                	slli	a4,a4,0x1
    8000630c:	96ba                	add	a3,a3,a4
    8000630e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006312:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006316:	6798                	ld	a4,8(a5)
    80006318:	00275783          	lhu	a5,2(a4)
    8000631c:	2785                	addiw	a5,a5,1
    8000631e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006322:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006326:	100017b7          	lui	a5,0x10001
    8000632a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000632e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006332:	0001e917          	auipc	s2,0x1e
    80006336:	93e90913          	addi	s2,s2,-1730 # 80023c70 <disk+0x128>
  while(b->disk == 1) {
    8000633a:	84ae                	mv	s1,a1
    8000633c:	00b79a63          	bne	a5,a1,80006350 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80006340:	85ca                	mv	a1,s2
    80006342:	854e                	mv	a0,s3
    80006344:	dd7fb0ef          	jal	8000211a <sleep>
  while(b->disk == 1) {
    80006348:	0049a783          	lw	a5,4(s3)
    8000634c:	fe978ae3          	beq	a5,s1,80006340 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80006350:	fa042903          	lw	s2,-96(s0)
    80006354:	00491713          	slli	a4,s2,0x4
    80006358:	02070713          	addi	a4,a4,32
    8000635c:	0001d797          	auipc	a5,0x1d
    80006360:	7ec78793          	addi	a5,a5,2028 # 80023b48 <disk>
    80006364:	97ba                	add	a5,a5,a4
    80006366:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000636a:	0001d997          	auipc	s3,0x1d
    8000636e:	7de98993          	addi	s3,s3,2014 # 80023b48 <disk>
    80006372:	00491713          	slli	a4,s2,0x4
    80006376:	0009b783          	ld	a5,0(s3)
    8000637a:	97ba                	add	a5,a5,a4
    8000637c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006380:	854a                	mv	a0,s2
    80006382:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006386:	bddff0ef          	jal	80005f62 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000638a:	8885                	andi	s1,s1,1
    8000638c:	f0fd                	bnez	s1,80006372 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000638e:	0001e517          	auipc	a0,0x1e
    80006392:	8e250513          	addi	a0,a0,-1822 # 80023c70 <disk+0x128>
    80006396:	927fa0ef          	jal	80000cbc <release>
}
    8000639a:	60e6                	ld	ra,88(sp)
    8000639c:	6446                	ld	s0,80(sp)
    8000639e:	64a6                	ld	s1,72(sp)
    800063a0:	6906                	ld	s2,64(sp)
    800063a2:	79e2                	ld	s3,56(sp)
    800063a4:	7a42                	ld	s4,48(sp)
    800063a6:	7aa2                	ld	s5,40(sp)
    800063a8:	7b02                	ld	s6,32(sp)
    800063aa:	6be2                	ld	s7,24(sp)
    800063ac:	6c42                	ld	s8,16(sp)
    800063ae:	6125                	addi	sp,sp,96
    800063b0:	8082                	ret

00000000800063b2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800063b2:	1101                	addi	sp,sp,-32
    800063b4:	ec06                	sd	ra,24(sp)
    800063b6:	e822                	sd	s0,16(sp)
    800063b8:	e426                	sd	s1,8(sp)
    800063ba:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800063bc:	0001d497          	auipc	s1,0x1d
    800063c0:	78c48493          	addi	s1,s1,1932 # 80023b48 <disk>
    800063c4:	0001e517          	auipc	a0,0x1e
    800063c8:	8ac50513          	addi	a0,a0,-1876 # 80023c70 <disk+0x128>
    800063cc:	85dfa0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800063d0:	100017b7          	lui	a5,0x10001
    800063d4:	53bc                	lw	a5,96(a5)
    800063d6:	8b8d                	andi	a5,a5,3
    800063d8:	10001737          	lui	a4,0x10001
    800063dc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800063de:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800063e2:	689c                	ld	a5,16(s1)
    800063e4:	0204d703          	lhu	a4,32(s1)
    800063e8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800063ec:	04f70863          	beq	a4,a5,8000643c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800063f0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800063f4:	6898                	ld	a4,16(s1)
    800063f6:	0204d783          	lhu	a5,32(s1)
    800063fa:	8b9d                	andi	a5,a5,7
    800063fc:	078e                	slli	a5,a5,0x3
    800063fe:	97ba                	add	a5,a5,a4
    80006400:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006402:	00479713          	slli	a4,a5,0x4
    80006406:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000640a:	9726                	add	a4,a4,s1
    8000640c:	01074703          	lbu	a4,16(a4)
    80006410:	e329                	bnez	a4,80006452 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006412:	0792                	slli	a5,a5,0x4
    80006414:	02078793          	addi	a5,a5,32
    80006418:	97a6                	add	a5,a5,s1
    8000641a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000641c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006420:	d47fb0ef          	jal	80002166 <wakeup>

    disk.used_idx += 1;
    80006424:	0204d783          	lhu	a5,32(s1)
    80006428:	2785                	addiw	a5,a5,1
    8000642a:	17c2                	slli	a5,a5,0x30
    8000642c:	93c1                	srli	a5,a5,0x30
    8000642e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006432:	6898                	ld	a4,16(s1)
    80006434:	00275703          	lhu	a4,2(a4)
    80006438:	faf71ce3          	bne	a4,a5,800063f0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000643c:	0001e517          	auipc	a0,0x1e
    80006440:	83450513          	addi	a0,a0,-1996 # 80023c70 <disk+0x128>
    80006444:	879fa0ef          	jal	80000cbc <release>
}
    80006448:	60e2                	ld	ra,24(sp)
    8000644a:	6442                	ld	s0,16(sp)
    8000644c:	64a2                	ld	s1,8(sp)
    8000644e:	6105                	addi	sp,sp,32
    80006450:	8082                	ret
      panic("virtio_disk_intr status");
    80006452:	00002517          	auipc	a0,0x2
    80006456:	50e50513          	addi	a0,a0,1294 # 80008960 <etext+0x960>
    8000645a:	bcafa0ef          	jal	80000824 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
