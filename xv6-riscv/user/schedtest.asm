
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
  10:	3f6000ef          	jal	406 <uptime>
  14:	892a                	mv	s2,a0
    while (uptime() - start < iterations*10) {
  16:	0029949b          	slliw	s1,s3,0x2
  1a:	013484bb          	addw	s1,s1,s3
  1e:	0014949b          	slliw	s1,s1,0x1
  22:	3e4000ef          	jal	406 <uptime>
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
  48:	3a6000ef          	jal	3ee <getpid>

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
  74:	92098993          	addi	s3,s3,-1760 # 990 <malloc+0x11e>
    for (i = 0; i < 5; i++) {
  78:	4915                	li	s2,5
        int pid = fork();
  7a:	2ec000ef          	jal	366 <fork>
  7e:	862a                	mv	a2,a0
        if (pid < 0) {
  80:	02054c63          	bltz	a0,b8 <main+0x58>
        } else if (pid == 0) {
  84:	c521                	beqz	a0,cc <main+0x6c>
            printf("Parent: Forked child %d with PID %d\n", i + 1, pid);
  86:	2485                	addiw	s1,s1,1
  88:	85a6                	mv	a1,s1
  8a:	854e                	mv	a0,s3
  8c:	732000ef          	jal	7be <printf>
    for (i = 0; i < 5; i++) {
  90:	ff2495e3          	bne	s1,s2,7a <main+0x1a>
    
    
   
    
    for (i = 0; i < 5; i++) {
        wait(0);
  94:	4501                	li	a0,0
  96:	2e0000ef          	jal	376 <wait>
  9a:	4501                	li	a0,0
  9c:	2da000ef          	jal	376 <wait>
  a0:	4501                	li	a0,0
  a2:	2d4000ef          	jal	376 <wait>
  a6:	4501                	li	a0,0
  a8:	2ce000ef          	jal	376 <wait>
  ac:	4501                	li	a0,0
  ae:	2c8000ef          	jal	376 <wait>
    }
    
    
    exit(0);
  b2:	4501                	li	a0,0
  b4:	2ba000ef          	jal	36e <exit>
            printf("Fork failed for child %d\n", i);
  b8:	85a6                	mv	a1,s1
  ba:	00001517          	auipc	a0,0x1
  be:	8b650513          	addi	a0,a0,-1866 # 970 <malloc+0xfe>
  c2:	6fc000ef          	jal	7be <printf>
            exit(1);
  c6:	4505                	li	a0,1
  c8:	2a6000ef          	jal	36e <exit>
            child_process(i + 1);
  cc:	0014851b          	addiw	a0,s1,1
  d0:	f6dff0ef          	jal	3c <child_process>
            exit(0);  
  d4:	4501                	li	a0,0
  d6:	298000ef          	jal	36e <exit>

00000000000000da <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  e2:	f7fff0ef          	jal	60 <main>
  exit(r);
  e6:	288000ef          	jal	36e <exit>

00000000000000ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f0:	87aa                	mv	a5,a0
  f2:	0585                	addi	a1,a1,1
  f4:	0785                	addi	a5,a5,1
  f6:	fff5c703          	lbu	a4,-1(a1)
  fa:	fee78fa3          	sb	a4,-1(a5)
  fe:	fb75                	bnez	a4,f2 <strcpy+0x8>
    ;
  return os;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x1e>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x1e>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strlen>:

uint
strlen(const char *s)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf91                	beqz	a5,158 <strlen+0x26>
 13e:	0505                	addi	a0,a0,1
 140:	87aa                	mv	a5,a0
 142:	86be                	mv	a3,a5
 144:	0785                	addi	a5,a5,1
 146:	fff7c703          	lbu	a4,-1(a5)
 14a:	ff65                	bnez	a4,142 <strlen+0x10>
 14c:	40a6853b          	subw	a0,a3,a0
 150:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  for(n = 0; s[n]; n++)
 158:	4501                	li	a0,0
 15a:	bfe5                	j	152 <strlen+0x20>

000000000000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 162:	ca19                	beqz	a2,178 <memset+0x1c>
 164:	87aa                	mv	a5,a0
 166:	1602                	slli	a2,a2,0x20
 168:	9201                	srli	a2,a2,0x20
 16a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 172:	0785                	addi	a5,a5,1
 174:	fee79de3          	bne	a5,a4,16e <memset+0x12>
  }
  return dst;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strchr>:

char*
strchr(const char *s, char c)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  for(; *s; s++)
 184:	00054783          	lbu	a5,0(a0)
 188:	cb99                	beqz	a5,19e <strchr+0x20>
    if(*s == c)
 18a:	00f58763          	beq	a1,a5,198 <strchr+0x1a>
  for(; *s; s++)
 18e:	0505                	addi	a0,a0,1
 190:	00054783          	lbu	a5,0(a0)
 194:	fbfd                	bnez	a5,18a <strchr+0xc>
      return (char*)s;
  return 0;
 196:	4501                	li	a0,0
}
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret
  return 0;
 19e:	4501                	li	a0,0
 1a0:	bfe5                	j	198 <strchr+0x1a>

00000000000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	711d                	addi	sp,sp,-96
 1a4:	ec86                	sd	ra,88(sp)
 1a6:	e8a2                	sd	s0,80(sp)
 1a8:	e4a6                	sd	s1,72(sp)
 1aa:	e0ca                	sd	s2,64(sp)
 1ac:	fc4e                	sd	s3,56(sp)
 1ae:	f852                	sd	s4,48(sp)
 1b0:	f456                	sd	s5,40(sp)
 1b2:	f05a                	sd	s6,32(sp)
 1b4:	ec5e                	sd	s7,24(sp)
 1b6:	1080                	addi	s0,sp,96
 1b8:	8baa                	mv	s7,a0
 1ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bc:	892a                	mv	s2,a0
 1be:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c0:	4aa9                	li	s5,10
 1c2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c4:	89a6                	mv	s3,s1
 1c6:	2485                	addiw	s1,s1,1
 1c8:	0344d663          	bge	s1,s4,1f4 <gets+0x52>
    cc = read(0, &c, 1);
 1cc:	4605                	li	a2,1
 1ce:	faf40593          	addi	a1,s0,-81
 1d2:	4501                	li	a0,0
 1d4:	1b2000ef          	jal	386 <read>
    if(cc < 1)
 1d8:	00a05e63          	blez	a0,1f4 <gets+0x52>
    buf[i++] = c;
 1dc:	faf44783          	lbu	a5,-81(s0)
 1e0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e4:	01578763          	beq	a5,s5,1f2 <gets+0x50>
 1e8:	0905                	addi	s2,s2,1
 1ea:	fd679de3          	bne	a5,s6,1c4 <gets+0x22>
    buf[i++] = c;
 1ee:	89a6                	mv	s3,s1
 1f0:	a011                	j	1f4 <gets+0x52>
 1f2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f4:	99de                	add	s3,s3,s7
 1f6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1fa:	855e                	mv	a0,s7
 1fc:	60e6                	ld	ra,88(sp)
 1fe:	6446                	ld	s0,80(sp)
 200:	64a6                	ld	s1,72(sp)
 202:	6906                	ld	s2,64(sp)
 204:	79e2                	ld	s3,56(sp)
 206:	7a42                	ld	s4,48(sp)
 208:	7aa2                	ld	s5,40(sp)
 20a:	7b02                	ld	s6,32(sp)
 20c:	6be2                	ld	s7,24(sp)
 20e:	6125                	addi	sp,sp,96
 210:	8082                	ret

0000000000000212 <stat>:

int
stat(const char *n, struct stat *st)
{
 212:	1101                	addi	sp,sp,-32
 214:	ec06                	sd	ra,24(sp)
 216:	e822                	sd	s0,16(sp)
 218:	e04a                	sd	s2,0(sp)
 21a:	1000                	addi	s0,sp,32
 21c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21e:	4581                	li	a1,0
 220:	18e000ef          	jal	3ae <open>
  if(fd < 0)
 224:	02054263          	bltz	a0,248 <stat+0x36>
 228:	e426                	sd	s1,8(sp)
 22a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22c:	85ca                	mv	a1,s2
 22e:	198000ef          	jal	3c6 <fstat>
 232:	892a                	mv	s2,a0
  close(fd);
 234:	8526                	mv	a0,s1
 236:	160000ef          	jal	396 <close>
  return r;
 23a:	64a2                	ld	s1,8(sp)
}
 23c:	854a                	mv	a0,s2
 23e:	60e2                	ld	ra,24(sp)
 240:	6442                	ld	s0,16(sp)
 242:	6902                	ld	s2,0(sp)
 244:	6105                	addi	sp,sp,32
 246:	8082                	ret
    return -1;
 248:	597d                	li	s2,-1
 24a:	bfcd                	j	23c <stat+0x2a>

000000000000024c <atoi>:

int
atoi(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	00054683          	lbu	a3,0(a0)
 256:	fd06879b          	addiw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	4625                	li	a2,9
 260:	02f66863          	bltu	a2,a5,290 <atoi+0x44>
 264:	872a                	mv	a4,a0
  n = 0;
 266:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 268:	0705                	addi	a4,a4,1
 26a:	0025179b          	slliw	a5,a0,0x2
 26e:	9fa9                	addw	a5,a5,a0
 270:	0017979b          	slliw	a5,a5,0x1
 274:	9fb5                	addw	a5,a5,a3
 276:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27a:	00074683          	lbu	a3,0(a4)
 27e:	fd06879b          	addiw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	fef671e3          	bgeu	a2,a5,268 <atoi+0x1c>
  return n;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  n = 0;
 290:	4501                	li	a0,0
 292:	bfe5                	j	28a <atoi+0x3e>

0000000000000294 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29a:	02b57463          	bgeu	a0,a1,2c2 <memmove+0x2e>
    while(n-- > 0)
 29e:	00c05f63          	blez	a2,2bc <memmove+0x28>
 2a2:	1602                	slli	a2,a2,0x20
 2a4:	9201                	srli	a2,a2,0x20
 2a6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2aa:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ac:	0585                	addi	a1,a1,1
 2ae:	0705                	addi	a4,a4,1
 2b0:	fff5c683          	lbu	a3,-1(a1)
 2b4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b8:	fef71ae3          	bne	a4,a5,2ac <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
    dst += n;
 2c2:	00c50733          	add	a4,a0,a2
    src += n;
 2c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c8:	fec05ae3          	blez	a2,2bc <memmove+0x28>
 2cc:	fff6079b          	addiw	a5,a2,-1
 2d0:	1782                	slli	a5,a5,0x20
 2d2:	9381                	srli	a5,a5,0x20
 2d4:	fff7c793          	not	a5,a5
 2d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2da:	15fd                	addi	a1,a1,-1
 2dc:	177d                	addi	a4,a4,-1
 2de:	0005c683          	lbu	a3,0(a1)
 2e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e6:	fee79ae3          	bne	a5,a4,2da <memmove+0x46>
 2ea:	bfc9                	j	2bc <memmove+0x28>

00000000000002ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f2:	ca05                	beqz	a2,322 <memcmp+0x36>
 2f4:	fff6069b          	addiw	a3,a2,-1
 2f8:	1682                	slli	a3,a3,0x20
 2fa:	9281                	srli	a3,a3,0x20
 2fc:	0685                	addi	a3,a3,1
 2fe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 300:	00054783          	lbu	a5,0(a0)
 304:	0005c703          	lbu	a4,0(a1)
 308:	00e79863          	bne	a5,a4,318 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 30c:	0505                	addi	a0,a0,1
    p2++;
 30e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 310:	fed518e3          	bne	a0,a3,300 <memcmp+0x14>
  }
  return 0;
 314:	4501                	li	a0,0
 316:	a019                	j	31c <memcmp+0x30>
      return *p1 - *p2;
 318:	40e7853b          	subw	a0,a5,a4
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
  return 0;
 322:	4501                	li	a0,0
 324:	bfe5                	j	31c <memcmp+0x30>

0000000000000326 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32e:	f67ff0ef          	jal	294 <memmove>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <sbrk>:

char *
sbrk(int n) {
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 342:	4585                	li	a1,1
 344:	0b2000ef          	jal	3f6 <sys_sbrk>
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret

0000000000000350 <sbrklazy>:

char *
sbrklazy(int n) {
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 358:	4589                	li	a1,2
 35a:	09c000ef          	jal	3f6 <sys_sbrk>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 366:	4885                	li	a7,1
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exit>:
.global exit
exit:
 li a7, SYS_exit
 36e:	4889                	li	a7,2
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <wait>:
.global wait
wait:
 li a7, SYS_wait
 376:	488d                	li	a7,3
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 37e:	4891                	li	a7,4
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <read>:
.global read
read:
 li a7, SYS_read
 386:	4895                	li	a7,5
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <write>:
.global write
write:
 li a7, SYS_write
 38e:	48c1                	li	a7,16
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <close>:
.global close
close:
 li a7, SYS_close
 396:	48d5                	li	a7,21
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <kill>:
.global kill
kill:
 li a7, SYS_kill
 39e:	4899                	li	a7,6
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a6:	489d                	li	a7,7
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <open>:
.global open
open:
 li a7, SYS_open
 3ae:	48bd                	li	a7,15
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b6:	48c5                	li	a7,17
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3be:	48c9                	li	a7,18
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c6:	48a1                	li	a7,8
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <link>:
.global link
link:
 li a7, SYS_link
 3ce:	48cd                	li	a7,19
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d6:	48d1                	li	a7,20
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3de:	48a5                	li	a7,9
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e6:	48a9                	li	a7,10
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ee:	48ad                	li	a7,11
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3f6:	48b1                	li	a7,12
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <pause>:
.global pause
pause:
 li a7, SYS_pause
 3fe:	48b5                	li	a7,13
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 406:	48b9                	li	a7,14
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <kps>:
.global kps
kps:
 li a7, SYS_kps
 40e:	48d9                	li	a7,22
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 416:	48dd                	li	a7,23
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 41e:	48e1                	li	a7,24
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 426:	48e5                	li	a7,25
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 42e:	48e9                	li	a7,26
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 436:	1101                	addi	sp,sp,-32
 438:	ec06                	sd	ra,24(sp)
 43a:	e822                	sd	s0,16(sp)
 43c:	1000                	addi	s0,sp,32
 43e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 442:	4605                	li	a2,1
 444:	fef40593          	addi	a1,s0,-17
 448:	f47ff0ef          	jal	38e <write>
}
 44c:	60e2                	ld	ra,24(sp)
 44e:	6442                	ld	s0,16(sp)
 450:	6105                	addi	sp,sp,32
 452:	8082                	ret

0000000000000454 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 454:	715d                	addi	sp,sp,-80
 456:	e486                	sd	ra,72(sp)
 458:	e0a2                	sd	s0,64(sp)
 45a:	f84a                	sd	s2,48(sp)
 45c:	0880                	addi	s0,sp,80
 45e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 460:	c299                	beqz	a3,466 <printint+0x12>
 462:	0805c363          	bltz	a1,4e8 <printint+0x94>
  neg = 0;
 466:	4881                	li	a7,0
 468:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 46c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 46e:	00000517          	auipc	a0,0x0
 472:	55250513          	addi	a0,a0,1362 # 9c0 <digits>
 476:	883e                	mv	a6,a5
 478:	2785                	addiw	a5,a5,1
 47a:	02c5f733          	remu	a4,a1,a2
 47e:	972a                	add	a4,a4,a0
 480:	00074703          	lbu	a4,0(a4)
 484:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 488:	872e                	mv	a4,a1
 48a:	02c5d5b3          	divu	a1,a1,a2
 48e:	0685                	addi	a3,a3,1
 490:	fec773e3          	bgeu	a4,a2,476 <printint+0x22>
  if(neg)
 494:	00088b63          	beqz	a7,4aa <printint+0x56>
    buf[i++] = '-';
 498:	fd078793          	addi	a5,a5,-48
 49c:	97a2                	add	a5,a5,s0
 49e:	02d00713          	li	a4,45
 4a2:	fee78423          	sb	a4,-24(a5)
 4a6:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4aa:	02f05a63          	blez	a5,4de <printint+0x8a>
 4ae:	fc26                	sd	s1,56(sp)
 4b0:	f44e                	sd	s3,40(sp)
 4b2:	fb840713          	addi	a4,s0,-72
 4b6:	00f704b3          	add	s1,a4,a5
 4ba:	fff70993          	addi	s3,a4,-1
 4be:	99be                	add	s3,s3,a5
 4c0:	37fd                	addiw	a5,a5,-1
 4c2:	1782                	slli	a5,a5,0x20
 4c4:	9381                	srli	a5,a5,0x20
 4c6:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4ca:	fff4c583          	lbu	a1,-1(s1)
 4ce:	854a                	mv	a0,s2
 4d0:	f67ff0ef          	jal	436 <putc>
  while(--i >= 0)
 4d4:	14fd                	addi	s1,s1,-1
 4d6:	ff349ae3          	bne	s1,s3,4ca <printint+0x76>
 4da:	74e2                	ld	s1,56(sp)
 4dc:	79a2                	ld	s3,40(sp)
}
 4de:	60a6                	ld	ra,72(sp)
 4e0:	6406                	ld	s0,64(sp)
 4e2:	7942                	ld	s2,48(sp)
 4e4:	6161                	addi	sp,sp,80
 4e6:	8082                	ret
    x = -xx;
 4e8:	40b005b3          	neg	a1,a1
    neg = 1;
 4ec:	4885                	li	a7,1
    x = -xx;
 4ee:	bfad                	j	468 <printint+0x14>

00000000000004f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f0:	711d                	addi	sp,sp,-96
 4f2:	ec86                	sd	ra,88(sp)
 4f4:	e8a2                	sd	s0,80(sp)
 4f6:	e0ca                	sd	s2,64(sp)
 4f8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4fa:	0005c903          	lbu	s2,0(a1)
 4fe:	28090663          	beqz	s2,78a <vprintf+0x29a>
 502:	e4a6                	sd	s1,72(sp)
 504:	fc4e                	sd	s3,56(sp)
 506:	f852                	sd	s4,48(sp)
 508:	f456                	sd	s5,40(sp)
 50a:	f05a                	sd	s6,32(sp)
 50c:	ec5e                	sd	s7,24(sp)
 50e:	e862                	sd	s8,16(sp)
 510:	e466                	sd	s9,8(sp)
 512:	8b2a                	mv	s6,a0
 514:	8a2e                	mv	s4,a1
 516:	8bb2                	mv	s7,a2
  state = 0;
 518:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 51a:	4481                	li	s1,0
 51c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 51e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 522:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 526:	06c00c93          	li	s9,108
 52a:	a005                	j	54a <vprintf+0x5a>
        putc(fd, c0);
 52c:	85ca                	mv	a1,s2
 52e:	855a                	mv	a0,s6
 530:	f07ff0ef          	jal	436 <putc>
 534:	a019                	j	53a <vprintf+0x4a>
    } else if(state == '%'){
 536:	03598263          	beq	s3,s5,55a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 53a:	2485                	addiw	s1,s1,1
 53c:	8726                	mv	a4,s1
 53e:	009a07b3          	add	a5,s4,s1
 542:	0007c903          	lbu	s2,0(a5)
 546:	22090a63          	beqz	s2,77a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 54a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 54e:	fe0994e3          	bnez	s3,536 <vprintf+0x46>
      if(c0 == '%'){
 552:	fd579de3          	bne	a5,s5,52c <vprintf+0x3c>
        state = '%';
 556:	89be                	mv	s3,a5
 558:	b7cd                	j	53a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 55a:	00ea06b3          	add	a3,s4,a4
 55e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 562:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 564:	c681                	beqz	a3,56c <vprintf+0x7c>
 566:	9752                	add	a4,a4,s4
 568:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 56c:	05878363          	beq	a5,s8,5b2 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 570:	05978d63          	beq	a5,s9,5ca <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 574:	07500713          	li	a4,117
 578:	0ee78763          	beq	a5,a4,666 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 57c:	07800713          	li	a4,120
 580:	12e78963          	beq	a5,a4,6b2 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 584:	07000713          	li	a4,112
 588:	14e78e63          	beq	a5,a4,6e4 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 58c:	06300713          	li	a4,99
 590:	18e78e63          	beq	a5,a4,72c <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 594:	07300713          	li	a4,115
 598:	1ae78463          	beq	a5,a4,740 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 59c:	02500713          	li	a4,37
 5a0:	04e79563          	bne	a5,a4,5ea <vprintf+0xfa>
        putc(fd, '%');
 5a4:	02500593          	li	a1,37
 5a8:	855a                	mv	a0,s6
 5aa:	e8dff0ef          	jal	436 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b769                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5b2:	008b8913          	addi	s2,s7,8
 5b6:	4685                	li	a3,1
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	e95ff0ef          	jal	454 <printint>
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	bf8d                	j	53a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5ca:	06400793          	li	a5,100
 5ce:	02f68963          	beq	a3,a5,600 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d2:	06c00793          	li	a5,108
 5d6:	04f68263          	beq	a3,a5,61a <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5da:	07500793          	li	a5,117
 5de:	0af68063          	beq	a3,a5,67e <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5e2:	07800793          	li	a5,120
 5e6:	0ef68263          	beq	a3,a5,6ca <vprintf+0x1da>
        putc(fd, '%');
 5ea:	02500593          	li	a1,37
 5ee:	855a                	mv	a0,s6
 5f0:	e47ff0ef          	jal	436 <putc>
        putc(fd, c0);
 5f4:	85ca                	mv	a1,s2
 5f6:	855a                	mv	a0,s6
 5f8:	e3fff0ef          	jal	436 <putc>
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bf35                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 600:	008b8913          	addi	s2,s7,8
 604:	4685                	li	a3,1
 606:	4629                	li	a2,10
 608:	000bb583          	ld	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	e47ff0ef          	jal	454 <printint>
        i += 1;
 612:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
        i += 1;
 618:	b70d                	j	53a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 61a:	06400793          	li	a5,100
 61e:	02f60763          	beq	a2,a5,64c <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 622:	07500793          	li	a5,117
 626:	06f60963          	beq	a2,a5,698 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 62a:	07800793          	li	a5,120
 62e:	faf61ee3          	bne	a2,a5,5ea <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	008b8913          	addi	s2,s7,8
 636:	4681                	li	a3,0
 638:	4641                	li	a2,16
 63a:	000bb583          	ld	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	e15ff0ef          	jal	454 <printint>
        i += 2;
 644:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
        i += 2;
 64a:	bdc5                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64c:	008b8913          	addi	s2,s7,8
 650:	4685                	li	a3,1
 652:	4629                	li	a2,10
 654:	000bb583          	ld	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	dfbff0ef          	jal	454 <printint>
        i += 2;
 65e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
        i += 2;
 664:	bdd9                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 666:	008b8913          	addi	s2,s7,8
 66a:	4681                	li	a3,0
 66c:	4629                	li	a2,10
 66e:	000be583          	lwu	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	de1ff0ef          	jal	454 <printint>
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bd7d                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67e:	008b8913          	addi	s2,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000bb583          	ld	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	dc9ff0ef          	jal	454 <printint>
        i += 1;
 690:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
        i += 1;
 696:	b555                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 698:	008b8913          	addi	s2,s7,8
 69c:	4681                	li	a3,0
 69e:	4629                	li	a2,10
 6a0:	000bb583          	ld	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	dafff0ef          	jal	454 <printint>
        i += 2;
 6aa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ac:	8bca                	mv	s7,s2
      state = 0;
 6ae:	4981                	li	s3,0
        i += 2;
 6b0:	b569                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	4681                	li	a3,0
 6b8:	4641                	li	a2,16
 6ba:	000be583          	lwu	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	d95ff0ef          	jal	454 <printint>
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bd8d                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4641                	li	a2,16
 6d2:	000bb583          	ld	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	d7dff0ef          	jal	454 <printint>
        i += 1;
 6dc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6de:	8bca                	mv	s7,s2
      state = 0;
 6e0:	4981                	li	s3,0
        i += 1;
 6e2:	bda1                	j	53a <vprintf+0x4a>
 6e4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6e6:	008b8d13          	addi	s10,s7,8
 6ea:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ee:	03000593          	li	a1,48
 6f2:	855a                	mv	a0,s6
 6f4:	d43ff0ef          	jal	436 <putc>
  putc(fd, 'x');
 6f8:	07800593          	li	a1,120
 6fc:	855a                	mv	a0,s6
 6fe:	d39ff0ef          	jal	436 <putc>
 702:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 704:	00000b97          	auipc	s7,0x0
 708:	2bcb8b93          	addi	s7,s7,700 # 9c0 <digits>
 70c:	03c9d793          	srli	a5,s3,0x3c
 710:	97de                	add	a5,a5,s7
 712:	0007c583          	lbu	a1,0(a5)
 716:	855a                	mv	a0,s6
 718:	d1fff0ef          	jal	436 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71c:	0992                	slli	s3,s3,0x4
 71e:	397d                	addiw	s2,s2,-1
 720:	fe0916e3          	bnez	s2,70c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 724:	8bea                	mv	s7,s10
      state = 0;
 726:	4981                	li	s3,0
 728:	6d02                	ld	s10,0(sp)
 72a:	bd01                	j	53a <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 72c:	008b8913          	addi	s2,s7,8
 730:	000bc583          	lbu	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	d01ff0ef          	jal	436 <putc>
 73a:	8bca                	mv	s7,s2
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bbf5                	j	53a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 740:	008b8993          	addi	s3,s7,8
 744:	000bb903          	ld	s2,0(s7)
 748:	00090f63          	beqz	s2,766 <vprintf+0x276>
        for(; *s; s++)
 74c:	00094583          	lbu	a1,0(s2)
 750:	c195                	beqz	a1,774 <vprintf+0x284>
          putc(fd, *s);
 752:	855a                	mv	a0,s6
 754:	ce3ff0ef          	jal	436 <putc>
        for(; *s; s++)
 758:	0905                	addi	s2,s2,1
 75a:	00094583          	lbu	a1,0(s2)
 75e:	f9f5                	bnez	a1,752 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 760:	8bce                	mv	s7,s3
      state = 0;
 762:	4981                	li	s3,0
 764:	bbd9                	j	53a <vprintf+0x4a>
          s = "(null)";
 766:	00000917          	auipc	s2,0x0
 76a:	25290913          	addi	s2,s2,594 # 9b8 <malloc+0x146>
        for(; *s; s++)
 76e:	02800593          	li	a1,40
 772:	b7c5                	j	752 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 774:	8bce                	mv	s7,s3
      state = 0;
 776:	4981                	li	s3,0
 778:	b3c9                	j	53a <vprintf+0x4a>
 77a:	64a6                	ld	s1,72(sp)
 77c:	79e2                	ld	s3,56(sp)
 77e:	7a42                	ld	s4,48(sp)
 780:	7aa2                	ld	s5,40(sp)
 782:	7b02                	ld	s6,32(sp)
 784:	6be2                	ld	s7,24(sp)
 786:	6c42                	ld	s8,16(sp)
 788:	6ca2                	ld	s9,8(sp)
    }
  }
}
 78a:	60e6                	ld	ra,88(sp)
 78c:	6446                	ld	s0,80(sp)
 78e:	6906                	ld	s2,64(sp)
 790:	6125                	addi	sp,sp,96
 792:	8082                	ret

