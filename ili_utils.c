#include <asm/desc.h>
// #include "types.h"

void my_store_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY
// </STUDENT FILL>

    asm volatile ("SIDT %0;"
    :
    :"m"(idtr) // maybe the "m" is a bug
    :"memory"
    );


}

void my_load_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY

// <STUDENT FILL>
    asm volatile ("LIDT %0;"
    :
    :"m"(idtr) // maybe the "m" is a bug
    :"memory"
    );

}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
// <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY
// </STUDENT FILL>

    unsigned short adr_lower_16 =0;
    unsigned long shift_left_16_adr=0;
    unsigned short adr_middle_16 =0;
    unsigned long shift_left_32_adr = 0;
    unsigned int  adr_higher_32  = 0 ;



    adr_lower_16 = addr & 0xFFFF;
    gate->offset_low = adr_lower_16;

    
    shift_left_16_adr = addr >> 16;
    
    adr_middle_16 = shift_left_16_adr & 0xFFFF;
    gate->offset_middle = adr_middle_16;

    shift_left_32_adr = addr >> 32;
    adr_higher_32 = shift_left_32_adr & 0xFFFFFFFF;
    gate->offset_high = adr_higher_32;

}

unsigned long my_get_gate_offset(gate_desc *gate) {
// <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY
// </STUDENT FILL>

    unsigned long adr_middle_16_l = 0;
    unsigned long adr_higher_32_l = 0;
    unsigned long offset  = 0;


    adr_middle_16_l = (unsigned long)gate->offset_middle;
    adr_higher_32_l = (unsigned long)gate->offset_high;

    offset =gate->offset_low + (adr_middle_16_l << 16) + (adr_higher_32_l << 32);
    return offset;

}
