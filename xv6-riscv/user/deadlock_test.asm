
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
   c:	9f850513          	addi	a0,a0,-1544 # a00 <malloc+0x102>
  10:	03b000ef          	jal	84a <printf>

  // First, test manual check when no deadlock exists
  printf("Test 1: No deadlock - calling check_deadlock()...\n");
  14:	00001517          	auipc	a0,0x1
  18:	a2c50513          	addi	a0,a0,-1492 # a40 <malloc+0x142>
  1c:	02f000ef          	jal	84a <printf>
  int result = check_deadlock();
  20:	49a000ef          	jal	4ba <check_deadlock>
  24:	85aa                	mv	a1,a0
  printf("Result: %d (0 means no deadlock)\n\n", result);
  26:	00001517          	auipc	a0,0x1
  2a:	a5250513          	addi	a0,a0,-1454 # a78 <malloc+0x17a>
  2e:	01d000ef          	jal	84a <printf>

  printf("Test 2: Simulating deadlock scenario\n");
  32:	00001517          	auipc	a0,0x1
  36:	a6e50513          	addi	a0,a0,-1426 # aa0 <malloc+0x1a2>
  3a:	011000ef          	jal	84a <printf>
  printf("(In a real scenario, two processes would hold resources\n");
  3e:	00001517          	auipc	a0,0x1
  42:	a8a50513          	addi	a0,a0,-1398 # ac8 <malloc+0x1ca>
  46:	005000ef          	jal	84a <printf>
  printf(" and wait for each other's resources, creating a cycle\n");
  4a:	00001517          	auipc	a0,0x1
  4e:	abe50513          	addi	a0,a0,-1346 # b08 <malloc+0x20a>
  52:	7f8000ef          	jal	84a <printf>
  printf(" in the resource allocation graph. The kernel would then\n");
  56:	00001517          	auipc	a0,0x1
  5a:	aea50513          	addi	a0,a0,-1302 # b40 <malloc+0x242>
  5e:	7ec000ef          	jal	84a <printf>
  printf(" detect this cycle and kill the process that consumed\n");
  62:	00001517          	auipc	a0,0x1
  66:	b1e50513          	addi	a0,a0,-1250 # b80 <malloc+0x282>
  6a:	7e0000ef          	jal	84a <printf>
  printf(" the most energy to break the deadlock.)\n\n");
  6e:	00001517          	auipc	a0,0x1
  72:	b4a50513          	addi	a0,a0,-1206 # bb8 <malloc+0x2ba>
  76:	7d4000ef          	jal	84a <printf>

  // Fork two children that will try to create a deadlock
  int pid1 = fork();
  7a:	378000ef          	jal	3f2 <fork>
  if(pid1 == 0){
  7e:	ed21                	bnez	a0,d6 <main+0xd6>
    // Child 1: burn some CPU (high energy) then sleep to simulate waiting
    printf("Child 1 (pid=%d): Running CPU-intensive work (high energy)...\n", getpid());
  80:	3fa000ef          	jal	47a <getpid>
  84:	85aa                	mv	a1,a0
  86:	00001517          	auipc	a0,0x1
  8a:	b6250513          	addi	a0,a0,-1182 # be8 <malloc+0x2ea>
  8e:	7bc000ef          	jal	84a <printf>
    for(volatile int i = 0; i < 1000000; i++); // burn CPU = accumulate energy_consumed
  92:	fe042423          	sw	zero,-24(s0)
  96:	fe842703          	lw	a4,-24(s0)
  9a:	2701                	sext.w	a4,a4
  9c:	000f47b7          	lui	a5,0xf4
  a0:	23f78793          	addi	a5,a5,575 # f423f <base+0xf222f>
  a4:	00e7cd63          	blt	a5,a4,be <main+0xbe>
  a8:	873e                	mv	a4,a5
  aa:	fe842783          	lw	a5,-24(s0)
  ae:	2785                	addiw	a5,a5,1
  b0:	fef42423          	sw	a5,-24(s0)
  b4:	fe842783          	lw	a5,-24(s0)
  b8:	2781                	sext.w	a5,a5
  ba:	fef758e3          	bge	a4,a5,aa <main+0xaa>
    printf("Child 1 (pid=%d): Done. Energy consumed is high.\n", getpid());
  be:	3bc000ef          	jal	47a <getpid>
  c2:	85aa                	mv	a1,a0
  c4:	00001517          	auipc	a0,0x1
  c8:	b6450513          	addi	a0,a0,-1180 # c28 <malloc+0x32a>
  cc:	77e000ef          	jal	84a <printf>
    exit(0);
  d0:	4501                	li	a0,0
  d2:	328000ef          	jal	3fa <exit>
  }

  int pid2 = fork();
  d6:	31c000ef          	jal	3f2 <fork>
  if(pid2 == 0){
  da:	e929                	bnez	a0,12c <main+0x12c>
    // Child 2: do less work (low energy)
    printf("Child 2 (pid=%d): Running light work (low energy)...\n", getpid());
  dc:	39e000ef          	jal	47a <getpid>
  e0:	85aa                	mv	a1,a0
  e2:	00001517          	auipc	a0,0x1
  e6:	b7e50513          	addi	a0,a0,-1154 # c60 <malloc+0x362>
  ea:	760000ef          	jal	84a <printf>
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
 114:	366000ef          	jal	47a <getpid>
 118:	85aa                	mv	a1,a0
 11a:	00001517          	auipc	a0,0x1
 11e:	b7e50513          	addi	a0,a0,-1154 # c98 <malloc+0x39a>
 122:	728000ef          	jal	84a <printf>
    exit(0);
 126:	4501                	li	a0,0
 128:	2d2000ef          	jal	3fa <exit>
  }

  // Parent waits
  int status;
  wait(&status);
 12c:	fec40513          	addi	a0,s0,-20
 130:	2d2000ef          	jal	402 <wait>
  wait(&status);
 134:	fec40513          	addi	a0,s0,-20
 138:	2ca000ef          	jal	402 <wait>

  printf("\nTest Complete\n");
 13c:	00001517          	auipc	a0,0x1
 140:	b9450513          	addi	a0,a0,-1132 # cd0 <malloc+0x3d2>
 144:	706000ef          	jal	84a <printf>
  printf("In a real deadlock, the kernel would have killed the process\n");
 148:	00001517          	auipc	a0,0x1
 14c:	b9850513          	addi	a0,a0,-1128 # ce0 <malloc+0x3e2>
 150:	6fa000ef          	jal	84a <printf>
  printf("with the HIGHEST energy_consumed, saving system resources.\n");
 154:	00001517          	auipc	a0,0x1
 158:	bcc50513          	addi	a0,a0,-1076 # d20 <malloc+0x422>
 15c:	6ee000ef          	jal	84a <printf>

  exit(0);
 160:	4501                	li	a0,0
 162:	298000ef          	jal	3fa <exit>

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
 172:	288000ef          	jal	3fa <exit>

0000000000000176 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 176:	1141                	addi	sp,sp,-16
 178:	e422                	sd	s0,8(sp)
 17a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 17c:	87aa                	mv	a5,a0
 17e:	0585                	addi	a1,a1,1
 180:	0785                	addi	a5,a5,1
 182:	fff5c703          	lbu	a4,-1(a1)
 186:	fee78fa3          	sb	a4,-1(a5)
 18a:	fb75                	bnez	a4,17e <strcpy+0x8>
    ;
  return os;
}
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret

0000000000000192 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 198:	00054783          	lbu	a5,0(a0)
 19c:	cb91                	beqz	a5,1b0 <strcmp+0x1e>
 19e:	0005c703          	lbu	a4,0(a1)
 1a2:	00f71763          	bne	a4,a5,1b0 <strcmp+0x1e>
    p++, q++;
 1a6:	0505                	addi	a0,a0,1
 1a8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	fbe5                	bnez	a5,19e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1b0:	0005c503          	lbu	a0,0(a1)
}
 1b4:	40a7853b          	subw	a0,a5,a0
 1b8:	6422                	ld	s0,8(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strlen>:

uint
strlen(const char *s)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e422                	sd	s0,8(sp)
 1c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	cf91                	beqz	a5,1e4 <strlen+0x26>
 1ca:	0505                	addi	a0,a0,1
 1cc:	87aa                	mv	a5,a0
 1ce:	86be                	mv	a3,a5
 1d0:	0785                	addi	a5,a5,1
 1d2:	fff7c703          	lbu	a4,-1(a5)
 1d6:	ff65                	bnez	a4,1ce <strlen+0x10>
 1d8:	40a6853b          	subw	a0,a3,a0
 1dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  for(n = 0; s[n]; n++)
 1e4:	4501                	li	a0,0
 1e6:	bfe5                	j	1de <strlen+0x20>

00000000000001e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ee:	ca19                	beqz	a2,204 <memset+0x1c>
 1f0:	87aa                	mv	a5,a0
 1f2:	1602                	slli	a2,a2,0x20
 1f4:	9201                	srli	a2,a2,0x20
 1f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1fe:	0785                	addi	a5,a5,1
 200:	fee79de3          	bne	a5,a4,1fa <memset+0x12>
  }
  return dst;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret

000000000000020a <strchr>:

char*
strchr(const char *s, char c)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 210:	00054783          	lbu	a5,0(a0)
 214:	cb99                	beqz	a5,22a <strchr+0x20>
    if(*s == c)
 216:	00f58763          	beq	a1,a5,224 <strchr+0x1a>
  for(; *s; s++)
 21a:	0505                	addi	a0,a0,1
 21c:	00054783          	lbu	a5,0(a0)
 220:	fbfd                	bnez	a5,216 <strchr+0xc>
      return (char*)s;
  return 0;
 222:	4501                	li	a0,0
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  return 0;
 22a:	4501                	li	a0,0
 22c:	bfe5                	j	224 <strchr+0x1a>

000000000000022e <gets>:

