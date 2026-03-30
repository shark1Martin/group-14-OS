
user/_ln:     file format elf64-littleriscv


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
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	91058593          	addi	a1,a1,-1776 # 920 <malloc+0xf6>
  18:	4509                	li	a0,2
  1a:	72e000ef          	jal	748 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2e4000ef          	jal	304 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	338000ef          	jal	364 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2ce000ef          	jal	304 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	8fa58593          	addi	a1,a1,-1798 # 938 <malloc+0x10e>
  46:	4509                	li	a0,2
  48:	700000ef          	jal	748 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	2aa000ef          	jal	304 <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x28>
  bc:	00150793          	addi	a5,a0,1
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for(n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfdd                	j	ce <strlen+0x20>

00000000000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e2:	ca19                	beqz	a2,f8 <memset+0x1e>
  e4:	87aa                	mv	a5,a0
  e6:	1602                	slli	a2,a2,0x20
  e8:	9201                	srli	a2,a2,0x20
  ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f2:	0785                	addi	a5,a5,1
  f4:	fee79de3          	bne	a5,a4,ee <memset+0x14>
  }
  return dst;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  for(; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cf81                	beqz	a5,124 <strchr+0x24>
    if(*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1c>
  for(; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xe>
      return (char*)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  return 0;
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strchr+0x1c>

0000000000000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	711d                	addi	sp,sp,-96
 12a:	ec86                	sd	ra,88(sp)
 12c:	e8a2                	sd	s0,80(sp)
 12e:	e4a6                	sd	s1,72(sp)
 130:	e0ca                	sd	s2,64(sp)
 132:	fc4e                	sd	s3,56(sp)
 134:	f852                	sd	s4,48(sp)
 136:	f456                	sd	s5,40(sp)
 138:	f05a                	sd	s6,32(sp)
 13a:	ec5e                	sd	s7,24(sp)
 13c:	e862                	sd	s8,16(sp)
 13e:	1080                	addi	s0,sp,96
 140:	8baa                	mv	s7,a0
 142:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 144:	892a                	mv	s2,a0
 146:	4481                	li	s1,0
    cc = read(0, &c, 1);
 148:	faf40b13          	addi	s6,s0,-81
 14c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 14e:	8c26                	mv	s8,s1
 150:	0014899b          	addiw	s3,s1,1
 154:	84ce                	mv	s1,s3
 156:	0349d463          	bge	s3,s4,17e <gets+0x56>
    cc = read(0, &c, 1);
 15a:	8656                	mv	a2,s5
 15c:	85da                	mv	a1,s6
 15e:	4501                	li	a0,0
 160:	1bc000ef          	jal	31c <read>
    if(cc < 1)
 164:	00a05d63          	blez	a0,17e <gets+0x56>
      break;
    buf[i++] = c;
 168:	faf44783          	lbu	a5,-81(s0)
 16c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 170:	0905                	addi	s2,s2,1
 172:	ff678713          	addi	a4,a5,-10
 176:	c319                	beqz	a4,17c <gets+0x54>
 178:	17cd                	addi	a5,a5,-13
 17a:	fbf1                	bnez	a5,14e <gets+0x26>
    buf[i++] = c;
 17c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 17e:	9c5e                	add	s8,s8,s7
 180:	000c0023          	sb	zero,0(s8)
  return buf;
}
 184:	855e                	mv	a0,s7
 186:	60e6                	ld	ra,88(sp)
 188:	6446                	ld	s0,80(sp)
 18a:	64a6                	ld	s1,72(sp)
 18c:	6906                	ld	s2,64(sp)
 18e:	79e2                	ld	s3,56(sp)
 190:	7a42                	ld	s4,48(sp)
 192:	7aa2                	ld	s5,40(sp)
 194:	7b02                	ld	s6,32(sp)
 196:	6be2                	ld	s7,24(sp)
 198:	6c42                	ld	s8,16(sp)
 19a:	6125                	addi	sp,sp,96
 19c:	8082                	ret

000000000000019e <stat>:

int
stat(const char *n, struct stat *st)
{
 19e:	1101                	addi	sp,sp,-32
 1a0:	ec06                	sd	ra,24(sp)
 1a2:	e822                	sd	s0,16(sp)
 1a4:	e04a                	sd	s2,0(sp)
 1a6:	1000                	addi	s0,sp,32
 1a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	4581                	li	a1,0
 1ac:	198000ef          	jal	344 <open>
  if(fd < 0)
 1b0:	02054263          	bltz	a0,1d4 <stat+0x36>
 1b4:	e426                	sd	s1,8(sp)
 1b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b8:	85ca                	mv	a1,s2
 1ba:	1a2000ef          	jal	35c <fstat>
 1be:	892a                	mv	s2,a0
  close(fd);
 1c0:	8526                	mv	a0,s1
 1c2:	16a000ef          	jal	32c <close>
  return r;
 1c6:	64a2                	ld	s1,8(sp)
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	6902                	ld	s2,0(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret
    return -1;
 1d4:	57fd                	li	a5,-1
 1d6:	893e                	mv	s2,a5
 1d8:	bfc5                	j	1c8 <stat+0x2a>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e406                	sd	ra,8(sp)
 1de:	e022                	sd	s0,0(sp)
 1e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e2:	00054683          	lbu	a3,0(a0)
 1e6:	fd06879b          	addiw	a5,a3,-48
 1ea:	0ff7f793          	zext.b	a5,a5
 1ee:	4625                	li	a2,9
 1f0:	02f66963          	bltu	a2,a5,222 <atoi+0x48>
 1f4:	872a                	mv	a4,a0
  n = 0;
 1f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f8:	0705                	addi	a4,a4,1
 1fa:	0025179b          	slliw	a5,a0,0x2
 1fe:	9fa9                	addw	a5,a5,a0
 200:	0017979b          	slliw	a5,a5,0x1
 204:	9fb5                	addw	a5,a5,a3
 206:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20a:	00074683          	lbu	a3,0(a4)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	fef671e3          	bgeu	a2,a5,1f8 <atoi+0x1e>
  return n;
}
 21a:	60a2                	ld	ra,8(sp)
 21c:	6402                	ld	s0,0(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  n = 0;
 222:	4501                	li	a0,0
 224:	bfdd                	j	21a <atoi+0x40>

0000000000000226 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 22e:	02b57563          	bgeu	a0,a1,258 <memmove+0x32>
    while(n-- > 0)
 232:	00c05f63          	blez	a2,250 <memmove+0x2a>
 236:	1602                	slli	a2,a2,0x20
 238:	9201                	srli	a2,a2,0x20
 23a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 23e:	872a                	mv	a4,a0
      *dst++ = *src++;
 240:	0585                	addi	a1,a1,1
 242:	0705                	addi	a4,a4,1
 244:	fff5c683          	lbu	a3,-1(a1)
 248:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24c:	fee79ae3          	bne	a5,a4,240 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 250:	60a2                	ld	ra,8(sp)
 252:	6402                	ld	s0,0(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
    while(n-- > 0)
 258:	fec05ce3          	blez	a2,250 <memmove+0x2a>
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
 262:	fff6079b          	addiw	a5,a2,-1
 266:	1782                	slli	a5,a5,0x20
 268:	9381                	srli	a5,a5,0x20
 26a:	fff7c793          	not	a5,a5
 26e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 270:	15fd                	addi	a1,a1,-1
 272:	177d                	addi	a4,a4,-1
 274:	0005c683          	lbu	a3,0(a1)
 278:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27c:	fef71ae3          	bne	a4,a5,270 <memmove+0x4a>
 280:	bfc1                	j	250 <memmove+0x2a>

0000000000000282 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28a:	c61d                	beqz	a2,2b8 <memcmp+0x36>
 28c:	1602                	slli	a2,a2,0x20
 28e:	9201                	srli	a2,a2,0x20
 290:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 294:	00054783          	lbu	a5,0(a0)
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00e79863          	bne	a5,a4,2ac <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a0:	0505                	addi	a0,a0,1
    p2++;
 2a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a4:	fed518e3          	bne	a0,a3,294 <memcmp+0x12>
  }
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	a019                	j	2b0 <memcmp+0x2e>
      return *p1 - *p2;
 2ac:	40e7853b          	subw	a0,a5,a4
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfdd                	j	2b0 <memcmp+0x2e>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	f63ff0ef          	jal	226 <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <sbrk>:

char *
sbrk(int n) {
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d8:	4585                	li	a1,1
 2da:	0b2000ef          	jal	38c <sys_sbrk>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <sbrklazy>:

char *
sbrklazy(int n) {
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ee:	4589                	li	a1,2
 2f0:	09c000ef          	jal	38c <sys_sbrk>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pause>:
.global pause
pause:
 li a7, SYS_pause
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <kps>:
.global kps
kps:
 li a7, SYS_kps
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 3b4:	48e1                	li	a7,24
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 3bc:	48e5                	li	a7,25
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 3c4:	48e9                	li	a7,26
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3cc:	1101                	addi	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	fef40593          	addi	a1,s0,-17
 3de:	f47ff0ef          	jal	324 <write>
}
 3e2:	60e2                	ld	ra,24(sp)
 3e4:	6442                	ld	s0,16(sp)
 3e6:	6105                	addi	sp,sp,32
 3e8:	8082                	ret

00000000000003ea <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ea:	715d                	addi	sp,sp,-80
 3ec:	e486                	sd	ra,72(sp)
 3ee:	e0a2                	sd	s0,64(sp)
 3f0:	f84a                	sd	s2,48(sp)
 3f2:	f44e                	sd	s3,40(sp)
 3f4:	0880                	addi	s0,sp,80
 3f6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3f8:	c6d1                	beqz	a3,484 <printint+0x9a>
 3fa:	0805d563          	bgez	a1,484 <printint+0x9a>
    neg = 1;
    x = -xx;
 3fe:	40b005b3          	neg	a1,a1
    neg = 1;
 402:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 404:	fb840993          	addi	s3,s0,-72
  neg = 0;
 408:	86ce                	mv	a3,s3
  i = 0;
 40a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 40c:	00000817          	auipc	a6,0x0
 410:	54c80813          	addi	a6,a6,1356 # 958 <digits>
 414:	88ba                	mv	a7,a4
 416:	0017051b          	addiw	a0,a4,1
 41a:	872a                	mv	a4,a0
 41c:	02c5f7b3          	remu	a5,a1,a2
 420:	97c2                	add	a5,a5,a6
 422:	0007c783          	lbu	a5,0(a5)
 426:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 42a:	87ae                	mv	a5,a1
 42c:	02c5d5b3          	divu	a1,a1,a2
 430:	0685                	addi	a3,a3,1
 432:	fec7f1e3          	bgeu	a5,a2,414 <printint+0x2a>
  if(neg)
 436:	00030c63          	beqz	t1,44e <printint+0x64>
    buf[i++] = '-';
 43a:	fd050793          	addi	a5,a0,-48
 43e:	00878533          	add	a0,a5,s0
 442:	02d00793          	li	a5,45
 446:	fef50423          	sb	a5,-24(a0)
 44a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 44e:	02e05563          	blez	a4,478 <printint+0x8e>
 452:	fc26                	sd	s1,56(sp)
 454:	377d                	addiw	a4,a4,-1
 456:	00e984b3          	add	s1,s3,a4
 45a:	19fd                	addi	s3,s3,-1
 45c:	99ba                	add	s3,s3,a4
 45e:	1702                	slli	a4,a4,0x20
 460:	9301                	srli	a4,a4,0x20
 462:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 466:	0004c583          	lbu	a1,0(s1)
 46a:	854a                	mv	a0,s2
 46c:	f61ff0ef          	jal	3cc <putc>
  while(--i >= 0)
 470:	14fd                	addi	s1,s1,-1
 472:	ff349ae3          	bne	s1,s3,466 <printint+0x7c>
 476:	74e2                	ld	s1,56(sp)
}
 478:	60a6                	ld	ra,72(sp)
 47a:	6406                	ld	s0,64(sp)
 47c:	7942                	ld	s2,48(sp)
 47e:	79a2                	ld	s3,40(sp)
 480:	6161                	addi	sp,sp,80
 482:	8082                	ret
  neg = 0;
 484:	4301                	li	t1,0
 486:	bfbd                	j	404 <printint+0x1a>

0000000000000488 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 488:	711d                	addi	sp,sp,-96
 48a:	ec86                	sd	ra,88(sp)
 48c:	e8a2                	sd	s0,80(sp)
 48e:	e4a6                	sd	s1,72(sp)
 490:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 492:	0005c483          	lbu	s1,0(a1)
 496:	22048363          	beqz	s1,6bc <vprintf+0x234>
 49a:	e0ca                	sd	s2,64(sp)
 49c:	fc4e                	sd	s3,56(sp)
 49e:	f852                	sd	s4,48(sp)
 4a0:	f456                	sd	s5,40(sp)
 4a2:	f05a                	sd	s6,32(sp)
 4a4:	ec5e                	sd	s7,24(sp)
 4a6:	e862                	sd	s8,16(sp)
 4a8:	8b2a                	mv	s6,a0
 4aa:	8a2e                	mv	s4,a1
 4ac:	8bb2                	mv	s7,a2
  state = 0;
 4ae:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4b0:	4901                	li	s2,0
 4b2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b8:	06400c13          	li	s8,100
 4bc:	a00d                	j	4de <vprintf+0x56>
        putc(fd, c0);
 4be:	85a6                	mv	a1,s1
 4c0:	855a                	mv	a0,s6
 4c2:	f0bff0ef          	jal	3cc <putc>
 4c6:	a019                	j	4cc <vprintf+0x44>
    } else if(state == '%'){
 4c8:	03598363          	beq	s3,s5,4ee <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4cc:	0019079b          	addiw	a5,s2,1
 4d0:	893e                	mv	s2,a5
 4d2:	873e                	mv	a4,a5
 4d4:	97d2                	add	a5,a5,s4
 4d6:	0007c483          	lbu	s1,0(a5)
 4da:	1c048a63          	beqz	s1,6ae <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4de:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4e2:	fe0993e3          	bnez	s3,4c8 <vprintf+0x40>
      if(c0 == '%'){
 4e6:	fd579ce3          	bne	a5,s5,4be <vprintf+0x36>
        state = '%';
 4ea:	89be                	mv	s3,a5
 4ec:	b7c5                	j	4cc <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ee:	00ea06b3          	add	a3,s4,a4
 4f2:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4f6:	1c060863          	beqz	a2,6c6 <vprintf+0x23e>
      if(c0 == 'd'){
 4fa:	03878763          	beq	a5,s8,528 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4fe:	f9478693          	addi	a3,a5,-108
 502:	0016b693          	seqz	a3,a3
 506:	f9c60593          	addi	a1,a2,-100
 50a:	e99d                	bnez	a1,540 <vprintf+0xb8>
 50c:	ca95                	beqz	a3,540 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 50e:	008b8493          	addi	s1,s7,8
 512:	4685                	li	a3,1
 514:	4629                	li	a2,10
 516:	000bb583          	ld	a1,0(s7)
 51a:	855a                	mv	a0,s6
 51c:	ecfff0ef          	jal	3ea <printint>
        i += 1;
 520:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 522:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 524:	4981                	li	s3,0
 526:	b75d                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 528:	008b8493          	addi	s1,s7,8
 52c:	4685                	li	a3,1
 52e:	4629                	li	a2,10
 530:	000ba583          	lw	a1,0(s7)
 534:	855a                	mv	a0,s6
 536:	eb5ff0ef          	jal	3ea <printint>
 53a:	8ba6                	mv	s7,s1
      state = 0;
 53c:	4981                	li	s3,0
 53e:	b779                	j	4cc <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 540:	9752                	add	a4,a4,s4
 542:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 546:	f9460713          	addi	a4,a2,-108
 54a:	00173713          	seqz	a4,a4
 54e:	8f75                	and	a4,a4,a3
 550:	f9c58513          	addi	a0,a1,-100
 554:	18051363          	bnez	a0,6da <vprintf+0x252>
 558:	18070163          	beqz	a4,6da <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	008b8493          	addi	s1,s7,8
 560:	4685                	li	a3,1
 562:	4629                	li	a2,10
 564:	000bb583          	ld	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	e81ff0ef          	jal	3ea <printint>
        i += 2;
 56e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 570:	8ba6                	mv	s7,s1
      state = 0;
 572:	4981                	li	s3,0
        i += 2;
 574:	bfa1                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 576:	008b8493          	addi	s1,s7,8
 57a:	4681                	li	a3,0
 57c:	4629                	li	a2,10
 57e:	000be583          	lwu	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	e67ff0ef          	jal	3ea <printint>
 588:	8ba6                	mv	s7,s1
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b781                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	008b8493          	addi	s1,s7,8
 592:	4681                	li	a3,0
 594:	4629                	li	a2,10
 596:	000bb583          	ld	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e4fff0ef          	jal	3ea <printint>
        i += 1;
 5a0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	8ba6                	mv	s7,s1
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b71d                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	008b8493          	addi	s1,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4629                	li	a2,10
 5b0:	000bb583          	ld	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e35ff0ef          	jal	3ea <printint>
        i += 2;
 5ba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
        i += 2;
 5c0:	b731                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4641                	li	a2,16
 5ca:	000be583          	lwu	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e1bff0ef          	jal	3ea <printint>
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bdd5                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4681                	li	a3,0
 5e0:	4641                	li	a2,16
 5e2:	000bb583          	ld	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	e03ff0ef          	jal	3ea <printint>
        i += 1;
 5ec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ee:	8ba6                	mv	s7,s1
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bde9                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	de9ff0ef          	jal	3ea <printint>
        i += 2;
 606:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	b5c1                	j	4cc <vprintf+0x44>
 60e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 610:	008b8793          	addi	a5,s7,8
 614:	8cbe                	mv	s9,a5
 616:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 61a:	03000593          	li	a1,48
 61e:	855a                	mv	a0,s6
 620:	dadff0ef          	jal	3cc <putc>
  putc(fd, 'x');
 624:	07800593          	li	a1,120
 628:	855a                	mv	a0,s6
 62a:	da3ff0ef          	jal	3cc <putc>
 62e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 630:	00000b97          	auipc	s7,0x0
 634:	328b8b93          	addi	s7,s7,808 # 958 <digits>
 638:	03c9d793          	srli	a5,s3,0x3c
 63c:	97de                	add	a5,a5,s7
 63e:	0007c583          	lbu	a1,0(a5)
 642:	855a                	mv	a0,s6
 644:	d89ff0ef          	jal	3cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 648:	0992                	slli	s3,s3,0x4
 64a:	34fd                	addiw	s1,s1,-1
 64c:	f4f5                	bnez	s1,638 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 64e:	8be6                	mv	s7,s9
      state = 0;
 650:	4981                	li	s3,0
 652:	6ca2                	ld	s9,8(sp)
 654:	bda5                	j	4cc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 656:	008b8493          	addi	s1,s7,8
 65a:	000bc583          	lbu	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	d6dff0ef          	jal	3cc <putc>
 664:	8ba6                	mv	s7,s1
      state = 0;
 666:	4981                	li	s3,0
 668:	b595                	j	4cc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 66a:	008b8993          	addi	s3,s7,8
 66e:	000bb483          	ld	s1,0(s7)
 672:	cc91                	beqz	s1,68e <vprintf+0x206>
        for(; *s; s++)
 674:	0004c583          	lbu	a1,0(s1)
 678:	c985                	beqz	a1,6a8 <vprintf+0x220>
          putc(fd, *s);
 67a:	855a                	mv	a0,s6
 67c:	d51ff0ef          	jal	3cc <putc>
        for(; *s; s++)
 680:	0485                	addi	s1,s1,1
 682:	0004c583          	lbu	a1,0(s1)
 686:	f9f5                	bnez	a1,67a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 688:	8bce                	mv	s7,s3
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b581                	j	4cc <vprintf+0x44>
          s = "(null)";
 68e:	00000497          	auipc	s1,0x0
 692:	2c248493          	addi	s1,s1,706 # 950 <malloc+0x126>
        for(; *s; s++)
 696:	02800593          	li	a1,40
 69a:	b7c5                	j	67a <vprintf+0x1f2>
        putc(fd, '%');
 69c:	85be                	mv	a1,a5
 69e:	855a                	mv	a0,s6
 6a0:	d2dff0ef          	jal	3cc <putc>
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b51d                	j	4cc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b505                	j	4cc <vprintf+0x44>
 6ae:	6906                	ld	s2,64(sp)
 6b0:	79e2                	ld	s3,56(sp)
 6b2:	7a42                	ld	s4,48(sp)
 6b4:	7aa2                	ld	s5,40(sp)
 6b6:	7b02                	ld	s6,32(sp)
 6b8:	6be2                	ld	s7,24(sp)
 6ba:	6c42                	ld	s8,16(sp)
    }
  }
}
 6bc:	60e6                	ld	ra,88(sp)
 6be:	6446                	ld	s0,80(sp)
 6c0:	64a6                	ld	s1,72(sp)
 6c2:	6125                	addi	sp,sp,96
 6c4:	8082                	ret
      if(c0 == 'd'){
 6c6:	06400713          	li	a4,100
 6ca:	e4e78fe3          	beq	a5,a4,528 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6ce:	f9478693          	addi	a3,a5,-108
 6d2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6d6:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d8:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6da:	07500513          	li	a0,117
 6de:	e8a78ce3          	beq	a5,a0,576 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6e2:	f8b60513          	addi	a0,a2,-117
 6e6:	e119                	bnez	a0,6ec <vprintf+0x264>
 6e8:	ea0693e3          	bnez	a3,58e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ec:	f8b58513          	addi	a0,a1,-117
 6f0:	e119                	bnez	a0,6f6 <vprintf+0x26e>
 6f2:	ea071be3          	bnez	a4,5a8 <vprintf+0x120>
      } else if(c0 == 'x'){
 6f6:	07800513          	li	a0,120
 6fa:	eca784e3          	beq	a5,a0,5c2 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6fe:	f8860613          	addi	a2,a2,-120
 702:	e219                	bnez	a2,708 <vprintf+0x280>
 704:	ec069be3          	bnez	a3,5da <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 708:	f8858593          	addi	a1,a1,-120
 70c:	e199                	bnez	a1,712 <vprintf+0x28a>
 70e:	ee0713e3          	bnez	a4,5f4 <vprintf+0x16c>
      } else if(c0 == 'p'){
 712:	07000713          	li	a4,112
 716:	eee78ce3          	beq	a5,a4,60e <vprintf+0x186>
      } else if(c0 == 'c'){
 71a:	06300713          	li	a4,99
 71e:	f2e78ce3          	beq	a5,a4,656 <vprintf+0x1ce>
      } else if(c0 == 's'){
 722:	07300713          	li	a4,115
 726:	f4e782e3          	beq	a5,a4,66a <vprintf+0x1e2>
      } else if(c0 == '%'){
 72a:	02500713          	li	a4,37
 72e:	f6e787e3          	beq	a5,a4,69c <vprintf+0x214>
        putc(fd, '%');
 732:	02500593          	li	a1,37
 736:	855a                	mv	a0,s6
 738:	c95ff0ef          	jal	3cc <putc>
        putc(fd, c0);
 73c:	85a6                	mv	a1,s1
 73e:	855a                	mv	a0,s6
 740:	c8dff0ef          	jal	3cc <putc>
      state = 0;
 744:	4981                	li	s3,0
 746:	b359                	j	4cc <vprintf+0x44>

0000000000000748 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 748:	715d                	addi	sp,sp,-80
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	e010                	sd	a2,0(s0)
 752:	e414                	sd	a3,8(s0)
 754:	e818                	sd	a4,16(s0)
 756:	ec1c                	sd	a5,24(s0)
 758:	03043023          	sd	a6,32(s0)
 75c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	8622                	mv	a2,s0
 762:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 766:	d23ff0ef          	jal	488 <vprintf>
}
 76a:	60e2                	ld	ra,24(sp)
 76c:	6442                	ld	s0,16(sp)
 76e:	6161                	addi	sp,sp,80
 770:	8082                	ret

0000000000000772 <printf>:

void
printf(const char *fmt, ...)
{
 772:	711d                	addi	sp,sp,-96
 774:	ec06                	sd	ra,24(sp)
 776:	e822                	sd	s0,16(sp)
 778:	1000                	addi	s0,sp,32
 77a:	e40c                	sd	a1,8(s0)
 77c:	e810                	sd	a2,16(s0)
 77e:	ec14                	sd	a3,24(s0)
 780:	f018                	sd	a4,32(s0)
 782:	f41c                	sd	a5,40(s0)
 784:	03043823          	sd	a6,48(s0)
 788:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	00840613          	addi	a2,s0,8
 790:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 794:	85aa                	mv	a1,a0
 796:	4505                	li	a0,1
 798:	cf1ff0ef          	jal	488 <vprintf>
}
 79c:	60e2                	ld	ra,24(sp)
 79e:	6442                	ld	s0,16(sp)
 7a0:	6125                	addi	sp,sp,96
 7a2:	8082                	ret

00000000000007a4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a4:	1141                	addi	sp,sp,-16
 7a6:	e406                	sd	ra,8(sp)
 7a8:	e022                	sd	s0,0(sp)
 7aa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ac:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	00001797          	auipc	a5,0x1
 7b4:	8507b783          	ld	a5,-1968(a5) # 1000 <freep>
 7b8:	a039                	j	7c6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e7e463          	bltu	a5,a4,7c4 <free+0x20>
 7c0:	00e6ea63          	bltu	a3,a4,7d4 <free+0x30>
{
 7c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	fed7fae3          	bgeu	a5,a3,7ba <free+0x16>
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e6e463          	bltu	a3,a4,7d4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	fee7eae3          	bltu	a5,a4,7c4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d4:	ff852583          	lw	a1,-8(a0)
 7d8:	6390                	ld	a2,0(a5)
 7da:	02059813          	slli	a6,a1,0x20
 7de:	01c85713          	srli	a4,a6,0x1c
 7e2:	9736                	add	a4,a4,a3
 7e4:	02e60563          	beq	a2,a4,80e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7ec:	4790                	lw	a2,8(a5)
 7ee:	02061593          	slli	a1,a2,0x20
 7f2:	01c5d713          	srli	a4,a1,0x1c
 7f6:	973e                	add	a4,a4,a5
 7f8:	02e68263          	beq	a3,a4,81c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7fc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fe:	00001717          	auipc	a4,0x1
 802:	80f73123          	sd	a5,-2046(a4) # 1000 <freep>
}
 806:	60a2                	ld	ra,8(sp)
 808:	6402                	ld	s0,0(sp)
 80a:	0141                	addi	sp,sp,16
 80c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 80e:	4618                	lw	a4,8(a2)
 810:	9f2d                	addw	a4,a4,a1
 812:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	6398                	ld	a4,0(a5)
 818:	6310                	ld	a2,0(a4)
 81a:	b7f9                	j	7e8 <free+0x44>
    p->s.size += bp->s.size;
 81c:	ff852703          	lw	a4,-8(a0)
 820:	9f31                	addw	a4,a4,a2
 822:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 824:	ff053683          	ld	a3,-16(a0)
 828:	bfd1                	j	7fc <free+0x58>

000000000000082a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 82a:	7139                	addi	sp,sp,-64
 82c:	fc06                	sd	ra,56(sp)
 82e:	f822                	sd	s0,48(sp)
 830:	f04a                	sd	s2,32(sp)
 832:	ec4e                	sd	s3,24(sp)
 834:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	02051993          	slli	s3,a0,0x20
 83a:	0209d993          	srli	s3,s3,0x20
 83e:	09bd                	addi	s3,s3,15
 840:	0049d993          	srli	s3,s3,0x4
 844:	2985                	addiw	s3,s3,1
 846:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 848:	00000517          	auipc	a0,0x0
 84c:	7b853503          	ld	a0,1976(a0) # 1000 <freep>
 850:	c905                	beqz	a0,880 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 852:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 854:	4798                	lw	a4,8(a5)
 856:	09377663          	bgeu	a4,s3,8e2 <malloc+0xb8>
 85a:	f426                	sd	s1,40(sp)
 85c:	e852                	sd	s4,16(sp)
 85e:	e456                	sd	s5,8(sp)
 860:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 862:	8a4e                	mv	s4,s3
 864:	6705                	lui	a4,0x1
 866:	00e9f363          	bgeu	s3,a4,86c <malloc+0x42>
 86a:	6a05                	lui	s4,0x1
 86c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 870:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 874:	00000497          	auipc	s1,0x0
 878:	78c48493          	addi	s1,s1,1932 # 1000 <freep>
  if(p == SBRK_ERROR)
 87c:	5afd                	li	s5,-1
 87e:	a83d                	j	8bc <malloc+0x92>
 880:	f426                	sd	s1,40(sp)
 882:	e852                	sd	s4,16(sp)
 884:	e456                	sd	s5,8(sp)
 886:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 888:	00000797          	auipc	a5,0x0
 88c:	78878793          	addi	a5,a5,1928 # 1010 <base>
 890:	00000717          	auipc	a4,0x0
 894:	76f73823          	sd	a5,1904(a4) # 1000 <freep>
 898:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 89e:	b7d1                	j	862 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8a0:	6398                	ld	a4,0(a5)
 8a2:	e118                	sd	a4,0(a0)
 8a4:	a899                	j	8fa <malloc+0xd0>
  hp->s.size = nu;
 8a6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8aa:	0541                	addi	a0,a0,16
 8ac:	ef9ff0ef          	jal	7a4 <free>
  return freep;
 8b0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8b2:	c125                	beqz	a0,912 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b6:	4798                	lw	a4,8(a5)
 8b8:	03277163          	bgeu	a4,s2,8da <malloc+0xb0>
    if(p == freep)
 8bc:	6098                	ld	a4,0(s1)
 8be:	853e                	mv	a0,a5
 8c0:	fef71ae3          	bne	a4,a5,8b4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8c4:	8552                	mv	a0,s4
 8c6:	a0bff0ef          	jal	2d0 <sbrk>
  if(p == SBRK_ERROR)
 8ca:	fd551ee3          	bne	a0,s5,8a6 <malloc+0x7c>
        return 0;
 8ce:	4501                	li	a0,0
 8d0:	74a2                	ld	s1,40(sp)
 8d2:	6a42                	ld	s4,16(sp)
 8d4:	6aa2                	ld	s5,8(sp)
 8d6:	6b02                	ld	s6,0(sp)
 8d8:	a03d                	j	906 <malloc+0xdc>
 8da:	74a2                	ld	s1,40(sp)
 8dc:	6a42                	ld	s4,16(sp)
 8de:	6aa2                	ld	s5,8(sp)
 8e0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8e2:	fae90fe3          	beq	s2,a4,8a0 <malloc+0x76>
        p->s.size -= nunits;
 8e6:	4137073b          	subw	a4,a4,s3
 8ea:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ec:	02071693          	slli	a3,a4,0x20
 8f0:	01c6d713          	srli	a4,a3,0x1c
 8f4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8fa:	00000717          	auipc	a4,0x0
 8fe:	70a73323          	sd	a0,1798(a4) # 1000 <freep>
      return (void*)(p + 1);
 902:	01078513          	addi	a0,a5,16
  }
}
 906:	70e2                	ld	ra,56(sp)
 908:	7442                	ld	s0,48(sp)
 90a:	7902                	ld	s2,32(sp)
 90c:	69e2                	ld	s3,24(sp)
 90e:	6121                	addi	sp,sp,64
 910:	8082                	ret
 912:	74a2                	ld	s1,40(sp)
 914:	6a42                	ld	s4,16(sp)
 916:	6aa2                	ld	s5,8(sp)
 918:	6b02                	ld	s6,0(sp)
 91a:	b7f5                	j	906 <malloc+0xdc>
