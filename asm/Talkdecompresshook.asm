.gba
.open "rom/output.gba",0x08000000


;Decompression Relocation
.thumb


;For reference on what registers go to what on arrival of function!
;Take care to write down the addresses to make sense of this.
;r0 = The address the game would normally decompress too
;r1 = The rom address where the normally compressed text is found.



;To prevent the game from switching to the default address
.org 0x080037A2
	ldr r0, [r4, #0x10]
.org 0x080037B4
	nop

;To change the game's decompression and reading addresses!
.org 0x08BF1EB0
Relocated_Func:
;New Code
	push	{r1-r3,r7} ;saves our addresses for later!
	ldr     r1, [FirstTalkLZ77Buffer] ;This loads in the original address for the game's in-level text!
	cmp     r1, r0
	beq		TalkRedirect ;If the addresses match, it redirects to the TalkRedirect jump!
	b		UpdateReadingAddress
TalkRedirect:
	ldr     r0, [NewTalkLZ77Buffer] ;This replaces the decompression location for the in-level text!
	b		UpdateReadingAddress
UpdateReadingAddress: ;This is the final piece before the the intended decompression function kicks in! This puts in our intended reading address for the reading function to use!
	str		r0, [r4, #0x10]
	b 		 BacktoOG
BacktoOG:
	pop		   {r1-r3,r7}
    push       {r4,r5,r6,lr}					   ;080005a0 70 b5      
    add        r4, r0, #0x0                          ;080005a2 04 1c      
    add        r6, r1, #0x0                          ;080005a4 0e 1c      
    ldr        r1, [r6, #0x0]                        ;080005a6 31 68      
    mov        r0, #0xf0                            ;080005a8 f0 20      
    and        r0, r1                               ;080005aa 08 40      
    lsr        r0, r0, #0x4                          ;080005ac 00 09      
    cmp        r0, #0x8                             ;080005ae 08 28      
    bne        LAB_080005ba                        ;080005b0 03 d1      
    mov        r0, #0xf                             ;080005b2 0f 20      
    and        r1, r0                               ;080005b4 01 40      
    add        r0, r1, #0x0                          ;080005b6 08 1c      
    add        r0, #0x8                             ;080005b8 08 30      
LAB_080005ba:                                                          
    ldr        r1, [PTR_DAT_080005fc]               ;080005ba 10 49      
    lsl        r0, r0, #0x2                          ;080005bc 80 00      
    add        r0, r0, r1                            ;080005be 40 18      
    ldr        r5, [r0, #0x0];=>DAT_0814defc         ;080005c0 05 68      
    cmp        r5, #0x0                             ;080005c2 00 2d      
    beq        LAB_0800060c                        ;080005c4 22 d0      
    mov        r3, #0x0                             ;080005c6 00 23      
    mov        r0, #0xfa                            ;080005c8 fa 20      
    lsl        r0, r0, #0x18                         ;080005ca 00 06      
    add        r1, r4, r0                            ;080005cc 21 18      
    ldr        r0, [DAT_08000600]                   ;080005ce 0c 48      
    cmp        r1, r0                               ;080005d0 81 42      
    bhi        LAB_080005d6                        ;080005d2 00 d8      
    mov        r3, #0x1                             ;080005d4 01 23      
LAB_080005d6:                                                          
    mov        r0, #0xfb                            ;080005d6 fb 20      
    lsl        r0, r0, #0x18                         ;080005d8 00 06      
    add        r1, r4, r0                            ;080005da 21 18      
    ldr        r0, [DAT_08000604]                   ;080005dc 09 48      
    cmp        r1, r0                               ;080005de 81 42      
    bhi        LAB_080005e4                        ;080005e0 00 d8      
    mov        r3, #0x1                             ;080005e2 01 23      
LAB_080005e4:                                                          
    ldr        r2, [PTR_DAT_08000608]               ;080005e4 08 4a      
    lsl        r0, r3, #0x2                          ;080005e6 98 00      
    lsl        r1, r5, #0x3                          ;080005e8 e9 00      
    add        r0, r0, r1                            ;080005ea 40 18      
    add        r0, r0, r2                            ;080005ec 80 18      
    ldr        r2, [r0, #0x0];=>DAT_0814ded0          ;080005ee 02 68      
    add        r0, r6, #0x0                          ;080005f0 30 1c      
    add        r1, r4, #0x0                          ;080005f2 21 1c      
    bl         BranchJump_Link                     ;080005f4 42 f1 de fe
; -- Flow Override: CALL_RETURN (CALL_TERMINATOR)                     
    mov        r0, #0x1                             ;080005f8 01 20      
    b          LAB_0800060e                        ;080005fa 08 e0
.align 4	
PTR_DAT_080005fc:                                                      
    .word 0x0814DEFC                        ;080005fc fc de 14 08
.align 4
DAT_08000600:                                                          
    .word 0x00017FFF                           ;08000600 ff 7f 01 00
.align 4
DAT_08000604:                                                           
    .word 0x000003FF                          ;08000604 ff 03 00 00
.align 4
PTR_DAT_08000608:                                                       
	.word 0x0814DECC                        ;08000608 cc de 14 08
LAB_0800060c:                                                           
    mov        r0, #0x0                             ;0800060c 00 20      
LAB_0800060e:                                                           
    pop        {r4,r5,r6}                          ;0800060e 70 bc      
    pop        {r1}                                ;08000610 02 bc      
    bx         r1									;08000612 08 47      
.align 4
BranchJump_Link:
	bx 			r2
;RamBuffers (Essentially, this is where the text data would normally be sent to and read from. These are here for compare related commands) DO NOT TOUCH!
;=======================================
.align 4
FirstTalkLZ77Buffer:
	.word 0x0200D350

;New RamBuffers (These will replace the original addresses If needed) You may modify them if needed!
.align 4
NewTalkLZ77Buffer:	;This is where the Conversation texts will now be sent to and read from!
	.word 0x02020000

;
;Pointer	
.org 0x080037C4
	.word Relocated_Func + 1
 
.close
