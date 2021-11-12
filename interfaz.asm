.data
titulo: .asciiz "Máquina Expendedora de productos\n"
codigo: .asciiz "\nIngrese el código del producto:\n"
dinero: .asciiz "\nIngrese el dinero:\n"
fileName: .asciiz "codigos.txt"
fileWords: .space 1024
.text
#imprimir titulo
li $v0, 4
la $a0, titulo
syscall

#
li $v0,13           	# open_file syscall code = 13
    	la $a0,fileName     	# get the file name
    	li $a1,0           	# file flag = read (0)
    	syscall
    	move $s0,$v0        	# save the file descriptor. $s0 = file
	
	#read the file
	li $v0, 14		# read_file syscall code = 14
	move $a0,$s0		# file descriptor
	la $a1,fileWords  	# The buffer that holds the string of the WHOLE file
	la $a2,1024		# hardcoded buffer length
	syscall
	
	# print whats in the file
	li $v0, 4		# read_string syscall code = 4
	la $a0,fileWords
	syscall
	
	#Close the file
    	li $v0, 16         		# close_file syscall code
    	move $a0,$s0      		# file descriptor to close
    	syscall

#imprimir mensaje de input
li $v0, 4
la $a0, codigo
syscall

#Leer entero
li $v0, 5
syscall

move $t1, $v0

#imprimir mensaje de input
li $v0, 4
la $a0, dinero
syscall

#Leer entero
li $v0, 5
syscall

move $t2, $v0

































# funciones