char*
gets(char *buf, int max)
{
 22e:	711d                	addi	sp,sp,-96
 230:	ec86                	sd	ra,88(sp)
 232:	e8a2                	sd	s0,80(sp)
 234:	e4a6                	sd	s1,72(sp)
 236:	e0ca                	sd	s2,64(sp)
 238:	fc4e                	sd	s3,56(sp)
 23a:	f852                	sd	s4,48(sp)
 23c:	f456                	sd	s5,40(sp)
 23e:	f05a                	sd	s6,32(sp)
 240:	ec5e                	sd	s7,24(sp)
 242:	1080                	addi	s0,sp,96
 244:	8baa                	mv	s7,a0
 246:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 248:	892a                	mv	s2,a0
 24a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 24c:	4aa9                	li	s5,10
 24e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 250:	89a6                	mv	s3,s1
 252:	2485                	addiw	s1,s1,1
 254:	0344d663          	bge	s1,s4,280 <gets+0x52>
    cc = read(0, &c, 1);
 258:	4605                	li	a2,1
 25a:	faf40593          	addi	a1,s0,-81
 25e:	4501                	li	a0,0
 260:	1b2000ef          	jal	412 <read>
    if(cc < 1)
 264:	00a05e63          	blez	a0,280 <gets+0x52>
    buf[i++] = c;
 268:	faf44783          	lbu	a5,-81(s0)
 26c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 270:	01578763          	beq	a5,s5,27e <gets+0x50>
 274:	0905                	addi	s2,s2,1
 276:	fd679de3          	bne	a5,s6,250 <gets+0x22>
    buf[i++] = c;
 27a:	89a6                	mv	s3,s1
 27c:	a011                	j	280 <gets+0x52>
 27e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 280:	99de                	add	s3,s3,s7
 282:	00098023          	sb	zero,0(s3)
  return buf;
}
 286:	855e                	mv	a0,s7
 288:	60e6                	ld	ra,88(sp)
 28a:	6446                	ld	s0,80(sp)
 28c:	64a6                	ld	s1,72(sp)
 28e:	6906                	ld	s2,64(sp)
 290:	79e2                	ld	s3,56(sp)
 292:	7a42                	ld	s4,48(sp)
 294:	7aa2                	ld	s5,40(sp)
 296:	7b02                	ld	s6,32(sp)
 298:	6be2                	ld	s7,24(sp)
 29a:	6125                	addi	sp,sp,96
 29c:	8082                	ret

000000000000029e <stat>:

int
stat(const char *n, struct stat *st)
{
 29e:	1101                	addi	sp,sp,-32
 2a0:	ec06                	sd	ra,24(sp)
 2a2:	e822                	sd	s0,16(sp)
 2a4:	e04a                	sd	s2,0(sp)
 2a6:	1000                	addi	s0,sp,32
 2a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2aa:	4581                	li	a1,0
 2ac:	18e000ef          	jal	43a <open>
  if(fd < 0)
 2b0:	02054263          	bltz	a0,2d4 <stat+0x36>
 2b4:	e426                	sd	s1,8(sp)
 2b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b8:	85ca                	mv	a1,s2
 2ba:	198000ef          	jal	452 <fstat>
 2be:	892a                	mv	s2,a0
  close(fd);
 2c0:	8526                	mv	a0,s1
 2c2:	160000ef          	jal	422 <close>
  return r;
 2c6:	64a2                	ld	s1,8(sp)
}
 2c8:	854a                	mv	a0,s2
 2ca:	60e2                	ld	ra,24(sp)
 2cc:	6442                	ld	s0,16(sp)
 2ce:	6902                	ld	s2,0(sp)
 2d0:	6105                	addi	sp,sp,32
 2d2:	8082                	ret
    return -1;
 2d4:	597d                	li	s2,-1
 2d6:	bfcd                	j	2c8 <stat+0x2a>

00000000000002d8 <atoi>:

int
atoi(const char *s)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2de:	00054683          	lbu	a3,0(a0)
 2e2:	fd06879b          	addiw	a5,a3,-48
 2e6:	0ff7f793          	zext.b	a5,a5
 2ea:	4625                	li	a2,9
 2ec:	02f66863          	bltu	a2,a5,31c <atoi+0x44>
 2f0:	872a                	mv	a4,a0
  n = 0;
 2f2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2f4:	0705                	addi	a4,a4,1
 2f6:	0025179b          	slliw	a5,a0,0x2
 2fa:	9fa9                	addw	a5,a5,a0
 2fc:	0017979b          	slliw	a5,a5,0x1
 300:	9fb5                	addw	a5,a5,a3
 302:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 306:	00074683          	lbu	a3,0(a4)
 30a:	fd06879b          	addiw	a5,a3,-48
 30e:	0ff7f793          	zext.b	a5,a5
 312:	fef671e3          	bgeu	a2,a5,2f4 <atoi+0x1c>
  return n;
}
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
  n = 0;
 31c:	4501                	li	a0,0
 31e:	bfe5                	j	316 <atoi+0x3e>

0000000000000320 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 326:	02b57463          	bgeu	a0,a1,34e <memmove+0x2e>
    while(n-- > 0)
 32a:	00c05f63          	blez	a2,348 <memmove+0x28>
 32e:	1602                	slli	a2,a2,0x20
 330:	9201                	srli	a2,a2,0x20
 332:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 336:	872a                	mv	a4,a0
      *dst++ = *src++;
 338:	0585                	addi	a1,a1,1
 33a:	0705                	addi	a4,a4,1
 33c:	fff5c683          	lbu	a3,-1(a1)
 340:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 344:	fef71ae3          	bne	a4,a5,338 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
    dst += n;
 34e:	00c50733          	add	a4,a0,a2
    src += n;
 352:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 354:	fec05ae3          	blez	a2,348 <memmove+0x28>
 358:	fff6079b          	addiw	a5,a2,-1
 35c:	1782                	slli	a5,a5,0x20
 35e:	9381                	srli	a5,a5,0x20
 360:	fff7c793          	not	a5,a5
 364:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 366:	15fd                	addi	a1,a1,-1
 368:	177d                	addi	a4,a4,-1
 36a:	0005c683          	lbu	a3,0(a1)
 36e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 372:	fee79ae3          	bne	a5,a4,366 <memmove+0x46>
 376:	bfc9                	j	348 <memmove+0x28>

