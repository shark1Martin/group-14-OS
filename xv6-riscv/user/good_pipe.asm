
user/_good_pipe:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"

int main(void)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    int pid;

    char *haiku = "The light of a candle\nfluttering in the wind\nthe first star of night.\n";

    // create the pipe using the pipe() system call
    if (pipe(p) < 0)
   8:	fd840513          	addi	a0,s0,-40
   c:	352000ef          	jal	35e <pipe>
  10:	04054563          	bltz	a0,5a <main+0x5a>
        printf("pipe creation failed\n");
        exit(1);
    }

    // Fork a child process
    pid = fork();
  14:	332000ef          	jal	346 <fork>

    // if pid negative, fork failed
    if (pid < 0)
  18:	04054b63          	bltz	a0,6e <main+0x6e>
  1c:	ec26                	sd	s1,24(sp)
    {
        printf("fork failed\n");
        exit(1);
    }
    // PARENT: parent process has the pid of child
    if (pid > 0)
  1e:	06a05263          	blez	a0,82 <main+0x82>
    {
        // parent writes, so close read end
        close(p[0]);
  22:	fd842503          	lw	a0,-40(s0)
  26:	350000ef          	jal	376 <close>

        // Write the haiku into the pipe, one byte at a time
        int i = 0;
        while (haiku[i] != '\0')
  2a:	00001497          	auipc	s1,0x1
  2e:	92648493          	addi	s1,s1,-1754 # 950 <malloc+0xfe>
        {
            // write file descriptor, a char from haiku, reading max 1 char 
            write(p[1], &haiku[i], 1);
  32:	4605                	li	a2,1
  34:	85a6                	mv	a1,s1
  36:	fdc42503          	lw	a0,-36(s0)
  3a:	334000ef          	jal	36e <write>
        while (haiku[i] != '\0')
  3e:	0485                	addi	s1,s1,1
  40:	0004c783          	lbu	a5,0(s1)
  44:	f7fd                	bnez	a5,32 <main+0x32>
            i++;
        }

        // Close write rend
        close(p[1]);
  46:	fdc42503          	lw	a0,-36(s0)
  4a:	32c000ef          	jal	376 <close>

        // pause parent, wait for the child to finish
        wait(0);
  4e:	4501                	li	a0,0
  50:	306000ef          	jal	356 <wait>

        // close the read end
        close(p[0]);
    }

    exit(0);
  54:	4501                	li	a0,0
  56:	2f8000ef          	jal	34e <exit>
  5a:	ec26                	sd	s1,24(sp)
        printf("pipe creation failed\n");
  5c:	00001517          	auipc	a0,0x1
  60:	93c50513          	addi	a0,a0,-1732 # 998 <malloc+0x146>
  64:	73a000ef          	jal	79e <printf>
        exit(1);
  68:	4505                	li	a0,1
  6a:	2e4000ef          	jal	34e <exit>
  6e:	ec26                	sd	s1,24(sp)
        printf("fork failed\n");
  70:	00001517          	auipc	a0,0x1
  74:	94050513          	addi	a0,a0,-1728 # 9b0 <malloc+0x15e>
  78:	726000ef          	jal	79e <printf>
        exit(1);
  7c:	4505                	li	a0,1
  7e:	2d0000ef          	jal	34e <exit>
        close(p[1]);
  82:	fdc42503          	lw	a0,-36(s0)
  86:	2f0000ef          	jal	376 <close>
            printf("%c", ch);
  8a:	00001497          	auipc	s1,0x1
  8e:	93648493          	addi	s1,s1,-1738 # 9c0 <malloc+0x16e>
        while (read(p[0], &ch, 1) > 0)
  92:	a031                	j	9e <main+0x9e>
            printf("%c", ch);
  94:	fd744583          	lbu	a1,-41(s0)
  98:	8526                	mv	a0,s1
  9a:	704000ef          	jal	79e <printf>
        while (read(p[0], &ch, 1) > 0)
  9e:	4605                	li	a2,1
  a0:	fd740593          	addi	a1,s0,-41
  a4:	fd842503          	lw	a0,-40(s0)
  a8:	2be000ef          	jal	366 <read>
  ac:	fea044e3          	bgtz	a0,94 <main+0x94>
        close(p[0]);
  b0:	fd842503          	lw	a0,-40(s0)
  b4:	2c2000ef          	jal	376 <close>
  b8:	bf71                	j	54 <main+0x54>

00000000000000ba <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e406                	sd	ra,8(sp)
  be:	e022                	sd	s0,0(sp)
  c0:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c2:	f3fff0ef          	jal	0 <main>
  exit(r);
  c6:	288000ef          	jal	34e <exit>

