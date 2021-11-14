.data
titulo: .asciiz "Máquina Expendedora de productos\n"
cost:.asciiz"Producto--Codigo--Precio \nCOKE--c--30\nSPRITE--s--25\nWATER BOTTLE--w--20 \nMANGO DRINK--m--15\n"
coins:.asciiz"\n Dinero válido\n\ 25 centavos - (f)\n 50 centavos - (t)\n 1 dolar - (T)\n 10 dolares - (H)"
dinero: .asciiz "\n Ingresa su dinero\n"
producto: .asciiz "\n Ingrese el código del producto que desea: \n"
codigo: .asciiz "\n Ingresa el código:\n"
gracias:.asciiz"\n Gracias por comprar. \n"
dineromaquina:.asciiz"\n  Tu dinero puesto "
salto:.asciiz"\n"
salida:.asciiz"Si no desea comprar otra cosa ponga x para salir"
centavos:.asciiz"centavos "
opcion:.asciiz"\nCOKE\t\t-\tc\nSPRITE\t\t-\ts\nWATER BOTTLE\t-\tw\nMANGO DRINK\t-\tm\n\n"
pocodinero:.asciiz"\n Poco dinero \n"
nodrink:.asciiz"No hay esta bebida en el stock"
cambio:.asciiz"\n Tu cambio es :  "
seguir:.asciiz"\n Desea seguir comprando , si su opcion es si ponga -s, caso contrario -n \n"
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
        li $t2,'T'
        li $t3,'H' 
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
li $t4,'s'
li $t5,'w'
li $t6,'m'
beq $s5,$t1,salir
beq $s5,$t2,cake
beq $s5,$t4,sprite
beq $s5,$t5,waterbottle
beq $s5,$t6,mangodrink
j continue

mangodrink:
lw $t5,mangop
blt $s6,$t5,ingresarmasmonedas
lw $t3,mangoval
beq $t3,$zero,outofmangodrink
j outofmangodrinkdone

outofmangodrink:
li $v0,55
la $a1,4
la $a0,nodrink
syscall
j continuedone

outofmangodrinkdone:
        sub $t3,$t3,1
	sw $t3,mangoval
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
	
waterbottle:
lw $t6,waterp
blt $s6,$t6,ingresarmasmonedas
lw $t3,waterval
beq $t3,$zero,outofwaterbottle
j outofwaterbottleedone

outofwaterbottleedone:
	sub $t3,$t3,1
	sw $t3,waterval
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
	

outofwaterbottle:
li $v0,55
la $a1,4
la $a0,nodrink
syscall
j continuedone

sprite:
blt $s6,$t7,ingresarmasmonedas
lw $t3,spriteval
beq $t3,$zero,outofsprite
j outofspritedone


outofspritedone:
	sub $t3,$t3,1
	sw $t3,spriteval
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
	
outofsprite:
li $v0,55
la $a1,4
la $a0,nodrink
syscall
j continue


cake:
blt $s6,$t8,ingresarmasmonedas
lw $t3,cokeval
beq $t3,$zero,outofcoke
j outofcokedone

outofcokedone:
	sub $t3,$t3,1
	sw $t3,cokeval
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

		
outofcoke:
	li $v0,55
	la $a1,4
	la $a0,nodrink
	syscall
	j continuedone

continuedone:
	blt $s6,$t5,pedirdinero
	bge $s6,$t5,continue
	
ingresarmasmonedas:
li $v0,4 
la $a0,pocodinero
syscall
j pedirdinero


salir:
li $v0,55
la $a0,gracias
li $a1,4
syscall
li $v0,10
syscall

