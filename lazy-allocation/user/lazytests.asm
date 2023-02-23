
user/_lazytests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sparse_memory>:
#include "kernel/riscv.h"

#define REGION_SZ (1024 * 1024 * 1024)

void sparse_memory(char *s)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    char *i, *prev_end, *new_end;

    prev_end = sbrk(REGION_SZ);
   8:	40000537          	lui	a0,0x40000
   c:	00000097          	auipc	ra,0x0
  10:	622080e7          	jalr	1570(ra) # 62e <sbrk>
    if (prev_end == (char *)0xffffffffffffffffL)
  14:	57fd                	li	a5,-1
  16:	02f50c63          	beq	a0,a5,4e <sparse_memory+0x4e>
        printf("sbrk() failed\n");
        exit(1);
    }
    new_end = prev_end + REGION_SZ;

    for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  1a:	6605                	lui	a2,0x1
  1c:	962a                	add	a2,a2,a0
  1e:	400017b7          	lui	a5,0x40001
  22:	00f50733          	add	a4,a0,a5
  26:	87b2                	mv	a5,a2
  28:	000406b7          	lui	a3,0x40
        *(char **)i = i;
  2c:	e39c                	sd	a5,0(a5)
    for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  2e:	97b6                	add	a5,a5,a3
  30:	fee79ee3          	bne	a5,a4,2c <sparse_memory+0x2c>

    for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  34:	000406b7          	lui	a3,0x40
    {
        if (*(char **)i != i)
  38:	621c                	ld	a5,0(a2)
  3a:	02c79763          	bne	a5,a2,68 <sparse_memory+0x68>
    for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  3e:	9636                	add	a2,a2,a3
  40:	fee61ce3          	bne	a2,a4,38 <sparse_memory+0x38>
            printf("failed to read value from memory\n");
            exit(1);
        }
    }

    exit(0);
  44:	4501                	li	a0,0
  46:	00000097          	auipc	ra,0x0
  4a:	560080e7          	jalr	1376(ra) # 5a6 <exit>
        printf("sbrk() failed\n");
  4e:	00001517          	auipc	a0,0x1
  52:	a6250513          	addi	a0,a0,-1438 # ab0 <malloc+0xea>
  56:	00001097          	auipc	ra,0x1
  5a:	8b8080e7          	jalr	-1864(ra) # 90e <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	546080e7          	jalr	1350(ra) # 5a6 <exit>
            printf("failed to read value from memory\n");
  68:	00001517          	auipc	a0,0x1
  6c:	a5850513          	addi	a0,a0,-1448 # ac0 <malloc+0xfa>
  70:	00001097          	auipc	ra,0x1
  74:	89e080e7          	jalr	-1890(ra) # 90e <printf>
            exit(1);
  78:	4505                	li	a0,1
  7a:	00000097          	auipc	ra,0x0
  7e:	52c080e7          	jalr	1324(ra) # 5a6 <exit>

0000000000000082 <sparse_memory_unmap>:
}

void sparse_memory_unmap(char *s)
{
  82:	7139                	addi	sp,sp,-64
  84:	fc06                	sd	ra,56(sp)
  86:	f822                	sd	s0,48(sp)
  88:	f426                	sd	s1,40(sp)
  8a:	f04a                	sd	s2,32(sp)
  8c:	ec4e                	sd	s3,24(sp)
  8e:	0080                	addi	s0,sp,64
    int pid;
    char *i, *prev_end, *new_end;

    prev_end = sbrk(REGION_SZ);
  90:	40000537          	lui	a0,0x40000
  94:	00000097          	auipc	ra,0x0
  98:	59a080e7          	jalr	1434(ra) # 62e <sbrk>
    if (prev_end == (char *)0xffffffffffffffffL)
  9c:	57fd                	li	a5,-1
  9e:	04f50963          	beq	a0,a5,f0 <sparse_memory_unmap+0x6e>
        printf("sbrk() failed\n");
        exit(1);
    }
    new_end = prev_end + REGION_SZ;

    for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  a2:	6905                	lui	s2,0x1
  a4:	992a                	add	s2,s2,a0
  a6:	400017b7          	lui	a5,0x40001
  aa:	00f504b3          	add	s1,a0,a5
  ae:	87ca                	mv	a5,s2
  b0:	01000737          	lui	a4,0x1000
        *(char **)i = i;
  b4:	e39c                	sd	a5,0(a5)
    for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  b6:	97ba                	add	a5,a5,a4
  b8:	fef49ee3          	bne	s1,a5,b4 <sparse_memory_unmap+0x32>

    for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  bc:	010009b7          	lui	s3,0x1000
    {
        pid = fork();
  c0:	00000097          	auipc	ra,0x0
  c4:	4de080e7          	jalr	1246(ra) # 59e <fork>
        if (pid < 0)
  c8:	04054163          	bltz	a0,10a <sparse_memory_unmap+0x88>
        {
            printf("error forking\n");
            exit(1);
        }
        else if (pid == 0)
  cc:	cd21                	beqz	a0,124 <sparse_memory_unmap+0xa2>
            exit(0);
        }
        else
        {
            int status;
            wait(&status);
  ce:	fcc40513          	addi	a0,s0,-52
  d2:	00000097          	auipc	ra,0x0
  d6:	4dc080e7          	jalr	1244(ra) # 5ae <wait>
            if (status == 0)
  da:	fcc42783          	lw	a5,-52(s0)
  de:	c3a5                	beqz	a5,13e <sparse_memory_unmap+0xbc>
    for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  e0:	994e                	add	s2,s2,s3
  e2:	fd249fe3          	bne	s1,s2,c0 <sparse_memory_unmap+0x3e>
                exit(1);
            }
        }
    }

    exit(0);
  e6:	4501                	li	a0,0
  e8:	00000097          	auipc	ra,0x0
  ec:	4be080e7          	jalr	1214(ra) # 5a6 <exit>
        printf("sbrk() failed\n");
  f0:	00001517          	auipc	a0,0x1
  f4:	9c050513          	addi	a0,a0,-1600 # ab0 <malloc+0xea>
  f8:	00001097          	auipc	ra,0x1
  fc:	816080e7          	jalr	-2026(ra) # 90e <printf>
        exit(1);
 100:	4505                	li	a0,1
 102:	00000097          	auipc	ra,0x0
 106:	4a4080e7          	jalr	1188(ra) # 5a6 <exit>
            printf("error forking\n");
 10a:	00001517          	auipc	a0,0x1
 10e:	9de50513          	addi	a0,a0,-1570 # ae8 <malloc+0x122>
 112:	00000097          	auipc	ra,0x0
 116:	7fc080e7          	jalr	2044(ra) # 90e <printf>
            exit(1);
 11a:	4505                	li	a0,1
 11c:	00000097          	auipc	ra,0x0
 120:	48a080e7          	jalr	1162(ra) # 5a6 <exit>
            sbrk(-1L * REGION_SZ);
 124:	c0000537          	lui	a0,0xc0000
 128:	00000097          	auipc	ra,0x0
 12c:	506080e7          	jalr	1286(ra) # 62e <sbrk>
            *(char **)i = i;
 130:	01293023          	sd	s2,0(s2) # 1000 <freep>
            exit(0);
 134:	4501                	li	a0,0
 136:	00000097          	auipc	ra,0x0
 13a:	470080e7          	jalr	1136(ra) # 5a6 <exit>
                printf("memory not unmapped\n");
 13e:	00001517          	auipc	a0,0x1
 142:	9ba50513          	addi	a0,a0,-1606 # af8 <malloc+0x132>
 146:	00000097          	auipc	ra,0x0
 14a:	7c8080e7          	jalr	1992(ra) # 90e <printf>
                exit(1);
 14e:	4505                	li	a0,1
 150:	00000097          	auipc	ra,0x0
 154:	456080e7          	jalr	1110(ra) # 5a6 <exit>

