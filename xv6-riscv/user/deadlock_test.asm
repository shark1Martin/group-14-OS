
user/_deadlock_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

int main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  printf("Deadlock Detection with Energy-Aware Recovery Test\n\n");
   8:	00001517          	auipc	a0,0x1
   c:	a3850513          	addi	a0,a0,-1480 # a40 <malloc+0xfe>
  10:	07b000ef          	jal	88a <printf>

  // First, test manual check when no deadlock exists
  printf("Test 1: No deadlock - calling check_deadlock()...\n");
  14:	00001517          	auipc	a0,0x1
  18:	a6c50513          	addi	a0,a0,-1428 # a80 <malloc+0x13e>
  1c:	06f000ef          	jal	88a <printf>
  int result = check_deadlock();
  20:	4bc000ef          	jal	4dc <check_deadlock>
  24:	85aa                	mv	a1,a0
  printf("Result: %d (0 means no deadlock)\n\n", result);
  26:	00001517          	auipc	a0,0x1
  2a:	a9250513          	addi	a0,a0,-1390 # ab8 <malloc+0x176>
  2e:	05d000ef          	jal	88a <printf>

  printf("Test 2: Simulating deadlock scenario\n");
  32:	00001517          	auipc	a0,0x1
  36:	aae50513          	addi	a0,a0,-1362 # ae0 <malloc+0x19e>
  3a:	051000ef          	jal	88a <printf>
  printf("(In a real scenario, two processes would hold resources\n");
  3e:	00001517          	auipc	a0,0x1
  42:	aca50513          	addi	a0,a0,-1334 # b08 <malloc+0x1c6>
  46:	045000ef          	jal	88a <printf>
  printf(" and wait for each other's resources, creating a cycle\n");
  4a:	00001517          	auipc	a0,0x1
  4e:	afe50513          	addi	a0,a0,-1282 # b48 <malloc+0x206>
  52:	039000ef          	jal	88a <printf>
  printf(" in the resource allocation graph. The kernel would then\n");
  56:	00001517          	auipc	a0,0x1
  5a:	b2a50513          	addi	a0,a0,-1238 # b80 <malloc+0x23e>
  5e:	02d000ef          	jal	88a <printf>
  printf(" detect this cycle and kill the process that consumed\n");
  62:	00001517          	auipc	a0,0x1
  66:	b5e50513          	addi	a0,a0,-1186 # bc0 <malloc+0x27e>
  6a:	021000ef          	jal	88a <printf>
  printf(" the most energy to break the deadlock.)\n\n");
  6e:	00001517          	auipc	a0,0x1
  72:	b8a50513          	addi	a0,a0,-1142 # bf8 <malloc+0x2b6>
  76:	015000ef          	jal	88a <printf>

  // Fork two children that will try to create a deadlock
  int pid1 = fork();
  7a:	39a000ef          	jal	414 <fork>
  if(pid1 == 0){
  7e:	ed21                	bnez	a0,d6 <main+0xd6>
    // Child 1: burn some CPU (high energy) then sleep to simulate waiting
    printf("Child 1 (pid=%d): Running CPU-intensive work (high energy)...\n", getpid());
  80:	41c000ef          	jal	49c <getpid>
  84:	85aa                	mv	a1,a0
  86:	00001517          	auipc	a0,0x1
  8a:	ba250513          	addi	a0,a0,-1118 # c28 <malloc+0x2e6>
  8e:	7fc000ef          	jal	88a <printf>
    for(volatile int i = 0; i < 1000000; i++); // burn CPU = accumulate energy_consumed
  92:	fe042423          	sw	zero,-24(s0)
  96:	fe842703          	lw	a4,-24(s0)
  9a:	2701                	sext.w	a4,a4
  9c:	000f47b7          	lui	a5,0xf4
  a0:	23f78793          	addi	a5,a5,575 # f423f <base+0xf322f>
  a4:	00e7cd63          	blt	a5,a4,be <main+0xbe>
  a8:	873e                	mv	a4,a5
  aa:	fe842783          	lw	a5,-24(s0)
  ae:	2785                	addiw	a5,a5,1
  b0:	fef42423          	sw	a5,-24(s0)
  b4:	fe842783          	lw	a5,-24(s0)
  b8:	2781                	sext.w	a5,a5
  ba:	fef758e3          	bge	a4,a5,aa <main+0xaa>
    printf("Child 1 (pid=%d): Done. Energy consumed is high.\n", getpid());
  be:	3de000ef          	jal	49c <getpid>
  c2:	85aa                	mv	a1,a0
  c4:	00001517          	auipc	a0,0x1
  c8:	ba450513          	addi	a0,a0,-1116 # c68 <malloc+0x326>
  cc:	7be000ef          	jal	88a <printf>
    exit(0);
  d0:	4501                	li	a0,0
  d2:	34a000ef          	jal	41c <exit>
  }

  int pid2 = fork();
  d6:	33e000ef          	jal	414 <fork>
  if(pid2 == 0){
  da:	e929                	bnez	a0,12c <main+0x12c>
    // Child 2: do less work (low energy)
    printf("Child 2 (pid=%d): Running light work (low energy)...\n", getpid());
  dc:	3c0000ef          	jal	49c <getpid>
  e0:	85aa                	mv	a1,a0
  e2:	00001517          	auipc	a0,0x1
  e6:	bbe50513          	addi	a0,a0,-1090 # ca0 <malloc+0x35e>
  ea:	7a0000ef          	jal	88a <printf>
    for(volatile int i = 0; i < 100; i++); // minimal CPU burn
  ee:	fe042423          	sw	zero,-24(s0)
  f2:	fe842783          	lw	a5,-24(s0)
  f6:	2781                	sext.w	a5,a5
  f8:	06300713          	li	a4,99
  fc:	00f74c63          	blt	a4,a5,114 <main+0x114>
 100:	fe842783          	lw	a5,-24(s0)
 104:	2785                	addiw	a5,a5,1
 106:	fef42423          	sw	a5,-24(s0)
 10a:	fe842783          	lw	a5,-24(s0)
 10e:	2781                	sext.w	a5,a5
 110:	fef758e3          	bge	a4,a5,100 <main+0x100>
    printf("Child 2 (pid=%d): Done. Energy consumed is low.\n", getpid());
 114:	388000ef          	jal	49c <getpid>
 118:	85aa                	mv	a1,a0
 11a:	00001517          	auipc	a0,0x1
 11e:	bbe50513          	addi	a0,a0,-1090 # cd8 <malloc+0x396>
 122:	768000ef          	jal	88a <printf>
    exit(0);
 126:	4501                	li	a0,0
 128:	2f4000ef          	jal	41c <exit>
  }

  // Parent waits
  int status;
  wait(&status);
 12c:	fec40513          	addi	a0,s0,-20
 130:	2f4000ef          	jal	424 <wait>
  wait(&status);
 134:	fec40513          	addi	a0,s0,-20
 138:	2ec000ef          	jal	424 <wait>

  printf("\nTest Complete\n");
 13c:	00001517          	auipc	a0,0x1
 140:	bd450513          	addi	a0,a0,-1068 # d10 <malloc+0x3ce>
 144:	746000ef          	jal	88a <printf>
  printf("In a real deadlock, the kernel would have killed the process\n");
 148:	00001517          	auipc	a0,0x1
 14c:	bd850513          	addi	a0,a0,-1064 # d20 <malloc+0x3de>
 150:	73a000ef          	jal	88a <printf>
  printf("with the HIGHEST energy_consumed, saving system resources.\n");
 154:	00001517          	auipc	a0,0x1
 158:	c0c50513          	addi	a0,a0,-1012 # d60 <malloc+0x41e>
 15c:	72e000ef          	jal	88a <printf>

  exit(0);
 160:	4501                	li	a0,0
 162:	2ba000ef          	jal	41c <exit>

