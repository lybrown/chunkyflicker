    icl 'hardware.asm'
    org $80
tmp org *+1
pri org *+1
bak org *+1

    org $2000
    sei
    mva #0 NMIEN
    sta bak
    sta DMACTL
    lda PORTB
    and #$FE
    sta PORTB

    lda:rne VCOUNT
    mwa #nmi NMIVEC
    mva #$C0 NMIEN
    mwa #dlist0 DLISTL
    mva #$22 DMACTL
    mva #$C0 PRIOR
    sta pri

    jmp *

nmi
    sta tmp
    bit NMIST
    bpl vbi
dli
    sta WSYNC
    lda #$0D
    sta VSCROL
    lda #$03
    sta VSCROL
donenmi
    lda tmp
    rti
vbi
    lda #$80
    eor:sta pri
    sta PRIOR
    lda CONSOL
    and #1
    cmp:sta laststart
    scs:inc bak
    lda CONSOL
    and #2
    cmp:sta lastselect
    scs:dec bak
    lda pri
    bpl black
    lda bak
    and #7
    asl @
    sta COLBAK
    jmp donenmi
black
    mva #0 COLBAK
    jmp donenmi

laststart
    dta 1
lastselect
    dta 2


    org $4000
dlist0
    :2 dta $70
    dta $B0
    dta $6F,a(scr0)
    :24 dta $8F,$2F
    dta $F
    dta $41,a(dlist1)
dlist1
    :2 dta $70
    dta $B0
    dta $6F,a(scr1)
    :24 dta $8F,$2F
    dta $F
    dta $41,a(dlist0)

    ift 0
    org $8000
scr0
    :40*52 dta [[#/40]&$0F]*$11
    ;:40*52 dta #&$FF
scr1
    :40*52 dta [[#%40]&$0F]*$11
    ;:40*52 dta [#>>4]&$FF

    els
    org $8000
scr0
scr1 equ *+2000
    icl 'image.asm'

    eif