00000000000000ca <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d0:	87aa                	mv	a5,a0
  d2:	0585                	addi	a1,a1,1
  d4:	0785                	addi	a5,a5,1
  d6:	fff5c703          	lbu	a4,-1(a1)
  da:	fee78fa3          	sb	a4,-1(a5)
  de:	fb75                	bnez	a4,d2 <strcpy+0x8>
    ;
  return os;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret

00000000000000e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ec:	00054783          	lbu	a5,0(a0)
  f0:	cb91                	beqz	a5,104 <strcmp+0x1e>
  f2:	0005c703          	lbu	a4,0(a1)
  f6:	00f71763          	bne	a4,a5,104 <strcmp+0x1e>
    p++, q++;
  fa:	0505                	addi	a0,a0,1
  fc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  fe:	00054783          	lbu	a5,0(a0)
 102:	fbe5                	bnez	a5,f2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 104:	0005c503          	lbu	a0,0(a1)
}
 108:	40a7853b          	subw	a0,a5,a0
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strlen>:

uint
strlen(const char *s)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cf91                	beqz	a5,138 <strlen+0x26>
 11e:	0505                	addi	a0,a0,1
 120:	87aa                	mv	a5,a0
 122:	86be                	mv	a3,a5
 124:	0785                	addi	a5,a5,1
 126:	fff7c703          	lbu	a4,-1(a5)
 12a:	ff65                	bnez	a4,122 <strlen+0x10>
 12c:	40a6853b          	subw	a0,a3,a0
 130:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret
  for(n = 0; s[n]; n++)
 138:	4501                	li	a0,0
 13a:	bfe5                	j	132 <strlen+0x20>

000000000000013c <memset>:

void*
memset(void *dst, int c, uint n)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 142:	ca19                	beqz	a2,158 <memset+0x1c>
 144:	87aa                	mv	a5,a0
 146:	1602                	slli	a2,a2,0x20
 148:	9201                	srli	a2,a2,0x20
 14a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 14e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 152:	0785                	addi	a5,a5,1
 154:	fee79de3          	bne	a5,a4,14e <memset+0x12>
  }
  return dst;
}
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret

000000000000015e <strchr>:

char*
strchr(const char *s, char c)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	addi	s0,sp,16
  for(; *s; s++)
 164:	00054783          	lbu	a5,0(a0)
 168:	cb99                	beqz	a5,17e <strchr+0x20>
    if(*s == c)
 16a:	00f58763          	beq	a1,a5,178 <strchr+0x1a>
  for(; *s; s++)
 16e:	0505                	addi	a0,a0,1
 170:	00054783          	lbu	a5,0(a0)
 174:	fbfd                	bnez	a5,16a <strchr+0xc>
      return (char*)s;
  return 0;
 176:	4501                	li	a0,0
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  return 0;
 17e:	4501                	li	a0,0
 180:	bfe5                	j	178 <strchr+0x1a>

0000000000000182 <gets>:

