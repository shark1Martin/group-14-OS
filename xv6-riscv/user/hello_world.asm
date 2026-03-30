
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
   c:	d4850513          	addi	a0,a0,-696 # d50 <malloc+0x100>
  10:	389000ef          	jal	b98 <printf>
  int x = 42;
  char c = 'A';
  
  printf("Integer x = %d\n", x);
  14:	02a00593          	li	a1,42
  18:	00001517          	auipc	a0,0x1
  1c:	d6050513          	addi	a0,a0,-672 # d78 <malloc+0x128>
  20:	379000ef          	jal	b98 <printf>
  printf("Character c = %c\n", c);
  24:	04100593          	li	a1,65
  28:	00001517          	auipc	a0,0x1
  2c:	d6050513          	addi	a0,a0,-672 # d88 <malloc+0x138>
  30:	369000ef          	jal	b98 <printf>
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
  3e:	e406                	sd	ra,8(sp)
  40:	e022                	sd	s0,0(sp)
  42:	0800                	addi	s0,sp,16
  return a + b;
}
  44:	9d2d                	addw	a0,a0,a1
  46:	60a2                	ld	ra,8(sp)
  48:	6402                	ld	s0,0(sp)
  4a:	0141                	addi	sp,sp,16
  4c:	8082                	ret

000000000000004e <multiply>:

int
multiply(int a, int b)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int result = a * b;
  return result;
}
  56:	02b5053b          	mulw	a0,a0,a1
  5a:	60a2                	ld	ra,8(sp)
  5c:	6402                	ld	s0,0(sp)
  5e:	0141                	addi	sp,sp,16
  60:	8082                	ret

0000000000000062 <demo_functions>:

void
demo_functions(void)
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  printf("\n=== Functions ===\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	d3650513          	addi	a0,a0,-714 # da0 <malloc+0x150>
  72:	327000ef          	jal	b98 <printf>
  int sum = add_numbers(10, 20);
  int product = multiply(5, 7);
  
  printf("10 + 20 = %d\n", sum);
  76:	45f9                	li	a1,30
  78:	00001517          	auipc	a0,0x1
  7c:	d4050513          	addi	a0,a0,-704 # db8 <malloc+0x168>
  80:	319000ef          	jal	b98 <printf>
  printf("5 * 7 = %d\n", product);
  84:	02300593          	li	a1,35
  88:	00001517          	auipc	a0,0x1
  8c:	d4050513          	addi	a0,a0,-704 # dc8 <malloc+0x178>
  90:	309000ef          	jal	b98 <printf>
}
  94:	60a2                	ld	ra,8(sp)
  96:	6402                	ld	s0,0(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret

000000000000009c <demo_arrays>:

// Example 3: Arrays
void
demo_arrays(void)
{
  9c:	715d                	addi	sp,sp,-80
  9e:	e486                	sd	ra,72(sp)
  a0:	e0a2                	sd	s0,64(sp)
  a2:	fc26                	sd	s1,56(sp)
  a4:	f84a                	sd	s2,48(sp)
  a6:	f44e                	sd	s3,40(sp)
  a8:	f052                	sd	s4,32(sp)
  aa:	0880                	addi	s0,sp,80
  printf("\n=== Arrays ===\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	d2c50513          	addi	a0,a0,-724 # dd8 <malloc+0x188>
  b4:	2e5000ef          	jal	b98 <printf>
  int numbers[5] = {10, 20, 30, 40, 50};
  b8:	47a9                	li	a5,10
  ba:	faf42c23          	sw	a5,-72(s0)
  be:	47d1                	li	a5,20
  c0:	faf42e23          	sw	a5,-68(s0)
  c4:	47f9                	li	a5,30
  c6:	fcf42023          	sw	a5,-64(s0)
  ca:	02800793          	li	a5,40
  ce:	fcf42223          	sw	a5,-60(s0)
  d2:	03200793          	li	a5,50
  d6:	fcf42423          	sw	a5,-56(s0)
  
  printf("Array elements:\n");
  da:	00001517          	auipc	a0,0x1
  de:	d1650513          	addi	a0,a0,-746 # df0 <malloc+0x1a0>
  e2:	2b7000ef          	jal	b98 <printf>
  for(int i = 0; i < 5; i++) {
  e6:	fb840913          	addi	s2,s0,-72
  ea:	4481                	li	s1,0
    printf("  numbers[%d] = %d\n", i, numbers[i]);
  ec:	00001a17          	auipc	s4,0x1
  f0:	d1ca0a13          	addi	s4,s4,-740 # e08 <malloc+0x1b8>
  for(int i = 0; i < 5; i++) {
  f4:	4995                	li	s3,5
    printf("  numbers[%d] = %d\n", i, numbers[i]);
  f6:	00092603          	lw	a2,0(s2)
  fa:	85a6                	mv	a1,s1
  fc:	8552                	mv	a0,s4
  fe:	29b000ef          	jal	b98 <printf>
  for(int i = 0; i < 5; i++) {
 102:	2485                	addiw	s1,s1,1
 104:	0911                	addi	s2,s2,4
 106:	ff3498e3          	bne	s1,s3,f6 <demo_arrays+0x5a>
  // Calculate sum
  int sum = 0;
  for(int i = 0; i < 5; i++) {
    sum += numbers[i];
  }
  printf("Sum of array = %d\n", sum);
 10a:	09600593          	li	a1,150
 10e:	00001517          	auipc	a0,0x1
 112:	d1250513          	addi	a0,a0,-750 # e20 <malloc+0x1d0>
 116:	283000ef          	jal	b98 <printf>
}
 11a:	60a6                	ld	ra,72(sp)
 11c:	6406                	ld	s0,64(sp)
 11e:	74e2                	ld	s1,56(sp)
 120:	7942                	ld	s2,48(sp)
 122:	79a2                	ld	s3,40(sp)
 124:	7a02                	ld	s4,32(sp)
 126:	6161                	addi	sp,sp,80
 128:	8082                	ret

000000000000012a <demo_structs>:
  int id;
};

void
demo_structs(void)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e406                	sd	ra,8(sp)
 12e:	e022                	sd	s0,0(sp)
 130:	0800                	addi	s0,sp,16
  printf("\n=== Structures ===\n");
 132:	00001517          	auipc	a0,0x1
 136:	d0650513          	addi	a0,a0,-762 # e38 <malloc+0x1e8>
 13a:	25f000ef          	jal	b98 <printf>
  
  struct point p;
  p.x = 100;
  p.y = 200;
  printf("Point: (%d, %d)\n", p.x, p.y);
 13e:	0c800613          	li	a2,200
 142:	06400593          	li	a1,100
 146:	00001517          	auipc	a0,0x1
 14a:	d0a50513          	addi	a0,a0,-758 # e50 <malloc+0x200>
 14e:	24b000ef          	jal	b98 <printf>
  
  struct person student;
  student.age = 20;
  student.id = 12345;
  printf("Person: age=%d, id=%d\n", student.age, student.id);
 152:	660d                	lui	a2,0x3
 154:	03960613          	addi	a2,a2,57 # 3039 <base+0x1029>
 158:	45d1                	li	a1,20
 15a:	00001517          	auipc	a0,0x1
 15e:	d0e50513          	addi	a0,a0,-754 # e68 <malloc+0x218>
 162:	237000ef          	jal	b98 <printf>
}
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <demo_strings>:

// Example 5: Strings (character arrays)
void
demo_strings(void)
{
 16e:	7159                	addi	sp,sp,-112
 170:	f486                	sd	ra,104(sp)
 172:	f0a2                	sd	s0,96(sp)
 174:	eca6                	sd	s1,88(sp)
 176:	1880                	addi	s0,sp,112
  printf("\n=== Strings ===\n");
 178:	00001517          	auipc	a0,0x1
 17c:	d0850513          	addi	a0,a0,-760 # e80 <malloc+0x230>
 180:	219000ef          	jal	b98 <printf>
  
  char greeting[] = "Hello";
 184:	6c6c67b7          	lui	a5,0x6c6c6
 188:	54878793          	addi	a5,a5,1352 # 6c6c6548 <base+0x6c6c4538>
 18c:	fcf42c23          	sw	a5,-40(s0)
 190:	06f00793          	li	a5,111
 194:	fcf41e23          	sh	a5,-36(s0)
  char name[] = "xv6";  // Need 4 chars: 'x', 'v', '6', '\0'
 198:	003677b7          	lui	a5,0x367
 19c:	67878793          	addi	a5,a5,1656 # 367678 <base+0x365668>
 1a0:	fcf42823          	sw	a5,-48(s0)
  
  printf("Greeting: %s\n", greeting);
 1a4:	fd840593          	addi	a1,s0,-40
 1a8:	00001517          	auipc	a0,0x1
 1ac:	cf050513          	addi	a0,a0,-784 # e98 <malloc+0x248>
 1b0:	1e9000ef          	jal	b98 <printf>
  printf("Name: %s\n", name);
 1b4:	fd040493          	addi	s1,s0,-48
 1b8:	85a6                	mv	a1,s1
 1ba:	00001517          	auipc	a0,0x1
 1be:	cee50513          	addi	a0,a0,-786 # ea8 <malloc+0x258>
 1c2:	1d7000ef          	jal	b98 <printf>
  
  // String length
  int len = strlen(name);
 1c6:	8526                	mv	a0,s1
 1c8:	30c000ef          	jal	4d4 <strlen>
 1cc:	862a                	mv	a2,a0
  printf("Length of '%s' = %d\n", name, len);
 1ce:	85a6                	mv	a1,s1
 1d0:	00001517          	auipc	a0,0x1
 1d4:	ce850513          	addi	a0,a0,-792 # eb8 <malloc+0x268>
 1d8:	1c1000ef          	jal	b98 <printf>
  
  // String concatenation (manual)
  char message[50] = "Welcome to ";
 1dc:	00001797          	auipc	a5,0x1
 1e0:	d0478793          	addi	a5,a5,-764 # ee0 <malloc+0x290>
 1e4:	0007cf03          	lbu	t5,0(a5)
 1e8:	0017ce83          	lbu	t4,1(a5)
 1ec:	0027ce03          	lbu	t3,2(a5)
 1f0:	0037c303          	lbu	t1,3(a5)
 1f4:	0047c883          	lbu	a7,4(a5)
 1f8:	0057c803          	lbu	a6,5(a5)
 1fc:	0067c503          	lbu	a0,6(a5)
 200:	0077c583          	lbu	a1,7(a5)
 204:	0087c603          	lbu	a2,8(a5)
 208:	0097c683          	lbu	a3,9(a5)
 20c:	00a7c703          	lbu	a4,10(a5)
 210:	f9e40c23          	sb	t5,-104(s0)
 214:	f9d40ca3          	sb	t4,-103(s0)
 218:	f9c40d23          	sb	t3,-102(s0)
 21c:	f8640da3          	sb	t1,-101(s0)
 220:	f9140e23          	sb	a7,-100(s0)
 224:	f9040ea3          	sb	a6,-99(s0)
 228:	f8a40f23          	sb	a0,-98(s0)
 22c:	f8b40fa3          	sb	a1,-97(s0)
 230:	fac40023          	sb	a2,-96(s0)
 234:	fad400a3          	sb	a3,-95(s0)
 238:	fae40123          	sb	a4,-94(s0)
 23c:	00b7c783          	lbu	a5,11(a5)
 240:	faf401a3          	sb	a5,-93(s0)
 244:	fa042223          	sw	zero,-92(s0)
 248:	fa042423          	sw	zero,-88(s0)
 24c:	fa042623          	sw	zero,-84(s0)
 250:	fa042823          	sw	zero,-80(s0)
 254:	fa042a23          	sw	zero,-76(s0)
 258:	fa042c23          	sw	zero,-72(s0)
 25c:	fa042e23          	sw	zero,-68(s0)
 260:	fc042023          	sw	zero,-64(s0)
 264:	fc042223          	sw	zero,-60(s0)
 268:	fc041423          	sh	zero,-56(s0)
  int i = strlen(message);
 26c:	f9840513          	addi	a0,s0,-104
 270:	264000ef          	jal	4d4 <strlen>
 274:	86aa                	mv	a3,a0
  int j = 0;
  while(name[j] != '\0') {
 276:	fd044703          	lbu	a4,-48(s0)
 27a:	cf09                	beqz	a4,294 <demo_strings+0x126>
 27c:	f9840793          	addi	a5,s0,-104
 280:	953e                	add	a0,a0,a5
 282:	87a6                	mv	a5,s1
    message[i++] = name[j++];
 284:	2685                	addiw	a3,a3,1
 286:	00e50023          	sb	a4,0(a0)
  while(name[j] != '\0') {
 28a:	0017c703          	lbu	a4,1(a5)
 28e:	0505                	addi	a0,a0,1
 290:	0785                	addi	a5,a5,1
 292:	fb6d                	bnez	a4,284 <demo_strings+0x116>
  }
  message[i] = '\0';
 294:	fe068793          	addi	a5,a3,-32
 298:	008786b3          	add	a3,a5,s0
 29c:	fa068c23          	sb	zero,-72(a3)
  printf("Message: %s\n", message);
 2a0:	f9840593          	addi	a1,s0,-104
 2a4:	00001517          	auipc	a0,0x1
 2a8:	c2c50513          	addi	a0,a0,-980 # ed0 <malloc+0x280>
 2ac:	0ed000ef          	jal	b98 <printf>
}
 2b0:	70a6                	ld	ra,104(sp)
 2b2:	7406                	ld	s0,96(sp)
 2b4:	64e6                	ld	s1,88(sp)
 2b6:	6165                	addi	sp,sp,112
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
 2c6:	c2e50513          	addi	a0,a0,-978 # ef0 <malloc+0x2a0>
 2ca:	0cf000ef          	jal	b98 <printf>
  
  int a = 5;           
 2ce:	4795                	li	a5,5
 2d0:	fef42623          	sw	a5,-20(s0)
  // a regular integer, stored somewhere in memory
  printf("a = %d\n", a);
 2d4:	85be                	mv	a1,a5
 2d6:	00001517          	auipc	a0,0x1
 2da:	c3250513          	addi	a0,a0,-974 # f08 <malloc+0x2b8>
 2de:	0bb000ef          	jal	b98 <printf>
  
  int *p = &a;         
 2e2:	fec40593          	addi	a1,s0,-20
 2e6:	feb43023          	sd	a1,-32(s0)
  // a pointer to an integer value, `p` stores the memory location of `a`
  printf("p = %p (address of a)\n", p);
 2ea:	00001517          	auipc	a0,0x1
 2ee:	c2650513          	addi	a0,a0,-986 # f10 <malloc+0x2c0>
 2f2:	0a7000ef          	jal	b98 <printf>
  printf("*p = %d (value at address p)\n", *p);
 2f6:	fe043783          	ld	a5,-32(s0)
 2fa:	438c                	lw	a1,0(a5)
 2fc:	00001517          	auipc	a0,0x1
 300:	c2c50513          	addi	a0,a0,-980 # f28 <malloc+0x2d8>
 304:	095000ef          	jal	b98 <printf>
  
  *p = 6;              
 308:	fe043783          	ld	a5,-32(s0)
 30c:	4719                	li	a4,6
 30e:	c398                	sw	a4,0(a5)
  // when outside of declarations, * is a 'dereference' operator, i.e., give me the content in the address that variable p refers to
  printf("After *p = 6:\n");
 310:	00001517          	auipc	a0,0x1
 314:	c3850513          	addi	a0,a0,-968 # f48 <malloc+0x2f8>
 318:	081000ef          	jal	b98 <printf>
  printf("a = %d (changed via pointer)\n", a);
 31c:	fec42583          	lw	a1,-20(s0)
 320:	00001517          	auipc	a0,0x1
 324:	c3850513          	addi	a0,a0,-968 # f58 <malloc+0x308>
 328:	071000ef          	jal	b98 <printf>
  
  int **x = &p;        
  // a pointer to a pointer, `x` stores the memory location of `p`
  
  printf("x = %p (address of p)\n", x);
 32c:	fe040593          	addi	a1,s0,-32
 330:	00001517          	auipc	a0,0x1
 334:	c4850513          	addi	a0,a0,-952 # f78 <malloc+0x328>
 338:	061000ef          	jal	b98 <printf>
  printf("*x = %p (value at x, which is address of a)\n", *x);
 33c:	fe043583          	ld	a1,-32(s0)
 340:	00001517          	auipc	a0,0x1
 344:	c5050513          	addi	a0,a0,-944 # f90 <malloc+0x340>
 348:	051000ef          	jal	b98 <printf>
  printf("**x = %d (value at address stored in p)\n", **x);
 34c:	fe043783          	ld	a5,-32(s0)
 350:	438c                	lw	a1,0(a5)
 352:	00001517          	auipc	a0,0x1
 356:	c6e50513          	addi	a0,a0,-914 # fc0 <malloc+0x370>
 35a:	03f000ef          	jal	b98 <printf>
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
 366:	dd010113          	addi	sp,sp,-560
 36a:	22113423          	sd	ra,552(sp)
 36e:	22813023          	sd	s0,544(sp)
 372:	20913c23          	sd	s1,536(sp)
 376:	1c00                	addi	s0,sp,560
 378:	84aa                	mv	s1,a0
  printf("\n=== File Reading ===\n");
 37a:	00001517          	auipc	a0,0x1
 37e:	c7650513          	addi	a0,a0,-906 # ff0 <malloc+0x3a0>
 382:	017000ef          	jal	b98 <printf>
  char buf[512];
  int fd, n;

  
  // Open the file for reading
  fd = open(filename, 0);  // 0 = O_RDONLY
 386:	4581                	li	a1,0
 388:	8526                	mv	a0,s1
 38a:	3e0000ef          	jal	76a <open>
  if(fd < 0){
 38e:	02054663          	bltz	a0,3ba <demo_file_read+0x54>
 392:	21213823          	sd	s2,528(sp)
 396:	21313423          	sd	s3,520(sp)
 39a:	21413023          	sd	s4,512(sp)
 39e:	892a                	mv	s2,a0
    printf("Error: cannot open %s\n", filename);
    return;
  }
  
  printf("Reading from %s\n", filename);
 3a0:	85a6                	mv	a1,s1
 3a2:	00001517          	auipc	a0,0x1
 3a6:	c7e50513          	addi	a0,a0,-898 # 1020 <malloc+0x3d0>
 3aa:	7ee000ef          	jal	b98 <printf>
  
  // Read and print file contents
  while((n = read(fd, buf, sizeof(buf))) > 0) {
 3ae:	dd040493          	addi	s1,s0,-560
 3b2:	20000993          	li	s3,512
    write(1, buf, n);  // Write to stdout (fd = 1)
 3b6:	4a05                	li	s4,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
 3b8:	a829                	j	3d2 <demo_file_read+0x6c>
    printf("Error: cannot open %s\n", filename);
 3ba:	85a6                	mv	a1,s1
 3bc:	00001517          	auipc	a0,0x1
 3c0:	c4c50513          	addi	a0,a0,-948 # 1008 <malloc+0x3b8>
 3c4:	7d4000ef          	jal	b98 <printf>
    return;
 3c8:	a825                	j	400 <demo_file_read+0x9a>
    write(1, buf, n);  // Write to stdout (fd = 1)
 3ca:	85a6                	mv	a1,s1
 3cc:	8552                	mv	a0,s4
 3ce:	37c000ef          	jal	74a <write>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
 3d2:	864e                	mv	a2,s3
 3d4:	85a6                	mv	a1,s1
 3d6:	854a                	mv	a0,s2
 3d8:	36a000ef          	jal	742 <read>
 3dc:	862a                	mv	a2,a0
 3de:	fea046e3          	bgtz	a0,3ca <demo_file_read+0x64>
  }
  
  // Close the file
  close(fd);
 3e2:	854a                	mv	a0,s2
 3e4:	36e000ef          	jal	752 <close>
  printf("\n");
 3e8:	00001517          	auipc	a0,0x1
 3ec:	c5050513          	addi	a0,a0,-944 # 1038 <malloc+0x3e8>
 3f0:	7a8000ef          	jal	b98 <printf>
 3f4:	21013903          	ld	s2,528(sp)
 3f8:	20813983          	ld	s3,520(sp)
 3fc:	20013a03          	ld	s4,512(sp)
}
 400:	22813083          	ld	ra,552(sp)
 404:	22013403          	ld	s0,544(sp)
 408:	21813483          	ld	s1,536(sp)
 40c:	23010113          	addi	sp,sp,560
 410:	8082                	ret

0000000000000412 <main>:

int
main(int argc, char *argv[])
{
 412:	1101                	addi	sp,sp,-32
 414:	ec06                	sd	ra,24(sp)
 416:	e822                	sd	s0,16(sp)
 418:	e426                	sd	s1,8(sp)
 41a:	e04a                	sd	s2,0(sp)
 41c:	1000                	addi	s0,sp,32
 41e:	84aa                	mv	s1,a0
 420:	892e                	mv	s2,a1
  printf("=== Basic C Programming Examples ===\n");
 422:	00001517          	auipc	a0,0x1
 426:	c1e50513          	addi	a0,a0,-994 # 1040 <malloc+0x3f0>
 42a:	76e000ef          	jal	b98 <printf>
  
  demo_variables();
 42e:	bd3ff0ef          	jal	0 <demo_variables>
  demo_functions();
 432:	c31ff0ef          	jal	62 <demo_functions>
  demo_arrays();
 436:	c67ff0ef          	jal	9c <demo_arrays>
  demo_structs();
 43a:	cf1ff0ef          	jal	12a <demo_structs>
  demo_strings();
 43e:	d31ff0ef          	jal	16e <demo_strings>
  demo_pointers();
 442:	e79ff0ef          	jal	2ba <demo_pointers>

  if (argc < 2){
 446:	4785                	li	a5,1
 448:	0097df63          	bge	a5,s1,466 <main+0x54>
    printf("<filename> not provided to read");
  }
  else{
    // pass filename from command line
    // hello_world (argv[0]) <filename> (argv[1])
    demo_file_read(argv[1]);
 44c:	00893503          	ld	a0,8(s2)
 450:	f17ff0ef          	jal	366 <demo_file_read>
  }
  
  printf("\n=== All demos complete! ===\n");
 454:	00001517          	auipc	a0,0x1
 458:	c3450513          	addi	a0,a0,-972 # 1088 <malloc+0x438>
 45c:	73c000ef          	jal	b98 <printf>
  exit(0);
 460:	4501                	li	a0,0
 462:	2c8000ef          	jal	72a <exit>
    printf("<filename> not provided to read");
 466:	00001517          	auipc	a0,0x1
 46a:	c0250513          	addi	a0,a0,-1022 # 1068 <malloc+0x418>
 46e:	72a000ef          	jal	b98 <printf>
 472:	b7cd                	j	454 <main+0x42>

0000000000000474 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 474:	1141                	addi	sp,sp,-16
 476:	e406                	sd	ra,8(sp)
 478:	e022                	sd	s0,0(sp)
 47a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 47c:	f97ff0ef          	jal	412 <main>
  exit(r);
 480:	2aa000ef          	jal	72a <exit>

0000000000000484 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 484:	1141                	addi	sp,sp,-16
 486:	e406                	sd	ra,8(sp)
 488:	e022                	sd	s0,0(sp)
 48a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 48c:	87aa                	mv	a5,a0
 48e:	0585                	addi	a1,a1,1
 490:	0785                	addi	a5,a5,1
 492:	fff5c703          	lbu	a4,-1(a1)
 496:	fee78fa3          	sb	a4,-1(a5)
 49a:	fb75                	bnez	a4,48e <strcpy+0xa>
    ;
  return os;
}
 49c:	60a2                	ld	ra,8(sp)
 49e:	6402                	ld	s0,0(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret

00000000000004a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e406                	sd	ra,8(sp)
 4a8:	e022                	sd	s0,0(sp)
 4aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4ac:	00054783          	lbu	a5,0(a0)
 4b0:	cb91                	beqz	a5,4c4 <strcmp+0x20>
 4b2:	0005c703          	lbu	a4,0(a1)
 4b6:	00f71763          	bne	a4,a5,4c4 <strcmp+0x20>
    p++, q++;
 4ba:	0505                	addi	a0,a0,1
 4bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4be:	00054783          	lbu	a5,0(a0)
 4c2:	fbe5                	bnez	a5,4b2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 4c4:	0005c503          	lbu	a0,0(a1)
}
 4c8:	40a7853b          	subw	a0,a5,a0
 4cc:	60a2                	ld	ra,8(sp)
 4ce:	6402                	ld	s0,0(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret

00000000000004d4 <strlen>:

uint
strlen(const char *s)
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e406                	sd	ra,8(sp)
 4d8:	e022                	sd	s0,0(sp)
 4da:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4dc:	00054783          	lbu	a5,0(a0)
 4e0:	cf91                	beqz	a5,4fc <strlen+0x28>
 4e2:	00150793          	addi	a5,a0,1
 4e6:	86be                	mv	a3,a5
 4e8:	0785                	addi	a5,a5,1
 4ea:	fff7c703          	lbu	a4,-1(a5)
 4ee:	ff65                	bnez	a4,4e6 <strlen+0x12>
 4f0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 4f4:	60a2                	ld	ra,8(sp)
 4f6:	6402                	ld	s0,0(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret
  for(n = 0; s[n]; n++)
 4fc:	4501                	li	a0,0
 4fe:	bfdd                	j	4f4 <strlen+0x20>

0000000000000500 <memset>:

void*
memset(void *dst, int c, uint n)
{
 500:	1141                	addi	sp,sp,-16
 502:	e406                	sd	ra,8(sp)
 504:	e022                	sd	s0,0(sp)
 506:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 508:	ca19                	beqz	a2,51e <memset+0x1e>
 50a:	87aa                	mv	a5,a0
 50c:	1602                	slli	a2,a2,0x20
 50e:	9201                	srli	a2,a2,0x20
 510:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 514:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 518:	0785                	addi	a5,a5,1
 51a:	fee79de3          	bne	a5,a4,514 <memset+0x14>
  }
  return dst;
}
 51e:	60a2                	ld	ra,8(sp)
 520:	6402                	ld	s0,0(sp)
 522:	0141                	addi	sp,sp,16
 524:	8082                	ret

0000000000000526 <strchr>:

char*
strchr(const char *s, char c)
{
 526:	1141                	addi	sp,sp,-16
 528:	e406                	sd	ra,8(sp)
 52a:	e022                	sd	s0,0(sp)
 52c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 52e:	00054783          	lbu	a5,0(a0)
 532:	cf81                	beqz	a5,54a <strchr+0x24>
    if(*s == c)
 534:	00f58763          	beq	a1,a5,542 <strchr+0x1c>
  for(; *s; s++)
 538:	0505                	addi	a0,a0,1
 53a:	00054783          	lbu	a5,0(a0)
 53e:	fbfd                	bnez	a5,534 <strchr+0xe>
      return (char*)s;
  return 0;
 540:	4501                	li	a0,0
}
 542:	60a2                	ld	ra,8(sp)
 544:	6402                	ld	s0,0(sp)
 546:	0141                	addi	sp,sp,16
 548:	8082                	ret
  return 0;
 54a:	4501                	li	a0,0
 54c:	bfdd                	j	542 <strchr+0x1c>

000000000000054e <gets>:

char*
gets(char *buf, int max)
{
 54e:	711d                	addi	sp,sp,-96
 550:	ec86                	sd	ra,88(sp)
 552:	e8a2                	sd	s0,80(sp)
 554:	e4a6                	sd	s1,72(sp)
 556:	e0ca                	sd	s2,64(sp)
 558:	fc4e                	sd	s3,56(sp)
 55a:	f852                	sd	s4,48(sp)
 55c:	f456                	sd	s5,40(sp)
 55e:	f05a                	sd	s6,32(sp)
 560:	ec5e                	sd	s7,24(sp)
 562:	e862                	sd	s8,16(sp)
 564:	1080                	addi	s0,sp,96
 566:	8baa                	mv	s7,a0
 568:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 56a:	892a                	mv	s2,a0
 56c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 56e:	faf40b13          	addi	s6,s0,-81
 572:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 574:	8c26                	mv	s8,s1
 576:	0014899b          	addiw	s3,s1,1
 57a:	84ce                	mv	s1,s3
 57c:	0349d463          	bge	s3,s4,5a4 <gets+0x56>
    cc = read(0, &c, 1);
 580:	8656                	mv	a2,s5
 582:	85da                	mv	a1,s6
 584:	4501                	li	a0,0
 586:	1bc000ef          	jal	742 <read>
    if(cc < 1)
 58a:	00a05d63          	blez	a0,5a4 <gets+0x56>
      break;
    buf[i++] = c;
 58e:	faf44783          	lbu	a5,-81(s0)
 592:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 596:	0905                	addi	s2,s2,1
 598:	ff678713          	addi	a4,a5,-10
 59c:	c319                	beqz	a4,5a2 <gets+0x54>
 59e:	17cd                	addi	a5,a5,-13
 5a0:	fbf1                	bnez	a5,574 <gets+0x26>
    buf[i++] = c;
 5a2:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 5a4:	9c5e                	add	s8,s8,s7
 5a6:	000c0023          	sb	zero,0(s8)
  return buf;
}
 5aa:	855e                	mv	a0,s7
 5ac:	60e6                	ld	ra,88(sp)
 5ae:	6446                	ld	s0,80(sp)
 5b0:	64a6                	ld	s1,72(sp)
 5b2:	6906                	ld	s2,64(sp)
 5b4:	79e2                	ld	s3,56(sp)
 5b6:	7a42                	ld	s4,48(sp)
 5b8:	7aa2                	ld	s5,40(sp)
 5ba:	7b02                	ld	s6,32(sp)
 5bc:	6be2                	ld	s7,24(sp)
 5be:	6c42                	ld	s8,16(sp)
 5c0:	6125                	addi	sp,sp,96
 5c2:	8082                	ret

00000000000005c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 5c4:	1101                	addi	sp,sp,-32
 5c6:	ec06                	sd	ra,24(sp)
 5c8:	e822                	sd	s0,16(sp)
 5ca:	e04a                	sd	s2,0(sp)
 5cc:	1000                	addi	s0,sp,32
 5ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5d0:	4581                	li	a1,0
 5d2:	198000ef          	jal	76a <open>
  if(fd < 0)
 5d6:	02054263          	bltz	a0,5fa <stat+0x36>
 5da:	e426                	sd	s1,8(sp)
 5dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5de:	85ca                	mv	a1,s2
 5e0:	1a2000ef          	jal	782 <fstat>
 5e4:	892a                	mv	s2,a0
  close(fd);
 5e6:	8526                	mv	a0,s1
 5e8:	16a000ef          	jal	752 <close>
  return r;
 5ec:	64a2                	ld	s1,8(sp)
}
 5ee:	854a                	mv	a0,s2
 5f0:	60e2                	ld	ra,24(sp)
 5f2:	6442                	ld	s0,16(sp)
 5f4:	6902                	ld	s2,0(sp)
 5f6:	6105                	addi	sp,sp,32
 5f8:	8082                	ret
    return -1;
 5fa:	57fd                	li	a5,-1
 5fc:	893e                	mv	s2,a5
 5fe:	bfc5                	j	5ee <stat+0x2a>

0000000000000600 <atoi>:

int
atoi(const char *s)
{
 600:	1141                	addi	sp,sp,-16
 602:	e406                	sd	ra,8(sp)
 604:	e022                	sd	s0,0(sp)
 606:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 608:	00054683          	lbu	a3,0(a0)
 60c:	fd06879b          	addiw	a5,a3,-48
 610:	0ff7f793          	zext.b	a5,a5
 614:	4625                	li	a2,9
 616:	02f66963          	bltu	a2,a5,648 <atoi+0x48>
 61a:	872a                	mv	a4,a0
  n = 0;
 61c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 61e:	0705                	addi	a4,a4,1
 620:	0025179b          	slliw	a5,a0,0x2
 624:	9fa9                	addw	a5,a5,a0
 626:	0017979b          	slliw	a5,a5,0x1
 62a:	9fb5                	addw	a5,a5,a3
 62c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 630:	00074683          	lbu	a3,0(a4)
 634:	fd06879b          	addiw	a5,a3,-48
 638:	0ff7f793          	zext.b	a5,a5
 63c:	fef671e3          	bgeu	a2,a5,61e <atoi+0x1e>
  return n;
}
 640:	60a2                	ld	ra,8(sp)
 642:	6402                	ld	s0,0(sp)
 644:	0141                	addi	sp,sp,16
 646:	8082                	ret
  n = 0;
 648:	4501                	li	a0,0
 64a:	bfdd                	j	640 <atoi+0x40>

000000000000064c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 64c:	1141                	addi	sp,sp,-16
 64e:	e406                	sd	ra,8(sp)
 650:	e022                	sd	s0,0(sp)
 652:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 654:	02b57563          	bgeu	a0,a1,67e <memmove+0x32>
    while(n-- > 0)
 658:	00c05f63          	blez	a2,676 <memmove+0x2a>
 65c:	1602                	slli	a2,a2,0x20
 65e:	9201                	srli	a2,a2,0x20
 660:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 664:	872a                	mv	a4,a0
      *dst++ = *src++;
 666:	0585                	addi	a1,a1,1
 668:	0705                	addi	a4,a4,1
 66a:	fff5c683          	lbu	a3,-1(a1)
 66e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 672:	fee79ae3          	bne	a5,a4,666 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 676:	60a2                	ld	ra,8(sp)
 678:	6402                	ld	s0,0(sp)
 67a:	0141                	addi	sp,sp,16
 67c:	8082                	ret
    while(n-- > 0)
 67e:	fec05ce3          	blez	a2,676 <memmove+0x2a>
    dst += n;
 682:	00c50733          	add	a4,a0,a2
    src += n;
 686:	95b2                	add	a1,a1,a2
 688:	fff6079b          	addiw	a5,a2,-1
 68c:	1782                	slli	a5,a5,0x20
 68e:	9381                	srli	a5,a5,0x20
 690:	fff7c793          	not	a5,a5
 694:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 696:	15fd                	addi	a1,a1,-1
 698:	177d                	addi	a4,a4,-1
 69a:	0005c683          	lbu	a3,0(a1)
 69e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6a2:	fef71ae3          	bne	a4,a5,696 <memmove+0x4a>
 6a6:	bfc1                	j	676 <memmove+0x2a>

00000000000006a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6a8:	1141                	addi	sp,sp,-16
 6aa:	e406                	sd	ra,8(sp)
 6ac:	e022                	sd	s0,0(sp)
 6ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6b0:	c61d                	beqz	a2,6de <memcmp+0x36>
 6b2:	1602                	slli	a2,a2,0x20
 6b4:	9201                	srli	a2,a2,0x20
 6b6:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 6ba:	00054783          	lbu	a5,0(a0)
 6be:	0005c703          	lbu	a4,0(a1)
 6c2:	00e79863          	bne	a5,a4,6d2 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 6c6:	0505                	addi	a0,a0,1
    p2++;
 6c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6ca:	fed518e3          	bne	a0,a3,6ba <memcmp+0x12>
  }
  return 0;
 6ce:	4501                	li	a0,0
 6d0:	a019                	j	6d6 <memcmp+0x2e>
      return *p1 - *p2;
 6d2:	40e7853b          	subw	a0,a5,a4
}
 6d6:	60a2                	ld	ra,8(sp)
 6d8:	6402                	ld	s0,0(sp)
 6da:	0141                	addi	sp,sp,16
 6dc:	8082                	ret
  return 0;
 6de:	4501                	li	a0,0
 6e0:	bfdd                	j	6d6 <memcmp+0x2e>

00000000000006e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6e2:	1141                	addi	sp,sp,-16
 6e4:	e406                	sd	ra,8(sp)
 6e6:	e022                	sd	s0,0(sp)
 6e8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6ea:	f63ff0ef          	jal	64c <memmove>
}
 6ee:	60a2                	ld	ra,8(sp)
 6f0:	6402                	ld	s0,0(sp)
 6f2:	0141                	addi	sp,sp,16
 6f4:	8082                	ret

