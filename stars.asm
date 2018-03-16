; #########################################################################
;
;   stars.asm - Assembly file for EECS205 Assignment 1
;      
;   Ryan (Yejun) Jeon, Section 20
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include stars.inc

.DATA

	;; If you need to, you can place global variables here


.CODE


DrawStarField proc
        
	;; Place your code here

      invoke DrawStar, 50, 300
      invoke DrawStar, 177, 120
      invoke DrawStar, 100, 100
      invoke DrawStar, 150, 150
      invoke DrawStar, 250, 320
      invoke DrawStar, 320, 123
      invoke DrawStar, 25, 214
      invoke DrawStar, 330, 205
      invoke DrawStar, 420, 420
      invoke DrawStar, 69, 400
      invoke DrawStar, 13, 200
      invoke DrawStar, 42, 250
      invoke DrawStar, 330, 330
      invoke DrawStar, 220, 220
      invoke DrawStar, 220, 300
      invoke DrawStar, 120, 330
      invoke DrawStar, 600, 440
      invoke DrawStar, 550, 200
      invoke DrawStar, 600, 100
      
                

	ret  			; Careful! Don't remove this line
DrawStarField endp



END
