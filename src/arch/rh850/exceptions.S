.balign 0x200
.global vector_table
vector_table:
	br	.

	.balign 0x10
	syncp
	br	_guest_exception	/* SYSERR ; Guest */

	.balign 0x10
	br	_guest_exception,	/* HVTRAP; Guest */

	.balign 0x10
	br	_guest_exception	/* FETRAP ; Guest? */

	.balign 0x10
	br	_guest_exception	/* TRAP0 ; Guest? */

	.balign 0x10
	br	_guest_exception	/* TRAP1 ; Guest? */

	.balign 0x10
	br	_host_exception		/* RIE */

	.balign 0x10
	syncp
	br	_host_exception		/* FPP/FPI */

	.balign 0x10
	br	_host_exception		/* UCPOP */

	/* TODO: Dfferentiate between MIP/MDP guest and hyp exceptions */
	.balign 0x10
	br	_guest_exception	/* MIP/MDP ; Guest */

	.balign 0x10
	br	_host_exception		/* RIE */

	.balign 0x10
	br	_host_exception		/* PIE */

	.balign 0x10
	br	_host_exception		/* MAE */

	.balign 0x10
	br	_host_exception		/* UCPOP */

	.balign 0x10
	syncp
	br	_host_exception,	/* FENMI */

	.balign 0x10
	syncp
	br	_host_exception		/* FEINT */

	/* only used with direct vector method */
	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority0) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority1) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority2) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority3) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority4) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority5) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority6) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority7) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority8) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority9) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority10) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority11) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority12) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority13) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority14) */

	.balign 0x10
	syncp
	br	_Interrupt_EI		/* INTn(priority15) */

/* only used with table reference method */
.balign	0x200
.global interrupt_table
interrupt_table:
	.long	_Interrupt_EI 	/* INT0 */
	.long	_Interrupt_EI 	/* INT1 */
	.long	_Interrupt_EI 	/* INT2 */
	.rept	2048 - 3
	.long	_Interrupt_EI 	/* INTn */
	.endr

_guest_exception: 
	br .

    /*VM_EXIT
    jarl abort, lp
    VM_ENTRY*/

_host_exception:
	br .
	/*br	_host_exception*/

_Interrupt_EI:

	pushsp r1, r30
	
	/* copy int_id to r6 */
	stsr 13, r6, 0	/* EIIC (TODO: FEIC ?) */
	mov 0x7FF, r20
	and r20, r6

    jarl _rh850_irq_handle, lp

	popsp r1, r30

	/* select ret instruction */
	br _select_xxret


/**
 * Execute eiret or feret depending on the exception type
 * and restores r31 from HVSB
 */
_select_xxret:
	stsr 5, r31, 0
	andi 0x80, r31, r31
	cmp r0, r31
	be _ei_ret
	stsr 20, r31, 1
    feret
_ei_ret:
	stsr 20, r31, 1
	eiret
