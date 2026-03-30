
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	73813103          	ld	sp,1848(sp) # 8000b738 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000016:	04a000ef          	jal	80000060 <start>

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
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd7f17>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	dbc78793          	addi	a5,a5,-580 # 80000e3c <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a2:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	7119                	addi	sp,sp,-128
    800000d2:	fc86                	sd	ra,120(sp)
    800000d4:	f8a2                	sd	s0,112(sp)
    800000d6:	f4a6                	sd	s1,104(sp)
    800000d8:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while(i < n){
    800000da:	06c05a63          	blez	a2,8000014e <consolewrite+0x7e>
    800000de:	f0ca                	sd	s2,96(sp)
    800000e0:	ecce                	sd	s3,88(sp)
    800000e2:	e8d2                	sd	s4,80(sp)
    800000e4:	e4d6                	sd	s5,72(sp)
    800000e6:	e0da                	sd	s6,64(sp)
    800000e8:	fc5e                	sd	s7,56(sp)
    800000ea:	f862                	sd	s8,48(sp)
    800000ec:	f466                	sd	s9,40(sp)
    800000ee:	8aaa                	mv	s5,a0
    800000f0:	8b2e                	mv	s6,a1
    800000f2:	8a32                	mv	s4,a2
  int i = 0;
    800000f4:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000f6:	02000c13          	li	s8,32
    800000fa:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800000fe:	5bfd                	li	s7,-1
    80000100:	a035                	j	8000012c <consolewrite+0x5c>
    if(nn > n - i)
    80000102:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000106:	86ce                	mv	a3,s3
    80000108:	01648633          	add	a2,s1,s6
    8000010c:	85d6                	mv	a1,s5
    8000010e:	f8040513          	addi	a0,s0,-128
    80000112:	2f6020ef          	jal	80002408 <either_copyin>
    80000116:	03750e63          	beq	a0,s7,80000152 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    8000011a:	85ce                	mv	a1,s3
    8000011c:	f8040513          	addi	a0,s0,-128
    80000120:	778000ef          	jal	80000898 <uartwrite>
    i += nn;
    80000124:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80000128:	0144da63          	bge	s1,s4,8000013c <consolewrite+0x6c>
    if(nn > n - i)
    8000012c:	409a093b          	subw	s2,s4,s1
    80000130:	0009079b          	sext.w	a5,s2
    80000134:	fcfc57e3          	bge	s8,a5,80000102 <consolewrite+0x32>
    80000138:	8966                	mv	s2,s9
    8000013a:	b7e1                	j	80000102 <consolewrite+0x32>
    8000013c:	7906                	ld	s2,96(sp)
    8000013e:	69e6                	ld	s3,88(sp)
    80000140:	6a46                	ld	s4,80(sp)
    80000142:	6aa6                	ld	s5,72(sp)
    80000144:	6b06                	ld	s6,64(sp)
    80000146:	7be2                	ld	s7,56(sp)
    80000148:	7c42                	ld	s8,48(sp)
    8000014a:	7ca2                	ld	s9,40(sp)
    8000014c:	a819                	j	80000162 <consolewrite+0x92>
  int i = 0;
    8000014e:	4481                	li	s1,0
    80000150:	a809                	j	80000162 <consolewrite+0x92>
    80000152:	7906                	ld	s2,96(sp)
    80000154:	69e6                	ld	s3,88(sp)
    80000156:	6a46                	ld	s4,80(sp)
    80000158:	6aa6                	ld	s5,72(sp)
    8000015a:	6b06                	ld	s6,64(sp)
    8000015c:	7be2                	ld	s7,56(sp)
    8000015e:	7c42                	ld	s8,48(sp)
    80000160:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80000162:	8526                	mv	a0,s1
    80000164:	70e6                	ld	ra,120(sp)
    80000166:	7446                	ld	s0,112(sp)
    80000168:	74a6                	ld	s1,104(sp)
    8000016a:	6109                	addi	sp,sp,128
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018c:	00013517          	auipc	a0,0x13
    80000190:	5f450513          	addi	a0,a0,1524 # 80013780 <cons>
    80000194:	23b000ef          	jal	80000bce <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000198:	00013497          	auipc	s1,0x13
    8000019c:	5e848493          	addi	s1,s1,1512 # 80013780 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a0:	00013917          	auipc	s2,0x13
    800001a4:	67890913          	addi	s2,s2,1656 # 80013818 <cons+0x98>
  while(n > 0){
    800001a8:	0b305d63          	blez	s3,80000262 <consoleread+0xf4>
    while(cons.r == cons.w){
    800001ac:	0984a783          	lw	a5,152(s1)
    800001b0:	09c4a703          	lw	a4,156(s1)
    800001b4:	0af71263          	bne	a4,a5,80000258 <consoleread+0xea>
      if(killed(myproc())){
    800001b8:	716010ef          	jal	800018ce <myproc>
    800001bc:	0cc020ef          	jal	80002288 <killed>
    800001c0:	e12d                	bnez	a0,80000222 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    800001c2:	85a6                	mv	a1,s1
    800001c4:	854a                	mv	a0,s2
    800001c6:	68b010ef          	jal	80002050 <sleep>
    while(cons.r == cons.w){
    800001ca:	0984a783          	lw	a5,152(s1)
    800001ce:	09c4a703          	lw	a4,156(s1)
    800001d2:	fef703e3          	beq	a4,a5,800001b8 <consoleread+0x4a>
    800001d6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001d8:	00013717          	auipc	a4,0x13
    800001dc:	5a870713          	addi	a4,a4,1448 # 80013780 <cons>
    800001e0:	0017869b          	addiw	a3,a5,1
    800001e4:	08d72c23          	sw	a3,152(a4)
    800001e8:	07f7f693          	andi	a3,a5,127
    800001ec:	9736                	add	a4,a4,a3
    800001ee:	01874703          	lbu	a4,24(a4)
    800001f2:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001f6:	4691                	li	a3,4
    800001f8:	04db8663          	beq	s7,a3,80000244 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001fc:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000200:	4685                	li	a3,1
    80000202:	faf40613          	addi	a2,s0,-81
    80000206:	85d2                	mv	a1,s4
    80000208:	8556                	mv	a0,s5
    8000020a:	1b4020ef          	jal	800023be <either_copyout>
    8000020e:	57fd                	li	a5,-1
    80000210:	04f50863          	beq	a0,a5,80000260 <consoleread+0xf2>
      break;

    dst++;
    80000214:	0a05                	addi	s4,s4,1
    --n;
    80000216:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80000218:	47a9                	li	a5,10
    8000021a:	04fb8d63          	beq	s7,a5,80000274 <consoleread+0x106>
    8000021e:	6be2                	ld	s7,24(sp)
    80000220:	b761                	j	800001a8 <consoleread+0x3a>
        release(&cons.lock);
    80000222:	00013517          	auipc	a0,0x13
    80000226:	55e50513          	addi	a0,a0,1374 # 80013780 <cons>
    8000022a:	23d000ef          	jal	80000c66 <release>
        return -1;
    8000022e:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000230:	60e6                	ld	ra,88(sp)
    80000232:	6446                	ld	s0,80(sp)
    80000234:	64a6                	ld	s1,72(sp)
    80000236:	6906                	ld	s2,64(sp)
    80000238:	79e2                	ld	s3,56(sp)
    8000023a:	7a42                	ld	s4,48(sp)
    8000023c:	7aa2                	ld	s5,40(sp)
    8000023e:	7b02                	ld	s6,32(sp)
    80000240:	6125                	addi	sp,sp,96
    80000242:	8082                	ret
      if(n < target){
    80000244:	0009871b          	sext.w	a4,s3
    80000248:	01677a63          	bgeu	a4,s6,8000025c <consoleread+0xee>
        cons.r--;
    8000024c:	00013717          	auipc	a4,0x13
    80000250:	5cf72623          	sw	a5,1484(a4) # 80013818 <cons+0x98>
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	a031                	j	80000262 <consoleread+0xf4>
    80000258:	ec5e                	sd	s7,24(sp)
    8000025a:	bfbd                	j	800001d8 <consoleread+0x6a>
    8000025c:	6be2                	ld	s7,24(sp)
    8000025e:	a011                	j	80000262 <consoleread+0xf4>
    80000260:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000262:	00013517          	auipc	a0,0x13
    80000266:	51e50513          	addi	a0,a0,1310 # 80013780 <cons>
    8000026a:	1fd000ef          	jal	80000c66 <release>
  return target - n;
    8000026e:	413b053b          	subw	a0,s6,s3
    80000272:	bf7d                	j	80000230 <consoleread+0xc2>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	b7f5                	j	80000262 <consoleread+0xf4>

0000000080000278 <consputc>:
{
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e406                	sd	ra,8(sp)
    8000027c:	e022                	sd	s0,0(sp)
    8000027e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000280:	10000793          	li	a5,256
    80000284:	00f50863          	beq	a0,a5,80000294 <consputc+0x1c>
    uartputc_sync(c);
    80000288:	6a4000ef          	jal	8000092c <uartputc_sync>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000294:	4521                	li	a0,8
    80000296:	696000ef          	jal	8000092c <uartputc_sync>
    8000029a:	02000513          	li	a0,32
    8000029e:	68e000ef          	jal	8000092c <uartputc_sync>
    800002a2:	4521                	li	a0,8
    800002a4:	688000ef          	jal	8000092c <uartputc_sync>
    800002a8:	b7d5                	j	8000028c <consputc+0x14>

00000000800002aa <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002aa:	1101                	addi	sp,sp,-32
    800002ac:	ec06                	sd	ra,24(sp)
    800002ae:	e822                	sd	s0,16(sp)
    800002b0:	e426                	sd	s1,8(sp)
    800002b2:	1000                	addi	s0,sp,32
    800002b4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b6:	00013517          	auipc	a0,0x13
    800002ba:	4ca50513          	addi	a0,a0,1226 # 80013780 <cons>
    800002be:	111000ef          	jal	80000bce <acquire>

  switch(c){
    800002c2:	47d5                	li	a5,21
    800002c4:	08f48f63          	beq	s1,a5,80000362 <consoleintr+0xb8>
    800002c8:	0297c563          	blt	a5,s1,800002f2 <consoleintr+0x48>
    800002cc:	47a1                	li	a5,8
    800002ce:	0ef48463          	beq	s1,a5,800003b6 <consoleintr+0x10c>
    800002d2:	47c1                	li	a5,16
    800002d4:	10f49563          	bne	s1,a5,800003de <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002d8:	17a020ef          	jal	80002452 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002dc:	00013517          	auipc	a0,0x13
    800002e0:	4a450513          	addi	a0,a0,1188 # 80013780 <cons>
    800002e4:	183000ef          	jal	80000c66 <release>
}
    800002e8:	60e2                	ld	ra,24(sp)
    800002ea:	6442                	ld	s0,16(sp)
    800002ec:	64a2                	ld	s1,8(sp)
    800002ee:	6105                	addi	sp,sp,32
    800002f0:	8082                	ret
  switch(c){
    800002f2:	07f00793          	li	a5,127
    800002f6:	0cf48063          	beq	s1,a5,800003b6 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fa:	00013717          	auipc	a4,0x13
    800002fe:	48670713          	addi	a4,a4,1158 # 80013780 <cons>
    80000302:	0a072783          	lw	a5,160(a4)
    80000306:	09872703          	lw	a4,152(a4)
    8000030a:	9f99                	subw	a5,a5,a4
    8000030c:	07f00713          	li	a4,127
    80000310:	fcf766e3          	bltu	a4,a5,800002dc <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000314:	47b5                	li	a5,13
    80000316:	0cf48763          	beq	s1,a5,800003e4 <consoleintr+0x13a>
      consputc(c);
    8000031a:	8526                	mv	a0,s1
    8000031c:	f5dff0ef          	jal	80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000320:	00013797          	auipc	a5,0x13
    80000324:	46078793          	addi	a5,a5,1120 # 80013780 <cons>
    80000328:	0a07a683          	lw	a3,160(a5)
    8000032c:	0016871b          	addiw	a4,a3,1
    80000330:	0007061b          	sext.w	a2,a4
    80000334:	0ae7a023          	sw	a4,160(a5)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	97b6                	add	a5,a5,a3
    8000033e:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	47a9                	li	a5,10
    80000344:	0cf48563          	beq	s1,a5,8000040e <consoleintr+0x164>
    80000348:	4791                	li	a5,4
    8000034a:	0cf48263          	beq	s1,a5,8000040e <consoleintr+0x164>
    8000034e:	00013797          	auipc	a5,0x13
    80000352:	4ca7a783          	lw	a5,1226(a5) # 80013818 <cons+0x98>
    80000356:	9f1d                	subw	a4,a4,a5
    80000358:	08000793          	li	a5,128
    8000035c:	f8f710e3          	bne	a4,a5,800002dc <consoleintr+0x32>
    80000360:	a07d                	j	8000040e <consoleintr+0x164>
    80000362:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000364:	00013717          	auipc	a4,0x13
    80000368:	41c70713          	addi	a4,a4,1052 # 80013780 <cons>
    8000036c:	0a072783          	lw	a5,160(a4)
    80000370:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000374:	00013497          	auipc	s1,0x13
    80000378:	40c48493          	addi	s1,s1,1036 # 80013780 <cons>
    while(cons.e != cons.w &&
    8000037c:	4929                	li	s2,10
    8000037e:	02f70863          	beq	a4,a5,800003ae <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000382:	37fd                	addiw	a5,a5,-1
    80000384:	07f7f713          	andi	a4,a5,127
    80000388:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000038a:	01874703          	lbu	a4,24(a4)
    8000038e:	03270263          	beq	a4,s2,800003b2 <consoleintr+0x108>
      cons.e--;
    80000392:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000396:	10000513          	li	a0,256
    8000039a:	edfff0ef          	jal	80000278 <consputc>
    while(cons.e != cons.w &&
    8000039e:	0a04a783          	lw	a5,160(s1)
    800003a2:	09c4a703          	lw	a4,156(s1)
    800003a6:	fcf71ee3          	bne	a4,a5,80000382 <consoleintr+0xd8>
    800003aa:	6902                	ld	s2,0(sp)
    800003ac:	bf05                	j	800002dc <consoleintr+0x32>
    800003ae:	6902                	ld	s2,0(sp)
    800003b0:	b735                	j	800002dc <consoleintr+0x32>
    800003b2:	6902                	ld	s2,0(sp)
    800003b4:	b725                	j	800002dc <consoleintr+0x32>
    if(cons.e != cons.w){
    800003b6:	00013717          	auipc	a4,0x13
    800003ba:	3ca70713          	addi	a4,a4,970 # 80013780 <cons>
    800003be:	0a072783          	lw	a5,160(a4)
    800003c2:	09c72703          	lw	a4,156(a4)
    800003c6:	f0f70be3          	beq	a4,a5,800002dc <consoleintr+0x32>
      cons.e--;
    800003ca:	37fd                	addiw	a5,a5,-1
    800003cc:	00013717          	auipc	a4,0x13
    800003d0:	44f72a23          	sw	a5,1108(a4) # 80013820 <cons+0xa0>
      consputc(BACKSPACE);
    800003d4:	10000513          	li	a0,256
    800003d8:	ea1ff0ef          	jal	80000278 <consputc>
    800003dc:	b701                	j	800002dc <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003de:	ee048fe3          	beqz	s1,800002dc <consoleintr+0x32>
    800003e2:	bf21                	j	800002fa <consoleintr+0x50>
      consputc(c);
    800003e4:	4529                	li	a0,10
    800003e6:	e93ff0ef          	jal	80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003ea:	00013797          	auipc	a5,0x13
    800003ee:	39678793          	addi	a5,a5,918 # 80013780 <cons>
    800003f2:	0a07a703          	lw	a4,160(a5)
    800003f6:	0017069b          	addiw	a3,a4,1
    800003fa:	0006861b          	sext.w	a2,a3
    800003fe:	0ad7a023          	sw	a3,160(a5)
    80000402:	07f77713          	andi	a4,a4,127
    80000406:	97ba                	add	a5,a5,a4
    80000408:	4729                	li	a4,10
    8000040a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040e:	00013797          	auipc	a5,0x13
    80000412:	40c7a723          	sw	a2,1038(a5) # 8001381c <cons+0x9c>
        wakeup(&cons.r);
    80000416:	00013517          	auipc	a0,0x13
    8000041a:	40250513          	addi	a0,a0,1026 # 80013818 <cons+0x98>
    8000041e:	47f010ef          	jal	8000209c <wakeup>
    80000422:	bd6d                	j	800002dc <consoleintr+0x32>

0000000080000424 <consoleinit>:

void
consoleinit(void)
{
    80000424:	1141                	addi	sp,sp,-16
    80000426:	e406                	sd	ra,8(sp)
    80000428:	e022                	sd	s0,0(sp)
    8000042a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000042c:	00008597          	auipc	a1,0x8
    80000430:	bd458593          	addi	a1,a1,-1068 # 80008000 <etext>
    80000434:	00013517          	auipc	a0,0x13
    80000438:	34c50513          	addi	a0,a0,844 # 80013780 <cons>
    8000043c:	712000ef          	jal	80000b4e <initlock>

  uartinit();
    80000440:	400000ef          	jal	80000840 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000444:	00025797          	auipc	a5,0x25
    80000448:	30c78793          	addi	a5,a5,780 # 80025750 <devsw>
    8000044c:	00000717          	auipc	a4,0x0
    80000450:	d2270713          	addi	a4,a4,-734 # 8000016e <consoleread>
    80000454:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000456:	00000717          	auipc	a4,0x0
    8000045a:	c7a70713          	addi	a4,a4,-902 # 800000d0 <consolewrite>
    8000045e:	ef98                	sd	a4,24(a5)
}
    80000460:	60a2                	ld	ra,8(sp)
    80000462:	6402                	ld	s0,0(sp)
    80000464:	0141                	addi	sp,sp,16
    80000466:	8082                	ret

0000000080000468 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000468:	7139                	addi	sp,sp,-64
    8000046a:	fc06                	sd	ra,56(sp)
    8000046c:	f822                	sd	s0,48(sp)
    8000046e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000470:	c219                	beqz	a2,80000476 <printint+0xe>
    80000472:	08054063          	bltz	a0,800004f2 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80000476:	4881                	li	a7,0
    80000478:	fc840693          	addi	a3,s0,-56

  i = 0;
    8000047c:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000047e:	00008617          	auipc	a2,0x8
    80000482:	4fa60613          	addi	a2,a2,1274 # 80008978 <digits>
    80000486:	883e                	mv	a6,a5
    80000488:	2785                	addiw	a5,a5,1
    8000048a:	02b57733          	remu	a4,a0,a1
    8000048e:	9732                	add	a4,a4,a2
    80000490:	00074703          	lbu	a4,0(a4)
    80000494:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000498:	872a                	mv	a4,a0
    8000049a:	02b55533          	divu	a0,a0,a1
    8000049e:	0685                	addi	a3,a3,1
    800004a0:	feb773e3          	bgeu	a4,a1,80000486 <printint+0x1e>

  if(sign)
    800004a4:	00088a63          	beqz	a7,800004b8 <printint+0x50>
    buf[i++] = '-';
    800004a8:	1781                	addi	a5,a5,-32
    800004aa:	97a2                	add	a5,a5,s0
    800004ac:	02d00713          	li	a4,45
    800004b0:	fee78423          	sb	a4,-24(a5)
    800004b4:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800004b8:	02f05963          	blez	a5,800004ea <printint+0x82>
    800004bc:	f426                	sd	s1,40(sp)
    800004be:	f04a                	sd	s2,32(sp)
    800004c0:	fc840713          	addi	a4,s0,-56
    800004c4:	00f704b3          	add	s1,a4,a5
    800004c8:	fff70913          	addi	s2,a4,-1
    800004cc:	993e                	add	s2,s2,a5
    800004ce:	37fd                	addiw	a5,a5,-1
    800004d0:	1782                	slli	a5,a5,0x20
    800004d2:	9381                	srli	a5,a5,0x20
    800004d4:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004d8:	fff4c503          	lbu	a0,-1(s1)
    800004dc:	d9dff0ef          	jal	80000278 <consputc>
  while(--i >= 0)
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	ff249be3          	bne	s1,s2,800004d8 <printint+0x70>
    800004e6:	74a2                	ld	s1,40(sp)
    800004e8:	7902                	ld	s2,32(sp)
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4885                	li	a7,1
    x = -xx;
    800004f8:	b741                	j	80000478 <printint+0x10>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	e8d2                	sd	s4,80(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	8a2a                	mv	s4,a0
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
    80000518:	0000b797          	auipc	a5,0xb
    8000051c:	23c7a783          	lw	a5,572(a5) # 8000b754 <panicking>
    80000520:	c3a1                	beqz	a5,80000560 <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	000a4503          	lbu	a0,0(s4)
    8000052e:	28050763          	beqz	a0,800007bc <printf+0x2c2>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	f0ca                	sd	s2,96(sp)
    80000536:	ecce                	sd	s3,88(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	f862                	sd	s8,48(sp)
    8000053e:	f466                	sd	s9,40(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4981                	li	s3,0
    if(cx != '%'){
    80000546:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000054a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000054e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000552:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000556:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000055a:	07000d93          	li	s11,112
    8000055e:	a01d                	j	80000584 <printf+0x8a>
    acquire(&pr.lock);
    80000560:	00013517          	auipc	a0,0x13
    80000564:	2c850513          	addi	a0,a0,712 # 80013828 <pr>
    80000568:	666000ef          	jal	80000bce <acquire>
    8000056c:	bf5d                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056e:	d0bff0ef          	jal	80000278 <consputc>
      continue;
    80000572:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000574:	0014899b          	addiw	s3,s1,1
    80000578:	013a07b3          	add	a5,s4,s3
    8000057c:	0007c503          	lbu	a0,0(a5)
    80000580:	20050b63          	beqz	a0,80000796 <printf+0x29c>
    if(cx != '%'){
    80000584:	ff5515e3          	bne	a0,s5,8000056e <printf+0x74>
    i++;
    80000588:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000058c:	009a07b3          	add	a5,s4,s1
    80000590:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000594:	20090b63          	beqz	s2,800007aa <printf+0x2b0>
    80000598:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000059c:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059e:	c789                	beqz	a5,800005a8 <printf+0xae>
    800005a0:	009a0733          	add	a4,s4,s1
    800005a4:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800005a8:	03690963          	beq	s2,s6,800005da <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800005ac:	05890363          	beq	s2,s8,800005f2 <printf+0xf8>
    } else if(c0 == 'u'){
    800005b0:	0d990663          	beq	s2,s9,8000067c <printf+0x182>
    } else if(c0 == 'x'){
    800005b4:	11a90d63          	beq	s2,s10,800006ce <printf+0x1d4>
    } else if(c0 == 'p'){
    800005b8:	15b90663          	beq	s2,s11,80000704 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800005bc:	06300793          	li	a5,99
    800005c0:	18f90563          	beq	s2,a5,8000074a <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    800005c4:	07300793          	li	a5,115
    800005c8:	18f90b63          	beq	s2,a5,8000075e <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005cc:	03591b63          	bne	s2,s5,80000602 <printf+0x108>
      consputc('%');
    800005d0:	02500513          	li	a0,37
    800005d4:	ca5ff0ef          	jal	80000278 <consputc>
    800005d8:	bf71                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800005da:	f8843783          	ld	a5,-120(s0)
    800005de:	00878713          	addi	a4,a5,8
    800005e2:	f8e43423          	sd	a4,-120(s0)
    800005e6:	4605                	li	a2,1
    800005e8:	45a9                	li	a1,10
    800005ea:	4388                	lw	a0,0(a5)
    800005ec:	e7dff0ef          	jal	80000468 <printint>
    800005f0:	b751                	j	80000574 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    800005f2:	01678f63          	beq	a5,s6,80000610 <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005f6:	03878b63          	beq	a5,s8,8000062c <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    800005fa:	09978e63          	beq	a5,s9,80000696 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    800005fe:	0fa78563          	beq	a5,s10,800006e8 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000602:	8556                	mv	a0,s5
    80000604:	c75ff0ef          	jal	80000278 <consputc>
      consputc(c0);
    80000608:	854a                	mv	a0,s2
    8000060a:	c6fff0ef          	jal	80000278 <consputc>
    8000060e:	b79d                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000610:	f8843783          	ld	a5,-120(s0)
    80000614:	00878713          	addi	a4,a5,8
    80000618:	f8e43423          	sd	a4,-120(s0)
    8000061c:	4605                	li	a2,1
    8000061e:	45a9                	li	a1,10
    80000620:	6388                	ld	a0,0(a5)
    80000622:	e47ff0ef          	jal	80000468 <printint>
      i += 1;
    80000626:	0029849b          	addiw	s1,s3,2
    8000062a:	b7a9                	j	80000574 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000062c:	06400793          	li	a5,100
    80000630:	02f68863          	beq	a3,a5,80000660 <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000634:	07500793          	li	a5,117
    80000638:	06f68d63          	beq	a3,a5,800006b2 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000063c:	07800793          	li	a5,120
    80000640:	fcf691e3          	bne	a3,a5,80000602 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4601                	li	a2,0
    80000652:	45c1                	li	a1,16
    80000654:	6388                	ld	a0,0(a5)
    80000656:	e13ff0ef          	jal	80000468 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bf19                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4605                	li	a2,1
    8000066e:	45a9                	li	a1,10
    80000670:	6388                	ld	a0,0(a5)
    80000672:	df7ff0ef          	jal	80000468 <printint>
      i += 2;
    80000676:	0039849b          	addiw	s1,s3,3
    8000067a:	bded                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4601                	li	a2,0
    8000068a:	45a9                	li	a1,10
    8000068c:	0007e503          	lwu	a0,0(a5)
    80000690:	dd9ff0ef          	jal	80000468 <printint>
    80000694:	b5c5                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	addi	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	4601                	li	a2,0
    800006a4:	45a9                	li	a1,10
    800006a6:	6388                	ld	a0,0(a5)
    800006a8:	dc1ff0ef          	jal	80000468 <printint>
      i += 1;
    800006ac:	0029849b          	addiw	s1,s3,2
    800006b0:	b5d1                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4601                	li	a2,0
    800006c0:	45a9                	li	a1,10
    800006c2:	6388                	ld	a0,0(a5)
    800006c4:	da5ff0ef          	jal	80000468 <printint>
      i += 2;
    800006c8:	0039849b          	addiw	s1,s3,3
    800006cc:	b565                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	4601                	li	a2,0
    800006dc:	45c1                	li	a1,16
    800006de:	0007e503          	lwu	a0,0(a5)
    800006e2:	d87ff0ef          	jal	80000468 <printint>
    800006e6:	b579                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800006e8:	f8843783          	ld	a5,-120(s0)
    800006ec:	00878713          	addi	a4,a5,8
    800006f0:	f8e43423          	sd	a4,-120(s0)
    800006f4:	4601                	li	a2,0
    800006f6:	45c1                	li	a1,16
    800006f8:	6388                	ld	a0,0(a5)
    800006fa:	d6fff0ef          	jal	80000468 <printint>
      i += 1;
    800006fe:	0029849b          	addiw	s1,s3,2
    80000702:	bd8d                	j	80000574 <printf+0x7a>
    80000704:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80000706:	f8843783          	ld	a5,-120(s0)
    8000070a:	00878713          	addi	a4,a5,8
    8000070e:	f8e43423          	sd	a4,-120(s0)
    80000712:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80000716:	03000513          	li	a0,48
    8000071a:	b5fff0ef          	jal	80000278 <consputc>
  consputc('x');
    8000071e:	07800513          	li	a0,120
    80000722:	b57ff0ef          	jal	80000278 <consputc>
    80000726:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000728:	00008b97          	auipc	s7,0x8
    8000072c:	250b8b93          	addi	s7,s7,592 # 80008978 <digits>
    80000730:	03c9d793          	srli	a5,s3,0x3c
    80000734:	97de                	add	a5,a5,s7
    80000736:	0007c503          	lbu	a0,0(a5)
    8000073a:	b3fff0ef          	jal	80000278 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000073e:	0992                	slli	s3,s3,0x4
    80000740:	397d                	addiw	s2,s2,-1
    80000742:	fe0917e3          	bnez	s2,80000730 <printf+0x236>
    80000746:	7be2                	ld	s7,56(sp)
    80000748:	b535                	j	80000574 <printf+0x7a>
      consputc(va_arg(ap, uint));
    8000074a:	f8843783          	ld	a5,-120(s0)
    8000074e:	00878713          	addi	a4,a5,8
    80000752:	f8e43423          	sd	a4,-120(s0)
    80000756:	4388                	lw	a0,0(a5)
    80000758:	b21ff0ef          	jal	80000278 <consputc>
    8000075c:	bd21                	j	80000574 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    8000075e:	f8843783          	ld	a5,-120(s0)
    80000762:	00878713          	addi	a4,a5,8
    80000766:	f8e43423          	sd	a4,-120(s0)
    8000076a:	0007b903          	ld	s2,0(a5)
    8000076e:	00090d63          	beqz	s2,80000788 <printf+0x28e>
      for(; *s; s++)
    80000772:	00094503          	lbu	a0,0(s2)
    80000776:	de050fe3          	beqz	a0,80000574 <printf+0x7a>
        consputc(*s);
    8000077a:	affff0ef          	jal	80000278 <consputc>
      for(; *s; s++)
    8000077e:	0905                	addi	s2,s2,1
    80000780:	00094503          	lbu	a0,0(s2)
    80000784:	f97d                	bnez	a0,8000077a <printf+0x280>
    80000786:	b3fd                	j	80000574 <printf+0x7a>
        s = "(null)";
    80000788:	00008917          	auipc	s2,0x8
    8000078c:	88090913          	addi	s2,s2,-1920 # 80008008 <etext+0x8>
      for(; *s; s++)
    80000790:	02800513          	li	a0,40
    80000794:	b7dd                	j	8000077a <printf+0x280>
    80000796:	74a6                	ld	s1,104(sp)
    80000798:	7906                	ld	s2,96(sp)
    8000079a:	69e6                	ld	s3,88(sp)
    8000079c:	6aa6                	ld	s5,72(sp)
    8000079e:	6b06                	ld	s6,64(sp)
    800007a0:	7c42                	ld	s8,48(sp)
    800007a2:	7ca2                	ld	s9,40(sp)
    800007a4:	7d02                	ld	s10,32(sp)
    800007a6:	6de2                	ld	s11,24(sp)
    800007a8:	a811                	j	800007bc <printf+0x2c2>
    800007aa:	74a6                	ld	s1,104(sp)
    800007ac:	7906                	ld	s2,96(sp)
    800007ae:	69e6                	ld	s3,88(sp)
    800007b0:	6aa6                	ld	s5,72(sp)
    800007b2:	6b06                	ld	s6,64(sp)
    800007b4:	7c42                	ld	s8,48(sp)
    800007b6:	7ca2                	ld	s9,40(sp)
    800007b8:	7d02                	ld	s10,32(sp)
    800007ba:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800007bc:	0000b797          	auipc	a5,0xb
    800007c0:	f987a783          	lw	a5,-104(a5) # 8000b754 <panicking>
    800007c4:	c799                	beqz	a5,800007d2 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    800007c6:	4501                	li	a0,0
    800007c8:	70e6                	ld	ra,120(sp)
    800007ca:	7446                	ld	s0,112(sp)
    800007cc:	6a46                	ld	s4,80(sp)
    800007ce:	6129                	addi	sp,sp,192
    800007d0:	8082                	ret
    release(&pr.lock);
    800007d2:	00013517          	auipc	a0,0x13
    800007d6:	05650513          	addi	a0,a0,86 # 80013828 <pr>
    800007da:	48c000ef          	jal	80000c66 <release>
  return 0;
    800007de:	b7e5                	j	800007c6 <printf+0x2cc>

00000000800007e0 <panic>:

void
panic(char *s)
{
    800007e0:	1101                	addi	sp,sp,-32
    800007e2:	ec06                	sd	ra,24(sp)
    800007e4:	e822                	sd	s0,16(sp)
    800007e6:	e426                	sd	s1,8(sp)
    800007e8:	e04a                	sd	s2,0(sp)
    800007ea:	1000                	addi	s0,sp,32
    800007ec:	84aa                	mv	s1,a0
  panicking = 1;
    800007ee:	4905                	li	s2,1
    800007f0:	0000b797          	auipc	a5,0xb
    800007f4:	f727a223          	sw	s2,-156(a5) # 8000b754 <panicking>
  printf("panic: ");
    800007f8:	00008517          	auipc	a0,0x8
    800007fc:	81850513          	addi	a0,a0,-2024 # 80008010 <etext+0x10>
    80000800:	cfbff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000804:	85a6                	mv	a1,s1
    80000806:	00008517          	auipc	a0,0x8
    8000080a:	81250513          	addi	a0,a0,-2030 # 80008018 <etext+0x18>
    8000080e:	cedff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000812:	0000b797          	auipc	a5,0xb
    80000816:	f327af23          	sw	s2,-194(a5) # 8000b750 <panicked>
  for(;;)
    8000081a:	a001                	j	8000081a <panic+0x3a>

000000008000081c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000081c:	1141                	addi	sp,sp,-16
    8000081e:	e406                	sd	ra,8(sp)
    80000820:	e022                	sd	s0,0(sp)
    80000822:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000824:	00007597          	auipc	a1,0x7
    80000828:	7fc58593          	addi	a1,a1,2044 # 80008020 <etext+0x20>
    8000082c:	00013517          	auipc	a0,0x13
    80000830:	ffc50513          	addi	a0,a0,-4 # 80013828 <pr>
    80000834:	31a000ef          	jal	80000b4e <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80000840:	1141                	addi	sp,sp,-16
    80000842:	e406                	sd	ra,8(sp)
    80000844:	e022                	sd	s0,0(sp)
    80000846:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000848:	100007b7          	lui	a5,0x10000
    8000084c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000850:	10000737          	lui	a4,0x10000
    80000854:	f8000693          	li	a3,-128
    80000858:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000085c:	468d                	li	a3,3
    8000085e:	10000637          	lui	a2,0x10000
    80000862:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000866:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000086a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	461d                	li	a2,7
    80000874:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000878:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    8000087c:	00007597          	auipc	a1,0x7
    80000880:	7ac58593          	addi	a1,a1,1964 # 80008028 <etext+0x28>
    80000884:	00013517          	auipc	a0,0x13
    80000888:	fbc50513          	addi	a0,a0,-68 # 80013840 <tx_lock>
    8000088c:	2c2000ef          	jal	80000b4e <initlock>
}
    80000890:	60a2                	ld	ra,8(sp)
    80000892:	6402                	ld	s0,0(sp)
    80000894:	0141                	addi	sp,sp,16
    80000896:	8082                	ret

0000000080000898 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80000898:	715d                	addi	sp,sp,-80
    8000089a:	e486                	sd	ra,72(sp)
    8000089c:	e0a2                	sd	s0,64(sp)
    8000089e:	fc26                	sd	s1,56(sp)
    800008a0:	ec56                	sd	s5,24(sp)
    800008a2:	0880                	addi	s0,sp,80
    800008a4:	8aaa                	mv	s5,a0
    800008a6:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008a8:	00013517          	auipc	a0,0x13
    800008ac:	f9850513          	addi	a0,a0,-104 # 80013840 <tx_lock>
    800008b0:	31e000ef          	jal	80000bce <acquire>

  int i = 0;
  while(i < n){ 
    800008b4:	06905063          	blez	s1,80000914 <uartwrite+0x7c>
    800008b8:	f84a                	sd	s2,48(sp)
    800008ba:	f44e                	sd	s3,40(sp)
    800008bc:	f052                	sd	s4,32(sp)
    800008be:	e85a                	sd	s6,16(sp)
    800008c0:	e45e                	sd	s7,8(sp)
    800008c2:	8a56                	mv	s4,s5
    800008c4:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    800008c6:	0000b497          	auipc	s1,0xb
    800008ca:	e9648493          	addi	s1,s1,-362 # 8000b75c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800008ce:	00013997          	auipc	s3,0x13
    800008d2:	f7298993          	addi	s3,s3,-142 # 80013840 <tx_lock>
    800008d6:	0000b917          	auipc	s2,0xb
    800008da:	e8290913          	addi	s2,s2,-382 # 8000b758 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    800008de:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    800008e2:	4b05                	li	s6,1
    800008e4:	a005                	j	80000904 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    800008e6:	85ce                	mv	a1,s3
    800008e8:	854a                	mv	a0,s2
    800008ea:	766010ef          	jal	80002050 <sleep>
    while(tx_busy != 0){
    800008ee:	409c                	lw	a5,0(s1)
    800008f0:	fbfd                	bnez	a5,800008e6 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800008f2:	000a4783          	lbu	a5,0(s4)
    800008f6:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800008fa:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800008fe:	0a05                	addi	s4,s4,1
    80000900:	015a0563          	beq	s4,s5,8000090a <uartwrite+0x72>
    while(tx_busy != 0){
    80000904:	409c                	lw	a5,0(s1)
    80000906:	f3e5                	bnez	a5,800008e6 <uartwrite+0x4e>
    80000908:	b7ed                	j	800008f2 <uartwrite+0x5a>
    8000090a:	7942                	ld	s2,48(sp)
    8000090c:	79a2                	ld	s3,40(sp)
    8000090e:	7a02                	ld	s4,32(sp)
    80000910:	6b42                	ld	s6,16(sp)
    80000912:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000914:	00013517          	auipc	a0,0x13
    80000918:	f2c50513          	addi	a0,a0,-212 # 80013840 <tx_lock>
    8000091c:	34a000ef          	jal	80000c66 <release>
}
    80000920:	60a6                	ld	ra,72(sp)
    80000922:	6406                	ld	s0,64(sp)
    80000924:	74e2                	ld	s1,56(sp)
    80000926:	6ae2                	ld	s5,24(sp)
    80000928:	6161                	addi	sp,sp,80
    8000092a:	8082                	ret

000000008000092c <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000092c:	1101                	addi	sp,sp,-32
    8000092e:	ec06                	sd	ra,24(sp)
    80000930:	e822                	sd	s0,16(sp)
    80000932:	e426                	sd	s1,8(sp)
    80000934:	1000                	addi	s0,sp,32
    80000936:	84aa                	mv	s1,a0
  if(panicking == 0)
    80000938:	0000b797          	auipc	a5,0xb
    8000093c:	e1c7a783          	lw	a5,-484(a5) # 8000b754 <panicking>
    80000940:	cf95                	beqz	a5,8000097c <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000942:	0000b797          	auipc	a5,0xb
    80000946:	e0e7a783          	lw	a5,-498(a5) # 8000b750 <panicked>
    8000094a:	ef85                	bnez	a5,80000982 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000094c:	10000737          	lui	a4,0x10000
    80000950:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000952:	00074783          	lbu	a5,0(a4)
    80000956:	0207f793          	andi	a5,a5,32
    8000095a:	dfe5                	beqz	a5,80000952 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000095c:	0ff4f513          	zext.b	a0,s1
    80000960:	100007b7          	lui	a5,0x10000
    80000964:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80000968:	0000b797          	auipc	a5,0xb
    8000096c:	dec7a783          	lw	a5,-532(a5) # 8000b754 <panicking>
    80000970:	cb91                	beqz	a5,80000984 <uartputc_sync+0x58>
    pop_off();
}
    80000972:	60e2                	ld	ra,24(sp)
    80000974:	6442                	ld	s0,16(sp)
    80000976:	64a2                	ld	s1,8(sp)
    80000978:	6105                	addi	sp,sp,32
    8000097a:	8082                	ret
    push_off();
    8000097c:	212000ef          	jal	80000b8e <push_off>
    80000980:	b7c9                	j	80000942 <uartputc_sync+0x16>
    for(;;)
    80000982:	a001                	j	80000982 <uartputc_sync+0x56>
    pop_off();
    80000984:	28e000ef          	jal	80000c12 <pop_off>
}
    80000988:	b7ed                	j	80000972 <uartputc_sync+0x46>

000000008000098a <uartgetc>:

// try to read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000098a:	1141                	addi	sp,sp,-16
    8000098c:	e422                	sd	s0,8(sp)
    8000098e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80000990:	100007b7          	lui	a5,0x10000
    80000994:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000996:	0007c783          	lbu	a5,0(a5)
    8000099a:	8b85                	andi	a5,a5,1
    8000099c:	cb81                	beqz	a5,800009ac <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000099e:	100007b7          	lui	a5,0x10000
    800009a2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009a6:	6422                	ld	s0,8(sp)
    800009a8:	0141                	addi	sp,sp,16
    800009aa:	8082                	ret
    return -1;
    800009ac:	557d                	li	a0,-1
    800009ae:	bfe5                	j	800009a6 <uartgetc+0x1c>

00000000800009b0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009b0:	1101                	addi	sp,sp,-32
    800009b2:	ec06                	sd	ra,24(sp)
    800009b4:	e822                	sd	s0,16(sp)
    800009b6:	e426                	sd	s1,8(sp)
    800009b8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009ba:	100007b7          	lui	a5,0x10000
    800009be:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800009c0:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    800009c4:	00013517          	auipc	a0,0x13
    800009c8:	e7c50513          	addi	a0,a0,-388 # 80013840 <tx_lock>
    800009cc:	202000ef          	jal	80000bce <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    800009d0:	100007b7          	lui	a5,0x10000
    800009d4:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009d6:	0007c783          	lbu	a5,0(a5)
    800009da:	0207f793          	andi	a5,a5,32
    800009de:	eb89                	bnez	a5,800009f0 <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800009e0:	00013517          	auipc	a0,0x13
    800009e4:	e6050513          	addi	a0,a0,-416 # 80013840 <tx_lock>
    800009e8:	27e000ef          	jal	80000c66 <release>

  // read and process incoming characters, if any.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009ec:	54fd                	li	s1,-1
    800009ee:	a831                	j	80000a0a <uartintr+0x5a>
    tx_busy = 0;
    800009f0:	0000b797          	auipc	a5,0xb
    800009f4:	d607a623          	sw	zero,-660(a5) # 8000b75c <tx_busy>
    wakeup(&tx_chan);
    800009f8:	0000b517          	auipc	a0,0xb
    800009fc:	d6050513          	addi	a0,a0,-672 # 8000b758 <tx_chan>
    80000a00:	69c010ef          	jal	8000209c <wakeup>
    80000a04:	bff1                	j	800009e0 <uartintr+0x30>
      break;
    consoleintr(c);
    80000a06:	8a5ff0ef          	jal	800002aa <consoleintr>
    int c = uartgetc();
    80000a0a:	f81ff0ef          	jal	8000098a <uartgetc>
    if(c == -1)
    80000a0e:	fe951ce3          	bne	a0,s1,80000a06 <uartintr+0x56>
  }
}
    80000a12:	60e2                	ld	ra,24(sp)
    80000a14:	6442                	ld	s0,16(sp)
    80000a16:	64a2                	ld	s1,8(sp)
    80000a18:	6105                	addi	sp,sp,32
    80000a1a:	8082                	ret

0000000080000a1c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a1c:	1101                	addi	sp,sp,-32
    80000a1e:	ec06                	sd	ra,24(sp)
    80000a20:	e822                	sd	s0,16(sp)
    80000a22:	e426                	sd	s1,8(sp)
    80000a24:	e04a                	sd	s2,0(sp)
    80000a26:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a28:	03451793          	slli	a5,a0,0x34
    80000a2c:	e7a9                	bnez	a5,80000a76 <kfree+0x5a>
    80000a2e:	84aa                	mv	s1,a0
    80000a30:	00026797          	auipc	a5,0x26
    80000a34:	eb878793          	addi	a5,a5,-328 # 800268e8 <end>
    80000a38:	02f56f63          	bltu	a0,a5,80000a76 <kfree+0x5a>
    80000a3c:	47c5                	li	a5,17
    80000a3e:	07ee                	slli	a5,a5,0x1b
    80000a40:	02f57b63          	bgeu	a0,a5,80000a76 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a44:	6605                	lui	a2,0x1
    80000a46:	4585                	li	a1,1
    80000a48:	25a000ef          	jal	80000ca2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a4c:	00013917          	auipc	s2,0x13
    80000a50:	e0c90913          	addi	s2,s2,-500 # 80013858 <kmem>
    80000a54:	854a                	mv	a0,s2
    80000a56:	178000ef          	jal	80000bce <acquire>
  r->next = kmem.freelist;
    80000a5a:	01893783          	ld	a5,24(s2)
    80000a5e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a60:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a64:	854a                	mv	a0,s2
    80000a66:	200000ef          	jal	80000c66 <release>
}
    80000a6a:	60e2                	ld	ra,24(sp)
    80000a6c:	6442                	ld	s0,16(sp)
    80000a6e:	64a2                	ld	s1,8(sp)
    80000a70:	6902                	ld	s2,0(sp)
    80000a72:	6105                	addi	sp,sp,32
    80000a74:	8082                	ret
    panic("kfree");
    80000a76:	00007517          	auipc	a0,0x7
    80000a7a:	5ba50513          	addi	a0,a0,1466 # 80008030 <etext+0x30>
    80000a7e:	d63ff0ef          	jal	800007e0 <panic>

0000000080000a82 <freerange>:
{
    80000a82:	7179                	addi	sp,sp,-48
    80000a84:	f406                	sd	ra,40(sp)
    80000a86:	f022                	sd	s0,32(sp)
    80000a88:	ec26                	sd	s1,24(sp)
    80000a8a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a8c:	6785                	lui	a5,0x1
    80000a8e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a92:	00e504b3          	add	s1,a0,a4
    80000a96:	777d                	lui	a4,0xfffff
    80000a98:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a9a:	94be                	add	s1,s1,a5
    80000a9c:	0295e263          	bltu	a1,s1,80000ac0 <freerange+0x3e>
    80000aa0:	e84a                	sd	s2,16(sp)
    80000aa2:	e44e                	sd	s3,8(sp)
    80000aa4:	e052                	sd	s4,0(sp)
    80000aa6:	892e                	mv	s2,a1
    kfree(p);
    80000aa8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aaa:	6985                	lui	s3,0x1
    kfree(p);
    80000aac:	01448533          	add	a0,s1,s4
    80000ab0:	f6dff0ef          	jal	80000a1c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab4:	94ce                	add	s1,s1,s3
    80000ab6:	fe997be3          	bgeu	s2,s1,80000aac <freerange+0x2a>
    80000aba:	6942                	ld	s2,16(sp)
    80000abc:	69a2                	ld	s3,8(sp)
    80000abe:	6a02                	ld	s4,0(sp)
}
    80000ac0:	70a2                	ld	ra,40(sp)
    80000ac2:	7402                	ld	s0,32(sp)
    80000ac4:	64e2                	ld	s1,24(sp)
    80000ac6:	6145                	addi	sp,sp,48
    80000ac8:	8082                	ret

0000000080000aca <kinit>:
{
    80000aca:	1141                	addi	sp,sp,-16
    80000acc:	e406                	sd	ra,8(sp)
    80000ace:	e022                	sd	s0,0(sp)
    80000ad0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ad2:	00007597          	auipc	a1,0x7
    80000ad6:	56658593          	addi	a1,a1,1382 # 80008038 <etext+0x38>
    80000ada:	00013517          	auipc	a0,0x13
    80000ade:	d7e50513          	addi	a0,a0,-642 # 80013858 <kmem>
    80000ae2:	06c000ef          	jal	80000b4e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ae6:	45c5                	li	a1,17
    80000ae8:	05ee                	slli	a1,a1,0x1b
    80000aea:	00026517          	auipc	a0,0x26
    80000aee:	dfe50513          	addi	a0,a0,-514 # 800268e8 <end>
    80000af2:	f91ff0ef          	jal	80000a82 <freerange>
}
    80000af6:	60a2                	ld	ra,8(sp)
    80000af8:	6402                	ld	s0,0(sp)
    80000afa:	0141                	addi	sp,sp,16
    80000afc:	8082                	ret

0000000080000afe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000afe:	1101                	addi	sp,sp,-32
    80000b00:	ec06                	sd	ra,24(sp)
    80000b02:	e822                	sd	s0,16(sp)
    80000b04:	e426                	sd	s1,8(sp)
    80000b06:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b08:	00013497          	auipc	s1,0x13
    80000b0c:	d5048493          	addi	s1,s1,-688 # 80013858 <kmem>
    80000b10:	8526                	mv	a0,s1
    80000b12:	0bc000ef          	jal	80000bce <acquire>
  r = kmem.freelist;
    80000b16:	6c84                	ld	s1,24(s1)
  if(r)
    80000b18:	c485                	beqz	s1,80000b40 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b1a:	609c                	ld	a5,0(s1)
    80000b1c:	00013517          	auipc	a0,0x13
    80000b20:	d3c50513          	addi	a0,a0,-708 # 80013858 <kmem>
    80000b24:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b26:	140000ef          	jal	80000c66 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b2a:	6605                	lui	a2,0x1
    80000b2c:	4595                	li	a1,5
    80000b2e:	8526                	mv	a0,s1
    80000b30:	172000ef          	jal	80000ca2 <memset>
  return (void*)r;
}
    80000b34:	8526                	mv	a0,s1
    80000b36:	60e2                	ld	ra,24(sp)
    80000b38:	6442                	ld	s0,16(sp)
    80000b3a:	64a2                	ld	s1,8(sp)
    80000b3c:	6105                	addi	sp,sp,32
    80000b3e:	8082                	ret
  release(&kmem.lock);
    80000b40:	00013517          	auipc	a0,0x13
    80000b44:	d1850513          	addi	a0,a0,-744 # 80013858 <kmem>
    80000b48:	11e000ef          	jal	80000c66 <release>
  if(r)
    80000b4c:	b7e5                	j	80000b34 <kalloc+0x36>

0000000080000b4e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b4e:	1141                	addi	sp,sp,-16
    80000b50:	e422                	sd	s0,8(sp)
    80000b52:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b54:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b56:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b5a:	00053823          	sd	zero,16(a0)
}
    80000b5e:	6422                	ld	s0,8(sp)
    80000b60:	0141                	addi	sp,sp,16
    80000b62:	8082                	ret

0000000080000b64 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b64:	411c                	lw	a5,0(a0)
    80000b66:	e399                	bnez	a5,80000b6c <holding+0x8>
    80000b68:	4501                	li	a0,0
  return r;
}
    80000b6a:	8082                	ret
{
    80000b6c:	1101                	addi	sp,sp,-32
    80000b6e:	ec06                	sd	ra,24(sp)
    80000b70:	e822                	sd	s0,16(sp)
    80000b72:	e426                	sd	s1,8(sp)
    80000b74:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b76:	6904                	ld	s1,16(a0)
    80000b78:	53b000ef          	jal	800018b2 <mycpu>
    80000b7c:	40a48533          	sub	a0,s1,a0
    80000b80:	00153513          	seqz	a0,a0
}
    80000b84:	60e2                	ld	ra,24(sp)
    80000b86:	6442                	ld	s0,16(sp)
    80000b88:	64a2                	ld	s1,8(sp)
    80000b8a:	6105                	addi	sp,sp,32
    80000b8c:	8082                	ret

0000000080000b8e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b8e:	1101                	addi	sp,sp,-32
    80000b90:	ec06                	sd	ra,24(sp)
    80000b92:	e822                	sd	s0,16(sp)
    80000b94:	e426                	sd	s1,8(sp)
    80000b96:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b98:	100024f3          	csrr	s1,sstatus
    80000b9c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000ba0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ba2:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000ba6:	50d000ef          	jal	800018b2 <mycpu>
    80000baa:	5d3c                	lw	a5,120(a0)
    80000bac:	cb99                	beqz	a5,80000bc2 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bae:	505000ef          	jal	800018b2 <mycpu>
    80000bb2:	5d3c                	lw	a5,120(a0)
    80000bb4:	2785                	addiw	a5,a5,1
    80000bb6:	dd3c                	sw	a5,120(a0)
}
    80000bb8:	60e2                	ld	ra,24(sp)
    80000bba:	6442                	ld	s0,16(sp)
    80000bbc:	64a2                	ld	s1,8(sp)
    80000bbe:	6105                	addi	sp,sp,32
    80000bc0:	8082                	ret
    mycpu()->intena = old;
    80000bc2:	4f1000ef          	jal	800018b2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bc6:	8085                	srli	s1,s1,0x1
    80000bc8:	8885                	andi	s1,s1,1
    80000bca:	dd64                	sw	s1,124(a0)
    80000bcc:	b7cd                	j	80000bae <push_off+0x20>

0000000080000bce <acquire>:
{
    80000bce:	1101                	addi	sp,sp,-32
    80000bd0:	ec06                	sd	ra,24(sp)
    80000bd2:	e822                	sd	s0,16(sp)
    80000bd4:	e426                	sd	s1,8(sp)
    80000bd6:	1000                	addi	s0,sp,32
    80000bd8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bda:	fb5ff0ef          	jal	80000b8e <push_off>
  if(holding(lk))
    80000bde:	8526                	mv	a0,s1
    80000be0:	f85ff0ef          	jal	80000b64 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be4:	4705                	li	a4,1
  if(holding(lk))
    80000be6:	e105                	bnez	a0,80000c06 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be8:	87ba                	mv	a5,a4
    80000bea:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bee:	2781                	sext.w	a5,a5
    80000bf0:	ffe5                	bnez	a5,80000be8 <acquire+0x1a>
  __sync_synchronize();
    80000bf2:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000bf6:	4bd000ef          	jal	800018b2 <mycpu>
    80000bfa:	e888                	sd	a0,16(s1)
}
    80000bfc:	60e2                	ld	ra,24(sp)
    80000bfe:	6442                	ld	s0,16(sp)
    80000c00:	64a2                	ld	s1,8(sp)
    80000c02:	6105                	addi	sp,sp,32
    80000c04:	8082                	ret
    panic("acquire");
    80000c06:	00007517          	auipc	a0,0x7
    80000c0a:	43a50513          	addi	a0,a0,1082 # 80008040 <etext+0x40>
    80000c0e:	bd3ff0ef          	jal	800007e0 <panic>

0000000080000c12 <pop_off>:

void
pop_off(void)
{
    80000c12:	1141                	addi	sp,sp,-16
    80000c14:	e406                	sd	ra,8(sp)
    80000c16:	e022                	sd	s0,0(sp)
    80000c18:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c1a:	499000ef          	jal	800018b2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c1e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c22:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c24:	e78d                	bnez	a5,80000c4e <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c26:	5d3c                	lw	a5,120(a0)
    80000c28:	02f05963          	blez	a5,80000c5a <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c2c:	37fd                	addiw	a5,a5,-1
    80000c2e:	0007871b          	sext.w	a4,a5
    80000c32:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c34:	eb09                	bnez	a4,80000c46 <pop_off+0x34>
    80000c36:	5d7c                	lw	a5,124(a0)
    80000c38:	c799                	beqz	a5,80000c46 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c3a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c3e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c42:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c46:	60a2                	ld	ra,8(sp)
    80000c48:	6402                	ld	s0,0(sp)
    80000c4a:	0141                	addi	sp,sp,16
    80000c4c:	8082                	ret
    panic("pop_off - interruptible");
    80000c4e:	00007517          	auipc	a0,0x7
    80000c52:	3fa50513          	addi	a0,a0,1018 # 80008048 <etext+0x48>
    80000c56:	b8bff0ef          	jal	800007e0 <panic>
    panic("pop_off");
    80000c5a:	00007517          	auipc	a0,0x7
    80000c5e:	40650513          	addi	a0,a0,1030 # 80008060 <etext+0x60>
    80000c62:	b7fff0ef          	jal	800007e0 <panic>

0000000080000c66 <release>:
{
    80000c66:	1101                	addi	sp,sp,-32
    80000c68:	ec06                	sd	ra,24(sp)
    80000c6a:	e822                	sd	s0,16(sp)
    80000c6c:	e426                	sd	s1,8(sp)
    80000c6e:	1000                	addi	s0,sp,32
    80000c70:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c72:	ef3ff0ef          	jal	80000b64 <holding>
    80000c76:	c105                	beqz	a0,80000c96 <release+0x30>
  lk->cpu = 0;
    80000c78:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c7c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000c80:	0310000f          	fence	rw,w
    80000c84:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c88:	f8bff0ef          	jal	80000c12 <pop_off>
}
    80000c8c:	60e2                	ld	ra,24(sp)
    80000c8e:	6442                	ld	s0,16(sp)
    80000c90:	64a2                	ld	s1,8(sp)
    80000c92:	6105                	addi	sp,sp,32
    80000c94:	8082                	ret
    panic("release");
    80000c96:	00007517          	auipc	a0,0x7
    80000c9a:	3d250513          	addi	a0,a0,978 # 80008068 <etext+0x68>
    80000c9e:	b43ff0ef          	jal	800007e0 <panic>

0000000080000ca2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ca2:	1141                	addi	sp,sp,-16
    80000ca4:	e422                	sd	s0,8(sp)
    80000ca6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000ca8:	ca19                	beqz	a2,80000cbe <memset+0x1c>
    80000caa:	87aa                	mv	a5,a0
    80000cac:	1602                	slli	a2,a2,0x20
    80000cae:	9201                	srli	a2,a2,0x20
    80000cb0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cb4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cb8:	0785                	addi	a5,a5,1
    80000cba:	fee79de3          	bne	a5,a4,80000cb4 <memset+0x12>
  }
  return dst;
}
    80000cbe:	6422                	ld	s0,8(sp)
    80000cc0:	0141                	addi	sp,sp,16
    80000cc2:	8082                	ret

0000000080000cc4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cc4:	1141                	addi	sp,sp,-16
    80000cc6:	e422                	sd	s0,8(sp)
    80000cc8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cca:	ca05                	beqz	a2,80000cfa <memcmp+0x36>
    80000ccc:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cd0:	1682                	slli	a3,a3,0x20
    80000cd2:	9281                	srli	a3,a3,0x20
    80000cd4:	0685                	addi	a3,a3,1
    80000cd6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cd8:	00054783          	lbu	a5,0(a0)
    80000cdc:	0005c703          	lbu	a4,0(a1)
    80000ce0:	00e79863          	bne	a5,a4,80000cf0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000ce4:	0505                	addi	a0,a0,1
    80000ce6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000ce8:	fed518e3          	bne	a0,a3,80000cd8 <memcmp+0x14>
  }

  return 0;
    80000cec:	4501                	li	a0,0
    80000cee:	a019                	j	80000cf4 <memcmp+0x30>
      return *s1 - *s2;
    80000cf0:	40e7853b          	subw	a0,a5,a4
}
    80000cf4:	6422                	ld	s0,8(sp)
    80000cf6:	0141                	addi	sp,sp,16
    80000cf8:	8082                	ret
  return 0;
    80000cfa:	4501                	li	a0,0
    80000cfc:	bfe5                	j	80000cf4 <memcmp+0x30>

0000000080000cfe <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cfe:	1141                	addi	sp,sp,-16
    80000d00:	e422                	sd	s0,8(sp)
    80000d02:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d04:	c205                	beqz	a2,80000d24 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d06:	02a5e263          	bltu	a1,a0,80000d2a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d0a:	1602                	slli	a2,a2,0x20
    80000d0c:	9201                	srli	a2,a2,0x20
    80000d0e:	00c587b3          	add	a5,a1,a2
{
    80000d12:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d14:	0585                	addi	a1,a1,1
    80000d16:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8719>
    80000d18:	fff5c683          	lbu	a3,-1(a1)
    80000d1c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d20:	feb79ae3          	bne	a5,a1,80000d14 <memmove+0x16>

  return dst;
}
    80000d24:	6422                	ld	s0,8(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret
  if(s < d && s + n > d){
    80000d2a:	02061693          	slli	a3,a2,0x20
    80000d2e:	9281                	srli	a3,a3,0x20
    80000d30:	00d58733          	add	a4,a1,a3
    80000d34:	fce57be3          	bgeu	a0,a4,80000d0a <memmove+0xc>
    d += n;
    80000d38:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d3a:	fff6079b          	addiw	a5,a2,-1
    80000d3e:	1782                	slli	a5,a5,0x20
    80000d40:	9381                	srli	a5,a5,0x20
    80000d42:	fff7c793          	not	a5,a5
    80000d46:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d48:	177d                	addi	a4,a4,-1
    80000d4a:	16fd                	addi	a3,a3,-1
    80000d4c:	00074603          	lbu	a2,0(a4)
    80000d50:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d54:	fef71ae3          	bne	a4,a5,80000d48 <memmove+0x4a>
    80000d58:	b7f1                	j	80000d24 <memmove+0x26>

0000000080000d5a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d5a:	1141                	addi	sp,sp,-16
    80000d5c:	e406                	sd	ra,8(sp)
    80000d5e:	e022                	sd	s0,0(sp)
    80000d60:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d62:	f9dff0ef          	jal	80000cfe <memmove>
}
    80000d66:	60a2                	ld	ra,8(sp)
    80000d68:	6402                	ld	s0,0(sp)
    80000d6a:	0141                	addi	sp,sp,16
    80000d6c:	8082                	ret

0000000080000d6e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d6e:	1141                	addi	sp,sp,-16
    80000d70:	e422                	sd	s0,8(sp)
    80000d72:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d74:	ce11                	beqz	a2,80000d90 <strncmp+0x22>
    80000d76:	00054783          	lbu	a5,0(a0)
    80000d7a:	cf89                	beqz	a5,80000d94 <strncmp+0x26>
    80000d7c:	0005c703          	lbu	a4,0(a1)
    80000d80:	00f71a63          	bne	a4,a5,80000d94 <strncmp+0x26>
    n--, p++, q++;
    80000d84:	367d                	addiw	a2,a2,-1
    80000d86:	0505                	addi	a0,a0,1
    80000d88:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d8a:	f675                	bnez	a2,80000d76 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d8c:	4501                	li	a0,0
    80000d8e:	a801                	j	80000d9e <strncmp+0x30>
    80000d90:	4501                	li	a0,0
    80000d92:	a031                	j	80000d9e <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000d94:	00054503          	lbu	a0,0(a0)
    80000d98:	0005c783          	lbu	a5,0(a1)
    80000d9c:	9d1d                	subw	a0,a0,a5
}
    80000d9e:	6422                	ld	s0,8(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret

0000000080000da4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000da4:	1141                	addi	sp,sp,-16
    80000da6:	e422                	sd	s0,8(sp)
    80000da8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000daa:	87aa                	mv	a5,a0
    80000dac:	86b2                	mv	a3,a2
    80000dae:	367d                	addiw	a2,a2,-1
    80000db0:	02d05563          	blez	a3,80000dda <strncpy+0x36>
    80000db4:	0785                	addi	a5,a5,1
    80000db6:	0005c703          	lbu	a4,0(a1)
    80000dba:	fee78fa3          	sb	a4,-1(a5)
    80000dbe:	0585                	addi	a1,a1,1
    80000dc0:	f775                	bnez	a4,80000dac <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dc2:	873e                	mv	a4,a5
    80000dc4:	9fb5                	addw	a5,a5,a3
    80000dc6:	37fd                	addiw	a5,a5,-1
    80000dc8:	00c05963          	blez	a2,80000dda <strncpy+0x36>
    *s++ = 0;
    80000dcc:	0705                	addi	a4,a4,1
    80000dce:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000dd2:	40e786bb          	subw	a3,a5,a4
    80000dd6:	fed04be3          	bgtz	a3,80000dcc <strncpy+0x28>
  return os;
}
    80000dda:	6422                	ld	s0,8(sp)
    80000ddc:	0141                	addi	sp,sp,16
    80000dde:	8082                	ret

0000000080000de0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000de0:	1141                	addi	sp,sp,-16
    80000de2:	e422                	sd	s0,8(sp)
    80000de4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000de6:	02c05363          	blez	a2,80000e0c <safestrcpy+0x2c>
    80000dea:	fff6069b          	addiw	a3,a2,-1
    80000dee:	1682                	slli	a3,a3,0x20
    80000df0:	9281                	srli	a3,a3,0x20
    80000df2:	96ae                	add	a3,a3,a1
    80000df4:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000df6:	00d58963          	beq	a1,a3,80000e08 <safestrcpy+0x28>
    80000dfa:	0585                	addi	a1,a1,1
    80000dfc:	0785                	addi	a5,a5,1
    80000dfe:	fff5c703          	lbu	a4,-1(a1)
    80000e02:	fee78fa3          	sb	a4,-1(a5)
    80000e06:	fb65                	bnez	a4,80000df6 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e08:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e0c:	6422                	ld	s0,8(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret

0000000080000e12 <strlen>:

int
strlen(const char *s)
{
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e422                	sd	s0,8(sp)
    80000e16:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e18:	00054783          	lbu	a5,0(a0)
    80000e1c:	cf91                	beqz	a5,80000e38 <strlen+0x26>
    80000e1e:	0505                	addi	a0,a0,1
    80000e20:	87aa                	mv	a5,a0
    80000e22:	86be                	mv	a3,a5
    80000e24:	0785                	addi	a5,a5,1
    80000e26:	fff7c703          	lbu	a4,-1(a5)
    80000e2a:	ff65                	bnez	a4,80000e22 <strlen+0x10>
    80000e2c:	40a6853b          	subw	a0,a3,a0
    80000e30:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e38:	4501                	li	a0,0
    80000e3a:	bfe5                	j	80000e32 <strlen+0x20>

0000000080000e3c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e3c:	1141                	addi	sp,sp,-16
    80000e3e:	e406                	sd	ra,8(sp)
    80000e40:	e022                	sd	s0,0(sp)
    80000e42:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e44:	25f000ef          	jal	800018a2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e48:	0000b717          	auipc	a4,0xb
    80000e4c:	91870713          	addi	a4,a4,-1768 # 8000b760 <started>
  if(cpuid() == 0){
    80000e50:	c51d                	beqz	a0,80000e7e <main+0x42>
    while(started == 0)
    80000e52:	431c                	lw	a5,0(a4)
    80000e54:	2781                	sext.w	a5,a5
    80000e56:	dff5                	beqz	a5,80000e52 <main+0x16>
      ;
    __sync_synchronize();
    80000e58:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e5c:	247000ef          	jal	800018a2 <cpuid>
    80000e60:	85aa                	mv	a1,a0
    80000e62:	00007517          	auipc	a0,0x7
    80000e66:	22650513          	addi	a0,a0,550 # 80008088 <etext+0x88>
    80000e6a:	e90ff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000e6e:	080000ef          	jal	80000eee <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e72:	343010ef          	jal	800029b4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e76:	743040ef          	jal	80005db8 <plicinithart>
  }

  scheduler();        
    80000e7a:	72f000ef          	jal	80001da8 <scheduler>
    consoleinit();
    80000e7e:	da6ff0ef          	jal	80000424 <consoleinit>
    printfinit();
    80000e82:	99bff0ef          	jal	8000081c <printfinit>
    printf("\n");
    80000e86:	00007517          	auipc	a0,0x7
    80000e8a:	21250513          	addi	a0,a0,530 # 80008098 <etext+0x98>
    80000e8e:	e6cff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000e92:	00007517          	auipc	a0,0x7
    80000e96:	1de50513          	addi	a0,a0,478 # 80008070 <etext+0x70>
    80000e9a:	e60ff0ef          	jal	800004fa <printf>
    printf("\n");
    80000e9e:	00007517          	auipc	a0,0x7
    80000ea2:	1fa50513          	addi	a0,a0,506 # 80008098 <etext+0x98>
    80000ea6:	e54ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000eaa:	c21ff0ef          	jal	80000aca <kinit>
    kvminit();       // create kernel page table
    80000eae:	2ca000ef          	jal	80001178 <kvminit>
    kvminithart();   // turn on paging
    80000eb2:	03c000ef          	jal	80000eee <kvminithart>
    procinit();      // process table
    80000eb6:	137000ef          	jal	800017ec <procinit>
    trapinit();      // trap vectors
    80000eba:	2d7010ef          	jal	80002990 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ebe:	2f7010ef          	jal	800029b4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ec2:	6dd040ef          	jal	80005d9e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000ec6:	6f3040ef          	jal	80005db8 <plicinithart>
    binit();         // buffer cache
    80000eca:	3aa020ef          	jal	80003274 <binit>
    iinit();         // inode table
    80000ece:	131020ef          	jal	800037fe <iinit>
    fileinit();      // file table
    80000ed2:	1c1030ef          	jal	80004892 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ed6:	7d3040ef          	jal	80005ea8 <virtio_disk_init>
    userinit();      // first user process
    80000eda:	523000ef          	jal	80001bfc <userinit>
    __sync_synchronize();
    80000ede:	0330000f          	fence	rw,rw
    started = 1;
    80000ee2:	4785                	li	a5,1
    80000ee4:	0000b717          	auipc	a4,0xb
    80000ee8:	86f72e23          	sw	a5,-1924(a4) # 8000b760 <started>
    80000eec:	b779                	j	80000e7a <main+0x3e>

0000000080000eee <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000eee:	1141                	addi	sp,sp,-16
    80000ef0:	e422                	sd	s0,8(sp)
    80000ef2:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000ef4:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ef8:	0000b797          	auipc	a5,0xb
    80000efc:	8707b783          	ld	a5,-1936(a5) # 8000b768 <kernel_pagetable>
    80000f00:	83b1                	srli	a5,a5,0xc
    80000f02:	577d                	li	a4,-1
    80000f04:	177e                	slli	a4,a4,0x3f
    80000f06:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f08:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f0c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f10:	6422                	ld	s0,8(sp)
    80000f12:	0141                	addi	sp,sp,16
    80000f14:	8082                	ret

0000000080000f16 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f16:	7139                	addi	sp,sp,-64
    80000f18:	fc06                	sd	ra,56(sp)
    80000f1a:	f822                	sd	s0,48(sp)
    80000f1c:	f426                	sd	s1,40(sp)
    80000f1e:	f04a                	sd	s2,32(sp)
    80000f20:	ec4e                	sd	s3,24(sp)
    80000f22:	e852                	sd	s4,16(sp)
    80000f24:	e456                	sd	s5,8(sp)
    80000f26:	e05a                	sd	s6,0(sp)
    80000f28:	0080                	addi	s0,sp,64
    80000f2a:	84aa                	mv	s1,a0
    80000f2c:	89ae                	mv	s3,a1
    80000f2e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f30:	57fd                	li	a5,-1
    80000f32:	83e9                	srli	a5,a5,0x1a
    80000f34:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f36:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f38:	02b7fc63          	bgeu	a5,a1,80000f70 <walk+0x5a>
    panic("walk");
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	16450513          	addi	a0,a0,356 # 800080a0 <etext+0xa0>
    80000f44:	89dff0ef          	jal	800007e0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f48:	060a8263          	beqz	s5,80000fac <walk+0x96>
    80000f4c:	bb3ff0ef          	jal	80000afe <kalloc>
    80000f50:	84aa                	mv	s1,a0
    80000f52:	c139                	beqz	a0,80000f98 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f54:	6605                	lui	a2,0x1
    80000f56:	4581                	li	a1,0
    80000f58:	d4bff0ef          	jal	80000ca2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f5c:	00c4d793          	srli	a5,s1,0xc
    80000f60:	07aa                	slli	a5,a5,0xa
    80000f62:	0017e793          	ori	a5,a5,1
    80000f66:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f6a:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd870f>
    80000f6c:	036a0063          	beq	s4,s6,80000f8c <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f70:	0149d933          	srl	s2,s3,s4
    80000f74:	1ff97913          	andi	s2,s2,511
    80000f78:	090e                	slli	s2,s2,0x3
    80000f7a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f7c:	00093483          	ld	s1,0(s2)
    80000f80:	0014f793          	andi	a5,s1,1
    80000f84:	d3f1                	beqz	a5,80000f48 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f86:	80a9                	srli	s1,s1,0xa
    80000f88:	04b2                	slli	s1,s1,0xc
    80000f8a:	b7c5                	j	80000f6a <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f8c:	00c9d513          	srli	a0,s3,0xc
    80000f90:	1ff57513          	andi	a0,a0,511
    80000f94:	050e                	slli	a0,a0,0x3
    80000f96:	9526                	add	a0,a0,s1
}
    80000f98:	70e2                	ld	ra,56(sp)
    80000f9a:	7442                	ld	s0,48(sp)
    80000f9c:	74a2                	ld	s1,40(sp)
    80000f9e:	7902                	ld	s2,32(sp)
    80000fa0:	69e2                	ld	s3,24(sp)
    80000fa2:	6a42                	ld	s4,16(sp)
    80000fa4:	6aa2                	ld	s5,8(sp)
    80000fa6:	6b02                	ld	s6,0(sp)
    80000fa8:	6121                	addi	sp,sp,64
    80000faa:	8082                	ret
        return 0;
    80000fac:	4501                	li	a0,0
    80000fae:	b7ed                	j	80000f98 <walk+0x82>

0000000080000fb0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fb0:	57fd                	li	a5,-1
    80000fb2:	83e9                	srli	a5,a5,0x1a
    80000fb4:	00b7f463          	bgeu	a5,a1,80000fbc <walkaddr+0xc>
    return 0;
    80000fb8:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fba:	8082                	ret
{
    80000fbc:	1141                	addi	sp,sp,-16
    80000fbe:	e406                	sd	ra,8(sp)
    80000fc0:	e022                	sd	s0,0(sp)
    80000fc2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fc4:	4601                	li	a2,0
    80000fc6:	f51ff0ef          	jal	80000f16 <walk>
  if(pte == 0)
    80000fca:	c105                	beqz	a0,80000fea <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000fcc:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fce:	0117f693          	andi	a3,a5,17
    80000fd2:	4745                	li	a4,17
    return 0;
    80000fd4:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fd6:	00e68663          	beq	a3,a4,80000fe2 <walkaddr+0x32>
}
    80000fda:	60a2                	ld	ra,8(sp)
    80000fdc:	6402                	ld	s0,0(sp)
    80000fde:	0141                	addi	sp,sp,16
    80000fe0:	8082                	ret
  pa = PTE2PA(*pte);
    80000fe2:	83a9                	srli	a5,a5,0xa
    80000fe4:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000fe8:	bfcd                	j	80000fda <walkaddr+0x2a>
    return 0;
    80000fea:	4501                	li	a0,0
    80000fec:	b7fd                	j	80000fda <walkaddr+0x2a>

0000000080000fee <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000fee:	715d                	addi	sp,sp,-80
    80000ff0:	e486                	sd	ra,72(sp)
    80000ff2:	e0a2                	sd	s0,64(sp)
    80000ff4:	fc26                	sd	s1,56(sp)
    80000ff6:	f84a                	sd	s2,48(sp)
    80000ff8:	f44e                	sd	s3,40(sp)
    80000ffa:	f052                	sd	s4,32(sp)
    80000ffc:	ec56                	sd	s5,24(sp)
    80000ffe:	e85a                	sd	s6,16(sp)
    80001000:	e45e                	sd	s7,8(sp)
    80001002:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001004:	03459793          	slli	a5,a1,0x34
    80001008:	e7a9                	bnez	a5,80001052 <mappages+0x64>
    8000100a:	8aaa                	mv	s5,a0
    8000100c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000100e:	03461793          	slli	a5,a2,0x34
    80001012:	e7b1                	bnez	a5,8000105e <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001014:	ca39                	beqz	a2,8000106a <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001016:	77fd                	lui	a5,0xfffff
    80001018:	963e                	add	a2,a2,a5
    8000101a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000101e:	892e                	mv	s2,a1
    80001020:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001024:	6b85                	lui	s7,0x1
    80001026:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000102a:	4605                	li	a2,1
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8556                	mv	a0,s5
    80001030:	ee7ff0ef          	jal	80000f16 <walk>
    80001034:	c539                	beqz	a0,80001082 <mappages+0x94>
    if(*pte & PTE_V)
    80001036:	611c                	ld	a5,0(a0)
    80001038:	8b85                	andi	a5,a5,1
    8000103a:	ef95                	bnez	a5,80001076 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000103c:	80b1                	srli	s1,s1,0xc
    8000103e:	04aa                	slli	s1,s1,0xa
    80001040:	0164e4b3          	or	s1,s1,s6
    80001044:	0014e493          	ori	s1,s1,1
    80001048:	e104                	sd	s1,0(a0)
    if(a == last)
    8000104a:	05390863          	beq	s2,s3,8000109a <mappages+0xac>
    a += PGSIZE;
    8000104e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	bfd9                	j	80001026 <mappages+0x38>
    panic("mappages: va not aligned");
    80001052:	00007517          	auipc	a0,0x7
    80001056:	05650513          	addi	a0,a0,86 # 800080a8 <etext+0xa8>
    8000105a:	f86ff0ef          	jal	800007e0 <panic>
    panic("mappages: size not aligned");
    8000105e:	00007517          	auipc	a0,0x7
    80001062:	06a50513          	addi	a0,a0,106 # 800080c8 <etext+0xc8>
    80001066:	f7aff0ef          	jal	800007e0 <panic>
    panic("mappages: size");
    8000106a:	00007517          	auipc	a0,0x7
    8000106e:	07e50513          	addi	a0,a0,126 # 800080e8 <etext+0xe8>
    80001072:	f6eff0ef          	jal	800007e0 <panic>
      panic("mappages: remap");
    80001076:	00007517          	auipc	a0,0x7
    8000107a:	08250513          	addi	a0,a0,130 # 800080f8 <etext+0xf8>
    8000107e:	f62ff0ef          	jal	800007e0 <panic>
      return -1;
    80001082:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001084:	60a6                	ld	ra,72(sp)
    80001086:	6406                	ld	s0,64(sp)
    80001088:	74e2                	ld	s1,56(sp)
    8000108a:	7942                	ld	s2,48(sp)
    8000108c:	79a2                	ld	s3,40(sp)
    8000108e:	7a02                	ld	s4,32(sp)
    80001090:	6ae2                	ld	s5,24(sp)
    80001092:	6b42                	ld	s6,16(sp)
    80001094:	6ba2                	ld	s7,8(sp)
    80001096:	6161                	addi	sp,sp,80
    80001098:	8082                	ret
  return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7e5                	j	80001084 <mappages+0x96>

000000008000109e <kvmmap>:
{
    8000109e:	1141                	addi	sp,sp,-16
    800010a0:	e406                	sd	ra,8(sp)
    800010a2:	e022                	sd	s0,0(sp)
    800010a4:	0800                	addi	s0,sp,16
    800010a6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010a8:	86b2                	mv	a3,a2
    800010aa:	863e                	mv	a2,a5
    800010ac:	f43ff0ef          	jal	80000fee <mappages>
    800010b0:	e509                	bnez	a0,800010ba <kvmmap+0x1c>
}
    800010b2:	60a2                	ld	ra,8(sp)
    800010b4:	6402                	ld	s0,0(sp)
    800010b6:	0141                	addi	sp,sp,16
    800010b8:	8082                	ret
    panic("kvmmap");
    800010ba:	00007517          	auipc	a0,0x7
    800010be:	04e50513          	addi	a0,a0,78 # 80008108 <etext+0x108>
    800010c2:	f1eff0ef          	jal	800007e0 <panic>

00000000800010c6 <kvmmake>:
{
    800010c6:	1101                	addi	sp,sp,-32
    800010c8:	ec06                	sd	ra,24(sp)
    800010ca:	e822                	sd	s0,16(sp)
    800010cc:	e426                	sd	s1,8(sp)
    800010ce:	e04a                	sd	s2,0(sp)
    800010d0:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010d2:	a2dff0ef          	jal	80000afe <kalloc>
    800010d6:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010d8:	6605                	lui	a2,0x1
    800010da:	4581                	li	a1,0
    800010dc:	bc7ff0ef          	jal	80000ca2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010e0:	4719                	li	a4,6
    800010e2:	6685                	lui	a3,0x1
    800010e4:	10000637          	lui	a2,0x10000
    800010e8:	100005b7          	lui	a1,0x10000
    800010ec:	8526                	mv	a0,s1
    800010ee:	fb1ff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010f2:	4719                	li	a4,6
    800010f4:	6685                	lui	a3,0x1
    800010f6:	10001637          	lui	a2,0x10001
    800010fa:	100015b7          	lui	a1,0x10001
    800010fe:	8526                	mv	a0,s1
    80001100:	f9fff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001104:	4719                	li	a4,6
    80001106:	040006b7          	lui	a3,0x4000
    8000110a:	0c000637          	lui	a2,0xc000
    8000110e:	0c0005b7          	lui	a1,0xc000
    80001112:	8526                	mv	a0,s1
    80001114:	f8bff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001118:	00007917          	auipc	s2,0x7
    8000111c:	ee890913          	addi	s2,s2,-280 # 80008000 <etext>
    80001120:	4729                	li	a4,10
    80001122:	80007697          	auipc	a3,0x80007
    80001126:	ede68693          	addi	a3,a3,-290 # 8000 <_entry-0x7fff8000>
    8000112a:	4605                	li	a2,1
    8000112c:	067e                	slli	a2,a2,0x1f
    8000112e:	85b2                	mv	a1,a2
    80001130:	8526                	mv	a0,s1
    80001132:	f6dff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001136:	46c5                	li	a3,17
    80001138:	06ee                	slli	a3,a3,0x1b
    8000113a:	4719                	li	a4,6
    8000113c:	412686b3          	sub	a3,a3,s2
    80001140:	864a                	mv	a2,s2
    80001142:	85ca                	mv	a1,s2
    80001144:	8526                	mv	a0,s1
    80001146:	f59ff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000114a:	4729                	li	a4,10
    8000114c:	6685                	lui	a3,0x1
    8000114e:	00006617          	auipc	a2,0x6
    80001152:	eb260613          	addi	a2,a2,-334 # 80007000 <_trampoline>
    80001156:	040005b7          	lui	a1,0x4000
    8000115a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000115c:	05b2                	slli	a1,a1,0xc
    8000115e:	8526                	mv	a0,s1
    80001160:	f3fff0ef          	jal	8000109e <kvmmap>
  proc_mapstacks(kpgtbl);
    80001164:	8526                	mv	a0,s1
    80001166:	5ee000ef          	jal	80001754 <proc_mapstacks>
}
    8000116a:	8526                	mv	a0,s1
    8000116c:	60e2                	ld	ra,24(sp)
    8000116e:	6442                	ld	s0,16(sp)
    80001170:	64a2                	ld	s1,8(sp)
    80001172:	6902                	ld	s2,0(sp)
    80001174:	6105                	addi	sp,sp,32
    80001176:	8082                	ret

0000000080001178 <kvminit>:
{
    80001178:	1141                	addi	sp,sp,-16
    8000117a:	e406                	sd	ra,8(sp)
    8000117c:	e022                	sd	s0,0(sp)
    8000117e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001180:	f47ff0ef          	jal	800010c6 <kvmmake>
    80001184:	0000a797          	auipc	a5,0xa
    80001188:	5ea7b223          	sd	a0,1508(a5) # 8000b768 <kernel_pagetable>
}
    8000118c:	60a2                	ld	ra,8(sp)
    8000118e:	6402                	ld	s0,0(sp)
    80001190:	0141                	addi	sp,sp,16
    80001192:	8082                	ret

0000000080001194 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001194:	1101                	addi	sp,sp,-32
    80001196:	ec06                	sd	ra,24(sp)
    80001198:	e822                	sd	s0,16(sp)
    8000119a:	e426                	sd	s1,8(sp)
    8000119c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000119e:	961ff0ef          	jal	80000afe <kalloc>
    800011a2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800011a4:	c509                	beqz	a0,800011ae <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011a6:	6605                	lui	a2,0x1
    800011a8:	4581                	li	a1,0
    800011aa:	af9ff0ef          	jal	80000ca2 <memset>
  return pagetable;
}
    800011ae:	8526                	mv	a0,s1
    800011b0:	60e2                	ld	ra,24(sp)
    800011b2:	6442                	ld	s0,16(sp)
    800011b4:	64a2                	ld	s1,8(sp)
    800011b6:	6105                	addi	sp,sp,32
    800011b8:	8082                	ret

00000000800011ba <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ba:	7139                	addi	sp,sp,-64
    800011bc:	fc06                	sd	ra,56(sp)
    800011be:	f822                	sd	s0,48(sp)
    800011c0:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c2:	03459793          	slli	a5,a1,0x34
    800011c6:	e38d                	bnez	a5,800011e8 <uvmunmap+0x2e>
    800011c8:	f04a                	sd	s2,32(sp)
    800011ca:	ec4e                	sd	s3,24(sp)
    800011cc:	e852                	sd	s4,16(sp)
    800011ce:	e456                	sd	s5,8(sp)
    800011d0:	e05a                	sd	s6,0(sp)
    800011d2:	8a2a                	mv	s4,a0
    800011d4:	892e                	mv	s2,a1
    800011d6:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011d8:	0632                	slli	a2,a2,0xc
    800011da:	00b609b3          	add	s3,a2,a1
    800011de:	6b05                	lui	s6,0x1
    800011e0:	0535f963          	bgeu	a1,s3,80001232 <uvmunmap+0x78>
    800011e4:	f426                	sd	s1,40(sp)
    800011e6:	a015                	j	8000120a <uvmunmap+0x50>
    800011e8:	f426                	sd	s1,40(sp)
    800011ea:	f04a                	sd	s2,32(sp)
    800011ec:	ec4e                	sd	s3,24(sp)
    800011ee:	e852                	sd	s4,16(sp)
    800011f0:	e456                	sd	s5,8(sp)
    800011f2:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    800011f4:	00007517          	auipc	a0,0x7
    800011f8:	f1c50513          	addi	a0,a0,-228 # 80008110 <etext+0x110>
    800011fc:	de4ff0ef          	jal	800007e0 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001200:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001204:	995a                	add	s2,s2,s6
    80001206:	03397563          	bgeu	s2,s3,80001230 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000120a:	4601                	li	a2,0
    8000120c:	85ca                	mv	a1,s2
    8000120e:	8552                	mv	a0,s4
    80001210:	d07ff0ef          	jal	80000f16 <walk>
    80001214:	84aa                	mv	s1,a0
    80001216:	d57d                	beqz	a0,80001204 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80001218:	611c                	ld	a5,0(a0)
    8000121a:	0017f713          	andi	a4,a5,1
    8000121e:	d37d                	beqz	a4,80001204 <uvmunmap+0x4a>
    if(do_free){
    80001220:	fe0a80e3          	beqz	s5,80001200 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001224:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80001226:	00c79513          	slli	a0,a5,0xc
    8000122a:	ff2ff0ef          	jal	80000a1c <kfree>
    8000122e:	bfc9                	j	80001200 <uvmunmap+0x46>
    80001230:	74a2                	ld	s1,40(sp)
    80001232:	7902                	ld	s2,32(sp)
    80001234:	69e2                	ld	s3,24(sp)
    80001236:	6a42                	ld	s4,16(sp)
    80001238:	6aa2                	ld	s5,8(sp)
    8000123a:	6b02                	ld	s6,0(sp)
  }
}
    8000123c:	70e2                	ld	ra,56(sp)
    8000123e:	7442                	ld	s0,48(sp)
    80001240:	6121                	addi	sp,sp,64
    80001242:	8082                	ret

0000000080001244 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001244:	1101                	addi	sp,sp,-32
    80001246:	ec06                	sd	ra,24(sp)
    80001248:	e822                	sd	s0,16(sp)
    8000124a:	e426                	sd	s1,8(sp)
    8000124c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000124e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001250:	00b67d63          	bgeu	a2,a1,8000126a <uvmdealloc+0x26>
    80001254:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001256:	6785                	lui	a5,0x1
    80001258:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000125a:	00f60733          	add	a4,a2,a5
    8000125e:	76fd                	lui	a3,0xfffff
    80001260:	8f75                	and	a4,a4,a3
    80001262:	97ae                	add	a5,a5,a1
    80001264:	8ff5                	and	a5,a5,a3
    80001266:	00f76863          	bltu	a4,a5,80001276 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000126a:	8526                	mv	a0,s1
    8000126c:	60e2                	ld	ra,24(sp)
    8000126e:	6442                	ld	s0,16(sp)
    80001270:	64a2                	ld	s1,8(sp)
    80001272:	6105                	addi	sp,sp,32
    80001274:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001276:	8f99                	sub	a5,a5,a4
    80001278:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000127a:	4685                	li	a3,1
    8000127c:	0007861b          	sext.w	a2,a5
    80001280:	85ba                	mv	a1,a4
    80001282:	f39ff0ef          	jal	800011ba <uvmunmap>
    80001286:	b7d5                	j	8000126a <uvmdealloc+0x26>

0000000080001288 <uvmalloc>:
  if(newsz < oldsz)
    80001288:	08b66f63          	bltu	a2,a1,80001326 <uvmalloc+0x9e>
{
    8000128c:	7139                	addi	sp,sp,-64
    8000128e:	fc06                	sd	ra,56(sp)
    80001290:	f822                	sd	s0,48(sp)
    80001292:	ec4e                	sd	s3,24(sp)
    80001294:	e852                	sd	s4,16(sp)
    80001296:	e456                	sd	s5,8(sp)
    80001298:	0080                	addi	s0,sp,64
    8000129a:	8aaa                	mv	s5,a0
    8000129c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000129e:	6785                	lui	a5,0x1
    800012a0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012a2:	95be                	add	a1,a1,a5
    800012a4:	77fd                	lui	a5,0xfffff
    800012a6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012aa:	08c9f063          	bgeu	s3,a2,8000132a <uvmalloc+0xa2>
    800012ae:	f426                	sd	s1,40(sp)
    800012b0:	f04a                	sd	s2,32(sp)
    800012b2:	e05a                	sd	s6,0(sp)
    800012b4:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012b6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012ba:	845ff0ef          	jal	80000afe <kalloc>
    800012be:	84aa                	mv	s1,a0
    if(mem == 0){
    800012c0:	c515                	beqz	a0,800012ec <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800012c2:	6605                	lui	a2,0x1
    800012c4:	4581                	li	a1,0
    800012c6:	9ddff0ef          	jal	80000ca2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012ca:	875a                	mv	a4,s6
    800012cc:	86a6                	mv	a3,s1
    800012ce:	6605                	lui	a2,0x1
    800012d0:	85ca                	mv	a1,s2
    800012d2:	8556                	mv	a0,s5
    800012d4:	d1bff0ef          	jal	80000fee <mappages>
    800012d8:	e915                	bnez	a0,8000130c <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012da:	6785                	lui	a5,0x1
    800012dc:	993e                	add	s2,s2,a5
    800012de:	fd496ee3          	bltu	s2,s4,800012ba <uvmalloc+0x32>
  return newsz;
    800012e2:	8552                	mv	a0,s4
    800012e4:	74a2                	ld	s1,40(sp)
    800012e6:	7902                	ld	s2,32(sp)
    800012e8:	6b02                	ld	s6,0(sp)
    800012ea:	a811                	j	800012fe <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800012ec:	864e                	mv	a2,s3
    800012ee:	85ca                	mv	a1,s2
    800012f0:	8556                	mv	a0,s5
    800012f2:	f53ff0ef          	jal	80001244 <uvmdealloc>
      return 0;
    800012f6:	4501                	li	a0,0
    800012f8:	74a2                	ld	s1,40(sp)
    800012fa:	7902                	ld	s2,32(sp)
    800012fc:	6b02                	ld	s6,0(sp)
}
    800012fe:	70e2                	ld	ra,56(sp)
    80001300:	7442                	ld	s0,48(sp)
    80001302:	69e2                	ld	s3,24(sp)
    80001304:	6a42                	ld	s4,16(sp)
    80001306:	6aa2                	ld	s5,8(sp)
    80001308:	6121                	addi	sp,sp,64
    8000130a:	8082                	ret
      kfree(mem);
    8000130c:	8526                	mv	a0,s1
    8000130e:	f0eff0ef          	jal	80000a1c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001312:	864e                	mv	a2,s3
    80001314:	85ca                	mv	a1,s2
    80001316:	8556                	mv	a0,s5
    80001318:	f2dff0ef          	jal	80001244 <uvmdealloc>
      return 0;
    8000131c:	4501                	li	a0,0
    8000131e:	74a2                	ld	s1,40(sp)
    80001320:	7902                	ld	s2,32(sp)
    80001322:	6b02                	ld	s6,0(sp)
    80001324:	bfe9                	j	800012fe <uvmalloc+0x76>
    return oldsz;
    80001326:	852e                	mv	a0,a1
}
    80001328:	8082                	ret
  return newsz;
    8000132a:	8532                	mv	a0,a2
    8000132c:	bfc9                	j	800012fe <uvmalloc+0x76>

000000008000132e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000132e:	7179                	addi	sp,sp,-48
    80001330:	f406                	sd	ra,40(sp)
    80001332:	f022                	sd	s0,32(sp)
    80001334:	ec26                	sd	s1,24(sp)
    80001336:	e84a                	sd	s2,16(sp)
    80001338:	e44e                	sd	s3,8(sp)
    8000133a:	e052                	sd	s4,0(sp)
    8000133c:	1800                	addi	s0,sp,48
    8000133e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001340:	84aa                	mv	s1,a0
    80001342:	6905                	lui	s2,0x1
    80001344:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001346:	4985                	li	s3,1
    80001348:	a819                	j	8000135e <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000134a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000134c:	00c79513          	slli	a0,a5,0xc
    80001350:	fdfff0ef          	jal	8000132e <freewalk>
      pagetable[i] = 0;
    80001354:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001358:	04a1                	addi	s1,s1,8
    8000135a:	01248f63          	beq	s1,s2,80001378 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000135e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001360:	00f7f713          	andi	a4,a5,15
    80001364:	ff3703e3          	beq	a4,s3,8000134a <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001368:	8b85                	andi	a5,a5,1
    8000136a:	d7fd                	beqz	a5,80001358 <freewalk+0x2a>
      panic("freewalk: leaf");
    8000136c:	00007517          	auipc	a0,0x7
    80001370:	dbc50513          	addi	a0,a0,-580 # 80008128 <etext+0x128>
    80001374:	c6cff0ef          	jal	800007e0 <panic>
    }
  }
  kfree((void*)pagetable);
    80001378:	8552                	mv	a0,s4
    8000137a:	ea2ff0ef          	jal	80000a1c <kfree>
}
    8000137e:	70a2                	ld	ra,40(sp)
    80001380:	7402                	ld	s0,32(sp)
    80001382:	64e2                	ld	s1,24(sp)
    80001384:	6942                	ld	s2,16(sp)
    80001386:	69a2                	ld	s3,8(sp)
    80001388:	6a02                	ld	s4,0(sp)
    8000138a:	6145                	addi	sp,sp,48
    8000138c:	8082                	ret

000000008000138e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000138e:	1101                	addi	sp,sp,-32
    80001390:	ec06                	sd	ra,24(sp)
    80001392:	e822                	sd	s0,16(sp)
    80001394:	e426                	sd	s1,8(sp)
    80001396:	1000                	addi	s0,sp,32
    80001398:	84aa                	mv	s1,a0
  if(sz > 0)
    8000139a:	e989                	bnez	a1,800013ac <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000139c:	8526                	mv	a0,s1
    8000139e:	f91ff0ef          	jal	8000132e <freewalk>
}
    800013a2:	60e2                	ld	ra,24(sp)
    800013a4:	6442                	ld	s0,16(sp)
    800013a6:	64a2                	ld	s1,8(sp)
    800013a8:	6105                	addi	sp,sp,32
    800013aa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800013ac:	6785                	lui	a5,0x1
    800013ae:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013b0:	95be                	add	a1,a1,a5
    800013b2:	4685                	li	a3,1
    800013b4:	00c5d613          	srli	a2,a1,0xc
    800013b8:	4581                	li	a1,0
    800013ba:	e01ff0ef          	jal	800011ba <uvmunmap>
    800013be:	bff9                	j	8000139c <uvmfree+0xe>

00000000800013c0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800013c0:	ce49                	beqz	a2,8000145a <uvmcopy+0x9a>
{
    800013c2:	715d                	addi	sp,sp,-80
    800013c4:	e486                	sd	ra,72(sp)
    800013c6:	e0a2                	sd	s0,64(sp)
    800013c8:	fc26                	sd	s1,56(sp)
    800013ca:	f84a                	sd	s2,48(sp)
    800013cc:	f44e                	sd	s3,40(sp)
    800013ce:	f052                	sd	s4,32(sp)
    800013d0:	ec56                	sd	s5,24(sp)
    800013d2:	e85a                	sd	s6,16(sp)
    800013d4:	e45e                	sd	s7,8(sp)
    800013d6:	0880                	addi	s0,sp,80
    800013d8:	8aaa                	mv	s5,a0
    800013da:	8b2e                	mv	s6,a1
    800013dc:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800013de:	4481                	li	s1,0
    800013e0:	a029                	j	800013ea <uvmcopy+0x2a>
    800013e2:	6785                	lui	a5,0x1
    800013e4:	94be                	add	s1,s1,a5
    800013e6:	0544fe63          	bgeu	s1,s4,80001442 <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    800013ea:	4601                	li	a2,0
    800013ec:	85a6                	mv	a1,s1
    800013ee:	8556                	mv	a0,s5
    800013f0:	b27ff0ef          	jal	80000f16 <walk>
    800013f4:	d57d                	beqz	a0,800013e2 <uvmcopy+0x22>
      continue;   // page table entry hasn't been allocated
    if((*pte & PTE_V) == 0)
    800013f6:	6118                	ld	a4,0(a0)
    800013f8:	00177793          	andi	a5,a4,1
    800013fc:	d3fd                	beqz	a5,800013e2 <uvmcopy+0x22>
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    800013fe:	00a75593          	srli	a1,a4,0xa
    80001402:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001406:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    8000140a:	ef4ff0ef          	jal	80000afe <kalloc>
    8000140e:	89aa                	mv	s3,a0
    80001410:	c105                	beqz	a0,80001430 <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001412:	6605                	lui	a2,0x1
    80001414:	85de                	mv	a1,s7
    80001416:	8e9ff0ef          	jal	80000cfe <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000141a:	874a                	mv	a4,s2
    8000141c:	86ce                	mv	a3,s3
    8000141e:	6605                	lui	a2,0x1
    80001420:	85a6                	mv	a1,s1
    80001422:	855a                	mv	a0,s6
    80001424:	bcbff0ef          	jal	80000fee <mappages>
    80001428:	dd4d                	beqz	a0,800013e2 <uvmcopy+0x22>
      kfree(mem);
    8000142a:	854e                	mv	a0,s3
    8000142c:	df0ff0ef          	jal	80000a1c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001430:	4685                	li	a3,1
    80001432:	00c4d613          	srli	a2,s1,0xc
    80001436:	4581                	li	a1,0
    80001438:	855a                	mv	a0,s6
    8000143a:	d81ff0ef          	jal	800011ba <uvmunmap>
  return -1;
    8000143e:	557d                	li	a0,-1
    80001440:	a011                	j	80001444 <uvmcopy+0x84>
  return 0;
    80001442:	4501                	li	a0,0
}
    80001444:	60a6                	ld	ra,72(sp)
    80001446:	6406                	ld	s0,64(sp)
    80001448:	74e2                	ld	s1,56(sp)
    8000144a:	7942                	ld	s2,48(sp)
    8000144c:	79a2                	ld	s3,40(sp)
    8000144e:	7a02                	ld	s4,32(sp)
    80001450:	6ae2                	ld	s5,24(sp)
    80001452:	6b42                	ld	s6,16(sp)
    80001454:	6ba2                	ld	s7,8(sp)
    80001456:	6161                	addi	sp,sp,80
    80001458:	8082                	ret
  return 0;
    8000145a:	4501                	li	a0,0
}
    8000145c:	8082                	ret

000000008000145e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000145e:	1141                	addi	sp,sp,-16
    80001460:	e406                	sd	ra,8(sp)
    80001462:	e022                	sd	s0,0(sp)
    80001464:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001466:	4601                	li	a2,0
    80001468:	aafff0ef          	jal	80000f16 <walk>
  if(pte == 0)
    8000146c:	c901                	beqz	a0,8000147c <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000146e:	611c                	ld	a5,0(a0)
    80001470:	9bbd                	andi	a5,a5,-17
    80001472:	e11c                	sd	a5,0(a0)
}
    80001474:	60a2                	ld	ra,8(sp)
    80001476:	6402                	ld	s0,0(sp)
    80001478:	0141                	addi	sp,sp,16
    8000147a:	8082                	ret
    panic("uvmclear");
    8000147c:	00007517          	auipc	a0,0x7
    80001480:	cbc50513          	addi	a0,a0,-836 # 80008138 <etext+0x138>
    80001484:	b5cff0ef          	jal	800007e0 <panic>

0000000080001488 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001488:	c6dd                	beqz	a3,80001536 <copyinstr+0xae>
{
    8000148a:	715d                	addi	sp,sp,-80
    8000148c:	e486                	sd	ra,72(sp)
    8000148e:	e0a2                	sd	s0,64(sp)
    80001490:	fc26                	sd	s1,56(sp)
    80001492:	f84a                	sd	s2,48(sp)
    80001494:	f44e                	sd	s3,40(sp)
    80001496:	f052                	sd	s4,32(sp)
    80001498:	ec56                	sd	s5,24(sp)
    8000149a:	e85a                	sd	s6,16(sp)
    8000149c:	e45e                	sd	s7,8(sp)
    8000149e:	0880                	addi	s0,sp,80
    800014a0:	8a2a                	mv	s4,a0
    800014a2:	8b2e                	mv	s6,a1
    800014a4:	8bb2                	mv	s7,a2
    800014a6:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800014a8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800014aa:	6985                	lui	s3,0x1
    800014ac:	a825                	j	800014e4 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800014ae:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800014b2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800014b4:	37fd                	addiw	a5,a5,-1
    800014b6:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800014ba:	60a6                	ld	ra,72(sp)
    800014bc:	6406                	ld	s0,64(sp)
    800014be:	74e2                	ld	s1,56(sp)
    800014c0:	7942                	ld	s2,48(sp)
    800014c2:	79a2                	ld	s3,40(sp)
    800014c4:	7a02                	ld	s4,32(sp)
    800014c6:	6ae2                	ld	s5,24(sp)
    800014c8:	6b42                	ld	s6,16(sp)
    800014ca:	6ba2                	ld	s7,8(sp)
    800014cc:	6161                	addi	sp,sp,80
    800014ce:	8082                	ret
    800014d0:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800014d4:	9742                	add	a4,a4,a6
      --max;
    800014d6:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    800014da:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    800014de:	04e58463          	beq	a1,a4,80001526 <copyinstr+0x9e>
{
    800014e2:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    800014e4:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800014e8:	85a6                	mv	a1,s1
    800014ea:	8552                	mv	a0,s4
    800014ec:	ac5ff0ef          	jal	80000fb0 <walkaddr>
    if(pa0 == 0)
    800014f0:	cd0d                	beqz	a0,8000152a <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800014f2:	417486b3          	sub	a3,s1,s7
    800014f6:	96ce                	add	a3,a3,s3
    if(n > max)
    800014f8:	00d97363          	bgeu	s2,a3,800014fe <copyinstr+0x76>
    800014fc:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800014fe:	955e                	add	a0,a0,s7
    80001500:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001502:	c695                	beqz	a3,8000152e <copyinstr+0xa6>
    80001504:	87da                	mv	a5,s6
    80001506:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001508:	41650633          	sub	a2,a0,s6
    while(n > 0){
    8000150c:	96da                	add	a3,a3,s6
    8000150e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001510:	00f60733          	add	a4,a2,a5
    80001514:	00074703          	lbu	a4,0(a4)
    80001518:	db59                	beqz	a4,800014ae <copyinstr+0x26>
        *dst = *p;
    8000151a:	00e78023          	sb	a4,0(a5)
      dst++;
    8000151e:	0785                	addi	a5,a5,1
    while(n > 0){
    80001520:	fed797e3          	bne	a5,a3,8000150e <copyinstr+0x86>
    80001524:	b775                	j	800014d0 <copyinstr+0x48>
    80001526:	4781                	li	a5,0
    80001528:	b771                	j	800014b4 <copyinstr+0x2c>
      return -1;
    8000152a:	557d                	li	a0,-1
    8000152c:	b779                	j	800014ba <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    8000152e:	6b85                	lui	s7,0x1
    80001530:	9ba6                	add	s7,s7,s1
    80001532:	87da                	mv	a5,s6
    80001534:	b77d                	j	800014e2 <copyinstr+0x5a>
  int got_null = 0;
    80001536:	4781                	li	a5,0
  if(got_null){
    80001538:	37fd                	addiw	a5,a5,-1
    8000153a:	0007851b          	sext.w	a0,a5
}
    8000153e:	8082                	ret

0000000080001540 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001540:	1141                	addi	sp,sp,-16
    80001542:	e406                	sd	ra,8(sp)
    80001544:	e022                	sd	s0,0(sp)
    80001546:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80001548:	4601                	li	a2,0
    8000154a:	9cdff0ef          	jal	80000f16 <walk>
  if (pte == 0) {
    8000154e:	c519                	beqz	a0,8000155c <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    80001550:	6108                	ld	a0,0(a0)
    80001552:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80001554:	60a2                	ld	ra,8(sp)
    80001556:	6402                	ld	s0,0(sp)
    80001558:	0141                	addi	sp,sp,16
    8000155a:	8082                	ret
    return 0;
    8000155c:	4501                	li	a0,0
    8000155e:	bfdd                	j	80001554 <ismapped+0x14>

0000000080001560 <vmfault>:
{
    80001560:	7179                	addi	sp,sp,-48
    80001562:	f406                	sd	ra,40(sp)
    80001564:	f022                	sd	s0,32(sp)
    80001566:	ec26                	sd	s1,24(sp)
    80001568:	e44e                	sd	s3,8(sp)
    8000156a:	1800                	addi	s0,sp,48
    8000156c:	89aa                	mv	s3,a0
    8000156e:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80001570:	35e000ef          	jal	800018ce <myproc>
  if (va >= p->sz)
    80001574:	653c                	ld	a5,72(a0)
    80001576:	00f4ea63          	bltu	s1,a5,8000158a <vmfault+0x2a>
    return 0;
    8000157a:	4981                	li	s3,0
}
    8000157c:	854e                	mv	a0,s3
    8000157e:	70a2                	ld	ra,40(sp)
    80001580:	7402                	ld	s0,32(sp)
    80001582:	64e2                	ld	s1,24(sp)
    80001584:	69a2                	ld	s3,8(sp)
    80001586:	6145                	addi	sp,sp,48
    80001588:	8082                	ret
    8000158a:	e84a                	sd	s2,16(sp)
    8000158c:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    8000158e:	77fd                	lui	a5,0xfffff
    80001590:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    80001592:	85a6                	mv	a1,s1
    80001594:	854e                	mv	a0,s3
    80001596:	fabff0ef          	jal	80001540 <ismapped>
    return 0;
    8000159a:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    8000159c:	c119                	beqz	a0,800015a2 <vmfault+0x42>
    8000159e:	6942                	ld	s2,16(sp)
    800015a0:	bff1                	j	8000157c <vmfault+0x1c>
    800015a2:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    800015a4:	d5aff0ef          	jal	80000afe <kalloc>
    800015a8:	8a2a                	mv	s4,a0
  if(mem == 0)
    800015aa:	c90d                	beqz	a0,800015dc <vmfault+0x7c>
  mem = (uint64) kalloc();
    800015ac:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    800015ae:	6605                	lui	a2,0x1
    800015b0:	4581                	li	a1,0
    800015b2:	ef0ff0ef          	jal	80000ca2 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    800015b6:	4759                	li	a4,22
    800015b8:	86d2                	mv	a3,s4
    800015ba:	6605                	lui	a2,0x1
    800015bc:	85a6                	mv	a1,s1
    800015be:	05093503          	ld	a0,80(s2)
    800015c2:	a2dff0ef          	jal	80000fee <mappages>
    800015c6:	e501                	bnez	a0,800015ce <vmfault+0x6e>
    800015c8:	6942                	ld	s2,16(sp)
    800015ca:	6a02                	ld	s4,0(sp)
    800015cc:	bf45                	j	8000157c <vmfault+0x1c>
    kfree((void *)mem);
    800015ce:	8552                	mv	a0,s4
    800015d0:	c4cff0ef          	jal	80000a1c <kfree>
    return 0;
    800015d4:	4981                	li	s3,0
    800015d6:	6942                	ld	s2,16(sp)
    800015d8:	6a02                	ld	s4,0(sp)
    800015da:	b74d                	j	8000157c <vmfault+0x1c>
    800015dc:	6942                	ld	s2,16(sp)
    800015de:	6a02                	ld	s4,0(sp)
    800015e0:	bf71                	j	8000157c <vmfault+0x1c>

00000000800015e2 <copyout>:
  while(len > 0){
    800015e2:	c2cd                	beqz	a3,80001684 <copyout+0xa2>
{
    800015e4:	711d                	addi	sp,sp,-96
    800015e6:	ec86                	sd	ra,88(sp)
    800015e8:	e8a2                	sd	s0,80(sp)
    800015ea:	e4a6                	sd	s1,72(sp)
    800015ec:	f852                	sd	s4,48(sp)
    800015ee:	f05a                	sd	s6,32(sp)
    800015f0:	ec5e                	sd	s7,24(sp)
    800015f2:	e862                	sd	s8,16(sp)
    800015f4:	1080                	addi	s0,sp,96
    800015f6:	8c2a                	mv	s8,a0
    800015f8:	8b2e                	mv	s6,a1
    800015fa:	8bb2                	mv	s7,a2
    800015fc:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    800015fe:	74fd                	lui	s1,0xfffff
    80001600:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001602:	57fd                	li	a5,-1
    80001604:	83e9                	srli	a5,a5,0x1a
    80001606:	0897e163          	bltu	a5,s1,80001688 <copyout+0xa6>
    8000160a:	e0ca                	sd	s2,64(sp)
    8000160c:	fc4e                	sd	s3,56(sp)
    8000160e:	f456                	sd	s5,40(sp)
    80001610:	e466                	sd	s9,8(sp)
    80001612:	e06a                	sd	s10,0(sp)
    80001614:	6d05                	lui	s10,0x1
    80001616:	8cbe                	mv	s9,a5
    80001618:	a015                	j	8000163c <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000161a:	409b0533          	sub	a0,s6,s1
    8000161e:	0009861b          	sext.w	a2,s3
    80001622:	85de                	mv	a1,s7
    80001624:	954a                	add	a0,a0,s2
    80001626:	ed8ff0ef          	jal	80000cfe <memmove>
    len -= n;
    8000162a:	413a0a33          	sub	s4,s4,s3
    src += n;
    8000162e:	9bce                	add	s7,s7,s3
  while(len > 0){
    80001630:	040a0363          	beqz	s4,80001676 <copyout+0x94>
    if(va0 >= MAXVA)
    80001634:	055cec63          	bltu	s9,s5,8000168c <copyout+0xaa>
    80001638:	84d6                	mv	s1,s5
    8000163a:	8b56                	mv	s6,s5
    pa0 = walkaddr(pagetable, va0);
    8000163c:	85a6                	mv	a1,s1
    8000163e:	8562                	mv	a0,s8
    80001640:	971ff0ef          	jal	80000fb0 <walkaddr>
    80001644:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80001646:	e901                	bnez	a0,80001656 <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001648:	4601                	li	a2,0
    8000164a:	85a6                	mv	a1,s1
    8000164c:	8562                	mv	a0,s8
    8000164e:	f13ff0ef          	jal	80001560 <vmfault>
    80001652:	892a                	mv	s2,a0
    80001654:	c139                	beqz	a0,8000169a <copyout+0xb8>
    pte = walk(pagetable, va0, 0);
    80001656:	4601                	li	a2,0
    80001658:	85a6                	mv	a1,s1
    8000165a:	8562                	mv	a0,s8
    8000165c:	8bbff0ef          	jal	80000f16 <walk>
    if((*pte & PTE_W) == 0)
    80001660:	611c                	ld	a5,0(a0)
    80001662:	8b91                	andi	a5,a5,4
    80001664:	c3b1                	beqz	a5,800016a8 <copyout+0xc6>
    n = PGSIZE - (dstva - va0);
    80001666:	01a48ab3          	add	s5,s1,s10
    8000166a:	416a89b3          	sub	s3,s5,s6
    if(n > len)
    8000166e:	fb3a76e3          	bgeu	s4,s3,8000161a <copyout+0x38>
    80001672:	89d2                	mv	s3,s4
    80001674:	b75d                	j	8000161a <copyout+0x38>
  return 0;
    80001676:	4501                	li	a0,0
    80001678:	6906                	ld	s2,64(sp)
    8000167a:	79e2                	ld	s3,56(sp)
    8000167c:	7aa2                	ld	s5,40(sp)
    8000167e:	6ca2                	ld	s9,8(sp)
    80001680:	6d02                	ld	s10,0(sp)
    80001682:	a80d                	j	800016b4 <copyout+0xd2>
    80001684:	4501                	li	a0,0
}
    80001686:	8082                	ret
      return -1;
    80001688:	557d                	li	a0,-1
    8000168a:	a02d                	j	800016b4 <copyout+0xd2>
    8000168c:	557d                	li	a0,-1
    8000168e:	6906                	ld	s2,64(sp)
    80001690:	79e2                	ld	s3,56(sp)
    80001692:	7aa2                	ld	s5,40(sp)
    80001694:	6ca2                	ld	s9,8(sp)
    80001696:	6d02                	ld	s10,0(sp)
    80001698:	a831                	j	800016b4 <copyout+0xd2>
        return -1;
    8000169a:	557d                	li	a0,-1
    8000169c:	6906                	ld	s2,64(sp)
    8000169e:	79e2                	ld	s3,56(sp)
    800016a0:	7aa2                	ld	s5,40(sp)
    800016a2:	6ca2                	ld	s9,8(sp)
    800016a4:	6d02                	ld	s10,0(sp)
    800016a6:	a039                	j	800016b4 <copyout+0xd2>
      return -1;
    800016a8:	557d                	li	a0,-1
    800016aa:	6906                	ld	s2,64(sp)
    800016ac:	79e2                	ld	s3,56(sp)
    800016ae:	7aa2                	ld	s5,40(sp)
    800016b0:	6ca2                	ld	s9,8(sp)
    800016b2:	6d02                	ld	s10,0(sp)
}
    800016b4:	60e6                	ld	ra,88(sp)
    800016b6:	6446                	ld	s0,80(sp)
    800016b8:	64a6                	ld	s1,72(sp)
    800016ba:	7a42                	ld	s4,48(sp)
    800016bc:	7b02                	ld	s6,32(sp)
    800016be:	6be2                	ld	s7,24(sp)
    800016c0:	6c42                	ld	s8,16(sp)
    800016c2:	6125                	addi	sp,sp,96
    800016c4:	8082                	ret

00000000800016c6 <copyin>:
  while(len > 0){
    800016c6:	c6c9                	beqz	a3,80001750 <copyin+0x8a>
{
    800016c8:	715d                	addi	sp,sp,-80
    800016ca:	e486                	sd	ra,72(sp)
    800016cc:	e0a2                	sd	s0,64(sp)
    800016ce:	fc26                	sd	s1,56(sp)
    800016d0:	f84a                	sd	s2,48(sp)
    800016d2:	f44e                	sd	s3,40(sp)
    800016d4:	f052                	sd	s4,32(sp)
    800016d6:	ec56                	sd	s5,24(sp)
    800016d8:	e85a                	sd	s6,16(sp)
    800016da:	e45e                	sd	s7,8(sp)
    800016dc:	e062                	sd	s8,0(sp)
    800016de:	0880                	addi	s0,sp,80
    800016e0:	8baa                	mv	s7,a0
    800016e2:	8aae                	mv	s5,a1
    800016e4:	8932                	mv	s2,a2
    800016e6:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    800016e8:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    800016ea:	6b05                	lui	s6,0x1
    800016ec:	a035                	j	80001718 <copyin+0x52>
    800016ee:	412984b3          	sub	s1,s3,s2
    800016f2:	94da                	add	s1,s1,s6
    if(n > len)
    800016f4:	009a7363          	bgeu	s4,s1,800016fa <copyin+0x34>
    800016f8:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016fa:	413905b3          	sub	a1,s2,s3
    800016fe:	0004861b          	sext.w	a2,s1
    80001702:	95aa                	add	a1,a1,a0
    80001704:	8556                	mv	a0,s5
    80001706:	df8ff0ef          	jal	80000cfe <memmove>
    len -= n;
    8000170a:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000170e:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001710:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001714:	020a0163          	beqz	s4,80001736 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001718:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    8000171c:	85ce                	mv	a1,s3
    8000171e:	855e                	mv	a0,s7
    80001720:	891ff0ef          	jal	80000fb0 <walkaddr>
    if(pa0 == 0) {
    80001724:	f569                	bnez	a0,800016ee <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001726:	4601                	li	a2,0
    80001728:	85ce                	mv	a1,s3
    8000172a:	855e                	mv	a0,s7
    8000172c:	e35ff0ef          	jal	80001560 <vmfault>
    80001730:	fd5d                	bnez	a0,800016ee <copyin+0x28>
        return -1;
    80001732:	557d                	li	a0,-1
    80001734:	a011                	j	80001738 <copyin+0x72>
  return 0;
    80001736:	4501                	li	a0,0
}
    80001738:	60a6                	ld	ra,72(sp)
    8000173a:	6406                	ld	s0,64(sp)
    8000173c:	74e2                	ld	s1,56(sp)
    8000173e:	7942                	ld	s2,48(sp)
    80001740:	79a2                	ld	s3,40(sp)
    80001742:	7a02                	ld	s4,32(sp)
    80001744:	6ae2                	ld	s5,24(sp)
    80001746:	6b42                	ld	s6,16(sp)
    80001748:	6ba2                	ld	s7,8(sp)
    8000174a:	6c02                	ld	s8,0(sp)
    8000174c:	6161                	addi	sp,sp,80
    8000174e:	8082                	ret
  return 0;
    80001750:	4501                	li	a0,0
}
    80001752:	8082                	ret

0000000080001754 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001754:	7139                	addi	sp,sp,-64
    80001756:	fc06                	sd	ra,56(sp)
    80001758:	f822                	sd	s0,48(sp)
    8000175a:	f426                	sd	s1,40(sp)
    8000175c:	f04a                	sd	s2,32(sp)
    8000175e:	ec4e                	sd	s3,24(sp)
    80001760:	e852                	sd	s4,16(sp)
    80001762:	e456                	sd	s5,8(sp)
    80001764:	e05a                	sd	s6,0(sp)
    80001766:	0080                	addi	s0,sp,64
    80001768:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000176a:	00012497          	auipc	s1,0x12
    8000176e:	53e48493          	addi	s1,s1,1342 # 80013ca8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001772:	8b26                	mv	s6,s1
    80001774:	feeef937          	lui	s2,0xfeeef
    80001778:	eef90913          	addi	s2,s2,-273 # fffffffffeeeeeef <end+0xffffffff7eec8607>
    8000177c:	0932                	slli	s2,s2,0xc
    8000177e:	eef90913          	addi	s2,s2,-273
    80001782:	0932                	slli	s2,s2,0xc
    80001784:	eef90913          	addi	s2,s2,-273
    80001788:	0932                	slli	s2,s2,0xc
    8000178a:	eef90913          	addi	s2,s2,-273
    8000178e:	040009b7          	lui	s3,0x4000
    80001792:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001794:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001796:	0001aa97          	auipc	s5,0x1a
    8000179a:	d12a8a93          	addi	s5,s5,-750 # 8001b4a8 <tickslock>
    char *pa = kalloc();
    8000179e:	b60ff0ef          	jal	80000afe <kalloc>
    800017a2:	862a                	mv	a2,a0
    if(pa == 0)
    800017a4:	cd15                	beqz	a0,800017e0 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017a6:	416485b3          	sub	a1,s1,s6
    800017aa:	8595                	srai	a1,a1,0x5
    800017ac:	032585b3          	mul	a1,a1,s2
    800017b0:	2585                	addiw	a1,a1,1
    800017b2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017b6:	4719                	li	a4,6
    800017b8:	6685                	lui	a3,0x1
    800017ba:	40b985b3          	sub	a1,s3,a1
    800017be:	8552                	mv	a0,s4
    800017c0:	8dfff0ef          	jal	8000109e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c4:	1e048493          	addi	s1,s1,480
    800017c8:	fd549be3          	bne	s1,s5,8000179e <proc_mapstacks+0x4a>
  }
}
    800017cc:	70e2                	ld	ra,56(sp)
    800017ce:	7442                	ld	s0,48(sp)
    800017d0:	74a2                	ld	s1,40(sp)
    800017d2:	7902                	ld	s2,32(sp)
    800017d4:	69e2                	ld	s3,24(sp)
    800017d6:	6a42                	ld	s4,16(sp)
    800017d8:	6aa2                	ld	s5,8(sp)
    800017da:	6b02                	ld	s6,0(sp)
    800017dc:	6121                	addi	sp,sp,64
    800017de:	8082                	ret
      panic("kalloc");
    800017e0:	00007517          	auipc	a0,0x7
    800017e4:	96850513          	addi	a0,a0,-1688 # 80008148 <etext+0x148>
    800017e8:	ff9fe0ef          	jal	800007e0 <panic>

00000000800017ec <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017ec:	7139                	addi	sp,sp,-64
    800017ee:	fc06                	sd	ra,56(sp)
    800017f0:	f822                	sd	s0,48(sp)
    800017f2:	f426                	sd	s1,40(sp)
    800017f4:	f04a                	sd	s2,32(sp)
    800017f6:	ec4e                	sd	s3,24(sp)
    800017f8:	e852                	sd	s4,16(sp)
    800017fa:	e456                	sd	s5,8(sp)
    800017fc:	e05a                	sd	s6,0(sp)
    800017fe:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001800:	00007597          	auipc	a1,0x7
    80001804:	95058593          	addi	a1,a1,-1712 # 80008150 <etext+0x150>
    80001808:	00012517          	auipc	a0,0x12
    8000180c:	07050513          	addi	a0,a0,112 # 80013878 <pid_lock>
    80001810:	b3eff0ef          	jal	80000b4e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001814:	00007597          	auipc	a1,0x7
    80001818:	94458593          	addi	a1,a1,-1724 # 80008158 <etext+0x158>
    8000181c:	00012517          	auipc	a0,0x12
    80001820:	07450513          	addi	a0,a0,116 # 80013890 <wait_lock>
    80001824:	b2aff0ef          	jal	80000b4e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001828:	00012497          	auipc	s1,0x12
    8000182c:	48048493          	addi	s1,s1,1152 # 80013ca8 <proc>
      initlock(&p->lock, "proc");
    80001830:	00007b17          	auipc	s6,0x7
    80001834:	938b0b13          	addi	s6,s6,-1736 # 80008168 <etext+0x168>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001838:	8aa6                	mv	s5,s1
    8000183a:	feeef937          	lui	s2,0xfeeef
    8000183e:	eef90913          	addi	s2,s2,-273 # fffffffffeeeeeef <end+0xffffffff7eec8607>
    80001842:	0932                	slli	s2,s2,0xc
    80001844:	eef90913          	addi	s2,s2,-273
    80001848:	0932                	slli	s2,s2,0xc
    8000184a:	eef90913          	addi	s2,s2,-273
    8000184e:	0932                	slli	s2,s2,0xc
    80001850:	eef90913          	addi	s2,s2,-273
    80001854:	040009b7          	lui	s3,0x4000
    80001858:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000185a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185c:	0001aa17          	auipc	s4,0x1a
    80001860:	c4ca0a13          	addi	s4,s4,-948 # 8001b4a8 <tickslock>
      initlock(&p->lock, "proc");
    80001864:	85da                	mv	a1,s6
    80001866:	8526                	mv	a0,s1
    80001868:	ae6ff0ef          	jal	80000b4e <initlock>
      p->state = UNUSED;
    8000186c:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001870:	415487b3          	sub	a5,s1,s5
    80001874:	8795                	srai	a5,a5,0x5
    80001876:	032787b3          	mul	a5,a5,s2
    8000187a:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffd8719>
    8000187c:	00d7979b          	slliw	a5,a5,0xd
    80001880:	40f987b3          	sub	a5,s3,a5
    80001884:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001886:	1e048493          	addi	s1,s1,480
    8000188a:	fd449de3          	bne	s1,s4,80001864 <procinit+0x78>
  }
}
    8000188e:	70e2                	ld	ra,56(sp)
    80001890:	7442                	ld	s0,48(sp)
    80001892:	74a2                	ld	s1,40(sp)
    80001894:	7902                	ld	s2,32(sp)
    80001896:	69e2                	ld	s3,24(sp)
    80001898:	6a42                	ld	s4,16(sp)
    8000189a:	6aa2                	ld	s5,8(sp)
    8000189c:	6b02                	ld	s6,0(sp)
    8000189e:	6121                	addi	sp,sp,64
    800018a0:	8082                	ret

00000000800018a2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018a2:	1141                	addi	sp,sp,-16
    800018a4:	e422                	sd	s0,8(sp)
    800018a6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018a8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018aa:	2501                	sext.w	a0,a0
    800018ac:	6422                	ld	s0,8(sp)
    800018ae:	0141                	addi	sp,sp,16
    800018b0:	8082                	ret

00000000800018b2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018b2:	1141                	addi	sp,sp,-16
    800018b4:	e422                	sd	s0,8(sp)
    800018b6:	0800                	addi	s0,sp,16
    800018b8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018ba:	2781                	sext.w	a5,a5
    800018bc:	079e                	slli	a5,a5,0x7
  return c;
}
    800018be:	00012517          	auipc	a0,0x12
    800018c2:	fea50513          	addi	a0,a0,-22 # 800138a8 <cpus>
    800018c6:	953e                	add	a0,a0,a5
    800018c8:	6422                	ld	s0,8(sp)
    800018ca:	0141                	addi	sp,sp,16
    800018cc:	8082                	ret

00000000800018ce <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018ce:	1101                	addi	sp,sp,-32
    800018d0:	ec06                	sd	ra,24(sp)
    800018d2:	e822                	sd	s0,16(sp)
    800018d4:	e426                	sd	s1,8(sp)
    800018d6:	1000                	addi	s0,sp,32
  push_off();
    800018d8:	ab6ff0ef          	jal	80000b8e <push_off>
    800018dc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018de:	2781                	sext.w	a5,a5
    800018e0:	079e                	slli	a5,a5,0x7
    800018e2:	00012717          	auipc	a4,0x12
    800018e6:	f9670713          	addi	a4,a4,-106 # 80013878 <pid_lock>
    800018ea:	97ba                	add	a5,a5,a4
    800018ec:	7b84                	ld	s1,48(a5)
  pop_off();
    800018ee:	b24ff0ef          	jal	80000c12 <pop_off>
  return p;
}
    800018f2:	8526                	mv	a0,s1
    800018f4:	60e2                	ld	ra,24(sp)
    800018f6:	6442                	ld	s0,16(sp)
    800018f8:	64a2                	ld	s1,8(sp)
    800018fa:	6105                	addi	sp,sp,32
    800018fc:	8082                	ret

00000000800018fe <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001908:	fc7ff0ef          	jal	800018ce <myproc>
    8000190c:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000190e:	b58ff0ef          	jal	80000c66 <release>

  if (first) {
    80001912:	0000a797          	auipc	a5,0xa
    80001916:	e0e7a783          	lw	a5,-498(a5) # 8000b720 <first.1>
    8000191a:	cf8d                	beqz	a5,80001954 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000191c:	4505                	li	a0,1
    8000191e:	39c020ef          	jal	80003cba <fsinit>

    first = 0;
    80001922:	0000a797          	auipc	a5,0xa
    80001926:	de07af23          	sw	zero,-514(a5) # 8000b720 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000192a:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    8000192e:	00007517          	auipc	a0,0x7
    80001932:	84250513          	addi	a0,a0,-1982 # 80008170 <etext+0x170>
    80001936:	fca43823          	sd	a0,-48(s0)
    8000193a:	fc043c23          	sd	zero,-40(s0)
    8000193e:	fd040593          	addi	a1,s0,-48
    80001942:	68a030ef          	jal	80004fcc <kexec>
    80001946:	6cbc                	ld	a5,88(s1)
    80001948:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000194a:	6cbc                	ld	a5,88(s1)
    8000194c:	7bb8                	ld	a4,112(a5)
    8000194e:	57fd                	li	a5,-1
    80001950:	02f70d63          	beq	a4,a5,8000198a <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001954:	078010ef          	jal	800029cc <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001958:	68a8                	ld	a0,80(s1)
    8000195a:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000195c:	04000737          	lui	a4,0x4000
    80001960:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001962:	0732                	slli	a4,a4,0xc
    80001964:	00005797          	auipc	a5,0x5
    80001968:	73878793          	addi	a5,a5,1848 # 8000709c <userret>
    8000196c:	00005697          	auipc	a3,0x5
    80001970:	69468693          	addi	a3,a3,1684 # 80007000 <_trampoline>
    80001974:	8f95                	sub	a5,a5,a3
    80001976:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001978:	577d                	li	a4,-1
    8000197a:	177e                	slli	a4,a4,0x3f
    8000197c:	8d59                	or	a0,a0,a4
    8000197e:	9782                	jalr	a5
}
    80001980:	70a2                	ld	ra,40(sp)
    80001982:	7402                	ld	s0,32(sp)
    80001984:	64e2                	ld	s1,24(sp)
    80001986:	6145                	addi	sp,sp,48
    80001988:	8082                	ret
      panic("exec");
    8000198a:	00006517          	auipc	a0,0x6
    8000198e:	7ee50513          	addi	a0,a0,2030 # 80008178 <etext+0x178>
    80001992:	e4ffe0ef          	jal	800007e0 <panic>

0000000080001996 <allocpid>:
{
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	e426                	sd	s1,8(sp)
    8000199e:	e04a                	sd	s2,0(sp)
    800019a0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019a2:	00012917          	auipc	s2,0x12
    800019a6:	ed690913          	addi	s2,s2,-298 # 80013878 <pid_lock>
    800019aa:	854a                	mv	a0,s2
    800019ac:	a22ff0ef          	jal	80000bce <acquire>
  pid = nextpid;
    800019b0:	0000a797          	auipc	a5,0xa
    800019b4:	d7478793          	addi	a5,a5,-652 # 8000b724 <nextpid>
    800019b8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019ba:	0014871b          	addiw	a4,s1,1
    800019be:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019c0:	854a                	mv	a0,s2
    800019c2:	aa4ff0ef          	jal	80000c66 <release>
}
    800019c6:	8526                	mv	a0,s1
    800019c8:	60e2                	ld	ra,24(sp)
    800019ca:	6442                	ld	s0,16(sp)
    800019cc:	64a2                	ld	s1,8(sp)
    800019ce:	6902                	ld	s2,0(sp)
    800019d0:	6105                	addi	sp,sp,32
    800019d2:	8082                	ret

00000000800019d4 <proc_pagetable>:
{
    800019d4:	1101                	addi	sp,sp,-32
    800019d6:	ec06                	sd	ra,24(sp)
    800019d8:	e822                	sd	s0,16(sp)
    800019da:	e426                	sd	s1,8(sp)
    800019dc:	e04a                	sd	s2,0(sp)
    800019de:	1000                	addi	s0,sp,32
    800019e0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019e2:	fb2ff0ef          	jal	80001194 <uvmcreate>
    800019e6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019e8:	cd05                	beqz	a0,80001a20 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019ea:	4729                	li	a4,10
    800019ec:	00005697          	auipc	a3,0x5
    800019f0:	61468693          	addi	a3,a3,1556 # 80007000 <_trampoline>
    800019f4:	6605                	lui	a2,0x1
    800019f6:	040005b7          	lui	a1,0x4000
    800019fa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019fc:	05b2                	slli	a1,a1,0xc
    800019fe:	df0ff0ef          	jal	80000fee <mappages>
    80001a02:	02054663          	bltz	a0,80001a2e <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a06:	4719                	li	a4,6
    80001a08:	05893683          	ld	a3,88(s2)
    80001a0c:	6605                	lui	a2,0x1
    80001a0e:	020005b7          	lui	a1,0x2000
    80001a12:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a14:	05b6                	slli	a1,a1,0xd
    80001a16:	8526                	mv	a0,s1
    80001a18:	dd6ff0ef          	jal	80000fee <mappages>
    80001a1c:	00054f63          	bltz	a0,80001a3a <proc_pagetable+0x66>
}
    80001a20:	8526                	mv	a0,s1
    80001a22:	60e2                	ld	ra,24(sp)
    80001a24:	6442                	ld	s0,16(sp)
    80001a26:	64a2                	ld	s1,8(sp)
    80001a28:	6902                	ld	s2,0(sp)
    80001a2a:	6105                	addi	sp,sp,32
    80001a2c:	8082                	ret
    uvmfree(pagetable, 0);
    80001a2e:	4581                	li	a1,0
    80001a30:	8526                	mv	a0,s1
    80001a32:	95dff0ef          	jal	8000138e <uvmfree>
    return 0;
    80001a36:	4481                	li	s1,0
    80001a38:	b7e5                	j	80001a20 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a3a:	4681                	li	a3,0
    80001a3c:	4605                	li	a2,1
    80001a3e:	040005b7          	lui	a1,0x4000
    80001a42:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a44:	05b2                	slli	a1,a1,0xc
    80001a46:	8526                	mv	a0,s1
    80001a48:	f72ff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    80001a4c:	4581                	li	a1,0
    80001a4e:	8526                	mv	a0,s1
    80001a50:	93fff0ef          	jal	8000138e <uvmfree>
    return 0;
    80001a54:	4481                	li	s1,0
    80001a56:	b7e9                	j	80001a20 <proc_pagetable+0x4c>

0000000080001a58 <proc_freepagetable>:
{
    80001a58:	1101                	addi	sp,sp,-32
    80001a5a:	ec06                	sd	ra,24(sp)
    80001a5c:	e822                	sd	s0,16(sp)
    80001a5e:	e426                	sd	s1,8(sp)
    80001a60:	e04a                	sd	s2,0(sp)
    80001a62:	1000                	addi	s0,sp,32
    80001a64:	84aa                	mv	s1,a0
    80001a66:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a68:	4681                	li	a3,0
    80001a6a:	4605                	li	a2,1
    80001a6c:	040005b7          	lui	a1,0x4000
    80001a70:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a72:	05b2                	slli	a1,a1,0xc
    80001a74:	f46ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a78:	4681                	li	a3,0
    80001a7a:	4605                	li	a2,1
    80001a7c:	020005b7          	lui	a1,0x2000
    80001a80:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a82:	05b6                	slli	a1,a1,0xd
    80001a84:	8526                	mv	a0,s1
    80001a86:	f34ff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    80001a8a:	85ca                	mv	a1,s2
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	901ff0ef          	jal	8000138e <uvmfree>
}
    80001a92:	60e2                	ld	ra,24(sp)
    80001a94:	6442                	ld	s0,16(sp)
    80001a96:	64a2                	ld	s1,8(sp)
    80001a98:	6902                	ld	s2,0(sp)
    80001a9a:	6105                	addi	sp,sp,32
    80001a9c:	8082                	ret

0000000080001a9e <freeproc>:
{
    80001a9e:	1101                	addi	sp,sp,-32
    80001aa0:	ec06                	sd	ra,24(sp)
    80001aa2:	e822                	sd	s0,16(sp)
    80001aa4:	e426                	sd	s1,8(sp)
    80001aa6:	1000                	addi	s0,sp,32
    80001aa8:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001aaa:	6d28                	ld	a0,88(a0)
    80001aac:	c119                	beqz	a0,80001ab2 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001aae:	f6ffe0ef          	jal	80000a1c <kfree>
  p->trapframe = 0;
    80001ab2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001ab6:	68a8                	ld	a0,80(s1)
    80001ab8:	c501                	beqz	a0,80001ac0 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001aba:	64ac                	ld	a1,72(s1)
    80001abc:	f9dff0ef          	jal	80001a58 <proc_freepagetable>
  p->pagetable = 0;
    80001ac0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ac4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ac8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001acc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ad0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001ad4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001ad8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001adc:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ae0:	0004ac23          	sw	zero,24(s1)
  p->energy_budget = 0;
    80001ae4:	1604b823          	sd	zero,368(s1)
  p->energy_consumed = 0;
    80001ae8:	1604bc23          	sd	zero,376(s1)
  p->last_scheduled_tick = 0;
    80001aec:	1804b023          	sd	zero,384(s1)
  p->waiting_for_lock = 0;
    80001af0:	1804b423          	sd	zero,392(s1)
  p->deadlock_reports = 0;
    80001af4:	1804b823          	sd	zero,400(s1)
  p->in_deadlock = 0;
    80001af8:	1804ac23          	sw	zero,408(s1)
  for(int i = 0; i < NRES; i++)
    80001afc:	19c48793          	addi	a5,s1,412
    80001b00:	1dc48713          	addi	a4,s1,476
    p->holding_res[i] = 0;
    80001b04:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < NRES; i++)
    80001b08:	0791                	addi	a5,a5,4
    80001b0a:	fee79de3          	bne	a5,a4,80001b04 <freeproc+0x66>
  p->waiting_res = -1;
    80001b0e:	57fd                	li	a5,-1
    80001b10:	1cf4ae23          	sw	a5,476(s1)
}
    80001b14:	60e2                	ld	ra,24(sp)
    80001b16:	6442                	ld	s0,16(sp)
    80001b18:	64a2                	ld	s1,8(sp)
    80001b1a:	6105                	addi	sp,sp,32
    80001b1c:	8082                	ret

0000000080001b1e <allocproc>:
{
    80001b1e:	1101                	addi	sp,sp,-32
    80001b20:	ec06                	sd	ra,24(sp)
    80001b22:	e822                	sd	s0,16(sp)
    80001b24:	e426                	sd	s1,8(sp)
    80001b26:	e04a                	sd	s2,0(sp)
    80001b28:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b2a:	00012497          	auipc	s1,0x12
    80001b2e:	17e48493          	addi	s1,s1,382 # 80013ca8 <proc>
    80001b32:	0001a917          	auipc	s2,0x1a
    80001b36:	97690913          	addi	s2,s2,-1674 # 8001b4a8 <tickslock>
    acquire(&p->lock);
    80001b3a:	8526                	mv	a0,s1
    80001b3c:	892ff0ef          	jal	80000bce <acquire>
    if(p->state == UNUSED) {
    80001b40:	4c9c                	lw	a5,24(s1)
    80001b42:	cb91                	beqz	a5,80001b56 <allocproc+0x38>
      release(&p->lock);
    80001b44:	8526                	mv	a0,s1
    80001b46:	920ff0ef          	jal	80000c66 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b4a:	1e048493          	addi	s1,s1,480
    80001b4e:	ff2496e3          	bne	s1,s2,80001b3a <allocproc+0x1c>
  return 0;
    80001b52:	4481                	li	s1,0
    80001b54:	a8ad                	j	80001bce <allocproc+0xb0>
  p->pid = allocpid();
    80001b56:	e41ff0ef          	jal	80001996 <allocpid>
    80001b5a:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b5c:	4785                	li	a5,1
    80001b5e:	cc9c                	sw	a5,24(s1)
  p-> waiting_tick = 0;
    80001b60:	1604a423          	sw	zero,360(s1)
  p->energy_budget = DEFAULT_ENERGY_BUDGET;
    80001b64:	3e800793          	li	a5,1000
    80001b68:	16f4b823          	sd	a5,368(s1)
  p->energy_consumed = 0;
    80001b6c:	1604bc23          	sd	zero,376(s1)
  p->last_scheduled_tick = 0;
    80001b70:	1804b023          	sd	zero,384(s1)
  p->waiting_for_lock = 0;
    80001b74:	1804b423          	sd	zero,392(s1)
  p->deadlock_reports = 0;
    80001b78:	1804b823          	sd	zero,400(s1)
  p->in_deadlock = 0;
    80001b7c:	1804ac23          	sw	zero,408(s1)
  for(int i = 0; i < NRES; i++)
    80001b80:	19c48793          	addi	a5,s1,412
    80001b84:	1dc48713          	addi	a4,s1,476
    p->holding_res[i] = 0;
    80001b88:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < NRES; i++)
    80001b8c:	0791                	addi	a5,a5,4
    80001b8e:	fee79de3          	bne	a5,a4,80001b88 <allocproc+0x6a>
  p->waiting_res = -1;
    80001b92:	57fd                	li	a5,-1
    80001b94:	1cf4ae23          	sw	a5,476(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b98:	f67fe0ef          	jal	80000afe <kalloc>
    80001b9c:	892a                	mv	s2,a0
    80001b9e:	eca8                	sd	a0,88(s1)
    80001ba0:	cd15                	beqz	a0,80001bdc <allocproc+0xbe>
  p->pagetable = proc_pagetable(p);
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	e31ff0ef          	jal	800019d4 <proc_pagetable>
    80001ba8:	892a                	mv	s2,a0
    80001baa:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001bac:	c121                	beqz	a0,80001bec <allocproc+0xce>
  memset(&p->context, 0, sizeof(p->context));
    80001bae:	07000613          	li	a2,112
    80001bb2:	4581                	li	a1,0
    80001bb4:	06048513          	addi	a0,s1,96
    80001bb8:	8eaff0ef          	jal	80000ca2 <memset>
  p->context.ra = (uint64)forkret;
    80001bbc:	00000797          	auipc	a5,0x0
    80001bc0:	d4278793          	addi	a5,a5,-702 # 800018fe <forkret>
    80001bc4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001bc6:	60bc                	ld	a5,64(s1)
    80001bc8:	6705                	lui	a4,0x1
    80001bca:	97ba                	add	a5,a5,a4
    80001bcc:	f4bc                	sd	a5,104(s1)
}
    80001bce:	8526                	mv	a0,s1
    80001bd0:	60e2                	ld	ra,24(sp)
    80001bd2:	6442                	ld	s0,16(sp)
    80001bd4:	64a2                	ld	s1,8(sp)
    80001bd6:	6902                	ld	s2,0(sp)
    80001bd8:	6105                	addi	sp,sp,32
    80001bda:	8082                	ret
    freeproc(p);
    80001bdc:	8526                	mv	a0,s1
    80001bde:	ec1ff0ef          	jal	80001a9e <freeproc>
    release(&p->lock);
    80001be2:	8526                	mv	a0,s1
    80001be4:	882ff0ef          	jal	80000c66 <release>
    return 0;
    80001be8:	84ca                	mv	s1,s2
    80001bea:	b7d5                	j	80001bce <allocproc+0xb0>
    freeproc(p);
    80001bec:	8526                	mv	a0,s1
    80001bee:	eb1ff0ef          	jal	80001a9e <freeproc>
    release(&p->lock);
    80001bf2:	8526                	mv	a0,s1
    80001bf4:	872ff0ef          	jal	80000c66 <release>
    return 0;
    80001bf8:	84ca                	mv	s1,s2
    80001bfa:	bfd1                	j	80001bce <allocproc+0xb0>

0000000080001bfc <userinit>:
{
    80001bfc:	1101                	addi	sp,sp,-32
    80001bfe:	ec06                	sd	ra,24(sp)
    80001c00:	e822                	sd	s0,16(sp)
    80001c02:	e426                	sd	s1,8(sp)
    80001c04:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c06:	f19ff0ef          	jal	80001b1e <allocproc>
    80001c0a:	84aa                	mv	s1,a0
  initproc = p;
    80001c0c:	0000a797          	auipc	a5,0xa
    80001c10:	b6a7b223          	sd	a0,-1180(a5) # 8000b770 <initproc>
  p->cwd = namei("/");
    80001c14:	00006517          	auipc	a0,0x6
    80001c18:	56c50513          	addi	a0,a0,1388 # 80008180 <etext+0x180>
    80001c1c:	5c0020ef          	jal	800041dc <namei>
    80001c20:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c24:	478d                	li	a5,3
    80001c26:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	83cff0ef          	jal	80000c66 <release>
}
    80001c2e:	60e2                	ld	ra,24(sp)
    80001c30:	6442                	ld	s0,16(sp)
    80001c32:	64a2                	ld	s1,8(sp)
    80001c34:	6105                	addi	sp,sp,32
    80001c36:	8082                	ret

0000000080001c38 <growproc>:
{
    80001c38:	1101                	addi	sp,sp,-32
    80001c3a:	ec06                	sd	ra,24(sp)
    80001c3c:	e822                	sd	s0,16(sp)
    80001c3e:	e426                	sd	s1,8(sp)
    80001c40:	e04a                	sd	s2,0(sp)
    80001c42:	1000                	addi	s0,sp,32
    80001c44:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c46:	c89ff0ef          	jal	800018ce <myproc>
    80001c4a:	892a                	mv	s2,a0
  sz = p->sz;
    80001c4c:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c4e:	02905963          	blez	s1,80001c80 <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001c52:	00b48633          	add	a2,s1,a1
    80001c56:	020007b7          	lui	a5,0x2000
    80001c5a:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c5c:	07b6                	slli	a5,a5,0xd
    80001c5e:	02c7ea63          	bltu	a5,a2,80001c92 <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c62:	4691                	li	a3,4
    80001c64:	6928                	ld	a0,80(a0)
    80001c66:	e22ff0ef          	jal	80001288 <uvmalloc>
    80001c6a:	85aa                	mv	a1,a0
    80001c6c:	c50d                	beqz	a0,80001c96 <growproc+0x5e>
  p->sz = sz;
    80001c6e:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c72:	4501                	li	a0,0
}
    80001c74:	60e2                	ld	ra,24(sp)
    80001c76:	6442                	ld	s0,16(sp)
    80001c78:	64a2                	ld	s1,8(sp)
    80001c7a:	6902                	ld	s2,0(sp)
    80001c7c:	6105                	addi	sp,sp,32
    80001c7e:	8082                	ret
  } else if(n < 0){
    80001c80:	fe04d7e3          	bgez	s1,80001c6e <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c84:	00b48633          	add	a2,s1,a1
    80001c88:	6928                	ld	a0,80(a0)
    80001c8a:	dbaff0ef          	jal	80001244 <uvmdealloc>
    80001c8e:	85aa                	mv	a1,a0
    80001c90:	bff9                	j	80001c6e <growproc+0x36>
      return -1;
    80001c92:	557d                	li	a0,-1
    80001c94:	b7c5                	j	80001c74 <growproc+0x3c>
      return -1;
    80001c96:	557d                	li	a0,-1
    80001c98:	bff1                	j	80001c74 <growproc+0x3c>

0000000080001c9a <kfork>:
{
    80001c9a:	7139                	addi	sp,sp,-64
    80001c9c:	fc06                	sd	ra,56(sp)
    80001c9e:	f822                	sd	s0,48(sp)
    80001ca0:	f04a                	sd	s2,32(sp)
    80001ca2:	e456                	sd	s5,8(sp)
    80001ca4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001ca6:	c29ff0ef          	jal	800018ce <myproc>
    80001caa:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001cac:	e73ff0ef          	jal	80001b1e <allocproc>
    80001cb0:	0e050a63          	beqz	a0,80001da4 <kfork+0x10a>
    80001cb4:	e852                	sd	s4,16(sp)
    80001cb6:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001cb8:	048ab603          	ld	a2,72(s5)
    80001cbc:	692c                	ld	a1,80(a0)
    80001cbe:	050ab503          	ld	a0,80(s5)
    80001cc2:	efeff0ef          	jal	800013c0 <uvmcopy>
    80001cc6:	04054a63          	bltz	a0,80001d1a <kfork+0x80>
    80001cca:	f426                	sd	s1,40(sp)
    80001ccc:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001cce:	048ab783          	ld	a5,72(s5)
    80001cd2:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001cd6:	058ab683          	ld	a3,88(s5)
    80001cda:	87b6                	mv	a5,a3
    80001cdc:	058a3703          	ld	a4,88(s4)
    80001ce0:	12068693          	addi	a3,a3,288
    80001ce4:	0007b803          	ld	a6,0(a5)
    80001ce8:	6788                	ld	a0,8(a5)
    80001cea:	6b8c                	ld	a1,16(a5)
    80001cec:	6f90                	ld	a2,24(a5)
    80001cee:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001cf2:	e708                	sd	a0,8(a4)
    80001cf4:	eb0c                	sd	a1,16(a4)
    80001cf6:	ef10                	sd	a2,24(a4)
    80001cf8:	02078793          	addi	a5,a5,32
    80001cfc:	02070713          	addi	a4,a4,32
    80001d00:	fed792e3          	bne	a5,a3,80001ce4 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001d04:	058a3783          	ld	a5,88(s4)
    80001d08:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001d0c:	0d0a8493          	addi	s1,s5,208
    80001d10:	0d0a0913          	addi	s2,s4,208
    80001d14:	150a8993          	addi	s3,s5,336
    80001d18:	a831                	j	80001d34 <kfork+0x9a>
    freeproc(np);
    80001d1a:	8552                	mv	a0,s4
    80001d1c:	d83ff0ef          	jal	80001a9e <freeproc>
    release(&np->lock);
    80001d20:	8552                	mv	a0,s4
    80001d22:	f45fe0ef          	jal	80000c66 <release>
    return -1;
    80001d26:	597d                	li	s2,-1
    80001d28:	6a42                	ld	s4,16(sp)
    80001d2a:	a0b5                	j	80001d96 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001d2c:	04a1                	addi	s1,s1,8
    80001d2e:	0921                	addi	s2,s2,8
    80001d30:	01348963          	beq	s1,s3,80001d42 <kfork+0xa8>
    if(p->ofile[i])
    80001d34:	6088                	ld	a0,0(s1)
    80001d36:	d97d                	beqz	a0,80001d2c <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d38:	3dd020ef          	jal	80004914 <filedup>
    80001d3c:	00a93023          	sd	a0,0(s2)
    80001d40:	b7f5                	j	80001d2c <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001d42:	150ab503          	ld	a0,336(s5)
    80001d46:	44b010ef          	jal	80003990 <idup>
    80001d4a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d4e:	4641                	li	a2,16
    80001d50:	158a8593          	addi	a1,s5,344
    80001d54:	158a0513          	addi	a0,s4,344
    80001d58:	888ff0ef          	jal	80000de0 <safestrcpy>
  pid = np->pid;
    80001d5c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001d60:	8552                	mv	a0,s4
    80001d62:	f05fe0ef          	jal	80000c66 <release>
  acquire(&wait_lock);
    80001d66:	00012497          	auipc	s1,0x12
    80001d6a:	b2a48493          	addi	s1,s1,-1238 # 80013890 <wait_lock>
    80001d6e:	8526                	mv	a0,s1
    80001d70:	e5ffe0ef          	jal	80000bce <acquire>
  np->parent = p;
    80001d74:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d78:	8526                	mv	a0,s1
    80001d7a:	eedfe0ef          	jal	80000c66 <release>
  acquire(&np->lock);
    80001d7e:	8552                	mv	a0,s4
    80001d80:	e4ffe0ef          	jal	80000bce <acquire>
  np->state = RUNNABLE;
    80001d84:	478d                	li	a5,3
    80001d86:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d8a:	8552                	mv	a0,s4
    80001d8c:	edbfe0ef          	jal	80000c66 <release>
  return pid;
    80001d90:	74a2                	ld	s1,40(sp)
    80001d92:	69e2                	ld	s3,24(sp)
    80001d94:	6a42                	ld	s4,16(sp)
}
    80001d96:	854a                	mv	a0,s2
    80001d98:	70e2                	ld	ra,56(sp)
    80001d9a:	7442                	ld	s0,48(sp)
    80001d9c:	7902                	ld	s2,32(sp)
    80001d9e:	6aa2                	ld	s5,8(sp)
    80001da0:	6121                	addi	sp,sp,64
    80001da2:	8082                	ret
    return -1;
    80001da4:	597d                	li	s2,-1
    80001da6:	bfc5                	j	80001d96 <kfork+0xfc>

0000000080001da8 <scheduler>:
{
    80001da8:	715d                	addi	sp,sp,-80
    80001daa:	e486                	sd	ra,72(sp)
    80001dac:	e0a2                	sd	s0,64(sp)
    80001dae:	fc26                	sd	s1,56(sp)
    80001db0:	f84a                	sd	s2,48(sp)
    80001db2:	f44e                	sd	s3,40(sp)
    80001db4:	f052                	sd	s4,32(sp)
    80001db6:	ec56                	sd	s5,24(sp)
    80001db8:	e85a                	sd	s6,16(sp)
    80001dba:	e45e                	sd	s7,8(sp)
    80001dbc:	e062                	sd	s8,0(sp)
    80001dbe:	0880                	addi	s0,sp,80
    80001dc0:	8792                	mv	a5,tp
  int id = r_tp();
    80001dc2:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001dc4:	00779693          	slli	a3,a5,0x7
    80001dc8:	00012717          	auipc	a4,0x12
    80001dcc:	ab070713          	addi	a4,a4,-1360 # 80013878 <pid_lock>
    80001dd0:	9736                	add	a4,a4,a3
    80001dd2:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &chosen->context);
    80001dd6:	00012717          	auipc	a4,0x12
    80001dda:	ada70713          	addi	a4,a4,-1318 # 800138b0 <cpus+0x8>
    80001dde:	00e68c33          	add	s8,a3,a4
         strncmp(p->parent->name, "schedtest", 16) == 0 &&
    80001de2:	06400a93          	li	s5,100
    for(p = proc; p < &proc[NPROC]; p++){
    80001de6:	00019917          	auipc	s2,0x19
    80001dea:	6c290913          	addi	s2,s2,1730 # 8001b4a8 <tickslock>
      c->proc = chosen;
    80001dee:	00012b17          	auipc	s6,0x12
    80001df2:	a8ab0b13          	addi	s6,s6,-1398 # 80013878 <pid_lock>
    80001df6:	9b36                	add	s6,s6,a3
    80001df8:	a2b1                	j	80001f44 <scheduler+0x19c>
      release(&p->lock);
    80001dfa:	8526                	mv	a0,s1
    80001dfc:	e6bfe0ef          	jal	80000c66 <release>
    for(p = proc; p < &proc[NPROC]; p++){
    80001e00:	1e048493          	addi	s1,s1,480
    80001e04:	05248363          	beq	s1,s2,80001e4a <scheduler+0xa2>
      acquire(&p->lock);
    80001e08:	8526                	mv	a0,s1
    80001e0a:	dc5fe0ef          	jal	80000bce <acquire>
      if(p->state == RUNNABLE &&
    80001e0e:	4c9c                	lw	a5,24(s1)
    80001e10:	ff3795e3          	bne	a5,s3,80001dfa <scheduler+0x52>
         p->parent != 0 &&
    80001e14:	7c88                	ld	a0,56(s1)
      if(p->state == RUNNABLE &&
    80001e16:	d175                	beqz	a0,80001dfa <scheduler+0x52>
         strncmp(p->parent->name, "schedtest", 16) == 0 &&
    80001e18:	4641                	li	a2,16
    80001e1a:	85de                	mv	a1,s7
    80001e1c:	15850513          	addi	a0,a0,344
    80001e20:	f4ffe0ef          	jal	80000d6e <strncmp>
         p->parent != 0 &&
    80001e24:	f979                	bnez	a0,80001dfa <scheduler+0x52>
         strncmp(p->parent->name, "schedtest", 16) == 0 &&
    80001e26:	1704b783          	ld	a5,368(s1)
    80001e2a:	fcfaf8e3          	bgeu	s5,a5,80001dfa <scheduler+0x52>
        if(chosen == 0 || p->pid < chosen->pid){
    80001e2e:	000a0c63          	beqz	s4,80001e46 <scheduler+0x9e>
    80001e32:	5898                	lw	a4,48(s1)
    80001e34:	030a2783          	lw	a5,48(s4)
    80001e38:	fcf751e3          	bge	a4,a5,80001dfa <scheduler+0x52>
            release(&chosen->lock);
    80001e3c:	8552                	mv	a0,s4
    80001e3e:	e29fe0ef          	jal	80000c66 <release>
          chosen = p;
    80001e42:	8a26                	mv	s4,s1
    80001e44:	bf75                	j	80001e00 <scheduler+0x58>
    80001e46:	8a26                	mv	s4,s1
    80001e48:	bf65                	j	80001e00 <scheduler+0x58>
    if(chosen == 0){
    80001e4a:	000a0c63          	beqz	s4,80001e62 <scheduler+0xba>
      for(p = proc; p < &proc[NPROC]; p++){
    80001e4e:	00012497          	auipc	s1,0x12
    80001e52:	e5a48493          	addi	s1,s1,-422 # 80013ca8 <proc>
        if(p->state == RUNNABLE &&
    80001e56:	498d                	li	s3,3
           strncmp(p->parent->name, "schedtest", 16) == 0)
    80001e58:	00006b97          	auipc	s7,0x6
    80001e5c:	330b8b93          	addi	s7,s7,816 # 80008188 <etext+0x188>
    80001e60:	a851                	j	80001ef4 <scheduler+0x14c>
      for(p = proc; p < &proc[NPROC]; p++){
    80001e62:	00012497          	auipc	s1,0x12
    80001e66:	e4648493          	addi	s1,s1,-442 # 80013ca8 <proc>
    80001e6a:	a801                	j	80001e7a <scheduler+0xd2>
        release(&p->lock);
    80001e6c:	8526                	mv	a0,s1
    80001e6e:	df9fe0ef          	jal	80000c66 <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001e72:	1e048493          	addi	s1,s1,480
    80001e76:	05248263          	beq	s1,s2,80001eba <scheduler+0x112>
        acquire(&p->lock);
    80001e7a:	8526                	mv	a0,s1
    80001e7c:	d53fe0ef          	jal	80000bce <acquire>
        if(p->state == RUNNABLE &&
    80001e80:	4c9c                	lw	a5,24(s1)
    80001e82:	ff3795e3          	bne	a5,s3,80001e6c <scheduler+0xc4>
           p->parent != 0 &&
    80001e86:	7c88                	ld	a0,56(s1)
        if(p->state == RUNNABLE &&
    80001e88:	d175                	beqz	a0,80001e6c <scheduler+0xc4>
           strncmp(p->parent->name, "schedtest", 16) == 0)
    80001e8a:	4641                	li	a2,16
    80001e8c:	85de                	mv	a1,s7
    80001e8e:	15850513          	addi	a0,a0,344
    80001e92:	eddfe0ef          	jal	80000d6e <strncmp>
           p->parent != 0 &&
    80001e96:	f979                	bnez	a0,80001e6c <scheduler+0xc4>
          if(chosen == 0 || p->pid < chosen->pid){
    80001e98:	000a0a63          	beqz	s4,80001eac <scheduler+0x104>
    80001e9c:	5898                	lw	a4,48(s1)
    80001e9e:	030a2783          	lw	a5,48(s4)
    80001ea2:	fcf755e3          	bge	a4,a5,80001e6c <scheduler+0xc4>
              release(&chosen->lock);
    80001ea6:	8552                	mv	a0,s4
    80001ea8:	dbffe0ef          	jal	80000c66 <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001eac:	1e048793          	addi	a5,s1,480
    80001eb0:	0b278b63          	beq	a5,s2,80001f66 <scheduler+0x1be>
    80001eb4:	8a26                	mv	s4,s1
    80001eb6:	84be                	mv	s1,a5
    80001eb8:	b7c9                	j	80001e7a <scheduler+0xd2>
    if(chosen == 0){
    80001eba:	f80a1ae3          	bnez	s4,80001e4e <scheduler+0xa6>
      for(p = proc; p < &proc[NPROC]; p++){
    80001ebe:	00012a17          	auipc	s4,0x12
    80001ec2:	deaa0a13          	addi	s4,s4,-534 # 80013ca8 <proc>
        if(p->state == RUNNABLE){
    80001ec6:	448d                	li	s1,3
        acquire(&p->lock);
    80001ec8:	8552                	mv	a0,s4
    80001eca:	d05fe0ef          	jal	80000bce <acquire>
        if(p->state == RUNNABLE){
    80001ece:	018a2783          	lw	a5,24(s4)
    80001ed2:	f6978ee3          	beq	a5,s1,80001e4e <scheduler+0xa6>
        release(&p->lock);
    80001ed6:	8552                	mv	a0,s4
    80001ed8:	d8ffe0ef          	jal	80000c66 <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001edc:	1e0a0a13          	addi	s4,s4,480
    80001ee0:	ff2a14e3          	bne	s4,s2,80001ec8 <scheduler+0x120>
    80001ee4:	a0ad                	j	80001f4e <scheduler+0x1a6>
        release(&p->lock);
    80001ee6:	8526                	mv	a0,s1
    80001ee8:	d7ffe0ef          	jal	80000c66 <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001eec:	1e048493          	addi	s1,s1,480
    80001ef0:	03248963          	beq	s1,s2,80001f22 <scheduler+0x17a>
        if(p == chosen)
    80001ef4:	fe9a0ce3          	beq	s4,s1,80001eec <scheduler+0x144>
        acquire(&p->lock);
    80001ef8:	8526                	mv	a0,s1
    80001efa:	cd5fe0ef          	jal	80000bce <acquire>
        if(p->state == RUNNABLE &&
    80001efe:	4c9c                	lw	a5,24(s1)
    80001f00:	ff3793e3          	bne	a5,s3,80001ee6 <scheduler+0x13e>
           p->parent != 0 &&
    80001f04:	7c88                	ld	a0,56(s1)
        if(p->state == RUNNABLE &&
    80001f06:	d165                	beqz	a0,80001ee6 <scheduler+0x13e>
           strncmp(p->parent->name, "schedtest", 16) == 0)
    80001f08:	4641                	li	a2,16
    80001f0a:	85de                	mv	a1,s7
    80001f0c:	15850513          	addi	a0,a0,344
    80001f10:	e5ffe0ef          	jal	80000d6e <strncmp>
           p->parent != 0 &&
    80001f14:	f969                	bnez	a0,80001ee6 <scheduler+0x13e>
          p->waiting_tick++;
    80001f16:	1684a783          	lw	a5,360(s1)
    80001f1a:	2785                	addiw	a5,a5,1
    80001f1c:	16f4a423          	sw	a5,360(s1)
    80001f20:	b7d9                	j	80001ee6 <scheduler+0x13e>
      chosen->state = RUNNING;
    80001f22:	4791                	li	a5,4
    80001f24:	00fa2c23          	sw	a5,24(s4)
      chosen->last_scheduled_tick = 0;  // Reset tick counter for this scheduling period
    80001f28:	180a3023          	sd	zero,384(s4)
      c->proc = chosen;
    80001f2c:	034b3823          	sd	s4,48(s6)
      swtch(&c->context, &chosen->context);
    80001f30:	060a0593          	addi	a1,s4,96
    80001f34:	8562                	mv	a0,s8
    80001f36:	1f1000ef          	jal	80002926 <swtch>
      c->proc = 0;
    80001f3a:	020b3823          	sd	zero,48(s6)
      release(&chosen->lock);
    80001f3e:	8552                	mv	a0,s4
    80001f40:	d27fe0ef          	jal	80000c66 <release>
      if(p->state == RUNNABLE &&
    80001f44:	498d                	li	s3,3
         strncmp(p->parent->name, "schedtest", 16) == 0 &&
    80001f46:	00006b97          	auipc	s7,0x6
    80001f4a:	242b8b93          	addi	s7,s7,578 # 80008188 <etext+0x188>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f4e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f52:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f56:	10079073          	csrw	sstatus,a5
    struct proc *chosen = 0;
    80001f5a:	4a01                	li	s4,0
    for(p = proc; p < &proc[NPROC]; p++){
    80001f5c:	00012497          	auipc	s1,0x12
    80001f60:	d4c48493          	addi	s1,s1,-692 # 80013ca8 <proc>
    80001f64:	b555                	j	80001e08 <scheduler+0x60>
      for(p = proc; p < &proc[NPROC]; p++){
    80001f66:	8a26                	mv	s4,s1
    80001f68:	b5dd                	j	80001e4e <scheduler+0xa6>

0000000080001f6a <sched>:
{
    80001f6a:	7179                	addi	sp,sp,-48
    80001f6c:	f406                	sd	ra,40(sp)
    80001f6e:	f022                	sd	s0,32(sp)
    80001f70:	ec26                	sd	s1,24(sp)
    80001f72:	e84a                	sd	s2,16(sp)
    80001f74:	e44e                	sd	s3,8(sp)
    80001f76:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f78:	957ff0ef          	jal	800018ce <myproc>
    80001f7c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f7e:	be7fe0ef          	jal	80000b64 <holding>
    80001f82:	c92d                	beqz	a0,80001ff4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f84:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f86:	2781                	sext.w	a5,a5
    80001f88:	079e                	slli	a5,a5,0x7
    80001f8a:	00012717          	auipc	a4,0x12
    80001f8e:	8ee70713          	addi	a4,a4,-1810 # 80013878 <pid_lock>
    80001f92:	97ba                	add	a5,a5,a4
    80001f94:	0a87a703          	lw	a4,168(a5)
    80001f98:	4785                	li	a5,1
    80001f9a:	06f71363          	bne	a4,a5,80002000 <sched+0x96>
  if(p->state == RUNNING)
    80001f9e:	4c98                	lw	a4,24(s1)
    80001fa0:	4791                	li	a5,4
    80001fa2:	06f70563          	beq	a4,a5,8000200c <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fa6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001faa:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001fac:	e7b5                	bnez	a5,80002018 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fae:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001fb0:	00012917          	auipc	s2,0x12
    80001fb4:	8c890913          	addi	s2,s2,-1848 # 80013878 <pid_lock>
    80001fb8:	2781                	sext.w	a5,a5
    80001fba:	079e                	slli	a5,a5,0x7
    80001fbc:	97ca                	add	a5,a5,s2
    80001fbe:	0ac7a983          	lw	s3,172(a5)
    80001fc2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fc4:	2781                	sext.w	a5,a5
    80001fc6:	079e                	slli	a5,a5,0x7
    80001fc8:	00012597          	auipc	a1,0x12
    80001fcc:	8e858593          	addi	a1,a1,-1816 # 800138b0 <cpus+0x8>
    80001fd0:	95be                	add	a1,a1,a5
    80001fd2:	06048513          	addi	a0,s1,96
    80001fd6:	151000ef          	jal	80002926 <swtch>
    80001fda:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fdc:	2781                	sext.w	a5,a5
    80001fde:	079e                	slli	a5,a5,0x7
    80001fe0:	993e                	add	s2,s2,a5
    80001fe2:	0b392623          	sw	s3,172(s2)
}
    80001fe6:	70a2                	ld	ra,40(sp)
    80001fe8:	7402                	ld	s0,32(sp)
    80001fea:	64e2                	ld	s1,24(sp)
    80001fec:	6942                	ld	s2,16(sp)
    80001fee:	69a2                	ld	s3,8(sp)
    80001ff0:	6145                	addi	sp,sp,48
    80001ff2:	8082                	ret
    panic("sched p->lock");
    80001ff4:	00006517          	auipc	a0,0x6
    80001ff8:	1a450513          	addi	a0,a0,420 # 80008198 <etext+0x198>
    80001ffc:	fe4fe0ef          	jal	800007e0 <panic>
    panic("sched locks");
    80002000:	00006517          	auipc	a0,0x6
    80002004:	1a850513          	addi	a0,a0,424 # 800081a8 <etext+0x1a8>
    80002008:	fd8fe0ef          	jal	800007e0 <panic>
    panic("sched RUNNING");
    8000200c:	00006517          	auipc	a0,0x6
    80002010:	1ac50513          	addi	a0,a0,428 # 800081b8 <etext+0x1b8>
    80002014:	fccfe0ef          	jal	800007e0 <panic>
    panic("sched interruptible");
    80002018:	00006517          	auipc	a0,0x6
    8000201c:	1b050513          	addi	a0,a0,432 # 800081c8 <etext+0x1c8>
    80002020:	fc0fe0ef          	jal	800007e0 <panic>

0000000080002024 <yield>:
{
    80002024:	1101                	addi	sp,sp,-32
    80002026:	ec06                	sd	ra,24(sp)
    80002028:	e822                	sd	s0,16(sp)
    8000202a:	e426                	sd	s1,8(sp)
    8000202c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000202e:	8a1ff0ef          	jal	800018ce <myproc>
    80002032:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002034:	b9bfe0ef          	jal	80000bce <acquire>
  p->state = RUNNABLE;
    80002038:	478d                	li	a5,3
    8000203a:	cc9c                	sw	a5,24(s1)
  sched();
    8000203c:	f2fff0ef          	jal	80001f6a <sched>
  release(&p->lock);
    80002040:	8526                	mv	a0,s1
    80002042:	c25fe0ef          	jal	80000c66 <release>
}
    80002046:	60e2                	ld	ra,24(sp)
    80002048:	6442                	ld	s0,16(sp)
    8000204a:	64a2                	ld	s1,8(sp)
    8000204c:	6105                	addi	sp,sp,32
    8000204e:	8082                	ret

0000000080002050 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002050:	7179                	addi	sp,sp,-48
    80002052:	f406                	sd	ra,40(sp)
    80002054:	f022                	sd	s0,32(sp)
    80002056:	ec26                	sd	s1,24(sp)
    80002058:	e84a                	sd	s2,16(sp)
    8000205a:	e44e                	sd	s3,8(sp)
    8000205c:	1800                	addi	s0,sp,48
    8000205e:	89aa                	mv	s3,a0
    80002060:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002062:	86dff0ef          	jal	800018ce <myproc>
    80002066:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002068:	b67fe0ef          	jal	80000bce <acquire>
  release(lk);
    8000206c:	854a                	mv	a0,s2
    8000206e:	bf9fe0ef          	jal	80000c66 <release>

  // Go to sleep.
  p->chan = chan;
    80002072:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002076:	4789                	li	a5,2
    80002078:	cc9c                	sw	a5,24(s1)

  sched();
    8000207a:	ef1ff0ef          	jal	80001f6a <sched>

  // Tidy up.
  p->chan = 0;
    8000207e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002082:	8526                	mv	a0,s1
    80002084:	be3fe0ef          	jal	80000c66 <release>
  acquire(lk);
    80002088:	854a                	mv	a0,s2
    8000208a:	b45fe0ef          	jal	80000bce <acquire>
}
    8000208e:	70a2                	ld	ra,40(sp)
    80002090:	7402                	ld	s0,32(sp)
    80002092:	64e2                	ld	s1,24(sp)
    80002094:	6942                	ld	s2,16(sp)
    80002096:	69a2                	ld	s3,8(sp)
    80002098:	6145                	addi	sp,sp,48
    8000209a:	8082                	ret

000000008000209c <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    8000209c:	7139                	addi	sp,sp,-64
    8000209e:	fc06                	sd	ra,56(sp)
    800020a0:	f822                	sd	s0,48(sp)
    800020a2:	f426                	sd	s1,40(sp)
    800020a4:	f04a                	sd	s2,32(sp)
    800020a6:	ec4e                	sd	s3,24(sp)
    800020a8:	e852                	sd	s4,16(sp)
    800020aa:	e456                	sd	s5,8(sp)
    800020ac:	0080                	addi	s0,sp,64
    800020ae:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800020b0:	00012497          	auipc	s1,0x12
    800020b4:	bf848493          	addi	s1,s1,-1032 # 80013ca8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020b8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020ba:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800020bc:	00019917          	auipc	s2,0x19
    800020c0:	3ec90913          	addi	s2,s2,1004 # 8001b4a8 <tickslock>
    800020c4:	a801                	j	800020d4 <wakeup+0x38>
      }
      release(&p->lock);
    800020c6:	8526                	mv	a0,s1
    800020c8:	b9ffe0ef          	jal	80000c66 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020cc:	1e048493          	addi	s1,s1,480
    800020d0:	03248263          	beq	s1,s2,800020f4 <wakeup+0x58>
    if(p != myproc()){
    800020d4:	ffaff0ef          	jal	800018ce <myproc>
    800020d8:	fea48ae3          	beq	s1,a0,800020cc <wakeup+0x30>
      acquire(&p->lock);
    800020dc:	8526                	mv	a0,s1
    800020de:	af1fe0ef          	jal	80000bce <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800020e2:	4c9c                	lw	a5,24(s1)
    800020e4:	ff3791e3          	bne	a5,s3,800020c6 <wakeup+0x2a>
    800020e8:	709c                	ld	a5,32(s1)
    800020ea:	fd479ee3          	bne	a5,s4,800020c6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800020ee:	0154ac23          	sw	s5,24(s1)
    800020f2:	bfd1                	j	800020c6 <wakeup+0x2a>
    }
  }
}
    800020f4:	70e2                	ld	ra,56(sp)
    800020f6:	7442                	ld	s0,48(sp)
    800020f8:	74a2                	ld	s1,40(sp)
    800020fa:	7902                	ld	s2,32(sp)
    800020fc:	69e2                	ld	s3,24(sp)
    800020fe:	6a42                	ld	s4,16(sp)
    80002100:	6aa2                	ld	s5,8(sp)
    80002102:	6121                	addi	sp,sp,64
    80002104:	8082                	ret

0000000080002106 <reparent>:
{
    80002106:	7179                	addi	sp,sp,-48
    80002108:	f406                	sd	ra,40(sp)
    8000210a:	f022                	sd	s0,32(sp)
    8000210c:	ec26                	sd	s1,24(sp)
    8000210e:	e84a                	sd	s2,16(sp)
    80002110:	e44e                	sd	s3,8(sp)
    80002112:	e052                	sd	s4,0(sp)
    80002114:	1800                	addi	s0,sp,48
    80002116:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002118:	00012497          	auipc	s1,0x12
    8000211c:	b9048493          	addi	s1,s1,-1136 # 80013ca8 <proc>
      pp->parent = initproc;
    80002120:	00009a17          	auipc	s4,0x9
    80002124:	650a0a13          	addi	s4,s4,1616 # 8000b770 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002128:	00019997          	auipc	s3,0x19
    8000212c:	38098993          	addi	s3,s3,896 # 8001b4a8 <tickslock>
    80002130:	a029                	j	8000213a <reparent+0x34>
    80002132:	1e048493          	addi	s1,s1,480
    80002136:	01348b63          	beq	s1,s3,8000214c <reparent+0x46>
    if(pp->parent == p){
    8000213a:	7c9c                	ld	a5,56(s1)
    8000213c:	ff279be3          	bne	a5,s2,80002132 <reparent+0x2c>
      pp->parent = initproc;
    80002140:	000a3503          	ld	a0,0(s4)
    80002144:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002146:	f57ff0ef          	jal	8000209c <wakeup>
    8000214a:	b7e5                	j	80002132 <reparent+0x2c>
}
    8000214c:	70a2                	ld	ra,40(sp)
    8000214e:	7402                	ld	s0,32(sp)
    80002150:	64e2                	ld	s1,24(sp)
    80002152:	6942                	ld	s2,16(sp)
    80002154:	69a2                	ld	s3,8(sp)
    80002156:	6a02                	ld	s4,0(sp)
    80002158:	6145                	addi	sp,sp,48
    8000215a:	8082                	ret

000000008000215c <kexit>:
{
    8000215c:	7179                	addi	sp,sp,-48
    8000215e:	f406                	sd	ra,40(sp)
    80002160:	f022                	sd	s0,32(sp)
    80002162:	ec26                	sd	s1,24(sp)
    80002164:	e84a                	sd	s2,16(sp)
    80002166:	e44e                	sd	s3,8(sp)
    80002168:	e052                	sd	s4,0(sp)
    8000216a:	1800                	addi	s0,sp,48
    8000216c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000216e:	f60ff0ef          	jal	800018ce <myproc>
    80002172:	89aa                	mv	s3,a0
  if(p == initproc)
    80002174:	00009797          	auipc	a5,0x9
    80002178:	5fc7b783          	ld	a5,1532(a5) # 8000b770 <initproc>
    8000217c:	0d050493          	addi	s1,a0,208
    80002180:	15050913          	addi	s2,a0,336
    80002184:	00a79f63          	bne	a5,a0,800021a2 <kexit+0x46>
    panic("init exiting");
    80002188:	00006517          	auipc	a0,0x6
    8000218c:	05850513          	addi	a0,a0,88 # 800081e0 <etext+0x1e0>
    80002190:	e50fe0ef          	jal	800007e0 <panic>
      fileclose(f);
    80002194:	7c6020ef          	jal	8000495a <fileclose>
      p->ofile[fd] = 0;
    80002198:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000219c:	04a1                	addi	s1,s1,8
    8000219e:	01248563          	beq	s1,s2,800021a8 <kexit+0x4c>
    if(p->ofile[fd]){
    800021a2:	6088                	ld	a0,0(s1)
    800021a4:	f965                	bnez	a0,80002194 <kexit+0x38>
    800021a6:	bfdd                	j	8000219c <kexit+0x40>
  begin_op();
    800021a8:	208020ef          	jal	800043b0 <begin_op>
  iput(p->cwd);
    800021ac:	1509b503          	ld	a0,336(s3)
    800021b0:	199010ef          	jal	80003b48 <iput>
  end_op();
    800021b4:	266020ef          	jal	8000441a <end_op>
  p->cwd = 0;
    800021b8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800021bc:	00011497          	auipc	s1,0x11
    800021c0:	6d448493          	addi	s1,s1,1748 # 80013890 <wait_lock>
    800021c4:	8526                	mv	a0,s1
    800021c6:	a09fe0ef          	jal	80000bce <acquire>
  reparent(p);
    800021ca:	854e                	mv	a0,s3
    800021cc:	f3bff0ef          	jal	80002106 <reparent>
  wakeup(p->parent);
    800021d0:	0389b503          	ld	a0,56(s3)
    800021d4:	ec9ff0ef          	jal	8000209c <wakeup>
  acquire(&p->lock);
    800021d8:	854e                	mv	a0,s3
    800021da:	9f5fe0ef          	jal	80000bce <acquire>
  p->xstate = status;
    800021de:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800021e2:	4795                	li	a5,5
    800021e4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800021e8:	8526                	mv	a0,s1
    800021ea:	a7dfe0ef          	jal	80000c66 <release>
  sched();
    800021ee:	d7dff0ef          	jal	80001f6a <sched>
  panic("zombie exit");
    800021f2:	00006517          	auipc	a0,0x6
    800021f6:	ffe50513          	addi	a0,a0,-2 # 800081f0 <etext+0x1f0>
    800021fa:	de6fe0ef          	jal	800007e0 <panic>

00000000800021fe <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800021fe:	7179                	addi	sp,sp,-48
    80002200:	f406                	sd	ra,40(sp)
    80002202:	f022                	sd	s0,32(sp)
    80002204:	ec26                	sd	s1,24(sp)
    80002206:	e84a                	sd	s2,16(sp)
    80002208:	e44e                	sd	s3,8(sp)
    8000220a:	1800                	addi	s0,sp,48
    8000220c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000220e:	00012497          	auipc	s1,0x12
    80002212:	a9a48493          	addi	s1,s1,-1382 # 80013ca8 <proc>
    80002216:	00019997          	auipc	s3,0x19
    8000221a:	29298993          	addi	s3,s3,658 # 8001b4a8 <tickslock>
    acquire(&p->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	9affe0ef          	jal	80000bce <acquire>
    if(p->pid == pid){
    80002224:	589c                	lw	a5,48(s1)
    80002226:	01278b63          	beq	a5,s2,8000223c <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000222a:	8526                	mv	a0,s1
    8000222c:	a3bfe0ef          	jal	80000c66 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002230:	1e048493          	addi	s1,s1,480
    80002234:	ff3495e3          	bne	s1,s3,8000221e <kkill+0x20>
  }
  return -1;
    80002238:	557d                	li	a0,-1
    8000223a:	a819                	j	80002250 <kkill+0x52>
      p->killed = 1;
    8000223c:	4785                	li	a5,1
    8000223e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002240:	4c98                	lw	a4,24(s1)
    80002242:	4789                	li	a5,2
    80002244:	00f70d63          	beq	a4,a5,8000225e <kkill+0x60>
      release(&p->lock);
    80002248:	8526                	mv	a0,s1
    8000224a:	a1dfe0ef          	jal	80000c66 <release>
      return 0;
    8000224e:	4501                	li	a0,0
}
    80002250:	70a2                	ld	ra,40(sp)
    80002252:	7402                	ld	s0,32(sp)
    80002254:	64e2                	ld	s1,24(sp)
    80002256:	6942                	ld	s2,16(sp)
    80002258:	69a2                	ld	s3,8(sp)
    8000225a:	6145                	addi	sp,sp,48
    8000225c:	8082                	ret
        p->state = RUNNABLE;
    8000225e:	478d                	li	a5,3
    80002260:	cc9c                	sw	a5,24(s1)
    80002262:	b7dd                	j	80002248 <kkill+0x4a>

0000000080002264 <setkilled>:

void
setkilled(struct proc *p)
{
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	e426                	sd	s1,8(sp)
    8000226c:	1000                	addi	s0,sp,32
    8000226e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002270:	95ffe0ef          	jal	80000bce <acquire>
  p->killed = 1;
    80002274:	4785                	li	a5,1
    80002276:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002278:	8526                	mv	a0,s1
    8000227a:	9edfe0ef          	jal	80000c66 <release>
}
    8000227e:	60e2                	ld	ra,24(sp)
    80002280:	6442                	ld	s0,16(sp)
    80002282:	64a2                	ld	s1,8(sp)
    80002284:	6105                	addi	sp,sp,32
    80002286:	8082                	ret

0000000080002288 <killed>:

int
killed(struct proc *p)
{
    80002288:	1101                	addi	sp,sp,-32
    8000228a:	ec06                	sd	ra,24(sp)
    8000228c:	e822                	sd	s0,16(sp)
    8000228e:	e426                	sd	s1,8(sp)
    80002290:	e04a                	sd	s2,0(sp)
    80002292:	1000                	addi	s0,sp,32
    80002294:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002296:	939fe0ef          	jal	80000bce <acquire>
  k = p->killed;
    8000229a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000229e:	8526                	mv	a0,s1
    800022a0:	9c7fe0ef          	jal	80000c66 <release>
  return k;
}
    800022a4:	854a                	mv	a0,s2
    800022a6:	60e2                	ld	ra,24(sp)
    800022a8:	6442                	ld	s0,16(sp)
    800022aa:	64a2                	ld	s1,8(sp)
    800022ac:	6902                	ld	s2,0(sp)
    800022ae:	6105                	addi	sp,sp,32
    800022b0:	8082                	ret

00000000800022b2 <kwait>:
{
    800022b2:	715d                	addi	sp,sp,-80
    800022b4:	e486                	sd	ra,72(sp)
    800022b6:	e0a2                	sd	s0,64(sp)
    800022b8:	fc26                	sd	s1,56(sp)
    800022ba:	f84a                	sd	s2,48(sp)
    800022bc:	f44e                	sd	s3,40(sp)
    800022be:	f052                	sd	s4,32(sp)
    800022c0:	ec56                	sd	s5,24(sp)
    800022c2:	e85a                	sd	s6,16(sp)
    800022c4:	e45e                	sd	s7,8(sp)
    800022c6:	e062                	sd	s8,0(sp)
    800022c8:	0880                	addi	s0,sp,80
    800022ca:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800022cc:	e02ff0ef          	jal	800018ce <myproc>
    800022d0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800022d2:	00011517          	auipc	a0,0x11
    800022d6:	5be50513          	addi	a0,a0,1470 # 80013890 <wait_lock>
    800022da:	8f5fe0ef          	jal	80000bce <acquire>
    havekids = 0;
    800022de:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800022e0:	4a15                	li	s4,5
        havekids = 1;
    800022e2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e4:	00019997          	auipc	s3,0x19
    800022e8:	1c498993          	addi	s3,s3,452 # 8001b4a8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800022ec:	00011c17          	auipc	s8,0x11
    800022f0:	5a4c0c13          	addi	s8,s8,1444 # 80013890 <wait_lock>
    800022f4:	a07d                	j	800023a2 <kwait+0xf0>
          printf("schedstats: pid=%d waiting_tick=%d\n", pp->pid, pp->waiting_tick);
    800022f6:	1684a603          	lw	a2,360(s1)
    800022fa:	588c                	lw	a1,48(s1)
    800022fc:	00006517          	auipc	a0,0x6
    80002300:	f0450513          	addi	a0,a0,-252 # 80008200 <etext+0x200>
    80002304:	9f6fe0ef          	jal	800004fa <printf>
          pid = pp->pid;
    80002308:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000230c:	000b0c63          	beqz	s6,80002324 <kwait+0x72>
    80002310:	4691                	li	a3,4
    80002312:	02c48613          	addi	a2,s1,44
    80002316:	85da                	mv	a1,s6
    80002318:	05093503          	ld	a0,80(s2)
    8000231c:	ac6ff0ef          	jal	800015e2 <copyout>
    80002320:	02054b63          	bltz	a0,80002356 <kwait+0xa4>
          freeproc(pp);
    80002324:	8526                	mv	a0,s1
    80002326:	f78ff0ef          	jal	80001a9e <freeproc>
          release(&pp->lock);
    8000232a:	8526                	mv	a0,s1
    8000232c:	93bfe0ef          	jal	80000c66 <release>
          release(&wait_lock);
    80002330:	00011517          	auipc	a0,0x11
    80002334:	56050513          	addi	a0,a0,1376 # 80013890 <wait_lock>
    80002338:	92ffe0ef          	jal	80000c66 <release>
}
    8000233c:	854e                	mv	a0,s3
    8000233e:	60a6                	ld	ra,72(sp)
    80002340:	6406                	ld	s0,64(sp)
    80002342:	74e2                	ld	s1,56(sp)
    80002344:	7942                	ld	s2,48(sp)
    80002346:	79a2                	ld	s3,40(sp)
    80002348:	7a02                	ld	s4,32(sp)
    8000234a:	6ae2                	ld	s5,24(sp)
    8000234c:	6b42                	ld	s6,16(sp)
    8000234e:	6ba2                	ld	s7,8(sp)
    80002350:	6c02                	ld	s8,0(sp)
    80002352:	6161                	addi	sp,sp,80
    80002354:	8082                	ret
            release(&pp->lock);
    80002356:	8526                	mv	a0,s1
    80002358:	90ffe0ef          	jal	80000c66 <release>
            release(&wait_lock);
    8000235c:	00011517          	auipc	a0,0x11
    80002360:	53450513          	addi	a0,a0,1332 # 80013890 <wait_lock>
    80002364:	903fe0ef          	jal	80000c66 <release>
            return -1;
    80002368:	59fd                	li	s3,-1
    8000236a:	bfc9                	j	8000233c <kwait+0x8a>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000236c:	1e048493          	addi	s1,s1,480
    80002370:	03348063          	beq	s1,s3,80002390 <kwait+0xde>
      if(pp->parent == p){
    80002374:	7c9c                	ld	a5,56(s1)
    80002376:	ff279be3          	bne	a5,s2,8000236c <kwait+0xba>
        acquire(&pp->lock);
    8000237a:	8526                	mv	a0,s1
    8000237c:	853fe0ef          	jal	80000bce <acquire>
        if(pp->state == ZOMBIE){
    80002380:	4c9c                	lw	a5,24(s1)
    80002382:	f7478ae3          	beq	a5,s4,800022f6 <kwait+0x44>
        release(&pp->lock);
    80002386:	8526                	mv	a0,s1
    80002388:	8dffe0ef          	jal	80000c66 <release>
        havekids = 1;
    8000238c:	8756                	mv	a4,s5
    8000238e:	bff9                	j	8000236c <kwait+0xba>
    if(!havekids || killed(p)){
    80002390:	cf19                	beqz	a4,800023ae <kwait+0xfc>
    80002392:	854a                	mv	a0,s2
    80002394:	ef5ff0ef          	jal	80002288 <killed>
    80002398:	e919                	bnez	a0,800023ae <kwait+0xfc>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000239a:	85e2                	mv	a1,s8
    8000239c:	854a                	mv	a0,s2
    8000239e:	cb3ff0ef          	jal	80002050 <sleep>
    havekids = 0;
    800023a2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023a4:	00012497          	auipc	s1,0x12
    800023a8:	90448493          	addi	s1,s1,-1788 # 80013ca8 <proc>
    800023ac:	b7e1                	j	80002374 <kwait+0xc2>
      release(&wait_lock);
    800023ae:	00011517          	auipc	a0,0x11
    800023b2:	4e250513          	addi	a0,a0,1250 # 80013890 <wait_lock>
    800023b6:	8b1fe0ef          	jal	80000c66 <release>
      return -1;
    800023ba:	59fd                	li	s3,-1
    800023bc:	b741                	j	8000233c <kwait+0x8a>

00000000800023be <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800023be:	7179                	addi	sp,sp,-48
    800023c0:	f406                	sd	ra,40(sp)
    800023c2:	f022                	sd	s0,32(sp)
    800023c4:	ec26                	sd	s1,24(sp)
    800023c6:	e84a                	sd	s2,16(sp)
    800023c8:	e44e                	sd	s3,8(sp)
    800023ca:	e052                	sd	s4,0(sp)
    800023cc:	1800                	addi	s0,sp,48
    800023ce:	84aa                	mv	s1,a0
    800023d0:	892e                	mv	s2,a1
    800023d2:	89b2                	mv	s3,a2
    800023d4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800023d6:	cf8ff0ef          	jal	800018ce <myproc>
  if(user_dst){
    800023da:	cc99                	beqz	s1,800023f8 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800023dc:	86d2                	mv	a3,s4
    800023de:	864e                	mv	a2,s3
    800023e0:	85ca                	mv	a1,s2
    800023e2:	6928                	ld	a0,80(a0)
    800023e4:	9feff0ef          	jal	800015e2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800023e8:	70a2                	ld	ra,40(sp)
    800023ea:	7402                	ld	s0,32(sp)
    800023ec:	64e2                	ld	s1,24(sp)
    800023ee:	6942                	ld	s2,16(sp)
    800023f0:	69a2                	ld	s3,8(sp)
    800023f2:	6a02                	ld	s4,0(sp)
    800023f4:	6145                	addi	sp,sp,48
    800023f6:	8082                	ret
    memmove((char *)dst, src, len);
    800023f8:	000a061b          	sext.w	a2,s4
    800023fc:	85ce                	mv	a1,s3
    800023fe:	854a                	mv	a0,s2
    80002400:	8fffe0ef          	jal	80000cfe <memmove>
    return 0;
    80002404:	8526                	mv	a0,s1
    80002406:	b7cd                	j	800023e8 <either_copyout+0x2a>

0000000080002408 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002408:	7179                	addi	sp,sp,-48
    8000240a:	f406                	sd	ra,40(sp)
    8000240c:	f022                	sd	s0,32(sp)
    8000240e:	ec26                	sd	s1,24(sp)
    80002410:	e84a                	sd	s2,16(sp)
    80002412:	e44e                	sd	s3,8(sp)
    80002414:	e052                	sd	s4,0(sp)
    80002416:	1800                	addi	s0,sp,48
    80002418:	892a                	mv	s2,a0
    8000241a:	84ae                	mv	s1,a1
    8000241c:	89b2                	mv	s3,a2
    8000241e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002420:	caeff0ef          	jal	800018ce <myproc>
  if(user_src){
    80002424:	cc99                	beqz	s1,80002442 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002426:	86d2                	mv	a3,s4
    80002428:	864e                	mv	a2,s3
    8000242a:	85ca                	mv	a1,s2
    8000242c:	6928                	ld	a0,80(a0)
    8000242e:	a98ff0ef          	jal	800016c6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002432:	70a2                	ld	ra,40(sp)
    80002434:	7402                	ld	s0,32(sp)
    80002436:	64e2                	ld	s1,24(sp)
    80002438:	6942                	ld	s2,16(sp)
    8000243a:	69a2                	ld	s3,8(sp)
    8000243c:	6a02                	ld	s4,0(sp)
    8000243e:	6145                	addi	sp,sp,48
    80002440:	8082                	ret
    memmove(dst, (char*)src, len);
    80002442:	000a061b          	sext.w	a2,s4
    80002446:	85ce                	mv	a1,s3
    80002448:	854a                	mv	a0,s2
    8000244a:	8b5fe0ef          	jal	80000cfe <memmove>
    return 0;
    8000244e:	8526                	mv	a0,s1
    80002450:	b7cd                	j	80002432 <either_copyin+0x2a>

0000000080002452 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002452:	715d                	addi	sp,sp,-80
    80002454:	e486                	sd	ra,72(sp)
    80002456:	e0a2                	sd	s0,64(sp)
    80002458:	fc26                	sd	s1,56(sp)
    8000245a:	f84a                	sd	s2,48(sp)
    8000245c:	f44e                	sd	s3,40(sp)
    8000245e:	f052                	sd	s4,32(sp)
    80002460:	ec56                	sd	s5,24(sp)
    80002462:	e85a                	sd	s6,16(sp)
    80002464:	e45e                	sd	s7,8(sp)
    80002466:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002468:	00006517          	auipc	a0,0x6
    8000246c:	c3050513          	addi	a0,a0,-976 # 80008098 <etext+0x98>
    80002470:	88afe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002474:	00012497          	auipc	s1,0x12
    80002478:	98c48493          	addi	s1,s1,-1652 # 80013e00 <proc+0x158>
    8000247c:	00019917          	auipc	s2,0x19
    80002480:	18490913          	addi	s2,s2,388 # 8001b600 <bcache+0xe0>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002484:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002486:	00006997          	auipc	s3,0x6
    8000248a:	da298993          	addi	s3,s3,-606 # 80008228 <etext+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    8000248e:	00006a97          	auipc	s5,0x6
    80002492:	da2a8a93          	addi	s5,s5,-606 # 80008230 <etext+0x230>
    printf("\n");
    80002496:	00006a17          	auipc	s4,0x6
    8000249a:	c02a0a13          	addi	s4,s4,-1022 # 80008098 <etext+0x98>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000249e:	00006b97          	auipc	s7,0x6
    800024a2:	4f2b8b93          	addi	s7,s7,1266 # 80008990 <states.0>
    800024a6:	a829                	j	800024c0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800024a8:	ed86a583          	lw	a1,-296(a3)
    800024ac:	8556                	mv	a0,s5
    800024ae:	84cfe0ef          	jal	800004fa <printf>
    printf("\n");
    800024b2:	8552                	mv	a0,s4
    800024b4:	846fe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024b8:	1e048493          	addi	s1,s1,480
    800024bc:	03248263          	beq	s1,s2,800024e0 <procdump+0x8e>
    if(p->state == UNUSED)
    800024c0:	86a6                	mv	a3,s1
    800024c2:	ec04a783          	lw	a5,-320(s1)
    800024c6:	dbed                	beqz	a5,800024b8 <procdump+0x66>
      state = "???";
    800024c8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024ca:	fcfb6fe3          	bltu	s6,a5,800024a8 <procdump+0x56>
    800024ce:	02079713          	slli	a4,a5,0x20
    800024d2:	01d75793          	srli	a5,a4,0x1d
    800024d6:	97de                	add	a5,a5,s7
    800024d8:	6390                	ld	a2,0(a5)
    800024da:	f679                	bnez	a2,800024a8 <procdump+0x56>
      state = "???";
    800024dc:	864e                	mv	a2,s3
    800024de:	b7e9                	j	800024a8 <procdump+0x56>
  }
}
    800024e0:	60a6                	ld	ra,72(sp)
    800024e2:	6406                	ld	s0,64(sp)
    800024e4:	74e2                	ld	s1,56(sp)
    800024e6:	7942                	ld	s2,48(sp)
    800024e8:	79a2                	ld	s3,40(sp)
    800024ea:	7a02                	ld	s4,32(sp)
    800024ec:	6ae2                	ld	s5,24(sp)
    800024ee:	6b42                	ld	s6,16(sp)
    800024f0:	6ba2                	ld	s7,8(sp)
    800024f2:	6161                	addi	sp,sp,80
    800024f4:	8082                	ret

00000000800024f6 <kps>:

int
kps(char *arguments)
{
    800024f6:	711d                	addi	sp,sp,-96
    800024f8:	ec86                	sd	ra,88(sp)
    800024fa:	e8a2                	sd	s0,80(sp)
    800024fc:	e4a6                	sd	s1,72(sp)
    800024fe:	1080                	addi	s0,sp,96
    80002500:	84aa                	mv	s1,a0
  int arg_length = 4;
  char *states[] = {"UNUSED", "USED", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE"};
    80002502:	00006797          	auipc	a5,0x6
    80002506:	48e78793          	addi	a5,a5,1166 # 80008990 <states.0>
    8000250a:	0307b803          	ld	a6,48(a5)
    8000250e:	7f8c                	ld	a1,56(a5)
    80002510:	63b0                	ld	a2,64(a5)
    80002512:	67b4                	ld	a3,72(a5)
    80002514:	6bb8                	ld	a4,80(a5)
    80002516:	6fbc                	ld	a5,88(a5)
    80002518:	fb043023          	sd	a6,-96(s0)
    8000251c:	fab43423          	sd	a1,-88(s0)
    80002520:	fac43823          	sd	a2,-80(s0)
    80002524:	fad43c23          	sd	a3,-72(s0)
    80002528:	fce43023          	sd	a4,-64(s0)
    8000252c:	fcf43423          	sd	a5,-56(s0)
  struct proc *p;
  // if user enter "-o" argument
  if (strncmp(arguments, "-o", arg_length) == 0)
    80002530:	4611                	li	a2,4
    80002532:	00006597          	auipc	a1,0x6
    80002536:	d0e58593          	addi	a1,a1,-754 # 80008240 <etext+0x240>
    8000253a:	835fe0ef          	jal	80000d6e <strncmp>
    8000253e:	e13d                	bnez	a0,800025a4 <kps+0xae>
    80002540:	e0ca                	sd	s2,64(sp)
    80002542:	fc4e                	sd	s3,56(sp)
    80002544:	f852                	sd	s4,48(sp)
    80002546:	00012497          	auipc	s1,0x12
    8000254a:	8ba48493          	addi	s1,s1,-1862 # 80013e00 <proc+0x158>
    8000254e:	00019997          	auipc	s3,0x19
    80002552:	0b298993          	addi	s3,s3,178 # 8001b600 <bcache+0xe0>
  {
    for (p = proc; p < &proc[NPROC]; p++)
    {
      // skip/filter out printing the unused processes
      if (strncmp(p->name, "", arg_length) == 0)
    80002556:	00006917          	auipc	s2,0x6
    8000255a:	e4290913          	addi	s2,s2,-446 # 80008398 <etext+0x398>
      {
        continue;
      }
      printf("%s   ", p->name);
    8000255e:	00006a17          	auipc	s4,0x6
    80002562:	ceaa0a13          	addi	s4,s4,-790 # 80008248 <etext+0x248>
    80002566:	a029                	j	80002570 <kps+0x7a>
    for (p = proc; p < &proc[NPROC]; p++)
    80002568:	1e048493          	addi	s1,s1,480
    8000256c:	01348d63          	beq	s1,s3,80002586 <kps+0x90>
      if (strncmp(p->name, "", arg_length) == 0)
    80002570:	4611                	li	a2,4
    80002572:	85ca                	mv	a1,s2
    80002574:	8526                	mv	a0,s1
    80002576:	ff8fe0ef          	jal	80000d6e <strncmp>
    8000257a:	d57d                	beqz	a0,80002568 <kps+0x72>
      printf("%s   ", p->name);
    8000257c:	85a6                	mv	a1,s1
    8000257e:	8552                	mv	a0,s4
    80002580:	f7bfd0ef          	jal	800004fa <printf>
    80002584:	b7d5                	j	80002568 <kps+0x72>
    }
    printf("\n");
    80002586:	00006517          	auipc	a0,0x6
    8000258a:	b1250513          	addi	a0,a0,-1262 # 80008098 <etext+0x98>
    8000258e:	f6dfd0ef          	jal	800004fa <printf>
    80002592:	6906                	ld	s2,64(sp)
    80002594:	79e2                	ld	s3,56(sp)
    80002596:	7a42                	ld	s4,48(sp)
  else
  {
    printf("Usage: ps [-o | -l]\n");
  }
  return 0;
}
    80002598:	4501                	li	a0,0
    8000259a:	60e6                	ld	ra,88(sp)
    8000259c:	6446                	ld	s0,80(sp)
    8000259e:	64a6                	ld	s1,72(sp)
    800025a0:	6125                	addi	sp,sp,96
    800025a2:	8082                	ret
  else if (strncmp(arguments, "-l", arg_length) == 0)
    800025a4:	4611                	li	a2,4
    800025a6:	00006597          	auipc	a1,0x6
    800025aa:	caa58593          	addi	a1,a1,-854 # 80008250 <etext+0x250>
    800025ae:	8526                	mv	a0,s1
    800025b0:	fbefe0ef          	jal	80000d6e <strncmp>
    800025b4:	e151                	bnez	a0,80002638 <kps+0x142>
    800025b6:	e0ca                	sd	s2,64(sp)
    800025b8:	fc4e                	sd	s3,56(sp)
    printf("%s   %s       %s\n", "PID", "STATE", "NAME");
    800025ba:	00006697          	auipc	a3,0x6
    800025be:	c9e68693          	addi	a3,a3,-866 # 80008258 <etext+0x258>
    800025c2:	00006617          	auipc	a2,0x6
    800025c6:	c9e60613          	addi	a2,a2,-866 # 80008260 <etext+0x260>
    800025ca:	00006597          	auipc	a1,0x6
    800025ce:	c9e58593          	addi	a1,a1,-866 # 80008268 <etext+0x268>
    800025d2:	00006517          	auipc	a0,0x6
    800025d6:	c9e50513          	addi	a0,a0,-866 # 80008270 <etext+0x270>
    800025da:	f21fd0ef          	jal	800004fa <printf>
    printf("-------------------------\n");
    800025de:	00006517          	auipc	a0,0x6
    800025e2:	caa50513          	addi	a0,a0,-854 # 80008288 <etext+0x288>
    800025e6:	f15fd0ef          	jal	800004fa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800025ea:	00012497          	auipc	s1,0x12
    800025ee:	81648493          	addi	s1,s1,-2026 # 80013e00 <proc+0x158>
    800025f2:	00019917          	auipc	s2,0x19
    800025f6:	00e90913          	addi	s2,s2,14 # 8001b600 <bcache+0xe0>
      printf("%d     %s    %s\n", p->pid, states[p->state], p->name);
    800025fa:	00006997          	auipc	s3,0x6
    800025fe:	cae98993          	addi	s3,s3,-850 # 800082a8 <etext+0x2a8>
    80002602:	a029                	j	8000260c <kps+0x116>
    for (p = proc; p < &proc[NPROC]; p++)
    80002604:	1e048493          	addi	s1,s1,480
    80002608:	03248563          	beq	s1,s2,80002632 <kps+0x13c>
      if (p->state == 0)
    8000260c:	ec04a783          	lw	a5,-320(s1)
    80002610:	dbf5                	beqz	a5,80002604 <kps+0x10e>
      printf("%d     %s    %s\n", p->pid, states[p->state], p->name);
    80002612:	02079713          	slli	a4,a5,0x20
    80002616:	01d75793          	srli	a5,a4,0x1d
    8000261a:	fd078793          	addi	a5,a5,-48
    8000261e:	97a2                	add	a5,a5,s0
    80002620:	86a6                	mv	a3,s1
    80002622:	fd07b603          	ld	a2,-48(a5)
    80002626:	ed84a583          	lw	a1,-296(s1)
    8000262a:	854e                	mv	a0,s3
    8000262c:	ecffd0ef          	jal	800004fa <printf>
    80002630:	bfd1                	j	80002604 <kps+0x10e>
    80002632:	6906                	ld	s2,64(sp)
    80002634:	79e2                	ld	s3,56(sp)
    80002636:	b78d                	j	80002598 <kps+0xa2>
    printf("Usage: ps [-o | -l]\n");
    80002638:	00006517          	auipc	a0,0x6
    8000263c:	c8850513          	addi	a0,a0,-888 # 800082c0 <etext+0x2c0>
    80002640:	ebbfd0ef          	jal	800004fa <printf>
    80002644:	bf91                	j	80002598 <kps+0xa2>

0000000080002646 <res_acquire>:


// Acquire a resource for the current process (called when a process gets a lock/resource).
void
res_acquire(int res_id)
{
    80002646:	1101                	addi	sp,sp,-32
    80002648:	ec06                	sd	ra,24(sp)
    8000264a:	e822                	sd	s0,16(sp)
    8000264c:	e426                	sd	s1,8(sp)
    8000264e:	1000                	addi	s0,sp,32
    80002650:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002652:	a7cff0ef          	jal	800018ce <myproc>
  if(res_id < 0 || res_id >= NRES)
    80002656:	0004871b          	sext.w	a4,s1
    8000265a:	47bd                	li	a5,15
    8000265c:	00e7f763          	bgeu	a5,a4,8000266a <res_acquire+0x24>
    return;
  acquire(&p->lock);
  p->holding_res[res_id] = 1;
  p->waiting_res = -1;  // no longer waiting
  release(&p->lock);
}
    80002660:	60e2                	ld	ra,24(sp)
    80002662:	6442                	ld	s0,16(sp)
    80002664:	64a2                	ld	s1,8(sp)
    80002666:	6105                	addi	sp,sp,32
    80002668:	8082                	ret
    8000266a:	e04a                	sd	s2,0(sp)
    8000266c:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000266e:	d60fe0ef          	jal	80000bce <acquire>
  p->holding_res[res_id] = 1;
    80002672:	06448493          	addi	s1,s1,100
    80002676:	048a                	slli	s1,s1,0x2
    80002678:	94ca                	add	s1,s1,s2
    8000267a:	4785                	li	a5,1
    8000267c:	c4dc                	sw	a5,12(s1)
  p->waiting_res = -1;  // no longer waiting
    8000267e:	57fd                	li	a5,-1
    80002680:	1cf92e23          	sw	a5,476(s2)
  release(&p->lock);
    80002684:	854a                	mv	a0,s2
    80002686:	de0fe0ef          	jal	80000c66 <release>
    8000268a:	6902                	ld	s2,0(sp)
    8000268c:	bfd1                	j	80002660 <res_acquire+0x1a>

000000008000268e <res_release>:

// Release a resource held by the current process.
void
res_release(int res_id)
{
    8000268e:	1101                	addi	sp,sp,-32
    80002690:	ec06                	sd	ra,24(sp)
    80002692:	e822                	sd	s0,16(sp)
    80002694:	e426                	sd	s1,8(sp)
    80002696:	1000                	addi	s0,sp,32
    80002698:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000269a:	a34ff0ef          	jal	800018ce <myproc>
  if(res_id < 0 || res_id >= NRES)
    8000269e:	0004871b          	sext.w	a4,s1
    800026a2:	47bd                	li	a5,15
    800026a4:	00e7f763          	bgeu	a5,a4,800026b2 <res_release+0x24>
    return;
  acquire(&p->lock);
  p->holding_res[res_id] = 0;
  release(&p->lock);
}
    800026a8:	60e2                	ld	ra,24(sp)
    800026aa:	6442                	ld	s0,16(sp)
    800026ac:	64a2                	ld	s1,8(sp)
    800026ae:	6105                	addi	sp,sp,32
    800026b0:	8082                	ret
    800026b2:	e04a                	sd	s2,0(sp)
    800026b4:	892a                	mv	s2,a0
  acquire(&p->lock);
    800026b6:	d18fe0ef          	jal	80000bce <acquire>
  p->holding_res[res_id] = 0;
    800026ba:	06448493          	addi	s1,s1,100
    800026be:	048a                	slli	s1,s1,0x2
    800026c0:	94ca                	add	s1,s1,s2
    800026c2:	0004a623          	sw	zero,12(s1)
  release(&p->lock);
    800026c6:	854a                	mv	a0,s2
    800026c8:	d9efe0ef          	jal	80000c66 <release>
    800026cc:	6902                	ld	s2,0(sp)
    800026ce:	bfe9                	j	800026a8 <res_release+0x1a>

00000000800026d0 <res_wait>:

// Mark that the current process is waiting for a resource.
void
res_wait(int res_id)
{
    800026d0:	1101                	addi	sp,sp,-32
    800026d2:	ec06                	sd	ra,24(sp)
    800026d4:	e822                	sd	s0,16(sp)
    800026d6:	e426                	sd	s1,8(sp)
    800026d8:	1000                	addi	s0,sp,32
    800026da:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800026dc:	9f2ff0ef          	jal	800018ce <myproc>
  if(res_id < 0 || res_id >= NRES)
    800026e0:	0004871b          	sext.w	a4,s1
    800026e4:	47bd                	li	a5,15
    800026e6:	00e7f763          	bgeu	a5,a4,800026f4 <res_wait+0x24>
    return;
  acquire(&p->lock);
  p->waiting_res = res_id;
  release(&p->lock);
}
    800026ea:	60e2                	ld	ra,24(sp)
    800026ec:	6442                	ld	s0,16(sp)
    800026ee:	64a2                	ld	s1,8(sp)
    800026f0:	6105                	addi	sp,sp,32
    800026f2:	8082                	ret
    800026f4:	e04a                	sd	s2,0(sp)
    800026f6:	892a                	mv	s2,a0
  acquire(&p->lock);
    800026f8:	cd6fe0ef          	jal	80000bce <acquire>
  p->waiting_res = res_id;
    800026fc:	1c992e23          	sw	s1,476(s2)
  release(&p->lock);
    80002700:	854a                	mv	a0,s2
    80002702:	d64fe0ef          	jal	80000c66 <release>
    80002706:	6902                	ld	s2,0(sp)
    80002708:	b7cd                	j	800026ea <res_wait+0x1a>

000000008000270a <check_deadlock>:

// 0  = no deadlock found
// pid of killed victim = deadlock was found and resolved
int
check_deadlock(void)
{
    8000270a:	bc010113          	addi	sp,sp,-1088
    8000270e:	42113c23          	sd	ra,1080(sp)
    80002712:	42813823          	sd	s0,1072(sp)
    80002716:	42913423          	sd	s1,1064(sp)
    8000271a:	44010413          	addi	s0,sp,1088
  struct proc *deadlocked[NPROC];
  int num_deadlocked = 0;

  // For each process that is waiting for a resource, follow the wait-for chain.
  // If we revisit a process, we've found a cycle = deadlock.
  for(p = proc; p < &proc[NPROC]; p++){
    8000271e:	00011817          	auipc	a6,0x11
    80002722:	58a80813          	addi	a6,a6,1418 # 80013ca8 <proc>
    if(p->state == UNUSED || p->waiting_res < 0)
      continue;

    // Follow the chain: p waits for res -> who holds res? -> does that proc wait for something?
    struct proc *visited[NPROC];
    int nvisited = 0;
    80002726:	4881                	li	a7,0
  for(p = proc; p < &proc[NPROC]; p++){
    80002728:	00019e17          	auipc	t3,0x19
    8000272c:	d80e0e13          	addi	t3,t3,-640 # 8001b4a8 <tickslock>
    80002730:	a851                	j	800027c4 <check_deadlock+0xba>
      // Check if we've already visited this process (cycle detected)
      for(int i = 0; i < nvisited; i++){
        if(visited[i] == cur){
          // DEADLOCK DETECTED — collect all processes in the cycle
          num_deadlocked = 0;
          for(int j = i; j < nvisited; j++){
    80002732:	12b75663          	bge	a4,a1,8000285e <check_deadlock+0x154>
    80002736:	43213023          	sd	s2,1056(sp)
    8000273a:	41313c23          	sd	s3,1048(sp)
    8000273e:	00371793          	slli	a5,a4,0x3
    80002742:	bc040693          	addi	a3,s0,-1088
    80002746:	96be                	add	a3,a3,a5
    80002748:	dc040913          	addi	s2,s0,-576
    8000274c:	0005899b          	sext.w	s3,a1
    80002750:	0007051b          	sext.w	a0,a4
    80002754:	9d99                	subw	a1,a1,a4
    80002756:	02059793          	slli	a5,a1,0x20
    8000275a:	01d7d613          	srli	a2,a5,0x1d
    8000275e:	964a                	add	a2,a2,s2
    80002760:	87ca                	mv	a5,s2
            deadlocked[num_deadlocked++] = visited[j];
    80002762:	6298                	ld	a4,0(a3)
    80002764:	e398                	sd	a4,0(a5)
          for(int j = i; j < nvisited; j++){
    80002766:	06a1                	addi	a3,a3,8
    80002768:	07a1                	addi	a5,a5,8
    8000276a:	fec79ce3          	bne	a5,a2,80002762 <check_deadlock+0x58>
    8000276e:	0005849b          	sext.w	s1,a1

  // No deadlock found
  return 0;

found_deadlock:
  if(num_deadlocked == 0)
    80002772:	c09d                	beqz	s1,80002798 <check_deadlock+0x8e>
    80002774:	41413823          	sd	s4,1040(sp)
    80002778:	39fd                	addiw	s3,s3,-1
    8000277a:	40a989bb          	subw	s3,s3,a0
    return 0;

  // Among all deadlocked processes, pick the one with the HIGHEST energy_consumed.
  // killing the most energy-hungry process first reduces overall system
  // energy waste and breaks the deadlock in the most sustainable way.
  struct proc *victim = deadlocked[0];
    8000277e:	dc043a03          	ld	s4,-576(s0)
  uint64 max_energy = deadlocked[0]->energy_consumed;
    80002782:	178a3583          	ld	a1,376(s4)

  for(int i = 1; i < num_deadlocked; i++){
    80002786:	4785                	li	a5,1
    80002788:	0a97db63          	bge	a5,s1,8000283e <check_deadlock+0x134>
    8000278c:	41513423          	sd	s5,1032(sp)
    80002790:	dc840713          	addi	a4,s0,-568
    80002794:	4781                	li	a5,0
    80002796:	a861                	j	8000282e <check_deadlock+0x124>
    80002798:	42013903          	ld	s2,1056(sp)
    8000279c:	41813983          	ld	s3,1048(sp)
    800027a0:	aab9                	j	800028fe <check_deadlock+0x1f4>
  for(p = proc; p < &proc[NPROC]; p++){
    800027a2:	1e078793          	addi	a5,a5,480
    800027a6:	00d78b63          	beq	a5,a3,800027bc <check_deadlock+0xb2>
    if(p->state != UNUSED && p->holding_res[res_id])
    800027aa:	4f98                	lw	a4,24(a5)
    800027ac:	db7d                	beqz	a4,800027a2 <check_deadlock+0x98>
    800027ae:	00c78733          	add	a4,a5,a2
    800027b2:	19c72703          	lw	a4,412(a4)
    800027b6:	d775                	beqz	a4,800027a2 <check_deadlock+0x98>
    while(cur != 0 && cur->waiting_res >= 0){
    800027b8:	0321                	addi	t1,t1,8
    800027ba:	a005                	j	800027da <check_deadlock+0xd0>
  for(p = proc; p < &proc[NPROC]; p++){
    800027bc:	1e080813          	addi	a6,a6,480
    800027c0:	05c80f63          	beq	a6,t3,8000281e <check_deadlock+0x114>
    if(p->state == UNUSED || p->waiting_res < 0)
    800027c4:	01882783          	lw	a5,24(a6)
    800027c8:	dbf5                	beqz	a5,800027bc <check_deadlock+0xb2>
    800027ca:	1dc82783          	lw	a5,476(a6)
    800027ce:	fe07c7e3          	bltz	a5,800027bc <check_deadlock+0xb2>
    800027d2:	bc040313          	addi	t1,s0,-1088
    struct proc *cur = p;
    800027d6:	87c2                	mv	a5,a6
    int nvisited = 0;
    800027d8:	85c6                	mv	a1,a7
    while(cur != 0 && cur->waiting_res >= 0){
    800027da:	1dc7a503          	lw	a0,476(a5)
    800027de:	fc054fe3          	bltz	a0,800027bc <check_deadlock+0xb2>
      for(int i = 0; i < nvisited; i++){
    800027e2:	bc040693          	addi	a3,s0,-1088
    800027e6:	8746                	mv	a4,a7
    800027e8:	00b05d63          	blez	a1,80002802 <check_deadlock+0xf8>
        if(visited[i] == cur){
    800027ec:	6290                	ld	a2,0(a3)
    800027ee:	f4f602e3          	beq	a2,a5,80002732 <check_deadlock+0x28>
      for(int i = 0; i < nvisited; i++){
    800027f2:	2705                	addiw	a4,a4,1
    800027f4:	06a1                	addi	a3,a3,8
    800027f6:	feb71be3          	bne	a4,a1,800027ec <check_deadlock+0xe2>
      if(nvisited >= NPROC)
    800027fa:	03f00713          	li	a4,63
    800027fe:	fab74fe3          	blt	a4,a1,800027bc <check_deadlock+0xb2>
      visited[nvisited++] = cur;
    80002802:	2585                	addiw	a1,a1,1
    80002804:	00f33023          	sd	a5,0(t1)
  for(p = proc; p < &proc[NPROC]; p++){
    80002808:	00251613          	slli	a2,a0,0x2
    8000280c:	00011797          	auipc	a5,0x11
    80002810:	49c78793          	addi	a5,a5,1180 # 80013ca8 <proc>
    80002814:	00019697          	auipc	a3,0x19
    80002818:	c9468693          	addi	a3,a3,-876 # 8001b4a8 <tickslock>
    8000281c:	b779                	j	800027aa <check_deadlock+0xa0>
  return 0;
    8000281e:	4481                	li	s1,0
    80002820:	a8f9                	j	800028fe <check_deadlock+0x1f4>
  for(int i = 1; i < num_deadlocked; i++){
    80002822:	0785                	addi	a5,a5,1
    80002824:	0721                	addi	a4,a4,8
    80002826:	0007869b          	sext.w	a3,a5
    8000282a:	0336dc63          	bge	a3,s3,80002862 <check_deadlock+0x158>
    if(deadlocked[i]->energy_consumed > max_energy){
    8000282e:	6314                	ld	a3,0(a4)
    80002830:	1786b603          	ld	a2,376(a3)
    80002834:	fec5f7e3          	bgeu	a1,a2,80002822 <check_deadlock+0x118>
      max_energy = deadlocked[i]->energy_consumed;
    80002838:	85b2                	mv	a1,a2
      victim = deadlocked[i];
    8000283a:	8a36                	mv	s4,a3
    8000283c:	b7dd                	j	80002822 <check_deadlock+0x118>
    }
  }

  // Print deadlock info
  printf("DEADLOCK DETECTED! %d processes in cycle:\n", num_deadlocked);
    8000283e:	85a6                	mv	a1,s1
    80002840:	00006517          	auipc	a0,0x6
    80002844:	a9850513          	addi	a0,a0,-1384 # 800082d8 <etext+0x2d8>
    80002848:	cb3fd0ef          	jal	800004fa <printf>
  for(int i = 0; i < num_deadlocked; i++){
    8000284c:	04905a63          	blez	s1,800028a0 <check_deadlock+0x196>
    80002850:	41513423          	sd	s5,1032(sp)
    80002854:	a831                	j	80002870 <check_deadlock+0x166>
  for(int i = 0; i < NRES; i++)
    victim->holding_res[i] = 0;
  victim->waiting_res = -1;
  victim->killed = 1;
  if(victim->state == SLEEPING)
    victim->state = RUNNABLE;
    80002856:	478d                	li	a5,3
    80002858:	00fa2c23          	sw	a5,24(s4)
    8000285c:	a071                	j	800028e8 <check_deadlock+0x1de>
    return 0;
    8000285e:	4481                	li	s1,0
    80002860:	a879                	j	800028fe <check_deadlock+0x1f4>
  printf("DEADLOCK DETECTED! %d processes in cycle:\n", num_deadlocked);
    80002862:	85a6                	mv	a1,s1
    80002864:	00006517          	auipc	a0,0x6
    80002868:	a7450513          	addi	a0,a0,-1420 # 800082d8 <etext+0x2d8>
    8000286c:	c8ffd0ef          	jal	800004fa <printf>
  for(int i = 0; i < num_deadlocked; i++){
    80002870:	4481                	li	s1,0
    printf("  pid=%d name=%s energy_consumed=%ld waiting_res=%d\n",
    80002872:	00006a97          	auipc	s5,0x6
    80002876:	a96a8a93          	addi	s5,s5,-1386 # 80008308 <etext+0x308>
           deadlocked[i]->pid,
    8000287a:	00093783          	ld	a5,0(s2)
    printf("  pid=%d name=%s energy_consumed=%ld waiting_res=%d\n",
    8000287e:	1dc7a703          	lw	a4,476(a5)
    80002882:	1787b683          	ld	a3,376(a5)
    80002886:	15878613          	addi	a2,a5,344
    8000288a:	5b8c                	lw	a1,48(a5)
    8000288c:	8556                	mv	a0,s5
    8000288e:	c6dfd0ef          	jal	800004fa <printf>
  for(int i = 0; i < num_deadlocked; i++){
    80002892:	87a6                	mv	a5,s1
    80002894:	2485                	addiw	s1,s1,1
    80002896:	0921                	addi	s2,s2,8
    80002898:	ff37c1e3          	blt	a5,s3,8000287a <check_deadlock+0x170>
    8000289c:	40813a83          	ld	s5,1032(sp)
  printf("ENERGY-AWARE RECOVERY: Killing pid=%d (name=%s, energy=%ld) — highest energy consumer\n",
    800028a0:	178a3683          	ld	a3,376(s4)
    800028a4:	158a0613          	addi	a2,s4,344
    800028a8:	030a2583          	lw	a1,48(s4)
    800028ac:	00006517          	auipc	a0,0x6
    800028b0:	a9450513          	addi	a0,a0,-1388 # 80008340 <etext+0x340>
    800028b4:	c47fd0ef          	jal	800004fa <printf>
  acquire(&victim->lock);
    800028b8:	84d2                	mv	s1,s4
    800028ba:	8552                	mv	a0,s4
    800028bc:	b12fe0ef          	jal	80000bce <acquire>
  for(int i = 0; i < NRES; i++)
    800028c0:	19ca0793          	addi	a5,s4,412
    800028c4:	1dca0713          	addi	a4,s4,476
    victim->holding_res[i] = 0;
    800028c8:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < NRES; i++)
    800028cc:	0791                	addi	a5,a5,4
    800028ce:	fee79de3          	bne	a5,a4,800028c8 <check_deadlock+0x1be>
  victim->waiting_res = -1;
    800028d2:	57fd                	li	a5,-1
    800028d4:	1cfa2e23          	sw	a5,476(s4)
  victim->killed = 1;
    800028d8:	4785                	li	a5,1
    800028da:	02fa2423          	sw	a5,40(s4)
  if(victim->state == SLEEPING)
    800028de:	018a2703          	lw	a4,24(s4)
    800028e2:	4789                	li	a5,2
    800028e4:	f6f709e3          	beq	a4,a5,80002856 <check_deadlock+0x14c>
  release(&victim->lock);
    800028e8:	8526                	mv	a0,s1
    800028ea:	b7cfe0ef          	jal	80000c66 <release>

  return victim->pid;
    800028ee:	030a2483          	lw	s1,48(s4)
    800028f2:	42013903          	ld	s2,1056(sp)
    800028f6:	41813983          	ld	s3,1048(sp)
    800028fa:	41013a03          	ld	s4,1040(sp)
}
    800028fe:	8526                	mv	a0,s1
    80002900:	43813083          	ld	ra,1080(sp)
    80002904:	43013403          	ld	s0,1072(sp)
    80002908:	42813483          	ld	s1,1064(sp)
    8000290c:	44010113          	addi	sp,sp,1088
    80002910:	8082                	ret

0000000080002912 <deadlock_recover>:

// called periodically from the timer interrupt handler.
// runs the deadlock detection algorithm and recovers if needed.
void
deadlock_recover(void)
{
    80002912:	1141                	addi	sp,sp,-16
    80002914:	e406                	sd	ra,8(sp)
    80002916:	e022                	sd	s0,0(sp)
    80002918:	0800                	addi	s0,sp,16
  check_deadlock();
    8000291a:	df1ff0ef          	jal	8000270a <check_deadlock>
}
    8000291e:	60a2                	ld	ra,8(sp)
    80002920:	6402                	ld	s0,0(sp)
    80002922:	0141                	addi	sp,sp,16
    80002924:	8082                	ret

0000000080002926 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002926:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000292a:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000292e:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002930:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002932:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80002936:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8000293a:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000293e:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002942:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002946:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000294a:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000294e:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002952:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002956:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000295a:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000295e:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002962:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002964:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002966:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000296a:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000296e:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002972:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002976:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000297a:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000297e:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002982:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002986:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000298a:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000298e:	8082                	ret

0000000080002990 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002990:	1141                	addi	sp,sp,-16
    80002992:	e406                	sd	ra,8(sp)
    80002994:	e022                	sd	s0,0(sp)
    80002996:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002998:	00006597          	auipc	a1,0x6
    8000299c:	a7858593          	addi	a1,a1,-1416 # 80008410 <etext+0x410>
    800029a0:	00019517          	auipc	a0,0x19
    800029a4:	b0850513          	addi	a0,a0,-1272 # 8001b4a8 <tickslock>
    800029a8:	9a6fe0ef          	jal	80000b4e <initlock>
}
    800029ac:	60a2                	ld	ra,8(sp)
    800029ae:	6402                	ld	s0,0(sp)
    800029b0:	0141                	addi	sp,sp,16
    800029b2:	8082                	ret

00000000800029b4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800029b4:	1141                	addi	sp,sp,-16
    800029b6:	e422                	sd	s0,8(sp)
    800029b8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029ba:	00003797          	auipc	a5,0x3
    800029be:	38678793          	addi	a5,a5,902 # 80005d40 <kernelvec>
    800029c2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800029c6:	6422                	ld	s0,8(sp)
    800029c8:	0141                	addi	sp,sp,16
    800029ca:	8082                	ret

00000000800029cc <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800029cc:	1141                	addi	sp,sp,-16
    800029ce:	e406                	sd	ra,8(sp)
    800029d0:	e022                	sd	s0,0(sp)
    800029d2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800029d4:	efbfe0ef          	jal	800018ce <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800029dc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029de:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800029e2:	04000737          	lui	a4,0x4000
    800029e6:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800029e8:	0732                	slli	a4,a4,0xc
    800029ea:	00004797          	auipc	a5,0x4
    800029ee:	61678793          	addi	a5,a5,1558 # 80007000 <_trampoline>
    800029f2:	00004697          	auipc	a3,0x4
    800029f6:	60e68693          	addi	a3,a3,1550 # 80007000 <_trampoline>
    800029fa:	8f95                	sub	a5,a5,a3
    800029fc:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029fe:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a02:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a04:	18002773          	csrr	a4,satp
    80002a08:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a0a:	6d38                	ld	a4,88(a0)
    80002a0c:	613c                	ld	a5,64(a0)
    80002a0e:	6685                	lui	a3,0x1
    80002a10:	97b6                	add	a5,a5,a3
    80002a12:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002a14:	6d3c                	ld	a5,88(a0)
    80002a16:	00000717          	auipc	a4,0x0
    80002a1a:	12c70713          	addi	a4,a4,300 # 80002b42 <usertrap>
    80002a1e:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002a20:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002a22:	8712                	mv	a4,tp
    80002a24:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a26:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002a2a:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002a2e:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a32:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002a36:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a38:	6f9c                	ld	a5,24(a5)
    80002a3a:	14179073          	csrw	sepc,a5
}
    80002a3e:	60a2                	ld	ra,8(sp)
    80002a40:	6402                	ld	s0,0(sp)
    80002a42:	0141                	addi	sp,sp,16
    80002a44:	8082                	ret

0000000080002a46 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	e426                	sd	s1,8(sp)
    80002a4e:	1000                	addi	s0,sp,32
  struct proc *p;
  
  if(cpuid() == 0){
    80002a50:	e53fe0ef          	jal	800018a2 <cpuid>
    80002a54:	c929                	beqz	a0,80002aa6 <clockintr+0x60>
    wakeup(&ticks);
    release(&tickslock);
  }

  // Track energy consumption for the currently running process
  p = myproc();
    80002a56:	e79fe0ef          	jal	800018ce <myproc>
    80002a5a:	84aa                	mv	s1,a0
  if(p != 0){
    80002a5c:	c51d                	beqz	a0,80002a8a <clockintr+0x44>
    acquire(&p->lock);
    80002a5e:	970fe0ef          	jal	80000bce <acquire>
    p->energy_consumed += ENERGY_PER_TICK;
    80002a62:	1784b783          	ld	a5,376(s1)
    80002a66:	0785                	addi	a5,a5,1
    80002a68:	16f4bc23          	sd	a5,376(s1)
    
    // Deplete energy budget
    if(p->energy_budget >= ENERGY_PER_TICK){
    80002a6c:	1704b783          	ld	a5,368(s1)
      p->energy_budget -= ENERGY_PER_TICK;
    80002a70:	00f03733          	snez	a4,a5
    80002a74:	8f99                	sub	a5,a5,a4
    80002a76:	16f4b823          	sd	a5,368(s1)
    } else {
      p->energy_budget = 0;
    }
    
    p->last_scheduled_tick++;
    80002a7a:	1804b783          	ld	a5,384(s1)
    80002a7e:	0785                	addi	a5,a5,1
    80002a80:	18f4b023          	sd	a5,384(s1)
    release(&p->lock);
    80002a84:	8526                	mv	a0,s1
    80002a86:	9e0fe0ef          	jal	80000c66 <release>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002a8a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002a8e:	000f4737          	lui	a4,0xf4
    80002a92:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002a96:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002a98:	14d79073          	csrw	stimecmp,a5
}
    80002a9c:	60e2                	ld	ra,24(sp)
    80002a9e:	6442                	ld	s0,16(sp)
    80002aa0:	64a2                	ld	s1,8(sp)
    80002aa2:	6105                	addi	sp,sp,32
    80002aa4:	8082                	ret
    acquire(&tickslock);
    80002aa6:	00019497          	auipc	s1,0x19
    80002aaa:	a0248493          	addi	s1,s1,-1534 # 8001b4a8 <tickslock>
    80002aae:	8526                	mv	a0,s1
    80002ab0:	91efe0ef          	jal	80000bce <acquire>
    ticks++;
    80002ab4:	00009517          	auipc	a0,0x9
    80002ab8:	cc450513          	addi	a0,a0,-828 # 8000b778 <ticks>
    80002abc:	411c                	lw	a5,0(a0)
    80002abe:	2785                	addiw	a5,a5,1
    80002ac0:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002ac2:	ddaff0ef          	jal	8000209c <wakeup>
    release(&tickslock);
    80002ac6:	8526                	mv	a0,s1
    80002ac8:	99efe0ef          	jal	80000c66 <release>
    80002acc:	b769                	j	80002a56 <clockintr+0x10>

0000000080002ace <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002ace:	1101                	addi	sp,sp,-32
    80002ad0:	ec06                	sd	ra,24(sp)
    80002ad2:	e822                	sd	s0,16(sp)
    80002ad4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ad6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002ada:	57fd                	li	a5,-1
    80002adc:	17fe                	slli	a5,a5,0x3f
    80002ade:	07a5                	addi	a5,a5,9
    80002ae0:	00f70c63          	beq	a4,a5,80002af8 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002ae4:	57fd                	li	a5,-1
    80002ae6:	17fe                	slli	a5,a5,0x3f
    80002ae8:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002aea:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002aec:	04f70763          	beq	a4,a5,80002b3a <devintr+0x6c>
  }
}
    80002af0:	60e2                	ld	ra,24(sp)
    80002af2:	6442                	ld	s0,16(sp)
    80002af4:	6105                	addi	sp,sp,32
    80002af6:	8082                	ret
    80002af8:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002afa:	2f2030ef          	jal	80005dec <plic_claim>
    80002afe:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002b00:	47a9                	li	a5,10
    80002b02:	00f50963          	beq	a0,a5,80002b14 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002b06:	4785                	li	a5,1
    80002b08:	00f50963          	beq	a0,a5,80002b1a <devintr+0x4c>
    return 1;
    80002b0c:	4505                	li	a0,1
    } else if(irq){
    80002b0e:	e889                	bnez	s1,80002b20 <devintr+0x52>
    80002b10:	64a2                	ld	s1,8(sp)
    80002b12:	bff9                	j	80002af0 <devintr+0x22>
      uartintr();
    80002b14:	e9dfd0ef          	jal	800009b0 <uartintr>
    if(irq)
    80002b18:	a819                	j	80002b2e <devintr+0x60>
      virtio_disk_intr();
    80002b1a:	798030ef          	jal	800062b2 <virtio_disk_intr>
    if(irq)
    80002b1e:	a801                	j	80002b2e <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002b20:	85a6                	mv	a1,s1
    80002b22:	00006517          	auipc	a0,0x6
    80002b26:	8f650513          	addi	a0,a0,-1802 # 80008418 <etext+0x418>
    80002b2a:	9d1fd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    80002b2e:	8526                	mv	a0,s1
    80002b30:	2dc030ef          	jal	80005e0c <plic_complete>
    return 1;
    80002b34:	4505                	li	a0,1
    80002b36:	64a2                	ld	s1,8(sp)
    80002b38:	bf65                	j	80002af0 <devintr+0x22>
    clockintr();
    80002b3a:	f0dff0ef          	jal	80002a46 <clockintr>
    return 2;
    80002b3e:	4509                	li	a0,2
    80002b40:	bf45                	j	80002af0 <devintr+0x22>

0000000080002b42 <usertrap>:
{
    80002b42:	7179                	addi	sp,sp,-48
    80002b44:	f406                	sd	ra,40(sp)
    80002b46:	f022                	sd	s0,32(sp)
    80002b48:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b4a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002b4e:	1007f793          	andi	a5,a5,256
    80002b52:	ebb5                	bnez	a5,80002bc6 <usertrap+0x84>
    80002b54:	ec26                	sd	s1,24(sp)
    80002b56:	e84a                	sd	s2,16(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b58:	00003797          	auipc	a5,0x3
    80002b5c:	1e878793          	addi	a5,a5,488 # 80005d40 <kernelvec>
    80002b60:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002b64:	d6bfe0ef          	jal	800018ce <myproc>
    80002b68:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002b6a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b6c:	14102773          	csrr	a4,sepc
    80002b70:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b72:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002b76:	47a1                	li	a5,8
    80002b78:	06f70063          	beq	a4,a5,80002bd8 <usertrap+0x96>
  } else if((which_dev = devintr()) != 0){
    80002b7c:	f53ff0ef          	jal	80002ace <devintr>
    80002b80:	892a                	mv	s2,a0
    80002b82:	e95d                	bnez	a0,80002c38 <usertrap+0xf6>
    80002b84:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002b88:	47bd                	li	a5,15
    80002b8a:	08f70b63          	beq	a4,a5,80002c20 <usertrap+0xde>
    80002b8e:	14202773          	csrr	a4,scause
    80002b92:	47b5                	li	a5,13
    80002b94:	08f70663          	beq	a4,a5,80002c20 <usertrap+0xde>
    80002b98:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002b9c:	5890                	lw	a2,48(s1)
    80002b9e:	00006517          	auipc	a0,0x6
    80002ba2:	8ba50513          	addi	a0,a0,-1862 # 80008458 <etext+0x458>
    80002ba6:	955fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002baa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002bae:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002bb2:	00006517          	auipc	a0,0x6
    80002bb6:	8d650513          	addi	a0,a0,-1834 # 80008488 <etext+0x488>
    80002bba:	941fd0ef          	jal	800004fa <printf>
    setkilled(p);
    80002bbe:	8526                	mv	a0,s1
    80002bc0:	ea4ff0ef          	jal	80002264 <setkilled>
    80002bc4:	a80d                	j	80002bf6 <usertrap+0xb4>
    80002bc6:	ec26                	sd	s1,24(sp)
    80002bc8:	e84a                	sd	s2,16(sp)
    80002bca:	e44e                	sd	s3,8(sp)
    panic("usertrap: not from user mode");
    80002bcc:	00006517          	auipc	a0,0x6
    80002bd0:	86c50513          	addi	a0,a0,-1940 # 80008438 <etext+0x438>
    80002bd4:	c0dfd0ef          	jal	800007e0 <panic>
    if(killed(p))
    80002bd8:	eb0ff0ef          	jal	80002288 <killed>
    80002bdc:	ed15                	bnez	a0,80002c18 <usertrap+0xd6>
    p->trapframe->epc += 4;
    80002bde:	6cb8                	ld	a4,88(s1)
    80002be0:	6f1c                	ld	a5,24(a4)
    80002be2:	0791                	addi	a5,a5,4
    80002be4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002be6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002bea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bee:	10079073          	csrw	sstatus,a5
    syscall();
    80002bf2:	29a000ef          	jal	80002e8c <syscall>
  if(killed(p))
    80002bf6:	8526                	mv	a0,s1
    80002bf8:	e90ff0ef          	jal	80002288 <killed>
    80002bfc:	e139                	bnez	a0,80002c42 <usertrap+0x100>
  prepare_return();
    80002bfe:	dcfff0ef          	jal	800029cc <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002c02:	68a8                	ld	a0,80(s1)
    80002c04:	8131                	srli	a0,a0,0xc
    80002c06:	57fd                	li	a5,-1
    80002c08:	17fe                	slli	a5,a5,0x3f
    80002c0a:	8d5d                	or	a0,a0,a5
}
    80002c0c:	64e2                	ld	s1,24(sp)
    80002c0e:	6942                	ld	s2,16(sp)
    80002c10:	70a2                	ld	ra,40(sp)
    80002c12:	7402                	ld	s0,32(sp)
    80002c14:	6145                	addi	sp,sp,48
    80002c16:	8082                	ret
      kexit(-1);
    80002c18:	557d                	li	a0,-1
    80002c1a:	d42ff0ef          	jal	8000215c <kexit>
    80002c1e:	b7c1                	j	80002bde <usertrap+0x9c>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c20:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c24:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002c28:	164d                	addi	a2,a2,-13
    80002c2a:	00163613          	seqz	a2,a2
    80002c2e:	68a8                	ld	a0,80(s1)
    80002c30:	931fe0ef          	jal	80001560 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002c34:	f169                	bnez	a0,80002bf6 <usertrap+0xb4>
    80002c36:	b78d                	j	80002b98 <usertrap+0x56>
  if(killed(p))
    80002c38:	8526                	mv	a0,s1
    80002c3a:	e4eff0ef          	jal	80002288 <killed>
    80002c3e:	c511                	beqz	a0,80002c4a <usertrap+0x108>
    80002c40:	a011                	j	80002c44 <usertrap+0x102>
    80002c42:	4901                	li	s2,0
    kexit(-1);
    80002c44:	557d                	li	a0,-1
    80002c46:	d16ff0ef          	jal	8000215c <kexit>
  if(which_dev == 2){
    80002c4a:	4789                	li	a5,2
    80002c4c:	faf919e3          	bne	s2,a5,80002bfe <usertrap+0xbc>
    80002c50:	e44e                	sd	s3,8(sp)
    p->energy_consumed += ENERGY_PER_TICK;
    80002c52:	1784b783          	ld	a5,376(s1)
    80002c56:	0785                	addi	a5,a5,1
    80002c58:	16f4bc23          	sd	a5,376(s1)
    if(p->energy_budget > 0)
    80002c5c:	1704b783          	ld	a5,368(s1)
    80002c60:	c781                	beqz	a5,80002c68 <usertrap+0x126>
      p->energy_budget -= ENERGY_PER_TICK;
    80002c62:	17fd                	addi	a5,a5,-1
    80002c64:	16f4b823          	sd	a5,368(s1)
    p->last_scheduled_tick++;
    80002c68:	1804b783          	ld	a5,384(s1)
    80002c6c:	0785                	addi	a5,a5,1
    80002c6e:	18f4b023          	sd	a5,384(s1)
    acquire(&tickslock);
    80002c72:	00019997          	auipc	s3,0x19
    80002c76:	83698993          	addi	s3,s3,-1994 # 8001b4a8 <tickslock>
    80002c7a:	854e                	mv	a0,s3
    80002c7c:	f53fd0ef          	jal	80000bce <acquire>
    uint current_ticks = ticks;
    80002c80:	00009917          	auipc	s2,0x9
    80002c84:	af892903          	lw	s2,-1288(s2) # 8000b778 <ticks>
    release(&tickslock);
    80002c88:	854e                	mv	a0,s3
    80002c8a:	fddfd0ef          	jal	80000c66 <release>
    if(current_ticks % DEADLOCK_CHECK_INTERVAL == 0){
    80002c8e:	06400793          	li	a5,100
    80002c92:	02f9793b          	remuw	s2,s2,a5
    80002c96:	2901                	sext.w	s2,s2
    80002c98:	00090663          	beqz	s2,80002ca4 <usertrap+0x162>
    yield();
    80002c9c:	b88ff0ef          	jal	80002024 <yield>
    80002ca0:	69a2                	ld	s3,8(sp)
    80002ca2:	bfb1                	j	80002bfe <usertrap+0xbc>
      deadlock_recover();
    80002ca4:	c6fff0ef          	jal	80002912 <deadlock_recover>
    80002ca8:	bfd5                	j	80002c9c <usertrap+0x15a>

0000000080002caa <kerneltrap>:
{
    80002caa:	7179                	addi	sp,sp,-48
    80002cac:	f406                	sd	ra,40(sp)
    80002cae:	f022                	sd	s0,32(sp)
    80002cb0:	ec26                	sd	s1,24(sp)
    80002cb2:	e84a                	sd	s2,16(sp)
    80002cb4:	e44e                	sd	s3,8(sp)
    80002cb6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cb8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cbc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cc0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002cc4:	1004f793          	andi	a5,s1,256
    80002cc8:	c795                	beqz	a5,80002cf4 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002cce:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002cd0:	eb85                	bnez	a5,80002d00 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002cd2:	dfdff0ef          	jal	80002ace <devintr>
    80002cd6:	c91d                	beqz	a0,80002d0c <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002cd8:	4789                	li	a5,2
    80002cda:	04f50a63          	beq	a0,a5,80002d2e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cde:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ce2:	10049073          	csrw	sstatus,s1
}
    80002ce6:	70a2                	ld	ra,40(sp)
    80002ce8:	7402                	ld	s0,32(sp)
    80002cea:	64e2                	ld	s1,24(sp)
    80002cec:	6942                	ld	s2,16(sp)
    80002cee:	69a2                	ld	s3,8(sp)
    80002cf0:	6145                	addi	sp,sp,48
    80002cf2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002cf4:	00005517          	auipc	a0,0x5
    80002cf8:	7bc50513          	addi	a0,a0,1980 # 800084b0 <etext+0x4b0>
    80002cfc:	ae5fd0ef          	jal	800007e0 <panic>
    panic("kerneltrap: interrupts enabled");
    80002d00:	00005517          	auipc	a0,0x5
    80002d04:	7d850513          	addi	a0,a0,2008 # 800084d8 <etext+0x4d8>
    80002d08:	ad9fd0ef          	jal	800007e0 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d0c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d10:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002d14:	85ce                	mv	a1,s3
    80002d16:	00005517          	auipc	a0,0x5
    80002d1a:	7e250513          	addi	a0,a0,2018 # 800084f8 <etext+0x4f8>
    80002d1e:	fdcfd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80002d22:	00005517          	auipc	a0,0x5
    80002d26:	7fe50513          	addi	a0,a0,2046 # 80008520 <etext+0x520>
    80002d2a:	ab7fd0ef          	jal	800007e0 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002d2e:	ba1fe0ef          	jal	800018ce <myproc>
    80002d32:	d555                	beqz	a0,80002cde <kerneltrap+0x34>
    yield();
    80002d34:	af0ff0ef          	jal	80002024 <yield>
    80002d38:	b75d                	j	80002cde <kerneltrap+0x34>

0000000080002d3a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d3a:	1101                	addi	sp,sp,-32
    80002d3c:	ec06                	sd	ra,24(sp)
    80002d3e:	e822                	sd	s0,16(sp)
    80002d40:	e426                	sd	s1,8(sp)
    80002d42:	1000                	addi	s0,sp,32
    80002d44:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002d46:	b89fe0ef          	jal	800018ce <myproc>
  switch (n) {
    80002d4a:	4795                	li	a5,5
    80002d4c:	0497e163          	bltu	a5,s1,80002d8e <argraw+0x54>
    80002d50:	048a                	slli	s1,s1,0x2
    80002d52:	00006717          	auipc	a4,0x6
    80002d56:	c9e70713          	addi	a4,a4,-866 # 800089f0 <states.0+0x60>
    80002d5a:	94ba                	add	s1,s1,a4
    80002d5c:	409c                	lw	a5,0(s1)
    80002d5e:	97ba                	add	a5,a5,a4
    80002d60:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002d62:	6d3c                	ld	a5,88(a0)
    80002d64:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002d66:	60e2                	ld	ra,24(sp)
    80002d68:	6442                	ld	s0,16(sp)
    80002d6a:	64a2                	ld	s1,8(sp)
    80002d6c:	6105                	addi	sp,sp,32
    80002d6e:	8082                	ret
    return p->trapframe->a1;
    80002d70:	6d3c                	ld	a5,88(a0)
    80002d72:	7fa8                	ld	a0,120(a5)
    80002d74:	bfcd                	j	80002d66 <argraw+0x2c>
    return p->trapframe->a2;
    80002d76:	6d3c                	ld	a5,88(a0)
    80002d78:	63c8                	ld	a0,128(a5)
    80002d7a:	b7f5                	j	80002d66 <argraw+0x2c>
    return p->trapframe->a3;
    80002d7c:	6d3c                	ld	a5,88(a0)
    80002d7e:	67c8                	ld	a0,136(a5)
    80002d80:	b7dd                	j	80002d66 <argraw+0x2c>
    return p->trapframe->a4;
    80002d82:	6d3c                	ld	a5,88(a0)
    80002d84:	6bc8                	ld	a0,144(a5)
    80002d86:	b7c5                	j	80002d66 <argraw+0x2c>
    return p->trapframe->a5;
    80002d88:	6d3c                	ld	a5,88(a0)
    80002d8a:	6fc8                	ld	a0,152(a5)
    80002d8c:	bfe9                	j	80002d66 <argraw+0x2c>
  panic("argraw");
    80002d8e:	00005517          	auipc	a0,0x5
    80002d92:	7a250513          	addi	a0,a0,1954 # 80008530 <etext+0x530>
    80002d96:	a4bfd0ef          	jal	800007e0 <panic>

0000000080002d9a <fetchaddr>:
{
    80002d9a:	1101                	addi	sp,sp,-32
    80002d9c:	ec06                	sd	ra,24(sp)
    80002d9e:	e822                	sd	s0,16(sp)
    80002da0:	e426                	sd	s1,8(sp)
    80002da2:	e04a                	sd	s2,0(sp)
    80002da4:	1000                	addi	s0,sp,32
    80002da6:	84aa                	mv	s1,a0
    80002da8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002daa:	b25fe0ef          	jal	800018ce <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002dae:	653c                	ld	a5,72(a0)
    80002db0:	02f4f663          	bgeu	s1,a5,80002ddc <fetchaddr+0x42>
    80002db4:	00848713          	addi	a4,s1,8
    80002db8:	02e7e463          	bltu	a5,a4,80002de0 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002dbc:	46a1                	li	a3,8
    80002dbe:	8626                	mv	a2,s1
    80002dc0:	85ca                	mv	a1,s2
    80002dc2:	6928                	ld	a0,80(a0)
    80002dc4:	903fe0ef          	jal	800016c6 <copyin>
    80002dc8:	00a03533          	snez	a0,a0
    80002dcc:	40a00533          	neg	a0,a0
}
    80002dd0:	60e2                	ld	ra,24(sp)
    80002dd2:	6442                	ld	s0,16(sp)
    80002dd4:	64a2                	ld	s1,8(sp)
    80002dd6:	6902                	ld	s2,0(sp)
    80002dd8:	6105                	addi	sp,sp,32
    80002dda:	8082                	ret
    return -1;
    80002ddc:	557d                	li	a0,-1
    80002dde:	bfcd                	j	80002dd0 <fetchaddr+0x36>
    80002de0:	557d                	li	a0,-1
    80002de2:	b7fd                	j	80002dd0 <fetchaddr+0x36>

0000000080002de4 <fetchstr>:
{
    80002de4:	7179                	addi	sp,sp,-48
    80002de6:	f406                	sd	ra,40(sp)
    80002de8:	f022                	sd	s0,32(sp)
    80002dea:	ec26                	sd	s1,24(sp)
    80002dec:	e84a                	sd	s2,16(sp)
    80002dee:	e44e                	sd	s3,8(sp)
    80002df0:	1800                	addi	s0,sp,48
    80002df2:	892a                	mv	s2,a0
    80002df4:	84ae                	mv	s1,a1
    80002df6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002df8:	ad7fe0ef          	jal	800018ce <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002dfc:	86ce                	mv	a3,s3
    80002dfe:	864a                	mv	a2,s2
    80002e00:	85a6                	mv	a1,s1
    80002e02:	6928                	ld	a0,80(a0)
    80002e04:	e84fe0ef          	jal	80001488 <copyinstr>
    80002e08:	00054c63          	bltz	a0,80002e20 <fetchstr+0x3c>
  return strlen(buf);
    80002e0c:	8526                	mv	a0,s1
    80002e0e:	804fe0ef          	jal	80000e12 <strlen>
}
    80002e12:	70a2                	ld	ra,40(sp)
    80002e14:	7402                	ld	s0,32(sp)
    80002e16:	64e2                	ld	s1,24(sp)
    80002e18:	6942                	ld	s2,16(sp)
    80002e1a:	69a2                	ld	s3,8(sp)
    80002e1c:	6145                	addi	sp,sp,48
    80002e1e:	8082                	ret
    return -1;
    80002e20:	557d                	li	a0,-1
    80002e22:	bfc5                	j	80002e12 <fetchstr+0x2e>

0000000080002e24 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002e24:	1101                	addi	sp,sp,-32
    80002e26:	ec06                	sd	ra,24(sp)
    80002e28:	e822                	sd	s0,16(sp)
    80002e2a:	e426                	sd	s1,8(sp)
    80002e2c:	1000                	addi	s0,sp,32
    80002e2e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e30:	f0bff0ef          	jal	80002d3a <argraw>
    80002e34:	c088                	sw	a0,0(s1)
}
    80002e36:	60e2                	ld	ra,24(sp)
    80002e38:	6442                	ld	s0,16(sp)
    80002e3a:	64a2                	ld	s1,8(sp)
    80002e3c:	6105                	addi	sp,sp,32
    80002e3e:	8082                	ret

0000000080002e40 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002e40:	1101                	addi	sp,sp,-32
    80002e42:	ec06                	sd	ra,24(sp)
    80002e44:	e822                	sd	s0,16(sp)
    80002e46:	e426                	sd	s1,8(sp)
    80002e48:	1000                	addi	s0,sp,32
    80002e4a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e4c:	eefff0ef          	jal	80002d3a <argraw>
    80002e50:	e088                	sd	a0,0(s1)
}
    80002e52:	60e2                	ld	ra,24(sp)
    80002e54:	6442                	ld	s0,16(sp)
    80002e56:	64a2                	ld	s1,8(sp)
    80002e58:	6105                	addi	sp,sp,32
    80002e5a:	8082                	ret

0000000080002e5c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002e5c:	7179                	addi	sp,sp,-48
    80002e5e:	f406                	sd	ra,40(sp)
    80002e60:	f022                	sd	s0,32(sp)
    80002e62:	ec26                	sd	s1,24(sp)
    80002e64:	e84a                	sd	s2,16(sp)
    80002e66:	1800                	addi	s0,sp,48
    80002e68:	84ae                	mv	s1,a1
    80002e6a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002e6c:	fd840593          	addi	a1,s0,-40
    80002e70:	fd1ff0ef          	jal	80002e40 <argaddr>
  return fetchstr(addr, buf, max);
    80002e74:	864a                	mv	a2,s2
    80002e76:	85a6                	mv	a1,s1
    80002e78:	fd843503          	ld	a0,-40(s0)
    80002e7c:	f69ff0ef          	jal	80002de4 <fetchstr>
}
    80002e80:	70a2                	ld	ra,40(sp)
    80002e82:	7402                	ld	s0,32(sp)
    80002e84:	64e2                	ld	s1,24(sp)
    80002e86:	6942                	ld	s2,16(sp)
    80002e88:	6145                	addi	sp,sp,48
    80002e8a:	8082                	ret

0000000080002e8c <syscall>:
[SYS_check_deadlock] sys_check_deadlock
};

void
syscall(void)
{
    80002e8c:	1101                	addi	sp,sp,-32
    80002e8e:	ec06                	sd	ra,24(sp)
    80002e90:	e822                	sd	s0,16(sp)
    80002e92:	e426                	sd	s1,8(sp)
    80002e94:	e04a                	sd	s2,0(sp)
    80002e96:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002e98:	a37fe0ef          	jal	800018ce <myproc>
    80002e9c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002e9e:	05853903          	ld	s2,88(a0)
    80002ea2:	0a893783          	ld	a5,168(s2)
    80002ea6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002eaa:	37fd                	addiw	a5,a5,-1
    80002eac:	4765                	li	a4,25
    80002eae:	00f76f63          	bltu	a4,a5,80002ecc <syscall+0x40>
    80002eb2:	00369713          	slli	a4,a3,0x3
    80002eb6:	00006797          	auipc	a5,0x6
    80002eba:	b5278793          	addi	a5,a5,-1198 # 80008a08 <syscalls>
    80002ebe:	97ba                	add	a5,a5,a4
    80002ec0:	639c                	ld	a5,0(a5)
    80002ec2:	c789                	beqz	a5,80002ecc <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002ec4:	9782                	jalr	a5
    80002ec6:	06a93823          	sd	a0,112(s2)
    80002eca:	a829                	j	80002ee4 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ecc:	15848613          	addi	a2,s1,344
    80002ed0:	588c                	lw	a1,48(s1)
    80002ed2:	00005517          	auipc	a0,0x5
    80002ed6:	66650513          	addi	a0,a0,1638 # 80008538 <etext+0x538>
    80002eda:	e20fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002ede:	6cbc                	ld	a5,88(s1)
    80002ee0:	577d                	li	a4,-1
    80002ee2:	fbb8                	sd	a4,112(a5)
  }
}
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	64a2                	ld	s1,8(sp)
    80002eea:	6902                	ld	s2,0(sp)
    80002eec:	6105                	addi	sp,sp,32
    80002eee:	8082                	ret

0000000080002ef0 <ensure_demo_locks_inited>:
static int demo_locks_inited = 0;

static void
ensure_demo_locks_inited(void)
{
  if(demo_locks_inited)
    80002ef0:	00009797          	auipc	a5,0x9
    80002ef4:	88c7a783          	lw	a5,-1908(a5) # 8000b77c <demo_locks_inited>
    80002ef8:	c391                	beqz	a5,80002efc <ensure_demo_locks_inited+0xc>
    80002efa:	8082                	ret
{
    80002efc:	1141                	addi	sp,sp,-16
    80002efe:	e406                	sd	ra,8(sp)
    80002f00:	e022                	sd	s0,0(sp)
    80002f02:	0800                	addi	s0,sp,16
    return;

  initsleeplock(&demo_locks[0], "demo_lock_0");
    80002f04:	00005597          	auipc	a1,0x5
    80002f08:	65458593          	addi	a1,a1,1620 # 80008558 <etext+0x558>
    80002f0c:	00018517          	auipc	a0,0x18
    80002f10:	5b450513          	addi	a0,a0,1460 # 8001b4c0 <demo_locks>
    80002f14:	720010ef          	jal	80004634 <initsleeplock>
  initsleeplock(&demo_locks[1], "demo_lock_1");
    80002f18:	00005597          	auipc	a1,0x5
    80002f1c:	65058593          	addi	a1,a1,1616 # 80008568 <etext+0x568>
    80002f20:	00018517          	auipc	a0,0x18
    80002f24:	5d050513          	addi	a0,a0,1488 # 8001b4f0 <demo_locks+0x30>
    80002f28:	70c010ef          	jal	80004634 <initsleeplock>
  demo_locks_inited = 1;
    80002f2c:	4785                	li	a5,1
    80002f2e:	00009717          	auipc	a4,0x9
    80002f32:	84f72723          	sw	a5,-1970(a4) # 8000b77c <demo_locks_inited>
}
    80002f36:	60a2                	ld	ra,8(sp)
    80002f38:	6402                	ld	s0,0(sp)
    80002f3a:	0141                	addi	sp,sp,16
    80002f3c:	8082                	ret

0000000080002f3e <sys_kps>:

uint64
sys_kps(void)
{
    80002f3e:	1101                	addi	sp,sp,-32
    80002f40:	ec06                	sd	ra,24(sp)
    80002f42:	e822                	sd	s0,16(sp)
    80002f44:	1000                	addi	s0,sp,32
  int arg_length = 4;
  int first_argument = 0;
  int max_num_copy = 128;
  char kernal_buffer[arg_length];
  if (argstr(first_argument, kernal_buffer, max_num_copy) < 0)
    80002f46:	08000613          	li	a2,128
    80002f4a:	fe840593          	addi	a1,s0,-24
    80002f4e:	4501                	li	a0,0
    80002f50:	f0dff0ef          	jal	80002e5c <argstr>
    80002f54:	87aa                	mv	a5,a0
  {
    // error
    return -1;
    80002f56:	557d                	li	a0,-1
  if (argstr(first_argument, kernal_buffer, max_num_copy) < 0)
    80002f58:	0007c663          	bltz	a5,80002f64 <sys_kps+0x26>
  }
  return kps(kernal_buffer);
    80002f5c:	fe840513          	addi	a0,s0,-24
    80002f60:	d96ff0ef          	jal	800024f6 <kps>

}
    80002f64:	60e2                	ld	ra,24(sp)
    80002f66:	6442                	ld	s0,16(sp)
    80002f68:	6105                	addi	sp,sp,32
    80002f6a:	8082                	ret

0000000080002f6c <sys_exit>:

uint64
sys_exit(void)
{
    80002f6c:	1101                	addi	sp,sp,-32
    80002f6e:	ec06                	sd	ra,24(sp)
    80002f70:	e822                	sd	s0,16(sp)
    80002f72:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002f74:	fec40593          	addi	a1,s0,-20
    80002f78:	4501                	li	a0,0
    80002f7a:	eabff0ef          	jal	80002e24 <argint>
  kexit(n);
    80002f7e:	fec42503          	lw	a0,-20(s0)
    80002f82:	9daff0ef          	jal	8000215c <kexit>
  return 0;  // not reached
}
    80002f86:	4501                	li	a0,0
    80002f88:	60e2                	ld	ra,24(sp)
    80002f8a:	6442                	ld	s0,16(sp)
    80002f8c:	6105                	addi	sp,sp,32
    80002f8e:	8082                	ret

0000000080002f90 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002f90:	1141                	addi	sp,sp,-16
    80002f92:	e406                	sd	ra,8(sp)
    80002f94:	e022                	sd	s0,0(sp)
    80002f96:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002f98:	937fe0ef          	jal	800018ce <myproc>
}
    80002f9c:	5908                	lw	a0,48(a0)
    80002f9e:	60a2                	ld	ra,8(sp)
    80002fa0:	6402                	ld	s0,0(sp)
    80002fa2:	0141                	addi	sp,sp,16
    80002fa4:	8082                	ret

0000000080002fa6 <sys_fork>:

uint64
sys_fork(void)
{
    80002fa6:	1141                	addi	sp,sp,-16
    80002fa8:	e406                	sd	ra,8(sp)
    80002faa:	e022                	sd	s0,0(sp)
    80002fac:	0800                	addi	s0,sp,16
  return kfork();
    80002fae:	cedfe0ef          	jal	80001c9a <kfork>
}
    80002fb2:	60a2                	ld	ra,8(sp)
    80002fb4:	6402                	ld	s0,0(sp)
    80002fb6:	0141                	addi	sp,sp,16
    80002fb8:	8082                	ret

0000000080002fba <sys_wait>:

uint64
sys_wait(void)
{
    80002fba:	1101                	addi	sp,sp,-32
    80002fbc:	ec06                	sd	ra,24(sp)
    80002fbe:	e822                	sd	s0,16(sp)
    80002fc0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002fc2:	fe840593          	addi	a1,s0,-24
    80002fc6:	4501                	li	a0,0
    80002fc8:	e79ff0ef          	jal	80002e40 <argaddr>
  return kwait(p);
    80002fcc:	fe843503          	ld	a0,-24(s0)
    80002fd0:	ae2ff0ef          	jal	800022b2 <kwait>
}
    80002fd4:	60e2                	ld	ra,24(sp)
    80002fd6:	6442                	ld	s0,16(sp)
    80002fd8:	6105                	addi	sp,sp,32
    80002fda:	8082                	ret

0000000080002fdc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002fdc:	7179                	addi	sp,sp,-48
    80002fde:	f406                	sd	ra,40(sp)
    80002fe0:	f022                	sd	s0,32(sp)
    80002fe2:	ec26                	sd	s1,24(sp)
    80002fe4:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002fe6:	fd840593          	addi	a1,s0,-40
    80002fea:	4501                	li	a0,0
    80002fec:	e39ff0ef          	jal	80002e24 <argint>
  argint(1, &t);
    80002ff0:	fdc40593          	addi	a1,s0,-36
    80002ff4:	4505                	li	a0,1
    80002ff6:	e2fff0ef          	jal	80002e24 <argint>
  addr = myproc()->sz;
    80002ffa:	8d5fe0ef          	jal	800018ce <myproc>
    80002ffe:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80003000:	fdc42703          	lw	a4,-36(s0)
    80003004:	4785                	li	a5,1
    80003006:	02f70763          	beq	a4,a5,80003034 <sys_sbrk+0x58>
    8000300a:	fd842783          	lw	a5,-40(s0)
    8000300e:	0207c363          	bltz	a5,80003034 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80003012:	97a6                	add	a5,a5,s1
    80003014:	0297ee63          	bltu	a5,s1,80003050 <sys_sbrk+0x74>
      return -1;
    if(addr + n > TRAPFRAME)
    80003018:	02000737          	lui	a4,0x2000
    8000301c:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    8000301e:	0736                	slli	a4,a4,0xd
    80003020:	02f76a63          	bltu	a4,a5,80003054 <sys_sbrk+0x78>
      return -1;
    myproc()->sz += n;
    80003024:	8abfe0ef          	jal	800018ce <myproc>
    80003028:	fd842703          	lw	a4,-40(s0)
    8000302c:	653c                	ld	a5,72(a0)
    8000302e:	97ba                	add	a5,a5,a4
    80003030:	e53c                	sd	a5,72(a0)
    80003032:	a039                	j	80003040 <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80003034:	fd842503          	lw	a0,-40(s0)
    80003038:	c01fe0ef          	jal	80001c38 <growproc>
    8000303c:	00054863          	bltz	a0,8000304c <sys_sbrk+0x70>
  }
  return addr;
}
    80003040:	8526                	mv	a0,s1
    80003042:	70a2                	ld	ra,40(sp)
    80003044:	7402                	ld	s0,32(sp)
    80003046:	64e2                	ld	s1,24(sp)
    80003048:	6145                	addi	sp,sp,48
    8000304a:	8082                	ret
      return -1;
    8000304c:	54fd                	li	s1,-1
    8000304e:	bfcd                	j	80003040 <sys_sbrk+0x64>
      return -1;
    80003050:	54fd                	li	s1,-1
    80003052:	b7fd                	j	80003040 <sys_sbrk+0x64>
      return -1;
    80003054:	54fd                	li	s1,-1
    80003056:	b7ed                	j	80003040 <sys_sbrk+0x64>

0000000080003058 <sys_pause>:

uint64
sys_pause(void)
{
    80003058:	7139                	addi	sp,sp,-64
    8000305a:	fc06                	sd	ra,56(sp)
    8000305c:	f822                	sd	s0,48(sp)
    8000305e:	f04a                	sd	s2,32(sp)
    80003060:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003062:	fcc40593          	addi	a1,s0,-52
    80003066:	4501                	li	a0,0
    80003068:	dbdff0ef          	jal	80002e24 <argint>
  if(n < 0)
    8000306c:	fcc42783          	lw	a5,-52(s0)
    80003070:	0607c763          	bltz	a5,800030de <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80003074:	00018517          	auipc	a0,0x18
    80003078:	43450513          	addi	a0,a0,1076 # 8001b4a8 <tickslock>
    8000307c:	b53fd0ef          	jal	80000bce <acquire>
  ticks0 = ticks;
    80003080:	00008917          	auipc	s2,0x8
    80003084:	6f892903          	lw	s2,1784(s2) # 8000b778 <ticks>
  while(ticks - ticks0 < n){
    80003088:	fcc42783          	lw	a5,-52(s0)
    8000308c:	cf8d                	beqz	a5,800030c6 <sys_pause+0x6e>
    8000308e:	f426                	sd	s1,40(sp)
    80003090:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003092:	00018997          	auipc	s3,0x18
    80003096:	41698993          	addi	s3,s3,1046 # 8001b4a8 <tickslock>
    8000309a:	00008497          	auipc	s1,0x8
    8000309e:	6de48493          	addi	s1,s1,1758 # 8000b778 <ticks>
    if(killed(myproc())){
    800030a2:	82dfe0ef          	jal	800018ce <myproc>
    800030a6:	9e2ff0ef          	jal	80002288 <killed>
    800030aa:	ed0d                	bnez	a0,800030e4 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    800030ac:	85ce                	mv	a1,s3
    800030ae:	8526                	mv	a0,s1
    800030b0:	fa1fe0ef          	jal	80002050 <sleep>
  while(ticks - ticks0 < n){
    800030b4:	409c                	lw	a5,0(s1)
    800030b6:	412787bb          	subw	a5,a5,s2
    800030ba:	fcc42703          	lw	a4,-52(s0)
    800030be:	fee7e2e3          	bltu	a5,a4,800030a2 <sys_pause+0x4a>
    800030c2:	74a2                	ld	s1,40(sp)
    800030c4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800030c6:	00018517          	auipc	a0,0x18
    800030ca:	3e250513          	addi	a0,a0,994 # 8001b4a8 <tickslock>
    800030ce:	b99fd0ef          	jal	80000c66 <release>
  return 0;
    800030d2:	4501                	li	a0,0
}
    800030d4:	70e2                	ld	ra,56(sp)
    800030d6:	7442                	ld	s0,48(sp)
    800030d8:	7902                	ld	s2,32(sp)
    800030da:	6121                	addi	sp,sp,64
    800030dc:	8082                	ret
    n = 0;
    800030de:	fc042623          	sw	zero,-52(s0)
    800030e2:	bf49                	j	80003074 <sys_pause+0x1c>
      release(&tickslock);
    800030e4:	00018517          	auipc	a0,0x18
    800030e8:	3c450513          	addi	a0,a0,964 # 8001b4a8 <tickslock>
    800030ec:	b7bfd0ef          	jal	80000c66 <release>
      return -1;
    800030f0:	557d                	li	a0,-1
    800030f2:	74a2                	ld	s1,40(sp)
    800030f4:	69e2                	ld	s3,24(sp)
    800030f6:	bff9                	j	800030d4 <sys_pause+0x7c>

00000000800030f8 <sys_kill>:

uint64
sys_kill(void)
{
    800030f8:	1101                	addi	sp,sp,-32
    800030fa:	ec06                	sd	ra,24(sp)
    800030fc:	e822                	sd	s0,16(sp)
    800030fe:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003100:	fec40593          	addi	a1,s0,-20
    80003104:	4501                	li	a0,0
    80003106:	d1fff0ef          	jal	80002e24 <argint>
  return kkill(pid);
    8000310a:	fec42503          	lw	a0,-20(s0)
    8000310e:	8f0ff0ef          	jal	800021fe <kkill>
}
    80003112:	60e2                	ld	ra,24(sp)
    80003114:	6442                	ld	s0,16(sp)
    80003116:	6105                	addi	sp,sp,32
    80003118:	8082                	ret

000000008000311a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000311a:	1101                	addi	sp,sp,-32
    8000311c:	ec06                	sd	ra,24(sp)
    8000311e:	e822                	sd	s0,16(sp)
    80003120:	e426                	sd	s1,8(sp)
    80003122:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003124:	00018517          	auipc	a0,0x18
    80003128:	38450513          	addi	a0,a0,900 # 8001b4a8 <tickslock>
    8000312c:	aa3fd0ef          	jal	80000bce <acquire>
  xticks = ticks;
    80003130:	00008497          	auipc	s1,0x8
    80003134:	6484a483          	lw	s1,1608(s1) # 8000b778 <ticks>
  release(&tickslock);
    80003138:	00018517          	auipc	a0,0x18
    8000313c:	37050513          	addi	a0,a0,880 # 8001b4a8 <tickslock>
    80003140:	b27fd0ef          	jal	80000c66 <release>
  return xticks;
}
    80003144:	02049513          	slli	a0,s1,0x20
    80003148:	9101                	srli	a0,a0,0x20
    8000314a:	60e2                	ld	ra,24(sp)
    8000314c:	6442                	ld	s0,16(sp)
    8000314e:	64a2                	ld	s1,8(sp)
    80003150:	6105                	addi	sp,sp,32
    80003152:	8082                	ret

0000000080003154 <sys_getenergy>:

// Get energy information for the current process
uint64
sys_getenergy(void)
{
    80003154:	7139                	addi	sp,sp,-64
    80003156:	fc06                	sd	ra,56(sp)
    80003158:	f822                	sd	s0,48(sp)
    8000315a:	f426                	sd	s1,40(sp)
    8000315c:	0080                	addi	s0,sp,64
  uint64 addr;
  struct proc *p = myproc();
    8000315e:	f70fe0ef          	jal	800018ce <myproc>
    80003162:	84aa                	mv	s1,a0
  
  argaddr(0, &addr);
    80003164:	fd840593          	addi	a1,s0,-40
    80003168:	4501                	li	a0,0
    8000316a:	cd7ff0ef          	jal	80002e40 <argaddr>
  
  if(addr == 0)
    8000316e:	fd843783          	ld	a5,-40(s0)
    return -1;
    80003172:	557d                	li	a0,-1
  if(addr == 0)
    80003174:	cb9d                	beqz	a5,800031aa <sys_getenergy+0x56>
  
  // Create a temporary buffer to hold the energy info
  // We use a struct that matches the user-space definition
  uint64 energy_data[3];  // energy_budget, energy_consumed, pid
  
  acquire(&p->lock);
    80003176:	8526                	mv	a0,s1
    80003178:	a57fd0ef          	jal	80000bce <acquire>
  energy_data[0] = p->energy_budget;
    8000317c:	1704b783          	ld	a5,368(s1)
    80003180:	fcf43023          	sd	a5,-64(s0)
  energy_data[1] = p->energy_consumed;
    80003184:	1784b783          	ld	a5,376(s1)
    80003188:	fcf43423          	sd	a5,-56(s0)
  energy_data[2] = p->pid;
    8000318c:	589c                	lw	a5,48(s1)
    8000318e:	fcf43823          	sd	a5,-48(s0)
  release(&p->lock);
    80003192:	8526                	mv	a0,s1
    80003194:	ad3fd0ef          	jal	80000c66 <release>
  
  // Copy the energy information to user space
  if(copyout(p->pagetable, addr, (char *)energy_data, sizeof(energy_data)) < 0)
    80003198:	46e1                	li	a3,24
    8000319a:	fc040613          	addi	a2,s0,-64
    8000319e:	fd843583          	ld	a1,-40(s0)
    800031a2:	68a8                	ld	a0,80(s1)
    800031a4:	c3efe0ef          	jal	800015e2 <copyout>
    800031a8:	957d                	srai	a0,a0,0x3f
    return -1;
  
  return 0;
}
    800031aa:	70e2                	ld	ra,56(sp)
    800031ac:	7442                	ld	s0,48(sp)
    800031ae:	74a2                	ld	s1,40(sp)
    800031b0:	6121                	addi	sp,sp,64
    800031b2:	8082                	ret

00000000800031b4 <sys_dlockacq>:

uint64
sys_dlockacq(void)
{
    800031b4:	1101                	addi	sp,sp,-32
    800031b6:	ec06                	sd	ra,24(sp)
    800031b8:	e822                	sd	s0,16(sp)
    800031ba:	1000                	addi	s0,sp,32
  int lockid;

  argint(0, &lockid);
    800031bc:	fec40593          	addi	a1,s0,-20
    800031c0:	4501                	li	a0,0
    800031c2:	c63ff0ef          	jal	80002e24 <argint>
  if(lockid < 0 || lockid > 1)
    800031c6:	fec42703          	lw	a4,-20(s0)
    800031ca:	4785                	li	a5,1
    return -1;
    800031cc:	557d                	li	a0,-1
  if(lockid < 0 || lockid > 1)
    800031ce:	02e7e263          	bltu	a5,a4,800031f2 <sys_dlockacq+0x3e>

  ensure_demo_locks_inited();
    800031d2:	d1fff0ef          	jal	80002ef0 <ensure_demo_locks_inited>
  acquiresleep(&demo_locks[lockid]);
    800031d6:	fec42703          	lw	a4,-20(s0)
    800031da:	00171793          	slli	a5,a4,0x1
    800031de:	97ba                	add	a5,a5,a4
    800031e0:	0792                	slli	a5,a5,0x4
    800031e2:	00018517          	auipc	a0,0x18
    800031e6:	2de50513          	addi	a0,a0,734 # 8001b4c0 <demo_locks>
    800031ea:	953e                	add	a0,a0,a5
    800031ec:	47e010ef          	jal	8000466a <acquiresleep>
  return 0;
    800031f0:	4501                	li	a0,0
}
    800031f2:	60e2                	ld	ra,24(sp)
    800031f4:	6442                	ld	s0,16(sp)
    800031f6:	6105                	addi	sp,sp,32
    800031f8:	8082                	ret

00000000800031fa <sys_dlockrel>:

uint64
sys_dlockrel(void)
{
    800031fa:	1101                	addi	sp,sp,-32
    800031fc:	ec06                	sd	ra,24(sp)
    800031fe:	e822                	sd	s0,16(sp)
    80003200:	1000                	addi	s0,sp,32
  int lockid;

  argint(0, &lockid);
    80003202:	fec40593          	addi	a1,s0,-20
    80003206:	4501                	li	a0,0
    80003208:	c1dff0ef          	jal	80002e24 <argint>
  if(lockid < 0 || lockid > 1)
    8000320c:	fec42703          	lw	a4,-20(s0)
    80003210:	4785                	li	a5,1
    return -1;
    80003212:	557d                	li	a0,-1
  if(lockid < 0 || lockid > 1)
    80003214:	04e7e263          	bltu	a5,a4,80003258 <sys_dlockrel+0x5e>

  ensure_demo_locks_inited();
    80003218:	cd9ff0ef          	jal	80002ef0 <ensure_demo_locks_inited>
  if(!holdingsleep(&demo_locks[lockid]))
    8000321c:	fec42703          	lw	a4,-20(s0)
    80003220:	00171793          	slli	a5,a4,0x1
    80003224:	97ba                	add	a5,a5,a4
    80003226:	0792                	slli	a5,a5,0x4
    80003228:	00018517          	auipc	a0,0x18
    8000322c:	29850513          	addi	a0,a0,664 # 8001b4c0 <demo_locks>
    80003230:	953e                	add	a0,a0,a5
    80003232:	616010ef          	jal	80004848 <holdingsleep>
    80003236:	87aa                	mv	a5,a0
    return -1;
    80003238:	557d                	li	a0,-1
  if(!holdingsleep(&demo_locks[lockid]))
    8000323a:	cf99                	beqz	a5,80003258 <sys_dlockrel+0x5e>

  releasesleep(&demo_locks[lockid]);
    8000323c:	fec42703          	lw	a4,-20(s0)
    80003240:	00171793          	slli	a5,a4,0x1
    80003244:	97ba                	add	a5,a5,a4
    80003246:	0792                	slli	a5,a5,0x4
    80003248:	00018517          	auipc	a0,0x18
    8000324c:	27850513          	addi	a0,a0,632 # 8001b4c0 <demo_locks>
    80003250:	953e                	add	a0,a0,a5
    80003252:	5be010ef          	jal	80004810 <releasesleep>
  return 0;
    80003256:	4501                	li	a0,0
}
    80003258:	60e2                	ld	ra,24(sp)
    8000325a:	6442                	ld	s0,16(sp)
    8000325c:	6105                	addi	sp,sp,32
    8000325e:	8082                	ret

0000000080003260 <sys_check_deadlock>:

// deadlock recovery system call
uint64
sys_check_deadlock(void)
{
    80003260:	1141                	addi	sp,sp,-16
    80003262:	e406                	sd	ra,8(sp)
    80003264:	e022                	sd	s0,0(sp)
    80003266:	0800                	addi	s0,sp,16
  return check_deadlock();
    80003268:	ca2ff0ef          	jal	8000270a <check_deadlock>
}
    8000326c:	60a2                	ld	ra,8(sp)
    8000326e:	6402                	ld	s0,0(sp)
    80003270:	0141                	addi	sp,sp,16
    80003272:	8082                	ret

0000000080003274 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003274:	7179                	addi	sp,sp,-48
    80003276:	f406                	sd	ra,40(sp)
    80003278:	f022                	sd	s0,32(sp)
    8000327a:	ec26                	sd	s1,24(sp)
    8000327c:	e84a                	sd	s2,16(sp)
    8000327e:	e44e                	sd	s3,8(sp)
    80003280:	e052                	sd	s4,0(sp)
    80003282:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003284:	00005597          	auipc	a1,0x5
    80003288:	2f458593          	addi	a1,a1,756 # 80008578 <etext+0x578>
    8000328c:	00018517          	auipc	a0,0x18
    80003290:	29450513          	addi	a0,a0,660 # 8001b520 <bcache>
    80003294:	8bbfd0ef          	jal	80000b4e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003298:	00020797          	auipc	a5,0x20
    8000329c:	28878793          	addi	a5,a5,648 # 80023520 <bcache+0x8000>
    800032a0:	00020717          	auipc	a4,0x20
    800032a4:	4e870713          	addi	a4,a4,1256 # 80023788 <bcache+0x8268>
    800032a8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800032ac:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800032b0:	00018497          	auipc	s1,0x18
    800032b4:	28848493          	addi	s1,s1,648 # 8001b538 <bcache+0x18>
    b->next = bcache.head.next;
    800032b8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800032ba:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800032bc:	00005a17          	auipc	s4,0x5
    800032c0:	2c4a0a13          	addi	s4,s4,708 # 80008580 <etext+0x580>
    b->next = bcache.head.next;
    800032c4:	2b893783          	ld	a5,696(s2)
    800032c8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800032ca:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800032ce:	85d2                	mv	a1,s4
    800032d0:	01048513          	addi	a0,s1,16
    800032d4:	360010ef          	jal	80004634 <initsleeplock>
    bcache.head.next->prev = b;
    800032d8:	2b893783          	ld	a5,696(s2)
    800032dc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800032de:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800032e2:	45848493          	addi	s1,s1,1112
    800032e6:	fd349fe3          	bne	s1,s3,800032c4 <binit+0x50>
  }
}
    800032ea:	70a2                	ld	ra,40(sp)
    800032ec:	7402                	ld	s0,32(sp)
    800032ee:	64e2                	ld	s1,24(sp)
    800032f0:	6942                	ld	s2,16(sp)
    800032f2:	69a2                	ld	s3,8(sp)
    800032f4:	6a02                	ld	s4,0(sp)
    800032f6:	6145                	addi	sp,sp,48
    800032f8:	8082                	ret

00000000800032fa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800032fa:	7179                	addi	sp,sp,-48
    800032fc:	f406                	sd	ra,40(sp)
    800032fe:	f022                	sd	s0,32(sp)
    80003300:	ec26                	sd	s1,24(sp)
    80003302:	e84a                	sd	s2,16(sp)
    80003304:	e44e                	sd	s3,8(sp)
    80003306:	1800                	addi	s0,sp,48
    80003308:	892a                	mv	s2,a0
    8000330a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000330c:	00018517          	auipc	a0,0x18
    80003310:	21450513          	addi	a0,a0,532 # 8001b520 <bcache>
    80003314:	8bbfd0ef          	jal	80000bce <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003318:	00020497          	auipc	s1,0x20
    8000331c:	4c04b483          	ld	s1,1216(s1) # 800237d8 <bcache+0x82b8>
    80003320:	00020797          	auipc	a5,0x20
    80003324:	46878793          	addi	a5,a5,1128 # 80023788 <bcache+0x8268>
    80003328:	02f48b63          	beq	s1,a5,8000335e <bread+0x64>
    8000332c:	873e                	mv	a4,a5
    8000332e:	a021                	j	80003336 <bread+0x3c>
    80003330:	68a4                	ld	s1,80(s1)
    80003332:	02e48663          	beq	s1,a4,8000335e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80003336:	449c                	lw	a5,8(s1)
    80003338:	ff279ce3          	bne	a5,s2,80003330 <bread+0x36>
    8000333c:	44dc                	lw	a5,12(s1)
    8000333e:	ff3799e3          	bne	a5,s3,80003330 <bread+0x36>
      b->refcnt++;
    80003342:	40bc                	lw	a5,64(s1)
    80003344:	2785                	addiw	a5,a5,1
    80003346:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003348:	00018517          	auipc	a0,0x18
    8000334c:	1d850513          	addi	a0,a0,472 # 8001b520 <bcache>
    80003350:	917fd0ef          	jal	80000c66 <release>
      acquiresleep(&b->lock);
    80003354:	01048513          	addi	a0,s1,16
    80003358:	312010ef          	jal	8000466a <acquiresleep>
      return b;
    8000335c:	a889                	j	800033ae <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000335e:	00020497          	auipc	s1,0x20
    80003362:	4724b483          	ld	s1,1138(s1) # 800237d0 <bcache+0x82b0>
    80003366:	00020797          	auipc	a5,0x20
    8000336a:	42278793          	addi	a5,a5,1058 # 80023788 <bcache+0x8268>
    8000336e:	00f48863          	beq	s1,a5,8000337e <bread+0x84>
    80003372:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003374:	40bc                	lw	a5,64(s1)
    80003376:	cb91                	beqz	a5,8000338a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003378:	64a4                	ld	s1,72(s1)
    8000337a:	fee49de3          	bne	s1,a4,80003374 <bread+0x7a>
  panic("bget: no buffers");
    8000337e:	00005517          	auipc	a0,0x5
    80003382:	20a50513          	addi	a0,a0,522 # 80008588 <etext+0x588>
    80003386:	c5afd0ef          	jal	800007e0 <panic>
      b->dev = dev;
    8000338a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000338e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003392:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003396:	4785                	li	a5,1
    80003398:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000339a:	00018517          	auipc	a0,0x18
    8000339e:	18650513          	addi	a0,a0,390 # 8001b520 <bcache>
    800033a2:	8c5fd0ef          	jal	80000c66 <release>
      acquiresleep(&b->lock);
    800033a6:	01048513          	addi	a0,s1,16
    800033aa:	2c0010ef          	jal	8000466a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800033ae:	409c                	lw	a5,0(s1)
    800033b0:	cb89                	beqz	a5,800033c2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800033b2:	8526                	mv	a0,s1
    800033b4:	70a2                	ld	ra,40(sp)
    800033b6:	7402                	ld	s0,32(sp)
    800033b8:	64e2                	ld	s1,24(sp)
    800033ba:	6942                	ld	s2,16(sp)
    800033bc:	69a2                	ld	s3,8(sp)
    800033be:	6145                	addi	sp,sp,48
    800033c0:	8082                	ret
    virtio_disk_rw(b, 0);
    800033c2:	4581                	li	a1,0
    800033c4:	8526                	mv	a0,s1
    800033c6:	4db020ef          	jal	800060a0 <virtio_disk_rw>
    b->valid = 1;
    800033ca:	4785                	li	a5,1
    800033cc:	c09c                	sw	a5,0(s1)
  return b;
    800033ce:	b7d5                	j	800033b2 <bread+0xb8>

00000000800033d0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800033d0:	1101                	addi	sp,sp,-32
    800033d2:	ec06                	sd	ra,24(sp)
    800033d4:	e822                	sd	s0,16(sp)
    800033d6:	e426                	sd	s1,8(sp)
    800033d8:	1000                	addi	s0,sp,32
    800033da:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800033dc:	0541                	addi	a0,a0,16
    800033de:	46a010ef          	jal	80004848 <holdingsleep>
    800033e2:	c911                	beqz	a0,800033f6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800033e4:	4585                	li	a1,1
    800033e6:	8526                	mv	a0,s1
    800033e8:	4b9020ef          	jal	800060a0 <virtio_disk_rw>
}
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	64a2                	ld	s1,8(sp)
    800033f2:	6105                	addi	sp,sp,32
    800033f4:	8082                	ret
    panic("bwrite");
    800033f6:	00005517          	auipc	a0,0x5
    800033fa:	1aa50513          	addi	a0,a0,426 # 800085a0 <etext+0x5a0>
    800033fe:	be2fd0ef          	jal	800007e0 <panic>

0000000080003402 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003402:	1101                	addi	sp,sp,-32
    80003404:	ec06                	sd	ra,24(sp)
    80003406:	e822                	sd	s0,16(sp)
    80003408:	e426                	sd	s1,8(sp)
    8000340a:	e04a                	sd	s2,0(sp)
    8000340c:	1000                	addi	s0,sp,32
    8000340e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003410:	01050913          	addi	s2,a0,16
    80003414:	854a                	mv	a0,s2
    80003416:	432010ef          	jal	80004848 <holdingsleep>
    8000341a:	c135                	beqz	a0,8000347e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000341c:	854a                	mv	a0,s2
    8000341e:	3f2010ef          	jal	80004810 <releasesleep>

  acquire(&bcache.lock);
    80003422:	00018517          	auipc	a0,0x18
    80003426:	0fe50513          	addi	a0,a0,254 # 8001b520 <bcache>
    8000342a:	fa4fd0ef          	jal	80000bce <acquire>
  b->refcnt--;
    8000342e:	40bc                	lw	a5,64(s1)
    80003430:	37fd                	addiw	a5,a5,-1
    80003432:	0007871b          	sext.w	a4,a5
    80003436:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003438:	e71d                	bnez	a4,80003466 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000343a:	68b8                	ld	a4,80(s1)
    8000343c:	64bc                	ld	a5,72(s1)
    8000343e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003440:	68b8                	ld	a4,80(s1)
    80003442:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003444:	00020797          	auipc	a5,0x20
    80003448:	0dc78793          	addi	a5,a5,220 # 80023520 <bcache+0x8000>
    8000344c:	2b87b703          	ld	a4,696(a5)
    80003450:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003452:	00020717          	auipc	a4,0x20
    80003456:	33670713          	addi	a4,a4,822 # 80023788 <bcache+0x8268>
    8000345a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000345c:	2b87b703          	ld	a4,696(a5)
    80003460:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003462:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003466:	00018517          	auipc	a0,0x18
    8000346a:	0ba50513          	addi	a0,a0,186 # 8001b520 <bcache>
    8000346e:	ff8fd0ef          	jal	80000c66 <release>
}
    80003472:	60e2                	ld	ra,24(sp)
    80003474:	6442                	ld	s0,16(sp)
    80003476:	64a2                	ld	s1,8(sp)
    80003478:	6902                	ld	s2,0(sp)
    8000347a:	6105                	addi	sp,sp,32
    8000347c:	8082                	ret
    panic("brelse");
    8000347e:	00005517          	auipc	a0,0x5
    80003482:	12a50513          	addi	a0,a0,298 # 800085a8 <etext+0x5a8>
    80003486:	b5afd0ef          	jal	800007e0 <panic>

000000008000348a <bpin>:

void
bpin(struct buf *b) {
    8000348a:	1101                	addi	sp,sp,-32
    8000348c:	ec06                	sd	ra,24(sp)
    8000348e:	e822                	sd	s0,16(sp)
    80003490:	e426                	sd	s1,8(sp)
    80003492:	1000                	addi	s0,sp,32
    80003494:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003496:	00018517          	auipc	a0,0x18
    8000349a:	08a50513          	addi	a0,a0,138 # 8001b520 <bcache>
    8000349e:	f30fd0ef          	jal	80000bce <acquire>
  b->refcnt++;
    800034a2:	40bc                	lw	a5,64(s1)
    800034a4:	2785                	addiw	a5,a5,1
    800034a6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800034a8:	00018517          	auipc	a0,0x18
    800034ac:	07850513          	addi	a0,a0,120 # 8001b520 <bcache>
    800034b0:	fb6fd0ef          	jal	80000c66 <release>
}
    800034b4:	60e2                	ld	ra,24(sp)
    800034b6:	6442                	ld	s0,16(sp)
    800034b8:	64a2                	ld	s1,8(sp)
    800034ba:	6105                	addi	sp,sp,32
    800034bc:	8082                	ret

00000000800034be <bunpin>:

void
bunpin(struct buf *b) {
    800034be:	1101                	addi	sp,sp,-32
    800034c0:	ec06                	sd	ra,24(sp)
    800034c2:	e822                	sd	s0,16(sp)
    800034c4:	e426                	sd	s1,8(sp)
    800034c6:	1000                	addi	s0,sp,32
    800034c8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800034ca:	00018517          	auipc	a0,0x18
    800034ce:	05650513          	addi	a0,a0,86 # 8001b520 <bcache>
    800034d2:	efcfd0ef          	jal	80000bce <acquire>
  b->refcnt--;
    800034d6:	40bc                	lw	a5,64(s1)
    800034d8:	37fd                	addiw	a5,a5,-1
    800034da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800034dc:	00018517          	auipc	a0,0x18
    800034e0:	04450513          	addi	a0,a0,68 # 8001b520 <bcache>
    800034e4:	f82fd0ef          	jal	80000c66 <release>
}
    800034e8:	60e2                	ld	ra,24(sp)
    800034ea:	6442                	ld	s0,16(sp)
    800034ec:	64a2                	ld	s1,8(sp)
    800034ee:	6105                	addi	sp,sp,32
    800034f0:	8082                	ret

00000000800034f2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800034f2:	1101                	addi	sp,sp,-32
    800034f4:	ec06                	sd	ra,24(sp)
    800034f6:	e822                	sd	s0,16(sp)
    800034f8:	e426                	sd	s1,8(sp)
    800034fa:	e04a                	sd	s2,0(sp)
    800034fc:	1000                	addi	s0,sp,32
    800034fe:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003500:	00d5d59b          	srliw	a1,a1,0xd
    80003504:	00020797          	auipc	a5,0x20
    80003508:	6f87a783          	lw	a5,1784(a5) # 80023bfc <sb+0x1c>
    8000350c:	9dbd                	addw	a1,a1,a5
    8000350e:	dedff0ef          	jal	800032fa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003512:	0074f713          	andi	a4,s1,7
    80003516:	4785                	li	a5,1
    80003518:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000351c:	14ce                	slli	s1,s1,0x33
    8000351e:	90d9                	srli	s1,s1,0x36
    80003520:	00950733          	add	a4,a0,s1
    80003524:	05874703          	lbu	a4,88(a4)
    80003528:	00e7f6b3          	and	a3,a5,a4
    8000352c:	c29d                	beqz	a3,80003552 <bfree+0x60>
    8000352e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003530:	94aa                	add	s1,s1,a0
    80003532:	fff7c793          	not	a5,a5
    80003536:	8f7d                	and	a4,a4,a5
    80003538:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000353c:	7f9000ef          	jal	80004534 <log_write>
  brelse(bp);
    80003540:	854a                	mv	a0,s2
    80003542:	ec1ff0ef          	jal	80003402 <brelse>
}
    80003546:	60e2                	ld	ra,24(sp)
    80003548:	6442                	ld	s0,16(sp)
    8000354a:	64a2                	ld	s1,8(sp)
    8000354c:	6902                	ld	s2,0(sp)
    8000354e:	6105                	addi	sp,sp,32
    80003550:	8082                	ret
    panic("freeing free block");
    80003552:	00005517          	auipc	a0,0x5
    80003556:	05e50513          	addi	a0,a0,94 # 800085b0 <etext+0x5b0>
    8000355a:	a86fd0ef          	jal	800007e0 <panic>

000000008000355e <balloc>:
{
    8000355e:	711d                	addi	sp,sp,-96
    80003560:	ec86                	sd	ra,88(sp)
    80003562:	e8a2                	sd	s0,80(sp)
    80003564:	e4a6                	sd	s1,72(sp)
    80003566:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003568:	00020797          	auipc	a5,0x20
    8000356c:	67c7a783          	lw	a5,1660(a5) # 80023be4 <sb+0x4>
    80003570:	0e078f63          	beqz	a5,8000366e <balloc+0x110>
    80003574:	e0ca                	sd	s2,64(sp)
    80003576:	fc4e                	sd	s3,56(sp)
    80003578:	f852                	sd	s4,48(sp)
    8000357a:	f456                	sd	s5,40(sp)
    8000357c:	f05a                	sd	s6,32(sp)
    8000357e:	ec5e                	sd	s7,24(sp)
    80003580:	e862                	sd	s8,16(sp)
    80003582:	e466                	sd	s9,8(sp)
    80003584:	8baa                	mv	s7,a0
    80003586:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003588:	00020b17          	auipc	s6,0x20
    8000358c:	658b0b13          	addi	s6,s6,1624 # 80023be0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003590:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003592:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003594:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003596:	6c89                	lui	s9,0x2
    80003598:	a0b5                	j	80003604 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000359a:	97ca                	add	a5,a5,s2
    8000359c:	8e55                	or	a2,a2,a3
    8000359e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800035a2:	854a                	mv	a0,s2
    800035a4:	791000ef          	jal	80004534 <log_write>
        brelse(bp);
    800035a8:	854a                	mv	a0,s2
    800035aa:	e59ff0ef          	jal	80003402 <brelse>
  bp = bread(dev, bno);
    800035ae:	85a6                	mv	a1,s1
    800035b0:	855e                	mv	a0,s7
    800035b2:	d49ff0ef          	jal	800032fa <bread>
    800035b6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800035b8:	40000613          	li	a2,1024
    800035bc:	4581                	li	a1,0
    800035be:	05850513          	addi	a0,a0,88
    800035c2:	ee0fd0ef          	jal	80000ca2 <memset>
  log_write(bp);
    800035c6:	854a                	mv	a0,s2
    800035c8:	76d000ef          	jal	80004534 <log_write>
  brelse(bp);
    800035cc:	854a                	mv	a0,s2
    800035ce:	e35ff0ef          	jal	80003402 <brelse>
}
    800035d2:	6906                	ld	s2,64(sp)
    800035d4:	79e2                	ld	s3,56(sp)
    800035d6:	7a42                	ld	s4,48(sp)
    800035d8:	7aa2                	ld	s5,40(sp)
    800035da:	7b02                	ld	s6,32(sp)
    800035dc:	6be2                	ld	s7,24(sp)
    800035de:	6c42                	ld	s8,16(sp)
    800035e0:	6ca2                	ld	s9,8(sp)
}
    800035e2:	8526                	mv	a0,s1
    800035e4:	60e6                	ld	ra,88(sp)
    800035e6:	6446                	ld	s0,80(sp)
    800035e8:	64a6                	ld	s1,72(sp)
    800035ea:	6125                	addi	sp,sp,96
    800035ec:	8082                	ret
    brelse(bp);
    800035ee:	854a                	mv	a0,s2
    800035f0:	e13ff0ef          	jal	80003402 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800035f4:	015c87bb          	addw	a5,s9,s5
    800035f8:	00078a9b          	sext.w	s5,a5
    800035fc:	004b2703          	lw	a4,4(s6)
    80003600:	04eaff63          	bgeu	s5,a4,8000365e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80003604:	41fad79b          	sraiw	a5,s5,0x1f
    80003608:	0137d79b          	srliw	a5,a5,0x13
    8000360c:	015787bb          	addw	a5,a5,s5
    80003610:	40d7d79b          	sraiw	a5,a5,0xd
    80003614:	01cb2583          	lw	a1,28(s6)
    80003618:	9dbd                	addw	a1,a1,a5
    8000361a:	855e                	mv	a0,s7
    8000361c:	cdfff0ef          	jal	800032fa <bread>
    80003620:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003622:	004b2503          	lw	a0,4(s6)
    80003626:	000a849b          	sext.w	s1,s5
    8000362a:	8762                	mv	a4,s8
    8000362c:	fca4f1e3          	bgeu	s1,a0,800035ee <balloc+0x90>
      m = 1 << (bi % 8);
    80003630:	00777693          	andi	a3,a4,7
    80003634:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003638:	41f7579b          	sraiw	a5,a4,0x1f
    8000363c:	01d7d79b          	srliw	a5,a5,0x1d
    80003640:	9fb9                	addw	a5,a5,a4
    80003642:	4037d79b          	sraiw	a5,a5,0x3
    80003646:	00f90633          	add	a2,s2,a5
    8000364a:	05864603          	lbu	a2,88(a2)
    8000364e:	00c6f5b3          	and	a1,a3,a2
    80003652:	d5a1                	beqz	a1,8000359a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003654:	2705                	addiw	a4,a4,1
    80003656:	2485                	addiw	s1,s1,1
    80003658:	fd471ae3          	bne	a4,s4,8000362c <balloc+0xce>
    8000365c:	bf49                	j	800035ee <balloc+0x90>
    8000365e:	6906                	ld	s2,64(sp)
    80003660:	79e2                	ld	s3,56(sp)
    80003662:	7a42                	ld	s4,48(sp)
    80003664:	7aa2                	ld	s5,40(sp)
    80003666:	7b02                	ld	s6,32(sp)
    80003668:	6be2                	ld	s7,24(sp)
    8000366a:	6c42                	ld	s8,16(sp)
    8000366c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000366e:	00005517          	auipc	a0,0x5
    80003672:	f5a50513          	addi	a0,a0,-166 # 800085c8 <etext+0x5c8>
    80003676:	e85fc0ef          	jal	800004fa <printf>
  return 0;
    8000367a:	4481                	li	s1,0
    8000367c:	b79d                	j	800035e2 <balloc+0x84>

000000008000367e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000367e:	7179                	addi	sp,sp,-48
    80003680:	f406                	sd	ra,40(sp)
    80003682:	f022                	sd	s0,32(sp)
    80003684:	ec26                	sd	s1,24(sp)
    80003686:	e84a                	sd	s2,16(sp)
    80003688:	e44e                	sd	s3,8(sp)
    8000368a:	1800                	addi	s0,sp,48
    8000368c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000368e:	47ad                	li	a5,11
    80003690:	02b7e663          	bltu	a5,a1,800036bc <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003694:	02059793          	slli	a5,a1,0x20
    80003698:	01e7d593          	srli	a1,a5,0x1e
    8000369c:	00b504b3          	add	s1,a0,a1
    800036a0:	0504a903          	lw	s2,80(s1)
    800036a4:	06091a63          	bnez	s2,80003718 <bmap+0x9a>
      addr = balloc(ip->dev);
    800036a8:	4108                	lw	a0,0(a0)
    800036aa:	eb5ff0ef          	jal	8000355e <balloc>
    800036ae:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800036b2:	06090363          	beqz	s2,80003718 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800036b6:	0524a823          	sw	s2,80(s1)
    800036ba:	a8b9                	j	80003718 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800036bc:	ff45849b          	addiw	s1,a1,-12
    800036c0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800036c4:	0ff00793          	li	a5,255
    800036c8:	06e7ee63          	bltu	a5,a4,80003744 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800036cc:	08052903          	lw	s2,128(a0)
    800036d0:	00091d63          	bnez	s2,800036ea <bmap+0x6c>
      addr = balloc(ip->dev);
    800036d4:	4108                	lw	a0,0(a0)
    800036d6:	e89ff0ef          	jal	8000355e <balloc>
    800036da:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800036de:	02090d63          	beqz	s2,80003718 <bmap+0x9a>
    800036e2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800036e4:	0929a023          	sw	s2,128(s3)
    800036e8:	a011                	j	800036ec <bmap+0x6e>
    800036ea:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800036ec:	85ca                	mv	a1,s2
    800036ee:	0009a503          	lw	a0,0(s3)
    800036f2:	c09ff0ef          	jal	800032fa <bread>
    800036f6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800036f8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800036fc:	02049713          	slli	a4,s1,0x20
    80003700:	01e75593          	srli	a1,a4,0x1e
    80003704:	00b784b3          	add	s1,a5,a1
    80003708:	0004a903          	lw	s2,0(s1)
    8000370c:	00090e63          	beqz	s2,80003728 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003710:	8552                	mv	a0,s4
    80003712:	cf1ff0ef          	jal	80003402 <brelse>
    return addr;
    80003716:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003718:	854a                	mv	a0,s2
    8000371a:	70a2                	ld	ra,40(sp)
    8000371c:	7402                	ld	s0,32(sp)
    8000371e:	64e2                	ld	s1,24(sp)
    80003720:	6942                	ld	s2,16(sp)
    80003722:	69a2                	ld	s3,8(sp)
    80003724:	6145                	addi	sp,sp,48
    80003726:	8082                	ret
      addr = balloc(ip->dev);
    80003728:	0009a503          	lw	a0,0(s3)
    8000372c:	e33ff0ef          	jal	8000355e <balloc>
    80003730:	0005091b          	sext.w	s2,a0
      if(addr){
    80003734:	fc090ee3          	beqz	s2,80003710 <bmap+0x92>
        a[bn] = addr;
    80003738:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000373c:	8552                	mv	a0,s4
    8000373e:	5f7000ef          	jal	80004534 <log_write>
    80003742:	b7f9                	j	80003710 <bmap+0x92>
    80003744:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003746:	00005517          	auipc	a0,0x5
    8000374a:	e9a50513          	addi	a0,a0,-358 # 800085e0 <etext+0x5e0>
    8000374e:	892fd0ef          	jal	800007e0 <panic>

0000000080003752 <iget>:
{
    80003752:	7179                	addi	sp,sp,-48
    80003754:	f406                	sd	ra,40(sp)
    80003756:	f022                	sd	s0,32(sp)
    80003758:	ec26                	sd	s1,24(sp)
    8000375a:	e84a                	sd	s2,16(sp)
    8000375c:	e44e                	sd	s3,8(sp)
    8000375e:	e052                	sd	s4,0(sp)
    80003760:	1800                	addi	s0,sp,48
    80003762:	89aa                	mv	s3,a0
    80003764:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003766:	00020517          	auipc	a0,0x20
    8000376a:	49a50513          	addi	a0,a0,1178 # 80023c00 <itable>
    8000376e:	c60fd0ef          	jal	80000bce <acquire>
  empty = 0;
    80003772:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003774:	00020497          	auipc	s1,0x20
    80003778:	4a448493          	addi	s1,s1,1188 # 80023c18 <itable+0x18>
    8000377c:	00022697          	auipc	a3,0x22
    80003780:	f2c68693          	addi	a3,a3,-212 # 800256a8 <log>
    80003784:	a039                	j	80003792 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003786:	02090963          	beqz	s2,800037b8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000378a:	08848493          	addi	s1,s1,136
    8000378e:	02d48863          	beq	s1,a3,800037be <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003792:	449c                	lw	a5,8(s1)
    80003794:	fef059e3          	blez	a5,80003786 <iget+0x34>
    80003798:	4098                	lw	a4,0(s1)
    8000379a:	ff3716e3          	bne	a4,s3,80003786 <iget+0x34>
    8000379e:	40d8                	lw	a4,4(s1)
    800037a0:	ff4713e3          	bne	a4,s4,80003786 <iget+0x34>
      ip->ref++;
    800037a4:	2785                	addiw	a5,a5,1
    800037a6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800037a8:	00020517          	auipc	a0,0x20
    800037ac:	45850513          	addi	a0,a0,1112 # 80023c00 <itable>
    800037b0:	cb6fd0ef          	jal	80000c66 <release>
      return ip;
    800037b4:	8926                	mv	s2,s1
    800037b6:	a02d                	j	800037e0 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800037b8:	fbe9                	bnez	a5,8000378a <iget+0x38>
      empty = ip;
    800037ba:	8926                	mv	s2,s1
    800037bc:	b7f9                	j	8000378a <iget+0x38>
  if(empty == 0)
    800037be:	02090a63          	beqz	s2,800037f2 <iget+0xa0>
  ip->dev = dev;
    800037c2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800037c6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800037ca:	4785                	li	a5,1
    800037cc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800037d0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800037d4:	00020517          	auipc	a0,0x20
    800037d8:	42c50513          	addi	a0,a0,1068 # 80023c00 <itable>
    800037dc:	c8afd0ef          	jal	80000c66 <release>
}
    800037e0:	854a                	mv	a0,s2
    800037e2:	70a2                	ld	ra,40(sp)
    800037e4:	7402                	ld	s0,32(sp)
    800037e6:	64e2                	ld	s1,24(sp)
    800037e8:	6942                	ld	s2,16(sp)
    800037ea:	69a2                	ld	s3,8(sp)
    800037ec:	6a02                	ld	s4,0(sp)
    800037ee:	6145                	addi	sp,sp,48
    800037f0:	8082                	ret
    panic("iget: no inodes");
    800037f2:	00005517          	auipc	a0,0x5
    800037f6:	e0650513          	addi	a0,a0,-506 # 800085f8 <etext+0x5f8>
    800037fa:	fe7fc0ef          	jal	800007e0 <panic>

00000000800037fe <iinit>:
{
    800037fe:	7179                	addi	sp,sp,-48
    80003800:	f406                	sd	ra,40(sp)
    80003802:	f022                	sd	s0,32(sp)
    80003804:	ec26                	sd	s1,24(sp)
    80003806:	e84a                	sd	s2,16(sp)
    80003808:	e44e                	sd	s3,8(sp)
    8000380a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000380c:	00005597          	auipc	a1,0x5
    80003810:	dfc58593          	addi	a1,a1,-516 # 80008608 <etext+0x608>
    80003814:	00020517          	auipc	a0,0x20
    80003818:	3ec50513          	addi	a0,a0,1004 # 80023c00 <itable>
    8000381c:	b32fd0ef          	jal	80000b4e <initlock>
  for(i = 0; i < NINODE; i++) {
    80003820:	00020497          	auipc	s1,0x20
    80003824:	40848493          	addi	s1,s1,1032 # 80023c28 <itable+0x28>
    80003828:	00022997          	auipc	s3,0x22
    8000382c:	e9098993          	addi	s3,s3,-368 # 800256b8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003830:	00005917          	auipc	s2,0x5
    80003834:	de090913          	addi	s2,s2,-544 # 80008610 <etext+0x610>
    80003838:	85ca                	mv	a1,s2
    8000383a:	8526                	mv	a0,s1
    8000383c:	5f9000ef          	jal	80004634 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003840:	08848493          	addi	s1,s1,136
    80003844:	ff349ae3          	bne	s1,s3,80003838 <iinit+0x3a>
}
    80003848:	70a2                	ld	ra,40(sp)
    8000384a:	7402                	ld	s0,32(sp)
    8000384c:	64e2                	ld	s1,24(sp)
    8000384e:	6942                	ld	s2,16(sp)
    80003850:	69a2                	ld	s3,8(sp)
    80003852:	6145                	addi	sp,sp,48
    80003854:	8082                	ret

0000000080003856 <ialloc>:
{
    80003856:	7139                	addi	sp,sp,-64
    80003858:	fc06                	sd	ra,56(sp)
    8000385a:	f822                	sd	s0,48(sp)
    8000385c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000385e:	00020717          	auipc	a4,0x20
    80003862:	38e72703          	lw	a4,910(a4) # 80023bec <sb+0xc>
    80003866:	4785                	li	a5,1
    80003868:	06e7f063          	bgeu	a5,a4,800038c8 <ialloc+0x72>
    8000386c:	f426                	sd	s1,40(sp)
    8000386e:	f04a                	sd	s2,32(sp)
    80003870:	ec4e                	sd	s3,24(sp)
    80003872:	e852                	sd	s4,16(sp)
    80003874:	e456                	sd	s5,8(sp)
    80003876:	e05a                	sd	s6,0(sp)
    80003878:	8aaa                	mv	s5,a0
    8000387a:	8b2e                	mv	s6,a1
    8000387c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000387e:	00020a17          	auipc	s4,0x20
    80003882:	362a0a13          	addi	s4,s4,866 # 80023be0 <sb>
    80003886:	00495593          	srli	a1,s2,0x4
    8000388a:	018a2783          	lw	a5,24(s4)
    8000388e:	9dbd                	addw	a1,a1,a5
    80003890:	8556                	mv	a0,s5
    80003892:	a69ff0ef          	jal	800032fa <bread>
    80003896:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003898:	05850993          	addi	s3,a0,88
    8000389c:	00f97793          	andi	a5,s2,15
    800038a0:	079a                	slli	a5,a5,0x6
    800038a2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800038a4:	00099783          	lh	a5,0(s3)
    800038a8:	cb9d                	beqz	a5,800038de <ialloc+0x88>
    brelse(bp);
    800038aa:	b59ff0ef          	jal	80003402 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800038ae:	0905                	addi	s2,s2,1
    800038b0:	00ca2703          	lw	a4,12(s4)
    800038b4:	0009079b          	sext.w	a5,s2
    800038b8:	fce7e7e3          	bltu	a5,a4,80003886 <ialloc+0x30>
    800038bc:	74a2                	ld	s1,40(sp)
    800038be:	7902                	ld	s2,32(sp)
    800038c0:	69e2                	ld	s3,24(sp)
    800038c2:	6a42                	ld	s4,16(sp)
    800038c4:	6aa2                	ld	s5,8(sp)
    800038c6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800038c8:	00005517          	auipc	a0,0x5
    800038cc:	d5050513          	addi	a0,a0,-688 # 80008618 <etext+0x618>
    800038d0:	c2bfc0ef          	jal	800004fa <printf>
  return 0;
    800038d4:	4501                	li	a0,0
}
    800038d6:	70e2                	ld	ra,56(sp)
    800038d8:	7442                	ld	s0,48(sp)
    800038da:	6121                	addi	sp,sp,64
    800038dc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800038de:	04000613          	li	a2,64
    800038e2:	4581                	li	a1,0
    800038e4:	854e                	mv	a0,s3
    800038e6:	bbcfd0ef          	jal	80000ca2 <memset>
      dip->type = type;
    800038ea:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800038ee:	8526                	mv	a0,s1
    800038f0:	445000ef          	jal	80004534 <log_write>
      brelse(bp);
    800038f4:	8526                	mv	a0,s1
    800038f6:	b0dff0ef          	jal	80003402 <brelse>
      return iget(dev, inum);
    800038fa:	0009059b          	sext.w	a1,s2
    800038fe:	8556                	mv	a0,s5
    80003900:	e53ff0ef          	jal	80003752 <iget>
    80003904:	74a2                	ld	s1,40(sp)
    80003906:	7902                	ld	s2,32(sp)
    80003908:	69e2                	ld	s3,24(sp)
    8000390a:	6a42                	ld	s4,16(sp)
    8000390c:	6aa2                	ld	s5,8(sp)
    8000390e:	6b02                	ld	s6,0(sp)
    80003910:	b7d9                	j	800038d6 <ialloc+0x80>

0000000080003912 <iupdate>:
{
    80003912:	1101                	addi	sp,sp,-32
    80003914:	ec06                	sd	ra,24(sp)
    80003916:	e822                	sd	s0,16(sp)
    80003918:	e426                	sd	s1,8(sp)
    8000391a:	e04a                	sd	s2,0(sp)
    8000391c:	1000                	addi	s0,sp,32
    8000391e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003920:	415c                	lw	a5,4(a0)
    80003922:	0047d79b          	srliw	a5,a5,0x4
    80003926:	00020597          	auipc	a1,0x20
    8000392a:	2d25a583          	lw	a1,722(a1) # 80023bf8 <sb+0x18>
    8000392e:	9dbd                	addw	a1,a1,a5
    80003930:	4108                	lw	a0,0(a0)
    80003932:	9c9ff0ef          	jal	800032fa <bread>
    80003936:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003938:	05850793          	addi	a5,a0,88
    8000393c:	40d8                	lw	a4,4(s1)
    8000393e:	8b3d                	andi	a4,a4,15
    80003940:	071a                	slli	a4,a4,0x6
    80003942:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003944:	04449703          	lh	a4,68(s1)
    80003948:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000394c:	04649703          	lh	a4,70(s1)
    80003950:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003954:	04849703          	lh	a4,72(s1)
    80003958:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000395c:	04a49703          	lh	a4,74(s1)
    80003960:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003964:	44f8                	lw	a4,76(s1)
    80003966:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003968:	03400613          	li	a2,52
    8000396c:	05048593          	addi	a1,s1,80
    80003970:	00c78513          	addi	a0,a5,12
    80003974:	b8afd0ef          	jal	80000cfe <memmove>
  log_write(bp);
    80003978:	854a                	mv	a0,s2
    8000397a:	3bb000ef          	jal	80004534 <log_write>
  brelse(bp);
    8000397e:	854a                	mv	a0,s2
    80003980:	a83ff0ef          	jal	80003402 <brelse>
}
    80003984:	60e2                	ld	ra,24(sp)
    80003986:	6442                	ld	s0,16(sp)
    80003988:	64a2                	ld	s1,8(sp)
    8000398a:	6902                	ld	s2,0(sp)
    8000398c:	6105                	addi	sp,sp,32
    8000398e:	8082                	ret

0000000080003990 <idup>:
{
    80003990:	1101                	addi	sp,sp,-32
    80003992:	ec06                	sd	ra,24(sp)
    80003994:	e822                	sd	s0,16(sp)
    80003996:	e426                	sd	s1,8(sp)
    80003998:	1000                	addi	s0,sp,32
    8000399a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000399c:	00020517          	auipc	a0,0x20
    800039a0:	26450513          	addi	a0,a0,612 # 80023c00 <itable>
    800039a4:	a2afd0ef          	jal	80000bce <acquire>
  ip->ref++;
    800039a8:	449c                	lw	a5,8(s1)
    800039aa:	2785                	addiw	a5,a5,1
    800039ac:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800039ae:	00020517          	auipc	a0,0x20
    800039b2:	25250513          	addi	a0,a0,594 # 80023c00 <itable>
    800039b6:	ab0fd0ef          	jal	80000c66 <release>
}
    800039ba:	8526                	mv	a0,s1
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	64a2                	ld	s1,8(sp)
    800039c2:	6105                	addi	sp,sp,32
    800039c4:	8082                	ret

00000000800039c6 <ilock>:
{
    800039c6:	1101                	addi	sp,sp,-32
    800039c8:	ec06                	sd	ra,24(sp)
    800039ca:	e822                	sd	s0,16(sp)
    800039cc:	e426                	sd	s1,8(sp)
    800039ce:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800039d0:	cd19                	beqz	a0,800039ee <ilock+0x28>
    800039d2:	84aa                	mv	s1,a0
    800039d4:	451c                	lw	a5,8(a0)
    800039d6:	00f05c63          	blez	a5,800039ee <ilock+0x28>
  acquiresleep(&ip->lock);
    800039da:	0541                	addi	a0,a0,16
    800039dc:	48f000ef          	jal	8000466a <acquiresleep>
  if(ip->valid == 0){
    800039e0:	40bc                	lw	a5,64(s1)
    800039e2:	cf89                	beqz	a5,800039fc <ilock+0x36>
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6105                	addi	sp,sp,32
    800039ec:	8082                	ret
    800039ee:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800039f0:	00005517          	auipc	a0,0x5
    800039f4:	c4050513          	addi	a0,a0,-960 # 80008630 <etext+0x630>
    800039f8:	de9fc0ef          	jal	800007e0 <panic>
    800039fc:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039fe:	40dc                	lw	a5,4(s1)
    80003a00:	0047d79b          	srliw	a5,a5,0x4
    80003a04:	00020597          	auipc	a1,0x20
    80003a08:	1f45a583          	lw	a1,500(a1) # 80023bf8 <sb+0x18>
    80003a0c:	9dbd                	addw	a1,a1,a5
    80003a0e:	4088                	lw	a0,0(s1)
    80003a10:	8ebff0ef          	jal	800032fa <bread>
    80003a14:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a16:	05850593          	addi	a1,a0,88
    80003a1a:	40dc                	lw	a5,4(s1)
    80003a1c:	8bbd                	andi	a5,a5,15
    80003a1e:	079a                	slli	a5,a5,0x6
    80003a20:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003a22:	00059783          	lh	a5,0(a1)
    80003a26:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003a2a:	00259783          	lh	a5,2(a1)
    80003a2e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003a32:	00459783          	lh	a5,4(a1)
    80003a36:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003a3a:	00659783          	lh	a5,6(a1)
    80003a3e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003a42:	459c                	lw	a5,8(a1)
    80003a44:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003a46:	03400613          	li	a2,52
    80003a4a:	05b1                	addi	a1,a1,12
    80003a4c:	05048513          	addi	a0,s1,80
    80003a50:	aaefd0ef          	jal	80000cfe <memmove>
    brelse(bp);
    80003a54:	854a                	mv	a0,s2
    80003a56:	9adff0ef          	jal	80003402 <brelse>
    ip->valid = 1;
    80003a5a:	4785                	li	a5,1
    80003a5c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003a5e:	04449783          	lh	a5,68(s1)
    80003a62:	c399                	beqz	a5,80003a68 <ilock+0xa2>
    80003a64:	6902                	ld	s2,0(sp)
    80003a66:	bfbd                	j	800039e4 <ilock+0x1e>
      panic("ilock: no type");
    80003a68:	00005517          	auipc	a0,0x5
    80003a6c:	bd050513          	addi	a0,a0,-1072 # 80008638 <etext+0x638>
    80003a70:	d71fc0ef          	jal	800007e0 <panic>

0000000080003a74 <iunlock>:
{
    80003a74:	1101                	addi	sp,sp,-32
    80003a76:	ec06                	sd	ra,24(sp)
    80003a78:	e822                	sd	s0,16(sp)
    80003a7a:	e426                	sd	s1,8(sp)
    80003a7c:	e04a                	sd	s2,0(sp)
    80003a7e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003a80:	c505                	beqz	a0,80003aa8 <iunlock+0x34>
    80003a82:	84aa                	mv	s1,a0
    80003a84:	01050913          	addi	s2,a0,16
    80003a88:	854a                	mv	a0,s2
    80003a8a:	5bf000ef          	jal	80004848 <holdingsleep>
    80003a8e:	cd09                	beqz	a0,80003aa8 <iunlock+0x34>
    80003a90:	449c                	lw	a5,8(s1)
    80003a92:	00f05b63          	blez	a5,80003aa8 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003a96:	854a                	mv	a0,s2
    80003a98:	579000ef          	jal	80004810 <releasesleep>
}
    80003a9c:	60e2                	ld	ra,24(sp)
    80003a9e:	6442                	ld	s0,16(sp)
    80003aa0:	64a2                	ld	s1,8(sp)
    80003aa2:	6902                	ld	s2,0(sp)
    80003aa4:	6105                	addi	sp,sp,32
    80003aa6:	8082                	ret
    panic("iunlock");
    80003aa8:	00005517          	auipc	a0,0x5
    80003aac:	ba050513          	addi	a0,a0,-1120 # 80008648 <etext+0x648>
    80003ab0:	d31fc0ef          	jal	800007e0 <panic>

0000000080003ab4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003ab4:	7179                	addi	sp,sp,-48
    80003ab6:	f406                	sd	ra,40(sp)
    80003ab8:	f022                	sd	s0,32(sp)
    80003aba:	ec26                	sd	s1,24(sp)
    80003abc:	e84a                	sd	s2,16(sp)
    80003abe:	e44e                	sd	s3,8(sp)
    80003ac0:	1800                	addi	s0,sp,48
    80003ac2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003ac4:	05050493          	addi	s1,a0,80
    80003ac8:	08050913          	addi	s2,a0,128
    80003acc:	a021                	j	80003ad4 <itrunc+0x20>
    80003ace:	0491                	addi	s1,s1,4
    80003ad0:	01248b63          	beq	s1,s2,80003ae6 <itrunc+0x32>
    if(ip->addrs[i]){
    80003ad4:	408c                	lw	a1,0(s1)
    80003ad6:	dde5                	beqz	a1,80003ace <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003ad8:	0009a503          	lw	a0,0(s3)
    80003adc:	a17ff0ef          	jal	800034f2 <bfree>
      ip->addrs[i] = 0;
    80003ae0:	0004a023          	sw	zero,0(s1)
    80003ae4:	b7ed                	j	80003ace <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003ae6:	0809a583          	lw	a1,128(s3)
    80003aea:	ed89                	bnez	a1,80003b04 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003aec:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003af0:	854e                	mv	a0,s3
    80003af2:	e21ff0ef          	jal	80003912 <iupdate>
}
    80003af6:	70a2                	ld	ra,40(sp)
    80003af8:	7402                	ld	s0,32(sp)
    80003afa:	64e2                	ld	s1,24(sp)
    80003afc:	6942                	ld	s2,16(sp)
    80003afe:	69a2                	ld	s3,8(sp)
    80003b00:	6145                	addi	sp,sp,48
    80003b02:	8082                	ret
    80003b04:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003b06:	0009a503          	lw	a0,0(s3)
    80003b0a:	ff0ff0ef          	jal	800032fa <bread>
    80003b0e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003b10:	05850493          	addi	s1,a0,88
    80003b14:	45850913          	addi	s2,a0,1112
    80003b18:	a021                	j	80003b20 <itrunc+0x6c>
    80003b1a:	0491                	addi	s1,s1,4
    80003b1c:	01248963          	beq	s1,s2,80003b2e <itrunc+0x7a>
      if(a[j])
    80003b20:	408c                	lw	a1,0(s1)
    80003b22:	dde5                	beqz	a1,80003b1a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003b24:	0009a503          	lw	a0,0(s3)
    80003b28:	9cbff0ef          	jal	800034f2 <bfree>
    80003b2c:	b7fd                	j	80003b1a <itrunc+0x66>
    brelse(bp);
    80003b2e:	8552                	mv	a0,s4
    80003b30:	8d3ff0ef          	jal	80003402 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003b34:	0809a583          	lw	a1,128(s3)
    80003b38:	0009a503          	lw	a0,0(s3)
    80003b3c:	9b7ff0ef          	jal	800034f2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003b40:	0809a023          	sw	zero,128(s3)
    80003b44:	6a02                	ld	s4,0(sp)
    80003b46:	b75d                	j	80003aec <itrunc+0x38>

0000000080003b48 <iput>:
{
    80003b48:	1101                	addi	sp,sp,-32
    80003b4a:	ec06                	sd	ra,24(sp)
    80003b4c:	e822                	sd	s0,16(sp)
    80003b4e:	e426                	sd	s1,8(sp)
    80003b50:	1000                	addi	s0,sp,32
    80003b52:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003b54:	00020517          	auipc	a0,0x20
    80003b58:	0ac50513          	addi	a0,a0,172 # 80023c00 <itable>
    80003b5c:	872fd0ef          	jal	80000bce <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003b60:	4498                	lw	a4,8(s1)
    80003b62:	4785                	li	a5,1
    80003b64:	02f70063          	beq	a4,a5,80003b84 <iput+0x3c>
  ip->ref--;
    80003b68:	449c                	lw	a5,8(s1)
    80003b6a:	37fd                	addiw	a5,a5,-1
    80003b6c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003b6e:	00020517          	auipc	a0,0x20
    80003b72:	09250513          	addi	a0,a0,146 # 80023c00 <itable>
    80003b76:	8f0fd0ef          	jal	80000c66 <release>
}
    80003b7a:	60e2                	ld	ra,24(sp)
    80003b7c:	6442                	ld	s0,16(sp)
    80003b7e:	64a2                	ld	s1,8(sp)
    80003b80:	6105                	addi	sp,sp,32
    80003b82:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003b84:	40bc                	lw	a5,64(s1)
    80003b86:	d3ed                	beqz	a5,80003b68 <iput+0x20>
    80003b88:	04a49783          	lh	a5,74(s1)
    80003b8c:	fff1                	bnez	a5,80003b68 <iput+0x20>
    80003b8e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003b90:	01048913          	addi	s2,s1,16
    80003b94:	854a                	mv	a0,s2
    80003b96:	2d5000ef          	jal	8000466a <acquiresleep>
    release(&itable.lock);
    80003b9a:	00020517          	auipc	a0,0x20
    80003b9e:	06650513          	addi	a0,a0,102 # 80023c00 <itable>
    80003ba2:	8c4fd0ef          	jal	80000c66 <release>
    itrunc(ip);
    80003ba6:	8526                	mv	a0,s1
    80003ba8:	f0dff0ef          	jal	80003ab4 <itrunc>
    ip->type = 0;
    80003bac:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	d61ff0ef          	jal	80003912 <iupdate>
    ip->valid = 0;
    80003bb6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003bba:	854a                	mv	a0,s2
    80003bbc:	455000ef          	jal	80004810 <releasesleep>
    acquire(&itable.lock);
    80003bc0:	00020517          	auipc	a0,0x20
    80003bc4:	04050513          	addi	a0,a0,64 # 80023c00 <itable>
    80003bc8:	806fd0ef          	jal	80000bce <acquire>
    80003bcc:	6902                	ld	s2,0(sp)
    80003bce:	bf69                	j	80003b68 <iput+0x20>

0000000080003bd0 <iunlockput>:
{
    80003bd0:	1101                	addi	sp,sp,-32
    80003bd2:	ec06                	sd	ra,24(sp)
    80003bd4:	e822                	sd	s0,16(sp)
    80003bd6:	e426                	sd	s1,8(sp)
    80003bd8:	1000                	addi	s0,sp,32
    80003bda:	84aa                	mv	s1,a0
  iunlock(ip);
    80003bdc:	e99ff0ef          	jal	80003a74 <iunlock>
  iput(ip);
    80003be0:	8526                	mv	a0,s1
    80003be2:	f67ff0ef          	jal	80003b48 <iput>
}
    80003be6:	60e2                	ld	ra,24(sp)
    80003be8:	6442                	ld	s0,16(sp)
    80003bea:	64a2                	ld	s1,8(sp)
    80003bec:	6105                	addi	sp,sp,32
    80003bee:	8082                	ret

0000000080003bf0 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003bf0:	00020717          	auipc	a4,0x20
    80003bf4:	ffc72703          	lw	a4,-4(a4) # 80023bec <sb+0xc>
    80003bf8:	4785                	li	a5,1
    80003bfa:	0ae7ff63          	bgeu	a5,a4,80003cb8 <ireclaim+0xc8>
{
    80003bfe:	7139                	addi	sp,sp,-64
    80003c00:	fc06                	sd	ra,56(sp)
    80003c02:	f822                	sd	s0,48(sp)
    80003c04:	f426                	sd	s1,40(sp)
    80003c06:	f04a                	sd	s2,32(sp)
    80003c08:	ec4e                	sd	s3,24(sp)
    80003c0a:	e852                	sd	s4,16(sp)
    80003c0c:	e456                	sd	s5,8(sp)
    80003c0e:	e05a                	sd	s6,0(sp)
    80003c10:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003c12:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003c14:	00050a1b          	sext.w	s4,a0
    80003c18:	00020a97          	auipc	s5,0x20
    80003c1c:	fc8a8a93          	addi	s5,s5,-56 # 80023be0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003c20:	00005b17          	auipc	s6,0x5
    80003c24:	a30b0b13          	addi	s6,s6,-1488 # 80008650 <etext+0x650>
    80003c28:	a099                	j	80003c6e <ireclaim+0x7e>
    80003c2a:	85ce                	mv	a1,s3
    80003c2c:	855a                	mv	a0,s6
    80003c2e:	8cdfc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003c32:	85ce                	mv	a1,s3
    80003c34:	8552                	mv	a0,s4
    80003c36:	b1dff0ef          	jal	80003752 <iget>
    80003c3a:	89aa                	mv	s3,a0
    brelse(bp);
    80003c3c:	854a                	mv	a0,s2
    80003c3e:	fc4ff0ef          	jal	80003402 <brelse>
    if (ip) {
    80003c42:	00098f63          	beqz	s3,80003c60 <ireclaim+0x70>
      begin_op();
    80003c46:	76a000ef          	jal	800043b0 <begin_op>
      ilock(ip);
    80003c4a:	854e                	mv	a0,s3
    80003c4c:	d7bff0ef          	jal	800039c6 <ilock>
      iunlock(ip);
    80003c50:	854e                	mv	a0,s3
    80003c52:	e23ff0ef          	jal	80003a74 <iunlock>
      iput(ip);
    80003c56:	854e                	mv	a0,s3
    80003c58:	ef1ff0ef          	jal	80003b48 <iput>
      end_op();
    80003c5c:	7be000ef          	jal	8000441a <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003c60:	0485                	addi	s1,s1,1
    80003c62:	00caa703          	lw	a4,12(s5)
    80003c66:	0004879b          	sext.w	a5,s1
    80003c6a:	02e7fd63          	bgeu	a5,a4,80003ca4 <ireclaim+0xb4>
    80003c6e:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003c72:	0044d593          	srli	a1,s1,0x4
    80003c76:	018aa783          	lw	a5,24(s5)
    80003c7a:	9dbd                	addw	a1,a1,a5
    80003c7c:	8552                	mv	a0,s4
    80003c7e:	e7cff0ef          	jal	800032fa <bread>
    80003c82:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003c84:	05850793          	addi	a5,a0,88
    80003c88:	00f9f713          	andi	a4,s3,15
    80003c8c:	071a                	slli	a4,a4,0x6
    80003c8e:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003c90:	00079703          	lh	a4,0(a5)
    80003c94:	c701                	beqz	a4,80003c9c <ireclaim+0xac>
    80003c96:	00679783          	lh	a5,6(a5)
    80003c9a:	dbc1                	beqz	a5,80003c2a <ireclaim+0x3a>
    brelse(bp);
    80003c9c:	854a                	mv	a0,s2
    80003c9e:	f64ff0ef          	jal	80003402 <brelse>
    if (ip) {
    80003ca2:	bf7d                	j	80003c60 <ireclaim+0x70>
}
    80003ca4:	70e2                	ld	ra,56(sp)
    80003ca6:	7442                	ld	s0,48(sp)
    80003ca8:	74a2                	ld	s1,40(sp)
    80003caa:	7902                	ld	s2,32(sp)
    80003cac:	69e2                	ld	s3,24(sp)
    80003cae:	6a42                	ld	s4,16(sp)
    80003cb0:	6aa2                	ld	s5,8(sp)
    80003cb2:	6b02                	ld	s6,0(sp)
    80003cb4:	6121                	addi	sp,sp,64
    80003cb6:	8082                	ret
    80003cb8:	8082                	ret

0000000080003cba <fsinit>:
fsinit(int dev) {
    80003cba:	7179                	addi	sp,sp,-48
    80003cbc:	f406                	sd	ra,40(sp)
    80003cbe:	f022                	sd	s0,32(sp)
    80003cc0:	ec26                	sd	s1,24(sp)
    80003cc2:	e84a                	sd	s2,16(sp)
    80003cc4:	e44e                	sd	s3,8(sp)
    80003cc6:	1800                	addi	s0,sp,48
    80003cc8:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    80003cca:	4585                	li	a1,1
    80003ccc:	e2eff0ef          	jal	800032fa <bread>
    80003cd0:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003cd2:	00020997          	auipc	s3,0x20
    80003cd6:	f0e98993          	addi	s3,s3,-242 # 80023be0 <sb>
    80003cda:	02000613          	li	a2,32
    80003cde:	05850593          	addi	a1,a0,88
    80003ce2:	854e                	mv	a0,s3
    80003ce4:	81afd0ef          	jal	80000cfe <memmove>
  brelse(bp);
    80003ce8:	854a                	mv	a0,s2
    80003cea:	f18ff0ef          	jal	80003402 <brelse>
  if(sb.magic != FSMAGIC)
    80003cee:	0009a703          	lw	a4,0(s3)
    80003cf2:	102037b7          	lui	a5,0x10203
    80003cf6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003cfa:	02f71363          	bne	a4,a5,80003d20 <fsinit+0x66>
  initlog(dev, &sb);
    80003cfe:	00020597          	auipc	a1,0x20
    80003d02:	ee258593          	addi	a1,a1,-286 # 80023be0 <sb>
    80003d06:	8526                	mv	a0,s1
    80003d08:	62a000ef          	jal	80004332 <initlog>
  ireclaim(dev);
    80003d0c:	8526                	mv	a0,s1
    80003d0e:	ee3ff0ef          	jal	80003bf0 <ireclaim>
}
    80003d12:	70a2                	ld	ra,40(sp)
    80003d14:	7402                	ld	s0,32(sp)
    80003d16:	64e2                	ld	s1,24(sp)
    80003d18:	6942                	ld	s2,16(sp)
    80003d1a:	69a2                	ld	s3,8(sp)
    80003d1c:	6145                	addi	sp,sp,48
    80003d1e:	8082                	ret
    panic("invalid file system");
    80003d20:	00005517          	auipc	a0,0x5
    80003d24:	95050513          	addi	a0,a0,-1712 # 80008670 <etext+0x670>
    80003d28:	ab9fc0ef          	jal	800007e0 <panic>

0000000080003d2c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003d2c:	1141                	addi	sp,sp,-16
    80003d2e:	e422                	sd	s0,8(sp)
    80003d30:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003d32:	411c                	lw	a5,0(a0)
    80003d34:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003d36:	415c                	lw	a5,4(a0)
    80003d38:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003d3a:	04451783          	lh	a5,68(a0)
    80003d3e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003d42:	04a51783          	lh	a5,74(a0)
    80003d46:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003d4a:	04c56783          	lwu	a5,76(a0)
    80003d4e:	e99c                	sd	a5,16(a1)
}
    80003d50:	6422                	ld	s0,8(sp)
    80003d52:	0141                	addi	sp,sp,16
    80003d54:	8082                	ret

0000000080003d56 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d56:	457c                	lw	a5,76(a0)
    80003d58:	0ed7eb63          	bltu	a5,a3,80003e4e <readi+0xf8>
{
    80003d5c:	7159                	addi	sp,sp,-112
    80003d5e:	f486                	sd	ra,104(sp)
    80003d60:	f0a2                	sd	s0,96(sp)
    80003d62:	eca6                	sd	s1,88(sp)
    80003d64:	e0d2                	sd	s4,64(sp)
    80003d66:	fc56                	sd	s5,56(sp)
    80003d68:	f85a                	sd	s6,48(sp)
    80003d6a:	f45e                	sd	s7,40(sp)
    80003d6c:	1880                	addi	s0,sp,112
    80003d6e:	8b2a                	mv	s6,a0
    80003d70:	8bae                	mv	s7,a1
    80003d72:	8a32                	mv	s4,a2
    80003d74:	84b6                	mv	s1,a3
    80003d76:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003d78:	9f35                	addw	a4,a4,a3
    return 0;
    80003d7a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003d7c:	0cd76063          	bltu	a4,a3,80003e3c <readi+0xe6>
    80003d80:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003d82:	00e7f463          	bgeu	a5,a4,80003d8a <readi+0x34>
    n = ip->size - off;
    80003d86:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d8a:	080a8f63          	beqz	s5,80003e28 <readi+0xd2>
    80003d8e:	e8ca                	sd	s2,80(sp)
    80003d90:	f062                	sd	s8,32(sp)
    80003d92:	ec66                	sd	s9,24(sp)
    80003d94:	e86a                	sd	s10,16(sp)
    80003d96:	e46e                	sd	s11,8(sp)
    80003d98:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d9a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003d9e:	5c7d                	li	s8,-1
    80003da0:	a80d                	j	80003dd2 <readi+0x7c>
    80003da2:	020d1d93          	slli	s11,s10,0x20
    80003da6:	020ddd93          	srli	s11,s11,0x20
    80003daa:	05890613          	addi	a2,s2,88
    80003dae:	86ee                	mv	a3,s11
    80003db0:	963a                	add	a2,a2,a4
    80003db2:	85d2                	mv	a1,s4
    80003db4:	855e                	mv	a0,s7
    80003db6:	e08fe0ef          	jal	800023be <either_copyout>
    80003dba:	05850763          	beq	a0,s8,80003e08 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003dbe:	854a                	mv	a0,s2
    80003dc0:	e42ff0ef          	jal	80003402 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003dc4:	013d09bb          	addw	s3,s10,s3
    80003dc8:	009d04bb          	addw	s1,s10,s1
    80003dcc:	9a6e                	add	s4,s4,s11
    80003dce:	0559f763          	bgeu	s3,s5,80003e1c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003dd2:	00a4d59b          	srliw	a1,s1,0xa
    80003dd6:	855a                	mv	a0,s6
    80003dd8:	8a7ff0ef          	jal	8000367e <bmap>
    80003ddc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003de0:	c5b1                	beqz	a1,80003e2c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003de2:	000b2503          	lw	a0,0(s6)
    80003de6:	d14ff0ef          	jal	800032fa <bread>
    80003dea:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003dec:	3ff4f713          	andi	a4,s1,1023
    80003df0:	40ec87bb          	subw	a5,s9,a4
    80003df4:	413a86bb          	subw	a3,s5,s3
    80003df8:	8d3e                	mv	s10,a5
    80003dfa:	2781                	sext.w	a5,a5
    80003dfc:	0006861b          	sext.w	a2,a3
    80003e00:	faf671e3          	bgeu	a2,a5,80003da2 <readi+0x4c>
    80003e04:	8d36                	mv	s10,a3
    80003e06:	bf71                	j	80003da2 <readi+0x4c>
      brelse(bp);
    80003e08:	854a                	mv	a0,s2
    80003e0a:	df8ff0ef          	jal	80003402 <brelse>
      tot = -1;
    80003e0e:	59fd                	li	s3,-1
      break;
    80003e10:	6946                	ld	s2,80(sp)
    80003e12:	7c02                	ld	s8,32(sp)
    80003e14:	6ce2                	ld	s9,24(sp)
    80003e16:	6d42                	ld	s10,16(sp)
    80003e18:	6da2                	ld	s11,8(sp)
    80003e1a:	a831                	j	80003e36 <readi+0xe0>
    80003e1c:	6946                	ld	s2,80(sp)
    80003e1e:	7c02                	ld	s8,32(sp)
    80003e20:	6ce2                	ld	s9,24(sp)
    80003e22:	6d42                	ld	s10,16(sp)
    80003e24:	6da2                	ld	s11,8(sp)
    80003e26:	a801                	j	80003e36 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e28:	89d6                	mv	s3,s5
    80003e2a:	a031                	j	80003e36 <readi+0xe0>
    80003e2c:	6946                	ld	s2,80(sp)
    80003e2e:	7c02                	ld	s8,32(sp)
    80003e30:	6ce2                	ld	s9,24(sp)
    80003e32:	6d42                	ld	s10,16(sp)
    80003e34:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003e36:	0009851b          	sext.w	a0,s3
    80003e3a:	69a6                	ld	s3,72(sp)
}
    80003e3c:	70a6                	ld	ra,104(sp)
    80003e3e:	7406                	ld	s0,96(sp)
    80003e40:	64e6                	ld	s1,88(sp)
    80003e42:	6a06                	ld	s4,64(sp)
    80003e44:	7ae2                	ld	s5,56(sp)
    80003e46:	7b42                	ld	s6,48(sp)
    80003e48:	7ba2                	ld	s7,40(sp)
    80003e4a:	6165                	addi	sp,sp,112
    80003e4c:	8082                	ret
    return 0;
    80003e4e:	4501                	li	a0,0
}
    80003e50:	8082                	ret

0000000080003e52 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e52:	457c                	lw	a5,76(a0)
    80003e54:	10d7e063          	bltu	a5,a3,80003f54 <writei+0x102>
{
    80003e58:	7159                	addi	sp,sp,-112
    80003e5a:	f486                	sd	ra,104(sp)
    80003e5c:	f0a2                	sd	s0,96(sp)
    80003e5e:	e8ca                	sd	s2,80(sp)
    80003e60:	e0d2                	sd	s4,64(sp)
    80003e62:	fc56                	sd	s5,56(sp)
    80003e64:	f85a                	sd	s6,48(sp)
    80003e66:	f45e                	sd	s7,40(sp)
    80003e68:	1880                	addi	s0,sp,112
    80003e6a:	8aaa                	mv	s5,a0
    80003e6c:	8bae                	mv	s7,a1
    80003e6e:	8a32                	mv	s4,a2
    80003e70:	8936                	mv	s2,a3
    80003e72:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003e74:	00e687bb          	addw	a5,a3,a4
    80003e78:	0ed7e063          	bltu	a5,a3,80003f58 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003e7c:	00043737          	lui	a4,0x43
    80003e80:	0cf76e63          	bltu	a4,a5,80003f5c <writei+0x10a>
    80003e84:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e86:	0a0b0f63          	beqz	s6,80003f44 <writei+0xf2>
    80003e8a:	eca6                	sd	s1,88(sp)
    80003e8c:	f062                	sd	s8,32(sp)
    80003e8e:	ec66                	sd	s9,24(sp)
    80003e90:	e86a                	sd	s10,16(sp)
    80003e92:	e46e                	sd	s11,8(sp)
    80003e94:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e96:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003e9a:	5c7d                	li	s8,-1
    80003e9c:	a825                	j	80003ed4 <writei+0x82>
    80003e9e:	020d1d93          	slli	s11,s10,0x20
    80003ea2:	020ddd93          	srli	s11,s11,0x20
    80003ea6:	05848513          	addi	a0,s1,88
    80003eaa:	86ee                	mv	a3,s11
    80003eac:	8652                	mv	a2,s4
    80003eae:	85de                	mv	a1,s7
    80003eb0:	953a                	add	a0,a0,a4
    80003eb2:	d56fe0ef          	jal	80002408 <either_copyin>
    80003eb6:	05850a63          	beq	a0,s8,80003f0a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003eba:	8526                	mv	a0,s1
    80003ebc:	678000ef          	jal	80004534 <log_write>
    brelse(bp);
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	d40ff0ef          	jal	80003402 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ec6:	013d09bb          	addw	s3,s10,s3
    80003eca:	012d093b          	addw	s2,s10,s2
    80003ece:	9a6e                	add	s4,s4,s11
    80003ed0:	0569f063          	bgeu	s3,s6,80003f10 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003ed4:	00a9559b          	srliw	a1,s2,0xa
    80003ed8:	8556                	mv	a0,s5
    80003eda:	fa4ff0ef          	jal	8000367e <bmap>
    80003ede:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003ee2:	c59d                	beqz	a1,80003f10 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003ee4:	000aa503          	lw	a0,0(s5)
    80003ee8:	c12ff0ef          	jal	800032fa <bread>
    80003eec:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003eee:	3ff97713          	andi	a4,s2,1023
    80003ef2:	40ec87bb          	subw	a5,s9,a4
    80003ef6:	413b06bb          	subw	a3,s6,s3
    80003efa:	8d3e                	mv	s10,a5
    80003efc:	2781                	sext.w	a5,a5
    80003efe:	0006861b          	sext.w	a2,a3
    80003f02:	f8f67ee3          	bgeu	a2,a5,80003e9e <writei+0x4c>
    80003f06:	8d36                	mv	s10,a3
    80003f08:	bf59                	j	80003e9e <writei+0x4c>
      brelse(bp);
    80003f0a:	8526                	mv	a0,s1
    80003f0c:	cf6ff0ef          	jal	80003402 <brelse>
  }

  if(off > ip->size)
    80003f10:	04caa783          	lw	a5,76(s5)
    80003f14:	0327fa63          	bgeu	a5,s2,80003f48 <writei+0xf6>
    ip->size = off;
    80003f18:	052aa623          	sw	s2,76(s5)
    80003f1c:	64e6                	ld	s1,88(sp)
    80003f1e:	7c02                	ld	s8,32(sp)
    80003f20:	6ce2                	ld	s9,24(sp)
    80003f22:	6d42                	ld	s10,16(sp)
    80003f24:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003f26:	8556                	mv	a0,s5
    80003f28:	9ebff0ef          	jal	80003912 <iupdate>

  return tot;
    80003f2c:	0009851b          	sext.w	a0,s3
    80003f30:	69a6                	ld	s3,72(sp)
}
    80003f32:	70a6                	ld	ra,104(sp)
    80003f34:	7406                	ld	s0,96(sp)
    80003f36:	6946                	ld	s2,80(sp)
    80003f38:	6a06                	ld	s4,64(sp)
    80003f3a:	7ae2                	ld	s5,56(sp)
    80003f3c:	7b42                	ld	s6,48(sp)
    80003f3e:	7ba2                	ld	s7,40(sp)
    80003f40:	6165                	addi	sp,sp,112
    80003f42:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f44:	89da                	mv	s3,s6
    80003f46:	b7c5                	j	80003f26 <writei+0xd4>
    80003f48:	64e6                	ld	s1,88(sp)
    80003f4a:	7c02                	ld	s8,32(sp)
    80003f4c:	6ce2                	ld	s9,24(sp)
    80003f4e:	6d42                	ld	s10,16(sp)
    80003f50:	6da2                	ld	s11,8(sp)
    80003f52:	bfd1                	j	80003f26 <writei+0xd4>
    return -1;
    80003f54:	557d                	li	a0,-1
}
    80003f56:	8082                	ret
    return -1;
    80003f58:	557d                	li	a0,-1
    80003f5a:	bfe1                	j	80003f32 <writei+0xe0>
    return -1;
    80003f5c:	557d                	li	a0,-1
    80003f5e:	bfd1                	j	80003f32 <writei+0xe0>

0000000080003f60 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003f60:	1141                	addi	sp,sp,-16
    80003f62:	e406                	sd	ra,8(sp)
    80003f64:	e022                	sd	s0,0(sp)
    80003f66:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003f68:	4639                	li	a2,14
    80003f6a:	e05fc0ef          	jal	80000d6e <strncmp>
}
    80003f6e:	60a2                	ld	ra,8(sp)
    80003f70:	6402                	ld	s0,0(sp)
    80003f72:	0141                	addi	sp,sp,16
    80003f74:	8082                	ret

0000000080003f76 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003f76:	7139                	addi	sp,sp,-64
    80003f78:	fc06                	sd	ra,56(sp)
    80003f7a:	f822                	sd	s0,48(sp)
    80003f7c:	f426                	sd	s1,40(sp)
    80003f7e:	f04a                	sd	s2,32(sp)
    80003f80:	ec4e                	sd	s3,24(sp)
    80003f82:	e852                	sd	s4,16(sp)
    80003f84:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003f86:	04451703          	lh	a4,68(a0)
    80003f8a:	4785                	li	a5,1
    80003f8c:	00f71a63          	bne	a4,a5,80003fa0 <dirlookup+0x2a>
    80003f90:	892a                	mv	s2,a0
    80003f92:	89ae                	mv	s3,a1
    80003f94:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f96:	457c                	lw	a5,76(a0)
    80003f98:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003f9a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f9c:	e39d                	bnez	a5,80003fc2 <dirlookup+0x4c>
    80003f9e:	a095                	j	80004002 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003fa0:	00004517          	auipc	a0,0x4
    80003fa4:	6e850513          	addi	a0,a0,1768 # 80008688 <etext+0x688>
    80003fa8:	839fc0ef          	jal	800007e0 <panic>
      panic("dirlookup read");
    80003fac:	00004517          	auipc	a0,0x4
    80003fb0:	6f450513          	addi	a0,a0,1780 # 800086a0 <etext+0x6a0>
    80003fb4:	82dfc0ef          	jal	800007e0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fb8:	24c1                	addiw	s1,s1,16
    80003fba:	04c92783          	lw	a5,76(s2)
    80003fbe:	04f4f163          	bgeu	s1,a5,80004000 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fc2:	4741                	li	a4,16
    80003fc4:	86a6                	mv	a3,s1
    80003fc6:	fc040613          	addi	a2,s0,-64
    80003fca:	4581                	li	a1,0
    80003fcc:	854a                	mv	a0,s2
    80003fce:	d89ff0ef          	jal	80003d56 <readi>
    80003fd2:	47c1                	li	a5,16
    80003fd4:	fcf51ce3          	bne	a0,a5,80003fac <dirlookup+0x36>
    if(de.inum == 0)
    80003fd8:	fc045783          	lhu	a5,-64(s0)
    80003fdc:	dff1                	beqz	a5,80003fb8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003fde:	fc240593          	addi	a1,s0,-62
    80003fe2:	854e                	mv	a0,s3
    80003fe4:	f7dff0ef          	jal	80003f60 <namecmp>
    80003fe8:	f961                	bnez	a0,80003fb8 <dirlookup+0x42>
      if(poff)
    80003fea:	000a0463          	beqz	s4,80003ff2 <dirlookup+0x7c>
        *poff = off;
    80003fee:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003ff2:	fc045583          	lhu	a1,-64(s0)
    80003ff6:	00092503          	lw	a0,0(s2)
    80003ffa:	f58ff0ef          	jal	80003752 <iget>
    80003ffe:	a011                	j	80004002 <dirlookup+0x8c>
  return 0;
    80004000:	4501                	li	a0,0
}
    80004002:	70e2                	ld	ra,56(sp)
    80004004:	7442                	ld	s0,48(sp)
    80004006:	74a2                	ld	s1,40(sp)
    80004008:	7902                	ld	s2,32(sp)
    8000400a:	69e2                	ld	s3,24(sp)
    8000400c:	6a42                	ld	s4,16(sp)
    8000400e:	6121                	addi	sp,sp,64
    80004010:	8082                	ret

0000000080004012 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004012:	711d                	addi	sp,sp,-96
    80004014:	ec86                	sd	ra,88(sp)
    80004016:	e8a2                	sd	s0,80(sp)
    80004018:	e4a6                	sd	s1,72(sp)
    8000401a:	e0ca                	sd	s2,64(sp)
    8000401c:	fc4e                	sd	s3,56(sp)
    8000401e:	f852                	sd	s4,48(sp)
    80004020:	f456                	sd	s5,40(sp)
    80004022:	f05a                	sd	s6,32(sp)
    80004024:	ec5e                	sd	s7,24(sp)
    80004026:	e862                	sd	s8,16(sp)
    80004028:	e466                	sd	s9,8(sp)
    8000402a:	1080                	addi	s0,sp,96
    8000402c:	84aa                	mv	s1,a0
    8000402e:	8b2e                	mv	s6,a1
    80004030:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004032:	00054703          	lbu	a4,0(a0)
    80004036:	02f00793          	li	a5,47
    8000403a:	00f70e63          	beq	a4,a5,80004056 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000403e:	891fd0ef          	jal	800018ce <myproc>
    80004042:	15053503          	ld	a0,336(a0)
    80004046:	94bff0ef          	jal	80003990 <idup>
    8000404a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000404c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004050:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004052:	4b85                	li	s7,1
    80004054:	a871                	j	800040f0 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80004056:	4585                	li	a1,1
    80004058:	4505                	li	a0,1
    8000405a:	ef8ff0ef          	jal	80003752 <iget>
    8000405e:	8a2a                	mv	s4,a0
    80004060:	b7f5                	j	8000404c <namex+0x3a>
      iunlockput(ip);
    80004062:	8552                	mv	a0,s4
    80004064:	b6dff0ef          	jal	80003bd0 <iunlockput>
      return 0;
    80004068:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000406a:	8552                	mv	a0,s4
    8000406c:	60e6                	ld	ra,88(sp)
    8000406e:	6446                	ld	s0,80(sp)
    80004070:	64a6                	ld	s1,72(sp)
    80004072:	6906                	ld	s2,64(sp)
    80004074:	79e2                	ld	s3,56(sp)
    80004076:	7a42                	ld	s4,48(sp)
    80004078:	7aa2                	ld	s5,40(sp)
    8000407a:	7b02                	ld	s6,32(sp)
    8000407c:	6be2                	ld	s7,24(sp)
    8000407e:	6c42                	ld	s8,16(sp)
    80004080:	6ca2                	ld	s9,8(sp)
    80004082:	6125                	addi	sp,sp,96
    80004084:	8082                	ret
      iunlock(ip);
    80004086:	8552                	mv	a0,s4
    80004088:	9edff0ef          	jal	80003a74 <iunlock>
      return ip;
    8000408c:	bff9                	j	8000406a <namex+0x58>
      iunlockput(ip);
    8000408e:	8552                	mv	a0,s4
    80004090:	b41ff0ef          	jal	80003bd0 <iunlockput>
      return 0;
    80004094:	8a4e                	mv	s4,s3
    80004096:	bfd1                	j	8000406a <namex+0x58>
  len = path - s;
    80004098:	40998633          	sub	a2,s3,s1
    8000409c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800040a0:	099c5063          	bge	s8,s9,80004120 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800040a4:	4639                	li	a2,14
    800040a6:	85a6                	mv	a1,s1
    800040a8:	8556                	mv	a0,s5
    800040aa:	c55fc0ef          	jal	80000cfe <memmove>
    800040ae:	84ce                	mv	s1,s3
  while(*path == '/')
    800040b0:	0004c783          	lbu	a5,0(s1)
    800040b4:	01279763          	bne	a5,s2,800040c2 <namex+0xb0>
    path++;
    800040b8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800040ba:	0004c783          	lbu	a5,0(s1)
    800040be:	ff278de3          	beq	a5,s2,800040b8 <namex+0xa6>
    ilock(ip);
    800040c2:	8552                	mv	a0,s4
    800040c4:	903ff0ef          	jal	800039c6 <ilock>
    if(ip->type != T_DIR){
    800040c8:	044a1783          	lh	a5,68(s4)
    800040cc:	f9779be3          	bne	a5,s7,80004062 <namex+0x50>
    if(nameiparent && *path == '\0'){
    800040d0:	000b0563          	beqz	s6,800040da <namex+0xc8>
    800040d4:	0004c783          	lbu	a5,0(s1)
    800040d8:	d7dd                	beqz	a5,80004086 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800040da:	4601                	li	a2,0
    800040dc:	85d6                	mv	a1,s5
    800040de:	8552                	mv	a0,s4
    800040e0:	e97ff0ef          	jal	80003f76 <dirlookup>
    800040e4:	89aa                	mv	s3,a0
    800040e6:	d545                	beqz	a0,8000408e <namex+0x7c>
    iunlockput(ip);
    800040e8:	8552                	mv	a0,s4
    800040ea:	ae7ff0ef          	jal	80003bd0 <iunlockput>
    ip = next;
    800040ee:	8a4e                	mv	s4,s3
  while(*path == '/')
    800040f0:	0004c783          	lbu	a5,0(s1)
    800040f4:	01279763          	bne	a5,s2,80004102 <namex+0xf0>
    path++;
    800040f8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800040fa:	0004c783          	lbu	a5,0(s1)
    800040fe:	ff278de3          	beq	a5,s2,800040f8 <namex+0xe6>
  if(*path == 0)
    80004102:	cb8d                	beqz	a5,80004134 <namex+0x122>
  while(*path != '/' && *path != 0)
    80004104:	0004c783          	lbu	a5,0(s1)
    80004108:	89a6                	mv	s3,s1
  len = path - s;
    8000410a:	4c81                	li	s9,0
    8000410c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000410e:	01278963          	beq	a5,s2,80004120 <namex+0x10e>
    80004112:	d3d9                	beqz	a5,80004098 <namex+0x86>
    path++;
    80004114:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004116:	0009c783          	lbu	a5,0(s3)
    8000411a:	ff279ce3          	bne	a5,s2,80004112 <namex+0x100>
    8000411e:	bfad                	j	80004098 <namex+0x86>
    memmove(name, s, len);
    80004120:	2601                	sext.w	a2,a2
    80004122:	85a6                	mv	a1,s1
    80004124:	8556                	mv	a0,s5
    80004126:	bd9fc0ef          	jal	80000cfe <memmove>
    name[len] = 0;
    8000412a:	9cd6                	add	s9,s9,s5
    8000412c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004130:	84ce                	mv	s1,s3
    80004132:	bfbd                	j	800040b0 <namex+0x9e>
  if(nameiparent){
    80004134:	f20b0be3          	beqz	s6,8000406a <namex+0x58>
    iput(ip);
    80004138:	8552                	mv	a0,s4
    8000413a:	a0fff0ef          	jal	80003b48 <iput>
    return 0;
    8000413e:	4a01                	li	s4,0
    80004140:	b72d                	j	8000406a <namex+0x58>

0000000080004142 <dirlink>:
{
    80004142:	7139                	addi	sp,sp,-64
    80004144:	fc06                	sd	ra,56(sp)
    80004146:	f822                	sd	s0,48(sp)
    80004148:	f04a                	sd	s2,32(sp)
    8000414a:	ec4e                	sd	s3,24(sp)
    8000414c:	e852                	sd	s4,16(sp)
    8000414e:	0080                	addi	s0,sp,64
    80004150:	892a                	mv	s2,a0
    80004152:	8a2e                	mv	s4,a1
    80004154:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004156:	4601                	li	a2,0
    80004158:	e1fff0ef          	jal	80003f76 <dirlookup>
    8000415c:	e535                	bnez	a0,800041c8 <dirlink+0x86>
    8000415e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004160:	04c92483          	lw	s1,76(s2)
    80004164:	c48d                	beqz	s1,8000418e <dirlink+0x4c>
    80004166:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004168:	4741                	li	a4,16
    8000416a:	86a6                	mv	a3,s1
    8000416c:	fc040613          	addi	a2,s0,-64
    80004170:	4581                	li	a1,0
    80004172:	854a                	mv	a0,s2
    80004174:	be3ff0ef          	jal	80003d56 <readi>
    80004178:	47c1                	li	a5,16
    8000417a:	04f51b63          	bne	a0,a5,800041d0 <dirlink+0x8e>
    if(de.inum == 0)
    8000417e:	fc045783          	lhu	a5,-64(s0)
    80004182:	c791                	beqz	a5,8000418e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004184:	24c1                	addiw	s1,s1,16
    80004186:	04c92783          	lw	a5,76(s2)
    8000418a:	fcf4efe3          	bltu	s1,a5,80004168 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000418e:	4639                	li	a2,14
    80004190:	85d2                	mv	a1,s4
    80004192:	fc240513          	addi	a0,s0,-62
    80004196:	c0ffc0ef          	jal	80000da4 <strncpy>
  de.inum = inum;
    8000419a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000419e:	4741                	li	a4,16
    800041a0:	86a6                	mv	a3,s1
    800041a2:	fc040613          	addi	a2,s0,-64
    800041a6:	4581                	li	a1,0
    800041a8:	854a                	mv	a0,s2
    800041aa:	ca9ff0ef          	jal	80003e52 <writei>
    800041ae:	1541                	addi	a0,a0,-16
    800041b0:	00a03533          	snez	a0,a0
    800041b4:	40a00533          	neg	a0,a0
    800041b8:	74a2                	ld	s1,40(sp)
}
    800041ba:	70e2                	ld	ra,56(sp)
    800041bc:	7442                	ld	s0,48(sp)
    800041be:	7902                	ld	s2,32(sp)
    800041c0:	69e2                	ld	s3,24(sp)
    800041c2:	6a42                	ld	s4,16(sp)
    800041c4:	6121                	addi	sp,sp,64
    800041c6:	8082                	ret
    iput(ip);
    800041c8:	981ff0ef          	jal	80003b48 <iput>
    return -1;
    800041cc:	557d                	li	a0,-1
    800041ce:	b7f5                	j	800041ba <dirlink+0x78>
      panic("dirlink read");
    800041d0:	00004517          	auipc	a0,0x4
    800041d4:	4e050513          	addi	a0,a0,1248 # 800086b0 <etext+0x6b0>
    800041d8:	e08fc0ef          	jal	800007e0 <panic>

00000000800041dc <namei>:

struct inode*
namei(char *path)
{
    800041dc:	1101                	addi	sp,sp,-32
    800041de:	ec06                	sd	ra,24(sp)
    800041e0:	e822                	sd	s0,16(sp)
    800041e2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800041e4:	fe040613          	addi	a2,s0,-32
    800041e8:	4581                	li	a1,0
    800041ea:	e29ff0ef          	jal	80004012 <namex>
}
    800041ee:	60e2                	ld	ra,24(sp)
    800041f0:	6442                	ld	s0,16(sp)
    800041f2:	6105                	addi	sp,sp,32
    800041f4:	8082                	ret

00000000800041f6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800041f6:	1141                	addi	sp,sp,-16
    800041f8:	e406                	sd	ra,8(sp)
    800041fa:	e022                	sd	s0,0(sp)
    800041fc:	0800                	addi	s0,sp,16
    800041fe:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004200:	4585                	li	a1,1
    80004202:	e11ff0ef          	jal	80004012 <namex>
}
    80004206:	60a2                	ld	ra,8(sp)
    80004208:	6402                	ld	s0,0(sp)
    8000420a:	0141                	addi	sp,sp,16
    8000420c:	8082                	ret

000000008000420e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000420e:	1101                	addi	sp,sp,-32
    80004210:	ec06                	sd	ra,24(sp)
    80004212:	e822                	sd	s0,16(sp)
    80004214:	e426                	sd	s1,8(sp)
    80004216:	e04a                	sd	s2,0(sp)
    80004218:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000421a:	00021917          	auipc	s2,0x21
    8000421e:	48e90913          	addi	s2,s2,1166 # 800256a8 <log>
    80004222:	01892583          	lw	a1,24(s2)
    80004226:	02492503          	lw	a0,36(s2)
    8000422a:	8d0ff0ef          	jal	800032fa <bread>
    8000422e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004230:	02892603          	lw	a2,40(s2)
    80004234:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004236:	00c05f63          	blez	a2,80004254 <write_head+0x46>
    8000423a:	00021717          	auipc	a4,0x21
    8000423e:	49a70713          	addi	a4,a4,1178 # 800256d4 <log+0x2c>
    80004242:	87aa                	mv	a5,a0
    80004244:	060a                	slli	a2,a2,0x2
    80004246:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004248:	4314                	lw	a3,0(a4)
    8000424a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000424c:	0711                	addi	a4,a4,4
    8000424e:	0791                	addi	a5,a5,4
    80004250:	fec79ce3          	bne	a5,a2,80004248 <write_head+0x3a>
  }
  bwrite(buf);
    80004254:	8526                	mv	a0,s1
    80004256:	97aff0ef          	jal	800033d0 <bwrite>
  brelse(buf);
    8000425a:	8526                	mv	a0,s1
    8000425c:	9a6ff0ef          	jal	80003402 <brelse>
}
    80004260:	60e2                	ld	ra,24(sp)
    80004262:	6442                	ld	s0,16(sp)
    80004264:	64a2                	ld	s1,8(sp)
    80004266:	6902                	ld	s2,0(sp)
    80004268:	6105                	addi	sp,sp,32
    8000426a:	8082                	ret

000000008000426c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000426c:	00021797          	auipc	a5,0x21
    80004270:	4647a783          	lw	a5,1124(a5) # 800256d0 <log+0x28>
    80004274:	0af05e63          	blez	a5,80004330 <install_trans+0xc4>
{
    80004278:	715d                	addi	sp,sp,-80
    8000427a:	e486                	sd	ra,72(sp)
    8000427c:	e0a2                	sd	s0,64(sp)
    8000427e:	fc26                	sd	s1,56(sp)
    80004280:	f84a                	sd	s2,48(sp)
    80004282:	f44e                	sd	s3,40(sp)
    80004284:	f052                	sd	s4,32(sp)
    80004286:	ec56                	sd	s5,24(sp)
    80004288:	e85a                	sd	s6,16(sp)
    8000428a:	e45e                	sd	s7,8(sp)
    8000428c:	0880                	addi	s0,sp,80
    8000428e:	8b2a                	mv	s6,a0
    80004290:	00021a97          	auipc	s5,0x21
    80004294:	444a8a93          	addi	s5,s5,1092 # 800256d4 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004298:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000429a:	00004b97          	auipc	s7,0x4
    8000429e:	426b8b93          	addi	s7,s7,1062 # 800086c0 <etext+0x6c0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800042a2:	00021a17          	auipc	s4,0x21
    800042a6:	406a0a13          	addi	s4,s4,1030 # 800256a8 <log>
    800042aa:	a025                	j	800042d2 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800042ac:	000aa603          	lw	a2,0(s5)
    800042b0:	85ce                	mv	a1,s3
    800042b2:	855e                	mv	a0,s7
    800042b4:	a46fc0ef          	jal	800004fa <printf>
    800042b8:	a839                	j	800042d6 <install_trans+0x6a>
    brelse(lbuf);
    800042ba:	854a                	mv	a0,s2
    800042bc:	946ff0ef          	jal	80003402 <brelse>
    brelse(dbuf);
    800042c0:	8526                	mv	a0,s1
    800042c2:	940ff0ef          	jal	80003402 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042c6:	2985                	addiw	s3,s3,1
    800042c8:	0a91                	addi	s5,s5,4
    800042ca:	028a2783          	lw	a5,40(s4)
    800042ce:	04f9d663          	bge	s3,a5,8000431a <install_trans+0xae>
    if(recovering) {
    800042d2:	fc0b1de3          	bnez	s6,800042ac <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800042d6:	018a2583          	lw	a1,24(s4)
    800042da:	013585bb          	addw	a1,a1,s3
    800042de:	2585                	addiw	a1,a1,1
    800042e0:	024a2503          	lw	a0,36(s4)
    800042e4:	816ff0ef          	jal	800032fa <bread>
    800042e8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800042ea:	000aa583          	lw	a1,0(s5)
    800042ee:	024a2503          	lw	a0,36(s4)
    800042f2:	808ff0ef          	jal	800032fa <bread>
    800042f6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800042f8:	40000613          	li	a2,1024
    800042fc:	05890593          	addi	a1,s2,88
    80004300:	05850513          	addi	a0,a0,88
    80004304:	9fbfc0ef          	jal	80000cfe <memmove>
    bwrite(dbuf);  // write dst to disk
    80004308:	8526                	mv	a0,s1
    8000430a:	8c6ff0ef          	jal	800033d0 <bwrite>
    if(recovering == 0)
    8000430e:	fa0b16e3          	bnez	s6,800042ba <install_trans+0x4e>
      bunpin(dbuf);
    80004312:	8526                	mv	a0,s1
    80004314:	9aaff0ef          	jal	800034be <bunpin>
    80004318:	b74d                	j	800042ba <install_trans+0x4e>
}
    8000431a:	60a6                	ld	ra,72(sp)
    8000431c:	6406                	ld	s0,64(sp)
    8000431e:	74e2                	ld	s1,56(sp)
    80004320:	7942                	ld	s2,48(sp)
    80004322:	79a2                	ld	s3,40(sp)
    80004324:	7a02                	ld	s4,32(sp)
    80004326:	6ae2                	ld	s5,24(sp)
    80004328:	6b42                	ld	s6,16(sp)
    8000432a:	6ba2                	ld	s7,8(sp)
    8000432c:	6161                	addi	sp,sp,80
    8000432e:	8082                	ret
    80004330:	8082                	ret

0000000080004332 <initlog>:
{
    80004332:	7179                	addi	sp,sp,-48
    80004334:	f406                	sd	ra,40(sp)
    80004336:	f022                	sd	s0,32(sp)
    80004338:	ec26                	sd	s1,24(sp)
    8000433a:	e84a                	sd	s2,16(sp)
    8000433c:	e44e                	sd	s3,8(sp)
    8000433e:	1800                	addi	s0,sp,48
    80004340:	892a                	mv	s2,a0
    80004342:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004344:	00021497          	auipc	s1,0x21
    80004348:	36448493          	addi	s1,s1,868 # 800256a8 <log>
    8000434c:	00004597          	auipc	a1,0x4
    80004350:	39458593          	addi	a1,a1,916 # 800086e0 <etext+0x6e0>
    80004354:	8526                	mv	a0,s1
    80004356:	ff8fc0ef          	jal	80000b4e <initlock>
  log.start = sb->logstart;
    8000435a:	0149a583          	lw	a1,20(s3)
    8000435e:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80004360:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004364:	854a                	mv	a0,s2
    80004366:	f95fe0ef          	jal	800032fa <bread>
  log.lh.n = lh->n;
    8000436a:	4d30                	lw	a2,88(a0)
    8000436c:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000436e:	00c05f63          	blez	a2,8000438c <initlog+0x5a>
    80004372:	87aa                	mv	a5,a0
    80004374:	00021717          	auipc	a4,0x21
    80004378:	36070713          	addi	a4,a4,864 # 800256d4 <log+0x2c>
    8000437c:	060a                	slli	a2,a2,0x2
    8000437e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004380:	4ff4                	lw	a3,92(a5)
    80004382:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004384:	0791                	addi	a5,a5,4
    80004386:	0711                	addi	a4,a4,4
    80004388:	fec79ce3          	bne	a5,a2,80004380 <initlog+0x4e>
  brelse(buf);
    8000438c:	876ff0ef          	jal	80003402 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004390:	4505                	li	a0,1
    80004392:	edbff0ef          	jal	8000426c <install_trans>
  log.lh.n = 0;
    80004396:	00021797          	auipc	a5,0x21
    8000439a:	3207ad23          	sw	zero,826(a5) # 800256d0 <log+0x28>
  write_head(); // clear the log
    8000439e:	e71ff0ef          	jal	8000420e <write_head>
}
    800043a2:	70a2                	ld	ra,40(sp)
    800043a4:	7402                	ld	s0,32(sp)
    800043a6:	64e2                	ld	s1,24(sp)
    800043a8:	6942                	ld	s2,16(sp)
    800043aa:	69a2                	ld	s3,8(sp)
    800043ac:	6145                	addi	sp,sp,48
    800043ae:	8082                	ret

00000000800043b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800043b0:	1101                	addi	sp,sp,-32
    800043b2:	ec06                	sd	ra,24(sp)
    800043b4:	e822                	sd	s0,16(sp)
    800043b6:	e426                	sd	s1,8(sp)
    800043b8:	e04a                	sd	s2,0(sp)
    800043ba:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800043bc:	00021517          	auipc	a0,0x21
    800043c0:	2ec50513          	addi	a0,a0,748 # 800256a8 <log>
    800043c4:	80bfc0ef          	jal	80000bce <acquire>
  while(1){
    if(log.committing){
    800043c8:	00021497          	auipc	s1,0x21
    800043cc:	2e048493          	addi	s1,s1,736 # 800256a8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800043d0:	4979                	li	s2,30
    800043d2:	a029                	j	800043dc <begin_op+0x2c>
      sleep(&log, &log.lock);
    800043d4:	85a6                	mv	a1,s1
    800043d6:	8526                	mv	a0,s1
    800043d8:	c79fd0ef          	jal	80002050 <sleep>
    if(log.committing){
    800043dc:	509c                	lw	a5,32(s1)
    800043de:	fbfd                	bnez	a5,800043d4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800043e0:	4cd8                	lw	a4,28(s1)
    800043e2:	2705                	addiw	a4,a4,1
    800043e4:	0027179b          	slliw	a5,a4,0x2
    800043e8:	9fb9                	addw	a5,a5,a4
    800043ea:	0017979b          	slliw	a5,a5,0x1
    800043ee:	5494                	lw	a3,40(s1)
    800043f0:	9fb5                	addw	a5,a5,a3
    800043f2:	00f95763          	bge	s2,a5,80004400 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800043f6:	85a6                	mv	a1,s1
    800043f8:	8526                	mv	a0,s1
    800043fa:	c57fd0ef          	jal	80002050 <sleep>
    800043fe:	bff9                	j	800043dc <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80004400:	00021517          	auipc	a0,0x21
    80004404:	2a850513          	addi	a0,a0,680 # 800256a8 <log>
    80004408:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    8000440a:	85dfc0ef          	jal	80000c66 <release>
      break;
    }
  }
}
    8000440e:	60e2                	ld	ra,24(sp)
    80004410:	6442                	ld	s0,16(sp)
    80004412:	64a2                	ld	s1,8(sp)
    80004414:	6902                	ld	s2,0(sp)
    80004416:	6105                	addi	sp,sp,32
    80004418:	8082                	ret

000000008000441a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000441a:	7139                	addi	sp,sp,-64
    8000441c:	fc06                	sd	ra,56(sp)
    8000441e:	f822                	sd	s0,48(sp)
    80004420:	f426                	sd	s1,40(sp)
    80004422:	f04a                	sd	s2,32(sp)
    80004424:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004426:	00021497          	auipc	s1,0x21
    8000442a:	28248493          	addi	s1,s1,642 # 800256a8 <log>
    8000442e:	8526                	mv	a0,s1
    80004430:	f9efc0ef          	jal	80000bce <acquire>
  log.outstanding -= 1;
    80004434:	4cdc                	lw	a5,28(s1)
    80004436:	37fd                	addiw	a5,a5,-1
    80004438:	0007891b          	sext.w	s2,a5
    8000443c:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    8000443e:	509c                	lw	a5,32(s1)
    80004440:	ef9d                	bnez	a5,8000447e <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80004442:	04091763          	bnez	s2,80004490 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80004446:	00021497          	auipc	s1,0x21
    8000444a:	26248493          	addi	s1,s1,610 # 800256a8 <log>
    8000444e:	4785                	li	a5,1
    80004450:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004452:	8526                	mv	a0,s1
    80004454:	813fc0ef          	jal	80000c66 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004458:	549c                	lw	a5,40(s1)
    8000445a:	04f04b63          	bgtz	a5,800044b0 <end_op+0x96>
    acquire(&log.lock);
    8000445e:	00021497          	auipc	s1,0x21
    80004462:	24a48493          	addi	s1,s1,586 # 800256a8 <log>
    80004466:	8526                	mv	a0,s1
    80004468:	f66fc0ef          	jal	80000bce <acquire>
    log.committing = 0;
    8000446c:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80004470:	8526                	mv	a0,s1
    80004472:	c2bfd0ef          	jal	8000209c <wakeup>
    release(&log.lock);
    80004476:	8526                	mv	a0,s1
    80004478:	feefc0ef          	jal	80000c66 <release>
}
    8000447c:	a025                	j	800044a4 <end_op+0x8a>
    8000447e:	ec4e                	sd	s3,24(sp)
    80004480:	e852                	sd	s4,16(sp)
    80004482:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004484:	00004517          	auipc	a0,0x4
    80004488:	26450513          	addi	a0,a0,612 # 800086e8 <etext+0x6e8>
    8000448c:	b54fc0ef          	jal	800007e0 <panic>
    wakeup(&log);
    80004490:	00021497          	auipc	s1,0x21
    80004494:	21848493          	addi	s1,s1,536 # 800256a8 <log>
    80004498:	8526                	mv	a0,s1
    8000449a:	c03fd0ef          	jal	8000209c <wakeup>
  release(&log.lock);
    8000449e:	8526                	mv	a0,s1
    800044a0:	fc6fc0ef          	jal	80000c66 <release>
}
    800044a4:	70e2                	ld	ra,56(sp)
    800044a6:	7442                	ld	s0,48(sp)
    800044a8:	74a2                	ld	s1,40(sp)
    800044aa:	7902                	ld	s2,32(sp)
    800044ac:	6121                	addi	sp,sp,64
    800044ae:	8082                	ret
    800044b0:	ec4e                	sd	s3,24(sp)
    800044b2:	e852                	sd	s4,16(sp)
    800044b4:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800044b6:	00021a97          	auipc	s5,0x21
    800044ba:	21ea8a93          	addi	s5,s5,542 # 800256d4 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800044be:	00021a17          	auipc	s4,0x21
    800044c2:	1eaa0a13          	addi	s4,s4,490 # 800256a8 <log>
    800044c6:	018a2583          	lw	a1,24(s4)
    800044ca:	012585bb          	addw	a1,a1,s2
    800044ce:	2585                	addiw	a1,a1,1
    800044d0:	024a2503          	lw	a0,36(s4)
    800044d4:	e27fe0ef          	jal	800032fa <bread>
    800044d8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800044da:	000aa583          	lw	a1,0(s5)
    800044de:	024a2503          	lw	a0,36(s4)
    800044e2:	e19fe0ef          	jal	800032fa <bread>
    800044e6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800044e8:	40000613          	li	a2,1024
    800044ec:	05850593          	addi	a1,a0,88
    800044f0:	05848513          	addi	a0,s1,88
    800044f4:	80bfc0ef          	jal	80000cfe <memmove>
    bwrite(to);  // write the log
    800044f8:	8526                	mv	a0,s1
    800044fa:	ed7fe0ef          	jal	800033d0 <bwrite>
    brelse(from);
    800044fe:	854e                	mv	a0,s3
    80004500:	f03fe0ef          	jal	80003402 <brelse>
    brelse(to);
    80004504:	8526                	mv	a0,s1
    80004506:	efdfe0ef          	jal	80003402 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000450a:	2905                	addiw	s2,s2,1
    8000450c:	0a91                	addi	s5,s5,4
    8000450e:	028a2783          	lw	a5,40(s4)
    80004512:	faf94ae3          	blt	s2,a5,800044c6 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004516:	cf9ff0ef          	jal	8000420e <write_head>
    install_trans(0); // Now install writes to home locations
    8000451a:	4501                	li	a0,0
    8000451c:	d51ff0ef          	jal	8000426c <install_trans>
    log.lh.n = 0;
    80004520:	00021797          	auipc	a5,0x21
    80004524:	1a07a823          	sw	zero,432(a5) # 800256d0 <log+0x28>
    write_head();    // Erase the transaction from the log
    80004528:	ce7ff0ef          	jal	8000420e <write_head>
    8000452c:	69e2                	ld	s3,24(sp)
    8000452e:	6a42                	ld	s4,16(sp)
    80004530:	6aa2                	ld	s5,8(sp)
    80004532:	b735                	j	8000445e <end_op+0x44>

0000000080004534 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004534:	1101                	addi	sp,sp,-32
    80004536:	ec06                	sd	ra,24(sp)
    80004538:	e822                	sd	s0,16(sp)
    8000453a:	e426                	sd	s1,8(sp)
    8000453c:	e04a                	sd	s2,0(sp)
    8000453e:	1000                	addi	s0,sp,32
    80004540:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004542:	00021917          	auipc	s2,0x21
    80004546:	16690913          	addi	s2,s2,358 # 800256a8 <log>
    8000454a:	854a                	mv	a0,s2
    8000454c:	e82fc0ef          	jal	80000bce <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80004550:	02892603          	lw	a2,40(s2)
    80004554:	47f5                	li	a5,29
    80004556:	04c7cc63          	blt	a5,a2,800045ae <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000455a:	00021797          	auipc	a5,0x21
    8000455e:	16a7a783          	lw	a5,362(a5) # 800256c4 <log+0x1c>
    80004562:	04f05c63          	blez	a5,800045ba <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004566:	4781                	li	a5,0
    80004568:	04c05f63          	blez	a2,800045c6 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000456c:	44cc                	lw	a1,12(s1)
    8000456e:	00021717          	auipc	a4,0x21
    80004572:	16670713          	addi	a4,a4,358 # 800256d4 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80004576:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004578:	4314                	lw	a3,0(a4)
    8000457a:	04b68663          	beq	a3,a1,800045c6 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    8000457e:	2785                	addiw	a5,a5,1
    80004580:	0711                	addi	a4,a4,4
    80004582:	fef61be3          	bne	a2,a5,80004578 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004586:	0621                	addi	a2,a2,8
    80004588:	060a                	slli	a2,a2,0x2
    8000458a:	00021797          	auipc	a5,0x21
    8000458e:	11e78793          	addi	a5,a5,286 # 800256a8 <log>
    80004592:	97b2                	add	a5,a5,a2
    80004594:	44d8                	lw	a4,12(s1)
    80004596:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004598:	8526                	mv	a0,s1
    8000459a:	ef1fe0ef          	jal	8000348a <bpin>
    log.lh.n++;
    8000459e:	00021717          	auipc	a4,0x21
    800045a2:	10a70713          	addi	a4,a4,266 # 800256a8 <log>
    800045a6:	571c                	lw	a5,40(a4)
    800045a8:	2785                	addiw	a5,a5,1
    800045aa:	d71c                	sw	a5,40(a4)
    800045ac:	a80d                	j	800045de <log_write+0xaa>
    panic("too big a transaction");
    800045ae:	00004517          	auipc	a0,0x4
    800045b2:	14a50513          	addi	a0,a0,330 # 800086f8 <etext+0x6f8>
    800045b6:	a2afc0ef          	jal	800007e0 <panic>
    panic("log_write outside of trans");
    800045ba:	00004517          	auipc	a0,0x4
    800045be:	15650513          	addi	a0,a0,342 # 80008710 <etext+0x710>
    800045c2:	a1efc0ef          	jal	800007e0 <panic>
  log.lh.block[i] = b->blockno;
    800045c6:	00878693          	addi	a3,a5,8
    800045ca:	068a                	slli	a3,a3,0x2
    800045cc:	00021717          	auipc	a4,0x21
    800045d0:	0dc70713          	addi	a4,a4,220 # 800256a8 <log>
    800045d4:	9736                	add	a4,a4,a3
    800045d6:	44d4                	lw	a3,12(s1)
    800045d8:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800045da:	faf60fe3          	beq	a2,a5,80004598 <log_write+0x64>
  }
  release(&log.lock);
    800045de:	00021517          	auipc	a0,0x21
    800045e2:	0ca50513          	addi	a0,a0,202 # 800256a8 <log>
    800045e6:	e80fc0ef          	jal	80000c66 <release>
}
    800045ea:	60e2                	ld	ra,24(sp)
    800045ec:	6442                	ld	s0,16(sp)
    800045ee:	64a2                	ld	s1,8(sp)
    800045f0:	6902                	ld	s2,0(sp)
    800045f2:	6105                	addi	sp,sp,32
    800045f4:	8082                	ret

00000000800045f6 <pid2proc>:

extern struct proc proc[NPROC];

static struct proc*
pid2proc(int pid)
{
    800045f6:	1141                	addi	sp,sp,-16
    800045f8:	e422                	sd	s0,8(sp)
    800045fa:	0800                	addi	s0,sp,16
  struct proc *p;

  if(pid <= 0)
    800045fc:	02a05a63          	blez	a0,80004630 <pid2proc+0x3a>
    80004600:	872a                	mv	a4,a0
    return 0;

  for(p = proc; p < &proc[NPROC]; p++){
    80004602:	0000f517          	auipc	a0,0xf
    80004606:	6a650513          	addi	a0,a0,1702 # 80013ca8 <proc>
    8000460a:	00017697          	auipc	a3,0x17
    8000460e:	e9e68693          	addi	a3,a3,-354 # 8001b4a8 <tickslock>
    80004612:	a029                	j	8000461c <pid2proc+0x26>
    80004614:	1e050513          	addi	a0,a0,480
    80004618:	00d50a63          	beq	a0,a3,8000462c <pid2proc+0x36>
    if(p->pid == pid && p->state != UNUSED)
    8000461c:	591c                	lw	a5,48(a0)
    8000461e:	fee79be3          	bne	a5,a4,80004614 <pid2proc+0x1e>
    80004622:	4d1c                	lw	a5,24(a0)
    80004624:	dbe5                	beqz	a5,80004614 <pid2proc+0x1e>
      return p;
  }
  return 0;
}
    80004626:	6422                	ld	s0,8(sp)
    80004628:	0141                	addi	sp,sp,16
    8000462a:	8082                	ret
  return 0;
    8000462c:	4501                	li	a0,0
    8000462e:	bfe5                	j	80004626 <pid2proc+0x30>
    return 0;
    80004630:	4501                	li	a0,0
    80004632:	bfd5                	j	80004626 <pid2proc+0x30>

0000000080004634 <initsleeplock>:
  return -1;  // should not happen if a deadlock was truly detected
}

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004634:	1101                	addi	sp,sp,-32
    80004636:	ec06                	sd	ra,24(sp)
    80004638:	e822                	sd	s0,16(sp)
    8000463a:	e426                	sd	s1,8(sp)
    8000463c:	e04a                	sd	s2,0(sp)
    8000463e:	1000                	addi	s0,sp,32
    80004640:	84aa                	mv	s1,a0
    80004642:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004644:	00004597          	auipc	a1,0x4
    80004648:	0ec58593          	addi	a1,a1,236 # 80008730 <etext+0x730>
    8000464c:	0521                	addi	a0,a0,8
    8000464e:	d00fc0ef          	jal	80000b4e <initlock>
  lk->name = name;
    80004652:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004656:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000465a:	0204a423          	sw	zero,40(s1)
}
    8000465e:	60e2                	ld	ra,24(sp)
    80004660:	6442                	ld	s0,16(sp)
    80004662:	64a2                	ld	s1,8(sp)
    80004664:	6902                	ld	s2,0(sp)
    80004666:	6105                	addi	sp,sp,32
    80004668:	8082                	ret

000000008000466a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000466a:	7159                	addi	sp,sp,-112
    8000466c:	f486                	sd	ra,104(sp)
    8000466e:	f0a2                	sd	s0,96(sp)
    80004670:	eca6                	sd	s1,88(sp)
    80004672:	e0d2                	sd	s4,64(sp)
    80004674:	ec66                	sd	s9,24(sp)
    80004676:	1880                	addi	s0,sp,112
    80004678:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000467a:	a54fd0ef          	jal	800018ce <myproc>
    8000467e:	84aa                	mv	s1,a0

  acquire(&lk->lk);
    80004680:	008a0c93          	addi	s9,s4,8
    80004684:	8566                	mv	a0,s9
    80004686:	d48fc0ef          	jal	80000bce <acquire>
  while (lk->locked) {
    8000468a:	000a2783          	lw	a5,0(s4)
    8000468e:	10078963          	beqz	a5,800047a0 <acquiresleep+0x136>
    80004692:	e8ca                	sd	s2,80(sp)
    80004694:	e4ce                	sd	s3,72(sp)
    80004696:	fc56                	sd	s5,56(sp)
    80004698:	f85a                	sd	s6,48(sp)
    8000469a:	f45e                	sd	s7,40(sp)
    8000469c:	f062                	sd	s8,32(sp)
    8000469e:	e86a                	sd	s10,16(sp)
    800046a0:	e46e                	sd	s11,8(sp)
  while(owner_pid > 0 && hops < NPROC){
    800046a2:	04000c13          	li	s8,64
    p->waiting_for_lock = lk;
    if(would_create_deadlock(p, lk)){
      p->deadlock_reports++;
      printf("deadlock warning: pid %d waits for %s held by pid %d\n",
    800046a6:	00004d17          	auipc	s10,0x4
    800046aa:	0ead0d13          	addi	s10,s10,234 # 80008790 <etext+0x790>
  current_proc->in_deadlock = 1;
    800046ae:	4b05                	li	s6,1
    if(victim->state == SLEEPING){
    800046b0:	4d89                	li	s11,2
    800046b2:	a871                	j	8000474e <acquiresleep+0xe4>
    next_lock = owner->waiting_for_lock;
    800046b4:	18853783          	ld	a5,392(a0)
    if(next_lock == 0 || next_lock->locked == 0)
    800046b8:	c79d                	beqz	a5,800046e6 <acquiresleep+0x7c>
    800046ba:	4398                	lw	a4,0(a5)
    800046bc:	c70d                	beqz	a4,800046e6 <acquiresleep+0x7c>
    owner_pid = next_lock->pid;
    800046be:	5788                	lw	a0,40(a5)
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    800046c0:	02a05363          	blez	a0,800046e6 <acquiresleep+0x7c>
    800046c4:	02a98163          	beq	s3,a0,800046e6 <acquiresleep+0x7c>
    800046c8:	397d                	addiw	s2,s2,-1
    800046ca:	00090e63          	beqz	s2,800046e6 <acquiresleep+0x7c>
    struct proc *owner = pid2proc(owner_pid);
    800046ce:	f29ff0ef          	jal	800045f6 <pid2proc>
    if(owner == 0)
    800046d2:	c911                	beqz	a0,800046e6 <acquiresleep+0x7c>
    owner->in_deadlock = 1;
    800046d4:	19652c23          	sw	s6,408(a0)
    if(owner->energy_consumed > max_energy){
    800046d8:	17853783          	ld	a5,376(a0)
    800046dc:	fcfafce3          	bgeu	s5,a5,800046b4 <acquiresleep+0x4a>
      max_energy = owner->energy_consumed;
    800046e0:	8abe                	mv	s5,a5
      victim = owner;
    800046e2:	8baa                	mv	s7,a0
    800046e4:	bfc1                	j	800046b4 <acquiresleep+0x4a>
  if(victim != 0){
    800046e6:	040b8d63          	beqz	s7,80004740 <acquiresleep+0xd6>
    printf("deadlock recovery: killing pid %d (energy_consumed=%d) to break deadlock\n",
    800046ea:	178ba603          	lw	a2,376(s7)
    800046ee:	030ba583          	lw	a1,48(s7)
    800046f2:	00004517          	auipc	a0,0x4
    800046f6:	04e50513          	addi	a0,a0,78 # 80008740 <etext+0x740>
    800046fa:	e01fb0ef          	jal	800004fa <printf>
    victim->killed = 1;
    800046fe:	036ba423          	sw	s6,40(s7)
    if(victim->state == SLEEPING){
    80004702:	018ba783          	lw	a5,24(s7)
    80004706:	09b78163          	beq	a5,s11,80004788 <acquiresleep+0x11e>
    current_proc->in_deadlock = 0;
    8000470a:	1804ac23          	sw	zero,408(s1)
    owner_pid = target_lock->pid;
    8000470e:	028a2503          	lw	a0,40(s4)
    while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    80004712:	02a05763          	blez	a0,80004740 <acquiresleep+0xd6>
    80004716:	02a98563          	beq	s3,a0,80004740 <acquiresleep+0xd6>
    8000471a:	8962                	mv	s2,s8
      struct proc *owner = pid2proc(owner_pid);
    8000471c:	edbff0ef          	jal	800045f6 <pid2proc>
      if(owner == 0)
    80004720:	c105                	beqz	a0,80004740 <acquiresleep+0xd6>
      owner->in_deadlock = 0;
    80004722:	18052c23          	sw	zero,408(a0)
      next_lock = owner->waiting_for_lock;
    80004726:	18853783          	ld	a5,392(a0)
      if(next_lock == 0 || next_lock->locked == 0)
    8000472a:	cb99                	beqz	a5,80004740 <acquiresleep+0xd6>
    8000472c:	4398                	lw	a4,0(a5)
    8000472e:	cb09                	beqz	a4,80004740 <acquiresleep+0xd6>
      owner_pid = next_lock->pid;
    80004730:	5788                	lw	a0,40(a5)
    while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    80004732:	00a05763          	blez	a0,80004740 <acquiresleep+0xd6>
    80004736:	00a98563          	beq	s3,a0,80004740 <acquiresleep+0xd6>
    8000473a:	397d                	addiw	s2,s2,-1
    8000473c:	fe0910e3          	bnez	s2,8000471c <acquiresleep+0xb2>
             p->pid, lk->name, lk->pid);
      // break the deadlock by killing the highest energy process in deadlock cycle
      energy_aware_deadlock_recovery(p, lk);
    }
    sleep(lk, &lk->lk);
    80004740:	85e6                	mv	a1,s9
    80004742:	8552                	mv	a0,s4
    80004744:	90dfd0ef          	jal	80002050 <sleep>
  while (lk->locked) {
    80004748:	000a2783          	lw	a5,0(s4)
    8000474c:	c3b1                	beqz	a5,80004790 <acquiresleep+0x126>
    p->waiting_for_lock = lk;
    8000474e:	1944b423          	sd	s4,392(s1)
  if(current_proc == 0 || target_lock == 0)
    80004752:	d4fd                	beqz	s1,80004740 <acquiresleep+0xd6>
  owner_pid = target_lock->pid;
    80004754:	028a2503          	lw	a0,40(s4)
  while(owner_pid > 0 && hops < NPROC){
    80004758:	fea054e3          	blez	a0,80004740 <acquiresleep+0xd6>
    8000475c:	8962                	mv	s2,s8
    struct proc *owner = pid2proc(owner_pid);
    8000475e:	e99ff0ef          	jal	800045f6 <pid2proc>
    if(owner == 0)
    80004762:	dd79                	beqz	a0,80004740 <acquiresleep+0xd6>
    if(owner->pid == current_proc->pid)
    80004764:	5918                	lw	a4,48(a0)
    80004766:	589c                	lw	a5,48(s1)
    80004768:	06f70663          	beq	a4,a5,800047d4 <acquiresleep+0x16a>
    next_lock = owner->waiting_for_lock;
    8000476c:	18853783          	ld	a5,392(a0)
    if(next_lock == 0 || next_lock->locked == 0)
    80004770:	dbe1                	beqz	a5,80004740 <acquiresleep+0xd6>
    80004772:	4398                	lw	a4,0(a5)
    80004774:	d771                	beqz	a4,80004740 <acquiresleep+0xd6>
    owner_pid = next_lock->pid;
    80004776:	5788                	lw	a0,40(a5)
  while(owner_pid > 0 && hops < NPROC){
    80004778:	fca054e3          	blez	a0,80004740 <acquiresleep+0xd6>
    8000477c:	397d                	addiw	s2,s2,-1
    8000477e:	fe0910e3          	bnez	s2,8000475e <acquiresleep+0xf4>
    80004782:	bf7d                	j	80004740 <acquiresleep+0xd6>
    victim = current_proc;
    80004784:	8ba6                	mv	s7,s1
    80004786:	b795                	j	800046ea <acquiresleep+0x80>
      victim->state = RUNNABLE;
    80004788:	478d                	li	a5,3
    8000478a:	00fbac23          	sw	a5,24(s7)
    8000478e:	bfb5                	j	8000470a <acquiresleep+0xa0>
    80004790:	6946                	ld	s2,80(sp)
    80004792:	69a6                	ld	s3,72(sp)
    80004794:	7ae2                	ld	s5,56(sp)
    80004796:	7b42                	ld	s6,48(sp)
    80004798:	7ba2                	ld	s7,40(sp)
    8000479a:	7c02                	ld	s8,32(sp)
    8000479c:	6d42                	ld	s10,16(sp)
    8000479e:	6da2                	ld	s11,8(sp)
  }
  p->waiting_for_lock = 0;
    800047a0:	1804b423          	sd	zero,392(s1)
  lk->locked = 1;
    800047a4:	4785                	li	a5,1
    800047a6:	00fa2023          	sw	a5,0(s4)
  lk->pid = p->pid;
    800047aa:	589c                	lw	a5,48(s1)
    800047ac:	02fa2423          	sw	a5,40(s4)
  release(&lk->lk);
    800047b0:	8566                	mv	a0,s9
    800047b2:	cb4fc0ef          	jal	80000c66 <release>
}
    800047b6:	70a6                	ld	ra,104(sp)
    800047b8:	7406                	ld	s0,96(sp)
    800047ba:	64e6                	ld	s1,88(sp)
    800047bc:	6a06                	ld	s4,64(sp)
    800047be:	6ce2                	ld	s9,24(sp)
    800047c0:	6165                	addi	sp,sp,112
    800047c2:	8082                	ret
  owner_pid = target_lock->pid;
    800047c4:	028a2503          	lw	a0,40(s4)
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    800047c8:	faa05ee3          	blez	a0,80004784 <acquiresleep+0x11a>
    victim = current_proc;
    800047cc:	8ba6                	mv	s7,s1
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    800047ce:	02a99f63          	bne	s3,a0,8000480c <acquiresleep+0x1a2>
    800047d2:	bf21                	j	800046ea <acquiresleep+0x80>
      p->deadlock_reports++;
    800047d4:	1904b783          	ld	a5,400(s1)
    800047d8:	0785                	addi	a5,a5,1
    800047da:	18f4b823          	sd	a5,400(s1)
      printf("deadlock warning: pid %d waits for %s held by pid %d\n",
    800047de:	028a2683          	lw	a3,40(s4)
    800047e2:	020a3603          	ld	a2,32(s4)
    800047e6:	588c                	lw	a1,48(s1)
    800047e8:	856a                	mv	a0,s10
    800047ea:	d11fb0ef          	jal	800004fa <printf>
  int start_pid = current_proc->pid;
    800047ee:	0304a983          	lw	s3,48(s1)
  current_proc->in_deadlock = 1;
    800047f2:	1964ac23          	sw	s6,408(s1)
  if(current_proc->energy_consumed > max_energy){
    800047f6:	1784ba83          	ld	s5,376(s1)
    800047fa:	fc0a95e3          	bnez	s5,800047c4 <acquiresleep+0x15a>
  owner_pid = target_lock->pid;
    800047fe:	028a2503          	lw	a0,40(s4)
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    80004802:	f2a05fe3          	blez	a0,80004740 <acquiresleep+0xd6>
  struct proc *victim = 0;
    80004806:	4b81                	li	s7,0
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    80004808:	f2a98ce3          	beq	s3,a0,80004740 <acquiresleep+0xd6>
    victim = current_proc;
    8000480c:	8962                	mv	s2,s8
    8000480e:	b5c1                	j	800046ce <acquiresleep+0x64>

0000000080004810 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004810:	1101                	addi	sp,sp,-32
    80004812:	ec06                	sd	ra,24(sp)
    80004814:	e822                	sd	s0,16(sp)
    80004816:	e426                	sd	s1,8(sp)
    80004818:	e04a                	sd	s2,0(sp)
    8000481a:	1000                	addi	s0,sp,32
    8000481c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000481e:	00850913          	addi	s2,a0,8
    80004822:	854a                	mv	a0,s2
    80004824:	baafc0ef          	jal	80000bce <acquire>
  lk->locked = 0;
    80004828:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000482c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004830:	8526                	mv	a0,s1
    80004832:	86bfd0ef          	jal	8000209c <wakeup>
  release(&lk->lk);
    80004836:	854a                	mv	a0,s2
    80004838:	c2efc0ef          	jal	80000c66 <release>
}
    8000483c:	60e2                	ld	ra,24(sp)
    8000483e:	6442                	ld	s0,16(sp)
    80004840:	64a2                	ld	s1,8(sp)
    80004842:	6902                	ld	s2,0(sp)
    80004844:	6105                	addi	sp,sp,32
    80004846:	8082                	ret

0000000080004848 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004848:	7179                	addi	sp,sp,-48
    8000484a:	f406                	sd	ra,40(sp)
    8000484c:	f022                	sd	s0,32(sp)
    8000484e:	ec26                	sd	s1,24(sp)
    80004850:	e84a                	sd	s2,16(sp)
    80004852:	1800                	addi	s0,sp,48
    80004854:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004856:	00850913          	addi	s2,a0,8
    8000485a:	854a                	mv	a0,s2
    8000485c:	b72fc0ef          	jal	80000bce <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004860:	409c                	lw	a5,0(s1)
    80004862:	ef81                	bnez	a5,8000487a <holdingsleep+0x32>
    80004864:	4481                	li	s1,0
  release(&lk->lk);
    80004866:	854a                	mv	a0,s2
    80004868:	bfefc0ef          	jal	80000c66 <release>
  return r;
}
    8000486c:	8526                	mv	a0,s1
    8000486e:	70a2                	ld	ra,40(sp)
    80004870:	7402                	ld	s0,32(sp)
    80004872:	64e2                	ld	s1,24(sp)
    80004874:	6942                	ld	s2,16(sp)
    80004876:	6145                	addi	sp,sp,48
    80004878:	8082                	ret
    8000487a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000487c:	0284a983          	lw	s3,40(s1)
    80004880:	84efd0ef          	jal	800018ce <myproc>
    80004884:	5904                	lw	s1,48(a0)
    80004886:	413484b3          	sub	s1,s1,s3
    8000488a:	0014b493          	seqz	s1,s1
    8000488e:	69a2                	ld	s3,8(sp)
    80004890:	bfd9                	j	80004866 <holdingsleep+0x1e>

0000000080004892 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004892:	1141                	addi	sp,sp,-16
    80004894:	e406                	sd	ra,8(sp)
    80004896:	e022                	sd	s0,0(sp)
    80004898:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000489a:	00004597          	auipc	a1,0x4
    8000489e:	f2e58593          	addi	a1,a1,-210 # 800087c8 <etext+0x7c8>
    800048a2:	00021517          	auipc	a0,0x21
    800048a6:	f4e50513          	addi	a0,a0,-178 # 800257f0 <ftable>
    800048aa:	aa4fc0ef          	jal	80000b4e <initlock>
}
    800048ae:	60a2                	ld	ra,8(sp)
    800048b0:	6402                	ld	s0,0(sp)
    800048b2:	0141                	addi	sp,sp,16
    800048b4:	8082                	ret

00000000800048b6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800048b6:	1101                	addi	sp,sp,-32
    800048b8:	ec06                	sd	ra,24(sp)
    800048ba:	e822                	sd	s0,16(sp)
    800048bc:	e426                	sd	s1,8(sp)
    800048be:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800048c0:	00021517          	auipc	a0,0x21
    800048c4:	f3050513          	addi	a0,a0,-208 # 800257f0 <ftable>
    800048c8:	b06fc0ef          	jal	80000bce <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800048cc:	00021497          	auipc	s1,0x21
    800048d0:	f3c48493          	addi	s1,s1,-196 # 80025808 <ftable+0x18>
    800048d4:	00022717          	auipc	a4,0x22
    800048d8:	ed470713          	addi	a4,a4,-300 # 800267a8 <disk>
    if(f->ref == 0){
    800048dc:	40dc                	lw	a5,4(s1)
    800048de:	cf89                	beqz	a5,800048f8 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800048e0:	02848493          	addi	s1,s1,40
    800048e4:	fee49ce3          	bne	s1,a4,800048dc <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800048e8:	00021517          	auipc	a0,0x21
    800048ec:	f0850513          	addi	a0,a0,-248 # 800257f0 <ftable>
    800048f0:	b76fc0ef          	jal	80000c66 <release>
  return 0;
    800048f4:	4481                	li	s1,0
    800048f6:	a809                	j	80004908 <filealloc+0x52>
      f->ref = 1;
    800048f8:	4785                	li	a5,1
    800048fa:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800048fc:	00021517          	auipc	a0,0x21
    80004900:	ef450513          	addi	a0,a0,-268 # 800257f0 <ftable>
    80004904:	b62fc0ef          	jal	80000c66 <release>
}
    80004908:	8526                	mv	a0,s1
    8000490a:	60e2                	ld	ra,24(sp)
    8000490c:	6442                	ld	s0,16(sp)
    8000490e:	64a2                	ld	s1,8(sp)
    80004910:	6105                	addi	sp,sp,32
    80004912:	8082                	ret

0000000080004914 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004914:	1101                	addi	sp,sp,-32
    80004916:	ec06                	sd	ra,24(sp)
    80004918:	e822                	sd	s0,16(sp)
    8000491a:	e426                	sd	s1,8(sp)
    8000491c:	1000                	addi	s0,sp,32
    8000491e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004920:	00021517          	auipc	a0,0x21
    80004924:	ed050513          	addi	a0,a0,-304 # 800257f0 <ftable>
    80004928:	aa6fc0ef          	jal	80000bce <acquire>
  if(f->ref < 1)
    8000492c:	40dc                	lw	a5,4(s1)
    8000492e:	02f05063          	blez	a5,8000494e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004932:	2785                	addiw	a5,a5,1
    80004934:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004936:	00021517          	auipc	a0,0x21
    8000493a:	eba50513          	addi	a0,a0,-326 # 800257f0 <ftable>
    8000493e:	b28fc0ef          	jal	80000c66 <release>
  return f;
}
    80004942:	8526                	mv	a0,s1
    80004944:	60e2                	ld	ra,24(sp)
    80004946:	6442                	ld	s0,16(sp)
    80004948:	64a2                	ld	s1,8(sp)
    8000494a:	6105                	addi	sp,sp,32
    8000494c:	8082                	ret
    panic("filedup");
    8000494e:	00004517          	auipc	a0,0x4
    80004952:	e8250513          	addi	a0,a0,-382 # 800087d0 <etext+0x7d0>
    80004956:	e8bfb0ef          	jal	800007e0 <panic>

000000008000495a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000495a:	7139                	addi	sp,sp,-64
    8000495c:	fc06                	sd	ra,56(sp)
    8000495e:	f822                	sd	s0,48(sp)
    80004960:	f426                	sd	s1,40(sp)
    80004962:	0080                	addi	s0,sp,64
    80004964:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004966:	00021517          	auipc	a0,0x21
    8000496a:	e8a50513          	addi	a0,a0,-374 # 800257f0 <ftable>
    8000496e:	a60fc0ef          	jal	80000bce <acquire>
  if(f->ref < 1)
    80004972:	40dc                	lw	a5,4(s1)
    80004974:	04f05a63          	blez	a5,800049c8 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004978:	37fd                	addiw	a5,a5,-1
    8000497a:	0007871b          	sext.w	a4,a5
    8000497e:	c0dc                	sw	a5,4(s1)
    80004980:	04e04e63          	bgtz	a4,800049dc <fileclose+0x82>
    80004984:	f04a                	sd	s2,32(sp)
    80004986:	ec4e                	sd	s3,24(sp)
    80004988:	e852                	sd	s4,16(sp)
    8000498a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000498c:	0004a903          	lw	s2,0(s1)
    80004990:	0094ca83          	lbu	s5,9(s1)
    80004994:	0104ba03          	ld	s4,16(s1)
    80004998:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000499c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800049a0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800049a4:	00021517          	auipc	a0,0x21
    800049a8:	e4c50513          	addi	a0,a0,-436 # 800257f0 <ftable>
    800049ac:	abafc0ef          	jal	80000c66 <release>

  if(ff.type == FD_PIPE){
    800049b0:	4785                	li	a5,1
    800049b2:	04f90063          	beq	s2,a5,800049f2 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800049b6:	3979                	addiw	s2,s2,-2
    800049b8:	4785                	li	a5,1
    800049ba:	0527f563          	bgeu	a5,s2,80004a04 <fileclose+0xaa>
    800049be:	7902                	ld	s2,32(sp)
    800049c0:	69e2                	ld	s3,24(sp)
    800049c2:	6a42                	ld	s4,16(sp)
    800049c4:	6aa2                	ld	s5,8(sp)
    800049c6:	a00d                	j	800049e8 <fileclose+0x8e>
    800049c8:	f04a                	sd	s2,32(sp)
    800049ca:	ec4e                	sd	s3,24(sp)
    800049cc:	e852                	sd	s4,16(sp)
    800049ce:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800049d0:	00004517          	auipc	a0,0x4
    800049d4:	e0850513          	addi	a0,a0,-504 # 800087d8 <etext+0x7d8>
    800049d8:	e09fb0ef          	jal	800007e0 <panic>
    release(&ftable.lock);
    800049dc:	00021517          	auipc	a0,0x21
    800049e0:	e1450513          	addi	a0,a0,-492 # 800257f0 <ftable>
    800049e4:	a82fc0ef          	jal	80000c66 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800049e8:	70e2                	ld	ra,56(sp)
    800049ea:	7442                	ld	s0,48(sp)
    800049ec:	74a2                	ld	s1,40(sp)
    800049ee:	6121                	addi	sp,sp,64
    800049f0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800049f2:	85d6                	mv	a1,s5
    800049f4:	8552                	mv	a0,s4
    800049f6:	358000ef          	jal	80004d4e <pipeclose>
    800049fa:	7902                	ld	s2,32(sp)
    800049fc:	69e2                	ld	s3,24(sp)
    800049fe:	6a42                	ld	s4,16(sp)
    80004a00:	6aa2                	ld	s5,8(sp)
    80004a02:	b7dd                	j	800049e8 <fileclose+0x8e>
    begin_op();
    80004a04:	9adff0ef          	jal	800043b0 <begin_op>
    iput(ff.ip);
    80004a08:	854e                	mv	a0,s3
    80004a0a:	93eff0ef          	jal	80003b48 <iput>
    end_op();
    80004a0e:	a0dff0ef          	jal	8000441a <end_op>
    80004a12:	7902                	ld	s2,32(sp)
    80004a14:	69e2                	ld	s3,24(sp)
    80004a16:	6a42                	ld	s4,16(sp)
    80004a18:	6aa2                	ld	s5,8(sp)
    80004a1a:	b7f9                	j	800049e8 <fileclose+0x8e>

0000000080004a1c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004a1c:	715d                	addi	sp,sp,-80
    80004a1e:	e486                	sd	ra,72(sp)
    80004a20:	e0a2                	sd	s0,64(sp)
    80004a22:	fc26                	sd	s1,56(sp)
    80004a24:	f44e                	sd	s3,40(sp)
    80004a26:	0880                	addi	s0,sp,80
    80004a28:	84aa                	mv	s1,a0
    80004a2a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004a2c:	ea3fc0ef          	jal	800018ce <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004a30:	409c                	lw	a5,0(s1)
    80004a32:	37f9                	addiw	a5,a5,-2
    80004a34:	4705                	li	a4,1
    80004a36:	04f76063          	bltu	a4,a5,80004a76 <filestat+0x5a>
    80004a3a:	f84a                	sd	s2,48(sp)
    80004a3c:	892a                	mv	s2,a0
    ilock(f->ip);
    80004a3e:	6c88                	ld	a0,24(s1)
    80004a40:	f87fe0ef          	jal	800039c6 <ilock>
    stati(f->ip, &st);
    80004a44:	fb840593          	addi	a1,s0,-72
    80004a48:	6c88                	ld	a0,24(s1)
    80004a4a:	ae2ff0ef          	jal	80003d2c <stati>
    iunlock(f->ip);
    80004a4e:	6c88                	ld	a0,24(s1)
    80004a50:	824ff0ef          	jal	80003a74 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004a54:	46e1                	li	a3,24
    80004a56:	fb840613          	addi	a2,s0,-72
    80004a5a:	85ce                	mv	a1,s3
    80004a5c:	05093503          	ld	a0,80(s2)
    80004a60:	b83fc0ef          	jal	800015e2 <copyout>
    80004a64:	41f5551b          	sraiw	a0,a0,0x1f
    80004a68:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004a6a:	60a6                	ld	ra,72(sp)
    80004a6c:	6406                	ld	s0,64(sp)
    80004a6e:	74e2                	ld	s1,56(sp)
    80004a70:	79a2                	ld	s3,40(sp)
    80004a72:	6161                	addi	sp,sp,80
    80004a74:	8082                	ret
  return -1;
    80004a76:	557d                	li	a0,-1
    80004a78:	bfcd                	j	80004a6a <filestat+0x4e>

0000000080004a7a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004a7a:	7179                	addi	sp,sp,-48
    80004a7c:	f406                	sd	ra,40(sp)
    80004a7e:	f022                	sd	s0,32(sp)
    80004a80:	e84a                	sd	s2,16(sp)
    80004a82:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004a84:	00854783          	lbu	a5,8(a0)
    80004a88:	cfd1                	beqz	a5,80004b24 <fileread+0xaa>
    80004a8a:	ec26                	sd	s1,24(sp)
    80004a8c:	e44e                	sd	s3,8(sp)
    80004a8e:	84aa                	mv	s1,a0
    80004a90:	89ae                	mv	s3,a1
    80004a92:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a94:	411c                	lw	a5,0(a0)
    80004a96:	4705                	li	a4,1
    80004a98:	04e78363          	beq	a5,a4,80004ade <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a9c:	470d                	li	a4,3
    80004a9e:	04e78763          	beq	a5,a4,80004aec <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004aa2:	4709                	li	a4,2
    80004aa4:	06e79a63          	bne	a5,a4,80004b18 <fileread+0x9e>
    ilock(f->ip);
    80004aa8:	6d08                	ld	a0,24(a0)
    80004aaa:	f1dfe0ef          	jal	800039c6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004aae:	874a                	mv	a4,s2
    80004ab0:	5094                	lw	a3,32(s1)
    80004ab2:	864e                	mv	a2,s3
    80004ab4:	4585                	li	a1,1
    80004ab6:	6c88                	ld	a0,24(s1)
    80004ab8:	a9eff0ef          	jal	80003d56 <readi>
    80004abc:	892a                	mv	s2,a0
    80004abe:	00a05563          	blez	a0,80004ac8 <fileread+0x4e>
      f->off += r;
    80004ac2:	509c                	lw	a5,32(s1)
    80004ac4:	9fa9                	addw	a5,a5,a0
    80004ac6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ac8:	6c88                	ld	a0,24(s1)
    80004aca:	fabfe0ef          	jal	80003a74 <iunlock>
    80004ace:	64e2                	ld	s1,24(sp)
    80004ad0:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004ad2:	854a                	mv	a0,s2
    80004ad4:	70a2                	ld	ra,40(sp)
    80004ad6:	7402                	ld	s0,32(sp)
    80004ad8:	6942                	ld	s2,16(sp)
    80004ada:	6145                	addi	sp,sp,48
    80004adc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004ade:	6908                	ld	a0,16(a0)
    80004ae0:	3dc000ef          	jal	80004ebc <piperead>
    80004ae4:	892a                	mv	s2,a0
    80004ae6:	64e2                	ld	s1,24(sp)
    80004ae8:	69a2                	ld	s3,8(sp)
    80004aea:	b7e5                	j	80004ad2 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004aec:	02451783          	lh	a5,36(a0)
    80004af0:	03079693          	slli	a3,a5,0x30
    80004af4:	92c1                	srli	a3,a3,0x30
    80004af6:	4725                	li	a4,9
    80004af8:	02d76863          	bltu	a4,a3,80004b28 <fileread+0xae>
    80004afc:	0792                	slli	a5,a5,0x4
    80004afe:	00021717          	auipc	a4,0x21
    80004b02:	c5270713          	addi	a4,a4,-942 # 80025750 <devsw>
    80004b06:	97ba                	add	a5,a5,a4
    80004b08:	639c                	ld	a5,0(a5)
    80004b0a:	c39d                	beqz	a5,80004b30 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004b0c:	4505                	li	a0,1
    80004b0e:	9782                	jalr	a5
    80004b10:	892a                	mv	s2,a0
    80004b12:	64e2                	ld	s1,24(sp)
    80004b14:	69a2                	ld	s3,8(sp)
    80004b16:	bf75                	j	80004ad2 <fileread+0x58>
    panic("fileread");
    80004b18:	00004517          	auipc	a0,0x4
    80004b1c:	cd050513          	addi	a0,a0,-816 # 800087e8 <etext+0x7e8>
    80004b20:	cc1fb0ef          	jal	800007e0 <panic>
    return -1;
    80004b24:	597d                	li	s2,-1
    80004b26:	b775                	j	80004ad2 <fileread+0x58>
      return -1;
    80004b28:	597d                	li	s2,-1
    80004b2a:	64e2                	ld	s1,24(sp)
    80004b2c:	69a2                	ld	s3,8(sp)
    80004b2e:	b755                	j	80004ad2 <fileread+0x58>
    80004b30:	597d                	li	s2,-1
    80004b32:	64e2                	ld	s1,24(sp)
    80004b34:	69a2                	ld	s3,8(sp)
    80004b36:	bf71                	j	80004ad2 <fileread+0x58>

0000000080004b38 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004b38:	00954783          	lbu	a5,9(a0)
    80004b3c:	10078b63          	beqz	a5,80004c52 <filewrite+0x11a>
{
    80004b40:	715d                	addi	sp,sp,-80
    80004b42:	e486                	sd	ra,72(sp)
    80004b44:	e0a2                	sd	s0,64(sp)
    80004b46:	f84a                	sd	s2,48(sp)
    80004b48:	f052                	sd	s4,32(sp)
    80004b4a:	e85a                	sd	s6,16(sp)
    80004b4c:	0880                	addi	s0,sp,80
    80004b4e:	892a                	mv	s2,a0
    80004b50:	8b2e                	mv	s6,a1
    80004b52:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b54:	411c                	lw	a5,0(a0)
    80004b56:	4705                	li	a4,1
    80004b58:	02e78763          	beq	a5,a4,80004b86 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b5c:	470d                	li	a4,3
    80004b5e:	02e78863          	beq	a5,a4,80004b8e <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b62:	4709                	li	a4,2
    80004b64:	0ce79c63          	bne	a5,a4,80004c3c <filewrite+0x104>
    80004b68:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004b6a:	0ac05863          	blez	a2,80004c1a <filewrite+0xe2>
    80004b6e:	fc26                	sd	s1,56(sp)
    80004b70:	ec56                	sd	s5,24(sp)
    80004b72:	e45e                	sd	s7,8(sp)
    80004b74:	e062                	sd	s8,0(sp)
    int i = 0;
    80004b76:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004b78:	6b85                	lui	s7,0x1
    80004b7a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004b7e:	6c05                	lui	s8,0x1
    80004b80:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004b84:	a8b5                	j	80004c00 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004b86:	6908                	ld	a0,16(a0)
    80004b88:	23a000ef          	jal	80004dc2 <pipewrite>
    80004b8c:	a04d                	j	80004c2e <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004b8e:	02451783          	lh	a5,36(a0)
    80004b92:	03079693          	slli	a3,a5,0x30
    80004b96:	92c1                	srli	a3,a3,0x30
    80004b98:	4725                	li	a4,9
    80004b9a:	0ad76e63          	bltu	a4,a3,80004c56 <filewrite+0x11e>
    80004b9e:	0792                	slli	a5,a5,0x4
    80004ba0:	00021717          	auipc	a4,0x21
    80004ba4:	bb070713          	addi	a4,a4,-1104 # 80025750 <devsw>
    80004ba8:	97ba                	add	a5,a5,a4
    80004baa:	679c                	ld	a5,8(a5)
    80004bac:	c7dd                	beqz	a5,80004c5a <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004bae:	4505                	li	a0,1
    80004bb0:	9782                	jalr	a5
    80004bb2:	a8b5                	j	80004c2e <filewrite+0xf6>
      if(n1 > max)
    80004bb4:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004bb8:	ff8ff0ef          	jal	800043b0 <begin_op>
      ilock(f->ip);
    80004bbc:	01893503          	ld	a0,24(s2)
    80004bc0:	e07fe0ef          	jal	800039c6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004bc4:	8756                	mv	a4,s5
    80004bc6:	02092683          	lw	a3,32(s2)
    80004bca:	01698633          	add	a2,s3,s6
    80004bce:	4585                	li	a1,1
    80004bd0:	01893503          	ld	a0,24(s2)
    80004bd4:	a7eff0ef          	jal	80003e52 <writei>
    80004bd8:	84aa                	mv	s1,a0
    80004bda:	00a05763          	blez	a0,80004be8 <filewrite+0xb0>
        f->off += r;
    80004bde:	02092783          	lw	a5,32(s2)
    80004be2:	9fa9                	addw	a5,a5,a0
    80004be4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004be8:	01893503          	ld	a0,24(s2)
    80004bec:	e89fe0ef          	jal	80003a74 <iunlock>
      end_op();
    80004bf0:	82bff0ef          	jal	8000441a <end_op>

      if(r != n1){
    80004bf4:	029a9563          	bne	s5,s1,80004c1e <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004bf8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004bfc:	0149da63          	bge	s3,s4,80004c10 <filewrite+0xd8>
      int n1 = n - i;
    80004c00:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004c04:	0004879b          	sext.w	a5,s1
    80004c08:	fafbd6e3          	bge	s7,a5,80004bb4 <filewrite+0x7c>
    80004c0c:	84e2                	mv	s1,s8
    80004c0e:	b75d                	j	80004bb4 <filewrite+0x7c>
    80004c10:	74e2                	ld	s1,56(sp)
    80004c12:	6ae2                	ld	s5,24(sp)
    80004c14:	6ba2                	ld	s7,8(sp)
    80004c16:	6c02                	ld	s8,0(sp)
    80004c18:	a039                	j	80004c26 <filewrite+0xee>
    int i = 0;
    80004c1a:	4981                	li	s3,0
    80004c1c:	a029                	j	80004c26 <filewrite+0xee>
    80004c1e:	74e2                	ld	s1,56(sp)
    80004c20:	6ae2                	ld	s5,24(sp)
    80004c22:	6ba2                	ld	s7,8(sp)
    80004c24:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004c26:	033a1c63          	bne	s4,s3,80004c5e <filewrite+0x126>
    80004c2a:	8552                	mv	a0,s4
    80004c2c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004c2e:	60a6                	ld	ra,72(sp)
    80004c30:	6406                	ld	s0,64(sp)
    80004c32:	7942                	ld	s2,48(sp)
    80004c34:	7a02                	ld	s4,32(sp)
    80004c36:	6b42                	ld	s6,16(sp)
    80004c38:	6161                	addi	sp,sp,80
    80004c3a:	8082                	ret
    80004c3c:	fc26                	sd	s1,56(sp)
    80004c3e:	f44e                	sd	s3,40(sp)
    80004c40:	ec56                	sd	s5,24(sp)
    80004c42:	e45e                	sd	s7,8(sp)
    80004c44:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004c46:	00004517          	auipc	a0,0x4
    80004c4a:	bb250513          	addi	a0,a0,-1102 # 800087f8 <etext+0x7f8>
    80004c4e:	b93fb0ef          	jal	800007e0 <panic>
    return -1;
    80004c52:	557d                	li	a0,-1
}
    80004c54:	8082                	ret
      return -1;
    80004c56:	557d                	li	a0,-1
    80004c58:	bfd9                	j	80004c2e <filewrite+0xf6>
    80004c5a:	557d                	li	a0,-1
    80004c5c:	bfc9                	j	80004c2e <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004c5e:	557d                	li	a0,-1
    80004c60:	79a2                	ld	s3,40(sp)
    80004c62:	b7f1                	j	80004c2e <filewrite+0xf6>

0000000080004c64 <peterson_acquire>:

// Peterson's lock acquire
// id = 0 for writer, id = 1 for reader
static void
peterson_acquire(struct pipe *pi, int id)
{
    80004c64:	1141                	addi	sp,sp,-16
    80004c66:	e422                	sd	s0,8(sp)
    80004c68:	0800                	addi	s0,sp,16
  int other = 1 - id;
    80004c6a:	4785                	li	a5,1
    80004c6c:	9f8d                	subw	a5,a5,a1
    80004c6e:	0007869b          	sext.w	a3,a5
  pi->flag[id] = 1;        // I want to enter
    80004c72:	058a                	slli	a1,a1,0x2
    80004c74:	95aa                	add	a1,a1,a0
    80004c76:	4705                	li	a4,1
    80004c78:	c198                	sw	a4,0(a1)
  pi->turn = other;        // But I give the other process a chance first
    80004c7a:	c51c                	sw	a5,8(a0)

  // Memory fence to ensure the above stores are visible before the while check
  __sync_synchronize();
    80004c7c:	0330000f          	fence	rw,rw

  // Busy-wait while the OTHER process also wants in AND it's the other's turn
  while(pi->flag[other] == 1 && pi->turn == other)
    80004c80:	00269713          	slli	a4,a3,0x2
    80004c84:	972a                	add	a4,a4,a0
    80004c86:	4605                	li	a2,1
    80004c88:	431c                	lw	a5,0(a4)
    80004c8a:	2781                	sext.w	a5,a5
    80004c8c:	00c79663          	bne	a5,a2,80004c98 <peterson_acquire+0x34>
    80004c90:	451c                	lw	a5,8(a0)
    80004c92:	2781                	sext.w	a5,a5
    80004c94:	fed78ae3          	beq	a5,a3,80004c88 <peterson_acquire+0x24>
    ;
}
    80004c98:	6422                	ld	s0,8(sp)
    80004c9a:	0141                	addi	sp,sp,16
    80004c9c:	8082                	ret

0000000080004c9e <pipealloc>:
  pi->flag[id] = 0;       // I no longer want to be in the critical section
}

int
pipealloc(struct file **f0, struct file **f1)
{
    80004c9e:	1101                	addi	sp,sp,-32
    80004ca0:	ec06                	sd	ra,24(sp)
    80004ca2:	e822                	sd	s0,16(sp)
    80004ca4:	e426                	sd	s1,8(sp)
    80004ca6:	e04a                	sd	s2,0(sp)
    80004ca8:	1000                	addi	s0,sp,32
    80004caa:	84aa                	mv	s1,a0
    80004cac:	892e                	mv	s2,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004cae:	0005b023          	sd	zero,0(a1)
    80004cb2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004cb6:	c01ff0ef          	jal	800048b6 <filealloc>
    80004cba:	e088                	sd	a0,0(s1)
    80004cbc:	cd35                	beqz	a0,80004d38 <pipealloc+0x9a>
    80004cbe:	bf9ff0ef          	jal	800048b6 <filealloc>
    80004cc2:	00a93023          	sd	a0,0(s2)
    80004cc6:	c52d                	beqz	a0,80004d30 <pipealloc+0x92>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004cc8:	e37fb0ef          	jal	80000afe <kalloc>
    80004ccc:	cd39                	beqz	a0,80004d2a <pipealloc+0x8c>
    goto bad;
  pi->readopen = 1;
    80004cce:	4785                	li	a5,1
    80004cd0:	20f52a23          	sw	a5,532(a0)
  pi->writeopen = 1;
    80004cd4:	20f52c23          	sw	a5,536(a0)
  pi->nwrite = 0;
    80004cd8:	20052823          	sw	zero,528(a0)
  pi->nread = 0;
    80004cdc:	20052623          	sw	zero,524(a0)

  // Initialize Peterson's variables (instead of initlock)
  pi->flag[0] = 0;
    80004ce0:	00052023          	sw	zero,0(a0)
  pi->flag[1] = 0;
    80004ce4:	00052223          	sw	zero,4(a0)
  pi->turn = 0;
    80004ce8:	00052423          	sw	zero,8(a0)

  (*f0)->type = FD_PIPE;
    80004cec:	6098                	ld	a4,0(s1)
    80004cee:	c31c                	sw	a5,0(a4)
  (*f0)->readable = 1;
    80004cf0:	6098                	ld	a4,0(s1)
    80004cf2:	00f70423          	sb	a5,8(a4)
  (*f0)->writable = 0;
    80004cf6:	6098                	ld	a4,0(s1)
    80004cf8:	000704a3          	sb	zero,9(a4)
  (*f0)->pipe = pi;
    80004cfc:	6098                	ld	a4,0(s1)
    80004cfe:	eb08                	sd	a0,16(a4)
  (*f1)->type = FD_PIPE;
    80004d00:	00093703          	ld	a4,0(s2)
    80004d04:	c31c                	sw	a5,0(a4)
  (*f1)->readable = 0;
    80004d06:	00093703          	ld	a4,0(s2)
    80004d0a:	00070423          	sb	zero,8(a4)
  (*f1)->writable = 1;
    80004d0e:	00093703          	ld	a4,0(s2)
    80004d12:	00f704a3          	sb	a5,9(a4)
  (*f1)->pipe = pi;
    80004d16:	00093783          	ld	a5,0(s2)
    80004d1a:	eb88                	sd	a0,16(a5)
  return 0;
    80004d1c:	4501                	li	a0,0
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
    80004d1e:	60e2                	ld	ra,24(sp)
    80004d20:	6442                	ld	s0,16(sp)
    80004d22:	64a2                	ld	s1,8(sp)
    80004d24:	6902                	ld	s2,0(sp)
    80004d26:	6105                	addi	sp,sp,32
    80004d28:	8082                	ret
  if(*f0)
    80004d2a:	6088                	ld	a0,0(s1)
    80004d2c:	e501                	bnez	a0,80004d34 <pipealloc+0x96>
    80004d2e:	a029                	j	80004d38 <pipealloc+0x9a>
    80004d30:	6088                	ld	a0,0(s1)
    80004d32:	cd01                	beqz	a0,80004d4a <pipealloc+0xac>
    fileclose(*f0);
    80004d34:	c27ff0ef          	jal	8000495a <fileclose>
  if(*f1)
    80004d38:	00093783          	ld	a5,0(s2)
  return -1;
    80004d3c:	557d                	li	a0,-1
  if(*f1)
    80004d3e:	d3e5                	beqz	a5,80004d1e <pipealloc+0x80>
    fileclose(*f1);
    80004d40:	853e                	mv	a0,a5
    80004d42:	c19ff0ef          	jal	8000495a <fileclose>
  return -1;
    80004d46:	557d                	li	a0,-1
    80004d48:	bfd9                	j	80004d1e <pipealloc+0x80>
    80004d4a:	557d                	li	a0,-1
    80004d4c:	bfc9                	j	80004d1e <pipealloc+0x80>

0000000080004d4e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004d4e:	7179                	addi	sp,sp,-48
    80004d50:	f406                	sd	ra,40(sp)
    80004d52:	f022                	sd	s0,32(sp)
    80004d54:	ec26                	sd	s1,24(sp)
    80004d56:	e84a                	sd	s2,16(sp)
    80004d58:	e44e                	sd	s3,8(sp)
    80004d5a:	1800                	addi	s0,sp,48
    80004d5c:	84aa                	mv	s1,a0
    80004d5e:	89ae                	mv	s3,a1
  // Determine our process id for Peterson's: writer = 0, reader = 1
  int id = writable ? 0 : 1;
    80004d60:	0015b913          	seqz	s2,a1

  peterson_acquire(pi, id);
    80004d64:	85ca                	mv	a1,s2
    80004d66:	effff0ef          	jal	80004c64 <peterson_acquire>
  if(writable){
    80004d6a:	02098b63          	beqz	s3,80004da0 <pipeclose+0x52>
    pi->writeopen = 0;
    80004d6e:	2004ac23          	sw	zero,536(s1)
    wakeup(&pi->nread);
    80004d72:	20c48513          	addi	a0,s1,524
    80004d76:	b26fd0ef          	jal	8000209c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004d7a:	2144a783          	lw	a5,532(s1)
    80004d7e:	e781                	bnez	a5,80004d86 <pipeclose+0x38>
    80004d80:	2184a783          	lw	a5,536(s1)
    80004d84:	c78d                	beqz	a5,80004dae <pipeclose+0x60>
  __sync_synchronize();
    80004d86:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004d8a:	090a                	slli	s2,s2,0x2
    80004d8c:	94ca                	add	s1,s1,s2
    80004d8e:	0004a023          	sw	zero,0(s1)
    peterson_release(pi, id);
    kfree((char*)pi);
  } else
    peterson_release(pi, id);
}
    80004d92:	70a2                	ld	ra,40(sp)
    80004d94:	7402                	ld	s0,32(sp)
    80004d96:	64e2                	ld	s1,24(sp)
    80004d98:	6942                	ld	s2,16(sp)
    80004d9a:	69a2                	ld	s3,8(sp)
    80004d9c:	6145                	addi	sp,sp,48
    80004d9e:	8082                	ret
    pi->readopen = 0;
    80004da0:	2004aa23          	sw	zero,532(s1)
    wakeup(&pi->nwrite);
    80004da4:	21048513          	addi	a0,s1,528
    80004da8:	af4fd0ef          	jal	8000209c <wakeup>
    80004dac:	b7f9                	j	80004d7a <pipeclose+0x2c>
  __sync_synchronize();
    80004dae:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004db2:	090a                	slli	s2,s2,0x2
    80004db4:	9926                	add	s2,s2,s1
    80004db6:	00092023          	sw	zero,0(s2)
    kfree((char*)pi);
    80004dba:	8526                	mv	a0,s1
    80004dbc:	c61fb0ef          	jal	80000a1c <kfree>
    80004dc0:	bfc9                	j	80004d92 <pipeclose+0x44>

0000000080004dc2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004dc2:	711d                	addi	sp,sp,-96
    80004dc4:	ec86                	sd	ra,88(sp)
    80004dc6:	e8a2                	sd	s0,80(sp)
    80004dc8:	e4a6                	sd	s1,72(sp)
    80004dca:	e0ca                	sd	s2,64(sp)
    80004dcc:	fc4e                	sd	s3,56(sp)
    80004dce:	f852                	sd	s4,48(sp)
    80004dd0:	f456                	sd	s5,40(sp)
    80004dd2:	1080                	addi	s0,sp,96
    80004dd4:	84aa                	mv	s1,a0
    80004dd6:	8aae                	mv	s5,a1
    80004dd8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004dda:	af5fc0ef          	jal	800018ce <myproc>
    80004dde:	89aa                	mv	s3,a0

  // Writer is process 0 in Peterson's algorithm
  peterson_acquire(pi, 0);
    80004de0:	4581                	li	a1,0
    80004de2:	8526                	mv	a0,s1
    80004de4:	e81ff0ef          	jal	80004c64 <peterson_acquire>
  while(i < n){
    80004de8:	0d405463          	blez	s4,80004eb0 <pipewrite+0xee>
    80004dec:	f05a                	sd	s6,32(sp)
    80004dee:	ec5e                	sd	s7,24(sp)
    80004df0:	e862                	sd	s8,16(sp)
  int i = 0;
    80004df2:	4901                	li	s2,0
      sleep(&pi->nwrite, 0);
      // Re-acquire Peterson's lock after waking up
      peterson_acquire(pi, 0);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004df4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004df6:	20c48c13          	addi	s8,s1,524
      sleep(&pi->nwrite, 0);
    80004dfa:	21048b93          	addi	s7,s1,528
    80004dfe:	a0a1                	j	80004e46 <pipewrite+0x84>
  __sync_synchronize();
    80004e00:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004e04:	0004a023          	sw	zero,0(s1)
      return -1;
    80004e08:	597d                	li	s2,-1
}
    80004e0a:	7b02                	ld	s6,32(sp)
    80004e0c:	6be2                	ld	s7,24(sp)
    80004e0e:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  peterson_release(pi, 0);

  return i;
}
    80004e10:	854a                	mv	a0,s2
    80004e12:	60e6                	ld	ra,88(sp)
    80004e14:	6446                	ld	s0,80(sp)
    80004e16:	64a6                	ld	s1,72(sp)
    80004e18:	6906                	ld	s2,64(sp)
    80004e1a:	79e2                	ld	s3,56(sp)
    80004e1c:	7a42                	ld	s4,48(sp)
    80004e1e:	7aa2                	ld	s5,40(sp)
    80004e20:	6125                	addi	sp,sp,96
    80004e22:	8082                	ret
      wakeup(&pi->nread);
    80004e24:	8562                	mv	a0,s8
    80004e26:	a76fd0ef          	jal	8000209c <wakeup>
  __sync_synchronize();
    80004e2a:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004e2e:	0004a023          	sw	zero,0(s1)
      sleep(&pi->nwrite, 0);
    80004e32:	4581                	li	a1,0
    80004e34:	855e                	mv	a0,s7
    80004e36:	a1afd0ef          	jal	80002050 <sleep>
      peterson_acquire(pi, 0);
    80004e3a:	4581                	li	a1,0
    80004e3c:	8526                	mv	a0,s1
    80004e3e:	e27ff0ef          	jal	80004c64 <peterson_acquire>
  while(i < n){
    80004e42:	05495b63          	bge	s2,s4,80004e98 <pipewrite+0xd6>
    if(pi->readopen == 0 || killed(pr)){
    80004e46:	2144a783          	lw	a5,532(s1)
    80004e4a:	dbdd                	beqz	a5,80004e00 <pipewrite+0x3e>
    80004e4c:	854e                	mv	a0,s3
    80004e4e:	c3afd0ef          	jal	80002288 <killed>
    80004e52:	f55d                	bnez	a0,80004e00 <pipewrite+0x3e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004e54:	20c4a783          	lw	a5,524(s1)
    80004e58:	2104a703          	lw	a4,528(s1)
    80004e5c:	2007879b          	addiw	a5,a5,512
    80004e60:	fcf702e3          	beq	a4,a5,80004e24 <pipewrite+0x62>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e64:	4685                	li	a3,1
    80004e66:	01590633          	add	a2,s2,s5
    80004e6a:	faf40593          	addi	a1,s0,-81
    80004e6e:	0509b503          	ld	a0,80(s3)
    80004e72:	855fc0ef          	jal	800016c6 <copyin>
    80004e76:	03650f63          	beq	a0,s6,80004eb4 <pipewrite+0xf2>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004e7a:	2104a783          	lw	a5,528(s1)
    80004e7e:	0017871b          	addiw	a4,a5,1
    80004e82:	20e4a823          	sw	a4,528(s1)
    80004e86:	1ff7f793          	andi	a5,a5,511
    80004e8a:	97a6                	add	a5,a5,s1
    80004e8c:	faf44703          	lbu	a4,-81(s0)
    80004e90:	00e78623          	sb	a4,12(a5)
      i++;
    80004e94:	2905                	addiw	s2,s2,1
    80004e96:	b775                	j	80004e42 <pipewrite+0x80>
    80004e98:	7b02                	ld	s6,32(sp)
    80004e9a:	6be2                	ld	s7,24(sp)
    80004e9c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004e9e:	20c48513          	addi	a0,s1,524
    80004ea2:	9fafd0ef          	jal	8000209c <wakeup>
  __sync_synchronize();
    80004ea6:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004eaa:	0004a023          	sw	zero,0(s1)
}
    80004eae:	b78d                	j	80004e10 <pipewrite+0x4e>
  int i = 0;
    80004eb0:	4901                	li	s2,0
    80004eb2:	b7f5                	j	80004e9e <pipewrite+0xdc>
    80004eb4:	7b02                	ld	s6,32(sp)
    80004eb6:	6be2                	ld	s7,24(sp)
    80004eb8:	6c42                	ld	s8,16(sp)
    80004eba:	b7d5                	j	80004e9e <pipewrite+0xdc>

0000000080004ebc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ebc:	715d                	addi	sp,sp,-80
    80004ebe:	e486                	sd	ra,72(sp)
    80004ec0:	e0a2                	sd	s0,64(sp)
    80004ec2:	fc26                	sd	s1,56(sp)
    80004ec4:	f84a                	sd	s2,48(sp)
    80004ec6:	f44e                	sd	s3,40(sp)
    80004ec8:	f052                	sd	s4,32(sp)
    80004eca:	ec56                	sd	s5,24(sp)
    80004ecc:	0880                	addi	s0,sp,80
    80004ece:	84aa                	mv	s1,a0
    80004ed0:	892e                	mv	s2,a1
    80004ed2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004ed4:	9fbfc0ef          	jal	800018ce <myproc>
    80004ed8:	8a2a                	mv	s4,a0
  char ch;

  // Reader is process 1 in Peterson's algorithm
  peterson_acquire(pi, 1);
    80004eda:	4585                	li	a1,1
    80004edc:	8526                	mv	a0,s1
    80004ede:	d87ff0ef          	jal	80004c64 <peterson_acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ee2:	20c4a703          	lw	a4,524(s1)
    80004ee6:	2104a783          	lw	a5,528(s1)
      return -1;
    }
    // Release Peterson's lock before sleeping so the writer can acquire it
    peterson_release(pi, 1);
    // Sleep on nread — the writer will wake us when it writes
    sleep(&pi->nread, 0);
    80004eea:	20c48993          	addi	s3,s1,524
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004eee:	02f71d63          	bne	a4,a5,80004f28 <piperead+0x6c>
    80004ef2:	2184a783          	lw	a5,536(s1)
    80004ef6:	c3a9                	beqz	a5,80004f38 <piperead+0x7c>
    if(killed(pr)){
    80004ef8:	8552                	mv	a0,s4
    80004efa:	b8efd0ef          	jal	80002288 <killed>
    80004efe:	e51d                	bnez	a0,80004f2c <piperead+0x70>
  __sync_synchronize();
    80004f00:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004f04:	0004a223          	sw	zero,4(s1)
    sleep(&pi->nread, 0);
    80004f08:	4581                	li	a1,0
    80004f0a:	854e                	mv	a0,s3
    80004f0c:	944fd0ef          	jal	80002050 <sleep>
    // Re-acquire Peterson's lock after waking up
    peterson_acquire(pi, 1);
    80004f10:	4585                	li	a1,1
    80004f12:	8526                	mv	a0,s1
    80004f14:	d51ff0ef          	jal	80004c64 <peterson_acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f18:	20c4a703          	lw	a4,524(s1)
    80004f1c:	2104a783          	lw	a5,528(s1)
    80004f20:	fcf709e3          	beq	a4,a5,80004ef2 <piperead+0x36>
    80004f24:	e85a                	sd	s6,16(sp)
    80004f26:	a811                	j	80004f3a <piperead+0x7e>
    80004f28:	e85a                	sd	s6,16(sp)
    80004f2a:	a801                	j	80004f3a <piperead+0x7e>
  __sync_synchronize();
    80004f2c:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004f30:	0004a223          	sw	zero,4(s1)
      return -1;
    80004f34:	59fd                	li	s3,-1
}
    80004f36:	a085                	j	80004f96 <piperead+0xda>
    80004f38:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f3a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004f3c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f3e:	05505363          	blez	s5,80004f84 <piperead+0xc8>
    if(pi->nread == pi->nwrite)
    80004f42:	20c4a783          	lw	a5,524(s1)
    80004f46:	2104a703          	lw	a4,528(s1)
    80004f4a:	02f70d63          	beq	a4,a5,80004f84 <piperead+0xc8>
    ch = pi->data[pi->nread % PIPESIZE];
    80004f4e:	1ff7f793          	andi	a5,a5,511
    80004f52:	97a6                	add	a5,a5,s1
    80004f54:	00c7c783          	lbu	a5,12(a5)
    80004f58:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004f5c:	4685                	li	a3,1
    80004f5e:	fbf40613          	addi	a2,s0,-65
    80004f62:	85ca                	mv	a1,s2
    80004f64:	050a3503          	ld	a0,80(s4)
    80004f68:	e7afc0ef          	jal	800015e2 <copyout>
    80004f6c:	03650f63          	beq	a0,s6,80004faa <piperead+0xee>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004f70:	20c4a783          	lw	a5,524(s1)
    80004f74:	2785                	addiw	a5,a5,1
    80004f76:	20f4a623          	sw	a5,524(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f7a:	2985                	addiw	s3,s3,1
    80004f7c:	0905                	addi	s2,s2,1
    80004f7e:	fd3a92e3          	bne	s5,s3,80004f42 <piperead+0x86>
    80004f82:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004f84:	21048513          	addi	a0,s1,528
    80004f88:	914fd0ef          	jal	8000209c <wakeup>
  __sync_synchronize();
    80004f8c:	0330000f          	fence	rw,rw
  pi->flag[id] = 0;       // I no longer want to be in the critical section
    80004f90:	0004a223          	sw	zero,4(s1)
    80004f94:	6b42                	ld	s6,16(sp)
  peterson_release(pi, 1);
  return i;
}
    80004f96:	854e                	mv	a0,s3
    80004f98:	60a6                	ld	ra,72(sp)
    80004f9a:	6406                	ld	s0,64(sp)
    80004f9c:	74e2                	ld	s1,56(sp)
    80004f9e:	7942                	ld	s2,48(sp)
    80004fa0:	79a2                	ld	s3,40(sp)
    80004fa2:	7a02                	ld	s4,32(sp)
    80004fa4:	6ae2                	ld	s5,24(sp)
    80004fa6:	6161                	addi	sp,sp,80
    80004fa8:	8082                	ret
      if(i == 0)
    80004faa:	fc099de3          	bnez	s3,80004f84 <piperead+0xc8>
        i = -1;
    80004fae:	89aa                	mv	s3,a0
    80004fb0:	bfd1                	j	80004f84 <piperead+0xc8>

0000000080004fb2 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004fb2:	1141                	addi	sp,sp,-16
    80004fb4:	e422                	sd	s0,8(sp)
    80004fb6:	0800                	addi	s0,sp,16
    80004fb8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004fba:	8905                	andi	a0,a0,1
    80004fbc:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004fbe:	8b89                	andi	a5,a5,2
    80004fc0:	c399                	beqz	a5,80004fc6 <flags2perm+0x14>
      perm |= PTE_W;
    80004fc2:	00456513          	ori	a0,a0,4
    return perm;
}
    80004fc6:	6422                	ld	s0,8(sp)
    80004fc8:	0141                	addi	sp,sp,16
    80004fca:	8082                	ret

0000000080004fcc <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004fcc:	df010113          	addi	sp,sp,-528
    80004fd0:	20113423          	sd	ra,520(sp)
    80004fd4:	20813023          	sd	s0,512(sp)
    80004fd8:	ffa6                	sd	s1,504(sp)
    80004fda:	fbca                	sd	s2,496(sp)
    80004fdc:	0c00                	addi	s0,sp,528
    80004fde:	892a                	mv	s2,a0
    80004fe0:	dea43c23          	sd	a0,-520(s0)
    80004fe4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004fe8:	8e7fc0ef          	jal	800018ce <myproc>
    80004fec:	84aa                	mv	s1,a0

  begin_op();
    80004fee:	bc2ff0ef          	jal	800043b0 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004ff2:	854a                	mv	a0,s2
    80004ff4:	9e8ff0ef          	jal	800041dc <namei>
    80004ff8:	c931                	beqz	a0,8000504c <kexec+0x80>
    80004ffa:	f3d2                	sd	s4,480(sp)
    80004ffc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004ffe:	9c9fe0ef          	jal	800039c6 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005002:	04000713          	li	a4,64
    80005006:	4681                	li	a3,0
    80005008:	e5040613          	addi	a2,s0,-432
    8000500c:	4581                	li	a1,0
    8000500e:	8552                	mv	a0,s4
    80005010:	d47fe0ef          	jal	80003d56 <readi>
    80005014:	04000793          	li	a5,64
    80005018:	00f51a63          	bne	a0,a5,8000502c <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    8000501c:	e5042703          	lw	a4,-432(s0)
    80005020:	464c47b7          	lui	a5,0x464c4
    80005024:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005028:	02f70663          	beq	a4,a5,80005054 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000502c:	8552                	mv	a0,s4
    8000502e:	ba3fe0ef          	jal	80003bd0 <iunlockput>
    end_op();
    80005032:	be8ff0ef          	jal	8000441a <end_op>
  }
  return -1;
    80005036:	557d                	li	a0,-1
    80005038:	7a1e                	ld	s4,480(sp)
}
    8000503a:	20813083          	ld	ra,520(sp)
    8000503e:	20013403          	ld	s0,512(sp)
    80005042:	74fe                	ld	s1,504(sp)
    80005044:	795e                	ld	s2,496(sp)
    80005046:	21010113          	addi	sp,sp,528
    8000504a:	8082                	ret
    end_op();
    8000504c:	bceff0ef          	jal	8000441a <end_op>
    return -1;
    80005050:	557d                	li	a0,-1
    80005052:	b7e5                	j	8000503a <kexec+0x6e>
    80005054:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005056:	8526                	mv	a0,s1
    80005058:	97dfc0ef          	jal	800019d4 <proc_pagetable>
    8000505c:	8b2a                	mv	s6,a0
    8000505e:	2c050b63          	beqz	a0,80005334 <kexec+0x368>
    80005062:	f7ce                	sd	s3,488(sp)
    80005064:	efd6                	sd	s5,472(sp)
    80005066:	e7de                	sd	s7,456(sp)
    80005068:	e3e2                	sd	s8,448(sp)
    8000506a:	ff66                	sd	s9,440(sp)
    8000506c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000506e:	e7042d03          	lw	s10,-400(s0)
    80005072:	e8845783          	lhu	a5,-376(s0)
    80005076:	12078963          	beqz	a5,800051a8 <kexec+0x1dc>
    8000507a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000507c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000507e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005080:	6c85                	lui	s9,0x1
    80005082:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005086:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000508a:	6a85                	lui	s5,0x1
    8000508c:	a085                	j	800050ec <kexec+0x120>
      panic("loadseg: address should exist");
    8000508e:	00003517          	auipc	a0,0x3
    80005092:	77a50513          	addi	a0,a0,1914 # 80008808 <etext+0x808>
    80005096:	f4afb0ef          	jal	800007e0 <panic>
    if(sz - i < PGSIZE)
    8000509a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000509c:	8726                	mv	a4,s1
    8000509e:	012c06bb          	addw	a3,s8,s2
    800050a2:	4581                	li	a1,0
    800050a4:	8552                	mv	a0,s4
    800050a6:	cb1fe0ef          	jal	80003d56 <readi>
    800050aa:	2501                	sext.w	a0,a0
    800050ac:	24a49a63          	bne	s1,a0,80005300 <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800050b0:	012a893b          	addw	s2,s5,s2
    800050b4:	03397363          	bgeu	s2,s3,800050da <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800050b8:	02091593          	slli	a1,s2,0x20
    800050bc:	9181                	srli	a1,a1,0x20
    800050be:	95de                	add	a1,a1,s7
    800050c0:	855a                	mv	a0,s6
    800050c2:	eeffb0ef          	jal	80000fb0 <walkaddr>
    800050c6:	862a                	mv	a2,a0
    if(pa == 0)
    800050c8:	d179                	beqz	a0,8000508e <kexec+0xc2>
    if(sz - i < PGSIZE)
    800050ca:	412984bb          	subw	s1,s3,s2
    800050ce:	0004879b          	sext.w	a5,s1
    800050d2:	fcfcf4e3          	bgeu	s9,a5,8000509a <kexec+0xce>
    800050d6:	84d6                	mv	s1,s5
    800050d8:	b7c9                	j	8000509a <kexec+0xce>
    sz = sz1;
    800050da:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800050de:	2d85                	addiw	s11,s11,1
    800050e0:	038d0d1b          	addiw	s10,s10,56
    800050e4:	e8845783          	lhu	a5,-376(s0)
    800050e8:	08fdd063          	bge	s11,a5,80005168 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800050ec:	2d01                	sext.w	s10,s10
    800050ee:	03800713          	li	a4,56
    800050f2:	86ea                	mv	a3,s10
    800050f4:	e1840613          	addi	a2,s0,-488
    800050f8:	4581                	li	a1,0
    800050fa:	8552                	mv	a0,s4
    800050fc:	c5bfe0ef          	jal	80003d56 <readi>
    80005100:	03800793          	li	a5,56
    80005104:	1cf51663          	bne	a0,a5,800052d0 <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80005108:	e1842783          	lw	a5,-488(s0)
    8000510c:	4705                	li	a4,1
    8000510e:	fce798e3          	bne	a5,a4,800050de <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80005112:	e4043483          	ld	s1,-448(s0)
    80005116:	e3843783          	ld	a5,-456(s0)
    8000511a:	1af4ef63          	bltu	s1,a5,800052d8 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000511e:	e2843783          	ld	a5,-472(s0)
    80005122:	94be                	add	s1,s1,a5
    80005124:	1af4ee63          	bltu	s1,a5,800052e0 <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80005128:	df043703          	ld	a4,-528(s0)
    8000512c:	8ff9                	and	a5,a5,a4
    8000512e:	1a079d63          	bnez	a5,800052e8 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005132:	e1c42503          	lw	a0,-484(s0)
    80005136:	e7dff0ef          	jal	80004fb2 <flags2perm>
    8000513a:	86aa                	mv	a3,a0
    8000513c:	8626                	mv	a2,s1
    8000513e:	85ca                	mv	a1,s2
    80005140:	855a                	mv	a0,s6
    80005142:	946fc0ef          	jal	80001288 <uvmalloc>
    80005146:	e0a43423          	sd	a0,-504(s0)
    8000514a:	1a050363          	beqz	a0,800052f0 <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000514e:	e2843b83          	ld	s7,-472(s0)
    80005152:	e2042c03          	lw	s8,-480(s0)
    80005156:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000515a:	00098463          	beqz	s3,80005162 <kexec+0x196>
    8000515e:	4901                	li	s2,0
    80005160:	bfa1                	j	800050b8 <kexec+0xec>
    sz = sz1;
    80005162:	e0843903          	ld	s2,-504(s0)
    80005166:	bfa5                	j	800050de <kexec+0x112>
    80005168:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000516a:	8552                	mv	a0,s4
    8000516c:	a65fe0ef          	jal	80003bd0 <iunlockput>
  end_op();
    80005170:	aaaff0ef          	jal	8000441a <end_op>
  p = myproc();
    80005174:	f5afc0ef          	jal	800018ce <myproc>
    80005178:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000517a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000517e:	6985                	lui	s3,0x1
    80005180:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005182:	99ca                	add	s3,s3,s2
    80005184:	77fd                	lui	a5,0xfffff
    80005186:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000518a:	4691                	li	a3,4
    8000518c:	6609                	lui	a2,0x2
    8000518e:	964e                	add	a2,a2,s3
    80005190:	85ce                	mv	a1,s3
    80005192:	855a                	mv	a0,s6
    80005194:	8f4fc0ef          	jal	80001288 <uvmalloc>
    80005198:	892a                	mv	s2,a0
    8000519a:	e0a43423          	sd	a0,-504(s0)
    8000519e:	e519                	bnez	a0,800051ac <kexec+0x1e0>
  if(pagetable)
    800051a0:	e1343423          	sd	s3,-504(s0)
    800051a4:	4a01                	li	s4,0
    800051a6:	aab1                	j	80005302 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800051a8:	4901                	li	s2,0
    800051aa:	b7c1                	j	8000516a <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800051ac:	75f9                	lui	a1,0xffffe
    800051ae:	95aa                	add	a1,a1,a0
    800051b0:	855a                	mv	a0,s6
    800051b2:	aacfc0ef          	jal	8000145e <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800051b6:	7bfd                	lui	s7,0xfffff
    800051b8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800051ba:	e0043783          	ld	a5,-512(s0)
    800051be:	6388                	ld	a0,0(a5)
    800051c0:	cd39                	beqz	a0,8000521e <kexec+0x252>
    800051c2:	e9040993          	addi	s3,s0,-368
    800051c6:	f9040c13          	addi	s8,s0,-112
    800051ca:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800051cc:	c47fb0ef          	jal	80000e12 <strlen>
    800051d0:	0015079b          	addiw	a5,a0,1
    800051d4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800051d8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800051dc:	11796e63          	bltu	s2,s7,800052f8 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800051e0:	e0043d03          	ld	s10,-512(s0)
    800051e4:	000d3a03          	ld	s4,0(s10)
    800051e8:	8552                	mv	a0,s4
    800051ea:	c29fb0ef          	jal	80000e12 <strlen>
    800051ee:	0015069b          	addiw	a3,a0,1
    800051f2:	8652                	mv	a2,s4
    800051f4:	85ca                	mv	a1,s2
    800051f6:	855a                	mv	a0,s6
    800051f8:	beafc0ef          	jal	800015e2 <copyout>
    800051fc:	10054063          	bltz	a0,800052fc <kexec+0x330>
    ustack[argc] = sp;
    80005200:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005204:	0485                	addi	s1,s1,1
    80005206:	008d0793          	addi	a5,s10,8
    8000520a:	e0f43023          	sd	a5,-512(s0)
    8000520e:	008d3503          	ld	a0,8(s10)
    80005212:	c909                	beqz	a0,80005224 <kexec+0x258>
    if(argc >= MAXARG)
    80005214:	09a1                	addi	s3,s3,8
    80005216:	fb899be3          	bne	s3,s8,800051cc <kexec+0x200>
  ip = 0;
    8000521a:	4a01                	li	s4,0
    8000521c:	a0dd                	j	80005302 <kexec+0x336>
  sp = sz;
    8000521e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005222:	4481                	li	s1,0
  ustack[argc] = 0;
    80005224:	00349793          	slli	a5,s1,0x3
    80005228:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd86a8>
    8000522c:	97a2                	add	a5,a5,s0
    8000522e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005232:	00148693          	addi	a3,s1,1
    80005236:	068e                	slli	a3,a3,0x3
    80005238:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000523c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005240:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005244:	f5796ee3          	bltu	s2,s7,800051a0 <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005248:	e9040613          	addi	a2,s0,-368
    8000524c:	85ca                	mv	a1,s2
    8000524e:	855a                	mv	a0,s6
    80005250:	b92fc0ef          	jal	800015e2 <copyout>
    80005254:	0e054263          	bltz	a0,80005338 <kexec+0x36c>
  p->trapframe->a1 = sp;
    80005258:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000525c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005260:	df843783          	ld	a5,-520(s0)
    80005264:	0007c703          	lbu	a4,0(a5)
    80005268:	cf11                	beqz	a4,80005284 <kexec+0x2b8>
    8000526a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000526c:	02f00693          	li	a3,47
    80005270:	a039                	j	8000527e <kexec+0x2b2>
      last = s+1;
    80005272:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005276:	0785                	addi	a5,a5,1
    80005278:	fff7c703          	lbu	a4,-1(a5)
    8000527c:	c701                	beqz	a4,80005284 <kexec+0x2b8>
    if(*s == '/')
    8000527e:	fed71ce3          	bne	a4,a3,80005276 <kexec+0x2aa>
    80005282:	bfc5                	j	80005272 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80005284:	4641                	li	a2,16
    80005286:	df843583          	ld	a1,-520(s0)
    8000528a:	158a8513          	addi	a0,s5,344
    8000528e:	b53fb0ef          	jal	80000de0 <safestrcpy>
  oldpagetable = p->pagetable;
    80005292:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005296:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000529a:	e0843783          	ld	a5,-504(s0)
    8000529e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    800052a2:	058ab783          	ld	a5,88(s5)
    800052a6:	e6843703          	ld	a4,-408(s0)
    800052aa:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800052ac:	058ab783          	ld	a5,88(s5)
    800052b0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800052b4:	85e6                	mv	a1,s9
    800052b6:	fa2fc0ef          	jal	80001a58 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800052ba:	0004851b          	sext.w	a0,s1
    800052be:	79be                	ld	s3,488(sp)
    800052c0:	7a1e                	ld	s4,480(sp)
    800052c2:	6afe                	ld	s5,472(sp)
    800052c4:	6b5e                	ld	s6,464(sp)
    800052c6:	6bbe                	ld	s7,456(sp)
    800052c8:	6c1e                	ld	s8,448(sp)
    800052ca:	7cfa                	ld	s9,440(sp)
    800052cc:	7d5a                	ld	s10,432(sp)
    800052ce:	b3b5                	j	8000503a <kexec+0x6e>
    800052d0:	e1243423          	sd	s2,-504(s0)
    800052d4:	7dba                	ld	s11,424(sp)
    800052d6:	a035                	j	80005302 <kexec+0x336>
    800052d8:	e1243423          	sd	s2,-504(s0)
    800052dc:	7dba                	ld	s11,424(sp)
    800052de:	a015                	j	80005302 <kexec+0x336>
    800052e0:	e1243423          	sd	s2,-504(s0)
    800052e4:	7dba                	ld	s11,424(sp)
    800052e6:	a831                	j	80005302 <kexec+0x336>
    800052e8:	e1243423          	sd	s2,-504(s0)
    800052ec:	7dba                	ld	s11,424(sp)
    800052ee:	a811                	j	80005302 <kexec+0x336>
    800052f0:	e1243423          	sd	s2,-504(s0)
    800052f4:	7dba                	ld	s11,424(sp)
    800052f6:	a031                	j	80005302 <kexec+0x336>
  ip = 0;
    800052f8:	4a01                	li	s4,0
    800052fa:	a021                	j	80005302 <kexec+0x336>
    800052fc:	4a01                	li	s4,0
  if(pagetable)
    800052fe:	a011                	j	80005302 <kexec+0x336>
    80005300:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80005302:	e0843583          	ld	a1,-504(s0)
    80005306:	855a                	mv	a0,s6
    80005308:	f50fc0ef          	jal	80001a58 <proc_freepagetable>
  return -1;
    8000530c:	557d                	li	a0,-1
  if(ip){
    8000530e:	000a1b63          	bnez	s4,80005324 <kexec+0x358>
    80005312:	79be                	ld	s3,488(sp)
    80005314:	7a1e                	ld	s4,480(sp)
    80005316:	6afe                	ld	s5,472(sp)
    80005318:	6b5e                	ld	s6,464(sp)
    8000531a:	6bbe                	ld	s7,456(sp)
    8000531c:	6c1e                	ld	s8,448(sp)
    8000531e:	7cfa                	ld	s9,440(sp)
    80005320:	7d5a                	ld	s10,432(sp)
    80005322:	bb21                	j	8000503a <kexec+0x6e>
    80005324:	79be                	ld	s3,488(sp)
    80005326:	6afe                	ld	s5,472(sp)
    80005328:	6b5e                	ld	s6,464(sp)
    8000532a:	6bbe                	ld	s7,456(sp)
    8000532c:	6c1e                	ld	s8,448(sp)
    8000532e:	7cfa                	ld	s9,440(sp)
    80005330:	7d5a                	ld	s10,432(sp)
    80005332:	b9ed                	j	8000502c <kexec+0x60>
    80005334:	6b5e                	ld	s6,464(sp)
    80005336:	b9dd                	j	8000502c <kexec+0x60>
  sz = sz1;
    80005338:	e0843983          	ld	s3,-504(s0)
    8000533c:	b595                	j	800051a0 <kexec+0x1d4>

000000008000533e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000533e:	7179                	addi	sp,sp,-48
    80005340:	f406                	sd	ra,40(sp)
    80005342:	f022                	sd	s0,32(sp)
    80005344:	ec26                	sd	s1,24(sp)
    80005346:	e84a                	sd	s2,16(sp)
    80005348:	1800                	addi	s0,sp,48
    8000534a:	892e                	mv	s2,a1
    8000534c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000534e:	fdc40593          	addi	a1,s0,-36
    80005352:	ad3fd0ef          	jal	80002e24 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005356:	fdc42703          	lw	a4,-36(s0)
    8000535a:	47bd                	li	a5,15
    8000535c:	02e7e963          	bltu	a5,a4,8000538e <argfd+0x50>
    80005360:	d6efc0ef          	jal	800018ce <myproc>
    80005364:	fdc42703          	lw	a4,-36(s0)
    80005368:	01a70793          	addi	a5,a4,26
    8000536c:	078e                	slli	a5,a5,0x3
    8000536e:	953e                	add	a0,a0,a5
    80005370:	611c                	ld	a5,0(a0)
    80005372:	c385                	beqz	a5,80005392 <argfd+0x54>
    return -1;
  if(pfd)
    80005374:	00090463          	beqz	s2,8000537c <argfd+0x3e>
    *pfd = fd;
    80005378:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000537c:	4501                	li	a0,0
  if(pf)
    8000537e:	c091                	beqz	s1,80005382 <argfd+0x44>
    *pf = f;
    80005380:	e09c                	sd	a5,0(s1)
}
    80005382:	70a2                	ld	ra,40(sp)
    80005384:	7402                	ld	s0,32(sp)
    80005386:	64e2                	ld	s1,24(sp)
    80005388:	6942                	ld	s2,16(sp)
    8000538a:	6145                	addi	sp,sp,48
    8000538c:	8082                	ret
    return -1;
    8000538e:	557d                	li	a0,-1
    80005390:	bfcd                	j	80005382 <argfd+0x44>
    80005392:	557d                	li	a0,-1
    80005394:	b7fd                	j	80005382 <argfd+0x44>

0000000080005396 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005396:	1101                	addi	sp,sp,-32
    80005398:	ec06                	sd	ra,24(sp)
    8000539a:	e822                	sd	s0,16(sp)
    8000539c:	e426                	sd	s1,8(sp)
    8000539e:	1000                	addi	s0,sp,32
    800053a0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800053a2:	d2cfc0ef          	jal	800018ce <myproc>
    800053a6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800053a8:	0d050793          	addi	a5,a0,208
    800053ac:	4501                	li	a0,0
    800053ae:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800053b0:	6398                	ld	a4,0(a5)
    800053b2:	cb19                	beqz	a4,800053c8 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800053b4:	2505                	addiw	a0,a0,1
    800053b6:	07a1                	addi	a5,a5,8
    800053b8:	fed51ce3          	bne	a0,a3,800053b0 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800053bc:	557d                	li	a0,-1
}
    800053be:	60e2                	ld	ra,24(sp)
    800053c0:	6442                	ld	s0,16(sp)
    800053c2:	64a2                	ld	s1,8(sp)
    800053c4:	6105                	addi	sp,sp,32
    800053c6:	8082                	ret
      p->ofile[fd] = f;
    800053c8:	01a50793          	addi	a5,a0,26
    800053cc:	078e                	slli	a5,a5,0x3
    800053ce:	963e                	add	a2,a2,a5
    800053d0:	e204                	sd	s1,0(a2)
      return fd;
    800053d2:	b7f5                	j	800053be <fdalloc+0x28>

00000000800053d4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800053d4:	715d                	addi	sp,sp,-80
    800053d6:	e486                	sd	ra,72(sp)
    800053d8:	e0a2                	sd	s0,64(sp)
    800053da:	fc26                	sd	s1,56(sp)
    800053dc:	f84a                	sd	s2,48(sp)
    800053de:	f44e                	sd	s3,40(sp)
    800053e0:	ec56                	sd	s5,24(sp)
    800053e2:	e85a                	sd	s6,16(sp)
    800053e4:	0880                	addi	s0,sp,80
    800053e6:	8b2e                	mv	s6,a1
    800053e8:	89b2                	mv	s3,a2
    800053ea:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800053ec:	fb040593          	addi	a1,s0,-80
    800053f0:	e07fe0ef          	jal	800041f6 <nameiparent>
    800053f4:	84aa                	mv	s1,a0
    800053f6:	10050a63          	beqz	a0,8000550a <create+0x136>
    return 0;

  ilock(dp);
    800053fa:	dccfe0ef          	jal	800039c6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800053fe:	4601                	li	a2,0
    80005400:	fb040593          	addi	a1,s0,-80
    80005404:	8526                	mv	a0,s1
    80005406:	b71fe0ef          	jal	80003f76 <dirlookup>
    8000540a:	8aaa                	mv	s5,a0
    8000540c:	c129                	beqz	a0,8000544e <create+0x7a>
    iunlockput(dp);
    8000540e:	8526                	mv	a0,s1
    80005410:	fc0fe0ef          	jal	80003bd0 <iunlockput>
    ilock(ip);
    80005414:	8556                	mv	a0,s5
    80005416:	db0fe0ef          	jal	800039c6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000541a:	4789                	li	a5,2
    8000541c:	02fb1463          	bne	s6,a5,80005444 <create+0x70>
    80005420:	044ad783          	lhu	a5,68(s5)
    80005424:	37f9                	addiw	a5,a5,-2
    80005426:	17c2                	slli	a5,a5,0x30
    80005428:	93c1                	srli	a5,a5,0x30
    8000542a:	4705                	li	a4,1
    8000542c:	00f76c63          	bltu	a4,a5,80005444 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005430:	8556                	mv	a0,s5
    80005432:	60a6                	ld	ra,72(sp)
    80005434:	6406                	ld	s0,64(sp)
    80005436:	74e2                	ld	s1,56(sp)
    80005438:	7942                	ld	s2,48(sp)
    8000543a:	79a2                	ld	s3,40(sp)
    8000543c:	6ae2                	ld	s5,24(sp)
    8000543e:	6b42                	ld	s6,16(sp)
    80005440:	6161                	addi	sp,sp,80
    80005442:	8082                	ret
    iunlockput(ip);
    80005444:	8556                	mv	a0,s5
    80005446:	f8afe0ef          	jal	80003bd0 <iunlockput>
    return 0;
    8000544a:	4a81                	li	s5,0
    8000544c:	b7d5                	j	80005430 <create+0x5c>
    8000544e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005450:	85da                	mv	a1,s6
    80005452:	4088                	lw	a0,0(s1)
    80005454:	c02fe0ef          	jal	80003856 <ialloc>
    80005458:	8a2a                	mv	s4,a0
    8000545a:	cd15                	beqz	a0,80005496 <create+0xc2>
  ilock(ip);
    8000545c:	d6afe0ef          	jal	800039c6 <ilock>
  ip->major = major;
    80005460:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005464:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005468:	4905                	li	s2,1
    8000546a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000546e:	8552                	mv	a0,s4
    80005470:	ca2fe0ef          	jal	80003912 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005474:	032b0763          	beq	s6,s2,800054a2 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80005478:	004a2603          	lw	a2,4(s4)
    8000547c:	fb040593          	addi	a1,s0,-80
    80005480:	8526                	mv	a0,s1
    80005482:	cc1fe0ef          	jal	80004142 <dirlink>
    80005486:	06054563          	bltz	a0,800054f0 <create+0x11c>
  iunlockput(dp);
    8000548a:	8526                	mv	a0,s1
    8000548c:	f44fe0ef          	jal	80003bd0 <iunlockput>
  return ip;
    80005490:	8ad2                	mv	s5,s4
    80005492:	7a02                	ld	s4,32(sp)
    80005494:	bf71                	j	80005430 <create+0x5c>
    iunlockput(dp);
    80005496:	8526                	mv	a0,s1
    80005498:	f38fe0ef          	jal	80003bd0 <iunlockput>
    return 0;
    8000549c:	8ad2                	mv	s5,s4
    8000549e:	7a02                	ld	s4,32(sp)
    800054a0:	bf41                	j	80005430 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800054a2:	004a2603          	lw	a2,4(s4)
    800054a6:	00003597          	auipc	a1,0x3
    800054aa:	38258593          	addi	a1,a1,898 # 80008828 <etext+0x828>
    800054ae:	8552                	mv	a0,s4
    800054b0:	c93fe0ef          	jal	80004142 <dirlink>
    800054b4:	02054e63          	bltz	a0,800054f0 <create+0x11c>
    800054b8:	40d0                	lw	a2,4(s1)
    800054ba:	00003597          	auipc	a1,0x3
    800054be:	37658593          	addi	a1,a1,886 # 80008830 <etext+0x830>
    800054c2:	8552                	mv	a0,s4
    800054c4:	c7ffe0ef          	jal	80004142 <dirlink>
    800054c8:	02054463          	bltz	a0,800054f0 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800054cc:	004a2603          	lw	a2,4(s4)
    800054d0:	fb040593          	addi	a1,s0,-80
    800054d4:	8526                	mv	a0,s1
    800054d6:	c6dfe0ef          	jal	80004142 <dirlink>
    800054da:	00054b63          	bltz	a0,800054f0 <create+0x11c>
    dp->nlink++;  // for ".."
    800054de:	04a4d783          	lhu	a5,74(s1)
    800054e2:	2785                	addiw	a5,a5,1
    800054e4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800054e8:	8526                	mv	a0,s1
    800054ea:	c28fe0ef          	jal	80003912 <iupdate>
    800054ee:	bf71                	j	8000548a <create+0xb6>
  ip->nlink = 0;
    800054f0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800054f4:	8552                	mv	a0,s4
    800054f6:	c1cfe0ef          	jal	80003912 <iupdate>
  iunlockput(ip);
    800054fa:	8552                	mv	a0,s4
    800054fc:	ed4fe0ef          	jal	80003bd0 <iunlockput>
  iunlockput(dp);
    80005500:	8526                	mv	a0,s1
    80005502:	ecefe0ef          	jal	80003bd0 <iunlockput>
  return 0;
    80005506:	7a02                	ld	s4,32(sp)
    80005508:	b725                	j	80005430 <create+0x5c>
    return 0;
    8000550a:	8aaa                	mv	s5,a0
    8000550c:	b715                	j	80005430 <create+0x5c>

000000008000550e <sys_dup>:
{
    8000550e:	7179                	addi	sp,sp,-48
    80005510:	f406                	sd	ra,40(sp)
    80005512:	f022                	sd	s0,32(sp)
    80005514:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005516:	fd840613          	addi	a2,s0,-40
    8000551a:	4581                	li	a1,0
    8000551c:	4501                	li	a0,0
    8000551e:	e21ff0ef          	jal	8000533e <argfd>
    return -1;
    80005522:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005524:	02054363          	bltz	a0,8000554a <sys_dup+0x3c>
    80005528:	ec26                	sd	s1,24(sp)
    8000552a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000552c:	fd843903          	ld	s2,-40(s0)
    80005530:	854a                	mv	a0,s2
    80005532:	e65ff0ef          	jal	80005396 <fdalloc>
    80005536:	84aa                	mv	s1,a0
    return -1;
    80005538:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000553a:	00054d63          	bltz	a0,80005554 <sys_dup+0x46>
  filedup(f);
    8000553e:	854a                	mv	a0,s2
    80005540:	bd4ff0ef          	jal	80004914 <filedup>
  return fd;
    80005544:	87a6                	mv	a5,s1
    80005546:	64e2                	ld	s1,24(sp)
    80005548:	6942                	ld	s2,16(sp)
}
    8000554a:	853e                	mv	a0,a5
    8000554c:	70a2                	ld	ra,40(sp)
    8000554e:	7402                	ld	s0,32(sp)
    80005550:	6145                	addi	sp,sp,48
    80005552:	8082                	ret
    80005554:	64e2                	ld	s1,24(sp)
    80005556:	6942                	ld	s2,16(sp)
    80005558:	bfcd                	j	8000554a <sys_dup+0x3c>

000000008000555a <sys_read>:
{
    8000555a:	7179                	addi	sp,sp,-48
    8000555c:	f406                	sd	ra,40(sp)
    8000555e:	f022                	sd	s0,32(sp)
    80005560:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005562:	fd840593          	addi	a1,s0,-40
    80005566:	4505                	li	a0,1
    80005568:	8d9fd0ef          	jal	80002e40 <argaddr>
  argint(2, &n);
    8000556c:	fe440593          	addi	a1,s0,-28
    80005570:	4509                	li	a0,2
    80005572:	8b3fd0ef          	jal	80002e24 <argint>
  if(argfd(0, 0, &f) < 0)
    80005576:	fe840613          	addi	a2,s0,-24
    8000557a:	4581                	li	a1,0
    8000557c:	4501                	li	a0,0
    8000557e:	dc1ff0ef          	jal	8000533e <argfd>
    80005582:	87aa                	mv	a5,a0
    return -1;
    80005584:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005586:	0007ca63          	bltz	a5,8000559a <sys_read+0x40>
  return fileread(f, p, n);
    8000558a:	fe442603          	lw	a2,-28(s0)
    8000558e:	fd843583          	ld	a1,-40(s0)
    80005592:	fe843503          	ld	a0,-24(s0)
    80005596:	ce4ff0ef          	jal	80004a7a <fileread>
}
    8000559a:	70a2                	ld	ra,40(sp)
    8000559c:	7402                	ld	s0,32(sp)
    8000559e:	6145                	addi	sp,sp,48
    800055a0:	8082                	ret

00000000800055a2 <sys_write>:
{
    800055a2:	7179                	addi	sp,sp,-48
    800055a4:	f406                	sd	ra,40(sp)
    800055a6:	f022                	sd	s0,32(sp)
    800055a8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800055aa:	fd840593          	addi	a1,s0,-40
    800055ae:	4505                	li	a0,1
    800055b0:	891fd0ef          	jal	80002e40 <argaddr>
  argint(2, &n);
    800055b4:	fe440593          	addi	a1,s0,-28
    800055b8:	4509                	li	a0,2
    800055ba:	86bfd0ef          	jal	80002e24 <argint>
  if(argfd(0, 0, &f) < 0)
    800055be:	fe840613          	addi	a2,s0,-24
    800055c2:	4581                	li	a1,0
    800055c4:	4501                	li	a0,0
    800055c6:	d79ff0ef          	jal	8000533e <argfd>
    800055ca:	87aa                	mv	a5,a0
    return -1;
    800055cc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800055ce:	0007ca63          	bltz	a5,800055e2 <sys_write+0x40>
  return filewrite(f, p, n);
    800055d2:	fe442603          	lw	a2,-28(s0)
    800055d6:	fd843583          	ld	a1,-40(s0)
    800055da:	fe843503          	ld	a0,-24(s0)
    800055de:	d5aff0ef          	jal	80004b38 <filewrite>
}
    800055e2:	70a2                	ld	ra,40(sp)
    800055e4:	7402                	ld	s0,32(sp)
    800055e6:	6145                	addi	sp,sp,48
    800055e8:	8082                	ret

00000000800055ea <sys_close>:
{
    800055ea:	1101                	addi	sp,sp,-32
    800055ec:	ec06                	sd	ra,24(sp)
    800055ee:	e822                	sd	s0,16(sp)
    800055f0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800055f2:	fe040613          	addi	a2,s0,-32
    800055f6:	fec40593          	addi	a1,s0,-20
    800055fa:	4501                	li	a0,0
    800055fc:	d43ff0ef          	jal	8000533e <argfd>
    return -1;
    80005600:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005602:	02054063          	bltz	a0,80005622 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80005606:	ac8fc0ef          	jal	800018ce <myproc>
    8000560a:	fec42783          	lw	a5,-20(s0)
    8000560e:	07e9                	addi	a5,a5,26
    80005610:	078e                	slli	a5,a5,0x3
    80005612:	953e                	add	a0,a0,a5
    80005614:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005618:	fe043503          	ld	a0,-32(s0)
    8000561c:	b3eff0ef          	jal	8000495a <fileclose>
  return 0;
    80005620:	4781                	li	a5,0
}
    80005622:	853e                	mv	a0,a5
    80005624:	60e2                	ld	ra,24(sp)
    80005626:	6442                	ld	s0,16(sp)
    80005628:	6105                	addi	sp,sp,32
    8000562a:	8082                	ret

000000008000562c <sys_fstat>:
{
    8000562c:	1101                	addi	sp,sp,-32
    8000562e:	ec06                	sd	ra,24(sp)
    80005630:	e822                	sd	s0,16(sp)
    80005632:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005634:	fe040593          	addi	a1,s0,-32
    80005638:	4505                	li	a0,1
    8000563a:	807fd0ef          	jal	80002e40 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000563e:	fe840613          	addi	a2,s0,-24
    80005642:	4581                	li	a1,0
    80005644:	4501                	li	a0,0
    80005646:	cf9ff0ef          	jal	8000533e <argfd>
    8000564a:	87aa                	mv	a5,a0
    return -1;
    8000564c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000564e:	0007c863          	bltz	a5,8000565e <sys_fstat+0x32>
  return filestat(f, st);
    80005652:	fe043583          	ld	a1,-32(s0)
    80005656:	fe843503          	ld	a0,-24(s0)
    8000565a:	bc2ff0ef          	jal	80004a1c <filestat>
}
    8000565e:	60e2                	ld	ra,24(sp)
    80005660:	6442                	ld	s0,16(sp)
    80005662:	6105                	addi	sp,sp,32
    80005664:	8082                	ret

0000000080005666 <sys_link>:
{
    80005666:	7169                	addi	sp,sp,-304
    80005668:	f606                	sd	ra,296(sp)
    8000566a:	f222                	sd	s0,288(sp)
    8000566c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000566e:	08000613          	li	a2,128
    80005672:	ed040593          	addi	a1,s0,-304
    80005676:	4501                	li	a0,0
    80005678:	fe4fd0ef          	jal	80002e5c <argstr>
    return -1;
    8000567c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000567e:	0c054e63          	bltz	a0,8000575a <sys_link+0xf4>
    80005682:	08000613          	li	a2,128
    80005686:	f5040593          	addi	a1,s0,-176
    8000568a:	4505                	li	a0,1
    8000568c:	fd0fd0ef          	jal	80002e5c <argstr>
    return -1;
    80005690:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005692:	0c054463          	bltz	a0,8000575a <sys_link+0xf4>
    80005696:	ee26                	sd	s1,280(sp)
  begin_op();
    80005698:	d19fe0ef          	jal	800043b0 <begin_op>
  if((ip = namei(old)) == 0){
    8000569c:	ed040513          	addi	a0,s0,-304
    800056a0:	b3dfe0ef          	jal	800041dc <namei>
    800056a4:	84aa                	mv	s1,a0
    800056a6:	c53d                	beqz	a0,80005714 <sys_link+0xae>
  ilock(ip);
    800056a8:	b1efe0ef          	jal	800039c6 <ilock>
  if(ip->type == T_DIR){
    800056ac:	04449703          	lh	a4,68(s1)
    800056b0:	4785                	li	a5,1
    800056b2:	06f70663          	beq	a4,a5,8000571e <sys_link+0xb8>
    800056b6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800056b8:	04a4d783          	lhu	a5,74(s1)
    800056bc:	2785                	addiw	a5,a5,1
    800056be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800056c2:	8526                	mv	a0,s1
    800056c4:	a4efe0ef          	jal	80003912 <iupdate>
  iunlock(ip);
    800056c8:	8526                	mv	a0,s1
    800056ca:	baafe0ef          	jal	80003a74 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800056ce:	fd040593          	addi	a1,s0,-48
    800056d2:	f5040513          	addi	a0,s0,-176
    800056d6:	b21fe0ef          	jal	800041f6 <nameiparent>
    800056da:	892a                	mv	s2,a0
    800056dc:	cd21                	beqz	a0,80005734 <sys_link+0xce>
  ilock(dp);
    800056de:	ae8fe0ef          	jal	800039c6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800056e2:	00092703          	lw	a4,0(s2)
    800056e6:	409c                	lw	a5,0(s1)
    800056e8:	04f71363          	bne	a4,a5,8000572e <sys_link+0xc8>
    800056ec:	40d0                	lw	a2,4(s1)
    800056ee:	fd040593          	addi	a1,s0,-48
    800056f2:	854a                	mv	a0,s2
    800056f4:	a4ffe0ef          	jal	80004142 <dirlink>
    800056f8:	02054b63          	bltz	a0,8000572e <sys_link+0xc8>
  iunlockput(dp);
    800056fc:	854a                	mv	a0,s2
    800056fe:	cd2fe0ef          	jal	80003bd0 <iunlockput>
  iput(ip);
    80005702:	8526                	mv	a0,s1
    80005704:	c44fe0ef          	jal	80003b48 <iput>
  end_op();
    80005708:	d13fe0ef          	jal	8000441a <end_op>
  return 0;
    8000570c:	4781                	li	a5,0
    8000570e:	64f2                	ld	s1,280(sp)
    80005710:	6952                	ld	s2,272(sp)
    80005712:	a0a1                	j	8000575a <sys_link+0xf4>
    end_op();
    80005714:	d07fe0ef          	jal	8000441a <end_op>
    return -1;
    80005718:	57fd                	li	a5,-1
    8000571a:	64f2                	ld	s1,280(sp)
    8000571c:	a83d                	j	8000575a <sys_link+0xf4>
    iunlockput(ip);
    8000571e:	8526                	mv	a0,s1
    80005720:	cb0fe0ef          	jal	80003bd0 <iunlockput>
    end_op();
    80005724:	cf7fe0ef          	jal	8000441a <end_op>
    return -1;
    80005728:	57fd                	li	a5,-1
    8000572a:	64f2                	ld	s1,280(sp)
    8000572c:	a03d                	j	8000575a <sys_link+0xf4>
    iunlockput(dp);
    8000572e:	854a                	mv	a0,s2
    80005730:	ca0fe0ef          	jal	80003bd0 <iunlockput>
  ilock(ip);
    80005734:	8526                	mv	a0,s1
    80005736:	a90fe0ef          	jal	800039c6 <ilock>
  ip->nlink--;
    8000573a:	04a4d783          	lhu	a5,74(s1)
    8000573e:	37fd                	addiw	a5,a5,-1
    80005740:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005744:	8526                	mv	a0,s1
    80005746:	9ccfe0ef          	jal	80003912 <iupdate>
  iunlockput(ip);
    8000574a:	8526                	mv	a0,s1
    8000574c:	c84fe0ef          	jal	80003bd0 <iunlockput>
  end_op();
    80005750:	ccbfe0ef          	jal	8000441a <end_op>
  return -1;
    80005754:	57fd                	li	a5,-1
    80005756:	64f2                	ld	s1,280(sp)
    80005758:	6952                	ld	s2,272(sp)
}
    8000575a:	853e                	mv	a0,a5
    8000575c:	70b2                	ld	ra,296(sp)
    8000575e:	7412                	ld	s0,288(sp)
    80005760:	6155                	addi	sp,sp,304
    80005762:	8082                	ret

0000000080005764 <sys_unlink>:
{
    80005764:	7151                	addi	sp,sp,-240
    80005766:	f586                	sd	ra,232(sp)
    80005768:	f1a2                	sd	s0,224(sp)
    8000576a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000576c:	08000613          	li	a2,128
    80005770:	f3040593          	addi	a1,s0,-208
    80005774:	4501                	li	a0,0
    80005776:	ee6fd0ef          	jal	80002e5c <argstr>
    8000577a:	16054063          	bltz	a0,800058da <sys_unlink+0x176>
    8000577e:	eda6                	sd	s1,216(sp)
  begin_op();
    80005780:	c31fe0ef          	jal	800043b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005784:	fb040593          	addi	a1,s0,-80
    80005788:	f3040513          	addi	a0,s0,-208
    8000578c:	a6bfe0ef          	jal	800041f6 <nameiparent>
    80005790:	84aa                	mv	s1,a0
    80005792:	c945                	beqz	a0,80005842 <sys_unlink+0xde>
  ilock(dp);
    80005794:	a32fe0ef          	jal	800039c6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005798:	00003597          	auipc	a1,0x3
    8000579c:	09058593          	addi	a1,a1,144 # 80008828 <etext+0x828>
    800057a0:	fb040513          	addi	a0,s0,-80
    800057a4:	fbcfe0ef          	jal	80003f60 <namecmp>
    800057a8:	10050e63          	beqz	a0,800058c4 <sys_unlink+0x160>
    800057ac:	00003597          	auipc	a1,0x3
    800057b0:	08458593          	addi	a1,a1,132 # 80008830 <etext+0x830>
    800057b4:	fb040513          	addi	a0,s0,-80
    800057b8:	fa8fe0ef          	jal	80003f60 <namecmp>
    800057bc:	10050463          	beqz	a0,800058c4 <sys_unlink+0x160>
    800057c0:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800057c2:	f2c40613          	addi	a2,s0,-212
    800057c6:	fb040593          	addi	a1,s0,-80
    800057ca:	8526                	mv	a0,s1
    800057cc:	faafe0ef          	jal	80003f76 <dirlookup>
    800057d0:	892a                	mv	s2,a0
    800057d2:	0e050863          	beqz	a0,800058c2 <sys_unlink+0x15e>
  ilock(ip);
    800057d6:	9f0fe0ef          	jal	800039c6 <ilock>
  if(ip->nlink < 1)
    800057da:	04a91783          	lh	a5,74(s2)
    800057de:	06f05763          	blez	a5,8000584c <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800057e2:	04491703          	lh	a4,68(s2)
    800057e6:	4785                	li	a5,1
    800057e8:	06f70963          	beq	a4,a5,8000585a <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800057ec:	4641                	li	a2,16
    800057ee:	4581                	li	a1,0
    800057f0:	fc040513          	addi	a0,s0,-64
    800057f4:	caefb0ef          	jal	80000ca2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800057f8:	4741                	li	a4,16
    800057fa:	f2c42683          	lw	a3,-212(s0)
    800057fe:	fc040613          	addi	a2,s0,-64
    80005802:	4581                	li	a1,0
    80005804:	8526                	mv	a0,s1
    80005806:	e4cfe0ef          	jal	80003e52 <writei>
    8000580a:	47c1                	li	a5,16
    8000580c:	08f51b63          	bne	a0,a5,800058a2 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80005810:	04491703          	lh	a4,68(s2)
    80005814:	4785                	li	a5,1
    80005816:	08f70d63          	beq	a4,a5,800058b0 <sys_unlink+0x14c>
  iunlockput(dp);
    8000581a:	8526                	mv	a0,s1
    8000581c:	bb4fe0ef          	jal	80003bd0 <iunlockput>
  ip->nlink--;
    80005820:	04a95783          	lhu	a5,74(s2)
    80005824:	37fd                	addiw	a5,a5,-1
    80005826:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000582a:	854a                	mv	a0,s2
    8000582c:	8e6fe0ef          	jal	80003912 <iupdate>
  iunlockput(ip);
    80005830:	854a                	mv	a0,s2
    80005832:	b9efe0ef          	jal	80003bd0 <iunlockput>
  end_op();
    80005836:	be5fe0ef          	jal	8000441a <end_op>
  return 0;
    8000583a:	4501                	li	a0,0
    8000583c:	64ee                	ld	s1,216(sp)
    8000583e:	694e                	ld	s2,208(sp)
    80005840:	a849                	j	800058d2 <sys_unlink+0x16e>
    end_op();
    80005842:	bd9fe0ef          	jal	8000441a <end_op>
    return -1;
    80005846:	557d                	li	a0,-1
    80005848:	64ee                	ld	s1,216(sp)
    8000584a:	a061                	j	800058d2 <sys_unlink+0x16e>
    8000584c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000584e:	00003517          	auipc	a0,0x3
    80005852:	fea50513          	addi	a0,a0,-22 # 80008838 <etext+0x838>
    80005856:	f8bfa0ef          	jal	800007e0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000585a:	04c92703          	lw	a4,76(s2)
    8000585e:	02000793          	li	a5,32
    80005862:	f8e7f5e3          	bgeu	a5,a4,800057ec <sys_unlink+0x88>
    80005866:	e5ce                	sd	s3,200(sp)
    80005868:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000586c:	4741                	li	a4,16
    8000586e:	86ce                	mv	a3,s3
    80005870:	f1840613          	addi	a2,s0,-232
    80005874:	4581                	li	a1,0
    80005876:	854a                	mv	a0,s2
    80005878:	cdefe0ef          	jal	80003d56 <readi>
    8000587c:	47c1                	li	a5,16
    8000587e:	00f51c63          	bne	a0,a5,80005896 <sys_unlink+0x132>
    if(de.inum != 0)
    80005882:	f1845783          	lhu	a5,-232(s0)
    80005886:	efa1                	bnez	a5,800058de <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005888:	29c1                	addiw	s3,s3,16
    8000588a:	04c92783          	lw	a5,76(s2)
    8000588e:	fcf9efe3          	bltu	s3,a5,8000586c <sys_unlink+0x108>
    80005892:	69ae                	ld	s3,200(sp)
    80005894:	bfa1                	j	800057ec <sys_unlink+0x88>
      panic("isdirempty: readi");
    80005896:	00003517          	auipc	a0,0x3
    8000589a:	fba50513          	addi	a0,a0,-70 # 80008850 <etext+0x850>
    8000589e:	f43fa0ef          	jal	800007e0 <panic>
    800058a2:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800058a4:	00003517          	auipc	a0,0x3
    800058a8:	fc450513          	addi	a0,a0,-60 # 80008868 <etext+0x868>
    800058ac:	f35fa0ef          	jal	800007e0 <panic>
    dp->nlink--;
    800058b0:	04a4d783          	lhu	a5,74(s1)
    800058b4:	37fd                	addiw	a5,a5,-1
    800058b6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800058ba:	8526                	mv	a0,s1
    800058bc:	856fe0ef          	jal	80003912 <iupdate>
    800058c0:	bfa9                	j	8000581a <sys_unlink+0xb6>
    800058c2:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800058c4:	8526                	mv	a0,s1
    800058c6:	b0afe0ef          	jal	80003bd0 <iunlockput>
  end_op();
    800058ca:	b51fe0ef          	jal	8000441a <end_op>
  return -1;
    800058ce:	557d                	li	a0,-1
    800058d0:	64ee                	ld	s1,216(sp)
}
    800058d2:	70ae                	ld	ra,232(sp)
    800058d4:	740e                	ld	s0,224(sp)
    800058d6:	616d                	addi	sp,sp,240
    800058d8:	8082                	ret
    return -1;
    800058da:	557d                	li	a0,-1
    800058dc:	bfdd                	j	800058d2 <sys_unlink+0x16e>
    iunlockput(ip);
    800058de:	854a                	mv	a0,s2
    800058e0:	af0fe0ef          	jal	80003bd0 <iunlockput>
    goto bad;
    800058e4:	694e                	ld	s2,208(sp)
    800058e6:	69ae                	ld	s3,200(sp)
    800058e8:	bff1                	j	800058c4 <sys_unlink+0x160>

00000000800058ea <sys_open>:

uint64
sys_open(void)
{
    800058ea:	7131                	addi	sp,sp,-192
    800058ec:	fd06                	sd	ra,184(sp)
    800058ee:	f922                	sd	s0,176(sp)
    800058f0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800058f2:	f4c40593          	addi	a1,s0,-180
    800058f6:	4505                	li	a0,1
    800058f8:	d2cfd0ef          	jal	80002e24 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800058fc:	08000613          	li	a2,128
    80005900:	f5040593          	addi	a1,s0,-176
    80005904:	4501                	li	a0,0
    80005906:	d56fd0ef          	jal	80002e5c <argstr>
    8000590a:	87aa                	mv	a5,a0
    return -1;
    8000590c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000590e:	0a07c263          	bltz	a5,800059b2 <sys_open+0xc8>
    80005912:	f526                	sd	s1,168(sp)

  begin_op();
    80005914:	a9dfe0ef          	jal	800043b0 <begin_op>

  if(omode & O_CREATE){
    80005918:	f4c42783          	lw	a5,-180(s0)
    8000591c:	2007f793          	andi	a5,a5,512
    80005920:	c3d5                	beqz	a5,800059c4 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80005922:	4681                	li	a3,0
    80005924:	4601                	li	a2,0
    80005926:	4589                	li	a1,2
    80005928:	f5040513          	addi	a0,s0,-176
    8000592c:	aa9ff0ef          	jal	800053d4 <create>
    80005930:	84aa                	mv	s1,a0
    if(ip == 0){
    80005932:	c541                	beqz	a0,800059ba <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005934:	04449703          	lh	a4,68(s1)
    80005938:	478d                	li	a5,3
    8000593a:	00f71763          	bne	a4,a5,80005948 <sys_open+0x5e>
    8000593e:	0464d703          	lhu	a4,70(s1)
    80005942:	47a5                	li	a5,9
    80005944:	0ae7ed63          	bltu	a5,a4,800059fe <sys_open+0x114>
    80005948:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000594a:	f6dfe0ef          	jal	800048b6 <filealloc>
    8000594e:	892a                	mv	s2,a0
    80005950:	c179                	beqz	a0,80005a16 <sys_open+0x12c>
    80005952:	ed4e                	sd	s3,152(sp)
    80005954:	a43ff0ef          	jal	80005396 <fdalloc>
    80005958:	89aa                	mv	s3,a0
    8000595a:	0a054a63          	bltz	a0,80005a0e <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000595e:	04449703          	lh	a4,68(s1)
    80005962:	478d                	li	a5,3
    80005964:	0cf70263          	beq	a4,a5,80005a28 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005968:	4789                	li	a5,2
    8000596a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000596e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005972:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005976:	f4c42783          	lw	a5,-180(s0)
    8000597a:	0017c713          	xori	a4,a5,1
    8000597e:	8b05                	andi	a4,a4,1
    80005980:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005984:	0037f713          	andi	a4,a5,3
    80005988:	00e03733          	snez	a4,a4
    8000598c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005990:	4007f793          	andi	a5,a5,1024
    80005994:	c791                	beqz	a5,800059a0 <sys_open+0xb6>
    80005996:	04449703          	lh	a4,68(s1)
    8000599a:	4789                	li	a5,2
    8000599c:	08f70d63          	beq	a4,a5,80005a36 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800059a0:	8526                	mv	a0,s1
    800059a2:	8d2fe0ef          	jal	80003a74 <iunlock>
  end_op();
    800059a6:	a75fe0ef          	jal	8000441a <end_op>

  return fd;
    800059aa:	854e                	mv	a0,s3
    800059ac:	74aa                	ld	s1,168(sp)
    800059ae:	790a                	ld	s2,160(sp)
    800059b0:	69ea                	ld	s3,152(sp)
}
    800059b2:	70ea                	ld	ra,184(sp)
    800059b4:	744a                	ld	s0,176(sp)
    800059b6:	6129                	addi	sp,sp,192
    800059b8:	8082                	ret
      end_op();
    800059ba:	a61fe0ef          	jal	8000441a <end_op>
      return -1;
    800059be:	557d                	li	a0,-1
    800059c0:	74aa                	ld	s1,168(sp)
    800059c2:	bfc5                	j	800059b2 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800059c4:	f5040513          	addi	a0,s0,-176
    800059c8:	815fe0ef          	jal	800041dc <namei>
    800059cc:	84aa                	mv	s1,a0
    800059ce:	c11d                	beqz	a0,800059f4 <sys_open+0x10a>
    ilock(ip);
    800059d0:	ff7fd0ef          	jal	800039c6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800059d4:	04449703          	lh	a4,68(s1)
    800059d8:	4785                	li	a5,1
    800059da:	f4f71de3          	bne	a4,a5,80005934 <sys_open+0x4a>
    800059de:	f4c42783          	lw	a5,-180(s0)
    800059e2:	d3bd                	beqz	a5,80005948 <sys_open+0x5e>
      iunlockput(ip);
    800059e4:	8526                	mv	a0,s1
    800059e6:	9eafe0ef          	jal	80003bd0 <iunlockput>
      end_op();
    800059ea:	a31fe0ef          	jal	8000441a <end_op>
      return -1;
    800059ee:	557d                	li	a0,-1
    800059f0:	74aa                	ld	s1,168(sp)
    800059f2:	b7c1                	j	800059b2 <sys_open+0xc8>
      end_op();
    800059f4:	a27fe0ef          	jal	8000441a <end_op>
      return -1;
    800059f8:	557d                	li	a0,-1
    800059fa:	74aa                	ld	s1,168(sp)
    800059fc:	bf5d                	j	800059b2 <sys_open+0xc8>
    iunlockput(ip);
    800059fe:	8526                	mv	a0,s1
    80005a00:	9d0fe0ef          	jal	80003bd0 <iunlockput>
    end_op();
    80005a04:	a17fe0ef          	jal	8000441a <end_op>
    return -1;
    80005a08:	557d                	li	a0,-1
    80005a0a:	74aa                	ld	s1,168(sp)
    80005a0c:	b75d                	j	800059b2 <sys_open+0xc8>
      fileclose(f);
    80005a0e:	854a                	mv	a0,s2
    80005a10:	f4bfe0ef          	jal	8000495a <fileclose>
    80005a14:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005a16:	8526                	mv	a0,s1
    80005a18:	9b8fe0ef          	jal	80003bd0 <iunlockput>
    end_op();
    80005a1c:	9fffe0ef          	jal	8000441a <end_op>
    return -1;
    80005a20:	557d                	li	a0,-1
    80005a22:	74aa                	ld	s1,168(sp)
    80005a24:	790a                	ld	s2,160(sp)
    80005a26:	b771                	j	800059b2 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005a28:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005a2c:	04649783          	lh	a5,70(s1)
    80005a30:	02f91223          	sh	a5,36(s2)
    80005a34:	bf3d                	j	80005972 <sys_open+0x88>
    itrunc(ip);
    80005a36:	8526                	mv	a0,s1
    80005a38:	87cfe0ef          	jal	80003ab4 <itrunc>
    80005a3c:	b795                	j	800059a0 <sys_open+0xb6>

0000000080005a3e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005a3e:	7175                	addi	sp,sp,-144
    80005a40:	e506                	sd	ra,136(sp)
    80005a42:	e122                	sd	s0,128(sp)
    80005a44:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005a46:	96bfe0ef          	jal	800043b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005a4a:	08000613          	li	a2,128
    80005a4e:	f7040593          	addi	a1,s0,-144
    80005a52:	4501                	li	a0,0
    80005a54:	c08fd0ef          	jal	80002e5c <argstr>
    80005a58:	02054363          	bltz	a0,80005a7e <sys_mkdir+0x40>
    80005a5c:	4681                	li	a3,0
    80005a5e:	4601                	li	a2,0
    80005a60:	4585                	li	a1,1
    80005a62:	f7040513          	addi	a0,s0,-144
    80005a66:	96fff0ef          	jal	800053d4 <create>
    80005a6a:	c911                	beqz	a0,80005a7e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005a6c:	964fe0ef          	jal	80003bd0 <iunlockput>
  end_op();
    80005a70:	9abfe0ef          	jal	8000441a <end_op>
  return 0;
    80005a74:	4501                	li	a0,0
}
    80005a76:	60aa                	ld	ra,136(sp)
    80005a78:	640a                	ld	s0,128(sp)
    80005a7a:	6149                	addi	sp,sp,144
    80005a7c:	8082                	ret
    end_op();
    80005a7e:	99dfe0ef          	jal	8000441a <end_op>
    return -1;
    80005a82:	557d                	li	a0,-1
    80005a84:	bfcd                	j	80005a76 <sys_mkdir+0x38>

0000000080005a86 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005a86:	7135                	addi	sp,sp,-160
    80005a88:	ed06                	sd	ra,152(sp)
    80005a8a:	e922                	sd	s0,144(sp)
    80005a8c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005a8e:	923fe0ef          	jal	800043b0 <begin_op>
  argint(1, &major);
    80005a92:	f6c40593          	addi	a1,s0,-148
    80005a96:	4505                	li	a0,1
    80005a98:	b8cfd0ef          	jal	80002e24 <argint>
  argint(2, &minor);
    80005a9c:	f6840593          	addi	a1,s0,-152
    80005aa0:	4509                	li	a0,2
    80005aa2:	b82fd0ef          	jal	80002e24 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005aa6:	08000613          	li	a2,128
    80005aaa:	f7040593          	addi	a1,s0,-144
    80005aae:	4501                	li	a0,0
    80005ab0:	bacfd0ef          	jal	80002e5c <argstr>
    80005ab4:	02054563          	bltz	a0,80005ade <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005ab8:	f6841683          	lh	a3,-152(s0)
    80005abc:	f6c41603          	lh	a2,-148(s0)
    80005ac0:	458d                	li	a1,3
    80005ac2:	f7040513          	addi	a0,s0,-144
    80005ac6:	90fff0ef          	jal	800053d4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005aca:	c911                	beqz	a0,80005ade <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005acc:	904fe0ef          	jal	80003bd0 <iunlockput>
  end_op();
    80005ad0:	94bfe0ef          	jal	8000441a <end_op>
  return 0;
    80005ad4:	4501                	li	a0,0
}
    80005ad6:	60ea                	ld	ra,152(sp)
    80005ad8:	644a                	ld	s0,144(sp)
    80005ada:	610d                	addi	sp,sp,160
    80005adc:	8082                	ret
    end_op();
    80005ade:	93dfe0ef          	jal	8000441a <end_op>
    return -1;
    80005ae2:	557d                	li	a0,-1
    80005ae4:	bfcd                	j	80005ad6 <sys_mknod+0x50>

0000000080005ae6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005ae6:	7135                	addi	sp,sp,-160
    80005ae8:	ed06                	sd	ra,152(sp)
    80005aea:	e922                	sd	s0,144(sp)
    80005aec:	e14a                	sd	s2,128(sp)
    80005aee:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005af0:	ddffb0ef          	jal	800018ce <myproc>
    80005af4:	892a                	mv	s2,a0
  
  begin_op();
    80005af6:	8bbfe0ef          	jal	800043b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005afa:	08000613          	li	a2,128
    80005afe:	f6040593          	addi	a1,s0,-160
    80005b02:	4501                	li	a0,0
    80005b04:	b58fd0ef          	jal	80002e5c <argstr>
    80005b08:	04054363          	bltz	a0,80005b4e <sys_chdir+0x68>
    80005b0c:	e526                	sd	s1,136(sp)
    80005b0e:	f6040513          	addi	a0,s0,-160
    80005b12:	ecafe0ef          	jal	800041dc <namei>
    80005b16:	84aa                	mv	s1,a0
    80005b18:	c915                	beqz	a0,80005b4c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005b1a:	eadfd0ef          	jal	800039c6 <ilock>
  if(ip->type != T_DIR){
    80005b1e:	04449703          	lh	a4,68(s1)
    80005b22:	4785                	li	a5,1
    80005b24:	02f71963          	bne	a4,a5,80005b56 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005b28:	8526                	mv	a0,s1
    80005b2a:	f4bfd0ef          	jal	80003a74 <iunlock>
  iput(p->cwd);
    80005b2e:	15093503          	ld	a0,336(s2)
    80005b32:	816fe0ef          	jal	80003b48 <iput>
  end_op();
    80005b36:	8e5fe0ef          	jal	8000441a <end_op>
  p->cwd = ip;
    80005b3a:	14993823          	sd	s1,336(s2)
  return 0;
    80005b3e:	4501                	li	a0,0
    80005b40:	64aa                	ld	s1,136(sp)
}
    80005b42:	60ea                	ld	ra,152(sp)
    80005b44:	644a                	ld	s0,144(sp)
    80005b46:	690a                	ld	s2,128(sp)
    80005b48:	610d                	addi	sp,sp,160
    80005b4a:	8082                	ret
    80005b4c:	64aa                	ld	s1,136(sp)
    end_op();
    80005b4e:	8cdfe0ef          	jal	8000441a <end_op>
    return -1;
    80005b52:	557d                	li	a0,-1
    80005b54:	b7fd                	j	80005b42 <sys_chdir+0x5c>
    iunlockput(ip);
    80005b56:	8526                	mv	a0,s1
    80005b58:	878fe0ef          	jal	80003bd0 <iunlockput>
    end_op();
    80005b5c:	8bffe0ef          	jal	8000441a <end_op>
    return -1;
    80005b60:	557d                	li	a0,-1
    80005b62:	64aa                	ld	s1,136(sp)
    80005b64:	bff9                	j	80005b42 <sys_chdir+0x5c>

0000000080005b66 <sys_exec>:

uint64
sys_exec(void)
{
    80005b66:	7121                	addi	sp,sp,-448
    80005b68:	ff06                	sd	ra,440(sp)
    80005b6a:	fb22                	sd	s0,432(sp)
    80005b6c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005b6e:	e4840593          	addi	a1,s0,-440
    80005b72:	4505                	li	a0,1
    80005b74:	accfd0ef          	jal	80002e40 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005b78:	08000613          	li	a2,128
    80005b7c:	f5040593          	addi	a1,s0,-176
    80005b80:	4501                	li	a0,0
    80005b82:	adafd0ef          	jal	80002e5c <argstr>
    80005b86:	87aa                	mv	a5,a0
    return -1;
    80005b88:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005b8a:	0c07c463          	bltz	a5,80005c52 <sys_exec+0xec>
    80005b8e:	f726                	sd	s1,424(sp)
    80005b90:	f34a                	sd	s2,416(sp)
    80005b92:	ef4e                	sd	s3,408(sp)
    80005b94:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005b96:	10000613          	li	a2,256
    80005b9a:	4581                	li	a1,0
    80005b9c:	e5040513          	addi	a0,s0,-432
    80005ba0:	902fb0ef          	jal	80000ca2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ba4:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005ba8:	89a6                	mv	s3,s1
    80005baa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005bac:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005bb0:	00391513          	slli	a0,s2,0x3
    80005bb4:	e4040593          	addi	a1,s0,-448
    80005bb8:	e4843783          	ld	a5,-440(s0)
    80005bbc:	953e                	add	a0,a0,a5
    80005bbe:	9dcfd0ef          	jal	80002d9a <fetchaddr>
    80005bc2:	02054663          	bltz	a0,80005bee <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005bc6:	e4043783          	ld	a5,-448(s0)
    80005bca:	c3a9                	beqz	a5,80005c0c <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005bcc:	f33fa0ef          	jal	80000afe <kalloc>
    80005bd0:	85aa                	mv	a1,a0
    80005bd2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005bd6:	cd01                	beqz	a0,80005bee <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005bd8:	6605                	lui	a2,0x1
    80005bda:	e4043503          	ld	a0,-448(s0)
    80005bde:	a06fd0ef          	jal	80002de4 <fetchstr>
    80005be2:	00054663          	bltz	a0,80005bee <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005be6:	0905                	addi	s2,s2,1
    80005be8:	09a1                	addi	s3,s3,8
    80005bea:	fd4913e3          	bne	s2,s4,80005bb0 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bee:	f5040913          	addi	s2,s0,-176
    80005bf2:	6088                	ld	a0,0(s1)
    80005bf4:	c931                	beqz	a0,80005c48 <sys_exec+0xe2>
    kfree(argv[i]);
    80005bf6:	e27fa0ef          	jal	80000a1c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bfa:	04a1                	addi	s1,s1,8
    80005bfc:	ff249be3          	bne	s1,s2,80005bf2 <sys_exec+0x8c>
  return -1;
    80005c00:	557d                	li	a0,-1
    80005c02:	74ba                	ld	s1,424(sp)
    80005c04:	791a                	ld	s2,416(sp)
    80005c06:	69fa                	ld	s3,408(sp)
    80005c08:	6a5a                	ld	s4,400(sp)
    80005c0a:	a0a1                	j	80005c52 <sys_exec+0xec>
      argv[i] = 0;
    80005c0c:	0009079b          	sext.w	a5,s2
    80005c10:	078e                	slli	a5,a5,0x3
    80005c12:	fd078793          	addi	a5,a5,-48
    80005c16:	97a2                	add	a5,a5,s0
    80005c18:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    80005c1c:	e5040593          	addi	a1,s0,-432
    80005c20:	f5040513          	addi	a0,s0,-176
    80005c24:	ba8ff0ef          	jal	80004fcc <kexec>
    80005c28:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c2a:	f5040993          	addi	s3,s0,-176
    80005c2e:	6088                	ld	a0,0(s1)
    80005c30:	c511                	beqz	a0,80005c3c <sys_exec+0xd6>
    kfree(argv[i]);
    80005c32:	debfa0ef          	jal	80000a1c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c36:	04a1                	addi	s1,s1,8
    80005c38:	ff349be3          	bne	s1,s3,80005c2e <sys_exec+0xc8>
  return ret;
    80005c3c:	854a                	mv	a0,s2
    80005c3e:	74ba                	ld	s1,424(sp)
    80005c40:	791a                	ld	s2,416(sp)
    80005c42:	69fa                	ld	s3,408(sp)
    80005c44:	6a5a                	ld	s4,400(sp)
    80005c46:	a031                	j	80005c52 <sys_exec+0xec>
  return -1;
    80005c48:	557d                	li	a0,-1
    80005c4a:	74ba                	ld	s1,424(sp)
    80005c4c:	791a                	ld	s2,416(sp)
    80005c4e:	69fa                	ld	s3,408(sp)
    80005c50:	6a5a                	ld	s4,400(sp)
}
    80005c52:	70fa                	ld	ra,440(sp)
    80005c54:	745a                	ld	s0,432(sp)
    80005c56:	6139                	addi	sp,sp,448
    80005c58:	8082                	ret

0000000080005c5a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005c5a:	7139                	addi	sp,sp,-64
    80005c5c:	fc06                	sd	ra,56(sp)
    80005c5e:	f822                	sd	s0,48(sp)
    80005c60:	f426                	sd	s1,40(sp)
    80005c62:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005c64:	c6bfb0ef          	jal	800018ce <myproc>
    80005c68:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005c6a:	fd840593          	addi	a1,s0,-40
    80005c6e:	4501                	li	a0,0
    80005c70:	9d0fd0ef          	jal	80002e40 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005c74:	fc840593          	addi	a1,s0,-56
    80005c78:	fd040513          	addi	a0,s0,-48
    80005c7c:	822ff0ef          	jal	80004c9e <pipealloc>
    return -1;
    80005c80:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005c82:	0a054463          	bltz	a0,80005d2a <sys_pipe+0xd0>
  fd0 = -1;
    80005c86:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005c8a:	fd043503          	ld	a0,-48(s0)
    80005c8e:	f08ff0ef          	jal	80005396 <fdalloc>
    80005c92:	fca42223          	sw	a0,-60(s0)
    80005c96:	08054163          	bltz	a0,80005d18 <sys_pipe+0xbe>
    80005c9a:	fc843503          	ld	a0,-56(s0)
    80005c9e:	ef8ff0ef          	jal	80005396 <fdalloc>
    80005ca2:	fca42023          	sw	a0,-64(s0)
    80005ca6:	06054063          	bltz	a0,80005d06 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005caa:	4691                	li	a3,4
    80005cac:	fc440613          	addi	a2,s0,-60
    80005cb0:	fd843583          	ld	a1,-40(s0)
    80005cb4:	68a8                	ld	a0,80(s1)
    80005cb6:	92dfb0ef          	jal	800015e2 <copyout>
    80005cba:	00054e63          	bltz	a0,80005cd6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005cbe:	4691                	li	a3,4
    80005cc0:	fc040613          	addi	a2,s0,-64
    80005cc4:	fd843583          	ld	a1,-40(s0)
    80005cc8:	0591                	addi	a1,a1,4
    80005cca:	68a8                	ld	a0,80(s1)
    80005ccc:	917fb0ef          	jal	800015e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005cd0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005cd2:	04055c63          	bgez	a0,80005d2a <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005cd6:	fc442783          	lw	a5,-60(s0)
    80005cda:	07e9                	addi	a5,a5,26
    80005cdc:	078e                	slli	a5,a5,0x3
    80005cde:	97a6                	add	a5,a5,s1
    80005ce0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005ce4:	fc042783          	lw	a5,-64(s0)
    80005ce8:	07e9                	addi	a5,a5,26
    80005cea:	078e                	slli	a5,a5,0x3
    80005cec:	94be                	add	s1,s1,a5
    80005cee:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005cf2:	fd043503          	ld	a0,-48(s0)
    80005cf6:	c65fe0ef          	jal	8000495a <fileclose>
    fileclose(wf);
    80005cfa:	fc843503          	ld	a0,-56(s0)
    80005cfe:	c5dfe0ef          	jal	8000495a <fileclose>
    return -1;
    80005d02:	57fd                	li	a5,-1
    80005d04:	a01d                	j	80005d2a <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005d06:	fc442783          	lw	a5,-60(s0)
    80005d0a:	0007c763          	bltz	a5,80005d18 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005d0e:	07e9                	addi	a5,a5,26
    80005d10:	078e                	slli	a5,a5,0x3
    80005d12:	97a6                	add	a5,a5,s1
    80005d14:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005d18:	fd043503          	ld	a0,-48(s0)
    80005d1c:	c3ffe0ef          	jal	8000495a <fileclose>
    fileclose(wf);
    80005d20:	fc843503          	ld	a0,-56(s0)
    80005d24:	c37fe0ef          	jal	8000495a <fileclose>
    return -1;
    80005d28:	57fd                	li	a5,-1
}
    80005d2a:	853e                	mv	a0,a5
    80005d2c:	70e2                	ld	ra,56(sp)
    80005d2e:	7442                	ld	s0,48(sp)
    80005d30:	74a2                	ld	s1,40(sp)
    80005d32:	6121                	addi	sp,sp,64
    80005d34:	8082                	ret
	...

0000000080005d40 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005d40:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005d42:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005d44:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005d46:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005d48:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005d4a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80005d4c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80005d4e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005d50:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005d52:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005d54:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005d56:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005d58:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005d5a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80005d5c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80005d5e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005d60:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005d62:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005d64:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005d66:	f45fc0ef          	jal	80002caa <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005d6a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80005d6c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80005d6e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005d70:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005d72:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005d74:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005d76:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005d78:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005d7a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80005d7c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80005d7e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005d80:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005d82:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005d84:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005d86:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005d88:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005d8a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80005d8c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80005d8e:	10200073          	sret
	...

0000000080005d9e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005d9e:	1141                	addi	sp,sp,-16
    80005da0:	e422                	sd	s0,8(sp)
    80005da2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005da4:	0c0007b7          	lui	a5,0xc000
    80005da8:	4705                	li	a4,1
    80005daa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005dac:	0c0007b7          	lui	a5,0xc000
    80005db0:	c3d8                	sw	a4,4(a5)
}
    80005db2:	6422                	ld	s0,8(sp)
    80005db4:	0141                	addi	sp,sp,16
    80005db6:	8082                	ret

0000000080005db8 <plicinithart>:

void
plicinithart(void)
{
    80005db8:	1141                	addi	sp,sp,-16
    80005dba:	e406                	sd	ra,8(sp)
    80005dbc:	e022                	sd	s0,0(sp)
    80005dbe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005dc0:	ae3fb0ef          	jal	800018a2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005dc4:	0085171b          	slliw	a4,a0,0x8
    80005dc8:	0c0027b7          	lui	a5,0xc002
    80005dcc:	97ba                	add	a5,a5,a4
    80005dce:	40200713          	li	a4,1026
    80005dd2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005dd6:	00d5151b          	slliw	a0,a0,0xd
    80005dda:	0c2017b7          	lui	a5,0xc201
    80005dde:	97aa                	add	a5,a5,a0
    80005de0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005de4:	60a2                	ld	ra,8(sp)
    80005de6:	6402                	ld	s0,0(sp)
    80005de8:	0141                	addi	sp,sp,16
    80005dea:	8082                	ret

0000000080005dec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005dec:	1141                	addi	sp,sp,-16
    80005dee:	e406                	sd	ra,8(sp)
    80005df0:	e022                	sd	s0,0(sp)
    80005df2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005df4:	aaffb0ef          	jal	800018a2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005df8:	00d5151b          	slliw	a0,a0,0xd
    80005dfc:	0c2017b7          	lui	a5,0xc201
    80005e00:	97aa                	add	a5,a5,a0
  return irq;
}
    80005e02:	43c8                	lw	a0,4(a5)
    80005e04:	60a2                	ld	ra,8(sp)
    80005e06:	6402                	ld	s0,0(sp)
    80005e08:	0141                	addi	sp,sp,16
    80005e0a:	8082                	ret

0000000080005e0c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e0c:	1101                	addi	sp,sp,-32
    80005e0e:	ec06                	sd	ra,24(sp)
    80005e10:	e822                	sd	s0,16(sp)
    80005e12:	e426                	sd	s1,8(sp)
    80005e14:	1000                	addi	s0,sp,32
    80005e16:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e18:	a8bfb0ef          	jal	800018a2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e1c:	00d5151b          	slliw	a0,a0,0xd
    80005e20:	0c2017b7          	lui	a5,0xc201
    80005e24:	97aa                	add	a5,a5,a0
    80005e26:	c3c4                	sw	s1,4(a5)
}
    80005e28:	60e2                	ld	ra,24(sp)
    80005e2a:	6442                	ld	s0,16(sp)
    80005e2c:	64a2                	ld	s1,8(sp)
    80005e2e:	6105                	addi	sp,sp,32
    80005e30:	8082                	ret

0000000080005e32 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005e32:	1141                	addi	sp,sp,-16
    80005e34:	e406                	sd	ra,8(sp)
    80005e36:	e022                	sd	s0,0(sp)
    80005e38:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005e3a:	479d                	li	a5,7
    80005e3c:	04a7ca63          	blt	a5,a0,80005e90 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005e40:	00021797          	auipc	a5,0x21
    80005e44:	96878793          	addi	a5,a5,-1688 # 800267a8 <disk>
    80005e48:	97aa                	add	a5,a5,a0
    80005e4a:	0187c783          	lbu	a5,24(a5)
    80005e4e:	e7b9                	bnez	a5,80005e9c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005e50:	00451693          	slli	a3,a0,0x4
    80005e54:	00021797          	auipc	a5,0x21
    80005e58:	95478793          	addi	a5,a5,-1708 # 800267a8 <disk>
    80005e5c:	6398                	ld	a4,0(a5)
    80005e5e:	9736                	add	a4,a4,a3
    80005e60:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005e64:	6398                	ld	a4,0(a5)
    80005e66:	9736                	add	a4,a4,a3
    80005e68:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005e6c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005e70:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005e74:	97aa                	add	a5,a5,a0
    80005e76:	4705                	li	a4,1
    80005e78:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005e7c:	00021517          	auipc	a0,0x21
    80005e80:	94450513          	addi	a0,a0,-1724 # 800267c0 <disk+0x18>
    80005e84:	a18fc0ef          	jal	8000209c <wakeup>
}
    80005e88:	60a2                	ld	ra,8(sp)
    80005e8a:	6402                	ld	s0,0(sp)
    80005e8c:	0141                	addi	sp,sp,16
    80005e8e:	8082                	ret
    panic("free_desc 1");
    80005e90:	00003517          	auipc	a0,0x3
    80005e94:	9e850513          	addi	a0,a0,-1560 # 80008878 <etext+0x878>
    80005e98:	949fa0ef          	jal	800007e0 <panic>
    panic("free_desc 2");
    80005e9c:	00003517          	auipc	a0,0x3
    80005ea0:	9ec50513          	addi	a0,a0,-1556 # 80008888 <etext+0x888>
    80005ea4:	93dfa0ef          	jal	800007e0 <panic>

0000000080005ea8 <virtio_disk_init>:
{
    80005ea8:	1101                	addi	sp,sp,-32
    80005eaa:	ec06                	sd	ra,24(sp)
    80005eac:	e822                	sd	s0,16(sp)
    80005eae:	e426                	sd	s1,8(sp)
    80005eb0:	e04a                	sd	s2,0(sp)
    80005eb2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005eb4:	00003597          	auipc	a1,0x3
    80005eb8:	9e458593          	addi	a1,a1,-1564 # 80008898 <etext+0x898>
    80005ebc:	00021517          	auipc	a0,0x21
    80005ec0:	a1450513          	addi	a0,a0,-1516 # 800268d0 <disk+0x128>
    80005ec4:	c8bfa0ef          	jal	80000b4e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ec8:	100017b7          	lui	a5,0x10001
    80005ecc:	4398                	lw	a4,0(a5)
    80005ece:	2701                	sext.w	a4,a4
    80005ed0:	747277b7          	lui	a5,0x74727
    80005ed4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005ed8:	18f71063          	bne	a4,a5,80006058 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005edc:	100017b7          	lui	a5,0x10001
    80005ee0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005ee2:	439c                	lw	a5,0(a5)
    80005ee4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ee6:	4709                	li	a4,2
    80005ee8:	16e79863          	bne	a5,a4,80006058 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005eec:	100017b7          	lui	a5,0x10001
    80005ef0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005ef2:	439c                	lw	a5,0(a5)
    80005ef4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005ef6:	16e79163          	bne	a5,a4,80006058 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005efa:	100017b7          	lui	a5,0x10001
    80005efe:	47d8                	lw	a4,12(a5)
    80005f00:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f02:	554d47b7          	lui	a5,0x554d4
    80005f06:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005f0a:	14f71763          	bne	a4,a5,80006058 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f0e:	100017b7          	lui	a5,0x10001
    80005f12:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f16:	4705                	li	a4,1
    80005f18:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f1a:	470d                	li	a4,3
    80005f1c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005f1e:	10001737          	lui	a4,0x10001
    80005f22:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005f24:	c7ffe737          	lui	a4,0xc7ffe
    80005f28:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd7e77>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005f2c:	8ef9                	and	a3,a3,a4
    80005f2e:	10001737          	lui	a4,0x10001
    80005f32:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f34:	472d                	li	a4,11
    80005f36:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f38:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005f3c:	439c                	lw	a5,0(a5)
    80005f3e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005f42:	8ba1                	andi	a5,a5,8
    80005f44:	12078063          	beqz	a5,80006064 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005f48:	100017b7          	lui	a5,0x10001
    80005f4c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005f50:	100017b7          	lui	a5,0x10001
    80005f54:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005f58:	439c                	lw	a5,0(a5)
    80005f5a:	2781                	sext.w	a5,a5
    80005f5c:	10079a63          	bnez	a5,80006070 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005f60:	100017b7          	lui	a5,0x10001
    80005f64:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005f68:	439c                	lw	a5,0(a5)
    80005f6a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005f6c:	10078863          	beqz	a5,8000607c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005f70:	471d                	li	a4,7
    80005f72:	10f77b63          	bgeu	a4,a5,80006088 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005f76:	b89fa0ef          	jal	80000afe <kalloc>
    80005f7a:	00021497          	auipc	s1,0x21
    80005f7e:	82e48493          	addi	s1,s1,-2002 # 800267a8 <disk>
    80005f82:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005f84:	b7bfa0ef          	jal	80000afe <kalloc>
    80005f88:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005f8a:	b75fa0ef          	jal	80000afe <kalloc>
    80005f8e:	87aa                	mv	a5,a0
    80005f90:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005f92:	6088                	ld	a0,0(s1)
    80005f94:	10050063          	beqz	a0,80006094 <virtio_disk_init+0x1ec>
    80005f98:	00021717          	auipc	a4,0x21
    80005f9c:	81873703          	ld	a4,-2024(a4) # 800267b0 <disk+0x8>
    80005fa0:	0e070a63          	beqz	a4,80006094 <virtio_disk_init+0x1ec>
    80005fa4:	0e078863          	beqz	a5,80006094 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005fa8:	6605                	lui	a2,0x1
    80005faa:	4581                	li	a1,0
    80005fac:	cf7fa0ef          	jal	80000ca2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005fb0:	00020497          	auipc	s1,0x20
    80005fb4:	7f848493          	addi	s1,s1,2040 # 800267a8 <disk>
    80005fb8:	6605                	lui	a2,0x1
    80005fba:	4581                	li	a1,0
    80005fbc:	6488                	ld	a0,8(s1)
    80005fbe:	ce5fa0ef          	jal	80000ca2 <memset>
  memset(disk.used, 0, PGSIZE);
    80005fc2:	6605                	lui	a2,0x1
    80005fc4:	4581                	li	a1,0
    80005fc6:	6888                	ld	a0,16(s1)
    80005fc8:	cdbfa0ef          	jal	80000ca2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005fcc:	100017b7          	lui	a5,0x10001
    80005fd0:	4721                	li	a4,8
    80005fd2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005fd4:	4098                	lw	a4,0(s1)
    80005fd6:	100017b7          	lui	a5,0x10001
    80005fda:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005fde:	40d8                	lw	a4,4(s1)
    80005fe0:	100017b7          	lui	a5,0x10001
    80005fe4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005fe8:	649c                	ld	a5,8(s1)
    80005fea:	0007869b          	sext.w	a3,a5
    80005fee:	10001737          	lui	a4,0x10001
    80005ff2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005ff6:	9781                	srai	a5,a5,0x20
    80005ff8:	10001737          	lui	a4,0x10001
    80005ffc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006000:	689c                	ld	a5,16(s1)
    80006002:	0007869b          	sext.w	a3,a5
    80006006:	10001737          	lui	a4,0x10001
    8000600a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000600e:	9781                	srai	a5,a5,0x20
    80006010:	10001737          	lui	a4,0x10001
    80006014:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006018:	10001737          	lui	a4,0x10001
    8000601c:	4785                	li	a5,1
    8000601e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006020:	00f48c23          	sb	a5,24(s1)
    80006024:	00f48ca3          	sb	a5,25(s1)
    80006028:	00f48d23          	sb	a5,26(s1)
    8000602c:	00f48da3          	sb	a5,27(s1)
    80006030:	00f48e23          	sb	a5,28(s1)
    80006034:	00f48ea3          	sb	a5,29(s1)
    80006038:	00f48f23          	sb	a5,30(s1)
    8000603c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006040:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006044:	100017b7          	lui	a5,0x10001
    80006048:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000604c:	60e2                	ld	ra,24(sp)
    8000604e:	6442                	ld	s0,16(sp)
    80006050:	64a2                	ld	s1,8(sp)
    80006052:	6902                	ld	s2,0(sp)
    80006054:	6105                	addi	sp,sp,32
    80006056:	8082                	ret
    panic("could not find virtio disk");
    80006058:	00003517          	auipc	a0,0x3
    8000605c:	85050513          	addi	a0,a0,-1968 # 800088a8 <etext+0x8a8>
    80006060:	f80fa0ef          	jal	800007e0 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006064:	00003517          	auipc	a0,0x3
    80006068:	86450513          	addi	a0,a0,-1948 # 800088c8 <etext+0x8c8>
    8000606c:	f74fa0ef          	jal	800007e0 <panic>
    panic("virtio disk should not be ready");
    80006070:	00003517          	auipc	a0,0x3
    80006074:	87850513          	addi	a0,a0,-1928 # 800088e8 <etext+0x8e8>
    80006078:	f68fa0ef          	jal	800007e0 <panic>
    panic("virtio disk has no queue 0");
    8000607c:	00003517          	auipc	a0,0x3
    80006080:	88c50513          	addi	a0,a0,-1908 # 80008908 <etext+0x908>
    80006084:	f5cfa0ef          	jal	800007e0 <panic>
    panic("virtio disk max queue too short");
    80006088:	00003517          	auipc	a0,0x3
    8000608c:	8a050513          	addi	a0,a0,-1888 # 80008928 <etext+0x928>
    80006090:	f50fa0ef          	jal	800007e0 <panic>
    panic("virtio disk kalloc");
    80006094:	00003517          	auipc	a0,0x3
    80006098:	8b450513          	addi	a0,a0,-1868 # 80008948 <etext+0x948>
    8000609c:	f44fa0ef          	jal	800007e0 <panic>

00000000800060a0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800060a0:	7159                	addi	sp,sp,-112
    800060a2:	f486                	sd	ra,104(sp)
    800060a4:	f0a2                	sd	s0,96(sp)
    800060a6:	eca6                	sd	s1,88(sp)
    800060a8:	e8ca                	sd	s2,80(sp)
    800060aa:	e4ce                	sd	s3,72(sp)
    800060ac:	e0d2                	sd	s4,64(sp)
    800060ae:	fc56                	sd	s5,56(sp)
    800060b0:	f85a                	sd	s6,48(sp)
    800060b2:	f45e                	sd	s7,40(sp)
    800060b4:	f062                	sd	s8,32(sp)
    800060b6:	ec66                	sd	s9,24(sp)
    800060b8:	1880                	addi	s0,sp,112
    800060ba:	8a2a                	mv	s4,a0
    800060bc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800060be:	00c52c83          	lw	s9,12(a0)
    800060c2:	001c9c9b          	slliw	s9,s9,0x1
    800060c6:	1c82                	slli	s9,s9,0x20
    800060c8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800060cc:	00021517          	auipc	a0,0x21
    800060d0:	80450513          	addi	a0,a0,-2044 # 800268d0 <disk+0x128>
    800060d4:	afbfa0ef          	jal	80000bce <acquire>
  for(int i = 0; i < 3; i++){
    800060d8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800060da:	44a1                	li	s1,8
      disk.free[i] = 0;
    800060dc:	00020b17          	auipc	s6,0x20
    800060e0:	6ccb0b13          	addi	s6,s6,1740 # 800267a8 <disk>
  for(int i = 0; i < 3; i++){
    800060e4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800060e6:	00020c17          	auipc	s8,0x20
    800060ea:	7eac0c13          	addi	s8,s8,2026 # 800268d0 <disk+0x128>
    800060ee:	a8b9                	j	8000614c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800060f0:	00fb0733          	add	a4,s6,a5
    800060f4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800060f8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800060fa:	0207c563          	bltz	a5,80006124 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800060fe:	2905                	addiw	s2,s2,1
    80006100:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006102:	05590963          	beq	s2,s5,80006154 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80006106:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006108:	00020717          	auipc	a4,0x20
    8000610c:	6a070713          	addi	a4,a4,1696 # 800267a8 <disk>
    80006110:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006112:	01874683          	lbu	a3,24(a4)
    80006116:	fee9                	bnez	a3,800060f0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80006118:	2785                	addiw	a5,a5,1
    8000611a:	0705                	addi	a4,a4,1
    8000611c:	fe979be3          	bne	a5,s1,80006112 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80006120:	57fd                	li	a5,-1
    80006122:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006124:	01205d63          	blez	s2,8000613e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80006128:	f9042503          	lw	a0,-112(s0)
    8000612c:	d07ff0ef          	jal	80005e32 <free_desc>
      for(int j = 0; j < i; j++)
    80006130:	4785                	li	a5,1
    80006132:	0127d663          	bge	a5,s2,8000613e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80006136:	f9442503          	lw	a0,-108(s0)
    8000613a:	cf9ff0ef          	jal	80005e32 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000613e:	85e2                	mv	a1,s8
    80006140:	00020517          	auipc	a0,0x20
    80006144:	68050513          	addi	a0,a0,1664 # 800267c0 <disk+0x18>
    80006148:	f09fb0ef          	jal	80002050 <sleep>
  for(int i = 0; i < 3; i++){
    8000614c:	f9040613          	addi	a2,s0,-112
    80006150:	894e                	mv	s2,s3
    80006152:	bf55                	j	80006106 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006154:	f9042503          	lw	a0,-112(s0)
    80006158:	00451693          	slli	a3,a0,0x4

  if(write)
    8000615c:	00020797          	auipc	a5,0x20
    80006160:	64c78793          	addi	a5,a5,1612 # 800267a8 <disk>
    80006164:	00a50713          	addi	a4,a0,10
    80006168:	0712                	slli	a4,a4,0x4
    8000616a:	973e                	add	a4,a4,a5
    8000616c:	01703633          	snez	a2,s7
    80006170:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006172:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006176:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000617a:	6398                	ld	a4,0(a5)
    8000617c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000617e:	0a868613          	addi	a2,a3,168
    80006182:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006184:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006186:	6390                	ld	a2,0(a5)
    80006188:	00d605b3          	add	a1,a2,a3
    8000618c:	4741                	li	a4,16
    8000618e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006190:	4805                	li	a6,1
    80006192:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80006196:	f9442703          	lw	a4,-108(s0)
    8000619a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000619e:	0712                	slli	a4,a4,0x4
    800061a0:	963a                	add	a2,a2,a4
    800061a2:	058a0593          	addi	a1,s4,88
    800061a6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800061a8:	0007b883          	ld	a7,0(a5)
    800061ac:	9746                	add	a4,a4,a7
    800061ae:	40000613          	li	a2,1024
    800061b2:	c710                	sw	a2,8(a4)
  if(write)
    800061b4:	001bb613          	seqz	a2,s7
    800061b8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800061bc:	00166613          	ori	a2,a2,1
    800061c0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800061c4:	f9842583          	lw	a1,-104(s0)
    800061c8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800061cc:	00250613          	addi	a2,a0,2
    800061d0:	0612                	slli	a2,a2,0x4
    800061d2:	963e                	add	a2,a2,a5
    800061d4:	577d                	li	a4,-1
    800061d6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800061da:	0592                	slli	a1,a1,0x4
    800061dc:	98ae                	add	a7,a7,a1
    800061de:	03068713          	addi	a4,a3,48
    800061e2:	973e                	add	a4,a4,a5
    800061e4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800061e8:	6398                	ld	a4,0(a5)
    800061ea:	972e                	add	a4,a4,a1
    800061ec:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800061f0:	4689                	li	a3,2
    800061f2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800061f6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800061fa:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800061fe:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006202:	6794                	ld	a3,8(a5)
    80006204:	0026d703          	lhu	a4,2(a3)
    80006208:	8b1d                	andi	a4,a4,7
    8000620a:	0706                	slli	a4,a4,0x1
    8000620c:	96ba                	add	a3,a3,a4
    8000620e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006212:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006216:	6798                	ld	a4,8(a5)
    80006218:	00275783          	lhu	a5,2(a4)
    8000621c:	2785                	addiw	a5,a5,1
    8000621e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006222:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006226:	100017b7          	lui	a5,0x10001
    8000622a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000622e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006232:	00020917          	auipc	s2,0x20
    80006236:	69e90913          	addi	s2,s2,1694 # 800268d0 <disk+0x128>
  while(b->disk == 1) {
    8000623a:	4485                	li	s1,1
    8000623c:	01079a63          	bne	a5,a6,80006250 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80006240:	85ca                	mv	a1,s2
    80006242:	8552                	mv	a0,s4
    80006244:	e0dfb0ef          	jal	80002050 <sleep>
  while(b->disk == 1) {
    80006248:	004a2783          	lw	a5,4(s4)
    8000624c:	fe978ae3          	beq	a5,s1,80006240 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80006250:	f9042903          	lw	s2,-112(s0)
    80006254:	00290713          	addi	a4,s2,2
    80006258:	0712                	slli	a4,a4,0x4
    8000625a:	00020797          	auipc	a5,0x20
    8000625e:	54e78793          	addi	a5,a5,1358 # 800267a8 <disk>
    80006262:	97ba                	add	a5,a5,a4
    80006264:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006268:	00020997          	auipc	s3,0x20
    8000626c:	54098993          	addi	s3,s3,1344 # 800267a8 <disk>
    80006270:	00491713          	slli	a4,s2,0x4
    80006274:	0009b783          	ld	a5,0(s3)
    80006278:	97ba                	add	a5,a5,a4
    8000627a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000627e:	854a                	mv	a0,s2
    80006280:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006284:	bafff0ef          	jal	80005e32 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006288:	8885                	andi	s1,s1,1
    8000628a:	f0fd                	bnez	s1,80006270 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000628c:	00020517          	auipc	a0,0x20
    80006290:	64450513          	addi	a0,a0,1604 # 800268d0 <disk+0x128>
    80006294:	9d3fa0ef          	jal	80000c66 <release>
}
    80006298:	70a6                	ld	ra,104(sp)
    8000629a:	7406                	ld	s0,96(sp)
    8000629c:	64e6                	ld	s1,88(sp)
    8000629e:	6946                	ld	s2,80(sp)
    800062a0:	69a6                	ld	s3,72(sp)
    800062a2:	6a06                	ld	s4,64(sp)
    800062a4:	7ae2                	ld	s5,56(sp)
    800062a6:	7b42                	ld	s6,48(sp)
    800062a8:	7ba2                	ld	s7,40(sp)
    800062aa:	7c02                	ld	s8,32(sp)
    800062ac:	6ce2                	ld	s9,24(sp)
    800062ae:	6165                	addi	sp,sp,112
    800062b0:	8082                	ret

00000000800062b2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800062b2:	1101                	addi	sp,sp,-32
    800062b4:	ec06                	sd	ra,24(sp)
    800062b6:	e822                	sd	s0,16(sp)
    800062b8:	e426                	sd	s1,8(sp)
    800062ba:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800062bc:	00020497          	auipc	s1,0x20
    800062c0:	4ec48493          	addi	s1,s1,1260 # 800267a8 <disk>
    800062c4:	00020517          	auipc	a0,0x20
    800062c8:	60c50513          	addi	a0,a0,1548 # 800268d0 <disk+0x128>
    800062cc:	903fa0ef          	jal	80000bce <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800062d0:	100017b7          	lui	a5,0x10001
    800062d4:	53b8                	lw	a4,96(a5)
    800062d6:	8b0d                	andi	a4,a4,3
    800062d8:	100017b7          	lui	a5,0x10001
    800062dc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800062de:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800062e2:	689c                	ld	a5,16(s1)
    800062e4:	0204d703          	lhu	a4,32(s1)
    800062e8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800062ec:	04f70663          	beq	a4,a5,80006338 <virtio_disk_intr+0x86>
    __sync_synchronize();
    800062f0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800062f4:	6898                	ld	a4,16(s1)
    800062f6:	0204d783          	lhu	a5,32(s1)
    800062fa:	8b9d                	andi	a5,a5,7
    800062fc:	078e                	slli	a5,a5,0x3
    800062fe:	97ba                	add	a5,a5,a4
    80006300:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006302:	00278713          	addi	a4,a5,2
    80006306:	0712                	slli	a4,a4,0x4
    80006308:	9726                	add	a4,a4,s1
    8000630a:	01074703          	lbu	a4,16(a4)
    8000630e:	e321                	bnez	a4,8000634e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006310:	0789                	addi	a5,a5,2
    80006312:	0792                	slli	a5,a5,0x4
    80006314:	97a6                	add	a5,a5,s1
    80006316:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006318:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000631c:	d81fb0ef          	jal	8000209c <wakeup>

    disk.used_idx += 1;
    80006320:	0204d783          	lhu	a5,32(s1)
    80006324:	2785                	addiw	a5,a5,1
    80006326:	17c2                	slli	a5,a5,0x30
    80006328:	93c1                	srli	a5,a5,0x30
    8000632a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000632e:	6898                	ld	a4,16(s1)
    80006330:	00275703          	lhu	a4,2(a4)
    80006334:	faf71ee3          	bne	a4,a5,800062f0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006338:	00020517          	auipc	a0,0x20
    8000633c:	59850513          	addi	a0,a0,1432 # 800268d0 <disk+0x128>
    80006340:	927fa0ef          	jal	80000c66 <release>
}
    80006344:	60e2                	ld	ra,24(sp)
    80006346:	6442                	ld	s0,16(sp)
    80006348:	64a2                	ld	s1,8(sp)
    8000634a:	6105                	addi	sp,sp,32
    8000634c:	8082                	ret
      panic("virtio_disk_intr status");
    8000634e:	00002517          	auipc	a0,0x2
    80006352:	61250513          	addi	a0,a0,1554 # 80008960 <etext+0x960>
    80006356:	c8afa0ef          	jal	800007e0 <panic>
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
