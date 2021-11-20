.data
titulo: .asciiz "Máquina Expendedora de productos\n"
productosdisponibles:.asciiz"Producto--Código--Precio \nCocaCola--c--30\nGatorade--g--70\nVive100--v--50 \nBotellaAgua--b--40\n"
dineroaceptable:.asciiz"\n Dinero válido\n\ 25 centavos - (e)\n 50 centavos - (m)\n 1 dolar - (u)\n 10 dolares - (d)"
dinero: .asciiz "\n Ingresa su dinero\n"
producto: .asciiz "\n Ingrese el código del producto que desea: \n"
codigo: .asciiz "\n Ingresa el código:\n"
gracias:.asciiz"\n Gracias por comprar. \n"
dineromaquina:.asciiz"\n  Tu dinero puesto "
salto:.asciiz"\n"
salida:.asciiz"Si no desea comprar otra cosa ponga x para salir"
centavos:.asciiz"centavos "
opcion:.asciiz"\nCocaCola  c\nGatorade  g\nVive100  v\nBotellaAgua  b\n\n"
pocodinero:.asciiz"\n No te alcanza, ingresa más dinero \n"
nobebida:.asciiz"No hay esta bebida en el stock"
cambio:.asciiz"\n Tu cambio es :  "
seguir:.asciiz"\n Desea seguir comprando , si su opcion es si ponga -s, caso contrario -n \n"
pocostock:.asciiz "\n Hay poco stock de este producto \n"

# Valor de los productos 
cocacolava:.word 30
gatoradeva:.word 70
vive100va:.word 50
botellaaguava:.word 40

# Cantidad de productos disponibles en la máquina 
cocacolacant:.word 1
gatoradecant:.word 20
vive100cant:.word 20
botellaaguacant:.word 20


# Valores del dinero que acepta la máquina 
veinticinco:.word 25
cincuenta:.word 50
uno:.word 100
diez:.word 1000

.text
# Cargando valores del dinero de los productos en variables seguras 
lw $s0,cocacolava
lw $s1,gatoradeva
lw $s2,vive100va
lw $s3,botellaaguava

# Este registro representa el dinero del usuario en la máquina
li $s7,0

# Código que se usa para representar a los valores del dinero
li $t0,'e'
li $t1,'m'
li $t2,'u'
li $t3,'d'

#Código que representa a la opción salir
li $t4,'x'

# Cargando valores del dinero de los productos en variables temporales 
lw $t5,botellaaguava
lw $t6,vive100va
lw $t7,gatoradeva
lw $t8,cocacolava


#Imprimir título
li $v0, 4
la $a0, titulo
syscall

#Imprimir menú
li $v0, 4
la $a0, productosdisponibles
syscall

#Imprimir las restricciones de los valores de las monedas 
li $v0, 4
la $a0, dineroaceptable
syscall


# Se le pide al usuario que ingrese las monedas 
pedirdinero:    
	li $v0,4  
       	la $a0,dinero      
       	syscall  
        la $a0,salto  
       	syscall                
       	li $v0, 12                
       	syscall                     
       	move $s4, $v0 
       	## Aquí se ven los códigos de las monedas con letras
       	li $t0,'e'
        li $t1,'m'
        li $t2,'u'
        li $t3,'d' 
       	beq $s4,$t0,usoveinticinco
        beq $s4,$t1,usocincuenta
        beq $s4,$t2,usouno
        beq $s4,$t3,usodiez
       	j pedirdinero

# Usando monedas de veinticinco centavos 
usoveinticinco:
li $v0,4
la $a0,salto
syscall
lw $s5,veinticinco
add $s7,$s7,$s5
li $v0,4
la $a0,dineromaquina 
syscall
la $a0,centavos
syscall
li $v0,1
move $a0,$s7
syscall
li $v0,4
la $a0,salto
syscall
j menuproductos

# Usando monedas de cincuenta centavos 
usocincuenta:
li $v0,4
	la $a0,salto
	syscall
	lw $s5,cincuenta
	add $s7,$s7,$s5
	li $v0,4
	la $a0,dineromaquina
	syscall
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s7
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j menuproductos
	
# # Usando monedas de 100 centavos (un dólar)
usouno:
li $v0,4
	la $a0,salto
	syscall
	lw $s5,uno
	add $s7,$s7,$s5
	li $v0,4
	la $a0,dineromaquina
	syscall
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s7
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j menuproductos
	
# Usando monedas de 1000 centavos (diez dólares)
usodiez:
li $v0,4
	la $a0,salto
	syscall
	lw $s5,diez
	add $s7,$s7,$s5
	li $v0,4
	la $a0,dineromaquina
	syscall
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s7
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j menuproductos

# Aquí se le enseña al usuario los productos con su código y se le pide que ponga el código que desea
menuproductos:
blt $s7,$t8,pedirdinero
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
li $v0, 12                 
syscall
move $s5, $v0 
li $t1,'x'
## Aquí se ven los códigos de los productos con letras
li $t2,'c'
li $t4,'g'
li $t5,'v'
li $t6,'b'
beq $s5,$t1,salir
beq $s5,$t2,cocacola
beq $s5,$t4,gatorade
beq $s5,$t5,vive100p
beq $s5,$t6,botellaaguap
j menuproductos

