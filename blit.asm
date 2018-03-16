; #########################################################################
;
;   blit.asm - Assembly file for EECS205 Assignment 3
;
;	Ryan Yejun Jeon  yjj3249
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc


.DATA

	;; If you need to, you can place global variables here
	
.CODE

DrawPixel PROC USES eax ebx ecx x:DWORD, y:DWORD, color:DWORD

	mov ecx, color	    ;Store the color of th epixel	
	
	;First, Check screen boundaries
	cmp y, 0 ;If out of boundary left corner
	jl break
	cmp x, 0	
	jl break   
	
	cmp y, 480 ;If out of bounadry right corner 640 x 480
	jge break
	cmp x, 640
	jge break
	

	;Location of the pixel (if in bound)
	mov eax, y		
	mov ebx, 640		
	mul ebx				;640 (x pix) * y to figure out the y coordinate as address in array
	add eax, x			; + x to figure out x coordinate as address in the array
	add eax, ScreenBitsPtr   ;make eax the address of corresponding element in ScreenBits array
	
	mov BYTE PTR[eax], cl;     
	
	break:

	ret 			; Don't delete this line!!!
DrawPixel ENDP


BasicBlit PROC USES eax ebx ecx edx edi ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD
	LOCAL x_i:DWORD, x_f:DWORD, y_i:DWORD, y_f:DWORD, counter:DWORD, trans_color:BYTE
	
	;Set up pointer for the bitmap
	mov ecx, ptrBitmap  	
	mov bl, (EECS205BITMAP PTR [ecx]).bTransparent   
	mov trans_color, bl	

	;Coordinate initialization (Half - Half = Initial) / (Half + Half = Final)
	mov ebx, xcenter ;Set both sex initial and final to xcenter
	mov x_i, ebx	 
	mov x_f, ebx		
	mov ebx, (EECS205BITMAP PTR[ecx]).dwWidth ;get width 
	sar ebx, 1  		;width/2
	sub x_i, ebx		;x initial
	add x_f, ebx		;x final 
	
	;Same for Y coordinate
	mov ebx, ycenter	
	mov y_i, ebx
	mov y_f, ebx
	mov ebx, (EECS205BITMAP PTR [ecx]).dwHeight 
	sar ebx, 1
	sub y_i, ebx
	add y_f, ebx
	
	
	mov counter, 0 ;initialize the i value for the loop
	;Looping through the bitmap
	xLoop:
		mov ebx, x_f
		
		;x_i < x_f?
		cmp x_i, ebx		
		jge yLoop		;Skip to y
		
		;Else
		mov ebx, (EECS205BITMAP PTR [ecx]).lpBytes
		mov edi, counter
		mov dl, BYTE PTR [ebx + edi]
		mov al, trans_color
		
		;trans_color == color?
		cmp dl, al		
		je break
		
		;Else
		invoke DrawPixel, x_i, y_i, [ebx + edi] ;Draw a cooresponding pixel
	
	break:
		inc counter	
		;x_i++, for next column		
		inc x_i			
		jmp xLoop
		
	yLoop:
		inc y_i
		mov ebx, y_i
		
		;y_i >= y_f?
		cmp ebx, y_f
		jge break2
		
		;Else
		mov ebx, (EECS205BITMAP PTR [ecx]).dwWidth	
		sub x_i, ebx		
		jmp xLoop		;Update x
		
	break2: ;end
	ret 			; Don't delete this line!!!	
BasicBlit ENDP