00000000000006f6 <sbrk>:

char *
sbrk(int n) {
 6f6:	1141                	addi	sp,sp,-16
 6f8:	e406                	sd	ra,8(sp)
 6fa:	e022                	sd	s0,0(sp)
 6fc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 6fe:	4585                	li	a1,1
 700:	0b2000ef          	jal	7b2 <sys_sbrk>
}
 704:	60a2                	ld	ra,8(sp)
 706:	6402                	ld	s0,0(sp)
 708:	0141                	addi	sp,sp,16
 70a:	8082                	ret

000000000000070c <sbrklazy>:

char *
sbrklazy(int n) {
 70c:	1141                	addi	sp,sp,-16
 70e:	e406                	sd	ra,8(sp)
 710:	e022                	sd	s0,0(sp)
 712:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 714:	4589                	li	a1,2
 716:	09c000ef          	jal	7b2 <sys_sbrk>
}
 71a:	60a2                	ld	ra,8(sp)
 71c:	6402                	ld	s0,0(sp)
 71e:	0141                	addi	sp,sp,16
 720:	8082                	ret

0000000000000722 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 722:	4885                	li	a7,1
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <exit>:
.global exit
exit:
 li a7, SYS_exit
 72a:	4889                	li	a7,2
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <wait>:
.global wait
wait:
 li a7, SYS_wait
 732:	488d                	li	a7,3
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 73a:	4891                	li	a7,4
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <read>:
.global read
read:
 li a7, SYS_read
 742:	4895                	li	a7,5
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <write>:
.global write
write:
 li a7, SYS_write
 74a:	48c1                	li	a7,16
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <close>:
.global close
close:
 li a7, SYS_close
 752:	48d5                	li	a7,21
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <kill>:
.global kill
kill:
 li a7, SYS_kill
 75a:	4899                	li	a7,6
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <exec>:
.global exec
exec:
 li a7, SYS_exec
 762:	489d                	li	a7,7
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <open>:
.global open
open:
 li a7, SYS_open
 76a:	48bd                	li	a7,15
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 772:	48c5                	li	a7,17
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 77a:	48c9                	li	a7,18
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 782:	48a1                	li	a7,8
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <link>:
.global link
link:
 li a7, SYS_link
 78a:	48cd                	li	a7,19
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 792:	48d1                	li	a7,20
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 79a:	48a5                	li	a7,9
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7a2:	48a9                	li	a7,10
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7aa:	48ad                	li	a7,11
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 7b2:	48b1                	li	a7,12
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <pause>:
.global pause
pause:
 li a7, SYS_pause
 7ba:	48b5                	li	a7,13
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7c2:	48b9                	li	a7,14
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <kps>:
.global kps
kps:
 li a7, SYS_kps
 7ca:	48d9                	li	a7,22
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <getenergy>:
.global getenergy
getenergy:
 li a7, SYS_getenergy
 7d2:	48dd                	li	a7,23
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <dlockacq>:
.global dlockacq
dlockacq:
 li a7, SYS_dlockacq
 7da:	48e1                	li	a7,24
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <dlockrel>:
.global dlockrel
dlockrel:
 li a7, SYS_dlockrel
 7e2:	48e5                	li	a7,25
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <check_deadlock>:
.global check_deadlock
check_deadlock:
 li a7, SYS_check_deadlock
 7ea:	48e9                	li	a7,26
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7f2:	1101                	addi	sp,sp,-32
 7f4:	ec06                	sd	ra,24(sp)
 7f6:	e822                	sd	s0,16(sp)
 7f8:	1000                	addi	s0,sp,32
 7fa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7fe:	4605                	li	a2,1
 800:	fef40593          	addi	a1,s0,-17
 804:	f47ff0ef          	jal	74a <write>
}
 808:	60e2                	ld	ra,24(sp)
 80a:	6442                	ld	s0,16(sp)
 80c:	6105                	addi	sp,sp,32
 80e:	8082                	ret