0000000000000166 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 166:	1141                	addi	sp,sp,-16
 168:	e406                	sd	ra,8(sp)
 16a:	e022                	sd	s0,0(sp)
 16c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 16e:	e93ff0ef          	jal	0 <main>
  exit(r);
 172:	2aa000ef          	jal	41c <exit>

0000000000000176 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 176:	1141                	addi	sp,sp,-16
 178:	e406                	sd	ra,8(sp)
 17a:	e022                	sd	s0,0(sp)
 17c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 17e:	87aa                	mv	a5,a0
 180:	0585                	addi	a1,a1,1
 182:	0785                	addi	a5,a5,1
 184:	fff5c703          	lbu	a4,-1(a1)
 188:	fee78fa3          	sb	a4,-1(a5)
 18c:	fb75                	bnez	a4,180 <strcpy+0xa>
    ;
  return os;
}
 18e:	60a2                	ld	ra,8(sp)
 190:	6402                	ld	s0,0(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret

0000000000000196 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 196:	1141                	addi	sp,sp,-16
 198:	e406                	sd	ra,8(sp)
 19a:	e022                	sd	s0,0(sp)
 19c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	cb91                	beqz	a5,1b6 <strcmp+0x20>
 1a4:	0005c703          	lbu	a4,0(a1)
 1a8:	00f71763          	bne	a4,a5,1b6 <strcmp+0x20>
    p++, q++;
 1ac:	0505                	addi	a0,a0,1
 1ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fbe5                	bnez	a5,1a4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1b6:	0005c503          	lbu	a0,0(a1)
}
 1ba:	40a7853b          	subw	a0,a5,a0
 1be:	60a2                	ld	ra,8(sp)
 1c0:	6402                	ld	s0,0(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strlen>:

uint
strlen(const char *s)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e406                	sd	ra,8(sp)
 1ca:	e022                	sd	s0,0(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	cf91                	beqz	a5,1ee <strlen+0x28>
 1d4:	00150793          	addi	a5,a0,1
 1d8:	86be                	mv	a3,a5
 1da:	0785                	addi	a5,a5,1
 1dc:	fff7c703          	lbu	a4,-1(a5)
 1e0:	ff65                	bnez	a4,1d8 <strlen+0x12>
 1e2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1e6:	60a2                	ld	ra,8(sp)
 1e8:	6402                	ld	s0,0(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  for(n = 0; s[n]; n++)
 1ee:	4501                	li	a0,0
 1f0:	bfdd                	j	1e6 <strlen+0x20>

00000000000001f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e406                	sd	ra,8(sp)
 1f6:	e022                	sd	s0,0(sp)
 1f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1fa:	ca19                	beqz	a2,210 <memset+0x1e>
 1fc:	87aa                	mv	a5,a0
 1fe:	1602                	slli	a2,a2,0x20
 200:	9201                	srli	a2,a2,0x20
 202:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 206:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 20a:	0785                	addi	a5,a5,1
 20c:	fee79de3          	bne	a5,a4,206 <memset+0x14>
  }
  return dst;
}
 210:	60a2                	ld	ra,8(sp)
 212:	6402                	ld	s0,0(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret

0000000000000218 <strchr>:

char*
strchr(const char *s, char c)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 220:	00054783          	lbu	a5,0(a0)
 224:	cf81                	beqz	a5,23c <strchr+0x24>
    if(*s == c)
 226:	00f58763          	beq	a1,a5,234 <strchr+0x1c>
  for(; *s; s++)
 22a:	0505                	addi	a0,a0,1
 22c:	00054783          	lbu	a5,0(a0)
 230:	fbfd                	bnez	a5,226 <strchr+0xe>
      return (char*)s;
  return 0;
 232:	4501                	li	a0,0
}
 234:	60a2                	ld	ra,8(sp)
 236:	6402                	ld	s0,0(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
  return 0;
 23c:	4501                	li	a0,0
 23e:	bfdd                	j	234 <strchr+0x1c>

0000000000000240 <gets>:

char*
gets(char *buf, int max)
{
 240:	711d                	addi	sp,sp,-96
 242:	ec86                	sd	ra,88(sp)
 244:	e8a2                	sd	s0,80(sp)
 246:	e4a6                	sd	s1,72(sp)
 248:	e0ca                	sd	s2,64(sp)
 24a:	fc4e                	sd	s3,56(sp)
 24c:	f852                	sd	s4,48(sp)
 24e:	f456                	sd	s5,40(sp)
 250:	f05a                	sd	s6,32(sp)
 252:	ec5e                	sd	s7,24(sp)
 254:	e862                	sd	s8,16(sp)
 256:	1080                	addi	s0,sp,96
 258:	8baa                	mv	s7,a0
 25a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25c:	892a                	mv	s2,a0
 25e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 260:	faf40b13          	addi	s6,s0,-81
 264:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 266:	8c26                	mv	s8,s1
 268:	0014899b          	addiw	s3,s1,1
 26c:	84ce                	mv	s1,s3
 26e:	0349d463          	bge	s3,s4,296 <gets+0x56>
    cc = read(0, &c, 1);
 272:	8656                	mv	a2,s5
 274:	85da                	mv	a1,s6
 276:	4501                	li	a0,0
 278:	1bc000ef          	jal	434 <read>
    if(cc < 1)
 27c:	00a05d63          	blez	a0,296 <gets+0x56>
      break;
    buf[i++] = c;
 280:	faf44783          	lbu	a5,-81(s0)
 284:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 288:	0905                	addi	s2,s2,1
 28a:	ff678713          	addi	a4,a5,-10
 28e:	c319                	beqz	a4,294 <gets+0x54>
 290:	17cd                	addi	a5,a5,-13
 292:	fbf1                	bnez	a5,266 <gets+0x26>
    buf[i++] = c;
 294:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 296:	9c5e                	add	s8,s8,s7
 298:	000c0023          	sb	zero,0(s8)
  return buf;
}
 29c:	855e                	mv	a0,s7
 29e:	60e6                	ld	ra,88(sp)
 2a0:	6446                	ld	s0,80(sp)
 2a2:	64a6                	ld	s1,72(sp)
 2a4:	6906                	ld	s2,64(sp)
 2a6:	79e2                	ld	s3,56(sp)
 2a8:	7a42                	ld	s4,48(sp)
 2aa:	7aa2                	ld	s5,40(sp)
 2ac:	7b02                	ld	s6,32(sp)
 2ae:	6be2                	ld	s7,24(sp)
 2b0:	6c42                	ld	s8,16(sp)
 2b2:	6125                	addi	sp,sp,96
 2b4:	8082                	ret

00000000000002b6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b6:	1101                	addi	sp,sp,-32
 2b8:	ec06                	sd	ra,24(sp)
 2ba:	e822                	sd	s0,16(sp)
 2bc:	e04a                	sd	s2,0(sp)
 2be:	1000                	addi	s0,sp,32
 2c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c2:	4581                	li	a1,0
 2c4:	198000ef          	jal	45c <open>
  if(fd < 0)
 2c8:	02054263          	bltz	a0,2ec <stat+0x36>
 2cc:	e426                	sd	s1,8(sp)
 2ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d0:	85ca                	mv	a1,s2
 2d2:	1a2000ef          	jal	474 <fstat>
 2d6:	892a                	mv	s2,a0
  close(fd);
 2d8:	8526                	mv	a0,s1
 2da:	16a000ef          	jal	444 <close>
  return r;
 2de:	64a2                	ld	s1,8(sp)
}
 2e0:	854a                	mv	a0,s2
 2e2:	60e2                	ld	ra,24(sp)
 2e4:	6442                	ld	s0,16(sp)
 2e6:	6902                	ld	s2,0(sp)
 2e8:	6105                	addi	sp,sp,32
 2ea:	8082                	ret
    return -1;
 2ec:	57fd                	li	a5,-1
 2ee:	893e                	mv	s2,a5
 2f0:	bfc5                	j	2e0 <stat+0x2a>

00000000000002f2 <atoi>:

int
atoi(const char *s)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fa:	00054683          	lbu	a3,0(a0)
 2fe:	fd06879b          	addiw	a5,a3,-48
 302:	0ff7f793          	zext.b	a5,a5
 306:	4625                	li	a2,9
 308:	02f66963          	bltu	a2,a5,33a <atoi+0x48>
 30c:	872a                	mv	a4,a0
  n = 0;
 30e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 310:	0705                	addi	a4,a4,1
 312:	0025179b          	slliw	a5,a0,0x2
 316:	9fa9                	addw	a5,a5,a0
 318:	0017979b          	slliw	a5,a5,0x1
 31c:	9fb5                	addw	a5,a5,a3
 31e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 322:	00074683          	lbu	a3,0(a4)
 326:	fd06879b          	addiw	a5,a3,-48
 32a:	0ff7f793          	zext.b	a5,a5
 32e:	fef671e3          	bgeu	a2,a5,310 <atoi+0x1e>
  return n;
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  n = 0;
 33a:	4501                	li	a0,0
 33c:	bfdd                	j	332 <atoi+0x40>

000000000000033e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 346:	02b57563          	bgeu	a0,a1,370 <memmove+0x32>
    while(n-- > 0)
 34a:	00c05f63          	blez	a2,368 <memmove+0x2a>
 34e:	1602                	slli	a2,a2,0x20
 350:	9201                	srli	a2,a2,0x20
 352:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 356:	872a                	mv	a4,a0
      *dst++ = *src++;
 358:	0585                	addi	a1,a1,1
 35a:	0705                	addi	a4,a4,1
 35c:	fff5c683          	lbu	a3,-1(a1)
 360:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 364:	fee79ae3          	bne	a5,a4,358 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
    while(n-- > 0)
 370:	fec05ce3          	blez	a2,368 <memmove+0x2a>
    dst += n;
 374:	00c50733          	add	a4,a0,a2
    src += n;
 378:	95b2                	add	a1,a1,a2
 37a:	fff6079b          	addiw	a5,a2,-1
 37e:	1782                	slli	a5,a5,0x20
 380:	9381                	srli	a5,a5,0x20
 382:	fff7c793          	not	a5,a5
 386:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 388:	15fd                	addi	a1,a1,-1
 38a:	177d                	addi	a4,a4,-1
 38c:	0005c683          	lbu	a3,0(a1)
 390:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 394:	fef71ae3          	bne	a4,a5,388 <memmove+0x4a>
 398:	bfc1                	j	368 <memmove+0x2a>

000000000000039a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e406                	sd	ra,8(sp)
 39e:	e022                	sd	s0,0(sp)
 3a0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a2:	c61d                	beqz	a2,3d0 <memcmp+0x36>
 3a4:	1602                	slli	a2,a2,0x20
 3a6:	9201                	srli	a2,a2,0x20
 3a8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	0005c703          	lbu	a4,0(a1)
 3b4:	00e79863          	bne	a5,a4,3c4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3b8:	0505                	addi	a0,a0,1
    p2++;
 3ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3bc:	fed518e3          	bne	a0,a3,3ac <memcmp+0x12>
  }
  return 0;
 3c0:	4501                	li	a0,0
 3c2:	a019                	j	3c8 <memcmp+0x2e>
      return *p1 - *p2;
 3c4:	40e7853b          	subw	a0,a5,a4
}
 3c8:	60a2                	ld	ra,8(sp)
 3ca:	6402                	ld	s0,0(sp)
 3cc:	0141                	addi	sp,sp,16
 3ce:	8082                	ret
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	bfdd                	j	3c8 <memcmp+0x2e>

00000000000003d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e406                	sd	ra,8(sp)
 3d8:	e022                	sd	s0,0(sp)
 3da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3dc:	f63ff0ef          	jal	33e <memmove>
}
 3e0:	60a2                	ld	ra,8(sp)
 3e2:	6402                	ld	s0,0(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret

00000000000003e8 <sbrk>:

char *
sbrk(int n) {
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e406                	sd	ra,8(sp)
 3ec:	e022                	sd	s0,0(sp)
 3ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3f0:	4585                	li	a1,1
 3f2:	0b2000ef          	jal	4a4 <sys_sbrk>
}
 3f6:	60a2                	ld	ra,8(sp)
 3f8:	6402                	ld	s0,0(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret

00000000000003fe <sbrklazy>:

char *
sbrklazy(int n) {
 3fe:	1141                	addi	sp,sp,-16
 400:	e406                	sd	ra,8(sp)
 402:	e022                	sd	s0,0(sp)
 404:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 406:	4589                	li	a1,2
 408:	09c000ef          	jal	4a4 <sys_sbrk>
}
 40c:	60a2                	ld	ra,8(sp)
 40e:	6402                	ld	s0,0(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret

0000000000000414 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 414:	4885                	li	a7,1
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <exit>:
.global exit
exit:
 li a7, SYS_exit
 41c:	4889                	li	a7,2
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <wait>:
.global wait
wait:
 li a7, SYS_wait
 424:	488d                	li	a7,3
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 42c:	4891                	li	a7,4
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <read>:
.global read
read:
 li a7, SYS_read
 434:	4895                	li	a7,5
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <write>:
.global write
write:
 li a7, SYS_write
 43c:	48c1                	li	a7,16
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <close>:
.global close
close:
 li a7, SYS_close
 444:	48d5                	li	a7,21
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <kill>:
.global kill
kill:
 li a7, SYS_kill
 44c:	4899                	li	a7,6
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <exec>:
.global exec
exec:
 li a7, SYS_exec
 454:	489d                	li	a7,7
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <open>:
.global open
open:
 li a7, SYS_open
 45c:	48bd                	li	a7,15
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 464:	48c5                	li	a7,17
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 46c:	48c9                	li	a7,18
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 474:	48a1                	li	a7,8
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <link>:
.global link
link:
 li a7, SYS_link
 47c:	48cd                	li	a7,19
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 484:	48d1                	li	a7,20
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 48c:	48a5                	li	a7,9
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <dup>:
.global dup
dup:
 li a7, SYS_dup
 494:	48a9                	li	a7,10
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 49c:	48ad                	li	a7,11
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4a4:	48b1                	li	a7,12
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <pause>:
.global pause
pause:
 li a7, SYS_pause
 4ac:	48b5                	li	a7,13
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b4:	48b9                	li	a7,14
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <kps>:
.global kps
kps:
 li a7, SYS_kps
 4bc:	48d9                	li	a7,22
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 4c4:	48dd                	li	a7,23
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 4cc:	48e1                	li	a7,24
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 4d4:	48e5                	li	a7,25
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 4dc:	48e9                	li	a7,26
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e4:	1101                	addi	sp,sp,-32
 4e6:	ec06                	sd	ra,24(sp)
 4e8:	e822                	sd	s0,16(sp)
 4ea:	1000                	addi	s0,sp,32
 4ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f0:	4605                	li	a2,1
 4f2:	fef40593          	addi	a1,s0,-17
 4f6:	f47ff0ef          	jal	43c <write>
}
 4fa:	60e2                	ld	ra,24(sp)
 4fc:	6442                	ld	s0,16(sp)
 4fe:	6105                	addi	sp,sp,32
 500:	8082                	ret

0000000000000502 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 502:	715d                	addi	sp,sp,-80
 504:	e486                	sd	ra,72(sp)
 506:	e0a2                	sd	s0,64(sp)
 508:	f84a                	sd	s2,48(sp)
 50a:	f44e                	sd	s3,40(sp)
 50c:	0880                	addi	s0,sp,80
 50e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 510:	c6d1                	beqz	a3,59c <printint+0x9a>
 512:	0805d563          	bgez	a1,59c <printint+0x9a>
    neg = 1;
    x = -xx;
 516:	40b005b3          	neg	a1,a1
    neg = 1;
 51a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 51c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 520:	86ce                	mv	a3,s3
  i = 0;
 522:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 524:	00001817          	auipc	a6,0x1
 528:	88480813          	addi	a6,a6,-1916 # da8 <digits>
 52c:	88ba                	mv	a7,a4
 52e:	0017051b          	addiw	a0,a4,1
 532:	872a                	mv	a4,a0
 534:	02c5f7b3          	remu	a5,a1,a2
 538:	97c2                	add	a5,a5,a6
 53a:	0007c783          	lbu	a5,0(a5)
 53e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 542:	87ae                	mv	a5,a1
 544:	02c5d5b3          	divu	a1,a1,a2
 548:	0685                	addi	a3,a3,1
 54a:	fec7f1e3          	bgeu	a5,a2,52c <printint+0x2a>
  if(neg)
 54e:	00030c63          	beqz	t1,566 <printint+0x64>
    buf[i++] = '-';
 552:	fd050793          	addi	a5,a0,-48
 556:	00878533          	add	a0,a5,s0
 55a:	02d00793          	li	a5,45
 55e:	fef50423          	sb	a5,-24(a0)
 562:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 566:	02e05563          	blez	a4,590 <printint+0x8e>
 56a:	fc26                	sd	s1,56(sp)
 56c:	377d                	addiw	a4,a4,-1
 56e:	00e984b3          	add	s1,s3,a4
 572:	19fd                	addi	s3,s3,-1
 574:	99ba                	add	s3,s3,a4
 576:	1702                	slli	a4,a4,0x20
 578:	9301                	srli	a4,a4,0x20
 57a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 57e:	0004c583          	lbu	a1,0(s1)
 582:	854a                	mv	a0,s2
 584:	f61ff0ef          	jal	4e4 <putc>
  while(--i >= 0)
 588:	14fd                	addi	s1,s1,-1
 58a:	ff349ae3          	bne	s1,s3,57e <printint+0x7c>
 58e:	74e2                	ld	s1,56(sp)
}
 590:	60a6                	ld	ra,72(sp)
 592:	6406                	ld	s0,64(sp)
 594:	7942                	ld	s2,48(sp)
 596:	79a2                	ld	s3,40(sp)
 598:	6161                	addi	sp,sp,80
 59a:	8082                	ret
  neg = 0;
 59c:	4301                	li	t1,0
 59e:	bfbd                	j	51c <printint+0x1a>

00000000000005a0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a0:	711d                	addi	sp,sp,-96
 5a2:	ec86                	sd	ra,88(sp)
 5a4:	e8a2                	sd	s0,80(sp)
 5a6:	e4a6                	sd	s1,72(sp)
 5a8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5aa:	0005c483          	lbu	s1,0(a1)
 5ae:	22048363          	beqz	s1,7d4 <vprintf+0x234>
 5b2:	e0ca                	sd	s2,64(sp)
 5b4:	fc4e                	sd	s3,56(sp)
 5b6:	f852                	sd	s4,48(sp)
 5b8:	f456                	sd	s5,40(sp)
 5ba:	f05a                	sd	s6,32(sp)
 5bc:	ec5e                	sd	s7,24(sp)
 5be:	e862                	sd	s8,16(sp)
 5c0:	8b2a                	mv	s6,a0
 5c2:	8a2e                	mv	s4,a1
 5c4:	8bb2                	mv	s7,a2
  state = 0;
 5c6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5c8:	4901                	li	s2,0
 5ca:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5cc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5d0:	06400c13          	li	s8,100
 5d4:	a00d                	j	5f6 <vprintf+0x56>
        putc(fd, c0);
 5d6:	85a6                	mv	a1,s1
 5d8:	855a                	mv	a0,s6
 5da:	f0bff0ef          	jal	4e4 <putc>
 5de:	a019                	j	5e4 <vprintf+0x44>
    } else if(state == '%'){
 5e0:	03598363          	beq	s3,s5,606 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5e4:	0019079b          	addiw	a5,s2,1
 5e8:	893e                	mv	s2,a5
 5ea:	873e                	mv	a4,a5
 5ec:	97d2                	add	a5,a5,s4
 5ee:	0007c483          	lbu	s1,0(a5)
 5f2:	1c048a63          	beqz	s1,7c6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5f6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5fa:	fe0993e3          	bnez	s3,5e0 <vprintf+0x40>
      if(c0 == '%'){
 5fe:	fd579ce3          	bne	a5,s5,5d6 <vprintf+0x36>
        state = '%';
 602:	89be                	mv	s3,a5
 604:	b7c5                	j	5e4 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 606:	00ea06b3          	add	a3,s4,a4
 60a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 60e:	1c060863          	beqz	a2,7de <vprintf+0x23e>
      if(c0 == 'd'){
 612:	03878763          	beq	a5,s8,640 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 616:	f9478693          	addi	a3,a5,-108
 61a:	0016b693          	seqz	a3,a3
 61e:	f9c60593          	addi	a1,a2,-100
 622:	e99d                	bnez	a1,658 <vprintf+0xb8>
 624:	ca95                	beqz	a3,658 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 626:	008b8493          	addi	s1,s7,8
 62a:	4685                	li	a3,1
 62c:	4629                	li	a2,10
 62e:	000bb583          	ld	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	ecfff0ef          	jal	502 <printint>
        i += 1;
 638:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 63c:	4981                	li	s3,0
 63e:	b75d                	j	5e4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 640:	008b8493          	addi	s1,s7,8
 644:	4685                	li	a3,1
 646:	4629                	li	a2,10
 648:	000ba583          	lw	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	eb5ff0ef          	jal	502 <printint>
 652:	8ba6                	mv	s7,s1
      state = 0;
 654:	4981                	li	s3,0
 656:	b779                	j	5e4 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 658:	9752                	add	a4,a4,s4
 65a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65e:	f9460713          	addi	a4,a2,-108
 662:	00173713          	seqz	a4,a4
 666:	8f75                	and	a4,a4,a3
 668:	f9c58513          	addi	a0,a1,-100
 66c:	18051363          	bnez	a0,7f2 <vprintf+0x252>
 670:	18070163          	beqz	a4,7f2 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	008b8493          	addi	s1,s7,8
 678:	4685                	li	a3,1
 67a:	4629                	li	a2,10
 67c:	000bb583          	ld	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	e81ff0ef          	jal	502 <printint>
        i += 2;
 686:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	8ba6                	mv	s7,s1
      state = 0;
 68a:	4981                	li	s3,0
        i += 2;
 68c:	bfa1                	j	5e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 68e:	008b8493          	addi	s1,s7,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000be583          	lwu	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	e67ff0ef          	jal	502 <printint>
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b781                	j	5e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	008b8493          	addi	s1,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	e4fff0ef          	jal	502 <printint>
        i += 1;
 6b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	8ba6                	mv	s7,s1
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b71d                	j	5e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c0:	008b8493          	addi	s1,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4629                	li	a2,10
 6c8:	000bb583          	ld	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	e35ff0ef          	jal	502 <printint>
        i += 2;
 6d2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d4:	8ba6                	mv	s7,s1
      state = 0;
 6d6:	4981                	li	s3,0
        i += 2;
 6d8:	b731                	j	5e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6da:	008b8493          	addi	s1,s7,8
 6de:	4681                	li	a3,0
 6e0:	4641                	li	a2,16
 6e2:	000be583          	lwu	a1,0(s7)
 6e6:	855a                	mv	a0,s6
 6e8:	e1bff0ef          	jal	502 <printint>
 6ec:	8ba6                	mv	s7,s1
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bdd5                	j	5e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	008b8493          	addi	s1,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000bb583          	ld	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	e03ff0ef          	jal	502 <printint>
        i += 1;
 704:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	8ba6                	mv	s7,s1
      state = 0;
 708:	4981                	li	s3,0
 70a:	bde9                	j	5e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 70c:	008b8493          	addi	s1,s7,8
 710:	4681                	li	a3,0
 712:	4641                	li	a2,16
 714:	000bb583          	ld	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	de9ff0ef          	jal	502 <printint>
        i += 2;
 71e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 720:	8ba6                	mv	s7,s1
      state = 0;
 722:	4981                	li	s3,0
        i += 2;
 724:	b5c1                	j	5e4 <vprintf+0x44>
 726:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 728:	008b8793          	addi	a5,s7,8
 72c:	8cbe                	mv	s9,a5
 72e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 732:	03000593          	li	a1,48
 736:	855a                	mv	a0,s6
 738:	dadff0ef          	jal	4e4 <putc>
  putc(fd, 'x');
 73c:	07800593          	li	a1,120
 740:	855a                	mv	a0,s6
 742:	da3ff0ef          	jal	4e4 <putc>
 746:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 748:	00000b97          	auipc	s7,0x0
 74c:	660b8b93          	addi	s7,s7,1632 # da8 <digits>
 750:	03c9d793          	srli	a5,s3,0x3c
 754:	97de                	add	a5,a5,s7
 756:	0007c583          	lbu	a1,0(a5)
 75a:	855a                	mv	a0,s6
 75c:	d89ff0ef          	jal	4e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 760:	0992                	slli	s3,s3,0x4
 762:	34fd                	addiw	s1,s1,-1
 764:	f4f5                	bnez	s1,750 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 766:	8be6                	mv	s7,s9
      state = 0;
 768:	4981                	li	s3,0
 76a:	6ca2                	ld	s9,8(sp)
 76c:	bda5                	j	5e4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 76e:	008b8493          	addi	s1,s7,8
 772:	000bc583          	lbu	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	d6dff0ef          	jal	4e4 <putc>
 77c:	8ba6                	mv	s7,s1
      state = 0;
 77e:	4981                	li	s3,0
 780:	b595                	j	5e4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 782:	008b8993          	addi	s3,s7,8
 786:	000bb483          	ld	s1,0(s7)
 78a:	cc91                	beqz	s1,7a6 <vprintf+0x206>
        for(; *s; s++)
 78c:	0004c583          	lbu	a1,0(s1)
 790:	c985                	beqz	a1,7c0 <vprintf+0x220>
          putc(fd, *s);
 792:	855a                	mv	a0,s6
 794:	d51ff0ef          	jal	4e4 <putc>
        for(; *s; s++)
 798:	0485                	addi	s1,s1,1
 79a:	0004c583          	lbu	a1,0(s1)
 79e:	f9f5                	bnez	a1,792 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 7a0:	8bce                	mv	s7,s3
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b581                	j	5e4 <vprintf+0x44>
          s = "(null)";
 7a6:	00000497          	auipc	s1,0x0
 7aa:	5fa48493          	addi	s1,s1,1530 # da0 <malloc+0x45e>
        for(; *s; s++)
 7ae:	02800593          	li	a1,40
 7b2:	b7c5                	j	792 <vprintf+0x1f2>
        putc(fd, '%');
 7b4:	85be                	mv	a1,a5
 7b6:	855a                	mv	a0,s6
 7b8:	d2dff0ef          	jal	4e4 <putc>
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b51d                	j	5e4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7c0:	8bce                	mv	s7,s3
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	b505                	j	5e4 <vprintf+0x44>
 7c6:	6906                	ld	s2,64(sp)
 7c8:	79e2                	ld	s3,56(sp)
 7ca:	7a42                	ld	s4,48(sp)
 7cc:	7aa2                	ld	s5,40(sp)
 7ce:	7b02                	ld	s6,32(sp)
 7d0:	6be2                	ld	s7,24(sp)
 7d2:	6c42                	ld	s8,16(sp)
    }
  }
}
 7d4:	60e6                	ld	ra,88(sp)
 7d6:	6446                	ld	s0,80(sp)
 7d8:	64a6                	ld	s1,72(sp)
 7da:	6125                	addi	sp,sp,96
 7dc:	8082                	ret
      if(c0 == 'd'){
 7de:	06400713          	li	a4,100
 7e2:	e4e78fe3          	beq	a5,a4,640 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7e6:	f9478693          	addi	a3,a5,-108
 7ea:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7ee:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7f0:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7f2:	07500513          	li	a0,117
 7f6:	e8a78ce3          	beq	a5,a0,68e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7fa:	f8b60513          	addi	a0,a2,-117
 7fe:	e119                	bnez	a0,804 <vprintf+0x264>
 800:	ea0693e3          	bnez	a3,6a6 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 804:	f8b58513          	addi	a0,a1,-117
 808:	e119                	bnez	a0,80e <vprintf+0x26e>
 80a:	ea071be3          	bnez	a4,6c0 <vprintf+0x120>
      } else if(c0 == 'x'){
 80e:	07800513          	li	a0,120
 812:	eca784e3          	beq	a5,a0,6da <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 816:	f8860613          	addi	a2,a2,-120
 81a:	e219                	bnez	a2,820 <vprintf+0x280>
 81c:	ec069be3          	bnez	a3,6f2 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 820:	f8858593          	addi	a1,a1,-120
 824:	e199                	bnez	a1,82a <vprintf+0x28a>
 826:	ee0713e3          	bnez	a4,70c <vprintf+0x16c>
      } else if(c0 == 'p'){
 82a:	07000713          	li	a4,112
 82e:	eee78ce3          	beq	a5,a4,726 <vprintf+0x186>
      } else if(c0 == 'c'){
 832:	06300713          	li	a4,99
 836:	f2e78ce3          	beq	a5,a4,76e <vprintf+0x1ce>
      } else if(c0 == 's'){
 83a:	07300713          	li	a4,115
 83e:	f4e782e3          	beq	a5,a4,782 <vprintf+0x1e2>
      } else if(c0 == '%'){
 842:	02500713          	li	a4,37
 846:	f6e787e3          	beq	a5,a4,7b4 <vprintf+0x214>
        putc(fd, '%');
 84a:	02500593          	li	a1,37
 84e:	855a                	mv	a0,s6
 850:	c95ff0ef          	jal	4e4 <putc>
        putc(fd, c0);
 854:	85a6                	mv	a1,s1
 856:	855a                	mv	a0,s6
 858:	c8dff0ef          	jal	4e4 <putc>
      state = 0;
 85c:	4981                	li	s3,0
 85e:	b359                	j	5e4 <vprintf+0x44>

0000000000000860 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 860:	715d                	addi	sp,sp,-80
 862:	ec06                	sd	ra,24(sp)
 864:	e822                	sd	s0,16(sp)
 866:	1000                	addi	s0,sp,32
 868:	e010                	sd	a2,0(s0)
 86a:	e414                	sd	a3,8(s0)
 86c:	e818                	sd	a4,16(s0)
 86e:	ec1c                	sd	a5,24(s0)
 870:	03043023          	sd	a6,32(s0)
 874:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 878:	8622                	mv	a2,s0
 87a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 87e:	d23ff0ef          	jal	5a0 <vprintf>
}
 882:	60e2                	ld	ra,24(sp)
 884:	6442                	ld	s0,16(sp)
 886:	6161                	addi	sp,sp,80
 888:	8082                	ret

