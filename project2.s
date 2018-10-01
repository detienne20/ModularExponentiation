# project2.s
# Dania Etienne
# CDA 3101 Computer Organization Spring18' Project 2:Transform C code into MIPS Instructions. Problem: Given three positive integers x, k and n (1 < n < 1000), write a program to compute [(x^k) mod n] using fast modular exponentiation.

#Recieved guidance during office hours Monday (2/12/2018) from TA: Lu

.data

#Data Section

getX: .asciiz "Enter the first integer x: "
getK: .asciiz "Enter the second integer k: "
getN: .asciiz "Enter the third integer n: "
Result: .asciiz "The result of x^k mod n = "
errorInput: .asciiz "Input should be a positive interger."
IntX: .word 0
IntK: .word 0
IntN: .word 0
result: .word 0
temp: .word 0

.text

#Code Section

main:

#Get integer X:

li $v0, 4
la $a0, getX #Print message asking for x
syscall

li $v0, 5
syscall
sw $v0, IntX #Stores user input X

bltz $v0, NotPositive # If K  is not positive calls function NotPositive.

#Get integer K:
li $v0, 4
la $a0, getK
syscall

li $v0, 5
syscall
sw $v0, IntK #Stores user input K

bltz $v0, NotPositive # If K  is not positive calls function NotPositive.

#Get integer N:

li $v0, 4
la $a0, getN
syscall

li $v0, 5
syscall
sw $v0, IntN #Stores user input  N

bltz $v0, NotPositive # If K  is not positive calls function NotPositive.

addi $s3, $zero, 1                # s3 = 1
addi $s1, $zero, 2                # s1 = 2


# call the fme function
lw $a0, IntX
lw $a1, IntK
lw $a2, IntN

jal FME
move $t7, $v0  # answer was in v0, now move to t1

# display results
li $v0, 4
la $a0, Result
syscall

li $v0, 1
move $a0, $t7 #Prints Result
syscall

#Terminate Program
li $v0, 10  #syscall code 10 for terminating the program.
syscall

# FME recursive function
.globl FME

FME:

addi $sp, $sp, -16 #Allocate 16 bytes for the 3 variables (*-4):int  x, int k, int n, and the return address.
sw $ra, 12($sp) #save the return address on the stack
sw $a0, 8($sp) # save the variable x on the stack
sw $a1, 4($sp) # save the variable k on the stack
sw $a2, 0($sp)# save the variable n on the stack

# Base Case
li $v0, 1      # Result = 1
li $s2, 1

# If k <=0, it goes to result0
blez $a1, Result0

# recursive step

div $a1, $s1   # k = k /2   s1 is 2
mflo $a1                    # k = k / 2

jal FME

#Load the variables back from the stack.
lw $ra, 12($sp)
lw $a0, 8($sp)
lw $a1, 4($sp)
lw $a2, 0($sp)


div $a1, $s1
mfhi $t1             # $t1 = k % 2
li $s2, 1

bne $t1, $s3, Result1             # if k % 2 != 1, go to Result1

div $a0, $a2
mfhi $s2                    # Result = x % n


Result1:    #Result = (result*temp*temp) % n;

mult $s2, $v0
mflo $s2                     # result = result * temp
mult $s2, $v0                #result is again multiplied by temp.
mflo $s2

div $s2, $a2
mfhi $v0                    # result = result % n



Result0: #result=1;

addi $sp, $sp, 16
add $v0, $zero, $v0
jr $ra #Return


NotPositive:

li $v0,4
la $a0,errorInput #Print error message.
syscall


j main #Return to the top of main so User input can be valid.