# En el caso de elegir una botella con agua
botellaaguap:
lw $t5,botellaaguava
blt $s7,$t5,ingresarmasmonedas
lw $t3,botellaaguacant
beq $t3,$zero,nhbotellaagua
j comprarbotellaagua

# Aquí se avisa cuando no hay botellas con agua en la máquina
nhbotellaagua:
jal aviso
j maquina

# Proceso en que la máquina le da la botella con agua al cliente y le devuelve el cambio
comprarbotellaagua:
        sub $t3,$t3,1
	sw $t3,botellaaguacant
	sub $s7,$s7,$s3
	li $v0,4
	la $a0,cambio
	syscall
	li $v0,4
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s7
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j comprar

# En el caso de elegir una bebida Vive 100%	
vive100p:
lw $t6,vive100va
blt $s7,$t6,ingresarmasmonedas
lw $t3,vive100cant
beq $t3,$zero,nhvive100p
j comprarvive100p

# Proceso en que la máquina le da una bebida Vive 100% al cliente y le devuelve el cambio
comprarvive100p:
	sub $t3,$t3,1
	sw $t3,vive100cant
	sub $s7,$s7,$s2
	li $v0,4
	la $a0,cambio
	syscall
	li $v0,4
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s7
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j comprar
	
# Aquí se avisa cuando no hay Vive 100% en la máquina
nhvive100p:
jal aviso
j maquina

# En el caso de elegir un Gatorade
gatorade:
blt $s7,$t7,ingresarmasmonedas
lw $t3,gatoradecant
beq $t3,$zero,nhgatorade
j comprargatorade

# Proceso en que la máquina le da un gatorade al cliente y le devuelve el cambio
comprargatorade:
	sub $t3,$t3,1
	sw $t3,gatoradecant
	sub $s7,$s7,$s1
	li $v0,4
	la $a0,cambio
	syscall
	li $v0,4
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s7
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j comprar

# Aquí se avisa cuando no hay gatorade en la máquina
nhgatorade:
jal aviso
j menuproductos

# En el caso de elegir una coca-cola
cocacola:
blt $s7,$t8,ingresarmasmonedas
lw $t3,cocacolacant
jal stock
beq $t3,$zero,nhcocacola
j comprarcocacola

# Aquí se avisa cuando no hay coca-cola en la máquina		
nhcocacola:
jal aviso
j maquina

# Proceso en que la máquina le da una coca-cola al cliente y le devuelve el cambio
comprarcocacola:
	sub $t3,$t3,1
	sw $t3,cocacolacant
	sub $s7,$s7,$s0
	li $v0,4
	la $a0,cambio
	syscall
	li $v0,4
	la $a0,centavos
	syscall
	li $v0,1
	move $a0,$s7
	syscall
	li $v0,4
	la $a0,salto
	syscall
	j comprar

# Aquí se le pregunta al usuario si desea seguir comprando en la máquina
comprar:
li $v0,4
la $a0,seguir
syscall
li $v0, 12                
syscall                     
move $s6, $v0 
li $t4,'s'
li $t5,'n'
bge $s7,$s0,menuproductos
beq $s6,$t4,pedirdinero
beq $s6,$t5,salir
j comprar


# Aquí miramos si el dinero que tiene ahora el usuario es suficiente para comprar algo en la máquina.
maquina:
	blt $s7,$t5,pedirdinero
	bge $s7,$t5,menuproductos

# Proceso que le pedirá al usuario más monedas cuando este selecciona un producto que tiene un valor menor a su dinero
ingresarmasmonedas:
li $v0,4 
la $a0,pocodinero
syscall
j pedirdinero


## Función que avisa cuando no hay producto en el stock
aviso:
addi $sp, $sp, -4
sw $ra, 0($sp)

li $v0,55
la $a1,4
la $a0,nobebida
syscall

lw $ra,0($sp)
addi $sp, $sp, 4 
jr $ra


## Función que avisa si los productos tienen bajo stock
stock:

addi $sp, $sp, -4
sw $ra, 0($sp)
# Valores que representan el bajo stock de los productos
li $t0,1
li $t1,2 
li $t2,3

sw $t3,cocacolacant
beq $t3,$t0,mensaje1
beq $t3,$t1,mensaje1
beq $t3,$t2,mensaje1

sw $t3,gatoradecant
beq $t3,$t0,mensaje1
beq $t3,$t1,mensaje1
beq $t3,$t2,mensaje1

sw $t3,vive100cant
beq $t3,$t0,mensaje1
beq $t3,$t1,mensaje1
beq $t3,$t2,mensaje1

sw $t3,botellaaguacant
beq $t3,$t0,mensaje1
beq $t3,$t1,mensaje1
beq $t3,$t2,mensaje1

j return
mensaje1:
li $v0,4 
la $a0,pocostock      
syscall  
j return

return:

lw $ra,0($sp)
addi $sp, $sp, 4
 
jr $ra


# Etiqueta que sirve para salir del proceso de compra
salir:
li $v0,55
la $a0,gracias
li $a1,4
syscall
li $v0,10
syscall