0000000000000158 <oom>:
}

void oom(char *s)
{
 158:	7179                	addi	sp,sp,-48
 15a:	f406                	sd	ra,40(sp)
 15c:	f022                	sd	s0,32(sp)
 15e:	ec26                	sd	s1,24(sp)
 160:	1800                	addi	s0,sp,48
    void *m1, *m2;
    int pid;

    if ((pid = fork()) == 0)
 162:	00000097          	auipc	ra,0x0
 166:	43c080e7          	jalr	1084(ra) # 59e <fork>
    {
        m1 = 0;
 16a:	4481                	li	s1,0
    if ((pid = fork()) == 0)
 16c:	c10d                	beqz	a0,18e <oom+0x36>
        exit(0);
    }
    else
    {
        int xstatus;
        wait(&xstatus);
 16e:	fdc40513          	addi	a0,s0,-36
 172:	00000097          	auipc	ra,0x0
 176:	43c080e7          	jalr	1084(ra) # 5ae <wait>
        exit(xstatus == 0);
 17a:	fdc42503          	lw	a0,-36(s0)
 17e:	00153513          	seqz	a0,a0
 182:	00000097          	auipc	ra,0x0
 186:	424080e7          	jalr	1060(ra) # 5a6 <exit>
            *(char **)m2 = m1;
 18a:	e104                	sd	s1,0(a0)
            m1 = m2;
 18c:	84aa                	mv	s1,a0
        while ((m2 = malloc(4096 * 4096)) != 0)
 18e:	01000537          	lui	a0,0x1000
 192:	00001097          	auipc	ra,0x1
 196:	834080e7          	jalr	-1996(ra) # 9c6 <malloc>
 19a:	f965                	bnez	a0,18a <oom+0x32>
        exit(0);
 19c:	00000097          	auipc	ra,0x0
 1a0:	40a080e7          	jalr	1034(ra) # 5a6 <exit>

00000000000001a4 <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s)
{
 1a4:	7179                	addi	sp,sp,-48
 1a6:	f406                	sd	ra,40(sp)
 1a8:	f022                	sd	s0,32(sp)
 1aa:	ec26                	sd	s1,24(sp)
 1ac:	e84a                	sd	s2,16(sp)
 1ae:	1800                	addi	s0,sp,48
 1b0:	892a                	mv	s2,a0
 1b2:	84ae                	mv	s1,a1
    int pid;
    int xstatus;

    printf("running test %s\n", s);
 1b4:	00001517          	auipc	a0,0x1
 1b8:	95c50513          	addi	a0,a0,-1700 # b10 <malloc+0x14a>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	752080e7          	jalr	1874(ra) # 90e <printf>
    if ((pid = fork()) < 0)
 1c4:	00000097          	auipc	ra,0x0
 1c8:	3da080e7          	jalr	986(ra) # 59e <fork>
 1cc:	02054f63          	bltz	a0,20a <run+0x66>
    {
        printf("runtest: fork error\n");
        exit(1);
    }
    if (pid == 0)
 1d0:	c931                	beqz	a0,224 <run+0x80>
        f(s);
        exit(0);
    }
    else
    {
        wait(&xstatus);
 1d2:	fdc40513          	addi	a0,s0,-36
 1d6:	00000097          	auipc	ra,0x0
 1da:	3d8080e7          	jalr	984(ra) # 5ae <wait>
        if (xstatus != 0)
 1de:	fdc42783          	lw	a5,-36(s0)
 1e2:	cba1                	beqz	a5,232 <run+0x8e>
            printf("test %s: FAILED\n", s);
 1e4:	85a6                	mv	a1,s1
 1e6:	00001517          	auipc	a0,0x1
 1ea:	95a50513          	addi	a0,a0,-1702 # b40 <malloc+0x17a>
 1ee:	00000097          	auipc	ra,0x0
 1f2:	720080e7          	jalr	1824(ra) # 90e <printf>
        else
            printf("test %s: OK\n", s);
        return xstatus == 0;
 1f6:	fdc42503          	lw	a0,-36(s0)
    }
}
 1fa:	00153513          	seqz	a0,a0
 1fe:	70a2                	ld	ra,40(sp)
 200:	7402                	ld	s0,32(sp)
 202:	64e2                	ld	s1,24(sp)
 204:	6942                	ld	s2,16(sp)
 206:	6145                	addi	sp,sp,48
 208:	8082                	ret
        printf("runtest: fork error\n");
 20a:	00001517          	auipc	a0,0x1
 20e:	91e50513          	addi	a0,a0,-1762 # b28 <malloc+0x162>
 212:	00000097          	auipc	ra,0x0
 216:	6fc080e7          	jalr	1788(ra) # 90e <printf>
        exit(1);
 21a:	4505                	li	a0,1
 21c:	00000097          	auipc	ra,0x0
 220:	38a080e7          	jalr	906(ra) # 5a6 <exit>
        f(s);
 224:	8526                	mv	a0,s1
 226:	9902                	jalr	s2
        exit(0);
 228:	4501                	li	a0,0
 22a:	00000097          	auipc	ra,0x0
 22e:	37c080e7          	jalr	892(ra) # 5a6 <exit>
            printf("test %s: OK\n", s);
 232:	85a6                	mv	a1,s1
 234:	00001517          	auipc	a0,0x1
 238:	92450513          	addi	a0,a0,-1756 # b58 <malloc+0x192>
 23c:	00000097          	auipc	ra,0x0
 240:	6d2080e7          	jalr	1746(ra) # 90e <printf>
 244:	bf4d                	j	1f6 <run+0x52>

