# ***************************************
# Name: Scarlett Kadan
# Email: dkadan@hawk.iit.edu
# Course: CS 350
# Assignment: Project 1 - MIPS Hamming Code Encoder & Decoder
#
# Description of Program Purpose: Allows the user to encode or decode a 32-bit number using Hamming Codes
# ***************************************

# - Variables -------------------------------------------------------------------------------------
# The add number is the number of bytes to add to the address to obtain the message in bare mode
.data 0x10000000
    # Welcome messages
    newline: .ascii "\n"
    .align 4 # add 0
    welcome1: .asciiz "Hamming Code Encoder & Decoder \n"
    .align 4 # add 16
    welcome2: .asciiz "By: Scarlett Kadan \n"
    .align 4 # add 64

    # Menu prompts
    prompt1: .asciiz "To encode, type: 'E' or 'e' \n"
    .align 4 # add 96
    prompt2: .asciiz "To decode, type: 'D' or 'd' \n"
    .align 4 # add 128
    prompt3: .asciiz "To terminate, type: 'T' or 't' \n"
    .align 4 # add 160
    prompt4: .asciiz "Select: "
    .align 4 # add 208

    # Encoding prompts
    encode1: .asciiz "Enter an 11-bit number: "
    .align 4 # add 224
    encode2: .asciiz "The encoded number is: "
    .align 4 # add 256

    # Decoding prompts
    decode1: .asciiz "Enter a 16-bit number: "
    .align 4 # add 288
    decode2: .asciiz "Unvalidated data: "
    .align 4 # add 320
    decode3: .asciiz "Validated data: "
    .align 4 # add 352
    decode4: .asciiz "The encoded codeword is valid. \n"
    .align 4 # add 384
    decode5: .asciiz "The encoded codeword has 1 error. \n"
    .align 4 # add 432
    decode6: .asciiz "The encoded codeword has 2 errors. \n"
    .align 4 # add 480

    # Parity check prompts
    parity1: .asciiz "P1: "
    .align 4 # add 528
    parity2: .asciiz "P2: "
    .align 4 # add 544
    parity3: .asciiz "P4: "
    .align 4 # add 560
    parity4: .asciiz "P8: "
    .align 4 # add 576
    parity5: .asciiz "PT: "
    .align 4 # add 592
    parity6: .asciiz "Hamming Syndrome: "
    .align 4 # add 608
    parity7: .asciiz "Parity Check: PASSED \n"
    .align 4 # add 640
    parity8: .asciiz "Parity Check: FAILED \n"
    .align 4 # add 672

    # Terminate
    terminate: .asciiz "Stopping...\n"
    .align 4 # add 704

    # Storage
    tempStore1: .space 4
    .align 4 # add 720
    tempStore2: .space 4
    .align 4 # add 724
    tempStore3: .space 4
    .align 4 # add 728

.text
.globl main

# - Code ------------------------------------------------------------------------------------------

# Starts the program and calls the menu function
main: 
    # Print: welcome1
    lui $a0, 4096
    ori $a0, $a0, 16
    ori $v0, $zero, 4
    syscall

    # Print: welcome2
    lui $a0, 4096
    ori $a0, $a0, 64
    ori $v0, $zero, 4
    syscall

    # Print: newline
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall
    
    # Jump: menu
    or $0, $0, $0
    j menu


# Prints the menu and calls the appropriate function
menu:
    # Print: prompt1
    lui $a0, 4096
    ori $a0, $a0, 96
    ori $v0, $zero, 4
    syscall

    # Print: prompt2
    lui $a0, 4096
    ori $a0, $a0, 128
    ori $v0, $zero, 4
    syscall

    # Print: prompt3
    lui $a0, 4096
    ori $a0, $a0, 160
    ori $v0, $zero, 4
    syscall

    # Print: prompt4
    lui $a0, 4096
    ori $a0, $a0, 208
    ori $v0, $zero, 4
    syscall

    # Read: $v0 = 12
    ori $v0, $zero, 12
    or $0, $0, $0
    syscall
    or $0, $0, $0
    add $s0, $zero, $v0

    # Print: newline
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall
    syscall 
    add $v0, $zero, $s0

    # If: $v0 == 'E' or 'e'
    add $s0, $zero, 69
    or $0, $0, $0
    beq $v0, $s0, encode
    add $s0, $zero, 101
    or $0, $0, $0
    beq $v0, $s0, encode

    # If: $v0 == 'D' or 'd'
    add $s0, $zero, 68
    or $0, $0, $0
    beq $v0, $s0, decode
    add $s0, $zero, 100
    or $0, $0, $0
    beq $v0, $s0, decode

    # If: $v0 == 'T' or 't'
    add $s0, $zero, 84
    or $0, $0, $0
    beq $v0, $s0, end
    add $s0, $zero, 116
    or $0, $0, $0
    beq $v0, $s0, end

    # Else: Invalid input
    or $0, $0, $0
    j menu


encode:
    # Print: encode1
    lui $a0, 0x1000
    addiu $a0, $a0, 224
    addiu $v0, $zero, 4
    syscall

    # Read: String
    lui $a0, 0x1000
    addiu $a0, $a0, 720
    addiu $a1, $zero, 12
    addiu $v0, $zero, 8
    syscall

    # Convert string to binary ---> $t1
    lui $a0, 0x1000
    addiu $a0, $a0, 720
    addiu $t1, $zero, 0
    jal stringToBinary
    or $0, $0, $0

    # Parity Check
    addi $t4, $zero, 11
    jal parityCheck
    or $0, $0, $0

    # Print: newline
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: parity1
    lui $a0, 0x1000
    addiu $a0, $a0, 528
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s4
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall
 
    # Print: parity2
    lui $a0, 0x1000
    addiu $a0, $a0, 544
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s5
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: parity3
    lui $a0, 0x1000
    addiu $a0, $a0, 560
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s6
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: parity4
    lui $a0, 0x1000
    addiu $a0, $a0, 576
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s7
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: parity5
    lui $a0, 0x1000
    addiu $a0, $a0, 592
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s3
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Replace: P0
    add $t0, $zero, $s3
    add $v0, $zero, $t1
    addi $v1, $zero, 0
    jal replaceBit
    or $0, $0, $0
    add $t1, $zero, $t0

    # Replace: P1
    add $t0, $zero, $s4
    add $v0, $zero, $t1
    addi $v1, $zero, 1
    jal replaceBit
    or $0, $0, $0
    add $t1, $zero, $t0
    
    # Replace: P2
    add $t0, $zero, $s5
    add $v0, $zero, $t1
    addi $v1, $zero, 2
    jal replaceBit
    or $0, $0, $0
    add $t1, $zero, $t0

    # Replace: P4
    add $t0, $zero, $s6
    add $v0, $zero, $t1
    addi $v1, $zero, 4
    jal replaceBit
    or $0, $0, $0
    add $t1, $zero, $t0

    # Replace: P8
    add $t0, $zero, $s7
    add $v0, $zero, $t1
    addi $v1, $zero, 8
    jal replaceBit
    or $0, $0, $0
    add $t1, $zero, $t0

    # Print: encode2
    lui $a0, 0x1000
    addiu $a0, $a0, 256
    addiu $v0, $zero, 4
    syscall

    # Print: printDecimalAsBinary
    add $v1, $zero, $t1
    jal printDecimalAsBinary
    or $0, $0, $0

    # Jump: menu
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall
    syscall
    or $0, $0, $0
    j menu