0000000000000378 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e422                	sd	s0,8(sp)
 37c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 37e:	ca05                	beqz	a2,3ae <memcmp+0x36>
 380:	fff6069b          	addiw	a3,a2,-1
 384:	1682                	slli	a3,a3,0x20
 386:	9281                	srli	a3,a3,0x20
 388:	0685                	addi	a3,a3,1
 38a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 38c:	00054783          	lbu	a5,0(a0)
 390:	0005c703          	lbu	a4,0(a1)
 394:	00e79863          	bne	a5,a4,3a4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 398:	0505                	addi	a0,a0,1
    p2++;
 39a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 39c:	fed518e3          	bne	a0,a3,38c <memcmp+0x14>
  }
  return 0;
 3a0:	4501                	li	a0,0
 3a2:	a019                	j	3a8 <memcmp+0x30>
      return *p1 - *p2;
 3a4:	40e7853b          	subw	a0,a5,a4
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret
  return 0;
 3ae:	4501                	li	a0,0
 3b0:	bfe5                	j	3a8 <memcmp+0x30>

00000000000003b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e406                	sd	ra,8(sp)
 3b6:	e022                	sd	s0,0(sp)
 3b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ba:	f67ff0ef          	jal	320 <memmove>
}
 3be:	60a2                	ld	ra,8(sp)
 3c0:	6402                	ld	s0,0(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret

00000000000003c6 <sbrk>:

char *
sbrk(int n) {
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e406                	sd	ra,8(sp)
 3ca:	e022                	sd	s0,0(sp)
 3cc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3ce:	4585                	li	a1,1
 3d0:	0b2000ef          	jal	482 <sys_sbrk>
}
 3d4:	60a2                	ld	ra,8(sp)
 3d6:	6402                	ld	s0,0(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret

00000000000003dc <sbrklazy>:

char *
sbrklazy(int n) {
 3dc:	1141                	addi	sp,sp,-16
 3de:	e406                	sd	ra,8(sp)
 3e0:	e022                	sd	s0,0(sp)
 3e2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3e4:	4589                	li	a1,2
 3e6:	09c000ef          	jal	482 <sys_sbrk>
}
 3ea:	60a2                	ld	ra,8(sp)
 3ec:	6402                	ld	s0,0(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret

00000000000003f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f2:	4885                	li	a7,1
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fa:	4889                	li	a7,2
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <wait>:
.global wait
wait:
 li a7, SYS_wait
 402:	488d                	li	a7,3
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40a:	4891                	li	a7,4
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <read>:
.global read
read:
 li a7, SYS_read
 412:	4895                	li	a7,5
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <write>:
.global write
write:
 li a7, SYS_write
 41a:	48c1                	li	a7,16
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <close>:
.global close
close:
 li a7, SYS_close
 422:	48d5                	li	a7,21
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <kill>:
.global kill
kill:
 li a7, SYS_kill
 42a:	4899                	li	a7,6
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <exec>:
.global exec
exec:
 li a7, SYS_exec
 432:	489d                	li	a7,7
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <open>:
.global open
open:
 li a7, SYS_open
 43a:	48bd                	li	a7,15
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 442:	48c5                	li	a7,17
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44a:	48c9                	li	a7,18
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 452:	48a1                	li	a7,8
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <link>:
.global link
link:
 li a7, SYS_link
 45a:	48cd                	li	a7,19
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 462:	48d1                	li	a7,20
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46a:	48a5                	li	a7,9
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <dup>:
.global dup
dup:
 li a7, SYS_dup
 472:	48a9                	li	a7,10
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47a:	48ad                	li	a7,11
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 482:	48b1                	li	a7,12
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <pause>:
.global pause
pause:
 li a7, SYS_pause
 48a:	48b5                	li	a7,13
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 492:	48b9                	li	a7,14
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <kps>:
.global kps
kps:
 li a7, SYS_kps
 49a:	48d9                	li	a7,22
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 4a2:	48dd                	li	a7,23
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 4aa:	48e1                	li	a7,24
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 4b2:	48e5                	li	a7,25
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 4ba:	48e9                	li	a7,26
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4c2:	1101                	addi	sp,sp,-32
 4c4:	ec06                	sd	ra,24(sp)
 4c6:	e822                	sd	s0,16(sp)
 4c8:	1000                	addi	s0,sp,32
 4ca:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ce:	4605                	li	a2,1
 4d0:	fef40593          	addi	a1,s0,-17
 4d4:	f47ff0ef          	jal	41a <write>
}
 4d8:	60e2                	ld	ra,24(sp)
 4da:	6442                	ld	s0,16(sp)
 4dc:	6105                	addi	sp,sp,32
 4de:	8082                	ret

00000000000004e0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4e0:	715d                	addi	sp,sp,-80
 4e2:	e486                	sd	ra,72(sp)
 4e4:	e0a2                	sd	s0,64(sp)
 4e6:	f84a                	sd	s2,48(sp)
 4e8:	0880                	addi	s0,sp,80
 4ea:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4ec:	c299                	beqz	a3,4f2 <printint+0x12>
 4ee:	0805c363          	bltz	a1,574 <printint+0x94>
  neg = 0;
 4f2:	4881                	li	a7,0
 4f4:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4f8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4fa:	00001517          	auipc	a0,0x1
 4fe:	86e50513          	addi	a0,a0,-1938 # d68 <digits>
 502:	883e                	mv	a6,a5
 504:	2785                	addiw	a5,a5,1
 506:	02c5f733          	remu	a4,a1,a2
 50a:	972a                	add	a4,a4,a0
 50c:	00074703          	lbu	a4,0(a4)
 510:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 514:	872e                	mv	a4,a1
 516:	02c5d5b3          	divu	a1,a1,a2
 51a:	0685                	addi	a3,a3,1
 51c:	fec773e3          	bgeu	a4,a2,502 <printint+0x22>
  if(neg)
 520:	00088b63          	beqz	a7,536 <printint+0x56>
    buf[i++] = '-';
 524:	fd078793          	addi	a5,a5,-48
 528:	97a2                	add	a5,a5,s0
 52a:	02d00713          	li	a4,45
 52e:	fee78423          	sb	a4,-24(a5)
 532:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 536:	02f05a63          	blez	a5,56a <printint+0x8a>
 53a:	fc26                	sd	s1,56(sp)
 53c:	f44e                	sd	s3,40(sp)
 53e:	fb840713          	addi	a4,s0,-72
 542:	00f704b3          	add	s1,a4,a5
 546:	fff70993          	addi	s3,a4,-1
 54a:	99be                	add	s3,s3,a5
 54c:	37fd                	addiw	a5,a5,-1
 54e:	1782                	slli	a5,a5,0x20
 550:	9381                	srli	a5,a5,0x20
 552:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 556:	fff4c583          	lbu	a1,-1(s1)
 55a:	854a                	mv	a0,s2
 55c:	f67ff0ef          	jal	4c2 <putc>
  while(--i >= 0)
 560:	14fd                	addi	s1,s1,-1
 562:	ff349ae3          	bne	s1,s3,556 <printint+0x76>
 566:	74e2                	ld	s1,56(sp)
 568:	79a2                	ld	s3,40(sp)
}
 56a:	60a6                	ld	ra,72(sp)
 56c:	6406                	ld	s0,64(sp)
 56e:	7942                	ld	s2,48(sp)
 570:	6161                	addi	sp,sp,80
 572:	8082                	ret
    x = -xx;
 574:	40b005b3          	neg	a1,a1
    neg = 1;
 578:	4885                	li	a7,1
    x = -xx;
 57a:	bfad                	j	4f4 <printint+0x14>

000000000000057c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57c:	711d                	addi	sp,sp,-96
 57e:	ec86                	sd	ra,88(sp)
 580:	e8a2                	sd	s0,80(sp)
 582:	e0ca                	sd	s2,64(sp)
 584:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 586:	0005c903          	lbu	s2,0(a1)
 58a:	28090663          	beqz	s2,816 <vprintf+0x29a>
 58e:	e4a6                	sd	s1,72(sp)
 590:	fc4e                	sd	s3,56(sp)
 592:	f852                	sd	s4,48(sp)
 594:	f456                	sd	s5,40(sp)
 596:	f05a                	sd	s6,32(sp)
 598:	ec5e                	sd	s7,24(sp)
 59a:	e862                	sd	s8,16(sp)
 59c:	e466                	sd	s9,8(sp)
 59e:	8b2a                	mv	s6,a0
 5a0:	8a2e                	mv	s4,a1
 5a2:	8bb2                	mv	s7,a2
  state = 0;
 5a4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5a6:	4481                	li	s1,0
 5a8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5aa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5ae:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5b2:	06c00c93          	li	s9,108
 5b6:	a005                	j	5d6 <vprintf+0x5a>
        putc(fd, c0);
 5b8:	85ca                	mv	a1,s2
 5ba:	855a                	mv	a0,s6
 5bc:	f07ff0ef          	jal	4c2 <putc>
 5c0:	a019                	j	5c6 <vprintf+0x4a>
    } else if(state == '%'){
 5c2:	03598263          	beq	s3,s5,5e6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5c6:	2485                	addiw	s1,s1,1
 5c8:	8726                	mv	a4,s1
 5ca:	009a07b3          	add	a5,s4,s1
 5ce:	0007c903          	lbu	s2,0(a5)
 5d2:	22090a63          	beqz	s2,806 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5d6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5da:	fe0994e3          	bnez	s3,5c2 <vprintf+0x46>
      if(c0 == '%'){
 5de:	fd579de3          	bne	a5,s5,5b8 <vprintf+0x3c>
        state = '%';
 5e2:	89be                	mv	s3,a5
 5e4:	b7cd                	j	5c6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e6:	00ea06b3          	add	a3,s4,a4
 5ea:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ee:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5f0:	c681                	beqz	a3,5f8 <vprintf+0x7c>
 5f2:	9752                	add	a4,a4,s4
 5f4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5f8:	05878363          	beq	a5,s8,63e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5fc:	05978d63          	beq	a5,s9,656 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 600:	07500713          	li	a4,117
 604:	0ee78763          	beq	a5,a4,6f2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 608:	07800713          	li	a4,120
 60c:	12e78963          	beq	a5,a4,73e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 610:	07000713          	li	a4,112
 614:	14e78e63          	beq	a5,a4,770 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 618:	06300713          	li	a4,99
 61c:	18e78e63          	beq	a5,a4,7b8 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 620:	07300713          	li	a4,115
 624:	1ae78463          	beq	a5,a4,7cc <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 628:	02500713          	li	a4,37
 62c:	04e79563          	bne	a5,a4,676 <vprintf+0xfa>
        putc(fd, '%');
 630:	02500593          	li	a1,37
 634:	855a                	mv	a0,s6
 636:	e8dff0ef          	jal	4c2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 63a:	4981                	li	s3,0
 63c:	b769                	j	5c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 63e:	008b8913          	addi	s2,s7,8
 642:	4685                	li	a3,1
 644:	4629                	li	a2,10
 646:	000ba583          	lw	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e95ff0ef          	jal	4e0 <printint>
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
 654:	bf8d                	j	5c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 656:	06400793          	li	a5,100
 65a:	02f68963          	beq	a3,a5,68c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65e:	06c00793          	li	a5,108
 662:	04f68263          	beq	a3,a5,6a6 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 666:	07500793          	li	a5,117
 66a:	0af68063          	beq	a3,a5,70a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 66e:	07800793          	li	a5,120
 672:	0ef68263          	beq	a3,a5,756 <vprintf+0x1da>
        putc(fd, '%');
 676:	02500593          	li	a1,37
 67a:	855a                	mv	a0,s6
 67c:	e47ff0ef          	jal	4c2 <putc>
        putc(fd, c0);
 680:	85ca                	mv	a1,s2
 682:	855a                	mv	a0,s6
 684:	e3fff0ef          	jal	4c2 <putc>
      state = 0;
 688:	4981                	li	s3,0
 68a:	bf35                	j	5c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	008b8913          	addi	s2,s7,8
 690:	4685                	li	a3,1
 692:	4629                	li	a2,10
 694:	000bb583          	ld	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	e47ff0ef          	jal	4e0 <printint>
        i += 1;
 69e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 1;
 6a4:	b70d                	j	5c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a6:	06400793          	li	a5,100
 6aa:	02f60763          	beq	a2,a5,6d8 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ae:	07500793          	li	a5,117
 6b2:	06f60963          	beq	a2,a5,724 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6b6:	07800793          	li	a5,120
 6ba:	faf61ee3          	bne	a2,a5,676 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4641                	li	a2,16
 6c6:	000bb583          	ld	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	e15ff0ef          	jal	4e0 <printint>
        i += 2;
 6d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
        i += 2;
 6d6:	bdc5                	j	5c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4685                	li	a3,1
 6de:	4629                	li	a2,10
 6e0:	000bb583          	ld	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	dfbff0ef          	jal	4e0 <printint>
        i += 2;
 6ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 2;
 6f0:	bdd9                	j	5c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4629                	li	a2,10
 6fa:	000be583          	lwu	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	de1ff0ef          	jal	4e0 <printint>
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
 708:	bd7d                	j	5c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4681                	li	a3,0
 710:	4629                	li	a2,10
 712:	000bb583          	ld	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	dc9ff0ef          	jal	4e0 <printint>
        i += 1;
 71c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 1;
 722:	b555                	j	5c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 724:	008b8913          	addi	s2,s7,8
 728:	4681                	li	a3,0
 72a:	4629                	li	a2,10
 72c:	000bb583          	ld	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	dafff0ef          	jal	4e0 <printint>
        i += 2;
 736:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
        i += 2;
 73c:	b569                	j	5c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4641                	li	a2,16
 746:	000be583          	lwu	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	d95ff0ef          	jal	4e0 <printint>
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
 754:	bd8d                	j	5c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 756:	008b8913          	addi	s2,s7,8
 75a:	4681                	li	a3,0
 75c:	4641                	li	a2,16
 75e:	000bb583          	ld	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	d7dff0ef          	jal	4e0 <printint>
        i += 1;
 768:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 76a:	8bca                	mv	s7,s2
      state = 0;
 76c:	4981                	li	s3,0
        i += 1;
 76e:	bda1                	j	5c6 <vprintf+0x4a>
 770:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 772:	008b8d13          	addi	s10,s7,8
 776:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 77a:	03000593          	li	a1,48
 77e:	855a                	mv	a0,s6
 780:	d43ff0ef          	jal	4c2 <putc>
  putc(fd, 'x');
 784:	07800593          	li	a1,120
 788:	855a                	mv	a0,s6
 78a:	d39ff0ef          	jal	4c2 <putc>
 78e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 790:	00000b97          	auipc	s7,0x0
 794:	5d8b8b93          	addi	s7,s7,1496 # d68 <digits>
 798:	03c9d793          	srli	a5,s3,0x3c
 79c:	97de                	add	a5,a5,s7
 79e:	0007c583          	lbu	a1,0(a5)
 7a2:	855a                	mv	a0,s6
 7a4:	d1fff0ef          	jal	4c2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a8:	0992                	slli	s3,s3,0x4
 7aa:	397d                	addiw	s2,s2,-1
 7ac:	fe0916e3          	bnez	s2,798 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7b0:	8bea                	mv	s7,s10
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	6d02                	ld	s10,0(sp)
 7b6:	bd01                	j	5c6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7b8:	008b8913          	addi	s2,s7,8
 7bc:	000bc583          	lbu	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	d01ff0ef          	jal	4c2 <putc>
 7c6:	8bca                	mv	s7,s2
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bbf5                	j	5c6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7cc:	008b8993          	addi	s3,s7,8
 7d0:	000bb903          	ld	s2,0(s7)
 7d4:	00090f63          	beqz	s2,7f2 <vprintf+0x276>
        for(; *s; s++)
 7d8:	00094583          	lbu	a1,0(s2)
 7dc:	c195                	beqz	a1,800 <vprintf+0x284>
          putc(fd, *s);
 7de:	855a                	mv	a0,s6
 7e0:	ce3ff0ef          	jal	4c2 <putc>
        for(; *s; s++)
 7e4:	0905                	addi	s2,s2,1
 7e6:	00094583          	lbu	a1,0(s2)
 7ea:	f9f5                	bnez	a1,7de <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7ec:	8bce                	mv	s7,s3
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bbd9                	j	5c6 <vprintf+0x4a>
          s = "(null)";
 7f2:	00000917          	auipc	s2,0x0
 7f6:	56e90913          	addi	s2,s2,1390 # d60 <malloc+0x462>
        for(; *s; s++)
 7fa:	02800593          	li	a1,40
 7fe:	b7c5                	j	7de <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 800:	8bce                	mv	s7,s3
      state = 0;
 802:	4981                	li	s3,0
 804:	b3c9                	j	5c6 <vprintf+0x4a>
 806:	64a6                	ld	s1,72(sp)
 808:	79e2                	ld	s3,56(sp)
 80a:	7a42                	ld	s4,48(sp)
 80c:	7aa2                	ld	s5,40(sp)
 80e:	7b02                	ld	s6,32(sp)
 810:	6be2                	ld	s7,24(sp)
 812:	6c42                	ld	s8,16(sp)
 814:	6ca2                	ld	s9,8(sp)
    }
  }
}
 816:	60e6                	ld	ra,88(sp)
 818:	6446                	ld	s0,80(sp)
 81a:	6906                	ld	s2,64(sp)
 81c:	6125                	addi	sp,sp,96
 81e:	8082                	ret