000000000000088a <printf>:

void
printf(const char *fmt, ...)
{
 88a:	711d                	addi	sp,sp,-96
 88c:	ec06                	sd	ra,24(sp)
 88e:	e822                	sd	s0,16(sp)
 890:	1000                	addi	s0,sp,32
 892:	e40c                	sd	a1,8(s0)
 894:	e810                	sd	a2,16(s0)
 896:	ec14                	sd	a3,24(s0)
 898:	f018                	sd	a4,32(s0)
 89a:	f41c                	sd	a5,40(s0)
 89c:	03043823          	sd	a6,48(s0)
 8a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a4:	00840613          	addi	a2,s0,8
 8a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ac:	85aa                	mv	a1,a0
 8ae:	4505                	li	a0,1
 8b0:	cf1ff0ef          	jal	5a0 <vprintf>
}
 8b4:	60e2                	ld	ra,24(sp)
 8b6:	6442                	ld	s0,16(sp)
 8b8:	6125                	addi	sp,sp,96
 8ba:	8082                	ret

00000000000008bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8bc:	1141                	addi	sp,sp,-16
 8be:	e406                	sd	ra,8(sp)
 8c0:	e022                	sd	s0,0(sp)
 8c2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c8:	00000797          	auipc	a5,0x0
 8cc:	7387b783          	ld	a5,1848(a5) # 1000 <freep>
 8d0:	a039                	j	8de <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d2:	6398                	ld	a4,0(a5)
 8d4:	00e7e463          	bltu	a5,a4,8dc <free+0x20>
 8d8:	00e6ea63          	bltu	a3,a4,8ec <free+0x30>
{
 8dc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	fed7fae3          	bgeu	a5,a3,8d2 <free+0x16>
 8e2:	6398                	ld	a4,0(a5)
 8e4:	00e6e463          	bltu	a3,a4,8ec <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e8:	fee7eae3          	bltu	a5,a4,8dc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8ec:	ff852583          	lw	a1,-8(a0)
 8f0:	6390                	ld	a2,0(a5)
 8f2:	02059813          	slli	a6,a1,0x20
 8f6:	01c85713          	srli	a4,a6,0x1c
 8fa:	9736                	add	a4,a4,a3
 8fc:	02e60563          	beq	a2,a4,926 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 900:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 904:	4790                	lw	a2,8(a5)
 906:	02061593          	slli	a1,a2,0x20
 90a:	01c5d713          	srli	a4,a1,0x1c
 90e:	973e                	add	a4,a4,a5
 910:	02e68263          	beq	a3,a4,934 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 914:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 916:	00000717          	auipc	a4,0x0
 91a:	6ef73523          	sd	a5,1770(a4) # 1000 <freep>
}
 91e:	60a2                	ld	ra,8(sp)
 920:	6402                	ld	s0,0(sp)
 922:	0141                	addi	sp,sp,16
 924:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 926:	4618                	lw	a4,8(a2)
 928:	9f2d                	addw	a4,a4,a1
 92a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 92e:	6398                	ld	a4,0(a5)
 930:	6310                	ld	a2,0(a4)
 932:	b7f9                	j	900 <free+0x44>
    p->s.size += bp->s.size;
 934:	ff852703          	lw	a4,-8(a0)
 938:	9f31                	addw	a4,a4,a2
 93a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 93c:	ff053683          	ld	a3,-16(a0)
 940:	bfd1                	j	914 <free+0x58>

