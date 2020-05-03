		;;	crt0.c
		;;	zx spectrum ram startup code
		;;
		;;	tomaz stih sun may 20 2012
		.module crt0
		.globl _heap
		.globl _cmdline

		.area _HEADER(ABS)
	
		di				; no rom anymore

        ld (_cmdline),hl 
		ld (#store_sp),sp		; store SP
		ld sp,#16384

		;; store all regs
		push af
		push bc
		push de
		push hl
		push ix
		push iy
		ex af, af'
		push af
		exx
		push bc
		push de
		push hl

		call gsinit			; init static vars (sdcc style)

		;; start the os
		call _main			

		;; restore all regs
		pop hl
		pop de
		pop bc
		pop af
		exx
		ex af,af'
		pop iy
		pop ix
		pop hl
		pop de
		pop bc
		pop af

		ld sp,(#store_sp)		; restore original SP
		
		ei				; the rom is back
		or a ; clear carry
		ret	
store_sp:	.word 252
_cmdline:   .word 0

		;;	(linker documentation:) where specific ordering is desired - 
		;;	the first linker input file should have the area definitions 
		;;	in the desired order
		.area _HOME
		.area _CODE
	        .area _GSINIT
	        .area _GSFINAL	
		.area _DATA
	        .area _BSS
	        .area _HEAP

		;;	this area contains data initialization code -
		;;	unlike gnu toolchain which generates data, sdcc generates 
		;;	initialization code for every initialized global 
		;;	variable. and it puts this code into _GSINIT area
        	.area _GSINIT
gsinit:	
        	.area _GSFINAL
        	ret

		.area _DATA

		.area _BSS

		.area _HEAP
_heap::
