
user/_schedtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cpu_burst>:
#include "kernel/stat.h"
#include "user/user.h"


// Dummy calculation function to simulate CPU burst
void cpu_burst(int iterations) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
    
    int start = uptime();        // ticks since boot
  10:	408000ef          	jal	418 <uptime>
  14:	892a                	mv	s2,a0
    while (uptime() - start < iterations*10) {
  16:	0029949b          	slliw	s1,s3,0x2
  1a:	013484bb          	addw	s1,s1,s3
  1e:	0014949b          	slliw	s1,s1,0x1
  22:	3f6000ef          	jal	418 <uptime>
  26:	4125053b          	subw	a0,a0,s2
  2a:	fe954ce3          	blt	a0,s1,22 <cpu_burst+0x22>
            // busy wait: burn CPU
    }
}
  2e:	70a2                	ld	ra,40(sp)
  30:	7402                	ld	s0,32(sp)
  32:	64e2                	ld	s1,24(sp)
  34:	6942                	ld	s2,16(sp)
  36:	69a2                	ld	s3,8(sp)
  38:	6145                	addi	sp,sp,48
  3a:	8082                	ret

000000000000003c <child_process>:


void child_process(int child_id) {
  3c:	1101                	addi	sp,sp,-32
  3e:	ec06                	sd	ra,24(sp)
  40:	e822                	sd	s0,16(sp)
  42:	e426                	sd	s1,8(sp)
  44:	1000                	addi	s0,sp,32
  46:	448d                	li	s1,3
    
    int j;
    for (j = 0; j < 3; j++) {
        // increasing bursts
        // first child is shortest, last child is longest
        burst_input = 1+getpid();
  48:	3b8000ef          	jal	400 <getpid>

        // decreasing bursts
        // so that first child is longest and last child is shortest
        //burst_input = 13-getpid(); // where n >= max_pid // so burst_input isn't negative
        cpu_burst(burst_input);
  4c:	2505                	addiw	a0,a0,1
  4e:	fb3ff0ef          	jal	0 <cpu_burst>
    for (j = 0; j < 3; j++) {
  52:	34fd                	addiw	s1,s1,-1
  54:	f8f5                	bnez	s1,48 <child_process+0xc>
        
    }
}
  56:	60e2                	ld	ra,24(sp)
  58:	6442                	ld	s0,16(sp)
  5a:	64a2                	ld	s1,8(sp)
  5c:	6105                	addi	sp,sp,32
  5e:	8082                	ret

0000000000000060 <main>:

int main(void) {
  60:	7179                	addi	sp,sp,-48
  62:	f406                	sd	ra,40(sp)
  64:	f022                	sd	s0,32(sp)
  66:	ec26                	sd	s1,24(sp)
  68:	e84a                	sd	s2,16(sp)
  6a:	e44e                	sd	s3,8(sp)
  6c:	1800                	addi	s0,sp,48
    int i;
    
    for (i = 0; i < 5; i++) {
  6e:	4481                	li	s1,0
            
            child_process(i + 1);
            exit(0);  
        } else {
            
            printf("Parent: Forked child %d with PID %d\n", i + 1, pid);
  70:	00001997          	auipc	s3,0x1
  74:	95098993          	addi	s3,s3,-1712 # 9c0 <malloc+0x11a>
    for (i = 0; i < 5; i++) {
  78:	4915                	li	s2,5
        int pid = fork();
  7a:	2fe000ef          	jal	378 <fork>
  7e:	862a                	mv	a2,a0
        if (pid < 0) {
  80:	02054463          	bltz	a0,a8 <main+0x48>
        } else if (pid == 0) {
  84:	cd05                	beqz	a0,bc <main+0x5c>
            printf("Parent: Forked child %d with PID %d\n", i + 1, pid);
  86:	0014859b          	addiw	a1,s1,1
  8a:	84ae                	mv	s1,a1
  8c:	854e                	mv	a0,s3
  8e:	760000ef          	jal	7ee <printf>
    for (i = 0; i < 5; i++) {
  92:	ff2494e3          	bne	s1,s2,7a <main+0x1a>
  96:	4495                	li	s1,5
    
    
   
    
    for (i = 0; i < 5; i++) {
        wait(0);
  98:	4501                	li	a0,0
  9a:	2ee000ef          	jal	388 <wait>
    for (i = 0; i < 5; i++) {
  9e:	34fd                	addiw	s1,s1,-1
  a0:	fce5                	bnez	s1,98 <main+0x38>
    }
    
    
    exit(0);
  a2:	4501                	li	a0,0
  a4:	2dc000ef          	jal	380 <exit>
            printf("Fork failed for child %d\n", i);
  a8:	85a6                	mv	a1,s1
  aa:	00001517          	auipc	a0,0x1
  ae:	8f650513          	addi	a0,a0,-1802 # 9a0 <malloc+0xfa>
  b2:	73c000ef          	jal	7ee <printf>
            exit(1);
  b6:	4505                	li	a0,1
  b8:	2c8000ef          	jal	380 <exit>
            child_process(i + 1);
  bc:	0014851b          	addiw	a0,s1,1
  c0:	f7dff0ef          	jal	3c <child_process>
            exit(0);  
  c4:	4501                	li	a0,0
  c6:	2ba000ef          	jal	380 <exit>

00000000000000ca <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  d2:	f8fff0ef          	jal	60 <main>
  exit(r);
  d6:	2aa000ef          	jal	380 <exit>

00000000000000da <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e2:	87aa                	mv	a5,a0
  e4:	0585                	addi	a1,a1,1
  e6:	0785                	addi	a5,a5,1
  e8:	fff5c703          	lbu	a4,-1(a1)
  ec:	fee78fa3          	sb	a4,-1(a5)
  f0:	fb75                	bnez	a4,e4 <strcpy+0xa>
    ;
  return os;
}
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 102:	00054783          	lbu	a5,0(a0)
 106:	cb91                	beqz	a5,11a <strcmp+0x20>
 108:	0005c703          	lbu	a4,0(a1)
 10c:	00f71763          	bne	a4,a5,11a <strcmp+0x20>
    p++, q++;
 110:	0505                	addi	a0,a0,1
 112:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 114:	00054783          	lbu	a5,0(a0)
 118:	fbe5                	bnez	a5,108 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 11a:	0005c503          	lbu	a0,0(a1)
}
 11e:	40a7853b          	subw	a0,a5,a0
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strlen>:

uint
strlen(const char *s)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e406                	sd	ra,8(sp)
 12e:	e022                	sd	s0,0(sp)
 130:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 132:	00054783          	lbu	a5,0(a0)
 136:	cf91                	beqz	a5,152 <strlen+0x28>
 138:	00150793          	addi	a5,a0,1
 13c:	86be                	mv	a3,a5
 13e:	0785                	addi	a5,a5,1
 140:	fff7c703          	lbu	a4,-1(a5)
 144:	ff65                	bnez	a4,13c <strlen+0x12>
 146:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 14a:	60a2                	ld	ra,8(sp)
 14c:	6402                	ld	s0,0(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret
  for(n = 0; s[n]; n++)
 152:	4501                	li	a0,0
 154:	bfdd                	j	14a <strlen+0x20>

0000000000000156 <memset>:

void*
memset(void *dst, int c, uint n)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 15e:	ca19                	beqz	a2,174 <memset+0x1e>
 160:	87aa                	mv	a5,a0
 162:	1602                	slli	a2,a2,0x20
 164:	9201                	srli	a2,a2,0x20
 166:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16e:	0785                	addi	a5,a5,1
 170:	fee79de3          	bne	a5,a4,16a <memset+0x14>
  }
  return dst;
}
 174:	60a2                	ld	ra,8(sp)
 176:	6402                	ld	s0,0(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strchr>:

char*
strchr(const char *s, char c)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e406                	sd	ra,8(sp)
 180:	e022                	sd	s0,0(sp)
 182:	0800                	addi	s0,sp,16
  for(; *s; s++)
 184:	00054783          	lbu	a5,0(a0)
 188:	cf81                	beqz	a5,1a0 <strchr+0x24>
    if(*s == c)
 18a:	00f58763          	beq	a1,a5,198 <strchr+0x1c>
  for(; *s; s++)
 18e:	0505                	addi	a0,a0,1
 190:	00054783          	lbu	a5,0(a0)
 194:	fbfd                	bnez	a5,18a <strchr+0xe>
      return (char*)s;
  return 0;
 196:	4501                	li	a0,0
}
 198:	60a2                	ld	ra,8(sp)
 19a:	6402                	ld	s0,0(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret
  return 0;
 1a0:	4501                	li	a0,0
 1a2:	bfdd                	j	198 <strchr+0x1c>

00000000000001a4 <gets>:

char*
gets(char *buf, int max)
{
 1a4:	711d                	addi	sp,sp,-96
 1a6:	ec86                	sd	ra,88(sp)
 1a8:	e8a2                	sd	s0,80(sp)
 1aa:	e4a6                	sd	s1,72(sp)
 1ac:	e0ca                	sd	s2,64(sp)
 1ae:	fc4e                	sd	s3,56(sp)
 1b0:	f852                	sd	s4,48(sp)
 1b2:	f456                	sd	s5,40(sp)
 1b4:	f05a                	sd	s6,32(sp)
 1b6:	ec5e                	sd	s7,24(sp)
 1b8:	e862                	sd	s8,16(sp)
 1ba:	1080                	addi	s0,sp,96
 1bc:	8baa                	mv	s7,a0
 1be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	892a                	mv	s2,a0
 1c2:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c4:	faf40b13          	addi	s6,s0,-81
 1c8:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1ca:	8c26                	mv	s8,s1
 1cc:	0014899b          	addiw	s3,s1,1
 1d0:	84ce                	mv	s1,s3
 1d2:	0349d463          	bge	s3,s4,1fa <gets+0x56>
    cc = read(0, &c, 1);
 1d6:	8656                	mv	a2,s5
 1d8:	85da                	mv	a1,s6
 1da:	4501                	li	a0,0
 1dc:	1bc000ef          	jal	398 <read>
    if(cc < 1)
 1e0:	00a05d63          	blez	a0,1fa <gets+0x56>
      break;
    buf[i++] = c;
 1e4:	faf44783          	lbu	a5,-81(s0)
 1e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ec:	0905                	addi	s2,s2,1
 1ee:	ff678713          	addi	a4,a5,-10
 1f2:	c319                	beqz	a4,1f8 <gets+0x54>
 1f4:	17cd                	addi	a5,a5,-13
 1f6:	fbf1                	bnez	a5,1ca <gets+0x26>
    buf[i++] = c;
 1f8:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1fa:	9c5e                	add	s8,s8,s7
 1fc:	000c0023          	sb	zero,0(s8)
  return buf;
}
 200:	855e                	mv	a0,s7
 202:	60e6                	ld	ra,88(sp)
 204:	6446                	ld	s0,80(sp)
 206:	64a6                	ld	s1,72(sp)
 208:	6906                	ld	s2,64(sp)
 20a:	79e2                	ld	s3,56(sp)
 20c:	7a42                	ld	s4,48(sp)
 20e:	7aa2                	ld	s5,40(sp)
 210:	7b02                	ld	s6,32(sp)
 212:	6be2                	ld	s7,24(sp)
 214:	6c42                	ld	s8,16(sp)
 216:	6125                	addi	sp,sp,96
 218:	8082                	ret

000000000000021a <stat>:

int
stat(const char *n, struct stat *st)
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	e04a                	sd	s2,0(sp)
 222:	1000                	addi	s0,sp,32
 224:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	4581                	li	a1,0
 228:	198000ef          	jal	3c0 <open>
  if(fd < 0)
 22c:	02054263          	bltz	a0,250 <stat+0x36>
 230:	e426                	sd	s1,8(sp)
 232:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 234:	85ca                	mv	a1,s2
 236:	1a2000ef          	jal	3d8 <fstat>
 23a:	892a                	mv	s2,a0
  close(fd);
 23c:	8526                	mv	a0,s1
 23e:	16a000ef          	jal	3a8 <close>
  return r;
 242:	64a2                	ld	s1,8(sp)
}
 244:	854a                	mv	a0,s2
 246:	60e2                	ld	ra,24(sp)
 248:	6442                	ld	s0,16(sp)
 24a:	6902                	ld	s2,0(sp)
 24c:	6105                	addi	sp,sp,32
 24e:	8082                	ret
    return -1;
 250:	57fd                	li	a5,-1
 252:	893e                	mv	s2,a5
 254:	bfc5                	j	244 <stat+0x2a>

0000000000000256 <atoi>:

int
atoi(const char *s)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	00054683          	lbu	a3,0(a0)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	4625                	li	a2,9
 26c:	02f66963          	bltu	a2,a5,29e <atoi+0x48>
 270:	872a                	mv	a4,a0
  n = 0;
 272:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 274:	0705                	addi	a4,a4,1
 276:	0025179b          	slliw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	slliw	a5,a5,0x1
 280:	9fb5                	addw	a5,a5,a3
 282:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 286:	00074683          	lbu	a3,0(a4)
 28a:	fd06879b          	addiw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	fef671e3          	bgeu	a2,a5,274 <atoi+0x1e>
  return n;
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  n = 0;
 29e:	4501                	li	a0,0
 2a0:	bfdd                	j	296 <atoi+0x40>

00000000000002a2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2aa:	02b57563          	bgeu	a0,a1,2d4 <memmove+0x32>
    while(n-- > 0)
 2ae:	00c05f63          	blez	a2,2cc <memmove+0x2a>
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 2bc:	0585                	addi	a1,a1,1
 2be:	0705                	addi	a4,a4,1
 2c0:	fff5c683          	lbu	a3,-1(a1)
 2c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
    while(n-- > 0)
 2d4:	fec05ce3          	blez	a2,2cc <memmove+0x2a>
    dst += n;
 2d8:	00c50733          	add	a4,a0,a2
    src += n;
 2dc:	95b2                	add	a1,a1,a2
 2de:	fff6079b          	addiw	a5,a2,-1
 2e2:	1782                	slli	a5,a5,0x20
 2e4:	9381                	srli	a5,a5,0x20
 2e6:	fff7c793          	not	a5,a5
 2ea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ec:	15fd                	addi	a1,a1,-1
 2ee:	177d                	addi	a4,a4,-1
 2f0:	0005c683          	lbu	a3,0(a1)
 2f4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f8:	fef71ae3          	bne	a4,a5,2ec <memmove+0x4a>
 2fc:	bfc1                	j	2cc <memmove+0x2a>

00000000000002fe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 306:	c61d                	beqz	a2,334 <memcmp+0x36>
 308:	1602                	slli	a2,a2,0x20
 30a:	9201                	srli	a2,a2,0x20
 30c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 310:	00054783          	lbu	a5,0(a0)
 314:	0005c703          	lbu	a4,0(a1)
 318:	00e79863          	bne	a5,a4,328 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 31c:	0505                	addi	a0,a0,1
    p2++;
 31e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 320:	fed518e3          	bne	a0,a3,310 <memcmp+0x12>
  }
  return 0;
 324:	4501                	li	a0,0
 326:	a019                	j	32c <memcmp+0x2e>
      return *p1 - *p2;
 328:	40e7853b          	subw	a0,a5,a4
}
 32c:	60a2                	ld	ra,8(sp)
 32e:	6402                	ld	s0,0(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret
  return 0;
 334:	4501                	li	a0,0
 336:	bfdd                	j	32c <memcmp+0x2e>

0000000000000338 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 340:	f63ff0ef          	jal	2a2 <memmove>
}
 344:	60a2                	ld	ra,8(sp)
 346:	6402                	ld	s0,0(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <sbrk>:

char *
sbrk(int n) {
 34c:	1141                	addi	sp,sp,-16
 34e:	e406                	sd	ra,8(sp)
 350:	e022                	sd	s0,0(sp)
 352:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 354:	4585                	li	a1,1
 356:	0b2000ef          	jal	408 <sys_sbrk>
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret

0000000000000362 <sbrklazy>:

char *
sbrklazy(int n) {
 362:	1141                	addi	sp,sp,-16
 364:	e406                	sd	ra,8(sp)
 366:	e022                	sd	s0,0(sp)
 368:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 36a:	4589                	li	a1,2
 36c:	09c000ef          	jal	408 <sys_sbrk>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 378:	4885                	li	a7,1
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <exit>:
.global exit
exit:
 li a7, SYS_exit
 380:	4889                	li	a7,2
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <wait>:
.global wait
wait:
 li a7, SYS_wait
 388:	488d                	li	a7,3
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 390:	4891                	li	a7,4
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <read>:
.global read
read:
 li a7, SYS_read
 398:	4895                	li	a7,5
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <write>:
.global write
write:
 li a7, SYS_write
 3a0:	48c1                	li	a7,16
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <close>:
.global close
close:
 li a7, SYS_close
 3a8:	48d5                	li	a7,21
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b0:	4899                	li	a7,6
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b8:	489d                	li	a7,7
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <open>:
.global open
open:
 li a7, SYS_open
 3c0:	48bd                	li	a7,15
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c8:	48c5                	li	a7,17
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d0:	48c9                	li	a7,18
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d8:	48a1                	li	a7,8
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <link>:
.global link
link:
 li a7, SYS_link
 3e0:	48cd                	li	a7,19
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e8:	48d1                	li	a7,20
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f0:	48a5                	li	a7,9
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f8:	48a9                	li	a7,10
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 400:	48ad                	li	a7,11
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 408:	48b1                	li	a7,12
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <pause>:
.global pause
pause:
 li a7, SYS_pause
 410:	48b5                	li	a7,13
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 418:	48b9                	li	a7,14
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <kps>:
.global kps
kps:
 li a7, SYS_kps
 420:	48d9                	li	a7,22
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 428:	48dd                	li	a7,23
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 430:	48e1                	li	a7,24
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 438:	48e5                	li	a7,25
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 440:	48e9                	li	a7,26
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 448:	1101                	addi	sp,sp,-32
 44a:	ec06                	sd	ra,24(sp)
 44c:	e822                	sd	s0,16(sp)
 44e:	1000                	addi	s0,sp,32
 450:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 454:	4605                	li	a2,1
 456:	fef40593          	addi	a1,s0,-17
 45a:	f47ff0ef          	jal	3a0 <write>
}
 45e:	60e2                	ld	ra,24(sp)
 460:	6442                	ld	s0,16(sp)
 462:	6105                	addi	sp,sp,32
 464:	8082                	ret

0000000000000466 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 466:	715d                	addi	sp,sp,-80
 468:	e486                	sd	ra,72(sp)
 46a:	e0a2                	sd	s0,64(sp)
 46c:	f84a                	sd	s2,48(sp)
 46e:	f44e                	sd	s3,40(sp)
 470:	0880                	addi	s0,sp,80
 472:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 474:	c6d1                	beqz	a3,500 <printint+0x9a>
 476:	0805d563          	bgez	a1,500 <printint+0x9a>
    neg = 1;
    x = -xx;
 47a:	40b005b3          	neg	a1,a1
    neg = 1;
 47e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 480:	fb840993          	addi	s3,s0,-72
  neg = 0;
 484:	86ce                	mv	a3,s3
  i = 0;
 486:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 488:	00000817          	auipc	a6,0x0
 48c:	56880813          	addi	a6,a6,1384 # 9f0 <digits>
 490:	88ba                	mv	a7,a4
 492:	0017051b          	addiw	a0,a4,1
 496:	872a                	mv	a4,a0
 498:	02c5f7b3          	remu	a5,a1,a2
 49c:	97c2                	add	a5,a5,a6
 49e:	0007c783          	lbu	a5,0(a5)
 4a2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a6:	87ae                	mv	a5,a1
 4a8:	02c5d5b3          	divu	a1,a1,a2
 4ac:	0685                	addi	a3,a3,1
 4ae:	fec7f1e3          	bgeu	a5,a2,490 <printint+0x2a>
  if(neg)
 4b2:	00030c63          	beqz	t1,4ca <printint+0x64>
    buf[i++] = '-';
 4b6:	fd050793          	addi	a5,a0,-48
 4ba:	00878533          	add	a0,a5,s0
 4be:	02d00793          	li	a5,45
 4c2:	fef50423          	sb	a5,-24(a0)
 4c6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4ca:	02e05563          	blez	a4,4f4 <printint+0x8e>
 4ce:	fc26                	sd	s1,56(sp)
 4d0:	377d                	addiw	a4,a4,-1
 4d2:	00e984b3          	add	s1,s3,a4
 4d6:	19fd                	addi	s3,s3,-1
 4d8:	99ba                	add	s3,s3,a4
 4da:	1702                	slli	a4,a4,0x20
 4dc:	9301                	srli	a4,a4,0x20
 4de:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e2:	0004c583          	lbu	a1,0(s1)
 4e6:	854a                	mv	a0,s2
 4e8:	f61ff0ef          	jal	448 <putc>
  while(--i >= 0)
 4ec:	14fd                	addi	s1,s1,-1
 4ee:	ff349ae3          	bne	s1,s3,4e2 <printint+0x7c>
 4f2:	74e2                	ld	s1,56(sp)
}
 4f4:	60a6                	ld	ra,72(sp)
 4f6:	6406                	ld	s0,64(sp)
 4f8:	7942                	ld	s2,48(sp)
 4fa:	79a2                	ld	s3,40(sp)
 4fc:	6161                	addi	sp,sp,80
 4fe:	8082                	ret
  neg = 0;
 500:	4301                	li	t1,0
 502:	bfbd                	j	480 <printint+0x1a>

0000000000000504 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 504:	711d                	addi	sp,sp,-96
 506:	ec86                	sd	ra,88(sp)
 508:	e8a2                	sd	s0,80(sp)
 50a:	e4a6                	sd	s1,72(sp)
 50c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 50e:	0005c483          	lbu	s1,0(a1)
 512:	22048363          	beqz	s1,738 <vprintf+0x234>
 516:	e0ca                	sd	s2,64(sp)
 518:	fc4e                	sd	s3,56(sp)
 51a:	f852                	sd	s4,48(sp)
 51c:	f456                	sd	s5,40(sp)
 51e:	f05a                	sd	s6,32(sp)
 520:	ec5e                	sd	s7,24(sp)
 522:	e862                	sd	s8,16(sp)
 524:	8b2a                	mv	s6,a0
 526:	8a2e                	mv	s4,a1
 528:	8bb2                	mv	s7,a2
  state = 0;
 52a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 52c:	4901                	li	s2,0
 52e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 530:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 534:	06400c13          	li	s8,100
 538:	a00d                	j	55a <vprintf+0x56>
        putc(fd, c0);
 53a:	85a6                	mv	a1,s1
 53c:	855a                	mv	a0,s6
 53e:	f0bff0ef          	jal	448 <putc>
 542:	a019                	j	548 <vprintf+0x44>
    } else if(state == '%'){
 544:	03598363          	beq	s3,s5,56a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 548:	0019079b          	addiw	a5,s2,1
 54c:	893e                	mv	s2,a5
 54e:	873e                	mv	a4,a5
 550:	97d2                	add	a5,a5,s4
 552:	0007c483          	lbu	s1,0(a5)
 556:	1c048a63          	beqz	s1,72a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 55a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 55e:	fe0993e3          	bnez	s3,544 <vprintf+0x40>
      if(c0 == '%'){
 562:	fd579ce3          	bne	a5,s5,53a <vprintf+0x36>
        state = '%';
 566:	89be                	mv	s3,a5
 568:	b7c5                	j	548 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 56a:	00ea06b3          	add	a3,s4,a4
 56e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 572:	1c060863          	beqz	a2,742 <vprintf+0x23e>
      if(c0 == 'd'){
 576:	03878763          	beq	a5,s8,5a4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 57a:	f9478693          	addi	a3,a5,-108
 57e:	0016b693          	seqz	a3,a3
 582:	f9c60593          	addi	a1,a2,-100
 586:	e99d                	bnez	a1,5bc <vprintf+0xb8>
 588:	ca95                	beqz	a3,5bc <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	008b8493          	addi	s1,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000bb583          	ld	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	ecfff0ef          	jal	466 <printint>
        i += 1;
 59c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b75d                	j	548 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	eb5ff0ef          	jal	466 <printint>
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b779                	j	548 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5bc:	9752                	add	a4,a4,s4
 5be:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c2:	f9460713          	addi	a4,a2,-108
 5c6:	00173713          	seqz	a4,a4
 5ca:	8f75                	and	a4,a4,a3
 5cc:	f9c58513          	addi	a0,a1,-100
 5d0:	18051363          	bnez	a0,756 <vprintf+0x252>
 5d4:	18070163          	beqz	a4,756 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d8:	008b8493          	addi	s1,s7,8
 5dc:	4685                	li	a3,1
 5de:	4629                	li	a2,10
 5e0:	000bb583          	ld	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	e81ff0ef          	jal	466 <printint>
        i += 2;
 5ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
        i += 2;
 5f0:	bfa1                	j	548 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4629                	li	a2,10
 5fa:	000be583          	lwu	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e67ff0ef          	jal	466 <printint>
 604:	8ba6                	mv	s7,s1
      state = 0;
 606:	4981                	li	s3,0
 608:	b781                	j	548 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4681                	li	a3,0
 610:	4629                	li	a2,10
 612:	000bb583          	ld	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e4fff0ef          	jal	466 <printint>
        i += 1;
 61c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	8ba6                	mv	s7,s1
      state = 0;
 620:	4981                	li	s3,0
 622:	b71d                	j	548 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	008b8493          	addi	s1,s7,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000bb583          	ld	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	e35ff0ef          	jal	466 <printint>
        i += 2;
 636:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	8ba6                	mv	s7,s1
      state = 0;
 63a:	4981                	li	s3,0
        i += 2;
 63c:	b731                	j	548 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 63e:	008b8493          	addi	s1,s7,8
 642:	4681                	li	a3,0
 644:	4641                	li	a2,16
 646:	000be583          	lwu	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e1bff0ef          	jal	466 <printint>
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
 654:	bdd5                	j	548 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 656:	008b8493          	addi	s1,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000bb583          	ld	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	e03ff0ef          	jal	466 <printint>
        i += 1;
 668:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 66a:	8ba6                	mv	s7,s1
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bde9                	j	548 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	008b8493          	addi	s1,s7,8
 674:	4681                	li	a3,0
 676:	4641                	li	a2,16
 678:	000bb583          	ld	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	de9ff0ef          	jal	466 <printint>
        i += 2;
 682:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	8ba6                	mv	s7,s1
      state = 0;
 686:	4981                	li	s3,0
        i += 2;
 688:	b5c1                	j	548 <vprintf+0x44>
 68a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 68c:	008b8793          	addi	a5,s7,8
 690:	8cbe                	mv	s9,a5
 692:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 696:	03000593          	li	a1,48
 69a:	855a                	mv	a0,s6
 69c:	dadff0ef          	jal	448 <putc>
  putc(fd, 'x');
 6a0:	07800593          	li	a1,120
 6a4:	855a                	mv	a0,s6
 6a6:	da3ff0ef          	jal	448 <putc>
 6aa:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ac:	00000b97          	auipc	s7,0x0
 6b0:	344b8b93          	addi	s7,s7,836 # 9f0 <digits>
 6b4:	03c9d793          	srli	a5,s3,0x3c
 6b8:	97de                	add	a5,a5,s7
 6ba:	0007c583          	lbu	a1,0(a5)
 6be:	855a                	mv	a0,s6
 6c0:	d89ff0ef          	jal	448 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c4:	0992                	slli	s3,s3,0x4
 6c6:	34fd                	addiw	s1,s1,-1
 6c8:	f4f5                	bnez	s1,6b4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6ca:	8be6                	mv	s7,s9
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	6ca2                	ld	s9,8(sp)
 6d0:	bda5                	j	548 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6d2:	008b8493          	addi	s1,s7,8
 6d6:	000bc583          	lbu	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	d6dff0ef          	jal	448 <putc>
 6e0:	8ba6                	mv	s7,s1
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b595                	j	548 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6e6:	008b8993          	addi	s3,s7,8
 6ea:	000bb483          	ld	s1,0(s7)
 6ee:	cc91                	beqz	s1,70a <vprintf+0x206>
        for(; *s; s++)
 6f0:	0004c583          	lbu	a1,0(s1)
 6f4:	c985                	beqz	a1,724 <vprintf+0x220>
          putc(fd, *s);
 6f6:	855a                	mv	a0,s6
 6f8:	d51ff0ef          	jal	448 <putc>
        for(; *s; s++)
 6fc:	0485                	addi	s1,s1,1
 6fe:	0004c583          	lbu	a1,0(s1)
 702:	f9f5                	bnez	a1,6f6 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 704:	8bce                	mv	s7,s3
      state = 0;
 706:	4981                	li	s3,0
 708:	b581                	j	548 <vprintf+0x44>
          s = "(null)";
 70a:	00000497          	auipc	s1,0x0
 70e:	2de48493          	addi	s1,s1,734 # 9e8 <malloc+0x142>
        for(; *s; s++)
 712:	02800593          	li	a1,40
 716:	b7c5                	j	6f6 <vprintf+0x1f2>
        putc(fd, '%');
 718:	85be                	mv	a1,a5
 71a:	855a                	mv	a0,s6
 71c:	d2dff0ef          	jal	448 <putc>
      state = 0;
 720:	4981                	li	s3,0
 722:	b51d                	j	548 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 724:	8bce                	mv	s7,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	b505                	j	548 <vprintf+0x44>
 72a:	6906                	ld	s2,64(sp)
 72c:	79e2                	ld	s3,56(sp)
 72e:	7a42                	ld	s4,48(sp)
 730:	7aa2                	ld	s5,40(sp)
 732:	7b02                	ld	s6,32(sp)
 734:	6be2                	ld	s7,24(sp)
 736:	6c42                	ld	s8,16(sp)
    }
  }
}
 738:	60e6                	ld	ra,88(sp)
 73a:	6446                	ld	s0,80(sp)
 73c:	64a6                	ld	s1,72(sp)
 73e:	6125                	addi	sp,sp,96
 740:	8082                	ret
      if(c0 == 'd'){
 742:	06400713          	li	a4,100
 746:	e4e78fe3          	beq	a5,a4,5a4 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 74a:	f9478693          	addi	a3,a5,-108
 74e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 752:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 754:	4701                	li	a4,0
      } else if(c0 == 'u'){
 756:	07500513          	li	a0,117
 75a:	e8a78ce3          	beq	a5,a0,5f2 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 75e:	f8b60513          	addi	a0,a2,-117
 762:	e119                	bnez	a0,768 <vprintf+0x264>
 764:	ea0693e3          	bnez	a3,60a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 768:	f8b58513          	addi	a0,a1,-117
 76c:	e119                	bnez	a0,772 <vprintf+0x26e>
 76e:	ea071be3          	bnez	a4,624 <vprintf+0x120>
      } else if(c0 == 'x'){
 772:	07800513          	li	a0,120
 776:	eca784e3          	beq	a5,a0,63e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 77a:	f8860613          	addi	a2,a2,-120
 77e:	e219                	bnez	a2,784 <vprintf+0x280>
 780:	ec069be3          	bnez	a3,656 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 784:	f8858593          	addi	a1,a1,-120
 788:	e199                	bnez	a1,78e <vprintf+0x28a>
 78a:	ee0713e3          	bnez	a4,670 <vprintf+0x16c>
      } else if(c0 == 'p'){
 78e:	07000713          	li	a4,112
 792:	eee78ce3          	beq	a5,a4,68a <vprintf+0x186>
      } else if(c0 == 'c'){
 796:	06300713          	li	a4,99
 79a:	f2e78ce3          	beq	a5,a4,6d2 <vprintf+0x1ce>
      } else if(c0 == 's'){
 79e:	07300713          	li	a4,115
 7a2:	f4e782e3          	beq	a5,a4,6e6 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7a6:	02500713          	li	a4,37
 7aa:	f6e787e3          	beq	a5,a4,718 <vprintf+0x214>
        putc(fd, '%');
 7ae:	02500593          	li	a1,37
 7b2:	855a                	mv	a0,s6
 7b4:	c95ff0ef          	jal	448 <putc>
        putc(fd, c0);
 7b8:	85a6                	mv	a1,s1
 7ba:	855a                	mv	a0,s6
 7bc:	c8dff0ef          	jal	448 <putc>
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b359                	j	548 <vprintf+0x44>

00000000000007c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c4:	715d                	addi	sp,sp,-80
 7c6:	ec06                	sd	ra,24(sp)
 7c8:	e822                	sd	s0,16(sp)
 7ca:	1000                	addi	s0,sp,32
 7cc:	e010                	sd	a2,0(s0)
 7ce:	e414                	sd	a3,8(s0)
 7d0:	e818                	sd	a4,16(s0)
 7d2:	ec1c                	sd	a5,24(s0)
 7d4:	03043023          	sd	a6,32(s0)
 7d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7dc:	8622                	mv	a2,s0
 7de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e2:	d23ff0ef          	jal	504 <vprintf>
}
 7e6:	60e2                	ld	ra,24(sp)
 7e8:	6442                	ld	s0,16(sp)
 7ea:	6161                	addi	sp,sp,80
 7ec:	8082                	ret

00000000000007ee <printf>:

void
printf(const char *fmt, ...)
{
 7ee:	711d                	addi	sp,sp,-96
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e40c                	sd	a1,8(s0)
 7f8:	e810                	sd	a2,16(s0)
 7fa:	ec14                	sd	a3,24(s0)
 7fc:	f018                	sd	a4,32(s0)
 7fe:	f41c                	sd	a5,40(s0)
 800:	03043823          	sd	a6,48(s0)
 804:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	00840613          	addi	a2,s0,8
 80c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 810:	85aa                	mv	a1,a0
 812:	4505                	li	a0,1
 814:	cf1ff0ef          	jal	504 <vprintf>
}
 818:	60e2                	ld	ra,24(sp)
 81a:	6442                	ld	s0,16(sp)
 81c:	6125                	addi	sp,sp,96
 81e:	8082                	ret

0000000000000820 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 820:	1141                	addi	sp,sp,-16
 822:	e406                	sd	ra,8(sp)
 824:	e022                	sd	s0,0(sp)
 826:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 828:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	00000797          	auipc	a5,0x0
 830:	7d47b783          	ld	a5,2004(a5) # 1000 <freep>
 834:	a039                	j	842 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	6398                	ld	a4,0(a5)
 838:	00e7e463          	bltu	a5,a4,840 <free+0x20>
 83c:	00e6ea63          	bltu	a3,a4,850 <free+0x30>
{
 840:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	fed7fae3          	bgeu	a5,a3,836 <free+0x16>
 846:	6398                	ld	a4,0(a5)
 848:	00e6e463          	bltu	a3,a4,850 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	fee7eae3          	bltu	a5,a4,840 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 850:	ff852583          	lw	a1,-8(a0)
 854:	6390                	ld	a2,0(a5)
 856:	02059813          	slli	a6,a1,0x20
 85a:	01c85713          	srli	a4,a6,0x1c
 85e:	9736                	add	a4,a4,a3
 860:	02e60563          	beq	a2,a4,88a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 864:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 868:	4790                	lw	a2,8(a5)
 86a:	02061593          	slli	a1,a2,0x20
 86e:	01c5d713          	srli	a4,a1,0x1c
 872:	973e                	add	a4,a4,a5
 874:	02e68263          	beq	a3,a4,898 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 878:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 87a:	00000717          	auipc	a4,0x0
 87e:	78f73323          	sd	a5,1926(a4) # 1000 <freep>
}
 882:	60a2                	ld	ra,8(sp)
 884:	6402                	ld	s0,0(sp)
 886:	0141                	addi	sp,sp,16
 888:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 88a:	4618                	lw	a4,8(a2)
 88c:	9f2d                	addw	a4,a4,a1
 88e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	6398                	ld	a4,0(a5)
 894:	6310                	ld	a2,0(a4)
 896:	b7f9                	j	864 <free+0x44>
    p->s.size += bp->s.size;
 898:	ff852703          	lw	a4,-8(a0)
 89c:	9f31                	addw	a4,a4,a2
 89e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a0:	ff053683          	ld	a3,-16(a0)
 8a4:	bfd1                	j	878 <free+0x58>

00000000000008a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a6:	7139                	addi	sp,sp,-64
 8a8:	fc06                	sd	ra,56(sp)
 8aa:	f822                	sd	s0,48(sp)
 8ac:	f04a                	sd	s2,32(sp)
 8ae:	ec4e                	sd	s3,24(sp)
 8b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	02051993          	slli	s3,a0,0x20
 8b6:	0209d993          	srli	s3,s3,0x20
 8ba:	09bd                	addi	s3,s3,15
 8bc:	0049d993          	srli	s3,s3,0x4
 8c0:	2985                	addiw	s3,s3,1
 8c2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8c4:	00000517          	auipc	a0,0x0
 8c8:	73c53503          	ld	a0,1852(a0) # 1000 <freep>
 8cc:	c905                	beqz	a0,8fc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	09377663          	bgeu	a4,s3,95e <malloc+0xb8>
 8d6:	f426                	sd	s1,40(sp)
 8d8:	e852                	sd	s4,16(sp)
 8da:	e456                	sd	s5,8(sp)
 8dc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8de:	8a4e                	mv	s4,s3
 8e0:	6705                	lui	a4,0x1
 8e2:	00e9f363          	bgeu	s3,a4,8e8 <malloc+0x42>
 8e6:	6a05                	lui	s4,0x1
 8e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f0:	00000497          	auipc	s1,0x0
 8f4:	71048493          	addi	s1,s1,1808 # 1000 <freep>
  if(p == SBRK_ERROR)
 8f8:	5afd                	li	s5,-1
 8fa:	a83d                	j	938 <malloc+0x92>
 8fc:	f426                	sd	s1,40(sp)
 8fe:	e852                	sd	s4,16(sp)
 900:	e456                	sd	s5,8(sp)
 902:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 904:	00000797          	auipc	a5,0x0
 908:	70c78793          	addi	a5,a5,1804 # 1010 <base>
 90c:	00000717          	auipc	a4,0x0
 910:	6ef73a23          	sd	a5,1780(a4) # 1000 <freep>
 914:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 916:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 91a:	b7d1                	j	8de <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 91c:	6398                	ld	a4,0(a5)
 91e:	e118                	sd	a4,0(a0)
 920:	a899                	j	976 <malloc+0xd0>
  hp->s.size = nu;
 922:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 926:	0541                	addi	a0,a0,16
 928:	ef9ff0ef          	jal	820 <free>
  return freep;
 92c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 92e:	c125                	beqz	a0,98e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 930:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 932:	4798                	lw	a4,8(a5)
 934:	03277163          	bgeu	a4,s2,956 <malloc+0xb0>
    if(p == freep)
 938:	6098                	ld	a4,0(s1)
 93a:	853e                	mv	a0,a5
 93c:	fef71ae3          	bne	a4,a5,930 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 940:	8552                	mv	a0,s4
 942:	a0bff0ef          	jal	34c <sbrk>
  if(p == SBRK_ERROR)
 946:	fd551ee3          	bne	a0,s5,922 <malloc+0x7c>
        return 0;
 94a:	4501                	li	a0,0
 94c:	74a2                	ld	s1,40(sp)
 94e:	6a42                	ld	s4,16(sp)
 950:	6aa2                	ld	s5,8(sp)
 952:	6b02                	ld	s6,0(sp)
 954:	a03d                	j	982 <malloc+0xdc>
 956:	74a2                	ld	s1,40(sp)
 958:	6a42                	ld	s4,16(sp)
 95a:	6aa2                	ld	s5,8(sp)
 95c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 95e:	fae90fe3          	beq	s2,a4,91c <malloc+0x76>
        p->s.size -= nunits;
 962:	4137073b          	subw	a4,a4,s3
 966:	c798                	sw	a4,8(a5)
        p += p->s.size;
 968:	02071693          	slli	a3,a4,0x20
 96c:	01c6d713          	srli	a4,a3,0x1c
 970:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 972:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 976:	00000717          	auipc	a4,0x0
 97a:	68a73523          	sd	a0,1674(a4) # 1000 <freep>
      return (void*)(p + 1);
 97e:	01078513          	addi	a0,a5,16
  }
}
 982:	70e2                	ld	ra,56(sp)
 984:	7442                	ld	s0,48(sp)
 986:	7902                	ld	s2,32(sp)
 988:	69e2                	ld	s3,24(sp)
 98a:	6121                	addi	sp,sp,64
 98c:	8082                	ret
 98e:	74a2                	ld	s1,40(sp)
 990:	6a42                	ld	s4,16(sp)
 992:	6aa2                	ld	s5,8(sp)
 994:	6b02                	ld	s6,0(sp)
 996:	b7f5                	j	982 <malloc+0xdc>