0000000000000820 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 820:	715d                	addi	sp,sp,-80
 822:	ec06                	sd	ra,24(sp)
 824:	e822                	sd	s0,16(sp)
 826:	1000                	addi	s0,sp,32
 828:	e010                	sd	a2,0(s0)
 82a:	e414                	sd	a3,8(s0)
 82c:	e818                	sd	a4,16(s0)
 82e:	ec1c                	sd	a5,24(s0)
 830:	03043023          	sd	a6,32(s0)
 834:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 838:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 83c:	8622                	mv	a2,s0
 83e:	d3fff0ef          	jal	57c <vprintf>
}
 842:	60e2                	ld	ra,24(sp)
 844:	6442                	ld	s0,16(sp)
 846:	6161                	addi	sp,sp,80
 848:	8082                	ret

000000000000084a <printf>:

void
printf(const char *fmt, ...)
{
 84a:	711d                	addi	sp,sp,-96
 84c:	ec06                	sd	ra,24(sp)
 84e:	e822                	sd	s0,16(sp)
 850:	1000                	addi	s0,sp,32
 852:	e40c                	sd	a1,8(s0)
 854:	e810                	sd	a2,16(s0)
 856:	ec14                	sd	a3,24(s0)
 858:	f018                	sd	a4,32(s0)
 85a:	f41c                	sd	a5,40(s0)
 85c:	03043823          	sd	a6,48(s0)
 860:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 864:	00840613          	addi	a2,s0,8
 868:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 86c:	85aa                	mv	a1,a0
 86e:	4505                	li	a0,1
 870:	d0dff0ef          	jal	57c <vprintf>
}
 874:	60e2                	ld	ra,24(sp)
 876:	6442                	ld	s0,16(sp)
 878:	6125                	addi	sp,sp,96
 87a:	8082                	ret

