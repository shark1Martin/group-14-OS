
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"


int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    kps(argv[1]);
   8:	6588                	ld	a0,8(a1)
   a:	364000ef          	jal	36e <kps>
   e:	4501                	li	a0,0
  10:	60a2                	ld	ra,8(sp)
  12:	6402                	ld	s0,0(sp)
  14:	0141                	addi	sp,sp,16
  16:	8082                	ret

0000000000000018 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  18:	1141                	addi	sp,sp,-16
  1a:	e406                	sd	ra,8(sp)
  1c:	e022                	sd	s0,0(sp)
  1e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  20:	fe1ff0ef          	jal	0 <main>
  exit(r);
  24:	2aa000ef          	jal	2ce <exit>

0000000000000028 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  28:	1141                	addi	sp,sp,-16
  2a:	e406                	sd	ra,8(sp)
  2c:	e022                	sd	s0,0(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0xa>
    ;
  return os;
}
  40:	60a2                	ld	ra,8(sp)
  42:	6402                	ld	s0,0(sp)
  44:	0141                	addi	sp,sp,16
  46:	8082                	ret

0000000000000048 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  48:	1141                	addi	sp,sp,-16
  4a:	e406                	sd	ra,8(sp)
  4c:	e022                	sd	s0,0(sp)
  4e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	cb91                	beqz	a5,68 <strcmp+0x20>
  56:	0005c703          	lbu	a4,0(a1)
  5a:	00f71763          	bne	a4,a5,68 <strcmp+0x20>
    p++, q++;
  5e:	0505                	addi	a0,a0,1
  60:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  62:	00054783          	lbu	a5,0(a0)
  66:	fbe5                	bnez	a5,56 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  68:	0005c503          	lbu	a0,0(a1)
}
  6c:	40a7853b          	subw	a0,a5,a0
  70:	60a2                	ld	ra,8(sp)
  72:	6402                	ld	s0,0(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  80:	00054783          	lbu	a5,0(a0)
  84:	cf91                	beqz	a5,a0 <strlen+0x28>
  86:	00150793          	addi	a5,a0,1
  8a:	86be                	mv	a3,a5
  8c:	0785                	addi	a5,a5,1
  8e:	fff7c703          	lbu	a4,-1(a5)
  92:	ff65                	bnez	a4,8a <strlen+0x12>
  94:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  98:	60a2                	ld	ra,8(sp)
  9a:	6402                	ld	s0,0(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret
  for(n = 0; s[n]; n++)
  a0:	4501                	li	a0,0
  a2:	bfdd                	j	98 <strlen+0x20>

00000000000000a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e406                	sd	ra,8(sp)
  a8:	e022                	sd	s0,0(sp)
  aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ac:	ca19                	beqz	a2,c2 <memset+0x1e>
  ae:	87aa                	mv	a5,a0
  b0:	1602                	slli	a2,a2,0x20
  b2:	9201                	srli	a2,a2,0x20
  b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  bc:	0785                	addi	a5,a5,1
  be:	fee79de3          	bne	a5,a4,b8 <memset+0x14>
  }
  return dst;
}
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strchr>:

char*
strchr(const char *s, char c)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf81                	beqz	a5,ee <strchr+0x24>
    if(*s == c)
  d8:	00f58763          	beq	a1,a5,e6 <strchr+0x1c>
  for(; *s; s++)
  dc:	0505                	addi	a0,a0,1
  de:	00054783          	lbu	a5,0(a0)
  e2:	fbfd                	bnez	a5,d8 <strchr+0xe>
      return (char*)s;
  return 0;
  e4:	4501                	li	a0,0
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret
  return 0;
  ee:	4501                	li	a0,0
  f0:	bfdd                	j	e6 <strchr+0x1c>

00000000000000f2 <gets>:

char*
gets(char *buf, int max)
{
  f2:	711d                	addi	sp,sp,-96
  f4:	ec86                	sd	ra,88(sp)
  f6:	e8a2                	sd	s0,80(sp)
  f8:	e4a6                	sd	s1,72(sp)
  fa:	e0ca                	sd	s2,64(sp)
  fc:	fc4e                	sd	s3,56(sp)
  fe:	f852                	sd	s4,48(sp)
 100:	f456                	sd	s5,40(sp)
 102:	f05a                	sd	s6,32(sp)
 104:	ec5e                	sd	s7,24(sp)
 106:	e862                	sd	s8,16(sp)
 108:	1080                	addi	s0,sp,96
 10a:	8baa                	mv	s7,a0
 10c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10e:	892a                	mv	s2,a0
 110:	4481                	li	s1,0
    cc = read(0, &c, 1);
 112:	faf40b13          	addi	s6,s0,-81
 116:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 118:	8c26                	mv	s8,s1
 11a:	0014899b          	addiw	s3,s1,1
 11e:	84ce                	mv	s1,s3
 120:	0349d463          	bge	s3,s4,148 <gets+0x56>
    cc = read(0, &c, 1);
 124:	8656                	mv	a2,s5
 126:	85da                	mv	a1,s6
 128:	4501                	li	a0,0
 12a:	1bc000ef          	jal	2e6 <read>
    if(cc < 1)
 12e:	00a05d63          	blez	a0,148 <gets+0x56>
      break;
    buf[i++] = c;
 132:	faf44783          	lbu	a5,-81(s0)
 136:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13a:	0905                	addi	s2,s2,1
 13c:	ff678713          	addi	a4,a5,-10
 140:	c319                	beqz	a4,146 <gets+0x54>
 142:	17cd                	addi	a5,a5,-13
 144:	fbf1                	bnez	a5,118 <gets+0x26>
    buf[i++] = c;
 146:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 148:	9c5e                	add	s8,s8,s7
 14a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 14e:	855e                	mv	a0,s7
 150:	60e6                	ld	ra,88(sp)
 152:	6446                	ld	s0,80(sp)
 154:	64a6                	ld	s1,72(sp)
 156:	6906                	ld	s2,64(sp)
 158:	79e2                	ld	s3,56(sp)
 15a:	7a42                	ld	s4,48(sp)
 15c:	7aa2                	ld	s5,40(sp)
 15e:	7b02                	ld	s6,32(sp)
 160:	6be2                	ld	s7,24(sp)
 162:	6c42                	ld	s8,16(sp)
 164:	6125                	addi	sp,sp,96
 166:	8082                	ret

0000000000000168 <stat>:

int
stat(const char *n, struct stat *st)
{
 168:	1101                	addi	sp,sp,-32
 16a:	ec06                	sd	ra,24(sp)
 16c:	e822                	sd	s0,16(sp)
 16e:	e04a                	sd	s2,0(sp)
 170:	1000                	addi	s0,sp,32
 172:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 174:	4581                	li	a1,0
 176:	198000ef          	jal	30e <open>
  if(fd < 0)
 17a:	02054263          	bltz	a0,19e <stat+0x36>
 17e:	e426                	sd	s1,8(sp)
 180:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 182:	85ca                	mv	a1,s2
 184:	1a2000ef          	jal	326 <fstat>
 188:	892a                	mv	s2,a0
  close(fd);
 18a:	8526                	mv	a0,s1
 18c:	16a000ef          	jal	2f6 <close>
  return r;
 190:	64a2                	ld	s1,8(sp)
}
 192:	854a                	mv	a0,s2
 194:	60e2                	ld	ra,24(sp)
 196:	6442                	ld	s0,16(sp)
 198:	6902                	ld	s2,0(sp)
 19a:	6105                	addi	sp,sp,32
 19c:	8082                	ret
    return -1;
 19e:	57fd                	li	a5,-1
 1a0:	893e                	mv	s2,a5
 1a2:	bfc5                	j	192 <stat+0x2a>

00000000000001a4 <atoi>:

int
atoi(const char *s)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e406                	sd	ra,8(sp)
 1a8:	e022                	sd	s0,0(sp)
 1aa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ac:	00054683          	lbu	a3,0(a0)
 1b0:	fd06879b          	addiw	a5,a3,-48
 1b4:	0ff7f793          	zext.b	a5,a5
 1b8:	4625                	li	a2,9
 1ba:	02f66963          	bltu	a2,a5,1ec <atoi+0x48>
 1be:	872a                	mv	a4,a0
  n = 0;
 1c0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c2:	0705                	addi	a4,a4,1
 1c4:	0025179b          	slliw	a5,a0,0x2
 1c8:	9fa9                	addw	a5,a5,a0
 1ca:	0017979b          	slliw	a5,a5,0x1
 1ce:	9fb5                	addw	a5,a5,a3
 1d0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d4:	00074683          	lbu	a3,0(a4)
 1d8:	fd06879b          	addiw	a5,a3,-48
 1dc:	0ff7f793          	zext.b	a5,a5
 1e0:	fef671e3          	bgeu	a2,a5,1c2 <atoi+0x1e>
  return n;
}
 1e4:	60a2                	ld	ra,8(sp)
 1e6:	6402                	ld	s0,0(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
  n = 0;
 1ec:	4501                	li	a0,0
 1ee:	bfdd                	j	1e4 <atoi+0x40>

00000000000001f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e406                	sd	ra,8(sp)
 1f4:	e022                	sd	s0,0(sp)
 1f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f8:	02b57563          	bgeu	a0,a1,222 <memmove+0x32>
    while(n-- > 0)
 1fc:	00c05f63          	blez	a2,21a <memmove+0x2a>
 200:	1602                	slli	a2,a2,0x20
 202:	9201                	srli	a2,a2,0x20
 204:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 208:	872a                	mv	a4,a0
      *dst++ = *src++;
 20a:	0585                	addi	a1,a1,1
 20c:	0705                	addi	a4,a4,1
 20e:	fff5c683          	lbu	a3,-1(a1)
 212:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 216:	fee79ae3          	bne	a5,a4,20a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 21a:	60a2                	ld	ra,8(sp)
 21c:	6402                	ld	s0,0(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
    while(n-- > 0)
 222:	fec05ce3          	blez	a2,21a <memmove+0x2a>
    dst += n;
 226:	00c50733          	add	a4,a0,a2
    src += n;
 22a:	95b2                	add	a1,a1,a2
 22c:	fff6079b          	addiw	a5,a2,-1
 230:	1782                	slli	a5,a5,0x20
 232:	9381                	srli	a5,a5,0x20
 234:	fff7c793          	not	a5,a5
 238:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 23a:	15fd                	addi	a1,a1,-1
 23c:	177d                	addi	a4,a4,-1
 23e:	0005c683          	lbu	a3,0(a1)
 242:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 246:	fef71ae3          	bne	a4,a5,23a <memmove+0x4a>
 24a:	bfc1                	j	21a <memmove+0x2a>

000000000000024c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 254:	c61d                	beqz	a2,282 <memcmp+0x36>
 256:	1602                	slli	a2,a2,0x20
 258:	9201                	srli	a2,a2,0x20
 25a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 25e:	00054783          	lbu	a5,0(a0)
 262:	0005c703          	lbu	a4,0(a1)
 266:	00e79863          	bne	a5,a4,276 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 26a:	0505                	addi	a0,a0,1
    p2++;
 26c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26e:	fed518e3          	bne	a0,a3,25e <memcmp+0x12>
  }
  return 0;
 272:	4501                	li	a0,0
 274:	a019                	j	27a <memcmp+0x2e>
      return *p1 - *p2;
 276:	40e7853b          	subw	a0,a5,a4
}
 27a:	60a2                	ld	ra,8(sp)
 27c:	6402                	ld	s0,0(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret
  return 0;
 282:	4501                	li	a0,0
 284:	bfdd                	j	27a <memcmp+0x2e>

0000000000000286 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 28e:	f63ff0ef          	jal	1f0 <memmove>
}
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret

000000000000029a <sbrk>:

char *
sbrk(int n) {
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2a2:	4585                	li	a1,1
 2a4:	0b2000ef          	jal	356 <sys_sbrk>
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <sbrklazy>:

char *
sbrklazy(int n) {
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2b8:	4589                	li	a1,2
 2ba:	09c000ef          	jal	356 <sys_sbrk>
}
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c6:	4885                	li	a7,1
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ce:	4889                	li	a7,2
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d6:	488d                	li	a7,3
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2de:	4891                	li	a7,4
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <read>:
.global read
read:
 li a7, SYS_read
 2e6:	4895                	li	a7,5
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <write>:
.global write
write:
 li a7, SYS_write
 2ee:	48c1                	li	a7,16
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <close>:
.global close
close:
 li a7, SYS_close
 2f6:	48d5                	li	a7,21
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 2fe:	4899                	li	a7,6
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <exec>:
.global exec
exec:
 li a7, SYS_exec
 306:	489d                	li	a7,7
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <open>:
.global open
open:
 li a7, SYS_open
 30e:	48bd                	li	a7,15
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 316:	48c5                	li	a7,17
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 31e:	48c9                	li	a7,18
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 326:	48a1                	li	a7,8
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <link>:
.global link
link:
 li a7, SYS_link
 32e:	48cd                	li	a7,19
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 336:	48d1                	li	a7,20
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 33e:	48a5                	li	a7,9
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <dup>:
.global dup
dup:
 li a7, SYS_dup
 346:	48a9                	li	a7,10
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 34e:	48ad                	li	a7,11
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 356:	48b1                	li	a7,12
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <pause>:
.global pause
pause:
 li a7, SYS_pause
 35e:	48b5                	li	a7,13
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 366:	48b9                	li	a7,14
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <kps>:
.global kps
kps:
 li a7, SYS_kps
 36e:	48d9                	li	a7,22
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 376:	48dd                	li	a7,23
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 37e:	48e1                	li	a7,24
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 386:	48e5                	li	a7,25
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 38e:	48e9                	li	a7,26
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 396:	1101                	addi	sp,sp,-32
 398:	ec06                	sd	ra,24(sp)
 39a:	e822                	sd	s0,16(sp)
 39c:	1000                	addi	s0,sp,32
 39e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a2:	4605                	li	a2,1
 3a4:	fef40593          	addi	a1,s0,-17
 3a8:	f47ff0ef          	jal	2ee <write>
}
 3ac:	60e2                	ld	ra,24(sp)
 3ae:	6442                	ld	s0,16(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret

00000000000003b4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3b4:	715d                	addi	sp,sp,-80
 3b6:	e486                	sd	ra,72(sp)
 3b8:	e0a2                	sd	s0,64(sp)
 3ba:	f84a                	sd	s2,48(sp)
 3bc:	f44e                	sd	s3,40(sp)
 3be:	0880                	addi	s0,sp,80
 3c0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3c2:	c6d1                	beqz	a3,44e <printint+0x9a>
 3c4:	0805d563          	bgez	a1,44e <printint+0x9a>
    neg = 1;
    x = -xx;
 3c8:	40b005b3          	neg	a1,a1
    neg = 1;
 3cc:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3ce:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3d2:	86ce                	mv	a3,s3
  i = 0;
 3d4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d6:	00000817          	auipc	a6,0x0
 3da:	52280813          	addi	a6,a6,1314 # 8f8 <digits>
 3de:	88ba                	mv	a7,a4
 3e0:	0017051b          	addiw	a0,a4,1
 3e4:	872a                	mv	a4,a0
 3e6:	02c5f7b3          	remu	a5,a1,a2
 3ea:	97c2                	add	a5,a5,a6
 3ec:	0007c783          	lbu	a5,0(a5)
 3f0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f4:	87ae                	mv	a5,a1
 3f6:	02c5d5b3          	divu	a1,a1,a2
 3fa:	0685                	addi	a3,a3,1
 3fc:	fec7f1e3          	bgeu	a5,a2,3de <printint+0x2a>
  if(neg)
 400:	00030c63          	beqz	t1,418 <printint+0x64>
    buf[i++] = '-';
 404:	fd050793          	addi	a5,a0,-48
 408:	00878533          	add	a0,a5,s0
 40c:	02d00793          	li	a5,45
 410:	fef50423          	sb	a5,-24(a0)
 414:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 418:	02e05563          	blez	a4,442 <printint+0x8e>
 41c:	fc26                	sd	s1,56(sp)
 41e:	377d                	addiw	a4,a4,-1
 420:	00e984b3          	add	s1,s3,a4
 424:	19fd                	addi	s3,s3,-1
 426:	99ba                	add	s3,s3,a4
 428:	1702                	slli	a4,a4,0x20
 42a:	9301                	srli	a4,a4,0x20
 42c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 430:	0004c583          	lbu	a1,0(s1)
 434:	854a                	mv	a0,s2
 436:	f61ff0ef          	jal	396 <putc>
  while(--i >= 0)
 43a:	14fd                	addi	s1,s1,-1
 43c:	ff349ae3          	bne	s1,s3,430 <printint+0x7c>
 440:	74e2                	ld	s1,56(sp)
}
 442:	60a6                	ld	ra,72(sp)
 444:	6406                	ld	s0,64(sp)
 446:	7942                	ld	s2,48(sp)
 448:	79a2                	ld	s3,40(sp)
 44a:	6161                	addi	sp,sp,80
 44c:	8082                	ret
  neg = 0;
 44e:	4301                	li	t1,0
 450:	bfbd                	j	3ce <printint+0x1a>

