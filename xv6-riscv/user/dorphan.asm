
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	95450513          	addi	a0,a0,-1708 # 960 <malloc+0xf8>
  14:	396000ef          	jal	3aa <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	94c50513          	addi	a0,a0,-1716 # 968 <malloc+0x100>
  24:	78c000ef          	jal	7b0 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	318000ef          	jal	342 <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	93250513          	addi	a0,a0,-1742 # 960 <malloc+0xf8>
  36:	37c000ef          	jal	3b2 <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	94250513          	addi	a0,a0,-1726 # 980 <malloc+0x118>
  46:	76a000ef          	jal	7b0 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2f6000ef          	jal	342 <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	94850513          	addi	a0,a0,-1720 # 998 <malloc+0x130>
  58:	33a000ef          	jal	392 <unlink>
  5c:	00054e63          	bltz	a0,78 <main+0x78>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	95850513          	addi	a0,a0,-1704 # 9b8 <malloc+0x150>
  68:	748000ef          	jal	7b0 <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800493          	li	s1,1000
  70:	8526                	mv	a0,s1
  72:	360000ef          	jal	3d2 <pause>
  76:	bfed                	j	70 <main+0x70>
    printf("%s: unlink failed\n", s);
  78:	85a6                	mv	a1,s1
  7a:	00001517          	auipc	a0,0x1
  7e:	92650513          	addi	a0,a0,-1754 # 9a0 <malloc+0x138>
  82:	72e000ef          	jal	7b0 <printf>
    exit(1);
  86:	4505                	li	a0,1
  88:	2ba000ef          	jal	342 <exit>

000000000000008c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  94:	f6dff0ef          	jal	0 <main>
  exit(r);
  98:	2aa000ef          	jal	342 <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0xa>
    ;
  return os;
}
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb91                	beqz	a5,dc <strcmp+0x20>
  ca:	0005c703          	lbu	a4,0(a1)
  ce:	00f71763          	bne	a4,a5,dc <strcmp+0x20>
    p++, q++;
  d2:	0505                	addi	a0,a0,1
  d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbe5                	bnez	a5,ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  dc:	0005c503          	lbu	a0,0(a1)
}
  e0:	40a7853b          	subw	a0,a5,a0
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strlen>:

uint
strlen(const char *s)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cf91                	beqz	a5,114 <strlen+0x28>
  fa:	00150793          	addi	a5,a0,1
  fe:	86be                	mv	a3,a5
 100:	0785                	addi	a5,a5,1
 102:	fff7c703          	lbu	a4,-1(a5)
 106:	ff65                	bnez	a4,fe <strlen+0x12>
 108:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 10c:	60a2                	ld	ra,8(sp)
 10e:	6402                	ld	s0,0(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  for(n = 0; s[n]; n++)
 114:	4501                	li	a0,0
 116:	bfdd                	j	10c <strlen+0x20>

0000000000000118 <memset>:

void*
memset(void *dst, int c, uint n)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1e>
 122:	87aa                	mv	a5,a0
 124:	1602                	slli	a2,a2,0x20
 126:	9201                	srli	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	addi	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x14>
  }
  return dst;
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strchr>:

char*
strchr(const char *s, char c)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e406                	sd	ra,8(sp)
 142:	e022                	sd	s0,0(sp)
 144:	0800                	addi	s0,sp,16
  for(; *s; s++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf81                	beqz	a5,162 <strchr+0x24>
    if(*s == c)
 14c:	00f58763          	beq	a1,a5,15a <strchr+0x1c>
  for(; *s; s++)
 150:	0505                	addi	a0,a0,1
 152:	00054783          	lbu	a5,0(a0)
 156:	fbfd                	bnez	a5,14c <strchr+0xe>
      return (char*)s;
  return 0;
 158:	4501                	li	a0,0
}
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfdd                	j	15a <strchr+0x1c>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	e862                	sd	s8,16(sp)
 17c:	1080                	addi	s0,sp,96
 17e:	8baa                	mv	s7,a0
 180:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	892a                	mv	s2,a0
 184:	4481                	li	s1,0
    cc = read(0, &c, 1);
 186:	faf40b13          	addi	s6,s0,-81
 18a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 18c:	8c26                	mv	s8,s1
 18e:	0014899b          	addiw	s3,s1,1
 192:	84ce                	mv	s1,s3
 194:	0349d463          	bge	s3,s4,1bc <gets+0x56>
    cc = read(0, &c, 1);
 198:	8656                	mv	a2,s5
 19a:	85da                	mv	a1,s6
 19c:	4501                	li	a0,0
 19e:	1bc000ef          	jal	35a <read>
    if(cc < 1)
 1a2:	00a05d63          	blez	a0,1bc <gets+0x56>
      break;
    buf[i++] = c;
 1a6:	faf44783          	lbu	a5,-81(s0)
 1aa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ae:	0905                	addi	s2,s2,1
 1b0:	ff678713          	addi	a4,a5,-10
 1b4:	c319                	beqz	a4,1ba <gets+0x54>
 1b6:	17cd                	addi	a5,a5,-13
 1b8:	fbf1                	bnez	a5,18c <gets+0x26>
    buf[i++] = c;
 1ba:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1bc:	9c5e                	add	s8,s8,s7
 1be:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1c2:	855e                	mv	a0,s7
 1c4:	60e6                	ld	ra,88(sp)
 1c6:	6446                	ld	s0,80(sp)
 1c8:	64a6                	ld	s1,72(sp)
 1ca:	6906                	ld	s2,64(sp)
 1cc:	79e2                	ld	s3,56(sp)
 1ce:	7a42                	ld	s4,48(sp)
 1d0:	7aa2                	ld	s5,40(sp)
 1d2:	7b02                	ld	s6,32(sp)
 1d4:	6be2                	ld	s7,24(sp)
 1d6:	6c42                	ld	s8,16(sp)
 1d8:	6125                	addi	sp,sp,96
 1da:	8082                	ret