0000000000000246 <main>:

int main(int argc, char *argv[])
{
 246:	7119                	addi	sp,sp,-128
 248:	fc86                	sd	ra,120(sp)
 24a:	f8a2                	sd	s0,112(sp)
 24c:	f4a6                	sd	s1,104(sp)
 24e:	f0ca                	sd	s2,96(sp)
 250:	ecce                	sd	s3,88(sp)
 252:	e8d2                	sd	s4,80(sp)
 254:	e4d6                	sd	s5,72(sp)
 256:	0100                	addi	s0,sp,128
    char *n = 0;
    if (argc > 1)
 258:	4785                	li	a5,1
    char *n = 0;
 25a:	4981                	li	s3,0
    if (argc > 1)
 25c:	00a7d463          	bge	a5,a0,264 <main+0x1e>
    {
        n = argv[1];
 260:	0085b983          	ld	s3,8(a1)

    struct test
    {
        void (*f)(char *);
        char *s;
    } tests[] = {
 264:	00001797          	auipc	a5,0x1
 268:	97c78793          	addi	a5,a5,-1668 # be0 <malloc+0x21a>
 26c:	0007b883          	ld	a7,0(a5)
 270:	0087b803          	ld	a6,8(a5)
 274:	6b88                	ld	a0,16(a5)
 276:	6f8c                	ld	a1,24(a5)
 278:	7390                	ld	a2,32(a5)
 27a:	7794                	ld	a3,40(a5)
 27c:	7b98                	ld	a4,48(a5)
 27e:	7f9c                	ld	a5,56(a5)
 280:	f9143023          	sd	a7,-128(s0)
 284:	f9043423          	sd	a6,-120(s0)
 288:	f8a43823          	sd	a0,-112(s0)
 28c:	f8b43c23          	sd	a1,-104(s0)
 290:	fac43023          	sd	a2,-96(s0)
 294:	fad43423          	sd	a3,-88(s0)
 298:	fae43823          	sd	a4,-80(s0)
 29c:	faf43c23          	sd	a5,-72(s0)
        {sparse_memory_unmap, "lazy unmap"},
        {oom, "out of memory"},
        {0, 0},
    };

    printf("lazytests starting\n");
 2a0:	00001517          	auipc	a0,0x1
 2a4:	8c850513          	addi	a0,a0,-1848 # b68 <malloc+0x1a2>
 2a8:	00000097          	auipc	ra,0x0
 2ac:	666080e7          	jalr	1638(ra) # 90e <printf>

    int fail = 0;
    for (struct test *t = tests; t->s != 0; t++)
 2b0:	f8843903          	ld	s2,-120(s0)
 2b4:	04090963          	beqz	s2,306 <main+0xc0>
 2b8:	f8040493          	addi	s1,s0,-128
    int fail = 0;
 2bc:	4a01                	li	s4,0
    {
        if ((n == 0) || strcmp(t->s, n) == 0)
        {
            if (!run(t->f, t->s))
                fail = 1;
 2be:	4a85                	li	s5,1
 2c0:	a031                	j	2cc <main+0x86>
    for (struct test *t = tests; t->s != 0; t++)
 2c2:	04c1                	addi	s1,s1,16
 2c4:	0084b903          	ld	s2,8(s1)
 2c8:	02090463          	beqz	s2,2f0 <main+0xaa>
        if ((n == 0) || strcmp(t->s, n) == 0)
 2cc:	00098963          	beqz	s3,2de <main+0x98>
 2d0:	85ce                	mv	a1,s3
 2d2:	854a                	mv	a0,s2
 2d4:	00000097          	auipc	ra,0x0
 2d8:	082080e7          	jalr	130(ra) # 356 <strcmp>
 2dc:	f17d                	bnez	a0,2c2 <main+0x7c>
            if (!run(t->f, t->s))
 2de:	85ca                	mv	a1,s2
 2e0:	6088                	ld	a0,0(s1)
 2e2:	00000097          	auipc	ra,0x0
 2e6:	ec2080e7          	jalr	-318(ra) # 1a4 <run>
 2ea:	fd61                	bnez	a0,2c2 <main+0x7c>
                fail = 1;
 2ec:	8a56                	mv	s4,s5
 2ee:	bfd1                	j	2c2 <main+0x7c>
        }
    }
    if (!fail)
 2f0:	000a0b63          	beqz	s4,306 <main+0xc0>
        printf("ALL TESTS PASSED\n");
    else
        printf("SOME TESTS FAILED\n");
 2f4:	00001517          	auipc	a0,0x1
 2f8:	8a450513          	addi	a0,a0,-1884 # b98 <malloc+0x1d2>
 2fc:	00000097          	auipc	ra,0x0
 300:	612080e7          	jalr	1554(ra) # 90e <printf>
 304:	a809                	j	316 <main+0xd0>
        printf("ALL TESTS PASSED\n");
 306:	00001517          	auipc	a0,0x1
 30a:	87a50513          	addi	a0,a0,-1926 # b80 <malloc+0x1ba>
 30e:	00000097          	auipc	ra,0x0
 312:	600080e7          	jalr	1536(ra) # 90e <printf>
    exit(1); // not reached.
 316:	4505                	li	a0,1
 318:	00000097          	auipc	ra,0x0
 31c:	28e080e7          	jalr	654(ra) # 5a6 <exit>

0000000000000320 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  extern int main();
  main();
 328:	00000097          	auipc	ra,0x0
 32c:	f1e080e7          	jalr	-226(ra) # 246 <main>
  exit(0);
 330:	4501                	li	a0,0
 332:	00000097          	auipc	ra,0x0
 336:	274080e7          	jalr	628(ra) # 5a6 <exit>

000000000000033a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 340:	87aa                	mv	a5,a0
 342:	0585                	addi	a1,a1,1
 344:	0785                	addi	a5,a5,1
 346:	fff5c703          	lbu	a4,-1(a1)
 34a:	fee78fa3          	sb	a4,-1(a5)
 34e:	fb75                	bnez	a4,342 <strcpy+0x8>
    ;
  return os;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 35c:	00054783          	lbu	a5,0(a0)
 360:	cb91                	beqz	a5,374 <strcmp+0x1e>
 362:	0005c703          	lbu	a4,0(a1)
 366:	00f71763          	bne	a4,a5,374 <strcmp+0x1e>
    p++, q++;
 36a:	0505                	addi	a0,a0,1
 36c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 36e:	00054783          	lbu	a5,0(a0)
 372:	fbe5                	bnez	a5,362 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 374:	0005c503          	lbu	a0,0(a1)
}
 378:	40a7853b          	subw	a0,a5,a0
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <strlen>:

uint
strlen(const char *s)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 388:	00054783          	lbu	a5,0(a0)
 38c:	cf91                	beqz	a5,3a8 <strlen+0x26>
 38e:	0505                	addi	a0,a0,1
 390:	87aa                	mv	a5,a0
 392:	86be                	mv	a3,a5
 394:	0785                	addi	a5,a5,1
 396:	fff7c703          	lbu	a4,-1(a5)
 39a:	ff65                	bnez	a4,392 <strlen+0x10>
 39c:	40a6853b          	subw	a0,a3,a0
 3a0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 3a2:	6422                	ld	s0,8(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret
  for(n = 0; s[n]; n++)
 3a8:	4501                	li	a0,0
 3aa:	bfe5                	j	3a2 <strlen+0x20>

00000000000003ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3b2:	ca19                	beqz	a2,3c8 <memset+0x1c>
 3b4:	87aa                	mv	a5,a0
 3b6:	1602                	slli	a2,a2,0x20
 3b8:	9201                	srli	a2,a2,0x20
 3ba:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3be:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3c2:	0785                	addi	a5,a5,1
 3c4:	fee79de3          	bne	a5,a4,3be <memset+0x12>
  }
  return dst;
}
 3c8:	6422                	ld	s0,8(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <strchr>:

char*
strchr(const char *s, char c)
{
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e422                	sd	s0,8(sp)
 3d2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3d4:	00054783          	lbu	a5,0(a0)
 3d8:	cb99                	beqz	a5,3ee <strchr+0x20>
    if(*s == c)
 3da:	00f58763          	beq	a1,a5,3e8 <strchr+0x1a>
  for(; *s; s++)
 3de:	0505                	addi	a0,a0,1
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	fbfd                	bnez	a5,3da <strchr+0xc>
      return (char*)s;
  return 0;
 3e6:	4501                	li	a0,0
}
 3e8:	6422                	ld	s0,8(sp)
 3ea:	0141                	addi	sp,sp,16
 3ec:	8082                	ret
  return 0;
 3ee:	4501                	li	a0,0
 3f0:	bfe5                	j	3e8 <strchr+0x1a>

00000000000003f2 <gets>:

char*
gets(char *buf, int max)
{
 3f2:	711d                	addi	sp,sp,-96
 3f4:	ec86                	sd	ra,88(sp)
 3f6:	e8a2                	sd	s0,80(sp)
 3f8:	e4a6                	sd	s1,72(sp)
 3fa:	e0ca                	sd	s2,64(sp)
 3fc:	fc4e                	sd	s3,56(sp)
 3fe:	f852                	sd	s4,48(sp)
 400:	f456                	sd	s5,40(sp)
 402:	f05a                	sd	s6,32(sp)
 404:	ec5e                	sd	s7,24(sp)
 406:	1080                	addi	s0,sp,96
 408:	8baa                	mv	s7,a0
 40a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 40c:	892a                	mv	s2,a0
 40e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 410:	4aa9                	li	s5,10
 412:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 414:	89a6                	mv	s3,s1
 416:	2485                	addiw	s1,s1,1
 418:	0344d863          	bge	s1,s4,448 <gets+0x56>
    cc = read(0, &c, 1);
 41c:	4605                	li	a2,1
 41e:	faf40593          	addi	a1,s0,-81
 422:	4501                	li	a0,0
 424:	00000097          	auipc	ra,0x0
 428:	19a080e7          	jalr	410(ra) # 5be <read>
    if(cc < 1)
 42c:	00a05e63          	blez	a0,448 <gets+0x56>
    buf[i++] = c;
 430:	faf44783          	lbu	a5,-81(s0)
 434:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 438:	01578763          	beq	a5,s5,446 <gets+0x54>
 43c:	0905                	addi	s2,s2,1
 43e:	fd679be3          	bne	a5,s6,414 <gets+0x22>
  for(i=0; i+1 < max; ){
 442:	89a6                	mv	s3,s1
 444:	a011                	j	448 <gets+0x56>
 446:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 448:	99de                	add	s3,s3,s7
 44a:	00098023          	sb	zero,0(s3) # 1000000 <base+0xffeff0>
  return buf;
}
 44e:	855e                	mv	a0,s7
 450:	60e6                	ld	ra,88(sp)
 452:	6446                	ld	s0,80(sp)
 454:	64a6                	ld	s1,72(sp)
 456:	6906                	ld	s2,64(sp)
 458:	79e2                	ld	s3,56(sp)
 45a:	7a42                	ld	s4,48(sp)
 45c:	7aa2                	ld	s5,40(sp)
 45e:	7b02                	ld	s6,32(sp)
 460:	6be2                	ld	s7,24(sp)
 462:	6125                	addi	sp,sp,96
 464:	8082                	ret

0000000000000466 <stat>:

int
stat(const char *n, struct stat *st)
{
 466:	1101                	addi	sp,sp,-32
 468:	ec06                	sd	ra,24(sp)
 46a:	e822                	sd	s0,16(sp)
 46c:	e426                	sd	s1,8(sp)
 46e:	e04a                	sd	s2,0(sp)
 470:	1000                	addi	s0,sp,32
 472:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 474:	4581                	li	a1,0
 476:	00000097          	auipc	ra,0x0
 47a:	170080e7          	jalr	368(ra) # 5e6 <open>
  if(fd < 0)
 47e:	02054563          	bltz	a0,4a8 <stat+0x42>
 482:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 484:	85ca                	mv	a1,s2
 486:	00000097          	auipc	ra,0x0
 48a:	178080e7          	jalr	376(ra) # 5fe <fstat>
 48e:	892a                	mv	s2,a0
  close(fd);
 490:	8526                	mv	a0,s1
 492:	00000097          	auipc	ra,0x0
 496:	13c080e7          	jalr	316(ra) # 5ce <close>
  return r;
}
 49a:	854a                	mv	a0,s2
 49c:	60e2                	ld	ra,24(sp)
 49e:	6442                	ld	s0,16(sp)
 4a0:	64a2                	ld	s1,8(sp)
 4a2:	6902                	ld	s2,0(sp)
 4a4:	6105                	addi	sp,sp,32
 4a6:	8082                	ret
    return -1;
 4a8:	597d                	li	s2,-1
 4aa:	bfc5                	j	49a <stat+0x34>

00000000000004ac <atoi>:

int
atoi(const char *s)
{
 4ac:	1141                	addi	sp,sp,-16
 4ae:	e422                	sd	s0,8(sp)
 4b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b2:	00054683          	lbu	a3,0(a0)
 4b6:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x3efc0>
 4ba:	0ff7f793          	zext.b	a5,a5
 4be:	4625                	li	a2,9
 4c0:	02f66863          	bltu	a2,a5,4f0 <atoi+0x44>
 4c4:	872a                	mv	a4,a0
  n = 0;
 4c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4c8:	0705                	addi	a4,a4,1 # 1000001 <base+0xffeff1>
 4ca:	0025179b          	slliw	a5,a0,0x2
 4ce:	9fa9                	addw	a5,a5,a0
 4d0:	0017979b          	slliw	a5,a5,0x1
 4d4:	9fb5                	addw	a5,a5,a3
 4d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4da:	00074683          	lbu	a3,0(a4)
 4de:	fd06879b          	addiw	a5,a3,-48
 4e2:	0ff7f793          	zext.b	a5,a5
 4e6:	fef671e3          	bgeu	a2,a5,4c8 <atoi+0x1c>
  return n;
}
 4ea:	6422                	ld	s0,8(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret
  n = 0;
 4f0:	4501                	li	a0,0
 4f2:	bfe5                	j	4ea <atoi+0x3e>

00000000000004f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e422                	sd	s0,8(sp)
 4f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4fa:	02b57463          	bgeu	a0,a1,522 <memmove+0x2e>
    while(n-- > 0)
 4fe:	00c05f63          	blez	a2,51c <memmove+0x28>
 502:	1602                	slli	a2,a2,0x20
 504:	9201                	srli	a2,a2,0x20
 506:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 50a:	872a                	mv	a4,a0
      *dst++ = *src++;
 50c:	0585                	addi	a1,a1,1
 50e:	0705                	addi	a4,a4,1
 510:	fff5c683          	lbu	a3,-1(a1)
 514:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 518:	fee79ae3          	bne	a5,a4,50c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 51c:	6422                	ld	s0,8(sp)
 51e:	0141                	addi	sp,sp,16
 520:	8082                	ret
    dst += n;
 522:	00c50733          	add	a4,a0,a2
    src += n;
 526:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 528:	fec05ae3          	blez	a2,51c <memmove+0x28>
 52c:	fff6079b          	addiw	a5,a2,-1 # fff <digits+0x37f>
 530:	1782                	slli	a5,a5,0x20
 532:	9381                	srli	a5,a5,0x20
 534:	fff7c793          	not	a5,a5
 538:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 53a:	15fd                	addi	a1,a1,-1
 53c:	177d                	addi	a4,a4,-1
 53e:	0005c683          	lbu	a3,0(a1)
 542:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 546:	fee79ae3          	bne	a5,a4,53a <memmove+0x46>
 54a:	bfc9                	j	51c <memmove+0x28>

000000000000054c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 54c:	1141                	addi	sp,sp,-16
 54e:	e422                	sd	s0,8(sp)
 550:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 552:	ca05                	beqz	a2,582 <memcmp+0x36>
 554:	fff6069b          	addiw	a3,a2,-1
 558:	1682                	slli	a3,a3,0x20
 55a:	9281                	srli	a3,a3,0x20
 55c:	0685                	addi	a3,a3,1
 55e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 560:	00054783          	lbu	a5,0(a0)
 564:	0005c703          	lbu	a4,0(a1)
 568:	00e79863          	bne	a5,a4,578 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 56c:	0505                	addi	a0,a0,1
    p2++;
 56e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 570:	fed518e3          	bne	a0,a3,560 <memcmp+0x14>
  }
  return 0;
 574:	4501                	li	a0,0
 576:	a019                	j	57c <memcmp+0x30>
      return *p1 - *p2;
 578:	40e7853b          	subw	a0,a5,a4
}
 57c:	6422                	ld	s0,8(sp)
 57e:	0141                	addi	sp,sp,16
 580:	8082                	ret
  return 0;
 582:	4501                	li	a0,0
 584:	bfe5                	j	57c <memcmp+0x30>

0000000000000586 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 586:	1141                	addi	sp,sp,-16
 588:	e406                	sd	ra,8(sp)
 58a:	e022                	sd	s0,0(sp)
 58c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 58e:	00000097          	auipc	ra,0x0
 592:	f66080e7          	jalr	-154(ra) # 4f4 <memmove>
}
 596:	60a2                	ld	ra,8(sp)
 598:	6402                	ld	s0,0(sp)
 59a:	0141                	addi	sp,sp,16
 59c:	8082                	ret

