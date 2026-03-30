
user/_adapt_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  printf("\n=== Adaptive Ticking / System Heartbeat Test ===\n");
   c:	00001517          	auipc	a0,0x1
  10:	96450513          	addi	a0,a0,-1692 # 970 <malloc+0xfe>
  14:	7a6000ef          	jal	7ba <printf>
  
  printf("\n[Test 1] Busy spin waiting for 20 ticks.\n");
  18:	00001517          	auipc	a0,0x1
  1c:	99050513          	addi	a0,a0,-1648 # 9a8 <malloc+0x136>
  20:	79a000ef          	jal	7ba <printf>
  printf("         Because a process is RUNNABLE, the system uses the FAST timer_interval.\n");
  24:	00001517          	auipc	a0,0x1
  28:	9b450513          	addi	a0,a0,-1612 # 9d8 <malloc+0x166>
  2c:	78e000ef          	jal	7ba <printf>
  int start = uptime();
  30:	3b4000ef          	jal	3e4 <uptime>
  34:	84aa                	mv	s1,a0
  while(uptime() - start < 20) {
  36:	494d                	li	s2,19
  38:	3ac000ef          	jal	3e4 <uptime>
  3c:	9d05                	subw	a0,a0,s1
  3e:	fea95de3          	bge	s2,a0,38 <main+0x38>
    // Busy loop keeps the CPU spinning, so chosen != 0 in the scheduler.
    // The timer will not stretch.
  }
  printf("         [Done] That took about 2 seconds wall-clock time.\n");
  42:	00001517          	auipc	a0,0x1
  46:	9ee50513          	addi	a0,a0,-1554 # a30 <malloc+0x1be>
  4a:	770000ef          	jal	7ba <printf>

  printf("\n[Test 2] Sleeping for 20 ticks.\n");
  4e:	00001517          	auipc	a0,0x1
  52:	a2250513          	addi	a0,a0,-1502 # a70 <malloc+0x1fe>
  56:	764000ef          	jal	7ba <printf>
  printf("         Because NO processes are RUNNABLE, the scheduler stretches the timer 10x.\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	a3e50513          	addi	a0,a0,-1474 # a98 <malloc+0x226>
  62:	758000ef          	jal	7ba <printf>
  printf("         You should notice this takes ~10x longer (roughly 20 seconds) in real life!\n");
  66:	00001517          	auipc	a0,0x1
  6a:	a8a50513          	addi	a0,a0,-1398 # af0 <malloc+0x27e>
  6e:	74c000ef          	jal	7ba <printf>
  
  // pause goes to SLEEPING state (this OS variant uses pause instead of sleep). 
  // The scheduler has chosen == 0. The system goes into low power wfi mode and stretches the timer.
  pause(20);
  72:	4551                	li	a0,20
  74:	368000ef          	jal	3dc <pause>
  
  printf("         [Done] Woke up! The CPU slumbered cleanly and saved energy.\n");
  78:	00001517          	auipc	a0,0x1
  7c:	ad050513          	addi	a0,a0,-1328 # b48 <malloc+0x2d6>
  80:	73a000ef          	jal	7ba <printf>
  printf("\n=== Test Finished ===\n\n");
  84:	00001517          	auipc	a0,0x1
  88:	b0c50513          	addi	a0,a0,-1268 # b90 <malloc+0x31e>
  8c:	72e000ef          	jal	7ba <printf>
  
  exit(0);
  90:	4501                	li	a0,0
  92:	2ba000ef          	jal	34c <exit>

0000000000000096 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  9e:	f63ff0ef          	jal	0 <main>
  exit(r);
  a2:	2aa000ef          	jal	34c <exit>

00000000000000a6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e406                	sd	ra,8(sp)
  aa:	e022                	sd	s0,0(sp)
  ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ae:	87aa                	mv	a5,a0
  b0:	0585                	addi	a1,a1,1
  b2:	0785                	addi	a5,a5,1
  b4:	fff5c703          	lbu	a4,-1(a1)
  b8:	fee78fa3          	sb	a4,-1(a5)
  bc:	fb75                	bnez	a4,b0 <strcpy+0xa>
    ;
  return os;
}
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cb91                	beqz	a5,e6 <strcmp+0x20>
  d4:	0005c703          	lbu	a4,0(a1)
  d8:	00f71763          	bne	a4,a5,e6 <strcmp+0x20>
    p++, q++;
  dc:	0505                	addi	a0,a0,1
  de:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	fbe5                	bnez	a5,d4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  e6:	0005c503          	lbu	a0,0(a1)
}
  ea:	40a7853b          	subw	a0,a5,a0
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strlen>:

uint
strlen(const char *s)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cf91                	beqz	a5,11e <strlen+0x28>
 104:	00150793          	addi	a5,a0,1
 108:	86be                	mv	a3,a5
 10a:	0785                	addi	a5,a5,1
 10c:	fff7c703          	lbu	a4,-1(a5)
 110:	ff65                	bnez	a4,108 <strlen+0x12>
 112:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret
  for(n = 0; s[n]; n++)
 11e:	4501                	li	a0,0
 120:	bfdd                	j	116 <strlen+0x20>

0000000000000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 12a:	ca19                	beqz	a2,140 <memset+0x1e>
 12c:	87aa                	mv	a5,a0
 12e:	1602                	slli	a2,a2,0x20
 130:	9201                	srli	a2,a2,0x20
 132:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 136:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 13a:	0785                	addi	a5,a5,1
 13c:	fee79de3          	bne	a5,a4,136 <memset+0x14>
  }
  return dst;
}
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf81                	beqz	a5,16c <strchr+0x24>
    if(*s == c)
 156:	00f58763          	beq	a1,a5,164 <strchr+0x1c>
  for(; *s; s++)
 15a:	0505                	addi	a0,a0,1
 15c:	00054783          	lbu	a5,0(a0)
 160:	fbfd                	bnez	a5,156 <strchr+0xe>
      return (char*)s;
  return 0;
 162:	4501                	li	a0,0
}
 164:	60a2                	ld	ra,8(sp)
 166:	6402                	ld	s0,0(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret
  return 0;
 16c:	4501                	li	a0,0
 16e:	bfdd                	j	164 <strchr+0x1c>

0000000000000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	711d                	addi	sp,sp,-96
 172:	ec86                	sd	ra,88(sp)
 174:	e8a2                	sd	s0,80(sp)
 176:	e4a6                	sd	s1,72(sp)
 178:	e0ca                	sd	s2,64(sp)
 17a:	fc4e                	sd	s3,56(sp)
 17c:	f852                	sd	s4,48(sp)
 17e:	f456                	sd	s5,40(sp)
 180:	f05a                	sd	s6,32(sp)
 182:	ec5e                	sd	s7,24(sp)
 184:	e862                	sd	s8,16(sp)
 186:	1080                	addi	s0,sp,96
 188:	8baa                	mv	s7,a0
 18a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18c:	892a                	mv	s2,a0
 18e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 190:	faf40b13          	addi	s6,s0,-81
 194:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 196:	8c26                	mv	s8,s1
 198:	0014899b          	addiw	s3,s1,1
 19c:	84ce                	mv	s1,s3
 19e:	0349d463          	bge	s3,s4,1c6 <gets+0x56>
    cc = read(0, &c, 1);
 1a2:	8656                	mv	a2,s5
 1a4:	85da                	mv	a1,s6
 1a6:	4501                	li	a0,0
 1a8:	1bc000ef          	jal	364 <read>
    if(cc < 1)
 1ac:	00a05d63          	blez	a0,1c6 <gets+0x56>
      break;
    buf[i++] = c;
 1b0:	faf44783          	lbu	a5,-81(s0)
 1b4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b8:	0905                	addi	s2,s2,1
 1ba:	ff678713          	addi	a4,a5,-10
 1be:	c319                	beqz	a4,1c4 <gets+0x54>
 1c0:	17cd                	addi	a5,a5,-13
 1c2:	fbf1                	bnez	a5,196 <gets+0x26>
    buf[i++] = c;
 1c4:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1c6:	9c5e                	add	s8,s8,s7
 1c8:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1cc:	855e                	mv	a0,s7
 1ce:	60e6                	ld	ra,88(sp)
 1d0:	6446                	ld	s0,80(sp)
 1d2:	64a6                	ld	s1,72(sp)
 1d4:	6906                	ld	s2,64(sp)
 1d6:	79e2                	ld	s3,56(sp)
 1d8:	7a42                	ld	s4,48(sp)
 1da:	7aa2                	ld	s5,40(sp)
 1dc:	7b02                	ld	s6,32(sp)
 1de:	6be2                	ld	s7,24(sp)
 1e0:	6c42                	ld	s8,16(sp)
 1e2:	6125                	addi	sp,sp,96
 1e4:	8082                	ret

00000000000001e6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e6:	1101                	addi	sp,sp,-32
 1e8:	ec06                	sd	ra,24(sp)
 1ea:	e822                	sd	s0,16(sp)
 1ec:	e04a                	sd	s2,0(sp)
 1ee:	1000                	addi	s0,sp,32
 1f0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	4581                	li	a1,0
 1f4:	198000ef          	jal	38c <open>
  if(fd < 0)
 1f8:	02054263          	bltz	a0,21c <stat+0x36>
 1fc:	e426                	sd	s1,8(sp)
 1fe:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 200:	85ca                	mv	a1,s2
 202:	1a2000ef          	jal	3a4 <fstat>
 206:	892a                	mv	s2,a0
  close(fd);
 208:	8526                	mv	a0,s1
 20a:	16a000ef          	jal	374 <close>
  return r;
 20e:	64a2                	ld	s1,8(sp)
}
 210:	854a                	mv	a0,s2
 212:	60e2                	ld	ra,24(sp)
 214:	6442                	ld	s0,16(sp)
 216:	6902                	ld	s2,0(sp)
 218:	6105                	addi	sp,sp,32
 21a:	8082                	ret
    return -1;
 21c:	57fd                	li	a5,-1
 21e:	893e                	mv	s2,a5
 220:	bfc5                	j	210 <stat+0x2a>