0000000000000794 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 794:	715d                	addi	sp,sp,-80
 796:	ec06                	sd	ra,24(sp)
 798:	e822                	sd	s0,16(sp)
 79a:	1000                	addi	s0,sp,32
 79c:	e010                	sd	a2,0(s0)
 79e:	e414                	sd	a3,8(s0)
 7a0:	e818                	sd	a4,16(s0)
 7a2:	ec1c                	sd	a5,24(s0)
 7a4:	03043023          	sd	a6,32(s0)
 7a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b0:	8622                	mv	a2,s0
 7b2:	d3fff0ef          	jal	4f0 <vprintf>
}
 7b6:	60e2                	ld	ra,24(sp)
 7b8:	6442                	ld	s0,16(sp)
 7ba:	6161                	addi	sp,sp,80
 7bc:	8082                	ret

00000000000007be <printf>:

void
printf(const char *fmt, ...)
{
 7be:	711d                	addi	sp,sp,-96
 7c0:	ec06                	sd	ra,24(sp)
 7c2:	e822                	sd	s0,16(sp)
 7c4:	1000                	addi	s0,sp,32
 7c6:	e40c                	sd	a1,8(s0)
 7c8:	e810                	sd	a2,16(s0)
 7ca:	ec14                	sd	a3,24(s0)
 7cc:	f018                	sd	a4,32(s0)
 7ce:	f41c                	sd	a5,40(s0)
 7d0:	03043823          	sd	a6,48(s0)
 7d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d8:	00840613          	addi	a2,s0,8
 7dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e0:	85aa                	mv	a1,a0
 7e2:	4505                	li	a0,1
 7e4:	d0dff0ef          	jal	4f0 <vprintf>
}
 7e8:	60e2                	ld	ra,24(sp)
 7ea:	6442                	ld	s0,16(sp)
 7ec:	6125                	addi	sp,sp,96
 7ee:	8082                	ret

