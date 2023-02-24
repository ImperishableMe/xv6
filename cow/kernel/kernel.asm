
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0023a117          	auipc	sp,0x23a
    80000004:	ca010113          	addi	sp,sp,-864 # 80239ca0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0b1050ef          	jal	ra,800058c6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <incref>:
  initlock(&kmem.lock, "kmem");
  freerange(end, (void *)PHYSTOP);
}

void incref(uint64 pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	1000                	addi	s0,sp,32
    80000026:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    80000028:	00009517          	auipc	a0,0x9
    8000002c:	90850513          	addi	a0,a0,-1784 # 80008930 <kmem>
    80000030:	00006097          	auipc	ra,0x6
    80000034:	27e080e7          	jalr	638(ra) # 800062ae <acquire>
  uint64 pn = pa / PGSIZE;
    80000038:	00c4d513          	srli	a0,s1,0xc
  if (refcount[pn] == 0)
    8000003c:	00251713          	slli	a4,a0,0x2
    80000040:	00009797          	auipc	a5,0x9
    80000044:	91078793          	addi	a5,a5,-1776 # 80008950 <refcount>
    80000048:	97ba                	add	a5,a5,a4
    8000004a:	439c                	lw	a5,0(a5)
    8000004c:	c795                	beqz	a5,80000078 <incref+0x5c>
  {
    panic("incref: zero");
  }
  refcount[pn] += 1;
    8000004e:	050a                	slli	a0,a0,0x2
    80000050:	00009717          	auipc	a4,0x9
    80000054:	90070713          	addi	a4,a4,-1792 # 80008950 <refcount>
    80000058:	972a                	add	a4,a4,a0
    8000005a:	2785                	addiw	a5,a5,1
    8000005c:	c31c                	sw	a5,0(a4)
  release(&kmem.lock);
    8000005e:	00009517          	auipc	a0,0x9
    80000062:	8d250513          	addi	a0,a0,-1838 # 80008930 <kmem>
    80000066:	00006097          	auipc	ra,0x6
    8000006a:	2fc080e7          	jalr	764(ra) # 80006362 <release>
}
    8000006e:	60e2                	ld	ra,24(sp)
    80000070:	6442                	ld	s0,16(sp)
    80000072:	64a2                	ld	s1,8(sp)
    80000074:	6105                	addi	sp,sp,32
    80000076:	8082                	ret
    panic("incref: zero");
    80000078:	00008517          	auipc	a0,0x8
    8000007c:	f9850513          	addi	a0,a0,-104 # 80008010 <etext+0x10>
    80000080:	00006097          	auipc	ra,0x6
    80000084:	cf6080e7          	jalr	-778(ra) # 80005d76 <panic>

0000000080000088 <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000088:	7179                	addi	sp,sp,-48
    8000008a:	f406                	sd	ra,40(sp)
    8000008c:	f022                	sd	s0,32(sp)
    8000008e:	ec26                	sd	s1,24(sp)
    80000090:	e84a                	sd	s2,16(sp)
    80000092:	e44e                	sd	s3,8(sp)
    80000094:	1800                	addi	s0,sp,48
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000096:	03451793          	slli	a5,a0,0x34
    8000009a:	ebad                	bnez	a5,8000010c <kfree+0x84>
    8000009c:	84aa                	mv	s1,a0
    8000009e:	00242797          	auipc	a5,0x242
    800000a2:	d0278793          	addi	a5,a5,-766 # 80241da0 <end>
    800000a6:	06f56363          	bltu	a0,a5,8000010c <kfree+0x84>
    800000aa:	47c5                	li	a5,17
    800000ac:	07ee                	slli	a5,a5,0x1b
    800000ae:	04f57f63          	bgeu	a0,a5,8000010c <kfree+0x84>
    panic("kfree");

  uint64 pn = (uint64)pa / PGSIZE;
    800000b2:	00c55913          	srli	s2,a0,0xc
  if (refcount[pn] == 0)
    800000b6:	00291713          	slli	a4,s2,0x2
    800000ba:	00009797          	auipc	a5,0x9
    800000be:	89678793          	addi	a5,a5,-1898 # 80008950 <refcount>
    800000c2:	97ba                	add	a5,a5,a4
    800000c4:	439c                	lw	a5,0(a5)
    800000c6:	cbb9                	beqz	a5,8000011c <kfree+0x94>
  {
    panic("kfree: zero");
  }
  int cnt;
  acquire(&kmem.lock);
    800000c8:	00009997          	auipc	s3,0x9
    800000cc:	86898993          	addi	s3,s3,-1944 # 80008930 <kmem>
    800000d0:	854e                	mv	a0,s3
    800000d2:	00006097          	auipc	ra,0x6
    800000d6:	1dc080e7          	jalr	476(ra) # 800062ae <acquire>
  cnt = (--refcount[pn]);
    800000da:	090a                	slli	s2,s2,0x2
    800000dc:	00009797          	auipc	a5,0x9
    800000e0:	87478793          	addi	a5,a5,-1932 # 80008950 <refcount>
    800000e4:	97ca                	add	a5,a5,s2
    800000e6:	4398                	lw	a4,0(a5)
    800000e8:	377d                	addiw	a4,a4,-1
    800000ea:	0007091b          	sext.w	s2,a4
    800000ee:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    800000f0:	854e                	mv	a0,s3
    800000f2:	00006097          	auipc	ra,0x6
    800000f6:	270080e7          	jalr	624(ra) # 80006362 <release>

  if (cnt > 0)
    800000fa:	03205963          	blez	s2,8000012c <kfree+0xa4>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    800000fe:	70a2                	ld	ra,40(sp)
    80000100:	7402                	ld	s0,32(sp)
    80000102:	64e2                	ld	s1,24(sp)
    80000104:	6942                	ld	s2,16(sp)
    80000106:	69a2                	ld	s3,8(sp)
    80000108:	6145                	addi	sp,sp,48
    8000010a:	8082                	ret
    panic("kfree");
    8000010c:	00008517          	auipc	a0,0x8
    80000110:	f1450513          	addi	a0,a0,-236 # 80008020 <etext+0x20>
    80000114:	00006097          	auipc	ra,0x6
    80000118:	c62080e7          	jalr	-926(ra) # 80005d76 <panic>
    panic("kfree: zero");
    8000011c:	00008517          	auipc	a0,0x8
    80000120:	f0c50513          	addi	a0,a0,-244 # 80008028 <etext+0x28>
    80000124:	00006097          	auipc	ra,0x6
    80000128:	c52080e7          	jalr	-942(ra) # 80005d76 <panic>
  memset(pa, 1, PGSIZE);
    8000012c:	6605                	lui	a2,0x1
    8000012e:	4585                	li	a1,1
    80000130:	8526                	mv	a0,s1
    80000132:	00000097          	auipc	ra,0x0
    80000136:	168080e7          	jalr	360(ra) # 8000029a <memset>
  acquire(&kmem.lock);
    8000013a:	854e                	mv	a0,s3
    8000013c:	00006097          	auipc	ra,0x6
    80000140:	172080e7          	jalr	370(ra) # 800062ae <acquire>
  r->next = kmem.freelist;
    80000144:	0189b783          	ld	a5,24(s3)
    80000148:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    8000014a:	0099bc23          	sd	s1,24(s3)
  release(&kmem.lock);
    8000014e:	854e                	mv	a0,s3
    80000150:	00006097          	auipc	ra,0x6
    80000154:	212080e7          	jalr	530(ra) # 80006362 <release>
    80000158:	b75d                	j	800000fe <kfree+0x76>

000000008000015a <freerange>:
{
    8000015a:	7139                	addi	sp,sp,-64
    8000015c:	fc06                	sd	ra,56(sp)
    8000015e:	f822                	sd	s0,48(sp)
    80000160:	f426                	sd	s1,40(sp)
    80000162:	f04a                	sd	s2,32(sp)
    80000164:	ec4e                	sd	s3,24(sp)
    80000166:	e852                	sd	s4,16(sp)
    80000168:	e456                	sd	s5,8(sp)
    8000016a:	e05a                	sd	s6,0(sp)
    8000016c:	0080                	addi	s0,sp,64
  p = (char *)PGROUNDUP((uint64)pa_start);
    8000016e:	6785                	lui	a5,0x1
    80000170:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000174:	953a                	add	a0,a0,a4
    80000176:	777d                	lui	a4,0xfffff
    80000178:	00e574b3          	and	s1,a0,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    8000017c:	97a6                	add	a5,a5,s1
    8000017e:	02f5ea63          	bltu	a1,a5,800001b2 <freerange+0x58>
    80000182:	892e                	mv	s2,a1
    refcount[(uint64)p / PGSIZE] = 1;
    80000184:	00008b17          	auipc	s6,0x8
    80000188:	7ccb0b13          	addi	s6,s6,1996 # 80008950 <refcount>
    8000018c:	4a85                	li	s5,1
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    8000018e:	6a05                	lui	s4,0x1
    80000190:	6989                	lui	s3,0x2
    refcount[(uint64)p / PGSIZE] = 1;
    80000192:	00c4d793          	srli	a5,s1,0xc
    80000196:	078a                	slli	a5,a5,0x2
    80000198:	97da                	add	a5,a5,s6
    8000019a:	0157a023          	sw	s5,0(a5)
    kfree(p);
    8000019e:	8526                	mv	a0,s1
    800001a0:	00000097          	auipc	ra,0x0
    800001a4:	ee8080e7          	jalr	-280(ra) # 80000088 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800001a8:	87a6                	mv	a5,s1
    800001aa:	94d2                	add	s1,s1,s4
    800001ac:	97ce                	add	a5,a5,s3
    800001ae:	fef972e3          	bgeu	s2,a5,80000192 <freerange+0x38>
}
    800001b2:	70e2                	ld	ra,56(sp)
    800001b4:	7442                	ld	s0,48(sp)
    800001b6:	74a2                	ld	s1,40(sp)
    800001b8:	7902                	ld	s2,32(sp)
    800001ba:	69e2                	ld	s3,24(sp)
    800001bc:	6a42                	ld	s4,16(sp)
    800001be:	6aa2                	ld	s5,8(sp)
    800001c0:	6b02                	ld	s6,0(sp)
    800001c2:	6121                	addi	sp,sp,64
    800001c4:	8082                	ret

00000000800001c6 <kinit>:
{
    800001c6:	1141                	addi	sp,sp,-16
    800001c8:	e406                	sd	ra,8(sp)
    800001ca:	e022                	sd	s0,0(sp)
    800001cc:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800001ce:	00008597          	auipc	a1,0x8
    800001d2:	e6a58593          	addi	a1,a1,-406 # 80008038 <etext+0x38>
    800001d6:	00008517          	auipc	a0,0x8
    800001da:	75a50513          	addi	a0,a0,1882 # 80008930 <kmem>
    800001de:	00006097          	auipc	ra,0x6
    800001e2:	040080e7          	jalr	64(ra) # 8000621e <initlock>
  freerange(end, (void *)PHYSTOP);
    800001e6:	45c5                	li	a1,17
    800001e8:	05ee                	slli	a1,a1,0x1b
    800001ea:	00242517          	auipc	a0,0x242
    800001ee:	bb650513          	addi	a0,a0,-1098 # 80241da0 <end>
    800001f2:	00000097          	auipc	ra,0x0
    800001f6:	f68080e7          	jalr	-152(ra) # 8000015a <freerange>
}
    800001fa:	60a2                	ld	ra,8(sp)
    800001fc:	6402                	ld	s0,0(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret

0000000080000202 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000202:	1101                	addi	sp,sp,-32
    80000204:	ec06                	sd	ra,24(sp)
    80000206:	e822                	sd	s0,16(sp)
    80000208:	e426                	sd	s1,8(sp)
    8000020a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000020c:	00008497          	auipc	s1,0x8
    80000210:	72448493          	addi	s1,s1,1828 # 80008930 <kmem>
    80000214:	8526                	mv	a0,s1
    80000216:	00006097          	auipc	ra,0x6
    8000021a:	098080e7          	jalr	152(ra) # 800062ae <acquire>
  r = kmem.freelist;
    8000021e:	6c84                	ld	s1,24(s1)
  uint64 pn = (uint64)r / PGSIZE;
  if (r)
    80000220:	c4a5                	beqz	s1,80000288 <kalloc+0x86>
    80000222:	00c4d793          	srli	a5,s1,0xc
  {
    if (refcount[pn] > 0)
    80000226:	00279693          	slli	a3,a5,0x2
    8000022a:	00008717          	auipc	a4,0x8
    8000022e:	72670713          	addi	a4,a4,1830 # 80008950 <refcount>
    80000232:	9736                	add	a4,a4,a3
    80000234:	4318                	lw	a4,0(a4)
    80000236:	04e04163          	bgtz	a4,80000278 <kalloc+0x76>
    {
      panic("kalloc: non-zero");
    }
    refcount[pn] = 1;
    8000023a:	078a                	slli	a5,a5,0x2
    8000023c:	00008717          	auipc	a4,0x8
    80000240:	71470713          	addi	a4,a4,1812 # 80008950 <refcount>
    80000244:	97ba                	add	a5,a5,a4
    80000246:	4705                	li	a4,1
    80000248:	c398                	sw	a4,0(a5)
    kmem.freelist = r->next;
    8000024a:	609c                	ld	a5,0(s1)
    8000024c:	00008517          	auipc	a0,0x8
    80000250:	6e450513          	addi	a0,a0,1764 # 80008930 <kmem>
    80000254:	ed1c                	sd	a5,24(a0)
  }
  release(&kmem.lock);
    80000256:	00006097          	auipc	ra,0x6
    8000025a:	10c080e7          	jalr	268(ra) # 80006362 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    8000025e:	6605                	lui	a2,0x1
    80000260:	4595                	li	a1,5
    80000262:	8526                	mv	a0,s1
    80000264:	00000097          	auipc	ra,0x0
    80000268:	036080e7          	jalr	54(ra) # 8000029a <memset>
  return (void *)r;
}
    8000026c:	8526                	mv	a0,s1
    8000026e:	60e2                	ld	ra,24(sp)
    80000270:	6442                	ld	s0,16(sp)
    80000272:	64a2                	ld	s1,8(sp)
    80000274:	6105                	addi	sp,sp,32
    80000276:	8082                	ret
      panic("kalloc: non-zero");
    80000278:	00008517          	auipc	a0,0x8
    8000027c:	dc850513          	addi	a0,a0,-568 # 80008040 <etext+0x40>
    80000280:	00006097          	auipc	ra,0x6
    80000284:	af6080e7          	jalr	-1290(ra) # 80005d76 <panic>
  release(&kmem.lock);
    80000288:	00008517          	auipc	a0,0x8
    8000028c:	6a850513          	addi	a0,a0,1704 # 80008930 <kmem>
    80000290:	00006097          	auipc	ra,0x6
    80000294:	0d2080e7          	jalr	210(ra) # 80006362 <release>
  if (r)
    80000298:	bfd1                	j	8000026c <kalloc+0x6a>

000000008000029a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002a0:	ca19                	beqz	a2,800002b6 <memset+0x1c>
    800002a2:	87aa                	mv	a5,a0
    800002a4:	1602                	slli	a2,a2,0x20
    800002a6:	9201                	srli	a2,a2,0x20
    800002a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002b0:	0785                	addi	a5,a5,1
    800002b2:	fee79de3          	bne	a5,a4,800002ac <memset+0x12>
  }
  return dst;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002c2:	ca05                	beqz	a2,800002f2 <memcmp+0x36>
    800002c4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002c8:	1682                	slli	a3,a3,0x20
    800002ca:	9281                	srli	a3,a3,0x20
    800002cc:	0685                	addi	a3,a3,1
    800002ce:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002d0:	00054783          	lbu	a5,0(a0)
    800002d4:	0005c703          	lbu	a4,0(a1)
    800002d8:	00e79863          	bne	a5,a4,800002e8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002dc:	0505                	addi	a0,a0,1
    800002de:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002e0:	fed518e3          	bne	a0,a3,800002d0 <memcmp+0x14>
  }

  return 0;
    800002e4:	4501                	li	a0,0
    800002e6:	a019                	j	800002ec <memcmp+0x30>
      return *s1 - *s2;
    800002e8:	40e7853b          	subw	a0,a5,a4
}
    800002ec:	6422                	ld	s0,8(sp)
    800002ee:	0141                	addi	sp,sp,16
    800002f0:	8082                	ret
  return 0;
    800002f2:	4501                	li	a0,0
    800002f4:	bfe5                	j	800002ec <memcmp+0x30>

00000000800002f6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002fc:	c205                	beqz	a2,8000031c <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002fe:	02a5e263          	bltu	a1,a0,80000322 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000302:	1602                	slli	a2,a2,0x20
    80000304:	9201                	srli	a2,a2,0x20
    80000306:	00c587b3          	add	a5,a1,a2
{
    8000030a:	872a                	mv	a4,a0
      *d++ = *s++;
    8000030c:	0585                	addi	a1,a1,1
    8000030e:	0705                	addi	a4,a4,1
    80000310:	fff5c683          	lbu	a3,-1(a1)
    80000314:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000318:	fef59ae3          	bne	a1,a5,8000030c <memmove+0x16>

  return dst;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  if(s < d && s + n > d){
    80000322:	02061693          	slli	a3,a2,0x20
    80000326:	9281                	srli	a3,a3,0x20
    80000328:	00d58733          	add	a4,a1,a3
    8000032c:	fce57be3          	bgeu	a0,a4,80000302 <memmove+0xc>
    d += n;
    80000330:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000332:	fff6079b          	addiw	a5,a2,-1
    80000336:	1782                	slli	a5,a5,0x20
    80000338:	9381                	srli	a5,a5,0x20
    8000033a:	fff7c793          	not	a5,a5
    8000033e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000340:	177d                	addi	a4,a4,-1
    80000342:	16fd                	addi	a3,a3,-1
    80000344:	00074603          	lbu	a2,0(a4)
    80000348:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000034c:	fee79ae3          	bne	a5,a4,80000340 <memmove+0x4a>
    80000350:	b7f1                	j	8000031c <memmove+0x26>

0000000080000352 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000352:	1141                	addi	sp,sp,-16
    80000354:	e406                	sd	ra,8(sp)
    80000356:	e022                	sd	s0,0(sp)
    80000358:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000035a:	00000097          	auipc	ra,0x0
    8000035e:	f9c080e7          	jalr	-100(ra) # 800002f6 <memmove>
}
    80000362:	60a2                	ld	ra,8(sp)
    80000364:	6402                	ld	s0,0(sp)
    80000366:	0141                	addi	sp,sp,16
    80000368:	8082                	ret

000000008000036a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000036a:	1141                	addi	sp,sp,-16
    8000036c:	e422                	sd	s0,8(sp)
    8000036e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000370:	ce11                	beqz	a2,8000038c <strncmp+0x22>
    80000372:	00054783          	lbu	a5,0(a0)
    80000376:	cf89                	beqz	a5,80000390 <strncmp+0x26>
    80000378:	0005c703          	lbu	a4,0(a1)
    8000037c:	00f71a63          	bne	a4,a5,80000390 <strncmp+0x26>
    n--, p++, q++;
    80000380:	367d                	addiw	a2,a2,-1
    80000382:	0505                	addi	a0,a0,1
    80000384:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000386:	f675                	bnez	a2,80000372 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000388:	4501                	li	a0,0
    8000038a:	a809                	j	8000039c <strncmp+0x32>
    8000038c:	4501                	li	a0,0
    8000038e:	a039                	j	8000039c <strncmp+0x32>
  if(n == 0)
    80000390:	ca09                	beqz	a2,800003a2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000392:	00054503          	lbu	a0,0(a0)
    80000396:	0005c783          	lbu	a5,0(a1)
    8000039a:	9d1d                	subw	a0,a0,a5
}
    8000039c:	6422                	ld	s0,8(sp)
    8000039e:	0141                	addi	sp,sp,16
    800003a0:	8082                	ret
    return 0;
    800003a2:	4501                	li	a0,0
    800003a4:	bfe5                	j	8000039c <strncmp+0x32>

00000000800003a6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003a6:	1141                	addi	sp,sp,-16
    800003a8:	e422                	sd	s0,8(sp)
    800003aa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003ac:	87aa                	mv	a5,a0
    800003ae:	86b2                	mv	a3,a2
    800003b0:	367d                	addiw	a2,a2,-1
    800003b2:	00d05963          	blez	a3,800003c4 <strncpy+0x1e>
    800003b6:	0785                	addi	a5,a5,1
    800003b8:	0005c703          	lbu	a4,0(a1)
    800003bc:	fee78fa3          	sb	a4,-1(a5)
    800003c0:	0585                	addi	a1,a1,1
    800003c2:	f775                	bnez	a4,800003ae <strncpy+0x8>
    ;
  while(n-- > 0)
    800003c4:	873e                	mv	a4,a5
    800003c6:	9fb5                	addw	a5,a5,a3
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00c05963          	blez	a2,800003dc <strncpy+0x36>
    *s++ = 0;
    800003ce:	0705                	addi	a4,a4,1
    800003d0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800003d4:	40e786bb          	subw	a3,a5,a4
    800003d8:	fed04be3          	bgtz	a3,800003ce <strncpy+0x28>
  return os;
}
    800003dc:	6422                	ld	s0,8(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003e2:	1141                	addi	sp,sp,-16
    800003e4:	e422                	sd	s0,8(sp)
    800003e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003e8:	02c05363          	blez	a2,8000040e <safestrcpy+0x2c>
    800003ec:	fff6069b          	addiw	a3,a2,-1
    800003f0:	1682                	slli	a3,a3,0x20
    800003f2:	9281                	srli	a3,a3,0x20
    800003f4:	96ae                	add	a3,a3,a1
    800003f6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003f8:	00d58963          	beq	a1,a3,8000040a <safestrcpy+0x28>
    800003fc:	0585                	addi	a1,a1,1
    800003fe:	0785                	addi	a5,a5,1
    80000400:	fff5c703          	lbu	a4,-1(a1)
    80000404:	fee78fa3          	sb	a4,-1(a5)
    80000408:	fb65                	bnez	a4,800003f8 <safestrcpy+0x16>
    ;
  *s = 0;
    8000040a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000040e:	6422                	ld	s0,8(sp)
    80000410:	0141                	addi	sp,sp,16
    80000412:	8082                	ret

0000000080000414 <strlen>:

int
strlen(const char *s)
{
    80000414:	1141                	addi	sp,sp,-16
    80000416:	e422                	sd	s0,8(sp)
    80000418:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000041a:	00054783          	lbu	a5,0(a0)
    8000041e:	cf91                	beqz	a5,8000043a <strlen+0x26>
    80000420:	0505                	addi	a0,a0,1
    80000422:	87aa                	mv	a5,a0
    80000424:	86be                	mv	a3,a5
    80000426:	0785                	addi	a5,a5,1
    80000428:	fff7c703          	lbu	a4,-1(a5)
    8000042c:	ff65                	bnez	a4,80000424 <strlen+0x10>
    8000042e:	40a6853b          	subw	a0,a3,a0
    80000432:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000434:	6422                	ld	s0,8(sp)
    80000436:	0141                	addi	sp,sp,16
    80000438:	8082                	ret
  for(n = 0; s[n]; n++)
    8000043a:	4501                	li	a0,0
    8000043c:	bfe5                	j	80000434 <strlen+0x20>

000000008000043e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000043e:	1141                	addi	sp,sp,-16
    80000440:	e406                	sd	ra,8(sp)
    80000442:	e022                	sd	s0,0(sp)
    80000444:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000446:	00001097          	auipc	ra,0x1
    8000044a:	c00080e7          	jalr	-1024(ra) # 80001046 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000044e:	00008717          	auipc	a4,0x8
    80000452:	4b270713          	addi	a4,a4,1202 # 80008900 <started>
  if(cpuid() == 0){
    80000456:	c139                	beqz	a0,8000049c <main+0x5e>
    while(started == 0)
    80000458:	431c                	lw	a5,0(a4)
    8000045a:	2781                	sext.w	a5,a5
    8000045c:	dff5                	beqz	a5,80000458 <main+0x1a>
      ;
    __sync_synchronize();
    8000045e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000462:	00001097          	auipc	ra,0x1
    80000466:	be4080e7          	jalr	-1052(ra) # 80001046 <cpuid>
    8000046a:	85aa                	mv	a1,a0
    8000046c:	00008517          	auipc	a0,0x8
    80000470:	c0450513          	addi	a0,a0,-1020 # 80008070 <etext+0x70>
    80000474:	00006097          	auipc	ra,0x6
    80000478:	94c080e7          	jalr	-1716(ra) # 80005dc0 <printf>
    kvminithart();    // turn on paging
    8000047c:	00000097          	auipc	ra,0x0
    80000480:	0d8080e7          	jalr	216(ra) # 80000554 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000484:	00002097          	auipc	ra,0x2
    80000488:	88c080e7          	jalr	-1908(ra) # 80001d10 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000048c:	00005097          	auipc	ra,0x5
    80000490:	df4080e7          	jalr	-524(ra) # 80005280 <plicinithart>
  }

  scheduler();        
    80000494:	00001097          	auipc	ra,0x1
    80000498:	0d4080e7          	jalr	212(ra) # 80001568 <scheduler>
    consoleinit();
    8000049c:	00005097          	auipc	ra,0x5
    800004a0:	7ea080e7          	jalr	2026(ra) # 80005c86 <consoleinit>
    printfinit();
    800004a4:	00006097          	auipc	ra,0x6
    800004a8:	afc080e7          	jalr	-1284(ra) # 80005fa0 <printfinit>
    printf("\n");
    800004ac:	00008517          	auipc	a0,0x8
    800004b0:	cf450513          	addi	a0,a0,-780 # 800081a0 <etext+0x1a0>
    800004b4:	00006097          	auipc	ra,0x6
    800004b8:	90c080e7          	jalr	-1780(ra) # 80005dc0 <printf>
    printf("xv6 kernel is booting\n");
    800004bc:	00008517          	auipc	a0,0x8
    800004c0:	b9c50513          	addi	a0,a0,-1124 # 80008058 <etext+0x58>
    800004c4:	00006097          	auipc	ra,0x6
    800004c8:	8fc080e7          	jalr	-1796(ra) # 80005dc0 <printf>
    printf("\n");
    800004cc:	00008517          	auipc	a0,0x8
    800004d0:	cd450513          	addi	a0,a0,-812 # 800081a0 <etext+0x1a0>
    800004d4:	00006097          	auipc	ra,0x6
    800004d8:	8ec080e7          	jalr	-1812(ra) # 80005dc0 <printf>
    kinit();         // physical page allocator
    800004dc:	00000097          	auipc	ra,0x0
    800004e0:	cea080e7          	jalr	-790(ra) # 800001c6 <kinit>
    kvminit();       // create kernel page table
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	326080e7          	jalr	806(ra) # 8000080a <kvminit>
    kvminithart();   // turn on paging
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	068080e7          	jalr	104(ra) # 80000554 <kvminithart>
    procinit();      // process table
    800004f4:	00001097          	auipc	ra,0x1
    800004f8:	a9e080e7          	jalr	-1378(ra) # 80000f92 <procinit>
    trapinit();      // trap vectors
    800004fc:	00001097          	auipc	ra,0x1
    80000500:	7ec080e7          	jalr	2028(ra) # 80001ce8 <trapinit>
    trapinithart();  // install kernel trap vector
    80000504:	00002097          	auipc	ra,0x2
    80000508:	80c080e7          	jalr	-2036(ra) # 80001d10 <trapinithart>
    plicinit();      // set up interrupt controller
    8000050c:	00005097          	auipc	ra,0x5
    80000510:	d5e080e7          	jalr	-674(ra) # 8000526a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000514:	00005097          	auipc	ra,0x5
    80000518:	d6c080e7          	jalr	-660(ra) # 80005280 <plicinithart>
    binit();         // buffer cache
    8000051c:	00002097          	auipc	ra,0x2
    80000520:	f6a080e7          	jalr	-150(ra) # 80002486 <binit>
    iinit();         // inode table
    80000524:	00002097          	auipc	ra,0x2
    80000528:	608080e7          	jalr	1544(ra) # 80002b2c <iinit>
    fileinit();      // file table
    8000052c:	00003097          	auipc	ra,0x3
    80000530:	57e080e7          	jalr	1406(ra) # 80003aaa <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000534:	00005097          	auipc	ra,0x5
    80000538:	e54080e7          	jalr	-428(ra) # 80005388 <virtio_disk_init>
    userinit();      // first user process
    8000053c:	00001097          	auipc	ra,0x1
    80000540:	e0e080e7          	jalr	-498(ra) # 8000134a <userinit>
    __sync_synchronize();
    80000544:	0ff0000f          	fence
    started = 1;
    80000548:	4785                	li	a5,1
    8000054a:	00008717          	auipc	a4,0x8
    8000054e:	3af72b23          	sw	a5,950(a4) # 80008900 <started>
    80000552:	b789                	j	80000494 <main+0x56>

0000000080000554 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    80000554:	1141                	addi	sp,sp,-16
    80000556:	e422                	sd	s0,8(sp)
    80000558:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000055a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000055e:	00008797          	auipc	a5,0x8
    80000562:	3aa7b783          	ld	a5,938(a5) # 80008908 <kernel_pagetable>
    80000566:	83b1                	srli	a5,a5,0xc
    80000568:	577d                	li	a4,-1
    8000056a:	177e                	slli	a4,a4,0x3f
    8000056c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0"
    8000056e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000572:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000576:	6422                	ld	s0,8(sp)
    80000578:	0141                	addi	sp,sp,16
    8000057a:	8082                	ret

000000008000057c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000057c:	7139                	addi	sp,sp,-64
    8000057e:	fc06                	sd	ra,56(sp)
    80000580:	f822                	sd	s0,48(sp)
    80000582:	f426                	sd	s1,40(sp)
    80000584:	f04a                	sd	s2,32(sp)
    80000586:	ec4e                	sd	s3,24(sp)
    80000588:	e852                	sd	s4,16(sp)
    8000058a:	e456                	sd	s5,8(sp)
    8000058c:	e05a                	sd	s6,0(sp)
    8000058e:	0080                	addi	s0,sp,64
    80000590:	84aa                	mv	s1,a0
    80000592:	89ae                	mv	s3,a1
    80000594:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80000596:	57fd                	li	a5,-1
    80000598:	83e9                	srli	a5,a5,0x1a
    8000059a:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    8000059c:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000059e:	04b7f263          	bgeu	a5,a1,800005e2 <walk+0x66>
    panic("walk");
    800005a2:	00008517          	auipc	a0,0x8
    800005a6:	ae650513          	addi	a0,a0,-1306 # 80008088 <etext+0x88>
    800005aa:	00005097          	auipc	ra,0x5
    800005ae:	7cc080e7          	jalr	1996(ra) # 80005d76 <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800005b2:	060a8663          	beqz	s5,8000061e <walk+0xa2>
    800005b6:	00000097          	auipc	ra,0x0
    800005ba:	c4c080e7          	jalr	-948(ra) # 80000202 <kalloc>
    800005be:	84aa                	mv	s1,a0
    800005c0:	c529                	beqz	a0,8000060a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005c2:	6605                	lui	a2,0x1
    800005c4:	4581                	li	a1,0
    800005c6:	00000097          	auipc	ra,0x0
    800005ca:	cd4080e7          	jalr	-812(ra) # 8000029a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005ce:	00c4d793          	srli	a5,s1,0xc
    800005d2:	07aa                	slli	a5,a5,0xa
    800005d4:	0017e793          	ori	a5,a5,1
    800005d8:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    800005dc:	3a5d                	addiw	s4,s4,-9 # ff7 <_entry-0x7ffff009>
    800005de:	036a0063          	beq	s4,s6,800005fe <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005e2:	0149d933          	srl	s2,s3,s4
    800005e6:	1ff97913          	andi	s2,s2,511
    800005ea:	090e                	slli	s2,s2,0x3
    800005ec:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    800005ee:	00093483          	ld	s1,0(s2)
    800005f2:	0014f793          	andi	a5,s1,1
    800005f6:	dfd5                	beqz	a5,800005b2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005f8:	80a9                	srli	s1,s1,0xa
    800005fa:	04b2                	slli	s1,s1,0xc
    800005fc:	b7c5                	j	800005dc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005fe:	00c9d513          	srli	a0,s3,0xc
    80000602:	1ff57513          	andi	a0,a0,511
    80000606:	050e                	slli	a0,a0,0x3
    80000608:	9526                	add	a0,a0,s1
}
    8000060a:	70e2                	ld	ra,56(sp)
    8000060c:	7442                	ld	s0,48(sp)
    8000060e:	74a2                	ld	s1,40(sp)
    80000610:	7902                	ld	s2,32(sp)
    80000612:	69e2                	ld	s3,24(sp)
    80000614:	6a42                	ld	s4,16(sp)
    80000616:	6aa2                	ld	s5,8(sp)
    80000618:	6b02                	ld	s6,0(sp)
    8000061a:	6121                	addi	sp,sp,64
    8000061c:	8082                	ret
        return 0;
    8000061e:	4501                	li	a0,0
    80000620:	b7ed                	j	8000060a <walk+0x8e>

0000000080000622 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000622:	57fd                	li	a5,-1
    80000624:	83e9                	srli	a5,a5,0x1a
    80000626:	00b7f463          	bgeu	a5,a1,8000062e <walkaddr+0xc>
    return 0;
    8000062a:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000062c:	8082                	ret
{
    8000062e:	1141                	addi	sp,sp,-16
    80000630:	e406                	sd	ra,8(sp)
    80000632:	e022                	sd	s0,0(sp)
    80000634:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000636:	4601                	li	a2,0
    80000638:	00000097          	auipc	ra,0x0
    8000063c:	f44080e7          	jalr	-188(ra) # 8000057c <walk>
  if (pte == 0)
    80000640:	c105                	beqz	a0,80000660 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    80000642:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000644:	0117f693          	andi	a3,a5,17
    80000648:	4745                	li	a4,17
    return 0;
    8000064a:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    8000064c:	00e68663          	beq	a3,a4,80000658 <walkaddr+0x36>
}
    80000650:	60a2                	ld	ra,8(sp)
    80000652:	6402                	ld	s0,0(sp)
    80000654:	0141                	addi	sp,sp,16
    80000656:	8082                	ret
  pa = PTE2PA(*pte);
    80000658:	83a9                	srli	a5,a5,0xa
    8000065a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000065e:	bfcd                	j	80000650 <walkaddr+0x2e>
    return 0;
    80000660:	4501                	li	a0,0
    80000662:	b7fd                	j	80000650 <walkaddr+0x2e>

0000000080000664 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000664:	715d                	addi	sp,sp,-80
    80000666:	e486                	sd	ra,72(sp)
    80000668:	e0a2                	sd	s0,64(sp)
    8000066a:	fc26                	sd	s1,56(sp)
    8000066c:	f84a                	sd	s2,48(sp)
    8000066e:	f44e                	sd	s3,40(sp)
    80000670:	f052                	sd	s4,32(sp)
    80000672:	ec56                	sd	s5,24(sp)
    80000674:	e85a                	sd	s6,16(sp)
    80000676:	e45e                	sd	s7,8(sp)
    80000678:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    8000067a:	c639                	beqz	a2,800006c8 <mappages+0x64>
    8000067c:	8aaa                	mv	s5,a0
    8000067e:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    80000680:	777d                	lui	a4,0xfffff
    80000682:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000686:	fff58993          	addi	s3,a1,-1
    8000068a:	99b2                	add	s3,s3,a2
    8000068c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000690:	893e                	mv	s2,a5
    80000692:	40f68a33          	sub	s4,a3,a5
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80000696:	6b85                	lui	s7,0x1
    80000698:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000069c:	4605                	li	a2,1
    8000069e:	85ca                	mv	a1,s2
    800006a0:	8556                	mv	a0,s5
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	eda080e7          	jalr	-294(ra) # 8000057c <walk>
    800006aa:	cd1d                	beqz	a0,800006e8 <mappages+0x84>
    if (*pte & PTE_V)
    800006ac:	611c                	ld	a5,0(a0)
    800006ae:	8b85                	andi	a5,a5,1
    800006b0:	e785                	bnez	a5,800006d8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006b2:	80b1                	srli	s1,s1,0xc
    800006b4:	04aa                	slli	s1,s1,0xa
    800006b6:	0164e4b3          	or	s1,s1,s6
    800006ba:	0014e493          	ori	s1,s1,1
    800006be:	e104                	sd	s1,0(a0)
    if (a == last)
    800006c0:	05390063          	beq	s2,s3,80000700 <mappages+0x9c>
    a += PGSIZE;
    800006c4:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800006c6:	bfc9                	j	80000698 <mappages+0x34>
    panic("mappages: size");
    800006c8:	00008517          	auipc	a0,0x8
    800006cc:	9c850513          	addi	a0,a0,-1592 # 80008090 <etext+0x90>
    800006d0:	00005097          	auipc	ra,0x5
    800006d4:	6a6080e7          	jalr	1702(ra) # 80005d76 <panic>
      panic("mappages: remap");
    800006d8:	00008517          	auipc	a0,0x8
    800006dc:	9c850513          	addi	a0,a0,-1592 # 800080a0 <etext+0xa0>
    800006e0:	00005097          	auipc	ra,0x5
    800006e4:	696080e7          	jalr	1686(ra) # 80005d76 <panic>
      return -1;
    800006e8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006ea:	60a6                	ld	ra,72(sp)
    800006ec:	6406                	ld	s0,64(sp)
    800006ee:	74e2                	ld	s1,56(sp)
    800006f0:	7942                	ld	s2,48(sp)
    800006f2:	79a2                	ld	s3,40(sp)
    800006f4:	7a02                	ld	s4,32(sp)
    800006f6:	6ae2                	ld	s5,24(sp)
    800006f8:	6b42                	ld	s6,16(sp)
    800006fa:	6ba2                	ld	s7,8(sp)
    800006fc:	6161                	addi	sp,sp,80
    800006fe:	8082                	ret
  return 0;
    80000700:	4501                	li	a0,0
    80000702:	b7e5                	j	800006ea <mappages+0x86>

0000000080000704 <kvmmap>:
{
    80000704:	1141                	addi	sp,sp,-16
    80000706:	e406                	sd	ra,8(sp)
    80000708:	e022                	sd	s0,0(sp)
    8000070a:	0800                	addi	s0,sp,16
    8000070c:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000070e:	86b2                	mv	a3,a2
    80000710:	863e                	mv	a2,a5
    80000712:	00000097          	auipc	ra,0x0
    80000716:	f52080e7          	jalr	-174(ra) # 80000664 <mappages>
    8000071a:	e509                	bnez	a0,80000724 <kvmmap+0x20>
}
    8000071c:	60a2                	ld	ra,8(sp)
    8000071e:	6402                	ld	s0,0(sp)
    80000720:	0141                	addi	sp,sp,16
    80000722:	8082                	ret
    panic("kvmmap");
    80000724:	00008517          	auipc	a0,0x8
    80000728:	98c50513          	addi	a0,a0,-1652 # 800080b0 <etext+0xb0>
    8000072c:	00005097          	auipc	ra,0x5
    80000730:	64a080e7          	jalr	1610(ra) # 80005d76 <panic>

0000000080000734 <kvmmake>:
{
    80000734:	1101                	addi	sp,sp,-32
    80000736:	ec06                	sd	ra,24(sp)
    80000738:	e822                	sd	s0,16(sp)
    8000073a:	e426                	sd	s1,8(sp)
    8000073c:	e04a                	sd	s2,0(sp)
    8000073e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	ac2080e7          	jalr	-1342(ra) # 80000202 <kalloc>
    80000748:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000074a:	6605                	lui	a2,0x1
    8000074c:	4581                	li	a1,0
    8000074e:	00000097          	auipc	ra,0x0
    80000752:	b4c080e7          	jalr	-1204(ra) # 8000029a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000756:	4719                	li	a4,6
    80000758:	6685                	lui	a3,0x1
    8000075a:	10000637          	lui	a2,0x10000
    8000075e:	100005b7          	lui	a1,0x10000
    80000762:	8526                	mv	a0,s1
    80000764:	00000097          	auipc	ra,0x0
    80000768:	fa0080e7          	jalr	-96(ra) # 80000704 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000076c:	4719                	li	a4,6
    8000076e:	6685                	lui	a3,0x1
    80000770:	10001637          	lui	a2,0x10001
    80000774:	100015b7          	lui	a1,0x10001
    80000778:	8526                	mv	a0,s1
    8000077a:	00000097          	auipc	ra,0x0
    8000077e:	f8a080e7          	jalr	-118(ra) # 80000704 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000782:	4719                	li	a4,6
    80000784:	004006b7          	lui	a3,0x400
    80000788:	0c000637          	lui	a2,0xc000
    8000078c:	0c0005b7          	lui	a1,0xc000
    80000790:	8526                	mv	a0,s1
    80000792:	00000097          	auipc	ra,0x0
    80000796:	f72080e7          	jalr	-142(ra) # 80000704 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000079a:	00008917          	auipc	s2,0x8
    8000079e:	86690913          	addi	s2,s2,-1946 # 80008000 <etext>
    800007a2:	4729                	li	a4,10
    800007a4:	80008697          	auipc	a3,0x80008
    800007a8:	85c68693          	addi	a3,a3,-1956 # 8000 <_entry-0x7fff8000>
    800007ac:	4605                	li	a2,1
    800007ae:	067e                	slli	a2,a2,0x1f
    800007b0:	85b2                	mv	a1,a2
    800007b2:	8526                	mv	a0,s1
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	f50080e7          	jalr	-176(ra) # 80000704 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800007bc:	4719                	li	a4,6
    800007be:	46c5                	li	a3,17
    800007c0:	06ee                	slli	a3,a3,0x1b
    800007c2:	412686b3          	sub	a3,a3,s2
    800007c6:	864a                	mv	a2,s2
    800007c8:	85ca                	mv	a1,s2
    800007ca:	8526                	mv	a0,s1
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	f38080e7          	jalr	-200(ra) # 80000704 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007d4:	4729                	li	a4,10
    800007d6:	6685                	lui	a3,0x1
    800007d8:	00007617          	auipc	a2,0x7
    800007dc:	82860613          	addi	a2,a2,-2008 # 80007000 <_trampoline>
    800007e0:	040005b7          	lui	a1,0x4000
    800007e4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007e6:	05b2                	slli	a1,a1,0xc
    800007e8:	8526                	mv	a0,s1
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	f1a080e7          	jalr	-230(ra) # 80000704 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007f2:	8526                	mv	a0,s1
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	708080e7          	jalr	1800(ra) # 80000efc <proc_mapstacks>
}
    800007fc:	8526                	mv	a0,s1
    800007fe:	60e2                	ld	ra,24(sp)
    80000800:	6442                	ld	s0,16(sp)
    80000802:	64a2                	ld	s1,8(sp)
    80000804:	6902                	ld	s2,0(sp)
    80000806:	6105                	addi	sp,sp,32
    80000808:	8082                	ret

000000008000080a <kvminit>:
{
    8000080a:	1141                	addi	sp,sp,-16
    8000080c:	e406                	sd	ra,8(sp)
    8000080e:	e022                	sd	s0,0(sp)
    80000810:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000812:	00000097          	auipc	ra,0x0
    80000816:	f22080e7          	jalr	-222(ra) # 80000734 <kvmmake>
    8000081a:	00008797          	auipc	a5,0x8
    8000081e:	0ea7b723          	sd	a0,238(a5) # 80008908 <kernel_pagetable>
}
    80000822:	60a2                	ld	ra,8(sp)
    80000824:	6402                	ld	s0,0(sp)
    80000826:	0141                	addi	sp,sp,16
    80000828:	8082                	ret

000000008000082a <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000082a:	715d                	addi	sp,sp,-80
    8000082c:	e486                	sd	ra,72(sp)
    8000082e:	e0a2                	sd	s0,64(sp)
    80000830:	fc26                	sd	s1,56(sp)
    80000832:	f84a                	sd	s2,48(sp)
    80000834:	f44e                	sd	s3,40(sp)
    80000836:	f052                	sd	s4,32(sp)
    80000838:	ec56                	sd	s5,24(sp)
    8000083a:	e85a                	sd	s6,16(sp)
    8000083c:	e45e                	sd	s7,8(sp)
    8000083e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80000840:	03459793          	slli	a5,a1,0x34
    80000844:	e795                	bnez	a5,80000870 <uvmunmap+0x46>
    80000846:	8a2a                	mv	s4,a0
    80000848:	892e                	mv	s2,a1
    8000084a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000084c:	0632                	slli	a2,a2,0xc
    8000084e:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    80000852:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000854:	6b05                	lui	s6,0x1
    80000856:	0735e263          	bltu	a1,s3,800008ba <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    8000085a:	60a6                	ld	ra,72(sp)
    8000085c:	6406                	ld	s0,64(sp)
    8000085e:	74e2                	ld	s1,56(sp)
    80000860:	7942                	ld	s2,48(sp)
    80000862:	79a2                	ld	s3,40(sp)
    80000864:	7a02                	ld	s4,32(sp)
    80000866:	6ae2                	ld	s5,24(sp)
    80000868:	6b42                	ld	s6,16(sp)
    8000086a:	6ba2                	ld	s7,8(sp)
    8000086c:	6161                	addi	sp,sp,80
    8000086e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000870:	00008517          	auipc	a0,0x8
    80000874:	84850513          	addi	a0,a0,-1976 # 800080b8 <etext+0xb8>
    80000878:	00005097          	auipc	ra,0x5
    8000087c:	4fe080e7          	jalr	1278(ra) # 80005d76 <panic>
      panic("uvmunmap: walk");
    80000880:	00008517          	auipc	a0,0x8
    80000884:	85050513          	addi	a0,a0,-1968 # 800080d0 <etext+0xd0>
    80000888:	00005097          	auipc	ra,0x5
    8000088c:	4ee080e7          	jalr	1262(ra) # 80005d76 <panic>
      panic("uvmunmap: not mapped");
    80000890:	00008517          	auipc	a0,0x8
    80000894:	85050513          	addi	a0,a0,-1968 # 800080e0 <etext+0xe0>
    80000898:	00005097          	auipc	ra,0x5
    8000089c:	4de080e7          	jalr	1246(ra) # 80005d76 <panic>
      panic("uvmunmap: not a leaf");
    800008a0:	00008517          	auipc	a0,0x8
    800008a4:	85850513          	addi	a0,a0,-1960 # 800080f8 <etext+0xf8>
    800008a8:	00005097          	auipc	ra,0x5
    800008ac:	4ce080e7          	jalr	1230(ra) # 80005d76 <panic>
    *pte = 0;
    800008b0:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800008b4:	995a                	add	s2,s2,s6
    800008b6:	fb3972e3          	bgeu	s2,s3,8000085a <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800008ba:	4601                	li	a2,0
    800008bc:	85ca                	mv	a1,s2
    800008be:	8552                	mv	a0,s4
    800008c0:	00000097          	auipc	ra,0x0
    800008c4:	cbc080e7          	jalr	-836(ra) # 8000057c <walk>
    800008c8:	84aa                	mv	s1,a0
    800008ca:	d95d                	beqz	a0,80000880 <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0)
    800008cc:	6108                	ld	a0,0(a0)
    800008ce:	00157793          	andi	a5,a0,1
    800008d2:	dfdd                	beqz	a5,80000890 <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V)
    800008d4:	3ff57793          	andi	a5,a0,1023
    800008d8:	fd7784e3          	beq	a5,s7,800008a0 <uvmunmap+0x76>
    if (do_free)
    800008dc:	fc0a8ae3          	beqz	s5,800008b0 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008e0:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800008e2:	0532                	slli	a0,a0,0xc
    800008e4:	fffff097          	auipc	ra,0xfffff
    800008e8:	7a4080e7          	jalr	1956(ra) # 80000088 <kfree>
    800008ec:	b7d1                	j	800008b0 <uvmunmap+0x86>

00000000800008ee <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008ee:	1101                	addi	sp,sp,-32
    800008f0:	ec06                	sd	ra,24(sp)
    800008f2:	e822                	sd	s0,16(sp)
    800008f4:	e426                	sd	s1,8(sp)
    800008f6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	90a080e7          	jalr	-1782(ra) # 80000202 <kalloc>
    80000900:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000902:	c519                	beqz	a0,80000910 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000904:	6605                	lui	a2,0x1
    80000906:	4581                	li	a1,0
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	992080e7          	jalr	-1646(ra) # 8000029a <memset>
  return pagetable;
}
    80000910:	8526                	mv	a0,s1
    80000912:	60e2                	ld	ra,24(sp)
    80000914:	6442                	ld	s0,16(sp)
    80000916:	64a2                	ld	s1,8(sp)
    80000918:	6105                	addi	sp,sp,32
    8000091a:	8082                	ret

000000008000091c <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000091c:	7179                	addi	sp,sp,-48
    8000091e:	f406                	sd	ra,40(sp)
    80000920:	f022                	sd	s0,32(sp)
    80000922:	ec26                	sd	s1,24(sp)
    80000924:	e84a                	sd	s2,16(sp)
    80000926:	e44e                	sd	s3,8(sp)
    80000928:	e052                	sd	s4,0(sp)
    8000092a:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    8000092c:	6785                	lui	a5,0x1
    8000092e:	04f67863          	bgeu	a2,a5,8000097e <uvmfirst+0x62>
    80000932:	8a2a                	mv	s4,a0
    80000934:	89ae                	mv	s3,a1
    80000936:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	8ca080e7          	jalr	-1846(ra) # 80000202 <kalloc>
    80000940:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000942:	6605                	lui	a2,0x1
    80000944:	4581                	li	a1,0
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	954080e7          	jalr	-1708(ra) # 8000029a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000094e:	4779                	li	a4,30
    80000950:	86ca                	mv	a3,s2
    80000952:	6605                	lui	a2,0x1
    80000954:	4581                	li	a1,0
    80000956:	8552                	mv	a0,s4
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	d0c080e7          	jalr	-756(ra) # 80000664 <mappages>
  memmove(mem, src, sz);
    80000960:	8626                	mv	a2,s1
    80000962:	85ce                	mv	a1,s3
    80000964:	854a                	mv	a0,s2
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	990080e7          	jalr	-1648(ra) # 800002f6 <memmove>
}
    8000096e:	70a2                	ld	ra,40(sp)
    80000970:	7402                	ld	s0,32(sp)
    80000972:	64e2                	ld	s1,24(sp)
    80000974:	6942                	ld	s2,16(sp)
    80000976:	69a2                	ld	s3,8(sp)
    80000978:	6a02                	ld	s4,0(sp)
    8000097a:	6145                	addi	sp,sp,48
    8000097c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000097e:	00007517          	auipc	a0,0x7
    80000982:	79250513          	addi	a0,a0,1938 # 80008110 <etext+0x110>
    80000986:	00005097          	auipc	ra,0x5
    8000098a:	3f0080e7          	jalr	1008(ra) # 80005d76 <panic>

000000008000098e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000098e:	1101                	addi	sp,sp,-32
    80000990:	ec06                	sd	ra,24(sp)
    80000992:	e822                	sd	s0,16(sp)
    80000994:	e426                	sd	s1,8(sp)
    80000996:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80000998:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    8000099a:	00b67d63          	bgeu	a2,a1,800009b4 <uvmdealloc+0x26>
    8000099e:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    800009a0:	6785                	lui	a5,0x1
    800009a2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009a4:	00f60733          	add	a4,a2,a5
    800009a8:	76fd                	lui	a3,0xfffff
    800009aa:	8f75                	and	a4,a4,a3
    800009ac:	97ae                	add	a5,a5,a1
    800009ae:	8ff5                	and	a5,a5,a3
    800009b0:	00f76863          	bltu	a4,a5,800009c0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009b4:	8526                	mv	a0,s1
    800009b6:	60e2                	ld	ra,24(sp)
    800009b8:	6442                	ld	s0,16(sp)
    800009ba:	64a2                	ld	s1,8(sp)
    800009bc:	6105                	addi	sp,sp,32
    800009be:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009c0:	8f99                	sub	a5,a5,a4
    800009c2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009c4:	4685                	li	a3,1
    800009c6:	0007861b          	sext.w	a2,a5
    800009ca:	85ba                	mv	a1,a4
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	e5e080e7          	jalr	-418(ra) # 8000082a <uvmunmap>
    800009d4:	b7c5                	j	800009b4 <uvmdealloc+0x26>

00000000800009d6 <uvmalloc>:
  if (newsz < oldsz)
    800009d6:	0ab66563          	bltu	a2,a1,80000a80 <uvmalloc+0xaa>
{
    800009da:	7139                	addi	sp,sp,-64
    800009dc:	fc06                	sd	ra,56(sp)
    800009de:	f822                	sd	s0,48(sp)
    800009e0:	f426                	sd	s1,40(sp)
    800009e2:	f04a                	sd	s2,32(sp)
    800009e4:	ec4e                	sd	s3,24(sp)
    800009e6:	e852                	sd	s4,16(sp)
    800009e8:	e456                	sd	s5,8(sp)
    800009ea:	e05a                	sd	s6,0(sp)
    800009ec:	0080                	addi	s0,sp,64
    800009ee:	8aaa                	mv	s5,a0
    800009f0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009f2:	6785                	lui	a5,0x1
    800009f4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f6:	95be                	add	a1,a1,a5
    800009f8:	77fd                	lui	a5,0xfffff
    800009fa:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    800009fe:	08c9f363          	bgeu	s3,a2,80000a84 <uvmalloc+0xae>
    80000a02:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    80000a04:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000a08:	fffff097          	auipc	ra,0xfffff
    80000a0c:	7fa080e7          	jalr	2042(ra) # 80000202 <kalloc>
    80000a10:	84aa                	mv	s1,a0
    if (mem == 0)
    80000a12:	c51d                	beqz	a0,80000a40 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000a14:	6605                	lui	a2,0x1
    80000a16:	4581                	li	a1,0
    80000a18:	00000097          	auipc	ra,0x0
    80000a1c:	882080e7          	jalr	-1918(ra) # 8000029a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    80000a20:	875a                	mv	a4,s6
    80000a22:	86a6                	mv	a3,s1
    80000a24:	6605                	lui	a2,0x1
    80000a26:	85ca                	mv	a1,s2
    80000a28:	8556                	mv	a0,s5
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	c3a080e7          	jalr	-966(ra) # 80000664 <mappages>
    80000a32:	e90d                	bnez	a0,80000a64 <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000a34:	6785                	lui	a5,0x1
    80000a36:	993e                	add	s2,s2,a5
    80000a38:	fd4968e3          	bltu	s2,s4,80000a08 <uvmalloc+0x32>
  return newsz;
    80000a3c:	8552                	mv	a0,s4
    80000a3e:	a809                	j	80000a50 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000a40:	864e                	mv	a2,s3
    80000a42:	85ca                	mv	a1,s2
    80000a44:	8556                	mv	a0,s5
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	f48080e7          	jalr	-184(ra) # 8000098e <uvmdealloc>
      return 0;
    80000a4e:	4501                	li	a0,0
}
    80000a50:	70e2                	ld	ra,56(sp)
    80000a52:	7442                	ld	s0,48(sp)
    80000a54:	74a2                	ld	s1,40(sp)
    80000a56:	7902                	ld	s2,32(sp)
    80000a58:	69e2                	ld	s3,24(sp)
    80000a5a:	6a42                	ld	s4,16(sp)
    80000a5c:	6aa2                	ld	s5,8(sp)
    80000a5e:	6b02                	ld	s6,0(sp)
    80000a60:	6121                	addi	sp,sp,64
    80000a62:	8082                	ret
      kfree(mem);
    80000a64:	8526                	mv	a0,s1
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	622080e7          	jalr	1570(ra) # 80000088 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a6e:	864e                	mv	a2,s3
    80000a70:	85ca                	mv	a1,s2
    80000a72:	8556                	mv	a0,s5
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	f1a080e7          	jalr	-230(ra) # 8000098e <uvmdealloc>
      return 0;
    80000a7c:	4501                	li	a0,0
    80000a7e:	bfc9                	j	80000a50 <uvmalloc+0x7a>
    return oldsz;
    80000a80:	852e                	mv	a0,a1
}
    80000a82:	8082                	ret
  return newsz;
    80000a84:	8532                	mv	a0,a2
    80000a86:	b7e9                	j	80000a50 <uvmalloc+0x7a>

0000000080000a88 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000a88:	7179                	addi	sp,sp,-48
    80000a8a:	f406                	sd	ra,40(sp)
    80000a8c:	f022                	sd	s0,32(sp)
    80000a8e:	ec26                	sd	s1,24(sp)
    80000a90:	e84a                	sd	s2,16(sp)
    80000a92:	e44e                	sd	s3,8(sp)
    80000a94:	e052                	sd	s4,0(sp)
    80000a96:	1800                	addi	s0,sp,48
    80000a98:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80000a9a:	84aa                	mv	s1,a0
    80000a9c:	6905                	lui	s2,0x1
    80000a9e:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000aa0:	4985                	li	s3,1
    80000aa2:	a829                	j	80000abc <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000aa4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000aa6:	00c79513          	slli	a0,a5,0xc
    80000aaa:	00000097          	auipc	ra,0x0
    80000aae:	fde080e7          	jalr	-34(ra) # 80000a88 <freewalk>
      pagetable[i] = 0;
    80000ab2:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80000ab6:	04a1                	addi	s1,s1,8
    80000ab8:	03248163          	beq	s1,s2,80000ada <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000abc:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000abe:	00f7f713          	andi	a4,a5,15
    80000ac2:	ff3701e3          	beq	a4,s3,80000aa4 <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80000ac6:	8b85                	andi	a5,a5,1
    80000ac8:	d7fd                	beqz	a5,80000ab6 <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	66650513          	addi	a0,a0,1638 # 80008130 <etext+0x130>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	2a4080e7          	jalr	676(ra) # 80005d76 <panic>
    }
  }
  kfree((void *)pagetable);
    80000ada:	8552                	mv	a0,s4
    80000adc:	fffff097          	auipc	ra,0xfffff
    80000ae0:	5ac080e7          	jalr	1452(ra) # 80000088 <kfree>
}
    80000ae4:	70a2                	ld	ra,40(sp)
    80000ae6:	7402                	ld	s0,32(sp)
    80000ae8:	64e2                	ld	s1,24(sp)
    80000aea:	6942                	ld	s2,16(sp)
    80000aec:	69a2                	ld	s3,8(sp)
    80000aee:	6a02                	ld	s4,0(sp)
    80000af0:	6145                	addi	sp,sp,48
    80000af2:	8082                	ret

0000000080000af4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000af4:	1101                	addi	sp,sp,-32
    80000af6:	ec06                	sd	ra,24(sp)
    80000af8:	e822                	sd	s0,16(sp)
    80000afa:	e426                	sd	s1,8(sp)
    80000afc:	1000                	addi	s0,sp,32
    80000afe:	84aa                	mv	s1,a0
  if (sz > 0)
    80000b00:	e999                	bnez	a1,80000b16 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000b02:	8526                	mv	a0,s1
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	f84080e7          	jalr	-124(ra) # 80000a88 <freewalk>
}
    80000b0c:	60e2                	ld	ra,24(sp)
    80000b0e:	6442                	ld	s0,16(sp)
    80000b10:	64a2                	ld	s1,8(sp)
    80000b12:	6105                	addi	sp,sp,32
    80000b14:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000b16:	6785                	lui	a5,0x1
    80000b18:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b1a:	95be                	add	a1,a1,a5
    80000b1c:	4685                	li	a3,1
    80000b1e:	00c5d613          	srli	a2,a1,0xc
    80000b22:	4581                	li	a1,0
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	d06080e7          	jalr	-762(ra) # 8000082a <uvmunmap>
    80000b2c:	bfd9                	j	80000b02 <uvmfree+0xe>

0000000080000b2e <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE)
    80000b2e:	c271                	beqz	a2,80000bf2 <uvmcopy+0xc4>
{
    80000b30:	7139                	addi	sp,sp,-64
    80000b32:	fc06                	sd	ra,56(sp)
    80000b34:	f822                	sd	s0,48(sp)
    80000b36:	f426                	sd	s1,40(sp)
    80000b38:	f04a                	sd	s2,32(sp)
    80000b3a:	ec4e                	sd	s3,24(sp)
    80000b3c:	e852                	sd	s4,16(sp)
    80000b3e:	e456                	sd	s5,8(sp)
    80000b40:	e05a                	sd	s6,0(sp)
    80000b42:	0080                	addi	s0,sp,64
    80000b44:	8aaa                	mv	s5,a0
    80000b46:	8a2e                	mv	s4,a1
    80000b48:	89b2                	mv	s3,a2
  for (i = 0; i < sz; i += PGSIZE)
    80000b4a:	4481                	li	s1,0
    80000b4c:	a0a9                	j	80000b96 <uvmcopy+0x68>
  {
    if ((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000b4e:	00007517          	auipc	a0,0x7
    80000b52:	5f250513          	addi	a0,a0,1522 # 80008140 <etext+0x140>
    80000b56:	00005097          	auipc	ra,0x5
    80000b5a:	220080e7          	jalr	544(ra) # 80005d76 <panic>
    if ((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    80000b5e:	00007517          	auipc	a0,0x7
    80000b62:	60250513          	addi	a0,a0,1538 # 80008160 <etext+0x160>
    80000b66:	00005097          	auipc	ra,0x5
    80000b6a:	210080e7          	jalr	528(ra) # 80005d76 <panic>
    pa = PTE2PA(*pte);
    int is_write = *pte & PTE_W;
    *pte &= ~PTE_W;
    80000b6e:	e118                	sd	a4,0(a0)
      *pte |= PTE_C;
    }
    // remember to increase ref count
    // if((mem = kalloc()) == 0)
    //   goto err;
    incref(pa);
    80000b70:	854a                	mv	a0,s2
    80000b72:	fffff097          	auipc	ra,0xfffff
    80000b76:	4aa080e7          	jalr	1194(ra) # 8000001c <incref>
    if (mappages(new, i, PGSIZE, (uint64)pa, flags) != 0)
    80000b7a:	875a                	mv	a4,s6
    80000b7c:	86ca                	mv	a3,s2
    80000b7e:	6605                	lui	a2,0x1
    80000b80:	85a6                	mv	a1,s1
    80000b82:	8552                	mv	a0,s4
    80000b84:	00000097          	auipc	ra,0x0
    80000b88:	ae0080e7          	jalr	-1312(ra) # 80000664 <mappages>
    80000b8c:	ed1d                	bnez	a0,80000bca <uvmcopy+0x9c>
  for (i = 0; i < sz; i += PGSIZE)
    80000b8e:	6785                	lui	a5,0x1
    80000b90:	94be                	add	s1,s1,a5
    80000b92:	0534f663          	bgeu	s1,s3,80000bde <uvmcopy+0xb0>
    if ((pte = walk(old, i, 0)) == 0)
    80000b96:	4601                	li	a2,0
    80000b98:	85a6                	mv	a1,s1
    80000b9a:	8556                	mv	a0,s5
    80000b9c:	00000097          	auipc	ra,0x0
    80000ba0:	9e0080e7          	jalr	-1568(ra) # 8000057c <walk>
    80000ba4:	d54d                	beqz	a0,80000b4e <uvmcopy+0x20>
    if ((*pte & PTE_V) == 0)
    80000ba6:	611c                	ld	a5,0(a0)
    80000ba8:	0017f713          	andi	a4,a5,1
    80000bac:	db4d                	beqz	a4,80000b5e <uvmcopy+0x30>
    pa = PTE2PA(*pte);
    80000bae:	00a7d913          	srli	s2,a5,0xa
    80000bb2:	0932                	slli	s2,s2,0xc
    *pte &= ~PTE_W;
    80000bb4:	ffb7f713          	andi	a4,a5,-5
    flags = PTE_FLAGS(*pte);
    80000bb8:	3fb7fb13          	andi	s6,a5,1019
    if (is_write)
    80000bbc:	8b91                	andi	a5,a5,4
    80000bbe:	dbc5                	beqz	a5,80000b6e <uvmcopy+0x40>
      flags |= PTE_C;
    80000bc0:	100b6b13          	ori	s6,s6,256
      *pte |= PTE_C;
    80000bc4:	10076713          	ori	a4,a4,256
    80000bc8:	b75d                	j	80000b6e <uvmcopy+0x40>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bca:	4685                	li	a3,1
    80000bcc:	00c4d613          	srli	a2,s1,0xc
    80000bd0:	4581                	li	a1,0
    80000bd2:	8552                	mv	a0,s4
    80000bd4:	00000097          	auipc	ra,0x0
    80000bd8:	c56080e7          	jalr	-938(ra) # 8000082a <uvmunmap>
  return -1;
    80000bdc:	557d                	li	a0,-1
}
    80000bde:	70e2                	ld	ra,56(sp)
    80000be0:	7442                	ld	s0,48(sp)
    80000be2:	74a2                	ld	s1,40(sp)
    80000be4:	7902                	ld	s2,32(sp)
    80000be6:	69e2                	ld	s3,24(sp)
    80000be8:	6a42                	ld	s4,16(sp)
    80000bea:	6aa2                	ld	s5,8(sp)
    80000bec:	6b02                	ld	s6,0(sp)
    80000bee:	6121                	addi	sp,sp,64
    80000bf0:	8082                	ret
  return 0;
    80000bf2:	4501                	li	a0,0
}
    80000bf4:	8082                	ret

0000000080000bf6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bf6:	1141                	addi	sp,sp,-16
    80000bf8:	e406                	sd	ra,8(sp)
    80000bfa:	e022                	sd	s0,0(sp)
    80000bfc:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000bfe:	4601                	li	a2,0
    80000c00:	00000097          	auipc	ra,0x0
    80000c04:	97c080e7          	jalr	-1668(ra) # 8000057c <walk>
  if (pte == 0)
    80000c08:	c901                	beqz	a0,80000c18 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c0a:	611c                	ld	a5,0(a0)
    80000c0c:	9bbd                	andi	a5,a5,-17
    80000c0e:	e11c                	sd	a5,0(a0)
}
    80000c10:	60a2                	ld	ra,8(sp)
    80000c12:	6402                	ld	s0,0(sp)
    80000c14:	0141                	addi	sp,sp,16
    80000c16:	8082                	ret
    panic("uvmclear");
    80000c18:	00007517          	auipc	a0,0x7
    80000c1c:	56850513          	addi	a0,a0,1384 # 80008180 <etext+0x180>
    80000c20:	00005097          	auipc	ra,0x5
    80000c24:	156080e7          	jalr	342(ra) # 80005d76 <panic>

0000000080000c28 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

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
  {
    va0 = PGROUNDDOWN(srcva);
    80000c4a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4c:	6a85                	lui	s5,0x1
    80000c4e:	a01d                	j	80000c74 <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c50:	018505b3          	add	a1,a0,s8
    80000c54:	0004861b          	sext.w	a2,s1
    80000c58:	412585b3          	sub	a1,a1,s2
    80000c5c:	8552                	mv	a0,s4
    80000c5e:	fffff097          	auipc	ra,0xfffff
    80000c62:	698080e7          	jalr	1688(ra) # 800002f6 <memmove>

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
    pa0 = walkaddr(pagetable, va0);
    80000c78:	85ca                	mv	a1,s2
    80000c7a:	855a                	mv	a0,s6
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	9a6080e7          	jalr	-1626(ra) # 80000622 <walkaddr>
    if (pa0 == 0)
    80000c84:	cd01                	beqz	a0,80000c9c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c86:	418904b3          	sub	s1,s2,s8
    80000c8a:	94d6                	add	s1,s1,s5
    80000c8c:	fc99f2e3          	bgeu	s3,s1,80000c50 <copyin+0x28>
    80000c90:	84ce                	mv	s1,s3
    80000c92:	bf7d                	j	80000c50 <copyin+0x28>
  }
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
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

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
  {
    va0 = PGROUNDDOWN(srcva);
    80000cd6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cd8:	6985                	lui	s3,0x1
    80000cda:	a02d                	j	80000d04 <copyinstr+0x4e>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000cdc:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ce0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000ce2:	37fd                	addiw	a5,a5,-1
    80000ce4:	0007851b          	sext.w	a0,a5
  }
  else
  {
    return -1;
  }
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
    pa0 = walkaddr(pagetable, va0);
    80000d08:	85ca                	mv	a1,s2
    80000d0a:	8552                	mv	a0,s4
    80000d0c:	00000097          	auipc	ra,0x0
    80000d10:	916080e7          	jalr	-1770(ra) # 80000622 <walkaddr>
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
    80000d3a:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fdbd260>
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

0000000080000d66 <cow_alloc>:

int cow_alloc(pagetable_t pagetable, uint64 va)
{
  if (va >= MAXVA)
    80000d66:	57fd                	li	a5,-1
    80000d68:	83e9                	srli	a5,a5,0x1a
    80000d6a:	06b7e963          	bltu	a5,a1,80000ddc <cow_alloc+0x76>
{
    80000d6e:	7179                	addi	sp,sp,-48
    80000d70:	f406                	sd	ra,40(sp)
    80000d72:	f022                	sd	s0,32(sp)
    80000d74:	ec26                	sd	s1,24(sp)
    80000d76:	e84a                	sd	s2,16(sp)
    80000d78:	e44e                	sd	s3,8(sp)
    80000d7a:	1800                	addi	s0,sp,48
    return -1;
  pte_t *pte = walk(pagetable, va, 0);
    80000d7c:	4601                	li	a2,0
    80000d7e:	fffff097          	auipc	ra,0xfffff
    80000d82:	7fe080e7          	jalr	2046(ra) # 8000057c <walk>
    80000d86:	89aa                	mv	s3,a0

  if (!pte || !(*pte & PTE_V) || !(*pte & PTE_U) || !(*pte & PTE_C))
    80000d88:	cd21                	beqz	a0,80000de0 <cow_alloc+0x7a>
    80000d8a:	610c                	ld	a1,0(a0)
    80000d8c:	1115f713          	andi	a4,a1,273
    80000d90:	11100793          	li	a5,273
    80000d94:	04f71863          	bne	a4,a5,80000de4 <cow_alloc+0x7e>
    return -1;

  uint64 pas = PTE2PA(*pte);
    80000d98:	81a9                	srli	a1,a1,0xa
    80000d9a:	00c59913          	slli	s2,a1,0xc
  uint64 pad = (uint64)kalloc();
    80000d9e:	fffff097          	auipc	ra,0xfffff
    80000da2:	464080e7          	jalr	1124(ra) # 80000202 <kalloc>
    80000da6:	84aa                	mv	s1,a0
  if (pad == 0)
    80000da8:	c121                	beqz	a0,80000de8 <cow_alloc+0x82>
    return -1;
  memmove((char *)pad, (char *)pas, PGSIZE);
    80000daa:	6605                	lui	a2,0x1
    80000dac:	85ca                	mv	a1,s2
    80000dae:	fffff097          	auipc	ra,0xfffff
    80000db2:	548080e7          	jalr	1352(ra) # 800002f6 <memmove>
  // free pas once
  kfree((void *)pas);
    80000db6:	854a                	mv	a0,s2
    80000db8:	fffff097          	auipc	ra,0xfffff
    80000dbc:	2d0080e7          	jalr	720(ra) # 80000088 <kfree>
  // *pte = PA2PTE(pad) | PTE_FLAGS(*pte) | PTE_W;
  *pte = PA2PTE(pad) | PTE_U | PTE_V | PTE_R | PTE_W;
    80000dc0:	80b1                	srli	s1,s1,0xc
    80000dc2:	04aa                	slli	s1,s1,0xa
    80000dc4:	0174e493          	ori	s1,s1,23
    80000dc8:	0099b023          	sd	s1,0(s3) # 1000 <_entry-0x7ffff000>
  return 0;
    80000dcc:	4501                	li	a0,0
    80000dce:	70a2                	ld	ra,40(sp)
    80000dd0:	7402                	ld	s0,32(sp)
    80000dd2:	64e2                	ld	s1,24(sp)
    80000dd4:	6942                	ld	s2,16(sp)
    80000dd6:	69a2                	ld	s3,8(sp)
    80000dd8:	6145                	addi	sp,sp,48
    80000dda:	8082                	ret
    return -1;
    80000ddc:	557d                	li	a0,-1
    80000dde:	8082                	ret
    return -1;
    80000de0:	557d                	li	a0,-1
    80000de2:	b7f5                	j	80000dce <cow_alloc+0x68>
    80000de4:	557d                	li	a0,-1
    80000de6:	b7e5                	j	80000dce <cow_alloc+0x68>
    return -1;
    80000de8:	557d                	li	a0,-1
    80000dea:	b7d5                	j	80000dce <cow_alloc+0x68>

0000000080000dec <copyout>:
  while (len > 0)
    80000dec:	10068063          	beqz	a3,80000eec <copyout+0x100>
{
    80000df0:	711d                	addi	sp,sp,-96
    80000df2:	ec86                	sd	ra,88(sp)
    80000df4:	e8a2                	sd	s0,80(sp)
    80000df6:	e4a6                	sd	s1,72(sp)
    80000df8:	e0ca                	sd	s2,64(sp)
    80000dfa:	fc4e                	sd	s3,56(sp)
    80000dfc:	f852                	sd	s4,48(sp)
    80000dfe:	f456                	sd	s5,40(sp)
    80000e00:	f05a                	sd	s6,32(sp)
    80000e02:	ec5e                	sd	s7,24(sp)
    80000e04:	e862                	sd	s8,16(sp)
    80000e06:	e466                	sd	s9,8(sp)
    80000e08:	e06a                	sd	s10,0(sp)
    80000e0a:	1080                	addi	s0,sp,96
    80000e0c:	8aaa                	mv	s5,a0
    80000e0e:	89ae                	mv	s3,a1
    80000e10:	8a32                	mv	s4,a2
    80000e12:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(dstva);
    80000e14:	74fd                	lui	s1,0xfffff
    80000e16:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000e18:	57fd                	li	a5,-1
    80000e1a:	83e9                	srli	a5,a5,0x1a
    80000e1c:	0c97ea63          	bltu	a5,s1,80000ef0 <copyout+0x104>
    if (!pte || !(*pte & PTE_V) || !(*pte & PTE_U))
    80000e20:	4bc5                	li	s7,17
    80000e22:	6c05                	lui	s8,0x1
    if (va0 >= MAXVA)
    80000e24:	8b3e                	mv	s6,a5
    80000e26:	a8bd                	j	80000ea4 <copyout+0xb8>
      printf("copyout: invalid\n");
    80000e28:	00007517          	auipc	a0,0x7
    80000e2c:	36850513          	addi	a0,a0,872 # 80008190 <etext+0x190>
    80000e30:	00005097          	auipc	ra,0x5
    80000e34:	f90080e7          	jalr	-112(ra) # 80005dc0 <printf>
      return -1;
    80000e38:	557d                	li	a0,-1
}
    80000e3a:	60e6                	ld	ra,88(sp)
    80000e3c:	6446                	ld	s0,80(sp)
    80000e3e:	64a6                	ld	s1,72(sp)
    80000e40:	6906                	ld	s2,64(sp)
    80000e42:	79e2                	ld	s3,56(sp)
    80000e44:	7a42                	ld	s4,48(sp)
    80000e46:	7aa2                	ld	s5,40(sp)
    80000e48:	7b02                	ld	s6,32(sp)
    80000e4a:	6be2                	ld	s7,24(sp)
    80000e4c:	6c42                	ld	s8,16(sp)
    80000e4e:	6ca2                	ld	s9,8(sp)
    80000e50:	6d02                	ld	s10,0(sp)
    80000e52:	6125                	addi	sp,sp,96
    80000e54:	8082                	ret
      if (cow_alloc(pagetable, va0) < 0)
    80000e56:	85a6                	mv	a1,s1
    80000e58:	8556                	mv	a0,s5
    80000e5a:	00000097          	auipc	ra,0x0
    80000e5e:	f0c080e7          	jalr	-244(ra) # 80000d66 <cow_alloc>
    80000e62:	06055263          	bgez	a0,80000ec6 <copyout+0xda>
        return -1;
    80000e66:	557d                	li	a0,-1
    80000e68:	bfc9                	j	80000e3a <copyout+0x4e>
      printf("copyout: non-write, pte %p\n", *pte);
    80000e6a:	00007517          	auipc	a0,0x7
    80000e6e:	33e50513          	addi	a0,a0,830 # 800081a8 <etext+0x1a8>
    80000e72:	00005097          	auipc	ra,0x5
    80000e76:	f4e080e7          	jalr	-178(ra) # 80005dc0 <printf>
      return -1;
    80000e7a:	557d                	li	a0,-1
    80000e7c:	bf7d                	j	80000e3a <copyout+0x4e>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000e7e:	40998533          	sub	a0,s3,s1
    80000e82:	000c861b          	sext.w	a2,s9
    80000e86:	85d2                	mv	a1,s4
    80000e88:	953e                	add	a0,a0,a5
    80000e8a:	fffff097          	auipc	ra,0xfffff
    80000e8e:	46c080e7          	jalr	1132(ra) # 800002f6 <memmove>
    len -= n;
    80000e92:	41990933          	sub	s2,s2,s9
    src += n;
    80000e96:	9a66                	add	s4,s4,s9
  while (len > 0)
    80000e98:	04090863          	beqz	s2,80000ee8 <copyout+0xfc>
    if (va0 >= MAXVA)
    80000e9c:	05ab6c63          	bltu	s6,s10,80000ef4 <copyout+0x108>
    va0 = PGROUNDDOWN(dstva);
    80000ea0:	84ea                	mv	s1,s10
    dstva = va0 + PGSIZE;
    80000ea2:	89ea                	mv	s3,s10
    pte_t *pte = walk(pagetable, va0, 0);
    80000ea4:	4601                	li	a2,0
    80000ea6:	85a6                	mv	a1,s1
    80000ea8:	8556                	mv	a0,s5
    80000eaa:	fffff097          	auipc	ra,0xfffff
    80000eae:	6d2080e7          	jalr	1746(ra) # 8000057c <walk>
    80000eb2:	8caa                	mv	s9,a0
    if (!pte || !(*pte & PTE_V) || !(*pte & PTE_U))
    80000eb4:	d935                	beqz	a0,80000e28 <copyout+0x3c>
    80000eb6:	611c                	ld	a5,0(a0)
    80000eb8:	0117f713          	andi	a4,a5,17
    80000ebc:	f77716e3          	bne	a4,s7,80000e28 <copyout+0x3c>
    if ((*pte & PTE_C))
    80000ec0:	1007f793          	andi	a5,a5,256
    80000ec4:	fbc9                	bnez	a5,80000e56 <copyout+0x6a>
    if (!(*pte & PTE_W))
    80000ec6:	000cb583          	ld	a1,0(s9)
    80000eca:	0045f793          	andi	a5,a1,4
    80000ece:	dfd1                	beqz	a5,80000e6a <copyout+0x7e>
    pa0 = PTE2PA(*pte);
    80000ed0:	81a9                	srli	a1,a1,0xa
    80000ed2:	00c59793          	slli	a5,a1,0xc
    if (pa0 == 0)
    80000ed6:	c38d                	beqz	a5,80000ef8 <copyout+0x10c>
    n = PGSIZE - (dstva - va0);
    80000ed8:	01848d33          	add	s10,s1,s8
    80000edc:	413d0cb3          	sub	s9,s10,s3
    80000ee0:	f9997fe3          	bgeu	s2,s9,80000e7e <copyout+0x92>
    80000ee4:	8cca                	mv	s9,s2
    80000ee6:	bf61                	j	80000e7e <copyout+0x92>
  return 0;
    80000ee8:	4501                	li	a0,0
    80000eea:	bf81                	j	80000e3a <copyout+0x4e>
    80000eec:	4501                	li	a0,0
}
    80000eee:	8082                	ret
      return -1;
    80000ef0:	557d                	li	a0,-1
    80000ef2:	b7a1                	j	80000e3a <copyout+0x4e>
    80000ef4:	557d                	li	a0,-1
    80000ef6:	b791                	j	80000e3a <copyout+0x4e>
      return -1;
    80000ef8:	557d                	li	a0,-1
    80000efa:	b781                	j	80000e3a <copyout+0x4e>

0000000080000efc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000efc:	7139                	addi	sp,sp,-64
    80000efe:	fc06                	sd	ra,56(sp)
    80000f00:	f822                	sd	s0,48(sp)
    80000f02:	f426                	sd	s1,40(sp)
    80000f04:	f04a                	sd	s2,32(sp)
    80000f06:	ec4e                	sd	s3,24(sp)
    80000f08:	e852                	sd	s4,16(sp)
    80000f0a:	e456                	sd	s5,8(sp)
    80000f0c:	e05a                	sd	s6,0(sp)
    80000f0e:	0080                	addi	s0,sp,64
    80000f10:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f12:	00228497          	auipc	s1,0x228
    80000f16:	e6e48493          	addi	s1,s1,-402 # 80228d80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f1a:	8b26                	mv	s6,s1
    80000f1c:	00007a97          	auipc	s5,0x7
    80000f20:	0e4a8a93          	addi	s5,s5,228 # 80008000 <etext>
    80000f24:	04000937          	lui	s2,0x4000
    80000f28:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000f2a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2c:	0022ea17          	auipc	s4,0x22e
    80000f30:	854a0a13          	addi	s4,s4,-1964 # 8022e780 <tickslock>
    char *pa = kalloc();
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	2ce080e7          	jalr	718(ra) # 80000202 <kalloc>
    80000f3c:	862a                	mv	a2,a0
    if(pa == 0)
    80000f3e:	c131                	beqz	a0,80000f82 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000f40:	416485b3          	sub	a1,s1,s6
    80000f44:	858d                	srai	a1,a1,0x3
    80000f46:	000ab783          	ld	a5,0(s5)
    80000f4a:	02f585b3          	mul	a1,a1,a5
    80000f4e:	2585                	addiw	a1,a1,1
    80000f50:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f54:	4719                	li	a4,6
    80000f56:	6685                	lui	a3,0x1
    80000f58:	40b905b3          	sub	a1,s2,a1
    80000f5c:	854e                	mv	a0,s3
    80000f5e:	fffff097          	auipc	ra,0xfffff
    80000f62:	7a6080e7          	jalr	1958(ra) # 80000704 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f66:	16848493          	addi	s1,s1,360
    80000f6a:	fd4495e3          	bne	s1,s4,80000f34 <proc_mapstacks+0x38>
  }
}
    80000f6e:	70e2                	ld	ra,56(sp)
    80000f70:	7442                	ld	s0,48(sp)
    80000f72:	74a2                	ld	s1,40(sp)
    80000f74:	7902                	ld	s2,32(sp)
    80000f76:	69e2                	ld	s3,24(sp)
    80000f78:	6a42                	ld	s4,16(sp)
    80000f7a:	6aa2                	ld	s5,8(sp)
    80000f7c:	6b02                	ld	s6,0(sp)
    80000f7e:	6121                	addi	sp,sp,64
    80000f80:	8082                	ret
      panic("kalloc");
    80000f82:	00007517          	auipc	a0,0x7
    80000f86:	24650513          	addi	a0,a0,582 # 800081c8 <etext+0x1c8>
    80000f8a:	00005097          	auipc	ra,0x5
    80000f8e:	dec080e7          	jalr	-532(ra) # 80005d76 <panic>

0000000080000f92 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000f92:	7139                	addi	sp,sp,-64
    80000f94:	fc06                	sd	ra,56(sp)
    80000f96:	f822                	sd	s0,48(sp)
    80000f98:	f426                	sd	s1,40(sp)
    80000f9a:	f04a                	sd	s2,32(sp)
    80000f9c:	ec4e                	sd	s3,24(sp)
    80000f9e:	e852                	sd	s4,16(sp)
    80000fa0:	e456                	sd	s5,8(sp)
    80000fa2:	e05a                	sd	s6,0(sp)
    80000fa4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000fa6:	00007597          	auipc	a1,0x7
    80000faa:	22a58593          	addi	a1,a1,554 # 800081d0 <etext+0x1d0>
    80000fae:	00228517          	auipc	a0,0x228
    80000fb2:	9a250513          	addi	a0,a0,-1630 # 80228950 <pid_lock>
    80000fb6:	00005097          	auipc	ra,0x5
    80000fba:	268080e7          	jalr	616(ra) # 8000621e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000fbe:	00007597          	auipc	a1,0x7
    80000fc2:	21a58593          	addi	a1,a1,538 # 800081d8 <etext+0x1d8>
    80000fc6:	00228517          	auipc	a0,0x228
    80000fca:	9a250513          	addi	a0,a0,-1630 # 80228968 <wait_lock>
    80000fce:	00005097          	auipc	ra,0x5
    80000fd2:	250080e7          	jalr	592(ra) # 8000621e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fd6:	00228497          	auipc	s1,0x228
    80000fda:	daa48493          	addi	s1,s1,-598 # 80228d80 <proc>
      initlock(&p->lock, "proc");
    80000fde:	00007b17          	auipc	s6,0x7
    80000fe2:	20ab0b13          	addi	s6,s6,522 # 800081e8 <etext+0x1e8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000fe6:	8aa6                	mv	s5,s1
    80000fe8:	00007a17          	auipc	s4,0x7
    80000fec:	018a0a13          	addi	s4,s4,24 # 80008000 <etext>
    80000ff0:	04000937          	lui	s2,0x4000
    80000ff4:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ff6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff8:	0022d997          	auipc	s3,0x22d
    80000ffc:	78898993          	addi	s3,s3,1928 # 8022e780 <tickslock>
      initlock(&p->lock, "proc");
    80001000:	85da                	mv	a1,s6
    80001002:	8526                	mv	a0,s1
    80001004:	00005097          	auipc	ra,0x5
    80001008:	21a080e7          	jalr	538(ra) # 8000621e <initlock>
      p->state = UNUSED;
    8000100c:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001010:	415487b3          	sub	a5,s1,s5
    80001014:	878d                	srai	a5,a5,0x3
    80001016:	000a3703          	ld	a4,0(s4)
    8000101a:	02e787b3          	mul	a5,a5,a4
    8000101e:	2785                	addiw	a5,a5,1
    80001020:	00d7979b          	slliw	a5,a5,0xd
    80001024:	40f907b3          	sub	a5,s2,a5
    80001028:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000102a:	16848493          	addi	s1,s1,360
    8000102e:	fd3499e3          	bne	s1,s3,80001000 <procinit+0x6e>
  }
}
    80001032:	70e2                	ld	ra,56(sp)
    80001034:	7442                	ld	s0,48(sp)
    80001036:	74a2                	ld	s1,40(sp)
    80001038:	7902                	ld	s2,32(sp)
    8000103a:	69e2                	ld	s3,24(sp)
    8000103c:	6a42                	ld	s4,16(sp)
    8000103e:	6aa2                	ld	s5,8(sp)
    80001040:	6b02                	ld	s6,0(sp)
    80001042:	6121                	addi	sp,sp,64
    80001044:	8082                	ret

0000000080001046 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001046:	1141                	addi	sp,sp,-16
    80001048:	e422                	sd	s0,8(sp)
    8000104a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp"
    8000104c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000104e:	2501                	sext.w	a0,a0
    80001050:	6422                	ld	s0,8(sp)
    80001052:	0141                	addi	sp,sp,16
    80001054:	8082                	ret

0000000080001056 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001056:	1141                	addi	sp,sp,-16
    80001058:	e422                	sd	s0,8(sp)
    8000105a:	0800                	addi	s0,sp,16
    8000105c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000105e:	2781                	sext.w	a5,a5
    80001060:	079e                	slli	a5,a5,0x7
  return c;
}
    80001062:	00228517          	auipc	a0,0x228
    80001066:	91e50513          	addi	a0,a0,-1762 # 80228980 <cpus>
    8000106a:	953e                	add	a0,a0,a5
    8000106c:	6422                	ld	s0,8(sp)
    8000106e:	0141                	addi	sp,sp,16
    80001070:	8082                	ret

0000000080001072 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001072:	1101                	addi	sp,sp,-32
    80001074:	ec06                	sd	ra,24(sp)
    80001076:	e822                	sd	s0,16(sp)
    80001078:	e426                	sd	s1,8(sp)
    8000107a:	1000                	addi	s0,sp,32
  push_off();
    8000107c:	00005097          	auipc	ra,0x5
    80001080:	1e6080e7          	jalr	486(ra) # 80006262 <push_off>
    80001084:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001086:	2781                	sext.w	a5,a5
    80001088:	079e                	slli	a5,a5,0x7
    8000108a:	00228717          	auipc	a4,0x228
    8000108e:	8c670713          	addi	a4,a4,-1850 # 80228950 <pid_lock>
    80001092:	97ba                	add	a5,a5,a4
    80001094:	7b84                	ld	s1,48(a5)
  pop_off();
    80001096:	00005097          	auipc	ra,0x5
    8000109a:	26c080e7          	jalr	620(ra) # 80006302 <pop_off>
  return p;
}
    8000109e:	8526                	mv	a0,s1
    800010a0:	60e2                	ld	ra,24(sp)
    800010a2:	6442                	ld	s0,16(sp)
    800010a4:	64a2                	ld	s1,8(sp)
    800010a6:	6105                	addi	sp,sp,32
    800010a8:	8082                	ret

00000000800010aa <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800010aa:	1141                	addi	sp,sp,-16
    800010ac:	e406                	sd	ra,8(sp)
    800010ae:	e022                	sd	s0,0(sp)
    800010b0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800010b2:	00000097          	auipc	ra,0x0
    800010b6:	fc0080e7          	jalr	-64(ra) # 80001072 <myproc>
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	2a8080e7          	jalr	680(ra) # 80006362 <release>

  if (first) {
    800010c2:	00007797          	auipc	a5,0x7
    800010c6:	7ee7a783          	lw	a5,2030(a5) # 800088b0 <first.1>
    800010ca:	eb89                	bnez	a5,800010dc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010cc:	00001097          	auipc	ra,0x1
    800010d0:	c5c080e7          	jalr	-932(ra) # 80001d28 <usertrapret>
}
    800010d4:	60a2                	ld	ra,8(sp)
    800010d6:	6402                	ld	s0,0(sp)
    800010d8:	0141                	addi	sp,sp,16
    800010da:	8082                	ret
    first = 0;
    800010dc:	00007797          	auipc	a5,0x7
    800010e0:	7c07aa23          	sw	zero,2004(a5) # 800088b0 <first.1>
    fsinit(ROOTDEV);
    800010e4:	4505                	li	a0,1
    800010e6:	00002097          	auipc	ra,0x2
    800010ea:	9c6080e7          	jalr	-1594(ra) # 80002aac <fsinit>
    800010ee:	bff9                	j	800010cc <forkret+0x22>

00000000800010f0 <allocpid>:
{
    800010f0:	1101                	addi	sp,sp,-32
    800010f2:	ec06                	sd	ra,24(sp)
    800010f4:	e822                	sd	s0,16(sp)
    800010f6:	e426                	sd	s1,8(sp)
    800010f8:	e04a                	sd	s2,0(sp)
    800010fa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800010fc:	00228917          	auipc	s2,0x228
    80001100:	85490913          	addi	s2,s2,-1964 # 80228950 <pid_lock>
    80001104:	854a                	mv	a0,s2
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	1a8080e7          	jalr	424(ra) # 800062ae <acquire>
  pid = nextpid;
    8000110e:	00007797          	auipc	a5,0x7
    80001112:	7a678793          	addi	a5,a5,1958 # 800088b4 <nextpid>
    80001116:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001118:	0014871b          	addiw	a4,s1,1
    8000111c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000111e:	854a                	mv	a0,s2
    80001120:	00005097          	auipc	ra,0x5
    80001124:	242080e7          	jalr	578(ra) # 80006362 <release>
}
    80001128:	8526                	mv	a0,s1
    8000112a:	60e2                	ld	ra,24(sp)
    8000112c:	6442                	ld	s0,16(sp)
    8000112e:	64a2                	ld	s1,8(sp)
    80001130:	6902                	ld	s2,0(sp)
    80001132:	6105                	addi	sp,sp,32
    80001134:	8082                	ret

0000000080001136 <proc_pagetable>:
{
    80001136:	1101                	addi	sp,sp,-32
    80001138:	ec06                	sd	ra,24(sp)
    8000113a:	e822                	sd	s0,16(sp)
    8000113c:	e426                	sd	s1,8(sp)
    8000113e:	e04a                	sd	s2,0(sp)
    80001140:	1000                	addi	s0,sp,32
    80001142:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	7aa080e7          	jalr	1962(ra) # 800008ee <uvmcreate>
    8000114c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000114e:	c121                	beqz	a0,8000118e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001150:	4729                	li	a4,10
    80001152:	00006697          	auipc	a3,0x6
    80001156:	eae68693          	addi	a3,a3,-338 # 80007000 <_trampoline>
    8000115a:	6605                	lui	a2,0x1
    8000115c:	040005b7          	lui	a1,0x4000
    80001160:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001162:	05b2                	slli	a1,a1,0xc
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	500080e7          	jalr	1280(ra) # 80000664 <mappages>
    8000116c:	02054863          	bltz	a0,8000119c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001170:	4719                	li	a4,6
    80001172:	05893683          	ld	a3,88(s2)
    80001176:	6605                	lui	a2,0x1
    80001178:	020005b7          	lui	a1,0x2000
    8000117c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000117e:	05b6                	slli	a1,a1,0xd
    80001180:	8526                	mv	a0,s1
    80001182:	fffff097          	auipc	ra,0xfffff
    80001186:	4e2080e7          	jalr	1250(ra) # 80000664 <mappages>
    8000118a:	02054163          	bltz	a0,800011ac <proc_pagetable+0x76>
}
    8000118e:	8526                	mv	a0,s1
    80001190:	60e2                	ld	ra,24(sp)
    80001192:	6442                	ld	s0,16(sp)
    80001194:	64a2                	ld	s1,8(sp)
    80001196:	6902                	ld	s2,0(sp)
    80001198:	6105                	addi	sp,sp,32
    8000119a:	8082                	ret
    uvmfree(pagetable, 0);
    8000119c:	4581                	li	a1,0
    8000119e:	8526                	mv	a0,s1
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	954080e7          	jalr	-1708(ra) # 80000af4 <uvmfree>
    return 0;
    800011a8:	4481                	li	s1,0
    800011aa:	b7d5                	j	8000118e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011ac:	4681                	li	a3,0
    800011ae:	4605                	li	a2,1
    800011b0:	040005b7          	lui	a1,0x4000
    800011b4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011b6:	05b2                	slli	a1,a1,0xc
    800011b8:	8526                	mv	a0,s1
    800011ba:	fffff097          	auipc	ra,0xfffff
    800011be:	670080e7          	jalr	1648(ra) # 8000082a <uvmunmap>
    uvmfree(pagetable, 0);
    800011c2:	4581                	li	a1,0
    800011c4:	8526                	mv	a0,s1
    800011c6:	00000097          	auipc	ra,0x0
    800011ca:	92e080e7          	jalr	-1746(ra) # 80000af4 <uvmfree>
    return 0;
    800011ce:	4481                	li	s1,0
    800011d0:	bf7d                	j	8000118e <proc_pagetable+0x58>

00000000800011d2 <proc_freepagetable>:
{
    800011d2:	1101                	addi	sp,sp,-32
    800011d4:	ec06                	sd	ra,24(sp)
    800011d6:	e822                	sd	s0,16(sp)
    800011d8:	e426                	sd	s1,8(sp)
    800011da:	e04a                	sd	s2,0(sp)
    800011dc:	1000                	addi	s0,sp,32
    800011de:	84aa                	mv	s1,a0
    800011e0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011e2:	4681                	li	a3,0
    800011e4:	4605                	li	a2,1
    800011e6:	040005b7          	lui	a1,0x4000
    800011ea:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011ec:	05b2                	slli	a1,a1,0xc
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	63c080e7          	jalr	1596(ra) # 8000082a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011f6:	4681                	li	a3,0
    800011f8:	4605                	li	a2,1
    800011fa:	020005b7          	lui	a1,0x2000
    800011fe:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001200:	05b6                	slli	a1,a1,0xd
    80001202:	8526                	mv	a0,s1
    80001204:	fffff097          	auipc	ra,0xfffff
    80001208:	626080e7          	jalr	1574(ra) # 8000082a <uvmunmap>
  uvmfree(pagetable, sz);
    8000120c:	85ca                	mv	a1,s2
    8000120e:	8526                	mv	a0,s1
    80001210:	00000097          	auipc	ra,0x0
    80001214:	8e4080e7          	jalr	-1820(ra) # 80000af4 <uvmfree>
}
    80001218:	60e2                	ld	ra,24(sp)
    8000121a:	6442                	ld	s0,16(sp)
    8000121c:	64a2                	ld	s1,8(sp)
    8000121e:	6902                	ld	s2,0(sp)
    80001220:	6105                	addi	sp,sp,32
    80001222:	8082                	ret

0000000080001224 <freeproc>:
{
    80001224:	1101                	addi	sp,sp,-32
    80001226:	ec06                	sd	ra,24(sp)
    80001228:	e822                	sd	s0,16(sp)
    8000122a:	e426                	sd	s1,8(sp)
    8000122c:	1000                	addi	s0,sp,32
    8000122e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001230:	6d28                	ld	a0,88(a0)
    80001232:	c509                	beqz	a0,8000123c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	e54080e7          	jalr	-428(ra) # 80000088 <kfree>
  p->trapframe = 0;
    8000123c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001240:	68a8                	ld	a0,80(s1)
    80001242:	c511                	beqz	a0,8000124e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001244:	64ac                	ld	a1,72(s1)
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	f8c080e7          	jalr	-116(ra) # 800011d2 <proc_freepagetable>
  p->pagetable = 0;
    8000124e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001252:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001256:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000125a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000125e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001262:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001266:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000126a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000126e:	0004ac23          	sw	zero,24(s1)
}
    80001272:	60e2                	ld	ra,24(sp)
    80001274:	6442                	ld	s0,16(sp)
    80001276:	64a2                	ld	s1,8(sp)
    80001278:	6105                	addi	sp,sp,32
    8000127a:	8082                	ret

000000008000127c <allocproc>:
{
    8000127c:	1101                	addi	sp,sp,-32
    8000127e:	ec06                	sd	ra,24(sp)
    80001280:	e822                	sd	s0,16(sp)
    80001282:	e426                	sd	s1,8(sp)
    80001284:	e04a                	sd	s2,0(sp)
    80001286:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001288:	00228497          	auipc	s1,0x228
    8000128c:	af848493          	addi	s1,s1,-1288 # 80228d80 <proc>
    80001290:	0022d917          	auipc	s2,0x22d
    80001294:	4f090913          	addi	s2,s2,1264 # 8022e780 <tickslock>
    acquire(&p->lock);
    80001298:	8526                	mv	a0,s1
    8000129a:	00005097          	auipc	ra,0x5
    8000129e:	014080e7          	jalr	20(ra) # 800062ae <acquire>
    if(p->state == UNUSED) {
    800012a2:	4c9c                	lw	a5,24(s1)
    800012a4:	cf81                	beqz	a5,800012bc <allocproc+0x40>
      release(&p->lock);
    800012a6:	8526                	mv	a0,s1
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	0ba080e7          	jalr	186(ra) # 80006362 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012b0:	16848493          	addi	s1,s1,360
    800012b4:	ff2492e3          	bne	s1,s2,80001298 <allocproc+0x1c>
  return 0;
    800012b8:	4481                	li	s1,0
    800012ba:	a889                	j	8000130c <allocproc+0x90>
  p->pid = allocpid();
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	e34080e7          	jalr	-460(ra) # 800010f0 <allocpid>
    800012c4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012c6:	4785                	li	a5,1
    800012c8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012ca:	fffff097          	auipc	ra,0xfffff
    800012ce:	f38080e7          	jalr	-200(ra) # 80000202 <kalloc>
    800012d2:	892a                	mv	s2,a0
    800012d4:	eca8                	sd	a0,88(s1)
    800012d6:	c131                	beqz	a0,8000131a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012d8:	8526                	mv	a0,s1
    800012da:	00000097          	auipc	ra,0x0
    800012de:	e5c080e7          	jalr	-420(ra) # 80001136 <proc_pagetable>
    800012e2:	892a                	mv	s2,a0
    800012e4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012e6:	c531                	beqz	a0,80001332 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012e8:	07000613          	li	a2,112
    800012ec:	4581                	li	a1,0
    800012ee:	06048513          	addi	a0,s1,96
    800012f2:	fffff097          	auipc	ra,0xfffff
    800012f6:	fa8080e7          	jalr	-88(ra) # 8000029a <memset>
  p->context.ra = (uint64)forkret;
    800012fa:	00000797          	auipc	a5,0x0
    800012fe:	db078793          	addi	a5,a5,-592 # 800010aa <forkret>
    80001302:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001304:	60bc                	ld	a5,64(s1)
    80001306:	6705                	lui	a4,0x1
    80001308:	97ba                	add	a5,a5,a4
    8000130a:	f4bc                	sd	a5,104(s1)
}
    8000130c:	8526                	mv	a0,s1
    8000130e:	60e2                	ld	ra,24(sp)
    80001310:	6442                	ld	s0,16(sp)
    80001312:	64a2                	ld	s1,8(sp)
    80001314:	6902                	ld	s2,0(sp)
    80001316:	6105                	addi	sp,sp,32
    80001318:	8082                	ret
    freeproc(p);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00000097          	auipc	ra,0x0
    80001320:	f08080e7          	jalr	-248(ra) # 80001224 <freeproc>
    release(&p->lock);
    80001324:	8526                	mv	a0,s1
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	03c080e7          	jalr	60(ra) # 80006362 <release>
    return 0;
    8000132e:	84ca                	mv	s1,s2
    80001330:	bff1                	j	8000130c <allocproc+0x90>
    freeproc(p);
    80001332:	8526                	mv	a0,s1
    80001334:	00000097          	auipc	ra,0x0
    80001338:	ef0080e7          	jalr	-272(ra) # 80001224 <freeproc>
    release(&p->lock);
    8000133c:	8526                	mv	a0,s1
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	024080e7          	jalr	36(ra) # 80006362 <release>
    return 0;
    80001346:	84ca                	mv	s1,s2
    80001348:	b7d1                	j	8000130c <allocproc+0x90>

000000008000134a <userinit>:
{
    8000134a:	1101                	addi	sp,sp,-32
    8000134c:	ec06                	sd	ra,24(sp)
    8000134e:	e822                	sd	s0,16(sp)
    80001350:	e426                	sd	s1,8(sp)
    80001352:	1000                	addi	s0,sp,32
  p = allocproc();
    80001354:	00000097          	auipc	ra,0x0
    80001358:	f28080e7          	jalr	-216(ra) # 8000127c <allocproc>
    8000135c:	84aa                	mv	s1,a0
  initproc = p;
    8000135e:	00007797          	auipc	a5,0x7
    80001362:	5aa7b923          	sd	a0,1458(a5) # 80008910 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001366:	03400613          	li	a2,52
    8000136a:	00007597          	auipc	a1,0x7
    8000136e:	55658593          	addi	a1,a1,1366 # 800088c0 <initcode>
    80001372:	6928                	ld	a0,80(a0)
    80001374:	fffff097          	auipc	ra,0xfffff
    80001378:	5a8080e7          	jalr	1448(ra) # 8000091c <uvmfirst>
  p->sz = PGSIZE;
    8000137c:	6785                	lui	a5,0x1
    8000137e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001380:	6cb8                	ld	a4,88(s1)
    80001382:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001386:	6cb8                	ld	a4,88(s1)
    80001388:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000138a:	4641                	li	a2,16
    8000138c:	00007597          	auipc	a1,0x7
    80001390:	e6458593          	addi	a1,a1,-412 # 800081f0 <etext+0x1f0>
    80001394:	15848513          	addi	a0,s1,344
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	04a080e7          	jalr	74(ra) # 800003e2 <safestrcpy>
  p->cwd = namei("/");
    800013a0:	00007517          	auipc	a0,0x7
    800013a4:	e6050513          	addi	a0,a0,-416 # 80008200 <etext+0x200>
    800013a8:	00002097          	auipc	ra,0x2
    800013ac:	122080e7          	jalr	290(ra) # 800034ca <namei>
    800013b0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013b4:	478d                	li	a5,3
    800013b6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013b8:	8526                	mv	a0,s1
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	fa8080e7          	jalr	-88(ra) # 80006362 <release>
}
    800013c2:	60e2                	ld	ra,24(sp)
    800013c4:	6442                	ld	s0,16(sp)
    800013c6:	64a2                	ld	s1,8(sp)
    800013c8:	6105                	addi	sp,sp,32
    800013ca:	8082                	ret

00000000800013cc <growproc>:
{
    800013cc:	1101                	addi	sp,sp,-32
    800013ce:	ec06                	sd	ra,24(sp)
    800013d0:	e822                	sd	s0,16(sp)
    800013d2:	e426                	sd	s1,8(sp)
    800013d4:	e04a                	sd	s2,0(sp)
    800013d6:	1000                	addi	s0,sp,32
    800013d8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800013da:	00000097          	auipc	ra,0x0
    800013de:	c98080e7          	jalr	-872(ra) # 80001072 <myproc>
    800013e2:	84aa                	mv	s1,a0
  sz = p->sz;
    800013e4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800013e6:	01204c63          	bgtz	s2,800013fe <growproc+0x32>
  } else if(n < 0){
    800013ea:	02094663          	bltz	s2,80001416 <growproc+0x4a>
  p->sz = sz;
    800013ee:	e4ac                	sd	a1,72(s1)
  return 0;
    800013f0:	4501                	li	a0,0
}
    800013f2:	60e2                	ld	ra,24(sp)
    800013f4:	6442                	ld	s0,16(sp)
    800013f6:	64a2                	ld	s1,8(sp)
    800013f8:	6902                	ld	s2,0(sp)
    800013fa:	6105                	addi	sp,sp,32
    800013fc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800013fe:	4691                	li	a3,4
    80001400:	00b90633          	add	a2,s2,a1
    80001404:	6928                	ld	a0,80(a0)
    80001406:	fffff097          	auipc	ra,0xfffff
    8000140a:	5d0080e7          	jalr	1488(ra) # 800009d6 <uvmalloc>
    8000140e:	85aa                	mv	a1,a0
    80001410:	fd79                	bnez	a0,800013ee <growproc+0x22>
      return -1;
    80001412:	557d                	li	a0,-1
    80001414:	bff9                	j	800013f2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001416:	00b90633          	add	a2,s2,a1
    8000141a:	6928                	ld	a0,80(a0)
    8000141c:	fffff097          	auipc	ra,0xfffff
    80001420:	572080e7          	jalr	1394(ra) # 8000098e <uvmdealloc>
    80001424:	85aa                	mv	a1,a0
    80001426:	b7e1                	j	800013ee <growproc+0x22>

0000000080001428 <fork>:
{
    80001428:	7139                	addi	sp,sp,-64
    8000142a:	fc06                	sd	ra,56(sp)
    8000142c:	f822                	sd	s0,48(sp)
    8000142e:	f426                	sd	s1,40(sp)
    80001430:	f04a                	sd	s2,32(sp)
    80001432:	ec4e                	sd	s3,24(sp)
    80001434:	e852                	sd	s4,16(sp)
    80001436:	e456                	sd	s5,8(sp)
    80001438:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000143a:	00000097          	auipc	ra,0x0
    8000143e:	c38080e7          	jalr	-968(ra) # 80001072 <myproc>
    80001442:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001444:	00000097          	auipc	ra,0x0
    80001448:	e38080e7          	jalr	-456(ra) # 8000127c <allocproc>
    8000144c:	10050c63          	beqz	a0,80001564 <fork+0x13c>
    80001450:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001452:	048ab603          	ld	a2,72(s5)
    80001456:	692c                	ld	a1,80(a0)
    80001458:	050ab503          	ld	a0,80(s5)
    8000145c:	fffff097          	auipc	ra,0xfffff
    80001460:	6d2080e7          	jalr	1746(ra) # 80000b2e <uvmcopy>
    80001464:	04054863          	bltz	a0,800014b4 <fork+0x8c>
  np->sz = p->sz;
    80001468:	048ab783          	ld	a5,72(s5)
    8000146c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001470:	058ab683          	ld	a3,88(s5)
    80001474:	87b6                	mv	a5,a3
    80001476:	058a3703          	ld	a4,88(s4)
    8000147a:	12068693          	addi	a3,a3,288
    8000147e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001482:	6788                	ld	a0,8(a5)
    80001484:	6b8c                	ld	a1,16(a5)
    80001486:	6f90                	ld	a2,24(a5)
    80001488:	01073023          	sd	a6,0(a4)
    8000148c:	e708                	sd	a0,8(a4)
    8000148e:	eb0c                	sd	a1,16(a4)
    80001490:	ef10                	sd	a2,24(a4)
    80001492:	02078793          	addi	a5,a5,32
    80001496:	02070713          	addi	a4,a4,32
    8000149a:	fed792e3          	bne	a5,a3,8000147e <fork+0x56>
  np->trapframe->a0 = 0;
    8000149e:	058a3783          	ld	a5,88(s4)
    800014a2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014a6:	0d0a8493          	addi	s1,s5,208
    800014aa:	0d0a0913          	addi	s2,s4,208
    800014ae:	150a8993          	addi	s3,s5,336
    800014b2:	a00d                	j	800014d4 <fork+0xac>
    freeproc(np);
    800014b4:	8552                	mv	a0,s4
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	d6e080e7          	jalr	-658(ra) # 80001224 <freeproc>
    release(&np->lock);
    800014be:	8552                	mv	a0,s4
    800014c0:	00005097          	auipc	ra,0x5
    800014c4:	ea2080e7          	jalr	-350(ra) # 80006362 <release>
    return -1;
    800014c8:	597d                	li	s2,-1
    800014ca:	a059                	j	80001550 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800014cc:	04a1                	addi	s1,s1,8
    800014ce:	0921                	addi	s2,s2,8
    800014d0:	01348b63          	beq	s1,s3,800014e6 <fork+0xbe>
    if(p->ofile[i])
    800014d4:	6088                	ld	a0,0(s1)
    800014d6:	d97d                	beqz	a0,800014cc <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800014d8:	00002097          	auipc	ra,0x2
    800014dc:	664080e7          	jalr	1636(ra) # 80003b3c <filedup>
    800014e0:	00a93023          	sd	a0,0(s2)
    800014e4:	b7e5                	j	800014cc <fork+0xa4>
  np->cwd = idup(p->cwd);
    800014e6:	150ab503          	ld	a0,336(s5)
    800014ea:	00001097          	auipc	ra,0x1
    800014ee:	7fc080e7          	jalr	2044(ra) # 80002ce6 <idup>
    800014f2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014f6:	4641                	li	a2,16
    800014f8:	158a8593          	addi	a1,s5,344
    800014fc:	158a0513          	addi	a0,s4,344
    80001500:	fffff097          	auipc	ra,0xfffff
    80001504:	ee2080e7          	jalr	-286(ra) # 800003e2 <safestrcpy>
  pid = np->pid;
    80001508:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000150c:	8552                	mv	a0,s4
    8000150e:	00005097          	auipc	ra,0x5
    80001512:	e54080e7          	jalr	-428(ra) # 80006362 <release>
  acquire(&wait_lock);
    80001516:	00227497          	auipc	s1,0x227
    8000151a:	45248493          	addi	s1,s1,1106 # 80228968 <wait_lock>
    8000151e:	8526                	mv	a0,s1
    80001520:	00005097          	auipc	ra,0x5
    80001524:	d8e080e7          	jalr	-626(ra) # 800062ae <acquire>
  np->parent = p;
    80001528:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000152c:	8526                	mv	a0,s1
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	e34080e7          	jalr	-460(ra) # 80006362 <release>
  acquire(&np->lock);
    80001536:	8552                	mv	a0,s4
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	d76080e7          	jalr	-650(ra) # 800062ae <acquire>
  np->state = RUNNABLE;
    80001540:	478d                	li	a5,3
    80001542:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001546:	8552                	mv	a0,s4
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	e1a080e7          	jalr	-486(ra) # 80006362 <release>
}
    80001550:	854a                	mv	a0,s2
    80001552:	70e2                	ld	ra,56(sp)
    80001554:	7442                	ld	s0,48(sp)
    80001556:	74a2                	ld	s1,40(sp)
    80001558:	7902                	ld	s2,32(sp)
    8000155a:	69e2                	ld	s3,24(sp)
    8000155c:	6a42                	ld	s4,16(sp)
    8000155e:	6aa2                	ld	s5,8(sp)
    80001560:	6121                	addi	sp,sp,64
    80001562:	8082                	ret
    return -1;
    80001564:	597d                	li	s2,-1
    80001566:	b7ed                	j	80001550 <fork+0x128>

0000000080001568 <scheduler>:
{
    80001568:	7139                	addi	sp,sp,-64
    8000156a:	fc06                	sd	ra,56(sp)
    8000156c:	f822                	sd	s0,48(sp)
    8000156e:	f426                	sd	s1,40(sp)
    80001570:	f04a                	sd	s2,32(sp)
    80001572:	ec4e                	sd	s3,24(sp)
    80001574:	e852                	sd	s4,16(sp)
    80001576:	e456                	sd	s5,8(sp)
    80001578:	e05a                	sd	s6,0(sp)
    8000157a:	0080                	addi	s0,sp,64
    8000157c:	8792                	mv	a5,tp
  int id = r_tp();
    8000157e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001580:	00779a93          	slli	s5,a5,0x7
    80001584:	00227717          	auipc	a4,0x227
    80001588:	3cc70713          	addi	a4,a4,972 # 80228950 <pid_lock>
    8000158c:	9756                	add	a4,a4,s5
    8000158e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001592:	00227717          	auipc	a4,0x227
    80001596:	3f670713          	addi	a4,a4,1014 # 80228988 <cpus+0x8>
    8000159a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000159c:	498d                	li	s3,3
        p->state = RUNNING;
    8000159e:	4b11                	li	s6,4
        c->proc = p;
    800015a0:	079e                	slli	a5,a5,0x7
    800015a2:	00227a17          	auipc	s4,0x227
    800015a6:	3aea0a13          	addi	s4,s4,942 # 80228950 <pid_lock>
    800015aa:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ac:	0022d917          	auipc	s2,0x22d
    800015b0:	1d490913          	addi	s2,s2,468 # 8022e780 <tickslock>
  asm volatile("csrr %0, sstatus"
    800015b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015b8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    800015bc:	10079073          	csrw	sstatus,a5
    800015c0:	00227497          	auipc	s1,0x227
    800015c4:	7c048493          	addi	s1,s1,1984 # 80228d80 <proc>
    800015c8:	a811                	j	800015dc <scheduler+0x74>
      release(&p->lock);
    800015ca:	8526                	mv	a0,s1
    800015cc:	00005097          	auipc	ra,0x5
    800015d0:	d96080e7          	jalr	-618(ra) # 80006362 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015d4:	16848493          	addi	s1,s1,360
    800015d8:	fd248ee3          	beq	s1,s2,800015b4 <scheduler+0x4c>
      acquire(&p->lock);
    800015dc:	8526                	mv	a0,s1
    800015de:	00005097          	auipc	ra,0x5
    800015e2:	cd0080e7          	jalr	-816(ra) # 800062ae <acquire>
      if(p->state == RUNNABLE) {
    800015e6:	4c9c                	lw	a5,24(s1)
    800015e8:	ff3791e3          	bne	a5,s3,800015ca <scheduler+0x62>
        p->state = RUNNING;
    800015ec:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015f0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015f4:	06048593          	addi	a1,s1,96
    800015f8:	8556                	mv	a0,s5
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	684080e7          	jalr	1668(ra) # 80001c7e <swtch>
        c->proc = 0;
    80001602:	020a3823          	sd	zero,48(s4)
    80001606:	b7d1                	j	800015ca <scheduler+0x62>

0000000080001608 <sched>:
{
    80001608:	7179                	addi	sp,sp,-48
    8000160a:	f406                	sd	ra,40(sp)
    8000160c:	f022                	sd	s0,32(sp)
    8000160e:	ec26                	sd	s1,24(sp)
    80001610:	e84a                	sd	s2,16(sp)
    80001612:	e44e                	sd	s3,8(sp)
    80001614:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	a5c080e7          	jalr	-1444(ra) # 80001072 <myproc>
    8000161e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001620:	00005097          	auipc	ra,0x5
    80001624:	c14080e7          	jalr	-1004(ra) # 80006234 <holding>
    80001628:	c93d                	beqz	a0,8000169e <sched+0x96>
  asm volatile("mv %0, tp"
    8000162a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000162c:	2781                	sext.w	a5,a5
    8000162e:	079e                	slli	a5,a5,0x7
    80001630:	00227717          	auipc	a4,0x227
    80001634:	32070713          	addi	a4,a4,800 # 80228950 <pid_lock>
    80001638:	97ba                	add	a5,a5,a4
    8000163a:	0a87a703          	lw	a4,168(a5)
    8000163e:	4785                	li	a5,1
    80001640:	06f71763          	bne	a4,a5,800016ae <sched+0xa6>
  if(p->state == RUNNING)
    80001644:	4c98                	lw	a4,24(s1)
    80001646:	4791                	li	a5,4
    80001648:	06f70b63          	beq	a4,a5,800016be <sched+0xb6>
  asm volatile("csrr %0, sstatus"
    8000164c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001650:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001652:	efb5                	bnez	a5,800016ce <sched+0xc6>
  asm volatile("mv %0, tp"
    80001654:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001656:	00227917          	auipc	s2,0x227
    8000165a:	2fa90913          	addi	s2,s2,762 # 80228950 <pid_lock>
    8000165e:	2781                	sext.w	a5,a5
    80001660:	079e                	slli	a5,a5,0x7
    80001662:	97ca                	add	a5,a5,s2
    80001664:	0ac7a983          	lw	s3,172(a5)
    80001668:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000166a:	2781                	sext.w	a5,a5
    8000166c:	079e                	slli	a5,a5,0x7
    8000166e:	00227597          	auipc	a1,0x227
    80001672:	31a58593          	addi	a1,a1,794 # 80228988 <cpus+0x8>
    80001676:	95be                	add	a1,a1,a5
    80001678:	06048513          	addi	a0,s1,96
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	602080e7          	jalr	1538(ra) # 80001c7e <swtch>
    80001684:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001686:	2781                	sext.w	a5,a5
    80001688:	079e                	slli	a5,a5,0x7
    8000168a:	993e                	add	s2,s2,a5
    8000168c:	0b392623          	sw	s3,172(s2)
}
    80001690:	70a2                	ld	ra,40(sp)
    80001692:	7402                	ld	s0,32(sp)
    80001694:	64e2                	ld	s1,24(sp)
    80001696:	6942                	ld	s2,16(sp)
    80001698:	69a2                	ld	s3,8(sp)
    8000169a:	6145                	addi	sp,sp,48
    8000169c:	8082                	ret
    panic("sched p->lock");
    8000169e:	00007517          	auipc	a0,0x7
    800016a2:	b6a50513          	addi	a0,a0,-1174 # 80008208 <etext+0x208>
    800016a6:	00004097          	auipc	ra,0x4
    800016aa:	6d0080e7          	jalr	1744(ra) # 80005d76 <panic>
    panic("sched locks");
    800016ae:	00007517          	auipc	a0,0x7
    800016b2:	b6a50513          	addi	a0,a0,-1174 # 80008218 <etext+0x218>
    800016b6:	00004097          	auipc	ra,0x4
    800016ba:	6c0080e7          	jalr	1728(ra) # 80005d76 <panic>
    panic("sched running");
    800016be:	00007517          	auipc	a0,0x7
    800016c2:	b6a50513          	addi	a0,a0,-1174 # 80008228 <etext+0x228>
    800016c6:	00004097          	auipc	ra,0x4
    800016ca:	6b0080e7          	jalr	1712(ra) # 80005d76 <panic>
    panic("sched interruptible");
    800016ce:	00007517          	auipc	a0,0x7
    800016d2:	b6a50513          	addi	a0,a0,-1174 # 80008238 <etext+0x238>
    800016d6:	00004097          	auipc	ra,0x4
    800016da:	6a0080e7          	jalr	1696(ra) # 80005d76 <panic>

00000000800016de <yield>:
{
    800016de:	1101                	addi	sp,sp,-32
    800016e0:	ec06                	sd	ra,24(sp)
    800016e2:	e822                	sd	s0,16(sp)
    800016e4:	e426                	sd	s1,8(sp)
    800016e6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016e8:	00000097          	auipc	ra,0x0
    800016ec:	98a080e7          	jalr	-1654(ra) # 80001072 <myproc>
    800016f0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	bbc080e7          	jalr	-1092(ra) # 800062ae <acquire>
  p->state = RUNNABLE;
    800016fa:	478d                	li	a5,3
    800016fc:	cc9c                	sw	a5,24(s1)
  sched();
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	f0a080e7          	jalr	-246(ra) # 80001608 <sched>
  release(&p->lock);
    80001706:	8526                	mv	a0,s1
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	c5a080e7          	jalr	-934(ra) # 80006362 <release>
}
    80001710:	60e2                	ld	ra,24(sp)
    80001712:	6442                	ld	s0,16(sp)
    80001714:	64a2                	ld	s1,8(sp)
    80001716:	6105                	addi	sp,sp,32
    80001718:	8082                	ret

000000008000171a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000171a:	7179                	addi	sp,sp,-48
    8000171c:	f406                	sd	ra,40(sp)
    8000171e:	f022                	sd	s0,32(sp)
    80001720:	ec26                	sd	s1,24(sp)
    80001722:	e84a                	sd	s2,16(sp)
    80001724:	e44e                	sd	s3,8(sp)
    80001726:	1800                	addi	s0,sp,48
    80001728:	89aa                	mv	s3,a0
    8000172a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000172c:	00000097          	auipc	ra,0x0
    80001730:	946080e7          	jalr	-1722(ra) # 80001072 <myproc>
    80001734:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	b78080e7          	jalr	-1160(ra) # 800062ae <acquire>
  release(lk);
    8000173e:	854a                	mv	a0,s2
    80001740:	00005097          	auipc	ra,0x5
    80001744:	c22080e7          	jalr	-990(ra) # 80006362 <release>

  // Go to sleep.
  p->chan = chan;
    80001748:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000174c:	4789                	li	a5,2
    8000174e:	cc9c                	sw	a5,24(s1)

  sched();
    80001750:	00000097          	auipc	ra,0x0
    80001754:	eb8080e7          	jalr	-328(ra) # 80001608 <sched>

  // Tidy up.
  p->chan = 0;
    80001758:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000175c:	8526                	mv	a0,s1
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	c04080e7          	jalr	-1020(ra) # 80006362 <release>
  acquire(lk);
    80001766:	854a                	mv	a0,s2
    80001768:	00005097          	auipc	ra,0x5
    8000176c:	b46080e7          	jalr	-1210(ra) # 800062ae <acquire>
}
    80001770:	70a2                	ld	ra,40(sp)
    80001772:	7402                	ld	s0,32(sp)
    80001774:	64e2                	ld	s1,24(sp)
    80001776:	6942                	ld	s2,16(sp)
    80001778:	69a2                	ld	s3,8(sp)
    8000177a:	6145                	addi	sp,sp,48
    8000177c:	8082                	ret

000000008000177e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000177e:	7139                	addi	sp,sp,-64
    80001780:	fc06                	sd	ra,56(sp)
    80001782:	f822                	sd	s0,48(sp)
    80001784:	f426                	sd	s1,40(sp)
    80001786:	f04a                	sd	s2,32(sp)
    80001788:	ec4e                	sd	s3,24(sp)
    8000178a:	e852                	sd	s4,16(sp)
    8000178c:	e456                	sd	s5,8(sp)
    8000178e:	0080                	addi	s0,sp,64
    80001790:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001792:	00227497          	auipc	s1,0x227
    80001796:	5ee48493          	addi	s1,s1,1518 # 80228d80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000179a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000179c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000179e:	0022d917          	auipc	s2,0x22d
    800017a2:	fe290913          	addi	s2,s2,-30 # 8022e780 <tickslock>
    800017a6:	a811                	j	800017ba <wakeup+0x3c>
      }
      release(&p->lock);
    800017a8:	8526                	mv	a0,s1
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	bb8080e7          	jalr	-1096(ra) # 80006362 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017b2:	16848493          	addi	s1,s1,360
    800017b6:	03248663          	beq	s1,s2,800017e2 <wakeup+0x64>
    if(p != myproc()){
    800017ba:	00000097          	auipc	ra,0x0
    800017be:	8b8080e7          	jalr	-1864(ra) # 80001072 <myproc>
    800017c2:	fea488e3          	beq	s1,a0,800017b2 <wakeup+0x34>
      acquire(&p->lock);
    800017c6:	8526                	mv	a0,s1
    800017c8:	00005097          	auipc	ra,0x5
    800017cc:	ae6080e7          	jalr	-1306(ra) # 800062ae <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017d0:	4c9c                	lw	a5,24(s1)
    800017d2:	fd379be3          	bne	a5,s3,800017a8 <wakeup+0x2a>
    800017d6:	709c                	ld	a5,32(s1)
    800017d8:	fd4798e3          	bne	a5,s4,800017a8 <wakeup+0x2a>
        p->state = RUNNABLE;
    800017dc:	0154ac23          	sw	s5,24(s1)
    800017e0:	b7e1                	j	800017a8 <wakeup+0x2a>
    }
  }
}
    800017e2:	70e2                	ld	ra,56(sp)
    800017e4:	7442                	ld	s0,48(sp)
    800017e6:	74a2                	ld	s1,40(sp)
    800017e8:	7902                	ld	s2,32(sp)
    800017ea:	69e2                	ld	s3,24(sp)
    800017ec:	6a42                	ld	s4,16(sp)
    800017ee:	6aa2                	ld	s5,8(sp)
    800017f0:	6121                	addi	sp,sp,64
    800017f2:	8082                	ret

00000000800017f4 <reparent>:
{
    800017f4:	7179                	addi	sp,sp,-48
    800017f6:	f406                	sd	ra,40(sp)
    800017f8:	f022                	sd	s0,32(sp)
    800017fa:	ec26                	sd	s1,24(sp)
    800017fc:	e84a                	sd	s2,16(sp)
    800017fe:	e44e                	sd	s3,8(sp)
    80001800:	e052                	sd	s4,0(sp)
    80001802:	1800                	addi	s0,sp,48
    80001804:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001806:	00227497          	auipc	s1,0x227
    8000180a:	57a48493          	addi	s1,s1,1402 # 80228d80 <proc>
      pp->parent = initproc;
    8000180e:	00007a17          	auipc	s4,0x7
    80001812:	102a0a13          	addi	s4,s4,258 # 80008910 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001816:	0022d997          	auipc	s3,0x22d
    8000181a:	f6a98993          	addi	s3,s3,-150 # 8022e780 <tickslock>
    8000181e:	a029                	j	80001828 <reparent+0x34>
    80001820:	16848493          	addi	s1,s1,360
    80001824:	01348d63          	beq	s1,s3,8000183e <reparent+0x4a>
    if(pp->parent == p){
    80001828:	7c9c                	ld	a5,56(s1)
    8000182a:	ff279be3          	bne	a5,s2,80001820 <reparent+0x2c>
      pp->parent = initproc;
    8000182e:	000a3503          	ld	a0,0(s4)
    80001832:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001834:	00000097          	auipc	ra,0x0
    80001838:	f4a080e7          	jalr	-182(ra) # 8000177e <wakeup>
    8000183c:	b7d5                	j	80001820 <reparent+0x2c>
}
    8000183e:	70a2                	ld	ra,40(sp)
    80001840:	7402                	ld	s0,32(sp)
    80001842:	64e2                	ld	s1,24(sp)
    80001844:	6942                	ld	s2,16(sp)
    80001846:	69a2                	ld	s3,8(sp)
    80001848:	6a02                	ld	s4,0(sp)
    8000184a:	6145                	addi	sp,sp,48
    8000184c:	8082                	ret

000000008000184e <exit>:
{
    8000184e:	7179                	addi	sp,sp,-48
    80001850:	f406                	sd	ra,40(sp)
    80001852:	f022                	sd	s0,32(sp)
    80001854:	ec26                	sd	s1,24(sp)
    80001856:	e84a                	sd	s2,16(sp)
    80001858:	e44e                	sd	s3,8(sp)
    8000185a:	e052                	sd	s4,0(sp)
    8000185c:	1800                	addi	s0,sp,48
    8000185e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001860:	00000097          	auipc	ra,0x0
    80001864:	812080e7          	jalr	-2030(ra) # 80001072 <myproc>
    80001868:	89aa                	mv	s3,a0
  if(p == initproc)
    8000186a:	00007797          	auipc	a5,0x7
    8000186e:	0a67b783          	ld	a5,166(a5) # 80008910 <initproc>
    80001872:	0d050493          	addi	s1,a0,208
    80001876:	15050913          	addi	s2,a0,336
    8000187a:	02a79363          	bne	a5,a0,800018a0 <exit+0x52>
    panic("init exiting");
    8000187e:	00007517          	auipc	a0,0x7
    80001882:	9d250513          	addi	a0,a0,-1582 # 80008250 <etext+0x250>
    80001886:	00004097          	auipc	ra,0x4
    8000188a:	4f0080e7          	jalr	1264(ra) # 80005d76 <panic>
      fileclose(f);
    8000188e:	00002097          	auipc	ra,0x2
    80001892:	300080e7          	jalr	768(ra) # 80003b8e <fileclose>
      p->ofile[fd] = 0;
    80001896:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000189a:	04a1                	addi	s1,s1,8
    8000189c:	01248563          	beq	s1,s2,800018a6 <exit+0x58>
    if(p->ofile[fd]){
    800018a0:	6088                	ld	a0,0(s1)
    800018a2:	f575                	bnez	a0,8000188e <exit+0x40>
    800018a4:	bfdd                	j	8000189a <exit+0x4c>
  begin_op();
    800018a6:	00002097          	auipc	ra,0x2
    800018aa:	e24080e7          	jalr	-476(ra) # 800036ca <begin_op>
  iput(p->cwd);
    800018ae:	1509b503          	ld	a0,336(s3)
    800018b2:	00001097          	auipc	ra,0x1
    800018b6:	62c080e7          	jalr	1580(ra) # 80002ede <iput>
  end_op();
    800018ba:	00002097          	auipc	ra,0x2
    800018be:	e8a080e7          	jalr	-374(ra) # 80003744 <end_op>
  p->cwd = 0;
    800018c2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018c6:	00227497          	auipc	s1,0x227
    800018ca:	0a248493          	addi	s1,s1,162 # 80228968 <wait_lock>
    800018ce:	8526                	mv	a0,s1
    800018d0:	00005097          	auipc	ra,0x5
    800018d4:	9de080e7          	jalr	-1570(ra) # 800062ae <acquire>
  reparent(p);
    800018d8:	854e                	mv	a0,s3
    800018da:	00000097          	auipc	ra,0x0
    800018de:	f1a080e7          	jalr	-230(ra) # 800017f4 <reparent>
  wakeup(p->parent);
    800018e2:	0389b503          	ld	a0,56(s3)
    800018e6:	00000097          	auipc	ra,0x0
    800018ea:	e98080e7          	jalr	-360(ra) # 8000177e <wakeup>
  acquire(&p->lock);
    800018ee:	854e                	mv	a0,s3
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	9be080e7          	jalr	-1602(ra) # 800062ae <acquire>
  p->xstate = status;
    800018f8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018fc:	4795                	li	a5,5
    800018fe:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001902:	8526                	mv	a0,s1
    80001904:	00005097          	auipc	ra,0x5
    80001908:	a5e080e7          	jalr	-1442(ra) # 80006362 <release>
  sched();
    8000190c:	00000097          	auipc	ra,0x0
    80001910:	cfc080e7          	jalr	-772(ra) # 80001608 <sched>
  panic("zombie exit");
    80001914:	00007517          	auipc	a0,0x7
    80001918:	94c50513          	addi	a0,a0,-1716 # 80008260 <etext+0x260>
    8000191c:	00004097          	auipc	ra,0x4
    80001920:	45a080e7          	jalr	1114(ra) # 80005d76 <panic>

0000000080001924 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001924:	7179                	addi	sp,sp,-48
    80001926:	f406                	sd	ra,40(sp)
    80001928:	f022                	sd	s0,32(sp)
    8000192a:	ec26                	sd	s1,24(sp)
    8000192c:	e84a                	sd	s2,16(sp)
    8000192e:	e44e                	sd	s3,8(sp)
    80001930:	1800                	addi	s0,sp,48
    80001932:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001934:	00227497          	auipc	s1,0x227
    80001938:	44c48493          	addi	s1,s1,1100 # 80228d80 <proc>
    8000193c:	0022d997          	auipc	s3,0x22d
    80001940:	e4498993          	addi	s3,s3,-444 # 8022e780 <tickslock>
    acquire(&p->lock);
    80001944:	8526                	mv	a0,s1
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	968080e7          	jalr	-1688(ra) # 800062ae <acquire>
    if(p->pid == pid){
    8000194e:	589c                	lw	a5,48(s1)
    80001950:	01278d63          	beq	a5,s2,8000196a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001954:	8526                	mv	a0,s1
    80001956:	00005097          	auipc	ra,0x5
    8000195a:	a0c080e7          	jalr	-1524(ra) # 80006362 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000195e:	16848493          	addi	s1,s1,360
    80001962:	ff3491e3          	bne	s1,s3,80001944 <kill+0x20>
  }
  return -1;
    80001966:	557d                	li	a0,-1
    80001968:	a829                	j	80001982 <kill+0x5e>
      p->killed = 1;
    8000196a:	4785                	li	a5,1
    8000196c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000196e:	4c98                	lw	a4,24(s1)
    80001970:	4789                	li	a5,2
    80001972:	00f70f63          	beq	a4,a5,80001990 <kill+0x6c>
      release(&p->lock);
    80001976:	8526                	mv	a0,s1
    80001978:	00005097          	auipc	ra,0x5
    8000197c:	9ea080e7          	jalr	-1558(ra) # 80006362 <release>
      return 0;
    80001980:	4501                	li	a0,0
}
    80001982:	70a2                	ld	ra,40(sp)
    80001984:	7402                	ld	s0,32(sp)
    80001986:	64e2                	ld	s1,24(sp)
    80001988:	6942                	ld	s2,16(sp)
    8000198a:	69a2                	ld	s3,8(sp)
    8000198c:	6145                	addi	sp,sp,48
    8000198e:	8082                	ret
        p->state = RUNNABLE;
    80001990:	478d                	li	a5,3
    80001992:	cc9c                	sw	a5,24(s1)
    80001994:	b7cd                	j	80001976 <kill+0x52>

0000000080001996 <setkilled>:

void
setkilled(struct proc *p)
{
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	e426                	sd	s1,8(sp)
    8000199e:	1000                	addi	s0,sp,32
    800019a0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019a2:	00005097          	auipc	ra,0x5
    800019a6:	90c080e7          	jalr	-1780(ra) # 800062ae <acquire>
  p->killed = 1;
    800019aa:	4785                	li	a5,1
    800019ac:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019ae:	8526                	mv	a0,s1
    800019b0:	00005097          	auipc	ra,0x5
    800019b4:	9b2080e7          	jalr	-1614(ra) # 80006362 <release>
}
    800019b8:	60e2                	ld	ra,24(sp)
    800019ba:	6442                	ld	s0,16(sp)
    800019bc:	64a2                	ld	s1,8(sp)
    800019be:	6105                	addi	sp,sp,32
    800019c0:	8082                	ret

00000000800019c2 <killed>:

int
killed(struct proc *p)
{
    800019c2:	1101                	addi	sp,sp,-32
    800019c4:	ec06                	sd	ra,24(sp)
    800019c6:	e822                	sd	s0,16(sp)
    800019c8:	e426                	sd	s1,8(sp)
    800019ca:	e04a                	sd	s2,0(sp)
    800019cc:	1000                	addi	s0,sp,32
    800019ce:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800019d0:	00005097          	auipc	ra,0x5
    800019d4:	8de080e7          	jalr	-1826(ra) # 800062ae <acquire>
  k = p->killed;
    800019d8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800019dc:	8526                	mv	a0,s1
    800019de:	00005097          	auipc	ra,0x5
    800019e2:	984080e7          	jalr	-1660(ra) # 80006362 <release>
  return k;
}
    800019e6:	854a                	mv	a0,s2
    800019e8:	60e2                	ld	ra,24(sp)
    800019ea:	6442                	ld	s0,16(sp)
    800019ec:	64a2                	ld	s1,8(sp)
    800019ee:	6902                	ld	s2,0(sp)
    800019f0:	6105                	addi	sp,sp,32
    800019f2:	8082                	ret

00000000800019f4 <wait>:
{
    800019f4:	715d                	addi	sp,sp,-80
    800019f6:	e486                	sd	ra,72(sp)
    800019f8:	e0a2                	sd	s0,64(sp)
    800019fa:	fc26                	sd	s1,56(sp)
    800019fc:	f84a                	sd	s2,48(sp)
    800019fe:	f44e                	sd	s3,40(sp)
    80001a00:	f052                	sd	s4,32(sp)
    80001a02:	ec56                	sd	s5,24(sp)
    80001a04:	e85a                	sd	s6,16(sp)
    80001a06:	e45e                	sd	s7,8(sp)
    80001a08:	e062                	sd	s8,0(sp)
    80001a0a:	0880                	addi	s0,sp,80
    80001a0c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a0e:	fffff097          	auipc	ra,0xfffff
    80001a12:	664080e7          	jalr	1636(ra) # 80001072 <myproc>
    80001a16:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a18:	00227517          	auipc	a0,0x227
    80001a1c:	f5050513          	addi	a0,a0,-176 # 80228968 <wait_lock>
    80001a20:	00005097          	auipc	ra,0x5
    80001a24:	88e080e7          	jalr	-1906(ra) # 800062ae <acquire>
    havekids = 0;
    80001a28:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001a2a:	4a15                	li	s4,5
        havekids = 1;
    80001a2c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a2e:	0022d997          	auipc	s3,0x22d
    80001a32:	d5298993          	addi	s3,s3,-686 # 8022e780 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a36:	00227c17          	auipc	s8,0x227
    80001a3a:	f32c0c13          	addi	s8,s8,-206 # 80228968 <wait_lock>
    80001a3e:	a0d1                	j	80001b02 <wait+0x10e>
          pid = pp->pid;
    80001a40:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a44:	000b0e63          	beqz	s6,80001a60 <wait+0x6c>
    80001a48:	4691                	li	a3,4
    80001a4a:	02c48613          	addi	a2,s1,44
    80001a4e:	85da                	mv	a1,s6
    80001a50:	05093503          	ld	a0,80(s2)
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	398080e7          	jalr	920(ra) # 80000dec <copyout>
    80001a5c:	04054163          	bltz	a0,80001a9e <wait+0xaa>
          freeproc(pp);
    80001a60:	8526                	mv	a0,s1
    80001a62:	fffff097          	auipc	ra,0xfffff
    80001a66:	7c2080e7          	jalr	1986(ra) # 80001224 <freeproc>
          release(&pp->lock);
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	00005097          	auipc	ra,0x5
    80001a70:	8f6080e7          	jalr	-1802(ra) # 80006362 <release>
          release(&wait_lock);
    80001a74:	00227517          	auipc	a0,0x227
    80001a78:	ef450513          	addi	a0,a0,-268 # 80228968 <wait_lock>
    80001a7c:	00005097          	auipc	ra,0x5
    80001a80:	8e6080e7          	jalr	-1818(ra) # 80006362 <release>
}
    80001a84:	854e                	mv	a0,s3
    80001a86:	60a6                	ld	ra,72(sp)
    80001a88:	6406                	ld	s0,64(sp)
    80001a8a:	74e2                	ld	s1,56(sp)
    80001a8c:	7942                	ld	s2,48(sp)
    80001a8e:	79a2                	ld	s3,40(sp)
    80001a90:	7a02                	ld	s4,32(sp)
    80001a92:	6ae2                	ld	s5,24(sp)
    80001a94:	6b42                	ld	s6,16(sp)
    80001a96:	6ba2                	ld	s7,8(sp)
    80001a98:	6c02                	ld	s8,0(sp)
    80001a9a:	6161                	addi	sp,sp,80
    80001a9c:	8082                	ret
            release(&pp->lock);
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	00005097          	auipc	ra,0x5
    80001aa4:	8c2080e7          	jalr	-1854(ra) # 80006362 <release>
            release(&wait_lock);
    80001aa8:	00227517          	auipc	a0,0x227
    80001aac:	ec050513          	addi	a0,a0,-320 # 80228968 <wait_lock>
    80001ab0:	00005097          	auipc	ra,0x5
    80001ab4:	8b2080e7          	jalr	-1870(ra) # 80006362 <release>
            return -1;
    80001ab8:	59fd                	li	s3,-1
    80001aba:	b7e9                	j	80001a84 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001abc:	16848493          	addi	s1,s1,360
    80001ac0:	03348463          	beq	s1,s3,80001ae8 <wait+0xf4>
      if(pp->parent == p){
    80001ac4:	7c9c                	ld	a5,56(s1)
    80001ac6:	ff279be3          	bne	a5,s2,80001abc <wait+0xc8>
        acquire(&pp->lock);
    80001aca:	8526                	mv	a0,s1
    80001acc:	00004097          	auipc	ra,0x4
    80001ad0:	7e2080e7          	jalr	2018(ra) # 800062ae <acquire>
        if(pp->state == ZOMBIE){
    80001ad4:	4c9c                	lw	a5,24(s1)
    80001ad6:	f74785e3          	beq	a5,s4,80001a40 <wait+0x4c>
        release(&pp->lock);
    80001ada:	8526                	mv	a0,s1
    80001adc:	00005097          	auipc	ra,0x5
    80001ae0:	886080e7          	jalr	-1914(ra) # 80006362 <release>
        havekids = 1;
    80001ae4:	8756                	mv	a4,s5
    80001ae6:	bfd9                	j	80001abc <wait+0xc8>
    if(!havekids || killed(p)){
    80001ae8:	c31d                	beqz	a4,80001b0e <wait+0x11a>
    80001aea:	854a                	mv	a0,s2
    80001aec:	00000097          	auipc	ra,0x0
    80001af0:	ed6080e7          	jalr	-298(ra) # 800019c2 <killed>
    80001af4:	ed09                	bnez	a0,80001b0e <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001af6:	85e2                	mv	a1,s8
    80001af8:	854a                	mv	a0,s2
    80001afa:	00000097          	auipc	ra,0x0
    80001afe:	c20080e7          	jalr	-992(ra) # 8000171a <sleep>
    havekids = 0;
    80001b02:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001b04:	00227497          	auipc	s1,0x227
    80001b08:	27c48493          	addi	s1,s1,636 # 80228d80 <proc>
    80001b0c:	bf65                	j	80001ac4 <wait+0xd0>
      release(&wait_lock);
    80001b0e:	00227517          	auipc	a0,0x227
    80001b12:	e5a50513          	addi	a0,a0,-422 # 80228968 <wait_lock>
    80001b16:	00005097          	auipc	ra,0x5
    80001b1a:	84c080e7          	jalr	-1972(ra) # 80006362 <release>
      return -1;
    80001b1e:	59fd                	li	s3,-1
    80001b20:	b795                	j	80001a84 <wait+0x90>

0000000080001b22 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b22:	7179                	addi	sp,sp,-48
    80001b24:	f406                	sd	ra,40(sp)
    80001b26:	f022                	sd	s0,32(sp)
    80001b28:	ec26                	sd	s1,24(sp)
    80001b2a:	e84a                	sd	s2,16(sp)
    80001b2c:	e44e                	sd	s3,8(sp)
    80001b2e:	e052                	sd	s4,0(sp)
    80001b30:	1800                	addi	s0,sp,48
    80001b32:	84aa                	mv	s1,a0
    80001b34:	892e                	mv	s2,a1
    80001b36:	89b2                	mv	s3,a2
    80001b38:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b3a:	fffff097          	auipc	ra,0xfffff
    80001b3e:	538080e7          	jalr	1336(ra) # 80001072 <myproc>
  if(user_dst){
    80001b42:	c08d                	beqz	s1,80001b64 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b44:	86d2                	mv	a3,s4
    80001b46:	864e                	mv	a2,s3
    80001b48:	85ca                	mv	a1,s2
    80001b4a:	6928                	ld	a0,80(a0)
    80001b4c:	fffff097          	auipc	ra,0xfffff
    80001b50:	2a0080e7          	jalr	672(ra) # 80000dec <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b54:	70a2                	ld	ra,40(sp)
    80001b56:	7402                	ld	s0,32(sp)
    80001b58:	64e2                	ld	s1,24(sp)
    80001b5a:	6942                	ld	s2,16(sp)
    80001b5c:	69a2                	ld	s3,8(sp)
    80001b5e:	6a02                	ld	s4,0(sp)
    80001b60:	6145                	addi	sp,sp,48
    80001b62:	8082                	ret
    memmove((char *)dst, src, len);
    80001b64:	000a061b          	sext.w	a2,s4
    80001b68:	85ce                	mv	a1,s3
    80001b6a:	854a                	mv	a0,s2
    80001b6c:	ffffe097          	auipc	ra,0xffffe
    80001b70:	78a080e7          	jalr	1930(ra) # 800002f6 <memmove>
    return 0;
    80001b74:	8526                	mv	a0,s1
    80001b76:	bff9                	j	80001b54 <either_copyout+0x32>

0000000080001b78 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b78:	7179                	addi	sp,sp,-48
    80001b7a:	f406                	sd	ra,40(sp)
    80001b7c:	f022                	sd	s0,32(sp)
    80001b7e:	ec26                	sd	s1,24(sp)
    80001b80:	e84a                	sd	s2,16(sp)
    80001b82:	e44e                	sd	s3,8(sp)
    80001b84:	e052                	sd	s4,0(sp)
    80001b86:	1800                	addi	s0,sp,48
    80001b88:	892a                	mv	s2,a0
    80001b8a:	84ae                	mv	s1,a1
    80001b8c:	89b2                	mv	s3,a2
    80001b8e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b90:	fffff097          	auipc	ra,0xfffff
    80001b94:	4e2080e7          	jalr	1250(ra) # 80001072 <myproc>
  if(user_src){
    80001b98:	c08d                	beqz	s1,80001bba <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b9a:	86d2                	mv	a3,s4
    80001b9c:	864e                	mv	a2,s3
    80001b9e:	85ca                	mv	a1,s2
    80001ba0:	6928                	ld	a0,80(a0)
    80001ba2:	fffff097          	auipc	ra,0xfffff
    80001ba6:	086080e7          	jalr	134(ra) # 80000c28 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001baa:	70a2                	ld	ra,40(sp)
    80001bac:	7402                	ld	s0,32(sp)
    80001bae:	64e2                	ld	s1,24(sp)
    80001bb0:	6942                	ld	s2,16(sp)
    80001bb2:	69a2                	ld	s3,8(sp)
    80001bb4:	6a02                	ld	s4,0(sp)
    80001bb6:	6145                	addi	sp,sp,48
    80001bb8:	8082                	ret
    memmove(dst, (char*)src, len);
    80001bba:	000a061b          	sext.w	a2,s4
    80001bbe:	85ce                	mv	a1,s3
    80001bc0:	854a                	mv	a0,s2
    80001bc2:	ffffe097          	auipc	ra,0xffffe
    80001bc6:	734080e7          	jalr	1844(ra) # 800002f6 <memmove>
    return 0;
    80001bca:	8526                	mv	a0,s1
    80001bcc:	bff9                	j	80001baa <either_copyin+0x32>

0000000080001bce <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bce:	715d                	addi	sp,sp,-80
    80001bd0:	e486                	sd	ra,72(sp)
    80001bd2:	e0a2                	sd	s0,64(sp)
    80001bd4:	fc26                	sd	s1,56(sp)
    80001bd6:	f84a                	sd	s2,48(sp)
    80001bd8:	f44e                	sd	s3,40(sp)
    80001bda:	f052                	sd	s4,32(sp)
    80001bdc:	ec56                	sd	s5,24(sp)
    80001bde:	e85a                	sd	s6,16(sp)
    80001be0:	e45e                	sd	s7,8(sp)
    80001be2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001be4:	00006517          	auipc	a0,0x6
    80001be8:	5bc50513          	addi	a0,a0,1468 # 800081a0 <etext+0x1a0>
    80001bec:	00004097          	auipc	ra,0x4
    80001bf0:	1d4080e7          	jalr	468(ra) # 80005dc0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bf4:	00227497          	auipc	s1,0x227
    80001bf8:	2e448493          	addi	s1,s1,740 # 80228ed8 <proc+0x158>
    80001bfc:	0022d917          	auipc	s2,0x22d
    80001c00:	cdc90913          	addi	s2,s2,-804 # 8022e8d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c04:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c06:	00006997          	auipc	s3,0x6
    80001c0a:	66a98993          	addi	s3,s3,1642 # 80008270 <etext+0x270>
    printf("%d %s %s", p->pid, state, p->name);
    80001c0e:	00006a97          	auipc	s5,0x6
    80001c12:	66aa8a93          	addi	s5,s5,1642 # 80008278 <etext+0x278>
    printf("\n");
    80001c16:	00006a17          	auipc	s4,0x6
    80001c1a:	58aa0a13          	addi	s4,s4,1418 # 800081a0 <etext+0x1a0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c1e:	00006b97          	auipc	s7,0x6
    80001c22:	69ab8b93          	addi	s7,s7,1690 # 800082b8 <states.0>
    80001c26:	a00d                	j	80001c48 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c28:	ed86a583          	lw	a1,-296(a3)
    80001c2c:	8556                	mv	a0,s5
    80001c2e:	00004097          	auipc	ra,0x4
    80001c32:	192080e7          	jalr	402(ra) # 80005dc0 <printf>
    printf("\n");
    80001c36:	8552                	mv	a0,s4
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	188080e7          	jalr	392(ra) # 80005dc0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c40:	16848493          	addi	s1,s1,360
    80001c44:	03248263          	beq	s1,s2,80001c68 <procdump+0x9a>
    if(p->state == UNUSED)
    80001c48:	86a6                	mv	a3,s1
    80001c4a:	ec04a783          	lw	a5,-320(s1)
    80001c4e:	dbed                	beqz	a5,80001c40 <procdump+0x72>
      state = "???";
    80001c50:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c52:	fcfb6be3          	bltu	s6,a5,80001c28 <procdump+0x5a>
    80001c56:	02079713          	slli	a4,a5,0x20
    80001c5a:	01d75793          	srli	a5,a4,0x1d
    80001c5e:	97de                	add	a5,a5,s7
    80001c60:	6390                	ld	a2,0(a5)
    80001c62:	f279                	bnez	a2,80001c28 <procdump+0x5a>
      state = "???";
    80001c64:	864e                	mv	a2,s3
    80001c66:	b7c9                	j	80001c28 <procdump+0x5a>
  }
}
    80001c68:	60a6                	ld	ra,72(sp)
    80001c6a:	6406                	ld	s0,64(sp)
    80001c6c:	74e2                	ld	s1,56(sp)
    80001c6e:	7942                	ld	s2,48(sp)
    80001c70:	79a2                	ld	s3,40(sp)
    80001c72:	7a02                	ld	s4,32(sp)
    80001c74:	6ae2                	ld	s5,24(sp)
    80001c76:	6b42                	ld	s6,16(sp)
    80001c78:	6ba2                	ld	s7,8(sp)
    80001c7a:	6161                	addi	sp,sp,80
    80001c7c:	8082                	ret

0000000080001c7e <swtch>:
    80001c7e:	00153023          	sd	ra,0(a0)
    80001c82:	00253423          	sd	sp,8(a0)
    80001c86:	e900                	sd	s0,16(a0)
    80001c88:	ed04                	sd	s1,24(a0)
    80001c8a:	03253023          	sd	s2,32(a0)
    80001c8e:	03353423          	sd	s3,40(a0)
    80001c92:	03453823          	sd	s4,48(a0)
    80001c96:	03553c23          	sd	s5,56(a0)
    80001c9a:	05653023          	sd	s6,64(a0)
    80001c9e:	05753423          	sd	s7,72(a0)
    80001ca2:	05853823          	sd	s8,80(a0)
    80001ca6:	05953c23          	sd	s9,88(a0)
    80001caa:	07a53023          	sd	s10,96(a0)
    80001cae:	07b53423          	sd	s11,104(a0)
    80001cb2:	0005b083          	ld	ra,0(a1)
    80001cb6:	0085b103          	ld	sp,8(a1)
    80001cba:	6980                	ld	s0,16(a1)
    80001cbc:	6d84                	ld	s1,24(a1)
    80001cbe:	0205b903          	ld	s2,32(a1)
    80001cc2:	0285b983          	ld	s3,40(a1)
    80001cc6:	0305ba03          	ld	s4,48(a1)
    80001cca:	0385ba83          	ld	s5,56(a1)
    80001cce:	0405bb03          	ld	s6,64(a1)
    80001cd2:	0485bb83          	ld	s7,72(a1)
    80001cd6:	0505bc03          	ld	s8,80(a1)
    80001cda:	0585bc83          	ld	s9,88(a1)
    80001cde:	0605bd03          	ld	s10,96(a1)
    80001ce2:	0685bd83          	ld	s11,104(a1)
    80001ce6:	8082                	ret

0000000080001ce8 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001ce8:	1141                	addi	sp,sp,-16
    80001cea:	e406                	sd	ra,8(sp)
    80001cec:	e022                	sd	s0,0(sp)
    80001cee:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001cf0:	00006597          	auipc	a1,0x6
    80001cf4:	5f858593          	addi	a1,a1,1528 # 800082e8 <states.0+0x30>
    80001cf8:	0022d517          	auipc	a0,0x22d
    80001cfc:	a8850513          	addi	a0,a0,-1400 # 8022e780 <tickslock>
    80001d00:	00004097          	auipc	ra,0x4
    80001d04:	51e080e7          	jalr	1310(ra) # 8000621e <initlock>
}
    80001d08:	60a2                	ld	ra,8(sp)
    80001d0a:	6402                	ld	s0,0(sp)
    80001d0c:	0141                	addi	sp,sp,16
    80001d0e:	8082                	ret

0000000080001d10 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001d10:	1141                	addi	sp,sp,-16
    80001d12:	e422                	sd	s0,8(sp)
    80001d14:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0"
    80001d16:	00003797          	auipc	a5,0x3
    80001d1a:	49a78793          	addi	a5,a5,1178 # 800051b0 <kernelvec>
    80001d1e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d22:	6422                	ld	s0,8(sp)
    80001d24:	0141                	addi	sp,sp,16
    80001d26:	8082                	ret

0000000080001d28 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001d28:	1141                	addi	sp,sp,-16
    80001d2a:	e406                	sd	ra,8(sp)
    80001d2c:	e022                	sd	s0,0(sp)
    80001d2e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	342080e7          	jalr	834(ra) # 80001072 <myproc>
  asm volatile("csrr %0, sstatus"
    80001d38:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d3c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0"
    80001d3e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d42:	00005697          	auipc	a3,0x5
    80001d46:	2be68693          	addi	a3,a3,702 # 80007000 <_trampoline>
    80001d4a:	00005717          	auipc	a4,0x5
    80001d4e:	2b670713          	addi	a4,a4,694 # 80007000 <_trampoline>
    80001d52:	8f15                	sub	a4,a4,a3
    80001d54:	040007b7          	lui	a5,0x4000
    80001d58:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d5a:	07b2                	slli	a5,a5,0xc
    80001d5c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0"
    80001d5e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d62:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp"
    80001d64:	18002673          	csrr	a2,satp
    80001d68:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d6a:	6d30                	ld	a2,88(a0)
    80001d6c:	6138                	ld	a4,64(a0)
    80001d6e:	6585                	lui	a1,0x1
    80001d70:	972e                	add	a4,a4,a1
    80001d72:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d74:	6d38                	ld	a4,88(a0)
    80001d76:	00000617          	auipc	a2,0x0
    80001d7a:	13460613          	addi	a2,a2,308 # 80001eaa <usertrap>
    80001d7e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001d80:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp"
    80001d82:	8612                	mv	a2,tp
    80001d84:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus"
    80001d86:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d8a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d8e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0"
    80001d92:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d96:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0"
    80001d98:	6f18                	ld	a4,24(a4)
    80001d9a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d9e:	6928                	ld	a0,80(a0)
    80001da0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001da2:	00005717          	auipc	a4,0x5
    80001da6:	2fa70713          	addi	a4,a4,762 # 8000709c <userret>
    80001daa:	8f15                	sub	a4,a4,a3
    80001dac:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001dae:	577d                	li	a4,-1
    80001db0:	177e                	slli	a4,a4,0x3f
    80001db2:	8d59                	or	a0,a0,a4
    80001db4:	9782                	jalr	a5
}
    80001db6:	60a2                	ld	ra,8(sp)
    80001db8:	6402                	ld	s0,0(sp)
    80001dba:	0141                	addi	sp,sp,16
    80001dbc:	8082                	ret

0000000080001dbe <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	e426                	sd	s1,8(sp)
    80001dc6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001dc8:	0022d497          	auipc	s1,0x22d
    80001dcc:	9b848493          	addi	s1,s1,-1608 # 8022e780 <tickslock>
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	00004097          	auipc	ra,0x4
    80001dd6:	4dc080e7          	jalr	1244(ra) # 800062ae <acquire>
  ticks++;
    80001dda:	00007517          	auipc	a0,0x7
    80001dde:	b3e50513          	addi	a0,a0,-1218 # 80008918 <ticks>
    80001de2:	411c                	lw	a5,0(a0)
    80001de4:	2785                	addiw	a5,a5,1
    80001de6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001de8:	00000097          	auipc	ra,0x0
    80001dec:	996080e7          	jalr	-1642(ra) # 8000177e <wakeup>
  release(&tickslock);
    80001df0:	8526                	mv	a0,s1
    80001df2:	00004097          	auipc	ra,0x4
    80001df6:	570080e7          	jalr	1392(ra) # 80006362 <release>
}
    80001dfa:	60e2                	ld	ra,24(sp)
    80001dfc:	6442                	ld	s0,16(sp)
    80001dfe:	64a2                	ld	s1,8(sp)
    80001e00:	6105                	addi	sp,sp,32
    80001e02:	8082                	ret

0000000080001e04 <devintr>:
  asm volatile("csrr %0, scause"
    80001e04:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80001e08:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80001e0a:	0807df63          	bgez	a5,80001ea8 <devintr+0xa4>
{
    80001e0e:	1101                	addi	sp,sp,-32
    80001e10:	ec06                	sd	ra,24(sp)
    80001e12:	e822                	sd	s0,16(sp)
    80001e14:	e426                	sd	s1,8(sp)
    80001e16:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80001e18:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80001e1c:	46a5                	li	a3,9
    80001e1e:	00d70d63          	beq	a4,a3,80001e38 <devintr+0x34>
  else if (scause == 0x8000000000000001L)
    80001e22:	577d                	li	a4,-1
    80001e24:	177e                	slli	a4,a4,0x3f
    80001e26:	0705                	addi	a4,a4,1
    return 0;
    80001e28:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001e2a:	04e78e63          	beq	a5,a4,80001e86 <devintr+0x82>
  }
}
    80001e2e:	60e2                	ld	ra,24(sp)
    80001e30:	6442                	ld	s0,16(sp)
    80001e32:	64a2                	ld	s1,8(sp)
    80001e34:	6105                	addi	sp,sp,32
    80001e36:	8082                	ret
    int irq = plic_claim();
    80001e38:	00003097          	auipc	ra,0x3
    80001e3c:	480080e7          	jalr	1152(ra) # 800052b8 <plic_claim>
    80001e40:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001e42:	47a9                	li	a5,10
    80001e44:	02f50763          	beq	a0,a5,80001e72 <devintr+0x6e>
    else if (irq == VIRTIO0_IRQ)
    80001e48:	4785                	li	a5,1
    80001e4a:	02f50963          	beq	a0,a5,80001e7c <devintr+0x78>
    return 1;
    80001e4e:	4505                	li	a0,1
    else if (irq)
    80001e50:	dcf9                	beqz	s1,80001e2e <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e52:	85a6                	mv	a1,s1
    80001e54:	00006517          	auipc	a0,0x6
    80001e58:	49c50513          	addi	a0,a0,1180 # 800082f0 <states.0+0x38>
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	f64080e7          	jalr	-156(ra) # 80005dc0 <printf>
      plic_complete(irq);
    80001e64:	8526                	mv	a0,s1
    80001e66:	00003097          	auipc	ra,0x3
    80001e6a:	476080e7          	jalr	1142(ra) # 800052dc <plic_complete>
    return 1;
    80001e6e:	4505                	li	a0,1
    80001e70:	bf7d                	j	80001e2e <devintr+0x2a>
      uartintr();
    80001e72:	00004097          	auipc	ra,0x4
    80001e76:	35c080e7          	jalr	860(ra) # 800061ce <uartintr>
    if (irq)
    80001e7a:	b7ed                	j	80001e64 <devintr+0x60>
      virtio_disk_intr();
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	926080e7          	jalr	-1754(ra) # 800057a2 <virtio_disk_intr>
    if (irq)
    80001e84:	b7c5                	j	80001e64 <devintr+0x60>
    if (cpuid() == 0)
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	1c0080e7          	jalr	448(ra) # 80001046 <cpuid>
    80001e8e:	c901                	beqz	a0,80001e9e <devintr+0x9a>
  asm volatile("csrr %0, sip"
    80001e90:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e94:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0"
    80001e96:	14479073          	csrw	sip,a5
    return 2;
    80001e9a:	4509                	li	a0,2
    80001e9c:	bf49                	j	80001e2e <devintr+0x2a>
      clockintr();
    80001e9e:	00000097          	auipc	ra,0x0
    80001ea2:	f20080e7          	jalr	-224(ra) # 80001dbe <clockintr>
    80001ea6:	b7ed                	j	80001e90 <devintr+0x8c>
}
    80001ea8:	8082                	ret

0000000080001eaa <usertrap>:
{
    80001eaa:	1101                	addi	sp,sp,-32
    80001eac:	ec06                	sd	ra,24(sp)
    80001eae:	e822                	sd	s0,16(sp)
    80001eb0:	e426                	sd	s1,8(sp)
    80001eb2:	e04a                	sd	s2,0(sp)
    80001eb4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus"
    80001eb6:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001eba:	1007f793          	andi	a5,a5,256
    80001ebe:	efad                	bnez	a5,80001f38 <usertrap+0x8e>
  asm volatile("csrw stvec, %0"
    80001ec0:	00003797          	auipc	a5,0x3
    80001ec4:	2f078793          	addi	a5,a5,752 # 800051b0 <kernelvec>
    80001ec8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ecc:	fffff097          	auipc	ra,0xfffff
    80001ed0:	1a6080e7          	jalr	422(ra) # 80001072 <myproc>
    80001ed4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ed6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc"
    80001ed8:	14102773          	csrr	a4,sepc
    80001edc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause"
    80001ede:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001ee2:	47a1                	li	a5,8
    80001ee4:	06f70263          	beq	a4,a5,80001f48 <usertrap+0x9e>
  else if ((which_dev = devintr()) != 0)
    80001ee8:	00000097          	auipc	ra,0x0
    80001eec:	f1c080e7          	jalr	-228(ra) # 80001e04 <devintr>
    80001ef0:	892a                	mv	s2,a0
    80001ef2:	e179                	bnez	a0,80001fb8 <usertrap+0x10e>
    80001ef4:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80001ef8:	47bd                	li	a5,15
    80001efa:	0af70063          	beq	a4,a5,80001f9a <usertrap+0xf0>
    80001efe:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f02:	5890                	lw	a2,48(s1)
    80001f04:	00006517          	auipc	a0,0x6
    80001f08:	42c50513          	addi	a0,a0,1068 # 80008330 <states.0+0x78>
    80001f0c:	00004097          	auipc	ra,0x4
    80001f10:	eb4080e7          	jalr	-332(ra) # 80005dc0 <printf>
  asm volatile("csrr %0, sepc"
    80001f14:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval"
    80001f18:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f1c:	00006517          	auipc	a0,0x6
    80001f20:	44450513          	addi	a0,a0,1092 # 80008360 <states.0+0xa8>
    80001f24:	00004097          	auipc	ra,0x4
    80001f28:	e9c080e7          	jalr	-356(ra) # 80005dc0 <printf>
    setkilled(p);
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	00000097          	auipc	ra,0x0
    80001f32:	a68080e7          	jalr	-1432(ra) # 80001996 <setkilled>
    80001f36:	a825                	j	80001f6e <usertrap+0xc4>
    panic("usertrap: not from user mode");
    80001f38:	00006517          	auipc	a0,0x6
    80001f3c:	3d850513          	addi	a0,a0,984 # 80008310 <states.0+0x58>
    80001f40:	00004097          	auipc	ra,0x4
    80001f44:	e36080e7          	jalr	-458(ra) # 80005d76 <panic>
    if (killed(p))
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	a7a080e7          	jalr	-1414(ra) # 800019c2 <killed>
    80001f50:	ed1d                	bnez	a0,80001f8e <usertrap+0xe4>
    p->trapframe->epc += 4;
    80001f52:	6cb8                	ld	a4,88(s1)
    80001f54:	6f1c                	ld	a5,24(a4)
    80001f56:	0791                	addi	a5,a5,4
    80001f58:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus"
    80001f5a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f5e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    80001f62:	10079073          	csrw	sstatus,a5
    syscall();
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	2c6080e7          	jalr	710(ra) # 8000222c <syscall>
  if (killed(p))
    80001f6e:	8526                	mv	a0,s1
    80001f70:	00000097          	auipc	ra,0x0
    80001f74:	a52080e7          	jalr	-1454(ra) # 800019c2 <killed>
    80001f78:	e539                	bnez	a0,80001fc6 <usertrap+0x11c>
  usertrapret();
    80001f7a:	00000097          	auipc	ra,0x0
    80001f7e:	dae080e7          	jalr	-594(ra) # 80001d28 <usertrapret>
}
    80001f82:	60e2                	ld	ra,24(sp)
    80001f84:	6442                	ld	s0,16(sp)
    80001f86:	64a2                	ld	s1,8(sp)
    80001f88:	6902                	ld	s2,0(sp)
    80001f8a:	6105                	addi	sp,sp,32
    80001f8c:	8082                	ret
      exit(-1);
    80001f8e:	557d                	li	a0,-1
    80001f90:	00000097          	auipc	ra,0x0
    80001f94:	8be080e7          	jalr	-1858(ra) # 8000184e <exit>
    80001f98:	bf6d                	j	80001f52 <usertrap+0xa8>
  asm volatile("csrr %0, stval"
    80001f9a:	143025f3          	csrr	a1,stval
    if (cow_alloc(p->pagetable, va) < 0)
    80001f9e:	68a8                	ld	a0,80(s1)
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	dc6080e7          	jalr	-570(ra) # 80000d66 <cow_alloc>
    80001fa8:	fc0553e3          	bgez	a0,80001f6e <usertrap+0xc4>
      setkilled(p);
    80001fac:	8526                	mv	a0,s1
    80001fae:	00000097          	auipc	ra,0x0
    80001fb2:	9e8080e7          	jalr	-1560(ra) # 80001996 <setkilled>
    80001fb6:	bf65                	j	80001f6e <usertrap+0xc4>
  if (killed(p))
    80001fb8:	8526                	mv	a0,s1
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	a08080e7          	jalr	-1528(ra) # 800019c2 <killed>
    80001fc2:	c901                	beqz	a0,80001fd2 <usertrap+0x128>
    80001fc4:	a011                	j	80001fc8 <usertrap+0x11e>
    80001fc6:	4901                	li	s2,0
    exit(-1);
    80001fc8:	557d                	li	a0,-1
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	884080e7          	jalr	-1916(ra) # 8000184e <exit>
  if (which_dev == 2)
    80001fd2:	4789                	li	a5,2
    80001fd4:	faf913e3          	bne	s2,a5,80001f7a <usertrap+0xd0>
    yield();
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	706080e7          	jalr	1798(ra) # 800016de <yield>
    80001fe0:	bf69                	j	80001f7a <usertrap+0xd0>

0000000080001fe2 <kerneltrap>:
{
    80001fe2:	7179                	addi	sp,sp,-48
    80001fe4:	f406                	sd	ra,40(sp)
    80001fe6:	f022                	sd	s0,32(sp)
    80001fe8:	ec26                	sd	s1,24(sp)
    80001fea:	e84a                	sd	s2,16(sp)
    80001fec:	e44e                	sd	s3,8(sp)
    80001fee:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc"
    80001ff0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus"
    80001ff4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause"
    80001ff8:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001ffc:	1004f793          	andi	a5,s1,256
    80002000:	cb85                	beqz	a5,80002030 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus"
    80002002:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002006:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002008:	ef85                	bnez	a5,80002040 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    8000200a:	00000097          	auipc	ra,0x0
    8000200e:	dfa080e7          	jalr	-518(ra) # 80001e04 <devintr>
    80002012:	cd1d                	beqz	a0,80002050 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002014:	4789                	li	a5,2
    80002016:	06f50a63          	beq	a0,a5,8000208a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0"
    8000201a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0"
    8000201e:	10049073          	csrw	sstatus,s1
}
    80002022:	70a2                	ld	ra,40(sp)
    80002024:	7402                	ld	s0,32(sp)
    80002026:	64e2                	ld	s1,24(sp)
    80002028:	6942                	ld	s2,16(sp)
    8000202a:	69a2                	ld	s3,8(sp)
    8000202c:	6145                	addi	sp,sp,48
    8000202e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002030:	00006517          	auipc	a0,0x6
    80002034:	35050513          	addi	a0,a0,848 # 80008380 <states.0+0xc8>
    80002038:	00004097          	auipc	ra,0x4
    8000203c:	d3e080e7          	jalr	-706(ra) # 80005d76 <panic>
    panic("kerneltrap: interrupts enabled");
    80002040:	00006517          	auipc	a0,0x6
    80002044:	36850513          	addi	a0,a0,872 # 800083a8 <states.0+0xf0>
    80002048:	00004097          	auipc	ra,0x4
    8000204c:	d2e080e7          	jalr	-722(ra) # 80005d76 <panic>
    printf("scause %p\n", scause);
    80002050:	85ce                	mv	a1,s3
    80002052:	00006517          	auipc	a0,0x6
    80002056:	37650513          	addi	a0,a0,886 # 800083c8 <states.0+0x110>
    8000205a:	00004097          	auipc	ra,0x4
    8000205e:	d66080e7          	jalr	-666(ra) # 80005dc0 <printf>
  asm volatile("csrr %0, sepc"
    80002062:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval"
    80002066:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000206a:	00006517          	auipc	a0,0x6
    8000206e:	36e50513          	addi	a0,a0,878 # 800083d8 <states.0+0x120>
    80002072:	00004097          	auipc	ra,0x4
    80002076:	d4e080e7          	jalr	-690(ra) # 80005dc0 <printf>
    panic("kerneltrap");
    8000207a:	00006517          	auipc	a0,0x6
    8000207e:	37650513          	addi	a0,a0,886 # 800083f0 <states.0+0x138>
    80002082:	00004097          	auipc	ra,0x4
    80002086:	cf4080e7          	jalr	-780(ra) # 80005d76 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	fe8080e7          	jalr	-24(ra) # 80001072 <myproc>
    80002092:	d541                	beqz	a0,8000201a <kerneltrap+0x38>
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	fde080e7          	jalr	-34(ra) # 80001072 <myproc>
    8000209c:	4d18                	lw	a4,24(a0)
    8000209e:	4791                	li	a5,4
    800020a0:	f6f71de3          	bne	a4,a5,8000201a <kerneltrap+0x38>
    yield();
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	63a080e7          	jalr	1594(ra) # 800016de <yield>
    800020ac:	b7bd                	j	8000201a <kerneltrap+0x38>

00000000800020ae <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	e426                	sd	s1,8(sp)
    800020b6:	1000                	addi	s0,sp,32
    800020b8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020ba:	fffff097          	auipc	ra,0xfffff
    800020be:	fb8080e7          	jalr	-72(ra) # 80001072 <myproc>
  switch (n) {
    800020c2:	4795                	li	a5,5
    800020c4:	0497e163          	bltu	a5,s1,80002106 <argraw+0x58>
    800020c8:	048a                	slli	s1,s1,0x2
    800020ca:	00006717          	auipc	a4,0x6
    800020ce:	35e70713          	addi	a4,a4,862 # 80008428 <states.0+0x170>
    800020d2:	94ba                	add	s1,s1,a4
    800020d4:	409c                	lw	a5,0(s1)
    800020d6:	97ba                	add	a5,a5,a4
    800020d8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020da:	6d3c                	ld	a5,88(a0)
    800020dc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020de:	60e2                	ld	ra,24(sp)
    800020e0:	6442                	ld	s0,16(sp)
    800020e2:	64a2                	ld	s1,8(sp)
    800020e4:	6105                	addi	sp,sp,32
    800020e6:	8082                	ret
    return p->trapframe->a1;
    800020e8:	6d3c                	ld	a5,88(a0)
    800020ea:	7fa8                	ld	a0,120(a5)
    800020ec:	bfcd                	j	800020de <argraw+0x30>
    return p->trapframe->a2;
    800020ee:	6d3c                	ld	a5,88(a0)
    800020f0:	63c8                	ld	a0,128(a5)
    800020f2:	b7f5                	j	800020de <argraw+0x30>
    return p->trapframe->a3;
    800020f4:	6d3c                	ld	a5,88(a0)
    800020f6:	67c8                	ld	a0,136(a5)
    800020f8:	b7dd                	j	800020de <argraw+0x30>
    return p->trapframe->a4;
    800020fa:	6d3c                	ld	a5,88(a0)
    800020fc:	6bc8                	ld	a0,144(a5)
    800020fe:	b7c5                	j	800020de <argraw+0x30>
    return p->trapframe->a5;
    80002100:	6d3c                	ld	a5,88(a0)
    80002102:	6fc8                	ld	a0,152(a5)
    80002104:	bfe9                	j	800020de <argraw+0x30>
  panic("argraw");
    80002106:	00006517          	auipc	a0,0x6
    8000210a:	2fa50513          	addi	a0,a0,762 # 80008400 <states.0+0x148>
    8000210e:	00004097          	auipc	ra,0x4
    80002112:	c68080e7          	jalr	-920(ra) # 80005d76 <panic>

0000000080002116 <fetchaddr>:
{
    80002116:	1101                	addi	sp,sp,-32
    80002118:	ec06                	sd	ra,24(sp)
    8000211a:	e822                	sd	s0,16(sp)
    8000211c:	e426                	sd	s1,8(sp)
    8000211e:	e04a                	sd	s2,0(sp)
    80002120:	1000                	addi	s0,sp,32
    80002122:	84aa                	mv	s1,a0
    80002124:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	f4c080e7          	jalr	-180(ra) # 80001072 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000212e:	653c                	ld	a5,72(a0)
    80002130:	02f4f863          	bgeu	s1,a5,80002160 <fetchaddr+0x4a>
    80002134:	00848713          	addi	a4,s1,8
    80002138:	02e7e663          	bltu	a5,a4,80002164 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000213c:	46a1                	li	a3,8
    8000213e:	8626                	mv	a2,s1
    80002140:	85ca                	mv	a1,s2
    80002142:	6928                	ld	a0,80(a0)
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	ae4080e7          	jalr	-1308(ra) # 80000c28 <copyin>
    8000214c:	00a03533          	snez	a0,a0
    80002150:	40a00533          	neg	a0,a0
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6902                	ld	s2,0(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret
    return -1;
    80002160:	557d                	li	a0,-1
    80002162:	bfcd                	j	80002154 <fetchaddr+0x3e>
    80002164:	557d                	li	a0,-1
    80002166:	b7fd                	j	80002154 <fetchaddr+0x3e>

0000000080002168 <fetchstr>:
{
    80002168:	7179                	addi	sp,sp,-48
    8000216a:	f406                	sd	ra,40(sp)
    8000216c:	f022                	sd	s0,32(sp)
    8000216e:	ec26                	sd	s1,24(sp)
    80002170:	e84a                	sd	s2,16(sp)
    80002172:	e44e                	sd	s3,8(sp)
    80002174:	1800                	addi	s0,sp,48
    80002176:	892a                	mv	s2,a0
    80002178:	84ae                	mv	s1,a1
    8000217a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	ef6080e7          	jalr	-266(ra) # 80001072 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002184:	86ce                	mv	a3,s3
    80002186:	864a                	mv	a2,s2
    80002188:	85a6                	mv	a1,s1
    8000218a:	6928                	ld	a0,80(a0)
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	b2a080e7          	jalr	-1238(ra) # 80000cb6 <copyinstr>
    80002194:	00054e63          	bltz	a0,800021b0 <fetchstr+0x48>
  return strlen(buf);
    80002198:	8526                	mv	a0,s1
    8000219a:	ffffe097          	auipc	ra,0xffffe
    8000219e:	27a080e7          	jalr	634(ra) # 80000414 <strlen>
}
    800021a2:	70a2                	ld	ra,40(sp)
    800021a4:	7402                	ld	s0,32(sp)
    800021a6:	64e2                	ld	s1,24(sp)
    800021a8:	6942                	ld	s2,16(sp)
    800021aa:	69a2                	ld	s3,8(sp)
    800021ac:	6145                	addi	sp,sp,48
    800021ae:	8082                	ret
    return -1;
    800021b0:	557d                	li	a0,-1
    800021b2:	bfc5                	j	800021a2 <fetchstr+0x3a>

00000000800021b4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800021b4:	1101                	addi	sp,sp,-32
    800021b6:	ec06                	sd	ra,24(sp)
    800021b8:	e822                	sd	s0,16(sp)
    800021ba:	e426                	sd	s1,8(sp)
    800021bc:	1000                	addi	s0,sp,32
    800021be:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021c0:	00000097          	auipc	ra,0x0
    800021c4:	eee080e7          	jalr	-274(ra) # 800020ae <argraw>
    800021c8:	c088                	sw	a0,0(s1)
}
    800021ca:	60e2                	ld	ra,24(sp)
    800021cc:	6442                	ld	s0,16(sp)
    800021ce:	64a2                	ld	s1,8(sp)
    800021d0:	6105                	addi	sp,sp,32
    800021d2:	8082                	ret

00000000800021d4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800021d4:	1101                	addi	sp,sp,-32
    800021d6:	ec06                	sd	ra,24(sp)
    800021d8:	e822                	sd	s0,16(sp)
    800021da:	e426                	sd	s1,8(sp)
    800021dc:	1000                	addi	s0,sp,32
    800021de:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021e0:	00000097          	auipc	ra,0x0
    800021e4:	ece080e7          	jalr	-306(ra) # 800020ae <argraw>
    800021e8:	e088                	sd	a0,0(s1)
}
    800021ea:	60e2                	ld	ra,24(sp)
    800021ec:	6442                	ld	s0,16(sp)
    800021ee:	64a2                	ld	s1,8(sp)
    800021f0:	6105                	addi	sp,sp,32
    800021f2:	8082                	ret

00000000800021f4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021f4:	7179                	addi	sp,sp,-48
    800021f6:	f406                	sd	ra,40(sp)
    800021f8:	f022                	sd	s0,32(sp)
    800021fa:	ec26                	sd	s1,24(sp)
    800021fc:	e84a                	sd	s2,16(sp)
    800021fe:	1800                	addi	s0,sp,48
    80002200:	84ae                	mv	s1,a1
    80002202:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002204:	fd840593          	addi	a1,s0,-40
    80002208:	00000097          	auipc	ra,0x0
    8000220c:	fcc080e7          	jalr	-52(ra) # 800021d4 <argaddr>
  return fetchstr(addr, buf, max);
    80002210:	864a                	mv	a2,s2
    80002212:	85a6                	mv	a1,s1
    80002214:	fd843503          	ld	a0,-40(s0)
    80002218:	00000097          	auipc	ra,0x0
    8000221c:	f50080e7          	jalr	-176(ra) # 80002168 <fetchstr>
}
    80002220:	70a2                	ld	ra,40(sp)
    80002222:	7402                	ld	s0,32(sp)
    80002224:	64e2                	ld	s1,24(sp)
    80002226:	6942                	ld	s2,16(sp)
    80002228:	6145                	addi	sp,sp,48
    8000222a:	8082                	ret

000000008000222c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000222c:	1101                	addi	sp,sp,-32
    8000222e:	ec06                	sd	ra,24(sp)
    80002230:	e822                	sd	s0,16(sp)
    80002232:	e426                	sd	s1,8(sp)
    80002234:	e04a                	sd	s2,0(sp)
    80002236:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	e3a080e7          	jalr	-454(ra) # 80001072 <myproc>
    80002240:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002242:	05853903          	ld	s2,88(a0)
    80002246:	0a893783          	ld	a5,168(s2)
    8000224a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000224e:	37fd                	addiw	a5,a5,-1
    80002250:	4751                	li	a4,20
    80002252:	00f76f63          	bltu	a4,a5,80002270 <syscall+0x44>
    80002256:	00369713          	slli	a4,a3,0x3
    8000225a:	00006797          	auipc	a5,0x6
    8000225e:	1e678793          	addi	a5,a5,486 # 80008440 <syscalls>
    80002262:	97ba                	add	a5,a5,a4
    80002264:	639c                	ld	a5,0(a5)
    80002266:	c789                	beqz	a5,80002270 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002268:	9782                	jalr	a5
    8000226a:	06a93823          	sd	a0,112(s2)
    8000226e:	a839                	j	8000228c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002270:	15848613          	addi	a2,s1,344
    80002274:	588c                	lw	a1,48(s1)
    80002276:	00006517          	auipc	a0,0x6
    8000227a:	19250513          	addi	a0,a0,402 # 80008408 <states.0+0x150>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	b42080e7          	jalr	-1214(ra) # 80005dc0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002286:	6cbc                	ld	a5,88(s1)
    80002288:	577d                	li	a4,-1
    8000228a:	fbb8                	sd	a4,112(a5)
  }
}
    8000228c:	60e2                	ld	ra,24(sp)
    8000228e:	6442                	ld	s0,16(sp)
    80002290:	64a2                	ld	s1,8(sp)
    80002292:	6902                	ld	s2,0(sp)
    80002294:	6105                	addi	sp,sp,32
    80002296:	8082                	ret

0000000080002298 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002298:	1101                	addi	sp,sp,-32
    8000229a:	ec06                	sd	ra,24(sp)
    8000229c:	e822                	sd	s0,16(sp)
    8000229e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800022a0:	fec40593          	addi	a1,s0,-20
    800022a4:	4501                	li	a0,0
    800022a6:	00000097          	auipc	ra,0x0
    800022aa:	f0e080e7          	jalr	-242(ra) # 800021b4 <argint>
  exit(n);
    800022ae:	fec42503          	lw	a0,-20(s0)
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	59c080e7          	jalr	1436(ra) # 8000184e <exit>
  return 0;  // not reached
}
    800022ba:	4501                	li	a0,0
    800022bc:	60e2                	ld	ra,24(sp)
    800022be:	6442                	ld	s0,16(sp)
    800022c0:	6105                	addi	sp,sp,32
    800022c2:	8082                	ret

00000000800022c4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800022c4:	1141                	addi	sp,sp,-16
    800022c6:	e406                	sd	ra,8(sp)
    800022c8:	e022                	sd	s0,0(sp)
    800022ca:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022cc:	fffff097          	auipc	ra,0xfffff
    800022d0:	da6080e7          	jalr	-602(ra) # 80001072 <myproc>
}
    800022d4:	5908                	lw	a0,48(a0)
    800022d6:	60a2                	ld	ra,8(sp)
    800022d8:	6402                	ld	s0,0(sp)
    800022da:	0141                	addi	sp,sp,16
    800022dc:	8082                	ret

00000000800022de <sys_fork>:

uint64
sys_fork(void)
{
    800022de:	1141                	addi	sp,sp,-16
    800022e0:	e406                	sd	ra,8(sp)
    800022e2:	e022                	sd	s0,0(sp)
    800022e4:	0800                	addi	s0,sp,16
  return fork();
    800022e6:	fffff097          	auipc	ra,0xfffff
    800022ea:	142080e7          	jalr	322(ra) # 80001428 <fork>
}
    800022ee:	60a2                	ld	ra,8(sp)
    800022f0:	6402                	ld	s0,0(sp)
    800022f2:	0141                	addi	sp,sp,16
    800022f4:	8082                	ret

00000000800022f6 <sys_wait>:

uint64
sys_wait(void)
{
    800022f6:	1101                	addi	sp,sp,-32
    800022f8:	ec06                	sd	ra,24(sp)
    800022fa:	e822                	sd	s0,16(sp)
    800022fc:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800022fe:	fe840593          	addi	a1,s0,-24
    80002302:	4501                	li	a0,0
    80002304:	00000097          	auipc	ra,0x0
    80002308:	ed0080e7          	jalr	-304(ra) # 800021d4 <argaddr>
  return wait(p);
    8000230c:	fe843503          	ld	a0,-24(s0)
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	6e4080e7          	jalr	1764(ra) # 800019f4 <wait>
}
    80002318:	60e2                	ld	ra,24(sp)
    8000231a:	6442                	ld	s0,16(sp)
    8000231c:	6105                	addi	sp,sp,32
    8000231e:	8082                	ret

0000000080002320 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002320:	7179                	addi	sp,sp,-48
    80002322:	f406                	sd	ra,40(sp)
    80002324:	f022                	sd	s0,32(sp)
    80002326:	ec26                	sd	s1,24(sp)
    80002328:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000232a:	fdc40593          	addi	a1,s0,-36
    8000232e:	4501                	li	a0,0
    80002330:	00000097          	auipc	ra,0x0
    80002334:	e84080e7          	jalr	-380(ra) # 800021b4 <argint>
  addr = myproc()->sz;
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	d3a080e7          	jalr	-710(ra) # 80001072 <myproc>
    80002340:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002342:	fdc42503          	lw	a0,-36(s0)
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	086080e7          	jalr	134(ra) # 800013cc <growproc>
    8000234e:	00054863          	bltz	a0,8000235e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002352:	8526                	mv	a0,s1
    80002354:	70a2                	ld	ra,40(sp)
    80002356:	7402                	ld	s0,32(sp)
    80002358:	64e2                	ld	s1,24(sp)
    8000235a:	6145                	addi	sp,sp,48
    8000235c:	8082                	ret
    return -1;
    8000235e:	54fd                	li	s1,-1
    80002360:	bfcd                	j	80002352 <sys_sbrk+0x32>

0000000080002362 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002362:	7139                	addi	sp,sp,-64
    80002364:	fc06                	sd	ra,56(sp)
    80002366:	f822                	sd	s0,48(sp)
    80002368:	f426                	sd	s1,40(sp)
    8000236a:	f04a                	sd	s2,32(sp)
    8000236c:	ec4e                	sd	s3,24(sp)
    8000236e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002370:	fcc40593          	addi	a1,s0,-52
    80002374:	4501                	li	a0,0
    80002376:	00000097          	auipc	ra,0x0
    8000237a:	e3e080e7          	jalr	-450(ra) # 800021b4 <argint>
  if(n < 0)
    8000237e:	fcc42783          	lw	a5,-52(s0)
    80002382:	0607cf63          	bltz	a5,80002400 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002386:	0022c517          	auipc	a0,0x22c
    8000238a:	3fa50513          	addi	a0,a0,1018 # 8022e780 <tickslock>
    8000238e:	00004097          	auipc	ra,0x4
    80002392:	f20080e7          	jalr	-224(ra) # 800062ae <acquire>
  ticks0 = ticks;
    80002396:	00006917          	auipc	s2,0x6
    8000239a:	58292903          	lw	s2,1410(s2) # 80008918 <ticks>
  while(ticks - ticks0 < n){
    8000239e:	fcc42783          	lw	a5,-52(s0)
    800023a2:	cf9d                	beqz	a5,800023e0 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023a4:	0022c997          	auipc	s3,0x22c
    800023a8:	3dc98993          	addi	s3,s3,988 # 8022e780 <tickslock>
    800023ac:	00006497          	auipc	s1,0x6
    800023b0:	56c48493          	addi	s1,s1,1388 # 80008918 <ticks>
    if(killed(myproc())){
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	cbe080e7          	jalr	-834(ra) # 80001072 <myproc>
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	606080e7          	jalr	1542(ra) # 800019c2 <killed>
    800023c4:	e129                	bnez	a0,80002406 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800023c6:	85ce                	mv	a1,s3
    800023c8:	8526                	mv	a0,s1
    800023ca:	fffff097          	auipc	ra,0xfffff
    800023ce:	350080e7          	jalr	848(ra) # 8000171a <sleep>
  while(ticks - ticks0 < n){
    800023d2:	409c                	lw	a5,0(s1)
    800023d4:	412787bb          	subw	a5,a5,s2
    800023d8:	fcc42703          	lw	a4,-52(s0)
    800023dc:	fce7ece3          	bltu	a5,a4,800023b4 <sys_sleep+0x52>
  }
  release(&tickslock);
    800023e0:	0022c517          	auipc	a0,0x22c
    800023e4:	3a050513          	addi	a0,a0,928 # 8022e780 <tickslock>
    800023e8:	00004097          	auipc	ra,0x4
    800023ec:	f7a080e7          	jalr	-134(ra) # 80006362 <release>
  return 0;
    800023f0:	4501                	li	a0,0
}
    800023f2:	70e2                	ld	ra,56(sp)
    800023f4:	7442                	ld	s0,48(sp)
    800023f6:	74a2                	ld	s1,40(sp)
    800023f8:	7902                	ld	s2,32(sp)
    800023fa:	69e2                	ld	s3,24(sp)
    800023fc:	6121                	addi	sp,sp,64
    800023fe:	8082                	ret
    n = 0;
    80002400:	fc042623          	sw	zero,-52(s0)
    80002404:	b749                	j	80002386 <sys_sleep+0x24>
      release(&tickslock);
    80002406:	0022c517          	auipc	a0,0x22c
    8000240a:	37a50513          	addi	a0,a0,890 # 8022e780 <tickslock>
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	f54080e7          	jalr	-172(ra) # 80006362 <release>
      return -1;
    80002416:	557d                	li	a0,-1
    80002418:	bfe9                	j	800023f2 <sys_sleep+0x90>

000000008000241a <sys_kill>:

uint64
sys_kill(void)
{
    8000241a:	1101                	addi	sp,sp,-32
    8000241c:	ec06                	sd	ra,24(sp)
    8000241e:	e822                	sd	s0,16(sp)
    80002420:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002422:	fec40593          	addi	a1,s0,-20
    80002426:	4501                	li	a0,0
    80002428:	00000097          	auipc	ra,0x0
    8000242c:	d8c080e7          	jalr	-628(ra) # 800021b4 <argint>
  return kill(pid);
    80002430:	fec42503          	lw	a0,-20(s0)
    80002434:	fffff097          	auipc	ra,0xfffff
    80002438:	4f0080e7          	jalr	1264(ra) # 80001924 <kill>
}
    8000243c:	60e2                	ld	ra,24(sp)
    8000243e:	6442                	ld	s0,16(sp)
    80002440:	6105                	addi	sp,sp,32
    80002442:	8082                	ret

0000000080002444 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002444:	1101                	addi	sp,sp,-32
    80002446:	ec06                	sd	ra,24(sp)
    80002448:	e822                	sd	s0,16(sp)
    8000244a:	e426                	sd	s1,8(sp)
    8000244c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000244e:	0022c517          	auipc	a0,0x22c
    80002452:	33250513          	addi	a0,a0,818 # 8022e780 <tickslock>
    80002456:	00004097          	auipc	ra,0x4
    8000245a:	e58080e7          	jalr	-424(ra) # 800062ae <acquire>
  xticks = ticks;
    8000245e:	00006497          	auipc	s1,0x6
    80002462:	4ba4a483          	lw	s1,1210(s1) # 80008918 <ticks>
  release(&tickslock);
    80002466:	0022c517          	auipc	a0,0x22c
    8000246a:	31a50513          	addi	a0,a0,794 # 8022e780 <tickslock>
    8000246e:	00004097          	auipc	ra,0x4
    80002472:	ef4080e7          	jalr	-268(ra) # 80006362 <release>
  return xticks;
}
    80002476:	02049513          	slli	a0,s1,0x20
    8000247a:	9101                	srli	a0,a0,0x20
    8000247c:	60e2                	ld	ra,24(sp)
    8000247e:	6442                	ld	s0,16(sp)
    80002480:	64a2                	ld	s1,8(sp)
    80002482:	6105                	addi	sp,sp,32
    80002484:	8082                	ret

0000000080002486 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002486:	7179                	addi	sp,sp,-48
    80002488:	f406                	sd	ra,40(sp)
    8000248a:	f022                	sd	s0,32(sp)
    8000248c:	ec26                	sd	s1,24(sp)
    8000248e:	e84a                	sd	s2,16(sp)
    80002490:	e44e                	sd	s3,8(sp)
    80002492:	e052                	sd	s4,0(sp)
    80002494:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002496:	00006597          	auipc	a1,0x6
    8000249a:	05a58593          	addi	a1,a1,90 # 800084f0 <syscalls+0xb0>
    8000249e:	0022c517          	auipc	a0,0x22c
    800024a2:	2fa50513          	addi	a0,a0,762 # 8022e798 <bcache>
    800024a6:	00004097          	auipc	ra,0x4
    800024aa:	d78080e7          	jalr	-648(ra) # 8000621e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024ae:	00234797          	auipc	a5,0x234
    800024b2:	2ea78793          	addi	a5,a5,746 # 80236798 <bcache+0x8000>
    800024b6:	00234717          	auipc	a4,0x234
    800024ba:	54a70713          	addi	a4,a4,1354 # 80236a00 <bcache+0x8268>
    800024be:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024c2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024c6:	0022c497          	auipc	s1,0x22c
    800024ca:	2ea48493          	addi	s1,s1,746 # 8022e7b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024ce:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024d0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024d2:	00006a17          	auipc	s4,0x6
    800024d6:	026a0a13          	addi	s4,s4,38 # 800084f8 <syscalls+0xb8>
    b->next = bcache.head.next;
    800024da:	2b893783          	ld	a5,696(s2)
    800024de:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024e0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024e4:	85d2                	mv	a1,s4
    800024e6:	01048513          	addi	a0,s1,16
    800024ea:	00001097          	auipc	ra,0x1
    800024ee:	496080e7          	jalr	1174(ra) # 80003980 <initsleeplock>
    bcache.head.next->prev = b;
    800024f2:	2b893783          	ld	a5,696(s2)
    800024f6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024f8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024fc:	45848493          	addi	s1,s1,1112
    80002500:	fd349de3          	bne	s1,s3,800024da <binit+0x54>
  }
}
    80002504:	70a2                	ld	ra,40(sp)
    80002506:	7402                	ld	s0,32(sp)
    80002508:	64e2                	ld	s1,24(sp)
    8000250a:	6942                	ld	s2,16(sp)
    8000250c:	69a2                	ld	s3,8(sp)
    8000250e:	6a02                	ld	s4,0(sp)
    80002510:	6145                	addi	sp,sp,48
    80002512:	8082                	ret

0000000080002514 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002514:	7179                	addi	sp,sp,-48
    80002516:	f406                	sd	ra,40(sp)
    80002518:	f022                	sd	s0,32(sp)
    8000251a:	ec26                	sd	s1,24(sp)
    8000251c:	e84a                	sd	s2,16(sp)
    8000251e:	e44e                	sd	s3,8(sp)
    80002520:	1800                	addi	s0,sp,48
    80002522:	892a                	mv	s2,a0
    80002524:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002526:	0022c517          	auipc	a0,0x22c
    8000252a:	27250513          	addi	a0,a0,626 # 8022e798 <bcache>
    8000252e:	00004097          	auipc	ra,0x4
    80002532:	d80080e7          	jalr	-640(ra) # 800062ae <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002536:	00234497          	auipc	s1,0x234
    8000253a:	51a4b483          	ld	s1,1306(s1) # 80236a50 <bcache+0x82b8>
    8000253e:	00234797          	auipc	a5,0x234
    80002542:	4c278793          	addi	a5,a5,1218 # 80236a00 <bcache+0x8268>
    80002546:	02f48f63          	beq	s1,a5,80002584 <bread+0x70>
    8000254a:	873e                	mv	a4,a5
    8000254c:	a021                	j	80002554 <bread+0x40>
    8000254e:	68a4                	ld	s1,80(s1)
    80002550:	02e48a63          	beq	s1,a4,80002584 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002554:	449c                	lw	a5,8(s1)
    80002556:	ff279ce3          	bne	a5,s2,8000254e <bread+0x3a>
    8000255a:	44dc                	lw	a5,12(s1)
    8000255c:	ff3799e3          	bne	a5,s3,8000254e <bread+0x3a>
      b->refcnt++;
    80002560:	40bc                	lw	a5,64(s1)
    80002562:	2785                	addiw	a5,a5,1
    80002564:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002566:	0022c517          	auipc	a0,0x22c
    8000256a:	23250513          	addi	a0,a0,562 # 8022e798 <bcache>
    8000256e:	00004097          	auipc	ra,0x4
    80002572:	df4080e7          	jalr	-524(ra) # 80006362 <release>
      acquiresleep(&b->lock);
    80002576:	01048513          	addi	a0,s1,16
    8000257a:	00001097          	auipc	ra,0x1
    8000257e:	440080e7          	jalr	1088(ra) # 800039ba <acquiresleep>
      return b;
    80002582:	a8b9                	j	800025e0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002584:	00234497          	auipc	s1,0x234
    80002588:	4c44b483          	ld	s1,1220(s1) # 80236a48 <bcache+0x82b0>
    8000258c:	00234797          	auipc	a5,0x234
    80002590:	47478793          	addi	a5,a5,1140 # 80236a00 <bcache+0x8268>
    80002594:	00f48863          	beq	s1,a5,800025a4 <bread+0x90>
    80002598:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000259a:	40bc                	lw	a5,64(s1)
    8000259c:	cf81                	beqz	a5,800025b4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000259e:	64a4                	ld	s1,72(s1)
    800025a0:	fee49de3          	bne	s1,a4,8000259a <bread+0x86>
  panic("bget: no buffers");
    800025a4:	00006517          	auipc	a0,0x6
    800025a8:	f5c50513          	addi	a0,a0,-164 # 80008500 <syscalls+0xc0>
    800025ac:	00003097          	auipc	ra,0x3
    800025b0:	7ca080e7          	jalr	1994(ra) # 80005d76 <panic>
      b->dev = dev;
    800025b4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025b8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025bc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025c0:	4785                	li	a5,1
    800025c2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025c4:	0022c517          	auipc	a0,0x22c
    800025c8:	1d450513          	addi	a0,a0,468 # 8022e798 <bcache>
    800025cc:	00004097          	auipc	ra,0x4
    800025d0:	d96080e7          	jalr	-618(ra) # 80006362 <release>
      acquiresleep(&b->lock);
    800025d4:	01048513          	addi	a0,s1,16
    800025d8:	00001097          	auipc	ra,0x1
    800025dc:	3e2080e7          	jalr	994(ra) # 800039ba <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025e0:	409c                	lw	a5,0(s1)
    800025e2:	cb89                	beqz	a5,800025f4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025e4:	8526                	mv	a0,s1
    800025e6:	70a2                	ld	ra,40(sp)
    800025e8:	7402                	ld	s0,32(sp)
    800025ea:	64e2                	ld	s1,24(sp)
    800025ec:	6942                	ld	s2,16(sp)
    800025ee:	69a2                	ld	s3,8(sp)
    800025f0:	6145                	addi	sp,sp,48
    800025f2:	8082                	ret
    virtio_disk_rw(b, 0);
    800025f4:	4581                	li	a1,0
    800025f6:	8526                	mv	a0,s1
    800025f8:	00003097          	auipc	ra,0x3
    800025fc:	f7a080e7          	jalr	-134(ra) # 80005572 <virtio_disk_rw>
    b->valid = 1;
    80002600:	4785                	li	a5,1
    80002602:	c09c                	sw	a5,0(s1)
  return b;
    80002604:	b7c5                	j	800025e4 <bread+0xd0>

0000000080002606 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002606:	1101                	addi	sp,sp,-32
    80002608:	ec06                	sd	ra,24(sp)
    8000260a:	e822                	sd	s0,16(sp)
    8000260c:	e426                	sd	s1,8(sp)
    8000260e:	1000                	addi	s0,sp,32
    80002610:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002612:	0541                	addi	a0,a0,16
    80002614:	00001097          	auipc	ra,0x1
    80002618:	440080e7          	jalr	1088(ra) # 80003a54 <holdingsleep>
    8000261c:	cd01                	beqz	a0,80002634 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000261e:	4585                	li	a1,1
    80002620:	8526                	mv	a0,s1
    80002622:	00003097          	auipc	ra,0x3
    80002626:	f50080e7          	jalr	-176(ra) # 80005572 <virtio_disk_rw>
}
    8000262a:	60e2                	ld	ra,24(sp)
    8000262c:	6442                	ld	s0,16(sp)
    8000262e:	64a2                	ld	s1,8(sp)
    80002630:	6105                	addi	sp,sp,32
    80002632:	8082                	ret
    panic("bwrite");
    80002634:	00006517          	auipc	a0,0x6
    80002638:	ee450513          	addi	a0,a0,-284 # 80008518 <syscalls+0xd8>
    8000263c:	00003097          	auipc	ra,0x3
    80002640:	73a080e7          	jalr	1850(ra) # 80005d76 <panic>

0000000080002644 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002644:	1101                	addi	sp,sp,-32
    80002646:	ec06                	sd	ra,24(sp)
    80002648:	e822                	sd	s0,16(sp)
    8000264a:	e426                	sd	s1,8(sp)
    8000264c:	e04a                	sd	s2,0(sp)
    8000264e:	1000                	addi	s0,sp,32
    80002650:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002652:	01050913          	addi	s2,a0,16
    80002656:	854a                	mv	a0,s2
    80002658:	00001097          	auipc	ra,0x1
    8000265c:	3fc080e7          	jalr	1020(ra) # 80003a54 <holdingsleep>
    80002660:	c925                	beqz	a0,800026d0 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002662:	854a                	mv	a0,s2
    80002664:	00001097          	auipc	ra,0x1
    80002668:	3ac080e7          	jalr	940(ra) # 80003a10 <releasesleep>

  acquire(&bcache.lock);
    8000266c:	0022c517          	auipc	a0,0x22c
    80002670:	12c50513          	addi	a0,a0,300 # 8022e798 <bcache>
    80002674:	00004097          	auipc	ra,0x4
    80002678:	c3a080e7          	jalr	-966(ra) # 800062ae <acquire>
  b->refcnt--;
    8000267c:	40bc                	lw	a5,64(s1)
    8000267e:	37fd                	addiw	a5,a5,-1
    80002680:	0007871b          	sext.w	a4,a5
    80002684:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002686:	e71d                	bnez	a4,800026b4 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002688:	68b8                	ld	a4,80(s1)
    8000268a:	64bc                	ld	a5,72(s1)
    8000268c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000268e:	68b8                	ld	a4,80(s1)
    80002690:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002692:	00234797          	auipc	a5,0x234
    80002696:	10678793          	addi	a5,a5,262 # 80236798 <bcache+0x8000>
    8000269a:	2b87b703          	ld	a4,696(a5)
    8000269e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026a0:	00234717          	auipc	a4,0x234
    800026a4:	36070713          	addi	a4,a4,864 # 80236a00 <bcache+0x8268>
    800026a8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026aa:	2b87b703          	ld	a4,696(a5)
    800026ae:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026b0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026b4:	0022c517          	auipc	a0,0x22c
    800026b8:	0e450513          	addi	a0,a0,228 # 8022e798 <bcache>
    800026bc:	00004097          	auipc	ra,0x4
    800026c0:	ca6080e7          	jalr	-858(ra) # 80006362 <release>
}
    800026c4:	60e2                	ld	ra,24(sp)
    800026c6:	6442                	ld	s0,16(sp)
    800026c8:	64a2                	ld	s1,8(sp)
    800026ca:	6902                	ld	s2,0(sp)
    800026cc:	6105                	addi	sp,sp,32
    800026ce:	8082                	ret
    panic("brelse");
    800026d0:	00006517          	auipc	a0,0x6
    800026d4:	e5050513          	addi	a0,a0,-432 # 80008520 <syscalls+0xe0>
    800026d8:	00003097          	auipc	ra,0x3
    800026dc:	69e080e7          	jalr	1694(ra) # 80005d76 <panic>

00000000800026e0 <bpin>:

void
bpin(struct buf *b) {
    800026e0:	1101                	addi	sp,sp,-32
    800026e2:	ec06                	sd	ra,24(sp)
    800026e4:	e822                	sd	s0,16(sp)
    800026e6:	e426                	sd	s1,8(sp)
    800026e8:	1000                	addi	s0,sp,32
    800026ea:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026ec:	0022c517          	auipc	a0,0x22c
    800026f0:	0ac50513          	addi	a0,a0,172 # 8022e798 <bcache>
    800026f4:	00004097          	auipc	ra,0x4
    800026f8:	bba080e7          	jalr	-1094(ra) # 800062ae <acquire>
  b->refcnt++;
    800026fc:	40bc                	lw	a5,64(s1)
    800026fe:	2785                	addiw	a5,a5,1
    80002700:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002702:	0022c517          	auipc	a0,0x22c
    80002706:	09650513          	addi	a0,a0,150 # 8022e798 <bcache>
    8000270a:	00004097          	auipc	ra,0x4
    8000270e:	c58080e7          	jalr	-936(ra) # 80006362 <release>
}
    80002712:	60e2                	ld	ra,24(sp)
    80002714:	6442                	ld	s0,16(sp)
    80002716:	64a2                	ld	s1,8(sp)
    80002718:	6105                	addi	sp,sp,32
    8000271a:	8082                	ret

000000008000271c <bunpin>:

void
bunpin(struct buf *b) {
    8000271c:	1101                	addi	sp,sp,-32
    8000271e:	ec06                	sd	ra,24(sp)
    80002720:	e822                	sd	s0,16(sp)
    80002722:	e426                	sd	s1,8(sp)
    80002724:	1000                	addi	s0,sp,32
    80002726:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002728:	0022c517          	auipc	a0,0x22c
    8000272c:	07050513          	addi	a0,a0,112 # 8022e798 <bcache>
    80002730:	00004097          	auipc	ra,0x4
    80002734:	b7e080e7          	jalr	-1154(ra) # 800062ae <acquire>
  b->refcnt--;
    80002738:	40bc                	lw	a5,64(s1)
    8000273a:	37fd                	addiw	a5,a5,-1
    8000273c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000273e:	0022c517          	auipc	a0,0x22c
    80002742:	05a50513          	addi	a0,a0,90 # 8022e798 <bcache>
    80002746:	00004097          	auipc	ra,0x4
    8000274a:	c1c080e7          	jalr	-996(ra) # 80006362 <release>
}
    8000274e:	60e2                	ld	ra,24(sp)
    80002750:	6442                	ld	s0,16(sp)
    80002752:	64a2                	ld	s1,8(sp)
    80002754:	6105                	addi	sp,sp,32
    80002756:	8082                	ret

0000000080002758 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002758:	1101                	addi	sp,sp,-32
    8000275a:	ec06                	sd	ra,24(sp)
    8000275c:	e822                	sd	s0,16(sp)
    8000275e:	e426                	sd	s1,8(sp)
    80002760:	e04a                	sd	s2,0(sp)
    80002762:	1000                	addi	s0,sp,32
    80002764:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002766:	00d5d59b          	srliw	a1,a1,0xd
    8000276a:	00234797          	auipc	a5,0x234
    8000276e:	70a7a783          	lw	a5,1802(a5) # 80236e74 <sb+0x1c>
    80002772:	9dbd                	addw	a1,a1,a5
    80002774:	00000097          	auipc	ra,0x0
    80002778:	da0080e7          	jalr	-608(ra) # 80002514 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000277c:	0074f713          	andi	a4,s1,7
    80002780:	4785                	li	a5,1
    80002782:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002786:	14ce                	slli	s1,s1,0x33
    80002788:	90d9                	srli	s1,s1,0x36
    8000278a:	00950733          	add	a4,a0,s1
    8000278e:	05874703          	lbu	a4,88(a4)
    80002792:	00e7f6b3          	and	a3,a5,a4
    80002796:	c69d                	beqz	a3,800027c4 <bfree+0x6c>
    80002798:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000279a:	94aa                	add	s1,s1,a0
    8000279c:	fff7c793          	not	a5,a5
    800027a0:	8f7d                	and	a4,a4,a5
    800027a2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800027a6:	00001097          	auipc	ra,0x1
    800027aa:	0f6080e7          	jalr	246(ra) # 8000389c <log_write>
  brelse(bp);
    800027ae:	854a                	mv	a0,s2
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	e94080e7          	jalr	-364(ra) # 80002644 <brelse>
}
    800027b8:	60e2                	ld	ra,24(sp)
    800027ba:	6442                	ld	s0,16(sp)
    800027bc:	64a2                	ld	s1,8(sp)
    800027be:	6902                	ld	s2,0(sp)
    800027c0:	6105                	addi	sp,sp,32
    800027c2:	8082                	ret
    panic("freeing free block");
    800027c4:	00006517          	auipc	a0,0x6
    800027c8:	d6450513          	addi	a0,a0,-668 # 80008528 <syscalls+0xe8>
    800027cc:	00003097          	auipc	ra,0x3
    800027d0:	5aa080e7          	jalr	1450(ra) # 80005d76 <panic>

00000000800027d4 <balloc>:
{
    800027d4:	711d                	addi	sp,sp,-96
    800027d6:	ec86                	sd	ra,88(sp)
    800027d8:	e8a2                	sd	s0,80(sp)
    800027da:	e4a6                	sd	s1,72(sp)
    800027dc:	e0ca                	sd	s2,64(sp)
    800027de:	fc4e                	sd	s3,56(sp)
    800027e0:	f852                	sd	s4,48(sp)
    800027e2:	f456                	sd	s5,40(sp)
    800027e4:	f05a                	sd	s6,32(sp)
    800027e6:	ec5e                	sd	s7,24(sp)
    800027e8:	e862                	sd	s8,16(sp)
    800027ea:	e466                	sd	s9,8(sp)
    800027ec:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027ee:	00234797          	auipc	a5,0x234
    800027f2:	66e7a783          	lw	a5,1646(a5) # 80236e5c <sb+0x4>
    800027f6:	cff5                	beqz	a5,800028f2 <balloc+0x11e>
    800027f8:	8baa                	mv	s7,a0
    800027fa:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027fc:	00234b17          	auipc	s6,0x234
    80002800:	65cb0b13          	addi	s6,s6,1628 # 80236e58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002804:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002806:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002808:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000280a:	6c89                	lui	s9,0x2
    8000280c:	a061                	j	80002894 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000280e:	97ca                	add	a5,a5,s2
    80002810:	8e55                	or	a2,a2,a3
    80002812:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002816:	854a                	mv	a0,s2
    80002818:	00001097          	auipc	ra,0x1
    8000281c:	084080e7          	jalr	132(ra) # 8000389c <log_write>
        brelse(bp);
    80002820:	854a                	mv	a0,s2
    80002822:	00000097          	auipc	ra,0x0
    80002826:	e22080e7          	jalr	-478(ra) # 80002644 <brelse>
  bp = bread(dev, bno);
    8000282a:	85a6                	mv	a1,s1
    8000282c:	855e                	mv	a0,s7
    8000282e:	00000097          	auipc	ra,0x0
    80002832:	ce6080e7          	jalr	-794(ra) # 80002514 <bread>
    80002836:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002838:	40000613          	li	a2,1024
    8000283c:	4581                	li	a1,0
    8000283e:	05850513          	addi	a0,a0,88
    80002842:	ffffe097          	auipc	ra,0xffffe
    80002846:	a58080e7          	jalr	-1448(ra) # 8000029a <memset>
  log_write(bp);
    8000284a:	854a                	mv	a0,s2
    8000284c:	00001097          	auipc	ra,0x1
    80002850:	050080e7          	jalr	80(ra) # 8000389c <log_write>
  brelse(bp);
    80002854:	854a                	mv	a0,s2
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	dee080e7          	jalr	-530(ra) # 80002644 <brelse>
}
    8000285e:	8526                	mv	a0,s1
    80002860:	60e6                	ld	ra,88(sp)
    80002862:	6446                	ld	s0,80(sp)
    80002864:	64a6                	ld	s1,72(sp)
    80002866:	6906                	ld	s2,64(sp)
    80002868:	79e2                	ld	s3,56(sp)
    8000286a:	7a42                	ld	s4,48(sp)
    8000286c:	7aa2                	ld	s5,40(sp)
    8000286e:	7b02                	ld	s6,32(sp)
    80002870:	6be2                	ld	s7,24(sp)
    80002872:	6c42                	ld	s8,16(sp)
    80002874:	6ca2                	ld	s9,8(sp)
    80002876:	6125                	addi	sp,sp,96
    80002878:	8082                	ret
    brelse(bp);
    8000287a:	854a                	mv	a0,s2
    8000287c:	00000097          	auipc	ra,0x0
    80002880:	dc8080e7          	jalr	-568(ra) # 80002644 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002884:	015c87bb          	addw	a5,s9,s5
    80002888:	00078a9b          	sext.w	s5,a5
    8000288c:	004b2703          	lw	a4,4(s6)
    80002890:	06eaf163          	bgeu	s5,a4,800028f2 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002894:	41fad79b          	sraiw	a5,s5,0x1f
    80002898:	0137d79b          	srliw	a5,a5,0x13
    8000289c:	015787bb          	addw	a5,a5,s5
    800028a0:	40d7d79b          	sraiw	a5,a5,0xd
    800028a4:	01cb2583          	lw	a1,28(s6)
    800028a8:	9dbd                	addw	a1,a1,a5
    800028aa:	855e                	mv	a0,s7
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	c68080e7          	jalr	-920(ra) # 80002514 <bread>
    800028b4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028b6:	004b2503          	lw	a0,4(s6)
    800028ba:	000a849b          	sext.w	s1,s5
    800028be:	8762                	mv	a4,s8
    800028c0:	faa4fde3          	bgeu	s1,a0,8000287a <balloc+0xa6>
      m = 1 << (bi % 8);
    800028c4:	00777693          	andi	a3,a4,7
    800028c8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028cc:	41f7579b          	sraiw	a5,a4,0x1f
    800028d0:	01d7d79b          	srliw	a5,a5,0x1d
    800028d4:	9fb9                	addw	a5,a5,a4
    800028d6:	4037d79b          	sraiw	a5,a5,0x3
    800028da:	00f90633          	add	a2,s2,a5
    800028de:	05864603          	lbu	a2,88(a2)
    800028e2:	00c6f5b3          	and	a1,a3,a2
    800028e6:	d585                	beqz	a1,8000280e <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e8:	2705                	addiw	a4,a4,1
    800028ea:	2485                	addiw	s1,s1,1
    800028ec:	fd471ae3          	bne	a4,s4,800028c0 <balloc+0xec>
    800028f0:	b769                	j	8000287a <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800028f2:	00006517          	auipc	a0,0x6
    800028f6:	c4e50513          	addi	a0,a0,-946 # 80008540 <syscalls+0x100>
    800028fa:	00003097          	auipc	ra,0x3
    800028fe:	4c6080e7          	jalr	1222(ra) # 80005dc0 <printf>
  return 0;
    80002902:	4481                	li	s1,0
    80002904:	bfa9                	j	8000285e <balloc+0x8a>

0000000080002906 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002906:	7179                	addi	sp,sp,-48
    80002908:	f406                	sd	ra,40(sp)
    8000290a:	f022                	sd	s0,32(sp)
    8000290c:	ec26                	sd	s1,24(sp)
    8000290e:	e84a                	sd	s2,16(sp)
    80002910:	e44e                	sd	s3,8(sp)
    80002912:	e052                	sd	s4,0(sp)
    80002914:	1800                	addi	s0,sp,48
    80002916:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002918:	47ad                	li	a5,11
    8000291a:	02b7e863          	bltu	a5,a1,8000294a <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000291e:	02059793          	slli	a5,a1,0x20
    80002922:	01e7d593          	srli	a1,a5,0x1e
    80002926:	00b504b3          	add	s1,a0,a1
    8000292a:	0504a903          	lw	s2,80(s1)
    8000292e:	06091e63          	bnez	s2,800029aa <bmap+0xa4>
      addr = balloc(ip->dev);
    80002932:	4108                	lw	a0,0(a0)
    80002934:	00000097          	auipc	ra,0x0
    80002938:	ea0080e7          	jalr	-352(ra) # 800027d4 <balloc>
    8000293c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002940:	06090563          	beqz	s2,800029aa <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002944:	0524a823          	sw	s2,80(s1)
    80002948:	a08d                	j	800029aa <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000294a:	ff45849b          	addiw	s1,a1,-12
    8000294e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002952:	0ff00793          	li	a5,255
    80002956:	08e7e563          	bltu	a5,a4,800029e0 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000295a:	08052903          	lw	s2,128(a0)
    8000295e:	00091d63          	bnez	s2,80002978 <bmap+0x72>
      addr = balloc(ip->dev);
    80002962:	4108                	lw	a0,0(a0)
    80002964:	00000097          	auipc	ra,0x0
    80002968:	e70080e7          	jalr	-400(ra) # 800027d4 <balloc>
    8000296c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002970:	02090d63          	beqz	s2,800029aa <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002974:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002978:	85ca                	mv	a1,s2
    8000297a:	0009a503          	lw	a0,0(s3)
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	b96080e7          	jalr	-1130(ra) # 80002514 <bread>
    80002986:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002988:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000298c:	02049713          	slli	a4,s1,0x20
    80002990:	01e75593          	srli	a1,a4,0x1e
    80002994:	00b784b3          	add	s1,a5,a1
    80002998:	0004a903          	lw	s2,0(s1)
    8000299c:	02090063          	beqz	s2,800029bc <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029a0:	8552                	mv	a0,s4
    800029a2:	00000097          	auipc	ra,0x0
    800029a6:	ca2080e7          	jalr	-862(ra) # 80002644 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029aa:	854a                	mv	a0,s2
    800029ac:	70a2                	ld	ra,40(sp)
    800029ae:	7402                	ld	s0,32(sp)
    800029b0:	64e2                	ld	s1,24(sp)
    800029b2:	6942                	ld	s2,16(sp)
    800029b4:	69a2                	ld	s3,8(sp)
    800029b6:	6a02                	ld	s4,0(sp)
    800029b8:	6145                	addi	sp,sp,48
    800029ba:	8082                	ret
      addr = balloc(ip->dev);
    800029bc:	0009a503          	lw	a0,0(s3)
    800029c0:	00000097          	auipc	ra,0x0
    800029c4:	e14080e7          	jalr	-492(ra) # 800027d4 <balloc>
    800029c8:	0005091b          	sext.w	s2,a0
      if(addr){
    800029cc:	fc090ae3          	beqz	s2,800029a0 <bmap+0x9a>
        a[bn] = addr;
    800029d0:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800029d4:	8552                	mv	a0,s4
    800029d6:	00001097          	auipc	ra,0x1
    800029da:	ec6080e7          	jalr	-314(ra) # 8000389c <log_write>
    800029de:	b7c9                	j	800029a0 <bmap+0x9a>
  panic("bmap: out of range");
    800029e0:	00006517          	auipc	a0,0x6
    800029e4:	b7850513          	addi	a0,a0,-1160 # 80008558 <syscalls+0x118>
    800029e8:	00003097          	auipc	ra,0x3
    800029ec:	38e080e7          	jalr	910(ra) # 80005d76 <panic>

00000000800029f0 <iget>:
{
    800029f0:	7179                	addi	sp,sp,-48
    800029f2:	f406                	sd	ra,40(sp)
    800029f4:	f022                	sd	s0,32(sp)
    800029f6:	ec26                	sd	s1,24(sp)
    800029f8:	e84a                	sd	s2,16(sp)
    800029fa:	e44e                	sd	s3,8(sp)
    800029fc:	e052                	sd	s4,0(sp)
    800029fe:	1800                	addi	s0,sp,48
    80002a00:	89aa                	mv	s3,a0
    80002a02:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a04:	00234517          	auipc	a0,0x234
    80002a08:	47450513          	addi	a0,a0,1140 # 80236e78 <itable>
    80002a0c:	00004097          	auipc	ra,0x4
    80002a10:	8a2080e7          	jalr	-1886(ra) # 800062ae <acquire>
  empty = 0;
    80002a14:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a16:	00234497          	auipc	s1,0x234
    80002a1a:	47a48493          	addi	s1,s1,1146 # 80236e90 <itable+0x18>
    80002a1e:	00236697          	auipc	a3,0x236
    80002a22:	f0268693          	addi	a3,a3,-254 # 80238920 <log>
    80002a26:	a039                	j	80002a34 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a28:	02090b63          	beqz	s2,80002a5e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a2c:	08848493          	addi	s1,s1,136
    80002a30:	02d48a63          	beq	s1,a3,80002a64 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a34:	449c                	lw	a5,8(s1)
    80002a36:	fef059e3          	blez	a5,80002a28 <iget+0x38>
    80002a3a:	4098                	lw	a4,0(s1)
    80002a3c:	ff3716e3          	bne	a4,s3,80002a28 <iget+0x38>
    80002a40:	40d8                	lw	a4,4(s1)
    80002a42:	ff4713e3          	bne	a4,s4,80002a28 <iget+0x38>
      ip->ref++;
    80002a46:	2785                	addiw	a5,a5,1
    80002a48:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a4a:	00234517          	auipc	a0,0x234
    80002a4e:	42e50513          	addi	a0,a0,1070 # 80236e78 <itable>
    80002a52:	00004097          	auipc	ra,0x4
    80002a56:	910080e7          	jalr	-1776(ra) # 80006362 <release>
      return ip;
    80002a5a:	8926                	mv	s2,s1
    80002a5c:	a03d                	j	80002a8a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a5e:	f7f9                	bnez	a5,80002a2c <iget+0x3c>
    80002a60:	8926                	mv	s2,s1
    80002a62:	b7e9                	j	80002a2c <iget+0x3c>
  if(empty == 0)
    80002a64:	02090c63          	beqz	s2,80002a9c <iget+0xac>
  ip->dev = dev;
    80002a68:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a6c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a70:	4785                	li	a5,1
    80002a72:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a76:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a7a:	00234517          	auipc	a0,0x234
    80002a7e:	3fe50513          	addi	a0,a0,1022 # 80236e78 <itable>
    80002a82:	00004097          	auipc	ra,0x4
    80002a86:	8e0080e7          	jalr	-1824(ra) # 80006362 <release>
}
    80002a8a:	854a                	mv	a0,s2
    80002a8c:	70a2                	ld	ra,40(sp)
    80002a8e:	7402                	ld	s0,32(sp)
    80002a90:	64e2                	ld	s1,24(sp)
    80002a92:	6942                	ld	s2,16(sp)
    80002a94:	69a2                	ld	s3,8(sp)
    80002a96:	6a02                	ld	s4,0(sp)
    80002a98:	6145                	addi	sp,sp,48
    80002a9a:	8082                	ret
    panic("iget: no inodes");
    80002a9c:	00006517          	auipc	a0,0x6
    80002aa0:	ad450513          	addi	a0,a0,-1324 # 80008570 <syscalls+0x130>
    80002aa4:	00003097          	auipc	ra,0x3
    80002aa8:	2d2080e7          	jalr	722(ra) # 80005d76 <panic>

0000000080002aac <fsinit>:
fsinit(int dev) {
    80002aac:	7179                	addi	sp,sp,-48
    80002aae:	f406                	sd	ra,40(sp)
    80002ab0:	f022                	sd	s0,32(sp)
    80002ab2:	ec26                	sd	s1,24(sp)
    80002ab4:	e84a                	sd	s2,16(sp)
    80002ab6:	e44e                	sd	s3,8(sp)
    80002ab8:	1800                	addi	s0,sp,48
    80002aba:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002abc:	4585                	li	a1,1
    80002abe:	00000097          	auipc	ra,0x0
    80002ac2:	a56080e7          	jalr	-1450(ra) # 80002514 <bread>
    80002ac6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ac8:	00234997          	auipc	s3,0x234
    80002acc:	39098993          	addi	s3,s3,912 # 80236e58 <sb>
    80002ad0:	02000613          	li	a2,32
    80002ad4:	05850593          	addi	a1,a0,88
    80002ad8:	854e                	mv	a0,s3
    80002ada:	ffffe097          	auipc	ra,0xffffe
    80002ade:	81c080e7          	jalr	-2020(ra) # 800002f6 <memmove>
  brelse(bp);
    80002ae2:	8526                	mv	a0,s1
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	b60080e7          	jalr	-1184(ra) # 80002644 <brelse>
  if(sb.magic != FSMAGIC)
    80002aec:	0009a703          	lw	a4,0(s3)
    80002af0:	102037b7          	lui	a5,0x10203
    80002af4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002af8:	02f71263          	bne	a4,a5,80002b1c <fsinit+0x70>
  initlog(dev, &sb);
    80002afc:	00234597          	auipc	a1,0x234
    80002b00:	35c58593          	addi	a1,a1,860 # 80236e58 <sb>
    80002b04:	854a                	mv	a0,s2
    80002b06:	00001097          	auipc	ra,0x1
    80002b0a:	b2c080e7          	jalr	-1236(ra) # 80003632 <initlog>
}
    80002b0e:	70a2                	ld	ra,40(sp)
    80002b10:	7402                	ld	s0,32(sp)
    80002b12:	64e2                	ld	s1,24(sp)
    80002b14:	6942                	ld	s2,16(sp)
    80002b16:	69a2                	ld	s3,8(sp)
    80002b18:	6145                	addi	sp,sp,48
    80002b1a:	8082                	ret
    panic("invalid file system");
    80002b1c:	00006517          	auipc	a0,0x6
    80002b20:	a6450513          	addi	a0,a0,-1436 # 80008580 <syscalls+0x140>
    80002b24:	00003097          	auipc	ra,0x3
    80002b28:	252080e7          	jalr	594(ra) # 80005d76 <panic>

0000000080002b2c <iinit>:
{
    80002b2c:	7179                	addi	sp,sp,-48
    80002b2e:	f406                	sd	ra,40(sp)
    80002b30:	f022                	sd	s0,32(sp)
    80002b32:	ec26                	sd	s1,24(sp)
    80002b34:	e84a                	sd	s2,16(sp)
    80002b36:	e44e                	sd	s3,8(sp)
    80002b38:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b3a:	00006597          	auipc	a1,0x6
    80002b3e:	a5e58593          	addi	a1,a1,-1442 # 80008598 <syscalls+0x158>
    80002b42:	00234517          	auipc	a0,0x234
    80002b46:	33650513          	addi	a0,a0,822 # 80236e78 <itable>
    80002b4a:	00003097          	auipc	ra,0x3
    80002b4e:	6d4080e7          	jalr	1748(ra) # 8000621e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b52:	00234497          	auipc	s1,0x234
    80002b56:	34e48493          	addi	s1,s1,846 # 80236ea0 <itable+0x28>
    80002b5a:	00236997          	auipc	s3,0x236
    80002b5e:	dd698993          	addi	s3,s3,-554 # 80238930 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b62:	00006917          	auipc	s2,0x6
    80002b66:	a3e90913          	addi	s2,s2,-1474 # 800085a0 <syscalls+0x160>
    80002b6a:	85ca                	mv	a1,s2
    80002b6c:	8526                	mv	a0,s1
    80002b6e:	00001097          	auipc	ra,0x1
    80002b72:	e12080e7          	jalr	-494(ra) # 80003980 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b76:	08848493          	addi	s1,s1,136
    80002b7a:	ff3498e3          	bne	s1,s3,80002b6a <iinit+0x3e>
}
    80002b7e:	70a2                	ld	ra,40(sp)
    80002b80:	7402                	ld	s0,32(sp)
    80002b82:	64e2                	ld	s1,24(sp)
    80002b84:	6942                	ld	s2,16(sp)
    80002b86:	69a2                	ld	s3,8(sp)
    80002b88:	6145                	addi	sp,sp,48
    80002b8a:	8082                	ret

0000000080002b8c <ialloc>:
{
    80002b8c:	7139                	addi	sp,sp,-64
    80002b8e:	fc06                	sd	ra,56(sp)
    80002b90:	f822                	sd	s0,48(sp)
    80002b92:	f426                	sd	s1,40(sp)
    80002b94:	f04a                	sd	s2,32(sp)
    80002b96:	ec4e                	sd	s3,24(sp)
    80002b98:	e852                	sd	s4,16(sp)
    80002b9a:	e456                	sd	s5,8(sp)
    80002b9c:	e05a                	sd	s6,0(sp)
    80002b9e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba0:	00234717          	auipc	a4,0x234
    80002ba4:	2c472703          	lw	a4,708(a4) # 80236e64 <sb+0xc>
    80002ba8:	4785                	li	a5,1
    80002baa:	04e7f863          	bgeu	a5,a4,80002bfa <ialloc+0x6e>
    80002bae:	8aaa                	mv	s5,a0
    80002bb0:	8b2e                	mv	s6,a1
    80002bb2:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bb4:	00234a17          	auipc	s4,0x234
    80002bb8:	2a4a0a13          	addi	s4,s4,676 # 80236e58 <sb>
    80002bbc:	00495593          	srli	a1,s2,0x4
    80002bc0:	018a2783          	lw	a5,24(s4)
    80002bc4:	9dbd                	addw	a1,a1,a5
    80002bc6:	8556                	mv	a0,s5
    80002bc8:	00000097          	auipc	ra,0x0
    80002bcc:	94c080e7          	jalr	-1716(ra) # 80002514 <bread>
    80002bd0:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bd2:	05850993          	addi	s3,a0,88
    80002bd6:	00f97793          	andi	a5,s2,15
    80002bda:	079a                	slli	a5,a5,0x6
    80002bdc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bde:	00099783          	lh	a5,0(s3)
    80002be2:	cf9d                	beqz	a5,80002c20 <ialloc+0x94>
    brelse(bp);
    80002be4:	00000097          	auipc	ra,0x0
    80002be8:	a60080e7          	jalr	-1440(ra) # 80002644 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bec:	0905                	addi	s2,s2,1
    80002bee:	00ca2703          	lw	a4,12(s4)
    80002bf2:	0009079b          	sext.w	a5,s2
    80002bf6:	fce7e3e3          	bltu	a5,a4,80002bbc <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002bfa:	00006517          	auipc	a0,0x6
    80002bfe:	9ae50513          	addi	a0,a0,-1618 # 800085a8 <syscalls+0x168>
    80002c02:	00003097          	auipc	ra,0x3
    80002c06:	1be080e7          	jalr	446(ra) # 80005dc0 <printf>
  return 0;
    80002c0a:	4501                	li	a0,0
}
    80002c0c:	70e2                	ld	ra,56(sp)
    80002c0e:	7442                	ld	s0,48(sp)
    80002c10:	74a2                	ld	s1,40(sp)
    80002c12:	7902                	ld	s2,32(sp)
    80002c14:	69e2                	ld	s3,24(sp)
    80002c16:	6a42                	ld	s4,16(sp)
    80002c18:	6aa2                	ld	s5,8(sp)
    80002c1a:	6b02                	ld	s6,0(sp)
    80002c1c:	6121                	addi	sp,sp,64
    80002c1e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c20:	04000613          	li	a2,64
    80002c24:	4581                	li	a1,0
    80002c26:	854e                	mv	a0,s3
    80002c28:	ffffd097          	auipc	ra,0xffffd
    80002c2c:	672080e7          	jalr	1650(ra) # 8000029a <memset>
      dip->type = type;
    80002c30:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c34:	8526                	mv	a0,s1
    80002c36:	00001097          	auipc	ra,0x1
    80002c3a:	c66080e7          	jalr	-922(ra) # 8000389c <log_write>
      brelse(bp);
    80002c3e:	8526                	mv	a0,s1
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	a04080e7          	jalr	-1532(ra) # 80002644 <brelse>
      return iget(dev, inum);
    80002c48:	0009059b          	sext.w	a1,s2
    80002c4c:	8556                	mv	a0,s5
    80002c4e:	00000097          	auipc	ra,0x0
    80002c52:	da2080e7          	jalr	-606(ra) # 800029f0 <iget>
    80002c56:	bf5d                	j	80002c0c <ialloc+0x80>

0000000080002c58 <iupdate>:
{
    80002c58:	1101                	addi	sp,sp,-32
    80002c5a:	ec06                	sd	ra,24(sp)
    80002c5c:	e822                	sd	s0,16(sp)
    80002c5e:	e426                	sd	s1,8(sp)
    80002c60:	e04a                	sd	s2,0(sp)
    80002c62:	1000                	addi	s0,sp,32
    80002c64:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c66:	415c                	lw	a5,4(a0)
    80002c68:	0047d79b          	srliw	a5,a5,0x4
    80002c6c:	00234597          	auipc	a1,0x234
    80002c70:	2045a583          	lw	a1,516(a1) # 80236e70 <sb+0x18>
    80002c74:	9dbd                	addw	a1,a1,a5
    80002c76:	4108                	lw	a0,0(a0)
    80002c78:	00000097          	auipc	ra,0x0
    80002c7c:	89c080e7          	jalr	-1892(ra) # 80002514 <bread>
    80002c80:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c82:	05850793          	addi	a5,a0,88
    80002c86:	40d8                	lw	a4,4(s1)
    80002c88:	8b3d                	andi	a4,a4,15
    80002c8a:	071a                	slli	a4,a4,0x6
    80002c8c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c8e:	04449703          	lh	a4,68(s1)
    80002c92:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c96:	04649703          	lh	a4,70(s1)
    80002c9a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c9e:	04849703          	lh	a4,72(s1)
    80002ca2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ca6:	04a49703          	lh	a4,74(s1)
    80002caa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cae:	44f8                	lw	a4,76(s1)
    80002cb0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cb2:	03400613          	li	a2,52
    80002cb6:	05048593          	addi	a1,s1,80
    80002cba:	00c78513          	addi	a0,a5,12
    80002cbe:	ffffd097          	auipc	ra,0xffffd
    80002cc2:	638080e7          	jalr	1592(ra) # 800002f6 <memmove>
  log_write(bp);
    80002cc6:	854a                	mv	a0,s2
    80002cc8:	00001097          	auipc	ra,0x1
    80002ccc:	bd4080e7          	jalr	-1068(ra) # 8000389c <log_write>
  brelse(bp);
    80002cd0:	854a                	mv	a0,s2
    80002cd2:	00000097          	auipc	ra,0x0
    80002cd6:	972080e7          	jalr	-1678(ra) # 80002644 <brelse>
}
    80002cda:	60e2                	ld	ra,24(sp)
    80002cdc:	6442                	ld	s0,16(sp)
    80002cde:	64a2                	ld	s1,8(sp)
    80002ce0:	6902                	ld	s2,0(sp)
    80002ce2:	6105                	addi	sp,sp,32
    80002ce4:	8082                	ret

0000000080002ce6 <idup>:
{
    80002ce6:	1101                	addi	sp,sp,-32
    80002ce8:	ec06                	sd	ra,24(sp)
    80002cea:	e822                	sd	s0,16(sp)
    80002cec:	e426                	sd	s1,8(sp)
    80002cee:	1000                	addi	s0,sp,32
    80002cf0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cf2:	00234517          	auipc	a0,0x234
    80002cf6:	18650513          	addi	a0,a0,390 # 80236e78 <itable>
    80002cfa:	00003097          	auipc	ra,0x3
    80002cfe:	5b4080e7          	jalr	1460(ra) # 800062ae <acquire>
  ip->ref++;
    80002d02:	449c                	lw	a5,8(s1)
    80002d04:	2785                	addiw	a5,a5,1
    80002d06:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d08:	00234517          	auipc	a0,0x234
    80002d0c:	17050513          	addi	a0,a0,368 # 80236e78 <itable>
    80002d10:	00003097          	auipc	ra,0x3
    80002d14:	652080e7          	jalr	1618(ra) # 80006362 <release>
}
    80002d18:	8526                	mv	a0,s1
    80002d1a:	60e2                	ld	ra,24(sp)
    80002d1c:	6442                	ld	s0,16(sp)
    80002d1e:	64a2                	ld	s1,8(sp)
    80002d20:	6105                	addi	sp,sp,32
    80002d22:	8082                	ret

0000000080002d24 <ilock>:
{
    80002d24:	1101                	addi	sp,sp,-32
    80002d26:	ec06                	sd	ra,24(sp)
    80002d28:	e822                	sd	s0,16(sp)
    80002d2a:	e426                	sd	s1,8(sp)
    80002d2c:	e04a                	sd	s2,0(sp)
    80002d2e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d30:	c115                	beqz	a0,80002d54 <ilock+0x30>
    80002d32:	84aa                	mv	s1,a0
    80002d34:	451c                	lw	a5,8(a0)
    80002d36:	00f05f63          	blez	a5,80002d54 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d3a:	0541                	addi	a0,a0,16
    80002d3c:	00001097          	auipc	ra,0x1
    80002d40:	c7e080e7          	jalr	-898(ra) # 800039ba <acquiresleep>
  if(ip->valid == 0){
    80002d44:	40bc                	lw	a5,64(s1)
    80002d46:	cf99                	beqz	a5,80002d64 <ilock+0x40>
}
    80002d48:	60e2                	ld	ra,24(sp)
    80002d4a:	6442                	ld	s0,16(sp)
    80002d4c:	64a2                	ld	s1,8(sp)
    80002d4e:	6902                	ld	s2,0(sp)
    80002d50:	6105                	addi	sp,sp,32
    80002d52:	8082                	ret
    panic("ilock");
    80002d54:	00006517          	auipc	a0,0x6
    80002d58:	86c50513          	addi	a0,a0,-1940 # 800085c0 <syscalls+0x180>
    80002d5c:	00003097          	auipc	ra,0x3
    80002d60:	01a080e7          	jalr	26(ra) # 80005d76 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d64:	40dc                	lw	a5,4(s1)
    80002d66:	0047d79b          	srliw	a5,a5,0x4
    80002d6a:	00234597          	auipc	a1,0x234
    80002d6e:	1065a583          	lw	a1,262(a1) # 80236e70 <sb+0x18>
    80002d72:	9dbd                	addw	a1,a1,a5
    80002d74:	4088                	lw	a0,0(s1)
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	79e080e7          	jalr	1950(ra) # 80002514 <bread>
    80002d7e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d80:	05850593          	addi	a1,a0,88
    80002d84:	40dc                	lw	a5,4(s1)
    80002d86:	8bbd                	andi	a5,a5,15
    80002d88:	079a                	slli	a5,a5,0x6
    80002d8a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d8c:	00059783          	lh	a5,0(a1)
    80002d90:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d94:	00259783          	lh	a5,2(a1)
    80002d98:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d9c:	00459783          	lh	a5,4(a1)
    80002da0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002da4:	00659783          	lh	a5,6(a1)
    80002da8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002dac:	459c                	lw	a5,8(a1)
    80002dae:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002db0:	03400613          	li	a2,52
    80002db4:	05b1                	addi	a1,a1,12
    80002db6:	05048513          	addi	a0,s1,80
    80002dba:	ffffd097          	auipc	ra,0xffffd
    80002dbe:	53c080e7          	jalr	1340(ra) # 800002f6 <memmove>
    brelse(bp);
    80002dc2:	854a                	mv	a0,s2
    80002dc4:	00000097          	auipc	ra,0x0
    80002dc8:	880080e7          	jalr	-1920(ra) # 80002644 <brelse>
    ip->valid = 1;
    80002dcc:	4785                	li	a5,1
    80002dce:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dd0:	04449783          	lh	a5,68(s1)
    80002dd4:	fbb5                	bnez	a5,80002d48 <ilock+0x24>
      panic("ilock: no type");
    80002dd6:	00005517          	auipc	a0,0x5
    80002dda:	7f250513          	addi	a0,a0,2034 # 800085c8 <syscalls+0x188>
    80002dde:	00003097          	auipc	ra,0x3
    80002de2:	f98080e7          	jalr	-104(ra) # 80005d76 <panic>

0000000080002de6 <iunlock>:
{
    80002de6:	1101                	addi	sp,sp,-32
    80002de8:	ec06                	sd	ra,24(sp)
    80002dea:	e822                	sd	s0,16(sp)
    80002dec:	e426                	sd	s1,8(sp)
    80002dee:	e04a                	sd	s2,0(sp)
    80002df0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002df2:	c905                	beqz	a0,80002e22 <iunlock+0x3c>
    80002df4:	84aa                	mv	s1,a0
    80002df6:	01050913          	addi	s2,a0,16
    80002dfa:	854a                	mv	a0,s2
    80002dfc:	00001097          	auipc	ra,0x1
    80002e00:	c58080e7          	jalr	-936(ra) # 80003a54 <holdingsleep>
    80002e04:	cd19                	beqz	a0,80002e22 <iunlock+0x3c>
    80002e06:	449c                	lw	a5,8(s1)
    80002e08:	00f05d63          	blez	a5,80002e22 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e0c:	854a                	mv	a0,s2
    80002e0e:	00001097          	auipc	ra,0x1
    80002e12:	c02080e7          	jalr	-1022(ra) # 80003a10 <releasesleep>
}
    80002e16:	60e2                	ld	ra,24(sp)
    80002e18:	6442                	ld	s0,16(sp)
    80002e1a:	64a2                	ld	s1,8(sp)
    80002e1c:	6902                	ld	s2,0(sp)
    80002e1e:	6105                	addi	sp,sp,32
    80002e20:	8082                	ret
    panic("iunlock");
    80002e22:	00005517          	auipc	a0,0x5
    80002e26:	7b650513          	addi	a0,a0,1974 # 800085d8 <syscalls+0x198>
    80002e2a:	00003097          	auipc	ra,0x3
    80002e2e:	f4c080e7          	jalr	-180(ra) # 80005d76 <panic>

0000000080002e32 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e32:	7179                	addi	sp,sp,-48
    80002e34:	f406                	sd	ra,40(sp)
    80002e36:	f022                	sd	s0,32(sp)
    80002e38:	ec26                	sd	s1,24(sp)
    80002e3a:	e84a                	sd	s2,16(sp)
    80002e3c:	e44e                	sd	s3,8(sp)
    80002e3e:	e052                	sd	s4,0(sp)
    80002e40:	1800                	addi	s0,sp,48
    80002e42:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e44:	05050493          	addi	s1,a0,80
    80002e48:	08050913          	addi	s2,a0,128
    80002e4c:	a021                	j	80002e54 <itrunc+0x22>
    80002e4e:	0491                	addi	s1,s1,4
    80002e50:	01248d63          	beq	s1,s2,80002e6a <itrunc+0x38>
    if(ip->addrs[i]){
    80002e54:	408c                	lw	a1,0(s1)
    80002e56:	dde5                	beqz	a1,80002e4e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e58:	0009a503          	lw	a0,0(s3)
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	8fc080e7          	jalr	-1796(ra) # 80002758 <bfree>
      ip->addrs[i] = 0;
    80002e64:	0004a023          	sw	zero,0(s1)
    80002e68:	b7dd                	j	80002e4e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e6a:	0809a583          	lw	a1,128(s3)
    80002e6e:	e185                	bnez	a1,80002e8e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e70:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e74:	854e                	mv	a0,s3
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	de2080e7          	jalr	-542(ra) # 80002c58 <iupdate>
}
    80002e7e:	70a2                	ld	ra,40(sp)
    80002e80:	7402                	ld	s0,32(sp)
    80002e82:	64e2                	ld	s1,24(sp)
    80002e84:	6942                	ld	s2,16(sp)
    80002e86:	69a2                	ld	s3,8(sp)
    80002e88:	6a02                	ld	s4,0(sp)
    80002e8a:	6145                	addi	sp,sp,48
    80002e8c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e8e:	0009a503          	lw	a0,0(s3)
    80002e92:	fffff097          	auipc	ra,0xfffff
    80002e96:	682080e7          	jalr	1666(ra) # 80002514 <bread>
    80002e9a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e9c:	05850493          	addi	s1,a0,88
    80002ea0:	45850913          	addi	s2,a0,1112
    80002ea4:	a021                	j	80002eac <itrunc+0x7a>
    80002ea6:	0491                	addi	s1,s1,4
    80002ea8:	01248b63          	beq	s1,s2,80002ebe <itrunc+0x8c>
      if(a[j])
    80002eac:	408c                	lw	a1,0(s1)
    80002eae:	dde5                	beqz	a1,80002ea6 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002eb0:	0009a503          	lw	a0,0(s3)
    80002eb4:	00000097          	auipc	ra,0x0
    80002eb8:	8a4080e7          	jalr	-1884(ra) # 80002758 <bfree>
    80002ebc:	b7ed                	j	80002ea6 <itrunc+0x74>
    brelse(bp);
    80002ebe:	8552                	mv	a0,s4
    80002ec0:	fffff097          	auipc	ra,0xfffff
    80002ec4:	784080e7          	jalr	1924(ra) # 80002644 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ec8:	0809a583          	lw	a1,128(s3)
    80002ecc:	0009a503          	lw	a0,0(s3)
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	888080e7          	jalr	-1912(ra) # 80002758 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ed8:	0809a023          	sw	zero,128(s3)
    80002edc:	bf51                	j	80002e70 <itrunc+0x3e>

0000000080002ede <iput>:
{
    80002ede:	1101                	addi	sp,sp,-32
    80002ee0:	ec06                	sd	ra,24(sp)
    80002ee2:	e822                	sd	s0,16(sp)
    80002ee4:	e426                	sd	s1,8(sp)
    80002ee6:	e04a                	sd	s2,0(sp)
    80002ee8:	1000                	addi	s0,sp,32
    80002eea:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002eec:	00234517          	auipc	a0,0x234
    80002ef0:	f8c50513          	addi	a0,a0,-116 # 80236e78 <itable>
    80002ef4:	00003097          	auipc	ra,0x3
    80002ef8:	3ba080e7          	jalr	954(ra) # 800062ae <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002efc:	4498                	lw	a4,8(s1)
    80002efe:	4785                	li	a5,1
    80002f00:	02f70363          	beq	a4,a5,80002f26 <iput+0x48>
  ip->ref--;
    80002f04:	449c                	lw	a5,8(s1)
    80002f06:	37fd                	addiw	a5,a5,-1
    80002f08:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f0a:	00234517          	auipc	a0,0x234
    80002f0e:	f6e50513          	addi	a0,a0,-146 # 80236e78 <itable>
    80002f12:	00003097          	auipc	ra,0x3
    80002f16:	450080e7          	jalr	1104(ra) # 80006362 <release>
}
    80002f1a:	60e2                	ld	ra,24(sp)
    80002f1c:	6442                	ld	s0,16(sp)
    80002f1e:	64a2                	ld	s1,8(sp)
    80002f20:	6902                	ld	s2,0(sp)
    80002f22:	6105                	addi	sp,sp,32
    80002f24:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f26:	40bc                	lw	a5,64(s1)
    80002f28:	dff1                	beqz	a5,80002f04 <iput+0x26>
    80002f2a:	04a49783          	lh	a5,74(s1)
    80002f2e:	fbf9                	bnez	a5,80002f04 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f30:	01048913          	addi	s2,s1,16
    80002f34:	854a                	mv	a0,s2
    80002f36:	00001097          	auipc	ra,0x1
    80002f3a:	a84080e7          	jalr	-1404(ra) # 800039ba <acquiresleep>
    release(&itable.lock);
    80002f3e:	00234517          	auipc	a0,0x234
    80002f42:	f3a50513          	addi	a0,a0,-198 # 80236e78 <itable>
    80002f46:	00003097          	auipc	ra,0x3
    80002f4a:	41c080e7          	jalr	1052(ra) # 80006362 <release>
    itrunc(ip);
    80002f4e:	8526                	mv	a0,s1
    80002f50:	00000097          	auipc	ra,0x0
    80002f54:	ee2080e7          	jalr	-286(ra) # 80002e32 <itrunc>
    ip->type = 0;
    80002f58:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f5c:	8526                	mv	a0,s1
    80002f5e:	00000097          	auipc	ra,0x0
    80002f62:	cfa080e7          	jalr	-774(ra) # 80002c58 <iupdate>
    ip->valid = 0;
    80002f66:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f6a:	854a                	mv	a0,s2
    80002f6c:	00001097          	auipc	ra,0x1
    80002f70:	aa4080e7          	jalr	-1372(ra) # 80003a10 <releasesleep>
    acquire(&itable.lock);
    80002f74:	00234517          	auipc	a0,0x234
    80002f78:	f0450513          	addi	a0,a0,-252 # 80236e78 <itable>
    80002f7c:	00003097          	auipc	ra,0x3
    80002f80:	332080e7          	jalr	818(ra) # 800062ae <acquire>
    80002f84:	b741                	j	80002f04 <iput+0x26>

0000000080002f86 <iunlockput>:
{
    80002f86:	1101                	addi	sp,sp,-32
    80002f88:	ec06                	sd	ra,24(sp)
    80002f8a:	e822                	sd	s0,16(sp)
    80002f8c:	e426                	sd	s1,8(sp)
    80002f8e:	1000                	addi	s0,sp,32
    80002f90:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f92:	00000097          	auipc	ra,0x0
    80002f96:	e54080e7          	jalr	-428(ra) # 80002de6 <iunlock>
  iput(ip);
    80002f9a:	8526                	mv	a0,s1
    80002f9c:	00000097          	auipc	ra,0x0
    80002fa0:	f42080e7          	jalr	-190(ra) # 80002ede <iput>
}
    80002fa4:	60e2                	ld	ra,24(sp)
    80002fa6:	6442                	ld	s0,16(sp)
    80002fa8:	64a2                	ld	s1,8(sp)
    80002faa:	6105                	addi	sp,sp,32
    80002fac:	8082                	ret

0000000080002fae <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fae:	1141                	addi	sp,sp,-16
    80002fb0:	e422                	sd	s0,8(sp)
    80002fb2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fb4:	411c                	lw	a5,0(a0)
    80002fb6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fb8:	415c                	lw	a5,4(a0)
    80002fba:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fbc:	04451783          	lh	a5,68(a0)
    80002fc0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fc4:	04a51783          	lh	a5,74(a0)
    80002fc8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fcc:	04c56783          	lwu	a5,76(a0)
    80002fd0:	e99c                	sd	a5,16(a1)
}
    80002fd2:	6422                	ld	s0,8(sp)
    80002fd4:	0141                	addi	sp,sp,16
    80002fd6:	8082                	ret

0000000080002fd8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fd8:	457c                	lw	a5,76(a0)
    80002fda:	0ed7e963          	bltu	a5,a3,800030cc <readi+0xf4>
{
    80002fde:	7159                	addi	sp,sp,-112
    80002fe0:	f486                	sd	ra,104(sp)
    80002fe2:	f0a2                	sd	s0,96(sp)
    80002fe4:	eca6                	sd	s1,88(sp)
    80002fe6:	e8ca                	sd	s2,80(sp)
    80002fe8:	e4ce                	sd	s3,72(sp)
    80002fea:	e0d2                	sd	s4,64(sp)
    80002fec:	fc56                	sd	s5,56(sp)
    80002fee:	f85a                	sd	s6,48(sp)
    80002ff0:	f45e                	sd	s7,40(sp)
    80002ff2:	f062                	sd	s8,32(sp)
    80002ff4:	ec66                	sd	s9,24(sp)
    80002ff6:	e86a                	sd	s10,16(sp)
    80002ff8:	e46e                	sd	s11,8(sp)
    80002ffa:	1880                	addi	s0,sp,112
    80002ffc:	8b2a                	mv	s6,a0
    80002ffe:	8bae                	mv	s7,a1
    80003000:	8a32                	mv	s4,a2
    80003002:	84b6                	mv	s1,a3
    80003004:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003006:	9f35                	addw	a4,a4,a3
    return 0;
    80003008:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000300a:	0ad76063          	bltu	a4,a3,800030aa <readi+0xd2>
  if(off + n > ip->size)
    8000300e:	00e7f463          	bgeu	a5,a4,80003016 <readi+0x3e>
    n = ip->size - off;
    80003012:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003016:	0a0a8963          	beqz	s5,800030c8 <readi+0xf0>
    8000301a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000301c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003020:	5c7d                	li	s8,-1
    80003022:	a82d                	j	8000305c <readi+0x84>
    80003024:	020d1d93          	slli	s11,s10,0x20
    80003028:	020ddd93          	srli	s11,s11,0x20
    8000302c:	05890613          	addi	a2,s2,88
    80003030:	86ee                	mv	a3,s11
    80003032:	963a                	add	a2,a2,a4
    80003034:	85d2                	mv	a1,s4
    80003036:	855e                	mv	a0,s7
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	aea080e7          	jalr	-1302(ra) # 80001b22 <either_copyout>
    80003040:	05850d63          	beq	a0,s8,8000309a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003044:	854a                	mv	a0,s2
    80003046:	fffff097          	auipc	ra,0xfffff
    8000304a:	5fe080e7          	jalr	1534(ra) # 80002644 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000304e:	013d09bb          	addw	s3,s10,s3
    80003052:	009d04bb          	addw	s1,s10,s1
    80003056:	9a6e                	add	s4,s4,s11
    80003058:	0559f763          	bgeu	s3,s5,800030a6 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    8000305c:	00a4d59b          	srliw	a1,s1,0xa
    80003060:	855a                	mv	a0,s6
    80003062:	00000097          	auipc	ra,0x0
    80003066:	8a4080e7          	jalr	-1884(ra) # 80002906 <bmap>
    8000306a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000306e:	cd85                	beqz	a1,800030a6 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003070:	000b2503          	lw	a0,0(s6)
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	4a0080e7          	jalr	1184(ra) # 80002514 <bread>
    8000307c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000307e:	3ff4f713          	andi	a4,s1,1023
    80003082:	40ec87bb          	subw	a5,s9,a4
    80003086:	413a86bb          	subw	a3,s5,s3
    8000308a:	8d3e                	mv	s10,a5
    8000308c:	2781                	sext.w	a5,a5
    8000308e:	0006861b          	sext.w	a2,a3
    80003092:	f8f679e3          	bgeu	a2,a5,80003024 <readi+0x4c>
    80003096:	8d36                	mv	s10,a3
    80003098:	b771                	j	80003024 <readi+0x4c>
      brelse(bp);
    8000309a:	854a                	mv	a0,s2
    8000309c:	fffff097          	auipc	ra,0xfffff
    800030a0:	5a8080e7          	jalr	1448(ra) # 80002644 <brelse>
      tot = -1;
    800030a4:	59fd                	li	s3,-1
  }
  return tot;
    800030a6:	0009851b          	sext.w	a0,s3
}
    800030aa:	70a6                	ld	ra,104(sp)
    800030ac:	7406                	ld	s0,96(sp)
    800030ae:	64e6                	ld	s1,88(sp)
    800030b0:	6946                	ld	s2,80(sp)
    800030b2:	69a6                	ld	s3,72(sp)
    800030b4:	6a06                	ld	s4,64(sp)
    800030b6:	7ae2                	ld	s5,56(sp)
    800030b8:	7b42                	ld	s6,48(sp)
    800030ba:	7ba2                	ld	s7,40(sp)
    800030bc:	7c02                	ld	s8,32(sp)
    800030be:	6ce2                	ld	s9,24(sp)
    800030c0:	6d42                	ld	s10,16(sp)
    800030c2:	6da2                	ld	s11,8(sp)
    800030c4:	6165                	addi	sp,sp,112
    800030c6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030c8:	89d6                	mv	s3,s5
    800030ca:	bff1                	j	800030a6 <readi+0xce>
    return 0;
    800030cc:	4501                	li	a0,0
}
    800030ce:	8082                	ret

00000000800030d0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030d0:	457c                	lw	a5,76(a0)
    800030d2:	10d7e863          	bltu	a5,a3,800031e2 <writei+0x112>
{
    800030d6:	7159                	addi	sp,sp,-112
    800030d8:	f486                	sd	ra,104(sp)
    800030da:	f0a2                	sd	s0,96(sp)
    800030dc:	eca6                	sd	s1,88(sp)
    800030de:	e8ca                	sd	s2,80(sp)
    800030e0:	e4ce                	sd	s3,72(sp)
    800030e2:	e0d2                	sd	s4,64(sp)
    800030e4:	fc56                	sd	s5,56(sp)
    800030e6:	f85a                	sd	s6,48(sp)
    800030e8:	f45e                	sd	s7,40(sp)
    800030ea:	f062                	sd	s8,32(sp)
    800030ec:	ec66                	sd	s9,24(sp)
    800030ee:	e86a                	sd	s10,16(sp)
    800030f0:	e46e                	sd	s11,8(sp)
    800030f2:	1880                	addi	s0,sp,112
    800030f4:	8aaa                	mv	s5,a0
    800030f6:	8bae                	mv	s7,a1
    800030f8:	8a32                	mv	s4,a2
    800030fa:	8936                	mv	s2,a3
    800030fc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030fe:	00e687bb          	addw	a5,a3,a4
    80003102:	0ed7e263          	bltu	a5,a3,800031e6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003106:	00043737          	lui	a4,0x43
    8000310a:	0ef76063          	bltu	a4,a5,800031ea <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000310e:	0c0b0863          	beqz	s6,800031de <writei+0x10e>
    80003112:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003114:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003118:	5c7d                	li	s8,-1
    8000311a:	a091                	j	8000315e <writei+0x8e>
    8000311c:	020d1d93          	slli	s11,s10,0x20
    80003120:	020ddd93          	srli	s11,s11,0x20
    80003124:	05848513          	addi	a0,s1,88
    80003128:	86ee                	mv	a3,s11
    8000312a:	8652                	mv	a2,s4
    8000312c:	85de                	mv	a1,s7
    8000312e:	953a                	add	a0,a0,a4
    80003130:	fffff097          	auipc	ra,0xfffff
    80003134:	a48080e7          	jalr	-1464(ra) # 80001b78 <either_copyin>
    80003138:	07850263          	beq	a0,s8,8000319c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000313c:	8526                	mv	a0,s1
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	75e080e7          	jalr	1886(ra) # 8000389c <log_write>
    brelse(bp);
    80003146:	8526                	mv	a0,s1
    80003148:	fffff097          	auipc	ra,0xfffff
    8000314c:	4fc080e7          	jalr	1276(ra) # 80002644 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003150:	013d09bb          	addw	s3,s10,s3
    80003154:	012d093b          	addw	s2,s10,s2
    80003158:	9a6e                	add	s4,s4,s11
    8000315a:	0569f663          	bgeu	s3,s6,800031a6 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000315e:	00a9559b          	srliw	a1,s2,0xa
    80003162:	8556                	mv	a0,s5
    80003164:	fffff097          	auipc	ra,0xfffff
    80003168:	7a2080e7          	jalr	1954(ra) # 80002906 <bmap>
    8000316c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003170:	c99d                	beqz	a1,800031a6 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003172:	000aa503          	lw	a0,0(s5)
    80003176:	fffff097          	auipc	ra,0xfffff
    8000317a:	39e080e7          	jalr	926(ra) # 80002514 <bread>
    8000317e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003180:	3ff97713          	andi	a4,s2,1023
    80003184:	40ec87bb          	subw	a5,s9,a4
    80003188:	413b06bb          	subw	a3,s6,s3
    8000318c:	8d3e                	mv	s10,a5
    8000318e:	2781                	sext.w	a5,a5
    80003190:	0006861b          	sext.w	a2,a3
    80003194:	f8f674e3          	bgeu	a2,a5,8000311c <writei+0x4c>
    80003198:	8d36                	mv	s10,a3
    8000319a:	b749                	j	8000311c <writei+0x4c>
      brelse(bp);
    8000319c:	8526                	mv	a0,s1
    8000319e:	fffff097          	auipc	ra,0xfffff
    800031a2:	4a6080e7          	jalr	1190(ra) # 80002644 <brelse>
  }

  if(off > ip->size)
    800031a6:	04caa783          	lw	a5,76(s5)
    800031aa:	0127f463          	bgeu	a5,s2,800031b2 <writei+0xe2>
    ip->size = off;
    800031ae:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031b2:	8556                	mv	a0,s5
    800031b4:	00000097          	auipc	ra,0x0
    800031b8:	aa4080e7          	jalr	-1372(ra) # 80002c58 <iupdate>

  return tot;
    800031bc:	0009851b          	sext.w	a0,s3
}
    800031c0:	70a6                	ld	ra,104(sp)
    800031c2:	7406                	ld	s0,96(sp)
    800031c4:	64e6                	ld	s1,88(sp)
    800031c6:	6946                	ld	s2,80(sp)
    800031c8:	69a6                	ld	s3,72(sp)
    800031ca:	6a06                	ld	s4,64(sp)
    800031cc:	7ae2                	ld	s5,56(sp)
    800031ce:	7b42                	ld	s6,48(sp)
    800031d0:	7ba2                	ld	s7,40(sp)
    800031d2:	7c02                	ld	s8,32(sp)
    800031d4:	6ce2                	ld	s9,24(sp)
    800031d6:	6d42                	ld	s10,16(sp)
    800031d8:	6da2                	ld	s11,8(sp)
    800031da:	6165                	addi	sp,sp,112
    800031dc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031de:	89da                	mv	s3,s6
    800031e0:	bfc9                	j	800031b2 <writei+0xe2>
    return -1;
    800031e2:	557d                	li	a0,-1
}
    800031e4:	8082                	ret
    return -1;
    800031e6:	557d                	li	a0,-1
    800031e8:	bfe1                	j	800031c0 <writei+0xf0>
    return -1;
    800031ea:	557d                	li	a0,-1
    800031ec:	bfd1                	j	800031c0 <writei+0xf0>

00000000800031ee <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031ee:	1141                	addi	sp,sp,-16
    800031f0:	e406                	sd	ra,8(sp)
    800031f2:	e022                	sd	s0,0(sp)
    800031f4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031f6:	4639                	li	a2,14
    800031f8:	ffffd097          	auipc	ra,0xffffd
    800031fc:	172080e7          	jalr	370(ra) # 8000036a <strncmp>
}
    80003200:	60a2                	ld	ra,8(sp)
    80003202:	6402                	ld	s0,0(sp)
    80003204:	0141                	addi	sp,sp,16
    80003206:	8082                	ret

0000000080003208 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003208:	7139                	addi	sp,sp,-64
    8000320a:	fc06                	sd	ra,56(sp)
    8000320c:	f822                	sd	s0,48(sp)
    8000320e:	f426                	sd	s1,40(sp)
    80003210:	f04a                	sd	s2,32(sp)
    80003212:	ec4e                	sd	s3,24(sp)
    80003214:	e852                	sd	s4,16(sp)
    80003216:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003218:	04451703          	lh	a4,68(a0)
    8000321c:	4785                	li	a5,1
    8000321e:	00f71a63          	bne	a4,a5,80003232 <dirlookup+0x2a>
    80003222:	892a                	mv	s2,a0
    80003224:	89ae                	mv	s3,a1
    80003226:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003228:	457c                	lw	a5,76(a0)
    8000322a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000322c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322e:	e79d                	bnez	a5,8000325c <dirlookup+0x54>
    80003230:	a8a5                	j	800032a8 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003232:	00005517          	auipc	a0,0x5
    80003236:	3ae50513          	addi	a0,a0,942 # 800085e0 <syscalls+0x1a0>
    8000323a:	00003097          	auipc	ra,0x3
    8000323e:	b3c080e7          	jalr	-1220(ra) # 80005d76 <panic>
      panic("dirlookup read");
    80003242:	00005517          	auipc	a0,0x5
    80003246:	3b650513          	addi	a0,a0,950 # 800085f8 <syscalls+0x1b8>
    8000324a:	00003097          	auipc	ra,0x3
    8000324e:	b2c080e7          	jalr	-1236(ra) # 80005d76 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003252:	24c1                	addiw	s1,s1,16
    80003254:	04c92783          	lw	a5,76(s2)
    80003258:	04f4f763          	bgeu	s1,a5,800032a6 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000325c:	4741                	li	a4,16
    8000325e:	86a6                	mv	a3,s1
    80003260:	fc040613          	addi	a2,s0,-64
    80003264:	4581                	li	a1,0
    80003266:	854a                	mv	a0,s2
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	d70080e7          	jalr	-656(ra) # 80002fd8 <readi>
    80003270:	47c1                	li	a5,16
    80003272:	fcf518e3          	bne	a0,a5,80003242 <dirlookup+0x3a>
    if(de.inum == 0)
    80003276:	fc045783          	lhu	a5,-64(s0)
    8000327a:	dfe1                	beqz	a5,80003252 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000327c:	fc240593          	addi	a1,s0,-62
    80003280:	854e                	mv	a0,s3
    80003282:	00000097          	auipc	ra,0x0
    80003286:	f6c080e7          	jalr	-148(ra) # 800031ee <namecmp>
    8000328a:	f561                	bnez	a0,80003252 <dirlookup+0x4a>
      if(poff)
    8000328c:	000a0463          	beqz	s4,80003294 <dirlookup+0x8c>
        *poff = off;
    80003290:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003294:	fc045583          	lhu	a1,-64(s0)
    80003298:	00092503          	lw	a0,0(s2)
    8000329c:	fffff097          	auipc	ra,0xfffff
    800032a0:	754080e7          	jalr	1876(ra) # 800029f0 <iget>
    800032a4:	a011                	j	800032a8 <dirlookup+0xa0>
  return 0;
    800032a6:	4501                	li	a0,0
}
    800032a8:	70e2                	ld	ra,56(sp)
    800032aa:	7442                	ld	s0,48(sp)
    800032ac:	74a2                	ld	s1,40(sp)
    800032ae:	7902                	ld	s2,32(sp)
    800032b0:	69e2                	ld	s3,24(sp)
    800032b2:	6a42                	ld	s4,16(sp)
    800032b4:	6121                	addi	sp,sp,64
    800032b6:	8082                	ret

00000000800032b8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032b8:	711d                	addi	sp,sp,-96
    800032ba:	ec86                	sd	ra,88(sp)
    800032bc:	e8a2                	sd	s0,80(sp)
    800032be:	e4a6                	sd	s1,72(sp)
    800032c0:	e0ca                	sd	s2,64(sp)
    800032c2:	fc4e                	sd	s3,56(sp)
    800032c4:	f852                	sd	s4,48(sp)
    800032c6:	f456                	sd	s5,40(sp)
    800032c8:	f05a                	sd	s6,32(sp)
    800032ca:	ec5e                	sd	s7,24(sp)
    800032cc:	e862                	sd	s8,16(sp)
    800032ce:	e466                	sd	s9,8(sp)
    800032d0:	1080                	addi	s0,sp,96
    800032d2:	84aa                	mv	s1,a0
    800032d4:	8b2e                	mv	s6,a1
    800032d6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032d8:	00054703          	lbu	a4,0(a0)
    800032dc:	02f00793          	li	a5,47
    800032e0:	02f70263          	beq	a4,a5,80003304 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032e4:	ffffe097          	auipc	ra,0xffffe
    800032e8:	d8e080e7          	jalr	-626(ra) # 80001072 <myproc>
    800032ec:	15053503          	ld	a0,336(a0)
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	9f6080e7          	jalr	-1546(ra) # 80002ce6 <idup>
    800032f8:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032fa:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032fe:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003300:	4b85                	li	s7,1
    80003302:	a875                	j	800033be <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003304:	4585                	li	a1,1
    80003306:	4505                	li	a0,1
    80003308:	fffff097          	auipc	ra,0xfffff
    8000330c:	6e8080e7          	jalr	1768(ra) # 800029f0 <iget>
    80003310:	8a2a                	mv	s4,a0
    80003312:	b7e5                	j	800032fa <namex+0x42>
      iunlockput(ip);
    80003314:	8552                	mv	a0,s4
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	c70080e7          	jalr	-912(ra) # 80002f86 <iunlockput>
      return 0;
    8000331e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003320:	8552                	mv	a0,s4
    80003322:	60e6                	ld	ra,88(sp)
    80003324:	6446                	ld	s0,80(sp)
    80003326:	64a6                	ld	s1,72(sp)
    80003328:	6906                	ld	s2,64(sp)
    8000332a:	79e2                	ld	s3,56(sp)
    8000332c:	7a42                	ld	s4,48(sp)
    8000332e:	7aa2                	ld	s5,40(sp)
    80003330:	7b02                	ld	s6,32(sp)
    80003332:	6be2                	ld	s7,24(sp)
    80003334:	6c42                	ld	s8,16(sp)
    80003336:	6ca2                	ld	s9,8(sp)
    80003338:	6125                	addi	sp,sp,96
    8000333a:	8082                	ret
      iunlock(ip);
    8000333c:	8552                	mv	a0,s4
    8000333e:	00000097          	auipc	ra,0x0
    80003342:	aa8080e7          	jalr	-1368(ra) # 80002de6 <iunlock>
      return ip;
    80003346:	bfe9                	j	80003320 <namex+0x68>
      iunlockput(ip);
    80003348:	8552                	mv	a0,s4
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	c3c080e7          	jalr	-964(ra) # 80002f86 <iunlockput>
      return 0;
    80003352:	8a4e                	mv	s4,s3
    80003354:	b7f1                	j	80003320 <namex+0x68>
  len = path - s;
    80003356:	40998633          	sub	a2,s3,s1
    8000335a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000335e:	099c5863          	bge	s8,s9,800033ee <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003362:	4639                	li	a2,14
    80003364:	85a6                	mv	a1,s1
    80003366:	8556                	mv	a0,s5
    80003368:	ffffd097          	auipc	ra,0xffffd
    8000336c:	f8e080e7          	jalr	-114(ra) # 800002f6 <memmove>
    80003370:	84ce                	mv	s1,s3
  while(*path == '/')
    80003372:	0004c783          	lbu	a5,0(s1)
    80003376:	01279763          	bne	a5,s2,80003384 <namex+0xcc>
    path++;
    8000337a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000337c:	0004c783          	lbu	a5,0(s1)
    80003380:	ff278de3          	beq	a5,s2,8000337a <namex+0xc2>
    ilock(ip);
    80003384:	8552                	mv	a0,s4
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	99e080e7          	jalr	-1634(ra) # 80002d24 <ilock>
    if(ip->type != T_DIR){
    8000338e:	044a1783          	lh	a5,68(s4)
    80003392:	f97791e3          	bne	a5,s7,80003314 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003396:	000b0563          	beqz	s6,800033a0 <namex+0xe8>
    8000339a:	0004c783          	lbu	a5,0(s1)
    8000339e:	dfd9                	beqz	a5,8000333c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033a0:	4601                	li	a2,0
    800033a2:	85d6                	mv	a1,s5
    800033a4:	8552                	mv	a0,s4
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	e62080e7          	jalr	-414(ra) # 80003208 <dirlookup>
    800033ae:	89aa                	mv	s3,a0
    800033b0:	dd41                	beqz	a0,80003348 <namex+0x90>
    iunlockput(ip);
    800033b2:	8552                	mv	a0,s4
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	bd2080e7          	jalr	-1070(ra) # 80002f86 <iunlockput>
    ip = next;
    800033bc:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033be:	0004c783          	lbu	a5,0(s1)
    800033c2:	01279763          	bne	a5,s2,800033d0 <namex+0x118>
    path++;
    800033c6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033c8:	0004c783          	lbu	a5,0(s1)
    800033cc:	ff278de3          	beq	a5,s2,800033c6 <namex+0x10e>
  if(*path == 0)
    800033d0:	cb9d                	beqz	a5,80003406 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800033d2:	0004c783          	lbu	a5,0(s1)
    800033d6:	89a6                	mv	s3,s1
  len = path - s;
    800033d8:	4c81                	li	s9,0
    800033da:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800033dc:	01278963          	beq	a5,s2,800033ee <namex+0x136>
    800033e0:	dbbd                	beqz	a5,80003356 <namex+0x9e>
    path++;
    800033e2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033e4:	0009c783          	lbu	a5,0(s3)
    800033e8:	ff279ce3          	bne	a5,s2,800033e0 <namex+0x128>
    800033ec:	b7ad                	j	80003356 <namex+0x9e>
    memmove(name, s, len);
    800033ee:	2601                	sext.w	a2,a2
    800033f0:	85a6                	mv	a1,s1
    800033f2:	8556                	mv	a0,s5
    800033f4:	ffffd097          	auipc	ra,0xffffd
    800033f8:	f02080e7          	jalr	-254(ra) # 800002f6 <memmove>
    name[len] = 0;
    800033fc:	9cd6                	add	s9,s9,s5
    800033fe:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003402:	84ce                	mv	s1,s3
    80003404:	b7bd                	j	80003372 <namex+0xba>
  if(nameiparent){
    80003406:	f00b0de3          	beqz	s6,80003320 <namex+0x68>
    iput(ip);
    8000340a:	8552                	mv	a0,s4
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	ad2080e7          	jalr	-1326(ra) # 80002ede <iput>
    return 0;
    80003414:	4a01                	li	s4,0
    80003416:	b729                	j	80003320 <namex+0x68>

0000000080003418 <dirlink>:
{
    80003418:	7139                	addi	sp,sp,-64
    8000341a:	fc06                	sd	ra,56(sp)
    8000341c:	f822                	sd	s0,48(sp)
    8000341e:	f426                	sd	s1,40(sp)
    80003420:	f04a                	sd	s2,32(sp)
    80003422:	ec4e                	sd	s3,24(sp)
    80003424:	e852                	sd	s4,16(sp)
    80003426:	0080                	addi	s0,sp,64
    80003428:	892a                	mv	s2,a0
    8000342a:	8a2e                	mv	s4,a1
    8000342c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000342e:	4601                	li	a2,0
    80003430:	00000097          	auipc	ra,0x0
    80003434:	dd8080e7          	jalr	-552(ra) # 80003208 <dirlookup>
    80003438:	e93d                	bnez	a0,800034ae <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000343a:	04c92483          	lw	s1,76(s2)
    8000343e:	c49d                	beqz	s1,8000346c <dirlink+0x54>
    80003440:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003442:	4741                	li	a4,16
    80003444:	86a6                	mv	a3,s1
    80003446:	fc040613          	addi	a2,s0,-64
    8000344a:	4581                	li	a1,0
    8000344c:	854a                	mv	a0,s2
    8000344e:	00000097          	auipc	ra,0x0
    80003452:	b8a080e7          	jalr	-1142(ra) # 80002fd8 <readi>
    80003456:	47c1                	li	a5,16
    80003458:	06f51163          	bne	a0,a5,800034ba <dirlink+0xa2>
    if(de.inum == 0)
    8000345c:	fc045783          	lhu	a5,-64(s0)
    80003460:	c791                	beqz	a5,8000346c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003462:	24c1                	addiw	s1,s1,16
    80003464:	04c92783          	lw	a5,76(s2)
    80003468:	fcf4ede3          	bltu	s1,a5,80003442 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000346c:	4639                	li	a2,14
    8000346e:	85d2                	mv	a1,s4
    80003470:	fc240513          	addi	a0,s0,-62
    80003474:	ffffd097          	auipc	ra,0xffffd
    80003478:	f32080e7          	jalr	-206(ra) # 800003a6 <strncpy>
  de.inum = inum;
    8000347c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003480:	4741                	li	a4,16
    80003482:	86a6                	mv	a3,s1
    80003484:	fc040613          	addi	a2,s0,-64
    80003488:	4581                	li	a1,0
    8000348a:	854a                	mv	a0,s2
    8000348c:	00000097          	auipc	ra,0x0
    80003490:	c44080e7          	jalr	-956(ra) # 800030d0 <writei>
    80003494:	1541                	addi	a0,a0,-16
    80003496:	00a03533          	snez	a0,a0
    8000349a:	40a00533          	neg	a0,a0
}
    8000349e:	70e2                	ld	ra,56(sp)
    800034a0:	7442                	ld	s0,48(sp)
    800034a2:	74a2                	ld	s1,40(sp)
    800034a4:	7902                	ld	s2,32(sp)
    800034a6:	69e2                	ld	s3,24(sp)
    800034a8:	6a42                	ld	s4,16(sp)
    800034aa:	6121                	addi	sp,sp,64
    800034ac:	8082                	ret
    iput(ip);
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	a30080e7          	jalr	-1488(ra) # 80002ede <iput>
    return -1;
    800034b6:	557d                	li	a0,-1
    800034b8:	b7dd                	j	8000349e <dirlink+0x86>
      panic("dirlink read");
    800034ba:	00005517          	auipc	a0,0x5
    800034be:	14e50513          	addi	a0,a0,334 # 80008608 <syscalls+0x1c8>
    800034c2:	00003097          	auipc	ra,0x3
    800034c6:	8b4080e7          	jalr	-1868(ra) # 80005d76 <panic>

00000000800034ca <namei>:

struct inode*
namei(char *path)
{
    800034ca:	1101                	addi	sp,sp,-32
    800034cc:	ec06                	sd	ra,24(sp)
    800034ce:	e822                	sd	s0,16(sp)
    800034d0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034d2:	fe040613          	addi	a2,s0,-32
    800034d6:	4581                	li	a1,0
    800034d8:	00000097          	auipc	ra,0x0
    800034dc:	de0080e7          	jalr	-544(ra) # 800032b8 <namex>
}
    800034e0:	60e2                	ld	ra,24(sp)
    800034e2:	6442                	ld	s0,16(sp)
    800034e4:	6105                	addi	sp,sp,32
    800034e6:	8082                	ret

00000000800034e8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034e8:	1141                	addi	sp,sp,-16
    800034ea:	e406                	sd	ra,8(sp)
    800034ec:	e022                	sd	s0,0(sp)
    800034ee:	0800                	addi	s0,sp,16
    800034f0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034f2:	4585                	li	a1,1
    800034f4:	00000097          	auipc	ra,0x0
    800034f8:	dc4080e7          	jalr	-572(ra) # 800032b8 <namex>
}
    800034fc:	60a2                	ld	ra,8(sp)
    800034fe:	6402                	ld	s0,0(sp)
    80003500:	0141                	addi	sp,sp,16
    80003502:	8082                	ret

0000000080003504 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003504:	1101                	addi	sp,sp,-32
    80003506:	ec06                	sd	ra,24(sp)
    80003508:	e822                	sd	s0,16(sp)
    8000350a:	e426                	sd	s1,8(sp)
    8000350c:	e04a                	sd	s2,0(sp)
    8000350e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003510:	00235917          	auipc	s2,0x235
    80003514:	41090913          	addi	s2,s2,1040 # 80238920 <log>
    80003518:	01892583          	lw	a1,24(s2)
    8000351c:	02892503          	lw	a0,40(s2)
    80003520:	fffff097          	auipc	ra,0xfffff
    80003524:	ff4080e7          	jalr	-12(ra) # 80002514 <bread>
    80003528:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000352a:	02c92603          	lw	a2,44(s2)
    8000352e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003530:	00c05f63          	blez	a2,8000354e <write_head+0x4a>
    80003534:	00235717          	auipc	a4,0x235
    80003538:	41c70713          	addi	a4,a4,1052 # 80238950 <log+0x30>
    8000353c:	87aa                	mv	a5,a0
    8000353e:	060a                	slli	a2,a2,0x2
    80003540:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003542:	4314                	lw	a3,0(a4)
    80003544:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003546:	0711                	addi	a4,a4,4
    80003548:	0791                	addi	a5,a5,4
    8000354a:	fec79ce3          	bne	a5,a2,80003542 <write_head+0x3e>
  }
  bwrite(buf);
    8000354e:	8526                	mv	a0,s1
    80003550:	fffff097          	auipc	ra,0xfffff
    80003554:	0b6080e7          	jalr	182(ra) # 80002606 <bwrite>
  brelse(buf);
    80003558:	8526                	mv	a0,s1
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	0ea080e7          	jalr	234(ra) # 80002644 <brelse>
}
    80003562:	60e2                	ld	ra,24(sp)
    80003564:	6442                	ld	s0,16(sp)
    80003566:	64a2                	ld	s1,8(sp)
    80003568:	6902                	ld	s2,0(sp)
    8000356a:	6105                	addi	sp,sp,32
    8000356c:	8082                	ret

000000008000356e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000356e:	00235797          	auipc	a5,0x235
    80003572:	3de7a783          	lw	a5,990(a5) # 8023894c <log+0x2c>
    80003576:	0af05d63          	blez	a5,80003630 <install_trans+0xc2>
{
    8000357a:	7139                	addi	sp,sp,-64
    8000357c:	fc06                	sd	ra,56(sp)
    8000357e:	f822                	sd	s0,48(sp)
    80003580:	f426                	sd	s1,40(sp)
    80003582:	f04a                	sd	s2,32(sp)
    80003584:	ec4e                	sd	s3,24(sp)
    80003586:	e852                	sd	s4,16(sp)
    80003588:	e456                	sd	s5,8(sp)
    8000358a:	e05a                	sd	s6,0(sp)
    8000358c:	0080                	addi	s0,sp,64
    8000358e:	8b2a                	mv	s6,a0
    80003590:	00235a97          	auipc	s5,0x235
    80003594:	3c0a8a93          	addi	s5,s5,960 # 80238950 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003598:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000359a:	00235997          	auipc	s3,0x235
    8000359e:	38698993          	addi	s3,s3,902 # 80238920 <log>
    800035a2:	a00d                	j	800035c4 <install_trans+0x56>
    brelse(lbuf);
    800035a4:	854a                	mv	a0,s2
    800035a6:	fffff097          	auipc	ra,0xfffff
    800035aa:	09e080e7          	jalr	158(ra) # 80002644 <brelse>
    brelse(dbuf);
    800035ae:	8526                	mv	a0,s1
    800035b0:	fffff097          	auipc	ra,0xfffff
    800035b4:	094080e7          	jalr	148(ra) # 80002644 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b8:	2a05                	addiw	s4,s4,1
    800035ba:	0a91                	addi	s5,s5,4
    800035bc:	02c9a783          	lw	a5,44(s3)
    800035c0:	04fa5e63          	bge	s4,a5,8000361c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035c4:	0189a583          	lw	a1,24(s3)
    800035c8:	014585bb          	addw	a1,a1,s4
    800035cc:	2585                	addiw	a1,a1,1
    800035ce:	0289a503          	lw	a0,40(s3)
    800035d2:	fffff097          	auipc	ra,0xfffff
    800035d6:	f42080e7          	jalr	-190(ra) # 80002514 <bread>
    800035da:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035dc:	000aa583          	lw	a1,0(s5)
    800035e0:	0289a503          	lw	a0,40(s3)
    800035e4:	fffff097          	auipc	ra,0xfffff
    800035e8:	f30080e7          	jalr	-208(ra) # 80002514 <bread>
    800035ec:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035ee:	40000613          	li	a2,1024
    800035f2:	05890593          	addi	a1,s2,88
    800035f6:	05850513          	addi	a0,a0,88
    800035fa:	ffffd097          	auipc	ra,0xffffd
    800035fe:	cfc080e7          	jalr	-772(ra) # 800002f6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003602:	8526                	mv	a0,s1
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	002080e7          	jalr	2(ra) # 80002606 <bwrite>
    if(recovering == 0)
    8000360c:	f80b1ce3          	bnez	s6,800035a4 <install_trans+0x36>
      bunpin(dbuf);
    80003610:	8526                	mv	a0,s1
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	10a080e7          	jalr	266(ra) # 8000271c <bunpin>
    8000361a:	b769                	j	800035a4 <install_trans+0x36>
}
    8000361c:	70e2                	ld	ra,56(sp)
    8000361e:	7442                	ld	s0,48(sp)
    80003620:	74a2                	ld	s1,40(sp)
    80003622:	7902                	ld	s2,32(sp)
    80003624:	69e2                	ld	s3,24(sp)
    80003626:	6a42                	ld	s4,16(sp)
    80003628:	6aa2                	ld	s5,8(sp)
    8000362a:	6b02                	ld	s6,0(sp)
    8000362c:	6121                	addi	sp,sp,64
    8000362e:	8082                	ret
    80003630:	8082                	ret

0000000080003632 <initlog>:
{
    80003632:	7179                	addi	sp,sp,-48
    80003634:	f406                	sd	ra,40(sp)
    80003636:	f022                	sd	s0,32(sp)
    80003638:	ec26                	sd	s1,24(sp)
    8000363a:	e84a                	sd	s2,16(sp)
    8000363c:	e44e                	sd	s3,8(sp)
    8000363e:	1800                	addi	s0,sp,48
    80003640:	892a                	mv	s2,a0
    80003642:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003644:	00235497          	auipc	s1,0x235
    80003648:	2dc48493          	addi	s1,s1,732 # 80238920 <log>
    8000364c:	00005597          	auipc	a1,0x5
    80003650:	fcc58593          	addi	a1,a1,-52 # 80008618 <syscalls+0x1d8>
    80003654:	8526                	mv	a0,s1
    80003656:	00003097          	auipc	ra,0x3
    8000365a:	bc8080e7          	jalr	-1080(ra) # 8000621e <initlock>
  log.start = sb->logstart;
    8000365e:	0149a583          	lw	a1,20(s3)
    80003662:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003664:	0109a783          	lw	a5,16(s3)
    80003668:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000366a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000366e:	854a                	mv	a0,s2
    80003670:	fffff097          	auipc	ra,0xfffff
    80003674:	ea4080e7          	jalr	-348(ra) # 80002514 <bread>
  log.lh.n = lh->n;
    80003678:	4d30                	lw	a2,88(a0)
    8000367a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000367c:	00c05f63          	blez	a2,8000369a <initlog+0x68>
    80003680:	87aa                	mv	a5,a0
    80003682:	00235717          	auipc	a4,0x235
    80003686:	2ce70713          	addi	a4,a4,718 # 80238950 <log+0x30>
    8000368a:	060a                	slli	a2,a2,0x2
    8000368c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000368e:	4ff4                	lw	a3,92(a5)
    80003690:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003692:	0791                	addi	a5,a5,4
    80003694:	0711                	addi	a4,a4,4
    80003696:	fec79ce3          	bne	a5,a2,8000368e <initlog+0x5c>
  brelse(buf);
    8000369a:	fffff097          	auipc	ra,0xfffff
    8000369e:	faa080e7          	jalr	-86(ra) # 80002644 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036a2:	4505                	li	a0,1
    800036a4:	00000097          	auipc	ra,0x0
    800036a8:	eca080e7          	jalr	-310(ra) # 8000356e <install_trans>
  log.lh.n = 0;
    800036ac:	00235797          	auipc	a5,0x235
    800036b0:	2a07a023          	sw	zero,672(a5) # 8023894c <log+0x2c>
  write_head(); // clear the log
    800036b4:	00000097          	auipc	ra,0x0
    800036b8:	e50080e7          	jalr	-432(ra) # 80003504 <write_head>
}
    800036bc:	70a2                	ld	ra,40(sp)
    800036be:	7402                	ld	s0,32(sp)
    800036c0:	64e2                	ld	s1,24(sp)
    800036c2:	6942                	ld	s2,16(sp)
    800036c4:	69a2                	ld	s3,8(sp)
    800036c6:	6145                	addi	sp,sp,48
    800036c8:	8082                	ret

00000000800036ca <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036ca:	1101                	addi	sp,sp,-32
    800036cc:	ec06                	sd	ra,24(sp)
    800036ce:	e822                	sd	s0,16(sp)
    800036d0:	e426                	sd	s1,8(sp)
    800036d2:	e04a                	sd	s2,0(sp)
    800036d4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036d6:	00235517          	auipc	a0,0x235
    800036da:	24a50513          	addi	a0,a0,586 # 80238920 <log>
    800036de:	00003097          	auipc	ra,0x3
    800036e2:	bd0080e7          	jalr	-1072(ra) # 800062ae <acquire>
  while(1){
    if(log.committing){
    800036e6:	00235497          	auipc	s1,0x235
    800036ea:	23a48493          	addi	s1,s1,570 # 80238920 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036ee:	4979                	li	s2,30
    800036f0:	a039                	j	800036fe <begin_op+0x34>
      sleep(&log, &log.lock);
    800036f2:	85a6                	mv	a1,s1
    800036f4:	8526                	mv	a0,s1
    800036f6:	ffffe097          	auipc	ra,0xffffe
    800036fa:	024080e7          	jalr	36(ra) # 8000171a <sleep>
    if(log.committing){
    800036fe:	50dc                	lw	a5,36(s1)
    80003700:	fbed                	bnez	a5,800036f2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003702:	5098                	lw	a4,32(s1)
    80003704:	2705                	addiw	a4,a4,1
    80003706:	0027179b          	slliw	a5,a4,0x2
    8000370a:	9fb9                	addw	a5,a5,a4
    8000370c:	0017979b          	slliw	a5,a5,0x1
    80003710:	54d4                	lw	a3,44(s1)
    80003712:	9fb5                	addw	a5,a5,a3
    80003714:	00f95963          	bge	s2,a5,80003726 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003718:	85a6                	mv	a1,s1
    8000371a:	8526                	mv	a0,s1
    8000371c:	ffffe097          	auipc	ra,0xffffe
    80003720:	ffe080e7          	jalr	-2(ra) # 8000171a <sleep>
    80003724:	bfe9                	j	800036fe <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003726:	00235517          	auipc	a0,0x235
    8000372a:	1fa50513          	addi	a0,a0,506 # 80238920 <log>
    8000372e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003730:	00003097          	auipc	ra,0x3
    80003734:	c32080e7          	jalr	-974(ra) # 80006362 <release>
      break;
    }
  }
}
    80003738:	60e2                	ld	ra,24(sp)
    8000373a:	6442                	ld	s0,16(sp)
    8000373c:	64a2                	ld	s1,8(sp)
    8000373e:	6902                	ld	s2,0(sp)
    80003740:	6105                	addi	sp,sp,32
    80003742:	8082                	ret

0000000080003744 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003744:	7139                	addi	sp,sp,-64
    80003746:	fc06                	sd	ra,56(sp)
    80003748:	f822                	sd	s0,48(sp)
    8000374a:	f426                	sd	s1,40(sp)
    8000374c:	f04a                	sd	s2,32(sp)
    8000374e:	ec4e                	sd	s3,24(sp)
    80003750:	e852                	sd	s4,16(sp)
    80003752:	e456                	sd	s5,8(sp)
    80003754:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003756:	00235497          	auipc	s1,0x235
    8000375a:	1ca48493          	addi	s1,s1,458 # 80238920 <log>
    8000375e:	8526                	mv	a0,s1
    80003760:	00003097          	auipc	ra,0x3
    80003764:	b4e080e7          	jalr	-1202(ra) # 800062ae <acquire>
  log.outstanding -= 1;
    80003768:	509c                	lw	a5,32(s1)
    8000376a:	37fd                	addiw	a5,a5,-1
    8000376c:	0007891b          	sext.w	s2,a5
    80003770:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003772:	50dc                	lw	a5,36(s1)
    80003774:	e7b9                	bnez	a5,800037c2 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003776:	04091e63          	bnez	s2,800037d2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000377a:	00235497          	auipc	s1,0x235
    8000377e:	1a648493          	addi	s1,s1,422 # 80238920 <log>
    80003782:	4785                	li	a5,1
    80003784:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003786:	8526                	mv	a0,s1
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	bda080e7          	jalr	-1062(ra) # 80006362 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003790:	54dc                	lw	a5,44(s1)
    80003792:	06f04763          	bgtz	a5,80003800 <end_op+0xbc>
    acquire(&log.lock);
    80003796:	00235497          	auipc	s1,0x235
    8000379a:	18a48493          	addi	s1,s1,394 # 80238920 <log>
    8000379e:	8526                	mv	a0,s1
    800037a0:	00003097          	auipc	ra,0x3
    800037a4:	b0e080e7          	jalr	-1266(ra) # 800062ae <acquire>
    log.committing = 0;
    800037a8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037ac:	8526                	mv	a0,s1
    800037ae:	ffffe097          	auipc	ra,0xffffe
    800037b2:	fd0080e7          	jalr	-48(ra) # 8000177e <wakeup>
    release(&log.lock);
    800037b6:	8526                	mv	a0,s1
    800037b8:	00003097          	auipc	ra,0x3
    800037bc:	baa080e7          	jalr	-1110(ra) # 80006362 <release>
}
    800037c0:	a03d                	j	800037ee <end_op+0xaa>
    panic("log.committing");
    800037c2:	00005517          	auipc	a0,0x5
    800037c6:	e5e50513          	addi	a0,a0,-418 # 80008620 <syscalls+0x1e0>
    800037ca:	00002097          	auipc	ra,0x2
    800037ce:	5ac080e7          	jalr	1452(ra) # 80005d76 <panic>
    wakeup(&log);
    800037d2:	00235497          	auipc	s1,0x235
    800037d6:	14e48493          	addi	s1,s1,334 # 80238920 <log>
    800037da:	8526                	mv	a0,s1
    800037dc:	ffffe097          	auipc	ra,0xffffe
    800037e0:	fa2080e7          	jalr	-94(ra) # 8000177e <wakeup>
  release(&log.lock);
    800037e4:	8526                	mv	a0,s1
    800037e6:	00003097          	auipc	ra,0x3
    800037ea:	b7c080e7          	jalr	-1156(ra) # 80006362 <release>
}
    800037ee:	70e2                	ld	ra,56(sp)
    800037f0:	7442                	ld	s0,48(sp)
    800037f2:	74a2                	ld	s1,40(sp)
    800037f4:	7902                	ld	s2,32(sp)
    800037f6:	69e2                	ld	s3,24(sp)
    800037f8:	6a42                	ld	s4,16(sp)
    800037fa:	6aa2                	ld	s5,8(sp)
    800037fc:	6121                	addi	sp,sp,64
    800037fe:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003800:	00235a97          	auipc	s5,0x235
    80003804:	150a8a93          	addi	s5,s5,336 # 80238950 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003808:	00235a17          	auipc	s4,0x235
    8000380c:	118a0a13          	addi	s4,s4,280 # 80238920 <log>
    80003810:	018a2583          	lw	a1,24(s4)
    80003814:	012585bb          	addw	a1,a1,s2
    80003818:	2585                	addiw	a1,a1,1
    8000381a:	028a2503          	lw	a0,40(s4)
    8000381e:	fffff097          	auipc	ra,0xfffff
    80003822:	cf6080e7          	jalr	-778(ra) # 80002514 <bread>
    80003826:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003828:	000aa583          	lw	a1,0(s5)
    8000382c:	028a2503          	lw	a0,40(s4)
    80003830:	fffff097          	auipc	ra,0xfffff
    80003834:	ce4080e7          	jalr	-796(ra) # 80002514 <bread>
    80003838:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000383a:	40000613          	li	a2,1024
    8000383e:	05850593          	addi	a1,a0,88
    80003842:	05848513          	addi	a0,s1,88
    80003846:	ffffd097          	auipc	ra,0xffffd
    8000384a:	ab0080e7          	jalr	-1360(ra) # 800002f6 <memmove>
    bwrite(to);  // write the log
    8000384e:	8526                	mv	a0,s1
    80003850:	fffff097          	auipc	ra,0xfffff
    80003854:	db6080e7          	jalr	-586(ra) # 80002606 <bwrite>
    brelse(from);
    80003858:	854e                	mv	a0,s3
    8000385a:	fffff097          	auipc	ra,0xfffff
    8000385e:	dea080e7          	jalr	-534(ra) # 80002644 <brelse>
    brelse(to);
    80003862:	8526                	mv	a0,s1
    80003864:	fffff097          	auipc	ra,0xfffff
    80003868:	de0080e7          	jalr	-544(ra) # 80002644 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000386c:	2905                	addiw	s2,s2,1
    8000386e:	0a91                	addi	s5,s5,4
    80003870:	02ca2783          	lw	a5,44(s4)
    80003874:	f8f94ee3          	blt	s2,a5,80003810 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003878:	00000097          	auipc	ra,0x0
    8000387c:	c8c080e7          	jalr	-884(ra) # 80003504 <write_head>
    install_trans(0); // Now install writes to home locations
    80003880:	4501                	li	a0,0
    80003882:	00000097          	auipc	ra,0x0
    80003886:	cec080e7          	jalr	-788(ra) # 8000356e <install_trans>
    log.lh.n = 0;
    8000388a:	00235797          	auipc	a5,0x235
    8000388e:	0c07a123          	sw	zero,194(a5) # 8023894c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003892:	00000097          	auipc	ra,0x0
    80003896:	c72080e7          	jalr	-910(ra) # 80003504 <write_head>
    8000389a:	bdf5                	j	80003796 <end_op+0x52>

000000008000389c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000389c:	1101                	addi	sp,sp,-32
    8000389e:	ec06                	sd	ra,24(sp)
    800038a0:	e822                	sd	s0,16(sp)
    800038a2:	e426                	sd	s1,8(sp)
    800038a4:	e04a                	sd	s2,0(sp)
    800038a6:	1000                	addi	s0,sp,32
    800038a8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038aa:	00235917          	auipc	s2,0x235
    800038ae:	07690913          	addi	s2,s2,118 # 80238920 <log>
    800038b2:	854a                	mv	a0,s2
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	9fa080e7          	jalr	-1542(ra) # 800062ae <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038bc:	02c92603          	lw	a2,44(s2)
    800038c0:	47f5                	li	a5,29
    800038c2:	06c7c563          	blt	a5,a2,8000392c <log_write+0x90>
    800038c6:	00235797          	auipc	a5,0x235
    800038ca:	0767a783          	lw	a5,118(a5) # 8023893c <log+0x1c>
    800038ce:	37fd                	addiw	a5,a5,-1
    800038d0:	04f65e63          	bge	a2,a5,8000392c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038d4:	00235797          	auipc	a5,0x235
    800038d8:	06c7a783          	lw	a5,108(a5) # 80238940 <log+0x20>
    800038dc:	06f05063          	blez	a5,8000393c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038e0:	4781                	li	a5,0
    800038e2:	06c05563          	blez	a2,8000394c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038e6:	44cc                	lw	a1,12(s1)
    800038e8:	00235717          	auipc	a4,0x235
    800038ec:	06870713          	addi	a4,a4,104 # 80238950 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038f0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038f2:	4314                	lw	a3,0(a4)
    800038f4:	04b68c63          	beq	a3,a1,8000394c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038f8:	2785                	addiw	a5,a5,1
    800038fa:	0711                	addi	a4,a4,4
    800038fc:	fef61be3          	bne	a2,a5,800038f2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003900:	0621                	addi	a2,a2,8
    80003902:	060a                	slli	a2,a2,0x2
    80003904:	00235797          	auipc	a5,0x235
    80003908:	01c78793          	addi	a5,a5,28 # 80238920 <log>
    8000390c:	97b2                	add	a5,a5,a2
    8000390e:	44d8                	lw	a4,12(s1)
    80003910:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003912:	8526                	mv	a0,s1
    80003914:	fffff097          	auipc	ra,0xfffff
    80003918:	dcc080e7          	jalr	-564(ra) # 800026e0 <bpin>
    log.lh.n++;
    8000391c:	00235717          	auipc	a4,0x235
    80003920:	00470713          	addi	a4,a4,4 # 80238920 <log>
    80003924:	575c                	lw	a5,44(a4)
    80003926:	2785                	addiw	a5,a5,1
    80003928:	d75c                	sw	a5,44(a4)
    8000392a:	a82d                	j	80003964 <log_write+0xc8>
    panic("too big a transaction");
    8000392c:	00005517          	auipc	a0,0x5
    80003930:	d0450513          	addi	a0,a0,-764 # 80008630 <syscalls+0x1f0>
    80003934:	00002097          	auipc	ra,0x2
    80003938:	442080e7          	jalr	1090(ra) # 80005d76 <panic>
    panic("log_write outside of trans");
    8000393c:	00005517          	auipc	a0,0x5
    80003940:	d0c50513          	addi	a0,a0,-756 # 80008648 <syscalls+0x208>
    80003944:	00002097          	auipc	ra,0x2
    80003948:	432080e7          	jalr	1074(ra) # 80005d76 <panic>
  log.lh.block[i] = b->blockno;
    8000394c:	00878693          	addi	a3,a5,8
    80003950:	068a                	slli	a3,a3,0x2
    80003952:	00235717          	auipc	a4,0x235
    80003956:	fce70713          	addi	a4,a4,-50 # 80238920 <log>
    8000395a:	9736                	add	a4,a4,a3
    8000395c:	44d4                	lw	a3,12(s1)
    8000395e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003960:	faf609e3          	beq	a2,a5,80003912 <log_write+0x76>
  }
  release(&log.lock);
    80003964:	00235517          	auipc	a0,0x235
    80003968:	fbc50513          	addi	a0,a0,-68 # 80238920 <log>
    8000396c:	00003097          	auipc	ra,0x3
    80003970:	9f6080e7          	jalr	-1546(ra) # 80006362 <release>
}
    80003974:	60e2                	ld	ra,24(sp)
    80003976:	6442                	ld	s0,16(sp)
    80003978:	64a2                	ld	s1,8(sp)
    8000397a:	6902                	ld	s2,0(sp)
    8000397c:	6105                	addi	sp,sp,32
    8000397e:	8082                	ret

0000000080003980 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003980:	1101                	addi	sp,sp,-32
    80003982:	ec06                	sd	ra,24(sp)
    80003984:	e822                	sd	s0,16(sp)
    80003986:	e426                	sd	s1,8(sp)
    80003988:	e04a                	sd	s2,0(sp)
    8000398a:	1000                	addi	s0,sp,32
    8000398c:	84aa                	mv	s1,a0
    8000398e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003990:	00005597          	auipc	a1,0x5
    80003994:	cd858593          	addi	a1,a1,-808 # 80008668 <syscalls+0x228>
    80003998:	0521                	addi	a0,a0,8
    8000399a:	00003097          	auipc	ra,0x3
    8000399e:	884080e7          	jalr	-1916(ra) # 8000621e <initlock>
  lk->name = name;
    800039a2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039a6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039aa:	0204a423          	sw	zero,40(s1)
}
    800039ae:	60e2                	ld	ra,24(sp)
    800039b0:	6442                	ld	s0,16(sp)
    800039b2:	64a2                	ld	s1,8(sp)
    800039b4:	6902                	ld	s2,0(sp)
    800039b6:	6105                	addi	sp,sp,32
    800039b8:	8082                	ret

00000000800039ba <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039ba:	1101                	addi	sp,sp,-32
    800039bc:	ec06                	sd	ra,24(sp)
    800039be:	e822                	sd	s0,16(sp)
    800039c0:	e426                	sd	s1,8(sp)
    800039c2:	e04a                	sd	s2,0(sp)
    800039c4:	1000                	addi	s0,sp,32
    800039c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039c8:	00850913          	addi	s2,a0,8
    800039cc:	854a                	mv	a0,s2
    800039ce:	00003097          	auipc	ra,0x3
    800039d2:	8e0080e7          	jalr	-1824(ra) # 800062ae <acquire>
  while (lk->locked) {
    800039d6:	409c                	lw	a5,0(s1)
    800039d8:	cb89                	beqz	a5,800039ea <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039da:	85ca                	mv	a1,s2
    800039dc:	8526                	mv	a0,s1
    800039de:	ffffe097          	auipc	ra,0xffffe
    800039e2:	d3c080e7          	jalr	-708(ra) # 8000171a <sleep>
  while (lk->locked) {
    800039e6:	409c                	lw	a5,0(s1)
    800039e8:	fbed                	bnez	a5,800039da <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039ea:	4785                	li	a5,1
    800039ec:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039ee:	ffffd097          	auipc	ra,0xffffd
    800039f2:	684080e7          	jalr	1668(ra) # 80001072 <myproc>
    800039f6:	591c                	lw	a5,48(a0)
    800039f8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039fa:	854a                	mv	a0,s2
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	966080e7          	jalr	-1690(ra) # 80006362 <release>
}
    80003a04:	60e2                	ld	ra,24(sp)
    80003a06:	6442                	ld	s0,16(sp)
    80003a08:	64a2                	ld	s1,8(sp)
    80003a0a:	6902                	ld	s2,0(sp)
    80003a0c:	6105                	addi	sp,sp,32
    80003a0e:	8082                	ret

0000000080003a10 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a10:	1101                	addi	sp,sp,-32
    80003a12:	ec06                	sd	ra,24(sp)
    80003a14:	e822                	sd	s0,16(sp)
    80003a16:	e426                	sd	s1,8(sp)
    80003a18:	e04a                	sd	s2,0(sp)
    80003a1a:	1000                	addi	s0,sp,32
    80003a1c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a1e:	00850913          	addi	s2,a0,8
    80003a22:	854a                	mv	a0,s2
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	88a080e7          	jalr	-1910(ra) # 800062ae <acquire>
  lk->locked = 0;
    80003a2c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a30:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a34:	8526                	mv	a0,s1
    80003a36:	ffffe097          	auipc	ra,0xffffe
    80003a3a:	d48080e7          	jalr	-696(ra) # 8000177e <wakeup>
  release(&lk->lk);
    80003a3e:	854a                	mv	a0,s2
    80003a40:	00003097          	auipc	ra,0x3
    80003a44:	922080e7          	jalr	-1758(ra) # 80006362 <release>
}
    80003a48:	60e2                	ld	ra,24(sp)
    80003a4a:	6442                	ld	s0,16(sp)
    80003a4c:	64a2                	ld	s1,8(sp)
    80003a4e:	6902                	ld	s2,0(sp)
    80003a50:	6105                	addi	sp,sp,32
    80003a52:	8082                	ret

0000000080003a54 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a54:	7179                	addi	sp,sp,-48
    80003a56:	f406                	sd	ra,40(sp)
    80003a58:	f022                	sd	s0,32(sp)
    80003a5a:	ec26                	sd	s1,24(sp)
    80003a5c:	e84a                	sd	s2,16(sp)
    80003a5e:	e44e                	sd	s3,8(sp)
    80003a60:	1800                	addi	s0,sp,48
    80003a62:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a64:	00850913          	addi	s2,a0,8
    80003a68:	854a                	mv	a0,s2
    80003a6a:	00003097          	auipc	ra,0x3
    80003a6e:	844080e7          	jalr	-1980(ra) # 800062ae <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a72:	409c                	lw	a5,0(s1)
    80003a74:	ef99                	bnez	a5,80003a92 <holdingsleep+0x3e>
    80003a76:	4481                	li	s1,0
  release(&lk->lk);
    80003a78:	854a                	mv	a0,s2
    80003a7a:	00003097          	auipc	ra,0x3
    80003a7e:	8e8080e7          	jalr	-1816(ra) # 80006362 <release>
  return r;
}
    80003a82:	8526                	mv	a0,s1
    80003a84:	70a2                	ld	ra,40(sp)
    80003a86:	7402                	ld	s0,32(sp)
    80003a88:	64e2                	ld	s1,24(sp)
    80003a8a:	6942                	ld	s2,16(sp)
    80003a8c:	69a2                	ld	s3,8(sp)
    80003a8e:	6145                	addi	sp,sp,48
    80003a90:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a92:	0284a983          	lw	s3,40(s1)
    80003a96:	ffffd097          	auipc	ra,0xffffd
    80003a9a:	5dc080e7          	jalr	1500(ra) # 80001072 <myproc>
    80003a9e:	5904                	lw	s1,48(a0)
    80003aa0:	413484b3          	sub	s1,s1,s3
    80003aa4:	0014b493          	seqz	s1,s1
    80003aa8:	bfc1                	j	80003a78 <holdingsleep+0x24>

0000000080003aaa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003aaa:	1141                	addi	sp,sp,-16
    80003aac:	e406                	sd	ra,8(sp)
    80003aae:	e022                	sd	s0,0(sp)
    80003ab0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ab2:	00005597          	auipc	a1,0x5
    80003ab6:	bc658593          	addi	a1,a1,-1082 # 80008678 <syscalls+0x238>
    80003aba:	00235517          	auipc	a0,0x235
    80003abe:	fae50513          	addi	a0,a0,-82 # 80238a68 <ftable>
    80003ac2:	00002097          	auipc	ra,0x2
    80003ac6:	75c080e7          	jalr	1884(ra) # 8000621e <initlock>
}
    80003aca:	60a2                	ld	ra,8(sp)
    80003acc:	6402                	ld	s0,0(sp)
    80003ace:	0141                	addi	sp,sp,16
    80003ad0:	8082                	ret

0000000080003ad2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ad2:	1101                	addi	sp,sp,-32
    80003ad4:	ec06                	sd	ra,24(sp)
    80003ad6:	e822                	sd	s0,16(sp)
    80003ad8:	e426                	sd	s1,8(sp)
    80003ada:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003adc:	00235517          	auipc	a0,0x235
    80003ae0:	f8c50513          	addi	a0,a0,-116 # 80238a68 <ftable>
    80003ae4:	00002097          	auipc	ra,0x2
    80003ae8:	7ca080e7          	jalr	1994(ra) # 800062ae <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aec:	00235497          	auipc	s1,0x235
    80003af0:	f9448493          	addi	s1,s1,-108 # 80238a80 <ftable+0x18>
    80003af4:	00236717          	auipc	a4,0x236
    80003af8:	f2c70713          	addi	a4,a4,-212 # 80239a20 <disk>
    if(f->ref == 0){
    80003afc:	40dc                	lw	a5,4(s1)
    80003afe:	cf99                	beqz	a5,80003b1c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b00:	02848493          	addi	s1,s1,40
    80003b04:	fee49ce3          	bne	s1,a4,80003afc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b08:	00235517          	auipc	a0,0x235
    80003b0c:	f6050513          	addi	a0,a0,-160 # 80238a68 <ftable>
    80003b10:	00003097          	auipc	ra,0x3
    80003b14:	852080e7          	jalr	-1966(ra) # 80006362 <release>
  return 0;
    80003b18:	4481                	li	s1,0
    80003b1a:	a819                	j	80003b30 <filealloc+0x5e>
      f->ref = 1;
    80003b1c:	4785                	li	a5,1
    80003b1e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b20:	00235517          	auipc	a0,0x235
    80003b24:	f4850513          	addi	a0,a0,-184 # 80238a68 <ftable>
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	83a080e7          	jalr	-1990(ra) # 80006362 <release>
}
    80003b30:	8526                	mv	a0,s1
    80003b32:	60e2                	ld	ra,24(sp)
    80003b34:	6442                	ld	s0,16(sp)
    80003b36:	64a2                	ld	s1,8(sp)
    80003b38:	6105                	addi	sp,sp,32
    80003b3a:	8082                	ret

0000000080003b3c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b3c:	1101                	addi	sp,sp,-32
    80003b3e:	ec06                	sd	ra,24(sp)
    80003b40:	e822                	sd	s0,16(sp)
    80003b42:	e426                	sd	s1,8(sp)
    80003b44:	1000                	addi	s0,sp,32
    80003b46:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b48:	00235517          	auipc	a0,0x235
    80003b4c:	f2050513          	addi	a0,a0,-224 # 80238a68 <ftable>
    80003b50:	00002097          	auipc	ra,0x2
    80003b54:	75e080e7          	jalr	1886(ra) # 800062ae <acquire>
  if(f->ref < 1)
    80003b58:	40dc                	lw	a5,4(s1)
    80003b5a:	02f05263          	blez	a5,80003b7e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b5e:	2785                	addiw	a5,a5,1
    80003b60:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b62:	00235517          	auipc	a0,0x235
    80003b66:	f0650513          	addi	a0,a0,-250 # 80238a68 <ftable>
    80003b6a:	00002097          	auipc	ra,0x2
    80003b6e:	7f8080e7          	jalr	2040(ra) # 80006362 <release>
  return f;
}
    80003b72:	8526                	mv	a0,s1
    80003b74:	60e2                	ld	ra,24(sp)
    80003b76:	6442                	ld	s0,16(sp)
    80003b78:	64a2                	ld	s1,8(sp)
    80003b7a:	6105                	addi	sp,sp,32
    80003b7c:	8082                	ret
    panic("filedup");
    80003b7e:	00005517          	auipc	a0,0x5
    80003b82:	b0250513          	addi	a0,a0,-1278 # 80008680 <syscalls+0x240>
    80003b86:	00002097          	auipc	ra,0x2
    80003b8a:	1f0080e7          	jalr	496(ra) # 80005d76 <panic>

0000000080003b8e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b8e:	7139                	addi	sp,sp,-64
    80003b90:	fc06                	sd	ra,56(sp)
    80003b92:	f822                	sd	s0,48(sp)
    80003b94:	f426                	sd	s1,40(sp)
    80003b96:	f04a                	sd	s2,32(sp)
    80003b98:	ec4e                	sd	s3,24(sp)
    80003b9a:	e852                	sd	s4,16(sp)
    80003b9c:	e456                	sd	s5,8(sp)
    80003b9e:	0080                	addi	s0,sp,64
    80003ba0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ba2:	00235517          	auipc	a0,0x235
    80003ba6:	ec650513          	addi	a0,a0,-314 # 80238a68 <ftable>
    80003baa:	00002097          	auipc	ra,0x2
    80003bae:	704080e7          	jalr	1796(ra) # 800062ae <acquire>
  if(f->ref < 1)
    80003bb2:	40dc                	lw	a5,4(s1)
    80003bb4:	06f05163          	blez	a5,80003c16 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bb8:	37fd                	addiw	a5,a5,-1
    80003bba:	0007871b          	sext.w	a4,a5
    80003bbe:	c0dc                	sw	a5,4(s1)
    80003bc0:	06e04363          	bgtz	a4,80003c26 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bc4:	0004a903          	lw	s2,0(s1)
    80003bc8:	0094ca83          	lbu	s5,9(s1)
    80003bcc:	0104ba03          	ld	s4,16(s1)
    80003bd0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bd4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bd8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bdc:	00235517          	auipc	a0,0x235
    80003be0:	e8c50513          	addi	a0,a0,-372 # 80238a68 <ftable>
    80003be4:	00002097          	auipc	ra,0x2
    80003be8:	77e080e7          	jalr	1918(ra) # 80006362 <release>

  if(ff.type == FD_PIPE){
    80003bec:	4785                	li	a5,1
    80003bee:	04f90d63          	beq	s2,a5,80003c48 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bf2:	3979                	addiw	s2,s2,-2
    80003bf4:	4785                	li	a5,1
    80003bf6:	0527e063          	bltu	a5,s2,80003c36 <fileclose+0xa8>
    begin_op();
    80003bfa:	00000097          	auipc	ra,0x0
    80003bfe:	ad0080e7          	jalr	-1328(ra) # 800036ca <begin_op>
    iput(ff.ip);
    80003c02:	854e                	mv	a0,s3
    80003c04:	fffff097          	auipc	ra,0xfffff
    80003c08:	2da080e7          	jalr	730(ra) # 80002ede <iput>
    end_op();
    80003c0c:	00000097          	auipc	ra,0x0
    80003c10:	b38080e7          	jalr	-1224(ra) # 80003744 <end_op>
    80003c14:	a00d                	j	80003c36 <fileclose+0xa8>
    panic("fileclose");
    80003c16:	00005517          	auipc	a0,0x5
    80003c1a:	a7250513          	addi	a0,a0,-1422 # 80008688 <syscalls+0x248>
    80003c1e:	00002097          	auipc	ra,0x2
    80003c22:	158080e7          	jalr	344(ra) # 80005d76 <panic>
    release(&ftable.lock);
    80003c26:	00235517          	auipc	a0,0x235
    80003c2a:	e4250513          	addi	a0,a0,-446 # 80238a68 <ftable>
    80003c2e:	00002097          	auipc	ra,0x2
    80003c32:	734080e7          	jalr	1844(ra) # 80006362 <release>
  }
}
    80003c36:	70e2                	ld	ra,56(sp)
    80003c38:	7442                	ld	s0,48(sp)
    80003c3a:	74a2                	ld	s1,40(sp)
    80003c3c:	7902                	ld	s2,32(sp)
    80003c3e:	69e2                	ld	s3,24(sp)
    80003c40:	6a42                	ld	s4,16(sp)
    80003c42:	6aa2                	ld	s5,8(sp)
    80003c44:	6121                	addi	sp,sp,64
    80003c46:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c48:	85d6                	mv	a1,s5
    80003c4a:	8552                	mv	a0,s4
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	348080e7          	jalr	840(ra) # 80003f94 <pipeclose>
    80003c54:	b7cd                	j	80003c36 <fileclose+0xa8>

0000000080003c56 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c56:	715d                	addi	sp,sp,-80
    80003c58:	e486                	sd	ra,72(sp)
    80003c5a:	e0a2                	sd	s0,64(sp)
    80003c5c:	fc26                	sd	s1,56(sp)
    80003c5e:	f84a                	sd	s2,48(sp)
    80003c60:	f44e                	sd	s3,40(sp)
    80003c62:	0880                	addi	s0,sp,80
    80003c64:	84aa                	mv	s1,a0
    80003c66:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c68:	ffffd097          	auipc	ra,0xffffd
    80003c6c:	40a080e7          	jalr	1034(ra) # 80001072 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c70:	409c                	lw	a5,0(s1)
    80003c72:	37f9                	addiw	a5,a5,-2
    80003c74:	4705                	li	a4,1
    80003c76:	04f76763          	bltu	a4,a5,80003cc4 <filestat+0x6e>
    80003c7a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c7c:	6c88                	ld	a0,24(s1)
    80003c7e:	fffff097          	auipc	ra,0xfffff
    80003c82:	0a6080e7          	jalr	166(ra) # 80002d24 <ilock>
    stati(f->ip, &st);
    80003c86:	fb840593          	addi	a1,s0,-72
    80003c8a:	6c88                	ld	a0,24(s1)
    80003c8c:	fffff097          	auipc	ra,0xfffff
    80003c90:	322080e7          	jalr	802(ra) # 80002fae <stati>
    iunlock(f->ip);
    80003c94:	6c88                	ld	a0,24(s1)
    80003c96:	fffff097          	auipc	ra,0xfffff
    80003c9a:	150080e7          	jalr	336(ra) # 80002de6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c9e:	46e1                	li	a3,24
    80003ca0:	fb840613          	addi	a2,s0,-72
    80003ca4:	85ce                	mv	a1,s3
    80003ca6:	05093503          	ld	a0,80(s2)
    80003caa:	ffffd097          	auipc	ra,0xffffd
    80003cae:	142080e7          	jalr	322(ra) # 80000dec <copyout>
    80003cb2:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cb6:	60a6                	ld	ra,72(sp)
    80003cb8:	6406                	ld	s0,64(sp)
    80003cba:	74e2                	ld	s1,56(sp)
    80003cbc:	7942                	ld	s2,48(sp)
    80003cbe:	79a2                	ld	s3,40(sp)
    80003cc0:	6161                	addi	sp,sp,80
    80003cc2:	8082                	ret
  return -1;
    80003cc4:	557d                	li	a0,-1
    80003cc6:	bfc5                	j	80003cb6 <filestat+0x60>

0000000080003cc8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cc8:	7179                	addi	sp,sp,-48
    80003cca:	f406                	sd	ra,40(sp)
    80003ccc:	f022                	sd	s0,32(sp)
    80003cce:	ec26                	sd	s1,24(sp)
    80003cd0:	e84a                	sd	s2,16(sp)
    80003cd2:	e44e                	sd	s3,8(sp)
    80003cd4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cd6:	00854783          	lbu	a5,8(a0)
    80003cda:	c3d5                	beqz	a5,80003d7e <fileread+0xb6>
    80003cdc:	84aa                	mv	s1,a0
    80003cde:	89ae                	mv	s3,a1
    80003ce0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ce2:	411c                	lw	a5,0(a0)
    80003ce4:	4705                	li	a4,1
    80003ce6:	04e78963          	beq	a5,a4,80003d38 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cea:	470d                	li	a4,3
    80003cec:	04e78d63          	beq	a5,a4,80003d46 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cf0:	4709                	li	a4,2
    80003cf2:	06e79e63          	bne	a5,a4,80003d6e <fileread+0xa6>
    ilock(f->ip);
    80003cf6:	6d08                	ld	a0,24(a0)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	02c080e7          	jalr	44(ra) # 80002d24 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d00:	874a                	mv	a4,s2
    80003d02:	5094                	lw	a3,32(s1)
    80003d04:	864e                	mv	a2,s3
    80003d06:	4585                	li	a1,1
    80003d08:	6c88                	ld	a0,24(s1)
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	2ce080e7          	jalr	718(ra) # 80002fd8 <readi>
    80003d12:	892a                	mv	s2,a0
    80003d14:	00a05563          	blez	a0,80003d1e <fileread+0x56>
      f->off += r;
    80003d18:	509c                	lw	a5,32(s1)
    80003d1a:	9fa9                	addw	a5,a5,a0
    80003d1c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d1e:	6c88                	ld	a0,24(s1)
    80003d20:	fffff097          	auipc	ra,0xfffff
    80003d24:	0c6080e7          	jalr	198(ra) # 80002de6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d28:	854a                	mv	a0,s2
    80003d2a:	70a2                	ld	ra,40(sp)
    80003d2c:	7402                	ld	s0,32(sp)
    80003d2e:	64e2                	ld	s1,24(sp)
    80003d30:	6942                	ld	s2,16(sp)
    80003d32:	69a2                	ld	s3,8(sp)
    80003d34:	6145                	addi	sp,sp,48
    80003d36:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d38:	6908                	ld	a0,16(a0)
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	3c2080e7          	jalr	962(ra) # 800040fc <piperead>
    80003d42:	892a                	mv	s2,a0
    80003d44:	b7d5                	j	80003d28 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d46:	02451783          	lh	a5,36(a0)
    80003d4a:	03079693          	slli	a3,a5,0x30
    80003d4e:	92c1                	srli	a3,a3,0x30
    80003d50:	4725                	li	a4,9
    80003d52:	02d76863          	bltu	a4,a3,80003d82 <fileread+0xba>
    80003d56:	0792                	slli	a5,a5,0x4
    80003d58:	00235717          	auipc	a4,0x235
    80003d5c:	c7070713          	addi	a4,a4,-912 # 802389c8 <devsw>
    80003d60:	97ba                	add	a5,a5,a4
    80003d62:	639c                	ld	a5,0(a5)
    80003d64:	c38d                	beqz	a5,80003d86 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d66:	4505                	li	a0,1
    80003d68:	9782                	jalr	a5
    80003d6a:	892a                	mv	s2,a0
    80003d6c:	bf75                	j	80003d28 <fileread+0x60>
    panic("fileread");
    80003d6e:	00005517          	auipc	a0,0x5
    80003d72:	92a50513          	addi	a0,a0,-1750 # 80008698 <syscalls+0x258>
    80003d76:	00002097          	auipc	ra,0x2
    80003d7a:	000080e7          	jalr	ra # 80005d76 <panic>
    return -1;
    80003d7e:	597d                	li	s2,-1
    80003d80:	b765                	j	80003d28 <fileread+0x60>
      return -1;
    80003d82:	597d                	li	s2,-1
    80003d84:	b755                	j	80003d28 <fileread+0x60>
    80003d86:	597d                	li	s2,-1
    80003d88:	b745                	j	80003d28 <fileread+0x60>

0000000080003d8a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003d8a:	00954783          	lbu	a5,9(a0)
    80003d8e:	10078e63          	beqz	a5,80003eaa <filewrite+0x120>
{
    80003d92:	715d                	addi	sp,sp,-80
    80003d94:	e486                	sd	ra,72(sp)
    80003d96:	e0a2                	sd	s0,64(sp)
    80003d98:	fc26                	sd	s1,56(sp)
    80003d9a:	f84a                	sd	s2,48(sp)
    80003d9c:	f44e                	sd	s3,40(sp)
    80003d9e:	f052                	sd	s4,32(sp)
    80003da0:	ec56                	sd	s5,24(sp)
    80003da2:	e85a                	sd	s6,16(sp)
    80003da4:	e45e                	sd	s7,8(sp)
    80003da6:	e062                	sd	s8,0(sp)
    80003da8:	0880                	addi	s0,sp,80
    80003daa:	892a                	mv	s2,a0
    80003dac:	8b2e                	mv	s6,a1
    80003dae:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003db0:	411c                	lw	a5,0(a0)
    80003db2:	4705                	li	a4,1
    80003db4:	02e78263          	beq	a5,a4,80003dd8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003db8:	470d                	li	a4,3
    80003dba:	02e78563          	beq	a5,a4,80003de4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dbe:	4709                	li	a4,2
    80003dc0:	0ce79d63          	bne	a5,a4,80003e9a <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dc4:	0ac05b63          	blez	a2,80003e7a <filewrite+0xf0>
    int i = 0;
    80003dc8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003dca:	6b85                	lui	s7,0x1
    80003dcc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003dd0:	6c05                	lui	s8,0x1
    80003dd2:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003dd6:	a851                	j	80003e6a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003dd8:	6908                	ld	a0,16(a0)
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	22a080e7          	jalr	554(ra) # 80004004 <pipewrite>
    80003de2:	a045                	j	80003e82 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003de4:	02451783          	lh	a5,36(a0)
    80003de8:	03079693          	slli	a3,a5,0x30
    80003dec:	92c1                	srli	a3,a3,0x30
    80003dee:	4725                	li	a4,9
    80003df0:	0ad76f63          	bltu	a4,a3,80003eae <filewrite+0x124>
    80003df4:	0792                	slli	a5,a5,0x4
    80003df6:	00235717          	auipc	a4,0x235
    80003dfa:	bd270713          	addi	a4,a4,-1070 # 802389c8 <devsw>
    80003dfe:	97ba                	add	a5,a5,a4
    80003e00:	679c                	ld	a5,8(a5)
    80003e02:	cbc5                	beqz	a5,80003eb2 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003e04:	4505                	li	a0,1
    80003e06:	9782                	jalr	a5
    80003e08:	a8ad                	j	80003e82 <filewrite+0xf8>
      if(n1 > max)
    80003e0a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	8bc080e7          	jalr	-1860(ra) # 800036ca <begin_op>
      ilock(f->ip);
    80003e16:	01893503          	ld	a0,24(s2)
    80003e1a:	fffff097          	auipc	ra,0xfffff
    80003e1e:	f0a080e7          	jalr	-246(ra) # 80002d24 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e22:	8756                	mv	a4,s5
    80003e24:	02092683          	lw	a3,32(s2)
    80003e28:	01698633          	add	a2,s3,s6
    80003e2c:	4585                	li	a1,1
    80003e2e:	01893503          	ld	a0,24(s2)
    80003e32:	fffff097          	auipc	ra,0xfffff
    80003e36:	29e080e7          	jalr	670(ra) # 800030d0 <writei>
    80003e3a:	84aa                	mv	s1,a0
    80003e3c:	00a05763          	blez	a0,80003e4a <filewrite+0xc0>
        f->off += r;
    80003e40:	02092783          	lw	a5,32(s2)
    80003e44:	9fa9                	addw	a5,a5,a0
    80003e46:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e4a:	01893503          	ld	a0,24(s2)
    80003e4e:	fffff097          	auipc	ra,0xfffff
    80003e52:	f98080e7          	jalr	-104(ra) # 80002de6 <iunlock>
      end_op();
    80003e56:	00000097          	auipc	ra,0x0
    80003e5a:	8ee080e7          	jalr	-1810(ra) # 80003744 <end_op>

      if(r != n1){
    80003e5e:	009a9f63          	bne	s5,s1,80003e7c <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003e62:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e66:	0149db63          	bge	s3,s4,80003e7c <filewrite+0xf2>
      int n1 = n - i;
    80003e6a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003e6e:	0004879b          	sext.w	a5,s1
    80003e72:	f8fbdce3          	bge	s7,a5,80003e0a <filewrite+0x80>
    80003e76:	84e2                	mv	s1,s8
    80003e78:	bf49                	j	80003e0a <filewrite+0x80>
    int i = 0;
    80003e7a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e7c:	033a1d63          	bne	s4,s3,80003eb6 <filewrite+0x12c>
    80003e80:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e82:	60a6                	ld	ra,72(sp)
    80003e84:	6406                	ld	s0,64(sp)
    80003e86:	74e2                	ld	s1,56(sp)
    80003e88:	7942                	ld	s2,48(sp)
    80003e8a:	79a2                	ld	s3,40(sp)
    80003e8c:	7a02                	ld	s4,32(sp)
    80003e8e:	6ae2                	ld	s5,24(sp)
    80003e90:	6b42                	ld	s6,16(sp)
    80003e92:	6ba2                	ld	s7,8(sp)
    80003e94:	6c02                	ld	s8,0(sp)
    80003e96:	6161                	addi	sp,sp,80
    80003e98:	8082                	ret
    panic("filewrite");
    80003e9a:	00005517          	auipc	a0,0x5
    80003e9e:	80e50513          	addi	a0,a0,-2034 # 800086a8 <syscalls+0x268>
    80003ea2:	00002097          	auipc	ra,0x2
    80003ea6:	ed4080e7          	jalr	-300(ra) # 80005d76 <panic>
    return -1;
    80003eaa:	557d                	li	a0,-1
}
    80003eac:	8082                	ret
      return -1;
    80003eae:	557d                	li	a0,-1
    80003eb0:	bfc9                	j	80003e82 <filewrite+0xf8>
    80003eb2:	557d                	li	a0,-1
    80003eb4:	b7f9                	j	80003e82 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003eb6:	557d                	li	a0,-1
    80003eb8:	b7e9                	j	80003e82 <filewrite+0xf8>

0000000080003eba <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003eba:	7179                	addi	sp,sp,-48
    80003ebc:	f406                	sd	ra,40(sp)
    80003ebe:	f022                	sd	s0,32(sp)
    80003ec0:	ec26                	sd	s1,24(sp)
    80003ec2:	e84a                	sd	s2,16(sp)
    80003ec4:	e44e                	sd	s3,8(sp)
    80003ec6:	e052                	sd	s4,0(sp)
    80003ec8:	1800                	addi	s0,sp,48
    80003eca:	84aa                	mv	s1,a0
    80003ecc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ece:	0005b023          	sd	zero,0(a1)
    80003ed2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ed6:	00000097          	auipc	ra,0x0
    80003eda:	bfc080e7          	jalr	-1028(ra) # 80003ad2 <filealloc>
    80003ede:	e088                	sd	a0,0(s1)
    80003ee0:	c551                	beqz	a0,80003f6c <pipealloc+0xb2>
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	bf0080e7          	jalr	-1040(ra) # 80003ad2 <filealloc>
    80003eea:	00aa3023          	sd	a0,0(s4)
    80003eee:	c92d                	beqz	a0,80003f60 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ef0:	ffffc097          	auipc	ra,0xffffc
    80003ef4:	312080e7          	jalr	786(ra) # 80000202 <kalloc>
    80003ef8:	892a                	mv	s2,a0
    80003efa:	c125                	beqz	a0,80003f5a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003efc:	4985                	li	s3,1
    80003efe:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f02:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f06:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f0a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f0e:	00004597          	auipc	a1,0x4
    80003f12:	7aa58593          	addi	a1,a1,1962 # 800086b8 <syscalls+0x278>
    80003f16:	00002097          	auipc	ra,0x2
    80003f1a:	308080e7          	jalr	776(ra) # 8000621e <initlock>
  (*f0)->type = FD_PIPE;
    80003f1e:	609c                	ld	a5,0(s1)
    80003f20:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f24:	609c                	ld	a5,0(s1)
    80003f26:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f2a:	609c                	ld	a5,0(s1)
    80003f2c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f30:	609c                	ld	a5,0(s1)
    80003f32:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f36:	000a3783          	ld	a5,0(s4)
    80003f3a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f3e:	000a3783          	ld	a5,0(s4)
    80003f42:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f46:	000a3783          	ld	a5,0(s4)
    80003f4a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f4e:	000a3783          	ld	a5,0(s4)
    80003f52:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f56:	4501                	li	a0,0
    80003f58:	a025                	j	80003f80 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f5a:	6088                	ld	a0,0(s1)
    80003f5c:	e501                	bnez	a0,80003f64 <pipealloc+0xaa>
    80003f5e:	a039                	j	80003f6c <pipealloc+0xb2>
    80003f60:	6088                	ld	a0,0(s1)
    80003f62:	c51d                	beqz	a0,80003f90 <pipealloc+0xd6>
    fileclose(*f0);
    80003f64:	00000097          	auipc	ra,0x0
    80003f68:	c2a080e7          	jalr	-982(ra) # 80003b8e <fileclose>
  if(*f1)
    80003f6c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f70:	557d                	li	a0,-1
  if(*f1)
    80003f72:	c799                	beqz	a5,80003f80 <pipealloc+0xc6>
    fileclose(*f1);
    80003f74:	853e                	mv	a0,a5
    80003f76:	00000097          	auipc	ra,0x0
    80003f7a:	c18080e7          	jalr	-1000(ra) # 80003b8e <fileclose>
  return -1;
    80003f7e:	557d                	li	a0,-1
}
    80003f80:	70a2                	ld	ra,40(sp)
    80003f82:	7402                	ld	s0,32(sp)
    80003f84:	64e2                	ld	s1,24(sp)
    80003f86:	6942                	ld	s2,16(sp)
    80003f88:	69a2                	ld	s3,8(sp)
    80003f8a:	6a02                	ld	s4,0(sp)
    80003f8c:	6145                	addi	sp,sp,48
    80003f8e:	8082                	ret
  return -1;
    80003f90:	557d                	li	a0,-1
    80003f92:	b7fd                	j	80003f80 <pipealloc+0xc6>

0000000080003f94 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f94:	1101                	addi	sp,sp,-32
    80003f96:	ec06                	sd	ra,24(sp)
    80003f98:	e822                	sd	s0,16(sp)
    80003f9a:	e426                	sd	s1,8(sp)
    80003f9c:	e04a                	sd	s2,0(sp)
    80003f9e:	1000                	addi	s0,sp,32
    80003fa0:	84aa                	mv	s1,a0
    80003fa2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	30a080e7          	jalr	778(ra) # 800062ae <acquire>
  if(writable){
    80003fac:	02090d63          	beqz	s2,80003fe6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fb0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fb4:	21848513          	addi	a0,s1,536
    80003fb8:	ffffd097          	auipc	ra,0xffffd
    80003fbc:	7c6080e7          	jalr	1990(ra) # 8000177e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fc0:	2204b783          	ld	a5,544(s1)
    80003fc4:	eb95                	bnez	a5,80003ff8 <pipeclose+0x64>
    release(&pi->lock);
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	00002097          	auipc	ra,0x2
    80003fcc:	39a080e7          	jalr	922(ra) # 80006362 <release>
    kfree((char*)pi);
    80003fd0:	8526                	mv	a0,s1
    80003fd2:	ffffc097          	auipc	ra,0xffffc
    80003fd6:	0b6080e7          	jalr	182(ra) # 80000088 <kfree>
  } else
    release(&pi->lock);
}
    80003fda:	60e2                	ld	ra,24(sp)
    80003fdc:	6442                	ld	s0,16(sp)
    80003fde:	64a2                	ld	s1,8(sp)
    80003fe0:	6902                	ld	s2,0(sp)
    80003fe2:	6105                	addi	sp,sp,32
    80003fe4:	8082                	ret
    pi->readopen = 0;
    80003fe6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fea:	21c48513          	addi	a0,s1,540
    80003fee:	ffffd097          	auipc	ra,0xffffd
    80003ff2:	790080e7          	jalr	1936(ra) # 8000177e <wakeup>
    80003ff6:	b7e9                	j	80003fc0 <pipeclose+0x2c>
    release(&pi->lock);
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	00002097          	auipc	ra,0x2
    80003ffe:	368080e7          	jalr	872(ra) # 80006362 <release>
}
    80004002:	bfe1                	j	80003fda <pipeclose+0x46>

0000000080004004 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004004:	711d                	addi	sp,sp,-96
    80004006:	ec86                	sd	ra,88(sp)
    80004008:	e8a2                	sd	s0,80(sp)
    8000400a:	e4a6                	sd	s1,72(sp)
    8000400c:	e0ca                	sd	s2,64(sp)
    8000400e:	fc4e                	sd	s3,56(sp)
    80004010:	f852                	sd	s4,48(sp)
    80004012:	f456                	sd	s5,40(sp)
    80004014:	f05a                	sd	s6,32(sp)
    80004016:	ec5e                	sd	s7,24(sp)
    80004018:	e862                	sd	s8,16(sp)
    8000401a:	1080                	addi	s0,sp,96
    8000401c:	84aa                	mv	s1,a0
    8000401e:	8aae                	mv	s5,a1
    80004020:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004022:	ffffd097          	auipc	ra,0xffffd
    80004026:	050080e7          	jalr	80(ra) # 80001072 <myproc>
    8000402a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000402c:	8526                	mv	a0,s1
    8000402e:	00002097          	auipc	ra,0x2
    80004032:	280080e7          	jalr	640(ra) # 800062ae <acquire>
  while(i < n){
    80004036:	0b405663          	blez	s4,800040e2 <pipewrite+0xde>
  int i = 0;
    8000403a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000403c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000403e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004042:	21c48b93          	addi	s7,s1,540
    80004046:	a089                	j	80004088 <pipewrite+0x84>
      release(&pi->lock);
    80004048:	8526                	mv	a0,s1
    8000404a:	00002097          	auipc	ra,0x2
    8000404e:	318080e7          	jalr	792(ra) # 80006362 <release>
      return -1;
    80004052:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004054:	854a                	mv	a0,s2
    80004056:	60e6                	ld	ra,88(sp)
    80004058:	6446                	ld	s0,80(sp)
    8000405a:	64a6                	ld	s1,72(sp)
    8000405c:	6906                	ld	s2,64(sp)
    8000405e:	79e2                	ld	s3,56(sp)
    80004060:	7a42                	ld	s4,48(sp)
    80004062:	7aa2                	ld	s5,40(sp)
    80004064:	7b02                	ld	s6,32(sp)
    80004066:	6be2                	ld	s7,24(sp)
    80004068:	6c42                	ld	s8,16(sp)
    8000406a:	6125                	addi	sp,sp,96
    8000406c:	8082                	ret
      wakeup(&pi->nread);
    8000406e:	8562                	mv	a0,s8
    80004070:	ffffd097          	auipc	ra,0xffffd
    80004074:	70e080e7          	jalr	1806(ra) # 8000177e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004078:	85a6                	mv	a1,s1
    8000407a:	855e                	mv	a0,s7
    8000407c:	ffffd097          	auipc	ra,0xffffd
    80004080:	69e080e7          	jalr	1694(ra) # 8000171a <sleep>
  while(i < n){
    80004084:	07495063          	bge	s2,s4,800040e4 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004088:	2204a783          	lw	a5,544(s1)
    8000408c:	dfd5                	beqz	a5,80004048 <pipewrite+0x44>
    8000408e:	854e                	mv	a0,s3
    80004090:	ffffe097          	auipc	ra,0xffffe
    80004094:	932080e7          	jalr	-1742(ra) # 800019c2 <killed>
    80004098:	f945                	bnez	a0,80004048 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000409a:	2184a783          	lw	a5,536(s1)
    8000409e:	21c4a703          	lw	a4,540(s1)
    800040a2:	2007879b          	addiw	a5,a5,512
    800040a6:	fcf704e3          	beq	a4,a5,8000406e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040aa:	4685                	li	a3,1
    800040ac:	01590633          	add	a2,s2,s5
    800040b0:	faf40593          	addi	a1,s0,-81
    800040b4:	0509b503          	ld	a0,80(s3)
    800040b8:	ffffd097          	auipc	ra,0xffffd
    800040bc:	b70080e7          	jalr	-1168(ra) # 80000c28 <copyin>
    800040c0:	03650263          	beq	a0,s6,800040e4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040c4:	21c4a783          	lw	a5,540(s1)
    800040c8:	0017871b          	addiw	a4,a5,1
    800040cc:	20e4ae23          	sw	a4,540(s1)
    800040d0:	1ff7f793          	andi	a5,a5,511
    800040d4:	97a6                	add	a5,a5,s1
    800040d6:	faf44703          	lbu	a4,-81(s0)
    800040da:	00e78c23          	sb	a4,24(a5)
      i++;
    800040de:	2905                	addiw	s2,s2,1
    800040e0:	b755                	j	80004084 <pipewrite+0x80>
  int i = 0;
    800040e2:	4901                	li	s2,0
  wakeup(&pi->nread);
    800040e4:	21848513          	addi	a0,s1,536
    800040e8:	ffffd097          	auipc	ra,0xffffd
    800040ec:	696080e7          	jalr	1686(ra) # 8000177e <wakeup>
  release(&pi->lock);
    800040f0:	8526                	mv	a0,s1
    800040f2:	00002097          	auipc	ra,0x2
    800040f6:	270080e7          	jalr	624(ra) # 80006362 <release>
  return i;
    800040fa:	bfa9                	j	80004054 <pipewrite+0x50>

00000000800040fc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040fc:	715d                	addi	sp,sp,-80
    800040fe:	e486                	sd	ra,72(sp)
    80004100:	e0a2                	sd	s0,64(sp)
    80004102:	fc26                	sd	s1,56(sp)
    80004104:	f84a                	sd	s2,48(sp)
    80004106:	f44e                	sd	s3,40(sp)
    80004108:	f052                	sd	s4,32(sp)
    8000410a:	ec56                	sd	s5,24(sp)
    8000410c:	e85a                	sd	s6,16(sp)
    8000410e:	0880                	addi	s0,sp,80
    80004110:	84aa                	mv	s1,a0
    80004112:	892e                	mv	s2,a1
    80004114:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	f5c080e7          	jalr	-164(ra) # 80001072 <myproc>
    8000411e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004120:	8526                	mv	a0,s1
    80004122:	00002097          	auipc	ra,0x2
    80004126:	18c080e7          	jalr	396(ra) # 800062ae <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000412a:	2184a703          	lw	a4,536(s1)
    8000412e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004132:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004136:	02f71763          	bne	a4,a5,80004164 <piperead+0x68>
    8000413a:	2244a783          	lw	a5,548(s1)
    8000413e:	c39d                	beqz	a5,80004164 <piperead+0x68>
    if(killed(pr)){
    80004140:	8552                	mv	a0,s4
    80004142:	ffffe097          	auipc	ra,0xffffe
    80004146:	880080e7          	jalr	-1920(ra) # 800019c2 <killed>
    8000414a:	e949                	bnez	a0,800041dc <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000414c:	85a6                	mv	a1,s1
    8000414e:	854e                	mv	a0,s3
    80004150:	ffffd097          	auipc	ra,0xffffd
    80004154:	5ca080e7          	jalr	1482(ra) # 8000171a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004158:	2184a703          	lw	a4,536(s1)
    8000415c:	21c4a783          	lw	a5,540(s1)
    80004160:	fcf70de3          	beq	a4,a5,8000413a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004164:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004166:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004168:	05505463          	blez	s5,800041b0 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    8000416c:	2184a783          	lw	a5,536(s1)
    80004170:	21c4a703          	lw	a4,540(s1)
    80004174:	02f70e63          	beq	a4,a5,800041b0 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004178:	0017871b          	addiw	a4,a5,1
    8000417c:	20e4ac23          	sw	a4,536(s1)
    80004180:	1ff7f793          	andi	a5,a5,511
    80004184:	97a6                	add	a5,a5,s1
    80004186:	0187c783          	lbu	a5,24(a5)
    8000418a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000418e:	4685                	li	a3,1
    80004190:	fbf40613          	addi	a2,s0,-65
    80004194:	85ca                	mv	a1,s2
    80004196:	050a3503          	ld	a0,80(s4)
    8000419a:	ffffd097          	auipc	ra,0xffffd
    8000419e:	c52080e7          	jalr	-942(ra) # 80000dec <copyout>
    800041a2:	01650763          	beq	a0,s6,800041b0 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041a6:	2985                	addiw	s3,s3,1
    800041a8:	0905                	addi	s2,s2,1
    800041aa:	fd3a91e3          	bne	s5,s3,8000416c <piperead+0x70>
    800041ae:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041b0:	21c48513          	addi	a0,s1,540
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	5ca080e7          	jalr	1482(ra) # 8000177e <wakeup>
  release(&pi->lock);
    800041bc:	8526                	mv	a0,s1
    800041be:	00002097          	auipc	ra,0x2
    800041c2:	1a4080e7          	jalr	420(ra) # 80006362 <release>
  return i;
}
    800041c6:	854e                	mv	a0,s3
    800041c8:	60a6                	ld	ra,72(sp)
    800041ca:	6406                	ld	s0,64(sp)
    800041cc:	74e2                	ld	s1,56(sp)
    800041ce:	7942                	ld	s2,48(sp)
    800041d0:	79a2                	ld	s3,40(sp)
    800041d2:	7a02                	ld	s4,32(sp)
    800041d4:	6ae2                	ld	s5,24(sp)
    800041d6:	6b42                	ld	s6,16(sp)
    800041d8:	6161                	addi	sp,sp,80
    800041da:	8082                	ret
      release(&pi->lock);
    800041dc:	8526                	mv	a0,s1
    800041de:	00002097          	auipc	ra,0x2
    800041e2:	184080e7          	jalr	388(ra) # 80006362 <release>
      return -1;
    800041e6:	59fd                	li	s3,-1
    800041e8:	bff9                	j	800041c6 <piperead+0xca>

00000000800041ea <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800041ea:	1141                	addi	sp,sp,-16
    800041ec:	e422                	sd	s0,8(sp)
    800041ee:	0800                	addi	s0,sp,16
    800041f0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800041f2:	8905                	andi	a0,a0,1
    800041f4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800041f6:	8b89                	andi	a5,a5,2
    800041f8:	c399                	beqz	a5,800041fe <flags2perm+0x14>
      perm |= PTE_W;
    800041fa:	00456513          	ori	a0,a0,4
    return perm;
}
    800041fe:	6422                	ld	s0,8(sp)
    80004200:	0141                	addi	sp,sp,16
    80004202:	8082                	ret

0000000080004204 <exec>:

int
exec(char *path, char **argv)
{
    80004204:	df010113          	addi	sp,sp,-528
    80004208:	20113423          	sd	ra,520(sp)
    8000420c:	20813023          	sd	s0,512(sp)
    80004210:	ffa6                	sd	s1,504(sp)
    80004212:	fbca                	sd	s2,496(sp)
    80004214:	f7ce                	sd	s3,488(sp)
    80004216:	f3d2                	sd	s4,480(sp)
    80004218:	efd6                	sd	s5,472(sp)
    8000421a:	ebda                	sd	s6,464(sp)
    8000421c:	e7de                	sd	s7,456(sp)
    8000421e:	e3e2                	sd	s8,448(sp)
    80004220:	ff66                	sd	s9,440(sp)
    80004222:	fb6a                	sd	s10,432(sp)
    80004224:	f76e                	sd	s11,424(sp)
    80004226:	0c00                	addi	s0,sp,528
    80004228:	892a                	mv	s2,a0
    8000422a:	dea43c23          	sd	a0,-520(s0)
    8000422e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004232:	ffffd097          	auipc	ra,0xffffd
    80004236:	e40080e7          	jalr	-448(ra) # 80001072 <myproc>
    8000423a:	84aa                	mv	s1,a0

  begin_op();
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	48e080e7          	jalr	1166(ra) # 800036ca <begin_op>

  if((ip = namei(path)) == 0){
    80004244:	854a                	mv	a0,s2
    80004246:	fffff097          	auipc	ra,0xfffff
    8000424a:	284080e7          	jalr	644(ra) # 800034ca <namei>
    8000424e:	c92d                	beqz	a0,800042c0 <exec+0xbc>
    80004250:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004252:	fffff097          	auipc	ra,0xfffff
    80004256:	ad2080e7          	jalr	-1326(ra) # 80002d24 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000425a:	04000713          	li	a4,64
    8000425e:	4681                	li	a3,0
    80004260:	e5040613          	addi	a2,s0,-432
    80004264:	4581                	li	a1,0
    80004266:	8552                	mv	a0,s4
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	d70080e7          	jalr	-656(ra) # 80002fd8 <readi>
    80004270:	04000793          	li	a5,64
    80004274:	00f51a63          	bne	a0,a5,80004288 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004278:	e5042703          	lw	a4,-432(s0)
    8000427c:	464c47b7          	lui	a5,0x464c4
    80004280:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004284:	04f70463          	beq	a4,a5,800042cc <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004288:	8552                	mv	a0,s4
    8000428a:	fffff097          	auipc	ra,0xfffff
    8000428e:	cfc080e7          	jalr	-772(ra) # 80002f86 <iunlockput>
    end_op();
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	4b2080e7          	jalr	1202(ra) # 80003744 <end_op>
  }
  return -1;
    8000429a:	557d                	li	a0,-1
}
    8000429c:	20813083          	ld	ra,520(sp)
    800042a0:	20013403          	ld	s0,512(sp)
    800042a4:	74fe                	ld	s1,504(sp)
    800042a6:	795e                	ld	s2,496(sp)
    800042a8:	79be                	ld	s3,488(sp)
    800042aa:	7a1e                	ld	s4,480(sp)
    800042ac:	6afe                	ld	s5,472(sp)
    800042ae:	6b5e                	ld	s6,464(sp)
    800042b0:	6bbe                	ld	s7,456(sp)
    800042b2:	6c1e                	ld	s8,448(sp)
    800042b4:	7cfa                	ld	s9,440(sp)
    800042b6:	7d5a                	ld	s10,432(sp)
    800042b8:	7dba                	ld	s11,424(sp)
    800042ba:	21010113          	addi	sp,sp,528
    800042be:	8082                	ret
    end_op();
    800042c0:	fffff097          	auipc	ra,0xfffff
    800042c4:	484080e7          	jalr	1156(ra) # 80003744 <end_op>
    return -1;
    800042c8:	557d                	li	a0,-1
    800042ca:	bfc9                	j	8000429c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042cc:	8526                	mv	a0,s1
    800042ce:	ffffd097          	auipc	ra,0xffffd
    800042d2:	e68080e7          	jalr	-408(ra) # 80001136 <proc_pagetable>
    800042d6:	8b2a                	mv	s6,a0
    800042d8:	d945                	beqz	a0,80004288 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042da:	e7042d03          	lw	s10,-400(s0)
    800042de:	e8845783          	lhu	a5,-376(s0)
    800042e2:	10078463          	beqz	a5,800043ea <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042e6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e8:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800042ea:	6c85                	lui	s9,0x1
    800042ec:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042f0:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800042f4:	6a85                	lui	s5,0x1
    800042f6:	a0b5                	j	80004362 <exec+0x15e>
      panic("loadseg: address should exist");
    800042f8:	00004517          	auipc	a0,0x4
    800042fc:	3c850513          	addi	a0,a0,968 # 800086c0 <syscalls+0x280>
    80004300:	00002097          	auipc	ra,0x2
    80004304:	a76080e7          	jalr	-1418(ra) # 80005d76 <panic>
    if(sz - i < PGSIZE)
    80004308:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000430a:	8726                	mv	a4,s1
    8000430c:	012c06bb          	addw	a3,s8,s2
    80004310:	4581                	li	a1,0
    80004312:	8552                	mv	a0,s4
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	cc4080e7          	jalr	-828(ra) # 80002fd8 <readi>
    8000431c:	2501                	sext.w	a0,a0
    8000431e:	24a49863          	bne	s1,a0,8000456e <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004322:	012a893b          	addw	s2,s5,s2
    80004326:	03397563          	bgeu	s2,s3,80004350 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    8000432a:	02091593          	slli	a1,s2,0x20
    8000432e:	9181                	srli	a1,a1,0x20
    80004330:	95de                	add	a1,a1,s7
    80004332:	855a                	mv	a0,s6
    80004334:	ffffc097          	auipc	ra,0xffffc
    80004338:	2ee080e7          	jalr	750(ra) # 80000622 <walkaddr>
    8000433c:	862a                	mv	a2,a0
    if(pa == 0)
    8000433e:	dd4d                	beqz	a0,800042f8 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004340:	412984bb          	subw	s1,s3,s2
    80004344:	0004879b          	sext.w	a5,s1
    80004348:	fcfcf0e3          	bgeu	s9,a5,80004308 <exec+0x104>
    8000434c:	84d6                	mv	s1,s5
    8000434e:	bf6d                	j	80004308 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004350:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004354:	2d85                	addiw	s11,s11,1
    80004356:	038d0d1b          	addiw	s10,s10,56
    8000435a:	e8845783          	lhu	a5,-376(s0)
    8000435e:	08fdd763          	bge	s11,a5,800043ec <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004362:	2d01                	sext.w	s10,s10
    80004364:	03800713          	li	a4,56
    80004368:	86ea                	mv	a3,s10
    8000436a:	e1840613          	addi	a2,s0,-488
    8000436e:	4581                	li	a1,0
    80004370:	8552                	mv	a0,s4
    80004372:	fffff097          	auipc	ra,0xfffff
    80004376:	c66080e7          	jalr	-922(ra) # 80002fd8 <readi>
    8000437a:	03800793          	li	a5,56
    8000437e:	1ef51663          	bne	a0,a5,8000456a <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004382:	e1842783          	lw	a5,-488(s0)
    80004386:	4705                	li	a4,1
    80004388:	fce796e3          	bne	a5,a4,80004354 <exec+0x150>
    if(ph.memsz < ph.filesz)
    8000438c:	e4043483          	ld	s1,-448(s0)
    80004390:	e3843783          	ld	a5,-456(s0)
    80004394:	1ef4e863          	bltu	s1,a5,80004584 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004398:	e2843783          	ld	a5,-472(s0)
    8000439c:	94be                	add	s1,s1,a5
    8000439e:	1ef4e663          	bltu	s1,a5,8000458a <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800043a2:	df043703          	ld	a4,-528(s0)
    800043a6:	8ff9                	and	a5,a5,a4
    800043a8:	1e079463          	bnez	a5,80004590 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043ac:	e1c42503          	lw	a0,-484(s0)
    800043b0:	00000097          	auipc	ra,0x0
    800043b4:	e3a080e7          	jalr	-454(ra) # 800041ea <flags2perm>
    800043b8:	86aa                	mv	a3,a0
    800043ba:	8626                	mv	a2,s1
    800043bc:	85ca                	mv	a1,s2
    800043be:	855a                	mv	a0,s6
    800043c0:	ffffc097          	auipc	ra,0xffffc
    800043c4:	616080e7          	jalr	1558(ra) # 800009d6 <uvmalloc>
    800043c8:	e0a43423          	sd	a0,-504(s0)
    800043cc:	1c050563          	beqz	a0,80004596 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043d0:	e2843b83          	ld	s7,-472(s0)
    800043d4:	e2042c03          	lw	s8,-480(s0)
    800043d8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043dc:	00098463          	beqz	s3,800043e4 <exec+0x1e0>
    800043e0:	4901                	li	s2,0
    800043e2:	b7a1                	j	8000432a <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043e4:	e0843903          	ld	s2,-504(s0)
    800043e8:	b7b5                	j	80004354 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043ea:	4901                	li	s2,0
  iunlockput(ip);
    800043ec:	8552                	mv	a0,s4
    800043ee:	fffff097          	auipc	ra,0xfffff
    800043f2:	b98080e7          	jalr	-1128(ra) # 80002f86 <iunlockput>
  end_op();
    800043f6:	fffff097          	auipc	ra,0xfffff
    800043fa:	34e080e7          	jalr	846(ra) # 80003744 <end_op>
  p = myproc();
    800043fe:	ffffd097          	auipc	ra,0xffffd
    80004402:	c74080e7          	jalr	-908(ra) # 80001072 <myproc>
    80004406:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004408:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000440c:	6985                	lui	s3,0x1
    8000440e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004410:	99ca                	add	s3,s3,s2
    80004412:	77fd                	lui	a5,0xfffff
    80004414:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004418:	4691                	li	a3,4
    8000441a:	6609                	lui	a2,0x2
    8000441c:	964e                	add	a2,a2,s3
    8000441e:	85ce                	mv	a1,s3
    80004420:	855a                	mv	a0,s6
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	5b4080e7          	jalr	1460(ra) # 800009d6 <uvmalloc>
    8000442a:	892a                	mv	s2,a0
    8000442c:	e0a43423          	sd	a0,-504(s0)
    80004430:	e509                	bnez	a0,8000443a <exec+0x236>
  if(pagetable)
    80004432:	e1343423          	sd	s3,-504(s0)
    80004436:	4a01                	li	s4,0
    80004438:	aa1d                	j	8000456e <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000443a:	75f9                	lui	a1,0xffffe
    8000443c:	95aa                	add	a1,a1,a0
    8000443e:	855a                	mv	a0,s6
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	7b6080e7          	jalr	1974(ra) # 80000bf6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004448:	7bfd                	lui	s7,0xfffff
    8000444a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000444c:	e0043783          	ld	a5,-512(s0)
    80004450:	6388                	ld	a0,0(a5)
    80004452:	c52d                	beqz	a0,800044bc <exec+0x2b8>
    80004454:	e9040993          	addi	s3,s0,-368
    80004458:	f9040c13          	addi	s8,s0,-112
    8000445c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000445e:	ffffc097          	auipc	ra,0xffffc
    80004462:	fb6080e7          	jalr	-74(ra) # 80000414 <strlen>
    80004466:	0015079b          	addiw	a5,a0,1
    8000446a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000446e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004472:	13796563          	bltu	s2,s7,8000459c <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004476:	e0043d03          	ld	s10,-512(s0)
    8000447a:	000d3a03          	ld	s4,0(s10)
    8000447e:	8552                	mv	a0,s4
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	f94080e7          	jalr	-108(ra) # 80000414 <strlen>
    80004488:	0015069b          	addiw	a3,a0,1
    8000448c:	8652                	mv	a2,s4
    8000448e:	85ca                	mv	a1,s2
    80004490:	855a                	mv	a0,s6
    80004492:	ffffd097          	auipc	ra,0xffffd
    80004496:	95a080e7          	jalr	-1702(ra) # 80000dec <copyout>
    8000449a:	10054363          	bltz	a0,800045a0 <exec+0x39c>
    ustack[argc] = sp;
    8000449e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044a2:	0485                	addi	s1,s1,1
    800044a4:	008d0793          	addi	a5,s10,8
    800044a8:	e0f43023          	sd	a5,-512(s0)
    800044ac:	008d3503          	ld	a0,8(s10)
    800044b0:	c909                	beqz	a0,800044c2 <exec+0x2be>
    if(argc >= MAXARG)
    800044b2:	09a1                	addi	s3,s3,8
    800044b4:	fb8995e3          	bne	s3,s8,8000445e <exec+0x25a>
  ip = 0;
    800044b8:	4a01                	li	s4,0
    800044ba:	a855                	j	8000456e <exec+0x36a>
  sp = sz;
    800044bc:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800044c0:	4481                	li	s1,0
  ustack[argc] = 0;
    800044c2:	00349793          	slli	a5,s1,0x3
    800044c6:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fdbd1f0>
    800044ca:	97a2                	add	a5,a5,s0
    800044cc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800044d0:	00148693          	addi	a3,s1,1
    800044d4:	068e                	slli	a3,a3,0x3
    800044d6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044da:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800044de:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800044e2:	f57968e3          	bltu	s2,s7,80004432 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044e6:	e9040613          	addi	a2,s0,-368
    800044ea:	85ca                	mv	a1,s2
    800044ec:	855a                	mv	a0,s6
    800044ee:	ffffd097          	auipc	ra,0xffffd
    800044f2:	8fe080e7          	jalr	-1794(ra) # 80000dec <copyout>
    800044f6:	0a054763          	bltz	a0,800045a4 <exec+0x3a0>
  p->trapframe->a1 = sp;
    800044fa:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800044fe:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004502:	df843783          	ld	a5,-520(s0)
    80004506:	0007c703          	lbu	a4,0(a5)
    8000450a:	cf11                	beqz	a4,80004526 <exec+0x322>
    8000450c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000450e:	02f00693          	li	a3,47
    80004512:	a039                	j	80004520 <exec+0x31c>
      last = s+1;
    80004514:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004518:	0785                	addi	a5,a5,1
    8000451a:	fff7c703          	lbu	a4,-1(a5)
    8000451e:	c701                	beqz	a4,80004526 <exec+0x322>
    if(*s == '/')
    80004520:	fed71ce3          	bne	a4,a3,80004518 <exec+0x314>
    80004524:	bfc5                	j	80004514 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004526:	4641                	li	a2,16
    80004528:	df843583          	ld	a1,-520(s0)
    8000452c:	158a8513          	addi	a0,s5,344
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	eb2080e7          	jalr	-334(ra) # 800003e2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004538:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000453c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004540:	e0843783          	ld	a5,-504(s0)
    80004544:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004548:	058ab783          	ld	a5,88(s5)
    8000454c:	e6843703          	ld	a4,-408(s0)
    80004550:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004552:	058ab783          	ld	a5,88(s5)
    80004556:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000455a:	85e6                	mv	a1,s9
    8000455c:	ffffd097          	auipc	ra,0xffffd
    80004560:	c76080e7          	jalr	-906(ra) # 800011d2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004564:	0004851b          	sext.w	a0,s1
    80004568:	bb15                	j	8000429c <exec+0x98>
    8000456a:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000456e:	e0843583          	ld	a1,-504(s0)
    80004572:	855a                	mv	a0,s6
    80004574:	ffffd097          	auipc	ra,0xffffd
    80004578:	c5e080e7          	jalr	-930(ra) # 800011d2 <proc_freepagetable>
  return -1;
    8000457c:	557d                	li	a0,-1
  if(ip){
    8000457e:	d00a0fe3          	beqz	s4,8000429c <exec+0x98>
    80004582:	b319                	j	80004288 <exec+0x84>
    80004584:	e1243423          	sd	s2,-504(s0)
    80004588:	b7dd                	j	8000456e <exec+0x36a>
    8000458a:	e1243423          	sd	s2,-504(s0)
    8000458e:	b7c5                	j	8000456e <exec+0x36a>
    80004590:	e1243423          	sd	s2,-504(s0)
    80004594:	bfe9                	j	8000456e <exec+0x36a>
    80004596:	e1243423          	sd	s2,-504(s0)
    8000459a:	bfd1                	j	8000456e <exec+0x36a>
  ip = 0;
    8000459c:	4a01                	li	s4,0
    8000459e:	bfc1                	j	8000456e <exec+0x36a>
    800045a0:	4a01                	li	s4,0
  if(pagetable)
    800045a2:	b7f1                	j	8000456e <exec+0x36a>
  sz = sz1;
    800045a4:	e0843983          	ld	s3,-504(s0)
    800045a8:	b569                	j	80004432 <exec+0x22e>

00000000800045aa <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045aa:	7179                	addi	sp,sp,-48
    800045ac:	f406                	sd	ra,40(sp)
    800045ae:	f022                	sd	s0,32(sp)
    800045b0:	ec26                	sd	s1,24(sp)
    800045b2:	e84a                	sd	s2,16(sp)
    800045b4:	1800                	addi	s0,sp,48
    800045b6:	892e                	mv	s2,a1
    800045b8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800045ba:	fdc40593          	addi	a1,s0,-36
    800045be:	ffffe097          	auipc	ra,0xffffe
    800045c2:	bf6080e7          	jalr	-1034(ra) # 800021b4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045c6:	fdc42703          	lw	a4,-36(s0)
    800045ca:	47bd                	li	a5,15
    800045cc:	02e7eb63          	bltu	a5,a4,80004602 <argfd+0x58>
    800045d0:	ffffd097          	auipc	ra,0xffffd
    800045d4:	aa2080e7          	jalr	-1374(ra) # 80001072 <myproc>
    800045d8:	fdc42703          	lw	a4,-36(s0)
    800045dc:	01a70793          	addi	a5,a4,26
    800045e0:	078e                	slli	a5,a5,0x3
    800045e2:	953e                	add	a0,a0,a5
    800045e4:	611c                	ld	a5,0(a0)
    800045e6:	c385                	beqz	a5,80004606 <argfd+0x5c>
    return -1;
  if(pfd)
    800045e8:	00090463          	beqz	s2,800045f0 <argfd+0x46>
    *pfd = fd;
    800045ec:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045f0:	4501                	li	a0,0
  if(pf)
    800045f2:	c091                	beqz	s1,800045f6 <argfd+0x4c>
    *pf = f;
    800045f4:	e09c                	sd	a5,0(s1)
}
    800045f6:	70a2                	ld	ra,40(sp)
    800045f8:	7402                	ld	s0,32(sp)
    800045fa:	64e2                	ld	s1,24(sp)
    800045fc:	6942                	ld	s2,16(sp)
    800045fe:	6145                	addi	sp,sp,48
    80004600:	8082                	ret
    return -1;
    80004602:	557d                	li	a0,-1
    80004604:	bfcd                	j	800045f6 <argfd+0x4c>
    80004606:	557d                	li	a0,-1
    80004608:	b7fd                	j	800045f6 <argfd+0x4c>

000000008000460a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000460a:	1101                	addi	sp,sp,-32
    8000460c:	ec06                	sd	ra,24(sp)
    8000460e:	e822                	sd	s0,16(sp)
    80004610:	e426                	sd	s1,8(sp)
    80004612:	1000                	addi	s0,sp,32
    80004614:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004616:	ffffd097          	auipc	ra,0xffffd
    8000461a:	a5c080e7          	jalr	-1444(ra) # 80001072 <myproc>
    8000461e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004620:	0d050793          	addi	a5,a0,208
    80004624:	4501                	li	a0,0
    80004626:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004628:	6398                	ld	a4,0(a5)
    8000462a:	cb19                	beqz	a4,80004640 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000462c:	2505                	addiw	a0,a0,1
    8000462e:	07a1                	addi	a5,a5,8
    80004630:	fed51ce3          	bne	a0,a3,80004628 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004634:	557d                	li	a0,-1
}
    80004636:	60e2                	ld	ra,24(sp)
    80004638:	6442                	ld	s0,16(sp)
    8000463a:	64a2                	ld	s1,8(sp)
    8000463c:	6105                	addi	sp,sp,32
    8000463e:	8082                	ret
      p->ofile[fd] = f;
    80004640:	01a50793          	addi	a5,a0,26
    80004644:	078e                	slli	a5,a5,0x3
    80004646:	963e                	add	a2,a2,a5
    80004648:	e204                	sd	s1,0(a2)
      return fd;
    8000464a:	b7f5                	j	80004636 <fdalloc+0x2c>

000000008000464c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000464c:	715d                	addi	sp,sp,-80
    8000464e:	e486                	sd	ra,72(sp)
    80004650:	e0a2                	sd	s0,64(sp)
    80004652:	fc26                	sd	s1,56(sp)
    80004654:	f84a                	sd	s2,48(sp)
    80004656:	f44e                	sd	s3,40(sp)
    80004658:	f052                	sd	s4,32(sp)
    8000465a:	ec56                	sd	s5,24(sp)
    8000465c:	e85a                	sd	s6,16(sp)
    8000465e:	0880                	addi	s0,sp,80
    80004660:	8b2e                	mv	s6,a1
    80004662:	89b2                	mv	s3,a2
    80004664:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004666:	fb040593          	addi	a1,s0,-80
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	e7e080e7          	jalr	-386(ra) # 800034e8 <nameiparent>
    80004672:	84aa                	mv	s1,a0
    80004674:	14050b63          	beqz	a0,800047ca <create+0x17e>
    return 0;

  ilock(dp);
    80004678:	ffffe097          	auipc	ra,0xffffe
    8000467c:	6ac080e7          	jalr	1708(ra) # 80002d24 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004680:	4601                	li	a2,0
    80004682:	fb040593          	addi	a1,s0,-80
    80004686:	8526                	mv	a0,s1
    80004688:	fffff097          	auipc	ra,0xfffff
    8000468c:	b80080e7          	jalr	-1152(ra) # 80003208 <dirlookup>
    80004690:	8aaa                	mv	s5,a0
    80004692:	c921                	beqz	a0,800046e2 <create+0x96>
    iunlockput(dp);
    80004694:	8526                	mv	a0,s1
    80004696:	fffff097          	auipc	ra,0xfffff
    8000469a:	8f0080e7          	jalr	-1808(ra) # 80002f86 <iunlockput>
    ilock(ip);
    8000469e:	8556                	mv	a0,s5
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	684080e7          	jalr	1668(ra) # 80002d24 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046a8:	4789                	li	a5,2
    800046aa:	02fb1563          	bne	s6,a5,800046d4 <create+0x88>
    800046ae:	044ad783          	lhu	a5,68(s5)
    800046b2:	37f9                	addiw	a5,a5,-2
    800046b4:	17c2                	slli	a5,a5,0x30
    800046b6:	93c1                	srli	a5,a5,0x30
    800046b8:	4705                	li	a4,1
    800046ba:	00f76d63          	bltu	a4,a5,800046d4 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800046be:	8556                	mv	a0,s5
    800046c0:	60a6                	ld	ra,72(sp)
    800046c2:	6406                	ld	s0,64(sp)
    800046c4:	74e2                	ld	s1,56(sp)
    800046c6:	7942                	ld	s2,48(sp)
    800046c8:	79a2                	ld	s3,40(sp)
    800046ca:	7a02                	ld	s4,32(sp)
    800046cc:	6ae2                	ld	s5,24(sp)
    800046ce:	6b42                	ld	s6,16(sp)
    800046d0:	6161                	addi	sp,sp,80
    800046d2:	8082                	ret
    iunlockput(ip);
    800046d4:	8556                	mv	a0,s5
    800046d6:	fffff097          	auipc	ra,0xfffff
    800046da:	8b0080e7          	jalr	-1872(ra) # 80002f86 <iunlockput>
    return 0;
    800046de:	4a81                	li	s5,0
    800046e0:	bff9                	j	800046be <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800046e2:	85da                	mv	a1,s6
    800046e4:	4088                	lw	a0,0(s1)
    800046e6:	ffffe097          	auipc	ra,0xffffe
    800046ea:	4a6080e7          	jalr	1190(ra) # 80002b8c <ialloc>
    800046ee:	8a2a                	mv	s4,a0
    800046f0:	c529                	beqz	a0,8000473a <create+0xee>
  ilock(ip);
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	632080e7          	jalr	1586(ra) # 80002d24 <ilock>
  ip->major = major;
    800046fa:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800046fe:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004702:	4905                	li	s2,1
    80004704:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004708:	8552                	mv	a0,s4
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	54e080e7          	jalr	1358(ra) # 80002c58 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004712:	032b0b63          	beq	s6,s2,80004748 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004716:	004a2603          	lw	a2,4(s4)
    8000471a:	fb040593          	addi	a1,s0,-80
    8000471e:	8526                	mv	a0,s1
    80004720:	fffff097          	auipc	ra,0xfffff
    80004724:	cf8080e7          	jalr	-776(ra) # 80003418 <dirlink>
    80004728:	06054f63          	bltz	a0,800047a6 <create+0x15a>
  iunlockput(dp);
    8000472c:	8526                	mv	a0,s1
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	858080e7          	jalr	-1960(ra) # 80002f86 <iunlockput>
  return ip;
    80004736:	8ad2                	mv	s5,s4
    80004738:	b759                	j	800046be <create+0x72>
    iunlockput(dp);
    8000473a:	8526                	mv	a0,s1
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	84a080e7          	jalr	-1974(ra) # 80002f86 <iunlockput>
    return 0;
    80004744:	8ad2                	mv	s5,s4
    80004746:	bfa5                	j	800046be <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004748:	004a2603          	lw	a2,4(s4)
    8000474c:	00004597          	auipc	a1,0x4
    80004750:	f9458593          	addi	a1,a1,-108 # 800086e0 <syscalls+0x2a0>
    80004754:	8552                	mv	a0,s4
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	cc2080e7          	jalr	-830(ra) # 80003418 <dirlink>
    8000475e:	04054463          	bltz	a0,800047a6 <create+0x15a>
    80004762:	40d0                	lw	a2,4(s1)
    80004764:	00004597          	auipc	a1,0x4
    80004768:	f8458593          	addi	a1,a1,-124 # 800086e8 <syscalls+0x2a8>
    8000476c:	8552                	mv	a0,s4
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	caa080e7          	jalr	-854(ra) # 80003418 <dirlink>
    80004776:	02054863          	bltz	a0,800047a6 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    8000477a:	004a2603          	lw	a2,4(s4)
    8000477e:	fb040593          	addi	a1,s0,-80
    80004782:	8526                	mv	a0,s1
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	c94080e7          	jalr	-876(ra) # 80003418 <dirlink>
    8000478c:	00054d63          	bltz	a0,800047a6 <create+0x15a>
    dp->nlink++;  // for ".."
    80004790:	04a4d783          	lhu	a5,74(s1)
    80004794:	2785                	addiw	a5,a5,1
    80004796:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000479a:	8526                	mv	a0,s1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	4bc080e7          	jalr	1212(ra) # 80002c58 <iupdate>
    800047a4:	b761                	j	8000472c <create+0xe0>
  ip->nlink = 0;
    800047a6:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800047aa:	8552                	mv	a0,s4
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	4ac080e7          	jalr	1196(ra) # 80002c58 <iupdate>
  iunlockput(ip);
    800047b4:	8552                	mv	a0,s4
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	7d0080e7          	jalr	2000(ra) # 80002f86 <iunlockput>
  iunlockput(dp);
    800047be:	8526                	mv	a0,s1
    800047c0:	ffffe097          	auipc	ra,0xffffe
    800047c4:	7c6080e7          	jalr	1990(ra) # 80002f86 <iunlockput>
  return 0;
    800047c8:	bddd                	j	800046be <create+0x72>
    return 0;
    800047ca:	8aaa                	mv	s5,a0
    800047cc:	bdcd                	j	800046be <create+0x72>

00000000800047ce <sys_dup>:
{
    800047ce:	7179                	addi	sp,sp,-48
    800047d0:	f406                	sd	ra,40(sp)
    800047d2:	f022                	sd	s0,32(sp)
    800047d4:	ec26                	sd	s1,24(sp)
    800047d6:	e84a                	sd	s2,16(sp)
    800047d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047da:	fd840613          	addi	a2,s0,-40
    800047de:	4581                	li	a1,0
    800047e0:	4501                	li	a0,0
    800047e2:	00000097          	auipc	ra,0x0
    800047e6:	dc8080e7          	jalr	-568(ra) # 800045aa <argfd>
    return -1;
    800047ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047ec:	02054363          	bltz	a0,80004812 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800047f0:	fd843903          	ld	s2,-40(s0)
    800047f4:	854a                	mv	a0,s2
    800047f6:	00000097          	auipc	ra,0x0
    800047fa:	e14080e7          	jalr	-492(ra) # 8000460a <fdalloc>
    800047fe:	84aa                	mv	s1,a0
    return -1;
    80004800:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004802:	00054863          	bltz	a0,80004812 <sys_dup+0x44>
  filedup(f);
    80004806:	854a                	mv	a0,s2
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	334080e7          	jalr	820(ra) # 80003b3c <filedup>
  return fd;
    80004810:	87a6                	mv	a5,s1
}
    80004812:	853e                	mv	a0,a5
    80004814:	70a2                	ld	ra,40(sp)
    80004816:	7402                	ld	s0,32(sp)
    80004818:	64e2                	ld	s1,24(sp)
    8000481a:	6942                	ld	s2,16(sp)
    8000481c:	6145                	addi	sp,sp,48
    8000481e:	8082                	ret

0000000080004820 <sys_read>:
{
    80004820:	7179                	addi	sp,sp,-48
    80004822:	f406                	sd	ra,40(sp)
    80004824:	f022                	sd	s0,32(sp)
    80004826:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004828:	fd840593          	addi	a1,s0,-40
    8000482c:	4505                	li	a0,1
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	9a6080e7          	jalr	-1626(ra) # 800021d4 <argaddr>
  argint(2, &n);
    80004836:	fe440593          	addi	a1,s0,-28
    8000483a:	4509                	li	a0,2
    8000483c:	ffffe097          	auipc	ra,0xffffe
    80004840:	978080e7          	jalr	-1672(ra) # 800021b4 <argint>
  if(argfd(0, 0, &f) < 0)
    80004844:	fe840613          	addi	a2,s0,-24
    80004848:	4581                	li	a1,0
    8000484a:	4501                	li	a0,0
    8000484c:	00000097          	auipc	ra,0x0
    80004850:	d5e080e7          	jalr	-674(ra) # 800045aa <argfd>
    80004854:	87aa                	mv	a5,a0
    return -1;
    80004856:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004858:	0007cc63          	bltz	a5,80004870 <sys_read+0x50>
  return fileread(f, p, n);
    8000485c:	fe442603          	lw	a2,-28(s0)
    80004860:	fd843583          	ld	a1,-40(s0)
    80004864:	fe843503          	ld	a0,-24(s0)
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	460080e7          	jalr	1120(ra) # 80003cc8 <fileread>
}
    80004870:	70a2                	ld	ra,40(sp)
    80004872:	7402                	ld	s0,32(sp)
    80004874:	6145                	addi	sp,sp,48
    80004876:	8082                	ret

0000000080004878 <sys_write>:
{
    80004878:	7179                	addi	sp,sp,-48
    8000487a:	f406                	sd	ra,40(sp)
    8000487c:	f022                	sd	s0,32(sp)
    8000487e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004880:	fd840593          	addi	a1,s0,-40
    80004884:	4505                	li	a0,1
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	94e080e7          	jalr	-1714(ra) # 800021d4 <argaddr>
  argint(2, &n);
    8000488e:	fe440593          	addi	a1,s0,-28
    80004892:	4509                	li	a0,2
    80004894:	ffffe097          	auipc	ra,0xffffe
    80004898:	920080e7          	jalr	-1760(ra) # 800021b4 <argint>
  if(argfd(0, 0, &f) < 0)
    8000489c:	fe840613          	addi	a2,s0,-24
    800048a0:	4581                	li	a1,0
    800048a2:	4501                	li	a0,0
    800048a4:	00000097          	auipc	ra,0x0
    800048a8:	d06080e7          	jalr	-762(ra) # 800045aa <argfd>
    800048ac:	87aa                	mv	a5,a0
    return -1;
    800048ae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048b0:	0007cc63          	bltz	a5,800048c8 <sys_write+0x50>
  return filewrite(f, p, n);
    800048b4:	fe442603          	lw	a2,-28(s0)
    800048b8:	fd843583          	ld	a1,-40(s0)
    800048bc:	fe843503          	ld	a0,-24(s0)
    800048c0:	fffff097          	auipc	ra,0xfffff
    800048c4:	4ca080e7          	jalr	1226(ra) # 80003d8a <filewrite>
}
    800048c8:	70a2                	ld	ra,40(sp)
    800048ca:	7402                	ld	s0,32(sp)
    800048cc:	6145                	addi	sp,sp,48
    800048ce:	8082                	ret

00000000800048d0 <sys_close>:
{
    800048d0:	1101                	addi	sp,sp,-32
    800048d2:	ec06                	sd	ra,24(sp)
    800048d4:	e822                	sd	s0,16(sp)
    800048d6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048d8:	fe040613          	addi	a2,s0,-32
    800048dc:	fec40593          	addi	a1,s0,-20
    800048e0:	4501                	li	a0,0
    800048e2:	00000097          	auipc	ra,0x0
    800048e6:	cc8080e7          	jalr	-824(ra) # 800045aa <argfd>
    return -1;
    800048ea:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048ec:	02054463          	bltz	a0,80004914 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048f0:	ffffc097          	auipc	ra,0xffffc
    800048f4:	782080e7          	jalr	1922(ra) # 80001072 <myproc>
    800048f8:	fec42783          	lw	a5,-20(s0)
    800048fc:	07e9                	addi	a5,a5,26
    800048fe:	078e                	slli	a5,a5,0x3
    80004900:	953e                	add	a0,a0,a5
    80004902:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004906:	fe043503          	ld	a0,-32(s0)
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	284080e7          	jalr	644(ra) # 80003b8e <fileclose>
  return 0;
    80004912:	4781                	li	a5,0
}
    80004914:	853e                	mv	a0,a5
    80004916:	60e2                	ld	ra,24(sp)
    80004918:	6442                	ld	s0,16(sp)
    8000491a:	6105                	addi	sp,sp,32
    8000491c:	8082                	ret

000000008000491e <sys_fstat>:
{
    8000491e:	1101                	addi	sp,sp,-32
    80004920:	ec06                	sd	ra,24(sp)
    80004922:	e822                	sd	s0,16(sp)
    80004924:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004926:	fe040593          	addi	a1,s0,-32
    8000492a:	4505                	li	a0,1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	8a8080e7          	jalr	-1880(ra) # 800021d4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004934:	fe840613          	addi	a2,s0,-24
    80004938:	4581                	li	a1,0
    8000493a:	4501                	li	a0,0
    8000493c:	00000097          	auipc	ra,0x0
    80004940:	c6e080e7          	jalr	-914(ra) # 800045aa <argfd>
    80004944:	87aa                	mv	a5,a0
    return -1;
    80004946:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004948:	0007ca63          	bltz	a5,8000495c <sys_fstat+0x3e>
  return filestat(f, st);
    8000494c:	fe043583          	ld	a1,-32(s0)
    80004950:	fe843503          	ld	a0,-24(s0)
    80004954:	fffff097          	auipc	ra,0xfffff
    80004958:	302080e7          	jalr	770(ra) # 80003c56 <filestat>
}
    8000495c:	60e2                	ld	ra,24(sp)
    8000495e:	6442                	ld	s0,16(sp)
    80004960:	6105                	addi	sp,sp,32
    80004962:	8082                	ret

0000000080004964 <sys_link>:
{
    80004964:	7169                	addi	sp,sp,-304
    80004966:	f606                	sd	ra,296(sp)
    80004968:	f222                	sd	s0,288(sp)
    8000496a:	ee26                	sd	s1,280(sp)
    8000496c:	ea4a                	sd	s2,272(sp)
    8000496e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004970:	08000613          	li	a2,128
    80004974:	ed040593          	addi	a1,s0,-304
    80004978:	4501                	li	a0,0
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	87a080e7          	jalr	-1926(ra) # 800021f4 <argstr>
    return -1;
    80004982:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004984:	10054e63          	bltz	a0,80004aa0 <sys_link+0x13c>
    80004988:	08000613          	li	a2,128
    8000498c:	f5040593          	addi	a1,s0,-176
    80004990:	4505                	li	a0,1
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	862080e7          	jalr	-1950(ra) # 800021f4 <argstr>
    return -1;
    8000499a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499c:	10054263          	bltz	a0,80004aa0 <sys_link+0x13c>
  begin_op();
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	d2a080e7          	jalr	-726(ra) # 800036ca <begin_op>
  if((ip = namei(old)) == 0){
    800049a8:	ed040513          	addi	a0,s0,-304
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	b1e080e7          	jalr	-1250(ra) # 800034ca <namei>
    800049b4:	84aa                	mv	s1,a0
    800049b6:	c551                	beqz	a0,80004a42 <sys_link+0xde>
  ilock(ip);
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	36c080e7          	jalr	876(ra) # 80002d24 <ilock>
  if(ip->type == T_DIR){
    800049c0:	04449703          	lh	a4,68(s1)
    800049c4:	4785                	li	a5,1
    800049c6:	08f70463          	beq	a4,a5,80004a4e <sys_link+0xea>
  ip->nlink++;
    800049ca:	04a4d783          	lhu	a5,74(s1)
    800049ce:	2785                	addiw	a5,a5,1
    800049d0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	282080e7          	jalr	642(ra) # 80002c58 <iupdate>
  iunlock(ip);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	406080e7          	jalr	1030(ra) # 80002de6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049e8:	fd040593          	addi	a1,s0,-48
    800049ec:	f5040513          	addi	a0,s0,-176
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	af8080e7          	jalr	-1288(ra) # 800034e8 <nameiparent>
    800049f8:	892a                	mv	s2,a0
    800049fa:	c935                	beqz	a0,80004a6e <sys_link+0x10a>
  ilock(dp);
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	328080e7          	jalr	808(ra) # 80002d24 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a04:	00092703          	lw	a4,0(s2)
    80004a08:	409c                	lw	a5,0(s1)
    80004a0a:	04f71d63          	bne	a4,a5,80004a64 <sys_link+0x100>
    80004a0e:	40d0                	lw	a2,4(s1)
    80004a10:	fd040593          	addi	a1,s0,-48
    80004a14:	854a                	mv	a0,s2
    80004a16:	fffff097          	auipc	ra,0xfffff
    80004a1a:	a02080e7          	jalr	-1534(ra) # 80003418 <dirlink>
    80004a1e:	04054363          	bltz	a0,80004a64 <sys_link+0x100>
  iunlockput(dp);
    80004a22:	854a                	mv	a0,s2
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	562080e7          	jalr	1378(ra) # 80002f86 <iunlockput>
  iput(ip);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	4b0080e7          	jalr	1200(ra) # 80002ede <iput>
  end_op();
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	d0e080e7          	jalr	-754(ra) # 80003744 <end_op>
  return 0;
    80004a3e:	4781                	li	a5,0
    80004a40:	a085                	j	80004aa0 <sys_link+0x13c>
    end_op();
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	d02080e7          	jalr	-766(ra) # 80003744 <end_op>
    return -1;
    80004a4a:	57fd                	li	a5,-1
    80004a4c:	a891                	j	80004aa0 <sys_link+0x13c>
    iunlockput(ip);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	536080e7          	jalr	1334(ra) # 80002f86 <iunlockput>
    end_op();
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	cec080e7          	jalr	-788(ra) # 80003744 <end_op>
    return -1;
    80004a60:	57fd                	li	a5,-1
    80004a62:	a83d                	j	80004aa0 <sys_link+0x13c>
    iunlockput(dp);
    80004a64:	854a                	mv	a0,s2
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	520080e7          	jalr	1312(ra) # 80002f86 <iunlockput>
  ilock(ip);
    80004a6e:	8526                	mv	a0,s1
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	2b4080e7          	jalr	692(ra) # 80002d24 <ilock>
  ip->nlink--;
    80004a78:	04a4d783          	lhu	a5,74(s1)
    80004a7c:	37fd                	addiw	a5,a5,-1
    80004a7e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a82:	8526                	mv	a0,s1
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	1d4080e7          	jalr	468(ra) # 80002c58 <iupdate>
  iunlockput(ip);
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	4f8080e7          	jalr	1272(ra) # 80002f86 <iunlockput>
  end_op();
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	cae080e7          	jalr	-850(ra) # 80003744 <end_op>
  return -1;
    80004a9e:	57fd                	li	a5,-1
}
    80004aa0:	853e                	mv	a0,a5
    80004aa2:	70b2                	ld	ra,296(sp)
    80004aa4:	7412                	ld	s0,288(sp)
    80004aa6:	64f2                	ld	s1,280(sp)
    80004aa8:	6952                	ld	s2,272(sp)
    80004aaa:	6155                	addi	sp,sp,304
    80004aac:	8082                	ret

0000000080004aae <sys_unlink>:
{
    80004aae:	7151                	addi	sp,sp,-240
    80004ab0:	f586                	sd	ra,232(sp)
    80004ab2:	f1a2                	sd	s0,224(sp)
    80004ab4:	eda6                	sd	s1,216(sp)
    80004ab6:	e9ca                	sd	s2,208(sp)
    80004ab8:	e5ce                	sd	s3,200(sp)
    80004aba:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004abc:	08000613          	li	a2,128
    80004ac0:	f3040593          	addi	a1,s0,-208
    80004ac4:	4501                	li	a0,0
    80004ac6:	ffffd097          	auipc	ra,0xffffd
    80004aca:	72e080e7          	jalr	1838(ra) # 800021f4 <argstr>
    80004ace:	18054163          	bltz	a0,80004c50 <sys_unlink+0x1a2>
  begin_op();
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	bf8080e7          	jalr	-1032(ra) # 800036ca <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ada:	fb040593          	addi	a1,s0,-80
    80004ade:	f3040513          	addi	a0,s0,-208
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	a06080e7          	jalr	-1530(ra) # 800034e8 <nameiparent>
    80004aea:	84aa                	mv	s1,a0
    80004aec:	c979                	beqz	a0,80004bc2 <sys_unlink+0x114>
  ilock(dp);
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	236080e7          	jalr	566(ra) # 80002d24 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004af6:	00004597          	auipc	a1,0x4
    80004afa:	bea58593          	addi	a1,a1,-1046 # 800086e0 <syscalls+0x2a0>
    80004afe:	fb040513          	addi	a0,s0,-80
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	6ec080e7          	jalr	1772(ra) # 800031ee <namecmp>
    80004b0a:	14050a63          	beqz	a0,80004c5e <sys_unlink+0x1b0>
    80004b0e:	00004597          	auipc	a1,0x4
    80004b12:	bda58593          	addi	a1,a1,-1062 # 800086e8 <syscalls+0x2a8>
    80004b16:	fb040513          	addi	a0,s0,-80
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	6d4080e7          	jalr	1748(ra) # 800031ee <namecmp>
    80004b22:	12050e63          	beqz	a0,80004c5e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b26:	f2c40613          	addi	a2,s0,-212
    80004b2a:	fb040593          	addi	a1,s0,-80
    80004b2e:	8526                	mv	a0,s1
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	6d8080e7          	jalr	1752(ra) # 80003208 <dirlookup>
    80004b38:	892a                	mv	s2,a0
    80004b3a:	12050263          	beqz	a0,80004c5e <sys_unlink+0x1b0>
  ilock(ip);
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	1e6080e7          	jalr	486(ra) # 80002d24 <ilock>
  if(ip->nlink < 1)
    80004b46:	04a91783          	lh	a5,74(s2)
    80004b4a:	08f05263          	blez	a5,80004bce <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b4e:	04491703          	lh	a4,68(s2)
    80004b52:	4785                	li	a5,1
    80004b54:	08f70563          	beq	a4,a5,80004bde <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b58:	4641                	li	a2,16
    80004b5a:	4581                	li	a1,0
    80004b5c:	fc040513          	addi	a0,s0,-64
    80004b60:	ffffb097          	auipc	ra,0xffffb
    80004b64:	73a080e7          	jalr	1850(ra) # 8000029a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b68:	4741                	li	a4,16
    80004b6a:	f2c42683          	lw	a3,-212(s0)
    80004b6e:	fc040613          	addi	a2,s0,-64
    80004b72:	4581                	li	a1,0
    80004b74:	8526                	mv	a0,s1
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	55a080e7          	jalr	1370(ra) # 800030d0 <writei>
    80004b7e:	47c1                	li	a5,16
    80004b80:	0af51563          	bne	a0,a5,80004c2a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b84:	04491703          	lh	a4,68(s2)
    80004b88:	4785                	li	a5,1
    80004b8a:	0af70863          	beq	a4,a5,80004c3a <sys_unlink+0x18c>
  iunlockput(dp);
    80004b8e:	8526                	mv	a0,s1
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	3f6080e7          	jalr	1014(ra) # 80002f86 <iunlockput>
  ip->nlink--;
    80004b98:	04a95783          	lhu	a5,74(s2)
    80004b9c:	37fd                	addiw	a5,a5,-1
    80004b9e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ba2:	854a                	mv	a0,s2
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	0b4080e7          	jalr	180(ra) # 80002c58 <iupdate>
  iunlockput(ip);
    80004bac:	854a                	mv	a0,s2
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	3d8080e7          	jalr	984(ra) # 80002f86 <iunlockput>
  end_op();
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	b8e080e7          	jalr	-1138(ra) # 80003744 <end_op>
  return 0;
    80004bbe:	4501                	li	a0,0
    80004bc0:	a84d                	j	80004c72 <sys_unlink+0x1c4>
    end_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	b82080e7          	jalr	-1150(ra) # 80003744 <end_op>
    return -1;
    80004bca:	557d                	li	a0,-1
    80004bcc:	a05d                	j	80004c72 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bce:	00004517          	auipc	a0,0x4
    80004bd2:	b2250513          	addi	a0,a0,-1246 # 800086f0 <syscalls+0x2b0>
    80004bd6:	00001097          	auipc	ra,0x1
    80004bda:	1a0080e7          	jalr	416(ra) # 80005d76 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bde:	04c92703          	lw	a4,76(s2)
    80004be2:	02000793          	li	a5,32
    80004be6:	f6e7f9e3          	bgeu	a5,a4,80004b58 <sys_unlink+0xaa>
    80004bea:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bee:	4741                	li	a4,16
    80004bf0:	86ce                	mv	a3,s3
    80004bf2:	f1840613          	addi	a2,s0,-232
    80004bf6:	4581                	li	a1,0
    80004bf8:	854a                	mv	a0,s2
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	3de080e7          	jalr	990(ra) # 80002fd8 <readi>
    80004c02:	47c1                	li	a5,16
    80004c04:	00f51b63          	bne	a0,a5,80004c1a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c08:	f1845783          	lhu	a5,-232(s0)
    80004c0c:	e7a1                	bnez	a5,80004c54 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c0e:	29c1                	addiw	s3,s3,16
    80004c10:	04c92783          	lw	a5,76(s2)
    80004c14:	fcf9ede3          	bltu	s3,a5,80004bee <sys_unlink+0x140>
    80004c18:	b781                	j	80004b58 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c1a:	00004517          	auipc	a0,0x4
    80004c1e:	aee50513          	addi	a0,a0,-1298 # 80008708 <syscalls+0x2c8>
    80004c22:	00001097          	auipc	ra,0x1
    80004c26:	154080e7          	jalr	340(ra) # 80005d76 <panic>
    panic("unlink: writei");
    80004c2a:	00004517          	auipc	a0,0x4
    80004c2e:	af650513          	addi	a0,a0,-1290 # 80008720 <syscalls+0x2e0>
    80004c32:	00001097          	auipc	ra,0x1
    80004c36:	144080e7          	jalr	324(ra) # 80005d76 <panic>
    dp->nlink--;
    80004c3a:	04a4d783          	lhu	a5,74(s1)
    80004c3e:	37fd                	addiw	a5,a5,-1
    80004c40:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c44:	8526                	mv	a0,s1
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	012080e7          	jalr	18(ra) # 80002c58 <iupdate>
    80004c4e:	b781                	j	80004b8e <sys_unlink+0xe0>
    return -1;
    80004c50:	557d                	li	a0,-1
    80004c52:	a005                	j	80004c72 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c54:	854a                	mv	a0,s2
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	330080e7          	jalr	816(ra) # 80002f86 <iunlockput>
  iunlockput(dp);
    80004c5e:	8526                	mv	a0,s1
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	326080e7          	jalr	806(ra) # 80002f86 <iunlockput>
  end_op();
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	adc080e7          	jalr	-1316(ra) # 80003744 <end_op>
  return -1;
    80004c70:	557d                	li	a0,-1
}
    80004c72:	70ae                	ld	ra,232(sp)
    80004c74:	740e                	ld	s0,224(sp)
    80004c76:	64ee                	ld	s1,216(sp)
    80004c78:	694e                	ld	s2,208(sp)
    80004c7a:	69ae                	ld	s3,200(sp)
    80004c7c:	616d                	addi	sp,sp,240
    80004c7e:	8082                	ret

0000000080004c80 <sys_open>:

uint64
sys_open(void)
{
    80004c80:	7131                	addi	sp,sp,-192
    80004c82:	fd06                	sd	ra,184(sp)
    80004c84:	f922                	sd	s0,176(sp)
    80004c86:	f526                	sd	s1,168(sp)
    80004c88:	f14a                	sd	s2,160(sp)
    80004c8a:	ed4e                	sd	s3,152(sp)
    80004c8c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c8e:	f4c40593          	addi	a1,s0,-180
    80004c92:	4505                	li	a0,1
    80004c94:	ffffd097          	auipc	ra,0xffffd
    80004c98:	520080e7          	jalr	1312(ra) # 800021b4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c9c:	08000613          	li	a2,128
    80004ca0:	f5040593          	addi	a1,s0,-176
    80004ca4:	4501                	li	a0,0
    80004ca6:	ffffd097          	auipc	ra,0xffffd
    80004caa:	54e080e7          	jalr	1358(ra) # 800021f4 <argstr>
    80004cae:	87aa                	mv	a5,a0
    return -1;
    80004cb0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cb2:	0a07c863          	bltz	a5,80004d62 <sys_open+0xe2>

  begin_op();
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	a14080e7          	jalr	-1516(ra) # 800036ca <begin_op>

  if(omode & O_CREATE){
    80004cbe:	f4c42783          	lw	a5,-180(s0)
    80004cc2:	2007f793          	andi	a5,a5,512
    80004cc6:	cbdd                	beqz	a5,80004d7c <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004cc8:	4681                	li	a3,0
    80004cca:	4601                	li	a2,0
    80004ccc:	4589                	li	a1,2
    80004cce:	f5040513          	addi	a0,s0,-176
    80004cd2:	00000097          	auipc	ra,0x0
    80004cd6:	97a080e7          	jalr	-1670(ra) # 8000464c <create>
    80004cda:	84aa                	mv	s1,a0
    if(ip == 0){
    80004cdc:	c951                	beqz	a0,80004d70 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cde:	04449703          	lh	a4,68(s1)
    80004ce2:	478d                	li	a5,3
    80004ce4:	00f71763          	bne	a4,a5,80004cf2 <sys_open+0x72>
    80004ce8:	0464d703          	lhu	a4,70(s1)
    80004cec:	47a5                	li	a5,9
    80004cee:	0ce7ec63          	bltu	a5,a4,80004dc6 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cf2:	fffff097          	auipc	ra,0xfffff
    80004cf6:	de0080e7          	jalr	-544(ra) # 80003ad2 <filealloc>
    80004cfa:	892a                	mv	s2,a0
    80004cfc:	c56d                	beqz	a0,80004de6 <sys_open+0x166>
    80004cfe:	00000097          	auipc	ra,0x0
    80004d02:	90c080e7          	jalr	-1780(ra) # 8000460a <fdalloc>
    80004d06:	89aa                	mv	s3,a0
    80004d08:	0c054a63          	bltz	a0,80004ddc <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d0c:	04449703          	lh	a4,68(s1)
    80004d10:	478d                	li	a5,3
    80004d12:	0ef70563          	beq	a4,a5,80004dfc <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d16:	4789                	li	a5,2
    80004d18:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004d1c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004d20:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004d24:	f4c42783          	lw	a5,-180(s0)
    80004d28:	0017c713          	xori	a4,a5,1
    80004d2c:	8b05                	andi	a4,a4,1
    80004d2e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d32:	0037f713          	andi	a4,a5,3
    80004d36:	00e03733          	snez	a4,a4
    80004d3a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d3e:	4007f793          	andi	a5,a5,1024
    80004d42:	c791                	beqz	a5,80004d4e <sys_open+0xce>
    80004d44:	04449703          	lh	a4,68(s1)
    80004d48:	4789                	li	a5,2
    80004d4a:	0cf70063          	beq	a4,a5,80004e0a <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004d4e:	8526                	mv	a0,s1
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	096080e7          	jalr	150(ra) # 80002de6 <iunlock>
  end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	9ec080e7          	jalr	-1556(ra) # 80003744 <end_op>

  return fd;
    80004d60:	854e                	mv	a0,s3
}
    80004d62:	70ea                	ld	ra,184(sp)
    80004d64:	744a                	ld	s0,176(sp)
    80004d66:	74aa                	ld	s1,168(sp)
    80004d68:	790a                	ld	s2,160(sp)
    80004d6a:	69ea                	ld	s3,152(sp)
    80004d6c:	6129                	addi	sp,sp,192
    80004d6e:	8082                	ret
      end_op();
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	9d4080e7          	jalr	-1580(ra) # 80003744 <end_op>
      return -1;
    80004d78:	557d                	li	a0,-1
    80004d7a:	b7e5                	j	80004d62 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004d7c:	f5040513          	addi	a0,s0,-176
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	74a080e7          	jalr	1866(ra) # 800034ca <namei>
    80004d88:	84aa                	mv	s1,a0
    80004d8a:	c905                	beqz	a0,80004dba <sys_open+0x13a>
    ilock(ip);
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	f98080e7          	jalr	-104(ra) # 80002d24 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d94:	04449703          	lh	a4,68(s1)
    80004d98:	4785                	li	a5,1
    80004d9a:	f4f712e3          	bne	a4,a5,80004cde <sys_open+0x5e>
    80004d9e:	f4c42783          	lw	a5,-180(s0)
    80004da2:	dba1                	beqz	a5,80004cf2 <sys_open+0x72>
      iunlockput(ip);
    80004da4:	8526                	mv	a0,s1
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	1e0080e7          	jalr	480(ra) # 80002f86 <iunlockput>
      end_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	996080e7          	jalr	-1642(ra) # 80003744 <end_op>
      return -1;
    80004db6:	557d                	li	a0,-1
    80004db8:	b76d                	j	80004d62 <sys_open+0xe2>
      end_op();
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	98a080e7          	jalr	-1654(ra) # 80003744 <end_op>
      return -1;
    80004dc2:	557d                	li	a0,-1
    80004dc4:	bf79                	j	80004d62 <sys_open+0xe2>
    iunlockput(ip);
    80004dc6:	8526                	mv	a0,s1
    80004dc8:	ffffe097          	auipc	ra,0xffffe
    80004dcc:	1be080e7          	jalr	446(ra) # 80002f86 <iunlockput>
    end_op();
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	974080e7          	jalr	-1676(ra) # 80003744 <end_op>
    return -1;
    80004dd8:	557d                	li	a0,-1
    80004dda:	b761                	j	80004d62 <sys_open+0xe2>
      fileclose(f);
    80004ddc:	854a                	mv	a0,s2
    80004dde:	fffff097          	auipc	ra,0xfffff
    80004de2:	db0080e7          	jalr	-592(ra) # 80003b8e <fileclose>
    iunlockput(ip);
    80004de6:	8526                	mv	a0,s1
    80004de8:	ffffe097          	auipc	ra,0xffffe
    80004dec:	19e080e7          	jalr	414(ra) # 80002f86 <iunlockput>
    end_op();
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	954080e7          	jalr	-1708(ra) # 80003744 <end_op>
    return -1;
    80004df8:	557d                	li	a0,-1
    80004dfa:	b7a5                	j	80004d62 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004dfc:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004e00:	04649783          	lh	a5,70(s1)
    80004e04:	02f91223          	sh	a5,36(s2)
    80004e08:	bf21                	j	80004d20 <sys_open+0xa0>
    itrunc(ip);
    80004e0a:	8526                	mv	a0,s1
    80004e0c:	ffffe097          	auipc	ra,0xffffe
    80004e10:	026080e7          	jalr	38(ra) # 80002e32 <itrunc>
    80004e14:	bf2d                	j	80004d4e <sys_open+0xce>

0000000080004e16 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e16:	7175                	addi	sp,sp,-144
    80004e18:	e506                	sd	ra,136(sp)
    80004e1a:	e122                	sd	s0,128(sp)
    80004e1c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	8ac080e7          	jalr	-1876(ra) # 800036ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e26:	08000613          	li	a2,128
    80004e2a:	f7040593          	addi	a1,s0,-144
    80004e2e:	4501                	li	a0,0
    80004e30:	ffffd097          	auipc	ra,0xffffd
    80004e34:	3c4080e7          	jalr	964(ra) # 800021f4 <argstr>
    80004e38:	02054963          	bltz	a0,80004e6a <sys_mkdir+0x54>
    80004e3c:	4681                	li	a3,0
    80004e3e:	4601                	li	a2,0
    80004e40:	4585                	li	a1,1
    80004e42:	f7040513          	addi	a0,s0,-144
    80004e46:	00000097          	auipc	ra,0x0
    80004e4a:	806080e7          	jalr	-2042(ra) # 8000464c <create>
    80004e4e:	cd11                	beqz	a0,80004e6a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	136080e7          	jalr	310(ra) # 80002f86 <iunlockput>
  end_op();
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	8ec080e7          	jalr	-1812(ra) # 80003744 <end_op>
  return 0;
    80004e60:	4501                	li	a0,0
}
    80004e62:	60aa                	ld	ra,136(sp)
    80004e64:	640a                	ld	s0,128(sp)
    80004e66:	6149                	addi	sp,sp,144
    80004e68:	8082                	ret
    end_op();
    80004e6a:	fffff097          	auipc	ra,0xfffff
    80004e6e:	8da080e7          	jalr	-1830(ra) # 80003744 <end_op>
    return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	b7fd                	j	80004e62 <sys_mkdir+0x4c>

0000000080004e76 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e76:	7135                	addi	sp,sp,-160
    80004e78:	ed06                	sd	ra,152(sp)
    80004e7a:	e922                	sd	s0,144(sp)
    80004e7c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	84c080e7          	jalr	-1972(ra) # 800036ca <begin_op>
  argint(1, &major);
    80004e86:	f6c40593          	addi	a1,s0,-148
    80004e8a:	4505                	li	a0,1
    80004e8c:	ffffd097          	auipc	ra,0xffffd
    80004e90:	328080e7          	jalr	808(ra) # 800021b4 <argint>
  argint(2, &minor);
    80004e94:	f6840593          	addi	a1,s0,-152
    80004e98:	4509                	li	a0,2
    80004e9a:	ffffd097          	auipc	ra,0xffffd
    80004e9e:	31a080e7          	jalr	794(ra) # 800021b4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ea2:	08000613          	li	a2,128
    80004ea6:	f7040593          	addi	a1,s0,-144
    80004eaa:	4501                	li	a0,0
    80004eac:	ffffd097          	auipc	ra,0xffffd
    80004eb0:	348080e7          	jalr	840(ra) # 800021f4 <argstr>
    80004eb4:	02054b63          	bltz	a0,80004eea <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004eb8:	f6841683          	lh	a3,-152(s0)
    80004ebc:	f6c41603          	lh	a2,-148(s0)
    80004ec0:	458d                	li	a1,3
    80004ec2:	f7040513          	addi	a0,s0,-144
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	786080e7          	jalr	1926(ra) # 8000464c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ece:	cd11                	beqz	a0,80004eea <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	0b6080e7          	jalr	182(ra) # 80002f86 <iunlockput>
  end_op();
    80004ed8:	fffff097          	auipc	ra,0xfffff
    80004edc:	86c080e7          	jalr	-1940(ra) # 80003744 <end_op>
  return 0;
    80004ee0:	4501                	li	a0,0
}
    80004ee2:	60ea                	ld	ra,152(sp)
    80004ee4:	644a                	ld	s0,144(sp)
    80004ee6:	610d                	addi	sp,sp,160
    80004ee8:	8082                	ret
    end_op();
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	85a080e7          	jalr	-1958(ra) # 80003744 <end_op>
    return -1;
    80004ef2:	557d                	li	a0,-1
    80004ef4:	b7fd                	j	80004ee2 <sys_mknod+0x6c>

0000000080004ef6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ef6:	7135                	addi	sp,sp,-160
    80004ef8:	ed06                	sd	ra,152(sp)
    80004efa:	e922                	sd	s0,144(sp)
    80004efc:	e526                	sd	s1,136(sp)
    80004efe:	e14a                	sd	s2,128(sp)
    80004f00:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f02:	ffffc097          	auipc	ra,0xffffc
    80004f06:	170080e7          	jalr	368(ra) # 80001072 <myproc>
    80004f0a:	892a                	mv	s2,a0
  
  begin_op();
    80004f0c:	ffffe097          	auipc	ra,0xffffe
    80004f10:	7be080e7          	jalr	1982(ra) # 800036ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f14:	08000613          	li	a2,128
    80004f18:	f6040593          	addi	a1,s0,-160
    80004f1c:	4501                	li	a0,0
    80004f1e:	ffffd097          	auipc	ra,0xffffd
    80004f22:	2d6080e7          	jalr	726(ra) # 800021f4 <argstr>
    80004f26:	04054b63          	bltz	a0,80004f7c <sys_chdir+0x86>
    80004f2a:	f6040513          	addi	a0,s0,-160
    80004f2e:	ffffe097          	auipc	ra,0xffffe
    80004f32:	59c080e7          	jalr	1436(ra) # 800034ca <namei>
    80004f36:	84aa                	mv	s1,a0
    80004f38:	c131                	beqz	a0,80004f7c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f3a:	ffffe097          	auipc	ra,0xffffe
    80004f3e:	dea080e7          	jalr	-534(ra) # 80002d24 <ilock>
  if(ip->type != T_DIR){
    80004f42:	04449703          	lh	a4,68(s1)
    80004f46:	4785                	li	a5,1
    80004f48:	04f71063          	bne	a4,a5,80004f88 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f4c:	8526                	mv	a0,s1
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	e98080e7          	jalr	-360(ra) # 80002de6 <iunlock>
  iput(p->cwd);
    80004f56:	15093503          	ld	a0,336(s2)
    80004f5a:	ffffe097          	auipc	ra,0xffffe
    80004f5e:	f84080e7          	jalr	-124(ra) # 80002ede <iput>
  end_op();
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	7e2080e7          	jalr	2018(ra) # 80003744 <end_op>
  p->cwd = ip;
    80004f6a:	14993823          	sd	s1,336(s2)
  return 0;
    80004f6e:	4501                	li	a0,0
}
    80004f70:	60ea                	ld	ra,152(sp)
    80004f72:	644a                	ld	s0,144(sp)
    80004f74:	64aa                	ld	s1,136(sp)
    80004f76:	690a                	ld	s2,128(sp)
    80004f78:	610d                	addi	sp,sp,160
    80004f7a:	8082                	ret
    end_op();
    80004f7c:	ffffe097          	auipc	ra,0xffffe
    80004f80:	7c8080e7          	jalr	1992(ra) # 80003744 <end_op>
    return -1;
    80004f84:	557d                	li	a0,-1
    80004f86:	b7ed                	j	80004f70 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f88:	8526                	mv	a0,s1
    80004f8a:	ffffe097          	auipc	ra,0xffffe
    80004f8e:	ffc080e7          	jalr	-4(ra) # 80002f86 <iunlockput>
    end_op();
    80004f92:	ffffe097          	auipc	ra,0xffffe
    80004f96:	7b2080e7          	jalr	1970(ra) # 80003744 <end_op>
    return -1;
    80004f9a:	557d                	li	a0,-1
    80004f9c:	bfd1                	j	80004f70 <sys_chdir+0x7a>

0000000080004f9e <sys_exec>:

uint64
sys_exec(void)
{
    80004f9e:	7121                	addi	sp,sp,-448
    80004fa0:	ff06                	sd	ra,440(sp)
    80004fa2:	fb22                	sd	s0,432(sp)
    80004fa4:	f726                	sd	s1,424(sp)
    80004fa6:	f34a                	sd	s2,416(sp)
    80004fa8:	ef4e                	sd	s3,408(sp)
    80004faa:	eb52                	sd	s4,400(sp)
    80004fac:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004fae:	e4840593          	addi	a1,s0,-440
    80004fb2:	4505                	li	a0,1
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	220080e7          	jalr	544(ra) # 800021d4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004fbc:	08000613          	li	a2,128
    80004fc0:	f5040593          	addi	a1,s0,-176
    80004fc4:	4501                	li	a0,0
    80004fc6:	ffffd097          	auipc	ra,0xffffd
    80004fca:	22e080e7          	jalr	558(ra) # 800021f4 <argstr>
    80004fce:	87aa                	mv	a5,a0
    return -1;
    80004fd0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004fd2:	0c07c263          	bltz	a5,80005096 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004fd6:	10000613          	li	a2,256
    80004fda:	4581                	li	a1,0
    80004fdc:	e5040513          	addi	a0,s0,-432
    80004fe0:	ffffb097          	auipc	ra,0xffffb
    80004fe4:	2ba080e7          	jalr	698(ra) # 8000029a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fe8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004fec:	89a6                	mv	s3,s1
    80004fee:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ff0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ff4:	00391513          	slli	a0,s2,0x3
    80004ff8:	e4040593          	addi	a1,s0,-448
    80004ffc:	e4843783          	ld	a5,-440(s0)
    80005000:	953e                	add	a0,a0,a5
    80005002:	ffffd097          	auipc	ra,0xffffd
    80005006:	114080e7          	jalr	276(ra) # 80002116 <fetchaddr>
    8000500a:	02054a63          	bltz	a0,8000503e <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    8000500e:	e4043783          	ld	a5,-448(s0)
    80005012:	c3b9                	beqz	a5,80005058 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005014:	ffffb097          	auipc	ra,0xffffb
    80005018:	1ee080e7          	jalr	494(ra) # 80000202 <kalloc>
    8000501c:	85aa                	mv	a1,a0
    8000501e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005022:	cd11                	beqz	a0,8000503e <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005024:	6605                	lui	a2,0x1
    80005026:	e4043503          	ld	a0,-448(s0)
    8000502a:	ffffd097          	auipc	ra,0xffffd
    8000502e:	13e080e7          	jalr	318(ra) # 80002168 <fetchstr>
    80005032:	00054663          	bltz	a0,8000503e <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005036:	0905                	addi	s2,s2,1
    80005038:	09a1                	addi	s3,s3,8
    8000503a:	fb491de3          	bne	s2,s4,80004ff4 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000503e:	f5040913          	addi	s2,s0,-176
    80005042:	6088                	ld	a0,0(s1)
    80005044:	c921                	beqz	a0,80005094 <sys_exec+0xf6>
    kfree(argv[i]);
    80005046:	ffffb097          	auipc	ra,0xffffb
    8000504a:	042080e7          	jalr	66(ra) # 80000088 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000504e:	04a1                	addi	s1,s1,8
    80005050:	ff2499e3          	bne	s1,s2,80005042 <sys_exec+0xa4>
  return -1;
    80005054:	557d                	li	a0,-1
    80005056:	a081                	j	80005096 <sys_exec+0xf8>
      argv[i] = 0;
    80005058:	0009079b          	sext.w	a5,s2
    8000505c:	078e                	slli	a5,a5,0x3
    8000505e:	fd078793          	addi	a5,a5,-48
    80005062:	97a2                	add	a5,a5,s0
    80005064:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005068:	e5040593          	addi	a1,s0,-432
    8000506c:	f5040513          	addi	a0,s0,-176
    80005070:	fffff097          	auipc	ra,0xfffff
    80005074:	194080e7          	jalr	404(ra) # 80004204 <exec>
    80005078:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000507a:	f5040993          	addi	s3,s0,-176
    8000507e:	6088                	ld	a0,0(s1)
    80005080:	c901                	beqz	a0,80005090 <sys_exec+0xf2>
    kfree(argv[i]);
    80005082:	ffffb097          	auipc	ra,0xffffb
    80005086:	006080e7          	jalr	6(ra) # 80000088 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000508a:	04a1                	addi	s1,s1,8
    8000508c:	ff3499e3          	bne	s1,s3,8000507e <sys_exec+0xe0>
  return ret;
    80005090:	854a                	mv	a0,s2
    80005092:	a011                	j	80005096 <sys_exec+0xf8>
  return -1;
    80005094:	557d                	li	a0,-1
}
    80005096:	70fa                	ld	ra,440(sp)
    80005098:	745a                	ld	s0,432(sp)
    8000509a:	74ba                	ld	s1,424(sp)
    8000509c:	791a                	ld	s2,416(sp)
    8000509e:	69fa                	ld	s3,408(sp)
    800050a0:	6a5a                	ld	s4,400(sp)
    800050a2:	6139                	addi	sp,sp,448
    800050a4:	8082                	ret

00000000800050a6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050a6:	7139                	addi	sp,sp,-64
    800050a8:	fc06                	sd	ra,56(sp)
    800050aa:	f822                	sd	s0,48(sp)
    800050ac:	f426                	sd	s1,40(sp)
    800050ae:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050b0:	ffffc097          	auipc	ra,0xffffc
    800050b4:	fc2080e7          	jalr	-62(ra) # 80001072 <myproc>
    800050b8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800050ba:	fd840593          	addi	a1,s0,-40
    800050be:	4501                	li	a0,0
    800050c0:	ffffd097          	auipc	ra,0xffffd
    800050c4:	114080e7          	jalr	276(ra) # 800021d4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050c8:	fc840593          	addi	a1,s0,-56
    800050cc:	fd040513          	addi	a0,s0,-48
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	dea080e7          	jalr	-534(ra) # 80003eba <pipealloc>
    return -1;
    800050d8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050da:	0c054463          	bltz	a0,800051a2 <sys_pipe+0xfc>
  fd0 = -1;
    800050de:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050e2:	fd043503          	ld	a0,-48(s0)
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	524080e7          	jalr	1316(ra) # 8000460a <fdalloc>
    800050ee:	fca42223          	sw	a0,-60(s0)
    800050f2:	08054b63          	bltz	a0,80005188 <sys_pipe+0xe2>
    800050f6:	fc843503          	ld	a0,-56(s0)
    800050fa:	fffff097          	auipc	ra,0xfffff
    800050fe:	510080e7          	jalr	1296(ra) # 8000460a <fdalloc>
    80005102:	fca42023          	sw	a0,-64(s0)
    80005106:	06054863          	bltz	a0,80005176 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000510a:	4691                	li	a3,4
    8000510c:	fc440613          	addi	a2,s0,-60
    80005110:	fd843583          	ld	a1,-40(s0)
    80005114:	68a8                	ld	a0,80(s1)
    80005116:	ffffc097          	auipc	ra,0xffffc
    8000511a:	cd6080e7          	jalr	-810(ra) # 80000dec <copyout>
    8000511e:	02054063          	bltz	a0,8000513e <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005122:	4691                	li	a3,4
    80005124:	fc040613          	addi	a2,s0,-64
    80005128:	fd843583          	ld	a1,-40(s0)
    8000512c:	0591                	addi	a1,a1,4
    8000512e:	68a8                	ld	a0,80(s1)
    80005130:	ffffc097          	auipc	ra,0xffffc
    80005134:	cbc080e7          	jalr	-836(ra) # 80000dec <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005138:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000513a:	06055463          	bgez	a0,800051a2 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000513e:	fc442783          	lw	a5,-60(s0)
    80005142:	07e9                	addi	a5,a5,26
    80005144:	078e                	slli	a5,a5,0x3
    80005146:	97a6                	add	a5,a5,s1
    80005148:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000514c:	fc042783          	lw	a5,-64(s0)
    80005150:	07e9                	addi	a5,a5,26
    80005152:	078e                	slli	a5,a5,0x3
    80005154:	94be                	add	s1,s1,a5
    80005156:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000515a:	fd043503          	ld	a0,-48(s0)
    8000515e:	fffff097          	auipc	ra,0xfffff
    80005162:	a30080e7          	jalr	-1488(ra) # 80003b8e <fileclose>
    fileclose(wf);
    80005166:	fc843503          	ld	a0,-56(s0)
    8000516a:	fffff097          	auipc	ra,0xfffff
    8000516e:	a24080e7          	jalr	-1500(ra) # 80003b8e <fileclose>
    return -1;
    80005172:	57fd                	li	a5,-1
    80005174:	a03d                	j	800051a2 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005176:	fc442783          	lw	a5,-60(s0)
    8000517a:	0007c763          	bltz	a5,80005188 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000517e:	07e9                	addi	a5,a5,26
    80005180:	078e                	slli	a5,a5,0x3
    80005182:	97a6                	add	a5,a5,s1
    80005184:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005188:	fd043503          	ld	a0,-48(s0)
    8000518c:	fffff097          	auipc	ra,0xfffff
    80005190:	a02080e7          	jalr	-1534(ra) # 80003b8e <fileclose>
    fileclose(wf);
    80005194:	fc843503          	ld	a0,-56(s0)
    80005198:	fffff097          	auipc	ra,0xfffff
    8000519c:	9f6080e7          	jalr	-1546(ra) # 80003b8e <fileclose>
    return -1;
    800051a0:	57fd                	li	a5,-1
}
    800051a2:	853e                	mv	a0,a5
    800051a4:	70e2                	ld	ra,56(sp)
    800051a6:	7442                	ld	s0,48(sp)
    800051a8:	74a2                	ld	s1,40(sp)
    800051aa:	6121                	addi	sp,sp,64
    800051ac:	8082                	ret
	...

00000000800051b0 <kernelvec>:
    800051b0:	7111                	addi	sp,sp,-256
    800051b2:	e006                	sd	ra,0(sp)
    800051b4:	e40a                	sd	sp,8(sp)
    800051b6:	e80e                	sd	gp,16(sp)
    800051b8:	ec12                	sd	tp,24(sp)
    800051ba:	f016                	sd	t0,32(sp)
    800051bc:	f41a                	sd	t1,40(sp)
    800051be:	f81e                	sd	t2,48(sp)
    800051c0:	fc22                	sd	s0,56(sp)
    800051c2:	e0a6                	sd	s1,64(sp)
    800051c4:	e4aa                	sd	a0,72(sp)
    800051c6:	e8ae                	sd	a1,80(sp)
    800051c8:	ecb2                	sd	a2,88(sp)
    800051ca:	f0b6                	sd	a3,96(sp)
    800051cc:	f4ba                	sd	a4,104(sp)
    800051ce:	f8be                	sd	a5,112(sp)
    800051d0:	fcc2                	sd	a6,120(sp)
    800051d2:	e146                	sd	a7,128(sp)
    800051d4:	e54a                	sd	s2,136(sp)
    800051d6:	e94e                	sd	s3,144(sp)
    800051d8:	ed52                	sd	s4,152(sp)
    800051da:	f156                	sd	s5,160(sp)
    800051dc:	f55a                	sd	s6,168(sp)
    800051de:	f95e                	sd	s7,176(sp)
    800051e0:	fd62                	sd	s8,184(sp)
    800051e2:	e1e6                	sd	s9,192(sp)
    800051e4:	e5ea                	sd	s10,200(sp)
    800051e6:	e9ee                	sd	s11,208(sp)
    800051e8:	edf2                	sd	t3,216(sp)
    800051ea:	f1f6                	sd	t4,224(sp)
    800051ec:	f5fa                	sd	t5,232(sp)
    800051ee:	f9fe                	sd	t6,240(sp)
    800051f0:	df3fc0ef          	jal	ra,80001fe2 <kerneltrap>
    800051f4:	6082                	ld	ra,0(sp)
    800051f6:	6122                	ld	sp,8(sp)
    800051f8:	61c2                	ld	gp,16(sp)
    800051fa:	7282                	ld	t0,32(sp)
    800051fc:	7322                	ld	t1,40(sp)
    800051fe:	73c2                	ld	t2,48(sp)
    80005200:	7462                	ld	s0,56(sp)
    80005202:	6486                	ld	s1,64(sp)
    80005204:	6526                	ld	a0,72(sp)
    80005206:	65c6                	ld	a1,80(sp)
    80005208:	6666                	ld	a2,88(sp)
    8000520a:	7686                	ld	a3,96(sp)
    8000520c:	7726                	ld	a4,104(sp)
    8000520e:	77c6                	ld	a5,112(sp)
    80005210:	7866                	ld	a6,120(sp)
    80005212:	688a                	ld	a7,128(sp)
    80005214:	692a                	ld	s2,136(sp)
    80005216:	69ca                	ld	s3,144(sp)
    80005218:	6a6a                	ld	s4,152(sp)
    8000521a:	7a8a                	ld	s5,160(sp)
    8000521c:	7b2a                	ld	s6,168(sp)
    8000521e:	7bca                	ld	s7,176(sp)
    80005220:	7c6a                	ld	s8,184(sp)
    80005222:	6c8e                	ld	s9,192(sp)
    80005224:	6d2e                	ld	s10,200(sp)
    80005226:	6dce                	ld	s11,208(sp)
    80005228:	6e6e                	ld	t3,216(sp)
    8000522a:	7e8e                	ld	t4,224(sp)
    8000522c:	7f2e                	ld	t5,232(sp)
    8000522e:	7fce                	ld	t6,240(sp)
    80005230:	6111                	addi	sp,sp,256
    80005232:	10200073          	sret
    80005236:	00000013          	nop
    8000523a:	00000013          	nop
    8000523e:	0001                	nop

0000000080005240 <timervec>:
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	e10c                	sd	a1,0(a0)
    80005246:	e510                	sd	a2,8(a0)
    80005248:	e914                	sd	a3,16(a0)
    8000524a:	6d0c                	ld	a1,24(a0)
    8000524c:	7110                	ld	a2,32(a0)
    8000524e:	6194                	ld	a3,0(a1)
    80005250:	96b2                	add	a3,a3,a2
    80005252:	e194                	sd	a3,0(a1)
    80005254:	4589                	li	a1,2
    80005256:	14459073          	csrw	sip,a1
    8000525a:	6914                	ld	a3,16(a0)
    8000525c:	6510                	ld	a2,8(a0)
    8000525e:	610c                	ld	a1,0(a0)
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	30200073          	mret
	...

000000008000526a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000526a:	1141                	addi	sp,sp,-16
    8000526c:	e422                	sd	s0,8(sp)
    8000526e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005270:	0c0007b7          	lui	a5,0xc000
    80005274:	4705                	li	a4,1
    80005276:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005278:	c3d8                	sw	a4,4(a5)
}
    8000527a:	6422                	ld	s0,8(sp)
    8000527c:	0141                	addi	sp,sp,16
    8000527e:	8082                	ret

0000000080005280 <plicinithart>:

void
plicinithart(void)
{
    80005280:	1141                	addi	sp,sp,-16
    80005282:	e406                	sd	ra,8(sp)
    80005284:	e022                	sd	s0,0(sp)
    80005286:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	dbe080e7          	jalr	-578(ra) # 80001046 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005290:	0085171b          	slliw	a4,a0,0x8
    80005294:	0c0027b7          	lui	a5,0xc002
    80005298:	97ba                	add	a5,a5,a4
    8000529a:	40200713          	li	a4,1026
    8000529e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052a2:	00d5151b          	slliw	a0,a0,0xd
    800052a6:	0c2017b7          	lui	a5,0xc201
    800052aa:	97aa                	add	a5,a5,a0
    800052ac:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052b0:	60a2                	ld	ra,8(sp)
    800052b2:	6402                	ld	s0,0(sp)
    800052b4:	0141                	addi	sp,sp,16
    800052b6:	8082                	ret

00000000800052b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052b8:	1141                	addi	sp,sp,-16
    800052ba:	e406                	sd	ra,8(sp)
    800052bc:	e022                	sd	s0,0(sp)
    800052be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c0:	ffffc097          	auipc	ra,0xffffc
    800052c4:	d86080e7          	jalr	-634(ra) # 80001046 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052c8:	00d5151b          	slliw	a0,a0,0xd
    800052cc:	0c2017b7          	lui	a5,0xc201
    800052d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800052d2:	43c8                	lw	a0,4(a5)
    800052d4:	60a2                	ld	ra,8(sp)
    800052d6:	6402                	ld	s0,0(sp)
    800052d8:	0141                	addi	sp,sp,16
    800052da:	8082                	ret

00000000800052dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052dc:	1101                	addi	sp,sp,-32
    800052de:	ec06                	sd	ra,24(sp)
    800052e0:	e822                	sd	s0,16(sp)
    800052e2:	e426                	sd	s1,8(sp)
    800052e4:	1000                	addi	s0,sp,32
    800052e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052e8:	ffffc097          	auipc	ra,0xffffc
    800052ec:	d5e080e7          	jalr	-674(ra) # 80001046 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052f0:	00d5151b          	slliw	a0,a0,0xd
    800052f4:	0c2017b7          	lui	a5,0xc201
    800052f8:	97aa                	add	a5,a5,a0
    800052fa:	c3c4                	sw	s1,4(a5)
}
    800052fc:	60e2                	ld	ra,24(sp)
    800052fe:	6442                	ld	s0,16(sp)
    80005300:	64a2                	ld	s1,8(sp)
    80005302:	6105                	addi	sp,sp,32
    80005304:	8082                	ret

0000000080005306 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005306:	1141                	addi	sp,sp,-16
    80005308:	e406                	sd	ra,8(sp)
    8000530a:	e022                	sd	s0,0(sp)
    8000530c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000530e:	479d                	li	a5,7
    80005310:	04a7cc63          	blt	a5,a0,80005368 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005314:	00234797          	auipc	a5,0x234
    80005318:	70c78793          	addi	a5,a5,1804 # 80239a20 <disk>
    8000531c:	97aa                	add	a5,a5,a0
    8000531e:	0187c783          	lbu	a5,24(a5)
    80005322:	ebb9                	bnez	a5,80005378 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005324:	00451693          	slli	a3,a0,0x4
    80005328:	00234797          	auipc	a5,0x234
    8000532c:	6f878793          	addi	a5,a5,1784 # 80239a20 <disk>
    80005330:	6398                	ld	a4,0(a5)
    80005332:	9736                	add	a4,a4,a3
    80005334:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005338:	6398                	ld	a4,0(a5)
    8000533a:	9736                	add	a4,a4,a3
    8000533c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005340:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005344:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005348:	97aa                	add	a5,a5,a0
    8000534a:	4705                	li	a4,1
    8000534c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005350:	00234517          	auipc	a0,0x234
    80005354:	6e850513          	addi	a0,a0,1768 # 80239a38 <disk+0x18>
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	426080e7          	jalr	1062(ra) # 8000177e <wakeup>
}
    80005360:	60a2                	ld	ra,8(sp)
    80005362:	6402                	ld	s0,0(sp)
    80005364:	0141                	addi	sp,sp,16
    80005366:	8082                	ret
    panic("free_desc 1");
    80005368:	00003517          	auipc	a0,0x3
    8000536c:	3c850513          	addi	a0,a0,968 # 80008730 <syscalls+0x2f0>
    80005370:	00001097          	auipc	ra,0x1
    80005374:	a06080e7          	jalr	-1530(ra) # 80005d76 <panic>
    panic("free_desc 2");
    80005378:	00003517          	auipc	a0,0x3
    8000537c:	3c850513          	addi	a0,a0,968 # 80008740 <syscalls+0x300>
    80005380:	00001097          	auipc	ra,0x1
    80005384:	9f6080e7          	jalr	-1546(ra) # 80005d76 <panic>

0000000080005388 <virtio_disk_init>:
{
    80005388:	1101                	addi	sp,sp,-32
    8000538a:	ec06                	sd	ra,24(sp)
    8000538c:	e822                	sd	s0,16(sp)
    8000538e:	e426                	sd	s1,8(sp)
    80005390:	e04a                	sd	s2,0(sp)
    80005392:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005394:	00003597          	auipc	a1,0x3
    80005398:	3bc58593          	addi	a1,a1,956 # 80008750 <syscalls+0x310>
    8000539c:	00234517          	auipc	a0,0x234
    800053a0:	7ac50513          	addi	a0,a0,1964 # 80239b48 <disk+0x128>
    800053a4:	00001097          	auipc	ra,0x1
    800053a8:	e7a080e7          	jalr	-390(ra) # 8000621e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053ac:	100017b7          	lui	a5,0x10001
    800053b0:	4398                	lw	a4,0(a5)
    800053b2:	2701                	sext.w	a4,a4
    800053b4:	747277b7          	lui	a5,0x74727
    800053b8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053bc:	14f71b63          	bne	a4,a5,80005512 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053c0:	100017b7          	lui	a5,0x10001
    800053c4:	43dc                	lw	a5,4(a5)
    800053c6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053c8:	4709                	li	a4,2
    800053ca:	14e79463          	bne	a5,a4,80005512 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ce:	100017b7          	lui	a5,0x10001
    800053d2:	479c                	lw	a5,8(a5)
    800053d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053d6:	12e79e63          	bne	a5,a4,80005512 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053da:	100017b7          	lui	a5,0x10001
    800053de:	47d8                	lw	a4,12(a5)
    800053e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053e2:	554d47b7          	lui	a5,0x554d4
    800053e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053ea:	12f71463          	bne	a4,a5,80005512 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ee:	100017b7          	lui	a5,0x10001
    800053f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f6:	4705                	li	a4,1
    800053f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053fa:	470d                	li	a4,3
    800053fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053fe:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005400:	c7ffe6b7          	lui	a3,0xc7ffe
    80005404:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47dbc9bf>
    80005408:	8f75                	and	a4,a4,a3
    8000540a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000540c:	472d                	li	a4,11
    8000540e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005410:	5bbc                	lw	a5,112(a5)
    80005412:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005416:	8ba1                	andi	a5,a5,8
    80005418:	10078563          	beqz	a5,80005522 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000541c:	100017b7          	lui	a5,0x10001
    80005420:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005424:	43fc                	lw	a5,68(a5)
    80005426:	2781                	sext.w	a5,a5
    80005428:	10079563          	bnez	a5,80005532 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000542c:	100017b7          	lui	a5,0x10001
    80005430:	5bdc                	lw	a5,52(a5)
    80005432:	2781                	sext.w	a5,a5
  if(max == 0)
    80005434:	10078763          	beqz	a5,80005542 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005438:	471d                	li	a4,7
    8000543a:	10f77c63          	bgeu	a4,a5,80005552 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000543e:	ffffb097          	auipc	ra,0xffffb
    80005442:	dc4080e7          	jalr	-572(ra) # 80000202 <kalloc>
    80005446:	00234497          	auipc	s1,0x234
    8000544a:	5da48493          	addi	s1,s1,1498 # 80239a20 <disk>
    8000544e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005450:	ffffb097          	auipc	ra,0xffffb
    80005454:	db2080e7          	jalr	-590(ra) # 80000202 <kalloc>
    80005458:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000545a:	ffffb097          	auipc	ra,0xffffb
    8000545e:	da8080e7          	jalr	-600(ra) # 80000202 <kalloc>
    80005462:	87aa                	mv	a5,a0
    80005464:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005466:	6088                	ld	a0,0(s1)
    80005468:	cd6d                	beqz	a0,80005562 <virtio_disk_init+0x1da>
    8000546a:	00234717          	auipc	a4,0x234
    8000546e:	5be73703          	ld	a4,1470(a4) # 80239a28 <disk+0x8>
    80005472:	cb65                	beqz	a4,80005562 <virtio_disk_init+0x1da>
    80005474:	c7fd                	beqz	a5,80005562 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005476:	6605                	lui	a2,0x1
    80005478:	4581                	li	a1,0
    8000547a:	ffffb097          	auipc	ra,0xffffb
    8000547e:	e20080e7          	jalr	-480(ra) # 8000029a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005482:	00234497          	auipc	s1,0x234
    80005486:	59e48493          	addi	s1,s1,1438 # 80239a20 <disk>
    8000548a:	6605                	lui	a2,0x1
    8000548c:	4581                	li	a1,0
    8000548e:	6488                	ld	a0,8(s1)
    80005490:	ffffb097          	auipc	ra,0xffffb
    80005494:	e0a080e7          	jalr	-502(ra) # 8000029a <memset>
  memset(disk.used, 0, PGSIZE);
    80005498:	6605                	lui	a2,0x1
    8000549a:	4581                	li	a1,0
    8000549c:	6888                	ld	a0,16(s1)
    8000549e:	ffffb097          	auipc	ra,0xffffb
    800054a2:	dfc080e7          	jalr	-516(ra) # 8000029a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054a6:	100017b7          	lui	a5,0x10001
    800054aa:	4721                	li	a4,8
    800054ac:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800054ae:	4098                	lw	a4,0(s1)
    800054b0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054b4:	40d8                	lw	a4,4(s1)
    800054b6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054ba:	6498                	ld	a4,8(s1)
    800054bc:	0007069b          	sext.w	a3,a4
    800054c0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054c4:	9701                	srai	a4,a4,0x20
    800054c6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054ca:	6898                	ld	a4,16(s1)
    800054cc:	0007069b          	sext.w	a3,a4
    800054d0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054d4:	9701                	srai	a4,a4,0x20
    800054d6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054da:	4705                	li	a4,1
    800054dc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800054de:	00e48c23          	sb	a4,24(s1)
    800054e2:	00e48ca3          	sb	a4,25(s1)
    800054e6:	00e48d23          	sb	a4,26(s1)
    800054ea:	00e48da3          	sb	a4,27(s1)
    800054ee:	00e48e23          	sb	a4,28(s1)
    800054f2:	00e48ea3          	sb	a4,29(s1)
    800054f6:	00e48f23          	sb	a4,30(s1)
    800054fa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054fe:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005502:	0727a823          	sw	s2,112(a5)
}
    80005506:	60e2                	ld	ra,24(sp)
    80005508:	6442                	ld	s0,16(sp)
    8000550a:	64a2                	ld	s1,8(sp)
    8000550c:	6902                	ld	s2,0(sp)
    8000550e:	6105                	addi	sp,sp,32
    80005510:	8082                	ret
    panic("could not find virtio disk");
    80005512:	00003517          	auipc	a0,0x3
    80005516:	24e50513          	addi	a0,a0,590 # 80008760 <syscalls+0x320>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	85c080e7          	jalr	-1956(ra) # 80005d76 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	25e50513          	addi	a0,a0,606 # 80008780 <syscalls+0x340>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	84c080e7          	jalr	-1972(ra) # 80005d76 <panic>
    panic("virtio disk should not be ready");
    80005532:	00003517          	auipc	a0,0x3
    80005536:	26e50513          	addi	a0,a0,622 # 800087a0 <syscalls+0x360>
    8000553a:	00001097          	auipc	ra,0x1
    8000553e:	83c080e7          	jalr	-1988(ra) # 80005d76 <panic>
    panic("virtio disk has no queue 0");
    80005542:	00003517          	auipc	a0,0x3
    80005546:	27e50513          	addi	a0,a0,638 # 800087c0 <syscalls+0x380>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	82c080e7          	jalr	-2004(ra) # 80005d76 <panic>
    panic("virtio disk max queue too short");
    80005552:	00003517          	auipc	a0,0x3
    80005556:	28e50513          	addi	a0,a0,654 # 800087e0 <syscalls+0x3a0>
    8000555a:	00001097          	auipc	ra,0x1
    8000555e:	81c080e7          	jalr	-2020(ra) # 80005d76 <panic>
    panic("virtio disk kalloc");
    80005562:	00003517          	auipc	a0,0x3
    80005566:	29e50513          	addi	a0,a0,670 # 80008800 <syscalls+0x3c0>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	80c080e7          	jalr	-2036(ra) # 80005d76 <panic>

0000000080005572 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005572:	7159                	addi	sp,sp,-112
    80005574:	f486                	sd	ra,104(sp)
    80005576:	f0a2                	sd	s0,96(sp)
    80005578:	eca6                	sd	s1,88(sp)
    8000557a:	e8ca                	sd	s2,80(sp)
    8000557c:	e4ce                	sd	s3,72(sp)
    8000557e:	e0d2                	sd	s4,64(sp)
    80005580:	fc56                	sd	s5,56(sp)
    80005582:	f85a                	sd	s6,48(sp)
    80005584:	f45e                	sd	s7,40(sp)
    80005586:	f062                	sd	s8,32(sp)
    80005588:	ec66                	sd	s9,24(sp)
    8000558a:	e86a                	sd	s10,16(sp)
    8000558c:	1880                	addi	s0,sp,112
    8000558e:	8a2a                	mv	s4,a0
    80005590:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005592:	00c52c83          	lw	s9,12(a0)
    80005596:	001c9c9b          	slliw	s9,s9,0x1
    8000559a:	1c82                	slli	s9,s9,0x20
    8000559c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055a0:	00234517          	auipc	a0,0x234
    800055a4:	5a850513          	addi	a0,a0,1448 # 80239b48 <disk+0x128>
    800055a8:	00001097          	auipc	ra,0x1
    800055ac:	d06080e7          	jalr	-762(ra) # 800062ae <acquire>
  for(int i = 0; i < 3; i++){
    800055b0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800055b2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055b4:	00234b17          	auipc	s6,0x234
    800055b8:	46cb0b13          	addi	s6,s6,1132 # 80239a20 <disk>
  for(int i = 0; i < 3; i++){
    800055bc:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055be:	00234c17          	auipc	s8,0x234
    800055c2:	58ac0c13          	addi	s8,s8,1418 # 80239b48 <disk+0x128>
    800055c6:	a095                	j	8000562a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800055c8:	00fb0733          	add	a4,s6,a5
    800055cc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055d0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800055d2:	0207c563          	bltz	a5,800055fc <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800055d6:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800055d8:	0591                	addi	a1,a1,4
    800055da:	05560d63          	beq	a2,s5,80005634 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800055de:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800055e0:	00234717          	auipc	a4,0x234
    800055e4:	44070713          	addi	a4,a4,1088 # 80239a20 <disk>
    800055e8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800055ea:	01874683          	lbu	a3,24(a4)
    800055ee:	fee9                	bnez	a3,800055c8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800055f0:	2785                	addiw	a5,a5,1
    800055f2:	0705                	addi	a4,a4,1
    800055f4:	fe979be3          	bne	a5,s1,800055ea <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800055f8:	57fd                	li	a5,-1
    800055fa:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800055fc:	00c05e63          	blez	a2,80005618 <virtio_disk_rw+0xa6>
    80005600:	060a                	slli	a2,a2,0x2
    80005602:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005606:	0009a503          	lw	a0,0(s3)
    8000560a:	00000097          	auipc	ra,0x0
    8000560e:	cfc080e7          	jalr	-772(ra) # 80005306 <free_desc>
      for(int j = 0; j < i; j++)
    80005612:	0991                	addi	s3,s3,4
    80005614:	ffa999e3          	bne	s3,s10,80005606 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005618:	85e2                	mv	a1,s8
    8000561a:	00234517          	auipc	a0,0x234
    8000561e:	41e50513          	addi	a0,a0,1054 # 80239a38 <disk+0x18>
    80005622:	ffffc097          	auipc	ra,0xffffc
    80005626:	0f8080e7          	jalr	248(ra) # 8000171a <sleep>
  for(int i = 0; i < 3; i++){
    8000562a:	f9040993          	addi	s3,s0,-112
{
    8000562e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005630:	864a                	mv	a2,s2
    80005632:	b775                	j	800055de <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005634:	f9042503          	lw	a0,-112(s0)
    80005638:	00a50713          	addi	a4,a0,10
    8000563c:	0712                	slli	a4,a4,0x4

  if(write)
    8000563e:	00234797          	auipc	a5,0x234
    80005642:	3e278793          	addi	a5,a5,994 # 80239a20 <disk>
    80005646:	00e786b3          	add	a3,a5,a4
    8000564a:	01703633          	snez	a2,s7
    8000564e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005650:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005654:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005658:	f6070613          	addi	a2,a4,-160
    8000565c:	6394                	ld	a3,0(a5)
    8000565e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005660:	00870593          	addi	a1,a4,8
    80005664:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005666:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005668:	0007b803          	ld	a6,0(a5)
    8000566c:	9642                	add	a2,a2,a6
    8000566e:	46c1                	li	a3,16
    80005670:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005672:	4585                	li	a1,1
    80005674:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005678:	f9442683          	lw	a3,-108(s0)
    8000567c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005680:	0692                	slli	a3,a3,0x4
    80005682:	9836                	add	a6,a6,a3
    80005684:	058a0613          	addi	a2,s4,88
    80005688:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000568c:	0007b803          	ld	a6,0(a5)
    80005690:	96c2                	add	a3,a3,a6
    80005692:	40000613          	li	a2,1024
    80005696:	c690                	sw	a2,8(a3)
  if(write)
    80005698:	001bb613          	seqz	a2,s7
    8000569c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056a0:	00166613          	ori	a2,a2,1
    800056a4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056a8:	f9842603          	lw	a2,-104(s0)
    800056ac:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056b0:	00250693          	addi	a3,a0,2
    800056b4:	0692                	slli	a3,a3,0x4
    800056b6:	96be                	add	a3,a3,a5
    800056b8:	58fd                	li	a7,-1
    800056ba:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056be:	0612                	slli	a2,a2,0x4
    800056c0:	9832                	add	a6,a6,a2
    800056c2:	f9070713          	addi	a4,a4,-112
    800056c6:	973e                	add	a4,a4,a5
    800056c8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800056cc:	6398                	ld	a4,0(a5)
    800056ce:	9732                	add	a4,a4,a2
    800056d0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056d2:	4609                	li	a2,2
    800056d4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800056d8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056dc:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800056e0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056e4:	6794                	ld	a3,8(a5)
    800056e6:	0026d703          	lhu	a4,2(a3)
    800056ea:	8b1d                	andi	a4,a4,7
    800056ec:	0706                	slli	a4,a4,0x1
    800056ee:	96ba                	add	a3,a3,a4
    800056f0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800056f4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056f8:	6798                	ld	a4,8(a5)
    800056fa:	00275783          	lhu	a5,2(a4)
    800056fe:	2785                	addiw	a5,a5,1
    80005700:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005704:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005708:	100017b7          	lui	a5,0x10001
    8000570c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005710:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005714:	00234917          	auipc	s2,0x234
    80005718:	43490913          	addi	s2,s2,1076 # 80239b48 <disk+0x128>
  while(b->disk == 1) {
    8000571c:	4485                	li	s1,1
    8000571e:	00b79c63          	bne	a5,a1,80005736 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005722:	85ca                	mv	a1,s2
    80005724:	8552                	mv	a0,s4
    80005726:	ffffc097          	auipc	ra,0xffffc
    8000572a:	ff4080e7          	jalr	-12(ra) # 8000171a <sleep>
  while(b->disk == 1) {
    8000572e:	004a2783          	lw	a5,4(s4)
    80005732:	fe9788e3          	beq	a5,s1,80005722 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005736:	f9042903          	lw	s2,-112(s0)
    8000573a:	00290713          	addi	a4,s2,2
    8000573e:	0712                	slli	a4,a4,0x4
    80005740:	00234797          	auipc	a5,0x234
    80005744:	2e078793          	addi	a5,a5,736 # 80239a20 <disk>
    80005748:	97ba                	add	a5,a5,a4
    8000574a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000574e:	00234997          	auipc	s3,0x234
    80005752:	2d298993          	addi	s3,s3,722 # 80239a20 <disk>
    80005756:	00491713          	slli	a4,s2,0x4
    8000575a:	0009b783          	ld	a5,0(s3)
    8000575e:	97ba                	add	a5,a5,a4
    80005760:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005764:	854a                	mv	a0,s2
    80005766:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000576a:	00000097          	auipc	ra,0x0
    8000576e:	b9c080e7          	jalr	-1124(ra) # 80005306 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005772:	8885                	andi	s1,s1,1
    80005774:	f0ed                	bnez	s1,80005756 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005776:	00234517          	auipc	a0,0x234
    8000577a:	3d250513          	addi	a0,a0,978 # 80239b48 <disk+0x128>
    8000577e:	00001097          	auipc	ra,0x1
    80005782:	be4080e7          	jalr	-1052(ra) # 80006362 <release>
}
    80005786:	70a6                	ld	ra,104(sp)
    80005788:	7406                	ld	s0,96(sp)
    8000578a:	64e6                	ld	s1,88(sp)
    8000578c:	6946                	ld	s2,80(sp)
    8000578e:	69a6                	ld	s3,72(sp)
    80005790:	6a06                	ld	s4,64(sp)
    80005792:	7ae2                	ld	s5,56(sp)
    80005794:	7b42                	ld	s6,48(sp)
    80005796:	7ba2                	ld	s7,40(sp)
    80005798:	7c02                	ld	s8,32(sp)
    8000579a:	6ce2                	ld	s9,24(sp)
    8000579c:	6d42                	ld	s10,16(sp)
    8000579e:	6165                	addi	sp,sp,112
    800057a0:	8082                	ret

00000000800057a2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057a2:	1101                	addi	sp,sp,-32
    800057a4:	ec06                	sd	ra,24(sp)
    800057a6:	e822                	sd	s0,16(sp)
    800057a8:	e426                	sd	s1,8(sp)
    800057aa:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057ac:	00234497          	auipc	s1,0x234
    800057b0:	27448493          	addi	s1,s1,628 # 80239a20 <disk>
    800057b4:	00234517          	auipc	a0,0x234
    800057b8:	39450513          	addi	a0,a0,916 # 80239b48 <disk+0x128>
    800057bc:	00001097          	auipc	ra,0x1
    800057c0:	af2080e7          	jalr	-1294(ra) # 800062ae <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057c4:	10001737          	lui	a4,0x10001
    800057c8:	533c                	lw	a5,96(a4)
    800057ca:	8b8d                	andi	a5,a5,3
    800057cc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057ce:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057d2:	689c                	ld	a5,16(s1)
    800057d4:	0204d703          	lhu	a4,32(s1)
    800057d8:	0027d783          	lhu	a5,2(a5)
    800057dc:	04f70863          	beq	a4,a5,8000582c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800057e0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057e4:	6898                	ld	a4,16(s1)
    800057e6:	0204d783          	lhu	a5,32(s1)
    800057ea:	8b9d                	andi	a5,a5,7
    800057ec:	078e                	slli	a5,a5,0x3
    800057ee:	97ba                	add	a5,a5,a4
    800057f0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057f2:	00278713          	addi	a4,a5,2
    800057f6:	0712                	slli	a4,a4,0x4
    800057f8:	9726                	add	a4,a4,s1
    800057fa:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057fe:	e721                	bnez	a4,80005846 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005800:	0789                	addi	a5,a5,2
    80005802:	0792                	slli	a5,a5,0x4
    80005804:	97a6                	add	a5,a5,s1
    80005806:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005808:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000580c:	ffffc097          	auipc	ra,0xffffc
    80005810:	f72080e7          	jalr	-142(ra) # 8000177e <wakeup>

    disk.used_idx += 1;
    80005814:	0204d783          	lhu	a5,32(s1)
    80005818:	2785                	addiw	a5,a5,1
    8000581a:	17c2                	slli	a5,a5,0x30
    8000581c:	93c1                	srli	a5,a5,0x30
    8000581e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005822:	6898                	ld	a4,16(s1)
    80005824:	00275703          	lhu	a4,2(a4)
    80005828:	faf71ce3          	bne	a4,a5,800057e0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000582c:	00234517          	auipc	a0,0x234
    80005830:	31c50513          	addi	a0,a0,796 # 80239b48 <disk+0x128>
    80005834:	00001097          	auipc	ra,0x1
    80005838:	b2e080e7          	jalr	-1234(ra) # 80006362 <release>
}
    8000583c:	60e2                	ld	ra,24(sp)
    8000583e:	6442                	ld	s0,16(sp)
    80005840:	64a2                	ld	s1,8(sp)
    80005842:	6105                	addi	sp,sp,32
    80005844:	8082                	ret
      panic("virtio_disk_intr status");
    80005846:	00003517          	auipc	a0,0x3
    8000584a:	fd250513          	addi	a0,a0,-46 # 80008818 <syscalls+0x3d8>
    8000584e:	00000097          	auipc	ra,0x0
    80005852:	528080e7          	jalr	1320(ra) # 80005d76 <panic>

0000000080005856 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005856:	1141                	addi	sp,sp,-16
    80005858:	e422                	sd	s0,8(sp)
    8000585a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid"
    8000585c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005860:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005864:	0037979b          	slliw	a5,a5,0x3
    80005868:	02004737          	lui	a4,0x2004
    8000586c:	97ba                	add	a5,a5,a4
    8000586e:	0200c737          	lui	a4,0x200c
    80005872:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005876:	000f4637          	lui	a2,0xf4
    8000587a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000587e:	9732                	add	a4,a4,a2
    80005880:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005882:	00259693          	slli	a3,a1,0x2
    80005886:	96ae                	add	a3,a3,a1
    80005888:	068e                	slli	a3,a3,0x3
    8000588a:	00234717          	auipc	a4,0x234
    8000588e:	2d670713          	addi	a4,a4,726 # 80239b60 <timer_scratch>
    80005892:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005894:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005896:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0"
    80005898:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0"
    8000589c:	00000797          	auipc	a5,0x0
    800058a0:	9a478793          	addi	a5,a5,-1628 # 80005240 <timervec>
    800058a4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus"
    800058a8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058ac:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0"
    800058b0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie"
    800058b4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058b8:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0"
    800058bc:	30479073          	csrw	mie,a5
}
    800058c0:	6422                	ld	s0,8(sp)
    800058c2:	0141                	addi	sp,sp,16
    800058c4:	8082                	ret

00000000800058c6 <start>:
{
    800058c6:	1141                	addi	sp,sp,-16
    800058c8:	e406                	sd	ra,8(sp)
    800058ca:	e022                	sd	s0,0(sp)
    800058cc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus"
    800058ce:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058d2:	7779                	lui	a4,0xffffe
    800058d4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbca5f>
    800058d8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058da:	6705                	lui	a4,0x1
    800058dc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058e0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0"
    800058e2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0"
    800058e6:	ffffb797          	auipc	a5,0xffffb
    800058ea:	b5878793          	addi	a5,a5,-1192 # 8000043e <main>
    800058ee:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0"
    800058f2:	4781                	li	a5,0
    800058f4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0"
    800058f8:	67c1                	lui	a5,0x10
    800058fa:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058fc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0"
    80005900:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie"
    80005904:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005908:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0"
    8000590c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0"
    80005910:	57fd                	li	a5,-1
    80005912:	83a9                	srli	a5,a5,0xa
    80005914:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0"
    80005918:	47bd                	li	a5,15
    8000591a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000591e:	00000097          	auipc	ra,0x0
    80005922:	f38080e7          	jalr	-200(ra) # 80005856 <timerinit>
  asm volatile("csrr %0, mhartid"
    80005926:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000592a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0"
    8000592c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000592e:	30200073          	mret
}
    80005932:	60a2                	ld	ra,8(sp)
    80005934:	6402                	ld	s0,0(sp)
    80005936:	0141                	addi	sp,sp,16
    80005938:	8082                	ret

000000008000593a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000593a:	715d                	addi	sp,sp,-80
    8000593c:	e486                	sd	ra,72(sp)
    8000593e:	e0a2                	sd	s0,64(sp)
    80005940:	fc26                	sd	s1,56(sp)
    80005942:	f84a                	sd	s2,48(sp)
    80005944:	f44e                	sd	s3,40(sp)
    80005946:	f052                	sd	s4,32(sp)
    80005948:	ec56                	sd	s5,24(sp)
    8000594a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000594c:	04c05763          	blez	a2,8000599a <consolewrite+0x60>
    80005950:	8a2a                	mv	s4,a0
    80005952:	84ae                	mv	s1,a1
    80005954:	89b2                	mv	s3,a2
    80005956:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005958:	5afd                	li	s5,-1
    8000595a:	4685                	li	a3,1
    8000595c:	8626                	mv	a2,s1
    8000595e:	85d2                	mv	a1,s4
    80005960:	fbf40513          	addi	a0,s0,-65
    80005964:	ffffc097          	auipc	ra,0xffffc
    80005968:	214080e7          	jalr	532(ra) # 80001b78 <either_copyin>
    8000596c:	01550d63          	beq	a0,s5,80005986 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005970:	fbf44503          	lbu	a0,-65(s0)
    80005974:	00000097          	auipc	ra,0x0
    80005978:	780080e7          	jalr	1920(ra) # 800060f4 <uartputc>
  for(i = 0; i < n; i++){
    8000597c:	2905                	addiw	s2,s2,1
    8000597e:	0485                	addi	s1,s1,1
    80005980:	fd299de3          	bne	s3,s2,8000595a <consolewrite+0x20>
    80005984:	894e                	mv	s2,s3
  }

  return i;
}
    80005986:	854a                	mv	a0,s2
    80005988:	60a6                	ld	ra,72(sp)
    8000598a:	6406                	ld	s0,64(sp)
    8000598c:	74e2                	ld	s1,56(sp)
    8000598e:	7942                	ld	s2,48(sp)
    80005990:	79a2                	ld	s3,40(sp)
    80005992:	7a02                	ld	s4,32(sp)
    80005994:	6ae2                	ld	s5,24(sp)
    80005996:	6161                	addi	sp,sp,80
    80005998:	8082                	ret
  for(i = 0; i < n; i++){
    8000599a:	4901                	li	s2,0
    8000599c:	b7ed                	j	80005986 <consolewrite+0x4c>

000000008000599e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000599e:	711d                	addi	sp,sp,-96
    800059a0:	ec86                	sd	ra,88(sp)
    800059a2:	e8a2                	sd	s0,80(sp)
    800059a4:	e4a6                	sd	s1,72(sp)
    800059a6:	e0ca                	sd	s2,64(sp)
    800059a8:	fc4e                	sd	s3,56(sp)
    800059aa:	f852                	sd	s4,48(sp)
    800059ac:	f456                	sd	s5,40(sp)
    800059ae:	f05a                	sd	s6,32(sp)
    800059b0:	ec5e                	sd	s7,24(sp)
    800059b2:	1080                	addi	s0,sp,96
    800059b4:	8aaa                	mv	s5,a0
    800059b6:	8a2e                	mv	s4,a1
    800059b8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059ba:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059be:	0023c517          	auipc	a0,0x23c
    800059c2:	2e250513          	addi	a0,a0,738 # 80241ca0 <cons>
    800059c6:	00001097          	auipc	ra,0x1
    800059ca:	8e8080e7          	jalr	-1816(ra) # 800062ae <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059ce:	0023c497          	auipc	s1,0x23c
    800059d2:	2d248493          	addi	s1,s1,722 # 80241ca0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059d6:	0023c917          	auipc	s2,0x23c
    800059da:	36290913          	addi	s2,s2,866 # 80241d38 <cons+0x98>
  while(n > 0){
    800059de:	09305263          	blez	s3,80005a62 <consoleread+0xc4>
    while(cons.r == cons.w){
    800059e2:	0984a783          	lw	a5,152(s1)
    800059e6:	09c4a703          	lw	a4,156(s1)
    800059ea:	02f71763          	bne	a4,a5,80005a18 <consoleread+0x7a>
      if(killed(myproc())){
    800059ee:	ffffb097          	auipc	ra,0xffffb
    800059f2:	684080e7          	jalr	1668(ra) # 80001072 <myproc>
    800059f6:	ffffc097          	auipc	ra,0xffffc
    800059fa:	fcc080e7          	jalr	-52(ra) # 800019c2 <killed>
    800059fe:	ed2d                	bnez	a0,80005a78 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005a00:	85a6                	mv	a1,s1
    80005a02:	854a                	mv	a0,s2
    80005a04:	ffffc097          	auipc	ra,0xffffc
    80005a08:	d16080e7          	jalr	-746(ra) # 8000171a <sleep>
    while(cons.r == cons.w){
    80005a0c:	0984a783          	lw	a5,152(s1)
    80005a10:	09c4a703          	lw	a4,156(s1)
    80005a14:	fcf70de3          	beq	a4,a5,800059ee <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a18:	0023c717          	auipc	a4,0x23c
    80005a1c:	28870713          	addi	a4,a4,648 # 80241ca0 <cons>
    80005a20:	0017869b          	addiw	a3,a5,1
    80005a24:	08d72c23          	sw	a3,152(a4)
    80005a28:	07f7f693          	andi	a3,a5,127
    80005a2c:	9736                	add	a4,a4,a3
    80005a2e:	01874703          	lbu	a4,24(a4)
    80005a32:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a36:	4691                	li	a3,4
    80005a38:	06db8463          	beq	s7,a3,80005aa0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a3c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a40:	4685                	li	a3,1
    80005a42:	faf40613          	addi	a2,s0,-81
    80005a46:	85d2                	mv	a1,s4
    80005a48:	8556                	mv	a0,s5
    80005a4a:	ffffc097          	auipc	ra,0xffffc
    80005a4e:	0d8080e7          	jalr	216(ra) # 80001b22 <either_copyout>
    80005a52:	57fd                	li	a5,-1
    80005a54:	00f50763          	beq	a0,a5,80005a62 <consoleread+0xc4>
      break;

    dst++;
    80005a58:	0a05                	addi	s4,s4,1
    --n;
    80005a5a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005a5c:	47a9                	li	a5,10
    80005a5e:	f8fb90e3          	bne	s7,a5,800059de <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a62:	0023c517          	auipc	a0,0x23c
    80005a66:	23e50513          	addi	a0,a0,574 # 80241ca0 <cons>
    80005a6a:	00001097          	auipc	ra,0x1
    80005a6e:	8f8080e7          	jalr	-1800(ra) # 80006362 <release>

  return target - n;
    80005a72:	413b053b          	subw	a0,s6,s3
    80005a76:	a811                	j	80005a8a <consoleread+0xec>
        release(&cons.lock);
    80005a78:	0023c517          	auipc	a0,0x23c
    80005a7c:	22850513          	addi	a0,a0,552 # 80241ca0 <cons>
    80005a80:	00001097          	auipc	ra,0x1
    80005a84:	8e2080e7          	jalr	-1822(ra) # 80006362 <release>
        return -1;
    80005a88:	557d                	li	a0,-1
}
    80005a8a:	60e6                	ld	ra,88(sp)
    80005a8c:	6446                	ld	s0,80(sp)
    80005a8e:	64a6                	ld	s1,72(sp)
    80005a90:	6906                	ld	s2,64(sp)
    80005a92:	79e2                	ld	s3,56(sp)
    80005a94:	7a42                	ld	s4,48(sp)
    80005a96:	7aa2                	ld	s5,40(sp)
    80005a98:	7b02                	ld	s6,32(sp)
    80005a9a:	6be2                	ld	s7,24(sp)
    80005a9c:	6125                	addi	sp,sp,96
    80005a9e:	8082                	ret
      if(n < target){
    80005aa0:	0009871b          	sext.w	a4,s3
    80005aa4:	fb677fe3          	bgeu	a4,s6,80005a62 <consoleread+0xc4>
        cons.r--;
    80005aa8:	0023c717          	auipc	a4,0x23c
    80005aac:	28f72823          	sw	a5,656(a4) # 80241d38 <cons+0x98>
    80005ab0:	bf4d                	j	80005a62 <consoleread+0xc4>

0000000080005ab2 <consputc>:
{
    80005ab2:	1141                	addi	sp,sp,-16
    80005ab4:	e406                	sd	ra,8(sp)
    80005ab6:	e022                	sd	s0,0(sp)
    80005ab8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005aba:	10000793          	li	a5,256
    80005abe:	00f50a63          	beq	a0,a5,80005ad2 <consputc+0x20>
    uartputc_sync(c);
    80005ac2:	00000097          	auipc	ra,0x0
    80005ac6:	560080e7          	jalr	1376(ra) # 80006022 <uartputc_sync>
}
    80005aca:	60a2                	ld	ra,8(sp)
    80005acc:	6402                	ld	s0,0(sp)
    80005ace:	0141                	addi	sp,sp,16
    80005ad0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ad2:	4521                	li	a0,8
    80005ad4:	00000097          	auipc	ra,0x0
    80005ad8:	54e080e7          	jalr	1358(ra) # 80006022 <uartputc_sync>
    80005adc:	02000513          	li	a0,32
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	542080e7          	jalr	1346(ra) # 80006022 <uartputc_sync>
    80005ae8:	4521                	li	a0,8
    80005aea:	00000097          	auipc	ra,0x0
    80005aee:	538080e7          	jalr	1336(ra) # 80006022 <uartputc_sync>
    80005af2:	bfe1                	j	80005aca <consputc+0x18>

0000000080005af4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005af4:	1101                	addi	sp,sp,-32
    80005af6:	ec06                	sd	ra,24(sp)
    80005af8:	e822                	sd	s0,16(sp)
    80005afa:	e426                	sd	s1,8(sp)
    80005afc:	e04a                	sd	s2,0(sp)
    80005afe:	1000                	addi	s0,sp,32
    80005b00:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b02:	0023c517          	auipc	a0,0x23c
    80005b06:	19e50513          	addi	a0,a0,414 # 80241ca0 <cons>
    80005b0a:	00000097          	auipc	ra,0x0
    80005b0e:	7a4080e7          	jalr	1956(ra) # 800062ae <acquire>

  switch(c){
    80005b12:	47d5                	li	a5,21
    80005b14:	0af48663          	beq	s1,a5,80005bc0 <consoleintr+0xcc>
    80005b18:	0297ca63          	blt	a5,s1,80005b4c <consoleintr+0x58>
    80005b1c:	47a1                	li	a5,8
    80005b1e:	0ef48763          	beq	s1,a5,80005c0c <consoleintr+0x118>
    80005b22:	47c1                	li	a5,16
    80005b24:	10f49a63          	bne	s1,a5,80005c38 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b28:	ffffc097          	auipc	ra,0xffffc
    80005b2c:	0a6080e7          	jalr	166(ra) # 80001bce <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b30:	0023c517          	auipc	a0,0x23c
    80005b34:	17050513          	addi	a0,a0,368 # 80241ca0 <cons>
    80005b38:	00001097          	auipc	ra,0x1
    80005b3c:	82a080e7          	jalr	-2006(ra) # 80006362 <release>
}
    80005b40:	60e2                	ld	ra,24(sp)
    80005b42:	6442                	ld	s0,16(sp)
    80005b44:	64a2                	ld	s1,8(sp)
    80005b46:	6902                	ld	s2,0(sp)
    80005b48:	6105                	addi	sp,sp,32
    80005b4a:	8082                	ret
  switch(c){
    80005b4c:	07f00793          	li	a5,127
    80005b50:	0af48e63          	beq	s1,a5,80005c0c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b54:	0023c717          	auipc	a4,0x23c
    80005b58:	14c70713          	addi	a4,a4,332 # 80241ca0 <cons>
    80005b5c:	0a072783          	lw	a5,160(a4)
    80005b60:	09872703          	lw	a4,152(a4)
    80005b64:	9f99                	subw	a5,a5,a4
    80005b66:	07f00713          	li	a4,127
    80005b6a:	fcf763e3          	bltu	a4,a5,80005b30 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b6e:	47b5                	li	a5,13
    80005b70:	0cf48763          	beq	s1,a5,80005c3e <consoleintr+0x14a>
      consputc(c);
    80005b74:	8526                	mv	a0,s1
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	f3c080e7          	jalr	-196(ra) # 80005ab2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b7e:	0023c797          	auipc	a5,0x23c
    80005b82:	12278793          	addi	a5,a5,290 # 80241ca0 <cons>
    80005b86:	0a07a683          	lw	a3,160(a5)
    80005b8a:	0016871b          	addiw	a4,a3,1
    80005b8e:	0007061b          	sext.w	a2,a4
    80005b92:	0ae7a023          	sw	a4,160(a5)
    80005b96:	07f6f693          	andi	a3,a3,127
    80005b9a:	97b6                	add	a5,a5,a3
    80005b9c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005ba0:	47a9                	li	a5,10
    80005ba2:	0cf48563          	beq	s1,a5,80005c6c <consoleintr+0x178>
    80005ba6:	4791                	li	a5,4
    80005ba8:	0cf48263          	beq	s1,a5,80005c6c <consoleintr+0x178>
    80005bac:	0023c797          	auipc	a5,0x23c
    80005bb0:	18c7a783          	lw	a5,396(a5) # 80241d38 <cons+0x98>
    80005bb4:	9f1d                	subw	a4,a4,a5
    80005bb6:	08000793          	li	a5,128
    80005bba:	f6f71be3          	bne	a4,a5,80005b30 <consoleintr+0x3c>
    80005bbe:	a07d                	j	80005c6c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bc0:	0023c717          	auipc	a4,0x23c
    80005bc4:	0e070713          	addi	a4,a4,224 # 80241ca0 <cons>
    80005bc8:	0a072783          	lw	a5,160(a4)
    80005bcc:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bd0:	0023c497          	auipc	s1,0x23c
    80005bd4:	0d048493          	addi	s1,s1,208 # 80241ca0 <cons>
    while(cons.e != cons.w &&
    80005bd8:	4929                	li	s2,10
    80005bda:	f4f70be3          	beq	a4,a5,80005b30 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bde:	37fd                	addiw	a5,a5,-1
    80005be0:	07f7f713          	andi	a4,a5,127
    80005be4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005be6:	01874703          	lbu	a4,24(a4)
    80005bea:	f52703e3          	beq	a4,s2,80005b30 <consoleintr+0x3c>
      cons.e--;
    80005bee:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bf2:	10000513          	li	a0,256
    80005bf6:	00000097          	auipc	ra,0x0
    80005bfa:	ebc080e7          	jalr	-324(ra) # 80005ab2 <consputc>
    while(cons.e != cons.w &&
    80005bfe:	0a04a783          	lw	a5,160(s1)
    80005c02:	09c4a703          	lw	a4,156(s1)
    80005c06:	fcf71ce3          	bne	a4,a5,80005bde <consoleintr+0xea>
    80005c0a:	b71d                	j	80005b30 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c0c:	0023c717          	auipc	a4,0x23c
    80005c10:	09470713          	addi	a4,a4,148 # 80241ca0 <cons>
    80005c14:	0a072783          	lw	a5,160(a4)
    80005c18:	09c72703          	lw	a4,156(a4)
    80005c1c:	f0f70ae3          	beq	a4,a5,80005b30 <consoleintr+0x3c>
      cons.e--;
    80005c20:	37fd                	addiw	a5,a5,-1
    80005c22:	0023c717          	auipc	a4,0x23c
    80005c26:	10f72f23          	sw	a5,286(a4) # 80241d40 <cons+0xa0>
      consputc(BACKSPACE);
    80005c2a:	10000513          	li	a0,256
    80005c2e:	00000097          	auipc	ra,0x0
    80005c32:	e84080e7          	jalr	-380(ra) # 80005ab2 <consputc>
    80005c36:	bded                	j	80005b30 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c38:	ee048ce3          	beqz	s1,80005b30 <consoleintr+0x3c>
    80005c3c:	bf21                	j	80005b54 <consoleintr+0x60>
      consputc(c);
    80005c3e:	4529                	li	a0,10
    80005c40:	00000097          	auipc	ra,0x0
    80005c44:	e72080e7          	jalr	-398(ra) # 80005ab2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c48:	0023c797          	auipc	a5,0x23c
    80005c4c:	05878793          	addi	a5,a5,88 # 80241ca0 <cons>
    80005c50:	0a07a703          	lw	a4,160(a5)
    80005c54:	0017069b          	addiw	a3,a4,1
    80005c58:	0006861b          	sext.w	a2,a3
    80005c5c:	0ad7a023          	sw	a3,160(a5)
    80005c60:	07f77713          	andi	a4,a4,127
    80005c64:	97ba                	add	a5,a5,a4
    80005c66:	4729                	li	a4,10
    80005c68:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c6c:	0023c797          	auipc	a5,0x23c
    80005c70:	0cc7a823          	sw	a2,208(a5) # 80241d3c <cons+0x9c>
        wakeup(&cons.r);
    80005c74:	0023c517          	auipc	a0,0x23c
    80005c78:	0c450513          	addi	a0,a0,196 # 80241d38 <cons+0x98>
    80005c7c:	ffffc097          	auipc	ra,0xffffc
    80005c80:	b02080e7          	jalr	-1278(ra) # 8000177e <wakeup>
    80005c84:	b575                	j	80005b30 <consoleintr+0x3c>

0000000080005c86 <consoleinit>:

void
consoleinit(void)
{
    80005c86:	1141                	addi	sp,sp,-16
    80005c88:	e406                	sd	ra,8(sp)
    80005c8a:	e022                	sd	s0,0(sp)
    80005c8c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c8e:	00003597          	auipc	a1,0x3
    80005c92:	ba258593          	addi	a1,a1,-1118 # 80008830 <syscalls+0x3f0>
    80005c96:	0023c517          	auipc	a0,0x23c
    80005c9a:	00a50513          	addi	a0,a0,10 # 80241ca0 <cons>
    80005c9e:	00000097          	auipc	ra,0x0
    80005ca2:	580080e7          	jalr	1408(ra) # 8000621e <initlock>

  uartinit();
    80005ca6:	00000097          	auipc	ra,0x0
    80005caa:	32c080e7          	jalr	812(ra) # 80005fd2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cae:	00233797          	auipc	a5,0x233
    80005cb2:	d1a78793          	addi	a5,a5,-742 # 802389c8 <devsw>
    80005cb6:	00000717          	auipc	a4,0x0
    80005cba:	ce870713          	addi	a4,a4,-792 # 8000599e <consoleread>
    80005cbe:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cc0:	00000717          	auipc	a4,0x0
    80005cc4:	c7a70713          	addi	a4,a4,-902 # 8000593a <consolewrite>
    80005cc8:	ef98                	sd	a4,24(a5)
}
    80005cca:	60a2                	ld	ra,8(sp)
    80005ccc:	6402                	ld	s0,0(sp)
    80005cce:	0141                	addi	sp,sp,16
    80005cd0:	8082                	ret

0000000080005cd2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cd2:	7179                	addi	sp,sp,-48
    80005cd4:	f406                	sd	ra,40(sp)
    80005cd6:	f022                	sd	s0,32(sp)
    80005cd8:	ec26                	sd	s1,24(sp)
    80005cda:	e84a                	sd	s2,16(sp)
    80005cdc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cde:	c219                	beqz	a2,80005ce4 <printint+0x12>
    80005ce0:	08054763          	bltz	a0,80005d6e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005ce4:	2501                	sext.w	a0,a0
    80005ce6:	4881                	li	a7,0
    80005ce8:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cec:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cee:	2581                	sext.w	a1,a1
    80005cf0:	00003617          	auipc	a2,0x3
    80005cf4:	b7060613          	addi	a2,a2,-1168 # 80008860 <digits>
    80005cf8:	883a                	mv	a6,a4
    80005cfa:	2705                	addiw	a4,a4,1
    80005cfc:	02b577bb          	remuw	a5,a0,a1
    80005d00:	1782                	slli	a5,a5,0x20
    80005d02:	9381                	srli	a5,a5,0x20
    80005d04:	97b2                	add	a5,a5,a2
    80005d06:	0007c783          	lbu	a5,0(a5)
    80005d0a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d0e:	0005079b          	sext.w	a5,a0
    80005d12:	02b5553b          	divuw	a0,a0,a1
    80005d16:	0685                	addi	a3,a3,1
    80005d18:	feb7f0e3          	bgeu	a5,a1,80005cf8 <printint+0x26>

  if(sign)
    80005d1c:	00088c63          	beqz	a7,80005d34 <printint+0x62>
    buf[i++] = '-';
    80005d20:	fe070793          	addi	a5,a4,-32
    80005d24:	00878733          	add	a4,a5,s0
    80005d28:	02d00793          	li	a5,45
    80005d2c:	fef70823          	sb	a5,-16(a4)
    80005d30:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d34:	02e05763          	blez	a4,80005d62 <printint+0x90>
    80005d38:	fd040793          	addi	a5,s0,-48
    80005d3c:	00e784b3          	add	s1,a5,a4
    80005d40:	fff78913          	addi	s2,a5,-1
    80005d44:	993a                	add	s2,s2,a4
    80005d46:	377d                	addiw	a4,a4,-1
    80005d48:	1702                	slli	a4,a4,0x20
    80005d4a:	9301                	srli	a4,a4,0x20
    80005d4c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d50:	fff4c503          	lbu	a0,-1(s1)
    80005d54:	00000097          	auipc	ra,0x0
    80005d58:	d5e080e7          	jalr	-674(ra) # 80005ab2 <consputc>
  while(--i >= 0)
    80005d5c:	14fd                	addi	s1,s1,-1
    80005d5e:	ff2499e3          	bne	s1,s2,80005d50 <printint+0x7e>
}
    80005d62:	70a2                	ld	ra,40(sp)
    80005d64:	7402                	ld	s0,32(sp)
    80005d66:	64e2                	ld	s1,24(sp)
    80005d68:	6942                	ld	s2,16(sp)
    80005d6a:	6145                	addi	sp,sp,48
    80005d6c:	8082                	ret
    x = -xx;
    80005d6e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d72:	4885                	li	a7,1
    x = -xx;
    80005d74:	bf95                	j	80005ce8 <printint+0x16>

0000000080005d76 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d76:	1101                	addi	sp,sp,-32
    80005d78:	ec06                	sd	ra,24(sp)
    80005d7a:	e822                	sd	s0,16(sp)
    80005d7c:	e426                	sd	s1,8(sp)
    80005d7e:	1000                	addi	s0,sp,32
    80005d80:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d82:	0023c797          	auipc	a5,0x23c
    80005d86:	fc07af23          	sw	zero,-34(a5) # 80241d60 <pr+0x18>
  printf("panic: ");
    80005d8a:	00003517          	auipc	a0,0x3
    80005d8e:	aae50513          	addi	a0,a0,-1362 # 80008838 <syscalls+0x3f8>
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	02e080e7          	jalr	46(ra) # 80005dc0 <printf>
  printf(s);
    80005d9a:	8526                	mv	a0,s1
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	024080e7          	jalr	36(ra) # 80005dc0 <printf>
  printf("\n");
    80005da4:	00002517          	auipc	a0,0x2
    80005da8:	3fc50513          	addi	a0,a0,1020 # 800081a0 <etext+0x1a0>
    80005dac:	00000097          	auipc	ra,0x0
    80005db0:	014080e7          	jalr	20(ra) # 80005dc0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005db4:	4785                	li	a5,1
    80005db6:	00003717          	auipc	a4,0x3
    80005dba:	b6f72323          	sw	a5,-1178(a4) # 8000891c <panicked>
  for(;;)
    80005dbe:	a001                	j	80005dbe <panic+0x48>

0000000080005dc0 <printf>:
{
    80005dc0:	7131                	addi	sp,sp,-192
    80005dc2:	fc86                	sd	ra,120(sp)
    80005dc4:	f8a2                	sd	s0,112(sp)
    80005dc6:	f4a6                	sd	s1,104(sp)
    80005dc8:	f0ca                	sd	s2,96(sp)
    80005dca:	ecce                	sd	s3,88(sp)
    80005dcc:	e8d2                	sd	s4,80(sp)
    80005dce:	e4d6                	sd	s5,72(sp)
    80005dd0:	e0da                	sd	s6,64(sp)
    80005dd2:	fc5e                	sd	s7,56(sp)
    80005dd4:	f862                	sd	s8,48(sp)
    80005dd6:	f466                	sd	s9,40(sp)
    80005dd8:	f06a                	sd	s10,32(sp)
    80005dda:	ec6e                	sd	s11,24(sp)
    80005ddc:	0100                	addi	s0,sp,128
    80005dde:	8a2a                	mv	s4,a0
    80005de0:	e40c                	sd	a1,8(s0)
    80005de2:	e810                	sd	a2,16(s0)
    80005de4:	ec14                	sd	a3,24(s0)
    80005de6:	f018                	sd	a4,32(s0)
    80005de8:	f41c                	sd	a5,40(s0)
    80005dea:	03043823          	sd	a6,48(s0)
    80005dee:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005df2:	0023cd97          	auipc	s11,0x23c
    80005df6:	f6edad83          	lw	s11,-146(s11) # 80241d60 <pr+0x18>
  if(locking)
    80005dfa:	020d9b63          	bnez	s11,80005e30 <printf+0x70>
  if (fmt == 0)
    80005dfe:	040a0263          	beqz	s4,80005e42 <printf+0x82>
  va_start(ap, fmt);
    80005e02:	00840793          	addi	a5,s0,8
    80005e06:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e0a:	000a4503          	lbu	a0,0(s4)
    80005e0e:	14050f63          	beqz	a0,80005f6c <printf+0x1ac>
    80005e12:	4981                	li	s3,0
    if(c != '%'){
    80005e14:	02500a93          	li	s5,37
    switch(c){
    80005e18:	07000b93          	li	s7,112
  consputc('x');
    80005e1c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e1e:	00003b17          	auipc	s6,0x3
    80005e22:	a42b0b13          	addi	s6,s6,-1470 # 80008860 <digits>
    switch(c){
    80005e26:	07300c93          	li	s9,115
    80005e2a:	06400c13          	li	s8,100
    80005e2e:	a82d                	j	80005e68 <printf+0xa8>
    acquire(&pr.lock);
    80005e30:	0023c517          	auipc	a0,0x23c
    80005e34:	f1850513          	addi	a0,a0,-232 # 80241d48 <pr>
    80005e38:	00000097          	auipc	ra,0x0
    80005e3c:	476080e7          	jalr	1142(ra) # 800062ae <acquire>
    80005e40:	bf7d                	j	80005dfe <printf+0x3e>
    panic("null fmt");
    80005e42:	00003517          	auipc	a0,0x3
    80005e46:	a0650513          	addi	a0,a0,-1530 # 80008848 <syscalls+0x408>
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	f2c080e7          	jalr	-212(ra) # 80005d76 <panic>
      consputc(c);
    80005e52:	00000097          	auipc	ra,0x0
    80005e56:	c60080e7          	jalr	-928(ra) # 80005ab2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e5a:	2985                	addiw	s3,s3,1
    80005e5c:	013a07b3          	add	a5,s4,s3
    80005e60:	0007c503          	lbu	a0,0(a5)
    80005e64:	10050463          	beqz	a0,80005f6c <printf+0x1ac>
    if(c != '%'){
    80005e68:	ff5515e3          	bne	a0,s5,80005e52 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e6c:	2985                	addiw	s3,s3,1
    80005e6e:	013a07b3          	add	a5,s4,s3
    80005e72:	0007c783          	lbu	a5,0(a5)
    80005e76:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e7a:	cbed                	beqz	a5,80005f6c <printf+0x1ac>
    switch(c){
    80005e7c:	05778a63          	beq	a5,s7,80005ed0 <printf+0x110>
    80005e80:	02fbf663          	bgeu	s7,a5,80005eac <printf+0xec>
    80005e84:	09978863          	beq	a5,s9,80005f14 <printf+0x154>
    80005e88:	07800713          	li	a4,120
    80005e8c:	0ce79563          	bne	a5,a4,80005f56 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e90:	f8843783          	ld	a5,-120(s0)
    80005e94:	00878713          	addi	a4,a5,8
    80005e98:	f8e43423          	sd	a4,-120(s0)
    80005e9c:	4605                	li	a2,1
    80005e9e:	85ea                	mv	a1,s10
    80005ea0:	4388                	lw	a0,0(a5)
    80005ea2:	00000097          	auipc	ra,0x0
    80005ea6:	e30080e7          	jalr	-464(ra) # 80005cd2 <printint>
      break;
    80005eaa:	bf45                	j	80005e5a <printf+0x9a>
    switch(c){
    80005eac:	09578f63          	beq	a5,s5,80005f4a <printf+0x18a>
    80005eb0:	0b879363          	bne	a5,s8,80005f56 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005eb4:	f8843783          	ld	a5,-120(s0)
    80005eb8:	00878713          	addi	a4,a5,8
    80005ebc:	f8e43423          	sd	a4,-120(s0)
    80005ec0:	4605                	li	a2,1
    80005ec2:	45a9                	li	a1,10
    80005ec4:	4388                	lw	a0,0(a5)
    80005ec6:	00000097          	auipc	ra,0x0
    80005eca:	e0c080e7          	jalr	-500(ra) # 80005cd2 <printint>
      break;
    80005ece:	b771                	j	80005e5a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ed0:	f8843783          	ld	a5,-120(s0)
    80005ed4:	00878713          	addi	a4,a5,8
    80005ed8:	f8e43423          	sd	a4,-120(s0)
    80005edc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005ee0:	03000513          	li	a0,48
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	bce080e7          	jalr	-1074(ra) # 80005ab2 <consputc>
  consputc('x');
    80005eec:	07800513          	li	a0,120
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	bc2080e7          	jalr	-1086(ra) # 80005ab2 <consputc>
    80005ef8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005efa:	03c95793          	srli	a5,s2,0x3c
    80005efe:	97da                	add	a5,a5,s6
    80005f00:	0007c503          	lbu	a0,0(a5)
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	bae080e7          	jalr	-1106(ra) # 80005ab2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f0c:	0912                	slli	s2,s2,0x4
    80005f0e:	34fd                	addiw	s1,s1,-1
    80005f10:	f4ed                	bnez	s1,80005efa <printf+0x13a>
    80005f12:	b7a1                	j	80005e5a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f14:	f8843783          	ld	a5,-120(s0)
    80005f18:	00878713          	addi	a4,a5,8
    80005f1c:	f8e43423          	sd	a4,-120(s0)
    80005f20:	6384                	ld	s1,0(a5)
    80005f22:	cc89                	beqz	s1,80005f3c <printf+0x17c>
      for(; *s; s++)
    80005f24:	0004c503          	lbu	a0,0(s1)
    80005f28:	d90d                	beqz	a0,80005e5a <printf+0x9a>
        consputc(*s);
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	b88080e7          	jalr	-1144(ra) # 80005ab2 <consputc>
      for(; *s; s++)
    80005f32:	0485                	addi	s1,s1,1
    80005f34:	0004c503          	lbu	a0,0(s1)
    80005f38:	f96d                	bnez	a0,80005f2a <printf+0x16a>
    80005f3a:	b705                	j	80005e5a <printf+0x9a>
        s = "(null)";
    80005f3c:	00003497          	auipc	s1,0x3
    80005f40:	90448493          	addi	s1,s1,-1788 # 80008840 <syscalls+0x400>
      for(; *s; s++)
    80005f44:	02800513          	li	a0,40
    80005f48:	b7cd                	j	80005f2a <printf+0x16a>
      consputc('%');
    80005f4a:	8556                	mv	a0,s5
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	b66080e7          	jalr	-1178(ra) # 80005ab2 <consputc>
      break;
    80005f54:	b719                	j	80005e5a <printf+0x9a>
      consputc('%');
    80005f56:	8556                	mv	a0,s5
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	b5a080e7          	jalr	-1190(ra) # 80005ab2 <consputc>
      consputc(c);
    80005f60:	8526                	mv	a0,s1
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	b50080e7          	jalr	-1200(ra) # 80005ab2 <consputc>
      break;
    80005f6a:	bdc5                	j	80005e5a <printf+0x9a>
  if(locking)
    80005f6c:	020d9163          	bnez	s11,80005f8e <printf+0x1ce>
}
    80005f70:	70e6                	ld	ra,120(sp)
    80005f72:	7446                	ld	s0,112(sp)
    80005f74:	74a6                	ld	s1,104(sp)
    80005f76:	7906                	ld	s2,96(sp)
    80005f78:	69e6                	ld	s3,88(sp)
    80005f7a:	6a46                	ld	s4,80(sp)
    80005f7c:	6aa6                	ld	s5,72(sp)
    80005f7e:	6b06                	ld	s6,64(sp)
    80005f80:	7be2                	ld	s7,56(sp)
    80005f82:	7c42                	ld	s8,48(sp)
    80005f84:	7ca2                	ld	s9,40(sp)
    80005f86:	7d02                	ld	s10,32(sp)
    80005f88:	6de2                	ld	s11,24(sp)
    80005f8a:	6129                	addi	sp,sp,192
    80005f8c:	8082                	ret
    release(&pr.lock);
    80005f8e:	0023c517          	auipc	a0,0x23c
    80005f92:	dba50513          	addi	a0,a0,-582 # 80241d48 <pr>
    80005f96:	00000097          	auipc	ra,0x0
    80005f9a:	3cc080e7          	jalr	972(ra) # 80006362 <release>
}
    80005f9e:	bfc9                	j	80005f70 <printf+0x1b0>

0000000080005fa0 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fa0:	1101                	addi	sp,sp,-32
    80005fa2:	ec06                	sd	ra,24(sp)
    80005fa4:	e822                	sd	s0,16(sp)
    80005fa6:	e426                	sd	s1,8(sp)
    80005fa8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005faa:	0023c497          	auipc	s1,0x23c
    80005fae:	d9e48493          	addi	s1,s1,-610 # 80241d48 <pr>
    80005fb2:	00003597          	auipc	a1,0x3
    80005fb6:	8a658593          	addi	a1,a1,-1882 # 80008858 <syscalls+0x418>
    80005fba:	8526                	mv	a0,s1
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	262080e7          	jalr	610(ra) # 8000621e <initlock>
  pr.locking = 1;
    80005fc4:	4785                	li	a5,1
    80005fc6:	cc9c                	sw	a5,24(s1)
}
    80005fc8:	60e2                	ld	ra,24(sp)
    80005fca:	6442                	ld	s0,16(sp)
    80005fcc:	64a2                	ld	s1,8(sp)
    80005fce:	6105                	addi	sp,sp,32
    80005fd0:	8082                	ret

0000000080005fd2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fd2:	1141                	addi	sp,sp,-16
    80005fd4:	e406                	sd	ra,8(sp)
    80005fd6:	e022                	sd	s0,0(sp)
    80005fd8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fda:	100007b7          	lui	a5,0x10000
    80005fde:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fe2:	f8000713          	li	a4,-128
    80005fe6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fea:	470d                	li	a4,3
    80005fec:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ff0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ff4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ff8:	469d                	li	a3,7
    80005ffa:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ffe:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006002:	00003597          	auipc	a1,0x3
    80006006:	87658593          	addi	a1,a1,-1930 # 80008878 <digits+0x18>
    8000600a:	0023c517          	auipc	a0,0x23c
    8000600e:	d5e50513          	addi	a0,a0,-674 # 80241d68 <uart_tx_lock>
    80006012:	00000097          	auipc	ra,0x0
    80006016:	20c080e7          	jalr	524(ra) # 8000621e <initlock>
}
    8000601a:	60a2                	ld	ra,8(sp)
    8000601c:	6402                	ld	s0,0(sp)
    8000601e:	0141                	addi	sp,sp,16
    80006020:	8082                	ret

0000000080006022 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006022:	1101                	addi	sp,sp,-32
    80006024:	ec06                	sd	ra,24(sp)
    80006026:	e822                	sd	s0,16(sp)
    80006028:	e426                	sd	s1,8(sp)
    8000602a:	1000                	addi	s0,sp,32
    8000602c:	84aa                	mv	s1,a0
  push_off();
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	234080e7          	jalr	564(ra) # 80006262 <push_off>

  if(panicked){
    80006036:	00003797          	auipc	a5,0x3
    8000603a:	8e67a783          	lw	a5,-1818(a5) # 8000891c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000603e:	10000737          	lui	a4,0x10000
  if(panicked){
    80006042:	c391                	beqz	a5,80006046 <uartputc_sync+0x24>
    for(;;)
    80006044:	a001                	j	80006044 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006046:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000604a:	0207f793          	andi	a5,a5,32
    8000604e:	dfe5                	beqz	a5,80006046 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006050:	0ff4f513          	zext.b	a0,s1
    80006054:	100007b7          	lui	a5,0x10000
    80006058:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	2a6080e7          	jalr	678(ra) # 80006302 <pop_off>
}
    80006064:	60e2                	ld	ra,24(sp)
    80006066:	6442                	ld	s0,16(sp)
    80006068:	64a2                	ld	s1,8(sp)
    8000606a:	6105                	addi	sp,sp,32
    8000606c:	8082                	ret

000000008000606e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000606e:	00003797          	auipc	a5,0x3
    80006072:	8b27b783          	ld	a5,-1870(a5) # 80008920 <uart_tx_r>
    80006076:	00003717          	auipc	a4,0x3
    8000607a:	8b273703          	ld	a4,-1870(a4) # 80008928 <uart_tx_w>
    8000607e:	06f70a63          	beq	a4,a5,800060f2 <uartstart+0x84>
{
    80006082:	7139                	addi	sp,sp,-64
    80006084:	fc06                	sd	ra,56(sp)
    80006086:	f822                	sd	s0,48(sp)
    80006088:	f426                	sd	s1,40(sp)
    8000608a:	f04a                	sd	s2,32(sp)
    8000608c:	ec4e                	sd	s3,24(sp)
    8000608e:	e852                	sd	s4,16(sp)
    80006090:	e456                	sd	s5,8(sp)
    80006092:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006094:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006098:	0023ca17          	auipc	s4,0x23c
    8000609c:	cd0a0a13          	addi	s4,s4,-816 # 80241d68 <uart_tx_lock>
    uart_tx_r += 1;
    800060a0:	00003497          	auipc	s1,0x3
    800060a4:	88048493          	addi	s1,s1,-1920 # 80008920 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060a8:	00003997          	auipc	s3,0x3
    800060ac:	88098993          	addi	s3,s3,-1920 # 80008928 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060b0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060b4:	02077713          	andi	a4,a4,32
    800060b8:	c705                	beqz	a4,800060e0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060ba:	01f7f713          	andi	a4,a5,31
    800060be:	9752                	add	a4,a4,s4
    800060c0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800060c4:	0785                	addi	a5,a5,1
    800060c6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060c8:	8526                	mv	a0,s1
    800060ca:	ffffb097          	auipc	ra,0xffffb
    800060ce:	6b4080e7          	jalr	1716(ra) # 8000177e <wakeup>
    
    WriteReg(THR, c);
    800060d2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060d6:	609c                	ld	a5,0(s1)
    800060d8:	0009b703          	ld	a4,0(s3)
    800060dc:	fcf71ae3          	bne	a4,a5,800060b0 <uartstart+0x42>
  }
}
    800060e0:	70e2                	ld	ra,56(sp)
    800060e2:	7442                	ld	s0,48(sp)
    800060e4:	74a2                	ld	s1,40(sp)
    800060e6:	7902                	ld	s2,32(sp)
    800060e8:	69e2                	ld	s3,24(sp)
    800060ea:	6a42                	ld	s4,16(sp)
    800060ec:	6aa2                	ld	s5,8(sp)
    800060ee:	6121                	addi	sp,sp,64
    800060f0:	8082                	ret
    800060f2:	8082                	ret

00000000800060f4 <uartputc>:
{
    800060f4:	7179                	addi	sp,sp,-48
    800060f6:	f406                	sd	ra,40(sp)
    800060f8:	f022                	sd	s0,32(sp)
    800060fa:	ec26                	sd	s1,24(sp)
    800060fc:	e84a                	sd	s2,16(sp)
    800060fe:	e44e                	sd	s3,8(sp)
    80006100:	e052                	sd	s4,0(sp)
    80006102:	1800                	addi	s0,sp,48
    80006104:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006106:	0023c517          	auipc	a0,0x23c
    8000610a:	c6250513          	addi	a0,a0,-926 # 80241d68 <uart_tx_lock>
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	1a0080e7          	jalr	416(ra) # 800062ae <acquire>
  if(panicked){
    80006116:	00003797          	auipc	a5,0x3
    8000611a:	8067a783          	lw	a5,-2042(a5) # 8000891c <panicked>
    8000611e:	e7c9                	bnez	a5,800061a8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006120:	00003717          	auipc	a4,0x3
    80006124:	80873703          	ld	a4,-2040(a4) # 80008928 <uart_tx_w>
    80006128:	00002797          	auipc	a5,0x2
    8000612c:	7f87b783          	ld	a5,2040(a5) # 80008920 <uart_tx_r>
    80006130:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006134:	0023c997          	auipc	s3,0x23c
    80006138:	c3498993          	addi	s3,s3,-972 # 80241d68 <uart_tx_lock>
    8000613c:	00002497          	auipc	s1,0x2
    80006140:	7e448493          	addi	s1,s1,2020 # 80008920 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006144:	00002917          	auipc	s2,0x2
    80006148:	7e490913          	addi	s2,s2,2020 # 80008928 <uart_tx_w>
    8000614c:	00e79f63          	bne	a5,a4,8000616a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006150:	85ce                	mv	a1,s3
    80006152:	8526                	mv	a0,s1
    80006154:	ffffb097          	auipc	ra,0xffffb
    80006158:	5c6080e7          	jalr	1478(ra) # 8000171a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000615c:	00093703          	ld	a4,0(s2)
    80006160:	609c                	ld	a5,0(s1)
    80006162:	02078793          	addi	a5,a5,32
    80006166:	fee785e3          	beq	a5,a4,80006150 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000616a:	0023c497          	auipc	s1,0x23c
    8000616e:	bfe48493          	addi	s1,s1,-1026 # 80241d68 <uart_tx_lock>
    80006172:	01f77793          	andi	a5,a4,31
    80006176:	97a6                	add	a5,a5,s1
    80006178:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000617c:	0705                	addi	a4,a4,1
    8000617e:	00002797          	auipc	a5,0x2
    80006182:	7ae7b523          	sd	a4,1962(a5) # 80008928 <uart_tx_w>
  uartstart();
    80006186:	00000097          	auipc	ra,0x0
    8000618a:	ee8080e7          	jalr	-280(ra) # 8000606e <uartstart>
  release(&uart_tx_lock);
    8000618e:	8526                	mv	a0,s1
    80006190:	00000097          	auipc	ra,0x0
    80006194:	1d2080e7          	jalr	466(ra) # 80006362 <release>
}
    80006198:	70a2                	ld	ra,40(sp)
    8000619a:	7402                	ld	s0,32(sp)
    8000619c:	64e2                	ld	s1,24(sp)
    8000619e:	6942                	ld	s2,16(sp)
    800061a0:	69a2                	ld	s3,8(sp)
    800061a2:	6a02                	ld	s4,0(sp)
    800061a4:	6145                	addi	sp,sp,48
    800061a6:	8082                	ret
    for(;;)
    800061a8:	a001                	j	800061a8 <uartputc+0xb4>

00000000800061aa <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061aa:	1141                	addi	sp,sp,-16
    800061ac:	e422                	sd	s0,8(sp)
    800061ae:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061b0:	100007b7          	lui	a5,0x10000
    800061b4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061b8:	8b85                	andi	a5,a5,1
    800061ba:	cb81                	beqz	a5,800061ca <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800061bc:	100007b7          	lui	a5,0x10000
    800061c0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061c4:	6422                	ld	s0,8(sp)
    800061c6:	0141                	addi	sp,sp,16
    800061c8:	8082                	ret
    return -1;
    800061ca:	557d                	li	a0,-1
    800061cc:	bfe5                	j	800061c4 <uartgetc+0x1a>

00000000800061ce <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800061ce:	1101                	addi	sp,sp,-32
    800061d0:	ec06                	sd	ra,24(sp)
    800061d2:	e822                	sd	s0,16(sp)
    800061d4:	e426                	sd	s1,8(sp)
    800061d6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061d8:	54fd                	li	s1,-1
    800061da:	a029                	j	800061e4 <uartintr+0x16>
      break;
    consoleintr(c);
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	918080e7          	jalr	-1768(ra) # 80005af4 <consoleintr>
    int c = uartgetc();
    800061e4:	00000097          	auipc	ra,0x0
    800061e8:	fc6080e7          	jalr	-58(ra) # 800061aa <uartgetc>
    if(c == -1)
    800061ec:	fe9518e3          	bne	a0,s1,800061dc <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061f0:	0023c497          	auipc	s1,0x23c
    800061f4:	b7848493          	addi	s1,s1,-1160 # 80241d68 <uart_tx_lock>
    800061f8:	8526                	mv	a0,s1
    800061fa:	00000097          	auipc	ra,0x0
    800061fe:	0b4080e7          	jalr	180(ra) # 800062ae <acquire>
  uartstart();
    80006202:	00000097          	auipc	ra,0x0
    80006206:	e6c080e7          	jalr	-404(ra) # 8000606e <uartstart>
  release(&uart_tx_lock);
    8000620a:	8526                	mv	a0,s1
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	156080e7          	jalr	342(ra) # 80006362 <release>
}
    80006214:	60e2                	ld	ra,24(sp)
    80006216:	6442                	ld	s0,16(sp)
    80006218:	64a2                	ld	s1,8(sp)
    8000621a:	6105                	addi	sp,sp,32
    8000621c:	8082                	ret

000000008000621e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000621e:	1141                	addi	sp,sp,-16
    80006220:	e422                	sd	s0,8(sp)
    80006222:	0800                	addi	s0,sp,16
  lk->name = name;
    80006224:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006226:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000622a:	00053823          	sd	zero,16(a0)
}
    8000622e:	6422                	ld	s0,8(sp)
    80006230:	0141                	addi	sp,sp,16
    80006232:	8082                	ret

0000000080006234 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006234:	411c                	lw	a5,0(a0)
    80006236:	e399                	bnez	a5,8000623c <holding+0x8>
    80006238:	4501                	li	a0,0
  return r;
}
    8000623a:	8082                	ret
{
    8000623c:	1101                	addi	sp,sp,-32
    8000623e:	ec06                	sd	ra,24(sp)
    80006240:	e822                	sd	s0,16(sp)
    80006242:	e426                	sd	s1,8(sp)
    80006244:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006246:	6904                	ld	s1,16(a0)
    80006248:	ffffb097          	auipc	ra,0xffffb
    8000624c:	e0e080e7          	jalr	-498(ra) # 80001056 <mycpu>
    80006250:	40a48533          	sub	a0,s1,a0
    80006254:	00153513          	seqz	a0,a0
}
    80006258:	60e2                	ld	ra,24(sp)
    8000625a:	6442                	ld	s0,16(sp)
    8000625c:	64a2                	ld	s1,8(sp)
    8000625e:	6105                	addi	sp,sp,32
    80006260:	8082                	ret

0000000080006262 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus"
    8000626c:	100024f3          	csrr	s1,sstatus
    80006270:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006274:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0"
    80006276:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000627a:	ffffb097          	auipc	ra,0xffffb
    8000627e:	ddc080e7          	jalr	-548(ra) # 80001056 <mycpu>
    80006282:	5d3c                	lw	a5,120(a0)
    80006284:	cf89                	beqz	a5,8000629e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006286:	ffffb097          	auipc	ra,0xffffb
    8000628a:	dd0080e7          	jalr	-560(ra) # 80001056 <mycpu>
    8000628e:	5d3c                	lw	a5,120(a0)
    80006290:	2785                	addiw	a5,a5,1
    80006292:	dd3c                	sw	a5,120(a0)
}
    80006294:	60e2                	ld	ra,24(sp)
    80006296:	6442                	ld	s0,16(sp)
    80006298:	64a2                	ld	s1,8(sp)
    8000629a:	6105                	addi	sp,sp,32
    8000629c:	8082                	ret
    mycpu()->intena = old;
    8000629e:	ffffb097          	auipc	ra,0xffffb
    800062a2:	db8080e7          	jalr	-584(ra) # 80001056 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062a6:	8085                	srli	s1,s1,0x1
    800062a8:	8885                	andi	s1,s1,1
    800062aa:	dd64                	sw	s1,124(a0)
    800062ac:	bfe9                	j	80006286 <push_off+0x24>

00000000800062ae <acquire>:
{
    800062ae:	1101                	addi	sp,sp,-32
    800062b0:	ec06                	sd	ra,24(sp)
    800062b2:	e822                	sd	s0,16(sp)
    800062b4:	e426                	sd	s1,8(sp)
    800062b6:	1000                	addi	s0,sp,32
    800062b8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	fa8080e7          	jalr	-88(ra) # 80006262 <push_off>
  if(holding(lk))
    800062c2:	8526                	mv	a0,s1
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	f70080e7          	jalr	-144(ra) # 80006234 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062cc:	4705                	li	a4,1
  if(holding(lk))
    800062ce:	e115                	bnez	a0,800062f2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062d0:	87ba                	mv	a5,a4
    800062d2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062d6:	2781                	sext.w	a5,a5
    800062d8:	ffe5                	bnez	a5,800062d0 <acquire+0x22>
  __sync_synchronize();
    800062da:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	d78080e7          	jalr	-648(ra) # 80001056 <mycpu>
    800062e6:	e888                	sd	a0,16(s1)
}
    800062e8:	60e2                	ld	ra,24(sp)
    800062ea:	6442                	ld	s0,16(sp)
    800062ec:	64a2                	ld	s1,8(sp)
    800062ee:	6105                	addi	sp,sp,32
    800062f0:	8082                	ret
    panic("acquire");
    800062f2:	00002517          	auipc	a0,0x2
    800062f6:	58e50513          	addi	a0,a0,1422 # 80008880 <digits+0x20>
    800062fa:	00000097          	auipc	ra,0x0
    800062fe:	a7c080e7          	jalr	-1412(ra) # 80005d76 <panic>

0000000080006302 <pop_off>:

void
pop_off(void)
{
    80006302:	1141                	addi	sp,sp,-16
    80006304:	e406                	sd	ra,8(sp)
    80006306:	e022                	sd	s0,0(sp)
    80006308:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000630a:	ffffb097          	auipc	ra,0xffffb
    8000630e:	d4c080e7          	jalr	-692(ra) # 80001056 <mycpu>
  asm volatile("csrr %0, sstatus"
    80006312:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006316:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006318:	e78d                	bnez	a5,80006342 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000631a:	5d3c                	lw	a5,120(a0)
    8000631c:	02f05b63          	blez	a5,80006352 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006320:	37fd                	addiw	a5,a5,-1
    80006322:	0007871b          	sext.w	a4,a5
    80006326:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006328:	eb09                	bnez	a4,8000633a <pop_off+0x38>
    8000632a:	5d7c                	lw	a5,124(a0)
    8000632c:	c799                	beqz	a5,8000633a <pop_off+0x38>
  asm volatile("csrr %0, sstatus"
    8000632e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006332:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    80006336:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000633a:	60a2                	ld	ra,8(sp)
    8000633c:	6402                	ld	s0,0(sp)
    8000633e:	0141                	addi	sp,sp,16
    80006340:	8082                	ret
    panic("pop_off - interruptible");
    80006342:	00002517          	auipc	a0,0x2
    80006346:	54650513          	addi	a0,a0,1350 # 80008888 <digits+0x28>
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	a2c080e7          	jalr	-1492(ra) # 80005d76 <panic>
    panic("pop_off");
    80006352:	00002517          	auipc	a0,0x2
    80006356:	54e50513          	addi	a0,a0,1358 # 800088a0 <digits+0x40>
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	a1c080e7          	jalr	-1508(ra) # 80005d76 <panic>

0000000080006362 <release>:
{
    80006362:	1101                	addi	sp,sp,-32
    80006364:	ec06                	sd	ra,24(sp)
    80006366:	e822                	sd	s0,16(sp)
    80006368:	e426                	sd	s1,8(sp)
    8000636a:	1000                	addi	s0,sp,32
    8000636c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	ec6080e7          	jalr	-314(ra) # 80006234 <holding>
    80006376:	c115                	beqz	a0,8000639a <release+0x38>
  lk->cpu = 0;
    80006378:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000637c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006380:	0f50000f          	fence	iorw,ow
    80006384:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	f7a080e7          	jalr	-134(ra) # 80006302 <pop_off>
}
    80006390:	60e2                	ld	ra,24(sp)
    80006392:	6442                	ld	s0,16(sp)
    80006394:	64a2                	ld	s1,8(sp)
    80006396:	6105                	addi	sp,sp,32
    80006398:	8082                	ret
    panic("release");
    8000639a:	00002517          	auipc	a0,0x2
    8000639e:	50e50513          	addi	a0,a0,1294 # 800088a8 <digits+0x48>
    800063a2:	00000097          	auipc	ra,0x0
    800063a6:	9d4080e7          	jalr	-1580(ra) # 80005d76 <panic>
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