000000000000059e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 59e:	4885                	li	a7,1
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5a6:	4889                	li	a7,2
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <wait>:
.global wait
wait:
 li a7, SYS_wait
 5ae:	488d                	li	a7,3
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5b6:	4891                	li	a7,4
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <read>:
.global read
read:
 li a7, SYS_read
 5be:	4895                	li	a7,5
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <write>:
.global write
write:
 li a7, SYS_write
 5c6:	48c1                	li	a7,16
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <close>:
.global close
close:
 li a7, SYS_close
 5ce:	48d5                	li	a7,21
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5d6:	4899                	li	a7,6
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <exec>:
.global exec
exec:
 li a7, SYS_exec
 5de:	489d                	li	a7,7
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <open>:
.global open
open:
 li a7, SYS_open
 5e6:	48bd                	li	a7,15
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ee:	48c5                	li	a7,17
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5f6:	48c9                	li	a7,18
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5fe:	48a1                	li	a7,8
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <link>:
.global link
link:
 li a7, SYS_link
 606:	48cd                	li	a7,19
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 60e:	48d1                	li	a7,20
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 616:	48a5                	li	a7,9
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <dup>:
.global dup
dup:
 li a7, SYS_dup
 61e:	48a9                	li	a7,10
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 626:	48ad                	li	a7,11
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 62e:	48b1                	li	a7,12
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 636:	48b5                	li	a7,13
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 63e:	48b9                	li	a7,14
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 646:	1101                	addi	sp,sp,-32
 648:	ec06                	sd	ra,24(sp)
 64a:	e822                	sd	s0,16(sp)
 64c:	1000                	addi	s0,sp,32
 64e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 652:	4605                	li	a2,1
 654:	fef40593          	addi	a1,s0,-17
 658:	00000097          	auipc	ra,0x0
 65c:	f6e080e7          	jalr	-146(ra) # 5c6 <write>
}
 660:	60e2                	ld	ra,24(sp)
 662:	6442                	ld	s0,16(sp)
 664:	6105                	addi	sp,sp,32
 666:	8082                	ret