00000000000007f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f0:	1141                	addi	sp,sp,-16
 7f2:	e422                	sd	s0,8(sp)
 7f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	00001797          	auipc	a5,0x1
 7fe:	8067b783          	ld	a5,-2042(a5) # 1000 <freep>
 802:	a02d                	j	82c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 804:	4618                	lw	a4,8(a2)
 806:	9f2d                	addw	a4,a4,a1
 808:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	6398                	ld	a4,0(a5)
 80e:	6310                	ld	a2,0(a4)
 810:	a83d                	j	84e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 812:	ff852703          	lw	a4,-8(a0)
 816:	9f31                	addw	a4,a4,a2
 818:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 81a:	ff053683          	ld	a3,-16(a0)
 81e:	a091                	j	862 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	6398                	ld	a4,0(a5)
 822:	00e7e463          	bltu	a5,a4,82a <free+0x3a>
 826:	00e6ea63          	bltu	a3,a4,83a <free+0x4a>
{
 82a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	fed7fae3          	bgeu	a5,a3,820 <free+0x30>
 830:	6398                	ld	a4,0(a5)
 832:	00e6e463          	bltu	a3,a4,83a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	fee7eae3          	bltu	a5,a4,82a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 83a:	ff852583          	lw	a1,-8(a0)
 83e:	6390                	ld	a2,0(a5)
 840:	02059813          	slli	a6,a1,0x20
 844:	01c85713          	srli	a4,a6,0x1c
 848:	9736                	add	a4,a4,a3
 84a:	fae60de3          	beq	a2,a4,804 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 852:	4790                	lw	a2,8(a5)
 854:	02061593          	slli	a1,a2,0x20
 858:	01c5d713          	srli	a4,a1,0x1c
 85c:	973e                	add	a4,a4,a5
 85e:	fae68ae3          	beq	a3,a4,812 <free+0x22>
    p->s.ptr = bp->s.ptr;
 862:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 864:	00000717          	auipc	a4,0x0
 868:	78f73e23          	sd	a5,1948(a4) # 1000 <freep>
}
 86c:	6422                	ld	s0,8(sp)
 86e:	0141                	addi	sp,sp,16
 870:	8082                	ret

