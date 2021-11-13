.data
titulo: .asciiz "Máquina Expendedora de productos\n"
cost:.asciiz"Producto--Codigo--Precio \nCOKE--c--30\nSPRITE--s--25\nWATER BOTTLE--w--20 \nMANGO DRINK--m--15\n"
coins:.asciiz"\n Dinero válido\n\ 25 centavos - (f)\n 50 centavos - (t)\n 1 dolar - (T)\n 10 dolares - (H)"
dinero: .asciiz "\n Ingresa su dinero\n"
codigo: .asciiz "\n Ingresa el código:\n"
gracias:.asciiz"\nGracias por comprar\n"
dineromaquina:.asciiz"\n  Tu dinero puesto "
salto:.asciiz"\n"
centavos:.asciiz"centavos: "
dolar:.asciiz" dolar: "
dolares: .asciiz" dolares: "
opcion:.asciiz"\nCOKE\t\t-\tc\nSPRITE\t\t-\ts\nWATER BOTTLE\t-\tw\nMANGO DRINK\t-\tm\n\n"

# CANTIDAD DE PRODUCTOS
cokeval:.word 10
spriteval:.word 1
waterval:.word 10
mangoval:.word 10

# VALOR DE LOS PRODUCTOS
cokep:.word 30
spritep:.word 25
waterp:.word 20
mangop:.word 15

#VALOR DE DINERO QUE ACEPTA LA MAQUINA
veinticinco:.word 25
cincuenta:.word 50
uno:.word 100
diez:.word 1000

.text
# CARGANDO DATOS EN VARIABLES TEMPORALES Y SSEGURAS
li $s6,0
lw $s0,cokep
lw $s1,spritep
lw $s2,waterp
lw $s3,mangop
lw $t8,cokep
lw $t7,spritep
lw $t6,waterp
lw $t5,mangop

#imprimir titulo
li $v0, 4
la $a0, titulo
syscall

#imprimir menu
li $v0, 4
la $a0, cost
syscall

#imprimir dinero aceptado
li $v0, 4
la $a0, coins
syscall

# codigo de dinero
li $t0,'f'
li $t1,'t'
li $t2,'T'
li $t3,'H'

# pedir dinero
pedirdinero:    
	li $v0,4  # IMPRIMIR STRING
       	la $a0,dinero      
       	syscall  
        la $a0,salto  
       	syscall                
       	li $v0, 12 #LEER CARACTER                 
       	syscall                     
       	move $s4, $v0  
       	beq $s4,$t0,ce
       ##beq $s4,$t1,c
       	#beq $s4,$t2,c
       #	beq $s4,$t3,c
       	j pedirdinero

ce:
jal dineropuesto
move $s6,$v0
blt $s6,$t8,pedirdinero
j condicion










dineropuesto:
# reservar memoria
addi $sp,$sp,-8
sw $s6,0($sp)
sw $ra,4($sp)
# cuerpo de la funcion
li $v0,4
la $a0,salto
syscall
beq $s4,$t0,veinticinco1
beq $s4,$t1,cincuenta1
beq $s4,$t2,uno1
beq $s4,$t3,diez1

veinticinco1:
lw $s5,veinticinco
j continua

cincuenta1:
lw $s5,cincuenta
j continua

uno1:
lw $s5,uno
j continua

diez1:
lw $s5,diez
j continua

continua:
	add $s6,$s6,$s5
	li $v0,32
	la $a0,500
	syscall
	li $v0,4
	la $a0,dineromaquina # IMPRIMIR L cantidad de usuario
	syscall
	li $v0,1
	move $a0,$s6
	syscall
	li $v0,4
	la $a0,salto
	syscall

#liberar memoria
lw $s6,0($sp)
lw $ra,4($sp)
addi,$sp,$sp,8
jr $ra


condicion:
blt $s6,$t8,pedirdinero
li $v0,4
la $a0,opcion
syscall

