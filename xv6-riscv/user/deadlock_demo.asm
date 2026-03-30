
user/_deadlock_demo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  printf("Deadlock Detection with Energy-Aware Recovery Demo\n");
   8:	00001517          	auipc	a0,0x1
   c:	9c850513          	addi	a0,a0,-1592 # 9d0 <malloc+0x100>
  10:	00d000ef          	jal	81c <printf>
  printf("Two processes will try to acquire locks in opposite order.\n");
  14:	00001517          	auipc	a0,0x1
  18:	9f450513          	addi	a0,a0,-1548 # a08 <malloc+0x138>
  1c:	001000ef          	jal	81c <printf>
  printf("When deadlock is detected, the process with highest energy\n");
  20:	00001517          	auipc	a0,0x1
  24:	a2850513          	addi	a0,a0,-1496 # a48 <malloc+0x178>
  28:	7f4000ef          	jal	81c <printf>
  printf("consumption will be killed to break the deadlock.\n\n");
  2c:	00001517          	auipc	a0,0x1
  30:	a5c50513          	addi	a0,a0,-1444 # a88 <malloc+0x1b8>
  34:	7e8000ef          	jal	81c <printf>

  int pid = fork();
  38:	38c000ef          	jal	3c4 <fork>

  if(pid < 0){
  3c:	06054363          	bltz	a0,a2 <main+0xa2>
    printf("deadlock_demo: fork failed\n");
    exit(1);
  }

  if(pid == 0){
  40:	e935                	bnez	a0,b4 <main+0xb4>
  42:	000f47b7          	lui	a5,0xf4
  46:	24078793          	addi	a5,a5,576 # f4240 <base+0xf2230>
    // Child burns some CPU to increase energy_consumed
    // this makes the child the higher-energy process
    for(int i = 0; i < 1000000; i++)
  4a:	37fd                	addiw	a5,a5,-1
  4c:	fffd                	bnez	a5,4a <main+0x4a>
      ;  // busy loop to consume energy ticks

    // Child grabs lock 1 first, then tries lock 0.
    printf("child (pid %d): acquiring lock 1\n", getpid());
  4e:	3fe000ef          	jal	44c <getpid>
  52:	85aa                	mv	a1,a0
  54:	00001517          	auipc	a0,0x1
  58:	a8c50513          	addi	a0,a0,-1396 # ae0 <malloc+0x210>
  5c:	7c0000ef          	jal	81c <printf>
    dlockacq(1);
  60:	4505                	li	a0,1
  62:	41a000ef          	jal	47c <dlockacq>
    pause(20);
  66:	4551                	li	a0,20
  68:	3f4000ef          	jal	45c <pause>
    printf("child (pid %d): acquiring lock 0 (should trigger deadlock + recovery)\n", getpid());
  6c:	3e0000ef          	jal	44c <getpid>
  70:	85aa                	mv	a1,a0
  72:	00001517          	auipc	a0,0x1
  76:	a9650513          	addi	a0,a0,-1386 # b08 <malloc+0x238>
  7a:	7a2000ef          	jal	81c <printf>
    dlockacq(0);
  7e:	4501                	li	a0,0
  80:	3fc000ef          	jal	47c <dlockacq>
    printf("child: if you see this, child survived the deadlock\n");
  84:	00001517          	auipc	a0,0x1
  88:	acc50513          	addi	a0,a0,-1332 # b50 <malloc+0x280>
  8c:	790000ef          	jal	81c <printf>
    dlockrel(0);
  90:	4501                	li	a0,0
  92:	3f2000ef          	jal	484 <dlockrel>
    dlockrel(1);
  96:	4505                	li	a0,1
  98:	3ec000ef          	jal	484 <dlockrel>
    exit(0);
  9c:	4501                	li	a0,0
  9e:	32e000ef          	jal	3cc <exit>
    printf("deadlock_demo: fork failed\n");
  a2:	00001517          	auipc	a0,0x1
  a6:	a1e50513          	addi	a0,a0,-1506 # ac0 <malloc+0x1f0>
  aa:	772000ef          	jal	81c <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	31c000ef          	jal	3cc <exit>
  }

  // Parent grabs lock 0 first, then tries lock 1.
  printf("parent (pid %d): acquiring lock 0\n", getpid());
  b4:	398000ef          	jal	44c <getpid>
  b8:	85aa                	mv	a1,a0
  ba:	00001517          	auipc	a0,0x1
  be:	ace50513          	addi	a0,a0,-1330 # b88 <malloc+0x2b8>
  c2:	75a000ef          	jal	81c <printf>
  dlockacq(0);
  c6:	4501                	li	a0,0
  c8:	3b4000ef          	jal	47c <dlockacq>
  pause(20);
  cc:	4551                	li	a0,20
  ce:	38e000ef          	jal	45c <pause>
  printf("parent (pid %d): acquiring lock 1\n", getpid());
  d2:	37a000ef          	jal	44c <getpid>
  d6:	85aa                	mv	a1,a0
  d8:	00001517          	auipc	a0,0x1
  dc:	ad850513          	addi	a0,a0,-1320 # bb0 <malloc+0x2e0>
  e0:	73c000ef          	jal	81c <printf>
  dlockacq(1);
  e4:	4505                	li	a0,1
  e6:	396000ef          	jal	47c <dlockacq>
  printf("parent: if you see this, parent survived the deadlock\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	aee50513          	addi	a0,a0,-1298 # bd8 <malloc+0x308>
  f2:	72a000ef          	jal	81c <printf>

  dlockrel(1);
  f6:	4505                	li	a0,1
  f8:	38c000ef          	jal	484 <dlockrel>
  dlockrel(0);
  fc:	4501                	li	a0,0
  fe:	386000ef          	jal	484 <dlockrel>

  // Also demonstrate the check_deadlock syscall
  printf("\nCalling check_deadlock() syscall...\n");
 102:	00001517          	auipc	a0,0x1
 106:	b0e50513          	addi	a0,a0,-1266 # c10 <malloc+0x340>
 10a:	712000ef          	jal	81c <printf>
  int result = check_deadlock();
 10e:	37e000ef          	jal	48c <check_deadlock>
 112:	85aa                	mv	a1,a0
  printf("check_deadlock returned: %d (0 = no deadlock found)\n", result);
 114:	00001517          	auipc	a0,0x1
 118:	b2450513          	addi	a0,a0,-1244 # c38 <malloc+0x368>
 11c:	700000ef          	jal	81c <printf>

  wait(0);
 120:	4501                	li	a0,0
 122:	2b2000ef          	jal	3d4 <wait>
  printf("\nDemo complete\n");
 126:	00001517          	auipc	a0,0x1
 12a:	b4a50513          	addi	a0,a0,-1206 # c70 <malloc+0x3a0>
 12e:	6ee000ef          	jal	81c <printf>
  exit(0);
 132:	4501                	li	a0,0
 134:	298000ef          	jal	3cc <exit>

0000000000000138 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e406                	sd	ra,8(sp)
 13c:	e022                	sd	s0,0(sp)
 13e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 140:	ec1ff0ef          	jal	0 <main>
  exit(r);
 144:	288000ef          	jal	3cc <exit>

0000000000000148 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14e:	87aa                	mv	a5,a0
 150:	0585                	addi	a1,a1,1
 152:	0785                	addi	a5,a5,1
 154:	fff5c703          	lbu	a4,-1(a1)
 158:	fee78fa3          	sb	a4,-1(a5)
 15c:	fb75                	bnez	a4,150 <strcpy+0x8>
    ;
  return os;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 164:	1141                	addi	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cb91                	beqz	a5,182 <strcmp+0x1e>
 170:	0005c703          	lbu	a4,0(a1)
 174:	00f71763          	bne	a4,a5,182 <strcmp+0x1e>
    p++, q++;
 178:	0505                	addi	a0,a0,1
 17a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 17c:	00054783          	lbu	a5,0(a0)
 180:	fbe5                	bnez	a5,170 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 182:	0005c503          	lbu	a0,0(a1)
}
 186:	40a7853b          	subw	a0,a5,a0
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strlen>:

uint
strlen(const char *s)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cf91                	beqz	a5,1b6 <strlen+0x26>
 19c:	0505                	addi	a0,a0,1
 19e:	87aa                	mv	a5,a0
 1a0:	86be                	mv	a3,a5
 1a2:	0785                	addi	a5,a5,1
 1a4:	fff7c703          	lbu	a4,-1(a5)
 1a8:	ff65                	bnez	a4,1a0 <strlen+0x10>
 1aa:	40a6853b          	subw	a0,a3,a0
 1ae:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret
  for(n = 0; s[n]; n++)
 1b6:	4501                	li	a0,0
 1b8:	bfe5                	j	1b0 <strlen+0x20>

00000000000001ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1c0:	ca19                	beqz	a2,1d6 <memset+0x1c>
 1c2:	87aa                	mv	a5,a0
 1c4:	1602                	slli	a2,a2,0x20
 1c6:	9201                	srli	a2,a2,0x20
 1c8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1cc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1d0:	0785                	addi	a5,a5,1
 1d2:	fee79de3          	bne	a5,a4,1cc <memset+0x12>
  }
  return dst;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret

00000000000001dc <strchr>:

char*
strchr(const char *s, char c)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	cb99                	beqz	a5,1fc <strchr+0x20>
    if(*s == c)
 1e8:	00f58763          	beq	a1,a5,1f6 <strchr+0x1a>
  for(; *s; s++)
 1ec:	0505                	addi	a0,a0,1
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	fbfd                	bnez	a5,1e8 <strchr+0xc>
      return (char*)s;
  return 0;
 1f4:	4501                	li	a0,0
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret
  return 0;
 1fc:	4501                	li	a0,0
 1fe:	bfe5                	j	1f6 <strchr+0x1a>

