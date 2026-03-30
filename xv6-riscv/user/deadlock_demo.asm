
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
   c:	a0850513          	addi	a0,a0,-1528 # a10 <malloc+0xfc>
  10:	04d000ef          	jal	85c <printf>
  printf("Two processes will try to acquire locks in opposite order.\n");
  14:	00001517          	auipc	a0,0x1
  18:	a3450513          	addi	a0,a0,-1484 # a48 <malloc+0x134>
  1c:	041000ef          	jal	85c <printf>
  printf("When deadlock is detected, the process with highest energy\n");
  20:	00001517          	auipc	a0,0x1
  24:	a6850513          	addi	a0,a0,-1432 # a88 <malloc+0x174>
  28:	035000ef          	jal	85c <printf>
  printf("consumption will be killed to break the deadlock.\n\n");
  2c:	00001517          	auipc	a0,0x1
  30:	a9c50513          	addi	a0,a0,-1380 # ac8 <malloc+0x1b4>
  34:	029000ef          	jal	85c <printf>

  int pid = fork();
  38:	3ae000ef          	jal	3e6 <fork>

  if(pid < 0){
  3c:	06054363          	bltz	a0,a2 <main+0xa2>
    printf("deadlock_demo: fork failed\n");
    exit(1);
  }

  if(pid == 0){
  40:	e935                	bnez	a0,b4 <main+0xb4>
  42:	000f47b7          	lui	a5,0xf4
  46:	24078793          	addi	a5,a5,576 # f4240 <base+0xf3230>
    // Child burns some CPU to increase energy_consumed
    // this makes the child the higher-energy process
    for(int i = 0; i < 1000000; i++)
  4a:	37fd                	addiw	a5,a5,-1
  4c:	fffd                	bnez	a5,4a <main+0x4a>
      ;  // busy loop to consume energy ticks

    // Child grabs lock 1 first, then tries lock 0.
    printf("child (pid %d): acquiring lock 1\n", getpid());
  4e:	420000ef          	jal	46e <getpid>
  52:	85aa                	mv	a1,a0
  54:	00001517          	auipc	a0,0x1
  58:	acc50513          	addi	a0,a0,-1332 # b20 <malloc+0x20c>
  5c:	001000ef          	jal	85c <printf>
    dlockacq(1);
  60:	4505                	li	a0,1
  62:	43c000ef          	jal	49e <dlockacq>
    pause(20);
  66:	4551                	li	a0,20
  68:	416000ef          	jal	47e <pause>
    printf("child (pid %d): acquiring lock 0 (should trigger deadlock + recovery)\n", getpid());
  6c:	402000ef          	jal	46e <getpid>
  70:	85aa                	mv	a1,a0
  72:	00001517          	auipc	a0,0x1
  76:	ad650513          	addi	a0,a0,-1322 # b48 <malloc+0x234>
  7a:	7e2000ef          	jal	85c <printf>
    dlockacq(0);
  7e:	4501                	li	a0,0
  80:	41e000ef          	jal	49e <dlockacq>
    printf("child: if you see this, child survived the deadlock\n");
  84:	00001517          	auipc	a0,0x1
  88:	b0c50513          	addi	a0,a0,-1268 # b90 <malloc+0x27c>
  8c:	7d0000ef          	jal	85c <printf>
    dlockrel(0);
  90:	4501                	li	a0,0
  92:	414000ef          	jal	4a6 <dlockrel>
    dlockrel(1);
  96:	4505                	li	a0,1
  98:	40e000ef          	jal	4a6 <dlockrel>
    exit(0);
  9c:	4501                	li	a0,0
  9e:	350000ef          	jal	3ee <exit>
    printf("deadlock_demo: fork failed\n");
  a2:	00001517          	auipc	a0,0x1
  a6:	a5e50513          	addi	a0,a0,-1442 # b00 <malloc+0x1ec>
  aa:	7b2000ef          	jal	85c <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	33e000ef          	jal	3ee <exit>
  }

  // Parent grabs lock 0 first, then tries lock 1.
  printf("parent (pid %d): acquiring lock 0\n", getpid());
  b4:	3ba000ef          	jal	46e <getpid>
  b8:	85aa                	mv	a1,a0
  ba:	00001517          	auipc	a0,0x1
  be:	b0e50513          	addi	a0,a0,-1266 # bc8 <malloc+0x2b4>
  c2:	79a000ef          	jal	85c <printf>
  dlockacq(0);
  c6:	4501                	li	a0,0
  c8:	3d6000ef          	jal	49e <dlockacq>
  pause(20);
  cc:	4551                	li	a0,20
  ce:	3b0000ef          	jal	47e <pause>
  printf("parent (pid %d): acquiring lock 1\n", getpid());
  d2:	39c000ef          	jal	46e <getpid>
  d6:	85aa                	mv	a1,a0
  d8:	00001517          	auipc	a0,0x1
  dc:	b1850513          	addi	a0,a0,-1256 # bf0 <malloc+0x2dc>
  e0:	77c000ef          	jal	85c <printf>
  dlockacq(1);
  e4:	4505                	li	a0,1
  e6:	3b8000ef          	jal	49e <dlockacq>
  printf("parent: if you see this, parent survived the deadlock\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	b2e50513          	addi	a0,a0,-1234 # c18 <malloc+0x304>
  f2:	76a000ef          	jal	85c <printf>

  dlockrel(1);
  f6:	4505                	li	a0,1
  f8:	3ae000ef          	jal	4a6 <dlockrel>
  dlockrel(0);
  fc:	4501                	li	a0,0
  fe:	3a8000ef          	jal	4a6 <dlockrel>

  // Also demonstrate the check_deadlock syscall
  printf("\nCalling check_deadlock() syscall...\n");
 102:	00001517          	auipc	a0,0x1
 106:	b4e50513          	addi	a0,a0,-1202 # c50 <malloc+0x33c>
 10a:	752000ef          	jal	85c <printf>
  int result = check_deadlock();
 10e:	3a0000ef          	jal	4ae <check_deadlock>
 112:	85aa                	mv	a1,a0
  printf("check_deadlock returned: %d (0 = no deadlock found)\n", result);
 114:	00001517          	auipc	a0,0x1
 118:	b6450513          	addi	a0,a0,-1180 # c78 <malloc+0x364>
 11c:	740000ef          	jal	85c <printf>

  wait(0);
 120:	4501                	li	a0,0
 122:	2d4000ef          	jal	3f6 <wait>
  printf("\nDemo complete\n");
 126:	00001517          	auipc	a0,0x1
 12a:	b8a50513          	addi	a0,a0,-1142 # cb0 <malloc+0x39c>
 12e:	72e000ef          	jal	85c <printf>
  exit(0);
 132:	4501                	li	a0,0
 134:	2ba000ef          	jal	3ee <exit>

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
 144:	2aa000ef          	jal	3ee <exit>

0000000000000148 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 150:	87aa                	mv	a5,a0
 152:	0585                	addi	a1,a1,1
 154:	0785                	addi	a5,a5,1
 156:	fff5c703          	lbu	a4,-1(a1)
 15a:	fee78fa3          	sb	a4,-1(a5)
 15e:	fb75                	bnez	a4,152 <strcpy+0xa>
    ;
  return os;
}
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e406                	sd	ra,8(sp)
 16c:	e022                	sd	s0,0(sp)
 16e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	cb91                	beqz	a5,188 <strcmp+0x20>
 176:	0005c703          	lbu	a4,0(a1)
 17a:	00f71763          	bne	a4,a5,188 <strcmp+0x20>
    p++, q++;
 17e:	0505                	addi	a0,a0,1
 180:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	fbe5                	bnez	a5,176 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 188:	0005c503          	lbu	a0,0(a1)
}
 18c:	40a7853b          	subw	a0,a5,a0
 190:	60a2                	ld	ra,8(sp)
 192:	6402                	ld	s0,0(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <strlen>:

uint
strlen(const char *s)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e406                	sd	ra,8(sp)
 19c:	e022                	sd	s0,0(sp)
 19e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	cf91                	beqz	a5,1c0 <strlen+0x28>
 1a6:	00150793          	addi	a5,a0,1
 1aa:	86be                	mv	a3,a5
 1ac:	0785                	addi	a5,a5,1
 1ae:	fff7c703          	lbu	a4,-1(a5)
 1b2:	ff65                	bnez	a4,1aa <strlen+0x12>
 1b4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  for(n = 0; s[n]; n++)
 1c0:	4501                	li	a0,0
 1c2:	bfdd                	j	1b8 <strlen+0x20>

00000000000001c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c4:	1141                	addi	sp,sp,-16
 1c6:	e406                	sd	ra,8(sp)
 1c8:	e022                	sd	s0,0(sp)
 1ca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1cc:	ca19                	beqz	a2,1e2 <memset+0x1e>
 1ce:	87aa                	mv	a5,a0
 1d0:	1602                	slli	a2,a2,0x20
 1d2:	9201                	srli	a2,a2,0x20
 1d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1dc:	0785                	addi	a5,a5,1
 1de:	fee79de3          	bne	a5,a4,1d8 <memset+0x14>
  }
  return dst;
}
 1e2:	60a2                	ld	ra,8(sp)
 1e4:	6402                	ld	s0,0(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret

00000000000001ea <strchr>:

char*
strchr(const char *s, char c)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cf81                	beqz	a5,20e <strchr+0x24>
    if(*s == c)
 1f8:	00f58763          	beq	a1,a5,206 <strchr+0x1c>
  for(; *s; s++)
 1fc:	0505                	addi	a0,a0,1
 1fe:	00054783          	lbu	a5,0(a0)
 202:	fbfd                	bnez	a5,1f8 <strchr+0xe>
      return (char*)s;
  return 0;
 204:	4501                	li	a0,0
}
 206:	60a2                	ld	ra,8(sp)
 208:	6402                	ld	s0,0(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  return 0;
 20e:	4501                	li	a0,0
 210:	bfdd                	j	206 <strchr+0x1c>

0000000000000212 <gets>:

char*
gets(char *buf, int max)
{
 212:	711d                	addi	sp,sp,-96
 214:	ec86                	sd	ra,88(sp)
 216:	e8a2                	sd	s0,80(sp)
 218:	e4a6                	sd	s1,72(sp)
 21a:	e0ca                	sd	s2,64(sp)
 21c:	fc4e                	sd	s3,56(sp)
 21e:	f852                	sd	s4,48(sp)
 220:	f456                	sd	s5,40(sp)
 222:	f05a                	sd	s6,32(sp)
 224:	ec5e                	sd	s7,24(sp)
 226:	e862                	sd	s8,16(sp)
 228:	1080                	addi	s0,sp,96
 22a:	8baa                	mv	s7,a0
 22c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	892a                	mv	s2,a0
 230:	4481                	li	s1,0
    cc = read(0, &c, 1);
 232:	faf40b13          	addi	s6,s0,-81
 236:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 238:	8c26                	mv	s8,s1
 23a:	0014899b          	addiw	s3,s1,1
 23e:	84ce                	mv	s1,s3
 240:	0349d463          	bge	s3,s4,268 <gets+0x56>
    cc = read(0, &c, 1);
 244:	8656                	mv	a2,s5
 246:	85da                	mv	a1,s6
 248:	4501                	li	a0,0
 24a:	1bc000ef          	jal	406 <read>
    if(cc < 1)
 24e:	00a05d63          	blez	a0,268 <gets+0x56>
      break;
    buf[i++] = c;
 252:	faf44783          	lbu	a5,-81(s0)
 256:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25a:	0905                	addi	s2,s2,1
 25c:	ff678713          	addi	a4,a5,-10
 260:	c319                	beqz	a4,266 <gets+0x54>
 262:	17cd                	addi	a5,a5,-13
 264:	fbf1                	bnez	a5,238 <gets+0x26>
    buf[i++] = c;
 266:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 268:	9c5e                	add	s8,s8,s7
 26a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 26e:	855e                	mv	a0,s7
 270:	60e6                	ld	ra,88(sp)
 272:	6446                	ld	s0,80(sp)
 274:	64a6                	ld	s1,72(sp)
 276:	6906                	ld	s2,64(sp)
 278:	79e2                	ld	s3,56(sp)
 27a:	7a42                	ld	s4,48(sp)
 27c:	7aa2                	ld	s5,40(sp)
 27e:	7b02                	ld	s6,32(sp)
 280:	6be2                	ld	s7,24(sp)
 282:	6c42                	ld	s8,16(sp)
 284:	6125                	addi	sp,sp,96
 286:	8082                	ret

0000000000000288 <stat>:

int
stat(const char *n, struct stat *st)
{
 288:	1101                	addi	sp,sp,-32
 28a:	ec06                	sd	ra,24(sp)
 28c:	e822                	sd	s0,16(sp)
 28e:	e04a                	sd	s2,0(sp)
 290:	1000                	addi	s0,sp,32
 292:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 294:	4581                	li	a1,0
 296:	198000ef          	jal	42e <open>
  if(fd < 0)
 29a:	02054263          	bltz	a0,2be <stat+0x36>
 29e:	e426                	sd	s1,8(sp)
 2a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a2:	85ca                	mv	a1,s2
 2a4:	1a2000ef          	jal	446 <fstat>
 2a8:	892a                	mv	s2,a0
  close(fd);
 2aa:	8526                	mv	a0,s1
 2ac:	16a000ef          	jal	416 <close>
  return r;
 2b0:	64a2                	ld	s1,8(sp)
}
 2b2:	854a                	mv	a0,s2
 2b4:	60e2                	ld	ra,24(sp)
 2b6:	6442                	ld	s0,16(sp)
 2b8:	6902                	ld	s2,0(sp)
 2ba:	6105                	addi	sp,sp,32
 2bc:	8082                	ret
    return -1;
 2be:	57fd                	li	a5,-1
 2c0:	893e                	mv	s2,a5
 2c2:	bfc5                	j	2b2 <stat+0x2a>

00000000000002c4 <atoi>:

int
atoi(const char *s)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cc:	00054683          	lbu	a3,0(a0)
 2d0:	fd06879b          	addiw	a5,a3,-48
 2d4:	0ff7f793          	zext.b	a5,a5
 2d8:	4625                	li	a2,9
 2da:	02f66963          	bltu	a2,a5,30c <atoi+0x48>
 2de:	872a                	mv	a4,a0
  n = 0;
 2e0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2e2:	0705                	addi	a4,a4,1
 2e4:	0025179b          	slliw	a5,a0,0x2
 2e8:	9fa9                	addw	a5,a5,a0
 2ea:	0017979b          	slliw	a5,a5,0x1
 2ee:	9fb5                	addw	a5,a5,a3
 2f0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f4:	00074683          	lbu	a3,0(a4)
 2f8:	fd06879b          	addiw	a5,a3,-48
 2fc:	0ff7f793          	zext.b	a5,a5
 300:	fef671e3          	bgeu	a2,a5,2e2 <atoi+0x1e>
  return n;
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
  n = 0;
 30c:	4501                	li	a0,0
 30e:	bfdd                	j	304 <atoi+0x40>

0000000000000310 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 310:	1141                	addi	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 318:	02b57563          	bgeu	a0,a1,342 <memmove+0x32>
    while(n-- > 0)
 31c:	00c05f63          	blez	a2,33a <memmove+0x2a>
 320:	1602                	slli	a2,a2,0x20
 322:	9201                	srli	a2,a2,0x20
 324:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 328:	872a                	mv	a4,a0
      *dst++ = *src++;
 32a:	0585                	addi	a1,a1,1
 32c:	0705                	addi	a4,a4,1
 32e:	fff5c683          	lbu	a3,-1(a1)
 332:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 336:	fee79ae3          	bne	a5,a4,32a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 33a:	60a2                	ld	ra,8(sp)
 33c:	6402                	ld	s0,0(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
    while(n-- > 0)
 342:	fec05ce3          	blez	a2,33a <memmove+0x2a>
    dst += n;
 346:	00c50733          	add	a4,a0,a2
    src += n;
 34a:	95b2                	add	a1,a1,a2
 34c:	fff6079b          	addiw	a5,a2,-1
 350:	1782                	slli	a5,a5,0x20
 352:	9381                	srli	a5,a5,0x20
 354:	fff7c793          	not	a5,a5
 358:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35a:	15fd                	addi	a1,a1,-1
 35c:	177d                	addi	a4,a4,-1
 35e:	0005c683          	lbu	a3,0(a1)
 362:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 366:	fef71ae3          	bne	a4,a5,35a <memmove+0x4a>
 36a:	bfc1                	j	33a <memmove+0x2a>

000000000000036c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 374:	c61d                	beqz	a2,3a2 <memcmp+0x36>
 376:	1602                	slli	a2,a2,0x20
 378:	9201                	srli	a2,a2,0x20
 37a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 37e:	00054783          	lbu	a5,0(a0)
 382:	0005c703          	lbu	a4,0(a1)
 386:	00e79863          	bne	a5,a4,396 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 38a:	0505                	addi	a0,a0,1
    p2++;
 38c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 38e:	fed518e3          	bne	a0,a3,37e <memcmp+0x12>
  }
  return 0;
 392:	4501                	li	a0,0
 394:	a019                	j	39a <memcmp+0x2e>
      return *p1 - *p2;
 396:	40e7853b          	subw	a0,a5,a4
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	bfdd                	j	39a <memcmp+0x2e>

00000000000003a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e406                	sd	ra,8(sp)
 3aa:	e022                	sd	s0,0(sp)
 3ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ae:	f63ff0ef          	jal	310 <memmove>
}
 3b2:	60a2                	ld	ra,8(sp)
 3b4:	6402                	ld	s0,0(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret

00000000000003ba <sbrk>:

char *
sbrk(int n) {
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e406                	sd	ra,8(sp)
 3be:	e022                	sd	s0,0(sp)
 3c0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3c2:	4585                	li	a1,1
 3c4:	0b2000ef          	jal	476 <sys_sbrk>
}
 3c8:	60a2                	ld	ra,8(sp)
 3ca:	6402                	ld	s0,0(sp)
 3cc:	0141                	addi	sp,sp,16
 3ce:	8082                	ret

00000000000003d0 <sbrklazy>:

char *
sbrklazy(int n) {
 3d0:	1141                	addi	sp,sp,-16
 3d2:	e406                	sd	ra,8(sp)
 3d4:	e022                	sd	s0,0(sp)
 3d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3d8:	4589                	li	a1,2
 3da:	09c000ef          	jal	476 <sys_sbrk>
}
 3de:	60a2                	ld	ra,8(sp)
 3e0:	6402                	ld	s0,0(sp)
 3e2:	0141                	addi	sp,sp,16
 3e4:	8082                	ret

00000000000003e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e6:	4885                	li	a7,1
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ee:	4889                	li	a7,2
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f6:	488d                	li	a7,3
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fe:	4891                	li	a7,4
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <read>:
.global read
read:
 li a7, SYS_read
 406:	4895                	li	a7,5
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <write>:
.global write
write:
 li a7, SYS_write
 40e:	48c1                	li	a7,16
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <close>:
.global close
close:
 li a7, SYS_close
 416:	48d5                	li	a7,21
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <kill>:
.global kill
kill:
 li a7, SYS_kill
 41e:	4899                	li	a7,6
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <exec>:
.global exec
exec:
 li a7, SYS_exec
 426:	489d                	li	a7,7
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <open>:
.global open
open:
 li a7, SYS_open
 42e:	48bd                	li	a7,15
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 436:	48c5                	li	a7,17
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43e:	48c9                	li	a7,18
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 446:	48a1                	li	a7,8
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <link>:
.global link
link:
 li a7, SYS_link
 44e:	48cd                	li	a7,19
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 456:	48d1                	li	a7,20
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45e:	48a5                	li	a7,9
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <dup>:
.global dup
dup:
 li a7, SYS_dup
 466:	48a9                	li	a7,10
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46e:	48ad                	li	a7,11
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 476:	48b1                	li	a7,12
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <pause>:
.global pause
pause:
 li a7, SYS_pause
 47e:	48b5                	li	a7,13
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 486:	48b9                	li	a7,14
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <kps>:
.global kps
kps:
 li a7, SYS_kps
 48e:	48d9                	li	a7,22
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 496:	48dd                	li	a7,23
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 49e:	48e1                	li	a7,24
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 4a6:	48e5                	li	a7,25
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 4ae:	48e9                	li	a7,26
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b6:	1101                	addi	sp,sp,-32
 4b8:	ec06                	sd	ra,24(sp)
 4ba:	e822                	sd	s0,16(sp)
 4bc:	1000                	addi	s0,sp,32
 4be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c2:	4605                	li	a2,1
 4c4:	fef40593          	addi	a1,s0,-17
 4c8:	f47ff0ef          	jal	40e <write>
}
 4cc:	60e2                	ld	ra,24(sp)
 4ce:	6442                	ld	s0,16(sp)
 4d0:	6105                	addi	sp,sp,32
 4d2:	8082                	ret

00000000000004d4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4d4:	715d                	addi	sp,sp,-80
 4d6:	e486                	sd	ra,72(sp)
 4d8:	e0a2                	sd	s0,64(sp)
 4da:	f84a                	sd	s2,48(sp)
 4dc:	f44e                	sd	s3,40(sp)
 4de:	0880                	addi	s0,sp,80
 4e0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4e2:	c6d1                	beqz	a3,56e <printint+0x9a>
 4e4:	0805d563          	bgez	a1,56e <printint+0x9a>
    neg = 1;
    x = -xx;
 4e8:	40b005b3          	neg	a1,a1
    neg = 1;
 4ec:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4ee:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4f2:	86ce                	mv	a3,s3
  i = 0;
 4f4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f6:	00000817          	auipc	a6,0x0
 4fa:	7d280813          	addi	a6,a6,2002 # cc8 <digits>
 4fe:	88ba                	mv	a7,a4
 500:	0017051b          	addiw	a0,a4,1
 504:	872a                	mv	a4,a0
 506:	02c5f7b3          	remu	a5,a1,a2
 50a:	97c2                	add	a5,a5,a6
 50c:	0007c783          	lbu	a5,0(a5)
 510:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 514:	87ae                	mv	a5,a1
 516:	02c5d5b3          	divu	a1,a1,a2
 51a:	0685                	addi	a3,a3,1
 51c:	fec7f1e3          	bgeu	a5,a2,4fe <printint+0x2a>
  if(neg)
 520:	00030c63          	beqz	t1,538 <printint+0x64>
    buf[i++] = '-';
 524:	fd050793          	addi	a5,a0,-48
 528:	00878533          	add	a0,a5,s0
 52c:	02d00793          	li	a5,45
 530:	fef50423          	sb	a5,-24(a0)
 534:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 538:	02e05563          	blez	a4,562 <printint+0x8e>
 53c:	fc26                	sd	s1,56(sp)
 53e:	377d                	addiw	a4,a4,-1
 540:	00e984b3          	add	s1,s3,a4
 544:	19fd                	addi	s3,s3,-1
 546:	99ba                	add	s3,s3,a4
 548:	1702                	slli	a4,a4,0x20
 54a:	9301                	srli	a4,a4,0x20
 54c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 550:	0004c583          	lbu	a1,0(s1)
 554:	854a                	mv	a0,s2
 556:	f61ff0ef          	jal	4b6 <putc>
  while(--i >= 0)
 55a:	14fd                	addi	s1,s1,-1
 55c:	ff349ae3          	bne	s1,s3,550 <printint+0x7c>
 560:	74e2                	ld	s1,56(sp)
}
 562:	60a6                	ld	ra,72(sp)
 564:	6406                	ld	s0,64(sp)
 566:	7942                	ld	s2,48(sp)
 568:	79a2                	ld	s3,40(sp)
 56a:	6161                	addi	sp,sp,80
 56c:	8082                	ret
  neg = 0;
 56e:	4301                	li	t1,0
 570:	bfbd                	j	4ee <printint+0x1a>

