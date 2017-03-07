	//Assignment 1 Brody Jackson (10152939) and Josh Dow (10150588)
	//Program will work per assignment specifications

	//*****************Initial setup**********************
	
.section    .init
.globl     _start

_start:
    b       main
.section .text


	//******************The following section is the start of the program********************
	
main:
    	mov     	sp, #0x8000             // Initializing the stack pointer
	bl		EnableJTAG              // Enable JTAG
	bl		InitUART
	mov r8, #0 				//Number of stars used for squares
	mov r6, #0 				//Number of starts used for rectangles
	mov r4, #0 				//Number of starts used for triangles
	mov r12, #0 				//total number of stars used
        ldr r0, =string0			//load string to print into r0 (creator names)
        mov r1, #40				//print 40 characters
        bl WriteStringUART			//call write string
	

	//*******************The following section will print initial messages to the user************************
	
Userask:
        ldr r0, =newLine			//load a new line string into r0 
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call write string
        ldr r0, =strAsk				//load string to give message to user
        mov r1, #96				//print 96 characters 
	bl WriteStringUART			//call write string
	ldr r0, =strCh				//load string to ask user what their choice is
	mov r1, #38				//print 38 characters
	bl WriteStringUART                      //call write string
getInp:
        ldr r0, =newLine			//load a new line string into r0 
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call write string
	ldr r0, =Buffer				//The buffer which will store user input. user input will be stored in terms of bytes using ascii	
	mov r1, #256				//read 256 bytes 
	bl ReadLineUART                         //call to readline
        cmp r0, #2                              //compare length of input to 2
        bgt inperr                              //error in input; Too many characters
        cmp r0, #1                              //compare length of input to 1
        blt inperr      		        //error in input; 0 input characters
	ldr r0, =Buffer				//load the address of the buffer into r0 
	ldrb r5, [r0]                           //load the first character in the buffer into r5
	ldrb r7, [r0,#1] 			//load the second character int the buffer into r7 
	cmp r5, #45				//compare the first character to the ascii value for '-'
	beq c1					//if we read a '-', then branch to c1
	cmp r7, #0 				//compare second character read to 0 
	bne berror				//if the second character is not 0 then branch to error
	cmp r5, #113				//compare the first character to q
	beq bexit				//if the first character is equal to q, then branch to exit
	cmp r5, #49				//compare the first value read to 1
	blt berror				//if the value is less than 1, then branch to error
	cmp r5, #51				//compare the first value read to 3
	bgt berror				//if the value is greater than 3, then branch to error
	b getwid				//if we pass all the error checks, then we branch to get width
c1:
	cmp r7, #49				//compare the second character to ascii value of 1
	beq summary                             //branch to the summary
        b inperr				//input error; Wrong exit code

	
	//***************The following section is used to get the width entered from the user*********************
	
getwid:
	ldr r0, =shpAsk				//load string to ask to enter width
	mov r1, #59				//print 59 characters
	bl WriteStringUART			//call write string
        ldr r0, =newLine			//load the new line string into r0 
        mov r1, #3				//print 3 characters
        bl WriteStringUART			//print string
	ldr r0, =Buffer				//The buffer which will store user input. user input will be stored interns of bytes using ascii
	mov r1, #256				//read 256 bytes 
	bl ReadLineUART				//call read line
	cmp r0, #1				//compare the number of characters read to 1, if we read more than branch to error
	bne beer				//if the character we read is not 0, then branch to width error 
	
	ldr r0, =Buffer				//load the address of the buffer into r0
	ldrb r9, [r0]				//load the first character we read from the buffer into r9		
	
	cmp r9, #51				//compare the  width value read to 3 
	blt beer				//If less than 3, branch to width error
	cmp r9, #57				//compare  width value read to 9 
	bgt beer				//If greater than 9, branch to width error		
	sub r9, r9, #48				//subtract one from r9 
	cmp r5, #49 				//we can now compare the user choic we read to ascii value 1
	beq square				//if it is equal, then move to square
	cmp r5, #50				//we can now compare the user choic we read to ascii value 2
	beq rectan				//if it is equal, then move to rectangle
	cmp r5, #51				//we can now compare the user choic we read to ascii value 3
	beq triang				//if it is equal, we branch to triangle


	//***************************The following section is used to print all the shapes to the screen for a given width ****************************
	
square:
	mov r10, #0				//move 0 into the loop counter r10
break:	add r10, r10, #1			//increment the loop counter by 1
	cmp r10, r9				//compare the value of the loop counter to the width
	bgt Userask				//once the value of r10 is greater than the width, branch back to user ask
	ldr r0, =newLine			//load the new line string into r0
	mov r1, #3				//print 1 byte
	bl WriteStringUART			//call write string
	mov r11, #0				//move the value of 0 into loop counter stored in r11
break2:	cmp r11, r9				//compare the value of the inner loop counter to width
	beq break				//if the value is equal, then break out of the inner loop 
	ldr r0, =drawShp			//else load the string responsible for drawing '*' into r0
	mov r1, #1				//print 1 byte
	bl WriteStringUART			//print string
        ldr r0, =newSpc				//load the string to print a space
        mov r1, #1				//print  character
        bl WriteStringUART			//call write string
	add r8, r8, #1				//increment the number of stars used in squared by one
	add r11, r11, #1			//increment the inner loop counter by 1
	b break2				//branch back to the top of the inner loop

rectan:
	mov r10, #0				//move 0 into the loop counter r10 
	sub r7, r9, #2				//create a register r7, which represents the length (width - 2)
break3:	add r10, r10, #1			//increment the outer loop counter by one
	cmp r10, r7				//compare the value of the loop counter to length
	bgt Userask				//if the value is greater, than branch back to user ask 
	ldr r0, =newLine			//load the new line string into r0
	mov r1, #3				//print 3 bytes
	bl WriteStringUART			//call write string
	mov r11, #0				//move the value of 0 into loop counter stored in r11
break4:	cmp r11, r9				//compare the value of inner loop counter to width
	beq break3				//if the value is equal, then break out of the inner loop 
	ldr r0, =drawShp			//else load the string responsible for drawing '*' into r0
	mov r1, #1				//print 1 byte
	bl WriteStringUART			//write string
        ldr r0, =newSpc				//load the space string into r0
        mov r1, #1				//print 1 byte
        bl WriteStringUART			//call write line
	add r6, r6, #1				//increment the number of stars used for rectangles by one
	add r11, r11, #1			//increment the inner loop counter by one
	b break4				//branch back to the top of the inner loop
	
triang:
	mov r10, #1				//make r10 the outer loop counter, initialize with 0
	mov r7, r9				//move width into r7
break5:	
	mov r11, #1				//move 0 into another loop counter in r11
break6:
	ldr r0, =newSpc				//move the string that prints a space into r0
	mov r1, #1				//print 1 byte
	bl WriteStringUART			//call write line
	add r11, r11, #1			//increment the loop counter by one
	cmp r11, r7				//compare the number of spaces to r7
	ble break6				//if spaces is less than or equal then branch to break7
break7:
	mov r11, #1                             //move 1 into a new loop counter r11

spacel:
        
breakk7:
	add r11, r11, #1			//increment the loop counter r11 by one
	ldr r0, =drawShp			//load the string responsible for printing '*' into r0
	mov r1, #1				//print 1 byte
	bl WriteStringUART			//call write string
        add r4, r4, #1			        //increment r4 by one
	ldr r0, =newSpc				//load the string respondible for printing spaces into r0
	mov r1, #1				//print 1 byte
	bl WriteStringUART			//call write string	
	cmp r11, r10				//compare the value of inner loop counter to outer loop counter
	ble breakk7				//if less than or equal, branch back up to breakk7
up:
	ldr r0, =newLine			//load the string responsible for a new line into r0
	mov r1, #3				//print 1 byte
	bl WriteStringUART			//call write string
	sub r7, r7, #1				//decrement the value of r7 by one
	add r10, r10, #1			//increment the outer loop counter by one
	cmp r10, r9				//compare the value of the outer loop counter to the width
	ble break5				//if less than or equal, branch back up to break5
	b Userask				//else branch to userask
	

	//***************The following section is used to caluculate and print the total number of stars used for all the shapes*******************
	
summary:					

total:
        ldr r10, =meanpc			//load the string which will be overwritten with an ascii value
        add r12, r6, r4                         //adds number of stars used in triangle and rectangle
	add r12, r12, r8			//adds the number of stars in squares to the total
        ldr r0, =dspTot				//load the string that will print the total number of stars string 
        mov r1, #28				//print 28 bytes
        bl WriteStringUART			//print line
        mov r11, r12				//move the total number of stars into r11
        mov r7, #0				//move 0 into r7
        cmp r11, #0				//compare total star number to 0
        beq zprint				//if there are 0 stars, then move to zero print	
        cmp r11, #10				//compare the inital total number of stars to 10 
        blt ones				//if less than 10, branch to ones
        cmp r11, #100				//compare the initial total number of stars to 100
        blt tens				//if less than 100, branch to tens
        cmp r11, #1000				//compare the initial total number of stars to 1000
        blt hundreds				//if less than 1000 branch to hundreds
      
thousands: 
        sub r11, r11, #1000			//subtract 1000 from the total number of stars
        add r7, r7, #1				//increment the number in the thousands place by one
        cmp r11, #1000 				//compare the new total number to 1000
        bge thousands				//if it is greater than 1000, branch back to thousands
        add r7, #48				//turn the loop counter into an ascii value
        str r7, [r10]				//store this ascii value to the string which will print it
        ldr r0, =meanpc				//load the address of the number into r0 
        mov r1, #1				//print 1 byte
        bl WriteStringUART			//call write string to write the number in the thousands place
        mov r7, #0				//reset the loop counter

hundreds:
        cmp r11, #100				//compare the value of r11 to 100
        blt hz					//if the number is a 0, then skip over loop 
        sub r11, r11, #100			//subtract 100 from remaining total 
        add r7, r7, #1				//increment the number in the hundreds place by one
        cmp r11, #100 				//compare the new total to 100
        bge hundreds				//if still greater than 100,brach back to top of loop 
hz:     add r7, #48				//turn the loop counter into an ascii value
        str r7, [r10]				//store this ascii value to the adress we will print
        ldr r0, =meanpc				//load the string with the ascii value into r0
        mov r1, #1				//print 1 byte
        bl WriteStringUART			//call write string
        mov r7, #0				//reset the loop counter

tens: 
        cmp r11, #10				//compare the value of r11 to 10 
        blt tz					//if the number is a 0, then skip over loop 
        sub r11, r11, #10			//subtract 100 from remaining total
        add r7, r7, #1				//increment the number in the tens place by one
        cmp r11, #10 				//compare the new total to 10 
        bge tens				//if still greater than 10, branch back to top of loop
tz:     add r7, #48				//turn the loop cunter into an ascii value
        str r7, [r10]				//store this ascii value to the adress we will print 
        ldr r0, =meanpc				//load the string with the ascii value into r0 
        mov r1, #1				//print 1 byte
        bl WriteStringUART			//call write string
        mov r7, #0				//reset the loop counter
	
ones:
        cmp r11, #1				//compare the value of r11 to 1 
        blt oz					//if the number is a 0, then skip over loop 
        sub r11, r11, #1			//subtract 1 fromt he remaining total 
        add r7, r7, #1				//increment the number in the ones place by one
        cmp r11, #1				//compare the new total to 10		 
        bge ones    				//if still greater than 1, branch back to top of loop 
oz:     add r7, #48				//turn the loop counter into an ascii value
        str r7, [r10]				//store this ascii value to the address we will print
        ldr r0, =meanpc				//load the string with the ascii value into r0 
        mov r1, #1				//print 1 byte
        bl WriteStringUART			//call write string
        b means					//branch to mean calculation 
zprint:		
        add r11, #48				//turn current loop value into ascii (will be 0) 
        str r11, [r10]				//store this ascii value to the address we will print
        ldr r0, =meanpc				//load the string with the ascii value into r0 
        mov r1, #1				//print 1 byte
        bl WriteStringUART			//call write string
        b means					//branch to mean calculation
	

	//*******************The following section is used to print the mean number of stars used for all the shapes***********************

means:  
        ldr r0, =newLine			//load the string which prints a new line into r0 
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call print string
        mov r10, #10                            //move 10 into r10 
        mov r11, #0				//move 0 into r11
        mul r5, r8, r10				//multiply number of square stars by 10, store in r5
meanss:
        cmp r8, #0				//compare the number of square stars to 0 
        beq mss					//if there were 0 square stars, then skip
        cmp r8, r12				//compare the number of square stars to the total star number
        beq ssall                               //if they are equal, then we need to branch to print 1.0
        sub r5, r5, r12				//subtract the total number of stars from the r5 value
        add r11, r11, #1                        //increment the value of loop counter by one
        cmp r5, r12                             //Compare value of r5 to the total star number
        bge meanss				//if it is still greater, than repeat the loop 
mss:    ldr r0, =dspSQ				//load the string which prints the mean we are calculating
        mov r1, #38				//print 38 btyes
        bl WriteStringUART                      //call print line
        ldr r0, =meanstr                        //load the string which prints 0.
        mov r1, #2				//print 2 bytes
        bl WriteStringUART			//call print line
        add r11, r11, #48			//turn the number of loop for square into an ascii value
        ldr r9, =meanpc				//load the string which will print an ascii value
        str r11, [r9]				//load the ascii value we determined into the string which prints ascii
        ldr r0, =meanpc				//load the ascii value string 
        mov r1, #1				//print one byte
        bl WriteStringUART			//call print line
        ldr r0, =newLine			//load the string which prints a new line
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call print line
        b meanr 				//branch to the rectangle calculation
ssall:
        ldr r0, =dspSQ				//load the string which will print the square mean message
        mov r1, #38				//print 38 bytes
        bl WriteStringUART 			//call print line
        ldr r0, =onestr				//load the string which will print 1.0
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call print line
        ldr r0, =newLine			//load the string which will print a new line
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call print line

meanr:
        mov r11, #0				//reset the loop cunter
        mul r5, r6, r10                         //multiply the number of stars used in rectangles by 10 
meanrr:
        cmp r6, #0				//compare the number of rectangle stars to 0 
        beq mrr					//if they are equal then branch to print 0.0
        cmp r6, r12				//compare r6 to total number of stars
        beq rrall				//if they are equal then branch to print 1.0
        sub r5, r5, r12				//subtract star total from number in r5
        add r11, r11, #1                        //increment the loop counter by one
        cmp r5, r12                             //compare new r5 value to total 
        bge meanrr				//if it is still greater, branch back to top of loop
mrr:    ldr r0, =dspRT				//load message abuout rectangle mean 
        mov r1, #41				//print 41 bytes 
        bl WriteStringUART                      //call print line
        ldr r0, =meanstr                       	//load string which will print 0.0
        mov r1, #2				//print 2 bytes
        bl WriteStringUART			//call print line
        add r11, r11, #48			//turn loop counter into an ascii value
        ldr r9, =meanpc				//load address of where acscii value needs to go
        str r11, [r9]				//store the ascii value to the address
        ldr r0, =meanpc				//add the address of string with ascii value
        mov r1, #1				//print 1  byte
        bl WriteStringUART			//call print line
        ldr r0, =newLine			//load string which will print a new line
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call print lin
        b meant					//branch to mean triangle

rrall:
        ldr r0, =dspRT				//load message about rectangle mean
        mov r1, #41				//print 41 byte	
        bl WriteStringUART 			//call print line
        ldr r0, =onestr				//load the string which prints 1.0
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call print line
        ldr r0, =newLine			//load the string which prints a new line
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call print line
meant: 
        mov r11, #0 				//reset the loop counter
        mul r5, r4, r10                         //Multiply number of stars used for triangle by 10 
meantt:
        cmp r4, #0				//compare the triangle star number to 0 
        beq mtt					//if equal, branch to print 0.0
        cmp r4, r12				//compare the number of stars in triangle to total 
        beq ttall				//if equal branch to print 1.0
        sub r5, r5, r12				//subtract total number of stars from triangle stars
        add r11, r11, #1                        //increment loop counter by one
        cmp r5, r12                             //compare new r5 value to total star number
        bge meantt				//if the value is still greater, than branch back to top of loop 
mtt:    ldr r0, =dspTR				//load message about triangle mean 
        mov r1, #40				//print 40 bytes
        bl WriteStringUART                      //call print line
        ldr r0, =meanstr                        //load string which will print 0.
        mov r1, #2				//print 2 bytes
        bl WriteStringUART			//call print line
        add r11, r11, #48			//turn loop counter into ascii value
        ldr r9, =meanpc				//load address of area that will store ascii value
        str r11, [r9]				//store the acsii value at this address
        ldr r0, =meanpc				//load the string which will print ascii value
        mov r1, #1				//print 1 byte
        bl WriteStringUART			//call print line
        ldr r0, =newLine			//load string which will print a new line
        mov r1, #3				//print 3 bytes
        bl WriteStringUART                      //call print line
        mov r4, #0                              //Resets Triangle count to 0
        mov r6, #0                              //Resets Rectangle count to 0
        mov r8, #0                              //Resets Square count to 0
        mov r12, #0                             //Resets Total count to 0
        b Userask				//branch back up to userAsk
ttall:
        ldr r0, =dspTR				//load message about triangle means
        mov r1, #40				//print 40 characters
        bl WriteStringUART 			//call print line
        ldr r0, =onestr				//load the string which will print 1.0
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call print line
        ldr r0, =newLine			//load the string which will print a new line
        mov r1, #3				//print 3 bytes
        bl WriteStringUART			//call print line
        mov r4, #0                              //Resets Triangle count to 0
        mov r6, #0                              //Resets Rectangle count to 0
        mov r8, #0                              //Resets Square count to 0
        mov r12, #0                             //Resets Total count to 0
        b Userask				//branch back up to useAsk
	

	//*********************The following section will cause the program to exit*************************
	
bexit:
        ldr r0, =trmprg				//load exit string 
        mov r1, #21				//print 21 bytes
        bl WriteStringUART			//call print line
exit:	
	b exit					//exit loop
	


	//********************The following sectin will print various messages if there is input error, then re-promt the user***********************
	
inperr:
        ldr r0, =inErr				//load string which prints input error message
        mov r1, #54				//print 54 bytes
        bl WriteStringUART			//call print line
        b Userask				//re ask user
berror:
        ldr r0, =bndErr				//load string which prints a bound entry error
        mov r1, #72				//print 72 bytes
        bl WriteStringUART			//call print line
        b Userask				//re ask user

beer:
        ldr r0, =bnd2				//load the string which prints width entry error
        mov r1, #54				//print 54 bytes
        bl WriteStringUART			//call print line
        b getwid				//re ask user for width


	//*********************The data section contains string we will use, as well as the buffer that we set up to read input**********************
	
.section .data
string0:
	.ascii "Created By: Josh Dow and Brody Jackson\r\n"
	.align
tot:
        .ascii "\n"
        .align

meanpc:
        .ascii "1000000"
        .align

strAsk:
        .ascii "Please enter the number of the object you wish to draw. Press -1 for summary.\r\nPress q to exit\r\n"
	.align
strCh:
        .ascii "1- Square; 2- Rectangle; 3- Triangle\r\n"
        .align

inErr:
        .ascii "Wrong number format! q is the only allowed character\r\n"
        .align
bndErr:
        .ascii "Invalid number! The number should be between 1 and 3 or -1 for summary\r\n"
        .align
bnd2:
        .ascii "Invalid number! The number should be between 3 and 9\r\n"

shpAsk:
        .ascii "Please enter the width of object. Must be between 3 and 9\r\n"
        .align

drawShp:
        .ascii "*"

newLine:
	.ascii " \r\n"
	.align
newSpc:
	.ascii " "
	.align
meanstr:
        .ascii "0."
        .align
onestr:
        .ascii "1.0"
        .align
dspTot:
        .ascii "Total Number of stars is: "
        .align
dspSQ:
        .ascii "Mean of Stars used to draw Square(s): "
        .align
dspRT:
        .ascii "Mean of Stars used to draw Rectangle(s): "
        .align
dspTR:
        .ascii "Mean of Stars used to draw Triangle(s): "
        .align


trmprg:
        .ascii "Terminating Program\r\n"
        .align

Buffer:			
	.rept 256
	.byte 0
	.endr