0000000000000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	711d                	addi	sp,sp,-96
 202:	ec86                	sd	ra,88(sp)
 204:	e8a2                	sd	s0,80(sp)
 206:	e4a6                	sd	s1,72(sp)
 208:	e0ca                	sd	s2,64(sp)
 20a:	fc4e                	sd	s3,56(sp)
 20c:	f852                	sd	s4,48(sp)
 20e:	f456                	sd	s5,40(sp)
 210:	f05a                	sd	s6,32(sp)
 212:	ec5e                	sd	s7,24(sp)
 214:	1080                	addi	s0,sp,96
 216:	8baa                	mv	s7,a0
 218:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21a:	892a                	mv	s2,a0
 21c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 21e:	4aa9                	li	s5,10
 220:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 222:	89a6                	mv	s3,s1
 224:	2485                	addiw	s1,s1,1
 226:	0344d663          	bge	s1,s4,252 <gets+0x52>
    cc = read(0, &c, 1);
 22a:	4605                	li	a2,1
 22c:	faf40593          	addi	a1,s0,-81
 230:	4501                	li	a0,0
 232:	1b2000ef          	jal	3e4 <read>
    if(cc < 1)
 236:	00a05e63          	blez	a0,252 <gets+0x52>
    buf[i++] = c;
 23a:	faf44783          	lbu	a5,-81(s0)
 23e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 242:	01578763          	beq	a5,s5,250 <gets+0x50>
 246:	0905                	addi	s2,s2,1
 248:	fd679de3          	bne	a5,s6,222 <gets+0x22>
    buf[i++] = c;
 24c:	89a6                	mv	s3,s1
 24e:	a011                	j	252 <gets+0x52>
 250:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 252:	99de                	add	s3,s3,s7
 254:	00098023          	sb	zero,0(s3)
  return buf;
}
 258:	855e                	mv	a0,s7
 25a:	60e6                	ld	ra,88(sp)
 25c:	6446                	ld	s0,80(sp)
 25e:	64a6                	ld	s1,72(sp)
 260:	6906                	ld	s2,64(sp)
 262:	79e2                	ld	s3,56(sp)
 264:	7a42                	ld	s4,48(sp)
 266:	7aa2                	ld	s5,40(sp)
 268:	7b02                	ld	s6,32(sp)
 26a:	6be2                	ld	s7,24(sp)
 26c:	6125                	addi	sp,sp,96
 26e:	8082                	ret

0000000000000270 <stat>:

int
stat(const char *n, struct stat *st)
{
 270:	1101                	addi	sp,sp,-32
 272:	ec06                	sd	ra,24(sp)
 274:	e822                	sd	s0,16(sp)
 276:	e04a                	sd	s2,0(sp)
 278:	1000                	addi	s0,sp,32
 27a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27c:	4581                	li	a1,0
 27e:	18e000ef          	jal	40c <open>
  if(fd < 0)
 282:	02054263          	bltz	a0,2a6 <stat+0x36>
 286:	e426                	sd	s1,8(sp)
 288:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 28a:	85ca                	mv	a1,s2
 28c:	198000ef          	jal	424 <fstat>
 290:	892a                	mv	s2,a0
  close(fd);
 292:	8526                	mv	a0,s1
 294:	160000ef          	jal	3f4 <close>
  return r;
 298:	64a2                	ld	s1,8(sp)
}
 29a:	854a                	mv	a0,s2
 29c:	60e2                	ld	ra,24(sp)
 29e:	6442                	ld	s0,16(sp)
 2a0:	6902                	ld	s2,0(sp)
 2a2:	6105                	addi	sp,sp,32
 2a4:	8082                	ret
    return -1;
 2a6:	597d                	li	s2,-1
 2a8:	bfcd                	j	29a <stat+0x2a>

00000000000002aa <atoi>:

int
atoi(const char *s)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b0:	00054683          	lbu	a3,0(a0)
 2b4:	fd06879b          	addiw	a5,a3,-48
 2b8:	0ff7f793          	zext.b	a5,a5
 2bc:	4625                	li	a2,9
 2be:	02f66863          	bltu	a2,a5,2ee <atoi+0x44>
 2c2:	872a                	mv	a4,a0
  n = 0;
 2c4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c6:	0705                	addi	a4,a4,1
 2c8:	0025179b          	slliw	a5,a0,0x2
 2cc:	9fa9                	addw	a5,a5,a0
 2ce:	0017979b          	slliw	a5,a5,0x1
 2d2:	9fb5                	addw	a5,a5,a3
 2d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d8:	00074683          	lbu	a3,0(a4)
 2dc:	fd06879b          	addiw	a5,a3,-48
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	fef671e3          	bgeu	a2,a5,2c6 <atoi+0x1c>
  return n;
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
  n = 0;
 2ee:	4501                	li	a0,0
 2f0:	bfe5                	j	2e8 <atoi+0x3e>

00000000000002f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f8:	02b57463          	bgeu	a0,a1,320 <memmove+0x2e>
    while(n-- > 0)
 2fc:	00c05f63          	blez	a2,31a <memmove+0x28>
 300:	1602                	slli	a2,a2,0x20
 302:	9201                	srli	a2,a2,0x20
 304:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 308:	872a                	mv	a4,a0
      *dst++ = *src++;
 30a:	0585                	addi	a1,a1,1
 30c:	0705                	addi	a4,a4,1
 30e:	fff5c683          	lbu	a3,-1(a1)
 312:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 316:	fef71ae3          	bne	a4,a5,30a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
    dst += n;
 320:	00c50733          	add	a4,a0,a2
    src += n;
 324:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 326:	fec05ae3          	blez	a2,31a <memmove+0x28>
 32a:	fff6079b          	addiw	a5,a2,-1
 32e:	1782                	slli	a5,a5,0x20
 330:	9381                	srli	a5,a5,0x20
 332:	fff7c793          	not	a5,a5
 336:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 338:	15fd                	addi	a1,a1,-1
 33a:	177d                	addi	a4,a4,-1
 33c:	0005c683          	lbu	a3,0(a1)
 340:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 344:	fee79ae3          	bne	a5,a4,338 <memmove+0x46>
 348:	bfc9                	j	31a <memmove+0x28>

