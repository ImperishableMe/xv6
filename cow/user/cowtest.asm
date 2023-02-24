
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:

// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  char *p = sbrk(sz);
   e:	05555537          	lui	a0,0x5555
  12:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x5550544>
  16:	00000097          	auipc	ra,0x0
  1a:	7bc080e7          	jalr	1980(ra) # 7d2 <sbrk>
  if (p == (char *)0xffffffffffffffffL)
  1e:	57fd                	li	a5,-1
  20:	06f50563          	beq	a0,a5,8a <simpletest+0x8a>
  24:	84aa                	mv	s1,a0
  {
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for (char *q = p; q < p + sz; q += 4096)
  26:	05556937          	lui	s2,0x5556
  2a:	992a                	add	s2,s2,a0
  2c:	6985                	lui	s3,0x1
  {
    // printf("hello %p\n", q);
    *(int *)q = getpid();
  2e:	00000097          	auipc	ra,0x0
  32:	79c080e7          	jalr	1948(ra) # 7ca <getpid>
  36:	c088                	sw	a0,0(s1)
  for (char *q = p; q < p + sz; q += 4096)
  38:	94ce                	add	s1,s1,s3
  3a:	fe991ae3          	bne	s2,s1,2e <simpletest+0x2e>
  }

  int pid = fork();
  3e:	00000097          	auipc	ra,0x0
  42:	704080e7          	jalr	1796(ra) # 742 <fork>
  if (pid < 0)
  46:	06054363          	bltz	a0,ac <simpletest+0xac>
  {
    printf("fork() failed\n");
    exit(-1);
  }

  if (pid == 0)
  4a:	cd35                	beqz	a0,c6 <simpletest+0xc6>
    exit(0);

  wait(0);
  4c:	4501                	li	a0,0
  4e:	00000097          	auipc	ra,0x0
  52:	704080e7          	jalr	1796(ra) # 752 <wait>

  if (sbrk(-sz) == (char *)0xffffffffffffffffL)
  56:	faaab537          	lui	a0,0xfaaab
  5a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa5a9c>
  5e:	00000097          	auipc	ra,0x0
  62:	774080e7          	jalr	1908(ra) # 7d2 <sbrk>
  66:	57fd                	li	a5,-1
  68:	06f50363          	beq	a0,a5,ce <simpletest+0xce>
  {
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  6c:	00001517          	auipc	a0,0x1
  70:	c2450513          	addi	a0,a0,-988 # c90 <malloc+0x126>
  74:	00001097          	auipc	ra,0x1
  78:	a3e080e7          	jalr	-1474(ra) # ab2 <printf>
}
  7c:	70a2                	ld	ra,40(sp)
  7e:	7402                	ld	s0,32(sp)
  80:	64e2                	ld	s1,24(sp)
  82:	6942                	ld	s2,16(sp)
  84:	69a2                	ld	s3,8(sp)
  86:	6145                	addi	sp,sp,48
  88:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  8a:	055555b7          	lui	a1,0x5555
  8e:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  92:	00001517          	auipc	a0,0x1
  96:	bbe50513          	addi	a0,a0,-1090 # c50 <malloc+0xe6>
  9a:	00001097          	auipc	ra,0x1
  9e:	a18080e7          	jalr	-1512(ra) # ab2 <printf>
    exit(-1);
  a2:	557d                	li	a0,-1
  a4:	00000097          	auipc	ra,0x0
  a8:	6a6080e7          	jalr	1702(ra) # 74a <exit>
    printf("fork() failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	bbc50513          	addi	a0,a0,-1092 # c68 <malloc+0xfe>
  b4:	00001097          	auipc	ra,0x1
  b8:	9fe080e7          	jalr	-1538(ra) # ab2 <printf>
    exit(-1);
  bc:	557d                	li	a0,-1
  be:	00000097          	auipc	ra,0x0
  c2:	68c080e7          	jalr	1676(ra) # 74a <exit>
    exit(0);
  c6:	00000097          	auipc	ra,0x0
  ca:	684080e7          	jalr	1668(ra) # 74a <exit>
    printf("sbrk(-%d) failed\n", sz);
  ce:	055555b7          	lui	a1,0x5555
  d2:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  d6:	00001517          	auipc	a0,0x1
  da:	ba250513          	addi	a0,a0,-1118 # c78 <malloc+0x10e>
  de:	00001097          	auipc	ra,0x1
  e2:	9d4080e7          	jalr	-1580(ra) # ab2 <printf>
    exit(-1);
  e6:	557d                	li	a0,-1
  e8:	00000097          	auipc	ra,0x0
  ec:	662080e7          	jalr	1634(ra) # 74a <exit>

00000000000000f0 <threetest>:
// three processes all write COW memory.
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void threetest()
{
  f0:	7179                	addi	sp,sp,-48
  f2:	f406                	sd	ra,40(sp)
  f4:	f022                	sd	s0,32(sp)
  f6:	ec26                	sd	s1,24(sp)
  f8:	e84a                	sd	s2,16(sp)
  fa:	e44e                	sd	s3,8(sp)
  fc:	e052                	sd	s4,0(sp)
  fe:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 100:	00001517          	auipc	a0,0x1
 104:	b9850513          	addi	a0,a0,-1128 # c98 <malloc+0x12e>
 108:	00001097          	auipc	ra,0x1
 10c:	9aa080e7          	jalr	-1622(ra) # ab2 <printf>

  char *p = sbrk(sz);
 110:	02000537          	lui	a0,0x2000
 114:	00000097          	auipc	ra,0x0
 118:	6be080e7          	jalr	1726(ra) # 7d2 <sbrk>
  if (p == (char *)0xffffffffffffffffL)
 11c:	57fd                	li	a5,-1
 11e:	08f50763          	beq	a0,a5,1ac <threetest+0xbc>
 122:	84aa                	mv	s1,a0
  {
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
 124:	00000097          	auipc	ra,0x0
 128:	61e080e7          	jalr	1566(ra) # 742 <fork>
  if (pid1 < 0)
 12c:	08054f63          	bltz	a0,1ca <threetest+0xda>
  {
    printf("fork failed\n");
    exit(-1);
  }
  if (pid1 == 0)
 130:	c955                	beqz	a0,1e4 <threetest+0xf4>
      *(int *)q = 9999;
    }
    exit(0);
  }

  for (char *q = p; q < p + sz; q += 4096)
 132:	020009b7          	lui	s3,0x2000
 136:	99a6                	add	s3,s3,s1
 138:	8926                	mv	s2,s1
 13a:	6a05                	lui	s4,0x1
  {
    *(int *)q = getpid();
 13c:	00000097          	auipc	ra,0x0
 140:	68e080e7          	jalr	1678(ra) # 7ca <getpid>
 144:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x5550ff0>
  for (char *q = p; q < p + sz; q += 4096)
 148:	9952                	add	s2,s2,s4
 14a:	ff3919e3          	bne	s2,s3,13c <threetest+0x4c>
  }

  wait(0);
 14e:	4501                	li	a0,0
 150:	00000097          	auipc	ra,0x0
 154:	602080e7          	jalr	1538(ra) # 752 <wait>

  sleep(1);
 158:	4505                	li	a0,1
 15a:	00000097          	auipc	ra,0x0
 15e:	680080e7          	jalr	1664(ra) # 7da <sleep>

  for (char *q = p; q < p + sz; q += 4096)
 162:	6a05                	lui	s4,0x1
  {
    if (*(int *)q != getpid())
 164:	0004a903          	lw	s2,0(s1)
 168:	00000097          	auipc	ra,0x0
 16c:	662080e7          	jalr	1634(ra) # 7ca <getpid>
 170:	10a91a63          	bne	s2,a0,284 <threetest+0x194>
  for (char *q = p; q < p + sz; q += 4096)
 174:	94d2                	add	s1,s1,s4
 176:	ff3497e3          	bne	s1,s3,164 <threetest+0x74>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if (sbrk(-sz) == (char *)0xffffffffffffffffL)
 17a:	fe000537          	lui	a0,0xfe000
 17e:	00000097          	auipc	ra,0x0
 182:	654080e7          	jalr	1620(ra) # 7d2 <sbrk>
 186:	57fd                	li	a5,-1
 188:	10f50b63          	beq	a0,a5,29e <threetest+0x1ae>
  {
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 18c:	00001517          	auipc	a0,0x1
 190:	b0450513          	addi	a0,a0,-1276 # c90 <malloc+0x126>
 194:	00001097          	auipc	ra,0x1
 198:	91e080e7          	jalr	-1762(ra) # ab2 <printf>
}
 19c:	70a2                	ld	ra,40(sp)
 19e:	7402                	ld	s0,32(sp)
 1a0:	64e2                	ld	s1,24(sp)
 1a2:	6942                	ld	s2,16(sp)
 1a4:	69a2                	ld	s3,8(sp)
 1a6:	6a02                	ld	s4,0(sp)
 1a8:	6145                	addi	sp,sp,48
 1aa:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1ac:	020005b7          	lui	a1,0x2000
 1b0:	00001517          	auipc	a0,0x1
 1b4:	aa050513          	addi	a0,a0,-1376 # c50 <malloc+0xe6>
 1b8:	00001097          	auipc	ra,0x1
 1bc:	8fa080e7          	jalr	-1798(ra) # ab2 <printf>
    exit(-1);
 1c0:	557d                	li	a0,-1
 1c2:	00000097          	auipc	ra,0x0
 1c6:	588080e7          	jalr	1416(ra) # 74a <exit>
    printf("fork failed\n");
 1ca:	00001517          	auipc	a0,0x1
 1ce:	ad650513          	addi	a0,a0,-1322 # ca0 <malloc+0x136>
 1d2:	00001097          	auipc	ra,0x1
 1d6:	8e0080e7          	jalr	-1824(ra) # ab2 <printf>
    exit(-1);
 1da:	557d                	li	a0,-1
 1dc:	00000097          	auipc	ra,0x0
 1e0:	56e080e7          	jalr	1390(ra) # 74a <exit>
    pid2 = fork();
 1e4:	00000097          	auipc	ra,0x0
 1e8:	55e080e7          	jalr	1374(ra) # 742 <fork>
    if (pid2 < 0)
 1ec:	04054263          	bltz	a0,230 <threetest+0x140>
    if (pid2 == 0)
 1f0:	ed29                	bnez	a0,24a <threetest+0x15a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096)
 1f2:	0199a9b7          	lui	s3,0x199a
 1f6:	99a6                	add	s3,s3,s1
 1f8:	8926                	mv	s2,s1
 1fa:	6a05                	lui	s4,0x1
        *(int *)q = getpid();
 1fc:	00000097          	auipc	ra,0x0
 200:	5ce080e7          	jalr	1486(ra) # 7ca <getpid>
 204:	00a92023          	sw	a0,0(s2)
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096)
 208:	9952                	add	s2,s2,s4
 20a:	ff2999e3          	bne	s3,s2,1fc <threetest+0x10c>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096)
 20e:	6a05                	lui	s4,0x1
        if (*(int *)q != getpid())
 210:	0004a903          	lw	s2,0(s1)
 214:	00000097          	auipc	ra,0x0
 218:	5b6080e7          	jalr	1462(ra) # 7ca <getpid>
 21c:	04a91763          	bne	s2,a0,26a <threetest+0x17a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096)
 220:	94d2                	add	s1,s1,s4
 222:	fe9997e3          	bne	s3,s1,210 <threetest+0x120>
      exit(-1);
 226:	557d                	li	a0,-1
 228:	00000097          	auipc	ra,0x0
 22c:	522080e7          	jalr	1314(ra) # 74a <exit>
      printf("fork failed");
 230:	00001517          	auipc	a0,0x1
 234:	a8050513          	addi	a0,a0,-1408 # cb0 <malloc+0x146>
 238:	00001097          	auipc	ra,0x1
 23c:	87a080e7          	jalr	-1926(ra) # ab2 <printf>
      exit(-1);
 240:	557d                	li	a0,-1
 242:	00000097          	auipc	ra,0x0
 246:	508080e7          	jalr	1288(ra) # 74a <exit>
    for (char *q = p; q < p + (sz / 2); q += 4096)
 24a:	01000737          	lui	a4,0x1000
 24e:	9726                	add	a4,a4,s1
      *(int *)q = 9999;
 250:	6789                	lui	a5,0x2
 252:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x6ff>
    for (char *q = p; q < p + (sz / 2); q += 4096)
 256:	6685                	lui	a3,0x1
      *(int *)q = 9999;
 258:	c09c                	sw	a5,0(s1)
    for (char *q = p; q < p + (sz / 2); q += 4096)
 25a:	94b6                	add	s1,s1,a3
 25c:	fee49ee3          	bne	s1,a4,258 <threetest+0x168>
    exit(0);
 260:	4501                	li	a0,0
 262:	00000097          	auipc	ra,0x0
 266:	4e8080e7          	jalr	1256(ra) # 74a <exit>
          printf("wrong content\n");
 26a:	00001517          	auipc	a0,0x1
 26e:	a5650513          	addi	a0,a0,-1450 # cc0 <malloc+0x156>
 272:	00001097          	auipc	ra,0x1
 276:	840080e7          	jalr	-1984(ra) # ab2 <printf>
          exit(-1);
 27a:	557d                	li	a0,-1
 27c:	00000097          	auipc	ra,0x0
 280:	4ce080e7          	jalr	1230(ra) # 74a <exit>
      printf("wrong content\n");
 284:	00001517          	auipc	a0,0x1
 288:	a3c50513          	addi	a0,a0,-1476 # cc0 <malloc+0x156>
 28c:	00001097          	auipc	ra,0x1
 290:	826080e7          	jalr	-2010(ra) # ab2 <printf>
      exit(-1);
 294:	557d                	li	a0,-1
 296:	00000097          	auipc	ra,0x0
 29a:	4b4080e7          	jalr	1204(ra) # 74a <exit>
    printf("sbrk(-%d) failed\n", sz);
 29e:	020005b7          	lui	a1,0x2000
 2a2:	00001517          	auipc	a0,0x1
 2a6:	9d650513          	addi	a0,a0,-1578 # c78 <malloc+0x10e>
 2aa:	00001097          	auipc	ra,0x1
 2ae:	808080e7          	jalr	-2040(ra) # ab2 <printf>
    exit(-1);
 2b2:	557d                	li	a0,-1
 2b4:	00000097          	auipc	ra,0x0
 2b8:	496080e7          	jalr	1174(ra) # 74a <exit>