0000000000000668 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 668:	7139                	addi	sp,sp,-64
 66a:	fc06                	sd	ra,56(sp)
 66c:	f822                	sd	s0,48(sp)
 66e:	f426                	sd	s1,40(sp)
 670:	f04a                	sd	s2,32(sp)
 672:	ec4e                	sd	s3,24(sp)
 674:	0080                	addi	s0,sp,64
 676:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 678:	c299                	beqz	a3,67e <printint+0x16>
 67a:	0805c963          	bltz	a1,70c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 67e:	2581                	sext.w	a1,a1
  neg = 0;
 680:	4881                	li	a7,0
 682:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 686:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 688:	2601                	sext.w	a2,a2
 68a:	00000517          	auipc	a0,0x0
 68e:	5f650513          	addi	a0,a0,1526 # c80 <digits>
 692:	883a                	mv	a6,a4
 694:	2705                	addiw	a4,a4,1
 696:	02c5f7bb          	remuw	a5,a1,a2
 69a:	1782                	slli	a5,a5,0x20
 69c:	9381                	srli	a5,a5,0x20
 69e:	97aa                	add	a5,a5,a0
 6a0:	0007c783          	lbu	a5,0(a5)
 6a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6a8:	0005879b          	sext.w	a5,a1
 6ac:	02c5d5bb          	divuw	a1,a1,a2
 6b0:	0685                	addi	a3,a3,1
 6b2:	fec7f0e3          	bgeu	a5,a2,692 <printint+0x2a>
  if(neg)
 6b6:	00088c63          	beqz	a7,6ce <printint+0x66>
    buf[i++] = '-';
 6ba:	fd070793          	addi	a5,a4,-48
 6be:	00878733          	add	a4,a5,s0
 6c2:	02d00793          	li	a5,45
 6c6:	fef70823          	sb	a5,-16(a4)
 6ca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6ce:	02e05863          	blez	a4,6fe <printint+0x96>
 6d2:	fc040793          	addi	a5,s0,-64
 6d6:	00e78933          	add	s2,a5,a4
 6da:	fff78993          	addi	s3,a5,-1
 6de:	99ba                	add	s3,s3,a4
 6e0:	377d                	addiw	a4,a4,-1
 6e2:	1702                	slli	a4,a4,0x20
 6e4:	9301                	srli	a4,a4,0x20
 6e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ea:	fff94583          	lbu	a1,-1(s2)
 6ee:	8526                	mv	a0,s1
 6f0:	00000097          	auipc	ra,0x0
 6f4:	f56080e7          	jalr	-170(ra) # 646 <putc>
  while(--i >= 0)
 6f8:	197d                	addi	s2,s2,-1
 6fa:	ff3918e3          	bne	s2,s3,6ea <printint+0x82>
}
 6fe:	70e2                	ld	ra,56(sp)
 700:	7442                	ld	s0,48(sp)
 702:	74a2                	ld	s1,40(sp)
 704:	7902                	ld	s2,32(sp)
 706:	69e2                	ld	s3,24(sp)
 708:	6121                	addi	sp,sp,64
 70a:	8082                	ret
    x = -xx;
 70c:	40b005bb          	negw	a1,a1
    neg = 1;
 710:	4885                	li	a7,1
    x = -xx;
 712:	bf85                	j	682 <printint+0x1a>