000000000000087c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 87c:	1141                	addi	sp,sp,-16
 87e:	e422                	sd	s0,8(sp)
 880:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 882:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 886:	00001797          	auipc	a5,0x1
 88a:	77a7b783          	ld	a5,1914(a5) # 2000 <freep>
 88e:	a02d                	j	8b8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 890:	4618                	lw	a4,8(a2)
 892:	9f2d                	addw	a4,a4,a1
 894:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	6310                	ld	a2,0(a4)
 89c:	a83d                	j	8da <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 89e:	ff852703          	lw	a4,-8(a0)
 8a2:	9f31                	addw	a4,a4,a2
 8a4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a6:	ff053683          	ld	a3,-16(a0)
 8aa:	a091                	j	8ee <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ac:	6398                	ld	a4,0(a5)
 8ae:	00e7e463          	bltu	a5,a4,8b6 <free+0x3a>
 8b2:	00e6ea63          	bltu	a3,a4,8c6 <free+0x4a>
{
 8b6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b8:	fed7fae3          	bgeu	a5,a3,8ac <free+0x30>
 8bc:	6398                	ld	a4,0(a5)
 8be:	00e6e463          	bltu	a3,a4,8c6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c2:	fee7eae3          	bltu	a5,a4,8b6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8c6:	ff852583          	lw	a1,-8(a0)
 8ca:	6390                	ld	a2,0(a5)
 8cc:	02059813          	slli	a6,a1,0x20
 8d0:	01c85713          	srli	a4,a6,0x1c
 8d4:	9736                	add	a4,a4,a3
 8d6:	fae60de3          	beq	a2,a4,890 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8da:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8de:	4790                	lw	a2,8(a5)
 8e0:	02061593          	slli	a1,a2,0x20
 8e4:	01c5d713          	srli	a4,a1,0x1c
 8e8:	973e                	add	a4,a4,a5
 8ea:	fae68ae3          	beq	a3,a4,89e <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ee:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8f0:	00001717          	auipc	a4,0x1
 8f4:	70f73823          	sd	a5,1808(a4) # 2000 <freep>
}
 8f8:	6422                	ld	s0,8(sp)
 8fa:	0141                	addi	sp,sp,16
 8fc:	8082                	ret

