
user/_energy_test:     file format elf64-littleriscv


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
   8:	0080                	addi	s0,sp,64
  struct energy_info info;
  int pid = getpid();
   a:	43a000ef          	jal	444 <getpid>
   e:	84aa                	mv	s1,a0
  
  printf("Energy Scheduling Test\n");
  10:	00001517          	auipc	a0,0x1
  14:	9d050513          	addi	a0,a0,-1584 # 9e0 <malloc+0xf6>
  18:	01b000ef          	jal	832 <printf>
  printf("=======================\n\n");
  1c:	00001517          	auipc	a0,0x1
  20:	9dc50513          	addi	a0,a0,-1572 # 9f8 <malloc+0x10e>
  24:	00f000ef          	jal	832 <printf>
  
  printf("Main process PID: %d\n", pid);
  28:	85a6                	mv	a1,s1
  2a:	00001517          	auipc	a0,0x1
  2e:	9ee50513          	addi	a0,a0,-1554 # a18 <malloc+0x12e>
  32:	001000ef          	jal	832 <printf>
  
  // Get initial energy info
  if(getenergy(&info) == 0) {
  36:	fc840513          	addi	a0,s0,-56
  3a:	432000ef          	jal	46c <getenergy>
  3e:	e941                	bnez	a0,ce <main+0xce>
    printf("Initial Energy Status:\n");
  40:	00001517          	auipc	a0,0x1
  44:	9f050513          	addi	a0,a0,-1552 # a30 <malloc+0x146>
  48:	7ea000ef          	jal	832 <printf>
    printf("  PID: %d\n", (int)info.pid);
  4c:	fd842583          	lw	a1,-40(s0)
  50:	00001517          	auipc	a0,0x1
  54:	9f850513          	addi	a0,a0,-1544 # a48 <malloc+0x15e>
  58:	7da000ef          	jal	832 <printf>
    printf("  Energy Budget: %d\n", (int)info.energy_budget);
  5c:	fc842583          	lw	a1,-56(s0)
  60:	00001517          	auipc	a0,0x1
  64:	9f850513          	addi	a0,a0,-1544 # a58 <malloc+0x16e>
  68:	7ca000ef          	jal	832 <printf>
    printf("  Energy Consumed: %d\n", (int)info.energy_consumed);
  6c:	fd042583          	lw	a1,-48(s0)
  70:	00001517          	auipc	a0,0x1
  74:	a0050513          	addi	a0,a0,-1536 # a70 <malloc+0x186>
  78:	7ba000ef          	jal	832 <printf>
  } else {
    printf("Error getting energy info\n");
  }
  
  printf("\nStarting test: CPU-intensive workload...\n");
  7c:	00001517          	auipc	a0,0x1
  80:	a2c50513          	addi	a0,a0,-1492 # aa8 <malloc+0x1be>
  84:	7ae000ef          	jal	832 <printf>
  
  // Perform some CPU-intensive work
  volatile int sum = 0;
  88:	fc042223          	sw	zero,-60(s0)
  for(int i = 0; i < 1000000; i++) {
  8c:	4781                	li	a5,0
  8e:	000f46b7          	lui	a3,0xf4
  92:	24068693          	addi	a3,a3,576 # f4240 <base+0xf3230>
    sum += i;
  96:	fc442703          	lw	a4,-60(s0)
  9a:	9f3d                	addw	a4,a4,a5
  9c:	fce42223          	sw	a4,-60(s0)
  for(int i = 0; i < 1000000; i++) {
  a0:	2785                	addiw	a5,a5,1
  a2:	fed79ae3          	bne	a5,a3,96 <main+0x96>
  }
  
  printf("Work completed. Final energy status:\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	a3250513          	addi	a0,a0,-1486 # ad8 <malloc+0x1ee>
  ae:	784000ef          	jal	832 <printf>
  if(getenergy(&info) == 0) {
  b2:	fc840513          	addi	a0,s0,-56
  b6:	3b6000ef          	jal	46c <getenergy>
  ba:	c10d                	beqz	a0,dc <main+0xdc>
    printf("  PID: %d\n", (int)info.pid);
    printf("  Energy Budget: %d\n", (int)info.energy_budget);
    printf("  Energy Consumed: %d\n", (int)info.energy_consumed);
  }
  
  printf("\nEnergy test completed!\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	a4450513          	addi	a0,a0,-1468 # b00 <malloc+0x216>
  c4:	76e000ef          	jal	832 <printf>
  
  exit(0);
  c8:	4501                	li	a0,0
  ca:	2fa000ef          	jal	3c4 <exit>
    printf("Error getting energy info\n");
  ce:	00001517          	auipc	a0,0x1
  d2:	9ba50513          	addi	a0,a0,-1606 # a88 <malloc+0x19e>
  d6:	75c000ef          	jal	832 <printf>
  da:	b74d                	j	7c <main+0x7c>
    printf("  PID: %d\n", (int)info.pid);
  dc:	fd842583          	lw	a1,-40(s0)
  e0:	00001517          	auipc	a0,0x1
  e4:	96850513          	addi	a0,a0,-1688 # a48 <malloc+0x15e>
  e8:	74a000ef          	jal	832 <printf>
    printf("  Energy Budget: %d\n", (int)info.energy_budget);
  ec:	fc842583          	lw	a1,-56(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	96850513          	addi	a0,a0,-1688 # a58 <malloc+0x16e>
  f8:	73a000ef          	jal	832 <printf>
    printf("  Energy Consumed: %d\n", (int)info.energy_consumed);
  fc:	fd042583          	lw	a1,-48(s0)
 100:	00001517          	auipc	a0,0x1
 104:	97050513          	addi	a0,a0,-1680 # a70 <malloc+0x186>
 108:	72a000ef          	jal	832 <printf>
 10c:	bf45                	j	bc <main+0xbc>

000000000000010e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e406                	sd	ra,8(sp)
 112:	e022                	sd	s0,0(sp)
 114:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 116:	eebff0ef          	jal	0 <main>
  exit(r);
 11a:	2aa000ef          	jal	3c4 <exit>

000000000000011e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 126:	87aa                	mv	a5,a0
 128:	0585                	addi	a1,a1,1
 12a:	0785                	addi	a5,a5,1
 12c:	fff5c703          	lbu	a4,-1(a1)
 130:	fee78fa3          	sb	a4,-1(a5)
 134:	fb75                	bnez	a4,128 <strcpy+0xa>
    ;
  return os;
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e406                	sd	ra,8(sp)
 142:	e022                	sd	s0,0(sp)
 144:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cb91                	beqz	a5,15e <strcmp+0x20>
 14c:	0005c703          	lbu	a4,0(a1)
 150:	00f71763          	bne	a4,a5,15e <strcmp+0x20>
    p++, q++;
 154:	0505                	addi	a0,a0,1
 156:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 158:	00054783          	lbu	a5,0(a0)
 15c:	fbe5                	bnez	a5,14c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 15e:	0005c503          	lbu	a0,0(a1)
}
 162:	40a7853b          	subw	a0,a5,a0
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint
strlen(const char *s)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 176:	00054783          	lbu	a5,0(a0)
 17a:	cf91                	beqz	a5,196 <strlen+0x28>
 17c:	00150793          	addi	a5,a0,1
 180:	86be                	mv	a3,a5
 182:	0785                	addi	a5,a5,1
 184:	fff7c703          	lbu	a4,-1(a5)
 188:	ff65                	bnez	a4,180 <strlen+0x12>
 18a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 18e:	60a2                	ld	ra,8(sp)
 190:	6402                	ld	s0,0(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret
  for(n = 0; s[n]; n++)
 196:	4501                	li	a0,0
 198:	bfdd                	j	18e <strlen+0x20>

000000000000019a <memset>:

void*
memset(void *dst, int c, uint n)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e406                	sd	ra,8(sp)
 19e:	e022                	sd	s0,0(sp)
 1a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1a2:	ca19                	beqz	a2,1b8 <memset+0x1e>
 1a4:	87aa                	mv	a5,a0
 1a6:	1602                	slli	a2,a2,0x20
 1a8:	9201                	srli	a2,a2,0x20
 1aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1b2:	0785                	addi	a5,a5,1
 1b4:	fee79de3          	bne	a5,a4,1ae <memset+0x14>
  }
  return dst;
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e406                	sd	ra,8(sp)
 1c4:	e022                	sd	s0,0(sp)
 1c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	cf81                	beqz	a5,1e4 <strchr+0x24>
    if(*s == c)
 1ce:	00f58763          	beq	a1,a5,1dc <strchr+0x1c>
  for(; *s; s++)
 1d2:	0505                	addi	a0,a0,1
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	fbfd                	bnez	a5,1ce <strchr+0xe>
      return (char*)s;
  return 0;
 1da:	4501                	li	a0,0
}
 1dc:	60a2                	ld	ra,8(sp)
 1de:	6402                	ld	s0,0(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  return 0;
 1e4:	4501                	li	a0,0
 1e6:	bfdd                	j	1dc <strchr+0x1c>

00000000000001e8 <gets>:

char*
gets(char *buf, int max)
{
 1e8:	711d                	addi	sp,sp,-96
 1ea:	ec86                	sd	ra,88(sp)
 1ec:	e8a2                	sd	s0,80(sp)
 1ee:	e4a6                	sd	s1,72(sp)
 1f0:	e0ca                	sd	s2,64(sp)
 1f2:	fc4e                	sd	s3,56(sp)
 1f4:	f852                	sd	s4,48(sp)
 1f6:	f456                	sd	s5,40(sp)
 1f8:	f05a                	sd	s6,32(sp)
 1fa:	ec5e                	sd	s7,24(sp)
 1fc:	e862                	sd	s8,16(sp)
 1fe:	1080                	addi	s0,sp,96
 200:	8baa                	mv	s7,a0
 202:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 204:	892a                	mv	s2,a0
 206:	4481                	li	s1,0
    cc = read(0, &c, 1);
 208:	faf40b13          	addi	s6,s0,-81
 20c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 20e:	8c26                	mv	s8,s1
 210:	0014899b          	addiw	s3,s1,1
 214:	84ce                	mv	s1,s3
 216:	0349d463          	bge	s3,s4,23e <gets+0x56>
    cc = read(0, &c, 1);
 21a:	8656                	mv	a2,s5
 21c:	85da                	mv	a1,s6
 21e:	4501                	li	a0,0
 220:	1bc000ef          	jal	3dc <read>
    if(cc < 1)
 224:	00a05d63          	blez	a0,23e <gets+0x56>
      break;
    buf[i++] = c;
 228:	faf44783          	lbu	a5,-81(s0)
 22c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 230:	0905                	addi	s2,s2,1
 232:	ff678713          	addi	a4,a5,-10
 236:	c319                	beqz	a4,23c <gets+0x54>
 238:	17cd                	addi	a5,a5,-13
 23a:	fbf1                	bnez	a5,20e <gets+0x26>
    buf[i++] = c;
 23c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 23e:	9c5e                	add	s8,s8,s7
 240:	000c0023          	sb	zero,0(s8)
  return buf;
}
 244:	855e                	mv	a0,s7
 246:	60e6                	ld	ra,88(sp)
 248:	6446                	ld	s0,80(sp)
 24a:	64a6                	ld	s1,72(sp)
 24c:	6906                	ld	s2,64(sp)
 24e:	79e2                	ld	s3,56(sp)
 250:	7a42                	ld	s4,48(sp)
 252:	7aa2                	ld	s5,40(sp)
 254:	7b02                	ld	s6,32(sp)
 256:	6be2                	ld	s7,24(sp)
 258:	6c42                	ld	s8,16(sp)
 25a:	6125                	addi	sp,sp,96
 25c:	8082                	ret

000000000000025e <stat>:

int
stat(const char *n, struct stat *st)
{
 25e:	1101                	addi	sp,sp,-32
 260:	ec06                	sd	ra,24(sp)
 262:	e822                	sd	s0,16(sp)
 264:	e04a                	sd	s2,0(sp)
 266:	1000                	addi	s0,sp,32
 268:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26a:	4581                	li	a1,0
 26c:	198000ef          	jal	404 <open>
  if(fd < 0)
 270:	02054263          	bltz	a0,294 <stat+0x36>
 274:	e426                	sd	s1,8(sp)
 276:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 278:	85ca                	mv	a1,s2
 27a:	1a2000ef          	jal	41c <fstat>
 27e:	892a                	mv	s2,a0
  close(fd);
 280:	8526                	mv	a0,s1
 282:	16a000ef          	jal	3ec <close>
  return r;
 286:	64a2                	ld	s1,8(sp)
}
 288:	854a                	mv	a0,s2
 28a:	60e2                	ld	ra,24(sp)
 28c:	6442                	ld	s0,16(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	addi	sp,sp,32
 292:	8082                	ret
    return -1;
 294:	57fd                	li	a5,-1
 296:	893e                	mv	s2,a5
 298:	bfc5                	j	288 <stat+0x2a>

000000000000029a <atoi>:

int
atoi(const char *s)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a2:	00054683          	lbu	a3,0(a0)
 2a6:	fd06879b          	addiw	a5,a3,-48
 2aa:	0ff7f793          	zext.b	a5,a5
 2ae:	4625                	li	a2,9
 2b0:	02f66963          	bltu	a2,a5,2e2 <atoi+0x48>
 2b4:	872a                	mv	a4,a0
  n = 0;
 2b6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b8:	0705                	addi	a4,a4,1
 2ba:	0025179b          	slliw	a5,a0,0x2
 2be:	9fa9                	addw	a5,a5,a0
 2c0:	0017979b          	slliw	a5,a5,0x1
 2c4:	9fb5                	addw	a5,a5,a3
 2c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ca:	00074683          	lbu	a3,0(a4)
 2ce:	fd06879b          	addiw	a5,a3,-48
 2d2:	0ff7f793          	zext.b	a5,a5
 2d6:	fef671e3          	bgeu	a2,a5,2b8 <atoi+0x1e>
  return n;
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  n = 0;
 2e2:	4501                	li	a0,0
 2e4:	bfdd                	j	2da <atoi+0x40>

00000000000002e6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ee:	02b57563          	bgeu	a0,a1,318 <memmove+0x32>
    while(n-- > 0)
 2f2:	00c05f63          	blez	a2,310 <memmove+0x2a>
 2f6:	1602                	slli	a2,a2,0x20
 2f8:	9201                	srli	a2,a2,0x20
 2fa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2fe:	872a                	mv	a4,a0
      *dst++ = *src++;
 300:	0585                	addi	a1,a1,1
 302:	0705                	addi	a4,a4,1
 304:	fff5c683          	lbu	a3,-1(a1)
 308:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 30c:	fee79ae3          	bne	a5,a4,300 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
    while(n-- > 0)
 318:	fec05ce3          	blez	a2,310 <memmove+0x2a>
    dst += n;
 31c:	00c50733          	add	a4,a0,a2
    src += n;
 320:	95b2                	add	a1,a1,a2
 322:	fff6079b          	addiw	a5,a2,-1
 326:	1782                	slli	a5,a5,0x20
 328:	9381                	srli	a5,a5,0x20
 32a:	fff7c793          	not	a5,a5
 32e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 330:	15fd                	addi	a1,a1,-1
 332:	177d                	addi	a4,a4,-1
 334:	0005c683          	lbu	a3,0(a1)
 338:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33c:	fef71ae3          	bne	a4,a5,330 <memmove+0x4a>
 340:	bfc1                	j	310 <memmove+0x2a>

0000000000000342 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34a:	c61d                	beqz	a2,378 <memcmp+0x36>
 34c:	1602                	slli	a2,a2,0x20
 34e:	9201                	srli	a2,a2,0x20
 350:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 354:	00054783          	lbu	a5,0(a0)
 358:	0005c703          	lbu	a4,0(a1)
 35c:	00e79863          	bne	a5,a4,36c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 360:	0505                	addi	a0,a0,1
    p2++;
 362:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 364:	fed518e3          	bne	a0,a3,354 <memcmp+0x12>
  }
  return 0;
 368:	4501                	li	a0,0
 36a:	a019                	j	370 <memcmp+0x2e>
      return *p1 - *p2;
 36c:	40e7853b          	subw	a0,a5,a4
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfdd                	j	370 <memcmp+0x2e>

000000000000037c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 384:	f63ff0ef          	jal	2e6 <memmove>
}
 388:	60a2                	ld	ra,8(sp)
 38a:	6402                	ld	s0,0(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret

0000000000000390 <sbrk>:

char *
sbrk(int n) {
 390:	1141                	addi	sp,sp,-16
 392:	e406                	sd	ra,8(sp)
 394:	e022                	sd	s0,0(sp)
 396:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 398:	4585                	li	a1,1
 39a:	0b2000ef          	jal	44c <sys_sbrk>
}
 39e:	60a2                	ld	ra,8(sp)
 3a0:	6402                	ld	s0,0(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret

00000000000003a6 <sbrklazy>:

char *
sbrklazy(int n) {
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e406                	sd	ra,8(sp)
 3aa:	e022                	sd	s0,0(sp)
 3ac:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3ae:	4589                	li	a1,2
 3b0:	09c000ef          	jal	44c <sys_sbrk>
}
 3b4:	60a2                	ld	ra,8(sp)
 3b6:	6402                	ld	s0,0(sp)
 3b8:	0141                	addi	sp,sp,16
 3ba:	8082                	ret

00000000000003bc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3bc:	4885                	li	a7,1
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c4:	4889                	li	a7,2
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3cc:	488d                	li	a7,3
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d4:	4891                	li	a7,4
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <read>:
.global read
read:
 li a7, SYS_read
 3dc:	4895                	li	a7,5
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <write>:
.global write
write:
 li a7, SYS_write
 3e4:	48c1                	li	a7,16
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <close>:
.global close
close:
 li a7, SYS_close
 3ec:	48d5                	li	a7,21
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f4:	4899                	li	a7,6
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fc:	489d                	li	a7,7
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <open>:
.global open
open:
 li a7, SYS_open
 404:	48bd                	li	a7,15
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40c:	48c5                	li	a7,17
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 414:	48c9                	li	a7,18
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41c:	48a1                	li	a7,8
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <link>:
.global link
link:
 li a7, SYS_link
 424:	48cd                	li	a7,19
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42c:	48d1                	li	a7,20
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 434:	48a5                	li	a7,9
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <dup>:
.global dup
dup:
 li a7, SYS_dup
 43c:	48a9                	li	a7,10
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 444:	48ad                	li	a7,11
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 44c:	48b1                	li	a7,12
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <pause>:
.global pause
pause:
 li a7, SYS_pause
 454:	48b5                	li	a7,13
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45c:	48b9                	li	a7,14
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <kps>:
.global kps
kps:
 li a7, SYS_kps
 464:	48d9                	li	a7,22
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 46c:	48dd                	li	a7,23
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 474:	48e1                	li	a7,24
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 47c:	48e5                	li	a7,25
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 484:	48e9                	li	a7,26
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48c:	1101                	addi	sp,sp,-32
 48e:	ec06                	sd	ra,24(sp)
 490:	e822                	sd	s0,16(sp)
 492:	1000                	addi	s0,sp,32
 494:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 498:	4605                	li	a2,1
 49a:	fef40593          	addi	a1,s0,-17
 49e:	f47ff0ef          	jal	3e4 <write>
}
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	6105                	addi	sp,sp,32
 4a8:	8082                	ret

00000000000004aa <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4aa:	715d                	addi	sp,sp,-80
 4ac:	e486                	sd	ra,72(sp)
 4ae:	e0a2                	sd	s0,64(sp)
 4b0:	f84a                	sd	s2,48(sp)
 4b2:	f44e                	sd	s3,40(sp)
 4b4:	0880                	addi	s0,sp,80
 4b6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4b8:	c6d1                	beqz	a3,544 <printint+0x9a>
 4ba:	0805d563          	bgez	a1,544 <printint+0x9a>
    neg = 1;
    x = -xx;
 4be:	40b005b3          	neg	a1,a1
    neg = 1;
 4c2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4c4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4c8:	86ce                	mv	a3,s3
  i = 0;
 4ca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4cc:	00000817          	auipc	a6,0x0
 4d0:	65c80813          	addi	a6,a6,1628 # b28 <digits>
 4d4:	88ba                	mv	a7,a4
 4d6:	0017051b          	addiw	a0,a4,1
 4da:	872a                	mv	a4,a0
 4dc:	02c5f7b3          	remu	a5,a1,a2
 4e0:	97c2                	add	a5,a5,a6
 4e2:	0007c783          	lbu	a5,0(a5)
 4e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ea:	87ae                	mv	a5,a1
 4ec:	02c5d5b3          	divu	a1,a1,a2
 4f0:	0685                	addi	a3,a3,1
 4f2:	fec7f1e3          	bgeu	a5,a2,4d4 <printint+0x2a>
  if(neg)
 4f6:	00030c63          	beqz	t1,50e <printint+0x64>
    buf[i++] = '-';
 4fa:	fd050793          	addi	a5,a0,-48
 4fe:	00878533          	add	a0,a5,s0
 502:	02d00793          	li	a5,45
 506:	fef50423          	sb	a5,-24(a0)
 50a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 50e:	02e05563          	blez	a4,538 <printint+0x8e>
 512:	fc26                	sd	s1,56(sp)
 514:	377d                	addiw	a4,a4,-1
 516:	00e984b3          	add	s1,s3,a4
 51a:	19fd                	addi	s3,s3,-1
 51c:	99ba                	add	s3,s3,a4
 51e:	1702                	slli	a4,a4,0x20
 520:	9301                	srli	a4,a4,0x20
 522:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 526:	0004c583          	lbu	a1,0(s1)
 52a:	854a                	mv	a0,s2
 52c:	f61ff0ef          	jal	48c <putc>
  while(--i >= 0)
 530:	14fd                	addi	s1,s1,-1
 532:	ff349ae3          	bne	s1,s3,526 <printint+0x7c>
 536:	74e2                	ld	s1,56(sp)
}
 538:	60a6                	ld	ra,72(sp)
 53a:	6406                	ld	s0,64(sp)
 53c:	7942                	ld	s2,48(sp)
 53e:	79a2                	ld	s3,40(sp)
 540:	6161                	addi	sp,sp,80
 542:	8082                	ret
  neg = 0;
 544:	4301                	li	t1,0
 546:	bfbd                	j	4c4 <printint+0x1a>

0000000000000548 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 548:	711d                	addi	sp,sp,-96
 54a:	ec86                	sd	ra,88(sp)
 54c:	e8a2                	sd	s0,80(sp)
 54e:	e4a6                	sd	s1,72(sp)
 550:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 552:	0005c483          	lbu	s1,0(a1)
 556:	22048363          	beqz	s1,77c <vprintf+0x234>
 55a:	e0ca                	sd	s2,64(sp)
 55c:	fc4e                	sd	s3,56(sp)
 55e:	f852                	sd	s4,48(sp)
 560:	f456                	sd	s5,40(sp)
 562:	f05a                	sd	s6,32(sp)
 564:	ec5e                	sd	s7,24(sp)
 566:	e862                	sd	s8,16(sp)
 568:	8b2a                	mv	s6,a0
 56a:	8a2e                	mv	s4,a1
 56c:	8bb2                	mv	s7,a2
  state = 0;
 56e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 570:	4901                	li	s2,0
 572:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 574:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 578:	06400c13          	li	s8,100
 57c:	a00d                	j	59e <vprintf+0x56>
        putc(fd, c0);
 57e:	85a6                	mv	a1,s1
 580:	855a                	mv	a0,s6
 582:	f0bff0ef          	jal	48c <putc>
 586:	a019                	j	58c <vprintf+0x44>
    } else if(state == '%'){
 588:	03598363          	beq	s3,s5,5ae <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 58c:	0019079b          	addiw	a5,s2,1
 590:	893e                	mv	s2,a5
 592:	873e                	mv	a4,a5
 594:	97d2                	add	a5,a5,s4
 596:	0007c483          	lbu	s1,0(a5)
 59a:	1c048a63          	beqz	s1,76e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 59e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5a2:	fe0993e3          	bnez	s3,588 <vprintf+0x40>
      if(c0 == '%'){
 5a6:	fd579ce3          	bne	a5,s5,57e <vprintf+0x36>
        state = '%';
 5aa:	89be                	mv	s3,a5
 5ac:	b7c5                	j	58c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5ae:	00ea06b3          	add	a3,s4,a4
 5b2:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5b6:	1c060863          	beqz	a2,786 <vprintf+0x23e>
      if(c0 == 'd'){
 5ba:	03878763          	beq	a5,s8,5e8 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5be:	f9478693          	addi	a3,a5,-108
 5c2:	0016b693          	seqz	a3,a3
 5c6:	f9c60593          	addi	a1,a2,-100
 5ca:	e99d                	bnez	a1,600 <vprintf+0xb8>
 5cc:	ca95                	beqz	a3,600 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4685                	li	a3,1
 5d4:	4629                	li	a2,10
 5d6:	000bb583          	ld	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	ecfff0ef          	jal	4aa <printint>
        i += 1;
 5e0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e2:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b75d                	j	58c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4685                	li	a3,1
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	eb5ff0ef          	jal	4aa <printint>
 5fa:	8ba6                	mv	s7,s1
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b779                	j	58c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 600:	9752                	add	a4,a4,s4
 602:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 606:	f9460713          	addi	a4,a2,-108
 60a:	00173713          	seqz	a4,a4
 60e:	8f75                	and	a4,a4,a3
 610:	f9c58513          	addi	a0,a1,-100
 614:	18051363          	bnez	a0,79a <vprintf+0x252>
 618:	18070163          	beqz	a4,79a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 61c:	008b8493          	addi	s1,s7,8
 620:	4685                	li	a3,1
 622:	4629                	li	a2,10
 624:	000bb583          	ld	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	e81ff0ef          	jal	4aa <printint>
        i += 2;
 62e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	8ba6                	mv	s7,s1
      state = 0;
 632:	4981                	li	s3,0
        i += 2;
 634:	bfa1                	j	58c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 636:	008b8493          	addi	s1,s7,8
 63a:	4681                	li	a3,0
 63c:	4629                	li	a2,10
 63e:	000be583          	lwu	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e67ff0ef          	jal	4aa <printint>
 648:	8ba6                	mv	s7,s1
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b781                	j	58c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	008b8493          	addi	s1,s7,8
 652:	4681                	li	a3,0
 654:	4629                	li	a2,10
 656:	000bb583          	ld	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	e4fff0ef          	jal	4aa <printint>
        i += 1;
 660:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	8ba6                	mv	s7,s1
      state = 0;
 664:	4981                	li	s3,0
 666:	b71d                	j	58c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 668:	008b8493          	addi	s1,s7,8
 66c:	4681                	li	a3,0
 66e:	4629                	li	a2,10
 670:	000bb583          	ld	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e35ff0ef          	jal	4aa <printint>
        i += 2;
 67a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	8ba6                	mv	s7,s1
      state = 0;
 67e:	4981                	li	s3,0
        i += 2;
 680:	b731                	j	58c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 682:	008b8493          	addi	s1,s7,8
 686:	4681                	li	a3,0
 688:	4641                	li	a2,16
 68a:	000be583          	lwu	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e1bff0ef          	jal	4aa <printint>
 694:	8ba6                	mv	s7,s1
      state = 0;
 696:	4981                	li	s3,0
 698:	bdd5                	j	58c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69a:	008b8493          	addi	s1,s7,8
 69e:	4681                	li	a3,0
 6a0:	4641                	li	a2,16
 6a2:	000bb583          	ld	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	e03ff0ef          	jal	4aa <printint>
        i += 1;
 6ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	8ba6                	mv	s7,s1
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bde9                	j	58c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b4:	008b8493          	addi	s1,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4641                	li	a2,16
 6bc:	000bb583          	ld	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	de9ff0ef          	jal	4aa <printint>
        i += 2;
 6c6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	8ba6                	mv	s7,s1
      state = 0;
 6ca:	4981                	li	s3,0
        i += 2;
 6cc:	b5c1                	j	58c <vprintf+0x44>
 6ce:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6d0:	008b8793          	addi	a5,s7,8
 6d4:	8cbe                	mv	s9,a5
 6d6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6da:	03000593          	li	a1,48
 6de:	855a                	mv	a0,s6
 6e0:	dadff0ef          	jal	48c <putc>
  putc(fd, 'x');
 6e4:	07800593          	li	a1,120
 6e8:	855a                	mv	a0,s6
 6ea:	da3ff0ef          	jal	48c <putc>
 6ee:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f0:	00000b97          	auipc	s7,0x0
 6f4:	438b8b93          	addi	s7,s7,1080 # b28 <digits>
 6f8:	03c9d793          	srli	a5,s3,0x3c
 6fc:	97de                	add	a5,a5,s7
 6fe:	0007c583          	lbu	a1,0(a5)
 702:	855a                	mv	a0,s6
 704:	d89ff0ef          	jal	48c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 708:	0992                	slli	s3,s3,0x4
 70a:	34fd                	addiw	s1,s1,-1
 70c:	f4f5                	bnez	s1,6f8 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 70e:	8be6                	mv	s7,s9
      state = 0;
 710:	4981                	li	s3,0
 712:	6ca2                	ld	s9,8(sp)
 714:	bda5                	j	58c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 716:	008b8493          	addi	s1,s7,8
 71a:	000bc583          	lbu	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	d6dff0ef          	jal	48c <putc>
 724:	8ba6                	mv	s7,s1
      state = 0;
 726:	4981                	li	s3,0
 728:	b595                	j	58c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 72a:	008b8993          	addi	s3,s7,8
 72e:	000bb483          	ld	s1,0(s7)
 732:	cc91                	beqz	s1,74e <vprintf+0x206>
        for(; *s; s++)
 734:	0004c583          	lbu	a1,0(s1)
 738:	c985                	beqz	a1,768 <vprintf+0x220>
          putc(fd, *s);
 73a:	855a                	mv	a0,s6
 73c:	d51ff0ef          	jal	48c <putc>
        for(; *s; s++)
 740:	0485                	addi	s1,s1,1
 742:	0004c583          	lbu	a1,0(s1)
 746:	f9f5                	bnez	a1,73a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 748:	8bce                	mv	s7,s3
      state = 0;
 74a:	4981                	li	s3,0
 74c:	b581                	j	58c <vprintf+0x44>
          s = "(null)";
 74e:	00000497          	auipc	s1,0x0
 752:	3d248493          	addi	s1,s1,978 # b20 <malloc+0x236>
        for(; *s; s++)
 756:	02800593          	li	a1,40
 75a:	b7c5                	j	73a <vprintf+0x1f2>
        putc(fd, '%');
 75c:	85be                	mv	a1,a5
 75e:	855a                	mv	a0,s6
 760:	d2dff0ef          	jal	48c <putc>
      state = 0;
 764:	4981                	li	s3,0
 766:	b51d                	j	58c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 768:	8bce                	mv	s7,s3
      state = 0;
 76a:	4981                	li	s3,0
 76c:	b505                	j	58c <vprintf+0x44>
 76e:	6906                	ld	s2,64(sp)
 770:	79e2                	ld	s3,56(sp)
 772:	7a42                	ld	s4,48(sp)
 774:	7aa2                	ld	s5,40(sp)
 776:	7b02                	ld	s6,32(sp)
 778:	6be2                	ld	s7,24(sp)
 77a:	6c42                	ld	s8,16(sp)
    }
  }
}
 77c:	60e6                	ld	ra,88(sp)
 77e:	6446                	ld	s0,80(sp)
 780:	64a6                	ld	s1,72(sp)
 782:	6125                	addi	sp,sp,96
 784:	8082                	ret
      if(c0 == 'd'){
 786:	06400713          	li	a4,100
 78a:	e4e78fe3          	beq	a5,a4,5e8 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 78e:	f9478693          	addi	a3,a5,-108
 792:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 796:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 798:	4701                	li	a4,0
      } else if(c0 == 'u'){
 79a:	07500513          	li	a0,117
 79e:	e8a78ce3          	beq	a5,a0,636 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7a2:	f8b60513          	addi	a0,a2,-117
 7a6:	e119                	bnez	a0,7ac <vprintf+0x264>
 7a8:	ea0693e3          	bnez	a3,64e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7ac:	f8b58513          	addi	a0,a1,-117
 7b0:	e119                	bnez	a0,7b6 <vprintf+0x26e>
 7b2:	ea071be3          	bnez	a4,668 <vprintf+0x120>
      } else if(c0 == 'x'){
 7b6:	07800513          	li	a0,120
 7ba:	eca784e3          	beq	a5,a0,682 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7be:	f8860613          	addi	a2,a2,-120
 7c2:	e219                	bnez	a2,7c8 <vprintf+0x280>
 7c4:	ec069be3          	bnez	a3,69a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7c8:	f8858593          	addi	a1,a1,-120
 7cc:	e199                	bnez	a1,7d2 <vprintf+0x28a>
 7ce:	ee0713e3          	bnez	a4,6b4 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7d2:	07000713          	li	a4,112
 7d6:	eee78ce3          	beq	a5,a4,6ce <vprintf+0x186>
      } else if(c0 == 'c'){
 7da:	06300713          	li	a4,99
 7de:	f2e78ce3          	beq	a5,a4,716 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7e2:	07300713          	li	a4,115
 7e6:	f4e782e3          	beq	a5,a4,72a <vprintf+0x1e2>
      } else if(c0 == '%'){
 7ea:	02500713          	li	a4,37
 7ee:	f6e787e3          	beq	a5,a4,75c <vprintf+0x214>
        putc(fd, '%');
 7f2:	02500593          	li	a1,37
 7f6:	855a                	mv	a0,s6
 7f8:	c95ff0ef          	jal	48c <putc>
        putc(fd, c0);
 7fc:	85a6                	mv	a1,s1
 7fe:	855a                	mv	a0,s6
 800:	c8dff0ef          	jal	48c <putc>
      state = 0;
 804:	4981                	li	s3,0
 806:	b359                	j	58c <vprintf+0x44>

0000000000000808 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 808:	715d                	addi	sp,sp,-80
 80a:	ec06                	sd	ra,24(sp)
 80c:	e822                	sd	s0,16(sp)
 80e:	1000                	addi	s0,sp,32
 810:	e010                	sd	a2,0(s0)
 812:	e414                	sd	a3,8(s0)
 814:	e818                	sd	a4,16(s0)
 816:	ec1c                	sd	a5,24(s0)
 818:	03043023          	sd	a6,32(s0)
 81c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	8622                	mv	a2,s0
 822:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 826:	d23ff0ef          	jal	548 <vprintf>
}
 82a:	60e2                	ld	ra,24(sp)
 82c:	6442                	ld	s0,16(sp)
 82e:	6161                	addi	sp,sp,80
 830:	8082                	ret

0000000000000832 <printf>:

void
printf(const char *fmt, ...)
{
 832:	711d                	addi	sp,sp,-96
 834:	ec06                	sd	ra,24(sp)
 836:	e822                	sd	s0,16(sp)
 838:	1000                	addi	s0,sp,32
 83a:	e40c                	sd	a1,8(s0)
 83c:	e810                	sd	a2,16(s0)
 83e:	ec14                	sd	a3,24(s0)
 840:	f018                	sd	a4,32(s0)
 842:	f41c                	sd	a5,40(s0)
 844:	03043823          	sd	a6,48(s0)
 848:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84c:	00840613          	addi	a2,s0,8
 850:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 854:	85aa                	mv	a1,a0
 856:	4505                	li	a0,1
 858:	cf1ff0ef          	jal	548 <vprintf>
}
 85c:	60e2                	ld	ra,24(sp)
 85e:	6442                	ld	s0,16(sp)
 860:	6125                	addi	sp,sp,96
 862:	8082                	ret

0000000000000864 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 864:	1141                	addi	sp,sp,-16
 866:	e406                	sd	ra,8(sp)
 868:	e022                	sd	s0,0(sp)
 86a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	00000797          	auipc	a5,0x0
 874:	7907b783          	ld	a5,1936(a5) # 1000 <freep>
 878:	a039                	j	886 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87a:	6398                	ld	a4,0(a5)
 87c:	00e7e463          	bltu	a5,a4,884 <free+0x20>
 880:	00e6ea63          	bltu	a3,a4,894 <free+0x30>
{
 884:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 886:	fed7fae3          	bgeu	a5,a3,87a <free+0x16>
 88a:	6398                	ld	a4,0(a5)
 88c:	00e6e463          	bltu	a3,a4,894 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	fee7eae3          	bltu	a5,a4,884 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 894:	ff852583          	lw	a1,-8(a0)
 898:	6390                	ld	a2,0(a5)
 89a:	02059813          	slli	a6,a1,0x20
 89e:	01c85713          	srli	a4,a6,0x1c
 8a2:	9736                	add	a4,a4,a3
 8a4:	02e60563          	beq	a2,a4,8ce <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8a8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8ac:	4790                	lw	a2,8(a5)
 8ae:	02061593          	slli	a1,a2,0x20
 8b2:	01c5d713          	srli	a4,a1,0x1c
 8b6:	973e                	add	a4,a4,a5
 8b8:	02e68263          	beq	a3,a4,8dc <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8be:	00000717          	auipc	a4,0x0
 8c2:	74f73123          	sd	a5,1858(a4) # 1000 <freep>
}
 8c6:	60a2                	ld	ra,8(sp)
 8c8:	6402                	ld	s0,0(sp)
 8ca:	0141                	addi	sp,sp,16
 8cc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8ce:	4618                	lw	a4,8(a2)
 8d0:	9f2d                	addw	a4,a4,a1
 8d2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d6:	6398                	ld	a4,0(a5)
 8d8:	6310                	ld	a2,0(a4)
 8da:	b7f9                	j	8a8 <free+0x44>
    p->s.size += bp->s.size;
 8dc:	ff852703          	lw	a4,-8(a0)
 8e0:	9f31                	addw	a4,a4,a2
 8e2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8e4:	ff053683          	ld	a3,-16(a0)
 8e8:	bfd1                	j	8bc <free+0x58>

00000000000008ea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ea:	7139                	addi	sp,sp,-64
 8ec:	fc06                	sd	ra,56(sp)
 8ee:	f822                	sd	s0,48(sp)
 8f0:	f04a                	sd	s2,32(sp)
 8f2:	ec4e                	sd	s3,24(sp)
 8f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f6:	02051993          	slli	s3,a0,0x20
 8fa:	0209d993          	srli	s3,s3,0x20
 8fe:	09bd                	addi	s3,s3,15
 900:	0049d993          	srli	s3,s3,0x4
 904:	2985                	addiw	s3,s3,1
 906:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 908:	00000517          	auipc	a0,0x0
 90c:	6f853503          	ld	a0,1784(a0) # 1000 <freep>
 910:	c905                	beqz	a0,940 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 912:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 914:	4798                	lw	a4,8(a5)
 916:	09377663          	bgeu	a4,s3,9a2 <malloc+0xb8>
 91a:	f426                	sd	s1,40(sp)
 91c:	e852                	sd	s4,16(sp)
 91e:	e456                	sd	s5,8(sp)
 920:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 922:	8a4e                	mv	s4,s3
 924:	6705                	lui	a4,0x1
 926:	00e9f363          	bgeu	s3,a4,92c <malloc+0x42>
 92a:	6a05                	lui	s4,0x1
 92c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 930:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 934:	00000497          	auipc	s1,0x0
 938:	6cc48493          	addi	s1,s1,1740 # 1000 <freep>
  if(p == SBRK_ERROR)
 93c:	5afd                	li	s5,-1
 93e:	a83d                	j	97c <malloc+0x92>
 940:	f426                	sd	s1,40(sp)
 942:	e852                	sd	s4,16(sp)
 944:	e456                	sd	s5,8(sp)
 946:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 948:	00000797          	auipc	a5,0x0
 94c:	6c878793          	addi	a5,a5,1736 # 1010 <base>
 950:	00000717          	auipc	a4,0x0
 954:	6af73823          	sd	a5,1712(a4) # 1000 <freep>
 958:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 95a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95e:	b7d1                	j	922 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	e118                	sd	a4,0(a0)
 964:	a899                	j	9ba <malloc+0xd0>
  hp->s.size = nu;
 966:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 96a:	0541                	addi	a0,a0,16
 96c:	ef9ff0ef          	jal	864 <free>
  return freep;
 970:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 972:	c125                	beqz	a0,9d2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 974:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 976:	4798                	lw	a4,8(a5)
 978:	03277163          	bgeu	a4,s2,99a <malloc+0xb0>
    if(p == freep)
 97c:	6098                	ld	a4,0(s1)
 97e:	853e                	mv	a0,a5
 980:	fef71ae3          	bne	a4,a5,974 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 984:	8552                	mv	a0,s4
 986:	a0bff0ef          	jal	390 <sbrk>
  if(p == SBRK_ERROR)
 98a:	fd551ee3          	bne	a0,s5,966 <malloc+0x7c>
        return 0;
 98e:	4501                	li	a0,0
 990:	74a2                	ld	s1,40(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
 998:	a03d                	j	9c6 <malloc+0xdc>
 99a:	74a2                	ld	s1,40(sp)
 99c:	6a42                	ld	s4,16(sp)
 99e:	6aa2                	ld	s5,8(sp)
 9a0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9a2:	fae90fe3          	beq	s2,a4,960 <malloc+0x76>
        p->s.size -= nunits;
 9a6:	4137073b          	subw	a4,a4,s3
 9aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ac:	02071693          	slli	a3,a4,0x20
 9b0:	01c6d713          	srli	a4,a3,0x1c
 9b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ba:	00000717          	auipc	a4,0x0
 9be:	64a73323          	sd	a0,1606(a4) # 1000 <freep>
      return (void*)(p + 1);
 9c2:	01078513          	addi	a0,a5,16
  }
}
 9c6:	70e2                	ld	ra,56(sp)
 9c8:	7442                	ld	s0,48(sp)
 9ca:	7902                	ld	s2,32(sp)
 9cc:	69e2                	ld	s3,24(sp)
 9ce:	6121                	addi	sp,sp,64
 9d0:	8082                	ret
 9d2:	74a2                	ld	s1,40(sp)
 9d4:	6a42                	ld	s4,16(sp)
 9d6:	6aa2                	ld	s5,8(sp)
 9d8:	6b02                	ld	s6,0(sp)
 9da:	b7f5                	j	9c6 <malloc+0xdc>
