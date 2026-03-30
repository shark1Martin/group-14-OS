
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
   a:	342000ef          	jal	34c <kps>
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
  24:	288000ef          	jal	2ac <exit>

0000000000000028 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  28:	1141                	addi	sp,sp,-16
  2a:	e422                	sd	s0,8(sp)
  2c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2e:	87aa                	mv	a5,a0
  30:	0585                	addi	a1,a1,1
  32:	0785                	addi	a5,a5,1
  34:	fff5c703          	lbu	a4,-1(a1)
  38:	fee78fa3          	sb	a4,-1(a5)
  3c:	fb75                	bnez	a4,30 <strcpy+0x8>
    ;
  return os;
}
  3e:	6422                	ld	s0,8(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x1e>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x1e>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	6422                	ld	s0,8(sp)
  6c:	0141                	addi	sp,sp,16
  6e:	8082                	ret

0000000000000070 <strlen>:

uint
strlen(const char *s)
{
  70:	1141                	addi	sp,sp,-16
  72:	e422                	sd	s0,8(sp)
  74:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  76:	00054783          	lbu	a5,0(a0)
  7a:	cf91                	beqz	a5,96 <strlen+0x26>
  7c:	0505                	addi	a0,a0,1
  7e:	87aa                	mv	a5,a0
  80:	86be                	mv	a3,a5
  82:	0785                	addi	a5,a5,1
  84:	fff7c703          	lbu	a4,-1(a5)
  88:	ff65                	bnez	a4,80 <strlen+0x10>
  8a:	40a6853b          	subw	a0,a3,a0
  8e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret
  for(n = 0; s[n]; n++)
  96:	4501                	li	a0,0
  98:	bfe5                	j	90 <strlen+0x20>

000000000000009a <memset>:

void*
memset(void *dst, int c, uint n)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a0:	ca19                	beqz	a2,b6 <memset+0x1c>
  a2:	87aa                	mv	a5,a0
  a4:	1602                	slli	a2,a2,0x20
  a6:	9201                	srli	a2,a2,0x20
  a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b0:	0785                	addi	a5,a5,1
  b2:	fee79de3          	bne	a5,a4,ac <memset+0x12>
  }
  return dst;
}
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strchr>:

char*
strchr(const char *s, char c)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cb99                	beqz	a5,dc <strchr+0x20>
    if(*s == c)
  c8:	00f58763          	beq	a1,a5,d6 <strchr+0x1a>
  for(; *s; s++)
  cc:	0505                	addi	a0,a0,1
  ce:	00054783          	lbu	a5,0(a0)
  d2:	fbfd                	bnez	a5,c8 <strchr+0xc>
      return (char*)s;
  return 0;
  d4:	4501                	li	a0,0
}
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret
  return 0;
  dc:	4501                	li	a0,0
  de:	bfe5                	j	d6 <strchr+0x1a>

00000000000000e0 <gets>:

char*
gets(char *buf, int max)
{
  e0:	711d                	addi	sp,sp,-96
  e2:	ec86                	sd	ra,88(sp)
  e4:	e8a2                	sd	s0,80(sp)
  e6:	e4a6                	sd	s1,72(sp)
  e8:	e0ca                	sd	s2,64(sp)
  ea:	fc4e                	sd	s3,56(sp)
  ec:	f852                	sd	s4,48(sp)
  ee:	f456                	sd	s5,40(sp)
  f0:	f05a                	sd	s6,32(sp)
  f2:	ec5e                	sd	s7,24(sp)
  f4:	1080                	addi	s0,sp,96
  f6:	8baa                	mv	s7,a0
  f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fa:	892a                	mv	s2,a0
  fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  fe:	4aa9                	li	s5,10
 100:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 102:	89a6                	mv	s3,s1
 104:	2485                	addiw	s1,s1,1
 106:	0344d663          	bge	s1,s4,132 <gets+0x52>
    cc = read(0, &c, 1);
 10a:	4605                	li	a2,1
 10c:	faf40593          	addi	a1,s0,-81
 110:	4501                	li	a0,0
 112:	1b2000ef          	jal	2c4 <read>
    if(cc < 1)
 116:	00a05e63          	blez	a0,132 <gets+0x52>
    buf[i++] = c;
 11a:	faf44783          	lbu	a5,-81(s0)
 11e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 122:	01578763          	beq	a5,s5,130 <gets+0x50>
 126:	0905                	addi	s2,s2,1
 128:	fd679de3          	bne	a5,s6,102 <gets+0x22>
    buf[i++] = c;
 12c:	89a6                	mv	s3,s1
 12e:	a011                	j	132 <gets+0x52>
 130:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 132:	99de                	add	s3,s3,s7
 134:	00098023          	sb	zero,0(s3)
  return buf;
}
 138:	855e                	mv	a0,s7
 13a:	60e6                	ld	ra,88(sp)
 13c:	6446                	ld	s0,80(sp)
 13e:	64a6                	ld	s1,72(sp)
 140:	6906                	ld	s2,64(sp)
 142:	79e2                	ld	s3,56(sp)
 144:	7a42                	ld	s4,48(sp)
 146:	7aa2                	ld	s5,40(sp)
 148:	7b02                	ld	s6,32(sp)
 14a:	6be2                	ld	s7,24(sp)
 14c:	6125                	addi	sp,sp,96
 14e:	8082                	ret