00000000000008fe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8fe:	7139                	addi	sp,sp,-64
 900:	fc06                	sd	ra,56(sp)
 902:	f822                	sd	s0,48(sp)
 904:	f426                	sd	s1,40(sp)
 906:	ec4e                	sd	s3,24(sp)
 908:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90a:	02051493          	slli	s1,a0,0x20
 90e:	9081                	srli	s1,s1,0x20
 910:	04bd                	addi	s1,s1,15
 912:	8091                	srli	s1,s1,0x4
 914:	0014899b          	addiw	s3,s1,1
 918:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 91a:	00001517          	auipc	a0,0x1
 91e:	6e653503          	ld	a0,1766(a0) # 2000 <freep>
 922:	c915                	beqz	a0,956 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 924:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 926:	4798                	lw	a4,8(a5)
 928:	08977a63          	bgeu	a4,s1,9bc <malloc+0xbe>
 92c:	f04a                	sd	s2,32(sp)
 92e:	e852                	sd	s4,16(sp)
 930:	e456                	sd	s5,8(sp)
 932:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 934:	8a4e                	mv	s4,s3
 936:	0009871b          	sext.w	a4,s3
 93a:	6685                	lui	a3,0x1
 93c:	00d77363          	bgeu	a4,a3,942 <malloc+0x44>
 940:	6a05                	lui	s4,0x1
 942:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 946:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 94a:	00001917          	auipc	s2,0x1
 94e:	6b690913          	addi	s2,s2,1718 # 2000 <freep>
  if(p == SBRK_ERROR)
 952:	5afd                	li	s5,-1
 954:	a081                	j	994 <malloc+0x96>
 956:	f04a                	sd	s2,32(sp)
 958:	e852                	sd	s4,16(sp)
 95a:	e456                	sd	s5,8(sp)
 95c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 95e:	00001797          	auipc	a5,0x1
 962:	6b278793          	addi	a5,a5,1714 # 2010 <base>
 966:	00001717          	auipc	a4,0x1
 96a:	68f73d23          	sd	a5,1690(a4) # 2000 <freep>
 96e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 970:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 974:	b7c1                	j	934 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 976:	6398                	ld	a4,0(a5)
 978:	e118                	sd	a4,0(a0)
 97a:	a8a9                	j	9d4 <malloc+0xd6>
  hp->s.size = nu;
 97c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 980:	0541                	addi	a0,a0,16
 982:	efbff0ef          	jal	87c <free>
  return freep;
 986:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 98a:	c12d                	beqz	a0,9ec <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98e:	4798                	lw	a4,8(a5)
 990:	02977263          	bgeu	a4,s1,9b4 <malloc+0xb6>
    if(p == freep)
 994:	00093703          	ld	a4,0(s2)
 998:	853e                	mv	a0,a5
 99a:	fef719e3          	bne	a4,a5,98c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 99e:	8552                	mv	a0,s4
 9a0:	a27ff0ef          	jal	3c6 <sbrk>
  if(p == SBRK_ERROR)
 9a4:	fd551ce3          	bne	a0,s5,97c <malloc+0x7e>
        return 0;
 9a8:	4501                	li	a0,0
 9aa:	7902                	ld	s2,32(sp)
 9ac:	6a42                	ld	s4,16(sp)
 9ae:	6aa2                	ld	s5,8(sp)
 9b0:	6b02                	ld	s6,0(sp)
 9b2:	a03d                	j	9e0 <malloc+0xe2>
 9b4:	7902                	ld	s2,32(sp)
 9b6:	6a42                	ld	s4,16(sp)
 9b8:	6aa2                	ld	s5,8(sp)
 9ba:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9bc:	fae48de3          	beq	s1,a4,976 <malloc+0x78>
        p->s.size -= nunits;
 9c0:	4137073b          	subw	a4,a4,s3
 9c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c6:	02071693          	slli	a3,a4,0x20
 9ca:	01c6d713          	srli	a4,a3,0x1c
 9ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d4:	00001717          	auipc	a4,0x1
 9d8:	62a73623          	sd	a0,1580(a4) # 2000 <freep>
      return (void*)(p + 1);
 9dc:	01078513          	addi	a0,a5,16
  }
}
 9e0:	70e2                	ld	ra,56(sp)
 9e2:	7442                	ld	s0,48(sp)
 9e4:	74a2                	ld	s1,40(sp)
 9e6:	69e2                	ld	s3,24(sp)
 9e8:	6121                	addi	sp,sp,64
 9ea:	8082                	ret
 9ec:	7902                	ld	s2,32(sp)
 9ee:	6a42                	ld	s4,16(sp)
 9f0:	6aa2                	ld	s5,8(sp)
 9f2:	6b02                	ld	s6,0(sp)
 9f4:	b7f5                	j	9e0 <malloc+0xe2>
