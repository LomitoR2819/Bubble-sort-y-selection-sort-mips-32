.data
array:      .word 5, 3, 8, 1, 2, 7, 4, 6   # Arreglo a ordenar
array_size: .word 8                         # Tamaño del arreglo
space:      .asciiz " "                     # Espacio 
newline:    .asciiz "\n"                    
original: .asciiz "Arreglo original: "  
ordenado:   .asciiz "Arreglo ordenado: "  

.text
.globl main

main:
    # Imprimir arreglo original
    la   $a0, original
    li   $v0, 4
    syscall
    jal  cargarimp

    # Ordenar el arreglo (Selection Sort)
    jal  selection_sort

    # Imprimir arreglo ordenado
    la   $a0, ordenado
    li   $v0, 4
    syscall
    jal  cargarimp

    # Terminar programa
    li   $v0, 10
    syscall

# Subrutina: Selection Sort
selection_sort:
    la   $s0, array         # $s0 = dirección base del arreglo
    lw   $s1, array_size    # $s1 = tamaño del arreglo (n)
    li   $t0, 0             # $t0 = i = 0

outer_loop:
    bge  $t0, $s1, end_sort # Si i >= n, termina
    move $t1, $t0           # $t1 = min_idx = i
    addi $t2, $t0, 1        # $t2 = j = i + 1

inner_loop:
    bge  $t2, $s1, end_inner_loop

    # Cargar array[j]
    sll  $t3, $t2, 2
    add  $t3, $s0, $t3
    lw   $t3, 0($t3)

    # Cargar array[min_idx]
    sll  $t4, $t1, 2
    add  $t4, $s0, $t4
    lw   $t4, 0($t4)

    # Comparar
    bge  $t3, $t4, skip_update_min
    move $t1, $t2           # min_idx = j

skip_update_min:
    addi $t2, $t2, 1        # j++
    j    inner_loop

end_inner_loop:
    # Intercambiar si i != min_idx
    beq  $t0, $t1, skip_swap

    # Cargar array[i]
    sll  $t3, $t0, 2
    add  $t3, $s0, $t3
    lw   $t5, 0($t3)

    # Cargar array[min_idx]
    sll  $t4, $t1, 2
    add  $t4, $s0, $t4
    lw   $t6, 0($t4)

    # Swap
    sw   $t6, 0($t3)
    sw   $t5, 0($t4)

skip_swap:
    addi $t0, $t0, 1        # i++
    j    outer_loop

end_sort:
    jr   $ra                # Retornar de la subrutina

# Subrutina: Imprimir arreglo
cargarimp:
    la   $s0, array         # Dirección base del arreglo
    lw   $s1, array_size    # Tamaño del arreglo
    li   $t0, 0             # Índice i = 0

imprimir:
    bge  $t0, $s1, end_print

    # Cargar array[i]
    sll  $t1, $t0, 2
    add  $t1, $s0, $t1
    lw   $a0, 0($t1)

    # Imprimir array[i]
    li   $v0, 1
    syscall

    # Imprimir espacio
    la   $a0, space
    li   $v0, 4
    syscall

    addi $t0, $t0, 1        # i++
    j    imprimir

end_print:
    # Imprimir salto de línea
    la   $a0, newline
    li   $v0, 4
    syscall
    jr   $ra                # Retornar