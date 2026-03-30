
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	06a7d063          	bge	a5,a0,76 <main+0x76>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	91cb0b13          	addi	s6,s6,-1764 # 950 <malloc+0xf8>
  3c:	a809                	j	4e <main+0x4e>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	30e000ef          	jal	352 <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	addi	s1,s1,8
  4a:	03448663          	beq	s1,s4,76 <main+0x76>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	088000ef          	jal	dc <strlen>
  58:	862a                	mv	a2,a0
  5a:	85ca                	mv	a1,s2
  5c:	854e                	mv	a0,s3
  5e:	2f4000ef          	jal	352 <write>
    if(i + 1 < argc){
  62:	fd549ee3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	8f058593          	addi	a1,a1,-1808 # 958 <malloc+0x100>
  70:	8532                	mv	a0,a2
  72:	2e0000ef          	jal	352 <write>
    }
  }
  exit(0);
  76:	4501                	li	a0,0
  78:	2ba000ef          	jal	332 <exit>

000000000000007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  84:	f7dff0ef          	jal	0 <main>
  exit(r);
  88:	2aa000ef          	jal	332 <exit>

000000000000008c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  94:	87aa                	mv	a5,a0
  96:	0585                	addi	a1,a1,1
  98:	0785                	addi	a5,a5,1
  9a:	fff5c703          	lbu	a4,-1(a1)
  9e:	fee78fa3          	sb	a4,-1(a5)
  a2:	fb75                	bnez	a4,96 <strcpy+0xa>
    ;
  return os;
}
  a4:	60a2                	ld	ra,8(sp)
  a6:	6402                	ld	s0,0(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x20>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x20>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf91                	beqz	a5,104 <strlen+0x28>
  ea:	00150793          	addi	a5,a0,1
  ee:	86be                	mv	a3,a5
  f0:	0785                	addi	a5,a5,1
  f2:	fff7c703          	lbu	a4,-1(a5)
  f6:	ff65                	bnez	a4,ee <strlen+0x12>
  f8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  fc:	60a2                	ld	ra,8(sp)
  fe:	6402                	ld	s0,0(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret
  for(n = 0; s[n]; n++)
 104:	4501                	li	a0,0
 106:	bfdd                	j	fc <strlen+0x20>

0000000000000108 <memset>:

void*
memset(void *dst, int c, uint n)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 110:	ca19                	beqz	a2,126 <memset+0x1e>
 112:	87aa                	mv	a5,a0
 114:	1602                	slli	a2,a2,0x20
 116:	9201                	srli	a2,a2,0x20
 118:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 120:	0785                	addi	a5,a5,1
 122:	fee79de3          	bne	a5,a4,11c <memset+0x14>
  }
  return dst;
}
 126:	60a2                	ld	ra,8(sp)
 128:	6402                	ld	s0,0(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strchr>:

char*
strchr(const char *s, char c)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  for(; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cf81                	beqz	a5,152 <strchr+0x24>
    if(*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1c>
  for(; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xe>
      return (char*)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	60a2                	ld	ra,8(sp)
 14c:	6402                	ld	s0,0(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret
  return 0;
 152:	4501                	li	a0,0
 154:	bfdd                	j	14a <strchr+0x1c>

0000000000000156 <gets>:

char*
gets(char *buf, int max)
{
 156:	711d                	addi	sp,sp,-96
 158:	ec86                	sd	ra,88(sp)
 15a:	e8a2                	sd	s0,80(sp)
 15c:	e4a6                	sd	s1,72(sp)
 15e:	e0ca                	sd	s2,64(sp)
 160:	fc4e                	sd	s3,56(sp)
 162:	f852                	sd	s4,48(sp)
 164:	f456                	sd	s5,40(sp)
 166:	f05a                	sd	s6,32(sp)
 168:	ec5e                	sd	s7,24(sp)
 16a:	e862                	sd	s8,16(sp)
 16c:	1080                	addi	s0,sp,96
 16e:	8baa                	mv	s7,a0
 170:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 172:	892a                	mv	s2,a0
 174:	4481                	li	s1,0
    cc = read(0, &c, 1);
 176:	faf40b13          	addi	s6,s0,-81
 17a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 17c:	8c26                	mv	s8,s1
 17e:	0014899b          	addiw	s3,s1,1
 182:	84ce                	mv	s1,s3
 184:	0349d463          	bge	s3,s4,1ac <gets+0x56>
    cc = read(0, &c, 1);
 188:	8656                	mv	a2,s5
 18a:	85da                	mv	a1,s6
 18c:	4501                	li	a0,0
 18e:	1bc000ef          	jal	34a <read>
    if(cc < 1)
 192:	00a05d63          	blez	a0,1ac <gets+0x56>
      break;
    buf[i++] = c;
 196:	faf44783          	lbu	a5,-81(s0)
 19a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 19e:	0905                	addi	s2,s2,1
 1a0:	ff678713          	addi	a4,a5,-10
 1a4:	c319                	beqz	a4,1aa <gets+0x54>
 1a6:	17cd                	addi	a5,a5,-13
 1a8:	fbf1                	bnez	a5,17c <gets+0x26>
    buf[i++] = c;
 1aa:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ac:	9c5e                	add	s8,s8,s7
 1ae:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1b2:	855e                	mv	a0,s7
 1b4:	60e6                	ld	ra,88(sp)
 1b6:	6446                	ld	s0,80(sp)
 1b8:	64a6                	ld	s1,72(sp)
 1ba:	6906                	ld	s2,64(sp)
 1bc:	79e2                	ld	s3,56(sp)
 1be:	7a42                	ld	s4,48(sp)
 1c0:	7aa2                	ld	s5,40(sp)
 1c2:	7b02                	ld	s6,32(sp)
 1c4:	6be2                	ld	s7,24(sp)
 1c6:	6c42                	ld	s8,16(sp)
 1c8:	6125                	addi	sp,sp,96
 1ca:	8082                	ret

00000000000001cc <stat>:

int
stat(const char *n, struct stat *st)
{
 1cc:	1101                	addi	sp,sp,-32
 1ce:	ec06                	sd	ra,24(sp)
 1d0:	e822                	sd	s0,16(sp)
 1d2:	e04a                	sd	s2,0(sp)
 1d4:	1000                	addi	s0,sp,32
 1d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d8:	4581                	li	a1,0
 1da:	198000ef          	jal	372 <open>
  if(fd < 0)
 1de:	02054263          	bltz	a0,202 <stat+0x36>
 1e2:	e426                	sd	s1,8(sp)
 1e4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e6:	85ca                	mv	a1,s2
 1e8:	1a2000ef          	jal	38a <fstat>
 1ec:	892a                	mv	s2,a0
  close(fd);
 1ee:	8526                	mv	a0,s1
 1f0:	16a000ef          	jal	35a <close>
  return r;
 1f4:	64a2                	ld	s1,8(sp)
}
 1f6:	854a                	mv	a0,s2
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	6902                	ld	s2,0(sp)
 1fe:	6105                	addi	sp,sp,32
 200:	8082                	ret
    return -1;
 202:	57fd                	li	a5,-1
 204:	893e                	mv	s2,a5
 206:	bfc5                	j	1f6 <stat+0x2a>

0000000000000208 <atoi>:

int
atoi(const char *s)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e406                	sd	ra,8(sp)
 20c:	e022                	sd	s0,0(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 210:	00054683          	lbu	a3,0(a0)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	4625                	li	a2,9
 21e:	02f66963          	bltu	a2,a5,250 <atoi+0x48>
 222:	872a                	mv	a4,a0
  n = 0;
 224:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 226:	0705                	addi	a4,a4,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 238:	00074683          	lbu	a3,0(a4)
 23c:	fd06879b          	addiw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	fef671e3          	bgeu	a2,a5,226 <atoi+0x1e>
  return n;
}
 248:	60a2                	ld	ra,8(sp)
 24a:	6402                	ld	s0,0(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
  n = 0;
 250:	4501                	li	a0,0
 252:	bfdd                	j	248 <atoi+0x40>

0000000000000254 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25c:	02b57563          	bgeu	a0,a1,286 <memmove+0x32>
    while(n-- > 0)
 260:	00c05f63          	blez	a2,27e <memmove+0x2a>
 264:	1602                	slli	a2,a2,0x20
 266:	9201                	srli	a2,a2,0x20
 268:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26c:	872a                	mv	a4,a0
      *dst++ = *src++;
 26e:	0585                	addi	a1,a1,1
 270:	0705                	addi	a4,a4,1
 272:	fff5c683          	lbu	a3,-1(a1)
 276:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27a:	fee79ae3          	bne	a5,a4,26e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
    while(n-- > 0)
 286:	fec05ce3          	blez	a2,27e <memmove+0x2a>
    dst += n;
 28a:	00c50733          	add	a4,a0,a2
    src += n;
 28e:	95b2                	add	a1,a1,a2
 290:	fff6079b          	addiw	a5,a2,-1
 294:	1782                	slli	a5,a5,0x20
 296:	9381                	srli	a5,a5,0x20
 298:	fff7c793          	not	a5,a5
 29c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29e:	15fd                	addi	a1,a1,-1
 2a0:	177d                	addi	a4,a4,-1
 2a2:	0005c683          	lbu	a3,0(a1)
 2a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2aa:	fef71ae3          	bne	a4,a5,29e <memmove+0x4a>
 2ae:	bfc1                	j	27e <memmove+0x2a>

00000000000002b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b8:	c61d                	beqz	a2,2e6 <memcmp+0x36>
 2ba:	1602                	slli	a2,a2,0x20
 2bc:	9201                	srli	a2,a2,0x20
 2be:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	0005c703          	lbu	a4,0(a1)
 2ca:	00e79863          	bne	a5,a4,2da <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ce:	0505                	addi	a0,a0,1
    p2++;
 2d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d2:	fed518e3          	bne	a0,a3,2c2 <memcmp+0x12>
  }
  return 0;
 2d6:	4501                	li	a0,0
 2d8:	a019                	j	2de <memcmp+0x2e>
      return *p1 - *p2;
 2da:	40e7853b          	subw	a0,a5,a4
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	bfdd                	j	2de <memcmp+0x2e>

00000000000002ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f2:	f63ff0ef          	jal	254 <memmove>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrk>:

char *
sbrk(int n) {
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 306:	4585                	li	a1,1
 308:	0b2000ef          	jal	3ba <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <sbrklazy>:

char *
sbrklazy(int n) {
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 31c:	4589                	li	a1,2
 31e:	09c000ef          	jal	3ba <sys_sbrk>
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32a:	4885                	li	a7,1
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <exit>:
.global exit
exit:
 li a7, SYS_exit
 332:	4889                	li	a7,2
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <wait>:
.global wait
wait:
 li a7, SYS_wait
 33a:	488d                	li	a7,3
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 342:	4891                	li	a7,4
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <read>:
.global read
read:
 li a7, SYS_read
 34a:	4895                	li	a7,5
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <write>:
.global write
write:
 li a7, SYS_write
 352:	48c1                	li	a7,16
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <close>:
.global close
close:
 li a7, SYS_close
 35a:	48d5                	li	a7,21
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <kill>:
.global kill
kill:
 li a7, SYS_kill
 362:	4899                	li	a7,6
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <exec>:
.global exec
exec:
 li a7, SYS_exec
 36a:	489d                	li	a7,7
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <open>:
.global open
open:
 li a7, SYS_open
 372:	48bd                	li	a7,15
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37a:	48c5                	li	a7,17
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 382:	48c9                	li	a7,18
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38a:	48a1                	li	a7,8
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <link>:
.global link
link:
 li a7, SYS_link
 392:	48cd                	li	a7,19
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39a:	48d1                	li	a7,20
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a2:	48a5                	li	a7,9
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <dup>:
.global dup
dup:
 li a7, SYS_dup
 3aa:	48a9                	li	a7,10
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b2:	48ad                	li	a7,11
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3ba:	48b1                	li	a7,12
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3c2:	48b5                	li	a7,13
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ca:	48b9                	li	a7,14
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <kps>:
.global kps
kps:
 li a7, SYS_kps
 3d2:	48d9                	li	a7,22
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 3da:	48dd                	li	a7,23
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 3e2:	48e1                	li	a7,24
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 3ea:	48e5                	li	a7,25
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 3f2:	48e9                	li	a7,26
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fa:	1101                	addi	sp,sp,-32
 3fc:	ec06                	sd	ra,24(sp)
 3fe:	e822                	sd	s0,16(sp)
 400:	1000                	addi	s0,sp,32
 402:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 406:	4605                	li	a2,1
 408:	fef40593          	addi	a1,s0,-17
 40c:	f47ff0ef          	jal	352 <write>
}
 410:	60e2                	ld	ra,24(sp)
 412:	6442                	ld	s0,16(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret

0000000000000418 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 418:	715d                	addi	sp,sp,-80
 41a:	e486                	sd	ra,72(sp)
 41c:	e0a2                	sd	s0,64(sp)
 41e:	f84a                	sd	s2,48(sp)
 420:	f44e                	sd	s3,40(sp)
 422:	0880                	addi	s0,sp,80
 424:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 426:	c6d1                	beqz	a3,4b2 <printint+0x9a>
 428:	0805d563          	bgez	a1,4b2 <printint+0x9a>
    neg = 1;
    x = -xx;
 42c:	40b005b3          	neg	a1,a1
    neg = 1;
 430:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 432:	fb840993          	addi	s3,s0,-72
  neg = 0;
 436:	86ce                	mv	a3,s3
  i = 0;
 438:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 43a:	00000817          	auipc	a6,0x0
 43e:	52e80813          	addi	a6,a6,1326 # 968 <digits>
 442:	88ba                	mv	a7,a4
 444:	0017051b          	addiw	a0,a4,1
 448:	872a                	mv	a4,a0
 44a:	02c5f7b3          	remu	a5,a1,a2
 44e:	97c2                	add	a5,a5,a6
 450:	0007c783          	lbu	a5,0(a5)
 454:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 458:	87ae                	mv	a5,a1
 45a:	02c5d5b3          	divu	a1,a1,a2
 45e:	0685                	addi	a3,a3,1
 460:	fec7f1e3          	bgeu	a5,a2,442 <printint+0x2a>
  if(neg)
 464:	00030c63          	beqz	t1,47c <printint+0x64>
    buf[i++] = '-';
 468:	fd050793          	addi	a5,a0,-48
 46c:	00878533          	add	a0,a5,s0
 470:	02d00793          	li	a5,45
 474:	fef50423          	sb	a5,-24(a0)
 478:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 47c:	02e05563          	blez	a4,4a6 <printint+0x8e>
 480:	fc26                	sd	s1,56(sp)
 482:	377d                	addiw	a4,a4,-1
 484:	00e984b3          	add	s1,s3,a4
 488:	19fd                	addi	s3,s3,-1
 48a:	99ba                	add	s3,s3,a4
 48c:	1702                	slli	a4,a4,0x20
 48e:	9301                	srli	a4,a4,0x20
 490:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 494:	0004c583          	lbu	a1,0(s1)
 498:	854a                	mv	a0,s2
 49a:	f61ff0ef          	jal	3fa <putc>
  while(--i >= 0)
 49e:	14fd                	addi	s1,s1,-1
 4a0:	ff349ae3          	bne	s1,s3,494 <printint+0x7c>
 4a4:	74e2                	ld	s1,56(sp)
}
 4a6:	60a6                	ld	ra,72(sp)
 4a8:	6406                	ld	s0,64(sp)
 4aa:	7942                	ld	s2,48(sp)
 4ac:	79a2                	ld	s3,40(sp)
 4ae:	6161                	addi	sp,sp,80
 4b0:	8082                	ret
  neg = 0;
 4b2:	4301                	li	t1,0
 4b4:	bfbd                	j	432 <printint+0x1a>

00000000000004b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b6:	711d                	addi	sp,sp,-96
 4b8:	ec86                	sd	ra,88(sp)
 4ba:	e8a2                	sd	s0,80(sp)
 4bc:	e4a6                	sd	s1,72(sp)
 4be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c0:	0005c483          	lbu	s1,0(a1)
 4c4:	22048363          	beqz	s1,6ea <vprintf+0x234>
 4c8:	e0ca                	sd	s2,64(sp)
 4ca:	fc4e                	sd	s3,56(sp)
 4cc:	f852                	sd	s4,48(sp)
 4ce:	f456                	sd	s5,40(sp)
 4d0:	f05a                	sd	s6,32(sp)
 4d2:	ec5e                	sd	s7,24(sp)
 4d4:	e862                	sd	s8,16(sp)
 4d6:	8b2a                	mv	s6,a0
 4d8:	8a2e                	mv	s4,a1
 4da:	8bb2                	mv	s7,a2
  state = 0;
 4dc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4de:	4901                	li	s2,0
 4e0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e6:	06400c13          	li	s8,100
 4ea:	a00d                	j	50c <vprintf+0x56>
        putc(fd, c0);
 4ec:	85a6                	mv	a1,s1
 4ee:	855a                	mv	a0,s6
 4f0:	f0bff0ef          	jal	3fa <putc>
 4f4:	a019                	j	4fa <vprintf+0x44>
    } else if(state == '%'){
 4f6:	03598363          	beq	s3,s5,51c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4fa:	0019079b          	addiw	a5,s2,1
 4fe:	893e                	mv	s2,a5
 500:	873e                	mv	a4,a5
 502:	97d2                	add	a5,a5,s4
 504:	0007c483          	lbu	s1,0(a5)
 508:	1c048a63          	beqz	s1,6dc <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 50c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 510:	fe0993e3          	bnez	s3,4f6 <vprintf+0x40>
      if(c0 == '%'){
 514:	fd579ce3          	bne	a5,s5,4ec <vprintf+0x36>
        state = '%';
 518:	89be                	mv	s3,a5
 51a:	b7c5                	j	4fa <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 51c:	00ea06b3          	add	a3,s4,a4
 520:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 524:	1c060863          	beqz	a2,6f4 <vprintf+0x23e>
      if(c0 == 'd'){
 528:	03878763          	beq	a5,s8,556 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 52c:	f9478693          	addi	a3,a5,-108
 530:	0016b693          	seqz	a3,a3
 534:	f9c60593          	addi	a1,a2,-100
 538:	e99d                	bnez	a1,56e <vprintf+0xb8>
 53a:	ca95                	beqz	a3,56e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53c:	008b8493          	addi	s1,s7,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000bb583          	ld	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	ecfff0ef          	jal	418 <printint>
        i += 1;
 54e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 550:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 552:	4981                	li	s3,0
 554:	b75d                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b8493          	addi	s1,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	eb5ff0ef          	jal	418 <printint>
 568:	8ba6                	mv	s7,s1
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b779                	j	4fa <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 56e:	9752                	add	a4,a4,s4
 570:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 574:	f9460713          	addi	a4,a2,-108
 578:	00173713          	seqz	a4,a4
 57c:	8f75                	and	a4,a4,a3
 57e:	f9c58513          	addi	a0,a1,-100
 582:	18051363          	bnez	a0,708 <vprintf+0x252>
 586:	18070163          	beqz	a4,708 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	008b8493          	addi	s1,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000bb583          	ld	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	e81ff0ef          	jal	418 <printint>
        i += 2;
 59c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	8ba6                	mv	s7,s1
      state = 0;
 5a0:	4981                	li	s3,0
        i += 2;
 5a2:	bfa1                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000be583          	lwu	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e67ff0ef          	jal	418 <printint>
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b781                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000bb583          	ld	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e4fff0ef          	jal	418 <printint>
        i += 1;
 5ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b71d                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e35ff0ef          	jal	418 <printint>
        i += 2;
 5e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	b731                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000be583          	lwu	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e1bff0ef          	jal	418 <printint>
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
 606:	bdd5                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e03ff0ef          	jal	418 <printint>
        i += 1;
 61a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	bde9                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	de9ff0ef          	jal	418 <printint>
        i += 2;
 634:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
        i += 2;
 63a:	b5c1                	j	4fa <vprintf+0x44>
 63c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 63e:	008b8793          	addi	a5,s7,8
 642:	8cbe                	mv	s9,a5
 644:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 648:	03000593          	li	a1,48
 64c:	855a                	mv	a0,s6
 64e:	dadff0ef          	jal	3fa <putc>
  putc(fd, 'x');
 652:	07800593          	li	a1,120
 656:	855a                	mv	a0,s6
 658:	da3ff0ef          	jal	3fa <putc>
 65c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65e:	00000b97          	auipc	s7,0x0
 662:	30ab8b93          	addi	s7,s7,778 # 968 <digits>
 666:	03c9d793          	srli	a5,s3,0x3c
 66a:	97de                	add	a5,a5,s7
 66c:	0007c583          	lbu	a1,0(a5)
 670:	855a                	mv	a0,s6
 672:	d89ff0ef          	jal	3fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 676:	0992                	slli	s3,s3,0x4
 678:	34fd                	addiw	s1,s1,-1
 67a:	f4f5                	bnez	s1,666 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 67c:	8be6                	mv	s7,s9
      state = 0;
 67e:	4981                	li	s3,0
 680:	6ca2                	ld	s9,8(sp)
 682:	bda5                	j	4fa <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 684:	008b8493          	addi	s1,s7,8
 688:	000bc583          	lbu	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	d6dff0ef          	jal	3fa <putc>
 692:	8ba6                	mv	s7,s1
      state = 0;
 694:	4981                	li	s3,0
 696:	b595                	j	4fa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 698:	008b8993          	addi	s3,s7,8
 69c:	000bb483          	ld	s1,0(s7)
 6a0:	cc91                	beqz	s1,6bc <vprintf+0x206>
        for(; *s; s++)
 6a2:	0004c583          	lbu	a1,0(s1)
 6a6:	c985                	beqz	a1,6d6 <vprintf+0x220>
          putc(fd, *s);
 6a8:	855a                	mv	a0,s6
 6aa:	d51ff0ef          	jal	3fa <putc>
        for(; *s; s++)
 6ae:	0485                	addi	s1,s1,1
 6b0:	0004c583          	lbu	a1,0(s1)
 6b4:	f9f5                	bnez	a1,6a8 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b581                	j	4fa <vprintf+0x44>
          s = "(null)";
 6bc:	00000497          	auipc	s1,0x0
 6c0:	2a448493          	addi	s1,s1,676 # 960 <malloc+0x108>
        for(; *s; s++)
 6c4:	02800593          	li	a1,40
 6c8:	b7c5                	j	6a8 <vprintf+0x1f2>
        putc(fd, '%');
 6ca:	85be                	mv	a1,a5
 6cc:	855a                	mv	a0,s6
 6ce:	d2dff0ef          	jal	3fa <putc>
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b51d                	j	4fa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6d6:	8bce                	mv	s7,s3
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b505                	j	4fa <vprintf+0x44>
 6dc:	6906                	ld	s2,64(sp)
 6de:	79e2                	ld	s3,56(sp)
 6e0:	7a42                	ld	s4,48(sp)
 6e2:	7aa2                	ld	s5,40(sp)
 6e4:	7b02                	ld	s6,32(sp)
 6e6:	6be2                	ld	s7,24(sp)
 6e8:	6c42                	ld	s8,16(sp)
    }
  }
}
 6ea:	60e6                	ld	ra,88(sp)
 6ec:	6446                	ld	s0,80(sp)
 6ee:	64a6                	ld	s1,72(sp)
 6f0:	6125                	addi	sp,sp,96
 6f2:	8082                	ret
      if(c0 == 'd'){
 6f4:	06400713          	li	a4,100
 6f8:	e4e78fe3          	beq	a5,a4,556 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6fc:	f9478693          	addi	a3,a5,-108
 700:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 704:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 706:	4701                	li	a4,0
      } else if(c0 == 'u'){
 708:	07500513          	li	a0,117
 70c:	e8a78ce3          	beq	a5,a0,5a4 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 710:	f8b60513          	addi	a0,a2,-117
 714:	e119                	bnez	a0,71a <vprintf+0x264>
 716:	ea0693e3          	bnez	a3,5bc <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 71a:	f8b58513          	addi	a0,a1,-117
 71e:	e119                	bnez	a0,724 <vprintf+0x26e>
 720:	ea071be3          	bnez	a4,5d6 <vprintf+0x120>
      } else if(c0 == 'x'){
 724:	07800513          	li	a0,120
 728:	eca784e3          	beq	a5,a0,5f0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 72c:	f8860613          	addi	a2,a2,-120
 730:	e219                	bnez	a2,736 <vprintf+0x280>
 732:	ec069be3          	bnez	a3,608 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 736:	f8858593          	addi	a1,a1,-120
 73a:	e199                	bnez	a1,740 <vprintf+0x28a>
 73c:	ee0713e3          	bnez	a4,622 <vprintf+0x16c>
      } else if(c0 == 'p'){
 740:	07000713          	li	a4,112
 744:	eee78ce3          	beq	a5,a4,63c <vprintf+0x186>
      } else if(c0 == 'c'){
 748:	06300713          	li	a4,99
 74c:	f2e78ce3          	beq	a5,a4,684 <vprintf+0x1ce>
      } else if(c0 == 's'){
 750:	07300713          	li	a4,115
 754:	f4e782e3          	beq	a5,a4,698 <vprintf+0x1e2>
      } else if(c0 == '%'){
 758:	02500713          	li	a4,37
 75c:	f6e787e3          	beq	a5,a4,6ca <vprintf+0x214>
        putc(fd, '%');
 760:	02500593          	li	a1,37
 764:	855a                	mv	a0,s6
 766:	c95ff0ef          	jal	3fa <putc>
        putc(fd, c0);
 76a:	85a6                	mv	a1,s1
 76c:	855a                	mv	a0,s6
 76e:	c8dff0ef          	jal	3fa <putc>
      state = 0;
 772:	4981                	li	s3,0
 774:	b359                	j	4fa <vprintf+0x44>

0000000000000776 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 776:	715d                	addi	sp,sp,-80
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e010                	sd	a2,0(s0)
 780:	e414                	sd	a3,8(s0)
 782:	e818                	sd	a4,16(s0)
 784:	ec1c                	sd	a5,24(s0)
 786:	03043023          	sd	a6,32(s0)
 78a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	8622                	mv	a2,s0
 790:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 794:	d23ff0ef          	jal	4b6 <vprintf>
}
 798:	60e2                	ld	ra,24(sp)
 79a:	6442                	ld	s0,16(sp)
 79c:	6161                	addi	sp,sp,80
 79e:	8082                	ret

00000000000007a0 <printf>:

void
printf(const char *fmt, ...)
{
 7a0:	711d                	addi	sp,sp,-96
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	addi	s0,sp,32
 7a8:	e40c                	sd	a1,8(s0)
 7aa:	e810                	sd	a2,16(s0)
 7ac:	ec14                	sd	a3,24(s0)
 7ae:	f018                	sd	a4,32(s0)
 7b0:	f41c                	sd	a5,40(s0)
 7b2:	03043823          	sd	a6,48(s0)
 7b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ba:	00840613          	addi	a2,s0,8
 7be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c2:	85aa                	mv	a1,a0
 7c4:	4505                	li	a0,1
 7c6:	cf1ff0ef          	jal	4b6 <vprintf>
}
 7ca:	60e2                	ld	ra,24(sp)
 7cc:	6442                	ld	s0,16(sp)
 7ce:	6125                	addi	sp,sp,96
 7d0:	8082                	ret

00000000000007d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d2:	1141                	addi	sp,sp,-16
 7d4:	e406                	sd	ra,8(sp)
 7d6:	e022                	sd	s0,0(sp)
 7d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	00001797          	auipc	a5,0x1
 7e2:	8227b783          	ld	a5,-2014(a5) # 1000 <freep>
 7e6:	a039                	j	7f4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	6398                	ld	a4,0(a5)
 7ea:	00e7e463          	bltu	a5,a4,7f2 <free+0x20>
 7ee:	00e6ea63          	bltu	a3,a4,802 <free+0x30>
{
 7f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	fed7fae3          	bgeu	a5,a3,7e8 <free+0x16>
 7f8:	6398                	ld	a4,0(a5)
 7fa:	00e6e463          	bltu	a3,a4,802 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fe:	fee7eae3          	bltu	a5,a4,7f2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 802:	ff852583          	lw	a1,-8(a0)
 806:	6390                	ld	a2,0(a5)
 808:	02059813          	slli	a6,a1,0x20
 80c:	01c85713          	srli	a4,a6,0x1c
 810:	9736                	add	a4,a4,a3
 812:	02e60563          	beq	a2,a4,83c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 81a:	4790                	lw	a2,8(a5)
 81c:	02061593          	slli	a1,a2,0x20
 820:	01c5d713          	srli	a4,a1,0x1c
 824:	973e                	add	a4,a4,a5
 826:	02e68263          	beq	a3,a4,84a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 82a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82c:	00000717          	auipc	a4,0x0
 830:	7cf73a23          	sd	a5,2004(a4) # 1000 <freep>
}
 834:	60a2                	ld	ra,8(sp)
 836:	6402                	ld	s0,0(sp)
 838:	0141                	addi	sp,sp,16
 83a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 83c:	4618                	lw	a4,8(a2)
 83e:	9f2d                	addw	a4,a4,a1
 840:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 844:	6398                	ld	a4,0(a5)
 846:	6310                	ld	a2,0(a4)
 848:	b7f9                	j	816 <free+0x44>
    p->s.size += bp->s.size;
 84a:	ff852703          	lw	a4,-8(a0)
 84e:	9f31                	addw	a4,a4,a2
 850:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 852:	ff053683          	ld	a3,-16(a0)
 856:	bfd1                	j	82a <free+0x58>

0000000000000858 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 858:	7139                	addi	sp,sp,-64
 85a:	fc06                	sd	ra,56(sp)
 85c:	f822                	sd	s0,48(sp)
 85e:	f04a                	sd	s2,32(sp)
 860:	ec4e                	sd	s3,24(sp)
 862:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 864:	02051993          	slli	s3,a0,0x20
 868:	0209d993          	srli	s3,s3,0x20
 86c:	09bd                	addi	s3,s3,15
 86e:	0049d993          	srli	s3,s3,0x4
 872:	2985                	addiw	s3,s3,1
 874:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 876:	00000517          	auipc	a0,0x0
 87a:	78a53503          	ld	a0,1930(a0) # 1000 <freep>
 87e:	c905                	beqz	a0,8ae <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 882:	4798                	lw	a4,8(a5)
 884:	09377663          	bgeu	a4,s3,910 <malloc+0xb8>
 888:	f426                	sd	s1,40(sp)
 88a:	e852                	sd	s4,16(sp)
 88c:	e456                	sd	s5,8(sp)
 88e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 890:	8a4e                	mv	s4,s3
 892:	6705                	lui	a4,0x1
 894:	00e9f363          	bgeu	s3,a4,89a <malloc+0x42>
 898:	6a05                	lui	s4,0x1
 89a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a2:	00000497          	auipc	s1,0x0
 8a6:	75e48493          	addi	s1,s1,1886 # 1000 <freep>
  if(p == SBRK_ERROR)
 8aa:	5afd                	li	s5,-1
 8ac:	a83d                	j	8ea <malloc+0x92>
 8ae:	f426                	sd	s1,40(sp)
 8b0:	e852                	sd	s4,16(sp)
 8b2:	e456                	sd	s5,8(sp)
 8b4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b6:	00000797          	auipc	a5,0x0
 8ba:	75a78793          	addi	a5,a5,1882 # 1010 <base>
 8be:	00000717          	auipc	a4,0x0
 8c2:	74f73123          	sd	a5,1858(a4) # 1000 <freep>
 8c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8cc:	b7d1                	j	890 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ce:	6398                	ld	a4,0(a5)
 8d0:	e118                	sd	a4,0(a0)
 8d2:	a899                	j	928 <malloc+0xd0>
  hp->s.size = nu;
 8d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d8:	0541                	addi	a0,a0,16
 8da:	ef9ff0ef          	jal	7d2 <free>
  return freep;
 8de:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8e0:	c125                	beqz	a0,940 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	03277163          	bgeu	a4,s2,908 <malloc+0xb0>
    if(p == freep)
 8ea:	6098                	ld	a4,0(s1)
 8ec:	853e                	mv	a0,a5
 8ee:	fef71ae3          	bne	a4,a5,8e2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8f2:	8552                	mv	a0,s4
 8f4:	a0bff0ef          	jal	2fe <sbrk>
  if(p == SBRK_ERROR)
 8f8:	fd551ee3          	bne	a0,s5,8d4 <malloc+0x7c>
        return 0;
 8fc:	4501                	li	a0,0
 8fe:	74a2                	ld	s1,40(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	a03d                	j	934 <malloc+0xdc>
 908:	74a2                	ld	s1,40(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 910:	fae90fe3          	beq	s2,a4,8ce <malloc+0x76>
        p->s.size -= nunits;
 914:	4137073b          	subw	a4,a4,s3
 918:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91a:	02071693          	slli	a3,a4,0x20
 91e:	01c6d713          	srli	a4,a3,0x1c
 922:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 924:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 928:	00000717          	auipc	a4,0x0
 92c:	6ca73c23          	sd	a0,1752(a4) # 1000 <freep>
      return (void*)(p + 1);
 930:	01078513          	addi	a0,a5,16
  }
}
 934:	70e2                	ld	ra,56(sp)
 936:	7442                	ld	s0,48(sp)
 938:	7902                	ld	s2,32(sp)
 93a:	69e2                	ld	s3,24(sp)
 93c:	6121                	addi	sp,sp,64
 93e:	8082                	ret
 940:	74a2                	ld	s1,40(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
 948:	b7f5                	j	934 <malloc+0xdc>
