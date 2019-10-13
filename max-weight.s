@ BSS section
    .bss
z: .word

@ DATA SECTION
    .data
data_items: .word 0x205a15e3, 0x2000a123, 0x256c8700, 0x295468f2
num: .word 0
weight: .word 0

@ TEXT section
    .text

.global _main

#r1 => points to num
#r7 => stores weight
#r8 => points to weight variable
                
_main:
    LDR r5, =data_items       ;@Initialize the address of data item
    LDR r8, =weight
    LDR r1, =num           
    MOV r2, #0                ;@r2 will iterate through the data_items
    MOV r7, #0                ;@r7 will store the max weight

LOOP1:                                                                 
    CMP r2, #16               ;@check for the length of data_items => 4*4 = 16
    BEQ END                   ;@move to end if last data_items is done
    LDR r3, [r5, r2]          ;@load the data item
    ADD r2, #4                ;@ increment the iterator           
    B CNT_BITS                ;@ branch to count the number of bits in r3

LOOP2:
    LDR r3, [r5, r2]          ;@load the data item again as content or r3 is changed in COUNT
    CMP r4, r7                ;@ compare previous stored weight in r7 with currently calculated weight in r4
    BGT STORE_MAX_BIT         ;@ branch to store the max in r7
    B LOOP1
                
STORE_MAX_BIT:
    MOV r7, r4                ;@ store max weight
    STR r7, [r8]
    STR r3, [r1]
    B LOOP1

CNT_BITS:
    MOV r4, #0                ;@r4 store the weight
    MOV r0, #1
                
COUNT:
    CMP r3, #0                ;@the data item of which num bit needs to be counted
    BEQ LOOP2
    AND r6, r3, r0            ;@ r6 = r3 & 0x01
    MOV r3, r3, LSR #1        ;@ Right shift data to move next bit to
    CMP r6, #0                ;@ compare if LSB is 1 or 0
    ADDNE r4, r4, #1          ;@ if = 1 then increment r4.
    B COUNT

END:
	LDR r1, =num
    LDR r1, [r1, #0]
    LDR r8, =weight
    LDR r8, [r8, #0]
    mov pc, r14
