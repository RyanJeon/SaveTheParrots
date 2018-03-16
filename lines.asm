; #########################################################################
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA

	;; If you need to, you can place global variables here
	
.CODE
	

;; Don't forget to add the USES the directive here  
;;   Place any registers that you modify (either explicitly or implicitly)
;;   into the USES list so that caller's values can be preserved
	
;;   For example, if your procedure uses only the eax and ebx registers
;;      DrawLine PROC USES eax ebx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD

DrawLine PROC USES eax ebx edx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
	;; Feel free to use local variables...declare them here
	;; For example:
	;; 	LOCAL foo:DWORD, bar:DWORD
	
	;; Place your code here

      LOCAL delta_x:DWORD, delta_y:DWORD, inc_x:DWORD, inc_y:DWORD, curr_x:DWORD, curr_y:DWORD, error:DWORD, prev_error:DWORD

      mov eax, x1
      sub eax, x0

     ;;abs(x1-x0)
      cmp eax, 0  
      jg res
      neg eax
      
res:  mov delta_x, eax ;;assign delta_x

      mov eax, y1
      sub eax, y0
      
      ;;abs(y1-y0)
      cmp eax, 0    
      jg res2
      neg eax
      
res2: mov delta_y, eax ;;assign delta_y


    ;; if (x0 < x1)
      mov eax, x0
      mov ebx, x1
      cmp eax, ebx   
      jge else1   ;;if(x0 >= x1)
      mov inc_x, 1
      jmp res3

    ;;else
else1: mov inc_x, -1 

res3: 

    ;; if (y0 < y1)
      mov eax, y0
      mov ebx, y1
      cmp eax, ebx  
      jge else2   ;;if(y0 >= y1) 
      mov inc_y, 1
      jmp res4

   ;;else
else2: mov inc_y, -1

res4:

    ;;if (delta_x > delta_y)
     mov eax, delta_x
     mov ebx, delta_y
     cmp eax, ebx
     jle else3


     ;;error = delta_x / 2
     mov eax, delta_x
     mov ebx, 2
     xor edx, edx
     idiv ebx
     mov error, eax
     jmp res5

;;error = - delta_y / 2
else3: mov eax, delta_y
       mov ebx, 2
       xor edx, edx
       idiv ebx
       mov error, eax

res5: 
     mov eax, x0
     mov ebx, y0
     mov curr_x, eax  ;;curr_x = x0
     mov curr_y, ebx  ;;curr_y = y0
     invoke DrawPixel, curr_x, curr_y, color  ;;DrawPixel(curr_x, curr_y, color)


;;The while loop starts below

condition: ;;condition for the while loop

    ;;curr_x != x1
    mov eax, curr_x
    mov ebx, x1
    cmp eax, ebx
    je endloop ;;end the loop

    ;;curr_y != y1
    mov eax, curr_y
    mov ebx, y1
    cmp eax, ebx
    je endloop ;;end the loop
    
looping:
    invoke DrawPixel, curr_x, curr_y, color
    mov eax, error
    mov prev_error, eax ;;prve_error = error

    
    mov eax, prev_error 
    mov ebx, delta_x
    neg ebx

    ;;if (prev_error > - delta_x)
    cmp eax, ebx
    jle res_l1 ;;(if not)
    
    sub eax, delta_y
    mov error, eax    ;;(error = error - delta_y)
    
    mov eax, curr_x
    add eax, inc_x
    mov curr_x, eax ;;(curr_x = curr_x + inc_x)

res_l1:

    mov eax, prev_error
    mov ebx, delta_y

    ;;if (prev_error < delta_y)
    cmp eax, ebx
    jge res_l2 ;;(if not)

    add eax, delta_x
    mov error, eax    ;;(error = error + delta_x)
    
    mov eax, curr_y
    add eax, inc_y
    mov curr_y, eax ;;(curr_y = curr_y + inc_y)


res_l2:

    
    
    jmp condition ;;check condition again
    

endloop:
      
        


	ret        	;;  Don't delete this line...you need it
DrawLine ENDP




END