0000000000000714 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 714:	715d                	addi	sp,sp,-80
 716:	e486                	sd	ra,72(sp)
 718:	e0a2                	sd	s0,64(sp)
 71a:	fc26                	sd	s1,56(sp)
 71c:	f84a                	sd	s2,48(sp)
 71e:	f44e                	sd	s3,40(sp)
 720:	f052                	sd	s4,32(sp)
 722:	ec56                	sd	s5,24(sp)
 724:	e85a                	sd	s6,16(sp)
 726:	e45e                	sd	s7,8(sp)
 728:	e062                	sd	s8,0(sp)
 72a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 72c:	0005c903          	lbu	s2,0(a1)
 730:	18090c63          	beqz	s2,8c8 <vprintf+0x1b4>
 734:	8aaa                	mv	s5,a0
 736:	8bb2                	mv	s7,a2
 738:	00158493          	addi	s1,a1,1
  state = 0;
 73c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 73e:	02500a13          	li	s4,37
 742:	4b55                	li	s6,21
 744:	a839                	j	762 <vprintf+0x4e>
        putc(fd, c);
 746:	85ca                	mv	a1,s2
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	efc080e7          	jalr	-260(ra) # 646 <putc>
 752:	a019                	j	758 <vprintf+0x44>
    } else if(state == '%'){
 754:	01498d63          	beq	s3,s4,76e <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 758:	0485                	addi	s1,s1,1
 75a:	fff4c903          	lbu	s2,-1(s1)
 75e:	16090563          	beqz	s2,8c8 <vprintf+0x1b4>
    if(state == 0){
 762:	fe0999e3          	bnez	s3,754 <vprintf+0x40>
      if(c == '%'){
 766:	ff4910e3          	bne	s2,s4,746 <vprintf+0x32>
        state = '%';
 76a:	89d2                	mv	s3,s4
 76c:	b7f5                	j	758 <vprintf+0x44>
      if(c == 'd'){
 76e:	13490263          	beq	s2,s4,892 <vprintf+0x17e>
 772:	f9d9079b          	addiw	a5,s2,-99
 776:	0ff7f793          	zext.b	a5,a5
 77a:	12fb6563          	bltu	s6,a5,8a4 <vprintf+0x190>
 77e:	f9d9079b          	addiw	a5,s2,-99
 782:	0ff7f713          	zext.b	a4,a5
 786:	10eb6f63          	bltu	s6,a4,8a4 <vprintf+0x190>
 78a:	00271793          	slli	a5,a4,0x2
 78e:	00000717          	auipc	a4,0x0
 792:	49a70713          	addi	a4,a4,1178 # c28 <malloc+0x262>
 796:	97ba                	add	a5,a5,a4
 798:	439c                	lw	a5,0(a5)
 79a:	97ba                	add	a5,a5,a4
 79c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 79e:	008b8913          	addi	s2,s7,8
 7a2:	4685                	li	a3,1
 7a4:	4629                	li	a2,10
 7a6:	000ba583          	lw	a1,0(s7)
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	ebc080e7          	jalr	-324(ra) # 668 <printint>
 7b4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b745                	j	758 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ba:	008b8913          	addi	s2,s7,8
 7be:	4681                	li	a3,0
 7c0:	4629                	li	a2,10
 7c2:	000ba583          	lw	a1,0(s7)
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	ea0080e7          	jalr	-352(ra) # 668 <printint>
 7d0:	8bca                	mv	s7,s2
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b751                	j	758 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7d6:	008b8913          	addi	s2,s7,8
 7da:	4681                	li	a3,0
 7dc:	4641                	li	a2,16
 7de:	000ba583          	lw	a1,0(s7)
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	e84080e7          	jalr	-380(ra) # 668 <printint>
 7ec:	8bca                	mv	s7,s2
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	b7a5                	j	758 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 7f2:	008b8c13          	addi	s8,s7,8
 7f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7fa:	03000593          	li	a1,48
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	e46080e7          	jalr	-442(ra) # 646 <putc>
  putc(fd, 'x');
 808:	07800593          	li	a1,120
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	e38080e7          	jalr	-456(ra) # 646 <putc>
 816:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 818:	00000b97          	auipc	s7,0x0
 81c:	468b8b93          	addi	s7,s7,1128 # c80 <digits>
 820:	03c9d793          	srli	a5,s3,0x3c
 824:	97de                	add	a5,a5,s7
 826:	0007c583          	lbu	a1,0(a5)
 82a:	8556                	mv	a0,s5
 82c:	00000097          	auipc	ra,0x0
 830:	e1a080e7          	jalr	-486(ra) # 646 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 834:	0992                	slli	s3,s3,0x4
 836:	397d                	addiw	s2,s2,-1
 838:	fe0914e3          	bnez	s2,820 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 83c:	8be2                	mv	s7,s8
      state = 0;
 83e:	4981                	li	s3,0
 840:	bf21                	j	758 <vprintf+0x44>
        s = va_arg(ap, char*);
 842:	008b8993          	addi	s3,s7,8
 846:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 84a:	02090163          	beqz	s2,86c <vprintf+0x158>
        while(*s != 0){
 84e:	00094583          	lbu	a1,0(s2)
 852:	c9a5                	beqz	a1,8c2 <vprintf+0x1ae>
          putc(fd, *s);
 854:	8556                	mv	a0,s5
 856:	00000097          	auipc	ra,0x0
 85a:	df0080e7          	jalr	-528(ra) # 646 <putc>
          s++;
 85e:	0905                	addi	s2,s2,1
        while(*s != 0){
 860:	00094583          	lbu	a1,0(s2)
 864:	f9e5                	bnez	a1,854 <vprintf+0x140>
        s = va_arg(ap, char*);
 866:	8bce                	mv	s7,s3
      state = 0;
 868:	4981                	li	s3,0
 86a:	b5fd                	j	758 <vprintf+0x44>
          s = "(null)";
 86c:	00000917          	auipc	s2,0x0
 870:	3b490913          	addi	s2,s2,948 # c20 <malloc+0x25a>
        while(*s != 0){
 874:	02800593          	li	a1,40
 878:	bff1                	j	854 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 87a:	008b8913          	addi	s2,s7,8
 87e:	000bc583          	lbu	a1,0(s7)
 882:	8556                	mv	a0,s5
 884:	00000097          	auipc	ra,0x0
 888:	dc2080e7          	jalr	-574(ra) # 646 <putc>
 88c:	8bca                	mv	s7,s2
      state = 0;
 88e:	4981                	li	s3,0
 890:	b5e1                	j	758 <vprintf+0x44>
        putc(fd, c);
 892:	02500593          	li	a1,37
 896:	8556                	mv	a0,s5
 898:	00000097          	auipc	ra,0x0
 89c:	dae080e7          	jalr	-594(ra) # 646 <putc>
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	bd5d                	j	758 <vprintf+0x44>
        putc(fd, '%');
 8a4:	02500593          	li	a1,37
 8a8:	8556                	mv	a0,s5
 8aa:	00000097          	auipc	ra,0x0
 8ae:	d9c080e7          	jalr	-612(ra) # 646 <putc>
        putc(fd, c);
 8b2:	85ca                	mv	a1,s2
 8b4:	8556                	mv	a0,s5
 8b6:	00000097          	auipc	ra,0x0
 8ba:	d90080e7          	jalr	-624(ra) # 646 <putc>
      state = 0;
 8be:	4981                	li	s3,0
 8c0:	bd61                	j	758 <vprintf+0x44>
        s = va_arg(ap, char*);
 8c2:	8bce                	mv	s7,s3
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	bd49                	j	758 <vprintf+0x44>
    }
  }
}
 8c8:	60a6                	ld	ra,72(sp)
 8ca:	6406                	ld	s0,64(sp)
 8cc:	74e2                	ld	s1,56(sp)
 8ce:	7942                	ld	s2,48(sp)
 8d0:	79a2                	ld	s3,40(sp)
 8d2:	7a02                	ld	s4,32(sp)
 8d4:	6ae2                	ld	s5,24(sp)
 8d6:	6b42                	ld	s6,16(sp)
 8d8:	6ba2                	ld	s7,8(sp)
 8da:	6c02                	ld	s8,0(sp)
 8dc:	6161                	addi	sp,sp,80
 8de:	8082                	ret

00000000000008e0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e0:	715d                	addi	sp,sp,-80
 8e2:	ec06                	sd	ra,24(sp)
 8e4:	e822                	sd	s0,16(sp)
 8e6:	1000                	addi	s0,sp,32
 8e8:	e010                	sd	a2,0(s0)
 8ea:	e414                	sd	a3,8(s0)
 8ec:	e818                	sd	a4,16(s0)
 8ee:	ec1c                	sd	a5,24(s0)
 8f0:	03043023          	sd	a6,32(s0)
 8f4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8fc:	8622                	mv	a2,s0
 8fe:	00000097          	auipc	ra,0x0
 902:	e16080e7          	jalr	-490(ra) # 714 <vprintf>
}
 906:	60e2                	ld	ra,24(sp)
 908:	6442                	ld	s0,16(sp)
 90a:	6161                	addi	sp,sp,80
 90c:	8082                	ret

000000000000090e <printf>:

void
printf(const char *fmt, ...)
{
 90e:	711d                	addi	sp,sp,-96
 910:	ec06                	sd	ra,24(sp)
 912:	e822                	sd	s0,16(sp)
 914:	1000                	addi	s0,sp,32
 916:	e40c                	sd	a1,8(s0)
 918:	e810                	sd	a2,16(s0)
 91a:	ec14                	sd	a3,24(s0)
 91c:	f018                	sd	a4,32(s0)
 91e:	f41c                	sd	a5,40(s0)
 920:	03043823          	sd	a6,48(s0)
 924:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 928:	00840613          	addi	a2,s0,8
 92c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 930:	85aa                	mv	a1,a0
 932:	4505                	li	a0,1
 934:	00000097          	auipc	ra,0x0
 938:	de0080e7          	jalr	-544(ra) # 714 <vprintf>
}
 93c:	60e2                	ld	ra,24(sp)
 93e:	6442                	ld	s0,16(sp)
 940:	6125                	addi	sp,sp,96
 942:	8082                	ret

0000000000000944 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 944:	1141                	addi	sp,sp,-16
 946:	e422                	sd	s0,8(sp)
 948:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94e:	00000797          	auipc	a5,0x0
 952:	6b27b783          	ld	a5,1714(a5) # 1000 <freep>
 956:	a02d                	j	980 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 958:	4618                	lw	a4,8(a2)
 95a:	9f2d                	addw	a4,a4,a1
 95c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	6310                	ld	a2,0(a4)
 964:	a83d                	j	9a2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 966:	ff852703          	lw	a4,-8(a0)
 96a:	9f31                	addw	a4,a4,a2
 96c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 96e:	ff053683          	ld	a3,-16(a0)
 972:	a091                	j	9b6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 974:	6398                	ld	a4,0(a5)
 976:	00e7e463          	bltu	a5,a4,97e <free+0x3a>
 97a:	00e6ea63          	bltu	a3,a4,98e <free+0x4a>
{
 97e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 980:	fed7fae3          	bgeu	a5,a3,974 <free+0x30>
 984:	6398                	ld	a4,0(a5)
 986:	00e6e463          	bltu	a3,a4,98e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98a:	fee7eae3          	bltu	a5,a4,97e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 98e:	ff852583          	lw	a1,-8(a0)
 992:	6390                	ld	a2,0(a5)
 994:	02059813          	slli	a6,a1,0x20
 998:	01c85713          	srli	a4,a6,0x1c
 99c:	9736                	add	a4,a4,a3
 99e:	fae60de3          	beq	a2,a4,958 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9a2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9a6:	4790                	lw	a2,8(a5)
 9a8:	02061593          	slli	a1,a2,0x20
 9ac:	01c5d713          	srli	a4,a1,0x1c
 9b0:	973e                	add	a4,a4,a5
 9b2:	fae68ae3          	beq	a3,a4,966 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9b6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9b8:	00000717          	auipc	a4,0x0
 9bc:	64f73423          	sd	a5,1608(a4) # 1000 <freep>
}
 9c0:	6422                	ld	s0,8(sp)
 9c2:	0141                	addi	sp,sp,16
 9c4:	8082                	ret

00000000000009c6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c6:	7139                	addi	sp,sp,-64
 9c8:	fc06                	sd	ra,56(sp)
 9ca:	f822                	sd	s0,48(sp)
 9cc:	f426                	sd	s1,40(sp)
 9ce:	f04a                	sd	s2,32(sp)
 9d0:	ec4e                	sd	s3,24(sp)
 9d2:	e852                	sd	s4,16(sp)
 9d4:	e456                	sd	s5,8(sp)
 9d6:	e05a                	sd	s6,0(sp)
 9d8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9da:	02051493          	slli	s1,a0,0x20
 9de:	9081                	srli	s1,s1,0x20
 9e0:	04bd                	addi	s1,s1,15
 9e2:	8091                	srli	s1,s1,0x4
 9e4:	0014899b          	addiw	s3,s1,1
 9e8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9ea:	00000517          	auipc	a0,0x0
 9ee:	61653503          	ld	a0,1558(a0) # 1000 <freep>
 9f2:	c515                	beqz	a0,a1e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f6:	4798                	lw	a4,8(a5)
 9f8:	02977f63          	bgeu	a4,s1,a36 <malloc+0x70>
  if(nu < 4096)
 9fc:	8a4e                	mv	s4,s3
 9fe:	0009871b          	sext.w	a4,s3
 a02:	6685                	lui	a3,0x1
 a04:	00d77363          	bgeu	a4,a3,a0a <malloc+0x44>
 a08:	6a05                	lui	s4,0x1
 a0a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a0e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a12:	00000917          	auipc	s2,0x0
 a16:	5ee90913          	addi	s2,s2,1518 # 1000 <freep>
  if(p == (char*)-1)
 a1a:	5afd                	li	s5,-1
 a1c:	a895                	j	a90 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a1e:	00000797          	auipc	a5,0x0
 a22:	5f278793          	addi	a5,a5,1522 # 1010 <base>
 a26:	00000717          	auipc	a4,0x0
 a2a:	5cf73d23          	sd	a5,1498(a4) # 1000 <freep>
 a2e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a30:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a34:	b7e1                	j	9fc <malloc+0x36>
      if(p->s.size == nunits)
 a36:	02e48c63          	beq	s1,a4,a6e <malloc+0xa8>
        p->s.size -= nunits;
 a3a:	4137073b          	subw	a4,a4,s3
 a3e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a40:	02071693          	slli	a3,a4,0x20
 a44:	01c6d713          	srli	a4,a3,0x1c
 a48:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a4a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a4e:	00000717          	auipc	a4,0x0
 a52:	5aa73923          	sd	a0,1458(a4) # 1000 <freep>
      return (void*)(p + 1);
 a56:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a5a:	70e2                	ld	ra,56(sp)
 a5c:	7442                	ld	s0,48(sp)
 a5e:	74a2                	ld	s1,40(sp)
 a60:	7902                	ld	s2,32(sp)
 a62:	69e2                	ld	s3,24(sp)
 a64:	6a42                	ld	s4,16(sp)
 a66:	6aa2                	ld	s5,8(sp)
 a68:	6b02                	ld	s6,0(sp)
 a6a:	6121                	addi	sp,sp,64
 a6c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a6e:	6398                	ld	a4,0(a5)
 a70:	e118                	sd	a4,0(a0)
 a72:	bff1                	j	a4e <malloc+0x88>
  hp->s.size = nu;
 a74:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a78:	0541                	addi	a0,a0,16
 a7a:	00000097          	auipc	ra,0x0
 a7e:	eca080e7          	jalr	-310(ra) # 944 <free>
  return freep;
 a82:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a86:	d971                	beqz	a0,a5a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a88:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a8a:	4798                	lw	a4,8(a5)
 a8c:	fa9775e3          	bgeu	a4,s1,a36 <malloc+0x70>
    if(p == freep)
 a90:	00093703          	ld	a4,0(s2)
 a94:	853e                	mv	a0,a5
 a96:	fef719e3          	bne	a4,a5,a88 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a9a:	8552                	mv	a0,s4
 a9c:	00000097          	auipc	ra,0x0
 aa0:	b92080e7          	jalr	-1134(ra) # 62e <sbrk>
  if(p == (char*)-1)
 aa4:	fd5518e3          	bne	a0,s5,a74 <malloc+0xae>
        return 0;
 aa8:	4501                	li	a0,0
 aaa:	bf45                	j	a5a <malloc+0x94>
