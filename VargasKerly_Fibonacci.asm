.data
    mensaje_entrada: .asciiz "Ingrese cuántos números de Fibonacci desea (Min 1): "  # Pide al usuario cuántos números de Fibonacci quiere generar
    mensaje_resultado: .asciiz "Serie Fibonacci: "  # Mensaje para indicar que la serie Fibonacci se va a mostrar
    mensaje_suma: .asciiz "\nSuma de la serie: "  # Mensaje para mostrar la suma de la serie
    mensaje_error: .asciiz "Error: Debe ingresar un número mayor que 0.\n"  # Mensaje de error si el número ingresado no es válido

.text
main:
    # Primero, pedimos cuántos números de Fibonacci generar
valida_entrada:
    li $v0, 4  # Preparamos para imprimir un mensaje
    la $a0, mensaje_entrada  # Cargamos el mensaje en $a0
    syscall  # Llamamos a la syscall para imprimir el mensaje

    li $v0, 5   # Preparamos para leer un número
    syscall  # Leemos el número ingresado por el usuario
    move $t0, $v0  # Guardamos el número ingresado en $t0

    # Comprobamos que el número ingresado sea mayor que 0
    blez $t0, error  # Si el número es menor o igual a 0, saltamos al manejo de error

    j iniciar_fibonacci  # Si la entrada es válida, continuamos a generar la serie Fibonacci

error:
    li $v0, 4  # Preparamos para imprimir el mensaje de error
    la $a0, mensaje_error  # Cargamos el mensaje de error en $a0
    syscall  # Llamamos a la syscall para mostrar el error
    j valida_entrada  # Vuelve a pedir la cantidad de números Fibonacci

iniciar_fibonacci:
    li $t1, 0    # F(0) = 0, inicializamos el primer número de Fibonacci
    li $t2, 1    # F(1) = 1, inicializamos el segundo número de Fibonacci
    li $t3, 0    # Inicializamos el contador de términos generados

    # Inicializamos los registros para la suma de la serie
    li $t4, 0    # Parte baja de la suma (32 bits)
    li $t5, 0    # Parte alta de la suma (32 bits)

    # Imprimimos el mensaje de inicio de la serie
    li $v0, 4
    la $a0, mensaje_resultado
    syscall

loop_fib:
    beq $t3, $t0, fin  # Si ya hemos generado la cantidad de términos solicitados, terminamos

    # Imprimimos el número Fibonacci actual
    li $v0, 1
    move $a0, $t1  # Cargamos el número Fibonacci actual en $a0
    syscall  # Llamamos a la syscall para imprimir el número

    # Imprimimos un espacio entre los números
    li $v0, 11
    li $a0, 32  # Cargamos el valor ASCII del espacio
    syscall  # Llamamos a la syscall para imprimir el espacio

    # Acumulamos la suma de la serie usando doble precisión
    add $t4, $t4, $t1  # Sumamos el número actual a la parte baja de la suma
    slt $t6, $t4, $t1  # Verificamos si hubo un desbordamiento en la parte baja
    add $t5, $t5, $t6  # Si hubo desbordamiento, sumamos 1 a la parte alta de la suma

    # Calculamos el siguiente número de Fibonacci
    add $t7, $t1, $t2  # Calculamos F(n+1) = F(n) + F(n-1)
    move $t1, $t2  # El siguiente número de Fibonacci es el anterior
    move $t2, $t7  # El número actual se convierte en el siguiente

    addi $t3, $t3, 1  # Incrementamos el contador de términos generados
    j loop_fib  # Volvemos al inicio del bucle para generar el siguiente número

fin:
    # Mostramos el mensaje de la suma total
    li $v0, 4
    la $a0, mensaje_suma
    syscall  # Imprimimos el mensaje de la suma

    # Imprimimos la parte alta de la suma, si es diferente de 0
    bnez $t5, imprimir_parte_alta  # Si la parte alta no es 0, imprimimosla
    j imprimir_parte_baja  # Si no hay parte alta, solo imprimimos la parte baja

imprimir_parte_alta:
    li $v0, 1
    move $a0, $t5  # Colocamos la parte alta de la suma en $a0
    syscall  # Llamamos a la syscall para imprimir la parte alta

    li $v0, 11
    li $a0, 32  # Cargamos el valor ASCII de un espacio
    syscall  # Imprimimos un espacio entre la parte alta y baja de la suma

imprimir_parte_baja:
    li $v0, 1
    move $a0, $t4  # Colocamos la parte baja de la suma en $a0
    syscall  # Llamamos a la syscall para imprimir la parte baja

    # Terminamos el programa
    li $v0, 10  # Preparamos la syscall para salir
    syscall  # Llamamos a la syscall para finalizar