0000000000000872 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 872:	7139                	addi	sp,sp,-64
 874:	fc06                	sd	ra,56(sp)
 876:	f822                	sd	s0,48(sp)
 878:	f426                	sd	s1,40(sp)
 87a:	ec4e                	sd	s3,24(sp)
 87c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87e:	02051493          	slli	s1,a0,0x20
 882:	9081                	srli	s1,s1,0x20
 884:	04bd                	addi	s1,s1,15
 886:	8091                	srli	s1,s1,0x4
 888:	0014899b          	addiw	s3,s1,1
 88c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 88e:	00000517          	auipc	a0,0x0
 892:	77253503          	ld	a0,1906(a0) # 1000 <freep>
 896:	c915                	beqz	a0,8ca <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89a:	4798                	lw	a4,8(a5)
 89c:	08977a63          	bgeu	a4,s1,930 <malloc+0xbe>
 8a0:	f04a                	sd	s2,32(sp)
 8a2:	e852                	sd	s4,16(sp)
 8a4:	e456                	sd	s5,8(sp)
 8a6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a8:	8a4e                	mv	s4,s3
 8aa:	0009871b          	sext.w	a4,s3
 8ae:	6685                	lui	a3,0x1
 8b0:	00d77363          	bgeu	a4,a3,8b6 <malloc+0x44>
 8b4:	6a05                	lui	s4,0x1
 8b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8be:	00000917          	auipc	s2,0x0
 8c2:	74290913          	addi	s2,s2,1858 # 1000 <freep>
  if(p == SBRK_ERROR)
 8c6:	5afd                	li	s5,-1
 8c8:	a081                	j	908 <malloc+0x96>
 8ca:	f04a                	sd	s2,32(sp)
 8cc:	e852                	sd	s4,16(sp)
 8ce:	e456                	sd	s5,8(sp)
 8d0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d2:	00000797          	auipc	a5,0x0
 8d6:	73e78793          	addi	a5,a5,1854 # 1010 <base>
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73323          	sd	a5,1830(a4) # 1000 <freep>
 8e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e8:	b7c1                	j	8a8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	e118                	sd	a4,0(a0)
 8ee:	a8a9                	j	948 <malloc+0xd6>
  hp->s.size = nu;
 8f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f4:	0541                	addi	a0,a0,16
 8f6:	efbff0ef          	jal	7f0 <free>
  return freep;
 8fa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8fe:	c12d                	beqz	a0,960 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 900:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 902:	4798                	lw	a4,8(a5)
 904:	02977263          	bgeu	a4,s1,928 <malloc+0xb6>
    if(p == freep)
 908:	00093703          	ld	a4,0(s2)
 90c:	853e                	mv	a0,a5
 90e:	fef719e3          	bne	a4,a5,900 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 912:	8552                	mv	a0,s4
 914:	a27ff0ef          	jal	33a <sbrk>
  if(p == SBRK_ERROR)
 918:	fd551ce3          	bne	a0,s5,8f0 <malloc+0x7e>
        return 0;
 91c:	4501                	li	a0,0
 91e:	7902                	ld	s2,32(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
 926:	a03d                	j	954 <malloc+0xe2>
 928:	7902                	ld	s2,32(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 930:	fae48de3          	beq	s1,a4,8ea <malloc+0x78>
        p->s.size -= nunits;
 934:	4137073b          	subw	a4,a4,s3
 938:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93a:	02071693          	slli	a3,a4,0x20
 93e:	01c6d713          	srli	a4,a3,0x1c
 942:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 944:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 948:	00000717          	auipc	a4,0x0
 94c:	6aa73c23          	sd	a0,1720(a4) # 1000 <freep>
      return (void*)(p + 1);
 950:	01078513          	addi	a0,a5,16
  }
}
 954:	70e2                	ld	ra,56(sp)
 956:	7442                	ld	s0,48(sp)
 958:	74a2                	ld	s1,40(sp)
 95a:	69e2                	ld	s3,24(sp)
 95c:	6121                	addi	sp,sp,64
 95e:	8082                	ret
 960:	7902                	ld	s2,32(sp)
 962:	6a42                	ld	s4,16(sp)
 964:	6aa2                	ld	s5,8(sp)
 966:	6b02                	ld	s6,0(sp)
 968:	b7f5                	j	954 <malloc+0xe2>
