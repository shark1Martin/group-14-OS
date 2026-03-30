
user/_hello_world:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <demo_variables>:
#include "user/user.h"

// Example 1: Variables and types
void
demo_variables(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  printf("\n=== Variables and Types ===\n");
   8:	00001517          	auipc	a0,0x1
   c:	ce850513          	addi	a0,a0,-792 # cf0 <malloc+0xf8>
  10:	335000ef          	jal	b44 <printf>
  int x = 42;
  char c = 'A';
  
  printf("Integer x = %d\n", x);
  14:	02a00593          	li	a1,42
  18:	00001517          	auipc	a0,0x1
  1c:	d0050513          	addi	a0,a0,-768 # d18 <malloc+0x120>
  20:	325000ef          	jal	b44 <printf>
  printf("Character c = %c\n", c);
  24:	04100593          	li	a1,65
  28:	00001517          	auipc	a0,0x1
  2c:	d0050513          	addi	a0,a0,-768 # d28 <malloc+0x130>
  30:	315000ef          	jal	b44 <printf>
}
  34:	60a2                	ld	ra,8(sp)
  36:	6402                	ld	s0,0(sp)
  38:	0141                	addi	sp,sp,16
  3a:	8082                	ret

000000000000003c <add_numbers>:

// Example 2: Functions with parameters and return values
int
add_numbers(int a, int b)
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e422                	sd	s0,8(sp)
  40:	0800                	addi	s0,sp,16
  return a + b;
}
  42:	9d2d                	addw	a0,a0,a1
  44:	6422                	ld	s0,8(sp)
  46:	0141                	addi	sp,sp,16
  48:	8082                	ret

000000000000004a <multiply>:

int
multiply(int a, int b)
{
  4a:	1141                	addi	sp,sp,-16
  4c:	e422                	sd	s0,8(sp)
  4e:	0800                	addi	s0,sp,16
  int result = a * b;
  return result;
}
  50:	02b5053b          	mulw	a0,a0,a1
  54:	6422                	ld	s0,8(sp)
  56:	0141                	addi	sp,sp,16
  58:	8082                	ret

000000000000005a <demo_functions>:

void
demo_functions(void)
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e406                	sd	ra,8(sp)
  5e:	e022                	sd	s0,0(sp)
  60:	0800                	addi	s0,sp,16
  printf("\n=== Functions ===\n");
  62:	00001517          	auipc	a0,0x1
  66:	cde50513          	addi	a0,a0,-802 # d40 <malloc+0x148>
  6a:	2db000ef          	jal	b44 <printf>
  int sum = add_numbers(10, 20);
  int product = multiply(5, 7);
  
  printf("10 + 20 = %d\n", sum);
  6e:	45f9                	li	a1,30
  70:	00001517          	auipc	a0,0x1
  74:	ce850513          	addi	a0,a0,-792 # d58 <malloc+0x160>
  78:	2cd000ef          	jal	b44 <printf>
  printf("5 * 7 = %d\n", product);
  7c:	02300593          	li	a1,35
  80:	00001517          	auipc	a0,0x1
  84:	ce850513          	addi	a0,a0,-792 # d68 <malloc+0x170>
  88:	2bd000ef          	jal	b44 <printf>
}
  8c:	60a2                	ld	ra,8(sp)
  8e:	6402                	ld	s0,0(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <demo_arrays>:

// Example 3: Arrays
void
demo_arrays(void)
{
  94:	715d                	addi	sp,sp,-80
  96:	e486                	sd	ra,72(sp)
  98:	e0a2                	sd	s0,64(sp)
  9a:	fc26                	sd	s1,56(sp)
  9c:	f84a                	sd	s2,48(sp)
  9e:	f44e                	sd	s3,40(sp)
  a0:	f052                	sd	s4,32(sp)
  a2:	0880                	addi	s0,sp,80
  printf("\n=== Arrays ===\n");
  a4:	00001517          	auipc	a0,0x1
  a8:	cd450513          	addi	a0,a0,-812 # d78 <malloc+0x180>
  ac:	299000ef          	jal	b44 <printf>
  int numbers[5] = {10, 20, 30, 40, 50};
  b0:	47a9                	li	a5,10
  b2:	faf42c23          	sw	a5,-72(s0)
  b6:	47d1                	li	a5,20
  b8:	faf42e23          	sw	a5,-68(s0)
  bc:	47f9                	li	a5,30
  be:	fcf42023          	sw	a5,-64(s0)
  c2:	02800793          	li	a5,40
  c6:	fcf42223          	sw	a5,-60(s0)
  ca:	03200793          	li	a5,50
  ce:	fcf42423          	sw	a5,-56(s0)
  
  printf("Array elements:\n");
  d2:	00001517          	auipc	a0,0x1
  d6:	cbe50513          	addi	a0,a0,-834 # d90 <malloc+0x198>
  da:	26b000ef          	jal	b44 <printf>
  for(int i = 0; i < 5; i++) {
  de:	fb840913          	addi	s2,s0,-72
  e2:	4481                	li	s1,0
    printf("  numbers[%d] = %d\n", i, numbers[i]);
  e4:	00001a17          	auipc	s4,0x1
  e8:	cc4a0a13          	addi	s4,s4,-828 # da8 <malloc+0x1b0>
  for(int i = 0; i < 5; i++) {
  ec:	4995                	li	s3,5
    printf("  numbers[%d] = %d\n", i, numbers[i]);
  ee:	00092603          	lw	a2,0(s2)
  f2:	85a6                	mv	a1,s1
  f4:	8552                	mv	a0,s4
  f6:	24f000ef          	jal	b44 <printf>
  for(int i = 0; i < 5; i++) {
  fa:	2485                	addiw	s1,s1,1
  fc:	0911                	addi	s2,s2,4
  fe:	ff3498e3          	bne	s1,s3,ee <demo_arrays+0x5a>
  // Calculate sum
  int sum = 0;
  for(int i = 0; i < 5; i++) {
    sum += numbers[i];
  }
  printf("Sum of array = %d\n", sum);
 102:	09600593          	li	a1,150
 106:	00001517          	auipc	a0,0x1
 10a:	cba50513          	addi	a0,a0,-838 # dc0 <malloc+0x1c8>
 10e:	237000ef          	jal	b44 <printf>
}
 112:	60a6                	ld	ra,72(sp)
 114:	6406                	ld	s0,64(sp)
 116:	74e2                	ld	s1,56(sp)
 118:	7942                	ld	s2,48(sp)
 11a:	79a2                	ld	s3,40(sp)
 11c:	7a02                	ld	s4,32(sp)
 11e:	6161                	addi	sp,sp,80
 120:	8082                	ret

0000000000000122 <demo_structs>:
  int id;
};

void
demo_structs(void)
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  printf("\n=== Structures ===\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	cae50513          	addi	a0,a0,-850 # dd8 <malloc+0x1e0>
 132:	213000ef          	jal	b44 <printf>
  
  struct point p;
  p.x = 100;
  p.y = 200;
  printf("Point: (%d, %d)\n", p.x, p.y);
 136:	0c800613          	li	a2,200
 13a:	06400593          	li	a1,100
 13e:	00001517          	auipc	a0,0x1
 142:	cb250513          	addi	a0,a0,-846 # df0 <malloc+0x1f8>
 146:	1ff000ef          	jal	b44 <printf>
  
  struct person student;
  student.age = 20;
  student.id = 12345;
  printf("Person: age=%d, id=%d\n", student.age, student.id);
 14a:	660d                	lui	a2,0x3
 14c:	03960613          	addi	a2,a2,57 # 3039 <base+0x1029>
 150:	45d1                	li	a1,20
 152:	00001517          	auipc	a0,0x1
 156:	cb650513          	addi	a0,a0,-842 # e08 <malloc+0x210>
 15a:	1eb000ef          	jal	b44 <printf>
}
 15e:	60a2                	ld	ra,8(sp)
 160:	6402                	ld	s0,0(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <demo_strings>:

// Example 5: Strings (character arrays)
void
demo_strings(void)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	1080                	addi	s0,sp,96
  printf("\n=== Strings ===\n");
 16e:	00001517          	auipc	a0,0x1
 172:	cb250513          	addi	a0,a0,-846 # e20 <malloc+0x228>
 176:	1cf000ef          	jal	b44 <printf>
  
  char greeting[] = "Hello";
 17a:	6c6c67b7          	lui	a5,0x6c6c6
 17e:	54878793          	addi	a5,a5,1352 # 6c6c6548 <base+0x6c6c4538>
 182:	fef42423          	sw	a5,-24(s0)
 186:	06f00793          	li	a5,111
 18a:	fef41623          	sh	a5,-20(s0)
  char name[] = "xv6";  // Need 4 chars: 'x', 'v', '6', '\0'
 18e:	003677b7          	lui	a5,0x367
 192:	67878793          	addi	a5,a5,1656 # 367678 <base+0x365668>
 196:	fef42023          	sw	a5,-32(s0)
  
  printf("Greeting: %s\n", greeting);
 19a:	fe840593          	addi	a1,s0,-24
 19e:	00001517          	auipc	a0,0x1
 1a2:	c9a50513          	addi	a0,a0,-870 # e38 <malloc+0x240>
 1a6:	19f000ef          	jal	b44 <printf>
  printf("Name: %s\n", name);
 1aa:	fe040593          	addi	a1,s0,-32
 1ae:	00001517          	auipc	a0,0x1
 1b2:	c9a50513          	addi	a0,a0,-870 # e48 <malloc+0x250>
 1b6:	18f000ef          	jal	b44 <printf>
  
  // String length
  int len = strlen(name);
 1ba:	fe040513          	addi	a0,s0,-32
 1be:	2fa000ef          	jal	4b8 <strlen>
  printf("Length of '%s' = %d\n", name, len);
 1c2:	0005061b          	sext.w	a2,a0
 1c6:	fe040593          	addi	a1,s0,-32
 1ca:	00001517          	auipc	a0,0x1
 1ce:	c8e50513          	addi	a0,a0,-882 # e58 <malloc+0x260>
 1d2:	173000ef          	jal	b44 <printf>
  
  // String concatenation (manual)
  char message[50] = "Welcome to ";
 1d6:	00001797          	auipc	a5,0x1
 1da:	caa78793          	addi	a5,a5,-854 # e80 <malloc+0x288>
 1de:	0007cf03          	lbu	t5,0(a5)
 1e2:	0017ce83          	lbu	t4,1(a5)
 1e6:	0027ce03          	lbu	t3,2(a5)
 1ea:	0037c303          	lbu	t1,3(a5)
 1ee:	0047c883          	lbu	a7,4(a5)
 1f2:	0057c803          	lbu	a6,5(a5)
 1f6:	0067c503          	lbu	a0,6(a5)
 1fa:	0077c583          	lbu	a1,7(a5)
 1fe:	0087c603          	lbu	a2,8(a5)
 202:	0097c683          	lbu	a3,9(a5)
 206:	00a7c703          	lbu	a4,10(a5)
 20a:	00b7c783          	lbu	a5,11(a5)
 20e:	fbe40423          	sb	t5,-88(s0)
 212:	fbd404a3          	sb	t4,-87(s0)
 216:	fbc40523          	sb	t3,-86(s0)
 21a:	fa6405a3          	sb	t1,-85(s0)
 21e:	fb140623          	sb	a7,-84(s0)
 222:	fb0406a3          	sb	a6,-83(s0)
 226:	faa40723          	sb	a0,-82(s0)
 22a:	fab407a3          	sb	a1,-81(s0)
 22e:	fac40823          	sb	a2,-80(s0)
 232:	fad408a3          	sb	a3,-79(s0)
 236:	fae40923          	sb	a4,-78(s0)
 23a:	faf409a3          	sb	a5,-77(s0)
 23e:	fa042a23          	sw	zero,-76(s0)
 242:	fa042c23          	sw	zero,-72(s0)
 246:	fa042e23          	sw	zero,-68(s0)
 24a:	fc042023          	sw	zero,-64(s0)
 24e:	fc042223          	sw	zero,-60(s0)
 252:	fc042423          	sw	zero,-56(s0)
 256:	fc042623          	sw	zero,-52(s0)
 25a:	fc042823          	sw	zero,-48(s0)
 25e:	fc042a23          	sw	zero,-44(s0)
 262:	fc041c23          	sh	zero,-40(s0)
  int i = strlen(message);
 266:	fa840513          	addi	a0,s0,-88
 26a:	24e000ef          	jal	4b8 <strlen>
 26e:	2501                	sext.w	a0,a0
  int j = 0;
  while(name[j] != '\0') {
 270:	fe044703          	lbu	a4,-32(s0)
 274:	c30d                	beqz	a4,296 <demo_strings+0x130>
 276:	0015079b          	addiw	a5,a0,1
 27a:	fe040693          	addi	a3,s0,-32
    message[i++] = name[j++];
 27e:	fa840613          	addi	a2,s0,-88
 282:	963e                	add	a2,a2,a5
 284:	fee60fa3          	sb	a4,-1(a2)
  while(name[j] != '\0') {
 288:	0016c703          	lbu	a4,1(a3)
 28c:	853e                	mv	a0,a5
 28e:	0785                	addi	a5,a5,1
 290:	0685                	addi	a3,a3,1
 292:	f775                	bnez	a4,27e <demo_strings+0x118>
    message[i++] = name[j++];
 294:	2501                	sext.w	a0,a0
  }
  message[i] = '\0';
 296:	ff050793          	addi	a5,a0,-16
 29a:	00878533          	add	a0,a5,s0
 29e:	fa050c23          	sb	zero,-72(a0)
  printf("Message: %s\n", message);
 2a2:	fa840593          	addi	a1,s0,-88
 2a6:	00001517          	auipc	a0,0x1
 2aa:	bca50513          	addi	a0,a0,-1078 # e70 <malloc+0x278>
 2ae:	097000ef          	jal	b44 <printf>
}
 2b2:	60e6                	ld	ra,88(sp)
 2b4:	6446                	ld	s0,80(sp)
 2b6:	6125                	addi	sp,sp,96
 2b8:	8082                	ret

00000000000002ba <demo_pointers>:

// Example 6: Pointers
void
demo_pointers(void)
{
 2ba:	1101                	addi	sp,sp,-32
 2bc:	ec06                	sd	ra,24(sp)
 2be:	e822                	sd	s0,16(sp)
 2c0:	1000                	addi	s0,sp,32
  printf("\n=== Pointers ===\n");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	bce50513          	addi	a0,a0,-1074 # e90 <malloc+0x298>
 2ca:	07b000ef          	jal	b44 <printf>
  
  int a = 5;           
 2ce:	4795                	li	a5,5
 2d0:	fef42623          	sw	a5,-20(s0)
  // a regular integer, stored somewhere in memory
  printf("a = %d\n", a);
 2d4:	4595                	li	a1,5
 2d6:	00001517          	auipc	a0,0x1
 2da:	bd250513          	addi	a0,a0,-1070 # ea8 <malloc+0x2b0>
 2de:	067000ef          	jal	b44 <printf>
  
  int *p = &a;         
 2e2:	fec40593          	addi	a1,s0,-20
 2e6:	feb43023          	sd	a1,-32(s0)
  // a pointer to an integer value, `p` stores the memory location of `a`
  printf("p = %p (address of a)\n", p);
 2ea:	00001517          	auipc	a0,0x1
 2ee:	bc650513          	addi	a0,a0,-1082 # eb0 <malloc+0x2b8>
 2f2:	053000ef          	jal	b44 <printf>
  printf("*p = %d (value at address p)\n", *p);
 2f6:	fe043783          	ld	a5,-32(s0)
 2fa:	438c                	lw	a1,0(a5)
 2fc:	00001517          	auipc	a0,0x1
 300:	bcc50513          	addi	a0,a0,-1076 # ec8 <malloc+0x2d0>
 304:	041000ef          	jal	b44 <printf>
  
  *p = 6;              
 308:	fe043783          	ld	a5,-32(s0)
 30c:	4719                	li	a4,6
 30e:	c398                	sw	a4,0(a5)
  // when outside of declarations, * is a 'dereference' operator, i.e., give me the content in the address that variable p refers to
  printf("After *p = 6:\n");
 310:	00001517          	auipc	a0,0x1
 314:	bd850513          	addi	a0,a0,-1064 # ee8 <malloc+0x2f0>
 318:	02d000ef          	jal	b44 <printf>
  printf("a = %d (changed via pointer)\n", a);
 31c:	fec42583          	lw	a1,-20(s0)
 320:	00001517          	auipc	a0,0x1
 324:	bd850513          	addi	a0,a0,-1064 # ef8 <malloc+0x300>
 328:	01d000ef          	jal	b44 <printf>
  
  int **x = &p;        
  // a pointer to a pointer, `x` stores the memory location of `p`
  
  printf("x = %p (address of p)\n", x);
 32c:	fe040593          	addi	a1,s0,-32
 330:	00001517          	auipc	a0,0x1
 334:	be850513          	addi	a0,a0,-1048 # f18 <malloc+0x320>
 338:	00d000ef          	jal	b44 <printf>
  printf("*x = %p (value at x, which is address of a)\n", *x);
 33c:	fe043583          	ld	a1,-32(s0)
 340:	00001517          	auipc	a0,0x1
 344:	bf050513          	addi	a0,a0,-1040 # f30 <malloc+0x338>
 348:	7fc000ef          	jal	b44 <printf>
  printf("**x = %d (value at address stored in p)\n", **x);
 34c:	fe043783          	ld	a5,-32(s0)
 350:	438c                	lw	a1,0(a5)
 352:	00001517          	auipc	a0,0x1
 356:	c0e50513          	addi	a0,a0,-1010 # f60 <malloc+0x368>
 35a:	7ea000ef          	jal	b44 <printf>
}
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	6105                	addi	sp,sp,32
 364:	8082                	ret

0000000000000366 <demo_file_read>:

// Example 7: File I/O - Reading a file
void
demo_file_read(char *filename)
{
 366:	de010113          	addi	sp,sp,-544
 36a:	20113c23          	sd	ra,536(sp)
 36e:	20813823          	sd	s0,528(sp)
 372:	21213023          	sd	s2,512(sp)
 376:	1400                	addi	s0,sp,544
 378:	892a                	mv	s2,a0
  printf("\n=== File Reading ===\n");
 37a:	00001517          	auipc	a0,0x1
 37e:	c1650513          	addi	a0,a0,-1002 # f90 <malloc+0x398>
 382:	7c2000ef          	jal	b44 <printf>
  char buf[512];
  int fd, n;

  
  // Open the file for reading
  fd = open(filename, 0);  // 0 = O_RDONLY
 386:	4581                	li	a1,0
 388:	854a                	mv	a0,s2
 38a:	3aa000ef          	jal	734 <open>
  if(fd < 0){
 38e:	00054d63          	bltz	a0,3a8 <demo_file_read+0x42>
 392:	20913423          	sd	s1,520(sp)
 396:	84aa                	mv	s1,a0
    printf("Error: cannot open %s\n", filename);
    return;
  }
  
  printf("Reading from %s\n", filename);
 398:	85ca                	mv	a1,s2
 39a:	00001517          	auipc	a0,0x1
 39e:	c2650513          	addi	a0,a0,-986 # fc0 <malloc+0x3c8>
 3a2:	7a2000ef          	jal	b44 <printf>
  
  // Read and print file contents
  while((n = read(fd, buf, sizeof(buf))) > 0) {
 3a6:	a831                	j	3c2 <demo_file_read+0x5c>
    printf("Error: cannot open %s\n", filename);
 3a8:	85ca                	mv	a1,s2
 3aa:	00001517          	auipc	a0,0x1
 3ae:	bfe50513          	addi	a0,a0,-1026 # fa8 <malloc+0x3b0>
 3b2:	792000ef          	jal	b44 <printf>
    return;
 3b6:	a81d                	j	3ec <demo_file_read+0x86>
    write(1, buf, n);  // Write to stdout (fd = 1)
 3b8:	de040593          	addi	a1,s0,-544
 3bc:	4505                	li	a0,1
 3be:	356000ef          	jal	714 <write>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
 3c2:	20000613          	li	a2,512
 3c6:	de040593          	addi	a1,s0,-544
 3ca:	8526                	mv	a0,s1
 3cc:	340000ef          	jal	70c <read>
 3d0:	862a                	mv	a2,a0
 3d2:	fea043e3          	bgtz	a0,3b8 <demo_file_read+0x52>
  }
  
  // Close the file
  close(fd);
 3d6:	8526                	mv	a0,s1
 3d8:	344000ef          	jal	71c <close>
  printf("\n");
 3dc:	00001517          	auipc	a0,0x1
 3e0:	bfc50513          	addi	a0,a0,-1028 # fd8 <malloc+0x3e0>
 3e4:	760000ef          	jal	b44 <printf>
 3e8:	20813483          	ld	s1,520(sp)
}
 3ec:	21813083          	ld	ra,536(sp)
 3f0:	21013403          	ld	s0,528(sp)
 3f4:	20013903          	ld	s2,512(sp)
 3f8:	22010113          	addi	sp,sp,544
 3fc:	8082                	ret

00000000000003fe <main>:

int
main(int argc, char *argv[])
{
 3fe:	1101                	addi	sp,sp,-32
 400:	ec06                	sd	ra,24(sp)
 402:	e822                	sd	s0,16(sp)
 404:	e426                	sd	s1,8(sp)
 406:	e04a                	sd	s2,0(sp)
 408:	1000                	addi	s0,sp,32
 40a:	84aa                	mv	s1,a0
 40c:	892e                	mv	s2,a1
  printf("=== Basic C Programming Examples ===\n");
 40e:	00001517          	auipc	a0,0x1
 412:	bd250513          	addi	a0,a0,-1070 # fe0 <malloc+0x3e8>
 416:	72e000ef          	jal	b44 <printf>
  
  demo_variables();
 41a:	be7ff0ef          	jal	0 <demo_variables>
  demo_functions();
 41e:	c3dff0ef          	jal	5a <demo_functions>
  demo_arrays();
 422:	c73ff0ef          	jal	94 <demo_arrays>
  demo_structs();
 426:	cfdff0ef          	jal	122 <demo_structs>
  demo_strings();
 42a:	d3dff0ef          	jal	166 <demo_strings>
  demo_pointers();
 42e:	e8dff0ef          	jal	2ba <demo_pointers>

  if (argc < 2){
 432:	4785                	li	a5,1
 434:	0097df63          	bge	a5,s1,452 <main+0x54>
    printf("<filename> not provided to read");
  }
  else{
    // pass filename from command line
    // hello_world (argv[0]) <filename> (argv[1])
    demo_file_read(argv[1]);
 438:	00893503          	ld	a0,8(s2)
 43c:	f2bff0ef          	jal	366 <demo_file_read>
  }
  
  printf("\n=== All demos complete! ===\n");
 440:	00001517          	auipc	a0,0x1
 444:	be850513          	addi	a0,a0,-1048 # 1028 <malloc+0x430>
 448:	6fc000ef          	jal	b44 <printf>
  exit(0);
 44c:	4501                	li	a0,0
 44e:	2a6000ef          	jal	6f4 <exit>
    printf("<filename> not provided to read");
 452:	00001517          	auipc	a0,0x1
 456:	bb650513          	addi	a0,a0,-1098 # 1008 <malloc+0x410>
 45a:	6ea000ef          	jal	b44 <printf>
 45e:	b7cd                	j	440 <main+0x42>

0000000000000460 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 460:	1141                	addi	sp,sp,-16
 462:	e406                	sd	ra,8(sp)
 464:	e022                	sd	s0,0(sp)
 466:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 468:	f97ff0ef          	jal	3fe <main>
  exit(r);
 46c:	288000ef          	jal	6f4 <exit>

0000000000000470 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 470:	1141                	addi	sp,sp,-16
 472:	e422                	sd	s0,8(sp)
 474:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 476:	87aa                	mv	a5,a0
 478:	0585                	addi	a1,a1,1
 47a:	0785                	addi	a5,a5,1
 47c:	fff5c703          	lbu	a4,-1(a1)
 480:	fee78fa3          	sb	a4,-1(a5)
 484:	fb75                	bnez	a4,478 <strcpy+0x8>
    ;
  return os;
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret

000000000000048c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 48c:	1141                	addi	sp,sp,-16
 48e:	e422                	sd	s0,8(sp)
 490:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 492:	00054783          	lbu	a5,0(a0)
 496:	cb91                	beqz	a5,4aa <strcmp+0x1e>
 498:	0005c703          	lbu	a4,0(a1)
 49c:	00f71763          	bne	a4,a5,4aa <strcmp+0x1e>
    p++, q++;
 4a0:	0505                	addi	a0,a0,1
 4a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4a4:	00054783          	lbu	a5,0(a0)
 4a8:	fbe5                	bnez	a5,498 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4aa:	0005c503          	lbu	a0,0(a1)
}
 4ae:	40a7853b          	subw	a0,a5,a0
 4b2:	6422                	ld	s0,8(sp)
 4b4:	0141                	addi	sp,sp,16
 4b6:	8082                	ret

00000000000004b8 <strlen>:

uint
strlen(const char *s)
{
 4b8:	1141                	addi	sp,sp,-16
 4ba:	e422                	sd	s0,8(sp)
 4bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4be:	00054783          	lbu	a5,0(a0)
 4c2:	cf91                	beqz	a5,4de <strlen+0x26>
 4c4:	0505                	addi	a0,a0,1
 4c6:	87aa                	mv	a5,a0
 4c8:	86be                	mv	a3,a5
 4ca:	0785                	addi	a5,a5,1
 4cc:	fff7c703          	lbu	a4,-1(a5)
 4d0:	ff65                	bnez	a4,4c8 <strlen+0x10>
 4d2:	40a6853b          	subw	a0,a3,a0
 4d6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
  for(n = 0; s[n]; n++)
 4de:	4501                	li	a0,0
 4e0:	bfe5                	j	4d8 <strlen+0x20>

00000000000004e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4e2:	1141                	addi	sp,sp,-16
 4e4:	e422                	sd	s0,8(sp)
 4e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4e8:	ca19                	beqz	a2,4fe <memset+0x1c>
 4ea:	87aa                	mv	a5,a0
 4ec:	1602                	slli	a2,a2,0x20
 4ee:	9201                	srli	a2,a2,0x20
 4f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4f8:	0785                	addi	a5,a5,1
 4fa:	fee79de3          	bne	a5,a4,4f4 <memset+0x12>
  }
  return dst;
}
 4fe:	6422                	ld	s0,8(sp)
 500:	0141                	addi	sp,sp,16
 502:	8082                	ret

0000000000000504 <strchr>:

char*
strchr(const char *s, char c)
{
 504:	1141                	addi	sp,sp,-16
 506:	e422                	sd	s0,8(sp)
 508:	0800                	addi	s0,sp,16
  for(; *s; s++)
 50a:	00054783          	lbu	a5,0(a0)
 50e:	cb99                	beqz	a5,524 <strchr+0x20>
    if(*s == c)
 510:	00f58763          	beq	a1,a5,51e <strchr+0x1a>
  for(; *s; s++)
 514:	0505                	addi	a0,a0,1
 516:	00054783          	lbu	a5,0(a0)
 51a:	fbfd                	bnez	a5,510 <strchr+0xc>
      return (char*)s;
  return 0;
 51c:	4501                	li	a0,0
}
 51e:	6422                	ld	s0,8(sp)
 520:	0141                	addi	sp,sp,16
 522:	8082                	ret
  return 0;
 524:	4501                	li	a0,0
 526:	bfe5                	j	51e <strchr+0x1a>

0000000000000528 <gets>:

char*
gets(char *buf, int max)
{
 528:	711d                	addi	sp,sp,-96
 52a:	ec86                	sd	ra,88(sp)
 52c:	e8a2                	sd	s0,80(sp)
 52e:	e4a6                	sd	s1,72(sp)
 530:	e0ca                	sd	s2,64(sp)
 532:	fc4e                	sd	s3,56(sp)
 534:	f852                	sd	s4,48(sp)
 536:	f456                	sd	s5,40(sp)
 538:	f05a                	sd	s6,32(sp)
 53a:	ec5e                	sd	s7,24(sp)
 53c:	1080                	addi	s0,sp,96
 53e:	8baa                	mv	s7,a0
 540:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 542:	892a                	mv	s2,a0
 544:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 546:	4aa9                	li	s5,10
 548:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 54a:	89a6                	mv	s3,s1
 54c:	2485                	addiw	s1,s1,1
 54e:	0344d663          	bge	s1,s4,57a <gets+0x52>
    cc = read(0, &c, 1);
 552:	4605                	li	a2,1
 554:	faf40593          	addi	a1,s0,-81
 558:	4501                	li	a0,0
 55a:	1b2000ef          	jal	70c <read>
    if(cc < 1)
 55e:	00a05e63          	blez	a0,57a <gets+0x52>
    buf[i++] = c;
 562:	faf44783          	lbu	a5,-81(s0)
 566:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 56a:	01578763          	beq	a5,s5,578 <gets+0x50>
 56e:	0905                	addi	s2,s2,1
 570:	fd679de3          	bne	a5,s6,54a <gets+0x22>
    buf[i++] = c;
 574:	89a6                	mv	s3,s1
 576:	a011                	j	57a <gets+0x52>
 578:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 57a:	99de                	add	s3,s3,s7
 57c:	00098023          	sb	zero,0(s3)
  return buf;
}
 580:	855e                	mv	a0,s7
 582:	60e6                	ld	ra,88(sp)
 584:	6446                	ld	s0,80(sp)
 586:	64a6                	ld	s1,72(sp)
 588:	6906                	ld	s2,64(sp)
 58a:	79e2                	ld	s3,56(sp)
 58c:	7a42                	ld	s4,48(sp)
 58e:	7aa2                	ld	s5,40(sp)
 590:	7b02                	ld	s6,32(sp)
 592:	6be2                	ld	s7,24(sp)
 594:	6125                	addi	sp,sp,96
 596:	8082                	ret

0000000000000598 <stat>:

int
stat(const char *n, struct stat *st)
{
 598:	1101                	addi	sp,sp,-32
 59a:	ec06                	sd	ra,24(sp)
 59c:	e822                	sd	s0,16(sp)
 59e:	e04a                	sd	s2,0(sp)
 5a0:	1000                	addi	s0,sp,32
 5a2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5a4:	4581                	li	a1,0
 5a6:	18e000ef          	jal	734 <open>
  if(fd < 0)
 5aa:	02054263          	bltz	a0,5ce <stat+0x36>
 5ae:	e426                	sd	s1,8(sp)
 5b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5b2:	85ca                	mv	a1,s2
 5b4:	198000ef          	jal	74c <fstat>
 5b8:	892a                	mv	s2,a0
  close(fd);
 5ba:	8526                	mv	a0,s1
 5bc:	160000ef          	jal	71c <close>
  return r;
 5c0:	64a2                	ld	s1,8(sp)
}
 5c2:	854a                	mv	a0,s2
 5c4:	60e2                	ld	ra,24(sp)
 5c6:	6442                	ld	s0,16(sp)
 5c8:	6902                	ld	s2,0(sp)
 5ca:	6105                	addi	sp,sp,32
 5cc:	8082                	ret
    return -1;
 5ce:	597d                	li	s2,-1
 5d0:	bfcd                	j	5c2 <stat+0x2a>

00000000000005d2 <atoi>:

int
atoi(const char *s)
{
 5d2:	1141                	addi	sp,sp,-16
 5d4:	e422                	sd	s0,8(sp)
 5d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5d8:	00054683          	lbu	a3,0(a0)
 5dc:	fd06879b          	addiw	a5,a3,-48
 5e0:	0ff7f793          	zext.b	a5,a5
 5e4:	4625                	li	a2,9
 5e6:	02f66863          	bltu	a2,a5,616 <atoi+0x44>
 5ea:	872a                	mv	a4,a0
  n = 0;
 5ec:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5ee:	0705                	addi	a4,a4,1
 5f0:	0025179b          	slliw	a5,a0,0x2
 5f4:	9fa9                	addw	a5,a5,a0
 5f6:	0017979b          	slliw	a5,a5,0x1
 5fa:	9fb5                	addw	a5,a5,a3
 5fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 600:	00074683          	lbu	a3,0(a4)
 604:	fd06879b          	addiw	a5,a3,-48
 608:	0ff7f793          	zext.b	a5,a5
 60c:	fef671e3          	bgeu	a2,a5,5ee <atoi+0x1c>
  return n;
}
 610:	6422                	ld	s0,8(sp)
 612:	0141                	addi	sp,sp,16
 614:	8082                	ret
  n = 0;
 616:	4501                	li	a0,0
 618:	bfe5                	j	610 <atoi+0x3e>

000000000000061a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 61a:	1141                	addi	sp,sp,-16
 61c:	e422                	sd	s0,8(sp)
 61e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 620:	02b57463          	bgeu	a0,a1,648 <memmove+0x2e>
    while(n-- > 0)
 624:	00c05f63          	blez	a2,642 <memmove+0x28>
 628:	1602                	slli	a2,a2,0x20
 62a:	9201                	srli	a2,a2,0x20
 62c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 630:	872a                	mv	a4,a0
      *dst++ = *src++;
 632:	0585                	addi	a1,a1,1
 634:	0705                	addi	a4,a4,1
 636:	fff5c683          	lbu	a3,-1(a1)
 63a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 63e:	fef71ae3          	bne	a4,a5,632 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 642:	6422                	ld	s0,8(sp)
 644:	0141                	addi	sp,sp,16
 646:	8082                	ret
    dst += n;
 648:	00c50733          	add	a4,a0,a2
    src += n;
 64c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 64e:	fec05ae3          	blez	a2,642 <memmove+0x28>
 652:	fff6079b          	addiw	a5,a2,-1
 656:	1782                	slli	a5,a5,0x20
 658:	9381                	srli	a5,a5,0x20
 65a:	fff7c793          	not	a5,a5
 65e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 660:	15fd                	addi	a1,a1,-1
 662:	177d                	addi	a4,a4,-1
 664:	0005c683          	lbu	a3,0(a1)
 668:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 66c:	fee79ae3          	bne	a5,a4,660 <memmove+0x46>
 670:	bfc9                	j	642 <memmove+0x28>

0000000000000672 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 672:	1141                	addi	sp,sp,-16
 674:	e422                	sd	s0,8(sp)
 676:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 678:	ca05                	beqz	a2,6a8 <memcmp+0x36>
 67a:	fff6069b          	addiw	a3,a2,-1
 67e:	1682                	slli	a3,a3,0x20
 680:	9281                	srli	a3,a3,0x20
 682:	0685                	addi	a3,a3,1
 684:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 686:	00054783          	lbu	a5,0(a0)
 68a:	0005c703          	lbu	a4,0(a1)
 68e:	00e79863          	bne	a5,a4,69e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 692:	0505                	addi	a0,a0,1
    p2++;
 694:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 696:	fed518e3          	bne	a0,a3,686 <memcmp+0x14>
  }
  return 0;
 69a:	4501                	li	a0,0
 69c:	a019                	j	6a2 <memcmp+0x30>
      return *p1 - *p2;
 69e:	40e7853b          	subw	a0,a5,a4
}
 6a2:	6422                	ld	s0,8(sp)
 6a4:	0141                	addi	sp,sp,16
 6a6:	8082                	ret
  return 0;
 6a8:	4501                	li	a0,0
 6aa:	bfe5                	j	6a2 <memcmp+0x30>

00000000000006ac <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6ac:	1141                	addi	sp,sp,-16
 6ae:	e406                	sd	ra,8(sp)
 6b0:	e022                	sd	s0,0(sp)
 6b2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6b4:	f67ff0ef          	jal	61a <memmove>
}
 6b8:	60a2                	ld	ra,8(sp)
 6ba:	6402                	ld	s0,0(sp)
 6bc:	0141                	addi	sp,sp,16
 6be:	8082                	ret

