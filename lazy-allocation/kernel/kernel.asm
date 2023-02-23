
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	be010113          	addi	sp,sp,-1056 # 80019be0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	760050ef          	jal	ra,80005776 <start>

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
    80000030:	00022797          	auipc	a5,0x22
    80000034:	cb078793          	addi	a5,a5,-848 # 80021ce0 <end>
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
    80000054:	82090913          	addi	s2,s2,-2016 # 80008870 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	104080e7          	jalr	260(ra) # 8000615e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1a4080e7          	jalr	420(ra) # 80006212 <release>
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
    8000008e:	b9c080e7          	jalr	-1124(ra) # 80005c26 <panic>

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
    800000f2:	78250513          	addi	a0,a0,1922 # 80008870 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	fd8080e7          	jalr	-40(ra) # 800060ce <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	bde50513          	addi	a0,a0,-1058 # 80021ce0 <end>
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
    80000128:	74c48493          	addi	s1,s1,1868 # 80008870 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	030080e7          	jalr	48(ra) # 8000615e <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	73450513          	addi	a0,a0,1844 # 80008870 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	0cc080e7          	jalr	204(ra) # 80006212 <release>

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
    8000016c:	70850513          	addi	a0,a0,1800 # 80008870 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	0a2080e7          	jalr	162(ra) # 80006212 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd321>
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
    8000032a:	b8a080e7          	jalr	-1142(ra) # 80000eb0 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	51270713          	addi	a4,a4,1298 # 80008840 <started>
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
    80000346:	b6e080e7          	jalr	-1170(ra) # 80000eb0 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	91c080e7          	jalr	-1764(ra) # 80005c70 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	816080e7          	jalr	-2026(ra) # 80001b7a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	dc4080e7          	jalr	-572(ra) # 80005130 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	05e080e7          	jalr	94(ra) # 800013d2 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	7ba080e7          	jalr	1978(ra) # 80005b36 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	acc080e7          	jalr	-1332(ra) # 80005e50 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	8dc080e7          	jalr	-1828(ra) # 80005c70 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	8cc080e7          	jalr	-1844(ra) # 80005c70 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	8bc080e7          	jalr	-1860(ra) # 80005c70 <printf>
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
    800003d8:	a28080e7          	jalr	-1496(ra) # 80000dfc <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	776080e7          	jalr	1910(ra) # 80001b52 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	796080e7          	jalr	1942(ra) # 80001b7a <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	d2e080e7          	jalr	-722(ra) # 8000511a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d3c080e7          	jalr	-708(ra) # 80005130 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	f0e080e7          	jalr	-242(ra) # 8000230a <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	5ac080e7          	jalr	1452(ra) # 800029b0 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	522080e7          	jalr	1314(ra) # 8000392e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	e24080e7          	jalr	-476(ra) # 80005238 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d98080e7          	jalr	-616(ra) # 800011b4 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	40f72b23          	sw	a5,1046(a4) # 80008840 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
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
    80000442:	40a7b783          	ld	a5,1034(a5) # 80008848 <kernel_pagetable>
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
  if (va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    8000047c:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	79c080e7          	jalr	1948(ra) # 80005c26 <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
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
  for (int level = 2; level > 0; level--)
    800004bc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd317>
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
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

  if (va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
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
  if (pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
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
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
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

  if (size == 0)
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
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if (*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if (a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	676080e7          	jalr	1654(ra) # 80005c26 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	666080e7          	jalr	1638(ra) # 80005c26 <panic>
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
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
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
    80000610:	61a080e7          	jalr	1562(ra) # 80005c26 <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
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
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
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
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
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
    800006d8:	692080e7          	jalr	1682(ra) # 80000d66 <proc_mapstacks>
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
    800006fe:	14a7b723          	sd	a0,334(a5) # 80008848 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
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

  if ((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
      // panic("uvmunmap: walk");
      continue;
    if ((*pte & PTE_V) == 0)
      // panic("uvmunmap: not mapped");
      continue;
    if (PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000734:	6a85                	lui	s5,0x1
    80000736:	0535e263          	bltu	a1,s3,8000077a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
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
    8000075c:	4ce080e7          	jalr	1230(ra) # 80005c26 <panic>
      panic("uvmunmap: not a leaf");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	4be080e7          	jalr	1214(ra) # 80005c26 <panic>
    *pte = 0;
    80000770:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000774:	9956                	add	s2,s2,s5
    80000776:	fd3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    8000077a:	4601                	li	a2,0
    8000077c:	85ca                	mv	a1,s2
    8000077e:	8552                	mv	a0,s4
    80000780:	00000097          	auipc	ra,0x0
    80000784:	cdc080e7          	jalr	-804(ra) # 8000045c <walk>
    80000788:	84aa                	mv	s1,a0
    8000078a:	d56d                	beqz	a0,80000774 <uvmunmap+0x6a>
    if ((*pte & PTE_V) == 0)
    8000078c:	611c                	ld	a5,0(a0)
    8000078e:	0017f713          	andi	a4,a5,1
    80000792:	d36d                	beqz	a4,80000774 <uvmunmap+0x6a>
    if (PTE_FLAGS(*pte) == PTE_V)
    80000794:	3ff7f713          	andi	a4,a5,1023
    80000798:	fd7704e3          	beq	a4,s7,80000760 <uvmunmap+0x56>
    if (do_free)
    8000079c:	fc0b0ae3          	beqz	s6,80000770 <uvmunmap+0x66>
      uint64 pa = PTE2PA(*pte);
    800007a0:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    800007a2:	00c79513          	slli	a0,a5,0xc
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	876080e7          	jalr	-1930(ra) # 8000001c <kfree>
    800007ae:	b7c9                	j	80000770 <uvmunmap+0x66>

00000000800007b0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007b0:	1101                	addi	sp,sp,-32
    800007b2:	ec06                	sd	ra,24(sp)
    800007b4:	e822                	sd	s0,16(sp)
    800007b6:	e426                	sd	s1,8(sp)
    800007b8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	960080e7          	jalr	-1696(ra) # 8000011a <kalloc>
    800007c2:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800007c4:	c519                	beqz	a0,800007d2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007c6:	6605                	lui	a2,0x1
    800007c8:	4581                	li	a1,0
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	9b0080e7          	jalr	-1616(ra) # 8000017a <memset>
  return pagetable;
}
    800007d2:	8526                	mv	a0,s1
    800007d4:	60e2                	ld	ra,24(sp)
    800007d6:	6442                	ld	s0,16(sp)
    800007d8:	64a2                	ld	s1,8(sp)
    800007da:	6105                	addi	sp,sp,32
    800007dc:	8082                	ret

00000000800007de <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007de:	7179                	addi	sp,sp,-48
    800007e0:	f406                	sd	ra,40(sp)
    800007e2:	f022                	sd	s0,32(sp)
    800007e4:	ec26                	sd	s1,24(sp)
    800007e6:	e84a                	sd	s2,16(sp)
    800007e8:	e44e                	sd	s3,8(sp)
    800007ea:	e052                	sd	s4,0(sp)
    800007ec:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    800007ee:	6785                	lui	a5,0x1
    800007f0:	04f67863          	bgeu	a2,a5,80000840 <uvmfirst+0x62>
    800007f4:	8a2a                	mv	s4,a0
    800007f6:	89ae                	mv	s3,a1
    800007f8:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	920080e7          	jalr	-1760(ra) # 8000011a <kalloc>
    80000802:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000804:	6605                	lui	a2,0x1
    80000806:	4581                	li	a1,0
    80000808:	00000097          	auipc	ra,0x0
    8000080c:	972080e7          	jalr	-1678(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000810:	4779                	li	a4,30
    80000812:	86ca                	mv	a3,s2
    80000814:	6605                	lui	a2,0x1
    80000816:	4581                	li	a1,0
    80000818:	8552                	mv	a0,s4
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	d2a080e7          	jalr	-726(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000822:	8626                	mv	a2,s1
    80000824:	85ce                	mv	a1,s3
    80000826:	854a                	mv	a0,s2
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	9ae080e7          	jalr	-1618(ra) # 800001d6 <memmove>
}
    80000830:	70a2                	ld	ra,40(sp)
    80000832:	7402                	ld	s0,32(sp)
    80000834:	64e2                	ld	s1,24(sp)
    80000836:	6942                	ld	s2,16(sp)
    80000838:	69a2                	ld	s3,8(sp)
    8000083a:	6a02                	ld	s4,0(sp)
    8000083c:	6145                	addi	sp,sp,48
    8000083e:	8082                	ret
    panic("uvmfirst: more than a page");
    80000840:	00008517          	auipc	a0,0x8
    80000844:	87050513          	addi	a0,a0,-1936 # 800080b0 <etext+0xb0>
    80000848:	00005097          	auipc	ra,0x5
    8000084c:	3de080e7          	jalr	990(ra) # 80005c26 <panic>

0000000080000850 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000850:	1101                	addi	sp,sp,-32
    80000852:	ec06                	sd	ra,24(sp)
    80000854:	e822                	sd	s0,16(sp)
    80000856:	e426                	sd	s1,8(sp)
    80000858:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    8000085a:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    8000085c:	00b67d63          	bgeu	a2,a1,80000876 <uvmdealloc+0x26>
    80000860:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    80000862:	6785                	lui	a5,0x1
    80000864:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000866:	00f60733          	add	a4,a2,a5
    8000086a:	76fd                	lui	a3,0xfffff
    8000086c:	8f75                	and	a4,a4,a3
    8000086e:	97ae                	add	a5,a5,a1
    80000870:	8ff5                	and	a5,a5,a3
    80000872:	00f76863          	bltu	a4,a5,80000882 <uvmdealloc+0x32>
  {
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }
  return newsz;
}
    80000876:	8526                	mv	a0,s1
    80000878:	60e2                	ld	ra,24(sp)
    8000087a:	6442                	ld	s0,16(sp)
    8000087c:	64a2                	ld	s1,8(sp)
    8000087e:	6105                	addi	sp,sp,32
    80000880:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000882:	8f99                	sub	a5,a5,a4
    80000884:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000886:	4685                	li	a3,1
    80000888:	0007861b          	sext.w	a2,a5
    8000088c:	85ba                	mv	a1,a4
    8000088e:	00000097          	auipc	ra,0x0
    80000892:	e7c080e7          	jalr	-388(ra) # 8000070a <uvmunmap>
    80000896:	b7c5                	j	80000876 <uvmdealloc+0x26>

0000000080000898 <uvmalloc>:
  if (newsz < oldsz)
    80000898:	0ab66563          	bltu	a2,a1,80000942 <uvmalloc+0xaa>
{
    8000089c:	7139                	addi	sp,sp,-64
    8000089e:	fc06                	sd	ra,56(sp)
    800008a0:	f822                	sd	s0,48(sp)
    800008a2:	f426                	sd	s1,40(sp)
    800008a4:	f04a                	sd	s2,32(sp)
    800008a6:	ec4e                	sd	s3,24(sp)
    800008a8:	e852                	sd	s4,16(sp)
    800008aa:	e456                	sd	s5,8(sp)
    800008ac:	e05a                	sd	s6,0(sp)
    800008ae:	0080                	addi	s0,sp,64
    800008b0:	8aaa                	mv	s5,a0
    800008b2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008b4:	6785                	lui	a5,0x1
    800008b6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008b8:	95be                	add	a1,a1,a5
    800008ba:	77fd                	lui	a5,0xfffff
    800008bc:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    800008c0:	08c9f363          	bgeu	s3,a2,80000946 <uvmalloc+0xae>
    800008c4:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    800008c6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008ca:	00000097          	auipc	ra,0x0
    800008ce:	850080e7          	jalr	-1968(ra) # 8000011a <kalloc>
    800008d2:	84aa                	mv	s1,a0
    if (mem == 0)
    800008d4:	c51d                	beqz	a0,80000902 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008d6:	6605                	lui	a2,0x1
    800008d8:	4581                	li	a1,0
    800008da:	00000097          	auipc	ra,0x0
    800008de:	8a0080e7          	jalr	-1888(ra) # 8000017a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    800008e2:	875a                	mv	a4,s6
    800008e4:	86a6                	mv	a3,s1
    800008e6:	6605                	lui	a2,0x1
    800008e8:	85ca                	mv	a1,s2
    800008ea:	8556                	mv	a0,s5
    800008ec:	00000097          	auipc	ra,0x0
    800008f0:	c58080e7          	jalr	-936(ra) # 80000544 <mappages>
    800008f4:	e90d                	bnez	a0,80000926 <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE)
    800008f6:	6785                	lui	a5,0x1
    800008f8:	993e                	add	s2,s2,a5
    800008fa:	fd4968e3          	bltu	s2,s4,800008ca <uvmalloc+0x32>
  return newsz;
    800008fe:	8552                	mv	a0,s4
    80000900:	a809                	j	80000912 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000902:	864e                	mv	a2,s3
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	f48080e7          	jalr	-184(ra) # 80000850 <uvmdealloc>
      return 0;
    80000910:	4501                	li	a0,0
}
    80000912:	70e2                	ld	ra,56(sp)
    80000914:	7442                	ld	s0,48(sp)
    80000916:	74a2                	ld	s1,40(sp)
    80000918:	7902                	ld	s2,32(sp)
    8000091a:	69e2                	ld	s3,24(sp)
    8000091c:	6a42                	ld	s4,16(sp)
    8000091e:	6aa2                	ld	s5,8(sp)
    80000920:	6b02                	ld	s6,0(sp)
    80000922:	6121                	addi	sp,sp,64
    80000924:	8082                	ret
      kfree(mem);
    80000926:	8526                	mv	a0,s1
    80000928:	fffff097          	auipc	ra,0xfffff
    8000092c:	6f4080e7          	jalr	1780(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000930:	864e                	mv	a2,s3
    80000932:	85ca                	mv	a1,s2
    80000934:	8556                	mv	a0,s5
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	f1a080e7          	jalr	-230(ra) # 80000850 <uvmdealloc>
      return 0;
    8000093e:	4501                	li	a0,0
    80000940:	bfc9                	j	80000912 <uvmalloc+0x7a>
    return oldsz;
    80000942:	852e                	mv	a0,a1
}
    80000944:	8082                	ret
  return newsz;
    80000946:	8532                	mv	a0,a2
    80000948:	b7e9                	j	80000912 <uvmalloc+0x7a>

000000008000094a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    8000094a:	7179                	addi	sp,sp,-48
    8000094c:	f406                	sd	ra,40(sp)
    8000094e:	f022                	sd	s0,32(sp)
    80000950:	ec26                	sd	s1,24(sp)
    80000952:	e84a                	sd	s2,16(sp)
    80000954:	e44e                	sd	s3,8(sp)
    80000956:	e052                	sd	s4,0(sp)
    80000958:	1800                	addi	s0,sp,48
    8000095a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    8000095c:	84aa                	mv	s1,a0
    8000095e:	6905                	lui	s2,0x1
    80000960:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000962:	4985                	li	s3,1
    80000964:	a829                	j	8000097e <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000966:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000968:	00c79513          	slli	a0,a5,0xc
    8000096c:	00000097          	auipc	ra,0x0
    80000970:	fde080e7          	jalr	-34(ra) # 8000094a <freewalk>
      pagetable[i] = 0;
    80000974:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80000978:	04a1                	addi	s1,s1,8
    8000097a:	03248163          	beq	s1,s2,8000099c <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000097e:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000980:	00f7f713          	andi	a4,a5,15
    80000984:	ff3701e3          	beq	a4,s3,80000966 <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80000988:	8b85                	andi	a5,a5,1
    8000098a:	d7fd                	beqz	a5,80000978 <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    8000098c:	00007517          	auipc	a0,0x7
    80000990:	74450513          	addi	a0,a0,1860 # 800080d0 <etext+0xd0>
    80000994:	00005097          	auipc	ra,0x5
    80000998:	292080e7          	jalr	658(ra) # 80005c26 <panic>
    }
  }
  kfree((void *)pagetable);
    8000099c:	8552                	mv	a0,s4
    8000099e:	fffff097          	auipc	ra,0xfffff
    800009a2:	67e080e7          	jalr	1662(ra) # 8000001c <kfree>
}
    800009a6:	70a2                	ld	ra,40(sp)
    800009a8:	7402                	ld	s0,32(sp)
    800009aa:	64e2                	ld	s1,24(sp)
    800009ac:	6942                	ld	s2,16(sp)
    800009ae:	69a2                	ld	s3,8(sp)
    800009b0:	6a02                	ld	s4,0(sp)
    800009b2:	6145                	addi	sp,sp,48
    800009b4:	8082                	ret

00000000800009b6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009b6:	1101                	addi	sp,sp,-32
    800009b8:	ec06                	sd	ra,24(sp)
    800009ba:	e822                	sd	s0,16(sp)
    800009bc:	e426                	sd	s1,8(sp)
    800009be:	1000                	addi	s0,sp,32
    800009c0:	84aa                	mv	s1,a0
  if (sz > 0)
    800009c2:	e999                	bnez	a1,800009d8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	f84080e7          	jalr	-124(ra) # 8000094a <freewalk>
}
    800009ce:	60e2                	ld	ra,24(sp)
    800009d0:	6442                	ld	s0,16(sp)
    800009d2:	64a2                	ld	s1,8(sp)
    800009d4:	6105                	addi	sp,sp,32
    800009d6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800009d8:	6785                	lui	a5,0x1
    800009da:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009dc:	95be                	add	a1,a1,a5
    800009de:	4685                	li	a3,1
    800009e0:	00c5d613          	srli	a2,a1,0xc
    800009e4:	4581                	li	a1,0
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	d24080e7          	jalr	-732(ra) # 8000070a <uvmunmap>
    800009ee:	bfd9                	j	800009c4 <uvmfree+0xe>

00000000800009f0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE)
    800009f0:	ca4d                	beqz	a2,80000aa2 <uvmcopy+0xb2>
{
    800009f2:	715d                	addi	sp,sp,-80
    800009f4:	e486                	sd	ra,72(sp)
    800009f6:	e0a2                	sd	s0,64(sp)
    800009f8:	fc26                	sd	s1,56(sp)
    800009fa:	f84a                	sd	s2,48(sp)
    800009fc:	f44e                	sd	s3,40(sp)
    800009fe:	f052                	sd	s4,32(sp)
    80000a00:	ec56                	sd	s5,24(sp)
    80000a02:	e85a                	sd	s6,16(sp)
    80000a04:	e45e                	sd	s7,8(sp)
    80000a06:	0880                	addi	s0,sp,80
    80000a08:	8aaa                	mv	s5,a0
    80000a0a:	8b2e                	mv	s6,a1
    80000a0c:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE)
    80000a0e:	4481                	li	s1,0
    80000a10:	a029                	j	80000a1a <uvmcopy+0x2a>
    80000a12:	6785                	lui	a5,0x1
    80000a14:	94be                	add	s1,s1,a5
    80000a16:	0744fa63          	bgeu	s1,s4,80000a8a <uvmcopy+0x9a>
  {
    if ((pte = walk(old, i, 0)) == 0)
    80000a1a:	4601                	li	a2,0
    80000a1c:	85a6                	mv	a1,s1
    80000a1e:	8556                	mv	a0,s5
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	a3c080e7          	jalr	-1476(ra) # 8000045c <walk>
    80000a28:	d56d                	beqz	a0,80000a12 <uvmcopy+0x22>
      // panic("uvmcopy: pte should exist");
      continue;

    if ((*pte & PTE_V) == 0)
    80000a2a:	6118                	ld	a4,0(a0)
    80000a2c:	00177793          	andi	a5,a4,1
    80000a30:	d3ed                	beqz	a5,80000a12 <uvmcopy+0x22>
      // panic("uvmcopy: page not present");
      continue;
    pa = PTE2PA(*pte);
    80000a32:	00a75593          	srli	a1,a4,0xa
    80000a36:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a3a:	3ff77913          	andi	s2,a4,1023
    if ((mem = kalloc()) == 0)
    80000a3e:	fffff097          	auipc	ra,0xfffff
    80000a42:	6dc080e7          	jalr	1756(ra) # 8000011a <kalloc>
    80000a46:	89aa                	mv	s3,a0
    80000a48:	c515                	beqz	a0,80000a74 <uvmcopy+0x84>
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80000a4a:	6605                	lui	a2,0x1
    80000a4c:	85de                	mv	a1,s7
    80000a4e:	fffff097          	auipc	ra,0xfffff
    80000a52:	788080e7          	jalr	1928(ra) # 800001d6 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0)
    80000a56:	874a                	mv	a4,s2
    80000a58:	86ce                	mv	a3,s3
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	85a6                	mv	a1,s1
    80000a5e:	855a                	mv	a0,s6
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	ae4080e7          	jalr	-1308(ra) # 80000544 <mappages>
    80000a68:	d54d                	beqz	a0,80000a12 <uvmcopy+0x22>
    {
      kfree(mem);
    80000a6a:	854e                	mv	a0,s3
    80000a6c:	fffff097          	auipc	ra,0xfffff
    80000a70:	5b0080e7          	jalr	1456(ra) # 8000001c <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a74:	4685                	li	a3,1
    80000a76:	00c4d613          	srli	a2,s1,0xc
    80000a7a:	4581                	li	a1,0
    80000a7c:	855a                	mv	a0,s6
    80000a7e:	00000097          	auipc	ra,0x0
    80000a82:	c8c080e7          	jalr	-884(ra) # 8000070a <uvmunmap>
  return -1;
    80000a86:	557d                	li	a0,-1
    80000a88:	a011                	j	80000a8c <uvmcopy+0x9c>
  return 0;
    80000a8a:	4501                	li	a0,0
}
    80000a8c:	60a6                	ld	ra,72(sp)
    80000a8e:	6406                	ld	s0,64(sp)
    80000a90:	74e2                	ld	s1,56(sp)
    80000a92:	7942                	ld	s2,48(sp)
    80000a94:	79a2                	ld	s3,40(sp)
    80000a96:	7a02                	ld	s4,32(sp)
    80000a98:	6ae2                	ld	s5,24(sp)
    80000a9a:	6b42                	ld	s6,16(sp)
    80000a9c:	6ba2                	ld	s7,8(sp)
    80000a9e:	6161                	addi	sp,sp,80
    80000aa0:	8082                	ret
  return 0;
    80000aa2:	4501                	li	a0,0
}
    80000aa4:	8082                	ret

0000000080000aa6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000aa6:	1141                	addi	sp,sp,-16
    80000aa8:	e406                	sd	ra,8(sp)
    80000aaa:	e022                	sd	s0,0(sp)
    80000aac:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000aae:	4601                	li	a2,0
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	9ac080e7          	jalr	-1620(ra) # 8000045c <walk>
  if (pte == 0)
    80000ab8:	c901                	beqz	a0,80000ac8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aba:	611c                	ld	a5,0(a0)
    80000abc:	9bbd                	andi	a5,a5,-17
    80000abe:	e11c                	sd	a5,0(a0)
}
    80000ac0:	60a2                	ld	ra,8(sp)
    80000ac2:	6402                	ld	s0,0(sp)
    80000ac4:	0141                	addi	sp,sp,16
    80000ac6:	8082                	ret
    panic("uvmclear");
    80000ac8:	00007517          	auipc	a0,0x7
    80000acc:	61850513          	addi	a0,a0,1560 # 800080e0 <etext+0xe0>
    80000ad0:	00005097          	auipc	ra,0x5
    80000ad4:	156080e7          	jalr	342(ra) # 80005c26 <panic>

0000000080000ad8 <lazy_alloc>:
    return -1;
  }
}

int lazy_alloc(uint64 va)
{
    80000ad8:	7179                	addi	sp,sp,-48
    80000ada:	f406                	sd	ra,40(sp)
    80000adc:	f022                	sd	s0,32(sp)
    80000ade:	ec26                	sd	s1,24(sp)
    80000ae0:	e84a                	sd	s2,16(sp)
    80000ae2:	e44e                	sd	s3,8(sp)
    80000ae4:	1800                	addi	s0,sp,48
    80000ae6:	84aa                	mv	s1,a0
  // printf("lazy alloc: %p\n", va);
  struct proc *p = myproc();
    80000ae8:	00000097          	auipc	ra,0x0
    80000aec:	3f4080e7          	jalr	1012(ra) # 80000edc <myproc>
  pagetable_t pagetable = p->pagetable;
    80000af0:	05053983          	ld	s3,80(a0)
  uint64 vpn = PGROUNDDOWN(va);
    80000af4:	75fd                	lui	a1,0xfffff
    80000af6:	00b4f933          	and	s2,s1,a1
  if (va >= p->sz)
    80000afa:	653c                	ld	a5,72(a0)
    80000afc:	04f4f663          	bgeu	s1,a5,80000b48 <lazy_alloc+0x70>
    return -1;
  char *mem = kalloc();
    80000b00:	fffff097          	auipc	ra,0xfffff
    80000b04:	61a080e7          	jalr	1562(ra) # 8000011a <kalloc>
    80000b08:	84aa                	mv	s1,a0
  if (mem == 0)
    80000b0a:	c129                	beqz	a0,80000b4c <lazy_alloc+0x74>
    return -1;
  memset(mem, 0, PGSIZE);
    80000b0c:	6605                	lui	a2,0x1
    80000b0e:	4581                	li	a1,0
    80000b10:	fffff097          	auipc	ra,0xfffff
    80000b14:	66a080e7          	jalr	1642(ra) # 8000017a <memset>
  if (mappages(pagetable, vpn, PGSIZE, (uint64)mem, PTE_R | PTE_U | PTE_W) != 0)
    80000b18:	4759                	li	a4,22
    80000b1a:	86a6                	mv	a3,s1
    80000b1c:	6605                	lui	a2,0x1
    80000b1e:	85ca                	mv	a1,s2
    80000b20:	854e                	mv	a0,s3
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	a22080e7          	jalr	-1502(ra) # 80000544 <mappages>
    80000b2a:	e901                	bnez	a0,80000b3a <lazy_alloc+0x62>
    kfree(mem);
    // uvmdealloc(pagetable, a, oldsz);
    return -1;
  }
  return 0;
    80000b2c:	70a2                	ld	ra,40(sp)
    80000b2e:	7402                	ld	s0,32(sp)
    80000b30:	64e2                	ld	s1,24(sp)
    80000b32:	6942                	ld	s2,16(sp)
    80000b34:	69a2                	ld	s3,8(sp)
    80000b36:	6145                	addi	sp,sp,48
    80000b38:	8082                	ret
    kfree(mem);
    80000b3a:	8526                	mv	a0,s1
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	4e0080e7          	jalr	1248(ra) # 8000001c <kfree>
    return -1;
    80000b44:	557d                	li	a0,-1
    80000b46:	b7dd                	j	80000b2c <lazy_alloc+0x54>
    return -1;
    80000b48:	557d                	li	a0,-1
    80000b4a:	b7cd                	j	80000b2c <lazy_alloc+0x54>
    return -1;
    80000b4c:	557d                	li	a0,-1
    80000b4e:	bff9                	j	80000b2c <lazy_alloc+0x54>

0000000080000b50 <walkaddralloc>:
{
    80000b50:	7179                	addi	sp,sp,-48
    80000b52:	f406                	sd	ra,40(sp)
    80000b54:	f022                	sd	s0,32(sp)
    80000b56:	ec26                	sd	s1,24(sp)
    80000b58:	e84a                	sd	s2,16(sp)
    80000b5a:	e44e                	sd	s3,8(sp)
    80000b5c:	1800                	addi	s0,sp,48
    80000b5e:	89aa                	mv	s3,a0
    80000b60:	892e                	mv	s2,a1
  uint64 pa = walkaddr(pagetable, va);
    80000b62:	00000097          	auipc	ra,0x0
    80000b66:	9a0080e7          	jalr	-1632(ra) # 80000502 <walkaddr>
    80000b6a:	84aa                	mv	s1,a0
  if (pa == 0)
    80000b6c:	c909                	beqz	a0,80000b7e <walkaddralloc+0x2e>
}
    80000b6e:	8526                	mv	a0,s1
    80000b70:	70a2                	ld	ra,40(sp)
    80000b72:	7402                	ld	s0,32(sp)
    80000b74:	64e2                	ld	s1,24(sp)
    80000b76:	6942                	ld	s2,16(sp)
    80000b78:	69a2                	ld	s3,8(sp)
    80000b7a:	6145                	addi	sp,sp,48
    80000b7c:	8082                	ret
    if (lazy_alloc(va) < 0)
    80000b7e:	854a                	mv	a0,s2
    80000b80:	00000097          	auipc	ra,0x0
    80000b84:	f58080e7          	jalr	-168(ra) # 80000ad8 <lazy_alloc>
    80000b88:	fe0543e3          	bltz	a0,80000b6e <walkaddralloc+0x1e>
    pa = walkaddr(pagetable, va);
    80000b8c:	85ca                	mv	a1,s2
    80000b8e:	854e                	mv	a0,s3
    80000b90:	00000097          	auipc	ra,0x0
    80000b94:	972080e7          	jalr	-1678(ra) # 80000502 <walkaddr>
    80000b98:	84aa                	mv	s1,a0
    80000b9a:	bfd1                	j	80000b6e <walkaddralloc+0x1e>

0000000080000b9c <copyout>:
  while (len > 0)
    80000b9c:	c6bd                	beqz	a3,80000c0a <copyout+0x6e>
{
    80000b9e:	715d                	addi	sp,sp,-80
    80000ba0:	e486                	sd	ra,72(sp)
    80000ba2:	e0a2                	sd	s0,64(sp)
    80000ba4:	fc26                	sd	s1,56(sp)
    80000ba6:	f84a                	sd	s2,48(sp)
    80000ba8:	f44e                	sd	s3,40(sp)
    80000baa:	f052                	sd	s4,32(sp)
    80000bac:	ec56                	sd	s5,24(sp)
    80000bae:	e85a                	sd	s6,16(sp)
    80000bb0:	e45e                	sd	s7,8(sp)
    80000bb2:	e062                	sd	s8,0(sp)
    80000bb4:	0880                	addi	s0,sp,80
    80000bb6:	8b2a                	mv	s6,a0
    80000bb8:	8c2e                	mv	s8,a1
    80000bba:	8a32                	mv	s4,a2
    80000bbc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000bbe:	7bfd                	lui	s7,0xfffff
    n = PGSIZE - (dstva - va0);
    80000bc0:	6a85                	lui	s5,0x1
    80000bc2:	a015                	j	80000be6 <copyout+0x4a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000bc4:	9562                	add	a0,a0,s8
    80000bc6:	0004861b          	sext.w	a2,s1
    80000bca:	85d2                	mv	a1,s4
    80000bcc:	41250533          	sub	a0,a0,s2
    80000bd0:	fffff097          	auipc	ra,0xfffff
    80000bd4:	606080e7          	jalr	1542(ra) # 800001d6 <memmove>
    len -= n;
    80000bd8:	409989b3          	sub	s3,s3,s1
    src += n;
    80000bdc:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000bde:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000be2:	02098263          	beqz	s3,80000c06 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000be6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddralloc(pagetable, va0);
    80000bea:	85ca                	mv	a1,s2
    80000bec:	855a                	mv	a0,s6
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	f62080e7          	jalr	-158(ra) # 80000b50 <walkaddralloc>
    if (pa0 == 0)
    80000bf6:	cd01                	beqz	a0,80000c0e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bf8:	418904b3          	sub	s1,s2,s8
    80000bfc:	94d6                	add	s1,s1,s5
    80000bfe:	fc99f3e3          	bgeu	s3,s1,80000bc4 <copyout+0x28>
    80000c02:	84ce                	mv	s1,s3
    80000c04:	b7c1                	j	80000bc4 <copyout+0x28>
  return 0;
    80000c06:	4501                	li	a0,0
    80000c08:	a021                	j	80000c10 <copyout+0x74>
    80000c0a:	4501                	li	a0,0
}
    80000c0c:	8082                	ret
      return -1;
    80000c0e:	557d                	li	a0,-1
}
    80000c10:	60a6                	ld	ra,72(sp)
    80000c12:	6406                	ld	s0,64(sp)
    80000c14:	74e2                	ld	s1,56(sp)
    80000c16:	7942                	ld	s2,48(sp)
    80000c18:	79a2                	ld	s3,40(sp)
    80000c1a:	7a02                	ld	s4,32(sp)
    80000c1c:	6ae2                	ld	s5,24(sp)
    80000c1e:	6b42                	ld	s6,16(sp)
    80000c20:	6ba2                	ld	s7,8(sp)
    80000c22:	6c02                	ld	s8,0(sp)
    80000c24:	6161                	addi	sp,sp,80
    80000c26:	8082                	ret

0000000080000c28 <copyin>:
  while (len > 0)
    80000c28:	caa5                	beqz	a3,80000c98 <copyin+0x70>
{
    80000c2a:	715d                	addi	sp,sp,-80
    80000c2c:	e486                	sd	ra,72(sp)
    80000c2e:	e0a2                	sd	s0,64(sp)
    80000c30:	fc26                	sd	s1,56(sp)
    80000c32:	f84a                	sd	s2,48(sp)
    80000c34:	f44e                	sd	s3,40(sp)
    80000c36:	f052                	sd	s4,32(sp)
    80000c38:	ec56                	sd	s5,24(sp)
    80000c3a:	e85a                	sd	s6,16(sp)
    80000c3c:	e45e                	sd	s7,8(sp)
    80000c3e:	e062                	sd	s8,0(sp)
    80000c40:	0880                	addi	s0,sp,80
    80000c42:	8b2a                	mv	s6,a0
    80000c44:	8a2e                	mv	s4,a1
    80000c46:	8c32                	mv	s8,a2
    80000c48:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4a:	7bfd                	lui	s7,0xfffff
    n = PGSIZE - (srcva - va0);
    80000c4c:	6a85                	lui	s5,0x1
    80000c4e:	a01d                	j	80000c74 <copyin+0x4c>
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c50:	018505b3          	add	a1,a0,s8
    80000c54:	0004861b          	sext.w	a2,s1
    80000c58:	412585b3          	sub	a1,a1,s2
    80000c5c:	8552                	mv	a0,s4
    80000c5e:	fffff097          	auipc	ra,0xfffff
    80000c62:	578080e7          	jalr	1400(ra) # 800001d6 <memmove>
    len -= n;
    80000c66:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c6a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c6c:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000c70:	02098263          	beqz	s3,80000c94 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c74:	017c7933          	and	s2,s8,s7
    pa0 = walkaddralloc(pagetable, va0);
    80000c78:	85ca                	mv	a1,s2
    80000c7a:	855a                	mv	a0,s6
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	ed4080e7          	jalr	-300(ra) # 80000b50 <walkaddralloc>
    if (pa0 == 0)
    80000c84:	cd01                	beqz	a0,80000c9c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c86:	418904b3          	sub	s1,s2,s8
    80000c8a:	94d6                	add	s1,s1,s5
    80000c8c:	fc99f2e3          	bgeu	s3,s1,80000c50 <copyin+0x28>
    80000c90:	84ce                	mv	s1,s3
    80000c92:	bf7d                	j	80000c50 <copyin+0x28>
  return 0;
    80000c94:	4501                	li	a0,0
    80000c96:	a021                	j	80000c9e <copyin+0x76>
    80000c98:	4501                	li	a0,0
}
    80000c9a:	8082                	ret
      return -1;
    80000c9c:	557d                	li	a0,-1
}
    80000c9e:	60a6                	ld	ra,72(sp)
    80000ca0:	6406                	ld	s0,64(sp)
    80000ca2:	74e2                	ld	s1,56(sp)
    80000ca4:	7942                	ld	s2,48(sp)
    80000ca6:	79a2                	ld	s3,40(sp)
    80000ca8:	7a02                	ld	s4,32(sp)
    80000caa:	6ae2                	ld	s5,24(sp)
    80000cac:	6b42                	ld	s6,16(sp)
    80000cae:	6ba2                	ld	s7,8(sp)
    80000cb0:	6c02                	ld	s8,0(sp)
    80000cb2:	6161                	addi	sp,sp,80
    80000cb4:	8082                	ret

0000000080000cb6 <copyinstr>:
  while (got_null == 0 && max > 0)
    80000cb6:	c2dd                	beqz	a3,80000d5c <copyinstr+0xa6>
{
    80000cb8:	715d                	addi	sp,sp,-80
    80000cba:	e486                	sd	ra,72(sp)
    80000cbc:	e0a2                	sd	s0,64(sp)
    80000cbe:	fc26                	sd	s1,56(sp)
    80000cc0:	f84a                	sd	s2,48(sp)
    80000cc2:	f44e                	sd	s3,40(sp)
    80000cc4:	f052                	sd	s4,32(sp)
    80000cc6:	ec56                	sd	s5,24(sp)
    80000cc8:	e85a                	sd	s6,16(sp)
    80000cca:	e45e                	sd	s7,8(sp)
    80000ccc:	0880                	addi	s0,sp,80
    80000cce:	8a2a                	mv	s4,a0
    80000cd0:	8b2e                	mv	s6,a1
    80000cd2:	8bb2                	mv	s7,a2
    80000cd4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000cd6:	7afd                	lui	s5,0xfffff
    n = PGSIZE - (srcva - va0);
    80000cd8:	6985                	lui	s3,0x1
    80000cda:	a02d                	j	80000d04 <copyinstr+0x4e>
        *dst = '\0';
    80000cdc:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ce0:	4785                	li	a5,1
  if (got_null)
    80000ce2:	37fd                	addiw	a5,a5,-1
    80000ce4:	0007851b          	sext.w	a0,a5
}
    80000ce8:	60a6                	ld	ra,72(sp)
    80000cea:	6406                	ld	s0,64(sp)
    80000cec:	74e2                	ld	s1,56(sp)
    80000cee:	7942                	ld	s2,48(sp)
    80000cf0:	79a2                	ld	s3,40(sp)
    80000cf2:	7a02                	ld	s4,32(sp)
    80000cf4:	6ae2                	ld	s5,24(sp)
    80000cf6:	6b42                	ld	s6,16(sp)
    80000cf8:	6ba2                	ld	s7,8(sp)
    80000cfa:	6161                	addi	sp,sp,80
    80000cfc:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cfe:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    80000d02:	c8a9                	beqz	s1,80000d54 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000d04:	015bf933          	and	s2,s7,s5
    pa0 = walkaddralloc(pagetable, va0);
    80000d08:	85ca                	mv	a1,s2
    80000d0a:	8552                	mv	a0,s4
    80000d0c:	00000097          	auipc	ra,0x0
    80000d10:	e44080e7          	jalr	-444(ra) # 80000b50 <walkaddralloc>
    if (pa0 == 0)
    80000d14:	c131                	beqz	a0,80000d58 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000d16:	417906b3          	sub	a3,s2,s7
    80000d1a:	96ce                	add	a3,a3,s3
    80000d1c:	00d4f363          	bgeu	s1,a3,80000d22 <copyinstr+0x6c>
    80000d20:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000d22:	955e                	add	a0,a0,s7
    80000d24:	41250533          	sub	a0,a0,s2
    while (n > 0)
    80000d28:	daf9                	beqz	a3,80000cfe <copyinstr+0x48>
    80000d2a:	87da                	mv	a5,s6
    80000d2c:	885a                	mv	a6,s6
      if (*p == '\0')
    80000d2e:	41650633          	sub	a2,a0,s6
    while (n > 0)
    80000d32:	96da                	add	a3,a3,s6
    80000d34:	85be                	mv	a1,a5
      if (*p == '\0')
    80000d36:	00f60733          	add	a4,a2,a5
    80000d3a:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd320>
    80000d3e:	df59                	beqz	a4,80000cdc <copyinstr+0x26>
        *dst = *p;
    80000d40:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d44:	0785                	addi	a5,a5,1
    while (n > 0)
    80000d46:	fed797e3          	bne	a5,a3,80000d34 <copyinstr+0x7e>
    80000d4a:	14fd                	addi	s1,s1,-1
    80000d4c:	94c2                	add	s1,s1,a6
      --max;
    80000d4e:	8c8d                	sub	s1,s1,a1
      dst++;
    80000d50:	8b3e                	mv	s6,a5
    80000d52:	b775                	j	80000cfe <copyinstr+0x48>
    80000d54:	4781                	li	a5,0
    80000d56:	b771                	j	80000ce2 <copyinstr+0x2c>
      return -1;
    80000d58:	557d                	li	a0,-1
    80000d5a:	b779                	j	80000ce8 <copyinstr+0x32>
  int got_null = 0;
    80000d5c:	4781                	li	a5,0
  if (got_null)
    80000d5e:	37fd                	addiw	a5,a5,-1
    80000d60:	0007851b          	sext.w	a0,a5
}
    80000d64:	8082                	ret

0000000080000d66 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d66:	7139                	addi	sp,sp,-64
    80000d68:	fc06                	sd	ra,56(sp)
    80000d6a:	f822                	sd	s0,48(sp)
    80000d6c:	f426                	sd	s1,40(sp)
    80000d6e:	f04a                	sd	s2,32(sp)
    80000d70:	ec4e                	sd	s3,24(sp)
    80000d72:	e852                	sd	s4,16(sp)
    80000d74:	e456                	sd	s5,8(sp)
    80000d76:	e05a                	sd	s6,0(sp)
    80000d78:	0080                	addi	s0,sp,64
    80000d7a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d7c:	00008497          	auipc	s1,0x8
    80000d80:	f4448493          	addi	s1,s1,-188 # 80008cc0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d84:	8b26                	mv	s6,s1
    80000d86:	00007a97          	auipc	s5,0x7
    80000d8a:	27aa8a93          	addi	s5,s5,634 # 80008000 <etext>
    80000d8e:	04000937          	lui	s2,0x4000
    80000d92:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d94:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d96:	0000ea17          	auipc	s4,0xe
    80000d9a:	92aa0a13          	addi	s4,s4,-1750 # 8000e6c0 <tickslock>
    char *pa = kalloc();
    80000d9e:	fffff097          	auipc	ra,0xfffff
    80000da2:	37c080e7          	jalr	892(ra) # 8000011a <kalloc>
    80000da6:	862a                	mv	a2,a0
    if(pa == 0)
    80000da8:	c131                	beqz	a0,80000dec <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000daa:	416485b3          	sub	a1,s1,s6
    80000dae:	858d                	srai	a1,a1,0x3
    80000db0:	000ab783          	ld	a5,0(s5)
    80000db4:	02f585b3          	mul	a1,a1,a5
    80000db8:	2585                	addiw	a1,a1,1 # fffffffffffff001 <end+0xffffffff7ffdd321>
    80000dba:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000dbe:	4719                	li	a4,6
    80000dc0:	6685                	lui	a3,0x1
    80000dc2:	40b905b3          	sub	a1,s2,a1
    80000dc6:	854e                	mv	a0,s3
    80000dc8:	00000097          	auipc	ra,0x0
    80000dcc:	81c080e7          	jalr	-2020(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd0:	16848493          	addi	s1,s1,360
    80000dd4:	fd4495e3          	bne	s1,s4,80000d9e <proc_mapstacks+0x38>
  }
}
    80000dd8:	70e2                	ld	ra,56(sp)
    80000dda:	7442                	ld	s0,48(sp)
    80000ddc:	74a2                	ld	s1,40(sp)
    80000dde:	7902                	ld	s2,32(sp)
    80000de0:	69e2                	ld	s3,24(sp)
    80000de2:	6a42                	ld	s4,16(sp)
    80000de4:	6aa2                	ld	s5,8(sp)
    80000de6:	6b02                	ld	s6,0(sp)
    80000de8:	6121                	addi	sp,sp,64
    80000dea:	8082                	ret
      panic("kalloc");
    80000dec:	00007517          	auipc	a0,0x7
    80000df0:	30450513          	addi	a0,a0,772 # 800080f0 <etext+0xf0>
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	e32080e7          	jalr	-462(ra) # 80005c26 <panic>

0000000080000dfc <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dfc:	7139                	addi	sp,sp,-64
    80000dfe:	fc06                	sd	ra,56(sp)
    80000e00:	f822                	sd	s0,48(sp)
    80000e02:	f426                	sd	s1,40(sp)
    80000e04:	f04a                	sd	s2,32(sp)
    80000e06:	ec4e                	sd	s3,24(sp)
    80000e08:	e852                	sd	s4,16(sp)
    80000e0a:	e456                	sd	s5,8(sp)
    80000e0c:	e05a                	sd	s6,0(sp)
    80000e0e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e10:	00007597          	auipc	a1,0x7
    80000e14:	2e858593          	addi	a1,a1,744 # 800080f8 <etext+0xf8>
    80000e18:	00008517          	auipc	a0,0x8
    80000e1c:	a7850513          	addi	a0,a0,-1416 # 80008890 <pid_lock>
    80000e20:	00005097          	auipc	ra,0x5
    80000e24:	2ae080e7          	jalr	686(ra) # 800060ce <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e28:	00007597          	auipc	a1,0x7
    80000e2c:	2d858593          	addi	a1,a1,728 # 80008100 <etext+0x100>
    80000e30:	00008517          	auipc	a0,0x8
    80000e34:	a7850513          	addi	a0,a0,-1416 # 800088a8 <wait_lock>
    80000e38:	00005097          	auipc	ra,0x5
    80000e3c:	296080e7          	jalr	662(ra) # 800060ce <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e40:	00008497          	auipc	s1,0x8
    80000e44:	e8048493          	addi	s1,s1,-384 # 80008cc0 <proc>
      initlock(&p->lock, "proc");
    80000e48:	00007b17          	auipc	s6,0x7
    80000e4c:	2c8b0b13          	addi	s6,s6,712 # 80008110 <etext+0x110>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e50:	8aa6                	mv	s5,s1
    80000e52:	00007a17          	auipc	s4,0x7
    80000e56:	1aea0a13          	addi	s4,s4,430 # 80008000 <etext>
    80000e5a:	04000937          	lui	s2,0x4000
    80000e5e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e60:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e62:	0000e997          	auipc	s3,0xe
    80000e66:	85e98993          	addi	s3,s3,-1954 # 8000e6c0 <tickslock>
      initlock(&p->lock, "proc");
    80000e6a:	85da                	mv	a1,s6
    80000e6c:	8526                	mv	a0,s1
    80000e6e:	00005097          	auipc	ra,0x5
    80000e72:	260080e7          	jalr	608(ra) # 800060ce <initlock>
      p->state = UNUSED;
    80000e76:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e7a:	415487b3          	sub	a5,s1,s5
    80000e7e:	878d                	srai	a5,a5,0x3
    80000e80:	000a3703          	ld	a4,0(s4)
    80000e84:	02e787b3          	mul	a5,a5,a4
    80000e88:	2785                	addiw	a5,a5,1
    80000e8a:	00d7979b          	slliw	a5,a5,0xd
    80000e8e:	40f907b3          	sub	a5,s2,a5
    80000e92:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e94:	16848493          	addi	s1,s1,360
    80000e98:	fd3499e3          	bne	s1,s3,80000e6a <procinit+0x6e>
  }
}
    80000e9c:	70e2                	ld	ra,56(sp)
    80000e9e:	7442                	ld	s0,48(sp)
    80000ea0:	74a2                	ld	s1,40(sp)
    80000ea2:	7902                	ld	s2,32(sp)
    80000ea4:	69e2                	ld	s3,24(sp)
    80000ea6:	6a42                	ld	s4,16(sp)
    80000ea8:	6aa2                	ld	s5,8(sp)
    80000eaa:	6b02                	ld	s6,0(sp)
    80000eac:	6121                	addi	sp,sp,64
    80000eae:	8082                	ret

0000000080000eb0 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000eb0:	1141                	addi	sp,sp,-16
    80000eb2:	e422                	sd	s0,8(sp)
    80000eb4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000eb6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000eb8:	2501                	sext.w	a0,a0
    80000eba:	6422                	ld	s0,8(sp)
    80000ebc:	0141                	addi	sp,sp,16
    80000ebe:	8082                	ret

0000000080000ec0 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000ec0:	1141                	addi	sp,sp,-16
    80000ec2:	e422                	sd	s0,8(sp)
    80000ec4:	0800                	addi	s0,sp,16
    80000ec6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ec8:	2781                	sext.w	a5,a5
    80000eca:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ecc:	00008517          	auipc	a0,0x8
    80000ed0:	9f450513          	addi	a0,a0,-1548 # 800088c0 <cpus>
    80000ed4:	953e                	add	a0,a0,a5
    80000ed6:	6422                	ld	s0,8(sp)
    80000ed8:	0141                	addi	sp,sp,16
    80000eda:	8082                	ret

0000000080000edc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000edc:	1101                	addi	sp,sp,-32
    80000ede:	ec06                	sd	ra,24(sp)
    80000ee0:	e822                	sd	s0,16(sp)
    80000ee2:	e426                	sd	s1,8(sp)
    80000ee4:	1000                	addi	s0,sp,32
  push_off();
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	22c080e7          	jalr	556(ra) # 80006112 <push_off>
    80000eee:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ef0:	2781                	sext.w	a5,a5
    80000ef2:	079e                	slli	a5,a5,0x7
    80000ef4:	00008717          	auipc	a4,0x8
    80000ef8:	99c70713          	addi	a4,a4,-1636 # 80008890 <pid_lock>
    80000efc:	97ba                	add	a5,a5,a4
    80000efe:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	2b2080e7          	jalr	690(ra) # 800061b2 <pop_off>
  return p;
}
    80000f08:	8526                	mv	a0,s1
    80000f0a:	60e2                	ld	ra,24(sp)
    80000f0c:	6442                	ld	s0,16(sp)
    80000f0e:	64a2                	ld	s1,8(sp)
    80000f10:	6105                	addi	sp,sp,32
    80000f12:	8082                	ret

0000000080000f14 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e406                	sd	ra,8(sp)
    80000f18:	e022                	sd	s0,0(sp)
    80000f1a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f1c:	00000097          	auipc	ra,0x0
    80000f20:	fc0080e7          	jalr	-64(ra) # 80000edc <myproc>
    80000f24:	00005097          	auipc	ra,0x5
    80000f28:	2ee080e7          	jalr	750(ra) # 80006212 <release>

  if (first) {
    80000f2c:	00008797          	auipc	a5,0x8
    80000f30:	8c47a783          	lw	a5,-1852(a5) # 800087f0 <first.1>
    80000f34:	eb89                	bnez	a5,80000f46 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f36:	00001097          	auipc	ra,0x1
    80000f3a:	c5c080e7          	jalr	-932(ra) # 80001b92 <usertrapret>
}
    80000f3e:	60a2                	ld	ra,8(sp)
    80000f40:	6402                	ld	s0,0(sp)
    80000f42:	0141                	addi	sp,sp,16
    80000f44:	8082                	ret
    first = 0;
    80000f46:	00008797          	auipc	a5,0x8
    80000f4a:	8a07a523          	sw	zero,-1878(a5) # 800087f0 <first.1>
    fsinit(ROOTDEV);
    80000f4e:	4505                	li	a0,1
    80000f50:	00002097          	auipc	ra,0x2
    80000f54:	9e0080e7          	jalr	-1568(ra) # 80002930 <fsinit>
    80000f58:	bff9                	j	80000f36 <forkret+0x22>

0000000080000f5a <allocpid>:
{
    80000f5a:	1101                	addi	sp,sp,-32
    80000f5c:	ec06                	sd	ra,24(sp)
    80000f5e:	e822                	sd	s0,16(sp)
    80000f60:	e426                	sd	s1,8(sp)
    80000f62:	e04a                	sd	s2,0(sp)
    80000f64:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f66:	00008917          	auipc	s2,0x8
    80000f6a:	92a90913          	addi	s2,s2,-1750 # 80008890 <pid_lock>
    80000f6e:	854a                	mv	a0,s2
    80000f70:	00005097          	auipc	ra,0x5
    80000f74:	1ee080e7          	jalr	494(ra) # 8000615e <acquire>
  pid = nextpid;
    80000f78:	00008797          	auipc	a5,0x8
    80000f7c:	87c78793          	addi	a5,a5,-1924 # 800087f4 <nextpid>
    80000f80:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f82:	0014871b          	addiw	a4,s1,1
    80000f86:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f88:	854a                	mv	a0,s2
    80000f8a:	00005097          	auipc	ra,0x5
    80000f8e:	288080e7          	jalr	648(ra) # 80006212 <release>
}
    80000f92:	8526                	mv	a0,s1
    80000f94:	60e2                	ld	ra,24(sp)
    80000f96:	6442                	ld	s0,16(sp)
    80000f98:	64a2                	ld	s1,8(sp)
    80000f9a:	6902                	ld	s2,0(sp)
    80000f9c:	6105                	addi	sp,sp,32
    80000f9e:	8082                	ret

0000000080000fa0 <proc_pagetable>:
{
    80000fa0:	1101                	addi	sp,sp,-32
    80000fa2:	ec06                	sd	ra,24(sp)
    80000fa4:	e822                	sd	s0,16(sp)
    80000fa6:	e426                	sd	s1,8(sp)
    80000fa8:	e04a                	sd	s2,0(sp)
    80000faa:	1000                	addi	s0,sp,32
    80000fac:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fae:	00000097          	auipc	ra,0x0
    80000fb2:	802080e7          	jalr	-2046(ra) # 800007b0 <uvmcreate>
    80000fb6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fb8:	c121                	beqz	a0,80000ff8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fba:	4729                	li	a4,10
    80000fbc:	00006697          	auipc	a3,0x6
    80000fc0:	04468693          	addi	a3,a3,68 # 80007000 <_trampoline>
    80000fc4:	6605                	lui	a2,0x1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	576080e7          	jalr	1398(ra) # 80000544 <mappages>
    80000fd6:	02054863          	bltz	a0,80001006 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fda:	4719                	li	a4,6
    80000fdc:	05893683          	ld	a3,88(s2)
    80000fe0:	6605                	lui	a2,0x1
    80000fe2:	020005b7          	lui	a1,0x2000
    80000fe6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe8:	05b6                	slli	a1,a1,0xd
    80000fea:	8526                	mv	a0,s1
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	558080e7          	jalr	1368(ra) # 80000544 <mappages>
    80000ff4:	02054163          	bltz	a0,80001016 <proc_pagetable+0x76>
}
    80000ff8:	8526                	mv	a0,s1
    80000ffa:	60e2                	ld	ra,24(sp)
    80000ffc:	6442                	ld	s0,16(sp)
    80000ffe:	64a2                	ld	s1,8(sp)
    80001000:	6902                	ld	s2,0(sp)
    80001002:	6105                	addi	sp,sp,32
    80001004:	8082                	ret
    uvmfree(pagetable, 0);
    80001006:	4581                	li	a1,0
    80001008:	8526                	mv	a0,s1
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	9ac080e7          	jalr	-1620(ra) # 800009b6 <uvmfree>
    return 0;
    80001012:	4481                	li	s1,0
    80001014:	b7d5                	j	80000ff8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001016:	4681                	li	a3,0
    80001018:	4605                	li	a2,1
    8000101a:	040005b7          	lui	a1,0x4000
    8000101e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001020:	05b2                	slli	a1,a1,0xc
    80001022:	8526                	mv	a0,s1
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	6e6080e7          	jalr	1766(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    8000102c:	4581                	li	a1,0
    8000102e:	8526                	mv	a0,s1
    80001030:	00000097          	auipc	ra,0x0
    80001034:	986080e7          	jalr	-1658(ra) # 800009b6 <uvmfree>
    return 0;
    80001038:	4481                	li	s1,0
    8000103a:	bf7d                	j	80000ff8 <proc_pagetable+0x58>

000000008000103c <proc_freepagetable>:
{
    8000103c:	1101                	addi	sp,sp,-32
    8000103e:	ec06                	sd	ra,24(sp)
    80001040:	e822                	sd	s0,16(sp)
    80001042:	e426                	sd	s1,8(sp)
    80001044:	e04a                	sd	s2,0(sp)
    80001046:	1000                	addi	s0,sp,32
    80001048:	84aa                	mv	s1,a0
    8000104a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000104c:	4681                	li	a3,0
    8000104e:	4605                	li	a2,1
    80001050:	040005b7          	lui	a1,0x4000
    80001054:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001056:	05b2                	slli	a1,a1,0xc
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	6b2080e7          	jalr	1714(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001060:	4681                	li	a3,0
    80001062:	4605                	li	a2,1
    80001064:	020005b7          	lui	a1,0x2000
    80001068:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000106a:	05b6                	slli	a1,a1,0xd
    8000106c:	8526                	mv	a0,s1
    8000106e:	fffff097          	auipc	ra,0xfffff
    80001072:	69c080e7          	jalr	1692(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80001076:	85ca                	mv	a1,s2
    80001078:	8526                	mv	a0,s1
    8000107a:	00000097          	auipc	ra,0x0
    8000107e:	93c080e7          	jalr	-1732(ra) # 800009b6 <uvmfree>
}
    80001082:	60e2                	ld	ra,24(sp)
    80001084:	6442                	ld	s0,16(sp)
    80001086:	64a2                	ld	s1,8(sp)
    80001088:	6902                	ld	s2,0(sp)
    8000108a:	6105                	addi	sp,sp,32
    8000108c:	8082                	ret

000000008000108e <freeproc>:
{
    8000108e:	1101                	addi	sp,sp,-32
    80001090:	ec06                	sd	ra,24(sp)
    80001092:	e822                	sd	s0,16(sp)
    80001094:	e426                	sd	s1,8(sp)
    80001096:	1000                	addi	s0,sp,32
    80001098:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000109a:	6d28                	ld	a0,88(a0)
    8000109c:	c509                	beqz	a0,800010a6 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000109e:	fffff097          	auipc	ra,0xfffff
    800010a2:	f7e080e7          	jalr	-130(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800010a6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010aa:	68a8                	ld	a0,80(s1)
    800010ac:	c511                	beqz	a0,800010b8 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800010ae:	64ac                	ld	a1,72(s1)
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	f8c080e7          	jalr	-116(ra) # 8000103c <proc_freepagetable>
  p->pagetable = 0;
    800010b8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010bc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010c0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010c4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010c8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010cc:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010d0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010d4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010d8:	0004ac23          	sw	zero,24(s1)
}
    800010dc:	60e2                	ld	ra,24(sp)
    800010de:	6442                	ld	s0,16(sp)
    800010e0:	64a2                	ld	s1,8(sp)
    800010e2:	6105                	addi	sp,sp,32
    800010e4:	8082                	ret

00000000800010e6 <allocproc>:
{
    800010e6:	1101                	addi	sp,sp,-32
    800010e8:	ec06                	sd	ra,24(sp)
    800010ea:	e822                	sd	s0,16(sp)
    800010ec:	e426                	sd	s1,8(sp)
    800010ee:	e04a                	sd	s2,0(sp)
    800010f0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010f2:	00008497          	auipc	s1,0x8
    800010f6:	bce48493          	addi	s1,s1,-1074 # 80008cc0 <proc>
    800010fa:	0000d917          	auipc	s2,0xd
    800010fe:	5c690913          	addi	s2,s2,1478 # 8000e6c0 <tickslock>
    acquire(&p->lock);
    80001102:	8526                	mv	a0,s1
    80001104:	00005097          	auipc	ra,0x5
    80001108:	05a080e7          	jalr	90(ra) # 8000615e <acquire>
    if(p->state == UNUSED) {
    8000110c:	4c9c                	lw	a5,24(s1)
    8000110e:	cf81                	beqz	a5,80001126 <allocproc+0x40>
      release(&p->lock);
    80001110:	8526                	mv	a0,s1
    80001112:	00005097          	auipc	ra,0x5
    80001116:	100080e7          	jalr	256(ra) # 80006212 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000111a:	16848493          	addi	s1,s1,360
    8000111e:	ff2492e3          	bne	s1,s2,80001102 <allocproc+0x1c>
  return 0;
    80001122:	4481                	li	s1,0
    80001124:	a889                	j	80001176 <allocproc+0x90>
  p->pid = allocpid();
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	e34080e7          	jalr	-460(ra) # 80000f5a <allocpid>
    8000112e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001130:	4785                	li	a5,1
    80001132:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001134:	fffff097          	auipc	ra,0xfffff
    80001138:	fe6080e7          	jalr	-26(ra) # 8000011a <kalloc>
    8000113c:	892a                	mv	s2,a0
    8000113e:	eca8                	sd	a0,88(s1)
    80001140:	c131                	beqz	a0,80001184 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001142:	8526                	mv	a0,s1
    80001144:	00000097          	auipc	ra,0x0
    80001148:	e5c080e7          	jalr	-420(ra) # 80000fa0 <proc_pagetable>
    8000114c:	892a                	mv	s2,a0
    8000114e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001150:	c531                	beqz	a0,8000119c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001152:	07000613          	li	a2,112
    80001156:	4581                	li	a1,0
    80001158:	06048513          	addi	a0,s1,96
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	01e080e7          	jalr	30(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001164:	00000797          	auipc	a5,0x0
    80001168:	db078793          	addi	a5,a5,-592 # 80000f14 <forkret>
    8000116c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000116e:	60bc                	ld	a5,64(s1)
    80001170:	6705                	lui	a4,0x1
    80001172:	97ba                	add	a5,a5,a4
    80001174:	f4bc                	sd	a5,104(s1)
}
    80001176:	8526                	mv	a0,s1
    80001178:	60e2                	ld	ra,24(sp)
    8000117a:	6442                	ld	s0,16(sp)
    8000117c:	64a2                	ld	s1,8(sp)
    8000117e:	6902                	ld	s2,0(sp)
    80001180:	6105                	addi	sp,sp,32
    80001182:	8082                	ret
    freeproc(p);
    80001184:	8526                	mv	a0,s1
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	f08080e7          	jalr	-248(ra) # 8000108e <freeproc>
    release(&p->lock);
    8000118e:	8526                	mv	a0,s1
    80001190:	00005097          	auipc	ra,0x5
    80001194:	082080e7          	jalr	130(ra) # 80006212 <release>
    return 0;
    80001198:	84ca                	mv	s1,s2
    8000119a:	bff1                	j	80001176 <allocproc+0x90>
    freeproc(p);
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	ef0080e7          	jalr	-272(ra) # 8000108e <freeproc>
    release(&p->lock);
    800011a6:	8526                	mv	a0,s1
    800011a8:	00005097          	auipc	ra,0x5
    800011ac:	06a080e7          	jalr	106(ra) # 80006212 <release>
    return 0;
    800011b0:	84ca                	mv	s1,s2
    800011b2:	b7d1                	j	80001176 <allocproc+0x90>

00000000800011b4 <userinit>:
{
    800011b4:	1101                	addi	sp,sp,-32
    800011b6:	ec06                	sd	ra,24(sp)
    800011b8:	e822                	sd	s0,16(sp)
    800011ba:	e426                	sd	s1,8(sp)
    800011bc:	1000                	addi	s0,sp,32
  p = allocproc();
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	f28080e7          	jalr	-216(ra) # 800010e6 <allocproc>
    800011c6:	84aa                	mv	s1,a0
  initproc = p;
    800011c8:	00007797          	auipc	a5,0x7
    800011cc:	68a7b423          	sd	a0,1672(a5) # 80008850 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011d0:	03400613          	li	a2,52
    800011d4:	00007597          	auipc	a1,0x7
    800011d8:	62c58593          	addi	a1,a1,1580 # 80008800 <initcode>
    800011dc:	6928                	ld	a0,80(a0)
    800011de:	fffff097          	auipc	ra,0xfffff
    800011e2:	600080e7          	jalr	1536(ra) # 800007de <uvmfirst>
  p->sz = PGSIZE;
    800011e6:	6785                	lui	a5,0x1
    800011e8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ea:	6cb8                	ld	a4,88(s1)
    800011ec:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011f0:	6cb8                	ld	a4,88(s1)
    800011f2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011f4:	4641                	li	a2,16
    800011f6:	00007597          	auipc	a1,0x7
    800011fa:	f2258593          	addi	a1,a1,-222 # 80008118 <etext+0x118>
    800011fe:	15848513          	addi	a0,s1,344
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	0c0080e7          	jalr	192(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    8000120a:	00007517          	auipc	a0,0x7
    8000120e:	f1e50513          	addi	a0,a0,-226 # 80008128 <etext+0x128>
    80001212:	00002097          	auipc	ra,0x2
    80001216:	13c080e7          	jalr	316(ra) # 8000334e <namei>
    8000121a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000121e:	478d                	li	a5,3
    80001220:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001222:	8526                	mv	a0,s1
    80001224:	00005097          	auipc	ra,0x5
    80001228:	fee080e7          	jalr	-18(ra) # 80006212 <release>
}
    8000122c:	60e2                	ld	ra,24(sp)
    8000122e:	6442                	ld	s0,16(sp)
    80001230:	64a2                	ld	s1,8(sp)
    80001232:	6105                	addi	sp,sp,32
    80001234:	8082                	ret

0000000080001236 <growproc>:
{
    80001236:	1101                	addi	sp,sp,-32
    80001238:	ec06                	sd	ra,24(sp)
    8000123a:	e822                	sd	s0,16(sp)
    8000123c:	e426                	sd	s1,8(sp)
    8000123e:	e04a                	sd	s2,0(sp)
    80001240:	1000                	addi	s0,sp,32
    80001242:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001244:	00000097          	auipc	ra,0x0
    80001248:	c98080e7          	jalr	-872(ra) # 80000edc <myproc>
    8000124c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000124e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001250:	01204c63          	bgtz	s2,80001268 <growproc+0x32>
  } else if(n < 0){
    80001254:	02094663          	bltz	s2,80001280 <growproc+0x4a>
  p->sz = sz;
    80001258:	e4ac                	sd	a1,72(s1)
  return 0;
    8000125a:	4501                	li	a0,0
}
    8000125c:	60e2                	ld	ra,24(sp)
    8000125e:	6442                	ld	s0,16(sp)
    80001260:	64a2                	ld	s1,8(sp)
    80001262:	6902                	ld	s2,0(sp)
    80001264:	6105                	addi	sp,sp,32
    80001266:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001268:	4691                	li	a3,4
    8000126a:	00b90633          	add	a2,s2,a1
    8000126e:	6928                	ld	a0,80(a0)
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	628080e7          	jalr	1576(ra) # 80000898 <uvmalloc>
    80001278:	85aa                	mv	a1,a0
    8000127a:	fd79                	bnez	a0,80001258 <growproc+0x22>
      return -1;
    8000127c:	557d                	li	a0,-1
    8000127e:	bff9                	j	8000125c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001280:	00b90633          	add	a2,s2,a1
    80001284:	6928                	ld	a0,80(a0)
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	5ca080e7          	jalr	1482(ra) # 80000850 <uvmdealloc>
    8000128e:	85aa                	mv	a1,a0
    80001290:	b7e1                	j	80001258 <growproc+0x22>

0000000080001292 <fork>:
{
    80001292:	7139                	addi	sp,sp,-64
    80001294:	fc06                	sd	ra,56(sp)
    80001296:	f822                	sd	s0,48(sp)
    80001298:	f426                	sd	s1,40(sp)
    8000129a:	f04a                	sd	s2,32(sp)
    8000129c:	ec4e                	sd	s3,24(sp)
    8000129e:	e852                	sd	s4,16(sp)
    800012a0:	e456                	sd	s5,8(sp)
    800012a2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	c38080e7          	jalr	-968(ra) # 80000edc <myproc>
    800012ac:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	e38080e7          	jalr	-456(ra) # 800010e6 <allocproc>
    800012b6:	10050c63          	beqz	a0,800013ce <fork+0x13c>
    800012ba:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012bc:	048ab603          	ld	a2,72(s5)
    800012c0:	692c                	ld	a1,80(a0)
    800012c2:	050ab503          	ld	a0,80(s5)
    800012c6:	fffff097          	auipc	ra,0xfffff
    800012ca:	72a080e7          	jalr	1834(ra) # 800009f0 <uvmcopy>
    800012ce:	04054863          	bltz	a0,8000131e <fork+0x8c>
  np->sz = p->sz;
    800012d2:	048ab783          	ld	a5,72(s5)
    800012d6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012da:	058ab683          	ld	a3,88(s5)
    800012de:	87b6                	mv	a5,a3
    800012e0:	058a3703          	ld	a4,88(s4)
    800012e4:	12068693          	addi	a3,a3,288
    800012e8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ec:	6788                	ld	a0,8(a5)
    800012ee:	6b8c                	ld	a1,16(a5)
    800012f0:	6f90                	ld	a2,24(a5)
    800012f2:	01073023          	sd	a6,0(a4)
    800012f6:	e708                	sd	a0,8(a4)
    800012f8:	eb0c                	sd	a1,16(a4)
    800012fa:	ef10                	sd	a2,24(a4)
    800012fc:	02078793          	addi	a5,a5,32
    80001300:	02070713          	addi	a4,a4,32
    80001304:	fed792e3          	bne	a5,a3,800012e8 <fork+0x56>
  np->trapframe->a0 = 0;
    80001308:	058a3783          	ld	a5,88(s4)
    8000130c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001310:	0d0a8493          	addi	s1,s5,208
    80001314:	0d0a0913          	addi	s2,s4,208
    80001318:	150a8993          	addi	s3,s5,336
    8000131c:	a00d                	j	8000133e <fork+0xac>
    freeproc(np);
    8000131e:	8552                	mv	a0,s4
    80001320:	00000097          	auipc	ra,0x0
    80001324:	d6e080e7          	jalr	-658(ra) # 8000108e <freeproc>
    release(&np->lock);
    80001328:	8552                	mv	a0,s4
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	ee8080e7          	jalr	-280(ra) # 80006212 <release>
    return -1;
    80001332:	597d                	li	s2,-1
    80001334:	a059                	j	800013ba <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001336:	04a1                	addi	s1,s1,8
    80001338:	0921                	addi	s2,s2,8
    8000133a:	01348b63          	beq	s1,s3,80001350 <fork+0xbe>
    if(p->ofile[i])
    8000133e:	6088                	ld	a0,0(s1)
    80001340:	d97d                	beqz	a0,80001336 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001342:	00002097          	auipc	ra,0x2
    80001346:	67e080e7          	jalr	1662(ra) # 800039c0 <filedup>
    8000134a:	00a93023          	sd	a0,0(s2)
    8000134e:	b7e5                	j	80001336 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001350:	150ab503          	ld	a0,336(s5)
    80001354:	00002097          	auipc	ra,0x2
    80001358:	816080e7          	jalr	-2026(ra) # 80002b6a <idup>
    8000135c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001360:	4641                	li	a2,16
    80001362:	158a8593          	addi	a1,s5,344
    80001366:	158a0513          	addi	a0,s4,344
    8000136a:	fffff097          	auipc	ra,0xfffff
    8000136e:	f58080e7          	jalr	-168(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001372:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001376:	8552                	mv	a0,s4
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	e9a080e7          	jalr	-358(ra) # 80006212 <release>
  acquire(&wait_lock);
    80001380:	00007497          	auipc	s1,0x7
    80001384:	52848493          	addi	s1,s1,1320 # 800088a8 <wait_lock>
    80001388:	8526                	mv	a0,s1
    8000138a:	00005097          	auipc	ra,0x5
    8000138e:	dd4080e7          	jalr	-556(ra) # 8000615e <acquire>
  np->parent = p;
    80001392:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001396:	8526                	mv	a0,s1
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	e7a080e7          	jalr	-390(ra) # 80006212 <release>
  acquire(&np->lock);
    800013a0:	8552                	mv	a0,s4
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	dbc080e7          	jalr	-580(ra) # 8000615e <acquire>
  np->state = RUNNABLE;
    800013aa:	478d                	li	a5,3
    800013ac:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013b0:	8552                	mv	a0,s4
    800013b2:	00005097          	auipc	ra,0x5
    800013b6:	e60080e7          	jalr	-416(ra) # 80006212 <release>
}
    800013ba:	854a                	mv	a0,s2
    800013bc:	70e2                	ld	ra,56(sp)
    800013be:	7442                	ld	s0,48(sp)
    800013c0:	74a2                	ld	s1,40(sp)
    800013c2:	7902                	ld	s2,32(sp)
    800013c4:	69e2                	ld	s3,24(sp)
    800013c6:	6a42                	ld	s4,16(sp)
    800013c8:	6aa2                	ld	s5,8(sp)
    800013ca:	6121                	addi	sp,sp,64
    800013cc:	8082                	ret
    return -1;
    800013ce:	597d                	li	s2,-1
    800013d0:	b7ed                	j	800013ba <fork+0x128>

00000000800013d2 <scheduler>:
{
    800013d2:	7139                	addi	sp,sp,-64
    800013d4:	fc06                	sd	ra,56(sp)
    800013d6:	f822                	sd	s0,48(sp)
    800013d8:	f426                	sd	s1,40(sp)
    800013da:	f04a                	sd	s2,32(sp)
    800013dc:	ec4e                	sd	s3,24(sp)
    800013de:	e852                	sd	s4,16(sp)
    800013e0:	e456                	sd	s5,8(sp)
    800013e2:	e05a                	sd	s6,0(sp)
    800013e4:	0080                	addi	s0,sp,64
    800013e6:	8792                	mv	a5,tp
  int id = r_tp();
    800013e8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ea:	00779a93          	slli	s5,a5,0x7
    800013ee:	00007717          	auipc	a4,0x7
    800013f2:	4a270713          	addi	a4,a4,1186 # 80008890 <pid_lock>
    800013f6:	9756                	add	a4,a4,s5
    800013f8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013fc:	00007717          	auipc	a4,0x7
    80001400:	4cc70713          	addi	a4,a4,1228 # 800088c8 <cpus+0x8>
    80001404:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001406:	498d                	li	s3,3
        p->state = RUNNING;
    80001408:	4b11                	li	s6,4
        c->proc = p;
    8000140a:	079e                	slli	a5,a5,0x7
    8000140c:	00007a17          	auipc	s4,0x7
    80001410:	484a0a13          	addi	s4,s4,1156 # 80008890 <pid_lock>
    80001414:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001416:	0000d917          	auipc	s2,0xd
    8000141a:	2aa90913          	addi	s2,s2,682 # 8000e6c0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000141e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001422:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001426:	10079073          	csrw	sstatus,a5
    8000142a:	00008497          	auipc	s1,0x8
    8000142e:	89648493          	addi	s1,s1,-1898 # 80008cc0 <proc>
    80001432:	a811                	j	80001446 <scheduler+0x74>
      release(&p->lock);
    80001434:	8526                	mv	a0,s1
    80001436:	00005097          	auipc	ra,0x5
    8000143a:	ddc080e7          	jalr	-548(ra) # 80006212 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000143e:	16848493          	addi	s1,s1,360
    80001442:	fd248ee3          	beq	s1,s2,8000141e <scheduler+0x4c>
      acquire(&p->lock);
    80001446:	8526                	mv	a0,s1
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	d16080e7          	jalr	-746(ra) # 8000615e <acquire>
      if(p->state == RUNNABLE) {
    80001450:	4c9c                	lw	a5,24(s1)
    80001452:	ff3791e3          	bne	a5,s3,80001434 <scheduler+0x62>
        p->state = RUNNING;
    80001456:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000145a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000145e:	06048593          	addi	a1,s1,96
    80001462:	8556                	mv	a0,s5
    80001464:	00000097          	auipc	ra,0x0
    80001468:	684080e7          	jalr	1668(ra) # 80001ae8 <swtch>
        c->proc = 0;
    8000146c:	020a3823          	sd	zero,48(s4)
    80001470:	b7d1                	j	80001434 <scheduler+0x62>

0000000080001472 <sched>:
{
    80001472:	7179                	addi	sp,sp,-48
    80001474:	f406                	sd	ra,40(sp)
    80001476:	f022                	sd	s0,32(sp)
    80001478:	ec26                	sd	s1,24(sp)
    8000147a:	e84a                	sd	s2,16(sp)
    8000147c:	e44e                	sd	s3,8(sp)
    8000147e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001480:	00000097          	auipc	ra,0x0
    80001484:	a5c080e7          	jalr	-1444(ra) # 80000edc <myproc>
    80001488:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000148a:	00005097          	auipc	ra,0x5
    8000148e:	c5a080e7          	jalr	-934(ra) # 800060e4 <holding>
    80001492:	c93d                	beqz	a0,80001508 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001494:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001496:	2781                	sext.w	a5,a5
    80001498:	079e                	slli	a5,a5,0x7
    8000149a:	00007717          	auipc	a4,0x7
    8000149e:	3f670713          	addi	a4,a4,1014 # 80008890 <pid_lock>
    800014a2:	97ba                	add	a5,a5,a4
    800014a4:	0a87a703          	lw	a4,168(a5)
    800014a8:	4785                	li	a5,1
    800014aa:	06f71763          	bne	a4,a5,80001518 <sched+0xa6>
  if(p->state == RUNNING)
    800014ae:	4c98                	lw	a4,24(s1)
    800014b0:	4791                	li	a5,4
    800014b2:	06f70b63          	beq	a4,a5,80001528 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014b6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ba:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014bc:	efb5                	bnez	a5,80001538 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014be:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014c0:	00007917          	auipc	s2,0x7
    800014c4:	3d090913          	addi	s2,s2,976 # 80008890 <pid_lock>
    800014c8:	2781                	sext.w	a5,a5
    800014ca:	079e                	slli	a5,a5,0x7
    800014cc:	97ca                	add	a5,a5,s2
    800014ce:	0ac7a983          	lw	s3,172(a5)
    800014d2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014d4:	2781                	sext.w	a5,a5
    800014d6:	079e                	slli	a5,a5,0x7
    800014d8:	00007597          	auipc	a1,0x7
    800014dc:	3f058593          	addi	a1,a1,1008 # 800088c8 <cpus+0x8>
    800014e0:	95be                	add	a1,a1,a5
    800014e2:	06048513          	addi	a0,s1,96
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	602080e7          	jalr	1538(ra) # 80001ae8 <swtch>
    800014ee:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014f0:	2781                	sext.w	a5,a5
    800014f2:	079e                	slli	a5,a5,0x7
    800014f4:	993e                	add	s2,s2,a5
    800014f6:	0b392623          	sw	s3,172(s2)
}
    800014fa:	70a2                	ld	ra,40(sp)
    800014fc:	7402                	ld	s0,32(sp)
    800014fe:	64e2                	ld	s1,24(sp)
    80001500:	6942                	ld	s2,16(sp)
    80001502:	69a2                	ld	s3,8(sp)
    80001504:	6145                	addi	sp,sp,48
    80001506:	8082                	ret
    panic("sched p->lock");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	c2850513          	addi	a0,a0,-984 # 80008130 <etext+0x130>
    80001510:	00004097          	auipc	ra,0x4
    80001514:	716080e7          	jalr	1814(ra) # 80005c26 <panic>
    panic("sched locks");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	c2850513          	addi	a0,a0,-984 # 80008140 <etext+0x140>
    80001520:	00004097          	auipc	ra,0x4
    80001524:	706080e7          	jalr	1798(ra) # 80005c26 <panic>
    panic("sched running");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	c2850513          	addi	a0,a0,-984 # 80008150 <etext+0x150>
    80001530:	00004097          	auipc	ra,0x4
    80001534:	6f6080e7          	jalr	1782(ra) # 80005c26 <panic>
    panic("sched interruptible");
    80001538:	00007517          	auipc	a0,0x7
    8000153c:	c2850513          	addi	a0,a0,-984 # 80008160 <etext+0x160>
    80001540:	00004097          	auipc	ra,0x4
    80001544:	6e6080e7          	jalr	1766(ra) # 80005c26 <panic>

0000000080001548 <yield>:
{
    80001548:	1101                	addi	sp,sp,-32
    8000154a:	ec06                	sd	ra,24(sp)
    8000154c:	e822                	sd	s0,16(sp)
    8000154e:	e426                	sd	s1,8(sp)
    80001550:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001552:	00000097          	auipc	ra,0x0
    80001556:	98a080e7          	jalr	-1654(ra) # 80000edc <myproc>
    8000155a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	c02080e7          	jalr	-1022(ra) # 8000615e <acquire>
  p->state = RUNNABLE;
    80001564:	478d                	li	a5,3
    80001566:	cc9c                	sw	a5,24(s1)
  sched();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	f0a080e7          	jalr	-246(ra) # 80001472 <sched>
  release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	ca0080e7          	jalr	-864(ra) # 80006212 <release>
}
    8000157a:	60e2                	ld	ra,24(sp)
    8000157c:	6442                	ld	s0,16(sp)
    8000157e:	64a2                	ld	s1,8(sp)
    80001580:	6105                	addi	sp,sp,32
    80001582:	8082                	ret

0000000080001584 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001584:	7179                	addi	sp,sp,-48
    80001586:	f406                	sd	ra,40(sp)
    80001588:	f022                	sd	s0,32(sp)
    8000158a:	ec26                	sd	s1,24(sp)
    8000158c:	e84a                	sd	s2,16(sp)
    8000158e:	e44e                	sd	s3,8(sp)
    80001590:	1800                	addi	s0,sp,48
    80001592:	89aa                	mv	s3,a0
    80001594:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	946080e7          	jalr	-1722(ra) # 80000edc <myproc>
    8000159e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	bbe080e7          	jalr	-1090(ra) # 8000615e <acquire>
  release(lk);
    800015a8:	854a                	mv	a0,s2
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	c68080e7          	jalr	-920(ra) # 80006212 <release>

  // Go to sleep.
  p->chan = chan;
    800015b2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015b6:	4789                	li	a5,2
    800015b8:	cc9c                	sw	a5,24(s1)

  sched();
    800015ba:	00000097          	auipc	ra,0x0
    800015be:	eb8080e7          	jalr	-328(ra) # 80001472 <sched>

  // Tidy up.
  p->chan = 0;
    800015c2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015c6:	8526                	mv	a0,s1
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	c4a080e7          	jalr	-950(ra) # 80006212 <release>
  acquire(lk);
    800015d0:	854a                	mv	a0,s2
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	b8c080e7          	jalr	-1140(ra) # 8000615e <acquire>
}
    800015da:	70a2                	ld	ra,40(sp)
    800015dc:	7402                	ld	s0,32(sp)
    800015de:	64e2                	ld	s1,24(sp)
    800015e0:	6942                	ld	s2,16(sp)
    800015e2:	69a2                	ld	s3,8(sp)
    800015e4:	6145                	addi	sp,sp,48
    800015e6:	8082                	ret

00000000800015e8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015e8:	7139                	addi	sp,sp,-64
    800015ea:	fc06                	sd	ra,56(sp)
    800015ec:	f822                	sd	s0,48(sp)
    800015ee:	f426                	sd	s1,40(sp)
    800015f0:	f04a                	sd	s2,32(sp)
    800015f2:	ec4e                	sd	s3,24(sp)
    800015f4:	e852                	sd	s4,16(sp)
    800015f6:	e456                	sd	s5,8(sp)
    800015f8:	0080                	addi	s0,sp,64
    800015fa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015fc:	00007497          	auipc	s1,0x7
    80001600:	6c448493          	addi	s1,s1,1732 # 80008cc0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001604:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001606:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001608:	0000d917          	auipc	s2,0xd
    8000160c:	0b890913          	addi	s2,s2,184 # 8000e6c0 <tickslock>
    80001610:	a811                	j	80001624 <wakeup+0x3c>
      }
      release(&p->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	00005097          	auipc	ra,0x5
    80001618:	bfe080e7          	jalr	-1026(ra) # 80006212 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000161c:	16848493          	addi	s1,s1,360
    80001620:	03248663          	beq	s1,s2,8000164c <wakeup+0x64>
    if(p != myproc()){
    80001624:	00000097          	auipc	ra,0x0
    80001628:	8b8080e7          	jalr	-1864(ra) # 80000edc <myproc>
    8000162c:	fea488e3          	beq	s1,a0,8000161c <wakeup+0x34>
      acquire(&p->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	b2c080e7          	jalr	-1236(ra) # 8000615e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000163a:	4c9c                	lw	a5,24(s1)
    8000163c:	fd379be3          	bne	a5,s3,80001612 <wakeup+0x2a>
    80001640:	709c                	ld	a5,32(s1)
    80001642:	fd4798e3          	bne	a5,s4,80001612 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001646:	0154ac23          	sw	s5,24(s1)
    8000164a:	b7e1                	j	80001612 <wakeup+0x2a>
    }
  }
}
    8000164c:	70e2                	ld	ra,56(sp)
    8000164e:	7442                	ld	s0,48(sp)
    80001650:	74a2                	ld	s1,40(sp)
    80001652:	7902                	ld	s2,32(sp)
    80001654:	69e2                	ld	s3,24(sp)
    80001656:	6a42                	ld	s4,16(sp)
    80001658:	6aa2                	ld	s5,8(sp)
    8000165a:	6121                	addi	sp,sp,64
    8000165c:	8082                	ret

000000008000165e <reparent>:
{
    8000165e:	7179                	addi	sp,sp,-48
    80001660:	f406                	sd	ra,40(sp)
    80001662:	f022                	sd	s0,32(sp)
    80001664:	ec26                	sd	s1,24(sp)
    80001666:	e84a                	sd	s2,16(sp)
    80001668:	e44e                	sd	s3,8(sp)
    8000166a:	e052                	sd	s4,0(sp)
    8000166c:	1800                	addi	s0,sp,48
    8000166e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001670:	00007497          	auipc	s1,0x7
    80001674:	65048493          	addi	s1,s1,1616 # 80008cc0 <proc>
      pp->parent = initproc;
    80001678:	00007a17          	auipc	s4,0x7
    8000167c:	1d8a0a13          	addi	s4,s4,472 # 80008850 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001680:	0000d997          	auipc	s3,0xd
    80001684:	04098993          	addi	s3,s3,64 # 8000e6c0 <tickslock>
    80001688:	a029                	j	80001692 <reparent+0x34>
    8000168a:	16848493          	addi	s1,s1,360
    8000168e:	01348d63          	beq	s1,s3,800016a8 <reparent+0x4a>
    if(pp->parent == p){
    80001692:	7c9c                	ld	a5,56(s1)
    80001694:	ff279be3          	bne	a5,s2,8000168a <reparent+0x2c>
      pp->parent = initproc;
    80001698:	000a3503          	ld	a0,0(s4)
    8000169c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	f4a080e7          	jalr	-182(ra) # 800015e8 <wakeup>
    800016a6:	b7d5                	j	8000168a <reparent+0x2c>
}
    800016a8:	70a2                	ld	ra,40(sp)
    800016aa:	7402                	ld	s0,32(sp)
    800016ac:	64e2                	ld	s1,24(sp)
    800016ae:	6942                	ld	s2,16(sp)
    800016b0:	69a2                	ld	s3,8(sp)
    800016b2:	6a02                	ld	s4,0(sp)
    800016b4:	6145                	addi	sp,sp,48
    800016b6:	8082                	ret

00000000800016b8 <exit>:
{
    800016b8:	7179                	addi	sp,sp,-48
    800016ba:	f406                	sd	ra,40(sp)
    800016bc:	f022                	sd	s0,32(sp)
    800016be:	ec26                	sd	s1,24(sp)
    800016c0:	e84a                	sd	s2,16(sp)
    800016c2:	e44e                	sd	s3,8(sp)
    800016c4:	e052                	sd	s4,0(sp)
    800016c6:	1800                	addi	s0,sp,48
    800016c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	812080e7          	jalr	-2030(ra) # 80000edc <myproc>
    800016d2:	89aa                	mv	s3,a0
  if(p == initproc)
    800016d4:	00007797          	auipc	a5,0x7
    800016d8:	17c7b783          	ld	a5,380(a5) # 80008850 <initproc>
    800016dc:	0d050493          	addi	s1,a0,208
    800016e0:	15050913          	addi	s2,a0,336
    800016e4:	02a79363          	bne	a5,a0,8000170a <exit+0x52>
    panic("init exiting");
    800016e8:	00007517          	auipc	a0,0x7
    800016ec:	a9050513          	addi	a0,a0,-1392 # 80008178 <etext+0x178>
    800016f0:	00004097          	auipc	ra,0x4
    800016f4:	536080e7          	jalr	1334(ra) # 80005c26 <panic>
      fileclose(f);
    800016f8:	00002097          	auipc	ra,0x2
    800016fc:	31a080e7          	jalr	794(ra) # 80003a12 <fileclose>
      p->ofile[fd] = 0;
    80001700:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001704:	04a1                	addi	s1,s1,8
    80001706:	01248563          	beq	s1,s2,80001710 <exit+0x58>
    if(p->ofile[fd]){
    8000170a:	6088                	ld	a0,0(s1)
    8000170c:	f575                	bnez	a0,800016f8 <exit+0x40>
    8000170e:	bfdd                	j	80001704 <exit+0x4c>
  begin_op();
    80001710:	00002097          	auipc	ra,0x2
    80001714:	e3e080e7          	jalr	-450(ra) # 8000354e <begin_op>
  iput(p->cwd);
    80001718:	1509b503          	ld	a0,336(s3)
    8000171c:	00001097          	auipc	ra,0x1
    80001720:	646080e7          	jalr	1606(ra) # 80002d62 <iput>
  end_op();
    80001724:	00002097          	auipc	ra,0x2
    80001728:	ea4080e7          	jalr	-348(ra) # 800035c8 <end_op>
  p->cwd = 0;
    8000172c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001730:	00007497          	auipc	s1,0x7
    80001734:	17848493          	addi	s1,s1,376 # 800088a8 <wait_lock>
    80001738:	8526                	mv	a0,s1
    8000173a:	00005097          	auipc	ra,0x5
    8000173e:	a24080e7          	jalr	-1500(ra) # 8000615e <acquire>
  reparent(p);
    80001742:	854e                	mv	a0,s3
    80001744:	00000097          	auipc	ra,0x0
    80001748:	f1a080e7          	jalr	-230(ra) # 8000165e <reparent>
  wakeup(p->parent);
    8000174c:	0389b503          	ld	a0,56(s3)
    80001750:	00000097          	auipc	ra,0x0
    80001754:	e98080e7          	jalr	-360(ra) # 800015e8 <wakeup>
  acquire(&p->lock);
    80001758:	854e                	mv	a0,s3
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	a04080e7          	jalr	-1532(ra) # 8000615e <acquire>
  p->xstate = status;
    80001762:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001766:	4795                	li	a5,5
    80001768:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	aa4080e7          	jalr	-1372(ra) # 80006212 <release>
  sched();
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	cfc080e7          	jalr	-772(ra) # 80001472 <sched>
  panic("zombie exit");
    8000177e:	00007517          	auipc	a0,0x7
    80001782:	a0a50513          	addi	a0,a0,-1526 # 80008188 <etext+0x188>
    80001786:	00004097          	auipc	ra,0x4
    8000178a:	4a0080e7          	jalr	1184(ra) # 80005c26 <panic>

000000008000178e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000178e:	7179                	addi	sp,sp,-48
    80001790:	f406                	sd	ra,40(sp)
    80001792:	f022                	sd	s0,32(sp)
    80001794:	ec26                	sd	s1,24(sp)
    80001796:	e84a                	sd	s2,16(sp)
    80001798:	e44e                	sd	s3,8(sp)
    8000179a:	1800                	addi	s0,sp,48
    8000179c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000179e:	00007497          	auipc	s1,0x7
    800017a2:	52248493          	addi	s1,s1,1314 # 80008cc0 <proc>
    800017a6:	0000d997          	auipc	s3,0xd
    800017aa:	f1a98993          	addi	s3,s3,-230 # 8000e6c0 <tickslock>
    acquire(&p->lock);
    800017ae:	8526                	mv	a0,s1
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	9ae080e7          	jalr	-1618(ra) # 8000615e <acquire>
    if(p->pid == pid){
    800017b8:	589c                	lw	a5,48(s1)
    800017ba:	01278d63          	beq	a5,s2,800017d4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	a52080e7          	jalr	-1454(ra) # 80006212 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017c8:	16848493          	addi	s1,s1,360
    800017cc:	ff3491e3          	bne	s1,s3,800017ae <kill+0x20>
  }
  return -1;
    800017d0:	557d                	li	a0,-1
    800017d2:	a829                	j	800017ec <kill+0x5e>
      p->killed = 1;
    800017d4:	4785                	li	a5,1
    800017d6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017d8:	4c98                	lw	a4,24(s1)
    800017da:	4789                	li	a5,2
    800017dc:	00f70f63          	beq	a4,a5,800017fa <kill+0x6c>
      release(&p->lock);
    800017e0:	8526                	mv	a0,s1
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	a30080e7          	jalr	-1488(ra) # 80006212 <release>
      return 0;
    800017ea:	4501                	li	a0,0
}
    800017ec:	70a2                	ld	ra,40(sp)
    800017ee:	7402                	ld	s0,32(sp)
    800017f0:	64e2                	ld	s1,24(sp)
    800017f2:	6942                	ld	s2,16(sp)
    800017f4:	69a2                	ld	s3,8(sp)
    800017f6:	6145                	addi	sp,sp,48
    800017f8:	8082                	ret
        p->state = RUNNABLE;
    800017fa:	478d                	li	a5,3
    800017fc:	cc9c                	sw	a5,24(s1)
    800017fe:	b7cd                	j	800017e0 <kill+0x52>

0000000080001800 <setkilled>:

void
setkilled(struct proc *p)
{
    80001800:	1101                	addi	sp,sp,-32
    80001802:	ec06                	sd	ra,24(sp)
    80001804:	e822                	sd	s0,16(sp)
    80001806:	e426                	sd	s1,8(sp)
    80001808:	1000                	addi	s0,sp,32
    8000180a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	952080e7          	jalr	-1710(ra) # 8000615e <acquire>
  p->killed = 1;
    80001814:	4785                	li	a5,1
    80001816:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	9f8080e7          	jalr	-1544(ra) # 80006212 <release>
}
    80001822:	60e2                	ld	ra,24(sp)
    80001824:	6442                	ld	s0,16(sp)
    80001826:	64a2                	ld	s1,8(sp)
    80001828:	6105                	addi	sp,sp,32
    8000182a:	8082                	ret

000000008000182c <killed>:

int
killed(struct proc *p)
{
    8000182c:	1101                	addi	sp,sp,-32
    8000182e:	ec06                	sd	ra,24(sp)
    80001830:	e822                	sd	s0,16(sp)
    80001832:	e426                	sd	s1,8(sp)
    80001834:	e04a                	sd	s2,0(sp)
    80001836:	1000                	addi	s0,sp,32
    80001838:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	924080e7          	jalr	-1756(ra) # 8000615e <acquire>
  k = p->killed;
    80001842:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001846:	8526                	mv	a0,s1
    80001848:	00005097          	auipc	ra,0x5
    8000184c:	9ca080e7          	jalr	-1590(ra) # 80006212 <release>
  return k;
}
    80001850:	854a                	mv	a0,s2
    80001852:	60e2                	ld	ra,24(sp)
    80001854:	6442                	ld	s0,16(sp)
    80001856:	64a2                	ld	s1,8(sp)
    80001858:	6902                	ld	s2,0(sp)
    8000185a:	6105                	addi	sp,sp,32
    8000185c:	8082                	ret

000000008000185e <wait>:
{
    8000185e:	715d                	addi	sp,sp,-80
    80001860:	e486                	sd	ra,72(sp)
    80001862:	e0a2                	sd	s0,64(sp)
    80001864:	fc26                	sd	s1,56(sp)
    80001866:	f84a                	sd	s2,48(sp)
    80001868:	f44e                	sd	s3,40(sp)
    8000186a:	f052                	sd	s4,32(sp)
    8000186c:	ec56                	sd	s5,24(sp)
    8000186e:	e85a                	sd	s6,16(sp)
    80001870:	e45e                	sd	s7,8(sp)
    80001872:	e062                	sd	s8,0(sp)
    80001874:	0880                	addi	s0,sp,80
    80001876:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001878:	fffff097          	auipc	ra,0xfffff
    8000187c:	664080e7          	jalr	1636(ra) # 80000edc <myproc>
    80001880:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001882:	00007517          	auipc	a0,0x7
    80001886:	02650513          	addi	a0,a0,38 # 800088a8 <wait_lock>
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	8d4080e7          	jalr	-1836(ra) # 8000615e <acquire>
    havekids = 0;
    80001892:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001894:	4a15                	li	s4,5
        havekids = 1;
    80001896:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001898:	0000d997          	auipc	s3,0xd
    8000189c:	e2898993          	addi	s3,s3,-472 # 8000e6c0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018a0:	00007c17          	auipc	s8,0x7
    800018a4:	008c0c13          	addi	s8,s8,8 # 800088a8 <wait_lock>
    800018a8:	a0d1                	j	8000196c <wait+0x10e>
          pid = pp->pid;
    800018aa:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018ae:	000b0e63          	beqz	s6,800018ca <wait+0x6c>
    800018b2:	4691                	li	a3,4
    800018b4:	02c48613          	addi	a2,s1,44
    800018b8:	85da                	mv	a1,s6
    800018ba:	05093503          	ld	a0,80(s2)
    800018be:	fffff097          	auipc	ra,0xfffff
    800018c2:	2de080e7          	jalr	734(ra) # 80000b9c <copyout>
    800018c6:	04054163          	bltz	a0,80001908 <wait+0xaa>
          freeproc(pp);
    800018ca:	8526                	mv	a0,s1
    800018cc:	fffff097          	auipc	ra,0xfffff
    800018d0:	7c2080e7          	jalr	1986(ra) # 8000108e <freeproc>
          release(&pp->lock);
    800018d4:	8526                	mv	a0,s1
    800018d6:	00005097          	auipc	ra,0x5
    800018da:	93c080e7          	jalr	-1732(ra) # 80006212 <release>
          release(&wait_lock);
    800018de:	00007517          	auipc	a0,0x7
    800018e2:	fca50513          	addi	a0,a0,-54 # 800088a8 <wait_lock>
    800018e6:	00005097          	auipc	ra,0x5
    800018ea:	92c080e7          	jalr	-1748(ra) # 80006212 <release>
}
    800018ee:	854e                	mv	a0,s3
    800018f0:	60a6                	ld	ra,72(sp)
    800018f2:	6406                	ld	s0,64(sp)
    800018f4:	74e2                	ld	s1,56(sp)
    800018f6:	7942                	ld	s2,48(sp)
    800018f8:	79a2                	ld	s3,40(sp)
    800018fa:	7a02                	ld	s4,32(sp)
    800018fc:	6ae2                	ld	s5,24(sp)
    800018fe:	6b42                	ld	s6,16(sp)
    80001900:	6ba2                	ld	s7,8(sp)
    80001902:	6c02                	ld	s8,0(sp)
    80001904:	6161                	addi	sp,sp,80
    80001906:	8082                	ret
            release(&pp->lock);
    80001908:	8526                	mv	a0,s1
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	908080e7          	jalr	-1784(ra) # 80006212 <release>
            release(&wait_lock);
    80001912:	00007517          	auipc	a0,0x7
    80001916:	f9650513          	addi	a0,a0,-106 # 800088a8 <wait_lock>
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	8f8080e7          	jalr	-1800(ra) # 80006212 <release>
            return -1;
    80001922:	59fd                	li	s3,-1
    80001924:	b7e9                	j	800018ee <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001926:	16848493          	addi	s1,s1,360
    8000192a:	03348463          	beq	s1,s3,80001952 <wait+0xf4>
      if(pp->parent == p){
    8000192e:	7c9c                	ld	a5,56(s1)
    80001930:	ff279be3          	bne	a5,s2,80001926 <wait+0xc8>
        acquire(&pp->lock);
    80001934:	8526                	mv	a0,s1
    80001936:	00005097          	auipc	ra,0x5
    8000193a:	828080e7          	jalr	-2008(ra) # 8000615e <acquire>
        if(pp->state == ZOMBIE){
    8000193e:	4c9c                	lw	a5,24(s1)
    80001940:	f74785e3          	beq	a5,s4,800018aa <wait+0x4c>
        release(&pp->lock);
    80001944:	8526                	mv	a0,s1
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	8cc080e7          	jalr	-1844(ra) # 80006212 <release>
        havekids = 1;
    8000194e:	8756                	mv	a4,s5
    80001950:	bfd9                	j	80001926 <wait+0xc8>
    if(!havekids || killed(p)){
    80001952:	c31d                	beqz	a4,80001978 <wait+0x11a>
    80001954:	854a                	mv	a0,s2
    80001956:	00000097          	auipc	ra,0x0
    8000195a:	ed6080e7          	jalr	-298(ra) # 8000182c <killed>
    8000195e:	ed09                	bnez	a0,80001978 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001960:	85e2                	mv	a1,s8
    80001962:	854a                	mv	a0,s2
    80001964:	00000097          	auipc	ra,0x0
    80001968:	c20080e7          	jalr	-992(ra) # 80001584 <sleep>
    havekids = 0;
    8000196c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000196e:	00007497          	auipc	s1,0x7
    80001972:	35248493          	addi	s1,s1,850 # 80008cc0 <proc>
    80001976:	bf65                	j	8000192e <wait+0xd0>
      release(&wait_lock);
    80001978:	00007517          	auipc	a0,0x7
    8000197c:	f3050513          	addi	a0,a0,-208 # 800088a8 <wait_lock>
    80001980:	00005097          	auipc	ra,0x5
    80001984:	892080e7          	jalr	-1902(ra) # 80006212 <release>
      return -1;
    80001988:	59fd                	li	s3,-1
    8000198a:	b795                	j	800018ee <wait+0x90>

000000008000198c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000198c:	7179                	addi	sp,sp,-48
    8000198e:	f406                	sd	ra,40(sp)
    80001990:	f022                	sd	s0,32(sp)
    80001992:	ec26                	sd	s1,24(sp)
    80001994:	e84a                	sd	s2,16(sp)
    80001996:	e44e                	sd	s3,8(sp)
    80001998:	e052                	sd	s4,0(sp)
    8000199a:	1800                	addi	s0,sp,48
    8000199c:	84aa                	mv	s1,a0
    8000199e:	892e                	mv	s2,a1
    800019a0:	89b2                	mv	s3,a2
    800019a2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	538080e7          	jalr	1336(ra) # 80000edc <myproc>
  if(user_dst){
    800019ac:	c08d                	beqz	s1,800019ce <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019ae:	86d2                	mv	a3,s4
    800019b0:	864e                	mv	a2,s3
    800019b2:	85ca                	mv	a1,s2
    800019b4:	6928                	ld	a0,80(a0)
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	1e6080e7          	jalr	486(ra) # 80000b9c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019be:	70a2                	ld	ra,40(sp)
    800019c0:	7402                	ld	s0,32(sp)
    800019c2:	64e2                	ld	s1,24(sp)
    800019c4:	6942                	ld	s2,16(sp)
    800019c6:	69a2                	ld	s3,8(sp)
    800019c8:	6a02                	ld	s4,0(sp)
    800019ca:	6145                	addi	sp,sp,48
    800019cc:	8082                	ret
    memmove((char *)dst, src, len);
    800019ce:	000a061b          	sext.w	a2,s4
    800019d2:	85ce                	mv	a1,s3
    800019d4:	854a                	mv	a0,s2
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	800080e7          	jalr	-2048(ra) # 800001d6 <memmove>
    return 0;
    800019de:	8526                	mv	a0,s1
    800019e0:	bff9                	j	800019be <either_copyout+0x32>

00000000800019e2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019e2:	7179                	addi	sp,sp,-48
    800019e4:	f406                	sd	ra,40(sp)
    800019e6:	f022                	sd	s0,32(sp)
    800019e8:	ec26                	sd	s1,24(sp)
    800019ea:	e84a                	sd	s2,16(sp)
    800019ec:	e44e                	sd	s3,8(sp)
    800019ee:	e052                	sd	s4,0(sp)
    800019f0:	1800                	addi	s0,sp,48
    800019f2:	892a                	mv	s2,a0
    800019f4:	84ae                	mv	s1,a1
    800019f6:	89b2                	mv	s3,a2
    800019f8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019fa:	fffff097          	auipc	ra,0xfffff
    800019fe:	4e2080e7          	jalr	1250(ra) # 80000edc <myproc>
  if(user_src){
    80001a02:	c08d                	beqz	s1,80001a24 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a04:	86d2                	mv	a3,s4
    80001a06:	864e                	mv	a2,s3
    80001a08:	85ca                	mv	a1,s2
    80001a0a:	6928                	ld	a0,80(a0)
    80001a0c:	fffff097          	auipc	ra,0xfffff
    80001a10:	21c080e7          	jalr	540(ra) # 80000c28 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a14:	70a2                	ld	ra,40(sp)
    80001a16:	7402                	ld	s0,32(sp)
    80001a18:	64e2                	ld	s1,24(sp)
    80001a1a:	6942                	ld	s2,16(sp)
    80001a1c:	69a2                	ld	s3,8(sp)
    80001a1e:	6a02                	ld	s4,0(sp)
    80001a20:	6145                	addi	sp,sp,48
    80001a22:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a24:	000a061b          	sext.w	a2,s4
    80001a28:	85ce                	mv	a1,s3
    80001a2a:	854a                	mv	a0,s2
    80001a2c:	ffffe097          	auipc	ra,0xffffe
    80001a30:	7aa080e7          	jalr	1962(ra) # 800001d6 <memmove>
    return 0;
    80001a34:	8526                	mv	a0,s1
    80001a36:	bff9                	j	80001a14 <either_copyin+0x32>

0000000080001a38 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a38:	715d                	addi	sp,sp,-80
    80001a3a:	e486                	sd	ra,72(sp)
    80001a3c:	e0a2                	sd	s0,64(sp)
    80001a3e:	fc26                	sd	s1,56(sp)
    80001a40:	f84a                	sd	s2,48(sp)
    80001a42:	f44e                	sd	s3,40(sp)
    80001a44:	f052                	sd	s4,32(sp)
    80001a46:	ec56                	sd	s5,24(sp)
    80001a48:	e85a                	sd	s6,16(sp)
    80001a4a:	e45e                	sd	s7,8(sp)
    80001a4c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a4e:	00006517          	auipc	a0,0x6
    80001a52:	5fa50513          	addi	a0,a0,1530 # 80008048 <etext+0x48>
    80001a56:	00004097          	auipc	ra,0x4
    80001a5a:	21a080e7          	jalr	538(ra) # 80005c70 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a5e:	00007497          	auipc	s1,0x7
    80001a62:	3ba48493          	addi	s1,s1,954 # 80008e18 <proc+0x158>
    80001a66:	0000d917          	auipc	s2,0xd
    80001a6a:	db290913          	addi	s2,s2,-590 # 8000e818 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a6e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a70:	00006997          	auipc	s3,0x6
    80001a74:	72898993          	addi	s3,s3,1832 # 80008198 <etext+0x198>
    printf("%d %s %s", p->pid, state, p->name);
    80001a78:	00006a97          	auipc	s5,0x6
    80001a7c:	728a8a93          	addi	s5,s5,1832 # 800081a0 <etext+0x1a0>
    printf("\n");
    80001a80:	00006a17          	auipc	s4,0x6
    80001a84:	5c8a0a13          	addi	s4,s4,1480 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a88:	00006b97          	auipc	s7,0x6
    80001a8c:	758b8b93          	addi	s7,s7,1880 # 800081e0 <states.0>
    80001a90:	a00d                	j	80001ab2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a92:	ed86a583          	lw	a1,-296(a3)
    80001a96:	8556                	mv	a0,s5
    80001a98:	00004097          	auipc	ra,0x4
    80001a9c:	1d8080e7          	jalr	472(ra) # 80005c70 <printf>
    printf("\n");
    80001aa0:	8552                	mv	a0,s4
    80001aa2:	00004097          	auipc	ra,0x4
    80001aa6:	1ce080e7          	jalr	462(ra) # 80005c70 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aaa:	16848493          	addi	s1,s1,360
    80001aae:	03248263          	beq	s1,s2,80001ad2 <procdump+0x9a>
    if(p->state == UNUSED)
    80001ab2:	86a6                	mv	a3,s1
    80001ab4:	ec04a783          	lw	a5,-320(s1)
    80001ab8:	dbed                	beqz	a5,80001aaa <procdump+0x72>
      state = "???";
    80001aba:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001abc:	fcfb6be3          	bltu	s6,a5,80001a92 <procdump+0x5a>
    80001ac0:	02079713          	slli	a4,a5,0x20
    80001ac4:	01d75793          	srli	a5,a4,0x1d
    80001ac8:	97de                	add	a5,a5,s7
    80001aca:	6390                	ld	a2,0(a5)
    80001acc:	f279                	bnez	a2,80001a92 <procdump+0x5a>
      state = "???";
    80001ace:	864e                	mv	a2,s3
    80001ad0:	b7c9                	j	80001a92 <procdump+0x5a>
  }
}
    80001ad2:	60a6                	ld	ra,72(sp)
    80001ad4:	6406                	ld	s0,64(sp)
    80001ad6:	74e2                	ld	s1,56(sp)
    80001ad8:	7942                	ld	s2,48(sp)
    80001ada:	79a2                	ld	s3,40(sp)
    80001adc:	7a02                	ld	s4,32(sp)
    80001ade:	6ae2                	ld	s5,24(sp)
    80001ae0:	6b42                	ld	s6,16(sp)
    80001ae2:	6ba2                	ld	s7,8(sp)
    80001ae4:	6161                	addi	sp,sp,80
    80001ae6:	8082                	ret

0000000080001ae8 <swtch>:
    80001ae8:	00153023          	sd	ra,0(a0)
    80001aec:	00253423          	sd	sp,8(a0)
    80001af0:	e900                	sd	s0,16(a0)
    80001af2:	ed04                	sd	s1,24(a0)
    80001af4:	03253023          	sd	s2,32(a0)
    80001af8:	03353423          	sd	s3,40(a0)
    80001afc:	03453823          	sd	s4,48(a0)
    80001b00:	03553c23          	sd	s5,56(a0)
    80001b04:	05653023          	sd	s6,64(a0)
    80001b08:	05753423          	sd	s7,72(a0)
    80001b0c:	05853823          	sd	s8,80(a0)
    80001b10:	05953c23          	sd	s9,88(a0)
    80001b14:	07a53023          	sd	s10,96(a0)
    80001b18:	07b53423          	sd	s11,104(a0)
    80001b1c:	0005b083          	ld	ra,0(a1)
    80001b20:	0085b103          	ld	sp,8(a1)
    80001b24:	6980                	ld	s0,16(a1)
    80001b26:	6d84                	ld	s1,24(a1)
    80001b28:	0205b903          	ld	s2,32(a1)
    80001b2c:	0285b983          	ld	s3,40(a1)
    80001b30:	0305ba03          	ld	s4,48(a1)
    80001b34:	0385ba83          	ld	s5,56(a1)
    80001b38:	0405bb03          	ld	s6,64(a1)
    80001b3c:	0485bb83          	ld	s7,72(a1)
    80001b40:	0505bc03          	ld	s8,80(a1)
    80001b44:	0585bc83          	ld	s9,88(a1)
    80001b48:	0605bd03          	ld	s10,96(a1)
    80001b4c:	0685bd83          	ld	s11,104(a1)
    80001b50:	8082                	ret

0000000080001b52 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001b52:	1141                	addi	sp,sp,-16
    80001b54:	e406                	sd	ra,8(sp)
    80001b56:	e022                	sd	s0,0(sp)
    80001b58:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b5a:	00006597          	auipc	a1,0x6
    80001b5e:	6b658593          	addi	a1,a1,1718 # 80008210 <states.0+0x30>
    80001b62:	0000d517          	auipc	a0,0xd
    80001b66:	b5e50513          	addi	a0,a0,-1186 # 8000e6c0 <tickslock>
    80001b6a:	00004097          	auipc	ra,0x4
    80001b6e:	564080e7          	jalr	1380(ra) # 800060ce <initlock>
}
    80001b72:	60a2                	ld	ra,8(sp)
    80001b74:	6402                	ld	s0,0(sp)
    80001b76:	0141                	addi	sp,sp,16
    80001b78:	8082                	ret

0000000080001b7a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001b7a:	1141                	addi	sp,sp,-16
    80001b7c:	e422                	sd	s0,8(sp)
    80001b7e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b80:	00003797          	auipc	a5,0x3
    80001b84:	4e078793          	addi	a5,a5,1248 # 80005060 <kernelvec>
    80001b88:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b8c:	6422                	ld	s0,8(sp)
    80001b8e:	0141                	addi	sp,sp,16
    80001b90:	8082                	ret

0000000080001b92 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b92:	1141                	addi	sp,sp,-16
    80001b94:	e406                	sd	ra,8(sp)
    80001b96:	e022                	sd	s0,0(sp)
    80001b98:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b9a:	fffff097          	auipc	ra,0xfffff
    80001b9e:	342080e7          	jalr	834(ra) # 80000edc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ba6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bac:	00005697          	auipc	a3,0x5
    80001bb0:	45468693          	addi	a3,a3,1108 # 80007000 <_trampoline>
    80001bb4:	00005717          	auipc	a4,0x5
    80001bb8:	44c70713          	addi	a4,a4,1100 # 80007000 <_trampoline>
    80001bbc:	8f15                	sub	a4,a4,a3
    80001bbe:	040007b7          	lui	a5,0x4000
    80001bc2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bc4:	07b2                	slli	a5,a5,0xc
    80001bc6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc8:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bcc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bce:	18002673          	csrr	a2,satp
    80001bd2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bd4:	6d30                	ld	a2,88(a0)
    80001bd6:	6138                	ld	a4,64(a0)
    80001bd8:	6585                	lui	a1,0x1
    80001bda:	972e                	add	a4,a4,a1
    80001bdc:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bde:	6d38                	ld	a4,88(a0)
    80001be0:	00000617          	auipc	a2,0x0
    80001be4:	13460613          	addi	a2,a2,308 # 80001d14 <usertrap>
    80001be8:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001bea:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bec:	8612                	mv	a2,tp
    80001bee:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bf4:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bf8:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bfc:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c00:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c02:	6f18                	ld	a4,24(a4)
    80001c04:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c08:	6928                	ld	a0,80(a0)
    80001c0a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c0c:	00005717          	auipc	a4,0x5
    80001c10:	49070713          	addi	a4,a4,1168 # 8000709c <userret>
    80001c14:	8f15                	sub	a4,a4,a3
    80001c16:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c18:	577d                	li	a4,-1
    80001c1a:	177e                	slli	a4,a4,0x3f
    80001c1c:	8d59                	or	a0,a0,a4
    80001c1e:	9782                	jalr	a5
}
    80001c20:	60a2                	ld	ra,8(sp)
    80001c22:	6402                	ld	s0,0(sp)
    80001c24:	0141                	addi	sp,sp,16
    80001c26:	8082                	ret

0000000080001c28 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001c28:	1101                	addi	sp,sp,-32
    80001c2a:	ec06                	sd	ra,24(sp)
    80001c2c:	e822                	sd	s0,16(sp)
    80001c2e:	e426                	sd	s1,8(sp)
    80001c30:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c32:	0000d497          	auipc	s1,0xd
    80001c36:	a8e48493          	addi	s1,s1,-1394 # 8000e6c0 <tickslock>
    80001c3a:	8526                	mv	a0,s1
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	522080e7          	jalr	1314(ra) # 8000615e <acquire>
  ticks++;
    80001c44:	00007517          	auipc	a0,0x7
    80001c48:	c1450513          	addi	a0,a0,-1004 # 80008858 <ticks>
    80001c4c:	411c                	lw	a5,0(a0)
    80001c4e:	2785                	addiw	a5,a5,1
    80001c50:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c52:	00000097          	auipc	ra,0x0
    80001c56:	996080e7          	jalr	-1642(ra) # 800015e8 <wakeup>
  release(&tickslock);
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	5b6080e7          	jalr	1462(ra) # 80006212 <release>
}
    80001c64:	60e2                	ld	ra,24(sp)
    80001c66:	6442                	ld	s0,16(sp)
    80001c68:	64a2                	ld	s1,8(sp)
    80001c6a:	6105                	addi	sp,sp,32
    80001c6c:	8082                	ret

0000000080001c6e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6e:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80001c72:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80001c74:	0807df63          	bgez	a5,80001d12 <devintr+0xa4>
{
    80001c78:	1101                	addi	sp,sp,-32
    80001c7a:	ec06                	sd	ra,24(sp)
    80001c7c:	e822                	sd	s0,16(sp)
    80001c7e:	e426                	sd	s1,8(sp)
    80001c80:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80001c82:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80001c86:	46a5                	li	a3,9
    80001c88:	00d70d63          	beq	a4,a3,80001ca2 <devintr+0x34>
  else if (scause == 0x8000000000000001L)
    80001c8c:	577d                	li	a4,-1
    80001c8e:	177e                	slli	a4,a4,0x3f
    80001c90:	0705                	addi	a4,a4,1
    return 0;
    80001c92:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001c94:	04e78e63          	beq	a5,a4,80001cf0 <devintr+0x82>
  }
}
    80001c98:	60e2                	ld	ra,24(sp)
    80001c9a:	6442                	ld	s0,16(sp)
    80001c9c:	64a2                	ld	s1,8(sp)
    80001c9e:	6105                	addi	sp,sp,32
    80001ca0:	8082                	ret
    int irq = plic_claim();
    80001ca2:	00003097          	auipc	ra,0x3
    80001ca6:	4c6080e7          	jalr	1222(ra) # 80005168 <plic_claim>
    80001caa:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001cac:	47a9                	li	a5,10
    80001cae:	02f50763          	beq	a0,a5,80001cdc <devintr+0x6e>
    else if (irq == VIRTIO0_IRQ)
    80001cb2:	4785                	li	a5,1
    80001cb4:	02f50963          	beq	a0,a5,80001ce6 <devintr+0x78>
    return 1;
    80001cb8:	4505                	li	a0,1
    else if (irq)
    80001cba:	dcf9                	beqz	s1,80001c98 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cbc:	85a6                	mv	a1,s1
    80001cbe:	00006517          	auipc	a0,0x6
    80001cc2:	55a50513          	addi	a0,a0,1370 # 80008218 <states.0+0x38>
    80001cc6:	00004097          	auipc	ra,0x4
    80001cca:	faa080e7          	jalr	-86(ra) # 80005c70 <printf>
      plic_complete(irq);
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00003097          	auipc	ra,0x3
    80001cd4:	4bc080e7          	jalr	1212(ra) # 8000518c <plic_complete>
    return 1;
    80001cd8:	4505                	li	a0,1
    80001cda:	bf7d                	j	80001c98 <devintr+0x2a>
      uartintr();
    80001cdc:	00004097          	auipc	ra,0x4
    80001ce0:	3a2080e7          	jalr	930(ra) # 8000607e <uartintr>
    if (irq)
    80001ce4:	b7ed                	j	80001cce <devintr+0x60>
      virtio_disk_intr();
    80001ce6:	00004097          	auipc	ra,0x4
    80001cea:	96c080e7          	jalr	-1684(ra) # 80005652 <virtio_disk_intr>
    if (irq)
    80001cee:	b7c5                	j	80001cce <devintr+0x60>
    if (cpuid() == 0)
    80001cf0:	fffff097          	auipc	ra,0xfffff
    80001cf4:	1c0080e7          	jalr	448(ra) # 80000eb0 <cpuid>
    80001cf8:	c901                	beqz	a0,80001d08 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cfa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cfe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d00:	14479073          	csrw	sip,a5
    return 2;
    80001d04:	4509                	li	a0,2
    80001d06:	bf49                	j	80001c98 <devintr+0x2a>
      clockintr();
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	f20080e7          	jalr	-224(ra) # 80001c28 <clockintr>
    80001d10:	b7ed                	j	80001cfa <devintr+0x8c>
}
    80001d12:	8082                	ret

0000000080001d14 <usertrap>:
{
    80001d14:	1101                	addi	sp,sp,-32
    80001d16:	ec06                	sd	ra,24(sp)
    80001d18:	e822                	sd	s0,16(sp)
    80001d1a:	e426                	sd	s1,8(sp)
    80001d1c:	e04a                	sd	s2,0(sp)
    80001d1e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d20:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001d24:	1007f793          	andi	a5,a5,256
    80001d28:	e3bd                	bnez	a5,80001d8e <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d2a:	00003797          	auipc	a5,0x3
    80001d2e:	33678793          	addi	a5,a5,822 # 80005060 <kernelvec>
    80001d32:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d36:	fffff097          	auipc	ra,0xfffff
    80001d3a:	1a6080e7          	jalr	422(ra) # 80000edc <myproc>
    80001d3e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d40:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d42:	14102773          	csrr	a4,sepc
    80001d46:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d48:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001d4c:	47a1                	li	a5,8
    80001d4e:	04f70863          	beq	a4,a5,80001d9e <usertrap+0x8a>
  else if ((which_dev = devintr()) != 0)
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	f1c080e7          	jalr	-228(ra) # 80001c6e <devintr>
    80001d5a:	892a                	mv	s2,a0
    80001d5c:	e579                	bnez	a0,80001e2a <usertrap+0x116>
    80001d5e:	14202773          	csrr	a4,scause
  else if (r_scause() == 13 || r_scause() == 15) // load or store
    80001d62:	47b5                	li	a5,13
    80001d64:	00f70763          	beq	a4,a5,80001d72 <usertrap+0x5e>
    80001d68:	14202773          	csrr	a4,scause
    80001d6c:	47bd                	li	a5,15
    80001d6e:	08f71163          	bne	a4,a5,80001df0 <usertrap+0xdc>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d72:	14302573          	csrr	a0,stval
    if (lazy_alloc(va) < 0)
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	d62080e7          	jalr	-670(ra) # 80000ad8 <lazy_alloc>
    80001d7e:	04055363          	bgez	a0,80001dc4 <usertrap+0xb0>
      setkilled(p);
    80001d82:	8526                	mv	a0,s1
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	a7c080e7          	jalr	-1412(ra) # 80001800 <setkilled>
    80001d8c:	a825                	j	80001dc4 <usertrap+0xb0>
    panic("usertrap: not from user mode");
    80001d8e:	00006517          	auipc	a0,0x6
    80001d92:	4aa50513          	addi	a0,a0,1194 # 80008238 <states.0+0x58>
    80001d96:	00004097          	auipc	ra,0x4
    80001d9a:	e90080e7          	jalr	-368(ra) # 80005c26 <panic>
    if (killed(p))
    80001d9e:	00000097          	auipc	ra,0x0
    80001da2:	a8e080e7          	jalr	-1394(ra) # 8000182c <killed>
    80001da6:	ed1d                	bnez	a0,80001de4 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001da8:	6cb8                	ld	a4,88(s1)
    80001daa:	6f1c                	ld	a5,24(a4)
    80001dac:	0791                	addi	a5,a5,4
    80001dae:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001db4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db8:	10079073          	csrw	sstatus,a5
    syscall();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	2fa080e7          	jalr	762(ra) # 800020b6 <syscall>
  if (killed(p))
    80001dc4:	8526                	mv	a0,s1
    80001dc6:	00000097          	auipc	ra,0x0
    80001dca:	a66080e7          	jalr	-1434(ra) # 8000182c <killed>
    80001dce:	e52d                	bnez	a0,80001e38 <usertrap+0x124>
  usertrapret();
    80001dd0:	00000097          	auipc	ra,0x0
    80001dd4:	dc2080e7          	jalr	-574(ra) # 80001b92 <usertrapret>
}
    80001dd8:	60e2                	ld	ra,24(sp)
    80001dda:	6442                	ld	s0,16(sp)
    80001ddc:	64a2                	ld	s1,8(sp)
    80001dde:	6902                	ld	s2,0(sp)
    80001de0:	6105                	addi	sp,sp,32
    80001de2:	8082                	ret
      exit(-1);
    80001de4:	557d                	li	a0,-1
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	8d2080e7          	jalr	-1838(ra) # 800016b8 <exit>
    80001dee:	bf6d                	j	80001da8 <usertrap+0x94>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001df4:	5890                	lw	a2,48(s1)
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	46250513          	addi	a0,a0,1122 # 80008258 <states.0+0x78>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	e72080e7          	jalr	-398(ra) # 80005c70 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e06:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e0a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e0e:	00006517          	auipc	a0,0x6
    80001e12:	47a50513          	addi	a0,a0,1146 # 80008288 <states.0+0xa8>
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	e5a080e7          	jalr	-422(ra) # 80005c70 <printf>
    setkilled(p);
    80001e1e:	8526                	mv	a0,s1
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	9e0080e7          	jalr	-1568(ra) # 80001800 <setkilled>
    80001e28:	bf71                	j	80001dc4 <usertrap+0xb0>
  if (killed(p))
    80001e2a:	8526                	mv	a0,s1
    80001e2c:	00000097          	auipc	ra,0x0
    80001e30:	a00080e7          	jalr	-1536(ra) # 8000182c <killed>
    80001e34:	c901                	beqz	a0,80001e44 <usertrap+0x130>
    80001e36:	a011                	j	80001e3a <usertrap+0x126>
    80001e38:	4901                	li	s2,0
    exit(-1);
    80001e3a:	557d                	li	a0,-1
    80001e3c:	00000097          	auipc	ra,0x0
    80001e40:	87c080e7          	jalr	-1924(ra) # 800016b8 <exit>
  if (which_dev == 2)
    80001e44:	4789                	li	a5,2
    80001e46:	f8f915e3          	bne	s2,a5,80001dd0 <usertrap+0xbc>
    yield();
    80001e4a:	fffff097          	auipc	ra,0xfffff
    80001e4e:	6fe080e7          	jalr	1790(ra) # 80001548 <yield>
    80001e52:	bfbd                	j	80001dd0 <usertrap+0xbc>

0000000080001e54 <kerneltrap>:
{
    80001e54:	7179                	addi	sp,sp,-48
    80001e56:	f406                	sd	ra,40(sp)
    80001e58:	f022                	sd	s0,32(sp)
    80001e5a:	ec26                	sd	s1,24(sp)
    80001e5c:	e84a                	sd	s2,16(sp)
    80001e5e:	e44e                	sd	s3,8(sp)
    80001e60:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e62:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e66:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6a:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001e6e:	1004f793          	andi	a5,s1,256
    80001e72:	cb85                	beqz	a5,80001ea2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e74:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e78:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001e7a:	ef85                	bnez	a5,80001eb2 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001e7c:	00000097          	auipc	ra,0x0
    80001e80:	df2080e7          	jalr	-526(ra) # 80001c6e <devintr>
    80001e84:	cd1d                	beqz	a0,80001ec2 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e86:	4789                	li	a5,2
    80001e88:	06f50a63          	beq	a0,a5,80001efc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e8c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e90:	10049073          	csrw	sstatus,s1
}
    80001e94:	70a2                	ld	ra,40(sp)
    80001e96:	7402                	ld	s0,32(sp)
    80001e98:	64e2                	ld	s1,24(sp)
    80001e9a:	6942                	ld	s2,16(sp)
    80001e9c:	69a2                	ld	s3,8(sp)
    80001e9e:	6145                	addi	sp,sp,48
    80001ea0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ea2:	00006517          	auipc	a0,0x6
    80001ea6:	40650513          	addi	a0,a0,1030 # 800082a8 <states.0+0xc8>
    80001eaa:	00004097          	auipc	ra,0x4
    80001eae:	d7c080e7          	jalr	-644(ra) # 80005c26 <panic>
    panic("kerneltrap: interrupts enabled");
    80001eb2:	00006517          	auipc	a0,0x6
    80001eb6:	41e50513          	addi	a0,a0,1054 # 800082d0 <states.0+0xf0>
    80001eba:	00004097          	auipc	ra,0x4
    80001ebe:	d6c080e7          	jalr	-660(ra) # 80005c26 <panic>
    printf("scause %p\n", scause);
    80001ec2:	85ce                	mv	a1,s3
    80001ec4:	00006517          	auipc	a0,0x6
    80001ec8:	42c50513          	addi	a0,a0,1068 # 800082f0 <states.0+0x110>
    80001ecc:	00004097          	auipc	ra,0x4
    80001ed0:	da4080e7          	jalr	-604(ra) # 80005c70 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001edc:	00006517          	auipc	a0,0x6
    80001ee0:	42450513          	addi	a0,a0,1060 # 80008300 <states.0+0x120>
    80001ee4:	00004097          	auipc	ra,0x4
    80001ee8:	d8c080e7          	jalr	-628(ra) # 80005c70 <printf>
    panic("kerneltrap");
    80001eec:	00006517          	auipc	a0,0x6
    80001ef0:	42c50513          	addi	a0,a0,1068 # 80008318 <states.0+0x138>
    80001ef4:	00004097          	auipc	ra,0x4
    80001ef8:	d32080e7          	jalr	-718(ra) # 80005c26 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	fe0080e7          	jalr	-32(ra) # 80000edc <myproc>
    80001f04:	d541                	beqz	a0,80001e8c <kerneltrap+0x38>
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	fd6080e7          	jalr	-42(ra) # 80000edc <myproc>
    80001f0e:	4d18                	lw	a4,24(a0)
    80001f10:	4791                	li	a5,4
    80001f12:	f6f71de3          	bne	a4,a5,80001e8c <kerneltrap+0x38>
    yield();
    80001f16:	fffff097          	auipc	ra,0xfffff
    80001f1a:	632080e7          	jalr	1586(ra) # 80001548 <yield>
    80001f1e:	b7bd                	j	80001e8c <kerneltrap+0x38>

0000000080001f20 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f20:	1101                	addi	sp,sp,-32
    80001f22:	ec06                	sd	ra,24(sp)
    80001f24:	e822                	sd	s0,16(sp)
    80001f26:	e426                	sd	s1,8(sp)
    80001f28:	1000                	addi	s0,sp,32
    80001f2a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	fb0080e7          	jalr	-80(ra) # 80000edc <myproc>
  switch (n)
    80001f34:	4795                	li	a5,5
    80001f36:	0497e163          	bltu	a5,s1,80001f78 <argraw+0x58>
    80001f3a:	048a                	slli	s1,s1,0x2
    80001f3c:	00006717          	auipc	a4,0x6
    80001f40:	41c70713          	addi	a4,a4,1052 # 80008358 <states.0+0x178>
    80001f44:	94ba                	add	s1,s1,a4
    80001f46:	409c                	lw	a5,0(s1)
    80001f48:	97ba                	add	a5,a5,a4
    80001f4a:	8782                	jr	a5
  {
  case 0:
    return p->trapframe->a0;
    80001f4c:	6d3c                	ld	a5,88(a0)
    80001f4e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f50:	60e2                	ld	ra,24(sp)
    80001f52:	6442                	ld	s0,16(sp)
    80001f54:	64a2                	ld	s1,8(sp)
    80001f56:	6105                	addi	sp,sp,32
    80001f58:	8082                	ret
    return p->trapframe->a1;
    80001f5a:	6d3c                	ld	a5,88(a0)
    80001f5c:	7fa8                	ld	a0,120(a5)
    80001f5e:	bfcd                	j	80001f50 <argraw+0x30>
    return p->trapframe->a2;
    80001f60:	6d3c                	ld	a5,88(a0)
    80001f62:	63c8                	ld	a0,128(a5)
    80001f64:	b7f5                	j	80001f50 <argraw+0x30>
    return p->trapframe->a3;
    80001f66:	6d3c                	ld	a5,88(a0)
    80001f68:	67c8                	ld	a0,136(a5)
    80001f6a:	b7dd                	j	80001f50 <argraw+0x30>
    return p->trapframe->a4;
    80001f6c:	6d3c                	ld	a5,88(a0)
    80001f6e:	6bc8                	ld	a0,144(a5)
    80001f70:	b7c5                	j	80001f50 <argraw+0x30>
    return p->trapframe->a5;
    80001f72:	6d3c                	ld	a5,88(a0)
    80001f74:	6fc8                	ld	a0,152(a5)
    80001f76:	bfe9                	j	80001f50 <argraw+0x30>
  panic("argraw");
    80001f78:	00006517          	auipc	a0,0x6
    80001f7c:	3b050513          	addi	a0,a0,944 # 80008328 <states.0+0x148>
    80001f80:	00004097          	auipc	ra,0x4
    80001f84:	ca6080e7          	jalr	-858(ra) # 80005c26 <panic>

0000000080001f88 <fetchaddr>:
{
    80001f88:	1101                	addi	sp,sp,-32
    80001f8a:	ec06                	sd	ra,24(sp)
    80001f8c:	e822                	sd	s0,16(sp)
    80001f8e:	e426                	sd	s1,8(sp)
    80001f90:	e04a                	sd	s2,0(sp)
    80001f92:	1000                	addi	s0,sp,32
    80001f94:	84aa                	mv	s1,a0
    80001f96:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	f44080e7          	jalr	-188(ra) # 80000edc <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001fa0:	653c                	ld	a5,72(a0)
    80001fa2:	02f4f863          	bgeu	s1,a5,80001fd2 <fetchaddr+0x4a>
    80001fa6:	00848713          	addi	a4,s1,8
    80001faa:	02e7e663          	bltu	a5,a4,80001fd6 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fae:	46a1                	li	a3,8
    80001fb0:	8626                	mv	a2,s1
    80001fb2:	85ca                	mv	a1,s2
    80001fb4:	6928                	ld	a0,80(a0)
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	c72080e7          	jalr	-910(ra) # 80000c28 <copyin>
    80001fbe:	00a03533          	snez	a0,a0
    80001fc2:	40a00533          	neg	a0,a0
}
    80001fc6:	60e2                	ld	ra,24(sp)
    80001fc8:	6442                	ld	s0,16(sp)
    80001fca:	64a2                	ld	s1,8(sp)
    80001fcc:	6902                	ld	s2,0(sp)
    80001fce:	6105                	addi	sp,sp,32
    80001fd0:	8082                	ret
    return -1;
    80001fd2:	557d                	li	a0,-1
    80001fd4:	bfcd                	j	80001fc6 <fetchaddr+0x3e>
    80001fd6:	557d                	li	a0,-1
    80001fd8:	b7fd                	j	80001fc6 <fetchaddr+0x3e>

0000000080001fda <fetchstr>:
{
    80001fda:	7179                	addi	sp,sp,-48
    80001fdc:	f406                	sd	ra,40(sp)
    80001fde:	f022                	sd	s0,32(sp)
    80001fe0:	ec26                	sd	s1,24(sp)
    80001fe2:	e84a                	sd	s2,16(sp)
    80001fe4:	e44e                	sd	s3,8(sp)
    80001fe6:	1800                	addi	s0,sp,48
    80001fe8:	892a                	mv	s2,a0
    80001fea:	84ae                	mv	s1,a1
    80001fec:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	eee080e7          	jalr	-274(ra) # 80000edc <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80001ff6:	86ce                	mv	a3,s3
    80001ff8:	864a                	mv	a2,s2
    80001ffa:	85a6                	mv	a1,s1
    80001ffc:	6928                	ld	a0,80(a0)
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	cb8080e7          	jalr	-840(ra) # 80000cb6 <copyinstr>
    80002006:	00054e63          	bltz	a0,80002022 <fetchstr+0x48>
  return strlen(buf);
    8000200a:	8526                	mv	a0,s1
    8000200c:	ffffe097          	auipc	ra,0xffffe
    80002010:	2e8080e7          	jalr	744(ra) # 800002f4 <strlen>
}
    80002014:	70a2                	ld	ra,40(sp)
    80002016:	7402                	ld	s0,32(sp)
    80002018:	64e2                	ld	s1,24(sp)
    8000201a:	6942                	ld	s2,16(sp)
    8000201c:	69a2                	ld	s3,8(sp)
    8000201e:	6145                	addi	sp,sp,48
    80002020:	8082                	ret
    return -1;
    80002022:	557d                	li	a0,-1
    80002024:	bfc5                	j	80002014 <fetchstr+0x3a>

0000000080002026 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002026:	1101                	addi	sp,sp,-32
    80002028:	ec06                	sd	ra,24(sp)
    8000202a:	e822                	sd	s0,16(sp)
    8000202c:	e426                	sd	s1,8(sp)
    8000202e:	1000                	addi	s0,sp,32
    80002030:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002032:	00000097          	auipc	ra,0x0
    80002036:	eee080e7          	jalr	-274(ra) # 80001f20 <argraw>
    8000203a:	c088                	sw	a0,0(s1)
}
    8000203c:	60e2                	ld	ra,24(sp)
    8000203e:	6442                	ld	s0,16(sp)
    80002040:	64a2                	ld	s1,8(sp)
    80002042:	6105                	addi	sp,sp,32
    80002044:	8082                	ret

0000000080002046 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002046:	1101                	addi	sp,sp,-32
    80002048:	ec06                	sd	ra,24(sp)
    8000204a:	e822                	sd	s0,16(sp)
    8000204c:	e426                	sd	s1,8(sp)
    8000204e:	1000                	addi	s0,sp,32
    80002050:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002052:	00000097          	auipc	ra,0x0
    80002056:	ece080e7          	jalr	-306(ra) # 80001f20 <argraw>
    8000205a:	e088                	sd	a0,0(s1)
}
    8000205c:	60e2                	ld	ra,24(sp)
    8000205e:	6442                	ld	s0,16(sp)
    80002060:	64a2                	ld	s1,8(sp)
    80002062:	6105                	addi	sp,sp,32
    80002064:	8082                	ret

0000000080002066 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002066:	7139                	addi	sp,sp,-64
    80002068:	fc06                	sd	ra,56(sp)
    8000206a:	f822                	sd	s0,48(sp)
    8000206c:	f426                	sd	s1,40(sp)
    8000206e:	f04a                	sd	s2,32(sp)
    80002070:	ec4e                	sd	s3,24(sp)
    80002072:	0080                	addi	s0,sp,64
    80002074:	84ae                	mv	s1,a1
    80002076:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002078:	fc840593          	addi	a1,s0,-56
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	fca080e7          	jalr	-54(ra) # 80002046 <argaddr>
  printf("arg %p\n", addr);
    80002084:	fc843983          	ld	s3,-56(s0)
    80002088:	85ce                	mv	a1,s3
    8000208a:	00006517          	auipc	a0,0x6
    8000208e:	2a650513          	addi	a0,a0,678 # 80008330 <states.0+0x150>
    80002092:	00004097          	auipc	ra,0x4
    80002096:	bde080e7          	jalr	-1058(ra) # 80005c70 <printf>
  return fetchstr(addr, buf, max);
    8000209a:	864a                	mv	a2,s2
    8000209c:	85a6                	mv	a1,s1
    8000209e:	854e                	mv	a0,s3
    800020a0:	00000097          	auipc	ra,0x0
    800020a4:	f3a080e7          	jalr	-198(ra) # 80001fda <fetchstr>
}
    800020a8:	70e2                	ld	ra,56(sp)
    800020aa:	7442                	ld	s0,48(sp)
    800020ac:	74a2                	ld	s1,40(sp)
    800020ae:	7902                	ld	s2,32(sp)
    800020b0:	69e2                	ld	s3,24(sp)
    800020b2:	6121                	addi	sp,sp,64
    800020b4:	8082                	ret

00000000800020b6 <syscall>:
    [SYS_mkdir] sys_mkdir,
    [SYS_close] sys_close,
};

void syscall(void)
{
    800020b6:	1101                	addi	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	e426                	sd	s1,8(sp)
    800020be:	e04a                	sd	s2,0(sp)
    800020c0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	e1a080e7          	jalr	-486(ra) # 80000edc <myproc>
    800020ca:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020cc:	05853903          	ld	s2,88(a0)
    800020d0:	0a893783          	ld	a5,168(s2)
    800020d4:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800020d8:	37fd                	addiw	a5,a5,-1
    800020da:	4751                	li	a4,20
    800020dc:	00f76f63          	bltu	a4,a5,800020fa <syscall+0x44>
    800020e0:	00369713          	slli	a4,a3,0x3
    800020e4:	00006797          	auipc	a5,0x6
    800020e8:	28c78793          	addi	a5,a5,652 # 80008370 <syscalls>
    800020ec:	97ba                	add	a5,a5,a4
    800020ee:	639c                	ld	a5,0(a5)
    800020f0:	c789                	beqz	a5,800020fa <syscall+0x44>
  {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020f2:	9782                	jalr	a5
    800020f4:	06a93823          	sd	a0,112(s2)
    800020f8:	a839                	j	80002116 <syscall+0x60>
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
    800020fa:	15848613          	addi	a2,s1,344
    800020fe:	588c                	lw	a1,48(s1)
    80002100:	00006517          	auipc	a0,0x6
    80002104:	23850513          	addi	a0,a0,568 # 80008338 <states.0+0x158>
    80002108:	00004097          	auipc	ra,0x4
    8000210c:	b68080e7          	jalr	-1176(ra) # 80005c70 <printf>
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002110:	6cbc                	ld	a5,88(s1)
    80002112:	577d                	li	a4,-1
    80002114:	fbb8                	sd	a4,112(a5)
  }
}
    80002116:	60e2                	ld	ra,24(sp)
    80002118:	6442                	ld	s0,16(sp)
    8000211a:	64a2                	ld	s1,8(sp)
    8000211c:	6902                	ld	s2,0(sp)
    8000211e:	6105                	addi	sp,sp,32
    80002120:	8082                	ret

0000000080002122 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002122:	1101                	addi	sp,sp,-32
    80002124:	ec06                	sd	ra,24(sp)
    80002126:	e822                	sd	s0,16(sp)
    80002128:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000212a:	fec40593          	addi	a1,s0,-20
    8000212e:	4501                	li	a0,0
    80002130:	00000097          	auipc	ra,0x0
    80002134:	ef6080e7          	jalr	-266(ra) # 80002026 <argint>
  exit(n);
    80002138:	fec42503          	lw	a0,-20(s0)
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	57c080e7          	jalr	1404(ra) # 800016b8 <exit>
  return 0; // not reached
}
    80002144:	4501                	li	a0,0
    80002146:	60e2                	ld	ra,24(sp)
    80002148:	6442                	ld	s0,16(sp)
    8000214a:	6105                	addi	sp,sp,32
    8000214c:	8082                	ret

000000008000214e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000214e:	1141                	addi	sp,sp,-16
    80002150:	e406                	sd	ra,8(sp)
    80002152:	e022                	sd	s0,0(sp)
    80002154:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	d86080e7          	jalr	-634(ra) # 80000edc <myproc>
}
    8000215e:	5908                	lw	a0,48(a0)
    80002160:	60a2                	ld	ra,8(sp)
    80002162:	6402                	ld	s0,0(sp)
    80002164:	0141                	addi	sp,sp,16
    80002166:	8082                	ret

0000000080002168 <sys_fork>:

uint64
sys_fork(void)
{
    80002168:	1141                	addi	sp,sp,-16
    8000216a:	e406                	sd	ra,8(sp)
    8000216c:	e022                	sd	s0,0(sp)
    8000216e:	0800                	addi	s0,sp,16
  return fork();
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	122080e7          	jalr	290(ra) # 80001292 <fork>
}
    80002178:	60a2                	ld	ra,8(sp)
    8000217a:	6402                	ld	s0,0(sp)
    8000217c:	0141                	addi	sp,sp,16
    8000217e:	8082                	ret

0000000080002180 <sys_wait>:

uint64
sys_wait(void)
{
    80002180:	1101                	addi	sp,sp,-32
    80002182:	ec06                	sd	ra,24(sp)
    80002184:	e822                	sd	s0,16(sp)
    80002186:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002188:	fe840593          	addi	a1,s0,-24
    8000218c:	4501                	li	a0,0
    8000218e:	00000097          	auipc	ra,0x0
    80002192:	eb8080e7          	jalr	-328(ra) # 80002046 <argaddr>
  return wait(p);
    80002196:	fe843503          	ld	a0,-24(s0)
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	6c4080e7          	jalr	1732(ra) # 8000185e <wait>
}
    800021a2:	60e2                	ld	ra,24(sp)
    800021a4:	6442                	ld	s0,16(sp)
    800021a6:	6105                	addi	sp,sp,32
    800021a8:	8082                	ret

00000000800021aa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021aa:	7179                	addi	sp,sp,-48
    800021ac:	f406                	sd	ra,40(sp)
    800021ae:	f022                	sd	s0,32(sp)
    800021b0:	ec26                	sd	s1,24(sp)
    800021b2:	e84a                	sd	s2,16(sp)
    800021b4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;
  struct proc *p = myproc();
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	d26080e7          	jalr	-730(ra) # 80000edc <myproc>
    800021be:	84aa                	mv	s1,a0
  argint(0, &n);
    800021c0:	fdc40593          	addi	a1,s0,-36
    800021c4:	4501                	li	a0,0
    800021c6:	00000097          	auipc	ra,0x0
    800021ca:	e60080e7          	jalr	-416(ra) # 80002026 <argint>
  addr = p->sz;
    800021ce:	0484b903          	ld	s2,72(s1)
  p->sz += n;
    800021d2:	fdc42603          	lw	a2,-36(s0)
    800021d6:	964a                	add	a2,a2,s2
    800021d8:	e4b0                	sd	a2,72(s1)
  if (uvmdealloc(p->pagetable, addr, p->sz) < 0)
    800021da:	85ca                	mv	a1,s2
    800021dc:	68a8                	ld	a0,80(s1)
    800021de:	ffffe097          	auipc	ra,0xffffe
    800021e2:	672080e7          	jalr	1650(ra) # 80000850 <uvmdealloc>
    return -1;
  return addr;
}
    800021e6:	854a                	mv	a0,s2
    800021e8:	70a2                	ld	ra,40(sp)
    800021ea:	7402                	ld	s0,32(sp)
    800021ec:	64e2                	ld	s1,24(sp)
    800021ee:	6942                	ld	s2,16(sp)
    800021f0:	6145                	addi	sp,sp,48
    800021f2:	8082                	ret

00000000800021f4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021f4:	7139                	addi	sp,sp,-64
    800021f6:	fc06                	sd	ra,56(sp)
    800021f8:	f822                	sd	s0,48(sp)
    800021fa:	f426                	sd	s1,40(sp)
    800021fc:	f04a                	sd	s2,32(sp)
    800021fe:	ec4e                	sd	s3,24(sp)
    80002200:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002202:	fcc40593          	addi	a1,s0,-52
    80002206:	4501                	li	a0,0
    80002208:	00000097          	auipc	ra,0x0
    8000220c:	e1e080e7          	jalr	-482(ra) # 80002026 <argint>
  acquire(&tickslock);
    80002210:	0000c517          	auipc	a0,0xc
    80002214:	4b050513          	addi	a0,a0,1200 # 8000e6c0 <tickslock>
    80002218:	00004097          	auipc	ra,0x4
    8000221c:	f46080e7          	jalr	-186(ra) # 8000615e <acquire>
  ticks0 = ticks;
    80002220:	00006917          	auipc	s2,0x6
    80002224:	63892903          	lw	s2,1592(s2) # 80008858 <ticks>
  while (ticks - ticks0 < n)
    80002228:	fcc42783          	lw	a5,-52(s0)
    8000222c:	cf9d                	beqz	a5,8000226a <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000222e:	0000c997          	auipc	s3,0xc
    80002232:	49298993          	addi	s3,s3,1170 # 8000e6c0 <tickslock>
    80002236:	00006497          	auipc	s1,0x6
    8000223a:	62248493          	addi	s1,s1,1570 # 80008858 <ticks>
    if (killed(myproc()))
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	c9e080e7          	jalr	-866(ra) # 80000edc <myproc>
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	5e6080e7          	jalr	1510(ra) # 8000182c <killed>
    8000224e:	ed15                	bnez	a0,8000228a <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002250:	85ce                	mv	a1,s3
    80002252:	8526                	mv	a0,s1
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	330080e7          	jalr	816(ra) # 80001584 <sleep>
  while (ticks - ticks0 < n)
    8000225c:	409c                	lw	a5,0(s1)
    8000225e:	412787bb          	subw	a5,a5,s2
    80002262:	fcc42703          	lw	a4,-52(s0)
    80002266:	fce7ece3          	bltu	a5,a4,8000223e <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000226a:	0000c517          	auipc	a0,0xc
    8000226e:	45650513          	addi	a0,a0,1110 # 8000e6c0 <tickslock>
    80002272:	00004097          	auipc	ra,0x4
    80002276:	fa0080e7          	jalr	-96(ra) # 80006212 <release>
  return 0;
    8000227a:	4501                	li	a0,0
}
    8000227c:	70e2                	ld	ra,56(sp)
    8000227e:	7442                	ld	s0,48(sp)
    80002280:	74a2                	ld	s1,40(sp)
    80002282:	7902                	ld	s2,32(sp)
    80002284:	69e2                	ld	s3,24(sp)
    80002286:	6121                	addi	sp,sp,64
    80002288:	8082                	ret
      release(&tickslock);
    8000228a:	0000c517          	auipc	a0,0xc
    8000228e:	43650513          	addi	a0,a0,1078 # 8000e6c0 <tickslock>
    80002292:	00004097          	auipc	ra,0x4
    80002296:	f80080e7          	jalr	-128(ra) # 80006212 <release>
      return -1;
    8000229a:	557d                	li	a0,-1
    8000229c:	b7c5                	j	8000227c <sys_sleep+0x88>

000000008000229e <sys_kill>:

uint64
sys_kill(void)
{
    8000229e:	1101                	addi	sp,sp,-32
    800022a0:	ec06                	sd	ra,24(sp)
    800022a2:	e822                	sd	s0,16(sp)
    800022a4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022a6:	fec40593          	addi	a1,s0,-20
    800022aa:	4501                	li	a0,0
    800022ac:	00000097          	auipc	ra,0x0
    800022b0:	d7a080e7          	jalr	-646(ra) # 80002026 <argint>
  return kill(pid);
    800022b4:	fec42503          	lw	a0,-20(s0)
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	4d6080e7          	jalr	1238(ra) # 8000178e <kill>
}
    800022c0:	60e2                	ld	ra,24(sp)
    800022c2:	6442                	ld	s0,16(sp)
    800022c4:	6105                	addi	sp,sp,32
    800022c6:	8082                	ret

00000000800022c8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022c8:	1101                	addi	sp,sp,-32
    800022ca:	ec06                	sd	ra,24(sp)
    800022cc:	e822                	sd	s0,16(sp)
    800022ce:	e426                	sd	s1,8(sp)
    800022d0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022d2:	0000c517          	auipc	a0,0xc
    800022d6:	3ee50513          	addi	a0,a0,1006 # 8000e6c0 <tickslock>
    800022da:	00004097          	auipc	ra,0x4
    800022de:	e84080e7          	jalr	-380(ra) # 8000615e <acquire>
  xticks = ticks;
    800022e2:	00006497          	auipc	s1,0x6
    800022e6:	5764a483          	lw	s1,1398(s1) # 80008858 <ticks>
  release(&tickslock);
    800022ea:	0000c517          	auipc	a0,0xc
    800022ee:	3d650513          	addi	a0,a0,982 # 8000e6c0 <tickslock>
    800022f2:	00004097          	auipc	ra,0x4
    800022f6:	f20080e7          	jalr	-224(ra) # 80006212 <release>
  return xticks;
}
    800022fa:	02049513          	slli	a0,s1,0x20
    800022fe:	9101                	srli	a0,a0,0x20
    80002300:	60e2                	ld	ra,24(sp)
    80002302:	6442                	ld	s0,16(sp)
    80002304:	64a2                	ld	s1,8(sp)
    80002306:	6105                	addi	sp,sp,32
    80002308:	8082                	ret

000000008000230a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000230a:	7179                	addi	sp,sp,-48
    8000230c:	f406                	sd	ra,40(sp)
    8000230e:	f022                	sd	s0,32(sp)
    80002310:	ec26                	sd	s1,24(sp)
    80002312:	e84a                	sd	s2,16(sp)
    80002314:	e44e                	sd	s3,8(sp)
    80002316:	e052                	sd	s4,0(sp)
    80002318:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000231a:	00006597          	auipc	a1,0x6
    8000231e:	10658593          	addi	a1,a1,262 # 80008420 <syscalls+0xb0>
    80002322:	0000c517          	auipc	a0,0xc
    80002326:	3b650513          	addi	a0,a0,950 # 8000e6d8 <bcache>
    8000232a:	00004097          	auipc	ra,0x4
    8000232e:	da4080e7          	jalr	-604(ra) # 800060ce <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002332:	00014797          	auipc	a5,0x14
    80002336:	3a678793          	addi	a5,a5,934 # 800166d8 <bcache+0x8000>
    8000233a:	00014717          	auipc	a4,0x14
    8000233e:	60670713          	addi	a4,a4,1542 # 80016940 <bcache+0x8268>
    80002342:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002346:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000234a:	0000c497          	auipc	s1,0xc
    8000234e:	3a648493          	addi	s1,s1,934 # 8000e6f0 <bcache+0x18>
    b->next = bcache.head.next;
    80002352:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002354:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002356:	00006a17          	auipc	s4,0x6
    8000235a:	0d2a0a13          	addi	s4,s4,210 # 80008428 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000235e:	2b893783          	ld	a5,696(s2)
    80002362:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002364:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002368:	85d2                	mv	a1,s4
    8000236a:	01048513          	addi	a0,s1,16
    8000236e:	00001097          	auipc	ra,0x1
    80002372:	496080e7          	jalr	1174(ra) # 80003804 <initsleeplock>
    bcache.head.next->prev = b;
    80002376:	2b893783          	ld	a5,696(s2)
    8000237a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000237c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002380:	45848493          	addi	s1,s1,1112
    80002384:	fd349de3          	bne	s1,s3,8000235e <binit+0x54>
  }
}
    80002388:	70a2                	ld	ra,40(sp)
    8000238a:	7402                	ld	s0,32(sp)
    8000238c:	64e2                	ld	s1,24(sp)
    8000238e:	6942                	ld	s2,16(sp)
    80002390:	69a2                	ld	s3,8(sp)
    80002392:	6a02                	ld	s4,0(sp)
    80002394:	6145                	addi	sp,sp,48
    80002396:	8082                	ret

0000000080002398 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002398:	7179                	addi	sp,sp,-48
    8000239a:	f406                	sd	ra,40(sp)
    8000239c:	f022                	sd	s0,32(sp)
    8000239e:	ec26                	sd	s1,24(sp)
    800023a0:	e84a                	sd	s2,16(sp)
    800023a2:	e44e                	sd	s3,8(sp)
    800023a4:	1800                	addi	s0,sp,48
    800023a6:	892a                	mv	s2,a0
    800023a8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023aa:	0000c517          	auipc	a0,0xc
    800023ae:	32e50513          	addi	a0,a0,814 # 8000e6d8 <bcache>
    800023b2:	00004097          	auipc	ra,0x4
    800023b6:	dac080e7          	jalr	-596(ra) # 8000615e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023ba:	00014497          	auipc	s1,0x14
    800023be:	5d64b483          	ld	s1,1494(s1) # 80016990 <bcache+0x82b8>
    800023c2:	00014797          	auipc	a5,0x14
    800023c6:	57e78793          	addi	a5,a5,1406 # 80016940 <bcache+0x8268>
    800023ca:	02f48f63          	beq	s1,a5,80002408 <bread+0x70>
    800023ce:	873e                	mv	a4,a5
    800023d0:	a021                	j	800023d8 <bread+0x40>
    800023d2:	68a4                	ld	s1,80(s1)
    800023d4:	02e48a63          	beq	s1,a4,80002408 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023d8:	449c                	lw	a5,8(s1)
    800023da:	ff279ce3          	bne	a5,s2,800023d2 <bread+0x3a>
    800023de:	44dc                	lw	a5,12(s1)
    800023e0:	ff3799e3          	bne	a5,s3,800023d2 <bread+0x3a>
      b->refcnt++;
    800023e4:	40bc                	lw	a5,64(s1)
    800023e6:	2785                	addiw	a5,a5,1
    800023e8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023ea:	0000c517          	auipc	a0,0xc
    800023ee:	2ee50513          	addi	a0,a0,750 # 8000e6d8 <bcache>
    800023f2:	00004097          	auipc	ra,0x4
    800023f6:	e20080e7          	jalr	-480(ra) # 80006212 <release>
      acquiresleep(&b->lock);
    800023fa:	01048513          	addi	a0,s1,16
    800023fe:	00001097          	auipc	ra,0x1
    80002402:	440080e7          	jalr	1088(ra) # 8000383e <acquiresleep>
      return b;
    80002406:	a8b9                	j	80002464 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002408:	00014497          	auipc	s1,0x14
    8000240c:	5804b483          	ld	s1,1408(s1) # 80016988 <bcache+0x82b0>
    80002410:	00014797          	auipc	a5,0x14
    80002414:	53078793          	addi	a5,a5,1328 # 80016940 <bcache+0x8268>
    80002418:	00f48863          	beq	s1,a5,80002428 <bread+0x90>
    8000241c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000241e:	40bc                	lw	a5,64(s1)
    80002420:	cf81                	beqz	a5,80002438 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002422:	64a4                	ld	s1,72(s1)
    80002424:	fee49de3          	bne	s1,a4,8000241e <bread+0x86>
  panic("bget: no buffers");
    80002428:	00006517          	auipc	a0,0x6
    8000242c:	00850513          	addi	a0,a0,8 # 80008430 <syscalls+0xc0>
    80002430:	00003097          	auipc	ra,0x3
    80002434:	7f6080e7          	jalr	2038(ra) # 80005c26 <panic>
      b->dev = dev;
    80002438:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000243c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002440:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002444:	4785                	li	a5,1
    80002446:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002448:	0000c517          	auipc	a0,0xc
    8000244c:	29050513          	addi	a0,a0,656 # 8000e6d8 <bcache>
    80002450:	00004097          	auipc	ra,0x4
    80002454:	dc2080e7          	jalr	-574(ra) # 80006212 <release>
      acquiresleep(&b->lock);
    80002458:	01048513          	addi	a0,s1,16
    8000245c:	00001097          	auipc	ra,0x1
    80002460:	3e2080e7          	jalr	994(ra) # 8000383e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002464:	409c                	lw	a5,0(s1)
    80002466:	cb89                	beqz	a5,80002478 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002468:	8526                	mv	a0,s1
    8000246a:	70a2                	ld	ra,40(sp)
    8000246c:	7402                	ld	s0,32(sp)
    8000246e:	64e2                	ld	s1,24(sp)
    80002470:	6942                	ld	s2,16(sp)
    80002472:	69a2                	ld	s3,8(sp)
    80002474:	6145                	addi	sp,sp,48
    80002476:	8082                	ret
    virtio_disk_rw(b, 0);
    80002478:	4581                	li	a1,0
    8000247a:	8526                	mv	a0,s1
    8000247c:	00003097          	auipc	ra,0x3
    80002480:	fa6080e7          	jalr	-90(ra) # 80005422 <virtio_disk_rw>
    b->valid = 1;
    80002484:	4785                	li	a5,1
    80002486:	c09c                	sw	a5,0(s1)
  return b;
    80002488:	b7c5                	j	80002468 <bread+0xd0>

000000008000248a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000248a:	1101                	addi	sp,sp,-32
    8000248c:	ec06                	sd	ra,24(sp)
    8000248e:	e822                	sd	s0,16(sp)
    80002490:	e426                	sd	s1,8(sp)
    80002492:	1000                	addi	s0,sp,32
    80002494:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002496:	0541                	addi	a0,a0,16
    80002498:	00001097          	auipc	ra,0x1
    8000249c:	440080e7          	jalr	1088(ra) # 800038d8 <holdingsleep>
    800024a0:	cd01                	beqz	a0,800024b8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024a2:	4585                	li	a1,1
    800024a4:	8526                	mv	a0,s1
    800024a6:	00003097          	auipc	ra,0x3
    800024aa:	f7c080e7          	jalr	-132(ra) # 80005422 <virtio_disk_rw>
}
    800024ae:	60e2                	ld	ra,24(sp)
    800024b0:	6442                	ld	s0,16(sp)
    800024b2:	64a2                	ld	s1,8(sp)
    800024b4:	6105                	addi	sp,sp,32
    800024b6:	8082                	ret
    panic("bwrite");
    800024b8:	00006517          	auipc	a0,0x6
    800024bc:	f9050513          	addi	a0,a0,-112 # 80008448 <syscalls+0xd8>
    800024c0:	00003097          	auipc	ra,0x3
    800024c4:	766080e7          	jalr	1894(ra) # 80005c26 <panic>

00000000800024c8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024c8:	1101                	addi	sp,sp,-32
    800024ca:	ec06                	sd	ra,24(sp)
    800024cc:	e822                	sd	s0,16(sp)
    800024ce:	e426                	sd	s1,8(sp)
    800024d0:	e04a                	sd	s2,0(sp)
    800024d2:	1000                	addi	s0,sp,32
    800024d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024d6:	01050913          	addi	s2,a0,16
    800024da:	854a                	mv	a0,s2
    800024dc:	00001097          	auipc	ra,0x1
    800024e0:	3fc080e7          	jalr	1020(ra) # 800038d8 <holdingsleep>
    800024e4:	c925                	beqz	a0,80002554 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800024e6:	854a                	mv	a0,s2
    800024e8:	00001097          	auipc	ra,0x1
    800024ec:	3ac080e7          	jalr	940(ra) # 80003894 <releasesleep>

  acquire(&bcache.lock);
    800024f0:	0000c517          	auipc	a0,0xc
    800024f4:	1e850513          	addi	a0,a0,488 # 8000e6d8 <bcache>
    800024f8:	00004097          	auipc	ra,0x4
    800024fc:	c66080e7          	jalr	-922(ra) # 8000615e <acquire>
  b->refcnt--;
    80002500:	40bc                	lw	a5,64(s1)
    80002502:	37fd                	addiw	a5,a5,-1
    80002504:	0007871b          	sext.w	a4,a5
    80002508:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000250a:	e71d                	bnez	a4,80002538 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000250c:	68b8                	ld	a4,80(s1)
    8000250e:	64bc                	ld	a5,72(s1)
    80002510:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002512:	68b8                	ld	a4,80(s1)
    80002514:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002516:	00014797          	auipc	a5,0x14
    8000251a:	1c278793          	addi	a5,a5,450 # 800166d8 <bcache+0x8000>
    8000251e:	2b87b703          	ld	a4,696(a5)
    80002522:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002524:	00014717          	auipc	a4,0x14
    80002528:	41c70713          	addi	a4,a4,1052 # 80016940 <bcache+0x8268>
    8000252c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000252e:	2b87b703          	ld	a4,696(a5)
    80002532:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002534:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002538:	0000c517          	auipc	a0,0xc
    8000253c:	1a050513          	addi	a0,a0,416 # 8000e6d8 <bcache>
    80002540:	00004097          	auipc	ra,0x4
    80002544:	cd2080e7          	jalr	-814(ra) # 80006212 <release>
}
    80002548:	60e2                	ld	ra,24(sp)
    8000254a:	6442                	ld	s0,16(sp)
    8000254c:	64a2                	ld	s1,8(sp)
    8000254e:	6902                	ld	s2,0(sp)
    80002550:	6105                	addi	sp,sp,32
    80002552:	8082                	ret
    panic("brelse");
    80002554:	00006517          	auipc	a0,0x6
    80002558:	efc50513          	addi	a0,a0,-260 # 80008450 <syscalls+0xe0>
    8000255c:	00003097          	auipc	ra,0x3
    80002560:	6ca080e7          	jalr	1738(ra) # 80005c26 <panic>

0000000080002564 <bpin>:

void
bpin(struct buf *b) {
    80002564:	1101                	addi	sp,sp,-32
    80002566:	ec06                	sd	ra,24(sp)
    80002568:	e822                	sd	s0,16(sp)
    8000256a:	e426                	sd	s1,8(sp)
    8000256c:	1000                	addi	s0,sp,32
    8000256e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002570:	0000c517          	auipc	a0,0xc
    80002574:	16850513          	addi	a0,a0,360 # 8000e6d8 <bcache>
    80002578:	00004097          	auipc	ra,0x4
    8000257c:	be6080e7          	jalr	-1050(ra) # 8000615e <acquire>
  b->refcnt++;
    80002580:	40bc                	lw	a5,64(s1)
    80002582:	2785                	addiw	a5,a5,1
    80002584:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002586:	0000c517          	auipc	a0,0xc
    8000258a:	15250513          	addi	a0,a0,338 # 8000e6d8 <bcache>
    8000258e:	00004097          	auipc	ra,0x4
    80002592:	c84080e7          	jalr	-892(ra) # 80006212 <release>
}
    80002596:	60e2                	ld	ra,24(sp)
    80002598:	6442                	ld	s0,16(sp)
    8000259a:	64a2                	ld	s1,8(sp)
    8000259c:	6105                	addi	sp,sp,32
    8000259e:	8082                	ret

00000000800025a0 <bunpin>:

void
bunpin(struct buf *b) {
    800025a0:	1101                	addi	sp,sp,-32
    800025a2:	ec06                	sd	ra,24(sp)
    800025a4:	e822                	sd	s0,16(sp)
    800025a6:	e426                	sd	s1,8(sp)
    800025a8:	1000                	addi	s0,sp,32
    800025aa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025ac:	0000c517          	auipc	a0,0xc
    800025b0:	12c50513          	addi	a0,a0,300 # 8000e6d8 <bcache>
    800025b4:	00004097          	auipc	ra,0x4
    800025b8:	baa080e7          	jalr	-1110(ra) # 8000615e <acquire>
  b->refcnt--;
    800025bc:	40bc                	lw	a5,64(s1)
    800025be:	37fd                	addiw	a5,a5,-1
    800025c0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025c2:	0000c517          	auipc	a0,0xc
    800025c6:	11650513          	addi	a0,a0,278 # 8000e6d8 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	c48080e7          	jalr	-952(ra) # 80006212 <release>
}
    800025d2:	60e2                	ld	ra,24(sp)
    800025d4:	6442                	ld	s0,16(sp)
    800025d6:	64a2                	ld	s1,8(sp)
    800025d8:	6105                	addi	sp,sp,32
    800025da:	8082                	ret

00000000800025dc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025dc:	1101                	addi	sp,sp,-32
    800025de:	ec06                	sd	ra,24(sp)
    800025e0:	e822                	sd	s0,16(sp)
    800025e2:	e426                	sd	s1,8(sp)
    800025e4:	e04a                	sd	s2,0(sp)
    800025e6:	1000                	addi	s0,sp,32
    800025e8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025ea:	00d5d59b          	srliw	a1,a1,0xd
    800025ee:	00014797          	auipc	a5,0x14
    800025f2:	7c67a783          	lw	a5,1990(a5) # 80016db4 <sb+0x1c>
    800025f6:	9dbd                	addw	a1,a1,a5
    800025f8:	00000097          	auipc	ra,0x0
    800025fc:	da0080e7          	jalr	-608(ra) # 80002398 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002600:	0074f713          	andi	a4,s1,7
    80002604:	4785                	li	a5,1
    80002606:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000260a:	14ce                	slli	s1,s1,0x33
    8000260c:	90d9                	srli	s1,s1,0x36
    8000260e:	00950733          	add	a4,a0,s1
    80002612:	05874703          	lbu	a4,88(a4)
    80002616:	00e7f6b3          	and	a3,a5,a4
    8000261a:	c69d                	beqz	a3,80002648 <bfree+0x6c>
    8000261c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000261e:	94aa                	add	s1,s1,a0
    80002620:	fff7c793          	not	a5,a5
    80002624:	8f7d                	and	a4,a4,a5
    80002626:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000262a:	00001097          	auipc	ra,0x1
    8000262e:	0f6080e7          	jalr	246(ra) # 80003720 <log_write>
  brelse(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	e94080e7          	jalr	-364(ra) # 800024c8 <brelse>
}
    8000263c:	60e2                	ld	ra,24(sp)
    8000263e:	6442                	ld	s0,16(sp)
    80002640:	64a2                	ld	s1,8(sp)
    80002642:	6902                	ld	s2,0(sp)
    80002644:	6105                	addi	sp,sp,32
    80002646:	8082                	ret
    panic("freeing free block");
    80002648:	00006517          	auipc	a0,0x6
    8000264c:	e1050513          	addi	a0,a0,-496 # 80008458 <syscalls+0xe8>
    80002650:	00003097          	auipc	ra,0x3
    80002654:	5d6080e7          	jalr	1494(ra) # 80005c26 <panic>

0000000080002658 <balloc>:
{
    80002658:	711d                	addi	sp,sp,-96
    8000265a:	ec86                	sd	ra,88(sp)
    8000265c:	e8a2                	sd	s0,80(sp)
    8000265e:	e4a6                	sd	s1,72(sp)
    80002660:	e0ca                	sd	s2,64(sp)
    80002662:	fc4e                	sd	s3,56(sp)
    80002664:	f852                	sd	s4,48(sp)
    80002666:	f456                	sd	s5,40(sp)
    80002668:	f05a                	sd	s6,32(sp)
    8000266a:	ec5e                	sd	s7,24(sp)
    8000266c:	e862                	sd	s8,16(sp)
    8000266e:	e466                	sd	s9,8(sp)
    80002670:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002672:	00014797          	auipc	a5,0x14
    80002676:	72a7a783          	lw	a5,1834(a5) # 80016d9c <sb+0x4>
    8000267a:	cff5                	beqz	a5,80002776 <balloc+0x11e>
    8000267c:	8baa                	mv	s7,a0
    8000267e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002680:	00014b17          	auipc	s6,0x14
    80002684:	718b0b13          	addi	s6,s6,1816 # 80016d98 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002688:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000268a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000268c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000268e:	6c89                	lui	s9,0x2
    80002690:	a061                	j	80002718 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002692:	97ca                	add	a5,a5,s2
    80002694:	8e55                	or	a2,a2,a3
    80002696:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000269a:	854a                	mv	a0,s2
    8000269c:	00001097          	auipc	ra,0x1
    800026a0:	084080e7          	jalr	132(ra) # 80003720 <log_write>
        brelse(bp);
    800026a4:	854a                	mv	a0,s2
    800026a6:	00000097          	auipc	ra,0x0
    800026aa:	e22080e7          	jalr	-478(ra) # 800024c8 <brelse>
  bp = bread(dev, bno);
    800026ae:	85a6                	mv	a1,s1
    800026b0:	855e                	mv	a0,s7
    800026b2:	00000097          	auipc	ra,0x0
    800026b6:	ce6080e7          	jalr	-794(ra) # 80002398 <bread>
    800026ba:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026bc:	40000613          	li	a2,1024
    800026c0:	4581                	li	a1,0
    800026c2:	05850513          	addi	a0,a0,88
    800026c6:	ffffe097          	auipc	ra,0xffffe
    800026ca:	ab4080e7          	jalr	-1356(ra) # 8000017a <memset>
  log_write(bp);
    800026ce:	854a                	mv	a0,s2
    800026d0:	00001097          	auipc	ra,0x1
    800026d4:	050080e7          	jalr	80(ra) # 80003720 <log_write>
  brelse(bp);
    800026d8:	854a                	mv	a0,s2
    800026da:	00000097          	auipc	ra,0x0
    800026de:	dee080e7          	jalr	-530(ra) # 800024c8 <brelse>
}
    800026e2:	8526                	mv	a0,s1
    800026e4:	60e6                	ld	ra,88(sp)
    800026e6:	6446                	ld	s0,80(sp)
    800026e8:	64a6                	ld	s1,72(sp)
    800026ea:	6906                	ld	s2,64(sp)
    800026ec:	79e2                	ld	s3,56(sp)
    800026ee:	7a42                	ld	s4,48(sp)
    800026f0:	7aa2                	ld	s5,40(sp)
    800026f2:	7b02                	ld	s6,32(sp)
    800026f4:	6be2                	ld	s7,24(sp)
    800026f6:	6c42                	ld	s8,16(sp)
    800026f8:	6ca2                	ld	s9,8(sp)
    800026fa:	6125                	addi	sp,sp,96
    800026fc:	8082                	ret
    brelse(bp);
    800026fe:	854a                	mv	a0,s2
    80002700:	00000097          	auipc	ra,0x0
    80002704:	dc8080e7          	jalr	-568(ra) # 800024c8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002708:	015c87bb          	addw	a5,s9,s5
    8000270c:	00078a9b          	sext.w	s5,a5
    80002710:	004b2703          	lw	a4,4(s6)
    80002714:	06eaf163          	bgeu	s5,a4,80002776 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002718:	41fad79b          	sraiw	a5,s5,0x1f
    8000271c:	0137d79b          	srliw	a5,a5,0x13
    80002720:	015787bb          	addw	a5,a5,s5
    80002724:	40d7d79b          	sraiw	a5,a5,0xd
    80002728:	01cb2583          	lw	a1,28(s6)
    8000272c:	9dbd                	addw	a1,a1,a5
    8000272e:	855e                	mv	a0,s7
    80002730:	00000097          	auipc	ra,0x0
    80002734:	c68080e7          	jalr	-920(ra) # 80002398 <bread>
    80002738:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000273a:	004b2503          	lw	a0,4(s6)
    8000273e:	000a849b          	sext.w	s1,s5
    80002742:	8762                	mv	a4,s8
    80002744:	faa4fde3          	bgeu	s1,a0,800026fe <balloc+0xa6>
      m = 1 << (bi % 8);
    80002748:	00777693          	andi	a3,a4,7
    8000274c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002750:	41f7579b          	sraiw	a5,a4,0x1f
    80002754:	01d7d79b          	srliw	a5,a5,0x1d
    80002758:	9fb9                	addw	a5,a5,a4
    8000275a:	4037d79b          	sraiw	a5,a5,0x3
    8000275e:	00f90633          	add	a2,s2,a5
    80002762:	05864603          	lbu	a2,88(a2)
    80002766:	00c6f5b3          	and	a1,a3,a2
    8000276a:	d585                	beqz	a1,80002692 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000276c:	2705                	addiw	a4,a4,1
    8000276e:	2485                	addiw	s1,s1,1
    80002770:	fd471ae3          	bne	a4,s4,80002744 <balloc+0xec>
    80002774:	b769                	j	800026fe <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002776:	00006517          	auipc	a0,0x6
    8000277a:	cfa50513          	addi	a0,a0,-774 # 80008470 <syscalls+0x100>
    8000277e:	00003097          	auipc	ra,0x3
    80002782:	4f2080e7          	jalr	1266(ra) # 80005c70 <printf>
  return 0;
    80002786:	4481                	li	s1,0
    80002788:	bfa9                	j	800026e2 <balloc+0x8a>

000000008000278a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000278a:	7179                	addi	sp,sp,-48
    8000278c:	f406                	sd	ra,40(sp)
    8000278e:	f022                	sd	s0,32(sp)
    80002790:	ec26                	sd	s1,24(sp)
    80002792:	e84a                	sd	s2,16(sp)
    80002794:	e44e                	sd	s3,8(sp)
    80002796:	e052                	sd	s4,0(sp)
    80002798:	1800                	addi	s0,sp,48
    8000279a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000279c:	47ad                	li	a5,11
    8000279e:	02b7e863          	bltu	a5,a1,800027ce <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800027a2:	02059793          	slli	a5,a1,0x20
    800027a6:	01e7d593          	srli	a1,a5,0x1e
    800027aa:	00b504b3          	add	s1,a0,a1
    800027ae:	0504a903          	lw	s2,80(s1)
    800027b2:	06091e63          	bnez	s2,8000282e <bmap+0xa4>
      addr = balloc(ip->dev);
    800027b6:	4108                	lw	a0,0(a0)
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	ea0080e7          	jalr	-352(ra) # 80002658 <balloc>
    800027c0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027c4:	06090563          	beqz	s2,8000282e <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800027c8:	0524a823          	sw	s2,80(s1)
    800027cc:	a08d                	j	8000282e <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027ce:	ff45849b          	addiw	s1,a1,-12
    800027d2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027d6:	0ff00793          	li	a5,255
    800027da:	08e7e563          	bltu	a5,a4,80002864 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027de:	08052903          	lw	s2,128(a0)
    800027e2:	00091d63          	bnez	s2,800027fc <bmap+0x72>
      addr = balloc(ip->dev);
    800027e6:	4108                	lw	a0,0(a0)
    800027e8:	00000097          	auipc	ra,0x0
    800027ec:	e70080e7          	jalr	-400(ra) # 80002658 <balloc>
    800027f0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027f4:	02090d63          	beqz	s2,8000282e <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800027f8:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800027fc:	85ca                	mv	a1,s2
    800027fe:	0009a503          	lw	a0,0(s3)
    80002802:	00000097          	auipc	ra,0x0
    80002806:	b96080e7          	jalr	-1130(ra) # 80002398 <bread>
    8000280a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000280c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002810:	02049713          	slli	a4,s1,0x20
    80002814:	01e75593          	srli	a1,a4,0x1e
    80002818:	00b784b3          	add	s1,a5,a1
    8000281c:	0004a903          	lw	s2,0(s1)
    80002820:	02090063          	beqz	s2,80002840 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002824:	8552                	mv	a0,s4
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	ca2080e7          	jalr	-862(ra) # 800024c8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000282e:	854a                	mv	a0,s2
    80002830:	70a2                	ld	ra,40(sp)
    80002832:	7402                	ld	s0,32(sp)
    80002834:	64e2                	ld	s1,24(sp)
    80002836:	6942                	ld	s2,16(sp)
    80002838:	69a2                	ld	s3,8(sp)
    8000283a:	6a02                	ld	s4,0(sp)
    8000283c:	6145                	addi	sp,sp,48
    8000283e:	8082                	ret
      addr = balloc(ip->dev);
    80002840:	0009a503          	lw	a0,0(s3)
    80002844:	00000097          	auipc	ra,0x0
    80002848:	e14080e7          	jalr	-492(ra) # 80002658 <balloc>
    8000284c:	0005091b          	sext.w	s2,a0
      if(addr){
    80002850:	fc090ae3          	beqz	s2,80002824 <bmap+0x9a>
        a[bn] = addr;
    80002854:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002858:	8552                	mv	a0,s4
    8000285a:	00001097          	auipc	ra,0x1
    8000285e:	ec6080e7          	jalr	-314(ra) # 80003720 <log_write>
    80002862:	b7c9                	j	80002824 <bmap+0x9a>
  panic("bmap: out of range");
    80002864:	00006517          	auipc	a0,0x6
    80002868:	c2450513          	addi	a0,a0,-988 # 80008488 <syscalls+0x118>
    8000286c:	00003097          	auipc	ra,0x3
    80002870:	3ba080e7          	jalr	954(ra) # 80005c26 <panic>

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
    80002888:	00014517          	auipc	a0,0x14
    8000288c:	53050513          	addi	a0,a0,1328 # 80016db8 <itable>
    80002890:	00004097          	auipc	ra,0x4
    80002894:	8ce080e7          	jalr	-1842(ra) # 8000615e <acquire>
  empty = 0;
    80002898:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000289a:	00014497          	auipc	s1,0x14
    8000289e:	53648493          	addi	s1,s1,1334 # 80016dd0 <itable+0x18>
    800028a2:	00016697          	auipc	a3,0x16
    800028a6:	fbe68693          	addi	a3,a3,-66 # 80018860 <log>
    800028aa:	a039                	j	800028b8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ac:	02090b63          	beqz	s2,800028e2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b0:	08848493          	addi	s1,s1,136
    800028b4:	02d48a63          	beq	s1,a3,800028e8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028b8:	449c                	lw	a5,8(s1)
    800028ba:	fef059e3          	blez	a5,800028ac <iget+0x38>
    800028be:	4098                	lw	a4,0(s1)
    800028c0:	ff3716e3          	bne	a4,s3,800028ac <iget+0x38>
    800028c4:	40d8                	lw	a4,4(s1)
    800028c6:	ff4713e3          	bne	a4,s4,800028ac <iget+0x38>
      ip->ref++;
    800028ca:	2785                	addiw	a5,a5,1
    800028cc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028ce:	00014517          	auipc	a0,0x14
    800028d2:	4ea50513          	addi	a0,a0,1258 # 80016db8 <itable>
    800028d6:	00004097          	auipc	ra,0x4
    800028da:	93c080e7          	jalr	-1732(ra) # 80006212 <release>
      return ip;
    800028de:	8926                	mv	s2,s1
    800028e0:	a03d                	j	8000290e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e2:	f7f9                	bnez	a5,800028b0 <iget+0x3c>
    800028e4:	8926                	mv	s2,s1
    800028e6:	b7e9                	j	800028b0 <iget+0x3c>
  if(empty == 0)
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
    800028fe:	00014517          	auipc	a0,0x14
    80002902:	4ba50513          	addi	a0,a0,1210 # 80016db8 <itable>
    80002906:	00004097          	auipc	ra,0x4
    8000290a:	90c080e7          	jalr	-1780(ra) # 80006212 <release>
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
    80002924:	b8050513          	addi	a0,a0,-1152 # 800084a0 <syscalls+0x130>
    80002928:	00003097          	auipc	ra,0x3
    8000292c:	2fe080e7          	jalr	766(ra) # 80005c26 <panic>

0000000080002930 <fsinit>:
fsinit(int dev) {
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
    80002946:	a56080e7          	jalr	-1450(ra) # 80002398 <bread>
    8000294a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000294c:	00014997          	auipc	s3,0x14
    80002950:	44c98993          	addi	s3,s3,1100 # 80016d98 <sb>
    80002954:	02000613          	li	a2,32
    80002958:	05850593          	addi	a1,a0,88
    8000295c:	854e                	mv	a0,s3
    8000295e:	ffffe097          	auipc	ra,0xffffe
    80002962:	878080e7          	jalr	-1928(ra) # 800001d6 <memmove>
  brelse(bp);
    80002966:	8526                	mv	a0,s1
    80002968:	00000097          	auipc	ra,0x0
    8000296c:	b60080e7          	jalr	-1184(ra) # 800024c8 <brelse>
  if(sb.magic != FSMAGIC)
    80002970:	0009a703          	lw	a4,0(s3)
    80002974:	102037b7          	lui	a5,0x10203
    80002978:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000297c:	02f71263          	bne	a4,a5,800029a0 <fsinit+0x70>
  initlog(dev, &sb);
    80002980:	00014597          	auipc	a1,0x14
    80002984:	41858593          	addi	a1,a1,1048 # 80016d98 <sb>
    80002988:	854a                	mv	a0,s2
    8000298a:	00001097          	auipc	ra,0x1
    8000298e:	b2c080e7          	jalr	-1236(ra) # 800034b6 <initlog>
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
    800029a4:	b1050513          	addi	a0,a0,-1264 # 800084b0 <syscalls+0x140>
    800029a8:	00003097          	auipc	ra,0x3
    800029ac:	27e080e7          	jalr	638(ra) # 80005c26 <panic>

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
    800029c2:	b0a58593          	addi	a1,a1,-1270 # 800084c8 <syscalls+0x158>
    800029c6:	00014517          	auipc	a0,0x14
    800029ca:	3f250513          	addi	a0,a0,1010 # 80016db8 <itable>
    800029ce:	00003097          	auipc	ra,0x3
    800029d2:	700080e7          	jalr	1792(ra) # 800060ce <initlock>
  for(i = 0; i < NINODE; i++) {
    800029d6:	00014497          	auipc	s1,0x14
    800029da:	40a48493          	addi	s1,s1,1034 # 80016de0 <itable+0x28>
    800029de:	00016997          	auipc	s3,0x16
    800029e2:	e9298993          	addi	s3,s3,-366 # 80018870 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029e6:	00006917          	auipc	s2,0x6
    800029ea:	aea90913          	addi	s2,s2,-1302 # 800084d0 <syscalls+0x160>
    800029ee:	85ca                	mv	a1,s2
    800029f0:	8526                	mv	a0,s1
    800029f2:	00001097          	auipc	ra,0x1
    800029f6:	e12080e7          	jalr	-494(ra) # 80003804 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
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
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a24:	00014717          	auipc	a4,0x14
    80002a28:	38072703          	lw	a4,896(a4) # 80016da4 <sb+0xc>
    80002a2c:	4785                	li	a5,1
    80002a2e:	04e7f863          	bgeu	a5,a4,80002a7e <ialloc+0x6e>
    80002a32:	8aaa                	mv	s5,a0
    80002a34:	8b2e                	mv	s6,a1
    80002a36:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a38:	00014a17          	auipc	s4,0x14
    80002a3c:	360a0a13          	addi	s4,s4,864 # 80016d98 <sb>
    80002a40:	00495593          	srli	a1,s2,0x4
    80002a44:	018a2783          	lw	a5,24(s4)
    80002a48:	9dbd                	addw	a1,a1,a5
    80002a4a:	8556                	mv	a0,s5
    80002a4c:	00000097          	auipc	ra,0x0
    80002a50:	94c080e7          	jalr	-1716(ra) # 80002398 <bread>
    80002a54:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a56:	05850993          	addi	s3,a0,88
    80002a5a:	00f97793          	andi	a5,s2,15
    80002a5e:	079a                	slli	a5,a5,0x6
    80002a60:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a62:	00099783          	lh	a5,0(s3)
    80002a66:	cf9d                	beqz	a5,80002aa4 <ialloc+0x94>
    brelse(bp);
    80002a68:	00000097          	auipc	ra,0x0
    80002a6c:	a60080e7          	jalr	-1440(ra) # 800024c8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a70:	0905                	addi	s2,s2,1
    80002a72:	00ca2703          	lw	a4,12(s4)
    80002a76:	0009079b          	sext.w	a5,s2
    80002a7a:	fce7e3e3          	bltu	a5,a4,80002a40 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002a7e:	00006517          	auipc	a0,0x6
    80002a82:	a5a50513          	addi	a0,a0,-1446 # 800084d8 <syscalls+0x168>
    80002a86:	00003097          	auipc	ra,0x3
    80002a8a:	1ea080e7          	jalr	490(ra) # 80005c70 <printf>
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
      log_write(bp);   // mark it allocated on the disk
    80002ab8:	8526                	mv	a0,s1
    80002aba:	00001097          	auipc	ra,0x1
    80002abe:	c66080e7          	jalr	-922(ra) # 80003720 <log_write>
      brelse(bp);
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	a04080e7          	jalr	-1532(ra) # 800024c8 <brelse>
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
    80002af0:	00014597          	auipc	a1,0x14
    80002af4:	2c05a583          	lw	a1,704(a1) # 80016db0 <sb+0x18>
    80002af8:	9dbd                	addw	a1,a1,a5
    80002afa:	4108                	lw	a0,0(a0)
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	89c080e7          	jalr	-1892(ra) # 80002398 <bread>
    80002b04:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
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
    80002b50:	bd4080e7          	jalr	-1068(ra) # 80003720 <log_write>
  brelse(bp);
    80002b54:	854a                	mv	a0,s2
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	972080e7          	jalr	-1678(ra) # 800024c8 <brelse>
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
    80002b76:	00014517          	auipc	a0,0x14
    80002b7a:	24250513          	addi	a0,a0,578 # 80016db8 <itable>
    80002b7e:	00003097          	auipc	ra,0x3
    80002b82:	5e0080e7          	jalr	1504(ra) # 8000615e <acquire>
  ip->ref++;
    80002b86:	449c                	lw	a5,8(s1)
    80002b88:	2785                	addiw	a5,a5,1
    80002b8a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b8c:	00014517          	auipc	a0,0x14
    80002b90:	22c50513          	addi	a0,a0,556 # 80016db8 <itable>
    80002b94:	00003097          	auipc	ra,0x3
    80002b98:	67e080e7          	jalr	1662(ra) # 80006212 <release>
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
  if(ip == 0 || ip->ref < 1)
    80002bb4:	c115                	beqz	a0,80002bd8 <ilock+0x30>
    80002bb6:	84aa                	mv	s1,a0
    80002bb8:	451c                	lw	a5,8(a0)
    80002bba:	00f05f63          	blez	a5,80002bd8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bbe:	0541                	addi	a0,a0,16
    80002bc0:	00001097          	auipc	ra,0x1
    80002bc4:	c7e080e7          	jalr	-898(ra) # 8000383e <acquiresleep>
  if(ip->valid == 0){
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
    80002bdc:	91850513          	addi	a0,a0,-1768 # 800084f0 <syscalls+0x180>
    80002be0:	00003097          	auipc	ra,0x3
    80002be4:	046080e7          	jalr	70(ra) # 80005c26 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002be8:	40dc                	lw	a5,4(s1)
    80002bea:	0047d79b          	srliw	a5,a5,0x4
    80002bee:	00014597          	auipc	a1,0x14
    80002bf2:	1c25a583          	lw	a1,450(a1) # 80016db0 <sb+0x18>
    80002bf6:	9dbd                	addw	a1,a1,a5
    80002bf8:	4088                	lw	a0,0(s1)
    80002bfa:	fffff097          	auipc	ra,0xfffff
    80002bfe:	79e080e7          	jalr	1950(ra) # 80002398 <bread>
    80002c02:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
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
    80002c48:	00000097          	auipc	ra,0x0
    80002c4c:	880080e7          	jalr	-1920(ra) # 800024c8 <brelse>
    ip->valid = 1;
    80002c50:	4785                	li	a5,1
    80002c52:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c54:	04449783          	lh	a5,68(s1)
    80002c58:	fbb5                	bnez	a5,80002bcc <ilock+0x24>
      panic("ilock: no type");
    80002c5a:	00006517          	auipc	a0,0x6
    80002c5e:	89e50513          	addi	a0,a0,-1890 # 800084f8 <syscalls+0x188>
    80002c62:	00003097          	auipc	ra,0x3
    80002c66:	fc4080e7          	jalr	-60(ra) # 80005c26 <panic>

0000000080002c6a <iunlock>:
{
    80002c6a:	1101                	addi	sp,sp,-32
    80002c6c:	ec06                	sd	ra,24(sp)
    80002c6e:	e822                	sd	s0,16(sp)
    80002c70:	e426                	sd	s1,8(sp)
    80002c72:	e04a                	sd	s2,0(sp)
    80002c74:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c76:	c905                	beqz	a0,80002ca6 <iunlock+0x3c>
    80002c78:	84aa                	mv	s1,a0
    80002c7a:	01050913          	addi	s2,a0,16
    80002c7e:	854a                	mv	a0,s2
    80002c80:	00001097          	auipc	ra,0x1
    80002c84:	c58080e7          	jalr	-936(ra) # 800038d8 <holdingsleep>
    80002c88:	cd19                	beqz	a0,80002ca6 <iunlock+0x3c>
    80002c8a:	449c                	lw	a5,8(s1)
    80002c8c:	00f05d63          	blez	a5,80002ca6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c90:	854a                	mv	a0,s2
    80002c92:	00001097          	auipc	ra,0x1
    80002c96:	c02080e7          	jalr	-1022(ra) # 80003894 <releasesleep>
}
    80002c9a:	60e2                	ld	ra,24(sp)
    80002c9c:	6442                	ld	s0,16(sp)
    80002c9e:	64a2                	ld	s1,8(sp)
    80002ca0:	6902                	ld	s2,0(sp)
    80002ca2:	6105                	addi	sp,sp,32
    80002ca4:	8082                	ret
    panic("iunlock");
    80002ca6:	00006517          	auipc	a0,0x6
    80002caa:	86250513          	addi	a0,a0,-1950 # 80008508 <syscalls+0x198>
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	f78080e7          	jalr	-136(ra) # 80005c26 <panic>

0000000080002cb6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cb6:	7179                	addi	sp,sp,-48
    80002cb8:	f406                	sd	ra,40(sp)
    80002cba:	f022                	sd	s0,32(sp)
    80002cbc:	ec26                	sd	s1,24(sp)
    80002cbe:	e84a                	sd	s2,16(sp)
    80002cc0:	e44e                	sd	s3,8(sp)
    80002cc2:	e052                	sd	s4,0(sp)
    80002cc4:	1800                	addi	s0,sp,48
    80002cc6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cc8:	05050493          	addi	s1,a0,80
    80002ccc:	08050913          	addi	s2,a0,128
    80002cd0:	a021                	j	80002cd8 <itrunc+0x22>
    80002cd2:	0491                	addi	s1,s1,4
    80002cd4:	01248d63          	beq	s1,s2,80002cee <itrunc+0x38>
    if(ip->addrs[i]){
    80002cd8:	408c                	lw	a1,0(s1)
    80002cda:	dde5                	beqz	a1,80002cd2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cdc:	0009a503          	lw	a0,0(s3)
    80002ce0:	00000097          	auipc	ra,0x0
    80002ce4:	8fc080e7          	jalr	-1796(ra) # 800025dc <bfree>
      ip->addrs[i] = 0;
    80002ce8:	0004a023          	sw	zero,0(s1)
    80002cec:	b7dd                	j	80002cd2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cee:	0809a583          	lw	a1,128(s3)
    80002cf2:	e185                	bnez	a1,80002d12 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cf4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cf8:	854e                	mv	a0,s3
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	de2080e7          	jalr	-542(ra) # 80002adc <iupdate>
}
    80002d02:	70a2                	ld	ra,40(sp)
    80002d04:	7402                	ld	s0,32(sp)
    80002d06:	64e2                	ld	s1,24(sp)
    80002d08:	6942                	ld	s2,16(sp)
    80002d0a:	69a2                	ld	s3,8(sp)
    80002d0c:	6a02                	ld	s4,0(sp)
    80002d0e:	6145                	addi	sp,sp,48
    80002d10:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d12:	0009a503          	lw	a0,0(s3)
    80002d16:	fffff097          	auipc	ra,0xfffff
    80002d1a:	682080e7          	jalr	1666(ra) # 80002398 <bread>
    80002d1e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d20:	05850493          	addi	s1,a0,88
    80002d24:	45850913          	addi	s2,a0,1112
    80002d28:	a021                	j	80002d30 <itrunc+0x7a>
    80002d2a:	0491                	addi	s1,s1,4
    80002d2c:	01248b63          	beq	s1,s2,80002d42 <itrunc+0x8c>
      if(a[j])
    80002d30:	408c                	lw	a1,0(s1)
    80002d32:	dde5                	beqz	a1,80002d2a <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d34:	0009a503          	lw	a0,0(s3)
    80002d38:	00000097          	auipc	ra,0x0
    80002d3c:	8a4080e7          	jalr	-1884(ra) # 800025dc <bfree>
    80002d40:	b7ed                	j	80002d2a <itrunc+0x74>
    brelse(bp);
    80002d42:	8552                	mv	a0,s4
    80002d44:	fffff097          	auipc	ra,0xfffff
    80002d48:	784080e7          	jalr	1924(ra) # 800024c8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d4c:	0809a583          	lw	a1,128(s3)
    80002d50:	0009a503          	lw	a0,0(s3)
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	888080e7          	jalr	-1912(ra) # 800025dc <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d5c:	0809a023          	sw	zero,128(s3)
    80002d60:	bf51                	j	80002cf4 <itrunc+0x3e>

0000000080002d62 <iput>:
{
    80002d62:	1101                	addi	sp,sp,-32
    80002d64:	ec06                	sd	ra,24(sp)
    80002d66:	e822                	sd	s0,16(sp)
    80002d68:	e426                	sd	s1,8(sp)
    80002d6a:	e04a                	sd	s2,0(sp)
    80002d6c:	1000                	addi	s0,sp,32
    80002d6e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d70:	00014517          	auipc	a0,0x14
    80002d74:	04850513          	addi	a0,a0,72 # 80016db8 <itable>
    80002d78:	00003097          	auipc	ra,0x3
    80002d7c:	3e6080e7          	jalr	998(ra) # 8000615e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d80:	4498                	lw	a4,8(s1)
    80002d82:	4785                	li	a5,1
    80002d84:	02f70363          	beq	a4,a5,80002daa <iput+0x48>
  ip->ref--;
    80002d88:	449c                	lw	a5,8(s1)
    80002d8a:	37fd                	addiw	a5,a5,-1
    80002d8c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d8e:	00014517          	auipc	a0,0x14
    80002d92:	02a50513          	addi	a0,a0,42 # 80016db8 <itable>
    80002d96:	00003097          	auipc	ra,0x3
    80002d9a:	47c080e7          	jalr	1148(ra) # 80006212 <release>
}
    80002d9e:	60e2                	ld	ra,24(sp)
    80002da0:	6442                	ld	s0,16(sp)
    80002da2:	64a2                	ld	s1,8(sp)
    80002da4:	6902                	ld	s2,0(sp)
    80002da6:	6105                	addi	sp,sp,32
    80002da8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002daa:	40bc                	lw	a5,64(s1)
    80002dac:	dff1                	beqz	a5,80002d88 <iput+0x26>
    80002dae:	04a49783          	lh	a5,74(s1)
    80002db2:	fbf9                	bnez	a5,80002d88 <iput+0x26>
    acquiresleep(&ip->lock);
    80002db4:	01048913          	addi	s2,s1,16
    80002db8:	854a                	mv	a0,s2
    80002dba:	00001097          	auipc	ra,0x1
    80002dbe:	a84080e7          	jalr	-1404(ra) # 8000383e <acquiresleep>
    release(&itable.lock);
    80002dc2:	00014517          	auipc	a0,0x14
    80002dc6:	ff650513          	addi	a0,a0,-10 # 80016db8 <itable>
    80002dca:	00003097          	auipc	ra,0x3
    80002dce:	448080e7          	jalr	1096(ra) # 80006212 <release>
    itrunc(ip);
    80002dd2:	8526                	mv	a0,s1
    80002dd4:	00000097          	auipc	ra,0x0
    80002dd8:	ee2080e7          	jalr	-286(ra) # 80002cb6 <itrunc>
    ip->type = 0;
    80002ddc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002de0:	8526                	mv	a0,s1
    80002de2:	00000097          	auipc	ra,0x0
    80002de6:	cfa080e7          	jalr	-774(ra) # 80002adc <iupdate>
    ip->valid = 0;
    80002dea:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dee:	854a                	mv	a0,s2
    80002df0:	00001097          	auipc	ra,0x1
    80002df4:	aa4080e7          	jalr	-1372(ra) # 80003894 <releasesleep>
    acquire(&itable.lock);
    80002df8:	00014517          	auipc	a0,0x14
    80002dfc:	fc050513          	addi	a0,a0,-64 # 80016db8 <itable>
    80002e00:	00003097          	auipc	ra,0x3
    80002e04:	35e080e7          	jalr	862(ra) # 8000615e <acquire>
    80002e08:	b741                	j	80002d88 <iput+0x26>

0000000080002e0a <iunlockput>:
{
    80002e0a:	1101                	addi	sp,sp,-32
    80002e0c:	ec06                	sd	ra,24(sp)
    80002e0e:	e822                	sd	s0,16(sp)
    80002e10:	e426                	sd	s1,8(sp)
    80002e12:	1000                	addi	s0,sp,32
    80002e14:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	e54080e7          	jalr	-428(ra) # 80002c6a <iunlock>
  iput(ip);
    80002e1e:	8526                	mv	a0,s1
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	f42080e7          	jalr	-190(ra) # 80002d62 <iput>
}
    80002e28:	60e2                	ld	ra,24(sp)
    80002e2a:	6442                	ld	s0,16(sp)
    80002e2c:	64a2                	ld	s1,8(sp)
    80002e2e:	6105                	addi	sp,sp,32
    80002e30:	8082                	ret

0000000080002e32 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e32:	1141                	addi	sp,sp,-16
    80002e34:	e422                	sd	s0,8(sp)
    80002e36:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e38:	411c                	lw	a5,0(a0)
    80002e3a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e3c:	415c                	lw	a5,4(a0)
    80002e3e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e40:	04451783          	lh	a5,68(a0)
    80002e44:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e48:	04a51783          	lh	a5,74(a0)
    80002e4c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e50:	04c56783          	lwu	a5,76(a0)
    80002e54:	e99c                	sd	a5,16(a1)
}
    80002e56:	6422                	ld	s0,8(sp)
    80002e58:	0141                	addi	sp,sp,16
    80002e5a:	8082                	ret

0000000080002e5c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e5c:	457c                	lw	a5,76(a0)
    80002e5e:	0ed7e963          	bltu	a5,a3,80002f50 <readi+0xf4>
{
    80002e62:	7159                	addi	sp,sp,-112
    80002e64:	f486                	sd	ra,104(sp)
    80002e66:	f0a2                	sd	s0,96(sp)
    80002e68:	eca6                	sd	s1,88(sp)
    80002e6a:	e8ca                	sd	s2,80(sp)
    80002e6c:	e4ce                	sd	s3,72(sp)
    80002e6e:	e0d2                	sd	s4,64(sp)
    80002e70:	fc56                	sd	s5,56(sp)
    80002e72:	f85a                	sd	s6,48(sp)
    80002e74:	f45e                	sd	s7,40(sp)
    80002e76:	f062                	sd	s8,32(sp)
    80002e78:	ec66                	sd	s9,24(sp)
    80002e7a:	e86a                	sd	s10,16(sp)
    80002e7c:	e46e                	sd	s11,8(sp)
    80002e7e:	1880                	addi	s0,sp,112
    80002e80:	8b2a                	mv	s6,a0
    80002e82:	8bae                	mv	s7,a1
    80002e84:	8a32                	mv	s4,a2
    80002e86:	84b6                	mv	s1,a3
    80002e88:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e8a:	9f35                	addw	a4,a4,a3
    return 0;
    80002e8c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e8e:	0ad76063          	bltu	a4,a3,80002f2e <readi+0xd2>
  if(off + n > ip->size)
    80002e92:	00e7f463          	bgeu	a5,a4,80002e9a <readi+0x3e>
    n = ip->size - off;
    80002e96:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e9a:	0a0a8963          	beqz	s5,80002f4c <readi+0xf0>
    80002e9e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ea0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ea4:	5c7d                	li	s8,-1
    80002ea6:	a82d                	j	80002ee0 <readi+0x84>
    80002ea8:	020d1d93          	slli	s11,s10,0x20
    80002eac:	020ddd93          	srli	s11,s11,0x20
    80002eb0:	05890613          	addi	a2,s2,88
    80002eb4:	86ee                	mv	a3,s11
    80002eb6:	963a                	add	a2,a2,a4
    80002eb8:	85d2                	mv	a1,s4
    80002eba:	855e                	mv	a0,s7
    80002ebc:	fffff097          	auipc	ra,0xfffff
    80002ec0:	ad0080e7          	jalr	-1328(ra) # 8000198c <either_copyout>
    80002ec4:	05850d63          	beq	a0,s8,80002f1e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ec8:	854a                	mv	a0,s2
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	5fe080e7          	jalr	1534(ra) # 800024c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed2:	013d09bb          	addw	s3,s10,s3
    80002ed6:	009d04bb          	addw	s1,s10,s1
    80002eda:	9a6e                	add	s4,s4,s11
    80002edc:	0559f763          	bgeu	s3,s5,80002f2a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002ee0:	00a4d59b          	srliw	a1,s1,0xa
    80002ee4:	855a                	mv	a0,s6
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	8a4080e7          	jalr	-1884(ra) # 8000278a <bmap>
    80002eee:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ef2:	cd85                	beqz	a1,80002f2a <readi+0xce>
    bp = bread(ip->dev, addr);
    80002ef4:	000b2503          	lw	a0,0(s6)
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	4a0080e7          	jalr	1184(ra) # 80002398 <bread>
    80002f00:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f02:	3ff4f713          	andi	a4,s1,1023
    80002f06:	40ec87bb          	subw	a5,s9,a4
    80002f0a:	413a86bb          	subw	a3,s5,s3
    80002f0e:	8d3e                	mv	s10,a5
    80002f10:	2781                	sext.w	a5,a5
    80002f12:	0006861b          	sext.w	a2,a3
    80002f16:	f8f679e3          	bgeu	a2,a5,80002ea8 <readi+0x4c>
    80002f1a:	8d36                	mv	s10,a3
    80002f1c:	b771                	j	80002ea8 <readi+0x4c>
      brelse(bp);
    80002f1e:	854a                	mv	a0,s2
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	5a8080e7          	jalr	1448(ra) # 800024c8 <brelse>
      tot = -1;
    80002f28:	59fd                	li	s3,-1
  }
  return tot;
    80002f2a:	0009851b          	sext.w	a0,s3
}
    80002f2e:	70a6                	ld	ra,104(sp)
    80002f30:	7406                	ld	s0,96(sp)
    80002f32:	64e6                	ld	s1,88(sp)
    80002f34:	6946                	ld	s2,80(sp)
    80002f36:	69a6                	ld	s3,72(sp)
    80002f38:	6a06                	ld	s4,64(sp)
    80002f3a:	7ae2                	ld	s5,56(sp)
    80002f3c:	7b42                	ld	s6,48(sp)
    80002f3e:	7ba2                	ld	s7,40(sp)
    80002f40:	7c02                	ld	s8,32(sp)
    80002f42:	6ce2                	ld	s9,24(sp)
    80002f44:	6d42                	ld	s10,16(sp)
    80002f46:	6da2                	ld	s11,8(sp)
    80002f48:	6165                	addi	sp,sp,112
    80002f4a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f4c:	89d6                	mv	s3,s5
    80002f4e:	bff1                	j	80002f2a <readi+0xce>
    return 0;
    80002f50:	4501                	li	a0,0
}
    80002f52:	8082                	ret

0000000080002f54 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f54:	457c                	lw	a5,76(a0)
    80002f56:	10d7e863          	bltu	a5,a3,80003066 <writei+0x112>
{
    80002f5a:	7159                	addi	sp,sp,-112
    80002f5c:	f486                	sd	ra,104(sp)
    80002f5e:	f0a2                	sd	s0,96(sp)
    80002f60:	eca6                	sd	s1,88(sp)
    80002f62:	e8ca                	sd	s2,80(sp)
    80002f64:	e4ce                	sd	s3,72(sp)
    80002f66:	e0d2                	sd	s4,64(sp)
    80002f68:	fc56                	sd	s5,56(sp)
    80002f6a:	f85a                	sd	s6,48(sp)
    80002f6c:	f45e                	sd	s7,40(sp)
    80002f6e:	f062                	sd	s8,32(sp)
    80002f70:	ec66                	sd	s9,24(sp)
    80002f72:	e86a                	sd	s10,16(sp)
    80002f74:	e46e                	sd	s11,8(sp)
    80002f76:	1880                	addi	s0,sp,112
    80002f78:	8aaa                	mv	s5,a0
    80002f7a:	8bae                	mv	s7,a1
    80002f7c:	8a32                	mv	s4,a2
    80002f7e:	8936                	mv	s2,a3
    80002f80:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f82:	00e687bb          	addw	a5,a3,a4
    80002f86:	0ed7e263          	bltu	a5,a3,8000306a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f8a:	00043737          	lui	a4,0x43
    80002f8e:	0ef76063          	bltu	a4,a5,8000306e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f92:	0c0b0863          	beqz	s6,80003062 <writei+0x10e>
    80002f96:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f98:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f9c:	5c7d                	li	s8,-1
    80002f9e:	a091                	j	80002fe2 <writei+0x8e>
    80002fa0:	020d1d93          	slli	s11,s10,0x20
    80002fa4:	020ddd93          	srli	s11,s11,0x20
    80002fa8:	05848513          	addi	a0,s1,88
    80002fac:	86ee                	mv	a3,s11
    80002fae:	8652                	mv	a2,s4
    80002fb0:	85de                	mv	a1,s7
    80002fb2:	953a                	add	a0,a0,a4
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	a2e080e7          	jalr	-1490(ra) # 800019e2 <either_copyin>
    80002fbc:	07850263          	beq	a0,s8,80003020 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fc0:	8526                	mv	a0,s1
    80002fc2:	00000097          	auipc	ra,0x0
    80002fc6:	75e080e7          	jalr	1886(ra) # 80003720 <log_write>
    brelse(bp);
    80002fca:	8526                	mv	a0,s1
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	4fc080e7          	jalr	1276(ra) # 800024c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd4:	013d09bb          	addw	s3,s10,s3
    80002fd8:	012d093b          	addw	s2,s10,s2
    80002fdc:	9a6e                	add	s4,s4,s11
    80002fde:	0569f663          	bgeu	s3,s6,8000302a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002fe2:	00a9559b          	srliw	a1,s2,0xa
    80002fe6:	8556                	mv	a0,s5
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	7a2080e7          	jalr	1954(ra) # 8000278a <bmap>
    80002ff0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ff4:	c99d                	beqz	a1,8000302a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002ff6:	000aa503          	lw	a0,0(s5)
    80002ffa:	fffff097          	auipc	ra,0xfffff
    80002ffe:	39e080e7          	jalr	926(ra) # 80002398 <bread>
    80003002:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003004:	3ff97713          	andi	a4,s2,1023
    80003008:	40ec87bb          	subw	a5,s9,a4
    8000300c:	413b06bb          	subw	a3,s6,s3
    80003010:	8d3e                	mv	s10,a5
    80003012:	2781                	sext.w	a5,a5
    80003014:	0006861b          	sext.w	a2,a3
    80003018:	f8f674e3          	bgeu	a2,a5,80002fa0 <writei+0x4c>
    8000301c:	8d36                	mv	s10,a3
    8000301e:	b749                	j	80002fa0 <writei+0x4c>
      brelse(bp);
    80003020:	8526                	mv	a0,s1
    80003022:	fffff097          	auipc	ra,0xfffff
    80003026:	4a6080e7          	jalr	1190(ra) # 800024c8 <brelse>
  }

  if(off > ip->size)
    8000302a:	04caa783          	lw	a5,76(s5)
    8000302e:	0127f463          	bgeu	a5,s2,80003036 <writei+0xe2>
    ip->size = off;
    80003032:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003036:	8556                	mv	a0,s5
    80003038:	00000097          	auipc	ra,0x0
    8000303c:	aa4080e7          	jalr	-1372(ra) # 80002adc <iupdate>

  return tot;
    80003040:	0009851b          	sext.w	a0,s3
}
    80003044:	70a6                	ld	ra,104(sp)
    80003046:	7406                	ld	s0,96(sp)
    80003048:	64e6                	ld	s1,88(sp)
    8000304a:	6946                	ld	s2,80(sp)
    8000304c:	69a6                	ld	s3,72(sp)
    8000304e:	6a06                	ld	s4,64(sp)
    80003050:	7ae2                	ld	s5,56(sp)
    80003052:	7b42                	ld	s6,48(sp)
    80003054:	7ba2                	ld	s7,40(sp)
    80003056:	7c02                	ld	s8,32(sp)
    80003058:	6ce2                	ld	s9,24(sp)
    8000305a:	6d42                	ld	s10,16(sp)
    8000305c:	6da2                	ld	s11,8(sp)
    8000305e:	6165                	addi	sp,sp,112
    80003060:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003062:	89da                	mv	s3,s6
    80003064:	bfc9                	j	80003036 <writei+0xe2>
    return -1;
    80003066:	557d                	li	a0,-1
}
    80003068:	8082                	ret
    return -1;
    8000306a:	557d                	li	a0,-1
    8000306c:	bfe1                	j	80003044 <writei+0xf0>
    return -1;
    8000306e:	557d                	li	a0,-1
    80003070:	bfd1                	j	80003044 <writei+0xf0>

0000000080003072 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003072:	1141                	addi	sp,sp,-16
    80003074:	e406                	sd	ra,8(sp)
    80003076:	e022                	sd	s0,0(sp)
    80003078:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000307a:	4639                	li	a2,14
    8000307c:	ffffd097          	auipc	ra,0xffffd
    80003080:	1ce080e7          	jalr	462(ra) # 8000024a <strncmp>
}
    80003084:	60a2                	ld	ra,8(sp)
    80003086:	6402                	ld	s0,0(sp)
    80003088:	0141                	addi	sp,sp,16
    8000308a:	8082                	ret

000000008000308c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000308c:	7139                	addi	sp,sp,-64
    8000308e:	fc06                	sd	ra,56(sp)
    80003090:	f822                	sd	s0,48(sp)
    80003092:	f426                	sd	s1,40(sp)
    80003094:	f04a                	sd	s2,32(sp)
    80003096:	ec4e                	sd	s3,24(sp)
    80003098:	e852                	sd	s4,16(sp)
    8000309a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000309c:	04451703          	lh	a4,68(a0)
    800030a0:	4785                	li	a5,1
    800030a2:	00f71a63          	bne	a4,a5,800030b6 <dirlookup+0x2a>
    800030a6:	892a                	mv	s2,a0
    800030a8:	89ae                	mv	s3,a1
    800030aa:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ac:	457c                	lw	a5,76(a0)
    800030ae:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030b0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030b2:	e79d                	bnez	a5,800030e0 <dirlookup+0x54>
    800030b4:	a8a5                	j	8000312c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030b6:	00005517          	auipc	a0,0x5
    800030ba:	45a50513          	addi	a0,a0,1114 # 80008510 <syscalls+0x1a0>
    800030be:	00003097          	auipc	ra,0x3
    800030c2:	b68080e7          	jalr	-1176(ra) # 80005c26 <panic>
      panic("dirlookup read");
    800030c6:	00005517          	auipc	a0,0x5
    800030ca:	46250513          	addi	a0,a0,1122 # 80008528 <syscalls+0x1b8>
    800030ce:	00003097          	auipc	ra,0x3
    800030d2:	b58080e7          	jalr	-1192(ra) # 80005c26 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d6:	24c1                	addiw	s1,s1,16
    800030d8:	04c92783          	lw	a5,76(s2)
    800030dc:	04f4f763          	bgeu	s1,a5,8000312a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030e0:	4741                	li	a4,16
    800030e2:	86a6                	mv	a3,s1
    800030e4:	fc040613          	addi	a2,s0,-64
    800030e8:	4581                	li	a1,0
    800030ea:	854a                	mv	a0,s2
    800030ec:	00000097          	auipc	ra,0x0
    800030f0:	d70080e7          	jalr	-656(ra) # 80002e5c <readi>
    800030f4:	47c1                	li	a5,16
    800030f6:	fcf518e3          	bne	a0,a5,800030c6 <dirlookup+0x3a>
    if(de.inum == 0)
    800030fa:	fc045783          	lhu	a5,-64(s0)
    800030fe:	dfe1                	beqz	a5,800030d6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003100:	fc240593          	addi	a1,s0,-62
    80003104:	854e                	mv	a0,s3
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	f6c080e7          	jalr	-148(ra) # 80003072 <namecmp>
    8000310e:	f561                	bnez	a0,800030d6 <dirlookup+0x4a>
      if(poff)
    80003110:	000a0463          	beqz	s4,80003118 <dirlookup+0x8c>
        *poff = off;
    80003114:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003118:	fc045583          	lhu	a1,-64(s0)
    8000311c:	00092503          	lw	a0,0(s2)
    80003120:	fffff097          	auipc	ra,0xfffff
    80003124:	754080e7          	jalr	1876(ra) # 80002874 <iget>
    80003128:	a011                	j	8000312c <dirlookup+0xa0>
  return 0;
    8000312a:	4501                	li	a0,0
}
    8000312c:	70e2                	ld	ra,56(sp)
    8000312e:	7442                	ld	s0,48(sp)
    80003130:	74a2                	ld	s1,40(sp)
    80003132:	7902                	ld	s2,32(sp)
    80003134:	69e2                	ld	s3,24(sp)
    80003136:	6a42                	ld	s4,16(sp)
    80003138:	6121                	addi	sp,sp,64
    8000313a:	8082                	ret

000000008000313c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000313c:	711d                	addi	sp,sp,-96
    8000313e:	ec86                	sd	ra,88(sp)
    80003140:	e8a2                	sd	s0,80(sp)
    80003142:	e4a6                	sd	s1,72(sp)
    80003144:	e0ca                	sd	s2,64(sp)
    80003146:	fc4e                	sd	s3,56(sp)
    80003148:	f852                	sd	s4,48(sp)
    8000314a:	f456                	sd	s5,40(sp)
    8000314c:	f05a                	sd	s6,32(sp)
    8000314e:	ec5e                	sd	s7,24(sp)
    80003150:	e862                	sd	s8,16(sp)
    80003152:	e466                	sd	s9,8(sp)
    80003154:	1080                	addi	s0,sp,96
    80003156:	84aa                	mv	s1,a0
    80003158:	8b2e                	mv	s6,a1
    8000315a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000315c:	00054703          	lbu	a4,0(a0)
    80003160:	02f00793          	li	a5,47
    80003164:	02f70263          	beq	a4,a5,80003188 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003168:	ffffe097          	auipc	ra,0xffffe
    8000316c:	d74080e7          	jalr	-652(ra) # 80000edc <myproc>
    80003170:	15053503          	ld	a0,336(a0)
    80003174:	00000097          	auipc	ra,0x0
    80003178:	9f6080e7          	jalr	-1546(ra) # 80002b6a <idup>
    8000317c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000317e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003182:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003184:	4b85                	li	s7,1
    80003186:	a875                	j	80003242 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003188:	4585                	li	a1,1
    8000318a:	4505                	li	a0,1
    8000318c:	fffff097          	auipc	ra,0xfffff
    80003190:	6e8080e7          	jalr	1768(ra) # 80002874 <iget>
    80003194:	8a2a                	mv	s4,a0
    80003196:	b7e5                	j	8000317e <namex+0x42>
      iunlockput(ip);
    80003198:	8552                	mv	a0,s4
    8000319a:	00000097          	auipc	ra,0x0
    8000319e:	c70080e7          	jalr	-912(ra) # 80002e0a <iunlockput>
      return 0;
    800031a2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031a4:	8552                	mv	a0,s4
    800031a6:	60e6                	ld	ra,88(sp)
    800031a8:	6446                	ld	s0,80(sp)
    800031aa:	64a6                	ld	s1,72(sp)
    800031ac:	6906                	ld	s2,64(sp)
    800031ae:	79e2                	ld	s3,56(sp)
    800031b0:	7a42                	ld	s4,48(sp)
    800031b2:	7aa2                	ld	s5,40(sp)
    800031b4:	7b02                	ld	s6,32(sp)
    800031b6:	6be2                	ld	s7,24(sp)
    800031b8:	6c42                	ld	s8,16(sp)
    800031ba:	6ca2                	ld	s9,8(sp)
    800031bc:	6125                	addi	sp,sp,96
    800031be:	8082                	ret
      iunlock(ip);
    800031c0:	8552                	mv	a0,s4
    800031c2:	00000097          	auipc	ra,0x0
    800031c6:	aa8080e7          	jalr	-1368(ra) # 80002c6a <iunlock>
      return ip;
    800031ca:	bfe9                	j	800031a4 <namex+0x68>
      iunlockput(ip);
    800031cc:	8552                	mv	a0,s4
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	c3c080e7          	jalr	-964(ra) # 80002e0a <iunlockput>
      return 0;
    800031d6:	8a4e                	mv	s4,s3
    800031d8:	b7f1                	j	800031a4 <namex+0x68>
  len = path - s;
    800031da:	40998633          	sub	a2,s3,s1
    800031de:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800031e2:	099c5863          	bge	s8,s9,80003272 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800031e6:	4639                	li	a2,14
    800031e8:	85a6                	mv	a1,s1
    800031ea:	8556                	mv	a0,s5
    800031ec:	ffffd097          	auipc	ra,0xffffd
    800031f0:	fea080e7          	jalr	-22(ra) # 800001d6 <memmove>
    800031f4:	84ce                	mv	s1,s3
  while(*path == '/')
    800031f6:	0004c783          	lbu	a5,0(s1)
    800031fa:	01279763          	bne	a5,s2,80003208 <namex+0xcc>
    path++;
    800031fe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003200:	0004c783          	lbu	a5,0(s1)
    80003204:	ff278de3          	beq	a5,s2,800031fe <namex+0xc2>
    ilock(ip);
    80003208:	8552                	mv	a0,s4
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	99e080e7          	jalr	-1634(ra) # 80002ba8 <ilock>
    if(ip->type != T_DIR){
    80003212:	044a1783          	lh	a5,68(s4)
    80003216:	f97791e3          	bne	a5,s7,80003198 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000321a:	000b0563          	beqz	s6,80003224 <namex+0xe8>
    8000321e:	0004c783          	lbu	a5,0(s1)
    80003222:	dfd9                	beqz	a5,800031c0 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003224:	4601                	li	a2,0
    80003226:	85d6                	mv	a1,s5
    80003228:	8552                	mv	a0,s4
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	e62080e7          	jalr	-414(ra) # 8000308c <dirlookup>
    80003232:	89aa                	mv	s3,a0
    80003234:	dd41                	beqz	a0,800031cc <namex+0x90>
    iunlockput(ip);
    80003236:	8552                	mv	a0,s4
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	bd2080e7          	jalr	-1070(ra) # 80002e0a <iunlockput>
    ip = next;
    80003240:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003242:	0004c783          	lbu	a5,0(s1)
    80003246:	01279763          	bne	a5,s2,80003254 <namex+0x118>
    path++;
    8000324a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000324c:	0004c783          	lbu	a5,0(s1)
    80003250:	ff278de3          	beq	a5,s2,8000324a <namex+0x10e>
  if(*path == 0)
    80003254:	cb9d                	beqz	a5,8000328a <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003256:	0004c783          	lbu	a5,0(s1)
    8000325a:	89a6                	mv	s3,s1
  len = path - s;
    8000325c:	4c81                	li	s9,0
    8000325e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003260:	01278963          	beq	a5,s2,80003272 <namex+0x136>
    80003264:	dbbd                	beqz	a5,800031da <namex+0x9e>
    path++;
    80003266:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003268:	0009c783          	lbu	a5,0(s3)
    8000326c:	ff279ce3          	bne	a5,s2,80003264 <namex+0x128>
    80003270:	b7ad                	j	800031da <namex+0x9e>
    memmove(name, s, len);
    80003272:	2601                	sext.w	a2,a2
    80003274:	85a6                	mv	a1,s1
    80003276:	8556                	mv	a0,s5
    80003278:	ffffd097          	auipc	ra,0xffffd
    8000327c:	f5e080e7          	jalr	-162(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003280:	9cd6                	add	s9,s9,s5
    80003282:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003286:	84ce                	mv	s1,s3
    80003288:	b7bd                	j	800031f6 <namex+0xba>
  if(nameiparent){
    8000328a:	f00b0de3          	beqz	s6,800031a4 <namex+0x68>
    iput(ip);
    8000328e:	8552                	mv	a0,s4
    80003290:	00000097          	auipc	ra,0x0
    80003294:	ad2080e7          	jalr	-1326(ra) # 80002d62 <iput>
    return 0;
    80003298:	4a01                	li	s4,0
    8000329a:	b729                	j	800031a4 <namex+0x68>

000000008000329c <dirlink>:
{
    8000329c:	7139                	addi	sp,sp,-64
    8000329e:	fc06                	sd	ra,56(sp)
    800032a0:	f822                	sd	s0,48(sp)
    800032a2:	f426                	sd	s1,40(sp)
    800032a4:	f04a                	sd	s2,32(sp)
    800032a6:	ec4e                	sd	s3,24(sp)
    800032a8:	e852                	sd	s4,16(sp)
    800032aa:	0080                	addi	s0,sp,64
    800032ac:	892a                	mv	s2,a0
    800032ae:	8a2e                	mv	s4,a1
    800032b0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032b2:	4601                	li	a2,0
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	dd8080e7          	jalr	-552(ra) # 8000308c <dirlookup>
    800032bc:	e93d                	bnez	a0,80003332 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032be:	04c92483          	lw	s1,76(s2)
    800032c2:	c49d                	beqz	s1,800032f0 <dirlink+0x54>
    800032c4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c6:	4741                	li	a4,16
    800032c8:	86a6                	mv	a3,s1
    800032ca:	fc040613          	addi	a2,s0,-64
    800032ce:	4581                	li	a1,0
    800032d0:	854a                	mv	a0,s2
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	b8a080e7          	jalr	-1142(ra) # 80002e5c <readi>
    800032da:	47c1                	li	a5,16
    800032dc:	06f51163          	bne	a0,a5,8000333e <dirlink+0xa2>
    if(de.inum == 0)
    800032e0:	fc045783          	lhu	a5,-64(s0)
    800032e4:	c791                	beqz	a5,800032f0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e6:	24c1                	addiw	s1,s1,16
    800032e8:	04c92783          	lw	a5,76(s2)
    800032ec:	fcf4ede3          	bltu	s1,a5,800032c6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032f0:	4639                	li	a2,14
    800032f2:	85d2                	mv	a1,s4
    800032f4:	fc240513          	addi	a0,s0,-62
    800032f8:	ffffd097          	auipc	ra,0xffffd
    800032fc:	f8e080e7          	jalr	-114(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003300:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003304:	4741                	li	a4,16
    80003306:	86a6                	mv	a3,s1
    80003308:	fc040613          	addi	a2,s0,-64
    8000330c:	4581                	li	a1,0
    8000330e:	854a                	mv	a0,s2
    80003310:	00000097          	auipc	ra,0x0
    80003314:	c44080e7          	jalr	-956(ra) # 80002f54 <writei>
    80003318:	1541                	addi	a0,a0,-16
    8000331a:	00a03533          	snez	a0,a0
    8000331e:	40a00533          	neg	a0,a0
}
    80003322:	70e2                	ld	ra,56(sp)
    80003324:	7442                	ld	s0,48(sp)
    80003326:	74a2                	ld	s1,40(sp)
    80003328:	7902                	ld	s2,32(sp)
    8000332a:	69e2                	ld	s3,24(sp)
    8000332c:	6a42                	ld	s4,16(sp)
    8000332e:	6121                	addi	sp,sp,64
    80003330:	8082                	ret
    iput(ip);
    80003332:	00000097          	auipc	ra,0x0
    80003336:	a30080e7          	jalr	-1488(ra) # 80002d62 <iput>
    return -1;
    8000333a:	557d                	li	a0,-1
    8000333c:	b7dd                	j	80003322 <dirlink+0x86>
      panic("dirlink read");
    8000333e:	00005517          	auipc	a0,0x5
    80003342:	1fa50513          	addi	a0,a0,506 # 80008538 <syscalls+0x1c8>
    80003346:	00003097          	auipc	ra,0x3
    8000334a:	8e0080e7          	jalr	-1824(ra) # 80005c26 <panic>

000000008000334e <namei>:

struct inode*
namei(char *path)
{
    8000334e:	1101                	addi	sp,sp,-32
    80003350:	ec06                	sd	ra,24(sp)
    80003352:	e822                	sd	s0,16(sp)
    80003354:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003356:	fe040613          	addi	a2,s0,-32
    8000335a:	4581                	li	a1,0
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	de0080e7          	jalr	-544(ra) # 8000313c <namex>
}
    80003364:	60e2                	ld	ra,24(sp)
    80003366:	6442                	ld	s0,16(sp)
    80003368:	6105                	addi	sp,sp,32
    8000336a:	8082                	ret

000000008000336c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000336c:	1141                	addi	sp,sp,-16
    8000336e:	e406                	sd	ra,8(sp)
    80003370:	e022                	sd	s0,0(sp)
    80003372:	0800                	addi	s0,sp,16
    80003374:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003376:	4585                	li	a1,1
    80003378:	00000097          	auipc	ra,0x0
    8000337c:	dc4080e7          	jalr	-572(ra) # 8000313c <namex>
}
    80003380:	60a2                	ld	ra,8(sp)
    80003382:	6402                	ld	s0,0(sp)
    80003384:	0141                	addi	sp,sp,16
    80003386:	8082                	ret

0000000080003388 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003388:	1101                	addi	sp,sp,-32
    8000338a:	ec06                	sd	ra,24(sp)
    8000338c:	e822                	sd	s0,16(sp)
    8000338e:	e426                	sd	s1,8(sp)
    80003390:	e04a                	sd	s2,0(sp)
    80003392:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003394:	00015917          	auipc	s2,0x15
    80003398:	4cc90913          	addi	s2,s2,1228 # 80018860 <log>
    8000339c:	01892583          	lw	a1,24(s2)
    800033a0:	02892503          	lw	a0,40(s2)
    800033a4:	fffff097          	auipc	ra,0xfffff
    800033a8:	ff4080e7          	jalr	-12(ra) # 80002398 <bread>
    800033ac:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033ae:	02c92603          	lw	a2,44(s2)
    800033b2:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033b4:	00c05f63          	blez	a2,800033d2 <write_head+0x4a>
    800033b8:	00015717          	auipc	a4,0x15
    800033bc:	4d870713          	addi	a4,a4,1240 # 80018890 <log+0x30>
    800033c0:	87aa                	mv	a5,a0
    800033c2:	060a                	slli	a2,a2,0x2
    800033c4:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800033c6:	4314                	lw	a3,0(a4)
    800033c8:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800033ca:	0711                	addi	a4,a4,4
    800033cc:	0791                	addi	a5,a5,4
    800033ce:	fec79ce3          	bne	a5,a2,800033c6 <write_head+0x3e>
  }
  bwrite(buf);
    800033d2:	8526                	mv	a0,s1
    800033d4:	fffff097          	auipc	ra,0xfffff
    800033d8:	0b6080e7          	jalr	182(ra) # 8000248a <bwrite>
  brelse(buf);
    800033dc:	8526                	mv	a0,s1
    800033de:	fffff097          	auipc	ra,0xfffff
    800033e2:	0ea080e7          	jalr	234(ra) # 800024c8 <brelse>
}
    800033e6:	60e2                	ld	ra,24(sp)
    800033e8:	6442                	ld	s0,16(sp)
    800033ea:	64a2                	ld	s1,8(sp)
    800033ec:	6902                	ld	s2,0(sp)
    800033ee:	6105                	addi	sp,sp,32
    800033f0:	8082                	ret

00000000800033f2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033f2:	00015797          	auipc	a5,0x15
    800033f6:	49a7a783          	lw	a5,1178(a5) # 8001888c <log+0x2c>
    800033fa:	0af05d63          	blez	a5,800034b4 <install_trans+0xc2>
{
    800033fe:	7139                	addi	sp,sp,-64
    80003400:	fc06                	sd	ra,56(sp)
    80003402:	f822                	sd	s0,48(sp)
    80003404:	f426                	sd	s1,40(sp)
    80003406:	f04a                	sd	s2,32(sp)
    80003408:	ec4e                	sd	s3,24(sp)
    8000340a:	e852                	sd	s4,16(sp)
    8000340c:	e456                	sd	s5,8(sp)
    8000340e:	e05a                	sd	s6,0(sp)
    80003410:	0080                	addi	s0,sp,64
    80003412:	8b2a                	mv	s6,a0
    80003414:	00015a97          	auipc	s5,0x15
    80003418:	47ca8a93          	addi	s5,s5,1148 # 80018890 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000341c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000341e:	00015997          	auipc	s3,0x15
    80003422:	44298993          	addi	s3,s3,1090 # 80018860 <log>
    80003426:	a00d                	j	80003448 <install_trans+0x56>
    brelse(lbuf);
    80003428:	854a                	mv	a0,s2
    8000342a:	fffff097          	auipc	ra,0xfffff
    8000342e:	09e080e7          	jalr	158(ra) # 800024c8 <brelse>
    brelse(dbuf);
    80003432:	8526                	mv	a0,s1
    80003434:	fffff097          	auipc	ra,0xfffff
    80003438:	094080e7          	jalr	148(ra) # 800024c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000343c:	2a05                	addiw	s4,s4,1
    8000343e:	0a91                	addi	s5,s5,4
    80003440:	02c9a783          	lw	a5,44(s3)
    80003444:	04fa5e63          	bge	s4,a5,800034a0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003448:	0189a583          	lw	a1,24(s3)
    8000344c:	014585bb          	addw	a1,a1,s4
    80003450:	2585                	addiw	a1,a1,1
    80003452:	0289a503          	lw	a0,40(s3)
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	f42080e7          	jalr	-190(ra) # 80002398 <bread>
    8000345e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003460:	000aa583          	lw	a1,0(s5)
    80003464:	0289a503          	lw	a0,40(s3)
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	f30080e7          	jalr	-208(ra) # 80002398 <bread>
    80003470:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003472:	40000613          	li	a2,1024
    80003476:	05890593          	addi	a1,s2,88
    8000347a:	05850513          	addi	a0,a0,88
    8000347e:	ffffd097          	auipc	ra,0xffffd
    80003482:	d58080e7          	jalr	-680(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003486:	8526                	mv	a0,s1
    80003488:	fffff097          	auipc	ra,0xfffff
    8000348c:	002080e7          	jalr	2(ra) # 8000248a <bwrite>
    if(recovering == 0)
    80003490:	f80b1ce3          	bnez	s6,80003428 <install_trans+0x36>
      bunpin(dbuf);
    80003494:	8526                	mv	a0,s1
    80003496:	fffff097          	auipc	ra,0xfffff
    8000349a:	10a080e7          	jalr	266(ra) # 800025a0 <bunpin>
    8000349e:	b769                	j	80003428 <install_trans+0x36>
}
    800034a0:	70e2                	ld	ra,56(sp)
    800034a2:	7442                	ld	s0,48(sp)
    800034a4:	74a2                	ld	s1,40(sp)
    800034a6:	7902                	ld	s2,32(sp)
    800034a8:	69e2                	ld	s3,24(sp)
    800034aa:	6a42                	ld	s4,16(sp)
    800034ac:	6aa2                	ld	s5,8(sp)
    800034ae:	6b02                	ld	s6,0(sp)
    800034b0:	6121                	addi	sp,sp,64
    800034b2:	8082                	ret
    800034b4:	8082                	ret

00000000800034b6 <initlog>:
{
    800034b6:	7179                	addi	sp,sp,-48
    800034b8:	f406                	sd	ra,40(sp)
    800034ba:	f022                	sd	s0,32(sp)
    800034bc:	ec26                	sd	s1,24(sp)
    800034be:	e84a                	sd	s2,16(sp)
    800034c0:	e44e                	sd	s3,8(sp)
    800034c2:	1800                	addi	s0,sp,48
    800034c4:	892a                	mv	s2,a0
    800034c6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034c8:	00015497          	auipc	s1,0x15
    800034cc:	39848493          	addi	s1,s1,920 # 80018860 <log>
    800034d0:	00005597          	auipc	a1,0x5
    800034d4:	07858593          	addi	a1,a1,120 # 80008548 <syscalls+0x1d8>
    800034d8:	8526                	mv	a0,s1
    800034da:	00003097          	auipc	ra,0x3
    800034de:	bf4080e7          	jalr	-1036(ra) # 800060ce <initlock>
  log.start = sb->logstart;
    800034e2:	0149a583          	lw	a1,20(s3)
    800034e6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034e8:	0109a783          	lw	a5,16(s3)
    800034ec:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034ee:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034f2:	854a                	mv	a0,s2
    800034f4:	fffff097          	auipc	ra,0xfffff
    800034f8:	ea4080e7          	jalr	-348(ra) # 80002398 <bread>
  log.lh.n = lh->n;
    800034fc:	4d30                	lw	a2,88(a0)
    800034fe:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003500:	00c05f63          	blez	a2,8000351e <initlog+0x68>
    80003504:	87aa                	mv	a5,a0
    80003506:	00015717          	auipc	a4,0x15
    8000350a:	38a70713          	addi	a4,a4,906 # 80018890 <log+0x30>
    8000350e:	060a                	slli	a2,a2,0x2
    80003510:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003512:	4ff4                	lw	a3,92(a5)
    80003514:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003516:	0791                	addi	a5,a5,4
    80003518:	0711                	addi	a4,a4,4
    8000351a:	fec79ce3          	bne	a5,a2,80003512 <initlog+0x5c>
  brelse(buf);
    8000351e:	fffff097          	auipc	ra,0xfffff
    80003522:	faa080e7          	jalr	-86(ra) # 800024c8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003526:	4505                	li	a0,1
    80003528:	00000097          	auipc	ra,0x0
    8000352c:	eca080e7          	jalr	-310(ra) # 800033f2 <install_trans>
  log.lh.n = 0;
    80003530:	00015797          	auipc	a5,0x15
    80003534:	3407ae23          	sw	zero,860(a5) # 8001888c <log+0x2c>
  write_head(); // clear the log
    80003538:	00000097          	auipc	ra,0x0
    8000353c:	e50080e7          	jalr	-432(ra) # 80003388 <write_head>
}
    80003540:	70a2                	ld	ra,40(sp)
    80003542:	7402                	ld	s0,32(sp)
    80003544:	64e2                	ld	s1,24(sp)
    80003546:	6942                	ld	s2,16(sp)
    80003548:	69a2                	ld	s3,8(sp)
    8000354a:	6145                	addi	sp,sp,48
    8000354c:	8082                	ret

000000008000354e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000354e:	1101                	addi	sp,sp,-32
    80003550:	ec06                	sd	ra,24(sp)
    80003552:	e822                	sd	s0,16(sp)
    80003554:	e426                	sd	s1,8(sp)
    80003556:	e04a                	sd	s2,0(sp)
    80003558:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000355a:	00015517          	auipc	a0,0x15
    8000355e:	30650513          	addi	a0,a0,774 # 80018860 <log>
    80003562:	00003097          	auipc	ra,0x3
    80003566:	bfc080e7          	jalr	-1028(ra) # 8000615e <acquire>
  while(1){
    if(log.committing){
    8000356a:	00015497          	auipc	s1,0x15
    8000356e:	2f648493          	addi	s1,s1,758 # 80018860 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003572:	4979                	li	s2,30
    80003574:	a039                	j	80003582 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003576:	85a6                	mv	a1,s1
    80003578:	8526                	mv	a0,s1
    8000357a:	ffffe097          	auipc	ra,0xffffe
    8000357e:	00a080e7          	jalr	10(ra) # 80001584 <sleep>
    if(log.committing){
    80003582:	50dc                	lw	a5,36(s1)
    80003584:	fbed                	bnez	a5,80003576 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003586:	5098                	lw	a4,32(s1)
    80003588:	2705                	addiw	a4,a4,1
    8000358a:	0027179b          	slliw	a5,a4,0x2
    8000358e:	9fb9                	addw	a5,a5,a4
    80003590:	0017979b          	slliw	a5,a5,0x1
    80003594:	54d4                	lw	a3,44(s1)
    80003596:	9fb5                	addw	a5,a5,a3
    80003598:	00f95963          	bge	s2,a5,800035aa <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000359c:	85a6                	mv	a1,s1
    8000359e:	8526                	mv	a0,s1
    800035a0:	ffffe097          	auipc	ra,0xffffe
    800035a4:	fe4080e7          	jalr	-28(ra) # 80001584 <sleep>
    800035a8:	bfe9                	j	80003582 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035aa:	00015517          	auipc	a0,0x15
    800035ae:	2b650513          	addi	a0,a0,694 # 80018860 <log>
    800035b2:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800035b4:	00003097          	auipc	ra,0x3
    800035b8:	c5e080e7          	jalr	-930(ra) # 80006212 <release>
      break;
    }
  }
}
    800035bc:	60e2                	ld	ra,24(sp)
    800035be:	6442                	ld	s0,16(sp)
    800035c0:	64a2                	ld	s1,8(sp)
    800035c2:	6902                	ld	s2,0(sp)
    800035c4:	6105                	addi	sp,sp,32
    800035c6:	8082                	ret

00000000800035c8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035c8:	7139                	addi	sp,sp,-64
    800035ca:	fc06                	sd	ra,56(sp)
    800035cc:	f822                	sd	s0,48(sp)
    800035ce:	f426                	sd	s1,40(sp)
    800035d0:	f04a                	sd	s2,32(sp)
    800035d2:	ec4e                	sd	s3,24(sp)
    800035d4:	e852                	sd	s4,16(sp)
    800035d6:	e456                	sd	s5,8(sp)
    800035d8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035da:	00015497          	auipc	s1,0x15
    800035de:	28648493          	addi	s1,s1,646 # 80018860 <log>
    800035e2:	8526                	mv	a0,s1
    800035e4:	00003097          	auipc	ra,0x3
    800035e8:	b7a080e7          	jalr	-1158(ra) # 8000615e <acquire>
  log.outstanding -= 1;
    800035ec:	509c                	lw	a5,32(s1)
    800035ee:	37fd                	addiw	a5,a5,-1
    800035f0:	0007891b          	sext.w	s2,a5
    800035f4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035f6:	50dc                	lw	a5,36(s1)
    800035f8:	e7b9                	bnez	a5,80003646 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035fa:	04091e63          	bnez	s2,80003656 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035fe:	00015497          	auipc	s1,0x15
    80003602:	26248493          	addi	s1,s1,610 # 80018860 <log>
    80003606:	4785                	li	a5,1
    80003608:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000360a:	8526                	mv	a0,s1
    8000360c:	00003097          	auipc	ra,0x3
    80003610:	c06080e7          	jalr	-1018(ra) # 80006212 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003614:	54dc                	lw	a5,44(s1)
    80003616:	06f04763          	bgtz	a5,80003684 <end_op+0xbc>
    acquire(&log.lock);
    8000361a:	00015497          	auipc	s1,0x15
    8000361e:	24648493          	addi	s1,s1,582 # 80018860 <log>
    80003622:	8526                	mv	a0,s1
    80003624:	00003097          	auipc	ra,0x3
    80003628:	b3a080e7          	jalr	-1222(ra) # 8000615e <acquire>
    log.committing = 0;
    8000362c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003630:	8526                	mv	a0,s1
    80003632:	ffffe097          	auipc	ra,0xffffe
    80003636:	fb6080e7          	jalr	-74(ra) # 800015e8 <wakeup>
    release(&log.lock);
    8000363a:	8526                	mv	a0,s1
    8000363c:	00003097          	auipc	ra,0x3
    80003640:	bd6080e7          	jalr	-1066(ra) # 80006212 <release>
}
    80003644:	a03d                	j	80003672 <end_op+0xaa>
    panic("log.committing");
    80003646:	00005517          	auipc	a0,0x5
    8000364a:	f0a50513          	addi	a0,a0,-246 # 80008550 <syscalls+0x1e0>
    8000364e:	00002097          	auipc	ra,0x2
    80003652:	5d8080e7          	jalr	1496(ra) # 80005c26 <panic>
    wakeup(&log);
    80003656:	00015497          	auipc	s1,0x15
    8000365a:	20a48493          	addi	s1,s1,522 # 80018860 <log>
    8000365e:	8526                	mv	a0,s1
    80003660:	ffffe097          	auipc	ra,0xffffe
    80003664:	f88080e7          	jalr	-120(ra) # 800015e8 <wakeup>
  release(&log.lock);
    80003668:	8526                	mv	a0,s1
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	ba8080e7          	jalr	-1112(ra) # 80006212 <release>
}
    80003672:	70e2                	ld	ra,56(sp)
    80003674:	7442                	ld	s0,48(sp)
    80003676:	74a2                	ld	s1,40(sp)
    80003678:	7902                	ld	s2,32(sp)
    8000367a:	69e2                	ld	s3,24(sp)
    8000367c:	6a42                	ld	s4,16(sp)
    8000367e:	6aa2                	ld	s5,8(sp)
    80003680:	6121                	addi	sp,sp,64
    80003682:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003684:	00015a97          	auipc	s5,0x15
    80003688:	20ca8a93          	addi	s5,s5,524 # 80018890 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000368c:	00015a17          	auipc	s4,0x15
    80003690:	1d4a0a13          	addi	s4,s4,468 # 80018860 <log>
    80003694:	018a2583          	lw	a1,24(s4)
    80003698:	012585bb          	addw	a1,a1,s2
    8000369c:	2585                	addiw	a1,a1,1
    8000369e:	028a2503          	lw	a0,40(s4)
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	cf6080e7          	jalr	-778(ra) # 80002398 <bread>
    800036aa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036ac:	000aa583          	lw	a1,0(s5)
    800036b0:	028a2503          	lw	a0,40(s4)
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	ce4080e7          	jalr	-796(ra) # 80002398 <bread>
    800036bc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036be:	40000613          	li	a2,1024
    800036c2:	05850593          	addi	a1,a0,88
    800036c6:	05848513          	addi	a0,s1,88
    800036ca:	ffffd097          	auipc	ra,0xffffd
    800036ce:	b0c080e7          	jalr	-1268(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800036d2:	8526                	mv	a0,s1
    800036d4:	fffff097          	auipc	ra,0xfffff
    800036d8:	db6080e7          	jalr	-586(ra) # 8000248a <bwrite>
    brelse(from);
    800036dc:	854e                	mv	a0,s3
    800036de:	fffff097          	auipc	ra,0xfffff
    800036e2:	dea080e7          	jalr	-534(ra) # 800024c8 <brelse>
    brelse(to);
    800036e6:	8526                	mv	a0,s1
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	de0080e7          	jalr	-544(ra) # 800024c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f0:	2905                	addiw	s2,s2,1
    800036f2:	0a91                	addi	s5,s5,4
    800036f4:	02ca2783          	lw	a5,44(s4)
    800036f8:	f8f94ee3          	blt	s2,a5,80003694 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036fc:	00000097          	auipc	ra,0x0
    80003700:	c8c080e7          	jalr	-884(ra) # 80003388 <write_head>
    install_trans(0); // Now install writes to home locations
    80003704:	4501                	li	a0,0
    80003706:	00000097          	auipc	ra,0x0
    8000370a:	cec080e7          	jalr	-788(ra) # 800033f2 <install_trans>
    log.lh.n = 0;
    8000370e:	00015797          	auipc	a5,0x15
    80003712:	1607af23          	sw	zero,382(a5) # 8001888c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	c72080e7          	jalr	-910(ra) # 80003388 <write_head>
    8000371e:	bdf5                	j	8000361a <end_op+0x52>

0000000080003720 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003720:	1101                	addi	sp,sp,-32
    80003722:	ec06                	sd	ra,24(sp)
    80003724:	e822                	sd	s0,16(sp)
    80003726:	e426                	sd	s1,8(sp)
    80003728:	e04a                	sd	s2,0(sp)
    8000372a:	1000                	addi	s0,sp,32
    8000372c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000372e:	00015917          	auipc	s2,0x15
    80003732:	13290913          	addi	s2,s2,306 # 80018860 <log>
    80003736:	854a                	mv	a0,s2
    80003738:	00003097          	auipc	ra,0x3
    8000373c:	a26080e7          	jalr	-1498(ra) # 8000615e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003740:	02c92603          	lw	a2,44(s2)
    80003744:	47f5                	li	a5,29
    80003746:	06c7c563          	blt	a5,a2,800037b0 <log_write+0x90>
    8000374a:	00015797          	auipc	a5,0x15
    8000374e:	1327a783          	lw	a5,306(a5) # 8001887c <log+0x1c>
    80003752:	37fd                	addiw	a5,a5,-1
    80003754:	04f65e63          	bge	a2,a5,800037b0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003758:	00015797          	auipc	a5,0x15
    8000375c:	1287a783          	lw	a5,296(a5) # 80018880 <log+0x20>
    80003760:	06f05063          	blez	a5,800037c0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003764:	4781                	li	a5,0
    80003766:	06c05563          	blez	a2,800037d0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000376a:	44cc                	lw	a1,12(s1)
    8000376c:	00015717          	auipc	a4,0x15
    80003770:	12470713          	addi	a4,a4,292 # 80018890 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003774:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003776:	4314                	lw	a3,0(a4)
    80003778:	04b68c63          	beq	a3,a1,800037d0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000377c:	2785                	addiw	a5,a5,1
    8000377e:	0711                	addi	a4,a4,4
    80003780:	fef61be3          	bne	a2,a5,80003776 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003784:	0621                	addi	a2,a2,8
    80003786:	060a                	slli	a2,a2,0x2
    80003788:	00015797          	auipc	a5,0x15
    8000378c:	0d878793          	addi	a5,a5,216 # 80018860 <log>
    80003790:	97b2                	add	a5,a5,a2
    80003792:	44d8                	lw	a4,12(s1)
    80003794:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003796:	8526                	mv	a0,s1
    80003798:	fffff097          	auipc	ra,0xfffff
    8000379c:	dcc080e7          	jalr	-564(ra) # 80002564 <bpin>
    log.lh.n++;
    800037a0:	00015717          	auipc	a4,0x15
    800037a4:	0c070713          	addi	a4,a4,192 # 80018860 <log>
    800037a8:	575c                	lw	a5,44(a4)
    800037aa:	2785                	addiw	a5,a5,1
    800037ac:	d75c                	sw	a5,44(a4)
    800037ae:	a82d                	j	800037e8 <log_write+0xc8>
    panic("too big a transaction");
    800037b0:	00005517          	auipc	a0,0x5
    800037b4:	db050513          	addi	a0,a0,-592 # 80008560 <syscalls+0x1f0>
    800037b8:	00002097          	auipc	ra,0x2
    800037bc:	46e080e7          	jalr	1134(ra) # 80005c26 <panic>
    panic("log_write outside of trans");
    800037c0:	00005517          	auipc	a0,0x5
    800037c4:	db850513          	addi	a0,a0,-584 # 80008578 <syscalls+0x208>
    800037c8:	00002097          	auipc	ra,0x2
    800037cc:	45e080e7          	jalr	1118(ra) # 80005c26 <panic>
  log.lh.block[i] = b->blockno;
    800037d0:	00878693          	addi	a3,a5,8
    800037d4:	068a                	slli	a3,a3,0x2
    800037d6:	00015717          	auipc	a4,0x15
    800037da:	08a70713          	addi	a4,a4,138 # 80018860 <log>
    800037de:	9736                	add	a4,a4,a3
    800037e0:	44d4                	lw	a3,12(s1)
    800037e2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037e4:	faf609e3          	beq	a2,a5,80003796 <log_write+0x76>
  }
  release(&log.lock);
    800037e8:	00015517          	auipc	a0,0x15
    800037ec:	07850513          	addi	a0,a0,120 # 80018860 <log>
    800037f0:	00003097          	auipc	ra,0x3
    800037f4:	a22080e7          	jalr	-1502(ra) # 80006212 <release>
}
    800037f8:	60e2                	ld	ra,24(sp)
    800037fa:	6442                	ld	s0,16(sp)
    800037fc:	64a2                	ld	s1,8(sp)
    800037fe:	6902                	ld	s2,0(sp)
    80003800:	6105                	addi	sp,sp,32
    80003802:	8082                	ret

0000000080003804 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003804:	1101                	addi	sp,sp,-32
    80003806:	ec06                	sd	ra,24(sp)
    80003808:	e822                	sd	s0,16(sp)
    8000380a:	e426                	sd	s1,8(sp)
    8000380c:	e04a                	sd	s2,0(sp)
    8000380e:	1000                	addi	s0,sp,32
    80003810:	84aa                	mv	s1,a0
    80003812:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003814:	00005597          	auipc	a1,0x5
    80003818:	d8458593          	addi	a1,a1,-636 # 80008598 <syscalls+0x228>
    8000381c:	0521                	addi	a0,a0,8
    8000381e:	00003097          	auipc	ra,0x3
    80003822:	8b0080e7          	jalr	-1872(ra) # 800060ce <initlock>
  lk->name = name;
    80003826:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000382a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000382e:	0204a423          	sw	zero,40(s1)
}
    80003832:	60e2                	ld	ra,24(sp)
    80003834:	6442                	ld	s0,16(sp)
    80003836:	64a2                	ld	s1,8(sp)
    80003838:	6902                	ld	s2,0(sp)
    8000383a:	6105                	addi	sp,sp,32
    8000383c:	8082                	ret

000000008000383e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000383e:	1101                	addi	sp,sp,-32
    80003840:	ec06                	sd	ra,24(sp)
    80003842:	e822                	sd	s0,16(sp)
    80003844:	e426                	sd	s1,8(sp)
    80003846:	e04a                	sd	s2,0(sp)
    80003848:	1000                	addi	s0,sp,32
    8000384a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000384c:	00850913          	addi	s2,a0,8
    80003850:	854a                	mv	a0,s2
    80003852:	00003097          	auipc	ra,0x3
    80003856:	90c080e7          	jalr	-1780(ra) # 8000615e <acquire>
  while (lk->locked) {
    8000385a:	409c                	lw	a5,0(s1)
    8000385c:	cb89                	beqz	a5,8000386e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000385e:	85ca                	mv	a1,s2
    80003860:	8526                	mv	a0,s1
    80003862:	ffffe097          	auipc	ra,0xffffe
    80003866:	d22080e7          	jalr	-734(ra) # 80001584 <sleep>
  while (lk->locked) {
    8000386a:	409c                	lw	a5,0(s1)
    8000386c:	fbed                	bnez	a5,8000385e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000386e:	4785                	li	a5,1
    80003870:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003872:	ffffd097          	auipc	ra,0xffffd
    80003876:	66a080e7          	jalr	1642(ra) # 80000edc <myproc>
    8000387a:	591c                	lw	a5,48(a0)
    8000387c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000387e:	854a                	mv	a0,s2
    80003880:	00003097          	auipc	ra,0x3
    80003884:	992080e7          	jalr	-1646(ra) # 80006212 <release>
}
    80003888:	60e2                	ld	ra,24(sp)
    8000388a:	6442                	ld	s0,16(sp)
    8000388c:	64a2                	ld	s1,8(sp)
    8000388e:	6902                	ld	s2,0(sp)
    80003890:	6105                	addi	sp,sp,32
    80003892:	8082                	ret

0000000080003894 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003894:	1101                	addi	sp,sp,-32
    80003896:	ec06                	sd	ra,24(sp)
    80003898:	e822                	sd	s0,16(sp)
    8000389a:	e426                	sd	s1,8(sp)
    8000389c:	e04a                	sd	s2,0(sp)
    8000389e:	1000                	addi	s0,sp,32
    800038a0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038a2:	00850913          	addi	s2,a0,8
    800038a6:	854a                	mv	a0,s2
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	8b6080e7          	jalr	-1866(ra) # 8000615e <acquire>
  lk->locked = 0;
    800038b0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038b4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038b8:	8526                	mv	a0,s1
    800038ba:	ffffe097          	auipc	ra,0xffffe
    800038be:	d2e080e7          	jalr	-722(ra) # 800015e8 <wakeup>
  release(&lk->lk);
    800038c2:	854a                	mv	a0,s2
    800038c4:	00003097          	auipc	ra,0x3
    800038c8:	94e080e7          	jalr	-1714(ra) # 80006212 <release>
}
    800038cc:	60e2                	ld	ra,24(sp)
    800038ce:	6442                	ld	s0,16(sp)
    800038d0:	64a2                	ld	s1,8(sp)
    800038d2:	6902                	ld	s2,0(sp)
    800038d4:	6105                	addi	sp,sp,32
    800038d6:	8082                	ret

00000000800038d8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038d8:	7179                	addi	sp,sp,-48
    800038da:	f406                	sd	ra,40(sp)
    800038dc:	f022                	sd	s0,32(sp)
    800038de:	ec26                	sd	s1,24(sp)
    800038e0:	e84a                	sd	s2,16(sp)
    800038e2:	e44e                	sd	s3,8(sp)
    800038e4:	1800                	addi	s0,sp,48
    800038e6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038e8:	00850913          	addi	s2,a0,8
    800038ec:	854a                	mv	a0,s2
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	870080e7          	jalr	-1936(ra) # 8000615e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038f6:	409c                	lw	a5,0(s1)
    800038f8:	ef99                	bnez	a5,80003916 <holdingsleep+0x3e>
    800038fa:	4481                	li	s1,0
  release(&lk->lk);
    800038fc:	854a                	mv	a0,s2
    800038fe:	00003097          	auipc	ra,0x3
    80003902:	914080e7          	jalr	-1772(ra) # 80006212 <release>
  return r;
}
    80003906:	8526                	mv	a0,s1
    80003908:	70a2                	ld	ra,40(sp)
    8000390a:	7402                	ld	s0,32(sp)
    8000390c:	64e2                	ld	s1,24(sp)
    8000390e:	6942                	ld	s2,16(sp)
    80003910:	69a2                	ld	s3,8(sp)
    80003912:	6145                	addi	sp,sp,48
    80003914:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003916:	0284a983          	lw	s3,40(s1)
    8000391a:	ffffd097          	auipc	ra,0xffffd
    8000391e:	5c2080e7          	jalr	1474(ra) # 80000edc <myproc>
    80003922:	5904                	lw	s1,48(a0)
    80003924:	413484b3          	sub	s1,s1,s3
    80003928:	0014b493          	seqz	s1,s1
    8000392c:	bfc1                	j	800038fc <holdingsleep+0x24>

000000008000392e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000392e:	1141                	addi	sp,sp,-16
    80003930:	e406                	sd	ra,8(sp)
    80003932:	e022                	sd	s0,0(sp)
    80003934:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003936:	00005597          	auipc	a1,0x5
    8000393a:	c7258593          	addi	a1,a1,-910 # 800085a8 <syscalls+0x238>
    8000393e:	00015517          	auipc	a0,0x15
    80003942:	06a50513          	addi	a0,a0,106 # 800189a8 <ftable>
    80003946:	00002097          	auipc	ra,0x2
    8000394a:	788080e7          	jalr	1928(ra) # 800060ce <initlock>
}
    8000394e:	60a2                	ld	ra,8(sp)
    80003950:	6402                	ld	s0,0(sp)
    80003952:	0141                	addi	sp,sp,16
    80003954:	8082                	ret

0000000080003956 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003956:	1101                	addi	sp,sp,-32
    80003958:	ec06                	sd	ra,24(sp)
    8000395a:	e822                	sd	s0,16(sp)
    8000395c:	e426                	sd	s1,8(sp)
    8000395e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003960:	00015517          	auipc	a0,0x15
    80003964:	04850513          	addi	a0,a0,72 # 800189a8 <ftable>
    80003968:	00002097          	auipc	ra,0x2
    8000396c:	7f6080e7          	jalr	2038(ra) # 8000615e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003970:	00015497          	auipc	s1,0x15
    80003974:	05048493          	addi	s1,s1,80 # 800189c0 <ftable+0x18>
    80003978:	00016717          	auipc	a4,0x16
    8000397c:	fe870713          	addi	a4,a4,-24 # 80019960 <disk>
    if(f->ref == 0){
    80003980:	40dc                	lw	a5,4(s1)
    80003982:	cf99                	beqz	a5,800039a0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003984:	02848493          	addi	s1,s1,40
    80003988:	fee49ce3          	bne	s1,a4,80003980 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000398c:	00015517          	auipc	a0,0x15
    80003990:	01c50513          	addi	a0,a0,28 # 800189a8 <ftable>
    80003994:	00003097          	auipc	ra,0x3
    80003998:	87e080e7          	jalr	-1922(ra) # 80006212 <release>
  return 0;
    8000399c:	4481                	li	s1,0
    8000399e:	a819                	j	800039b4 <filealloc+0x5e>
      f->ref = 1;
    800039a0:	4785                	li	a5,1
    800039a2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039a4:	00015517          	auipc	a0,0x15
    800039a8:	00450513          	addi	a0,a0,4 # 800189a8 <ftable>
    800039ac:	00003097          	auipc	ra,0x3
    800039b0:	866080e7          	jalr	-1946(ra) # 80006212 <release>
}
    800039b4:	8526                	mv	a0,s1
    800039b6:	60e2                	ld	ra,24(sp)
    800039b8:	6442                	ld	s0,16(sp)
    800039ba:	64a2                	ld	s1,8(sp)
    800039bc:	6105                	addi	sp,sp,32
    800039be:	8082                	ret

00000000800039c0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039c0:	1101                	addi	sp,sp,-32
    800039c2:	ec06                	sd	ra,24(sp)
    800039c4:	e822                	sd	s0,16(sp)
    800039c6:	e426                	sd	s1,8(sp)
    800039c8:	1000                	addi	s0,sp,32
    800039ca:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039cc:	00015517          	auipc	a0,0x15
    800039d0:	fdc50513          	addi	a0,a0,-36 # 800189a8 <ftable>
    800039d4:	00002097          	auipc	ra,0x2
    800039d8:	78a080e7          	jalr	1930(ra) # 8000615e <acquire>
  if(f->ref < 1)
    800039dc:	40dc                	lw	a5,4(s1)
    800039de:	02f05263          	blez	a5,80003a02 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039e2:	2785                	addiw	a5,a5,1
    800039e4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039e6:	00015517          	auipc	a0,0x15
    800039ea:	fc250513          	addi	a0,a0,-62 # 800189a8 <ftable>
    800039ee:	00003097          	auipc	ra,0x3
    800039f2:	824080e7          	jalr	-2012(ra) # 80006212 <release>
  return f;
}
    800039f6:	8526                	mv	a0,s1
    800039f8:	60e2                	ld	ra,24(sp)
    800039fa:	6442                	ld	s0,16(sp)
    800039fc:	64a2                	ld	s1,8(sp)
    800039fe:	6105                	addi	sp,sp,32
    80003a00:	8082                	ret
    panic("filedup");
    80003a02:	00005517          	auipc	a0,0x5
    80003a06:	bae50513          	addi	a0,a0,-1106 # 800085b0 <syscalls+0x240>
    80003a0a:	00002097          	auipc	ra,0x2
    80003a0e:	21c080e7          	jalr	540(ra) # 80005c26 <panic>

0000000080003a12 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a12:	7139                	addi	sp,sp,-64
    80003a14:	fc06                	sd	ra,56(sp)
    80003a16:	f822                	sd	s0,48(sp)
    80003a18:	f426                	sd	s1,40(sp)
    80003a1a:	f04a                	sd	s2,32(sp)
    80003a1c:	ec4e                	sd	s3,24(sp)
    80003a1e:	e852                	sd	s4,16(sp)
    80003a20:	e456                	sd	s5,8(sp)
    80003a22:	0080                	addi	s0,sp,64
    80003a24:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a26:	00015517          	auipc	a0,0x15
    80003a2a:	f8250513          	addi	a0,a0,-126 # 800189a8 <ftable>
    80003a2e:	00002097          	auipc	ra,0x2
    80003a32:	730080e7          	jalr	1840(ra) # 8000615e <acquire>
  if(f->ref < 1)
    80003a36:	40dc                	lw	a5,4(s1)
    80003a38:	06f05163          	blez	a5,80003a9a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a3c:	37fd                	addiw	a5,a5,-1
    80003a3e:	0007871b          	sext.w	a4,a5
    80003a42:	c0dc                	sw	a5,4(s1)
    80003a44:	06e04363          	bgtz	a4,80003aaa <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a48:	0004a903          	lw	s2,0(s1)
    80003a4c:	0094ca83          	lbu	s5,9(s1)
    80003a50:	0104ba03          	ld	s4,16(s1)
    80003a54:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a58:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a5c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a60:	00015517          	auipc	a0,0x15
    80003a64:	f4850513          	addi	a0,a0,-184 # 800189a8 <ftable>
    80003a68:	00002097          	auipc	ra,0x2
    80003a6c:	7aa080e7          	jalr	1962(ra) # 80006212 <release>

  if(ff.type == FD_PIPE){
    80003a70:	4785                	li	a5,1
    80003a72:	04f90d63          	beq	s2,a5,80003acc <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a76:	3979                	addiw	s2,s2,-2
    80003a78:	4785                	li	a5,1
    80003a7a:	0527e063          	bltu	a5,s2,80003aba <fileclose+0xa8>
    begin_op();
    80003a7e:	00000097          	auipc	ra,0x0
    80003a82:	ad0080e7          	jalr	-1328(ra) # 8000354e <begin_op>
    iput(ff.ip);
    80003a86:	854e                	mv	a0,s3
    80003a88:	fffff097          	auipc	ra,0xfffff
    80003a8c:	2da080e7          	jalr	730(ra) # 80002d62 <iput>
    end_op();
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	b38080e7          	jalr	-1224(ra) # 800035c8 <end_op>
    80003a98:	a00d                	j	80003aba <fileclose+0xa8>
    panic("fileclose");
    80003a9a:	00005517          	auipc	a0,0x5
    80003a9e:	b1e50513          	addi	a0,a0,-1250 # 800085b8 <syscalls+0x248>
    80003aa2:	00002097          	auipc	ra,0x2
    80003aa6:	184080e7          	jalr	388(ra) # 80005c26 <panic>
    release(&ftable.lock);
    80003aaa:	00015517          	auipc	a0,0x15
    80003aae:	efe50513          	addi	a0,a0,-258 # 800189a8 <ftable>
    80003ab2:	00002097          	auipc	ra,0x2
    80003ab6:	760080e7          	jalr	1888(ra) # 80006212 <release>
  }
}
    80003aba:	70e2                	ld	ra,56(sp)
    80003abc:	7442                	ld	s0,48(sp)
    80003abe:	74a2                	ld	s1,40(sp)
    80003ac0:	7902                	ld	s2,32(sp)
    80003ac2:	69e2                	ld	s3,24(sp)
    80003ac4:	6a42                	ld	s4,16(sp)
    80003ac6:	6aa2                	ld	s5,8(sp)
    80003ac8:	6121                	addi	sp,sp,64
    80003aca:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003acc:	85d6                	mv	a1,s5
    80003ace:	8552                	mv	a0,s4
    80003ad0:	00000097          	auipc	ra,0x0
    80003ad4:	348080e7          	jalr	840(ra) # 80003e18 <pipeclose>
    80003ad8:	b7cd                	j	80003aba <fileclose+0xa8>

0000000080003ada <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ada:	715d                	addi	sp,sp,-80
    80003adc:	e486                	sd	ra,72(sp)
    80003ade:	e0a2                	sd	s0,64(sp)
    80003ae0:	fc26                	sd	s1,56(sp)
    80003ae2:	f84a                	sd	s2,48(sp)
    80003ae4:	f44e                	sd	s3,40(sp)
    80003ae6:	0880                	addi	s0,sp,80
    80003ae8:	84aa                	mv	s1,a0
    80003aea:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aec:	ffffd097          	auipc	ra,0xffffd
    80003af0:	3f0080e7          	jalr	1008(ra) # 80000edc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003af4:	409c                	lw	a5,0(s1)
    80003af6:	37f9                	addiw	a5,a5,-2
    80003af8:	4705                	li	a4,1
    80003afa:	04f76763          	bltu	a4,a5,80003b48 <filestat+0x6e>
    80003afe:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b00:	6c88                	ld	a0,24(s1)
    80003b02:	fffff097          	auipc	ra,0xfffff
    80003b06:	0a6080e7          	jalr	166(ra) # 80002ba8 <ilock>
    stati(f->ip, &st);
    80003b0a:	fb840593          	addi	a1,s0,-72
    80003b0e:	6c88                	ld	a0,24(s1)
    80003b10:	fffff097          	auipc	ra,0xfffff
    80003b14:	322080e7          	jalr	802(ra) # 80002e32 <stati>
    iunlock(f->ip);
    80003b18:	6c88                	ld	a0,24(s1)
    80003b1a:	fffff097          	auipc	ra,0xfffff
    80003b1e:	150080e7          	jalr	336(ra) # 80002c6a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b22:	46e1                	li	a3,24
    80003b24:	fb840613          	addi	a2,s0,-72
    80003b28:	85ce                	mv	a1,s3
    80003b2a:	05093503          	ld	a0,80(s2)
    80003b2e:	ffffd097          	auipc	ra,0xffffd
    80003b32:	06e080e7          	jalr	110(ra) # 80000b9c <copyout>
    80003b36:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b3a:	60a6                	ld	ra,72(sp)
    80003b3c:	6406                	ld	s0,64(sp)
    80003b3e:	74e2                	ld	s1,56(sp)
    80003b40:	7942                	ld	s2,48(sp)
    80003b42:	79a2                	ld	s3,40(sp)
    80003b44:	6161                	addi	sp,sp,80
    80003b46:	8082                	ret
  return -1;
    80003b48:	557d                	li	a0,-1
    80003b4a:	bfc5                	j	80003b3a <filestat+0x60>

0000000080003b4c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b4c:	7179                	addi	sp,sp,-48
    80003b4e:	f406                	sd	ra,40(sp)
    80003b50:	f022                	sd	s0,32(sp)
    80003b52:	ec26                	sd	s1,24(sp)
    80003b54:	e84a                	sd	s2,16(sp)
    80003b56:	e44e                	sd	s3,8(sp)
    80003b58:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b5a:	00854783          	lbu	a5,8(a0)
    80003b5e:	c3d5                	beqz	a5,80003c02 <fileread+0xb6>
    80003b60:	84aa                	mv	s1,a0
    80003b62:	89ae                	mv	s3,a1
    80003b64:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b66:	411c                	lw	a5,0(a0)
    80003b68:	4705                	li	a4,1
    80003b6a:	04e78963          	beq	a5,a4,80003bbc <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b6e:	470d                	li	a4,3
    80003b70:	04e78d63          	beq	a5,a4,80003bca <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b74:	4709                	li	a4,2
    80003b76:	06e79e63          	bne	a5,a4,80003bf2 <fileread+0xa6>
    ilock(f->ip);
    80003b7a:	6d08                	ld	a0,24(a0)
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	02c080e7          	jalr	44(ra) # 80002ba8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b84:	874a                	mv	a4,s2
    80003b86:	5094                	lw	a3,32(s1)
    80003b88:	864e                	mv	a2,s3
    80003b8a:	4585                	li	a1,1
    80003b8c:	6c88                	ld	a0,24(s1)
    80003b8e:	fffff097          	auipc	ra,0xfffff
    80003b92:	2ce080e7          	jalr	718(ra) # 80002e5c <readi>
    80003b96:	892a                	mv	s2,a0
    80003b98:	00a05563          	blez	a0,80003ba2 <fileread+0x56>
      f->off += r;
    80003b9c:	509c                	lw	a5,32(s1)
    80003b9e:	9fa9                	addw	a5,a5,a0
    80003ba0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ba2:	6c88                	ld	a0,24(s1)
    80003ba4:	fffff097          	auipc	ra,0xfffff
    80003ba8:	0c6080e7          	jalr	198(ra) # 80002c6a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bac:	854a                	mv	a0,s2
    80003bae:	70a2                	ld	ra,40(sp)
    80003bb0:	7402                	ld	s0,32(sp)
    80003bb2:	64e2                	ld	s1,24(sp)
    80003bb4:	6942                	ld	s2,16(sp)
    80003bb6:	69a2                	ld	s3,8(sp)
    80003bb8:	6145                	addi	sp,sp,48
    80003bba:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bbc:	6908                	ld	a0,16(a0)
    80003bbe:	00000097          	auipc	ra,0x0
    80003bc2:	3c2080e7          	jalr	962(ra) # 80003f80 <piperead>
    80003bc6:	892a                	mv	s2,a0
    80003bc8:	b7d5                	j	80003bac <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bca:	02451783          	lh	a5,36(a0)
    80003bce:	03079693          	slli	a3,a5,0x30
    80003bd2:	92c1                	srli	a3,a3,0x30
    80003bd4:	4725                	li	a4,9
    80003bd6:	02d76863          	bltu	a4,a3,80003c06 <fileread+0xba>
    80003bda:	0792                	slli	a5,a5,0x4
    80003bdc:	00015717          	auipc	a4,0x15
    80003be0:	d2c70713          	addi	a4,a4,-724 # 80018908 <devsw>
    80003be4:	97ba                	add	a5,a5,a4
    80003be6:	639c                	ld	a5,0(a5)
    80003be8:	c38d                	beqz	a5,80003c0a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003bea:	4505                	li	a0,1
    80003bec:	9782                	jalr	a5
    80003bee:	892a                	mv	s2,a0
    80003bf0:	bf75                	j	80003bac <fileread+0x60>
    panic("fileread");
    80003bf2:	00005517          	auipc	a0,0x5
    80003bf6:	9d650513          	addi	a0,a0,-1578 # 800085c8 <syscalls+0x258>
    80003bfa:	00002097          	auipc	ra,0x2
    80003bfe:	02c080e7          	jalr	44(ra) # 80005c26 <panic>
    return -1;
    80003c02:	597d                	li	s2,-1
    80003c04:	b765                	j	80003bac <fileread+0x60>
      return -1;
    80003c06:	597d                	li	s2,-1
    80003c08:	b755                	j	80003bac <fileread+0x60>
    80003c0a:	597d                	li	s2,-1
    80003c0c:	b745                	j	80003bac <fileread+0x60>

0000000080003c0e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c0e:	00954783          	lbu	a5,9(a0)
    80003c12:	10078e63          	beqz	a5,80003d2e <filewrite+0x120>
{
    80003c16:	715d                	addi	sp,sp,-80
    80003c18:	e486                	sd	ra,72(sp)
    80003c1a:	e0a2                	sd	s0,64(sp)
    80003c1c:	fc26                	sd	s1,56(sp)
    80003c1e:	f84a                	sd	s2,48(sp)
    80003c20:	f44e                	sd	s3,40(sp)
    80003c22:	f052                	sd	s4,32(sp)
    80003c24:	ec56                	sd	s5,24(sp)
    80003c26:	e85a                	sd	s6,16(sp)
    80003c28:	e45e                	sd	s7,8(sp)
    80003c2a:	e062                	sd	s8,0(sp)
    80003c2c:	0880                	addi	s0,sp,80
    80003c2e:	892a                	mv	s2,a0
    80003c30:	8b2e                	mv	s6,a1
    80003c32:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c34:	411c                	lw	a5,0(a0)
    80003c36:	4705                	li	a4,1
    80003c38:	02e78263          	beq	a5,a4,80003c5c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c3c:	470d                	li	a4,3
    80003c3e:	02e78563          	beq	a5,a4,80003c68 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c42:	4709                	li	a4,2
    80003c44:	0ce79d63          	bne	a5,a4,80003d1e <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c48:	0ac05b63          	blez	a2,80003cfe <filewrite+0xf0>
    int i = 0;
    80003c4c:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003c4e:	6b85                	lui	s7,0x1
    80003c50:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c54:	6c05                	lui	s8,0x1
    80003c56:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c5a:	a851                	j	80003cee <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003c5c:	6908                	ld	a0,16(a0)
    80003c5e:	00000097          	auipc	ra,0x0
    80003c62:	22a080e7          	jalr	554(ra) # 80003e88 <pipewrite>
    80003c66:	a045                	j	80003d06 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c68:	02451783          	lh	a5,36(a0)
    80003c6c:	03079693          	slli	a3,a5,0x30
    80003c70:	92c1                	srli	a3,a3,0x30
    80003c72:	4725                	li	a4,9
    80003c74:	0ad76f63          	bltu	a4,a3,80003d32 <filewrite+0x124>
    80003c78:	0792                	slli	a5,a5,0x4
    80003c7a:	00015717          	auipc	a4,0x15
    80003c7e:	c8e70713          	addi	a4,a4,-882 # 80018908 <devsw>
    80003c82:	97ba                	add	a5,a5,a4
    80003c84:	679c                	ld	a5,8(a5)
    80003c86:	cbc5                	beqz	a5,80003d36 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003c88:	4505                	li	a0,1
    80003c8a:	9782                	jalr	a5
    80003c8c:	a8ad                	j	80003d06 <filewrite+0xf8>
      if(n1 > max)
    80003c8e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003c92:	00000097          	auipc	ra,0x0
    80003c96:	8bc080e7          	jalr	-1860(ra) # 8000354e <begin_op>
      ilock(f->ip);
    80003c9a:	01893503          	ld	a0,24(s2)
    80003c9e:	fffff097          	auipc	ra,0xfffff
    80003ca2:	f0a080e7          	jalr	-246(ra) # 80002ba8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ca6:	8756                	mv	a4,s5
    80003ca8:	02092683          	lw	a3,32(s2)
    80003cac:	01698633          	add	a2,s3,s6
    80003cb0:	4585                	li	a1,1
    80003cb2:	01893503          	ld	a0,24(s2)
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	29e080e7          	jalr	670(ra) # 80002f54 <writei>
    80003cbe:	84aa                	mv	s1,a0
    80003cc0:	00a05763          	blez	a0,80003cce <filewrite+0xc0>
        f->off += r;
    80003cc4:	02092783          	lw	a5,32(s2)
    80003cc8:	9fa9                	addw	a5,a5,a0
    80003cca:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cce:	01893503          	ld	a0,24(s2)
    80003cd2:	fffff097          	auipc	ra,0xfffff
    80003cd6:	f98080e7          	jalr	-104(ra) # 80002c6a <iunlock>
      end_op();
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	8ee080e7          	jalr	-1810(ra) # 800035c8 <end_op>

      if(r != n1){
    80003ce2:	009a9f63          	bne	s5,s1,80003d00 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003ce6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003cea:	0149db63          	bge	s3,s4,80003d00 <filewrite+0xf2>
      int n1 = n - i;
    80003cee:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003cf2:	0004879b          	sext.w	a5,s1
    80003cf6:	f8fbdce3          	bge	s7,a5,80003c8e <filewrite+0x80>
    80003cfa:	84e2                	mv	s1,s8
    80003cfc:	bf49                	j	80003c8e <filewrite+0x80>
    int i = 0;
    80003cfe:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d00:	033a1d63          	bne	s4,s3,80003d3a <filewrite+0x12c>
    80003d04:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d06:	60a6                	ld	ra,72(sp)
    80003d08:	6406                	ld	s0,64(sp)
    80003d0a:	74e2                	ld	s1,56(sp)
    80003d0c:	7942                	ld	s2,48(sp)
    80003d0e:	79a2                	ld	s3,40(sp)
    80003d10:	7a02                	ld	s4,32(sp)
    80003d12:	6ae2                	ld	s5,24(sp)
    80003d14:	6b42                	ld	s6,16(sp)
    80003d16:	6ba2                	ld	s7,8(sp)
    80003d18:	6c02                	ld	s8,0(sp)
    80003d1a:	6161                	addi	sp,sp,80
    80003d1c:	8082                	ret
    panic("filewrite");
    80003d1e:	00005517          	auipc	a0,0x5
    80003d22:	8ba50513          	addi	a0,a0,-1862 # 800085d8 <syscalls+0x268>
    80003d26:	00002097          	auipc	ra,0x2
    80003d2a:	f00080e7          	jalr	-256(ra) # 80005c26 <panic>
    return -1;
    80003d2e:	557d                	li	a0,-1
}
    80003d30:	8082                	ret
      return -1;
    80003d32:	557d                	li	a0,-1
    80003d34:	bfc9                	j	80003d06 <filewrite+0xf8>
    80003d36:	557d                	li	a0,-1
    80003d38:	b7f9                	j	80003d06 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003d3a:	557d                	li	a0,-1
    80003d3c:	b7e9                	j	80003d06 <filewrite+0xf8>

0000000080003d3e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d3e:	7179                	addi	sp,sp,-48
    80003d40:	f406                	sd	ra,40(sp)
    80003d42:	f022                	sd	s0,32(sp)
    80003d44:	ec26                	sd	s1,24(sp)
    80003d46:	e84a                	sd	s2,16(sp)
    80003d48:	e44e                	sd	s3,8(sp)
    80003d4a:	e052                	sd	s4,0(sp)
    80003d4c:	1800                	addi	s0,sp,48
    80003d4e:	84aa                	mv	s1,a0
    80003d50:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d52:	0005b023          	sd	zero,0(a1)
    80003d56:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	bfc080e7          	jalr	-1028(ra) # 80003956 <filealloc>
    80003d62:	e088                	sd	a0,0(s1)
    80003d64:	c551                	beqz	a0,80003df0 <pipealloc+0xb2>
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	bf0080e7          	jalr	-1040(ra) # 80003956 <filealloc>
    80003d6e:	00aa3023          	sd	a0,0(s4)
    80003d72:	c92d                	beqz	a0,80003de4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d74:	ffffc097          	auipc	ra,0xffffc
    80003d78:	3a6080e7          	jalr	934(ra) # 8000011a <kalloc>
    80003d7c:	892a                	mv	s2,a0
    80003d7e:	c125                	beqz	a0,80003dde <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d80:	4985                	li	s3,1
    80003d82:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d86:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d8a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d8e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d92:	00005597          	auipc	a1,0x5
    80003d96:	85658593          	addi	a1,a1,-1962 # 800085e8 <syscalls+0x278>
    80003d9a:	00002097          	auipc	ra,0x2
    80003d9e:	334080e7          	jalr	820(ra) # 800060ce <initlock>
  (*f0)->type = FD_PIPE;
    80003da2:	609c                	ld	a5,0(s1)
    80003da4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003da8:	609c                	ld	a5,0(s1)
    80003daa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dae:	609c                	ld	a5,0(s1)
    80003db0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003db4:	609c                	ld	a5,0(s1)
    80003db6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dba:	000a3783          	ld	a5,0(s4)
    80003dbe:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dc2:	000a3783          	ld	a5,0(s4)
    80003dc6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dca:	000a3783          	ld	a5,0(s4)
    80003dce:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003dd2:	000a3783          	ld	a5,0(s4)
    80003dd6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003dda:	4501                	li	a0,0
    80003ddc:	a025                	j	80003e04 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dde:	6088                	ld	a0,0(s1)
    80003de0:	e501                	bnez	a0,80003de8 <pipealloc+0xaa>
    80003de2:	a039                	j	80003df0 <pipealloc+0xb2>
    80003de4:	6088                	ld	a0,0(s1)
    80003de6:	c51d                	beqz	a0,80003e14 <pipealloc+0xd6>
    fileclose(*f0);
    80003de8:	00000097          	auipc	ra,0x0
    80003dec:	c2a080e7          	jalr	-982(ra) # 80003a12 <fileclose>
  if(*f1)
    80003df0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003df4:	557d                	li	a0,-1
  if(*f1)
    80003df6:	c799                	beqz	a5,80003e04 <pipealloc+0xc6>
    fileclose(*f1);
    80003df8:	853e                	mv	a0,a5
    80003dfa:	00000097          	auipc	ra,0x0
    80003dfe:	c18080e7          	jalr	-1000(ra) # 80003a12 <fileclose>
  return -1;
    80003e02:	557d                	li	a0,-1
}
    80003e04:	70a2                	ld	ra,40(sp)
    80003e06:	7402                	ld	s0,32(sp)
    80003e08:	64e2                	ld	s1,24(sp)
    80003e0a:	6942                	ld	s2,16(sp)
    80003e0c:	69a2                	ld	s3,8(sp)
    80003e0e:	6a02                	ld	s4,0(sp)
    80003e10:	6145                	addi	sp,sp,48
    80003e12:	8082                	ret
  return -1;
    80003e14:	557d                	li	a0,-1
    80003e16:	b7fd                	j	80003e04 <pipealloc+0xc6>

0000000080003e18 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e18:	1101                	addi	sp,sp,-32
    80003e1a:	ec06                	sd	ra,24(sp)
    80003e1c:	e822                	sd	s0,16(sp)
    80003e1e:	e426                	sd	s1,8(sp)
    80003e20:	e04a                	sd	s2,0(sp)
    80003e22:	1000                	addi	s0,sp,32
    80003e24:	84aa                	mv	s1,a0
    80003e26:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e28:	00002097          	auipc	ra,0x2
    80003e2c:	336080e7          	jalr	822(ra) # 8000615e <acquire>
  if(writable){
    80003e30:	02090d63          	beqz	s2,80003e6a <pipeclose+0x52>
    pi->writeopen = 0;
    80003e34:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e38:	21848513          	addi	a0,s1,536
    80003e3c:	ffffd097          	auipc	ra,0xffffd
    80003e40:	7ac080e7          	jalr	1964(ra) # 800015e8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e44:	2204b783          	ld	a5,544(s1)
    80003e48:	eb95                	bnez	a5,80003e7c <pipeclose+0x64>
    release(&pi->lock);
    80003e4a:	8526                	mv	a0,s1
    80003e4c:	00002097          	auipc	ra,0x2
    80003e50:	3c6080e7          	jalr	966(ra) # 80006212 <release>
    kfree((char*)pi);
    80003e54:	8526                	mv	a0,s1
    80003e56:	ffffc097          	auipc	ra,0xffffc
    80003e5a:	1c6080e7          	jalr	454(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e5e:	60e2                	ld	ra,24(sp)
    80003e60:	6442                	ld	s0,16(sp)
    80003e62:	64a2                	ld	s1,8(sp)
    80003e64:	6902                	ld	s2,0(sp)
    80003e66:	6105                	addi	sp,sp,32
    80003e68:	8082                	ret
    pi->readopen = 0;
    80003e6a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e6e:	21c48513          	addi	a0,s1,540
    80003e72:	ffffd097          	auipc	ra,0xffffd
    80003e76:	776080e7          	jalr	1910(ra) # 800015e8 <wakeup>
    80003e7a:	b7e9                	j	80003e44 <pipeclose+0x2c>
    release(&pi->lock);
    80003e7c:	8526                	mv	a0,s1
    80003e7e:	00002097          	auipc	ra,0x2
    80003e82:	394080e7          	jalr	916(ra) # 80006212 <release>
}
    80003e86:	bfe1                	j	80003e5e <pipeclose+0x46>

0000000080003e88 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e88:	711d                	addi	sp,sp,-96
    80003e8a:	ec86                	sd	ra,88(sp)
    80003e8c:	e8a2                	sd	s0,80(sp)
    80003e8e:	e4a6                	sd	s1,72(sp)
    80003e90:	e0ca                	sd	s2,64(sp)
    80003e92:	fc4e                	sd	s3,56(sp)
    80003e94:	f852                	sd	s4,48(sp)
    80003e96:	f456                	sd	s5,40(sp)
    80003e98:	f05a                	sd	s6,32(sp)
    80003e9a:	ec5e                	sd	s7,24(sp)
    80003e9c:	e862                	sd	s8,16(sp)
    80003e9e:	1080                	addi	s0,sp,96
    80003ea0:	84aa                	mv	s1,a0
    80003ea2:	8aae                	mv	s5,a1
    80003ea4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ea6:	ffffd097          	auipc	ra,0xffffd
    80003eaa:	036080e7          	jalr	54(ra) # 80000edc <myproc>
    80003eae:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003eb0:	8526                	mv	a0,s1
    80003eb2:	00002097          	auipc	ra,0x2
    80003eb6:	2ac080e7          	jalr	684(ra) # 8000615e <acquire>
  while(i < n){
    80003eba:	0b405663          	blez	s4,80003f66 <pipewrite+0xde>
  int i = 0;
    80003ebe:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ec0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ec2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ec6:	21c48b93          	addi	s7,s1,540
    80003eca:	a089                	j	80003f0c <pipewrite+0x84>
      release(&pi->lock);
    80003ecc:	8526                	mv	a0,s1
    80003ece:	00002097          	auipc	ra,0x2
    80003ed2:	344080e7          	jalr	836(ra) # 80006212 <release>
      return -1;
    80003ed6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ed8:	854a                	mv	a0,s2
    80003eda:	60e6                	ld	ra,88(sp)
    80003edc:	6446                	ld	s0,80(sp)
    80003ede:	64a6                	ld	s1,72(sp)
    80003ee0:	6906                	ld	s2,64(sp)
    80003ee2:	79e2                	ld	s3,56(sp)
    80003ee4:	7a42                	ld	s4,48(sp)
    80003ee6:	7aa2                	ld	s5,40(sp)
    80003ee8:	7b02                	ld	s6,32(sp)
    80003eea:	6be2                	ld	s7,24(sp)
    80003eec:	6c42                	ld	s8,16(sp)
    80003eee:	6125                	addi	sp,sp,96
    80003ef0:	8082                	ret
      wakeup(&pi->nread);
    80003ef2:	8562                	mv	a0,s8
    80003ef4:	ffffd097          	auipc	ra,0xffffd
    80003ef8:	6f4080e7          	jalr	1780(ra) # 800015e8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003efc:	85a6                	mv	a1,s1
    80003efe:	855e                	mv	a0,s7
    80003f00:	ffffd097          	auipc	ra,0xffffd
    80003f04:	684080e7          	jalr	1668(ra) # 80001584 <sleep>
  while(i < n){
    80003f08:	07495063          	bge	s2,s4,80003f68 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f0c:	2204a783          	lw	a5,544(s1)
    80003f10:	dfd5                	beqz	a5,80003ecc <pipewrite+0x44>
    80003f12:	854e                	mv	a0,s3
    80003f14:	ffffe097          	auipc	ra,0xffffe
    80003f18:	918080e7          	jalr	-1768(ra) # 8000182c <killed>
    80003f1c:	f945                	bnez	a0,80003ecc <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f1e:	2184a783          	lw	a5,536(s1)
    80003f22:	21c4a703          	lw	a4,540(s1)
    80003f26:	2007879b          	addiw	a5,a5,512
    80003f2a:	fcf704e3          	beq	a4,a5,80003ef2 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f2e:	4685                	li	a3,1
    80003f30:	01590633          	add	a2,s2,s5
    80003f34:	faf40593          	addi	a1,s0,-81
    80003f38:	0509b503          	ld	a0,80(s3)
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	cec080e7          	jalr	-788(ra) # 80000c28 <copyin>
    80003f44:	03650263          	beq	a0,s6,80003f68 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f48:	21c4a783          	lw	a5,540(s1)
    80003f4c:	0017871b          	addiw	a4,a5,1
    80003f50:	20e4ae23          	sw	a4,540(s1)
    80003f54:	1ff7f793          	andi	a5,a5,511
    80003f58:	97a6                	add	a5,a5,s1
    80003f5a:	faf44703          	lbu	a4,-81(s0)
    80003f5e:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f62:	2905                	addiw	s2,s2,1
    80003f64:	b755                	j	80003f08 <pipewrite+0x80>
  int i = 0;
    80003f66:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f68:	21848513          	addi	a0,s1,536
    80003f6c:	ffffd097          	auipc	ra,0xffffd
    80003f70:	67c080e7          	jalr	1660(ra) # 800015e8 <wakeup>
  release(&pi->lock);
    80003f74:	8526                	mv	a0,s1
    80003f76:	00002097          	auipc	ra,0x2
    80003f7a:	29c080e7          	jalr	668(ra) # 80006212 <release>
  return i;
    80003f7e:	bfa9                	j	80003ed8 <pipewrite+0x50>

0000000080003f80 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f80:	715d                	addi	sp,sp,-80
    80003f82:	e486                	sd	ra,72(sp)
    80003f84:	e0a2                	sd	s0,64(sp)
    80003f86:	fc26                	sd	s1,56(sp)
    80003f88:	f84a                	sd	s2,48(sp)
    80003f8a:	f44e                	sd	s3,40(sp)
    80003f8c:	f052                	sd	s4,32(sp)
    80003f8e:	ec56                	sd	s5,24(sp)
    80003f90:	e85a                	sd	s6,16(sp)
    80003f92:	0880                	addi	s0,sp,80
    80003f94:	84aa                	mv	s1,a0
    80003f96:	892e                	mv	s2,a1
    80003f98:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	f42080e7          	jalr	-190(ra) # 80000edc <myproc>
    80003fa2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	00002097          	auipc	ra,0x2
    80003faa:	1b8080e7          	jalr	440(ra) # 8000615e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fae:	2184a703          	lw	a4,536(s1)
    80003fb2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fb6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fba:	02f71763          	bne	a4,a5,80003fe8 <piperead+0x68>
    80003fbe:	2244a783          	lw	a5,548(s1)
    80003fc2:	c39d                	beqz	a5,80003fe8 <piperead+0x68>
    if(killed(pr)){
    80003fc4:	8552                	mv	a0,s4
    80003fc6:	ffffe097          	auipc	ra,0xffffe
    80003fca:	866080e7          	jalr	-1946(ra) # 8000182c <killed>
    80003fce:	e949                	bnez	a0,80004060 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fd0:	85a6                	mv	a1,s1
    80003fd2:	854e                	mv	a0,s3
    80003fd4:	ffffd097          	auipc	ra,0xffffd
    80003fd8:	5b0080e7          	jalr	1456(ra) # 80001584 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fdc:	2184a703          	lw	a4,536(s1)
    80003fe0:	21c4a783          	lw	a5,540(s1)
    80003fe4:	fcf70de3          	beq	a4,a5,80003fbe <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fe8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fea:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fec:	05505463          	blez	s5,80004034 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003ff0:	2184a783          	lw	a5,536(s1)
    80003ff4:	21c4a703          	lw	a4,540(s1)
    80003ff8:	02f70e63          	beq	a4,a5,80004034 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ffc:	0017871b          	addiw	a4,a5,1
    80004000:	20e4ac23          	sw	a4,536(s1)
    80004004:	1ff7f793          	andi	a5,a5,511
    80004008:	97a6                	add	a5,a5,s1
    8000400a:	0187c783          	lbu	a5,24(a5)
    8000400e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004012:	4685                	li	a3,1
    80004014:	fbf40613          	addi	a2,s0,-65
    80004018:	85ca                	mv	a1,s2
    8000401a:	050a3503          	ld	a0,80(s4)
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	b7e080e7          	jalr	-1154(ra) # 80000b9c <copyout>
    80004026:	01650763          	beq	a0,s6,80004034 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000402a:	2985                	addiw	s3,s3,1
    8000402c:	0905                	addi	s2,s2,1
    8000402e:	fd3a91e3          	bne	s5,s3,80003ff0 <piperead+0x70>
    80004032:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004034:	21c48513          	addi	a0,s1,540
    80004038:	ffffd097          	auipc	ra,0xffffd
    8000403c:	5b0080e7          	jalr	1456(ra) # 800015e8 <wakeup>
  release(&pi->lock);
    80004040:	8526                	mv	a0,s1
    80004042:	00002097          	auipc	ra,0x2
    80004046:	1d0080e7          	jalr	464(ra) # 80006212 <release>
  return i;
}
    8000404a:	854e                	mv	a0,s3
    8000404c:	60a6                	ld	ra,72(sp)
    8000404e:	6406                	ld	s0,64(sp)
    80004050:	74e2                	ld	s1,56(sp)
    80004052:	7942                	ld	s2,48(sp)
    80004054:	79a2                	ld	s3,40(sp)
    80004056:	7a02                	ld	s4,32(sp)
    80004058:	6ae2                	ld	s5,24(sp)
    8000405a:	6b42                	ld	s6,16(sp)
    8000405c:	6161                	addi	sp,sp,80
    8000405e:	8082                	ret
      release(&pi->lock);
    80004060:	8526                	mv	a0,s1
    80004062:	00002097          	auipc	ra,0x2
    80004066:	1b0080e7          	jalr	432(ra) # 80006212 <release>
      return -1;
    8000406a:	59fd                	li	s3,-1
    8000406c:	bff9                	j	8000404a <piperead+0xca>

000000008000406e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000406e:	1141                	addi	sp,sp,-16
    80004070:	e422                	sd	s0,8(sp)
    80004072:	0800                	addi	s0,sp,16
    80004074:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004076:	8905                	andi	a0,a0,1
    80004078:	050e                	slli	a0,a0,0x3
    perm = PTE_X;
  if (flags & 0x2)
    8000407a:	8b89                	andi	a5,a5,2
    8000407c:	c399                	beqz	a5,80004082 <flags2perm+0x14>
    perm |= PTE_W;
    8000407e:	00456513          	ori	a0,a0,4
  return perm;
}
    80004082:	6422                	ld	s0,8(sp)
    80004084:	0141                	addi	sp,sp,16
    80004086:	8082                	ret

0000000080004088 <exec>:

int exec(char *path, char **argv)
{
    80004088:	df010113          	addi	sp,sp,-528
    8000408c:	20113423          	sd	ra,520(sp)
    80004090:	20813023          	sd	s0,512(sp)
    80004094:	ffa6                	sd	s1,504(sp)
    80004096:	fbca                	sd	s2,496(sp)
    80004098:	f7ce                	sd	s3,488(sp)
    8000409a:	f3d2                	sd	s4,480(sp)
    8000409c:	efd6                	sd	s5,472(sp)
    8000409e:	ebda                	sd	s6,464(sp)
    800040a0:	e7de                	sd	s7,456(sp)
    800040a2:	e3e2                	sd	s8,448(sp)
    800040a4:	ff66                	sd	s9,440(sp)
    800040a6:	fb6a                	sd	s10,432(sp)
    800040a8:	f76e                	sd	s11,424(sp)
    800040aa:	0c00                	addi	s0,sp,528
    800040ac:	892a                	mv	s2,a0
    800040ae:	dea43c23          	sd	a0,-520(s0)
    800040b2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	e26080e7          	jalr	-474(ra) # 80000edc <myproc>
    800040be:	84aa                	mv	s1,a0

  begin_op();
    800040c0:	fffff097          	auipc	ra,0xfffff
    800040c4:	48e080e7          	jalr	1166(ra) # 8000354e <begin_op>

  if ((ip = namei(path)) == 0)
    800040c8:	854a                	mv	a0,s2
    800040ca:	fffff097          	auipc	ra,0xfffff
    800040ce:	284080e7          	jalr	644(ra) # 8000334e <namei>
    800040d2:	c92d                	beqz	a0,80004144 <exec+0xbc>
    800040d4:	8a2a                	mv	s4,a0
  {
    end_op();
    return -1;
  }
  ilock(ip);
    800040d6:	fffff097          	auipc	ra,0xfffff
    800040da:	ad2080e7          	jalr	-1326(ra) # 80002ba8 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040de:	04000713          	li	a4,64
    800040e2:	4681                	li	a3,0
    800040e4:	e5040613          	addi	a2,s0,-432
    800040e8:	4581                	li	a1,0
    800040ea:	8552                	mv	a0,s4
    800040ec:	fffff097          	auipc	ra,0xfffff
    800040f0:	d70080e7          	jalr	-656(ra) # 80002e5c <readi>
    800040f4:	04000793          	li	a5,64
    800040f8:	00f51a63          	bne	a0,a5,8000410c <exec+0x84>
    goto bad;

  if (elf.magic != ELF_MAGIC)
    800040fc:	e5042703          	lw	a4,-432(s0)
    80004100:	464c47b7          	lui	a5,0x464c4
    80004104:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004108:	04f70463          	beq	a4,a5,80004150 <exec+0xc8>
bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip)
  {
    iunlockput(ip);
    8000410c:	8552                	mv	a0,s4
    8000410e:	fffff097          	auipc	ra,0xfffff
    80004112:	cfc080e7          	jalr	-772(ra) # 80002e0a <iunlockput>
    end_op();
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	4b2080e7          	jalr	1202(ra) # 800035c8 <end_op>
  }
  return -1;
    8000411e:	557d                	li	a0,-1
}
    80004120:	20813083          	ld	ra,520(sp)
    80004124:	20013403          	ld	s0,512(sp)
    80004128:	74fe                	ld	s1,504(sp)
    8000412a:	795e                	ld	s2,496(sp)
    8000412c:	79be                	ld	s3,488(sp)
    8000412e:	7a1e                	ld	s4,480(sp)
    80004130:	6afe                	ld	s5,472(sp)
    80004132:	6b5e                	ld	s6,464(sp)
    80004134:	6bbe                	ld	s7,456(sp)
    80004136:	6c1e                	ld	s8,448(sp)
    80004138:	7cfa                	ld	s9,440(sp)
    8000413a:	7d5a                	ld	s10,432(sp)
    8000413c:	7dba                	ld	s11,424(sp)
    8000413e:	21010113          	addi	sp,sp,528
    80004142:	8082                	ret
    end_op();
    80004144:	fffff097          	auipc	ra,0xfffff
    80004148:	484080e7          	jalr	1156(ra) # 800035c8 <end_op>
    return -1;
    8000414c:	557d                	li	a0,-1
    8000414e:	bfc9                	j	80004120 <exec+0x98>
  if ((pagetable = proc_pagetable(p)) == 0)
    80004150:	8526                	mv	a0,s1
    80004152:	ffffd097          	auipc	ra,0xffffd
    80004156:	e4e080e7          	jalr	-434(ra) # 80000fa0 <proc_pagetable>
    8000415a:	8b2a                	mv	s6,a0
    8000415c:	d945                	beqz	a0,8000410c <exec+0x84>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    8000415e:	e7042d03          	lw	s10,-400(s0)
    80004162:	e8845783          	lhu	a5,-376(s0)
    80004166:	10078463          	beqz	a5,8000426e <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000416a:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    8000416c:	4d81                	li	s11,0
    if (ph.vaddr % PGSIZE != 0)
    8000416e:	6c85                	lui	s9,0x1
    80004170:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004174:	def43823          	sd	a5,-528(s0)
  for (i = 0; i < sz; i += PGSIZE)
  {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004178:	6a85                	lui	s5,0x1
    8000417a:	a0b5                	j	800041e6 <exec+0x15e>
      panic("loadseg: address should exist");
    8000417c:	00004517          	auipc	a0,0x4
    80004180:	47450513          	addi	a0,a0,1140 # 800085f0 <syscalls+0x280>
    80004184:	00002097          	auipc	ra,0x2
    80004188:	aa2080e7          	jalr	-1374(ra) # 80005c26 <panic>
    if (sz - i < PGSIZE)
    8000418c:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    8000418e:	8726                	mv	a4,s1
    80004190:	012c06bb          	addw	a3,s8,s2
    80004194:	4581                	li	a1,0
    80004196:	8552                	mv	a0,s4
    80004198:	fffff097          	auipc	ra,0xfffff
    8000419c:	cc4080e7          	jalr	-828(ra) # 80002e5c <readi>
    800041a0:	2501                	sext.w	a0,a0
    800041a2:	24a49863          	bne	s1,a0,800043f2 <exec+0x36a>
  for (i = 0; i < sz; i += PGSIZE)
    800041a6:	012a893b          	addw	s2,s5,s2
    800041aa:	03397563          	bgeu	s2,s3,800041d4 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    800041ae:	02091593          	slli	a1,s2,0x20
    800041b2:	9181                	srli	a1,a1,0x20
    800041b4:	95de                	add	a1,a1,s7
    800041b6:	855a                	mv	a0,s6
    800041b8:	ffffc097          	auipc	ra,0xffffc
    800041bc:	34a080e7          	jalr	842(ra) # 80000502 <walkaddr>
    800041c0:	862a                	mv	a2,a0
    if (pa == 0)
    800041c2:	dd4d                	beqz	a0,8000417c <exec+0xf4>
    if (sz - i < PGSIZE)
    800041c4:	412984bb          	subw	s1,s3,s2
    800041c8:	0004879b          	sext.w	a5,s1
    800041cc:	fcfcf0e3          	bgeu	s9,a5,8000418c <exec+0x104>
    800041d0:	84d6                	mv	s1,s5
    800041d2:	bf6d                	j	8000418c <exec+0x104>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800041d4:	e0843903          	ld	s2,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    800041d8:	2d85                	addiw	s11,s11,1
    800041da:	038d0d1b          	addiw	s10,s10,56
    800041de:	e8845783          	lhu	a5,-376(s0)
    800041e2:	08fdd763          	bge	s11,a5,80004270 <exec+0x1e8>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041e6:	2d01                	sext.w	s10,s10
    800041e8:	03800713          	li	a4,56
    800041ec:	86ea                	mv	a3,s10
    800041ee:	e1840613          	addi	a2,s0,-488
    800041f2:	4581                	li	a1,0
    800041f4:	8552                	mv	a0,s4
    800041f6:	fffff097          	auipc	ra,0xfffff
    800041fa:	c66080e7          	jalr	-922(ra) # 80002e5c <readi>
    800041fe:	03800793          	li	a5,56
    80004202:	1ef51663          	bne	a0,a5,800043ee <exec+0x366>
    if (ph.type != ELF_PROG_LOAD)
    80004206:	e1842783          	lw	a5,-488(s0)
    8000420a:	4705                	li	a4,1
    8000420c:	fce796e3          	bne	a5,a4,800041d8 <exec+0x150>
    if (ph.memsz < ph.filesz)
    80004210:	e4043483          	ld	s1,-448(s0)
    80004214:	e3843783          	ld	a5,-456(s0)
    80004218:	1ef4e863          	bltu	s1,a5,80004408 <exec+0x380>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    8000421c:	e2843783          	ld	a5,-472(s0)
    80004220:	94be                	add	s1,s1,a5
    80004222:	1ef4e663          	bltu	s1,a5,8000440e <exec+0x386>
    if (ph.vaddr % PGSIZE != 0)
    80004226:	df043703          	ld	a4,-528(s0)
    8000422a:	8ff9                	and	a5,a5,a4
    8000422c:	1e079463          	bnez	a5,80004414 <exec+0x38c>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004230:	e1c42503          	lw	a0,-484(s0)
    80004234:	00000097          	auipc	ra,0x0
    80004238:	e3a080e7          	jalr	-454(ra) # 8000406e <flags2perm>
    8000423c:	86aa                	mv	a3,a0
    8000423e:	8626                	mv	a2,s1
    80004240:	85ca                	mv	a1,s2
    80004242:	855a                	mv	a0,s6
    80004244:	ffffc097          	auipc	ra,0xffffc
    80004248:	654080e7          	jalr	1620(ra) # 80000898 <uvmalloc>
    8000424c:	e0a43423          	sd	a0,-504(s0)
    80004250:	1c050563          	beqz	a0,8000441a <exec+0x392>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004254:	e2843b83          	ld	s7,-472(s0)
    80004258:	e2042c03          	lw	s8,-480(s0)
    8000425c:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE)
    80004260:	00098463          	beqz	s3,80004268 <exec+0x1e0>
    80004264:	4901                	li	s2,0
    80004266:	b7a1                	j	800041ae <exec+0x126>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004268:	e0843903          	ld	s2,-504(s0)
    8000426c:	b7b5                	j	800041d8 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000426e:	4901                	li	s2,0
  iunlockput(ip);
    80004270:	8552                	mv	a0,s4
    80004272:	fffff097          	auipc	ra,0xfffff
    80004276:	b98080e7          	jalr	-1128(ra) # 80002e0a <iunlockput>
  end_op();
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	34e080e7          	jalr	846(ra) # 800035c8 <end_op>
  p = myproc();
    80004282:	ffffd097          	auipc	ra,0xffffd
    80004286:	c5a080e7          	jalr	-934(ra) # 80000edc <myproc>
    8000428a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000428c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004290:	6985                	lui	s3,0x1
    80004292:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004294:	99ca                	add	s3,s3,s2
    80004296:	77fd                	lui	a5,0xfffff
    80004298:	00f9f9b3          	and	s3,s3,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0)
    8000429c:	4691                	li	a3,4
    8000429e:	6609                	lui	a2,0x2
    800042a0:	964e                	add	a2,a2,s3
    800042a2:	85ce                	mv	a1,s3
    800042a4:	855a                	mv	a0,s6
    800042a6:	ffffc097          	auipc	ra,0xffffc
    800042aa:	5f2080e7          	jalr	1522(ra) # 80000898 <uvmalloc>
    800042ae:	892a                	mv	s2,a0
    800042b0:	e0a43423          	sd	a0,-504(s0)
    800042b4:	e509                	bnez	a0,800042be <exec+0x236>
  if (pagetable)
    800042b6:	e1343423          	sd	s3,-504(s0)
    800042ba:	4a01                	li	s4,0
    800042bc:	aa1d                	j	800043f2 <exec+0x36a>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    800042be:	75f9                	lui	a1,0xffffe
    800042c0:	95aa                	add	a1,a1,a0
    800042c2:	855a                	mv	a0,s6
    800042c4:	ffffc097          	auipc	ra,0xffffc
    800042c8:	7e2080e7          	jalr	2018(ra) # 80000aa6 <uvmclear>
  stackbase = sp - PGSIZE;
    800042cc:	7bfd                	lui	s7,0xfffff
    800042ce:	9bca                	add	s7,s7,s2
  for (argc = 0; argv[argc]; argc++)
    800042d0:	e0043783          	ld	a5,-512(s0)
    800042d4:	6388                	ld	a0,0(a5)
    800042d6:	c52d                	beqz	a0,80004340 <exec+0x2b8>
    800042d8:	e9040993          	addi	s3,s0,-368
    800042dc:	f9040c13          	addi	s8,s0,-112
    800042e0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042e2:	ffffc097          	auipc	ra,0xffffc
    800042e6:	012080e7          	jalr	18(ra) # 800002f4 <strlen>
    800042ea:	0015079b          	addiw	a5,a0,1
    800042ee:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042f2:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase)
    800042f6:	13796563          	bltu	s2,s7,80004420 <exec+0x398>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042fa:	e0043d03          	ld	s10,-512(s0)
    800042fe:	000d3a03          	ld	s4,0(s10)
    80004302:	8552                	mv	a0,s4
    80004304:	ffffc097          	auipc	ra,0xffffc
    80004308:	ff0080e7          	jalr	-16(ra) # 800002f4 <strlen>
    8000430c:	0015069b          	addiw	a3,a0,1
    80004310:	8652                	mv	a2,s4
    80004312:	85ca                	mv	a1,s2
    80004314:	855a                	mv	a0,s6
    80004316:	ffffd097          	auipc	ra,0xffffd
    8000431a:	886080e7          	jalr	-1914(ra) # 80000b9c <copyout>
    8000431e:	10054363          	bltz	a0,80004424 <exec+0x39c>
    ustack[argc] = sp;
    80004322:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++)
    80004326:	0485                	addi	s1,s1,1
    80004328:	008d0793          	addi	a5,s10,8
    8000432c:	e0f43023          	sd	a5,-512(s0)
    80004330:	008d3503          	ld	a0,8(s10)
    80004334:	c909                	beqz	a0,80004346 <exec+0x2be>
    if (argc >= MAXARG)
    80004336:	09a1                	addi	s3,s3,8
    80004338:	fb8995e3          	bne	s3,s8,800042e2 <exec+0x25a>
  ip = 0;
    8000433c:	4a01                	li	s4,0
    8000433e:	a855                	j	800043f2 <exec+0x36a>
  sp = sz;
    80004340:	e0843903          	ld	s2,-504(s0)
  for (argc = 0; argv[argc]; argc++)
    80004344:	4481                	li	s1,0
  ustack[argc] = 0;
    80004346:	00349793          	slli	a5,s1,0x3
    8000434a:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd2b0>
    8000434e:	97a2                	add	a5,a5,s0
    80004350:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004354:	00148693          	addi	a3,s1,1
    80004358:	068e                	slli	a3,a3,0x3
    8000435a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000435e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004362:	e0843983          	ld	s3,-504(s0)
  if (sp < stackbase)
    80004366:	f57968e3          	bltu	s2,s7,800042b6 <exec+0x22e>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    8000436a:	e9040613          	addi	a2,s0,-368
    8000436e:	85ca                	mv	a1,s2
    80004370:	855a                	mv	a0,s6
    80004372:	ffffd097          	auipc	ra,0xffffd
    80004376:	82a080e7          	jalr	-2006(ra) # 80000b9c <copyout>
    8000437a:	0a054763          	bltz	a0,80004428 <exec+0x3a0>
  p->trapframe->a1 = sp;
    8000437e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004382:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004386:	df843783          	ld	a5,-520(s0)
    8000438a:	0007c703          	lbu	a4,0(a5)
    8000438e:	cf11                	beqz	a4,800043aa <exec+0x322>
    80004390:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004392:	02f00693          	li	a3,47
    80004396:	a039                	j	800043a4 <exec+0x31c>
      last = s + 1;
    80004398:	def43c23          	sd	a5,-520(s0)
  for (last = s = path; *s; s++)
    8000439c:	0785                	addi	a5,a5,1
    8000439e:	fff7c703          	lbu	a4,-1(a5)
    800043a2:	c701                	beqz	a4,800043aa <exec+0x322>
    if (*s == '/')
    800043a4:	fed71ce3          	bne	a4,a3,8000439c <exec+0x314>
    800043a8:	bfc5                	j	80004398 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    800043aa:	4641                	li	a2,16
    800043ac:	df843583          	ld	a1,-520(s0)
    800043b0:	158a8513          	addi	a0,s5,344
    800043b4:	ffffc097          	auipc	ra,0xffffc
    800043b8:	f0e080e7          	jalr	-242(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800043bc:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043c0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800043c4:	e0843783          	ld	a5,-504(s0)
    800043c8:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry; // initial program counter = main
    800043cc:	058ab783          	ld	a5,88(s5)
    800043d0:	e6843703          	ld	a4,-408(s0)
    800043d4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    800043d6:	058ab783          	ld	a5,88(s5)
    800043da:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043de:	85e6                	mv	a1,s9
    800043e0:	ffffd097          	auipc	ra,0xffffd
    800043e4:	c5c080e7          	jalr	-932(ra) # 8000103c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043e8:	0004851b          	sext.w	a0,s1
    800043ec:	bb15                	j	80004120 <exec+0x98>
    800043ee:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043f2:	e0843583          	ld	a1,-504(s0)
    800043f6:	855a                	mv	a0,s6
    800043f8:	ffffd097          	auipc	ra,0xffffd
    800043fc:	c44080e7          	jalr	-956(ra) # 8000103c <proc_freepagetable>
  return -1;
    80004400:	557d                	li	a0,-1
  if (ip)
    80004402:	d00a0fe3          	beqz	s4,80004120 <exec+0x98>
    80004406:	b319                	j	8000410c <exec+0x84>
    80004408:	e1243423          	sd	s2,-504(s0)
    8000440c:	b7dd                	j	800043f2 <exec+0x36a>
    8000440e:	e1243423          	sd	s2,-504(s0)
    80004412:	b7c5                	j	800043f2 <exec+0x36a>
    80004414:	e1243423          	sd	s2,-504(s0)
    80004418:	bfe9                	j	800043f2 <exec+0x36a>
    8000441a:	e1243423          	sd	s2,-504(s0)
    8000441e:	bfd1                	j	800043f2 <exec+0x36a>
  ip = 0;
    80004420:	4a01                	li	s4,0
    80004422:	bfc1                	j	800043f2 <exec+0x36a>
    80004424:	4a01                	li	s4,0
  if (pagetable)
    80004426:	b7f1                	j	800043f2 <exec+0x36a>
  sz = sz1;
    80004428:	e0843983          	ld	s3,-504(s0)
    8000442c:	b569                	j	800042b6 <exec+0x22e>

000000008000442e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000442e:	7179                	addi	sp,sp,-48
    80004430:	f406                	sd	ra,40(sp)
    80004432:	f022                	sd	s0,32(sp)
    80004434:	ec26                	sd	s1,24(sp)
    80004436:	e84a                	sd	s2,16(sp)
    80004438:	1800                	addi	s0,sp,48
    8000443a:	892e                	mv	s2,a1
    8000443c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000443e:	fdc40593          	addi	a1,s0,-36
    80004442:	ffffe097          	auipc	ra,0xffffe
    80004446:	be4080e7          	jalr	-1052(ra) # 80002026 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    8000444a:	fdc42703          	lw	a4,-36(s0)
    8000444e:	47bd                	li	a5,15
    80004450:	02e7eb63          	bltu	a5,a4,80004486 <argfd+0x58>
    80004454:	ffffd097          	auipc	ra,0xffffd
    80004458:	a88080e7          	jalr	-1400(ra) # 80000edc <myproc>
    8000445c:	fdc42703          	lw	a4,-36(s0)
    80004460:	01a70793          	addi	a5,a4,26
    80004464:	078e                	slli	a5,a5,0x3
    80004466:	953e                	add	a0,a0,a5
    80004468:	611c                	ld	a5,0(a0)
    8000446a:	c385                	beqz	a5,8000448a <argfd+0x5c>
    return -1;
  if (pfd)
    8000446c:	00090463          	beqz	s2,80004474 <argfd+0x46>
    *pfd = fd;
    80004470:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004474:	4501                	li	a0,0
  if (pf)
    80004476:	c091                	beqz	s1,8000447a <argfd+0x4c>
    *pf = f;
    80004478:	e09c                	sd	a5,0(s1)
}
    8000447a:	70a2                	ld	ra,40(sp)
    8000447c:	7402                	ld	s0,32(sp)
    8000447e:	64e2                	ld	s1,24(sp)
    80004480:	6942                	ld	s2,16(sp)
    80004482:	6145                	addi	sp,sp,48
    80004484:	8082                	ret
    return -1;
    80004486:	557d                	li	a0,-1
    80004488:	bfcd                	j	8000447a <argfd+0x4c>
    8000448a:	557d                	li	a0,-1
    8000448c:	b7fd                	j	8000447a <argfd+0x4c>

000000008000448e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000448e:	1101                	addi	sp,sp,-32
    80004490:	ec06                	sd	ra,24(sp)
    80004492:	e822                	sd	s0,16(sp)
    80004494:	e426                	sd	s1,8(sp)
    80004496:	1000                	addi	s0,sp,32
    80004498:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000449a:	ffffd097          	auipc	ra,0xffffd
    8000449e:	a42080e7          	jalr	-1470(ra) # 80000edc <myproc>
    800044a2:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    800044a4:	0d050793          	addi	a5,a0,208
    800044a8:	4501                	li	a0,0
    800044aa:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    800044ac:	6398                	ld	a4,0(a5)
    800044ae:	cb19                	beqz	a4,800044c4 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    800044b0:	2505                	addiw	a0,a0,1
    800044b2:	07a1                	addi	a5,a5,8
    800044b4:	fed51ce3          	bne	a0,a3,800044ac <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044b8:	557d                	li	a0,-1
}
    800044ba:	60e2                	ld	ra,24(sp)
    800044bc:	6442                	ld	s0,16(sp)
    800044be:	64a2                	ld	s1,8(sp)
    800044c0:	6105                	addi	sp,sp,32
    800044c2:	8082                	ret
      p->ofile[fd] = f;
    800044c4:	01a50793          	addi	a5,a0,26
    800044c8:	078e                	slli	a5,a5,0x3
    800044ca:	963e                	add	a2,a2,a5
    800044cc:	e204                	sd	s1,0(a2)
      return fd;
    800044ce:	b7f5                	j	800044ba <fdalloc+0x2c>

00000000800044d0 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800044d0:	715d                	addi	sp,sp,-80
    800044d2:	e486                	sd	ra,72(sp)
    800044d4:	e0a2                	sd	s0,64(sp)
    800044d6:	fc26                	sd	s1,56(sp)
    800044d8:	f84a                	sd	s2,48(sp)
    800044da:	f44e                	sd	s3,40(sp)
    800044dc:	f052                	sd	s4,32(sp)
    800044de:	ec56                	sd	s5,24(sp)
    800044e0:	e85a                	sd	s6,16(sp)
    800044e2:	0880                	addi	s0,sp,80
    800044e4:	8b2e                	mv	s6,a1
    800044e6:	89b2                	mv	s3,a2
    800044e8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800044ea:	fb040593          	addi	a1,s0,-80
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	e7e080e7          	jalr	-386(ra) # 8000336c <nameiparent>
    800044f6:	84aa                	mv	s1,a0
    800044f8:	14050b63          	beqz	a0,8000464e <create+0x17e>
    return 0;

  ilock(dp);
    800044fc:	ffffe097          	auipc	ra,0xffffe
    80004500:	6ac080e7          	jalr	1708(ra) # 80002ba8 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    80004504:	4601                	li	a2,0
    80004506:	fb040593          	addi	a1,s0,-80
    8000450a:	8526                	mv	a0,s1
    8000450c:	fffff097          	auipc	ra,0xfffff
    80004510:	b80080e7          	jalr	-1152(ra) # 8000308c <dirlookup>
    80004514:	8aaa                	mv	s5,a0
    80004516:	c921                	beqz	a0,80004566 <create+0x96>
  {
    iunlockput(dp);
    80004518:	8526                	mv	a0,s1
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	8f0080e7          	jalr	-1808(ra) # 80002e0a <iunlockput>
    ilock(ip);
    80004522:	8556                	mv	a0,s5
    80004524:	ffffe097          	auipc	ra,0xffffe
    80004528:	684080e7          	jalr	1668(ra) # 80002ba8 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000452c:	4789                	li	a5,2
    8000452e:	02fb1563          	bne	s6,a5,80004558 <create+0x88>
    80004532:	044ad783          	lhu	a5,68(s5)
    80004536:	37f9                	addiw	a5,a5,-2
    80004538:	17c2                	slli	a5,a5,0x30
    8000453a:	93c1                	srli	a5,a5,0x30
    8000453c:	4705                	li	a4,1
    8000453e:	00f76d63          	bltu	a4,a5,80004558 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004542:	8556                	mv	a0,s5
    80004544:	60a6                	ld	ra,72(sp)
    80004546:	6406                	ld	s0,64(sp)
    80004548:	74e2                	ld	s1,56(sp)
    8000454a:	7942                	ld	s2,48(sp)
    8000454c:	79a2                	ld	s3,40(sp)
    8000454e:	7a02                	ld	s4,32(sp)
    80004550:	6ae2                	ld	s5,24(sp)
    80004552:	6b42                	ld	s6,16(sp)
    80004554:	6161                	addi	sp,sp,80
    80004556:	8082                	ret
    iunlockput(ip);
    80004558:	8556                	mv	a0,s5
    8000455a:	fffff097          	auipc	ra,0xfffff
    8000455e:	8b0080e7          	jalr	-1872(ra) # 80002e0a <iunlockput>
    return 0;
    80004562:	4a81                	li	s5,0
    80004564:	bff9                	j	80004542 <create+0x72>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80004566:	85da                	mv	a1,s6
    80004568:	4088                	lw	a0,0(s1)
    8000456a:	ffffe097          	auipc	ra,0xffffe
    8000456e:	4a6080e7          	jalr	1190(ra) # 80002a10 <ialloc>
    80004572:	8a2a                	mv	s4,a0
    80004574:	c529                	beqz	a0,800045be <create+0xee>
  ilock(ip);
    80004576:	ffffe097          	auipc	ra,0xffffe
    8000457a:	632080e7          	jalr	1586(ra) # 80002ba8 <ilock>
  ip->major = major;
    8000457e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004582:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004586:	4905                	li	s2,1
    80004588:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000458c:	8552                	mv	a0,s4
    8000458e:	ffffe097          	auipc	ra,0xffffe
    80004592:	54e080e7          	jalr	1358(ra) # 80002adc <iupdate>
  if (type == T_DIR)
    80004596:	032b0b63          	beq	s6,s2,800045cc <create+0xfc>
  if (dirlink(dp, name, ip->inum) < 0)
    8000459a:	004a2603          	lw	a2,4(s4)
    8000459e:	fb040593          	addi	a1,s0,-80
    800045a2:	8526                	mv	a0,s1
    800045a4:	fffff097          	auipc	ra,0xfffff
    800045a8:	cf8080e7          	jalr	-776(ra) # 8000329c <dirlink>
    800045ac:	06054f63          	bltz	a0,8000462a <create+0x15a>
  iunlockput(dp);
    800045b0:	8526                	mv	a0,s1
    800045b2:	fffff097          	auipc	ra,0xfffff
    800045b6:	858080e7          	jalr	-1960(ra) # 80002e0a <iunlockput>
  return ip;
    800045ba:	8ad2                	mv	s5,s4
    800045bc:	b759                	j	80004542 <create+0x72>
    iunlockput(dp);
    800045be:	8526                	mv	a0,s1
    800045c0:	fffff097          	auipc	ra,0xfffff
    800045c4:	84a080e7          	jalr	-1974(ra) # 80002e0a <iunlockput>
    return 0;
    800045c8:	8ad2                	mv	s5,s4
    800045ca:	bfa5                	j	80004542 <create+0x72>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045cc:	004a2603          	lw	a2,4(s4)
    800045d0:	00004597          	auipc	a1,0x4
    800045d4:	04058593          	addi	a1,a1,64 # 80008610 <syscalls+0x2a0>
    800045d8:	8552                	mv	a0,s4
    800045da:	fffff097          	auipc	ra,0xfffff
    800045de:	cc2080e7          	jalr	-830(ra) # 8000329c <dirlink>
    800045e2:	04054463          	bltz	a0,8000462a <create+0x15a>
    800045e6:	40d0                	lw	a2,4(s1)
    800045e8:	00004597          	auipc	a1,0x4
    800045ec:	03058593          	addi	a1,a1,48 # 80008618 <syscalls+0x2a8>
    800045f0:	8552                	mv	a0,s4
    800045f2:	fffff097          	auipc	ra,0xfffff
    800045f6:	caa080e7          	jalr	-854(ra) # 8000329c <dirlink>
    800045fa:	02054863          	bltz	a0,8000462a <create+0x15a>
  if (dirlink(dp, name, ip->inum) < 0)
    800045fe:	004a2603          	lw	a2,4(s4)
    80004602:	fb040593          	addi	a1,s0,-80
    80004606:	8526                	mv	a0,s1
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	c94080e7          	jalr	-876(ra) # 8000329c <dirlink>
    80004610:	00054d63          	bltz	a0,8000462a <create+0x15a>
    dp->nlink++; // for ".."
    80004614:	04a4d783          	lhu	a5,74(s1)
    80004618:	2785                	addiw	a5,a5,1
    8000461a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000461e:	8526                	mv	a0,s1
    80004620:	ffffe097          	auipc	ra,0xffffe
    80004624:	4bc080e7          	jalr	1212(ra) # 80002adc <iupdate>
    80004628:	b761                	j	800045b0 <create+0xe0>
  ip->nlink = 0;
    8000462a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000462e:	8552                	mv	a0,s4
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	4ac080e7          	jalr	1196(ra) # 80002adc <iupdate>
  iunlockput(ip);
    80004638:	8552                	mv	a0,s4
    8000463a:	ffffe097          	auipc	ra,0xffffe
    8000463e:	7d0080e7          	jalr	2000(ra) # 80002e0a <iunlockput>
  iunlockput(dp);
    80004642:	8526                	mv	a0,s1
    80004644:	ffffe097          	auipc	ra,0xffffe
    80004648:	7c6080e7          	jalr	1990(ra) # 80002e0a <iunlockput>
  return 0;
    8000464c:	bddd                	j	80004542 <create+0x72>
    return 0;
    8000464e:	8aaa                	mv	s5,a0
    80004650:	bdcd                	j	80004542 <create+0x72>

0000000080004652 <sys_dup>:
{
    80004652:	7179                	addi	sp,sp,-48
    80004654:	f406                	sd	ra,40(sp)
    80004656:	f022                	sd	s0,32(sp)
    80004658:	ec26                	sd	s1,24(sp)
    8000465a:	e84a                	sd	s2,16(sp)
    8000465c:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    8000465e:	fd840613          	addi	a2,s0,-40
    80004662:	4581                	li	a1,0
    80004664:	4501                	li	a0,0
    80004666:	00000097          	auipc	ra,0x0
    8000466a:	dc8080e7          	jalr	-568(ra) # 8000442e <argfd>
    return -1;
    8000466e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80004670:	02054363          	bltz	a0,80004696 <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0)
    80004674:	fd843903          	ld	s2,-40(s0)
    80004678:	854a                	mv	a0,s2
    8000467a:	00000097          	auipc	ra,0x0
    8000467e:	e14080e7          	jalr	-492(ra) # 8000448e <fdalloc>
    80004682:	84aa                	mv	s1,a0
    return -1;
    80004684:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80004686:	00054863          	bltz	a0,80004696 <sys_dup+0x44>
  filedup(f);
    8000468a:	854a                	mv	a0,s2
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	334080e7          	jalr	820(ra) # 800039c0 <filedup>
  return fd;
    80004694:	87a6                	mv	a5,s1
}
    80004696:	853e                	mv	a0,a5
    80004698:	70a2                	ld	ra,40(sp)
    8000469a:	7402                	ld	s0,32(sp)
    8000469c:	64e2                	ld	s1,24(sp)
    8000469e:	6942                	ld	s2,16(sp)
    800046a0:	6145                	addi	sp,sp,48
    800046a2:	8082                	ret

00000000800046a4 <sys_read>:
{
    800046a4:	7179                	addi	sp,sp,-48
    800046a6:	f406                	sd	ra,40(sp)
    800046a8:	f022                	sd	s0,32(sp)
    800046aa:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046ac:	fd840593          	addi	a1,s0,-40
    800046b0:	4505                	li	a0,1
    800046b2:	ffffe097          	auipc	ra,0xffffe
    800046b6:	994080e7          	jalr	-1644(ra) # 80002046 <argaddr>
  argint(2, &n);
    800046ba:	fe440593          	addi	a1,s0,-28
    800046be:	4509                	li	a0,2
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	966080e7          	jalr	-1690(ra) # 80002026 <argint>
  if (argfd(0, 0, &f) < 0)
    800046c8:	fe840613          	addi	a2,s0,-24
    800046cc:	4581                	li	a1,0
    800046ce:	4501                	li	a0,0
    800046d0:	00000097          	auipc	ra,0x0
    800046d4:	d5e080e7          	jalr	-674(ra) # 8000442e <argfd>
    800046d8:	87aa                	mv	a5,a0
    return -1;
    800046da:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800046dc:	0007cc63          	bltz	a5,800046f4 <sys_read+0x50>
  return fileread(f, p, n);
    800046e0:	fe442603          	lw	a2,-28(s0)
    800046e4:	fd843583          	ld	a1,-40(s0)
    800046e8:	fe843503          	ld	a0,-24(s0)
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	460080e7          	jalr	1120(ra) # 80003b4c <fileread>
}
    800046f4:	70a2                	ld	ra,40(sp)
    800046f6:	7402                	ld	s0,32(sp)
    800046f8:	6145                	addi	sp,sp,48
    800046fa:	8082                	ret

00000000800046fc <sys_write>:
{
    800046fc:	7179                	addi	sp,sp,-48
    800046fe:	f406                	sd	ra,40(sp)
    80004700:	f022                	sd	s0,32(sp)
    80004702:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004704:	fd840593          	addi	a1,s0,-40
    80004708:	4505                	li	a0,1
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	93c080e7          	jalr	-1732(ra) # 80002046 <argaddr>
  argint(2, &n);
    80004712:	fe440593          	addi	a1,s0,-28
    80004716:	4509                	li	a0,2
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	90e080e7          	jalr	-1778(ra) # 80002026 <argint>
  if (argfd(0, 0, &f) < 0)
    80004720:	fe840613          	addi	a2,s0,-24
    80004724:	4581                	li	a1,0
    80004726:	4501                	li	a0,0
    80004728:	00000097          	auipc	ra,0x0
    8000472c:	d06080e7          	jalr	-762(ra) # 8000442e <argfd>
    80004730:	87aa                	mv	a5,a0
    return -1;
    80004732:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004734:	0007cc63          	bltz	a5,8000474c <sys_write+0x50>
  return filewrite(f, p, n);
    80004738:	fe442603          	lw	a2,-28(s0)
    8000473c:	fd843583          	ld	a1,-40(s0)
    80004740:	fe843503          	ld	a0,-24(s0)
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	4ca080e7          	jalr	1226(ra) # 80003c0e <filewrite>
}
    8000474c:	70a2                	ld	ra,40(sp)
    8000474e:	7402                	ld	s0,32(sp)
    80004750:	6145                	addi	sp,sp,48
    80004752:	8082                	ret

0000000080004754 <sys_close>:
{
    80004754:	1101                	addi	sp,sp,-32
    80004756:	ec06                	sd	ra,24(sp)
    80004758:	e822                	sd	s0,16(sp)
    8000475a:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    8000475c:	fe040613          	addi	a2,s0,-32
    80004760:	fec40593          	addi	a1,s0,-20
    80004764:	4501                	li	a0,0
    80004766:	00000097          	auipc	ra,0x0
    8000476a:	cc8080e7          	jalr	-824(ra) # 8000442e <argfd>
    return -1;
    8000476e:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004770:	02054463          	bltz	a0,80004798 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004774:	ffffc097          	auipc	ra,0xffffc
    80004778:	768080e7          	jalr	1896(ra) # 80000edc <myproc>
    8000477c:	fec42783          	lw	a5,-20(s0)
    80004780:	07e9                	addi	a5,a5,26
    80004782:	078e                	slli	a5,a5,0x3
    80004784:	953e                	add	a0,a0,a5
    80004786:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000478a:	fe043503          	ld	a0,-32(s0)
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	284080e7          	jalr	644(ra) # 80003a12 <fileclose>
  return 0;
    80004796:	4781                	li	a5,0
}
    80004798:	853e                	mv	a0,a5
    8000479a:	60e2                	ld	ra,24(sp)
    8000479c:	6442                	ld	s0,16(sp)
    8000479e:	6105                	addi	sp,sp,32
    800047a0:	8082                	ret

00000000800047a2 <sys_fstat>:
{
    800047a2:	1101                	addi	sp,sp,-32
    800047a4:	ec06                	sd	ra,24(sp)
    800047a6:	e822                	sd	s0,16(sp)
    800047a8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800047aa:	fe040593          	addi	a1,s0,-32
    800047ae:	4505                	li	a0,1
    800047b0:	ffffe097          	auipc	ra,0xffffe
    800047b4:	896080e7          	jalr	-1898(ra) # 80002046 <argaddr>
  if (argfd(0, 0, &f) < 0)
    800047b8:	fe840613          	addi	a2,s0,-24
    800047bc:	4581                	li	a1,0
    800047be:	4501                	li	a0,0
    800047c0:	00000097          	auipc	ra,0x0
    800047c4:	c6e080e7          	jalr	-914(ra) # 8000442e <argfd>
    800047c8:	87aa                	mv	a5,a0
    return -1;
    800047ca:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800047cc:	0007ca63          	bltz	a5,800047e0 <sys_fstat+0x3e>
  return filestat(f, st);
    800047d0:	fe043583          	ld	a1,-32(s0)
    800047d4:	fe843503          	ld	a0,-24(s0)
    800047d8:	fffff097          	auipc	ra,0xfffff
    800047dc:	302080e7          	jalr	770(ra) # 80003ada <filestat>
}
    800047e0:	60e2                	ld	ra,24(sp)
    800047e2:	6442                	ld	s0,16(sp)
    800047e4:	6105                	addi	sp,sp,32
    800047e6:	8082                	ret

00000000800047e8 <sys_link>:
{
    800047e8:	7169                	addi	sp,sp,-304
    800047ea:	f606                	sd	ra,296(sp)
    800047ec:	f222                	sd	s0,288(sp)
    800047ee:	ee26                	sd	s1,280(sp)
    800047f0:	ea4a                	sd	s2,272(sp)
    800047f2:	1a00                	addi	s0,sp,304
  printf("enter\n");
    800047f4:	00004517          	auipc	a0,0x4
    800047f8:	e2c50513          	addi	a0,a0,-468 # 80008620 <syscalls+0x2b0>
    800047fc:	00001097          	auipc	ra,0x1
    80004800:	474080e7          	jalr	1140(ra) # 80005c70 <printf>
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004804:	08000613          	li	a2,128
    80004808:	ed040593          	addi	a1,s0,-304
    8000480c:	4501                	li	a0,0
    8000480e:	ffffe097          	auipc	ra,0xffffe
    80004812:	858080e7          	jalr	-1960(ra) # 80002066 <argstr>
    return -1;
    80004816:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004818:	12054763          	bltz	a0,80004946 <sys_link+0x15e>
    8000481c:	08000613          	li	a2,128
    80004820:	f5040593          	addi	a1,s0,-176
    80004824:	4505                	li	a0,1
    80004826:	ffffe097          	auipc	ra,0xffffe
    8000482a:	840080e7          	jalr	-1984(ra) # 80002066 <argstr>
    return -1;
    8000482e:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004830:	10054b63          	bltz	a0,80004946 <sys_link+0x15e>
  begin_op();
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	d1a080e7          	jalr	-742(ra) # 8000354e <begin_op>
  if ((ip = namei(old)) == 0)
    8000483c:	ed040513          	addi	a0,s0,-304
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	b0e080e7          	jalr	-1266(ra) # 8000334e <namei>
    80004848:	84aa                	mv	s1,a0
    8000484a:	cd59                	beqz	a0,800048e8 <sys_link+0x100>
  printf("end\n");
    8000484c:	00004517          	auipc	a0,0x4
    80004850:	ddc50513          	addi	a0,a0,-548 # 80008628 <syscalls+0x2b8>
    80004854:	00001097          	auipc	ra,0x1
    80004858:	41c080e7          	jalr	1052(ra) # 80005c70 <printf>
  ilock(ip);
    8000485c:	8526                	mv	a0,s1
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	34a080e7          	jalr	842(ra) # 80002ba8 <ilock>
  if (ip->type == T_DIR)
    80004866:	04449703          	lh	a4,68(s1)
    8000486a:	4785                	li	a5,1
    8000486c:	08f70463          	beq	a4,a5,800048f4 <sys_link+0x10c>
  ip->nlink++;
    80004870:	04a4d783          	lhu	a5,74(s1)
    80004874:	2785                	addiw	a5,a5,1
    80004876:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000487a:	8526                	mv	a0,s1
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	260080e7          	jalr	608(ra) # 80002adc <iupdate>
  iunlock(ip);
    80004884:	8526                	mv	a0,s1
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	3e4080e7          	jalr	996(ra) # 80002c6a <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000488e:	fd040593          	addi	a1,s0,-48
    80004892:	f5040513          	addi	a0,s0,-176
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	ad6080e7          	jalr	-1322(ra) # 8000336c <nameiparent>
    8000489e:	892a                	mv	s2,a0
    800048a0:	c935                	beqz	a0,80004914 <sys_link+0x12c>
  ilock(dp);
    800048a2:	ffffe097          	auipc	ra,0xffffe
    800048a6:	306080e7          	jalr	774(ra) # 80002ba8 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    800048aa:	00092703          	lw	a4,0(s2)
    800048ae:	409c                	lw	a5,0(s1)
    800048b0:	04f71d63          	bne	a4,a5,8000490a <sys_link+0x122>
    800048b4:	40d0                	lw	a2,4(s1)
    800048b6:	fd040593          	addi	a1,s0,-48
    800048ba:	854a                	mv	a0,s2
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	9e0080e7          	jalr	-1568(ra) # 8000329c <dirlink>
    800048c4:	04054363          	bltz	a0,8000490a <sys_link+0x122>
  iunlockput(dp);
    800048c8:	854a                	mv	a0,s2
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	540080e7          	jalr	1344(ra) # 80002e0a <iunlockput>
  iput(ip);
    800048d2:	8526                	mv	a0,s1
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	48e080e7          	jalr	1166(ra) # 80002d62 <iput>
  end_op();
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	cec080e7          	jalr	-788(ra) # 800035c8 <end_op>
  return 0;
    800048e4:	4781                	li	a5,0
    800048e6:	a085                	j	80004946 <sys_link+0x15e>
    end_op();
    800048e8:	fffff097          	auipc	ra,0xfffff
    800048ec:	ce0080e7          	jalr	-800(ra) # 800035c8 <end_op>
    return -1;
    800048f0:	57fd                	li	a5,-1
    800048f2:	a891                	j	80004946 <sys_link+0x15e>
    iunlockput(ip);
    800048f4:	8526                	mv	a0,s1
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	514080e7          	jalr	1300(ra) # 80002e0a <iunlockput>
    end_op();
    800048fe:	fffff097          	auipc	ra,0xfffff
    80004902:	cca080e7          	jalr	-822(ra) # 800035c8 <end_op>
    return -1;
    80004906:	57fd                	li	a5,-1
    80004908:	a83d                	j	80004946 <sys_link+0x15e>
    iunlockput(dp);
    8000490a:	854a                	mv	a0,s2
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	4fe080e7          	jalr	1278(ra) # 80002e0a <iunlockput>
  ilock(ip);
    80004914:	8526                	mv	a0,s1
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	292080e7          	jalr	658(ra) # 80002ba8 <ilock>
  ip->nlink--;
    8000491e:	04a4d783          	lhu	a5,74(s1)
    80004922:	37fd                	addiw	a5,a5,-1
    80004924:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	1b2080e7          	jalr	434(ra) # 80002adc <iupdate>
  iunlockput(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	4d6080e7          	jalr	1238(ra) # 80002e0a <iunlockput>
  end_op();
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	c8c080e7          	jalr	-884(ra) # 800035c8 <end_op>
  return -1;
    80004944:	57fd                	li	a5,-1
}
    80004946:	853e                	mv	a0,a5
    80004948:	70b2                	ld	ra,296(sp)
    8000494a:	7412                	ld	s0,288(sp)
    8000494c:	64f2                	ld	s1,280(sp)
    8000494e:	6952                	ld	s2,272(sp)
    80004950:	6155                	addi	sp,sp,304
    80004952:	8082                	ret

0000000080004954 <sys_unlink>:
{
    80004954:	7151                	addi	sp,sp,-240
    80004956:	f586                	sd	ra,232(sp)
    80004958:	f1a2                	sd	s0,224(sp)
    8000495a:	eda6                	sd	s1,216(sp)
    8000495c:	e9ca                	sd	s2,208(sp)
    8000495e:	e5ce                	sd	s3,200(sp)
    80004960:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004962:	08000613          	li	a2,128
    80004966:	f3040593          	addi	a1,s0,-208
    8000496a:	4501                	li	a0,0
    8000496c:	ffffd097          	auipc	ra,0xffffd
    80004970:	6fa080e7          	jalr	1786(ra) # 80002066 <argstr>
    80004974:	18054163          	bltz	a0,80004af6 <sys_unlink+0x1a2>
  begin_op();
    80004978:	fffff097          	auipc	ra,0xfffff
    8000497c:	bd6080e7          	jalr	-1066(ra) # 8000354e <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    80004980:	fb040593          	addi	a1,s0,-80
    80004984:	f3040513          	addi	a0,s0,-208
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	9e4080e7          	jalr	-1564(ra) # 8000336c <nameiparent>
    80004990:	84aa                	mv	s1,a0
    80004992:	c979                	beqz	a0,80004a68 <sys_unlink+0x114>
  ilock(dp);
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	214080e7          	jalr	532(ra) # 80002ba8 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000499c:	00004597          	auipc	a1,0x4
    800049a0:	c7458593          	addi	a1,a1,-908 # 80008610 <syscalls+0x2a0>
    800049a4:	fb040513          	addi	a0,s0,-80
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	6ca080e7          	jalr	1738(ra) # 80003072 <namecmp>
    800049b0:	14050a63          	beqz	a0,80004b04 <sys_unlink+0x1b0>
    800049b4:	00004597          	auipc	a1,0x4
    800049b8:	c6458593          	addi	a1,a1,-924 # 80008618 <syscalls+0x2a8>
    800049bc:	fb040513          	addi	a0,s0,-80
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	6b2080e7          	jalr	1714(ra) # 80003072 <namecmp>
    800049c8:	12050e63          	beqz	a0,80004b04 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    800049cc:	f2c40613          	addi	a2,s0,-212
    800049d0:	fb040593          	addi	a1,s0,-80
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	6b6080e7          	jalr	1718(ra) # 8000308c <dirlookup>
    800049de:	892a                	mv	s2,a0
    800049e0:	12050263          	beqz	a0,80004b04 <sys_unlink+0x1b0>
  ilock(ip);
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	1c4080e7          	jalr	452(ra) # 80002ba8 <ilock>
  if (ip->nlink < 1)
    800049ec:	04a91783          	lh	a5,74(s2)
    800049f0:	08f05263          	blez	a5,80004a74 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    800049f4:	04491703          	lh	a4,68(s2)
    800049f8:	4785                	li	a5,1
    800049fa:	08f70563          	beq	a4,a5,80004a84 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049fe:	4641                	li	a2,16
    80004a00:	4581                	li	a1,0
    80004a02:	fc040513          	addi	a0,s0,-64
    80004a06:	ffffb097          	auipc	ra,0xffffb
    80004a0a:	774080e7          	jalr	1908(ra) # 8000017a <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a0e:	4741                	li	a4,16
    80004a10:	f2c42683          	lw	a3,-212(s0)
    80004a14:	fc040613          	addi	a2,s0,-64
    80004a18:	4581                	li	a1,0
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	538080e7          	jalr	1336(ra) # 80002f54 <writei>
    80004a24:	47c1                	li	a5,16
    80004a26:	0af51563          	bne	a0,a5,80004ad0 <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80004a2a:	04491703          	lh	a4,68(s2)
    80004a2e:	4785                	li	a5,1
    80004a30:	0af70863          	beq	a4,a5,80004ae0 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	3d4080e7          	jalr	980(ra) # 80002e0a <iunlockput>
  ip->nlink--;
    80004a3e:	04a95783          	lhu	a5,74(s2)
    80004a42:	37fd                	addiw	a5,a5,-1
    80004a44:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a48:	854a                	mv	a0,s2
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	092080e7          	jalr	146(ra) # 80002adc <iupdate>
  iunlockput(ip);
    80004a52:	854a                	mv	a0,s2
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	3b6080e7          	jalr	950(ra) # 80002e0a <iunlockput>
  end_op();
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	b6c080e7          	jalr	-1172(ra) # 800035c8 <end_op>
  return 0;
    80004a64:	4501                	li	a0,0
    80004a66:	a84d                	j	80004b18 <sys_unlink+0x1c4>
    end_op();
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	b60080e7          	jalr	-1184(ra) # 800035c8 <end_op>
    return -1;
    80004a70:	557d                	li	a0,-1
    80004a72:	a05d                	j	80004b18 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a74:	00004517          	auipc	a0,0x4
    80004a78:	bbc50513          	addi	a0,a0,-1092 # 80008630 <syscalls+0x2c0>
    80004a7c:	00001097          	auipc	ra,0x1
    80004a80:	1aa080e7          	jalr	426(ra) # 80005c26 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004a84:	04c92703          	lw	a4,76(s2)
    80004a88:	02000793          	li	a5,32
    80004a8c:	f6e7f9e3          	bgeu	a5,a4,800049fe <sys_unlink+0xaa>
    80004a90:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a94:	4741                	li	a4,16
    80004a96:	86ce                	mv	a3,s3
    80004a98:	f1840613          	addi	a2,s0,-232
    80004a9c:	4581                	li	a1,0
    80004a9e:	854a                	mv	a0,s2
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	3bc080e7          	jalr	956(ra) # 80002e5c <readi>
    80004aa8:	47c1                	li	a5,16
    80004aaa:	00f51b63          	bne	a0,a5,80004ac0 <sys_unlink+0x16c>
    if (de.inum != 0)
    80004aae:	f1845783          	lhu	a5,-232(s0)
    80004ab2:	e7a1                	bnez	a5,80004afa <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004ab4:	29c1                	addiw	s3,s3,16
    80004ab6:	04c92783          	lw	a5,76(s2)
    80004aba:	fcf9ede3          	bltu	s3,a5,80004a94 <sys_unlink+0x140>
    80004abe:	b781                	j	800049fe <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ac0:	00004517          	auipc	a0,0x4
    80004ac4:	b8850513          	addi	a0,a0,-1144 # 80008648 <syscalls+0x2d8>
    80004ac8:	00001097          	auipc	ra,0x1
    80004acc:	15e080e7          	jalr	350(ra) # 80005c26 <panic>
    panic("unlink: writei");
    80004ad0:	00004517          	auipc	a0,0x4
    80004ad4:	b9050513          	addi	a0,a0,-1136 # 80008660 <syscalls+0x2f0>
    80004ad8:	00001097          	auipc	ra,0x1
    80004adc:	14e080e7          	jalr	334(ra) # 80005c26 <panic>
    dp->nlink--;
    80004ae0:	04a4d783          	lhu	a5,74(s1)
    80004ae4:	37fd                	addiw	a5,a5,-1
    80004ae6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	ff0080e7          	jalr	-16(ra) # 80002adc <iupdate>
    80004af4:	b781                	j	80004a34 <sys_unlink+0xe0>
    return -1;
    80004af6:	557d                	li	a0,-1
    80004af8:	a005                	j	80004b18 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004afa:	854a                	mv	a0,s2
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	30e080e7          	jalr	782(ra) # 80002e0a <iunlockput>
  iunlockput(dp);
    80004b04:	8526                	mv	a0,s1
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	304080e7          	jalr	772(ra) # 80002e0a <iunlockput>
  end_op();
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	aba080e7          	jalr	-1350(ra) # 800035c8 <end_op>
  return -1;
    80004b16:	557d                	li	a0,-1
}
    80004b18:	70ae                	ld	ra,232(sp)
    80004b1a:	740e                	ld	s0,224(sp)
    80004b1c:	64ee                	ld	s1,216(sp)
    80004b1e:	694e                	ld	s2,208(sp)
    80004b20:	69ae                	ld	s3,200(sp)
    80004b22:	616d                	addi	sp,sp,240
    80004b24:	8082                	ret

0000000080004b26 <sys_open>:

uint64
sys_open(void)
{
    80004b26:	7131                	addi	sp,sp,-192
    80004b28:	fd06                	sd	ra,184(sp)
    80004b2a:	f922                	sd	s0,176(sp)
    80004b2c:	f526                	sd	s1,168(sp)
    80004b2e:	f14a                	sd	s2,160(sp)
    80004b30:	ed4e                	sd	s3,152(sp)
    80004b32:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b34:	f4c40593          	addi	a1,s0,-180
    80004b38:	4505                	li	a0,1
    80004b3a:	ffffd097          	auipc	ra,0xffffd
    80004b3e:	4ec080e7          	jalr	1260(ra) # 80002026 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004b42:	08000613          	li	a2,128
    80004b46:	f5040593          	addi	a1,s0,-176
    80004b4a:	4501                	li	a0,0
    80004b4c:	ffffd097          	auipc	ra,0xffffd
    80004b50:	51a080e7          	jalr	1306(ra) # 80002066 <argstr>
    80004b54:	87aa                	mv	a5,a0
    return -1;
    80004b56:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004b58:	0a07c863          	bltz	a5,80004c08 <sys_open+0xe2>

  begin_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	9f2080e7          	jalr	-1550(ra) # 8000354e <begin_op>

  if (omode & O_CREATE)
    80004b64:	f4c42783          	lw	a5,-180(s0)
    80004b68:	2007f793          	andi	a5,a5,512
    80004b6c:	cbdd                	beqz	a5,80004c22 <sys_open+0xfc>
  {
    ip = create(path, T_FILE, 0, 0);
    80004b6e:	4681                	li	a3,0
    80004b70:	4601                	li	a2,0
    80004b72:	4589                	li	a1,2
    80004b74:	f5040513          	addi	a0,s0,-176
    80004b78:	00000097          	auipc	ra,0x0
    80004b7c:	958080e7          	jalr	-1704(ra) # 800044d0 <create>
    80004b80:	84aa                	mv	s1,a0
    if (ip == 0)
    80004b82:	c951                	beqz	a0,80004c16 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004b84:	04449703          	lh	a4,68(s1)
    80004b88:	478d                	li	a5,3
    80004b8a:	00f71763          	bne	a4,a5,80004b98 <sys_open+0x72>
    80004b8e:	0464d703          	lhu	a4,70(s1)
    80004b92:	47a5                	li	a5,9
    80004b94:	0ce7ec63          	bltu	a5,a4,80004c6c <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004b98:	fffff097          	auipc	ra,0xfffff
    80004b9c:	dbe080e7          	jalr	-578(ra) # 80003956 <filealloc>
    80004ba0:	892a                	mv	s2,a0
    80004ba2:	c56d                	beqz	a0,80004c8c <sys_open+0x166>
    80004ba4:	00000097          	auipc	ra,0x0
    80004ba8:	8ea080e7          	jalr	-1814(ra) # 8000448e <fdalloc>
    80004bac:	89aa                	mv	s3,a0
    80004bae:	0c054a63          	bltz	a0,80004c82 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004bb2:	04449703          	lh	a4,68(s1)
    80004bb6:	478d                	li	a5,3
    80004bb8:	0ef70563          	beq	a4,a5,80004ca2 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004bbc:	4789                	li	a5,2
    80004bbe:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004bc2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004bc6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004bca:	f4c42783          	lw	a5,-180(s0)
    80004bce:	0017c713          	xori	a4,a5,1
    80004bd2:	8b05                	andi	a4,a4,1
    80004bd4:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bd8:	0037f713          	andi	a4,a5,3
    80004bdc:	00e03733          	snez	a4,a4
    80004be0:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004be4:	4007f793          	andi	a5,a5,1024
    80004be8:	c791                	beqz	a5,80004bf4 <sys_open+0xce>
    80004bea:	04449703          	lh	a4,68(s1)
    80004bee:	4789                	li	a5,2
    80004bf0:	0cf70063          	beq	a4,a5,80004cb0 <sys_open+0x18a>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	074080e7          	jalr	116(ra) # 80002c6a <iunlock>
  end_op();
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	9ca080e7          	jalr	-1590(ra) # 800035c8 <end_op>

  return fd;
    80004c06:	854e                	mv	a0,s3
}
    80004c08:	70ea                	ld	ra,184(sp)
    80004c0a:	744a                	ld	s0,176(sp)
    80004c0c:	74aa                	ld	s1,168(sp)
    80004c0e:	790a                	ld	s2,160(sp)
    80004c10:	69ea                	ld	s3,152(sp)
    80004c12:	6129                	addi	sp,sp,192
    80004c14:	8082                	ret
      end_op();
    80004c16:	fffff097          	auipc	ra,0xfffff
    80004c1a:	9b2080e7          	jalr	-1614(ra) # 800035c8 <end_op>
      return -1;
    80004c1e:	557d                	li	a0,-1
    80004c20:	b7e5                	j	80004c08 <sys_open+0xe2>
    if ((ip = namei(path)) == 0)
    80004c22:	f5040513          	addi	a0,s0,-176
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	728080e7          	jalr	1832(ra) # 8000334e <namei>
    80004c2e:	84aa                	mv	s1,a0
    80004c30:	c905                	beqz	a0,80004c60 <sys_open+0x13a>
    ilock(ip);
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	f76080e7          	jalr	-138(ra) # 80002ba8 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80004c3a:	04449703          	lh	a4,68(s1)
    80004c3e:	4785                	li	a5,1
    80004c40:	f4f712e3          	bne	a4,a5,80004b84 <sys_open+0x5e>
    80004c44:	f4c42783          	lw	a5,-180(s0)
    80004c48:	dba1                	beqz	a5,80004b98 <sys_open+0x72>
      iunlockput(ip);
    80004c4a:	8526                	mv	a0,s1
    80004c4c:	ffffe097          	auipc	ra,0xffffe
    80004c50:	1be080e7          	jalr	446(ra) # 80002e0a <iunlockput>
      end_op();
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	974080e7          	jalr	-1676(ra) # 800035c8 <end_op>
      return -1;
    80004c5c:	557d                	li	a0,-1
    80004c5e:	b76d                	j	80004c08 <sys_open+0xe2>
      end_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	968080e7          	jalr	-1688(ra) # 800035c8 <end_op>
      return -1;
    80004c68:	557d                	li	a0,-1
    80004c6a:	bf79                	j	80004c08 <sys_open+0xe2>
    iunlockput(ip);
    80004c6c:	8526                	mv	a0,s1
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	19c080e7          	jalr	412(ra) # 80002e0a <iunlockput>
    end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	952080e7          	jalr	-1710(ra) # 800035c8 <end_op>
    return -1;
    80004c7e:	557d                	li	a0,-1
    80004c80:	b761                	j	80004c08 <sys_open+0xe2>
      fileclose(f);
    80004c82:	854a                	mv	a0,s2
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	d8e080e7          	jalr	-626(ra) # 80003a12 <fileclose>
    iunlockput(ip);
    80004c8c:	8526                	mv	a0,s1
    80004c8e:	ffffe097          	auipc	ra,0xffffe
    80004c92:	17c080e7          	jalr	380(ra) # 80002e0a <iunlockput>
    end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	932080e7          	jalr	-1742(ra) # 800035c8 <end_op>
    return -1;
    80004c9e:	557d                	li	a0,-1
    80004ca0:	b7a5                	j	80004c08 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004ca2:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004ca6:	04649783          	lh	a5,70(s1)
    80004caa:	02f91223          	sh	a5,36(s2)
    80004cae:	bf21                	j	80004bc6 <sys_open+0xa0>
    itrunc(ip);
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	004080e7          	jalr	4(ra) # 80002cb6 <itrunc>
    80004cba:	bf2d                	j	80004bf4 <sys_open+0xce>

0000000080004cbc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cbc:	7175                	addi	sp,sp,-144
    80004cbe:	e506                	sd	ra,136(sp)
    80004cc0:	e122                	sd	s0,128(sp)
    80004cc2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	88a080e7          	jalr	-1910(ra) # 8000354e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004ccc:	08000613          	li	a2,128
    80004cd0:	f7040593          	addi	a1,s0,-144
    80004cd4:	4501                	li	a0,0
    80004cd6:	ffffd097          	auipc	ra,0xffffd
    80004cda:	390080e7          	jalr	912(ra) # 80002066 <argstr>
    80004cde:	02054963          	bltz	a0,80004d10 <sys_mkdir+0x54>
    80004ce2:	4681                	li	a3,0
    80004ce4:	4601                	li	a2,0
    80004ce6:	4585                	li	a1,1
    80004ce8:	f7040513          	addi	a0,s0,-144
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	7e4080e7          	jalr	2020(ra) # 800044d0 <create>
    80004cf4:	cd11                	beqz	a0,80004d10 <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cf6:	ffffe097          	auipc	ra,0xffffe
    80004cfa:	114080e7          	jalr	276(ra) # 80002e0a <iunlockput>
  end_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	8ca080e7          	jalr	-1846(ra) # 800035c8 <end_op>
  return 0;
    80004d06:	4501                	li	a0,0
}
    80004d08:	60aa                	ld	ra,136(sp)
    80004d0a:	640a                	ld	s0,128(sp)
    80004d0c:	6149                	addi	sp,sp,144
    80004d0e:	8082                	ret
    end_op();
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	8b8080e7          	jalr	-1864(ra) # 800035c8 <end_op>
    return -1;
    80004d18:	557d                	li	a0,-1
    80004d1a:	b7fd                	j	80004d08 <sys_mkdir+0x4c>

0000000080004d1c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d1c:	7135                	addi	sp,sp,-160
    80004d1e:	ed06                	sd	ra,152(sp)
    80004d20:	e922                	sd	s0,144(sp)
    80004d22:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d24:	fffff097          	auipc	ra,0xfffff
    80004d28:	82a080e7          	jalr	-2006(ra) # 8000354e <begin_op>
  argint(1, &major);
    80004d2c:	f6c40593          	addi	a1,s0,-148
    80004d30:	4505                	li	a0,1
    80004d32:	ffffd097          	auipc	ra,0xffffd
    80004d36:	2f4080e7          	jalr	756(ra) # 80002026 <argint>
  argint(2, &minor);
    80004d3a:	f6840593          	addi	a1,s0,-152
    80004d3e:	4509                	li	a0,2
    80004d40:	ffffd097          	auipc	ra,0xffffd
    80004d44:	2e6080e7          	jalr	742(ra) # 80002026 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004d48:	08000613          	li	a2,128
    80004d4c:	f7040593          	addi	a1,s0,-144
    80004d50:	4501                	li	a0,0
    80004d52:	ffffd097          	auipc	ra,0xffffd
    80004d56:	314080e7          	jalr	788(ra) # 80002066 <argstr>
    80004d5a:	02054b63          	bltz	a0,80004d90 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80004d5e:	f6841683          	lh	a3,-152(s0)
    80004d62:	f6c41603          	lh	a2,-148(s0)
    80004d66:	458d                	li	a1,3
    80004d68:	f7040513          	addi	a0,s0,-144
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	764080e7          	jalr	1892(ra) # 800044d0 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004d74:	cd11                	beqz	a0,80004d90 <sys_mknod+0x74>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	094080e7          	jalr	148(ra) # 80002e0a <iunlockput>
  end_op();
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	84a080e7          	jalr	-1974(ra) # 800035c8 <end_op>
  return 0;
    80004d86:	4501                	li	a0,0
}
    80004d88:	60ea                	ld	ra,152(sp)
    80004d8a:	644a                	ld	s0,144(sp)
    80004d8c:	610d                	addi	sp,sp,160
    80004d8e:	8082                	ret
    end_op();
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	838080e7          	jalr	-1992(ra) # 800035c8 <end_op>
    return -1;
    80004d98:	557d                	li	a0,-1
    80004d9a:	b7fd                	j	80004d88 <sys_mknod+0x6c>

0000000080004d9c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d9c:	7135                	addi	sp,sp,-160
    80004d9e:	ed06                	sd	ra,152(sp)
    80004da0:	e922                	sd	s0,144(sp)
    80004da2:	e526                	sd	s1,136(sp)
    80004da4:	e14a                	sd	s2,128(sp)
    80004da6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004da8:	ffffc097          	auipc	ra,0xffffc
    80004dac:	134080e7          	jalr	308(ra) # 80000edc <myproc>
    80004db0:	892a                	mv	s2,a0

  begin_op();
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	79c080e7          	jalr	1948(ra) # 8000354e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80004dba:	08000613          	li	a2,128
    80004dbe:	f6040593          	addi	a1,s0,-160
    80004dc2:	4501                	li	a0,0
    80004dc4:	ffffd097          	auipc	ra,0xffffd
    80004dc8:	2a2080e7          	jalr	674(ra) # 80002066 <argstr>
    80004dcc:	04054b63          	bltz	a0,80004e22 <sys_chdir+0x86>
    80004dd0:	f6040513          	addi	a0,s0,-160
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	57a080e7          	jalr	1402(ra) # 8000334e <namei>
    80004ddc:	84aa                	mv	s1,a0
    80004dde:	c131                	beqz	a0,80004e22 <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    80004de0:	ffffe097          	auipc	ra,0xffffe
    80004de4:	dc8080e7          	jalr	-568(ra) # 80002ba8 <ilock>
  if (ip->type != T_DIR)
    80004de8:	04449703          	lh	a4,68(s1)
    80004dec:	4785                	li	a5,1
    80004dee:	04f71063          	bne	a4,a5,80004e2e <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004df2:	8526                	mv	a0,s1
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	e76080e7          	jalr	-394(ra) # 80002c6a <iunlock>
  iput(p->cwd);
    80004dfc:	15093503          	ld	a0,336(s2)
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	f62080e7          	jalr	-158(ra) # 80002d62 <iput>
  end_op();
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	7c0080e7          	jalr	1984(ra) # 800035c8 <end_op>
  p->cwd = ip;
    80004e10:	14993823          	sd	s1,336(s2)
  return 0;
    80004e14:	4501                	li	a0,0
}
    80004e16:	60ea                	ld	ra,152(sp)
    80004e18:	644a                	ld	s0,144(sp)
    80004e1a:	64aa                	ld	s1,136(sp)
    80004e1c:	690a                	ld	s2,128(sp)
    80004e1e:	610d                	addi	sp,sp,160
    80004e20:	8082                	ret
    end_op();
    80004e22:	ffffe097          	auipc	ra,0xffffe
    80004e26:	7a6080e7          	jalr	1958(ra) # 800035c8 <end_op>
    return -1;
    80004e2a:	557d                	li	a0,-1
    80004e2c:	b7ed                	j	80004e16 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e2e:	8526                	mv	a0,s1
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	fda080e7          	jalr	-38(ra) # 80002e0a <iunlockput>
    end_op();
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	790080e7          	jalr	1936(ra) # 800035c8 <end_op>
    return -1;
    80004e40:	557d                	li	a0,-1
    80004e42:	bfd1                	j	80004e16 <sys_chdir+0x7a>

0000000080004e44 <sys_exec>:

uint64
sys_exec(void)
{
    80004e44:	7121                	addi	sp,sp,-448
    80004e46:	ff06                	sd	ra,440(sp)
    80004e48:	fb22                	sd	s0,432(sp)
    80004e4a:	f726                	sd	s1,424(sp)
    80004e4c:	f34a                	sd	s2,416(sp)
    80004e4e:	ef4e                	sd	s3,408(sp)
    80004e50:	eb52                	sd	s4,400(sp)
    80004e52:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e54:	e4840593          	addi	a1,s0,-440
    80004e58:	4505                	li	a0,1
    80004e5a:	ffffd097          	auipc	ra,0xffffd
    80004e5e:	1ec080e7          	jalr	492(ra) # 80002046 <argaddr>
  if (argstr(0, path, MAXPATH) < 0)
    80004e62:	08000613          	li	a2,128
    80004e66:	f5040593          	addi	a1,s0,-176
    80004e6a:	4501                	li	a0,0
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	1fa080e7          	jalr	506(ra) # 80002066 <argstr>
    80004e74:	87aa                	mv	a5,a0
  {
    return -1;
    80004e76:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0)
    80004e78:	0c07c263          	bltz	a5,80004f3c <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004e7c:	10000613          	li	a2,256
    80004e80:	4581                	li	a1,0
    80004e82:	e5040513          	addi	a0,s0,-432
    80004e86:	ffffb097          	auipc	ra,0xffffb
    80004e8a:	2f4080e7          	jalr	756(ra) # 8000017a <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80004e8e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e92:	89a6                	mv	s3,s1
    80004e94:	4901                	li	s2,0
    if (i >= NELEM(argv))
    80004e96:	02000a13          	li	s4,32
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80004e9a:	00391513          	slli	a0,s2,0x3
    80004e9e:	e4040593          	addi	a1,s0,-448
    80004ea2:	e4843783          	ld	a5,-440(s0)
    80004ea6:	953e                	add	a0,a0,a5
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	0e0080e7          	jalr	224(ra) # 80001f88 <fetchaddr>
    80004eb0:	02054a63          	bltz	a0,80004ee4 <sys_exec+0xa0>
    {
      goto bad;
    }
    if (uarg == 0)
    80004eb4:	e4043783          	ld	a5,-448(s0)
    80004eb8:	c3b9                	beqz	a5,80004efe <sys_exec+0xba>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eba:	ffffb097          	auipc	ra,0xffffb
    80004ebe:	260080e7          	jalr	608(ra) # 8000011a <kalloc>
    80004ec2:	85aa                	mv	a1,a0
    80004ec4:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80004ec8:	cd11                	beqz	a0,80004ee4 <sys_exec+0xa0>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004eca:	6605                	lui	a2,0x1
    80004ecc:	e4043503          	ld	a0,-448(s0)
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	10a080e7          	jalr	266(ra) # 80001fda <fetchstr>
    80004ed8:	00054663          	bltz	a0,80004ee4 <sys_exec+0xa0>
    if (i >= NELEM(argv))
    80004edc:	0905                	addi	s2,s2,1
    80004ede:	09a1                	addi	s3,s3,8
    80004ee0:	fb491de3          	bne	s2,s4,80004e9a <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ee4:	f5040913          	addi	s2,s0,-176
    80004ee8:	6088                	ld	a0,0(s1)
    80004eea:	c921                	beqz	a0,80004f3a <sys_exec+0xf6>
    kfree(argv[i]);
    80004eec:	ffffb097          	auipc	ra,0xffffb
    80004ef0:	130080e7          	jalr	304(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef4:	04a1                	addi	s1,s1,8
    80004ef6:	ff2499e3          	bne	s1,s2,80004ee8 <sys_exec+0xa4>
  return -1;
    80004efa:	557d                	li	a0,-1
    80004efc:	a081                	j	80004f3c <sys_exec+0xf8>
      argv[i] = 0;
    80004efe:	0009079b          	sext.w	a5,s2
    80004f02:	078e                	slli	a5,a5,0x3
    80004f04:	fd078793          	addi	a5,a5,-48
    80004f08:	97a2                	add	a5,a5,s0
    80004f0a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f0e:	e5040593          	addi	a1,s0,-432
    80004f12:	f5040513          	addi	a0,s0,-176
    80004f16:	fffff097          	auipc	ra,0xfffff
    80004f1a:	172080e7          	jalr	370(ra) # 80004088 <exec>
    80004f1e:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f20:	f5040993          	addi	s3,s0,-176
    80004f24:	6088                	ld	a0,0(s1)
    80004f26:	c901                	beqz	a0,80004f36 <sys_exec+0xf2>
    kfree(argv[i]);
    80004f28:	ffffb097          	auipc	ra,0xffffb
    80004f2c:	0f4080e7          	jalr	244(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f30:	04a1                	addi	s1,s1,8
    80004f32:	ff3499e3          	bne	s1,s3,80004f24 <sys_exec+0xe0>
  return ret;
    80004f36:	854a                	mv	a0,s2
    80004f38:	a011                	j	80004f3c <sys_exec+0xf8>
  return -1;
    80004f3a:	557d                	li	a0,-1
}
    80004f3c:	70fa                	ld	ra,440(sp)
    80004f3e:	745a                	ld	s0,432(sp)
    80004f40:	74ba                	ld	s1,424(sp)
    80004f42:	791a                	ld	s2,416(sp)
    80004f44:	69fa                	ld	s3,408(sp)
    80004f46:	6a5a                	ld	s4,400(sp)
    80004f48:	6139                	addi	sp,sp,448
    80004f4a:	8082                	ret

0000000080004f4c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f4c:	7139                	addi	sp,sp,-64
    80004f4e:	fc06                	sd	ra,56(sp)
    80004f50:	f822                	sd	s0,48(sp)
    80004f52:	f426                	sd	s1,40(sp)
    80004f54:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f56:	ffffc097          	auipc	ra,0xffffc
    80004f5a:	f86080e7          	jalr	-122(ra) # 80000edc <myproc>
    80004f5e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f60:	fd840593          	addi	a1,s0,-40
    80004f64:	4501                	li	a0,0
    80004f66:	ffffd097          	auipc	ra,0xffffd
    80004f6a:	0e0080e7          	jalr	224(ra) # 80002046 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80004f6e:	fc840593          	addi	a1,s0,-56
    80004f72:	fd040513          	addi	a0,s0,-48
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	dc8080e7          	jalr	-568(ra) # 80003d3e <pipealloc>
    return -1;
    80004f7e:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80004f80:	0c054463          	bltz	a0,80005048 <sys_pipe+0xfc>
  fd0 = -1;
    80004f84:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80004f88:	fd043503          	ld	a0,-48(s0)
    80004f8c:	fffff097          	auipc	ra,0xfffff
    80004f90:	502080e7          	jalr	1282(ra) # 8000448e <fdalloc>
    80004f94:	fca42223          	sw	a0,-60(s0)
    80004f98:	08054b63          	bltz	a0,8000502e <sys_pipe+0xe2>
    80004f9c:	fc843503          	ld	a0,-56(s0)
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	4ee080e7          	jalr	1262(ra) # 8000448e <fdalloc>
    80004fa8:	fca42023          	sw	a0,-64(s0)
    80004fac:	06054863          	bltz	a0,8000501c <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004fb0:	4691                	li	a3,4
    80004fb2:	fc440613          	addi	a2,s0,-60
    80004fb6:	fd843583          	ld	a1,-40(s0)
    80004fba:	68a8                	ld	a0,80(s1)
    80004fbc:	ffffc097          	auipc	ra,0xffffc
    80004fc0:	be0080e7          	jalr	-1056(ra) # 80000b9c <copyout>
    80004fc4:	02054063          	bltz	a0,80004fe4 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    80004fc8:	4691                	li	a3,4
    80004fca:	fc040613          	addi	a2,s0,-64
    80004fce:	fd843583          	ld	a1,-40(s0)
    80004fd2:	0591                	addi	a1,a1,4
    80004fd4:	68a8                	ld	a0,80(s1)
    80004fd6:	ffffc097          	auipc	ra,0xffffc
    80004fda:	bc6080e7          	jalr	-1082(ra) # 80000b9c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fde:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004fe0:	06055463          	bgez	a0,80005048 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004fe4:	fc442783          	lw	a5,-60(s0)
    80004fe8:	07e9                	addi	a5,a5,26
    80004fea:	078e                	slli	a5,a5,0x3
    80004fec:	97a6                	add	a5,a5,s1
    80004fee:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ff2:	fc042783          	lw	a5,-64(s0)
    80004ff6:	07e9                	addi	a5,a5,26
    80004ff8:	078e                	slli	a5,a5,0x3
    80004ffa:	94be                	add	s1,s1,a5
    80004ffc:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005000:	fd043503          	ld	a0,-48(s0)
    80005004:	fffff097          	auipc	ra,0xfffff
    80005008:	a0e080e7          	jalr	-1522(ra) # 80003a12 <fileclose>
    fileclose(wf);
    8000500c:	fc843503          	ld	a0,-56(s0)
    80005010:	fffff097          	auipc	ra,0xfffff
    80005014:	a02080e7          	jalr	-1534(ra) # 80003a12 <fileclose>
    return -1;
    80005018:	57fd                	li	a5,-1
    8000501a:	a03d                	j	80005048 <sys_pipe+0xfc>
    if (fd0 >= 0)
    8000501c:	fc442783          	lw	a5,-60(s0)
    80005020:	0007c763          	bltz	a5,8000502e <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005024:	07e9                	addi	a5,a5,26
    80005026:	078e                	slli	a5,a5,0x3
    80005028:	97a6                	add	a5,a5,s1
    8000502a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000502e:	fd043503          	ld	a0,-48(s0)
    80005032:	fffff097          	auipc	ra,0xfffff
    80005036:	9e0080e7          	jalr	-1568(ra) # 80003a12 <fileclose>
    fileclose(wf);
    8000503a:	fc843503          	ld	a0,-56(s0)
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	9d4080e7          	jalr	-1580(ra) # 80003a12 <fileclose>
    return -1;
    80005046:	57fd                	li	a5,-1
}
    80005048:	853e                	mv	a0,a5
    8000504a:	70e2                	ld	ra,56(sp)
    8000504c:	7442                	ld	s0,48(sp)
    8000504e:	74a2                	ld	s1,40(sp)
    80005050:	6121                	addi	sp,sp,64
    80005052:	8082                	ret
	...

0000000080005060 <kernelvec>:
    80005060:	7111                	addi	sp,sp,-256
    80005062:	e006                	sd	ra,0(sp)
    80005064:	e40a                	sd	sp,8(sp)
    80005066:	e80e                	sd	gp,16(sp)
    80005068:	ec12                	sd	tp,24(sp)
    8000506a:	f016                	sd	t0,32(sp)
    8000506c:	f41a                	sd	t1,40(sp)
    8000506e:	f81e                	sd	t2,48(sp)
    80005070:	fc22                	sd	s0,56(sp)
    80005072:	e0a6                	sd	s1,64(sp)
    80005074:	e4aa                	sd	a0,72(sp)
    80005076:	e8ae                	sd	a1,80(sp)
    80005078:	ecb2                	sd	a2,88(sp)
    8000507a:	f0b6                	sd	a3,96(sp)
    8000507c:	f4ba                	sd	a4,104(sp)
    8000507e:	f8be                	sd	a5,112(sp)
    80005080:	fcc2                	sd	a6,120(sp)
    80005082:	e146                	sd	a7,128(sp)
    80005084:	e54a                	sd	s2,136(sp)
    80005086:	e94e                	sd	s3,144(sp)
    80005088:	ed52                	sd	s4,152(sp)
    8000508a:	f156                	sd	s5,160(sp)
    8000508c:	f55a                	sd	s6,168(sp)
    8000508e:	f95e                	sd	s7,176(sp)
    80005090:	fd62                	sd	s8,184(sp)
    80005092:	e1e6                	sd	s9,192(sp)
    80005094:	e5ea                	sd	s10,200(sp)
    80005096:	e9ee                	sd	s11,208(sp)
    80005098:	edf2                	sd	t3,216(sp)
    8000509a:	f1f6                	sd	t4,224(sp)
    8000509c:	f5fa                	sd	t5,232(sp)
    8000509e:	f9fe                	sd	t6,240(sp)
    800050a0:	db5fc0ef          	jal	ra,80001e54 <kerneltrap>
    800050a4:	6082                	ld	ra,0(sp)
    800050a6:	6122                	ld	sp,8(sp)
    800050a8:	61c2                	ld	gp,16(sp)
    800050aa:	7282                	ld	t0,32(sp)
    800050ac:	7322                	ld	t1,40(sp)
    800050ae:	73c2                	ld	t2,48(sp)
    800050b0:	7462                	ld	s0,56(sp)
    800050b2:	6486                	ld	s1,64(sp)
    800050b4:	6526                	ld	a0,72(sp)
    800050b6:	65c6                	ld	a1,80(sp)
    800050b8:	6666                	ld	a2,88(sp)
    800050ba:	7686                	ld	a3,96(sp)
    800050bc:	7726                	ld	a4,104(sp)
    800050be:	77c6                	ld	a5,112(sp)
    800050c0:	7866                	ld	a6,120(sp)
    800050c2:	688a                	ld	a7,128(sp)
    800050c4:	692a                	ld	s2,136(sp)
    800050c6:	69ca                	ld	s3,144(sp)
    800050c8:	6a6a                	ld	s4,152(sp)
    800050ca:	7a8a                	ld	s5,160(sp)
    800050cc:	7b2a                	ld	s6,168(sp)
    800050ce:	7bca                	ld	s7,176(sp)
    800050d0:	7c6a                	ld	s8,184(sp)
    800050d2:	6c8e                	ld	s9,192(sp)
    800050d4:	6d2e                	ld	s10,200(sp)
    800050d6:	6dce                	ld	s11,208(sp)
    800050d8:	6e6e                	ld	t3,216(sp)
    800050da:	7e8e                	ld	t4,224(sp)
    800050dc:	7f2e                	ld	t5,232(sp)
    800050de:	7fce                	ld	t6,240(sp)
    800050e0:	6111                	addi	sp,sp,256
    800050e2:	10200073          	sret
    800050e6:	00000013          	nop
    800050ea:	00000013          	nop
    800050ee:	0001                	nop

00000000800050f0 <timervec>:
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	e10c                	sd	a1,0(a0)
    800050f6:	e510                	sd	a2,8(a0)
    800050f8:	e914                	sd	a3,16(a0)
    800050fa:	6d0c                	ld	a1,24(a0)
    800050fc:	7110                	ld	a2,32(a0)
    800050fe:	6194                	ld	a3,0(a1)
    80005100:	96b2                	add	a3,a3,a2
    80005102:	e194                	sd	a3,0(a1)
    80005104:	4589                	li	a1,2
    80005106:	14459073          	csrw	sip,a1
    8000510a:	6914                	ld	a3,16(a0)
    8000510c:	6510                	ld	a2,8(a0)
    8000510e:	610c                	ld	a1,0(a0)
    80005110:	34051573          	csrrw	a0,mscratch,a0
    80005114:	30200073          	mret
	...

000000008000511a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000511a:	1141                	addi	sp,sp,-16
    8000511c:	e422                	sd	s0,8(sp)
    8000511e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005120:	0c0007b7          	lui	a5,0xc000
    80005124:	4705                	li	a4,1
    80005126:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005128:	c3d8                	sw	a4,4(a5)
}
    8000512a:	6422                	ld	s0,8(sp)
    8000512c:	0141                	addi	sp,sp,16
    8000512e:	8082                	ret

0000000080005130 <plicinithart>:

void
plicinithart(void)
{
    80005130:	1141                	addi	sp,sp,-16
    80005132:	e406                	sd	ra,8(sp)
    80005134:	e022                	sd	s0,0(sp)
    80005136:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	d78080e7          	jalr	-648(ra) # 80000eb0 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005140:	0085171b          	slliw	a4,a0,0x8
    80005144:	0c0027b7          	lui	a5,0xc002
    80005148:	97ba                	add	a5,a5,a4
    8000514a:	40200713          	li	a4,1026
    8000514e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005152:	00d5151b          	slliw	a0,a0,0xd
    80005156:	0c2017b7          	lui	a5,0xc201
    8000515a:	97aa                	add	a5,a5,a0
    8000515c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret

0000000080005168 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005168:	1141                	addi	sp,sp,-16
    8000516a:	e406                	sd	ra,8(sp)
    8000516c:	e022                	sd	s0,0(sp)
    8000516e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	d40080e7          	jalr	-704(ra) # 80000eb0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005178:	00d5151b          	slliw	a0,a0,0xd
    8000517c:	0c2017b7          	lui	a5,0xc201
    80005180:	97aa                	add	a5,a5,a0
  return irq;
}
    80005182:	43c8                	lw	a0,4(a5)
    80005184:	60a2                	ld	ra,8(sp)
    80005186:	6402                	ld	s0,0(sp)
    80005188:	0141                	addi	sp,sp,16
    8000518a:	8082                	ret

000000008000518c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000518c:	1101                	addi	sp,sp,-32
    8000518e:	ec06                	sd	ra,24(sp)
    80005190:	e822                	sd	s0,16(sp)
    80005192:	e426                	sd	s1,8(sp)
    80005194:	1000                	addi	s0,sp,32
    80005196:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	d18080e7          	jalr	-744(ra) # 80000eb0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051a0:	00d5151b          	slliw	a0,a0,0xd
    800051a4:	0c2017b7          	lui	a5,0xc201
    800051a8:	97aa                	add	a5,a5,a0
    800051aa:	c3c4                	sw	s1,4(a5)
}
    800051ac:	60e2                	ld	ra,24(sp)
    800051ae:	6442                	ld	s0,16(sp)
    800051b0:	64a2                	ld	s1,8(sp)
    800051b2:	6105                	addi	sp,sp,32
    800051b4:	8082                	ret

00000000800051b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051b6:	1141                	addi	sp,sp,-16
    800051b8:	e406                	sd	ra,8(sp)
    800051ba:	e022                	sd	s0,0(sp)
    800051bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051be:	479d                	li	a5,7
    800051c0:	04a7cc63          	blt	a5,a0,80005218 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800051c4:	00014797          	auipc	a5,0x14
    800051c8:	79c78793          	addi	a5,a5,1948 # 80019960 <disk>
    800051cc:	97aa                	add	a5,a5,a0
    800051ce:	0187c783          	lbu	a5,24(a5)
    800051d2:	ebb9                	bnez	a5,80005228 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051d4:	00451693          	slli	a3,a0,0x4
    800051d8:	00014797          	auipc	a5,0x14
    800051dc:	78878793          	addi	a5,a5,1928 # 80019960 <disk>
    800051e0:	6398                	ld	a4,0(a5)
    800051e2:	9736                	add	a4,a4,a3
    800051e4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800051e8:	6398                	ld	a4,0(a5)
    800051ea:	9736                	add	a4,a4,a3
    800051ec:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800051f0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800051f4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800051f8:	97aa                	add	a5,a5,a0
    800051fa:	4705                	li	a4,1
    800051fc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005200:	00014517          	auipc	a0,0x14
    80005204:	77850513          	addi	a0,a0,1912 # 80019978 <disk+0x18>
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	3e0080e7          	jalr	992(ra) # 800015e8 <wakeup>
}
    80005210:	60a2                	ld	ra,8(sp)
    80005212:	6402                	ld	s0,0(sp)
    80005214:	0141                	addi	sp,sp,16
    80005216:	8082                	ret
    panic("free_desc 1");
    80005218:	00003517          	auipc	a0,0x3
    8000521c:	45850513          	addi	a0,a0,1112 # 80008670 <syscalls+0x300>
    80005220:	00001097          	auipc	ra,0x1
    80005224:	a06080e7          	jalr	-1530(ra) # 80005c26 <panic>
    panic("free_desc 2");
    80005228:	00003517          	auipc	a0,0x3
    8000522c:	45850513          	addi	a0,a0,1112 # 80008680 <syscalls+0x310>
    80005230:	00001097          	auipc	ra,0x1
    80005234:	9f6080e7          	jalr	-1546(ra) # 80005c26 <panic>

0000000080005238 <virtio_disk_init>:
{
    80005238:	1101                	addi	sp,sp,-32
    8000523a:	ec06                	sd	ra,24(sp)
    8000523c:	e822                	sd	s0,16(sp)
    8000523e:	e426                	sd	s1,8(sp)
    80005240:	e04a                	sd	s2,0(sp)
    80005242:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005244:	00003597          	auipc	a1,0x3
    80005248:	44c58593          	addi	a1,a1,1100 # 80008690 <syscalls+0x320>
    8000524c:	00015517          	auipc	a0,0x15
    80005250:	83c50513          	addi	a0,a0,-1988 # 80019a88 <disk+0x128>
    80005254:	00001097          	auipc	ra,0x1
    80005258:	e7a080e7          	jalr	-390(ra) # 800060ce <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000525c:	100017b7          	lui	a5,0x10001
    80005260:	4398                	lw	a4,0(a5)
    80005262:	2701                	sext.w	a4,a4
    80005264:	747277b7          	lui	a5,0x74727
    80005268:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000526c:	14f71b63          	bne	a4,a5,800053c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005270:	100017b7          	lui	a5,0x10001
    80005274:	43dc                	lw	a5,4(a5)
    80005276:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005278:	4709                	li	a4,2
    8000527a:	14e79463          	bne	a5,a4,800053c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000527e:	100017b7          	lui	a5,0x10001
    80005282:	479c                	lw	a5,8(a5)
    80005284:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005286:	12e79e63          	bne	a5,a4,800053c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000528a:	100017b7          	lui	a5,0x10001
    8000528e:	47d8                	lw	a4,12(a5)
    80005290:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005292:	554d47b7          	lui	a5,0x554d4
    80005296:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000529a:	12f71463          	bne	a4,a5,800053c2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000529e:	100017b7          	lui	a5,0x10001
    800052a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052a6:	4705                	li	a4,1
    800052a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052aa:	470d                	li	a4,3
    800052ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052ae:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052b0:	c7ffe6b7          	lui	a3,0xc7ffe
    800052b4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdca7f>
    800052b8:	8f75                	and	a4,a4,a3
    800052ba:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052bc:	472d                	li	a4,11
    800052be:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052c0:	5bbc                	lw	a5,112(a5)
    800052c2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052c6:	8ba1                	andi	a5,a5,8
    800052c8:	10078563          	beqz	a5,800053d2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052cc:	100017b7          	lui	a5,0x10001
    800052d0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800052d4:	43fc                	lw	a5,68(a5)
    800052d6:	2781                	sext.w	a5,a5
    800052d8:	10079563          	bnez	a5,800053e2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052dc:	100017b7          	lui	a5,0x10001
    800052e0:	5bdc                	lw	a5,52(a5)
    800052e2:	2781                	sext.w	a5,a5
  if(max == 0)
    800052e4:	10078763          	beqz	a5,800053f2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800052e8:	471d                	li	a4,7
    800052ea:	10f77c63          	bgeu	a4,a5,80005402 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800052ee:	ffffb097          	auipc	ra,0xffffb
    800052f2:	e2c080e7          	jalr	-468(ra) # 8000011a <kalloc>
    800052f6:	00014497          	auipc	s1,0x14
    800052fa:	66a48493          	addi	s1,s1,1642 # 80019960 <disk>
    800052fe:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005300:	ffffb097          	auipc	ra,0xffffb
    80005304:	e1a080e7          	jalr	-486(ra) # 8000011a <kalloc>
    80005308:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000530a:	ffffb097          	auipc	ra,0xffffb
    8000530e:	e10080e7          	jalr	-496(ra) # 8000011a <kalloc>
    80005312:	87aa                	mv	a5,a0
    80005314:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005316:	6088                	ld	a0,0(s1)
    80005318:	cd6d                	beqz	a0,80005412 <virtio_disk_init+0x1da>
    8000531a:	00014717          	auipc	a4,0x14
    8000531e:	64e73703          	ld	a4,1614(a4) # 80019968 <disk+0x8>
    80005322:	cb65                	beqz	a4,80005412 <virtio_disk_init+0x1da>
    80005324:	c7fd                	beqz	a5,80005412 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005326:	6605                	lui	a2,0x1
    80005328:	4581                	li	a1,0
    8000532a:	ffffb097          	auipc	ra,0xffffb
    8000532e:	e50080e7          	jalr	-432(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005332:	00014497          	auipc	s1,0x14
    80005336:	62e48493          	addi	s1,s1,1582 # 80019960 <disk>
    8000533a:	6605                	lui	a2,0x1
    8000533c:	4581                	li	a1,0
    8000533e:	6488                	ld	a0,8(s1)
    80005340:	ffffb097          	auipc	ra,0xffffb
    80005344:	e3a080e7          	jalr	-454(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005348:	6605                	lui	a2,0x1
    8000534a:	4581                	li	a1,0
    8000534c:	6888                	ld	a0,16(s1)
    8000534e:	ffffb097          	auipc	ra,0xffffb
    80005352:	e2c080e7          	jalr	-468(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005356:	100017b7          	lui	a5,0x10001
    8000535a:	4721                	li	a4,8
    8000535c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000535e:	4098                	lw	a4,0(s1)
    80005360:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005364:	40d8                	lw	a4,4(s1)
    80005366:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000536a:	6498                	ld	a4,8(s1)
    8000536c:	0007069b          	sext.w	a3,a4
    80005370:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005374:	9701                	srai	a4,a4,0x20
    80005376:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000537a:	6898                	ld	a4,16(s1)
    8000537c:	0007069b          	sext.w	a3,a4
    80005380:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005384:	9701                	srai	a4,a4,0x20
    80005386:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000538a:	4705                	li	a4,1
    8000538c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000538e:	00e48c23          	sb	a4,24(s1)
    80005392:	00e48ca3          	sb	a4,25(s1)
    80005396:	00e48d23          	sb	a4,26(s1)
    8000539a:	00e48da3          	sb	a4,27(s1)
    8000539e:	00e48e23          	sb	a4,28(s1)
    800053a2:	00e48ea3          	sb	a4,29(s1)
    800053a6:	00e48f23          	sb	a4,30(s1)
    800053aa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053ae:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b2:	0727a823          	sw	s2,112(a5)
}
    800053b6:	60e2                	ld	ra,24(sp)
    800053b8:	6442                	ld	s0,16(sp)
    800053ba:	64a2                	ld	s1,8(sp)
    800053bc:	6902                	ld	s2,0(sp)
    800053be:	6105                	addi	sp,sp,32
    800053c0:	8082                	ret
    panic("could not find virtio disk");
    800053c2:	00003517          	auipc	a0,0x3
    800053c6:	2de50513          	addi	a0,a0,734 # 800086a0 <syscalls+0x330>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	85c080e7          	jalr	-1956(ra) # 80005c26 <panic>
    panic("virtio disk FEATURES_OK unset");
    800053d2:	00003517          	auipc	a0,0x3
    800053d6:	2ee50513          	addi	a0,a0,750 # 800086c0 <syscalls+0x350>
    800053da:	00001097          	auipc	ra,0x1
    800053de:	84c080e7          	jalr	-1972(ra) # 80005c26 <panic>
    panic("virtio disk should not be ready");
    800053e2:	00003517          	auipc	a0,0x3
    800053e6:	2fe50513          	addi	a0,a0,766 # 800086e0 <syscalls+0x370>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	83c080e7          	jalr	-1988(ra) # 80005c26 <panic>
    panic("virtio disk has no queue 0");
    800053f2:	00003517          	auipc	a0,0x3
    800053f6:	30e50513          	addi	a0,a0,782 # 80008700 <syscalls+0x390>
    800053fa:	00001097          	auipc	ra,0x1
    800053fe:	82c080e7          	jalr	-2004(ra) # 80005c26 <panic>
    panic("virtio disk max queue too short");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	31e50513          	addi	a0,a0,798 # 80008720 <syscalls+0x3b0>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	81c080e7          	jalr	-2020(ra) # 80005c26 <panic>
    panic("virtio disk kalloc");
    80005412:	00003517          	auipc	a0,0x3
    80005416:	32e50513          	addi	a0,a0,814 # 80008740 <syscalls+0x3d0>
    8000541a:	00001097          	auipc	ra,0x1
    8000541e:	80c080e7          	jalr	-2036(ra) # 80005c26 <panic>

0000000080005422 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005422:	7159                	addi	sp,sp,-112
    80005424:	f486                	sd	ra,104(sp)
    80005426:	f0a2                	sd	s0,96(sp)
    80005428:	eca6                	sd	s1,88(sp)
    8000542a:	e8ca                	sd	s2,80(sp)
    8000542c:	e4ce                	sd	s3,72(sp)
    8000542e:	e0d2                	sd	s4,64(sp)
    80005430:	fc56                	sd	s5,56(sp)
    80005432:	f85a                	sd	s6,48(sp)
    80005434:	f45e                	sd	s7,40(sp)
    80005436:	f062                	sd	s8,32(sp)
    80005438:	ec66                	sd	s9,24(sp)
    8000543a:	e86a                	sd	s10,16(sp)
    8000543c:	1880                	addi	s0,sp,112
    8000543e:	8a2a                	mv	s4,a0
    80005440:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005442:	00c52c83          	lw	s9,12(a0)
    80005446:	001c9c9b          	slliw	s9,s9,0x1
    8000544a:	1c82                	slli	s9,s9,0x20
    8000544c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005450:	00014517          	auipc	a0,0x14
    80005454:	63850513          	addi	a0,a0,1592 # 80019a88 <disk+0x128>
    80005458:	00001097          	auipc	ra,0x1
    8000545c:	d06080e7          	jalr	-762(ra) # 8000615e <acquire>
  for(int i = 0; i < 3; i++){
    80005460:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005462:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005464:	00014b17          	auipc	s6,0x14
    80005468:	4fcb0b13          	addi	s6,s6,1276 # 80019960 <disk>
  for(int i = 0; i < 3; i++){
    8000546c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000546e:	00014c17          	auipc	s8,0x14
    80005472:	61ac0c13          	addi	s8,s8,1562 # 80019a88 <disk+0x128>
    80005476:	a095                	j	800054da <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005478:	00fb0733          	add	a4,s6,a5
    8000547c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005480:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005482:	0207c563          	bltz	a5,800054ac <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005486:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005488:	0591                	addi	a1,a1,4
    8000548a:	05560d63          	beq	a2,s5,800054e4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000548e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005490:	00014717          	auipc	a4,0x14
    80005494:	4d070713          	addi	a4,a4,1232 # 80019960 <disk>
    80005498:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000549a:	01874683          	lbu	a3,24(a4)
    8000549e:	fee9                	bnez	a3,80005478 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800054a0:	2785                	addiw	a5,a5,1
    800054a2:	0705                	addi	a4,a4,1
    800054a4:	fe979be3          	bne	a5,s1,8000549a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800054a8:	57fd                	li	a5,-1
    800054aa:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800054ac:	00c05e63          	blez	a2,800054c8 <virtio_disk_rw+0xa6>
    800054b0:	060a                	slli	a2,a2,0x2
    800054b2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800054b6:	0009a503          	lw	a0,0(s3)
    800054ba:	00000097          	auipc	ra,0x0
    800054be:	cfc080e7          	jalr	-772(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    800054c2:	0991                	addi	s3,s3,4
    800054c4:	ffa999e3          	bne	s3,s10,800054b6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054c8:	85e2                	mv	a1,s8
    800054ca:	00014517          	auipc	a0,0x14
    800054ce:	4ae50513          	addi	a0,a0,1198 # 80019978 <disk+0x18>
    800054d2:	ffffc097          	auipc	ra,0xffffc
    800054d6:	0b2080e7          	jalr	178(ra) # 80001584 <sleep>
  for(int i = 0; i < 3; i++){
    800054da:	f9040993          	addi	s3,s0,-112
{
    800054de:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800054e0:	864a                	mv	a2,s2
    800054e2:	b775                	j	8000548e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054e4:	f9042503          	lw	a0,-112(s0)
    800054e8:	00a50713          	addi	a4,a0,10
    800054ec:	0712                	slli	a4,a4,0x4

  if(write)
    800054ee:	00014797          	auipc	a5,0x14
    800054f2:	47278793          	addi	a5,a5,1138 # 80019960 <disk>
    800054f6:	00e786b3          	add	a3,a5,a4
    800054fa:	01703633          	snez	a2,s7
    800054fe:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005500:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005504:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005508:	f6070613          	addi	a2,a4,-160
    8000550c:	6394                	ld	a3,0(a5)
    8000550e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005510:	00870593          	addi	a1,a4,8
    80005514:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005516:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005518:	0007b803          	ld	a6,0(a5)
    8000551c:	9642                	add	a2,a2,a6
    8000551e:	46c1                	li	a3,16
    80005520:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005522:	4585                	li	a1,1
    80005524:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005528:	f9442683          	lw	a3,-108(s0)
    8000552c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005530:	0692                	slli	a3,a3,0x4
    80005532:	9836                	add	a6,a6,a3
    80005534:	058a0613          	addi	a2,s4,88
    80005538:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000553c:	0007b803          	ld	a6,0(a5)
    80005540:	96c2                	add	a3,a3,a6
    80005542:	40000613          	li	a2,1024
    80005546:	c690                	sw	a2,8(a3)
  if(write)
    80005548:	001bb613          	seqz	a2,s7
    8000554c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005550:	00166613          	ori	a2,a2,1
    80005554:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005558:	f9842603          	lw	a2,-104(s0)
    8000555c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005560:	00250693          	addi	a3,a0,2
    80005564:	0692                	slli	a3,a3,0x4
    80005566:	96be                	add	a3,a3,a5
    80005568:	58fd                	li	a7,-1
    8000556a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000556e:	0612                	slli	a2,a2,0x4
    80005570:	9832                	add	a6,a6,a2
    80005572:	f9070713          	addi	a4,a4,-112
    80005576:	973e                	add	a4,a4,a5
    80005578:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000557c:	6398                	ld	a4,0(a5)
    8000557e:	9732                	add	a4,a4,a2
    80005580:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005582:	4609                	li	a2,2
    80005584:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005588:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000558c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005590:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005594:	6794                	ld	a3,8(a5)
    80005596:	0026d703          	lhu	a4,2(a3)
    8000559a:	8b1d                	andi	a4,a4,7
    8000559c:	0706                	slli	a4,a4,0x1
    8000559e:	96ba                	add	a3,a3,a4
    800055a0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800055a4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055a8:	6798                	ld	a4,8(a5)
    800055aa:	00275783          	lhu	a5,2(a4)
    800055ae:	2785                	addiw	a5,a5,1
    800055b0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055b4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055b8:	100017b7          	lui	a5,0x10001
    800055bc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055c0:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800055c4:	00014917          	auipc	s2,0x14
    800055c8:	4c490913          	addi	s2,s2,1220 # 80019a88 <disk+0x128>
  while(b->disk == 1) {
    800055cc:	4485                	li	s1,1
    800055ce:	00b79c63          	bne	a5,a1,800055e6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800055d2:	85ca                	mv	a1,s2
    800055d4:	8552                	mv	a0,s4
    800055d6:	ffffc097          	auipc	ra,0xffffc
    800055da:	fae080e7          	jalr	-82(ra) # 80001584 <sleep>
  while(b->disk == 1) {
    800055de:	004a2783          	lw	a5,4(s4)
    800055e2:	fe9788e3          	beq	a5,s1,800055d2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800055e6:	f9042903          	lw	s2,-112(s0)
    800055ea:	00290713          	addi	a4,s2,2
    800055ee:	0712                	slli	a4,a4,0x4
    800055f0:	00014797          	auipc	a5,0x14
    800055f4:	37078793          	addi	a5,a5,880 # 80019960 <disk>
    800055f8:	97ba                	add	a5,a5,a4
    800055fa:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055fe:	00014997          	auipc	s3,0x14
    80005602:	36298993          	addi	s3,s3,866 # 80019960 <disk>
    80005606:	00491713          	slli	a4,s2,0x4
    8000560a:	0009b783          	ld	a5,0(s3)
    8000560e:	97ba                	add	a5,a5,a4
    80005610:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005614:	854a                	mv	a0,s2
    80005616:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000561a:	00000097          	auipc	ra,0x0
    8000561e:	b9c080e7          	jalr	-1124(ra) # 800051b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005622:	8885                	andi	s1,s1,1
    80005624:	f0ed                	bnez	s1,80005606 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005626:	00014517          	auipc	a0,0x14
    8000562a:	46250513          	addi	a0,a0,1122 # 80019a88 <disk+0x128>
    8000562e:	00001097          	auipc	ra,0x1
    80005632:	be4080e7          	jalr	-1052(ra) # 80006212 <release>
}
    80005636:	70a6                	ld	ra,104(sp)
    80005638:	7406                	ld	s0,96(sp)
    8000563a:	64e6                	ld	s1,88(sp)
    8000563c:	6946                	ld	s2,80(sp)
    8000563e:	69a6                	ld	s3,72(sp)
    80005640:	6a06                	ld	s4,64(sp)
    80005642:	7ae2                	ld	s5,56(sp)
    80005644:	7b42                	ld	s6,48(sp)
    80005646:	7ba2                	ld	s7,40(sp)
    80005648:	7c02                	ld	s8,32(sp)
    8000564a:	6ce2                	ld	s9,24(sp)
    8000564c:	6d42                	ld	s10,16(sp)
    8000564e:	6165                	addi	sp,sp,112
    80005650:	8082                	ret

0000000080005652 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005652:	1101                	addi	sp,sp,-32
    80005654:	ec06                	sd	ra,24(sp)
    80005656:	e822                	sd	s0,16(sp)
    80005658:	e426                	sd	s1,8(sp)
    8000565a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000565c:	00014497          	auipc	s1,0x14
    80005660:	30448493          	addi	s1,s1,772 # 80019960 <disk>
    80005664:	00014517          	auipc	a0,0x14
    80005668:	42450513          	addi	a0,a0,1060 # 80019a88 <disk+0x128>
    8000566c:	00001097          	auipc	ra,0x1
    80005670:	af2080e7          	jalr	-1294(ra) # 8000615e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005674:	10001737          	lui	a4,0x10001
    80005678:	533c                	lw	a5,96(a4)
    8000567a:	8b8d                	andi	a5,a5,3
    8000567c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000567e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005682:	689c                	ld	a5,16(s1)
    80005684:	0204d703          	lhu	a4,32(s1)
    80005688:	0027d783          	lhu	a5,2(a5)
    8000568c:	04f70863          	beq	a4,a5,800056dc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005690:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005694:	6898                	ld	a4,16(s1)
    80005696:	0204d783          	lhu	a5,32(s1)
    8000569a:	8b9d                	andi	a5,a5,7
    8000569c:	078e                	slli	a5,a5,0x3
    8000569e:	97ba                	add	a5,a5,a4
    800056a0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056a2:	00278713          	addi	a4,a5,2
    800056a6:	0712                	slli	a4,a4,0x4
    800056a8:	9726                	add	a4,a4,s1
    800056aa:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056ae:	e721                	bnez	a4,800056f6 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056b0:	0789                	addi	a5,a5,2
    800056b2:	0792                	slli	a5,a5,0x4
    800056b4:	97a6                	add	a5,a5,s1
    800056b6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800056b8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056bc:	ffffc097          	auipc	ra,0xffffc
    800056c0:	f2c080e7          	jalr	-212(ra) # 800015e8 <wakeup>

    disk.used_idx += 1;
    800056c4:	0204d783          	lhu	a5,32(s1)
    800056c8:	2785                	addiw	a5,a5,1
    800056ca:	17c2                	slli	a5,a5,0x30
    800056cc:	93c1                	srli	a5,a5,0x30
    800056ce:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056d2:	6898                	ld	a4,16(s1)
    800056d4:	00275703          	lhu	a4,2(a4)
    800056d8:	faf71ce3          	bne	a4,a5,80005690 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800056dc:	00014517          	auipc	a0,0x14
    800056e0:	3ac50513          	addi	a0,a0,940 # 80019a88 <disk+0x128>
    800056e4:	00001097          	auipc	ra,0x1
    800056e8:	b2e080e7          	jalr	-1234(ra) # 80006212 <release>
}
    800056ec:	60e2                	ld	ra,24(sp)
    800056ee:	6442                	ld	s0,16(sp)
    800056f0:	64a2                	ld	s1,8(sp)
    800056f2:	6105                	addi	sp,sp,32
    800056f4:	8082                	ret
      panic("virtio_disk_intr status");
    800056f6:	00003517          	auipc	a0,0x3
    800056fa:	06250513          	addi	a0,a0,98 # 80008758 <syscalls+0x3e8>
    800056fe:	00000097          	auipc	ra,0x0
    80005702:	528080e7          	jalr	1320(ra) # 80005c26 <panic>

0000000080005706 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005706:	1141                	addi	sp,sp,-16
    80005708:	e422                	sd	s0,8(sp)
    8000570a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000570c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005710:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005714:	0037979b          	slliw	a5,a5,0x3
    80005718:	02004737          	lui	a4,0x2004
    8000571c:	97ba                	add	a5,a5,a4
    8000571e:	0200c737          	lui	a4,0x200c
    80005722:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005726:	000f4637          	lui	a2,0xf4
    8000572a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000572e:	9732                	add	a4,a4,a2
    80005730:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005732:	00259693          	slli	a3,a1,0x2
    80005736:	96ae                	add	a3,a3,a1
    80005738:	068e                	slli	a3,a3,0x3
    8000573a:	00014717          	auipc	a4,0x14
    8000573e:	36670713          	addi	a4,a4,870 # 80019aa0 <timer_scratch>
    80005742:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005744:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005746:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005748:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000574c:	00000797          	auipc	a5,0x0
    80005750:	9a478793          	addi	a5,a5,-1628 # 800050f0 <timervec>
    80005754:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005758:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000575c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005760:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005764:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005768:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000576c:	30479073          	csrw	mie,a5
}
    80005770:	6422                	ld	s0,8(sp)
    80005772:	0141                	addi	sp,sp,16
    80005774:	8082                	ret

0000000080005776 <start>:
{
    80005776:	1141                	addi	sp,sp,-16
    80005778:	e406                	sd	ra,8(sp)
    8000577a:	e022                	sd	s0,0(sp)
    8000577c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000577e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005782:	7779                	lui	a4,0xffffe
    80005784:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcb1f>
    80005788:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000578a:	6705                	lui	a4,0x1
    8000578c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005790:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005792:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005796:	ffffb797          	auipc	a5,0xffffb
    8000579a:	b8878793          	addi	a5,a5,-1144 # 8000031e <main>
    8000579e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057a2:	4781                	li	a5,0
    800057a4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057a8:	67c1                	lui	a5,0x10
    800057aa:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057ac:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057b0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057b4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057b8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057bc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057c0:	57fd                	li	a5,-1
    800057c2:	83a9                	srli	a5,a5,0xa
    800057c4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057c8:	47bd                	li	a5,15
    800057ca:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057ce:	00000097          	auipc	ra,0x0
    800057d2:	f38080e7          	jalr	-200(ra) # 80005706 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057d6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057da:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057dc:	823e                	mv	tp,a5
  asm volatile("mret");
    800057de:	30200073          	mret
}
    800057e2:	60a2                	ld	ra,8(sp)
    800057e4:	6402                	ld	s0,0(sp)
    800057e6:	0141                	addi	sp,sp,16
    800057e8:	8082                	ret

00000000800057ea <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057ea:	715d                	addi	sp,sp,-80
    800057ec:	e486                	sd	ra,72(sp)
    800057ee:	e0a2                	sd	s0,64(sp)
    800057f0:	fc26                	sd	s1,56(sp)
    800057f2:	f84a                	sd	s2,48(sp)
    800057f4:	f44e                	sd	s3,40(sp)
    800057f6:	f052                	sd	s4,32(sp)
    800057f8:	ec56                	sd	s5,24(sp)
    800057fa:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057fc:	04c05763          	blez	a2,8000584a <consolewrite+0x60>
    80005800:	8a2a                	mv	s4,a0
    80005802:	84ae                	mv	s1,a1
    80005804:	89b2                	mv	s3,a2
    80005806:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005808:	5afd                	li	s5,-1
    8000580a:	4685                	li	a3,1
    8000580c:	8626                	mv	a2,s1
    8000580e:	85d2                	mv	a1,s4
    80005810:	fbf40513          	addi	a0,s0,-65
    80005814:	ffffc097          	auipc	ra,0xffffc
    80005818:	1ce080e7          	jalr	462(ra) # 800019e2 <either_copyin>
    8000581c:	01550d63          	beq	a0,s5,80005836 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005820:	fbf44503          	lbu	a0,-65(s0)
    80005824:	00000097          	auipc	ra,0x0
    80005828:	780080e7          	jalr	1920(ra) # 80005fa4 <uartputc>
  for(i = 0; i < n; i++){
    8000582c:	2905                	addiw	s2,s2,1
    8000582e:	0485                	addi	s1,s1,1
    80005830:	fd299de3          	bne	s3,s2,8000580a <consolewrite+0x20>
    80005834:	894e                	mv	s2,s3
  }

  return i;
}
    80005836:	854a                	mv	a0,s2
    80005838:	60a6                	ld	ra,72(sp)
    8000583a:	6406                	ld	s0,64(sp)
    8000583c:	74e2                	ld	s1,56(sp)
    8000583e:	7942                	ld	s2,48(sp)
    80005840:	79a2                	ld	s3,40(sp)
    80005842:	7a02                	ld	s4,32(sp)
    80005844:	6ae2                	ld	s5,24(sp)
    80005846:	6161                	addi	sp,sp,80
    80005848:	8082                	ret
  for(i = 0; i < n; i++){
    8000584a:	4901                	li	s2,0
    8000584c:	b7ed                	j	80005836 <consolewrite+0x4c>

000000008000584e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000584e:	711d                	addi	sp,sp,-96
    80005850:	ec86                	sd	ra,88(sp)
    80005852:	e8a2                	sd	s0,80(sp)
    80005854:	e4a6                	sd	s1,72(sp)
    80005856:	e0ca                	sd	s2,64(sp)
    80005858:	fc4e                	sd	s3,56(sp)
    8000585a:	f852                	sd	s4,48(sp)
    8000585c:	f456                	sd	s5,40(sp)
    8000585e:	f05a                	sd	s6,32(sp)
    80005860:	ec5e                	sd	s7,24(sp)
    80005862:	1080                	addi	s0,sp,96
    80005864:	8aaa                	mv	s5,a0
    80005866:	8a2e                	mv	s4,a1
    80005868:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000586a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000586e:	0001c517          	auipc	a0,0x1c
    80005872:	37250513          	addi	a0,a0,882 # 80021be0 <cons>
    80005876:	00001097          	auipc	ra,0x1
    8000587a:	8e8080e7          	jalr	-1816(ra) # 8000615e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000587e:	0001c497          	auipc	s1,0x1c
    80005882:	36248493          	addi	s1,s1,866 # 80021be0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005886:	0001c917          	auipc	s2,0x1c
    8000588a:	3f290913          	addi	s2,s2,1010 # 80021c78 <cons+0x98>
  while(n > 0){
    8000588e:	09305263          	blez	s3,80005912 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005892:	0984a783          	lw	a5,152(s1)
    80005896:	09c4a703          	lw	a4,156(s1)
    8000589a:	02f71763          	bne	a4,a5,800058c8 <consoleread+0x7a>
      if(killed(myproc())){
    8000589e:	ffffb097          	auipc	ra,0xffffb
    800058a2:	63e080e7          	jalr	1598(ra) # 80000edc <myproc>
    800058a6:	ffffc097          	auipc	ra,0xffffc
    800058aa:	f86080e7          	jalr	-122(ra) # 8000182c <killed>
    800058ae:	ed2d                	bnez	a0,80005928 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800058b0:	85a6                	mv	a1,s1
    800058b2:	854a                	mv	a0,s2
    800058b4:	ffffc097          	auipc	ra,0xffffc
    800058b8:	cd0080e7          	jalr	-816(ra) # 80001584 <sleep>
    while(cons.r == cons.w){
    800058bc:	0984a783          	lw	a5,152(s1)
    800058c0:	09c4a703          	lw	a4,156(s1)
    800058c4:	fcf70de3          	beq	a4,a5,8000589e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800058c8:	0001c717          	auipc	a4,0x1c
    800058cc:	31870713          	addi	a4,a4,792 # 80021be0 <cons>
    800058d0:	0017869b          	addiw	a3,a5,1
    800058d4:	08d72c23          	sw	a3,152(a4)
    800058d8:	07f7f693          	andi	a3,a5,127
    800058dc:	9736                	add	a4,a4,a3
    800058de:	01874703          	lbu	a4,24(a4)
    800058e2:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800058e6:	4691                	li	a3,4
    800058e8:	06db8463          	beq	s7,a3,80005950 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800058ec:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058f0:	4685                	li	a3,1
    800058f2:	faf40613          	addi	a2,s0,-81
    800058f6:	85d2                	mv	a1,s4
    800058f8:	8556                	mv	a0,s5
    800058fa:	ffffc097          	auipc	ra,0xffffc
    800058fe:	092080e7          	jalr	146(ra) # 8000198c <either_copyout>
    80005902:	57fd                	li	a5,-1
    80005904:	00f50763          	beq	a0,a5,80005912 <consoleread+0xc4>
      break;

    dst++;
    80005908:	0a05                	addi	s4,s4,1
    --n;
    8000590a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000590c:	47a9                	li	a5,10
    8000590e:	f8fb90e3          	bne	s7,a5,8000588e <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005912:	0001c517          	auipc	a0,0x1c
    80005916:	2ce50513          	addi	a0,a0,718 # 80021be0 <cons>
    8000591a:	00001097          	auipc	ra,0x1
    8000591e:	8f8080e7          	jalr	-1800(ra) # 80006212 <release>

  return target - n;
    80005922:	413b053b          	subw	a0,s6,s3
    80005926:	a811                	j	8000593a <consoleread+0xec>
        release(&cons.lock);
    80005928:	0001c517          	auipc	a0,0x1c
    8000592c:	2b850513          	addi	a0,a0,696 # 80021be0 <cons>
    80005930:	00001097          	auipc	ra,0x1
    80005934:	8e2080e7          	jalr	-1822(ra) # 80006212 <release>
        return -1;
    80005938:	557d                	li	a0,-1
}
    8000593a:	60e6                	ld	ra,88(sp)
    8000593c:	6446                	ld	s0,80(sp)
    8000593e:	64a6                	ld	s1,72(sp)
    80005940:	6906                	ld	s2,64(sp)
    80005942:	79e2                	ld	s3,56(sp)
    80005944:	7a42                	ld	s4,48(sp)
    80005946:	7aa2                	ld	s5,40(sp)
    80005948:	7b02                	ld	s6,32(sp)
    8000594a:	6be2                	ld	s7,24(sp)
    8000594c:	6125                	addi	sp,sp,96
    8000594e:	8082                	ret
      if(n < target){
    80005950:	0009871b          	sext.w	a4,s3
    80005954:	fb677fe3          	bgeu	a4,s6,80005912 <consoleread+0xc4>
        cons.r--;
    80005958:	0001c717          	auipc	a4,0x1c
    8000595c:	32f72023          	sw	a5,800(a4) # 80021c78 <cons+0x98>
    80005960:	bf4d                	j	80005912 <consoleread+0xc4>

0000000080005962 <consputc>:
{
    80005962:	1141                	addi	sp,sp,-16
    80005964:	e406                	sd	ra,8(sp)
    80005966:	e022                	sd	s0,0(sp)
    80005968:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000596a:	10000793          	li	a5,256
    8000596e:	00f50a63          	beq	a0,a5,80005982 <consputc+0x20>
    uartputc_sync(c);
    80005972:	00000097          	auipc	ra,0x0
    80005976:	560080e7          	jalr	1376(ra) # 80005ed2 <uartputc_sync>
}
    8000597a:	60a2                	ld	ra,8(sp)
    8000597c:	6402                	ld	s0,0(sp)
    8000597e:	0141                	addi	sp,sp,16
    80005980:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005982:	4521                	li	a0,8
    80005984:	00000097          	auipc	ra,0x0
    80005988:	54e080e7          	jalr	1358(ra) # 80005ed2 <uartputc_sync>
    8000598c:	02000513          	li	a0,32
    80005990:	00000097          	auipc	ra,0x0
    80005994:	542080e7          	jalr	1346(ra) # 80005ed2 <uartputc_sync>
    80005998:	4521                	li	a0,8
    8000599a:	00000097          	auipc	ra,0x0
    8000599e:	538080e7          	jalr	1336(ra) # 80005ed2 <uartputc_sync>
    800059a2:	bfe1                	j	8000597a <consputc+0x18>

00000000800059a4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059a4:	1101                	addi	sp,sp,-32
    800059a6:	ec06                	sd	ra,24(sp)
    800059a8:	e822                	sd	s0,16(sp)
    800059aa:	e426                	sd	s1,8(sp)
    800059ac:	e04a                	sd	s2,0(sp)
    800059ae:	1000                	addi	s0,sp,32
    800059b0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059b2:	0001c517          	auipc	a0,0x1c
    800059b6:	22e50513          	addi	a0,a0,558 # 80021be0 <cons>
    800059ba:	00000097          	auipc	ra,0x0
    800059be:	7a4080e7          	jalr	1956(ra) # 8000615e <acquire>

  switch(c){
    800059c2:	47d5                	li	a5,21
    800059c4:	0af48663          	beq	s1,a5,80005a70 <consoleintr+0xcc>
    800059c8:	0297ca63          	blt	a5,s1,800059fc <consoleintr+0x58>
    800059cc:	47a1                	li	a5,8
    800059ce:	0ef48763          	beq	s1,a5,80005abc <consoleintr+0x118>
    800059d2:	47c1                	li	a5,16
    800059d4:	10f49a63          	bne	s1,a5,80005ae8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059d8:	ffffc097          	auipc	ra,0xffffc
    800059dc:	060080e7          	jalr	96(ra) # 80001a38 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059e0:	0001c517          	auipc	a0,0x1c
    800059e4:	20050513          	addi	a0,a0,512 # 80021be0 <cons>
    800059e8:	00001097          	auipc	ra,0x1
    800059ec:	82a080e7          	jalr	-2006(ra) # 80006212 <release>
}
    800059f0:	60e2                	ld	ra,24(sp)
    800059f2:	6442                	ld	s0,16(sp)
    800059f4:	64a2                	ld	s1,8(sp)
    800059f6:	6902                	ld	s2,0(sp)
    800059f8:	6105                	addi	sp,sp,32
    800059fa:	8082                	ret
  switch(c){
    800059fc:	07f00793          	li	a5,127
    80005a00:	0af48e63          	beq	s1,a5,80005abc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a04:	0001c717          	auipc	a4,0x1c
    80005a08:	1dc70713          	addi	a4,a4,476 # 80021be0 <cons>
    80005a0c:	0a072783          	lw	a5,160(a4)
    80005a10:	09872703          	lw	a4,152(a4)
    80005a14:	9f99                	subw	a5,a5,a4
    80005a16:	07f00713          	li	a4,127
    80005a1a:	fcf763e3          	bltu	a4,a5,800059e0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a1e:	47b5                	li	a5,13
    80005a20:	0cf48763          	beq	s1,a5,80005aee <consoleintr+0x14a>
      consputc(c);
    80005a24:	8526                	mv	a0,s1
    80005a26:	00000097          	auipc	ra,0x0
    80005a2a:	f3c080e7          	jalr	-196(ra) # 80005962 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a2e:	0001c797          	auipc	a5,0x1c
    80005a32:	1b278793          	addi	a5,a5,434 # 80021be0 <cons>
    80005a36:	0a07a683          	lw	a3,160(a5)
    80005a3a:	0016871b          	addiw	a4,a3,1
    80005a3e:	0007061b          	sext.w	a2,a4
    80005a42:	0ae7a023          	sw	a4,160(a5)
    80005a46:	07f6f693          	andi	a3,a3,127
    80005a4a:	97b6                	add	a5,a5,a3
    80005a4c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a50:	47a9                	li	a5,10
    80005a52:	0cf48563          	beq	s1,a5,80005b1c <consoleintr+0x178>
    80005a56:	4791                	li	a5,4
    80005a58:	0cf48263          	beq	s1,a5,80005b1c <consoleintr+0x178>
    80005a5c:	0001c797          	auipc	a5,0x1c
    80005a60:	21c7a783          	lw	a5,540(a5) # 80021c78 <cons+0x98>
    80005a64:	9f1d                	subw	a4,a4,a5
    80005a66:	08000793          	li	a5,128
    80005a6a:	f6f71be3          	bne	a4,a5,800059e0 <consoleintr+0x3c>
    80005a6e:	a07d                	j	80005b1c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a70:	0001c717          	auipc	a4,0x1c
    80005a74:	17070713          	addi	a4,a4,368 # 80021be0 <cons>
    80005a78:	0a072783          	lw	a5,160(a4)
    80005a7c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a80:	0001c497          	auipc	s1,0x1c
    80005a84:	16048493          	addi	s1,s1,352 # 80021be0 <cons>
    while(cons.e != cons.w &&
    80005a88:	4929                	li	s2,10
    80005a8a:	f4f70be3          	beq	a4,a5,800059e0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a8e:	37fd                	addiw	a5,a5,-1
    80005a90:	07f7f713          	andi	a4,a5,127
    80005a94:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a96:	01874703          	lbu	a4,24(a4)
    80005a9a:	f52703e3          	beq	a4,s2,800059e0 <consoleintr+0x3c>
      cons.e--;
    80005a9e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005aa2:	10000513          	li	a0,256
    80005aa6:	00000097          	auipc	ra,0x0
    80005aaa:	ebc080e7          	jalr	-324(ra) # 80005962 <consputc>
    while(cons.e != cons.w &&
    80005aae:	0a04a783          	lw	a5,160(s1)
    80005ab2:	09c4a703          	lw	a4,156(s1)
    80005ab6:	fcf71ce3          	bne	a4,a5,80005a8e <consoleintr+0xea>
    80005aba:	b71d                	j	800059e0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005abc:	0001c717          	auipc	a4,0x1c
    80005ac0:	12470713          	addi	a4,a4,292 # 80021be0 <cons>
    80005ac4:	0a072783          	lw	a5,160(a4)
    80005ac8:	09c72703          	lw	a4,156(a4)
    80005acc:	f0f70ae3          	beq	a4,a5,800059e0 <consoleintr+0x3c>
      cons.e--;
    80005ad0:	37fd                	addiw	a5,a5,-1
    80005ad2:	0001c717          	auipc	a4,0x1c
    80005ad6:	1af72723          	sw	a5,430(a4) # 80021c80 <cons+0xa0>
      consputc(BACKSPACE);
    80005ada:	10000513          	li	a0,256
    80005ade:	00000097          	auipc	ra,0x0
    80005ae2:	e84080e7          	jalr	-380(ra) # 80005962 <consputc>
    80005ae6:	bded                	j	800059e0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ae8:	ee048ce3          	beqz	s1,800059e0 <consoleintr+0x3c>
    80005aec:	bf21                	j	80005a04 <consoleintr+0x60>
      consputc(c);
    80005aee:	4529                	li	a0,10
    80005af0:	00000097          	auipc	ra,0x0
    80005af4:	e72080e7          	jalr	-398(ra) # 80005962 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005af8:	0001c797          	auipc	a5,0x1c
    80005afc:	0e878793          	addi	a5,a5,232 # 80021be0 <cons>
    80005b00:	0a07a703          	lw	a4,160(a5)
    80005b04:	0017069b          	addiw	a3,a4,1
    80005b08:	0006861b          	sext.w	a2,a3
    80005b0c:	0ad7a023          	sw	a3,160(a5)
    80005b10:	07f77713          	andi	a4,a4,127
    80005b14:	97ba                	add	a5,a5,a4
    80005b16:	4729                	li	a4,10
    80005b18:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b1c:	0001c797          	auipc	a5,0x1c
    80005b20:	16c7a023          	sw	a2,352(a5) # 80021c7c <cons+0x9c>
        wakeup(&cons.r);
    80005b24:	0001c517          	auipc	a0,0x1c
    80005b28:	15450513          	addi	a0,a0,340 # 80021c78 <cons+0x98>
    80005b2c:	ffffc097          	auipc	ra,0xffffc
    80005b30:	abc080e7          	jalr	-1348(ra) # 800015e8 <wakeup>
    80005b34:	b575                	j	800059e0 <consoleintr+0x3c>

0000000080005b36 <consoleinit>:

void
consoleinit(void)
{
    80005b36:	1141                	addi	sp,sp,-16
    80005b38:	e406                	sd	ra,8(sp)
    80005b3a:	e022                	sd	s0,0(sp)
    80005b3c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b3e:	00003597          	auipc	a1,0x3
    80005b42:	c3258593          	addi	a1,a1,-974 # 80008770 <syscalls+0x400>
    80005b46:	0001c517          	auipc	a0,0x1c
    80005b4a:	09a50513          	addi	a0,a0,154 # 80021be0 <cons>
    80005b4e:	00000097          	auipc	ra,0x0
    80005b52:	580080e7          	jalr	1408(ra) # 800060ce <initlock>

  uartinit();
    80005b56:	00000097          	auipc	ra,0x0
    80005b5a:	32c080e7          	jalr	812(ra) # 80005e82 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b5e:	00013797          	auipc	a5,0x13
    80005b62:	daa78793          	addi	a5,a5,-598 # 80018908 <devsw>
    80005b66:	00000717          	auipc	a4,0x0
    80005b6a:	ce870713          	addi	a4,a4,-792 # 8000584e <consoleread>
    80005b6e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b70:	00000717          	auipc	a4,0x0
    80005b74:	c7a70713          	addi	a4,a4,-902 # 800057ea <consolewrite>
    80005b78:	ef98                	sd	a4,24(a5)
}
    80005b7a:	60a2                	ld	ra,8(sp)
    80005b7c:	6402                	ld	s0,0(sp)
    80005b7e:	0141                	addi	sp,sp,16
    80005b80:	8082                	ret

0000000080005b82 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b82:	7179                	addi	sp,sp,-48
    80005b84:	f406                	sd	ra,40(sp)
    80005b86:	f022                	sd	s0,32(sp)
    80005b88:	ec26                	sd	s1,24(sp)
    80005b8a:	e84a                	sd	s2,16(sp)
    80005b8c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b8e:	c219                	beqz	a2,80005b94 <printint+0x12>
    80005b90:	08054763          	bltz	a0,80005c1e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b94:	2501                	sext.w	a0,a0
    80005b96:	4881                	li	a7,0
    80005b98:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b9c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b9e:	2581                	sext.w	a1,a1
    80005ba0:	00003617          	auipc	a2,0x3
    80005ba4:	c0060613          	addi	a2,a2,-1024 # 800087a0 <digits>
    80005ba8:	883a                	mv	a6,a4
    80005baa:	2705                	addiw	a4,a4,1
    80005bac:	02b577bb          	remuw	a5,a0,a1
    80005bb0:	1782                	slli	a5,a5,0x20
    80005bb2:	9381                	srli	a5,a5,0x20
    80005bb4:	97b2                	add	a5,a5,a2
    80005bb6:	0007c783          	lbu	a5,0(a5)
    80005bba:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bbe:	0005079b          	sext.w	a5,a0
    80005bc2:	02b5553b          	divuw	a0,a0,a1
    80005bc6:	0685                	addi	a3,a3,1
    80005bc8:	feb7f0e3          	bgeu	a5,a1,80005ba8 <printint+0x26>

  if(sign)
    80005bcc:	00088c63          	beqz	a7,80005be4 <printint+0x62>
    buf[i++] = '-';
    80005bd0:	fe070793          	addi	a5,a4,-32
    80005bd4:	00878733          	add	a4,a5,s0
    80005bd8:	02d00793          	li	a5,45
    80005bdc:	fef70823          	sb	a5,-16(a4)
    80005be0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005be4:	02e05763          	blez	a4,80005c12 <printint+0x90>
    80005be8:	fd040793          	addi	a5,s0,-48
    80005bec:	00e784b3          	add	s1,a5,a4
    80005bf0:	fff78913          	addi	s2,a5,-1
    80005bf4:	993a                	add	s2,s2,a4
    80005bf6:	377d                	addiw	a4,a4,-1
    80005bf8:	1702                	slli	a4,a4,0x20
    80005bfa:	9301                	srli	a4,a4,0x20
    80005bfc:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c00:	fff4c503          	lbu	a0,-1(s1)
    80005c04:	00000097          	auipc	ra,0x0
    80005c08:	d5e080e7          	jalr	-674(ra) # 80005962 <consputc>
  while(--i >= 0)
    80005c0c:	14fd                	addi	s1,s1,-1
    80005c0e:	ff2499e3          	bne	s1,s2,80005c00 <printint+0x7e>
}
    80005c12:	70a2                	ld	ra,40(sp)
    80005c14:	7402                	ld	s0,32(sp)
    80005c16:	64e2                	ld	s1,24(sp)
    80005c18:	6942                	ld	s2,16(sp)
    80005c1a:	6145                	addi	sp,sp,48
    80005c1c:	8082                	ret
    x = -xx;
    80005c1e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c22:	4885                	li	a7,1
    x = -xx;
    80005c24:	bf95                	j	80005b98 <printint+0x16>

0000000080005c26 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c26:	1101                	addi	sp,sp,-32
    80005c28:	ec06                	sd	ra,24(sp)
    80005c2a:	e822                	sd	s0,16(sp)
    80005c2c:	e426                	sd	s1,8(sp)
    80005c2e:	1000                	addi	s0,sp,32
    80005c30:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c32:	0001c797          	auipc	a5,0x1c
    80005c36:	0607a723          	sw	zero,110(a5) # 80021ca0 <pr+0x18>
  printf("panic: ");
    80005c3a:	00003517          	auipc	a0,0x3
    80005c3e:	b3e50513          	addi	a0,a0,-1218 # 80008778 <syscalls+0x408>
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	02e080e7          	jalr	46(ra) # 80005c70 <printf>
  printf(s);
    80005c4a:	8526                	mv	a0,s1
    80005c4c:	00000097          	auipc	ra,0x0
    80005c50:	024080e7          	jalr	36(ra) # 80005c70 <printf>
  printf("\n");
    80005c54:	00002517          	auipc	a0,0x2
    80005c58:	3f450513          	addi	a0,a0,1012 # 80008048 <etext+0x48>
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	014080e7          	jalr	20(ra) # 80005c70 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c64:	4785                	li	a5,1
    80005c66:	00003717          	auipc	a4,0x3
    80005c6a:	bef72b23          	sw	a5,-1034(a4) # 8000885c <panicked>
  for(;;)
    80005c6e:	a001                	j	80005c6e <panic+0x48>

0000000080005c70 <printf>:
{
    80005c70:	7131                	addi	sp,sp,-192
    80005c72:	fc86                	sd	ra,120(sp)
    80005c74:	f8a2                	sd	s0,112(sp)
    80005c76:	f4a6                	sd	s1,104(sp)
    80005c78:	f0ca                	sd	s2,96(sp)
    80005c7a:	ecce                	sd	s3,88(sp)
    80005c7c:	e8d2                	sd	s4,80(sp)
    80005c7e:	e4d6                	sd	s5,72(sp)
    80005c80:	e0da                	sd	s6,64(sp)
    80005c82:	fc5e                	sd	s7,56(sp)
    80005c84:	f862                	sd	s8,48(sp)
    80005c86:	f466                	sd	s9,40(sp)
    80005c88:	f06a                	sd	s10,32(sp)
    80005c8a:	ec6e                	sd	s11,24(sp)
    80005c8c:	0100                	addi	s0,sp,128
    80005c8e:	8a2a                	mv	s4,a0
    80005c90:	e40c                	sd	a1,8(s0)
    80005c92:	e810                	sd	a2,16(s0)
    80005c94:	ec14                	sd	a3,24(s0)
    80005c96:	f018                	sd	a4,32(s0)
    80005c98:	f41c                	sd	a5,40(s0)
    80005c9a:	03043823          	sd	a6,48(s0)
    80005c9e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ca2:	0001cd97          	auipc	s11,0x1c
    80005ca6:	ffedad83          	lw	s11,-2(s11) # 80021ca0 <pr+0x18>
  if(locking)
    80005caa:	020d9b63          	bnez	s11,80005ce0 <printf+0x70>
  if (fmt == 0)
    80005cae:	040a0263          	beqz	s4,80005cf2 <printf+0x82>
  va_start(ap, fmt);
    80005cb2:	00840793          	addi	a5,s0,8
    80005cb6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cba:	000a4503          	lbu	a0,0(s4)
    80005cbe:	14050f63          	beqz	a0,80005e1c <printf+0x1ac>
    80005cc2:	4981                	li	s3,0
    if(c != '%'){
    80005cc4:	02500a93          	li	s5,37
    switch(c){
    80005cc8:	07000b93          	li	s7,112
  consputc('x');
    80005ccc:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cce:	00003b17          	auipc	s6,0x3
    80005cd2:	ad2b0b13          	addi	s6,s6,-1326 # 800087a0 <digits>
    switch(c){
    80005cd6:	07300c93          	li	s9,115
    80005cda:	06400c13          	li	s8,100
    80005cde:	a82d                	j	80005d18 <printf+0xa8>
    acquire(&pr.lock);
    80005ce0:	0001c517          	auipc	a0,0x1c
    80005ce4:	fa850513          	addi	a0,a0,-88 # 80021c88 <pr>
    80005ce8:	00000097          	auipc	ra,0x0
    80005cec:	476080e7          	jalr	1142(ra) # 8000615e <acquire>
    80005cf0:	bf7d                	j	80005cae <printf+0x3e>
    panic("null fmt");
    80005cf2:	00003517          	auipc	a0,0x3
    80005cf6:	a9650513          	addi	a0,a0,-1386 # 80008788 <syscalls+0x418>
    80005cfa:	00000097          	auipc	ra,0x0
    80005cfe:	f2c080e7          	jalr	-212(ra) # 80005c26 <panic>
      consputc(c);
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	c60080e7          	jalr	-928(ra) # 80005962 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d0a:	2985                	addiw	s3,s3,1
    80005d0c:	013a07b3          	add	a5,s4,s3
    80005d10:	0007c503          	lbu	a0,0(a5)
    80005d14:	10050463          	beqz	a0,80005e1c <printf+0x1ac>
    if(c != '%'){
    80005d18:	ff5515e3          	bne	a0,s5,80005d02 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d1c:	2985                	addiw	s3,s3,1
    80005d1e:	013a07b3          	add	a5,s4,s3
    80005d22:	0007c783          	lbu	a5,0(a5)
    80005d26:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d2a:	cbed                	beqz	a5,80005e1c <printf+0x1ac>
    switch(c){
    80005d2c:	05778a63          	beq	a5,s7,80005d80 <printf+0x110>
    80005d30:	02fbf663          	bgeu	s7,a5,80005d5c <printf+0xec>
    80005d34:	09978863          	beq	a5,s9,80005dc4 <printf+0x154>
    80005d38:	07800713          	li	a4,120
    80005d3c:	0ce79563          	bne	a5,a4,80005e06 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d40:	f8843783          	ld	a5,-120(s0)
    80005d44:	00878713          	addi	a4,a5,8
    80005d48:	f8e43423          	sd	a4,-120(s0)
    80005d4c:	4605                	li	a2,1
    80005d4e:	85ea                	mv	a1,s10
    80005d50:	4388                	lw	a0,0(a5)
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	e30080e7          	jalr	-464(ra) # 80005b82 <printint>
      break;
    80005d5a:	bf45                	j	80005d0a <printf+0x9a>
    switch(c){
    80005d5c:	09578f63          	beq	a5,s5,80005dfa <printf+0x18a>
    80005d60:	0b879363          	bne	a5,s8,80005e06 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d64:	f8843783          	ld	a5,-120(s0)
    80005d68:	00878713          	addi	a4,a5,8
    80005d6c:	f8e43423          	sd	a4,-120(s0)
    80005d70:	4605                	li	a2,1
    80005d72:	45a9                	li	a1,10
    80005d74:	4388                	lw	a0,0(a5)
    80005d76:	00000097          	auipc	ra,0x0
    80005d7a:	e0c080e7          	jalr	-500(ra) # 80005b82 <printint>
      break;
    80005d7e:	b771                	j	80005d0a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d80:	f8843783          	ld	a5,-120(s0)
    80005d84:	00878713          	addi	a4,a5,8
    80005d88:	f8e43423          	sd	a4,-120(s0)
    80005d8c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d90:	03000513          	li	a0,48
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	bce080e7          	jalr	-1074(ra) # 80005962 <consputc>
  consputc('x');
    80005d9c:	07800513          	li	a0,120
    80005da0:	00000097          	auipc	ra,0x0
    80005da4:	bc2080e7          	jalr	-1086(ra) # 80005962 <consputc>
    80005da8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005daa:	03c95793          	srli	a5,s2,0x3c
    80005dae:	97da                	add	a5,a5,s6
    80005db0:	0007c503          	lbu	a0,0(a5)
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	bae080e7          	jalr	-1106(ra) # 80005962 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dbc:	0912                	slli	s2,s2,0x4
    80005dbe:	34fd                	addiw	s1,s1,-1
    80005dc0:	f4ed                	bnez	s1,80005daa <printf+0x13a>
    80005dc2:	b7a1                	j	80005d0a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005dc4:	f8843783          	ld	a5,-120(s0)
    80005dc8:	00878713          	addi	a4,a5,8
    80005dcc:	f8e43423          	sd	a4,-120(s0)
    80005dd0:	6384                	ld	s1,0(a5)
    80005dd2:	cc89                	beqz	s1,80005dec <printf+0x17c>
      for(; *s; s++)
    80005dd4:	0004c503          	lbu	a0,0(s1)
    80005dd8:	d90d                	beqz	a0,80005d0a <printf+0x9a>
        consputc(*s);
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	b88080e7          	jalr	-1144(ra) # 80005962 <consputc>
      for(; *s; s++)
    80005de2:	0485                	addi	s1,s1,1
    80005de4:	0004c503          	lbu	a0,0(s1)
    80005de8:	f96d                	bnez	a0,80005dda <printf+0x16a>
    80005dea:	b705                	j	80005d0a <printf+0x9a>
        s = "(null)";
    80005dec:	00003497          	auipc	s1,0x3
    80005df0:	99448493          	addi	s1,s1,-1644 # 80008780 <syscalls+0x410>
      for(; *s; s++)
    80005df4:	02800513          	li	a0,40
    80005df8:	b7cd                	j	80005dda <printf+0x16a>
      consputc('%');
    80005dfa:	8556                	mv	a0,s5
    80005dfc:	00000097          	auipc	ra,0x0
    80005e00:	b66080e7          	jalr	-1178(ra) # 80005962 <consputc>
      break;
    80005e04:	b719                	j	80005d0a <printf+0x9a>
      consputc('%');
    80005e06:	8556                	mv	a0,s5
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	b5a080e7          	jalr	-1190(ra) # 80005962 <consputc>
      consputc(c);
    80005e10:	8526                	mv	a0,s1
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	b50080e7          	jalr	-1200(ra) # 80005962 <consputc>
      break;
    80005e1a:	bdc5                	j	80005d0a <printf+0x9a>
  if(locking)
    80005e1c:	020d9163          	bnez	s11,80005e3e <printf+0x1ce>
}
    80005e20:	70e6                	ld	ra,120(sp)
    80005e22:	7446                	ld	s0,112(sp)
    80005e24:	74a6                	ld	s1,104(sp)
    80005e26:	7906                	ld	s2,96(sp)
    80005e28:	69e6                	ld	s3,88(sp)
    80005e2a:	6a46                	ld	s4,80(sp)
    80005e2c:	6aa6                	ld	s5,72(sp)
    80005e2e:	6b06                	ld	s6,64(sp)
    80005e30:	7be2                	ld	s7,56(sp)
    80005e32:	7c42                	ld	s8,48(sp)
    80005e34:	7ca2                	ld	s9,40(sp)
    80005e36:	7d02                	ld	s10,32(sp)
    80005e38:	6de2                	ld	s11,24(sp)
    80005e3a:	6129                	addi	sp,sp,192
    80005e3c:	8082                	ret
    release(&pr.lock);
    80005e3e:	0001c517          	auipc	a0,0x1c
    80005e42:	e4a50513          	addi	a0,a0,-438 # 80021c88 <pr>
    80005e46:	00000097          	auipc	ra,0x0
    80005e4a:	3cc080e7          	jalr	972(ra) # 80006212 <release>
}
    80005e4e:	bfc9                	j	80005e20 <printf+0x1b0>

0000000080005e50 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e50:	1101                	addi	sp,sp,-32
    80005e52:	ec06                	sd	ra,24(sp)
    80005e54:	e822                	sd	s0,16(sp)
    80005e56:	e426                	sd	s1,8(sp)
    80005e58:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e5a:	0001c497          	auipc	s1,0x1c
    80005e5e:	e2e48493          	addi	s1,s1,-466 # 80021c88 <pr>
    80005e62:	00003597          	auipc	a1,0x3
    80005e66:	93658593          	addi	a1,a1,-1738 # 80008798 <syscalls+0x428>
    80005e6a:	8526                	mv	a0,s1
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	262080e7          	jalr	610(ra) # 800060ce <initlock>
  pr.locking = 1;
    80005e74:	4785                	li	a5,1
    80005e76:	cc9c                	sw	a5,24(s1)
}
    80005e78:	60e2                	ld	ra,24(sp)
    80005e7a:	6442                	ld	s0,16(sp)
    80005e7c:	64a2                	ld	s1,8(sp)
    80005e7e:	6105                	addi	sp,sp,32
    80005e80:	8082                	ret

0000000080005e82 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e82:	1141                	addi	sp,sp,-16
    80005e84:	e406                	sd	ra,8(sp)
    80005e86:	e022                	sd	s0,0(sp)
    80005e88:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e8a:	100007b7          	lui	a5,0x10000
    80005e8e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e92:	f8000713          	li	a4,-128
    80005e96:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e9a:	470d                	li	a4,3
    80005e9c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ea0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ea4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ea8:	469d                	li	a3,7
    80005eaa:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005eae:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005eb2:	00003597          	auipc	a1,0x3
    80005eb6:	90658593          	addi	a1,a1,-1786 # 800087b8 <digits+0x18>
    80005eba:	0001c517          	auipc	a0,0x1c
    80005ebe:	dee50513          	addi	a0,a0,-530 # 80021ca8 <uart_tx_lock>
    80005ec2:	00000097          	auipc	ra,0x0
    80005ec6:	20c080e7          	jalr	524(ra) # 800060ce <initlock>
}
    80005eca:	60a2                	ld	ra,8(sp)
    80005ecc:	6402                	ld	s0,0(sp)
    80005ece:	0141                	addi	sp,sp,16
    80005ed0:	8082                	ret

0000000080005ed2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ed2:	1101                	addi	sp,sp,-32
    80005ed4:	ec06                	sd	ra,24(sp)
    80005ed6:	e822                	sd	s0,16(sp)
    80005ed8:	e426                	sd	s1,8(sp)
    80005eda:	1000                	addi	s0,sp,32
    80005edc:	84aa                	mv	s1,a0
  push_off();
    80005ede:	00000097          	auipc	ra,0x0
    80005ee2:	234080e7          	jalr	564(ra) # 80006112 <push_off>

  if(panicked){
    80005ee6:	00003797          	auipc	a5,0x3
    80005eea:	9767a783          	lw	a5,-1674(a5) # 8000885c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005eee:	10000737          	lui	a4,0x10000
  if(panicked){
    80005ef2:	c391                	beqz	a5,80005ef6 <uartputc_sync+0x24>
    for(;;)
    80005ef4:	a001                	j	80005ef4 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ef6:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005efa:	0207f793          	andi	a5,a5,32
    80005efe:	dfe5                	beqz	a5,80005ef6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f00:	0ff4f513          	zext.b	a0,s1
    80005f04:	100007b7          	lui	a5,0x10000
    80005f08:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f0c:	00000097          	auipc	ra,0x0
    80005f10:	2a6080e7          	jalr	678(ra) # 800061b2 <pop_off>
}
    80005f14:	60e2                	ld	ra,24(sp)
    80005f16:	6442                	ld	s0,16(sp)
    80005f18:	64a2                	ld	s1,8(sp)
    80005f1a:	6105                	addi	sp,sp,32
    80005f1c:	8082                	ret

0000000080005f1e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f1e:	00003797          	auipc	a5,0x3
    80005f22:	9427b783          	ld	a5,-1726(a5) # 80008860 <uart_tx_r>
    80005f26:	00003717          	auipc	a4,0x3
    80005f2a:	94273703          	ld	a4,-1726(a4) # 80008868 <uart_tx_w>
    80005f2e:	06f70a63          	beq	a4,a5,80005fa2 <uartstart+0x84>
{
    80005f32:	7139                	addi	sp,sp,-64
    80005f34:	fc06                	sd	ra,56(sp)
    80005f36:	f822                	sd	s0,48(sp)
    80005f38:	f426                	sd	s1,40(sp)
    80005f3a:	f04a                	sd	s2,32(sp)
    80005f3c:	ec4e                	sd	s3,24(sp)
    80005f3e:	e852                	sd	s4,16(sp)
    80005f40:	e456                	sd	s5,8(sp)
    80005f42:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f44:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f48:	0001ca17          	auipc	s4,0x1c
    80005f4c:	d60a0a13          	addi	s4,s4,-672 # 80021ca8 <uart_tx_lock>
    uart_tx_r += 1;
    80005f50:	00003497          	auipc	s1,0x3
    80005f54:	91048493          	addi	s1,s1,-1776 # 80008860 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f58:	00003997          	auipc	s3,0x3
    80005f5c:	91098993          	addi	s3,s3,-1776 # 80008868 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f60:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f64:	02077713          	andi	a4,a4,32
    80005f68:	c705                	beqz	a4,80005f90 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f6a:	01f7f713          	andi	a4,a5,31
    80005f6e:	9752                	add	a4,a4,s4
    80005f70:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f74:	0785                	addi	a5,a5,1
    80005f76:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f78:	8526                	mv	a0,s1
    80005f7a:	ffffb097          	auipc	ra,0xffffb
    80005f7e:	66e080e7          	jalr	1646(ra) # 800015e8 <wakeup>
    
    WriteReg(THR, c);
    80005f82:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f86:	609c                	ld	a5,0(s1)
    80005f88:	0009b703          	ld	a4,0(s3)
    80005f8c:	fcf71ae3          	bne	a4,a5,80005f60 <uartstart+0x42>
  }
}
    80005f90:	70e2                	ld	ra,56(sp)
    80005f92:	7442                	ld	s0,48(sp)
    80005f94:	74a2                	ld	s1,40(sp)
    80005f96:	7902                	ld	s2,32(sp)
    80005f98:	69e2                	ld	s3,24(sp)
    80005f9a:	6a42                	ld	s4,16(sp)
    80005f9c:	6aa2                	ld	s5,8(sp)
    80005f9e:	6121                	addi	sp,sp,64
    80005fa0:	8082                	ret
    80005fa2:	8082                	ret

0000000080005fa4 <uartputc>:
{
    80005fa4:	7179                	addi	sp,sp,-48
    80005fa6:	f406                	sd	ra,40(sp)
    80005fa8:	f022                	sd	s0,32(sp)
    80005faa:	ec26                	sd	s1,24(sp)
    80005fac:	e84a                	sd	s2,16(sp)
    80005fae:	e44e                	sd	s3,8(sp)
    80005fb0:	e052                	sd	s4,0(sp)
    80005fb2:	1800                	addi	s0,sp,48
    80005fb4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005fb6:	0001c517          	auipc	a0,0x1c
    80005fba:	cf250513          	addi	a0,a0,-782 # 80021ca8 <uart_tx_lock>
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	1a0080e7          	jalr	416(ra) # 8000615e <acquire>
  if(panicked){
    80005fc6:	00003797          	auipc	a5,0x3
    80005fca:	8967a783          	lw	a5,-1898(a5) # 8000885c <panicked>
    80005fce:	e7c9                	bnez	a5,80006058 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fd0:	00003717          	auipc	a4,0x3
    80005fd4:	89873703          	ld	a4,-1896(a4) # 80008868 <uart_tx_w>
    80005fd8:	00003797          	auipc	a5,0x3
    80005fdc:	8887b783          	ld	a5,-1912(a5) # 80008860 <uart_tx_r>
    80005fe0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005fe4:	0001c997          	auipc	s3,0x1c
    80005fe8:	cc498993          	addi	s3,s3,-828 # 80021ca8 <uart_tx_lock>
    80005fec:	00003497          	auipc	s1,0x3
    80005ff0:	87448493          	addi	s1,s1,-1932 # 80008860 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ff4:	00003917          	auipc	s2,0x3
    80005ff8:	87490913          	addi	s2,s2,-1932 # 80008868 <uart_tx_w>
    80005ffc:	00e79f63          	bne	a5,a4,8000601a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006000:	85ce                	mv	a1,s3
    80006002:	8526                	mv	a0,s1
    80006004:	ffffb097          	auipc	ra,0xffffb
    80006008:	580080e7          	jalr	1408(ra) # 80001584 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000600c:	00093703          	ld	a4,0(s2)
    80006010:	609c                	ld	a5,0(s1)
    80006012:	02078793          	addi	a5,a5,32
    80006016:	fee785e3          	beq	a5,a4,80006000 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000601a:	0001c497          	auipc	s1,0x1c
    8000601e:	c8e48493          	addi	s1,s1,-882 # 80021ca8 <uart_tx_lock>
    80006022:	01f77793          	andi	a5,a4,31
    80006026:	97a6                	add	a5,a5,s1
    80006028:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000602c:	0705                	addi	a4,a4,1
    8000602e:	00003797          	auipc	a5,0x3
    80006032:	82e7bd23          	sd	a4,-1990(a5) # 80008868 <uart_tx_w>
  uartstart();
    80006036:	00000097          	auipc	ra,0x0
    8000603a:	ee8080e7          	jalr	-280(ra) # 80005f1e <uartstart>
  release(&uart_tx_lock);
    8000603e:	8526                	mv	a0,s1
    80006040:	00000097          	auipc	ra,0x0
    80006044:	1d2080e7          	jalr	466(ra) # 80006212 <release>
}
    80006048:	70a2                	ld	ra,40(sp)
    8000604a:	7402                	ld	s0,32(sp)
    8000604c:	64e2                	ld	s1,24(sp)
    8000604e:	6942                	ld	s2,16(sp)
    80006050:	69a2                	ld	s3,8(sp)
    80006052:	6a02                	ld	s4,0(sp)
    80006054:	6145                	addi	sp,sp,48
    80006056:	8082                	ret
    for(;;)
    80006058:	a001                	j	80006058 <uartputc+0xb4>

000000008000605a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000605a:	1141                	addi	sp,sp,-16
    8000605c:	e422                	sd	s0,8(sp)
    8000605e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006060:	100007b7          	lui	a5,0x10000
    80006064:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006068:	8b85                	andi	a5,a5,1
    8000606a:	cb81                	beqz	a5,8000607a <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000606c:	100007b7          	lui	a5,0x10000
    80006070:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006074:	6422                	ld	s0,8(sp)
    80006076:	0141                	addi	sp,sp,16
    80006078:	8082                	ret
    return -1;
    8000607a:	557d                	li	a0,-1
    8000607c:	bfe5                	j	80006074 <uartgetc+0x1a>

000000008000607e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000607e:	1101                	addi	sp,sp,-32
    80006080:	ec06                	sd	ra,24(sp)
    80006082:	e822                	sd	s0,16(sp)
    80006084:	e426                	sd	s1,8(sp)
    80006086:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006088:	54fd                	li	s1,-1
    8000608a:	a029                	j	80006094 <uartintr+0x16>
      break;
    consoleintr(c);
    8000608c:	00000097          	auipc	ra,0x0
    80006090:	918080e7          	jalr	-1768(ra) # 800059a4 <consoleintr>
    int c = uartgetc();
    80006094:	00000097          	auipc	ra,0x0
    80006098:	fc6080e7          	jalr	-58(ra) # 8000605a <uartgetc>
    if(c == -1)
    8000609c:	fe9518e3          	bne	a0,s1,8000608c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060a0:	0001c497          	auipc	s1,0x1c
    800060a4:	c0848493          	addi	s1,s1,-1016 # 80021ca8 <uart_tx_lock>
    800060a8:	8526                	mv	a0,s1
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	0b4080e7          	jalr	180(ra) # 8000615e <acquire>
  uartstart();
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	e6c080e7          	jalr	-404(ra) # 80005f1e <uartstart>
  release(&uart_tx_lock);
    800060ba:	8526                	mv	a0,s1
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	156080e7          	jalr	342(ra) # 80006212 <release>
}
    800060c4:	60e2                	ld	ra,24(sp)
    800060c6:	6442                	ld	s0,16(sp)
    800060c8:	64a2                	ld	s1,8(sp)
    800060ca:	6105                	addi	sp,sp,32
    800060cc:	8082                	ret

00000000800060ce <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060ce:	1141                	addi	sp,sp,-16
    800060d0:	e422                	sd	s0,8(sp)
    800060d2:	0800                	addi	s0,sp,16
  lk->name = name;
    800060d4:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060d6:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060da:	00053823          	sd	zero,16(a0)
}
    800060de:	6422                	ld	s0,8(sp)
    800060e0:	0141                	addi	sp,sp,16
    800060e2:	8082                	ret

00000000800060e4 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060e4:	411c                	lw	a5,0(a0)
    800060e6:	e399                	bnez	a5,800060ec <holding+0x8>
    800060e8:	4501                	li	a0,0
  return r;
}
    800060ea:	8082                	ret
{
    800060ec:	1101                	addi	sp,sp,-32
    800060ee:	ec06                	sd	ra,24(sp)
    800060f0:	e822                	sd	s0,16(sp)
    800060f2:	e426                	sd	s1,8(sp)
    800060f4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800060f6:	6904                	ld	s1,16(a0)
    800060f8:	ffffb097          	auipc	ra,0xffffb
    800060fc:	dc8080e7          	jalr	-568(ra) # 80000ec0 <mycpu>
    80006100:	40a48533          	sub	a0,s1,a0
    80006104:	00153513          	seqz	a0,a0
}
    80006108:	60e2                	ld	ra,24(sp)
    8000610a:	6442                	ld	s0,16(sp)
    8000610c:	64a2                	ld	s1,8(sp)
    8000610e:	6105                	addi	sp,sp,32
    80006110:	8082                	ret

0000000080006112 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006112:	1101                	addi	sp,sp,-32
    80006114:	ec06                	sd	ra,24(sp)
    80006116:	e822                	sd	s0,16(sp)
    80006118:	e426                	sd	s1,8(sp)
    8000611a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000611c:	100024f3          	csrr	s1,sstatus
    80006120:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006124:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006126:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	d96080e7          	jalr	-618(ra) # 80000ec0 <mycpu>
    80006132:	5d3c                	lw	a5,120(a0)
    80006134:	cf89                	beqz	a5,8000614e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006136:	ffffb097          	auipc	ra,0xffffb
    8000613a:	d8a080e7          	jalr	-630(ra) # 80000ec0 <mycpu>
    8000613e:	5d3c                	lw	a5,120(a0)
    80006140:	2785                	addiw	a5,a5,1
    80006142:	dd3c                	sw	a5,120(a0)
}
    80006144:	60e2                	ld	ra,24(sp)
    80006146:	6442                	ld	s0,16(sp)
    80006148:	64a2                	ld	s1,8(sp)
    8000614a:	6105                	addi	sp,sp,32
    8000614c:	8082                	ret
    mycpu()->intena = old;
    8000614e:	ffffb097          	auipc	ra,0xffffb
    80006152:	d72080e7          	jalr	-654(ra) # 80000ec0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006156:	8085                	srli	s1,s1,0x1
    80006158:	8885                	andi	s1,s1,1
    8000615a:	dd64                	sw	s1,124(a0)
    8000615c:	bfe9                	j	80006136 <push_off+0x24>

000000008000615e <acquire>:
{
    8000615e:	1101                	addi	sp,sp,-32
    80006160:	ec06                	sd	ra,24(sp)
    80006162:	e822                	sd	s0,16(sp)
    80006164:	e426                	sd	s1,8(sp)
    80006166:	1000                	addi	s0,sp,32
    80006168:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000616a:	00000097          	auipc	ra,0x0
    8000616e:	fa8080e7          	jalr	-88(ra) # 80006112 <push_off>
  if(holding(lk))
    80006172:	8526                	mv	a0,s1
    80006174:	00000097          	auipc	ra,0x0
    80006178:	f70080e7          	jalr	-144(ra) # 800060e4 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000617c:	4705                	li	a4,1
  if(holding(lk))
    8000617e:	e115                	bnez	a0,800061a2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006180:	87ba                	mv	a5,a4
    80006182:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006186:	2781                	sext.w	a5,a5
    80006188:	ffe5                	bnez	a5,80006180 <acquire+0x22>
  __sync_synchronize();
    8000618a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000618e:	ffffb097          	auipc	ra,0xffffb
    80006192:	d32080e7          	jalr	-718(ra) # 80000ec0 <mycpu>
    80006196:	e888                	sd	a0,16(s1)
}
    80006198:	60e2                	ld	ra,24(sp)
    8000619a:	6442                	ld	s0,16(sp)
    8000619c:	64a2                	ld	s1,8(sp)
    8000619e:	6105                	addi	sp,sp,32
    800061a0:	8082                	ret
    panic("acquire");
    800061a2:	00002517          	auipc	a0,0x2
    800061a6:	61e50513          	addi	a0,a0,1566 # 800087c0 <digits+0x20>
    800061aa:	00000097          	auipc	ra,0x0
    800061ae:	a7c080e7          	jalr	-1412(ra) # 80005c26 <panic>

00000000800061b2 <pop_off>:

void
pop_off(void)
{
    800061b2:	1141                	addi	sp,sp,-16
    800061b4:	e406                	sd	ra,8(sp)
    800061b6:	e022                	sd	s0,0(sp)
    800061b8:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061ba:	ffffb097          	auipc	ra,0xffffb
    800061be:	d06080e7          	jalr	-762(ra) # 80000ec0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061c2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061c6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061c8:	e78d                	bnez	a5,800061f2 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061ca:	5d3c                	lw	a5,120(a0)
    800061cc:	02f05b63          	blez	a5,80006202 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061d0:	37fd                	addiw	a5,a5,-1
    800061d2:	0007871b          	sext.w	a4,a5
    800061d6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061d8:	eb09                	bnez	a4,800061ea <pop_off+0x38>
    800061da:	5d7c                	lw	a5,124(a0)
    800061dc:	c799                	beqz	a5,800061ea <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061e2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061e6:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061ea:	60a2                	ld	ra,8(sp)
    800061ec:	6402                	ld	s0,0(sp)
    800061ee:	0141                	addi	sp,sp,16
    800061f0:	8082                	ret
    panic("pop_off - interruptible");
    800061f2:	00002517          	auipc	a0,0x2
    800061f6:	5d650513          	addi	a0,a0,1494 # 800087c8 <digits+0x28>
    800061fa:	00000097          	auipc	ra,0x0
    800061fe:	a2c080e7          	jalr	-1492(ra) # 80005c26 <panic>
    panic("pop_off");
    80006202:	00002517          	auipc	a0,0x2
    80006206:	5de50513          	addi	a0,a0,1502 # 800087e0 <digits+0x40>
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	a1c080e7          	jalr	-1508(ra) # 80005c26 <panic>

0000000080006212 <release>:
{
    80006212:	1101                	addi	sp,sp,-32
    80006214:	ec06                	sd	ra,24(sp)
    80006216:	e822                	sd	s0,16(sp)
    80006218:	e426                	sd	s1,8(sp)
    8000621a:	1000                	addi	s0,sp,32
    8000621c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	ec6080e7          	jalr	-314(ra) # 800060e4 <holding>
    80006226:	c115                	beqz	a0,8000624a <release+0x38>
  lk->cpu = 0;
    80006228:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000622c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006230:	0f50000f          	fence	iorw,ow
    80006234:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	f7a080e7          	jalr	-134(ra) # 800061b2 <pop_off>
}
    80006240:	60e2                	ld	ra,24(sp)
    80006242:	6442                	ld	s0,16(sp)
    80006244:	64a2                	ld	s1,8(sp)
    80006246:	6105                	addi	sp,sp,32
    80006248:	8082                	ret
    panic("release");
    8000624a:	00002517          	auipc	a0,0x2
    8000624e:	59e50513          	addi	a0,a0,1438 # 800087e8 <digits+0x48>
    80006252:	00000097          	auipc	ra,0x0
    80006256:	9d4080e7          	jalr	-1580(ra) # 80005c26 <panic>
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
