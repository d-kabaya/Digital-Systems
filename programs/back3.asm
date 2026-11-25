    
    ; Initialisation

    li   r1,0x4000  ; Address of Display
    li   r2,0x4001  ; Address of KbdReady
    li   r3,0x4002  ; Address of KbdData
    li   r4,0x2000  ; Address of RAM
    lli  r5,0       ; Length of string
    
    ; Read characters from keyboard
    
read:
    lw   r6,(r2)    ; While KbdReady 
    bz   r6,read    ; is zero, keep polling
    lw   r6,(r3)    ; Read char from keyboard 
    lli  r7,0x0A     
    sub  r7,r7,r6   ; is it 'Enter'?
    bz   r7,print   ; if yes, proceed to printing
    sw   r6,(r4)    ; save the character in RAM
    lli  r7, 1      
    add  r5,r5,r7   ; increment the length of string
    add  r4,r4,r7   ; advance the RAM pointer
    bz   r0,read    ; go to waiting for the next character
print:
    bz   r5, halt   ; if the length of the string is 0, goto halt 
    lli  r7, 1
    sub  r5,r5,r7   ; decrement the length of the string 
    sub  r4,r4,r7   ; move the RAM pointer one address backwards 
    lw   r6,(r4)    ; load the character from RAM
    sw   r6,(r1)    ; print it on the Display
    bz   r0, print  ; go to the start of the printing loop
halt:
    bz   r0, halt   ; loop forever