0000000000000810 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 810:	715d                	addi	sp,sp,-80
 812:	e486                	sd	ra,72(sp)
 814:	e0a2                	sd	s0,64(sp)
 816:	f84a                	sd	s2,48(sp)
 818:	f44e                	sd	s3,40(sp)
 81a:	0880                	addi	s0,sp,80
 81c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 81e:	c6d1                	beqz	a3,8aa <printint+0x9a>
 820:	0805d563          	bgez	a1,8aa <printint+0x9a>
    neg = 1;
    x = -xx;
 824:	40b005b3          	neg	a1,a1
    neg = 1;
 828:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 82a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 82e:	86ce                	mv	a3,s3
  i = 0;
 830:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 832:	00001817          	auipc	a6,0x1
 836:	87e80813          	addi	a6,a6,-1922 # 10b0 <digits>
 83a:	88ba                	mv	a7,a4
 83c:	0017051b          	addiw	a0,a4,1
 840:	872a                	mv	a4,a0
 842:	02c5f7b3          	remu	a5,a1,a2
 846:	97c2                	add	a5,a5,a6
 848:	0007c783          	lbu	a5,0(a5)
 84c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 850:	87ae                	mv	a5,a1
 852:	02c5d5b3          	divu	a1,a1,a2
 856:	0685                	addi	a3,a3,1
 858:	fec7f1e3          	bgeu	a5,a2,83a <printint+0x2a>
  if(neg)
 85c:	00030c63          	beqz	t1,874 <printint+0x64>
    buf[i++] = '-';
 860:	fd050793          	addi	a5,a0,-48
 864:	00878533          	add	a0,a5,s0
 868:	02d00793          	li	a5,45
 86c:	fef50423          	sb	a5,-24(a0)
 870:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 874:	02e05563          	blez	a4,89e <printint+0x8e>
 878:	fc26                	sd	s1,56(sp)
 87a:	377d                	addiw	a4,a4,-1
 87c:	00e984b3          	add	s1,s3,a4
 880:	19fd                	addi	s3,s3,-1
 882:	99ba                	add	s3,s3,a4
 884:	1702                	slli	a4,a4,0x20
 886:	9301                	srli	a4,a4,0x20
 888:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 88c:	0004c583          	lbu	a1,0(s1)
 890:	854a                	mv	a0,s2
 892:	f61ff0ef          	jal	7f2 <putc>
  while(--i >= 0)
 896:	14fd                	addi	s1,s1,-1
 898:	ff349ae3          	bne	s1,s3,88c <printint+0x7c>
 89c:	74e2                	ld	s1,56(sp)
}
 89e:	60a6                	ld	ra,72(sp)
 8a0:	6406                	ld	s0,64(sp)
 8a2:	7942                	ld	s2,48(sp)
 8a4:	79a2                	ld	s3,40(sp)
 8a6:	6161                	addi	sp,sp,80
 8a8:	8082                	ret
  neg = 0;
 8aa:	4301                	li	t1,0
 8ac:	bfbd                	j	82a <printint+0x1a>

