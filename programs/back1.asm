    lli  r1,0x00
    lhi  r1,0x40
    lli  r2,0x01
    lhi  r2,0x40
    lli  r3,0x02
    lhi  r3,0x40
    lli  r4,0x00
    lhi  r4,0x20 
    lli  r5,0
    lw   r6,(r2)
    bz   r6,-1
    lw   r6,(r3)
    lli  r7,0x0A
    sub  r7,r7,r6
    bz   r7, 6
    sw   r6,(r4)
    lli  r7, 1
    add  r5,r5,r7
    add  r4,r4,r7
    bz   r0,-10
    bz   r5, 7
    lli  r7, 1
    sub  r5,r5,r7
    sub  r4,r4,r7
    lw   r6,(r4)
    sw   r6,(r1)
    bz   r0, -6
    bz   r0, 0
