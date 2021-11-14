.data
titulo: .asciiz "Máquina Expendedora de productos\n"
cost:.asciiz"Producto--Codigo--Precio \nCocaCola--c--30\nGatorade--g--25\nVive100--v--20 \nBotellaAgua--b--15\n"
coins:.asciiz"\n Dinero válido\n\ 25 centavos - (f)\n 50 centavos - (t)\n 1 dolar - (u)\n 10 dolares - (d)"
dinero: .asciiz "\n Ingresa su dinero\n"
producto: .asciiz "\n Ingrese el código del producto que desea: \n"
codigo: .asciiz "\n Ingresa el código:\n"
gracias:.asciiz"\n Gracias por comprar. \n"
dineromaquina:.asciiz"\n  Tu dinero puesto "
salto:.asciiz"\n"
salida:.asciiz"Si no desea comprar otra cosa ponga x para salir"
centavos:.asciiz"centavos "
opcion:.asciiz"\nCocaCola  c\nGatorade  g\nVive100  v\nBotellaAgua  b\n\n"
pocodinero:.asciiz"\n Poco dinero \n"
nodrink:.asciiz"No hay esta bebida en el stock"
cambio:.asciiz"\n Tu cambio es :  "
seguir:.asciiz"\n Desea seguir comprando , si su opcion es si ponga -s, caso contrario -n \n"

# CANTIDAD DE PRODUCTOS
cocacolacant:.word 10
gatoradecant:.word 1
vive100cant:.word 10
botellaaguacant:.word 10

# VALOR DE LOS PRODUCTOS
cocacolava:.word 30
gatoradeva:.word 25
vive100va:.word 20
botellaaguava:.word 15

#VALOR DE DINERO QUE ACEPTA LA MAQUINA
veinticinco:.word 25
cincuenta:.word 50
uno:.word 100
diez:.word 1000

.text
# CARGANDO DATOS EN VARIABLES TEMPORALES Y SSEGURAS
li $s6,0
lw $s0,cocacolava
lw $s1,gatoradeva
lw $s2,vive100va
lw $s3,botellaaguava
lw $t8,cocacolava
lw $t7,gatoradeva
lw $t6,vive100va
lw $t5,botellaaguava

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
li $t2,'u'
li $t3,'d'
li $t4,'x'

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
       	li $t0,'f'
        li $t1,'t'
        li $t2,'u'
        li $t3,'d' 
       	beq $s4,$t0,usoveinticinco
        beq $s4,$t1,usocincuenta
        beq $s4,$t2,usouno
        beq $s4,$t3,usodiez
       	j pedirdinero

# usando monedas de veinticinco
usoveinticinco:
li $v0,4
la $a0,salto
syscall
lw $s5,veinticinco
add $s6,$s6,$s5
li $v0,32
la $a0,500
syscall
li $v0,4
la $a0,dineromaquina # IMPRIMIR L cantidad de usuario
syscall
la $a0,centavos
syscall
li $v0,1
move $a0,$s6
syscall
li $v0,4
la $a0,salto
syscall
j continue

# usando monedas de cincuenta
usocincuenta:
li $v0,4
	la $a0,salto
	syscall
	lw $s5,cincuenta
	add $s6,$s6,$s5
	li $v0,32
	la $a0,500
	syscall
	li $v0,4
	la $a0,dineromaquina
	syscall
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s6
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j continue
	
# usando moneda de un dolar o billete
usouno:
li $v0,4
	la $a0,salto
	syscall
	lw $s5,uno
	add $s6,$s6,$s5
	li $v0,32
	la $a0,500
	syscall
	li $v0,4
	la $a0,dineromaquina
	syscall
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s6
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j continue
	
# usando billete de diez dólares
usodiez:
li $v0,4
	la $a0,salto
	syscall
	lw $s5,diez
	add $s6,$s6,$s5
	li $v0,32
	la $a0,500
	syscall
	li $v0,4
	la $a0,dineromaquina
	syscall
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s6
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j continue