0000000000000150 <stat>:

int
stat(const char *n, struct stat *st)
{
 150:	1101                	addi	sp,sp,-32
 152:	ec06                	sd	ra,24(sp)
 154:	e822                	sd	s0,16(sp)
 156:	e04a                	sd	s2,0(sp)
 158:	1000                	addi	s0,sp,32
 15a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15c:	4581                	li	a1,0
 15e:	18e000ef          	jal	2ec <open>
  if(fd < 0)
 162:	02054263          	bltz	a0,186 <stat+0x36>
 166:	e426                	sd	s1,8(sp)
 168:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 16a:	85ca                	mv	a1,s2
 16c:	198000ef          	jal	304 <fstat>
 170:	892a                	mv	s2,a0
  close(fd);
 172:	8526                	mv	a0,s1
 174:	160000ef          	jal	2d4 <close>
  return r;
 178:	64a2                	ld	s1,8(sp)
}
 17a:	854a                	mv	a0,s2
 17c:	60e2                	ld	ra,24(sp)
 17e:	6442                	ld	s0,16(sp)
 180:	6902                	ld	s2,0(sp)
 182:	6105                	addi	sp,sp,32
 184:	8082                	ret
    return -1;
 186:	597d                	li	s2,-1
 188:	bfcd                	j	17a <stat+0x2a>

000000000000018a <atoi>:

int
atoi(const char *s)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 190:	00054683          	lbu	a3,0(a0)
 194:	fd06879b          	addiw	a5,a3,-48
 198:	0ff7f793          	zext.b	a5,a5
 19c:	4625                	li	a2,9
 19e:	02f66863          	bltu	a2,a5,1ce <atoi+0x44>
 1a2:	872a                	mv	a4,a0
  n = 0;
 1a4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1a6:	0705                	addi	a4,a4,1
 1a8:	0025179b          	slliw	a5,a0,0x2
 1ac:	9fa9                	addw	a5,a5,a0
 1ae:	0017979b          	slliw	a5,a5,0x1
 1b2:	9fb5                	addw	a5,a5,a3
 1b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1b8:	00074683          	lbu	a3,0(a4)
 1bc:	fd06879b          	addiw	a5,a3,-48
 1c0:	0ff7f793          	zext.b	a5,a5
 1c4:	fef671e3          	bgeu	a2,a5,1a6 <atoi+0x1c>
  return n;
}
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  n = 0;
 1ce:	4501                	li	a0,0
 1d0:	bfe5                	j	1c8 <atoi+0x3e>

00000000000001d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1d8:	02b57463          	bgeu	a0,a1,200 <memmove+0x2e>
    while(n-- > 0)
 1dc:	00c05f63          	blez	a2,1fa <memmove+0x28>
 1e0:	1602                	slli	a2,a2,0x20
 1e2:	9201                	srli	a2,a2,0x20
 1e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1e8:	872a                	mv	a4,a0
      *dst++ = *src++;
 1ea:	0585                	addi	a1,a1,1
 1ec:	0705                	addi	a4,a4,1
 1ee:	fff5c683          	lbu	a3,-1(a1)
 1f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1f6:	fef71ae3          	bne	a4,a5,1ea <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1fa:	6422                	ld	s0,8(sp)
 1fc:	0141                	addi	sp,sp,16
 1fe:	8082                	ret
    dst += n;
 200:	00c50733          	add	a4,a0,a2
    src += n;
 204:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 206:	fec05ae3          	blez	a2,1fa <memmove+0x28>
 20a:	fff6079b          	addiw	a5,a2,-1
 20e:	1782                	slli	a5,a5,0x20
 210:	9381                	srli	a5,a5,0x20
 212:	fff7c793          	not	a5,a5
 216:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 218:	15fd                	addi	a1,a1,-1
 21a:	177d                	addi	a4,a4,-1
 21c:	0005c683          	lbu	a3,0(a1)
 220:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 224:	fee79ae3          	bne	a5,a4,218 <memmove+0x46>
 228:	bfc9                	j	1fa <memmove+0x28>