000000000000034a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 350:	ca05                	beqz	a2,380 <memcmp+0x36>
 352:	fff6069b          	addiw	a3,a2,-1
 356:	1682                	slli	a3,a3,0x20
 358:	9281                	srli	a3,a3,0x20
 35a:	0685                	addi	a3,a3,1
 35c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 35e:	00054783          	lbu	a5,0(a0)
 362:	0005c703          	lbu	a4,0(a1)
 366:	00e79863          	bne	a5,a4,376 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36a:	0505                	addi	a0,a0,1
    p2++;
 36c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 36e:	fed518e3          	bne	a0,a3,35e <memcmp+0x14>
  }
  return 0;
 372:	4501                	li	a0,0
 374:	a019                	j	37a <memcmp+0x30>
      return *p1 - *p2;
 376:	40e7853b          	subw	a0,a5,a4
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
  return 0;
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <memcmp+0x30>

0000000000000384 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38c:	f67ff0ef          	jal	2f2 <memmove>
}
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret

0000000000000398 <sbrk>:

char *
sbrk(int n) {
 398:	1141                	addi	sp,sp,-16
 39a:	e406                	sd	ra,8(sp)
 39c:	e022                	sd	s0,0(sp)
 39e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3a0:	4585                	li	a1,1
 3a2:	0b2000ef          	jal	454 <sys_sbrk>
}
 3a6:	60a2                	ld	ra,8(sp)
 3a8:	6402                	ld	s0,0(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret

00000000000003ae <sbrklazy>:

char *
sbrklazy(int n) {
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e406                	sd	ra,8(sp)
 3b2:	e022                	sd	s0,0(sp)
 3b4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3b6:	4589                	li	a1,2
 3b8:	09c000ef          	jal	454 <sys_sbrk>
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret

00000000000003c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c4:	4885                	li	a7,1
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3cc:	4889                	li	a7,2
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d4:	488d                	li	a7,3
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3dc:	4891                	li	a7,4
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <read>:
.global read
read:
 li a7, SYS_read
 3e4:	4895                	li	a7,5
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <write>:
.global write
write:
 li a7, SYS_write
 3ec:	48c1                	li	a7,16
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <close>:
.global close
close:
 li a7, SYS_close
 3f4:	48d5                	li	a7,21
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fc:	4899                	li	a7,6
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <exec>:
.global exec
exec:
 li a7, SYS_exec
 404:	489d                	li	a7,7
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <open>:
.global open
open:
 li a7, SYS_open
 40c:	48bd                	li	a7,15
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 414:	48c5                	li	a7,17
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41c:	48c9                	li	a7,18
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 424:	48a1                	li	a7,8
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <link>:
.global link
link:
 li a7, SYS_link
 42c:	48cd                	li	a7,19
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 434:	48d1                	li	a7,20
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43c:	48a5                	li	a7,9
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <dup>:
.global dup
dup:
 li a7, SYS_dup
 444:	48a9                	li	a7,10
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44c:	48ad                	li	a7,11
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 454:	48b1                	li	a7,12
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <pause>:
.global pause
pause:
 li a7, SYS_pause
 45c:	48b5                	li	a7,13
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 464:	48b9                	li	a7,14
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <kps>:
.global kps
kps:
 li a7, SYS_kps
 46c:	48d9                	li	a7,22
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 474:	48dd                	li	a7,23
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 47c:	48e1                	li	a7,24
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 484:	48e5                	li	a7,25
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 48c:	48e9                	li	a7,26
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 494:	1101                	addi	sp,sp,-32
 496:	ec06                	sd	ra,24(sp)
 498:	e822                	sd	s0,16(sp)
 49a:	1000                	addi	s0,sp,32
 49c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a0:	4605                	li	a2,1
 4a2:	fef40593          	addi	a1,s0,-17
 4a6:	f47ff0ef          	jal	3ec <write>
}
 4aa:	60e2                	ld	ra,24(sp)
 4ac:	6442                	ld	s0,16(sp)
 4ae:	6105                	addi	sp,sp,32
 4b0:	8082                	ret

00000000000004b2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4b2:	715d                	addi	sp,sp,-80
 4b4:	e486                	sd	ra,72(sp)
 4b6:	e0a2                	sd	s0,64(sp)
 4b8:	f84a                	sd	s2,48(sp)
 4ba:	0880                	addi	s0,sp,80
 4bc:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4be:	c299                	beqz	a3,4c4 <printint+0x12>
 4c0:	0805c363          	bltz	a1,546 <printint+0x94>
  neg = 0;
 4c4:	4881                	li	a7,0
 4c6:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4ca:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4cc:	00000517          	auipc	a0,0x0
 4d0:	7bc50513          	addi	a0,a0,1980 # c88 <digits>
 4d4:	883e                	mv	a6,a5
 4d6:	2785                	addiw	a5,a5,1
 4d8:	02c5f733          	remu	a4,a1,a2
 4dc:	972a                	add	a4,a4,a0
 4de:	00074703          	lbu	a4,0(a4)
 4e2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4e6:	872e                	mv	a4,a1
 4e8:	02c5d5b3          	divu	a1,a1,a2
 4ec:	0685                	addi	a3,a3,1
 4ee:	fec773e3          	bgeu	a4,a2,4d4 <printint+0x22>
  if(neg)
 4f2:	00088b63          	beqz	a7,508 <printint+0x56>
    buf[i++] = '-';
 4f6:	fd078793          	addi	a5,a5,-48
 4fa:	97a2                	add	a5,a5,s0
 4fc:	02d00713          	li	a4,45
 500:	fee78423          	sb	a4,-24(a5)
 504:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 508:	02f05a63          	blez	a5,53c <printint+0x8a>
 50c:	fc26                	sd	s1,56(sp)
 50e:	f44e                	sd	s3,40(sp)
 510:	fb840713          	addi	a4,s0,-72
 514:	00f704b3          	add	s1,a4,a5
 518:	fff70993          	addi	s3,a4,-1
 51c:	99be                	add	s3,s3,a5
 51e:	37fd                	addiw	a5,a5,-1
 520:	1782                	slli	a5,a5,0x20
 522:	9381                	srli	a5,a5,0x20
 524:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 528:	fff4c583          	lbu	a1,-1(s1)
 52c:	854a                	mv	a0,s2
 52e:	f67ff0ef          	jal	494 <putc>
  while(--i >= 0)
 532:	14fd                	addi	s1,s1,-1
 534:	ff349ae3          	bne	s1,s3,528 <printint+0x76>
 538:	74e2                	ld	s1,56(sp)
 53a:	79a2                	ld	s3,40(sp)
}
 53c:	60a6                	ld	ra,72(sp)
 53e:	6406                	ld	s0,64(sp)
 540:	7942                	ld	s2,48(sp)
 542:	6161                	addi	sp,sp,80
 544:	8082                	ret
    x = -xx;
 546:	40b005b3          	neg	a1,a1
    neg = 1;
 54a:	4885                	li	a7,1
    x = -xx;
 54c:	bfad                	j	4c6 <printint+0x14>

