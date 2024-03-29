
user/_bigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/fcntl.h"
#include "kernel/fs.h"

int main()
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	addi	s0,sp,1072
  char buf[BSIZE];
  int fd, i, blocks;

  fd = open("big.file", O_CREATE | O_WRONLY);
  20:	20100593          	li	a1,513
  24:	00001517          	auipc	a0,0x1
  28:	8fc50513          	addi	a0,a0,-1796 # 920 <malloc+0xf4>
  2c:	00000097          	auipc	ra,0x0
  30:	420080e7          	jalr	1056(ra) # 44c <open>
  if (fd < 0)
  34:	04054463          	bltz	a0,7c <main+0x7c>
  38:	892a                	mv	s2,a0
  3a:	4481                	li	s1,0
    *(int *)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if (cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
  3c:	06400993          	li	s3,100
      printf(".");
  40:	00001a17          	auipc	s4,0x1
  44:	920a0a13          	addi	s4,s4,-1760 # 960 <malloc+0x134>
    *(int *)buf = blocks;
  48:	bc942823          	sw	s1,-1072(s0)
    int cc = write(fd, buf, sizeof(buf));
  4c:	40000613          	li	a2,1024
  50:	bd040593          	addi	a1,s0,-1072
  54:	854a                	mv	a0,s2
  56:	00000097          	auipc	ra,0x0
  5a:	3d6080e7          	jalr	982(ra) # 42c <write>
    if (cc <= 0)
  5e:	02a05c63          	blez	a0,96 <main+0x96>
    blocks++;
  62:	0014879b          	addiw	a5,s1,1
  66:	0007849b          	sext.w	s1,a5
    if (blocks % 100 == 0)
  6a:	0337e7bb          	remw	a5,a5,s3
  6e:	ffe9                	bnez	a5,48 <main+0x48>
      printf(".");
  70:	8552                	mv	a0,s4
  72:	00000097          	auipc	ra,0x0
  76:	702080e7          	jalr	1794(ra) # 774 <printf>
  7a:	b7f9                	j	48 <main+0x48>
    printf("bigfile: cannot open big.file for writing\n");
  7c:	00001517          	auipc	a0,0x1
  80:	8b450513          	addi	a0,a0,-1868 # 930 <malloc+0x104>
  84:	00000097          	auipc	ra,0x0
  88:	6f0080e7          	jalr	1776(ra) # 774 <printf>
    exit(-1);
  8c:	557d                	li	a0,-1
  8e:	00000097          	auipc	ra,0x0
  92:	37e080e7          	jalr	894(ra) # 40c <exit>
  }

  printf("\nwrote %d blocks\n", blocks);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	8d050513          	addi	a0,a0,-1840 # 968 <malloc+0x13c>
  a0:	00000097          	auipc	ra,0x0
  a4:	6d4080e7          	jalr	1748(ra) # 774 <printf>
  if (blocks != 65803)
  a8:	67c1                	lui	a5,0x10
  aa:	10b78793          	addi	a5,a5,267 # 1010b <base+0xf0fb>
  ae:	00f48f63          	beq	s1,a5,cc <main+0xcc>
  {
    printf("bigfile: file is too small\n");
  b2:	00001517          	auipc	a0,0x1
  b6:	8ce50513          	addi	a0,a0,-1842 # 980 <malloc+0x154>
  ba:	00000097          	auipc	ra,0x0
  be:	6ba080e7          	jalr	1722(ra) # 774 <printf>
    exit(-1);
  c2:	557d                	li	a0,-1
  c4:	00000097          	auipc	ra,0x0
  c8:	348080e7          	jalr	840(ra) # 40c <exit>
  }

  close(fd);
  cc:	854a                	mv	a0,s2
  ce:	00000097          	auipc	ra,0x0
  d2:	366080e7          	jalr	870(ra) # 434 <close>
  fd = open("big.file", O_RDONLY);
  d6:	4581                	li	a1,0
  d8:	00001517          	auipc	a0,0x1
  dc:	84850513          	addi	a0,a0,-1976 # 920 <malloc+0xf4>
  e0:	00000097          	auipc	ra,0x0
  e4:	36c080e7          	jalr	876(ra) # 44c <open>
  e8:	892a                	mv	s2,a0
  if (fd < 0)
  {
    printf("bigfile: cannot re-open big.file for reading\n");
    exit(-1);
  }
  for (i = 0; i < blocks; i++)
  ea:	4481                	li	s1,0
  if (fd < 0)
  ec:	04054463          	bltz	a0,134 <main+0x134>
  for (i = 0; i < blocks; i++)
  f0:	69c1                	lui	s3,0x10
  f2:	10b98993          	addi	s3,s3,267 # 1010b <base+0xf0fb>
  {
    int cc = read(fd, buf, sizeof(buf));
  f6:	40000613          	li	a2,1024
  fa:	bd040593          	addi	a1,s0,-1072
  fe:	854a                	mv	a0,s2
 100:	00000097          	auipc	ra,0x0
 104:	324080e7          	jalr	804(ra) # 424 <read>
    if (cc <= 0)
 108:	04a05363          	blez	a0,14e <main+0x14e>
    {
      printf("bigfile: read error at block %d\n", i);
      exit(-1);
    }
    if (*(int *)buf != i)
 10c:	bd042583          	lw	a1,-1072(s0)
 110:	04959d63          	bne	a1,s1,16a <main+0x16a>
  for (i = 0; i < blocks; i++)
 114:	2485                	addiw	s1,s1,1
 116:	ff3490e3          	bne	s1,s3,f6 <main+0xf6>
             *(int *)buf, i);
      exit(-1);
    }
  }

  printf("bigfile done; ok\n");
 11a:	00001517          	auipc	a0,0x1
 11e:	90e50513          	addi	a0,a0,-1778 # a28 <malloc+0x1fc>
 122:	00000097          	auipc	ra,0x0
 126:	652080e7          	jalr	1618(ra) # 774 <printf>

  exit(0);
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	2e0080e7          	jalr	736(ra) # 40c <exit>
    printf("bigfile: cannot re-open big.file for reading\n");
 134:	00001517          	auipc	a0,0x1
 138:	86c50513          	addi	a0,a0,-1940 # 9a0 <malloc+0x174>
 13c:	00000097          	auipc	ra,0x0
 140:	638080e7          	jalr	1592(ra) # 774 <printf>
    exit(-1);
 144:	557d                	li	a0,-1
 146:	00000097          	auipc	ra,0x0
 14a:	2c6080e7          	jalr	710(ra) # 40c <exit>
      printf("bigfile: read error at block %d\n", i);
 14e:	85a6                	mv	a1,s1
 150:	00001517          	auipc	a0,0x1
 154:	88050513          	addi	a0,a0,-1920 # 9d0 <malloc+0x1a4>
 158:	00000097          	auipc	ra,0x0
 15c:	61c080e7          	jalr	1564(ra) # 774 <printf>
      exit(-1);
 160:	557d                	li	a0,-1
 162:	00000097          	auipc	ra,0x0
 166:	2aa080e7          	jalr	682(ra) # 40c <exit>
      printf("bigfile: read the wrong data (%d) for block %d\n",
 16a:	8626                	mv	a2,s1
 16c:	00001517          	auipc	a0,0x1
 170:	88c50513          	addi	a0,a0,-1908 # 9f8 <malloc+0x1cc>
 174:	00000097          	auipc	ra,0x0
 178:	600080e7          	jalr	1536(ra) # 774 <printf>
      exit(-1);
 17c:	557d                	li	a0,-1
 17e:	00000097          	auipc	ra,0x0
 182:	28e080e7          	jalr	654(ra) # 40c <exit>

0000000000000186 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 186:	1141                	addi	sp,sp,-16
 188:	e406                	sd	ra,8(sp)
 18a:	e022                	sd	s0,0(sp)
 18c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 18e:	00000097          	auipc	ra,0x0
 192:	e72080e7          	jalr	-398(ra) # 0 <main>
  exit(0);
 196:	4501                	li	a0,0
 198:	00000097          	auipc	ra,0x0
 19c:	274080e7          	jalr	628(ra) # 40c <exit>

00000000000001a0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a6:	87aa                	mv	a5,a0
 1a8:	0585                	addi	a1,a1,1
 1aa:	0785                	addi	a5,a5,1
 1ac:	fff5c703          	lbu	a4,-1(a1)
 1b0:	fee78fa3          	sb	a4,-1(a5)
 1b4:	fb75                	bnez	a4,1a8 <strcpy+0x8>
    ;
  return os;
}
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	cb91                	beqz	a5,1da <strcmp+0x1e>
 1c8:	0005c703          	lbu	a4,0(a1)
 1cc:	00f71763          	bne	a4,a5,1da <strcmp+0x1e>
    p++, q++;
 1d0:	0505                	addi	a0,a0,1
 1d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	fbe5                	bnez	a5,1c8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1da:	0005c503          	lbu	a0,0(a1)
}
 1de:	40a7853b          	subw	a0,a5,a0
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret

00000000000001e8 <strlen>:

uint
strlen(const char *s)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	cf91                	beqz	a5,20e <strlen+0x26>
 1f4:	0505                	addi	a0,a0,1
 1f6:	87aa                	mv	a5,a0
 1f8:	86be                	mv	a3,a5
 1fa:	0785                	addi	a5,a5,1
 1fc:	fff7c703          	lbu	a4,-1(a5)
 200:	ff65                	bnez	a4,1f8 <strlen+0x10>
 202:	40a6853b          	subw	a0,a3,a0
 206:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  for(n = 0; s[n]; n++)
 20e:	4501                	li	a0,0
 210:	bfe5                	j	208 <strlen+0x20>

0000000000000212 <memset>:

void*
memset(void *dst, int c, uint n)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 218:	ca19                	beqz	a2,22e <memset+0x1c>
 21a:	87aa                	mv	a5,a0
 21c:	1602                	slli	a2,a2,0x20
 21e:	9201                	srli	a2,a2,0x20
 220:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 224:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 228:	0785                	addi	a5,a5,1
 22a:	fee79de3          	bne	a5,a4,224 <memset+0x12>
  }
  return dst;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret

0000000000000234 <strchr>:

char*
strchr(const char *s, char c)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  for(; *s; s++)
 23a:	00054783          	lbu	a5,0(a0)
 23e:	cb99                	beqz	a5,254 <strchr+0x20>
    if(*s == c)
 240:	00f58763          	beq	a1,a5,24e <strchr+0x1a>
  for(; *s; s++)
 244:	0505                	addi	a0,a0,1
 246:	00054783          	lbu	a5,0(a0)
 24a:	fbfd                	bnez	a5,240 <strchr+0xc>
      return (char*)s;
  return 0;
 24c:	4501                	li	a0,0
}
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
  return 0;
 254:	4501                	li	a0,0
 256:	bfe5                	j	24e <strchr+0x1a>