0000000000000942 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 942:	7139                	addi	sp,sp,-64
 944:	fc06                	sd	ra,56(sp)
 946:	f822                	sd	s0,48(sp)
 948:	f04a                	sd	s2,32(sp)
 94a:	ec4e                	sd	s3,24(sp)
 94c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94e:	02051993          	slli	s3,a0,0x20
 952:	0209d993          	srli	s3,s3,0x20
 956:	09bd                	addi	s3,s3,15
 958:	0049d993          	srli	s3,s3,0x4
 95c:	2985                	addiw	s3,s3,1
 95e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 960:	00000517          	auipc	a0,0x0
 964:	6a053503          	ld	a0,1696(a0) # 1000 <freep>
 968:	c905                	beqz	a0,998 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96c:	4798                	lw	a4,8(a5)
 96e:	09377663          	bgeu	a4,s3,9fa <malloc+0xb8>
 972:	f426                	sd	s1,40(sp)
 974:	e852                	sd	s4,16(sp)
 976:	e456                	sd	s5,8(sp)
 978:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 97a:	8a4e                	mv	s4,s3
 97c:	6705                	lui	a4,0x1
 97e:	00e9f363          	bgeu	s3,a4,984 <malloc+0x42>
 982:	6a05                	lui	s4,0x1
 984:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 988:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 98c:	00000497          	auipc	s1,0x0
 990:	67448493          	addi	s1,s1,1652 # 1000 <freep>
  if(p == SBRK_ERROR)
 994:	5afd                	li	s5,-1
 996:	a83d                	j	9d4 <malloc+0x92>
 998:	f426                	sd	s1,40(sp)
 99a:	e852                	sd	s4,16(sp)
 99c:	e456                	sd	s5,8(sp)
 99e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9a0:	00000797          	auipc	a5,0x0
 9a4:	67078793          	addi	a5,a5,1648 # 1010 <base>
 9a8:	00000717          	auipc	a4,0x0
 9ac:	64f73c23          	sd	a5,1624(a4) # 1000 <freep>
 9b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9b6:	b7d1                	j	97a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9b8:	6398                	ld	a4,0(a5)
 9ba:	e118                	sd	a4,0(a0)
 9bc:	a899                	j	a12 <malloc+0xd0>
  hp->s.size = nu;
 9be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c2:	0541                	addi	a0,a0,16
 9c4:	ef9ff0ef          	jal	8bc <free>
  return freep;
 9c8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9ca:	c125                	beqz	a0,a2a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ce:	4798                	lw	a4,8(a5)
 9d0:	03277163          	bgeu	a4,s2,9f2 <malloc+0xb0>
    if(p == freep)
 9d4:	6098                	ld	a4,0(s1)
 9d6:	853e                	mv	a0,a5
 9d8:	fef71ae3          	bne	a4,a5,9cc <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9dc:	8552                	mv	a0,s4
 9de:	a0bff0ef          	jal	3e8 <sbrk>
  if(p == SBRK_ERROR)
 9e2:	fd551ee3          	bne	a0,s5,9be <malloc+0x7c>
        return 0;
 9e6:	4501                	li	a0,0
 9e8:	74a2                	ld	s1,40(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
 9f0:	a03d                	j	a1e <malloc+0xdc>
 9f2:	74a2                	ld	s1,40(sp)
 9f4:	6a42                	ld	s4,16(sp)
 9f6:	6aa2                	ld	s5,8(sp)
 9f8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9fa:	fae90fe3          	beq	s2,a4,9b8 <malloc+0x76>
        p->s.size -= nunits;
 9fe:	4137073b          	subw	a4,a4,s3
 a02:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a04:	02071693          	slli	a3,a4,0x20
 a08:	01c6d713          	srli	a4,a3,0x1c
 a0c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a0e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a12:	00000717          	auipc	a4,0x0
 a16:	5ea73723          	sd	a0,1518(a4) # 1000 <freep>
      return (void*)(p + 1);
 a1a:	01078513          	addi	a0,a5,16
  }
}
 a1e:	70e2                	ld	ra,56(sp)
 a20:	7442                	ld	s0,48(sp)
 a22:	7902                	ld	s2,32(sp)
 a24:	69e2                	ld	s3,24(sp)
 a26:	6121                	addi	sp,sp,64
 a28:	8082                	ret
 a2a:	74a2                	ld	s1,40(sp)
 a2c:	6a42                	ld	s4,16(sp)
 a2e:	6aa2                	ld	s5,8(sp)
 a30:	6b02                	ld	s6,0(sp)
 a32:	b7f5                	j	a1e <malloc+0xdc>