000000000000054e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 54e:	711d                	addi	sp,sp,-96
 550:	ec86                	sd	ra,88(sp)
 552:	e8a2                	sd	s0,80(sp)
 554:	e0ca                	sd	s2,64(sp)
 556:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 558:	0005c903          	lbu	s2,0(a1)
 55c:	28090663          	beqz	s2,7e8 <vprintf+0x29a>
 560:	e4a6                	sd	s1,72(sp)
 562:	fc4e                	sd	s3,56(sp)
 564:	f852                	sd	s4,48(sp)
 566:	f456                	sd	s5,40(sp)
 568:	f05a                	sd	s6,32(sp)
 56a:	ec5e                	sd	s7,24(sp)
 56c:	e862                	sd	s8,16(sp)
 56e:	e466                	sd	s9,8(sp)
 570:	8b2a                	mv	s6,a0
 572:	8a2e                	mv	s4,a1
 574:	8bb2                	mv	s7,a2
  state = 0;
 576:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 578:	4481                	li	s1,0
 57a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 57c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 580:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 584:	06c00c93          	li	s9,108
 588:	a005                	j	5a8 <vprintf+0x5a>
        putc(fd, c0);
 58a:	85ca                	mv	a1,s2
 58c:	855a                	mv	a0,s6
 58e:	f07ff0ef          	jal	494 <putc>
 592:	a019                	j	598 <vprintf+0x4a>
    } else if(state == '%'){
 594:	03598263          	beq	s3,s5,5b8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 598:	2485                	addiw	s1,s1,1
 59a:	8726                	mv	a4,s1
 59c:	009a07b3          	add	a5,s4,s1
 5a0:	0007c903          	lbu	s2,0(a5)
 5a4:	22090a63          	beqz	s2,7d8 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ac:	fe0994e3          	bnez	s3,594 <vprintf+0x46>
      if(c0 == '%'){
 5b0:	fd579de3          	bne	a5,s5,58a <vprintf+0x3c>
        state = '%';
 5b4:	89be                	mv	s3,a5
 5b6:	b7cd                	j	598 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5b8:	00ea06b3          	add	a3,s4,a4
 5bc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5c0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5c2:	c681                	beqz	a3,5ca <vprintf+0x7c>
 5c4:	9752                	add	a4,a4,s4
 5c6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5ca:	05878363          	beq	a5,s8,610 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5ce:	05978d63          	beq	a5,s9,628 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5d2:	07500713          	li	a4,117
 5d6:	0ee78763          	beq	a5,a4,6c4 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5da:	07800713          	li	a4,120
 5de:	12e78963          	beq	a5,a4,710 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5e2:	07000713          	li	a4,112
 5e6:	14e78e63          	beq	a5,a4,742 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5ea:	06300713          	li	a4,99
 5ee:	18e78e63          	beq	a5,a4,78a <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5f2:	07300713          	li	a4,115
 5f6:	1ae78463          	beq	a5,a4,79e <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5fa:	02500713          	li	a4,37
 5fe:	04e79563          	bne	a5,a4,648 <vprintf+0xfa>
        putc(fd, '%');
 602:	02500593          	li	a1,37
 606:	855a                	mv	a0,s6
 608:	e8dff0ef          	jal	494 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 60c:	4981                	li	s3,0
 60e:	b769                	j	598 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 610:	008b8913          	addi	s2,s7,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e95ff0ef          	jal	4b2 <printint>
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	bf8d                	j	598 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 628:	06400793          	li	a5,100
 62c:	02f68963          	beq	a3,a5,65e <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 630:	06c00793          	li	a5,108
 634:	04f68263          	beq	a3,a5,678 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 638:	07500793          	li	a5,117
 63c:	0af68063          	beq	a3,a5,6dc <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 640:	07800793          	li	a5,120
 644:	0ef68263          	beq	a3,a5,728 <vprintf+0x1da>
        putc(fd, '%');
 648:	02500593          	li	a1,37
 64c:	855a                	mv	a0,s6
 64e:	e47ff0ef          	jal	494 <putc>
        putc(fd, c0);
 652:	85ca                	mv	a1,s2
 654:	855a                	mv	a0,s6
 656:	e3fff0ef          	jal	494 <putc>
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bf35                	j	598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	008b8913          	addi	s2,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e47ff0ef          	jal	4b2 <printint>
        i += 1;
 670:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
        i += 1;
 676:	b70d                	j	598 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 678:	06400793          	li	a5,100
 67c:	02f60763          	beq	a2,a5,6aa <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 680:	07500793          	li	a5,117
 684:	06f60963          	beq	a2,a5,6f6 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 688:	07800793          	li	a5,120
 68c:	faf61ee3          	bne	a2,a5,648 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 690:	008b8913          	addi	s2,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	e15ff0ef          	jal	4b2 <printint>
        i += 2;
 6a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a4:	8bca                	mv	s7,s2
      state = 0;
 6a6:	4981                	li	s3,0
        i += 2;
 6a8:	bdc5                	j	598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6aa:	008b8913          	addi	s2,s7,8
 6ae:	4685                	li	a3,1
 6b0:	4629                	li	a2,10
 6b2:	000bb583          	ld	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	dfbff0ef          	jal	4b2 <printint>
        i += 2;
 6bc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
        i += 2;
 6c2:	bdd9                	j	598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6c4:	008b8913          	addi	s2,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4629                	li	a2,10
 6cc:	000be583          	lwu	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	de1ff0ef          	jal	4b2 <printint>
 6d6:	8bca                	mv	s7,s2
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bd7d                	j	598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6dc:	008b8913          	addi	s2,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4629                	li	a2,10
 6e4:	000bb583          	ld	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	dc9ff0ef          	jal	4b2 <printint>
        i += 1;
 6ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f0:	8bca                	mv	s7,s2
      state = 0;
 6f2:	4981                	li	s3,0
        i += 1;
 6f4:	b555                	j	598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f6:	008b8913          	addi	s2,s7,8
 6fa:	4681                	li	a3,0
 6fc:	4629                	li	a2,10
 6fe:	000bb583          	ld	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	dafff0ef          	jal	4b2 <printint>
        i += 2;
 708:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
        i += 2;
 70e:	b569                	j	598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 710:	008b8913          	addi	s2,s7,8
 714:	4681                	li	a3,0
 716:	4641                	li	a2,16
 718:	000be583          	lwu	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	d95ff0ef          	jal	4b2 <printint>
 722:	8bca                	mv	s7,s2
      state = 0;
 724:	4981                	li	s3,0
 726:	bd8d                	j	598 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 728:	008b8913          	addi	s2,s7,8
 72c:	4681                	li	a3,0
 72e:	4641                	li	a2,16
 730:	000bb583          	ld	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	d7dff0ef          	jal	4b2 <printint>
        i += 1;
 73a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 73c:	8bca                	mv	s7,s2
      state = 0;
 73e:	4981                	li	s3,0
        i += 1;
 740:	bda1                	j	598 <vprintf+0x4a>
 742:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 744:	008b8d13          	addi	s10,s7,8
 748:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 74c:	03000593          	li	a1,48
 750:	855a                	mv	a0,s6
 752:	d43ff0ef          	jal	494 <putc>
  putc(fd, 'x');
 756:	07800593          	li	a1,120
 75a:	855a                	mv	a0,s6
 75c:	d39ff0ef          	jal	494 <putc>
 760:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 762:	00000b97          	auipc	s7,0x0
 766:	526b8b93          	addi	s7,s7,1318 # c88 <digits>
 76a:	03c9d793          	srli	a5,s3,0x3c
 76e:	97de                	add	a5,a5,s7
 770:	0007c583          	lbu	a1,0(a5)
 774:	855a                	mv	a0,s6
 776:	d1fff0ef          	jal	494 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77a:	0992                	slli	s3,s3,0x4
 77c:	397d                	addiw	s2,s2,-1
 77e:	fe0916e3          	bnez	s2,76a <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 782:	8bea                	mv	s7,s10
      state = 0;
 784:	4981                	li	s3,0
 786:	6d02                	ld	s10,0(sp)
 788:	bd01                	j	598 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 78a:	008b8913          	addi	s2,s7,8
 78e:	000bc583          	lbu	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	d01ff0ef          	jal	494 <putc>
 798:	8bca                	mv	s7,s2
      state = 0;
 79a:	4981                	li	s3,0
 79c:	bbf5                	j	598 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 79e:	008b8993          	addi	s3,s7,8
 7a2:	000bb903          	ld	s2,0(s7)
 7a6:	00090f63          	beqz	s2,7c4 <vprintf+0x276>
        for(; *s; s++)
 7aa:	00094583          	lbu	a1,0(s2)
 7ae:	c195                	beqz	a1,7d2 <vprintf+0x284>
          putc(fd, *s);
 7b0:	855a                	mv	a0,s6
 7b2:	ce3ff0ef          	jal	494 <putc>
        for(; *s; s++)
 7b6:	0905                	addi	s2,s2,1
 7b8:	00094583          	lbu	a1,0(s2)
 7bc:	f9f5                	bnez	a1,7b0 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7be:	8bce                	mv	s7,s3
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bbd9                	j	598 <vprintf+0x4a>
          s = "(null)";
 7c4:	00000917          	auipc	s2,0x0
 7c8:	4bc90913          	addi	s2,s2,1212 # c80 <malloc+0x3b0>
        for(; *s; s++)
 7cc:	02800593          	li	a1,40
 7d0:	b7c5                	j	7b0 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7d2:	8bce                	mv	s7,s3
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b3c9                	j	598 <vprintf+0x4a>
 7d8:	64a6                	ld	s1,72(sp)
 7da:	79e2                	ld	s3,56(sp)
 7dc:	7a42                	ld	s4,48(sp)
 7de:	7aa2                	ld	s5,40(sp)
 7e0:	7b02                	ld	s6,32(sp)
 7e2:	6be2                	ld	s7,24(sp)
 7e4:	6c42                	ld	s8,16(sp)
 7e6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7e8:	60e6                	ld	ra,88(sp)
 7ea:	6446                	ld	s0,80(sp)
 7ec:	6906                	ld	s2,64(sp)
 7ee:	6125                	addi	sp,sp,96
 7f0:	8082                	ret

00000000000007f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f2:	715d                	addi	sp,sp,-80
 7f4:	ec06                	sd	ra,24(sp)
 7f6:	e822                	sd	s0,16(sp)
 7f8:	1000                	addi	s0,sp,32
 7fa:	e010                	sd	a2,0(s0)
 7fc:	e414                	sd	a3,8(s0)
 7fe:	e818                	sd	a4,16(s0)
 800:	ec1c                	sd	a5,24(s0)
 802:	03043023          	sd	a6,32(s0)
 806:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 80a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80e:	8622                	mv	a2,s0
 810:	d3fff0ef          	jal	54e <vprintf>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6161                	addi	sp,sp,80
 81a:	8082                	ret

000000000000081c <printf>:

void
printf(const char *fmt, ...)
{
 81c:	711d                	addi	sp,sp,-96
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e40c                	sd	a1,8(s0)
 826:	e810                	sd	a2,16(s0)
 828:	ec14                	sd	a3,24(s0)
 82a:	f018                	sd	a4,32(s0)
 82c:	f41c                	sd	a5,40(s0)
 82e:	03043823          	sd	a6,48(s0)
 832:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 836:	00840613          	addi	a2,s0,8
 83a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83e:	85aa                	mv	a1,a0
 840:	4505                	li	a0,1
 842:	d0dff0ef          	jal	54e <vprintf>
}
 846:	60e2                	ld	ra,24(sp)
 848:	6442                	ld	s0,16(sp)
 84a:	6125                	addi	sp,sp,96
 84c:	8082                	ret

000000000000084e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84e:	1141                	addi	sp,sp,-16
 850:	e422                	sd	s0,8(sp)
 852:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 854:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 858:	00001797          	auipc	a5,0x1
 85c:	7a87b783          	ld	a5,1960(a5) # 2000 <freep>
 860:	a02d                	j	88a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 862:	4618                	lw	a4,8(a2)
 864:	9f2d                	addw	a4,a4,a1
 866:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86a:	6398                	ld	a4,0(a5)
 86c:	6310                	ld	a2,0(a4)
 86e:	a83d                	j	8ac <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 870:	ff852703          	lw	a4,-8(a0)
 874:	9f31                	addw	a4,a4,a2
 876:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 878:	ff053683          	ld	a3,-16(a0)
 87c:	a091                	j	8c0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87e:	6398                	ld	a4,0(a5)
 880:	00e7e463          	bltu	a5,a4,888 <free+0x3a>
 884:	00e6ea63          	bltu	a3,a4,898 <free+0x4a>
{
 888:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	fed7fae3          	bgeu	a5,a3,87e <free+0x30>
 88e:	6398                	ld	a4,0(a5)
 890:	00e6e463          	bltu	a3,a4,898 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 894:	fee7eae3          	bltu	a5,a4,888 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 898:	ff852583          	lw	a1,-8(a0)
 89c:	6390                	ld	a2,0(a5)
 89e:	02059813          	slli	a6,a1,0x20
 8a2:	01c85713          	srli	a4,a6,0x1c
 8a6:	9736                	add	a4,a4,a3
 8a8:	fae60de3          	beq	a2,a4,862 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8b0:	4790                	lw	a2,8(a5)
 8b2:	02061593          	slli	a1,a2,0x20
 8b6:	01c5d713          	srli	a4,a1,0x1c
 8ba:	973e                	add	a4,a4,a5
 8bc:	fae68ae3          	beq	a3,a4,870 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c2:	00001717          	auipc	a4,0x1
 8c6:	72f73f23          	sd	a5,1854(a4) # 2000 <freep>
}
 8ca:	6422                	ld	s0,8(sp)
 8cc:	0141                	addi	sp,sp,16
 8ce:	8082                	ret

00000000000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	7139                	addi	sp,sp,-64
 8d2:	fc06                	sd	ra,56(sp)
 8d4:	f822                	sd	s0,48(sp)
 8d6:	f426                	sd	s1,40(sp)
 8d8:	ec4e                	sd	s3,24(sp)
 8da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8dc:	02051493          	slli	s1,a0,0x20
 8e0:	9081                	srli	s1,s1,0x20
 8e2:	04bd                	addi	s1,s1,15
 8e4:	8091                	srli	s1,s1,0x4
 8e6:	0014899b          	addiw	s3,s1,1
 8ea:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ec:	00001517          	auipc	a0,0x1
 8f0:	71453503          	ld	a0,1812(a0) # 2000 <freep>
 8f4:	c915                	beqz	a0,928 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f8:	4798                	lw	a4,8(a5)
 8fa:	08977a63          	bgeu	a4,s1,98e <malloc+0xbe>
 8fe:	f04a                	sd	s2,32(sp)
 900:	e852                	sd	s4,16(sp)
 902:	e456                	sd	s5,8(sp)
 904:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 906:	8a4e                	mv	s4,s3
 908:	0009871b          	sext.w	a4,s3
 90c:	6685                	lui	a3,0x1
 90e:	00d77363          	bgeu	a4,a3,914 <malloc+0x44>
 912:	6a05                	lui	s4,0x1
 914:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 918:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 91c:	00001917          	auipc	s2,0x1
 920:	6e490913          	addi	s2,s2,1764 # 2000 <freep>
  if(p == SBRK_ERROR)
 924:	5afd                	li	s5,-1
 926:	a081                	j	966 <malloc+0x96>
 928:	f04a                	sd	s2,32(sp)
 92a:	e852                	sd	s4,16(sp)
 92c:	e456                	sd	s5,8(sp)
 92e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 930:	00001797          	auipc	a5,0x1
 934:	6e078793          	addi	a5,a5,1760 # 2010 <base>
 938:	00001717          	auipc	a4,0x1
 93c:	6cf73423          	sd	a5,1736(a4) # 2000 <freep>
 940:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 942:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 946:	b7c1                	j	906 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 948:	6398                	ld	a4,0(a5)
 94a:	e118                	sd	a4,0(a0)
 94c:	a8a9                	j	9a6 <malloc+0xd6>
  hp->s.size = nu;
 94e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 952:	0541                	addi	a0,a0,16
 954:	efbff0ef          	jal	84e <free>
  return freep;
 958:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 95c:	c12d                	beqz	a0,9be <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 960:	4798                	lw	a4,8(a5)
 962:	02977263          	bgeu	a4,s1,986 <malloc+0xb6>
    if(p == freep)
 966:	00093703          	ld	a4,0(s2)
 96a:	853e                	mv	a0,a5
 96c:	fef719e3          	bne	a4,a5,95e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 970:	8552                	mv	a0,s4
 972:	a27ff0ef          	jal	398 <sbrk>
  if(p == SBRK_ERROR)
 976:	fd551ce3          	bne	a0,s5,94e <malloc+0x7e>
        return 0;
 97a:	4501                	li	a0,0
 97c:	7902                	ld	s2,32(sp)
 97e:	6a42                	ld	s4,16(sp)
 980:	6aa2                	ld	s5,8(sp)
 982:	6b02                	ld	s6,0(sp)
 984:	a03d                	j	9b2 <malloc+0xe2>
 986:	7902                	ld	s2,32(sp)
 988:	6a42                	ld	s4,16(sp)
 98a:	6aa2                	ld	s5,8(sp)
 98c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 98e:	fae48de3          	beq	s1,a4,948 <malloc+0x78>
        p->s.size -= nunits;
 992:	4137073b          	subw	a4,a4,s3
 996:	c798                	sw	a4,8(a5)
        p += p->s.size;
 998:	02071693          	slli	a3,a4,0x20
 99c:	01c6d713          	srli	a4,a3,0x1c
 9a0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a6:	00001717          	auipc	a4,0x1
 9aa:	64a73d23          	sd	a0,1626(a4) # 2000 <freep>
      return (void*)(p + 1);
 9ae:	01078513          	addi	a0,a5,16
  }
}
 9b2:	70e2                	ld	ra,56(sp)
 9b4:	7442                	ld	s0,48(sp)
 9b6:	74a2                	ld	s1,40(sp)
 9b8:	69e2                	ld	s3,24(sp)
 9ba:	6121                	addi	sp,sp,64
 9bc:	8082                	ret
 9be:	7902                	ld	s2,32(sp)
 9c0:	6a42                	ld	s4,16(sp)
 9c2:	6aa2                	ld	s5,8(sp)
 9c4:	6b02                	ld	s6,0(sp)
 9c6:	b7f5                	j	9b2 <malloc+0xe2>