00000000000001dc <stat>:

int
stat(const char *n, struct stat *st)
{
 1dc:	1101                	addi	sp,sp,-32
 1de:	ec06                	sd	ra,24(sp)
 1e0:	e822                	sd	s0,16(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	198000ef          	jal	382 <open>
  if(fd < 0)
 1ee:	02054263          	bltz	a0,212 <stat+0x36>
 1f2:	e426                	sd	s1,8(sp)
 1f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f6:	85ca                	mv	a1,s2
 1f8:	1a2000ef          	jal	39a <fstat>
 1fc:	892a                	mv	s2,a0
  close(fd);
 1fe:	8526                	mv	a0,s1
 200:	16a000ef          	jal	36a <close>
  return r;
 204:	64a2                	ld	s1,8(sp)
}
 206:	854a                	mv	a0,s2
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	6902                	ld	s2,0(sp)
 20e:	6105                	addi	sp,sp,32
 210:	8082                	ret
    return -1;
 212:	57fd                	li	a5,-1
 214:	893e                	mv	s2,a5
 216:	bfc5                	j	206 <stat+0x2a>

0000000000000218 <atoi>:

int
atoi(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 220:	00054683          	lbu	a3,0(a0)
 224:	fd06879b          	addiw	a5,a3,-48
 228:	0ff7f793          	zext.b	a5,a5
 22c:	4625                	li	a2,9
 22e:	02f66963          	bltu	a2,a5,260 <atoi+0x48>
 232:	872a                	mv	a4,a0
  n = 0;
 234:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 236:	0705                	addi	a4,a4,1
 238:	0025179b          	slliw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	slliw	a5,a5,0x1
 242:	9fb5                	addw	a5,a5,a3
 244:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 248:	00074683          	lbu	a3,0(a4)
 24c:	fd06879b          	addiw	a5,a3,-48
 250:	0ff7f793          	zext.b	a5,a5
 254:	fef671e3          	bgeu	a2,a5,236 <atoi+0x1e>
  return n;
}
 258:	60a2                	ld	ra,8(sp)
 25a:	6402                	ld	s0,0(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret
  n = 0;
 260:	4501                	li	a0,0
 262:	bfdd                	j	258 <atoi+0x40>

0000000000000264 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26c:	02b57563          	bgeu	a0,a1,296 <memmove+0x32>
    while(n-- > 0)
 270:	00c05f63          	blez	a2,28e <memmove+0x2a>
 274:	1602                	slli	a2,a2,0x20
 276:	9201                	srli	a2,a2,0x20
 278:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27c:	872a                	mv	a4,a0
      *dst++ = *src++;
 27e:	0585                	addi	a1,a1,1
 280:	0705                	addi	a4,a4,1
 282:	fff5c683          	lbu	a3,-1(a1)
 286:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
    while(n-- > 0)
 296:	fec05ce3          	blez	a2,28e <memmove+0x2a>
    dst += n;
 29a:	00c50733          	add	a4,a0,a2
    src += n;
 29e:	95b2                	add	a1,a1,a2
 2a0:	fff6079b          	addiw	a5,a2,-1
 2a4:	1782                	slli	a5,a5,0x20
 2a6:	9381                	srli	a5,a5,0x20
 2a8:	fff7c793          	not	a5,a5
 2ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ae:	15fd                	addi	a1,a1,-1
 2b0:	177d                	addi	a4,a4,-1
 2b2:	0005c683          	lbu	a3,0(a1)
 2b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ba:	fef71ae3          	bne	a4,a5,2ae <memmove+0x4a>
 2be:	bfc1                	j	28e <memmove+0x2a>

00000000000002c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c8:	c61d                	beqz	a2,2f6 <memcmp+0x36>
 2ca:	1602                	slli	a2,a2,0x20
 2cc:	9201                	srli	a2,a2,0x20
 2ce:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	0005c703          	lbu	a4,0(a1)
 2da:	00e79863          	bne	a5,a4,2ea <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2de:	0505                	addi	a0,a0,1
    p2++;
 2e0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e2:	fed518e3          	bne	a0,a3,2d2 <memcmp+0x12>
  }
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	a019                	j	2ee <memcmp+0x2e>
      return *p1 - *p2;
 2ea:	40e7853b          	subw	a0,a5,a4
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	bfdd                	j	2ee <memcmp+0x2e>

00000000000002fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 302:	f63ff0ef          	jal	264 <memmove>
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <sbrk>:

char *
sbrk(int n) {
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 316:	4585                	li	a1,1
 318:	0b2000ef          	jal	3ca <sys_sbrk>
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <sbrklazy>:

char *
sbrklazy(int n) {
 324:	1141                	addi	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 32c:	4589                	li	a1,2
 32e:	09c000ef          	jal	3ca <sys_sbrk>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 33a:	4885                	li	a7,1
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exit>:
.global exit
exit:
 li a7, SYS_exit
 342:	4889                	li	a7,2
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <wait>:
.global wait
wait:
 li a7, SYS_wait
 34a:	488d                	li	a7,3
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 352:	4891                	li	a7,4
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <read>:
.global read
read:
 li a7, SYS_read
 35a:	4895                	li	a7,5
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <write>:
.global write
write:
 li a7, SYS_write
 362:	48c1                	li	a7,16
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <close>:
.global close
close:
 li a7, SYS_close
 36a:	48d5                	li	a7,21
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <kill>:
.global kill
kill:
 li a7, SYS_kill
 372:	4899                	li	a7,6
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exec>:
.global exec
exec:
 li a7, SYS_exec
 37a:	489d                	li	a7,7
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <open>:
.global open
open:
 li a7, SYS_open
 382:	48bd                	li	a7,15
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 38a:	48c5                	li	a7,17
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 392:	48c9                	li	a7,18
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 39a:	48a1                	li	a7,8
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <link>:
.global link
link:
 li a7, SYS_link
 3a2:	48cd                	li	a7,19
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3aa:	48d1                	li	a7,20
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b2:	48a5                	li	a7,9
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ba:	48a9                	li	a7,10
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c2:	48ad                	li	a7,11
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3ca:	48b1                	li	a7,12
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3d2:	48b5                	li	a7,13
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3da:	48b9                	li	a7,14
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <kps>:
.global kps
kps:
 li a7, SYS_kps
 3e2:	48d9                	li	a7,22
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 3ea:	48dd                	li	a7,23
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 3f2:	48e1                	li	a7,24
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 3fa:	48e5                	li	a7,25
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 402:	48e9                	li	a7,26
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40a:	1101                	addi	sp,sp,-32
 40c:	ec06                	sd	ra,24(sp)
 40e:	e822                	sd	s0,16(sp)
 410:	1000                	addi	s0,sp,32
 412:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 416:	4605                	li	a2,1
 418:	fef40593          	addi	a1,s0,-17
 41c:	f47ff0ef          	jal	362 <write>
}
 420:	60e2                	ld	ra,24(sp)
 422:	6442                	ld	s0,16(sp)
 424:	6105                	addi	sp,sp,32
 426:	8082                	ret

0000000000000428 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 428:	715d                	addi	sp,sp,-80
 42a:	e486                	sd	ra,72(sp)
 42c:	e0a2                	sd	s0,64(sp)
 42e:	f84a                	sd	s2,48(sp)
 430:	f44e                	sd	s3,40(sp)
 432:	0880                	addi	s0,sp,80
 434:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 436:	c6d1                	beqz	a3,4c2 <printint+0x9a>
 438:	0805d563          	bgez	a1,4c2 <printint+0x9a>
    neg = 1;
    x = -xx;
 43c:	40b005b3          	neg	a1,a1
    neg = 1;
 440:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 442:	fb840993          	addi	s3,s0,-72
  neg = 0;
 446:	86ce                	mv	a3,s3
  i = 0;
 448:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 44a:	00000817          	auipc	a6,0x0
 44e:	59680813          	addi	a6,a6,1430 # 9e0 <digits>
 452:	88ba                	mv	a7,a4
 454:	0017051b          	addiw	a0,a4,1
 458:	872a                	mv	a4,a0
 45a:	02c5f7b3          	remu	a5,a1,a2
 45e:	97c2                	add	a5,a5,a6
 460:	0007c783          	lbu	a5,0(a5)
 464:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 468:	87ae                	mv	a5,a1
 46a:	02c5d5b3          	divu	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fec7f1e3          	bgeu	a5,a2,452 <printint+0x2a>
  if(neg)
 474:	00030c63          	beqz	t1,48c <printint+0x64>
    buf[i++] = '-';
 478:	fd050793          	addi	a5,a0,-48
 47c:	00878533          	add	a0,a5,s0
 480:	02d00793          	li	a5,45
 484:	fef50423          	sb	a5,-24(a0)
 488:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 48c:	02e05563          	blez	a4,4b6 <printint+0x8e>
 490:	fc26                	sd	s1,56(sp)
 492:	377d                	addiw	a4,a4,-1
 494:	00e984b3          	add	s1,s3,a4
 498:	19fd                	addi	s3,s3,-1
 49a:	99ba                	add	s3,s3,a4
 49c:	1702                	slli	a4,a4,0x20
 49e:	9301                	srli	a4,a4,0x20
 4a0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a4:	0004c583          	lbu	a1,0(s1)
 4a8:	854a                	mv	a0,s2
 4aa:	f61ff0ef          	jal	40a <putc>
  while(--i >= 0)
 4ae:	14fd                	addi	s1,s1,-1
 4b0:	ff349ae3          	bne	s1,s3,4a4 <printint+0x7c>
 4b4:	74e2                	ld	s1,56(sp)
}
 4b6:	60a6                	ld	ra,72(sp)
 4b8:	6406                	ld	s0,64(sp)
 4ba:	7942                	ld	s2,48(sp)
 4bc:	79a2                	ld	s3,40(sp)
 4be:	6161                	addi	sp,sp,80
 4c0:	8082                	ret
  neg = 0;
 4c2:	4301                	li	t1,0
 4c4:	bfbd                	j	442 <printint+0x1a>

00000000000004c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c6:	711d                	addi	sp,sp,-96
 4c8:	ec86                	sd	ra,88(sp)
 4ca:	e8a2                	sd	s0,80(sp)
 4cc:	e4a6                	sd	s1,72(sp)
 4ce:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d0:	0005c483          	lbu	s1,0(a1)
 4d4:	22048363          	beqz	s1,6fa <vprintf+0x234>
 4d8:	e0ca                	sd	s2,64(sp)
 4da:	fc4e                	sd	s3,56(sp)
 4dc:	f852                	sd	s4,48(sp)
 4de:	f456                	sd	s5,40(sp)
 4e0:	f05a                	sd	s6,32(sp)
 4e2:	ec5e                	sd	s7,24(sp)
 4e4:	e862                	sd	s8,16(sp)
 4e6:	8b2a                	mv	s6,a0
 4e8:	8a2e                	mv	s4,a1
 4ea:	8bb2                	mv	s7,a2
  state = 0;
 4ec:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ee:	4901                	li	s2,0
 4f0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4f2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f6:	06400c13          	li	s8,100
 4fa:	a00d                	j	51c <vprintf+0x56>
        putc(fd, c0);
 4fc:	85a6                	mv	a1,s1
 4fe:	855a                	mv	a0,s6
 500:	f0bff0ef          	jal	40a <putc>
 504:	a019                	j	50a <vprintf+0x44>
    } else if(state == '%'){
 506:	03598363          	beq	s3,s5,52c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 50a:	0019079b          	addiw	a5,s2,1
 50e:	893e                	mv	s2,a5
 510:	873e                	mv	a4,a5
 512:	97d2                	add	a5,a5,s4
 514:	0007c483          	lbu	s1,0(a5)
 518:	1c048a63          	beqz	s1,6ec <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 51c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 520:	fe0993e3          	bnez	s3,506 <vprintf+0x40>
      if(c0 == '%'){
 524:	fd579ce3          	bne	a5,s5,4fc <vprintf+0x36>
        state = '%';
 528:	89be                	mv	s3,a5
 52a:	b7c5                	j	50a <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 52c:	00ea06b3          	add	a3,s4,a4
 530:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 534:	1c060863          	beqz	a2,704 <vprintf+0x23e>
      if(c0 == 'd'){
 538:	03878763          	beq	a5,s8,566 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 53c:	f9478693          	addi	a3,a5,-108
 540:	0016b693          	seqz	a3,a3
 544:	f9c60593          	addi	a1,a2,-100
 548:	e99d                	bnez	a1,57e <vprintf+0xb8>
 54a:	ca95                	beqz	a3,57e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54c:	008b8493          	addi	s1,s7,8
 550:	4685                	li	a3,1
 552:	4629                	li	a2,10
 554:	000bb583          	ld	a1,0(s7)
 558:	855a                	mv	a0,s6
 55a:	ecfff0ef          	jal	428 <printint>
        i += 1;
 55e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 560:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 562:	4981                	li	s3,0
 564:	b75d                	j	50a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 566:	008b8493          	addi	s1,s7,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000ba583          	lw	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	eb5ff0ef          	jal	428 <printint>
 578:	8ba6                	mv	s7,s1
      state = 0;
 57a:	4981                	li	s3,0
 57c:	b779                	j	50a <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 57e:	9752                	add	a4,a4,s4
 580:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 584:	f9460713          	addi	a4,a2,-108
 588:	00173713          	seqz	a4,a4
 58c:	8f75                	and	a4,a4,a3
 58e:	f9c58513          	addi	a0,a1,-100
 592:	18051363          	bnez	a0,718 <vprintf+0x252>
 596:	18070163          	beqz	a4,718 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59a:	008b8493          	addi	s1,s7,8
 59e:	4685                	li	a3,1
 5a0:	4629                	li	a2,10
 5a2:	000bb583          	ld	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	e81ff0ef          	jal	428 <printint>
        i += 2;
 5ac:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ae:	8ba6                	mv	s7,s1
      state = 0;
 5b0:	4981                	li	s3,0
        i += 2;
 5b2:	bfa1                	j	50a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4629                	li	a2,10
 5bc:	000be583          	lwu	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e67ff0ef          	jal	428 <printint>
 5c6:	8ba6                	mv	s7,s1
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b781                	j	50a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5cc:	008b8493          	addi	s1,s7,8
 5d0:	4681                	li	a3,0
 5d2:	4629                	li	a2,10
 5d4:	000bb583          	ld	a1,0(s7)
 5d8:	855a                	mv	a0,s6
 5da:	e4fff0ef          	jal	428 <printint>
        i += 1;
 5de:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	8ba6                	mv	s7,s1
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b71d                	j	50a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	008b8493          	addi	s1,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4629                	li	a2,10
 5ee:	000bb583          	ld	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	e35ff0ef          	jal	428 <printint>
        i += 2;
 5f8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	8ba6                	mv	s7,s1
      state = 0;
 5fc:	4981                	li	s3,0
        i += 2;
 5fe:	b731                	j	50a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 600:	008b8493          	addi	s1,s7,8
 604:	4681                	li	a3,0
 606:	4641                	li	a2,16
 608:	000be583          	lwu	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	e1bff0ef          	jal	428 <printint>
 612:	8ba6                	mv	s7,s1
      state = 0;
 614:	4981                	li	s3,0
 616:	bdd5                	j	50a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 618:	008b8493          	addi	s1,s7,8
 61c:	4681                	li	a3,0
 61e:	4641                	li	a2,16
 620:	000bb583          	ld	a1,0(s7)
 624:	855a                	mv	a0,s6
 626:	e03ff0ef          	jal	428 <printint>
        i += 1;
 62a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 62c:	8ba6                	mv	s7,s1
      state = 0;
 62e:	4981                	li	s3,0
 630:	bde9                	j	50a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	008b8493          	addi	s1,s7,8
 636:	4681                	li	a3,0
 638:	4641                	li	a2,16
 63a:	000bb583          	ld	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	de9ff0ef          	jal	428 <printint>
        i += 2;
 644:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	8ba6                	mv	s7,s1
      state = 0;
 648:	4981                	li	s3,0
        i += 2;
 64a:	b5c1                	j	50a <vprintf+0x44>
 64c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 64e:	008b8793          	addi	a5,s7,8
 652:	8cbe                	mv	s9,a5
 654:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 658:	03000593          	li	a1,48
 65c:	855a                	mv	a0,s6
 65e:	dadff0ef          	jal	40a <putc>
  putc(fd, 'x');
 662:	07800593          	li	a1,120
 666:	855a                	mv	a0,s6
 668:	da3ff0ef          	jal	40a <putc>
 66c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66e:	00000b97          	auipc	s7,0x0
 672:	372b8b93          	addi	s7,s7,882 # 9e0 <digits>
 676:	03c9d793          	srli	a5,s3,0x3c
 67a:	97de                	add	a5,a5,s7
 67c:	0007c583          	lbu	a1,0(a5)
 680:	855a                	mv	a0,s6
 682:	d89ff0ef          	jal	40a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 686:	0992                	slli	s3,s3,0x4
 688:	34fd                	addiw	s1,s1,-1
 68a:	f4f5                	bnez	s1,676 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 68c:	8be6                	mv	s7,s9
      state = 0;
 68e:	4981                	li	s3,0
 690:	6ca2                	ld	s9,8(sp)
 692:	bda5                	j	50a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 694:	008b8493          	addi	s1,s7,8
 698:	000bc583          	lbu	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	d6dff0ef          	jal	40a <putc>
 6a2:	8ba6                	mv	s7,s1
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b595                	j	50a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a8:	008b8993          	addi	s3,s7,8
 6ac:	000bb483          	ld	s1,0(s7)
 6b0:	cc91                	beqz	s1,6cc <vprintf+0x206>
        for(; *s; s++)
 6b2:	0004c583          	lbu	a1,0(s1)
 6b6:	c985                	beqz	a1,6e6 <vprintf+0x220>
          putc(fd, *s);
 6b8:	855a                	mv	a0,s6
 6ba:	d51ff0ef          	jal	40a <putc>
        for(; *s; s++)
 6be:	0485                	addi	s1,s1,1
 6c0:	0004c583          	lbu	a1,0(s1)
 6c4:	f9f5                	bnez	a1,6b8 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6c6:	8bce                	mv	s7,s3
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b581                	j	50a <vprintf+0x44>
          s = "(null)";
 6cc:	00000497          	auipc	s1,0x0
 6d0:	30c48493          	addi	s1,s1,780 # 9d8 <malloc+0x170>
        for(; *s; s++)
 6d4:	02800593          	li	a1,40
 6d8:	b7c5                	j	6b8 <vprintf+0x1f2>
        putc(fd, '%');
 6da:	85be                	mv	a1,a5
 6dc:	855a                	mv	a0,s6
 6de:	d2dff0ef          	jal	40a <putc>
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b51d                	j	50a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6e6:	8bce                	mv	s7,s3
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b505                	j	50a <vprintf+0x44>
 6ec:	6906                	ld	s2,64(sp)
 6ee:	79e2                	ld	s3,56(sp)
 6f0:	7a42                	ld	s4,48(sp)
 6f2:	7aa2                	ld	s5,40(sp)
 6f4:	7b02                	ld	s6,32(sp)
 6f6:	6be2                	ld	s7,24(sp)
 6f8:	6c42                	ld	s8,16(sp)
    }
  }
}
 6fa:	60e6                	ld	ra,88(sp)
 6fc:	6446                	ld	s0,80(sp)
 6fe:	64a6                	ld	s1,72(sp)
 700:	6125                	addi	sp,sp,96
 702:	8082                	ret
      if(c0 == 'd'){
 704:	06400713          	li	a4,100
 708:	e4e78fe3          	beq	a5,a4,566 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 70c:	f9478693          	addi	a3,a5,-108
 710:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 714:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 716:	4701                	li	a4,0
      } else if(c0 == 'u'){
 718:	07500513          	li	a0,117
 71c:	e8a78ce3          	beq	a5,a0,5b4 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 720:	f8b60513          	addi	a0,a2,-117
 724:	e119                	bnez	a0,72a <vprintf+0x264>
 726:	ea0693e3          	bnez	a3,5cc <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 72a:	f8b58513          	addi	a0,a1,-117
 72e:	e119                	bnez	a0,734 <vprintf+0x26e>
 730:	ea071be3          	bnez	a4,5e6 <vprintf+0x120>
      } else if(c0 == 'x'){
 734:	07800513          	li	a0,120
 738:	eca784e3          	beq	a5,a0,600 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 73c:	f8860613          	addi	a2,a2,-120
 740:	e219                	bnez	a2,746 <vprintf+0x280>
 742:	ec069be3          	bnez	a3,618 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 746:	f8858593          	addi	a1,a1,-120
 74a:	e199                	bnez	a1,750 <vprintf+0x28a>
 74c:	ee0713e3          	bnez	a4,632 <vprintf+0x16c>
      } else if(c0 == 'p'){
 750:	07000713          	li	a4,112
 754:	eee78ce3          	beq	a5,a4,64c <vprintf+0x186>
      } else if(c0 == 'c'){
 758:	06300713          	li	a4,99
 75c:	f2e78ce3          	beq	a5,a4,694 <vprintf+0x1ce>
      } else if(c0 == 's'){
 760:	07300713          	li	a4,115
 764:	f4e782e3          	beq	a5,a4,6a8 <vprintf+0x1e2>
      } else if(c0 == '%'){
 768:	02500713          	li	a4,37
 76c:	f6e787e3          	beq	a5,a4,6da <vprintf+0x214>
        putc(fd, '%');
 770:	02500593          	li	a1,37
 774:	855a                	mv	a0,s6
 776:	c95ff0ef          	jal	40a <putc>
        putc(fd, c0);
 77a:	85a6                	mv	a1,s1
 77c:	855a                	mv	a0,s6
 77e:	c8dff0ef          	jal	40a <putc>
      state = 0;
 782:	4981                	li	s3,0
 784:	b359                	j	50a <vprintf+0x44>

0000000000000786 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 786:	715d                	addi	sp,sp,-80
 788:	ec06                	sd	ra,24(sp)
 78a:	e822                	sd	s0,16(sp)
 78c:	1000                	addi	s0,sp,32
 78e:	e010                	sd	a2,0(s0)
 790:	e414                	sd	a3,8(s0)
 792:	e818                	sd	a4,16(s0)
 794:	ec1c                	sd	a5,24(s0)
 796:	03043023          	sd	a6,32(s0)
 79a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79e:	8622                	mv	a2,s0
 7a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a4:	d23ff0ef          	jal	4c6 <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6161                	addi	sp,sp,80
 7ae:	8082                	ret

00000000000007b0 <printf>:

void
printf(const char *fmt, ...)
{
 7b0:	711d                	addi	sp,sp,-96
 7b2:	ec06                	sd	ra,24(sp)
 7b4:	e822                	sd	s0,16(sp)
 7b6:	1000                	addi	s0,sp,32
 7b8:	e40c                	sd	a1,8(s0)
 7ba:	e810                	sd	a2,16(s0)
 7bc:	ec14                	sd	a3,24(s0)
 7be:	f018                	sd	a4,32(s0)
 7c0:	f41c                	sd	a5,40(s0)
 7c2:	03043823          	sd	a6,48(s0)
 7c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	00840613          	addi	a2,s0,8
 7ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d2:	85aa                	mv	a1,a0
 7d4:	4505                	li	a0,1
 7d6:	cf1ff0ef          	jal	4c6 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6125                	addi	sp,sp,96
 7e0:	8082                	ret

00000000000007e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e2:	1141                	addi	sp,sp,-16
 7e4:	e406                	sd	ra,8(sp)
 7e6:	e022                	sd	s0,0(sp)
 7e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	00001797          	auipc	a5,0x1
 7f2:	8127b783          	ld	a5,-2030(a5) # 1000 <freep>
 7f6:	a039                	j	804 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	6398                	ld	a4,0(a5)
 7fa:	00e7e463          	bltu	a5,a4,802 <free+0x20>
 7fe:	00e6ea63          	bltu	a3,a4,812 <free+0x30>
{
 802:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 804:	fed7fae3          	bgeu	a5,a3,7f8 <free+0x16>
 808:	6398                	ld	a4,0(a5)
 80a:	00e6e463          	bltu	a3,a4,812 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80e:	fee7eae3          	bltu	a5,a4,802 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 812:	ff852583          	lw	a1,-8(a0)
 816:	6390                	ld	a2,0(a5)
 818:	02059813          	slli	a6,a1,0x20
 81c:	01c85713          	srli	a4,a6,0x1c
 820:	9736                	add	a4,a4,a3
 822:	02e60563          	beq	a2,a4,84c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 82a:	4790                	lw	a2,8(a5)
 82c:	02061593          	slli	a1,a2,0x20
 830:	01c5d713          	srli	a4,a1,0x1c
 834:	973e                	add	a4,a4,a5
 836:	02e68263          	beq	a3,a4,85a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 83a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 83c:	00000717          	auipc	a4,0x0
 840:	7cf73223          	sd	a5,1988(a4) # 1000 <freep>
}
 844:	60a2                	ld	ra,8(sp)
 846:	6402                	ld	s0,0(sp)
 848:	0141                	addi	sp,sp,16
 84a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 84c:	4618                	lw	a4,8(a2)
 84e:	9f2d                	addw	a4,a4,a1
 850:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 854:	6398                	ld	a4,0(a5)
 856:	6310                	ld	a2,0(a4)
 858:	b7f9                	j	826 <free+0x44>
    p->s.size += bp->s.size;
 85a:	ff852703          	lw	a4,-8(a0)
 85e:	9f31                	addw	a4,a4,a2
 860:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 862:	ff053683          	ld	a3,-16(a0)
 866:	bfd1                	j	83a <free+0x58>

0000000000000868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f04a                	sd	s2,32(sp)
 870:	ec4e                	sd	s3,24(sp)
 872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 874:	02051993          	slli	s3,a0,0x20
 878:	0209d993          	srli	s3,s3,0x20
 87c:	09bd                	addi	s3,s3,15
 87e:	0049d993          	srli	s3,s3,0x4
 882:	2985                	addiw	s3,s3,1
 884:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 886:	00000517          	auipc	a0,0x0
 88a:	77a53503          	ld	a0,1914(a0) # 1000 <freep>
 88e:	c905                	beqz	a0,8be <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 892:	4798                	lw	a4,8(a5)
 894:	09377663          	bgeu	a4,s3,920 <malloc+0xb8>
 898:	f426                	sd	s1,40(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a0:	8a4e                	mv	s4,s3
 8a2:	6705                	lui	a4,0x1
 8a4:	00e9f363          	bgeu	s3,a4,8aa <malloc+0x42>
 8a8:	6a05                	lui	s4,0x1
 8aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b2:	00000497          	auipc	s1,0x0
 8b6:	74e48493          	addi	s1,s1,1870 # 1000 <freep>
  if(p == SBRK_ERROR)
 8ba:	5afd                	li	s5,-1
 8bc:	a83d                	j	8fa <malloc+0x92>
 8be:	f426                	sd	s1,40(sp)
 8c0:	e852                	sd	s4,16(sp)
 8c2:	e456                	sd	s5,8(sp)
 8c4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c6:	00001797          	auipc	a5,0x1
 8ca:	94278793          	addi	a5,a5,-1726 # 1208 <base>
 8ce:	00000717          	auipc	a4,0x0
 8d2:	72f73923          	sd	a5,1842(a4) # 1000 <freep>
 8d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8dc:	b7d1                	j	8a0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8de:	6398                	ld	a4,0(a5)
 8e0:	e118                	sd	a4,0(a0)
 8e2:	a899                	j	938 <malloc+0xd0>
  hp->s.size = nu;
 8e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e8:	0541                	addi	a0,a0,16
 8ea:	ef9ff0ef          	jal	7e2 <free>
  return freep;
 8ee:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8f0:	c125                	beqz	a0,950 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f4:	4798                	lw	a4,8(a5)
 8f6:	03277163          	bgeu	a4,s2,918 <malloc+0xb0>
    if(p == freep)
 8fa:	6098                	ld	a4,0(s1)
 8fc:	853e                	mv	a0,a5
 8fe:	fef71ae3          	bne	a4,a5,8f2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 902:	8552                	mv	a0,s4
 904:	a0bff0ef          	jal	30e <sbrk>
  if(p == SBRK_ERROR)
 908:	fd551ee3          	bne	a0,s5,8e4 <malloc+0x7c>
        return 0;
 90c:	4501                	li	a0,0
 90e:	74a2                	ld	s1,40(sp)
 910:	6a42                	ld	s4,16(sp)
 912:	6aa2                	ld	s5,8(sp)
 914:	6b02                	ld	s6,0(sp)
 916:	a03d                	j	944 <malloc+0xdc>
 918:	74a2                	ld	s1,40(sp)
 91a:	6a42                	ld	s4,16(sp)
 91c:	6aa2                	ld	s5,8(sp)
 91e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 920:	fae90fe3          	beq	s2,a4,8de <malloc+0x76>
        p->s.size -= nunits;
 924:	4137073b          	subw	a4,a4,s3
 928:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92a:	02071693          	slli	a3,a4,0x20
 92e:	01c6d713          	srli	a4,a3,0x1c
 932:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 934:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 938:	00000717          	auipc	a4,0x0
 93c:	6ca73423          	sd	a0,1736(a4) # 1000 <freep>
      return (void*)(p + 1);
 940:	01078513          	addi	a0,a5,16
  }
}
 944:	70e2                	ld	ra,56(sp)
 946:	7442                	ld	s0,48(sp)
 948:	7902                	ld	s2,32(sp)
 94a:	69e2                	ld	s3,24(sp)
 94c:	6121                	addi	sp,sp,64
 94e:	8082                	ret
 950:	74a2                	ld	s1,40(sp)
 952:	6a42                	ld	s4,16(sp)
 954:	6aa2                	ld	s5,8(sp)
 956:	6b02                	ld	s6,0(sp)
 958:	b7f5                	j	944 <malloc+0xdc>