char*
gets(char *buf, int max)
{
 182:	711d                	addi	sp,sp,-96
 184:	ec86                	sd	ra,88(sp)
 186:	e8a2                	sd	s0,80(sp)
 188:	e4a6                	sd	s1,72(sp)
 18a:	e0ca                	sd	s2,64(sp)
 18c:	fc4e                	sd	s3,56(sp)
 18e:	f852                	sd	s4,48(sp)
 190:	f456                	sd	s5,40(sp)
 192:	f05a                	sd	s6,32(sp)
 194:	ec5e                	sd	s7,24(sp)
 196:	1080                	addi	s0,sp,96
 198:	8baa                	mv	s7,a0
 19a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19c:	892a                	mv	s2,a0
 19e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a0:	4aa9                	li	s5,10
 1a2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1a4:	89a6                	mv	s3,s1
 1a6:	2485                	addiw	s1,s1,1
 1a8:	0344d663          	bge	s1,s4,1d4 <gets+0x52>
    cc = read(0, &c, 1);
 1ac:	4605                	li	a2,1
 1ae:	faf40593          	addi	a1,s0,-81
 1b2:	4501                	li	a0,0
 1b4:	1b2000ef          	jal	366 <read>
    if(cc < 1)
 1b8:	00a05e63          	blez	a0,1d4 <gets+0x52>
    buf[i++] = c;
 1bc:	faf44783          	lbu	a5,-81(s0)
 1c0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c4:	01578763          	beq	a5,s5,1d2 <gets+0x50>
 1c8:	0905                	addi	s2,s2,1
 1ca:	fd679de3          	bne	a5,s6,1a4 <gets+0x22>
    buf[i++] = c;
 1ce:	89a6                	mv	s3,s1
 1d0:	a011                	j	1d4 <gets+0x52>
 1d2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d4:	99de                	add	s3,s3,s7
 1d6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1da:	855e                	mv	a0,s7
 1dc:	60e6                	ld	ra,88(sp)
 1de:	6446                	ld	s0,80(sp)
 1e0:	64a6                	ld	s1,72(sp)
 1e2:	6906                	ld	s2,64(sp)
 1e4:	79e2                	ld	s3,56(sp)
 1e6:	7a42                	ld	s4,48(sp)
 1e8:	7aa2                	ld	s5,40(sp)
 1ea:	7b02                	ld	s6,32(sp)
 1ec:	6be2                	ld	s7,24(sp)
 1ee:	6125                	addi	sp,sp,96
 1f0:	8082                	ret

00000000000001f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f2:	1101                	addi	sp,sp,-32
 1f4:	ec06                	sd	ra,24(sp)
 1f6:	e822                	sd	s0,16(sp)
 1f8:	e04a                	sd	s2,0(sp)
 1fa:	1000                	addi	s0,sp,32
 1fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fe:	4581                	li	a1,0
 200:	18e000ef          	jal	38e <open>
  if(fd < 0)
 204:	02054263          	bltz	a0,228 <stat+0x36>
 208:	e426                	sd	s1,8(sp)
 20a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20c:	85ca                	mv	a1,s2
 20e:	198000ef          	jal	3a6 <fstat>
 212:	892a                	mv	s2,a0
  close(fd);
 214:	8526                	mv	a0,s1
 216:	160000ef          	jal	376 <close>
  return r;
 21a:	64a2                	ld	s1,8(sp)
}
 21c:	854a                	mv	a0,s2
 21e:	60e2                	ld	ra,24(sp)
 220:	6442                	ld	s0,16(sp)
 222:	6902                	ld	s2,0(sp)
 224:	6105                	addi	sp,sp,32
 226:	8082                	ret
    return -1;
 228:	597d                	li	s2,-1
 22a:	bfcd                	j	21c <stat+0x2a>

000000000000022c <atoi>:

int
atoi(const char *s)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 232:	00054683          	lbu	a3,0(a0)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	4625                	li	a2,9
 240:	02f66863          	bltu	a2,a5,270 <atoi+0x44>
 244:	872a                	mv	a4,a0
  n = 0;
 246:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 248:	0705                	addi	a4,a4,1
 24a:	0025179b          	slliw	a5,a0,0x2
 24e:	9fa9                	addw	a5,a5,a0
 250:	0017979b          	slliw	a5,a5,0x1
 254:	9fb5                	addw	a5,a5,a3
 256:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 25a:	00074683          	lbu	a3,0(a4)
 25e:	fd06879b          	addiw	a5,a3,-48
 262:	0ff7f793          	zext.b	a5,a5
 266:	fef671e3          	bgeu	a2,a5,248 <atoi+0x1c>
  return n;
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  n = 0;
 270:	4501                	li	a0,0
 272:	bfe5                	j	26a <atoi+0x3e>

0000000000000274 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27a:	02b57463          	bgeu	a0,a1,2a2 <memmove+0x2e>
    while(n-- > 0)
 27e:	00c05f63          	blez	a2,29c <memmove+0x28>
 282:	1602                	slli	a2,a2,0x20
 284:	9201                	srli	a2,a2,0x20
 286:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28a:	872a                	mv	a4,a0
      *dst++ = *src++;
 28c:	0585                	addi	a1,a1,1
 28e:	0705                	addi	a4,a4,1
 290:	fff5c683          	lbu	a3,-1(a1)
 294:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 298:	fef71ae3          	bne	a4,a5,28c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
    dst += n;
 2a2:	00c50733          	add	a4,a0,a2
    src += n;
 2a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a8:	fec05ae3          	blez	a2,29c <memmove+0x28>
 2ac:	fff6079b          	addiw	a5,a2,-1
 2b0:	1782                	slli	a5,a5,0x20
 2b2:	9381                	srli	a5,a5,0x20
 2b4:	fff7c793          	not	a5,a5
 2b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ba:	15fd                	addi	a1,a1,-1
 2bc:	177d                	addi	a4,a4,-1
 2be:	0005c683          	lbu	a3,0(a1)
 2c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c6:	fee79ae3          	bne	a5,a4,2ba <memmove+0x46>
 2ca:	bfc9                	j	29c <memmove+0x28>