00000000000006c0 <sbrk>:

char *
sbrk(int n) {
 6c0:	1141                	addi	sp,sp,-16
 6c2:	e406                	sd	ra,8(sp)
 6c4:	e022                	sd	s0,0(sp)
 6c6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 6c8:	4585                	li	a1,1
 6ca:	0b2000ef          	jal	77c <sys_sbrk>
}
 6ce:	60a2                	ld	ra,8(sp)
 6d0:	6402                	ld	s0,0(sp)
 6d2:	0141                	addi	sp,sp,16
 6d4:	8082                	ret

00000000000006d6 <sbrklazy>:

char *
sbrklazy(int n) {
 6d6:	1141                	addi	sp,sp,-16
 6d8:	e406                	sd	ra,8(sp)
 6da:	e022                	sd	s0,0(sp)
 6dc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 6de:	4589                	li	a1,2
 6e0:	09c000ef          	jal	77c <sys_sbrk>
}
 6e4:	60a2                	ld	ra,8(sp)
 6e6:	6402                	ld	s0,0(sp)
 6e8:	0141                	addi	sp,sp,16
 6ea:	8082                	ret

00000000000006ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ec:	4885                	li	a7,1
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6f4:	4889                	li	a7,2
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 6fc:	488d                	li	a7,3
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 704:	4891                	li	a7,4
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <read>:
.global read
read:
 li a7, SYS_read
 70c:	4895                	li	a7,5
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <write>:
.global write
write:
 li a7, SYS_write
 714:	48c1                	li	a7,16
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <close>:
.global close
close:
 li a7, SYS_close
 71c:	48d5                	li	a7,21
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <kill>:
.global kill
kill:
 li a7, SYS_kill
 724:	4899                	li	a7,6
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <exec>:
.global exec
exec:
 li a7, SYS_exec
 72c:	489d                	li	a7,7
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <open>:
.global open
open:
 li a7, SYS_open
 734:	48bd                	li	a7,15
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 73c:	48c5                	li	a7,17
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 744:	48c9                	li	a7,18
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 74c:	48a1                	li	a7,8
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <link>:
.global link
link:
 li a7, SYS_link
 754:	48cd                	li	a7,19
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 75c:	48d1                	li	a7,20
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 764:	48a5                	li	a7,9
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <dup>:
.global dup
dup:
 li a7, SYS_dup
 76c:	48a9                	li	a7,10
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 774:	48ad                	li	a7,11
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 77c:	48b1                	li	a7,12
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <pause>:
.global pause
pause:
 li a7, SYS_pause
 784:	48b5                	li	a7,13
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 78c:	48b9                	li	a7,14
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <kps>:
.global kps
kps:
 li a7, SYS_kps
 794:	48d9                	li	a7,22
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 79c:	48dd                	li	a7,23
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 7a4:	48e1                	li	a7,24
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 7ac:	48e5                	li	a7,25
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 7b4:	48e9                	li	a7,26
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7bc:	1101                	addi	sp,sp,-32
 7be:	ec06                	sd	ra,24(sp)
 7c0:	e822                	sd	s0,16(sp)
 7c2:	1000                	addi	s0,sp,32
 7c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7c8:	4605                	li	a2,1
 7ca:	fef40593          	addi	a1,s0,-17
 7ce:	f47ff0ef          	jal	714 <write>
}
 7d2:	60e2                	ld	ra,24(sp)
 7d4:	6442                	ld	s0,16(sp)
 7d6:	6105                	addi	sp,sp,32
 7d8:	8082                	ret

