#include <asm/desc.h>
// #include "types.h"

void my_store_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY
// </STUDENT FILL>

    asm volatile ("SIDT %0;"
    :"m"(idtr) // maybe the "m" is a bug
    );


}

void my_load_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY

// <STUDENT FILL>
    asm volatile ("LIDT %0;"
    :"m"(idtr) // maybe the "m" is a bug
    );

}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
// <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY
// </STUDENT FILL>

    unsigned short adr_lower_16 = addr & 0xFFFF;
    gate->offset_low = adr_lower_16;

    unsigned long shift_left_16_adr = addr >> 16;
    unsigned short adr_middle_16 = shift_left_16_adr & 0xFFFF;
    gate->offset_middle = adr_middle_16;

    unsigned long shift_left_32_adr = addr >> 32;
    unsigned int  adr_higher_32 = shift_left_32_adr & 0xFFFFFFFF;
    gate->offset_high = adr_higher_32;

}

unsigned long my_get_gate_offset(gate_desc *gate) {
// <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY
// </STUDENT FILL>

    unsigned long adr_middle_16_l = gate->offset_middle;
    unsigned long adr_higher_32_l = gate->offset_high;

    unsigned long offset =gate->offset_low + (adr_middle_16_l << 16) + (adr_middle_16_l << 32);
    return offset;

}