decode:
    # Print: decode1
    lui $a0, 0x1000
    ori $a0, $a0, 288
    ori $v0, $zero, 4
    syscall

    # Read: String
    lui $a0, 0x1000
    addiu $a0, $a0, 720
    addiu $a1, $zero, 17
    addiu $v0, $zero, 8
    syscall

    # Convert string to binary ---> $t1
    lui $a0, 0x1000
    addiu $a0, $a0, 720
    addiu $t1, $zero, 0
    jal decodeStringToBinary
    or $0, $0, $0

    # Print: newline
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: decode2
    lui $a0, 0x1000
    addiu $a0, $a0, 320
    addiu $v0, $zero, 4
    syscall

    # Print: printDecimalAsBinary
    add $v0, $zero, $t1
    jal extractData
    or $0, $0, $0
    jal printDecimalAsBinary
    or $0, $0, $0


    # Parity Check
    addi $t4, $zero, 16
    jal parityCheck
    or $0, $0, $0

    # Print: newline
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: parity1
    lui $a0, 0x1000
    addiu $a0, $a0, 528
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s4
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall
 
    # Print: parity2
    lui $a0, 0x1000
    addiu $a0, $a0, 544
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s5
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: parity3
    lui $a0, 0x1000
    addiu $a0, $a0, 560
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s6
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: parity4
    lui $a0, 0x1000
    addiu $a0, $a0, 576
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s7
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: parity5
    lui $a0, 0x1000
    addiu $a0, $a0, 592
    addiu $v0, $zero, 4
    syscall
    add $a0, $zero, $s3
    addiu $v0, $zero, 1
    syscall
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Print: parity6
    lui $a0, 0x1000
    addiu $a0, $a0, 608
    addiu $v0, $zero, 4
    syscall
    
    # Print: Hammings Syndrome
    jal hammingSyndrome
    or $0, $0, $0
    add $s2, $zero, $t0
    add $a0, $zero, $t0
    addiu $v0, $zero, 1
    syscall

    # Print: newline
    lui $a0, 4096
    ori $v0, $zero, 4
    syscall

    # Error Correction
    add $t0, $zero, $t1
    jal correct
    or $0, $0, $0

    # Jump: menu
    lui $a0, 0x1000
    ori $v0, $zero, 4
    syscall
    syscall
    or $0, $0, $0
    j menu

    
end:
    # Print: terminate
    lui $a0, 0x1000
    ori $a0, $a0, 704
    ori $v0, $zero, 4
    syscall

    # End
    addiu $v0, $zero, 10
    syscall


# - Helper Functions ------------------------------------------------------------------------------

# Function: stringToBinary
# Argument: $a0 - address of the string
# Result: $t1 - binary number
stringToBinary:
    addiu $t0, $zero, 16

stringToBinary_loop:
    addiu $t2, $zero, 1
    beq $t0, $t2, stringToBinary_parityPlace
    or $0, $0, $0
    addiu $t2, $zero, 2
    beq $t0, $t2, stringToBinary_parityPlace
    or $0, $0, $0
    addiu $t2, $zero, 3
    beq $t0, $t2, stringToBinary_parityPlace
    or $0, $0, $0
    addiu $t2, $zero, 5
    beq $t0, $t2, stringToBinary_parityPlace
    or $0, $0, $0
    addiu $t2, $zero, 9
    beq $t0, $t2, stringToBinary_parityPlace
    or $0, $0, $0

    lb $t2, 0($a0)
    or $0, $0, $0
    beq $t2, $zero, stringToBinary_end
    or $0, $0, $0
    sll $t1, $t1, 1

    addi $t3, $zero, 48
    sub $t2, $t2, $t3
    add $t1, $t1, $t2

    addi $a0, $a0, 1
    addi $t0, $t0, -1
    bne $t0, $zero, stringToBinary_loop
    or $0, $0, $0

stringToBinary_parityPlace:
    sll $t1, $t1, 1
    add $t1, $t1, $zero
    addi $t0, $t0, -1
    j stringToBinary_loop
    or $0, $0, $0

stringToBinary_end:
    jr $ra
    or $0, $0, $0


# Function: decodeStringToBinary
# Argument: $a0 - address of the string
# Result: $t1 - binary number
decodeStringToBinary:
    addiu $t0, $zero, 16

decodeStringToBinary_loop:
    lb $t2, 0($a0)
    or $0, $0, $0
    beq $t2, $zero, decodeStringToBinary_end
    or $0, $0, $0
    sll $t1, $t1, 1

    addi $t3, $zero, 48
    sub $t2, $t2, $t3
    add $t1, $t1, $t2

    addi $a0, $a0, 1
    addi $t0, $t0, -1
    bne $t0, $zero, decodeStringToBinary_loop
    or $0, $0, $0

decodeStringToBinary_end:
    jr $ra
    or $0, $0, $0