continue:
blt $s6,$t8,pedirdinero
li $v0,4
la $a0,opcion
syscall
li $v0,4
la $a0,salida
syscall
li $v0,4  
la $a0,producto      
syscall  
la $a0,salto  
syscall                
li $v0, 12 #LEER CARACTER                 
syscall
move $s5, $v0 
li $t1,'x'
li $t2,'c'
li $t4,'g'
li $t5,'v'
li $t6,'b'
beq $s5,$t1,salir
beq $s5,$t2,cocacola
beq $s5,$t4,gatorade
beq $s5,$t5,vive100p
beq $s5,$t6,botellaaguap
j continue

botellaaguap:
lw $t5,botellaaguava
blt $s6,$t5,ingresarmasmonedas
lw $t3,botellaaguacant
beq $t3,$zero,nhbotellaagua
j comprarbotellaagua

nhbotellaagua:
jal aviso
j continuedone

comprarbotellaagua:
        sub $t3,$t3,1
	sw $t3,botellaaguacant
	sub $s6,$s6,$s3
	li $v0,4
	la $a0,cambio
	syscall
	li $v0,4
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s6
	syscall
	li $v0,4
	la $a0,salto
	syscall
	li $v0,32
	la $a0,500
	syscall
	j comprar
	
vive100p:
lw $t6,vive100va
blt $s6,$t6,ingresarmasmonedas
lw $t3,vive100cant
beq $t3,$zero,nhvive100p
j comprarvive100p

comprarvive100p:
	sub $t3,$t3,1
	sw $t3,vive100cant
	sub $s6,$s6,$s2
	li $v0,4
	la $a0,cambio
	syscall
	li $v0,4
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s6
	syscall
	li $v0,4
	la $a0,salto
	syscall
	li $v0,32
	la $a0,500
	syscall
	j comprar
	

nhvive100p:
jal aviso
j continuedone

gatorade:
blt $s6,$t7,ingresarmasmonedas
lw $t3,gatoradecant
beq $t3,$zero,nhgatorade
j comprargatorade


comprargatorade:
	sub $t3,$t3,1
	sw $t3,gatoradecant
	sub $s6,$s6,$s1
	li $v0,4
	la $a0,cambio
	syscall
	li $v0,4
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s6
	syscall
	li $v0,4
	la $a0,salto
	syscall
	li $v0,32
	la $a0,500
	syscall
	j comprar
	
nhgatorade:
jal aviso
j continue


cocacola:
blt $s6,$t8,ingresarmasmonedas
lw $t3,cocacolacant
beq $t3,$zero,nhcocacola
j comprarcocacola

comprarcocacola:
	sub $t3,$t3,1
	sw $t3,cocacolacant
	sub $s6,$s6,$s0
	li $v0,4
	la $a0,cambio
	syscall
	li $v0,4
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s6
	syscall
	li $v0,4
	la $a0,salto
	syscall
	li $v0,32
	la $a0,500
	syscall
	j comprar

comprar:
li $v0,4
la $a0,seguir
syscall
li $v0, 12 #LEER CARACTER                 
syscall                     
move $s7, $v0 
li $t4,'s'
li $t5,'n'
bge $s6,$s0,continue
beq $s7,$t4,pedirdinero
beq $s7,$t5,salir
j comprar

		
nhcocacola:
	jal aviso
	j continuedone

continuedone:
	blt $s6,$t5,pedirdinero
	bge $s6,$t5,continue
	
ingresarmasmonedas:
li $v0,4 
la $a0,pocodinero
syscall
j pedirdinero


## funcion que avisa cuando no hay producto en el stock
aviso:
addi $sp, $sp, -4
sw $ra, 0($sp)

li $v0,55
la $a1,4
la $a0,nodrink
syscall

lw $ra,0($sp)
addi $sp, $sp, 4 
jr $ra




salir:
li $v0,55
la $a0,gracias
li $a1,4
syscall
li $v0,10
syscall

