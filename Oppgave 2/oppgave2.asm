; Inndata Programmet leser inn to sifre med ett eller flere mellomrom
; Utdata programmet skriver ut summen av de to sifrene,
; forutsatt at summen er mindre enn 10

; Konstanter
    cr equ 13 ; Vognretur
    lf equ 10 ; Linjeskift
    SYS_EXIT  equ 1
    SYS_READ  equ 3
    SYS_WRITE equ 4
    STDIN     equ 0
    STDOUT    equ 1
    STDERR    equ 2

; Datasegment
section .bss
    siffer resb 4

; Datasegment
section .data
    meld db "Skriv to ensifrede tall skilt med mellomrom.",cr,lf
        db "Summen av tallene maa vaere mindre enn 10.",cr,lf
    meldlen equ $ - meld
    feilmeld db cr,lf, "Skriv kun sifre!",cr,lf
    feillen equ $ - feilmeld
    crlf db cr,lf
    crlflen equ $ - crlf

; Kodesegment med program
section .text

global _start
_start:
    mov edx,meldlen
    mov ecx,meld
    mov ebx,STDOUT
    mov eax,SYS_WRITE
    int 0x80

    ; Les tall, innlest tall returneres i ecx
    ; Vellykket retur dersom edx=0
    call lessiffer
    cmp edx,0 ; Test om vellykket innlesning
    jne Slutt ; Hopp til avslutning ved feil i innlesning
    mov eax,ecx ; Første tall/siffer lagres i reg eax

    call lessiffer
    ; Les andre tall/siffer
    ; vellykket: edx=0, tall i ecx
    cmp edx,0 ; Test om vellykket innlesning
    jne Slutt
    mov ebx,ecx ; andre tall/siffer lagres i reg ebx

    call nylinje
    add eax,ebx
    call skrivsiffer ; Skriv ut verdi i ecx som ensifret tall
    call nylinje

Slutt:
    mov eax,SYS_EXIT
    mov ebx,0
    int 0x80

; ------------------------------------------------------------------


skrivsiffer:
    ; Skriver ut sifferet lagret i ecx. Ingen sjekk på verdiområdet.
            push eax
            push ebx
            push ecx
            push edx
            call delpaati
            add eax,'0'
            add edx,'0'
            mov [siffer],eax
            mov [siffer+1],edx
            mov ecx,siffer
            mov edx,4
            mov ebx,STDOUT
            mov eax,SYS_WRITE
            int 80h
            pop edx
            pop ecx
            pop ebx
            pop eax
            ret

delpaati:
    mov edx,0h
    mov ecx,0Ah
    div ecx
    ret

; --------------------------------------------------------------------
lessiffer:
    ; Leter forbi alle blanke til neste ikke-blank
    ; Neste ikke-blank returneres i ecx
    push eax
    push ebx
Lokke:
    ; Leser et tegn fra tastaturet
    mov eax,SYS_READ
    mov ebx,STDIN
    mov ecx,siffer
    mov edx,1
    int 0x80
    mov ecx,[siffer]
    cmp ecx,' '
    je Lokke
    cmp ecx,'0' ; Sjekk at tast er i område 0-9
    jb Feil
    cmp ecx,'9'
    ja Feil
    sub ecx,'0' ; Koverter ascii til tall.
    mov edx,0 ; Signaliser vellykket innlesning
    pop ebx
    pop eax
    ret ; Vellykket retur

Feil:
    mov edx,feillen
    mov ecx,feilmeld
    mov ebx,STDERR
    mov eax,SYS_WRITE
    int 0x80
    mov edx,1 ; Signaliser mislykket innlesning av tall
    pop ebx
    pop eax
    ret ; Mislykket retur

; ------------------------------------
; Flytt peker til helt til venstre på neste linje
nylinje:
    push eax
    push ebx
    push ecx
    push edx
    mov edx,crlflen
    mov ecx,crlf
    mov ebx,STDOUT
    mov eax,SYS_WRITE
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; End _start

      
