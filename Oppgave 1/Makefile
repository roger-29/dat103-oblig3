all:
	nasm -f elf32 oppgave1.asm -o oppgave1.o
	ld -m elf_i386 oppgave1.o -o oppgave1

macos:
	nasm -f macho32 oppgave1.asm -o oppgave1.o
	ld -arch i386 -macosx_version_min 10.6 -no_pie -e _start oppgave1.o -o oppgave1

clean:
