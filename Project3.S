.data
  str1: .asciiz "\nPlease enter an integer:\n"
  str2: .asciiz "Please enter an operator (+, -, *, /):\n"
  addchar: .byte '+'
  subtractchar: .byte '-'
  multchar: .byte '*'
  dividechar: .byte '/'

.text

main:
  # Print 1st string prompt message and read the 1st integer

  li $v0, 4
  la $a0, str1
  syscall

  li, $v0, 5
  syscall
  move $s0, $v0

  #Print the character message prompt
  li $v0, 4
  la $a0, str2
  syscall

  li $v0, 12
  syscall
  move $s2, $v0

  # Print 2nd string prompt message and read the 1st integer

  li $v0, 4
  la $a0, str1
  syscall

  li, $v0, 5
  syscall
  move $s1, $v0

  # loading the arguments and calling the adder function

  move $a0, $s0
  move $a1, $s1

  lb $t0, addchar
  lb $t1, subtractchar
  beq $t0, $s2, LADD
  beq $t1, $s2, LSUB

LSUB:
  nor $t1, $a1, $zero
  ori $t1, $t1, 1
  move $a1, $t1
  move $s3, $a0
  li  $a0, 1
  jal do_add
  move $a1, $v0
  move $a0, $s3
  jal do_add
  move $a0, $v0
  li $v0, 1
  syscall
  j exit




LADD:
  jal do_add
  move $a0, $v0
  li, $v0, 1
  syscall

  # end the program
exit:
  li $v0, 10
  syscall





# Do Add Function
do_add:
  addi $sp, $sp, -12
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  xor $s0, $a0, $a1 #Holding the sum
  and $s1, $a0, $a1 #Holding the carry
  j do_add_loop

do_add_loop:
  beq $s1, $zero, do_add_break
  sll $s1, $s1, 1  #carry = carry<< 1
  xor $t0, $s0, $s1 #temp = sum ^ carry
  and $s1, $s0, $s1 #carry = sum & carry
  move $s0, $t0 # sum = temp
  j do_add_loop

do_add_break:
  move $v0, $s0 # move sum into return value
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  addi $sp, $sp, 12
  jr $ra