0000000000000258 <gets>:

char*
gets(char *buf, int max)
{
 258:	711d                	addi	sp,sp,-96
 25a:	ec86                	sd	ra,88(sp)
 25c:	e8a2                	sd	s0,80(sp)
 25e:	e4a6                	sd	s1,72(sp)
 260:	e0ca                	sd	s2,64(sp)
 262:	fc4e                	sd	s3,56(sp)
 264:	f852                	sd	s4,48(sp)
 266:	f456                	sd	s5,40(sp)
 268:	f05a                	sd	s6,32(sp)
 26a:	ec5e                	sd	s7,24(sp)
 26c:	1080                	addi	s0,sp,96
 26e:	8baa                	mv	s7,a0
 270:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 272:	892a                	mv	s2,a0
 274:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 276:	4aa9                	li	s5,10
 278:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 27a:	89a6                	mv	s3,s1
 27c:	2485                	addiw	s1,s1,1
 27e:	0344d863          	bge	s1,s4,2ae <gets+0x56>
    cc = read(0, &c, 1);
 282:	4605                	li	a2,1
 284:	faf40593          	addi	a1,s0,-81
 288:	4501                	li	a0,0
 28a:	00000097          	auipc	ra,0x0
 28e:	19a080e7          	jalr	410(ra) # 424 <read>
    if(cc < 1)
 292:	00a05e63          	blez	a0,2ae <gets+0x56>
    buf[i++] = c;
 296:	faf44783          	lbu	a5,-81(s0)
 29a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 29e:	01578763          	beq	a5,s5,2ac <gets+0x54>
 2a2:	0905                	addi	s2,s2,1
 2a4:	fd679be3          	bne	a5,s6,27a <gets+0x22>
  for(i=0; i+1 < max; ){
 2a8:	89a6                	mv	s3,s1
 2aa:	a011                	j	2ae <gets+0x56>
 2ac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ae:	99de                	add	s3,s3,s7
 2b0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b4:	855e                	mv	a0,s7
 2b6:	60e6                	ld	ra,88(sp)
 2b8:	6446                	ld	s0,80(sp)
 2ba:	64a6                	ld	s1,72(sp)
 2bc:	6906                	ld	s2,64(sp)
 2be:	79e2                	ld	s3,56(sp)
 2c0:	7a42                	ld	s4,48(sp)
 2c2:	7aa2                	ld	s5,40(sp)
 2c4:	7b02                	ld	s6,32(sp)
 2c6:	6be2                	ld	s7,24(sp)
 2c8:	6125                	addi	sp,sp,96
 2ca:	8082                	ret

00000000000002cc <stat>:

int
stat(const char *n, struct stat *st)
{
 2cc:	1101                	addi	sp,sp,-32
 2ce:	ec06                	sd	ra,24(sp)
 2d0:	e822                	sd	s0,16(sp)
 2d2:	e426                	sd	s1,8(sp)
 2d4:	e04a                	sd	s2,0(sp)
 2d6:	1000                	addi	s0,sp,32
 2d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2da:	4581                	li	a1,0
 2dc:	00000097          	auipc	ra,0x0
 2e0:	170080e7          	jalr	368(ra) # 44c <open>
  if(fd < 0)
 2e4:	02054563          	bltz	a0,30e <stat+0x42>
 2e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ea:	85ca                	mv	a1,s2
 2ec:	00000097          	auipc	ra,0x0
 2f0:	178080e7          	jalr	376(ra) # 464 <fstat>
 2f4:	892a                	mv	s2,a0
  close(fd);
 2f6:	8526                	mv	a0,s1
 2f8:	00000097          	auipc	ra,0x0
 2fc:	13c080e7          	jalr	316(ra) # 434 <close>
  return r;
}
 300:	854a                	mv	a0,s2
 302:	60e2                	ld	ra,24(sp)
 304:	6442                	ld	s0,16(sp)
 306:	64a2                	ld	s1,8(sp)
 308:	6902                	ld	s2,0(sp)
 30a:	6105                	addi	sp,sp,32
 30c:	8082                	ret
    return -1;
 30e:	597d                	li	s2,-1
 310:	bfc5                	j	300 <stat+0x34>

0000000000000312 <atoi>:

int
atoi(const char *s)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 318:	00054683          	lbu	a3,0(a0)
 31c:	fd06879b          	addiw	a5,a3,-48
 320:	0ff7f793          	zext.b	a5,a5
 324:	4625                	li	a2,9
 326:	02f66863          	bltu	a2,a5,356 <atoi+0x44>
 32a:	872a                	mv	a4,a0
  n = 0;
 32c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 32e:	0705                	addi	a4,a4,1
 330:	0025179b          	slliw	a5,a0,0x2
 334:	9fa9                	addw	a5,a5,a0
 336:	0017979b          	slliw	a5,a5,0x1
 33a:	9fb5                	addw	a5,a5,a3
 33c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 340:	00074683          	lbu	a3,0(a4)
 344:	fd06879b          	addiw	a5,a3,-48
 348:	0ff7f793          	zext.b	a5,a5
 34c:	fef671e3          	bgeu	a2,a5,32e <atoi+0x1c>
  return n;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  n = 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <atoi+0x3e>

000000000000035a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 360:	02b57463          	bgeu	a0,a1,388 <memmove+0x2e>
    while(n-- > 0)
 364:	00c05f63          	blez	a2,382 <memmove+0x28>
 368:	1602                	slli	a2,a2,0x20
 36a:	9201                	srli	a2,a2,0x20
 36c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 370:	872a                	mv	a4,a0
      *dst++ = *src++;
 372:	0585                	addi	a1,a1,1
 374:	0705                	addi	a4,a4,1
 376:	fff5c683          	lbu	a3,-1(a1)
 37a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 37e:	fee79ae3          	bne	a5,a4,372 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
    dst += n;
 388:	00c50733          	add	a4,a0,a2
    src += n;
 38c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 38e:	fec05ae3          	blez	a2,382 <memmove+0x28>
 392:	fff6079b          	addiw	a5,a2,-1
 396:	1782                	slli	a5,a5,0x20
 398:	9381                	srli	a5,a5,0x20
 39a:	fff7c793          	not	a5,a5
 39e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a0:	15fd                	addi	a1,a1,-1
 3a2:	177d                	addi	a4,a4,-1
 3a4:	0005c683          	lbu	a3,0(a1)
 3a8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ac:	fee79ae3          	bne	a5,a4,3a0 <memmove+0x46>
 3b0:	bfc9                	j	382 <memmove+0x28>

00000000000003b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b8:	ca05                	beqz	a2,3e8 <memcmp+0x36>
 3ba:	fff6069b          	addiw	a3,a2,-1
 3be:	1682                	slli	a3,a3,0x20
 3c0:	9281                	srli	a3,a3,0x20
 3c2:	0685                	addi	a3,a3,1
 3c4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	0005c703          	lbu	a4,0(a1)
 3ce:	00e79863          	bne	a5,a4,3de <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d2:	0505                	addi	a0,a0,1
    p2++;
 3d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3d6:	fed518e3          	bne	a0,a3,3c6 <memcmp+0x14>
  }
  return 0;
 3da:	4501                	li	a0,0
 3dc:	a019                	j	3e2 <memcmp+0x30>
      return *p1 - *p2;
 3de:	40e7853b          	subw	a0,a5,a4
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
  return 0;
 3e8:	4501                	li	a0,0
 3ea:	bfe5                	j	3e2 <memcmp+0x30>

00000000000003ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e406                	sd	ra,8(sp)
 3f0:	e022                	sd	s0,0(sp)
 3f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f4:	00000097          	auipc	ra,0x0
 3f8:	f66080e7          	jalr	-154(ra) # 35a <memmove>
}
 3fc:	60a2                	ld	ra,8(sp)
 3fe:	6402                	ld	s0,0(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret

0000000000000404 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 404:	4885                	li	a7,1
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <exit>:
.global exit
exit:
 li a7, SYS_exit
 40c:	4889                	li	a7,2
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <wait>:
.global wait
wait:
 li a7, SYS_wait
 414:	488d                	li	a7,3
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 41c:	4891                	li	a7,4
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <read>:
.global read
read:
 li a7, SYS_read
 424:	4895                	li	a7,5
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <write>:
.global write
write:
 li a7, SYS_write
 42c:	48c1                	li	a7,16
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <close>:
.global close
close:
 li a7, SYS_close
 434:	48d5                	li	a7,21
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <kill>:
.global kill
kill:
 li a7, SYS_kill
 43c:	4899                	li	a7,6
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <exec>:
.global exec
exec:
 li a7, SYS_exec
 444:	489d                	li	a7,7
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <open>:
.global open
open:
 li a7, SYS_open
 44c:	48bd                	li	a7,15
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 454:	48c5                	li	a7,17
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 45c:	48c9                	li	a7,18
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 464:	48a1                	li	a7,8
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <link>:
.global link
link:
 li a7, SYS_link
 46c:	48cd                	li	a7,19
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 474:	48d1                	li	a7,20
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 47c:	48a5                	li	a7,9
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <dup>:
.global dup
dup:
 li a7, SYS_dup
 484:	48a9                	li	a7,10
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 48c:	48ad                	li	a7,11
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 494:	48b1                	li	a7,12
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 49c:	48b5                	li	a7,13
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a4:	48b9                	li	a7,14
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ac:	1101                	addi	sp,sp,-32
 4ae:	ec06                	sd	ra,24(sp)
 4b0:	e822                	sd	s0,16(sp)
 4b2:	1000                	addi	s0,sp,32
 4b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b8:	4605                	li	a2,1
 4ba:	fef40593          	addi	a1,s0,-17
 4be:	00000097          	auipc	ra,0x0
 4c2:	f6e080e7          	jalr	-146(ra) # 42c <write>
}
 4c6:	60e2                	ld	ra,24(sp)
 4c8:	6442                	ld	s0,16(sp)
 4ca:	6105                	addi	sp,sp,32
 4cc:	8082                	ret

