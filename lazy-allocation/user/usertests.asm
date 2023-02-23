
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
  }
}

// what if you pass ridiculous string pointers to system calls?
void copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16

  for (int ai = 0; ai < 2; ai++)
  {
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	bd6080e7          	jalr	-1066(ra) # 5be6 <open>
    if (fd >= 0)
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	bc4080e7          	jalr	-1084(ra) # 5be6 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if (fd >= 0)
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
    {
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	07250513          	addi	a0,a0,114 # 60b0 <malloc+0xea>
      46:	00006097          	auipc	ra,0x6
      4a:	ec8080e7          	jalr	-312(ra) # 5f0e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b56080e7          	jalr	-1194(ra) # 5ba6 <exit>

0000000000000058 <bsstest>:
char uninit[10000];
void bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++)
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
  {
    if (uninit[i] != '\0')
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++)
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
    {
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	05050513          	addi	a0,a0,80 # 60d0 <malloc+0x10a>
      88:	00006097          	auipc	ra,0x6
      8c:	e86080e7          	jalr	-378(ra) # 5f0e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b14080e7          	jalr	-1260(ra) # 5ba6 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	04050513          	addi	a0,a0,64 # 60e8 <malloc+0x122>
      b0:	00006097          	auipc	ra,0x6
      b4:	b36080e7          	jalr	-1226(ra) # 5be6 <open>
  if (fd < 0)
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b12080e7          	jalr	-1262(ra) # 5bce <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	04250513          	addi	a0,a0,66 # 6108 <malloc+0x142>
      ce:	00006097          	auipc	ra,0x6
      d2:	b18080e7          	jalr	-1256(ra) # 5be6 <open>
  if (fd >= 0)
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	00a50513          	addi	a0,a0,10 # 60f0 <malloc+0x12a>
      ee:	00006097          	auipc	ra,0x6
      f2:	e20080e7          	jalr	-480(ra) # 5f0e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	aae080e7          	jalr	-1362(ra) # 5ba6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	01650513          	addi	a0,a0,22 # 6118 <malloc+0x152>
     10a:	00006097          	auipc	ra,0x6
     10e:	e04080e7          	jalr	-508(ra) # 5f0e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	a92080e7          	jalr	-1390(ra) # 5ba6 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	01450513          	addi	a0,a0,20 # 6140 <malloc+0x17a>
     134:	00006097          	auipc	ra,0x6
     138:	ac2080e7          	jalr	-1342(ra) # 5bf6 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	00050513          	mv	a0,a0
     148:	00006097          	auipc	ra,0x6
     14c:	a9e080e7          	jalr	-1378(ra) # 5be6 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	ffc58593          	addi	a1,a1,-4 # 6150 <malloc+0x18a>
     15c:	00006097          	auipc	ra,0x6
     160:	a6a080e7          	jalr	-1430(ra) # 5bc6 <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	fd850513          	addi	a0,a0,-40 # 6140 <malloc+0x17a>
     170:	00006097          	auipc	ra,0x6
     174:	a76080e7          	jalr	-1418(ra) # 5be6 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	fdc58593          	addi	a1,a1,-36 # 6158 <malloc+0x192>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a40080e7          	jalr	-1472(ra) # 5bc6 <write>
  if (n != -1)
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	fac50513          	addi	a0,a0,-84 # 6140 <malloc+0x17a>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a5a080e7          	jalr	-1446(ra) # 5bf6 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a28080e7          	jalr	-1496(ra) # 5bce <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a1e080e7          	jalr	-1506(ra) # 5bce <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	f9650513          	addi	a0,a0,-106 # 6160 <malloc+0x19a>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d3c080e7          	jalr	-708(ra) # 5f0e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9ca080e7          	jalr	-1590(ra) # 5ba6 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for (i = 0; i < N; i++)
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE | O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9d6080e7          	jalr	-1578(ra) # 5be6 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9b6080e7          	jalr	-1610(ra) # 5bce <close>
  for (i = 0; i < N; i++)
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for (i = 0; i < N; i++)
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9b0080e7          	jalr	-1616(ra) # 5bf6 <unlink>
  for (i = 0; i < N; i++)
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f0c50513          	addi	a0,a0,-244 # 6188 <malloc+0x1c2>
     284:	00006097          	auipc	ra,0x6
     288:	972080e7          	jalr	-1678(ra) # 5bf6 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471)
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	ef8a8a93          	addi	s5,s5,-264 # 6188 <malloc+0x1c2>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471)
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x193>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	93a080e7          	jalr	-1734(ra) # 5be6 <open>
     2b4:	892a                	mv	s2,a0
    if (fd < 0)
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	908080e7          	jalr	-1784(ra) # 5bc6 <write>
     2c6:	89aa                	mv	s3,a0
      if (cc != sz)
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	8f4080e7          	jalr	-1804(ra) # 5bc6 <write>
      if (cc != sz)
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	8ee080e7          	jalr	-1810(ra) # 5bce <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	90c080e7          	jalr	-1780(ra) # 5bf6 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471)
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	e8650513          	addi	a0,a0,-378 # 6198 <malloc+0x1d2>
     31a:	00006097          	auipc	ra,0x6
     31e:	bf4080e7          	jalr	-1036(ra) # 5f0e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	882080e7          	jalr	-1918(ra) # 5ba6 <exit>
      if (cc != sz)
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	e8450513          	addi	a0,a0,-380 # 61b8 <malloc+0x1f2>
     33c:	00006097          	auipc	ra,0x6
     340:	bd2080e7          	jalr	-1070(ra) # 5f0e <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	860080e7          	jalr	-1952(ra) # 5ba6 <exit>

000000000000034e <badwrite>:
// a block to be allocated for a file that is then not freed when the
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void badwrite(char *s)
{
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;

  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	e7250513          	addi	a0,a0,-398 # 61d0 <malloc+0x20a>
     366:	00006097          	auipc	ra,0x6
     36a:	890080e7          	jalr	-1904(ra) # 5bf6 <unlink>
     36e:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++)
  {
    int fd = open("junk", O_CREATE | O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	e5e98993          	addi	s3,s3,-418 # 61d0 <malloc+0x20a>
    if (fd < 0)
    {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	860080e7          	jalr	-1952(ra) # 5be6 <open>
     38e:	84aa                	mv	s1,a0
    if (fd < 0)
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char *)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	82e080e7          	jalr	-2002(ra) # 5bc6 <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	82c080e7          	jalr	-2004(ra) # 5bce <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	84a080e7          	jalr	-1974(ra) # 5bf6 <unlink>
  for (int i = 0; i < assumed_free; i++)
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	e1250513          	addi	a0,a0,-494 # 61d0 <malloc+0x20a>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	820080e7          	jalr	-2016(ra) # 5be6 <open>
     3ce:	84aa                	mv	s1,a0
  if (fd < 0)
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
  {
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1)
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	d8258593          	addi	a1,a1,-638 # 6158 <malloc+0x192>
     3de:	00005097          	auipc	ra,0x5
     3e2:	7e8080e7          	jalr	2024(ra) # 5bc6 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
  {
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	e0450513          	addi	a0,a0,-508 # 61f0 <malloc+0x22a>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	b1a080e7          	jalr	-1254(ra) # 5f0e <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	7a8080e7          	jalr	1960(ra) # 5ba6 <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	dd250513          	addi	a0,a0,-558 # 61d8 <malloc+0x212>
     40e:	00006097          	auipc	ra,0x6
     412:	b00080e7          	jalr	-1280(ra) # 5f0e <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	78e080e7          	jalr	1934(ra) # 5ba6 <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	db850513          	addi	a0,a0,-584 # 61d8 <malloc+0x212>
     428:	00006097          	auipc	ra,0x6
     42c:	ae6080e7          	jalr	-1306(ra) # 5f0e <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	774080e7          	jalr	1908(ra) # 5ba6 <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	792080e7          	jalr	1938(ra) # 5bce <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	d8c50513          	addi	a0,a0,-628 # 61d0 <malloc+0x20a>
     44c:	00005097          	auipc	ra,0x5
     450:	7aa080e7          	jalr	1962(ra) # 5bf6 <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	750080e7          	jalr	1872(ra) # 5ba6 <exit>

000000000000045e <outofinodes>:
    unlink(name);
  }
}

void outofinodes(char *s)
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++)
     46c:	4481                	li	s1,0
  {
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++)
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	74c080e7          	jalr	1868(ra) # 5bf6 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	72c080e7          	jalr	1836(ra) # 5be6 <open>
    if (fd < 0)
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
    {
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	708080e7          	jalr	1800(ra) # 5bce <close>
  for (int i = 0; i < nzz; i++)
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for (int i = 0; i < nzz; i++)
  {
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++)
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	6e4080e7          	jalr	1764(ra) # 5bf6 <unlink>
  for (int i = 0; i < nzz; i++)
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for (int ai = 0; ai < 2; ai++)
     54c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	cb0a0a13          	addi	s4,s4,-848 # 6200 <malloc+0x23a>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	684080e7          	jalr	1668(ra) # 5be6 <open>
     56a:	84aa                	mv	s1,a0
    if (fd < 0)
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void *)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	652080e7          	jalr	1618(ra) # 5bc6 <write>
    if (n >= 0)
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	64c080e7          	jalr	1612(ra) # 5bce <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	66a080e7          	jalr	1642(ra) # 5bf6 <unlink>
    n = write(1, (char *)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	62c080e7          	jalr	1580(ra) # 5bc6 <write>
    if (n > 0)
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if (pipe(fds) < 0)
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	60c080e7          	jalr	1548(ra) # 5bb6 <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char *)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	608080e7          	jalr	1544(ra) # 5bc6 <write>
    if (n > 0)
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	600080e7          	jalr	1536(ra) # 5bce <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	5f4080e7          	jalr	1524(ra) # 5bce <close>
  for (int ai = 0; ai < 2; ai++)
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	c0c50513          	addi	a0,a0,-1012 # 6208 <malloc+0x242>
     604:	00006097          	auipc	ra,0x6
     608:	90a080e7          	jalr	-1782(ra) # 5f0e <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	598080e7          	jalr	1432(ra) # 5ba6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	c0650513          	addi	a0,a0,-1018 # 6220 <malloc+0x25a>
     622:	00006097          	auipc	ra,0x6
     626:	8ec080e7          	jalr	-1812(ra) # 5f0e <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	57a080e7          	jalr	1402(ra) # 5ba6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	c1850513          	addi	a0,a0,-1000 # 6250 <malloc+0x28a>
     640:	00006097          	auipc	ra,0x6
     644:	8ce080e7          	jalr	-1842(ra) # 5f0e <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	55c080e7          	jalr	1372(ra) # 5ba6 <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	c2e50513          	addi	a0,a0,-978 # 6280 <malloc+0x2ba>
     65a:	00006097          	auipc	ra,0x6
     65e:	8b4080e7          	jalr	-1868(ra) # 5f0e <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	542080e7          	jalr	1346(ra) # 5ba6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	c2050513          	addi	a0,a0,-992 # 6290 <malloc+0x2ca>
     678:	00006097          	auipc	ra,0x6
     67c:	896080e7          	jalr	-1898(ra) # 5f0e <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	524080e7          	jalr	1316(ra) # 5ba6 <exit>

000000000000068a <copyout>:
{
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     69c:	4785                	li	a5,1
     69e:	07fe                	slli	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for (int ai = 0; ai < 2; ai++)
     6aa:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	c12a0a13          	addi	s4,s4,-1006 # 62c0 <malloc+0x2fa>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	aa2a8a93          	addi	s5,s5,-1374 # 6158 <malloc+0x192>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	520080e7          	jalr	1312(ra) # 5be6 <open>
     6ce:	84aa                	mv	s1,a0
    if (fd < 0)
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void *)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	4e6080e7          	jalr	1254(ra) # 5bbe <read>
    if (n > 0)
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	4e8080e7          	jalr	1256(ra) # 5bce <close>
    if (pipe(fds) < 0)
     6ee:	fa840513          	addi	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	4c4080e7          	jalr	1220(ra) # 5bb6 <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	4c0080e7          	jalr	1216(ra) # 5bc6 <write>
    if (n != 1)
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void *)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	4a2080e7          	jalr	1186(ra) # 5bbe <read>
    if (n > 0)
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	4a2080e7          	jalr	1186(ra) # 5bce <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	496080e7          	jalr	1174(ra) # 5bce <close>
  for (int ai = 0; ai < 2; ai++)
     740:	0921                	addi	s2,s2,8
     742:	fc040793          	addi	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	addi	sp,sp,96
     75a:	8082                	ret
      printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	b6c50513          	addi	a0,a0,-1172 # 62c8 <malloc+0x302>
     764:	00005097          	auipc	ra,0x5
     768:	7aa080e7          	jalr	1962(ra) # 5f0e <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	438080e7          	jalr	1080(ra) # 5ba6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	b6650513          	addi	a0,a0,-1178 # 62e0 <malloc+0x31a>
     782:	00005097          	auipc	ra,0x5
     786:	78c080e7          	jalr	1932(ra) # 5f0e <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	41a080e7          	jalr	1050(ra) # 5ba6 <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	aec50513          	addi	a0,a0,-1300 # 6280 <malloc+0x2ba>
     79c:	00005097          	auipc	ra,0x5
     7a0:	772080e7          	jalr	1906(ra) # 5f0e <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	400080e7          	jalr	1024(ra) # 5ba6 <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	b6250513          	addi	a0,a0,-1182 # 6310 <malloc+0x34a>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	758080e7          	jalr	1880(ra) # 5f0e <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	3e6080e7          	jalr	998(ra) # 5ba6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	b5c50513          	addi	a0,a0,-1188 # 6328 <malloc+0x362>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	73a080e7          	jalr	1850(ra) # 5f0e <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	3c8080e7          	jalr	968(ra) # 5ba6 <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	addi	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	addi	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	94650513          	addi	a0,a0,-1722 # 6140 <malloc+0x17a>
     802:	00005097          	auipc	ra,0x5
     806:	3f4080e7          	jalr	1012(ra) # 5bf6 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	93250513          	addi	a0,a0,-1742 # 6140 <malloc+0x17a>
     816:	00005097          	auipc	ra,0x5
     81a:	3d0080e7          	jalr	976(ra) # 5be6 <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	92e58593          	addi	a1,a1,-1746 # 6150 <malloc+0x18a>
     82a:	00005097          	auipc	ra,0x5
     82e:	39c080e7          	jalr	924(ra) # 5bc6 <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	39a080e7          	jalr	922(ra) # 5bce <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	90250513          	addi	a0,a0,-1790 # 6140 <malloc+0x17a>
     846:	00005097          	auipc	ra,0x5
     84a:	3a0080e7          	jalr	928(ra) # 5be6 <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	addi	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	366080e7          	jalr	870(ra) # 5bbe <read>
  if (n != 4)
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	8d650513          	addi	a0,a0,-1834 # 6140 <malloc+0x17a>
     872:	00005097          	auipc	ra,0x5
     876:	374080e7          	jalr	884(ra) # 5be6 <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	8c250513          	addi	a0,a0,-1854 # 6140 <malloc+0x17a>
     886:	00005097          	auipc	ra,0x5
     88a:	360080e7          	jalr	864(ra) # 5be6 <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	addi	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	326080e7          	jalr	806(ra) # 5bbe <read>
     8a0:	8a2a                	mv	s4,a0
  if (n != 0)
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	310080e7          	jalr	784(ra) # 5bbe <read>
     8b6:	8a2a                	mv	s4,a0
  if (n != 0)
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	afc58593          	addi	a1,a1,-1284 # 63b8 <malloc+0x3f2>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	300080e7          	jalr	768(ra) # 5bc6 <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	addi	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	2e6080e7          	jalr	742(ra) # 5bbe <read>
  if (n != 6)
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	addi	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	2ce080e7          	jalr	718(ra) # 5bbe <read>
  if (n != 2)
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	84250513          	addi	a0,a0,-1982 # 6140 <malloc+0x17a>
     906:	00005097          	auipc	ra,0x5
     90a:	2f0080e7          	jalr	752(ra) # 5bf6 <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	2be080e7          	jalr	702(ra) # 5bce <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	2b4080e7          	jalr	692(ra) # 5bce <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	2aa080e7          	jalr	682(ra) # 5bce <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	addi	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	a1650513          	addi	a0,a0,-1514 # 6358 <malloc+0x392>
     94a:	00005097          	auipc	ra,0x5
     94e:	5c4080e7          	jalr	1476(ra) # 5f0e <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	252080e7          	jalr	594(ra) # 5ba6 <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	a1a50513          	addi	a0,a0,-1510 # 6378 <malloc+0x3b2>
     966:	00005097          	auipc	ra,0x5
     96a:	5a8080e7          	jalr	1448(ra) # 5f0e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	a1650513          	addi	a0,a0,-1514 # 6388 <malloc+0x3c2>
     97a:	00005097          	auipc	ra,0x5
     97e:	594080e7          	jalr	1428(ra) # 5f0e <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	222080e7          	jalr	546(ra) # 5ba6 <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	a1a50513          	addi	a0,a0,-1510 # 63a8 <malloc+0x3e2>
     996:	00005097          	auipc	ra,0x5
     99a:	578080e7          	jalr	1400(ra) # 5f0e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	9e650513          	addi	a0,a0,-1562 # 6388 <malloc+0x3c2>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	564080e7          	jalr	1380(ra) # 5f0e <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	1f2080e7          	jalr	498(ra) # 5ba6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	a0050513          	addi	a0,a0,-1536 # 63c0 <malloc+0x3fa>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	546080e7          	jalr	1350(ra) # 5f0e <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	1d4080e7          	jalr	468(ra) # 5ba6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	a0250513          	addi	a0,a0,-1534 # 63e0 <malloc+0x41a>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	528080e7          	jalr	1320(ra) # 5f0e <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	1b6080e7          	jalr	438(ra) # 5ba6 <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	addi	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE | O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	9ee50513          	addi	a0,a0,-1554 # 6400 <malloc+0x43a>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	1cc080e7          	jalr	460(ra) # 5be6 <open>
  if (fd < 0)
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ)
     a2a:	00006997          	auipc	s3,0x6
     a2e:	9fe98993          	addi	s3,s3,-1538 # 6428 <malloc+0x462>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ)
     a32:	00006a97          	auipc	s5,0x6
     a36:	a2ea8a93          	addi	s5,s5,-1490 # 6460 <malloc+0x49a>
  for (i = 0; i < N; i++)
     a3a:	06400a13          	li	s4,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ)
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	182080e7          	jalr	386(ra) # 5bc6 <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ)
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	16e080e7          	jalr	366(ra) # 5bc6 <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for (i = 0; i < N; i++)
     a66:	2485                	addiw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	160080e7          	jalr	352(ra) # 5bce <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	98850513          	addi	a0,a0,-1656 # 6400 <malloc+0x43a>
     a80:	00005097          	auipc	ra,0x5
     a84:	166080e7          	jalr	358(ra) # 5be6 <open>
     a88:	84aa                	mv	s1,a0
  if (fd < 0)
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N * SZ * 2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000c597          	auipc	a1,0xc
     a96:	1e658593          	addi	a1,a1,486 # cc78 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	124080e7          	jalr	292(ra) # 5bbe <read>
  if (i != N * SZ * 2)
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	122080e7          	jalr	290(ra) # 5bce <close>
  if (unlink("small") < 0)
     ab4:	00006517          	auipc	a0,0x6
     ab8:	94c50513          	addi	a0,a0,-1716 # 6400 <malloc+0x43a>
     abc:	00005097          	auipc	ra,0x5
     ac0:	13a080e7          	jalr	314(ra) # 5bf6 <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	addi	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	92a50513          	addi	a0,a0,-1750 # 6408 <malloc+0x442>
     ae6:	00005097          	auipc	ra,0x5
     aea:	428080e7          	jalr	1064(ra) # 5f0e <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	0b6080e7          	jalr	182(ra) # 5ba6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	93c50513          	addi	a0,a0,-1732 # 6438 <malloc+0x472>
     b04:	00005097          	auipc	ra,0x5
     b08:	40a080e7          	jalr	1034(ra) # 5f0e <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	098080e7          	jalr	152(ra) # 5ba6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	95650513          	addi	a0,a0,-1706 # 6470 <malloc+0x4aa>
     b22:	00005097          	auipc	ra,0x5
     b26:	3ec080e7          	jalr	1004(ra) # 5f0e <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	07a080e7          	jalr	122(ra) # 5ba6 <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	96250513          	addi	a0,a0,-1694 # 6498 <malloc+0x4d2>
     b3e:	00005097          	auipc	ra,0x5
     b42:	3d0080e7          	jalr	976(ra) # 5f0e <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	05e080e7          	jalr	94(ra) # 5ba6 <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	96650513          	addi	a0,a0,-1690 # 64b8 <malloc+0x4f2>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	3b4080e7          	jalr	948(ra) # 5f0e <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	042080e7          	jalr	66(ra) # 5ba6 <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	96250513          	addi	a0,a0,-1694 # 64d0 <malloc+0x50a>
     b76:	00005097          	auipc	ra,0x5
     b7a:	398080e7          	jalr	920(ra) # 5f0e <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	026080e7          	jalr	38(ra) # 5ba6 <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	addi	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	addi	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE | O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	95050513          	addi	a0,a0,-1712 # 64f0 <malloc+0x52a>
     ba8:	00005097          	auipc	ra,0x5
     bac:	03e080e7          	jalr	62(ra) # 5be6 <open>
     bb0:	89aa                	mv	s3,a0
  for (i = 0; i < MAXFILE; i++)
     bb2:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     bb4:	0000c917          	auipc	s2,0xc
     bb8:	0c490913          	addi	s2,s2,196 # cc78 <buf>
  for (i = 0; i < MAXFILE; i++)
     bbc:	10c00a13          	li	s4,268
  if (fd < 0)
     bc0:	06054c63          	bltz	a0,c38 <writebig+0xb0>
    ((int *)buf)[0] = i;
     bc4:	00992023          	sw	s1,0(s2)
    if (write(fd, buf, BSIZE) != BSIZE)
     bc8:	40000613          	li	a2,1024
     bcc:	85ca                	mv	a1,s2
     bce:	854e                	mv	a0,s3
     bd0:	00005097          	auipc	ra,0x5
     bd4:	ff6080e7          	jalr	-10(ra) # 5bc6 <write>
     bd8:	40000793          	li	a5,1024
     bdc:	06f51c63          	bne	a0,a5,c54 <writebig+0xcc>
  for (i = 0; i < MAXFILE; i++)
     be0:	2485                	addiw	s1,s1,1
     be2:	ff4491e3          	bne	s1,s4,bc4 <writebig+0x3c>
  close(fd);
     be6:	854e                	mv	a0,s3
     be8:	00005097          	auipc	ra,0x5
     bec:	fe6080e7          	jalr	-26(ra) # 5bce <close>
  fd = open("big", O_RDONLY);
     bf0:	4581                	li	a1,0
     bf2:	00006517          	auipc	a0,0x6
     bf6:	8fe50513          	addi	a0,a0,-1794 # 64f0 <malloc+0x52a>
     bfa:	00005097          	auipc	ra,0x5
     bfe:	fec080e7          	jalr	-20(ra) # 5be6 <open>
     c02:	89aa                	mv	s3,a0
  n = 0;
     c04:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c06:	0000c917          	auipc	s2,0xc
     c0a:	07290913          	addi	s2,s2,114 # cc78 <buf>
  if (fd < 0)
     c0e:	06054263          	bltz	a0,c72 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c12:	40000613          	li	a2,1024
     c16:	85ca                	mv	a1,s2
     c18:	854e                	mv	a0,s3
     c1a:	00005097          	auipc	ra,0x5
     c1e:	fa4080e7          	jalr	-92(ra) # 5bbe <read>
    if (i == 0)
     c22:	c535                	beqz	a0,c8e <writebig+0x106>
    else if (i != BSIZE)
     c24:	40000793          	li	a5,1024
     c28:	0af51f63          	bne	a0,a5,ce6 <writebig+0x15e>
    if (((int *)buf)[0] != n)
     c2c:	00092683          	lw	a3,0(s2)
     c30:	0c969a63          	bne	a3,s1,d04 <writebig+0x17c>
    n++;
     c34:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c36:	bff1                	j	c12 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c38:	85d6                	mv	a1,s5
     c3a:	00006517          	auipc	a0,0x6
     c3e:	8be50513          	addi	a0,a0,-1858 # 64f8 <malloc+0x532>
     c42:	00005097          	auipc	ra,0x5
     c46:	2cc080e7          	jalr	716(ra) # 5f0e <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	00005097          	auipc	ra,0x5
     c50:	f5a080e7          	jalr	-166(ra) # 5ba6 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c54:	8626                	mv	a2,s1
     c56:	85d6                	mv	a1,s5
     c58:	00006517          	auipc	a0,0x6
     c5c:	8c050513          	addi	a0,a0,-1856 # 6518 <malloc+0x552>
     c60:	00005097          	auipc	ra,0x5
     c64:	2ae080e7          	jalr	686(ra) # 5f0e <printf>
      exit(1);
     c68:	4505                	li	a0,1
     c6a:	00005097          	auipc	ra,0x5
     c6e:	f3c080e7          	jalr	-196(ra) # 5ba6 <exit>
    printf("%s: error: open big failed!\n", s);
     c72:	85d6                	mv	a1,s5
     c74:	00006517          	auipc	a0,0x6
     c78:	8cc50513          	addi	a0,a0,-1844 # 6540 <malloc+0x57a>
     c7c:	00005097          	auipc	ra,0x5
     c80:	292080e7          	jalr	658(ra) # 5f0e <printf>
    exit(1);
     c84:	4505                	li	a0,1
     c86:	00005097          	auipc	ra,0x5
     c8a:	f20080e7          	jalr	-224(ra) # 5ba6 <exit>
      if (n == MAXFILE - 1)
     c8e:	10b00793          	li	a5,267
     c92:	02f48a63          	beq	s1,a5,cc6 <writebig+0x13e>
  close(fd);
     c96:	854e                	mv	a0,s3
     c98:	00005097          	auipc	ra,0x5
     c9c:	f36080e7          	jalr	-202(ra) # 5bce <close>
  if (unlink("big") < 0)
     ca0:	00006517          	auipc	a0,0x6
     ca4:	85050513          	addi	a0,a0,-1968 # 64f0 <malloc+0x52a>
     ca8:	00005097          	auipc	ra,0x5
     cac:	f4e080e7          	jalr	-178(ra) # 5bf6 <unlink>
     cb0:	06054963          	bltz	a0,d22 <writebig+0x19a>
}
     cb4:	70e2                	ld	ra,56(sp)
     cb6:	7442                	ld	s0,48(sp)
     cb8:	74a2                	ld	s1,40(sp)
     cba:	7902                	ld	s2,32(sp)
     cbc:	69e2                	ld	s3,24(sp)
     cbe:	6a42                	ld	s4,16(sp)
     cc0:	6aa2                	ld	s5,8(sp)
     cc2:	6121                	addi	sp,sp,64
     cc4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc6:	10b00613          	li	a2,267
     cca:	85d6                	mv	a1,s5
     ccc:	00006517          	auipc	a0,0x6
     cd0:	89450513          	addi	a0,a0,-1900 # 6560 <malloc+0x59a>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	23a080e7          	jalr	570(ra) # 5f0e <printf>
        exit(1);
     cdc:	4505                	li	a0,1
     cde:	00005097          	auipc	ra,0x5
     ce2:	ec8080e7          	jalr	-312(ra) # 5ba6 <exit>
      printf("%s: read failed %d\n", s, i);
     ce6:	862a                	mv	a2,a0
     ce8:	85d6                	mv	a1,s5
     cea:	00006517          	auipc	a0,0x6
     cee:	89e50513          	addi	a0,a0,-1890 # 6588 <malloc+0x5c2>
     cf2:	00005097          	auipc	ra,0x5
     cf6:	21c080e7          	jalr	540(ra) # 5f0e <printf>
      exit(1);
     cfa:	4505                	li	a0,1
     cfc:	00005097          	auipc	ra,0x5
     d00:	eaa080e7          	jalr	-342(ra) # 5ba6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d04:	8626                	mv	a2,s1
     d06:	85d6                	mv	a1,s5
     d08:	00006517          	auipc	a0,0x6
     d0c:	89850513          	addi	a0,a0,-1896 # 65a0 <malloc+0x5da>
     d10:	00005097          	auipc	ra,0x5
     d14:	1fe080e7          	jalr	510(ra) # 5f0e <printf>
      exit(1);
     d18:	4505                	li	a0,1
     d1a:	00005097          	auipc	ra,0x5
     d1e:	e8c080e7          	jalr	-372(ra) # 5ba6 <exit>
    printf("%s: unlink big failed\n", s);
     d22:	85d6                	mv	a1,s5
     d24:	00006517          	auipc	a0,0x6
     d28:	8a450513          	addi	a0,a0,-1884 # 65c8 <malloc+0x602>
     d2c:	00005097          	auipc	ra,0x5
     d30:	1e2080e7          	jalr	482(ra) # 5f0e <printf>
    exit(1);
     d34:	4505                	li	a0,1
     d36:	00005097          	auipc	ra,0x5
     d3a:	e70080e7          	jalr	-400(ra) # 5ba6 <exit>

0000000000000d3e <unlinkread>:
{
     d3e:	7179                	addi	sp,sp,-48
     d40:	f406                	sd	ra,40(sp)
     d42:	f022                	sd	s0,32(sp)
     d44:	ec26                	sd	s1,24(sp)
     d46:	e84a                	sd	s2,16(sp)
     d48:	e44e                	sd	s3,8(sp)
     d4a:	1800                	addi	s0,sp,48
     d4c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d4e:	20200593          	li	a1,514
     d52:	00006517          	auipc	a0,0x6
     d56:	88e50513          	addi	a0,a0,-1906 # 65e0 <malloc+0x61a>
     d5a:	00005097          	auipc	ra,0x5
     d5e:	e8c080e7          	jalr	-372(ra) # 5be6 <open>
  if (fd < 0)
     d62:	0e054563          	bltz	a0,e4c <unlinkread+0x10e>
     d66:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d68:	4615                	li	a2,5
     d6a:	00006597          	auipc	a1,0x6
     d6e:	8a658593          	addi	a1,a1,-1882 # 6610 <malloc+0x64a>
     d72:	00005097          	auipc	ra,0x5
     d76:	e54080e7          	jalr	-428(ra) # 5bc6 <write>
  close(fd);
     d7a:	8526                	mv	a0,s1
     d7c:	00005097          	auipc	ra,0x5
     d80:	e52080e7          	jalr	-430(ra) # 5bce <close>
  fd = open("unlinkread", O_RDWR);
     d84:	4589                	li	a1,2
     d86:	00006517          	auipc	a0,0x6
     d8a:	85a50513          	addi	a0,a0,-1958 # 65e0 <malloc+0x61a>
     d8e:	00005097          	auipc	ra,0x5
     d92:	e58080e7          	jalr	-424(ra) # 5be6 <open>
     d96:	84aa                	mv	s1,a0
  if (fd < 0)
     d98:	0c054863          	bltz	a0,e68 <unlinkread+0x12a>
  if (unlink("unlinkread") != 0)
     d9c:	00006517          	auipc	a0,0x6
     da0:	84450513          	addi	a0,a0,-1980 # 65e0 <malloc+0x61a>
     da4:	00005097          	auipc	ra,0x5
     da8:	e52080e7          	jalr	-430(ra) # 5bf6 <unlink>
     dac:	ed61                	bnez	a0,e84 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00006517          	auipc	a0,0x6
     db6:	82e50513          	addi	a0,a0,-2002 # 65e0 <malloc+0x61a>
     dba:	00005097          	auipc	ra,0x5
     dbe:	e2c080e7          	jalr	-468(ra) # 5be6 <open>
     dc2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc4:	460d                	li	a2,3
     dc6:	00006597          	auipc	a1,0x6
     dca:	89258593          	addi	a1,a1,-1902 # 6658 <malloc+0x692>
     dce:	00005097          	auipc	ra,0x5
     dd2:	df8080e7          	jalr	-520(ra) # 5bc6 <write>
  close(fd1);
     dd6:	854a                	mv	a0,s2
     dd8:	00005097          	auipc	ra,0x5
     ddc:	df6080e7          	jalr	-522(ra) # 5bce <close>
  if (read(fd, buf, sizeof(buf)) != SZ)
     de0:	660d                	lui	a2,0x3
     de2:	0000c597          	auipc	a1,0xc
     de6:	e9658593          	addi	a1,a1,-362 # cc78 <buf>
     dea:	8526                	mv	a0,s1
     dec:	00005097          	auipc	ra,0x5
     df0:	dd2080e7          	jalr	-558(ra) # 5bbe <read>
     df4:	4795                	li	a5,5
     df6:	0af51563          	bne	a0,a5,ea0 <unlinkread+0x162>
  if (buf[0] != 'h')
     dfa:	0000c717          	auipc	a4,0xc
     dfe:	e7e74703          	lbu	a4,-386(a4) # cc78 <buf>
     e02:	06800793          	li	a5,104
     e06:	0af71b63          	bne	a4,a5,ebc <unlinkread+0x17e>
  if (write(fd, buf, 10) != 10)
     e0a:	4629                	li	a2,10
     e0c:	0000c597          	auipc	a1,0xc
     e10:	e6c58593          	addi	a1,a1,-404 # cc78 <buf>
     e14:	8526                	mv	a0,s1
     e16:	00005097          	auipc	ra,0x5
     e1a:	db0080e7          	jalr	-592(ra) # 5bc6 <write>
     e1e:	47a9                	li	a5,10
     e20:	0af51c63          	bne	a0,a5,ed8 <unlinkread+0x19a>
  close(fd);
     e24:	8526                	mv	a0,s1
     e26:	00005097          	auipc	ra,0x5
     e2a:	da8080e7          	jalr	-600(ra) # 5bce <close>
  unlink("unlinkread");
     e2e:	00005517          	auipc	a0,0x5
     e32:	7b250513          	addi	a0,a0,1970 # 65e0 <malloc+0x61a>
     e36:	00005097          	auipc	ra,0x5
     e3a:	dc0080e7          	jalr	-576(ra) # 5bf6 <unlink>
}
     e3e:	70a2                	ld	ra,40(sp)
     e40:	7402                	ld	s0,32(sp)
     e42:	64e2                	ld	s1,24(sp)
     e44:	6942                	ld	s2,16(sp)
     e46:	69a2                	ld	s3,8(sp)
     e48:	6145                	addi	sp,sp,48
     e4a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4c:	85ce                	mv	a1,s3
     e4e:	00005517          	auipc	a0,0x5
     e52:	7a250513          	addi	a0,a0,1954 # 65f0 <malloc+0x62a>
     e56:	00005097          	auipc	ra,0x5
     e5a:	0b8080e7          	jalr	184(ra) # 5f0e <printf>
    exit(1);
     e5e:	4505                	li	a0,1
     e60:	00005097          	auipc	ra,0x5
     e64:	d46080e7          	jalr	-698(ra) # 5ba6 <exit>
    printf("%s: open unlinkread failed\n", s);
     e68:	85ce                	mv	a1,s3
     e6a:	00005517          	auipc	a0,0x5
     e6e:	7ae50513          	addi	a0,a0,1966 # 6618 <malloc+0x652>
     e72:	00005097          	auipc	ra,0x5
     e76:	09c080e7          	jalr	156(ra) # 5f0e <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	d2a080e7          	jalr	-726(ra) # 5ba6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e84:	85ce                	mv	a1,s3
     e86:	00005517          	auipc	a0,0x5
     e8a:	7b250513          	addi	a0,a0,1970 # 6638 <malloc+0x672>
     e8e:	00005097          	auipc	ra,0x5
     e92:	080080e7          	jalr	128(ra) # 5f0e <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	d0e080e7          	jalr	-754(ra) # 5ba6 <exit>
    printf("%s: unlinkread read failed", s);
     ea0:	85ce                	mv	a1,s3
     ea2:	00005517          	auipc	a0,0x5
     ea6:	7be50513          	addi	a0,a0,1982 # 6660 <malloc+0x69a>
     eaa:	00005097          	auipc	ra,0x5
     eae:	064080e7          	jalr	100(ra) # 5f0e <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	cf2080e7          	jalr	-782(ra) # 5ba6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebc:	85ce                	mv	a1,s3
     ebe:	00005517          	auipc	a0,0x5
     ec2:	7c250513          	addi	a0,a0,1986 # 6680 <malloc+0x6ba>
     ec6:	00005097          	auipc	ra,0x5
     eca:	048080e7          	jalr	72(ra) # 5f0e <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	cd6080e7          	jalr	-810(ra) # 5ba6 <exit>
    printf("%s: unlinkread write failed\n", s);
     ed8:	85ce                	mv	a1,s3
     eda:	00005517          	auipc	a0,0x5
     ede:	7c650513          	addi	a0,a0,1990 # 66a0 <malloc+0x6da>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	02c080e7          	jalr	44(ra) # 5f0e <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	cba080e7          	jalr	-838(ra) # 5ba6 <exit>

0000000000000ef4 <linktest>:
{
     ef4:	1101                	addi	sp,sp,-32
     ef6:	ec06                	sd	ra,24(sp)
     ef8:	e822                	sd	s0,16(sp)
     efa:	e426                	sd	s1,8(sp)
     efc:	e04a                	sd	s2,0(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	892a                	mv	s2,a0
  unlink("lf1");
     f02:	00005517          	auipc	a0,0x5
     f06:	7be50513          	addi	a0,a0,1982 # 66c0 <malloc+0x6fa>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	cec080e7          	jalr	-788(ra) # 5bf6 <unlink>
  unlink("lf2");
     f12:	00005517          	auipc	a0,0x5
     f16:	7b650513          	addi	a0,a0,1974 # 66c8 <malloc+0x702>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	cdc080e7          	jalr	-804(ra) # 5bf6 <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     f22:	20200593          	li	a1,514
     f26:	00005517          	auipc	a0,0x5
     f2a:	79a50513          	addi	a0,a0,1946 # 66c0 <malloc+0x6fa>
     f2e:	00005097          	auipc	ra,0x5
     f32:	cb8080e7          	jalr	-840(ra) # 5be6 <open>
  if (fd < 0)
     f36:	10054763          	bltz	a0,1044 <linktest+0x150>
     f3a:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ)
     f3c:	4615                	li	a2,5
     f3e:	00005597          	auipc	a1,0x5
     f42:	6d258593          	addi	a1,a1,1746 # 6610 <malloc+0x64a>
     f46:	00005097          	auipc	ra,0x5
     f4a:	c80080e7          	jalr	-896(ra) # 5bc6 <write>
     f4e:	4795                	li	a5,5
     f50:	10f51863          	bne	a0,a5,1060 <linktest+0x16c>
  close(fd);
     f54:	8526                	mv	a0,s1
     f56:	00005097          	auipc	ra,0x5
     f5a:	c78080e7          	jalr	-904(ra) # 5bce <close>
  if (link("lf1", "lf2") < 0)
     f5e:	00005597          	auipc	a1,0x5
     f62:	76a58593          	addi	a1,a1,1898 # 66c8 <malloc+0x702>
     f66:	00005517          	auipc	a0,0x5
     f6a:	75a50513          	addi	a0,a0,1882 # 66c0 <malloc+0x6fa>
     f6e:	00005097          	auipc	ra,0x5
     f72:	c98080e7          	jalr	-872(ra) # 5c06 <link>
     f76:	10054363          	bltz	a0,107c <linktest+0x188>
  unlink("lf1");
     f7a:	00005517          	auipc	a0,0x5
     f7e:	74650513          	addi	a0,a0,1862 # 66c0 <malloc+0x6fa>
     f82:	00005097          	auipc	ra,0x5
     f86:	c74080e7          	jalr	-908(ra) # 5bf6 <unlink>
  if (open("lf1", 0) >= 0)
     f8a:	4581                	li	a1,0
     f8c:	00005517          	auipc	a0,0x5
     f90:	73450513          	addi	a0,a0,1844 # 66c0 <malloc+0x6fa>
     f94:	00005097          	auipc	ra,0x5
     f98:	c52080e7          	jalr	-942(ra) # 5be6 <open>
     f9c:	0e055e63          	bgez	a0,1098 <linktest+0x1a4>
  fd = open("lf2", 0);
     fa0:	4581                	li	a1,0
     fa2:	00005517          	auipc	a0,0x5
     fa6:	72650513          	addi	a0,a0,1830 # 66c8 <malloc+0x702>
     faa:	00005097          	auipc	ra,0x5
     fae:	c3c080e7          	jalr	-964(ra) # 5be6 <open>
     fb2:	84aa                	mv	s1,a0
  if (fd < 0)
     fb4:	10054063          	bltz	a0,10b4 <linktest+0x1c0>
  if (read(fd, buf, sizeof(buf)) != SZ)
     fb8:	660d                	lui	a2,0x3
     fba:	0000c597          	auipc	a1,0xc
     fbe:	cbe58593          	addi	a1,a1,-834 # cc78 <buf>
     fc2:	00005097          	auipc	ra,0x5
     fc6:	bfc080e7          	jalr	-1028(ra) # 5bbe <read>
     fca:	4795                	li	a5,5
     fcc:	10f51263          	bne	a0,a5,10d0 <linktest+0x1dc>
  close(fd);
     fd0:	8526                	mv	a0,s1
     fd2:	00005097          	auipc	ra,0x5
     fd6:	bfc080e7          	jalr	-1028(ra) # 5bce <close>
  if (link("lf2", "lf2") >= 0)
     fda:	00005597          	auipc	a1,0x5
     fde:	6ee58593          	addi	a1,a1,1774 # 66c8 <malloc+0x702>
     fe2:	852e                	mv	a0,a1
     fe4:	00005097          	auipc	ra,0x5
     fe8:	c22080e7          	jalr	-990(ra) # 5c06 <link>
     fec:	10055063          	bgez	a0,10ec <linktest+0x1f8>
  unlink("lf2");
     ff0:	00005517          	auipc	a0,0x5
     ff4:	6d850513          	addi	a0,a0,1752 # 66c8 <malloc+0x702>
     ff8:	00005097          	auipc	ra,0x5
     ffc:	bfe080e7          	jalr	-1026(ra) # 5bf6 <unlink>
  if (link("lf2", "lf1") >= 0)
    1000:	00005597          	auipc	a1,0x5
    1004:	6c058593          	addi	a1,a1,1728 # 66c0 <malloc+0x6fa>
    1008:	00005517          	auipc	a0,0x5
    100c:	6c050513          	addi	a0,a0,1728 # 66c8 <malloc+0x702>
    1010:	00005097          	auipc	ra,0x5
    1014:	bf6080e7          	jalr	-1034(ra) # 5c06 <link>
    1018:	0e055863          	bgez	a0,1108 <linktest+0x214>
  if (link(".", "lf1") >= 0)
    101c:	00005597          	auipc	a1,0x5
    1020:	6a458593          	addi	a1,a1,1700 # 66c0 <malloc+0x6fa>
    1024:	00005517          	auipc	a0,0x5
    1028:	7ac50513          	addi	a0,a0,1964 # 67d0 <malloc+0x80a>
    102c:	00005097          	auipc	ra,0x5
    1030:	bda080e7          	jalr	-1062(ra) # 5c06 <link>
    1034:	0e055863          	bgez	a0,1124 <linktest+0x230>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	64a2                	ld	s1,8(sp)
    103e:	6902                	ld	s2,0(sp)
    1040:	6105                	addi	sp,sp,32
    1042:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1044:	85ca                	mv	a1,s2
    1046:	00005517          	auipc	a0,0x5
    104a:	68a50513          	addi	a0,a0,1674 # 66d0 <malloc+0x70a>
    104e:	00005097          	auipc	ra,0x5
    1052:	ec0080e7          	jalr	-320(ra) # 5f0e <printf>
    exit(1);
    1056:	4505                	li	a0,1
    1058:	00005097          	auipc	ra,0x5
    105c:	b4e080e7          	jalr	-1202(ra) # 5ba6 <exit>
    printf("%s: write lf1 failed\n", s);
    1060:	85ca                	mv	a1,s2
    1062:	00005517          	auipc	a0,0x5
    1066:	68650513          	addi	a0,a0,1670 # 66e8 <malloc+0x722>
    106a:	00005097          	auipc	ra,0x5
    106e:	ea4080e7          	jalr	-348(ra) # 5f0e <printf>
    exit(1);
    1072:	4505                	li	a0,1
    1074:	00005097          	auipc	ra,0x5
    1078:	b32080e7          	jalr	-1230(ra) # 5ba6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107c:	85ca                	mv	a1,s2
    107e:	00005517          	auipc	a0,0x5
    1082:	68250513          	addi	a0,a0,1666 # 6700 <malloc+0x73a>
    1086:	00005097          	auipc	ra,0x5
    108a:	e88080e7          	jalr	-376(ra) # 5f0e <printf>
    exit(1);
    108e:	4505                	li	a0,1
    1090:	00005097          	auipc	ra,0x5
    1094:	b16080e7          	jalr	-1258(ra) # 5ba6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1098:	85ca                	mv	a1,s2
    109a:	00005517          	auipc	a0,0x5
    109e:	68650513          	addi	a0,a0,1670 # 6720 <malloc+0x75a>
    10a2:	00005097          	auipc	ra,0x5
    10a6:	e6c080e7          	jalr	-404(ra) # 5f0e <printf>
    exit(1);
    10aa:	4505                	li	a0,1
    10ac:	00005097          	auipc	ra,0x5
    10b0:	afa080e7          	jalr	-1286(ra) # 5ba6 <exit>
    printf("%s: open lf2 failed\n", s);
    10b4:	85ca                	mv	a1,s2
    10b6:	00005517          	auipc	a0,0x5
    10ba:	69a50513          	addi	a0,a0,1690 # 6750 <malloc+0x78a>
    10be:	00005097          	auipc	ra,0x5
    10c2:	e50080e7          	jalr	-432(ra) # 5f0e <printf>
    exit(1);
    10c6:	4505                	li	a0,1
    10c8:	00005097          	auipc	ra,0x5
    10cc:	ade080e7          	jalr	-1314(ra) # 5ba6 <exit>
    printf("%s: read lf2 failed\n", s);
    10d0:	85ca                	mv	a1,s2
    10d2:	00005517          	auipc	a0,0x5
    10d6:	69650513          	addi	a0,a0,1686 # 6768 <malloc+0x7a2>
    10da:	00005097          	auipc	ra,0x5
    10de:	e34080e7          	jalr	-460(ra) # 5f0e <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	ac2080e7          	jalr	-1342(ra) # 5ba6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ec:	85ca                	mv	a1,s2
    10ee:	00005517          	auipc	a0,0x5
    10f2:	69250513          	addi	a0,a0,1682 # 6780 <malloc+0x7ba>
    10f6:	00005097          	auipc	ra,0x5
    10fa:	e18080e7          	jalr	-488(ra) # 5f0e <printf>
    exit(1);
    10fe:	4505                	li	a0,1
    1100:	00005097          	auipc	ra,0x5
    1104:	aa6080e7          	jalr	-1370(ra) # 5ba6 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1108:	85ca                	mv	a1,s2
    110a:	00005517          	auipc	a0,0x5
    110e:	69e50513          	addi	a0,a0,1694 # 67a8 <malloc+0x7e2>
    1112:	00005097          	auipc	ra,0x5
    1116:	dfc080e7          	jalr	-516(ra) # 5f0e <printf>
    exit(1);
    111a:	4505                	li	a0,1
    111c:	00005097          	auipc	ra,0x5
    1120:	a8a080e7          	jalr	-1398(ra) # 5ba6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1124:	85ca                	mv	a1,s2
    1126:	00005517          	auipc	a0,0x5
    112a:	6b250513          	addi	a0,a0,1714 # 67d8 <malloc+0x812>
    112e:	00005097          	auipc	ra,0x5
    1132:	de0080e7          	jalr	-544(ra) # 5f0e <printf>
    exit(1);
    1136:	4505                	li	a0,1
    1138:	00005097          	auipc	ra,0x5
    113c:	a6e080e7          	jalr	-1426(ra) # 5ba6 <exit>

0000000000001140 <validatetest>:
{
    1140:	715d                	addi	sp,sp,-80
    1142:	e486                	sd	ra,72(sp)
    1144:	e0a2                	sd	s0,64(sp)
    1146:	fc26                	sd	s1,56(sp)
    1148:	f84a                	sd	s2,48(sp)
    114a:	f44e                	sd	s3,40(sp)
    114c:	f052                	sd	s4,32(sp)
    114e:	ec56                	sd	s5,24(sp)
    1150:	e85a                	sd	s6,16(sp)
    1152:	e45e                	sd	s7,8(sp)
    1154:	0880                	addi	s0,sp,80
    1156:	8baa                	mv	s7,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE)
    1158:	4481                	li	s1,0
    printf("testing arg %p\n", p);
    115a:	00005a17          	auipc	s4,0x5
    115e:	69ea0a13          	addi	s4,s4,1694 # 67f8 <malloc+0x832>
    if (link("nosuchfile", (char *)p) != -1)
    1162:	00005997          	auipc	s3,0x5
    1166:	6a698993          	addi	s3,s3,1702 # 6808 <malloc+0x842>
    116a:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE)
    116c:	6b05                	lui	s6,0x1
    116e:	00114ab7          	lui	s5,0x114
    printf("testing arg %p\n", p);
    1172:	85a6                	mv	a1,s1
    1174:	8552                	mv	a0,s4
    1176:	00005097          	auipc	ra,0x5
    117a:	d98080e7          	jalr	-616(ra) # 5f0e <printf>
    if (link("nosuchfile", (char *)p) != -1)
    117e:	85a6                	mv	a1,s1
    1180:	854e                	mv	a0,s3
    1182:	00005097          	auipc	ra,0x5
    1186:	a84080e7          	jalr	-1404(ra) # 5c06 <link>
    118a:	03251063          	bne	a0,s2,11aa <validatetest+0x6a>
  for (p = 0; p <= (uint)hi; p += PGSIZE)
    118e:	94da                	add	s1,s1,s6
    1190:	ff5491e3          	bne	s1,s5,1172 <validatetest+0x32>
}
    1194:	60a6                	ld	ra,72(sp)
    1196:	6406                	ld	s0,64(sp)
    1198:	74e2                	ld	s1,56(sp)
    119a:	7942                	ld	s2,48(sp)
    119c:	79a2                	ld	s3,40(sp)
    119e:	7a02                	ld	s4,32(sp)
    11a0:	6ae2                	ld	s5,24(sp)
    11a2:	6b42                	ld	s6,16(sp)
    11a4:	6ba2                	ld	s7,8(sp)
    11a6:	6161                	addi	sp,sp,80
    11a8:	8082                	ret
      printf("%s: link should not succeed\n", s);
    11aa:	85de                	mv	a1,s7
    11ac:	00005517          	auipc	a0,0x5
    11b0:	66c50513          	addi	a0,a0,1644 # 6818 <malloc+0x852>
    11b4:	00005097          	auipc	ra,0x5
    11b8:	d5a080e7          	jalr	-678(ra) # 5f0e <printf>
      exit(1);
    11bc:	4505                	li	a0,1
    11be:	00005097          	auipc	ra,0x5
    11c2:	9e8080e7          	jalr	-1560(ra) # 5ba6 <exit>

00000000000011c6 <bigdir>:
{
    11c6:	715d                	addi	sp,sp,-80
    11c8:	e486                	sd	ra,72(sp)
    11ca:	e0a2                	sd	s0,64(sp)
    11cc:	fc26                	sd	s1,56(sp)
    11ce:	f84a                	sd	s2,48(sp)
    11d0:	f44e                	sd	s3,40(sp)
    11d2:	f052                	sd	s4,32(sp)
    11d4:	ec56                	sd	s5,24(sp)
    11d6:	e85a                	sd	s6,16(sp)
    11d8:	0880                	addi	s0,sp,80
    11da:	89aa                	mv	s3,a0
  unlink("bd");
    11dc:	00005517          	auipc	a0,0x5
    11e0:	65c50513          	addi	a0,a0,1628 # 6838 <malloc+0x872>
    11e4:	00005097          	auipc	ra,0x5
    11e8:	a12080e7          	jalr	-1518(ra) # 5bf6 <unlink>
  fd = open("bd", O_CREATE);
    11ec:	20000593          	li	a1,512
    11f0:	00005517          	auipc	a0,0x5
    11f4:	64850513          	addi	a0,a0,1608 # 6838 <malloc+0x872>
    11f8:	00005097          	auipc	ra,0x5
    11fc:	9ee080e7          	jalr	-1554(ra) # 5be6 <open>
  if (fd < 0)
    1200:	0c054963          	bltz	a0,12d2 <bigdir+0x10c>
  close(fd);
    1204:	00005097          	auipc	ra,0x5
    1208:	9ca080e7          	jalr	-1590(ra) # 5bce <close>
  for (i = 0; i < N; i++)
    120c:	4901                	li	s2,0
    name[0] = 'x';
    120e:	07800a93          	li	s5,120
    if (link("bd", name) != 0)
    1212:	00005a17          	auipc	s4,0x5
    1216:	626a0a13          	addi	s4,s4,1574 # 6838 <malloc+0x872>
  for (i = 0; i < N; i++)
    121a:	1f400b13          	li	s6,500
    name[0] = 'x';
    121e:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1222:	41f9571b          	sraiw	a4,s2,0x1f
    1226:	01a7571b          	srliw	a4,a4,0x1a
    122a:	012707bb          	addw	a5,a4,s2
    122e:	4067d69b          	sraiw	a3,a5,0x6
    1232:	0306869b          	addiw	a3,a3,48
    1236:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    123a:	03f7f793          	andi	a5,a5,63
    123e:	9f99                	subw	a5,a5,a4
    1240:	0307879b          	addiw	a5,a5,48
    1244:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1248:	fa0409a3          	sb	zero,-77(s0)
    if (link("bd", name) != 0)
    124c:	fb040593          	addi	a1,s0,-80
    1250:	8552                	mv	a0,s4
    1252:	00005097          	auipc	ra,0x5
    1256:	9b4080e7          	jalr	-1612(ra) # 5c06 <link>
    125a:	84aa                	mv	s1,a0
    125c:	e949                	bnez	a0,12ee <bigdir+0x128>
  for (i = 0; i < N; i++)
    125e:	2905                	addiw	s2,s2,1
    1260:	fb691fe3          	bne	s2,s6,121e <bigdir+0x58>
  unlink("bd");
    1264:	00005517          	auipc	a0,0x5
    1268:	5d450513          	addi	a0,a0,1492 # 6838 <malloc+0x872>
    126c:	00005097          	auipc	ra,0x5
    1270:	98a080e7          	jalr	-1654(ra) # 5bf6 <unlink>
    name[0] = 'x';
    1274:	07800913          	li	s2,120
  for (i = 0; i < N; i++)
    1278:	1f400a13          	li	s4,500
    name[0] = 'x';
    127c:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1280:	41f4d71b          	sraiw	a4,s1,0x1f
    1284:	01a7571b          	srliw	a4,a4,0x1a
    1288:	009707bb          	addw	a5,a4,s1
    128c:	4067d69b          	sraiw	a3,a5,0x6
    1290:	0306869b          	addiw	a3,a3,48
    1294:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1298:	03f7f793          	andi	a5,a5,63
    129c:	9f99                	subw	a5,a5,a4
    129e:	0307879b          	addiw	a5,a5,48
    12a2:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    12a6:	fa0409a3          	sb	zero,-77(s0)
    if (unlink(name) != 0)
    12aa:	fb040513          	addi	a0,s0,-80
    12ae:	00005097          	auipc	ra,0x5
    12b2:	948080e7          	jalr	-1720(ra) # 5bf6 <unlink>
    12b6:	ed21                	bnez	a0,130e <bigdir+0x148>
  for (i = 0; i < N; i++)
    12b8:	2485                	addiw	s1,s1,1
    12ba:	fd4491e3          	bne	s1,s4,127c <bigdir+0xb6>
}
    12be:	60a6                	ld	ra,72(sp)
    12c0:	6406                	ld	s0,64(sp)
    12c2:	74e2                	ld	s1,56(sp)
    12c4:	7942                	ld	s2,48(sp)
    12c6:	79a2                	ld	s3,40(sp)
    12c8:	7a02                	ld	s4,32(sp)
    12ca:	6ae2                	ld	s5,24(sp)
    12cc:	6b42                	ld	s6,16(sp)
    12ce:	6161                	addi	sp,sp,80
    12d0:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12d2:	85ce                	mv	a1,s3
    12d4:	00005517          	auipc	a0,0x5
    12d8:	56c50513          	addi	a0,a0,1388 # 6840 <malloc+0x87a>
    12dc:	00005097          	auipc	ra,0x5
    12e0:	c32080e7          	jalr	-974(ra) # 5f0e <printf>
    exit(1);
    12e4:	4505                	li	a0,1
    12e6:	00005097          	auipc	ra,0x5
    12ea:	8c0080e7          	jalr	-1856(ra) # 5ba6 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12ee:	fb040613          	addi	a2,s0,-80
    12f2:	85ce                	mv	a1,s3
    12f4:	00005517          	auipc	a0,0x5
    12f8:	56c50513          	addi	a0,a0,1388 # 6860 <malloc+0x89a>
    12fc:	00005097          	auipc	ra,0x5
    1300:	c12080e7          	jalr	-1006(ra) # 5f0e <printf>
      exit(1);
    1304:	4505                	li	a0,1
    1306:	00005097          	auipc	ra,0x5
    130a:	8a0080e7          	jalr	-1888(ra) # 5ba6 <exit>
      printf("%s: bigdir unlink failed", s);
    130e:	85ce                	mv	a1,s3
    1310:	00005517          	auipc	a0,0x5
    1314:	57050513          	addi	a0,a0,1392 # 6880 <malloc+0x8ba>
    1318:	00005097          	auipc	ra,0x5
    131c:	bf6080e7          	jalr	-1034(ra) # 5f0e <printf>
      exit(1);
    1320:	4505                	li	a0,1
    1322:	00005097          	auipc	ra,0x5
    1326:	884080e7          	jalr	-1916(ra) # 5ba6 <exit>

000000000000132a <pgbug>:
{
    132a:	7179                	addi	sp,sp,-48
    132c:	f406                	sd	ra,40(sp)
    132e:	f022                	sd	s0,32(sp)
    1330:	ec26                	sd	s1,24(sp)
    1332:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1334:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1338:	00008497          	auipc	s1,0x8
    133c:	cc848493          	addi	s1,s1,-824 # 9000 <big>
    1340:	fd840593          	addi	a1,s0,-40
    1344:	6088                	ld	a0,0(s1)
    1346:	00005097          	auipc	ra,0x5
    134a:	898080e7          	jalr	-1896(ra) # 5bde <exec>
  pipe(big);
    134e:	6088                	ld	a0,0(s1)
    1350:	00005097          	auipc	ra,0x5
    1354:	866080e7          	jalr	-1946(ra) # 5bb6 <pipe>
  exit(0);
    1358:	4501                	li	a0,0
    135a:	00005097          	auipc	ra,0x5
    135e:	84c080e7          	jalr	-1972(ra) # 5ba6 <exit>

0000000000001362 <badarg>:
{
    1362:	7139                	addi	sp,sp,-64
    1364:	fc06                	sd	ra,56(sp)
    1366:	f822                	sd	s0,48(sp)
    1368:	f426                	sd	s1,40(sp)
    136a:	f04a                	sd	s2,32(sp)
    136c:	ec4e                	sd	s3,24(sp)
    136e:	0080                	addi	s0,sp,64
    1370:	64b1                	lui	s1,0xc
    1372:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char *)0xffffffff;
    1376:	597d                	li	s2,-1
    1378:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    137c:	00005997          	auipc	s3,0x5
    1380:	d6c98993          	addi	s3,s3,-660 # 60e8 <malloc+0x122>
    argv[0] = (char *)0xffffffff;
    1384:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1388:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    138c:	fc040593          	addi	a1,s0,-64
    1390:	854e                	mv	a0,s3
    1392:	00005097          	auipc	ra,0x5
    1396:	84c080e7          	jalr	-1972(ra) # 5bde <exec>
  for (int i = 0; i < 50000; i++)
    139a:	34fd                	addiw	s1,s1,-1
    139c:	f4e5                	bnez	s1,1384 <badarg+0x22>
  exit(0);
    139e:	4501                	li	a0,0
    13a0:	00005097          	auipc	ra,0x5
    13a4:	806080e7          	jalr	-2042(ra) # 5ba6 <exit>

00000000000013a8 <copyinstr2>:
{
    13a8:	7155                	addi	sp,sp,-208
    13aa:	e586                	sd	ra,200(sp)
    13ac:	e1a2                	sd	s0,192(sp)
    13ae:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    13b0:	f6840793          	addi	a5,s0,-152
    13b4:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13b8:	07800713          	li	a4,120
    13bc:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    13c0:	0785                	addi	a5,a5,1
    13c2:	fed79de3          	bne	a5,a3,13bc <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13c6:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13ca:	f6840513          	addi	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	828080e7          	jalr	-2008(ra) # 5bf6 <unlink>
  if (ret != -1)
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51063          	bne	a0,a5,14b8 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13dc:	20100593          	li	a1,513
    13e0:	f6840513          	addi	a0,s0,-152
    13e4:	00005097          	auipc	ra,0x5
    13e8:	802080e7          	jalr	-2046(ra) # 5be6 <open>
  if (fd != -1)
    13ec:	57fd                	li	a5,-1
    13ee:	0ef51563          	bne	a0,a5,14d8 <copyinstr2+0x130>
  ret = link(b, b);
    13f2:	f6840593          	addi	a1,s0,-152
    13f6:	852e                	mv	a0,a1
    13f8:	00005097          	auipc	ra,0x5
    13fc:	80e080e7          	jalr	-2034(ra) # 5c06 <link>
  if (ret != -1)
    1400:	57fd                	li	a5,-1
    1402:	0ef51b63          	bne	a0,a5,14f8 <copyinstr2+0x150>
  char *args[] = {"xx", 0};
    1406:	00006797          	auipc	a5,0x6
    140a:	6d278793          	addi	a5,a5,1746 # 7ad8 <malloc+0x1b12>
    140e:	f4f43c23          	sd	a5,-168(s0)
    1412:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1416:	f5840593          	addi	a1,s0,-168
    141a:	f6840513          	addi	a0,s0,-152
    141e:	00004097          	auipc	ra,0x4
    1422:	7c0080e7          	jalr	1984(ra) # 5bde <exec>
  if (ret != -1)
    1426:	57fd                	li	a5,-1
    1428:	0ef51963          	bne	a0,a5,151a <copyinstr2+0x172>
  int pid = fork();
    142c:	00004097          	auipc	ra,0x4
    1430:	772080e7          	jalr	1906(ra) # 5b9e <fork>
  if (pid < 0)
    1434:	10054363          	bltz	a0,153a <copyinstr2+0x192>
  if (pid == 0)
    1438:	12051463          	bnez	a0,1560 <copyinstr2+0x1b8>
    143c:	00008797          	auipc	a5,0x8
    1440:	12478793          	addi	a5,a5,292 # 9560 <big.0>
    1444:	00009697          	auipc	a3,0x9
    1448:	11c68693          	addi	a3,a3,284 # a560 <big.0+0x1000>
      big[i] = 'x';
    144c:	07800713          	li	a4,120
    1450:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1454:	0785                	addi	a5,a5,1
    1456:	fed79de3          	bne	a5,a3,1450 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    145a:	00009797          	auipc	a5,0x9
    145e:	10078323          	sb	zero,262(a5) # a560 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1462:	00007797          	auipc	a5,0x7
    1466:	0b678793          	addi	a5,a5,182 # 8518 <malloc+0x2552>
    146a:	6390                	ld	a2,0(a5)
    146c:	6794                	ld	a3,8(a5)
    146e:	6b98                	ld	a4,16(a5)
    1470:	6f9c                	ld	a5,24(a5)
    1472:	f2c43823          	sd	a2,-208(s0)
    1476:	f2d43c23          	sd	a3,-200(s0)
    147a:	f4e43023          	sd	a4,-192(s0)
    147e:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1482:	f3040593          	addi	a1,s0,-208
    1486:	00005517          	auipc	a0,0x5
    148a:	c6250513          	addi	a0,a0,-926 # 60e8 <malloc+0x122>
    148e:	00004097          	auipc	ra,0x4
    1492:	750080e7          	jalr	1872(ra) # 5bde <exec>
    if (ret != -1)
    1496:	57fd                	li	a5,-1
    1498:	0af50e63          	beq	a0,a5,1554 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    149c:	55fd                	li	a1,-1
    149e:	00005517          	auipc	a0,0x5
    14a2:	48a50513          	addi	a0,a0,1162 # 6928 <malloc+0x962>
    14a6:	00005097          	auipc	ra,0x5
    14aa:	a68080e7          	jalr	-1432(ra) # 5f0e <printf>
      exit(1);
    14ae:	4505                	li	a0,1
    14b0:	00004097          	auipc	ra,0x4
    14b4:	6f6080e7          	jalr	1782(ra) # 5ba6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14b8:	862a                	mv	a2,a0
    14ba:	f6840593          	addi	a1,s0,-152
    14be:	00005517          	auipc	a0,0x5
    14c2:	3e250513          	addi	a0,a0,994 # 68a0 <malloc+0x8da>
    14c6:	00005097          	auipc	ra,0x5
    14ca:	a48080e7          	jalr	-1464(ra) # 5f0e <printf>
    exit(1);
    14ce:	4505                	li	a0,1
    14d0:	00004097          	auipc	ra,0x4
    14d4:	6d6080e7          	jalr	1750(ra) # 5ba6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14d8:	862a                	mv	a2,a0
    14da:	f6840593          	addi	a1,s0,-152
    14de:	00005517          	auipc	a0,0x5
    14e2:	3e250513          	addi	a0,a0,994 # 68c0 <malloc+0x8fa>
    14e6:	00005097          	auipc	ra,0x5
    14ea:	a28080e7          	jalr	-1496(ra) # 5f0e <printf>
    exit(1);
    14ee:	4505                	li	a0,1
    14f0:	00004097          	auipc	ra,0x4
    14f4:	6b6080e7          	jalr	1718(ra) # 5ba6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14f8:	86aa                	mv	a3,a0
    14fa:	f6840613          	addi	a2,s0,-152
    14fe:	85b2                	mv	a1,a2
    1500:	00005517          	auipc	a0,0x5
    1504:	3e050513          	addi	a0,a0,992 # 68e0 <malloc+0x91a>
    1508:	00005097          	auipc	ra,0x5
    150c:	a06080e7          	jalr	-1530(ra) # 5f0e <printf>
    exit(1);
    1510:	4505                	li	a0,1
    1512:	00004097          	auipc	ra,0x4
    1516:	694080e7          	jalr	1684(ra) # 5ba6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    151a:	567d                	li	a2,-1
    151c:	f6840593          	addi	a1,s0,-152
    1520:	00005517          	auipc	a0,0x5
    1524:	3e850513          	addi	a0,a0,1000 # 6908 <malloc+0x942>
    1528:	00005097          	auipc	ra,0x5
    152c:	9e6080e7          	jalr	-1562(ra) # 5f0e <printf>
    exit(1);
    1530:	4505                	li	a0,1
    1532:	00004097          	auipc	ra,0x4
    1536:	674080e7          	jalr	1652(ra) # 5ba6 <exit>
    printf("fork failed\n");
    153a:	00006517          	auipc	a0,0x6
    153e:	84e50513          	addi	a0,a0,-1970 # 6d88 <malloc+0xdc2>
    1542:	00005097          	auipc	ra,0x5
    1546:	9cc080e7          	jalr	-1588(ra) # 5f0e <printf>
    exit(1);
    154a:	4505                	li	a0,1
    154c:	00004097          	auipc	ra,0x4
    1550:	65a080e7          	jalr	1626(ra) # 5ba6 <exit>
    exit(747); // OK
    1554:	2eb00513          	li	a0,747
    1558:	00004097          	auipc	ra,0x4
    155c:	64e080e7          	jalr	1614(ra) # 5ba6 <exit>
  int st = 0;
    1560:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1564:	f5440513          	addi	a0,s0,-172
    1568:	00004097          	auipc	ra,0x4
    156c:	646080e7          	jalr	1606(ra) # 5bae <wait>
  if (st != 747)
    1570:	f5442703          	lw	a4,-172(s0)
    1574:	2eb00793          	li	a5,747
    1578:	00f71663          	bne	a4,a5,1584 <copyinstr2+0x1dc>
}
    157c:	60ae                	ld	ra,200(sp)
    157e:	640e                	ld	s0,192(sp)
    1580:	6169                	addi	sp,sp,208
    1582:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1584:	00005517          	auipc	a0,0x5
    1588:	3cc50513          	addi	a0,a0,972 # 6950 <malloc+0x98a>
    158c:	00005097          	auipc	ra,0x5
    1590:	982080e7          	jalr	-1662(ra) # 5f0e <printf>
    exit(1);
    1594:	4505                	li	a0,1
    1596:	00004097          	auipc	ra,0x4
    159a:	610080e7          	jalr	1552(ra) # 5ba6 <exit>

000000000000159e <truncate3>:
{
    159e:	7159                	addi	sp,sp,-112
    15a0:	f486                	sd	ra,104(sp)
    15a2:	f0a2                	sd	s0,96(sp)
    15a4:	eca6                	sd	s1,88(sp)
    15a6:	e8ca                	sd	s2,80(sp)
    15a8:	e4ce                	sd	s3,72(sp)
    15aa:	e0d2                	sd	s4,64(sp)
    15ac:	fc56                	sd	s5,56(sp)
    15ae:	1880                	addi	s0,sp,112
    15b0:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    15b2:	60100593          	li	a1,1537
    15b6:	00005517          	auipc	a0,0x5
    15ba:	b8a50513          	addi	a0,a0,-1142 # 6140 <malloc+0x17a>
    15be:	00004097          	auipc	ra,0x4
    15c2:	628080e7          	jalr	1576(ra) # 5be6 <open>
    15c6:	00004097          	auipc	ra,0x4
    15ca:	608080e7          	jalr	1544(ra) # 5bce <close>
  pid = fork();
    15ce:	00004097          	auipc	ra,0x4
    15d2:	5d0080e7          	jalr	1488(ra) # 5b9e <fork>
  if (pid < 0)
    15d6:	08054063          	bltz	a0,1656 <truncate3+0xb8>
  if (pid == 0)
    15da:	e969                	bnez	a0,16ac <truncate3+0x10e>
    15dc:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15e0:	00005a17          	auipc	s4,0x5
    15e4:	b60a0a13          	addi	s4,s4,-1184 # 6140 <malloc+0x17a>
      int n = write(fd, "1234567890", 10);
    15e8:	00005a97          	auipc	s5,0x5
    15ec:	3c8a8a93          	addi	s5,s5,968 # 69b0 <malloc+0x9ea>
      int fd = open("truncfile", O_WRONLY);
    15f0:	4585                	li	a1,1
    15f2:	8552                	mv	a0,s4
    15f4:	00004097          	auipc	ra,0x4
    15f8:	5f2080e7          	jalr	1522(ra) # 5be6 <open>
    15fc:	84aa                	mv	s1,a0
      if (fd < 0)
    15fe:	06054a63          	bltz	a0,1672 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1602:	4629                	li	a2,10
    1604:	85d6                	mv	a1,s5
    1606:	00004097          	auipc	ra,0x4
    160a:	5c0080e7          	jalr	1472(ra) # 5bc6 <write>
      if (n != 10)
    160e:	47a9                	li	a5,10
    1610:	06f51f63          	bne	a0,a5,168e <truncate3+0xf0>
      close(fd);
    1614:	8526                	mv	a0,s1
    1616:	00004097          	auipc	ra,0x4
    161a:	5b8080e7          	jalr	1464(ra) # 5bce <close>
      fd = open("truncfile", O_RDONLY);
    161e:	4581                	li	a1,0
    1620:	8552                	mv	a0,s4
    1622:	00004097          	auipc	ra,0x4
    1626:	5c4080e7          	jalr	1476(ra) # 5be6 <open>
    162a:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    162c:	02000613          	li	a2,32
    1630:	f9840593          	addi	a1,s0,-104
    1634:	00004097          	auipc	ra,0x4
    1638:	58a080e7          	jalr	1418(ra) # 5bbe <read>
      close(fd);
    163c:	8526                	mv	a0,s1
    163e:	00004097          	auipc	ra,0x4
    1642:	590080e7          	jalr	1424(ra) # 5bce <close>
    for (int i = 0; i < 100; i++)
    1646:	39fd                	addiw	s3,s3,-1
    1648:	fa0994e3          	bnez	s3,15f0 <truncate3+0x52>
    exit(0);
    164c:	4501                	li	a0,0
    164e:	00004097          	auipc	ra,0x4
    1652:	558080e7          	jalr	1368(ra) # 5ba6 <exit>
    printf("%s: fork failed\n", s);
    1656:	85ca                	mv	a1,s2
    1658:	00005517          	auipc	a0,0x5
    165c:	32850513          	addi	a0,a0,808 # 6980 <malloc+0x9ba>
    1660:	00005097          	auipc	ra,0x5
    1664:	8ae080e7          	jalr	-1874(ra) # 5f0e <printf>
    exit(1);
    1668:	4505                	li	a0,1
    166a:	00004097          	auipc	ra,0x4
    166e:	53c080e7          	jalr	1340(ra) # 5ba6 <exit>
        printf("%s: open failed\n", s);
    1672:	85ca                	mv	a1,s2
    1674:	00005517          	auipc	a0,0x5
    1678:	32450513          	addi	a0,a0,804 # 6998 <malloc+0x9d2>
    167c:	00005097          	auipc	ra,0x5
    1680:	892080e7          	jalr	-1902(ra) # 5f0e <printf>
        exit(1);
    1684:	4505                	li	a0,1
    1686:	00004097          	auipc	ra,0x4
    168a:	520080e7          	jalr	1312(ra) # 5ba6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    168e:	862a                	mv	a2,a0
    1690:	85ca                	mv	a1,s2
    1692:	00005517          	auipc	a0,0x5
    1696:	32e50513          	addi	a0,a0,814 # 69c0 <malloc+0x9fa>
    169a:	00005097          	auipc	ra,0x5
    169e:	874080e7          	jalr	-1932(ra) # 5f0e <printf>
        exit(1);
    16a2:	4505                	li	a0,1
    16a4:	00004097          	auipc	ra,0x4
    16a8:	502080e7          	jalr	1282(ra) # 5ba6 <exit>
    16ac:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    16b0:	00005a17          	auipc	s4,0x5
    16b4:	a90a0a13          	addi	s4,s4,-1392 # 6140 <malloc+0x17a>
    int n = write(fd, "xxx", 3);
    16b8:	00005a97          	auipc	s5,0x5
    16bc:	328a8a93          	addi	s5,s5,808 # 69e0 <malloc+0xa1a>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    16c0:	60100593          	li	a1,1537
    16c4:	8552                	mv	a0,s4
    16c6:	00004097          	auipc	ra,0x4
    16ca:	520080e7          	jalr	1312(ra) # 5be6 <open>
    16ce:	84aa                	mv	s1,a0
    if (fd < 0)
    16d0:	04054763          	bltz	a0,171e <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16d4:	460d                	li	a2,3
    16d6:	85d6                	mv	a1,s5
    16d8:	00004097          	auipc	ra,0x4
    16dc:	4ee080e7          	jalr	1262(ra) # 5bc6 <write>
    if (n != 3)
    16e0:	478d                	li	a5,3
    16e2:	04f51c63          	bne	a0,a5,173a <truncate3+0x19c>
    close(fd);
    16e6:	8526                	mv	a0,s1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	4e6080e7          	jalr	1254(ra) # 5bce <close>
  for (int i = 0; i < 150; i++)
    16f0:	39fd                	addiw	s3,s3,-1
    16f2:	fc0997e3          	bnez	s3,16c0 <truncate3+0x122>
  wait(&xstatus);
    16f6:	fbc40513          	addi	a0,s0,-68
    16fa:	00004097          	auipc	ra,0x4
    16fe:	4b4080e7          	jalr	1204(ra) # 5bae <wait>
  unlink("truncfile");
    1702:	00005517          	auipc	a0,0x5
    1706:	a3e50513          	addi	a0,a0,-1474 # 6140 <malloc+0x17a>
    170a:	00004097          	auipc	ra,0x4
    170e:	4ec080e7          	jalr	1260(ra) # 5bf6 <unlink>
  exit(xstatus);
    1712:	fbc42503          	lw	a0,-68(s0)
    1716:	00004097          	auipc	ra,0x4
    171a:	490080e7          	jalr	1168(ra) # 5ba6 <exit>
      printf("%s: open failed\n", s);
    171e:	85ca                	mv	a1,s2
    1720:	00005517          	auipc	a0,0x5
    1724:	27850513          	addi	a0,a0,632 # 6998 <malloc+0x9d2>
    1728:	00004097          	auipc	ra,0x4
    172c:	7e6080e7          	jalr	2022(ra) # 5f0e <printf>
      exit(1);
    1730:	4505                	li	a0,1
    1732:	00004097          	auipc	ra,0x4
    1736:	474080e7          	jalr	1140(ra) # 5ba6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    173a:	862a                	mv	a2,a0
    173c:	85ca                	mv	a1,s2
    173e:	00005517          	auipc	a0,0x5
    1742:	2aa50513          	addi	a0,a0,682 # 69e8 <malloc+0xa22>
    1746:	00004097          	auipc	ra,0x4
    174a:	7c8080e7          	jalr	1992(ra) # 5f0e <printf>
      exit(1);
    174e:	4505                	li	a0,1
    1750:	00004097          	auipc	ra,0x4
    1754:	456080e7          	jalr	1110(ra) # 5ba6 <exit>

0000000000001758 <exectest>:
{
    1758:	715d                	addi	sp,sp,-80
    175a:	e486                	sd	ra,72(sp)
    175c:	e0a2                	sd	s0,64(sp)
    175e:	fc26                	sd	s1,56(sp)
    1760:	f84a                	sd	s2,48(sp)
    1762:	0880                	addi	s0,sp,80
    1764:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    1766:	00005797          	auipc	a5,0x5
    176a:	98278793          	addi	a5,a5,-1662 # 60e8 <malloc+0x122>
    176e:	fcf43023          	sd	a5,-64(s0)
    1772:	00005797          	auipc	a5,0x5
    1776:	29678793          	addi	a5,a5,662 # 6a08 <malloc+0xa42>
    177a:	fcf43423          	sd	a5,-56(s0)
    177e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1782:	00005517          	auipc	a0,0x5
    1786:	28e50513          	addi	a0,a0,654 # 6a10 <malloc+0xa4a>
    178a:	00004097          	auipc	ra,0x4
    178e:	46c080e7          	jalr	1132(ra) # 5bf6 <unlink>
  pid = fork();
    1792:	00004097          	auipc	ra,0x4
    1796:	40c080e7          	jalr	1036(ra) # 5b9e <fork>
  if (pid < 0)
    179a:	04054663          	bltz	a0,17e6 <exectest+0x8e>
    179e:	84aa                	mv	s1,a0
  if (pid == 0)
    17a0:	e959                	bnez	a0,1836 <exectest+0xde>
    close(1);
    17a2:	4505                	li	a0,1
    17a4:	00004097          	auipc	ra,0x4
    17a8:	42a080e7          	jalr	1066(ra) # 5bce <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    17ac:	20100593          	li	a1,513
    17b0:	00005517          	auipc	a0,0x5
    17b4:	26050513          	addi	a0,a0,608 # 6a10 <malloc+0xa4a>
    17b8:	00004097          	auipc	ra,0x4
    17bc:	42e080e7          	jalr	1070(ra) # 5be6 <open>
    if (fd < 0)
    17c0:	04054163          	bltz	a0,1802 <exectest+0xaa>
    if (fd != 1)
    17c4:	4785                	li	a5,1
    17c6:	04f50c63          	beq	a0,a5,181e <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17ca:	85ca                	mv	a1,s2
    17cc:	00005517          	auipc	a0,0x5
    17d0:	26450513          	addi	a0,a0,612 # 6a30 <malloc+0xa6a>
    17d4:	00004097          	auipc	ra,0x4
    17d8:	73a080e7          	jalr	1850(ra) # 5f0e <printf>
      exit(1);
    17dc:	4505                	li	a0,1
    17de:	00004097          	auipc	ra,0x4
    17e2:	3c8080e7          	jalr	968(ra) # 5ba6 <exit>
    printf("%s: fork failed\n", s);
    17e6:	85ca                	mv	a1,s2
    17e8:	00005517          	auipc	a0,0x5
    17ec:	19850513          	addi	a0,a0,408 # 6980 <malloc+0x9ba>
    17f0:	00004097          	auipc	ra,0x4
    17f4:	71e080e7          	jalr	1822(ra) # 5f0e <printf>
    exit(1);
    17f8:	4505                	li	a0,1
    17fa:	00004097          	auipc	ra,0x4
    17fe:	3ac080e7          	jalr	940(ra) # 5ba6 <exit>
      printf("%s: create failed\n", s);
    1802:	85ca                	mv	a1,s2
    1804:	00005517          	auipc	a0,0x5
    1808:	21450513          	addi	a0,a0,532 # 6a18 <malloc+0xa52>
    180c:	00004097          	auipc	ra,0x4
    1810:	702080e7          	jalr	1794(ra) # 5f0e <printf>
      exit(1);
    1814:	4505                	li	a0,1
    1816:	00004097          	auipc	ra,0x4
    181a:	390080e7          	jalr	912(ra) # 5ba6 <exit>
    if (exec("echo", echoargv) < 0)
    181e:	fc040593          	addi	a1,s0,-64
    1822:	00005517          	auipc	a0,0x5
    1826:	8c650513          	addi	a0,a0,-1850 # 60e8 <malloc+0x122>
    182a:	00004097          	auipc	ra,0x4
    182e:	3b4080e7          	jalr	948(ra) # 5bde <exec>
    1832:	02054163          	bltz	a0,1854 <exectest+0xfc>
  if (wait(&xstatus) != pid)
    1836:	fdc40513          	addi	a0,s0,-36
    183a:	00004097          	auipc	ra,0x4
    183e:	374080e7          	jalr	884(ra) # 5bae <wait>
    1842:	02951763          	bne	a0,s1,1870 <exectest+0x118>
  if (xstatus != 0)
    1846:	fdc42503          	lw	a0,-36(s0)
    184a:	cd0d                	beqz	a0,1884 <exectest+0x12c>
    exit(xstatus);
    184c:	00004097          	auipc	ra,0x4
    1850:	35a080e7          	jalr	858(ra) # 5ba6 <exit>
      printf("%s: exec echo failed\n", s);
    1854:	85ca                	mv	a1,s2
    1856:	00005517          	auipc	a0,0x5
    185a:	1ea50513          	addi	a0,a0,490 # 6a40 <malloc+0xa7a>
    185e:	00004097          	auipc	ra,0x4
    1862:	6b0080e7          	jalr	1712(ra) # 5f0e <printf>
      exit(1);
    1866:	4505                	li	a0,1
    1868:	00004097          	auipc	ra,0x4
    186c:	33e080e7          	jalr	830(ra) # 5ba6 <exit>
    printf("%s: wait failed!\n", s);
    1870:	85ca                	mv	a1,s2
    1872:	00005517          	auipc	a0,0x5
    1876:	1e650513          	addi	a0,a0,486 # 6a58 <malloc+0xa92>
    187a:	00004097          	auipc	ra,0x4
    187e:	694080e7          	jalr	1684(ra) # 5f0e <printf>
    1882:	b7d1                	j	1846 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1884:	4581                	li	a1,0
    1886:	00005517          	auipc	a0,0x5
    188a:	18a50513          	addi	a0,a0,394 # 6a10 <malloc+0xa4a>
    188e:	00004097          	auipc	ra,0x4
    1892:	358080e7          	jalr	856(ra) # 5be6 <open>
  if (fd < 0)
    1896:	02054a63          	bltz	a0,18ca <exectest+0x172>
  if (read(fd, buf, 2) != 2)
    189a:	4609                	li	a2,2
    189c:	fb840593          	addi	a1,s0,-72
    18a0:	00004097          	auipc	ra,0x4
    18a4:	31e080e7          	jalr	798(ra) # 5bbe <read>
    18a8:	4789                	li	a5,2
    18aa:	02f50e63          	beq	a0,a5,18e6 <exectest+0x18e>
    printf("%s: read failed\n", s);
    18ae:	85ca                	mv	a1,s2
    18b0:	00005517          	auipc	a0,0x5
    18b4:	c0850513          	addi	a0,a0,-1016 # 64b8 <malloc+0x4f2>
    18b8:	00004097          	auipc	ra,0x4
    18bc:	656080e7          	jalr	1622(ra) # 5f0e <printf>
    exit(1);
    18c0:	4505                	li	a0,1
    18c2:	00004097          	auipc	ra,0x4
    18c6:	2e4080e7          	jalr	740(ra) # 5ba6 <exit>
    printf("%s: open failed\n", s);
    18ca:	85ca                	mv	a1,s2
    18cc:	00005517          	auipc	a0,0x5
    18d0:	0cc50513          	addi	a0,a0,204 # 6998 <malloc+0x9d2>
    18d4:	00004097          	auipc	ra,0x4
    18d8:	63a080e7          	jalr	1594(ra) # 5f0e <printf>
    exit(1);
    18dc:	4505                	li	a0,1
    18de:	00004097          	auipc	ra,0x4
    18e2:	2c8080e7          	jalr	712(ra) # 5ba6 <exit>
  unlink("echo-ok");
    18e6:	00005517          	auipc	a0,0x5
    18ea:	12a50513          	addi	a0,a0,298 # 6a10 <malloc+0xa4a>
    18ee:	00004097          	auipc	ra,0x4
    18f2:	308080e7          	jalr	776(ra) # 5bf6 <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    18f6:	fb844703          	lbu	a4,-72(s0)
    18fa:	04f00793          	li	a5,79
    18fe:	00f71863          	bne	a4,a5,190e <exectest+0x1b6>
    1902:	fb944703          	lbu	a4,-71(s0)
    1906:	04b00793          	li	a5,75
    190a:	02f70063          	beq	a4,a5,192a <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    190e:	85ca                	mv	a1,s2
    1910:	00005517          	auipc	a0,0x5
    1914:	16050513          	addi	a0,a0,352 # 6a70 <malloc+0xaaa>
    1918:	00004097          	auipc	ra,0x4
    191c:	5f6080e7          	jalr	1526(ra) # 5f0e <printf>
    exit(1);
    1920:	4505                	li	a0,1
    1922:	00004097          	auipc	ra,0x4
    1926:	284080e7          	jalr	644(ra) # 5ba6 <exit>
    exit(0);
    192a:	4501                	li	a0,0
    192c:	00004097          	auipc	ra,0x4
    1930:	27a080e7          	jalr	634(ra) # 5ba6 <exit>

0000000000001934 <pipe1>:
{
    1934:	711d                	addi	sp,sp,-96
    1936:	ec86                	sd	ra,88(sp)
    1938:	e8a2                	sd	s0,80(sp)
    193a:	e4a6                	sd	s1,72(sp)
    193c:	e0ca                	sd	s2,64(sp)
    193e:	fc4e                	sd	s3,56(sp)
    1940:	f852                	sd	s4,48(sp)
    1942:	f456                	sd	s5,40(sp)
    1944:	f05a                	sd	s6,32(sp)
    1946:	ec5e                	sd	s7,24(sp)
    1948:	1080                	addi	s0,sp,96
    194a:	892a                	mv	s2,a0
  if (pipe(fds) != 0)
    194c:	fa840513          	addi	a0,s0,-88
    1950:	00004097          	auipc	ra,0x4
    1954:	266080e7          	jalr	614(ra) # 5bb6 <pipe>
    1958:	e93d                	bnez	a0,19ce <pipe1+0x9a>
    195a:	84aa                	mv	s1,a0
  pid = fork();
    195c:	00004097          	auipc	ra,0x4
    1960:	242080e7          	jalr	578(ra) # 5b9e <fork>
    1964:	8a2a                	mv	s4,a0
  if (pid == 0)
    1966:	c151                	beqz	a0,19ea <pipe1+0xb6>
  else if (pid > 0)
    1968:	16a05d63          	blez	a0,1ae2 <pipe1+0x1ae>
    close(fds[1]);
    196c:	fac42503          	lw	a0,-84(s0)
    1970:	00004097          	auipc	ra,0x4
    1974:	25e080e7          	jalr	606(ra) # 5bce <close>
    total = 0;
    1978:	8a26                	mv	s4,s1
    cc = 1;
    197a:	4985                	li	s3,1
    while ((n = read(fds[0], buf, cc)) > 0)
    197c:	0000ba97          	auipc	s5,0xb
    1980:	2fca8a93          	addi	s5,s5,764 # cc78 <buf>
    1984:	864e                	mv	a2,s3
    1986:	85d6                	mv	a1,s5
    1988:	fa842503          	lw	a0,-88(s0)
    198c:	00004097          	auipc	ra,0x4
    1990:	232080e7          	jalr	562(ra) # 5bbe <read>
    1994:	10a05263          	blez	a0,1a98 <pipe1+0x164>
      for (i = 0; i < n; i++)
    1998:	0000b717          	auipc	a4,0xb
    199c:	2e070713          	addi	a4,a4,736 # cc78 <buf>
    19a0:	00a4863b          	addw	a2,s1,a0
        if ((buf[i] & 0xff) != (seq++ & 0xff))
    19a4:	00074683          	lbu	a3,0(a4)
    19a8:	0ff4f793          	zext.b	a5,s1
    19ac:	2485                	addiw	s1,s1,1
    19ae:	0cf69163          	bne	a3,a5,1a70 <pipe1+0x13c>
      for (i = 0; i < n; i++)
    19b2:	0705                	addi	a4,a4,1
    19b4:	fec498e3          	bne	s1,a2,19a4 <pipe1+0x70>
      total += n;
    19b8:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19bc:	0019979b          	slliw	a5,s3,0x1
    19c0:	0007899b          	sext.w	s3,a5
      if (cc > sizeof(buf))
    19c4:	670d                	lui	a4,0x3
    19c6:	fb377fe3          	bgeu	a4,s3,1984 <pipe1+0x50>
        cc = sizeof(buf);
    19ca:	698d                	lui	s3,0x3
    19cc:	bf65                	j	1984 <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    19ce:	85ca                	mv	a1,s2
    19d0:	00005517          	auipc	a0,0x5
    19d4:	0b850513          	addi	a0,a0,184 # 6a88 <malloc+0xac2>
    19d8:	00004097          	auipc	ra,0x4
    19dc:	536080e7          	jalr	1334(ra) # 5f0e <printf>
    exit(1);
    19e0:	4505                	li	a0,1
    19e2:	00004097          	auipc	ra,0x4
    19e6:	1c4080e7          	jalr	452(ra) # 5ba6 <exit>
    close(fds[0]);
    19ea:	fa842503          	lw	a0,-88(s0)
    19ee:	00004097          	auipc	ra,0x4
    19f2:	1e0080e7          	jalr	480(ra) # 5bce <close>
    for (n = 0; n < N; n++)
    19f6:	0000bb17          	auipc	s6,0xb
    19fa:	282b0b13          	addi	s6,s6,642 # cc78 <buf>
    19fe:	416004bb          	negw	s1,s6
    1a02:	0ff4f493          	zext.b	s1,s1
    1a06:	409b0993          	addi	s3,s6,1033
      if (write(fds[1], buf, SZ) != SZ)
    1a0a:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++)
    1a0c:	6a85                	lui	s5,0x1
    1a0e:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x85>
{
    1a12:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a14:	0097873b          	addw	a4,a5,s1
    1a18:	00e78023          	sb	a4,0(a5)
      for (i = 0; i < SZ; i++)
    1a1c:	0785                	addi	a5,a5,1
    1a1e:	fef99be3          	bne	s3,a5,1a14 <pipe1+0xe0>
        buf[i] = seq++;
    1a22:	409a0a1b          	addiw	s4,s4,1033
      if (write(fds[1], buf, SZ) != SZ)
    1a26:	40900613          	li	a2,1033
    1a2a:	85de                	mv	a1,s7
    1a2c:	fac42503          	lw	a0,-84(s0)
    1a30:	00004097          	auipc	ra,0x4
    1a34:	196080e7          	jalr	406(ra) # 5bc6 <write>
    1a38:	40900793          	li	a5,1033
    1a3c:	00f51c63          	bne	a0,a5,1a54 <pipe1+0x120>
    for (n = 0; n < N; n++)
    1a40:	24a5                	addiw	s1,s1,9
    1a42:	0ff4f493          	zext.b	s1,s1
    1a46:	fd5a16e3          	bne	s4,s5,1a12 <pipe1+0xde>
    exit(0);
    1a4a:	4501                	li	a0,0
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	15a080e7          	jalr	346(ra) # 5ba6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a54:	85ca                	mv	a1,s2
    1a56:	00005517          	auipc	a0,0x5
    1a5a:	04a50513          	addi	a0,a0,74 # 6aa0 <malloc+0xada>
    1a5e:	00004097          	auipc	ra,0x4
    1a62:	4b0080e7          	jalr	1200(ra) # 5f0e <printf>
        exit(1);
    1a66:	4505                	li	a0,1
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	13e080e7          	jalr	318(ra) # 5ba6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a70:	85ca                	mv	a1,s2
    1a72:	00005517          	auipc	a0,0x5
    1a76:	04650513          	addi	a0,a0,70 # 6ab8 <malloc+0xaf2>
    1a7a:	00004097          	auipc	ra,0x4
    1a7e:	494080e7          	jalr	1172(ra) # 5f0e <printf>
}
    1a82:	60e6                	ld	ra,88(sp)
    1a84:	6446                	ld	s0,80(sp)
    1a86:	64a6                	ld	s1,72(sp)
    1a88:	6906                	ld	s2,64(sp)
    1a8a:	79e2                	ld	s3,56(sp)
    1a8c:	7a42                	ld	s4,48(sp)
    1a8e:	7aa2                	ld	s5,40(sp)
    1a90:	7b02                	ld	s6,32(sp)
    1a92:	6be2                	ld	s7,24(sp)
    1a94:	6125                	addi	sp,sp,96
    1a96:	8082                	ret
    if (total != N * SZ)
    1a98:	6785                	lui	a5,0x1
    1a9a:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x85>
    1a9e:	02fa0063          	beq	s4,a5,1abe <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1aa2:	85d2                	mv	a1,s4
    1aa4:	00005517          	auipc	a0,0x5
    1aa8:	02c50513          	addi	a0,a0,44 # 6ad0 <malloc+0xb0a>
    1aac:	00004097          	auipc	ra,0x4
    1ab0:	462080e7          	jalr	1122(ra) # 5f0e <printf>
      exit(1);
    1ab4:	4505                	li	a0,1
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	0f0080e7          	jalr	240(ra) # 5ba6 <exit>
    close(fds[0]);
    1abe:	fa842503          	lw	a0,-88(s0)
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	10c080e7          	jalr	268(ra) # 5bce <close>
    wait(&xstatus);
    1aca:	fa440513          	addi	a0,s0,-92
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	0e0080e7          	jalr	224(ra) # 5bae <wait>
    exit(xstatus);
    1ad6:	fa442503          	lw	a0,-92(s0)
    1ada:	00004097          	auipc	ra,0x4
    1ade:	0cc080e7          	jalr	204(ra) # 5ba6 <exit>
    printf("%s: fork() failed\n", s);
    1ae2:	85ca                	mv	a1,s2
    1ae4:	00005517          	auipc	a0,0x5
    1ae8:	00c50513          	addi	a0,a0,12 # 6af0 <malloc+0xb2a>
    1aec:	00004097          	auipc	ra,0x4
    1af0:	422080e7          	jalr	1058(ra) # 5f0e <printf>
    exit(1);
    1af4:	4505                	li	a0,1
    1af6:	00004097          	auipc	ra,0x4
    1afa:	0b0080e7          	jalr	176(ra) # 5ba6 <exit>

0000000000001afe <exitwait>:
{
    1afe:	7139                	addi	sp,sp,-64
    1b00:	fc06                	sd	ra,56(sp)
    1b02:	f822                	sd	s0,48(sp)
    1b04:	f426                	sd	s1,40(sp)
    1b06:	f04a                	sd	s2,32(sp)
    1b08:	ec4e                	sd	s3,24(sp)
    1b0a:	e852                	sd	s4,16(sp)
    1b0c:	0080                	addi	s0,sp,64
    1b0e:	8a2a                	mv	s4,a0
  for (i = 0; i < 100; i++)
    1b10:	4901                	li	s2,0
    1b12:	06400993          	li	s3,100
    pid = fork();
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	088080e7          	jalr	136(ra) # 5b9e <fork>
    1b1e:	84aa                	mv	s1,a0
    if (pid < 0)
    1b20:	02054a63          	bltz	a0,1b54 <exitwait+0x56>
    if (pid)
    1b24:	c151                	beqz	a0,1ba8 <exitwait+0xaa>
      if (wait(&xstate) != pid)
    1b26:	fcc40513          	addi	a0,s0,-52
    1b2a:	00004097          	auipc	ra,0x4
    1b2e:	084080e7          	jalr	132(ra) # 5bae <wait>
    1b32:	02951f63          	bne	a0,s1,1b70 <exitwait+0x72>
      if (i != xstate)
    1b36:	fcc42783          	lw	a5,-52(s0)
    1b3a:	05279963          	bne	a5,s2,1b8c <exitwait+0x8e>
  for (i = 0; i < 100; i++)
    1b3e:	2905                	addiw	s2,s2,1
    1b40:	fd391be3          	bne	s2,s3,1b16 <exitwait+0x18>
}
    1b44:	70e2                	ld	ra,56(sp)
    1b46:	7442                	ld	s0,48(sp)
    1b48:	74a2                	ld	s1,40(sp)
    1b4a:	7902                	ld	s2,32(sp)
    1b4c:	69e2                	ld	s3,24(sp)
    1b4e:	6a42                	ld	s4,16(sp)
    1b50:	6121                	addi	sp,sp,64
    1b52:	8082                	ret
      printf("%s: fork failed\n", s);
    1b54:	85d2                	mv	a1,s4
    1b56:	00005517          	auipc	a0,0x5
    1b5a:	e2a50513          	addi	a0,a0,-470 # 6980 <malloc+0x9ba>
    1b5e:	00004097          	auipc	ra,0x4
    1b62:	3b0080e7          	jalr	944(ra) # 5f0e <printf>
      exit(1);
    1b66:	4505                	li	a0,1
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	03e080e7          	jalr	62(ra) # 5ba6 <exit>
        printf("%s: wait wrong pid\n", s);
    1b70:	85d2                	mv	a1,s4
    1b72:	00005517          	auipc	a0,0x5
    1b76:	f9650513          	addi	a0,a0,-106 # 6b08 <malloc+0xb42>
    1b7a:	00004097          	auipc	ra,0x4
    1b7e:	394080e7          	jalr	916(ra) # 5f0e <printf>
        exit(1);
    1b82:	4505                	li	a0,1
    1b84:	00004097          	auipc	ra,0x4
    1b88:	022080e7          	jalr	34(ra) # 5ba6 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b8c:	85d2                	mv	a1,s4
    1b8e:	00005517          	auipc	a0,0x5
    1b92:	f9250513          	addi	a0,a0,-110 # 6b20 <malloc+0xb5a>
    1b96:	00004097          	auipc	ra,0x4
    1b9a:	378080e7          	jalr	888(ra) # 5f0e <printf>
        exit(1);
    1b9e:	4505                	li	a0,1
    1ba0:	00004097          	auipc	ra,0x4
    1ba4:	006080e7          	jalr	6(ra) # 5ba6 <exit>
      exit(i);
    1ba8:	854a                	mv	a0,s2
    1baa:	00004097          	auipc	ra,0x4
    1bae:	ffc080e7          	jalr	-4(ra) # 5ba6 <exit>

0000000000001bb2 <twochildren>:
{
    1bb2:	1101                	addi	sp,sp,-32
    1bb4:	ec06                	sd	ra,24(sp)
    1bb6:	e822                	sd	s0,16(sp)
    1bb8:	e426                	sd	s1,8(sp)
    1bba:	e04a                	sd	s2,0(sp)
    1bbc:	1000                	addi	s0,sp,32
    1bbe:	892a                	mv	s2,a0
    1bc0:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bc4:	00004097          	auipc	ra,0x4
    1bc8:	fda080e7          	jalr	-38(ra) # 5b9e <fork>
    if (pid1 < 0)
    1bcc:	02054c63          	bltz	a0,1c04 <twochildren+0x52>
    if (pid1 == 0)
    1bd0:	c921                	beqz	a0,1c20 <twochildren+0x6e>
      int pid2 = fork();
    1bd2:	00004097          	auipc	ra,0x4
    1bd6:	fcc080e7          	jalr	-52(ra) # 5b9e <fork>
      if (pid2 < 0)
    1bda:	04054763          	bltz	a0,1c28 <twochildren+0x76>
      if (pid2 == 0)
    1bde:	c13d                	beqz	a0,1c44 <twochildren+0x92>
        wait(0);
    1be0:	4501                	li	a0,0
    1be2:	00004097          	auipc	ra,0x4
    1be6:	fcc080e7          	jalr	-52(ra) # 5bae <wait>
        wait(0);
    1bea:	4501                	li	a0,0
    1bec:	00004097          	auipc	ra,0x4
    1bf0:	fc2080e7          	jalr	-62(ra) # 5bae <wait>
  for (int i = 0; i < 1000; i++)
    1bf4:	34fd                	addiw	s1,s1,-1
    1bf6:	f4f9                	bnez	s1,1bc4 <twochildren+0x12>
}
    1bf8:	60e2                	ld	ra,24(sp)
    1bfa:	6442                	ld	s0,16(sp)
    1bfc:	64a2                	ld	s1,8(sp)
    1bfe:	6902                	ld	s2,0(sp)
    1c00:	6105                	addi	sp,sp,32
    1c02:	8082                	ret
      printf("%s: fork failed\n", s);
    1c04:	85ca                	mv	a1,s2
    1c06:	00005517          	auipc	a0,0x5
    1c0a:	d7a50513          	addi	a0,a0,-646 # 6980 <malloc+0x9ba>
    1c0e:	00004097          	auipc	ra,0x4
    1c12:	300080e7          	jalr	768(ra) # 5f0e <printf>
      exit(1);
    1c16:	4505                	li	a0,1
    1c18:	00004097          	auipc	ra,0x4
    1c1c:	f8e080e7          	jalr	-114(ra) # 5ba6 <exit>
      exit(0);
    1c20:	00004097          	auipc	ra,0x4
    1c24:	f86080e7          	jalr	-122(ra) # 5ba6 <exit>
        printf("%s: fork failed\n", s);
    1c28:	85ca                	mv	a1,s2
    1c2a:	00005517          	auipc	a0,0x5
    1c2e:	d5650513          	addi	a0,a0,-682 # 6980 <malloc+0x9ba>
    1c32:	00004097          	auipc	ra,0x4
    1c36:	2dc080e7          	jalr	732(ra) # 5f0e <printf>
        exit(1);
    1c3a:	4505                	li	a0,1
    1c3c:	00004097          	auipc	ra,0x4
    1c40:	f6a080e7          	jalr	-150(ra) # 5ba6 <exit>
        exit(0);
    1c44:	00004097          	auipc	ra,0x4
    1c48:	f62080e7          	jalr	-158(ra) # 5ba6 <exit>

0000000000001c4c <forkfork>:
{
    1c4c:	7179                	addi	sp,sp,-48
    1c4e:	f406                	sd	ra,40(sp)
    1c50:	f022                	sd	s0,32(sp)
    1c52:	ec26                	sd	s1,24(sp)
    1c54:	1800                	addi	s0,sp,48
    1c56:	84aa                	mv	s1,a0
    int pid = fork();
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	f46080e7          	jalr	-186(ra) # 5b9e <fork>
    if (pid < 0)
    1c60:	04054163          	bltz	a0,1ca2 <forkfork+0x56>
    if (pid == 0)
    1c64:	cd29                	beqz	a0,1cbe <forkfork+0x72>
    int pid = fork();
    1c66:	00004097          	auipc	ra,0x4
    1c6a:	f38080e7          	jalr	-200(ra) # 5b9e <fork>
    if (pid < 0)
    1c6e:	02054a63          	bltz	a0,1ca2 <forkfork+0x56>
    if (pid == 0)
    1c72:	c531                	beqz	a0,1cbe <forkfork+0x72>
    wait(&xstatus);
    1c74:	fdc40513          	addi	a0,s0,-36
    1c78:	00004097          	auipc	ra,0x4
    1c7c:	f36080e7          	jalr	-202(ra) # 5bae <wait>
    if (xstatus != 0)
    1c80:	fdc42783          	lw	a5,-36(s0)
    1c84:	ebbd                	bnez	a5,1cfa <forkfork+0xae>
    wait(&xstatus);
    1c86:	fdc40513          	addi	a0,s0,-36
    1c8a:	00004097          	auipc	ra,0x4
    1c8e:	f24080e7          	jalr	-220(ra) # 5bae <wait>
    if (xstatus != 0)
    1c92:	fdc42783          	lw	a5,-36(s0)
    1c96:	e3b5                	bnez	a5,1cfa <forkfork+0xae>
}
    1c98:	70a2                	ld	ra,40(sp)
    1c9a:	7402                	ld	s0,32(sp)
    1c9c:	64e2                	ld	s1,24(sp)
    1c9e:	6145                	addi	sp,sp,48
    1ca0:	8082                	ret
      printf("%s: fork failed", s);
    1ca2:	85a6                	mv	a1,s1
    1ca4:	00005517          	auipc	a0,0x5
    1ca8:	e9c50513          	addi	a0,a0,-356 # 6b40 <malloc+0xb7a>
    1cac:	00004097          	auipc	ra,0x4
    1cb0:	262080e7          	jalr	610(ra) # 5f0e <printf>
      exit(1);
    1cb4:	4505                	li	a0,1
    1cb6:	00004097          	auipc	ra,0x4
    1cba:	ef0080e7          	jalr	-272(ra) # 5ba6 <exit>
{
    1cbe:	0c800493          	li	s1,200
        int pid1 = fork();
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	edc080e7          	jalr	-292(ra) # 5b9e <fork>
        if (pid1 < 0)
    1cca:	00054f63          	bltz	a0,1ce8 <forkfork+0x9c>
        if (pid1 == 0)
    1cce:	c115                	beqz	a0,1cf2 <forkfork+0xa6>
        wait(0);
    1cd0:	4501                	li	a0,0
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	edc080e7          	jalr	-292(ra) # 5bae <wait>
      for (int j = 0; j < 200; j++)
    1cda:	34fd                	addiw	s1,s1,-1
    1cdc:	f0fd                	bnez	s1,1cc2 <forkfork+0x76>
      exit(0);
    1cde:	4501                	li	a0,0
    1ce0:	00004097          	auipc	ra,0x4
    1ce4:	ec6080e7          	jalr	-314(ra) # 5ba6 <exit>
          exit(1);
    1ce8:	4505                	li	a0,1
    1cea:	00004097          	auipc	ra,0x4
    1cee:	ebc080e7          	jalr	-324(ra) # 5ba6 <exit>
          exit(0);
    1cf2:	00004097          	auipc	ra,0x4
    1cf6:	eb4080e7          	jalr	-332(ra) # 5ba6 <exit>
      printf("%s: fork in child failed", s);
    1cfa:	85a6                	mv	a1,s1
    1cfc:	00005517          	auipc	a0,0x5
    1d00:	e5450513          	addi	a0,a0,-428 # 6b50 <malloc+0xb8a>
    1d04:	00004097          	auipc	ra,0x4
    1d08:	20a080e7          	jalr	522(ra) # 5f0e <printf>
      exit(1);
    1d0c:	4505                	li	a0,1
    1d0e:	00004097          	auipc	ra,0x4
    1d12:	e98080e7          	jalr	-360(ra) # 5ba6 <exit>

0000000000001d16 <reparent2>:
{
    1d16:	1101                	addi	sp,sp,-32
    1d18:	ec06                	sd	ra,24(sp)
    1d1a:	e822                	sd	s0,16(sp)
    1d1c:	e426                	sd	s1,8(sp)
    1d1e:	1000                	addi	s0,sp,32
    1d20:	32000493          	li	s1,800
    int pid1 = fork();
    1d24:	00004097          	auipc	ra,0x4
    1d28:	e7a080e7          	jalr	-390(ra) # 5b9e <fork>
    if (pid1 < 0)
    1d2c:	00054f63          	bltz	a0,1d4a <reparent2+0x34>
    if (pid1 == 0)
    1d30:	c915                	beqz	a0,1d64 <reparent2+0x4e>
    wait(0);
    1d32:	4501                	li	a0,0
    1d34:	00004097          	auipc	ra,0x4
    1d38:	e7a080e7          	jalr	-390(ra) # 5bae <wait>
  for (int i = 0; i < 800; i++)
    1d3c:	34fd                	addiw	s1,s1,-1
    1d3e:	f0fd                	bnez	s1,1d24 <reparent2+0xe>
  exit(0);
    1d40:	4501                	li	a0,0
    1d42:	00004097          	auipc	ra,0x4
    1d46:	e64080e7          	jalr	-412(ra) # 5ba6 <exit>
      printf("fork failed\n");
    1d4a:	00005517          	auipc	a0,0x5
    1d4e:	03e50513          	addi	a0,a0,62 # 6d88 <malloc+0xdc2>
    1d52:	00004097          	auipc	ra,0x4
    1d56:	1bc080e7          	jalr	444(ra) # 5f0e <printf>
      exit(1);
    1d5a:	4505                	li	a0,1
    1d5c:	00004097          	auipc	ra,0x4
    1d60:	e4a080e7          	jalr	-438(ra) # 5ba6 <exit>
      fork();
    1d64:	00004097          	auipc	ra,0x4
    1d68:	e3a080e7          	jalr	-454(ra) # 5b9e <fork>
      fork();
    1d6c:	00004097          	auipc	ra,0x4
    1d70:	e32080e7          	jalr	-462(ra) # 5b9e <fork>
      exit(0);
    1d74:	4501                	li	a0,0
    1d76:	00004097          	auipc	ra,0x4
    1d7a:	e30080e7          	jalr	-464(ra) # 5ba6 <exit>

0000000000001d7e <createdelete>:
{
    1d7e:	7175                	addi	sp,sp,-144
    1d80:	e506                	sd	ra,136(sp)
    1d82:	e122                	sd	s0,128(sp)
    1d84:	fca6                	sd	s1,120(sp)
    1d86:	f8ca                	sd	s2,112(sp)
    1d88:	f4ce                	sd	s3,104(sp)
    1d8a:	f0d2                	sd	s4,96(sp)
    1d8c:	ecd6                	sd	s5,88(sp)
    1d8e:	e8da                	sd	s6,80(sp)
    1d90:	e4de                	sd	s7,72(sp)
    1d92:	e0e2                	sd	s8,64(sp)
    1d94:	fc66                	sd	s9,56(sp)
    1d96:	0900                	addi	s0,sp,144
    1d98:	8caa                	mv	s9,a0
  for (pi = 0; pi < NCHILD; pi++)
    1d9a:	4901                	li	s2,0
    1d9c:	4991                	li	s3,4
    pid = fork();
    1d9e:	00004097          	auipc	ra,0x4
    1da2:	e00080e7          	jalr	-512(ra) # 5b9e <fork>
    1da6:	84aa                	mv	s1,a0
    if (pid < 0)
    1da8:	02054f63          	bltz	a0,1de6 <createdelete+0x68>
    if (pid == 0)
    1dac:	c939                	beqz	a0,1e02 <createdelete+0x84>
  for (pi = 0; pi < NCHILD; pi++)
    1dae:	2905                	addiw	s2,s2,1
    1db0:	ff3917e3          	bne	s2,s3,1d9e <createdelete+0x20>
    1db4:	4491                	li	s1,4
    wait(&xstatus);
    1db6:	f7c40513          	addi	a0,s0,-132
    1dba:	00004097          	auipc	ra,0x4
    1dbe:	df4080e7          	jalr	-524(ra) # 5bae <wait>
    if (xstatus != 0)
    1dc2:	f7c42903          	lw	s2,-132(s0)
    1dc6:	0e091263          	bnez	s2,1eaa <createdelete+0x12c>
  for (pi = 0; pi < NCHILD; pi++)
    1dca:	34fd                	addiw	s1,s1,-1
    1dcc:	f4ed                	bnez	s1,1db6 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dce:	f8040123          	sb	zero,-126(s0)
    1dd2:	03000993          	li	s3,48
    1dd6:	5a7d                	li	s4,-1
    1dd8:	07000c13          	li	s8,112
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1ddc:	4b21                	li	s6,8
      if ((i == 0 || i >= N / 2) && fd < 0)
    1dde:	4ba5                	li	s7,9
    for (pi = 0; pi < NCHILD; pi++)
    1de0:	07400a93          	li	s5,116
    1de4:	a29d                	j	1f4a <createdelete+0x1cc>
      printf("fork failed\n", s);
    1de6:	85e6                	mv	a1,s9
    1de8:	00005517          	auipc	a0,0x5
    1dec:	fa050513          	addi	a0,a0,-96 # 6d88 <malloc+0xdc2>
    1df0:	00004097          	auipc	ra,0x4
    1df4:	11e080e7          	jalr	286(ra) # 5f0e <printf>
      exit(1);
    1df8:	4505                	li	a0,1
    1dfa:	00004097          	auipc	ra,0x4
    1dfe:	dac080e7          	jalr	-596(ra) # 5ba6 <exit>
      name[0] = 'p' + pi;
    1e02:	0709091b          	addiw	s2,s2,112
    1e06:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e0a:	f8040123          	sb	zero,-126(s0)
      for (i = 0; i < N; i++)
    1e0e:	4951                	li	s2,20
    1e10:	a015                	j	1e34 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e12:	85e6                	mv	a1,s9
    1e14:	00005517          	auipc	a0,0x5
    1e18:	c0450513          	addi	a0,a0,-1020 # 6a18 <malloc+0xa52>
    1e1c:	00004097          	auipc	ra,0x4
    1e20:	0f2080e7          	jalr	242(ra) # 5f0e <printf>
          exit(1);
    1e24:	4505                	li	a0,1
    1e26:	00004097          	auipc	ra,0x4
    1e2a:	d80080e7          	jalr	-640(ra) # 5ba6 <exit>
      for (i = 0; i < N; i++)
    1e2e:	2485                	addiw	s1,s1,1
    1e30:	07248863          	beq	s1,s2,1ea0 <createdelete+0x122>
        name[1] = '0' + i;
    1e34:	0304879b          	addiw	a5,s1,48
    1e38:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e3c:	20200593          	li	a1,514
    1e40:	f8040513          	addi	a0,s0,-128
    1e44:	00004097          	auipc	ra,0x4
    1e48:	da2080e7          	jalr	-606(ra) # 5be6 <open>
        if (fd < 0)
    1e4c:	fc0543e3          	bltz	a0,1e12 <createdelete+0x94>
        close(fd);
    1e50:	00004097          	auipc	ra,0x4
    1e54:	d7e080e7          	jalr	-642(ra) # 5bce <close>
        if (i > 0 && (i % 2) == 0)
    1e58:	fc905be3          	blez	s1,1e2e <createdelete+0xb0>
    1e5c:	0014f793          	andi	a5,s1,1
    1e60:	f7f9                	bnez	a5,1e2e <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e62:	01f4d79b          	srliw	a5,s1,0x1f
    1e66:	9fa5                	addw	a5,a5,s1
    1e68:	4017d79b          	sraiw	a5,a5,0x1
    1e6c:	0307879b          	addiw	a5,a5,48
    1e70:	f8f400a3          	sb	a5,-127(s0)
          if (unlink(name) < 0)
    1e74:	f8040513          	addi	a0,s0,-128
    1e78:	00004097          	auipc	ra,0x4
    1e7c:	d7e080e7          	jalr	-642(ra) # 5bf6 <unlink>
    1e80:	fa0557e3          	bgez	a0,1e2e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e84:	85e6                	mv	a1,s9
    1e86:	00005517          	auipc	a0,0x5
    1e8a:	cea50513          	addi	a0,a0,-790 # 6b70 <malloc+0xbaa>
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	080080e7          	jalr	128(ra) # 5f0e <printf>
            exit(1);
    1e96:	4505                	li	a0,1
    1e98:	00004097          	auipc	ra,0x4
    1e9c:	d0e080e7          	jalr	-754(ra) # 5ba6 <exit>
      exit(0);
    1ea0:	4501                	li	a0,0
    1ea2:	00004097          	auipc	ra,0x4
    1ea6:	d04080e7          	jalr	-764(ra) # 5ba6 <exit>
      exit(1);
    1eaa:	4505                	li	a0,1
    1eac:	00004097          	auipc	ra,0x4
    1eb0:	cfa080e7          	jalr	-774(ra) # 5ba6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1eb4:	f8040613          	addi	a2,s0,-128
    1eb8:	85e6                	mv	a1,s9
    1eba:	00005517          	auipc	a0,0x5
    1ebe:	cce50513          	addi	a0,a0,-818 # 6b88 <malloc+0xbc2>
    1ec2:	00004097          	auipc	ra,0x4
    1ec6:	04c080e7          	jalr	76(ra) # 5f0e <printf>
        exit(1);
    1eca:	4505                	li	a0,1
    1ecc:	00004097          	auipc	ra,0x4
    1ed0:	cda080e7          	jalr	-806(ra) # 5ba6 <exit>
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1ed4:	054b7163          	bgeu	s6,s4,1f16 <createdelete+0x198>
      if (fd >= 0)
    1ed8:	02055a63          	bgez	a0,1f0c <createdelete+0x18e>
    for (pi = 0; pi < NCHILD; pi++)
    1edc:	2485                	addiw	s1,s1,1
    1ede:	0ff4f493          	zext.b	s1,s1
    1ee2:	05548c63          	beq	s1,s5,1f3a <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ee6:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1eea:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1eee:	4581                	li	a1,0
    1ef0:	f8040513          	addi	a0,s0,-128
    1ef4:	00004097          	auipc	ra,0x4
    1ef8:	cf2080e7          	jalr	-782(ra) # 5be6 <open>
      if ((i == 0 || i >= N / 2) && fd < 0)
    1efc:	00090463          	beqz	s2,1f04 <createdelete+0x186>
    1f00:	fd2bdae3          	bge	s7,s2,1ed4 <createdelete+0x156>
    1f04:	fa0548e3          	bltz	a0,1eb4 <createdelete+0x136>
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1f08:	014b7963          	bgeu	s6,s4,1f1a <createdelete+0x19c>
        close(fd);
    1f0c:	00004097          	auipc	ra,0x4
    1f10:	cc2080e7          	jalr	-830(ra) # 5bce <close>
    1f14:	b7e1                	j	1edc <createdelete+0x15e>
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1f16:	fc0543e3          	bltz	a0,1edc <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f1a:	f8040613          	addi	a2,s0,-128
    1f1e:	85e6                	mv	a1,s9
    1f20:	00005517          	auipc	a0,0x5
    1f24:	c9050513          	addi	a0,a0,-880 # 6bb0 <malloc+0xbea>
    1f28:	00004097          	auipc	ra,0x4
    1f2c:	fe6080e7          	jalr	-26(ra) # 5f0e <printf>
        exit(1);
    1f30:	4505                	li	a0,1
    1f32:	00004097          	auipc	ra,0x4
    1f36:	c74080e7          	jalr	-908(ra) # 5ba6 <exit>
  for (i = 0; i < N; i++)
    1f3a:	2905                	addiw	s2,s2,1
    1f3c:	2a05                	addiw	s4,s4,1
    1f3e:	2985                	addiw	s3,s3,1 # 3001 <execout+0x8f>
    1f40:	0ff9f993          	zext.b	s3,s3
    1f44:	47d1                	li	a5,20
    1f46:	02f90a63          	beq	s2,a5,1f7a <createdelete+0x1fc>
    for (pi = 0; pi < NCHILD; pi++)
    1f4a:	84e2                	mv	s1,s8
    1f4c:	bf69                	j	1ee6 <createdelete+0x168>
  for (i = 0; i < N; i++)
    1f4e:	2905                	addiw	s2,s2,1
    1f50:	0ff97913          	zext.b	s2,s2
    1f54:	2985                	addiw	s3,s3,1
    1f56:	0ff9f993          	zext.b	s3,s3
    1f5a:	03490863          	beq	s2,s4,1f8a <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f5e:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f60:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f64:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f68:	f8040513          	addi	a0,s0,-128
    1f6c:	00004097          	auipc	ra,0x4
    1f70:	c8a080e7          	jalr	-886(ra) # 5bf6 <unlink>
    for (pi = 0; pi < NCHILD; pi++)
    1f74:	34fd                	addiw	s1,s1,-1
    1f76:	f4ed                	bnez	s1,1f60 <createdelete+0x1e2>
    1f78:	bfd9                	j	1f4e <createdelete+0x1d0>
    1f7a:	03000993          	li	s3,48
    1f7e:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f82:	4a91                	li	s5,4
  for (i = 0; i < N; i++)
    1f84:	08400a13          	li	s4,132
    1f88:	bfd9                	j	1f5e <createdelete+0x1e0>
}
    1f8a:	60aa                	ld	ra,136(sp)
    1f8c:	640a                	ld	s0,128(sp)
    1f8e:	74e6                	ld	s1,120(sp)
    1f90:	7946                	ld	s2,112(sp)
    1f92:	79a6                	ld	s3,104(sp)
    1f94:	7a06                	ld	s4,96(sp)
    1f96:	6ae6                	ld	s5,88(sp)
    1f98:	6b46                	ld	s6,80(sp)
    1f9a:	6ba6                	ld	s7,72(sp)
    1f9c:	6c06                	ld	s8,64(sp)
    1f9e:	7ce2                	ld	s9,56(sp)
    1fa0:	6149                	addi	sp,sp,144
    1fa2:	8082                	ret

0000000000001fa4 <linkunlink>:
{
    1fa4:	711d                	addi	sp,sp,-96
    1fa6:	ec86                	sd	ra,88(sp)
    1fa8:	e8a2                	sd	s0,80(sp)
    1faa:	e4a6                	sd	s1,72(sp)
    1fac:	e0ca                	sd	s2,64(sp)
    1fae:	fc4e                	sd	s3,56(sp)
    1fb0:	f852                	sd	s4,48(sp)
    1fb2:	f456                	sd	s5,40(sp)
    1fb4:	f05a                	sd	s6,32(sp)
    1fb6:	ec5e                	sd	s7,24(sp)
    1fb8:	e862                	sd	s8,16(sp)
    1fba:	e466                	sd	s9,8(sp)
    1fbc:	1080                	addi	s0,sp,96
    1fbe:	84aa                	mv	s1,a0
  unlink("x");
    1fc0:	00004517          	auipc	a0,0x4
    1fc4:	19850513          	addi	a0,a0,408 # 6158 <malloc+0x192>
    1fc8:	00004097          	auipc	ra,0x4
    1fcc:	c2e080e7          	jalr	-978(ra) # 5bf6 <unlink>
  pid = fork();
    1fd0:	00004097          	auipc	ra,0x4
    1fd4:	bce080e7          	jalr	-1074(ra) # 5b9e <fork>
  if (pid < 0)
    1fd8:	02054b63          	bltz	a0,200e <linkunlink+0x6a>
    1fdc:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fde:	06100c93          	li	s9,97
    1fe2:	c111                	beqz	a0,1fe6 <linkunlink+0x42>
    1fe4:	4c85                	li	s9,1
    1fe6:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fea:	41c659b7          	lui	s3,0x41c65
    1fee:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c551f5>
    1ff2:	690d                	lui	s2,0x3
    1ff4:	0399091b          	addiw	s2,s2,57 # 3039 <fourteen+0x3>
    if ((x % 3) == 0)
    1ff8:	4a0d                	li	s4,3
    else if ((x % 3) == 1)
    1ffa:	4b05                	li	s6,1
      unlink("x");
    1ffc:	00004a97          	auipc	s5,0x4
    2000:	15ca8a93          	addi	s5,s5,348 # 6158 <malloc+0x192>
      link("cat", "x");
    2004:	00005b97          	auipc	s7,0x5
    2008:	bd4b8b93          	addi	s7,s7,-1068 # 6bd8 <malloc+0xc12>
    200c:	a825                	j	2044 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    200e:	85a6                	mv	a1,s1
    2010:	00005517          	auipc	a0,0x5
    2014:	97050513          	addi	a0,a0,-1680 # 6980 <malloc+0x9ba>
    2018:	00004097          	auipc	ra,0x4
    201c:	ef6080e7          	jalr	-266(ra) # 5f0e <printf>
    exit(1);
    2020:	4505                	li	a0,1
    2022:	00004097          	auipc	ra,0x4
    2026:	b84080e7          	jalr	-1148(ra) # 5ba6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    202a:	20200593          	li	a1,514
    202e:	8556                	mv	a0,s5
    2030:	00004097          	auipc	ra,0x4
    2034:	bb6080e7          	jalr	-1098(ra) # 5be6 <open>
    2038:	00004097          	auipc	ra,0x4
    203c:	b96080e7          	jalr	-1130(ra) # 5bce <close>
  for (i = 0; i < 100; i++)
    2040:	34fd                	addiw	s1,s1,-1
    2042:	c88d                	beqz	s1,2074 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2044:	033c87bb          	mulw	a5,s9,s3
    2048:	012787bb          	addw	a5,a5,s2
    204c:	00078c9b          	sext.w	s9,a5
    if ((x % 3) == 0)
    2050:	0347f7bb          	remuw	a5,a5,s4
    2054:	dbf9                	beqz	a5,202a <linkunlink+0x86>
    else if ((x % 3) == 1)
    2056:	01678863          	beq	a5,s6,2066 <linkunlink+0xc2>
      unlink("x");
    205a:	8556                	mv	a0,s5
    205c:	00004097          	auipc	ra,0x4
    2060:	b9a080e7          	jalr	-1126(ra) # 5bf6 <unlink>
    2064:	bff1                	j	2040 <linkunlink+0x9c>
      link("cat", "x");
    2066:	85d6                	mv	a1,s5
    2068:	855e                	mv	a0,s7
    206a:	00004097          	auipc	ra,0x4
    206e:	b9c080e7          	jalr	-1124(ra) # 5c06 <link>
    2072:	b7f9                	j	2040 <linkunlink+0x9c>
  if (pid)
    2074:	020c0463          	beqz	s8,209c <linkunlink+0xf8>
    wait(0);
    2078:	4501                	li	a0,0
    207a:	00004097          	auipc	ra,0x4
    207e:	b34080e7          	jalr	-1228(ra) # 5bae <wait>
}
    2082:	60e6                	ld	ra,88(sp)
    2084:	6446                	ld	s0,80(sp)
    2086:	64a6                	ld	s1,72(sp)
    2088:	6906                	ld	s2,64(sp)
    208a:	79e2                	ld	s3,56(sp)
    208c:	7a42                	ld	s4,48(sp)
    208e:	7aa2                	ld	s5,40(sp)
    2090:	7b02                	ld	s6,32(sp)
    2092:	6be2                	ld	s7,24(sp)
    2094:	6c42                	ld	s8,16(sp)
    2096:	6ca2                	ld	s9,8(sp)
    2098:	6125                	addi	sp,sp,96
    209a:	8082                	ret
    exit(0);
    209c:	4501                	li	a0,0
    209e:	00004097          	auipc	ra,0x4
    20a2:	b08080e7          	jalr	-1272(ra) # 5ba6 <exit>

00000000000020a6 <forktest>:
{
    20a6:	7179                	addi	sp,sp,-48
    20a8:	f406                	sd	ra,40(sp)
    20aa:	f022                	sd	s0,32(sp)
    20ac:	ec26                	sd	s1,24(sp)
    20ae:	e84a                	sd	s2,16(sp)
    20b0:	e44e                	sd	s3,8(sp)
    20b2:	1800                	addi	s0,sp,48
    20b4:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++)
    20b6:	4481                	li	s1,0
    20b8:	3e800913          	li	s2,1000
    pid = fork();
    20bc:	00004097          	auipc	ra,0x4
    20c0:	ae2080e7          	jalr	-1310(ra) # 5b9e <fork>
    if (pid < 0)
    20c4:	02054863          	bltz	a0,20f4 <forktest+0x4e>
    if (pid == 0)
    20c8:	c115                	beqz	a0,20ec <forktest+0x46>
  for (n = 0; n < N; n++)
    20ca:	2485                	addiw	s1,s1,1
    20cc:	ff2498e3          	bne	s1,s2,20bc <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20d0:	85ce                	mv	a1,s3
    20d2:	00005517          	auipc	a0,0x5
    20d6:	b2650513          	addi	a0,a0,-1242 # 6bf8 <malloc+0xc32>
    20da:	00004097          	auipc	ra,0x4
    20de:	e34080e7          	jalr	-460(ra) # 5f0e <printf>
    exit(1);
    20e2:	4505                	li	a0,1
    20e4:	00004097          	auipc	ra,0x4
    20e8:	ac2080e7          	jalr	-1342(ra) # 5ba6 <exit>
      exit(0);
    20ec:	00004097          	auipc	ra,0x4
    20f0:	aba080e7          	jalr	-1350(ra) # 5ba6 <exit>
  if (n == 0)
    20f4:	cc9d                	beqz	s1,2132 <forktest+0x8c>
  if (n == N)
    20f6:	3e800793          	li	a5,1000
    20fa:	fcf48be3          	beq	s1,a5,20d0 <forktest+0x2a>
  for (; n > 0; n--)
    20fe:	00905b63          	blez	s1,2114 <forktest+0x6e>
    if (wait(0) < 0)
    2102:	4501                	li	a0,0
    2104:	00004097          	auipc	ra,0x4
    2108:	aaa080e7          	jalr	-1366(ra) # 5bae <wait>
    210c:	04054163          	bltz	a0,214e <forktest+0xa8>
  for (; n > 0; n--)
    2110:	34fd                	addiw	s1,s1,-1
    2112:	f8e5                	bnez	s1,2102 <forktest+0x5c>
  if (wait(0) != -1)
    2114:	4501                	li	a0,0
    2116:	00004097          	auipc	ra,0x4
    211a:	a98080e7          	jalr	-1384(ra) # 5bae <wait>
    211e:	57fd                	li	a5,-1
    2120:	04f51563          	bne	a0,a5,216a <forktest+0xc4>
}
    2124:	70a2                	ld	ra,40(sp)
    2126:	7402                	ld	s0,32(sp)
    2128:	64e2                	ld	s1,24(sp)
    212a:	6942                	ld	s2,16(sp)
    212c:	69a2                	ld	s3,8(sp)
    212e:	6145                	addi	sp,sp,48
    2130:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2132:	85ce                	mv	a1,s3
    2134:	00005517          	auipc	a0,0x5
    2138:	aac50513          	addi	a0,a0,-1364 # 6be0 <malloc+0xc1a>
    213c:	00004097          	auipc	ra,0x4
    2140:	dd2080e7          	jalr	-558(ra) # 5f0e <printf>
    exit(1);
    2144:	4505                	li	a0,1
    2146:	00004097          	auipc	ra,0x4
    214a:	a60080e7          	jalr	-1440(ra) # 5ba6 <exit>
      printf("%s: wait stopped early\n", s);
    214e:	85ce                	mv	a1,s3
    2150:	00005517          	auipc	a0,0x5
    2154:	ad050513          	addi	a0,a0,-1328 # 6c20 <malloc+0xc5a>
    2158:	00004097          	auipc	ra,0x4
    215c:	db6080e7          	jalr	-586(ra) # 5f0e <printf>
      exit(1);
    2160:	4505                	li	a0,1
    2162:	00004097          	auipc	ra,0x4
    2166:	a44080e7          	jalr	-1468(ra) # 5ba6 <exit>
    printf("%s: wait got too many\n", s);
    216a:	85ce                	mv	a1,s3
    216c:	00005517          	auipc	a0,0x5
    2170:	acc50513          	addi	a0,a0,-1332 # 6c38 <malloc+0xc72>
    2174:	00004097          	auipc	ra,0x4
    2178:	d9a080e7          	jalr	-614(ra) # 5f0e <printf>
    exit(1);
    217c:	4505                	li	a0,1
    217e:	00004097          	auipc	ra,0x4
    2182:	a28080e7          	jalr	-1496(ra) # 5ba6 <exit>

0000000000002186 <kernmem>:
{
    2186:	715d                	addi	sp,sp,-80
    2188:	e486                	sd	ra,72(sp)
    218a:	e0a2                	sd	s0,64(sp)
    218c:	fc26                	sd	s1,56(sp)
    218e:	f84a                	sd	s2,48(sp)
    2190:	f44e                	sd	s3,40(sp)
    2192:	f052                	sd	s4,32(sp)
    2194:	ec56                	sd	s5,24(sp)
    2196:	0880                	addi	s0,sp,80
    2198:	8a2a                	mv	s4,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000)
    219a:	4485                	li	s1,1
    219c:	04fe                	slli	s1,s1,0x1f
    if (xstatus != -1) // did kernel kill child?
    219e:	5afd                	li	s5,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000)
    21a0:	69b1                	lui	s3,0xc
    21a2:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    21a6:	1003d937          	lui	s2,0x1003d
    21aa:	090e                	slli	s2,s2,0x3
    21ac:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21b0:	00004097          	auipc	ra,0x4
    21b4:	9ee080e7          	jalr	-1554(ra) # 5b9e <fork>
    if (pid < 0)
    21b8:	02054963          	bltz	a0,21ea <kernmem+0x64>
    if (pid == 0)
    21bc:	c529                	beqz	a0,2206 <kernmem+0x80>
    wait(&xstatus);
    21be:	fbc40513          	addi	a0,s0,-68
    21c2:	00004097          	auipc	ra,0x4
    21c6:	9ec080e7          	jalr	-1556(ra) # 5bae <wait>
    if (xstatus != -1) // did kernel kill child?
    21ca:	fbc42783          	lw	a5,-68(s0)
    21ce:	05579d63          	bne	a5,s5,2228 <kernmem+0xa2>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000)
    21d2:	94ce                	add	s1,s1,s3
    21d4:	fd249ee3          	bne	s1,s2,21b0 <kernmem+0x2a>
}
    21d8:	60a6                	ld	ra,72(sp)
    21da:	6406                	ld	s0,64(sp)
    21dc:	74e2                	ld	s1,56(sp)
    21de:	7942                	ld	s2,48(sp)
    21e0:	79a2                	ld	s3,40(sp)
    21e2:	7a02                	ld	s4,32(sp)
    21e4:	6ae2                	ld	s5,24(sp)
    21e6:	6161                	addi	sp,sp,80
    21e8:	8082                	ret
      printf("%s: fork failed\n", s);
    21ea:	85d2                	mv	a1,s4
    21ec:	00004517          	auipc	a0,0x4
    21f0:	79450513          	addi	a0,a0,1940 # 6980 <malloc+0x9ba>
    21f4:	00004097          	auipc	ra,0x4
    21f8:	d1a080e7          	jalr	-742(ra) # 5f0e <printf>
      exit(1);
    21fc:	4505                	li	a0,1
    21fe:	00004097          	auipc	ra,0x4
    2202:	9a8080e7          	jalr	-1624(ra) # 5ba6 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2206:	0004c683          	lbu	a3,0(s1)
    220a:	8626                	mv	a2,s1
    220c:	85d2                	mv	a1,s4
    220e:	00005517          	auipc	a0,0x5
    2212:	a4250513          	addi	a0,a0,-1470 # 6c50 <malloc+0xc8a>
    2216:	00004097          	auipc	ra,0x4
    221a:	cf8080e7          	jalr	-776(ra) # 5f0e <printf>
      exit(1);
    221e:	4505                	li	a0,1
    2220:	00004097          	auipc	ra,0x4
    2224:	986080e7          	jalr	-1658(ra) # 5ba6 <exit>
      exit(1);
    2228:	4505                	li	a0,1
    222a:	00004097          	auipc	ra,0x4
    222e:	97c080e7          	jalr	-1668(ra) # 5ba6 <exit>

0000000000002232 <MAXVAplus>:
{
    2232:	7179                	addi	sp,sp,-48
    2234:	f406                	sd	ra,40(sp)
    2236:	f022                	sd	s0,32(sp)
    2238:	ec26                	sd	s1,24(sp)
    223a:	e84a                	sd	s2,16(sp)
    223c:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    223e:	4785                	li	a5,1
    2240:	179a                	slli	a5,a5,0x26
    2242:	fcf43c23          	sd	a5,-40(s0)
  for (; a != 0; a <<= 1)
    2246:	fd843783          	ld	a5,-40(s0)
    224a:	cf85                	beqz	a5,2282 <MAXVAplus+0x50>
    224c:	892a                	mv	s2,a0
    if (xstatus != -1) // did kernel kill child?
    224e:	54fd                	li	s1,-1
    pid = fork();
    2250:	00004097          	auipc	ra,0x4
    2254:	94e080e7          	jalr	-1714(ra) # 5b9e <fork>
    if (pid < 0)
    2258:	02054b63          	bltz	a0,228e <MAXVAplus+0x5c>
    if (pid == 0)
    225c:	c539                	beqz	a0,22aa <MAXVAplus+0x78>
    wait(&xstatus);
    225e:	fd440513          	addi	a0,s0,-44
    2262:	00004097          	auipc	ra,0x4
    2266:	94c080e7          	jalr	-1716(ra) # 5bae <wait>
    if (xstatus != -1) // did kernel kill child?
    226a:	fd442783          	lw	a5,-44(s0)
    226e:	06979463          	bne	a5,s1,22d6 <MAXVAplus+0xa4>
  for (; a != 0; a <<= 1)
    2272:	fd843783          	ld	a5,-40(s0)
    2276:	0786                	slli	a5,a5,0x1
    2278:	fcf43c23          	sd	a5,-40(s0)
    227c:	fd843783          	ld	a5,-40(s0)
    2280:	fbe1                	bnez	a5,2250 <MAXVAplus+0x1e>
}
    2282:	70a2                	ld	ra,40(sp)
    2284:	7402                	ld	s0,32(sp)
    2286:	64e2                	ld	s1,24(sp)
    2288:	6942                	ld	s2,16(sp)
    228a:	6145                	addi	sp,sp,48
    228c:	8082                	ret
      printf("%s: fork failed\n", s);
    228e:	85ca                	mv	a1,s2
    2290:	00004517          	auipc	a0,0x4
    2294:	6f050513          	addi	a0,a0,1776 # 6980 <malloc+0x9ba>
    2298:	00004097          	auipc	ra,0x4
    229c:	c76080e7          	jalr	-906(ra) # 5f0e <printf>
      exit(1);
    22a0:	4505                	li	a0,1
    22a2:	00004097          	auipc	ra,0x4
    22a6:	904080e7          	jalr	-1788(ra) # 5ba6 <exit>
      *(char *)a = 99;
    22aa:	fd843783          	ld	a5,-40(s0)
    22ae:	06300713          	li	a4,99
    22b2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22b6:	fd843603          	ld	a2,-40(s0)
    22ba:	85ca                	mv	a1,s2
    22bc:	00005517          	auipc	a0,0x5
    22c0:	9b450513          	addi	a0,a0,-1612 # 6c70 <malloc+0xcaa>
    22c4:	00004097          	auipc	ra,0x4
    22c8:	c4a080e7          	jalr	-950(ra) # 5f0e <printf>
      exit(1);
    22cc:	4505                	li	a0,1
    22ce:	00004097          	auipc	ra,0x4
    22d2:	8d8080e7          	jalr	-1832(ra) # 5ba6 <exit>
      exit(1);
    22d6:	4505                	li	a0,1
    22d8:	00004097          	auipc	ra,0x4
    22dc:	8ce080e7          	jalr	-1842(ra) # 5ba6 <exit>

00000000000022e0 <bigargtest>:
{
    22e0:	7179                	addi	sp,sp,-48
    22e2:	f406                	sd	ra,40(sp)
    22e4:	f022                	sd	s0,32(sp)
    22e6:	ec26                	sd	s1,24(sp)
    22e8:	1800                	addi	s0,sp,48
    22ea:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22ec:	00005517          	auipc	a0,0x5
    22f0:	99c50513          	addi	a0,a0,-1636 # 6c88 <malloc+0xcc2>
    22f4:	00004097          	auipc	ra,0x4
    22f8:	902080e7          	jalr	-1790(ra) # 5bf6 <unlink>
  pid = fork();
    22fc:	00004097          	auipc	ra,0x4
    2300:	8a2080e7          	jalr	-1886(ra) # 5b9e <fork>
  if (pid == 0)
    2304:	c121                	beqz	a0,2344 <bigargtest+0x64>
  else if (pid < 0)
    2306:	0a054063          	bltz	a0,23a6 <bigargtest+0xc6>
  wait(&xstatus);
    230a:	fdc40513          	addi	a0,s0,-36
    230e:	00004097          	auipc	ra,0x4
    2312:	8a0080e7          	jalr	-1888(ra) # 5bae <wait>
  if (xstatus != 0)
    2316:	fdc42503          	lw	a0,-36(s0)
    231a:	e545                	bnez	a0,23c2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    231c:	4581                	li	a1,0
    231e:	00005517          	auipc	a0,0x5
    2322:	96a50513          	addi	a0,a0,-1686 # 6c88 <malloc+0xcc2>
    2326:	00004097          	auipc	ra,0x4
    232a:	8c0080e7          	jalr	-1856(ra) # 5be6 <open>
  if (fd < 0)
    232e:	08054e63          	bltz	a0,23ca <bigargtest+0xea>
  close(fd);
    2332:	00004097          	auipc	ra,0x4
    2336:	89c080e7          	jalr	-1892(ra) # 5bce <close>
}
    233a:	70a2                	ld	ra,40(sp)
    233c:	7402                	ld	s0,32(sp)
    233e:	64e2                	ld	s1,24(sp)
    2340:	6145                	addi	sp,sp,48
    2342:	8082                	ret
    2344:	00007797          	auipc	a5,0x7
    2348:	11c78793          	addi	a5,a5,284 # 9460 <args.1>
    234c:	00007697          	auipc	a3,0x7
    2350:	20c68693          	addi	a3,a3,524 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2354:	00005717          	auipc	a4,0x5
    2358:	94470713          	addi	a4,a4,-1724 # 6c98 <malloc+0xcd2>
    235c:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    235e:	07a1                	addi	a5,a5,8
    2360:	fed79ee3          	bne	a5,a3,235c <bigargtest+0x7c>
    args[MAXARG - 1] = 0;
    2364:	00007597          	auipc	a1,0x7
    2368:	0fc58593          	addi	a1,a1,252 # 9460 <args.1>
    236c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2370:	00004517          	auipc	a0,0x4
    2374:	d7850513          	addi	a0,a0,-648 # 60e8 <malloc+0x122>
    2378:	00004097          	auipc	ra,0x4
    237c:	866080e7          	jalr	-1946(ra) # 5bde <exec>
    fd = open("bigarg-ok", O_CREATE);
    2380:	20000593          	li	a1,512
    2384:	00005517          	auipc	a0,0x5
    2388:	90450513          	addi	a0,a0,-1788 # 6c88 <malloc+0xcc2>
    238c:	00004097          	auipc	ra,0x4
    2390:	85a080e7          	jalr	-1958(ra) # 5be6 <open>
    close(fd);
    2394:	00004097          	auipc	ra,0x4
    2398:	83a080e7          	jalr	-1990(ra) # 5bce <close>
    exit(0);
    239c:	4501                	li	a0,0
    239e:	00004097          	auipc	ra,0x4
    23a2:	808080e7          	jalr	-2040(ra) # 5ba6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23a6:	85a6                	mv	a1,s1
    23a8:	00005517          	auipc	a0,0x5
    23ac:	9d050513          	addi	a0,a0,-1584 # 6d78 <malloc+0xdb2>
    23b0:	00004097          	auipc	ra,0x4
    23b4:	b5e080e7          	jalr	-1186(ra) # 5f0e <printf>
    exit(1);
    23b8:	4505                	li	a0,1
    23ba:	00003097          	auipc	ra,0x3
    23be:	7ec080e7          	jalr	2028(ra) # 5ba6 <exit>
    exit(xstatus);
    23c2:	00003097          	auipc	ra,0x3
    23c6:	7e4080e7          	jalr	2020(ra) # 5ba6 <exit>
    printf("%s: bigarg test failed!\n", s);
    23ca:	85a6                	mv	a1,s1
    23cc:	00005517          	auipc	a0,0x5
    23d0:	9cc50513          	addi	a0,a0,-1588 # 6d98 <malloc+0xdd2>
    23d4:	00004097          	auipc	ra,0x4
    23d8:	b3a080e7          	jalr	-1222(ra) # 5f0e <printf>
    exit(1);
    23dc:	4505                	li	a0,1
    23de:	00003097          	auipc	ra,0x3
    23e2:	7c8080e7          	jalr	1992(ra) # 5ba6 <exit>

00000000000023e6 <stacktest>:
{
    23e6:	7179                	addi	sp,sp,-48
    23e8:	f406                	sd	ra,40(sp)
    23ea:	f022                	sd	s0,32(sp)
    23ec:	ec26                	sd	s1,24(sp)
    23ee:	1800                	addi	s0,sp,48
    23f0:	84aa                	mv	s1,a0
  pid = fork();
    23f2:	00003097          	auipc	ra,0x3
    23f6:	7ac080e7          	jalr	1964(ra) # 5b9e <fork>
  if (pid == 0)
    23fa:	c115                	beqz	a0,241e <stacktest+0x38>
  else if (pid < 0)
    23fc:	04054463          	bltz	a0,2444 <stacktest+0x5e>
  wait(&xstatus);
    2400:	fdc40513          	addi	a0,s0,-36
    2404:	00003097          	auipc	ra,0x3
    2408:	7aa080e7          	jalr	1962(ra) # 5bae <wait>
  if (xstatus == -1) // kernel killed child?
    240c:	fdc42503          	lw	a0,-36(s0)
    2410:	57fd                	li	a5,-1
    2412:	04f50763          	beq	a0,a5,2460 <stacktest+0x7a>
    exit(xstatus);
    2416:	00003097          	auipc	ra,0x3
    241a:	790080e7          	jalr	1936(ra) # 5ba6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    241e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2420:	77fd                	lui	a5,0xfffff
    2422:	97ba                	add	a5,a5,a4
    2424:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2428:	85a6                	mv	a1,s1
    242a:	00005517          	auipc	a0,0x5
    242e:	98e50513          	addi	a0,a0,-1650 # 6db8 <malloc+0xdf2>
    2432:	00004097          	auipc	ra,0x4
    2436:	adc080e7          	jalr	-1316(ra) # 5f0e <printf>
    exit(1);
    243a:	4505                	li	a0,1
    243c:	00003097          	auipc	ra,0x3
    2440:	76a080e7          	jalr	1898(ra) # 5ba6 <exit>
    printf("%s: fork failed\n", s);
    2444:	85a6                	mv	a1,s1
    2446:	00004517          	auipc	a0,0x4
    244a:	53a50513          	addi	a0,a0,1338 # 6980 <malloc+0x9ba>
    244e:	00004097          	auipc	ra,0x4
    2452:	ac0080e7          	jalr	-1344(ra) # 5f0e <printf>
    exit(1);
    2456:	4505                	li	a0,1
    2458:	00003097          	auipc	ra,0x3
    245c:	74e080e7          	jalr	1870(ra) # 5ba6 <exit>
    exit(0);
    2460:	4501                	li	a0,0
    2462:	00003097          	auipc	ra,0x3
    2466:	744080e7          	jalr	1860(ra) # 5ba6 <exit>

000000000000246a <textwrite>:
{
    246a:	7179                	addi	sp,sp,-48
    246c:	f406                	sd	ra,40(sp)
    246e:	f022                	sd	s0,32(sp)
    2470:	ec26                	sd	s1,24(sp)
    2472:	1800                	addi	s0,sp,48
    2474:	84aa                	mv	s1,a0
  pid = fork();
    2476:	00003097          	auipc	ra,0x3
    247a:	728080e7          	jalr	1832(ra) # 5b9e <fork>
  if (pid == 0)
    247e:	c115                	beqz	a0,24a2 <textwrite+0x38>
  else if (pid < 0)
    2480:	02054963          	bltz	a0,24b2 <textwrite+0x48>
  wait(&xstatus);
    2484:	fdc40513          	addi	a0,s0,-36
    2488:	00003097          	auipc	ra,0x3
    248c:	726080e7          	jalr	1830(ra) # 5bae <wait>
  if (xstatus == -1) // kernel killed child?
    2490:	fdc42503          	lw	a0,-36(s0)
    2494:	57fd                	li	a5,-1
    2496:	02f50c63          	beq	a0,a5,24ce <textwrite+0x64>
    exit(xstatus);
    249a:	00003097          	auipc	ra,0x3
    249e:	70c080e7          	jalr	1804(ra) # 5ba6 <exit>
    *addr = 10;
    24a2:	47a9                	li	a5,10
    24a4:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    24a8:	4505                	li	a0,1
    24aa:	00003097          	auipc	ra,0x3
    24ae:	6fc080e7          	jalr	1788(ra) # 5ba6 <exit>
    printf("%s: fork failed\n", s);
    24b2:	85a6                	mv	a1,s1
    24b4:	00004517          	auipc	a0,0x4
    24b8:	4cc50513          	addi	a0,a0,1228 # 6980 <malloc+0x9ba>
    24bc:	00004097          	auipc	ra,0x4
    24c0:	a52080e7          	jalr	-1454(ra) # 5f0e <printf>
    exit(1);
    24c4:	4505                	li	a0,1
    24c6:	00003097          	auipc	ra,0x3
    24ca:	6e0080e7          	jalr	1760(ra) # 5ba6 <exit>
    exit(0);
    24ce:	4501                	li	a0,0
    24d0:	00003097          	auipc	ra,0x3
    24d4:	6d6080e7          	jalr	1750(ra) # 5ba6 <exit>

00000000000024d8 <manywrites>:
{
    24d8:	711d                	addi	sp,sp,-96
    24da:	ec86                	sd	ra,88(sp)
    24dc:	e8a2                	sd	s0,80(sp)
    24de:	e4a6                	sd	s1,72(sp)
    24e0:	e0ca                	sd	s2,64(sp)
    24e2:	fc4e                	sd	s3,56(sp)
    24e4:	f852                	sd	s4,48(sp)
    24e6:	f456                	sd	s5,40(sp)
    24e8:	f05a                	sd	s6,32(sp)
    24ea:	ec5e                	sd	s7,24(sp)
    24ec:	1080                	addi	s0,sp,96
    24ee:	8aaa                	mv	s5,a0
  for (int ci = 0; ci < nchildren; ci++)
    24f0:	4981                	li	s3,0
    24f2:	4911                	li	s2,4
    int pid = fork();
    24f4:	00003097          	auipc	ra,0x3
    24f8:	6aa080e7          	jalr	1706(ra) # 5b9e <fork>
    24fc:	84aa                	mv	s1,a0
    if (pid < 0)
    24fe:	02054963          	bltz	a0,2530 <manywrites+0x58>
    if (pid == 0)
    2502:	c521                	beqz	a0,254a <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++)
    2504:	2985                	addiw	s3,s3,1
    2506:	ff2997e3          	bne	s3,s2,24f4 <manywrites+0x1c>
    250a:	4491                	li	s1,4
    int st = 0;
    250c:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2510:	fa840513          	addi	a0,s0,-88
    2514:	00003097          	auipc	ra,0x3
    2518:	69a080e7          	jalr	1690(ra) # 5bae <wait>
    if (st != 0)
    251c:	fa842503          	lw	a0,-88(s0)
    2520:	ed6d                	bnez	a0,261a <manywrites+0x142>
  for (int ci = 0; ci < nchildren; ci++)
    2522:	34fd                	addiw	s1,s1,-1
    2524:	f4e5                	bnez	s1,250c <manywrites+0x34>
  exit(0);
    2526:	4501                	li	a0,0
    2528:	00003097          	auipc	ra,0x3
    252c:	67e080e7          	jalr	1662(ra) # 5ba6 <exit>
      printf("fork failed\n");
    2530:	00005517          	auipc	a0,0x5
    2534:	85850513          	addi	a0,a0,-1960 # 6d88 <malloc+0xdc2>
    2538:	00004097          	auipc	ra,0x4
    253c:	9d6080e7          	jalr	-1578(ra) # 5f0e <printf>
      exit(1);
    2540:	4505                	li	a0,1
    2542:	00003097          	auipc	ra,0x3
    2546:	664080e7          	jalr	1636(ra) # 5ba6 <exit>
      name[0] = 'b';
    254a:	06200793          	li	a5,98
    254e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2552:	0619879b          	addiw	a5,s3,97
    2556:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    255a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    255e:	fa840513          	addi	a0,s0,-88
    2562:	00003097          	auipc	ra,0x3
    2566:	694080e7          	jalr	1684(ra) # 5bf6 <unlink>
    256a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    256c:	0000ab17          	auipc	s6,0xa
    2570:	70cb0b13          	addi	s6,s6,1804 # cc78 <buf>
        for (int i = 0; i < ci + 1; i++)
    2574:	8a26                	mv	s4,s1
    2576:	0209ce63          	bltz	s3,25b2 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    257a:	20200593          	li	a1,514
    257e:	fa840513          	addi	a0,s0,-88
    2582:	00003097          	auipc	ra,0x3
    2586:	664080e7          	jalr	1636(ra) # 5be6 <open>
    258a:	892a                	mv	s2,a0
          if (fd < 0)
    258c:	04054763          	bltz	a0,25da <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2590:	660d                	lui	a2,0x3
    2592:	85da                	mv	a1,s6
    2594:	00003097          	auipc	ra,0x3
    2598:	632080e7          	jalr	1586(ra) # 5bc6 <write>
          if (cc != sz)
    259c:	678d                	lui	a5,0x3
    259e:	04f51e63          	bne	a0,a5,25fa <manywrites+0x122>
          close(fd);
    25a2:	854a                	mv	a0,s2
    25a4:	00003097          	auipc	ra,0x3
    25a8:	62a080e7          	jalr	1578(ra) # 5bce <close>
        for (int i = 0; i < ci + 1; i++)
    25ac:	2a05                	addiw	s4,s4,1
    25ae:	fd49d6e3          	bge	s3,s4,257a <manywrites+0xa2>
        unlink(name);
    25b2:	fa840513          	addi	a0,s0,-88
    25b6:	00003097          	auipc	ra,0x3
    25ba:	640080e7          	jalr	1600(ra) # 5bf6 <unlink>
      for (int iters = 0; iters < howmany; iters++)
    25be:	3bfd                	addiw	s7,s7,-1
    25c0:	fa0b9ae3          	bnez	s7,2574 <manywrites+0x9c>
      unlink(name);
    25c4:	fa840513          	addi	a0,s0,-88
    25c8:	00003097          	auipc	ra,0x3
    25cc:	62e080e7          	jalr	1582(ra) # 5bf6 <unlink>
      exit(0);
    25d0:	4501                	li	a0,0
    25d2:	00003097          	auipc	ra,0x3
    25d6:	5d4080e7          	jalr	1492(ra) # 5ba6 <exit>
            printf("%s: cannot create %s\n", s, name);
    25da:	fa840613          	addi	a2,s0,-88
    25de:	85d6                	mv	a1,s5
    25e0:	00005517          	auipc	a0,0x5
    25e4:	80050513          	addi	a0,a0,-2048 # 6de0 <malloc+0xe1a>
    25e8:	00004097          	auipc	ra,0x4
    25ec:	926080e7          	jalr	-1754(ra) # 5f0e <printf>
            exit(1);
    25f0:	4505                	li	a0,1
    25f2:	00003097          	auipc	ra,0x3
    25f6:	5b4080e7          	jalr	1460(ra) # 5ba6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25fa:	86aa                	mv	a3,a0
    25fc:	660d                	lui	a2,0x3
    25fe:	85d6                	mv	a1,s5
    2600:	00004517          	auipc	a0,0x4
    2604:	bb850513          	addi	a0,a0,-1096 # 61b8 <malloc+0x1f2>
    2608:	00004097          	auipc	ra,0x4
    260c:	906080e7          	jalr	-1786(ra) # 5f0e <printf>
            exit(1);
    2610:	4505                	li	a0,1
    2612:	00003097          	auipc	ra,0x3
    2616:	594080e7          	jalr	1428(ra) # 5ba6 <exit>
      exit(st);
    261a:	00003097          	auipc	ra,0x3
    261e:	58c080e7          	jalr	1420(ra) # 5ba6 <exit>

0000000000002622 <copyinstr3>:
{
    2622:	7179                	addi	sp,sp,-48
    2624:	f406                	sd	ra,40(sp)
    2626:	f022                	sd	s0,32(sp)
    2628:	ec26                	sd	s1,24(sp)
    262a:	1800                	addi	s0,sp,48
  sbrk(8192);
    262c:	6509                	lui	a0,0x2
    262e:	00003097          	auipc	ra,0x3
    2632:	600080e7          	jalr	1536(ra) # 5c2e <sbrk>
  uint64 top = (uint64)sbrk(0);
    2636:	4501                	li	a0,0
    2638:	00003097          	auipc	ra,0x3
    263c:	5f6080e7          	jalr	1526(ra) # 5c2e <sbrk>
  if ((top % PGSIZE) != 0)
    2640:	03451793          	slli	a5,a0,0x34
    2644:	e3c9                	bnez	a5,26c6 <copyinstr3+0xa4>
  top = (uint64)sbrk(0);
    2646:	4501                	li	a0,0
    2648:	00003097          	auipc	ra,0x3
    264c:	5e6080e7          	jalr	1510(ra) # 5c2e <sbrk>
  if (top % PGSIZE)
    2650:	03451793          	slli	a5,a0,0x34
    2654:	e3d9                	bnez	a5,26da <copyinstr3+0xb8>
  char *b = (char *)(top - 1);
    2656:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x5b>
  *b = 'x';
    265a:	07800793          	li	a5,120
    265e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2662:	8526                	mv	a0,s1
    2664:	00003097          	auipc	ra,0x3
    2668:	592080e7          	jalr	1426(ra) # 5bf6 <unlink>
  if (ret != -1)
    266c:	57fd                	li	a5,-1
    266e:	08f51363          	bne	a0,a5,26f4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2672:	20100593          	li	a1,513
    2676:	8526                	mv	a0,s1
    2678:	00003097          	auipc	ra,0x3
    267c:	56e080e7          	jalr	1390(ra) # 5be6 <open>
  if (fd != -1)
    2680:	57fd                	li	a5,-1
    2682:	08f51863          	bne	a0,a5,2712 <copyinstr3+0xf0>
  ret = link(b, b);
    2686:	85a6                	mv	a1,s1
    2688:	8526                	mv	a0,s1
    268a:	00003097          	auipc	ra,0x3
    268e:	57c080e7          	jalr	1404(ra) # 5c06 <link>
  if (ret != -1)
    2692:	57fd                	li	a5,-1
    2694:	08f51e63          	bne	a0,a5,2730 <copyinstr3+0x10e>
  char *args[] = {"xx", 0};
    2698:	00005797          	auipc	a5,0x5
    269c:	44078793          	addi	a5,a5,1088 # 7ad8 <malloc+0x1b12>
    26a0:	fcf43823          	sd	a5,-48(s0)
    26a4:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    26a8:	fd040593          	addi	a1,s0,-48
    26ac:	8526                	mv	a0,s1
    26ae:	00003097          	auipc	ra,0x3
    26b2:	530080e7          	jalr	1328(ra) # 5bde <exec>
  if (ret != -1)
    26b6:	57fd                	li	a5,-1
    26b8:	08f51c63          	bne	a0,a5,2750 <copyinstr3+0x12e>
}
    26bc:	70a2                	ld	ra,40(sp)
    26be:	7402                	ld	s0,32(sp)
    26c0:	64e2                	ld	s1,24(sp)
    26c2:	6145                	addi	sp,sp,48
    26c4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26c6:	0347d513          	srli	a0,a5,0x34
    26ca:	6785                	lui	a5,0x1
    26cc:	40a7853b          	subw	a0,a5,a0
    26d0:	00003097          	auipc	ra,0x3
    26d4:	55e080e7          	jalr	1374(ra) # 5c2e <sbrk>
    26d8:	b7bd                	j	2646 <copyinstr3+0x24>
    printf("oops\n");
    26da:	00004517          	auipc	a0,0x4
    26de:	71e50513          	addi	a0,a0,1822 # 6df8 <malloc+0xe32>
    26e2:	00004097          	auipc	ra,0x4
    26e6:	82c080e7          	jalr	-2004(ra) # 5f0e <printf>
    exit(1);
    26ea:	4505                	li	a0,1
    26ec:	00003097          	auipc	ra,0x3
    26f0:	4ba080e7          	jalr	1210(ra) # 5ba6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26f4:	862a                	mv	a2,a0
    26f6:	85a6                	mv	a1,s1
    26f8:	00004517          	auipc	a0,0x4
    26fc:	1a850513          	addi	a0,a0,424 # 68a0 <malloc+0x8da>
    2700:	00004097          	auipc	ra,0x4
    2704:	80e080e7          	jalr	-2034(ra) # 5f0e <printf>
    exit(1);
    2708:	4505                	li	a0,1
    270a:	00003097          	auipc	ra,0x3
    270e:	49c080e7          	jalr	1180(ra) # 5ba6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2712:	862a                	mv	a2,a0
    2714:	85a6                	mv	a1,s1
    2716:	00004517          	auipc	a0,0x4
    271a:	1aa50513          	addi	a0,a0,426 # 68c0 <malloc+0x8fa>
    271e:	00003097          	auipc	ra,0x3
    2722:	7f0080e7          	jalr	2032(ra) # 5f0e <printf>
    exit(1);
    2726:	4505                	li	a0,1
    2728:	00003097          	auipc	ra,0x3
    272c:	47e080e7          	jalr	1150(ra) # 5ba6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2730:	86aa                	mv	a3,a0
    2732:	8626                	mv	a2,s1
    2734:	85a6                	mv	a1,s1
    2736:	00004517          	auipc	a0,0x4
    273a:	1aa50513          	addi	a0,a0,426 # 68e0 <malloc+0x91a>
    273e:	00003097          	auipc	ra,0x3
    2742:	7d0080e7          	jalr	2000(ra) # 5f0e <printf>
    exit(1);
    2746:	4505                	li	a0,1
    2748:	00003097          	auipc	ra,0x3
    274c:	45e080e7          	jalr	1118(ra) # 5ba6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2750:	567d                	li	a2,-1
    2752:	85a6                	mv	a1,s1
    2754:	00004517          	auipc	a0,0x4
    2758:	1b450513          	addi	a0,a0,436 # 6908 <malloc+0x942>
    275c:	00003097          	auipc	ra,0x3
    2760:	7b2080e7          	jalr	1970(ra) # 5f0e <printf>
    exit(1);
    2764:	4505                	li	a0,1
    2766:	00003097          	auipc	ra,0x3
    276a:	440080e7          	jalr	1088(ra) # 5ba6 <exit>

000000000000276e <rwsbrk>:
{
    276e:	1101                	addi	sp,sp,-32
    2770:	ec06                	sd	ra,24(sp)
    2772:	e822                	sd	s0,16(sp)
    2774:	e426                	sd	s1,8(sp)
    2776:	e04a                	sd	s2,0(sp)
    2778:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    277a:	6509                	lui	a0,0x2
    277c:	00003097          	auipc	ra,0x3
    2780:	4b2080e7          	jalr	1202(ra) # 5c2e <sbrk>
  if (a == 0xffffffffffffffffLL)
    2784:	57fd                	li	a5,-1
    2786:	06f50263          	beq	a0,a5,27ea <rwsbrk+0x7c>
    278a:	84aa                	mv	s1,a0
  if ((uint64)sbrk(-8192) == 0xffffffffffffffffLL)
    278c:	7579                	lui	a0,0xffffe
    278e:	00003097          	auipc	ra,0x3
    2792:	4a0080e7          	jalr	1184(ra) # 5c2e <sbrk>
    2796:	57fd                	li	a5,-1
    2798:	06f50663          	beq	a0,a5,2804 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    279c:	20100593          	li	a1,513
    27a0:	00004517          	auipc	a0,0x4
    27a4:	69850513          	addi	a0,a0,1688 # 6e38 <malloc+0xe72>
    27a8:	00003097          	auipc	ra,0x3
    27ac:	43e080e7          	jalr	1086(ra) # 5be6 <open>
    27b0:	892a                	mv	s2,a0
  if (fd < 0)
    27b2:	06054663          	bltz	a0,281e <rwsbrk+0xb0>
  n = write(fd, (void *)(a + 4096), 1024);
    27b6:	6785                	lui	a5,0x1
    27b8:	94be                	add	s1,s1,a5
    27ba:	40000613          	li	a2,1024
    27be:	85a6                	mv	a1,s1
    27c0:	00003097          	auipc	ra,0x3
    27c4:	406080e7          	jalr	1030(ra) # 5bc6 <write>
    27c8:	862a                	mv	a2,a0
  if (n >= 0)
    27ca:	06054763          	bltz	a0,2838 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a + 4096, n);
    27ce:	85a6                	mv	a1,s1
    27d0:	00004517          	auipc	a0,0x4
    27d4:	68850513          	addi	a0,a0,1672 # 6e58 <malloc+0xe92>
    27d8:	00003097          	auipc	ra,0x3
    27dc:	736080e7          	jalr	1846(ra) # 5f0e <printf>
    exit(1);
    27e0:	4505                	li	a0,1
    27e2:	00003097          	auipc	ra,0x3
    27e6:	3c4080e7          	jalr	964(ra) # 5ba6 <exit>
    printf("sbrk(rwsbrk) failed\n");
    27ea:	00004517          	auipc	a0,0x4
    27ee:	61650513          	addi	a0,a0,1558 # 6e00 <malloc+0xe3a>
    27f2:	00003097          	auipc	ra,0x3
    27f6:	71c080e7          	jalr	1820(ra) # 5f0e <printf>
    exit(1);
    27fa:	4505                	li	a0,1
    27fc:	00003097          	auipc	ra,0x3
    2800:	3aa080e7          	jalr	938(ra) # 5ba6 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2804:	00004517          	auipc	a0,0x4
    2808:	61450513          	addi	a0,a0,1556 # 6e18 <malloc+0xe52>
    280c:	00003097          	auipc	ra,0x3
    2810:	702080e7          	jalr	1794(ra) # 5f0e <printf>
    exit(1);
    2814:	4505                	li	a0,1
    2816:	00003097          	auipc	ra,0x3
    281a:	390080e7          	jalr	912(ra) # 5ba6 <exit>
    printf("open(rwsbrk) failed\n");
    281e:	00004517          	auipc	a0,0x4
    2822:	62250513          	addi	a0,a0,1570 # 6e40 <malloc+0xe7a>
    2826:	00003097          	auipc	ra,0x3
    282a:	6e8080e7          	jalr	1768(ra) # 5f0e <printf>
    exit(1);
    282e:	4505                	li	a0,1
    2830:	00003097          	auipc	ra,0x3
    2834:	376080e7          	jalr	886(ra) # 5ba6 <exit>
  close(fd);
    2838:	854a                	mv	a0,s2
    283a:	00003097          	auipc	ra,0x3
    283e:	394080e7          	jalr	916(ra) # 5bce <close>
  unlink("rwsbrk");
    2842:	00004517          	auipc	a0,0x4
    2846:	5f650513          	addi	a0,a0,1526 # 6e38 <malloc+0xe72>
    284a:	00003097          	auipc	ra,0x3
    284e:	3ac080e7          	jalr	940(ra) # 5bf6 <unlink>
  fd = open("README", O_RDONLY);
    2852:	4581                	li	a1,0
    2854:	00004517          	auipc	a0,0x4
    2858:	a6c50513          	addi	a0,a0,-1428 # 62c0 <malloc+0x2fa>
    285c:	00003097          	auipc	ra,0x3
    2860:	38a080e7          	jalr	906(ra) # 5be6 <open>
    2864:	892a                	mv	s2,a0
  if (fd < 0)
    2866:	02054963          	bltz	a0,2898 <rwsbrk+0x12a>
  n = read(fd, (void *)(a + 4096), 10);
    286a:	4629                	li	a2,10
    286c:	85a6                	mv	a1,s1
    286e:	00003097          	auipc	ra,0x3
    2872:	350080e7          	jalr	848(ra) # 5bbe <read>
    2876:	862a                	mv	a2,a0
  if (n >= 0)
    2878:	02054d63          	bltz	a0,28b2 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a + 4096, n);
    287c:	85a6                	mv	a1,s1
    287e:	00004517          	auipc	a0,0x4
    2882:	60a50513          	addi	a0,a0,1546 # 6e88 <malloc+0xec2>
    2886:	00003097          	auipc	ra,0x3
    288a:	688080e7          	jalr	1672(ra) # 5f0e <printf>
    exit(1);
    288e:	4505                	li	a0,1
    2890:	00003097          	auipc	ra,0x3
    2894:	316080e7          	jalr	790(ra) # 5ba6 <exit>
    printf("open(rwsbrk) failed\n");
    2898:	00004517          	auipc	a0,0x4
    289c:	5a850513          	addi	a0,a0,1448 # 6e40 <malloc+0xe7a>
    28a0:	00003097          	auipc	ra,0x3
    28a4:	66e080e7          	jalr	1646(ra) # 5f0e <printf>
    exit(1);
    28a8:	4505                	li	a0,1
    28aa:	00003097          	auipc	ra,0x3
    28ae:	2fc080e7          	jalr	764(ra) # 5ba6 <exit>
  close(fd);
    28b2:	854a                	mv	a0,s2
    28b4:	00003097          	auipc	ra,0x3
    28b8:	31a080e7          	jalr	794(ra) # 5bce <close>
  exit(0);
    28bc:	4501                	li	a0,0
    28be:	00003097          	auipc	ra,0x3
    28c2:	2e8080e7          	jalr	744(ra) # 5ba6 <exit>

00000000000028c6 <sbrkbasic>:
{
    28c6:	7139                	addi	sp,sp,-64
    28c8:	fc06                	sd	ra,56(sp)
    28ca:	f822                	sd	s0,48(sp)
    28cc:	f426                	sd	s1,40(sp)
    28ce:	f04a                	sd	s2,32(sp)
    28d0:	ec4e                	sd	s3,24(sp)
    28d2:	e852                	sd	s4,16(sp)
    28d4:	0080                	addi	s0,sp,64
    28d6:	8a2a                	mv	s4,a0
  pid = fork();
    28d8:	00003097          	auipc	ra,0x3
    28dc:	2c6080e7          	jalr	710(ra) # 5b9e <fork>
  if (pid < 0)
    28e0:	02054c63          	bltz	a0,2918 <sbrkbasic+0x52>
  if (pid == 0)
    28e4:	ed21                	bnez	a0,293c <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    28e6:	40000537          	lui	a0,0x40000
    28ea:	00003097          	auipc	ra,0x3
    28ee:	344080e7          	jalr	836(ra) # 5c2e <sbrk>
    if (a == (char *)0xffffffffffffffffL)
    28f2:	57fd                	li	a5,-1
    28f4:	02f50f63          	beq	a0,a5,2932 <sbrkbasic+0x6c>
    for (b = a; b < a + TOOMUCH; b += 4096)
    28f8:	400007b7          	lui	a5,0x40000
    28fc:	97aa                	add	a5,a5,a0
      *b = 99;
    28fe:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += 4096)
    2902:	6705                	lui	a4,0x1
      *b = 99;
    2904:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for (b = a; b < a + TOOMUCH; b += 4096)
    2908:	953a                	add	a0,a0,a4
    290a:	fef51de3          	bne	a0,a5,2904 <sbrkbasic+0x3e>
    exit(1);
    290e:	4505                	li	a0,1
    2910:	00003097          	auipc	ra,0x3
    2914:	296080e7          	jalr	662(ra) # 5ba6 <exit>
    printf("fork failed in sbrkbasic\n");
    2918:	00004517          	auipc	a0,0x4
    291c:	59850513          	addi	a0,a0,1432 # 6eb0 <malloc+0xeea>
    2920:	00003097          	auipc	ra,0x3
    2924:	5ee080e7          	jalr	1518(ra) # 5f0e <printf>
    exit(1);
    2928:	4505                	li	a0,1
    292a:	00003097          	auipc	ra,0x3
    292e:	27c080e7          	jalr	636(ra) # 5ba6 <exit>
      exit(0);
    2932:	4501                	li	a0,0
    2934:	00003097          	auipc	ra,0x3
    2938:	272080e7          	jalr	626(ra) # 5ba6 <exit>
  wait(&xstatus);
    293c:	fcc40513          	addi	a0,s0,-52
    2940:	00003097          	auipc	ra,0x3
    2944:	26e080e7          	jalr	622(ra) # 5bae <wait>
  if (xstatus == 1)
    2948:	fcc42703          	lw	a4,-52(s0)
    294c:	4785                	li	a5,1
    294e:	00f70d63          	beq	a4,a5,2968 <sbrkbasic+0xa2>
  a = sbrk(0);
    2952:	4501                	li	a0,0
    2954:	00003097          	auipc	ra,0x3
    2958:	2da080e7          	jalr	730(ra) # 5c2e <sbrk>
    295c:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++)
    295e:	4901                	li	s2,0
    2960:	6985                	lui	s3,0x1
    2962:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x26>
    2966:	a005                	j	2986 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2968:	85d2                	mv	a1,s4
    296a:	00004517          	auipc	a0,0x4
    296e:	56650513          	addi	a0,a0,1382 # 6ed0 <malloc+0xf0a>
    2972:	00003097          	auipc	ra,0x3
    2976:	59c080e7          	jalr	1436(ra) # 5f0e <printf>
    exit(1);
    297a:	4505                	li	a0,1
    297c:	00003097          	auipc	ra,0x3
    2980:	22a080e7          	jalr	554(ra) # 5ba6 <exit>
    a = b + 1;
    2984:	84be                	mv	s1,a5
    b = sbrk(1);
    2986:	4505                	li	a0,1
    2988:	00003097          	auipc	ra,0x3
    298c:	2a6080e7          	jalr	678(ra) # 5c2e <sbrk>
    if (b != a)
    2990:	04951c63          	bne	a0,s1,29e8 <sbrkbasic+0x122>
    *b = 1;
    2994:	4785                	li	a5,1
    2996:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    299a:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++)
    299e:	2905                	addiw	s2,s2,1
    29a0:	ff3912e3          	bne	s2,s3,2984 <sbrkbasic+0xbe>
  pid = fork();
    29a4:	00003097          	auipc	ra,0x3
    29a8:	1fa080e7          	jalr	506(ra) # 5b9e <fork>
    29ac:	892a                	mv	s2,a0
  if (pid < 0)
    29ae:	04054e63          	bltz	a0,2a0a <sbrkbasic+0x144>
  c = sbrk(1);
    29b2:	4505                	li	a0,1
    29b4:	00003097          	auipc	ra,0x3
    29b8:	27a080e7          	jalr	634(ra) # 5c2e <sbrk>
  c = sbrk(1);
    29bc:	4505                	li	a0,1
    29be:	00003097          	auipc	ra,0x3
    29c2:	270080e7          	jalr	624(ra) # 5c2e <sbrk>
  if (c != a + 1)
    29c6:	0489                	addi	s1,s1,2
    29c8:	04a48f63          	beq	s1,a0,2a26 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    29cc:	85d2                	mv	a1,s4
    29ce:	00004517          	auipc	a0,0x4
    29d2:	56250513          	addi	a0,a0,1378 # 6f30 <malloc+0xf6a>
    29d6:	00003097          	auipc	ra,0x3
    29da:	538080e7          	jalr	1336(ra) # 5f0e <printf>
    exit(1);
    29de:	4505                	li	a0,1
    29e0:	00003097          	auipc	ra,0x3
    29e4:	1c6080e7          	jalr	454(ra) # 5ba6 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29e8:	872a                	mv	a4,a0
    29ea:	86a6                	mv	a3,s1
    29ec:	864a                	mv	a2,s2
    29ee:	85d2                	mv	a1,s4
    29f0:	00004517          	auipc	a0,0x4
    29f4:	50050513          	addi	a0,a0,1280 # 6ef0 <malloc+0xf2a>
    29f8:	00003097          	auipc	ra,0x3
    29fc:	516080e7          	jalr	1302(ra) # 5f0e <printf>
      exit(1);
    2a00:	4505                	li	a0,1
    2a02:	00003097          	auipc	ra,0x3
    2a06:	1a4080e7          	jalr	420(ra) # 5ba6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2a0a:	85d2                	mv	a1,s4
    2a0c:	00004517          	auipc	a0,0x4
    2a10:	50450513          	addi	a0,a0,1284 # 6f10 <malloc+0xf4a>
    2a14:	00003097          	auipc	ra,0x3
    2a18:	4fa080e7          	jalr	1274(ra) # 5f0e <printf>
    exit(1);
    2a1c:	4505                	li	a0,1
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	188080e7          	jalr	392(ra) # 5ba6 <exit>
  if (pid == 0)
    2a26:	00091763          	bnez	s2,2a34 <sbrkbasic+0x16e>
    exit(0);
    2a2a:	4501                	li	a0,0
    2a2c:	00003097          	auipc	ra,0x3
    2a30:	17a080e7          	jalr	378(ra) # 5ba6 <exit>
  wait(&xstatus);
    2a34:	fcc40513          	addi	a0,s0,-52
    2a38:	00003097          	auipc	ra,0x3
    2a3c:	176080e7          	jalr	374(ra) # 5bae <wait>
  exit(xstatus);
    2a40:	fcc42503          	lw	a0,-52(s0)
    2a44:	00003097          	auipc	ra,0x3
    2a48:	162080e7          	jalr	354(ra) # 5ba6 <exit>

0000000000002a4c <sbrkmuch>:
{
    2a4c:	7179                	addi	sp,sp,-48
    2a4e:	f406                	sd	ra,40(sp)
    2a50:	f022                	sd	s0,32(sp)
    2a52:	ec26                	sd	s1,24(sp)
    2a54:	e84a                	sd	s2,16(sp)
    2a56:	e44e                	sd	s3,8(sp)
    2a58:	e052                	sd	s4,0(sp)
    2a5a:	1800                	addi	s0,sp,48
    2a5c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a5e:	4501                	li	a0,0
    2a60:	00003097          	auipc	ra,0x3
    2a64:	1ce080e7          	jalr	462(ra) # 5c2e <sbrk>
    2a68:	892a                	mv	s2,a0
  a = sbrk(0);
    2a6a:	4501                	li	a0,0
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	1c2080e7          	jalr	450(ra) # 5c2e <sbrk>
    2a74:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a76:	06400537          	lui	a0,0x6400
    2a7a:	9d05                	subw	a0,a0,s1
    2a7c:	00003097          	auipc	ra,0x3
    2a80:	1b2080e7          	jalr	434(ra) # 5c2e <sbrk>
  if (p != a)
    2a84:	0ca49863          	bne	s1,a0,2b54 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a88:	4501                	li	a0,0
    2a8a:	00003097          	auipc	ra,0x3
    2a8e:	1a4080e7          	jalr	420(ra) # 5c2e <sbrk>
    2a92:	87aa                	mv	a5,a0
  for (char *pp = a; pp < eee; pp += 4096)
    2a94:	00a4f963          	bgeu	s1,a0,2aa6 <sbrkmuch+0x5a>
    *pp = 1;
    2a98:	4685                	li	a3,1
  for (char *pp = a; pp < eee; pp += 4096)
    2a9a:	6705                	lui	a4,0x1
    *pp = 1;
    2a9c:	00d48023          	sb	a3,0(s1)
  for (char *pp = a; pp < eee; pp += 4096)
    2aa0:	94ba                	add	s1,s1,a4
    2aa2:	fef4ede3          	bltu	s1,a5,2a9c <sbrkmuch+0x50>
  *lastaddr = 99;
    2aa6:	064007b7          	lui	a5,0x6400
    2aaa:	06300713          	li	a4,99
    2aae:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2ab2:	4501                	li	a0,0
    2ab4:	00003097          	auipc	ra,0x3
    2ab8:	17a080e7          	jalr	378(ra) # 5c2e <sbrk>
    2abc:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2abe:	757d                	lui	a0,0xfffff
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	16e080e7          	jalr	366(ra) # 5c2e <sbrk>
  if (c == (char *)0xffffffffffffffffL)
    2ac8:	57fd                	li	a5,-1
    2aca:	0af50363          	beq	a0,a5,2b70 <sbrkmuch+0x124>
  c = sbrk(0);
    2ace:	4501                	li	a0,0
    2ad0:	00003097          	auipc	ra,0x3
    2ad4:	15e080e7          	jalr	350(ra) # 5c2e <sbrk>
  if (c != a - PGSIZE)
    2ad8:	77fd                	lui	a5,0xfffff
    2ada:	97a6                	add	a5,a5,s1
    2adc:	0af51863          	bne	a0,a5,2b8c <sbrkmuch+0x140>
  a = sbrk(0);
    2ae0:	4501                	li	a0,0
    2ae2:	00003097          	auipc	ra,0x3
    2ae6:	14c080e7          	jalr	332(ra) # 5c2e <sbrk>
    2aea:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2aec:	6505                	lui	a0,0x1
    2aee:	00003097          	auipc	ra,0x3
    2af2:	140080e7          	jalr	320(ra) # 5c2e <sbrk>
    2af6:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE)
    2af8:	0aa49a63          	bne	s1,a0,2bac <sbrkmuch+0x160>
    2afc:	4501                	li	a0,0
    2afe:	00003097          	auipc	ra,0x3
    2b02:	130080e7          	jalr	304(ra) # 5c2e <sbrk>
    2b06:	6785                	lui	a5,0x1
    2b08:	97a6                	add	a5,a5,s1
    2b0a:	0af51163          	bne	a0,a5,2bac <sbrkmuch+0x160>
  if (*lastaddr == 99)
    2b0e:	064007b7          	lui	a5,0x6400
    2b12:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b16:	06300793          	li	a5,99
    2b1a:	0af70963          	beq	a4,a5,2bcc <sbrkmuch+0x180>
  a = sbrk(0);
    2b1e:	4501                	li	a0,0
    2b20:	00003097          	auipc	ra,0x3
    2b24:	10e080e7          	jalr	270(ra) # 5c2e <sbrk>
    2b28:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b2a:	4501                	li	a0,0
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	102080e7          	jalr	258(ra) # 5c2e <sbrk>
    2b34:	40a9053b          	subw	a0,s2,a0
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	0f6080e7          	jalr	246(ra) # 5c2e <sbrk>
  if (c != a)
    2b40:	0aa49463          	bne	s1,a0,2be8 <sbrkmuch+0x19c>
}
    2b44:	70a2                	ld	ra,40(sp)
    2b46:	7402                	ld	s0,32(sp)
    2b48:	64e2                	ld	s1,24(sp)
    2b4a:	6942                	ld	s2,16(sp)
    2b4c:	69a2                	ld	s3,8(sp)
    2b4e:	6a02                	ld	s4,0(sp)
    2b50:	6145                	addi	sp,sp,48
    2b52:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b54:	85ce                	mv	a1,s3
    2b56:	00004517          	auipc	a0,0x4
    2b5a:	3fa50513          	addi	a0,a0,1018 # 6f50 <malloc+0xf8a>
    2b5e:	00003097          	auipc	ra,0x3
    2b62:	3b0080e7          	jalr	944(ra) # 5f0e <printf>
    exit(1);
    2b66:	4505                	li	a0,1
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	03e080e7          	jalr	62(ra) # 5ba6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b70:	85ce                	mv	a1,s3
    2b72:	00004517          	auipc	a0,0x4
    2b76:	42650513          	addi	a0,a0,1062 # 6f98 <malloc+0xfd2>
    2b7a:	00003097          	auipc	ra,0x3
    2b7e:	394080e7          	jalr	916(ra) # 5f0e <printf>
    exit(1);
    2b82:	4505                	li	a0,1
    2b84:	00003097          	auipc	ra,0x3
    2b88:	022080e7          	jalr	34(ra) # 5ba6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b8c:	86aa                	mv	a3,a0
    2b8e:	8626                	mv	a2,s1
    2b90:	85ce                	mv	a1,s3
    2b92:	00004517          	auipc	a0,0x4
    2b96:	42650513          	addi	a0,a0,1062 # 6fb8 <malloc+0xff2>
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	374080e7          	jalr	884(ra) # 5f0e <printf>
    exit(1);
    2ba2:	4505                	li	a0,1
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	002080e7          	jalr	2(ra) # 5ba6 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2bac:	86d2                	mv	a3,s4
    2bae:	8626                	mv	a2,s1
    2bb0:	85ce                	mv	a1,s3
    2bb2:	00004517          	auipc	a0,0x4
    2bb6:	44650513          	addi	a0,a0,1094 # 6ff8 <malloc+0x1032>
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	354080e7          	jalr	852(ra) # 5f0e <printf>
    exit(1);
    2bc2:	4505                	li	a0,1
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	fe2080e7          	jalr	-30(ra) # 5ba6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bcc:	85ce                	mv	a1,s3
    2bce:	00004517          	auipc	a0,0x4
    2bd2:	45a50513          	addi	a0,a0,1114 # 7028 <malloc+0x1062>
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	338080e7          	jalr	824(ra) # 5f0e <printf>
    exit(1);
    2bde:	4505                	li	a0,1
    2be0:	00003097          	auipc	ra,0x3
    2be4:	fc6080e7          	jalr	-58(ra) # 5ba6 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2be8:	86aa                	mv	a3,a0
    2bea:	8626                	mv	a2,s1
    2bec:	85ce                	mv	a1,s3
    2bee:	00004517          	auipc	a0,0x4
    2bf2:	47250513          	addi	a0,a0,1138 # 7060 <malloc+0x109a>
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	318080e7          	jalr	792(ra) # 5f0e <printf>
    exit(1);
    2bfe:	4505                	li	a0,1
    2c00:	00003097          	auipc	ra,0x3
    2c04:	fa6080e7          	jalr	-90(ra) # 5ba6 <exit>

0000000000002c08 <sbrkarg>:
{
    2c08:	7179                	addi	sp,sp,-48
    2c0a:	f406                	sd	ra,40(sp)
    2c0c:	f022                	sd	s0,32(sp)
    2c0e:	ec26                	sd	s1,24(sp)
    2c10:	e84a                	sd	s2,16(sp)
    2c12:	e44e                	sd	s3,8(sp)
    2c14:	1800                	addi	s0,sp,48
    2c16:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c18:	6505                	lui	a0,0x1
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	014080e7          	jalr	20(ra) # 5c2e <sbrk>
    2c22:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2c24:	20100593          	li	a1,513
    2c28:	00004517          	auipc	a0,0x4
    2c2c:	46050513          	addi	a0,a0,1120 # 7088 <malloc+0x10c2>
    2c30:	00003097          	auipc	ra,0x3
    2c34:	fb6080e7          	jalr	-74(ra) # 5be6 <open>
    2c38:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c3a:	00004517          	auipc	a0,0x4
    2c3e:	44e50513          	addi	a0,a0,1102 # 7088 <malloc+0x10c2>
    2c42:	00003097          	auipc	ra,0x3
    2c46:	fb4080e7          	jalr	-76(ra) # 5bf6 <unlink>
  if (fd < 0)
    2c4a:	0404c163          	bltz	s1,2c8c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0)
    2c4e:	6605                	lui	a2,0x1
    2c50:	85ca                	mv	a1,s2
    2c52:	8526                	mv	a0,s1
    2c54:	00003097          	auipc	ra,0x3
    2c58:	f72080e7          	jalr	-142(ra) # 5bc6 <write>
    2c5c:	04054663          	bltz	a0,2ca8 <sbrkarg+0xa0>
  close(fd);
    2c60:	8526                	mv	a0,s1
    2c62:	00003097          	auipc	ra,0x3
    2c66:	f6c080e7          	jalr	-148(ra) # 5bce <close>
  a = sbrk(PGSIZE);
    2c6a:	6505                	lui	a0,0x1
    2c6c:	00003097          	auipc	ra,0x3
    2c70:	fc2080e7          	jalr	-62(ra) # 5c2e <sbrk>
  if (pipe((int *)a) != 0)
    2c74:	00003097          	auipc	ra,0x3
    2c78:	f42080e7          	jalr	-190(ra) # 5bb6 <pipe>
    2c7c:	e521                	bnez	a0,2cc4 <sbrkarg+0xbc>
}
    2c7e:	70a2                	ld	ra,40(sp)
    2c80:	7402                	ld	s0,32(sp)
    2c82:	64e2                	ld	s1,24(sp)
    2c84:	6942                	ld	s2,16(sp)
    2c86:	69a2                	ld	s3,8(sp)
    2c88:	6145                	addi	sp,sp,48
    2c8a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c8c:	85ce                	mv	a1,s3
    2c8e:	00004517          	auipc	a0,0x4
    2c92:	40250513          	addi	a0,a0,1026 # 7090 <malloc+0x10ca>
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	278080e7          	jalr	632(ra) # 5f0e <printf>
    exit(1);
    2c9e:	4505                	li	a0,1
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	f06080e7          	jalr	-250(ra) # 5ba6 <exit>
    printf("%s: write sbrk failed\n", s);
    2ca8:	85ce                	mv	a1,s3
    2caa:	00004517          	auipc	a0,0x4
    2cae:	3fe50513          	addi	a0,a0,1022 # 70a8 <malloc+0x10e2>
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	25c080e7          	jalr	604(ra) # 5f0e <printf>
    exit(1);
    2cba:	4505                	li	a0,1
    2cbc:	00003097          	auipc	ra,0x3
    2cc0:	eea080e7          	jalr	-278(ra) # 5ba6 <exit>
    printf("%s: pipe() failed\n", s);
    2cc4:	85ce                	mv	a1,s3
    2cc6:	00004517          	auipc	a0,0x4
    2cca:	dc250513          	addi	a0,a0,-574 # 6a88 <malloc+0xac2>
    2cce:	00003097          	auipc	ra,0x3
    2cd2:	240080e7          	jalr	576(ra) # 5f0e <printf>
    exit(1);
    2cd6:	4505                	li	a0,1
    2cd8:	00003097          	auipc	ra,0x3
    2cdc:	ece080e7          	jalr	-306(ra) # 5ba6 <exit>

0000000000002ce0 <argptest>:
{
    2ce0:	1101                	addi	sp,sp,-32
    2ce2:	ec06                	sd	ra,24(sp)
    2ce4:	e822                	sd	s0,16(sp)
    2ce6:	e426                	sd	s1,8(sp)
    2ce8:	e04a                	sd	s2,0(sp)
    2cea:	1000                	addi	s0,sp,32
    2cec:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cee:	4581                	li	a1,0
    2cf0:	00004517          	auipc	a0,0x4
    2cf4:	3d050513          	addi	a0,a0,976 # 70c0 <malloc+0x10fa>
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	eee080e7          	jalr	-274(ra) # 5be6 <open>
  if (fd < 0)
    2d00:	02054b63          	bltz	a0,2d36 <argptest+0x56>
    2d04:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2d06:	4501                	li	a0,0
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	f26080e7          	jalr	-218(ra) # 5c2e <sbrk>
    2d10:	567d                	li	a2,-1
    2d12:	fff50593          	addi	a1,a0,-1
    2d16:	8526                	mv	a0,s1
    2d18:	00003097          	auipc	ra,0x3
    2d1c:	ea6080e7          	jalr	-346(ra) # 5bbe <read>
  close(fd);
    2d20:	8526                	mv	a0,s1
    2d22:	00003097          	auipc	ra,0x3
    2d26:	eac080e7          	jalr	-340(ra) # 5bce <close>
}
    2d2a:	60e2                	ld	ra,24(sp)
    2d2c:	6442                	ld	s0,16(sp)
    2d2e:	64a2                	ld	s1,8(sp)
    2d30:	6902                	ld	s2,0(sp)
    2d32:	6105                	addi	sp,sp,32
    2d34:	8082                	ret
    printf("%s: open failed\n", s);
    2d36:	85ca                	mv	a1,s2
    2d38:	00004517          	auipc	a0,0x4
    2d3c:	c6050513          	addi	a0,a0,-928 # 6998 <malloc+0x9d2>
    2d40:	00003097          	auipc	ra,0x3
    2d44:	1ce080e7          	jalr	462(ra) # 5f0e <printf>
    exit(1);
    2d48:	4505                	li	a0,1
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	e5c080e7          	jalr	-420(ra) # 5ba6 <exit>

0000000000002d52 <sbrkbugs>:
{
    2d52:	1141                	addi	sp,sp,-16
    2d54:	e406                	sd	ra,8(sp)
    2d56:	e022                	sd	s0,0(sp)
    2d58:	0800                	addi	s0,sp,16
  int pid = fork();
    2d5a:	00003097          	auipc	ra,0x3
    2d5e:	e44080e7          	jalr	-444(ra) # 5b9e <fork>
  if (pid < 0)
    2d62:	02054263          	bltz	a0,2d86 <sbrkbugs+0x34>
  if (pid == 0)
    2d66:	ed0d                	bnez	a0,2da0 <sbrkbugs+0x4e>
    int sz = (uint64)sbrk(0);
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	ec6080e7          	jalr	-314(ra) # 5c2e <sbrk>
    sbrk(-sz);
    2d70:	40a0053b          	negw	a0,a0
    2d74:	00003097          	auipc	ra,0x3
    2d78:	eba080e7          	jalr	-326(ra) # 5c2e <sbrk>
    exit(0);
    2d7c:	4501                	li	a0,0
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	e28080e7          	jalr	-472(ra) # 5ba6 <exit>
    printf("fork failed\n");
    2d86:	00004517          	auipc	a0,0x4
    2d8a:	00250513          	addi	a0,a0,2 # 6d88 <malloc+0xdc2>
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	180080e7          	jalr	384(ra) # 5f0e <printf>
    exit(1);
    2d96:	4505                	li	a0,1
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	e0e080e7          	jalr	-498(ra) # 5ba6 <exit>
  wait(0);
    2da0:	4501                	li	a0,0
    2da2:	00003097          	auipc	ra,0x3
    2da6:	e0c080e7          	jalr	-500(ra) # 5bae <wait>
  pid = fork();
    2daa:	00003097          	auipc	ra,0x3
    2dae:	df4080e7          	jalr	-524(ra) # 5b9e <fork>
  if (pid < 0)
    2db2:	02054563          	bltz	a0,2ddc <sbrkbugs+0x8a>
  if (pid == 0)
    2db6:	e121                	bnez	a0,2df6 <sbrkbugs+0xa4>
    int sz = (uint64)sbrk(0);
    2db8:	00003097          	auipc	ra,0x3
    2dbc:	e76080e7          	jalr	-394(ra) # 5c2e <sbrk>
    sbrk(-(sz - 3500));
    2dc0:	6785                	lui	a5,0x1
    2dc2:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6e>
    2dc6:	40a7853b          	subw	a0,a5,a0
    2dca:	00003097          	auipc	ra,0x3
    2dce:	e64080e7          	jalr	-412(ra) # 5c2e <sbrk>
    exit(0);
    2dd2:	4501                	li	a0,0
    2dd4:	00003097          	auipc	ra,0x3
    2dd8:	dd2080e7          	jalr	-558(ra) # 5ba6 <exit>
    printf("fork failed\n");
    2ddc:	00004517          	auipc	a0,0x4
    2de0:	fac50513          	addi	a0,a0,-84 # 6d88 <malloc+0xdc2>
    2de4:	00003097          	auipc	ra,0x3
    2de8:	12a080e7          	jalr	298(ra) # 5f0e <printf>
    exit(1);
    2dec:	4505                	li	a0,1
    2dee:	00003097          	auipc	ra,0x3
    2df2:	db8080e7          	jalr	-584(ra) # 5ba6 <exit>
  wait(0);
    2df6:	4501                	li	a0,0
    2df8:	00003097          	auipc	ra,0x3
    2dfc:	db6080e7          	jalr	-586(ra) # 5bae <wait>
  pid = fork();
    2e00:	00003097          	auipc	ra,0x3
    2e04:	d9e080e7          	jalr	-610(ra) # 5b9e <fork>
  if (pid < 0)
    2e08:	02054a63          	bltz	a0,2e3c <sbrkbugs+0xea>
  if (pid == 0)
    2e0c:	e529                	bnez	a0,2e56 <sbrkbugs+0x104>
    sbrk((10 * 4096 + 2048) - (uint64)sbrk(0));
    2e0e:	00003097          	auipc	ra,0x3
    2e12:	e20080e7          	jalr	-480(ra) # 5c2e <sbrk>
    2e16:	67ad                	lui	a5,0xb
    2e18:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    2e1c:	40a7853b          	subw	a0,a5,a0
    2e20:	00003097          	auipc	ra,0x3
    2e24:	e0e080e7          	jalr	-498(ra) # 5c2e <sbrk>
    sbrk(-10);
    2e28:	5559                	li	a0,-10
    2e2a:	00003097          	auipc	ra,0x3
    2e2e:	e04080e7          	jalr	-508(ra) # 5c2e <sbrk>
    exit(0);
    2e32:	4501                	li	a0,0
    2e34:	00003097          	auipc	ra,0x3
    2e38:	d72080e7          	jalr	-654(ra) # 5ba6 <exit>
    printf("fork failed\n");
    2e3c:	00004517          	auipc	a0,0x4
    2e40:	f4c50513          	addi	a0,a0,-180 # 6d88 <malloc+0xdc2>
    2e44:	00003097          	auipc	ra,0x3
    2e48:	0ca080e7          	jalr	202(ra) # 5f0e <printf>
    exit(1);
    2e4c:	4505                	li	a0,1
    2e4e:	00003097          	auipc	ra,0x3
    2e52:	d58080e7          	jalr	-680(ra) # 5ba6 <exit>
  wait(0);
    2e56:	4501                	li	a0,0
    2e58:	00003097          	auipc	ra,0x3
    2e5c:	d56080e7          	jalr	-682(ra) # 5bae <wait>
  exit(0);
    2e60:	4501                	li	a0,0
    2e62:	00003097          	auipc	ra,0x3
    2e66:	d44080e7          	jalr	-700(ra) # 5ba6 <exit>

0000000000002e6a <sbrklast>:
{
    2e6a:	7179                	addi	sp,sp,-48
    2e6c:	f406                	sd	ra,40(sp)
    2e6e:	f022                	sd	s0,32(sp)
    2e70:	ec26                	sd	s1,24(sp)
    2e72:	e84a                	sd	s2,16(sp)
    2e74:	e44e                	sd	s3,8(sp)
    2e76:	e052                	sd	s4,0(sp)
    2e78:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    2e7a:	4501                	li	a0,0
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	db2080e7          	jalr	-590(ra) # 5c2e <sbrk>
  if ((top % 4096) != 0)
    2e84:	03451793          	slli	a5,a0,0x34
    2e88:	ebd9                	bnez	a5,2f1e <sbrklast+0xb4>
  sbrk(4096);
    2e8a:	6505                	lui	a0,0x1
    2e8c:	00003097          	auipc	ra,0x3
    2e90:	da2080e7          	jalr	-606(ra) # 5c2e <sbrk>
  sbrk(10);
    2e94:	4529                	li	a0,10
    2e96:	00003097          	auipc	ra,0x3
    2e9a:	d98080e7          	jalr	-616(ra) # 5c2e <sbrk>
  sbrk(-20);
    2e9e:	5531                	li	a0,-20
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	d8e080e7          	jalr	-626(ra) # 5c2e <sbrk>
  top = (uint64)sbrk(0);
    2ea8:	4501                	li	a0,0
    2eaa:	00003097          	auipc	ra,0x3
    2eae:	d84080e7          	jalr	-636(ra) # 5c2e <sbrk>
    2eb2:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    2eb4:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xcc>
  p[0] = 'x';
    2eb8:	07800a13          	li	s4,120
    2ebc:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2ec0:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    2ec4:	20200593          	li	a1,514
    2ec8:	854a                	mv	a0,s2
    2eca:	00003097          	auipc	ra,0x3
    2ece:	d1c080e7          	jalr	-740(ra) # 5be6 <open>
    2ed2:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ed4:	4605                	li	a2,1
    2ed6:	85ca                	mv	a1,s2
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	cee080e7          	jalr	-786(ra) # 5bc6 <write>
  close(fd);
    2ee0:	854e                	mv	a0,s3
    2ee2:	00003097          	auipc	ra,0x3
    2ee6:	cec080e7          	jalr	-788(ra) # 5bce <close>
  fd = open(p, O_RDWR);
    2eea:	4589                	li	a1,2
    2eec:	854a                	mv	a0,s2
    2eee:	00003097          	auipc	ra,0x3
    2ef2:	cf8080e7          	jalr	-776(ra) # 5be6 <open>
  p[0] = '\0';
    2ef6:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2efa:	4605                	li	a2,1
    2efc:	85ca                	mv	a1,s2
    2efe:	00003097          	auipc	ra,0x3
    2f02:	cc0080e7          	jalr	-832(ra) # 5bbe <read>
  if (p[0] != 'x')
    2f06:	fc04c783          	lbu	a5,-64(s1)
    2f0a:	03479463          	bne	a5,s4,2f32 <sbrklast+0xc8>
}
    2f0e:	70a2                	ld	ra,40(sp)
    2f10:	7402                	ld	s0,32(sp)
    2f12:	64e2                	ld	s1,24(sp)
    2f14:	6942                	ld	s2,16(sp)
    2f16:	69a2                	ld	s3,8(sp)
    2f18:	6a02                	ld	s4,0(sp)
    2f1a:	6145                	addi	sp,sp,48
    2f1c:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f1e:	0347d513          	srli	a0,a5,0x34
    2f22:	6785                	lui	a5,0x1
    2f24:	40a7853b          	subw	a0,a5,a0
    2f28:	00003097          	auipc	ra,0x3
    2f2c:	d06080e7          	jalr	-762(ra) # 5c2e <sbrk>
    2f30:	bfa9                	j	2e8a <sbrklast+0x20>
    exit(1);
    2f32:	4505                	li	a0,1
    2f34:	00003097          	auipc	ra,0x3
    2f38:	c72080e7          	jalr	-910(ra) # 5ba6 <exit>

0000000000002f3c <sbrk8000>:
{
    2f3c:	1141                	addi	sp,sp,-16
    2f3e:	e406                	sd	ra,8(sp)
    2f40:	e022                	sd	s0,0(sp)
    2f42:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f44:	80000537          	lui	a0,0x80000
    2f48:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2f4a:	00003097          	auipc	ra,0x3
    2f4e:	ce4080e7          	jalr	-796(ra) # 5c2e <sbrk>
  volatile char *top = sbrk(0);
    2f52:	4501                	li	a0,0
    2f54:	00003097          	auipc	ra,0x3
    2f58:	cda080e7          	jalr	-806(ra) # 5c2e <sbrk>
  *(top - 1) = *(top - 1) + 1;
    2f5c:	fff54783          	lbu	a5,-1(a0)
    2f60:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x10d>
    2f62:	0ff7f793          	zext.b	a5,a5
    2f66:	fef50fa3          	sb	a5,-1(a0)
}
    2f6a:	60a2                	ld	ra,8(sp)
    2f6c:	6402                	ld	s0,0(sp)
    2f6e:	0141                	addi	sp,sp,16
    2f70:	8082                	ret

0000000000002f72 <execout>:
{
    2f72:	715d                	addi	sp,sp,-80
    2f74:	e486                	sd	ra,72(sp)
    2f76:	e0a2                	sd	s0,64(sp)
    2f78:	fc26                	sd	s1,56(sp)
    2f7a:	f84a                	sd	s2,48(sp)
    2f7c:	f44e                	sd	s3,40(sp)
    2f7e:	f052                	sd	s4,32(sp)
    2f80:	0880                	addi	s0,sp,80
  for (int avail = 0; avail < 15; avail++)
    2f82:	4901                	li	s2,0
    2f84:	49bd                	li	s3,15
    int pid = fork();
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	c18080e7          	jalr	-1000(ra) # 5b9e <fork>
    2f8e:	84aa                	mv	s1,a0
    if (pid < 0)
    2f90:	02054063          	bltz	a0,2fb0 <execout+0x3e>
    else if (pid == 0)
    2f94:	c91d                	beqz	a0,2fca <execout+0x58>
      wait((int *)0);
    2f96:	4501                	li	a0,0
    2f98:	00003097          	auipc	ra,0x3
    2f9c:	c16080e7          	jalr	-1002(ra) # 5bae <wait>
  for (int avail = 0; avail < 15; avail++)
    2fa0:	2905                	addiw	s2,s2,1
    2fa2:	ff3912e3          	bne	s2,s3,2f86 <execout+0x14>
  exit(0);
    2fa6:	4501                	li	a0,0
    2fa8:	00003097          	auipc	ra,0x3
    2fac:	bfe080e7          	jalr	-1026(ra) # 5ba6 <exit>
      printf("fork failed\n");
    2fb0:	00004517          	auipc	a0,0x4
    2fb4:	dd850513          	addi	a0,a0,-552 # 6d88 <malloc+0xdc2>
    2fb8:	00003097          	auipc	ra,0x3
    2fbc:	f56080e7          	jalr	-170(ra) # 5f0e <printf>
      exit(1);
    2fc0:	4505                	li	a0,1
    2fc2:	00003097          	auipc	ra,0x3
    2fc6:	be4080e7          	jalr	-1052(ra) # 5ba6 <exit>
        if (a == 0xffffffffffffffffLL)
    2fca:	59fd                	li	s3,-1
        *(char *)(a + 4096 - 1) = 1;
    2fcc:	4a05                	li	s4,1
        uint64 a = (uint64)sbrk(4096);
    2fce:	6505                	lui	a0,0x1
    2fd0:	00003097          	auipc	ra,0x3
    2fd4:	c5e080e7          	jalr	-930(ra) # 5c2e <sbrk>
        if (a == 0xffffffffffffffffLL)
    2fd8:	01350763          	beq	a0,s3,2fe6 <execout+0x74>
        *(char *)(a + 4096 - 1) = 1;
    2fdc:	6785                	lui	a5,0x1
    2fde:	97aa                	add	a5,a5,a0
    2fe0:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x10b>
      {
    2fe4:	b7ed                	j	2fce <execout+0x5c>
      for (int i = 0; i < avail; i++)
    2fe6:	01205a63          	blez	s2,2ffa <execout+0x88>
        sbrk(-4096);
    2fea:	757d                	lui	a0,0xfffff
    2fec:	00003097          	auipc	ra,0x3
    2ff0:	c42080e7          	jalr	-958(ra) # 5c2e <sbrk>
      for (int i = 0; i < avail; i++)
    2ff4:	2485                	addiw	s1,s1,1
    2ff6:	ff249ae3          	bne	s1,s2,2fea <execout+0x78>
      close(1);
    2ffa:	4505                	li	a0,1
    2ffc:	00003097          	auipc	ra,0x3
    3000:	bd2080e7          	jalr	-1070(ra) # 5bce <close>
      char *args[] = {"echo", "x", 0};
    3004:	00003517          	auipc	a0,0x3
    3008:	0e450513          	addi	a0,a0,228 # 60e8 <malloc+0x122>
    300c:	faa43c23          	sd	a0,-72(s0)
    3010:	00003797          	auipc	a5,0x3
    3014:	14878793          	addi	a5,a5,328 # 6158 <malloc+0x192>
    3018:	fcf43023          	sd	a5,-64(s0)
    301c:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3020:	fb840593          	addi	a1,s0,-72
    3024:	00003097          	auipc	ra,0x3
    3028:	bba080e7          	jalr	-1094(ra) # 5bde <exec>
      exit(0);
    302c:	4501                	li	a0,0
    302e:	00003097          	auipc	ra,0x3
    3032:	b78080e7          	jalr	-1160(ra) # 5ba6 <exit>

0000000000003036 <fourteen>:
{
    3036:	1101                	addi	sp,sp,-32
    3038:	ec06                	sd	ra,24(sp)
    303a:	e822                	sd	s0,16(sp)
    303c:	e426                	sd	s1,8(sp)
    303e:	1000                	addi	s0,sp,32
    3040:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0)
    3042:	00004517          	auipc	a0,0x4
    3046:	25650513          	addi	a0,a0,598 # 7298 <malloc+0x12d2>
    304a:	00003097          	auipc	ra,0x3
    304e:	bc4080e7          	jalr	-1084(ra) # 5c0e <mkdir>
    3052:	e165                	bnez	a0,3132 <fourteen+0xfc>
  if (mkdir("12345678901234/123456789012345") != 0)
    3054:	00004517          	auipc	a0,0x4
    3058:	09c50513          	addi	a0,a0,156 # 70f0 <malloc+0x112a>
    305c:	00003097          	auipc	ra,0x3
    3060:	bb2080e7          	jalr	-1102(ra) # 5c0e <mkdir>
    3064:	e56d                	bnez	a0,314e <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3066:	20000593          	li	a1,512
    306a:	00004517          	auipc	a0,0x4
    306e:	0de50513          	addi	a0,a0,222 # 7148 <malloc+0x1182>
    3072:	00003097          	auipc	ra,0x3
    3076:	b74080e7          	jalr	-1164(ra) # 5be6 <open>
  if (fd < 0)
    307a:	0e054863          	bltz	a0,316a <fourteen+0x134>
  close(fd);
    307e:	00003097          	auipc	ra,0x3
    3082:	b50080e7          	jalr	-1200(ra) # 5bce <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3086:	4581                	li	a1,0
    3088:	00004517          	auipc	a0,0x4
    308c:	13850513          	addi	a0,a0,312 # 71c0 <malloc+0x11fa>
    3090:	00003097          	auipc	ra,0x3
    3094:	b56080e7          	jalr	-1194(ra) # 5be6 <open>
  if (fd < 0)
    3098:	0e054763          	bltz	a0,3186 <fourteen+0x150>
  close(fd);
    309c:	00003097          	auipc	ra,0x3
    30a0:	b32080e7          	jalr	-1230(ra) # 5bce <close>
  if (mkdir("12345678901234/12345678901234") == 0)
    30a4:	00004517          	auipc	a0,0x4
    30a8:	18c50513          	addi	a0,a0,396 # 7230 <malloc+0x126a>
    30ac:	00003097          	auipc	ra,0x3
    30b0:	b62080e7          	jalr	-1182(ra) # 5c0e <mkdir>
    30b4:	c57d                	beqz	a0,31a2 <fourteen+0x16c>
  if (mkdir("123456789012345/12345678901234") == 0)
    30b6:	00004517          	auipc	a0,0x4
    30ba:	1d250513          	addi	a0,a0,466 # 7288 <malloc+0x12c2>
    30be:	00003097          	auipc	ra,0x3
    30c2:	b50080e7          	jalr	-1200(ra) # 5c0e <mkdir>
    30c6:	cd65                	beqz	a0,31be <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30c8:	00004517          	auipc	a0,0x4
    30cc:	1c050513          	addi	a0,a0,448 # 7288 <malloc+0x12c2>
    30d0:	00003097          	auipc	ra,0x3
    30d4:	b26080e7          	jalr	-1242(ra) # 5bf6 <unlink>
  unlink("12345678901234/12345678901234");
    30d8:	00004517          	auipc	a0,0x4
    30dc:	15850513          	addi	a0,a0,344 # 7230 <malloc+0x126a>
    30e0:	00003097          	auipc	ra,0x3
    30e4:	b16080e7          	jalr	-1258(ra) # 5bf6 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30e8:	00004517          	auipc	a0,0x4
    30ec:	0d850513          	addi	a0,a0,216 # 71c0 <malloc+0x11fa>
    30f0:	00003097          	auipc	ra,0x3
    30f4:	b06080e7          	jalr	-1274(ra) # 5bf6 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30f8:	00004517          	auipc	a0,0x4
    30fc:	05050513          	addi	a0,a0,80 # 7148 <malloc+0x1182>
    3100:	00003097          	auipc	ra,0x3
    3104:	af6080e7          	jalr	-1290(ra) # 5bf6 <unlink>
  unlink("12345678901234/123456789012345");
    3108:	00004517          	auipc	a0,0x4
    310c:	fe850513          	addi	a0,a0,-24 # 70f0 <malloc+0x112a>
    3110:	00003097          	auipc	ra,0x3
    3114:	ae6080e7          	jalr	-1306(ra) # 5bf6 <unlink>
  unlink("12345678901234");
    3118:	00004517          	auipc	a0,0x4
    311c:	18050513          	addi	a0,a0,384 # 7298 <malloc+0x12d2>
    3120:	00003097          	auipc	ra,0x3
    3124:	ad6080e7          	jalr	-1322(ra) # 5bf6 <unlink>
}
    3128:	60e2                	ld	ra,24(sp)
    312a:	6442                	ld	s0,16(sp)
    312c:	64a2                	ld	s1,8(sp)
    312e:	6105                	addi	sp,sp,32
    3130:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3132:	85a6                	mv	a1,s1
    3134:	00004517          	auipc	a0,0x4
    3138:	f9450513          	addi	a0,a0,-108 # 70c8 <malloc+0x1102>
    313c:	00003097          	auipc	ra,0x3
    3140:	dd2080e7          	jalr	-558(ra) # 5f0e <printf>
    exit(1);
    3144:	4505                	li	a0,1
    3146:	00003097          	auipc	ra,0x3
    314a:	a60080e7          	jalr	-1440(ra) # 5ba6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    314e:	85a6                	mv	a1,s1
    3150:	00004517          	auipc	a0,0x4
    3154:	fc050513          	addi	a0,a0,-64 # 7110 <malloc+0x114a>
    3158:	00003097          	auipc	ra,0x3
    315c:	db6080e7          	jalr	-586(ra) # 5f0e <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	00003097          	auipc	ra,0x3
    3166:	a44080e7          	jalr	-1468(ra) # 5ba6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    316a:	85a6                	mv	a1,s1
    316c:	00004517          	auipc	a0,0x4
    3170:	00c50513          	addi	a0,a0,12 # 7178 <malloc+0x11b2>
    3174:	00003097          	auipc	ra,0x3
    3178:	d9a080e7          	jalr	-614(ra) # 5f0e <printf>
    exit(1);
    317c:	4505                	li	a0,1
    317e:	00003097          	auipc	ra,0x3
    3182:	a28080e7          	jalr	-1496(ra) # 5ba6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3186:	85a6                	mv	a1,s1
    3188:	00004517          	auipc	a0,0x4
    318c:	06850513          	addi	a0,a0,104 # 71f0 <malloc+0x122a>
    3190:	00003097          	auipc	ra,0x3
    3194:	d7e080e7          	jalr	-642(ra) # 5f0e <printf>
    exit(1);
    3198:	4505                	li	a0,1
    319a:	00003097          	auipc	ra,0x3
    319e:	a0c080e7          	jalr	-1524(ra) # 5ba6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    31a2:	85a6                	mv	a1,s1
    31a4:	00004517          	auipc	a0,0x4
    31a8:	0ac50513          	addi	a0,a0,172 # 7250 <malloc+0x128a>
    31ac:	00003097          	auipc	ra,0x3
    31b0:	d62080e7          	jalr	-670(ra) # 5f0e <printf>
    exit(1);
    31b4:	4505                	li	a0,1
    31b6:	00003097          	auipc	ra,0x3
    31ba:	9f0080e7          	jalr	-1552(ra) # 5ba6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31be:	85a6                	mv	a1,s1
    31c0:	00004517          	auipc	a0,0x4
    31c4:	0e850513          	addi	a0,a0,232 # 72a8 <malloc+0x12e2>
    31c8:	00003097          	auipc	ra,0x3
    31cc:	d46080e7          	jalr	-698(ra) # 5f0e <printf>
    exit(1);
    31d0:	4505                	li	a0,1
    31d2:	00003097          	auipc	ra,0x3
    31d6:	9d4080e7          	jalr	-1580(ra) # 5ba6 <exit>

00000000000031da <diskfull>:
{
    31da:	b9010113          	addi	sp,sp,-1136
    31de:	46113423          	sd	ra,1128(sp)
    31e2:	46813023          	sd	s0,1120(sp)
    31e6:	44913c23          	sd	s1,1112(sp)
    31ea:	45213823          	sd	s2,1104(sp)
    31ee:	45313423          	sd	s3,1096(sp)
    31f2:	45413023          	sd	s4,1088(sp)
    31f6:	43513c23          	sd	s5,1080(sp)
    31fa:	43613823          	sd	s6,1072(sp)
    31fe:	43713423          	sd	s7,1064(sp)
    3202:	43813023          	sd	s8,1056(sp)
    3206:	47010413          	addi	s0,sp,1136
    320a:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    320c:	00004517          	auipc	a0,0x4
    3210:	0d450513          	addi	a0,a0,212 # 72e0 <malloc+0x131a>
    3214:	00003097          	auipc	ra,0x3
    3218:	9e2080e7          	jalr	-1566(ra) # 5bf6 <unlink>
  for (fi = 0; done == 0; fi++)
    321c:	4a01                	li	s4,0
    name[0] = 'b';
    321e:	06200b13          	li	s6,98
    name[1] = 'i';
    3222:	06900a93          	li	s5,105
    name[2] = 'g';
    3226:	06700993          	li	s3,103
    322a:	10c00b93          	li	s7,268
    322e:	aabd                	j	33ac <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    3230:	b9040613          	addi	a2,s0,-1136
    3234:	85e2                	mv	a1,s8
    3236:	00004517          	auipc	a0,0x4
    323a:	0ba50513          	addi	a0,a0,186 # 72f0 <malloc+0x132a>
    323e:	00003097          	auipc	ra,0x3
    3242:	cd0080e7          	jalr	-816(ra) # 5f0e <printf>
      break;
    3246:	a821                	j	325e <diskfull+0x84>
        close(fd);
    3248:	854a                	mv	a0,s2
    324a:	00003097          	auipc	ra,0x3
    324e:	984080e7          	jalr	-1660(ra) # 5bce <close>
    close(fd);
    3252:	854a                	mv	a0,s2
    3254:	00003097          	auipc	ra,0x3
    3258:	97a080e7          	jalr	-1670(ra) # 5bce <close>
  for (fi = 0; done == 0; fi++)
    325c:	2a05                	addiw	s4,s4,1
  for (int i = 0; i < nzz; i++)
    325e:	4481                	li	s1,0
    name[0] = 'z';
    3260:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++)
    3264:	08000993          	li	s3,128
    name[0] = 'z';
    3268:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    326c:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3270:	41f4d71b          	sraiw	a4,s1,0x1f
    3274:	01b7571b          	srliw	a4,a4,0x1b
    3278:	009707bb          	addw	a5,a4,s1
    327c:	4057d69b          	sraiw	a3,a5,0x5
    3280:	0306869b          	addiw	a3,a3,48
    3284:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3288:	8bfd                	andi	a5,a5,31
    328a:	9f99                	subw	a5,a5,a4
    328c:	0307879b          	addiw	a5,a5,48
    3290:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3294:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3298:	bb040513          	addi	a0,s0,-1104
    329c:	00003097          	auipc	ra,0x3
    32a0:	95a080e7          	jalr	-1702(ra) # 5bf6 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    32a4:	60200593          	li	a1,1538
    32a8:	bb040513          	addi	a0,s0,-1104
    32ac:	00003097          	auipc	ra,0x3
    32b0:	93a080e7          	jalr	-1734(ra) # 5be6 <open>
    if (fd < 0)
    32b4:	00054963          	bltz	a0,32c6 <diskfull+0xec>
    close(fd);
    32b8:	00003097          	auipc	ra,0x3
    32bc:	916080e7          	jalr	-1770(ra) # 5bce <close>
  for (int i = 0; i < nzz; i++)
    32c0:	2485                	addiw	s1,s1,1
    32c2:	fb3493e3          	bne	s1,s3,3268 <diskfull+0x8e>
  if (mkdir("diskfulldir") == 0)
    32c6:	00004517          	auipc	a0,0x4
    32ca:	01a50513          	addi	a0,a0,26 # 72e0 <malloc+0x131a>
    32ce:	00003097          	auipc	ra,0x3
    32d2:	940080e7          	jalr	-1728(ra) # 5c0e <mkdir>
    32d6:	12050963          	beqz	a0,3408 <diskfull+0x22e>
  unlink("diskfulldir");
    32da:	00004517          	auipc	a0,0x4
    32de:	00650513          	addi	a0,a0,6 # 72e0 <malloc+0x131a>
    32e2:	00003097          	auipc	ra,0x3
    32e6:	914080e7          	jalr	-1772(ra) # 5bf6 <unlink>
  for (int i = 0; i < nzz; i++)
    32ea:	4481                	li	s1,0
    name[0] = 'z';
    32ec:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++)
    32f0:	08000993          	li	s3,128
    name[0] = 'z';
    32f4:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32f8:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32fc:	41f4d71b          	sraiw	a4,s1,0x1f
    3300:	01b7571b          	srliw	a4,a4,0x1b
    3304:	009707bb          	addw	a5,a4,s1
    3308:	4057d69b          	sraiw	a3,a5,0x5
    330c:	0306869b          	addiw	a3,a3,48
    3310:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3314:	8bfd                	andi	a5,a5,31
    3316:	9f99                	subw	a5,a5,a4
    3318:	0307879b          	addiw	a5,a5,48
    331c:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3320:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3324:	bb040513          	addi	a0,s0,-1104
    3328:	00003097          	auipc	ra,0x3
    332c:	8ce080e7          	jalr	-1842(ra) # 5bf6 <unlink>
  for (int i = 0; i < nzz; i++)
    3330:	2485                	addiw	s1,s1,1
    3332:	fd3491e3          	bne	s1,s3,32f4 <diskfull+0x11a>
  for (int i = 0; i < fi; i++)
    3336:	03405e63          	blez	s4,3372 <diskfull+0x198>
    333a:	4481                	li	s1,0
    name[0] = 'b';
    333c:	06200a93          	li	s5,98
    name[1] = 'i';
    3340:	06900993          	li	s3,105
    name[2] = 'g';
    3344:	06700913          	li	s2,103
    name[0] = 'b';
    3348:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    334c:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3350:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3354:	0304879b          	addiw	a5,s1,48
    3358:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    335c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3360:	bb040513          	addi	a0,s0,-1104
    3364:	00003097          	auipc	ra,0x3
    3368:	892080e7          	jalr	-1902(ra) # 5bf6 <unlink>
  for (int i = 0; i < fi; i++)
    336c:	2485                	addiw	s1,s1,1
    336e:	fd449de3          	bne	s1,s4,3348 <diskfull+0x16e>
}
    3372:	46813083          	ld	ra,1128(sp)
    3376:	46013403          	ld	s0,1120(sp)
    337a:	45813483          	ld	s1,1112(sp)
    337e:	45013903          	ld	s2,1104(sp)
    3382:	44813983          	ld	s3,1096(sp)
    3386:	44013a03          	ld	s4,1088(sp)
    338a:	43813a83          	ld	s5,1080(sp)
    338e:	43013b03          	ld	s6,1072(sp)
    3392:	42813b83          	ld	s7,1064(sp)
    3396:	42013c03          	ld	s8,1056(sp)
    339a:	47010113          	addi	sp,sp,1136
    339e:	8082                	ret
    close(fd);
    33a0:	854a                	mv	a0,s2
    33a2:	00003097          	auipc	ra,0x3
    33a6:	82c080e7          	jalr	-2004(ra) # 5bce <close>
  for (fi = 0; done == 0; fi++)
    33aa:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    33ac:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    33b0:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    33b4:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    33b8:	030a079b          	addiw	a5,s4,48
    33bc:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33c0:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    33c4:	b9040513          	addi	a0,s0,-1136
    33c8:	00003097          	auipc	ra,0x3
    33cc:	82e080e7          	jalr	-2002(ra) # 5bf6 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    33d0:	60200593          	li	a1,1538
    33d4:	b9040513          	addi	a0,s0,-1136
    33d8:	00003097          	auipc	ra,0x3
    33dc:	80e080e7          	jalr	-2034(ra) # 5be6 <open>
    33e0:	892a                	mv	s2,a0
    if (fd < 0)
    33e2:	e40547e3          	bltz	a0,3230 <diskfull+0x56>
    33e6:	84de                	mv	s1,s7
      if (write(fd, buf, BSIZE) != BSIZE)
    33e8:	40000613          	li	a2,1024
    33ec:	bb040593          	addi	a1,s0,-1104
    33f0:	854a                	mv	a0,s2
    33f2:	00002097          	auipc	ra,0x2
    33f6:	7d4080e7          	jalr	2004(ra) # 5bc6 <write>
    33fa:	40000793          	li	a5,1024
    33fe:	e4f515e3          	bne	a0,a5,3248 <diskfull+0x6e>
    for (int i = 0; i < MAXFILE; i++)
    3402:	34fd                	addiw	s1,s1,-1
    3404:	f0f5                	bnez	s1,33e8 <diskfull+0x20e>
    3406:	bf69                	j	33a0 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3408:	00004517          	auipc	a0,0x4
    340c:	f0850513          	addi	a0,a0,-248 # 7310 <malloc+0x134a>
    3410:	00003097          	auipc	ra,0x3
    3414:	afe080e7          	jalr	-1282(ra) # 5f0e <printf>
    3418:	b5c9                	j	32da <diskfull+0x100>

000000000000341a <iputtest>:
{
    341a:	1101                	addi	sp,sp,-32
    341c:	ec06                	sd	ra,24(sp)
    341e:	e822                	sd	s0,16(sp)
    3420:	e426                	sd	s1,8(sp)
    3422:	1000                	addi	s0,sp,32
    3424:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0)
    3426:	00004517          	auipc	a0,0x4
    342a:	f1a50513          	addi	a0,a0,-230 # 7340 <malloc+0x137a>
    342e:	00002097          	auipc	ra,0x2
    3432:	7e0080e7          	jalr	2016(ra) # 5c0e <mkdir>
    3436:	04054563          	bltz	a0,3480 <iputtest+0x66>
  if (chdir("iputdir") < 0)
    343a:	00004517          	auipc	a0,0x4
    343e:	f0650513          	addi	a0,a0,-250 # 7340 <malloc+0x137a>
    3442:	00002097          	auipc	ra,0x2
    3446:	7d4080e7          	jalr	2004(ra) # 5c16 <chdir>
    344a:	04054963          	bltz	a0,349c <iputtest+0x82>
  if (unlink("../iputdir") < 0)
    344e:	00004517          	auipc	a0,0x4
    3452:	f3250513          	addi	a0,a0,-206 # 7380 <malloc+0x13ba>
    3456:	00002097          	auipc	ra,0x2
    345a:	7a0080e7          	jalr	1952(ra) # 5bf6 <unlink>
    345e:	04054d63          	bltz	a0,34b8 <iputtest+0x9e>
  if (chdir("/") < 0)
    3462:	00004517          	auipc	a0,0x4
    3466:	f4e50513          	addi	a0,a0,-178 # 73b0 <malloc+0x13ea>
    346a:	00002097          	auipc	ra,0x2
    346e:	7ac080e7          	jalr	1964(ra) # 5c16 <chdir>
    3472:	06054163          	bltz	a0,34d4 <iputtest+0xba>
}
    3476:	60e2                	ld	ra,24(sp)
    3478:	6442                	ld	s0,16(sp)
    347a:	64a2                	ld	s1,8(sp)
    347c:	6105                	addi	sp,sp,32
    347e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3480:	85a6                	mv	a1,s1
    3482:	00004517          	auipc	a0,0x4
    3486:	ec650513          	addi	a0,a0,-314 # 7348 <malloc+0x1382>
    348a:	00003097          	auipc	ra,0x3
    348e:	a84080e7          	jalr	-1404(ra) # 5f0e <printf>
    exit(1);
    3492:	4505                	li	a0,1
    3494:	00002097          	auipc	ra,0x2
    3498:	712080e7          	jalr	1810(ra) # 5ba6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    349c:	85a6                	mv	a1,s1
    349e:	00004517          	auipc	a0,0x4
    34a2:	ec250513          	addi	a0,a0,-318 # 7360 <malloc+0x139a>
    34a6:	00003097          	auipc	ra,0x3
    34aa:	a68080e7          	jalr	-1432(ra) # 5f0e <printf>
    exit(1);
    34ae:	4505                	li	a0,1
    34b0:	00002097          	auipc	ra,0x2
    34b4:	6f6080e7          	jalr	1782(ra) # 5ba6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34b8:	85a6                	mv	a1,s1
    34ba:	00004517          	auipc	a0,0x4
    34be:	ed650513          	addi	a0,a0,-298 # 7390 <malloc+0x13ca>
    34c2:	00003097          	auipc	ra,0x3
    34c6:	a4c080e7          	jalr	-1460(ra) # 5f0e <printf>
    exit(1);
    34ca:	4505                	li	a0,1
    34cc:	00002097          	auipc	ra,0x2
    34d0:	6da080e7          	jalr	1754(ra) # 5ba6 <exit>
    printf("%s: chdir / failed\n", s);
    34d4:	85a6                	mv	a1,s1
    34d6:	00004517          	auipc	a0,0x4
    34da:	ee250513          	addi	a0,a0,-286 # 73b8 <malloc+0x13f2>
    34de:	00003097          	auipc	ra,0x3
    34e2:	a30080e7          	jalr	-1488(ra) # 5f0e <printf>
    exit(1);
    34e6:	4505                	li	a0,1
    34e8:	00002097          	auipc	ra,0x2
    34ec:	6be080e7          	jalr	1726(ra) # 5ba6 <exit>

00000000000034f0 <exitiputtest>:
{
    34f0:	7179                	addi	sp,sp,-48
    34f2:	f406                	sd	ra,40(sp)
    34f4:	f022                	sd	s0,32(sp)
    34f6:	ec26                	sd	s1,24(sp)
    34f8:	1800                	addi	s0,sp,48
    34fa:	84aa                	mv	s1,a0
  pid = fork();
    34fc:	00002097          	auipc	ra,0x2
    3500:	6a2080e7          	jalr	1698(ra) # 5b9e <fork>
  if (pid < 0)
    3504:	04054663          	bltz	a0,3550 <exitiputtest+0x60>
  if (pid == 0)
    3508:	ed45                	bnez	a0,35c0 <exitiputtest+0xd0>
    if (mkdir("iputdir") < 0)
    350a:	00004517          	auipc	a0,0x4
    350e:	e3650513          	addi	a0,a0,-458 # 7340 <malloc+0x137a>
    3512:	00002097          	auipc	ra,0x2
    3516:	6fc080e7          	jalr	1788(ra) # 5c0e <mkdir>
    351a:	04054963          	bltz	a0,356c <exitiputtest+0x7c>
    if (chdir("iputdir") < 0)
    351e:	00004517          	auipc	a0,0x4
    3522:	e2250513          	addi	a0,a0,-478 # 7340 <malloc+0x137a>
    3526:	00002097          	auipc	ra,0x2
    352a:	6f0080e7          	jalr	1776(ra) # 5c16 <chdir>
    352e:	04054d63          	bltz	a0,3588 <exitiputtest+0x98>
    if (unlink("../iputdir") < 0)
    3532:	00004517          	auipc	a0,0x4
    3536:	e4e50513          	addi	a0,a0,-434 # 7380 <malloc+0x13ba>
    353a:	00002097          	auipc	ra,0x2
    353e:	6bc080e7          	jalr	1724(ra) # 5bf6 <unlink>
    3542:	06054163          	bltz	a0,35a4 <exitiputtest+0xb4>
    exit(0);
    3546:	4501                	li	a0,0
    3548:	00002097          	auipc	ra,0x2
    354c:	65e080e7          	jalr	1630(ra) # 5ba6 <exit>
    printf("%s: fork failed\n", s);
    3550:	85a6                	mv	a1,s1
    3552:	00003517          	auipc	a0,0x3
    3556:	42e50513          	addi	a0,a0,1070 # 6980 <malloc+0x9ba>
    355a:	00003097          	auipc	ra,0x3
    355e:	9b4080e7          	jalr	-1612(ra) # 5f0e <printf>
    exit(1);
    3562:	4505                	li	a0,1
    3564:	00002097          	auipc	ra,0x2
    3568:	642080e7          	jalr	1602(ra) # 5ba6 <exit>
      printf("%s: mkdir failed\n", s);
    356c:	85a6                	mv	a1,s1
    356e:	00004517          	auipc	a0,0x4
    3572:	dda50513          	addi	a0,a0,-550 # 7348 <malloc+0x1382>
    3576:	00003097          	auipc	ra,0x3
    357a:	998080e7          	jalr	-1640(ra) # 5f0e <printf>
      exit(1);
    357e:	4505                	li	a0,1
    3580:	00002097          	auipc	ra,0x2
    3584:	626080e7          	jalr	1574(ra) # 5ba6 <exit>
      printf("%s: child chdir failed\n", s);
    3588:	85a6                	mv	a1,s1
    358a:	00004517          	auipc	a0,0x4
    358e:	e4650513          	addi	a0,a0,-442 # 73d0 <malloc+0x140a>
    3592:	00003097          	auipc	ra,0x3
    3596:	97c080e7          	jalr	-1668(ra) # 5f0e <printf>
      exit(1);
    359a:	4505                	li	a0,1
    359c:	00002097          	auipc	ra,0x2
    35a0:	60a080e7          	jalr	1546(ra) # 5ba6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35a4:	85a6                	mv	a1,s1
    35a6:	00004517          	auipc	a0,0x4
    35aa:	dea50513          	addi	a0,a0,-534 # 7390 <malloc+0x13ca>
    35ae:	00003097          	auipc	ra,0x3
    35b2:	960080e7          	jalr	-1696(ra) # 5f0e <printf>
      exit(1);
    35b6:	4505                	li	a0,1
    35b8:	00002097          	auipc	ra,0x2
    35bc:	5ee080e7          	jalr	1518(ra) # 5ba6 <exit>
  wait(&xstatus);
    35c0:	fdc40513          	addi	a0,s0,-36
    35c4:	00002097          	auipc	ra,0x2
    35c8:	5ea080e7          	jalr	1514(ra) # 5bae <wait>
  exit(xstatus);
    35cc:	fdc42503          	lw	a0,-36(s0)
    35d0:	00002097          	auipc	ra,0x2
    35d4:	5d6080e7          	jalr	1494(ra) # 5ba6 <exit>

00000000000035d8 <dirtest>:
{
    35d8:	1101                	addi	sp,sp,-32
    35da:	ec06                	sd	ra,24(sp)
    35dc:	e822                	sd	s0,16(sp)
    35de:	e426                	sd	s1,8(sp)
    35e0:	1000                	addi	s0,sp,32
    35e2:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0)
    35e4:	00004517          	auipc	a0,0x4
    35e8:	e0450513          	addi	a0,a0,-508 # 73e8 <malloc+0x1422>
    35ec:	00002097          	auipc	ra,0x2
    35f0:	622080e7          	jalr	1570(ra) # 5c0e <mkdir>
    35f4:	04054563          	bltz	a0,363e <dirtest+0x66>
  if (chdir("dir0") < 0)
    35f8:	00004517          	auipc	a0,0x4
    35fc:	df050513          	addi	a0,a0,-528 # 73e8 <malloc+0x1422>
    3600:	00002097          	auipc	ra,0x2
    3604:	616080e7          	jalr	1558(ra) # 5c16 <chdir>
    3608:	04054963          	bltz	a0,365a <dirtest+0x82>
  if (chdir("..") < 0)
    360c:	00004517          	auipc	a0,0x4
    3610:	dfc50513          	addi	a0,a0,-516 # 7408 <malloc+0x1442>
    3614:	00002097          	auipc	ra,0x2
    3618:	602080e7          	jalr	1538(ra) # 5c16 <chdir>
    361c:	04054d63          	bltz	a0,3676 <dirtest+0x9e>
  if (unlink("dir0") < 0)
    3620:	00004517          	auipc	a0,0x4
    3624:	dc850513          	addi	a0,a0,-568 # 73e8 <malloc+0x1422>
    3628:	00002097          	auipc	ra,0x2
    362c:	5ce080e7          	jalr	1486(ra) # 5bf6 <unlink>
    3630:	06054163          	bltz	a0,3692 <dirtest+0xba>
}
    3634:	60e2                	ld	ra,24(sp)
    3636:	6442                	ld	s0,16(sp)
    3638:	64a2                	ld	s1,8(sp)
    363a:	6105                	addi	sp,sp,32
    363c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    363e:	85a6                	mv	a1,s1
    3640:	00004517          	auipc	a0,0x4
    3644:	d0850513          	addi	a0,a0,-760 # 7348 <malloc+0x1382>
    3648:	00003097          	auipc	ra,0x3
    364c:	8c6080e7          	jalr	-1850(ra) # 5f0e <printf>
    exit(1);
    3650:	4505                	li	a0,1
    3652:	00002097          	auipc	ra,0x2
    3656:	554080e7          	jalr	1364(ra) # 5ba6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    365a:	85a6                	mv	a1,s1
    365c:	00004517          	auipc	a0,0x4
    3660:	d9450513          	addi	a0,a0,-620 # 73f0 <malloc+0x142a>
    3664:	00003097          	auipc	ra,0x3
    3668:	8aa080e7          	jalr	-1878(ra) # 5f0e <printf>
    exit(1);
    366c:	4505                	li	a0,1
    366e:	00002097          	auipc	ra,0x2
    3672:	538080e7          	jalr	1336(ra) # 5ba6 <exit>
    printf("%s: chdir .. failed\n", s);
    3676:	85a6                	mv	a1,s1
    3678:	00004517          	auipc	a0,0x4
    367c:	d9850513          	addi	a0,a0,-616 # 7410 <malloc+0x144a>
    3680:	00003097          	auipc	ra,0x3
    3684:	88e080e7          	jalr	-1906(ra) # 5f0e <printf>
    exit(1);
    3688:	4505                	li	a0,1
    368a:	00002097          	auipc	ra,0x2
    368e:	51c080e7          	jalr	1308(ra) # 5ba6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3692:	85a6                	mv	a1,s1
    3694:	00004517          	auipc	a0,0x4
    3698:	d9450513          	addi	a0,a0,-620 # 7428 <malloc+0x1462>
    369c:	00003097          	auipc	ra,0x3
    36a0:	872080e7          	jalr	-1934(ra) # 5f0e <printf>
    exit(1);
    36a4:	4505                	li	a0,1
    36a6:	00002097          	auipc	ra,0x2
    36aa:	500080e7          	jalr	1280(ra) # 5ba6 <exit>

00000000000036ae <subdir>:
{
    36ae:	1101                	addi	sp,sp,-32
    36b0:	ec06                	sd	ra,24(sp)
    36b2:	e822                	sd	s0,16(sp)
    36b4:	e426                	sd	s1,8(sp)
    36b6:	e04a                	sd	s2,0(sp)
    36b8:	1000                	addi	s0,sp,32
    36ba:	892a                	mv	s2,a0
  unlink("ff");
    36bc:	00004517          	auipc	a0,0x4
    36c0:	eb450513          	addi	a0,a0,-332 # 7570 <malloc+0x15aa>
    36c4:	00002097          	auipc	ra,0x2
    36c8:	532080e7          	jalr	1330(ra) # 5bf6 <unlink>
  if (mkdir("dd") != 0)
    36cc:	00004517          	auipc	a0,0x4
    36d0:	d7450513          	addi	a0,a0,-652 # 7440 <malloc+0x147a>
    36d4:	00002097          	auipc	ra,0x2
    36d8:	53a080e7          	jalr	1338(ra) # 5c0e <mkdir>
    36dc:	38051663          	bnez	a0,3a68 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36e0:	20200593          	li	a1,514
    36e4:	00004517          	auipc	a0,0x4
    36e8:	d7c50513          	addi	a0,a0,-644 # 7460 <malloc+0x149a>
    36ec:	00002097          	auipc	ra,0x2
    36f0:	4fa080e7          	jalr	1274(ra) # 5be6 <open>
    36f4:	84aa                	mv	s1,a0
  if (fd < 0)
    36f6:	38054763          	bltz	a0,3a84 <subdir+0x3d6>
  write(fd, "ff", 2);
    36fa:	4609                	li	a2,2
    36fc:	00004597          	auipc	a1,0x4
    3700:	e7458593          	addi	a1,a1,-396 # 7570 <malloc+0x15aa>
    3704:	00002097          	auipc	ra,0x2
    3708:	4c2080e7          	jalr	1218(ra) # 5bc6 <write>
  close(fd);
    370c:	8526                	mv	a0,s1
    370e:	00002097          	auipc	ra,0x2
    3712:	4c0080e7          	jalr	1216(ra) # 5bce <close>
  if (unlink("dd") >= 0)
    3716:	00004517          	auipc	a0,0x4
    371a:	d2a50513          	addi	a0,a0,-726 # 7440 <malloc+0x147a>
    371e:	00002097          	auipc	ra,0x2
    3722:	4d8080e7          	jalr	1240(ra) # 5bf6 <unlink>
    3726:	36055d63          	bgez	a0,3aa0 <subdir+0x3f2>
  if (mkdir("/dd/dd") != 0)
    372a:	00004517          	auipc	a0,0x4
    372e:	d8e50513          	addi	a0,a0,-626 # 74b8 <malloc+0x14f2>
    3732:	00002097          	auipc	ra,0x2
    3736:	4dc080e7          	jalr	1244(ra) # 5c0e <mkdir>
    373a:	38051163          	bnez	a0,3abc <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    373e:	20200593          	li	a1,514
    3742:	00004517          	auipc	a0,0x4
    3746:	d9e50513          	addi	a0,a0,-610 # 74e0 <malloc+0x151a>
    374a:	00002097          	auipc	ra,0x2
    374e:	49c080e7          	jalr	1180(ra) # 5be6 <open>
    3752:	84aa                	mv	s1,a0
  if (fd < 0)
    3754:	38054263          	bltz	a0,3ad8 <subdir+0x42a>
  write(fd, "FF", 2);
    3758:	4609                	li	a2,2
    375a:	00004597          	auipc	a1,0x4
    375e:	db658593          	addi	a1,a1,-586 # 7510 <malloc+0x154a>
    3762:	00002097          	auipc	ra,0x2
    3766:	464080e7          	jalr	1124(ra) # 5bc6 <write>
  close(fd);
    376a:	8526                	mv	a0,s1
    376c:	00002097          	auipc	ra,0x2
    3770:	462080e7          	jalr	1122(ra) # 5bce <close>
  fd = open("dd/dd/../ff", 0);
    3774:	4581                	li	a1,0
    3776:	00004517          	auipc	a0,0x4
    377a:	da250513          	addi	a0,a0,-606 # 7518 <malloc+0x1552>
    377e:	00002097          	auipc	ra,0x2
    3782:	468080e7          	jalr	1128(ra) # 5be6 <open>
    3786:	84aa                	mv	s1,a0
  if (fd < 0)
    3788:	36054663          	bltz	a0,3af4 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    378c:	660d                	lui	a2,0x3
    378e:	00009597          	auipc	a1,0x9
    3792:	4ea58593          	addi	a1,a1,1258 # cc78 <buf>
    3796:	00002097          	auipc	ra,0x2
    379a:	428080e7          	jalr	1064(ra) # 5bbe <read>
  if (cc != 2 || buf[0] != 'f')
    379e:	4789                	li	a5,2
    37a0:	36f51863          	bne	a0,a5,3b10 <subdir+0x462>
    37a4:	00009717          	auipc	a4,0x9
    37a8:	4d474703          	lbu	a4,1236(a4) # cc78 <buf>
    37ac:	06600793          	li	a5,102
    37b0:	36f71063          	bne	a4,a5,3b10 <subdir+0x462>
  close(fd);
    37b4:	8526                	mv	a0,s1
    37b6:	00002097          	auipc	ra,0x2
    37ba:	418080e7          	jalr	1048(ra) # 5bce <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0)
    37be:	00004597          	auipc	a1,0x4
    37c2:	daa58593          	addi	a1,a1,-598 # 7568 <malloc+0x15a2>
    37c6:	00004517          	auipc	a0,0x4
    37ca:	d1a50513          	addi	a0,a0,-742 # 74e0 <malloc+0x151a>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	438080e7          	jalr	1080(ra) # 5c06 <link>
    37d6:	34051b63          	bnez	a0,3b2c <subdir+0x47e>
  if (unlink("dd/dd/ff") != 0)
    37da:	00004517          	auipc	a0,0x4
    37de:	d0650513          	addi	a0,a0,-762 # 74e0 <malloc+0x151a>
    37e2:	00002097          	auipc	ra,0x2
    37e6:	414080e7          	jalr	1044(ra) # 5bf6 <unlink>
    37ea:	34051f63          	bnez	a0,3b48 <subdir+0x49a>
  if (open("dd/dd/ff", O_RDONLY) >= 0)
    37ee:	4581                	li	a1,0
    37f0:	00004517          	auipc	a0,0x4
    37f4:	cf050513          	addi	a0,a0,-784 # 74e0 <malloc+0x151a>
    37f8:	00002097          	auipc	ra,0x2
    37fc:	3ee080e7          	jalr	1006(ra) # 5be6 <open>
    3800:	36055263          	bgez	a0,3b64 <subdir+0x4b6>
  if (chdir("dd") != 0)
    3804:	00004517          	auipc	a0,0x4
    3808:	c3c50513          	addi	a0,a0,-964 # 7440 <malloc+0x147a>
    380c:	00002097          	auipc	ra,0x2
    3810:	40a080e7          	jalr	1034(ra) # 5c16 <chdir>
    3814:	36051663          	bnez	a0,3b80 <subdir+0x4d2>
  if (chdir("dd/../../dd") != 0)
    3818:	00004517          	auipc	a0,0x4
    381c:	de850513          	addi	a0,a0,-536 # 7600 <malloc+0x163a>
    3820:	00002097          	auipc	ra,0x2
    3824:	3f6080e7          	jalr	1014(ra) # 5c16 <chdir>
    3828:	36051a63          	bnez	a0,3b9c <subdir+0x4ee>
  if (chdir("dd/../../../dd") != 0)
    382c:	00004517          	auipc	a0,0x4
    3830:	e0450513          	addi	a0,a0,-508 # 7630 <malloc+0x166a>
    3834:	00002097          	auipc	ra,0x2
    3838:	3e2080e7          	jalr	994(ra) # 5c16 <chdir>
    383c:	36051e63          	bnez	a0,3bb8 <subdir+0x50a>
  if (chdir("./..") != 0)
    3840:	00004517          	auipc	a0,0x4
    3844:	e2050513          	addi	a0,a0,-480 # 7660 <malloc+0x169a>
    3848:	00002097          	auipc	ra,0x2
    384c:	3ce080e7          	jalr	974(ra) # 5c16 <chdir>
    3850:	38051263          	bnez	a0,3bd4 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3854:	4581                	li	a1,0
    3856:	00004517          	auipc	a0,0x4
    385a:	d1250513          	addi	a0,a0,-750 # 7568 <malloc+0x15a2>
    385e:	00002097          	auipc	ra,0x2
    3862:	388080e7          	jalr	904(ra) # 5be6 <open>
    3866:	84aa                	mv	s1,a0
  if (fd < 0)
    3868:	38054463          	bltz	a0,3bf0 <subdir+0x542>
  if (read(fd, buf, sizeof(buf)) != 2)
    386c:	660d                	lui	a2,0x3
    386e:	00009597          	auipc	a1,0x9
    3872:	40a58593          	addi	a1,a1,1034 # cc78 <buf>
    3876:	00002097          	auipc	ra,0x2
    387a:	348080e7          	jalr	840(ra) # 5bbe <read>
    387e:	4789                	li	a5,2
    3880:	38f51663          	bne	a0,a5,3c0c <subdir+0x55e>
  close(fd);
    3884:	8526                	mv	a0,s1
    3886:	00002097          	auipc	ra,0x2
    388a:	348080e7          	jalr	840(ra) # 5bce <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0)
    388e:	4581                	li	a1,0
    3890:	00004517          	auipc	a0,0x4
    3894:	c5050513          	addi	a0,a0,-944 # 74e0 <malloc+0x151a>
    3898:	00002097          	auipc	ra,0x2
    389c:	34e080e7          	jalr	846(ra) # 5be6 <open>
    38a0:	38055463          	bgez	a0,3c28 <subdir+0x57a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0)
    38a4:	20200593          	li	a1,514
    38a8:	00004517          	auipc	a0,0x4
    38ac:	e4850513          	addi	a0,a0,-440 # 76f0 <malloc+0x172a>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	336080e7          	jalr	822(ra) # 5be6 <open>
    38b8:	38055663          	bgez	a0,3c44 <subdir+0x596>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0)
    38bc:	20200593          	li	a1,514
    38c0:	00004517          	auipc	a0,0x4
    38c4:	e6050513          	addi	a0,a0,-416 # 7720 <malloc+0x175a>
    38c8:	00002097          	auipc	ra,0x2
    38cc:	31e080e7          	jalr	798(ra) # 5be6 <open>
    38d0:	38055863          	bgez	a0,3c60 <subdir+0x5b2>
  if (open("dd", O_CREATE) >= 0)
    38d4:	20000593          	li	a1,512
    38d8:	00004517          	auipc	a0,0x4
    38dc:	b6850513          	addi	a0,a0,-1176 # 7440 <malloc+0x147a>
    38e0:	00002097          	auipc	ra,0x2
    38e4:	306080e7          	jalr	774(ra) # 5be6 <open>
    38e8:	38055a63          	bgez	a0,3c7c <subdir+0x5ce>
  if (open("dd", O_RDWR) >= 0)
    38ec:	4589                	li	a1,2
    38ee:	00004517          	auipc	a0,0x4
    38f2:	b5250513          	addi	a0,a0,-1198 # 7440 <malloc+0x147a>
    38f6:	00002097          	auipc	ra,0x2
    38fa:	2f0080e7          	jalr	752(ra) # 5be6 <open>
    38fe:	38055d63          	bgez	a0,3c98 <subdir+0x5ea>
  if (open("dd", O_WRONLY) >= 0)
    3902:	4585                	li	a1,1
    3904:	00004517          	auipc	a0,0x4
    3908:	b3c50513          	addi	a0,a0,-1220 # 7440 <malloc+0x147a>
    390c:	00002097          	auipc	ra,0x2
    3910:	2da080e7          	jalr	730(ra) # 5be6 <open>
    3914:	3a055063          	bgez	a0,3cb4 <subdir+0x606>
  if (link("dd/ff/ff", "dd/dd/xx") == 0)
    3918:	00004597          	auipc	a1,0x4
    391c:	e9858593          	addi	a1,a1,-360 # 77b0 <malloc+0x17ea>
    3920:	00004517          	auipc	a0,0x4
    3924:	dd050513          	addi	a0,a0,-560 # 76f0 <malloc+0x172a>
    3928:	00002097          	auipc	ra,0x2
    392c:	2de080e7          	jalr	734(ra) # 5c06 <link>
    3930:	3a050063          	beqz	a0,3cd0 <subdir+0x622>
  if (link("dd/xx/ff", "dd/dd/xx") == 0)
    3934:	00004597          	auipc	a1,0x4
    3938:	e7c58593          	addi	a1,a1,-388 # 77b0 <malloc+0x17ea>
    393c:	00004517          	auipc	a0,0x4
    3940:	de450513          	addi	a0,a0,-540 # 7720 <malloc+0x175a>
    3944:	00002097          	auipc	ra,0x2
    3948:	2c2080e7          	jalr	706(ra) # 5c06 <link>
    394c:	3a050063          	beqz	a0,3cec <subdir+0x63e>
  if (link("dd/ff", "dd/dd/ffff") == 0)
    3950:	00004597          	auipc	a1,0x4
    3954:	c1858593          	addi	a1,a1,-1000 # 7568 <malloc+0x15a2>
    3958:	00004517          	auipc	a0,0x4
    395c:	b0850513          	addi	a0,a0,-1272 # 7460 <malloc+0x149a>
    3960:	00002097          	auipc	ra,0x2
    3964:	2a6080e7          	jalr	678(ra) # 5c06 <link>
    3968:	3a050063          	beqz	a0,3d08 <subdir+0x65a>
  if (mkdir("dd/ff/ff") == 0)
    396c:	00004517          	auipc	a0,0x4
    3970:	d8450513          	addi	a0,a0,-636 # 76f0 <malloc+0x172a>
    3974:	00002097          	auipc	ra,0x2
    3978:	29a080e7          	jalr	666(ra) # 5c0e <mkdir>
    397c:	3a050463          	beqz	a0,3d24 <subdir+0x676>
  if (mkdir("dd/xx/ff") == 0)
    3980:	00004517          	auipc	a0,0x4
    3984:	da050513          	addi	a0,a0,-608 # 7720 <malloc+0x175a>
    3988:	00002097          	auipc	ra,0x2
    398c:	286080e7          	jalr	646(ra) # 5c0e <mkdir>
    3990:	3a050863          	beqz	a0,3d40 <subdir+0x692>
  if (mkdir("dd/dd/ffff") == 0)
    3994:	00004517          	auipc	a0,0x4
    3998:	bd450513          	addi	a0,a0,-1068 # 7568 <malloc+0x15a2>
    399c:	00002097          	auipc	ra,0x2
    39a0:	272080e7          	jalr	626(ra) # 5c0e <mkdir>
    39a4:	3a050c63          	beqz	a0,3d5c <subdir+0x6ae>
  if (unlink("dd/xx/ff") == 0)
    39a8:	00004517          	auipc	a0,0x4
    39ac:	d7850513          	addi	a0,a0,-648 # 7720 <malloc+0x175a>
    39b0:	00002097          	auipc	ra,0x2
    39b4:	246080e7          	jalr	582(ra) # 5bf6 <unlink>
    39b8:	3c050063          	beqz	a0,3d78 <subdir+0x6ca>
  if (unlink("dd/ff/ff") == 0)
    39bc:	00004517          	auipc	a0,0x4
    39c0:	d3450513          	addi	a0,a0,-716 # 76f0 <malloc+0x172a>
    39c4:	00002097          	auipc	ra,0x2
    39c8:	232080e7          	jalr	562(ra) # 5bf6 <unlink>
    39cc:	3c050463          	beqz	a0,3d94 <subdir+0x6e6>
  if (chdir("dd/ff") == 0)
    39d0:	00004517          	auipc	a0,0x4
    39d4:	a9050513          	addi	a0,a0,-1392 # 7460 <malloc+0x149a>
    39d8:	00002097          	auipc	ra,0x2
    39dc:	23e080e7          	jalr	574(ra) # 5c16 <chdir>
    39e0:	3c050863          	beqz	a0,3db0 <subdir+0x702>
  if (chdir("dd/xx") == 0)
    39e4:	00004517          	auipc	a0,0x4
    39e8:	f1c50513          	addi	a0,a0,-228 # 7900 <malloc+0x193a>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	22a080e7          	jalr	554(ra) # 5c16 <chdir>
    39f4:	3c050c63          	beqz	a0,3dcc <subdir+0x71e>
  if (unlink("dd/dd/ffff") != 0)
    39f8:	00004517          	auipc	a0,0x4
    39fc:	b7050513          	addi	a0,a0,-1168 # 7568 <malloc+0x15a2>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	1f6080e7          	jalr	502(ra) # 5bf6 <unlink>
    3a08:	3e051063          	bnez	a0,3de8 <subdir+0x73a>
  if (unlink("dd/ff") != 0)
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	a5450513          	addi	a0,a0,-1452 # 7460 <malloc+0x149a>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	1e2080e7          	jalr	482(ra) # 5bf6 <unlink>
    3a1c:	3e051463          	bnez	a0,3e04 <subdir+0x756>
  if (unlink("dd") == 0)
    3a20:	00004517          	auipc	a0,0x4
    3a24:	a2050513          	addi	a0,a0,-1504 # 7440 <malloc+0x147a>
    3a28:	00002097          	auipc	ra,0x2
    3a2c:	1ce080e7          	jalr	462(ra) # 5bf6 <unlink>
    3a30:	3e050863          	beqz	a0,3e20 <subdir+0x772>
  if (unlink("dd/dd") < 0)
    3a34:	00004517          	auipc	a0,0x4
    3a38:	f3c50513          	addi	a0,a0,-196 # 7970 <malloc+0x19aa>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	1ba080e7          	jalr	442(ra) # 5bf6 <unlink>
    3a44:	3e054c63          	bltz	a0,3e3c <subdir+0x78e>
  if (unlink("dd") < 0)
    3a48:	00004517          	auipc	a0,0x4
    3a4c:	9f850513          	addi	a0,a0,-1544 # 7440 <malloc+0x147a>
    3a50:	00002097          	auipc	ra,0x2
    3a54:	1a6080e7          	jalr	422(ra) # 5bf6 <unlink>
    3a58:	40054063          	bltz	a0,3e58 <subdir+0x7aa>
}
    3a5c:	60e2                	ld	ra,24(sp)
    3a5e:	6442                	ld	s0,16(sp)
    3a60:	64a2                	ld	s1,8(sp)
    3a62:	6902                	ld	s2,0(sp)
    3a64:	6105                	addi	sp,sp,32
    3a66:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a68:	85ca                	mv	a1,s2
    3a6a:	00004517          	auipc	a0,0x4
    3a6e:	9de50513          	addi	a0,a0,-1570 # 7448 <malloc+0x1482>
    3a72:	00002097          	auipc	ra,0x2
    3a76:	49c080e7          	jalr	1180(ra) # 5f0e <printf>
    exit(1);
    3a7a:	4505                	li	a0,1
    3a7c:	00002097          	auipc	ra,0x2
    3a80:	12a080e7          	jalr	298(ra) # 5ba6 <exit>
    printf("%s: create dd/ff failed\n", s);
    3a84:	85ca                	mv	a1,s2
    3a86:	00004517          	auipc	a0,0x4
    3a8a:	9e250513          	addi	a0,a0,-1566 # 7468 <malloc+0x14a2>
    3a8e:	00002097          	auipc	ra,0x2
    3a92:	480080e7          	jalr	1152(ra) # 5f0e <printf>
    exit(1);
    3a96:	4505                	li	a0,1
    3a98:	00002097          	auipc	ra,0x2
    3a9c:	10e080e7          	jalr	270(ra) # 5ba6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3aa0:	85ca                	mv	a1,s2
    3aa2:	00004517          	auipc	a0,0x4
    3aa6:	9e650513          	addi	a0,a0,-1562 # 7488 <malloc+0x14c2>
    3aaa:	00002097          	auipc	ra,0x2
    3aae:	464080e7          	jalr	1124(ra) # 5f0e <printf>
    exit(1);
    3ab2:	4505                	li	a0,1
    3ab4:	00002097          	auipc	ra,0x2
    3ab8:	0f2080e7          	jalr	242(ra) # 5ba6 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3abc:	85ca                	mv	a1,s2
    3abe:	00004517          	auipc	a0,0x4
    3ac2:	a0250513          	addi	a0,a0,-1534 # 74c0 <malloc+0x14fa>
    3ac6:	00002097          	auipc	ra,0x2
    3aca:	448080e7          	jalr	1096(ra) # 5f0e <printf>
    exit(1);
    3ace:	4505                	li	a0,1
    3ad0:	00002097          	auipc	ra,0x2
    3ad4:	0d6080e7          	jalr	214(ra) # 5ba6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ad8:	85ca                	mv	a1,s2
    3ada:	00004517          	auipc	a0,0x4
    3ade:	a1650513          	addi	a0,a0,-1514 # 74f0 <malloc+0x152a>
    3ae2:	00002097          	auipc	ra,0x2
    3ae6:	42c080e7          	jalr	1068(ra) # 5f0e <printf>
    exit(1);
    3aea:	4505                	li	a0,1
    3aec:	00002097          	auipc	ra,0x2
    3af0:	0ba080e7          	jalr	186(ra) # 5ba6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3af4:	85ca                	mv	a1,s2
    3af6:	00004517          	auipc	a0,0x4
    3afa:	a3250513          	addi	a0,a0,-1486 # 7528 <malloc+0x1562>
    3afe:	00002097          	auipc	ra,0x2
    3b02:	410080e7          	jalr	1040(ra) # 5f0e <printf>
    exit(1);
    3b06:	4505                	li	a0,1
    3b08:	00002097          	auipc	ra,0x2
    3b0c:	09e080e7          	jalr	158(ra) # 5ba6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b10:	85ca                	mv	a1,s2
    3b12:	00004517          	auipc	a0,0x4
    3b16:	a3650513          	addi	a0,a0,-1482 # 7548 <malloc+0x1582>
    3b1a:	00002097          	auipc	ra,0x2
    3b1e:	3f4080e7          	jalr	1012(ra) # 5f0e <printf>
    exit(1);
    3b22:	4505                	li	a0,1
    3b24:	00002097          	auipc	ra,0x2
    3b28:	082080e7          	jalr	130(ra) # 5ba6 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b2c:	85ca                	mv	a1,s2
    3b2e:	00004517          	auipc	a0,0x4
    3b32:	a4a50513          	addi	a0,a0,-1462 # 7578 <malloc+0x15b2>
    3b36:	00002097          	auipc	ra,0x2
    3b3a:	3d8080e7          	jalr	984(ra) # 5f0e <printf>
    exit(1);
    3b3e:	4505                	li	a0,1
    3b40:	00002097          	auipc	ra,0x2
    3b44:	066080e7          	jalr	102(ra) # 5ba6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b48:	85ca                	mv	a1,s2
    3b4a:	00004517          	auipc	a0,0x4
    3b4e:	a5650513          	addi	a0,a0,-1450 # 75a0 <malloc+0x15da>
    3b52:	00002097          	auipc	ra,0x2
    3b56:	3bc080e7          	jalr	956(ra) # 5f0e <printf>
    exit(1);
    3b5a:	4505                	li	a0,1
    3b5c:	00002097          	auipc	ra,0x2
    3b60:	04a080e7          	jalr	74(ra) # 5ba6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b64:	85ca                	mv	a1,s2
    3b66:	00004517          	auipc	a0,0x4
    3b6a:	a5a50513          	addi	a0,a0,-1446 # 75c0 <malloc+0x15fa>
    3b6e:	00002097          	auipc	ra,0x2
    3b72:	3a0080e7          	jalr	928(ra) # 5f0e <printf>
    exit(1);
    3b76:	4505                	li	a0,1
    3b78:	00002097          	auipc	ra,0x2
    3b7c:	02e080e7          	jalr	46(ra) # 5ba6 <exit>
    printf("%s: chdir dd failed\n", s);
    3b80:	85ca                	mv	a1,s2
    3b82:	00004517          	auipc	a0,0x4
    3b86:	a6650513          	addi	a0,a0,-1434 # 75e8 <malloc+0x1622>
    3b8a:	00002097          	auipc	ra,0x2
    3b8e:	384080e7          	jalr	900(ra) # 5f0e <printf>
    exit(1);
    3b92:	4505                	li	a0,1
    3b94:	00002097          	auipc	ra,0x2
    3b98:	012080e7          	jalr	18(ra) # 5ba6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b9c:	85ca                	mv	a1,s2
    3b9e:	00004517          	auipc	a0,0x4
    3ba2:	a7250513          	addi	a0,a0,-1422 # 7610 <malloc+0x164a>
    3ba6:	00002097          	auipc	ra,0x2
    3baa:	368080e7          	jalr	872(ra) # 5f0e <printf>
    exit(1);
    3bae:	4505                	li	a0,1
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	ff6080e7          	jalr	-10(ra) # 5ba6 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3bb8:	85ca                	mv	a1,s2
    3bba:	00004517          	auipc	a0,0x4
    3bbe:	a8650513          	addi	a0,a0,-1402 # 7640 <malloc+0x167a>
    3bc2:	00002097          	auipc	ra,0x2
    3bc6:	34c080e7          	jalr	844(ra) # 5f0e <printf>
    exit(1);
    3bca:	4505                	li	a0,1
    3bcc:	00002097          	auipc	ra,0x2
    3bd0:	fda080e7          	jalr	-38(ra) # 5ba6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bd4:	85ca                	mv	a1,s2
    3bd6:	00004517          	auipc	a0,0x4
    3bda:	a9250513          	addi	a0,a0,-1390 # 7668 <malloc+0x16a2>
    3bde:	00002097          	auipc	ra,0x2
    3be2:	330080e7          	jalr	816(ra) # 5f0e <printf>
    exit(1);
    3be6:	4505                	li	a0,1
    3be8:	00002097          	auipc	ra,0x2
    3bec:	fbe080e7          	jalr	-66(ra) # 5ba6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bf0:	85ca                	mv	a1,s2
    3bf2:	00004517          	auipc	a0,0x4
    3bf6:	a8e50513          	addi	a0,a0,-1394 # 7680 <malloc+0x16ba>
    3bfa:	00002097          	auipc	ra,0x2
    3bfe:	314080e7          	jalr	788(ra) # 5f0e <printf>
    exit(1);
    3c02:	4505                	li	a0,1
    3c04:	00002097          	auipc	ra,0x2
    3c08:	fa2080e7          	jalr	-94(ra) # 5ba6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c0c:	85ca                	mv	a1,s2
    3c0e:	00004517          	auipc	a0,0x4
    3c12:	a9250513          	addi	a0,a0,-1390 # 76a0 <malloc+0x16da>
    3c16:	00002097          	auipc	ra,0x2
    3c1a:	2f8080e7          	jalr	760(ra) # 5f0e <printf>
    exit(1);
    3c1e:	4505                	li	a0,1
    3c20:	00002097          	auipc	ra,0x2
    3c24:	f86080e7          	jalr	-122(ra) # 5ba6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c28:	85ca                	mv	a1,s2
    3c2a:	00004517          	auipc	a0,0x4
    3c2e:	a9650513          	addi	a0,a0,-1386 # 76c0 <malloc+0x16fa>
    3c32:	00002097          	auipc	ra,0x2
    3c36:	2dc080e7          	jalr	732(ra) # 5f0e <printf>
    exit(1);
    3c3a:	4505                	li	a0,1
    3c3c:	00002097          	auipc	ra,0x2
    3c40:	f6a080e7          	jalr	-150(ra) # 5ba6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c44:	85ca                	mv	a1,s2
    3c46:	00004517          	auipc	a0,0x4
    3c4a:	aba50513          	addi	a0,a0,-1350 # 7700 <malloc+0x173a>
    3c4e:	00002097          	auipc	ra,0x2
    3c52:	2c0080e7          	jalr	704(ra) # 5f0e <printf>
    exit(1);
    3c56:	4505                	li	a0,1
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	f4e080e7          	jalr	-178(ra) # 5ba6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c60:	85ca                	mv	a1,s2
    3c62:	00004517          	auipc	a0,0x4
    3c66:	ace50513          	addi	a0,a0,-1330 # 7730 <malloc+0x176a>
    3c6a:	00002097          	auipc	ra,0x2
    3c6e:	2a4080e7          	jalr	676(ra) # 5f0e <printf>
    exit(1);
    3c72:	4505                	li	a0,1
    3c74:	00002097          	auipc	ra,0x2
    3c78:	f32080e7          	jalr	-206(ra) # 5ba6 <exit>
    printf("%s: create dd succeeded!\n", s);
    3c7c:	85ca                	mv	a1,s2
    3c7e:	00004517          	auipc	a0,0x4
    3c82:	ad250513          	addi	a0,a0,-1326 # 7750 <malloc+0x178a>
    3c86:	00002097          	auipc	ra,0x2
    3c8a:	288080e7          	jalr	648(ra) # 5f0e <printf>
    exit(1);
    3c8e:	4505                	li	a0,1
    3c90:	00002097          	auipc	ra,0x2
    3c94:	f16080e7          	jalr	-234(ra) # 5ba6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c98:	85ca                	mv	a1,s2
    3c9a:	00004517          	auipc	a0,0x4
    3c9e:	ad650513          	addi	a0,a0,-1322 # 7770 <malloc+0x17aa>
    3ca2:	00002097          	auipc	ra,0x2
    3ca6:	26c080e7          	jalr	620(ra) # 5f0e <printf>
    exit(1);
    3caa:	4505                	li	a0,1
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	efa080e7          	jalr	-262(ra) # 5ba6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3cb4:	85ca                	mv	a1,s2
    3cb6:	00004517          	auipc	a0,0x4
    3cba:	ada50513          	addi	a0,a0,-1318 # 7790 <malloc+0x17ca>
    3cbe:	00002097          	auipc	ra,0x2
    3cc2:	250080e7          	jalr	592(ra) # 5f0e <printf>
    exit(1);
    3cc6:	4505                	li	a0,1
    3cc8:	00002097          	auipc	ra,0x2
    3ccc:	ede080e7          	jalr	-290(ra) # 5ba6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cd0:	85ca                	mv	a1,s2
    3cd2:	00004517          	auipc	a0,0x4
    3cd6:	aee50513          	addi	a0,a0,-1298 # 77c0 <malloc+0x17fa>
    3cda:	00002097          	auipc	ra,0x2
    3cde:	234080e7          	jalr	564(ra) # 5f0e <printf>
    exit(1);
    3ce2:	4505                	li	a0,1
    3ce4:	00002097          	auipc	ra,0x2
    3ce8:	ec2080e7          	jalr	-318(ra) # 5ba6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cec:	85ca                	mv	a1,s2
    3cee:	00004517          	auipc	a0,0x4
    3cf2:	afa50513          	addi	a0,a0,-1286 # 77e8 <malloc+0x1822>
    3cf6:	00002097          	auipc	ra,0x2
    3cfa:	218080e7          	jalr	536(ra) # 5f0e <printf>
    exit(1);
    3cfe:	4505                	li	a0,1
    3d00:	00002097          	auipc	ra,0x2
    3d04:	ea6080e7          	jalr	-346(ra) # 5ba6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d08:	85ca                	mv	a1,s2
    3d0a:	00004517          	auipc	a0,0x4
    3d0e:	b0650513          	addi	a0,a0,-1274 # 7810 <malloc+0x184a>
    3d12:	00002097          	auipc	ra,0x2
    3d16:	1fc080e7          	jalr	508(ra) # 5f0e <printf>
    exit(1);
    3d1a:	4505                	li	a0,1
    3d1c:	00002097          	auipc	ra,0x2
    3d20:	e8a080e7          	jalr	-374(ra) # 5ba6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d24:	85ca                	mv	a1,s2
    3d26:	00004517          	auipc	a0,0x4
    3d2a:	b1250513          	addi	a0,a0,-1262 # 7838 <malloc+0x1872>
    3d2e:	00002097          	auipc	ra,0x2
    3d32:	1e0080e7          	jalr	480(ra) # 5f0e <printf>
    exit(1);
    3d36:	4505                	li	a0,1
    3d38:	00002097          	auipc	ra,0x2
    3d3c:	e6e080e7          	jalr	-402(ra) # 5ba6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d40:	85ca                	mv	a1,s2
    3d42:	00004517          	auipc	a0,0x4
    3d46:	b1650513          	addi	a0,a0,-1258 # 7858 <malloc+0x1892>
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	1c4080e7          	jalr	452(ra) # 5f0e <printf>
    exit(1);
    3d52:	4505                	li	a0,1
    3d54:	00002097          	auipc	ra,0x2
    3d58:	e52080e7          	jalr	-430(ra) # 5ba6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d5c:	85ca                	mv	a1,s2
    3d5e:	00004517          	auipc	a0,0x4
    3d62:	b1a50513          	addi	a0,a0,-1254 # 7878 <malloc+0x18b2>
    3d66:	00002097          	auipc	ra,0x2
    3d6a:	1a8080e7          	jalr	424(ra) # 5f0e <printf>
    exit(1);
    3d6e:	4505                	li	a0,1
    3d70:	00002097          	auipc	ra,0x2
    3d74:	e36080e7          	jalr	-458(ra) # 5ba6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d78:	85ca                	mv	a1,s2
    3d7a:	00004517          	auipc	a0,0x4
    3d7e:	b2650513          	addi	a0,a0,-1242 # 78a0 <malloc+0x18da>
    3d82:	00002097          	auipc	ra,0x2
    3d86:	18c080e7          	jalr	396(ra) # 5f0e <printf>
    exit(1);
    3d8a:	4505                	li	a0,1
    3d8c:	00002097          	auipc	ra,0x2
    3d90:	e1a080e7          	jalr	-486(ra) # 5ba6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d94:	85ca                	mv	a1,s2
    3d96:	00004517          	auipc	a0,0x4
    3d9a:	b2a50513          	addi	a0,a0,-1238 # 78c0 <malloc+0x18fa>
    3d9e:	00002097          	auipc	ra,0x2
    3da2:	170080e7          	jalr	368(ra) # 5f0e <printf>
    exit(1);
    3da6:	4505                	li	a0,1
    3da8:	00002097          	auipc	ra,0x2
    3dac:	dfe080e7          	jalr	-514(ra) # 5ba6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3db0:	85ca                	mv	a1,s2
    3db2:	00004517          	auipc	a0,0x4
    3db6:	b2e50513          	addi	a0,a0,-1234 # 78e0 <malloc+0x191a>
    3dba:	00002097          	auipc	ra,0x2
    3dbe:	154080e7          	jalr	340(ra) # 5f0e <printf>
    exit(1);
    3dc2:	4505                	li	a0,1
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	de2080e7          	jalr	-542(ra) # 5ba6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3dcc:	85ca                	mv	a1,s2
    3dce:	00004517          	auipc	a0,0x4
    3dd2:	b3a50513          	addi	a0,a0,-1222 # 7908 <malloc+0x1942>
    3dd6:	00002097          	auipc	ra,0x2
    3dda:	138080e7          	jalr	312(ra) # 5f0e <printf>
    exit(1);
    3dde:	4505                	li	a0,1
    3de0:	00002097          	auipc	ra,0x2
    3de4:	dc6080e7          	jalr	-570(ra) # 5ba6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3de8:	85ca                	mv	a1,s2
    3dea:	00003517          	auipc	a0,0x3
    3dee:	7b650513          	addi	a0,a0,1974 # 75a0 <malloc+0x15da>
    3df2:	00002097          	auipc	ra,0x2
    3df6:	11c080e7          	jalr	284(ra) # 5f0e <printf>
    exit(1);
    3dfa:	4505                	li	a0,1
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	daa080e7          	jalr	-598(ra) # 5ba6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e04:	85ca                	mv	a1,s2
    3e06:	00004517          	auipc	a0,0x4
    3e0a:	b2250513          	addi	a0,a0,-1246 # 7928 <malloc+0x1962>
    3e0e:	00002097          	auipc	ra,0x2
    3e12:	100080e7          	jalr	256(ra) # 5f0e <printf>
    exit(1);
    3e16:	4505                	li	a0,1
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	d8e080e7          	jalr	-626(ra) # 5ba6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e20:	85ca                	mv	a1,s2
    3e22:	00004517          	auipc	a0,0x4
    3e26:	b2650513          	addi	a0,a0,-1242 # 7948 <malloc+0x1982>
    3e2a:	00002097          	auipc	ra,0x2
    3e2e:	0e4080e7          	jalr	228(ra) # 5f0e <printf>
    exit(1);
    3e32:	4505                	li	a0,1
    3e34:	00002097          	auipc	ra,0x2
    3e38:	d72080e7          	jalr	-654(ra) # 5ba6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e3c:	85ca                	mv	a1,s2
    3e3e:	00004517          	auipc	a0,0x4
    3e42:	b3a50513          	addi	a0,a0,-1222 # 7978 <malloc+0x19b2>
    3e46:	00002097          	auipc	ra,0x2
    3e4a:	0c8080e7          	jalr	200(ra) # 5f0e <printf>
    exit(1);
    3e4e:	4505                	li	a0,1
    3e50:	00002097          	auipc	ra,0x2
    3e54:	d56080e7          	jalr	-682(ra) # 5ba6 <exit>
    printf("%s: unlink dd failed\n", s);
    3e58:	85ca                	mv	a1,s2
    3e5a:	00004517          	auipc	a0,0x4
    3e5e:	b3e50513          	addi	a0,a0,-1218 # 7998 <malloc+0x19d2>
    3e62:	00002097          	auipc	ra,0x2
    3e66:	0ac080e7          	jalr	172(ra) # 5f0e <printf>
    exit(1);
    3e6a:	4505                	li	a0,1
    3e6c:	00002097          	auipc	ra,0x2
    3e70:	d3a080e7          	jalr	-710(ra) # 5ba6 <exit>

0000000000003e74 <rmdot>:
{
    3e74:	1101                	addi	sp,sp,-32
    3e76:	ec06                	sd	ra,24(sp)
    3e78:	e822                	sd	s0,16(sp)
    3e7a:	e426                	sd	s1,8(sp)
    3e7c:	1000                	addi	s0,sp,32
    3e7e:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0)
    3e80:	00004517          	auipc	a0,0x4
    3e84:	b3050513          	addi	a0,a0,-1232 # 79b0 <malloc+0x19ea>
    3e88:	00002097          	auipc	ra,0x2
    3e8c:	d86080e7          	jalr	-634(ra) # 5c0e <mkdir>
    3e90:	e549                	bnez	a0,3f1a <rmdot+0xa6>
  if (chdir("dots") != 0)
    3e92:	00004517          	auipc	a0,0x4
    3e96:	b1e50513          	addi	a0,a0,-1250 # 79b0 <malloc+0x19ea>
    3e9a:	00002097          	auipc	ra,0x2
    3e9e:	d7c080e7          	jalr	-644(ra) # 5c16 <chdir>
    3ea2:	e951                	bnez	a0,3f36 <rmdot+0xc2>
  if (unlink(".") == 0)
    3ea4:	00003517          	auipc	a0,0x3
    3ea8:	92c50513          	addi	a0,a0,-1748 # 67d0 <malloc+0x80a>
    3eac:	00002097          	auipc	ra,0x2
    3eb0:	d4a080e7          	jalr	-694(ra) # 5bf6 <unlink>
    3eb4:	cd59                	beqz	a0,3f52 <rmdot+0xde>
  if (unlink("..") == 0)
    3eb6:	00003517          	auipc	a0,0x3
    3eba:	55250513          	addi	a0,a0,1362 # 7408 <malloc+0x1442>
    3ebe:	00002097          	auipc	ra,0x2
    3ec2:	d38080e7          	jalr	-712(ra) # 5bf6 <unlink>
    3ec6:	c545                	beqz	a0,3f6e <rmdot+0xfa>
  if (chdir("/") != 0)
    3ec8:	00003517          	auipc	a0,0x3
    3ecc:	4e850513          	addi	a0,a0,1256 # 73b0 <malloc+0x13ea>
    3ed0:	00002097          	auipc	ra,0x2
    3ed4:	d46080e7          	jalr	-698(ra) # 5c16 <chdir>
    3ed8:	e94d                	bnez	a0,3f8a <rmdot+0x116>
  if (unlink("dots/.") == 0)
    3eda:	00004517          	auipc	a0,0x4
    3ede:	b3e50513          	addi	a0,a0,-1218 # 7a18 <malloc+0x1a52>
    3ee2:	00002097          	auipc	ra,0x2
    3ee6:	d14080e7          	jalr	-748(ra) # 5bf6 <unlink>
    3eea:	cd55                	beqz	a0,3fa6 <rmdot+0x132>
  if (unlink("dots/..") == 0)
    3eec:	00004517          	auipc	a0,0x4
    3ef0:	b5450513          	addi	a0,a0,-1196 # 7a40 <malloc+0x1a7a>
    3ef4:	00002097          	auipc	ra,0x2
    3ef8:	d02080e7          	jalr	-766(ra) # 5bf6 <unlink>
    3efc:	c179                	beqz	a0,3fc2 <rmdot+0x14e>
  if (unlink("dots") != 0)
    3efe:	00004517          	auipc	a0,0x4
    3f02:	ab250513          	addi	a0,a0,-1358 # 79b0 <malloc+0x19ea>
    3f06:	00002097          	auipc	ra,0x2
    3f0a:	cf0080e7          	jalr	-784(ra) # 5bf6 <unlink>
    3f0e:	e961                	bnez	a0,3fde <rmdot+0x16a>
}
    3f10:	60e2                	ld	ra,24(sp)
    3f12:	6442                	ld	s0,16(sp)
    3f14:	64a2                	ld	s1,8(sp)
    3f16:	6105                	addi	sp,sp,32
    3f18:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f1a:	85a6                	mv	a1,s1
    3f1c:	00004517          	auipc	a0,0x4
    3f20:	a9c50513          	addi	a0,a0,-1380 # 79b8 <malloc+0x19f2>
    3f24:	00002097          	auipc	ra,0x2
    3f28:	fea080e7          	jalr	-22(ra) # 5f0e <printf>
    exit(1);
    3f2c:	4505                	li	a0,1
    3f2e:	00002097          	auipc	ra,0x2
    3f32:	c78080e7          	jalr	-904(ra) # 5ba6 <exit>
    printf("%s: chdir dots failed\n", s);
    3f36:	85a6                	mv	a1,s1
    3f38:	00004517          	auipc	a0,0x4
    3f3c:	a9850513          	addi	a0,a0,-1384 # 79d0 <malloc+0x1a0a>
    3f40:	00002097          	auipc	ra,0x2
    3f44:	fce080e7          	jalr	-50(ra) # 5f0e <printf>
    exit(1);
    3f48:	4505                	li	a0,1
    3f4a:	00002097          	auipc	ra,0x2
    3f4e:	c5c080e7          	jalr	-932(ra) # 5ba6 <exit>
    printf("%s: rm . worked!\n", s);
    3f52:	85a6                	mv	a1,s1
    3f54:	00004517          	auipc	a0,0x4
    3f58:	a9450513          	addi	a0,a0,-1388 # 79e8 <malloc+0x1a22>
    3f5c:	00002097          	auipc	ra,0x2
    3f60:	fb2080e7          	jalr	-78(ra) # 5f0e <printf>
    exit(1);
    3f64:	4505                	li	a0,1
    3f66:	00002097          	auipc	ra,0x2
    3f6a:	c40080e7          	jalr	-960(ra) # 5ba6 <exit>
    printf("%s: rm .. worked!\n", s);
    3f6e:	85a6                	mv	a1,s1
    3f70:	00004517          	auipc	a0,0x4
    3f74:	a9050513          	addi	a0,a0,-1392 # 7a00 <malloc+0x1a3a>
    3f78:	00002097          	auipc	ra,0x2
    3f7c:	f96080e7          	jalr	-106(ra) # 5f0e <printf>
    exit(1);
    3f80:	4505                	li	a0,1
    3f82:	00002097          	auipc	ra,0x2
    3f86:	c24080e7          	jalr	-988(ra) # 5ba6 <exit>
    printf("%s: chdir / failed\n", s);
    3f8a:	85a6                	mv	a1,s1
    3f8c:	00003517          	auipc	a0,0x3
    3f90:	42c50513          	addi	a0,a0,1068 # 73b8 <malloc+0x13f2>
    3f94:	00002097          	auipc	ra,0x2
    3f98:	f7a080e7          	jalr	-134(ra) # 5f0e <printf>
    exit(1);
    3f9c:	4505                	li	a0,1
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	c08080e7          	jalr	-1016(ra) # 5ba6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3fa6:	85a6                	mv	a1,s1
    3fa8:	00004517          	auipc	a0,0x4
    3fac:	a7850513          	addi	a0,a0,-1416 # 7a20 <malloc+0x1a5a>
    3fb0:	00002097          	auipc	ra,0x2
    3fb4:	f5e080e7          	jalr	-162(ra) # 5f0e <printf>
    exit(1);
    3fb8:	4505                	li	a0,1
    3fba:	00002097          	auipc	ra,0x2
    3fbe:	bec080e7          	jalr	-1044(ra) # 5ba6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fc2:	85a6                	mv	a1,s1
    3fc4:	00004517          	auipc	a0,0x4
    3fc8:	a8450513          	addi	a0,a0,-1404 # 7a48 <malloc+0x1a82>
    3fcc:	00002097          	auipc	ra,0x2
    3fd0:	f42080e7          	jalr	-190(ra) # 5f0e <printf>
    exit(1);
    3fd4:	4505                	li	a0,1
    3fd6:	00002097          	auipc	ra,0x2
    3fda:	bd0080e7          	jalr	-1072(ra) # 5ba6 <exit>
    printf("%s: unlink dots failed!\n", s);
    3fde:	85a6                	mv	a1,s1
    3fe0:	00004517          	auipc	a0,0x4
    3fe4:	a8850513          	addi	a0,a0,-1400 # 7a68 <malloc+0x1aa2>
    3fe8:	00002097          	auipc	ra,0x2
    3fec:	f26080e7          	jalr	-218(ra) # 5f0e <printf>
    exit(1);
    3ff0:	4505                	li	a0,1
    3ff2:	00002097          	auipc	ra,0x2
    3ff6:	bb4080e7          	jalr	-1100(ra) # 5ba6 <exit>

0000000000003ffa <dirfile>:
{
    3ffa:	1101                	addi	sp,sp,-32
    3ffc:	ec06                	sd	ra,24(sp)
    3ffe:	e822                	sd	s0,16(sp)
    4000:	e426                	sd	s1,8(sp)
    4002:	e04a                	sd	s2,0(sp)
    4004:	1000                	addi	s0,sp,32
    4006:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4008:	20000593          	li	a1,512
    400c:	00004517          	auipc	a0,0x4
    4010:	a7c50513          	addi	a0,a0,-1412 # 7a88 <malloc+0x1ac2>
    4014:	00002097          	auipc	ra,0x2
    4018:	bd2080e7          	jalr	-1070(ra) # 5be6 <open>
  if (fd < 0)
    401c:	0e054d63          	bltz	a0,4116 <dirfile+0x11c>
  close(fd);
    4020:	00002097          	auipc	ra,0x2
    4024:	bae080e7          	jalr	-1106(ra) # 5bce <close>
  if (chdir("dirfile") == 0)
    4028:	00004517          	auipc	a0,0x4
    402c:	a6050513          	addi	a0,a0,-1440 # 7a88 <malloc+0x1ac2>
    4030:	00002097          	auipc	ra,0x2
    4034:	be6080e7          	jalr	-1050(ra) # 5c16 <chdir>
    4038:	cd6d                	beqz	a0,4132 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    403a:	4581                	li	a1,0
    403c:	00004517          	auipc	a0,0x4
    4040:	a9450513          	addi	a0,a0,-1388 # 7ad0 <malloc+0x1b0a>
    4044:	00002097          	auipc	ra,0x2
    4048:	ba2080e7          	jalr	-1118(ra) # 5be6 <open>
  if (fd >= 0)
    404c:	10055163          	bgez	a0,414e <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    4050:	20000593          	li	a1,512
    4054:	00004517          	auipc	a0,0x4
    4058:	a7c50513          	addi	a0,a0,-1412 # 7ad0 <malloc+0x1b0a>
    405c:	00002097          	auipc	ra,0x2
    4060:	b8a080e7          	jalr	-1142(ra) # 5be6 <open>
  if (fd >= 0)
    4064:	10055363          	bgez	a0,416a <dirfile+0x170>
  if (mkdir("dirfile/xx") == 0)
    4068:	00004517          	auipc	a0,0x4
    406c:	a6850513          	addi	a0,a0,-1432 # 7ad0 <malloc+0x1b0a>
    4070:	00002097          	auipc	ra,0x2
    4074:	b9e080e7          	jalr	-1122(ra) # 5c0e <mkdir>
    4078:	10050763          	beqz	a0,4186 <dirfile+0x18c>
  if (unlink("dirfile/xx") == 0)
    407c:	00004517          	auipc	a0,0x4
    4080:	a5450513          	addi	a0,a0,-1452 # 7ad0 <malloc+0x1b0a>
    4084:	00002097          	auipc	ra,0x2
    4088:	b72080e7          	jalr	-1166(ra) # 5bf6 <unlink>
    408c:	10050b63          	beqz	a0,41a2 <dirfile+0x1a8>
  if (link("README", "dirfile/xx") == 0)
    4090:	00004597          	auipc	a1,0x4
    4094:	a4058593          	addi	a1,a1,-1472 # 7ad0 <malloc+0x1b0a>
    4098:	00002517          	auipc	a0,0x2
    409c:	22850513          	addi	a0,a0,552 # 62c0 <malloc+0x2fa>
    40a0:	00002097          	auipc	ra,0x2
    40a4:	b66080e7          	jalr	-1178(ra) # 5c06 <link>
    40a8:	10050b63          	beqz	a0,41be <dirfile+0x1c4>
  if (unlink("dirfile") != 0)
    40ac:	00004517          	auipc	a0,0x4
    40b0:	9dc50513          	addi	a0,a0,-1572 # 7a88 <malloc+0x1ac2>
    40b4:	00002097          	auipc	ra,0x2
    40b8:	b42080e7          	jalr	-1214(ra) # 5bf6 <unlink>
    40bc:	10051f63          	bnez	a0,41da <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40c0:	4589                	li	a1,2
    40c2:	00002517          	auipc	a0,0x2
    40c6:	70e50513          	addi	a0,a0,1806 # 67d0 <malloc+0x80a>
    40ca:	00002097          	auipc	ra,0x2
    40ce:	b1c080e7          	jalr	-1252(ra) # 5be6 <open>
  if (fd >= 0)
    40d2:	12055263          	bgez	a0,41f6 <dirfile+0x1fc>
  fd = open(".", 0);
    40d6:	4581                	li	a1,0
    40d8:	00002517          	auipc	a0,0x2
    40dc:	6f850513          	addi	a0,a0,1784 # 67d0 <malloc+0x80a>
    40e0:	00002097          	auipc	ra,0x2
    40e4:	b06080e7          	jalr	-1274(ra) # 5be6 <open>
    40e8:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0)
    40ea:	4605                	li	a2,1
    40ec:	00002597          	auipc	a1,0x2
    40f0:	06c58593          	addi	a1,a1,108 # 6158 <malloc+0x192>
    40f4:	00002097          	auipc	ra,0x2
    40f8:	ad2080e7          	jalr	-1326(ra) # 5bc6 <write>
    40fc:	10a04b63          	bgtz	a0,4212 <dirfile+0x218>
  close(fd);
    4100:	8526                	mv	a0,s1
    4102:	00002097          	auipc	ra,0x2
    4106:	acc080e7          	jalr	-1332(ra) # 5bce <close>
}
    410a:	60e2                	ld	ra,24(sp)
    410c:	6442                	ld	s0,16(sp)
    410e:	64a2                	ld	s1,8(sp)
    4110:	6902                	ld	s2,0(sp)
    4112:	6105                	addi	sp,sp,32
    4114:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4116:	85ca                	mv	a1,s2
    4118:	00004517          	auipc	a0,0x4
    411c:	97850513          	addi	a0,a0,-1672 # 7a90 <malloc+0x1aca>
    4120:	00002097          	auipc	ra,0x2
    4124:	dee080e7          	jalr	-530(ra) # 5f0e <printf>
    exit(1);
    4128:	4505                	li	a0,1
    412a:	00002097          	auipc	ra,0x2
    412e:	a7c080e7          	jalr	-1412(ra) # 5ba6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4132:	85ca                	mv	a1,s2
    4134:	00004517          	auipc	a0,0x4
    4138:	97c50513          	addi	a0,a0,-1668 # 7ab0 <malloc+0x1aea>
    413c:	00002097          	auipc	ra,0x2
    4140:	dd2080e7          	jalr	-558(ra) # 5f0e <printf>
    exit(1);
    4144:	4505                	li	a0,1
    4146:	00002097          	auipc	ra,0x2
    414a:	a60080e7          	jalr	-1440(ra) # 5ba6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    414e:	85ca                	mv	a1,s2
    4150:	00004517          	auipc	a0,0x4
    4154:	99050513          	addi	a0,a0,-1648 # 7ae0 <malloc+0x1b1a>
    4158:	00002097          	auipc	ra,0x2
    415c:	db6080e7          	jalr	-586(ra) # 5f0e <printf>
    exit(1);
    4160:	4505                	li	a0,1
    4162:	00002097          	auipc	ra,0x2
    4166:	a44080e7          	jalr	-1468(ra) # 5ba6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    416a:	85ca                	mv	a1,s2
    416c:	00004517          	auipc	a0,0x4
    4170:	97450513          	addi	a0,a0,-1676 # 7ae0 <malloc+0x1b1a>
    4174:	00002097          	auipc	ra,0x2
    4178:	d9a080e7          	jalr	-614(ra) # 5f0e <printf>
    exit(1);
    417c:	4505                	li	a0,1
    417e:	00002097          	auipc	ra,0x2
    4182:	a28080e7          	jalr	-1496(ra) # 5ba6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4186:	85ca                	mv	a1,s2
    4188:	00004517          	auipc	a0,0x4
    418c:	98050513          	addi	a0,a0,-1664 # 7b08 <malloc+0x1b42>
    4190:	00002097          	auipc	ra,0x2
    4194:	d7e080e7          	jalr	-642(ra) # 5f0e <printf>
    exit(1);
    4198:	4505                	li	a0,1
    419a:	00002097          	auipc	ra,0x2
    419e:	a0c080e7          	jalr	-1524(ra) # 5ba6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41a2:	85ca                	mv	a1,s2
    41a4:	00004517          	auipc	a0,0x4
    41a8:	98c50513          	addi	a0,a0,-1652 # 7b30 <malloc+0x1b6a>
    41ac:	00002097          	auipc	ra,0x2
    41b0:	d62080e7          	jalr	-670(ra) # 5f0e <printf>
    exit(1);
    41b4:	4505                	li	a0,1
    41b6:	00002097          	auipc	ra,0x2
    41ba:	9f0080e7          	jalr	-1552(ra) # 5ba6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41be:	85ca                	mv	a1,s2
    41c0:	00004517          	auipc	a0,0x4
    41c4:	99850513          	addi	a0,a0,-1640 # 7b58 <malloc+0x1b92>
    41c8:	00002097          	auipc	ra,0x2
    41cc:	d46080e7          	jalr	-698(ra) # 5f0e <printf>
    exit(1);
    41d0:	4505                	li	a0,1
    41d2:	00002097          	auipc	ra,0x2
    41d6:	9d4080e7          	jalr	-1580(ra) # 5ba6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41da:	85ca                	mv	a1,s2
    41dc:	00004517          	auipc	a0,0x4
    41e0:	9a450513          	addi	a0,a0,-1628 # 7b80 <malloc+0x1bba>
    41e4:	00002097          	auipc	ra,0x2
    41e8:	d2a080e7          	jalr	-726(ra) # 5f0e <printf>
    exit(1);
    41ec:	4505                	li	a0,1
    41ee:	00002097          	auipc	ra,0x2
    41f2:	9b8080e7          	jalr	-1608(ra) # 5ba6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41f6:	85ca                	mv	a1,s2
    41f8:	00004517          	auipc	a0,0x4
    41fc:	9a850513          	addi	a0,a0,-1624 # 7ba0 <malloc+0x1bda>
    4200:	00002097          	auipc	ra,0x2
    4204:	d0e080e7          	jalr	-754(ra) # 5f0e <printf>
    exit(1);
    4208:	4505                	li	a0,1
    420a:	00002097          	auipc	ra,0x2
    420e:	99c080e7          	jalr	-1636(ra) # 5ba6 <exit>
    printf("%s: write . succeeded!\n", s);
    4212:	85ca                	mv	a1,s2
    4214:	00004517          	auipc	a0,0x4
    4218:	9b450513          	addi	a0,a0,-1612 # 7bc8 <malloc+0x1c02>
    421c:	00002097          	auipc	ra,0x2
    4220:	cf2080e7          	jalr	-782(ra) # 5f0e <printf>
    exit(1);
    4224:	4505                	li	a0,1
    4226:	00002097          	auipc	ra,0x2
    422a:	980080e7          	jalr	-1664(ra) # 5ba6 <exit>

000000000000422e <iref>:
{
    422e:	7139                	addi	sp,sp,-64
    4230:	fc06                	sd	ra,56(sp)
    4232:	f822                	sd	s0,48(sp)
    4234:	f426                	sd	s1,40(sp)
    4236:	f04a                	sd	s2,32(sp)
    4238:	ec4e                	sd	s3,24(sp)
    423a:	e852                	sd	s4,16(sp)
    423c:	e456                	sd	s5,8(sp)
    423e:	e05a                	sd	s6,0(sp)
    4240:	0080                	addi	s0,sp,64
    4242:	8b2a                	mv	s6,a0
    4244:	03300913          	li	s2,51
    if (mkdir("irefd") != 0)
    4248:	00004a17          	auipc	s4,0x4
    424c:	998a0a13          	addi	s4,s4,-1640 # 7be0 <malloc+0x1c1a>
    mkdir("");
    4250:	00003497          	auipc	s1,0x3
    4254:	49848493          	addi	s1,s1,1176 # 76e8 <malloc+0x1722>
    link("README", "");
    4258:	00002a97          	auipc	s5,0x2
    425c:	068a8a93          	addi	s5,s5,104 # 62c0 <malloc+0x2fa>
    fd = open("xx", O_CREATE);
    4260:	00004997          	auipc	s3,0x4
    4264:	87898993          	addi	s3,s3,-1928 # 7ad8 <malloc+0x1b12>
    4268:	a891                	j	42bc <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    426a:	85da                	mv	a1,s6
    426c:	00004517          	auipc	a0,0x4
    4270:	97c50513          	addi	a0,a0,-1668 # 7be8 <malloc+0x1c22>
    4274:	00002097          	auipc	ra,0x2
    4278:	c9a080e7          	jalr	-870(ra) # 5f0e <printf>
      exit(1);
    427c:	4505                	li	a0,1
    427e:	00002097          	auipc	ra,0x2
    4282:	928080e7          	jalr	-1752(ra) # 5ba6 <exit>
      printf("%s: chdir irefd failed\n", s);
    4286:	85da                	mv	a1,s6
    4288:	00004517          	auipc	a0,0x4
    428c:	97850513          	addi	a0,a0,-1672 # 7c00 <malloc+0x1c3a>
    4290:	00002097          	auipc	ra,0x2
    4294:	c7e080e7          	jalr	-898(ra) # 5f0e <printf>
      exit(1);
    4298:	4505                	li	a0,1
    429a:	00002097          	auipc	ra,0x2
    429e:	90c080e7          	jalr	-1780(ra) # 5ba6 <exit>
      close(fd);
    42a2:	00002097          	auipc	ra,0x2
    42a6:	92c080e7          	jalr	-1748(ra) # 5bce <close>
    42aa:	a889                	j	42fc <iref+0xce>
    unlink("xx");
    42ac:	854e                	mv	a0,s3
    42ae:	00002097          	auipc	ra,0x2
    42b2:	948080e7          	jalr	-1720(ra) # 5bf6 <unlink>
  for (i = 0; i < NINODE + 1; i++)
    42b6:	397d                	addiw	s2,s2,-1
    42b8:	06090063          	beqz	s2,4318 <iref+0xea>
    if (mkdir("irefd") != 0)
    42bc:	8552                	mv	a0,s4
    42be:	00002097          	auipc	ra,0x2
    42c2:	950080e7          	jalr	-1712(ra) # 5c0e <mkdir>
    42c6:	f155                	bnez	a0,426a <iref+0x3c>
    if (chdir("irefd") != 0)
    42c8:	8552                	mv	a0,s4
    42ca:	00002097          	auipc	ra,0x2
    42ce:	94c080e7          	jalr	-1716(ra) # 5c16 <chdir>
    42d2:	f955                	bnez	a0,4286 <iref+0x58>
    mkdir("");
    42d4:	8526                	mv	a0,s1
    42d6:	00002097          	auipc	ra,0x2
    42da:	938080e7          	jalr	-1736(ra) # 5c0e <mkdir>
    link("README", "");
    42de:	85a6                	mv	a1,s1
    42e0:	8556                	mv	a0,s5
    42e2:	00002097          	auipc	ra,0x2
    42e6:	924080e7          	jalr	-1756(ra) # 5c06 <link>
    fd = open("", O_CREATE);
    42ea:	20000593          	li	a1,512
    42ee:	8526                	mv	a0,s1
    42f0:	00002097          	auipc	ra,0x2
    42f4:	8f6080e7          	jalr	-1802(ra) # 5be6 <open>
    if (fd >= 0)
    42f8:	fa0555e3          	bgez	a0,42a2 <iref+0x74>
    fd = open("xx", O_CREATE);
    42fc:	20000593          	li	a1,512
    4300:	854e                	mv	a0,s3
    4302:	00002097          	auipc	ra,0x2
    4306:	8e4080e7          	jalr	-1820(ra) # 5be6 <open>
    if (fd >= 0)
    430a:	fa0541e3          	bltz	a0,42ac <iref+0x7e>
      close(fd);
    430e:	00002097          	auipc	ra,0x2
    4312:	8c0080e7          	jalr	-1856(ra) # 5bce <close>
    4316:	bf59                	j	42ac <iref+0x7e>
    4318:	03300493          	li	s1,51
    chdir("..");
    431c:	00003997          	auipc	s3,0x3
    4320:	0ec98993          	addi	s3,s3,236 # 7408 <malloc+0x1442>
    unlink("irefd");
    4324:	00004917          	auipc	s2,0x4
    4328:	8bc90913          	addi	s2,s2,-1860 # 7be0 <malloc+0x1c1a>
    chdir("..");
    432c:	854e                	mv	a0,s3
    432e:	00002097          	auipc	ra,0x2
    4332:	8e8080e7          	jalr	-1816(ra) # 5c16 <chdir>
    unlink("irefd");
    4336:	854a                	mv	a0,s2
    4338:	00002097          	auipc	ra,0x2
    433c:	8be080e7          	jalr	-1858(ra) # 5bf6 <unlink>
  for (i = 0; i < NINODE + 1; i++)
    4340:	34fd                	addiw	s1,s1,-1
    4342:	f4ed                	bnez	s1,432c <iref+0xfe>
  chdir("/");
    4344:	00003517          	auipc	a0,0x3
    4348:	06c50513          	addi	a0,a0,108 # 73b0 <malloc+0x13ea>
    434c:	00002097          	auipc	ra,0x2
    4350:	8ca080e7          	jalr	-1846(ra) # 5c16 <chdir>
}
    4354:	70e2                	ld	ra,56(sp)
    4356:	7442                	ld	s0,48(sp)
    4358:	74a2                	ld	s1,40(sp)
    435a:	7902                	ld	s2,32(sp)
    435c:	69e2                	ld	s3,24(sp)
    435e:	6a42                	ld	s4,16(sp)
    4360:	6aa2                	ld	s5,8(sp)
    4362:	6b02                	ld	s6,0(sp)
    4364:	6121                	addi	sp,sp,64
    4366:	8082                	ret

0000000000004368 <openiputtest>:
{
    4368:	7179                	addi	sp,sp,-48
    436a:	f406                	sd	ra,40(sp)
    436c:	f022                	sd	s0,32(sp)
    436e:	ec26                	sd	s1,24(sp)
    4370:	1800                	addi	s0,sp,48
    4372:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0)
    4374:	00004517          	auipc	a0,0x4
    4378:	8a450513          	addi	a0,a0,-1884 # 7c18 <malloc+0x1c52>
    437c:	00002097          	auipc	ra,0x2
    4380:	892080e7          	jalr	-1902(ra) # 5c0e <mkdir>
    4384:	04054263          	bltz	a0,43c8 <openiputtest+0x60>
  pid = fork();
    4388:	00002097          	auipc	ra,0x2
    438c:	816080e7          	jalr	-2026(ra) # 5b9e <fork>
  if (pid < 0)
    4390:	04054a63          	bltz	a0,43e4 <openiputtest+0x7c>
  if (pid == 0)
    4394:	e93d                	bnez	a0,440a <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4396:	4589                	li	a1,2
    4398:	00004517          	auipc	a0,0x4
    439c:	88050513          	addi	a0,a0,-1920 # 7c18 <malloc+0x1c52>
    43a0:	00002097          	auipc	ra,0x2
    43a4:	846080e7          	jalr	-1978(ra) # 5be6 <open>
    if (fd >= 0)
    43a8:	04054c63          	bltz	a0,4400 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43ac:	85a6                	mv	a1,s1
    43ae:	00004517          	auipc	a0,0x4
    43b2:	88a50513          	addi	a0,a0,-1910 # 7c38 <malloc+0x1c72>
    43b6:	00002097          	auipc	ra,0x2
    43ba:	b58080e7          	jalr	-1192(ra) # 5f0e <printf>
      exit(1);
    43be:	4505                	li	a0,1
    43c0:	00001097          	auipc	ra,0x1
    43c4:	7e6080e7          	jalr	2022(ra) # 5ba6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    43c8:	85a6                	mv	a1,s1
    43ca:	00004517          	auipc	a0,0x4
    43ce:	85650513          	addi	a0,a0,-1962 # 7c20 <malloc+0x1c5a>
    43d2:	00002097          	auipc	ra,0x2
    43d6:	b3c080e7          	jalr	-1220(ra) # 5f0e <printf>
    exit(1);
    43da:	4505                	li	a0,1
    43dc:	00001097          	auipc	ra,0x1
    43e0:	7ca080e7          	jalr	1994(ra) # 5ba6 <exit>
    printf("%s: fork failed\n", s);
    43e4:	85a6                	mv	a1,s1
    43e6:	00002517          	auipc	a0,0x2
    43ea:	59a50513          	addi	a0,a0,1434 # 6980 <malloc+0x9ba>
    43ee:	00002097          	auipc	ra,0x2
    43f2:	b20080e7          	jalr	-1248(ra) # 5f0e <printf>
    exit(1);
    43f6:	4505                	li	a0,1
    43f8:	00001097          	auipc	ra,0x1
    43fc:	7ae080e7          	jalr	1966(ra) # 5ba6 <exit>
    exit(0);
    4400:	4501                	li	a0,0
    4402:	00001097          	auipc	ra,0x1
    4406:	7a4080e7          	jalr	1956(ra) # 5ba6 <exit>
  sleep(1);
    440a:	4505                	li	a0,1
    440c:	00002097          	auipc	ra,0x2
    4410:	82a080e7          	jalr	-2006(ra) # 5c36 <sleep>
  if (unlink("oidir") != 0)
    4414:	00004517          	auipc	a0,0x4
    4418:	80450513          	addi	a0,a0,-2044 # 7c18 <malloc+0x1c52>
    441c:	00001097          	auipc	ra,0x1
    4420:	7da080e7          	jalr	2010(ra) # 5bf6 <unlink>
    4424:	cd19                	beqz	a0,4442 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4426:	85a6                	mv	a1,s1
    4428:	00002517          	auipc	a0,0x2
    442c:	74850513          	addi	a0,a0,1864 # 6b70 <malloc+0xbaa>
    4430:	00002097          	auipc	ra,0x2
    4434:	ade080e7          	jalr	-1314(ra) # 5f0e <printf>
    exit(1);
    4438:	4505                	li	a0,1
    443a:	00001097          	auipc	ra,0x1
    443e:	76c080e7          	jalr	1900(ra) # 5ba6 <exit>
  wait(&xstatus);
    4442:	fdc40513          	addi	a0,s0,-36
    4446:	00001097          	auipc	ra,0x1
    444a:	768080e7          	jalr	1896(ra) # 5bae <wait>
  exit(xstatus);
    444e:	fdc42503          	lw	a0,-36(s0)
    4452:	00001097          	auipc	ra,0x1
    4456:	754080e7          	jalr	1876(ra) # 5ba6 <exit>

000000000000445a <forkforkfork>:
{
    445a:	1101                	addi	sp,sp,-32
    445c:	ec06                	sd	ra,24(sp)
    445e:	e822                	sd	s0,16(sp)
    4460:	e426                	sd	s1,8(sp)
    4462:	1000                	addi	s0,sp,32
    4464:	84aa                	mv	s1,a0
  unlink("stopforking");
    4466:	00003517          	auipc	a0,0x3
    446a:	7fa50513          	addi	a0,a0,2042 # 7c60 <malloc+0x1c9a>
    446e:	00001097          	auipc	ra,0x1
    4472:	788080e7          	jalr	1928(ra) # 5bf6 <unlink>
  int pid = fork();
    4476:	00001097          	auipc	ra,0x1
    447a:	728080e7          	jalr	1832(ra) # 5b9e <fork>
  if (pid < 0)
    447e:	04054563          	bltz	a0,44c8 <forkforkfork+0x6e>
  if (pid == 0)
    4482:	c12d                	beqz	a0,44e4 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4484:	4551                	li	a0,20
    4486:	00001097          	auipc	ra,0x1
    448a:	7b0080e7          	jalr	1968(ra) # 5c36 <sleep>
  close(open("stopforking", O_CREATE | O_RDWR));
    448e:	20200593          	li	a1,514
    4492:	00003517          	auipc	a0,0x3
    4496:	7ce50513          	addi	a0,a0,1998 # 7c60 <malloc+0x1c9a>
    449a:	00001097          	auipc	ra,0x1
    449e:	74c080e7          	jalr	1868(ra) # 5be6 <open>
    44a2:	00001097          	auipc	ra,0x1
    44a6:	72c080e7          	jalr	1836(ra) # 5bce <close>
  wait(0);
    44aa:	4501                	li	a0,0
    44ac:	00001097          	auipc	ra,0x1
    44b0:	702080e7          	jalr	1794(ra) # 5bae <wait>
  sleep(10); // one second
    44b4:	4529                	li	a0,10
    44b6:	00001097          	auipc	ra,0x1
    44ba:	780080e7          	jalr	1920(ra) # 5c36 <sleep>
}
    44be:	60e2                	ld	ra,24(sp)
    44c0:	6442                	ld	s0,16(sp)
    44c2:	64a2                	ld	s1,8(sp)
    44c4:	6105                	addi	sp,sp,32
    44c6:	8082                	ret
    printf("%s: fork failed", s);
    44c8:	85a6                	mv	a1,s1
    44ca:	00002517          	auipc	a0,0x2
    44ce:	67650513          	addi	a0,a0,1654 # 6b40 <malloc+0xb7a>
    44d2:	00002097          	auipc	ra,0x2
    44d6:	a3c080e7          	jalr	-1476(ra) # 5f0e <printf>
    exit(1);
    44da:	4505                	li	a0,1
    44dc:	00001097          	auipc	ra,0x1
    44e0:	6ca080e7          	jalr	1738(ra) # 5ba6 <exit>
      int fd = open("stopforking", 0);
    44e4:	00003497          	auipc	s1,0x3
    44e8:	77c48493          	addi	s1,s1,1916 # 7c60 <malloc+0x1c9a>
    44ec:	4581                	li	a1,0
    44ee:	8526                	mv	a0,s1
    44f0:	00001097          	auipc	ra,0x1
    44f4:	6f6080e7          	jalr	1782(ra) # 5be6 <open>
      if (fd >= 0)
    44f8:	02055763          	bgez	a0,4526 <forkforkfork+0xcc>
      if (fork() < 0)
    44fc:	00001097          	auipc	ra,0x1
    4500:	6a2080e7          	jalr	1698(ra) # 5b9e <fork>
    4504:	fe0554e3          	bgez	a0,44ec <forkforkfork+0x92>
        close(open("stopforking", O_CREATE | O_RDWR));
    4508:	20200593          	li	a1,514
    450c:	00003517          	auipc	a0,0x3
    4510:	75450513          	addi	a0,a0,1876 # 7c60 <malloc+0x1c9a>
    4514:	00001097          	auipc	ra,0x1
    4518:	6d2080e7          	jalr	1746(ra) # 5be6 <open>
    451c:	00001097          	auipc	ra,0x1
    4520:	6b2080e7          	jalr	1714(ra) # 5bce <close>
    4524:	b7e1                	j	44ec <forkforkfork+0x92>
        exit(0);
    4526:	4501                	li	a0,0
    4528:	00001097          	auipc	ra,0x1
    452c:	67e080e7          	jalr	1662(ra) # 5ba6 <exit>

0000000000004530 <killstatus>:
{
    4530:	7139                	addi	sp,sp,-64
    4532:	fc06                	sd	ra,56(sp)
    4534:	f822                	sd	s0,48(sp)
    4536:	f426                	sd	s1,40(sp)
    4538:	f04a                	sd	s2,32(sp)
    453a:	ec4e                	sd	s3,24(sp)
    453c:	e852                	sd	s4,16(sp)
    453e:	0080                	addi	s0,sp,64
    4540:	8a2a                	mv	s4,a0
    4542:	06400913          	li	s2,100
    if (xst != -1)
    4546:	59fd                	li	s3,-1
    int pid1 = fork();
    4548:	00001097          	auipc	ra,0x1
    454c:	656080e7          	jalr	1622(ra) # 5b9e <fork>
    4550:	84aa                	mv	s1,a0
    if (pid1 < 0)
    4552:	02054f63          	bltz	a0,4590 <killstatus+0x60>
    if (pid1 == 0)
    4556:	c939                	beqz	a0,45ac <killstatus+0x7c>
    sleep(1);
    4558:	4505                	li	a0,1
    455a:	00001097          	auipc	ra,0x1
    455e:	6dc080e7          	jalr	1756(ra) # 5c36 <sleep>
    kill(pid1);
    4562:	8526                	mv	a0,s1
    4564:	00001097          	auipc	ra,0x1
    4568:	672080e7          	jalr	1650(ra) # 5bd6 <kill>
    wait(&xst);
    456c:	fcc40513          	addi	a0,s0,-52
    4570:	00001097          	auipc	ra,0x1
    4574:	63e080e7          	jalr	1598(ra) # 5bae <wait>
    if (xst != -1)
    4578:	fcc42783          	lw	a5,-52(s0)
    457c:	03379d63          	bne	a5,s3,45b6 <killstatus+0x86>
  for (int i = 0; i < 100; i++)
    4580:	397d                	addiw	s2,s2,-1
    4582:	fc0913e3          	bnez	s2,4548 <killstatus+0x18>
  exit(0);
    4586:	4501                	li	a0,0
    4588:	00001097          	auipc	ra,0x1
    458c:	61e080e7          	jalr	1566(ra) # 5ba6 <exit>
      printf("%s: fork failed\n", s);
    4590:	85d2                	mv	a1,s4
    4592:	00002517          	auipc	a0,0x2
    4596:	3ee50513          	addi	a0,a0,1006 # 6980 <malloc+0x9ba>
    459a:	00002097          	auipc	ra,0x2
    459e:	974080e7          	jalr	-1676(ra) # 5f0e <printf>
      exit(1);
    45a2:	4505                	li	a0,1
    45a4:	00001097          	auipc	ra,0x1
    45a8:	602080e7          	jalr	1538(ra) # 5ba6 <exit>
        getpid();
    45ac:	00001097          	auipc	ra,0x1
    45b0:	67a080e7          	jalr	1658(ra) # 5c26 <getpid>
      while (1)
    45b4:	bfe5                	j	45ac <killstatus+0x7c>
      printf("%s: status should be -1\n", s);
    45b6:	85d2                	mv	a1,s4
    45b8:	00003517          	auipc	a0,0x3
    45bc:	6b850513          	addi	a0,a0,1720 # 7c70 <malloc+0x1caa>
    45c0:	00002097          	auipc	ra,0x2
    45c4:	94e080e7          	jalr	-1714(ra) # 5f0e <printf>
      exit(1);
    45c8:	4505                	li	a0,1
    45ca:	00001097          	auipc	ra,0x1
    45ce:	5dc080e7          	jalr	1500(ra) # 5ba6 <exit>

00000000000045d2 <preempt>:
{
    45d2:	7139                	addi	sp,sp,-64
    45d4:	fc06                	sd	ra,56(sp)
    45d6:	f822                	sd	s0,48(sp)
    45d8:	f426                	sd	s1,40(sp)
    45da:	f04a                	sd	s2,32(sp)
    45dc:	ec4e                	sd	s3,24(sp)
    45de:	e852                	sd	s4,16(sp)
    45e0:	0080                	addi	s0,sp,64
    45e2:	892a                	mv	s2,a0
  pid1 = fork();
    45e4:	00001097          	auipc	ra,0x1
    45e8:	5ba080e7          	jalr	1466(ra) # 5b9e <fork>
  if (pid1 < 0)
    45ec:	00054563          	bltz	a0,45f6 <preempt+0x24>
    45f0:	84aa                	mv	s1,a0
  if (pid1 == 0)
    45f2:	e105                	bnez	a0,4612 <preempt+0x40>
    for (;;)
    45f4:	a001                	j	45f4 <preempt+0x22>
    printf("%s: fork failed", s);
    45f6:	85ca                	mv	a1,s2
    45f8:	00002517          	auipc	a0,0x2
    45fc:	54850513          	addi	a0,a0,1352 # 6b40 <malloc+0xb7a>
    4600:	00002097          	auipc	ra,0x2
    4604:	90e080e7          	jalr	-1778(ra) # 5f0e <printf>
    exit(1);
    4608:	4505                	li	a0,1
    460a:	00001097          	auipc	ra,0x1
    460e:	59c080e7          	jalr	1436(ra) # 5ba6 <exit>
  pid2 = fork();
    4612:	00001097          	auipc	ra,0x1
    4616:	58c080e7          	jalr	1420(ra) # 5b9e <fork>
    461a:	89aa                	mv	s3,a0
  if (pid2 < 0)
    461c:	00054463          	bltz	a0,4624 <preempt+0x52>
  if (pid2 == 0)
    4620:	e105                	bnez	a0,4640 <preempt+0x6e>
    for (;;)
    4622:	a001                	j	4622 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4624:	85ca                	mv	a1,s2
    4626:	00002517          	auipc	a0,0x2
    462a:	35a50513          	addi	a0,a0,858 # 6980 <malloc+0x9ba>
    462e:	00002097          	auipc	ra,0x2
    4632:	8e0080e7          	jalr	-1824(ra) # 5f0e <printf>
    exit(1);
    4636:	4505                	li	a0,1
    4638:	00001097          	auipc	ra,0x1
    463c:	56e080e7          	jalr	1390(ra) # 5ba6 <exit>
  pipe(pfds);
    4640:	fc840513          	addi	a0,s0,-56
    4644:	00001097          	auipc	ra,0x1
    4648:	572080e7          	jalr	1394(ra) # 5bb6 <pipe>
  pid3 = fork();
    464c:	00001097          	auipc	ra,0x1
    4650:	552080e7          	jalr	1362(ra) # 5b9e <fork>
    4654:	8a2a                	mv	s4,a0
  if (pid3 < 0)
    4656:	02054e63          	bltz	a0,4692 <preempt+0xc0>
  if (pid3 == 0)
    465a:	e525                	bnez	a0,46c2 <preempt+0xf0>
    close(pfds[0]);
    465c:	fc842503          	lw	a0,-56(s0)
    4660:	00001097          	auipc	ra,0x1
    4664:	56e080e7          	jalr	1390(ra) # 5bce <close>
    if (write(pfds[1], "x", 1) != 1)
    4668:	4605                	li	a2,1
    466a:	00002597          	auipc	a1,0x2
    466e:	aee58593          	addi	a1,a1,-1298 # 6158 <malloc+0x192>
    4672:	fcc42503          	lw	a0,-52(s0)
    4676:	00001097          	auipc	ra,0x1
    467a:	550080e7          	jalr	1360(ra) # 5bc6 <write>
    467e:	4785                	li	a5,1
    4680:	02f51763          	bne	a0,a5,46ae <preempt+0xdc>
    close(pfds[1]);
    4684:	fcc42503          	lw	a0,-52(s0)
    4688:	00001097          	auipc	ra,0x1
    468c:	546080e7          	jalr	1350(ra) # 5bce <close>
    for (;;)
    4690:	a001                	j	4690 <preempt+0xbe>
    printf("%s: fork failed\n", s);
    4692:	85ca                	mv	a1,s2
    4694:	00002517          	auipc	a0,0x2
    4698:	2ec50513          	addi	a0,a0,748 # 6980 <malloc+0x9ba>
    469c:	00002097          	auipc	ra,0x2
    46a0:	872080e7          	jalr	-1934(ra) # 5f0e <printf>
    exit(1);
    46a4:	4505                	li	a0,1
    46a6:	00001097          	auipc	ra,0x1
    46aa:	500080e7          	jalr	1280(ra) # 5ba6 <exit>
      printf("%s: preempt write error", s);
    46ae:	85ca                	mv	a1,s2
    46b0:	00003517          	auipc	a0,0x3
    46b4:	5e050513          	addi	a0,a0,1504 # 7c90 <malloc+0x1cca>
    46b8:	00002097          	auipc	ra,0x2
    46bc:	856080e7          	jalr	-1962(ra) # 5f0e <printf>
    46c0:	b7d1                	j	4684 <preempt+0xb2>
  close(pfds[1]);
    46c2:	fcc42503          	lw	a0,-52(s0)
    46c6:	00001097          	auipc	ra,0x1
    46ca:	508080e7          	jalr	1288(ra) # 5bce <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1)
    46ce:	660d                	lui	a2,0x3
    46d0:	00008597          	auipc	a1,0x8
    46d4:	5a858593          	addi	a1,a1,1448 # cc78 <buf>
    46d8:	fc842503          	lw	a0,-56(s0)
    46dc:	00001097          	auipc	ra,0x1
    46e0:	4e2080e7          	jalr	1250(ra) # 5bbe <read>
    46e4:	4785                	li	a5,1
    46e6:	02f50363          	beq	a0,a5,470c <preempt+0x13a>
    printf("%s: preempt read error", s);
    46ea:	85ca                	mv	a1,s2
    46ec:	00003517          	auipc	a0,0x3
    46f0:	5bc50513          	addi	a0,a0,1468 # 7ca8 <malloc+0x1ce2>
    46f4:	00002097          	auipc	ra,0x2
    46f8:	81a080e7          	jalr	-2022(ra) # 5f0e <printf>
}
    46fc:	70e2                	ld	ra,56(sp)
    46fe:	7442                	ld	s0,48(sp)
    4700:	74a2                	ld	s1,40(sp)
    4702:	7902                	ld	s2,32(sp)
    4704:	69e2                	ld	s3,24(sp)
    4706:	6a42                	ld	s4,16(sp)
    4708:	6121                	addi	sp,sp,64
    470a:	8082                	ret
  close(pfds[0]);
    470c:	fc842503          	lw	a0,-56(s0)
    4710:	00001097          	auipc	ra,0x1
    4714:	4be080e7          	jalr	1214(ra) # 5bce <close>
  printf("kill... ");
    4718:	00003517          	auipc	a0,0x3
    471c:	5a850513          	addi	a0,a0,1448 # 7cc0 <malloc+0x1cfa>
    4720:	00001097          	auipc	ra,0x1
    4724:	7ee080e7          	jalr	2030(ra) # 5f0e <printf>
  kill(pid1);
    4728:	8526                	mv	a0,s1
    472a:	00001097          	auipc	ra,0x1
    472e:	4ac080e7          	jalr	1196(ra) # 5bd6 <kill>
  kill(pid2);
    4732:	854e                	mv	a0,s3
    4734:	00001097          	auipc	ra,0x1
    4738:	4a2080e7          	jalr	1186(ra) # 5bd6 <kill>
  kill(pid3);
    473c:	8552                	mv	a0,s4
    473e:	00001097          	auipc	ra,0x1
    4742:	498080e7          	jalr	1176(ra) # 5bd6 <kill>
  printf("wait... ");
    4746:	00003517          	auipc	a0,0x3
    474a:	58a50513          	addi	a0,a0,1418 # 7cd0 <malloc+0x1d0a>
    474e:	00001097          	auipc	ra,0x1
    4752:	7c0080e7          	jalr	1984(ra) # 5f0e <printf>
  wait(0);
    4756:	4501                	li	a0,0
    4758:	00001097          	auipc	ra,0x1
    475c:	456080e7          	jalr	1110(ra) # 5bae <wait>
  wait(0);
    4760:	4501                	li	a0,0
    4762:	00001097          	auipc	ra,0x1
    4766:	44c080e7          	jalr	1100(ra) # 5bae <wait>
  wait(0);
    476a:	4501                	li	a0,0
    476c:	00001097          	auipc	ra,0x1
    4770:	442080e7          	jalr	1090(ra) # 5bae <wait>
    4774:	b761                	j	46fc <preempt+0x12a>

0000000000004776 <reparent>:
{
    4776:	7179                	addi	sp,sp,-48
    4778:	f406                	sd	ra,40(sp)
    477a:	f022                	sd	s0,32(sp)
    477c:	ec26                	sd	s1,24(sp)
    477e:	e84a                	sd	s2,16(sp)
    4780:	e44e                	sd	s3,8(sp)
    4782:	e052                	sd	s4,0(sp)
    4784:	1800                	addi	s0,sp,48
    4786:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4788:	00001097          	auipc	ra,0x1
    478c:	49e080e7          	jalr	1182(ra) # 5c26 <getpid>
    4790:	8a2a                	mv	s4,a0
    4792:	0c800913          	li	s2,200
    int pid = fork();
    4796:	00001097          	auipc	ra,0x1
    479a:	408080e7          	jalr	1032(ra) # 5b9e <fork>
    479e:	84aa                	mv	s1,a0
    if (pid < 0)
    47a0:	02054263          	bltz	a0,47c4 <reparent+0x4e>
    if (pid)
    47a4:	cd21                	beqz	a0,47fc <reparent+0x86>
      if (wait(0) != pid)
    47a6:	4501                	li	a0,0
    47a8:	00001097          	auipc	ra,0x1
    47ac:	406080e7          	jalr	1030(ra) # 5bae <wait>
    47b0:	02951863          	bne	a0,s1,47e0 <reparent+0x6a>
  for (int i = 0; i < 200; i++)
    47b4:	397d                	addiw	s2,s2,-1
    47b6:	fe0910e3          	bnez	s2,4796 <reparent+0x20>
  exit(0);
    47ba:	4501                	li	a0,0
    47bc:	00001097          	auipc	ra,0x1
    47c0:	3ea080e7          	jalr	1002(ra) # 5ba6 <exit>
      printf("%s: fork failed\n", s);
    47c4:	85ce                	mv	a1,s3
    47c6:	00002517          	auipc	a0,0x2
    47ca:	1ba50513          	addi	a0,a0,442 # 6980 <malloc+0x9ba>
    47ce:	00001097          	auipc	ra,0x1
    47d2:	740080e7          	jalr	1856(ra) # 5f0e <printf>
      exit(1);
    47d6:	4505                	li	a0,1
    47d8:	00001097          	auipc	ra,0x1
    47dc:	3ce080e7          	jalr	974(ra) # 5ba6 <exit>
        printf("%s: wait wrong pid\n", s);
    47e0:	85ce                	mv	a1,s3
    47e2:	00002517          	auipc	a0,0x2
    47e6:	32650513          	addi	a0,a0,806 # 6b08 <malloc+0xb42>
    47ea:	00001097          	auipc	ra,0x1
    47ee:	724080e7          	jalr	1828(ra) # 5f0e <printf>
        exit(1);
    47f2:	4505                	li	a0,1
    47f4:	00001097          	auipc	ra,0x1
    47f8:	3b2080e7          	jalr	946(ra) # 5ba6 <exit>
      int pid2 = fork();
    47fc:	00001097          	auipc	ra,0x1
    4800:	3a2080e7          	jalr	930(ra) # 5b9e <fork>
      if (pid2 < 0)
    4804:	00054763          	bltz	a0,4812 <reparent+0x9c>
      exit(0);
    4808:	4501                	li	a0,0
    480a:	00001097          	auipc	ra,0x1
    480e:	39c080e7          	jalr	924(ra) # 5ba6 <exit>
        kill(master_pid);
    4812:	8552                	mv	a0,s4
    4814:	00001097          	auipc	ra,0x1
    4818:	3c2080e7          	jalr	962(ra) # 5bd6 <kill>
        exit(1);
    481c:	4505                	li	a0,1
    481e:	00001097          	auipc	ra,0x1
    4822:	388080e7          	jalr	904(ra) # 5ba6 <exit>

0000000000004826 <sbrkfail>:
{
    4826:	7119                	addi	sp,sp,-128
    4828:	fc86                	sd	ra,120(sp)
    482a:	f8a2                	sd	s0,112(sp)
    482c:	f4a6                	sd	s1,104(sp)
    482e:	f0ca                	sd	s2,96(sp)
    4830:	ecce                	sd	s3,88(sp)
    4832:	e8d2                	sd	s4,80(sp)
    4834:	e4d6                	sd	s5,72(sp)
    4836:	0100                	addi	s0,sp,128
    4838:	8aaa                	mv	s5,a0
  if (pipe(fds) != 0)
    483a:	fb040513          	addi	a0,s0,-80
    483e:	00001097          	auipc	ra,0x1
    4842:	378080e7          	jalr	888(ra) # 5bb6 <pipe>
    4846:	e901                	bnez	a0,4856 <sbrkfail+0x30>
    4848:	f8040493          	addi	s1,s0,-128
    484c:	fa840993          	addi	s3,s0,-88
    4850:	8926                	mv	s2,s1
    if (pids[i] != -1)
    4852:	5a7d                	li	s4,-1
    4854:	a085                	j	48b4 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4856:	85d6                	mv	a1,s5
    4858:	00002517          	auipc	a0,0x2
    485c:	23050513          	addi	a0,a0,560 # 6a88 <malloc+0xac2>
    4860:	00001097          	auipc	ra,0x1
    4864:	6ae080e7          	jalr	1710(ra) # 5f0e <printf>
    exit(1);
    4868:	4505                	li	a0,1
    486a:	00001097          	auipc	ra,0x1
    486e:	33c080e7          	jalr	828(ra) # 5ba6 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4872:	00001097          	auipc	ra,0x1
    4876:	3bc080e7          	jalr	956(ra) # 5c2e <sbrk>
    487a:	064007b7          	lui	a5,0x6400
    487e:	40a7853b          	subw	a0,a5,a0
    4882:	00001097          	auipc	ra,0x1
    4886:	3ac080e7          	jalr	940(ra) # 5c2e <sbrk>
      write(fds[1], "x", 1);
    488a:	4605                	li	a2,1
    488c:	00002597          	auipc	a1,0x2
    4890:	8cc58593          	addi	a1,a1,-1844 # 6158 <malloc+0x192>
    4894:	fb442503          	lw	a0,-76(s0)
    4898:	00001097          	auipc	ra,0x1
    489c:	32e080e7          	jalr	814(ra) # 5bc6 <write>
        sleep(1000);
    48a0:	3e800513          	li	a0,1000
    48a4:	00001097          	auipc	ra,0x1
    48a8:	392080e7          	jalr	914(ra) # 5c36 <sleep>
      for (;;)
    48ac:	bfd5                	j	48a0 <sbrkfail+0x7a>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++)
    48ae:	0911                	addi	s2,s2,4
    48b0:	03390563          	beq	s2,s3,48da <sbrkfail+0xb4>
    if ((pids[i] = fork()) == 0)
    48b4:	00001097          	auipc	ra,0x1
    48b8:	2ea080e7          	jalr	746(ra) # 5b9e <fork>
    48bc:	00a92023          	sw	a0,0(s2)
    48c0:	d94d                	beqz	a0,4872 <sbrkfail+0x4c>
    if (pids[i] != -1)
    48c2:	ff4506e3          	beq	a0,s4,48ae <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    48c6:	4605                	li	a2,1
    48c8:	faf40593          	addi	a1,s0,-81
    48cc:	fb042503          	lw	a0,-80(s0)
    48d0:	00001097          	auipc	ra,0x1
    48d4:	2ee080e7          	jalr	750(ra) # 5bbe <read>
    48d8:	bfd9                	j	48ae <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48da:	6505                	lui	a0,0x1
    48dc:	00001097          	auipc	ra,0x1
    48e0:	352080e7          	jalr	850(ra) # 5c2e <sbrk>
    48e4:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    48e6:	597d                	li	s2,-1
    48e8:	a021                	j	48f0 <sbrkfail+0xca>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++)
    48ea:	0491                	addi	s1,s1,4
    48ec:	01348f63          	beq	s1,s3,490a <sbrkfail+0xe4>
    if (pids[i] == -1)
    48f0:	4088                	lw	a0,0(s1)
    48f2:	ff250ce3          	beq	a0,s2,48ea <sbrkfail+0xc4>
    kill(pids[i]);
    48f6:	00001097          	auipc	ra,0x1
    48fa:	2e0080e7          	jalr	736(ra) # 5bd6 <kill>
    wait(0);
    48fe:	4501                	li	a0,0
    4900:	00001097          	auipc	ra,0x1
    4904:	2ae080e7          	jalr	686(ra) # 5bae <wait>
    4908:	b7cd                	j	48ea <sbrkfail+0xc4>
  if (c == (char *)0xffffffffffffffffL)
    490a:	57fd                	li	a5,-1
    490c:	04fa0163          	beq	s4,a5,494e <sbrkfail+0x128>
  pid = fork();
    4910:	00001097          	auipc	ra,0x1
    4914:	28e080e7          	jalr	654(ra) # 5b9e <fork>
    4918:	84aa                	mv	s1,a0
  if (pid < 0)
    491a:	04054863          	bltz	a0,496a <sbrkfail+0x144>
  if (pid == 0)
    491e:	c525                	beqz	a0,4986 <sbrkfail+0x160>
  wait(&xstatus);
    4920:	fbc40513          	addi	a0,s0,-68
    4924:	00001097          	auipc	ra,0x1
    4928:	28a080e7          	jalr	650(ra) # 5bae <wait>
  if (xstatus != -1 && xstatus != 2)
    492c:	fbc42783          	lw	a5,-68(s0)
    4930:	577d                	li	a4,-1
    4932:	00e78563          	beq	a5,a4,493c <sbrkfail+0x116>
    4936:	4709                	li	a4,2
    4938:	08e79d63          	bne	a5,a4,49d2 <sbrkfail+0x1ac>
}
    493c:	70e6                	ld	ra,120(sp)
    493e:	7446                	ld	s0,112(sp)
    4940:	74a6                	ld	s1,104(sp)
    4942:	7906                	ld	s2,96(sp)
    4944:	69e6                	ld	s3,88(sp)
    4946:	6a46                	ld	s4,80(sp)
    4948:	6aa6                	ld	s5,72(sp)
    494a:	6109                	addi	sp,sp,128
    494c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    494e:	85d6                	mv	a1,s5
    4950:	00003517          	auipc	a0,0x3
    4954:	39050513          	addi	a0,a0,912 # 7ce0 <malloc+0x1d1a>
    4958:	00001097          	auipc	ra,0x1
    495c:	5b6080e7          	jalr	1462(ra) # 5f0e <printf>
    exit(1);
    4960:	4505                	li	a0,1
    4962:	00001097          	auipc	ra,0x1
    4966:	244080e7          	jalr	580(ra) # 5ba6 <exit>
    printf("%s: fork failed\n", s);
    496a:	85d6                	mv	a1,s5
    496c:	00002517          	auipc	a0,0x2
    4970:	01450513          	addi	a0,a0,20 # 6980 <malloc+0x9ba>
    4974:	00001097          	auipc	ra,0x1
    4978:	59a080e7          	jalr	1434(ra) # 5f0e <printf>
    exit(1);
    497c:	4505                	li	a0,1
    497e:	00001097          	auipc	ra,0x1
    4982:	228080e7          	jalr	552(ra) # 5ba6 <exit>
    a = sbrk(0);
    4986:	4501                	li	a0,0
    4988:	00001097          	auipc	ra,0x1
    498c:	2a6080e7          	jalr	678(ra) # 5c2e <sbrk>
    4990:	892a                	mv	s2,a0
    sbrk(10 * BIG);
    4992:	3e800537          	lui	a0,0x3e800
    4996:	00001097          	auipc	ra,0x1
    499a:	298080e7          	jalr	664(ra) # 5c2e <sbrk>
    for (i = 0; i < 10 * BIG; i += PGSIZE)
    499e:	87ca                	mv	a5,s2
    49a0:	3e800737          	lui	a4,0x3e800
    49a4:	993a                	add	s2,s2,a4
    49a6:	6705                	lui	a4,0x1
      n += *(a + i);
    49a8:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    49ac:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10 * BIG; i += PGSIZE)
    49ae:	97ba                	add	a5,a5,a4
    49b0:	ff279ce3          	bne	a5,s2,49a8 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49b4:	8626                	mv	a2,s1
    49b6:	85d6                	mv	a1,s5
    49b8:	00003517          	auipc	a0,0x3
    49bc:	34850513          	addi	a0,a0,840 # 7d00 <malloc+0x1d3a>
    49c0:	00001097          	auipc	ra,0x1
    49c4:	54e080e7          	jalr	1358(ra) # 5f0e <printf>
    exit(1);
    49c8:	4505                	li	a0,1
    49ca:	00001097          	auipc	ra,0x1
    49ce:	1dc080e7          	jalr	476(ra) # 5ba6 <exit>
    exit(1);
    49d2:	4505                	li	a0,1
    49d4:	00001097          	auipc	ra,0x1
    49d8:	1d2080e7          	jalr	466(ra) # 5ba6 <exit>

00000000000049dc <mem>:
{
    49dc:	7139                	addi	sp,sp,-64
    49de:	fc06                	sd	ra,56(sp)
    49e0:	f822                	sd	s0,48(sp)
    49e2:	f426                	sd	s1,40(sp)
    49e4:	f04a                	sd	s2,32(sp)
    49e6:	ec4e                	sd	s3,24(sp)
    49e8:	0080                	addi	s0,sp,64
    49ea:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0)
    49ec:	00001097          	auipc	ra,0x1
    49f0:	1b2080e7          	jalr	434(ra) # 5b9e <fork>
    m1 = 0;
    49f4:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0)
    49f6:	6909                	lui	s2,0x2
    49f8:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0xef>
  if ((pid = fork()) == 0)
    49fc:	c115                	beqz	a0,4a20 <mem+0x44>
    wait(&xstatus);
    49fe:	fcc40513          	addi	a0,s0,-52
    4a02:	00001097          	auipc	ra,0x1
    4a06:	1ac080e7          	jalr	428(ra) # 5bae <wait>
    if (xstatus == -1)
    4a0a:	fcc42503          	lw	a0,-52(s0)
    4a0e:	57fd                	li	a5,-1
    4a10:	06f50363          	beq	a0,a5,4a76 <mem+0x9a>
    exit(xstatus);
    4a14:	00001097          	auipc	ra,0x1
    4a18:	192080e7          	jalr	402(ra) # 5ba6 <exit>
      *(char **)m2 = m1;
    4a1c:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a1e:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0)
    4a20:	854a                	mv	a0,s2
    4a22:	00001097          	auipc	ra,0x1
    4a26:	5a4080e7          	jalr	1444(ra) # 5fc6 <malloc>
    4a2a:	f96d                	bnez	a0,4a1c <mem+0x40>
    while (m1)
    4a2c:	c881                	beqz	s1,4a3c <mem+0x60>
      m2 = *(char **)m1;
    4a2e:	8526                	mv	a0,s1
    4a30:	6084                	ld	s1,0(s1)
      free(m1);
    4a32:	00001097          	auipc	ra,0x1
    4a36:	512080e7          	jalr	1298(ra) # 5f44 <free>
    while (m1)
    4a3a:	f8f5                	bnez	s1,4a2e <mem+0x52>
    m1 = malloc(1024 * 20);
    4a3c:	6515                	lui	a0,0x5
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	588080e7          	jalr	1416(ra) # 5fc6 <malloc>
    if (m1 == 0)
    4a46:	c911                	beqz	a0,4a5a <mem+0x7e>
    free(m1);
    4a48:	00001097          	auipc	ra,0x1
    4a4c:	4fc080e7          	jalr	1276(ra) # 5f44 <free>
    exit(0);
    4a50:	4501                	li	a0,0
    4a52:	00001097          	auipc	ra,0x1
    4a56:	154080e7          	jalr	340(ra) # 5ba6 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a5a:	85ce                	mv	a1,s3
    4a5c:	00003517          	auipc	a0,0x3
    4a60:	2d450513          	addi	a0,a0,724 # 7d30 <malloc+0x1d6a>
    4a64:	00001097          	auipc	ra,0x1
    4a68:	4aa080e7          	jalr	1194(ra) # 5f0e <printf>
      exit(1);
    4a6c:	4505                	li	a0,1
    4a6e:	00001097          	auipc	ra,0x1
    4a72:	138080e7          	jalr	312(ra) # 5ba6 <exit>
      exit(0);
    4a76:	4501                	li	a0,0
    4a78:	00001097          	auipc	ra,0x1
    4a7c:	12e080e7          	jalr	302(ra) # 5ba6 <exit>

0000000000004a80 <sharedfd>:
{
    4a80:	7159                	addi	sp,sp,-112
    4a82:	f486                	sd	ra,104(sp)
    4a84:	f0a2                	sd	s0,96(sp)
    4a86:	eca6                	sd	s1,88(sp)
    4a88:	e8ca                	sd	s2,80(sp)
    4a8a:	e4ce                	sd	s3,72(sp)
    4a8c:	e0d2                	sd	s4,64(sp)
    4a8e:	fc56                	sd	s5,56(sp)
    4a90:	f85a                	sd	s6,48(sp)
    4a92:	f45e                	sd	s7,40(sp)
    4a94:	1880                	addi	s0,sp,112
    4a96:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a98:	00003517          	auipc	a0,0x3
    4a9c:	2b850513          	addi	a0,a0,696 # 7d50 <malloc+0x1d8a>
    4aa0:	00001097          	auipc	ra,0x1
    4aa4:	156080e7          	jalr	342(ra) # 5bf6 <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    4aa8:	20200593          	li	a1,514
    4aac:	00003517          	auipc	a0,0x3
    4ab0:	2a450513          	addi	a0,a0,676 # 7d50 <malloc+0x1d8a>
    4ab4:	00001097          	auipc	ra,0x1
    4ab8:	132080e7          	jalr	306(ra) # 5be6 <open>
  if (fd < 0)
    4abc:	04054a63          	bltz	a0,4b10 <sharedfd+0x90>
    4ac0:	892a                	mv	s2,a0
  pid = fork();
    4ac2:	00001097          	auipc	ra,0x1
    4ac6:	0dc080e7          	jalr	220(ra) # 5b9e <fork>
    4aca:	89aa                	mv	s3,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    4acc:	07000593          	li	a1,112
    4ad0:	e119                	bnez	a0,4ad6 <sharedfd+0x56>
    4ad2:	06300593          	li	a1,99
    4ad6:	4629                	li	a2,10
    4ad8:	fa040513          	addi	a0,s0,-96
    4adc:	00001097          	auipc	ra,0x1
    4ae0:	ed0080e7          	jalr	-304(ra) # 59ac <memset>
    4ae4:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf))
    4ae8:	4629                	li	a2,10
    4aea:	fa040593          	addi	a1,s0,-96
    4aee:	854a                	mv	a0,s2
    4af0:	00001097          	auipc	ra,0x1
    4af4:	0d6080e7          	jalr	214(ra) # 5bc6 <write>
    4af8:	47a9                	li	a5,10
    4afa:	02f51963          	bne	a0,a5,4b2c <sharedfd+0xac>
  for (i = 0; i < N; i++)
    4afe:	34fd                	addiw	s1,s1,-1
    4b00:	f4e5                	bnez	s1,4ae8 <sharedfd+0x68>
  if (pid == 0)
    4b02:	04099363          	bnez	s3,4b48 <sharedfd+0xc8>
    exit(0);
    4b06:	4501                	li	a0,0
    4b08:	00001097          	auipc	ra,0x1
    4b0c:	09e080e7          	jalr	158(ra) # 5ba6 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4b10:	85d2                	mv	a1,s4
    4b12:	00003517          	auipc	a0,0x3
    4b16:	24e50513          	addi	a0,a0,590 # 7d60 <malloc+0x1d9a>
    4b1a:	00001097          	auipc	ra,0x1
    4b1e:	3f4080e7          	jalr	1012(ra) # 5f0e <printf>
    exit(1);
    4b22:	4505                	li	a0,1
    4b24:	00001097          	auipc	ra,0x1
    4b28:	082080e7          	jalr	130(ra) # 5ba6 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b2c:	85d2                	mv	a1,s4
    4b2e:	00003517          	auipc	a0,0x3
    4b32:	25a50513          	addi	a0,a0,602 # 7d88 <malloc+0x1dc2>
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	3d8080e7          	jalr	984(ra) # 5f0e <printf>
      exit(1);
    4b3e:	4505                	li	a0,1
    4b40:	00001097          	auipc	ra,0x1
    4b44:	066080e7          	jalr	102(ra) # 5ba6 <exit>
    wait(&xstatus);
    4b48:	f9c40513          	addi	a0,s0,-100
    4b4c:	00001097          	auipc	ra,0x1
    4b50:	062080e7          	jalr	98(ra) # 5bae <wait>
    if (xstatus != 0)
    4b54:	f9c42983          	lw	s3,-100(s0)
    4b58:	00098763          	beqz	s3,4b66 <sharedfd+0xe6>
      exit(xstatus);
    4b5c:	854e                	mv	a0,s3
    4b5e:	00001097          	auipc	ra,0x1
    4b62:	048080e7          	jalr	72(ra) # 5ba6 <exit>
  close(fd);
    4b66:	854a                	mv	a0,s2
    4b68:	00001097          	auipc	ra,0x1
    4b6c:	066080e7          	jalr	102(ra) # 5bce <close>
  fd = open("sharedfd", 0);
    4b70:	4581                	li	a1,0
    4b72:	00003517          	auipc	a0,0x3
    4b76:	1de50513          	addi	a0,a0,478 # 7d50 <malloc+0x1d8a>
    4b7a:	00001097          	auipc	ra,0x1
    4b7e:	06c080e7          	jalr	108(ra) # 5be6 <open>
    4b82:	8baa                	mv	s7,a0
  nc = np = 0;
    4b84:	8ace                	mv	s5,s3
  if (fd < 0)
    4b86:	02054563          	bltz	a0,4bb0 <sharedfd+0x130>
    4b8a:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    4b8e:	06300493          	li	s1,99
      if (buf[i] == 'p')
    4b92:	07000b13          	li	s6,112
  while ((n = read(fd, buf, sizeof(buf))) > 0)
    4b96:	4629                	li	a2,10
    4b98:	fa040593          	addi	a1,s0,-96
    4b9c:	855e                	mv	a0,s7
    4b9e:	00001097          	auipc	ra,0x1
    4ba2:	020080e7          	jalr	32(ra) # 5bbe <read>
    4ba6:	02a05f63          	blez	a0,4be4 <sharedfd+0x164>
    4baa:	fa040793          	addi	a5,s0,-96
    4bae:	a01d                	j	4bd4 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4bb0:	85d2                	mv	a1,s4
    4bb2:	00003517          	auipc	a0,0x3
    4bb6:	1f650513          	addi	a0,a0,502 # 7da8 <malloc+0x1de2>
    4bba:	00001097          	auipc	ra,0x1
    4bbe:	354080e7          	jalr	852(ra) # 5f0e <printf>
    exit(1);
    4bc2:	4505                	li	a0,1
    4bc4:	00001097          	auipc	ra,0x1
    4bc8:	fe2080e7          	jalr	-30(ra) # 5ba6 <exit>
        nc++;
    4bcc:	2985                	addiw	s3,s3,1
    for (i = 0; i < sizeof(buf); i++)
    4bce:	0785                	addi	a5,a5,1
    4bd0:	fd2783e3          	beq	a5,s2,4b96 <sharedfd+0x116>
      if (buf[i] == 'c')
    4bd4:	0007c703          	lbu	a4,0(a5)
    4bd8:	fe970ae3          	beq	a4,s1,4bcc <sharedfd+0x14c>
      if (buf[i] == 'p')
    4bdc:	ff6719e3          	bne	a4,s6,4bce <sharedfd+0x14e>
        np++;
    4be0:	2a85                	addiw	s5,s5,1
    4be2:	b7f5                	j	4bce <sharedfd+0x14e>
  close(fd);
    4be4:	855e                	mv	a0,s7
    4be6:	00001097          	auipc	ra,0x1
    4bea:	fe8080e7          	jalr	-24(ra) # 5bce <close>
  unlink("sharedfd");
    4bee:	00003517          	auipc	a0,0x3
    4bf2:	16250513          	addi	a0,a0,354 # 7d50 <malloc+0x1d8a>
    4bf6:	00001097          	auipc	ra,0x1
    4bfa:	000080e7          	jalr	ra # 5bf6 <unlink>
  if (nc == N * SZ && np == N * SZ)
    4bfe:	6789                	lui	a5,0x2
    4c00:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xee>
    4c04:	00f99763          	bne	s3,a5,4c12 <sharedfd+0x192>
    4c08:	6789                	lui	a5,0x2
    4c0a:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xee>
    4c0e:	02fa8063          	beq	s5,a5,4c2e <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4c12:	85d2                	mv	a1,s4
    4c14:	00003517          	auipc	a0,0x3
    4c18:	1bc50513          	addi	a0,a0,444 # 7dd0 <malloc+0x1e0a>
    4c1c:	00001097          	auipc	ra,0x1
    4c20:	2f2080e7          	jalr	754(ra) # 5f0e <printf>
    exit(1);
    4c24:	4505                	li	a0,1
    4c26:	00001097          	auipc	ra,0x1
    4c2a:	f80080e7          	jalr	-128(ra) # 5ba6 <exit>
    exit(0);
    4c2e:	4501                	li	a0,0
    4c30:	00001097          	auipc	ra,0x1
    4c34:	f76080e7          	jalr	-138(ra) # 5ba6 <exit>

0000000000004c38 <fourfiles>:
{
    4c38:	7135                	addi	sp,sp,-160
    4c3a:	ed06                	sd	ra,152(sp)
    4c3c:	e922                	sd	s0,144(sp)
    4c3e:	e526                	sd	s1,136(sp)
    4c40:	e14a                	sd	s2,128(sp)
    4c42:	fcce                	sd	s3,120(sp)
    4c44:	f8d2                	sd	s4,112(sp)
    4c46:	f4d6                	sd	s5,104(sp)
    4c48:	f0da                	sd	s6,96(sp)
    4c4a:	ecde                	sd	s7,88(sp)
    4c4c:	e8e2                	sd	s8,80(sp)
    4c4e:	e4e6                	sd	s9,72(sp)
    4c50:	e0ea                	sd	s10,64(sp)
    4c52:	fc6e                	sd	s11,56(sp)
    4c54:	1100                	addi	s0,sp,160
    4c56:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    4c58:	00003797          	auipc	a5,0x3
    4c5c:	19078793          	addi	a5,a5,400 # 7de8 <malloc+0x1e22>
    4c60:	f6f43823          	sd	a5,-144(s0)
    4c64:	00003797          	auipc	a5,0x3
    4c68:	18c78793          	addi	a5,a5,396 # 7df0 <malloc+0x1e2a>
    4c6c:	f6f43c23          	sd	a5,-136(s0)
    4c70:	00003797          	auipc	a5,0x3
    4c74:	18878793          	addi	a5,a5,392 # 7df8 <malloc+0x1e32>
    4c78:	f8f43023          	sd	a5,-128(s0)
    4c7c:	00003797          	auipc	a5,0x3
    4c80:	18478793          	addi	a5,a5,388 # 7e00 <malloc+0x1e3a>
    4c84:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++)
    4c88:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    4c8c:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++)
    4c8e:	4481                	li	s1,0
    4c90:	4a11                	li	s4,4
    fname = names[pi];
    4c92:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c96:	854e                	mv	a0,s3
    4c98:	00001097          	auipc	ra,0x1
    4c9c:	f5e080e7          	jalr	-162(ra) # 5bf6 <unlink>
    pid = fork();
    4ca0:	00001097          	auipc	ra,0x1
    4ca4:	efe080e7          	jalr	-258(ra) # 5b9e <fork>
    if (pid < 0)
    4ca8:	04054063          	bltz	a0,4ce8 <fourfiles+0xb0>
    if (pid == 0)
    4cac:	cd21                	beqz	a0,4d04 <fourfiles+0xcc>
  for (pi = 0; pi < NCHILD; pi++)
    4cae:	2485                	addiw	s1,s1,1
    4cb0:	0921                	addi	s2,s2,8
    4cb2:	ff4490e3          	bne	s1,s4,4c92 <fourfiles+0x5a>
    4cb6:	4491                	li	s1,4
    wait(&xstatus);
    4cb8:	f6c40513          	addi	a0,s0,-148
    4cbc:	00001097          	auipc	ra,0x1
    4cc0:	ef2080e7          	jalr	-270(ra) # 5bae <wait>
    if (xstatus != 0)
    4cc4:	f6c42a83          	lw	s5,-148(s0)
    4cc8:	0c0a9863          	bnez	s5,4d98 <fourfiles+0x160>
  for (pi = 0; pi < NCHILD; pi++)
    4ccc:	34fd                	addiw	s1,s1,-1
    4cce:	f4ed                	bnez	s1,4cb8 <fourfiles+0x80>
    4cd0:	03000b13          	li	s6,48
    while ((n = read(fd, buf, sizeof(buf))) > 0)
    4cd4:	00008a17          	auipc	s4,0x8
    4cd8:	fa4a0a13          	addi	s4,s4,-92 # cc78 <buf>
    if (total != N * SZ)
    4cdc:	6d05                	lui	s10,0x1
    4cde:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x18>
  for (i = 0; i < NCHILD; i++)
    4ce2:	03400d93          	li	s11,52
    4ce6:	a22d                	j	4e10 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4ce8:	85e6                	mv	a1,s9
    4cea:	00002517          	auipc	a0,0x2
    4cee:	09e50513          	addi	a0,a0,158 # 6d88 <malloc+0xdc2>
    4cf2:	00001097          	auipc	ra,0x1
    4cf6:	21c080e7          	jalr	540(ra) # 5f0e <printf>
      exit(1);
    4cfa:	4505                	li	a0,1
    4cfc:	00001097          	auipc	ra,0x1
    4d00:	eaa080e7          	jalr	-342(ra) # 5ba6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d04:	20200593          	li	a1,514
    4d08:	854e                	mv	a0,s3
    4d0a:	00001097          	auipc	ra,0x1
    4d0e:	edc080e7          	jalr	-292(ra) # 5be6 <open>
    4d12:	892a                	mv	s2,a0
      if (fd < 0)
    4d14:	04054763          	bltz	a0,4d62 <fourfiles+0x12a>
      memset(buf, '0' + pi, SZ);
    4d18:	1f400613          	li	a2,500
    4d1c:	0304859b          	addiw	a1,s1,48
    4d20:	00008517          	auipc	a0,0x8
    4d24:	f5850513          	addi	a0,a0,-168 # cc78 <buf>
    4d28:	00001097          	auipc	ra,0x1
    4d2c:	c84080e7          	jalr	-892(ra) # 59ac <memset>
    4d30:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ)
    4d32:	00008997          	auipc	s3,0x8
    4d36:	f4698993          	addi	s3,s3,-186 # cc78 <buf>
    4d3a:	1f400613          	li	a2,500
    4d3e:	85ce                	mv	a1,s3
    4d40:	854a                	mv	a0,s2
    4d42:	00001097          	auipc	ra,0x1
    4d46:	e84080e7          	jalr	-380(ra) # 5bc6 <write>
    4d4a:	85aa                	mv	a1,a0
    4d4c:	1f400793          	li	a5,500
    4d50:	02f51763          	bne	a0,a5,4d7e <fourfiles+0x146>
      for (i = 0; i < N; i++)
    4d54:	34fd                	addiw	s1,s1,-1
    4d56:	f0f5                	bnez	s1,4d3a <fourfiles+0x102>
      exit(0);
    4d58:	4501                	li	a0,0
    4d5a:	00001097          	auipc	ra,0x1
    4d5e:	e4c080e7          	jalr	-436(ra) # 5ba6 <exit>
        printf("create failed\n", s);
    4d62:	85e6                	mv	a1,s9
    4d64:	00003517          	auipc	a0,0x3
    4d68:	0a450513          	addi	a0,a0,164 # 7e08 <malloc+0x1e42>
    4d6c:	00001097          	auipc	ra,0x1
    4d70:	1a2080e7          	jalr	418(ra) # 5f0e <printf>
        exit(1);
    4d74:	4505                	li	a0,1
    4d76:	00001097          	auipc	ra,0x1
    4d7a:	e30080e7          	jalr	-464(ra) # 5ba6 <exit>
          printf("write failed %d\n", n);
    4d7e:	00003517          	auipc	a0,0x3
    4d82:	09a50513          	addi	a0,a0,154 # 7e18 <malloc+0x1e52>
    4d86:	00001097          	auipc	ra,0x1
    4d8a:	188080e7          	jalr	392(ra) # 5f0e <printf>
          exit(1);
    4d8e:	4505                	li	a0,1
    4d90:	00001097          	auipc	ra,0x1
    4d94:	e16080e7          	jalr	-490(ra) # 5ba6 <exit>
      exit(xstatus);
    4d98:	8556                	mv	a0,s5
    4d9a:	00001097          	auipc	ra,0x1
    4d9e:	e0c080e7          	jalr	-500(ra) # 5ba6 <exit>
          printf("wrong char\n", s);
    4da2:	85e6                	mv	a1,s9
    4da4:	00003517          	auipc	a0,0x3
    4da8:	08c50513          	addi	a0,a0,140 # 7e30 <malloc+0x1e6a>
    4dac:	00001097          	auipc	ra,0x1
    4db0:	162080e7          	jalr	354(ra) # 5f0e <printf>
          exit(1);
    4db4:	4505                	li	a0,1
    4db6:	00001097          	auipc	ra,0x1
    4dba:	df0080e7          	jalr	-528(ra) # 5ba6 <exit>
      total += n;
    4dbe:	00a9093b          	addw	s2,s2,a0
    while ((n = read(fd, buf, sizeof(buf))) > 0)
    4dc2:	660d                	lui	a2,0x3
    4dc4:	85d2                	mv	a1,s4
    4dc6:	854e                	mv	a0,s3
    4dc8:	00001097          	auipc	ra,0x1
    4dcc:	df6080e7          	jalr	-522(ra) # 5bbe <read>
    4dd0:	02a05063          	blez	a0,4df0 <fourfiles+0x1b8>
    4dd4:	00008797          	auipc	a5,0x8
    4dd8:	ea478793          	addi	a5,a5,-348 # cc78 <buf>
    4ddc:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i)
    4de0:	0007c703          	lbu	a4,0(a5)
    4de4:	fa971fe3          	bne	a4,s1,4da2 <fourfiles+0x16a>
      for (j = 0; j < n; j++)
    4de8:	0785                	addi	a5,a5,1
    4dea:	fed79be3          	bne	a5,a3,4de0 <fourfiles+0x1a8>
    4dee:	bfc1                	j	4dbe <fourfiles+0x186>
    close(fd);
    4df0:	854e                	mv	a0,s3
    4df2:	00001097          	auipc	ra,0x1
    4df6:	ddc080e7          	jalr	-548(ra) # 5bce <close>
    if (total != N * SZ)
    4dfa:	03a91863          	bne	s2,s10,4e2a <fourfiles+0x1f2>
    unlink(fname);
    4dfe:	8562                	mv	a0,s8
    4e00:	00001097          	auipc	ra,0x1
    4e04:	df6080e7          	jalr	-522(ra) # 5bf6 <unlink>
  for (i = 0; i < NCHILD; i++)
    4e08:	0ba1                	addi	s7,s7,8
    4e0a:	2b05                	addiw	s6,s6,1
    4e0c:	03bb0d63          	beq	s6,s11,4e46 <fourfiles+0x20e>
    fname = names[i];
    4e10:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e14:	4581                	li	a1,0
    4e16:	8562                	mv	a0,s8
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	dce080e7          	jalr	-562(ra) # 5be6 <open>
    4e20:	89aa                	mv	s3,a0
    total = 0;
    4e22:	8956                	mv	s2,s5
        if (buf[j] != '0' + i)
    4e24:	000b049b          	sext.w	s1,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0)
    4e28:	bf69                	j	4dc2 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4e2a:	85ca                	mv	a1,s2
    4e2c:	00003517          	auipc	a0,0x3
    4e30:	01450513          	addi	a0,a0,20 # 7e40 <malloc+0x1e7a>
    4e34:	00001097          	auipc	ra,0x1
    4e38:	0da080e7          	jalr	218(ra) # 5f0e <printf>
      exit(1);
    4e3c:	4505                	li	a0,1
    4e3e:	00001097          	auipc	ra,0x1
    4e42:	d68080e7          	jalr	-664(ra) # 5ba6 <exit>
}
    4e46:	60ea                	ld	ra,152(sp)
    4e48:	644a                	ld	s0,144(sp)
    4e4a:	64aa                	ld	s1,136(sp)
    4e4c:	690a                	ld	s2,128(sp)
    4e4e:	79e6                	ld	s3,120(sp)
    4e50:	7a46                	ld	s4,112(sp)
    4e52:	7aa6                	ld	s5,104(sp)
    4e54:	7b06                	ld	s6,96(sp)
    4e56:	6be6                	ld	s7,88(sp)
    4e58:	6c46                	ld	s8,80(sp)
    4e5a:	6ca6                	ld	s9,72(sp)
    4e5c:	6d06                	ld	s10,64(sp)
    4e5e:	7de2                	ld	s11,56(sp)
    4e60:	610d                	addi	sp,sp,160
    4e62:	8082                	ret

0000000000004e64 <concreate>:
{
    4e64:	7135                	addi	sp,sp,-160
    4e66:	ed06                	sd	ra,152(sp)
    4e68:	e922                	sd	s0,144(sp)
    4e6a:	e526                	sd	s1,136(sp)
    4e6c:	e14a                	sd	s2,128(sp)
    4e6e:	fcce                	sd	s3,120(sp)
    4e70:	f8d2                	sd	s4,112(sp)
    4e72:	f4d6                	sd	s5,104(sp)
    4e74:	f0da                	sd	s6,96(sp)
    4e76:	ecde                	sd	s7,88(sp)
    4e78:	1100                	addi	s0,sp,160
    4e7a:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e7c:	04300793          	li	a5,67
    4e80:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e84:	fa040523          	sb	zero,-86(s0)
  for (i = 0; i < N; i++)
    4e88:	4901                	li	s2,0
    if (pid && (i % 3) == 1)
    4e8a:	4b0d                	li	s6,3
    4e8c:	4a85                	li	s5,1
      link("C0", file);
    4e8e:	00003b97          	auipc	s7,0x3
    4e92:	fcab8b93          	addi	s7,s7,-54 # 7e58 <malloc+0x1e92>
  for (i = 0; i < N; i++)
    4e96:	02800a13          	li	s4,40
    4e9a:	acc9                	j	516c <concreate+0x308>
      link("C0", file);
    4e9c:	fa840593          	addi	a1,s0,-88
    4ea0:	855e                	mv	a0,s7
    4ea2:	00001097          	auipc	ra,0x1
    4ea6:	d64080e7          	jalr	-668(ra) # 5c06 <link>
    if (pid == 0)
    4eaa:	a465                	j	5152 <concreate+0x2ee>
    else if (pid == 0 && (i % 5) == 1)
    4eac:	4795                	li	a5,5
    4eae:	02f9693b          	remw	s2,s2,a5
    4eb2:	4785                	li	a5,1
    4eb4:	02f90b63          	beq	s2,a5,4eea <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4eb8:	20200593          	li	a1,514
    4ebc:	fa840513          	addi	a0,s0,-88
    4ec0:	00001097          	auipc	ra,0x1
    4ec4:	d26080e7          	jalr	-730(ra) # 5be6 <open>
      if (fd < 0)
    4ec8:	26055c63          	bgez	a0,5140 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4ecc:	fa840593          	addi	a1,s0,-88
    4ed0:	00003517          	auipc	a0,0x3
    4ed4:	f9050513          	addi	a0,a0,-112 # 7e60 <malloc+0x1e9a>
    4ed8:	00001097          	auipc	ra,0x1
    4edc:	036080e7          	jalr	54(ra) # 5f0e <printf>
        exit(1);
    4ee0:	4505                	li	a0,1
    4ee2:	00001097          	auipc	ra,0x1
    4ee6:	cc4080e7          	jalr	-828(ra) # 5ba6 <exit>
      link("C0", file);
    4eea:	fa840593          	addi	a1,s0,-88
    4eee:	00003517          	auipc	a0,0x3
    4ef2:	f6a50513          	addi	a0,a0,-150 # 7e58 <malloc+0x1e92>
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	d10080e7          	jalr	-752(ra) # 5c06 <link>
      exit(0);
    4efe:	4501                	li	a0,0
    4f00:	00001097          	auipc	ra,0x1
    4f04:	ca6080e7          	jalr	-858(ra) # 5ba6 <exit>
        exit(1);
    4f08:	4505                	li	a0,1
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	c9c080e7          	jalr	-868(ra) # 5ba6 <exit>
  memset(fa, 0, sizeof(fa));
    4f12:	02800613          	li	a2,40
    4f16:	4581                	li	a1,0
    4f18:	f8040513          	addi	a0,s0,-128
    4f1c:	00001097          	auipc	ra,0x1
    4f20:	a90080e7          	jalr	-1392(ra) # 59ac <memset>
  fd = open(".", 0);
    4f24:	4581                	li	a1,0
    4f26:	00002517          	auipc	a0,0x2
    4f2a:	8aa50513          	addi	a0,a0,-1878 # 67d0 <malloc+0x80a>
    4f2e:	00001097          	auipc	ra,0x1
    4f32:	cb8080e7          	jalr	-840(ra) # 5be6 <open>
    4f36:	892a                	mv	s2,a0
  n = 0;
    4f38:	8aa6                	mv	s5,s1
    if (de.name[0] == 'C' && de.name[2] == '\0')
    4f3a:	04300a13          	li	s4,67
      if (i < 0 || i >= sizeof(fa))
    4f3e:	02700b13          	li	s6,39
      fa[i] = 1;
    4f42:	4b85                	li	s7,1
  while (read(fd, &de, sizeof(de)) > 0)
    4f44:	4641                	li	a2,16
    4f46:	f7040593          	addi	a1,s0,-144
    4f4a:	854a                	mv	a0,s2
    4f4c:	00001097          	auipc	ra,0x1
    4f50:	c72080e7          	jalr	-910(ra) # 5bbe <read>
    4f54:	08a05263          	blez	a0,4fd8 <concreate+0x174>
    if (de.inum == 0)
    4f58:	f7045783          	lhu	a5,-144(s0)
    4f5c:	d7e5                	beqz	a5,4f44 <concreate+0xe0>
    if (de.name[0] == 'C' && de.name[2] == '\0')
    4f5e:	f7244783          	lbu	a5,-142(s0)
    4f62:	ff4791e3          	bne	a5,s4,4f44 <concreate+0xe0>
    4f66:	f7444783          	lbu	a5,-140(s0)
    4f6a:	ffe9                	bnez	a5,4f44 <concreate+0xe0>
      i = de.name[1] - '0';
    4f6c:	f7344783          	lbu	a5,-141(s0)
    4f70:	fd07879b          	addiw	a5,a5,-48
    4f74:	0007871b          	sext.w	a4,a5
      if (i < 0 || i >= sizeof(fa))
    4f78:	02eb6063          	bltu	s6,a4,4f98 <concreate+0x134>
      if (fa[i])
    4f7c:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xbc>
    4f80:	97a2                	add	a5,a5,s0
    4f82:	fd07c783          	lbu	a5,-48(a5)
    4f86:	eb8d                	bnez	a5,4fb8 <concreate+0x154>
      fa[i] = 1;
    4f88:	fb070793          	addi	a5,a4,-80
    4f8c:	00878733          	add	a4,a5,s0
    4f90:	fd770823          	sb	s7,-48(a4)
      n++;
    4f94:	2a85                	addiw	s5,s5,1
    4f96:	b77d                	j	4f44 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f98:	f7240613          	addi	a2,s0,-142
    4f9c:	85ce                	mv	a1,s3
    4f9e:	00003517          	auipc	a0,0x3
    4fa2:	ee250513          	addi	a0,a0,-286 # 7e80 <malloc+0x1eba>
    4fa6:	00001097          	auipc	ra,0x1
    4faa:	f68080e7          	jalr	-152(ra) # 5f0e <printf>
        exit(1);
    4fae:	4505                	li	a0,1
    4fb0:	00001097          	auipc	ra,0x1
    4fb4:	bf6080e7          	jalr	-1034(ra) # 5ba6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fb8:	f7240613          	addi	a2,s0,-142
    4fbc:	85ce                	mv	a1,s3
    4fbe:	00003517          	auipc	a0,0x3
    4fc2:	ee250513          	addi	a0,a0,-286 # 7ea0 <malloc+0x1eda>
    4fc6:	00001097          	auipc	ra,0x1
    4fca:	f48080e7          	jalr	-184(ra) # 5f0e <printf>
        exit(1);
    4fce:	4505                	li	a0,1
    4fd0:	00001097          	auipc	ra,0x1
    4fd4:	bd6080e7          	jalr	-1066(ra) # 5ba6 <exit>
  close(fd);
    4fd8:	854a                	mv	a0,s2
    4fda:	00001097          	auipc	ra,0x1
    4fde:	bf4080e7          	jalr	-1036(ra) # 5bce <close>
  if (n != N)
    4fe2:	02800793          	li	a5,40
    4fe6:	00fa9763          	bne	s5,a5,4ff4 <concreate+0x190>
    if (((i % 3) == 0 && pid == 0) ||
    4fea:	4a8d                	li	s5,3
    4fec:	4b05                	li	s6,1
  for (i = 0; i < N; i++)
    4fee:	02800a13          	li	s4,40
    4ff2:	a8c9                	j	50c4 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ff4:	85ce                	mv	a1,s3
    4ff6:	00003517          	auipc	a0,0x3
    4ffa:	ed250513          	addi	a0,a0,-302 # 7ec8 <malloc+0x1f02>
    4ffe:	00001097          	auipc	ra,0x1
    5002:	f10080e7          	jalr	-240(ra) # 5f0e <printf>
    exit(1);
    5006:	4505                	li	a0,1
    5008:	00001097          	auipc	ra,0x1
    500c:	b9e080e7          	jalr	-1122(ra) # 5ba6 <exit>
      printf("%s: fork failed\n", s);
    5010:	85ce                	mv	a1,s3
    5012:	00002517          	auipc	a0,0x2
    5016:	96e50513          	addi	a0,a0,-1682 # 6980 <malloc+0x9ba>
    501a:	00001097          	auipc	ra,0x1
    501e:	ef4080e7          	jalr	-268(ra) # 5f0e <printf>
      exit(1);
    5022:	4505                	li	a0,1
    5024:	00001097          	auipc	ra,0x1
    5028:	b82080e7          	jalr	-1150(ra) # 5ba6 <exit>
      close(open(file, 0));
    502c:	4581                	li	a1,0
    502e:	fa840513          	addi	a0,s0,-88
    5032:	00001097          	auipc	ra,0x1
    5036:	bb4080e7          	jalr	-1100(ra) # 5be6 <open>
    503a:	00001097          	auipc	ra,0x1
    503e:	b94080e7          	jalr	-1132(ra) # 5bce <close>
      close(open(file, 0));
    5042:	4581                	li	a1,0
    5044:	fa840513          	addi	a0,s0,-88
    5048:	00001097          	auipc	ra,0x1
    504c:	b9e080e7          	jalr	-1122(ra) # 5be6 <open>
    5050:	00001097          	auipc	ra,0x1
    5054:	b7e080e7          	jalr	-1154(ra) # 5bce <close>
      close(open(file, 0));
    5058:	4581                	li	a1,0
    505a:	fa840513          	addi	a0,s0,-88
    505e:	00001097          	auipc	ra,0x1
    5062:	b88080e7          	jalr	-1144(ra) # 5be6 <open>
    5066:	00001097          	auipc	ra,0x1
    506a:	b68080e7          	jalr	-1176(ra) # 5bce <close>
      close(open(file, 0));
    506e:	4581                	li	a1,0
    5070:	fa840513          	addi	a0,s0,-88
    5074:	00001097          	auipc	ra,0x1
    5078:	b72080e7          	jalr	-1166(ra) # 5be6 <open>
    507c:	00001097          	auipc	ra,0x1
    5080:	b52080e7          	jalr	-1198(ra) # 5bce <close>
      close(open(file, 0));
    5084:	4581                	li	a1,0
    5086:	fa840513          	addi	a0,s0,-88
    508a:	00001097          	auipc	ra,0x1
    508e:	b5c080e7          	jalr	-1188(ra) # 5be6 <open>
    5092:	00001097          	auipc	ra,0x1
    5096:	b3c080e7          	jalr	-1220(ra) # 5bce <close>
      close(open(file, 0));
    509a:	4581                	li	a1,0
    509c:	fa840513          	addi	a0,s0,-88
    50a0:	00001097          	auipc	ra,0x1
    50a4:	b46080e7          	jalr	-1210(ra) # 5be6 <open>
    50a8:	00001097          	auipc	ra,0x1
    50ac:	b26080e7          	jalr	-1242(ra) # 5bce <close>
    if (pid == 0)
    50b0:	08090363          	beqz	s2,5136 <concreate+0x2d2>
      wait(0);
    50b4:	4501                	li	a0,0
    50b6:	00001097          	auipc	ra,0x1
    50ba:	af8080e7          	jalr	-1288(ra) # 5bae <wait>
  for (i = 0; i < N; i++)
    50be:	2485                	addiw	s1,s1,1
    50c0:	0f448563          	beq	s1,s4,51aa <concreate+0x346>
    file[1] = '0' + i;
    50c4:	0304879b          	addiw	a5,s1,48
    50c8:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50cc:	00001097          	auipc	ra,0x1
    50d0:	ad2080e7          	jalr	-1326(ra) # 5b9e <fork>
    50d4:	892a                	mv	s2,a0
    if (pid < 0)
    50d6:	f2054de3          	bltz	a0,5010 <concreate+0x1ac>
    if (((i % 3) == 0 && pid == 0) ||
    50da:	0354e73b          	remw	a4,s1,s5
    50de:	00a767b3          	or	a5,a4,a0
    50e2:	2781                	sext.w	a5,a5
    50e4:	d7a1                	beqz	a5,502c <concreate+0x1c8>
    50e6:	01671363          	bne	a4,s6,50ec <concreate+0x288>
        ((i % 3) == 1 && pid != 0))
    50ea:	f129                	bnez	a0,502c <concreate+0x1c8>
      unlink(file);
    50ec:	fa840513          	addi	a0,s0,-88
    50f0:	00001097          	auipc	ra,0x1
    50f4:	b06080e7          	jalr	-1274(ra) # 5bf6 <unlink>
      unlink(file);
    50f8:	fa840513          	addi	a0,s0,-88
    50fc:	00001097          	auipc	ra,0x1
    5100:	afa080e7          	jalr	-1286(ra) # 5bf6 <unlink>
      unlink(file);
    5104:	fa840513          	addi	a0,s0,-88
    5108:	00001097          	auipc	ra,0x1
    510c:	aee080e7          	jalr	-1298(ra) # 5bf6 <unlink>
      unlink(file);
    5110:	fa840513          	addi	a0,s0,-88
    5114:	00001097          	auipc	ra,0x1
    5118:	ae2080e7          	jalr	-1310(ra) # 5bf6 <unlink>
      unlink(file);
    511c:	fa840513          	addi	a0,s0,-88
    5120:	00001097          	auipc	ra,0x1
    5124:	ad6080e7          	jalr	-1322(ra) # 5bf6 <unlink>
      unlink(file);
    5128:	fa840513          	addi	a0,s0,-88
    512c:	00001097          	auipc	ra,0x1
    5130:	aca080e7          	jalr	-1334(ra) # 5bf6 <unlink>
    5134:	bfb5                	j	50b0 <concreate+0x24c>
      exit(0);
    5136:	4501                	li	a0,0
    5138:	00001097          	auipc	ra,0x1
    513c:	a6e080e7          	jalr	-1426(ra) # 5ba6 <exit>
      close(fd);
    5140:	00001097          	auipc	ra,0x1
    5144:	a8e080e7          	jalr	-1394(ra) # 5bce <close>
    if (pid == 0)
    5148:	bb5d                	j	4efe <concreate+0x9a>
      close(fd);
    514a:	00001097          	auipc	ra,0x1
    514e:	a84080e7          	jalr	-1404(ra) # 5bce <close>
      wait(&xstatus);
    5152:	f6c40513          	addi	a0,s0,-148
    5156:	00001097          	auipc	ra,0x1
    515a:	a58080e7          	jalr	-1448(ra) # 5bae <wait>
      if (xstatus != 0)
    515e:	f6c42483          	lw	s1,-148(s0)
    5162:	da0493e3          	bnez	s1,4f08 <concreate+0xa4>
  for (i = 0; i < N; i++)
    5166:	2905                	addiw	s2,s2,1
    5168:	db4905e3          	beq	s2,s4,4f12 <concreate+0xae>
    file[1] = '0' + i;
    516c:	0309079b          	addiw	a5,s2,48
    5170:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5174:	fa840513          	addi	a0,s0,-88
    5178:	00001097          	auipc	ra,0x1
    517c:	a7e080e7          	jalr	-1410(ra) # 5bf6 <unlink>
    pid = fork();
    5180:	00001097          	auipc	ra,0x1
    5184:	a1e080e7          	jalr	-1506(ra) # 5b9e <fork>
    if (pid && (i % 3) == 1)
    5188:	d20502e3          	beqz	a0,4eac <concreate+0x48>
    518c:	036967bb          	remw	a5,s2,s6
    5190:	d15786e3          	beq	a5,s5,4e9c <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5194:	20200593          	li	a1,514
    5198:	fa840513          	addi	a0,s0,-88
    519c:	00001097          	auipc	ra,0x1
    51a0:	a4a080e7          	jalr	-1462(ra) # 5be6 <open>
      if (fd < 0)
    51a4:	fa0553e3          	bgez	a0,514a <concreate+0x2e6>
    51a8:	b315                	j	4ecc <concreate+0x68>
}
    51aa:	60ea                	ld	ra,152(sp)
    51ac:	644a                	ld	s0,144(sp)
    51ae:	64aa                	ld	s1,136(sp)
    51b0:	690a                	ld	s2,128(sp)
    51b2:	79e6                	ld	s3,120(sp)
    51b4:	7a46                	ld	s4,112(sp)
    51b6:	7aa6                	ld	s5,104(sp)
    51b8:	7b06                	ld	s6,96(sp)
    51ba:	6be6                	ld	s7,88(sp)
    51bc:	610d                	addi	sp,sp,160
    51be:	8082                	ret

00000000000051c0 <bigfile>:
{
    51c0:	7139                	addi	sp,sp,-64
    51c2:	fc06                	sd	ra,56(sp)
    51c4:	f822                	sd	s0,48(sp)
    51c6:	f426                	sd	s1,40(sp)
    51c8:	f04a                	sd	s2,32(sp)
    51ca:	ec4e                	sd	s3,24(sp)
    51cc:	e852                	sd	s4,16(sp)
    51ce:	e456                	sd	s5,8(sp)
    51d0:	0080                	addi	s0,sp,64
    51d2:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51d4:	00003517          	auipc	a0,0x3
    51d8:	d2c50513          	addi	a0,a0,-724 # 7f00 <malloc+0x1f3a>
    51dc:	00001097          	auipc	ra,0x1
    51e0:	a1a080e7          	jalr	-1510(ra) # 5bf6 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51e4:	20200593          	li	a1,514
    51e8:	00003517          	auipc	a0,0x3
    51ec:	d1850513          	addi	a0,a0,-744 # 7f00 <malloc+0x1f3a>
    51f0:	00001097          	auipc	ra,0x1
    51f4:	9f6080e7          	jalr	-1546(ra) # 5be6 <open>
    51f8:	89aa                	mv	s3,a0
  for (i = 0; i < N; i++)
    51fa:	4481                	li	s1,0
    memset(buf, i, SZ);
    51fc:	00008917          	auipc	s2,0x8
    5200:	a7c90913          	addi	s2,s2,-1412 # cc78 <buf>
  for (i = 0; i < N; i++)
    5204:	4a51                	li	s4,20
  if (fd < 0)
    5206:	0a054063          	bltz	a0,52a6 <bigfile+0xe6>
    memset(buf, i, SZ);
    520a:	25800613          	li	a2,600
    520e:	85a6                	mv	a1,s1
    5210:	854a                	mv	a0,s2
    5212:	00000097          	auipc	ra,0x0
    5216:	79a080e7          	jalr	1946(ra) # 59ac <memset>
    if (write(fd, buf, SZ) != SZ)
    521a:	25800613          	li	a2,600
    521e:	85ca                	mv	a1,s2
    5220:	854e                	mv	a0,s3
    5222:	00001097          	auipc	ra,0x1
    5226:	9a4080e7          	jalr	-1628(ra) # 5bc6 <write>
    522a:	25800793          	li	a5,600
    522e:	08f51a63          	bne	a0,a5,52c2 <bigfile+0x102>
  for (i = 0; i < N; i++)
    5232:	2485                	addiw	s1,s1,1
    5234:	fd449be3          	bne	s1,s4,520a <bigfile+0x4a>
  close(fd);
    5238:	854e                	mv	a0,s3
    523a:	00001097          	auipc	ra,0x1
    523e:	994080e7          	jalr	-1644(ra) # 5bce <close>
  fd = open("bigfile.dat", 0);
    5242:	4581                	li	a1,0
    5244:	00003517          	auipc	a0,0x3
    5248:	cbc50513          	addi	a0,a0,-836 # 7f00 <malloc+0x1f3a>
    524c:	00001097          	auipc	ra,0x1
    5250:	99a080e7          	jalr	-1638(ra) # 5be6 <open>
    5254:	8a2a                	mv	s4,a0
  total = 0;
    5256:	4981                	li	s3,0
  for (i = 0;; i++)
    5258:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    525a:	00008917          	auipc	s2,0x8
    525e:	a1e90913          	addi	s2,s2,-1506 # cc78 <buf>
  if (fd < 0)
    5262:	06054e63          	bltz	a0,52de <bigfile+0x11e>
    cc = read(fd, buf, SZ / 2);
    5266:	12c00613          	li	a2,300
    526a:	85ca                	mv	a1,s2
    526c:	8552                	mv	a0,s4
    526e:	00001097          	auipc	ra,0x1
    5272:	950080e7          	jalr	-1712(ra) # 5bbe <read>
    if (cc < 0)
    5276:	08054263          	bltz	a0,52fa <bigfile+0x13a>
    if (cc == 0)
    527a:	c971                	beqz	a0,534e <bigfile+0x18e>
    if (cc != SZ / 2)
    527c:	12c00793          	li	a5,300
    5280:	08f51b63          	bne	a0,a5,5316 <bigfile+0x156>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2)
    5284:	01f4d79b          	srliw	a5,s1,0x1f
    5288:	9fa5                	addw	a5,a5,s1
    528a:	4017d79b          	sraiw	a5,a5,0x1
    528e:	00094703          	lbu	a4,0(s2)
    5292:	0af71063          	bne	a4,a5,5332 <bigfile+0x172>
    5296:	12b94703          	lbu	a4,299(s2)
    529a:	08f71c63          	bne	a4,a5,5332 <bigfile+0x172>
    total += cc;
    529e:	12c9899b          	addiw	s3,s3,300
  for (i = 0;; i++)
    52a2:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    52a4:	b7c9                	j	5266 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52a6:	85d6                	mv	a1,s5
    52a8:	00003517          	auipc	a0,0x3
    52ac:	c6850513          	addi	a0,a0,-920 # 7f10 <malloc+0x1f4a>
    52b0:	00001097          	auipc	ra,0x1
    52b4:	c5e080e7          	jalr	-930(ra) # 5f0e <printf>
    exit(1);
    52b8:	4505                	li	a0,1
    52ba:	00001097          	auipc	ra,0x1
    52be:	8ec080e7          	jalr	-1812(ra) # 5ba6 <exit>
      printf("%s: write bigfile failed\n", s);
    52c2:	85d6                	mv	a1,s5
    52c4:	00003517          	auipc	a0,0x3
    52c8:	c6c50513          	addi	a0,a0,-916 # 7f30 <malloc+0x1f6a>
    52cc:	00001097          	auipc	ra,0x1
    52d0:	c42080e7          	jalr	-958(ra) # 5f0e <printf>
      exit(1);
    52d4:	4505                	li	a0,1
    52d6:	00001097          	auipc	ra,0x1
    52da:	8d0080e7          	jalr	-1840(ra) # 5ba6 <exit>
    printf("%s: cannot open bigfile\n", s);
    52de:	85d6                	mv	a1,s5
    52e0:	00003517          	auipc	a0,0x3
    52e4:	c7050513          	addi	a0,a0,-912 # 7f50 <malloc+0x1f8a>
    52e8:	00001097          	auipc	ra,0x1
    52ec:	c26080e7          	jalr	-986(ra) # 5f0e <printf>
    exit(1);
    52f0:	4505                	li	a0,1
    52f2:	00001097          	auipc	ra,0x1
    52f6:	8b4080e7          	jalr	-1868(ra) # 5ba6 <exit>
      printf("%s: read bigfile failed\n", s);
    52fa:	85d6                	mv	a1,s5
    52fc:	00003517          	auipc	a0,0x3
    5300:	c7450513          	addi	a0,a0,-908 # 7f70 <malloc+0x1faa>
    5304:	00001097          	auipc	ra,0x1
    5308:	c0a080e7          	jalr	-1014(ra) # 5f0e <printf>
      exit(1);
    530c:	4505                	li	a0,1
    530e:	00001097          	auipc	ra,0x1
    5312:	898080e7          	jalr	-1896(ra) # 5ba6 <exit>
      printf("%s: short read bigfile\n", s);
    5316:	85d6                	mv	a1,s5
    5318:	00003517          	auipc	a0,0x3
    531c:	c7850513          	addi	a0,a0,-904 # 7f90 <malloc+0x1fca>
    5320:	00001097          	auipc	ra,0x1
    5324:	bee080e7          	jalr	-1042(ra) # 5f0e <printf>
      exit(1);
    5328:	4505                	li	a0,1
    532a:	00001097          	auipc	ra,0x1
    532e:	87c080e7          	jalr	-1924(ra) # 5ba6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    5332:	85d6                	mv	a1,s5
    5334:	00003517          	auipc	a0,0x3
    5338:	c7450513          	addi	a0,a0,-908 # 7fa8 <malloc+0x1fe2>
    533c:	00001097          	auipc	ra,0x1
    5340:	bd2080e7          	jalr	-1070(ra) # 5f0e <printf>
      exit(1);
    5344:	4505                	li	a0,1
    5346:	00001097          	auipc	ra,0x1
    534a:	860080e7          	jalr	-1952(ra) # 5ba6 <exit>
  close(fd);
    534e:	8552                	mv	a0,s4
    5350:	00001097          	auipc	ra,0x1
    5354:	87e080e7          	jalr	-1922(ra) # 5bce <close>
  if (total != N * SZ)
    5358:	678d                	lui	a5,0x3
    535a:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x76>
    535e:	02f99363          	bne	s3,a5,5384 <bigfile+0x1c4>
  unlink("bigfile.dat");
    5362:	00003517          	auipc	a0,0x3
    5366:	b9e50513          	addi	a0,a0,-1122 # 7f00 <malloc+0x1f3a>
    536a:	00001097          	auipc	ra,0x1
    536e:	88c080e7          	jalr	-1908(ra) # 5bf6 <unlink>
}
    5372:	70e2                	ld	ra,56(sp)
    5374:	7442                	ld	s0,48(sp)
    5376:	74a2                	ld	s1,40(sp)
    5378:	7902                	ld	s2,32(sp)
    537a:	69e2                	ld	s3,24(sp)
    537c:	6a42                	ld	s4,16(sp)
    537e:	6aa2                	ld	s5,8(sp)
    5380:	6121                	addi	sp,sp,64
    5382:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5384:	85d6                	mv	a1,s5
    5386:	00003517          	auipc	a0,0x3
    538a:	c4250513          	addi	a0,a0,-958 # 7fc8 <malloc+0x2002>
    538e:	00001097          	auipc	ra,0x1
    5392:	b80080e7          	jalr	-1152(ra) # 5f0e <printf>
    exit(1);
    5396:	4505                	li	a0,1
    5398:	00001097          	auipc	ra,0x1
    539c:	80e080e7          	jalr	-2034(ra) # 5ba6 <exit>

00000000000053a0 <fsfull>:
{
    53a0:	7135                	addi	sp,sp,-160
    53a2:	ed06                	sd	ra,152(sp)
    53a4:	e922                	sd	s0,144(sp)
    53a6:	e526                	sd	s1,136(sp)
    53a8:	e14a                	sd	s2,128(sp)
    53aa:	fcce                	sd	s3,120(sp)
    53ac:	f8d2                	sd	s4,112(sp)
    53ae:	f4d6                	sd	s5,104(sp)
    53b0:	f0da                	sd	s6,96(sp)
    53b2:	ecde                	sd	s7,88(sp)
    53b4:	e8e2                	sd	s8,80(sp)
    53b6:	e4e6                	sd	s9,72(sp)
    53b8:	e0ea                	sd	s10,64(sp)
    53ba:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    53bc:	00003517          	auipc	a0,0x3
    53c0:	c2c50513          	addi	a0,a0,-980 # 7fe8 <malloc+0x2022>
    53c4:	00001097          	auipc	ra,0x1
    53c8:	b4a080e7          	jalr	-1206(ra) # 5f0e <printf>
  for (nfiles = 0;; nfiles++)
    53cc:	4481                	li	s1,0
    name[0] = 'f';
    53ce:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53d2:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53d6:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53da:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53dc:	00003c97          	auipc	s9,0x3
    53e0:	c1cc8c93          	addi	s9,s9,-996 # 7ff8 <malloc+0x2032>
    name[0] = 'f';
    53e4:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    53e8:	0384c7bb          	divw	a5,s1,s8
    53ec:	0307879b          	addiw	a5,a5,48
    53f0:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53f4:	0384e7bb          	remw	a5,s1,s8
    53f8:	0377c7bb          	divw	a5,a5,s7
    53fc:	0307879b          	addiw	a5,a5,48
    5400:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5404:	0374e7bb          	remw	a5,s1,s7
    5408:	0367c7bb          	divw	a5,a5,s6
    540c:	0307879b          	addiw	a5,a5,48
    5410:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5414:	0364e7bb          	remw	a5,s1,s6
    5418:	0307879b          	addiw	a5,a5,48
    541c:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5420:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    5424:	f6040593          	addi	a1,s0,-160
    5428:	8566                	mv	a0,s9
    542a:	00001097          	auipc	ra,0x1
    542e:	ae4080e7          	jalr	-1308(ra) # 5f0e <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    5432:	20200593          	li	a1,514
    5436:	f6040513          	addi	a0,s0,-160
    543a:	00000097          	auipc	ra,0x0
    543e:	7ac080e7          	jalr	1964(ra) # 5be6 <open>
    5442:	892a                	mv	s2,a0
    if (fd < 0)
    5444:	0a055563          	bgez	a0,54ee <fsfull+0x14e>
      printf("open %s failed\n", name);
    5448:	f6040593          	addi	a1,s0,-160
    544c:	00003517          	auipc	a0,0x3
    5450:	bbc50513          	addi	a0,a0,-1092 # 8008 <malloc+0x2042>
    5454:	00001097          	auipc	ra,0x1
    5458:	aba080e7          	jalr	-1350(ra) # 5f0e <printf>
  while (nfiles >= 0)
    545c:	0604c363          	bltz	s1,54c2 <fsfull+0x122>
    name[0] = 'f';
    5460:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5464:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5468:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    546c:	4929                	li	s2,10
  while (nfiles >= 0)
    546e:	5afd                	li	s5,-1
    name[0] = 'f';
    5470:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5474:	0344c7bb          	divw	a5,s1,s4
    5478:	0307879b          	addiw	a5,a5,48
    547c:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5480:	0344e7bb          	remw	a5,s1,s4
    5484:	0337c7bb          	divw	a5,a5,s3
    5488:	0307879b          	addiw	a5,a5,48
    548c:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5490:	0334e7bb          	remw	a5,s1,s3
    5494:	0327c7bb          	divw	a5,a5,s2
    5498:	0307879b          	addiw	a5,a5,48
    549c:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    54a0:	0324e7bb          	remw	a5,s1,s2
    54a4:	0307879b          	addiw	a5,a5,48
    54a8:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    54ac:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    54b0:	f6040513          	addi	a0,s0,-160
    54b4:	00000097          	auipc	ra,0x0
    54b8:	742080e7          	jalr	1858(ra) # 5bf6 <unlink>
    nfiles--;
    54bc:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0)
    54be:	fb5499e3          	bne	s1,s5,5470 <fsfull+0xd0>
  printf("fsfull test finished\n");
    54c2:	00003517          	auipc	a0,0x3
    54c6:	b6650513          	addi	a0,a0,-1178 # 8028 <malloc+0x2062>
    54ca:	00001097          	auipc	ra,0x1
    54ce:	a44080e7          	jalr	-1468(ra) # 5f0e <printf>
}
    54d2:	60ea                	ld	ra,152(sp)
    54d4:	644a                	ld	s0,144(sp)
    54d6:	64aa                	ld	s1,136(sp)
    54d8:	690a                	ld	s2,128(sp)
    54da:	79e6                	ld	s3,120(sp)
    54dc:	7a46                	ld	s4,112(sp)
    54de:	7aa6                	ld	s5,104(sp)
    54e0:	7b06                	ld	s6,96(sp)
    54e2:	6be6                	ld	s7,88(sp)
    54e4:	6c46                	ld	s8,80(sp)
    54e6:	6ca6                	ld	s9,72(sp)
    54e8:	6d06                	ld	s10,64(sp)
    54ea:	610d                	addi	sp,sp,160
    54ec:	8082                	ret
    int total = 0;
    54ee:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    54f0:	00007a97          	auipc	s5,0x7
    54f4:	788a8a93          	addi	s5,s5,1928 # cc78 <buf>
      if (cc < BSIZE)
    54f8:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    54fc:	40000613          	li	a2,1024
    5500:	85d6                	mv	a1,s5
    5502:	854a                	mv	a0,s2
    5504:	00000097          	auipc	ra,0x0
    5508:	6c2080e7          	jalr	1730(ra) # 5bc6 <write>
      if (cc < BSIZE)
    550c:	00aa5563          	bge	s4,a0,5516 <fsfull+0x176>
      total += cc;
    5510:	00a989bb          	addw	s3,s3,a0
    {
    5514:	b7e5                	j	54fc <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    5516:	85ce                	mv	a1,s3
    5518:	00003517          	auipc	a0,0x3
    551c:	b0050513          	addi	a0,a0,-1280 # 8018 <malloc+0x2052>
    5520:	00001097          	auipc	ra,0x1
    5524:	9ee080e7          	jalr	-1554(ra) # 5f0e <printf>
    close(fd);
    5528:	854a                	mv	a0,s2
    552a:	00000097          	auipc	ra,0x0
    552e:	6a4080e7          	jalr	1700(ra) # 5bce <close>
    if (total == 0)
    5532:	f20985e3          	beqz	s3,545c <fsfull+0xbc>
  for (nfiles = 0;; nfiles++)
    5536:	2485                	addiw	s1,s1,1
  {
    5538:	b575                	j	53e4 <fsfull+0x44>

000000000000553a <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s)
{
    553a:	7179                	addi	sp,sp,-48
    553c:	f406                	sd	ra,40(sp)
    553e:	f022                	sd	s0,32(sp)
    5540:	ec26                	sd	s1,24(sp)
    5542:	e84a                	sd	s2,16(sp)
    5544:	1800                	addi	s0,sp,48
    5546:	84aa                	mv	s1,a0
    5548:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    554a:	00003517          	auipc	a0,0x3
    554e:	af650513          	addi	a0,a0,-1290 # 8040 <malloc+0x207a>
    5552:	00001097          	auipc	ra,0x1
    5556:	9bc080e7          	jalr	-1604(ra) # 5f0e <printf>
  if ((pid = fork()) < 0)
    555a:	00000097          	auipc	ra,0x0
    555e:	644080e7          	jalr	1604(ra) # 5b9e <fork>
    5562:	02054e63          	bltz	a0,559e <run+0x64>
  {
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0)
    5566:	c929                	beqz	a0,55b8 <run+0x7e>
    f(s);
    exit(0);
  }
  else
  {
    wait(&xstatus);
    5568:	fdc40513          	addi	a0,s0,-36
    556c:	00000097          	auipc	ra,0x0
    5570:	642080e7          	jalr	1602(ra) # 5bae <wait>
    if (xstatus != 0)
    5574:	fdc42783          	lw	a5,-36(s0)
    5578:	c7b9                	beqz	a5,55c6 <run+0x8c>
      printf("FAILED\n");
    557a:	00003517          	auipc	a0,0x3
    557e:	aee50513          	addi	a0,a0,-1298 # 8068 <malloc+0x20a2>
    5582:	00001097          	auipc	ra,0x1
    5586:	98c080e7          	jalr	-1652(ra) # 5f0e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    558a:	fdc42503          	lw	a0,-36(s0)
  }
}
    558e:	00153513          	seqz	a0,a0
    5592:	70a2                	ld	ra,40(sp)
    5594:	7402                	ld	s0,32(sp)
    5596:	64e2                	ld	s1,24(sp)
    5598:	6942                	ld	s2,16(sp)
    559a:	6145                	addi	sp,sp,48
    559c:	8082                	ret
    printf("runtest: fork error\n");
    559e:	00003517          	auipc	a0,0x3
    55a2:	ab250513          	addi	a0,a0,-1358 # 8050 <malloc+0x208a>
    55a6:	00001097          	auipc	ra,0x1
    55aa:	968080e7          	jalr	-1688(ra) # 5f0e <printf>
    exit(1);
    55ae:	4505                	li	a0,1
    55b0:	00000097          	auipc	ra,0x0
    55b4:	5f6080e7          	jalr	1526(ra) # 5ba6 <exit>
    f(s);
    55b8:	854a                	mv	a0,s2
    55ba:	9482                	jalr	s1
    exit(0);
    55bc:	4501                	li	a0,0
    55be:	00000097          	auipc	ra,0x0
    55c2:	5e8080e7          	jalr	1512(ra) # 5ba6 <exit>
      printf("OK\n");
    55c6:	00003517          	auipc	a0,0x3
    55ca:	aaa50513          	addi	a0,a0,-1366 # 8070 <malloc+0x20aa>
    55ce:	00001097          	auipc	ra,0x1
    55d2:	940080e7          	jalr	-1728(ra) # 5f0e <printf>
    55d6:	bf55                	j	558a <run+0x50>

00000000000055d8 <runtests>:

int runtests(struct test *tests, char *justone)
{
    55d8:	1101                	addi	sp,sp,-32
    55da:	ec06                	sd	ra,24(sp)
    55dc:	e822                	sd	s0,16(sp)
    55de:	e426                	sd	s1,8(sp)
    55e0:	e04a                	sd	s2,0(sp)
    55e2:	1000                	addi	s0,sp,32
    55e4:	84aa                	mv	s1,a0
    55e6:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++)
    55e8:	6508                	ld	a0,8(a0)
    55ea:	ed09                	bnez	a0,5604 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55ec:	4501                	li	a0,0
    55ee:	a82d                	j	5628 <runtests+0x50>
      if (!run(t->f, t->s))
    55f0:	648c                	ld	a1,8(s1)
    55f2:	6088                	ld	a0,0(s1)
    55f4:	00000097          	auipc	ra,0x0
    55f8:	f46080e7          	jalr	-186(ra) # 553a <run>
    55fc:	cd09                	beqz	a0,5616 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++)
    55fe:	04c1                	addi	s1,s1,16
    5600:	6488                	ld	a0,8(s1)
    5602:	c11d                	beqz	a0,5628 <runtests+0x50>
    if ((justone == 0) || strcmp(t->s, justone) == 0)
    5604:	fe0906e3          	beqz	s2,55f0 <runtests+0x18>
    5608:	85ca                	mv	a1,s2
    560a:	00000097          	auipc	ra,0x0
    560e:	34c080e7          	jalr	844(ra) # 5956 <strcmp>
    5612:	f575                	bnez	a0,55fe <runtests+0x26>
    5614:	bff1                	j	55f0 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5616:	00003517          	auipc	a0,0x3
    561a:	a6250513          	addi	a0,a0,-1438 # 8078 <malloc+0x20b2>
    561e:	00001097          	auipc	ra,0x1
    5622:	8f0080e7          	jalr	-1808(ra) # 5f0e <printf>
        return 1;
    5626:	4505                	li	a0,1
}
    5628:	60e2                	ld	ra,24(sp)
    562a:	6442                	ld	s0,16(sp)
    562c:	64a2                	ld	s1,8(sp)
    562e:	6902                	ld	s2,0(sp)
    5630:	6105                	addi	sp,sp,32
    5632:	8082                	ret

0000000000005634 <countfree>:
// touches the pages to force allocation.
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int countfree()
{
    5634:	7139                	addi	sp,sp,-64
    5636:	fc06                	sd	ra,56(sp)
    5638:	f822                	sd	s0,48(sp)
    563a:	f426                	sd	s1,40(sp)
    563c:	f04a                	sd	s2,32(sp)
    563e:	ec4e                	sd	s3,24(sp)
    5640:	0080                	addi	s0,sp,64
  int fds[2];

  if (pipe(fds) < 0)
    5642:	fc840513          	addi	a0,s0,-56
    5646:	00000097          	auipc	ra,0x0
    564a:	570080e7          	jalr	1392(ra) # 5bb6 <pipe>
    564e:	06054763          	bltz	a0,56bc <countfree+0x88>
  {
    printf("pipe() failed in countfree()\n");
    exit(1);
  }

  int pid = fork();
    5652:	00000097          	auipc	ra,0x0
    5656:	54c080e7          	jalr	1356(ra) # 5b9e <fork>

  if (pid < 0)
    565a:	06054e63          	bltz	a0,56d6 <countfree+0xa2>
  {
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if (pid == 0)
    565e:	ed51                	bnez	a0,56fa <countfree+0xc6>
  {
    close(fds[0]);
    5660:	fc842503          	lw	a0,-56(s0)
    5664:	00000097          	auipc	ra,0x0
    5668:	56a080e7          	jalr	1386(ra) # 5bce <close>

    while (1)
    {
      uint64 a = (uint64)sbrk(4096);
      if (a == 0xffffffffffffffff)
    566c:	597d                	li	s2,-1
      {
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    566e:	4485                	li	s1,1

      // report back one more page.
      if (write(fds[1], "x", 1) != 1)
    5670:	00001997          	auipc	s3,0x1
    5674:	ae898993          	addi	s3,s3,-1304 # 6158 <malloc+0x192>
      uint64 a = (uint64)sbrk(4096);
    5678:	6505                	lui	a0,0x1
    567a:	00000097          	auipc	ra,0x0
    567e:	5b4080e7          	jalr	1460(ra) # 5c2e <sbrk>
      if (a == 0xffffffffffffffff)
    5682:	07250763          	beq	a0,s2,56f0 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    5686:	6785                	lui	a5,0x1
    5688:	97aa                	add	a5,a5,a0
    568a:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x10b>
      if (write(fds[1], "x", 1) != 1)
    568e:	8626                	mv	a2,s1
    5690:	85ce                	mv	a1,s3
    5692:	fcc42503          	lw	a0,-52(s0)
    5696:	00000097          	auipc	ra,0x0
    569a:	530080e7          	jalr	1328(ra) # 5bc6 <write>
    569e:	fc950de3          	beq	a0,s1,5678 <countfree+0x44>
      {
        printf("write() failed in countfree()\n");
    56a2:	00003517          	auipc	a0,0x3
    56a6:	a2e50513          	addi	a0,a0,-1490 # 80d0 <malloc+0x210a>
    56aa:	00001097          	auipc	ra,0x1
    56ae:	864080e7          	jalr	-1948(ra) # 5f0e <printf>
        exit(1);
    56b2:	4505                	li	a0,1
    56b4:	00000097          	auipc	ra,0x0
    56b8:	4f2080e7          	jalr	1266(ra) # 5ba6 <exit>
    printf("pipe() failed in countfree()\n");
    56bc:	00003517          	auipc	a0,0x3
    56c0:	9d450513          	addi	a0,a0,-1580 # 8090 <malloc+0x20ca>
    56c4:	00001097          	auipc	ra,0x1
    56c8:	84a080e7          	jalr	-1974(ra) # 5f0e <printf>
    exit(1);
    56cc:	4505                	li	a0,1
    56ce:	00000097          	auipc	ra,0x0
    56d2:	4d8080e7          	jalr	1240(ra) # 5ba6 <exit>
    printf("fork failed in countfree()\n");
    56d6:	00003517          	auipc	a0,0x3
    56da:	9da50513          	addi	a0,a0,-1574 # 80b0 <malloc+0x20ea>
    56de:	00001097          	auipc	ra,0x1
    56e2:	830080e7          	jalr	-2000(ra) # 5f0e <printf>
    exit(1);
    56e6:	4505                	li	a0,1
    56e8:	00000097          	auipc	ra,0x0
    56ec:	4be080e7          	jalr	1214(ra) # 5ba6 <exit>
      }
    }

    exit(0);
    56f0:	4501                	li	a0,0
    56f2:	00000097          	auipc	ra,0x0
    56f6:	4b4080e7          	jalr	1204(ra) # 5ba6 <exit>
  }

  close(fds[1]);
    56fa:	fcc42503          	lw	a0,-52(s0)
    56fe:	00000097          	auipc	ra,0x0
    5702:	4d0080e7          	jalr	1232(ra) # 5bce <close>

  int n = 0;
    5706:	4481                	li	s1,0
  while (1)
  {
    char c;
    int cc = read(fds[0], &c, 1);
    5708:	4605                	li	a2,1
    570a:	fc740593          	addi	a1,s0,-57
    570e:	fc842503          	lw	a0,-56(s0)
    5712:	00000097          	auipc	ra,0x0
    5716:	4ac080e7          	jalr	1196(ra) # 5bbe <read>
    if (cc < 0)
    571a:	00054563          	bltz	a0,5724 <countfree+0xf0>
    {
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if (cc == 0)
    571e:	c105                	beqz	a0,573e <countfree+0x10a>
      break;
    n += 1;
    5720:	2485                	addiw	s1,s1,1
  {
    5722:	b7dd                	j	5708 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5724:	00003517          	auipc	a0,0x3
    5728:	9cc50513          	addi	a0,a0,-1588 # 80f0 <malloc+0x212a>
    572c:	00000097          	auipc	ra,0x0
    5730:	7e2080e7          	jalr	2018(ra) # 5f0e <printf>
      exit(1);
    5734:	4505                	li	a0,1
    5736:	00000097          	auipc	ra,0x0
    573a:	470080e7          	jalr	1136(ra) # 5ba6 <exit>
  }

  close(fds[0]);
    573e:	fc842503          	lw	a0,-56(s0)
    5742:	00000097          	auipc	ra,0x0
    5746:	48c080e7          	jalr	1164(ra) # 5bce <close>
  wait((int *)0);
    574a:	4501                	li	a0,0
    574c:	00000097          	auipc	ra,0x0
    5750:	462080e7          	jalr	1122(ra) # 5bae <wait>

  return n;
}
    5754:	8526                	mv	a0,s1
    5756:	70e2                	ld	ra,56(sp)
    5758:	7442                	ld	s0,48(sp)
    575a:	74a2                	ld	s1,40(sp)
    575c:	7902                	ld	s2,32(sp)
    575e:	69e2                	ld	s3,24(sp)
    5760:	6121                	addi	sp,sp,64
    5762:	8082                	ret

0000000000005764 <drivetests>:

int drivetests(int quick, int continuous, char *justone)
{
    5764:	711d                	addi	sp,sp,-96
    5766:	ec86                	sd	ra,88(sp)
    5768:	e8a2                	sd	s0,80(sp)
    576a:	e4a6                	sd	s1,72(sp)
    576c:	e0ca                	sd	s2,64(sp)
    576e:	fc4e                	sd	s3,56(sp)
    5770:	f852                	sd	s4,48(sp)
    5772:	f456                	sd	s5,40(sp)
    5774:	f05a                	sd	s6,32(sp)
    5776:	ec5e                	sd	s7,24(sp)
    5778:	e862                	sd	s8,16(sp)
    577a:	e466                	sd	s9,8(sp)
    577c:	e06a                	sd	s10,0(sp)
    577e:	1080                	addi	s0,sp,96
    5780:	8aaa                	mv	s5,a0
    5782:	89ae                	mv	s3,a1
    5784:	8932                	mv	s2,a2
  do
  {
    printf("usertests starting\n");
    5786:	00003b97          	auipc	s7,0x3
    578a:	98ab8b93          	addi	s7,s7,-1654 # 8110 <malloc+0x214a>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone))
    578e:	00004b17          	auipc	s6,0x4
    5792:	882b0b13          	addi	s6,s6,-1918 # 9010 <quicktests>
    {
      if (continuous != 2)
    5796:	4a09                	li	s4,2
    }
    if (!quick)
    {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone))
    5798:	00004c17          	auipc	s8,0x4
    579c:	c48c0c13          	addi	s8,s8,-952 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57a0:	00003d17          	auipc	s10,0x3
    57a4:	988d0d13          	addi	s10,s10,-1656 # 8128 <malloc+0x2162>
        }
      }
    }
    if ((free1 = countfree()) < free0)
    {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57a8:	00003c97          	auipc	s9,0x3
    57ac:	9a0c8c93          	addi	s9,s9,-1632 # 8148 <malloc+0x2182>
    57b0:	a839                	j	57ce <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    57b2:	856a                	mv	a0,s10
    57b4:	00000097          	auipc	ra,0x0
    57b8:	75a080e7          	jalr	1882(ra) # 5f0e <printf>
    57bc:	a081                	j	57fc <drivetests+0x98>
    if ((free1 = countfree()) < free0)
    57be:	00000097          	auipc	ra,0x0
    57c2:	e76080e7          	jalr	-394(ra) # 5634 <countfree>
    57c6:	04954663          	blt	a0,s1,5812 <drivetests+0xae>
      if (continuous != 2)
      {
        return 1;
      }
    }
  } while (continuous);
    57ca:	06098163          	beqz	s3,582c <drivetests+0xc8>
    printf("usertests starting\n");
    57ce:	855e                	mv	a0,s7
    57d0:	00000097          	auipc	ra,0x0
    57d4:	73e080e7          	jalr	1854(ra) # 5f0e <printf>
    int free0 = countfree();
    57d8:	00000097          	auipc	ra,0x0
    57dc:	e5c080e7          	jalr	-420(ra) # 5634 <countfree>
    57e0:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone))
    57e2:	85ca                	mv	a1,s2
    57e4:	855a                	mv	a0,s6
    57e6:	00000097          	auipc	ra,0x0
    57ea:	df2080e7          	jalr	-526(ra) # 55d8 <runtests>
    57ee:	c119                	beqz	a0,57f4 <drivetests+0x90>
      if (continuous != 2)
    57f0:	03499c63          	bne	s3,s4,5828 <drivetests+0xc4>
    if (!quick)
    57f4:	fc0a95e3          	bnez	s5,57be <drivetests+0x5a>
      if (justone == 0)
    57f8:	fa090de3          	beqz	s2,57b2 <drivetests+0x4e>
      if (runtests(slowtests, justone))
    57fc:	85ca                	mv	a1,s2
    57fe:	8562                	mv	a0,s8
    5800:	00000097          	auipc	ra,0x0
    5804:	dd8080e7          	jalr	-552(ra) # 55d8 <runtests>
    5808:	d95d                	beqz	a0,57be <drivetests+0x5a>
        if (continuous != 2)
    580a:	fb498ae3          	beq	s3,s4,57be <drivetests+0x5a>
          return 1;
    580e:	4505                	li	a0,1
    5810:	a839                	j	582e <drivetests+0xca>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5812:	8626                	mv	a2,s1
    5814:	85aa                	mv	a1,a0
    5816:	8566                	mv	a0,s9
    5818:	00000097          	auipc	ra,0x0
    581c:	6f6080e7          	jalr	1782(ra) # 5f0e <printf>
      if (continuous != 2)
    5820:	fb4987e3          	beq	s3,s4,57ce <drivetests+0x6a>
        return 1;
    5824:	4505                	li	a0,1
    5826:	a021                	j	582e <drivetests+0xca>
        return 1;
    5828:	4505                	li	a0,1
    582a:	a011                	j	582e <drivetests+0xca>
  return 0;
    582c:	854e                	mv	a0,s3
}
    582e:	60e6                	ld	ra,88(sp)
    5830:	6446                	ld	s0,80(sp)
    5832:	64a6                	ld	s1,72(sp)
    5834:	6906                	ld	s2,64(sp)
    5836:	79e2                	ld	s3,56(sp)
    5838:	7a42                	ld	s4,48(sp)
    583a:	7aa2                	ld	s5,40(sp)
    583c:	7b02                	ld	s6,32(sp)
    583e:	6be2                	ld	s7,24(sp)
    5840:	6c42                	ld	s8,16(sp)
    5842:	6ca2                	ld	s9,8(sp)
    5844:	6d02                	ld	s10,0(sp)
    5846:	6125                	addi	sp,sp,96
    5848:	8082                	ret

000000000000584a <main>:

int main(int argc, char *argv[])
{
    584a:	1101                	addi	sp,sp,-32
    584c:	ec06                	sd	ra,24(sp)
    584e:	e822                	sd	s0,16(sp)
    5850:	e426                	sd	s1,8(sp)
    5852:	e04a                	sd	s2,0(sp)
    5854:	1000                	addi	s0,sp,32
    5856:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0)
    5858:	4789                	li	a5,2
    585a:	02f50263          	beq	a0,a5,587e <main+0x34>
  }
  else if (argc == 2 && argv[1][0] != '-')
  {
    justone = argv[1];
  }
  else if (argc > 1)
    585e:	4785                	li	a5,1
    5860:	08a7c063          	blt	a5,a0,58e0 <main+0x96>
  char *justone = 0;
    5864:	4601                	li	a2,0
  int quick = 0;
    5866:	4501                	li	a0,0
  int continuous = 0;
    5868:	4581                	li	a1,0
  {
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone))
    586a:	00000097          	auipc	ra,0x0
    586e:	efa080e7          	jalr	-262(ra) # 5764 <drivetests>
    5872:	c951                	beqz	a0,5906 <main+0xbc>
  {
    exit(1);
    5874:	4505                	li	a0,1
    5876:	00000097          	auipc	ra,0x0
    587a:	330080e7          	jalr	816(ra) # 5ba6 <exit>
    587e:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0)
    5880:	00003597          	auipc	a1,0x3
    5884:	8f858593          	addi	a1,a1,-1800 # 8178 <malloc+0x21b2>
    5888:	00893503          	ld	a0,8(s2)
    588c:	00000097          	auipc	ra,0x0
    5890:	0ca080e7          	jalr	202(ra) # 5956 <strcmp>
    5894:	85aa                	mv	a1,a0
    5896:	e501                	bnez	a0,589e <main+0x54>
  char *justone = 0;
    5898:	4601                	li	a2,0
    quick = 1;
    589a:	4505                	li	a0,1
    589c:	b7f9                	j	586a <main+0x20>
  else if (argc == 2 && strcmp(argv[1], "-c") == 0)
    589e:	00003597          	auipc	a1,0x3
    58a2:	8e258593          	addi	a1,a1,-1822 # 8180 <malloc+0x21ba>
    58a6:	00893503          	ld	a0,8(s2)
    58aa:	00000097          	auipc	ra,0x0
    58ae:	0ac080e7          	jalr	172(ra) # 5956 <strcmp>
    58b2:	c521                	beqz	a0,58fa <main+0xb0>
  else if (argc == 2 && strcmp(argv[1], "-C") == 0)
    58b4:	00003597          	auipc	a1,0x3
    58b8:	91c58593          	addi	a1,a1,-1764 # 81d0 <malloc+0x220a>
    58bc:	00893503          	ld	a0,8(s2)
    58c0:	00000097          	auipc	ra,0x0
    58c4:	096080e7          	jalr	150(ra) # 5956 <strcmp>
    58c8:	cd05                	beqz	a0,5900 <main+0xb6>
  else if (argc == 2 && argv[1][0] != '-')
    58ca:	00893603          	ld	a2,8(s2)
    58ce:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x8e>
    58d2:	02d00793          	li	a5,45
    58d6:	00f70563          	beq	a4,a5,58e0 <main+0x96>
  int quick = 0;
    58da:	4501                	li	a0,0
  int continuous = 0;
    58dc:	4581                	li	a1,0
    58de:	b771                	j	586a <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58e0:	00003517          	auipc	a0,0x3
    58e4:	8a850513          	addi	a0,a0,-1880 # 8188 <malloc+0x21c2>
    58e8:	00000097          	auipc	ra,0x0
    58ec:	626080e7          	jalr	1574(ra) # 5f0e <printf>
    exit(1);
    58f0:	4505                	li	a0,1
    58f2:	00000097          	auipc	ra,0x0
    58f6:	2b4080e7          	jalr	692(ra) # 5ba6 <exit>
  char *justone = 0;
    58fa:	4601                	li	a2,0
    continuous = 1;
    58fc:	4585                	li	a1,1
    58fe:	b7b5                	j	586a <main+0x20>
    continuous = 2;
    5900:	85a6                	mv	a1,s1
  char *justone = 0;
    5902:	4601                	li	a2,0
    5904:	b79d                	j	586a <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5906:	00003517          	auipc	a0,0x3
    590a:	8b250513          	addi	a0,a0,-1870 # 81b8 <malloc+0x21f2>
    590e:	00000097          	auipc	ra,0x0
    5912:	600080e7          	jalr	1536(ra) # 5f0e <printf>
  exit(0);
    5916:	4501                	li	a0,0
    5918:	00000097          	auipc	ra,0x0
    591c:	28e080e7          	jalr	654(ra) # 5ba6 <exit>

0000000000005920 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5920:	1141                	addi	sp,sp,-16
    5922:	e406                	sd	ra,8(sp)
    5924:	e022                	sd	s0,0(sp)
    5926:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5928:	00000097          	auipc	ra,0x0
    592c:	f22080e7          	jalr	-222(ra) # 584a <main>
  exit(0);
    5930:	4501                	li	a0,0
    5932:	00000097          	auipc	ra,0x0
    5936:	274080e7          	jalr	628(ra) # 5ba6 <exit>

000000000000593a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    593a:	1141                	addi	sp,sp,-16
    593c:	e422                	sd	s0,8(sp)
    593e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5940:	87aa                	mv	a5,a0
    5942:	0585                	addi	a1,a1,1
    5944:	0785                	addi	a5,a5,1
    5946:	fff5c703          	lbu	a4,-1(a1)
    594a:	fee78fa3          	sb	a4,-1(a5)
    594e:	fb75                	bnez	a4,5942 <strcpy+0x8>
    ;
  return os;
}
    5950:	6422                	ld	s0,8(sp)
    5952:	0141                	addi	sp,sp,16
    5954:	8082                	ret

0000000000005956 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5956:	1141                	addi	sp,sp,-16
    5958:	e422                	sd	s0,8(sp)
    595a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    595c:	00054783          	lbu	a5,0(a0)
    5960:	cb91                	beqz	a5,5974 <strcmp+0x1e>
    5962:	0005c703          	lbu	a4,0(a1)
    5966:	00f71763          	bne	a4,a5,5974 <strcmp+0x1e>
    p++, q++;
    596a:	0505                	addi	a0,a0,1
    596c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    596e:	00054783          	lbu	a5,0(a0)
    5972:	fbe5                	bnez	a5,5962 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5974:	0005c503          	lbu	a0,0(a1)
}
    5978:	40a7853b          	subw	a0,a5,a0
    597c:	6422                	ld	s0,8(sp)
    597e:	0141                	addi	sp,sp,16
    5980:	8082                	ret

0000000000005982 <strlen>:

uint
strlen(const char *s)
{
    5982:	1141                	addi	sp,sp,-16
    5984:	e422                	sd	s0,8(sp)
    5986:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5988:	00054783          	lbu	a5,0(a0)
    598c:	cf91                	beqz	a5,59a8 <strlen+0x26>
    598e:	0505                	addi	a0,a0,1
    5990:	87aa                	mv	a5,a0
    5992:	86be                	mv	a3,a5
    5994:	0785                	addi	a5,a5,1
    5996:	fff7c703          	lbu	a4,-1(a5)
    599a:	ff65                	bnez	a4,5992 <strlen+0x10>
    599c:	40a6853b          	subw	a0,a3,a0
    59a0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    59a2:	6422                	ld	s0,8(sp)
    59a4:	0141                	addi	sp,sp,16
    59a6:	8082                	ret
  for(n = 0; s[n]; n++)
    59a8:	4501                	li	a0,0
    59aa:	bfe5                	j	59a2 <strlen+0x20>

00000000000059ac <memset>:

void*
memset(void *dst, int c, uint n)
{
    59ac:	1141                	addi	sp,sp,-16
    59ae:	e422                	sd	s0,8(sp)
    59b0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59b2:	ca19                	beqz	a2,59c8 <memset+0x1c>
    59b4:	87aa                	mv	a5,a0
    59b6:	1602                	slli	a2,a2,0x20
    59b8:	9201                	srli	a2,a2,0x20
    59ba:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59be:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59c2:	0785                	addi	a5,a5,1
    59c4:	fee79de3          	bne	a5,a4,59be <memset+0x12>
  }
  return dst;
}
    59c8:	6422                	ld	s0,8(sp)
    59ca:	0141                	addi	sp,sp,16
    59cc:	8082                	ret

00000000000059ce <strchr>:

char*
strchr(const char *s, char c)
{
    59ce:	1141                	addi	sp,sp,-16
    59d0:	e422                	sd	s0,8(sp)
    59d2:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59d4:	00054783          	lbu	a5,0(a0)
    59d8:	cb99                	beqz	a5,59ee <strchr+0x20>
    if(*s == c)
    59da:	00f58763          	beq	a1,a5,59e8 <strchr+0x1a>
  for(; *s; s++)
    59de:	0505                	addi	a0,a0,1
    59e0:	00054783          	lbu	a5,0(a0)
    59e4:	fbfd                	bnez	a5,59da <strchr+0xc>
      return (char*)s;
  return 0;
    59e6:	4501                	li	a0,0
}
    59e8:	6422                	ld	s0,8(sp)
    59ea:	0141                	addi	sp,sp,16
    59ec:	8082                	ret
  return 0;
    59ee:	4501                	li	a0,0
    59f0:	bfe5                	j	59e8 <strchr+0x1a>

00000000000059f2 <gets>:

char*
gets(char *buf, int max)
{
    59f2:	711d                	addi	sp,sp,-96
    59f4:	ec86                	sd	ra,88(sp)
    59f6:	e8a2                	sd	s0,80(sp)
    59f8:	e4a6                	sd	s1,72(sp)
    59fa:	e0ca                	sd	s2,64(sp)
    59fc:	fc4e                	sd	s3,56(sp)
    59fe:	f852                	sd	s4,48(sp)
    5a00:	f456                	sd	s5,40(sp)
    5a02:	f05a                	sd	s6,32(sp)
    5a04:	ec5e                	sd	s7,24(sp)
    5a06:	1080                	addi	s0,sp,96
    5a08:	8baa                	mv	s7,a0
    5a0a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a0c:	892a                	mv	s2,a0
    5a0e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a10:	4aa9                	li	s5,10
    5a12:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a14:	89a6                	mv	s3,s1
    5a16:	2485                	addiw	s1,s1,1
    5a18:	0344d863          	bge	s1,s4,5a48 <gets+0x56>
    cc = read(0, &c, 1);
    5a1c:	4605                	li	a2,1
    5a1e:	faf40593          	addi	a1,s0,-81
    5a22:	4501                	li	a0,0
    5a24:	00000097          	auipc	ra,0x0
    5a28:	19a080e7          	jalr	410(ra) # 5bbe <read>
    if(cc < 1)
    5a2c:	00a05e63          	blez	a0,5a48 <gets+0x56>
    buf[i++] = c;
    5a30:	faf44783          	lbu	a5,-81(s0)
    5a34:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a38:	01578763          	beq	a5,s5,5a46 <gets+0x54>
    5a3c:	0905                	addi	s2,s2,1
    5a3e:	fd679be3          	bne	a5,s6,5a14 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a42:	89a6                	mv	s3,s1
    5a44:	a011                	j	5a48 <gets+0x56>
    5a46:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a48:	99de                	add	s3,s3,s7
    5a4a:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a4e:	855e                	mv	a0,s7
    5a50:	60e6                	ld	ra,88(sp)
    5a52:	6446                	ld	s0,80(sp)
    5a54:	64a6                	ld	s1,72(sp)
    5a56:	6906                	ld	s2,64(sp)
    5a58:	79e2                	ld	s3,56(sp)
    5a5a:	7a42                	ld	s4,48(sp)
    5a5c:	7aa2                	ld	s5,40(sp)
    5a5e:	7b02                	ld	s6,32(sp)
    5a60:	6be2                	ld	s7,24(sp)
    5a62:	6125                	addi	sp,sp,96
    5a64:	8082                	ret

0000000000005a66 <stat>:

int
stat(const char *n, struct stat *st)
{
    5a66:	1101                	addi	sp,sp,-32
    5a68:	ec06                	sd	ra,24(sp)
    5a6a:	e822                	sd	s0,16(sp)
    5a6c:	e426                	sd	s1,8(sp)
    5a6e:	e04a                	sd	s2,0(sp)
    5a70:	1000                	addi	s0,sp,32
    5a72:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a74:	4581                	li	a1,0
    5a76:	00000097          	auipc	ra,0x0
    5a7a:	170080e7          	jalr	368(ra) # 5be6 <open>
  if(fd < 0)
    5a7e:	02054563          	bltz	a0,5aa8 <stat+0x42>
    5a82:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5a84:	85ca                	mv	a1,s2
    5a86:	00000097          	auipc	ra,0x0
    5a8a:	178080e7          	jalr	376(ra) # 5bfe <fstat>
    5a8e:	892a                	mv	s2,a0
  close(fd);
    5a90:	8526                	mv	a0,s1
    5a92:	00000097          	auipc	ra,0x0
    5a96:	13c080e7          	jalr	316(ra) # 5bce <close>
  return r;
}
    5a9a:	854a                	mv	a0,s2
    5a9c:	60e2                	ld	ra,24(sp)
    5a9e:	6442                	ld	s0,16(sp)
    5aa0:	64a2                	ld	s1,8(sp)
    5aa2:	6902                	ld	s2,0(sp)
    5aa4:	6105                	addi	sp,sp,32
    5aa6:	8082                	ret
    return -1;
    5aa8:	597d                	li	s2,-1
    5aaa:	bfc5                	j	5a9a <stat+0x34>

0000000000005aac <atoi>:

int
atoi(const char *s)
{
    5aac:	1141                	addi	sp,sp,-16
    5aae:	e422                	sd	s0,8(sp)
    5ab0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5ab2:	00054683          	lbu	a3,0(a0)
    5ab6:	fd06879b          	addiw	a5,a3,-48
    5aba:	0ff7f793          	zext.b	a5,a5
    5abe:	4625                	li	a2,9
    5ac0:	02f66863          	bltu	a2,a5,5af0 <atoi+0x44>
    5ac4:	872a                	mv	a4,a0
  n = 0;
    5ac6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5ac8:	0705                	addi	a4,a4,1
    5aca:	0025179b          	slliw	a5,a0,0x2
    5ace:	9fa9                	addw	a5,a5,a0
    5ad0:	0017979b          	slliw	a5,a5,0x1
    5ad4:	9fb5                	addw	a5,a5,a3
    5ad6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5ada:	00074683          	lbu	a3,0(a4)
    5ade:	fd06879b          	addiw	a5,a3,-48
    5ae2:	0ff7f793          	zext.b	a5,a5
    5ae6:	fef671e3          	bgeu	a2,a5,5ac8 <atoi+0x1c>
  return n;
}
    5aea:	6422                	ld	s0,8(sp)
    5aec:	0141                	addi	sp,sp,16
    5aee:	8082                	ret
  n = 0;
    5af0:	4501                	li	a0,0
    5af2:	bfe5                	j	5aea <atoi+0x3e>

0000000000005af4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5af4:	1141                	addi	sp,sp,-16
    5af6:	e422                	sd	s0,8(sp)
    5af8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5afa:	02b57463          	bgeu	a0,a1,5b22 <memmove+0x2e>
    while(n-- > 0)
    5afe:	00c05f63          	blez	a2,5b1c <memmove+0x28>
    5b02:	1602                	slli	a2,a2,0x20
    5b04:	9201                	srli	a2,a2,0x20
    5b06:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b0a:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b0c:	0585                	addi	a1,a1,1
    5b0e:	0705                	addi	a4,a4,1
    5b10:	fff5c683          	lbu	a3,-1(a1)
    5b14:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b18:	fee79ae3          	bne	a5,a4,5b0c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b1c:	6422                	ld	s0,8(sp)
    5b1e:	0141                	addi	sp,sp,16
    5b20:	8082                	ret
    dst += n;
    5b22:	00c50733          	add	a4,a0,a2
    src += n;
    5b26:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b28:	fec05ae3          	blez	a2,5b1c <memmove+0x28>
    5b2c:	fff6079b          	addiw	a5,a2,-1
    5b30:	1782                	slli	a5,a5,0x20
    5b32:	9381                	srli	a5,a5,0x20
    5b34:	fff7c793          	not	a5,a5
    5b38:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b3a:	15fd                	addi	a1,a1,-1
    5b3c:	177d                	addi	a4,a4,-1
    5b3e:	0005c683          	lbu	a3,0(a1)
    5b42:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b46:	fee79ae3          	bne	a5,a4,5b3a <memmove+0x46>
    5b4a:	bfc9                	j	5b1c <memmove+0x28>

0000000000005b4c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b4c:	1141                	addi	sp,sp,-16
    5b4e:	e422                	sd	s0,8(sp)
    5b50:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b52:	ca05                	beqz	a2,5b82 <memcmp+0x36>
    5b54:	fff6069b          	addiw	a3,a2,-1
    5b58:	1682                	slli	a3,a3,0x20
    5b5a:	9281                	srli	a3,a3,0x20
    5b5c:	0685                	addi	a3,a3,1
    5b5e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b60:	00054783          	lbu	a5,0(a0)
    5b64:	0005c703          	lbu	a4,0(a1)
    5b68:	00e79863          	bne	a5,a4,5b78 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b6c:	0505                	addi	a0,a0,1
    p2++;
    5b6e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b70:	fed518e3          	bne	a0,a3,5b60 <memcmp+0x14>
  }
  return 0;
    5b74:	4501                	li	a0,0
    5b76:	a019                	j	5b7c <memcmp+0x30>
      return *p1 - *p2;
    5b78:	40e7853b          	subw	a0,a5,a4
}
    5b7c:	6422                	ld	s0,8(sp)
    5b7e:	0141                	addi	sp,sp,16
    5b80:	8082                	ret
  return 0;
    5b82:	4501                	li	a0,0
    5b84:	bfe5                	j	5b7c <memcmp+0x30>

0000000000005b86 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5b86:	1141                	addi	sp,sp,-16
    5b88:	e406                	sd	ra,8(sp)
    5b8a:	e022                	sd	s0,0(sp)
    5b8c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5b8e:	00000097          	auipc	ra,0x0
    5b92:	f66080e7          	jalr	-154(ra) # 5af4 <memmove>
}
    5b96:	60a2                	ld	ra,8(sp)
    5b98:	6402                	ld	s0,0(sp)
    5b9a:	0141                	addi	sp,sp,16
    5b9c:	8082                	ret

0000000000005b9e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5b9e:	4885                	li	a7,1
 ecall
    5ba0:	00000073          	ecall
 ret
    5ba4:	8082                	ret

0000000000005ba6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5ba6:	4889                	li	a7,2
 ecall
    5ba8:	00000073          	ecall
 ret
    5bac:	8082                	ret

0000000000005bae <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bae:	488d                	li	a7,3
 ecall
    5bb0:	00000073          	ecall
 ret
    5bb4:	8082                	ret

0000000000005bb6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5bb6:	4891                	li	a7,4
 ecall
    5bb8:	00000073          	ecall
 ret
    5bbc:	8082                	ret

0000000000005bbe <read>:
.global read
read:
 li a7, SYS_read
    5bbe:	4895                	li	a7,5
 ecall
    5bc0:	00000073          	ecall
 ret
    5bc4:	8082                	ret

0000000000005bc6 <write>:
.global write
write:
 li a7, SYS_write
    5bc6:	48c1                	li	a7,16
 ecall
    5bc8:	00000073          	ecall
 ret
    5bcc:	8082                	ret

0000000000005bce <close>:
.global close
close:
 li a7, SYS_close
    5bce:	48d5                	li	a7,21
 ecall
    5bd0:	00000073          	ecall
 ret
    5bd4:	8082                	ret

0000000000005bd6 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bd6:	4899                	li	a7,6
 ecall
    5bd8:	00000073          	ecall
 ret
    5bdc:	8082                	ret

0000000000005bde <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bde:	489d                	li	a7,7
 ecall
    5be0:	00000073          	ecall
 ret
    5be4:	8082                	ret

0000000000005be6 <open>:
.global open
open:
 li a7, SYS_open
    5be6:	48bd                	li	a7,15
 ecall
    5be8:	00000073          	ecall
 ret
    5bec:	8082                	ret

0000000000005bee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5bee:	48c5                	li	a7,17
 ecall
    5bf0:	00000073          	ecall
 ret
    5bf4:	8082                	ret

0000000000005bf6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5bf6:	48c9                	li	a7,18
 ecall
    5bf8:	00000073          	ecall
 ret
    5bfc:	8082                	ret

0000000000005bfe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5bfe:	48a1                	li	a7,8
 ecall
    5c00:	00000073          	ecall
 ret
    5c04:	8082                	ret

0000000000005c06 <link>:
.global link
link:
 li a7, SYS_link
    5c06:	48cd                	li	a7,19
 ecall
    5c08:	00000073          	ecall
 ret
    5c0c:	8082                	ret

0000000000005c0e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c0e:	48d1                	li	a7,20
 ecall
    5c10:	00000073          	ecall
 ret
    5c14:	8082                	ret

0000000000005c16 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c16:	48a5                	li	a7,9
 ecall
    5c18:	00000073          	ecall
 ret
    5c1c:	8082                	ret

0000000000005c1e <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c1e:	48a9                	li	a7,10
 ecall
    5c20:	00000073          	ecall
 ret
    5c24:	8082                	ret

0000000000005c26 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c26:	48ad                	li	a7,11
 ecall
    5c28:	00000073          	ecall
 ret
    5c2c:	8082                	ret

0000000000005c2e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c2e:	48b1                	li	a7,12
 ecall
    5c30:	00000073          	ecall
 ret
    5c34:	8082                	ret

0000000000005c36 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c36:	48b5                	li	a7,13
 ecall
    5c38:	00000073          	ecall
 ret
    5c3c:	8082                	ret

0000000000005c3e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c3e:	48b9                	li	a7,14
 ecall
    5c40:	00000073          	ecall
 ret
    5c44:	8082                	ret

0000000000005c46 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c46:	1101                	addi	sp,sp,-32
    5c48:	ec06                	sd	ra,24(sp)
    5c4a:	e822                	sd	s0,16(sp)
    5c4c:	1000                	addi	s0,sp,32
    5c4e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c52:	4605                	li	a2,1
    5c54:	fef40593          	addi	a1,s0,-17
    5c58:	00000097          	auipc	ra,0x0
    5c5c:	f6e080e7          	jalr	-146(ra) # 5bc6 <write>
}
    5c60:	60e2                	ld	ra,24(sp)
    5c62:	6442                	ld	s0,16(sp)
    5c64:	6105                	addi	sp,sp,32
    5c66:	8082                	ret

0000000000005c68 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c68:	7139                	addi	sp,sp,-64
    5c6a:	fc06                	sd	ra,56(sp)
    5c6c:	f822                	sd	s0,48(sp)
    5c6e:	f426                	sd	s1,40(sp)
    5c70:	f04a                	sd	s2,32(sp)
    5c72:	ec4e                	sd	s3,24(sp)
    5c74:	0080                	addi	s0,sp,64
    5c76:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5c78:	c299                	beqz	a3,5c7e <printint+0x16>
    5c7a:	0805c963          	bltz	a1,5d0c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5c7e:	2581                	sext.w	a1,a1
  neg = 0;
    5c80:	4881                	li	a7,0
    5c82:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5c86:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5c88:	2601                	sext.w	a2,a2
    5c8a:	00003517          	auipc	a0,0x3
    5c8e:	90e50513          	addi	a0,a0,-1778 # 8598 <digits>
    5c92:	883a                	mv	a6,a4
    5c94:	2705                	addiw	a4,a4,1
    5c96:	02c5f7bb          	remuw	a5,a1,a2
    5c9a:	1782                	slli	a5,a5,0x20
    5c9c:	9381                	srli	a5,a5,0x20
    5c9e:	97aa                	add	a5,a5,a0
    5ca0:	0007c783          	lbu	a5,0(a5)
    5ca4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5ca8:	0005879b          	sext.w	a5,a1
    5cac:	02c5d5bb          	divuw	a1,a1,a2
    5cb0:	0685                	addi	a3,a3,1
    5cb2:	fec7f0e3          	bgeu	a5,a2,5c92 <printint+0x2a>
  if(neg)
    5cb6:	00088c63          	beqz	a7,5cce <printint+0x66>
    buf[i++] = '-';
    5cba:	fd070793          	addi	a5,a4,-48
    5cbe:	00878733          	add	a4,a5,s0
    5cc2:	02d00793          	li	a5,45
    5cc6:	fef70823          	sb	a5,-16(a4)
    5cca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5cce:	02e05863          	blez	a4,5cfe <printint+0x96>
    5cd2:	fc040793          	addi	a5,s0,-64
    5cd6:	00e78933          	add	s2,a5,a4
    5cda:	fff78993          	addi	s3,a5,-1
    5cde:	99ba                	add	s3,s3,a4
    5ce0:	377d                	addiw	a4,a4,-1
    5ce2:	1702                	slli	a4,a4,0x20
    5ce4:	9301                	srli	a4,a4,0x20
    5ce6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5cea:	fff94583          	lbu	a1,-1(s2)
    5cee:	8526                	mv	a0,s1
    5cf0:	00000097          	auipc	ra,0x0
    5cf4:	f56080e7          	jalr	-170(ra) # 5c46 <putc>
  while(--i >= 0)
    5cf8:	197d                	addi	s2,s2,-1
    5cfa:	ff3918e3          	bne	s2,s3,5cea <printint+0x82>
}
    5cfe:	70e2                	ld	ra,56(sp)
    5d00:	7442                	ld	s0,48(sp)
    5d02:	74a2                	ld	s1,40(sp)
    5d04:	7902                	ld	s2,32(sp)
    5d06:	69e2                	ld	s3,24(sp)
    5d08:	6121                	addi	sp,sp,64
    5d0a:	8082                	ret
    x = -xx;
    5d0c:	40b005bb          	negw	a1,a1
    neg = 1;
    5d10:	4885                	li	a7,1
    x = -xx;
    5d12:	bf85                	j	5c82 <printint+0x1a>

0000000000005d14 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d14:	715d                	addi	sp,sp,-80
    5d16:	e486                	sd	ra,72(sp)
    5d18:	e0a2                	sd	s0,64(sp)
    5d1a:	fc26                	sd	s1,56(sp)
    5d1c:	f84a                	sd	s2,48(sp)
    5d1e:	f44e                	sd	s3,40(sp)
    5d20:	f052                	sd	s4,32(sp)
    5d22:	ec56                	sd	s5,24(sp)
    5d24:	e85a                	sd	s6,16(sp)
    5d26:	e45e                	sd	s7,8(sp)
    5d28:	e062                	sd	s8,0(sp)
    5d2a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d2c:	0005c903          	lbu	s2,0(a1)
    5d30:	18090c63          	beqz	s2,5ec8 <vprintf+0x1b4>
    5d34:	8aaa                	mv	s5,a0
    5d36:	8bb2                	mv	s7,a2
    5d38:	00158493          	addi	s1,a1,1
  state = 0;
    5d3c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d3e:	02500a13          	li	s4,37
    5d42:	4b55                	li	s6,21
    5d44:	a839                	j	5d62 <vprintf+0x4e>
        putc(fd, c);
    5d46:	85ca                	mv	a1,s2
    5d48:	8556                	mv	a0,s5
    5d4a:	00000097          	auipc	ra,0x0
    5d4e:	efc080e7          	jalr	-260(ra) # 5c46 <putc>
    5d52:	a019                	j	5d58 <vprintf+0x44>
    } else if(state == '%'){
    5d54:	01498d63          	beq	s3,s4,5d6e <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    5d58:	0485                	addi	s1,s1,1
    5d5a:	fff4c903          	lbu	s2,-1(s1)
    5d5e:	16090563          	beqz	s2,5ec8 <vprintf+0x1b4>
    if(state == 0){
    5d62:	fe0999e3          	bnez	s3,5d54 <vprintf+0x40>
      if(c == '%'){
    5d66:	ff4910e3          	bne	s2,s4,5d46 <vprintf+0x32>
        state = '%';
    5d6a:	89d2                	mv	s3,s4
    5d6c:	b7f5                	j	5d58 <vprintf+0x44>
      if(c == 'd'){
    5d6e:	13490263          	beq	s2,s4,5e92 <vprintf+0x17e>
    5d72:	f9d9079b          	addiw	a5,s2,-99
    5d76:	0ff7f793          	zext.b	a5,a5
    5d7a:	12fb6563          	bltu	s6,a5,5ea4 <vprintf+0x190>
    5d7e:	f9d9079b          	addiw	a5,s2,-99
    5d82:	0ff7f713          	zext.b	a4,a5
    5d86:	10eb6f63          	bltu	s6,a4,5ea4 <vprintf+0x190>
    5d8a:	00271793          	slli	a5,a4,0x2
    5d8e:	00002717          	auipc	a4,0x2
    5d92:	7b270713          	addi	a4,a4,1970 # 8540 <malloc+0x257a>
    5d96:	97ba                	add	a5,a5,a4
    5d98:	439c                	lw	a5,0(a5)
    5d9a:	97ba                	add	a5,a5,a4
    5d9c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5d9e:	008b8913          	addi	s2,s7,8
    5da2:	4685                	li	a3,1
    5da4:	4629                	li	a2,10
    5da6:	000ba583          	lw	a1,0(s7)
    5daa:	8556                	mv	a0,s5
    5dac:	00000097          	auipc	ra,0x0
    5db0:	ebc080e7          	jalr	-324(ra) # 5c68 <printint>
    5db4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5db6:	4981                	li	s3,0
    5db8:	b745                	j	5d58 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5dba:	008b8913          	addi	s2,s7,8
    5dbe:	4681                	li	a3,0
    5dc0:	4629                	li	a2,10
    5dc2:	000ba583          	lw	a1,0(s7)
    5dc6:	8556                	mv	a0,s5
    5dc8:	00000097          	auipc	ra,0x0
    5dcc:	ea0080e7          	jalr	-352(ra) # 5c68 <printint>
    5dd0:	8bca                	mv	s7,s2
      state = 0;
    5dd2:	4981                	li	s3,0
    5dd4:	b751                	j	5d58 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    5dd6:	008b8913          	addi	s2,s7,8
    5dda:	4681                	li	a3,0
    5ddc:	4641                	li	a2,16
    5dde:	000ba583          	lw	a1,0(s7)
    5de2:	8556                	mv	a0,s5
    5de4:	00000097          	auipc	ra,0x0
    5de8:	e84080e7          	jalr	-380(ra) # 5c68 <printint>
    5dec:	8bca                	mv	s7,s2
      state = 0;
    5dee:	4981                	li	s3,0
    5df0:	b7a5                	j	5d58 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    5df2:	008b8c13          	addi	s8,s7,8
    5df6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5dfa:	03000593          	li	a1,48
    5dfe:	8556                	mv	a0,s5
    5e00:	00000097          	auipc	ra,0x0
    5e04:	e46080e7          	jalr	-442(ra) # 5c46 <putc>
  putc(fd, 'x');
    5e08:	07800593          	li	a1,120
    5e0c:	8556                	mv	a0,s5
    5e0e:	00000097          	auipc	ra,0x0
    5e12:	e38080e7          	jalr	-456(ra) # 5c46 <putc>
    5e16:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e18:	00002b97          	auipc	s7,0x2
    5e1c:	780b8b93          	addi	s7,s7,1920 # 8598 <digits>
    5e20:	03c9d793          	srli	a5,s3,0x3c
    5e24:	97de                	add	a5,a5,s7
    5e26:	0007c583          	lbu	a1,0(a5)
    5e2a:	8556                	mv	a0,s5
    5e2c:	00000097          	auipc	ra,0x0
    5e30:	e1a080e7          	jalr	-486(ra) # 5c46 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e34:	0992                	slli	s3,s3,0x4
    5e36:	397d                	addiw	s2,s2,-1
    5e38:	fe0914e3          	bnez	s2,5e20 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5e3c:	8be2                	mv	s7,s8
      state = 0;
    5e3e:	4981                	li	s3,0
    5e40:	bf21                	j	5d58 <vprintf+0x44>
        s = va_arg(ap, char*);
    5e42:	008b8993          	addi	s3,s7,8
    5e46:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5e4a:	02090163          	beqz	s2,5e6c <vprintf+0x158>
        while(*s != 0){
    5e4e:	00094583          	lbu	a1,0(s2)
    5e52:	c9a5                	beqz	a1,5ec2 <vprintf+0x1ae>
          putc(fd, *s);
    5e54:	8556                	mv	a0,s5
    5e56:	00000097          	auipc	ra,0x0
    5e5a:	df0080e7          	jalr	-528(ra) # 5c46 <putc>
          s++;
    5e5e:	0905                	addi	s2,s2,1
        while(*s != 0){
    5e60:	00094583          	lbu	a1,0(s2)
    5e64:	f9e5                	bnez	a1,5e54 <vprintf+0x140>
        s = va_arg(ap, char*);
    5e66:	8bce                	mv	s7,s3
      state = 0;
    5e68:	4981                	li	s3,0
    5e6a:	b5fd                	j	5d58 <vprintf+0x44>
          s = "(null)";
    5e6c:	00002917          	auipc	s2,0x2
    5e70:	6cc90913          	addi	s2,s2,1740 # 8538 <malloc+0x2572>
        while(*s != 0){
    5e74:	02800593          	li	a1,40
    5e78:	bff1                	j	5e54 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    5e7a:	008b8913          	addi	s2,s7,8
    5e7e:	000bc583          	lbu	a1,0(s7)
    5e82:	8556                	mv	a0,s5
    5e84:	00000097          	auipc	ra,0x0
    5e88:	dc2080e7          	jalr	-574(ra) # 5c46 <putc>
    5e8c:	8bca                	mv	s7,s2
      state = 0;
    5e8e:	4981                	li	s3,0
    5e90:	b5e1                	j	5d58 <vprintf+0x44>
        putc(fd, c);
    5e92:	02500593          	li	a1,37
    5e96:	8556                	mv	a0,s5
    5e98:	00000097          	auipc	ra,0x0
    5e9c:	dae080e7          	jalr	-594(ra) # 5c46 <putc>
      state = 0;
    5ea0:	4981                	li	s3,0
    5ea2:	bd5d                	j	5d58 <vprintf+0x44>
        putc(fd, '%');
    5ea4:	02500593          	li	a1,37
    5ea8:	8556                	mv	a0,s5
    5eaa:	00000097          	auipc	ra,0x0
    5eae:	d9c080e7          	jalr	-612(ra) # 5c46 <putc>
        putc(fd, c);
    5eb2:	85ca                	mv	a1,s2
    5eb4:	8556                	mv	a0,s5
    5eb6:	00000097          	auipc	ra,0x0
    5eba:	d90080e7          	jalr	-624(ra) # 5c46 <putc>
      state = 0;
    5ebe:	4981                	li	s3,0
    5ec0:	bd61                	j	5d58 <vprintf+0x44>
        s = va_arg(ap, char*);
    5ec2:	8bce                	mv	s7,s3
      state = 0;
    5ec4:	4981                	li	s3,0
    5ec6:	bd49                	j	5d58 <vprintf+0x44>
    }
  }
}
    5ec8:	60a6                	ld	ra,72(sp)
    5eca:	6406                	ld	s0,64(sp)
    5ecc:	74e2                	ld	s1,56(sp)
    5ece:	7942                	ld	s2,48(sp)
    5ed0:	79a2                	ld	s3,40(sp)
    5ed2:	7a02                	ld	s4,32(sp)
    5ed4:	6ae2                	ld	s5,24(sp)
    5ed6:	6b42                	ld	s6,16(sp)
    5ed8:	6ba2                	ld	s7,8(sp)
    5eda:	6c02                	ld	s8,0(sp)
    5edc:	6161                	addi	sp,sp,80
    5ede:	8082                	ret

0000000000005ee0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5ee0:	715d                	addi	sp,sp,-80
    5ee2:	ec06                	sd	ra,24(sp)
    5ee4:	e822                	sd	s0,16(sp)
    5ee6:	1000                	addi	s0,sp,32
    5ee8:	e010                	sd	a2,0(s0)
    5eea:	e414                	sd	a3,8(s0)
    5eec:	e818                	sd	a4,16(s0)
    5eee:	ec1c                	sd	a5,24(s0)
    5ef0:	03043023          	sd	a6,32(s0)
    5ef4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5ef8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5efc:	8622                	mv	a2,s0
    5efe:	00000097          	auipc	ra,0x0
    5f02:	e16080e7          	jalr	-490(ra) # 5d14 <vprintf>
}
    5f06:	60e2                	ld	ra,24(sp)
    5f08:	6442                	ld	s0,16(sp)
    5f0a:	6161                	addi	sp,sp,80
    5f0c:	8082                	ret

0000000000005f0e <printf>:

void
printf(const char *fmt, ...)
{
    5f0e:	711d                	addi	sp,sp,-96
    5f10:	ec06                	sd	ra,24(sp)
    5f12:	e822                	sd	s0,16(sp)
    5f14:	1000                	addi	s0,sp,32
    5f16:	e40c                	sd	a1,8(s0)
    5f18:	e810                	sd	a2,16(s0)
    5f1a:	ec14                	sd	a3,24(s0)
    5f1c:	f018                	sd	a4,32(s0)
    5f1e:	f41c                	sd	a5,40(s0)
    5f20:	03043823          	sd	a6,48(s0)
    5f24:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f28:	00840613          	addi	a2,s0,8
    5f2c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f30:	85aa                	mv	a1,a0
    5f32:	4505                	li	a0,1
    5f34:	00000097          	auipc	ra,0x0
    5f38:	de0080e7          	jalr	-544(ra) # 5d14 <vprintf>
}
    5f3c:	60e2                	ld	ra,24(sp)
    5f3e:	6442                	ld	s0,16(sp)
    5f40:	6125                	addi	sp,sp,96
    5f42:	8082                	ret

0000000000005f44 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f44:	1141                	addi	sp,sp,-16
    5f46:	e422                	sd	s0,8(sp)
    5f48:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f4a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f4e:	00003797          	auipc	a5,0x3
    5f52:	5027b783          	ld	a5,1282(a5) # 9450 <freep>
    5f56:	a02d                	j	5f80 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f58:	4618                	lw	a4,8(a2)
    5f5a:	9f2d                	addw	a4,a4,a1
    5f5c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5f60:	6398                	ld	a4,0(a5)
    5f62:	6310                	ld	a2,0(a4)
    5f64:	a83d                	j	5fa2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5f66:	ff852703          	lw	a4,-8(a0)
    5f6a:	9f31                	addw	a4,a4,a2
    5f6c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5f6e:	ff053683          	ld	a3,-16(a0)
    5f72:	a091                	j	5fb6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f74:	6398                	ld	a4,0(a5)
    5f76:	00e7e463          	bltu	a5,a4,5f7e <free+0x3a>
    5f7a:	00e6ea63          	bltu	a3,a4,5f8e <free+0x4a>
{
    5f7e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f80:	fed7fae3          	bgeu	a5,a3,5f74 <free+0x30>
    5f84:	6398                	ld	a4,0(a5)
    5f86:	00e6e463          	bltu	a3,a4,5f8e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f8a:	fee7eae3          	bltu	a5,a4,5f7e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5f8e:	ff852583          	lw	a1,-8(a0)
    5f92:	6390                	ld	a2,0(a5)
    5f94:	02059813          	slli	a6,a1,0x20
    5f98:	01c85713          	srli	a4,a6,0x1c
    5f9c:	9736                	add	a4,a4,a3
    5f9e:	fae60de3          	beq	a2,a4,5f58 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5fa2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5fa6:	4790                	lw	a2,8(a5)
    5fa8:	02061593          	slli	a1,a2,0x20
    5fac:	01c5d713          	srli	a4,a1,0x1c
    5fb0:	973e                	add	a4,a4,a5
    5fb2:	fae68ae3          	beq	a3,a4,5f66 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5fb6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5fb8:	00003717          	auipc	a4,0x3
    5fbc:	48f73c23          	sd	a5,1176(a4) # 9450 <freep>
}
    5fc0:	6422                	ld	s0,8(sp)
    5fc2:	0141                	addi	sp,sp,16
    5fc4:	8082                	ret

0000000000005fc6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5fc6:	7139                	addi	sp,sp,-64
    5fc8:	fc06                	sd	ra,56(sp)
    5fca:	f822                	sd	s0,48(sp)
    5fcc:	f426                	sd	s1,40(sp)
    5fce:	f04a                	sd	s2,32(sp)
    5fd0:	ec4e                	sd	s3,24(sp)
    5fd2:	e852                	sd	s4,16(sp)
    5fd4:	e456                	sd	s5,8(sp)
    5fd6:	e05a                	sd	s6,0(sp)
    5fd8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5fda:	02051493          	slli	s1,a0,0x20
    5fde:	9081                	srli	s1,s1,0x20
    5fe0:	04bd                	addi	s1,s1,15
    5fe2:	8091                	srli	s1,s1,0x4
    5fe4:	0014899b          	addiw	s3,s1,1
    5fe8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5fea:	00003517          	auipc	a0,0x3
    5fee:	46653503          	ld	a0,1126(a0) # 9450 <freep>
    5ff2:	c515                	beqz	a0,601e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ff4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5ff6:	4798                	lw	a4,8(a5)
    5ff8:	02977f63          	bgeu	a4,s1,6036 <malloc+0x70>
  if(nu < 4096)
    5ffc:	8a4e                	mv	s4,s3
    5ffe:	0009871b          	sext.w	a4,s3
    6002:	6685                	lui	a3,0x1
    6004:	00d77363          	bgeu	a4,a3,600a <malloc+0x44>
    6008:	6a05                	lui	s4,0x1
    600a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    600e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6012:	00003917          	auipc	s2,0x3
    6016:	43e90913          	addi	s2,s2,1086 # 9450 <freep>
  if(p == (char*)-1)
    601a:	5afd                	li	s5,-1
    601c:	a895                	j	6090 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    601e:	0000a797          	auipc	a5,0xa
    6022:	c5a78793          	addi	a5,a5,-934 # fc78 <base>
    6026:	00003717          	auipc	a4,0x3
    602a:	42f73523          	sd	a5,1066(a4) # 9450 <freep>
    602e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6030:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6034:	b7e1                	j	5ffc <malloc+0x36>
      if(p->s.size == nunits)
    6036:	02e48c63          	beq	s1,a4,606e <malloc+0xa8>
        p->s.size -= nunits;
    603a:	4137073b          	subw	a4,a4,s3
    603e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6040:	02071693          	slli	a3,a4,0x20
    6044:	01c6d713          	srli	a4,a3,0x1c
    6048:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    604a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    604e:	00003717          	auipc	a4,0x3
    6052:	40a73123          	sd	a0,1026(a4) # 9450 <freep>
      return (void*)(p + 1);
    6056:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    605a:	70e2                	ld	ra,56(sp)
    605c:	7442                	ld	s0,48(sp)
    605e:	74a2                	ld	s1,40(sp)
    6060:	7902                	ld	s2,32(sp)
    6062:	69e2                	ld	s3,24(sp)
    6064:	6a42                	ld	s4,16(sp)
    6066:	6aa2                	ld	s5,8(sp)
    6068:	6b02                	ld	s6,0(sp)
    606a:	6121                	addi	sp,sp,64
    606c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    606e:	6398                	ld	a4,0(a5)
    6070:	e118                	sd	a4,0(a0)
    6072:	bff1                	j	604e <malloc+0x88>
  hp->s.size = nu;
    6074:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6078:	0541                	addi	a0,a0,16
    607a:	00000097          	auipc	ra,0x0
    607e:	eca080e7          	jalr	-310(ra) # 5f44 <free>
  return freep;
    6082:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6086:	d971                	beqz	a0,605a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6088:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    608a:	4798                	lw	a4,8(a5)
    608c:	fa9775e3          	bgeu	a4,s1,6036 <malloc+0x70>
    if(p == freep)
    6090:	00093703          	ld	a4,0(s2)
    6094:	853e                	mv	a0,a5
    6096:	fef719e3          	bne	a4,a5,6088 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    609a:	8552                	mv	a0,s4
    609c:	00000097          	auipc	ra,0x0
    60a0:	b92080e7          	jalr	-1134(ra) # 5c2e <sbrk>
  if(p == (char*)-1)
    60a4:	fd5518e3          	bne	a0,s5,6074 <malloc+0xae>
        return 0;
    60a8:	4501                	li	a0,0
    60aa:	bf45                	j	605a <malloc+0x94>