00000000000002bc <filetest>:
char buf[4096];
char junk3[4096];

// test whether copyout() simulates COW faults.
void filetest()
{
 2bc:	7179                	addi	sp,sp,-48
 2be:	f406                	sd	ra,40(sp)
 2c0:	f022                	sd	s0,32(sp)
 2c2:	ec26                	sd	s1,24(sp)
 2c4:	e84a                	sd	s2,16(sp)
 2c6:	1800                	addi	s0,sp,48
  printf("file: ");
 2c8:	00001517          	auipc	a0,0x1
 2cc:	a0850513          	addi	a0,a0,-1528 # cd0 <malloc+0x166>
 2d0:	00000097          	auipc	ra,0x0
 2d4:	7e2080e7          	jalr	2018(ra) # ab2 <printf>

  buf[0] = 99;
 2d8:	06300793          	li	a5,99
 2dc:	00002717          	auipc	a4,0x2
 2e0:	d2f70a23          	sb	a5,-716(a4) # 2010 <buf>

  for (int i = 0; i < 4; i++)
 2e4:	fc042c23          	sw	zero,-40(s0)
  {
    if (pipe(fds) != 0)
 2e8:	00001497          	auipc	s1,0x1
 2ec:	d1848493          	addi	s1,s1,-744 # 1000 <fds>
  for (int i = 0; i < 4; i++)
 2f0:	490d                	li	s2,3
    if (pipe(fds) != 0)
 2f2:	8526                	mv	a0,s1
 2f4:	00000097          	auipc	ra,0x0
 2f8:	466080e7          	jalr	1126(ra) # 75a <pipe>
 2fc:	e149                	bnez	a0,37e <filetest+0xc2>
    {
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 2fe:	00000097          	auipc	ra,0x0
 302:	444080e7          	jalr	1092(ra) # 742 <fork>
    if (pid < 0)
 306:	08054963          	bltz	a0,398 <filetest+0xdc>
    {
      printf("fork failed\n");
      exit(-1);
    }
    if (pid == 0)
 30a:	c545                	beqz	a0,3b2 <filetest+0xf6>
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if (write(fds[1], &i, sizeof(i)) != sizeof(i))
 30c:	4611                	li	a2,4
 30e:	fd840593          	addi	a1,s0,-40
 312:	40c8                	lw	a0,4(s1)
 314:	00000097          	auipc	ra,0x0
 318:	456080e7          	jalr	1110(ra) # 76a <write>
 31c:	4791                	li	a5,4
 31e:	10f51b63          	bne	a0,a5,434 <filetest+0x178>
  for (int i = 0; i < 4; i++)
 322:	fd842783          	lw	a5,-40(s0)
 326:	2785                	addiw	a5,a5,1
 328:	0007871b          	sext.w	a4,a5
 32c:	fcf42c23          	sw	a5,-40(s0)
 330:	fce951e3          	bge	s2,a4,2f2 <filetest+0x36>
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
 334:	fc042e23          	sw	zero,-36(s0)
 338:	4491                	li	s1,4
  for (int i = 0; i < 4; i++)
  {
    wait(&xstatus);
 33a:	fdc40513          	addi	a0,s0,-36
 33e:	00000097          	auipc	ra,0x0
 342:	414080e7          	jalr	1044(ra) # 752 <wait>
    if (xstatus != 0)
 346:	fdc42783          	lw	a5,-36(s0)
 34a:	10079263          	bnez	a5,44e <filetest+0x192>
  for (int i = 0; i < 4; i++)
 34e:	34fd                	addiw	s1,s1,-1
 350:	f4ed                	bnez	s1,33a <filetest+0x7e>
    {
      exit(1);
    }
  }

  if (buf[0] != 99)
 352:	00002717          	auipc	a4,0x2
 356:	cbe74703          	lbu	a4,-834(a4) # 2010 <buf>
 35a:	06300793          	li	a5,99
 35e:	0ef71d63          	bne	a4,a5,458 <filetest+0x19c>
  {
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
 362:	00001517          	auipc	a0,0x1
 366:	92e50513          	addi	a0,a0,-1746 # c90 <malloc+0x126>
 36a:	00000097          	auipc	ra,0x0
 36e:	748080e7          	jalr	1864(ra) # ab2 <printf>
}
 372:	70a2                	ld	ra,40(sp)
 374:	7402                	ld	s0,32(sp)
 376:	64e2                	ld	s1,24(sp)
 378:	6942                	ld	s2,16(sp)
 37a:	6145                	addi	sp,sp,48
 37c:	8082                	ret
      printf("pipe() failed\n");
 37e:	00001517          	auipc	a0,0x1
 382:	95a50513          	addi	a0,a0,-1702 # cd8 <malloc+0x16e>
 386:	00000097          	auipc	ra,0x0
 38a:	72c080e7          	jalr	1836(ra) # ab2 <printf>
      exit(-1);
 38e:	557d                	li	a0,-1
 390:	00000097          	auipc	ra,0x0
 394:	3ba080e7          	jalr	954(ra) # 74a <exit>
      printf("fork failed\n");
 398:	00001517          	auipc	a0,0x1
 39c:	90850513          	addi	a0,a0,-1784 # ca0 <malloc+0x136>
 3a0:	00000097          	auipc	ra,0x0
 3a4:	712080e7          	jalr	1810(ra) # ab2 <printf>
      exit(-1);
 3a8:	557d                	li	a0,-1
 3aa:	00000097          	auipc	ra,0x0
 3ae:	3a0080e7          	jalr	928(ra) # 74a <exit>
      sleep(1);
 3b2:	4505                	li	a0,1
 3b4:	00000097          	auipc	ra,0x0
 3b8:	426080e7          	jalr	1062(ra) # 7da <sleep>
      if (read(fds[0], buf, sizeof(i)) != sizeof(i))
 3bc:	4611                	li	a2,4
 3be:	00002597          	auipc	a1,0x2
 3c2:	c5258593          	addi	a1,a1,-942 # 2010 <buf>
 3c6:	00001517          	auipc	a0,0x1
 3ca:	c3a52503          	lw	a0,-966(a0) # 1000 <fds>
 3ce:	00000097          	auipc	ra,0x0
 3d2:	394080e7          	jalr	916(ra) # 762 <read>
 3d6:	4791                	li	a5,4
 3d8:	02f51c63          	bne	a0,a5,410 <filetest+0x154>
      sleep(1);
 3dc:	4505                	li	a0,1
 3de:	00000097          	auipc	ra,0x0
 3e2:	3fc080e7          	jalr	1020(ra) # 7da <sleep>
      if (j != i)
 3e6:	fd842703          	lw	a4,-40(s0)
 3ea:	00002797          	auipc	a5,0x2
 3ee:	c267a783          	lw	a5,-986(a5) # 2010 <buf>
 3f2:	02f70c63          	beq	a4,a5,42a <filetest+0x16e>
        printf("error: read the wrong value\n");
 3f6:	00001517          	auipc	a0,0x1
 3fa:	90a50513          	addi	a0,a0,-1782 # d00 <malloc+0x196>
 3fe:	00000097          	auipc	ra,0x0
 402:	6b4080e7          	jalr	1716(ra) # ab2 <printf>
        exit(1);
 406:	4505                	li	a0,1
 408:	00000097          	auipc	ra,0x0
 40c:	342080e7          	jalr	834(ra) # 74a <exit>
        printf("error: read failed\n");
 410:	00001517          	auipc	a0,0x1
 414:	8d850513          	addi	a0,a0,-1832 # ce8 <malloc+0x17e>
 418:	00000097          	auipc	ra,0x0
 41c:	69a080e7          	jalr	1690(ra) # ab2 <printf>
        exit(1);
 420:	4505                	li	a0,1
 422:	00000097          	auipc	ra,0x0
 426:	328080e7          	jalr	808(ra) # 74a <exit>
      exit(0);
 42a:	4501                	li	a0,0
 42c:	00000097          	auipc	ra,0x0
 430:	31e080e7          	jalr	798(ra) # 74a <exit>
      printf("error: write failed\n");
 434:	00001517          	auipc	a0,0x1
 438:	8ec50513          	addi	a0,a0,-1812 # d20 <malloc+0x1b6>
 43c:	00000097          	auipc	ra,0x0
 440:	676080e7          	jalr	1654(ra) # ab2 <printf>
      exit(-1);
 444:	557d                	li	a0,-1
 446:	00000097          	auipc	ra,0x0
 44a:	304080e7          	jalr	772(ra) # 74a <exit>
      exit(1);
 44e:	4505                	li	a0,1
 450:	00000097          	auipc	ra,0x0
 454:	2fa080e7          	jalr	762(ra) # 74a <exit>
    printf("error: child overwrote parent\n");
 458:	00001517          	auipc	a0,0x1
 45c:	8e050513          	addi	a0,a0,-1824 # d38 <malloc+0x1ce>
 460:	00000097          	auipc	ra,0x0
 464:	652080e7          	jalr	1618(ra) # ab2 <printf>
    exit(1);
 468:	4505                	li	a0,1
 46a:	00000097          	auipc	ra,0x0
 46e:	2e0080e7          	jalr	736(ra) # 74a <exit>

0000000000000472 <main>:

int main(int argc, char *argv[])
{
 472:	1141                	addi	sp,sp,-16
 474:	e406                	sd	ra,8(sp)
 476:	e022                	sd	s0,0(sp)
 478:	0800                	addi	s0,sp,16
  simpletest();
 47a:	00000097          	auipc	ra,0x0
 47e:	b86080e7          	jalr	-1146(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 482:	00000097          	auipc	ra,0x0
 486:	b7e080e7          	jalr	-1154(ra) # 0 <simpletest>

  threetest();
 48a:	00000097          	auipc	ra,0x0
 48e:	c66080e7          	jalr	-922(ra) # f0 <threetest>
  threetest();
 492:	00000097          	auipc	ra,0x0
 496:	c5e080e7          	jalr	-930(ra) # f0 <threetest>
  threetest();
 49a:	00000097          	auipc	ra,0x0
 49e:	c56080e7          	jalr	-938(ra) # f0 <threetest>

  filetest();
 4a2:	00000097          	auipc	ra,0x0
 4a6:	e1a080e7          	jalr	-486(ra) # 2bc <filetest>

  printf("ALL COW TESTS PASSED\n");
 4aa:	00001517          	auipc	a0,0x1
 4ae:	8ae50513          	addi	a0,a0,-1874 # d58 <malloc+0x1ee>
 4b2:	00000097          	auipc	ra,0x0
 4b6:	600080e7          	jalr	1536(ra) # ab2 <printf>

  exit(0);
 4ba:	4501                	li	a0,0
 4bc:	00000097          	auipc	ra,0x0
 4c0:	28e080e7          	jalr	654(ra) # 74a <exit>

00000000000004c4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e406                	sd	ra,8(sp)
 4c8:	e022                	sd	s0,0(sp)
 4ca:	0800                	addi	s0,sp,16
  extern int main();
  main();
 4cc:	00000097          	auipc	ra,0x0
 4d0:	fa6080e7          	jalr	-90(ra) # 472 <main>
  exit(0);
 4d4:	4501                	li	a0,0
 4d6:	00000097          	auipc	ra,0x0
 4da:	274080e7          	jalr	628(ra) # 74a <exit>

00000000000004de <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e422                	sd	s0,8(sp)
 4e2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4e4:	87aa                	mv	a5,a0
 4e6:	0585                	addi	a1,a1,1
 4e8:	0785                	addi	a5,a5,1
 4ea:	fff5c703          	lbu	a4,-1(a1)
 4ee:	fee78fa3          	sb	a4,-1(a5)
 4f2:	fb75                	bnez	a4,4e6 <strcpy+0x8>
    ;
  return os;
}
 4f4:	6422                	ld	s0,8(sp)
 4f6:	0141                	addi	sp,sp,16
 4f8:	8082                	ret

00000000000004fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4fa:	1141                	addi	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 500:	00054783          	lbu	a5,0(a0)
 504:	cb91                	beqz	a5,518 <strcmp+0x1e>
 506:	0005c703          	lbu	a4,0(a1)
 50a:	00f71763          	bne	a4,a5,518 <strcmp+0x1e>
    p++, q++;
 50e:	0505                	addi	a0,a0,1
 510:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 512:	00054783          	lbu	a5,0(a0)
 516:	fbe5                	bnez	a5,506 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 518:	0005c503          	lbu	a0,0(a1)
}
 51c:	40a7853b          	subw	a0,a5,a0
 520:	6422                	ld	s0,8(sp)
 522:	0141                	addi	sp,sp,16
 524:	8082                	ret

0000000000000526 <strlen>:

uint
strlen(const char *s)
{
 526:	1141                	addi	sp,sp,-16
 528:	e422                	sd	s0,8(sp)
 52a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 52c:	00054783          	lbu	a5,0(a0)
 530:	cf91                	beqz	a5,54c <strlen+0x26>
 532:	0505                	addi	a0,a0,1
 534:	87aa                	mv	a5,a0
 536:	86be                	mv	a3,a5
 538:	0785                	addi	a5,a5,1
 53a:	fff7c703          	lbu	a4,-1(a5)
 53e:	ff65                	bnez	a4,536 <strlen+0x10>
 540:	40a6853b          	subw	a0,a3,a0
 544:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 546:	6422                	ld	s0,8(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret
  for(n = 0; s[n]; n++)
 54c:	4501                	li	a0,0
 54e:	bfe5                	j	546 <strlen+0x20>

0000000000000550 <memset>:

void*
memset(void *dst, int c, uint n)
{
 550:	1141                	addi	sp,sp,-16
 552:	e422                	sd	s0,8(sp)
 554:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 556:	ca19                	beqz	a2,56c <memset+0x1c>
 558:	87aa                	mv	a5,a0
 55a:	1602                	slli	a2,a2,0x20
 55c:	9201                	srli	a2,a2,0x20
 55e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 562:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 566:	0785                	addi	a5,a5,1
 568:	fee79de3          	bne	a5,a4,562 <memset+0x12>
  }
  return dst;
}
 56c:	6422                	ld	s0,8(sp)
 56e:	0141                	addi	sp,sp,16
 570:	8082                	ret

0000000000000572 <strchr>:

char*
strchr(const char *s, char c)
{
 572:	1141                	addi	sp,sp,-16
 574:	e422                	sd	s0,8(sp)
 576:	0800                	addi	s0,sp,16
  for(; *s; s++)
 578:	00054783          	lbu	a5,0(a0)
 57c:	cb99                	beqz	a5,592 <strchr+0x20>
    if(*s == c)
 57e:	00f58763          	beq	a1,a5,58c <strchr+0x1a>
  for(; *s; s++)
 582:	0505                	addi	a0,a0,1
 584:	00054783          	lbu	a5,0(a0)
 588:	fbfd                	bnez	a5,57e <strchr+0xc>
      return (char*)s;
  return 0;
 58a:	4501                	li	a0,0
}
 58c:	6422                	ld	s0,8(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret
  return 0;
 592:	4501                	li	a0,0
 594:	bfe5                	j	58c <strchr+0x1a>

0000000000000596 <gets>:

char*
gets(char *buf, int max)
{
 596:	711d                	addi	sp,sp,-96
 598:	ec86                	sd	ra,88(sp)
 59a:	e8a2                	sd	s0,80(sp)
 59c:	e4a6                	sd	s1,72(sp)
 59e:	e0ca                	sd	s2,64(sp)
 5a0:	fc4e                	sd	s3,56(sp)
 5a2:	f852                	sd	s4,48(sp)
 5a4:	f456                	sd	s5,40(sp)
 5a6:	f05a                	sd	s6,32(sp)
 5a8:	ec5e                	sd	s7,24(sp)
 5aa:	1080                	addi	s0,sp,96
 5ac:	8baa                	mv	s7,a0
 5ae:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5b0:	892a                	mv	s2,a0
 5b2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5b4:	4aa9                	li	s5,10
 5b6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5b8:	89a6                	mv	s3,s1
 5ba:	2485                	addiw	s1,s1,1
 5bc:	0344d863          	bge	s1,s4,5ec <gets+0x56>
    cc = read(0, &c, 1);
 5c0:	4605                	li	a2,1
 5c2:	faf40593          	addi	a1,s0,-81
 5c6:	4501                	li	a0,0
 5c8:	00000097          	auipc	ra,0x0
 5cc:	19a080e7          	jalr	410(ra) # 762 <read>
    if(cc < 1)
 5d0:	00a05e63          	blez	a0,5ec <gets+0x56>
    buf[i++] = c;
 5d4:	faf44783          	lbu	a5,-81(s0)
 5d8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5dc:	01578763          	beq	a5,s5,5ea <gets+0x54>
 5e0:	0905                	addi	s2,s2,1
 5e2:	fd679be3          	bne	a5,s6,5b8 <gets+0x22>
  for(i=0; i+1 < max; ){
 5e6:	89a6                	mv	s3,s1
 5e8:	a011                	j	5ec <gets+0x56>
 5ea:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5ec:	99de                	add	s3,s3,s7
 5ee:	00098023          	sb	zero,0(s3) # 199a000 <base+0x1994ff0>
  return buf;
}
 5f2:	855e                	mv	a0,s7
 5f4:	60e6                	ld	ra,88(sp)
 5f6:	6446                	ld	s0,80(sp)
 5f8:	64a6                	ld	s1,72(sp)
 5fa:	6906                	ld	s2,64(sp)
 5fc:	79e2                	ld	s3,56(sp)
 5fe:	7a42                	ld	s4,48(sp)
 600:	7aa2                	ld	s5,40(sp)
 602:	7b02                	ld	s6,32(sp)
 604:	6be2                	ld	s7,24(sp)
 606:	6125                	addi	sp,sp,96
 608:	8082                	ret

000000000000060a <stat>:

int
stat(const char *n, struct stat *st)
{
 60a:	1101                	addi	sp,sp,-32
 60c:	ec06                	sd	ra,24(sp)
 60e:	e822                	sd	s0,16(sp)
 610:	e426                	sd	s1,8(sp)
 612:	e04a                	sd	s2,0(sp)
 614:	1000                	addi	s0,sp,32
 616:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 618:	4581                	li	a1,0
 61a:	00000097          	auipc	ra,0x0
 61e:	170080e7          	jalr	368(ra) # 78a <open>
  if(fd < 0)
 622:	02054563          	bltz	a0,64c <stat+0x42>
 626:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 628:	85ca                	mv	a1,s2
 62a:	00000097          	auipc	ra,0x0
 62e:	178080e7          	jalr	376(ra) # 7a2 <fstat>
 632:	892a                	mv	s2,a0
  close(fd);
 634:	8526                	mv	a0,s1
 636:	00000097          	auipc	ra,0x0
 63a:	13c080e7          	jalr	316(ra) # 772 <close>
  return r;
}
 63e:	854a                	mv	a0,s2
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	64a2                	ld	s1,8(sp)
 646:	6902                	ld	s2,0(sp)
 648:	6105                	addi	sp,sp,32
 64a:	8082                	ret
    return -1;
 64c:	597d                	li	s2,-1
 64e:	bfc5                	j	63e <stat+0x34>

0000000000000650 <atoi>:

int
atoi(const char *s)
{
 650:	1141                	addi	sp,sp,-16
 652:	e422                	sd	s0,8(sp)
 654:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 656:	00054683          	lbu	a3,0(a0)
 65a:	fd06879b          	addiw	a5,a3,-48 # fd0 <digits+0x200>
 65e:	0ff7f793          	zext.b	a5,a5
 662:	4625                	li	a2,9
 664:	02f66863          	bltu	a2,a5,694 <atoi+0x44>
 668:	872a                	mv	a4,a0
  n = 0;
 66a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 66c:	0705                	addi	a4,a4,1
 66e:	0025179b          	slliw	a5,a0,0x2
 672:	9fa9                	addw	a5,a5,a0
 674:	0017979b          	slliw	a5,a5,0x1
 678:	9fb5                	addw	a5,a5,a3
 67a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 67e:	00074683          	lbu	a3,0(a4)
 682:	fd06879b          	addiw	a5,a3,-48
 686:	0ff7f793          	zext.b	a5,a5
 68a:	fef671e3          	bgeu	a2,a5,66c <atoi+0x1c>
  return n;
}
 68e:	6422                	ld	s0,8(sp)
 690:	0141                	addi	sp,sp,16
 692:	8082                	ret
  n = 0;
 694:	4501                	li	a0,0
 696:	bfe5                	j	68e <atoi+0x3e>

0000000000000698 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 698:	1141                	addi	sp,sp,-16
 69a:	e422                	sd	s0,8(sp)
 69c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 69e:	02b57463          	bgeu	a0,a1,6c6 <memmove+0x2e>
    while(n-- > 0)
 6a2:	00c05f63          	blez	a2,6c0 <memmove+0x28>
 6a6:	1602                	slli	a2,a2,0x20
 6a8:	9201                	srli	a2,a2,0x20
 6aa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 6b0:	0585                	addi	a1,a1,1
 6b2:	0705                	addi	a4,a4,1
 6b4:	fff5c683          	lbu	a3,-1(a1)
 6b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6bc:	fee79ae3          	bne	a5,a4,6b0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6c0:	6422                	ld	s0,8(sp)
 6c2:	0141                	addi	sp,sp,16
 6c4:	8082                	ret
    dst += n;
 6c6:	00c50733          	add	a4,a0,a2
    src += n;
 6ca:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6cc:	fec05ae3          	blez	a2,6c0 <memmove+0x28>
 6d0:	fff6079b          	addiw	a5,a2,-1
 6d4:	1782                	slli	a5,a5,0x20
 6d6:	9381                	srli	a5,a5,0x20
 6d8:	fff7c793          	not	a5,a5
 6dc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6de:	15fd                	addi	a1,a1,-1
 6e0:	177d                	addi	a4,a4,-1
 6e2:	0005c683          	lbu	a3,0(a1)
 6e6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6ea:	fee79ae3          	bne	a5,a4,6de <memmove+0x46>
 6ee:	bfc9                	j	6c0 <memmove+0x28>

00000000000006f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6f0:	1141                	addi	sp,sp,-16
 6f2:	e422                	sd	s0,8(sp)
 6f4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6f6:	ca05                	beqz	a2,726 <memcmp+0x36>
 6f8:	fff6069b          	addiw	a3,a2,-1
 6fc:	1682                	slli	a3,a3,0x20
 6fe:	9281                	srli	a3,a3,0x20
 700:	0685                	addi	a3,a3,1
 702:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 704:	00054783          	lbu	a5,0(a0)
 708:	0005c703          	lbu	a4,0(a1)
 70c:	00e79863          	bne	a5,a4,71c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 710:	0505                	addi	a0,a0,1
    p2++;
 712:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 714:	fed518e3          	bne	a0,a3,704 <memcmp+0x14>
  }
  return 0;
 718:	4501                	li	a0,0
 71a:	a019                	j	720 <memcmp+0x30>
      return *p1 - *p2;
 71c:	40e7853b          	subw	a0,a5,a4
}
 720:	6422                	ld	s0,8(sp)
 722:	0141                	addi	sp,sp,16
 724:	8082                	ret
  return 0;
 726:	4501                	li	a0,0
 728:	bfe5                	j	720 <memcmp+0x30>

000000000000072a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 72a:	1141                	addi	sp,sp,-16
 72c:	e406                	sd	ra,8(sp)
 72e:	e022                	sd	s0,0(sp)
 730:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 732:	00000097          	auipc	ra,0x0
 736:	f66080e7          	jalr	-154(ra) # 698 <memmove>
}
 73a:	60a2                	ld	ra,8(sp)
 73c:	6402                	ld	s0,0(sp)
 73e:	0141                	addi	sp,sp,16
 740:	8082                	ret

0000000000000742 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 742:	4885                	li	a7,1
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <exit>:
.global exit
exit:
 li a7, SYS_exit
 74a:	4889                	li	a7,2
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <wait>:
.global wait
wait:
 li a7, SYS_wait
 752:	488d                	li	a7,3
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 75a:	4891                	li	a7,4
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <read>:
.global read
read:
 li a7, SYS_read
 762:	4895                	li	a7,5
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <write>:
.global write
write:
 li a7, SYS_write
 76a:	48c1                	li	a7,16
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <close>:
.global close
close:
 li a7, SYS_close
 772:	48d5                	li	a7,21
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <kill>:
.global kill
kill:
 li a7, SYS_kill
 77a:	4899                	li	a7,6
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <exec>:
.global exec
exec:
 li a7, SYS_exec
 782:	489d                	li	a7,7
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <open>:
.global open
open:
 li a7, SYS_open
 78a:	48bd                	li	a7,15
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 792:	48c5                	li	a7,17
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 79a:	48c9                	li	a7,18
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7a2:	48a1                	li	a7,8
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <link>:
.global link
link:
 li a7, SYS_link
 7aa:	48cd                	li	a7,19
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7b2:	48d1                	li	a7,20
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7ba:	48a5                	li	a7,9
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7c2:	48a9                	li	a7,10
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7ca:	48ad                	li	a7,11
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7d2:	48b1                	li	a7,12
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7da:	48b5                	li	a7,13
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7e2:	48b9                	li	a7,14
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7ea:	1101                	addi	sp,sp,-32
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	addi	s0,sp,32
 7f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7f6:	4605                	li	a2,1
 7f8:	fef40593          	addi	a1,s0,-17
 7fc:	00000097          	auipc	ra,0x0
 800:	f6e080e7          	jalr	-146(ra) # 76a <write>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6105                	addi	sp,sp,32
 80a:	8082                	ret

000000000000080c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f426                	sd	s1,40(sp)
 814:	f04a                	sd	s2,32(sp)
 816:	ec4e                	sd	s3,24(sp)
 818:	0080                	addi	s0,sp,64
 81a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 81c:	c299                	beqz	a3,822 <printint+0x16>
 81e:	0805c963          	bltz	a1,8b0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 822:	2581                	sext.w	a1,a1
  neg = 0;
 824:	4881                	li	a7,0
 826:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 82a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 82c:	2601                	sext.w	a2,a2
 82e:	00000517          	auipc	a0,0x0
 832:	5a250513          	addi	a0,a0,1442 # dd0 <digits>
 836:	883a                	mv	a6,a4
 838:	2705                	addiw	a4,a4,1
 83a:	02c5f7bb          	remuw	a5,a1,a2
 83e:	1782                	slli	a5,a5,0x20
 840:	9381                	srli	a5,a5,0x20
 842:	97aa                	add	a5,a5,a0
 844:	0007c783          	lbu	a5,0(a5)
 848:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 84c:	0005879b          	sext.w	a5,a1
 850:	02c5d5bb          	divuw	a1,a1,a2
 854:	0685                	addi	a3,a3,1
 856:	fec7f0e3          	bgeu	a5,a2,836 <printint+0x2a>
  if(neg)
 85a:	00088c63          	beqz	a7,872 <printint+0x66>
    buf[i++] = '-';
 85e:	fd070793          	addi	a5,a4,-48
 862:	00878733          	add	a4,a5,s0
 866:	02d00793          	li	a5,45
 86a:	fef70823          	sb	a5,-16(a4)
 86e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 872:	02e05863          	blez	a4,8a2 <printint+0x96>
 876:	fc040793          	addi	a5,s0,-64
 87a:	00e78933          	add	s2,a5,a4
 87e:	fff78993          	addi	s3,a5,-1
 882:	99ba                	add	s3,s3,a4
 884:	377d                	addiw	a4,a4,-1
 886:	1702                	slli	a4,a4,0x20
 888:	9301                	srli	a4,a4,0x20
 88a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 88e:	fff94583          	lbu	a1,-1(s2)
 892:	8526                	mv	a0,s1
 894:	00000097          	auipc	ra,0x0
 898:	f56080e7          	jalr	-170(ra) # 7ea <putc>
  while(--i >= 0)
 89c:	197d                	addi	s2,s2,-1
 89e:	ff3918e3          	bne	s2,s3,88e <printint+0x82>
}
 8a2:	70e2                	ld	ra,56(sp)
 8a4:	7442                	ld	s0,48(sp)
 8a6:	74a2                	ld	s1,40(sp)
 8a8:	7902                	ld	s2,32(sp)
 8aa:	69e2                	ld	s3,24(sp)
 8ac:	6121                	addi	sp,sp,64
 8ae:	8082                	ret
    x = -xx;
 8b0:	40b005bb          	negw	a1,a1
    neg = 1;
 8b4:	4885                	li	a7,1
    x = -xx;
 8b6:	bf85                	j	826 <printint+0x1a>

00000000000008b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8b8:	715d                	addi	sp,sp,-80
 8ba:	e486                	sd	ra,72(sp)
 8bc:	e0a2                	sd	s0,64(sp)
 8be:	fc26                	sd	s1,56(sp)
 8c0:	f84a                	sd	s2,48(sp)
 8c2:	f44e                	sd	s3,40(sp)
 8c4:	f052                	sd	s4,32(sp)
 8c6:	ec56                	sd	s5,24(sp)
 8c8:	e85a                	sd	s6,16(sp)
 8ca:	e45e                	sd	s7,8(sp)
 8cc:	e062                	sd	s8,0(sp)
 8ce:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8d0:	0005c903          	lbu	s2,0(a1)
 8d4:	18090c63          	beqz	s2,a6c <vprintf+0x1b4>
 8d8:	8aaa                	mv	s5,a0
 8da:	8bb2                	mv	s7,a2
 8dc:	00158493          	addi	s1,a1,1
  state = 0;
 8e0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8e2:	02500a13          	li	s4,37
 8e6:	4b55                	li	s6,21
 8e8:	a839                	j	906 <vprintf+0x4e>
        putc(fd, c);
 8ea:	85ca                	mv	a1,s2
 8ec:	8556                	mv	a0,s5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	efc080e7          	jalr	-260(ra) # 7ea <putc>
 8f6:	a019                	j	8fc <vprintf+0x44>
    } else if(state == '%'){
 8f8:	01498d63          	beq	s3,s4,912 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 8fc:	0485                	addi	s1,s1,1
 8fe:	fff4c903          	lbu	s2,-1(s1)
 902:	16090563          	beqz	s2,a6c <vprintf+0x1b4>
    if(state == 0){
 906:	fe0999e3          	bnez	s3,8f8 <vprintf+0x40>
      if(c == '%'){
 90a:	ff4910e3          	bne	s2,s4,8ea <vprintf+0x32>
        state = '%';
 90e:	89d2                	mv	s3,s4
 910:	b7f5                	j	8fc <vprintf+0x44>
      if(c == 'd'){
 912:	13490263          	beq	s2,s4,a36 <vprintf+0x17e>
 916:	f9d9079b          	addiw	a5,s2,-99
 91a:	0ff7f793          	zext.b	a5,a5
 91e:	12fb6563          	bltu	s6,a5,a48 <vprintf+0x190>
 922:	f9d9079b          	addiw	a5,s2,-99
 926:	0ff7f713          	zext.b	a4,a5
 92a:	10eb6f63          	bltu	s6,a4,a48 <vprintf+0x190>
 92e:	00271793          	slli	a5,a4,0x2
 932:	00000717          	auipc	a4,0x0
 936:	44670713          	addi	a4,a4,1094 # d78 <malloc+0x20e>
 93a:	97ba                	add	a5,a5,a4
 93c:	439c                	lw	a5,0(a5)
 93e:	97ba                	add	a5,a5,a4
 940:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 942:	008b8913          	addi	s2,s7,8
 946:	4685                	li	a3,1
 948:	4629                	li	a2,10
 94a:	000ba583          	lw	a1,0(s7)
 94e:	8556                	mv	a0,s5
 950:	00000097          	auipc	ra,0x0
 954:	ebc080e7          	jalr	-324(ra) # 80c <printint>
 958:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 95a:	4981                	li	s3,0
 95c:	b745                	j	8fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 95e:	008b8913          	addi	s2,s7,8
 962:	4681                	li	a3,0
 964:	4629                	li	a2,10
 966:	000ba583          	lw	a1,0(s7)
 96a:	8556                	mv	a0,s5
 96c:	00000097          	auipc	ra,0x0
 970:	ea0080e7          	jalr	-352(ra) # 80c <printint>
 974:	8bca                	mv	s7,s2
      state = 0;
 976:	4981                	li	s3,0
 978:	b751                	j	8fc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 97a:	008b8913          	addi	s2,s7,8
 97e:	4681                	li	a3,0
 980:	4641                	li	a2,16
 982:	000ba583          	lw	a1,0(s7)
 986:	8556                	mv	a0,s5
 988:	00000097          	auipc	ra,0x0
 98c:	e84080e7          	jalr	-380(ra) # 80c <printint>
 990:	8bca                	mv	s7,s2
      state = 0;
 992:	4981                	li	s3,0
 994:	b7a5                	j	8fc <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 996:	008b8c13          	addi	s8,s7,8
 99a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 99e:	03000593          	li	a1,48
 9a2:	8556                	mv	a0,s5
 9a4:	00000097          	auipc	ra,0x0
 9a8:	e46080e7          	jalr	-442(ra) # 7ea <putc>
  putc(fd, 'x');
 9ac:	07800593          	li	a1,120
 9b0:	8556                	mv	a0,s5
 9b2:	00000097          	auipc	ra,0x0
 9b6:	e38080e7          	jalr	-456(ra) # 7ea <putc>
 9ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9bc:	00000b97          	auipc	s7,0x0
 9c0:	414b8b93          	addi	s7,s7,1044 # dd0 <digits>
 9c4:	03c9d793          	srli	a5,s3,0x3c
 9c8:	97de                	add	a5,a5,s7
 9ca:	0007c583          	lbu	a1,0(a5)
 9ce:	8556                	mv	a0,s5
 9d0:	00000097          	auipc	ra,0x0
 9d4:	e1a080e7          	jalr	-486(ra) # 7ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9d8:	0992                	slli	s3,s3,0x4
 9da:	397d                	addiw	s2,s2,-1
 9dc:	fe0914e3          	bnez	s2,9c4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 9e0:	8be2                	mv	s7,s8
      state = 0;
 9e2:	4981                	li	s3,0
 9e4:	bf21                	j	8fc <vprintf+0x44>
        s = va_arg(ap, char*);
 9e6:	008b8993          	addi	s3,s7,8
 9ea:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 9ee:	02090163          	beqz	s2,a10 <vprintf+0x158>
        while(*s != 0){
 9f2:	00094583          	lbu	a1,0(s2)
 9f6:	c9a5                	beqz	a1,a66 <vprintf+0x1ae>
          putc(fd, *s);
 9f8:	8556                	mv	a0,s5
 9fa:	00000097          	auipc	ra,0x0
 9fe:	df0080e7          	jalr	-528(ra) # 7ea <putc>
          s++;
 a02:	0905                	addi	s2,s2,1
        while(*s != 0){
 a04:	00094583          	lbu	a1,0(s2)
 a08:	f9e5                	bnez	a1,9f8 <vprintf+0x140>
        s = va_arg(ap, char*);
 a0a:	8bce                	mv	s7,s3
      state = 0;
 a0c:	4981                	li	s3,0
 a0e:	b5fd                	j	8fc <vprintf+0x44>
          s = "(null)";
 a10:	00000917          	auipc	s2,0x0
 a14:	36090913          	addi	s2,s2,864 # d70 <malloc+0x206>
        while(*s != 0){
 a18:	02800593          	li	a1,40
 a1c:	bff1                	j	9f8 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 a1e:	008b8913          	addi	s2,s7,8
 a22:	000bc583          	lbu	a1,0(s7)
 a26:	8556                	mv	a0,s5
 a28:	00000097          	auipc	ra,0x0
 a2c:	dc2080e7          	jalr	-574(ra) # 7ea <putc>
 a30:	8bca                	mv	s7,s2
      state = 0;
 a32:	4981                	li	s3,0
 a34:	b5e1                	j	8fc <vprintf+0x44>
        putc(fd, c);
 a36:	02500593          	li	a1,37
 a3a:	8556                	mv	a0,s5
 a3c:	00000097          	auipc	ra,0x0
 a40:	dae080e7          	jalr	-594(ra) # 7ea <putc>
      state = 0;
 a44:	4981                	li	s3,0
 a46:	bd5d                	j	8fc <vprintf+0x44>
        putc(fd, '%');
 a48:	02500593          	li	a1,37
 a4c:	8556                	mv	a0,s5
 a4e:	00000097          	auipc	ra,0x0
 a52:	d9c080e7          	jalr	-612(ra) # 7ea <putc>
        putc(fd, c);
 a56:	85ca                	mv	a1,s2
 a58:	8556                	mv	a0,s5
 a5a:	00000097          	auipc	ra,0x0
 a5e:	d90080e7          	jalr	-624(ra) # 7ea <putc>
      state = 0;
 a62:	4981                	li	s3,0
 a64:	bd61                	j	8fc <vprintf+0x44>
        s = va_arg(ap, char*);
 a66:	8bce                	mv	s7,s3
      state = 0;
 a68:	4981                	li	s3,0
 a6a:	bd49                	j	8fc <vprintf+0x44>
    }
  }
}
 a6c:	60a6                	ld	ra,72(sp)
 a6e:	6406                	ld	s0,64(sp)
 a70:	74e2                	ld	s1,56(sp)
 a72:	7942                	ld	s2,48(sp)
 a74:	79a2                	ld	s3,40(sp)
 a76:	7a02                	ld	s4,32(sp)
 a78:	6ae2                	ld	s5,24(sp)
 a7a:	6b42                	ld	s6,16(sp)
 a7c:	6ba2                	ld	s7,8(sp)
 a7e:	6c02                	ld	s8,0(sp)
 a80:	6161                	addi	sp,sp,80
 a82:	8082                	ret

0000000000000a84 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a84:	715d                	addi	sp,sp,-80
 a86:	ec06                	sd	ra,24(sp)
 a88:	e822                	sd	s0,16(sp)
 a8a:	1000                	addi	s0,sp,32
 a8c:	e010                	sd	a2,0(s0)
 a8e:	e414                	sd	a3,8(s0)
 a90:	e818                	sd	a4,16(s0)
 a92:	ec1c                	sd	a5,24(s0)
 a94:	03043023          	sd	a6,32(s0)
 a98:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a9c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 aa0:	8622                	mv	a2,s0
 aa2:	00000097          	auipc	ra,0x0
 aa6:	e16080e7          	jalr	-490(ra) # 8b8 <vprintf>
}
 aaa:	60e2                	ld	ra,24(sp)
 aac:	6442                	ld	s0,16(sp)
 aae:	6161                	addi	sp,sp,80
 ab0:	8082                	ret

0000000000000ab2 <printf>:

void
printf(const char *fmt, ...)
{
 ab2:	711d                	addi	sp,sp,-96
 ab4:	ec06                	sd	ra,24(sp)
 ab6:	e822                	sd	s0,16(sp)
 ab8:	1000                	addi	s0,sp,32
 aba:	e40c                	sd	a1,8(s0)
 abc:	e810                	sd	a2,16(s0)
 abe:	ec14                	sd	a3,24(s0)
 ac0:	f018                	sd	a4,32(s0)
 ac2:	f41c                	sd	a5,40(s0)
 ac4:	03043823          	sd	a6,48(s0)
 ac8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 acc:	00840613          	addi	a2,s0,8
 ad0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ad4:	85aa                	mv	a1,a0
 ad6:	4505                	li	a0,1
 ad8:	00000097          	auipc	ra,0x0
 adc:	de0080e7          	jalr	-544(ra) # 8b8 <vprintf>
}
 ae0:	60e2                	ld	ra,24(sp)
 ae2:	6442                	ld	s0,16(sp)
 ae4:	6125                	addi	sp,sp,96
 ae6:	8082                	ret

0000000000000ae8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ae8:	1141                	addi	sp,sp,-16
 aea:	e422                	sd	s0,8(sp)
 aec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af2:	00000797          	auipc	a5,0x0
 af6:	5167b783          	ld	a5,1302(a5) # 1008 <freep>
 afa:	a02d                	j	b24 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 afc:	4618                	lw	a4,8(a2)
 afe:	9f2d                	addw	a4,a4,a1
 b00:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b04:	6398                	ld	a4,0(a5)
 b06:	6310                	ld	a2,0(a4)
 b08:	a83d                	j	b46 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b0a:	ff852703          	lw	a4,-8(a0)
 b0e:	9f31                	addw	a4,a4,a2
 b10:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b12:	ff053683          	ld	a3,-16(a0)
 b16:	a091                	j	b5a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b18:	6398                	ld	a4,0(a5)
 b1a:	00e7e463          	bltu	a5,a4,b22 <free+0x3a>
 b1e:	00e6ea63          	bltu	a3,a4,b32 <free+0x4a>
{
 b22:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b24:	fed7fae3          	bgeu	a5,a3,b18 <free+0x30>
 b28:	6398                	ld	a4,0(a5)
 b2a:	00e6e463          	bltu	a3,a4,b32 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b2e:	fee7eae3          	bltu	a5,a4,b22 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b32:	ff852583          	lw	a1,-8(a0)
 b36:	6390                	ld	a2,0(a5)
 b38:	02059813          	slli	a6,a1,0x20
 b3c:	01c85713          	srli	a4,a6,0x1c
 b40:	9736                	add	a4,a4,a3
 b42:	fae60de3          	beq	a2,a4,afc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b46:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b4a:	4790                	lw	a2,8(a5)
 b4c:	02061593          	slli	a1,a2,0x20
 b50:	01c5d713          	srli	a4,a1,0x1c
 b54:	973e                	add	a4,a4,a5
 b56:	fae68ae3          	beq	a3,a4,b0a <free+0x22>
    p->s.ptr = bp->s.ptr;
 b5a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b5c:	00000717          	auipc	a4,0x0
 b60:	4af73623          	sd	a5,1196(a4) # 1008 <freep>
}
 b64:	6422                	ld	s0,8(sp)
 b66:	0141                	addi	sp,sp,16
 b68:	8082                	ret

0000000000000b6a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b6a:	7139                	addi	sp,sp,-64
 b6c:	fc06                	sd	ra,56(sp)
 b6e:	f822                	sd	s0,48(sp)
 b70:	f426                	sd	s1,40(sp)
 b72:	f04a                	sd	s2,32(sp)
 b74:	ec4e                	sd	s3,24(sp)
 b76:	e852                	sd	s4,16(sp)
 b78:	e456                	sd	s5,8(sp)
 b7a:	e05a                	sd	s6,0(sp)
 b7c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b7e:	02051493          	slli	s1,a0,0x20
 b82:	9081                	srli	s1,s1,0x20
 b84:	04bd                	addi	s1,s1,15
 b86:	8091                	srli	s1,s1,0x4
 b88:	0014899b          	addiw	s3,s1,1
 b8c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b8e:	00000517          	auipc	a0,0x0
 b92:	47a53503          	ld	a0,1146(a0) # 1008 <freep>
 b96:	c515                	beqz	a0,bc2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b98:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b9a:	4798                	lw	a4,8(a5)
 b9c:	02977f63          	bgeu	a4,s1,bda <malloc+0x70>
  if(nu < 4096)
 ba0:	8a4e                	mv	s4,s3
 ba2:	0009871b          	sext.w	a4,s3
 ba6:	6685                	lui	a3,0x1
 ba8:	00d77363          	bgeu	a4,a3,bae <malloc+0x44>
 bac:	6a05                	lui	s4,0x1
 bae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bb2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bb6:	00000917          	auipc	s2,0x0
 bba:	45290913          	addi	s2,s2,1106 # 1008 <freep>
  if(p == (char*)-1)
 bbe:	5afd                	li	s5,-1
 bc0:	a895                	j	c34 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 bc2:	00004797          	auipc	a5,0x4
 bc6:	44e78793          	addi	a5,a5,1102 # 5010 <base>
 bca:	00000717          	auipc	a4,0x0
 bce:	42f73f23          	sd	a5,1086(a4) # 1008 <freep>
 bd2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bd4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bd8:	b7e1                	j	ba0 <malloc+0x36>
      if(p->s.size == nunits)
 bda:	02e48c63          	beq	s1,a4,c12 <malloc+0xa8>
        p->s.size -= nunits;
 bde:	4137073b          	subw	a4,a4,s3
 be2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 be4:	02071693          	slli	a3,a4,0x20
 be8:	01c6d713          	srli	a4,a3,0x1c
 bec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bf2:	00000717          	auipc	a4,0x0
 bf6:	40a73b23          	sd	a0,1046(a4) # 1008 <freep>
      return (void*)(p + 1);
 bfa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bfe:	70e2                	ld	ra,56(sp)
 c00:	7442                	ld	s0,48(sp)
 c02:	74a2                	ld	s1,40(sp)
 c04:	7902                	ld	s2,32(sp)
 c06:	69e2                	ld	s3,24(sp)
 c08:	6a42                	ld	s4,16(sp)
 c0a:	6aa2                	ld	s5,8(sp)
 c0c:	6b02                	ld	s6,0(sp)
 c0e:	6121                	addi	sp,sp,64
 c10:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c12:	6398                	ld	a4,0(a5)
 c14:	e118                	sd	a4,0(a0)
 c16:	bff1                	j	bf2 <malloc+0x88>
  hp->s.size = nu;
 c18:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c1c:	0541                	addi	a0,a0,16
 c1e:	00000097          	auipc	ra,0x0
 c22:	eca080e7          	jalr	-310(ra) # ae8 <free>
  return freep;
 c26:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c2a:	d971                	beqz	a0,bfe <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c2e:	4798                	lw	a4,8(a5)
 c30:	fa9775e3          	bgeu	a4,s1,bda <malloc+0x70>
    if(p == freep)
 c34:	00093703          	ld	a4,0(s2)
 c38:	853e                	mv	a0,a5
 c3a:	fef719e3          	bne	a4,a5,c2c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 c3e:	8552                	mv	a0,s4
 c40:	00000097          	auipc	ra,0x0
 c44:	b92080e7          	jalr	-1134(ra) # 7d2 <sbrk>
  if(p == (char*)-1)
 c48:	fd5518e3          	bne	a0,s5,c18 <malloc+0xae>
        return 0;
 c4c:	4501                	li	a0,0
 c4e:	bf45                	j	bfe <malloc+0x94>
