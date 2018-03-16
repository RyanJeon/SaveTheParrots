; #########################################################################
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)


	;; If you need to, you can place global variables here
	
.CODE

FixedSin PROC uses ebx ecx ecx edi angle:FXPT

	local negative:DWORD
	
	mov negative, 0 ;This will check if the angle is negative angle (default False)

	mov edx, angle   	;use edx to store the angle

	;in the case where the angle is 0 radian (skip all the process)
	cmp edx, 0
	je BelowPIHALF
	
	;Make the angle positive
	MakePos:
		cmp edx, 0 ;skip if already positive angle
		jge AboveZero
		add edx, TWO_PI
		jmp MakePos 

	; Let's Make angle to fit the givien table's range ( 0 < pi/2)
	; 0 < angle  / Make angle below 2Pi 
	AboveZero:			
		cmp edx, TWO_PI ;skip if angle is already below 2Pi
		jl BelowTWOPI	
		sub edx, TWO_PI 
		jmp AboveZero
	
	; 0 < angle <= 2PI
	BelowTWOPI:			
		cmp edx, PI ;skip if angle already less than PI
		jl BelowPI
		sub edx, PI ;If not subtract PI 
		mov negative, 1 ;Since the angle was in 3rd or 4th quadrant, the result has to be negative
		jmp BelowTWOPI 


	;0 < angle <= PI
	BelowPI:		
		cmp edx, PI_HALF ;If angle is exactly Pi/2
		je PIHALF
		
		cmp edx, PI_HALF ;If angle is In the range of the Table
		jl BelowPIHALF
		
		mov ecx, PI  ;Else (Pi/2 < angle < Pi)
		sub ecx, edx
		mov edx, ecx
		jmp BelowPI

	;Angle = Pi/2
	PIHALF:
		mov eax, 1
		shl eax, 16
		ret ;End here

	;0 < angle < PI/2
	BelowPIHALF:			
		
		;Final Calculation
		mov eax, edx 
		mov edx, PI_INC_RECIP
		imul edx
		
		movzx eax, WORD PTR[SINTAB + edx*2] ;Search in the table
		
		cmp negative, 0 ;If the original angle was third or fourth quadrant
		je Fin
		neg eax ;negate
	Fin:	

	ret			; Don't delete this line!!!
FixedSin ENDP 
	
	
FixedCos PROC angle:FXPT ;;Cos is only Pi/2 ahead Sin value

	mov ebx, PI_HALF
	add angle, ebx
	INVOKE FixedSin, angle

	ret			; Don't delete this line!!!	
FixedCos ENDP	
END
