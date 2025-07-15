.data
array: .word 4, 1, 7, 0, 9
n: .word 5
msg: .asciiz "Arreglo ordenado:\n"
.text
.globl main

main:
        la $a0, array # $a0 = array
        lw $a1, n # $a1 = n
        jal bubble

        # Imprimir mensaje
        li $v0, 4
        la $a0, msg
        syscall

        # Imprimir arreglo ordenado
        la $t0, array 
        lw $t1, n 
        li $t2, 0  
imprimir:
        bge $t2, $t1, fin # Si i >= n, fin
        sll $t3, $t2, 2 # t3 = i*4
        add $t4, $t0, $t3 # t4 = v + [i*4]
        lw $a0, 0($t4) # a0 = v[i]
	
	#imprimir entero
        li $v0, 1                     
        syscall
        
       	#imprimir espacio
        li $v0, 11
        li $a0, 32
        syscall

        addi $t2, $t2, 1
        j imprimir

fin:
        li $v0, 10       
        syscall
        
#Empieza el Bubble Sort

bubble:
        li $t0, 0 # i = 0
        addi $t1, $a1, -1 # n-1

for1:
        bge $t0, $t1, salir
        li $t2, 0 # j = 0
        li $t6, 0 # bandera = 0

        sub $t3, $t1, $t0 # t3 = n-1-i

for2:
        bge $t2, $t3, verificar
        sll $t4, $t2, 2 # t4 = j*4
        add $t5, $a0, $t4 # t5 = v + [j*4]
        lw $t7, 0($t5) # t7 = v[j]
        lw $t8, 4($t5) # t8 = v[j+1]

        bgt $t7, $t8, intercambio # si (v[j]>v[j+1]), ir a intercambio
        addi $t2, $t2, 1 # j++
        j for2 # ir a for 2

intercambio:
        sw $t8, 0($t5) # v[j] = v[j+1]
        sw $t7, 4($t5) # v[j+1] = v[j]
        li $t6, 1 # bandera = 1
        addi $t2, $t2, 1 # j++
        j for2

verificar:
        beq $t6, $zero, salir # si(bandera == 0), ir a salir
        addi $t0, $t0, 1 # i++
        j for1

salir:
        jr $ra
