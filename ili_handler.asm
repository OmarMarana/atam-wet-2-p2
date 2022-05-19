.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
    # Some smart student's code here #######

    
    pushq %r8
    pushq %r9
    xorq %r8, %r8
    xorq %r9, %r9


    movq 16(%rsp), %r8  # r8 = user_rip
    movw (%r8), %r9w  # r9w = the two bytes pointed to by user_rip eg 0x040f

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
    cmpb $0x0f ,%r9b
    cmove %rdx, %rcx # if the LSB is 0x0f then the len of the op is 2
    cmove %r12, %rdi # if the LSB is 0x0f then take the MSB of the op

    # now we have the byte that should be passed to what_to_do() in %rdi. we also have then len of the op in rcx

    pushq %rsi
    pushq %r10
    pushq %r11
    pushq %rax

    pushq %r8
    pushq %rcx

   
    call what_to_do

    
    cmpl $0x0, %eax
    je JUMP_TO_OLD_HANDLER
    movq %rax, %rdi # put rax in rdi incase what_to_do() ret val isnt zero
    
    add $16, %rsp

    popq %rax
    popq %r11
    popq %r10
    popq %rsi
    popq %r12
    add $8, %rsp # dont restore the rdi from the stack
    popq %rdx 
    popq %rcx
    popq %r9
    
    
    movq -80(%rsp), %r8 
    addq -88(%rsp), %r8 # user_rip += ill_op.len()  
    add $16, %rsp
    pushq %r8 # noew rip should have skipped the ill_op and is pointing to the next inst
    movq -8(%rsp), %r8
    iretq

  JUMP_TO_OLD_HANDLER:

    add $16, %rsp

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

    jmp *old_ili_handler

    # ##########################################
    # DONT FORGET TO RESTORE USED REGS EXCEPT FOR RDI
    # ##########################################