0000000000000452 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 452:	711d                	addi	sp,sp,-96
 454:	ec86                	sd	ra,88(sp)
 456:	e8a2                	sd	s0,80(sp)
 458:	e4a6                	sd	s1,72(sp)
 45a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45c:	0005c483          	lbu	s1,0(a1)
 460:	22048363          	beqz	s1,686 <vprintf+0x234>
 464:	e0ca                	sd	s2,64(sp)
 466:	fc4e                	sd	s3,56(sp)
 468:	f852                	sd	s4,48(sp)
 46a:	f456                	sd	s5,40(sp)
 46c:	f05a                	sd	s6,32(sp)
 46e:	ec5e                	sd	s7,24(sp)
 470:	e862                	sd	s8,16(sp)
 472:	8b2a                	mv	s6,a0
 474:	8a2e                	mv	s4,a1
 476:	8bb2                	mv	s7,a2
  state = 0;
 478:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 47a:	4901                	li	s2,0
 47c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 47e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 482:	06400c13          	li	s8,100
 486:	a00d                	j	4a8 <vprintf+0x56>
        putc(fd, c0);
 488:	85a6                	mv	a1,s1
 48a:	855a                	mv	a0,s6
 48c:	f0bff0ef          	jal	396 <putc>
 490:	a019                	j	496 <vprintf+0x44>
    } else if(state == '%'){
 492:	03598363          	beq	s3,s5,4b8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 496:	0019079b          	addiw	a5,s2,1
 49a:	893e                	mv	s2,a5
 49c:	873e                	mv	a4,a5
 49e:	97d2                	add	a5,a5,s4
 4a0:	0007c483          	lbu	s1,0(a5)
 4a4:	1c048a63          	beqz	s1,678 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4a8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ac:	fe0993e3          	bnez	s3,492 <vprintf+0x40>
      if(c0 == '%'){
 4b0:	fd579ce3          	bne	a5,s5,488 <vprintf+0x36>
        state = '%';
 4b4:	89be                	mv	s3,a5
 4b6:	b7c5                	j	496 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4b8:	00ea06b3          	add	a3,s4,a4
 4bc:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4c0:	1c060863          	beqz	a2,690 <vprintf+0x23e>
      if(c0 == 'd'){
 4c4:	03878763          	beq	a5,s8,4f2 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c8:	f9478693          	addi	a3,a5,-108
 4cc:	0016b693          	seqz	a3,a3
 4d0:	f9c60593          	addi	a1,a2,-100
 4d4:	e99d                	bnez	a1,50a <vprintf+0xb8>
 4d6:	ca95                	beqz	a3,50a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4d8:	008b8493          	addi	s1,s7,8
 4dc:	4685                	li	a3,1
 4de:	4629                	li	a2,10
 4e0:	000bb583          	ld	a1,0(s7)
 4e4:	855a                	mv	a0,s6
 4e6:	ecfff0ef          	jal	3b4 <printint>
        i += 1;
 4ea:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ec:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4ee:	4981                	li	s3,0
 4f0:	b75d                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4f2:	008b8493          	addi	s1,s7,8
 4f6:	4685                	li	a3,1
 4f8:	4629                	li	a2,10
 4fa:	000ba583          	lw	a1,0(s7)
 4fe:	855a                	mv	a0,s6
 500:	eb5ff0ef          	jal	3b4 <printint>
 504:	8ba6                	mv	s7,s1
      state = 0;
 506:	4981                	li	s3,0
 508:	b779                	j	496 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 50a:	9752                	add	a4,a4,s4
 50c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 510:	f9460713          	addi	a4,a2,-108
 514:	00173713          	seqz	a4,a4
 518:	8f75                	and	a4,a4,a3
 51a:	f9c58513          	addi	a0,a1,-100
 51e:	18051363          	bnez	a0,6a4 <vprintf+0x252>
 522:	18070163          	beqz	a4,6a4 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 526:	008b8493          	addi	s1,s7,8
 52a:	4685                	li	a3,1
 52c:	4629                	li	a2,10
 52e:	000bb583          	ld	a1,0(s7)
 532:	855a                	mv	a0,s6
 534:	e81ff0ef          	jal	3b4 <printint>
        i += 2;
 538:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 53a:	8ba6                	mv	s7,s1
      state = 0;
 53c:	4981                	li	s3,0
        i += 2;
 53e:	bfa1                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 540:	008b8493          	addi	s1,s7,8
 544:	4681                	li	a3,0
 546:	4629                	li	a2,10
 548:	000be583          	lwu	a1,0(s7)
 54c:	855a                	mv	a0,s6
 54e:	e67ff0ef          	jal	3b4 <printint>
 552:	8ba6                	mv	s7,s1
      state = 0;
 554:	4981                	li	s3,0
 556:	b781                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 558:	008b8493          	addi	s1,s7,8
 55c:	4681                	li	a3,0
 55e:	4629                	li	a2,10
 560:	000bb583          	ld	a1,0(s7)
 564:	855a                	mv	a0,s6
 566:	e4fff0ef          	jal	3b4 <printint>
        i += 1;
 56a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 56c:	8ba6                	mv	s7,s1
      state = 0;
 56e:	4981                	li	s3,0
 570:	b71d                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 572:	008b8493          	addi	s1,s7,8
 576:	4681                	li	a3,0
 578:	4629                	li	a2,10
 57a:	000bb583          	ld	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e35ff0ef          	jal	3b4 <printint>
        i += 2;
 584:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
        i += 2;
 58a:	b731                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 58c:	008b8493          	addi	s1,s7,8
 590:	4681                	li	a3,0
 592:	4641                	li	a2,16
 594:	000be583          	lwu	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e1bff0ef          	jal	3b4 <printint>
 59e:	8ba6                	mv	s7,s1
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bdd5                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4641                	li	a2,16
 5ac:	000bb583          	ld	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e03ff0ef          	jal	3b4 <printint>
        i += 1;
 5b6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	8ba6                	mv	s7,s1
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bde9                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4641                	li	a2,16
 5c6:	000bb583          	ld	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	de9ff0ef          	jal	3b4 <printint>
        i += 2;
 5d0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
        i += 2;
 5d6:	b5c1                	j	496 <vprintf+0x44>
 5d8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5da:	008b8793          	addi	a5,s7,8
 5de:	8cbe                	mv	s9,a5
 5e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e4:	03000593          	li	a1,48
 5e8:	855a                	mv	a0,s6
 5ea:	dadff0ef          	jal	396 <putc>
  putc(fd, 'x');
 5ee:	07800593          	li	a1,120
 5f2:	855a                	mv	a0,s6
 5f4:	da3ff0ef          	jal	396 <putc>
 5f8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fa:	00000b97          	auipc	s7,0x0
 5fe:	2feb8b93          	addi	s7,s7,766 # 8f8 <digits>
 602:	03c9d793          	srli	a5,s3,0x3c
 606:	97de                	add	a5,a5,s7
 608:	0007c583          	lbu	a1,0(a5)
 60c:	855a                	mv	a0,s6
 60e:	d89ff0ef          	jal	396 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 612:	0992                	slli	s3,s3,0x4
 614:	34fd                	addiw	s1,s1,-1
 616:	f4f5                	bnez	s1,602 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 618:	8be6                	mv	s7,s9
      state = 0;
 61a:	4981                	li	s3,0
 61c:	6ca2                	ld	s9,8(sp)
 61e:	bda5                	j	496 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 620:	008b8493          	addi	s1,s7,8
 624:	000bc583          	lbu	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	d6dff0ef          	jal	396 <putc>
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
 632:	b595                	j	496 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 634:	008b8993          	addi	s3,s7,8
 638:	000bb483          	ld	s1,0(s7)
 63c:	cc91                	beqz	s1,658 <vprintf+0x206>
        for(; *s; s++)
 63e:	0004c583          	lbu	a1,0(s1)
 642:	c985                	beqz	a1,672 <vprintf+0x220>
          putc(fd, *s);
 644:	855a                	mv	a0,s6
 646:	d51ff0ef          	jal	396 <putc>
        for(; *s; s++)
 64a:	0485                	addi	s1,s1,1
 64c:	0004c583          	lbu	a1,0(s1)
 650:	f9f5                	bnez	a1,644 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 652:	8bce                	mv	s7,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	b581                	j	496 <vprintf+0x44>
          s = "(null)";
 658:	00000497          	auipc	s1,0x0
 65c:	29848493          	addi	s1,s1,664 # 8f0 <malloc+0xfc>
        for(; *s; s++)
 660:	02800593          	li	a1,40
 664:	b7c5                	j	644 <vprintf+0x1f2>
        putc(fd, '%');
 666:	85be                	mv	a1,a5
 668:	855a                	mv	a0,s6
 66a:	d2dff0ef          	jal	396 <putc>
      state = 0;
 66e:	4981                	li	s3,0
 670:	b51d                	j	496 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 672:	8bce                	mv	s7,s3
      state = 0;
 674:	4981                	li	s3,0
 676:	b505                	j	496 <vprintf+0x44>
 678:	6906                	ld	s2,64(sp)
 67a:	79e2                	ld	s3,56(sp)
 67c:	7a42                	ld	s4,48(sp)
 67e:	7aa2                	ld	s5,40(sp)
 680:	7b02                	ld	s6,32(sp)
 682:	6be2                	ld	s7,24(sp)
 684:	6c42                	ld	s8,16(sp)
    }
  }
}
 686:	60e6                	ld	ra,88(sp)
 688:	6446                	ld	s0,80(sp)
 68a:	64a6                	ld	s1,72(sp)
 68c:	6125                	addi	sp,sp,96
 68e:	8082                	ret
      if(c0 == 'd'){
 690:	06400713          	li	a4,100
 694:	e4e78fe3          	beq	a5,a4,4f2 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 698:	f9478693          	addi	a3,a5,-108
 69c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6a0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6a4:	07500513          	li	a0,117
 6a8:	e8a78ce3          	beq	a5,a0,540 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6ac:	f8b60513          	addi	a0,a2,-117
 6b0:	e119                	bnez	a0,6b6 <vprintf+0x264>
 6b2:	ea0693e3          	bnez	a3,558 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6b6:	f8b58513          	addi	a0,a1,-117
 6ba:	e119                	bnez	a0,6c0 <vprintf+0x26e>
 6bc:	ea071be3          	bnez	a4,572 <vprintf+0x120>
      } else if(c0 == 'x'){
 6c0:	07800513          	li	a0,120
 6c4:	eca784e3          	beq	a5,a0,58c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6c8:	f8860613          	addi	a2,a2,-120
 6cc:	e219                	bnez	a2,6d2 <vprintf+0x280>
 6ce:	ec069be3          	bnez	a3,5a4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6d2:	f8858593          	addi	a1,a1,-120
 6d6:	e199                	bnez	a1,6dc <vprintf+0x28a>
 6d8:	ee0713e3          	bnez	a4,5be <vprintf+0x16c>
      } else if(c0 == 'p'){
 6dc:	07000713          	li	a4,112
 6e0:	eee78ce3          	beq	a5,a4,5d8 <vprintf+0x186>
      } else if(c0 == 'c'){
 6e4:	06300713          	li	a4,99
 6e8:	f2e78ce3          	beq	a5,a4,620 <vprintf+0x1ce>
      } else if(c0 == 's'){
 6ec:	07300713          	li	a4,115
 6f0:	f4e782e3          	beq	a5,a4,634 <vprintf+0x1e2>
      } else if(c0 == '%'){
 6f4:	02500713          	li	a4,37
 6f8:	f6e787e3          	beq	a5,a4,666 <vprintf+0x214>
        putc(fd, '%');
 6fc:	02500593          	li	a1,37
 700:	855a                	mv	a0,s6
 702:	c95ff0ef          	jal	396 <putc>
        putc(fd, c0);
 706:	85a6                	mv	a1,s1
 708:	855a                	mv	a0,s6
 70a:	c8dff0ef          	jal	396 <putc>
      state = 0;
 70e:	4981                	li	s3,0
 710:	b359                	j	496 <vprintf+0x44>

0000000000000712 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 712:	715d                	addi	sp,sp,-80
 714:	ec06                	sd	ra,24(sp)
 716:	e822                	sd	s0,16(sp)
 718:	1000                	addi	s0,sp,32
 71a:	e010                	sd	a2,0(s0)
 71c:	e414                	sd	a3,8(s0)
 71e:	e818                	sd	a4,16(s0)
 720:	ec1c                	sd	a5,24(s0)
 722:	03043023          	sd	a6,32(s0)
 726:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 72a:	8622                	mv	a2,s0
 72c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 730:	d23ff0ef          	jal	452 <vprintf>
}
 734:	60e2                	ld	ra,24(sp)
 736:	6442                	ld	s0,16(sp)
 738:	6161                	addi	sp,sp,80
 73a:	8082                	ret