0000000000000222 <atoi>:

int
atoi(const char *s)
{
 222:	1141                	addi	sp,sp,-16
 224:	e406                	sd	ra,8(sp)
 226:	e022                	sd	s0,0(sp)
 228:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22a:	00054683          	lbu	a3,0(a0)
 22e:	fd06879b          	addiw	a5,a3,-48
 232:	0ff7f793          	zext.b	a5,a5
 236:	4625                	li	a2,9
 238:	02f66963          	bltu	a2,a5,26a <atoi+0x48>
 23c:	872a                	mv	a4,a0
  n = 0;
 23e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 240:	0705                	addi	a4,a4,1
 242:	0025179b          	slliw	a5,a0,0x2
 246:	9fa9                	addw	a5,a5,a0
 248:	0017979b          	slliw	a5,a5,0x1
 24c:	9fb5                	addw	a5,a5,a3
 24e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 252:	00074683          	lbu	a3,0(a4)
 256:	fd06879b          	addiw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	fef671e3          	bgeu	a2,a5,240 <atoi+0x1e>
  return n;
}
 262:	60a2                	ld	ra,8(sp)
 264:	6402                	ld	s0,0(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
  n = 0;
 26a:	4501                	li	a0,0
 26c:	bfdd                	j	262 <atoi+0x40>

000000000000026e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 276:	02b57563          	bgeu	a0,a1,2a0 <memmove+0x32>
    while(n-- > 0)
 27a:	00c05f63          	blez	a2,298 <memmove+0x2a>
 27e:	1602                	slli	a2,a2,0x20
 280:	9201                	srli	a2,a2,0x20
 282:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 286:	872a                	mv	a4,a0
      *dst++ = *src++;
 288:	0585                	addi	a1,a1,1
 28a:	0705                	addi	a4,a4,1
 28c:	fff5c683          	lbu	a3,-1(a1)
 290:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 294:	fee79ae3          	bne	a5,a4,288 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
    while(n-- > 0)
 2a0:	fec05ce3          	blez	a2,298 <memmove+0x2a>
    dst += n;
 2a4:	00c50733          	add	a4,a0,a2
    src += n;
 2a8:	95b2                	add	a1,a1,a2
 2aa:	fff6079b          	addiw	a5,a2,-1
 2ae:	1782                	slli	a5,a5,0x20
 2b0:	9381                	srli	a5,a5,0x20
 2b2:	fff7c793          	not	a5,a5
 2b6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b8:	15fd                	addi	a1,a1,-1
 2ba:	177d                	addi	a4,a4,-1
 2bc:	0005c683          	lbu	a3,0(a1)
 2c0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c4:	fef71ae3          	bne	a4,a5,2b8 <memmove+0x4a>
 2c8:	bfc1                	j	298 <memmove+0x2a>

00000000000002ca <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d2:	c61d                	beqz	a2,300 <memcmp+0x36>
 2d4:	1602                	slli	a2,a2,0x20
 2d6:	9201                	srli	a2,a2,0x20
 2d8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	0005c703          	lbu	a4,0(a1)
 2e4:	00e79863          	bne	a5,a4,2f4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2e8:	0505                	addi	a0,a0,1
    p2++;
 2ea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ec:	fed518e3          	bne	a0,a3,2dc <memcmp+0x12>
  }
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	a019                	j	2f8 <memcmp+0x2e>
      return *p1 - *p2;
 2f4:	40e7853b          	subw	a0,a5,a4
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
  return 0;
 300:	4501                	li	a0,0
 302:	bfdd                	j	2f8 <memcmp+0x2e>

0000000000000304 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30c:	f63ff0ef          	jal	26e <memmove>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <sbrk>:

char *
sbrk(int n) {
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 320:	4585                	li	a1,1
 322:	0b2000ef          	jal	3d4 <sys_sbrk>
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <sbrklazy>:

char *
sbrklazy(int n) {
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 336:	4589                	li	a1,2
 338:	09c000ef          	jal	3d4 <sys_sbrk>
}
 33c:	60a2                	ld	ra,8(sp)
 33e:	6402                	ld	s0,0(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret

0000000000000344 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 344:	4885                	li	a7,1
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exit>:
.global exit
exit:
 li a7, SYS_exit
 34c:	4889                	li	a7,2
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <wait>:
.global wait
wait:
 li a7, SYS_wait
 354:	488d                	li	a7,3
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35c:	4891                	li	a7,4
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <read>:
.global read
read:
 li a7, SYS_read
 364:	4895                	li	a7,5
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <write>:
.global write
write:
 li a7, SYS_write
 36c:	48c1                	li	a7,16
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <close>:
.global close
close:
 li a7, SYS_close
 374:	48d5                	li	a7,21
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <kill>:
.global kill
kill:
 li a7, SYS_kill
 37c:	4899                	li	a7,6
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <exec>:
.global exec
exec:
 li a7, SYS_exec
 384:	489d                	li	a7,7
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <open>:
.global open
open:
 li a7, SYS_open
 38c:	48bd                	li	a7,15
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 394:	48c5                	li	a7,17
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39c:	48c9                	li	a7,18
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a4:	48a1                	li	a7,8
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <link>:
.global link
link:
 li a7, SYS_link
 3ac:	48cd                	li	a7,19
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b4:	48d1                	li	a7,20
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3bc:	48a5                	li	a7,9
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c4:	48a9                	li	a7,10
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3cc:	48ad                	li	a7,11
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3d4:	48b1                	li	a7,12
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <pause>:
.global pause
pause:
 li a7, SYS_pause
 3dc:	48b5                	li	a7,13
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e4:	48b9                	li	a7,14
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <kps>:
.global kps
kps:
 li a7, SYS_kps
 3ec:	48d9                	li	a7,22
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 3f4:	48dd                	li	a7,23
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 3fc:	48e1                	li	a7,24
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 404:	48e5                	li	a7,25
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 40c:	48e9                	li	a7,26
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 414:	1101                	addi	sp,sp,-32
 416:	ec06                	sd	ra,24(sp)
 418:	e822                	sd	s0,16(sp)
 41a:	1000                	addi	s0,sp,32
 41c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 420:	4605                	li	a2,1
 422:	fef40593          	addi	a1,s0,-17
 426:	f47ff0ef          	jal	36c <write>
}
 42a:	60e2                	ld	ra,24(sp)
 42c:	6442                	ld	s0,16(sp)
 42e:	6105                	addi	sp,sp,32
 430:	8082                	ret

0000000000000432 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 432:	715d                	addi	sp,sp,-80
 434:	e486                	sd	ra,72(sp)
 436:	e0a2                	sd	s0,64(sp)
 438:	f84a                	sd	s2,48(sp)
 43a:	f44e                	sd	s3,40(sp)
 43c:	0880                	addi	s0,sp,80
 43e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 440:	c6d1                	beqz	a3,4cc <printint+0x9a>
 442:	0805d563          	bgez	a1,4cc <printint+0x9a>
    neg = 1;
    x = -xx;
 446:	40b005b3          	neg	a1,a1
    neg = 1;
 44a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 44c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 450:	86ce                	mv	a3,s3
  i = 0;
 452:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 454:	00000817          	auipc	a6,0x0
 458:	76480813          	addi	a6,a6,1892 # bb8 <digits>
 45c:	88ba                	mv	a7,a4
 45e:	0017051b          	addiw	a0,a4,1
 462:	872a                	mv	a4,a0
 464:	02c5f7b3          	remu	a5,a1,a2
 468:	97c2                	add	a5,a5,a6
 46a:	0007c783          	lbu	a5,0(a5)
 46e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 472:	87ae                	mv	a5,a1
 474:	02c5d5b3          	divu	a1,a1,a2
 478:	0685                	addi	a3,a3,1
 47a:	fec7f1e3          	bgeu	a5,a2,45c <printint+0x2a>
  if(neg)
 47e:	00030c63          	beqz	t1,496 <printint+0x64>
    buf[i++] = '-';
 482:	fd050793          	addi	a5,a0,-48
 486:	00878533          	add	a0,a5,s0
 48a:	02d00793          	li	a5,45
 48e:	fef50423          	sb	a5,-24(a0)
 492:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 496:	02e05563          	blez	a4,4c0 <printint+0x8e>
 49a:	fc26                	sd	s1,56(sp)
 49c:	377d                	addiw	a4,a4,-1
 49e:	00e984b3          	add	s1,s3,a4
 4a2:	19fd                	addi	s3,s3,-1
 4a4:	99ba                	add	s3,s3,a4
 4a6:	1702                	slli	a4,a4,0x20
 4a8:	9301                	srli	a4,a4,0x20
 4aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ae:	0004c583          	lbu	a1,0(s1)
 4b2:	854a                	mv	a0,s2
 4b4:	f61ff0ef          	jal	414 <putc>
  while(--i >= 0)
 4b8:	14fd                	addi	s1,s1,-1
 4ba:	ff349ae3          	bne	s1,s3,4ae <printint+0x7c>
 4be:	74e2                	ld	s1,56(sp)
}
 4c0:	60a6                	ld	ra,72(sp)
 4c2:	6406                	ld	s0,64(sp)
 4c4:	7942                	ld	s2,48(sp)
 4c6:	79a2                	ld	s3,40(sp)
 4c8:	6161                	addi	sp,sp,80
 4ca:	8082                	ret
  neg = 0;
 4cc:	4301                	li	t1,0
 4ce:	bfbd                	j	44c <printint+0x1a>

