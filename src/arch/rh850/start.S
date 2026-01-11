#define STACK_SIZE  0x1000

.macro LOAD_ADDR    sym, reg
    movhi hi(\sym), r0, \reg
    movea lo(\sym), \reg, \reg
.endm

.section .start, "ax"
.global _start
_start:
    /**
    * Not following any ABI for registers in this boot code.
    * The following registers are however reserved to be passed to main
    * as arguments:
    *     r6 -> CPU ID
    *
    * Register r10 is reserved to hold the CPU ID
    * Register r11 is reserved to hold the master CPU ID
    * Register r12 is reserved to hold the CPU struct size
    * Register r13 is reserved to hold the CPU struct pointer
    * Register r31 is reserved as link pointer when calling a routine
    *
    * The remaining code must use r20-r29 as scratchpad registers in the main 
    * flow and r15-r19 as arguments and return values. r10-r14 are used to hold constants.
    */

.pushsection .data
.align 3
.global primary_hart
primary_hart: .word 0x0
primary_hart_valid: .word 0x0
primary_hart_ready: .word 0x0
.popsection

    /**
     * Save hart id in thread pointer. We assume the compiler does not use tp.
     */
    mov r6, tp

    /* Initialize global_pointer */
	LOAD_ADDR __gp, gp

    LOAD_ADDR primary_hart_valid, r20
    addi 1, r0, r21

hart_loop:
    ldl.w [r20], r22
    cmp r0, r22
    bne skip
    stc.w r21, [r20]
    cmp r0, r21
    be hart_loop

    LOAD_ADDR primary_hart, r20
    st.w r6, 0[r20]

    /* Clear bss */ 
    LOAD_ADDR __bss_start, r20
    LOAD_ADDR __bss_end, r21
    cmp r20, r21
    bnl bss_done

bss_loop:
    st.w r0, 0[r20]
    addi 4, r20, r20
    cmp r20, r21
    bl bss_loop

bss_done:
    /* Set exception vector */
    /* set PSW.EBV and PSW.ID */
    mov 0x8020, r20
    ldsr r20, 5, 0

    /* configure EBASE with exception vector */
    LOAD_ADDR vector_table, r20
    ori 0x2, r20, r20   /* direct vector method */
    ldsr r20, 3, 1

    /* configure INTBP with interrupt vector */
    LOAD_ADDR interrupt_table, r20
    ldsr r20, 4, 1

    LOAD_ADDR primary_hart_ready, r20
    addi 1, r0, r21
    st.w r21, 0[r20]

skip:
    LOAD_ADDR primary_hart_ready, r20

wait:
    ld.w 0[r20], r21
    cmp r0, r21
    be wait

    /* Initialize stack pointer*/
    LOAD_ADDR _stack_base, r20
    addi STACK_SIZE, r0, r21
    add r21, r20
#ifndef SINGLE_CORE
    mul     tp, r21, r22
    add     r21, r20
#endif
    mov r20, sp

    //TODO: other c runtime init (ctors, etc...)
    
    /* Jump to main */
    jarl __init, lp
    br .

