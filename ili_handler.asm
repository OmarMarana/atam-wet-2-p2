.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
    # Some smart student's code here #######

    # according to slide 45 in lec 5 the backing up of regs isnt done here

    /*

    How do I get the ill-inst that caused the interrupt?
      *According to T6 the %rip of the instruction that caused the interrupt is available on the stack.
      Which is the addr of the ill-inst. Therefore, if im able to get (%rip_onstack) it should give me the inst 
      that im looking for(which should be the opcode as they said in the pdf).
      *The question is whether the memory (%rip_onstack) is on the kernel stack or the user stack. Since we are
      on the kernel stack bcus we're in the handler...    

    Maybe after all the stack isnt relevant to the stack type.
      The only thing that matters is the %rip according to lec5 slide 50

    do i have to return scratch registers to their initial value if i use them in here?
      *yes, except for %rdi which should have the ret val of what_to_do in case it isn't 0


    */

    pushq %r8
    pushq %r9
    xorq %r8, %r8
    xorq %r9, %r9


    movq 16(%rsp), %r8  # r8 = user_rip
    movw (%r8), %r9w  # r9w = the two bytes pointed to by user_rip

    # now we have the opcode in r9w and we need to get the MSB

    pushq %rcx # rcx is the len of the opcode
    pushq %rdx
    pushq %rdi
    pushq %r12

    xorq %rdi, %rdi
    xorq %rcx, %rcx
    xorq %rdx, %rdx
    xorq %r12, %r12


    movq %r9, %r12
    shrq $0x8 , %r12
    movb %r9b, %dil 
    movq $0x2, %rdx
    movq $0x1, %rcx
    cmpb %r9b, $0x0F
    cmove %rdx, %rcx # if the LSB is 0x0f then the len of the op is 2
    cmove %r12, %rdi # if the LSB is 0x0f then take the MSB of the op

    # now we have the byte that should be passed to what_to_do() in %rdi. we also have then len of the op in rcx

    pushq %rsi
    pushq %r10
    pushq %r11
    pushq %rax

    pushq %r8
    pushq %rcx

    # the byte is in rdi
    call what_to_do

    popq %rcx
    popq %r8

    ; mov 72(%rsp), %r8
    ; mov 49(%rsp), %rcx



    cmpq $0x0, %rax
    je JUMP_TO_OLD_HANDLER
    movq %rax, %rdi # put rax in rdi incase what_to_do() ret val isnt zero
    
    popq %rax
    popq %r11
    popq %r10
    popq %rsi
    popq %r12
    add $8, %rsp # dont restore the rdi from the stack
    popq %rdx 
    popq %rcx
    popq %r9
    ; popq %r8

    add %rcx, %r8 # user_rip += ill_op.len()
    add $16, %rsp
    pushq %r8 # noew rip should have skipped the ill_op and is pointing to the next inst
    iretq

  JUMP_TO_OLD_HANDLER:
    popq %rax
    popq %r11
    popq %r10
    popq %rsi
    popq %r12
    popq %rdi
    popq %rdx
    popq %rcx
    popq %r9
    popq %r8

    jmp* old_ili_handler



    # ##########################################
    # DONT FORGET TO RESTORE USED REGS EXCEPT FOR RDI
    # ##########################################



    