# Function: parityCheck
# Argument: $t1 - binary number
#           #t4 - binary number length (11 or 16)
# Result: $s4 - P8
#         $s5 - P4
#         $s6 - P2
#         $s7 - P1
#         $s3 - PT
parityCheck:
    add $a3, $zero, $ra
    andi $s4, $t1, 43690
    andi $s5, $t1, 52428
    andi $s6, $t1, 61680
    andi $s7, $t1, 65280 

    add $v0, $zero, $s4
    jal oneCount
    or $0, $0, $0
    add $s4, $zero, $v1

    add $v0, $zero, $s5
    jal oneCount
    or $0, $0, $0
    add $s5, $zero, $v1

    add $v0, $zero, $s6
    jal oneCount
    or $0, $0, $0
    add $s6, $zero, $v1

    add $v0, $zero, $s7
    jal oneCount
    or $0, $0, $0
    add $s7, $zero, $v1

    add $s3, $zero, $t1

    addi $t5, $zero, 16
    beq $t4, $t5, parityCheck_end
    or $0, $0, $0

    sll $s3, $s3, 1
    add $s3, $s3, $s4
    sll $s3, $s3, 1
    add $s3, $s3, $s5
    sll $s3, $s3, 1
    add $s3, $s3, $s6
    sll $s3, $s3, 1
    add $s3, $s3, $s7

parityCheck_end:
    add $v0, $zero, $s3
    jal oneCount
    or $0, $0, $0
    add $s3, $zero, $v1

    add $ra, $zero, $a3
    add $a3, $zero, $zero
    jr $ra
    or $0, $0, $0


# Function: oneCount
# Argument: $v0 - binary number
# Result: $v1 - 1 if odd number of 1s, 0 if even number of 1s
oneCount:
    addi $v1, $zero, 0

oneCount_loop:
    andi $t2, $v0, 1
    beq $t2, $zero, oneCount_isZero
    or $0, $0, $0
    addi $v1, $v1, 1

oneCount_isZero:
    srl $v0, $v0, 1
    beq $v0, $zero, oneCount_determine
    or $0, $0, $0
    j oneCount_loop
    or $0, $0, $0

oneCount_determine:
    andi $t0, $v1, 1
    and $v1, $zero, $zero
    beq $t0, $zero, oneCount_end
    or $0, $0, $0
    addi $v1, $zero, 1

oneCount_end:
    jr $ra
    or $0, $0, $0


# Function: replaceBit
# Argument: $v0 - number to modify
#           $v1 - position of bit to modify (0 to end of number)
#           $t0 - new value for position (1 or 0)
# Result: $t0 - modified number
replaceBit:
    bne $t0, $zero, replaceBit_setOne
    or $0, $0, $0
    j replaceBit_setZero
    or $0, $0, $0

replaceBit_setOne:
    addi $t3, $zero, 1
    sll $t3, $t3, $v1
    or $t0, $v0, $t3
    j replaceBit_end
    or $0, $0, $0

replaceBit_setZero:
    addi $t3, $zero, 1
    sll $t3, $t3, $v1
    nor $t3, $zero, $t3
    and $t0, $v0, $t3

replaceBit_end:
    jr $ra
    or $0, $0, $0


# Function: printDecimalAsBinary
# Argument: $v1 - number to print
# Result: Binary number printed to console
printDecimalAsBinary:
    addiu $t6, $zero , 15

printDecimalAsBinary_loop:
    srl $t2, $v1, $t6
    andi $t2, $t2, 1

    addiu $v0, $zero, 1  
    add $a0, $t2, $zero  
    syscall              
    addi $t6, $t6, -1

    bgez $t6, printDecimalAsBinary_loop

printDecimalAsBinary_end:
    jr $ra
    or $0, $0, $0


# Function: hammingSyndrome
# Argument: $s4 - P1
#           $s5 - P2
#           $s6 - P4
#           $s7 - P8
# Result: $t0 - Hamming Syndrome
hammingSyndrome:
    add $t0, $zero, $s4
    sll $t0, $t0, 1
    add $t0, $t0, $s5
    sll $t0, $t0, 1
    add $t0, $t0, $s6
    sll $t0, $t0, 1
    add $t0, $t0, $s7

    jr $ra
    or $0, $0, $0