RotateBlit PROC  USES eax ebx ecx edx esi edi lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
	LOCAL dstX:DWORD, dstY:DWORD, srcX:DWORD, srcY:DWORD, shiftX:DWORD, shiftY:DWORD, trans_color:BYTE,  dstWidth:DWORD, dstHeight:DWORD
	
	invoke FixedCos, angle
	mov ecx, eax			;cosa = FixedCos(angle)
	invoke FixedSin, angle	
	mov edi, eax			;sina = FixedSin(angle)
	
	
	mov esi, lpBmp ;esi = lpBitmap
	
	
	mov bl, (EECS205BITMAP PTR [esi]).bTransparent
	mov trans_color, bl		;store the transparent color in trans_color

	
	;shiftX Calc
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	imul ecx
	mov shiftX, eax
	sar shiftX, 1			;EECS205BITMAP PTR [esi]).dwWidth * cosa / 2
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	imul edi
	sar eax, 1			;EECS205BITMAP PTR [esi]).dwHeight * sina / 2
	sub shiftX, eax			;set shiftX
	
	;shiftY Calc
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	imul ecx
	mov shiftY, eax
	sar shiftY, 1 ;Divide height by 2
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	imul edi
	sar eax, 1 ;Divide height by 2
	add shiftY, eax 
		
	
	;dstWidth Calc
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	add eax, (EECS205BITMAP PTR [esi]).dwHeight  ;(EECS205BITMAP PTR [esi]).dwWidth + (EECS205BITMAP PTR[esi]).dwHeight
	
	;dstHeight= dstWidth
	mov dstWidth, eax		
	mov dstHeight, eax
	
	;Setting up forloop condition
	neg eax
	mov dstX, eax		;dstX = -dstWidth
	mov dstY, eax		;dstY = -dstHeight
	
	;Integer transformation
	sar shiftY, 16		
	sar shiftX, 16
	jmp x_cond  ;First Loop

;Inside the second loop 
yLoop:
	
	;srcX = dstX*cosa + dstY*sina
	mov eax, dstX	
	imul ecx
	mov srcX, eax
	mov eax, dstY
	imul edi
	add srcX, eax		
	
	;srcY = dstY*cosa – dstX*sina
	mov eax, dstY
	imul ecx
	mov srcY, eax
	mov eax, dstX
	imul edi
	sub srcY, eax
	
	;Integer transformation 
	sar srcX, 16		
	sar srcY, 16
	
;Insde If condition 
	;srcX >= 0 
	cmp srcX, 0		
	jl break
	
	;&&
	
	;srcX < (EECS205BITMAP PTR [esi]).dwWidth
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	cmp srcX, eax		
	jge break
	
	;&&
	
	;srcY >= 0	
	cmp srcY, 0		
	jl break
	
	;&&
	
	;srcY >= 0 && srcY < (EECS205BITMAP PTR [esi]).dwHeight
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	cmp srcY, eax		
	jge break
	
	;&&
	
	;(xcenter+dstX-shiftX) >=0
	mov eax, xcenter
	add eax, dstX
	sub eax, shiftX
	cmp eax, 0
	jl break		
	
	;&&
	
	;(xcenter+dstX-shiftX) < 639
	mov eax, xcenter
	add eax, dstX
	sub eax, shiftX
	cmp eax, 639
	jge break		
	
	;&&

	;(ycenter+dstY-shiftY) >=0
	mov eax, ycenter
	add eax, dstY
	sub eax, shiftY
	cmp eax, 0
	jl break	

	;&&

	;(ycenter+dstY-shiftY) < 479
	mov eax, ycenter
	add eax, dstY
	sub eax, shiftY
	cmp eax, 479
	jge break		
	
	;&&

	;bitmap pixel (srcX,srcY) is not transparent?
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth	; Color (srcX, srcY)
	
	mov edx, srcY					
	imul edx
	add eax, srcX
	add eax, (EECS205BITMAP PTR [esi]).lpBytes
	mov dl, BYTE PTR [eax]
	
	;Is it transparent?
	cmp dl, trans_color					
	je break
	
	
	;xcenter+dstX-shiftX
	mov ebx, xcenter				
	add ebx, dstX
	sub ebx, shiftX
	
	;ycenter+dstY-shiftY
	mov edx, ycenter
	add edx, dstY
	sub edx, shiftY
	
	invoke DrawPixel, ebx, edx, BYTE PTR [eax] ;DrawPixel(xcenter+dstX-shiftX, ycenter+dstY-shiftY, bitmap pixel)
	
break:
	inc dstY ;dstY++

y_cond: ;Second loop condition 
	;dstY < dstHeight
	mov eax, dstY
	cmp eax, dstHeight
	jl yLoop
	inc dstX ;dstX++

x_cond: ;First Loop condition 
	; dstX < dstWidth
    mov eax, dstHeight
	neg eax
    mov dstY, eax	
	mov eax, dstX
	cmp eax, dstWidth
	jl y_cond

	
	ret 			; Don't delete this line!!!		
RotateBlit ENDP



END