0000000000000572 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 572:	711d                	addi	sp,sp,-96
 574:	ec86                	sd	ra,88(sp)
 576:	e8a2                	sd	s0,80(sp)
 578:	e4a6                	sd	s1,72(sp)
 57a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 57c:	0005c483          	lbu	s1,0(a1)
 580:	22048363          	beqz	s1,7a6 <vprintf+0x234>
 584:	e0ca                	sd	s2,64(sp)
 586:	fc4e                	sd	s3,56(sp)
 588:	f852                	sd	s4,48(sp)
 58a:	f456                	sd	s5,40(sp)
 58c:	f05a                	sd	s6,32(sp)
 58e:	ec5e                	sd	s7,24(sp)
 590:	e862                	sd	s8,16(sp)
 592:	8b2a                	mv	s6,a0
 594:	8a2e                	mv	s4,a1
 596:	8bb2                	mv	s7,a2
  state = 0;
 598:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 59a:	4901                	li	s2,0
 59c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 59e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5a2:	06400c13          	li	s8,100
 5a6:	a00d                	j	5c8 <vprintf+0x56>
        putc(fd, c0);
 5a8:	85a6                	mv	a1,s1
 5aa:	855a                	mv	a0,s6
 5ac:	f0bff0ef          	jal	4b6 <putc>
 5b0:	a019                	j	5b6 <vprintf+0x44>
    } else if(state == '%'){
 5b2:	03598363          	beq	s3,s5,5d8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5b6:	0019079b          	addiw	a5,s2,1
 5ba:	893e                	mv	s2,a5
 5bc:	873e                	mv	a4,a5
 5be:	97d2                	add	a5,a5,s4
 5c0:	0007c483          	lbu	s1,0(a5)
 5c4:	1c048a63          	beqz	s1,798 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5c8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5cc:	fe0993e3          	bnez	s3,5b2 <vprintf+0x40>
      if(c0 == '%'){
 5d0:	fd579ce3          	bne	a5,s5,5a8 <vprintf+0x36>
        state = '%';
 5d4:	89be                	mv	s3,a5
 5d6:	b7c5                	j	5b6 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5d8:	00ea06b3          	add	a3,s4,a4
 5dc:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5e0:	1c060863          	beqz	a2,7b0 <vprintf+0x23e>
      if(c0 == 'd'){
 5e4:	03878763          	beq	a5,s8,612 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5e8:	f9478693          	addi	a3,a5,-108
 5ec:	0016b693          	seqz	a3,a3
 5f0:	f9c60593          	addi	a1,a2,-100
 5f4:	e99d                	bnez	a1,62a <vprintf+0xb8>
 5f6:	ca95                	beqz	a3,62a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	ecfff0ef          	jal	4d4 <printint>
        i += 1;
 60a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 60e:	4981                	li	s3,0
 610:	b75d                	j	5b6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 612:	008b8493          	addi	s1,s7,8
 616:	4685                	li	a3,1
 618:	4629                	li	a2,10
 61a:	000ba583          	lw	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	eb5ff0ef          	jal	4d4 <printint>
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
 628:	b779                	j	5b6 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 62a:	9752                	add	a4,a4,s4
 62c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 630:	f9460713          	addi	a4,a2,-108
 634:	00173713          	seqz	a4,a4
 638:	8f75                	and	a4,a4,a3
 63a:	f9c58513          	addi	a0,a1,-100
 63e:	18051363          	bnez	a0,7c4 <vprintf+0x252>
 642:	18070163          	beqz	a4,7c4 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 646:	008b8493          	addi	s1,s7,8
 64a:	4685                	li	a3,1
 64c:	4629                	li	a2,10
 64e:	000bb583          	ld	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	e81ff0ef          	jal	4d4 <printint>
        i += 2;
 658:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 65a:	8ba6                	mv	s7,s1
      state = 0;
 65c:	4981                	li	s3,0
        i += 2;
 65e:	bfa1                	j	5b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 660:	008b8493          	addi	s1,s7,8
 664:	4681                	li	a3,0
 666:	4629                	li	a2,10
 668:	000be583          	lwu	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	e67ff0ef          	jal	4d4 <printint>
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
 676:	b781                	j	5b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000bb583          	ld	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	e4fff0ef          	jal	4d4 <printint>
        i += 1;
 68a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	8ba6                	mv	s7,s1
      state = 0;
 68e:	4981                	li	s3,0
 690:	b71d                	j	5b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	008b8493          	addi	s1,s7,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000bb583          	ld	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	e35ff0ef          	jal	4d4 <printint>
        i += 2;
 6a4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	8ba6                	mv	s7,s1
      state = 0;
 6a8:	4981                	li	s3,0
        i += 2;
 6aa:	b731                	j	5b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	4681                	li	a3,0
 6b2:	4641                	li	a2,16
 6b4:	000be583          	lwu	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	e1bff0ef          	jal	4d4 <printint>
 6be:	8ba6                	mv	s7,s1
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bdd5                	j	5b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c4:	008b8493          	addi	s1,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000bb583          	ld	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	e03ff0ef          	jal	4d4 <printint>
        i += 1;
 6d6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d8:	8ba6                	mv	s7,s1
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bde9                	j	5b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6de:	008b8493          	addi	s1,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4641                	li	a2,16
 6e6:	000bb583          	ld	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	de9ff0ef          	jal	4d4 <printint>
        i += 2;
 6f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	8ba6                	mv	s7,s1
      state = 0;
 6f4:	4981                	li	s3,0
        i += 2;
 6f6:	b5c1                	j	5b6 <vprintf+0x44>
 6f8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6fa:	008b8793          	addi	a5,s7,8
 6fe:	8cbe                	mv	s9,a5
 700:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 704:	03000593          	li	a1,48
 708:	855a                	mv	a0,s6
 70a:	dadff0ef          	jal	4b6 <putc>
  putc(fd, 'x');
 70e:	07800593          	li	a1,120
 712:	855a                	mv	a0,s6
 714:	da3ff0ef          	jal	4b6 <putc>
 718:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71a:	00000b97          	auipc	s7,0x0
 71e:	5aeb8b93          	addi	s7,s7,1454 # cc8 <digits>
 722:	03c9d793          	srli	a5,s3,0x3c
 726:	97de                	add	a5,a5,s7
 728:	0007c583          	lbu	a1,0(a5)
 72c:	855a                	mv	a0,s6
 72e:	d89ff0ef          	jal	4b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 732:	0992                	slli	s3,s3,0x4
 734:	34fd                	addiw	s1,s1,-1
 736:	f4f5                	bnez	s1,722 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 738:	8be6                	mv	s7,s9
      state = 0;
 73a:	4981                	li	s3,0
 73c:	6ca2                	ld	s9,8(sp)
 73e:	bda5                	j	5b6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 740:	008b8493          	addi	s1,s7,8
 744:	000bc583          	lbu	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	d6dff0ef          	jal	4b6 <putc>
 74e:	8ba6                	mv	s7,s1
      state = 0;
 750:	4981                	li	s3,0
 752:	b595                	j	5b6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 754:	008b8993          	addi	s3,s7,8
 758:	000bb483          	ld	s1,0(s7)
 75c:	cc91                	beqz	s1,778 <vprintf+0x206>
        for(; *s; s++)
 75e:	0004c583          	lbu	a1,0(s1)
 762:	c985                	beqz	a1,792 <vprintf+0x220>
          putc(fd, *s);
 764:	855a                	mv	a0,s6
 766:	d51ff0ef          	jal	4b6 <putc>
        for(; *s; s++)
 76a:	0485                	addi	s1,s1,1
 76c:	0004c583          	lbu	a1,0(s1)
 770:	f9f5                	bnez	a1,764 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 772:	8bce                	mv	s7,s3
      state = 0;
 774:	4981                	li	s3,0
 776:	b581                	j	5b6 <vprintf+0x44>
          s = "(null)";
 778:	00000497          	auipc	s1,0x0
 77c:	54848493          	addi	s1,s1,1352 # cc0 <malloc+0x3ac>
        for(; *s; s++)
 780:	02800593          	li	a1,40
 784:	b7c5                	j	764 <vprintf+0x1f2>
        putc(fd, '%');
 786:	85be                	mv	a1,a5
 788:	855a                	mv	a0,s6
 78a:	d2dff0ef          	jal	4b6 <putc>
      state = 0;
 78e:	4981                	li	s3,0
 790:	b51d                	j	5b6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 792:	8bce                	mv	s7,s3
      state = 0;
 794:	4981                	li	s3,0
 796:	b505                	j	5b6 <vprintf+0x44>
 798:	6906                	ld	s2,64(sp)
 79a:	79e2                	ld	s3,56(sp)
 79c:	7a42                	ld	s4,48(sp)
 79e:	7aa2                	ld	s5,40(sp)
 7a0:	7b02                	ld	s6,32(sp)
 7a2:	6be2                	ld	s7,24(sp)
 7a4:	6c42                	ld	s8,16(sp)
    }
  }
}
 7a6:	60e6                	ld	ra,88(sp)
 7a8:	6446                	ld	s0,80(sp)
 7aa:	64a6                	ld	s1,72(sp)
 7ac:	6125                	addi	sp,sp,96
 7ae:	8082                	ret
      if(c0 == 'd'){
 7b0:	06400713          	li	a4,100
 7b4:	e4e78fe3          	beq	a5,a4,612 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7b8:	f9478693          	addi	a3,a5,-108
 7bc:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7c0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7c2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7c4:	07500513          	li	a0,117
 7c8:	e8a78ce3          	beq	a5,a0,660 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7cc:	f8b60513          	addi	a0,a2,-117
 7d0:	e119                	bnez	a0,7d6 <vprintf+0x264>
 7d2:	ea0693e3          	bnez	a3,678 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7d6:	f8b58513          	addi	a0,a1,-117
 7da:	e119                	bnez	a0,7e0 <vprintf+0x26e>
 7dc:	ea071be3          	bnez	a4,692 <vprintf+0x120>
      } else if(c0 == 'x'){
 7e0:	07800513          	li	a0,120
 7e4:	eca784e3          	beq	a5,a0,6ac <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7e8:	f8860613          	addi	a2,a2,-120
 7ec:	e219                	bnez	a2,7f2 <vprintf+0x280>
 7ee:	ec069be3          	bnez	a3,6c4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7f2:	f8858593          	addi	a1,a1,-120
 7f6:	e199                	bnez	a1,7fc <vprintf+0x28a>
 7f8:	ee0713e3          	bnez	a4,6de <vprintf+0x16c>
      } else if(c0 == 'p'){
 7fc:	07000713          	li	a4,112
 800:	eee78ce3          	beq	a5,a4,6f8 <vprintf+0x186>
      } else if(c0 == 'c'){
 804:	06300713          	li	a4,99
 808:	f2e78ce3          	beq	a5,a4,740 <vprintf+0x1ce>
      } else if(c0 == 's'){
 80c:	07300713          	li	a4,115
 810:	f4e782e3          	beq	a5,a4,754 <vprintf+0x1e2>
      } else if(c0 == '%'){
 814:	02500713          	li	a4,37
 818:	f6e787e3          	beq	a5,a4,786 <vprintf+0x214>
        putc(fd, '%');
 81c:	02500593          	li	a1,37
 820:	855a                	mv	a0,s6
 822:	c95ff0ef          	jal	4b6 <putc>
        putc(fd, c0);
 826:	85a6                	mv	a1,s1
 828:	855a                	mv	a0,s6
 82a:	c8dff0ef          	jal	4b6 <putc>
      state = 0;
 82e:	4981                	li	s3,0
 830:	b359                	j	5b6 <vprintf+0x44>

0000000000000832 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 832:	715d                	addi	sp,sp,-80
 834:	ec06                	sd	ra,24(sp)
 836:	e822                	sd	s0,16(sp)
 838:	1000                	addi	s0,sp,32
 83a:	e010                	sd	a2,0(s0)
 83c:	e414                	sd	a3,8(s0)
 83e:	e818                	sd	a4,16(s0)
 840:	ec1c                	sd	a5,24(s0)
 842:	03043023          	sd	a6,32(s0)
 846:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84a:	8622                	mv	a2,s0
 84c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 850:	d23ff0ef          	jal	572 <vprintf>
}
 854:	60e2                	ld	ra,24(sp)
 856:	6442                	ld	s0,16(sp)
 858:	6161                	addi	sp,sp,80
 85a:	8082                	ret

