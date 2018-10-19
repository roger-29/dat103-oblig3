section .bss
    a resb 1            ;Plass til variabelen a

section .data
    crlf db 13,10
    crlflen equ $ - crlf

section .text

global _start

_start:
        mov eax,0
        mov [a],eax     ;variabelen a blir tildelt verdien 0.
        mov ecx,0       ;Tellevariabelen i.
        call nylinje    
lokke:  cmp ecx,10      ;Starten av løkken.Sammenligner tellevariabelen med 10 (i < 10)
        jb increment    ;Hvis i < 10 er sann så inkrementeres a
        call decrement  ;Hvis i < 10 er usann så dekrementeres a
lm:     cmp ecx,19      ;Sammenligner tellevariabelen med 20-1 for å sjekke om den er mindre
        inc ecx         ;Tellevariabelen inkrementeres
        jb lokke        ;Løkken itereres på nytt hvis tellevariabelen var mindre enn 
        call print      ;20-1
        call nylinje
        mov eax,1
        mov ebx,0       
        int 0x80        ;Programmet avsluttes

;Inkrementerer variabelen a        
increment:
    mov eax,[a]
    inc eax
    mov [a],eax
    jmp lm  

;Dekrementerer variabelen a
decrement:
    mov eax,[a]
    dec eax
    mov [a],eax
    jmp lm   

;Printer variabelen lagre i a
print:
    push ebp
    mov ebp,esp
    mov edx,1
    mov ecx,[a]
    add ecx,'0'
    mov [a],ecx
    mov ecx,a
    mov ebx,1
    mov eax,4
    int 0x80
    pop ebp
    ret

;Hentet fra oppgave 2
nylinje:
    push eax
    push ebx
    push ecx
    push edx
    mov edx,crlflen
    mov ecx,crlf
    mov ebx,1
    mov eax,4
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