000000000000022a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 230:	ca05                	beqz	a2,260 <memcmp+0x36>
 232:	fff6069b          	addiw	a3,a2,-1
 236:	1682                	slli	a3,a3,0x20
 238:	9281                	srli	a3,a3,0x20
 23a:	0685                	addi	a3,a3,1
 23c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 23e:	00054783          	lbu	a5,0(a0)
 242:	0005c703          	lbu	a4,0(a1)
 246:	00e79863          	bne	a5,a4,256 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 24a:	0505                	addi	a0,a0,1
    p2++;
 24c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 24e:	fed518e3          	bne	a0,a3,23e <memcmp+0x14>
  }
  return 0;
 252:	4501                	li	a0,0
 254:	a019                	j	25a <memcmp+0x30>
      return *p1 - *p2;
 256:	40e7853b          	subw	a0,a5,a4
}
 25a:	6422                	ld	s0,8(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret
  return 0;
 260:	4501                	li	a0,0
 262:	bfe5                	j	25a <memcmp+0x30>

0000000000000264 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 26c:	f67ff0ef          	jal	1d2 <memmove>
}
 270:	60a2                	ld	ra,8(sp)
 272:	6402                	ld	s0,0(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret

0000000000000278 <sbrk>:

char *
sbrk(int n) {
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 280:	4585                	li	a1,1
 282:	0b2000ef          	jal	334 <sys_sbrk>
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <sbrklazy>:

char *
sbrklazy(int n) {
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 296:	4589                	li	a1,2
 298:	09c000ef          	jal	334 <sys_sbrk>
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a4:	4885                	li	a7,1
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ac:	4889                	li	a7,2
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b4:	488d                	li	a7,3
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2bc:	4891                	li	a7,4
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <read>:
.global read
read:
 li a7, SYS_read
 2c4:	4895                	li	a7,5
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <write>:
.global write
write:
 li a7, SYS_write
 2cc:	48c1                	li	a7,16
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <close>:
.global close
close:
 li a7, SYS_close
 2d4:	48d5                	li	a7,21
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2dc:	4899                	li	a7,6
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e4:	489d                	li	a7,7
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <open>:
.global open
open:
 li a7, SYS_open
 2ec:	48bd                	li	a7,15
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f4:	48c5                	li	a7,17
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2fc:	48c9                	li	a7,18
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 304:	48a1                	li	a7,8
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <link>:
.global link
link:
 li a7, SYS_link
 30c:	48cd                	li	a7,19
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 314:	48d1                	li	a7,20
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 31c:	48a5                	li	a7,9
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <dup>:
.global dup
dup:
 li a7, SYS_dup
 324:	48a9                	li	a7,10
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 32c:	48ad                	li	a7,11
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 334:	48b1                	li	a7,12
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <pause>:
.global pause
pause:
 li a7, SYS_pause
 33c:	48b5                	li	a7,13
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 344:	48b9                	li	a7,14
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <kps>:
.global kps
kps:
 li a7, SYS_kps
 34c:	48d9                	li	a7,22
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 354:	48dd                	li	a7,23
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 35c:	48e1                	li	a7,24
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 364:	48e5                	li	a7,25
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 36c:	48e9                	li	a7,26
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 374:	1101                	addi	sp,sp,-32
 376:	ec06                	sd	ra,24(sp)
 378:	e822                	sd	s0,16(sp)
 37a:	1000                	addi	s0,sp,32
 37c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 380:	4605                	li	a2,1
 382:	fef40593          	addi	a1,s0,-17
 386:	f47ff0ef          	jal	2cc <write>
}
 38a:	60e2                	ld	ra,24(sp)
 38c:	6442                	ld	s0,16(sp)
 38e:	6105                	addi	sp,sp,32
 390:	8082                	ret

0000000000000392 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 392:	715d                	addi	sp,sp,-80
 394:	e486                	sd	ra,72(sp)
 396:	e0a2                	sd	s0,64(sp)
 398:	f84a                	sd	s2,48(sp)
 39a:	0880                	addi	s0,sp,80
 39c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 39e:	c299                	beqz	a3,3a4 <printint+0x12>
 3a0:	0805c363          	bltz	a1,426 <printint+0x94>
  neg = 0;
 3a4:	4881                	li	a7,0
 3a6:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3aa:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3ac:	00000517          	auipc	a0,0x0
 3b0:	50c50513          	addi	a0,a0,1292 # 8b8 <digits>
 3b4:	883e                	mv	a6,a5
 3b6:	2785                	addiw	a5,a5,1
 3b8:	02c5f733          	remu	a4,a1,a2
 3bc:	972a                	add	a4,a4,a0
 3be:	00074703          	lbu	a4,0(a4)
 3c2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3c6:	872e                	mv	a4,a1
 3c8:	02c5d5b3          	divu	a1,a1,a2
 3cc:	0685                	addi	a3,a3,1
 3ce:	fec773e3          	bgeu	a4,a2,3b4 <printint+0x22>
  if(neg)
 3d2:	00088b63          	beqz	a7,3e8 <printint+0x56>
    buf[i++] = '-';
 3d6:	fd078793          	addi	a5,a5,-48
 3da:	97a2                	add	a5,a5,s0
 3dc:	02d00713          	li	a4,45
 3e0:	fee78423          	sb	a4,-24(a5)
 3e4:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 3e8:	02f05a63          	blez	a5,41c <printint+0x8a>
 3ec:	fc26                	sd	s1,56(sp)
 3ee:	f44e                	sd	s3,40(sp)
 3f0:	fb840713          	addi	a4,s0,-72
 3f4:	00f704b3          	add	s1,a4,a5
 3f8:	fff70993          	addi	s3,a4,-1
 3fc:	99be                	add	s3,s3,a5
 3fe:	37fd                	addiw	a5,a5,-1
 400:	1782                	slli	a5,a5,0x20
 402:	9381                	srli	a5,a5,0x20
 404:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 408:	fff4c583          	lbu	a1,-1(s1)
 40c:	854a                	mv	a0,s2
 40e:	f67ff0ef          	jal	374 <putc>
  while(--i >= 0)
 412:	14fd                	addi	s1,s1,-1
 414:	ff349ae3          	bne	s1,s3,408 <printint+0x76>
 418:	74e2                	ld	s1,56(sp)
 41a:	79a2                	ld	s3,40(sp)
}
 41c:	60a6                	ld	ra,72(sp)
 41e:	6406                	ld	s0,64(sp)
 420:	7942                	ld	s2,48(sp)
 422:	6161                	addi	sp,sp,80
 424:	8082                	ret
    x = -xx;
 426:	40b005b3          	neg	a1,a1
    neg = 1;
 42a:	4885                	li	a7,1
    x = -xx;
 42c:	bfad                	j	3a6 <printint+0x14>

000000000000042e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42e:	711d                	addi	sp,sp,-96
 430:	ec86                	sd	ra,88(sp)
 432:	e8a2                	sd	s0,80(sp)
 434:	e0ca                	sd	s2,64(sp)
 436:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 438:	0005c903          	lbu	s2,0(a1)
 43c:	28090663          	beqz	s2,6c8 <vprintf+0x29a>
 440:	e4a6                	sd	s1,72(sp)
 442:	fc4e                	sd	s3,56(sp)
 444:	f852                	sd	s4,48(sp)
 446:	f456                	sd	s5,40(sp)
 448:	f05a                	sd	s6,32(sp)
 44a:	ec5e                	sd	s7,24(sp)
 44c:	e862                	sd	s8,16(sp)
 44e:	e466                	sd	s9,8(sp)
 450:	8b2a                	mv	s6,a0
 452:	8a2e                	mv	s4,a1
 454:	8bb2                	mv	s7,a2
  state = 0;
 456:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 458:	4481                	li	s1,0
 45a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 45c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 460:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 464:	06c00c93          	li	s9,108
 468:	a005                	j	488 <vprintf+0x5a>
        putc(fd, c0);
 46a:	85ca                	mv	a1,s2
 46c:	855a                	mv	a0,s6
 46e:	f07ff0ef          	jal	374 <putc>
 472:	a019                	j	478 <vprintf+0x4a>
    } else if(state == '%'){
 474:	03598263          	beq	s3,s5,498 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 478:	2485                	addiw	s1,s1,1
 47a:	8726                	mv	a4,s1
 47c:	009a07b3          	add	a5,s4,s1
 480:	0007c903          	lbu	s2,0(a5)
 484:	22090a63          	beqz	s2,6b8 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 488:	0009079b          	sext.w	a5,s2
    if(state == 0){
 48c:	fe0994e3          	bnez	s3,474 <vprintf+0x46>
      if(c0 == '%'){
 490:	fd579de3          	bne	a5,s5,46a <vprintf+0x3c>
        state = '%';
 494:	89be                	mv	s3,a5
 496:	b7cd                	j	478 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 498:	00ea06b3          	add	a3,s4,a4
 49c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4a0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4a2:	c681                	beqz	a3,4aa <vprintf+0x7c>
 4a4:	9752                	add	a4,a4,s4
 4a6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4aa:	05878363          	beq	a5,s8,4f0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4ae:	05978d63          	beq	a5,s9,508 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4b2:	07500713          	li	a4,117
 4b6:	0ee78763          	beq	a5,a4,5a4 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ba:	07800713          	li	a4,120
 4be:	12e78963          	beq	a5,a4,5f0 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4c2:	07000713          	li	a4,112
 4c6:	14e78e63          	beq	a5,a4,622 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4ca:	06300713          	li	a4,99
 4ce:	18e78e63          	beq	a5,a4,66a <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4d2:	07300713          	li	a4,115
 4d6:	1ae78463          	beq	a5,a4,67e <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4da:	02500713          	li	a4,37
 4de:	04e79563          	bne	a5,a4,528 <vprintf+0xfa>
        putc(fd, '%');
 4e2:	02500593          	li	a1,37
 4e6:	855a                	mv	a0,s6
 4e8:	e8dff0ef          	jal	374 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	b769                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4f0:	008b8913          	addi	s2,s7,8
 4f4:	4685                	li	a3,1
 4f6:	4629                	li	a2,10
 4f8:	000ba583          	lw	a1,0(s7)
 4fc:	855a                	mv	a0,s6
 4fe:	e95ff0ef          	jal	392 <printint>
 502:	8bca                	mv	s7,s2
      state = 0;
 504:	4981                	li	s3,0
 506:	bf8d                	j	478 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 508:	06400793          	li	a5,100
 50c:	02f68963          	beq	a3,a5,53e <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 510:	06c00793          	li	a5,108
 514:	04f68263          	beq	a3,a5,558 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 518:	07500793          	li	a5,117
 51c:	0af68063          	beq	a3,a5,5bc <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 520:	07800793          	li	a5,120
 524:	0ef68263          	beq	a3,a5,608 <vprintf+0x1da>
        putc(fd, '%');
 528:	02500593          	li	a1,37
 52c:	855a                	mv	a0,s6
 52e:	e47ff0ef          	jal	374 <putc>
        putc(fd, c0);
 532:	85ca                	mv	a1,s2
 534:	855a                	mv	a0,s6
 536:	e3fff0ef          	jal	374 <putc>
      state = 0;
 53a:	4981                	li	s3,0
 53c:	bf35                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53e:	008b8913          	addi	s2,s7,8
 542:	4685                	li	a3,1
 544:	4629                	li	a2,10
 546:	000bb583          	ld	a1,0(s7)
 54a:	855a                	mv	a0,s6
 54c:	e47ff0ef          	jal	392 <printint>
        i += 1;
 550:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 552:	8bca                	mv	s7,s2
      state = 0;
 554:	4981                	li	s3,0
        i += 1;
 556:	b70d                	j	478 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 558:	06400793          	li	a5,100
 55c:	02f60763          	beq	a2,a5,58a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 560:	07500793          	li	a5,117
 564:	06f60963          	beq	a2,a5,5d6 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 568:	07800793          	li	a5,120
 56c:	faf61ee3          	bne	a2,a5,528 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 570:	008b8913          	addi	s2,s7,8
 574:	4681                	li	a3,0
 576:	4641                	li	a2,16
 578:	000bb583          	ld	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	e15ff0ef          	jal	392 <printint>
        i += 2;
 582:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 584:	8bca                	mv	s7,s2
      state = 0;
 586:	4981                	li	s3,0
        i += 2;
 588:	bdc5                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	008b8913          	addi	s2,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000bb583          	ld	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	dfbff0ef          	jal	392 <printint>
        i += 2;
 59c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
        i += 2;
 5a2:	bdd9                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000be583          	lwu	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	de1ff0ef          	jal	392 <printint>
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bd7d                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000bb583          	ld	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	dc9ff0ef          	jal	392 <printint>
        i += 1;
 5ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
        i += 1;
 5d4:	b555                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	008b8913          	addi	s2,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	dafff0ef          	jal	392 <printint>
        i += 2;
 5e8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	b569                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000be583          	lwu	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	d95ff0ef          	jal	392 <printint>
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	bd8d                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8913          	addi	s2,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	d7dff0ef          	jal	392 <printint>
        i += 1;
 61a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
        i += 1;
 620:	bda1                	j	478 <vprintf+0x4a>
 622:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 624:	008b8d13          	addi	s10,s7,8
 628:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 62c:	03000593          	li	a1,48
 630:	855a                	mv	a0,s6
 632:	d43ff0ef          	jal	374 <putc>
  putc(fd, 'x');
 636:	07800593          	li	a1,120
 63a:	855a                	mv	a0,s6
 63c:	d39ff0ef          	jal	374 <putc>
 640:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 642:	00000b97          	auipc	s7,0x0
 646:	276b8b93          	addi	s7,s7,630 # 8b8 <digits>
 64a:	03c9d793          	srli	a5,s3,0x3c
 64e:	97de                	add	a5,a5,s7
 650:	0007c583          	lbu	a1,0(a5)
 654:	855a                	mv	a0,s6
 656:	d1fff0ef          	jal	374 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65a:	0992                	slli	s3,s3,0x4
 65c:	397d                	addiw	s2,s2,-1
 65e:	fe0916e3          	bnez	s2,64a <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 662:	8bea                	mv	s7,s10
      state = 0;
 664:	4981                	li	s3,0
 666:	6d02                	ld	s10,0(sp)
 668:	bd01                	j	478 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 66a:	008b8913          	addi	s2,s7,8
 66e:	000bc583          	lbu	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	d01ff0ef          	jal	374 <putc>
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bbf5                	j	478 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 67e:	008b8993          	addi	s3,s7,8
 682:	000bb903          	ld	s2,0(s7)
 686:	00090f63          	beqz	s2,6a4 <vprintf+0x276>
        for(; *s; s++)
 68a:	00094583          	lbu	a1,0(s2)
 68e:	c195                	beqz	a1,6b2 <vprintf+0x284>
          putc(fd, *s);
 690:	855a                	mv	a0,s6
 692:	ce3ff0ef          	jal	374 <putc>
        for(; *s; s++)
 696:	0905                	addi	s2,s2,1
 698:	00094583          	lbu	a1,0(s2)
 69c:	f9f5                	bnez	a1,690 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 69e:	8bce                	mv	s7,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bbd9                	j	478 <vprintf+0x4a>
          s = "(null)";
 6a4:	00000917          	auipc	s2,0x0
 6a8:	20c90913          	addi	s2,s2,524 # 8b0 <malloc+0x100>
        for(; *s; s++)
 6ac:	02800593          	li	a1,40
 6b0:	b7c5                	j	690 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6b2:	8bce                	mv	s7,s3
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b3c9                	j	478 <vprintf+0x4a>
 6b8:	64a6                	ld	s1,72(sp)
 6ba:	79e2                	ld	s3,56(sp)
 6bc:	7a42                	ld	s4,48(sp)
 6be:	7aa2                	ld	s5,40(sp)
 6c0:	7b02                	ld	s6,32(sp)
 6c2:	6be2                	ld	s7,24(sp)
 6c4:	6c42                	ld	s8,16(sp)
 6c6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6c8:	60e6                	ld	ra,88(sp)
 6ca:	6446                	ld	s0,80(sp)
 6cc:	6906                	ld	s2,64(sp)
 6ce:	6125                	addi	sp,sp,96
 6d0:	8082                	ret

00000000000006d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d2:	715d                	addi	sp,sp,-80
 6d4:	ec06                	sd	ra,24(sp)
 6d6:	e822                	sd	s0,16(sp)
 6d8:	1000                	addi	s0,sp,32
 6da:	e010                	sd	a2,0(s0)
 6dc:	e414                	sd	a3,8(s0)
 6de:	e818                	sd	a4,16(s0)
 6e0:	ec1c                	sd	a5,24(s0)
 6e2:	03043023          	sd	a6,32(s0)
 6e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ee:	8622                	mv	a2,s0
 6f0:	d3fff0ef          	jal	42e <vprintf>
}
 6f4:	60e2                	ld	ra,24(sp)
 6f6:	6442                	ld	s0,16(sp)
 6f8:	6161                	addi	sp,sp,80
 6fa:	8082                	ret

00000000000006fc <printf>:

void
printf(const char *fmt, ...)
{
 6fc:	711d                	addi	sp,sp,-96
 6fe:	ec06                	sd	ra,24(sp)
 700:	e822                	sd	s0,16(sp)
 702:	1000                	addi	s0,sp,32
 704:	e40c                	sd	a1,8(s0)
 706:	e810                	sd	a2,16(s0)
 708:	ec14                	sd	a3,24(s0)
 70a:	f018                	sd	a4,32(s0)
 70c:	f41c                	sd	a5,40(s0)
 70e:	03043823          	sd	a6,48(s0)
 712:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 716:	00840613          	addi	a2,s0,8
 71a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 71e:	85aa                	mv	a1,a0
 720:	4505                	li	a0,1
 722:	d0dff0ef          	jal	42e <vprintf>
}
 726:	60e2                	ld	ra,24(sp)
 728:	6442                	ld	s0,16(sp)
 72a:	6125                	addi	sp,sp,96
 72c:	8082                	ret

000000000000072e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72e:	1141                	addi	sp,sp,-16
 730:	e422                	sd	s0,8(sp)
 732:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 734:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	00001797          	auipc	a5,0x1
 73c:	8c87b783          	ld	a5,-1848(a5) # 1000 <freep>
 740:	a02d                	j	76a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 742:	4618                	lw	a4,8(a2)
 744:	9f2d                	addw	a4,a4,a1
 746:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 74a:	6398                	ld	a4,0(a5)
 74c:	6310                	ld	a2,0(a4)
 74e:	a83d                	j	78c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 750:	ff852703          	lw	a4,-8(a0)
 754:	9f31                	addw	a4,a4,a2
 756:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 758:	ff053683          	ld	a3,-16(a0)
 75c:	a091                	j	7a0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	6398                	ld	a4,0(a5)
 760:	00e7e463          	bltu	a5,a4,768 <free+0x3a>
 764:	00e6ea63          	bltu	a3,a4,778 <free+0x4a>
{
 768:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	fed7fae3          	bgeu	a5,a3,75e <free+0x30>
 76e:	6398                	ld	a4,0(a5)
 770:	00e6e463          	bltu	a3,a4,778 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	fee7eae3          	bltu	a5,a4,768 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 778:	ff852583          	lw	a1,-8(a0)
 77c:	6390                	ld	a2,0(a5)
 77e:	02059813          	slli	a6,a1,0x20
 782:	01c85713          	srli	a4,a6,0x1c
 786:	9736                	add	a4,a4,a3
 788:	fae60de3          	beq	a2,a4,742 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 78c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 790:	4790                	lw	a2,8(a5)
 792:	02061593          	slli	a1,a2,0x20
 796:	01c5d713          	srli	a4,a1,0x1c
 79a:	973e                	add	a4,a4,a5
 79c:	fae68ae3          	beq	a3,a4,750 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7a0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a2:	00001717          	auipc	a4,0x1
 7a6:	84f73f23          	sd	a5,-1954(a4) # 1000 <freep>
}
 7aa:	6422                	ld	s0,8(sp)
 7ac:	0141                	addi	sp,sp,16
 7ae:	8082                	ret

00000000000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	7139                	addi	sp,sp,-64
 7b2:	fc06                	sd	ra,56(sp)
 7b4:	f822                	sd	s0,48(sp)
 7b6:	f426                	sd	s1,40(sp)
 7b8:	ec4e                	sd	s3,24(sp)
 7ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bc:	02051493          	slli	s1,a0,0x20
 7c0:	9081                	srli	s1,s1,0x20
 7c2:	04bd                	addi	s1,s1,15
 7c4:	8091                	srli	s1,s1,0x4
 7c6:	0014899b          	addiw	s3,s1,1
 7ca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7cc:	00001517          	auipc	a0,0x1
 7d0:	83453503          	ld	a0,-1996(a0) # 1000 <freep>
 7d4:	c915                	beqz	a0,808 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d8:	4798                	lw	a4,8(a5)
 7da:	08977a63          	bgeu	a4,s1,86e <malloc+0xbe>
 7de:	f04a                	sd	s2,32(sp)
 7e0:	e852                	sd	s4,16(sp)
 7e2:	e456                	sd	s5,8(sp)
 7e4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e6:	8a4e                	mv	s4,s3
 7e8:	0009871b          	sext.w	a4,s3
 7ec:	6685                	lui	a3,0x1
 7ee:	00d77363          	bgeu	a4,a3,7f4 <malloc+0x44>
 7f2:	6a05                	lui	s4,0x1
 7f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fc:	00001917          	auipc	s2,0x1
 800:	80490913          	addi	s2,s2,-2044 # 1000 <freep>
  if(p == SBRK_ERROR)
 804:	5afd                	li	s5,-1
 806:	a081                	j	846 <malloc+0x96>
 808:	f04a                	sd	s2,32(sp)
 80a:	e852                	sd	s4,16(sp)
 80c:	e456                	sd	s5,8(sp)
 80e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 810:	00001797          	auipc	a5,0x1
 814:	80078793          	addi	a5,a5,-2048 # 1010 <base>
 818:	00000717          	auipc	a4,0x0
 81c:	7ef73423          	sd	a5,2024(a4) # 1000 <freep>
 820:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 822:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 826:	b7c1                	j	7e6 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	e118                	sd	a4,0(a0)
 82c:	a8a9                	j	886 <malloc+0xd6>
  hp->s.size = nu;
 82e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 832:	0541                	addi	a0,a0,16
 834:	efbff0ef          	jal	72e <free>
  return freep;
 838:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83c:	c12d                	beqz	a0,89e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 840:	4798                	lw	a4,8(a5)
 842:	02977263          	bgeu	a4,s1,866 <malloc+0xb6>
    if(p == freep)
 846:	00093703          	ld	a4,0(s2)
 84a:	853e                	mv	a0,a5
 84c:	fef719e3          	bne	a4,a5,83e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 850:	8552                	mv	a0,s4
 852:	a27ff0ef          	jal	278 <sbrk>
  if(p == SBRK_ERROR)
 856:	fd551ce3          	bne	a0,s5,82e <malloc+0x7e>
        return 0;
 85a:	4501                	li	a0,0
 85c:	7902                	ld	s2,32(sp)
 85e:	6a42                	ld	s4,16(sp)
 860:	6aa2                	ld	s5,8(sp)
 862:	6b02                	ld	s6,0(sp)
 864:	a03d                	j	892 <malloc+0xe2>
 866:	7902                	ld	s2,32(sp)
 868:	6a42                	ld	s4,16(sp)
 86a:	6aa2                	ld	s5,8(sp)
 86c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 86e:	fae48de3          	beq	s1,a4,828 <malloc+0x78>
        p->s.size -= nunits;
 872:	4137073b          	subw	a4,a4,s3
 876:	c798                	sw	a4,8(a5)
        p += p->s.size;
 878:	02071693          	slli	a3,a4,0x20
 87c:	01c6d713          	srli	a4,a3,0x1c
 880:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 882:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 886:	00000717          	auipc	a4,0x0
 88a:	76a73d23          	sd	a0,1914(a4) # 1000 <freep>
      return (void*)(p + 1);
 88e:	01078513          	addi	a0,a5,16
  }
}
 892:	70e2                	ld	ra,56(sp)
 894:	7442                	ld	s0,48(sp)
 896:	74a2                	ld	s1,40(sp)
 898:	69e2                	ld	s3,24(sp)
 89a:	6121                	addi	sp,sp,64
 89c:	8082                	ret
 89e:	7902                	ld	s2,32(sp)
 8a0:	6a42                	ld	s4,16(sp)
 8a2:	6aa2                	ld	s5,8(sp)
 8a4:	6b02                	ld	s6,0(sp)
 8a6:	b7f5                	j	892 <malloc+0xe2>
