
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00015117          	auipc	sp,0x15
    80000004:	04010113          	addi	sp,sp,64 # 80015040 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7e0050ef          	jal	ra,800057f6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0001d797          	auipc	a5,0x1d
    80000034:	11078793          	addi	a5,a5,272 # 8001d140 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	87090913          	addi	s2,s2,-1936 # 800088c0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	184080e7          	jalr	388(ra) # 800061de <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	224080e7          	jalr	548(ra) # 80006292 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c1c080e7          	jalr	-996(ra) # 80005ca6 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00008517          	auipc	a0,0x8
    800000f2:	7d250513          	addi	a0,a0,2002 # 800088c0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	058080e7          	jalr	88(ra) # 8000614e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	0001d517          	auipc	a0,0x1d
    80000106:	03e50513          	addi	a0,a0,62 # 8001d140 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	79c48493          	addi	s1,s1,1948 # 800088c0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	0b0080e7          	jalr	176(ra) # 800061de <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	78450513          	addi	a0,a0,1924 # 800088c0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	14c080e7          	jalr	332(ra) # 80006292 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	75850513          	addi	a0,a0,1880 # 800088c0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	122080e7          	jalr	290(ra) # 80006292 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffe1ec1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	87aa                	mv	a5,a0
    8000028e:	86b2                	mv	a3,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	00d05963          	blez	a3,800002a4 <strncpy+0x1e>
    80000296:	0785                	addi	a5,a5,1
    80000298:	0005c703          	lbu	a4,0(a1)
    8000029c:	fee78fa3          	sb	a4,-1(a5)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f775                	bnez	a4,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	873e                	mv	a4,a5
    800002a6:	9fb5                	addw	a5,a5,a3
    800002a8:	37fd                	addiw	a5,a5,-1
    800002aa:	00c05963          	blez	a2,800002bc <strncpy+0x36>
    *s++ = 0;
    800002ae:	0705                	addi	a4,a4,1
    800002b0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002b4:	40e786bb          	subw	a3,a5,a4
    800002b8:	fed04be3          	bgtz	a3,800002ae <strncpy+0x28>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	86be                	mv	a3,a5
    80000306:	0785                	addi	a5,a5,1
    80000308:	fff7c703          	lbu	a4,-1(a5)
    8000030c:	ff65                	bnez	a4,80000304 <strlen+0x10>
    8000030e:	40a6853b          	subw	a0,a3,a0
    80000312:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	b00080e7          	jalr	-1280(ra) # 80000e26 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	56270713          	addi	a4,a4,1378 # 80008890 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ae4080e7          	jalr	-1308(ra) # 80000e26 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	99c080e7          	jalr	-1636(ra) # 80005cf0 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	786080e7          	jalr	1926(ra) # 80001aea <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	e44080e7          	jalr	-444(ra) # 800051b0 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fd4080e7          	jalr	-44(ra) # 80001348 <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	83a080e7          	jalr	-1990(ra) # 80005bb6 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b4c080e7          	jalr	-1204(ra) # 80005ed0 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	95c080e7          	jalr	-1700(ra) # 80005cf0 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	94c080e7          	jalr	-1716(ra) # 80005cf0 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	93c080e7          	jalr	-1732(ra) # 80005cf0 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d22080e7          	jalr	-734(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	99e080e7          	jalr	-1634(ra) # 80000d72 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	6e6080e7          	jalr	1766(ra) # 80001ac2 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	706080e7          	jalr	1798(ra) # 80001aea <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	dae080e7          	jalr	-594(ra) # 8000519a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	dbc080e7          	jalr	-580(ra) # 800051b0 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e3c080e7          	jalr	-452(ra) # 80002238 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	5ac080e7          	jalr	1452(ra) # 800029b0 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	5ca080e7          	jalr	1482(ra) # 800039d6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	ea4080e7          	jalr	-348(ra) # 800052b8 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d0e080e7          	jalr	-754(ra) # 8000112a <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	46f72323          	sw	a5,1126(a4) # 80008890 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	45a7b783          	ld	a5,1114(a5) # 80008898 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	81c080e7          	jalr	-2020(ra) # 80005ca6 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c84080e7          	jalr	-892(ra) # 8000011a <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd4080e7          	jalr	-812(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffe1eb7>
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	83a9                	srli	a5,a5,0xa
    8000053a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	777d                	lui	a4,0xfffff
    80000562:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000566:	fff58993          	addi	s3,a1,-1
    8000056a:	99b2                	add	s3,s3,a2
    8000056c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000570:	893e                	mv	s2,a5
    80000572:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	6f6080e7          	jalr	1782(ra) # 80005ca6 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	6e6080e7          	jalr	1766(ra) # 80005ca6 <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	69a080e7          	jalr	1690(ra) # 80005ca6 <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	afa080e7          	jalr	-1286(ra) # 8000011a <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4c080e7          	jalr	-1204(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	608080e7          	jalr	1544(ra) # 80000cdc <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	18a7bf23          	sd	a0,414(a5) # 80008898 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	54e080e7          	jalr	1358(ra) # 80005ca6 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	53e080e7          	jalr	1342(ra) # 80005ca6 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	52e080e7          	jalr	1326(ra) # 80005ca6 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	51e080e7          	jalr	1310(ra) # 80005ca6 <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	andi	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	andi	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	slli	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	942080e7          	jalr	-1726(ra) # 8000011a <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	992080e7          	jalr	-1646(ra) # 8000017a <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	902080e7          	jalr	-1790(ra) # 8000011a <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	954080e7          	jalr	-1708(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	990080e7          	jalr	-1648(ra) # 800001d6 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	addi	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	440080e7          	jalr	1088(ra) # 80005ca6 <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	76fd                	lui	a3,0xfffff
    8000088a:	8f75                	and	a4,a4,a3
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff5                	and	a5,a5,a3
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	addi	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a829                	j	8000099c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000986:	00c79513          	slli	a0,a5,0xc
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	fde080e7          	jalr	-34(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000992:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000996:	04a1                	addi	s1,s1,8
    80000998:	03248163          	beq	s1,s2,800009ba <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099e:	00f7f713          	andi	a4,a5,15
    800009a2:	ff3701e3          	beq	a4,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a6:	8b85                	andi	a5,a5,1
    800009a8:	d7fd                	beqz	a5,80000996 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009aa:	00007517          	auipc	a0,0x7
    800009ae:	74e50513          	addi	a0,a0,1870 # 800080f8 <etext+0xf8>
    800009b2:	00005097          	auipc	ra,0x5
    800009b6:	2f4080e7          	jalr	756(ra) # 80005ca6 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ba:	8552                	mv	a0,s4
    800009bc:	fffff097          	auipc	ra,0xfffff
    800009c0:	660080e7          	jalr	1632(ra) # 8000001c <kfree>
}
    800009c4:	70a2                	ld	ra,40(sp)
    800009c6:	7402                	ld	s0,32(sp)
    800009c8:	64e2                	ld	s1,24(sp)
    800009ca:	6942                	ld	s2,16(sp)
    800009cc:	69a2                	ld	s3,8(sp)
    800009ce:	6a02                	ld	s4,0(sp)
    800009d0:	6145                	addi	sp,sp,48
    800009d2:	8082                	ret

00000000800009d4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d4:	1101                	addi	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	addi	s0,sp,32
    800009de:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e0:	e999                	bnez	a1,800009f6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e2:	8526                	mv	a0,s1
    800009e4:	00000097          	auipc	ra,0x0
    800009e8:	f84080e7          	jalr	-124(ra) # 80000968 <freewalk>
}
    800009ec:	60e2                	ld	ra,24(sp)
    800009ee:	6442                	ld	s0,16(sp)
    800009f0:	64a2                	ld	s1,8(sp)
    800009f2:	6105                	addi	sp,sp,32
    800009f4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f6:	6785                	lui	a5,0x1
    800009f8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fa:	95be                	add	a1,a1,a5
    800009fc:	4685                	li	a3,1
    800009fe:	00c5d613          	srli	a2,a1,0xc
    80000a02:	4581                	li	a1,0
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	d06080e7          	jalr	-762(ra) # 8000070a <uvmunmap>
    80000a0c:	bfd9                	j	800009e2 <uvmfree+0xe>

0000000080000a0e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0e:	c679                	beqz	a2,80000adc <uvmcopy+0xce>
{
    80000a10:	715d                	addi	sp,sp,-80
    80000a12:	e486                	sd	ra,72(sp)
    80000a14:	e0a2                	sd	s0,64(sp)
    80000a16:	fc26                	sd	s1,56(sp)
    80000a18:	f84a                	sd	s2,48(sp)
    80000a1a:	f44e                	sd	s3,40(sp)
    80000a1c:	f052                	sd	s4,32(sp)
    80000a1e:	ec56                	sd	s5,24(sp)
    80000a20:	e85a                	sd	s6,16(sp)
    80000a22:	e45e                	sd	s7,8(sp)
    80000a24:	0880                	addi	s0,sp,80
    80000a26:	8b2a                	mv	s6,a0
    80000a28:	8aae                	mv	s5,a1
    80000a2a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a2e:	4601                	li	a2,0
    80000a30:	85ce                	mv	a1,s3
    80000a32:	855a                	mv	a0,s6
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	a28080e7          	jalr	-1496(ra) # 8000045c <walk>
    80000a3c:	c531                	beqz	a0,80000a88 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a3e:	6118                	ld	a4,0(a0)
    80000a40:	00177793          	andi	a5,a4,1
    80000a44:	cbb1                	beqz	a5,80000a98 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a46:	00a75593          	srli	a1,a4,0xa
    80000a4a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a4e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	6c8080e7          	jalr	1736(ra) # 8000011a <kalloc>
    80000a5a:	892a                	mv	s2,a0
    80000a5c:	c939                	beqz	a0,80000ab2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85de                	mv	a1,s7
    80000a62:	fffff097          	auipc	ra,0xfffff
    80000a66:	774080e7          	jalr	1908(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6a:	8726                	mv	a4,s1
    80000a6c:	86ca                	mv	a3,s2
    80000a6e:	6605                	lui	a2,0x1
    80000a70:	85ce                	mv	a1,s3
    80000a72:	8556                	mv	a0,s5
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	ad0080e7          	jalr	-1328(ra) # 80000544 <mappages>
    80000a7c:	e515                	bnez	a0,80000aa8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a7e:	6785                	lui	a5,0x1
    80000a80:	99be                	add	s3,s3,a5
    80000a82:	fb49e6e3          	bltu	s3,s4,80000a2e <uvmcopy+0x20>
    80000a86:	a081                	j	80000ac6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	68050513          	addi	a0,a0,1664 # 80008108 <etext+0x108>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	216080e7          	jalr	534(ra) # 80005ca6 <panic>
      panic("uvmcopy: page not present");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	addi	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	206080e7          	jalr	518(ra) # 80005ca6 <panic>
      kfree(mem);
    80000aa8:	854a                	mv	a0,s2
    80000aaa:	fffff097          	auipc	ra,0xfffff
    80000aae:	572080e7          	jalr	1394(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab2:	4685                	li	a3,1
    80000ab4:	00c9d613          	srli	a2,s3,0xc
    80000ab8:	4581                	li	a1,0
    80000aba:	8556                	mv	a0,s5
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	c4e080e7          	jalr	-946(ra) # 8000070a <uvmunmap>
  return -1;
    80000ac4:	557d                	li	a0,-1
}
    80000ac6:	60a6                	ld	ra,72(sp)
    80000ac8:	6406                	ld	s0,64(sp)
    80000aca:	74e2                	ld	s1,56(sp)
    80000acc:	7942                	ld	s2,48(sp)
    80000ace:	79a2                	ld	s3,40(sp)
    80000ad0:	7a02                	ld	s4,32(sp)
    80000ad2:	6ae2                	ld	s5,24(sp)
    80000ad4:	6b42                	ld	s6,16(sp)
    80000ad6:	6ba2                	ld	s7,8(sp)
    80000ad8:	6161                	addi	sp,sp,80
    80000ada:	8082                	ret
  return 0;
    80000adc:	4501                	li	a0,0
}
    80000ade:	8082                	ret

0000000080000ae0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae0:	1141                	addi	sp,sp,-16
    80000ae2:	e406                	sd	ra,8(sp)
    80000ae4:	e022                	sd	s0,0(sp)
    80000ae6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae8:	4601                	li	a2,0
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	972080e7          	jalr	-1678(ra) # 8000045c <walk>
  if(pte == 0)
    80000af2:	c901                	beqz	a0,80000b02 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af4:	611c                	ld	a5,0(a0)
    80000af6:	9bbd                	andi	a5,a5,-17
    80000af8:	e11c                	sd	a5,0(a0)
}
    80000afa:	60a2                	ld	ra,8(sp)
    80000afc:	6402                	ld	s0,0(sp)
    80000afe:	0141                	addi	sp,sp,16
    80000b00:	8082                	ret
    panic("uvmclear");
    80000b02:	00007517          	auipc	a0,0x7
    80000b06:	64650513          	addi	a0,a0,1606 # 80008148 <etext+0x148>
    80000b0a:	00005097          	auipc	ra,0x5
    80000b0e:	19c080e7          	jalr	412(ra) # 80005ca6 <panic>

0000000080000b12 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b12:	c6bd                	beqz	a3,80000b80 <copyout+0x6e>
{
    80000b14:	715d                	addi	sp,sp,-80
    80000b16:	e486                	sd	ra,72(sp)
    80000b18:	e0a2                	sd	s0,64(sp)
    80000b1a:	fc26                	sd	s1,56(sp)
    80000b1c:	f84a                	sd	s2,48(sp)
    80000b1e:	f44e                	sd	s3,40(sp)
    80000b20:	f052                	sd	s4,32(sp)
    80000b22:	ec56                	sd	s5,24(sp)
    80000b24:	e85a                	sd	s6,16(sp)
    80000b26:	e45e                	sd	s7,8(sp)
    80000b28:	e062                	sd	s8,0(sp)
    80000b2a:	0880                	addi	s0,sp,80
    80000b2c:	8b2a                	mv	s6,a0
    80000b2e:	8c2e                	mv	s8,a1
    80000b30:	8a32                	mv	s4,a2
    80000b32:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b34:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b36:	6a85                	lui	s5,0x1
    80000b38:	a015                	j	80000b5c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3a:	9562                	add	a0,a0,s8
    80000b3c:	0004861b          	sext.w	a2,s1
    80000b40:	85d2                	mv	a1,s4
    80000b42:	41250533          	sub	a0,a0,s2
    80000b46:	fffff097          	auipc	ra,0xfffff
    80000b4a:	690080e7          	jalr	1680(ra) # 800001d6 <memmove>

    len -= n;
    80000b4e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b52:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b54:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b58:	02098263          	beqz	s3,80000b7c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b60:	85ca                	mv	a1,s2
    80000b62:	855a                	mv	a0,s6
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	99e080e7          	jalr	-1634(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b6c:	cd01                	beqz	a0,80000b84 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b6e:	418904b3          	sub	s1,s2,s8
    80000b72:	94d6                	add	s1,s1,s5
    80000b74:	fc99f3e3          	bgeu	s3,s1,80000b3a <copyout+0x28>
    80000b78:	84ce                	mv	s1,s3
    80000b7a:	b7c1                	j	80000b3a <copyout+0x28>
  }
  return 0;
    80000b7c:	4501                	li	a0,0
    80000b7e:	a021                	j	80000b86 <copyout+0x74>
    80000b80:	4501                	li	a0,0
}
    80000b82:	8082                	ret
      return -1;
    80000b84:	557d                	li	a0,-1
}
    80000b86:	60a6                	ld	ra,72(sp)
    80000b88:	6406                	ld	s0,64(sp)
    80000b8a:	74e2                	ld	s1,56(sp)
    80000b8c:	7942                	ld	s2,48(sp)
    80000b8e:	79a2                	ld	s3,40(sp)
    80000b90:	7a02                	ld	s4,32(sp)
    80000b92:	6ae2                	ld	s5,24(sp)
    80000b94:	6b42                	ld	s6,16(sp)
    80000b96:	6ba2                	ld	s7,8(sp)
    80000b98:	6c02                	ld	s8,0(sp)
    80000b9a:	6161                	addi	sp,sp,80
    80000b9c:	8082                	ret

0000000080000b9e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b9e:	caa5                	beqz	a3,80000c0e <copyin+0x70>
{
    80000ba0:	715d                	addi	sp,sp,-80
    80000ba2:	e486                	sd	ra,72(sp)
    80000ba4:	e0a2                	sd	s0,64(sp)
    80000ba6:	fc26                	sd	s1,56(sp)
    80000ba8:	f84a                	sd	s2,48(sp)
    80000baa:	f44e                	sd	s3,40(sp)
    80000bac:	f052                	sd	s4,32(sp)
    80000bae:	ec56                	sd	s5,24(sp)
    80000bb0:	e85a                	sd	s6,16(sp)
    80000bb2:	e45e                	sd	s7,8(sp)
    80000bb4:	e062                	sd	s8,0(sp)
    80000bb6:	0880                	addi	s0,sp,80
    80000bb8:	8b2a                	mv	s6,a0
    80000bba:	8a2e                	mv	s4,a1
    80000bbc:	8c32                	mv	s8,a2
    80000bbe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc2:	6a85                	lui	s5,0x1
    80000bc4:	a01d                	j	80000bea <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc6:	018505b3          	add	a1,a0,s8
    80000bca:	0004861b          	sext.w	a2,s1
    80000bce:	412585b3          	sub	a1,a1,s2
    80000bd2:	8552                	mv	a0,s4
    80000bd4:	fffff097          	auipc	ra,0xfffff
    80000bd8:	602080e7          	jalr	1538(ra) # 800001d6 <memmove>

    len -= n;
    80000bdc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be6:	02098263          	beqz	s3,80000c0a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bea:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bee:	85ca                	mv	a1,s2
    80000bf0:	855a                	mv	a0,s6
    80000bf2:	00000097          	auipc	ra,0x0
    80000bf6:	910080e7          	jalr	-1776(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bfa:	cd01                	beqz	a0,80000c12 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfc:	418904b3          	sub	s1,s2,s8
    80000c00:	94d6                	add	s1,s1,s5
    80000c02:	fc99f2e3          	bgeu	s3,s1,80000bc6 <copyin+0x28>
    80000c06:	84ce                	mv	s1,s3
    80000c08:	bf7d                	j	80000bc6 <copyin+0x28>
  }
  return 0;
    80000c0a:	4501                	li	a0,0
    80000c0c:	a021                	j	80000c14 <copyin+0x76>
    80000c0e:	4501                	li	a0,0
}
    80000c10:	8082                	ret
      return -1;
    80000c12:	557d                	li	a0,-1
}
    80000c14:	60a6                	ld	ra,72(sp)
    80000c16:	6406                	ld	s0,64(sp)
    80000c18:	74e2                	ld	s1,56(sp)
    80000c1a:	7942                	ld	s2,48(sp)
    80000c1c:	79a2                	ld	s3,40(sp)
    80000c1e:	7a02                	ld	s4,32(sp)
    80000c20:	6ae2                	ld	s5,24(sp)
    80000c22:	6b42                	ld	s6,16(sp)
    80000c24:	6ba2                	ld	s7,8(sp)
    80000c26:	6c02                	ld	s8,0(sp)
    80000c28:	6161                	addi	sp,sp,80
    80000c2a:	8082                	ret

0000000080000c2c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2c:	c2dd                	beqz	a3,80000cd2 <copyinstr+0xa6>
{
    80000c2e:	715d                	addi	sp,sp,-80
    80000c30:	e486                	sd	ra,72(sp)
    80000c32:	e0a2                	sd	s0,64(sp)
    80000c34:	fc26                	sd	s1,56(sp)
    80000c36:	f84a                	sd	s2,48(sp)
    80000c38:	f44e                	sd	s3,40(sp)
    80000c3a:	f052                	sd	s4,32(sp)
    80000c3c:	ec56                	sd	s5,24(sp)
    80000c3e:	e85a                	sd	s6,16(sp)
    80000c40:	e45e                	sd	s7,8(sp)
    80000c42:	0880                	addi	s0,sp,80
    80000c44:	8a2a                	mv	s4,a0
    80000c46:	8b2e                	mv	s6,a1
    80000c48:	8bb2                	mv	s7,a2
    80000c4a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6985                	lui	s3,0x1
    80000c50:	a02d                	j	80000c7a <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c52:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c56:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c58:	37fd                	addiw	a5,a5,-1
    80000c5a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c5e:	60a6                	ld	ra,72(sp)
    80000c60:	6406                	ld	s0,64(sp)
    80000c62:	74e2                	ld	s1,56(sp)
    80000c64:	7942                	ld	s2,48(sp)
    80000c66:	79a2                	ld	s3,40(sp)
    80000c68:	7a02                	ld	s4,32(sp)
    80000c6a:	6ae2                	ld	s5,24(sp)
    80000c6c:	6b42                	ld	s6,16(sp)
    80000c6e:	6ba2                	ld	s7,8(sp)
    80000c70:	6161                	addi	sp,sp,80
    80000c72:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c74:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c78:	c8a9                	beqz	s1,80000cca <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c7e:	85ca                	mv	a1,s2
    80000c80:	8552                	mv	a0,s4
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	880080e7          	jalr	-1920(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c8a:	c131                	beqz	a0,80000cce <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8c:	417906b3          	sub	a3,s2,s7
    80000c90:	96ce                	add	a3,a3,s3
    80000c92:	00d4f363          	bgeu	s1,a3,80000c98 <copyinstr+0x6c>
    80000c96:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c98:	955e                	add	a0,a0,s7
    80000c9a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c9e:	daf9                	beqz	a3,80000c74 <copyinstr+0x48>
    80000ca0:	87da                	mv	a5,s6
    80000ca2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ca8:	96da                	add	a3,a3,s6
    80000caa:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffe1ec0>
    80000cb4:	df59                	beqz	a4,80000c52 <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cba:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cbc:	fed797e3          	bne	a5,a3,80000caa <copyinstr+0x7e>
    80000cc0:	14fd                	addi	s1,s1,-1
    80000cc2:	94c2                	add	s1,s1,a6
      --max;
    80000cc4:	8c8d                	sub	s1,s1,a1
      dst++;
    80000cc6:	8b3e                	mv	s6,a5
    80000cc8:	b775                	j	80000c74 <copyinstr+0x48>
    80000cca:	4781                	li	a5,0
    80000ccc:	b771                	j	80000c58 <copyinstr+0x2c>
      return -1;
    80000cce:	557d                	li	a0,-1
    80000cd0:	b779                	j	80000c5e <copyinstr+0x32>
  int got_null = 0;
    80000cd2:	4781                	li	a5,0
  if(got_null){
    80000cd4:	37fd                	addiw	a5,a5,-1
    80000cd6:	0007851b          	sext.w	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cdc:	7139                	addi	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	addi	s0,sp,64
    80000cf0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	01e48493          	addi	s1,s1,30 # 80008d10 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	00007a97          	auipc	s5,0x7
    80000d00:	304a8a93          	addi	s5,s5,772 # 80008000 <etext>
    80000d04:	04000937          	lui	s2,0x4000
    80000d08:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d0a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	00009a17          	auipc	s4,0x9
    80000d10:	e14a0a13          	addi	s4,s4,-492 # 80009b20 <tickslock>
    char *pa = kalloc();
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	406080e7          	jalr	1030(ra) # 8000011a <kalloc>
    80000d1c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d1e:	c131                	beqz	a0,80000d62 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d20:	416485b3          	sub	a1,s1,s6
    80000d24:	858d                	srai	a1,a1,0x3
    80000d26:	000ab783          	ld	a5,0(s5)
    80000d2a:	02f585b3          	mul	a1,a1,a5
    80000d2e:	2585                	addiw	a1,a1,1
    80000d30:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d34:	4719                	li	a4,6
    80000d36:	6685                	lui	a3,0x1
    80000d38:	40b905b3          	sub	a1,s2,a1
    80000d3c:	854e                	mv	a0,s3
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	8a6080e7          	jalr	-1882(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d46:	16848493          	addi	s1,s1,360
    80000d4a:	fd4495e3          	bne	s1,s4,80000d14 <proc_mapstacks+0x38>
  }
}
    80000d4e:	70e2                	ld	ra,56(sp)
    80000d50:	7442                	ld	s0,48(sp)
    80000d52:	74a2                	ld	s1,40(sp)
    80000d54:	7902                	ld	s2,32(sp)
    80000d56:	69e2                	ld	s3,24(sp)
    80000d58:	6a42                	ld	s4,16(sp)
    80000d5a:	6aa2                	ld	s5,8(sp)
    80000d5c:	6b02                	ld	s6,0(sp)
    80000d5e:	6121                	addi	sp,sp,64
    80000d60:	8082                	ret
      panic("kalloc");
    80000d62:	00007517          	auipc	a0,0x7
    80000d66:	3f650513          	addi	a0,a0,1014 # 80008158 <etext+0x158>
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	f3c080e7          	jalr	-196(ra) # 80005ca6 <panic>

0000000080000d72 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d72:	7139                	addi	sp,sp,-64
    80000d74:	fc06                	sd	ra,56(sp)
    80000d76:	f822                	sd	s0,48(sp)
    80000d78:	f426                	sd	s1,40(sp)
    80000d7a:	f04a                	sd	s2,32(sp)
    80000d7c:	ec4e                	sd	s3,24(sp)
    80000d7e:	e852                	sd	s4,16(sp)
    80000d80:	e456                	sd	s5,8(sp)
    80000d82:	e05a                	sd	s6,0(sp)
    80000d84:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3da58593          	addi	a1,a1,986 # 80008160 <etext+0x160>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	b5250513          	addi	a0,a0,-1198 # 800088e0 <pid_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	3b8080e7          	jalr	952(ra) # 8000614e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	b5250513          	addi	a0,a0,-1198 # 800088f8 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	3a0080e7          	jalr	928(ra) # 8000614e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00008497          	auipc	s1,0x8
    80000dba:	f5a48493          	addi	s1,s1,-166 # 80008d10 <proc>
      initlock(&p->lock, "proc");
    80000dbe:	00007b17          	auipc	s6,0x7
    80000dc2:	3bab0b13          	addi	s6,s6,954 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc6:	8aa6                	mv	s5,s1
    80000dc8:	00007a17          	auipc	s4,0x7
    80000dcc:	238a0a13          	addi	s4,s4,568 # 80008000 <etext>
    80000dd0:	04000937          	lui	s2,0x4000
    80000dd4:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dd6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	00009997          	auipc	s3,0x9
    80000ddc:	d4898993          	addi	s3,s3,-696 # 80009b20 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	36a080e7          	jalr	874(ra) # 8000614e <initlock>
      p->state = UNUSED;
    80000dec:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df0:	415487b3          	sub	a5,s1,s5
    80000df4:	878d                	srai	a5,a5,0x3
    80000df6:	000a3703          	ld	a4,0(s4)
    80000dfa:	02e787b3          	mul	a5,a5,a4
    80000dfe:	2785                	addiw	a5,a5,1
    80000e00:	00d7979b          	slliw	a5,a5,0xd
    80000e04:	40f907b3          	sub	a5,s2,a5
    80000e08:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	16848493          	addi	s1,s1,360
    80000e0e:	fd3499e3          	bne	s1,s3,80000de0 <procinit+0x6e>
  }
}
    80000e12:	70e2                	ld	ra,56(sp)
    80000e14:	7442                	ld	s0,48(sp)
    80000e16:	74a2                	ld	s1,40(sp)
    80000e18:	7902                	ld	s2,32(sp)
    80000e1a:	69e2                	ld	s3,24(sp)
    80000e1c:	6a42                	ld	s4,16(sp)
    80000e1e:	6aa2                	ld	s5,8(sp)
    80000e20:	6b02                	ld	s6,0(sp)
    80000e22:	6121                	addi	sp,sp,64
    80000e24:	8082                	ret

0000000080000e26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2e:	2501                	sext.w	a0,a0
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
    80000e3c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e42:	00008517          	auipc	a0,0x8
    80000e46:	ace50513          	addi	a0,a0,-1330 # 80008910 <cpus>
    80000e4a:	953e                	add	a0,a0,a5
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e52:	1101                	addi	sp,sp,-32
    80000e54:	ec06                	sd	ra,24(sp)
    80000e56:	e822                	sd	s0,16(sp)
    80000e58:	e426                	sd	s1,8(sp)
    80000e5a:	1000                	addi	s0,sp,32
  push_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	336080e7          	jalr	822(ra) # 80006192 <push_off>
    80000e64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e66:	2781                	sext.w	a5,a5
    80000e68:	079e                	slli	a5,a5,0x7
    80000e6a:	00008717          	auipc	a4,0x8
    80000e6e:	a7670713          	addi	a4,a4,-1418 # 800088e0 <pid_lock>
    80000e72:	97ba                	add	a5,a5,a4
    80000e74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	3bc080e7          	jalr	956(ra) # 80006232 <pop_off>
  return p;
}
    80000e7e:	8526                	mv	a0,s1
    80000e80:	60e2                	ld	ra,24(sp)
    80000e82:	6442                	ld	s0,16(sp)
    80000e84:	64a2                	ld	s1,8(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret

0000000080000e8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8a:	1141                	addi	sp,sp,-16
    80000e8c:	e406                	sd	ra,8(sp)
    80000e8e:	e022                	sd	s0,0(sp)
    80000e90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	fc0080e7          	jalr	-64(ra) # 80000e52 <myproc>
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	3f8080e7          	jalr	1016(ra) # 80006292 <release>

  if (first) {
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	99e7a783          	lw	a5,-1634(a5) # 80008840 <first.1>
    80000eaa:	eb89                	bnez	a5,80000ebc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	c56080e7          	jalr	-938(ra) # 80001b02 <usertrapret>
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
    first = 0;
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9807a223          	sw	zero,-1660(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000ec4:	4505                	li	a0,1
    80000ec6:	00002097          	auipc	ra,0x2
    80000eca:	a6a080e7          	jalr	-1430(ra) # 80002930 <fsinit>
    80000ece:	bff9                	j	80000eac <forkret+0x22>

0000000080000ed0 <allocpid>:
{
    80000ed0:	1101                	addi	sp,sp,-32
    80000ed2:	ec06                	sd	ra,24(sp)
    80000ed4:	e822                	sd	s0,16(sp)
    80000ed6:	e426                	sd	s1,8(sp)
    80000ed8:	e04a                	sd	s2,0(sp)
    80000eda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000edc:	00008917          	auipc	s2,0x8
    80000ee0:	a0490913          	addi	s2,s2,-1532 # 800088e0 <pid_lock>
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	2f8080e7          	jalr	760(ra) # 800061de <acquire>
  pid = nextpid;
    80000eee:	00008797          	auipc	a5,0x8
    80000ef2:	95678793          	addi	a5,a5,-1706 # 80008844 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	392080e7          	jalr	914(ra) # 80006292 <release>
}
    80000f08:	8526                	mv	a0,s1
    80000f0a:	60e2                	ld	ra,24(sp)
    80000f0c:	6442                	ld	s0,16(sp)
    80000f0e:	64a2                	ld	s1,8(sp)
    80000f10:	6902                	ld	s2,0(sp)
    80000f12:	6105                	addi	sp,sp,32
    80000f14:	8082                	ret

0000000080000f16 <proc_pagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	8aa080e7          	jalr	-1878(ra) # 800007ce <uvmcreate>
    80000f2c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2e:	c121                	beqz	a0,80000f6e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f30:	4729                	li	a4,10
    80000f32:	00006697          	auipc	a3,0x6
    80000f36:	0ce68693          	addi	a3,a3,206 # 80007000 <_trampoline>
    80000f3a:	6605                	lui	a2,0x1
    80000f3c:	040005b7          	lui	a1,0x4000
    80000f40:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f42:	05b2                	slli	a1,a1,0xc
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	600080e7          	jalr	1536(ra) # 80000544 <mappages>
    80000f4c:	02054863          	bltz	a0,80000f7c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f50:	4719                	li	a4,6
    80000f52:	05893683          	ld	a3,88(s2)
    80000f56:	6605                	lui	a2,0x1
    80000f58:	020005b7          	lui	a1,0x2000
    80000f5c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f5e:	05b6                	slli	a1,a1,0xd
    80000f60:	8526                	mv	a0,s1
    80000f62:	fffff097          	auipc	ra,0xfffff
    80000f66:	5e2080e7          	jalr	1506(ra) # 80000544 <mappages>
    80000f6a:	02054163          	bltz	a0,80000f8c <proc_pagetable+0x76>
}
    80000f6e:	8526                	mv	a0,s1
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6902                	ld	s2,0(sp)
    80000f78:	6105                	addi	sp,sp,32
    80000f7a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7c:	4581                	li	a1,0
    80000f7e:	8526                	mv	a0,s1
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	a54080e7          	jalr	-1452(ra) # 800009d4 <uvmfree>
    return 0;
    80000f88:	4481                	li	s1,0
    80000f8a:	b7d5                	j	80000f6e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8c:	4681                	li	a3,0
    80000f8e:	4605                	li	a2,1
    80000f90:	040005b7          	lui	a1,0x4000
    80000f94:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f96:	05b2                	slli	a1,a1,0xc
    80000f98:	8526                	mv	a0,s1
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	770080e7          	jalr	1904(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa2:	4581                	li	a1,0
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	a2e080e7          	jalr	-1490(ra) # 800009d4 <uvmfree>
    return 0;
    80000fae:	4481                	li	s1,0
    80000fb0:	bf7d                	j	80000f6e <proc_pagetable+0x58>

0000000080000fb2 <proc_freepagetable>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
    80000fbe:	84aa                	mv	s1,a0
    80000fc0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	73c080e7          	jalr	1852(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	726080e7          	jalr	1830(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fec:	85ca                	mv	a1,s2
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	9e4080e7          	jalr	-1564(ra) # 800009d4 <uvmfree>
}
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret

0000000080001004 <freeproc>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001010:	6d28                	ld	a0,88(a0)
    80001012:	c509                	beqz	a0,8000101c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	008080e7          	jalr	8(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001020:	68a8                	ld	a0,80(s1)
    80001022:	c511                	beqz	a0,8000102e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001024:	64ac                	ld	a1,72(s1)
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	f8c080e7          	jalr	-116(ra) # 80000fb2 <proc_freepagetable>
  p->pagetable = 0;
    8000102e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001032:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001036:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000103e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001042:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001046:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000104e:	0004ac23          	sw	zero,24(s1)
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6105                	addi	sp,sp,32
    8000105a:	8082                	ret

000000008000105c <allocproc>:
{
    8000105c:	1101                	addi	sp,sp,-32
    8000105e:	ec06                	sd	ra,24(sp)
    80001060:	e822                	sd	s0,16(sp)
    80001062:	e426                	sd	s1,8(sp)
    80001064:	e04a                	sd	s2,0(sp)
    80001066:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001068:	00008497          	auipc	s1,0x8
    8000106c:	ca848493          	addi	s1,s1,-856 # 80008d10 <proc>
    80001070:	00009917          	auipc	s2,0x9
    80001074:	ab090913          	addi	s2,s2,-1360 # 80009b20 <tickslock>
    acquire(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	164080e7          	jalr	356(ra) # 800061de <acquire>
    if(p->state == UNUSED) {
    80001082:	4c9c                	lw	a5,24(s1)
    80001084:	c395                	beqz	a5,800010a8 <allocproc+0x4c>
      release(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	00005097          	auipc	ra,0x5
    8000108c:	20a080e7          	jalr	522(ra) # 80006292 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001090:	16848493          	addi	s1,s1,360
    80001094:	ff2492e3          	bne	s1,s2,80001078 <allocproc+0x1c>
  return 0;
    80001098:	4481                	li	s1,0
}
    8000109a:	8526                	mv	a0,s1
    8000109c:	60e2                	ld	ra,24(sp)
    8000109e:	6442                	ld	s0,16(sp)
    800010a0:	64a2                	ld	s1,8(sp)
    800010a2:	6902                	ld	s2,0(sp)
    800010a4:	6105                	addi	sp,sp,32
    800010a6:	8082                	ret
  p->pid = allocpid();
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	e28080e7          	jalr	-472(ra) # 80000ed0 <allocpid>
    800010b0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010b2:	4785                	li	a5,1
    800010b4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b6:	fffff097          	auipc	ra,0xfffff
    800010ba:	064080e7          	jalr	100(ra) # 8000011a <kalloc>
    800010be:	892a                	mv	s2,a0
    800010c0:	eca8                	sd	a0,88(s1)
    800010c2:	cd05                	beqz	a0,800010fa <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010c4:	8526                	mv	a0,s1
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	e50080e7          	jalr	-432(ra) # 80000f16 <proc_pagetable>
    800010ce:	892a                	mv	s2,a0
    800010d0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010d2:	c121                	beqz	a0,80001112 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010d4:	07000613          	li	a2,112
    800010d8:	4581                	li	a1,0
    800010da:	06048513          	addi	a0,s1,96
    800010de:	fffff097          	auipc	ra,0xfffff
    800010e2:	09c080e7          	jalr	156(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010e6:	00000797          	auipc	a5,0x0
    800010ea:	da478793          	addi	a5,a5,-604 # 80000e8a <forkret>
    800010ee:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010f0:	60bc                	ld	a5,64(s1)
    800010f2:	6705                	lui	a4,0x1
    800010f4:	97ba                	add	a5,a5,a4
    800010f6:	f4bc                	sd	a5,104(s1)
  return p;
    800010f8:	b74d                	j	8000109a <allocproc+0x3e>
    freeproc(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	f08080e7          	jalr	-248(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	18c080e7          	jalr	396(ra) # 80006292 <release>
    return 0;
    8000110e:	84ca                	mv	s1,s2
    80001110:	b769                	j	8000109a <allocproc+0x3e>
    freeproc(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	ef0080e7          	jalr	-272(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	174080e7          	jalr	372(ra) # 80006292 <release>
    return 0;
    80001126:	84ca                	mv	s1,s2
    80001128:	bf8d                	j	8000109a <allocproc+0x3e>

000000008000112a <userinit>:
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	1000                	addi	s0,sp,32
  p = allocproc();
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f28080e7          	jalr	-216(ra) # 8000105c <allocproc>
    8000113c:	84aa                	mv	s1,a0
  initproc = p;
    8000113e:	00007797          	auipc	a5,0x7
    80001142:	76a7b123          	sd	a0,1890(a5) # 800088a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001146:	03400613          	li	a2,52
    8000114a:	00007597          	auipc	a1,0x7
    8000114e:	70658593          	addi	a1,a1,1798 # 80008850 <initcode>
    80001152:	6928                	ld	a0,80(a0)
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	6a8080e7          	jalr	1704(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    8000115c:	6785                	lui	a5,0x1
    8000115e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001160:	6cb8                	ld	a4,88(s1)
    80001162:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116a:	4641                	li	a2,16
    8000116c:	00007597          	auipc	a1,0x7
    80001170:	01458593          	addi	a1,a1,20 # 80008180 <etext+0x180>
    80001174:	15848513          	addi	a0,s1,344
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	14a080e7          	jalr	330(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001180:	00007517          	auipc	a0,0x7
    80001184:	01050513          	addi	a0,a0,16 # 80008190 <etext+0x190>
    80001188:	00002097          	auipc	ra,0x2
    8000118c:	26e080e7          	jalr	622(ra) # 800033f6 <namei>
    80001190:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001194:	478d                	li	a5,3
    80001196:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001198:	8526                	mv	a0,s1
    8000119a:	00005097          	auipc	ra,0x5
    8000119e:	0f8080e7          	jalr	248(ra) # 80006292 <release>
}
    800011a2:	60e2                	ld	ra,24(sp)
    800011a4:	6442                	ld	s0,16(sp)
    800011a6:	64a2                	ld	s1,8(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <growproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	e04a                	sd	s2,0(sp)
    800011b6:	1000                	addi	s0,sp,32
    800011b8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	c98080e7          	jalr	-872(ra) # 80000e52 <myproc>
    800011c2:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011c6:	01204c63          	bgtz	s2,800011de <growproc+0x32>
  } else if(n < 0){
    800011ca:	02094663          	bltz	s2,800011f6 <growproc+0x4a>
  p->sz = sz;
    800011ce:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011de:	4691                	li	a3,4
    800011e0:	00b90633          	add	a2,s2,a1
    800011e4:	6928                	ld	a0,80(a0)
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	6d0080e7          	jalr	1744(ra) # 800008b6 <uvmalloc>
    800011ee:	85aa                	mv	a1,a0
    800011f0:	fd79                	bnez	a0,800011ce <growproc+0x22>
      return -1;
    800011f2:	557d                	li	a0,-1
    800011f4:	bff9                	j	800011d2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f6:	00b90633          	add	a2,s2,a1
    800011fa:	6928                	ld	a0,80(a0)
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	672080e7          	jalr	1650(ra) # 8000086e <uvmdealloc>
    80001204:	85aa                	mv	a1,a0
    80001206:	b7e1                	j	800011ce <growproc+0x22>

0000000080001208 <fork>:
{
    80001208:	7139                	addi	sp,sp,-64
    8000120a:	fc06                	sd	ra,56(sp)
    8000120c:	f822                	sd	s0,48(sp)
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	c38080e7          	jalr	-968(ra) # 80000e52 <myproc>
    80001222:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001224:	00000097          	auipc	ra,0x0
    80001228:	e38080e7          	jalr	-456(ra) # 8000105c <allocproc>
    8000122c:	10050c63          	beqz	a0,80001344 <fork+0x13c>
    80001230:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001232:	048ab603          	ld	a2,72(s5)
    80001236:	692c                	ld	a1,80(a0)
    80001238:	050ab503          	ld	a0,80(s5)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	7d2080e7          	jalr	2002(ra) # 80000a0e <uvmcopy>
    80001244:	04054863          	bltz	a0,80001294 <fork+0x8c>
  np->sz = p->sz;
    80001248:	048ab783          	ld	a5,72(s5)
    8000124c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001250:	058ab683          	ld	a3,88(s5)
    80001254:	87b6                	mv	a5,a3
    80001256:	058a3703          	ld	a4,88(s4)
    8000125a:	12068693          	addi	a3,a3,288
    8000125e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001262:	6788                	ld	a0,8(a5)
    80001264:	6b8c                	ld	a1,16(a5)
    80001266:	6f90                	ld	a2,24(a5)
    80001268:	01073023          	sd	a6,0(a4)
    8000126c:	e708                	sd	a0,8(a4)
    8000126e:	eb0c                	sd	a1,16(a4)
    80001270:	ef10                	sd	a2,24(a4)
    80001272:	02078793          	addi	a5,a5,32
    80001276:	02070713          	addi	a4,a4,32
    8000127a:	fed792e3          	bne	a5,a3,8000125e <fork+0x56>
  np->trapframe->a0 = 0;
    8000127e:	058a3783          	ld	a5,88(s4)
    80001282:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001286:	0d0a8493          	addi	s1,s5,208
    8000128a:	0d0a0913          	addi	s2,s4,208
    8000128e:	150a8993          	addi	s3,s5,336
    80001292:	a00d                	j	800012b4 <fork+0xac>
    freeproc(np);
    80001294:	8552                	mv	a0,s4
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	d6e080e7          	jalr	-658(ra) # 80001004 <freeproc>
    release(&np->lock);
    8000129e:	8552                	mv	a0,s4
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	ff2080e7          	jalr	-14(ra) # 80006292 <release>
    return -1;
    800012a8:	597d                	li	s2,-1
    800012aa:	a059                	j	80001330 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ac:	04a1                	addi	s1,s1,8
    800012ae:	0921                	addi	s2,s2,8
    800012b0:	01348b63          	beq	s1,s3,800012c6 <fork+0xbe>
    if(p->ofile[i])
    800012b4:	6088                	ld	a0,0(s1)
    800012b6:	d97d                	beqz	a0,800012ac <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b8:	00002097          	auipc	ra,0x2
    800012bc:	7b0080e7          	jalr	1968(ra) # 80003a68 <filedup>
    800012c0:	00a93023          	sd	a0,0(s2)
    800012c4:	b7e5                	j	800012ac <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c6:	150ab503          	ld	a0,336(s5)
    800012ca:	00002097          	auipc	ra,0x2
    800012ce:	8a0080e7          	jalr	-1888(ra) # 80002b6a <idup>
    800012d2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d6:	4641                	li	a2,16
    800012d8:	158a8593          	addi	a1,s5,344
    800012dc:	158a0513          	addi	a0,s4,344
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	fe2080e7          	jalr	-30(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012e8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012ec:	8552                	mv	a0,s4
    800012ee:	00005097          	auipc	ra,0x5
    800012f2:	fa4080e7          	jalr	-92(ra) # 80006292 <release>
  acquire(&wait_lock);
    800012f6:	00007497          	auipc	s1,0x7
    800012fa:	60248493          	addi	s1,s1,1538 # 800088f8 <wait_lock>
    800012fe:	8526                	mv	a0,s1
    80001300:	00005097          	auipc	ra,0x5
    80001304:	ede080e7          	jalr	-290(ra) # 800061de <acquire>
  np->parent = p;
    80001308:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	f84080e7          	jalr	-124(ra) # 80006292 <release>
  acquire(&np->lock);
    80001316:	8552                	mv	a0,s4
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	ec6080e7          	jalr	-314(ra) # 800061de <acquire>
  np->state = RUNNABLE;
    80001320:	478d                	li	a5,3
    80001322:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001326:	8552                	mv	a0,s4
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	f6a080e7          	jalr	-150(ra) # 80006292 <release>
}
    80001330:	854a                	mv	a0,s2
    80001332:	70e2                	ld	ra,56(sp)
    80001334:	7442                	ld	s0,48(sp)
    80001336:	74a2                	ld	s1,40(sp)
    80001338:	7902                	ld	s2,32(sp)
    8000133a:	69e2                	ld	s3,24(sp)
    8000133c:	6a42                	ld	s4,16(sp)
    8000133e:	6aa2                	ld	s5,8(sp)
    80001340:	6121                	addi	sp,sp,64
    80001342:	8082                	ret
    return -1;
    80001344:	597d                	li	s2,-1
    80001346:	b7ed                	j	80001330 <fork+0x128>

0000000080001348 <scheduler>:
{
    80001348:	7139                	addi	sp,sp,-64
    8000134a:	fc06                	sd	ra,56(sp)
    8000134c:	f822                	sd	s0,48(sp)
    8000134e:	f426                	sd	s1,40(sp)
    80001350:	f04a                	sd	s2,32(sp)
    80001352:	ec4e                	sd	s3,24(sp)
    80001354:	e852                	sd	s4,16(sp)
    80001356:	e456                	sd	s5,8(sp)
    80001358:	e05a                	sd	s6,0(sp)
    8000135a:	0080                	addi	s0,sp,64
    8000135c:	8792                	mv	a5,tp
  int id = r_tp();
    8000135e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001360:	00779a93          	slli	s5,a5,0x7
    80001364:	00007717          	auipc	a4,0x7
    80001368:	57c70713          	addi	a4,a4,1404 # 800088e0 <pid_lock>
    8000136c:	9756                	add	a4,a4,s5
    8000136e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001372:	00007717          	auipc	a4,0x7
    80001376:	5a670713          	addi	a4,a4,1446 # 80008918 <cpus+0x8>
    8000137a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137c:	498d                	li	s3,3
        p->state = RUNNING;
    8000137e:	4b11                	li	s6,4
        c->proc = p;
    80001380:	079e                	slli	a5,a5,0x7
    80001382:	00007a17          	auipc	s4,0x7
    80001386:	55ea0a13          	addi	s4,s4,1374 # 800088e0 <pid_lock>
    8000138a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138c:	00008917          	auipc	s2,0x8
    80001390:	79490913          	addi	s2,s2,1940 # 80009b20 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001394:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001398:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139c:	10079073          	csrw	sstatus,a5
    800013a0:	00008497          	auipc	s1,0x8
    800013a4:	97048493          	addi	s1,s1,-1680 # 80008d10 <proc>
    800013a8:	a811                	j	800013bc <scheduler+0x74>
      release(&p->lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00005097          	auipc	ra,0x5
    800013b0:	ee6080e7          	jalr	-282(ra) # 80006292 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b4:	16848493          	addi	s1,s1,360
    800013b8:	fd248ee3          	beq	s1,s2,80001394 <scheduler+0x4c>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	00005097          	auipc	ra,0x5
    800013c2:	e20080e7          	jalr	-480(ra) # 800061de <acquire>
      if(p->state == RUNNABLE) {
    800013c6:	4c9c                	lw	a5,24(s1)
    800013c8:	ff3791e3          	bne	a5,s3,800013aa <scheduler+0x62>
        p->state = RUNNING;
    800013cc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d4:	06048593          	addi	a1,s1,96
    800013d8:	8556                	mv	a0,s5
    800013da:	00000097          	auipc	ra,0x0
    800013de:	67e080e7          	jalr	1662(ra) # 80001a58 <swtch>
        c->proc = 0;
    800013e2:	020a3823          	sd	zero,48(s4)
    800013e6:	b7d1                	j	800013aa <scheduler+0x62>

00000000800013e8 <sched>:
{
    800013e8:	7179                	addi	sp,sp,-48
    800013ea:	f406                	sd	ra,40(sp)
    800013ec:	f022                	sd	s0,32(sp)
    800013ee:	ec26                	sd	s1,24(sp)
    800013f0:	e84a                	sd	s2,16(sp)
    800013f2:	e44e                	sd	s3,8(sp)
    800013f4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	a5c080e7          	jalr	-1444(ra) # 80000e52 <myproc>
    800013fe:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001400:	00005097          	auipc	ra,0x5
    80001404:	d64080e7          	jalr	-668(ra) # 80006164 <holding>
    80001408:	c93d                	beqz	a0,8000147e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000140a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140c:	2781                	sext.w	a5,a5
    8000140e:	079e                	slli	a5,a5,0x7
    80001410:	00007717          	auipc	a4,0x7
    80001414:	4d070713          	addi	a4,a4,1232 # 800088e0 <pid_lock>
    80001418:	97ba                	add	a5,a5,a4
    8000141a:	0a87a703          	lw	a4,168(a5)
    8000141e:	4785                	li	a5,1
    80001420:	06f71763          	bne	a4,a5,8000148e <sched+0xa6>
  if(p->state == RUNNING)
    80001424:	4c98                	lw	a4,24(s1)
    80001426:	4791                	li	a5,4
    80001428:	06f70b63          	beq	a4,a5,8000149e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001430:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001432:	efb5                	bnez	a5,800014ae <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001434:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001436:	00007917          	auipc	s2,0x7
    8000143a:	4aa90913          	addi	s2,s2,1194 # 800088e0 <pid_lock>
    8000143e:	2781                	sext.w	a5,a5
    80001440:	079e                	slli	a5,a5,0x7
    80001442:	97ca                	add	a5,a5,s2
    80001444:	0ac7a983          	lw	s3,172(a5)
    80001448:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	00007597          	auipc	a1,0x7
    80001452:	4ca58593          	addi	a1,a1,1226 # 80008918 <cpus+0x8>
    80001456:	95be                	add	a1,a1,a5
    80001458:	06048513          	addi	a0,s1,96
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	5fc080e7          	jalr	1532(ra) # 80001a58 <swtch>
    80001464:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	993e                	add	s2,s2,a5
    8000146c:	0b392623          	sw	s3,172(s2)
}
    80001470:	70a2                	ld	ra,40(sp)
    80001472:	7402                	ld	s0,32(sp)
    80001474:	64e2                	ld	s1,24(sp)
    80001476:	6942                	ld	s2,16(sp)
    80001478:	69a2                	ld	s3,8(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret
    panic("sched p->lock");
    8000147e:	00007517          	auipc	a0,0x7
    80001482:	d1a50513          	addi	a0,a0,-742 # 80008198 <etext+0x198>
    80001486:	00005097          	auipc	ra,0x5
    8000148a:	820080e7          	jalr	-2016(ra) # 80005ca6 <panic>
    panic("sched locks");
    8000148e:	00007517          	auipc	a0,0x7
    80001492:	d1a50513          	addi	a0,a0,-742 # 800081a8 <etext+0x1a8>
    80001496:	00005097          	auipc	ra,0x5
    8000149a:	810080e7          	jalr	-2032(ra) # 80005ca6 <panic>
    panic("sched running");
    8000149e:	00007517          	auipc	a0,0x7
    800014a2:	d1a50513          	addi	a0,a0,-742 # 800081b8 <etext+0x1b8>
    800014a6:	00005097          	auipc	ra,0x5
    800014aa:	800080e7          	jalr	-2048(ra) # 80005ca6 <panic>
    panic("sched interruptible");
    800014ae:	00007517          	auipc	a0,0x7
    800014b2:	d1a50513          	addi	a0,a0,-742 # 800081c8 <etext+0x1c8>
    800014b6:	00004097          	auipc	ra,0x4
    800014ba:	7f0080e7          	jalr	2032(ra) # 80005ca6 <panic>

00000000800014be <yield>:
{
    800014be:	1101                	addi	sp,sp,-32
    800014c0:	ec06                	sd	ra,24(sp)
    800014c2:	e822                	sd	s0,16(sp)
    800014c4:	e426                	sd	s1,8(sp)
    800014c6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	98a080e7          	jalr	-1654(ra) # 80000e52 <myproc>
    800014d0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	d0c080e7          	jalr	-756(ra) # 800061de <acquire>
  p->state = RUNNABLE;
    800014da:	478d                	li	a5,3
    800014dc:	cc9c                	sw	a5,24(s1)
  sched();
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	f0a080e7          	jalr	-246(ra) # 800013e8 <sched>
  release(&p->lock);
    800014e6:	8526                	mv	a0,s1
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	daa080e7          	jalr	-598(ra) # 80006292 <release>
}
    800014f0:	60e2                	ld	ra,24(sp)
    800014f2:	6442                	ld	s0,16(sp)
    800014f4:	64a2                	ld	s1,8(sp)
    800014f6:	6105                	addi	sp,sp,32
    800014f8:	8082                	ret

00000000800014fa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014fa:	7179                	addi	sp,sp,-48
    800014fc:	f406                	sd	ra,40(sp)
    800014fe:	f022                	sd	s0,32(sp)
    80001500:	ec26                	sd	s1,24(sp)
    80001502:	e84a                	sd	s2,16(sp)
    80001504:	e44e                	sd	s3,8(sp)
    80001506:	1800                	addi	s0,sp,48
    80001508:	89aa                	mv	s3,a0
    8000150a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	946080e7          	jalr	-1722(ra) # 80000e52 <myproc>
    80001514:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	cc8080e7          	jalr	-824(ra) # 800061de <acquire>
  release(lk);
    8000151e:	854a                	mv	a0,s2
    80001520:	00005097          	auipc	ra,0x5
    80001524:	d72080e7          	jalr	-654(ra) # 80006292 <release>

  // Go to sleep.
  p->chan = chan;
    80001528:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152c:	4789                	li	a5,2
    8000152e:	cc9c                	sw	a5,24(s1)

  sched();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	eb8080e7          	jalr	-328(ra) # 800013e8 <sched>

  // Tidy up.
  p->chan = 0;
    80001538:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	d54080e7          	jalr	-684(ra) # 80006292 <release>
  acquire(lk);
    80001546:	854a                	mv	a0,s2
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	c96080e7          	jalr	-874(ra) # 800061de <acquire>
}
    80001550:	70a2                	ld	ra,40(sp)
    80001552:	7402                	ld	s0,32(sp)
    80001554:	64e2                	ld	s1,24(sp)
    80001556:	6942                	ld	s2,16(sp)
    80001558:	69a2                	ld	s3,8(sp)
    8000155a:	6145                	addi	sp,sp,48
    8000155c:	8082                	ret

000000008000155e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000155e:	7179                	addi	sp,sp,-48
    80001560:	f406                	sd	ra,40(sp)
    80001562:	f022                	sd	s0,32(sp)
    80001564:	ec26                	sd	s1,24(sp)
    80001566:	e84a                	sd	s2,16(sp)
    80001568:	e44e                	sd	s3,8(sp)
    8000156a:	e052                	sd	s4,0(sp)
    8000156c:	1800                	addi	s0,sp,48
    8000156e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001570:	00007497          	auipc	s1,0x7
    80001574:	7a048493          	addi	s1,s1,1952 # 80008d10 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001578:	4989                	li	s3,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000157a:	00008917          	auipc	s2,0x8
    8000157e:	5a690913          	addi	s2,s2,1446 # 80009b20 <tickslock>
    80001582:	a811                	j	80001596 <wakeup+0x38>
        p->state = RUNNABLE;
      }
      release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	d0c080e7          	jalr	-756(ra) # 80006292 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000158e:	16848493          	addi	s1,s1,360
    80001592:	03248663          	beq	s1,s2,800015be <wakeup+0x60>
    if(p != myproc()){
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	8bc080e7          	jalr	-1860(ra) # 80000e52 <myproc>
    8000159e:	fea488e3          	beq	s1,a0,8000158e <wakeup+0x30>
      acquire(&p->lock);
    800015a2:	8526                	mv	a0,s1
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	c3a080e7          	jalr	-966(ra) # 800061de <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015ac:	4c9c                	lw	a5,24(s1)
    800015ae:	fd379be3          	bne	a5,s3,80001584 <wakeup+0x26>
    800015b2:	709c                	ld	a5,32(s1)
    800015b4:	fd4798e3          	bne	a5,s4,80001584 <wakeup+0x26>
        p->state = RUNNABLE;
    800015b8:	478d                	li	a5,3
    800015ba:	cc9c                	sw	a5,24(s1)
    800015bc:	b7e1                	j	80001584 <wakeup+0x26>
    }
  }
}
    800015be:	70a2                	ld	ra,40(sp)
    800015c0:	7402                	ld	s0,32(sp)
    800015c2:	64e2                	ld	s1,24(sp)
    800015c4:	6942                	ld	s2,16(sp)
    800015c6:	69a2                	ld	s3,8(sp)
    800015c8:	6a02                	ld	s4,0(sp)
    800015ca:	6145                	addi	sp,sp,48
    800015cc:	8082                	ret

00000000800015ce <reparent>:
{
    800015ce:	7179                	addi	sp,sp,-48
    800015d0:	f406                	sd	ra,40(sp)
    800015d2:	f022                	sd	s0,32(sp)
    800015d4:	ec26                	sd	s1,24(sp)
    800015d6:	e84a                	sd	s2,16(sp)
    800015d8:	e44e                	sd	s3,8(sp)
    800015da:	e052                	sd	s4,0(sp)
    800015dc:	1800                	addi	s0,sp,48
    800015de:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015e0:	00007497          	auipc	s1,0x7
    800015e4:	73048493          	addi	s1,s1,1840 # 80008d10 <proc>
      pp->parent = initproc;
    800015e8:	00007a17          	auipc	s4,0x7
    800015ec:	2b8a0a13          	addi	s4,s4,696 # 800088a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f0:	00008997          	auipc	s3,0x8
    800015f4:	53098993          	addi	s3,s3,1328 # 80009b20 <tickslock>
    800015f8:	a029                	j	80001602 <reparent+0x34>
    800015fa:	16848493          	addi	s1,s1,360
    800015fe:	01348d63          	beq	s1,s3,80001618 <reparent+0x4a>
    if(pp->parent == p){
    80001602:	7c9c                	ld	a5,56(s1)
    80001604:	ff279be3          	bne	a5,s2,800015fa <reparent+0x2c>
      pp->parent = initproc;
    80001608:	000a3503          	ld	a0,0(s4)
    8000160c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	f50080e7          	jalr	-176(ra) # 8000155e <wakeup>
    80001616:	b7d5                	j	800015fa <reparent+0x2c>
}
    80001618:	70a2                	ld	ra,40(sp)
    8000161a:	7402                	ld	s0,32(sp)
    8000161c:	64e2                	ld	s1,24(sp)
    8000161e:	6942                	ld	s2,16(sp)
    80001620:	69a2                	ld	s3,8(sp)
    80001622:	6a02                	ld	s4,0(sp)
    80001624:	6145                	addi	sp,sp,48
    80001626:	8082                	ret

0000000080001628 <exit>:
{
    80001628:	7179                	addi	sp,sp,-48
    8000162a:	f406                	sd	ra,40(sp)
    8000162c:	f022                	sd	s0,32(sp)
    8000162e:	ec26                	sd	s1,24(sp)
    80001630:	e84a                	sd	s2,16(sp)
    80001632:	e44e                	sd	s3,8(sp)
    80001634:	e052                	sd	s4,0(sp)
    80001636:	1800                	addi	s0,sp,48
    80001638:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000163a:	00000097          	auipc	ra,0x0
    8000163e:	818080e7          	jalr	-2024(ra) # 80000e52 <myproc>
    80001642:	89aa                	mv	s3,a0
  if(p == initproc)
    80001644:	00007797          	auipc	a5,0x7
    80001648:	25c7b783          	ld	a5,604(a5) # 800088a0 <initproc>
    8000164c:	0d050493          	addi	s1,a0,208
    80001650:	15050913          	addi	s2,a0,336
    80001654:	02a79363          	bne	a5,a0,8000167a <exit+0x52>
    panic("init exiting");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b8850513          	addi	a0,a0,-1144 # 800081e0 <etext+0x1e0>
    80001660:	00004097          	auipc	ra,0x4
    80001664:	646080e7          	jalr	1606(ra) # 80005ca6 <panic>
      fileclose(f);
    80001668:	00002097          	auipc	ra,0x2
    8000166c:	452080e7          	jalr	1106(ra) # 80003aba <fileclose>
      p->ofile[fd] = 0;
    80001670:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001674:	04a1                	addi	s1,s1,8
    80001676:	01248563          	beq	s1,s2,80001680 <exit+0x58>
    if(p->ofile[fd]){
    8000167a:	6088                	ld	a0,0(s1)
    8000167c:	f575                	bnez	a0,80001668 <exit+0x40>
    8000167e:	bfdd                	j	80001674 <exit+0x4c>
  begin_op();
    80001680:	00002097          	auipc	ra,0x2
    80001684:	f76080e7          	jalr	-138(ra) # 800035f6 <begin_op>
  iput(p->cwd);
    80001688:	1509b503          	ld	a0,336(s3)
    8000168c:	00001097          	auipc	ra,0x1
    80001690:	77c080e7          	jalr	1916(ra) # 80002e08 <iput>
  end_op();
    80001694:	00002097          	auipc	ra,0x2
    80001698:	fdc080e7          	jalr	-36(ra) # 80003670 <end_op>
  p->cwd = 0;
    8000169c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a0:	00007497          	auipc	s1,0x7
    800016a4:	25848493          	addi	s1,s1,600 # 800088f8 <wait_lock>
    800016a8:	8526                	mv	a0,s1
    800016aa:	00005097          	auipc	ra,0x5
    800016ae:	b34080e7          	jalr	-1228(ra) # 800061de <acquire>
  reparent(p);
    800016b2:	854e                	mv	a0,s3
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	f1a080e7          	jalr	-230(ra) # 800015ce <reparent>
  wakeup(p->parent);
    800016bc:	0389b503          	ld	a0,56(s3)
    800016c0:	00000097          	auipc	ra,0x0
    800016c4:	e9e080e7          	jalr	-354(ra) # 8000155e <wakeup>
  acquire(&p->lock);
    800016c8:	854e                	mv	a0,s3
    800016ca:	00005097          	auipc	ra,0x5
    800016ce:	b14080e7          	jalr	-1260(ra) # 800061de <acquire>
  p->xstate = status;
    800016d2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016d6:	4795                	li	a5,5
    800016d8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	bb4080e7          	jalr	-1100(ra) # 80006292 <release>
  sched();
    800016e6:	00000097          	auipc	ra,0x0
    800016ea:	d02080e7          	jalr	-766(ra) # 800013e8 <sched>
  panic("zombie exit");
    800016ee:	00007517          	auipc	a0,0x7
    800016f2:	b0250513          	addi	a0,a0,-1278 # 800081f0 <etext+0x1f0>
    800016f6:	00004097          	auipc	ra,0x4
    800016fa:	5b0080e7          	jalr	1456(ra) # 80005ca6 <panic>

00000000800016fe <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800016fe:	7179                	addi	sp,sp,-48
    80001700:	f406                	sd	ra,40(sp)
    80001702:	f022                	sd	s0,32(sp)
    80001704:	ec26                	sd	s1,24(sp)
    80001706:	e84a                	sd	s2,16(sp)
    80001708:	e44e                	sd	s3,8(sp)
    8000170a:	1800                	addi	s0,sp,48
    8000170c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000170e:	00007497          	auipc	s1,0x7
    80001712:	60248493          	addi	s1,s1,1538 # 80008d10 <proc>
    80001716:	00008997          	auipc	s3,0x8
    8000171a:	40a98993          	addi	s3,s3,1034 # 80009b20 <tickslock>
    acquire(&p->lock);
    8000171e:	8526                	mv	a0,s1
    80001720:	00005097          	auipc	ra,0x5
    80001724:	abe080e7          	jalr	-1346(ra) # 800061de <acquire>
    if(p->pid == pid){
    80001728:	589c                	lw	a5,48(s1)
    8000172a:	03278363          	beq	a5,s2,80001750 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	b62080e7          	jalr	-1182(ra) # 80006292 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001738:	16848493          	addi	s1,s1,360
    8000173c:	ff3491e3          	bne	s1,s3,8000171e <kill+0x20>
  }
  return -1;
    80001740:	557d                	li	a0,-1
}
    80001742:	70a2                	ld	ra,40(sp)
    80001744:	7402                	ld	s0,32(sp)
    80001746:	64e2                	ld	s1,24(sp)
    80001748:	6942                	ld	s2,16(sp)
    8000174a:	69a2                	ld	s3,8(sp)
    8000174c:	6145                	addi	sp,sp,48
    8000174e:	8082                	ret
      p->killed = 1;
    80001750:	4785                	li	a5,1
    80001752:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001754:	4c98                	lw	a4,24(s1)
    80001756:	4789                	li	a5,2
    80001758:	00f70963          	beq	a4,a5,8000176a <kill+0x6c>
      release(&p->lock);
    8000175c:	8526                	mv	a0,s1
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	b34080e7          	jalr	-1228(ra) # 80006292 <release>
      return 0;
    80001766:	4501                	li	a0,0
    80001768:	bfe9                	j	80001742 <kill+0x44>
        p->state = RUNNABLE;
    8000176a:	478d                	li	a5,3
    8000176c:	cc9c                	sw	a5,24(s1)
    8000176e:	b7fd                	j	8000175c <kill+0x5e>

0000000080001770 <setkilled>:

void
setkilled(struct proc *p)
{
    80001770:	1101                	addi	sp,sp,-32
    80001772:	ec06                	sd	ra,24(sp)
    80001774:	e822                	sd	s0,16(sp)
    80001776:	e426                	sd	s1,8(sp)
    80001778:	1000                	addi	s0,sp,32
    8000177a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	a62080e7          	jalr	-1438(ra) # 800061de <acquire>
  p->killed = 1;
    80001784:	4785                	li	a5,1
    80001786:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001788:	8526                	mv	a0,s1
    8000178a:	00005097          	auipc	ra,0x5
    8000178e:	b08080e7          	jalr	-1272(ra) # 80006292 <release>
}
    80001792:	60e2                	ld	ra,24(sp)
    80001794:	6442                	ld	s0,16(sp)
    80001796:	64a2                	ld	s1,8(sp)
    80001798:	6105                	addi	sp,sp,32
    8000179a:	8082                	ret

000000008000179c <killed>:

int
killed(struct proc *p)
{
    8000179c:	1101                	addi	sp,sp,-32
    8000179e:	ec06                	sd	ra,24(sp)
    800017a0:	e822                	sd	s0,16(sp)
    800017a2:	e426                	sd	s1,8(sp)
    800017a4:	e04a                	sd	s2,0(sp)
    800017a6:	1000                	addi	s0,sp,32
    800017a8:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	a34080e7          	jalr	-1484(ra) # 800061de <acquire>
  k = p->killed;
    800017b2:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017b6:	8526                	mv	a0,s1
    800017b8:	00005097          	auipc	ra,0x5
    800017bc:	ada080e7          	jalr	-1318(ra) # 80006292 <release>
  return k;
}
    800017c0:	854a                	mv	a0,s2
    800017c2:	60e2                	ld	ra,24(sp)
    800017c4:	6442                	ld	s0,16(sp)
    800017c6:	64a2                	ld	s1,8(sp)
    800017c8:	6902                	ld	s2,0(sp)
    800017ca:	6105                	addi	sp,sp,32
    800017cc:	8082                	ret

00000000800017ce <wait>:
{
    800017ce:	715d                	addi	sp,sp,-80
    800017d0:	e486                	sd	ra,72(sp)
    800017d2:	e0a2                	sd	s0,64(sp)
    800017d4:	fc26                	sd	s1,56(sp)
    800017d6:	f84a                	sd	s2,48(sp)
    800017d8:	f44e                	sd	s3,40(sp)
    800017da:	f052                	sd	s4,32(sp)
    800017dc:	ec56                	sd	s5,24(sp)
    800017de:	e85a                	sd	s6,16(sp)
    800017e0:	e45e                	sd	s7,8(sp)
    800017e2:	e062                	sd	s8,0(sp)
    800017e4:	0880                	addi	s0,sp,80
    800017e6:	8c2a                	mv	s8,a0
  struct proc *p = myproc();
    800017e8:	fffff097          	auipc	ra,0xfffff
    800017ec:	66a080e7          	jalr	1642(ra) # 80000e52 <myproc>
    800017f0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017f2:	00007517          	auipc	a0,0x7
    800017f6:	10650513          	addi	a0,a0,262 # 800088f8 <wait_lock>
    800017fa:	00005097          	auipc	ra,0x5
    800017fe:	9e4080e7          	jalr	-1564(ra) # 800061de <acquire>
    havekids = 0;
    80001802:	4b01                	li	s6,0
        if(pp->state == ZOMBIE){
    80001804:	4a15                	li	s4,5
        havekids = 1;
    80001806:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001808:	00008997          	auipc	s3,0x8
    8000180c:	31898993          	addi	s3,s3,792 # 80009b20 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001810:	00007b97          	auipc	s7,0x7
    80001814:	0e8b8b93          	addi	s7,s7,232 # 800088f8 <wait_lock>
    80001818:	a0d1                	j	800018dc <wait+0x10e>
          pid = pp->pid;
    8000181a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000181e:	000c0e63          	beqz	s8,8000183a <wait+0x6c>
    80001822:	4691                	li	a3,4
    80001824:	02c48613          	addi	a2,s1,44
    80001828:	85e2                	mv	a1,s8
    8000182a:	05093503          	ld	a0,80(s2)
    8000182e:	fffff097          	auipc	ra,0xfffff
    80001832:	2e4080e7          	jalr	740(ra) # 80000b12 <copyout>
    80001836:	04054163          	bltz	a0,80001878 <wait+0xaa>
          freeproc(pp);
    8000183a:	8526                	mv	a0,s1
    8000183c:	fffff097          	auipc	ra,0xfffff
    80001840:	7c8080e7          	jalr	1992(ra) # 80001004 <freeproc>
          release(&pp->lock);
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	a4c080e7          	jalr	-1460(ra) # 80006292 <release>
          release(&wait_lock);
    8000184e:	00007517          	auipc	a0,0x7
    80001852:	0aa50513          	addi	a0,a0,170 # 800088f8 <wait_lock>
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	a3c080e7          	jalr	-1476(ra) # 80006292 <release>
}
    8000185e:	854e                	mv	a0,s3
    80001860:	60a6                	ld	ra,72(sp)
    80001862:	6406                	ld	s0,64(sp)
    80001864:	74e2                	ld	s1,56(sp)
    80001866:	7942                	ld	s2,48(sp)
    80001868:	79a2                	ld	s3,40(sp)
    8000186a:	7a02                	ld	s4,32(sp)
    8000186c:	6ae2                	ld	s5,24(sp)
    8000186e:	6b42                	ld	s6,16(sp)
    80001870:	6ba2                	ld	s7,8(sp)
    80001872:	6c02                	ld	s8,0(sp)
    80001874:	6161                	addi	sp,sp,80
    80001876:	8082                	ret
            release(&pp->lock);
    80001878:	8526                	mv	a0,s1
    8000187a:	00005097          	auipc	ra,0x5
    8000187e:	a18080e7          	jalr	-1512(ra) # 80006292 <release>
            release(&wait_lock);
    80001882:	00007517          	auipc	a0,0x7
    80001886:	07650513          	addi	a0,a0,118 # 800088f8 <wait_lock>
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	a08080e7          	jalr	-1528(ra) # 80006292 <release>
            return -1;
    80001892:	59fd                	li	s3,-1
    80001894:	b7e9                	j	8000185e <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001896:	16848493          	addi	s1,s1,360
    8000189a:	03348463          	beq	s1,s3,800018c2 <wait+0xf4>
      if(pp->parent == p){
    8000189e:	7c9c                	ld	a5,56(s1)
    800018a0:	ff279be3          	bne	a5,s2,80001896 <wait+0xc8>
        acquire(&pp->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	938080e7          	jalr	-1736(ra) # 800061de <acquire>
        if(pp->state == ZOMBIE){
    800018ae:	4c9c                	lw	a5,24(s1)
    800018b0:	f74785e3          	beq	a5,s4,8000181a <wait+0x4c>
        release(&pp->lock);
    800018b4:	8526                	mv	a0,s1
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	9dc080e7          	jalr	-1572(ra) # 80006292 <release>
        havekids = 1;
    800018be:	8756                	mv	a4,s5
    800018c0:	bfd9                	j	80001896 <wait+0xc8>
    if(!havekids || killed(p)){
    800018c2:	c31d                	beqz	a4,800018e8 <wait+0x11a>
    800018c4:	854a                	mv	a0,s2
    800018c6:	00000097          	auipc	ra,0x0
    800018ca:	ed6080e7          	jalr	-298(ra) # 8000179c <killed>
    800018ce:	ed09                	bnez	a0,800018e8 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018d0:	85de                	mv	a1,s7
    800018d2:	854a                	mv	a0,s2
    800018d4:	00000097          	auipc	ra,0x0
    800018d8:	c26080e7          	jalr	-986(ra) # 800014fa <sleep>
    havekids = 0;
    800018dc:	875a                	mv	a4,s6
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018de:	00007497          	auipc	s1,0x7
    800018e2:	43248493          	addi	s1,s1,1074 # 80008d10 <proc>
    800018e6:	bf65                	j	8000189e <wait+0xd0>
      release(&wait_lock);
    800018e8:	00007517          	auipc	a0,0x7
    800018ec:	01050513          	addi	a0,a0,16 # 800088f8 <wait_lock>
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	9a2080e7          	jalr	-1630(ra) # 80006292 <release>
      return -1;
    800018f8:	59fd                	li	s3,-1
    800018fa:	b795                	j	8000185e <wait+0x90>

00000000800018fc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fc:	7179                	addi	sp,sp,-48
    800018fe:	f406                	sd	ra,40(sp)
    80001900:	f022                	sd	s0,32(sp)
    80001902:	ec26                	sd	s1,24(sp)
    80001904:	e84a                	sd	s2,16(sp)
    80001906:	e44e                	sd	s3,8(sp)
    80001908:	e052                	sd	s4,0(sp)
    8000190a:	1800                	addi	s0,sp,48
    8000190c:	84aa                	mv	s1,a0
    8000190e:	892e                	mv	s2,a1
    80001910:	89b2                	mv	s3,a2
    80001912:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	53e080e7          	jalr	1342(ra) # 80000e52 <myproc>
  if(user_dst){
    8000191c:	c08d                	beqz	s1,8000193e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191e:	86d2                	mv	a3,s4
    80001920:	864e                	mv	a2,s3
    80001922:	85ca                	mv	a1,s2
    80001924:	6928                	ld	a0,80(a0)
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	1ec080e7          	jalr	492(ra) # 80000b12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192e:	70a2                	ld	ra,40(sp)
    80001930:	7402                	ld	s0,32(sp)
    80001932:	64e2                	ld	s1,24(sp)
    80001934:	6942                	ld	s2,16(sp)
    80001936:	69a2                	ld	s3,8(sp)
    80001938:	6a02                	ld	s4,0(sp)
    8000193a:	6145                	addi	sp,sp,48
    8000193c:	8082                	ret
    memmove((char *)dst, src, len);
    8000193e:	000a061b          	sext.w	a2,s4
    80001942:	85ce                	mv	a1,s3
    80001944:	854a                	mv	a0,s2
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	890080e7          	jalr	-1904(ra) # 800001d6 <memmove>
    return 0;
    8000194e:	8526                	mv	a0,s1
    80001950:	bff9                	j	8000192e <either_copyout+0x32>

0000000080001952 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001952:	7179                	addi	sp,sp,-48
    80001954:	f406                	sd	ra,40(sp)
    80001956:	f022                	sd	s0,32(sp)
    80001958:	ec26                	sd	s1,24(sp)
    8000195a:	e84a                	sd	s2,16(sp)
    8000195c:	e44e                	sd	s3,8(sp)
    8000195e:	e052                	sd	s4,0(sp)
    80001960:	1800                	addi	s0,sp,48
    80001962:	892a                	mv	s2,a0
    80001964:	84ae                	mv	s1,a1
    80001966:	89b2                	mv	s3,a2
    80001968:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	4e8080e7          	jalr	1256(ra) # 80000e52 <myproc>
  if(user_src){
    80001972:	c08d                	beqz	s1,80001994 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001974:	86d2                	mv	a3,s4
    80001976:	864e                	mv	a2,s3
    80001978:	85ca                	mv	a1,s2
    8000197a:	6928                	ld	a0,80(a0)
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	222080e7          	jalr	546(ra) # 80000b9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001984:	70a2                	ld	ra,40(sp)
    80001986:	7402                	ld	s0,32(sp)
    80001988:	64e2                	ld	s1,24(sp)
    8000198a:	6942                	ld	s2,16(sp)
    8000198c:	69a2                	ld	s3,8(sp)
    8000198e:	6a02                	ld	s4,0(sp)
    80001990:	6145                	addi	sp,sp,48
    80001992:	8082                	ret
    memmove(dst, (char*)src, len);
    80001994:	000a061b          	sext.w	a2,s4
    80001998:	85ce                	mv	a1,s3
    8000199a:	854a                	mv	a0,s2
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	83a080e7          	jalr	-1990(ra) # 800001d6 <memmove>
    return 0;
    800019a4:	8526                	mv	a0,s1
    800019a6:	bff9                	j	80001984 <either_copyin+0x32>

00000000800019a8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a8:	715d                	addi	sp,sp,-80
    800019aa:	e486                	sd	ra,72(sp)
    800019ac:	e0a2                	sd	s0,64(sp)
    800019ae:	fc26                	sd	s1,56(sp)
    800019b0:	f84a                	sd	s2,48(sp)
    800019b2:	f44e                	sd	s3,40(sp)
    800019b4:	f052                	sd	s4,32(sp)
    800019b6:	ec56                	sd	s5,24(sp)
    800019b8:	e85a                	sd	s6,16(sp)
    800019ba:	e45e                	sd	s7,8(sp)
    800019bc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019be:	00006517          	auipc	a0,0x6
    800019c2:	68a50513          	addi	a0,a0,1674 # 80008048 <etext+0x48>
    800019c6:	00004097          	auipc	ra,0x4
    800019ca:	32a080e7          	jalr	810(ra) # 80005cf0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ce:	00007497          	auipc	s1,0x7
    800019d2:	49a48493          	addi	s1,s1,1178 # 80008e68 <proc+0x158>
    800019d6:	00008917          	auipc	s2,0x8
    800019da:	2a290913          	addi	s2,s2,674 # 80009c78 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019de:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e0:	00007997          	auipc	s3,0x7
    800019e4:	82098993          	addi	s3,s3,-2016 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e8:	00007a97          	auipc	s5,0x7
    800019ec:	820a8a93          	addi	s5,s5,-2016 # 80008208 <etext+0x208>
    printf("\n");
    800019f0:	00006a17          	auipc	s4,0x6
    800019f4:	658a0a13          	addi	s4,s4,1624 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f8:	00007b97          	auipc	s7,0x7
    800019fc:	850b8b93          	addi	s7,s7,-1968 # 80008248 <states.0>
    80001a00:	a00d                	j	80001a22 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a02:	ed86a583          	lw	a1,-296(a3)
    80001a06:	8556                	mv	a0,s5
    80001a08:	00004097          	auipc	ra,0x4
    80001a0c:	2e8080e7          	jalr	744(ra) # 80005cf0 <printf>
    printf("\n");
    80001a10:	8552                	mv	a0,s4
    80001a12:	00004097          	auipc	ra,0x4
    80001a16:	2de080e7          	jalr	734(ra) # 80005cf0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1a:	16848493          	addi	s1,s1,360
    80001a1e:	03248263          	beq	s1,s2,80001a42 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a22:	86a6                	mv	a3,s1
    80001a24:	ec04a783          	lw	a5,-320(s1)
    80001a28:	dbed                	beqz	a5,80001a1a <procdump+0x72>
      state = "???";
    80001a2a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2c:	fcfb6be3          	bltu	s6,a5,80001a02 <procdump+0x5a>
    80001a30:	02079713          	slli	a4,a5,0x20
    80001a34:	01d75793          	srli	a5,a4,0x1d
    80001a38:	97de                	add	a5,a5,s7
    80001a3a:	6390                	ld	a2,0(a5)
    80001a3c:	f279                	bnez	a2,80001a02 <procdump+0x5a>
      state = "???";
    80001a3e:	864e                	mv	a2,s3
    80001a40:	b7c9                	j	80001a02 <procdump+0x5a>
  }
}
    80001a42:	60a6                	ld	ra,72(sp)
    80001a44:	6406                	ld	s0,64(sp)
    80001a46:	74e2                	ld	s1,56(sp)
    80001a48:	7942                	ld	s2,48(sp)
    80001a4a:	79a2                	ld	s3,40(sp)
    80001a4c:	7a02                	ld	s4,32(sp)
    80001a4e:	6ae2                	ld	s5,24(sp)
    80001a50:	6b42                	ld	s6,16(sp)
    80001a52:	6ba2                	ld	s7,8(sp)
    80001a54:	6161                	addi	sp,sp,80
    80001a56:	8082                	ret

0000000080001a58 <swtch>:
    80001a58:	00153023          	sd	ra,0(a0)
    80001a5c:	00253423          	sd	sp,8(a0)
    80001a60:	e900                	sd	s0,16(a0)
    80001a62:	ed04                	sd	s1,24(a0)
    80001a64:	03253023          	sd	s2,32(a0)
    80001a68:	03353423          	sd	s3,40(a0)
    80001a6c:	03453823          	sd	s4,48(a0)
    80001a70:	03553c23          	sd	s5,56(a0)
    80001a74:	05653023          	sd	s6,64(a0)
    80001a78:	05753423          	sd	s7,72(a0)
    80001a7c:	05853823          	sd	s8,80(a0)
    80001a80:	05953c23          	sd	s9,88(a0)
    80001a84:	07a53023          	sd	s10,96(a0)
    80001a88:	07b53423          	sd	s11,104(a0)
    80001a8c:	0005b083          	ld	ra,0(a1)
    80001a90:	0085b103          	ld	sp,8(a1)
    80001a94:	6980                	ld	s0,16(a1)
    80001a96:	6d84                	ld	s1,24(a1)
    80001a98:	0205b903          	ld	s2,32(a1)
    80001a9c:	0285b983          	ld	s3,40(a1)
    80001aa0:	0305ba03          	ld	s4,48(a1)
    80001aa4:	0385ba83          	ld	s5,56(a1)
    80001aa8:	0405bb03          	ld	s6,64(a1)
    80001aac:	0485bb83          	ld	s7,72(a1)
    80001ab0:	0505bc03          	ld	s8,80(a1)
    80001ab4:	0585bc83          	ld	s9,88(a1)
    80001ab8:	0605bd03          	ld	s10,96(a1)
    80001abc:	0685bd83          	ld	s11,104(a1)
    80001ac0:	8082                	ret

0000000080001ac2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac2:	1141                	addi	sp,sp,-16
    80001ac4:	e406                	sd	ra,8(sp)
    80001ac6:	e022                	sd	s0,0(sp)
    80001ac8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001aca:	00006597          	auipc	a1,0x6
    80001ace:	7ae58593          	addi	a1,a1,1966 # 80008278 <states.0+0x30>
    80001ad2:	00008517          	auipc	a0,0x8
    80001ad6:	04e50513          	addi	a0,a0,78 # 80009b20 <tickslock>
    80001ada:	00004097          	auipc	ra,0x4
    80001ade:	674080e7          	jalr	1652(ra) # 8000614e <initlock>
}
    80001ae2:	60a2                	ld	ra,8(sp)
    80001ae4:	6402                	ld	s0,0(sp)
    80001ae6:	0141                	addi	sp,sp,16
    80001ae8:	8082                	ret

0000000080001aea <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aea:	1141                	addi	sp,sp,-16
    80001aec:	e422                	sd	s0,8(sp)
    80001aee:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af0:	00003797          	auipc	a5,0x3
    80001af4:	5f078793          	addi	a5,a5,1520 # 800050e0 <kernelvec>
    80001af8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001afc:	6422                	ld	s0,8(sp)
    80001afe:	0141                	addi	sp,sp,16
    80001b00:	8082                	ret

0000000080001b02 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b02:	1141                	addi	sp,sp,-16
    80001b04:	e406                	sd	ra,8(sp)
    80001b06:	e022                	sd	s0,0(sp)
    80001b08:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b0a:	fffff097          	auipc	ra,0xfffff
    80001b0e:	348080e7          	jalr	840(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b12:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b16:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b18:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b1c:	00005697          	auipc	a3,0x5
    80001b20:	4e468693          	addi	a3,a3,1252 # 80007000 <_trampoline>
    80001b24:	00005717          	auipc	a4,0x5
    80001b28:	4dc70713          	addi	a4,a4,1244 # 80007000 <_trampoline>
    80001b2c:	8f15                	sub	a4,a4,a3
    80001b2e:	040007b7          	lui	a5,0x4000
    80001b32:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b34:	07b2                	slli	a5,a5,0xc
    80001b36:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b38:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b3c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b3e:	18002673          	csrr	a2,satp
    80001b42:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b44:	6d30                	ld	a2,88(a0)
    80001b46:	6138                	ld	a4,64(a0)
    80001b48:	6585                	lui	a1,0x1
    80001b4a:	972e                	add	a4,a4,a1
    80001b4c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b4e:	6d38                	ld	a4,88(a0)
    80001b50:	00000617          	auipc	a2,0x0
    80001b54:	13460613          	addi	a2,a2,308 # 80001c84 <usertrap>
    80001b58:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b5a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b5c:	8612                	mv	a2,tp
    80001b5e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b60:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b64:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b68:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b70:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b72:	6f18                	ld	a4,24(a4)
    80001b74:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b78:	6928                	ld	a0,80(a0)
    80001b7a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b7c:	00005717          	auipc	a4,0x5
    80001b80:	52070713          	addi	a4,a4,1312 # 8000709c <userret>
    80001b84:	8f15                	sub	a4,a4,a3
    80001b86:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b88:	577d                	li	a4,-1
    80001b8a:	177e                	slli	a4,a4,0x3f
    80001b8c:	8d59                	or	a0,a0,a4
    80001b8e:	9782                	jalr	a5
}
    80001b90:	60a2                	ld	ra,8(sp)
    80001b92:	6402                	ld	s0,0(sp)
    80001b94:	0141                	addi	sp,sp,16
    80001b96:	8082                	ret

0000000080001b98 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b98:	1101                	addi	sp,sp,-32
    80001b9a:	ec06                	sd	ra,24(sp)
    80001b9c:	e822                	sd	s0,16(sp)
    80001b9e:	e426                	sd	s1,8(sp)
    80001ba0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba2:	00008497          	auipc	s1,0x8
    80001ba6:	f7e48493          	addi	s1,s1,-130 # 80009b20 <tickslock>
    80001baa:	8526                	mv	a0,s1
    80001bac:	00004097          	auipc	ra,0x4
    80001bb0:	632080e7          	jalr	1586(ra) # 800061de <acquire>
  ticks++;
    80001bb4:	00007517          	auipc	a0,0x7
    80001bb8:	cf450513          	addi	a0,a0,-780 # 800088a8 <ticks>
    80001bbc:	411c                	lw	a5,0(a0)
    80001bbe:	2785                	addiw	a5,a5,1
    80001bc0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc2:	00000097          	auipc	ra,0x0
    80001bc6:	99c080e7          	jalr	-1636(ra) # 8000155e <wakeup>
  release(&tickslock);
    80001bca:	8526                	mv	a0,s1
    80001bcc:	00004097          	auipc	ra,0x4
    80001bd0:	6c6080e7          	jalr	1734(ra) # 80006292 <release>
}
    80001bd4:	60e2                	ld	ra,24(sp)
    80001bd6:	6442                	ld	s0,16(sp)
    80001bd8:	64a2                	ld	s1,8(sp)
    80001bda:	6105                	addi	sp,sp,32
    80001bdc:	8082                	ret

0000000080001bde <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bde:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001be2:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001be4:	0807df63          	bgez	a5,80001c82 <devintr+0xa4>
{
    80001be8:	1101                	addi	sp,sp,-32
    80001bea:	ec06                	sd	ra,24(sp)
    80001bec:	e822                	sd	s0,16(sp)
    80001bee:	e426                	sd	s1,8(sp)
    80001bf0:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001bf2:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001bf6:	46a5                	li	a3,9
    80001bf8:	00d70d63          	beq	a4,a3,80001c12 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001bfc:	577d                	li	a4,-1
    80001bfe:	177e                	slli	a4,a4,0x3f
    80001c00:	0705                	addi	a4,a4,1
    return 0;
    80001c02:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c04:	04e78e63          	beq	a5,a4,80001c60 <devintr+0x82>
  }
}
    80001c08:	60e2                	ld	ra,24(sp)
    80001c0a:	6442                	ld	s0,16(sp)
    80001c0c:	64a2                	ld	s1,8(sp)
    80001c0e:	6105                	addi	sp,sp,32
    80001c10:	8082                	ret
    int irq = plic_claim();
    80001c12:	00003097          	auipc	ra,0x3
    80001c16:	5d6080e7          	jalr	1494(ra) # 800051e8 <plic_claim>
    80001c1a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c1c:	47a9                	li	a5,10
    80001c1e:	02f50763          	beq	a0,a5,80001c4c <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001c22:	4785                	li	a5,1
    80001c24:	02f50963          	beq	a0,a5,80001c56 <devintr+0x78>
    return 1;
    80001c28:	4505                	li	a0,1
    } else if(irq){
    80001c2a:	dcf9                	beqz	s1,80001c08 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2c:	85a6                	mv	a1,s1
    80001c2e:	00006517          	auipc	a0,0x6
    80001c32:	65250513          	addi	a0,a0,1618 # 80008280 <states.0+0x38>
    80001c36:	00004097          	auipc	ra,0x4
    80001c3a:	0ba080e7          	jalr	186(ra) # 80005cf0 <printf>
      plic_complete(irq);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	00003097          	auipc	ra,0x3
    80001c44:	5cc080e7          	jalr	1484(ra) # 8000520c <plic_complete>
    return 1;
    80001c48:	4505                	li	a0,1
    80001c4a:	bf7d                	j	80001c08 <devintr+0x2a>
      uartintr();
    80001c4c:	00004097          	auipc	ra,0x4
    80001c50:	4b2080e7          	jalr	1202(ra) # 800060fe <uartintr>
    if(irq)
    80001c54:	b7ed                	j	80001c3e <devintr+0x60>
      virtio_disk_intr();
    80001c56:	00004097          	auipc	ra,0x4
    80001c5a:	a7c080e7          	jalr	-1412(ra) # 800056d2 <virtio_disk_intr>
    if(irq)
    80001c5e:	b7c5                	j	80001c3e <devintr+0x60>
    if(cpuid() == 0){
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	1c6080e7          	jalr	454(ra) # 80000e26 <cpuid>
    80001c68:	c901                	beqz	a0,80001c78 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c6a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c6e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c70:	14479073          	csrw	sip,a5
    return 2;
    80001c74:	4509                	li	a0,2
    80001c76:	bf49                	j	80001c08 <devintr+0x2a>
      clockintr();
    80001c78:	00000097          	auipc	ra,0x0
    80001c7c:	f20080e7          	jalr	-224(ra) # 80001b98 <clockintr>
    80001c80:	b7ed                	j	80001c6a <devintr+0x8c>
}
    80001c82:	8082                	ret

0000000080001c84 <usertrap>:
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	e426                	sd	s1,8(sp)
    80001c8c:	e04a                	sd	s2,0(sp)
    80001c8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c90:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c94:	1007f793          	andi	a5,a5,256
    80001c98:	e3b1                	bnez	a5,80001cdc <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c9a:	00003797          	auipc	a5,0x3
    80001c9e:	44678793          	addi	a5,a5,1094 # 800050e0 <kernelvec>
    80001ca2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ca6:	fffff097          	auipc	ra,0xfffff
    80001caa:	1ac080e7          	jalr	428(ra) # 80000e52 <myproc>
    80001cae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb2:	14102773          	csrr	a4,sepc
    80001cb6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cbc:	47a1                	li	a5,8
    80001cbe:	02f70763          	beq	a4,a5,80001cec <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	f1c080e7          	jalr	-228(ra) # 80001bde <devintr>
    80001cca:	892a                	mv	s2,a0
    80001ccc:	c151                	beqz	a0,80001d50 <usertrap+0xcc>
  if(killed(p))
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	acc080e7          	jalr	-1332(ra) # 8000179c <killed>
    80001cd8:	c929                	beqz	a0,80001d2a <usertrap+0xa6>
    80001cda:	a099                	j	80001d20 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5c450513          	addi	a0,a0,1476 # 800082a0 <states.0+0x58>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	fc2080e7          	jalr	-62(ra) # 80005ca6 <panic>
    if(killed(p))
    80001cec:	00000097          	auipc	ra,0x0
    80001cf0:	ab0080e7          	jalr	-1360(ra) # 8000179c <killed>
    80001cf4:	e921                	bnez	a0,80001d44 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cf6:	6cb8                	ld	a4,88(s1)
    80001cf8:	6f1c                	ld	a5,24(a4)
    80001cfa:	0791                	addi	a5,a5,4
    80001cfc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cfe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d02:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d06:	10079073          	csrw	sstatus,a5
    syscall();
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	2d4080e7          	jalr	724(ra) # 80001fde <syscall>
  if(killed(p))
    80001d12:	8526                	mv	a0,s1
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	a88080e7          	jalr	-1400(ra) # 8000179c <killed>
    80001d1c:	c911                	beqz	a0,80001d30 <usertrap+0xac>
    80001d1e:	4901                	li	s2,0
    exit(-1);
    80001d20:	557d                	li	a0,-1
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	906080e7          	jalr	-1786(ra) # 80001628 <exit>
  if(which_dev == 2)
    80001d2a:	4789                	li	a5,2
    80001d2c:	04f90f63          	beq	s2,a5,80001d8a <usertrap+0x106>
  usertrapret();
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	dd2080e7          	jalr	-558(ra) # 80001b02 <usertrapret>
}
    80001d38:	60e2                	ld	ra,24(sp)
    80001d3a:	6442                	ld	s0,16(sp)
    80001d3c:	64a2                	ld	s1,8(sp)
    80001d3e:	6902                	ld	s2,0(sp)
    80001d40:	6105                	addi	sp,sp,32
    80001d42:	8082                	ret
      exit(-1);
    80001d44:	557d                	li	a0,-1
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	8e2080e7          	jalr	-1822(ra) # 80001628 <exit>
    80001d4e:	b765                	j	80001cf6 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d50:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d54:	5890                	lw	a2,48(s1)
    80001d56:	00006517          	auipc	a0,0x6
    80001d5a:	56a50513          	addi	a0,a0,1386 # 800082c0 <states.0+0x78>
    80001d5e:	00004097          	auipc	ra,0x4
    80001d62:	f92080e7          	jalr	-110(ra) # 80005cf0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d66:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d6a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d6e:	00006517          	auipc	a0,0x6
    80001d72:	58250513          	addi	a0,a0,1410 # 800082f0 <states.0+0xa8>
    80001d76:	00004097          	auipc	ra,0x4
    80001d7a:	f7a080e7          	jalr	-134(ra) # 80005cf0 <printf>
    setkilled(p);
    80001d7e:	8526                	mv	a0,s1
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	9f0080e7          	jalr	-1552(ra) # 80001770 <setkilled>
    80001d88:	b769                	j	80001d12 <usertrap+0x8e>
    yield();
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	734080e7          	jalr	1844(ra) # 800014be <yield>
    80001d92:	bf79                	j	80001d30 <usertrap+0xac>

0000000080001d94 <kerneltrap>:
{
    80001d94:	7179                	addi	sp,sp,-48
    80001d96:	f406                	sd	ra,40(sp)
    80001d98:	f022                	sd	s0,32(sp)
    80001d9a:	ec26                	sd	s1,24(sp)
    80001d9c:	e84a                	sd	s2,16(sp)
    80001d9e:	e44e                	sd	s3,8(sp)
    80001da0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001daa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dae:	1004f793          	andi	a5,s1,256
    80001db2:	cb85                	beqz	a5,80001de2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001db8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dba:	ef85                	bnez	a5,80001df2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	e22080e7          	jalr	-478(ra) # 80001bde <devintr>
    80001dc4:	cd1d                	beqz	a0,80001e02 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dc6:	4789                	li	a5,2
    80001dc8:	06f50a63          	beq	a0,a5,80001e3c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dcc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd0:	10049073          	csrw	sstatus,s1
}
    80001dd4:	70a2                	ld	ra,40(sp)
    80001dd6:	7402                	ld	s0,32(sp)
    80001dd8:	64e2                	ld	s1,24(sp)
    80001dda:	6942                	ld	s2,16(sp)
    80001ddc:	69a2                	ld	s3,8(sp)
    80001dde:	6145                	addi	sp,sp,48
    80001de0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	52e50513          	addi	a0,a0,1326 # 80008310 <states.0+0xc8>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	ebc080e7          	jalr	-324(ra) # 80005ca6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001df2:	00006517          	auipc	a0,0x6
    80001df6:	54650513          	addi	a0,a0,1350 # 80008338 <states.0+0xf0>
    80001dfa:	00004097          	auipc	ra,0x4
    80001dfe:	eac080e7          	jalr	-340(ra) # 80005ca6 <panic>
    printf("scause %p\n", scause);
    80001e02:	85ce                	mv	a1,s3
    80001e04:	00006517          	auipc	a0,0x6
    80001e08:	55450513          	addi	a0,a0,1364 # 80008358 <states.0+0x110>
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	ee4080e7          	jalr	-284(ra) # 80005cf0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e14:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e18:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	54c50513          	addi	a0,a0,1356 # 80008368 <states.0+0x120>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	ecc080e7          	jalr	-308(ra) # 80005cf0 <printf>
    panic("kerneltrap");
    80001e2c:	00006517          	auipc	a0,0x6
    80001e30:	55450513          	addi	a0,a0,1364 # 80008380 <states.0+0x138>
    80001e34:	00004097          	auipc	ra,0x4
    80001e38:	e72080e7          	jalr	-398(ra) # 80005ca6 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	016080e7          	jalr	22(ra) # 80000e52 <myproc>
    80001e44:	d541                	beqz	a0,80001dcc <kerneltrap+0x38>
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	00c080e7          	jalr	12(ra) # 80000e52 <myproc>
    80001e4e:	4d18                	lw	a4,24(a0)
    80001e50:	4791                	li	a5,4
    80001e52:	f6f71de3          	bne	a4,a5,80001dcc <kerneltrap+0x38>
    yield();
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	668080e7          	jalr	1640(ra) # 800014be <yield>
    80001e5e:	b7bd                	j	80001dcc <kerneltrap+0x38>

0000000080001e60 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	e426                	sd	s1,8(sp)
    80001e68:	1000                	addi	s0,sp,32
    80001e6a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	fe6080e7          	jalr	-26(ra) # 80000e52 <myproc>
  switch (n) {
    80001e74:	4795                	li	a5,5
    80001e76:	0497e163          	bltu	a5,s1,80001eb8 <argraw+0x58>
    80001e7a:	048a                	slli	s1,s1,0x2
    80001e7c:	00006717          	auipc	a4,0x6
    80001e80:	53c70713          	addi	a4,a4,1340 # 800083b8 <states.0+0x170>
    80001e84:	94ba                	add	s1,s1,a4
    80001e86:	409c                	lw	a5,0(s1)
    80001e88:	97ba                	add	a5,a5,a4
    80001e8a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e8c:	6d3c                	ld	a5,88(a0)
    80001e8e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e90:	60e2                	ld	ra,24(sp)
    80001e92:	6442                	ld	s0,16(sp)
    80001e94:	64a2                	ld	s1,8(sp)
    80001e96:	6105                	addi	sp,sp,32
    80001e98:	8082                	ret
    return p->trapframe->a1;
    80001e9a:	6d3c                	ld	a5,88(a0)
    80001e9c:	7fa8                	ld	a0,120(a5)
    80001e9e:	bfcd                	j	80001e90 <argraw+0x30>
    return p->trapframe->a2;
    80001ea0:	6d3c                	ld	a5,88(a0)
    80001ea2:	63c8                	ld	a0,128(a5)
    80001ea4:	b7f5                	j	80001e90 <argraw+0x30>
    return p->trapframe->a3;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	67c8                	ld	a0,136(a5)
    80001eaa:	b7dd                	j	80001e90 <argraw+0x30>
    return p->trapframe->a4;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	6bc8                	ld	a0,144(a5)
    80001eb0:	b7c5                	j	80001e90 <argraw+0x30>
    return p->trapframe->a5;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	6fc8                	ld	a0,152(a5)
    80001eb6:	bfe9                	j	80001e90 <argraw+0x30>
  panic("argraw");
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	4d850513          	addi	a0,a0,1240 # 80008390 <states.0+0x148>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	de6080e7          	jalr	-538(ra) # 80005ca6 <panic>

0000000080001ec8 <fetchaddr>:
{
    80001ec8:	1101                	addi	sp,sp,-32
    80001eca:	ec06                	sd	ra,24(sp)
    80001ecc:	e822                	sd	s0,16(sp)
    80001ece:	e426                	sd	s1,8(sp)
    80001ed0:	e04a                	sd	s2,0(sp)
    80001ed2:	1000                	addi	s0,sp,32
    80001ed4:	84aa                	mv	s1,a0
    80001ed6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	f7a080e7          	jalr	-134(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ee0:	653c                	ld	a5,72(a0)
    80001ee2:	02f4f863          	bgeu	s1,a5,80001f12 <fetchaddr+0x4a>
    80001ee6:	00848713          	addi	a4,s1,8
    80001eea:	02e7e663          	bltu	a5,a4,80001f16 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001eee:	46a1                	li	a3,8
    80001ef0:	8626                	mv	a2,s1
    80001ef2:	85ca                	mv	a1,s2
    80001ef4:	6928                	ld	a0,80(a0)
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	ca8080e7          	jalr	-856(ra) # 80000b9e <copyin>
    80001efe:	00a03533          	snez	a0,a0
    80001f02:	40a00533          	neg	a0,a0
}
    80001f06:	60e2                	ld	ra,24(sp)
    80001f08:	6442                	ld	s0,16(sp)
    80001f0a:	64a2                	ld	s1,8(sp)
    80001f0c:	6902                	ld	s2,0(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret
    return -1;
    80001f12:	557d                	li	a0,-1
    80001f14:	bfcd                	j	80001f06 <fetchaddr+0x3e>
    80001f16:	557d                	li	a0,-1
    80001f18:	b7fd                	j	80001f06 <fetchaddr+0x3e>

0000000080001f1a <fetchstr>:
{
    80001f1a:	7179                	addi	sp,sp,-48
    80001f1c:	f406                	sd	ra,40(sp)
    80001f1e:	f022                	sd	s0,32(sp)
    80001f20:	ec26                	sd	s1,24(sp)
    80001f22:	e84a                	sd	s2,16(sp)
    80001f24:	e44e                	sd	s3,8(sp)
    80001f26:	1800                	addi	s0,sp,48
    80001f28:	892a                	mv	s2,a0
    80001f2a:	84ae                	mv	s1,a1
    80001f2c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	f24080e7          	jalr	-220(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f36:	86ce                	mv	a3,s3
    80001f38:	864a                	mv	a2,s2
    80001f3a:	85a6                	mv	a1,s1
    80001f3c:	6928                	ld	a0,80(a0)
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	cee080e7          	jalr	-786(ra) # 80000c2c <copyinstr>
    80001f46:	00054e63          	bltz	a0,80001f62 <fetchstr+0x48>
  return strlen(buf);
    80001f4a:	8526                	mv	a0,s1
    80001f4c:	ffffe097          	auipc	ra,0xffffe
    80001f50:	3a8080e7          	jalr	936(ra) # 800002f4 <strlen>
}
    80001f54:	70a2                	ld	ra,40(sp)
    80001f56:	7402                	ld	s0,32(sp)
    80001f58:	64e2                	ld	s1,24(sp)
    80001f5a:	6942                	ld	s2,16(sp)
    80001f5c:	69a2                	ld	s3,8(sp)
    80001f5e:	6145                	addi	sp,sp,48
    80001f60:	8082                	ret
    return -1;
    80001f62:	557d                	li	a0,-1
    80001f64:	bfc5                	j	80001f54 <fetchstr+0x3a>

0000000080001f66 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f66:	1101                	addi	sp,sp,-32
    80001f68:	ec06                	sd	ra,24(sp)
    80001f6a:	e822                	sd	s0,16(sp)
    80001f6c:	e426                	sd	s1,8(sp)
    80001f6e:	1000                	addi	s0,sp,32
    80001f70:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f72:	00000097          	auipc	ra,0x0
    80001f76:	eee080e7          	jalr	-274(ra) # 80001e60 <argraw>
    80001f7a:	c088                	sw	a0,0(s1)
}
    80001f7c:	60e2                	ld	ra,24(sp)
    80001f7e:	6442                	ld	s0,16(sp)
    80001f80:	64a2                	ld	s1,8(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret

0000000080001f86 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f86:	1101                	addi	sp,sp,-32
    80001f88:	ec06                	sd	ra,24(sp)
    80001f8a:	e822                	sd	s0,16(sp)
    80001f8c:	e426                	sd	s1,8(sp)
    80001f8e:	1000                	addi	s0,sp,32
    80001f90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f92:	00000097          	auipc	ra,0x0
    80001f96:	ece080e7          	jalr	-306(ra) # 80001e60 <argraw>
    80001f9a:	e088                	sd	a0,0(s1)
}
    80001f9c:	60e2                	ld	ra,24(sp)
    80001f9e:	6442                	ld	s0,16(sp)
    80001fa0:	64a2                	ld	s1,8(sp)
    80001fa2:	6105                	addi	sp,sp,32
    80001fa4:	8082                	ret

0000000080001fa6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fa6:	7179                	addi	sp,sp,-48
    80001fa8:	f406                	sd	ra,40(sp)
    80001faa:	f022                	sd	s0,32(sp)
    80001fac:	ec26                	sd	s1,24(sp)
    80001fae:	e84a                	sd	s2,16(sp)
    80001fb0:	1800                	addi	s0,sp,48
    80001fb2:	84ae                	mv	s1,a1
    80001fb4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fb6:	fd840593          	addi	a1,s0,-40
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	fcc080e7          	jalr	-52(ra) # 80001f86 <argaddr>
  return fetchstr(addr, buf, max);
    80001fc2:	864a                	mv	a2,s2
    80001fc4:	85a6                	mv	a1,s1
    80001fc6:	fd843503          	ld	a0,-40(s0)
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	f50080e7          	jalr	-176(ra) # 80001f1a <fetchstr>
}
    80001fd2:	70a2                	ld	ra,40(sp)
    80001fd4:	7402                	ld	s0,32(sp)
    80001fd6:	64e2                	ld	s1,24(sp)
    80001fd8:	6942                	ld	s2,16(sp)
    80001fda:	6145                	addi	sp,sp,48
    80001fdc:	8082                	ret

0000000080001fde <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	e04a                	sd	s2,0(sp)
    80001fe8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	e68080e7          	jalr	-408(ra) # 80000e52 <myproc>
    80001ff2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ff4:	05853903          	ld	s2,88(a0)
    80001ff8:	0a893783          	ld	a5,168(s2)
    80001ffc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002000:	37fd                	addiw	a5,a5,-1
    80002002:	4751                	li	a4,20
    80002004:	00f76f63          	bltu	a4,a5,80002022 <syscall+0x44>
    80002008:	00369713          	slli	a4,a3,0x3
    8000200c:	00006797          	auipc	a5,0x6
    80002010:	3c478793          	addi	a5,a5,964 # 800083d0 <syscalls>
    80002014:	97ba                	add	a5,a5,a4
    80002016:	639c                	ld	a5,0(a5)
    80002018:	c789                	beqz	a5,80002022 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000201a:	9782                	jalr	a5
    8000201c:	06a93823          	sd	a0,112(s2)
    80002020:	a839                	j	8000203e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002022:	15848613          	addi	a2,s1,344
    80002026:	588c                	lw	a1,48(s1)
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	37050513          	addi	a0,a0,880 # 80008398 <states.0+0x150>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	cc0080e7          	jalr	-832(ra) # 80005cf0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002038:	6cbc                	ld	a5,88(s1)
    8000203a:	577d                	li	a4,-1
    8000203c:	fbb8                	sd	a4,112(a5)
  }
}
    8000203e:	60e2                	ld	ra,24(sp)
    80002040:	6442                	ld	s0,16(sp)
    80002042:	64a2                	ld	s1,8(sp)
    80002044:	6902                	ld	s2,0(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002052:	fec40593          	addi	a1,s0,-20
    80002056:	4501                	li	a0,0
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	f0e080e7          	jalr	-242(ra) # 80001f66 <argint>
  exit(n);
    80002060:	fec42503          	lw	a0,-20(s0)
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	5c4080e7          	jalr	1476(ra) # 80001628 <exit>
  return 0;  // not reached
}
    8000206c:	4501                	li	a0,0
    8000206e:	60e2                	ld	ra,24(sp)
    80002070:	6442                	ld	s0,16(sp)
    80002072:	6105                	addi	sp,sp,32
    80002074:	8082                	ret

0000000080002076 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002076:	1141                	addi	sp,sp,-16
    80002078:	e406                	sd	ra,8(sp)
    8000207a:	e022                	sd	s0,0(sp)
    8000207c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	dd4080e7          	jalr	-556(ra) # 80000e52 <myproc>
}
    80002086:	5908                	lw	a0,48(a0)
    80002088:	60a2                	ld	ra,8(sp)
    8000208a:	6402                	ld	s0,0(sp)
    8000208c:	0141                	addi	sp,sp,16
    8000208e:	8082                	ret

0000000080002090 <sys_fork>:

uint64
sys_fork(void)
{
    80002090:	1141                	addi	sp,sp,-16
    80002092:	e406                	sd	ra,8(sp)
    80002094:	e022                	sd	s0,0(sp)
    80002096:	0800                	addi	s0,sp,16
  return fork();
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	170080e7          	jalr	368(ra) # 80001208 <fork>
}
    800020a0:	60a2                	ld	ra,8(sp)
    800020a2:	6402                	ld	s0,0(sp)
    800020a4:	0141                	addi	sp,sp,16
    800020a6:	8082                	ret

00000000800020a8 <sys_wait>:

uint64
sys_wait(void)
{
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b0:	fe840593          	addi	a1,s0,-24
    800020b4:	4501                	li	a0,0
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	ed0080e7          	jalr	-304(ra) # 80001f86 <argaddr>
  return wait(p);
    800020be:	fe843503          	ld	a0,-24(s0)
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	70c080e7          	jalr	1804(ra) # 800017ce <wait>
}
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d2:	7179                	addi	sp,sp,-48
    800020d4:	f406                	sd	ra,40(sp)
    800020d6:	f022                	sd	s0,32(sp)
    800020d8:	ec26                	sd	s1,24(sp)
    800020da:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020dc:	fdc40593          	addi	a1,s0,-36
    800020e0:	4501                	li	a0,0
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	e84080e7          	jalr	-380(ra) # 80001f66 <argint>
  addr = myproc()->sz;
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	d68080e7          	jalr	-664(ra) # 80000e52 <myproc>
    800020f2:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020f4:	fdc42503          	lw	a0,-36(s0)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	0b4080e7          	jalr	180(ra) # 800011ac <growproc>
    80002100:	00054863          	bltz	a0,80002110 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002104:	8526                	mv	a0,s1
    80002106:	70a2                	ld	ra,40(sp)
    80002108:	7402                	ld	s0,32(sp)
    8000210a:	64e2                	ld	s1,24(sp)
    8000210c:	6145                	addi	sp,sp,48
    8000210e:	8082                	ret
    return -1;
    80002110:	54fd                	li	s1,-1
    80002112:	bfcd                	j	80002104 <sys_sbrk+0x32>

0000000080002114 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002114:	7139                	addi	sp,sp,-64
    80002116:	fc06                	sd	ra,56(sp)
    80002118:	f822                	sd	s0,48(sp)
    8000211a:	f426                	sd	s1,40(sp)
    8000211c:	f04a                	sd	s2,32(sp)
    8000211e:	ec4e                	sd	s3,24(sp)
    80002120:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002122:	fcc40593          	addi	a1,s0,-52
    80002126:	4501                	li	a0,0
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	e3e080e7          	jalr	-450(ra) # 80001f66 <argint>
  if(n < 0)
    80002130:	fcc42783          	lw	a5,-52(s0)
    80002134:	0607cf63          	bltz	a5,800021b2 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002138:	00008517          	auipc	a0,0x8
    8000213c:	9e850513          	addi	a0,a0,-1560 # 80009b20 <tickslock>
    80002140:	00004097          	auipc	ra,0x4
    80002144:	09e080e7          	jalr	158(ra) # 800061de <acquire>
  ticks0 = ticks;
    80002148:	00006917          	auipc	s2,0x6
    8000214c:	76092903          	lw	s2,1888(s2) # 800088a8 <ticks>
  while(ticks - ticks0 < n){
    80002150:	fcc42783          	lw	a5,-52(s0)
    80002154:	cf9d                	beqz	a5,80002192 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002156:	00008997          	auipc	s3,0x8
    8000215a:	9ca98993          	addi	s3,s3,-1590 # 80009b20 <tickslock>
    8000215e:	00006497          	auipc	s1,0x6
    80002162:	74a48493          	addi	s1,s1,1866 # 800088a8 <ticks>
    if(killed(myproc())){
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	cec080e7          	jalr	-788(ra) # 80000e52 <myproc>
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	62e080e7          	jalr	1582(ra) # 8000179c <killed>
    80002176:	e129                	bnez	a0,800021b8 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002178:	85ce                	mv	a1,s3
    8000217a:	8526                	mv	a0,s1
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	37e080e7          	jalr	894(ra) # 800014fa <sleep>
  while(ticks - ticks0 < n){
    80002184:	409c                	lw	a5,0(s1)
    80002186:	412787bb          	subw	a5,a5,s2
    8000218a:	fcc42703          	lw	a4,-52(s0)
    8000218e:	fce7ece3          	bltu	a5,a4,80002166 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002192:	00008517          	auipc	a0,0x8
    80002196:	98e50513          	addi	a0,a0,-1650 # 80009b20 <tickslock>
    8000219a:	00004097          	auipc	ra,0x4
    8000219e:	0f8080e7          	jalr	248(ra) # 80006292 <release>
  return 0;
    800021a2:	4501                	li	a0,0
}
    800021a4:	70e2                	ld	ra,56(sp)
    800021a6:	7442                	ld	s0,48(sp)
    800021a8:	74a2                	ld	s1,40(sp)
    800021aa:	7902                	ld	s2,32(sp)
    800021ac:	69e2                	ld	s3,24(sp)
    800021ae:	6121                	addi	sp,sp,64
    800021b0:	8082                	ret
    n = 0;
    800021b2:	fc042623          	sw	zero,-52(s0)
    800021b6:	b749                	j	80002138 <sys_sleep+0x24>
      release(&tickslock);
    800021b8:	00008517          	auipc	a0,0x8
    800021bc:	96850513          	addi	a0,a0,-1688 # 80009b20 <tickslock>
    800021c0:	00004097          	auipc	ra,0x4
    800021c4:	0d2080e7          	jalr	210(ra) # 80006292 <release>
      return -1;
    800021c8:	557d                	li	a0,-1
    800021ca:	bfe9                	j	800021a4 <sys_sleep+0x90>

00000000800021cc <sys_kill>:

uint64
sys_kill(void)
{
    800021cc:	1101                	addi	sp,sp,-32
    800021ce:	ec06                	sd	ra,24(sp)
    800021d0:	e822                	sd	s0,16(sp)
    800021d2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021d4:	fec40593          	addi	a1,s0,-20
    800021d8:	4501                	li	a0,0
    800021da:	00000097          	auipc	ra,0x0
    800021de:	d8c080e7          	jalr	-628(ra) # 80001f66 <argint>
  return kill(pid);
    800021e2:	fec42503          	lw	a0,-20(s0)
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	518080e7          	jalr	1304(ra) # 800016fe <kill>
}
    800021ee:	60e2                	ld	ra,24(sp)
    800021f0:	6442                	ld	s0,16(sp)
    800021f2:	6105                	addi	sp,sp,32
    800021f4:	8082                	ret

00000000800021f6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021f6:	1101                	addi	sp,sp,-32
    800021f8:	ec06                	sd	ra,24(sp)
    800021fa:	e822                	sd	s0,16(sp)
    800021fc:	e426                	sd	s1,8(sp)
    800021fe:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002200:	00008517          	auipc	a0,0x8
    80002204:	92050513          	addi	a0,a0,-1760 # 80009b20 <tickslock>
    80002208:	00004097          	auipc	ra,0x4
    8000220c:	fd6080e7          	jalr	-42(ra) # 800061de <acquire>
  xticks = ticks;
    80002210:	00006497          	auipc	s1,0x6
    80002214:	6984a483          	lw	s1,1688(s1) # 800088a8 <ticks>
  release(&tickslock);
    80002218:	00008517          	auipc	a0,0x8
    8000221c:	90850513          	addi	a0,a0,-1784 # 80009b20 <tickslock>
    80002220:	00004097          	auipc	ra,0x4
    80002224:	072080e7          	jalr	114(ra) # 80006292 <release>
  return xticks;
}
    80002228:	02049513          	slli	a0,s1,0x20
    8000222c:	9101                	srli	a0,a0,0x20
    8000222e:	60e2                	ld	ra,24(sp)
    80002230:	6442                	ld	s0,16(sp)
    80002232:	64a2                	ld	s1,8(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret

0000000080002238 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002238:	7179                	addi	sp,sp,-48
    8000223a:	f406                	sd	ra,40(sp)
    8000223c:	f022                	sd	s0,32(sp)
    8000223e:	ec26                	sd	s1,24(sp)
    80002240:	e84a                	sd	s2,16(sp)
    80002242:	e44e                	sd	s3,8(sp)
    80002244:	e052                	sd	s4,0(sp)
    80002246:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002248:	00006597          	auipc	a1,0x6
    8000224c:	23858593          	addi	a1,a1,568 # 80008480 <syscalls+0xb0>
    80002250:	00008517          	auipc	a0,0x8
    80002254:	8e850513          	addi	a0,a0,-1816 # 80009b38 <bcache>
    80002258:	00004097          	auipc	ra,0x4
    8000225c:	ef6080e7          	jalr	-266(ra) # 8000614e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002260:	00010797          	auipc	a5,0x10
    80002264:	8d878793          	addi	a5,a5,-1832 # 80011b38 <bcache+0x8000>
    80002268:	00010717          	auipc	a4,0x10
    8000226c:	b3870713          	addi	a4,a4,-1224 # 80011da0 <bcache+0x8268>
    80002270:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002274:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002278:	00008497          	auipc	s1,0x8
    8000227c:	8d848493          	addi	s1,s1,-1832 # 80009b50 <bcache+0x18>
    b->next = bcache.head.next;
    80002280:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002282:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002284:	00006a17          	auipc	s4,0x6
    80002288:	204a0a13          	addi	s4,s4,516 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000228c:	2b893783          	ld	a5,696(s2)
    80002290:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002292:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002296:	85d2                	mv	a1,s4
    80002298:	01048513          	addi	a0,s1,16
    8000229c:	00001097          	auipc	ra,0x1
    800022a0:	610080e7          	jalr	1552(ra) # 800038ac <initsleeplock>
    bcache.head.next->prev = b;
    800022a4:	2b893783          	ld	a5,696(s2)
    800022a8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022aa:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022ae:	45848493          	addi	s1,s1,1112
    800022b2:	fd349de3          	bne	s1,s3,8000228c <binit+0x54>
  }
}
    800022b6:	70a2                	ld	ra,40(sp)
    800022b8:	7402                	ld	s0,32(sp)
    800022ba:	64e2                	ld	s1,24(sp)
    800022bc:	6942                	ld	s2,16(sp)
    800022be:	69a2                	ld	s3,8(sp)
    800022c0:	6a02                	ld	s4,0(sp)
    800022c2:	6145                	addi	sp,sp,48
    800022c4:	8082                	ret

00000000800022c6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022c6:	7179                	addi	sp,sp,-48
    800022c8:	f406                	sd	ra,40(sp)
    800022ca:	f022                	sd	s0,32(sp)
    800022cc:	ec26                	sd	s1,24(sp)
    800022ce:	e84a                	sd	s2,16(sp)
    800022d0:	e44e                	sd	s3,8(sp)
    800022d2:	1800                	addi	s0,sp,48
    800022d4:	892a                	mv	s2,a0
    800022d6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022d8:	00008517          	auipc	a0,0x8
    800022dc:	86050513          	addi	a0,a0,-1952 # 80009b38 <bcache>
    800022e0:	00004097          	auipc	ra,0x4
    800022e4:	efe080e7          	jalr	-258(ra) # 800061de <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022e8:	00010497          	auipc	s1,0x10
    800022ec:	b084b483          	ld	s1,-1272(s1) # 80011df0 <bcache+0x82b8>
    800022f0:	00010797          	auipc	a5,0x10
    800022f4:	ab078793          	addi	a5,a5,-1360 # 80011da0 <bcache+0x8268>
    800022f8:	02f48f63          	beq	s1,a5,80002336 <bread+0x70>
    800022fc:	873e                	mv	a4,a5
    800022fe:	a021                	j	80002306 <bread+0x40>
    80002300:	68a4                	ld	s1,80(s1)
    80002302:	02e48a63          	beq	s1,a4,80002336 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002306:	449c                	lw	a5,8(s1)
    80002308:	ff279ce3          	bne	a5,s2,80002300 <bread+0x3a>
    8000230c:	44dc                	lw	a5,12(s1)
    8000230e:	ff3799e3          	bne	a5,s3,80002300 <bread+0x3a>
      b->refcnt++;
    80002312:	40bc                	lw	a5,64(s1)
    80002314:	2785                	addiw	a5,a5,1
    80002316:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002318:	00008517          	auipc	a0,0x8
    8000231c:	82050513          	addi	a0,a0,-2016 # 80009b38 <bcache>
    80002320:	00004097          	auipc	ra,0x4
    80002324:	f72080e7          	jalr	-142(ra) # 80006292 <release>
      acquiresleep(&b->lock);
    80002328:	01048513          	addi	a0,s1,16
    8000232c:	00001097          	auipc	ra,0x1
    80002330:	5ba080e7          	jalr	1466(ra) # 800038e6 <acquiresleep>
      return b;
    80002334:	a8b9                	j	80002392 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002336:	00010497          	auipc	s1,0x10
    8000233a:	ab24b483          	ld	s1,-1358(s1) # 80011de8 <bcache+0x82b0>
    8000233e:	00010797          	auipc	a5,0x10
    80002342:	a6278793          	addi	a5,a5,-1438 # 80011da0 <bcache+0x8268>
    80002346:	00f48863          	beq	s1,a5,80002356 <bread+0x90>
    8000234a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000234c:	40bc                	lw	a5,64(s1)
    8000234e:	cf81                	beqz	a5,80002366 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002350:	64a4                	ld	s1,72(s1)
    80002352:	fee49de3          	bne	s1,a4,8000234c <bread+0x86>
  panic("bget: no buffers");
    80002356:	00006517          	auipc	a0,0x6
    8000235a:	13a50513          	addi	a0,a0,314 # 80008490 <syscalls+0xc0>
    8000235e:	00004097          	auipc	ra,0x4
    80002362:	948080e7          	jalr	-1720(ra) # 80005ca6 <panic>
      b->dev = dev;
    80002366:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000236a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000236e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002372:	4785                	li	a5,1
    80002374:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002376:	00007517          	auipc	a0,0x7
    8000237a:	7c250513          	addi	a0,a0,1986 # 80009b38 <bcache>
    8000237e:	00004097          	auipc	ra,0x4
    80002382:	f14080e7          	jalr	-236(ra) # 80006292 <release>
      acquiresleep(&b->lock);
    80002386:	01048513          	addi	a0,s1,16
    8000238a:	00001097          	auipc	ra,0x1
    8000238e:	55c080e7          	jalr	1372(ra) # 800038e6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002392:	409c                	lw	a5,0(s1)
    80002394:	cb89                	beqz	a5,800023a6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002396:	8526                	mv	a0,s1
    80002398:	70a2                	ld	ra,40(sp)
    8000239a:	7402                	ld	s0,32(sp)
    8000239c:	64e2                	ld	s1,24(sp)
    8000239e:	6942                	ld	s2,16(sp)
    800023a0:	69a2                	ld	s3,8(sp)
    800023a2:	6145                	addi	sp,sp,48
    800023a4:	8082                	ret
    virtio_disk_rw(b, 0);
    800023a6:	4581                	li	a1,0
    800023a8:	8526                	mv	a0,s1
    800023aa:	00003097          	auipc	ra,0x3
    800023ae:	0f8080e7          	jalr	248(ra) # 800054a2 <virtio_disk_rw>
    b->valid = 1;
    800023b2:	4785                	li	a5,1
    800023b4:	c09c                	sw	a5,0(s1)
  return b;
    800023b6:	b7c5                	j	80002396 <bread+0xd0>

00000000800023b8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023b8:	1101                	addi	sp,sp,-32
    800023ba:	ec06                	sd	ra,24(sp)
    800023bc:	e822                	sd	s0,16(sp)
    800023be:	e426                	sd	s1,8(sp)
    800023c0:	1000                	addi	s0,sp,32
    800023c2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023c4:	0541                	addi	a0,a0,16
    800023c6:	00001097          	auipc	ra,0x1
    800023ca:	5ba080e7          	jalr	1466(ra) # 80003980 <holdingsleep>
    800023ce:	cd01                	beqz	a0,800023e6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023d0:	4585                	li	a1,1
    800023d2:	8526                	mv	a0,s1
    800023d4:	00003097          	auipc	ra,0x3
    800023d8:	0ce080e7          	jalr	206(ra) # 800054a2 <virtio_disk_rw>
}
    800023dc:	60e2                	ld	ra,24(sp)
    800023de:	6442                	ld	s0,16(sp)
    800023e0:	64a2                	ld	s1,8(sp)
    800023e2:	6105                	addi	sp,sp,32
    800023e4:	8082                	ret
    panic("bwrite");
    800023e6:	00006517          	auipc	a0,0x6
    800023ea:	0c250513          	addi	a0,a0,194 # 800084a8 <syscalls+0xd8>
    800023ee:	00004097          	auipc	ra,0x4
    800023f2:	8b8080e7          	jalr	-1864(ra) # 80005ca6 <panic>

00000000800023f6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023f6:	1101                	addi	sp,sp,-32
    800023f8:	ec06                	sd	ra,24(sp)
    800023fa:	e822                	sd	s0,16(sp)
    800023fc:	e426                	sd	s1,8(sp)
    800023fe:	e04a                	sd	s2,0(sp)
    80002400:	1000                	addi	s0,sp,32
    80002402:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002404:	01050913          	addi	s2,a0,16
    80002408:	854a                	mv	a0,s2
    8000240a:	00001097          	auipc	ra,0x1
    8000240e:	576080e7          	jalr	1398(ra) # 80003980 <holdingsleep>
    80002412:	c925                	beqz	a0,80002482 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002414:	854a                	mv	a0,s2
    80002416:	00001097          	auipc	ra,0x1
    8000241a:	526080e7          	jalr	1318(ra) # 8000393c <releasesleep>

  acquire(&bcache.lock);
    8000241e:	00007517          	auipc	a0,0x7
    80002422:	71a50513          	addi	a0,a0,1818 # 80009b38 <bcache>
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	db8080e7          	jalr	-584(ra) # 800061de <acquire>
  b->refcnt--;
    8000242e:	40bc                	lw	a5,64(s1)
    80002430:	37fd                	addiw	a5,a5,-1
    80002432:	0007871b          	sext.w	a4,a5
    80002436:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002438:	e71d                	bnez	a4,80002466 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000243a:	68b8                	ld	a4,80(s1)
    8000243c:	64bc                	ld	a5,72(s1)
    8000243e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002440:	68b8                	ld	a4,80(s1)
    80002442:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002444:	0000f797          	auipc	a5,0xf
    80002448:	6f478793          	addi	a5,a5,1780 # 80011b38 <bcache+0x8000>
    8000244c:	2b87b703          	ld	a4,696(a5)
    80002450:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002452:	00010717          	auipc	a4,0x10
    80002456:	94e70713          	addi	a4,a4,-1714 # 80011da0 <bcache+0x8268>
    8000245a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000245c:	2b87b703          	ld	a4,696(a5)
    80002460:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002462:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002466:	00007517          	auipc	a0,0x7
    8000246a:	6d250513          	addi	a0,a0,1746 # 80009b38 <bcache>
    8000246e:	00004097          	auipc	ra,0x4
    80002472:	e24080e7          	jalr	-476(ra) # 80006292 <release>
}
    80002476:	60e2                	ld	ra,24(sp)
    80002478:	6442                	ld	s0,16(sp)
    8000247a:	64a2                	ld	s1,8(sp)
    8000247c:	6902                	ld	s2,0(sp)
    8000247e:	6105                	addi	sp,sp,32
    80002480:	8082                	ret
    panic("brelse");
    80002482:	00006517          	auipc	a0,0x6
    80002486:	02e50513          	addi	a0,a0,46 # 800084b0 <syscalls+0xe0>
    8000248a:	00004097          	auipc	ra,0x4
    8000248e:	81c080e7          	jalr	-2020(ra) # 80005ca6 <panic>

0000000080002492 <bpin>:

void
bpin(struct buf *b) {
    80002492:	1101                	addi	sp,sp,-32
    80002494:	ec06                	sd	ra,24(sp)
    80002496:	e822                	sd	s0,16(sp)
    80002498:	e426                	sd	s1,8(sp)
    8000249a:	1000                	addi	s0,sp,32
    8000249c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000249e:	00007517          	auipc	a0,0x7
    800024a2:	69a50513          	addi	a0,a0,1690 # 80009b38 <bcache>
    800024a6:	00004097          	auipc	ra,0x4
    800024aa:	d38080e7          	jalr	-712(ra) # 800061de <acquire>
  b->refcnt++;
    800024ae:	40bc                	lw	a5,64(s1)
    800024b0:	2785                	addiw	a5,a5,1
    800024b2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024b4:	00007517          	auipc	a0,0x7
    800024b8:	68450513          	addi	a0,a0,1668 # 80009b38 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	dd6080e7          	jalr	-554(ra) # 80006292 <release>
}
    800024c4:	60e2                	ld	ra,24(sp)
    800024c6:	6442                	ld	s0,16(sp)
    800024c8:	64a2                	ld	s1,8(sp)
    800024ca:	6105                	addi	sp,sp,32
    800024cc:	8082                	ret

00000000800024ce <bunpin>:

void
bunpin(struct buf *b) {
    800024ce:	1101                	addi	sp,sp,-32
    800024d0:	ec06                	sd	ra,24(sp)
    800024d2:	e822                	sd	s0,16(sp)
    800024d4:	e426                	sd	s1,8(sp)
    800024d6:	1000                	addi	s0,sp,32
    800024d8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024da:	00007517          	auipc	a0,0x7
    800024de:	65e50513          	addi	a0,a0,1630 # 80009b38 <bcache>
    800024e2:	00004097          	auipc	ra,0x4
    800024e6:	cfc080e7          	jalr	-772(ra) # 800061de <acquire>
  b->refcnt--;
    800024ea:	40bc                	lw	a5,64(s1)
    800024ec:	37fd                	addiw	a5,a5,-1
    800024ee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024f0:	00007517          	auipc	a0,0x7
    800024f4:	64850513          	addi	a0,a0,1608 # 80009b38 <bcache>
    800024f8:	00004097          	auipc	ra,0x4
    800024fc:	d9a080e7          	jalr	-614(ra) # 80006292 <release>
}
    80002500:	60e2                	ld	ra,24(sp)
    80002502:	6442                	ld	s0,16(sp)
    80002504:	64a2                	ld	s1,8(sp)
    80002506:	6105                	addi	sp,sp,32
    80002508:	8082                	ret

000000008000250a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000250a:	1101                	addi	sp,sp,-32
    8000250c:	ec06                	sd	ra,24(sp)
    8000250e:	e822                	sd	s0,16(sp)
    80002510:	e426                	sd	s1,8(sp)
    80002512:	e04a                	sd	s2,0(sp)
    80002514:	1000                	addi	s0,sp,32
    80002516:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002518:	00d5d59b          	srliw	a1,a1,0xd
    8000251c:	00010797          	auipc	a5,0x10
    80002520:	cf87a783          	lw	a5,-776(a5) # 80012214 <sb+0x1c>
    80002524:	9dbd                	addw	a1,a1,a5
    80002526:	00000097          	auipc	ra,0x0
    8000252a:	da0080e7          	jalr	-608(ra) # 800022c6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000252e:	0074f713          	andi	a4,s1,7
    80002532:	4785                	li	a5,1
    80002534:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0)
    80002538:	14ce                	slli	s1,s1,0x33
    8000253a:	90d9                	srli	s1,s1,0x36
    8000253c:	00950733          	add	a4,a0,s1
    80002540:	05874703          	lbu	a4,88(a4)
    80002544:	00e7f6b3          	and	a3,a5,a4
    80002548:	c69d                	beqz	a3,80002576 <bfree+0x6c>
    8000254a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    8000254c:	94aa                	add	s1,s1,a0
    8000254e:	fff7c793          	not	a5,a5
    80002552:	8f7d                	and	a4,a4,a5
    80002554:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002558:	00001097          	auipc	ra,0x1
    8000255c:	270080e7          	jalr	624(ra) # 800037c8 <log_write>
  brelse(bp);
    80002560:	854a                	mv	a0,s2
    80002562:	00000097          	auipc	ra,0x0
    80002566:	e94080e7          	jalr	-364(ra) # 800023f6 <brelse>
}
    8000256a:	60e2                	ld	ra,24(sp)
    8000256c:	6442                	ld	s0,16(sp)
    8000256e:	64a2                	ld	s1,8(sp)
    80002570:	6902                	ld	s2,0(sp)
    80002572:	6105                	addi	sp,sp,32
    80002574:	8082                	ret
    panic("freeing free block");
    80002576:	00006517          	auipc	a0,0x6
    8000257a:	f4250513          	addi	a0,a0,-190 # 800084b8 <syscalls+0xe8>
    8000257e:	00003097          	auipc	ra,0x3
    80002582:	728080e7          	jalr	1832(ra) # 80005ca6 <panic>

0000000080002586 <balloc>:
{
    80002586:	711d                	addi	sp,sp,-96
    80002588:	ec86                	sd	ra,88(sp)
    8000258a:	e8a2                	sd	s0,80(sp)
    8000258c:	e4a6                	sd	s1,72(sp)
    8000258e:	e0ca                	sd	s2,64(sp)
    80002590:	fc4e                	sd	s3,56(sp)
    80002592:	f852                	sd	s4,48(sp)
    80002594:	f456                	sd	s5,40(sp)
    80002596:	f05a                	sd	s6,32(sp)
    80002598:	ec5e                	sd	s7,24(sp)
    8000259a:	e862                	sd	s8,16(sp)
    8000259c:	e466                	sd	s9,8(sp)
    8000259e:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB)
    800025a0:	00010797          	auipc	a5,0x10
    800025a4:	c5c7a783          	lw	a5,-932(a5) # 800121fc <sb+0x4>
    800025a8:	cff5                	beqz	a5,800026a4 <balloc+0x11e>
    800025aa:	8baa                	mv	s7,a0
    800025ac:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025ae:	00010b17          	auipc	s6,0x10
    800025b2:	c4ab0b13          	addi	s6,s6,-950 # 800121f8 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800025b6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025b8:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800025ba:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB)
    800025bc:	6c89                	lui	s9,0x2
    800025be:	a061                	j	80002646 <balloc+0xc0>
        bp->data[bi / 8] |= m; // Mark block in use.
    800025c0:	97ca                	add	a5,a5,s2
    800025c2:	8e55                	or	a2,a2,a3
    800025c4:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025c8:	854a                	mv	a0,s2
    800025ca:	00001097          	auipc	ra,0x1
    800025ce:	1fe080e7          	jalr	510(ra) # 800037c8 <log_write>
        brelse(bp);
    800025d2:	854a                	mv	a0,s2
    800025d4:	00000097          	auipc	ra,0x0
    800025d8:	e22080e7          	jalr	-478(ra) # 800023f6 <brelse>
  bp = bread(dev, bno);
    800025dc:	85a6                	mv	a1,s1
    800025de:	855e                	mv	a0,s7
    800025e0:	00000097          	auipc	ra,0x0
    800025e4:	ce6080e7          	jalr	-794(ra) # 800022c6 <bread>
    800025e8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025ea:	40000613          	li	a2,1024
    800025ee:	4581                	li	a1,0
    800025f0:	05850513          	addi	a0,a0,88
    800025f4:	ffffe097          	auipc	ra,0xffffe
    800025f8:	b86080e7          	jalr	-1146(ra) # 8000017a <memset>
  log_write(bp);
    800025fc:	854a                	mv	a0,s2
    800025fe:	00001097          	auipc	ra,0x1
    80002602:	1ca080e7          	jalr	458(ra) # 800037c8 <log_write>
  brelse(bp);
    80002606:	854a                	mv	a0,s2
    80002608:	00000097          	auipc	ra,0x0
    8000260c:	dee080e7          	jalr	-530(ra) # 800023f6 <brelse>
}
    80002610:	8526                	mv	a0,s1
    80002612:	60e6                	ld	ra,88(sp)
    80002614:	6446                	ld	s0,80(sp)
    80002616:	64a6                	ld	s1,72(sp)
    80002618:	6906                	ld	s2,64(sp)
    8000261a:	79e2                	ld	s3,56(sp)
    8000261c:	7a42                	ld	s4,48(sp)
    8000261e:	7aa2                	ld	s5,40(sp)
    80002620:	7b02                	ld	s6,32(sp)
    80002622:	6be2                	ld	s7,24(sp)
    80002624:	6c42                	ld	s8,16(sp)
    80002626:	6ca2                	ld	s9,8(sp)
    80002628:	6125                	addi	sp,sp,96
    8000262a:	8082                	ret
    brelse(bp);
    8000262c:	854a                	mv	a0,s2
    8000262e:	00000097          	auipc	ra,0x0
    80002632:	dc8080e7          	jalr	-568(ra) # 800023f6 <brelse>
  for (b = 0; b < sb.size; b += BPB)
    80002636:	015c87bb          	addw	a5,s9,s5
    8000263a:	00078a9b          	sext.w	s5,a5
    8000263e:	004b2703          	lw	a4,4(s6)
    80002642:	06eaf163          	bgeu	s5,a4,800026a4 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002646:	41fad79b          	sraiw	a5,s5,0x1f
    8000264a:	0137d79b          	srliw	a5,a5,0x13
    8000264e:	015787bb          	addw	a5,a5,s5
    80002652:	40d7d79b          	sraiw	a5,a5,0xd
    80002656:	01cb2583          	lw	a1,28(s6)
    8000265a:	9dbd                	addw	a1,a1,a5
    8000265c:	855e                	mv	a0,s7
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	c68080e7          	jalr	-920(ra) # 800022c6 <bread>
    80002666:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002668:	004b2503          	lw	a0,4(s6)
    8000266c:	000a849b          	sext.w	s1,s5
    80002670:	8762                	mv	a4,s8
    80002672:	faa4fde3          	bgeu	s1,a0,8000262c <balloc+0xa6>
      m = 1 << (bi % 8);
    80002676:	00777693          	andi	a3,a4,7
    8000267a:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0)
    8000267e:	41f7579b          	sraiw	a5,a4,0x1f
    80002682:	01d7d79b          	srliw	a5,a5,0x1d
    80002686:	9fb9                	addw	a5,a5,a4
    80002688:	4037d79b          	sraiw	a5,a5,0x3
    8000268c:	00f90633          	add	a2,s2,a5
    80002690:	05864603          	lbu	a2,88(a2)
    80002694:	00c6f5b3          	and	a1,a3,a2
    80002698:	d585                	beqz	a1,800025c0 <balloc+0x3a>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    8000269a:	2705                	addiw	a4,a4,1
    8000269c:	2485                	addiw	s1,s1,1
    8000269e:	fd471ae3          	bne	a4,s4,80002672 <balloc+0xec>
    800026a2:	b769                	j	8000262c <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800026a4:	00006517          	auipc	a0,0x6
    800026a8:	e2c50513          	addi	a0,a0,-468 # 800084d0 <syscalls+0x100>
    800026ac:	00003097          	auipc	ra,0x3
    800026b0:	644080e7          	jalr	1604(ra) # 80005cf0 <printf>
  return 0;
    800026b4:	4481                	li	s1,0
    800026b6:	bfa9                	j	80002610 <balloc+0x8a>

00000000800026b8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026b8:	7139                	addi	sp,sp,-64
    800026ba:	fc06                	sd	ra,56(sp)
    800026bc:	f822                	sd	s0,48(sp)
    800026be:	f426                	sd	s1,40(sp)
    800026c0:	f04a                	sd	s2,32(sp)
    800026c2:	ec4e                	sd	s3,24(sp)
    800026c4:	e852                	sd	s4,16(sp)
    800026c6:	e456                	sd	s5,8(sp)
    800026c8:	0080                	addi	s0,sp,64
    800026ca:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT)
    800026cc:	47a9                	li	a5,10
    800026ce:	04b7e063          	bltu	a5,a1,8000270e <bmap+0x56>
  {
    if ((addr = ip->addrs[bn]) == 0)
    800026d2:	02059793          	slli	a5,a1,0x20
    800026d6:	01e7d593          	srli	a1,a5,0x1e
    800026da:	00b50933          	add	s2,a0,a1
    800026de:	05092483          	lw	s1,80(s2)
    800026e2:	c899                	beqz	s1,800026f8 <bmap+0x40>
    a[bl2] = addr;
    log_write(bp);
  }
  brelse(bp);
  return addr;
}
    800026e4:	8526                	mv	a0,s1
    800026e6:	70e2                	ld	ra,56(sp)
    800026e8:	7442                	ld	s0,48(sp)
    800026ea:	74a2                	ld	s1,40(sp)
    800026ec:	7902                	ld	s2,32(sp)
    800026ee:	69e2                	ld	s3,24(sp)
    800026f0:	6a42                	ld	s4,16(sp)
    800026f2:	6aa2                	ld	s5,8(sp)
    800026f4:	6121                	addi	sp,sp,64
    800026f6:	8082                	ret
      addr = balloc(ip->dev);
    800026f8:	4108                	lw	a0,0(a0)
    800026fa:	00000097          	auipc	ra,0x0
    800026fe:	e8c080e7          	jalr	-372(ra) # 80002586 <balloc>
    80002702:	0005049b          	sext.w	s1,a0
      if (addr == 0)
    80002706:	dcf9                	beqz	s1,800026e4 <bmap+0x2c>
      ip->addrs[bn] = addr;
    80002708:	04992823          	sw	s1,80(s2)
    8000270c:	bfe1                	j	800026e4 <bmap+0x2c>
  bn -= NDIRECT;
    8000270e:	ff55891b          	addiw	s2,a1,-11
    80002712:	0009071b          	sext.w	a4,s2
  if (bn < NINDIRECT)
    80002716:	0ff00793          	li	a5,255
    8000271a:	06e7e763          	bltu	a5,a4,80002788 <bmap+0xd0>
    if ((addr = ip->addrs[NDIRECT]) == 0)
    8000271e:	5d64                	lw	s1,124(a0)
    80002720:	e899                	bnez	s1,80002736 <bmap+0x7e>
      addr = balloc(ip->dev);
    80002722:	4108                	lw	a0,0(a0)
    80002724:	00000097          	auipc	ra,0x0
    80002728:	e62080e7          	jalr	-414(ra) # 80002586 <balloc>
    8000272c:	0005049b          	sext.w	s1,a0
      if (addr == 0)
    80002730:	d8d5                	beqz	s1,800026e4 <bmap+0x2c>
      ip->addrs[NDIRECT] = addr;
    80002732:	0699ae23          	sw	s1,124(s3)
    bp = bread(ip->dev, addr);
    80002736:	85a6                	mv	a1,s1
    80002738:	0009a503          	lw	a0,0(s3)
    8000273c:	00000097          	auipc	ra,0x0
    80002740:	b8a080e7          	jalr	-1142(ra) # 800022c6 <bread>
    80002744:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002746:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0)
    8000274a:	02091713          	slli	a4,s2,0x20
    8000274e:	01e75913          	srli	s2,a4,0x1e
    80002752:	993e                	add	s2,s2,a5
    80002754:	00092483          	lw	s1,0(s2)
    80002758:	c499                	beqz	s1,80002766 <bmap+0xae>
    brelse(bp);
    8000275a:	8552                	mv	a0,s4
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	c9a080e7          	jalr	-870(ra) # 800023f6 <brelse>
    return addr;
    80002764:	b741                	j	800026e4 <bmap+0x2c>
      addr = balloc(ip->dev);
    80002766:	0009a503          	lw	a0,0(s3)
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	e1c080e7          	jalr	-484(ra) # 80002586 <balloc>
    80002772:	0005049b          	sext.w	s1,a0
      if (addr)
    80002776:	d0f5                	beqz	s1,8000275a <bmap+0xa2>
        a[bn] = addr;
    80002778:	00992023          	sw	s1,0(s2)
        log_write(bp);
    8000277c:	8552                	mv	a0,s4
    8000277e:	00001097          	auipc	ra,0x1
    80002782:	04a080e7          	jalr	74(ra) # 800037c8 <log_write>
    80002786:	bfd1                	j	8000275a <bmap+0xa2>
  bn -= NINDIRECT;
    80002788:	ef55891b          	addiw	s2,a1,-267
    8000278c:	0009071b          	sext.w	a4,s2
  if (bn >= NDINDIRECT)
    80002790:	67c1                	lui	a5,0x10
    80002792:	0af77d63          	bgeu	a4,a5,8000284c <bmap+0x194>
  if ((addr = ip->addrs[NDIRECT + 1]) == 0)
    80002796:	08052483          	lw	s1,128(a0)
    8000279a:	e899                	bnez	s1,800027b0 <bmap+0xf8>
    addr = balloc(ip->dev);
    8000279c:	4108                	lw	a0,0(a0)
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	de8080e7          	jalr	-536(ra) # 80002586 <balloc>
    800027a6:	0005049b          	sext.w	s1,a0
    if (addr == 0)
    800027aa:	dc8d                	beqz	s1,800026e4 <bmap+0x2c>
    ip->addrs[NDIRECT + 1] = addr;
    800027ac:	0899a023          	sw	s1,128(s3)
  bp = bread(ip->dev, addr);
    800027b0:	85a6                	mv	a1,s1
    800027b2:	0009a503          	lw	a0,0(s3)
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	b10080e7          	jalr	-1264(ra) # 800022c6 <bread>
    800027be:	8a2a                	mv	s4,a0
  a = (uint *)bp->data;
    800027c0:	05850a93          	addi	s5,a0,88
  if ((addr = a[bl1]) == 0)
    800027c4:	0089579b          	srliw	a5,s2,0x8
    800027c8:	078a                	slli	a5,a5,0x2
    800027ca:	9abe                	add	s5,s5,a5
    800027cc:	000aa483          	lw	s1,0(s5)
    800027d0:	e08d                	bnez	s1,800027f2 <bmap+0x13a>
    addr = balloc(ip->dev);
    800027d2:	0009a503          	lw	a0,0(s3)
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	db0080e7          	jalr	-592(ra) # 80002586 <balloc>
    800027de:	0005049b          	sext.w	s1,a0
    if (!addr)
    800027e2:	ccad                	beqz	s1,8000285c <bmap+0x1a4>
    a[bl1] = addr;
    800027e4:	009aa023          	sw	s1,0(s5)
    log_write(bp);
    800027e8:	8552                	mv	a0,s4
    800027ea:	00001097          	auipc	ra,0x1
    800027ee:	fde080e7          	jalr	-34(ra) # 800037c8 <log_write>
  brelse(bp);
    800027f2:	8552                	mv	a0,s4
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	c02080e7          	jalr	-1022(ra) # 800023f6 <brelse>
  bp = bread(ip->dev, addr);
    800027fc:	85a6                	mv	a1,s1
    800027fe:	0009a503          	lw	a0,0(s3)
    80002802:	00000097          	auipc	ra,0x0
    80002806:	ac4080e7          	jalr	-1340(ra) # 800022c6 <bread>
    8000280a:	8a2a                	mv	s4,a0
  a = (uint *)bp->data;
    8000280c:	05850793          	addi	a5,a0,88
  if ((addr = a[bl2]) == 0)
    80002810:	0ff97593          	zext.b	a1,s2
    80002814:	058a                	slli	a1,a1,0x2
    80002816:	00b78933          	add	s2,a5,a1
    8000281a:	00092483          	lw	s1,0(s2)
    8000281e:	e08d                	bnez	s1,80002840 <bmap+0x188>
    addr = balloc(ip->dev);
    80002820:	0009a503          	lw	a0,0(s3)
    80002824:	00000097          	auipc	ra,0x0
    80002828:	d62080e7          	jalr	-670(ra) # 80002586 <balloc>
    8000282c:	0005049b          	sext.w	s1,a0
    if (!addr)
    80002830:	cc85                	beqz	s1,80002868 <bmap+0x1b0>
    a[bl2] = addr;
    80002832:	00992023          	sw	s1,0(s2)
    log_write(bp);
    80002836:	8552                	mv	a0,s4
    80002838:	00001097          	auipc	ra,0x1
    8000283c:	f90080e7          	jalr	-112(ra) # 800037c8 <log_write>
  brelse(bp);
    80002840:	8552                	mv	a0,s4
    80002842:	00000097          	auipc	ra,0x0
    80002846:	bb4080e7          	jalr	-1100(ra) # 800023f6 <brelse>
  return addr;
    8000284a:	bd69                	j	800026e4 <bmap+0x2c>
    panic("bmap: out of range");
    8000284c:	00006517          	auipc	a0,0x6
    80002850:	c9c50513          	addi	a0,a0,-868 # 800084e8 <syscalls+0x118>
    80002854:	00003097          	auipc	ra,0x3
    80002858:	452080e7          	jalr	1106(ra) # 80005ca6 <panic>
      brelse(bp);
    8000285c:	8552                	mv	a0,s4
    8000285e:	00000097          	auipc	ra,0x0
    80002862:	b98080e7          	jalr	-1128(ra) # 800023f6 <brelse>
      return 0;
    80002866:	bdbd                	j	800026e4 <bmap+0x2c>
      brelse(bp);
    80002868:	8552                	mv	a0,s4
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	b8c080e7          	jalr	-1140(ra) # 800023f6 <brelse>
      return 0;
    80002872:	bd8d                	j	800026e4 <bmap+0x2c>

0000000080002874 <iget>:
{
    80002874:	7179                	addi	sp,sp,-48
    80002876:	f406                	sd	ra,40(sp)
    80002878:	f022                	sd	s0,32(sp)
    8000287a:	ec26                	sd	s1,24(sp)
    8000287c:	e84a                	sd	s2,16(sp)
    8000287e:	e44e                	sd	s3,8(sp)
    80002880:	e052                	sd	s4,0(sp)
    80002882:	1800                	addi	s0,sp,48
    80002884:	89aa                	mv	s3,a0
    80002886:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002888:	00010517          	auipc	a0,0x10
    8000288c:	99050513          	addi	a0,a0,-1648 # 80012218 <itable>
    80002890:	00004097          	auipc	ra,0x4
    80002894:	94e080e7          	jalr	-1714(ra) # 800061de <acquire>
  empty = 0;
    80002898:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8000289a:	00010497          	auipc	s1,0x10
    8000289e:	99648493          	addi	s1,s1,-1642 # 80012230 <itable+0x18>
    800028a2:	00011697          	auipc	a3,0x11
    800028a6:	41e68693          	addi	a3,a3,1054 # 80013cc0 <log>
    800028aa:	a039                	j	800028b8 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800028ac:	02090b63          	beqz	s2,800028e2 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    800028b0:	08848493          	addi	s1,s1,136
    800028b4:	02d48a63          	beq	s1,a3,800028e8 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    800028b8:	449c                	lw	a5,8(s1)
    800028ba:	fef059e3          	blez	a5,800028ac <iget+0x38>
    800028be:	4098                	lw	a4,0(s1)
    800028c0:	ff3716e3          	bne	a4,s3,800028ac <iget+0x38>
    800028c4:	40d8                	lw	a4,4(s1)
    800028c6:	ff4713e3          	bne	a4,s4,800028ac <iget+0x38>
      ip->ref++;
    800028ca:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    800028cc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028ce:	00010517          	auipc	a0,0x10
    800028d2:	94a50513          	addi	a0,a0,-1718 # 80012218 <itable>
    800028d6:	00004097          	auipc	ra,0x4
    800028da:	9bc080e7          	jalr	-1604(ra) # 80006292 <release>
      return ip;
    800028de:	8926                	mv	s2,s1
    800028e0:	a03d                	j	8000290e <iget+0x9a>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800028e2:	f7f9                	bnez	a5,800028b0 <iget+0x3c>
    800028e4:	8926                	mv	s2,s1
    800028e6:	b7e9                	j	800028b0 <iget+0x3c>
  if (empty == 0)
    800028e8:	02090c63          	beqz	s2,80002920 <iget+0xac>
  ip->dev = dev;
    800028ec:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028f0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028f4:	4785                	li	a5,1
    800028f6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028fa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028fe:	00010517          	auipc	a0,0x10
    80002902:	91a50513          	addi	a0,a0,-1766 # 80012218 <itable>
    80002906:	00004097          	auipc	ra,0x4
    8000290a:	98c080e7          	jalr	-1652(ra) # 80006292 <release>
}
    8000290e:	854a                	mv	a0,s2
    80002910:	70a2                	ld	ra,40(sp)
    80002912:	7402                	ld	s0,32(sp)
    80002914:	64e2                	ld	s1,24(sp)
    80002916:	6942                	ld	s2,16(sp)
    80002918:	69a2                	ld	s3,8(sp)
    8000291a:	6a02                	ld	s4,0(sp)
    8000291c:	6145                	addi	sp,sp,48
    8000291e:	8082                	ret
    panic("iget: no inodes");
    80002920:	00006517          	auipc	a0,0x6
    80002924:	be050513          	addi	a0,a0,-1056 # 80008500 <syscalls+0x130>
    80002928:	00003097          	auipc	ra,0x3
    8000292c:	37e080e7          	jalr	894(ra) # 80005ca6 <panic>

0000000080002930 <fsinit>:
{
    80002930:	7179                	addi	sp,sp,-48
    80002932:	f406                	sd	ra,40(sp)
    80002934:	f022                	sd	s0,32(sp)
    80002936:	ec26                	sd	s1,24(sp)
    80002938:	e84a                	sd	s2,16(sp)
    8000293a:	e44e                	sd	s3,8(sp)
    8000293c:	1800                	addi	s0,sp,48
    8000293e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002940:	4585                	li	a1,1
    80002942:	00000097          	auipc	ra,0x0
    80002946:	984080e7          	jalr	-1660(ra) # 800022c6 <bread>
    8000294a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000294c:	00010997          	auipc	s3,0x10
    80002950:	8ac98993          	addi	s3,s3,-1876 # 800121f8 <sb>
    80002954:	02000613          	li	a2,32
    80002958:	05850593          	addi	a1,a0,88
    8000295c:	854e                	mv	a0,s3
    8000295e:	ffffe097          	auipc	ra,0xffffe
    80002962:	878080e7          	jalr	-1928(ra) # 800001d6 <memmove>
  brelse(bp);
    80002966:	8526                	mv	a0,s1
    80002968:	00000097          	auipc	ra,0x0
    8000296c:	a8e080e7          	jalr	-1394(ra) # 800023f6 <brelse>
  if (sb.magic != FSMAGIC)
    80002970:	0009a703          	lw	a4,0(s3)
    80002974:	102037b7          	lui	a5,0x10203
    80002978:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000297c:	02f71263          	bne	a4,a5,800029a0 <fsinit+0x70>
  initlog(dev, &sb);
    80002980:	00010597          	auipc	a1,0x10
    80002984:	87858593          	addi	a1,a1,-1928 # 800121f8 <sb>
    80002988:	854a                	mv	a0,s2
    8000298a:	00001097          	auipc	ra,0x1
    8000298e:	bd4080e7          	jalr	-1068(ra) # 8000355e <initlog>
}
    80002992:	70a2                	ld	ra,40(sp)
    80002994:	7402                	ld	s0,32(sp)
    80002996:	64e2                	ld	s1,24(sp)
    80002998:	6942                	ld	s2,16(sp)
    8000299a:	69a2                	ld	s3,8(sp)
    8000299c:	6145                	addi	sp,sp,48
    8000299e:	8082                	ret
    panic("invalid file system");
    800029a0:	00006517          	auipc	a0,0x6
    800029a4:	b7050513          	addi	a0,a0,-1168 # 80008510 <syscalls+0x140>
    800029a8:	00003097          	auipc	ra,0x3
    800029ac:	2fe080e7          	jalr	766(ra) # 80005ca6 <panic>

00000000800029b0 <iinit>:
{
    800029b0:	7179                	addi	sp,sp,-48
    800029b2:	f406                	sd	ra,40(sp)
    800029b4:	f022                	sd	s0,32(sp)
    800029b6:	ec26                	sd	s1,24(sp)
    800029b8:	e84a                	sd	s2,16(sp)
    800029ba:	e44e                	sd	s3,8(sp)
    800029bc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029be:	00006597          	auipc	a1,0x6
    800029c2:	b6a58593          	addi	a1,a1,-1174 # 80008528 <syscalls+0x158>
    800029c6:	00010517          	auipc	a0,0x10
    800029ca:	85250513          	addi	a0,a0,-1966 # 80012218 <itable>
    800029ce:	00003097          	auipc	ra,0x3
    800029d2:	780080e7          	jalr	1920(ra) # 8000614e <initlock>
  for (i = 0; i < NINODE; i++)
    800029d6:	00010497          	auipc	s1,0x10
    800029da:	86a48493          	addi	s1,s1,-1942 # 80012240 <itable+0x28>
    800029de:	00011997          	auipc	s3,0x11
    800029e2:	2f298993          	addi	s3,s3,754 # 80013cd0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029e6:	00006917          	auipc	s2,0x6
    800029ea:	b4a90913          	addi	s2,s2,-1206 # 80008530 <syscalls+0x160>
    800029ee:	85ca                	mv	a1,s2
    800029f0:	8526                	mv	a0,s1
    800029f2:	00001097          	auipc	ra,0x1
    800029f6:	eba080e7          	jalr	-326(ra) # 800038ac <initsleeplock>
  for (i = 0; i < NINODE; i++)
    800029fa:	08848493          	addi	s1,s1,136
    800029fe:	ff3498e3          	bne	s1,s3,800029ee <iinit+0x3e>
}
    80002a02:	70a2                	ld	ra,40(sp)
    80002a04:	7402                	ld	s0,32(sp)
    80002a06:	64e2                	ld	s1,24(sp)
    80002a08:	6942                	ld	s2,16(sp)
    80002a0a:	69a2                	ld	s3,8(sp)
    80002a0c:	6145                	addi	sp,sp,48
    80002a0e:	8082                	ret

0000000080002a10 <ialloc>:
{
    80002a10:	7139                	addi	sp,sp,-64
    80002a12:	fc06                	sd	ra,56(sp)
    80002a14:	f822                	sd	s0,48(sp)
    80002a16:	f426                	sd	s1,40(sp)
    80002a18:	f04a                	sd	s2,32(sp)
    80002a1a:	ec4e                	sd	s3,24(sp)
    80002a1c:	e852                	sd	s4,16(sp)
    80002a1e:	e456                	sd	s5,8(sp)
    80002a20:	e05a                	sd	s6,0(sp)
    80002a22:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++)
    80002a24:	0000f717          	auipc	a4,0xf
    80002a28:	7e072703          	lw	a4,2016(a4) # 80012204 <sb+0xc>
    80002a2c:	4785                	li	a5,1
    80002a2e:	04e7f863          	bgeu	a5,a4,80002a7e <ialloc+0x6e>
    80002a32:	8aaa                	mv	s5,a0
    80002a34:	8b2e                	mv	s6,a1
    80002a36:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a38:	0000fa17          	auipc	s4,0xf
    80002a3c:	7c0a0a13          	addi	s4,s4,1984 # 800121f8 <sb>
    80002a40:	00495593          	srli	a1,s2,0x4
    80002a44:	018a2783          	lw	a5,24(s4)
    80002a48:	9dbd                	addw	a1,a1,a5
    80002a4a:	8556                	mv	a0,s5
    80002a4c:	00000097          	auipc	ra,0x0
    80002a50:	87a080e7          	jalr	-1926(ra) # 800022c6 <bread>
    80002a54:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002a56:	05850993          	addi	s3,a0,88
    80002a5a:	00f97793          	andi	a5,s2,15
    80002a5e:	079a                	slli	a5,a5,0x6
    80002a60:	99be                	add	s3,s3,a5
    if (dip->type == 0)
    80002a62:	00099783          	lh	a5,0(s3)
    80002a66:	cf9d                	beqz	a5,80002aa4 <ialloc+0x94>
    brelse(bp);
    80002a68:	00000097          	auipc	ra,0x0
    80002a6c:	98e080e7          	jalr	-1650(ra) # 800023f6 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++)
    80002a70:	0905                	addi	s2,s2,1
    80002a72:	00ca2703          	lw	a4,12(s4)
    80002a76:	0009079b          	sext.w	a5,s2
    80002a7a:	fce7e3e3          	bltu	a5,a4,80002a40 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002a7e:	00006517          	auipc	a0,0x6
    80002a82:	aba50513          	addi	a0,a0,-1350 # 80008538 <syscalls+0x168>
    80002a86:	00003097          	auipc	ra,0x3
    80002a8a:	26a080e7          	jalr	618(ra) # 80005cf0 <printf>
  return 0;
    80002a8e:	4501                	li	a0,0
}
    80002a90:	70e2                	ld	ra,56(sp)
    80002a92:	7442                	ld	s0,48(sp)
    80002a94:	74a2                	ld	s1,40(sp)
    80002a96:	7902                	ld	s2,32(sp)
    80002a98:	69e2                	ld	s3,24(sp)
    80002a9a:	6a42                	ld	s4,16(sp)
    80002a9c:	6aa2                	ld	s5,8(sp)
    80002a9e:	6b02                	ld	s6,0(sp)
    80002aa0:	6121                	addi	sp,sp,64
    80002aa2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002aa4:	04000613          	li	a2,64
    80002aa8:	4581                	li	a1,0
    80002aaa:	854e                	mv	a0,s3
    80002aac:	ffffd097          	auipc	ra,0xffffd
    80002ab0:	6ce080e7          	jalr	1742(ra) # 8000017a <memset>
      dip->type = type;
    80002ab4:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80002ab8:	8526                	mv	a0,s1
    80002aba:	00001097          	auipc	ra,0x1
    80002abe:	d0e080e7          	jalr	-754(ra) # 800037c8 <log_write>
      brelse(bp);
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	932080e7          	jalr	-1742(ra) # 800023f6 <brelse>
      return iget(dev, inum);
    80002acc:	0009059b          	sext.w	a1,s2
    80002ad0:	8556                	mv	a0,s5
    80002ad2:	00000097          	auipc	ra,0x0
    80002ad6:	da2080e7          	jalr	-606(ra) # 80002874 <iget>
    80002ada:	bf5d                	j	80002a90 <ialloc+0x80>

0000000080002adc <iupdate>:
{
    80002adc:	1101                	addi	sp,sp,-32
    80002ade:	ec06                	sd	ra,24(sp)
    80002ae0:	e822                	sd	s0,16(sp)
    80002ae2:	e426                	sd	s1,8(sp)
    80002ae4:	e04a                	sd	s2,0(sp)
    80002ae6:	1000                	addi	s0,sp,32
    80002ae8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aea:	415c                	lw	a5,4(a0)
    80002aec:	0047d79b          	srliw	a5,a5,0x4
    80002af0:	0000f597          	auipc	a1,0xf
    80002af4:	7205a583          	lw	a1,1824(a1) # 80012210 <sb+0x18>
    80002af8:	9dbd                	addw	a1,a1,a5
    80002afa:	4108                	lw	a0,0(a0)
    80002afc:	fffff097          	auipc	ra,0xfffff
    80002b00:	7ca080e7          	jalr	1994(ra) # 800022c6 <bread>
    80002b04:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b06:	05850793          	addi	a5,a0,88
    80002b0a:	40d8                	lw	a4,4(s1)
    80002b0c:	8b3d                	andi	a4,a4,15
    80002b0e:	071a                	slli	a4,a4,0x6
    80002b10:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b12:	04449703          	lh	a4,68(s1)
    80002b16:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b1a:	04649703          	lh	a4,70(s1)
    80002b1e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b22:	04849703          	lh	a4,72(s1)
    80002b26:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b2a:	04a49703          	lh	a4,74(s1)
    80002b2e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b32:	44f8                	lw	a4,76(s1)
    80002b34:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b36:	03400613          	li	a2,52
    80002b3a:	05048593          	addi	a1,s1,80
    80002b3e:	00c78513          	addi	a0,a5,12
    80002b42:	ffffd097          	auipc	ra,0xffffd
    80002b46:	694080e7          	jalr	1684(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b4a:	854a                	mv	a0,s2
    80002b4c:	00001097          	auipc	ra,0x1
    80002b50:	c7c080e7          	jalr	-900(ra) # 800037c8 <log_write>
  brelse(bp);
    80002b54:	854a                	mv	a0,s2
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	8a0080e7          	jalr	-1888(ra) # 800023f6 <brelse>
}
    80002b5e:	60e2                	ld	ra,24(sp)
    80002b60:	6442                	ld	s0,16(sp)
    80002b62:	64a2                	ld	s1,8(sp)
    80002b64:	6902                	ld	s2,0(sp)
    80002b66:	6105                	addi	sp,sp,32
    80002b68:	8082                	ret

0000000080002b6a <idup>:
{
    80002b6a:	1101                	addi	sp,sp,-32
    80002b6c:	ec06                	sd	ra,24(sp)
    80002b6e:	e822                	sd	s0,16(sp)
    80002b70:	e426                	sd	s1,8(sp)
    80002b72:	1000                	addi	s0,sp,32
    80002b74:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b76:	0000f517          	auipc	a0,0xf
    80002b7a:	6a250513          	addi	a0,a0,1698 # 80012218 <itable>
    80002b7e:	00003097          	auipc	ra,0x3
    80002b82:	660080e7          	jalr	1632(ra) # 800061de <acquire>
  ip->ref++;
    80002b86:	449c                	lw	a5,8(s1)
    80002b88:	2785                	addiw	a5,a5,1
    80002b8a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b8c:	0000f517          	auipc	a0,0xf
    80002b90:	68c50513          	addi	a0,a0,1676 # 80012218 <itable>
    80002b94:	00003097          	auipc	ra,0x3
    80002b98:	6fe080e7          	jalr	1790(ra) # 80006292 <release>
}
    80002b9c:	8526                	mv	a0,s1
    80002b9e:	60e2                	ld	ra,24(sp)
    80002ba0:	6442                	ld	s0,16(sp)
    80002ba2:	64a2                	ld	s1,8(sp)
    80002ba4:	6105                	addi	sp,sp,32
    80002ba6:	8082                	ret

0000000080002ba8 <ilock>:
{
    80002ba8:	1101                	addi	sp,sp,-32
    80002baa:	ec06                	sd	ra,24(sp)
    80002bac:	e822                	sd	s0,16(sp)
    80002bae:	e426                	sd	s1,8(sp)
    80002bb0:	e04a                	sd	s2,0(sp)
    80002bb2:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80002bb4:	c115                	beqz	a0,80002bd8 <ilock+0x30>
    80002bb6:	84aa                	mv	s1,a0
    80002bb8:	451c                	lw	a5,8(a0)
    80002bba:	00f05f63          	blez	a5,80002bd8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bbe:	0541                	addi	a0,a0,16
    80002bc0:	00001097          	auipc	ra,0x1
    80002bc4:	d26080e7          	jalr	-730(ra) # 800038e6 <acquiresleep>
  if (ip->valid == 0)
    80002bc8:	40bc                	lw	a5,64(s1)
    80002bca:	cf99                	beqz	a5,80002be8 <ilock+0x40>
}
    80002bcc:	60e2                	ld	ra,24(sp)
    80002bce:	6442                	ld	s0,16(sp)
    80002bd0:	64a2                	ld	s1,8(sp)
    80002bd2:	6902                	ld	s2,0(sp)
    80002bd4:	6105                	addi	sp,sp,32
    80002bd6:	8082                	ret
    panic("ilock");
    80002bd8:	00006517          	auipc	a0,0x6
    80002bdc:	97850513          	addi	a0,a0,-1672 # 80008550 <syscalls+0x180>
    80002be0:	00003097          	auipc	ra,0x3
    80002be4:	0c6080e7          	jalr	198(ra) # 80005ca6 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002be8:	40dc                	lw	a5,4(s1)
    80002bea:	0047d79b          	srliw	a5,a5,0x4
    80002bee:	0000f597          	auipc	a1,0xf
    80002bf2:	6225a583          	lw	a1,1570(a1) # 80012210 <sb+0x18>
    80002bf6:	9dbd                	addw	a1,a1,a5
    80002bf8:	4088                	lw	a0,0(s1)
    80002bfa:	fffff097          	auipc	ra,0xfffff
    80002bfe:	6cc080e7          	jalr	1740(ra) # 800022c6 <bread>
    80002c02:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c04:	05850593          	addi	a1,a0,88
    80002c08:	40dc                	lw	a5,4(s1)
    80002c0a:	8bbd                	andi	a5,a5,15
    80002c0c:	079a                	slli	a5,a5,0x6
    80002c0e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c10:	00059783          	lh	a5,0(a1)
    80002c14:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c18:	00259783          	lh	a5,2(a1)
    80002c1c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c20:	00459783          	lh	a5,4(a1)
    80002c24:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c28:	00659783          	lh	a5,6(a1)
    80002c2c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c30:	459c                	lw	a5,8(a1)
    80002c32:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c34:	03400613          	li	a2,52
    80002c38:	05b1                	addi	a1,a1,12
    80002c3a:	05048513          	addi	a0,s1,80
    80002c3e:	ffffd097          	auipc	ra,0xffffd
    80002c42:	598080e7          	jalr	1432(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c46:	854a                	mv	a0,s2
    80002c48:	fffff097          	auipc	ra,0xfffff
    80002c4c:	7ae080e7          	jalr	1966(ra) # 800023f6 <brelse>
    ip->valid = 1;
    80002c50:	4785                	li	a5,1
    80002c52:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80002c54:	04449783          	lh	a5,68(s1)
    80002c58:	fbb5                	bnez	a5,80002bcc <ilock+0x24>
      panic("ilock: no type");
    80002c5a:	00006517          	auipc	a0,0x6
    80002c5e:	8fe50513          	addi	a0,a0,-1794 # 80008558 <syscalls+0x188>
    80002c62:	00003097          	auipc	ra,0x3
    80002c66:	044080e7          	jalr	68(ra) # 80005ca6 <panic>

0000000080002c6a <iunlock>:
{
    80002c6a:	1101                	addi	sp,sp,-32
    80002c6c:	ec06                	sd	ra,24(sp)
    80002c6e:	e822                	sd	s0,16(sp)
    80002c70:	e426                	sd	s1,8(sp)
    80002c72:	e04a                	sd	s2,0(sp)
    80002c74:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c76:	c905                	beqz	a0,80002ca6 <iunlock+0x3c>
    80002c78:	84aa                	mv	s1,a0
    80002c7a:	01050913          	addi	s2,a0,16
    80002c7e:	854a                	mv	a0,s2
    80002c80:	00001097          	auipc	ra,0x1
    80002c84:	d00080e7          	jalr	-768(ra) # 80003980 <holdingsleep>
    80002c88:	cd19                	beqz	a0,80002ca6 <iunlock+0x3c>
    80002c8a:	449c                	lw	a5,8(s1)
    80002c8c:	00f05d63          	blez	a5,80002ca6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c90:	854a                	mv	a0,s2
    80002c92:	00001097          	auipc	ra,0x1
    80002c96:	caa080e7          	jalr	-854(ra) # 8000393c <releasesleep>
}
    80002c9a:	60e2                	ld	ra,24(sp)
    80002c9c:	6442                	ld	s0,16(sp)
    80002c9e:	64a2                	ld	s1,8(sp)
    80002ca0:	6902                	ld	s2,0(sp)
    80002ca2:	6105                	addi	sp,sp,32
    80002ca4:	8082                	ret
    panic("iunlock");
    80002ca6:	00006517          	auipc	a0,0x6
    80002caa:	8c250513          	addi	a0,a0,-1854 # 80008568 <syscalls+0x198>
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	ff8080e7          	jalr	-8(ra) # 80005ca6 <panic>

0000000080002cb6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80002cb6:	715d                	addi	sp,sp,-80
    80002cb8:	e486                	sd	ra,72(sp)
    80002cba:	e0a2                	sd	s0,64(sp)
    80002cbc:	fc26                	sd	s1,56(sp)
    80002cbe:	f84a                	sd	s2,48(sp)
    80002cc0:	f44e                	sd	s3,40(sp)
    80002cc2:	f052                	sd	s4,32(sp)
    80002cc4:	ec56                	sd	s5,24(sp)
    80002cc6:	e85a                	sd	s6,16(sp)
    80002cc8:	e45e                	sd	s7,8(sp)
    80002cca:	e062                	sd	s8,0(sp)
    80002ccc:	0880                	addi	s0,sp,80
    80002cce:	89aa                	mv	s3,a0
  int i, j, k;
  struct buf *bp;
  struct buf *nbp;
  uint *a, *na;

  for (i = 0; i < NDIRECT; i++)
    80002cd0:	05050493          	addi	s1,a0,80
    80002cd4:	07c50913          	addi	s2,a0,124
    80002cd8:	a021                	j	80002ce0 <itrunc+0x2a>
    80002cda:	0491                	addi	s1,s1,4
    80002cdc:	01248d63          	beq	s1,s2,80002cf6 <itrunc+0x40>
  {
    if (ip->addrs[i])
    80002ce0:	408c                	lw	a1,0(s1)
    80002ce2:	dde5                	beqz	a1,80002cda <itrunc+0x24>
    {
      bfree(ip->dev, ip->addrs[i]);
    80002ce4:	0009a503          	lw	a0,0(s3)
    80002ce8:	00000097          	auipc	ra,0x0
    80002cec:	822080e7          	jalr	-2014(ra) # 8000250a <bfree>
      ip->addrs[i] = 0;
    80002cf0:	0004a023          	sw	zero,0(s1)
    80002cf4:	b7dd                	j	80002cda <itrunc+0x24>
    }
  }

  if (ip->addrs[NDIRECT])
    80002cf6:	07c9a583          	lw	a1,124(s3)
    80002cfa:	e59d                	bnez	a1,80002d28 <itrunc+0x72>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  if (ip->addrs[NDIRECT + 1])
    80002cfc:	0809a583          	lw	a1,128(s3)
    80002d00:	eda5                	bnez	a1,80002d78 <itrunc+0xc2>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    ip->addrs[NDIRECT + 1] = 0;
  }

  ip->size = 0;
    80002d02:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d06:	854e                	mv	a0,s3
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	dd4080e7          	jalr	-556(ra) # 80002adc <iupdate>
}
    80002d10:	60a6                	ld	ra,72(sp)
    80002d12:	6406                	ld	s0,64(sp)
    80002d14:	74e2                	ld	s1,56(sp)
    80002d16:	7942                	ld	s2,48(sp)
    80002d18:	79a2                	ld	s3,40(sp)
    80002d1a:	7a02                	ld	s4,32(sp)
    80002d1c:	6ae2                	ld	s5,24(sp)
    80002d1e:	6b42                	ld	s6,16(sp)
    80002d20:	6ba2                	ld	s7,8(sp)
    80002d22:	6c02                	ld	s8,0(sp)
    80002d24:	6161                	addi	sp,sp,80
    80002d26:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d28:	0009a503          	lw	a0,0(s3)
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	59a080e7          	jalr	1434(ra) # 800022c6 <bread>
    80002d34:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++)
    80002d36:	05850493          	addi	s1,a0,88
    80002d3a:	45850913          	addi	s2,a0,1112
    80002d3e:	a021                	j	80002d46 <itrunc+0x90>
    80002d40:	0491                	addi	s1,s1,4
    80002d42:	01248b63          	beq	s1,s2,80002d58 <itrunc+0xa2>
      if (a[j])
    80002d46:	408c                	lw	a1,0(s1)
    80002d48:	dde5                	beqz	a1,80002d40 <itrunc+0x8a>
        bfree(ip->dev, a[j]);
    80002d4a:	0009a503          	lw	a0,0(s3)
    80002d4e:	fffff097          	auipc	ra,0xfffff
    80002d52:	7bc080e7          	jalr	1980(ra) # 8000250a <bfree>
    80002d56:	b7ed                	j	80002d40 <itrunc+0x8a>
    brelse(bp);
    80002d58:	8552                	mv	a0,s4
    80002d5a:	fffff097          	auipc	ra,0xfffff
    80002d5e:	69c080e7          	jalr	1692(ra) # 800023f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d62:	07c9a583          	lw	a1,124(s3)
    80002d66:	0009a503          	lw	a0,0(s3)
    80002d6a:	fffff097          	auipc	ra,0xfffff
    80002d6e:	7a0080e7          	jalr	1952(ra) # 8000250a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d72:	0609ae23          	sw	zero,124(s3)
    80002d76:	b759                	j	80002cfc <itrunc+0x46>
    bp = bread(ip->dev, ip->addrs[NDIRECT + 1]);
    80002d78:	0009a503          	lw	a0,0(s3)
    80002d7c:	fffff097          	auipc	ra,0xfffff
    80002d80:	54a080e7          	jalr	1354(ra) # 800022c6 <bread>
    80002d84:	8c2a                	mv	s8,a0
    for (j = 0; j < NINDIRECT; j++)
    80002d86:	05850a13          	addi	s4,a0,88
    80002d8a:	45850b13          	addi	s6,a0,1112
    80002d8e:	a82d                	j	80002dc8 <itrunc+0x112>
        for (k = 0; k < NINDIRECT; k++)
    80002d90:	0491                	addi	s1,s1,4
    80002d92:	00990b63          	beq	s2,s1,80002da8 <itrunc+0xf2>
          if (na[k])
    80002d96:	408c                	lw	a1,0(s1)
    80002d98:	dde5                	beqz	a1,80002d90 <itrunc+0xda>
            bfree(ip->dev, na[k]);
    80002d9a:	0009a503          	lw	a0,0(s3)
    80002d9e:	fffff097          	auipc	ra,0xfffff
    80002da2:	76c080e7          	jalr	1900(ra) # 8000250a <bfree>
    80002da6:	b7ed                	j	80002d90 <itrunc+0xda>
        brelse(nbp);
    80002da8:	855e                	mv	a0,s7
    80002daa:	fffff097          	auipc	ra,0xfffff
    80002dae:	64c080e7          	jalr	1612(ra) # 800023f6 <brelse>
        bfree(ip->dev, a[j]);
    80002db2:	000aa583          	lw	a1,0(s5)
    80002db6:	0009a503          	lw	a0,0(s3)
    80002dba:	fffff097          	auipc	ra,0xfffff
    80002dbe:	750080e7          	jalr	1872(ra) # 8000250a <bfree>
    for (j = 0; j < NINDIRECT; j++)
    80002dc2:	0a11                	addi	s4,s4,4
    80002dc4:	034b0263          	beq	s6,s4,80002de8 <itrunc+0x132>
      if (a[j])
    80002dc8:	8ad2                	mv	s5,s4
    80002dca:	000a2583          	lw	a1,0(s4)
    80002dce:	d9f5                	beqz	a1,80002dc2 <itrunc+0x10c>
        nbp = bread(ip->dev, a[j]);
    80002dd0:	0009a503          	lw	a0,0(s3)
    80002dd4:	fffff097          	auipc	ra,0xfffff
    80002dd8:	4f2080e7          	jalr	1266(ra) # 800022c6 <bread>
    80002ddc:	8baa                	mv	s7,a0
        for (k = 0; k < NINDIRECT; k++)
    80002dde:	05850493          	addi	s1,a0,88
    80002de2:	45850913          	addi	s2,a0,1112
    80002de6:	bf45                	j	80002d96 <itrunc+0xe0>
    brelse(bp);
    80002de8:	8562                	mv	a0,s8
    80002dea:	fffff097          	auipc	ra,0xfffff
    80002dee:	60c080e7          	jalr	1548(ra) # 800023f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    80002df2:	0809a583          	lw	a1,128(s3)
    80002df6:	0009a503          	lw	a0,0(s3)
    80002dfa:	fffff097          	auipc	ra,0xfffff
    80002dfe:	710080e7          	jalr	1808(ra) # 8000250a <bfree>
    ip->addrs[NDIRECT + 1] = 0;
    80002e02:	0809a023          	sw	zero,128(s3)
    80002e06:	bdf5                	j	80002d02 <itrunc+0x4c>

0000000080002e08 <iput>:
{
    80002e08:	1101                	addi	sp,sp,-32
    80002e0a:	ec06                	sd	ra,24(sp)
    80002e0c:	e822                	sd	s0,16(sp)
    80002e0e:	e426                	sd	s1,8(sp)
    80002e10:	e04a                	sd	s2,0(sp)
    80002e12:	1000                	addi	s0,sp,32
    80002e14:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e16:	0000f517          	auipc	a0,0xf
    80002e1a:	40250513          	addi	a0,a0,1026 # 80012218 <itable>
    80002e1e:	00003097          	auipc	ra,0x3
    80002e22:	3c0080e7          	jalr	960(ra) # 800061de <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002e26:	4498                	lw	a4,8(s1)
    80002e28:	4785                	li	a5,1
    80002e2a:	02f70363          	beq	a4,a5,80002e50 <iput+0x48>
  ip->ref--;
    80002e2e:	449c                	lw	a5,8(s1)
    80002e30:	37fd                	addiw	a5,a5,-1
    80002e32:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e34:	0000f517          	auipc	a0,0xf
    80002e38:	3e450513          	addi	a0,a0,996 # 80012218 <itable>
    80002e3c:	00003097          	auipc	ra,0x3
    80002e40:	456080e7          	jalr	1110(ra) # 80006292 <release>
}
    80002e44:	60e2                	ld	ra,24(sp)
    80002e46:	6442                	ld	s0,16(sp)
    80002e48:	64a2                	ld	s1,8(sp)
    80002e4a:	6902                	ld	s2,0(sp)
    80002e4c:	6105                	addi	sp,sp,32
    80002e4e:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002e50:	40bc                	lw	a5,64(s1)
    80002e52:	dff1                	beqz	a5,80002e2e <iput+0x26>
    80002e54:	04a49783          	lh	a5,74(s1)
    80002e58:	fbf9                	bnez	a5,80002e2e <iput+0x26>
    acquiresleep(&ip->lock);
    80002e5a:	01048913          	addi	s2,s1,16
    80002e5e:	854a                	mv	a0,s2
    80002e60:	00001097          	auipc	ra,0x1
    80002e64:	a86080e7          	jalr	-1402(ra) # 800038e6 <acquiresleep>
    release(&itable.lock);
    80002e68:	0000f517          	auipc	a0,0xf
    80002e6c:	3b050513          	addi	a0,a0,944 # 80012218 <itable>
    80002e70:	00003097          	auipc	ra,0x3
    80002e74:	422080e7          	jalr	1058(ra) # 80006292 <release>
    itrunc(ip);
    80002e78:	8526                	mv	a0,s1
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	e3c080e7          	jalr	-452(ra) # 80002cb6 <itrunc>
    ip->type = 0;
    80002e82:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e86:	8526                	mv	a0,s1
    80002e88:	00000097          	auipc	ra,0x0
    80002e8c:	c54080e7          	jalr	-940(ra) # 80002adc <iupdate>
    ip->valid = 0;
    80002e90:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e94:	854a                	mv	a0,s2
    80002e96:	00001097          	auipc	ra,0x1
    80002e9a:	aa6080e7          	jalr	-1370(ra) # 8000393c <releasesleep>
    acquire(&itable.lock);
    80002e9e:	0000f517          	auipc	a0,0xf
    80002ea2:	37a50513          	addi	a0,a0,890 # 80012218 <itable>
    80002ea6:	00003097          	auipc	ra,0x3
    80002eaa:	338080e7          	jalr	824(ra) # 800061de <acquire>
    80002eae:	b741                	j	80002e2e <iput+0x26>

0000000080002eb0 <iunlockput>:
{
    80002eb0:	1101                	addi	sp,sp,-32
    80002eb2:	ec06                	sd	ra,24(sp)
    80002eb4:	e822                	sd	s0,16(sp)
    80002eb6:	e426                	sd	s1,8(sp)
    80002eb8:	1000                	addi	s0,sp,32
    80002eba:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	dae080e7          	jalr	-594(ra) # 80002c6a <iunlock>
  iput(ip);
    80002ec4:	8526                	mv	a0,s1
    80002ec6:	00000097          	auipc	ra,0x0
    80002eca:	f42080e7          	jalr	-190(ra) # 80002e08 <iput>
}
    80002ece:	60e2                	ld	ra,24(sp)
    80002ed0:	6442                	ld	s0,16(sp)
    80002ed2:	64a2                	ld	s1,8(sp)
    80002ed4:	6105                	addi	sp,sp,32
    80002ed6:	8082                	ret

0000000080002ed8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002ed8:	1141                	addi	sp,sp,-16
    80002eda:	e422                	sd	s0,8(sp)
    80002edc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ede:	411c                	lw	a5,0(a0)
    80002ee0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ee2:	415c                	lw	a5,4(a0)
    80002ee4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ee6:	04451783          	lh	a5,68(a0)
    80002eea:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002eee:	04a51783          	lh	a5,74(a0)
    80002ef2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ef6:	04c56783          	lwu	a5,76(a0)
    80002efa:	e99c                	sd	a5,16(a1)
}
    80002efc:	6422                	ld	s0,8(sp)
    80002efe:	0141                	addi	sp,sp,16
    80002f00:	8082                	ret

0000000080002f02 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80002f02:	457c                	lw	a5,76(a0)
    80002f04:	0ed7e963          	bltu	a5,a3,80002ff6 <readi+0xf4>
{
    80002f08:	7159                	addi	sp,sp,-112
    80002f0a:	f486                	sd	ra,104(sp)
    80002f0c:	f0a2                	sd	s0,96(sp)
    80002f0e:	eca6                	sd	s1,88(sp)
    80002f10:	e8ca                	sd	s2,80(sp)
    80002f12:	e4ce                	sd	s3,72(sp)
    80002f14:	e0d2                	sd	s4,64(sp)
    80002f16:	fc56                	sd	s5,56(sp)
    80002f18:	f85a                	sd	s6,48(sp)
    80002f1a:	f45e                	sd	s7,40(sp)
    80002f1c:	f062                	sd	s8,32(sp)
    80002f1e:	ec66                	sd	s9,24(sp)
    80002f20:	e86a                	sd	s10,16(sp)
    80002f22:	e46e                	sd	s11,8(sp)
    80002f24:	1880                	addi	s0,sp,112
    80002f26:	8b2a                	mv	s6,a0
    80002f28:	8bae                	mv	s7,a1
    80002f2a:	8a32                	mv	s4,a2
    80002f2c:	84b6                	mv	s1,a3
    80002f2e:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    80002f30:	9f35                	addw	a4,a4,a3
    return 0;
    80002f32:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80002f34:	0ad76063          	bltu	a4,a3,80002fd4 <readi+0xd2>
  if (off + n > ip->size)
    80002f38:	00e7f463          	bgeu	a5,a4,80002f40 <readi+0x3e>
    n = ip->size - off;
    80002f3c:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f40:	0a0a8963          	beqz	s5,80002ff2 <readi+0xf0>
    80002f44:	4981                	li	s3,0
  {
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f46:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80002f4a:	5c7d                	li	s8,-1
    80002f4c:	a82d                	j	80002f86 <readi+0x84>
    80002f4e:	020d1d93          	slli	s11,s10,0x20
    80002f52:	020ddd93          	srli	s11,s11,0x20
    80002f56:	05890613          	addi	a2,s2,88
    80002f5a:	86ee                	mv	a3,s11
    80002f5c:	963a                	add	a2,a2,a4
    80002f5e:	85d2                	mv	a1,s4
    80002f60:	855e                	mv	a0,s7
    80002f62:	fffff097          	auipc	ra,0xfffff
    80002f66:	99a080e7          	jalr	-1638(ra) # 800018fc <either_copyout>
    80002f6a:	05850d63          	beq	a0,s8,80002fc4 <readi+0xc2>
    {
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f6e:	854a                	mv	a0,s2
    80002f70:	fffff097          	auipc	ra,0xfffff
    80002f74:	486080e7          	jalr	1158(ra) # 800023f6 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f78:	013d09bb          	addw	s3,s10,s3
    80002f7c:	009d04bb          	addw	s1,s10,s1
    80002f80:	9a6e                	add	s4,s4,s11
    80002f82:	0559f763          	bgeu	s3,s5,80002fd0 <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    80002f86:	00a4d59b          	srliw	a1,s1,0xa
    80002f8a:	855a                	mv	a0,s6
    80002f8c:	fffff097          	auipc	ra,0xfffff
    80002f90:	72c080e7          	jalr	1836(ra) # 800026b8 <bmap>
    80002f94:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    80002f98:	cd85                	beqz	a1,80002fd0 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f9a:	000b2503          	lw	a0,0(s6)
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	328080e7          	jalr	808(ra) # 800022c6 <bread>
    80002fa6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002fa8:	3ff4f713          	andi	a4,s1,1023
    80002fac:	40ec87bb          	subw	a5,s9,a4
    80002fb0:	413a86bb          	subw	a3,s5,s3
    80002fb4:	8d3e                	mv	s10,a5
    80002fb6:	2781                	sext.w	a5,a5
    80002fb8:	0006861b          	sext.w	a2,a3
    80002fbc:	f8f679e3          	bgeu	a2,a5,80002f4e <readi+0x4c>
    80002fc0:	8d36                	mv	s10,a3
    80002fc2:	b771                	j	80002f4e <readi+0x4c>
      brelse(bp);
    80002fc4:	854a                	mv	a0,s2
    80002fc6:	fffff097          	auipc	ra,0xfffff
    80002fca:	430080e7          	jalr	1072(ra) # 800023f6 <brelse>
      tot = -1;
    80002fce:	59fd                	li	s3,-1
  }
  return tot;
    80002fd0:	0009851b          	sext.w	a0,s3
}
    80002fd4:	70a6                	ld	ra,104(sp)
    80002fd6:	7406                	ld	s0,96(sp)
    80002fd8:	64e6                	ld	s1,88(sp)
    80002fda:	6946                	ld	s2,80(sp)
    80002fdc:	69a6                	ld	s3,72(sp)
    80002fde:	6a06                	ld	s4,64(sp)
    80002fe0:	7ae2                	ld	s5,56(sp)
    80002fe2:	7b42                	ld	s6,48(sp)
    80002fe4:	7ba2                	ld	s7,40(sp)
    80002fe6:	7c02                	ld	s8,32(sp)
    80002fe8:	6ce2                	ld	s9,24(sp)
    80002fea:	6d42                	ld	s10,16(sp)
    80002fec:	6da2                	ld	s11,8(sp)
    80002fee:	6165                	addi	sp,sp,112
    80002ff0:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002ff2:	89d6                	mv	s3,s5
    80002ff4:	bff1                	j	80002fd0 <readi+0xce>
    return 0;
    80002ff6:	4501                	li	a0,0
}
    80002ff8:	8082                	ret

0000000080002ffa <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80002ffa:	457c                	lw	a5,76(a0)
    80002ffc:	10d7e963          	bltu	a5,a3,8000310e <writei+0x114>
{
    80003000:	7159                	addi	sp,sp,-112
    80003002:	f486                	sd	ra,104(sp)
    80003004:	f0a2                	sd	s0,96(sp)
    80003006:	eca6                	sd	s1,88(sp)
    80003008:	e8ca                	sd	s2,80(sp)
    8000300a:	e4ce                	sd	s3,72(sp)
    8000300c:	e0d2                	sd	s4,64(sp)
    8000300e:	fc56                	sd	s5,56(sp)
    80003010:	f85a                	sd	s6,48(sp)
    80003012:	f45e                	sd	s7,40(sp)
    80003014:	f062                	sd	s8,32(sp)
    80003016:	ec66                	sd	s9,24(sp)
    80003018:	e86a                	sd	s10,16(sp)
    8000301a:	e46e                	sd	s11,8(sp)
    8000301c:	1880                	addi	s0,sp,112
    8000301e:	8aaa                	mv	s5,a0
    80003020:	8bae                	mv	s7,a1
    80003022:	8a32                	mv	s4,a2
    80003024:	8936                	mv	s2,a3
    80003026:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80003028:	9f35                	addw	a4,a4,a3
    8000302a:	0ed76463          	bltu	a4,a3,80003112 <writei+0x118>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    8000302e:	040437b7          	lui	a5,0x4043
    80003032:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80003036:	0ee7e063          	bltu	a5,a4,80003116 <writei+0x11c>
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000303a:	0c0b0863          	beqz	s6,8000310a <writei+0x110>
    8000303e:	4981                	li	s3,0
  {
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003040:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80003044:	5c7d                	li	s8,-1
    80003046:	a091                	j	8000308a <writei+0x90>
    80003048:	020d1d93          	slli	s11,s10,0x20
    8000304c:	020ddd93          	srli	s11,s11,0x20
    80003050:	05848513          	addi	a0,s1,88
    80003054:	86ee                	mv	a3,s11
    80003056:	8652                	mv	a2,s4
    80003058:	85de                	mv	a1,s7
    8000305a:	953a                	add	a0,a0,a4
    8000305c:	fffff097          	auipc	ra,0xfffff
    80003060:	8f6080e7          	jalr	-1802(ra) # 80001952 <either_copyin>
    80003064:	07850263          	beq	a0,s8,800030c8 <writei+0xce>
    {
      brelse(bp);
      break;
    }
    log_write(bp);
    80003068:	8526                	mv	a0,s1
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	75e080e7          	jalr	1886(ra) # 800037c8 <log_write>
    brelse(bp);
    80003072:	8526                	mv	a0,s1
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	382080e7          	jalr	898(ra) # 800023f6 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000307c:	013d09bb          	addw	s3,s10,s3
    80003080:	012d093b          	addw	s2,s10,s2
    80003084:	9a6e                	add	s4,s4,s11
    80003086:	0569f663          	bgeu	s3,s6,800030d2 <writei+0xd8>
    uint addr = bmap(ip, off / BSIZE);
    8000308a:	00a9559b          	srliw	a1,s2,0xa
    8000308e:	8556                	mv	a0,s5
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	628080e7          	jalr	1576(ra) # 800026b8 <bmap>
    80003098:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    8000309c:	c99d                	beqz	a1,800030d2 <writei+0xd8>
    bp = bread(ip->dev, addr);
    8000309e:	000aa503          	lw	a0,0(s5)
    800030a2:	fffff097          	auipc	ra,0xfffff
    800030a6:	224080e7          	jalr	548(ra) # 800022c6 <bread>
    800030aa:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800030ac:	3ff97713          	andi	a4,s2,1023
    800030b0:	40ec87bb          	subw	a5,s9,a4
    800030b4:	413b06bb          	subw	a3,s6,s3
    800030b8:	8d3e                	mv	s10,a5
    800030ba:	2781                	sext.w	a5,a5
    800030bc:	0006861b          	sext.w	a2,a3
    800030c0:	f8f674e3          	bgeu	a2,a5,80003048 <writei+0x4e>
    800030c4:	8d36                	mv	s10,a3
    800030c6:	b749                	j	80003048 <writei+0x4e>
      brelse(bp);
    800030c8:	8526                	mv	a0,s1
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	32c080e7          	jalr	812(ra) # 800023f6 <brelse>
  }

  if (off > ip->size)
    800030d2:	04caa783          	lw	a5,76(s5)
    800030d6:	0127f463          	bgeu	a5,s2,800030de <writei+0xe4>
    ip->size = off;
    800030da:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030de:	8556                	mv	a0,s5
    800030e0:	00000097          	auipc	ra,0x0
    800030e4:	9fc080e7          	jalr	-1540(ra) # 80002adc <iupdate>

  return tot;
    800030e8:	0009851b          	sext.w	a0,s3
}
    800030ec:	70a6                	ld	ra,104(sp)
    800030ee:	7406                	ld	s0,96(sp)
    800030f0:	64e6                	ld	s1,88(sp)
    800030f2:	6946                	ld	s2,80(sp)
    800030f4:	69a6                	ld	s3,72(sp)
    800030f6:	6a06                	ld	s4,64(sp)
    800030f8:	7ae2                	ld	s5,56(sp)
    800030fa:	7b42                	ld	s6,48(sp)
    800030fc:	7ba2                	ld	s7,40(sp)
    800030fe:	7c02                	ld	s8,32(sp)
    80003100:	6ce2                	ld	s9,24(sp)
    80003102:	6d42                	ld	s10,16(sp)
    80003104:	6da2                	ld	s11,8(sp)
    80003106:	6165                	addi	sp,sp,112
    80003108:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000310a:	89da                	mv	s3,s6
    8000310c:	bfc9                	j	800030de <writei+0xe4>
    return -1;
    8000310e:	557d                	li	a0,-1
}
    80003110:	8082                	ret
    return -1;
    80003112:	557d                	li	a0,-1
    80003114:	bfe1                	j	800030ec <writei+0xf2>
    return -1;
    80003116:	557d                	li	a0,-1
    80003118:	bfd1                	j	800030ec <writei+0xf2>

000000008000311a <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    8000311a:	1141                	addi	sp,sp,-16
    8000311c:	e406                	sd	ra,8(sp)
    8000311e:	e022                	sd	s0,0(sp)
    80003120:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003122:	4639                	li	a2,14
    80003124:	ffffd097          	auipc	ra,0xffffd
    80003128:	126080e7          	jalr	294(ra) # 8000024a <strncmp>
}
    8000312c:	60a2                	ld	ra,8(sp)
    8000312e:	6402                	ld	s0,0(sp)
    80003130:	0141                	addi	sp,sp,16
    80003132:	8082                	ret

0000000080003134 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003134:	7139                	addi	sp,sp,-64
    80003136:	fc06                	sd	ra,56(sp)
    80003138:	f822                	sd	s0,48(sp)
    8000313a:	f426                	sd	s1,40(sp)
    8000313c:	f04a                	sd	s2,32(sp)
    8000313e:	ec4e                	sd	s3,24(sp)
    80003140:	e852                	sd	s4,16(sp)
    80003142:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80003144:	04451703          	lh	a4,68(a0)
    80003148:	4785                	li	a5,1
    8000314a:	00f71a63          	bne	a4,a5,8000315e <dirlookup+0x2a>
    8000314e:	892a                	mv	s2,a0
    80003150:	89ae                	mv	s3,a1
    80003152:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de))
    80003154:	457c                	lw	a5,76(a0)
    80003156:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003158:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de))
    8000315a:	e79d                	bnez	a5,80003188 <dirlookup+0x54>
    8000315c:	a8a5                	j	800031d4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000315e:	00005517          	auipc	a0,0x5
    80003162:	41250513          	addi	a0,a0,1042 # 80008570 <syscalls+0x1a0>
    80003166:	00003097          	auipc	ra,0x3
    8000316a:	b40080e7          	jalr	-1216(ra) # 80005ca6 <panic>
      panic("dirlookup read");
    8000316e:	00005517          	auipc	a0,0x5
    80003172:	41a50513          	addi	a0,a0,1050 # 80008588 <syscalls+0x1b8>
    80003176:	00003097          	auipc	ra,0x3
    8000317a:	b30080e7          	jalr	-1232(ra) # 80005ca6 <panic>
  for (off = 0; off < dp->size; off += sizeof(de))
    8000317e:	24c1                	addiw	s1,s1,16
    80003180:	04c92783          	lw	a5,76(s2)
    80003184:	04f4f763          	bgeu	s1,a5,800031d2 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003188:	4741                	li	a4,16
    8000318a:	86a6                	mv	a3,s1
    8000318c:	fc040613          	addi	a2,s0,-64
    80003190:	4581                	li	a1,0
    80003192:	854a                	mv	a0,s2
    80003194:	00000097          	auipc	ra,0x0
    80003198:	d6e080e7          	jalr	-658(ra) # 80002f02 <readi>
    8000319c:	47c1                	li	a5,16
    8000319e:	fcf518e3          	bne	a0,a5,8000316e <dirlookup+0x3a>
    if (de.inum == 0)
    800031a2:	fc045783          	lhu	a5,-64(s0)
    800031a6:	dfe1                	beqz	a5,8000317e <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0)
    800031a8:	fc240593          	addi	a1,s0,-62
    800031ac:	854e                	mv	a0,s3
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	f6c080e7          	jalr	-148(ra) # 8000311a <namecmp>
    800031b6:	f561                	bnez	a0,8000317e <dirlookup+0x4a>
      if (poff)
    800031b8:	000a0463          	beqz	s4,800031c0 <dirlookup+0x8c>
        *poff = off;
    800031bc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031c0:	fc045583          	lhu	a1,-64(s0)
    800031c4:	00092503          	lw	a0,0(s2)
    800031c8:	fffff097          	auipc	ra,0xfffff
    800031cc:	6ac080e7          	jalr	1708(ra) # 80002874 <iget>
    800031d0:	a011                	j	800031d4 <dirlookup+0xa0>
  return 0;
    800031d2:	4501                	li	a0,0
}
    800031d4:	70e2                	ld	ra,56(sp)
    800031d6:	7442                	ld	s0,48(sp)
    800031d8:	74a2                	ld	s1,40(sp)
    800031da:	7902                	ld	s2,32(sp)
    800031dc:	69e2                	ld	s3,24(sp)
    800031de:	6a42                	ld	s4,16(sp)
    800031e0:	6121                	addi	sp,sp,64
    800031e2:	8082                	ret

00000000800031e4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800031e4:	711d                	addi	sp,sp,-96
    800031e6:	ec86                	sd	ra,88(sp)
    800031e8:	e8a2                	sd	s0,80(sp)
    800031ea:	e4a6                	sd	s1,72(sp)
    800031ec:	e0ca                	sd	s2,64(sp)
    800031ee:	fc4e                	sd	s3,56(sp)
    800031f0:	f852                	sd	s4,48(sp)
    800031f2:	f456                	sd	s5,40(sp)
    800031f4:	f05a                	sd	s6,32(sp)
    800031f6:	ec5e                	sd	s7,24(sp)
    800031f8:	e862                	sd	s8,16(sp)
    800031fa:	e466                	sd	s9,8(sp)
    800031fc:	1080                	addi	s0,sp,96
    800031fe:	84aa                	mv	s1,a0
    80003200:	8b2e                	mv	s6,a1
    80003202:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003204:	00054703          	lbu	a4,0(a0)
    80003208:	02f00793          	li	a5,47
    8000320c:	02f70263          	beq	a4,a5,80003230 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003210:	ffffe097          	auipc	ra,0xffffe
    80003214:	c42080e7          	jalr	-958(ra) # 80000e52 <myproc>
    80003218:	15053503          	ld	a0,336(a0)
    8000321c:	00000097          	auipc	ra,0x0
    80003220:	94e080e7          	jalr	-1714(ra) # 80002b6a <idup>
    80003224:	8a2a                	mv	s4,a0
  while (*path == '/')
    80003226:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    8000322a:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0)
  {
    ilock(ip);
    if (ip->type != T_DIR)
    8000322c:	4b85                	li	s7,1
    8000322e:	a875                	j	800032ea <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003230:	4585                	li	a1,1
    80003232:	4505                	li	a0,1
    80003234:	fffff097          	auipc	ra,0xfffff
    80003238:	640080e7          	jalr	1600(ra) # 80002874 <iget>
    8000323c:	8a2a                	mv	s4,a0
    8000323e:	b7e5                	j	80003226 <namex+0x42>
    {
      iunlockput(ip);
    80003240:	8552                	mv	a0,s4
    80003242:	00000097          	auipc	ra,0x0
    80003246:	c6e080e7          	jalr	-914(ra) # 80002eb0 <iunlockput>
      return 0;
    8000324a:	4a01                	li	s4,0
  {
    iput(ip);
    return 0;
  }
  return ip;
}
    8000324c:	8552                	mv	a0,s4
    8000324e:	60e6                	ld	ra,88(sp)
    80003250:	6446                	ld	s0,80(sp)
    80003252:	64a6                	ld	s1,72(sp)
    80003254:	6906                	ld	s2,64(sp)
    80003256:	79e2                	ld	s3,56(sp)
    80003258:	7a42                	ld	s4,48(sp)
    8000325a:	7aa2                	ld	s5,40(sp)
    8000325c:	7b02                	ld	s6,32(sp)
    8000325e:	6be2                	ld	s7,24(sp)
    80003260:	6c42                	ld	s8,16(sp)
    80003262:	6ca2                	ld	s9,8(sp)
    80003264:	6125                	addi	sp,sp,96
    80003266:	8082                	ret
      iunlock(ip);
    80003268:	8552                	mv	a0,s4
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	a00080e7          	jalr	-1536(ra) # 80002c6a <iunlock>
      return ip;
    80003272:	bfe9                	j	8000324c <namex+0x68>
      iunlockput(ip);
    80003274:	8552                	mv	a0,s4
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	c3a080e7          	jalr	-966(ra) # 80002eb0 <iunlockput>
      return 0;
    8000327e:	8a4e                	mv	s4,s3
    80003280:	b7f1                	j	8000324c <namex+0x68>
  len = path - s;
    80003282:	40998633          	sub	a2,s3,s1
    80003286:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    8000328a:	099c5863          	bge	s8,s9,8000331a <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000328e:	4639                	li	a2,14
    80003290:	85a6                	mv	a1,s1
    80003292:	8556                	mv	a0,s5
    80003294:	ffffd097          	auipc	ra,0xffffd
    80003298:	f42080e7          	jalr	-190(ra) # 800001d6 <memmove>
    8000329c:	84ce                	mv	s1,s3
  while (*path == '/')
    8000329e:	0004c783          	lbu	a5,0(s1)
    800032a2:	01279763          	bne	a5,s2,800032b0 <namex+0xcc>
    path++;
    800032a6:	0485                	addi	s1,s1,1
  while (*path == '/')
    800032a8:	0004c783          	lbu	a5,0(s1)
    800032ac:	ff278de3          	beq	a5,s2,800032a6 <namex+0xc2>
    ilock(ip);
    800032b0:	8552                	mv	a0,s4
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	8f6080e7          	jalr	-1802(ra) # 80002ba8 <ilock>
    if (ip->type != T_DIR)
    800032ba:	044a1783          	lh	a5,68(s4)
    800032be:	f97791e3          	bne	a5,s7,80003240 <namex+0x5c>
    if (nameiparent && *path == '\0')
    800032c2:	000b0563          	beqz	s6,800032cc <namex+0xe8>
    800032c6:	0004c783          	lbu	a5,0(s1)
    800032ca:	dfd9                	beqz	a5,80003268 <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0)
    800032cc:	4601                	li	a2,0
    800032ce:	85d6                	mv	a1,s5
    800032d0:	8552                	mv	a0,s4
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	e62080e7          	jalr	-414(ra) # 80003134 <dirlookup>
    800032da:	89aa                	mv	s3,a0
    800032dc:	dd41                	beqz	a0,80003274 <namex+0x90>
    iunlockput(ip);
    800032de:	8552                	mv	a0,s4
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	bd0080e7          	jalr	-1072(ra) # 80002eb0 <iunlockput>
    ip = next;
    800032e8:	8a4e                	mv	s4,s3
  while (*path == '/')
    800032ea:	0004c783          	lbu	a5,0(s1)
    800032ee:	01279763          	bne	a5,s2,800032fc <namex+0x118>
    path++;
    800032f2:	0485                	addi	s1,s1,1
  while (*path == '/')
    800032f4:	0004c783          	lbu	a5,0(s1)
    800032f8:	ff278de3          	beq	a5,s2,800032f2 <namex+0x10e>
  if (*path == 0)
    800032fc:	cb9d                	beqz	a5,80003332 <namex+0x14e>
  while (*path != '/' && *path != 0)
    800032fe:	0004c783          	lbu	a5,0(s1)
    80003302:	89a6                	mv	s3,s1
  len = path - s;
    80003304:	4c81                	li	s9,0
    80003306:	4601                	li	a2,0
  while (*path != '/' && *path != 0)
    80003308:	01278963          	beq	a5,s2,8000331a <namex+0x136>
    8000330c:	dbbd                	beqz	a5,80003282 <namex+0x9e>
    path++;
    8000330e:	0985                	addi	s3,s3,1
  while (*path != '/' && *path != 0)
    80003310:	0009c783          	lbu	a5,0(s3)
    80003314:	ff279ce3          	bne	a5,s2,8000330c <namex+0x128>
    80003318:	b7ad                	j	80003282 <namex+0x9e>
    memmove(name, s, len);
    8000331a:	2601                	sext.w	a2,a2
    8000331c:	85a6                	mv	a1,s1
    8000331e:	8556                	mv	a0,s5
    80003320:	ffffd097          	auipc	ra,0xffffd
    80003324:	eb6080e7          	jalr	-330(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003328:	9cd6                	add	s9,s9,s5
    8000332a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000332e:	84ce                	mv	s1,s3
    80003330:	b7bd                	j	8000329e <namex+0xba>
  if (nameiparent)
    80003332:	f00b0de3          	beqz	s6,8000324c <namex+0x68>
    iput(ip);
    80003336:	8552                	mv	a0,s4
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	ad0080e7          	jalr	-1328(ra) # 80002e08 <iput>
    return 0;
    80003340:	4a01                	li	s4,0
    80003342:	b729                	j	8000324c <namex+0x68>

0000000080003344 <dirlink>:
{
    80003344:	7139                	addi	sp,sp,-64
    80003346:	fc06                	sd	ra,56(sp)
    80003348:	f822                	sd	s0,48(sp)
    8000334a:	f426                	sd	s1,40(sp)
    8000334c:	f04a                	sd	s2,32(sp)
    8000334e:	ec4e                	sd	s3,24(sp)
    80003350:	e852                	sd	s4,16(sp)
    80003352:	0080                	addi	s0,sp,64
    80003354:	892a                	mv	s2,a0
    80003356:	8a2e                	mv	s4,a1
    80003358:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0)
    8000335a:	4601                	li	a2,0
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	dd8080e7          	jalr	-552(ra) # 80003134 <dirlookup>
    80003364:	e93d                	bnez	a0,800033da <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de))
    80003366:	04c92483          	lw	s1,76(s2)
    8000336a:	c49d                	beqz	s1,80003398 <dirlink+0x54>
    8000336c:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000336e:	4741                	li	a4,16
    80003370:	86a6                	mv	a3,s1
    80003372:	fc040613          	addi	a2,s0,-64
    80003376:	4581                	li	a1,0
    80003378:	854a                	mv	a0,s2
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	b88080e7          	jalr	-1144(ra) # 80002f02 <readi>
    80003382:	47c1                	li	a5,16
    80003384:	06f51163          	bne	a0,a5,800033e6 <dirlink+0xa2>
    if (de.inum == 0)
    80003388:	fc045783          	lhu	a5,-64(s0)
    8000338c:	c791                	beqz	a5,80003398 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de))
    8000338e:	24c1                	addiw	s1,s1,16
    80003390:	04c92783          	lw	a5,76(s2)
    80003394:	fcf4ede3          	bltu	s1,a5,8000336e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003398:	4639                	li	a2,14
    8000339a:	85d2                	mv	a1,s4
    8000339c:	fc240513          	addi	a0,s0,-62
    800033a0:	ffffd097          	auipc	ra,0xffffd
    800033a4:	ee6080e7          	jalr	-282(ra) # 80000286 <strncpy>
  de.inum = inum;
    800033a8:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ac:	4741                	li	a4,16
    800033ae:	86a6                	mv	a3,s1
    800033b0:	fc040613          	addi	a2,s0,-64
    800033b4:	4581                	li	a1,0
    800033b6:	854a                	mv	a0,s2
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	c42080e7          	jalr	-958(ra) # 80002ffa <writei>
    800033c0:	1541                	addi	a0,a0,-16
    800033c2:	00a03533          	snez	a0,a0
    800033c6:	40a00533          	neg	a0,a0
}
    800033ca:	70e2                	ld	ra,56(sp)
    800033cc:	7442                	ld	s0,48(sp)
    800033ce:	74a2                	ld	s1,40(sp)
    800033d0:	7902                	ld	s2,32(sp)
    800033d2:	69e2                	ld	s3,24(sp)
    800033d4:	6a42                	ld	s4,16(sp)
    800033d6:	6121                	addi	sp,sp,64
    800033d8:	8082                	ret
    iput(ip);
    800033da:	00000097          	auipc	ra,0x0
    800033de:	a2e080e7          	jalr	-1490(ra) # 80002e08 <iput>
    return -1;
    800033e2:	557d                	li	a0,-1
    800033e4:	b7dd                	j	800033ca <dirlink+0x86>
      panic("dirlink read");
    800033e6:	00005517          	auipc	a0,0x5
    800033ea:	1b250513          	addi	a0,a0,434 # 80008598 <syscalls+0x1c8>
    800033ee:	00003097          	auipc	ra,0x3
    800033f2:	8b8080e7          	jalr	-1864(ra) # 80005ca6 <panic>

00000000800033f6 <namei>:

struct inode *
namei(char *path)
{
    800033f6:	1101                	addi	sp,sp,-32
    800033f8:	ec06                	sd	ra,24(sp)
    800033fa:	e822                	sd	s0,16(sp)
    800033fc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033fe:	fe040613          	addi	a2,s0,-32
    80003402:	4581                	li	a1,0
    80003404:	00000097          	auipc	ra,0x0
    80003408:	de0080e7          	jalr	-544(ra) # 800031e4 <namex>
}
    8000340c:	60e2                	ld	ra,24(sp)
    8000340e:	6442                	ld	s0,16(sp)
    80003410:	6105                	addi	sp,sp,32
    80003412:	8082                	ret

0000000080003414 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003414:	1141                	addi	sp,sp,-16
    80003416:	e406                	sd	ra,8(sp)
    80003418:	e022                	sd	s0,0(sp)
    8000341a:	0800                	addi	s0,sp,16
    8000341c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000341e:	4585                	li	a1,1
    80003420:	00000097          	auipc	ra,0x0
    80003424:	dc4080e7          	jalr	-572(ra) # 800031e4 <namex>
}
    80003428:	60a2                	ld	ra,8(sp)
    8000342a:	6402                	ld	s0,0(sp)
    8000342c:	0141                	addi	sp,sp,16
    8000342e:	8082                	ret

0000000080003430 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003430:	1101                	addi	sp,sp,-32
    80003432:	ec06                	sd	ra,24(sp)
    80003434:	e822                	sd	s0,16(sp)
    80003436:	e426                	sd	s1,8(sp)
    80003438:	e04a                	sd	s2,0(sp)
    8000343a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000343c:	00011917          	auipc	s2,0x11
    80003440:	88490913          	addi	s2,s2,-1916 # 80013cc0 <log>
    80003444:	01892583          	lw	a1,24(s2)
    80003448:	02892503          	lw	a0,40(s2)
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	e7a080e7          	jalr	-390(ra) # 800022c6 <bread>
    80003454:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003456:	02c92603          	lw	a2,44(s2)
    8000345a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000345c:	00c05f63          	blez	a2,8000347a <write_head+0x4a>
    80003460:	00011717          	auipc	a4,0x11
    80003464:	89070713          	addi	a4,a4,-1904 # 80013cf0 <log+0x30>
    80003468:	87aa                	mv	a5,a0
    8000346a:	060a                	slli	a2,a2,0x2
    8000346c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000346e:	4314                	lw	a3,0(a4)
    80003470:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003472:	0711                	addi	a4,a4,4
    80003474:	0791                	addi	a5,a5,4
    80003476:	fec79ce3          	bne	a5,a2,8000346e <write_head+0x3e>
  }
  bwrite(buf);
    8000347a:	8526                	mv	a0,s1
    8000347c:	fffff097          	auipc	ra,0xfffff
    80003480:	f3c080e7          	jalr	-196(ra) # 800023b8 <bwrite>
  brelse(buf);
    80003484:	8526                	mv	a0,s1
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	f70080e7          	jalr	-144(ra) # 800023f6 <brelse>
}
    8000348e:	60e2                	ld	ra,24(sp)
    80003490:	6442                	ld	s0,16(sp)
    80003492:	64a2                	ld	s1,8(sp)
    80003494:	6902                	ld	s2,0(sp)
    80003496:	6105                	addi	sp,sp,32
    80003498:	8082                	ret

000000008000349a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000349a:	00011797          	auipc	a5,0x11
    8000349e:	8527a783          	lw	a5,-1966(a5) # 80013cec <log+0x2c>
    800034a2:	0af05d63          	blez	a5,8000355c <install_trans+0xc2>
{
    800034a6:	7139                	addi	sp,sp,-64
    800034a8:	fc06                	sd	ra,56(sp)
    800034aa:	f822                	sd	s0,48(sp)
    800034ac:	f426                	sd	s1,40(sp)
    800034ae:	f04a                	sd	s2,32(sp)
    800034b0:	ec4e                	sd	s3,24(sp)
    800034b2:	e852                	sd	s4,16(sp)
    800034b4:	e456                	sd	s5,8(sp)
    800034b6:	e05a                	sd	s6,0(sp)
    800034b8:	0080                	addi	s0,sp,64
    800034ba:	8b2a                	mv	s6,a0
    800034bc:	00011a97          	auipc	s5,0x11
    800034c0:	834a8a93          	addi	s5,s5,-1996 # 80013cf0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c6:	00010997          	auipc	s3,0x10
    800034ca:	7fa98993          	addi	s3,s3,2042 # 80013cc0 <log>
    800034ce:	a00d                	j	800034f0 <install_trans+0x56>
    brelse(lbuf);
    800034d0:	854a                	mv	a0,s2
    800034d2:	fffff097          	auipc	ra,0xfffff
    800034d6:	f24080e7          	jalr	-220(ra) # 800023f6 <brelse>
    brelse(dbuf);
    800034da:	8526                	mv	a0,s1
    800034dc:	fffff097          	auipc	ra,0xfffff
    800034e0:	f1a080e7          	jalr	-230(ra) # 800023f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e4:	2a05                	addiw	s4,s4,1
    800034e6:	0a91                	addi	s5,s5,4
    800034e8:	02c9a783          	lw	a5,44(s3)
    800034ec:	04fa5e63          	bge	s4,a5,80003548 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034f0:	0189a583          	lw	a1,24(s3)
    800034f4:	014585bb          	addw	a1,a1,s4
    800034f8:	2585                	addiw	a1,a1,1
    800034fa:	0289a503          	lw	a0,40(s3)
    800034fe:	fffff097          	auipc	ra,0xfffff
    80003502:	dc8080e7          	jalr	-568(ra) # 800022c6 <bread>
    80003506:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003508:	000aa583          	lw	a1,0(s5)
    8000350c:	0289a503          	lw	a0,40(s3)
    80003510:	fffff097          	auipc	ra,0xfffff
    80003514:	db6080e7          	jalr	-586(ra) # 800022c6 <bread>
    80003518:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000351a:	40000613          	li	a2,1024
    8000351e:	05890593          	addi	a1,s2,88
    80003522:	05850513          	addi	a0,a0,88
    80003526:	ffffd097          	auipc	ra,0xffffd
    8000352a:	cb0080e7          	jalr	-848(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000352e:	8526                	mv	a0,s1
    80003530:	fffff097          	auipc	ra,0xfffff
    80003534:	e88080e7          	jalr	-376(ra) # 800023b8 <bwrite>
    if(recovering == 0)
    80003538:	f80b1ce3          	bnez	s6,800034d0 <install_trans+0x36>
      bunpin(dbuf);
    8000353c:	8526                	mv	a0,s1
    8000353e:	fffff097          	auipc	ra,0xfffff
    80003542:	f90080e7          	jalr	-112(ra) # 800024ce <bunpin>
    80003546:	b769                	j	800034d0 <install_trans+0x36>
}
    80003548:	70e2                	ld	ra,56(sp)
    8000354a:	7442                	ld	s0,48(sp)
    8000354c:	74a2                	ld	s1,40(sp)
    8000354e:	7902                	ld	s2,32(sp)
    80003550:	69e2                	ld	s3,24(sp)
    80003552:	6a42                	ld	s4,16(sp)
    80003554:	6aa2                	ld	s5,8(sp)
    80003556:	6b02                	ld	s6,0(sp)
    80003558:	6121                	addi	sp,sp,64
    8000355a:	8082                	ret
    8000355c:	8082                	ret

000000008000355e <initlog>:
{
    8000355e:	7179                	addi	sp,sp,-48
    80003560:	f406                	sd	ra,40(sp)
    80003562:	f022                	sd	s0,32(sp)
    80003564:	ec26                	sd	s1,24(sp)
    80003566:	e84a                	sd	s2,16(sp)
    80003568:	e44e                	sd	s3,8(sp)
    8000356a:	1800                	addi	s0,sp,48
    8000356c:	892a                	mv	s2,a0
    8000356e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003570:	00010497          	auipc	s1,0x10
    80003574:	75048493          	addi	s1,s1,1872 # 80013cc0 <log>
    80003578:	00005597          	auipc	a1,0x5
    8000357c:	03058593          	addi	a1,a1,48 # 800085a8 <syscalls+0x1d8>
    80003580:	8526                	mv	a0,s1
    80003582:	00003097          	auipc	ra,0x3
    80003586:	bcc080e7          	jalr	-1076(ra) # 8000614e <initlock>
  log.start = sb->logstart;
    8000358a:	0149a583          	lw	a1,20(s3)
    8000358e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003590:	0109a783          	lw	a5,16(s3)
    80003594:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003596:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000359a:	854a                	mv	a0,s2
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	d2a080e7          	jalr	-726(ra) # 800022c6 <bread>
  log.lh.n = lh->n;
    800035a4:	4d30                	lw	a2,88(a0)
    800035a6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035a8:	00c05f63          	blez	a2,800035c6 <initlog+0x68>
    800035ac:	87aa                	mv	a5,a0
    800035ae:	00010717          	auipc	a4,0x10
    800035b2:	74270713          	addi	a4,a4,1858 # 80013cf0 <log+0x30>
    800035b6:	060a                	slli	a2,a2,0x2
    800035b8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035ba:	4ff4                	lw	a3,92(a5)
    800035bc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035be:	0791                	addi	a5,a5,4
    800035c0:	0711                	addi	a4,a4,4
    800035c2:	fec79ce3          	bne	a5,a2,800035ba <initlog+0x5c>
  brelse(buf);
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	e30080e7          	jalr	-464(ra) # 800023f6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035ce:	4505                	li	a0,1
    800035d0:	00000097          	auipc	ra,0x0
    800035d4:	eca080e7          	jalr	-310(ra) # 8000349a <install_trans>
  log.lh.n = 0;
    800035d8:	00010797          	auipc	a5,0x10
    800035dc:	7007aa23          	sw	zero,1812(a5) # 80013cec <log+0x2c>
  write_head(); // clear the log
    800035e0:	00000097          	auipc	ra,0x0
    800035e4:	e50080e7          	jalr	-432(ra) # 80003430 <write_head>
}
    800035e8:	70a2                	ld	ra,40(sp)
    800035ea:	7402                	ld	s0,32(sp)
    800035ec:	64e2                	ld	s1,24(sp)
    800035ee:	6942                	ld	s2,16(sp)
    800035f0:	69a2                	ld	s3,8(sp)
    800035f2:	6145                	addi	sp,sp,48
    800035f4:	8082                	ret

00000000800035f6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035f6:	1101                	addi	sp,sp,-32
    800035f8:	ec06                	sd	ra,24(sp)
    800035fa:	e822                	sd	s0,16(sp)
    800035fc:	e426                	sd	s1,8(sp)
    800035fe:	e04a                	sd	s2,0(sp)
    80003600:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003602:	00010517          	auipc	a0,0x10
    80003606:	6be50513          	addi	a0,a0,1726 # 80013cc0 <log>
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	bd4080e7          	jalr	-1068(ra) # 800061de <acquire>
  while(1){
    if(log.committing){
    80003612:	00010497          	auipc	s1,0x10
    80003616:	6ae48493          	addi	s1,s1,1710 # 80013cc0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000361a:	4979                	li	s2,30
    8000361c:	a039                	j	8000362a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000361e:	85a6                	mv	a1,s1
    80003620:	8526                	mv	a0,s1
    80003622:	ffffe097          	auipc	ra,0xffffe
    80003626:	ed8080e7          	jalr	-296(ra) # 800014fa <sleep>
    if(log.committing){
    8000362a:	50dc                	lw	a5,36(s1)
    8000362c:	fbed                	bnez	a5,8000361e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000362e:	5098                	lw	a4,32(s1)
    80003630:	2705                	addiw	a4,a4,1
    80003632:	0027179b          	slliw	a5,a4,0x2
    80003636:	9fb9                	addw	a5,a5,a4
    80003638:	0017979b          	slliw	a5,a5,0x1
    8000363c:	54d4                	lw	a3,44(s1)
    8000363e:	9fb5                	addw	a5,a5,a3
    80003640:	00f95963          	bge	s2,a5,80003652 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003644:	85a6                	mv	a1,s1
    80003646:	8526                	mv	a0,s1
    80003648:	ffffe097          	auipc	ra,0xffffe
    8000364c:	eb2080e7          	jalr	-334(ra) # 800014fa <sleep>
    80003650:	bfe9                	j	8000362a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003652:	00010517          	auipc	a0,0x10
    80003656:	66e50513          	addi	a0,a0,1646 # 80013cc0 <log>
    8000365a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	c36080e7          	jalr	-970(ra) # 80006292 <release>
      break;
    }
  }
}
    80003664:	60e2                	ld	ra,24(sp)
    80003666:	6442                	ld	s0,16(sp)
    80003668:	64a2                	ld	s1,8(sp)
    8000366a:	6902                	ld	s2,0(sp)
    8000366c:	6105                	addi	sp,sp,32
    8000366e:	8082                	ret

0000000080003670 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003670:	7139                	addi	sp,sp,-64
    80003672:	fc06                	sd	ra,56(sp)
    80003674:	f822                	sd	s0,48(sp)
    80003676:	f426                	sd	s1,40(sp)
    80003678:	f04a                	sd	s2,32(sp)
    8000367a:	ec4e                	sd	s3,24(sp)
    8000367c:	e852                	sd	s4,16(sp)
    8000367e:	e456                	sd	s5,8(sp)
    80003680:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003682:	00010497          	auipc	s1,0x10
    80003686:	63e48493          	addi	s1,s1,1598 # 80013cc0 <log>
    8000368a:	8526                	mv	a0,s1
    8000368c:	00003097          	auipc	ra,0x3
    80003690:	b52080e7          	jalr	-1198(ra) # 800061de <acquire>
  log.outstanding -= 1;
    80003694:	509c                	lw	a5,32(s1)
    80003696:	37fd                	addiw	a5,a5,-1
    80003698:	0007891b          	sext.w	s2,a5
    8000369c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000369e:	50dc                	lw	a5,36(s1)
    800036a0:	e7b9                	bnez	a5,800036ee <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036a2:	04091e63          	bnez	s2,800036fe <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036a6:	00010497          	auipc	s1,0x10
    800036aa:	61a48493          	addi	s1,s1,1562 # 80013cc0 <log>
    800036ae:	4785                	li	a5,1
    800036b0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	bde080e7          	jalr	-1058(ra) # 80006292 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036bc:	54dc                	lw	a5,44(s1)
    800036be:	06f04763          	bgtz	a5,8000372c <end_op+0xbc>
    acquire(&log.lock);
    800036c2:	00010497          	auipc	s1,0x10
    800036c6:	5fe48493          	addi	s1,s1,1534 # 80013cc0 <log>
    800036ca:	8526                	mv	a0,s1
    800036cc:	00003097          	auipc	ra,0x3
    800036d0:	b12080e7          	jalr	-1262(ra) # 800061de <acquire>
    log.committing = 0;
    800036d4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036d8:	8526                	mv	a0,s1
    800036da:	ffffe097          	auipc	ra,0xffffe
    800036de:	e84080e7          	jalr	-380(ra) # 8000155e <wakeup>
    release(&log.lock);
    800036e2:	8526                	mv	a0,s1
    800036e4:	00003097          	auipc	ra,0x3
    800036e8:	bae080e7          	jalr	-1106(ra) # 80006292 <release>
}
    800036ec:	a03d                	j	8000371a <end_op+0xaa>
    panic("log.committing");
    800036ee:	00005517          	auipc	a0,0x5
    800036f2:	ec250513          	addi	a0,a0,-318 # 800085b0 <syscalls+0x1e0>
    800036f6:	00002097          	auipc	ra,0x2
    800036fa:	5b0080e7          	jalr	1456(ra) # 80005ca6 <panic>
    wakeup(&log);
    800036fe:	00010497          	auipc	s1,0x10
    80003702:	5c248493          	addi	s1,s1,1474 # 80013cc0 <log>
    80003706:	8526                	mv	a0,s1
    80003708:	ffffe097          	auipc	ra,0xffffe
    8000370c:	e56080e7          	jalr	-426(ra) # 8000155e <wakeup>
  release(&log.lock);
    80003710:	8526                	mv	a0,s1
    80003712:	00003097          	auipc	ra,0x3
    80003716:	b80080e7          	jalr	-1152(ra) # 80006292 <release>
}
    8000371a:	70e2                	ld	ra,56(sp)
    8000371c:	7442                	ld	s0,48(sp)
    8000371e:	74a2                	ld	s1,40(sp)
    80003720:	7902                	ld	s2,32(sp)
    80003722:	69e2                	ld	s3,24(sp)
    80003724:	6a42                	ld	s4,16(sp)
    80003726:	6aa2                	ld	s5,8(sp)
    80003728:	6121                	addi	sp,sp,64
    8000372a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000372c:	00010a97          	auipc	s5,0x10
    80003730:	5c4a8a93          	addi	s5,s5,1476 # 80013cf0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003734:	00010a17          	auipc	s4,0x10
    80003738:	58ca0a13          	addi	s4,s4,1420 # 80013cc0 <log>
    8000373c:	018a2583          	lw	a1,24(s4)
    80003740:	012585bb          	addw	a1,a1,s2
    80003744:	2585                	addiw	a1,a1,1
    80003746:	028a2503          	lw	a0,40(s4)
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	b7c080e7          	jalr	-1156(ra) # 800022c6 <bread>
    80003752:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003754:	000aa583          	lw	a1,0(s5)
    80003758:	028a2503          	lw	a0,40(s4)
    8000375c:	fffff097          	auipc	ra,0xfffff
    80003760:	b6a080e7          	jalr	-1174(ra) # 800022c6 <bread>
    80003764:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003766:	40000613          	li	a2,1024
    8000376a:	05850593          	addi	a1,a0,88
    8000376e:	05848513          	addi	a0,s1,88
    80003772:	ffffd097          	auipc	ra,0xffffd
    80003776:	a64080e7          	jalr	-1436(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000377a:	8526                	mv	a0,s1
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	c3c080e7          	jalr	-964(ra) # 800023b8 <bwrite>
    brelse(from);
    80003784:	854e                	mv	a0,s3
    80003786:	fffff097          	auipc	ra,0xfffff
    8000378a:	c70080e7          	jalr	-912(ra) # 800023f6 <brelse>
    brelse(to);
    8000378e:	8526                	mv	a0,s1
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	c66080e7          	jalr	-922(ra) # 800023f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003798:	2905                	addiw	s2,s2,1
    8000379a:	0a91                	addi	s5,s5,4
    8000379c:	02ca2783          	lw	a5,44(s4)
    800037a0:	f8f94ee3          	blt	s2,a5,8000373c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037a4:	00000097          	auipc	ra,0x0
    800037a8:	c8c080e7          	jalr	-884(ra) # 80003430 <write_head>
    install_trans(0); // Now install writes to home locations
    800037ac:	4501                	li	a0,0
    800037ae:	00000097          	auipc	ra,0x0
    800037b2:	cec080e7          	jalr	-788(ra) # 8000349a <install_trans>
    log.lh.n = 0;
    800037b6:	00010797          	auipc	a5,0x10
    800037ba:	5207ab23          	sw	zero,1334(a5) # 80013cec <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037be:	00000097          	auipc	ra,0x0
    800037c2:	c72080e7          	jalr	-910(ra) # 80003430 <write_head>
    800037c6:	bdf5                	j	800036c2 <end_op+0x52>

00000000800037c8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037c8:	1101                	addi	sp,sp,-32
    800037ca:	ec06                	sd	ra,24(sp)
    800037cc:	e822                	sd	s0,16(sp)
    800037ce:	e426                	sd	s1,8(sp)
    800037d0:	e04a                	sd	s2,0(sp)
    800037d2:	1000                	addi	s0,sp,32
    800037d4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037d6:	00010917          	auipc	s2,0x10
    800037da:	4ea90913          	addi	s2,s2,1258 # 80013cc0 <log>
    800037de:	854a                	mv	a0,s2
    800037e0:	00003097          	auipc	ra,0x3
    800037e4:	9fe080e7          	jalr	-1538(ra) # 800061de <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037e8:	02c92603          	lw	a2,44(s2)
    800037ec:	47f5                	li	a5,29
    800037ee:	06c7c563          	blt	a5,a2,80003858 <log_write+0x90>
    800037f2:	00010797          	auipc	a5,0x10
    800037f6:	4ea7a783          	lw	a5,1258(a5) # 80013cdc <log+0x1c>
    800037fa:	37fd                	addiw	a5,a5,-1
    800037fc:	04f65e63          	bge	a2,a5,80003858 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003800:	00010797          	auipc	a5,0x10
    80003804:	4e07a783          	lw	a5,1248(a5) # 80013ce0 <log+0x20>
    80003808:	06f05063          	blez	a5,80003868 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000380c:	4781                	li	a5,0
    8000380e:	06c05563          	blez	a2,80003878 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003812:	44cc                	lw	a1,12(s1)
    80003814:	00010717          	auipc	a4,0x10
    80003818:	4dc70713          	addi	a4,a4,1244 # 80013cf0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000381c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000381e:	4314                	lw	a3,0(a4)
    80003820:	04b68c63          	beq	a3,a1,80003878 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003824:	2785                	addiw	a5,a5,1
    80003826:	0711                	addi	a4,a4,4
    80003828:	fef61be3          	bne	a2,a5,8000381e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000382c:	0621                	addi	a2,a2,8
    8000382e:	060a                	slli	a2,a2,0x2
    80003830:	00010797          	auipc	a5,0x10
    80003834:	49078793          	addi	a5,a5,1168 # 80013cc0 <log>
    80003838:	97b2                	add	a5,a5,a2
    8000383a:	44d8                	lw	a4,12(s1)
    8000383c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000383e:	8526                	mv	a0,s1
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	c52080e7          	jalr	-942(ra) # 80002492 <bpin>
    log.lh.n++;
    80003848:	00010717          	auipc	a4,0x10
    8000384c:	47870713          	addi	a4,a4,1144 # 80013cc0 <log>
    80003850:	575c                	lw	a5,44(a4)
    80003852:	2785                	addiw	a5,a5,1
    80003854:	d75c                	sw	a5,44(a4)
    80003856:	a82d                	j	80003890 <log_write+0xc8>
    panic("too big a transaction");
    80003858:	00005517          	auipc	a0,0x5
    8000385c:	d6850513          	addi	a0,a0,-664 # 800085c0 <syscalls+0x1f0>
    80003860:	00002097          	auipc	ra,0x2
    80003864:	446080e7          	jalr	1094(ra) # 80005ca6 <panic>
    panic("log_write outside of trans");
    80003868:	00005517          	auipc	a0,0x5
    8000386c:	d7050513          	addi	a0,a0,-656 # 800085d8 <syscalls+0x208>
    80003870:	00002097          	auipc	ra,0x2
    80003874:	436080e7          	jalr	1078(ra) # 80005ca6 <panic>
  log.lh.block[i] = b->blockno;
    80003878:	00878693          	addi	a3,a5,8
    8000387c:	068a                	slli	a3,a3,0x2
    8000387e:	00010717          	auipc	a4,0x10
    80003882:	44270713          	addi	a4,a4,1090 # 80013cc0 <log>
    80003886:	9736                	add	a4,a4,a3
    80003888:	44d4                	lw	a3,12(s1)
    8000388a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000388c:	faf609e3          	beq	a2,a5,8000383e <log_write+0x76>
  }
  release(&log.lock);
    80003890:	00010517          	auipc	a0,0x10
    80003894:	43050513          	addi	a0,a0,1072 # 80013cc0 <log>
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	9fa080e7          	jalr	-1542(ra) # 80006292 <release>
}
    800038a0:	60e2                	ld	ra,24(sp)
    800038a2:	6442                	ld	s0,16(sp)
    800038a4:	64a2                	ld	s1,8(sp)
    800038a6:	6902                	ld	s2,0(sp)
    800038a8:	6105                	addi	sp,sp,32
    800038aa:	8082                	ret

00000000800038ac <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038ac:	1101                	addi	sp,sp,-32
    800038ae:	ec06                	sd	ra,24(sp)
    800038b0:	e822                	sd	s0,16(sp)
    800038b2:	e426                	sd	s1,8(sp)
    800038b4:	e04a                	sd	s2,0(sp)
    800038b6:	1000                	addi	s0,sp,32
    800038b8:	84aa                	mv	s1,a0
    800038ba:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038bc:	00005597          	auipc	a1,0x5
    800038c0:	d3c58593          	addi	a1,a1,-708 # 800085f8 <syscalls+0x228>
    800038c4:	0521                	addi	a0,a0,8
    800038c6:	00003097          	auipc	ra,0x3
    800038ca:	888080e7          	jalr	-1912(ra) # 8000614e <initlock>
  lk->name = name;
    800038ce:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038d2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d6:	0204a423          	sw	zero,40(s1)
}
    800038da:	60e2                	ld	ra,24(sp)
    800038dc:	6442                	ld	s0,16(sp)
    800038de:	64a2                	ld	s1,8(sp)
    800038e0:	6902                	ld	s2,0(sp)
    800038e2:	6105                	addi	sp,sp,32
    800038e4:	8082                	ret

00000000800038e6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038e6:	1101                	addi	sp,sp,-32
    800038e8:	ec06                	sd	ra,24(sp)
    800038ea:	e822                	sd	s0,16(sp)
    800038ec:	e426                	sd	s1,8(sp)
    800038ee:	e04a                	sd	s2,0(sp)
    800038f0:	1000                	addi	s0,sp,32
    800038f2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f4:	00850913          	addi	s2,a0,8
    800038f8:	854a                	mv	a0,s2
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	8e4080e7          	jalr	-1820(ra) # 800061de <acquire>
  while (lk->locked) {
    80003902:	409c                	lw	a5,0(s1)
    80003904:	cb89                	beqz	a5,80003916 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003906:	85ca                	mv	a1,s2
    80003908:	8526                	mv	a0,s1
    8000390a:	ffffe097          	auipc	ra,0xffffe
    8000390e:	bf0080e7          	jalr	-1040(ra) # 800014fa <sleep>
  while (lk->locked) {
    80003912:	409c                	lw	a5,0(s1)
    80003914:	fbed                	bnez	a5,80003906 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003916:	4785                	li	a5,1
    80003918:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000391a:	ffffd097          	auipc	ra,0xffffd
    8000391e:	538080e7          	jalr	1336(ra) # 80000e52 <myproc>
    80003922:	591c                	lw	a5,48(a0)
    80003924:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003926:	854a                	mv	a0,s2
    80003928:	00003097          	auipc	ra,0x3
    8000392c:	96a080e7          	jalr	-1686(ra) # 80006292 <release>
}
    80003930:	60e2                	ld	ra,24(sp)
    80003932:	6442                	ld	s0,16(sp)
    80003934:	64a2                	ld	s1,8(sp)
    80003936:	6902                	ld	s2,0(sp)
    80003938:	6105                	addi	sp,sp,32
    8000393a:	8082                	ret

000000008000393c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000393c:	1101                	addi	sp,sp,-32
    8000393e:	ec06                	sd	ra,24(sp)
    80003940:	e822                	sd	s0,16(sp)
    80003942:	e426                	sd	s1,8(sp)
    80003944:	e04a                	sd	s2,0(sp)
    80003946:	1000                	addi	s0,sp,32
    80003948:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000394a:	00850913          	addi	s2,a0,8
    8000394e:	854a                	mv	a0,s2
    80003950:	00003097          	auipc	ra,0x3
    80003954:	88e080e7          	jalr	-1906(ra) # 800061de <acquire>
  lk->locked = 0;
    80003958:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000395c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003960:	8526                	mv	a0,s1
    80003962:	ffffe097          	auipc	ra,0xffffe
    80003966:	bfc080e7          	jalr	-1028(ra) # 8000155e <wakeup>
  release(&lk->lk);
    8000396a:	854a                	mv	a0,s2
    8000396c:	00003097          	auipc	ra,0x3
    80003970:	926080e7          	jalr	-1754(ra) # 80006292 <release>
}
    80003974:	60e2                	ld	ra,24(sp)
    80003976:	6442                	ld	s0,16(sp)
    80003978:	64a2                	ld	s1,8(sp)
    8000397a:	6902                	ld	s2,0(sp)
    8000397c:	6105                	addi	sp,sp,32
    8000397e:	8082                	ret

0000000080003980 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003980:	7179                	addi	sp,sp,-48
    80003982:	f406                	sd	ra,40(sp)
    80003984:	f022                	sd	s0,32(sp)
    80003986:	ec26                	sd	s1,24(sp)
    80003988:	e84a                	sd	s2,16(sp)
    8000398a:	e44e                	sd	s3,8(sp)
    8000398c:	1800                	addi	s0,sp,48
    8000398e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003990:	00850913          	addi	s2,a0,8
    80003994:	854a                	mv	a0,s2
    80003996:	00003097          	auipc	ra,0x3
    8000399a:	848080e7          	jalr	-1976(ra) # 800061de <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399e:	409c                	lw	a5,0(s1)
    800039a0:	ef99                	bnez	a5,800039be <holdingsleep+0x3e>
    800039a2:	4481                	li	s1,0
  release(&lk->lk);
    800039a4:	854a                	mv	a0,s2
    800039a6:	00003097          	auipc	ra,0x3
    800039aa:	8ec080e7          	jalr	-1812(ra) # 80006292 <release>
  return r;
}
    800039ae:	8526                	mv	a0,s1
    800039b0:	70a2                	ld	ra,40(sp)
    800039b2:	7402                	ld	s0,32(sp)
    800039b4:	64e2                	ld	s1,24(sp)
    800039b6:	6942                	ld	s2,16(sp)
    800039b8:	69a2                	ld	s3,8(sp)
    800039ba:	6145                	addi	sp,sp,48
    800039bc:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039be:	0284a983          	lw	s3,40(s1)
    800039c2:	ffffd097          	auipc	ra,0xffffd
    800039c6:	490080e7          	jalr	1168(ra) # 80000e52 <myproc>
    800039ca:	5904                	lw	s1,48(a0)
    800039cc:	413484b3          	sub	s1,s1,s3
    800039d0:	0014b493          	seqz	s1,s1
    800039d4:	bfc1                	j	800039a4 <holdingsleep+0x24>

00000000800039d6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039d6:	1141                	addi	sp,sp,-16
    800039d8:	e406                	sd	ra,8(sp)
    800039da:	e022                	sd	s0,0(sp)
    800039dc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039de:	00005597          	auipc	a1,0x5
    800039e2:	c2a58593          	addi	a1,a1,-982 # 80008608 <syscalls+0x238>
    800039e6:	00010517          	auipc	a0,0x10
    800039ea:	42250513          	addi	a0,a0,1058 # 80013e08 <ftable>
    800039ee:	00002097          	auipc	ra,0x2
    800039f2:	760080e7          	jalr	1888(ra) # 8000614e <initlock>
}
    800039f6:	60a2                	ld	ra,8(sp)
    800039f8:	6402                	ld	s0,0(sp)
    800039fa:	0141                	addi	sp,sp,16
    800039fc:	8082                	ret

00000000800039fe <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039fe:	1101                	addi	sp,sp,-32
    80003a00:	ec06                	sd	ra,24(sp)
    80003a02:	e822                	sd	s0,16(sp)
    80003a04:	e426                	sd	s1,8(sp)
    80003a06:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a08:	00010517          	auipc	a0,0x10
    80003a0c:	40050513          	addi	a0,a0,1024 # 80013e08 <ftable>
    80003a10:	00002097          	auipc	ra,0x2
    80003a14:	7ce080e7          	jalr	1998(ra) # 800061de <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a18:	00010497          	auipc	s1,0x10
    80003a1c:	40848493          	addi	s1,s1,1032 # 80013e20 <ftable+0x18>
    80003a20:	00011717          	auipc	a4,0x11
    80003a24:	3a070713          	addi	a4,a4,928 # 80014dc0 <disk>
    if(f->ref == 0){
    80003a28:	40dc                	lw	a5,4(s1)
    80003a2a:	cf99                	beqz	a5,80003a48 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a2c:	02848493          	addi	s1,s1,40
    80003a30:	fee49ce3          	bne	s1,a4,80003a28 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a34:	00010517          	auipc	a0,0x10
    80003a38:	3d450513          	addi	a0,a0,980 # 80013e08 <ftable>
    80003a3c:	00003097          	auipc	ra,0x3
    80003a40:	856080e7          	jalr	-1962(ra) # 80006292 <release>
  return 0;
    80003a44:	4481                	li	s1,0
    80003a46:	a819                	j	80003a5c <filealloc+0x5e>
      f->ref = 1;
    80003a48:	4785                	li	a5,1
    80003a4a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a4c:	00010517          	auipc	a0,0x10
    80003a50:	3bc50513          	addi	a0,a0,956 # 80013e08 <ftable>
    80003a54:	00003097          	auipc	ra,0x3
    80003a58:	83e080e7          	jalr	-1986(ra) # 80006292 <release>
}
    80003a5c:	8526                	mv	a0,s1
    80003a5e:	60e2                	ld	ra,24(sp)
    80003a60:	6442                	ld	s0,16(sp)
    80003a62:	64a2                	ld	s1,8(sp)
    80003a64:	6105                	addi	sp,sp,32
    80003a66:	8082                	ret

0000000080003a68 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a68:	1101                	addi	sp,sp,-32
    80003a6a:	ec06                	sd	ra,24(sp)
    80003a6c:	e822                	sd	s0,16(sp)
    80003a6e:	e426                	sd	s1,8(sp)
    80003a70:	1000                	addi	s0,sp,32
    80003a72:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a74:	00010517          	auipc	a0,0x10
    80003a78:	39450513          	addi	a0,a0,916 # 80013e08 <ftable>
    80003a7c:	00002097          	auipc	ra,0x2
    80003a80:	762080e7          	jalr	1890(ra) # 800061de <acquire>
  if(f->ref < 1)
    80003a84:	40dc                	lw	a5,4(s1)
    80003a86:	02f05263          	blez	a5,80003aaa <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a8a:	2785                	addiw	a5,a5,1
    80003a8c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a8e:	00010517          	auipc	a0,0x10
    80003a92:	37a50513          	addi	a0,a0,890 # 80013e08 <ftable>
    80003a96:	00002097          	auipc	ra,0x2
    80003a9a:	7fc080e7          	jalr	2044(ra) # 80006292 <release>
  return f;
}
    80003a9e:	8526                	mv	a0,s1
    80003aa0:	60e2                	ld	ra,24(sp)
    80003aa2:	6442                	ld	s0,16(sp)
    80003aa4:	64a2                	ld	s1,8(sp)
    80003aa6:	6105                	addi	sp,sp,32
    80003aa8:	8082                	ret
    panic("filedup");
    80003aaa:	00005517          	auipc	a0,0x5
    80003aae:	b6650513          	addi	a0,a0,-1178 # 80008610 <syscalls+0x240>
    80003ab2:	00002097          	auipc	ra,0x2
    80003ab6:	1f4080e7          	jalr	500(ra) # 80005ca6 <panic>

0000000080003aba <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003aba:	7139                	addi	sp,sp,-64
    80003abc:	fc06                	sd	ra,56(sp)
    80003abe:	f822                	sd	s0,48(sp)
    80003ac0:	f426                	sd	s1,40(sp)
    80003ac2:	f04a                	sd	s2,32(sp)
    80003ac4:	ec4e                	sd	s3,24(sp)
    80003ac6:	e852                	sd	s4,16(sp)
    80003ac8:	e456                	sd	s5,8(sp)
    80003aca:	0080                	addi	s0,sp,64
    80003acc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ace:	00010517          	auipc	a0,0x10
    80003ad2:	33a50513          	addi	a0,a0,826 # 80013e08 <ftable>
    80003ad6:	00002097          	auipc	ra,0x2
    80003ada:	708080e7          	jalr	1800(ra) # 800061de <acquire>
  if(f->ref < 1)
    80003ade:	40dc                	lw	a5,4(s1)
    80003ae0:	06f05163          	blez	a5,80003b42 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ae4:	37fd                	addiw	a5,a5,-1
    80003ae6:	0007871b          	sext.w	a4,a5
    80003aea:	c0dc                	sw	a5,4(s1)
    80003aec:	06e04363          	bgtz	a4,80003b52 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003af0:	0004a903          	lw	s2,0(s1)
    80003af4:	0094ca83          	lbu	s5,9(s1)
    80003af8:	0104ba03          	ld	s4,16(s1)
    80003afc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b00:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b04:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b08:	00010517          	auipc	a0,0x10
    80003b0c:	30050513          	addi	a0,a0,768 # 80013e08 <ftable>
    80003b10:	00002097          	auipc	ra,0x2
    80003b14:	782080e7          	jalr	1922(ra) # 80006292 <release>

  if(ff.type == FD_PIPE){
    80003b18:	4785                	li	a5,1
    80003b1a:	04f90d63          	beq	s2,a5,80003b74 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b1e:	3979                	addiw	s2,s2,-2
    80003b20:	4785                	li	a5,1
    80003b22:	0527e063          	bltu	a5,s2,80003b62 <fileclose+0xa8>
    begin_op();
    80003b26:	00000097          	auipc	ra,0x0
    80003b2a:	ad0080e7          	jalr	-1328(ra) # 800035f6 <begin_op>
    iput(ff.ip);
    80003b2e:	854e                	mv	a0,s3
    80003b30:	fffff097          	auipc	ra,0xfffff
    80003b34:	2d8080e7          	jalr	728(ra) # 80002e08 <iput>
    end_op();
    80003b38:	00000097          	auipc	ra,0x0
    80003b3c:	b38080e7          	jalr	-1224(ra) # 80003670 <end_op>
    80003b40:	a00d                	j	80003b62 <fileclose+0xa8>
    panic("fileclose");
    80003b42:	00005517          	auipc	a0,0x5
    80003b46:	ad650513          	addi	a0,a0,-1322 # 80008618 <syscalls+0x248>
    80003b4a:	00002097          	auipc	ra,0x2
    80003b4e:	15c080e7          	jalr	348(ra) # 80005ca6 <panic>
    release(&ftable.lock);
    80003b52:	00010517          	auipc	a0,0x10
    80003b56:	2b650513          	addi	a0,a0,694 # 80013e08 <ftable>
    80003b5a:	00002097          	auipc	ra,0x2
    80003b5e:	738080e7          	jalr	1848(ra) # 80006292 <release>
  }
}
    80003b62:	70e2                	ld	ra,56(sp)
    80003b64:	7442                	ld	s0,48(sp)
    80003b66:	74a2                	ld	s1,40(sp)
    80003b68:	7902                	ld	s2,32(sp)
    80003b6a:	69e2                	ld	s3,24(sp)
    80003b6c:	6a42                	ld	s4,16(sp)
    80003b6e:	6aa2                	ld	s5,8(sp)
    80003b70:	6121                	addi	sp,sp,64
    80003b72:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b74:	85d6                	mv	a1,s5
    80003b76:	8552                	mv	a0,s4
    80003b78:	00000097          	auipc	ra,0x0
    80003b7c:	348080e7          	jalr	840(ra) # 80003ec0 <pipeclose>
    80003b80:	b7cd                	j	80003b62 <fileclose+0xa8>

0000000080003b82 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b82:	715d                	addi	sp,sp,-80
    80003b84:	e486                	sd	ra,72(sp)
    80003b86:	e0a2                	sd	s0,64(sp)
    80003b88:	fc26                	sd	s1,56(sp)
    80003b8a:	f84a                	sd	s2,48(sp)
    80003b8c:	f44e                	sd	s3,40(sp)
    80003b8e:	0880                	addi	s0,sp,80
    80003b90:	84aa                	mv	s1,a0
    80003b92:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b94:	ffffd097          	auipc	ra,0xffffd
    80003b98:	2be080e7          	jalr	702(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b9c:	409c                	lw	a5,0(s1)
    80003b9e:	37f9                	addiw	a5,a5,-2
    80003ba0:	4705                	li	a4,1
    80003ba2:	04f76763          	bltu	a4,a5,80003bf0 <filestat+0x6e>
    80003ba6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ba8:	6c88                	ld	a0,24(s1)
    80003baa:	fffff097          	auipc	ra,0xfffff
    80003bae:	ffe080e7          	jalr	-2(ra) # 80002ba8 <ilock>
    stati(f->ip, &st);
    80003bb2:	fb840593          	addi	a1,s0,-72
    80003bb6:	6c88                	ld	a0,24(s1)
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	320080e7          	jalr	800(ra) # 80002ed8 <stati>
    iunlock(f->ip);
    80003bc0:	6c88                	ld	a0,24(s1)
    80003bc2:	fffff097          	auipc	ra,0xfffff
    80003bc6:	0a8080e7          	jalr	168(ra) # 80002c6a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bca:	46e1                	li	a3,24
    80003bcc:	fb840613          	addi	a2,s0,-72
    80003bd0:	85ce                	mv	a1,s3
    80003bd2:	05093503          	ld	a0,80(s2)
    80003bd6:	ffffd097          	auipc	ra,0xffffd
    80003bda:	f3c080e7          	jalr	-196(ra) # 80000b12 <copyout>
    80003bde:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003be2:	60a6                	ld	ra,72(sp)
    80003be4:	6406                	ld	s0,64(sp)
    80003be6:	74e2                	ld	s1,56(sp)
    80003be8:	7942                	ld	s2,48(sp)
    80003bea:	79a2                	ld	s3,40(sp)
    80003bec:	6161                	addi	sp,sp,80
    80003bee:	8082                	ret
  return -1;
    80003bf0:	557d                	li	a0,-1
    80003bf2:	bfc5                	j	80003be2 <filestat+0x60>

0000000080003bf4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bf4:	7179                	addi	sp,sp,-48
    80003bf6:	f406                	sd	ra,40(sp)
    80003bf8:	f022                	sd	s0,32(sp)
    80003bfa:	ec26                	sd	s1,24(sp)
    80003bfc:	e84a                	sd	s2,16(sp)
    80003bfe:	e44e                	sd	s3,8(sp)
    80003c00:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c02:	00854783          	lbu	a5,8(a0)
    80003c06:	c3d5                	beqz	a5,80003caa <fileread+0xb6>
    80003c08:	84aa                	mv	s1,a0
    80003c0a:	89ae                	mv	s3,a1
    80003c0c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c0e:	411c                	lw	a5,0(a0)
    80003c10:	4705                	li	a4,1
    80003c12:	04e78963          	beq	a5,a4,80003c64 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c16:	470d                	li	a4,3
    80003c18:	04e78d63          	beq	a5,a4,80003c72 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c1c:	4709                	li	a4,2
    80003c1e:	06e79e63          	bne	a5,a4,80003c9a <fileread+0xa6>
    ilock(f->ip);
    80003c22:	6d08                	ld	a0,24(a0)
    80003c24:	fffff097          	auipc	ra,0xfffff
    80003c28:	f84080e7          	jalr	-124(ra) # 80002ba8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c2c:	874a                	mv	a4,s2
    80003c2e:	5094                	lw	a3,32(s1)
    80003c30:	864e                	mv	a2,s3
    80003c32:	4585                	li	a1,1
    80003c34:	6c88                	ld	a0,24(s1)
    80003c36:	fffff097          	auipc	ra,0xfffff
    80003c3a:	2cc080e7          	jalr	716(ra) # 80002f02 <readi>
    80003c3e:	892a                	mv	s2,a0
    80003c40:	00a05563          	blez	a0,80003c4a <fileread+0x56>
      f->off += r;
    80003c44:	509c                	lw	a5,32(s1)
    80003c46:	9fa9                	addw	a5,a5,a0
    80003c48:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c4a:	6c88                	ld	a0,24(s1)
    80003c4c:	fffff097          	auipc	ra,0xfffff
    80003c50:	01e080e7          	jalr	30(ra) # 80002c6a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c54:	854a                	mv	a0,s2
    80003c56:	70a2                	ld	ra,40(sp)
    80003c58:	7402                	ld	s0,32(sp)
    80003c5a:	64e2                	ld	s1,24(sp)
    80003c5c:	6942                	ld	s2,16(sp)
    80003c5e:	69a2                	ld	s3,8(sp)
    80003c60:	6145                	addi	sp,sp,48
    80003c62:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c64:	6908                	ld	a0,16(a0)
    80003c66:	00000097          	auipc	ra,0x0
    80003c6a:	3c2080e7          	jalr	962(ra) # 80004028 <piperead>
    80003c6e:	892a                	mv	s2,a0
    80003c70:	b7d5                	j	80003c54 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c72:	02451783          	lh	a5,36(a0)
    80003c76:	03079693          	slli	a3,a5,0x30
    80003c7a:	92c1                	srli	a3,a3,0x30
    80003c7c:	4725                	li	a4,9
    80003c7e:	02d76863          	bltu	a4,a3,80003cae <fileread+0xba>
    80003c82:	0792                	slli	a5,a5,0x4
    80003c84:	00010717          	auipc	a4,0x10
    80003c88:	0e470713          	addi	a4,a4,228 # 80013d68 <devsw>
    80003c8c:	97ba                	add	a5,a5,a4
    80003c8e:	639c                	ld	a5,0(a5)
    80003c90:	c38d                	beqz	a5,80003cb2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c92:	4505                	li	a0,1
    80003c94:	9782                	jalr	a5
    80003c96:	892a                	mv	s2,a0
    80003c98:	bf75                	j	80003c54 <fileread+0x60>
    panic("fileread");
    80003c9a:	00005517          	auipc	a0,0x5
    80003c9e:	98e50513          	addi	a0,a0,-1650 # 80008628 <syscalls+0x258>
    80003ca2:	00002097          	auipc	ra,0x2
    80003ca6:	004080e7          	jalr	4(ra) # 80005ca6 <panic>
    return -1;
    80003caa:	597d                	li	s2,-1
    80003cac:	b765                	j	80003c54 <fileread+0x60>
      return -1;
    80003cae:	597d                	li	s2,-1
    80003cb0:	b755                	j	80003c54 <fileread+0x60>
    80003cb2:	597d                	li	s2,-1
    80003cb4:	b745                	j	80003c54 <fileread+0x60>

0000000080003cb6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003cb6:	00954783          	lbu	a5,9(a0)
    80003cba:	10078e63          	beqz	a5,80003dd6 <filewrite+0x120>
{
    80003cbe:	715d                	addi	sp,sp,-80
    80003cc0:	e486                	sd	ra,72(sp)
    80003cc2:	e0a2                	sd	s0,64(sp)
    80003cc4:	fc26                	sd	s1,56(sp)
    80003cc6:	f84a                	sd	s2,48(sp)
    80003cc8:	f44e                	sd	s3,40(sp)
    80003cca:	f052                	sd	s4,32(sp)
    80003ccc:	ec56                	sd	s5,24(sp)
    80003cce:	e85a                	sd	s6,16(sp)
    80003cd0:	e45e                	sd	s7,8(sp)
    80003cd2:	e062                	sd	s8,0(sp)
    80003cd4:	0880                	addi	s0,sp,80
    80003cd6:	892a                	mv	s2,a0
    80003cd8:	8b2e                	mv	s6,a1
    80003cda:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cdc:	411c                	lw	a5,0(a0)
    80003cde:	4705                	li	a4,1
    80003ce0:	02e78263          	beq	a5,a4,80003d04 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ce4:	470d                	li	a4,3
    80003ce6:	02e78563          	beq	a5,a4,80003d10 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cea:	4709                	li	a4,2
    80003cec:	0ce79d63          	bne	a5,a4,80003dc6 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cf0:	0ac05b63          	blez	a2,80003da6 <filewrite+0xf0>
    int i = 0;
    80003cf4:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003cf6:	6b85                	lui	s7,0x1
    80003cf8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cfc:	6c05                	lui	s8,0x1
    80003cfe:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d02:	a851                	j	80003d96 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d04:	6908                	ld	a0,16(a0)
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	22a080e7          	jalr	554(ra) # 80003f30 <pipewrite>
    80003d0e:	a045                	j	80003dae <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d10:	02451783          	lh	a5,36(a0)
    80003d14:	03079693          	slli	a3,a5,0x30
    80003d18:	92c1                	srli	a3,a3,0x30
    80003d1a:	4725                	li	a4,9
    80003d1c:	0ad76f63          	bltu	a4,a3,80003dda <filewrite+0x124>
    80003d20:	0792                	slli	a5,a5,0x4
    80003d22:	00010717          	auipc	a4,0x10
    80003d26:	04670713          	addi	a4,a4,70 # 80013d68 <devsw>
    80003d2a:	97ba                	add	a5,a5,a4
    80003d2c:	679c                	ld	a5,8(a5)
    80003d2e:	cbc5                	beqz	a5,80003dde <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003d30:	4505                	li	a0,1
    80003d32:	9782                	jalr	a5
    80003d34:	a8ad                	j	80003dae <filewrite+0xf8>
      if(n1 > max)
    80003d36:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	8bc080e7          	jalr	-1860(ra) # 800035f6 <begin_op>
      ilock(f->ip);
    80003d42:	01893503          	ld	a0,24(s2)
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	e62080e7          	jalr	-414(ra) # 80002ba8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d4e:	8756                	mv	a4,s5
    80003d50:	02092683          	lw	a3,32(s2)
    80003d54:	01698633          	add	a2,s3,s6
    80003d58:	4585                	li	a1,1
    80003d5a:	01893503          	ld	a0,24(s2)
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	29c080e7          	jalr	668(ra) # 80002ffa <writei>
    80003d66:	84aa                	mv	s1,a0
    80003d68:	00a05763          	blez	a0,80003d76 <filewrite+0xc0>
        f->off += r;
    80003d6c:	02092783          	lw	a5,32(s2)
    80003d70:	9fa9                	addw	a5,a5,a0
    80003d72:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d76:	01893503          	ld	a0,24(s2)
    80003d7a:	fffff097          	auipc	ra,0xfffff
    80003d7e:	ef0080e7          	jalr	-272(ra) # 80002c6a <iunlock>
      end_op();
    80003d82:	00000097          	auipc	ra,0x0
    80003d86:	8ee080e7          	jalr	-1810(ra) # 80003670 <end_op>

      if(r != n1){
    80003d8a:	009a9f63          	bne	s5,s1,80003da8 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003d8e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d92:	0149db63          	bge	s3,s4,80003da8 <filewrite+0xf2>
      int n1 = n - i;
    80003d96:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d9a:	0004879b          	sext.w	a5,s1
    80003d9e:	f8fbdce3          	bge	s7,a5,80003d36 <filewrite+0x80>
    80003da2:	84e2                	mv	s1,s8
    80003da4:	bf49                	j	80003d36 <filewrite+0x80>
    int i = 0;
    80003da6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003da8:	033a1d63          	bne	s4,s3,80003de2 <filewrite+0x12c>
    80003dac:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dae:	60a6                	ld	ra,72(sp)
    80003db0:	6406                	ld	s0,64(sp)
    80003db2:	74e2                	ld	s1,56(sp)
    80003db4:	7942                	ld	s2,48(sp)
    80003db6:	79a2                	ld	s3,40(sp)
    80003db8:	7a02                	ld	s4,32(sp)
    80003dba:	6ae2                	ld	s5,24(sp)
    80003dbc:	6b42                	ld	s6,16(sp)
    80003dbe:	6ba2                	ld	s7,8(sp)
    80003dc0:	6c02                	ld	s8,0(sp)
    80003dc2:	6161                	addi	sp,sp,80
    80003dc4:	8082                	ret
    panic("filewrite");
    80003dc6:	00005517          	auipc	a0,0x5
    80003dca:	87250513          	addi	a0,a0,-1934 # 80008638 <syscalls+0x268>
    80003dce:	00002097          	auipc	ra,0x2
    80003dd2:	ed8080e7          	jalr	-296(ra) # 80005ca6 <panic>
    return -1;
    80003dd6:	557d                	li	a0,-1
}
    80003dd8:	8082                	ret
      return -1;
    80003dda:	557d                	li	a0,-1
    80003ddc:	bfc9                	j	80003dae <filewrite+0xf8>
    80003dde:	557d                	li	a0,-1
    80003de0:	b7f9                	j	80003dae <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003de2:	557d                	li	a0,-1
    80003de4:	b7e9                	j	80003dae <filewrite+0xf8>

0000000080003de6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003de6:	7179                	addi	sp,sp,-48
    80003de8:	f406                	sd	ra,40(sp)
    80003dea:	f022                	sd	s0,32(sp)
    80003dec:	ec26                	sd	s1,24(sp)
    80003dee:	e84a                	sd	s2,16(sp)
    80003df0:	e44e                	sd	s3,8(sp)
    80003df2:	e052                	sd	s4,0(sp)
    80003df4:	1800                	addi	s0,sp,48
    80003df6:	84aa                	mv	s1,a0
    80003df8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dfa:	0005b023          	sd	zero,0(a1)
    80003dfe:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e02:	00000097          	auipc	ra,0x0
    80003e06:	bfc080e7          	jalr	-1028(ra) # 800039fe <filealloc>
    80003e0a:	e088                	sd	a0,0(s1)
    80003e0c:	c551                	beqz	a0,80003e98 <pipealloc+0xb2>
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	bf0080e7          	jalr	-1040(ra) # 800039fe <filealloc>
    80003e16:	00aa3023          	sd	a0,0(s4)
    80003e1a:	c92d                	beqz	a0,80003e8c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e1c:	ffffc097          	auipc	ra,0xffffc
    80003e20:	2fe080e7          	jalr	766(ra) # 8000011a <kalloc>
    80003e24:	892a                	mv	s2,a0
    80003e26:	c125                	beqz	a0,80003e86 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e28:	4985                	li	s3,1
    80003e2a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e2e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e32:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e36:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e3a:	00005597          	auipc	a1,0x5
    80003e3e:	80e58593          	addi	a1,a1,-2034 # 80008648 <syscalls+0x278>
    80003e42:	00002097          	auipc	ra,0x2
    80003e46:	30c080e7          	jalr	780(ra) # 8000614e <initlock>
  (*f0)->type = FD_PIPE;
    80003e4a:	609c                	ld	a5,0(s1)
    80003e4c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e50:	609c                	ld	a5,0(s1)
    80003e52:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e56:	609c                	ld	a5,0(s1)
    80003e58:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e5c:	609c                	ld	a5,0(s1)
    80003e5e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e62:	000a3783          	ld	a5,0(s4)
    80003e66:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e6a:	000a3783          	ld	a5,0(s4)
    80003e6e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e72:	000a3783          	ld	a5,0(s4)
    80003e76:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e7a:	000a3783          	ld	a5,0(s4)
    80003e7e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e82:	4501                	li	a0,0
    80003e84:	a025                	j	80003eac <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e86:	6088                	ld	a0,0(s1)
    80003e88:	e501                	bnez	a0,80003e90 <pipealloc+0xaa>
    80003e8a:	a039                	j	80003e98 <pipealloc+0xb2>
    80003e8c:	6088                	ld	a0,0(s1)
    80003e8e:	c51d                	beqz	a0,80003ebc <pipealloc+0xd6>
    fileclose(*f0);
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	c2a080e7          	jalr	-982(ra) # 80003aba <fileclose>
  if(*f1)
    80003e98:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e9c:	557d                	li	a0,-1
  if(*f1)
    80003e9e:	c799                	beqz	a5,80003eac <pipealloc+0xc6>
    fileclose(*f1);
    80003ea0:	853e                	mv	a0,a5
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	c18080e7          	jalr	-1000(ra) # 80003aba <fileclose>
  return -1;
    80003eaa:	557d                	li	a0,-1
}
    80003eac:	70a2                	ld	ra,40(sp)
    80003eae:	7402                	ld	s0,32(sp)
    80003eb0:	64e2                	ld	s1,24(sp)
    80003eb2:	6942                	ld	s2,16(sp)
    80003eb4:	69a2                	ld	s3,8(sp)
    80003eb6:	6a02                	ld	s4,0(sp)
    80003eb8:	6145                	addi	sp,sp,48
    80003eba:	8082                	ret
  return -1;
    80003ebc:	557d                	li	a0,-1
    80003ebe:	b7fd                	j	80003eac <pipealloc+0xc6>

0000000080003ec0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ec0:	1101                	addi	sp,sp,-32
    80003ec2:	ec06                	sd	ra,24(sp)
    80003ec4:	e822                	sd	s0,16(sp)
    80003ec6:	e426                	sd	s1,8(sp)
    80003ec8:	e04a                	sd	s2,0(sp)
    80003eca:	1000                	addi	s0,sp,32
    80003ecc:	84aa                	mv	s1,a0
    80003ece:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ed0:	00002097          	auipc	ra,0x2
    80003ed4:	30e080e7          	jalr	782(ra) # 800061de <acquire>
  if(writable){
    80003ed8:	02090d63          	beqz	s2,80003f12 <pipeclose+0x52>
    pi->writeopen = 0;
    80003edc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ee0:	21848513          	addi	a0,s1,536
    80003ee4:	ffffd097          	auipc	ra,0xffffd
    80003ee8:	67a080e7          	jalr	1658(ra) # 8000155e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eec:	2204b783          	ld	a5,544(s1)
    80003ef0:	eb95                	bnez	a5,80003f24 <pipeclose+0x64>
    release(&pi->lock);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	00002097          	auipc	ra,0x2
    80003ef8:	39e080e7          	jalr	926(ra) # 80006292 <release>
    kfree((char*)pi);
    80003efc:	8526                	mv	a0,s1
    80003efe:	ffffc097          	auipc	ra,0xffffc
    80003f02:	11e080e7          	jalr	286(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f06:	60e2                	ld	ra,24(sp)
    80003f08:	6442                	ld	s0,16(sp)
    80003f0a:	64a2                	ld	s1,8(sp)
    80003f0c:	6902                	ld	s2,0(sp)
    80003f0e:	6105                	addi	sp,sp,32
    80003f10:	8082                	ret
    pi->readopen = 0;
    80003f12:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f16:	21c48513          	addi	a0,s1,540
    80003f1a:	ffffd097          	auipc	ra,0xffffd
    80003f1e:	644080e7          	jalr	1604(ra) # 8000155e <wakeup>
    80003f22:	b7e9                	j	80003eec <pipeclose+0x2c>
    release(&pi->lock);
    80003f24:	8526                	mv	a0,s1
    80003f26:	00002097          	auipc	ra,0x2
    80003f2a:	36c080e7          	jalr	876(ra) # 80006292 <release>
}
    80003f2e:	bfe1                	j	80003f06 <pipeclose+0x46>

0000000080003f30 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f30:	711d                	addi	sp,sp,-96
    80003f32:	ec86                	sd	ra,88(sp)
    80003f34:	e8a2                	sd	s0,80(sp)
    80003f36:	e4a6                	sd	s1,72(sp)
    80003f38:	e0ca                	sd	s2,64(sp)
    80003f3a:	fc4e                	sd	s3,56(sp)
    80003f3c:	f852                	sd	s4,48(sp)
    80003f3e:	f456                	sd	s5,40(sp)
    80003f40:	f05a                	sd	s6,32(sp)
    80003f42:	ec5e                	sd	s7,24(sp)
    80003f44:	e862                	sd	s8,16(sp)
    80003f46:	1080                	addi	s0,sp,96
    80003f48:	84aa                	mv	s1,a0
    80003f4a:	8aae                	mv	s5,a1
    80003f4c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f4e:	ffffd097          	auipc	ra,0xffffd
    80003f52:	f04080e7          	jalr	-252(ra) # 80000e52 <myproc>
    80003f56:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f58:	8526                	mv	a0,s1
    80003f5a:	00002097          	auipc	ra,0x2
    80003f5e:	284080e7          	jalr	644(ra) # 800061de <acquire>
  while(i < n){
    80003f62:	0b405663          	blez	s4,8000400e <pipewrite+0xde>
  int i = 0;
    80003f66:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f68:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f6a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f6e:	21c48b93          	addi	s7,s1,540
    80003f72:	a089                	j	80003fb4 <pipewrite+0x84>
      release(&pi->lock);
    80003f74:	8526                	mv	a0,s1
    80003f76:	00002097          	auipc	ra,0x2
    80003f7a:	31c080e7          	jalr	796(ra) # 80006292 <release>
      return -1;
    80003f7e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f80:	854a                	mv	a0,s2
    80003f82:	60e6                	ld	ra,88(sp)
    80003f84:	6446                	ld	s0,80(sp)
    80003f86:	64a6                	ld	s1,72(sp)
    80003f88:	6906                	ld	s2,64(sp)
    80003f8a:	79e2                	ld	s3,56(sp)
    80003f8c:	7a42                	ld	s4,48(sp)
    80003f8e:	7aa2                	ld	s5,40(sp)
    80003f90:	7b02                	ld	s6,32(sp)
    80003f92:	6be2                	ld	s7,24(sp)
    80003f94:	6c42                	ld	s8,16(sp)
    80003f96:	6125                	addi	sp,sp,96
    80003f98:	8082                	ret
      wakeup(&pi->nread);
    80003f9a:	8562                	mv	a0,s8
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	5c2080e7          	jalr	1474(ra) # 8000155e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fa4:	85a6                	mv	a1,s1
    80003fa6:	855e                	mv	a0,s7
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	552080e7          	jalr	1362(ra) # 800014fa <sleep>
  while(i < n){
    80003fb0:	07495063          	bge	s2,s4,80004010 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003fb4:	2204a783          	lw	a5,544(s1)
    80003fb8:	dfd5                	beqz	a5,80003f74 <pipewrite+0x44>
    80003fba:	854e                	mv	a0,s3
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	7e0080e7          	jalr	2016(ra) # 8000179c <killed>
    80003fc4:	f945                	bnez	a0,80003f74 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fc6:	2184a783          	lw	a5,536(s1)
    80003fca:	21c4a703          	lw	a4,540(s1)
    80003fce:	2007879b          	addiw	a5,a5,512
    80003fd2:	fcf704e3          	beq	a4,a5,80003f9a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fd6:	4685                	li	a3,1
    80003fd8:	01590633          	add	a2,s2,s5
    80003fdc:	faf40593          	addi	a1,s0,-81
    80003fe0:	0509b503          	ld	a0,80(s3)
    80003fe4:	ffffd097          	auipc	ra,0xffffd
    80003fe8:	bba080e7          	jalr	-1094(ra) # 80000b9e <copyin>
    80003fec:	03650263          	beq	a0,s6,80004010 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ff0:	21c4a783          	lw	a5,540(s1)
    80003ff4:	0017871b          	addiw	a4,a5,1
    80003ff8:	20e4ae23          	sw	a4,540(s1)
    80003ffc:	1ff7f793          	andi	a5,a5,511
    80004000:	97a6                	add	a5,a5,s1
    80004002:	faf44703          	lbu	a4,-81(s0)
    80004006:	00e78c23          	sb	a4,24(a5)
      i++;
    8000400a:	2905                	addiw	s2,s2,1
    8000400c:	b755                	j	80003fb0 <pipewrite+0x80>
  int i = 0;
    8000400e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004010:	21848513          	addi	a0,s1,536
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	54a080e7          	jalr	1354(ra) # 8000155e <wakeup>
  release(&pi->lock);
    8000401c:	8526                	mv	a0,s1
    8000401e:	00002097          	auipc	ra,0x2
    80004022:	274080e7          	jalr	628(ra) # 80006292 <release>
  return i;
    80004026:	bfa9                	j	80003f80 <pipewrite+0x50>

0000000080004028 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004028:	715d                	addi	sp,sp,-80
    8000402a:	e486                	sd	ra,72(sp)
    8000402c:	e0a2                	sd	s0,64(sp)
    8000402e:	fc26                	sd	s1,56(sp)
    80004030:	f84a                	sd	s2,48(sp)
    80004032:	f44e                	sd	s3,40(sp)
    80004034:	f052                	sd	s4,32(sp)
    80004036:	ec56                	sd	s5,24(sp)
    80004038:	e85a                	sd	s6,16(sp)
    8000403a:	0880                	addi	s0,sp,80
    8000403c:	84aa                	mv	s1,a0
    8000403e:	892e                	mv	s2,a1
    80004040:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	e10080e7          	jalr	-496(ra) # 80000e52 <myproc>
    8000404a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000404c:	8526                	mv	a0,s1
    8000404e:	00002097          	auipc	ra,0x2
    80004052:	190080e7          	jalr	400(ra) # 800061de <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004056:	2184a703          	lw	a4,536(s1)
    8000405a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000405e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004062:	02f71763          	bne	a4,a5,80004090 <piperead+0x68>
    80004066:	2244a783          	lw	a5,548(s1)
    8000406a:	c39d                	beqz	a5,80004090 <piperead+0x68>
    if(killed(pr)){
    8000406c:	8552                	mv	a0,s4
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	72e080e7          	jalr	1838(ra) # 8000179c <killed>
    80004076:	e949                	bnez	a0,80004108 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004078:	85a6                	mv	a1,s1
    8000407a:	854e                	mv	a0,s3
    8000407c:	ffffd097          	auipc	ra,0xffffd
    80004080:	47e080e7          	jalr	1150(ra) # 800014fa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004084:	2184a703          	lw	a4,536(s1)
    80004088:	21c4a783          	lw	a5,540(s1)
    8000408c:	fcf70de3          	beq	a4,a5,80004066 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004090:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004092:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004094:	05505463          	blez	s5,800040dc <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004098:	2184a783          	lw	a5,536(s1)
    8000409c:	21c4a703          	lw	a4,540(s1)
    800040a0:	02f70e63          	beq	a4,a5,800040dc <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040a4:	0017871b          	addiw	a4,a5,1
    800040a8:	20e4ac23          	sw	a4,536(s1)
    800040ac:	1ff7f793          	andi	a5,a5,511
    800040b0:	97a6                	add	a5,a5,s1
    800040b2:	0187c783          	lbu	a5,24(a5)
    800040b6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040ba:	4685                	li	a3,1
    800040bc:	fbf40613          	addi	a2,s0,-65
    800040c0:	85ca                	mv	a1,s2
    800040c2:	050a3503          	ld	a0,80(s4)
    800040c6:	ffffd097          	auipc	ra,0xffffd
    800040ca:	a4c080e7          	jalr	-1460(ra) # 80000b12 <copyout>
    800040ce:	01650763          	beq	a0,s6,800040dc <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d2:	2985                	addiw	s3,s3,1
    800040d4:	0905                	addi	s2,s2,1
    800040d6:	fd3a91e3          	bne	s5,s3,80004098 <piperead+0x70>
    800040da:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040dc:	21c48513          	addi	a0,s1,540
    800040e0:	ffffd097          	auipc	ra,0xffffd
    800040e4:	47e080e7          	jalr	1150(ra) # 8000155e <wakeup>
  release(&pi->lock);
    800040e8:	8526                	mv	a0,s1
    800040ea:	00002097          	auipc	ra,0x2
    800040ee:	1a8080e7          	jalr	424(ra) # 80006292 <release>
  return i;
}
    800040f2:	854e                	mv	a0,s3
    800040f4:	60a6                	ld	ra,72(sp)
    800040f6:	6406                	ld	s0,64(sp)
    800040f8:	74e2                	ld	s1,56(sp)
    800040fa:	7942                	ld	s2,48(sp)
    800040fc:	79a2                	ld	s3,40(sp)
    800040fe:	7a02                	ld	s4,32(sp)
    80004100:	6ae2                	ld	s5,24(sp)
    80004102:	6b42                	ld	s6,16(sp)
    80004104:	6161                	addi	sp,sp,80
    80004106:	8082                	ret
      release(&pi->lock);
    80004108:	8526                	mv	a0,s1
    8000410a:	00002097          	auipc	ra,0x2
    8000410e:	188080e7          	jalr	392(ra) # 80006292 <release>
      return -1;
    80004112:	59fd                	li	s3,-1
    80004114:	bff9                	j	800040f2 <piperead+0xca>

0000000080004116 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004116:	1141                	addi	sp,sp,-16
    80004118:	e422                	sd	s0,8(sp)
    8000411a:	0800                	addi	s0,sp,16
    8000411c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000411e:	8905                	andi	a0,a0,1
    80004120:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004122:	8b89                	andi	a5,a5,2
    80004124:	c399                	beqz	a5,8000412a <flags2perm+0x14>
      perm |= PTE_W;
    80004126:	00456513          	ori	a0,a0,4
    return perm;
}
    8000412a:	6422                	ld	s0,8(sp)
    8000412c:	0141                	addi	sp,sp,16
    8000412e:	8082                	ret

0000000080004130 <exec>:

int
exec(char *path, char **argv)
{
    80004130:	df010113          	addi	sp,sp,-528
    80004134:	20113423          	sd	ra,520(sp)
    80004138:	20813023          	sd	s0,512(sp)
    8000413c:	ffa6                	sd	s1,504(sp)
    8000413e:	fbca                	sd	s2,496(sp)
    80004140:	f7ce                	sd	s3,488(sp)
    80004142:	f3d2                	sd	s4,480(sp)
    80004144:	efd6                	sd	s5,472(sp)
    80004146:	ebda                	sd	s6,464(sp)
    80004148:	e7de                	sd	s7,456(sp)
    8000414a:	e3e2                	sd	s8,448(sp)
    8000414c:	ff66                	sd	s9,440(sp)
    8000414e:	fb6a                	sd	s10,432(sp)
    80004150:	f76e                	sd	s11,424(sp)
    80004152:	0c00                	addi	s0,sp,528
    80004154:	892a                	mv	s2,a0
    80004156:	dea43c23          	sd	a0,-520(s0)
    8000415a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	cf4080e7          	jalr	-780(ra) # 80000e52 <myproc>
    80004166:	84aa                	mv	s1,a0

  begin_op();
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	48e080e7          	jalr	1166(ra) # 800035f6 <begin_op>

  if((ip = namei(path)) == 0){
    80004170:	854a                	mv	a0,s2
    80004172:	fffff097          	auipc	ra,0xfffff
    80004176:	284080e7          	jalr	644(ra) # 800033f6 <namei>
    8000417a:	c92d                	beqz	a0,800041ec <exec+0xbc>
    8000417c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000417e:	fffff097          	auipc	ra,0xfffff
    80004182:	a2a080e7          	jalr	-1494(ra) # 80002ba8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004186:	04000713          	li	a4,64
    8000418a:	4681                	li	a3,0
    8000418c:	e5040613          	addi	a2,s0,-432
    80004190:	4581                	li	a1,0
    80004192:	8552                	mv	a0,s4
    80004194:	fffff097          	auipc	ra,0xfffff
    80004198:	d6e080e7          	jalr	-658(ra) # 80002f02 <readi>
    8000419c:	04000793          	li	a5,64
    800041a0:	00f51a63          	bne	a0,a5,800041b4 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041a4:	e5042703          	lw	a4,-432(s0)
    800041a8:	464c47b7          	lui	a5,0x464c4
    800041ac:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041b0:	04f70463          	beq	a4,a5,800041f8 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041b4:	8552                	mv	a0,s4
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	cfa080e7          	jalr	-774(ra) # 80002eb0 <iunlockput>
    end_op();
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	4b2080e7          	jalr	1202(ra) # 80003670 <end_op>
  }
  return -1;
    800041c6:	557d                	li	a0,-1
}
    800041c8:	20813083          	ld	ra,520(sp)
    800041cc:	20013403          	ld	s0,512(sp)
    800041d0:	74fe                	ld	s1,504(sp)
    800041d2:	795e                	ld	s2,496(sp)
    800041d4:	79be                	ld	s3,488(sp)
    800041d6:	7a1e                	ld	s4,480(sp)
    800041d8:	6afe                	ld	s5,472(sp)
    800041da:	6b5e                	ld	s6,464(sp)
    800041dc:	6bbe                	ld	s7,456(sp)
    800041de:	6c1e                	ld	s8,448(sp)
    800041e0:	7cfa                	ld	s9,440(sp)
    800041e2:	7d5a                	ld	s10,432(sp)
    800041e4:	7dba                	ld	s11,424(sp)
    800041e6:	21010113          	addi	sp,sp,528
    800041ea:	8082                	ret
    end_op();
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	484080e7          	jalr	1156(ra) # 80003670 <end_op>
    return -1;
    800041f4:	557d                	li	a0,-1
    800041f6:	bfc9                	j	800041c8 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041f8:	8526                	mv	a0,s1
    800041fa:	ffffd097          	auipc	ra,0xffffd
    800041fe:	d1c080e7          	jalr	-740(ra) # 80000f16 <proc_pagetable>
    80004202:	8b2a                	mv	s6,a0
    80004204:	d945                	beqz	a0,800041b4 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004206:	e7042d03          	lw	s10,-400(s0)
    8000420a:	e8845783          	lhu	a5,-376(s0)
    8000420e:	10078463          	beqz	a5,80004316 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004212:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004214:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004216:	6c85                	lui	s9,0x1
    80004218:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000421c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004220:	6a85                	lui	s5,0x1
    80004222:	a0b5                	j	8000428e <exec+0x15e>
      panic("loadseg: address should exist");
    80004224:	00004517          	auipc	a0,0x4
    80004228:	42c50513          	addi	a0,a0,1068 # 80008650 <syscalls+0x280>
    8000422c:	00002097          	auipc	ra,0x2
    80004230:	a7a080e7          	jalr	-1414(ra) # 80005ca6 <panic>
    if(sz - i < PGSIZE)
    80004234:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004236:	8726                	mv	a4,s1
    80004238:	012c06bb          	addw	a3,s8,s2
    8000423c:	4581                	li	a1,0
    8000423e:	8552                	mv	a0,s4
    80004240:	fffff097          	auipc	ra,0xfffff
    80004244:	cc2080e7          	jalr	-830(ra) # 80002f02 <readi>
    80004248:	2501                	sext.w	a0,a0
    8000424a:	24a49863          	bne	s1,a0,8000449a <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    8000424e:	012a893b          	addw	s2,s5,s2
    80004252:	03397563          	bgeu	s2,s3,8000427c <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004256:	02091593          	slli	a1,s2,0x20
    8000425a:	9181                	srli	a1,a1,0x20
    8000425c:	95de                	add	a1,a1,s7
    8000425e:	855a                	mv	a0,s6
    80004260:	ffffc097          	auipc	ra,0xffffc
    80004264:	2a2080e7          	jalr	674(ra) # 80000502 <walkaddr>
    80004268:	862a                	mv	a2,a0
    if(pa == 0)
    8000426a:	dd4d                	beqz	a0,80004224 <exec+0xf4>
    if(sz - i < PGSIZE)
    8000426c:	412984bb          	subw	s1,s3,s2
    80004270:	0004879b          	sext.w	a5,s1
    80004274:	fcfcf0e3          	bgeu	s9,a5,80004234 <exec+0x104>
    80004278:	84d6                	mv	s1,s5
    8000427a:	bf6d                	j	80004234 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000427c:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004280:	2d85                	addiw	s11,s11,1
    80004282:	038d0d1b          	addiw	s10,s10,56
    80004286:	e8845783          	lhu	a5,-376(s0)
    8000428a:	08fdd763          	bge	s11,a5,80004318 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000428e:	2d01                	sext.w	s10,s10
    80004290:	03800713          	li	a4,56
    80004294:	86ea                	mv	a3,s10
    80004296:	e1840613          	addi	a2,s0,-488
    8000429a:	4581                	li	a1,0
    8000429c:	8552                	mv	a0,s4
    8000429e:	fffff097          	auipc	ra,0xfffff
    800042a2:	c64080e7          	jalr	-924(ra) # 80002f02 <readi>
    800042a6:	03800793          	li	a5,56
    800042aa:	1ef51663          	bne	a0,a5,80004496 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    800042ae:	e1842783          	lw	a5,-488(s0)
    800042b2:	4705                	li	a4,1
    800042b4:	fce796e3          	bne	a5,a4,80004280 <exec+0x150>
    if(ph.memsz < ph.filesz)
    800042b8:	e4043483          	ld	s1,-448(s0)
    800042bc:	e3843783          	ld	a5,-456(s0)
    800042c0:	1ef4e863          	bltu	s1,a5,800044b0 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042c4:	e2843783          	ld	a5,-472(s0)
    800042c8:	94be                	add	s1,s1,a5
    800042ca:	1ef4e663          	bltu	s1,a5,800044b6 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800042ce:	df043703          	ld	a4,-528(s0)
    800042d2:	8ff9                	and	a5,a5,a4
    800042d4:	1e079463          	bnez	a5,800044bc <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042d8:	e1c42503          	lw	a0,-484(s0)
    800042dc:	00000097          	auipc	ra,0x0
    800042e0:	e3a080e7          	jalr	-454(ra) # 80004116 <flags2perm>
    800042e4:	86aa                	mv	a3,a0
    800042e6:	8626                	mv	a2,s1
    800042e8:	85ca                	mv	a1,s2
    800042ea:	855a                	mv	a0,s6
    800042ec:	ffffc097          	auipc	ra,0xffffc
    800042f0:	5ca080e7          	jalr	1482(ra) # 800008b6 <uvmalloc>
    800042f4:	e0a43423          	sd	a0,-504(s0)
    800042f8:	1c050563          	beqz	a0,800044c2 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042fc:	e2843b83          	ld	s7,-472(s0)
    80004300:	e2042c03          	lw	s8,-480(s0)
    80004304:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004308:	00098463          	beqz	s3,80004310 <exec+0x1e0>
    8000430c:	4901                	li	s2,0
    8000430e:	b7a1                	j	80004256 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004310:	e0843903          	ld	s2,-504(s0)
    80004314:	b7b5                	j	80004280 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004316:	4901                	li	s2,0
  iunlockput(ip);
    80004318:	8552                	mv	a0,s4
    8000431a:	fffff097          	auipc	ra,0xfffff
    8000431e:	b96080e7          	jalr	-1130(ra) # 80002eb0 <iunlockput>
  end_op();
    80004322:	fffff097          	auipc	ra,0xfffff
    80004326:	34e080e7          	jalr	846(ra) # 80003670 <end_op>
  p = myproc();
    8000432a:	ffffd097          	auipc	ra,0xffffd
    8000432e:	b28080e7          	jalr	-1240(ra) # 80000e52 <myproc>
    80004332:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004334:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004338:	6985                	lui	s3,0x1
    8000433a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000433c:	99ca                	add	s3,s3,s2
    8000433e:	77fd                	lui	a5,0xfffff
    80004340:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004344:	4691                	li	a3,4
    80004346:	6609                	lui	a2,0x2
    80004348:	964e                	add	a2,a2,s3
    8000434a:	85ce                	mv	a1,s3
    8000434c:	855a                	mv	a0,s6
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	568080e7          	jalr	1384(ra) # 800008b6 <uvmalloc>
    80004356:	892a                	mv	s2,a0
    80004358:	e0a43423          	sd	a0,-504(s0)
    8000435c:	e509                	bnez	a0,80004366 <exec+0x236>
  if(pagetable)
    8000435e:	e1343423          	sd	s3,-504(s0)
    80004362:	4a01                	li	s4,0
    80004364:	aa1d                	j	8000449a <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004366:	75f9                	lui	a1,0xffffe
    80004368:	95aa                	add	a1,a1,a0
    8000436a:	855a                	mv	a0,s6
    8000436c:	ffffc097          	auipc	ra,0xffffc
    80004370:	774080e7          	jalr	1908(ra) # 80000ae0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004374:	7bfd                	lui	s7,0xfffff
    80004376:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004378:	e0043783          	ld	a5,-512(s0)
    8000437c:	6388                	ld	a0,0(a5)
    8000437e:	c52d                	beqz	a0,800043e8 <exec+0x2b8>
    80004380:	e9040993          	addi	s3,s0,-368
    80004384:	f9040c13          	addi	s8,s0,-112
    80004388:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000438a:	ffffc097          	auipc	ra,0xffffc
    8000438e:	f6a080e7          	jalr	-150(ra) # 800002f4 <strlen>
    80004392:	0015079b          	addiw	a5,a0,1
    80004396:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000439a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000439e:	13796563          	bltu	s2,s7,800044c8 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043a2:	e0043d03          	ld	s10,-512(s0)
    800043a6:	000d3a03          	ld	s4,0(s10)
    800043aa:	8552                	mv	a0,s4
    800043ac:	ffffc097          	auipc	ra,0xffffc
    800043b0:	f48080e7          	jalr	-184(ra) # 800002f4 <strlen>
    800043b4:	0015069b          	addiw	a3,a0,1
    800043b8:	8652                	mv	a2,s4
    800043ba:	85ca                	mv	a1,s2
    800043bc:	855a                	mv	a0,s6
    800043be:	ffffc097          	auipc	ra,0xffffc
    800043c2:	754080e7          	jalr	1876(ra) # 80000b12 <copyout>
    800043c6:	10054363          	bltz	a0,800044cc <exec+0x39c>
    ustack[argc] = sp;
    800043ca:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043ce:	0485                	addi	s1,s1,1
    800043d0:	008d0793          	addi	a5,s10,8
    800043d4:	e0f43023          	sd	a5,-512(s0)
    800043d8:	008d3503          	ld	a0,8(s10)
    800043dc:	c909                	beqz	a0,800043ee <exec+0x2be>
    if(argc >= MAXARG)
    800043de:	09a1                	addi	s3,s3,8
    800043e0:	fb8995e3          	bne	s3,s8,8000438a <exec+0x25a>
  ip = 0;
    800043e4:	4a01                	li	s4,0
    800043e6:	a855                	j	8000449a <exec+0x36a>
  sp = sz;
    800043e8:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043ec:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ee:	00349793          	slli	a5,s1,0x3
    800043f2:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffe1e50>
    800043f6:	97a2                	add	a5,a5,s0
    800043f8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043fc:	00148693          	addi	a3,s1,1
    80004400:	068e                	slli	a3,a3,0x3
    80004402:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004406:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000440a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000440e:	f57968e3          	bltu	s2,s7,8000435e <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004412:	e9040613          	addi	a2,s0,-368
    80004416:	85ca                	mv	a1,s2
    80004418:	855a                	mv	a0,s6
    8000441a:	ffffc097          	auipc	ra,0xffffc
    8000441e:	6f8080e7          	jalr	1784(ra) # 80000b12 <copyout>
    80004422:	0a054763          	bltz	a0,800044d0 <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004426:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000442a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000442e:	df843783          	ld	a5,-520(s0)
    80004432:	0007c703          	lbu	a4,0(a5)
    80004436:	cf11                	beqz	a4,80004452 <exec+0x322>
    80004438:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000443a:	02f00693          	li	a3,47
    8000443e:	a039                	j	8000444c <exec+0x31c>
      last = s+1;
    80004440:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004444:	0785                	addi	a5,a5,1
    80004446:	fff7c703          	lbu	a4,-1(a5)
    8000444a:	c701                	beqz	a4,80004452 <exec+0x322>
    if(*s == '/')
    8000444c:	fed71ce3          	bne	a4,a3,80004444 <exec+0x314>
    80004450:	bfc5                	j	80004440 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004452:	4641                	li	a2,16
    80004454:	df843583          	ld	a1,-520(s0)
    80004458:	158a8513          	addi	a0,s5,344
    8000445c:	ffffc097          	auipc	ra,0xffffc
    80004460:	e66080e7          	jalr	-410(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004464:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004468:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000446c:	e0843783          	ld	a5,-504(s0)
    80004470:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004474:	058ab783          	ld	a5,88(s5)
    80004478:	e6843703          	ld	a4,-408(s0)
    8000447c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000447e:	058ab783          	ld	a5,88(s5)
    80004482:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004486:	85e6                	mv	a1,s9
    80004488:	ffffd097          	auipc	ra,0xffffd
    8000448c:	b2a080e7          	jalr	-1238(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004490:	0004851b          	sext.w	a0,s1
    80004494:	bb15                	j	800041c8 <exec+0x98>
    80004496:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000449a:	e0843583          	ld	a1,-504(s0)
    8000449e:	855a                	mv	a0,s6
    800044a0:	ffffd097          	auipc	ra,0xffffd
    800044a4:	b12080e7          	jalr	-1262(ra) # 80000fb2 <proc_freepagetable>
  return -1;
    800044a8:	557d                	li	a0,-1
  if(ip){
    800044aa:	d00a0fe3          	beqz	s4,800041c8 <exec+0x98>
    800044ae:	b319                	j	800041b4 <exec+0x84>
    800044b0:	e1243423          	sd	s2,-504(s0)
    800044b4:	b7dd                	j	8000449a <exec+0x36a>
    800044b6:	e1243423          	sd	s2,-504(s0)
    800044ba:	b7c5                	j	8000449a <exec+0x36a>
    800044bc:	e1243423          	sd	s2,-504(s0)
    800044c0:	bfe9                	j	8000449a <exec+0x36a>
    800044c2:	e1243423          	sd	s2,-504(s0)
    800044c6:	bfd1                	j	8000449a <exec+0x36a>
  ip = 0;
    800044c8:	4a01                	li	s4,0
    800044ca:	bfc1                	j	8000449a <exec+0x36a>
    800044cc:	4a01                	li	s4,0
  if(pagetable)
    800044ce:	b7f1                	j	8000449a <exec+0x36a>
  sz = sz1;
    800044d0:	e0843983          	ld	s3,-504(s0)
    800044d4:	b569                	j	8000435e <exec+0x22e>

00000000800044d6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044d6:	7179                	addi	sp,sp,-48
    800044d8:	f406                	sd	ra,40(sp)
    800044da:	f022                	sd	s0,32(sp)
    800044dc:	ec26                	sd	s1,24(sp)
    800044de:	e84a                	sd	s2,16(sp)
    800044e0:	1800                	addi	s0,sp,48
    800044e2:	892e                	mv	s2,a1
    800044e4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044e6:	fdc40593          	addi	a1,s0,-36
    800044ea:	ffffe097          	auipc	ra,0xffffe
    800044ee:	a7c080e7          	jalr	-1412(ra) # 80001f66 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044f2:	fdc42703          	lw	a4,-36(s0)
    800044f6:	47bd                	li	a5,15
    800044f8:	02e7eb63          	bltu	a5,a4,8000452e <argfd+0x58>
    800044fc:	ffffd097          	auipc	ra,0xffffd
    80004500:	956080e7          	jalr	-1706(ra) # 80000e52 <myproc>
    80004504:	fdc42703          	lw	a4,-36(s0)
    80004508:	01a70793          	addi	a5,a4,26
    8000450c:	078e                	slli	a5,a5,0x3
    8000450e:	953e                	add	a0,a0,a5
    80004510:	611c                	ld	a5,0(a0)
    80004512:	c385                	beqz	a5,80004532 <argfd+0x5c>
    return -1;
  if(pfd)
    80004514:	00090463          	beqz	s2,8000451c <argfd+0x46>
    *pfd = fd;
    80004518:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000451c:	4501                	li	a0,0
  if(pf)
    8000451e:	c091                	beqz	s1,80004522 <argfd+0x4c>
    *pf = f;
    80004520:	e09c                	sd	a5,0(s1)
}
    80004522:	70a2                	ld	ra,40(sp)
    80004524:	7402                	ld	s0,32(sp)
    80004526:	64e2                	ld	s1,24(sp)
    80004528:	6942                	ld	s2,16(sp)
    8000452a:	6145                	addi	sp,sp,48
    8000452c:	8082                	ret
    return -1;
    8000452e:	557d                	li	a0,-1
    80004530:	bfcd                	j	80004522 <argfd+0x4c>
    80004532:	557d                	li	a0,-1
    80004534:	b7fd                	j	80004522 <argfd+0x4c>

0000000080004536 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004536:	1101                	addi	sp,sp,-32
    80004538:	ec06                	sd	ra,24(sp)
    8000453a:	e822                	sd	s0,16(sp)
    8000453c:	e426                	sd	s1,8(sp)
    8000453e:	1000                	addi	s0,sp,32
    80004540:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004542:	ffffd097          	auipc	ra,0xffffd
    80004546:	910080e7          	jalr	-1776(ra) # 80000e52 <myproc>
    8000454a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000454c:	0d050793          	addi	a5,a0,208
    80004550:	4501                	li	a0,0
    80004552:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004554:	6398                	ld	a4,0(a5)
    80004556:	cb19                	beqz	a4,8000456c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004558:	2505                	addiw	a0,a0,1
    8000455a:	07a1                	addi	a5,a5,8
    8000455c:	fed51ce3          	bne	a0,a3,80004554 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004560:	557d                	li	a0,-1
}
    80004562:	60e2                	ld	ra,24(sp)
    80004564:	6442                	ld	s0,16(sp)
    80004566:	64a2                	ld	s1,8(sp)
    80004568:	6105                	addi	sp,sp,32
    8000456a:	8082                	ret
      p->ofile[fd] = f;
    8000456c:	01a50793          	addi	a5,a0,26
    80004570:	078e                	slli	a5,a5,0x3
    80004572:	963e                	add	a2,a2,a5
    80004574:	e204                	sd	s1,0(a2)
      return fd;
    80004576:	b7f5                	j	80004562 <fdalloc+0x2c>

0000000080004578 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004578:	715d                	addi	sp,sp,-80
    8000457a:	e486                	sd	ra,72(sp)
    8000457c:	e0a2                	sd	s0,64(sp)
    8000457e:	fc26                	sd	s1,56(sp)
    80004580:	f84a                	sd	s2,48(sp)
    80004582:	f44e                	sd	s3,40(sp)
    80004584:	f052                	sd	s4,32(sp)
    80004586:	ec56                	sd	s5,24(sp)
    80004588:	e85a                	sd	s6,16(sp)
    8000458a:	0880                	addi	s0,sp,80
    8000458c:	8b2e                	mv	s6,a1
    8000458e:	89b2                	mv	s3,a2
    80004590:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004592:	fb040593          	addi	a1,s0,-80
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	e7e080e7          	jalr	-386(ra) # 80003414 <nameiparent>
    8000459e:	84aa                	mv	s1,a0
    800045a0:	14050b63          	beqz	a0,800046f6 <create+0x17e>
    return 0;

  ilock(dp);
    800045a4:	ffffe097          	auipc	ra,0xffffe
    800045a8:	604080e7          	jalr	1540(ra) # 80002ba8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045ac:	4601                	li	a2,0
    800045ae:	fb040593          	addi	a1,s0,-80
    800045b2:	8526                	mv	a0,s1
    800045b4:	fffff097          	auipc	ra,0xfffff
    800045b8:	b80080e7          	jalr	-1152(ra) # 80003134 <dirlookup>
    800045bc:	8aaa                	mv	s5,a0
    800045be:	c921                	beqz	a0,8000460e <create+0x96>
    iunlockput(dp);
    800045c0:	8526                	mv	a0,s1
    800045c2:	fffff097          	auipc	ra,0xfffff
    800045c6:	8ee080e7          	jalr	-1810(ra) # 80002eb0 <iunlockput>
    ilock(ip);
    800045ca:	8556                	mv	a0,s5
    800045cc:	ffffe097          	auipc	ra,0xffffe
    800045d0:	5dc080e7          	jalr	1500(ra) # 80002ba8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045d4:	4789                	li	a5,2
    800045d6:	02fb1563          	bne	s6,a5,80004600 <create+0x88>
    800045da:	044ad783          	lhu	a5,68(s5)
    800045de:	37f9                	addiw	a5,a5,-2
    800045e0:	17c2                	slli	a5,a5,0x30
    800045e2:	93c1                	srli	a5,a5,0x30
    800045e4:	4705                	li	a4,1
    800045e6:	00f76d63          	bltu	a4,a5,80004600 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045ea:	8556                	mv	a0,s5
    800045ec:	60a6                	ld	ra,72(sp)
    800045ee:	6406                	ld	s0,64(sp)
    800045f0:	74e2                	ld	s1,56(sp)
    800045f2:	7942                	ld	s2,48(sp)
    800045f4:	79a2                	ld	s3,40(sp)
    800045f6:	7a02                	ld	s4,32(sp)
    800045f8:	6ae2                	ld	s5,24(sp)
    800045fa:	6b42                	ld	s6,16(sp)
    800045fc:	6161                	addi	sp,sp,80
    800045fe:	8082                	ret
    iunlockput(ip);
    80004600:	8556                	mv	a0,s5
    80004602:	fffff097          	auipc	ra,0xfffff
    80004606:	8ae080e7          	jalr	-1874(ra) # 80002eb0 <iunlockput>
    return 0;
    8000460a:	4a81                	li	s5,0
    8000460c:	bff9                	j	800045ea <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000460e:	85da                	mv	a1,s6
    80004610:	4088                	lw	a0,0(s1)
    80004612:	ffffe097          	auipc	ra,0xffffe
    80004616:	3fe080e7          	jalr	1022(ra) # 80002a10 <ialloc>
    8000461a:	8a2a                	mv	s4,a0
    8000461c:	c529                	beqz	a0,80004666 <create+0xee>
  ilock(ip);
    8000461e:	ffffe097          	auipc	ra,0xffffe
    80004622:	58a080e7          	jalr	1418(ra) # 80002ba8 <ilock>
  ip->major = major;
    80004626:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000462a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000462e:	4905                	li	s2,1
    80004630:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004634:	8552                	mv	a0,s4
    80004636:	ffffe097          	auipc	ra,0xffffe
    8000463a:	4a6080e7          	jalr	1190(ra) # 80002adc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000463e:	032b0b63          	beq	s6,s2,80004674 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004642:	004a2603          	lw	a2,4(s4)
    80004646:	fb040593          	addi	a1,s0,-80
    8000464a:	8526                	mv	a0,s1
    8000464c:	fffff097          	auipc	ra,0xfffff
    80004650:	cf8080e7          	jalr	-776(ra) # 80003344 <dirlink>
    80004654:	06054f63          	bltz	a0,800046d2 <create+0x15a>
  iunlockput(dp);
    80004658:	8526                	mv	a0,s1
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	856080e7          	jalr	-1962(ra) # 80002eb0 <iunlockput>
  return ip;
    80004662:	8ad2                	mv	s5,s4
    80004664:	b759                	j	800045ea <create+0x72>
    iunlockput(dp);
    80004666:	8526                	mv	a0,s1
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	848080e7          	jalr	-1976(ra) # 80002eb0 <iunlockput>
    return 0;
    80004670:	8ad2                	mv	s5,s4
    80004672:	bfa5                	j	800045ea <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004674:	004a2603          	lw	a2,4(s4)
    80004678:	00004597          	auipc	a1,0x4
    8000467c:	ff858593          	addi	a1,a1,-8 # 80008670 <syscalls+0x2a0>
    80004680:	8552                	mv	a0,s4
    80004682:	fffff097          	auipc	ra,0xfffff
    80004686:	cc2080e7          	jalr	-830(ra) # 80003344 <dirlink>
    8000468a:	04054463          	bltz	a0,800046d2 <create+0x15a>
    8000468e:	40d0                	lw	a2,4(s1)
    80004690:	00004597          	auipc	a1,0x4
    80004694:	fe858593          	addi	a1,a1,-24 # 80008678 <syscalls+0x2a8>
    80004698:	8552                	mv	a0,s4
    8000469a:	fffff097          	auipc	ra,0xfffff
    8000469e:	caa080e7          	jalr	-854(ra) # 80003344 <dirlink>
    800046a2:	02054863          	bltz	a0,800046d2 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800046a6:	004a2603          	lw	a2,4(s4)
    800046aa:	fb040593          	addi	a1,s0,-80
    800046ae:	8526                	mv	a0,s1
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	c94080e7          	jalr	-876(ra) # 80003344 <dirlink>
    800046b8:	00054d63          	bltz	a0,800046d2 <create+0x15a>
    dp->nlink++;  // for ".."
    800046bc:	04a4d783          	lhu	a5,74(s1)
    800046c0:	2785                	addiw	a5,a5,1
    800046c2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046c6:	8526                	mv	a0,s1
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	414080e7          	jalr	1044(ra) # 80002adc <iupdate>
    800046d0:	b761                	j	80004658 <create+0xe0>
  ip->nlink = 0;
    800046d2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046d6:	8552                	mv	a0,s4
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	404080e7          	jalr	1028(ra) # 80002adc <iupdate>
  iunlockput(ip);
    800046e0:	8552                	mv	a0,s4
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	7ce080e7          	jalr	1998(ra) # 80002eb0 <iunlockput>
  iunlockput(dp);
    800046ea:	8526                	mv	a0,s1
    800046ec:	ffffe097          	auipc	ra,0xffffe
    800046f0:	7c4080e7          	jalr	1988(ra) # 80002eb0 <iunlockput>
  return 0;
    800046f4:	bddd                	j	800045ea <create+0x72>
    return 0;
    800046f6:	8aaa                	mv	s5,a0
    800046f8:	bdcd                	j	800045ea <create+0x72>

00000000800046fa <sys_dup>:
{
    800046fa:	7179                	addi	sp,sp,-48
    800046fc:	f406                	sd	ra,40(sp)
    800046fe:	f022                	sd	s0,32(sp)
    80004700:	ec26                	sd	s1,24(sp)
    80004702:	e84a                	sd	s2,16(sp)
    80004704:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004706:	fd840613          	addi	a2,s0,-40
    8000470a:	4581                	li	a1,0
    8000470c:	4501                	li	a0,0
    8000470e:	00000097          	auipc	ra,0x0
    80004712:	dc8080e7          	jalr	-568(ra) # 800044d6 <argfd>
    return -1;
    80004716:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004718:	02054363          	bltz	a0,8000473e <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000471c:	fd843903          	ld	s2,-40(s0)
    80004720:	854a                	mv	a0,s2
    80004722:	00000097          	auipc	ra,0x0
    80004726:	e14080e7          	jalr	-492(ra) # 80004536 <fdalloc>
    8000472a:	84aa                	mv	s1,a0
    return -1;
    8000472c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000472e:	00054863          	bltz	a0,8000473e <sys_dup+0x44>
  filedup(f);
    80004732:	854a                	mv	a0,s2
    80004734:	fffff097          	auipc	ra,0xfffff
    80004738:	334080e7          	jalr	820(ra) # 80003a68 <filedup>
  return fd;
    8000473c:	87a6                	mv	a5,s1
}
    8000473e:	853e                	mv	a0,a5
    80004740:	70a2                	ld	ra,40(sp)
    80004742:	7402                	ld	s0,32(sp)
    80004744:	64e2                	ld	s1,24(sp)
    80004746:	6942                	ld	s2,16(sp)
    80004748:	6145                	addi	sp,sp,48
    8000474a:	8082                	ret

000000008000474c <sys_read>:
{
    8000474c:	7179                	addi	sp,sp,-48
    8000474e:	f406                	sd	ra,40(sp)
    80004750:	f022                	sd	s0,32(sp)
    80004752:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004754:	fd840593          	addi	a1,s0,-40
    80004758:	4505                	li	a0,1
    8000475a:	ffffe097          	auipc	ra,0xffffe
    8000475e:	82c080e7          	jalr	-2004(ra) # 80001f86 <argaddr>
  argint(2, &n);
    80004762:	fe440593          	addi	a1,s0,-28
    80004766:	4509                	li	a0,2
    80004768:	ffffd097          	auipc	ra,0xffffd
    8000476c:	7fe080e7          	jalr	2046(ra) # 80001f66 <argint>
  if(argfd(0, 0, &f) < 0)
    80004770:	fe840613          	addi	a2,s0,-24
    80004774:	4581                	li	a1,0
    80004776:	4501                	li	a0,0
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	d5e080e7          	jalr	-674(ra) # 800044d6 <argfd>
    80004780:	87aa                	mv	a5,a0
    return -1;
    80004782:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004784:	0007cc63          	bltz	a5,8000479c <sys_read+0x50>
  return fileread(f, p, n);
    80004788:	fe442603          	lw	a2,-28(s0)
    8000478c:	fd843583          	ld	a1,-40(s0)
    80004790:	fe843503          	ld	a0,-24(s0)
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	460080e7          	jalr	1120(ra) # 80003bf4 <fileread>
}
    8000479c:	70a2                	ld	ra,40(sp)
    8000479e:	7402                	ld	s0,32(sp)
    800047a0:	6145                	addi	sp,sp,48
    800047a2:	8082                	ret

00000000800047a4 <sys_write>:
{
    800047a4:	7179                	addi	sp,sp,-48
    800047a6:	f406                	sd	ra,40(sp)
    800047a8:	f022                	sd	s0,32(sp)
    800047aa:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047ac:	fd840593          	addi	a1,s0,-40
    800047b0:	4505                	li	a0,1
    800047b2:	ffffd097          	auipc	ra,0xffffd
    800047b6:	7d4080e7          	jalr	2004(ra) # 80001f86 <argaddr>
  argint(2, &n);
    800047ba:	fe440593          	addi	a1,s0,-28
    800047be:	4509                	li	a0,2
    800047c0:	ffffd097          	auipc	ra,0xffffd
    800047c4:	7a6080e7          	jalr	1958(ra) # 80001f66 <argint>
  if(argfd(0, 0, &f) < 0)
    800047c8:	fe840613          	addi	a2,s0,-24
    800047cc:	4581                	li	a1,0
    800047ce:	4501                	li	a0,0
    800047d0:	00000097          	auipc	ra,0x0
    800047d4:	d06080e7          	jalr	-762(ra) # 800044d6 <argfd>
    800047d8:	87aa                	mv	a5,a0
    return -1;
    800047da:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047dc:	0007cc63          	bltz	a5,800047f4 <sys_write+0x50>
  return filewrite(f, p, n);
    800047e0:	fe442603          	lw	a2,-28(s0)
    800047e4:	fd843583          	ld	a1,-40(s0)
    800047e8:	fe843503          	ld	a0,-24(s0)
    800047ec:	fffff097          	auipc	ra,0xfffff
    800047f0:	4ca080e7          	jalr	1226(ra) # 80003cb6 <filewrite>
}
    800047f4:	70a2                	ld	ra,40(sp)
    800047f6:	7402                	ld	s0,32(sp)
    800047f8:	6145                	addi	sp,sp,48
    800047fa:	8082                	ret

00000000800047fc <sys_close>:
{
    800047fc:	1101                	addi	sp,sp,-32
    800047fe:	ec06                	sd	ra,24(sp)
    80004800:	e822                	sd	s0,16(sp)
    80004802:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004804:	fe040613          	addi	a2,s0,-32
    80004808:	fec40593          	addi	a1,s0,-20
    8000480c:	4501                	li	a0,0
    8000480e:	00000097          	auipc	ra,0x0
    80004812:	cc8080e7          	jalr	-824(ra) # 800044d6 <argfd>
    return -1;
    80004816:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004818:	02054463          	bltz	a0,80004840 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000481c:	ffffc097          	auipc	ra,0xffffc
    80004820:	636080e7          	jalr	1590(ra) # 80000e52 <myproc>
    80004824:	fec42783          	lw	a5,-20(s0)
    80004828:	07e9                	addi	a5,a5,26
    8000482a:	078e                	slli	a5,a5,0x3
    8000482c:	953e                	add	a0,a0,a5
    8000482e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004832:	fe043503          	ld	a0,-32(s0)
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	284080e7          	jalr	644(ra) # 80003aba <fileclose>
  return 0;
    8000483e:	4781                	li	a5,0
}
    80004840:	853e                	mv	a0,a5
    80004842:	60e2                	ld	ra,24(sp)
    80004844:	6442                	ld	s0,16(sp)
    80004846:	6105                	addi	sp,sp,32
    80004848:	8082                	ret

000000008000484a <sys_fstat>:
{
    8000484a:	1101                	addi	sp,sp,-32
    8000484c:	ec06                	sd	ra,24(sp)
    8000484e:	e822                	sd	s0,16(sp)
    80004850:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004852:	fe040593          	addi	a1,s0,-32
    80004856:	4505                	li	a0,1
    80004858:	ffffd097          	auipc	ra,0xffffd
    8000485c:	72e080e7          	jalr	1838(ra) # 80001f86 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004860:	fe840613          	addi	a2,s0,-24
    80004864:	4581                	li	a1,0
    80004866:	4501                	li	a0,0
    80004868:	00000097          	auipc	ra,0x0
    8000486c:	c6e080e7          	jalr	-914(ra) # 800044d6 <argfd>
    80004870:	87aa                	mv	a5,a0
    return -1;
    80004872:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004874:	0007ca63          	bltz	a5,80004888 <sys_fstat+0x3e>
  return filestat(f, st);
    80004878:	fe043583          	ld	a1,-32(s0)
    8000487c:	fe843503          	ld	a0,-24(s0)
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	302080e7          	jalr	770(ra) # 80003b82 <filestat>
}
    80004888:	60e2                	ld	ra,24(sp)
    8000488a:	6442                	ld	s0,16(sp)
    8000488c:	6105                	addi	sp,sp,32
    8000488e:	8082                	ret

0000000080004890 <sys_link>:
{
    80004890:	7169                	addi	sp,sp,-304
    80004892:	f606                	sd	ra,296(sp)
    80004894:	f222                	sd	s0,288(sp)
    80004896:	ee26                	sd	s1,280(sp)
    80004898:	ea4a                	sd	s2,272(sp)
    8000489a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000489c:	08000613          	li	a2,128
    800048a0:	ed040593          	addi	a1,s0,-304
    800048a4:	4501                	li	a0,0
    800048a6:	ffffd097          	auipc	ra,0xffffd
    800048aa:	700080e7          	jalr	1792(ra) # 80001fa6 <argstr>
    return -1;
    800048ae:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048b0:	10054e63          	bltz	a0,800049cc <sys_link+0x13c>
    800048b4:	08000613          	li	a2,128
    800048b8:	f5040593          	addi	a1,s0,-176
    800048bc:	4505                	li	a0,1
    800048be:	ffffd097          	auipc	ra,0xffffd
    800048c2:	6e8080e7          	jalr	1768(ra) # 80001fa6 <argstr>
    return -1;
    800048c6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048c8:	10054263          	bltz	a0,800049cc <sys_link+0x13c>
  begin_op();
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	d2a080e7          	jalr	-726(ra) # 800035f6 <begin_op>
  if((ip = namei(old)) == 0){
    800048d4:	ed040513          	addi	a0,s0,-304
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	b1e080e7          	jalr	-1250(ra) # 800033f6 <namei>
    800048e0:	84aa                	mv	s1,a0
    800048e2:	c551                	beqz	a0,8000496e <sys_link+0xde>
  ilock(ip);
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	2c4080e7          	jalr	708(ra) # 80002ba8 <ilock>
  if(ip->type == T_DIR){
    800048ec:	04449703          	lh	a4,68(s1)
    800048f0:	4785                	li	a5,1
    800048f2:	08f70463          	beq	a4,a5,8000497a <sys_link+0xea>
  ip->nlink++;
    800048f6:	04a4d783          	lhu	a5,74(s1)
    800048fa:	2785                	addiw	a5,a5,1
    800048fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004900:	8526                	mv	a0,s1
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	1da080e7          	jalr	474(ra) # 80002adc <iupdate>
  iunlock(ip);
    8000490a:	8526                	mv	a0,s1
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	35e080e7          	jalr	862(ra) # 80002c6a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004914:	fd040593          	addi	a1,s0,-48
    80004918:	f5040513          	addi	a0,s0,-176
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	af8080e7          	jalr	-1288(ra) # 80003414 <nameiparent>
    80004924:	892a                	mv	s2,a0
    80004926:	c935                	beqz	a0,8000499a <sys_link+0x10a>
  ilock(dp);
    80004928:	ffffe097          	auipc	ra,0xffffe
    8000492c:	280080e7          	jalr	640(ra) # 80002ba8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004930:	00092703          	lw	a4,0(s2)
    80004934:	409c                	lw	a5,0(s1)
    80004936:	04f71d63          	bne	a4,a5,80004990 <sys_link+0x100>
    8000493a:	40d0                	lw	a2,4(s1)
    8000493c:	fd040593          	addi	a1,s0,-48
    80004940:	854a                	mv	a0,s2
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	a02080e7          	jalr	-1534(ra) # 80003344 <dirlink>
    8000494a:	04054363          	bltz	a0,80004990 <sys_link+0x100>
  iunlockput(dp);
    8000494e:	854a                	mv	a0,s2
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	560080e7          	jalr	1376(ra) # 80002eb0 <iunlockput>
  iput(ip);
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	4ae080e7          	jalr	1198(ra) # 80002e08 <iput>
  end_op();
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	d0e080e7          	jalr	-754(ra) # 80003670 <end_op>
  return 0;
    8000496a:	4781                	li	a5,0
    8000496c:	a085                	j	800049cc <sys_link+0x13c>
    end_op();
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	d02080e7          	jalr	-766(ra) # 80003670 <end_op>
    return -1;
    80004976:	57fd                	li	a5,-1
    80004978:	a891                	j	800049cc <sys_link+0x13c>
    iunlockput(ip);
    8000497a:	8526                	mv	a0,s1
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	534080e7          	jalr	1332(ra) # 80002eb0 <iunlockput>
    end_op();
    80004984:	fffff097          	auipc	ra,0xfffff
    80004988:	cec080e7          	jalr	-788(ra) # 80003670 <end_op>
    return -1;
    8000498c:	57fd                	li	a5,-1
    8000498e:	a83d                	j	800049cc <sys_link+0x13c>
    iunlockput(dp);
    80004990:	854a                	mv	a0,s2
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	51e080e7          	jalr	1310(ra) # 80002eb0 <iunlockput>
  ilock(ip);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	20c080e7          	jalr	524(ra) # 80002ba8 <ilock>
  ip->nlink--;
    800049a4:	04a4d783          	lhu	a5,74(s1)
    800049a8:	37fd                	addiw	a5,a5,-1
    800049aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049ae:	8526                	mv	a0,s1
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	12c080e7          	jalr	300(ra) # 80002adc <iupdate>
  iunlockput(ip);
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	4f6080e7          	jalr	1270(ra) # 80002eb0 <iunlockput>
  end_op();
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	cae080e7          	jalr	-850(ra) # 80003670 <end_op>
  return -1;
    800049ca:	57fd                	li	a5,-1
}
    800049cc:	853e                	mv	a0,a5
    800049ce:	70b2                	ld	ra,296(sp)
    800049d0:	7412                	ld	s0,288(sp)
    800049d2:	64f2                	ld	s1,280(sp)
    800049d4:	6952                	ld	s2,272(sp)
    800049d6:	6155                	addi	sp,sp,304
    800049d8:	8082                	ret

00000000800049da <sys_unlink>:
{
    800049da:	7151                	addi	sp,sp,-240
    800049dc:	f586                	sd	ra,232(sp)
    800049de:	f1a2                	sd	s0,224(sp)
    800049e0:	eda6                	sd	s1,216(sp)
    800049e2:	e9ca                	sd	s2,208(sp)
    800049e4:	e5ce                	sd	s3,200(sp)
    800049e6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049e8:	08000613          	li	a2,128
    800049ec:	f3040593          	addi	a1,s0,-208
    800049f0:	4501                	li	a0,0
    800049f2:	ffffd097          	auipc	ra,0xffffd
    800049f6:	5b4080e7          	jalr	1460(ra) # 80001fa6 <argstr>
    800049fa:	18054163          	bltz	a0,80004b7c <sys_unlink+0x1a2>
  begin_op();
    800049fe:	fffff097          	auipc	ra,0xfffff
    80004a02:	bf8080e7          	jalr	-1032(ra) # 800035f6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a06:	fb040593          	addi	a1,s0,-80
    80004a0a:	f3040513          	addi	a0,s0,-208
    80004a0e:	fffff097          	auipc	ra,0xfffff
    80004a12:	a06080e7          	jalr	-1530(ra) # 80003414 <nameiparent>
    80004a16:	84aa                	mv	s1,a0
    80004a18:	c979                	beqz	a0,80004aee <sys_unlink+0x114>
  ilock(dp);
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	18e080e7          	jalr	398(ra) # 80002ba8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a22:	00004597          	auipc	a1,0x4
    80004a26:	c4e58593          	addi	a1,a1,-946 # 80008670 <syscalls+0x2a0>
    80004a2a:	fb040513          	addi	a0,s0,-80
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	6ec080e7          	jalr	1772(ra) # 8000311a <namecmp>
    80004a36:	14050a63          	beqz	a0,80004b8a <sys_unlink+0x1b0>
    80004a3a:	00004597          	auipc	a1,0x4
    80004a3e:	c3e58593          	addi	a1,a1,-962 # 80008678 <syscalls+0x2a8>
    80004a42:	fb040513          	addi	a0,s0,-80
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	6d4080e7          	jalr	1748(ra) # 8000311a <namecmp>
    80004a4e:	12050e63          	beqz	a0,80004b8a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a52:	f2c40613          	addi	a2,s0,-212
    80004a56:	fb040593          	addi	a1,s0,-80
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	6d8080e7          	jalr	1752(ra) # 80003134 <dirlookup>
    80004a64:	892a                	mv	s2,a0
    80004a66:	12050263          	beqz	a0,80004b8a <sys_unlink+0x1b0>
  ilock(ip);
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	13e080e7          	jalr	318(ra) # 80002ba8 <ilock>
  if(ip->nlink < 1)
    80004a72:	04a91783          	lh	a5,74(s2)
    80004a76:	08f05263          	blez	a5,80004afa <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a7a:	04491703          	lh	a4,68(s2)
    80004a7e:	4785                	li	a5,1
    80004a80:	08f70563          	beq	a4,a5,80004b0a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a84:	4641                	li	a2,16
    80004a86:	4581                	li	a1,0
    80004a88:	fc040513          	addi	a0,s0,-64
    80004a8c:	ffffb097          	auipc	ra,0xffffb
    80004a90:	6ee080e7          	jalr	1774(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a94:	4741                	li	a4,16
    80004a96:	f2c42683          	lw	a3,-212(s0)
    80004a9a:	fc040613          	addi	a2,s0,-64
    80004a9e:	4581                	li	a1,0
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	558080e7          	jalr	1368(ra) # 80002ffa <writei>
    80004aaa:	47c1                	li	a5,16
    80004aac:	0af51563          	bne	a0,a5,80004b56 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004ab0:	04491703          	lh	a4,68(s2)
    80004ab4:	4785                	li	a5,1
    80004ab6:	0af70863          	beq	a4,a5,80004b66 <sys_unlink+0x18c>
  iunlockput(dp);
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	3f4080e7          	jalr	1012(ra) # 80002eb0 <iunlockput>
  ip->nlink--;
    80004ac4:	04a95783          	lhu	a5,74(s2)
    80004ac8:	37fd                	addiw	a5,a5,-1
    80004aca:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ace:	854a                	mv	a0,s2
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	00c080e7          	jalr	12(ra) # 80002adc <iupdate>
  iunlockput(ip);
    80004ad8:	854a                	mv	a0,s2
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	3d6080e7          	jalr	982(ra) # 80002eb0 <iunlockput>
  end_op();
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	b8e080e7          	jalr	-1138(ra) # 80003670 <end_op>
  return 0;
    80004aea:	4501                	li	a0,0
    80004aec:	a84d                	j	80004b9e <sys_unlink+0x1c4>
    end_op();
    80004aee:	fffff097          	auipc	ra,0xfffff
    80004af2:	b82080e7          	jalr	-1150(ra) # 80003670 <end_op>
    return -1;
    80004af6:	557d                	li	a0,-1
    80004af8:	a05d                	j	80004b9e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004afa:	00004517          	auipc	a0,0x4
    80004afe:	b8650513          	addi	a0,a0,-1146 # 80008680 <syscalls+0x2b0>
    80004b02:	00001097          	auipc	ra,0x1
    80004b06:	1a4080e7          	jalr	420(ra) # 80005ca6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b0a:	04c92703          	lw	a4,76(s2)
    80004b0e:	02000793          	li	a5,32
    80004b12:	f6e7f9e3          	bgeu	a5,a4,80004a84 <sys_unlink+0xaa>
    80004b16:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b1a:	4741                	li	a4,16
    80004b1c:	86ce                	mv	a3,s3
    80004b1e:	f1840613          	addi	a2,s0,-232
    80004b22:	4581                	li	a1,0
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	3dc080e7          	jalr	988(ra) # 80002f02 <readi>
    80004b2e:	47c1                	li	a5,16
    80004b30:	00f51b63          	bne	a0,a5,80004b46 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b34:	f1845783          	lhu	a5,-232(s0)
    80004b38:	e7a1                	bnez	a5,80004b80 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b3a:	29c1                	addiw	s3,s3,16
    80004b3c:	04c92783          	lw	a5,76(s2)
    80004b40:	fcf9ede3          	bltu	s3,a5,80004b1a <sys_unlink+0x140>
    80004b44:	b781                	j	80004a84 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b46:	00004517          	auipc	a0,0x4
    80004b4a:	b5250513          	addi	a0,a0,-1198 # 80008698 <syscalls+0x2c8>
    80004b4e:	00001097          	auipc	ra,0x1
    80004b52:	158080e7          	jalr	344(ra) # 80005ca6 <panic>
    panic("unlink: writei");
    80004b56:	00004517          	auipc	a0,0x4
    80004b5a:	b5a50513          	addi	a0,a0,-1190 # 800086b0 <syscalls+0x2e0>
    80004b5e:	00001097          	auipc	ra,0x1
    80004b62:	148080e7          	jalr	328(ra) # 80005ca6 <panic>
    dp->nlink--;
    80004b66:	04a4d783          	lhu	a5,74(s1)
    80004b6a:	37fd                	addiw	a5,a5,-1
    80004b6c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b70:	8526                	mv	a0,s1
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	f6a080e7          	jalr	-150(ra) # 80002adc <iupdate>
    80004b7a:	b781                	j	80004aba <sys_unlink+0xe0>
    return -1;
    80004b7c:	557d                	li	a0,-1
    80004b7e:	a005                	j	80004b9e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b80:	854a                	mv	a0,s2
    80004b82:	ffffe097          	auipc	ra,0xffffe
    80004b86:	32e080e7          	jalr	814(ra) # 80002eb0 <iunlockput>
  iunlockput(dp);
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	324080e7          	jalr	804(ra) # 80002eb0 <iunlockput>
  end_op();
    80004b94:	fffff097          	auipc	ra,0xfffff
    80004b98:	adc080e7          	jalr	-1316(ra) # 80003670 <end_op>
  return -1;
    80004b9c:	557d                	li	a0,-1
}
    80004b9e:	70ae                	ld	ra,232(sp)
    80004ba0:	740e                	ld	s0,224(sp)
    80004ba2:	64ee                	ld	s1,216(sp)
    80004ba4:	694e                	ld	s2,208(sp)
    80004ba6:	69ae                	ld	s3,200(sp)
    80004ba8:	616d                	addi	sp,sp,240
    80004baa:	8082                	ret

0000000080004bac <sys_open>:

uint64
sys_open(void)
{
    80004bac:	7131                	addi	sp,sp,-192
    80004bae:	fd06                	sd	ra,184(sp)
    80004bb0:	f922                	sd	s0,176(sp)
    80004bb2:	f526                	sd	s1,168(sp)
    80004bb4:	f14a                	sd	s2,160(sp)
    80004bb6:	ed4e                	sd	s3,152(sp)
    80004bb8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004bba:	f4c40593          	addi	a1,s0,-180
    80004bbe:	4505                	li	a0,1
    80004bc0:	ffffd097          	auipc	ra,0xffffd
    80004bc4:	3a6080e7          	jalr	934(ra) # 80001f66 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bc8:	08000613          	li	a2,128
    80004bcc:	f5040593          	addi	a1,s0,-176
    80004bd0:	4501                	li	a0,0
    80004bd2:	ffffd097          	auipc	ra,0xffffd
    80004bd6:	3d4080e7          	jalr	980(ra) # 80001fa6 <argstr>
    80004bda:	87aa                	mv	a5,a0
    return -1;
    80004bdc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bde:	0a07c863          	bltz	a5,80004c8e <sys_open+0xe2>

  begin_op();
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	a14080e7          	jalr	-1516(ra) # 800035f6 <begin_op>

  if(omode & O_CREATE){
    80004bea:	f4c42783          	lw	a5,-180(s0)
    80004bee:	2007f793          	andi	a5,a5,512
    80004bf2:	cbdd                	beqz	a5,80004ca8 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004bf4:	4681                	li	a3,0
    80004bf6:	4601                	li	a2,0
    80004bf8:	4589                	li	a1,2
    80004bfa:	f5040513          	addi	a0,s0,-176
    80004bfe:	00000097          	auipc	ra,0x0
    80004c02:	97a080e7          	jalr	-1670(ra) # 80004578 <create>
    80004c06:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c08:	c951                	beqz	a0,80004c9c <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c0a:	04449703          	lh	a4,68(s1)
    80004c0e:	478d                	li	a5,3
    80004c10:	00f71763          	bne	a4,a5,80004c1e <sys_open+0x72>
    80004c14:	0464d703          	lhu	a4,70(s1)
    80004c18:	47a5                	li	a5,9
    80004c1a:	0ce7ec63          	bltu	a5,a4,80004cf2 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	de0080e7          	jalr	-544(ra) # 800039fe <filealloc>
    80004c26:	892a                	mv	s2,a0
    80004c28:	c56d                	beqz	a0,80004d12 <sys_open+0x166>
    80004c2a:	00000097          	auipc	ra,0x0
    80004c2e:	90c080e7          	jalr	-1780(ra) # 80004536 <fdalloc>
    80004c32:	89aa                	mv	s3,a0
    80004c34:	0c054a63          	bltz	a0,80004d08 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c38:	04449703          	lh	a4,68(s1)
    80004c3c:	478d                	li	a5,3
    80004c3e:	0ef70563          	beq	a4,a5,80004d28 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c42:	4789                	li	a5,2
    80004c44:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c48:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c4c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c50:	f4c42783          	lw	a5,-180(s0)
    80004c54:	0017c713          	xori	a4,a5,1
    80004c58:	8b05                	andi	a4,a4,1
    80004c5a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c5e:	0037f713          	andi	a4,a5,3
    80004c62:	00e03733          	snez	a4,a4
    80004c66:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c6a:	4007f793          	andi	a5,a5,1024
    80004c6e:	c791                	beqz	a5,80004c7a <sys_open+0xce>
    80004c70:	04449703          	lh	a4,68(s1)
    80004c74:	4789                	li	a5,2
    80004c76:	0cf70063          	beq	a4,a5,80004d36 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	fee080e7          	jalr	-18(ra) # 80002c6a <iunlock>
  end_op();
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	9ec080e7          	jalr	-1556(ra) # 80003670 <end_op>

  return fd;
    80004c8c:	854e                	mv	a0,s3
}
    80004c8e:	70ea                	ld	ra,184(sp)
    80004c90:	744a                	ld	s0,176(sp)
    80004c92:	74aa                	ld	s1,168(sp)
    80004c94:	790a                	ld	s2,160(sp)
    80004c96:	69ea                	ld	s3,152(sp)
    80004c98:	6129                	addi	sp,sp,192
    80004c9a:	8082                	ret
      end_op();
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	9d4080e7          	jalr	-1580(ra) # 80003670 <end_op>
      return -1;
    80004ca4:	557d                	li	a0,-1
    80004ca6:	b7e5                	j	80004c8e <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004ca8:	f5040513          	addi	a0,s0,-176
    80004cac:	ffffe097          	auipc	ra,0xffffe
    80004cb0:	74a080e7          	jalr	1866(ra) # 800033f6 <namei>
    80004cb4:	84aa                	mv	s1,a0
    80004cb6:	c905                	beqz	a0,80004ce6 <sys_open+0x13a>
    ilock(ip);
    80004cb8:	ffffe097          	auipc	ra,0xffffe
    80004cbc:	ef0080e7          	jalr	-272(ra) # 80002ba8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cc0:	04449703          	lh	a4,68(s1)
    80004cc4:	4785                	li	a5,1
    80004cc6:	f4f712e3          	bne	a4,a5,80004c0a <sys_open+0x5e>
    80004cca:	f4c42783          	lw	a5,-180(s0)
    80004cce:	dba1                	beqz	a5,80004c1e <sys_open+0x72>
      iunlockput(ip);
    80004cd0:	8526                	mv	a0,s1
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	1de080e7          	jalr	478(ra) # 80002eb0 <iunlockput>
      end_op();
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	996080e7          	jalr	-1642(ra) # 80003670 <end_op>
      return -1;
    80004ce2:	557d                	li	a0,-1
    80004ce4:	b76d                	j	80004c8e <sys_open+0xe2>
      end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	98a080e7          	jalr	-1654(ra) # 80003670 <end_op>
      return -1;
    80004cee:	557d                	li	a0,-1
    80004cf0:	bf79                	j	80004c8e <sys_open+0xe2>
    iunlockput(ip);
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	1bc080e7          	jalr	444(ra) # 80002eb0 <iunlockput>
    end_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	974080e7          	jalr	-1676(ra) # 80003670 <end_op>
    return -1;
    80004d04:	557d                	li	a0,-1
    80004d06:	b761                	j	80004c8e <sys_open+0xe2>
      fileclose(f);
    80004d08:	854a                	mv	a0,s2
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	db0080e7          	jalr	-592(ra) # 80003aba <fileclose>
    iunlockput(ip);
    80004d12:	8526                	mv	a0,s1
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	19c080e7          	jalr	412(ra) # 80002eb0 <iunlockput>
    end_op();
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	954080e7          	jalr	-1708(ra) # 80003670 <end_op>
    return -1;
    80004d24:	557d                	li	a0,-1
    80004d26:	b7a5                	j	80004c8e <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004d28:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d2c:	04649783          	lh	a5,70(s1)
    80004d30:	02f91223          	sh	a5,36(s2)
    80004d34:	bf21                	j	80004c4c <sys_open+0xa0>
    itrunc(ip);
    80004d36:	8526                	mv	a0,s1
    80004d38:	ffffe097          	auipc	ra,0xffffe
    80004d3c:	f7e080e7          	jalr	-130(ra) # 80002cb6 <itrunc>
    80004d40:	bf2d                	j	80004c7a <sys_open+0xce>

0000000080004d42 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d42:	7175                	addi	sp,sp,-144
    80004d44:	e506                	sd	ra,136(sp)
    80004d46:	e122                	sd	s0,128(sp)
    80004d48:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	8ac080e7          	jalr	-1876(ra) # 800035f6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d52:	08000613          	li	a2,128
    80004d56:	f7040593          	addi	a1,s0,-144
    80004d5a:	4501                	li	a0,0
    80004d5c:	ffffd097          	auipc	ra,0xffffd
    80004d60:	24a080e7          	jalr	586(ra) # 80001fa6 <argstr>
    80004d64:	02054963          	bltz	a0,80004d96 <sys_mkdir+0x54>
    80004d68:	4681                	li	a3,0
    80004d6a:	4601                	li	a2,0
    80004d6c:	4585                	li	a1,1
    80004d6e:	f7040513          	addi	a0,s0,-144
    80004d72:	00000097          	auipc	ra,0x0
    80004d76:	806080e7          	jalr	-2042(ra) # 80004578 <create>
    80004d7a:	cd11                	beqz	a0,80004d96 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d7c:	ffffe097          	auipc	ra,0xffffe
    80004d80:	134080e7          	jalr	308(ra) # 80002eb0 <iunlockput>
  end_op();
    80004d84:	fffff097          	auipc	ra,0xfffff
    80004d88:	8ec080e7          	jalr	-1812(ra) # 80003670 <end_op>
  return 0;
    80004d8c:	4501                	li	a0,0
}
    80004d8e:	60aa                	ld	ra,136(sp)
    80004d90:	640a                	ld	s0,128(sp)
    80004d92:	6149                	addi	sp,sp,144
    80004d94:	8082                	ret
    end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	8da080e7          	jalr	-1830(ra) # 80003670 <end_op>
    return -1;
    80004d9e:	557d                	li	a0,-1
    80004da0:	b7fd                	j	80004d8e <sys_mkdir+0x4c>

0000000080004da2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004da2:	7135                	addi	sp,sp,-160
    80004da4:	ed06                	sd	ra,152(sp)
    80004da6:	e922                	sd	s0,144(sp)
    80004da8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	84c080e7          	jalr	-1972(ra) # 800035f6 <begin_op>
  argint(1, &major);
    80004db2:	f6c40593          	addi	a1,s0,-148
    80004db6:	4505                	li	a0,1
    80004db8:	ffffd097          	auipc	ra,0xffffd
    80004dbc:	1ae080e7          	jalr	430(ra) # 80001f66 <argint>
  argint(2, &minor);
    80004dc0:	f6840593          	addi	a1,s0,-152
    80004dc4:	4509                	li	a0,2
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	1a0080e7          	jalr	416(ra) # 80001f66 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dce:	08000613          	li	a2,128
    80004dd2:	f7040593          	addi	a1,s0,-144
    80004dd6:	4501                	li	a0,0
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	1ce080e7          	jalr	462(ra) # 80001fa6 <argstr>
    80004de0:	02054b63          	bltz	a0,80004e16 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004de4:	f6841683          	lh	a3,-152(s0)
    80004de8:	f6c41603          	lh	a2,-148(s0)
    80004dec:	458d                	li	a1,3
    80004dee:	f7040513          	addi	a0,s0,-144
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	786080e7          	jalr	1926(ra) # 80004578 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dfa:	cd11                	beqz	a0,80004e16 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	0b4080e7          	jalr	180(ra) # 80002eb0 <iunlockput>
  end_op();
    80004e04:	fffff097          	auipc	ra,0xfffff
    80004e08:	86c080e7          	jalr	-1940(ra) # 80003670 <end_op>
  return 0;
    80004e0c:	4501                	li	a0,0
}
    80004e0e:	60ea                	ld	ra,152(sp)
    80004e10:	644a                	ld	s0,144(sp)
    80004e12:	610d                	addi	sp,sp,160
    80004e14:	8082                	ret
    end_op();
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	85a080e7          	jalr	-1958(ra) # 80003670 <end_op>
    return -1;
    80004e1e:	557d                	li	a0,-1
    80004e20:	b7fd                	j	80004e0e <sys_mknod+0x6c>

0000000080004e22 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e22:	7135                	addi	sp,sp,-160
    80004e24:	ed06                	sd	ra,152(sp)
    80004e26:	e922                	sd	s0,144(sp)
    80004e28:	e526                	sd	s1,136(sp)
    80004e2a:	e14a                	sd	s2,128(sp)
    80004e2c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e2e:	ffffc097          	auipc	ra,0xffffc
    80004e32:	024080e7          	jalr	36(ra) # 80000e52 <myproc>
    80004e36:	892a                	mv	s2,a0
  
  begin_op();
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	7be080e7          	jalr	1982(ra) # 800035f6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e40:	08000613          	li	a2,128
    80004e44:	f6040593          	addi	a1,s0,-160
    80004e48:	4501                	li	a0,0
    80004e4a:	ffffd097          	auipc	ra,0xffffd
    80004e4e:	15c080e7          	jalr	348(ra) # 80001fa6 <argstr>
    80004e52:	04054b63          	bltz	a0,80004ea8 <sys_chdir+0x86>
    80004e56:	f6040513          	addi	a0,s0,-160
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	59c080e7          	jalr	1436(ra) # 800033f6 <namei>
    80004e62:	84aa                	mv	s1,a0
    80004e64:	c131                	beqz	a0,80004ea8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	d42080e7          	jalr	-702(ra) # 80002ba8 <ilock>
  if(ip->type != T_DIR){
    80004e6e:	04449703          	lh	a4,68(s1)
    80004e72:	4785                	li	a5,1
    80004e74:	04f71063          	bne	a4,a5,80004eb4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e78:	8526                	mv	a0,s1
    80004e7a:	ffffe097          	auipc	ra,0xffffe
    80004e7e:	df0080e7          	jalr	-528(ra) # 80002c6a <iunlock>
  iput(p->cwd);
    80004e82:	15093503          	ld	a0,336(s2)
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	f82080e7          	jalr	-126(ra) # 80002e08 <iput>
  end_op();
    80004e8e:	ffffe097          	auipc	ra,0xffffe
    80004e92:	7e2080e7          	jalr	2018(ra) # 80003670 <end_op>
  p->cwd = ip;
    80004e96:	14993823          	sd	s1,336(s2)
  return 0;
    80004e9a:	4501                	li	a0,0
}
    80004e9c:	60ea                	ld	ra,152(sp)
    80004e9e:	644a                	ld	s0,144(sp)
    80004ea0:	64aa                	ld	s1,136(sp)
    80004ea2:	690a                	ld	s2,128(sp)
    80004ea4:	610d                	addi	sp,sp,160
    80004ea6:	8082                	ret
    end_op();
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	7c8080e7          	jalr	1992(ra) # 80003670 <end_op>
    return -1;
    80004eb0:	557d                	li	a0,-1
    80004eb2:	b7ed                	j	80004e9c <sys_chdir+0x7a>
    iunlockput(ip);
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	ffa080e7          	jalr	-6(ra) # 80002eb0 <iunlockput>
    end_op();
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	7b2080e7          	jalr	1970(ra) # 80003670 <end_op>
    return -1;
    80004ec6:	557d                	li	a0,-1
    80004ec8:	bfd1                	j	80004e9c <sys_chdir+0x7a>

0000000080004eca <sys_exec>:

uint64
sys_exec(void)
{
    80004eca:	7121                	addi	sp,sp,-448
    80004ecc:	ff06                	sd	ra,440(sp)
    80004ece:	fb22                	sd	s0,432(sp)
    80004ed0:	f726                	sd	s1,424(sp)
    80004ed2:	f34a                	sd	s2,416(sp)
    80004ed4:	ef4e                	sd	s3,408(sp)
    80004ed6:	eb52                	sd	s4,400(sp)
    80004ed8:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004eda:	e4840593          	addi	a1,s0,-440
    80004ede:	4505                	li	a0,1
    80004ee0:	ffffd097          	auipc	ra,0xffffd
    80004ee4:	0a6080e7          	jalr	166(ra) # 80001f86 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ee8:	08000613          	li	a2,128
    80004eec:	f5040593          	addi	a1,s0,-176
    80004ef0:	4501                	li	a0,0
    80004ef2:	ffffd097          	auipc	ra,0xffffd
    80004ef6:	0b4080e7          	jalr	180(ra) # 80001fa6 <argstr>
    80004efa:	87aa                	mv	a5,a0
    return -1;
    80004efc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004efe:	0c07c263          	bltz	a5,80004fc2 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004f02:	10000613          	li	a2,256
    80004f06:	4581                	li	a1,0
    80004f08:	e5040513          	addi	a0,s0,-432
    80004f0c:	ffffb097          	auipc	ra,0xffffb
    80004f10:	26e080e7          	jalr	622(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f14:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f18:	89a6                	mv	s3,s1
    80004f1a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f1c:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f20:	00391513          	slli	a0,s2,0x3
    80004f24:	e4040593          	addi	a1,s0,-448
    80004f28:	e4843783          	ld	a5,-440(s0)
    80004f2c:	953e                	add	a0,a0,a5
    80004f2e:	ffffd097          	auipc	ra,0xffffd
    80004f32:	f9a080e7          	jalr	-102(ra) # 80001ec8 <fetchaddr>
    80004f36:	02054a63          	bltz	a0,80004f6a <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004f3a:	e4043783          	ld	a5,-448(s0)
    80004f3e:	c3b9                	beqz	a5,80004f84 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f40:	ffffb097          	auipc	ra,0xffffb
    80004f44:	1da080e7          	jalr	474(ra) # 8000011a <kalloc>
    80004f48:	85aa                	mv	a1,a0
    80004f4a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f4e:	cd11                	beqz	a0,80004f6a <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f50:	6605                	lui	a2,0x1
    80004f52:	e4043503          	ld	a0,-448(s0)
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	fc4080e7          	jalr	-60(ra) # 80001f1a <fetchstr>
    80004f5e:	00054663          	bltz	a0,80004f6a <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004f62:	0905                	addi	s2,s2,1
    80004f64:	09a1                	addi	s3,s3,8
    80004f66:	fb491de3          	bne	s2,s4,80004f20 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6a:	f5040913          	addi	s2,s0,-176
    80004f6e:	6088                	ld	a0,0(s1)
    80004f70:	c921                	beqz	a0,80004fc0 <sys_exec+0xf6>
    kfree(argv[i]);
    80004f72:	ffffb097          	auipc	ra,0xffffb
    80004f76:	0aa080e7          	jalr	170(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f7a:	04a1                	addi	s1,s1,8
    80004f7c:	ff2499e3          	bne	s1,s2,80004f6e <sys_exec+0xa4>
  return -1;
    80004f80:	557d                	li	a0,-1
    80004f82:	a081                	j	80004fc2 <sys_exec+0xf8>
      argv[i] = 0;
    80004f84:	0009079b          	sext.w	a5,s2
    80004f88:	078e                	slli	a5,a5,0x3
    80004f8a:	fd078793          	addi	a5,a5,-48
    80004f8e:	97a2                	add	a5,a5,s0
    80004f90:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f94:	e5040593          	addi	a1,s0,-432
    80004f98:	f5040513          	addi	a0,s0,-176
    80004f9c:	fffff097          	auipc	ra,0xfffff
    80004fa0:	194080e7          	jalr	404(ra) # 80004130 <exec>
    80004fa4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa6:	f5040993          	addi	s3,s0,-176
    80004faa:	6088                	ld	a0,0(s1)
    80004fac:	c901                	beqz	a0,80004fbc <sys_exec+0xf2>
    kfree(argv[i]);
    80004fae:	ffffb097          	auipc	ra,0xffffb
    80004fb2:	06e080e7          	jalr	110(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb6:	04a1                	addi	s1,s1,8
    80004fb8:	ff3499e3          	bne	s1,s3,80004faa <sys_exec+0xe0>
  return ret;
    80004fbc:	854a                	mv	a0,s2
    80004fbe:	a011                	j	80004fc2 <sys_exec+0xf8>
  return -1;
    80004fc0:	557d                	li	a0,-1
}
    80004fc2:	70fa                	ld	ra,440(sp)
    80004fc4:	745a                	ld	s0,432(sp)
    80004fc6:	74ba                	ld	s1,424(sp)
    80004fc8:	791a                	ld	s2,416(sp)
    80004fca:	69fa                	ld	s3,408(sp)
    80004fcc:	6a5a                	ld	s4,400(sp)
    80004fce:	6139                	addi	sp,sp,448
    80004fd0:	8082                	ret

0000000080004fd2 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fd2:	7139                	addi	sp,sp,-64
    80004fd4:	fc06                	sd	ra,56(sp)
    80004fd6:	f822                	sd	s0,48(sp)
    80004fd8:	f426                	sd	s1,40(sp)
    80004fda:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fdc:	ffffc097          	auipc	ra,0xffffc
    80004fe0:	e76080e7          	jalr	-394(ra) # 80000e52 <myproc>
    80004fe4:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fe6:	fd840593          	addi	a1,s0,-40
    80004fea:	4501                	li	a0,0
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	f9a080e7          	jalr	-102(ra) # 80001f86 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004ff4:	fc840593          	addi	a1,s0,-56
    80004ff8:	fd040513          	addi	a0,s0,-48
    80004ffc:	fffff097          	auipc	ra,0xfffff
    80005000:	dea080e7          	jalr	-534(ra) # 80003de6 <pipealloc>
    return -1;
    80005004:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005006:	0c054463          	bltz	a0,800050ce <sys_pipe+0xfc>
  fd0 = -1;
    8000500a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000500e:	fd043503          	ld	a0,-48(s0)
    80005012:	fffff097          	auipc	ra,0xfffff
    80005016:	524080e7          	jalr	1316(ra) # 80004536 <fdalloc>
    8000501a:	fca42223          	sw	a0,-60(s0)
    8000501e:	08054b63          	bltz	a0,800050b4 <sys_pipe+0xe2>
    80005022:	fc843503          	ld	a0,-56(s0)
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	510080e7          	jalr	1296(ra) # 80004536 <fdalloc>
    8000502e:	fca42023          	sw	a0,-64(s0)
    80005032:	06054863          	bltz	a0,800050a2 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005036:	4691                	li	a3,4
    80005038:	fc440613          	addi	a2,s0,-60
    8000503c:	fd843583          	ld	a1,-40(s0)
    80005040:	68a8                	ld	a0,80(s1)
    80005042:	ffffc097          	auipc	ra,0xffffc
    80005046:	ad0080e7          	jalr	-1328(ra) # 80000b12 <copyout>
    8000504a:	02054063          	bltz	a0,8000506a <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000504e:	4691                	li	a3,4
    80005050:	fc040613          	addi	a2,s0,-64
    80005054:	fd843583          	ld	a1,-40(s0)
    80005058:	0591                	addi	a1,a1,4
    8000505a:	68a8                	ld	a0,80(s1)
    8000505c:	ffffc097          	auipc	ra,0xffffc
    80005060:	ab6080e7          	jalr	-1354(ra) # 80000b12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005064:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005066:	06055463          	bgez	a0,800050ce <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000506a:	fc442783          	lw	a5,-60(s0)
    8000506e:	07e9                	addi	a5,a5,26
    80005070:	078e                	slli	a5,a5,0x3
    80005072:	97a6                	add	a5,a5,s1
    80005074:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005078:	fc042783          	lw	a5,-64(s0)
    8000507c:	07e9                	addi	a5,a5,26
    8000507e:	078e                	slli	a5,a5,0x3
    80005080:	94be                	add	s1,s1,a5
    80005082:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005086:	fd043503          	ld	a0,-48(s0)
    8000508a:	fffff097          	auipc	ra,0xfffff
    8000508e:	a30080e7          	jalr	-1488(ra) # 80003aba <fileclose>
    fileclose(wf);
    80005092:	fc843503          	ld	a0,-56(s0)
    80005096:	fffff097          	auipc	ra,0xfffff
    8000509a:	a24080e7          	jalr	-1500(ra) # 80003aba <fileclose>
    return -1;
    8000509e:	57fd                	li	a5,-1
    800050a0:	a03d                	j	800050ce <sys_pipe+0xfc>
    if(fd0 >= 0)
    800050a2:	fc442783          	lw	a5,-60(s0)
    800050a6:	0007c763          	bltz	a5,800050b4 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800050aa:	07e9                	addi	a5,a5,26
    800050ac:	078e                	slli	a5,a5,0x3
    800050ae:	97a6                	add	a5,a5,s1
    800050b0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050b4:	fd043503          	ld	a0,-48(s0)
    800050b8:	fffff097          	auipc	ra,0xfffff
    800050bc:	a02080e7          	jalr	-1534(ra) # 80003aba <fileclose>
    fileclose(wf);
    800050c0:	fc843503          	ld	a0,-56(s0)
    800050c4:	fffff097          	auipc	ra,0xfffff
    800050c8:	9f6080e7          	jalr	-1546(ra) # 80003aba <fileclose>
    return -1;
    800050cc:	57fd                	li	a5,-1
}
    800050ce:	853e                	mv	a0,a5
    800050d0:	70e2                	ld	ra,56(sp)
    800050d2:	7442                	ld	s0,48(sp)
    800050d4:	74a2                	ld	s1,40(sp)
    800050d6:	6121                	addi	sp,sp,64
    800050d8:	8082                	ret
    800050da:	0000                	unimp
    800050dc:	0000                	unimp
	...

00000000800050e0 <kernelvec>:
    800050e0:	7111                	addi	sp,sp,-256
    800050e2:	e006                	sd	ra,0(sp)
    800050e4:	e40a                	sd	sp,8(sp)
    800050e6:	e80e                	sd	gp,16(sp)
    800050e8:	ec12                	sd	tp,24(sp)
    800050ea:	f016                	sd	t0,32(sp)
    800050ec:	f41a                	sd	t1,40(sp)
    800050ee:	f81e                	sd	t2,48(sp)
    800050f0:	fc22                	sd	s0,56(sp)
    800050f2:	e0a6                	sd	s1,64(sp)
    800050f4:	e4aa                	sd	a0,72(sp)
    800050f6:	e8ae                	sd	a1,80(sp)
    800050f8:	ecb2                	sd	a2,88(sp)
    800050fa:	f0b6                	sd	a3,96(sp)
    800050fc:	f4ba                	sd	a4,104(sp)
    800050fe:	f8be                	sd	a5,112(sp)
    80005100:	fcc2                	sd	a6,120(sp)
    80005102:	e146                	sd	a7,128(sp)
    80005104:	e54a                	sd	s2,136(sp)
    80005106:	e94e                	sd	s3,144(sp)
    80005108:	ed52                	sd	s4,152(sp)
    8000510a:	f156                	sd	s5,160(sp)
    8000510c:	f55a                	sd	s6,168(sp)
    8000510e:	f95e                	sd	s7,176(sp)
    80005110:	fd62                	sd	s8,184(sp)
    80005112:	e1e6                	sd	s9,192(sp)
    80005114:	e5ea                	sd	s10,200(sp)
    80005116:	e9ee                	sd	s11,208(sp)
    80005118:	edf2                	sd	t3,216(sp)
    8000511a:	f1f6                	sd	t4,224(sp)
    8000511c:	f5fa                	sd	t5,232(sp)
    8000511e:	f9fe                	sd	t6,240(sp)
    80005120:	c75fc0ef          	jal	ra,80001d94 <kerneltrap>
    80005124:	6082                	ld	ra,0(sp)
    80005126:	6122                	ld	sp,8(sp)
    80005128:	61c2                	ld	gp,16(sp)
    8000512a:	7282                	ld	t0,32(sp)
    8000512c:	7322                	ld	t1,40(sp)
    8000512e:	73c2                	ld	t2,48(sp)
    80005130:	7462                	ld	s0,56(sp)
    80005132:	6486                	ld	s1,64(sp)
    80005134:	6526                	ld	a0,72(sp)
    80005136:	65c6                	ld	a1,80(sp)
    80005138:	6666                	ld	a2,88(sp)
    8000513a:	7686                	ld	a3,96(sp)
    8000513c:	7726                	ld	a4,104(sp)
    8000513e:	77c6                	ld	a5,112(sp)
    80005140:	7866                	ld	a6,120(sp)
    80005142:	688a                	ld	a7,128(sp)
    80005144:	692a                	ld	s2,136(sp)
    80005146:	69ca                	ld	s3,144(sp)
    80005148:	6a6a                	ld	s4,152(sp)
    8000514a:	7a8a                	ld	s5,160(sp)
    8000514c:	7b2a                	ld	s6,168(sp)
    8000514e:	7bca                	ld	s7,176(sp)
    80005150:	7c6a                	ld	s8,184(sp)
    80005152:	6c8e                	ld	s9,192(sp)
    80005154:	6d2e                	ld	s10,200(sp)
    80005156:	6dce                	ld	s11,208(sp)
    80005158:	6e6e                	ld	t3,216(sp)
    8000515a:	7e8e                	ld	t4,224(sp)
    8000515c:	7f2e                	ld	t5,232(sp)
    8000515e:	7fce                	ld	t6,240(sp)
    80005160:	6111                	addi	sp,sp,256
    80005162:	10200073          	sret
    80005166:	00000013          	nop
    8000516a:	00000013          	nop
    8000516e:	0001                	nop

0000000080005170 <timervec>:
    80005170:	34051573          	csrrw	a0,mscratch,a0
    80005174:	e10c                	sd	a1,0(a0)
    80005176:	e510                	sd	a2,8(a0)
    80005178:	e914                	sd	a3,16(a0)
    8000517a:	6d0c                	ld	a1,24(a0)
    8000517c:	7110                	ld	a2,32(a0)
    8000517e:	6194                	ld	a3,0(a1)
    80005180:	96b2                	add	a3,a3,a2
    80005182:	e194                	sd	a3,0(a1)
    80005184:	4589                	li	a1,2
    80005186:	14459073          	csrw	sip,a1
    8000518a:	6914                	ld	a3,16(a0)
    8000518c:	6510                	ld	a2,8(a0)
    8000518e:	610c                	ld	a1,0(a0)
    80005190:	34051573          	csrrw	a0,mscratch,a0
    80005194:	30200073          	mret
	...

000000008000519a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000519a:	1141                	addi	sp,sp,-16
    8000519c:	e422                	sd	s0,8(sp)
    8000519e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051a0:	0c0007b7          	lui	a5,0xc000
    800051a4:	4705                	li	a4,1
    800051a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051a8:	c3d8                	sw	a4,4(a5)
}
    800051aa:	6422                	ld	s0,8(sp)
    800051ac:	0141                	addi	sp,sp,16
    800051ae:	8082                	ret

00000000800051b0 <plicinithart>:

void
plicinithart(void)
{
    800051b0:	1141                	addi	sp,sp,-16
    800051b2:	e406                	sd	ra,8(sp)
    800051b4:	e022                	sd	s0,0(sp)
    800051b6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	c6e080e7          	jalr	-914(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051c0:	0085171b          	slliw	a4,a0,0x8
    800051c4:	0c0027b7          	lui	a5,0xc002
    800051c8:	97ba                	add	a5,a5,a4
    800051ca:	40200713          	li	a4,1026
    800051ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051d2:	00d5151b          	slliw	a0,a0,0xd
    800051d6:	0c2017b7          	lui	a5,0xc201
    800051da:	97aa                	add	a5,a5,a0
    800051dc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051e0:	60a2                	ld	ra,8(sp)
    800051e2:	6402                	ld	s0,0(sp)
    800051e4:	0141                	addi	sp,sp,16
    800051e6:	8082                	ret

00000000800051e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051e8:	1141                	addi	sp,sp,-16
    800051ea:	e406                	sd	ra,8(sp)
    800051ec:	e022                	sd	s0,0(sp)
    800051ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051f0:	ffffc097          	auipc	ra,0xffffc
    800051f4:	c36080e7          	jalr	-970(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051f8:	00d5151b          	slliw	a0,a0,0xd
    800051fc:	0c2017b7          	lui	a5,0xc201
    80005200:	97aa                	add	a5,a5,a0
  return irq;
}
    80005202:	43c8                	lw	a0,4(a5)
    80005204:	60a2                	ld	ra,8(sp)
    80005206:	6402                	ld	s0,0(sp)
    80005208:	0141                	addi	sp,sp,16
    8000520a:	8082                	ret

000000008000520c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000520c:	1101                	addi	sp,sp,-32
    8000520e:	ec06                	sd	ra,24(sp)
    80005210:	e822                	sd	s0,16(sp)
    80005212:	e426                	sd	s1,8(sp)
    80005214:	1000                	addi	s0,sp,32
    80005216:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005218:	ffffc097          	auipc	ra,0xffffc
    8000521c:	c0e080e7          	jalr	-1010(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005220:	00d5151b          	slliw	a0,a0,0xd
    80005224:	0c2017b7          	lui	a5,0xc201
    80005228:	97aa                	add	a5,a5,a0
    8000522a:	c3c4                	sw	s1,4(a5)
}
    8000522c:	60e2                	ld	ra,24(sp)
    8000522e:	6442                	ld	s0,16(sp)
    80005230:	64a2                	ld	s1,8(sp)
    80005232:	6105                	addi	sp,sp,32
    80005234:	8082                	ret

0000000080005236 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005236:	1141                	addi	sp,sp,-16
    80005238:	e406                	sd	ra,8(sp)
    8000523a:	e022                	sd	s0,0(sp)
    8000523c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000523e:	479d                	li	a5,7
    80005240:	04a7cc63          	blt	a5,a0,80005298 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005244:	00010797          	auipc	a5,0x10
    80005248:	b7c78793          	addi	a5,a5,-1156 # 80014dc0 <disk>
    8000524c:	97aa                	add	a5,a5,a0
    8000524e:	0187c783          	lbu	a5,24(a5)
    80005252:	ebb9                	bnez	a5,800052a8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005254:	00451693          	slli	a3,a0,0x4
    80005258:	00010797          	auipc	a5,0x10
    8000525c:	b6878793          	addi	a5,a5,-1176 # 80014dc0 <disk>
    80005260:	6398                	ld	a4,0(a5)
    80005262:	9736                	add	a4,a4,a3
    80005264:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005268:	6398                	ld	a4,0(a5)
    8000526a:	9736                	add	a4,a4,a3
    8000526c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005270:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005274:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005278:	97aa                	add	a5,a5,a0
    8000527a:	4705                	li	a4,1
    8000527c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005280:	00010517          	auipc	a0,0x10
    80005284:	b5850513          	addi	a0,a0,-1192 # 80014dd8 <disk+0x18>
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	2d6080e7          	jalr	726(ra) # 8000155e <wakeup>
}
    80005290:	60a2                	ld	ra,8(sp)
    80005292:	6402                	ld	s0,0(sp)
    80005294:	0141                	addi	sp,sp,16
    80005296:	8082                	ret
    panic("free_desc 1");
    80005298:	00003517          	auipc	a0,0x3
    8000529c:	42850513          	addi	a0,a0,1064 # 800086c0 <syscalls+0x2f0>
    800052a0:	00001097          	auipc	ra,0x1
    800052a4:	a06080e7          	jalr	-1530(ra) # 80005ca6 <panic>
    panic("free_desc 2");
    800052a8:	00003517          	auipc	a0,0x3
    800052ac:	42850513          	addi	a0,a0,1064 # 800086d0 <syscalls+0x300>
    800052b0:	00001097          	auipc	ra,0x1
    800052b4:	9f6080e7          	jalr	-1546(ra) # 80005ca6 <panic>

00000000800052b8 <virtio_disk_init>:
{
    800052b8:	1101                	addi	sp,sp,-32
    800052ba:	ec06                	sd	ra,24(sp)
    800052bc:	e822                	sd	s0,16(sp)
    800052be:	e426                	sd	s1,8(sp)
    800052c0:	e04a                	sd	s2,0(sp)
    800052c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052c4:	00003597          	auipc	a1,0x3
    800052c8:	41c58593          	addi	a1,a1,1052 # 800086e0 <syscalls+0x310>
    800052cc:	00010517          	auipc	a0,0x10
    800052d0:	c1c50513          	addi	a0,a0,-996 # 80014ee8 <disk+0x128>
    800052d4:	00001097          	auipc	ra,0x1
    800052d8:	e7a080e7          	jalr	-390(ra) # 8000614e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052dc:	100017b7          	lui	a5,0x10001
    800052e0:	4398                	lw	a4,0(a5)
    800052e2:	2701                	sext.w	a4,a4
    800052e4:	747277b7          	lui	a5,0x74727
    800052e8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052ec:	14f71b63          	bne	a4,a5,80005442 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052f0:	100017b7          	lui	a5,0x10001
    800052f4:	43dc                	lw	a5,4(a5)
    800052f6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052f8:	4709                	li	a4,2
    800052fa:	14e79463          	bne	a5,a4,80005442 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052fe:	100017b7          	lui	a5,0x10001
    80005302:	479c                	lw	a5,8(a5)
    80005304:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005306:	12e79e63          	bne	a5,a4,80005442 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000530a:	100017b7          	lui	a5,0x10001
    8000530e:	47d8                	lw	a4,12(a5)
    80005310:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005312:	554d47b7          	lui	a5,0x554d4
    80005316:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000531a:	12f71463          	bne	a4,a5,80005442 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531e:	100017b7          	lui	a5,0x10001
    80005322:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005326:	4705                	li	a4,1
    80005328:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000532a:	470d                	li	a4,3
    8000532c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000532e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005330:	c7ffe6b7          	lui	a3,0xc7ffe
    80005334:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fe161f>
    80005338:	8f75                	and	a4,a4,a3
    8000533a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000533c:	472d                	li	a4,11
    8000533e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005340:	5bbc                	lw	a5,112(a5)
    80005342:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005346:	8ba1                	andi	a5,a5,8
    80005348:	10078563          	beqz	a5,80005452 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000534c:	100017b7          	lui	a5,0x10001
    80005350:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005354:	43fc                	lw	a5,68(a5)
    80005356:	2781                	sext.w	a5,a5
    80005358:	10079563          	bnez	a5,80005462 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000535c:	100017b7          	lui	a5,0x10001
    80005360:	5bdc                	lw	a5,52(a5)
    80005362:	2781                	sext.w	a5,a5
  if(max == 0)
    80005364:	10078763          	beqz	a5,80005472 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005368:	471d                	li	a4,7
    8000536a:	10f77c63          	bgeu	a4,a5,80005482 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000536e:	ffffb097          	auipc	ra,0xffffb
    80005372:	dac080e7          	jalr	-596(ra) # 8000011a <kalloc>
    80005376:	00010497          	auipc	s1,0x10
    8000537a:	a4a48493          	addi	s1,s1,-1462 # 80014dc0 <disk>
    8000537e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005380:	ffffb097          	auipc	ra,0xffffb
    80005384:	d9a080e7          	jalr	-614(ra) # 8000011a <kalloc>
    80005388:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000538a:	ffffb097          	auipc	ra,0xffffb
    8000538e:	d90080e7          	jalr	-624(ra) # 8000011a <kalloc>
    80005392:	87aa                	mv	a5,a0
    80005394:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005396:	6088                	ld	a0,0(s1)
    80005398:	cd6d                	beqz	a0,80005492 <virtio_disk_init+0x1da>
    8000539a:	00010717          	auipc	a4,0x10
    8000539e:	a2e73703          	ld	a4,-1490(a4) # 80014dc8 <disk+0x8>
    800053a2:	cb65                	beqz	a4,80005492 <virtio_disk_init+0x1da>
    800053a4:	c7fd                	beqz	a5,80005492 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800053a6:	6605                	lui	a2,0x1
    800053a8:	4581                	li	a1,0
    800053aa:	ffffb097          	auipc	ra,0xffffb
    800053ae:	dd0080e7          	jalr	-560(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800053b2:	00010497          	auipc	s1,0x10
    800053b6:	a0e48493          	addi	s1,s1,-1522 # 80014dc0 <disk>
    800053ba:	6605                	lui	a2,0x1
    800053bc:	4581                	li	a1,0
    800053be:	6488                	ld	a0,8(s1)
    800053c0:	ffffb097          	auipc	ra,0xffffb
    800053c4:	dba080e7          	jalr	-582(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800053c8:	6605                	lui	a2,0x1
    800053ca:	4581                	li	a1,0
    800053cc:	6888                	ld	a0,16(s1)
    800053ce:	ffffb097          	auipc	ra,0xffffb
    800053d2:	dac080e7          	jalr	-596(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053d6:	100017b7          	lui	a5,0x10001
    800053da:	4721                	li	a4,8
    800053dc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053de:	4098                	lw	a4,0(s1)
    800053e0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053e4:	40d8                	lw	a4,4(s1)
    800053e6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053ea:	6498                	ld	a4,8(s1)
    800053ec:	0007069b          	sext.w	a3,a4
    800053f0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053f4:	9701                	srai	a4,a4,0x20
    800053f6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053fa:	6898                	ld	a4,16(s1)
    800053fc:	0007069b          	sext.w	a3,a4
    80005400:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005404:	9701                	srai	a4,a4,0x20
    80005406:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000540a:	4705                	li	a4,1
    8000540c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000540e:	00e48c23          	sb	a4,24(s1)
    80005412:	00e48ca3          	sb	a4,25(s1)
    80005416:	00e48d23          	sb	a4,26(s1)
    8000541a:	00e48da3          	sb	a4,27(s1)
    8000541e:	00e48e23          	sb	a4,28(s1)
    80005422:	00e48ea3          	sb	a4,29(s1)
    80005426:	00e48f23          	sb	a4,30(s1)
    8000542a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000542e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005432:	0727a823          	sw	s2,112(a5)
}
    80005436:	60e2                	ld	ra,24(sp)
    80005438:	6442                	ld	s0,16(sp)
    8000543a:	64a2                	ld	s1,8(sp)
    8000543c:	6902                	ld	s2,0(sp)
    8000543e:	6105                	addi	sp,sp,32
    80005440:	8082                	ret
    panic("could not find virtio disk");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	2ae50513          	addi	a0,a0,686 # 800086f0 <syscalls+0x320>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	85c080e7          	jalr	-1956(ra) # 80005ca6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005452:	00003517          	auipc	a0,0x3
    80005456:	2be50513          	addi	a0,a0,702 # 80008710 <syscalls+0x340>
    8000545a:	00001097          	auipc	ra,0x1
    8000545e:	84c080e7          	jalr	-1972(ra) # 80005ca6 <panic>
    panic("virtio disk should not be ready");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	2ce50513          	addi	a0,a0,718 # 80008730 <syscalls+0x360>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	83c080e7          	jalr	-1988(ra) # 80005ca6 <panic>
    panic("virtio disk has no queue 0");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	2de50513          	addi	a0,a0,734 # 80008750 <syscalls+0x380>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	82c080e7          	jalr	-2004(ra) # 80005ca6 <panic>
    panic("virtio disk max queue too short");
    80005482:	00003517          	auipc	a0,0x3
    80005486:	2ee50513          	addi	a0,a0,750 # 80008770 <syscalls+0x3a0>
    8000548a:	00001097          	auipc	ra,0x1
    8000548e:	81c080e7          	jalr	-2020(ra) # 80005ca6 <panic>
    panic("virtio disk kalloc");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	2fe50513          	addi	a0,a0,766 # 80008790 <syscalls+0x3c0>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	80c080e7          	jalr	-2036(ra) # 80005ca6 <panic>

00000000800054a2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054a2:	7159                	addi	sp,sp,-112
    800054a4:	f486                	sd	ra,104(sp)
    800054a6:	f0a2                	sd	s0,96(sp)
    800054a8:	eca6                	sd	s1,88(sp)
    800054aa:	e8ca                	sd	s2,80(sp)
    800054ac:	e4ce                	sd	s3,72(sp)
    800054ae:	e0d2                	sd	s4,64(sp)
    800054b0:	fc56                	sd	s5,56(sp)
    800054b2:	f85a                	sd	s6,48(sp)
    800054b4:	f45e                	sd	s7,40(sp)
    800054b6:	f062                	sd	s8,32(sp)
    800054b8:	ec66                	sd	s9,24(sp)
    800054ba:	e86a                	sd	s10,16(sp)
    800054bc:	1880                	addi	s0,sp,112
    800054be:	8a2a                	mv	s4,a0
    800054c0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054c2:	00c52c83          	lw	s9,12(a0)
    800054c6:	001c9c9b          	slliw	s9,s9,0x1
    800054ca:	1c82                	slli	s9,s9,0x20
    800054cc:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054d0:	00010517          	auipc	a0,0x10
    800054d4:	a1850513          	addi	a0,a0,-1512 # 80014ee8 <disk+0x128>
    800054d8:	00001097          	auipc	ra,0x1
    800054dc:	d06080e7          	jalr	-762(ra) # 800061de <acquire>
  for(int i = 0; i < 3; i++){
    800054e0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800054e2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054e4:	00010b17          	auipc	s6,0x10
    800054e8:	8dcb0b13          	addi	s6,s6,-1828 # 80014dc0 <disk>
  for(int i = 0; i < 3; i++){
    800054ec:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054ee:	00010c17          	auipc	s8,0x10
    800054f2:	9fac0c13          	addi	s8,s8,-1542 # 80014ee8 <disk+0x128>
    800054f6:	a095                	j	8000555a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054f8:	00fb0733          	add	a4,s6,a5
    800054fc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005500:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005502:	0207c563          	bltz	a5,8000552c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005506:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005508:	0591                	addi	a1,a1,4
    8000550a:	05560d63          	beq	a2,s5,80005564 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000550e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005510:	00010717          	auipc	a4,0x10
    80005514:	8b070713          	addi	a4,a4,-1872 # 80014dc0 <disk>
    80005518:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000551a:	01874683          	lbu	a3,24(a4)
    8000551e:	fee9                	bnez	a3,800054f8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005520:	2785                	addiw	a5,a5,1
    80005522:	0705                	addi	a4,a4,1
    80005524:	fe979be3          	bne	a5,s1,8000551a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005528:	57fd                	li	a5,-1
    8000552a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000552c:	00c05e63          	blez	a2,80005548 <virtio_disk_rw+0xa6>
    80005530:	060a                	slli	a2,a2,0x2
    80005532:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005536:	0009a503          	lw	a0,0(s3)
    8000553a:	00000097          	auipc	ra,0x0
    8000553e:	cfc080e7          	jalr	-772(ra) # 80005236 <free_desc>
      for(int j = 0; j < i; j++)
    80005542:	0991                	addi	s3,s3,4
    80005544:	ffa999e3          	bne	s3,s10,80005536 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005548:	85e2                	mv	a1,s8
    8000554a:	00010517          	auipc	a0,0x10
    8000554e:	88e50513          	addi	a0,a0,-1906 # 80014dd8 <disk+0x18>
    80005552:	ffffc097          	auipc	ra,0xffffc
    80005556:	fa8080e7          	jalr	-88(ra) # 800014fa <sleep>
  for(int i = 0; i < 3; i++){
    8000555a:	f9040993          	addi	s3,s0,-112
{
    8000555e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005560:	864a                	mv	a2,s2
    80005562:	b775                	j	8000550e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005564:	f9042503          	lw	a0,-112(s0)
    80005568:	00a50713          	addi	a4,a0,10
    8000556c:	0712                	slli	a4,a4,0x4

  if(write)
    8000556e:	00010797          	auipc	a5,0x10
    80005572:	85278793          	addi	a5,a5,-1966 # 80014dc0 <disk>
    80005576:	00e786b3          	add	a3,a5,a4
    8000557a:	01703633          	snez	a2,s7
    8000557e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005580:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005584:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005588:	f6070613          	addi	a2,a4,-160
    8000558c:	6394                	ld	a3,0(a5)
    8000558e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005590:	00870593          	addi	a1,a4,8
    80005594:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005596:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005598:	0007b803          	ld	a6,0(a5)
    8000559c:	9642                	add	a2,a2,a6
    8000559e:	46c1                	li	a3,16
    800055a0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055a2:	4585                	li	a1,1
    800055a4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800055a8:	f9442683          	lw	a3,-108(s0)
    800055ac:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055b0:	0692                	slli	a3,a3,0x4
    800055b2:	9836                	add	a6,a6,a3
    800055b4:	058a0613          	addi	a2,s4,88
    800055b8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800055bc:	0007b803          	ld	a6,0(a5)
    800055c0:	96c2                	add	a3,a3,a6
    800055c2:	40000613          	li	a2,1024
    800055c6:	c690                	sw	a2,8(a3)
  if(write)
    800055c8:	001bb613          	seqz	a2,s7
    800055cc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055d0:	00166613          	ori	a2,a2,1
    800055d4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055d8:	f9842603          	lw	a2,-104(s0)
    800055dc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055e0:	00250693          	addi	a3,a0,2
    800055e4:	0692                	slli	a3,a3,0x4
    800055e6:	96be                	add	a3,a3,a5
    800055e8:	58fd                	li	a7,-1
    800055ea:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055ee:	0612                	slli	a2,a2,0x4
    800055f0:	9832                	add	a6,a6,a2
    800055f2:	f9070713          	addi	a4,a4,-112
    800055f6:	973e                	add	a4,a4,a5
    800055f8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055fc:	6398                	ld	a4,0(a5)
    800055fe:	9732                	add	a4,a4,a2
    80005600:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005602:	4609                	li	a2,2
    80005604:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005608:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000560c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005610:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005614:	6794                	ld	a3,8(a5)
    80005616:	0026d703          	lhu	a4,2(a3)
    8000561a:	8b1d                	andi	a4,a4,7
    8000561c:	0706                	slli	a4,a4,0x1
    8000561e:	96ba                	add	a3,a3,a4
    80005620:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005624:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005628:	6798                	ld	a4,8(a5)
    8000562a:	00275783          	lhu	a5,2(a4)
    8000562e:	2785                	addiw	a5,a5,1
    80005630:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005634:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005638:	100017b7          	lui	a5,0x10001
    8000563c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005640:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005644:	00010917          	auipc	s2,0x10
    80005648:	8a490913          	addi	s2,s2,-1884 # 80014ee8 <disk+0x128>
  while(b->disk == 1) {
    8000564c:	4485                	li	s1,1
    8000564e:	00b79c63          	bne	a5,a1,80005666 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005652:	85ca                	mv	a1,s2
    80005654:	8552                	mv	a0,s4
    80005656:	ffffc097          	auipc	ra,0xffffc
    8000565a:	ea4080e7          	jalr	-348(ra) # 800014fa <sleep>
  while(b->disk == 1) {
    8000565e:	004a2783          	lw	a5,4(s4)
    80005662:	fe9788e3          	beq	a5,s1,80005652 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005666:	f9042903          	lw	s2,-112(s0)
    8000566a:	00290713          	addi	a4,s2,2
    8000566e:	0712                	slli	a4,a4,0x4
    80005670:	0000f797          	auipc	a5,0xf
    80005674:	75078793          	addi	a5,a5,1872 # 80014dc0 <disk>
    80005678:	97ba                	add	a5,a5,a4
    8000567a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000567e:	0000f997          	auipc	s3,0xf
    80005682:	74298993          	addi	s3,s3,1858 # 80014dc0 <disk>
    80005686:	00491713          	slli	a4,s2,0x4
    8000568a:	0009b783          	ld	a5,0(s3)
    8000568e:	97ba                	add	a5,a5,a4
    80005690:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005694:	854a                	mv	a0,s2
    80005696:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000569a:	00000097          	auipc	ra,0x0
    8000569e:	b9c080e7          	jalr	-1124(ra) # 80005236 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056a2:	8885                	andi	s1,s1,1
    800056a4:	f0ed                	bnez	s1,80005686 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056a6:	00010517          	auipc	a0,0x10
    800056aa:	84250513          	addi	a0,a0,-1982 # 80014ee8 <disk+0x128>
    800056ae:	00001097          	auipc	ra,0x1
    800056b2:	be4080e7          	jalr	-1052(ra) # 80006292 <release>
}
    800056b6:	70a6                	ld	ra,104(sp)
    800056b8:	7406                	ld	s0,96(sp)
    800056ba:	64e6                	ld	s1,88(sp)
    800056bc:	6946                	ld	s2,80(sp)
    800056be:	69a6                	ld	s3,72(sp)
    800056c0:	6a06                	ld	s4,64(sp)
    800056c2:	7ae2                	ld	s5,56(sp)
    800056c4:	7b42                	ld	s6,48(sp)
    800056c6:	7ba2                	ld	s7,40(sp)
    800056c8:	7c02                	ld	s8,32(sp)
    800056ca:	6ce2                	ld	s9,24(sp)
    800056cc:	6d42                	ld	s10,16(sp)
    800056ce:	6165                	addi	sp,sp,112
    800056d0:	8082                	ret

00000000800056d2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056d2:	1101                	addi	sp,sp,-32
    800056d4:	ec06                	sd	ra,24(sp)
    800056d6:	e822                	sd	s0,16(sp)
    800056d8:	e426                	sd	s1,8(sp)
    800056da:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056dc:	0000f497          	auipc	s1,0xf
    800056e0:	6e448493          	addi	s1,s1,1764 # 80014dc0 <disk>
    800056e4:	00010517          	auipc	a0,0x10
    800056e8:	80450513          	addi	a0,a0,-2044 # 80014ee8 <disk+0x128>
    800056ec:	00001097          	auipc	ra,0x1
    800056f0:	af2080e7          	jalr	-1294(ra) # 800061de <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056f4:	10001737          	lui	a4,0x10001
    800056f8:	533c                	lw	a5,96(a4)
    800056fa:	8b8d                	andi	a5,a5,3
    800056fc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056fe:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005702:	689c                	ld	a5,16(s1)
    80005704:	0204d703          	lhu	a4,32(s1)
    80005708:	0027d783          	lhu	a5,2(a5)
    8000570c:	04f70863          	beq	a4,a5,8000575c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005710:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005714:	6898                	ld	a4,16(s1)
    80005716:	0204d783          	lhu	a5,32(s1)
    8000571a:	8b9d                	andi	a5,a5,7
    8000571c:	078e                	slli	a5,a5,0x3
    8000571e:	97ba                	add	a5,a5,a4
    80005720:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005722:	00278713          	addi	a4,a5,2
    80005726:	0712                	slli	a4,a4,0x4
    80005728:	9726                	add	a4,a4,s1
    8000572a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000572e:	e721                	bnez	a4,80005776 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005730:	0789                	addi	a5,a5,2
    80005732:	0792                	slli	a5,a5,0x4
    80005734:	97a6                	add	a5,a5,s1
    80005736:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005738:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000573c:	ffffc097          	auipc	ra,0xffffc
    80005740:	e22080e7          	jalr	-478(ra) # 8000155e <wakeup>

    disk.used_idx += 1;
    80005744:	0204d783          	lhu	a5,32(s1)
    80005748:	2785                	addiw	a5,a5,1
    8000574a:	17c2                	slli	a5,a5,0x30
    8000574c:	93c1                	srli	a5,a5,0x30
    8000574e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005752:	6898                	ld	a4,16(s1)
    80005754:	00275703          	lhu	a4,2(a4)
    80005758:	faf71ce3          	bne	a4,a5,80005710 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000575c:	0000f517          	auipc	a0,0xf
    80005760:	78c50513          	addi	a0,a0,1932 # 80014ee8 <disk+0x128>
    80005764:	00001097          	auipc	ra,0x1
    80005768:	b2e080e7          	jalr	-1234(ra) # 80006292 <release>
}
    8000576c:	60e2                	ld	ra,24(sp)
    8000576e:	6442                	ld	s0,16(sp)
    80005770:	64a2                	ld	s1,8(sp)
    80005772:	6105                	addi	sp,sp,32
    80005774:	8082                	ret
      panic("virtio_disk_intr status");
    80005776:	00003517          	auipc	a0,0x3
    8000577a:	03250513          	addi	a0,a0,50 # 800087a8 <syscalls+0x3d8>
    8000577e:	00000097          	auipc	ra,0x0
    80005782:	528080e7          	jalr	1320(ra) # 80005ca6 <panic>

0000000080005786 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005786:	1141                	addi	sp,sp,-16
    80005788:	e422                	sd	s0,8(sp)
    8000578a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000578c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005790:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005794:	0037979b          	slliw	a5,a5,0x3
    80005798:	02004737          	lui	a4,0x2004
    8000579c:	97ba                	add	a5,a5,a4
    8000579e:	0200c737          	lui	a4,0x200c
    800057a2:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057a6:	000f4637          	lui	a2,0xf4
    800057aa:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057ae:	9732                	add	a4,a4,a2
    800057b0:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057b2:	00259693          	slli	a3,a1,0x2
    800057b6:	96ae                	add	a3,a3,a1
    800057b8:	068e                	slli	a3,a3,0x3
    800057ba:	0000f717          	auipc	a4,0xf
    800057be:	74670713          	addi	a4,a4,1862 # 80014f00 <timer_scratch>
    800057c2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057c4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057c6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057c8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057cc:	00000797          	auipc	a5,0x0
    800057d0:	9a478793          	addi	a5,a5,-1628 # 80005170 <timervec>
    800057d4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057d8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057dc:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057e0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057e4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057e8:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057ec:	30479073          	csrw	mie,a5
}
    800057f0:	6422                	ld	s0,8(sp)
    800057f2:	0141                	addi	sp,sp,16
    800057f4:	8082                	ret

00000000800057f6 <start>:
{
    800057f6:	1141                	addi	sp,sp,-16
    800057f8:	e406                	sd	ra,8(sp)
    800057fa:	e022                	sd	s0,0(sp)
    800057fc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057fe:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005802:	7779                	lui	a4,0xffffe
    80005804:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffe16bf>
    80005808:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000580a:	6705                	lui	a4,0x1
    8000580c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005810:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005812:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005816:	ffffb797          	auipc	a5,0xffffb
    8000581a:	b0878793          	addi	a5,a5,-1272 # 8000031e <main>
    8000581e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005822:	4781                	li	a5,0
    80005824:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005828:	67c1                	lui	a5,0x10
    8000582a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000582c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005830:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005834:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005838:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000583c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005840:	57fd                	li	a5,-1
    80005842:	83a9                	srli	a5,a5,0xa
    80005844:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005848:	47bd                	li	a5,15
    8000584a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000584e:	00000097          	auipc	ra,0x0
    80005852:	f38080e7          	jalr	-200(ra) # 80005786 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005856:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000585a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000585c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000585e:	30200073          	mret
}
    80005862:	60a2                	ld	ra,8(sp)
    80005864:	6402                	ld	s0,0(sp)
    80005866:	0141                	addi	sp,sp,16
    80005868:	8082                	ret

000000008000586a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000586a:	715d                	addi	sp,sp,-80
    8000586c:	e486                	sd	ra,72(sp)
    8000586e:	e0a2                	sd	s0,64(sp)
    80005870:	fc26                	sd	s1,56(sp)
    80005872:	f84a                	sd	s2,48(sp)
    80005874:	f44e                	sd	s3,40(sp)
    80005876:	f052                	sd	s4,32(sp)
    80005878:	ec56                	sd	s5,24(sp)
    8000587a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000587c:	04c05763          	blez	a2,800058ca <consolewrite+0x60>
    80005880:	8a2a                	mv	s4,a0
    80005882:	84ae                	mv	s1,a1
    80005884:	89b2                	mv	s3,a2
    80005886:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005888:	5afd                	li	s5,-1
    8000588a:	4685                	li	a3,1
    8000588c:	8626                	mv	a2,s1
    8000588e:	85d2                	mv	a1,s4
    80005890:	fbf40513          	addi	a0,s0,-65
    80005894:	ffffc097          	auipc	ra,0xffffc
    80005898:	0be080e7          	jalr	190(ra) # 80001952 <either_copyin>
    8000589c:	01550d63          	beq	a0,s5,800058b6 <consolewrite+0x4c>
      break;
    uartputc(c);
    800058a0:	fbf44503          	lbu	a0,-65(s0)
    800058a4:	00000097          	auipc	ra,0x0
    800058a8:	780080e7          	jalr	1920(ra) # 80006024 <uartputc>
  for(i = 0; i < n; i++){
    800058ac:	2905                	addiw	s2,s2,1
    800058ae:	0485                	addi	s1,s1,1
    800058b0:	fd299de3          	bne	s3,s2,8000588a <consolewrite+0x20>
    800058b4:	894e                	mv	s2,s3
  }

  return i;
}
    800058b6:	854a                	mv	a0,s2
    800058b8:	60a6                	ld	ra,72(sp)
    800058ba:	6406                	ld	s0,64(sp)
    800058bc:	74e2                	ld	s1,56(sp)
    800058be:	7942                	ld	s2,48(sp)
    800058c0:	79a2                	ld	s3,40(sp)
    800058c2:	7a02                	ld	s4,32(sp)
    800058c4:	6ae2                	ld	s5,24(sp)
    800058c6:	6161                	addi	sp,sp,80
    800058c8:	8082                	ret
  for(i = 0; i < n; i++){
    800058ca:	4901                	li	s2,0
    800058cc:	b7ed                	j	800058b6 <consolewrite+0x4c>

00000000800058ce <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058ce:	711d                	addi	sp,sp,-96
    800058d0:	ec86                	sd	ra,88(sp)
    800058d2:	e8a2                	sd	s0,80(sp)
    800058d4:	e4a6                	sd	s1,72(sp)
    800058d6:	e0ca                	sd	s2,64(sp)
    800058d8:	fc4e                	sd	s3,56(sp)
    800058da:	f852                	sd	s4,48(sp)
    800058dc:	f456                	sd	s5,40(sp)
    800058de:	f05a                	sd	s6,32(sp)
    800058e0:	ec5e                	sd	s7,24(sp)
    800058e2:	1080                	addi	s0,sp,96
    800058e4:	8aaa                	mv	s5,a0
    800058e6:	8a2e                	mv	s4,a1
    800058e8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058ea:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058ee:	00017517          	auipc	a0,0x17
    800058f2:	75250513          	addi	a0,a0,1874 # 8001d040 <cons>
    800058f6:	00001097          	auipc	ra,0x1
    800058fa:	8e8080e7          	jalr	-1816(ra) # 800061de <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058fe:	00017497          	auipc	s1,0x17
    80005902:	74248493          	addi	s1,s1,1858 # 8001d040 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005906:	00017917          	auipc	s2,0x17
    8000590a:	7d290913          	addi	s2,s2,2002 # 8001d0d8 <cons+0x98>
  while(n > 0){
    8000590e:	09305263          	blez	s3,80005992 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005912:	0984a783          	lw	a5,152(s1)
    80005916:	09c4a703          	lw	a4,156(s1)
    8000591a:	02f71763          	bne	a4,a5,80005948 <consoleread+0x7a>
      if(killed(myproc())){
    8000591e:	ffffb097          	auipc	ra,0xffffb
    80005922:	534080e7          	jalr	1332(ra) # 80000e52 <myproc>
    80005926:	ffffc097          	auipc	ra,0xffffc
    8000592a:	e76080e7          	jalr	-394(ra) # 8000179c <killed>
    8000592e:	ed2d                	bnez	a0,800059a8 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005930:	85a6                	mv	a1,s1
    80005932:	854a                	mv	a0,s2
    80005934:	ffffc097          	auipc	ra,0xffffc
    80005938:	bc6080e7          	jalr	-1082(ra) # 800014fa <sleep>
    while(cons.r == cons.w){
    8000593c:	0984a783          	lw	a5,152(s1)
    80005940:	09c4a703          	lw	a4,156(s1)
    80005944:	fcf70de3          	beq	a4,a5,8000591e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005948:	00017717          	auipc	a4,0x17
    8000594c:	6f870713          	addi	a4,a4,1784 # 8001d040 <cons>
    80005950:	0017869b          	addiw	a3,a5,1
    80005954:	08d72c23          	sw	a3,152(a4)
    80005958:	07f7f693          	andi	a3,a5,127
    8000595c:	9736                	add	a4,a4,a3
    8000595e:	01874703          	lbu	a4,24(a4)
    80005962:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005966:	4691                	li	a3,4
    80005968:	06db8463          	beq	s7,a3,800059d0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000596c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005970:	4685                	li	a3,1
    80005972:	faf40613          	addi	a2,s0,-81
    80005976:	85d2                	mv	a1,s4
    80005978:	8556                	mv	a0,s5
    8000597a:	ffffc097          	auipc	ra,0xffffc
    8000597e:	f82080e7          	jalr	-126(ra) # 800018fc <either_copyout>
    80005982:	57fd                	li	a5,-1
    80005984:	00f50763          	beq	a0,a5,80005992 <consoleread+0xc4>
      break;

    dst++;
    80005988:	0a05                	addi	s4,s4,1
    --n;
    8000598a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000598c:	47a9                	li	a5,10
    8000598e:	f8fb90e3          	bne	s7,a5,8000590e <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005992:	00017517          	auipc	a0,0x17
    80005996:	6ae50513          	addi	a0,a0,1710 # 8001d040 <cons>
    8000599a:	00001097          	auipc	ra,0x1
    8000599e:	8f8080e7          	jalr	-1800(ra) # 80006292 <release>

  return target - n;
    800059a2:	413b053b          	subw	a0,s6,s3
    800059a6:	a811                	j	800059ba <consoleread+0xec>
        release(&cons.lock);
    800059a8:	00017517          	auipc	a0,0x17
    800059ac:	69850513          	addi	a0,a0,1688 # 8001d040 <cons>
    800059b0:	00001097          	auipc	ra,0x1
    800059b4:	8e2080e7          	jalr	-1822(ra) # 80006292 <release>
        return -1;
    800059b8:	557d                	li	a0,-1
}
    800059ba:	60e6                	ld	ra,88(sp)
    800059bc:	6446                	ld	s0,80(sp)
    800059be:	64a6                	ld	s1,72(sp)
    800059c0:	6906                	ld	s2,64(sp)
    800059c2:	79e2                	ld	s3,56(sp)
    800059c4:	7a42                	ld	s4,48(sp)
    800059c6:	7aa2                	ld	s5,40(sp)
    800059c8:	7b02                	ld	s6,32(sp)
    800059ca:	6be2                	ld	s7,24(sp)
    800059cc:	6125                	addi	sp,sp,96
    800059ce:	8082                	ret
      if(n < target){
    800059d0:	0009871b          	sext.w	a4,s3
    800059d4:	fb677fe3          	bgeu	a4,s6,80005992 <consoleread+0xc4>
        cons.r--;
    800059d8:	00017717          	auipc	a4,0x17
    800059dc:	70f72023          	sw	a5,1792(a4) # 8001d0d8 <cons+0x98>
    800059e0:	bf4d                	j	80005992 <consoleread+0xc4>

00000000800059e2 <consputc>:
{
    800059e2:	1141                	addi	sp,sp,-16
    800059e4:	e406                	sd	ra,8(sp)
    800059e6:	e022                	sd	s0,0(sp)
    800059e8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059ea:	10000793          	li	a5,256
    800059ee:	00f50a63          	beq	a0,a5,80005a02 <consputc+0x20>
    uartputc_sync(c);
    800059f2:	00000097          	auipc	ra,0x0
    800059f6:	560080e7          	jalr	1376(ra) # 80005f52 <uartputc_sync>
}
    800059fa:	60a2                	ld	ra,8(sp)
    800059fc:	6402                	ld	s0,0(sp)
    800059fe:	0141                	addi	sp,sp,16
    80005a00:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a02:	4521                	li	a0,8
    80005a04:	00000097          	auipc	ra,0x0
    80005a08:	54e080e7          	jalr	1358(ra) # 80005f52 <uartputc_sync>
    80005a0c:	02000513          	li	a0,32
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	542080e7          	jalr	1346(ra) # 80005f52 <uartputc_sync>
    80005a18:	4521                	li	a0,8
    80005a1a:	00000097          	auipc	ra,0x0
    80005a1e:	538080e7          	jalr	1336(ra) # 80005f52 <uartputc_sync>
    80005a22:	bfe1                	j	800059fa <consputc+0x18>

0000000080005a24 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a24:	1101                	addi	sp,sp,-32
    80005a26:	ec06                	sd	ra,24(sp)
    80005a28:	e822                	sd	s0,16(sp)
    80005a2a:	e426                	sd	s1,8(sp)
    80005a2c:	e04a                	sd	s2,0(sp)
    80005a2e:	1000                	addi	s0,sp,32
    80005a30:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a32:	00017517          	auipc	a0,0x17
    80005a36:	60e50513          	addi	a0,a0,1550 # 8001d040 <cons>
    80005a3a:	00000097          	auipc	ra,0x0
    80005a3e:	7a4080e7          	jalr	1956(ra) # 800061de <acquire>

  switch(c){
    80005a42:	47d5                	li	a5,21
    80005a44:	0af48663          	beq	s1,a5,80005af0 <consoleintr+0xcc>
    80005a48:	0297ca63          	blt	a5,s1,80005a7c <consoleintr+0x58>
    80005a4c:	47a1                	li	a5,8
    80005a4e:	0ef48763          	beq	s1,a5,80005b3c <consoleintr+0x118>
    80005a52:	47c1                	li	a5,16
    80005a54:	10f49a63          	bne	s1,a5,80005b68 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a58:	ffffc097          	auipc	ra,0xffffc
    80005a5c:	f50080e7          	jalr	-176(ra) # 800019a8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a60:	00017517          	auipc	a0,0x17
    80005a64:	5e050513          	addi	a0,a0,1504 # 8001d040 <cons>
    80005a68:	00001097          	auipc	ra,0x1
    80005a6c:	82a080e7          	jalr	-2006(ra) # 80006292 <release>
}
    80005a70:	60e2                	ld	ra,24(sp)
    80005a72:	6442                	ld	s0,16(sp)
    80005a74:	64a2                	ld	s1,8(sp)
    80005a76:	6902                	ld	s2,0(sp)
    80005a78:	6105                	addi	sp,sp,32
    80005a7a:	8082                	ret
  switch(c){
    80005a7c:	07f00793          	li	a5,127
    80005a80:	0af48e63          	beq	s1,a5,80005b3c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a84:	00017717          	auipc	a4,0x17
    80005a88:	5bc70713          	addi	a4,a4,1468 # 8001d040 <cons>
    80005a8c:	0a072783          	lw	a5,160(a4)
    80005a90:	09872703          	lw	a4,152(a4)
    80005a94:	9f99                	subw	a5,a5,a4
    80005a96:	07f00713          	li	a4,127
    80005a9a:	fcf763e3          	bltu	a4,a5,80005a60 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a9e:	47b5                	li	a5,13
    80005aa0:	0cf48763          	beq	s1,a5,80005b6e <consoleintr+0x14a>
      consputc(c);
    80005aa4:	8526                	mv	a0,s1
    80005aa6:	00000097          	auipc	ra,0x0
    80005aaa:	f3c080e7          	jalr	-196(ra) # 800059e2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005aae:	00017797          	auipc	a5,0x17
    80005ab2:	59278793          	addi	a5,a5,1426 # 8001d040 <cons>
    80005ab6:	0a07a683          	lw	a3,160(a5)
    80005aba:	0016871b          	addiw	a4,a3,1
    80005abe:	0007061b          	sext.w	a2,a4
    80005ac2:	0ae7a023          	sw	a4,160(a5)
    80005ac6:	07f6f693          	andi	a3,a3,127
    80005aca:	97b6                	add	a5,a5,a3
    80005acc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005ad0:	47a9                	li	a5,10
    80005ad2:	0cf48563          	beq	s1,a5,80005b9c <consoleintr+0x178>
    80005ad6:	4791                	li	a5,4
    80005ad8:	0cf48263          	beq	s1,a5,80005b9c <consoleintr+0x178>
    80005adc:	00017797          	auipc	a5,0x17
    80005ae0:	5fc7a783          	lw	a5,1532(a5) # 8001d0d8 <cons+0x98>
    80005ae4:	9f1d                	subw	a4,a4,a5
    80005ae6:	08000793          	li	a5,128
    80005aea:	f6f71be3          	bne	a4,a5,80005a60 <consoleintr+0x3c>
    80005aee:	a07d                	j	80005b9c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005af0:	00017717          	auipc	a4,0x17
    80005af4:	55070713          	addi	a4,a4,1360 # 8001d040 <cons>
    80005af8:	0a072783          	lw	a5,160(a4)
    80005afc:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b00:	00017497          	auipc	s1,0x17
    80005b04:	54048493          	addi	s1,s1,1344 # 8001d040 <cons>
    while(cons.e != cons.w &&
    80005b08:	4929                	li	s2,10
    80005b0a:	f4f70be3          	beq	a4,a5,80005a60 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b0e:	37fd                	addiw	a5,a5,-1
    80005b10:	07f7f713          	andi	a4,a5,127
    80005b14:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b16:	01874703          	lbu	a4,24(a4)
    80005b1a:	f52703e3          	beq	a4,s2,80005a60 <consoleintr+0x3c>
      cons.e--;
    80005b1e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b22:	10000513          	li	a0,256
    80005b26:	00000097          	auipc	ra,0x0
    80005b2a:	ebc080e7          	jalr	-324(ra) # 800059e2 <consputc>
    while(cons.e != cons.w &&
    80005b2e:	0a04a783          	lw	a5,160(s1)
    80005b32:	09c4a703          	lw	a4,156(s1)
    80005b36:	fcf71ce3          	bne	a4,a5,80005b0e <consoleintr+0xea>
    80005b3a:	b71d                	j	80005a60 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b3c:	00017717          	auipc	a4,0x17
    80005b40:	50470713          	addi	a4,a4,1284 # 8001d040 <cons>
    80005b44:	0a072783          	lw	a5,160(a4)
    80005b48:	09c72703          	lw	a4,156(a4)
    80005b4c:	f0f70ae3          	beq	a4,a5,80005a60 <consoleintr+0x3c>
      cons.e--;
    80005b50:	37fd                	addiw	a5,a5,-1
    80005b52:	00017717          	auipc	a4,0x17
    80005b56:	58f72723          	sw	a5,1422(a4) # 8001d0e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b5a:	10000513          	li	a0,256
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	e84080e7          	jalr	-380(ra) # 800059e2 <consputc>
    80005b66:	bded                	j	80005a60 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b68:	ee048ce3          	beqz	s1,80005a60 <consoleintr+0x3c>
    80005b6c:	bf21                	j	80005a84 <consoleintr+0x60>
      consputc(c);
    80005b6e:	4529                	li	a0,10
    80005b70:	00000097          	auipc	ra,0x0
    80005b74:	e72080e7          	jalr	-398(ra) # 800059e2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b78:	00017797          	auipc	a5,0x17
    80005b7c:	4c878793          	addi	a5,a5,1224 # 8001d040 <cons>
    80005b80:	0a07a703          	lw	a4,160(a5)
    80005b84:	0017069b          	addiw	a3,a4,1
    80005b88:	0006861b          	sext.w	a2,a3
    80005b8c:	0ad7a023          	sw	a3,160(a5)
    80005b90:	07f77713          	andi	a4,a4,127
    80005b94:	97ba                	add	a5,a5,a4
    80005b96:	4729                	li	a4,10
    80005b98:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b9c:	00017797          	auipc	a5,0x17
    80005ba0:	54c7a023          	sw	a2,1344(a5) # 8001d0dc <cons+0x9c>
        wakeup(&cons.r);
    80005ba4:	00017517          	auipc	a0,0x17
    80005ba8:	53450513          	addi	a0,a0,1332 # 8001d0d8 <cons+0x98>
    80005bac:	ffffc097          	auipc	ra,0xffffc
    80005bb0:	9b2080e7          	jalr	-1614(ra) # 8000155e <wakeup>
    80005bb4:	b575                	j	80005a60 <consoleintr+0x3c>

0000000080005bb6 <consoleinit>:

void
consoleinit(void)
{
    80005bb6:	1141                	addi	sp,sp,-16
    80005bb8:	e406                	sd	ra,8(sp)
    80005bba:	e022                	sd	s0,0(sp)
    80005bbc:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bbe:	00003597          	auipc	a1,0x3
    80005bc2:	c0258593          	addi	a1,a1,-1022 # 800087c0 <syscalls+0x3f0>
    80005bc6:	00017517          	auipc	a0,0x17
    80005bca:	47a50513          	addi	a0,a0,1146 # 8001d040 <cons>
    80005bce:	00000097          	auipc	ra,0x0
    80005bd2:	580080e7          	jalr	1408(ra) # 8000614e <initlock>

  uartinit();
    80005bd6:	00000097          	auipc	ra,0x0
    80005bda:	32c080e7          	jalr	812(ra) # 80005f02 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bde:	0000e797          	auipc	a5,0xe
    80005be2:	18a78793          	addi	a5,a5,394 # 80013d68 <devsw>
    80005be6:	00000717          	auipc	a4,0x0
    80005bea:	ce870713          	addi	a4,a4,-792 # 800058ce <consoleread>
    80005bee:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bf0:	00000717          	auipc	a4,0x0
    80005bf4:	c7a70713          	addi	a4,a4,-902 # 8000586a <consolewrite>
    80005bf8:	ef98                	sd	a4,24(a5)
}
    80005bfa:	60a2                	ld	ra,8(sp)
    80005bfc:	6402                	ld	s0,0(sp)
    80005bfe:	0141                	addi	sp,sp,16
    80005c00:	8082                	ret

0000000080005c02 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c02:	7179                	addi	sp,sp,-48
    80005c04:	f406                	sd	ra,40(sp)
    80005c06:	f022                	sd	s0,32(sp)
    80005c08:	ec26                	sd	s1,24(sp)
    80005c0a:	e84a                	sd	s2,16(sp)
    80005c0c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c0e:	c219                	beqz	a2,80005c14 <printint+0x12>
    80005c10:	08054763          	bltz	a0,80005c9e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c14:	2501                	sext.w	a0,a0
    80005c16:	4881                	li	a7,0
    80005c18:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c1c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c1e:	2581                	sext.w	a1,a1
    80005c20:	00003617          	auipc	a2,0x3
    80005c24:	bd060613          	addi	a2,a2,-1072 # 800087f0 <digits>
    80005c28:	883a                	mv	a6,a4
    80005c2a:	2705                	addiw	a4,a4,1
    80005c2c:	02b577bb          	remuw	a5,a0,a1
    80005c30:	1782                	slli	a5,a5,0x20
    80005c32:	9381                	srli	a5,a5,0x20
    80005c34:	97b2                	add	a5,a5,a2
    80005c36:	0007c783          	lbu	a5,0(a5)
    80005c3a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c3e:	0005079b          	sext.w	a5,a0
    80005c42:	02b5553b          	divuw	a0,a0,a1
    80005c46:	0685                	addi	a3,a3,1
    80005c48:	feb7f0e3          	bgeu	a5,a1,80005c28 <printint+0x26>

  if(sign)
    80005c4c:	00088c63          	beqz	a7,80005c64 <printint+0x62>
    buf[i++] = '-';
    80005c50:	fe070793          	addi	a5,a4,-32
    80005c54:	00878733          	add	a4,a5,s0
    80005c58:	02d00793          	li	a5,45
    80005c5c:	fef70823          	sb	a5,-16(a4)
    80005c60:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c64:	02e05763          	blez	a4,80005c92 <printint+0x90>
    80005c68:	fd040793          	addi	a5,s0,-48
    80005c6c:	00e784b3          	add	s1,a5,a4
    80005c70:	fff78913          	addi	s2,a5,-1
    80005c74:	993a                	add	s2,s2,a4
    80005c76:	377d                	addiw	a4,a4,-1
    80005c78:	1702                	slli	a4,a4,0x20
    80005c7a:	9301                	srli	a4,a4,0x20
    80005c7c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c80:	fff4c503          	lbu	a0,-1(s1)
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	d5e080e7          	jalr	-674(ra) # 800059e2 <consputc>
  while(--i >= 0)
    80005c8c:	14fd                	addi	s1,s1,-1
    80005c8e:	ff2499e3          	bne	s1,s2,80005c80 <printint+0x7e>
}
    80005c92:	70a2                	ld	ra,40(sp)
    80005c94:	7402                	ld	s0,32(sp)
    80005c96:	64e2                	ld	s1,24(sp)
    80005c98:	6942                	ld	s2,16(sp)
    80005c9a:	6145                	addi	sp,sp,48
    80005c9c:	8082                	ret
    x = -xx;
    80005c9e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ca2:	4885                	li	a7,1
    x = -xx;
    80005ca4:	bf95                	j	80005c18 <printint+0x16>

0000000080005ca6 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ca6:	1101                	addi	sp,sp,-32
    80005ca8:	ec06                	sd	ra,24(sp)
    80005caa:	e822                	sd	s0,16(sp)
    80005cac:	e426                	sd	s1,8(sp)
    80005cae:	1000                	addi	s0,sp,32
    80005cb0:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cb2:	00017797          	auipc	a5,0x17
    80005cb6:	4407a723          	sw	zero,1102(a5) # 8001d100 <pr+0x18>
  printf("panic: ");
    80005cba:	00003517          	auipc	a0,0x3
    80005cbe:	b0e50513          	addi	a0,a0,-1266 # 800087c8 <syscalls+0x3f8>
    80005cc2:	00000097          	auipc	ra,0x0
    80005cc6:	02e080e7          	jalr	46(ra) # 80005cf0 <printf>
  printf(s);
    80005cca:	8526                	mv	a0,s1
    80005ccc:	00000097          	auipc	ra,0x0
    80005cd0:	024080e7          	jalr	36(ra) # 80005cf0 <printf>
  printf("\n");
    80005cd4:	00002517          	auipc	a0,0x2
    80005cd8:	37450513          	addi	a0,a0,884 # 80008048 <etext+0x48>
    80005cdc:	00000097          	auipc	ra,0x0
    80005ce0:	014080e7          	jalr	20(ra) # 80005cf0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ce4:	4785                	li	a5,1
    80005ce6:	00003717          	auipc	a4,0x3
    80005cea:	bcf72323          	sw	a5,-1082(a4) # 800088ac <panicked>
  for(;;)
    80005cee:	a001                	j	80005cee <panic+0x48>

0000000080005cf0 <printf>:
{
    80005cf0:	7131                	addi	sp,sp,-192
    80005cf2:	fc86                	sd	ra,120(sp)
    80005cf4:	f8a2                	sd	s0,112(sp)
    80005cf6:	f4a6                	sd	s1,104(sp)
    80005cf8:	f0ca                	sd	s2,96(sp)
    80005cfa:	ecce                	sd	s3,88(sp)
    80005cfc:	e8d2                	sd	s4,80(sp)
    80005cfe:	e4d6                	sd	s5,72(sp)
    80005d00:	e0da                	sd	s6,64(sp)
    80005d02:	fc5e                	sd	s7,56(sp)
    80005d04:	f862                	sd	s8,48(sp)
    80005d06:	f466                	sd	s9,40(sp)
    80005d08:	f06a                	sd	s10,32(sp)
    80005d0a:	ec6e                	sd	s11,24(sp)
    80005d0c:	0100                	addi	s0,sp,128
    80005d0e:	8a2a                	mv	s4,a0
    80005d10:	e40c                	sd	a1,8(s0)
    80005d12:	e810                	sd	a2,16(s0)
    80005d14:	ec14                	sd	a3,24(s0)
    80005d16:	f018                	sd	a4,32(s0)
    80005d18:	f41c                	sd	a5,40(s0)
    80005d1a:	03043823          	sd	a6,48(s0)
    80005d1e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d22:	00017d97          	auipc	s11,0x17
    80005d26:	3dedad83          	lw	s11,990(s11) # 8001d100 <pr+0x18>
  if(locking)
    80005d2a:	020d9b63          	bnez	s11,80005d60 <printf+0x70>
  if (fmt == 0)
    80005d2e:	040a0263          	beqz	s4,80005d72 <printf+0x82>
  va_start(ap, fmt);
    80005d32:	00840793          	addi	a5,s0,8
    80005d36:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d3a:	000a4503          	lbu	a0,0(s4)
    80005d3e:	14050f63          	beqz	a0,80005e9c <printf+0x1ac>
    80005d42:	4981                	li	s3,0
    if(c != '%'){
    80005d44:	02500a93          	li	s5,37
    switch(c){
    80005d48:	07000b93          	li	s7,112
  consputc('x');
    80005d4c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d4e:	00003b17          	auipc	s6,0x3
    80005d52:	aa2b0b13          	addi	s6,s6,-1374 # 800087f0 <digits>
    switch(c){
    80005d56:	07300c93          	li	s9,115
    80005d5a:	06400c13          	li	s8,100
    80005d5e:	a82d                	j	80005d98 <printf+0xa8>
    acquire(&pr.lock);
    80005d60:	00017517          	auipc	a0,0x17
    80005d64:	38850513          	addi	a0,a0,904 # 8001d0e8 <pr>
    80005d68:	00000097          	auipc	ra,0x0
    80005d6c:	476080e7          	jalr	1142(ra) # 800061de <acquire>
    80005d70:	bf7d                	j	80005d2e <printf+0x3e>
    panic("null fmt");
    80005d72:	00003517          	auipc	a0,0x3
    80005d76:	a6650513          	addi	a0,a0,-1434 # 800087d8 <syscalls+0x408>
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	f2c080e7          	jalr	-212(ra) # 80005ca6 <panic>
      consputc(c);
    80005d82:	00000097          	auipc	ra,0x0
    80005d86:	c60080e7          	jalr	-928(ra) # 800059e2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d8a:	2985                	addiw	s3,s3,1
    80005d8c:	013a07b3          	add	a5,s4,s3
    80005d90:	0007c503          	lbu	a0,0(a5)
    80005d94:	10050463          	beqz	a0,80005e9c <printf+0x1ac>
    if(c != '%'){
    80005d98:	ff5515e3          	bne	a0,s5,80005d82 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d9c:	2985                	addiw	s3,s3,1
    80005d9e:	013a07b3          	add	a5,s4,s3
    80005da2:	0007c783          	lbu	a5,0(a5)
    80005da6:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005daa:	cbed                	beqz	a5,80005e9c <printf+0x1ac>
    switch(c){
    80005dac:	05778a63          	beq	a5,s7,80005e00 <printf+0x110>
    80005db0:	02fbf663          	bgeu	s7,a5,80005ddc <printf+0xec>
    80005db4:	09978863          	beq	a5,s9,80005e44 <printf+0x154>
    80005db8:	07800713          	li	a4,120
    80005dbc:	0ce79563          	bne	a5,a4,80005e86 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005dc0:	f8843783          	ld	a5,-120(s0)
    80005dc4:	00878713          	addi	a4,a5,8
    80005dc8:	f8e43423          	sd	a4,-120(s0)
    80005dcc:	4605                	li	a2,1
    80005dce:	85ea                	mv	a1,s10
    80005dd0:	4388                	lw	a0,0(a5)
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	e30080e7          	jalr	-464(ra) # 80005c02 <printint>
      break;
    80005dda:	bf45                	j	80005d8a <printf+0x9a>
    switch(c){
    80005ddc:	09578f63          	beq	a5,s5,80005e7a <printf+0x18a>
    80005de0:	0b879363          	bne	a5,s8,80005e86 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005de4:	f8843783          	ld	a5,-120(s0)
    80005de8:	00878713          	addi	a4,a5,8
    80005dec:	f8e43423          	sd	a4,-120(s0)
    80005df0:	4605                	li	a2,1
    80005df2:	45a9                	li	a1,10
    80005df4:	4388                	lw	a0,0(a5)
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	e0c080e7          	jalr	-500(ra) # 80005c02 <printint>
      break;
    80005dfe:	b771                	j	80005d8a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e00:	f8843783          	ld	a5,-120(s0)
    80005e04:	00878713          	addi	a4,a5,8
    80005e08:	f8e43423          	sd	a4,-120(s0)
    80005e0c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e10:	03000513          	li	a0,48
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	bce080e7          	jalr	-1074(ra) # 800059e2 <consputc>
  consputc('x');
    80005e1c:	07800513          	li	a0,120
    80005e20:	00000097          	auipc	ra,0x0
    80005e24:	bc2080e7          	jalr	-1086(ra) # 800059e2 <consputc>
    80005e28:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e2a:	03c95793          	srli	a5,s2,0x3c
    80005e2e:	97da                	add	a5,a5,s6
    80005e30:	0007c503          	lbu	a0,0(a5)
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	bae080e7          	jalr	-1106(ra) # 800059e2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e3c:	0912                	slli	s2,s2,0x4
    80005e3e:	34fd                	addiw	s1,s1,-1
    80005e40:	f4ed                	bnez	s1,80005e2a <printf+0x13a>
    80005e42:	b7a1                	j	80005d8a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e44:	f8843783          	ld	a5,-120(s0)
    80005e48:	00878713          	addi	a4,a5,8
    80005e4c:	f8e43423          	sd	a4,-120(s0)
    80005e50:	6384                	ld	s1,0(a5)
    80005e52:	cc89                	beqz	s1,80005e6c <printf+0x17c>
      for(; *s; s++)
    80005e54:	0004c503          	lbu	a0,0(s1)
    80005e58:	d90d                	beqz	a0,80005d8a <printf+0x9a>
        consputc(*s);
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	b88080e7          	jalr	-1144(ra) # 800059e2 <consputc>
      for(; *s; s++)
    80005e62:	0485                	addi	s1,s1,1
    80005e64:	0004c503          	lbu	a0,0(s1)
    80005e68:	f96d                	bnez	a0,80005e5a <printf+0x16a>
    80005e6a:	b705                	j	80005d8a <printf+0x9a>
        s = "(null)";
    80005e6c:	00003497          	auipc	s1,0x3
    80005e70:	96448493          	addi	s1,s1,-1692 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005e74:	02800513          	li	a0,40
    80005e78:	b7cd                	j	80005e5a <printf+0x16a>
      consputc('%');
    80005e7a:	8556                	mv	a0,s5
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	b66080e7          	jalr	-1178(ra) # 800059e2 <consputc>
      break;
    80005e84:	b719                	j	80005d8a <printf+0x9a>
      consputc('%');
    80005e86:	8556                	mv	a0,s5
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	b5a080e7          	jalr	-1190(ra) # 800059e2 <consputc>
      consputc(c);
    80005e90:	8526                	mv	a0,s1
    80005e92:	00000097          	auipc	ra,0x0
    80005e96:	b50080e7          	jalr	-1200(ra) # 800059e2 <consputc>
      break;
    80005e9a:	bdc5                	j	80005d8a <printf+0x9a>
  if(locking)
    80005e9c:	020d9163          	bnez	s11,80005ebe <printf+0x1ce>
}
    80005ea0:	70e6                	ld	ra,120(sp)
    80005ea2:	7446                	ld	s0,112(sp)
    80005ea4:	74a6                	ld	s1,104(sp)
    80005ea6:	7906                	ld	s2,96(sp)
    80005ea8:	69e6                	ld	s3,88(sp)
    80005eaa:	6a46                	ld	s4,80(sp)
    80005eac:	6aa6                	ld	s5,72(sp)
    80005eae:	6b06                	ld	s6,64(sp)
    80005eb0:	7be2                	ld	s7,56(sp)
    80005eb2:	7c42                	ld	s8,48(sp)
    80005eb4:	7ca2                	ld	s9,40(sp)
    80005eb6:	7d02                	ld	s10,32(sp)
    80005eb8:	6de2                	ld	s11,24(sp)
    80005eba:	6129                	addi	sp,sp,192
    80005ebc:	8082                	ret
    release(&pr.lock);
    80005ebe:	00017517          	auipc	a0,0x17
    80005ec2:	22a50513          	addi	a0,a0,554 # 8001d0e8 <pr>
    80005ec6:	00000097          	auipc	ra,0x0
    80005eca:	3cc080e7          	jalr	972(ra) # 80006292 <release>
}
    80005ece:	bfc9                	j	80005ea0 <printf+0x1b0>

0000000080005ed0 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ed0:	1101                	addi	sp,sp,-32
    80005ed2:	ec06                	sd	ra,24(sp)
    80005ed4:	e822                	sd	s0,16(sp)
    80005ed6:	e426                	sd	s1,8(sp)
    80005ed8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005eda:	00017497          	auipc	s1,0x17
    80005ede:	20e48493          	addi	s1,s1,526 # 8001d0e8 <pr>
    80005ee2:	00003597          	auipc	a1,0x3
    80005ee6:	90658593          	addi	a1,a1,-1786 # 800087e8 <syscalls+0x418>
    80005eea:	8526                	mv	a0,s1
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	262080e7          	jalr	610(ra) # 8000614e <initlock>
  pr.locking = 1;
    80005ef4:	4785                	li	a5,1
    80005ef6:	cc9c                	sw	a5,24(s1)
}
    80005ef8:	60e2                	ld	ra,24(sp)
    80005efa:	6442                	ld	s0,16(sp)
    80005efc:	64a2                	ld	s1,8(sp)
    80005efe:	6105                	addi	sp,sp,32
    80005f00:	8082                	ret

0000000080005f02 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f02:	1141                	addi	sp,sp,-16
    80005f04:	e406                	sd	ra,8(sp)
    80005f06:	e022                	sd	s0,0(sp)
    80005f08:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f0a:	100007b7          	lui	a5,0x10000
    80005f0e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f12:	f8000713          	li	a4,-128
    80005f16:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f1a:	470d                	li	a4,3
    80005f1c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f20:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f24:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f28:	469d                	li	a3,7
    80005f2a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f2e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f32:	00003597          	auipc	a1,0x3
    80005f36:	8d658593          	addi	a1,a1,-1834 # 80008808 <digits+0x18>
    80005f3a:	00017517          	auipc	a0,0x17
    80005f3e:	1ce50513          	addi	a0,a0,462 # 8001d108 <uart_tx_lock>
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	20c080e7          	jalr	524(ra) # 8000614e <initlock>
}
    80005f4a:	60a2                	ld	ra,8(sp)
    80005f4c:	6402                	ld	s0,0(sp)
    80005f4e:	0141                	addi	sp,sp,16
    80005f50:	8082                	ret

0000000080005f52 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f52:	1101                	addi	sp,sp,-32
    80005f54:	ec06                	sd	ra,24(sp)
    80005f56:	e822                	sd	s0,16(sp)
    80005f58:	e426                	sd	s1,8(sp)
    80005f5a:	1000                	addi	s0,sp,32
    80005f5c:	84aa                	mv	s1,a0
  push_off();
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	234080e7          	jalr	564(ra) # 80006192 <push_off>

  if(panicked){
    80005f66:	00003797          	auipc	a5,0x3
    80005f6a:	9467a783          	lw	a5,-1722(a5) # 800088ac <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f6e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f72:	c391                	beqz	a5,80005f76 <uartputc_sync+0x24>
    for(;;)
    80005f74:	a001                	j	80005f74 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f76:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f7a:	0207f793          	andi	a5,a5,32
    80005f7e:	dfe5                	beqz	a5,80005f76 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f80:	0ff4f513          	zext.b	a0,s1
    80005f84:	100007b7          	lui	a5,0x10000
    80005f88:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	2a6080e7          	jalr	678(ra) # 80006232 <pop_off>
}
    80005f94:	60e2                	ld	ra,24(sp)
    80005f96:	6442                	ld	s0,16(sp)
    80005f98:	64a2                	ld	s1,8(sp)
    80005f9a:	6105                	addi	sp,sp,32
    80005f9c:	8082                	ret

0000000080005f9e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f9e:	00003797          	auipc	a5,0x3
    80005fa2:	9127b783          	ld	a5,-1774(a5) # 800088b0 <uart_tx_r>
    80005fa6:	00003717          	auipc	a4,0x3
    80005faa:	91273703          	ld	a4,-1774(a4) # 800088b8 <uart_tx_w>
    80005fae:	06f70a63          	beq	a4,a5,80006022 <uartstart+0x84>
{
    80005fb2:	7139                	addi	sp,sp,-64
    80005fb4:	fc06                	sd	ra,56(sp)
    80005fb6:	f822                	sd	s0,48(sp)
    80005fb8:	f426                	sd	s1,40(sp)
    80005fba:	f04a                	sd	s2,32(sp)
    80005fbc:	ec4e                	sd	s3,24(sp)
    80005fbe:	e852                	sd	s4,16(sp)
    80005fc0:	e456                	sd	s5,8(sp)
    80005fc2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fc4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fc8:	00017a17          	auipc	s4,0x17
    80005fcc:	140a0a13          	addi	s4,s4,320 # 8001d108 <uart_tx_lock>
    uart_tx_r += 1;
    80005fd0:	00003497          	auipc	s1,0x3
    80005fd4:	8e048493          	addi	s1,s1,-1824 # 800088b0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fd8:	00003997          	auipc	s3,0x3
    80005fdc:	8e098993          	addi	s3,s3,-1824 # 800088b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fe0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fe4:	02077713          	andi	a4,a4,32
    80005fe8:	c705                	beqz	a4,80006010 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fea:	01f7f713          	andi	a4,a5,31
    80005fee:	9752                	add	a4,a4,s4
    80005ff0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005ff4:	0785                	addi	a5,a5,1
    80005ff6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ff8:	8526                	mv	a0,s1
    80005ffa:	ffffb097          	auipc	ra,0xffffb
    80005ffe:	564080e7          	jalr	1380(ra) # 8000155e <wakeup>
    
    WriteReg(THR, c);
    80006002:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006006:	609c                	ld	a5,0(s1)
    80006008:	0009b703          	ld	a4,0(s3)
    8000600c:	fcf71ae3          	bne	a4,a5,80005fe0 <uartstart+0x42>
  }
}
    80006010:	70e2                	ld	ra,56(sp)
    80006012:	7442                	ld	s0,48(sp)
    80006014:	74a2                	ld	s1,40(sp)
    80006016:	7902                	ld	s2,32(sp)
    80006018:	69e2                	ld	s3,24(sp)
    8000601a:	6a42                	ld	s4,16(sp)
    8000601c:	6aa2                	ld	s5,8(sp)
    8000601e:	6121                	addi	sp,sp,64
    80006020:	8082                	ret
    80006022:	8082                	ret

0000000080006024 <uartputc>:
{
    80006024:	7179                	addi	sp,sp,-48
    80006026:	f406                	sd	ra,40(sp)
    80006028:	f022                	sd	s0,32(sp)
    8000602a:	ec26                	sd	s1,24(sp)
    8000602c:	e84a                	sd	s2,16(sp)
    8000602e:	e44e                	sd	s3,8(sp)
    80006030:	e052                	sd	s4,0(sp)
    80006032:	1800                	addi	s0,sp,48
    80006034:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006036:	00017517          	auipc	a0,0x17
    8000603a:	0d250513          	addi	a0,a0,210 # 8001d108 <uart_tx_lock>
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	1a0080e7          	jalr	416(ra) # 800061de <acquire>
  if(panicked){
    80006046:	00003797          	auipc	a5,0x3
    8000604a:	8667a783          	lw	a5,-1946(a5) # 800088ac <panicked>
    8000604e:	e7c9                	bnez	a5,800060d8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006050:	00003717          	auipc	a4,0x3
    80006054:	86873703          	ld	a4,-1944(a4) # 800088b8 <uart_tx_w>
    80006058:	00003797          	auipc	a5,0x3
    8000605c:	8587b783          	ld	a5,-1960(a5) # 800088b0 <uart_tx_r>
    80006060:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006064:	00017997          	auipc	s3,0x17
    80006068:	0a498993          	addi	s3,s3,164 # 8001d108 <uart_tx_lock>
    8000606c:	00003497          	auipc	s1,0x3
    80006070:	84448493          	addi	s1,s1,-1980 # 800088b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006074:	00003917          	auipc	s2,0x3
    80006078:	84490913          	addi	s2,s2,-1980 # 800088b8 <uart_tx_w>
    8000607c:	00e79f63          	bne	a5,a4,8000609a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006080:	85ce                	mv	a1,s3
    80006082:	8526                	mv	a0,s1
    80006084:	ffffb097          	auipc	ra,0xffffb
    80006088:	476080e7          	jalr	1142(ra) # 800014fa <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000608c:	00093703          	ld	a4,0(s2)
    80006090:	609c                	ld	a5,0(s1)
    80006092:	02078793          	addi	a5,a5,32
    80006096:	fee785e3          	beq	a5,a4,80006080 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000609a:	00017497          	auipc	s1,0x17
    8000609e:	06e48493          	addi	s1,s1,110 # 8001d108 <uart_tx_lock>
    800060a2:	01f77793          	andi	a5,a4,31
    800060a6:	97a6                	add	a5,a5,s1
    800060a8:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800060ac:	0705                	addi	a4,a4,1
    800060ae:	00003797          	auipc	a5,0x3
    800060b2:	80e7b523          	sd	a4,-2038(a5) # 800088b8 <uart_tx_w>
  uartstart();
    800060b6:	00000097          	auipc	ra,0x0
    800060ba:	ee8080e7          	jalr	-280(ra) # 80005f9e <uartstart>
  release(&uart_tx_lock);
    800060be:	8526                	mv	a0,s1
    800060c0:	00000097          	auipc	ra,0x0
    800060c4:	1d2080e7          	jalr	466(ra) # 80006292 <release>
}
    800060c8:	70a2                	ld	ra,40(sp)
    800060ca:	7402                	ld	s0,32(sp)
    800060cc:	64e2                	ld	s1,24(sp)
    800060ce:	6942                	ld	s2,16(sp)
    800060d0:	69a2                	ld	s3,8(sp)
    800060d2:	6a02                	ld	s4,0(sp)
    800060d4:	6145                	addi	sp,sp,48
    800060d6:	8082                	ret
    for(;;)
    800060d8:	a001                	j	800060d8 <uartputc+0xb4>

00000000800060da <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060da:	1141                	addi	sp,sp,-16
    800060dc:	e422                	sd	s0,8(sp)
    800060de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060e0:	100007b7          	lui	a5,0x10000
    800060e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060e8:	8b85                	andi	a5,a5,1
    800060ea:	cb81                	beqz	a5,800060fa <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060ec:	100007b7          	lui	a5,0x10000
    800060f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060f4:	6422                	ld	s0,8(sp)
    800060f6:	0141                	addi	sp,sp,16
    800060f8:	8082                	ret
    return -1;
    800060fa:	557d                	li	a0,-1
    800060fc:	bfe5                	j	800060f4 <uartgetc+0x1a>

00000000800060fe <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060fe:	1101                	addi	sp,sp,-32
    80006100:	ec06                	sd	ra,24(sp)
    80006102:	e822                	sd	s0,16(sp)
    80006104:	e426                	sd	s1,8(sp)
    80006106:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006108:	54fd                	li	s1,-1
    8000610a:	a029                	j	80006114 <uartintr+0x16>
      break;
    consoleintr(c);
    8000610c:	00000097          	auipc	ra,0x0
    80006110:	918080e7          	jalr	-1768(ra) # 80005a24 <consoleintr>
    int c = uartgetc();
    80006114:	00000097          	auipc	ra,0x0
    80006118:	fc6080e7          	jalr	-58(ra) # 800060da <uartgetc>
    if(c == -1)
    8000611c:	fe9518e3          	bne	a0,s1,8000610c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006120:	00017497          	auipc	s1,0x17
    80006124:	fe848493          	addi	s1,s1,-24 # 8001d108 <uart_tx_lock>
    80006128:	8526                	mv	a0,s1
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	0b4080e7          	jalr	180(ra) # 800061de <acquire>
  uartstart();
    80006132:	00000097          	auipc	ra,0x0
    80006136:	e6c080e7          	jalr	-404(ra) # 80005f9e <uartstart>
  release(&uart_tx_lock);
    8000613a:	8526                	mv	a0,s1
    8000613c:	00000097          	auipc	ra,0x0
    80006140:	156080e7          	jalr	342(ra) # 80006292 <release>
}
    80006144:	60e2                	ld	ra,24(sp)
    80006146:	6442                	ld	s0,16(sp)
    80006148:	64a2                	ld	s1,8(sp)
    8000614a:	6105                	addi	sp,sp,32
    8000614c:	8082                	ret

000000008000614e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000614e:	1141                	addi	sp,sp,-16
    80006150:	e422                	sd	s0,8(sp)
    80006152:	0800                	addi	s0,sp,16
  lk->name = name;
    80006154:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006156:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000615a:	00053823          	sd	zero,16(a0)
}
    8000615e:	6422                	ld	s0,8(sp)
    80006160:	0141                	addi	sp,sp,16
    80006162:	8082                	ret

0000000080006164 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006164:	411c                	lw	a5,0(a0)
    80006166:	e399                	bnez	a5,8000616c <holding+0x8>
    80006168:	4501                	li	a0,0
  return r;
}
    8000616a:	8082                	ret
{
    8000616c:	1101                	addi	sp,sp,-32
    8000616e:	ec06                	sd	ra,24(sp)
    80006170:	e822                	sd	s0,16(sp)
    80006172:	e426                	sd	s1,8(sp)
    80006174:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006176:	6904                	ld	s1,16(a0)
    80006178:	ffffb097          	auipc	ra,0xffffb
    8000617c:	cbe080e7          	jalr	-834(ra) # 80000e36 <mycpu>
    80006180:	40a48533          	sub	a0,s1,a0
    80006184:	00153513          	seqz	a0,a0
}
    80006188:	60e2                	ld	ra,24(sp)
    8000618a:	6442                	ld	s0,16(sp)
    8000618c:	64a2                	ld	s1,8(sp)
    8000618e:	6105                	addi	sp,sp,32
    80006190:	8082                	ret

0000000080006192 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006192:	1101                	addi	sp,sp,-32
    80006194:	ec06                	sd	ra,24(sp)
    80006196:	e822                	sd	s0,16(sp)
    80006198:	e426                	sd	s1,8(sp)
    8000619a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000619c:	100024f3          	csrr	s1,sstatus
    800061a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061a4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061a6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061aa:	ffffb097          	auipc	ra,0xffffb
    800061ae:	c8c080e7          	jalr	-884(ra) # 80000e36 <mycpu>
    800061b2:	5d3c                	lw	a5,120(a0)
    800061b4:	cf89                	beqz	a5,800061ce <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061b6:	ffffb097          	auipc	ra,0xffffb
    800061ba:	c80080e7          	jalr	-896(ra) # 80000e36 <mycpu>
    800061be:	5d3c                	lw	a5,120(a0)
    800061c0:	2785                	addiw	a5,a5,1
    800061c2:	dd3c                	sw	a5,120(a0)
}
    800061c4:	60e2                	ld	ra,24(sp)
    800061c6:	6442                	ld	s0,16(sp)
    800061c8:	64a2                	ld	s1,8(sp)
    800061ca:	6105                	addi	sp,sp,32
    800061cc:	8082                	ret
    mycpu()->intena = old;
    800061ce:	ffffb097          	auipc	ra,0xffffb
    800061d2:	c68080e7          	jalr	-920(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061d6:	8085                	srli	s1,s1,0x1
    800061d8:	8885                	andi	s1,s1,1
    800061da:	dd64                	sw	s1,124(a0)
    800061dc:	bfe9                	j	800061b6 <push_off+0x24>

00000000800061de <acquire>:
{
    800061de:	1101                	addi	sp,sp,-32
    800061e0:	ec06                	sd	ra,24(sp)
    800061e2:	e822                	sd	s0,16(sp)
    800061e4:	e426                	sd	s1,8(sp)
    800061e6:	1000                	addi	s0,sp,32
    800061e8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	fa8080e7          	jalr	-88(ra) # 80006192 <push_off>
  if(holding(lk))
    800061f2:	8526                	mv	a0,s1
    800061f4:	00000097          	auipc	ra,0x0
    800061f8:	f70080e7          	jalr	-144(ra) # 80006164 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061fc:	4705                	li	a4,1
  if(holding(lk))
    800061fe:	e115                	bnez	a0,80006222 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006200:	87ba                	mv	a5,a4
    80006202:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006206:	2781                	sext.w	a5,a5
    80006208:	ffe5                	bnez	a5,80006200 <acquire+0x22>
  __sync_synchronize();
    8000620a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000620e:	ffffb097          	auipc	ra,0xffffb
    80006212:	c28080e7          	jalr	-984(ra) # 80000e36 <mycpu>
    80006216:	e888                	sd	a0,16(s1)
}
    80006218:	60e2                	ld	ra,24(sp)
    8000621a:	6442                	ld	s0,16(sp)
    8000621c:	64a2                	ld	s1,8(sp)
    8000621e:	6105                	addi	sp,sp,32
    80006220:	8082                	ret
    panic("acquire");
    80006222:	00002517          	auipc	a0,0x2
    80006226:	5ee50513          	addi	a0,a0,1518 # 80008810 <digits+0x20>
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	a7c080e7          	jalr	-1412(ra) # 80005ca6 <panic>

0000000080006232 <pop_off>:

void
pop_off(void)
{
    80006232:	1141                	addi	sp,sp,-16
    80006234:	e406                	sd	ra,8(sp)
    80006236:	e022                	sd	s0,0(sp)
    80006238:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000623a:	ffffb097          	auipc	ra,0xffffb
    8000623e:	bfc080e7          	jalr	-1028(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006242:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006246:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006248:	e78d                	bnez	a5,80006272 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000624a:	5d3c                	lw	a5,120(a0)
    8000624c:	02f05b63          	blez	a5,80006282 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006250:	37fd                	addiw	a5,a5,-1
    80006252:	0007871b          	sext.w	a4,a5
    80006256:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006258:	eb09                	bnez	a4,8000626a <pop_off+0x38>
    8000625a:	5d7c                	lw	a5,124(a0)
    8000625c:	c799                	beqz	a5,8000626a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000625e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006262:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006266:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000626a:	60a2                	ld	ra,8(sp)
    8000626c:	6402                	ld	s0,0(sp)
    8000626e:	0141                	addi	sp,sp,16
    80006270:	8082                	ret
    panic("pop_off - interruptible");
    80006272:	00002517          	auipc	a0,0x2
    80006276:	5a650513          	addi	a0,a0,1446 # 80008818 <digits+0x28>
    8000627a:	00000097          	auipc	ra,0x0
    8000627e:	a2c080e7          	jalr	-1492(ra) # 80005ca6 <panic>
    panic("pop_off");
    80006282:	00002517          	auipc	a0,0x2
    80006286:	5ae50513          	addi	a0,a0,1454 # 80008830 <digits+0x40>
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	a1c080e7          	jalr	-1508(ra) # 80005ca6 <panic>

0000000080006292 <release>:
{
    80006292:	1101                	addi	sp,sp,-32
    80006294:	ec06                	sd	ra,24(sp)
    80006296:	e822                	sd	s0,16(sp)
    80006298:	e426                	sd	s1,8(sp)
    8000629a:	1000                	addi	s0,sp,32
    8000629c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	ec6080e7          	jalr	-314(ra) # 80006164 <holding>
    800062a6:	c115                	beqz	a0,800062ca <release+0x38>
  lk->cpu = 0;
    800062a8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062ac:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062b0:	0f50000f          	fence	iorw,ow
    800062b4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	f7a080e7          	jalr	-134(ra) # 80006232 <pop_off>
}
    800062c0:	60e2                	ld	ra,24(sp)
    800062c2:	6442                	ld	s0,16(sp)
    800062c4:	64a2                	ld	s1,8(sp)
    800062c6:	6105                	addi	sp,sp,32
    800062c8:	8082                	ret
    panic("release");
    800062ca:	00002517          	auipc	a0,0x2
    800062ce:	56e50513          	addi	a0,a0,1390 # 80008838 <digits+0x48>
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	9d4080e7          	jalr	-1580(ra) # 80005ca6 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