00000000000004ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ce:	7139                	addi	sp,sp,-64
 4d0:	fc06                	sd	ra,56(sp)
 4d2:	f822                	sd	s0,48(sp)
 4d4:	f426                	sd	s1,40(sp)
 4d6:	f04a                	sd	s2,32(sp)
 4d8:	ec4e                	sd	s3,24(sp)
 4da:	0080                	addi	s0,sp,64
 4dc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4de:	c299                	beqz	a3,4e4 <printint+0x16>
 4e0:	0805c963          	bltz	a1,572 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4e4:	2581                	sext.w	a1,a1
  neg = 0;
 4e6:	4881                	li	a7,0
 4e8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ee:	2601                	sext.w	a2,a2
 4f0:	00000517          	auipc	a0,0x0
 4f4:	5b050513          	addi	a0,a0,1456 # aa0 <digits>
 4f8:	883a                	mv	a6,a4
 4fa:	2705                	addiw	a4,a4,1
 4fc:	02c5f7bb          	remuw	a5,a1,a2
 500:	1782                	slli	a5,a5,0x20
 502:	9381                	srli	a5,a5,0x20
 504:	97aa                	add	a5,a5,a0
 506:	0007c783          	lbu	a5,0(a5)
 50a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 50e:	0005879b          	sext.w	a5,a1
 512:	02c5d5bb          	divuw	a1,a1,a2
 516:	0685                	addi	a3,a3,1
 518:	fec7f0e3          	bgeu	a5,a2,4f8 <printint+0x2a>
  if(neg)
 51c:	00088c63          	beqz	a7,534 <printint+0x66>
    buf[i++] = '-';
 520:	fd070793          	addi	a5,a4,-48
 524:	00878733          	add	a4,a5,s0
 528:	02d00793          	li	a5,45
 52c:	fef70823          	sb	a5,-16(a4)
 530:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 534:	02e05863          	blez	a4,564 <printint+0x96>
 538:	fc040793          	addi	a5,s0,-64
 53c:	00e78933          	add	s2,a5,a4
 540:	fff78993          	addi	s3,a5,-1
 544:	99ba                	add	s3,s3,a4
 546:	377d                	addiw	a4,a4,-1
 548:	1702                	slli	a4,a4,0x20
 54a:	9301                	srli	a4,a4,0x20
 54c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 550:	fff94583          	lbu	a1,-1(s2)
 554:	8526                	mv	a0,s1
 556:	00000097          	auipc	ra,0x0
 55a:	f56080e7          	jalr	-170(ra) # 4ac <putc>
  while(--i >= 0)
 55e:	197d                	addi	s2,s2,-1
 560:	ff3918e3          	bne	s2,s3,550 <printint+0x82>
}
 564:	70e2                	ld	ra,56(sp)
 566:	7442                	ld	s0,48(sp)
 568:	74a2                	ld	s1,40(sp)
 56a:	7902                	ld	s2,32(sp)
 56c:	69e2                	ld	s3,24(sp)
 56e:	6121                	addi	sp,sp,64
 570:	8082                	ret
    x = -xx;
 572:	40b005bb          	negw	a1,a1
    neg = 1;
 576:	4885                	li	a7,1
    x = -xx;
 578:	bf85                	j	4e8 <printint+0x1a>

