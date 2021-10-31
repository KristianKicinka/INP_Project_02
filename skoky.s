; Vernamova sifra na architekture DLX
; jmeno prijmeni login

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xkicin02"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani

	
	loop:
	lb r25, login(r21)
	sgei r15,r25,97
	beqz r15,end_loop
	nop
	bnez r1,key_2
	nop

	sb cipher(r21),r25
	addi r1,r1,1

	j bottom
	nop

	key_2:

	subi r1,r1,1
	bottom:

	addi r21,r21,1
	j loop
	nop
	end_loop:
	
	;addi r21,r21,1
	;sb cipher(r21),r0

end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
