
user/_rm:     file format elf64-littleriscv


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
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	344000ef          	jal	36c <unlink>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2e4000ef          	jal	31c <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	90058593          	addi	a1,a1,-1792 # 940 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	716000ef          	jal	760 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2cc000ef          	jal	31c <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	90258593          	addi	a1,a1,-1790 # 958 <malloc+0x116>
  5e:	4509                	li	a0,2
  60:	700000ef          	jal	760 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  6e:	f93ff0ef          	jal	0 <main>
  exit(r);
  72:	2aa000ef          	jal	31c <exit>

0000000000000076 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0xa>
    ;
  return os;
}
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x20>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x20>
    p++, q++;
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf91                	beqz	a5,ee <strlen+0x28>
  d4:	00150793          	addi	a5,a0,1
  d8:	86be                	mv	a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	ff65                	bnez	a4,d8 <strlen+0x12>
  e2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret
  for(n = 0; s[n]; n++)
  ee:	4501                	li	a0,0
  f0:	bfdd                	j	e6 <strlen+0x20>

00000000000000f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fa:	ca19                	beqz	a2,110 <memset+0x1e>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x14>
  }
  return dst;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char*
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 120:	00054783          	lbu	a5,0(a0)
 124:	cf81                	beqz	a5,13c <strchr+0x24>
    if(*s == c)
 126:	00f58763          	beq	a1,a5,134 <strchr+0x1c>
  for(; *s; s++)
 12a:	0505                	addi	a0,a0,1
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbfd                	bnez	a5,126 <strchr+0xe>
      return (char*)s;
  return 0;
 132:	4501                	li	a0,0
}
 134:	60a2                	ld	ra,8(sp)
 136:	6402                	ld	s0,0(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret
  return 0;
 13c:	4501                	li	a0,0
 13e:	bfdd                	j	134 <strchr+0x1c>

0000000000000140 <gets>:

char*
gets(char *buf, int max)
{
 140:	711d                	addi	sp,sp,-96
 142:	ec86                	sd	ra,88(sp)
 144:	e8a2                	sd	s0,80(sp)
 146:	e4a6                	sd	s1,72(sp)
 148:	e0ca                	sd	s2,64(sp)
 14a:	fc4e                	sd	s3,56(sp)
 14c:	f852                	sd	s4,48(sp)
 14e:	f456                	sd	s5,40(sp)
 150:	f05a                	sd	s6,32(sp)
 152:	ec5e                	sd	s7,24(sp)
 154:	e862                	sd	s8,16(sp)
 156:	1080                	addi	s0,sp,96
 158:	8baa                	mv	s7,a0
 15a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15c:	892a                	mv	s2,a0
 15e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 160:	faf40b13          	addi	s6,s0,-81
 164:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 166:	8c26                	mv	s8,s1
 168:	0014899b          	addiw	s3,s1,1
 16c:	84ce                	mv	s1,s3
 16e:	0349d463          	bge	s3,s4,196 <gets+0x56>
    cc = read(0, &c, 1);
 172:	8656                	mv	a2,s5
 174:	85da                	mv	a1,s6
 176:	4501                	li	a0,0
 178:	1bc000ef          	jal	334 <read>
    if(cc < 1)
 17c:	00a05d63          	blez	a0,196 <gets+0x56>
      break;
    buf[i++] = c;
 180:	faf44783          	lbu	a5,-81(s0)
 184:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 188:	0905                	addi	s2,s2,1
 18a:	ff678713          	addi	a4,a5,-10
 18e:	c319                	beqz	a4,194 <gets+0x54>
 190:	17cd                	addi	a5,a5,-13
 192:	fbf1                	bnez	a5,166 <gets+0x26>
    buf[i++] = c;
 194:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 196:	9c5e                	add	s8,s8,s7
 198:	000c0023          	sb	zero,0(s8)
  return buf;
}
 19c:	855e                	mv	a0,s7
 19e:	60e6                	ld	ra,88(sp)
 1a0:	6446                	ld	s0,80(sp)
 1a2:	64a6                	ld	s1,72(sp)
 1a4:	6906                	ld	s2,64(sp)
 1a6:	79e2                	ld	s3,56(sp)
 1a8:	7a42                	ld	s4,48(sp)
 1aa:	7aa2                	ld	s5,40(sp)
 1ac:	7b02                	ld	s6,32(sp)
 1ae:	6be2                	ld	s7,24(sp)
 1b0:	6c42                	ld	s8,16(sp)
 1b2:	6125                	addi	sp,sp,96
 1b4:	8082                	ret

00000000000001b6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b6:	1101                	addi	sp,sp,-32
 1b8:	ec06                	sd	ra,24(sp)
 1ba:	e822                	sd	s0,16(sp)
 1bc:	e04a                	sd	s2,0(sp)
 1be:	1000                	addi	s0,sp,32
 1c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c2:	4581                	li	a1,0
 1c4:	198000ef          	jal	35c <open>
  if(fd < 0)
 1c8:	02054263          	bltz	a0,1ec <stat+0x36>
 1cc:	e426                	sd	s1,8(sp)
 1ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d0:	85ca                	mv	a1,s2
 1d2:	1a2000ef          	jal	374 <fstat>
 1d6:	892a                	mv	s2,a0
  close(fd);
 1d8:	8526                	mv	a0,s1
 1da:	16a000ef          	jal	344 <close>
  return r;
 1de:	64a2                	ld	s1,8(sp)
}
 1e0:	854a                	mv	a0,s2
 1e2:	60e2                	ld	ra,24(sp)
 1e4:	6442                	ld	s0,16(sp)
 1e6:	6902                	ld	s2,0(sp)
 1e8:	6105                	addi	sp,sp,32
 1ea:	8082                	ret
    return -1;
 1ec:	57fd                	li	a5,-1
 1ee:	893e                	mv	s2,a5
 1f0:	bfc5                	j	1e0 <stat+0x2a>

00000000000001f2 <atoi>:

int
atoi(const char *s)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e406                	sd	ra,8(sp)
 1f6:	e022                	sd	s0,0(sp)
 1f8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fa:	00054683          	lbu	a3,0(a0)
 1fe:	fd06879b          	addiw	a5,a3,-48
 202:	0ff7f793          	zext.b	a5,a5
 206:	4625                	li	a2,9
 208:	02f66963          	bltu	a2,a5,23a <atoi+0x48>
 20c:	872a                	mv	a4,a0
  n = 0;
 20e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 210:	0705                	addi	a4,a4,1
 212:	0025179b          	slliw	a5,a0,0x2
 216:	9fa9                	addw	a5,a5,a0
 218:	0017979b          	slliw	a5,a5,0x1
 21c:	9fb5                	addw	a5,a5,a3
 21e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 222:	00074683          	lbu	a3,0(a4)
 226:	fd06879b          	addiw	a5,a3,-48
 22a:	0ff7f793          	zext.b	a5,a5
 22e:	fef671e3          	bgeu	a2,a5,210 <atoi+0x1e>
  return n;
}
 232:	60a2                	ld	ra,8(sp)
 234:	6402                	ld	s0,0(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret
  n = 0;
 23a:	4501                	li	a0,0
 23c:	bfdd                	j	232 <atoi+0x40>

000000000000023e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e406                	sd	ra,8(sp)
 242:	e022                	sd	s0,0(sp)
 244:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 246:	02b57563          	bgeu	a0,a1,270 <memmove+0x32>
    while(n-- > 0)
 24a:	00c05f63          	blez	a2,268 <memmove+0x2a>
 24e:	1602                	slli	a2,a2,0x20
 250:	9201                	srli	a2,a2,0x20
 252:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 256:	872a                	mv	a4,a0
      *dst++ = *src++;
 258:	0585                	addi	a1,a1,1
 25a:	0705                	addi	a4,a4,1
 25c:	fff5c683          	lbu	a3,-1(a1)
 260:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 264:	fee79ae3          	bne	a5,a4,258 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 268:	60a2                	ld	ra,8(sp)
 26a:	6402                	ld	s0,0(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
    while(n-- > 0)
 270:	fec05ce3          	blez	a2,268 <memmove+0x2a>
    dst += n;
 274:	00c50733          	add	a4,a0,a2
    src += n;
 278:	95b2                	add	a1,a1,a2
 27a:	fff6079b          	addiw	a5,a2,-1
 27e:	1782                	slli	a5,a5,0x20
 280:	9381                	srli	a5,a5,0x20
 282:	fff7c793          	not	a5,a5
 286:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 288:	15fd                	addi	a1,a1,-1
 28a:	177d                	addi	a4,a4,-1
 28c:	0005c683          	lbu	a3,0(a1)
 290:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 294:	fef71ae3          	bne	a4,a5,288 <memmove+0x4a>
 298:	bfc1                	j	268 <memmove+0x2a>

000000000000029a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a2:	c61d                	beqz	a2,2d0 <memcmp+0x36>
 2a4:	1602                	slli	a2,a2,0x20
 2a6:	9201                	srli	a2,a2,0x20
 2a8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00e79863          	bne	a5,a4,2c4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2b8:	0505                	addi	a0,a0,1
    p2++;
 2ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2bc:	fed518e3          	bne	a0,a3,2ac <memcmp+0x12>
  }
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	a019                	j	2c8 <memcmp+0x2e>
      return *p1 - *p2;
 2c4:	40e7853b          	subw	a0,a5,a4
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
  return 0;
 2d0:	4501                	li	a0,0
 2d2:	bfdd                	j	2c8 <memcmp+0x2e>

00000000000002d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2dc:	f63ff0ef          	jal	23e <memmove>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <sbrk>:

char *
sbrk(int n) {
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f0:	4585                	li	a1,1
 2f2:	0b2000ef          	jal	3a4 <sys_sbrk>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrklazy>:

char *
sbrklazy(int n) {
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 306:	4589                	li	a1,2
 308:	09c000ef          	jal	3a4 <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 314:	4885                	li	a7,1
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exit>:
.global exit
exit:
 li a7, SYS_exit
 31c:	4889                	li	a7,2
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <wait>:
.global wait
wait:
 li a7, SYS_wait
 324:	488d                	li	a7,3
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32c:	4891                	li	a7,4
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <read>:
.global read
read:
 li a7, SYS_read
 334:	4895                	li	a7,5
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <write>:
.global write
write:
 li a7, SYS_write
 33c:	48c1                	li	a7,16
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <close>:
.global close
close:
 li a7, SYS_close
 344:	48d5                	li	a7,21
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <kill>:
.global kill
kill:
 li a7, SYS_kill
 34c:	4899                	li	a7,6
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <exec>:
.global exec
exec:
 li a7, SYS_exec
 354:	489d                	li	a7,7
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <open>:
.global open
open:
 li a7, SYS_open
 35c:	48bd                	li	a7,15
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 364:	48c5                	li	a7,17
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36c:	48c9                	li	a7,18
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 374:	48a1                	li	a7,8
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <link>:
.global link
link:
 li a7, SYS_link
 37c:	48cd                	li	a7,19
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 384:	48d1                	li	a7,20
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38c:	48a5                	li	a7,9
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <dup>:
.global dup
dup:
 li a7, SYS_dup
 394:	48a9                	li	a7,10
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39c:	48ad                	li	a7,11
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a4:	48b1                	li	a7,12
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ac:	48b5                	li	a7,13
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b4:	48b9                	li	a7,14
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <kps>:
.global kps
kps:
 li a7, SYS_kps
 3bc:	48d9                	li	a7,22
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 3c4:	48dd                	li	a7,23
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 3cc:	48e1                	li	a7,24
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 3d4:	48e5                	li	a7,25
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 3dc:	48e9                	li	a7,26
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	1000                	addi	s0,sp,32
 3ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f0:	4605                	li	a2,1
 3f2:	fef40593          	addi	a1,s0,-17
 3f6:	f47ff0ef          	jal	33c <write>
}
 3fa:	60e2                	ld	ra,24(sp)
 3fc:	6442                	ld	s0,16(sp)
 3fe:	6105                	addi	sp,sp,32
 400:	8082                	ret

0000000000000402 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 402:	715d                	addi	sp,sp,-80
 404:	e486                	sd	ra,72(sp)
 406:	e0a2                	sd	s0,64(sp)
 408:	f84a                	sd	s2,48(sp)
 40a:	f44e                	sd	s3,40(sp)
 40c:	0880                	addi	s0,sp,80
 40e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 410:	c6d1                	beqz	a3,49c <printint+0x9a>
 412:	0805d563          	bgez	a1,49c <printint+0x9a>
    neg = 1;
    x = -xx;
 416:	40b005b3          	neg	a1,a1
    neg = 1;
 41a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 41c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 420:	86ce                	mv	a3,s3
  i = 0;
 422:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 424:	00000817          	auipc	a6,0x0
 428:	55c80813          	addi	a6,a6,1372 # 980 <digits>
 42c:	88ba                	mv	a7,a4
 42e:	0017051b          	addiw	a0,a4,1
 432:	872a                	mv	a4,a0
 434:	02c5f7b3          	remu	a5,a1,a2
 438:	97c2                	add	a5,a5,a6
 43a:	0007c783          	lbu	a5,0(a5)
 43e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 442:	87ae                	mv	a5,a1
 444:	02c5d5b3          	divu	a1,a1,a2
 448:	0685                	addi	a3,a3,1
 44a:	fec7f1e3          	bgeu	a5,a2,42c <printint+0x2a>
  if(neg)
 44e:	00030c63          	beqz	t1,466 <printint+0x64>
    buf[i++] = '-';
 452:	fd050793          	addi	a5,a0,-48
 456:	00878533          	add	a0,a5,s0
 45a:	02d00793          	li	a5,45
 45e:	fef50423          	sb	a5,-24(a0)
 462:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 466:	02e05563          	blez	a4,490 <printint+0x8e>
 46a:	fc26                	sd	s1,56(sp)
 46c:	377d                	addiw	a4,a4,-1
 46e:	00e984b3          	add	s1,s3,a4
 472:	19fd                	addi	s3,s3,-1
 474:	99ba                	add	s3,s3,a4
 476:	1702                	slli	a4,a4,0x20
 478:	9301                	srli	a4,a4,0x20
 47a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 47e:	0004c583          	lbu	a1,0(s1)
 482:	854a                	mv	a0,s2
 484:	f61ff0ef          	jal	3e4 <putc>
  while(--i >= 0)
 488:	14fd                	addi	s1,s1,-1
 48a:	ff349ae3          	bne	s1,s3,47e <printint+0x7c>
 48e:	74e2                	ld	s1,56(sp)
}
 490:	60a6                	ld	ra,72(sp)
 492:	6406                	ld	s0,64(sp)
 494:	7942                	ld	s2,48(sp)
 496:	79a2                	ld	s3,40(sp)
 498:	6161                	addi	sp,sp,80
 49a:	8082                	ret
  neg = 0;
 49c:	4301                	li	t1,0
 49e:	bfbd                	j	41c <printint+0x1a>

00000000000004a0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a0:	711d                	addi	sp,sp,-96
 4a2:	ec86                	sd	ra,88(sp)
 4a4:	e8a2                	sd	s0,80(sp)
 4a6:	e4a6                	sd	s1,72(sp)
 4a8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4aa:	0005c483          	lbu	s1,0(a1)
 4ae:	22048363          	beqz	s1,6d4 <vprintf+0x234>
 4b2:	e0ca                	sd	s2,64(sp)
 4b4:	fc4e                	sd	s3,56(sp)
 4b6:	f852                	sd	s4,48(sp)
 4b8:	f456                	sd	s5,40(sp)
 4ba:	f05a                	sd	s6,32(sp)
 4bc:	ec5e                	sd	s7,24(sp)
 4be:	e862                	sd	s8,16(sp)
 4c0:	8b2a                	mv	s6,a0
 4c2:	8a2e                	mv	s4,a1
 4c4:	8bb2                	mv	s7,a2
  state = 0;
 4c6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4c8:	4901                	li	s2,0
 4ca:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4cc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4d0:	06400c13          	li	s8,100
 4d4:	a00d                	j	4f6 <vprintf+0x56>
        putc(fd, c0);
 4d6:	85a6                	mv	a1,s1
 4d8:	855a                	mv	a0,s6
 4da:	f0bff0ef          	jal	3e4 <putc>
 4de:	a019                	j	4e4 <vprintf+0x44>
    } else if(state == '%'){
 4e0:	03598363          	beq	s3,s5,506 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4e4:	0019079b          	addiw	a5,s2,1
 4e8:	893e                	mv	s2,a5
 4ea:	873e                	mv	a4,a5
 4ec:	97d2                	add	a5,a5,s4
 4ee:	0007c483          	lbu	s1,0(a5)
 4f2:	1c048a63          	beqz	s1,6c6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4f6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4fa:	fe0993e3          	bnez	s3,4e0 <vprintf+0x40>
      if(c0 == '%'){
 4fe:	fd579ce3          	bne	a5,s5,4d6 <vprintf+0x36>
        state = '%';
 502:	89be                	mv	s3,a5
 504:	b7c5                	j	4e4 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 506:	00ea06b3          	add	a3,s4,a4
 50a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 50e:	1c060863          	beqz	a2,6de <vprintf+0x23e>
      if(c0 == 'd'){
 512:	03878763          	beq	a5,s8,540 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 516:	f9478693          	addi	a3,a5,-108
 51a:	0016b693          	seqz	a3,a3
 51e:	f9c60593          	addi	a1,a2,-100
 522:	e99d                	bnez	a1,558 <vprintf+0xb8>
 524:	ca95                	beqz	a3,558 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 526:	008b8493          	addi	s1,s7,8
 52a:	4685                	li	a3,1
 52c:	4629                	li	a2,10
 52e:	000bb583          	ld	a1,0(s7)
 532:	855a                	mv	a0,s6
 534:	ecfff0ef          	jal	402 <printint>
        i += 1;
 538:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 53a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 53c:	4981                	li	s3,0
 53e:	b75d                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 540:	008b8493          	addi	s1,s7,8
 544:	4685                	li	a3,1
 546:	4629                	li	a2,10
 548:	000ba583          	lw	a1,0(s7)
 54c:	855a                	mv	a0,s6
 54e:	eb5ff0ef          	jal	402 <printint>
 552:	8ba6                	mv	s7,s1
      state = 0;
 554:	4981                	li	s3,0
 556:	b779                	j	4e4 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 558:	9752                	add	a4,a4,s4
 55a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55e:	f9460713          	addi	a4,a2,-108
 562:	00173713          	seqz	a4,a4
 566:	8f75                	and	a4,a4,a3
 568:	f9c58513          	addi	a0,a1,-100
 56c:	18051363          	bnez	a0,6f2 <vprintf+0x252>
 570:	18070163          	beqz	a4,6f2 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 574:	008b8493          	addi	s1,s7,8
 578:	4685                	li	a3,1
 57a:	4629                	li	a2,10
 57c:	000bb583          	ld	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	e81ff0ef          	jal	402 <printint>
        i += 2;
 586:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 588:	8ba6                	mv	s7,s1
      state = 0;
 58a:	4981                	li	s3,0
        i += 2;
 58c:	bfa1                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 58e:	008b8493          	addi	s1,s7,8
 592:	4681                	li	a3,0
 594:	4629                	li	a2,10
 596:	000be583          	lwu	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e67ff0ef          	jal	402 <printint>
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b781                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	008b8493          	addi	s1,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4629                	li	a2,10
 5ae:	000bb583          	ld	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	e4fff0ef          	jal	402 <printint>
        i += 1;
 5b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ba:	8ba6                	mv	s7,s1
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b71d                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4629                	li	a2,10
 5c8:	000bb583          	ld	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	e35ff0ef          	jal	402 <printint>
        i += 2;
 5d2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
        i += 2;
 5d8:	b731                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4681                	li	a3,0
 5e0:	4641                	li	a2,16
 5e2:	000be583          	lwu	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	e1bff0ef          	jal	402 <printint>
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bdd5                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4641                	li	a2,16
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e03ff0ef          	jal	402 <printint>
        i += 1;
 604:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 606:	8ba6                	mv	s7,s1
      state = 0;
 608:	4981                	li	s3,0
 60a:	bde9                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 60c:	008b8493          	addi	s1,s7,8
 610:	4681                	li	a3,0
 612:	4641                	li	a2,16
 614:	000bb583          	ld	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	de9ff0ef          	jal	402 <printint>
        i += 2;
 61e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 620:	8ba6                	mv	s7,s1
      state = 0;
 622:	4981                	li	s3,0
        i += 2;
 624:	b5c1                	j	4e4 <vprintf+0x44>
 626:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 628:	008b8793          	addi	a5,s7,8
 62c:	8cbe                	mv	s9,a5
 62e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 632:	03000593          	li	a1,48
 636:	855a                	mv	a0,s6
 638:	dadff0ef          	jal	3e4 <putc>
  putc(fd, 'x');
 63c:	07800593          	li	a1,120
 640:	855a                	mv	a0,s6
 642:	da3ff0ef          	jal	3e4 <putc>
 646:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 648:	00000b97          	auipc	s7,0x0
 64c:	338b8b93          	addi	s7,s7,824 # 980 <digits>
 650:	03c9d793          	srli	a5,s3,0x3c
 654:	97de                	add	a5,a5,s7
 656:	0007c583          	lbu	a1,0(a5)
 65a:	855a                	mv	a0,s6
 65c:	d89ff0ef          	jal	3e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 660:	0992                	slli	s3,s3,0x4
 662:	34fd                	addiw	s1,s1,-1
 664:	f4f5                	bnez	s1,650 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 666:	8be6                	mv	s7,s9
      state = 0;
 668:	4981                	li	s3,0
 66a:	6ca2                	ld	s9,8(sp)
 66c:	bda5                	j	4e4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 66e:	008b8493          	addi	s1,s7,8
 672:	000bc583          	lbu	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	d6dff0ef          	jal	3e4 <putc>
 67c:	8ba6                	mv	s7,s1
      state = 0;
 67e:	4981                	li	s3,0
 680:	b595                	j	4e4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 682:	008b8993          	addi	s3,s7,8
 686:	000bb483          	ld	s1,0(s7)
 68a:	cc91                	beqz	s1,6a6 <vprintf+0x206>
        for(; *s; s++)
 68c:	0004c583          	lbu	a1,0(s1)
 690:	c985                	beqz	a1,6c0 <vprintf+0x220>
          putc(fd, *s);
 692:	855a                	mv	a0,s6
 694:	d51ff0ef          	jal	3e4 <putc>
        for(; *s; s++)
 698:	0485                	addi	s1,s1,1
 69a:	0004c583          	lbu	a1,0(s1)
 69e:	f9f5                	bnez	a1,692 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6a0:	8bce                	mv	s7,s3
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b581                	j	4e4 <vprintf+0x44>
          s = "(null)";
 6a6:	00000497          	auipc	s1,0x0
 6aa:	2d248493          	addi	s1,s1,722 # 978 <malloc+0x136>
        for(; *s; s++)
 6ae:	02800593          	li	a1,40
 6b2:	b7c5                	j	692 <vprintf+0x1f2>
        putc(fd, '%');
 6b4:	85be                	mv	a1,a5
 6b6:	855a                	mv	a0,s6
 6b8:	d2dff0ef          	jal	3e4 <putc>
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b51d                	j	4e4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6c0:	8bce                	mv	s7,s3
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b505                	j	4e4 <vprintf+0x44>
 6c6:	6906                	ld	s2,64(sp)
 6c8:	79e2                	ld	s3,56(sp)
 6ca:	7a42                	ld	s4,48(sp)
 6cc:	7aa2                	ld	s5,40(sp)
 6ce:	7b02                	ld	s6,32(sp)
 6d0:	6be2                	ld	s7,24(sp)
 6d2:	6c42                	ld	s8,16(sp)
    }
  }
}
 6d4:	60e6                	ld	ra,88(sp)
 6d6:	6446                	ld	s0,80(sp)
 6d8:	64a6                	ld	s1,72(sp)
 6da:	6125                	addi	sp,sp,96
 6dc:	8082                	ret
      if(c0 == 'd'){
 6de:	06400713          	li	a4,100
 6e2:	e4e78fe3          	beq	a5,a4,540 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6e6:	f9478693          	addi	a3,a5,-108
 6ea:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6ee:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f0:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6f2:	07500513          	li	a0,117
 6f6:	e8a78ce3          	beq	a5,a0,58e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6fa:	f8b60513          	addi	a0,a2,-117
 6fe:	e119                	bnez	a0,704 <vprintf+0x264>
 700:	ea0693e3          	bnez	a3,5a6 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 704:	f8b58513          	addi	a0,a1,-117
 708:	e119                	bnez	a0,70e <vprintf+0x26e>
 70a:	ea071be3          	bnez	a4,5c0 <vprintf+0x120>
      } else if(c0 == 'x'){
 70e:	07800513          	li	a0,120
 712:	eca784e3          	beq	a5,a0,5da <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 716:	f8860613          	addi	a2,a2,-120
 71a:	e219                	bnez	a2,720 <vprintf+0x280>
 71c:	ec069be3          	bnez	a3,5f2 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 720:	f8858593          	addi	a1,a1,-120
 724:	e199                	bnez	a1,72a <vprintf+0x28a>
 726:	ee0713e3          	bnez	a4,60c <vprintf+0x16c>
      } else if(c0 == 'p'){
 72a:	07000713          	li	a4,112
 72e:	eee78ce3          	beq	a5,a4,626 <vprintf+0x186>
      } else if(c0 == 'c'){
 732:	06300713          	li	a4,99
 736:	f2e78ce3          	beq	a5,a4,66e <vprintf+0x1ce>
      } else if(c0 == 's'){
 73a:	07300713          	li	a4,115
 73e:	f4e782e3          	beq	a5,a4,682 <vprintf+0x1e2>
      } else if(c0 == '%'){
 742:	02500713          	li	a4,37
 746:	f6e787e3          	beq	a5,a4,6b4 <vprintf+0x214>
        putc(fd, '%');
 74a:	02500593          	li	a1,37
 74e:	855a                	mv	a0,s6
 750:	c95ff0ef          	jal	3e4 <putc>
        putc(fd, c0);
 754:	85a6                	mv	a1,s1
 756:	855a                	mv	a0,s6
 758:	c8dff0ef          	jal	3e4 <putc>
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b359                	j	4e4 <vprintf+0x44>

0000000000000760 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 760:	715d                	addi	sp,sp,-80
 762:	ec06                	sd	ra,24(sp)
 764:	e822                	sd	s0,16(sp)
 766:	1000                	addi	s0,sp,32
 768:	e010                	sd	a2,0(s0)
 76a:	e414                	sd	a3,8(s0)
 76c:	e818                	sd	a4,16(s0)
 76e:	ec1c                	sd	a5,24(s0)
 770:	03043023          	sd	a6,32(s0)
 774:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 778:	8622                	mv	a2,s0
 77a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 77e:	d23ff0ef          	jal	4a0 <vprintf>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6161                	addi	sp,sp,80
 788:	8082                	ret

000000000000078a <printf>:

void
printf(const char *fmt, ...)
{
 78a:	711d                	addi	sp,sp,-96
 78c:	ec06                	sd	ra,24(sp)
 78e:	e822                	sd	s0,16(sp)
 790:	1000                	addi	s0,sp,32
 792:	e40c                	sd	a1,8(s0)
 794:	e810                	sd	a2,16(s0)
 796:	ec14                	sd	a3,24(s0)
 798:	f018                	sd	a4,32(s0)
 79a:	f41c                	sd	a5,40(s0)
 79c:	03043823          	sd	a6,48(s0)
 7a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a4:	00840613          	addi	a2,s0,8
 7a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ac:	85aa                	mv	a1,a0
 7ae:	4505                	li	a0,1
 7b0:	cf1ff0ef          	jal	4a0 <vprintf>
}
 7b4:	60e2                	ld	ra,24(sp)
 7b6:	6442                	ld	s0,16(sp)
 7b8:	6125                	addi	sp,sp,96
 7ba:	8082                	ret

00000000000007bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7bc:	1141                	addi	sp,sp,-16
 7be:	e406                	sd	ra,8(sp)
 7c0:	e022                	sd	s0,0(sp)
 7c2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c8:	00001797          	auipc	a5,0x1
 7cc:	8387b783          	ld	a5,-1992(a5) # 1000 <freep>
 7d0:	a039                	j	7de <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d2:	6398                	ld	a4,0(a5)
 7d4:	00e7e463          	bltu	a5,a4,7dc <free+0x20>
 7d8:	00e6ea63          	bltu	a3,a4,7ec <free+0x30>
{
 7dc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	fed7fae3          	bgeu	a5,a3,7d2 <free+0x16>
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e6e463          	bltu	a3,a4,7ec <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	fee7eae3          	bltu	a5,a4,7dc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ec:	ff852583          	lw	a1,-8(a0)
 7f0:	6390                	ld	a2,0(a5)
 7f2:	02059813          	slli	a6,a1,0x20
 7f6:	01c85713          	srli	a4,a6,0x1c
 7fa:	9736                	add	a4,a4,a3
 7fc:	02e60563          	beq	a2,a4,826 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 800:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 804:	4790                	lw	a2,8(a5)
 806:	02061593          	slli	a1,a2,0x20
 80a:	01c5d713          	srli	a4,a1,0x1c
 80e:	973e                	add	a4,a4,a5
 810:	02e68263          	beq	a3,a4,834 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 814:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 816:	00000717          	auipc	a4,0x0
 81a:	7ef73523          	sd	a5,2026(a4) # 1000 <freep>
}
 81e:	60a2                	ld	ra,8(sp)
 820:	6402                	ld	s0,0(sp)
 822:	0141                	addi	sp,sp,16
 824:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 826:	4618                	lw	a4,8(a2)
 828:	9f2d                	addw	a4,a4,a1
 82a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82e:	6398                	ld	a4,0(a5)
 830:	6310                	ld	a2,0(a4)
 832:	b7f9                	j	800 <free+0x44>
    p->s.size += bp->s.size;
 834:	ff852703          	lw	a4,-8(a0)
 838:	9f31                	addw	a4,a4,a2
 83a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83c:	ff053683          	ld	a3,-16(a0)
 840:	bfd1                	j	814 <free+0x58>

0000000000000842 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 842:	7139                	addi	sp,sp,-64
 844:	fc06                	sd	ra,56(sp)
 846:	f822                	sd	s0,48(sp)
 848:	f04a                	sd	s2,32(sp)
 84a:	ec4e                	sd	s3,24(sp)
 84c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84e:	02051993          	slli	s3,a0,0x20
 852:	0209d993          	srli	s3,s3,0x20
 856:	09bd                	addi	s3,s3,15
 858:	0049d993          	srli	s3,s3,0x4
 85c:	2985                	addiw	s3,s3,1
 85e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 860:	00000517          	auipc	a0,0x0
 864:	7a053503          	ld	a0,1952(a0) # 1000 <freep>
 868:	c905                	beqz	a0,898 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86c:	4798                	lw	a4,8(a5)
 86e:	09377663          	bgeu	a4,s3,8fa <malloc+0xb8>
 872:	f426                	sd	s1,40(sp)
 874:	e852                	sd	s4,16(sp)
 876:	e456                	sd	s5,8(sp)
 878:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 87a:	8a4e                	mv	s4,s3
 87c:	6705                	lui	a4,0x1
 87e:	00e9f363          	bgeu	s3,a4,884 <malloc+0x42>
 882:	6a05                	lui	s4,0x1
 884:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 888:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88c:	00000497          	auipc	s1,0x0
 890:	77448493          	addi	s1,s1,1908 # 1000 <freep>
  if(p == SBRK_ERROR)
 894:	5afd                	li	s5,-1
 896:	a83d                	j	8d4 <malloc+0x92>
 898:	f426                	sd	s1,40(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a0:	00000797          	auipc	a5,0x0
 8a4:	77078793          	addi	a5,a5,1904 # 1010 <base>
 8a8:	00000717          	auipc	a4,0x0
 8ac:	74f73c23          	sd	a5,1880(a4) # 1000 <freep>
 8b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b6:	b7d1                	j	87a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8b8:	6398                	ld	a4,0(a5)
 8ba:	e118                	sd	a4,0(a0)
 8bc:	a899                	j	912 <malloc+0xd0>
  hp->s.size = nu;
 8be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c2:	0541                	addi	a0,a0,16
 8c4:	ef9ff0ef          	jal	7bc <free>
  return freep;
 8c8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8ca:	c125                	beqz	a0,92a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ce:	4798                	lw	a4,8(a5)
 8d0:	03277163          	bgeu	a4,s2,8f2 <malloc+0xb0>
    if(p == freep)
 8d4:	6098                	ld	a4,0(s1)
 8d6:	853e                	mv	a0,a5
 8d8:	fef71ae3          	bne	a4,a5,8cc <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8dc:	8552                	mv	a0,s4
 8de:	a0bff0ef          	jal	2e8 <sbrk>
  if(p == SBRK_ERROR)
 8e2:	fd551ee3          	bne	a0,s5,8be <malloc+0x7c>
        return 0;
 8e6:	4501                	li	a0,0
 8e8:	74a2                	ld	s1,40(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
 8f0:	a03d                	j	91e <malloc+0xdc>
 8f2:	74a2                	ld	s1,40(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8fa:	fae90fe3          	beq	s2,a4,8b8 <malloc+0x76>
        p->s.size -= nunits;
 8fe:	4137073b          	subw	a4,a4,s3
 902:	c798                	sw	a4,8(a5)
        p += p->s.size;
 904:	02071693          	slli	a3,a4,0x20
 908:	01c6d713          	srli	a4,a3,0x1c
 90c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 912:	00000717          	auipc	a4,0x0
 916:	6ea73723          	sd	a0,1774(a4) # 1000 <freep>
      return (void*)(p + 1);
 91a:	01078513          	addi	a0,a5,16
  }
}
 91e:	70e2                	ld	ra,56(sp)
 920:	7442                	ld	s0,48(sp)
 922:	7902                	ld	s2,32(sp)
 924:	69e2                	ld	s3,24(sp)
 926:	6121                	addi	sp,sp,64
 928:	8082                	ret
 92a:	74a2                	ld	s1,40(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
 932:	b7f5                	j	91e <malloc+0xdc>