00000000000004d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d0:	711d                	addi	sp,sp,-96
 4d2:	ec86                	sd	ra,88(sp)
 4d4:	e8a2                	sd	s0,80(sp)
 4d6:	e4a6                	sd	s1,72(sp)
 4d8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4da:	0005c483          	lbu	s1,0(a1)
 4de:	22048363          	beqz	s1,704 <vprintf+0x234>
 4e2:	e0ca                	sd	s2,64(sp)
 4e4:	fc4e                	sd	s3,56(sp)
 4e6:	f852                	sd	s4,48(sp)
 4e8:	f456                	sd	s5,40(sp)
 4ea:	f05a                	sd	s6,32(sp)
 4ec:	ec5e                	sd	s7,24(sp)
 4ee:	e862                	sd	s8,16(sp)
 4f0:	8b2a                	mv	s6,a0
 4f2:	8a2e                	mv	s4,a1
 4f4:	8bb2                	mv	s7,a2
  state = 0;
 4f6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4f8:	4901                	li	s2,0
 4fa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4fc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 500:	06400c13          	li	s8,100
 504:	a00d                	j	526 <vprintf+0x56>
        putc(fd, c0);
 506:	85a6                	mv	a1,s1
 508:	855a                	mv	a0,s6
 50a:	f0bff0ef          	jal	414 <putc>
 50e:	a019                	j	514 <vprintf+0x44>
    } else if(state == '%'){
 510:	03598363          	beq	s3,s5,536 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 514:	0019079b          	addiw	a5,s2,1
 518:	893e                	mv	s2,a5
 51a:	873e                	mv	a4,a5
 51c:	97d2                	add	a5,a5,s4
 51e:	0007c483          	lbu	s1,0(a5)
 522:	1c048a63          	beqz	s1,6f6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 526:	0004879b          	sext.w	a5,s1
    if(state == 0){
 52a:	fe0993e3          	bnez	s3,510 <vprintf+0x40>
      if(c0 == '%'){
 52e:	fd579ce3          	bne	a5,s5,506 <vprintf+0x36>
        state = '%';
 532:	89be                	mv	s3,a5
 534:	b7c5                	j	514 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 536:	00ea06b3          	add	a3,s4,a4
 53a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 53e:	1c060863          	beqz	a2,70e <vprintf+0x23e>
      if(c0 == 'd'){
 542:	03878763          	beq	a5,s8,570 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 546:	f9478693          	addi	a3,a5,-108
 54a:	0016b693          	seqz	a3,a3
 54e:	f9c60593          	addi	a1,a2,-100
 552:	e99d                	bnez	a1,588 <vprintf+0xb8>
 554:	ca95                	beqz	a3,588 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 556:	008b8493          	addi	s1,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000bb583          	ld	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	ecfff0ef          	jal	432 <printint>
        i += 1;
 568:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 56c:	4981                	li	s3,0
 56e:	b75d                	j	514 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 570:	008b8493          	addi	s1,s7,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	eb5ff0ef          	jal	432 <printint>
 582:	8ba6                	mv	s7,s1
      state = 0;
 584:	4981                	li	s3,0
 586:	b779                	j	514 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 588:	9752                	add	a4,a4,s4
 58a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 58e:	f9460713          	addi	a4,a2,-108
 592:	00173713          	seqz	a4,a4
 596:	8f75                	and	a4,a4,a3
 598:	f9c58513          	addi	a0,a1,-100
 59c:	18051363          	bnez	a0,722 <vprintf+0x252>
 5a0:	18070163          	beqz	a4,722 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000bb583          	ld	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e81ff0ef          	jal	432 <printint>
        i += 2;
 5b6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b8:	8ba6                	mv	s7,s1
      state = 0;
 5ba:	4981                	li	s3,0
        i += 2;
 5bc:	bfa1                	j	514 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4629                	li	a2,10
 5c6:	000be583          	lwu	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e67ff0ef          	jal	432 <printint>
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b781                	j	514 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e4fff0ef          	jal	432 <printint>
        i += 1;
 5e8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b71d                	j	514 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4629                	li	a2,10
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e35ff0ef          	jal	432 <printint>
        i += 2;
 602:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 604:	8ba6                	mv	s7,s1
      state = 0;
 606:	4981                	li	s3,0
        i += 2;
 608:	b731                	j	514 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4681                	li	a3,0
 610:	4641                	li	a2,16
 612:	000be583          	lwu	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e1bff0ef          	jal	432 <printint>
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	bdd5                	j	514 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e03ff0ef          	jal	432 <printint>
        i += 1;
 634:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
 63a:	bde9                	j	514 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4681                	li	a3,0
 642:	4641                	li	a2,16
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	de9ff0ef          	jal	432 <printint>
        i += 2;
 64e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	b5c1                	j	514 <vprintf+0x44>
 656:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 658:	008b8793          	addi	a5,s7,8
 65c:	8cbe                	mv	s9,a5
 65e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 662:	03000593          	li	a1,48
 666:	855a                	mv	a0,s6
 668:	dadff0ef          	jal	414 <putc>
  putc(fd, 'x');
 66c:	07800593          	li	a1,120
 670:	855a                	mv	a0,s6
 672:	da3ff0ef          	jal	414 <putc>
 676:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 678:	00000b97          	auipc	s7,0x0
 67c:	540b8b93          	addi	s7,s7,1344 # bb8 <digits>
 680:	03c9d793          	srli	a5,s3,0x3c
 684:	97de                	add	a5,a5,s7
 686:	0007c583          	lbu	a1,0(a5)
 68a:	855a                	mv	a0,s6
 68c:	d89ff0ef          	jal	414 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 690:	0992                	slli	s3,s3,0x4
 692:	34fd                	addiw	s1,s1,-1
 694:	f4f5                	bnez	s1,680 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 696:	8be6                	mv	s7,s9
      state = 0;
 698:	4981                	li	s3,0
 69a:	6ca2                	ld	s9,8(sp)
 69c:	bda5                	j	514 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 69e:	008b8493          	addi	s1,s7,8
 6a2:	000bc583          	lbu	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	d6dff0ef          	jal	414 <putc>
 6ac:	8ba6                	mv	s7,s1
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b595                	j	514 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6b2:	008b8993          	addi	s3,s7,8
 6b6:	000bb483          	ld	s1,0(s7)
 6ba:	cc91                	beqz	s1,6d6 <vprintf+0x206>
        for(; *s; s++)
 6bc:	0004c583          	lbu	a1,0(s1)
 6c0:	c985                	beqz	a1,6f0 <vprintf+0x220>
          putc(fd, *s);
 6c2:	855a                	mv	a0,s6
 6c4:	d51ff0ef          	jal	414 <putc>
        for(; *s; s++)
 6c8:	0485                	addi	s1,s1,1
 6ca:	0004c583          	lbu	a1,0(s1)
 6ce:	f9f5                	bnez	a1,6c2 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b581                	j	514 <vprintf+0x44>
          s = "(null)";
 6d6:	00000497          	auipc	s1,0x0
 6da:	4da48493          	addi	s1,s1,1242 # bb0 <malloc+0x33e>
        for(; *s; s++)
 6de:	02800593          	li	a1,40
 6e2:	b7c5                	j	6c2 <vprintf+0x1f2>
        putc(fd, '%');
 6e4:	85be                	mv	a1,a5
 6e6:	855a                	mv	a0,s6
 6e8:	d2dff0ef          	jal	414 <putc>
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b51d                	j	514 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6f0:	8bce                	mv	s7,s3
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b505                	j	514 <vprintf+0x44>
 6f6:	6906                	ld	s2,64(sp)
 6f8:	79e2                	ld	s3,56(sp)
 6fa:	7a42                	ld	s4,48(sp)
 6fc:	7aa2                	ld	s5,40(sp)
 6fe:	7b02                	ld	s6,32(sp)
 700:	6be2                	ld	s7,24(sp)
 702:	6c42                	ld	s8,16(sp)
    }
  }
}
 704:	60e6                	ld	ra,88(sp)
 706:	6446                	ld	s0,80(sp)
 708:	64a6                	ld	s1,72(sp)
 70a:	6125                	addi	sp,sp,96
 70c:	8082                	ret
      if(c0 == 'd'){
 70e:	06400713          	li	a4,100
 712:	e4e78fe3          	beq	a5,a4,570 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 716:	f9478693          	addi	a3,a5,-108
 71a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 71e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 720:	4701                	li	a4,0
      } else if(c0 == 'u'){
 722:	07500513          	li	a0,117
 726:	e8a78ce3          	beq	a5,a0,5be <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 72a:	f8b60513          	addi	a0,a2,-117
 72e:	e119                	bnez	a0,734 <vprintf+0x264>
 730:	ea0693e3          	bnez	a3,5d6 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 734:	f8b58513          	addi	a0,a1,-117
 738:	e119                	bnez	a0,73e <vprintf+0x26e>
 73a:	ea071be3          	bnez	a4,5f0 <vprintf+0x120>
      } else if(c0 == 'x'){
 73e:	07800513          	li	a0,120
 742:	eca784e3          	beq	a5,a0,60a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 746:	f8860613          	addi	a2,a2,-120
 74a:	e219                	bnez	a2,750 <vprintf+0x280>
 74c:	ec069be3          	bnez	a3,622 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 750:	f8858593          	addi	a1,a1,-120
 754:	e199                	bnez	a1,75a <vprintf+0x28a>
 756:	ee0713e3          	bnez	a4,63c <vprintf+0x16c>
      } else if(c0 == 'p'){
 75a:	07000713          	li	a4,112
 75e:	eee78ce3          	beq	a5,a4,656 <vprintf+0x186>
      } else if(c0 == 'c'){
 762:	06300713          	li	a4,99
 766:	f2e78ce3          	beq	a5,a4,69e <vprintf+0x1ce>
      } else if(c0 == 's'){
 76a:	07300713          	li	a4,115
 76e:	f4e782e3          	beq	a5,a4,6b2 <vprintf+0x1e2>
      } else if(c0 == '%'){
 772:	02500713          	li	a4,37
 776:	f6e787e3          	beq	a5,a4,6e4 <vprintf+0x214>
        putc(fd, '%');
 77a:	02500593          	li	a1,37
 77e:	855a                	mv	a0,s6
 780:	c95ff0ef          	jal	414 <putc>
        putc(fd, c0);
 784:	85a6                	mv	a1,s1
 786:	855a                	mv	a0,s6
 788:	c8dff0ef          	jal	414 <putc>
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b359                	j	514 <vprintf+0x44>

0000000000000790 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 790:	715d                	addi	sp,sp,-80
 792:	ec06                	sd	ra,24(sp)
 794:	e822                	sd	s0,16(sp)
 796:	1000                	addi	s0,sp,32
 798:	e010                	sd	a2,0(s0)
 79a:	e414                	sd	a3,8(s0)
 79c:	e818                	sd	a4,16(s0)
 79e:	ec1c                	sd	a5,24(s0)
 7a0:	03043023          	sd	a6,32(s0)
 7a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a8:	8622                	mv	a2,s0
 7aa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ae:	d23ff0ef          	jal	4d0 <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6161                	addi	sp,sp,80
 7b8:	8082                	ret

00000000000007ba <printf>:

void
printf(const char *fmt, ...)
{
 7ba:	711d                	addi	sp,sp,-96
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	addi	s0,sp,32
 7c2:	e40c                	sd	a1,8(s0)
 7c4:	e810                	sd	a2,16(s0)
 7c6:	ec14                	sd	a3,24(s0)
 7c8:	f018                	sd	a4,32(s0)
 7ca:	f41c                	sd	a5,40(s0)
 7cc:	03043823          	sd	a6,48(s0)
 7d0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d4:	00840613          	addi	a2,s0,8
 7d8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7dc:	85aa                	mv	a1,a0
 7de:	4505                	li	a0,1
 7e0:	cf1ff0ef          	jal	4d0 <vprintf>
}
 7e4:	60e2                	ld	ra,24(sp)
 7e6:	6442                	ld	s0,16(sp)
 7e8:	6125                	addi	sp,sp,96
 7ea:	8082                	ret

00000000000007ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ec:	1141                	addi	sp,sp,-16
 7ee:	e406                	sd	ra,8(sp)
 7f0:	e022                	sd	s0,0(sp)
 7f2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f8:	00001797          	auipc	a5,0x1
 7fc:	8087b783          	ld	a5,-2040(a5) # 1000 <freep>
 800:	a039                	j	80e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	6398                	ld	a4,0(a5)
 804:	00e7e463          	bltu	a5,a4,80c <free+0x20>
 808:	00e6ea63          	bltu	a3,a4,81c <free+0x30>
{
 80c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80e:	fed7fae3          	bgeu	a5,a3,802 <free+0x16>
 812:	6398                	ld	a4,0(a5)
 814:	00e6e463          	bltu	a3,a4,81c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	fee7eae3          	bltu	a5,a4,80c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 81c:	ff852583          	lw	a1,-8(a0)
 820:	6390                	ld	a2,0(a5)
 822:	02059813          	slli	a6,a1,0x20
 826:	01c85713          	srli	a4,a6,0x1c
 82a:	9736                	add	a4,a4,a3
 82c:	02e60563          	beq	a2,a4,856 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 834:	4790                	lw	a2,8(a5)
 836:	02061593          	slli	a1,a2,0x20
 83a:	01c5d713          	srli	a4,a1,0x1c
 83e:	973e                	add	a4,a4,a5
 840:	02e68263          	beq	a3,a4,864 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 844:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 846:	00000717          	auipc	a4,0x0
 84a:	7af73d23          	sd	a5,1978(a4) # 1000 <freep>
}
 84e:	60a2                	ld	ra,8(sp)
 850:	6402                	ld	s0,0(sp)
 852:	0141                	addi	sp,sp,16
 854:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 856:	4618                	lw	a4,8(a2)
 858:	9f2d                	addw	a4,a4,a1
 85a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 85e:	6398                	ld	a4,0(a5)
 860:	6310                	ld	a2,0(a4)
 862:	b7f9                	j	830 <free+0x44>
    p->s.size += bp->s.size;
 864:	ff852703          	lw	a4,-8(a0)
 868:	9f31                	addw	a4,a4,a2
 86a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 86c:	ff053683          	ld	a3,-16(a0)
 870:	bfd1                	j	844 <free+0x58>

0000000000000872 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 872:	7139                	addi	sp,sp,-64
 874:	fc06                	sd	ra,56(sp)
 876:	f822                	sd	s0,48(sp)
 878:	f04a                	sd	s2,32(sp)
 87a:	ec4e                	sd	s3,24(sp)
 87c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87e:	02051993          	slli	s3,a0,0x20
 882:	0209d993          	srli	s3,s3,0x20
 886:	09bd                	addi	s3,s3,15
 888:	0049d993          	srli	s3,s3,0x4
 88c:	2985                	addiw	s3,s3,1
 88e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 890:	00000517          	auipc	a0,0x0
 894:	77053503          	ld	a0,1904(a0) # 1000 <freep>
 898:	c905                	beqz	a0,8c8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	09377663          	bgeu	a4,s3,92a <malloc+0xb8>
 8a2:	f426                	sd	s1,40(sp)
 8a4:	e852                	sd	s4,16(sp)
 8a6:	e456                	sd	s5,8(sp)
 8a8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8aa:	8a4e                	mv	s4,s3
 8ac:	6705                	lui	a4,0x1
 8ae:	00e9f363          	bgeu	s3,a4,8b4 <malloc+0x42>
 8b2:	6a05                	lui	s4,0x1
 8b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8bc:	00000497          	auipc	s1,0x0
 8c0:	74448493          	addi	s1,s1,1860 # 1000 <freep>
  if(p == SBRK_ERROR)
 8c4:	5afd                	li	s5,-1
 8c6:	a83d                	j	904 <malloc+0x92>
 8c8:	f426                	sd	s1,40(sp)
 8ca:	e852                	sd	s4,16(sp)
 8cc:	e456                	sd	s5,8(sp)
 8ce:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d0:	00000797          	auipc	a5,0x0
 8d4:	74078793          	addi	a5,a5,1856 # 1010 <base>
 8d8:	00000717          	auipc	a4,0x0
 8dc:	72f73423          	sd	a5,1832(a4) # 1000 <freep>
 8e0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e6:	b7d1                	j	8aa <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8e8:	6398                	ld	a4,0(a5)
 8ea:	e118                	sd	a4,0(a0)
 8ec:	a899                	j	942 <malloc+0xd0>
  hp->s.size = nu;
 8ee:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f2:	0541                	addi	a0,a0,16
 8f4:	ef9ff0ef          	jal	7ec <free>
  return freep;
 8f8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8fa:	c125                	beqz	a0,95a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fe:	4798                	lw	a4,8(a5)
 900:	03277163          	bgeu	a4,s2,922 <malloc+0xb0>
    if(p == freep)
 904:	6098                	ld	a4,0(s1)
 906:	853e                	mv	a0,a5
 908:	fef71ae3          	bne	a4,a5,8fc <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 90c:	8552                	mv	a0,s4
 90e:	a0bff0ef          	jal	318 <sbrk>
  if(p == SBRK_ERROR)
 912:	fd551ee3          	bne	a0,s5,8ee <malloc+0x7c>
        return 0;
 916:	4501                	li	a0,0
 918:	74a2                	ld	s1,40(sp)
 91a:	6a42                	ld	s4,16(sp)
 91c:	6aa2                	ld	s5,8(sp)
 91e:	6b02                	ld	s6,0(sp)
 920:	a03d                	j	94e <malloc+0xdc>
 922:	74a2                	ld	s1,40(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 92a:	fae90fe3          	beq	s2,a4,8e8 <malloc+0x76>
        p->s.size -= nunits;
 92e:	4137073b          	subw	a4,a4,s3
 932:	c798                	sw	a4,8(a5)
        p += p->s.size;
 934:	02071693          	slli	a3,a4,0x20
 938:	01c6d713          	srli	a4,a3,0x1c
 93c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 942:	00000717          	auipc	a4,0x0
 946:	6aa73f23          	sd	a0,1726(a4) # 1000 <freep>
      return (void*)(p + 1);
 94a:	01078513          	addi	a0,a5,16
  }
}
 94e:	70e2                	ld	ra,56(sp)
 950:	7442                	ld	s0,48(sp)
 952:	7902                	ld	s2,32(sp)
 954:	69e2                	ld	s3,24(sp)
 956:	6121                	addi	sp,sp,64
 958:	8082                	ret
 95a:	74a2                	ld	s1,40(sp)
 95c:	6a42                	ld	s4,16(sp)
 95e:	6aa2                	ld	s5,8(sp)
 960:	6b02                	ld	s6,0(sp)
 962:	b7f5                	j	94e <malloc+0xdc>