00000000000002cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d2:	ca05                	beqz	a2,302 <memcmp+0x36>
 2d4:	fff6069b          	addiw	a3,a2,-1
 2d8:	1682                	slli	a3,a3,0x20
 2da:	9281                	srli	a3,a3,0x20
 2dc:	0685                	addi	a3,a3,1
 2de:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e0:	00054783          	lbu	a5,0(a0)
 2e4:	0005c703          	lbu	a4,0(a1)
 2e8:	00e79863          	bne	a5,a4,2f8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ec:	0505                	addi	a0,a0,1
    p2++;
 2ee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f0:	fed518e3          	bne	a0,a3,2e0 <memcmp+0x14>
  }
  return 0;
 2f4:	4501                	li	a0,0
 2f6:	a019                	j	2fc <memcmp+0x30>
      return *p1 - *p2;
 2f8:	40e7853b          	subw	a0,a5,a4
}
 2fc:	6422                	ld	s0,8(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  return 0;
 302:	4501                	li	a0,0
 304:	bfe5                	j	2fc <memcmp+0x30>

0000000000000306 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30e:	f67ff0ef          	jal	274 <memmove>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <sbrk>:

char *
sbrk(int n) {
 31a:	1141                	addi	sp,sp,-16
 31c:	e406                	sd	ra,8(sp)
 31e:	e022                	sd	s0,0(sp)
 320:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 322:	4585                	li	a1,1
 324:	0b2000ef          	jal	3d6 <sys_sbrk>
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret

0000000000000330 <sbrklazy>:

char *
sbrklazy(int n) {
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 338:	4589                	li	a1,2
 33a:	09c000ef          	jal	3d6 <sys_sbrk>
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 346:	4885                	li	a7,1
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <exit>:
.global exit
exit:
 li a7, SYS_exit
 34e:	4889                	li	a7,2
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <wait>:
.global wait
wait:
 li a7, SYS_wait
 356:	488d                	li	a7,3
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35e:	4891                	li	a7,4
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <read>:
.global read
read:
 li a7, SYS_read
 366:	4895                	li	a7,5
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <write>:
.global write
write:
 li a7, SYS_write
 36e:	48c1                	li	a7,16
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <close>:
.global close
close:
 li a7, SYS_close
 376:	48d5                	li	a7,21
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <kill>:
.global kill
kill:
 li a7, SYS_kill
 37e:	4899                	li	a7,6
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <exec>:
.global exec
exec:
 li a7, SYS_exec
 386:	489d                	li	a7,7
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <open>:
.global open
open:
 li a7, SYS_open
 38e:	48bd                	li	a7,15
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 396:	48c5                	li	a7,17
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39e:	48c9                	li	a7,18
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a6:	48a1                	li	a7,8
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <link>:
.global link
link:
 li a7, SYS_link
 3ae:	48cd                	li	a7,19
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b6:	48d1                	li	a7,20
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3be:	48a5                	li	a7,9
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c6:	48a9                	li	a7,10
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ce:	48ad                	li	a7,11
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3d6:	48b1                	li	a7,12
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <pause>:
.global pause
pause:
 li a7, SYS_pause
 3de:	48b5                	li	a7,13
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e6:	48b9                	li	a7,14
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <kps>:
.global kps
kps:
 li a7, SYS_kps
 3ee:	48d9                	li	a7,22
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 3f6:	48dd                	li	a7,23
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 3fe:	48e1                	li	a7,24
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 406:	48e5                	li	a7,25
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 40e:	48e9                	li	a7,26
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 416:	1101                	addi	sp,sp,-32
 418:	ec06                	sd	ra,24(sp)
 41a:	e822                	sd	s0,16(sp)
 41c:	1000                	addi	s0,sp,32
 41e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 422:	4605                	li	a2,1
 424:	fef40593          	addi	a1,s0,-17
 428:	f47ff0ef          	jal	36e <write>
}
 42c:	60e2                	ld	ra,24(sp)
 42e:	6442                	ld	s0,16(sp)
 430:	6105                	addi	sp,sp,32
 432:	8082                	ret

0000000000000434 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 434:	715d                	addi	sp,sp,-80
 436:	e486                	sd	ra,72(sp)
 438:	e0a2                	sd	s0,64(sp)
 43a:	f84a                	sd	s2,48(sp)
 43c:	0880                	addi	s0,sp,80
 43e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 440:	c299                	beqz	a3,446 <printint+0x12>
 442:	0805c363          	bltz	a1,4c8 <printint+0x94>
  neg = 0;
 446:	4881                	li	a7,0
 448:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 44c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 44e:	00000517          	auipc	a0,0x0
 452:	58250513          	addi	a0,a0,1410 # 9d0 <digits>
 456:	883e                	mv	a6,a5
 458:	2785                	addiw	a5,a5,1
 45a:	02c5f733          	remu	a4,a1,a2
 45e:	972a                	add	a4,a4,a0
 460:	00074703          	lbu	a4,0(a4)
 464:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 468:	872e                	mv	a4,a1
 46a:	02c5d5b3          	divu	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fec773e3          	bgeu	a4,a2,456 <printint+0x22>
  if(neg)
 474:	00088b63          	beqz	a7,48a <printint+0x56>
    buf[i++] = '-';
 478:	fd078793          	addi	a5,a5,-48
 47c:	97a2                	add	a5,a5,s0
 47e:	02d00713          	li	a4,45
 482:	fee78423          	sb	a4,-24(a5)
 486:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 48a:	02f05a63          	blez	a5,4be <printint+0x8a>
 48e:	fc26                	sd	s1,56(sp)
 490:	f44e                	sd	s3,40(sp)
 492:	fb840713          	addi	a4,s0,-72
 496:	00f704b3          	add	s1,a4,a5
 49a:	fff70993          	addi	s3,a4,-1
 49e:	99be                	add	s3,s3,a5
 4a0:	37fd                	addiw	a5,a5,-1
 4a2:	1782                	slli	a5,a5,0x20
 4a4:	9381                	srli	a5,a5,0x20
 4a6:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4aa:	fff4c583          	lbu	a1,-1(s1)
 4ae:	854a                	mv	a0,s2
 4b0:	f67ff0ef          	jal	416 <putc>
  while(--i >= 0)
 4b4:	14fd                	addi	s1,s1,-1
 4b6:	ff349ae3          	bne	s1,s3,4aa <printint+0x76>
 4ba:	74e2                	ld	s1,56(sp)
 4bc:	79a2                	ld	s3,40(sp)
}
 4be:	60a6                	ld	ra,72(sp)
 4c0:	6406                	ld	s0,64(sp)
 4c2:	7942                	ld	s2,48(sp)
 4c4:	6161                	addi	sp,sp,80
 4c6:	8082                	ret
    x = -xx;
 4c8:	40b005b3          	neg	a1,a1
    neg = 1;
 4cc:	4885                	li	a7,1
    x = -xx;
 4ce:	bfad                	j	448 <printint+0x14>

00000000000004d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d0:	711d                	addi	sp,sp,-96
 4d2:	ec86                	sd	ra,88(sp)
 4d4:	e8a2                	sd	s0,80(sp)
 4d6:	e0ca                	sd	s2,64(sp)
 4d8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4da:	0005c903          	lbu	s2,0(a1)
 4de:	28090663          	beqz	s2,76a <vprintf+0x29a>
 4e2:	e4a6                	sd	s1,72(sp)
 4e4:	fc4e                	sd	s3,56(sp)
 4e6:	f852                	sd	s4,48(sp)
 4e8:	f456                	sd	s5,40(sp)
 4ea:	f05a                	sd	s6,32(sp)
 4ec:	ec5e                	sd	s7,24(sp)
 4ee:	e862                	sd	s8,16(sp)
 4f0:	e466                	sd	s9,8(sp)
 4f2:	8b2a                	mv	s6,a0
 4f4:	8a2e                	mv	s4,a1
 4f6:	8bb2                	mv	s7,a2
  state = 0;
 4f8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4fa:	4481                	li	s1,0
 4fc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4fe:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 502:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 506:	06c00c93          	li	s9,108
 50a:	a005                	j	52a <vprintf+0x5a>
        putc(fd, c0);
 50c:	85ca                	mv	a1,s2
 50e:	855a                	mv	a0,s6
 510:	f07ff0ef          	jal	416 <putc>
 514:	a019                	j	51a <vprintf+0x4a>
    } else if(state == '%'){
 516:	03598263          	beq	s3,s5,53a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 51a:	2485                	addiw	s1,s1,1
 51c:	8726                	mv	a4,s1
 51e:	009a07b3          	add	a5,s4,s1
 522:	0007c903          	lbu	s2,0(a5)
 526:	22090a63          	beqz	s2,75a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 52a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 52e:	fe0994e3          	bnez	s3,516 <vprintf+0x46>
      if(c0 == '%'){
 532:	fd579de3          	bne	a5,s5,50c <vprintf+0x3c>
        state = '%';
 536:	89be                	mv	s3,a5
 538:	b7cd                	j	51a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 53a:	00ea06b3          	add	a3,s4,a4
 53e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 542:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 544:	c681                	beqz	a3,54c <vprintf+0x7c>
 546:	9752                	add	a4,a4,s4
 548:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 54c:	05878363          	beq	a5,s8,592 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 550:	05978d63          	beq	a5,s9,5aa <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 554:	07500713          	li	a4,117
 558:	0ee78763          	beq	a5,a4,646 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 55c:	07800713          	li	a4,120
 560:	12e78963          	beq	a5,a4,692 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 564:	07000713          	li	a4,112
 568:	14e78e63          	beq	a5,a4,6c4 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 56c:	06300713          	li	a4,99
 570:	18e78e63          	beq	a5,a4,70c <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 574:	07300713          	li	a4,115
 578:	1ae78463          	beq	a5,a4,720 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 57c:	02500713          	li	a4,37
 580:	04e79563          	bne	a5,a4,5ca <vprintf+0xfa>
        putc(fd, '%');
 584:	02500593          	li	a1,37
 588:	855a                	mv	a0,s6
 58a:	e8dff0ef          	jal	416 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 58e:	4981                	li	s3,0
 590:	b769                	j	51a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b8913          	addi	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e95ff0ef          	jal	434 <printint>
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	bf8d                	j	51a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5aa:	06400793          	li	a5,100
 5ae:	02f68963          	beq	a3,a5,5e0 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b2:	06c00793          	li	a5,108
 5b6:	04f68263          	beq	a3,a5,5fa <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5ba:	07500793          	li	a5,117
 5be:	0af68063          	beq	a3,a5,65e <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5c2:	07800793          	li	a5,120
 5c6:	0ef68263          	beq	a3,a5,6aa <vprintf+0x1da>
        putc(fd, '%');
 5ca:	02500593          	li	a1,37
 5ce:	855a                	mv	a0,s6
 5d0:	e47ff0ef          	jal	416 <putc>
        putc(fd, c0);
 5d4:	85ca                	mv	a1,s2
 5d6:	855a                	mv	a0,s6
 5d8:	e3fff0ef          	jal	416 <putc>
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bf35                	j	51a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e47ff0ef          	jal	434 <printint>
        i += 1;
 5f2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
        i += 1;
 5f8:	b70d                	j	51a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fa:	06400793          	li	a5,100
 5fe:	02f60763          	beq	a2,a5,62c <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 602:	07500793          	li	a5,117
 606:	06f60963          	beq	a2,a5,678 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 60a:	07800793          	li	a5,120
 60e:	faf61ee3          	bne	a2,a5,5ca <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 612:	008b8913          	addi	s2,s7,8
 616:	4681                	li	a3,0
 618:	4641                	li	a2,16
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e15ff0ef          	jal	434 <printint>
        i += 2;
 624:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	bdc5                	j	51a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62c:	008b8913          	addi	s2,s7,8
 630:	4685                	li	a3,1
 632:	4629                	li	a2,10
 634:	000bb583          	ld	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	dfbff0ef          	jal	434 <printint>
        i += 2;
 63e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
        i += 2;
 644:	bdd9                	j	51a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 646:	008b8913          	addi	s2,s7,8
 64a:	4681                	li	a3,0
 64c:	4629                	li	a2,10
 64e:	000be583          	lwu	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	de1ff0ef          	jal	434 <printint>
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bd7d                	j	51a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65e:	008b8913          	addi	s2,s7,8
 662:	4681                	li	a3,0
 664:	4629                	li	a2,10
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	dc9ff0ef          	jal	434 <printint>
        i += 1;
 670:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
        i += 1;
 676:	b555                	j	51a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	008b8913          	addi	s2,s7,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000bb583          	ld	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	dafff0ef          	jal	434 <printint>
        i += 2;
 68a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	b569                	j	51a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 692:	008b8913          	addi	s2,s7,8
 696:	4681                	li	a3,0
 698:	4641                	li	a2,16
 69a:	000be583          	lwu	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	d95ff0ef          	jal	434 <printint>
 6a4:	8bca                	mv	s7,s2
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bd8d                	j	51a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6aa:	008b8913          	addi	s2,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4641                	li	a2,16
 6b2:	000bb583          	ld	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	d7dff0ef          	jal	434 <printint>
        i += 1;
 6bc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
        i += 1;
 6c2:	bda1                	j	51a <vprintf+0x4a>
 6c4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6c6:	008b8d13          	addi	s10,s7,8
 6ca:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ce:	03000593          	li	a1,48
 6d2:	855a                	mv	a0,s6
 6d4:	d43ff0ef          	jal	416 <putc>
  putc(fd, 'x');
 6d8:	07800593          	li	a1,120
 6dc:	855a                	mv	a0,s6
 6de:	d39ff0ef          	jal	416 <putc>
 6e2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e4:	00000b97          	auipc	s7,0x0
 6e8:	2ecb8b93          	addi	s7,s7,748 # 9d0 <digits>
 6ec:	03c9d793          	srli	a5,s3,0x3c
 6f0:	97de                	add	a5,a5,s7
 6f2:	0007c583          	lbu	a1,0(a5)
 6f6:	855a                	mv	a0,s6
 6f8:	d1fff0ef          	jal	416 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fc:	0992                	slli	s3,s3,0x4
 6fe:	397d                	addiw	s2,s2,-1
 700:	fe0916e3          	bnez	s2,6ec <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 704:	8bea                	mv	s7,s10
      state = 0;
 706:	4981                	li	s3,0
 708:	6d02                	ld	s10,0(sp)
 70a:	bd01                	j	51a <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 70c:	008b8913          	addi	s2,s7,8
 710:	000bc583          	lbu	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	d01ff0ef          	jal	416 <putc>
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bbf5                	j	51a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 720:	008b8993          	addi	s3,s7,8
 724:	000bb903          	ld	s2,0(s7)
 728:	00090f63          	beqz	s2,746 <vprintf+0x276>
        for(; *s; s++)
 72c:	00094583          	lbu	a1,0(s2)
 730:	c195                	beqz	a1,754 <vprintf+0x284>
          putc(fd, *s);
 732:	855a                	mv	a0,s6
 734:	ce3ff0ef          	jal	416 <putc>
        for(; *s; s++)
 738:	0905                	addi	s2,s2,1
 73a:	00094583          	lbu	a1,0(s2)
 73e:	f9f5                	bnez	a1,732 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 740:	8bce                	mv	s7,s3
      state = 0;
 742:	4981                	li	s3,0
 744:	bbd9                	j	51a <vprintf+0x4a>
          s = "(null)";
 746:	00000917          	auipc	s2,0x0
 74a:	28290913          	addi	s2,s2,642 # 9c8 <malloc+0x176>
        for(; *s; s++)
 74e:	02800593          	li	a1,40
 752:	b7c5                	j	732 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 754:	8bce                	mv	s7,s3
      state = 0;
 756:	4981                	li	s3,0
 758:	b3c9                	j	51a <vprintf+0x4a>
 75a:	64a6                	ld	s1,72(sp)
 75c:	79e2                	ld	s3,56(sp)
 75e:	7a42                	ld	s4,48(sp)
 760:	7aa2                	ld	s5,40(sp)
 762:	7b02                	ld	s6,32(sp)
 764:	6be2                	ld	s7,24(sp)
 766:	6c42                	ld	s8,16(sp)
 768:	6ca2                	ld	s9,8(sp)
    }
  }
}
 76a:	60e6                	ld	ra,88(sp)
 76c:	6446                	ld	s0,80(sp)
 76e:	6906                	ld	s2,64(sp)
 770:	6125                	addi	sp,sp,96
 772:	8082                	ret

