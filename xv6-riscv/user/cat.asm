
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	ff890913          	addi	s2,s2,-8 # 1010 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	39c000ef          	jal	3c4 <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	394000ef          	jal	3cc <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	99058593          	addi	a1,a1,-1648 # 9d0 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	7a6000ef          	jal	7f0 <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	35c000ef          	jal	3ac <exit>
    }
  }
  if(n < 0){
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	97e58593          	addi	a1,a1,-1666 # 9e8 <malloc+0x116>
  72:	4509                	li	a0,2
  74:	77c000ef          	jal	7f0 <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	332000ef          	jal	3ac <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	340000ef          	jal	3ec <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	318000ef          	jal	3d4 <close>
  for(i = 1; i < argc; i++){
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	2e4000ef          	jal	3ac <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	2d2000ef          	jal	3ac <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	91e58593          	addi	a1,a1,-1762 # a00 <malloc+0x12e>
  ea:	4509                	li	a0,2
  ec:	704000ef          	jal	7f0 <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	2ba000ef          	jal	3ac <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  fe:	f81ff0ef          	jal	7e <main>
  exit(r);
 102:	2aa000ef          	jal	3ac <exit>

0000000000000106 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0xa>
    ;
  return os;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x20>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x20>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strlen>:

uint
strlen(const char *s)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x28>
 164:	00150793          	addi	a5,a0,1
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x12>
 172:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 176:	60a2                	ld	ra,8(sp)
 178:	6402                	ld	s0,0(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for(n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfdd                	j	176 <strlen+0x20>

0000000000000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18a:	ca19                	beqz	a2,1a0 <memset+0x1e>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x14>
  }
  return dst;
}
 1a0:	60a2                	ld	ra,8(sp)
 1a2:	6402                	ld	s0,0(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strchr>:

char*
strchr(const char *s, char c)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e406                	sd	ra,8(sp)
 1ac:	e022                	sd	s0,0(sp)
 1ae:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cf81                	beqz	a5,1cc <strchr+0x24>
    if(*s == c)
 1b6:	00f58763          	beq	a1,a5,1c4 <strchr+0x1c>
  for(; *s; s++)
 1ba:	0505                	addi	a0,a0,1
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbfd                	bnez	a5,1b6 <strchr+0xe>
      return (char*)s;
  return 0;
 1c2:	4501                	li	a0,0
}
 1c4:	60a2                	ld	ra,8(sp)
 1c6:	6402                	ld	s0,0(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret
  return 0;
 1cc:	4501                	li	a0,0
 1ce:	bfdd                	j	1c4 <strchr+0x1c>

00000000000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	711d                	addi	sp,sp,-96
 1d2:	ec86                	sd	ra,88(sp)
 1d4:	e8a2                	sd	s0,80(sp)
 1d6:	e4a6                	sd	s1,72(sp)
 1d8:	e0ca                	sd	s2,64(sp)
 1da:	fc4e                	sd	s3,56(sp)
 1dc:	f852                	sd	s4,48(sp)
 1de:	f456                	sd	s5,40(sp)
 1e0:	f05a                	sd	s6,32(sp)
 1e2:	ec5e                	sd	s7,24(sp)
 1e4:	e862                	sd	s8,16(sp)
 1e6:	1080                	addi	s0,sp,96
 1e8:	8baa                	mv	s7,a0
 1ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ec:	892a                	mv	s2,a0
 1ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f0:	faf40b13          	addi	s6,s0,-81
 1f4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1f6:	8c26                	mv	s8,s1
 1f8:	0014899b          	addiw	s3,s1,1
 1fc:	84ce                	mv	s1,s3
 1fe:	0349d463          	bge	s3,s4,226 <gets+0x56>
    cc = read(0, &c, 1);
 202:	8656                	mv	a2,s5
 204:	85da                	mv	a1,s6
 206:	4501                	li	a0,0
 208:	1bc000ef          	jal	3c4 <read>
    if(cc < 1)
 20c:	00a05d63          	blez	a0,226 <gets+0x56>
      break;
    buf[i++] = c;
 210:	faf44783          	lbu	a5,-81(s0)
 214:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 218:	0905                	addi	s2,s2,1
 21a:	ff678713          	addi	a4,a5,-10
 21e:	c319                	beqz	a4,224 <gets+0x54>
 220:	17cd                	addi	a5,a5,-13
 222:	fbf1                	bnez	a5,1f6 <gets+0x26>
    buf[i++] = c;
 224:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 226:	9c5e                	add	s8,s8,s7
 228:	000c0023          	sb	zero,0(s8)
  return buf;
}
 22c:	855e                	mv	a0,s7
 22e:	60e6                	ld	ra,88(sp)
 230:	6446                	ld	s0,80(sp)
 232:	64a6                	ld	s1,72(sp)
 234:	6906                	ld	s2,64(sp)
 236:	79e2                	ld	s3,56(sp)
 238:	7a42                	ld	s4,48(sp)
 23a:	7aa2                	ld	s5,40(sp)
 23c:	7b02                	ld	s6,32(sp)
 23e:	6be2                	ld	s7,24(sp)
 240:	6c42                	ld	s8,16(sp)
 242:	6125                	addi	sp,sp,96
 244:	8082                	ret

0000000000000246 <stat>:

int
stat(const char *n, struct stat *st)
{
 246:	1101                	addi	sp,sp,-32
 248:	ec06                	sd	ra,24(sp)
 24a:	e822                	sd	s0,16(sp)
 24c:	e04a                	sd	s2,0(sp)
 24e:	1000                	addi	s0,sp,32
 250:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 252:	4581                	li	a1,0
 254:	198000ef          	jal	3ec <open>
  if(fd < 0)
 258:	02054263          	bltz	a0,27c <stat+0x36>
 25c:	e426                	sd	s1,8(sp)
 25e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 260:	85ca                	mv	a1,s2
 262:	1a2000ef          	jal	404 <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	16a000ef          	jal	3d4 <close>
  return r;
 26e:	64a2                	ld	s1,8(sp)
}
 270:	854a                	mv	a0,s2
 272:	60e2                	ld	ra,24(sp)
 274:	6442                	ld	s0,16(sp)
 276:	6902                	ld	s2,0(sp)
 278:	6105                	addi	sp,sp,32
 27a:	8082                	ret
    return -1;
 27c:	57fd                	li	a5,-1
 27e:	893e                	mv	s2,a5
 280:	bfc5                	j	270 <stat+0x2a>

0000000000000282 <atoi>:

int
atoi(const char *s)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66963          	bltu	a2,a5,2ca <atoi+0x48>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1e>
  return n;
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfdd                	j	2c2 <atoi+0x40>

00000000000002ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d6:	02b57563          	bgeu	a0,a1,300 <memmove+0x32>
    while(n-- > 0)
 2da:	00c05f63          	blez	a2,2f8 <memmove+0x2a>
 2de:	1602                	slli	a2,a2,0x20
 2e0:	9201                	srli	a2,a2,0x20
 2e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e8:	0585                	addi	a1,a1,1
 2ea:	0705                	addi	a4,a4,1
 2ec:	fff5c683          	lbu	a3,-1(a1)
 2f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f4:	fee79ae3          	bne	a5,a4,2e8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
    while(n-- > 0)
 300:	fec05ce3          	blez	a2,2f8 <memmove+0x2a>
    dst += n;
 304:	00c50733          	add	a4,a0,a2
    src += n;
 308:	95b2                	add	a1,a1,a2
 30a:	fff6079b          	addiw	a5,a2,-1
 30e:	1782                	slli	a5,a5,0x20
 310:	9381                	srli	a5,a5,0x20
 312:	fff7c793          	not	a5,a5
 316:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 318:	15fd                	addi	a1,a1,-1
 31a:	177d                	addi	a4,a4,-1
 31c:	0005c683          	lbu	a3,0(a1)
 320:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 324:	fef71ae3          	bne	a4,a5,318 <memmove+0x4a>
 328:	bfc1                	j	2f8 <memmove+0x2a>

000000000000032a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 332:	c61d                	beqz	a2,360 <memcmp+0x36>
 334:	1602                	slli	a2,a2,0x20
 336:	9201                	srli	a2,a2,0x20
 338:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 33c:	00054783          	lbu	a5,0(a0)
 340:	0005c703          	lbu	a4,0(a1)
 344:	00e79863          	bne	a5,a4,354 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 348:	0505                	addi	a0,a0,1
    p2++;
 34a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34c:	fed518e3          	bne	a0,a3,33c <memcmp+0x12>
  }
  return 0;
 350:	4501                	li	a0,0
 352:	a019                	j	358 <memcmp+0x2e>
      return *p1 - *p2;
 354:	40e7853b          	subw	a0,a5,a4
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  return 0;
 360:	4501                	li	a0,0
 362:	bfdd                	j	358 <memcmp+0x2e>

0000000000000364 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36c:	f63ff0ef          	jal	2ce <memmove>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <sbrk>:

char *
sbrk(int n) {
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 380:	4585                	li	a1,1
 382:	0b2000ef          	jal	434 <sys_sbrk>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret

000000000000038e <sbrklazy>:

char *
sbrklazy(int n) {
 38e:	1141                	addi	sp,sp,-16
 390:	e406                	sd	ra,8(sp)
 392:	e022                	sd	s0,0(sp)
 394:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 396:	4589                	li	a1,2
 398:	09c000ef          	jal	434 <sys_sbrk>
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a4:	4885                	li	a7,1
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ac:	4889                	li	a7,2
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b4:	488d                	li	a7,3
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3bc:	4891                	li	a7,4
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <read>:
.global read
read:
 li a7, SYS_read
 3c4:	4895                	li	a7,5
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <write>:
.global write
write:
 li a7, SYS_write
 3cc:	48c1                	li	a7,16
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <close>:
.global close
close:
 li a7, SYS_close
 3d4:	48d5                	li	a7,21
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3dc:	4899                	li	a7,6
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e4:	489d                	li	a7,7
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <open>:
.global open
open:
 li a7, SYS_open
 3ec:	48bd                	li	a7,15
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f4:	48c5                	li	a7,17
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fc:	48c9                	li	a7,18
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 404:	48a1                	li	a7,8
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <link>:
.global link
link:
 li a7, SYS_link
 40c:	48cd                	li	a7,19
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 414:	48d1                	li	a7,20
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41c:	48a5                	li	a7,9
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <dup>:
.global dup
dup:
 li a7, SYS_dup
 424:	48a9                	li	a7,10
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42c:	48ad                	li	a7,11
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 434:	48b1                	li	a7,12
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <pause>:
.global pause
pause:
 li a7, SYS_pause
 43c:	48b5                	li	a7,13
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 444:	48b9                	li	a7,14
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <kps>:
.global kps
kps:
 li a7, SYS_kps
 44c:	48d9                	li	a7,22
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 454:	48dd                	li	a7,23
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 45c:	48e1                	li	a7,24
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 464:	48e5                	li	a7,25
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 46c:	48e9                	li	a7,26
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 474:	1101                	addi	sp,sp,-32
 476:	ec06                	sd	ra,24(sp)
 478:	e822                	sd	s0,16(sp)
 47a:	1000                	addi	s0,sp,32
 47c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 480:	4605                	li	a2,1
 482:	fef40593          	addi	a1,s0,-17
 486:	f47ff0ef          	jal	3cc <write>
}
 48a:	60e2                	ld	ra,24(sp)
 48c:	6442                	ld	s0,16(sp)
 48e:	6105                	addi	sp,sp,32
 490:	8082                	ret

0000000000000492 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 492:	715d                	addi	sp,sp,-80
 494:	e486                	sd	ra,72(sp)
 496:	e0a2                	sd	s0,64(sp)
 498:	f84a                	sd	s2,48(sp)
 49a:	f44e                	sd	s3,40(sp)
 49c:	0880                	addi	s0,sp,80
 49e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4a0:	c6d1                	beqz	a3,52c <printint+0x9a>
 4a2:	0805d563          	bgez	a1,52c <printint+0x9a>
    neg = 1;
    x = -xx;
 4a6:	40b005b3          	neg	a1,a1
    neg = 1;
 4aa:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4ac:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4b0:	86ce                	mv	a3,s3
  i = 0;
 4b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b4:	00000817          	auipc	a6,0x0
 4b8:	56c80813          	addi	a6,a6,1388 # a20 <digits>
 4bc:	88ba                	mv	a7,a4
 4be:	0017051b          	addiw	a0,a4,1
 4c2:	872a                	mv	a4,a0
 4c4:	02c5f7b3          	remu	a5,a1,a2
 4c8:	97c2                	add	a5,a5,a6
 4ca:	0007c783          	lbu	a5,0(a5)
 4ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d2:	87ae                	mv	a5,a1
 4d4:	02c5d5b3          	divu	a1,a1,a2
 4d8:	0685                	addi	a3,a3,1
 4da:	fec7f1e3          	bgeu	a5,a2,4bc <printint+0x2a>
  if(neg)
 4de:	00030c63          	beqz	t1,4f6 <printint+0x64>
    buf[i++] = '-';
 4e2:	fd050793          	addi	a5,a0,-48
 4e6:	00878533          	add	a0,a5,s0
 4ea:	02d00793          	li	a5,45
 4ee:	fef50423          	sb	a5,-24(a0)
 4f2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4f6:	02e05563          	blez	a4,520 <printint+0x8e>
 4fa:	fc26                	sd	s1,56(sp)
 4fc:	377d                	addiw	a4,a4,-1
 4fe:	00e984b3          	add	s1,s3,a4
 502:	19fd                	addi	s3,s3,-1
 504:	99ba                	add	s3,s3,a4
 506:	1702                	slli	a4,a4,0x20
 508:	9301                	srli	a4,a4,0x20
 50a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 50e:	0004c583          	lbu	a1,0(s1)
 512:	854a                	mv	a0,s2
 514:	f61ff0ef          	jal	474 <putc>
  while(--i >= 0)
 518:	14fd                	addi	s1,s1,-1
 51a:	ff349ae3          	bne	s1,s3,50e <printint+0x7c>
 51e:	74e2                	ld	s1,56(sp)
}
 520:	60a6                	ld	ra,72(sp)
 522:	6406                	ld	s0,64(sp)
 524:	7942                	ld	s2,48(sp)
 526:	79a2                	ld	s3,40(sp)
 528:	6161                	addi	sp,sp,80
 52a:	8082                	ret
  neg = 0;
 52c:	4301                	li	t1,0
 52e:	bfbd                	j	4ac <printint+0x1a>

0000000000000530 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 530:	711d                	addi	sp,sp,-96
 532:	ec86                	sd	ra,88(sp)
 534:	e8a2                	sd	s0,80(sp)
 536:	e4a6                	sd	s1,72(sp)
 538:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 53a:	0005c483          	lbu	s1,0(a1)
 53e:	22048363          	beqz	s1,764 <vprintf+0x234>
 542:	e0ca                	sd	s2,64(sp)
 544:	fc4e                	sd	s3,56(sp)
 546:	f852                	sd	s4,48(sp)
 548:	f456                	sd	s5,40(sp)
 54a:	f05a                	sd	s6,32(sp)
 54c:	ec5e                	sd	s7,24(sp)
 54e:	e862                	sd	s8,16(sp)
 550:	8b2a                	mv	s6,a0
 552:	8a2e                	mv	s4,a1
 554:	8bb2                	mv	s7,a2
  state = 0;
 556:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 558:	4901                	li	s2,0
 55a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 55c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 560:	06400c13          	li	s8,100
 564:	a00d                	j	586 <vprintf+0x56>
        putc(fd, c0);
 566:	85a6                	mv	a1,s1
 568:	855a                	mv	a0,s6
 56a:	f0bff0ef          	jal	474 <putc>
 56e:	a019                	j	574 <vprintf+0x44>
    } else if(state == '%'){
 570:	03598363          	beq	s3,s5,596 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 574:	0019079b          	addiw	a5,s2,1
 578:	893e                	mv	s2,a5
 57a:	873e                	mv	a4,a5
 57c:	97d2                	add	a5,a5,s4
 57e:	0007c483          	lbu	s1,0(a5)
 582:	1c048a63          	beqz	s1,756 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 586:	0004879b          	sext.w	a5,s1
    if(state == 0){
 58a:	fe0993e3          	bnez	s3,570 <vprintf+0x40>
      if(c0 == '%'){
 58e:	fd579ce3          	bne	a5,s5,566 <vprintf+0x36>
        state = '%';
 592:	89be                	mv	s3,a5
 594:	b7c5                	j	574 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 596:	00ea06b3          	add	a3,s4,a4
 59a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 59e:	1c060863          	beqz	a2,76e <vprintf+0x23e>
      if(c0 == 'd'){
 5a2:	03878763          	beq	a5,s8,5d0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5a6:	f9478693          	addi	a3,a5,-108
 5aa:	0016b693          	seqz	a3,a3
 5ae:	f9c60593          	addi	a1,a2,-100
 5b2:	e99d                	bnez	a1,5e8 <vprintf+0xb8>
 5b4:	ca95                	beqz	a3,5e8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	ecfff0ef          	jal	492 <printint>
        i += 1;
 5c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b75d                	j	574 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5d0:	008b8493          	addi	s1,s7,8
 5d4:	4685                	li	a3,1
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	eb5ff0ef          	jal	492 <printint>
 5e2:	8ba6                	mv	s7,s1
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b779                	j	574 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5e8:	9752                	add	a4,a4,s4
 5ea:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ee:	f9460713          	addi	a4,a2,-108
 5f2:	00173713          	seqz	a4,a4
 5f6:	8f75                	and	a4,a4,a3
 5f8:	f9c58513          	addi	a0,a1,-100
 5fc:	18051363          	bnez	a0,782 <vprintf+0x252>
 600:	18070163          	beqz	a4,782 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	008b8493          	addi	s1,s7,8
 608:	4685                	li	a3,1
 60a:	4629                	li	a2,10
 60c:	000bb583          	ld	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	e81ff0ef          	jal	492 <printint>
        i += 2;
 616:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 618:	8ba6                	mv	s7,s1
      state = 0;
 61a:	4981                	li	s3,0
        i += 2;
 61c:	bfa1                	j	574 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 61e:	008b8493          	addi	s1,s7,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000be583          	lwu	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	e67ff0ef          	jal	492 <printint>
 630:	8ba6                	mv	s7,s1
      state = 0;
 632:	4981                	li	s3,0
 634:	b781                	j	574 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	008b8493          	addi	s1,s7,8
 63a:	4681                	li	a3,0
 63c:	4629                	li	a2,10
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e4fff0ef          	jal	492 <printint>
        i += 1;
 648:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 64a:	8ba6                	mv	s7,s1
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b71d                	j	574 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	008b8493          	addi	s1,s7,8
 654:	4681                	li	a3,0
 656:	4629                	li	a2,10
 658:	000bb583          	ld	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	e35ff0ef          	jal	492 <printint>
        i += 2;
 662:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 664:	8ba6                	mv	s7,s1
      state = 0;
 666:	4981                	li	s3,0
        i += 2;
 668:	b731                	j	574 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 66a:	008b8493          	addi	s1,s7,8
 66e:	4681                	li	a3,0
 670:	4641                	li	a2,16
 672:	000be583          	lwu	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	e1bff0ef          	jal	492 <printint>
 67c:	8ba6                	mv	s7,s1
      state = 0;
 67e:	4981                	li	s3,0
 680:	bdd5                	j	574 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	008b8493          	addi	s1,s7,8
 686:	4681                	li	a3,0
 688:	4641                	li	a2,16
 68a:	000bb583          	ld	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e03ff0ef          	jal	492 <printint>
        i += 1;
 694:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 696:	8ba6                	mv	s7,s1
      state = 0;
 698:	4981                	li	s3,0
 69a:	bde9                	j	574 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69c:	008b8493          	addi	s1,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4641                	li	a2,16
 6a4:	000bb583          	ld	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	de9ff0ef          	jal	492 <printint>
        i += 2;
 6ae:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b0:	8ba6                	mv	s7,s1
      state = 0;
 6b2:	4981                	li	s3,0
        i += 2;
 6b4:	b5c1                	j	574 <vprintf+0x44>
 6b6:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6b8:	008b8793          	addi	a5,s7,8
 6bc:	8cbe                	mv	s9,a5
 6be:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c2:	03000593          	li	a1,48
 6c6:	855a                	mv	a0,s6
 6c8:	dadff0ef          	jal	474 <putc>
  putc(fd, 'x');
 6cc:	07800593          	li	a1,120
 6d0:	855a                	mv	a0,s6
 6d2:	da3ff0ef          	jal	474 <putc>
 6d6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d8:	00000b97          	auipc	s7,0x0
 6dc:	348b8b93          	addi	s7,s7,840 # a20 <digits>
 6e0:	03c9d793          	srli	a5,s3,0x3c
 6e4:	97de                	add	a5,a5,s7
 6e6:	0007c583          	lbu	a1,0(a5)
 6ea:	855a                	mv	a0,s6
 6ec:	d89ff0ef          	jal	474 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f0:	0992                	slli	s3,s3,0x4
 6f2:	34fd                	addiw	s1,s1,-1
 6f4:	f4f5                	bnez	s1,6e0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6f6:	8be6                	mv	s7,s9
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	6ca2                	ld	s9,8(sp)
 6fc:	bda5                	j	574 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6fe:	008b8493          	addi	s1,s7,8
 702:	000bc583          	lbu	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	d6dff0ef          	jal	474 <putc>
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
 710:	b595                	j	574 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 712:	008b8993          	addi	s3,s7,8
 716:	000bb483          	ld	s1,0(s7)
 71a:	cc91                	beqz	s1,736 <vprintf+0x206>
        for(; *s; s++)
 71c:	0004c583          	lbu	a1,0(s1)
 720:	c985                	beqz	a1,750 <vprintf+0x220>
          putc(fd, *s);
 722:	855a                	mv	a0,s6
 724:	d51ff0ef          	jal	474 <putc>
        for(; *s; s++)
 728:	0485                	addi	s1,s1,1
 72a:	0004c583          	lbu	a1,0(s1)
 72e:	f9f5                	bnez	a1,722 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 730:	8bce                	mv	s7,s3
      state = 0;
 732:	4981                	li	s3,0
 734:	b581                	j	574 <vprintf+0x44>
          s = "(null)";
 736:	00000497          	auipc	s1,0x0
 73a:	2e248493          	addi	s1,s1,738 # a18 <malloc+0x146>
        for(; *s; s++)
 73e:	02800593          	li	a1,40
 742:	b7c5                	j	722 <vprintf+0x1f2>
        putc(fd, '%');
 744:	85be                	mv	a1,a5
 746:	855a                	mv	a0,s6
 748:	d2dff0ef          	jal	474 <putc>
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b51d                	j	574 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 750:	8bce                	mv	s7,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	b505                	j	574 <vprintf+0x44>
 756:	6906                	ld	s2,64(sp)
 758:	79e2                	ld	s3,56(sp)
 75a:	7a42                	ld	s4,48(sp)
 75c:	7aa2                	ld	s5,40(sp)
 75e:	7b02                	ld	s6,32(sp)
 760:	6be2                	ld	s7,24(sp)
 762:	6c42                	ld	s8,16(sp)
    }
  }
}
 764:	60e6                	ld	ra,88(sp)
 766:	6446                	ld	s0,80(sp)
 768:	64a6                	ld	s1,72(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret
      if(c0 == 'd'){
 76e:	06400713          	li	a4,100
 772:	e4e78fe3          	beq	a5,a4,5d0 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 776:	f9478693          	addi	a3,a5,-108
 77a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 77e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 780:	4701                	li	a4,0
      } else if(c0 == 'u'){
 782:	07500513          	li	a0,117
 786:	e8a78ce3          	beq	a5,a0,61e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 78a:	f8b60513          	addi	a0,a2,-117
 78e:	e119                	bnez	a0,794 <vprintf+0x264>
 790:	ea0693e3          	bnez	a3,636 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 794:	f8b58513          	addi	a0,a1,-117
 798:	e119                	bnez	a0,79e <vprintf+0x26e>
 79a:	ea071be3          	bnez	a4,650 <vprintf+0x120>
      } else if(c0 == 'x'){
 79e:	07800513          	li	a0,120
 7a2:	eca784e3          	beq	a5,a0,66a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7a6:	f8860613          	addi	a2,a2,-120
 7aa:	e219                	bnez	a2,7b0 <vprintf+0x280>
 7ac:	ec069be3          	bnez	a3,682 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7b0:	f8858593          	addi	a1,a1,-120
 7b4:	e199                	bnez	a1,7ba <vprintf+0x28a>
 7b6:	ee0713e3          	bnez	a4,69c <vprintf+0x16c>
      } else if(c0 == 'p'){
 7ba:	07000713          	li	a4,112
 7be:	eee78ce3          	beq	a5,a4,6b6 <vprintf+0x186>
      } else if(c0 == 'c'){
 7c2:	06300713          	li	a4,99
 7c6:	f2e78ce3          	beq	a5,a4,6fe <vprintf+0x1ce>
      } else if(c0 == 's'){
 7ca:	07300713          	li	a4,115
 7ce:	f4e782e3          	beq	a5,a4,712 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7d2:	02500713          	li	a4,37
 7d6:	f6e787e3          	beq	a5,a4,744 <vprintf+0x214>
        putc(fd, '%');
 7da:	02500593          	li	a1,37
 7de:	855a                	mv	a0,s6
 7e0:	c95ff0ef          	jal	474 <putc>
        putc(fd, c0);
 7e4:	85a6                	mv	a1,s1
 7e6:	855a                	mv	a0,s6
 7e8:	c8dff0ef          	jal	474 <putc>
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b359                	j	574 <vprintf+0x44>

00000000000007f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f0:	715d                	addi	sp,sp,-80
 7f2:	ec06                	sd	ra,24(sp)
 7f4:	e822                	sd	s0,16(sp)
 7f6:	1000                	addi	s0,sp,32
 7f8:	e010                	sd	a2,0(s0)
 7fa:	e414                	sd	a3,8(s0)
 7fc:	e818                	sd	a4,16(s0)
 7fe:	ec1c                	sd	a5,24(s0)
 800:	03043023          	sd	a6,32(s0)
 804:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	8622                	mv	a2,s0
 80a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80e:	d23ff0ef          	jal	530 <vprintf>
}
 812:	60e2                	ld	ra,24(sp)
 814:	6442                	ld	s0,16(sp)
 816:	6161                	addi	sp,sp,80
 818:	8082                	ret

000000000000081a <printf>:

void
printf(const char *fmt, ...)
{
 81a:	711d                	addi	sp,sp,-96
 81c:	ec06                	sd	ra,24(sp)
 81e:	e822                	sd	s0,16(sp)
 820:	1000                	addi	s0,sp,32
 822:	e40c                	sd	a1,8(s0)
 824:	e810                	sd	a2,16(s0)
 826:	ec14                	sd	a3,24(s0)
 828:	f018                	sd	a4,32(s0)
 82a:	f41c                	sd	a5,40(s0)
 82c:	03043823          	sd	a6,48(s0)
 830:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 834:	00840613          	addi	a2,s0,8
 838:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83c:	85aa                	mv	a1,a0
 83e:	4505                	li	a0,1
 840:	cf1ff0ef          	jal	530 <vprintf>
}
 844:	60e2                	ld	ra,24(sp)
 846:	6442                	ld	s0,16(sp)
 848:	6125                	addi	sp,sp,96
 84a:	8082                	ret

000000000000084c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84c:	1141                	addi	sp,sp,-16
 84e:	e406                	sd	ra,8(sp)
 850:	e022                	sd	s0,0(sp)
 852:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 854:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 858:	00000797          	auipc	a5,0x0
 85c:	7a87b783          	ld	a5,1960(a5) # 1000 <freep>
 860:	a039                	j	86e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 862:	6398                	ld	a4,0(a5)
 864:	00e7e463          	bltu	a5,a4,86c <free+0x20>
 868:	00e6ea63          	bltu	a3,a4,87c <free+0x30>
{
 86c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86e:	fed7fae3          	bgeu	a5,a3,862 <free+0x16>
 872:	6398                	ld	a4,0(a5)
 874:	00e6e463          	bltu	a3,a4,87c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 878:	fee7eae3          	bltu	a5,a4,86c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 87c:	ff852583          	lw	a1,-8(a0)
 880:	6390                	ld	a2,0(a5)
 882:	02059813          	slli	a6,a1,0x20
 886:	01c85713          	srli	a4,a6,0x1c
 88a:	9736                	add	a4,a4,a3
 88c:	02e60563          	beq	a2,a4,8b6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 890:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 894:	4790                	lw	a2,8(a5)
 896:	02061593          	slli	a1,a2,0x20
 89a:	01c5d713          	srli	a4,a1,0x1c
 89e:	973e                	add	a4,a4,a5
 8a0:	02e68263          	beq	a3,a4,8c4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8a4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a6:	00000717          	auipc	a4,0x0
 8aa:	74f73d23          	sd	a5,1882(a4) # 1000 <freep>
}
 8ae:	60a2                	ld	ra,8(sp)
 8b0:	6402                	ld	s0,0(sp)
 8b2:	0141                	addi	sp,sp,16
 8b4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8b6:	4618                	lw	a4,8(a2)
 8b8:	9f2d                	addw	a4,a4,a1
 8ba:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8be:	6398                	ld	a4,0(a5)
 8c0:	6310                	ld	a2,0(a4)
 8c2:	b7f9                	j	890 <free+0x44>
    p->s.size += bp->s.size;
 8c4:	ff852703          	lw	a4,-8(a0)
 8c8:	9f31                	addw	a4,a4,a2
 8ca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8cc:	ff053683          	ld	a3,-16(a0)
 8d0:	bfd1                	j	8a4 <free+0x58>

00000000000008d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d2:	7139                	addi	sp,sp,-64
 8d4:	fc06                	sd	ra,56(sp)
 8d6:	f822                	sd	s0,48(sp)
 8d8:	f04a                	sd	s2,32(sp)
 8da:	ec4e                	sd	s3,24(sp)
 8dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8de:	02051993          	slli	s3,a0,0x20
 8e2:	0209d993          	srli	s3,s3,0x20
 8e6:	09bd                	addi	s3,s3,15
 8e8:	0049d993          	srli	s3,s3,0x4
 8ec:	2985                	addiw	s3,s3,1
 8ee:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8f0:	00000517          	auipc	a0,0x0
 8f4:	71053503          	ld	a0,1808(a0) # 1000 <freep>
 8f8:	c905                	beqz	a0,928 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fc:	4798                	lw	a4,8(a5)
 8fe:	09377663          	bgeu	a4,s3,98a <malloc+0xb8>
 902:	f426                	sd	s1,40(sp)
 904:	e852                	sd	s4,16(sp)
 906:	e456                	sd	s5,8(sp)
 908:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 90a:	8a4e                	mv	s4,s3
 90c:	6705                	lui	a4,0x1
 90e:	00e9f363          	bgeu	s3,a4,914 <malloc+0x42>
 912:	6a05                	lui	s4,0x1
 914:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 918:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 91c:	00000497          	auipc	s1,0x0
 920:	6e448493          	addi	s1,s1,1764 # 1000 <freep>
  if(p == SBRK_ERROR)
 924:	5afd                	li	s5,-1
 926:	a83d                	j	964 <malloc+0x92>
 928:	f426                	sd	s1,40(sp)
 92a:	e852                	sd	s4,16(sp)
 92c:	e456                	sd	s5,8(sp)
 92e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 930:	00001797          	auipc	a5,0x1
 934:	8e078793          	addi	a5,a5,-1824 # 1210 <base>
 938:	00000717          	auipc	a4,0x0
 93c:	6cf73423          	sd	a5,1736(a4) # 1000 <freep>
 940:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 942:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 946:	b7d1                	j	90a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 948:	6398                	ld	a4,0(a5)
 94a:	e118                	sd	a4,0(a0)
 94c:	a899                	j	9a2 <malloc+0xd0>
  hp->s.size = nu;
 94e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 952:	0541                	addi	a0,a0,16
 954:	ef9ff0ef          	jal	84c <free>
  return freep;
 958:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 95a:	c125                	beqz	a0,9ba <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95e:	4798                	lw	a4,8(a5)
 960:	03277163          	bgeu	a4,s2,982 <malloc+0xb0>
    if(p == freep)
 964:	6098                	ld	a4,0(s1)
 966:	853e                	mv	a0,a5
 968:	fef71ae3          	bne	a4,a5,95c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 96c:	8552                	mv	a0,s4
 96e:	a0bff0ef          	jal	378 <sbrk>
  if(p == SBRK_ERROR)
 972:	fd551ee3          	bne	a0,s5,94e <malloc+0x7c>
        return 0;
 976:	4501                	li	a0,0
 978:	74a2                	ld	s1,40(sp)
 97a:	6a42                	ld	s4,16(sp)
 97c:	6aa2                	ld	s5,8(sp)
 97e:	6b02                	ld	s6,0(sp)
 980:	a03d                	j	9ae <malloc+0xdc>
 982:	74a2                	ld	s1,40(sp)
 984:	6a42                	ld	s4,16(sp)
 986:	6aa2                	ld	s5,8(sp)
 988:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 98a:	fae90fe3          	beq	s2,a4,948 <malloc+0x76>
        p->s.size -= nunits;
 98e:	4137073b          	subw	a4,a4,s3
 992:	c798                	sw	a4,8(a5)
        p += p->s.size;
 994:	02071693          	slli	a3,a4,0x20
 998:	01c6d713          	srli	a4,a3,0x1c
 99c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 99e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a2:	00000717          	auipc	a4,0x0
 9a6:	64a73f23          	sd	a0,1630(a4) # 1000 <freep>
      return (void*)(p + 1);
 9aa:	01078513          	addi	a0,a5,16
  }
}
 9ae:	70e2                	ld	ra,56(sp)
 9b0:	7442                	ld	s0,48(sp)
 9b2:	7902                	ld	s2,32(sp)
 9b4:	69e2                	ld	s3,24(sp)
 9b6:	6121                	addi	sp,sp,64
 9b8:	8082                	ret
 9ba:	74a2                	ld	s1,40(sp)
 9bc:	6a42                	ld	s4,16(sp)
 9be:	6aa2                	ld	s5,8(sp)
 9c0:	6b02                	ld	s6,0(sp)
 9c2:	b7f5                	j	9ae <malloc+0xdc>
