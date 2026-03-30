
user/_good_pipe:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"

int main(void)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
    int pid;

    char *haiku = "The light of a candle\nfluttering in the wind\nthe first star of night.\n";

    // create the pipe using the pipe() system call
    if (pipe(p) < 0)
   8:	fc840513          	addi	a0,s0,-56
   c:	38c000ef          	jal	398 <pipe>
  10:	04054b63          	bltz	a0,66 <main+0x66>
        printf("pipe creation failed\n");
        exit(1);
    }

    // Fork a child process
    pid = fork();
  14:	36c000ef          	jal	380 <fork>

    // if pid negative, fork failed
    if (pid < 0)
  18:	06054363          	bltz	a0,7e <main+0x7e>
  1c:	f426                	sd	s1,40(sp)
  1e:	f04a                	sd	s2,32(sp)
  20:	ec4e                	sd	s3,24(sp)
    {
        printf("fork failed\n");
        exit(1);
    }
    // PARENT: parent process has the pid of child
    if (pid > 0)
  22:	06a05a63          	blez	a0,96 <main+0x96>
    {
        // parent writes, so close read end
        close(p[0]);
  26:	fc842503          	lw	a0,-56(s0)
  2a:	386000ef          	jal	3b0 <close>

        // Write the haiku into the pipe, one byte at a time
        int i = 0;
        while (haiku[i] != '\0')
  2e:	00001497          	auipc	s1,0x1
  32:	97248493          	addi	s1,s1,-1678 # 9a0 <malloc+0xf2>
        {
            // write file descriptor, a char from haiku, reading max 1 char 
            write(p[1], &haiku[i], 1);
  36:	4985                	li	s3,1
        while (haiku[i] != '\0')
  38:	00001917          	auipc	s2,0x1
  3c:	9ae90913          	addi	s2,s2,-1618 # 9e6 <malloc+0x138>
            write(p[1], &haiku[i], 1);
  40:	864e                	mv	a2,s3
  42:	85a6                	mv	a1,s1
  44:	fcc42503          	lw	a0,-52(s0)
  48:	360000ef          	jal	3a8 <write>
        while (haiku[i] != '\0')
  4c:	0485                	addi	s1,s1,1
  4e:	ff2499e3          	bne	s1,s2,40 <main+0x40>
            i++;
        }

        // Close write rend
        close(p[1]);
  52:	fcc42503          	lw	a0,-52(s0)
  56:	35a000ef          	jal	3b0 <close>

        // pause parent, wait for the child to finish
        wait(0);
  5a:	4501                	li	a0,0
  5c:	334000ef          	jal	390 <wait>

        // close the read end
        close(p[0]);
    }

    exit(0);
  60:	4501                	li	a0,0
  62:	326000ef          	jal	388 <exit>
  66:	f426                	sd	s1,40(sp)
  68:	f04a                	sd	s2,32(sp)
  6a:	ec4e                	sd	s3,24(sp)
        printf("pipe creation failed\n");
  6c:	00001517          	auipc	a0,0x1
  70:	97c50513          	addi	a0,a0,-1668 # 9e8 <malloc+0x13a>
  74:	782000ef          	jal	7f6 <printf>
        exit(1);
  78:	4505                	li	a0,1
  7a:	30e000ef          	jal	388 <exit>
  7e:	f426                	sd	s1,40(sp)
  80:	f04a                	sd	s2,32(sp)
  82:	ec4e                	sd	s3,24(sp)
        printf("fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	97c50513          	addi	a0,a0,-1668 # a00 <malloc+0x152>
  8c:	76a000ef          	jal	7f6 <printf>
        exit(1);
  90:	4505                	li	a0,1
  92:	2f6000ef          	jal	388 <exit>
        close(p[1]);
  96:	fcc42503          	lw	a0,-52(s0)
  9a:	316000ef          	jal	3b0 <close>
        while (read(p[0], &ch, 1) > 0)
  9e:	fc740913          	addi	s2,s0,-57
  a2:	4485                	li	s1,1
            printf("%c", ch);
  a4:	00001997          	auipc	s3,0x1
  a8:	96c98993          	addi	s3,s3,-1684 # a10 <malloc+0x162>
        while (read(p[0], &ch, 1) > 0)
  ac:	a031                	j	b8 <main+0xb8>
            printf("%c", ch);
  ae:	fc744583          	lbu	a1,-57(s0)
  b2:	854e                	mv	a0,s3
  b4:	742000ef          	jal	7f6 <printf>
        while (read(p[0], &ch, 1) > 0)
  b8:	8626                	mv	a2,s1
  ba:	85ca                	mv	a1,s2
  bc:	fc842503          	lw	a0,-56(s0)
  c0:	2e0000ef          	jal	3a0 <read>
  c4:	fea045e3          	bgtz	a0,ae <main+0xae>
        close(p[0]);
  c8:	fc842503          	lw	a0,-56(s0)
  cc:	2e4000ef          	jal	3b0 <close>
  d0:	bf41                	j	60 <main+0x60>

00000000000000d2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  da:	f27ff0ef          	jal	0 <main>
  exit(r);
  de:	2aa000ef          	jal	388 <exit>

00000000000000e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e406                	sd	ra,8(sp)
  e6:	e022                	sd	s0,0(sp)
  e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ea:	87aa                	mv	a5,a0
  ec:	0585                	addi	a1,a1,1
  ee:	0785                	addi	a5,a5,1
  f0:	fff5c703          	lbu	a4,-1(a1)
  f4:	fee78fa3          	sb	a4,-1(a5)
  f8:	fb75                	bnez	a4,ec <strcpy+0xa>
    ;
  return os;
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cb91                	beqz	a5,122 <strcmp+0x20>
 110:	0005c703          	lbu	a4,0(a1)
 114:	00f71763          	bne	a4,a5,122 <strcmp+0x20>
    p++, q++;
 118:	0505                	addi	a0,a0,1
 11a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbe5                	bnez	a5,110 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 122:	0005c503          	lbu	a0,0(a1)
}
 126:	40a7853b          	subw	a0,a5,a0
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strlen>:

uint
strlen(const char *s)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cf91                	beqz	a5,15a <strlen+0x28>
 140:	00150793          	addi	a5,a0,1
 144:	86be                	mv	a3,a5
 146:	0785                	addi	a5,a5,1
 148:	fff7c703          	lbu	a4,-1(a5)
 14c:	ff65                	bnez	a4,144 <strlen+0x12>
 14e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 152:	60a2                	ld	ra,8(sp)
 154:	6402                	ld	s0,0(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret
  for(n = 0; s[n]; n++)
 15a:	4501                	li	a0,0
 15c:	bfdd                	j	152 <strlen+0x20>

000000000000015e <memset>:

void*
memset(void *dst, int c, uint n)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e406                	sd	ra,8(sp)
 162:	e022                	sd	s0,0(sp)
 164:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 166:	ca19                	beqz	a2,17c <memset+0x1e>
 168:	87aa                	mv	a5,a0
 16a:	1602                	slli	a2,a2,0x20
 16c:	9201                	srli	a2,a2,0x20
 16e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 172:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 176:	0785                	addi	a5,a5,1
 178:	fee79de3          	bne	a5,a4,172 <memset+0x14>
  }
  return dst;
}
 17c:	60a2                	ld	ra,8(sp)
 17e:	6402                	ld	s0,0(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strchr>:

char*
strchr(const char *s, char c)
{
 184:	1141                	addi	sp,sp,-16
 186:	e406                	sd	ra,8(sp)
 188:	e022                	sd	s0,0(sp)
 18a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 18c:	00054783          	lbu	a5,0(a0)
 190:	cf81                	beqz	a5,1a8 <strchr+0x24>
    if(*s == c)
 192:	00f58763          	beq	a1,a5,1a0 <strchr+0x1c>
  for(; *s; s++)
 196:	0505                	addi	a0,a0,1
 198:	00054783          	lbu	a5,0(a0)
 19c:	fbfd                	bnez	a5,192 <strchr+0xe>
      return (char*)s;
  return 0;
 19e:	4501                	li	a0,0
}
 1a0:	60a2                	ld	ra,8(sp)
 1a2:	6402                	ld	s0,0(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret
  return 0;
 1a8:	4501                	li	a0,0
 1aa:	bfdd                	j	1a0 <strchr+0x1c>

00000000000001ac <gets>:

char*
gets(char *buf, int max)
{
 1ac:	711d                	addi	sp,sp,-96
 1ae:	ec86                	sd	ra,88(sp)
 1b0:	e8a2                	sd	s0,80(sp)
 1b2:	e4a6                	sd	s1,72(sp)
 1b4:	e0ca                	sd	s2,64(sp)
 1b6:	fc4e                	sd	s3,56(sp)
 1b8:	f852                	sd	s4,48(sp)
 1ba:	f456                	sd	s5,40(sp)
 1bc:	f05a                	sd	s6,32(sp)
 1be:	ec5e                	sd	s7,24(sp)
 1c0:	e862                	sd	s8,16(sp)
 1c2:	1080                	addi	s0,sp,96
 1c4:	8baa                	mv	s7,a0
 1c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	892a                	mv	s2,a0
 1ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1cc:	faf40b13          	addi	s6,s0,-81
 1d0:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1d2:	8c26                	mv	s8,s1
 1d4:	0014899b          	addiw	s3,s1,1
 1d8:	84ce                	mv	s1,s3
 1da:	0349d463          	bge	s3,s4,202 <gets+0x56>
    cc = read(0, &c, 1);
 1de:	8656                	mv	a2,s5
 1e0:	85da                	mv	a1,s6
 1e2:	4501                	li	a0,0
 1e4:	1bc000ef          	jal	3a0 <read>
    if(cc < 1)
 1e8:	00a05d63          	blez	a0,202 <gets+0x56>
      break;
    buf[i++] = c;
 1ec:	faf44783          	lbu	a5,-81(s0)
 1f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f4:	0905                	addi	s2,s2,1
 1f6:	ff678713          	addi	a4,a5,-10
 1fa:	c319                	beqz	a4,200 <gets+0x54>
 1fc:	17cd                	addi	a5,a5,-13
 1fe:	fbf1                	bnez	a5,1d2 <gets+0x26>
    buf[i++] = c;
 200:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 202:	9c5e                	add	s8,s8,s7
 204:	000c0023          	sb	zero,0(s8)
  return buf;
}
 208:	855e                	mv	a0,s7
 20a:	60e6                	ld	ra,88(sp)
 20c:	6446                	ld	s0,80(sp)
 20e:	64a6                	ld	s1,72(sp)
 210:	6906                	ld	s2,64(sp)
 212:	79e2                	ld	s3,56(sp)
 214:	7a42                	ld	s4,48(sp)
 216:	7aa2                	ld	s5,40(sp)
 218:	7b02                	ld	s6,32(sp)
 21a:	6be2                	ld	s7,24(sp)
 21c:	6c42                	ld	s8,16(sp)
 21e:	6125                	addi	sp,sp,96
 220:	8082                	ret

0000000000000222 <stat>:

int
stat(const char *n, struct stat *st)
{
 222:	1101                	addi	sp,sp,-32
 224:	ec06                	sd	ra,24(sp)
 226:	e822                	sd	s0,16(sp)
 228:	e04a                	sd	s2,0(sp)
 22a:	1000                	addi	s0,sp,32
 22c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	4581                	li	a1,0
 230:	198000ef          	jal	3c8 <open>
  if(fd < 0)
 234:	02054263          	bltz	a0,258 <stat+0x36>
 238:	e426                	sd	s1,8(sp)
 23a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23c:	85ca                	mv	a1,s2
 23e:	1a2000ef          	jal	3e0 <fstat>
 242:	892a                	mv	s2,a0
  close(fd);
 244:	8526                	mv	a0,s1
 246:	16a000ef          	jal	3b0 <close>
  return r;
 24a:	64a2                	ld	s1,8(sp)
}
 24c:	854a                	mv	a0,s2
 24e:	60e2                	ld	ra,24(sp)
 250:	6442                	ld	s0,16(sp)
 252:	6902                	ld	s2,0(sp)
 254:	6105                	addi	sp,sp,32
 256:	8082                	ret
    return -1;
 258:	57fd                	li	a5,-1
 25a:	893e                	mv	s2,a5
 25c:	bfc5                	j	24c <stat+0x2a>

000000000000025e <atoi>:

int
atoi(const char *s)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 266:	00054683          	lbu	a3,0(a0)
 26a:	fd06879b          	addiw	a5,a3,-48
 26e:	0ff7f793          	zext.b	a5,a5
 272:	4625                	li	a2,9
 274:	02f66963          	bltu	a2,a5,2a6 <atoi+0x48>
 278:	872a                	mv	a4,a0
  n = 0;
 27a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 27c:	0705                	addi	a4,a4,1
 27e:	0025179b          	slliw	a5,a0,0x2
 282:	9fa9                	addw	a5,a5,a0
 284:	0017979b          	slliw	a5,a5,0x1
 288:	9fb5                	addw	a5,a5,a3
 28a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28e:	00074683          	lbu	a3,0(a4)
 292:	fd06879b          	addiw	a5,a3,-48
 296:	0ff7f793          	zext.b	a5,a5
 29a:	fef671e3          	bgeu	a2,a5,27c <atoi+0x1e>
  return n;
}
 29e:	60a2                	ld	ra,8(sp)
 2a0:	6402                	ld	s0,0(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
  n = 0;
 2a6:	4501                	li	a0,0
 2a8:	bfdd                	j	29e <atoi+0x40>

00000000000002aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b2:	02b57563          	bgeu	a0,a1,2dc <memmove+0x32>
    while(n-- > 0)
 2b6:	00c05f63          	blez	a2,2d4 <memmove+0x2a>
 2ba:	1602                	slli	a2,a2,0x20
 2bc:	9201                	srli	a2,a2,0x20
 2be:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c4:	0585                	addi	a1,a1,1
 2c6:	0705                	addi	a4,a4,1
 2c8:	fff5c683          	lbu	a3,-1(a1)
 2cc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d0:	fee79ae3          	bne	a5,a4,2c4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
    while(n-- > 0)
 2dc:	fec05ce3          	blez	a2,2d4 <memmove+0x2a>
    dst += n;
 2e0:	00c50733          	add	a4,a0,a2
    src += n;
 2e4:	95b2                	add	a1,a1,a2
 2e6:	fff6079b          	addiw	a5,a2,-1
 2ea:	1782                	slli	a5,a5,0x20
 2ec:	9381                	srli	a5,a5,0x20
 2ee:	fff7c793          	not	a5,a5
 2f2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f4:	15fd                	addi	a1,a1,-1
 2f6:	177d                	addi	a4,a4,-1
 2f8:	0005c683          	lbu	a3,0(a1)
 2fc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 300:	fef71ae3          	bne	a4,a5,2f4 <memmove+0x4a>
 304:	bfc1                	j	2d4 <memmove+0x2a>

0000000000000306 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30e:	c61d                	beqz	a2,33c <memcmp+0x36>
 310:	1602                	slli	a2,a2,0x20
 312:	9201                	srli	a2,a2,0x20
 314:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 318:	00054783          	lbu	a5,0(a0)
 31c:	0005c703          	lbu	a4,0(a1)
 320:	00e79863          	bne	a5,a4,330 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 324:	0505                	addi	a0,a0,1
    p2++;
 326:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 328:	fed518e3          	bne	a0,a3,318 <memcmp+0x12>
  }
  return 0;
 32c:	4501                	li	a0,0
 32e:	a019                	j	334 <memcmp+0x2e>
      return *p1 - *p2;
 330:	40e7853b          	subw	a0,a5,a4
}
 334:	60a2                	ld	ra,8(sp)
 336:	6402                	ld	s0,0(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
  return 0;
 33c:	4501                	li	a0,0
 33e:	bfdd                	j	334 <memcmp+0x2e>

0000000000000340 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 348:	f63ff0ef          	jal	2aa <memmove>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <sbrk>:

char *
sbrk(int n) {
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 35c:	4585                	li	a1,1
 35e:	0b2000ef          	jal	410 <sys_sbrk>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <sbrklazy>:

char *
sbrklazy(int n) {
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 372:	4589                	li	a1,2
 374:	09c000ef          	jal	410 <sys_sbrk>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 380:	4885                	li	a7,1
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exit>:
.global exit
exit:
 li a7, SYS_exit
 388:	4889                	li	a7,2
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <wait>:
.global wait
wait:
 li a7, SYS_wait
 390:	488d                	li	a7,3
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 398:	4891                	li	a7,4
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <read>:
.global read
read:
 li a7, SYS_read
 3a0:	4895                	li	a7,5
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <write>:
.global write
write:
 li a7, SYS_write
 3a8:	48c1                	li	a7,16
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <close>:
.global close
close:
 li a7, SYS_close
 3b0:	48d5                	li	a7,21
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b8:	4899                	li	a7,6
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c0:	489d                	li	a7,7
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <open>:
.global open
open:
 li a7, SYS_open
 3c8:	48bd                	li	a7,15
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d0:	48c5                	li	a7,17
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d8:	48c9                	li	a7,18
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e0:	48a1                	li	a7,8
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <link>:
.global link
link:
 li a7, SYS_link
 3e8:	48cd                	li	a7,19
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f0:	48d1                	li	a7,20
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f8:	48a5                	li	a7,9
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <dup>:
.global dup
dup:
 li a7, SYS_dup
 400:	48a9                	li	a7,10
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 408:	48ad                	li	a7,11
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 410:	48b1                	li	a7,12
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <pause>:
.global pause
pause:
 li a7, SYS_pause
 418:	48b5                	li	a7,13
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 420:	48b9                	li	a7,14
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <kps>:
.global kps
kps:
 li a7, SYS_kps
 428:	48d9                	li	a7,22
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 430:	48dd                	li	a7,23
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 438:	48e1                	li	a7,24
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 440:	48e5                	li	a7,25
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 448:	48e9                	li	a7,26
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 450:	1101                	addi	sp,sp,-32
 452:	ec06                	sd	ra,24(sp)
 454:	e822                	sd	s0,16(sp)
 456:	1000                	addi	s0,sp,32
 458:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45c:	4605                	li	a2,1
 45e:	fef40593          	addi	a1,s0,-17
 462:	f47ff0ef          	jal	3a8 <write>
}
 466:	60e2                	ld	ra,24(sp)
 468:	6442                	ld	s0,16(sp)
 46a:	6105                	addi	sp,sp,32
 46c:	8082                	ret

000000000000046e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 46e:	715d                	addi	sp,sp,-80
 470:	e486                	sd	ra,72(sp)
 472:	e0a2                	sd	s0,64(sp)
 474:	f84a                	sd	s2,48(sp)
 476:	f44e                	sd	s3,40(sp)
 478:	0880                	addi	s0,sp,80
 47a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 47c:	c6d1                	beqz	a3,508 <printint+0x9a>
 47e:	0805d563          	bgez	a1,508 <printint+0x9a>
    neg = 1;
    x = -xx;
 482:	40b005b3          	neg	a1,a1
    neg = 1;
 486:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 488:	fb840993          	addi	s3,s0,-72
  neg = 0;
 48c:	86ce                	mv	a3,s3
  i = 0;
 48e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 490:	00000817          	auipc	a6,0x0
 494:	59080813          	addi	a6,a6,1424 # a20 <digits>
 498:	88ba                	mv	a7,a4
 49a:	0017051b          	addiw	a0,a4,1
 49e:	872a                	mv	a4,a0
 4a0:	02c5f7b3          	remu	a5,a1,a2
 4a4:	97c2                	add	a5,a5,a6
 4a6:	0007c783          	lbu	a5,0(a5)
 4aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ae:	87ae                	mv	a5,a1
 4b0:	02c5d5b3          	divu	a1,a1,a2
 4b4:	0685                	addi	a3,a3,1
 4b6:	fec7f1e3          	bgeu	a5,a2,498 <printint+0x2a>
  if(neg)
 4ba:	00030c63          	beqz	t1,4d2 <printint+0x64>
    buf[i++] = '-';
 4be:	fd050793          	addi	a5,a0,-48
 4c2:	00878533          	add	a0,a5,s0
 4c6:	02d00793          	li	a5,45
 4ca:	fef50423          	sb	a5,-24(a0)
 4ce:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4d2:	02e05563          	blez	a4,4fc <printint+0x8e>
 4d6:	fc26                	sd	s1,56(sp)
 4d8:	377d                	addiw	a4,a4,-1
 4da:	00e984b3          	add	s1,s3,a4
 4de:	19fd                	addi	s3,s3,-1
 4e0:	99ba                	add	s3,s3,a4
 4e2:	1702                	slli	a4,a4,0x20
 4e4:	9301                	srli	a4,a4,0x20
 4e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ea:	0004c583          	lbu	a1,0(s1)
 4ee:	854a                	mv	a0,s2
 4f0:	f61ff0ef          	jal	450 <putc>
  while(--i >= 0)
 4f4:	14fd                	addi	s1,s1,-1
 4f6:	ff349ae3          	bne	s1,s3,4ea <printint+0x7c>
 4fa:	74e2                	ld	s1,56(sp)
}
 4fc:	60a6                	ld	ra,72(sp)
 4fe:	6406                	ld	s0,64(sp)
 500:	7942                	ld	s2,48(sp)
 502:	79a2                	ld	s3,40(sp)
 504:	6161                	addi	sp,sp,80
 506:	8082                	ret
  neg = 0;
 508:	4301                	li	t1,0
 50a:	bfbd                	j	488 <printint+0x1a>

000000000000050c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50c:	711d                	addi	sp,sp,-96
 50e:	ec86                	sd	ra,88(sp)
 510:	e8a2                	sd	s0,80(sp)
 512:	e4a6                	sd	s1,72(sp)
 514:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 516:	0005c483          	lbu	s1,0(a1)
 51a:	22048363          	beqz	s1,740 <vprintf+0x234>
 51e:	e0ca                	sd	s2,64(sp)
 520:	fc4e                	sd	s3,56(sp)
 522:	f852                	sd	s4,48(sp)
 524:	f456                	sd	s5,40(sp)
 526:	f05a                	sd	s6,32(sp)
 528:	ec5e                	sd	s7,24(sp)
 52a:	e862                	sd	s8,16(sp)
 52c:	8b2a                	mv	s6,a0
 52e:	8a2e                	mv	s4,a1
 530:	8bb2                	mv	s7,a2
  state = 0;
 532:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 534:	4901                	li	s2,0
 536:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 538:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 53c:	06400c13          	li	s8,100
 540:	a00d                	j	562 <vprintf+0x56>
        putc(fd, c0);
 542:	85a6                	mv	a1,s1
 544:	855a                	mv	a0,s6
 546:	f0bff0ef          	jal	450 <putc>
 54a:	a019                	j	550 <vprintf+0x44>
    } else if(state == '%'){
 54c:	03598363          	beq	s3,s5,572 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 550:	0019079b          	addiw	a5,s2,1
 554:	893e                	mv	s2,a5
 556:	873e                	mv	a4,a5
 558:	97d2                	add	a5,a5,s4
 55a:	0007c483          	lbu	s1,0(a5)
 55e:	1c048a63          	beqz	s1,732 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 562:	0004879b          	sext.w	a5,s1
    if(state == 0){
 566:	fe0993e3          	bnez	s3,54c <vprintf+0x40>
      if(c0 == '%'){
 56a:	fd579ce3          	bne	a5,s5,542 <vprintf+0x36>
        state = '%';
 56e:	89be                	mv	s3,a5
 570:	b7c5                	j	550 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 572:	00ea06b3          	add	a3,s4,a4
 576:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 57a:	1c060863          	beqz	a2,74a <vprintf+0x23e>
      if(c0 == 'd'){
 57e:	03878763          	beq	a5,s8,5ac <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 582:	f9478693          	addi	a3,a5,-108
 586:	0016b693          	seqz	a3,a3
 58a:	f9c60593          	addi	a1,a2,-100
 58e:	e99d                	bnez	a1,5c4 <vprintf+0xb8>
 590:	ca95                	beqz	a3,5c4 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	008b8493          	addi	s1,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000bb583          	ld	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	ecfff0ef          	jal	46e <printint>
        i += 1;
 5a4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b75d                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5ac:	008b8493          	addi	s1,s7,8
 5b0:	4685                	li	a3,1
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	eb5ff0ef          	jal	46e <printint>
 5be:	8ba6                	mv	s7,s1
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b779                	j	550 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5c4:	9752                	add	a4,a4,s4
 5c6:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ca:	f9460713          	addi	a4,a2,-108
 5ce:	00173713          	seqz	a4,a4
 5d2:	8f75                	and	a4,a4,a3
 5d4:	f9c58513          	addi	a0,a1,-100
 5d8:	18051363          	bnez	a0,75e <vprintf+0x252>
 5dc:	18070163          	beqz	a4,75e <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e81ff0ef          	jal	46e <printint>
        i += 2;
 5f2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
        i += 2;
 5f8:	bfa1                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5fa:	008b8493          	addi	s1,s7,8
 5fe:	4681                	li	a3,0
 600:	4629                	li	a2,10
 602:	000be583          	lwu	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	e67ff0ef          	jal	46e <printint>
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
 610:	b781                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	008b8493          	addi	s1,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e4fff0ef          	jal	46e <printint>
        i += 1;
 624:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
 62a:	b71d                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000bb583          	ld	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	e35ff0ef          	jal	46e <printint>
        i += 2;
 63e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	8ba6                	mv	s7,s1
      state = 0;
 642:	4981                	li	s3,0
        i += 2;
 644:	b731                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 646:	008b8493          	addi	s1,s7,8
 64a:	4681                	li	a3,0
 64c:	4641                	li	a2,16
 64e:	000be583          	lwu	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	e1bff0ef          	jal	46e <printint>
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bdd5                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4681                	li	a3,0
 664:	4641                	li	a2,16
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e03ff0ef          	jal	46e <printint>
        i += 1;
 670:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
 676:	bde9                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4641                	li	a2,16
 680:	000bb583          	ld	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	de9ff0ef          	jal	46e <printint>
        i += 2;
 68a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	8ba6                	mv	s7,s1
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	b5c1                	j	550 <vprintf+0x44>
 692:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 694:	008b8793          	addi	a5,s7,8
 698:	8cbe                	mv	s9,a5
 69a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 69e:	03000593          	li	a1,48
 6a2:	855a                	mv	a0,s6
 6a4:	dadff0ef          	jal	450 <putc>
  putc(fd, 'x');
 6a8:	07800593          	li	a1,120
 6ac:	855a                	mv	a0,s6
 6ae:	da3ff0ef          	jal	450 <putc>
 6b2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b4:	00000b97          	auipc	s7,0x0
 6b8:	36cb8b93          	addi	s7,s7,876 # a20 <digits>
 6bc:	03c9d793          	srli	a5,s3,0x3c
 6c0:	97de                	add	a5,a5,s7
 6c2:	0007c583          	lbu	a1,0(a5)
 6c6:	855a                	mv	a0,s6
 6c8:	d89ff0ef          	jal	450 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6cc:	0992                	slli	s3,s3,0x4
 6ce:	34fd                	addiw	s1,s1,-1
 6d0:	f4f5                	bnez	s1,6bc <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6d2:	8be6                	mv	s7,s9
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	6ca2                	ld	s9,8(sp)
 6d8:	bda5                	j	550 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6da:	008b8493          	addi	s1,s7,8
 6de:	000bc583          	lbu	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	d6dff0ef          	jal	450 <putc>
 6e8:	8ba6                	mv	s7,s1
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b595                	j	550 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6ee:	008b8993          	addi	s3,s7,8
 6f2:	000bb483          	ld	s1,0(s7)
 6f6:	cc91                	beqz	s1,712 <vprintf+0x206>
        for(; *s; s++)
 6f8:	0004c583          	lbu	a1,0(s1)
 6fc:	c985                	beqz	a1,72c <vprintf+0x220>
          putc(fd, *s);
 6fe:	855a                	mv	a0,s6
 700:	d51ff0ef          	jal	450 <putc>
        for(; *s; s++)
 704:	0485                	addi	s1,s1,1
 706:	0004c583          	lbu	a1,0(s1)
 70a:	f9f5                	bnez	a1,6fe <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 70c:	8bce                	mv	s7,s3
      state = 0;
 70e:	4981                	li	s3,0
 710:	b581                	j	550 <vprintf+0x44>
          s = "(null)";
 712:	00000497          	auipc	s1,0x0
 716:	30648493          	addi	s1,s1,774 # a18 <malloc+0x16a>
        for(; *s; s++)
 71a:	02800593          	li	a1,40
 71e:	b7c5                	j	6fe <vprintf+0x1f2>
        putc(fd, '%');
 720:	85be                	mv	a1,a5
 722:	855a                	mv	a0,s6
 724:	d2dff0ef          	jal	450 <putc>
      state = 0;
 728:	4981                	li	s3,0
 72a:	b51d                	j	550 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 72c:	8bce                	mv	s7,s3
      state = 0;
 72e:	4981                	li	s3,0
 730:	b505                	j	550 <vprintf+0x44>
 732:	6906                	ld	s2,64(sp)
 734:	79e2                	ld	s3,56(sp)
 736:	7a42                	ld	s4,48(sp)
 738:	7aa2                	ld	s5,40(sp)
 73a:	7b02                	ld	s6,32(sp)
 73c:	6be2                	ld	s7,24(sp)
 73e:	6c42                	ld	s8,16(sp)
    }
  }
}
 740:	60e6                	ld	ra,88(sp)
 742:	6446                	ld	s0,80(sp)
 744:	64a6                	ld	s1,72(sp)
 746:	6125                	addi	sp,sp,96
 748:	8082                	ret
      if(c0 == 'd'){
 74a:	06400713          	li	a4,100
 74e:	e4e78fe3          	beq	a5,a4,5ac <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 752:	f9478693          	addi	a3,a5,-108
 756:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 75a:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 75c:	4701                	li	a4,0
      } else if(c0 == 'u'){
 75e:	07500513          	li	a0,117
 762:	e8a78ce3          	beq	a5,a0,5fa <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 766:	f8b60513          	addi	a0,a2,-117
 76a:	e119                	bnez	a0,770 <vprintf+0x264>
 76c:	ea0693e3          	bnez	a3,612 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 770:	f8b58513          	addi	a0,a1,-117
 774:	e119                	bnez	a0,77a <vprintf+0x26e>
 776:	ea071be3          	bnez	a4,62c <vprintf+0x120>
      } else if(c0 == 'x'){
 77a:	07800513          	li	a0,120
 77e:	eca784e3          	beq	a5,a0,646 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 782:	f8860613          	addi	a2,a2,-120
 786:	e219                	bnez	a2,78c <vprintf+0x280>
 788:	ec069be3          	bnez	a3,65e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 78c:	f8858593          	addi	a1,a1,-120
 790:	e199                	bnez	a1,796 <vprintf+0x28a>
 792:	ee0713e3          	bnez	a4,678 <vprintf+0x16c>
      } else if(c0 == 'p'){
 796:	07000713          	li	a4,112
 79a:	eee78ce3          	beq	a5,a4,692 <vprintf+0x186>
      } else if(c0 == 'c'){
 79e:	06300713          	li	a4,99
 7a2:	f2e78ce3          	beq	a5,a4,6da <vprintf+0x1ce>
      } else if(c0 == 's'){
 7a6:	07300713          	li	a4,115
 7aa:	f4e782e3          	beq	a5,a4,6ee <vprintf+0x1e2>
      } else if(c0 == '%'){
 7ae:	02500713          	li	a4,37
 7b2:	f6e787e3          	beq	a5,a4,720 <vprintf+0x214>
        putc(fd, '%');
 7b6:	02500593          	li	a1,37
 7ba:	855a                	mv	a0,s6
 7bc:	c95ff0ef          	jal	450 <putc>
        putc(fd, c0);
 7c0:	85a6                	mv	a1,s1
 7c2:	855a                	mv	a0,s6
 7c4:	c8dff0ef          	jal	450 <putc>
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	b359                	j	550 <vprintf+0x44>

00000000000007cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7cc:	715d                	addi	sp,sp,-80
 7ce:	ec06                	sd	ra,24(sp)
 7d0:	e822                	sd	s0,16(sp)
 7d2:	1000                	addi	s0,sp,32
 7d4:	e010                	sd	a2,0(s0)
 7d6:	e414                	sd	a3,8(s0)
 7d8:	e818                	sd	a4,16(s0)
 7da:	ec1c                	sd	a5,24(s0)
 7dc:	03043023          	sd	a6,32(s0)
 7e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e4:	8622                	mv	a2,s0
 7e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ea:	d23ff0ef          	jal	50c <vprintf>
}
 7ee:	60e2                	ld	ra,24(sp)
 7f0:	6442                	ld	s0,16(sp)
 7f2:	6161                	addi	sp,sp,80
 7f4:	8082                	ret

00000000000007f6 <printf>:

void
printf(const char *fmt, ...)
{
 7f6:	711d                	addi	sp,sp,-96
 7f8:	ec06                	sd	ra,24(sp)
 7fa:	e822                	sd	s0,16(sp)
 7fc:	1000                	addi	s0,sp,32
 7fe:	e40c                	sd	a1,8(s0)
 800:	e810                	sd	a2,16(s0)
 802:	ec14                	sd	a3,24(s0)
 804:	f018                	sd	a4,32(s0)
 806:	f41c                	sd	a5,40(s0)
 808:	03043823          	sd	a6,48(s0)
 80c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 810:	00840613          	addi	a2,s0,8
 814:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 818:	85aa                	mv	a1,a0
 81a:	4505                	li	a0,1
 81c:	cf1ff0ef          	jal	50c <vprintf>
}
 820:	60e2                	ld	ra,24(sp)
 822:	6442                	ld	s0,16(sp)
 824:	6125                	addi	sp,sp,96
 826:	8082                	ret

0000000000000828 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 828:	1141                	addi	sp,sp,-16
 82a:	e406                	sd	ra,8(sp)
 82c:	e022                	sd	s0,0(sp)
 82e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 830:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	00000797          	auipc	a5,0x0
 838:	7cc7b783          	ld	a5,1996(a5) # 1000 <freep>
 83c:	a039                	j	84a <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	6398                	ld	a4,0(a5)
 840:	00e7e463          	bltu	a5,a4,848 <free+0x20>
 844:	00e6ea63          	bltu	a3,a4,858 <free+0x30>
{
 848:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84a:	fed7fae3          	bgeu	a5,a3,83e <free+0x16>
 84e:	6398                	ld	a4,0(a5)
 850:	00e6e463          	bltu	a3,a4,858 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	fee7eae3          	bltu	a5,a4,848 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 858:	ff852583          	lw	a1,-8(a0)
 85c:	6390                	ld	a2,0(a5)
 85e:	02059813          	slli	a6,a1,0x20
 862:	01c85713          	srli	a4,a6,0x1c
 866:	9736                	add	a4,a4,a3
 868:	02e60563          	beq	a2,a4,892 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 86c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 870:	4790                	lw	a2,8(a5)
 872:	02061593          	slli	a1,a2,0x20
 876:	01c5d713          	srli	a4,a1,0x1c
 87a:	973e                	add	a4,a4,a5
 87c:	02e68263          	beq	a3,a4,8a0 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 880:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 882:	00000717          	auipc	a4,0x0
 886:	76f73f23          	sd	a5,1918(a4) # 1000 <freep>
}
 88a:	60a2                	ld	ra,8(sp)
 88c:	6402                	ld	s0,0(sp)
 88e:	0141                	addi	sp,sp,16
 890:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 892:	4618                	lw	a4,8(a2)
 894:	9f2d                	addw	a4,a4,a1
 896:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89a:	6398                	ld	a4,0(a5)
 89c:	6310                	ld	a2,0(a4)
 89e:	b7f9                	j	86c <free+0x44>
    p->s.size += bp->s.size;
 8a0:	ff852703          	lw	a4,-8(a0)
 8a4:	9f31                	addw	a4,a4,a2
 8a6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a8:	ff053683          	ld	a3,-16(a0)
 8ac:	bfd1                	j	880 <free+0x58>

00000000000008ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ae:	7139                	addi	sp,sp,-64
 8b0:	fc06                	sd	ra,56(sp)
 8b2:	f822                	sd	s0,48(sp)
 8b4:	f04a                	sd	s2,32(sp)
 8b6:	ec4e                	sd	s3,24(sp)
 8b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	02051993          	slli	s3,a0,0x20
 8be:	0209d993          	srli	s3,s3,0x20
 8c2:	09bd                	addi	s3,s3,15
 8c4:	0049d993          	srli	s3,s3,0x4
 8c8:	2985                	addiw	s3,s3,1
 8ca:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8cc:	00000517          	auipc	a0,0x0
 8d0:	73453503          	ld	a0,1844(a0) # 1000 <freep>
 8d4:	c905                	beqz	a0,904 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d8:	4798                	lw	a4,8(a5)
 8da:	09377663          	bgeu	a4,s3,966 <malloc+0xb8>
 8de:	f426                	sd	s1,40(sp)
 8e0:	e852                	sd	s4,16(sp)
 8e2:	e456                	sd	s5,8(sp)
 8e4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8e6:	8a4e                	mv	s4,s3
 8e8:	6705                	lui	a4,0x1
 8ea:	00e9f363          	bgeu	s3,a4,8f0 <malloc+0x42>
 8ee:	6a05                	lui	s4,0x1
 8f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f8:	00000497          	auipc	s1,0x0
 8fc:	70848493          	addi	s1,s1,1800 # 1000 <freep>
  if(p == SBRK_ERROR)
 900:	5afd                	li	s5,-1
 902:	a83d                	j	940 <malloc+0x92>
 904:	f426                	sd	s1,40(sp)
 906:	e852                	sd	s4,16(sp)
 908:	e456                	sd	s5,8(sp)
 90a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 90c:	00000797          	auipc	a5,0x0
 910:	70478793          	addi	a5,a5,1796 # 1010 <base>
 914:	00000717          	auipc	a4,0x0
 918:	6ef73623          	sd	a5,1772(a4) # 1000 <freep>
 91c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 922:	b7d1                	j	8e6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 924:	6398                	ld	a4,0(a5)
 926:	e118                	sd	a4,0(a0)
 928:	a899                	j	97e <malloc+0xd0>
  hp->s.size = nu;
 92a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92e:	0541                	addi	a0,a0,16
 930:	ef9ff0ef          	jal	828 <free>
  return freep;
 934:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 936:	c125                	beqz	a0,996 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 938:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93a:	4798                	lw	a4,8(a5)
 93c:	03277163          	bgeu	a4,s2,95e <malloc+0xb0>
    if(p == freep)
 940:	6098                	ld	a4,0(s1)
 942:	853e                	mv	a0,a5
 944:	fef71ae3          	bne	a4,a5,938 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 948:	8552                	mv	a0,s4
 94a:	a0bff0ef          	jal	354 <sbrk>
  if(p == SBRK_ERROR)
 94e:	fd551ee3          	bne	a0,s5,92a <malloc+0x7c>
        return 0;
 952:	4501                	li	a0,0
 954:	74a2                	ld	s1,40(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
 95c:	a03d                	j	98a <malloc+0xdc>
 95e:	74a2                	ld	s1,40(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 966:	fae90fe3          	beq	s2,a4,924 <malloc+0x76>
        p->s.size -= nunits;
 96a:	4137073b          	subw	a4,a4,s3
 96e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 970:	02071693          	slli	a3,a4,0x20
 974:	01c6d713          	srli	a4,a3,0x1c
 978:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97e:	00000717          	auipc	a4,0x0
 982:	68a73123          	sd	a0,1666(a4) # 1000 <freep>
      return (void*)(p + 1);
 986:	01078513          	addi	a0,a5,16
  }
}
 98a:	70e2                	ld	ra,56(sp)
 98c:	7442                	ld	s0,48(sp)
 98e:	7902                	ld	s2,32(sp)
 990:	69e2                	ld	s3,24(sp)
 992:	6121                	addi	sp,sp,64
 994:	8082                	ret
 996:	74a2                	ld	s1,40(sp)
 998:	6a42                	ld	s4,16(sp)
 99a:	6aa2                	ld	s5,8(sp)
 99c:	6b02                	ld	s6,0(sp)
 99e:	b7f5                	j	98a <malloc+0xdc>
