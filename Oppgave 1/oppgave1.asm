; Program som skriver ut Hello World

global _start

; Konstanter

cr equ 13      ; Vognretur
lf equ 10      		; Linjeskift

section .data     	; Datasegment
	melding db 'Hello World!', cr, lf
	lengde equ $ - melding
	
section .text      	; Kodesegment
_start:
	mov eax, 4       	; sys_write
	mov ebx, 1			; stdout
	mov ecx, melding
	mov edx, lengde
	int 0x80

	mov eax, 1          ; sys_exit
	mov ebx, 0			; exit code
	int 0x80