000000000000085c <printf>:

void
printf(const char *fmt, ...)
{
 85c:	711d                	addi	sp,sp,-96
 85e:	ec06                	sd	ra,24(sp)
 860:	e822                	sd	s0,16(sp)
 862:	1000                	addi	s0,sp,32
 864:	e40c                	sd	a1,8(s0)
 866:	e810                	sd	a2,16(s0)
 868:	ec14                	sd	a3,24(s0)
 86a:	f018                	sd	a4,32(s0)
 86c:	f41c                	sd	a5,40(s0)
 86e:	03043823          	sd	a6,48(s0)
 872:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 876:	00840613          	addi	a2,s0,8
 87a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 87e:	85aa                	mv	a1,a0
 880:	4505                	li	a0,1
 882:	cf1ff0ef          	jal	572 <vprintf>
}
 886:	60e2                	ld	ra,24(sp)
 888:	6442                	ld	s0,16(sp)
 88a:	6125                	addi	sp,sp,96
 88c:	8082                	ret

000000000000088e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88e:	1141                	addi	sp,sp,-16
 890:	e406                	sd	ra,8(sp)
 892:	e022                	sd	s0,0(sp)
 894:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 896:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89a:	00000797          	auipc	a5,0x0
 89e:	7667b783          	ld	a5,1894(a5) # 1000 <freep>
 8a2:	a039                	j	8b0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	6398                	ld	a4,0(a5)
 8a6:	00e7e463          	bltu	a5,a4,8ae <free+0x20>
 8aa:	00e6ea63          	bltu	a3,a4,8be <free+0x30>
{
 8ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b0:	fed7fae3          	bgeu	a5,a3,8a4 <free+0x16>
 8b4:	6398                	ld	a4,0(a5)
 8b6:	00e6e463          	bltu	a3,a4,8be <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	fee7eae3          	bltu	a5,a4,8ae <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8be:	ff852583          	lw	a1,-8(a0)
 8c2:	6390                	ld	a2,0(a5)
 8c4:	02059813          	slli	a6,a1,0x20
 8c8:	01c85713          	srli	a4,a6,0x1c
 8cc:	9736                	add	a4,a4,a3
 8ce:	02e60563          	beq	a2,a4,8f8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8d2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8d6:	4790                	lw	a2,8(a5)
 8d8:	02061593          	slli	a1,a2,0x20
 8dc:	01c5d713          	srli	a4,a1,0x1c
 8e0:	973e                	add	a4,a4,a5
 8e2:	02e68263          	beq	a3,a4,906 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e8:	00000717          	auipc	a4,0x0
 8ec:	70f73c23          	sd	a5,1816(a4) # 1000 <freep>
}
 8f0:	60a2                	ld	ra,8(sp)
 8f2:	6402                	ld	s0,0(sp)
 8f4:	0141                	addi	sp,sp,16
 8f6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8f8:	4618                	lw	a4,8(a2)
 8fa:	9f2d                	addw	a4,a4,a1
 8fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	6310                	ld	a2,0(a4)
 904:	b7f9                	j	8d2 <free+0x44>
    p->s.size += bp->s.size;
 906:	ff852703          	lw	a4,-8(a0)
 90a:	9f31                	addw	a4,a4,a2
 90c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 90e:	ff053683          	ld	a3,-16(a0)
 912:	bfd1                	j	8e6 <free+0x58>