000000000000057a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57a:	715d                	addi	sp,sp,-80
 57c:	e486                	sd	ra,72(sp)
 57e:	e0a2                	sd	s0,64(sp)
 580:	fc26                	sd	s1,56(sp)
 582:	f84a                	sd	s2,48(sp)
 584:	f44e                	sd	s3,40(sp)
 586:	f052                	sd	s4,32(sp)
 588:	ec56                	sd	s5,24(sp)
 58a:	e85a                	sd	s6,16(sp)
 58c:	e45e                	sd	s7,8(sp)
 58e:	e062                	sd	s8,0(sp)
 590:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 592:	0005c903          	lbu	s2,0(a1)
 596:	18090c63          	beqz	s2,72e <vprintf+0x1b4>
 59a:	8aaa                	mv	s5,a0
 59c:	8bb2                	mv	s7,a2
 59e:	00158493          	addi	s1,a1,1
  state = 0;
 5a2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a4:	02500a13          	li	s4,37
 5a8:	4b55                	li	s6,21
 5aa:	a839                	j	5c8 <vprintf+0x4e>
        putc(fd, c);
 5ac:	85ca                	mv	a1,s2
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	efc080e7          	jalr	-260(ra) # 4ac <putc>
 5b8:	a019                	j	5be <vprintf+0x44>
    } else if(state == '%'){
 5ba:	01498d63          	beq	s3,s4,5d4 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 5be:	0485                	addi	s1,s1,1
 5c0:	fff4c903          	lbu	s2,-1(s1)
 5c4:	16090563          	beqz	s2,72e <vprintf+0x1b4>
    if(state == 0){
 5c8:	fe0999e3          	bnez	s3,5ba <vprintf+0x40>
      if(c == '%'){
 5cc:	ff4910e3          	bne	s2,s4,5ac <vprintf+0x32>
        state = '%';
 5d0:	89d2                	mv	s3,s4
 5d2:	b7f5                	j	5be <vprintf+0x44>
      if(c == 'd'){
 5d4:	13490263          	beq	s2,s4,6f8 <vprintf+0x17e>
 5d8:	f9d9079b          	addiw	a5,s2,-99
 5dc:	0ff7f793          	zext.b	a5,a5
 5e0:	12fb6563          	bltu	s6,a5,70a <vprintf+0x190>
 5e4:	f9d9079b          	addiw	a5,s2,-99
 5e8:	0ff7f713          	zext.b	a4,a5
 5ec:	10eb6f63          	bltu	s6,a4,70a <vprintf+0x190>
 5f0:	00271793          	slli	a5,a4,0x2
 5f4:	00000717          	auipc	a4,0x0
 5f8:	45470713          	addi	a4,a4,1108 # a48 <malloc+0x21c>
 5fc:	97ba                	add	a5,a5,a4
 5fe:	439c                	lw	a5,0(a5)
 600:	97ba                	add	a5,a5,a4
 602:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 604:	008b8913          	addi	s2,s7,8
 608:	4685                	li	a3,1
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	ebc080e7          	jalr	-324(ra) # 4ce <printint>
 61a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b745                	j	5be <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 620:	008b8913          	addi	s2,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	ea0080e7          	jalr	-352(ra) # 4ce <printint>
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	b751                	j	5be <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4641                	li	a2,16
 644:	000ba583          	lw	a1,0(s7)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	e84080e7          	jalr	-380(ra) # 4ce <printint>
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	b7a5                	j	5be <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 658:	008b8c13          	addi	s8,s7,8
 65c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 660:	03000593          	li	a1,48
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e46080e7          	jalr	-442(ra) # 4ac <putc>
  putc(fd, 'x');
 66e:	07800593          	li	a1,120
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e38080e7          	jalr	-456(ra) # 4ac <putc>
 67c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67e:	00000b97          	auipc	s7,0x0
 682:	422b8b93          	addi	s7,s7,1058 # aa0 <digits>
 686:	03c9d793          	srli	a5,s3,0x3c
 68a:	97de                	add	a5,a5,s7
 68c:	0007c583          	lbu	a1,0(a5)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e1a080e7          	jalr	-486(ra) # 4ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69a:	0992                	slli	s3,s3,0x4
 69c:	397d                	addiw	s2,s2,-1
 69e:	fe0914e3          	bnez	s2,686 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6a2:	8be2                	mv	s7,s8
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bf21                	j	5be <vprintf+0x44>
        s = va_arg(ap, char*);
 6a8:	008b8993          	addi	s3,s7,8
 6ac:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6b0:	02090163          	beqz	s2,6d2 <vprintf+0x158>
        while(*s != 0){
 6b4:	00094583          	lbu	a1,0(s2)
 6b8:	c9a5                	beqz	a1,728 <vprintf+0x1ae>
          putc(fd, *s);
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	df0080e7          	jalr	-528(ra) # 4ac <putc>
          s++;
 6c4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6c6:	00094583          	lbu	a1,0(s2)
 6ca:	f9e5                	bnez	a1,6ba <vprintf+0x140>
        s = va_arg(ap, char*);
 6cc:	8bce                	mv	s7,s3
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b5fd                	j	5be <vprintf+0x44>
          s = "(null)";
 6d2:	00000917          	auipc	s2,0x0
 6d6:	36e90913          	addi	s2,s2,878 # a40 <malloc+0x214>
        while(*s != 0){
 6da:	02800593          	li	a1,40
 6de:	bff1                	j	6ba <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6e0:	008b8913          	addi	s2,s7,8
 6e4:	000bc583          	lbu	a1,0(s7)
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	dc2080e7          	jalr	-574(ra) # 4ac <putc>
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b5e1                	j	5be <vprintf+0x44>
        putc(fd, c);
 6f8:	02500593          	li	a1,37
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	dae080e7          	jalr	-594(ra) # 4ac <putc>
      state = 0;
 706:	4981                	li	s3,0
 708:	bd5d                	j	5be <vprintf+0x44>
        putc(fd, '%');
 70a:	02500593          	li	a1,37
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	d9c080e7          	jalr	-612(ra) # 4ac <putc>
        putc(fd, c);
 718:	85ca                	mv	a1,s2
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	d90080e7          	jalr	-624(ra) # 4ac <putc>
      state = 0;
 724:	4981                	li	s3,0
 726:	bd61                	j	5be <vprintf+0x44>
        s = va_arg(ap, char*);
 728:	8bce                	mv	s7,s3
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bd49                	j	5be <vprintf+0x44>
    }
  }
}
 72e:	60a6                	ld	ra,72(sp)
 730:	6406                	ld	s0,64(sp)
 732:	74e2                	ld	s1,56(sp)
 734:	7942                	ld	s2,48(sp)
 736:	79a2                	ld	s3,40(sp)
 738:	7a02                	ld	s4,32(sp)
 73a:	6ae2                	ld	s5,24(sp)
 73c:	6b42                	ld	s6,16(sp)
 73e:	6ba2                	ld	s7,8(sp)
 740:	6c02                	ld	s8,0(sp)
 742:	6161                	addi	sp,sp,80
 744:	8082                	ret

0000000000000746 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 746:	715d                	addi	sp,sp,-80
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e010                	sd	a2,0(s0)
 750:	e414                	sd	a3,8(s0)
 752:	e818                	sd	a4,16(s0)
 754:	ec1c                	sd	a5,24(s0)
 756:	03043023          	sd	a6,32(s0)
 75a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 762:	8622                	mv	a2,s0
 764:	00000097          	auipc	ra,0x0
 768:	e16080e7          	jalr	-490(ra) # 57a <vprintf>
}
 76c:	60e2                	ld	ra,24(sp)
 76e:	6442                	ld	s0,16(sp)
 770:	6161                	addi	sp,sp,80
 772:	8082                	ret

0000000000000774 <printf>:

void
printf(const char *fmt, ...)
{
 774:	711d                	addi	sp,sp,-96
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e40c                	sd	a1,8(s0)
 77e:	e810                	sd	a2,16(s0)
 780:	ec14                	sd	a3,24(s0)
 782:	f018                	sd	a4,32(s0)
 784:	f41c                	sd	a5,40(s0)
 786:	03043823          	sd	a6,48(s0)
 78a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	00840613          	addi	a2,s0,8
 792:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 796:	85aa                	mv	a1,a0
 798:	4505                	li	a0,1
 79a:	00000097          	auipc	ra,0x0
 79e:	de0080e7          	jalr	-544(ra) # 57a <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6125                	addi	sp,sp,96
 7a8:	8082                	ret

00000000000007aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7aa:	1141                	addi	sp,sp,-16
 7ac:	e422                	sd	s0,8(sp)
 7ae:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	00001797          	auipc	a5,0x1
 7b8:	84c7b783          	ld	a5,-1972(a5) # 1000 <freep>
 7bc:	a02d                	j	7e6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7be:	4618                	lw	a4,8(a2)
 7c0:	9f2d                	addw	a4,a4,a1
 7c2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	6398                	ld	a4,0(a5)
 7c8:	6310                	ld	a2,0(a4)
 7ca:	a83d                	j	808 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7cc:	ff852703          	lw	a4,-8(a0)
 7d0:	9f31                	addw	a4,a4,a2
 7d2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d4:	ff053683          	ld	a3,-16(a0)
 7d8:	a091                	j	81c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7da:	6398                	ld	a4,0(a5)
 7dc:	00e7e463          	bltu	a5,a4,7e4 <free+0x3a>
 7e0:	00e6ea63          	bltu	a3,a4,7f4 <free+0x4a>
{
 7e4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e6:	fed7fae3          	bgeu	a5,a3,7da <free+0x30>
 7ea:	6398                	ld	a4,0(a5)
 7ec:	00e6e463          	bltu	a3,a4,7f4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	fee7eae3          	bltu	a5,a4,7e4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7f4:	ff852583          	lw	a1,-8(a0)
 7f8:	6390                	ld	a2,0(a5)
 7fa:	02059813          	slli	a6,a1,0x20
 7fe:	01c85713          	srli	a4,a6,0x1c
 802:	9736                	add	a4,a4,a3
 804:	fae60de3          	beq	a2,a4,7be <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 808:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 80c:	4790                	lw	a2,8(a5)
 80e:	02061593          	slli	a1,a2,0x20
 812:	01c5d713          	srli	a4,a1,0x1c
 816:	973e                	add	a4,a4,a5
 818:	fae68ae3          	beq	a3,a4,7cc <free+0x22>
    p->s.ptr = bp->s.ptr;
 81c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 81e:	00000717          	auipc	a4,0x0
 822:	7ef73123          	sd	a5,2018(a4) # 1000 <freep>
}
 826:	6422                	ld	s0,8(sp)
 828:	0141                	addi	sp,sp,16
 82a:	8082                	ret

000000000000082c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 82c:	7139                	addi	sp,sp,-64
 82e:	fc06                	sd	ra,56(sp)
 830:	f822                	sd	s0,48(sp)
 832:	f426                	sd	s1,40(sp)
 834:	f04a                	sd	s2,32(sp)
 836:	ec4e                	sd	s3,24(sp)
 838:	e852                	sd	s4,16(sp)
 83a:	e456                	sd	s5,8(sp)
 83c:	e05a                	sd	s6,0(sp)
 83e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 840:	02051493          	slli	s1,a0,0x20
 844:	9081                	srli	s1,s1,0x20
 846:	04bd                	addi	s1,s1,15
 848:	8091                	srli	s1,s1,0x4
 84a:	0014899b          	addiw	s3,s1,1
 84e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 850:	00000517          	auipc	a0,0x0
 854:	7b053503          	ld	a0,1968(a0) # 1000 <freep>
 858:	c515                	beqz	a0,884 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85c:	4798                	lw	a4,8(a5)
 85e:	02977f63          	bgeu	a4,s1,89c <malloc+0x70>
  if(nu < 4096)
 862:	8a4e                	mv	s4,s3
 864:	0009871b          	sext.w	a4,s3
 868:	6685                	lui	a3,0x1
 86a:	00d77363          	bgeu	a4,a3,870 <malloc+0x44>
 86e:	6a05                	lui	s4,0x1
 870:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 874:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 878:	00000917          	auipc	s2,0x0
 87c:	78890913          	addi	s2,s2,1928 # 1000 <freep>
  if(p == (char*)-1)
 880:	5afd                	li	s5,-1
 882:	a895                	j	8f6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 884:	00000797          	auipc	a5,0x0
 888:	78c78793          	addi	a5,a5,1932 # 1010 <base>
 88c:	00000717          	auipc	a4,0x0
 890:	76f73a23          	sd	a5,1908(a4) # 1000 <freep>
 894:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 896:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 89a:	b7e1                	j	862 <malloc+0x36>
      if(p->s.size == nunits)
 89c:	02e48c63          	beq	s1,a4,8d4 <malloc+0xa8>
        p->s.size -= nunits;
 8a0:	4137073b          	subw	a4,a4,s3
 8a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a6:	02071693          	slli	a3,a4,0x20
 8aa:	01c6d713          	srli	a4,a3,0x1c
 8ae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74a73623          	sd	a0,1868(a4) # 1000 <freep>
      return (void*)(p + 1);
 8bc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c0:	70e2                	ld	ra,56(sp)
 8c2:	7442                	ld	s0,48(sp)
 8c4:	74a2                	ld	s1,40(sp)
 8c6:	7902                	ld	s2,32(sp)
 8c8:	69e2                	ld	s3,24(sp)
 8ca:	6a42                	ld	s4,16(sp)
 8cc:	6aa2                	ld	s5,8(sp)
 8ce:	6b02                	ld	s6,0(sp)
 8d0:	6121                	addi	sp,sp,64
 8d2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8d4:	6398                	ld	a4,0(a5)
 8d6:	e118                	sd	a4,0(a0)
 8d8:	bff1                	j	8b4 <malloc+0x88>
  hp->s.size = nu;
 8da:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8de:	0541                	addi	a0,a0,16
 8e0:	00000097          	auipc	ra,0x0
 8e4:	eca080e7          	jalr	-310(ra) # 7aa <free>
  return freep;
 8e8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ec:	d971                	beqz	a0,8c0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f0:	4798                	lw	a4,8(a5)
 8f2:	fa9775e3          	bgeu	a4,s1,89c <malloc+0x70>
    if(p == freep)
 8f6:	00093703          	ld	a4,0(s2)
 8fa:	853e                	mv	a0,a5
 8fc:	fef719e3          	bne	a4,a5,8ee <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 900:	8552                	mv	a0,s4
 902:	00000097          	auipc	ra,0x0
 906:	b92080e7          	jalr	-1134(ra) # 494 <sbrk>
  if(p == (char*)-1)
 90a:	fd5518e3          	bne	a0,s5,8da <malloc+0xae>
        return 0;
 90e:	4501                	li	a0,0
 910:	bf45                	j	8c0 <malloc+0x94>