# Function: correct
# Argument: $s2 - Hamming Syndrome
#           $s3 - PT
#           $s4 - P1
#           $s5 - P2
#           $s6 - P4
#           $s7 - P8
#           $t0 - binary number
correct:
    add $a3, $zero, $ra

    bne $s3, $zero, correct_oneError
    or $0, $0, $0
    bne $s2, $zero, correct_twoError
    or $0, $0, $0

correct_passed:
    # Print: parity7
    lui $a0, 0x1000
    addiu $a0, $a0, 640
    addiu $v0, $zero, 4
    syscall

    # Print: decode4
    lui $a0, 0x1000
    addiu $a0, $a0, 384
    addiu $v0, $zero, 4
    syscall

    # Print: decode 3
    lui $a0, 0x1000
    addiu $a0, $a0, 352
    addiu $v0, $zero, 4
    syscall

    # Print: extractData
    add $v0, $zero, $t0
    jal extractData
    or $0, $0, $0
    add $v0, $zero, $v1
    jal printDecimalAsBinary
    or $0, $0, $0

    j correct_end
    or $0, $0, $0

correct_oneError:
    # Print: parity8
    lui $a0, 0x1000
    addiu $a0, $a0, 672
    addiu $v0, $zero, 4
    syscall

    # Print: decode5
    lui $a0, 0x1000
    addiu $a0, $a0, 432
    addiu $v0, $zero, 4
    syscall

    # Print: decode 3
    lui $a0, 0x1000
    addiu $a0, $a0, 352
    addiu $v0, $zero, 4
    syscall

    # Switch Bit
    add $v0, $zero, $t0
    add $v1, $zero, $s2
    jal switchBit
    or $0, $0, $0

    # Print: extractData
    add $v0, $zero, $t0
    jal extractData
    or $0, $0, $0
    add $v0, $zero, $v1
    jal printDecimalAsBinary
    or $0, $0, $0

    j correct_end
    or $0, $0, $0

correct_twoError:
    # Print: parity8
    lui $a0, 0x1000
    addiu $a0, $a0, 672
    addiu $v0, $zero, 4
    syscall

    # Print: decode6
    lui $a0, 0x1000
    addiu $a0, $a0, 480
    addiu $v0, $zero, 4
    syscall

    # Print: decode 3
    lui $a0, 0x1000
    addiu $a0, $a0, 352
    addiu $v0, $zero, 4
    syscall

    # Print: the number -1
    addi $t0, $zero, -1
    add $a0, $zero, $t0
    addiu $v0, $zero, 1
    syscall


correct_end:
    add $ra, $zero, $a3
    add $a3, $zero, $zero
    jr $ra
    or $0, $0, $0


# Function: switchBit
# Argument: $v0 - number to modify
#           $v1 - position of bit to modify (0 to end of number)
# Result: $t0 - modified number
switchBit:
    addi $t6, $zero, 1
    sll $t6, $t6, $v1
    xor $t0, $v0, $t6
    jr $ra
    or $0, $0, $0

# Function: extractData
# Argument: $v0 - 16-bit encoded number
# Result: $v1 - 11-bit number with parity bits removed
extractData:
    add $v1, $zero, $zero
    addi $t3, $zero, 15

extractData_loop:
    addi $t7, $zero, -1
    beq $t3, $t7, extractData_end
    or $0, $0, $0

    addi $t6, $zero, 0
    beq $t3, $t6, extractData_skip
    or $0, $0, $0
    addi $t6, $zero, 1
    beq $t3, $t6, extractData_skip
    or $0, $0, $0
    addi $t6, $zero, 2
    beq $t3, $t6, extractData_skip
    or $0, $0, $0
    addi $t6, $zero, 4
    beq $t3, $t6, extractData_skip
    or $0, $0, $0
    addi $t6, $zero, 8
    beq $t3, $t6, extractData_skip
    or $0, $0, $0

    srl $t6, $v0, $t3
    andi $t6, $t6, 1
    sll $v1, $v1, 1
    or $v1, $v1, $t6

extractData_skip:
    addi $t3, $t3, -1
    j extractData_loop
    or $0, $0, $0

extractData_end:
    jr $ra
    or $0, $0, $0