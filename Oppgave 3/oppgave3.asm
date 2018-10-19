section .bss
    a resb 1

section .data
    crlf db 13,10
    crlflen equ $ - crlf

section .text

global _start

_start:
    mov [a],byte 0
    mov ecx,20
    call lokke
    call printa

lokke:
    call condition
    cmp ecx,0
    sub ecx,1
    jne lokke

condition:
    cmp ecx,10
    jl increment
    call decrement
 
        
increment:
    lock inc byte [a]
    ret

decrement:
    lock dec byte [a]
    ret

printa:
    mov edx,2
    mov ecx,a
    add ecx,'0'
    mov ebx,1
    mov eax,4
    int 80h
    call nylinje
    mov ebx,0
    mov eax,1
    int 80h

nylinje:
    push eax
    push ebx
    push ecx
    push edx
    mov edx,crlflen
    mov ecx,crlf
    mov ebx,1
    mov eax,4
    int 80h
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