00000000000008ae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8ae:	711d                	addi	sp,sp,-96
 8b0:	ec86                	sd	ra,88(sp)
 8b2:	e8a2                	sd	s0,80(sp)
 8b4:	e4a6                	sd	s1,72(sp)
 8b6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8b8:	0005c483          	lbu	s1,0(a1)
 8bc:	22048363          	beqz	s1,ae2 <vprintf+0x234>
 8c0:	e0ca                	sd	s2,64(sp)
 8c2:	fc4e                	sd	s3,56(sp)
 8c4:	f852                	sd	s4,48(sp)
 8c6:	f456                	sd	s5,40(sp)
 8c8:	f05a                	sd	s6,32(sp)
 8ca:	ec5e                	sd	s7,24(sp)
 8cc:	e862                	sd	s8,16(sp)
 8ce:	8b2a                	mv	s6,a0
 8d0:	8a2e                	mv	s4,a1
 8d2:	8bb2                	mv	s7,a2
  state = 0;
 8d4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8d6:	4901                	li	s2,0
 8d8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8da:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8de:	06400c13          	li	s8,100
 8e2:	a00d                	j	904 <vprintf+0x56>
        putc(fd, c0);
 8e4:	85a6                	mv	a1,s1
 8e6:	855a                	mv	a0,s6
 8e8:	f0bff0ef          	jal	7f2 <putc>
 8ec:	a019                	j	8f2 <vprintf+0x44>
    } else if(state == '%'){
 8ee:	03598363          	beq	s3,s5,914 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 8f2:	0019079b          	addiw	a5,s2,1
 8f6:	893e                	mv	s2,a5
 8f8:	873e                	mv	a4,a5
 8fa:	97d2                	add	a5,a5,s4
 8fc:	0007c483          	lbu	s1,0(a5)
 900:	1c048a63          	beqz	s1,ad4 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 904:	0004879b          	sext.w	a5,s1
    if(state == 0){
 908:	fe0993e3          	bnez	s3,8ee <vprintf+0x40>
      if(c0 == '%'){
 90c:	fd579ce3          	bne	a5,s5,8e4 <vprintf+0x36>
        state = '%';
 910:	89be                	mv	s3,a5
 912:	b7c5                	j	8f2 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 914:	00ea06b3          	add	a3,s4,a4
 918:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 91c:	1c060863          	beqz	a2,aec <vprintf+0x23e>
      if(c0 == 'd'){
 920:	03878763          	beq	a5,s8,94e <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 924:	f9478693          	addi	a3,a5,-108
 928:	0016b693          	seqz	a3,a3
 92c:	f9c60593          	addi	a1,a2,-100
 930:	e99d                	bnez	a1,966 <vprintf+0xb8>
 932:	ca95                	beqz	a3,966 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 934:	008b8493          	addi	s1,s7,8
 938:	4685                	li	a3,1
 93a:	4629                	li	a2,10
 93c:	000bb583          	ld	a1,0(s7)
 940:	855a                	mv	a0,s6
 942:	ecfff0ef          	jal	810 <printint>
        i += 1;
 946:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 948:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 94a:	4981                	li	s3,0
 94c:	b75d                	j	8f2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 94e:	008b8493          	addi	s1,s7,8
 952:	4685                	li	a3,1
 954:	4629                	li	a2,10
 956:	000ba583          	lw	a1,0(s7)
 95a:	855a                	mv	a0,s6
 95c:	eb5ff0ef          	jal	810 <printint>
 960:	8ba6                	mv	s7,s1
      state = 0;
 962:	4981                	li	s3,0
 964:	b779                	j	8f2 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 966:	9752                	add	a4,a4,s4
 968:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 96c:	f9460713          	addi	a4,a2,-108
 970:	00173713          	seqz	a4,a4
 974:	8f75                	and	a4,a4,a3
 976:	f9c58513          	addi	a0,a1,-100
 97a:	18051363          	bnez	a0,b00 <vprintf+0x252>
 97e:	18070163          	beqz	a4,b00 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 982:	008b8493          	addi	s1,s7,8
 986:	4685                	li	a3,1
 988:	4629                	li	a2,10
 98a:	000bb583          	ld	a1,0(s7)
 98e:	855a                	mv	a0,s6
 990:	e81ff0ef          	jal	810 <printint>
        i += 2;
 994:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 996:	8ba6                	mv	s7,s1
      state = 0;
 998:	4981                	li	s3,0
        i += 2;
 99a:	bfa1                	j	8f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 99c:	008b8493          	addi	s1,s7,8
 9a0:	4681                	li	a3,0
 9a2:	4629                	li	a2,10
 9a4:	000be583          	lwu	a1,0(s7)
 9a8:	855a                	mv	a0,s6
 9aa:	e67ff0ef          	jal	810 <printint>
 9ae:	8ba6                	mv	s7,s1
      state = 0;
 9b0:	4981                	li	s3,0
 9b2:	b781                	j	8f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9b4:	008b8493          	addi	s1,s7,8
 9b8:	4681                	li	a3,0
 9ba:	4629                	li	a2,10
 9bc:	000bb583          	ld	a1,0(s7)
 9c0:	855a                	mv	a0,s6
 9c2:	e4fff0ef          	jal	810 <printint>
        i += 1;
 9c6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9c8:	8ba6                	mv	s7,s1
      state = 0;
 9ca:	4981                	li	s3,0
 9cc:	b71d                	j	8f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9ce:	008b8493          	addi	s1,s7,8
 9d2:	4681                	li	a3,0
 9d4:	4629                	li	a2,10
 9d6:	000bb583          	ld	a1,0(s7)
 9da:	855a                	mv	a0,s6
 9dc:	e35ff0ef          	jal	810 <printint>
        i += 2;
 9e0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 9e2:	8ba6                	mv	s7,s1
      state = 0;
 9e4:	4981                	li	s3,0
        i += 2;
 9e6:	b731                	j	8f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 9e8:	008b8493          	addi	s1,s7,8
 9ec:	4681                	li	a3,0
 9ee:	4641                	li	a2,16
 9f0:	000be583          	lwu	a1,0(s7)
 9f4:	855a                	mv	a0,s6
 9f6:	e1bff0ef          	jal	810 <printint>
 9fa:	8ba6                	mv	s7,s1
      state = 0;
 9fc:	4981                	li	s3,0
 9fe:	bdd5                	j	8f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a00:	008b8493          	addi	s1,s7,8
 a04:	4681                	li	a3,0
 a06:	4641                	li	a2,16
 a08:	000bb583          	ld	a1,0(s7)
 a0c:	855a                	mv	a0,s6
 a0e:	e03ff0ef          	jal	810 <printint>
        i += 1;
 a12:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a14:	8ba6                	mv	s7,s1
      state = 0;
 a16:	4981                	li	s3,0
 a18:	bde9                	j	8f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a1a:	008b8493          	addi	s1,s7,8
 a1e:	4681                	li	a3,0
 a20:	4641                	li	a2,16
 a22:	000bb583          	ld	a1,0(s7)
 a26:	855a                	mv	a0,s6
 a28:	de9ff0ef          	jal	810 <printint>
        i += 2;
 a2c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a2e:	8ba6                	mv	s7,s1
      state = 0;
 a30:	4981                	li	s3,0
        i += 2;
 a32:	b5c1                	j	8f2 <vprintf+0x44>
 a34:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 a36:	008b8793          	addi	a5,s7,8
 a3a:	8cbe                	mv	s9,a5
 a3c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a40:	03000593          	li	a1,48
 a44:	855a                	mv	a0,s6
 a46:	dadff0ef          	jal	7f2 <putc>
  putc(fd, 'x');
 a4a:	07800593          	li	a1,120
 a4e:	855a                	mv	a0,s6
 a50:	da3ff0ef          	jal	7f2 <putc>
 a54:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a56:	00000b97          	auipc	s7,0x0
 a5a:	65ab8b93          	addi	s7,s7,1626 # 10b0 <digits>
 a5e:	03c9d793          	srli	a5,s3,0x3c
 a62:	97de                	add	a5,a5,s7
 a64:	0007c583          	lbu	a1,0(a5)
 a68:	855a                	mv	a0,s6
 a6a:	d89ff0ef          	jal	7f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a6e:	0992                	slli	s3,s3,0x4
 a70:	34fd                	addiw	s1,s1,-1
 a72:	f4f5                	bnez	s1,a5e <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 a74:	8be6                	mv	s7,s9
      state = 0;
 a76:	4981                	li	s3,0
 a78:	6ca2                	ld	s9,8(sp)
 a7a:	bda5                	j	8f2 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 a7c:	008b8493          	addi	s1,s7,8
 a80:	000bc583          	lbu	a1,0(s7)
 a84:	855a                	mv	a0,s6
 a86:	d6dff0ef          	jal	7f2 <putc>
 a8a:	8ba6                	mv	s7,s1
      state = 0;
 a8c:	4981                	li	s3,0
 a8e:	b595                	j	8f2 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 a90:	008b8993          	addi	s3,s7,8
 a94:	000bb483          	ld	s1,0(s7)
 a98:	cc91                	beqz	s1,ab4 <vprintf+0x206>
        for(; *s; s++)
 a9a:	0004c583          	lbu	a1,0(s1)
 a9e:	c985                	beqz	a1,ace <vprintf+0x220>
          putc(fd, *s);
 aa0:	855a                	mv	a0,s6
 aa2:	d51ff0ef          	jal	7f2 <putc>
        for(; *s; s++)
 aa6:	0485                	addi	s1,s1,1
 aa8:	0004c583          	lbu	a1,0(s1)
 aac:	f9f5                	bnez	a1,aa0 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 aae:	8bce                	mv	s7,s3
      state = 0;
 ab0:	4981                	li	s3,0
 ab2:	b581                	j	8f2 <vprintf+0x44>
          s = "(null)";
 ab4:	00000497          	auipc	s1,0x0
 ab8:	5f448493          	addi	s1,s1,1524 # 10a8 <malloc+0x458>
        for(; *s; s++)
 abc:	02800593          	li	a1,40
 ac0:	b7c5                	j	aa0 <vprintf+0x1f2>
        putc(fd, '%');
 ac2:	85be                	mv	a1,a5
 ac4:	855a                	mv	a0,s6
 ac6:	d2dff0ef          	jal	7f2 <putc>
      state = 0;
 aca:	4981                	li	s3,0
 acc:	b51d                	j	8f2 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 ace:	8bce                	mv	s7,s3
      state = 0;
 ad0:	4981                	li	s3,0
 ad2:	b505                	j	8f2 <vprintf+0x44>
 ad4:	6906                	ld	s2,64(sp)
 ad6:	79e2                	ld	s3,56(sp)
 ad8:	7a42                	ld	s4,48(sp)
 ada:	7aa2                	ld	s5,40(sp)
 adc:	7b02                	ld	s6,32(sp)
 ade:	6be2                	ld	s7,24(sp)
 ae0:	6c42                	ld	s8,16(sp)
    }
  }
}
 ae2:	60e6                	ld	ra,88(sp)
 ae4:	6446                	ld	s0,80(sp)
 ae6:	64a6                	ld	s1,72(sp)
 ae8:	6125                	addi	sp,sp,96
 aea:	8082                	ret
      if(c0 == 'd'){
 aec:	06400713          	li	a4,100
 af0:	e4e78fe3          	beq	a5,a4,94e <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 af4:	f9478693          	addi	a3,a5,-108
 af8:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 afc:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 afe:	4701                	li	a4,0
      } else if(c0 == 'u'){
 b00:	07500513          	li	a0,117
 b04:	e8a78ce3          	beq	a5,a0,99c <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 b08:	f8b60513          	addi	a0,a2,-117
 b0c:	e119                	bnez	a0,b12 <vprintf+0x264>
 b0e:	ea0693e3          	bnez	a3,9b4 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 b12:	f8b58513          	addi	a0,a1,-117
 b16:	e119                	bnez	a0,b1c <vprintf+0x26e>
 b18:	ea071be3          	bnez	a4,9ce <vprintf+0x120>
      } else if(c0 == 'x'){
 b1c:	07800513          	li	a0,120
 b20:	eca784e3          	beq	a5,a0,9e8 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 b24:	f8860613          	addi	a2,a2,-120
 b28:	e219                	bnez	a2,b2e <vprintf+0x280>
 b2a:	ec069be3          	bnez	a3,a00 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 b2e:	f8858593          	addi	a1,a1,-120
 b32:	e199                	bnez	a1,b38 <vprintf+0x28a>
 b34:	ee0713e3          	bnez	a4,a1a <vprintf+0x16c>
      } else if(c0 == 'p'){
 b38:	07000713          	li	a4,112
 b3c:	eee78ce3          	beq	a5,a4,a34 <vprintf+0x186>
      } else if(c0 == 'c'){
 b40:	06300713          	li	a4,99
 b44:	f2e78ce3          	beq	a5,a4,a7c <vprintf+0x1ce>
      } else if(c0 == 's'){
 b48:	07300713          	li	a4,115
 b4c:	f4e782e3          	beq	a5,a4,a90 <vprintf+0x1e2>
      } else if(c0 == '%'){
 b50:	02500713          	li	a4,37
 b54:	f6e787e3          	beq	a5,a4,ac2 <vprintf+0x214>
        putc(fd, '%');
 b58:	02500593          	li	a1,37
 b5c:	855a                	mv	a0,s6
 b5e:	c95ff0ef          	jal	7f2 <putc>
        putc(fd, c0);
 b62:	85a6                	mv	a1,s1
 b64:	855a                	mv	a0,s6
 b66:	c8dff0ef          	jal	7f2 <putc>
      state = 0;
 b6a:	4981                	li	s3,0
 b6c:	b359                	j	8f2 <vprintf+0x44>

0000000000000b6e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b6e:	715d                	addi	sp,sp,-80
 b70:	ec06                	sd	ra,24(sp)
 b72:	e822                	sd	s0,16(sp)
 b74:	1000                	addi	s0,sp,32
 b76:	e010                	sd	a2,0(s0)
 b78:	e414                	sd	a3,8(s0)
 b7a:	e818                	sd	a4,16(s0)
 b7c:	ec1c                	sd	a5,24(s0)
 b7e:	03043023          	sd	a6,32(s0)
 b82:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b86:	8622                	mv	a2,s0
 b88:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b8c:	d23ff0ef          	jal	8ae <vprintf>
}
 b90:	60e2                	ld	ra,24(sp)
 b92:	6442                	ld	s0,16(sp)
 b94:	6161                	addi	sp,sp,80
 b96:	8082                	ret

0000000000000b98 <printf>:

void
printf(const char *fmt, ...)
{
 b98:	711d                	addi	sp,sp,-96
 b9a:	ec06                	sd	ra,24(sp)
 b9c:	e822                	sd	s0,16(sp)
 b9e:	1000                	addi	s0,sp,32
 ba0:	e40c                	sd	a1,8(s0)
 ba2:	e810                	sd	a2,16(s0)
 ba4:	ec14                	sd	a3,24(s0)
 ba6:	f018                	sd	a4,32(s0)
 ba8:	f41c                	sd	a5,40(s0)
 baa:	03043823          	sd	a6,48(s0)
 bae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bb2:	00840613          	addi	a2,s0,8
 bb6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 bba:	85aa                	mv	a1,a0
 bbc:	4505                	li	a0,1
 bbe:	cf1ff0ef          	jal	8ae <vprintf>
}
 bc2:	60e2                	ld	ra,24(sp)
 bc4:	6442                	ld	s0,16(sp)
 bc6:	6125                	addi	sp,sp,96
 bc8:	8082                	ret

0000000000000bca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bca:	1141                	addi	sp,sp,-16
 bcc:	e406                	sd	ra,8(sp)
 bce:	e022                	sd	s0,0(sp)
 bd0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bd2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd6:	00001797          	auipc	a5,0x1
 bda:	42a7b783          	ld	a5,1066(a5) # 2000 <freep>
 bde:	a039                	j	bec <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 be0:	6398                	ld	a4,0(a5)
 be2:	00e7e463          	bltu	a5,a4,bea <free+0x20>
 be6:	00e6ea63          	bltu	a3,a4,bfa <free+0x30>
{
 bea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bec:	fed7fae3          	bgeu	a5,a3,be0 <free+0x16>
 bf0:	6398                	ld	a4,0(a5)
 bf2:	00e6e463          	bltu	a3,a4,bfa <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bf6:	fee7eae3          	bltu	a5,a4,bea <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 bfa:	ff852583          	lw	a1,-8(a0)
 bfe:	6390                	ld	a2,0(a5)
 c00:	02059813          	slli	a6,a1,0x20
 c04:	01c85713          	srli	a4,a6,0x1c
 c08:	9736                	add	a4,a4,a3
 c0a:	02e60563          	beq	a2,a4,c34 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 c0e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 c12:	4790                	lw	a2,8(a5)
 c14:	02061593          	slli	a1,a2,0x20
 c18:	01c5d713          	srli	a4,a1,0x1c
 c1c:	973e                	add	a4,a4,a5
 c1e:	02e68263          	beq	a3,a4,c42 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 c22:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c24:	00001717          	auipc	a4,0x1
 c28:	3cf73e23          	sd	a5,988(a4) # 2000 <freep>
}
 c2c:	60a2                	ld	ra,8(sp)
 c2e:	6402                	ld	s0,0(sp)
 c30:	0141                	addi	sp,sp,16
 c32:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 c34:	4618                	lw	a4,8(a2)
 c36:	9f2d                	addw	a4,a4,a1
 c38:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c3c:	6398                	ld	a4,0(a5)
 c3e:	6310                	ld	a2,0(a4)
 c40:	b7f9                	j	c0e <free+0x44>
    p->s.size += bp->s.size;
 c42:	ff852703          	lw	a4,-8(a0)
 c46:	9f31                	addw	a4,a4,a2
 c48:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c4a:	ff053683          	ld	a3,-16(a0)
 c4e:	bfd1                	j	c22 <free+0x58>

0000000000000c50 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c50:	7139                	addi	sp,sp,-64
 c52:	fc06                	sd	ra,56(sp)
 c54:	f822                	sd	s0,48(sp)
 c56:	f04a                	sd	s2,32(sp)
 c58:	ec4e                	sd	s3,24(sp)
 c5a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c5c:	02051993          	slli	s3,a0,0x20
 c60:	0209d993          	srli	s3,s3,0x20
 c64:	09bd                	addi	s3,s3,15
 c66:	0049d993          	srli	s3,s3,0x4
 c6a:	2985                	addiw	s3,s3,1
 c6c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 c6e:	00001517          	auipc	a0,0x1
 c72:	39253503          	ld	a0,914(a0) # 2000 <freep>
 c76:	c905                	beqz	a0,ca6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c78:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c7a:	4798                	lw	a4,8(a5)
 c7c:	09377663          	bgeu	a4,s3,d08 <malloc+0xb8>
 c80:	f426                	sd	s1,40(sp)
 c82:	e852                	sd	s4,16(sp)
 c84:	e456                	sd	s5,8(sp)
 c86:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 c88:	8a4e                	mv	s4,s3
 c8a:	6705                	lui	a4,0x1
 c8c:	00e9f363          	bgeu	s3,a4,c92 <malloc+0x42>
 c90:	6a05                	lui	s4,0x1
 c92:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c96:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c9a:	00001497          	auipc	s1,0x1
 c9e:	36648493          	addi	s1,s1,870 # 2000 <freep>
  if(p == SBRK_ERROR)
 ca2:	5afd                	li	s5,-1
 ca4:	a83d                	j	ce2 <malloc+0x92>
 ca6:	f426                	sd	s1,40(sp)
 ca8:	e852                	sd	s4,16(sp)
 caa:	e456                	sd	s5,8(sp)
 cac:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 cae:	00001797          	auipc	a5,0x1
 cb2:	36278793          	addi	a5,a5,866 # 2010 <base>
 cb6:	00001717          	auipc	a4,0x1
 cba:	34f73523          	sd	a5,842(a4) # 2000 <freep>
 cbe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 cc0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cc4:	b7d1                	j	c88 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 cc6:	6398                	ld	a4,0(a5)
 cc8:	e118                	sd	a4,0(a0)
 cca:	a899                	j	d20 <malloc+0xd0>
  hp->s.size = nu;
 ccc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cd0:	0541                	addi	a0,a0,16
 cd2:	ef9ff0ef          	jal	bca <free>
  return freep;
 cd6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 cd8:	c125                	beqz	a0,d38 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cda:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cdc:	4798                	lw	a4,8(a5)
 cde:	03277163          	bgeu	a4,s2,d00 <malloc+0xb0>
    if(p == freep)
 ce2:	6098                	ld	a4,0(s1)
 ce4:	853e                	mv	a0,a5
 ce6:	fef71ae3          	bne	a4,a5,cda <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 cea:	8552                	mv	a0,s4
 cec:	a0bff0ef          	jal	6f6 <sbrk>
  if(p == SBRK_ERROR)
 cf0:	fd551ee3          	bne	a0,s5,ccc <malloc+0x7c>
        return 0;
 cf4:	4501                	li	a0,0
 cf6:	74a2                	ld	s1,40(sp)
 cf8:	6a42                	ld	s4,16(sp)
 cfa:	6aa2                	ld	s5,8(sp)
 cfc:	6b02                	ld	s6,0(sp)
 cfe:	a03d                	j	d2c <malloc+0xdc>
 d00:	74a2                	ld	s1,40(sp)
 d02:	6a42                	ld	s4,16(sp)
 d04:	6aa2                	ld	s5,8(sp)
 d06:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 d08:	fae90fe3          	beq	s2,a4,cc6 <malloc+0x76>
        p->s.size -= nunits;
 d0c:	4137073b          	subw	a4,a4,s3
 d10:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d12:	02071693          	slli	a3,a4,0x20
 d16:	01c6d713          	srli	a4,a3,0x1c
 d1a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d1c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d20:	00001717          	auipc	a4,0x1
 d24:	2ea73023          	sd	a0,736(a4) # 2000 <freep>
      return (void*)(p + 1);
 d28:	01078513          	addi	a0,a5,16
  }
}
 d2c:	70e2                	ld	ra,56(sp)
 d2e:	7442                	ld	s0,48(sp)
 d30:	7902                	ld	s2,32(sp)
 d32:	69e2                	ld	s3,24(sp)
 d34:	6121                	addi	sp,sp,64
 d36:	8082                	ret
 d38:	74a2                	ld	s1,40(sp)
 d3a:	6a42                	ld	s4,16(sp)
 d3c:	6aa2                	ld	s5,8(sp)
 d3e:	6b02                	ld	s6,0(sp)
 d40:	b7f5                	j	d2c <malloc+0xdc>
