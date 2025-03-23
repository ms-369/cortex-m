MEMORY
{
    MEM : ORIGIN = 0X0, LENGTH = 0X40000
}

SECTIONS
{
    .text : {
        *(.vectors*)
        *(.text*)
    } > MEM
}