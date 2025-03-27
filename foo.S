//defive the register addresses of systick so we can refer them by a variable name
.equ systick_csr,   0xE000E010 //control status register
.equ systick_rvr,   0xE000E014 //decrements from reload_value_reg to 0
.equ systick_cvr,   0xE000E018
.equ systick_calib, 0xE000E01c
.equ timeout,       0x00ffffff //systic is a 24 bit counter  so we make all 24 bits 1 
                               //will be placed in rvr


.section .vectors
vector_table:
    .word 0x20001000 //vector table starts at 2 millionth position so we strat our vector table stack at 4 bytes above
    .word reset_handler
    
.org 0x0000003C //go to 0x003c and place the address of systick_handler which is of 4 bytes
    .word systick_handler
    .zero 400

    .section .text
    .align 2
    .type reset_handler, %function

reset_handler:
    mov r5, #0

    ldr r0, =systick_csr
    ldr r1, =systick_rvr
    ldr r2, =systick_cvr
    ldr r3, =timeout

//programming systick
    str r3, [r1] //24 bit 1 is placed onto reload_value_reg
    mov r3, #0x0
    str r3, [r2] //0 bcoz writing anything will set the cvr to 0 and countflg in csr to 0
    mov r3, #0x7 //setting last  3 bits to 1 in csr:[0]->1=counter enabled, [1]->1=counting down to 0 asserts systick exception, [2]->1=processor clock
    str r3, [r0]

    
    b .    
    
    
    .section .text
    .align 2
    .type systick_handler, %function

systick_handler:
    add r5, r5, #1
break_here:
    bx lr 