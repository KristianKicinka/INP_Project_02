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
	lb r25, login(r21)		;na?ítanie znaku z loginu
	sgei r15,r25,97			;kontrola, ?i sa jedná o valídny znak
	beqz r15,end_loop		;ukon?enie cyklu
	nop

	bnez r1,key_2			;ak sifrujem na zaklade druheho k?ú?a, presko?ím na náveštie key_2
	nop

	addi r25,r25,11			; prirátam k na?ítanému znaku hodnotu na základe prvého šifrovacieho k?ú?a

	sgti r27,r25,122		; kontrola hodnoty, hodnota musí zosta? v množine a-z
	beqz r27,add_to_cypher_1
	nop

	subi r25,r25,26			; korekcia hodnoty pri prekro?ení 122 (z)
	
	add_to_cypher_1:

	sb cipher(r21),r25		; zašifrovaného znaku do pamäti

	addi r1,r1,1			; zmena šifrovacieho k?ú?u
	j bottom
	nop

	key_2:

	subi r25,r25,9			; od?ítanie hodnoty na základe šifrovacieho k?ú?a ?. 2

	slti r27,r25,97			; kontrola hodnoty, hodnota musí zosta? v množine a-z
	beqz r27,add_to_cypher_2
	nop

	addi r25,r25,26			; korekcia hodnoty
	
	add_to_cypher_2:

	sb cipher(r21),r25		; uloženie do pamäti

	subi r1,r1,1

	bottom:

	addi r21,r21,1			; zvýšenie indexu v pamäti
	j loop				; skok na za?iatok cyklu
	nop
	end_loop:
					
	addi r21,r21,1			; po ukon?ení sa ako posledná pridá do zašifrovaného textu nula
	sb cipher(r21),r0

end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