000000000000073c <printf>:

void
printf(const char *fmt, ...)
{
 73c:	711d                	addi	sp,sp,-96
 73e:	ec06                	sd	ra,24(sp)
 740:	e822                	sd	s0,16(sp)
 742:	1000                	addi	s0,sp,32
 744:	e40c                	sd	a1,8(s0)
 746:	e810                	sd	a2,16(s0)
 748:	ec14                	sd	a3,24(s0)
 74a:	f018                	sd	a4,32(s0)
 74c:	f41c                	sd	a5,40(s0)
 74e:	03043823          	sd	a6,48(s0)
 752:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 756:	00840613          	addi	a2,s0,8
 75a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75e:	85aa                	mv	a1,a0
 760:	4505                	li	a0,1
 762:	cf1ff0ef          	jal	452 <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76e:	1141                	addi	sp,sp,-16
 770:	e406                	sd	ra,8(sp)
 772:	e022                	sd	s0,0(sp)
 774:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 776:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	00001797          	auipc	a5,0x1
 77e:	8867b783          	ld	a5,-1914(a5) # 1000 <freep>
 782:	a039                	j	790 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	6398                	ld	a4,0(a5)
 786:	00e7e463          	bltu	a5,a4,78e <free+0x20>
 78a:	00e6ea63          	bltu	a3,a4,79e <free+0x30>
{
 78e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	fed7fae3          	bgeu	a5,a3,784 <free+0x16>
 794:	6398                	ld	a4,0(a5)
 796:	00e6e463          	bltu	a3,a4,79e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	fee7eae3          	bltu	a5,a4,78e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 79e:	ff852583          	lw	a1,-8(a0)
 7a2:	6390                	ld	a2,0(a5)
 7a4:	02059813          	slli	a6,a1,0x20
 7a8:	01c85713          	srli	a4,a6,0x1c
 7ac:	9736                	add	a4,a4,a3
 7ae:	02e60563          	beq	a2,a4,7d8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7b6:	4790                	lw	a2,8(a5)
 7b8:	02061593          	slli	a1,a2,0x20
 7bc:	01c5d713          	srli	a4,a1,0x1c
 7c0:	973e                	add	a4,a4,a5
 7c2:	02e68263          	beq	a3,a4,7e6 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c8:	00001717          	auipc	a4,0x1
 7cc:	82f73c23          	sd	a5,-1992(a4) # 1000 <freep>
}
 7d0:	60a2                	ld	ra,8(sp)
 7d2:	6402                	ld	s0,0(sp)
 7d4:	0141                	addi	sp,sp,16
 7d6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7d8:	4618                	lw	a4,8(a2)
 7da:	9f2d                	addw	a4,a4,a1
 7dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	6398                	ld	a4,0(a5)
 7e2:	6310                	ld	a2,0(a4)
 7e4:	b7f9                	j	7b2 <free+0x44>
    p->s.size += bp->s.size;
 7e6:	ff852703          	lw	a4,-8(a0)
 7ea:	9f31                	addw	a4,a4,a2
 7ec:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ee:	ff053683          	ld	a3,-16(a0)
 7f2:	bfd1                	j	7c6 <free+0x58>

00000000000007f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f4:	7139                	addi	sp,sp,-64
 7f6:	fc06                	sd	ra,56(sp)
 7f8:	f822                	sd	s0,48(sp)
 7fa:	f04a                	sd	s2,32(sp)
 7fc:	ec4e                	sd	s3,24(sp)
 7fe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 800:	02051993          	slli	s3,a0,0x20
 804:	0209d993          	srli	s3,s3,0x20
 808:	09bd                	addi	s3,s3,15
 80a:	0049d993          	srli	s3,s3,0x4
 80e:	2985                	addiw	s3,s3,1
 810:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 812:	00000517          	auipc	a0,0x0
 816:	7ee53503          	ld	a0,2030(a0) # 1000 <freep>
 81a:	c905                	beqz	a0,84a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81e:	4798                	lw	a4,8(a5)
 820:	09377663          	bgeu	a4,s3,8ac <malloc+0xb8>
 824:	f426                	sd	s1,40(sp)
 826:	e852                	sd	s4,16(sp)
 828:	e456                	sd	s5,8(sp)
 82a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 82c:	8a4e                	mv	s4,s3
 82e:	6705                	lui	a4,0x1
 830:	00e9f363          	bgeu	s3,a4,836 <malloc+0x42>
 834:	6a05                	lui	s4,0x1
 836:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83e:	00000497          	auipc	s1,0x0
 842:	7c248493          	addi	s1,s1,1986 # 1000 <freep>
  if(p == SBRK_ERROR)
 846:	5afd                	li	s5,-1
 848:	a83d                	j	886 <malloc+0x92>
 84a:	f426                	sd	s1,40(sp)
 84c:	e852                	sd	s4,16(sp)
 84e:	e456                	sd	s5,8(sp)
 850:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 852:	00000797          	auipc	a5,0x0
 856:	7be78793          	addi	a5,a5,1982 # 1010 <base>
 85a:	00000717          	auipc	a4,0x0
 85e:	7af73323          	sd	a5,1958(a4) # 1000 <freep>
 862:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 864:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 868:	b7d1                	j	82c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 86a:	6398                	ld	a4,0(a5)
 86c:	e118                	sd	a4,0(a0)
 86e:	a899                	j	8c4 <malloc+0xd0>
  hp->s.size = nu;
 870:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 874:	0541                	addi	a0,a0,16
 876:	ef9ff0ef          	jal	76e <free>
  return freep;
 87a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 87c:	c125                	beqz	a0,8dc <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 880:	4798                	lw	a4,8(a5)
 882:	03277163          	bgeu	a4,s2,8a4 <malloc+0xb0>
    if(p == freep)
 886:	6098                	ld	a4,0(s1)
 888:	853e                	mv	a0,a5
 88a:	fef71ae3          	bne	a4,a5,87e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 88e:	8552                	mv	a0,s4
 890:	a0bff0ef          	jal	29a <sbrk>
  if(p == SBRK_ERROR)
 894:	fd551ee3          	bne	a0,s5,870 <malloc+0x7c>
        return 0;
 898:	4501                	li	a0,0
 89a:	74a2                	ld	s1,40(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
 8a2:	a03d                	j	8d0 <malloc+0xdc>
 8a4:	74a2                	ld	s1,40(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ac:	fae90fe3          	beq	s2,a4,86a <malloc+0x76>
        p->s.size -= nunits;
 8b0:	4137073b          	subw	a4,a4,s3
 8b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b6:	02071693          	slli	a3,a4,0x20
 8ba:	01c6d713          	srli	a4,a3,0x1c
 8be:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c4:	00000717          	auipc	a4,0x0
 8c8:	72a73e23          	sd	a0,1852(a4) # 1000 <freep>
      return (void*)(p + 1);
 8cc:	01078513          	addi	a0,a5,16
  }
}
 8d0:	70e2                	ld	ra,56(sp)
 8d2:	7442                	ld	s0,48(sp)
 8d4:	7902                	ld	s2,32(sp)
 8d6:	69e2                	ld	s3,24(sp)
 8d8:	6121                	addi	sp,sp,64
 8da:	8082                	ret
 8dc:	74a2                	ld	s1,40(sp)
 8de:	6a42                	ld	s4,16(sp)
 8e0:	6aa2                	ld	s5,8(sp)
 8e2:	6b02                	ld	s6,0(sp)
 8e4:	b7f5                	j	8d0 <malloc+0xdc>