0000000000000774 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 774:	715d                	addi	sp,sp,-80
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e010                	sd	a2,0(s0)
 77e:	e414                	sd	a3,8(s0)
 780:	e818                	sd	a4,16(s0)
 782:	ec1c                	sd	a5,24(s0)
 784:	03043023          	sd	a6,32(s0)
 788:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 790:	8622                	mv	a2,s0
 792:	d3fff0ef          	jal	4d0 <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6161                	addi	sp,sp,80
 79c:	8082                	ret

000000000000079e <printf>:

void
printf(const char *fmt, ...)
{
 79e:	711d                	addi	sp,sp,-96
 7a0:	ec06                	sd	ra,24(sp)
 7a2:	e822                	sd	s0,16(sp)
 7a4:	1000                	addi	s0,sp,32
 7a6:	e40c                	sd	a1,8(s0)
 7a8:	e810                	sd	a2,16(s0)
 7aa:	ec14                	sd	a3,24(s0)
 7ac:	f018                	sd	a4,32(s0)
 7ae:	f41c                	sd	a5,40(s0)
 7b0:	03043823          	sd	a6,48(s0)
 7b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	00840613          	addi	a2,s0,8
 7bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c0:	85aa                	mv	a1,a0
 7c2:	4505                	li	a0,1
 7c4:	d0dff0ef          	jal	4d0 <vprintf>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6125                	addi	sp,sp,96
 7ce:	8082                	ret

00000000000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	1141                	addi	sp,sp,-16
 7d2:	e422                	sd	s0,8(sp)
 7d4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	00001797          	auipc	a5,0x1
 7de:	8267b783          	ld	a5,-2010(a5) # 1000 <freep>
 7e2:	a02d                	j	80c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e4:	4618                	lw	a4,8(a2)
 7e6:	9f2d                	addw	a4,a4,a1
 7e8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ec:	6398                	ld	a4,0(a5)
 7ee:	6310                	ld	a2,0(a4)
 7f0:	a83d                	j	82e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f2:	ff852703          	lw	a4,-8(a0)
 7f6:	9f31                	addw	a4,a4,a2
 7f8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7fa:	ff053683          	ld	a3,-16(a0)
 7fe:	a091                	j	842 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	6398                	ld	a4,0(a5)
 802:	00e7e463          	bltu	a5,a4,80a <free+0x3a>
 806:	00e6ea63          	bltu	a3,a4,81a <free+0x4a>
{
 80a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80c:	fed7fae3          	bgeu	a5,a3,800 <free+0x30>
 810:	6398                	ld	a4,0(a5)
 812:	00e6e463          	bltu	a3,a4,81a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 816:	fee7eae3          	bltu	a5,a4,80a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 81a:	ff852583          	lw	a1,-8(a0)
 81e:	6390                	ld	a2,0(a5)
 820:	02059813          	slli	a6,a1,0x20
 824:	01c85713          	srli	a4,a6,0x1c
 828:	9736                	add	a4,a4,a3
 82a:	fae60de3          	beq	a2,a4,7e4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 82e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 832:	4790                	lw	a2,8(a5)
 834:	02061593          	slli	a1,a2,0x20
 838:	01c5d713          	srli	a4,a1,0x1c
 83c:	973e                	add	a4,a4,a5
 83e:	fae68ae3          	beq	a3,a4,7f2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 842:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 844:	00000717          	auipc	a4,0x0
 848:	7af73e23          	sd	a5,1980(a4) # 1000 <freep>
}
 84c:	6422                	ld	s0,8(sp)
 84e:	0141                	addi	sp,sp,16
 850:	8082                	ret

0000000000000852 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 852:	7139                	addi	sp,sp,-64
 854:	fc06                	sd	ra,56(sp)
 856:	f822                	sd	s0,48(sp)
 858:	f426                	sd	s1,40(sp)
 85a:	ec4e                	sd	s3,24(sp)
 85c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85e:	02051493          	slli	s1,a0,0x20
 862:	9081                	srli	s1,s1,0x20
 864:	04bd                	addi	s1,s1,15
 866:	8091                	srli	s1,s1,0x4
 868:	0014899b          	addiw	s3,s1,1
 86c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 86e:	00000517          	auipc	a0,0x0
 872:	79253503          	ld	a0,1938(a0) # 1000 <freep>
 876:	c915                	beqz	a0,8aa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 878:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87a:	4798                	lw	a4,8(a5)
 87c:	08977a63          	bgeu	a4,s1,910 <malloc+0xbe>
 880:	f04a                	sd	s2,32(sp)
 882:	e852                	sd	s4,16(sp)
 884:	e456                	sd	s5,8(sp)
 886:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 888:	8a4e                	mv	s4,s3
 88a:	0009871b          	sext.w	a4,s3
 88e:	6685                	lui	a3,0x1
 890:	00d77363          	bgeu	a4,a3,896 <malloc+0x44>
 894:	6a05                	lui	s4,0x1
 896:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 89e:	00000917          	auipc	s2,0x0
 8a2:	76290913          	addi	s2,s2,1890 # 1000 <freep>
  if(p == SBRK_ERROR)
 8a6:	5afd                	li	s5,-1
 8a8:	a081                	j	8e8 <malloc+0x96>
 8aa:	f04a                	sd	s2,32(sp)
 8ac:	e852                	sd	s4,16(sp)
 8ae:	e456                	sd	s5,8(sp)
 8b0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b2:	00000797          	auipc	a5,0x0
 8b6:	75e78793          	addi	a5,a5,1886 # 1010 <base>
 8ba:	00000717          	auipc	a4,0x0
 8be:	74f73323          	sd	a5,1862(a4) # 1000 <freep>
 8c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c8:	b7c1                	j	888 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ca:	6398                	ld	a4,0(a5)
 8cc:	e118                	sd	a4,0(a0)
 8ce:	a8a9                	j	928 <malloc+0xd6>
  hp->s.size = nu;
 8d0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d4:	0541                	addi	a0,a0,16
 8d6:	efbff0ef          	jal	7d0 <free>
  return freep;
 8da:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8de:	c12d                	beqz	a0,940 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e2:	4798                	lw	a4,8(a5)
 8e4:	02977263          	bgeu	a4,s1,908 <malloc+0xb6>
    if(p == freep)
 8e8:	00093703          	ld	a4,0(s2)
 8ec:	853e                	mv	a0,a5
 8ee:	fef719e3          	bne	a4,a5,8e0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8f2:	8552                	mv	a0,s4
 8f4:	a27ff0ef          	jal	31a <sbrk>
  if(p == SBRK_ERROR)
 8f8:	fd551ce3          	bne	a0,s5,8d0 <malloc+0x7e>
        return 0;
 8fc:	4501                	li	a0,0
 8fe:	7902                	ld	s2,32(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	a03d                	j	934 <malloc+0xe2>
 908:	7902                	ld	s2,32(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 910:	fae48de3          	beq	s1,a4,8ca <malloc+0x78>
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
 938:	74a2                	ld	s1,40(sp)
 93a:	69e2                	ld	s3,24(sp)
 93c:	6121                	addi	sp,sp,64
 93e:	8082                	ret
 940:	7902                	ld	s2,32(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
 948:	b7f5                	j	934 <malloc+0xe2>