0000000000000914 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 914:	7139                	addi	sp,sp,-64
 916:	fc06                	sd	ra,56(sp)
 918:	f822                	sd	s0,48(sp)
 91a:	f04a                	sd	s2,32(sp)
 91c:	ec4e                	sd	s3,24(sp)
 91e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 920:	02051993          	slli	s3,a0,0x20
 924:	0209d993          	srli	s3,s3,0x20
 928:	09bd                	addi	s3,s3,15
 92a:	0049d993          	srli	s3,s3,0x4
 92e:	2985                	addiw	s3,s3,1
 930:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 932:	00000517          	auipc	a0,0x0
 936:	6ce53503          	ld	a0,1742(a0) # 1000 <freep>
 93a:	c905                	beqz	a0,96a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93e:	4798                	lw	a4,8(a5)
 940:	09377663          	bgeu	a4,s3,9cc <malloc+0xb8>
 944:	f426                	sd	s1,40(sp)
 946:	e852                	sd	s4,16(sp)
 948:	e456                	sd	s5,8(sp)
 94a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 94c:	8a4e                	mv	s4,s3
 94e:	6705                	lui	a4,0x1
 950:	00e9f363          	bgeu	s3,a4,956 <malloc+0x42>
 954:	6a05                	lui	s4,0x1
 956:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 95e:	00000497          	auipc	s1,0x0
 962:	6a248493          	addi	s1,s1,1698 # 1000 <freep>
  if(p == SBRK_ERROR)
 966:	5afd                	li	s5,-1
 968:	a83d                	j	9a6 <malloc+0x92>
 96a:	f426                	sd	s1,40(sp)
 96c:	e852                	sd	s4,16(sp)
 96e:	e456                	sd	s5,8(sp)
 970:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 972:	00000797          	auipc	a5,0x0
 976:	69e78793          	addi	a5,a5,1694 # 1010 <base>
 97a:	00000717          	auipc	a4,0x0
 97e:	68f73323          	sd	a5,1670(a4) # 1000 <freep>
 982:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 984:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 988:	b7d1                	j	94c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 98a:	6398                	ld	a4,0(a5)
 98c:	e118                	sd	a4,0(a0)
 98e:	a899                	j	9e4 <malloc+0xd0>
  hp->s.size = nu;
 990:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 994:	0541                	addi	a0,a0,16
 996:	ef9ff0ef          	jal	88e <free>
  return freep;
 99a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 99c:	c125                	beqz	a0,9fc <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a0:	4798                	lw	a4,8(a5)
 9a2:	03277163          	bgeu	a4,s2,9c4 <malloc+0xb0>
    if(p == freep)
 9a6:	6098                	ld	a4,0(s1)
 9a8:	853e                	mv	a0,a5
 9aa:	fef71ae3          	bne	a4,a5,99e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9ae:	8552                	mv	a0,s4
 9b0:	a0bff0ef          	jal	3ba <sbrk>
  if(p == SBRK_ERROR)
 9b4:	fd551ee3          	bne	a0,s5,990 <malloc+0x7c>
        return 0;
 9b8:	4501                	li	a0,0
 9ba:	74a2                	ld	s1,40(sp)
 9bc:	6a42                	ld	s4,16(sp)
 9be:	6aa2                	ld	s5,8(sp)
 9c0:	6b02                	ld	s6,0(sp)
 9c2:	a03d                	j	9f0 <malloc+0xdc>
 9c4:	74a2                	ld	s1,40(sp)
 9c6:	6a42                	ld	s4,16(sp)
 9c8:	6aa2                	ld	s5,8(sp)
 9ca:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9cc:	fae90fe3          	beq	s2,a4,98a <malloc+0x76>
        p->s.size -= nunits;
 9d0:	4137073b          	subw	a4,a4,s3
 9d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d6:	02071693          	slli	a3,a4,0x20
 9da:	01c6d713          	srli	a4,a3,0x1c
 9de:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9e4:	00000717          	auipc	a4,0x0
 9e8:	60a73e23          	sd	a0,1564(a4) # 1000 <freep>
      return (void*)(p + 1);
 9ec:	01078513          	addi	a0,a5,16
  }
}
 9f0:	70e2                	ld	ra,56(sp)
 9f2:	7442                	ld	s0,48(sp)
 9f4:	7902                	ld	s2,32(sp)
 9f6:	69e2                	ld	s3,24(sp)
 9f8:	6121                	addi	sp,sp,64
 9fa:	8082                	ret
 9fc:	74a2                	ld	s1,40(sp)
 9fe:	6a42                	ld	s4,16(sp)
 a00:	6aa2                	ld	s5,8(sp)
 a02:	6b02                	ld	s6,0(sp)
 a04:	b7f5                	j	9f0 <malloc+0xdc>