00000000000007da <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 7da:	715d                	addi	sp,sp,-80
 7dc:	e486                	sd	ra,72(sp)
 7de:	e0a2                	sd	s0,64(sp)
 7e0:	f84a                	sd	s2,48(sp)
 7e2:	0880                	addi	s0,sp,80
 7e4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 7e6:	c299                	beqz	a3,7ec <printint+0x12>
 7e8:	0805c363          	bltz	a1,86e <printint+0x94>
  neg = 0;
 7ec:	4881                	li	a7,0
 7ee:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 7f2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 7f4:	00001517          	auipc	a0,0x1
 7f8:	85c50513          	addi	a0,a0,-1956 # 1050 <digits>
 7fc:	883e                	mv	a6,a5
 7fe:	2785                	addiw	a5,a5,1
 800:	02c5f733          	remu	a4,a1,a2
 804:	972a                	add	a4,a4,a0
 806:	00074703          	lbu	a4,0(a4)
 80a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 80e:	872e                	mv	a4,a1
 810:	02c5d5b3          	divu	a1,a1,a2
 814:	0685                	addi	a3,a3,1
 816:	fec773e3          	bgeu	a4,a2,7fc <printint+0x22>
  if(neg)
 81a:	00088b63          	beqz	a7,830 <printint+0x56>
    buf[i++] = '-';
 81e:	fd078793          	addi	a5,a5,-48
 822:	97a2                	add	a5,a5,s0
 824:	02d00713          	li	a4,45
 828:	fee78423          	sb	a4,-24(a5)
 82c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 830:	02f05a63          	blez	a5,864 <printint+0x8a>
 834:	fc26                	sd	s1,56(sp)
 836:	f44e                	sd	s3,40(sp)
 838:	fb840713          	addi	a4,s0,-72
 83c:	00f704b3          	add	s1,a4,a5
 840:	fff70993          	addi	s3,a4,-1
 844:	99be                	add	s3,s3,a5
 846:	37fd                	addiw	a5,a5,-1
 848:	1782                	slli	a5,a5,0x20
 84a:	9381                	srli	a5,a5,0x20
 84c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 850:	fff4c583          	lbu	a1,-1(s1)
 854:	854a                	mv	a0,s2
 856:	f67ff0ef          	jal	7bc <putc>
  while(--i >= 0)
 85a:	14fd                	addi	s1,s1,-1
 85c:	ff349ae3          	bne	s1,s3,850 <printint+0x76>
 860:	74e2                	ld	s1,56(sp)
 862:	79a2                	ld	s3,40(sp)
}
 864:	60a6                	ld	ra,72(sp)
 866:	6406                	ld	s0,64(sp)
 868:	7942                	ld	s2,48(sp)
 86a:	6161                	addi	sp,sp,80
 86c:	8082                	ret
    x = -xx;
 86e:	40b005b3          	neg	a1,a1
    neg = 1;
 872:	4885                	li	a7,1
    x = -xx;
 874:	bfad                	j	7ee <printint+0x14>

0000000000000876 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 876:	711d                	addi	sp,sp,-96
 878:	ec86                	sd	ra,88(sp)
 87a:	e8a2                	sd	s0,80(sp)
 87c:	e0ca                	sd	s2,64(sp)
 87e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 880:	0005c903          	lbu	s2,0(a1)
 884:	28090663          	beqz	s2,b10 <vprintf+0x29a>
 888:	e4a6                	sd	s1,72(sp)
 88a:	fc4e                	sd	s3,56(sp)
 88c:	f852                	sd	s4,48(sp)
 88e:	f456                	sd	s5,40(sp)
 890:	f05a                	sd	s6,32(sp)
 892:	ec5e                	sd	s7,24(sp)
 894:	e862                	sd	s8,16(sp)
 896:	e466                	sd	s9,8(sp)
 898:	8b2a                	mv	s6,a0
 89a:	8a2e                	mv	s4,a1
 89c:	8bb2                	mv	s7,a2
  state = 0;
 89e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8a0:	4481                	li	s1,0
 8a2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8a4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8a8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8ac:	06c00c93          	li	s9,108
 8b0:	a005                	j	8d0 <vprintf+0x5a>
        putc(fd, c0);
 8b2:	85ca                	mv	a1,s2
 8b4:	855a                	mv	a0,s6
 8b6:	f07ff0ef          	jal	7bc <putc>
 8ba:	a019                	j	8c0 <vprintf+0x4a>
    } else if(state == '%'){
 8bc:	03598263          	beq	s3,s5,8e0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 8c0:	2485                	addiw	s1,s1,1
 8c2:	8726                	mv	a4,s1
 8c4:	009a07b3          	add	a5,s4,s1
 8c8:	0007c903          	lbu	s2,0(a5)
 8cc:	22090a63          	beqz	s2,b00 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 8d0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8d4:	fe0994e3          	bnez	s3,8bc <vprintf+0x46>
      if(c0 == '%'){
 8d8:	fd579de3          	bne	a5,s5,8b2 <vprintf+0x3c>
        state = '%';
 8dc:	89be                	mv	s3,a5
 8de:	b7cd                	j	8c0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 8e0:	00ea06b3          	add	a3,s4,a4
 8e4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 8e8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 8ea:	c681                	beqz	a3,8f2 <vprintf+0x7c>
 8ec:	9752                	add	a4,a4,s4
 8ee:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 8f2:	05878363          	beq	a5,s8,938 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 8f6:	05978d63          	beq	a5,s9,950 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 8fa:	07500713          	li	a4,117
 8fe:	0ee78763          	beq	a5,a4,9ec <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 902:	07800713          	li	a4,120
 906:	12e78963          	beq	a5,a4,a38 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 90a:	07000713          	li	a4,112
 90e:	14e78e63          	beq	a5,a4,a6a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 912:	06300713          	li	a4,99
 916:	18e78e63          	beq	a5,a4,ab2 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 91a:	07300713          	li	a4,115
 91e:	1ae78463          	beq	a5,a4,ac6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 922:	02500713          	li	a4,37
 926:	04e79563          	bne	a5,a4,970 <vprintf+0xfa>
        putc(fd, '%');
 92a:	02500593          	li	a1,37
 92e:	855a                	mv	a0,s6
 930:	e8dff0ef          	jal	7bc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 934:	4981                	li	s3,0
 936:	b769                	j	8c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 938:	008b8913          	addi	s2,s7,8
 93c:	4685                	li	a3,1
 93e:	4629                	li	a2,10
 940:	000ba583          	lw	a1,0(s7)
 944:	855a                	mv	a0,s6
 946:	e95ff0ef          	jal	7da <printint>
 94a:	8bca                	mv	s7,s2
      state = 0;
 94c:	4981                	li	s3,0
 94e:	bf8d                	j	8c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 950:	06400793          	li	a5,100
 954:	02f68963          	beq	a3,a5,986 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 958:	06c00793          	li	a5,108
 95c:	04f68263          	beq	a3,a5,9a0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 960:	07500793          	li	a5,117
 964:	0af68063          	beq	a3,a5,a04 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 968:	07800793          	li	a5,120
 96c:	0ef68263          	beq	a3,a5,a50 <vprintf+0x1da>
        putc(fd, '%');
 970:	02500593          	li	a1,37
 974:	855a                	mv	a0,s6
 976:	e47ff0ef          	jal	7bc <putc>
        putc(fd, c0);
 97a:	85ca                	mv	a1,s2
 97c:	855a                	mv	a0,s6
 97e:	e3fff0ef          	jal	7bc <putc>
      state = 0;
 982:	4981                	li	s3,0
 984:	bf35                	j	8c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 986:	008b8913          	addi	s2,s7,8
 98a:	4685                	li	a3,1
 98c:	4629                	li	a2,10
 98e:	000bb583          	ld	a1,0(s7)
 992:	855a                	mv	a0,s6
 994:	e47ff0ef          	jal	7da <printint>
        i += 1;
 998:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 99a:	8bca                	mv	s7,s2
      state = 0;
 99c:	4981                	li	s3,0
        i += 1;
 99e:	b70d                	j	8c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9a0:	06400793          	li	a5,100
 9a4:	02f60763          	beq	a2,a5,9d2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9a8:	07500793          	li	a5,117
 9ac:	06f60963          	beq	a2,a5,a1e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9b0:	07800793          	li	a5,120
 9b4:	faf61ee3          	bne	a2,a5,970 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9b8:	008b8913          	addi	s2,s7,8
 9bc:	4681                	li	a3,0
 9be:	4641                	li	a2,16
 9c0:	000bb583          	ld	a1,0(s7)
 9c4:	855a                	mv	a0,s6
 9c6:	e15ff0ef          	jal	7da <printint>
        i += 2;
 9ca:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9cc:	8bca                	mv	s7,s2
      state = 0;
 9ce:	4981                	li	s3,0
        i += 2;
 9d0:	bdc5                	j	8c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9d2:	008b8913          	addi	s2,s7,8
 9d6:	4685                	li	a3,1
 9d8:	4629                	li	a2,10
 9da:	000bb583          	ld	a1,0(s7)
 9de:	855a                	mv	a0,s6
 9e0:	dfbff0ef          	jal	7da <printint>
        i += 2;
 9e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9e6:	8bca                	mv	s7,s2
      state = 0;
 9e8:	4981                	li	s3,0
        i += 2;
 9ea:	bdd9                	j	8c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 9ec:	008b8913          	addi	s2,s7,8
 9f0:	4681                	li	a3,0
 9f2:	4629                	li	a2,10
 9f4:	000be583          	lwu	a1,0(s7)
 9f8:	855a                	mv	a0,s6
 9fa:	de1ff0ef          	jal	7da <printint>
 9fe:	8bca                	mv	s7,s2
      state = 0;
 a00:	4981                	li	s3,0
 a02:	bd7d                	j	8c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a04:	008b8913          	addi	s2,s7,8
 a08:	4681                	li	a3,0
 a0a:	4629                	li	a2,10
 a0c:	000bb583          	ld	a1,0(s7)
 a10:	855a                	mv	a0,s6
 a12:	dc9ff0ef          	jal	7da <printint>
        i += 1;
 a16:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a18:	8bca                	mv	s7,s2
      state = 0;
 a1a:	4981                	li	s3,0
        i += 1;
 a1c:	b555                	j	8c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a1e:	008b8913          	addi	s2,s7,8
 a22:	4681                	li	a3,0
 a24:	4629                	li	a2,10
 a26:	000bb583          	ld	a1,0(s7)
 a2a:	855a                	mv	a0,s6
 a2c:	dafff0ef          	jal	7da <printint>
        i += 2;
 a30:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a32:	8bca                	mv	s7,s2
      state = 0;
 a34:	4981                	li	s3,0
        i += 2;
 a36:	b569                	j	8c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 a38:	008b8913          	addi	s2,s7,8
 a3c:	4681                	li	a3,0
 a3e:	4641                	li	a2,16
 a40:	000be583          	lwu	a1,0(s7)
 a44:	855a                	mv	a0,s6
 a46:	d95ff0ef          	jal	7da <printint>
 a4a:	8bca                	mv	s7,s2
      state = 0;
 a4c:	4981                	li	s3,0
 a4e:	bd8d                	j	8c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a50:	008b8913          	addi	s2,s7,8
 a54:	4681                	li	a3,0
 a56:	4641                	li	a2,16
 a58:	000bb583          	ld	a1,0(s7)
 a5c:	855a                	mv	a0,s6
 a5e:	d7dff0ef          	jal	7da <printint>
        i += 1;
 a62:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a64:	8bca                	mv	s7,s2
      state = 0;
 a66:	4981                	li	s3,0
        i += 1;
 a68:	bda1                	j	8c0 <vprintf+0x4a>
 a6a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a6c:	008b8d13          	addi	s10,s7,8
 a70:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a74:	03000593          	li	a1,48
 a78:	855a                	mv	a0,s6
 a7a:	d43ff0ef          	jal	7bc <putc>
  putc(fd, 'x');
 a7e:	07800593          	li	a1,120
 a82:	855a                	mv	a0,s6
 a84:	d39ff0ef          	jal	7bc <putc>
 a88:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a8a:	00000b97          	auipc	s7,0x0
 a8e:	5c6b8b93          	addi	s7,s7,1478 # 1050 <digits>
 a92:	03c9d793          	srli	a5,s3,0x3c
 a96:	97de                	add	a5,a5,s7
 a98:	0007c583          	lbu	a1,0(a5)
 a9c:	855a                	mv	a0,s6
 a9e:	d1fff0ef          	jal	7bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 aa2:	0992                	slli	s3,s3,0x4
 aa4:	397d                	addiw	s2,s2,-1
 aa6:	fe0916e3          	bnez	s2,a92 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 aaa:	8bea                	mv	s7,s10
      state = 0;
 aac:	4981                	li	s3,0
 aae:	6d02                	ld	s10,0(sp)
 ab0:	bd01                	j	8c0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 ab2:	008b8913          	addi	s2,s7,8
 ab6:	000bc583          	lbu	a1,0(s7)
 aba:	855a                	mv	a0,s6
 abc:	d01ff0ef          	jal	7bc <putc>
 ac0:	8bca                	mv	s7,s2
      state = 0;
 ac2:	4981                	li	s3,0
 ac4:	bbf5                	j	8c0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 ac6:	008b8993          	addi	s3,s7,8
 aca:	000bb903          	ld	s2,0(s7)
 ace:	00090f63          	beqz	s2,aec <vprintf+0x276>
        for(; *s; s++)
 ad2:	00094583          	lbu	a1,0(s2)
 ad6:	c195                	beqz	a1,afa <vprintf+0x284>
          putc(fd, *s);
 ad8:	855a                	mv	a0,s6
 ada:	ce3ff0ef          	jal	7bc <putc>
        for(; *s; s++)
 ade:	0905                	addi	s2,s2,1
 ae0:	00094583          	lbu	a1,0(s2)
 ae4:	f9f5                	bnez	a1,ad8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 ae6:	8bce                	mv	s7,s3
      state = 0;
 ae8:	4981                	li	s3,0
 aea:	bbd9                	j	8c0 <vprintf+0x4a>
          s = "(null)";
 aec:	00000917          	auipc	s2,0x0
 af0:	55c90913          	addi	s2,s2,1372 # 1048 <malloc+0x450>
        for(; *s; s++)
 af4:	02800593          	li	a1,40
 af8:	b7c5                	j	ad8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 afa:	8bce                	mv	s7,s3
      state = 0;
 afc:	4981                	li	s3,0
 afe:	b3c9                	j	8c0 <vprintf+0x4a>
 b00:	64a6                	ld	s1,72(sp)
 b02:	79e2                	ld	s3,56(sp)
 b04:	7a42                	ld	s4,48(sp)
 b06:	7aa2                	ld	s5,40(sp)
 b08:	7b02                	ld	s6,32(sp)
 b0a:	6be2                	ld	s7,24(sp)
 b0c:	6c42                	ld	s8,16(sp)
 b0e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 b10:	60e6                	ld	ra,88(sp)
 b12:	6446                	ld	s0,80(sp)
 b14:	6906                	ld	s2,64(sp)
 b16:	6125                	addi	sp,sp,96
 b18:	8082                	ret

0000000000000b1a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b1a:	715d                	addi	sp,sp,-80
 b1c:	ec06                	sd	ra,24(sp)
 b1e:	e822                	sd	s0,16(sp)
 b20:	1000                	addi	s0,sp,32
 b22:	e010                	sd	a2,0(s0)
 b24:	e414                	sd	a3,8(s0)
 b26:	e818                	sd	a4,16(s0)
 b28:	ec1c                	sd	a5,24(s0)
 b2a:	03043023          	sd	a6,32(s0)
 b2e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b32:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b36:	8622                	mv	a2,s0
 b38:	d3fff0ef          	jal	876 <vprintf>
}
 b3c:	60e2                	ld	ra,24(sp)
 b3e:	6442                	ld	s0,16(sp)
 b40:	6161                	addi	sp,sp,80
 b42:	8082                	ret

0000000000000b44 <printf>:

void
printf(const char *fmt, ...)
{
 b44:	711d                	addi	sp,sp,-96
 b46:	ec06                	sd	ra,24(sp)
 b48:	e822                	sd	s0,16(sp)
 b4a:	1000                	addi	s0,sp,32
 b4c:	e40c                	sd	a1,8(s0)
 b4e:	e810                	sd	a2,16(s0)
 b50:	ec14                	sd	a3,24(s0)
 b52:	f018                	sd	a4,32(s0)
 b54:	f41c                	sd	a5,40(s0)
 b56:	03043823          	sd	a6,48(s0)
 b5a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b5e:	00840613          	addi	a2,s0,8
 b62:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b66:	85aa                	mv	a1,a0
 b68:	4505                	li	a0,1
 b6a:	d0dff0ef          	jal	876 <vprintf>
}
 b6e:	60e2                	ld	ra,24(sp)
 b70:	6442                	ld	s0,16(sp)
 b72:	6125                	addi	sp,sp,96
 b74:	8082                	ret

0000000000000b76 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b76:	1141                	addi	sp,sp,-16
 b78:	e422                	sd	s0,8(sp)
 b7a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b7c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b80:	00001797          	auipc	a5,0x1
 b84:	4807b783          	ld	a5,1152(a5) # 2000 <freep>
 b88:	a02d                	j	bb2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b8a:	4618                	lw	a4,8(a2)
 b8c:	9f2d                	addw	a4,a4,a1
 b8e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b92:	6398                	ld	a4,0(a5)
 b94:	6310                	ld	a2,0(a4)
 b96:	a83d                	j	bd4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b98:	ff852703          	lw	a4,-8(a0)
 b9c:	9f31                	addw	a4,a4,a2
 b9e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ba0:	ff053683          	ld	a3,-16(a0)
 ba4:	a091                	j	be8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ba6:	6398                	ld	a4,0(a5)
 ba8:	00e7e463          	bltu	a5,a4,bb0 <free+0x3a>
 bac:	00e6ea63          	bltu	a3,a4,bc0 <free+0x4a>
{
 bb0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb2:	fed7fae3          	bgeu	a5,a3,ba6 <free+0x30>
 bb6:	6398                	ld	a4,0(a5)
 bb8:	00e6e463          	bltu	a3,a4,bc0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bbc:	fee7eae3          	bltu	a5,a4,bb0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bc0:	ff852583          	lw	a1,-8(a0)
 bc4:	6390                	ld	a2,0(a5)
 bc6:	02059813          	slli	a6,a1,0x20
 bca:	01c85713          	srli	a4,a6,0x1c
 bce:	9736                	add	a4,a4,a3
 bd0:	fae60de3          	beq	a2,a4,b8a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bd4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bd8:	4790                	lw	a2,8(a5)
 bda:	02061593          	slli	a1,a2,0x20
 bde:	01c5d713          	srli	a4,a1,0x1c
 be2:	973e                	add	a4,a4,a5
 be4:	fae68ae3          	beq	a3,a4,b98 <free+0x22>
    p->s.ptr = bp->s.ptr;
 be8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bea:	00001717          	auipc	a4,0x1
 bee:	40f73b23          	sd	a5,1046(a4) # 2000 <freep>
}
 bf2:	6422                	ld	s0,8(sp)
 bf4:	0141                	addi	sp,sp,16
 bf6:	8082                	ret

0000000000000bf8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bf8:	7139                	addi	sp,sp,-64
 bfa:	fc06                	sd	ra,56(sp)
 bfc:	f822                	sd	s0,48(sp)
 bfe:	f426                	sd	s1,40(sp)
 c00:	ec4e                	sd	s3,24(sp)
 c02:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c04:	02051493          	slli	s1,a0,0x20
 c08:	9081                	srli	s1,s1,0x20
 c0a:	04bd                	addi	s1,s1,15
 c0c:	8091                	srli	s1,s1,0x4
 c0e:	0014899b          	addiw	s3,s1,1
 c12:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c14:	00001517          	auipc	a0,0x1
 c18:	3ec53503          	ld	a0,1004(a0) # 2000 <freep>
 c1c:	c915                	beqz	a0,c50 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c1e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c20:	4798                	lw	a4,8(a5)
 c22:	08977a63          	bgeu	a4,s1,cb6 <malloc+0xbe>
 c26:	f04a                	sd	s2,32(sp)
 c28:	e852                	sd	s4,16(sp)
 c2a:	e456                	sd	s5,8(sp)
 c2c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 c2e:	8a4e                	mv	s4,s3
 c30:	0009871b          	sext.w	a4,s3
 c34:	6685                	lui	a3,0x1
 c36:	00d77363          	bgeu	a4,a3,c3c <malloc+0x44>
 c3a:	6a05                	lui	s4,0x1
 c3c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c40:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c44:	00001917          	auipc	s2,0x1
 c48:	3bc90913          	addi	s2,s2,956 # 2000 <freep>
  if(p == SBRK_ERROR)
 c4c:	5afd                	li	s5,-1
 c4e:	a081                	j	c8e <malloc+0x96>
 c50:	f04a                	sd	s2,32(sp)
 c52:	e852                	sd	s4,16(sp)
 c54:	e456                	sd	s5,8(sp)
 c56:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c58:	00001797          	auipc	a5,0x1
 c5c:	3b878793          	addi	a5,a5,952 # 2010 <base>
 c60:	00001717          	auipc	a4,0x1
 c64:	3af73023          	sd	a5,928(a4) # 2000 <freep>
 c68:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c6a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c6e:	b7c1                	j	c2e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 c70:	6398                	ld	a4,0(a5)
 c72:	e118                	sd	a4,0(a0)
 c74:	a8a9                	j	cce <malloc+0xd6>
  hp->s.size = nu;
 c76:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c7a:	0541                	addi	a0,a0,16
 c7c:	efbff0ef          	jal	b76 <free>
  return freep;
 c80:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c84:	c12d                	beqz	a0,ce6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c86:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c88:	4798                	lw	a4,8(a5)
 c8a:	02977263          	bgeu	a4,s1,cae <malloc+0xb6>
    if(p == freep)
 c8e:	00093703          	ld	a4,0(s2)
 c92:	853e                	mv	a0,a5
 c94:	fef719e3          	bne	a4,a5,c86 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c98:	8552                	mv	a0,s4
 c9a:	a27ff0ef          	jal	6c0 <sbrk>
  if(p == SBRK_ERROR)
 c9e:	fd551ce3          	bne	a0,s5,c76 <malloc+0x7e>
        return 0;
 ca2:	4501                	li	a0,0
 ca4:	7902                	ld	s2,32(sp)
 ca6:	6a42                	ld	s4,16(sp)
 ca8:	6aa2                	ld	s5,8(sp)
 caa:	6b02                	ld	s6,0(sp)
 cac:	a03d                	j	cda <malloc+0xe2>
 cae:	7902                	ld	s2,32(sp)
 cb0:	6a42                	ld	s4,16(sp)
 cb2:	6aa2                	ld	s5,8(sp)
 cb4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 cb6:	fae48de3          	beq	s1,a4,c70 <malloc+0x78>
        p->s.size -= nunits;
 cba:	4137073b          	subw	a4,a4,s3
 cbe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cc0:	02071693          	slli	a3,a4,0x20
 cc4:	01c6d713          	srli	a4,a3,0x1c
 cc8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cce:	00001717          	auipc	a4,0x1
 cd2:	32a73923          	sd	a0,818(a4) # 2000 <freep>
      return (void*)(p + 1);
 cd6:	01078513          	addi	a0,a5,16
  }
}
 cda:	70e2                	ld	ra,56(sp)
 cdc:	7442                	ld	s0,48(sp)
 cde:	74a2                	ld	s1,40(sp)
 ce0:	69e2                	ld	s3,24(sp)
 ce2:	6121                	addi	sp,sp,64
 ce4:	8082                	ret
 ce6:	7902                	ld	s2,32(sp)
 ce8:	6a42                	ld	s4,16(sp)
 cea:	6aa2                	ld	s5,8(sp)
 cec:	6b02                	ld	s6,0(sp)
 cee:	b7f5                	j	cda <malloc+0xe2>
