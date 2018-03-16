; #########################################################################
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc

include \masm32\include\windows.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib

include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib

includelib \masm32\lib\winmm.lib
include \masm32\include\winmm.inc


;; Has keycodes
include keys.inc

	
.DATA

;; If you need to, you can place global variables here



fighter DWORD ?
fighter_x DWORD ?
fighter_y DWORD ?
fighter_angle FXPT ?
boosted DWORD 0 ;Is the fighter boosted?
fighterSpeed DWORD 10


star_x DWORD ?
star_y DWORD ?
star_angle FXPT ?
star_bitmap DWORD ?
left DWORD ?
staron DWORD ?


nukeptr DWORD ?
nukex DWORD ?
nukey DWORD ?
nukeangle FXPT ?
nukeOn DWORD ?  ;; 0 = nuke not on, 1 = nuke on
nukeLife DWORD ? ;; default life time 20 * 10 px

asteroid1x DWORD ?
asteroid1y DWORD ?
asteroid1angle FXPT ?
asteroid1bitMap DWORD ?
asteroid1on DWORD ?
down DWORD ?

asteroid2x DWORD ?
asteroid2y DWORD ?
asteroid2angle FXPT ?
asteroid2bitMap DWORD ?
asteroid2on DWORD ?
down2 DWORD ?
up2 DWORD ?

asteroid3x DWORD ?
asteroid3y DWORD ?
asteroid3angle FXPT ?
asteroid3bitMap DWORD ?
asteroid3on DWORD ?
right3 DWORD ?

asteroid4x DWORD ?
asteroid4y DWORD ?
asteroid4angle FXPT ?
asteroid4bitMap DWORD ?
asteroid4on DWORD ?
down4 DWORD ?

parrotCount DWORD ? ;Initial Parrot count

parrot1x DWORD ?
parrot1y DWORD ?
parrot1angle FXPT ?
parrot1bitMap DWORD ?
parrot1on DWORD ?
downp1 DWORD ?

parrot2x DWORD ?
parrot2y DWORD ?
parrot2angle FXPT ?
parrot2bitMap DWORD ?
parrot2on DWORD ?

parrot3x DWORD ?
parrot3y DWORD ?
parrot3angle FXPT ?
parrot3bitMap DWORD ?
parrot3on DWORD ?
leftp3 DWORD ?

;Sounds
SndPath BYTE "Arcade-Game-Menu-Music-Loop-Sound-Effect-8-Bit-Style.wav",0
 

gameOverStr BYTE "Game Over! Press R to Restart", 0 ;General game over statement
gameOver DWORD 0

asteroidStr BYTE "DNFed .. You died before saving all the parrots.. :( " , 0 ;If you died by getting hit by an asteroid
gothit DWORD 0

timeStr BYTE "Time ran out.. The parrots will all starve to death..", 0 ;If time ran out

winStr BYTE "Wow! You saved all the parrots! Press R to play again.", 0 ; If saved all the parrots

pauseStr BYTE "Resume with Enter and Pause with Space", 0
pause DWORD 0
resumeStr BYTE "Pause with Space Bar", 0



starZone BYTE '-----Safe Zone-----', 0
info1 BYTE "Save all the Parrots before score is 0 (Destroying Asteroid is 50 points!)", 0


fmtStr BYTE "score: %d", 0
outStr BYTE 256 DUP(0)

fmtStrScore BYTE "Your Final Score Is: %d", 0
outStrScore BYTE 256 DUP(0)

started DWORD 0

timer BYTE ?, 0

timeMax DWORD ?


fighter_000 EECS205BITMAP <44, 37, 255,, offset fighter_000 + sizeof fighter_000>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,049h,0b6h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h
	BYTE 0ffh,0e0h,0e0h,080h,080h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,080h,080h
	BYTE 080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,049h,013h,049h,00ah,024h,049h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,049h,091h,049h,013h,0ffh,00ah,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h
	BYTE 013h,013h,0ffh,00ah,00ah,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,013h,013h,013h,00ah
	BYTE 00ah,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,0b6h,013h,013h,013h,00ah,00ah,091h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,049h,091h,0b6h,049h,013h,013h,00ah,024h,091h,049h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,091h
	BYTE 0b6h,049h,0ffh,024h,091h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,091h,091h,0b6h,091h,091h
	BYTE 049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,091h,091h,091h,049h,049h,049h,049h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,080h,0ffh,0ffh
	BYTE 0ffh,049h,091h,049h,049h,091h,049h,049h,024h,024h,049h,024h,0ffh,0ffh,0ffh,080h
	BYTE 080h,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0ffh,0e0h,0e0h,080h,080h,0ffh,049h,091h,091h,0b6h
	BYTE 091h,049h,049h,024h,049h,049h,049h,049h,024h,0ffh,0e0h,080h,080h,080h,080h,080h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0e0h,049h,049h,049h,024h,080h,0ffh,049h,091h,0b6h,0b6h,091h,091h,049h,049h
	BYTE 049h,049h,049h,049h,024h,0ffh,0e0h,024h,024h,024h,024h,080h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h
	BYTE 091h,049h,024h,049h,091h,091h,0b6h,091h,091h,091h,049h,049h,049h,049h,049h,049h
	BYTE 049h,024h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0ffh
	BYTE 049h,0b6h,091h,091h,091h,091h,049h,049h,049h,049h,049h,049h,024h,0e0h,091h,049h
	BYTE 049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0e0h,0ffh,049h,049h,091h
	BYTE 091h,091h,049h,049h,049h,049h,024h,024h,0e0h,080h,091h,049h,049h,049h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0b6h,091h,091h,091h,049h,024h,0e0h,0e0h,049h,091h,049h,049h,049h,049h,024h
	BYTE 024h,024h,049h,024h,080h,080h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,049h,049h,049h
	BYTE 049h,024h,024h,0e0h,0e0h,0b6h,049h,0b6h,0b6h,091h,080h,049h,049h,049h,024h,049h
	BYTE 080h,080h,049h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,091h,091h,049h,024h
	BYTE 0e0h,0b6h,049h,091h,0b6h,091h,080h,049h,049h,024h,024h,049h,080h,091h,049h,049h
	BYTE 049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,049h,0b6h,091h,091h,091h,091h,091h,049h,024h,0e0h,0b6h,049h,0b6h
	BYTE 091h,049h,080h,024h,024h,049h,024h,049h,080h,091h,049h,049h,049h,049h,049h,024h
	BYTE 024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h
	BYTE 0b6h,091h,091h,000h,091h,091h,049h,024h,0e0h,0b6h,091h,049h,0b6h,091h,080h,049h
	BYTE 049h,024h,049h,049h,080h,091h,049h,049h,000h,049h,049h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,049h,0b6h,091h,000h,0fch
	BYTE 000h,091h,049h,024h,0e0h,0b6h,091h,049h,091h,091h,080h,049h,024h,024h,049h,049h
	BYTE 080h,091h,049h,000h,090h,000h,049h,024h,024h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,0b6h,000h,0fch,000h,0fch,000h,049h,024h
	BYTE 0e0h,0b6h,091h,049h,0b6h,049h,080h,024h,049h,024h,049h,049h,080h,091h,000h,090h
	BYTE 000h,090h,000h,024h,024h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0b6h,091h,049h,0e0h,0b6h,000h,000h,000h,000h,000h,049h,024h,080h,0b6h,091h,091h
	BYTE 049h,091h,080h,049h,024h,049h,049h,049h,080h,091h,000h,000h,000h,000h,000h,024h
	BYTE 024h,024h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,0e0h,0e0h,080h
	BYTE 0b6h,091h,091h,091h,091h,091h,049h,024h,080h,0b6h,091h,0b6h,091h,049h,080h,024h
	BYTE 049h,049h,049h,049h,080h,091h,049h,049h,049h,049h,049h,024h,024h,080h,080h,080h
	BYTE 049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,080h,080h,0ffh,0ffh,049h,049h,049h
	BYTE 049h,049h,024h,0e3h,0b6h,0b6h,091h,091h,0b6h,091h,024h,049h,049h,049h,049h,049h
	BYTE 024h,0e3h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,080h,080h,080h,080h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0e0h,080h,0ffh,0ffh,0ffh,0e0h,0ffh,0e0h,0e0h,0e0h,0e0h,080h,080h
	BYTE 0ffh,0b6h,049h,049h,049h,0b6h,091h,024h,024h,024h,024h,024h,0ffh,0e0h,0e0h,080h
	BYTE 080h,080h,080h,080h,080h,0ffh,0ffh,0ffh,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,0e0h,080h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,080h,080h,080h,080h,080h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0e0h,024h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,080h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

nuke_000 EECS205BITMAP <8, 9, 255,, offset nuke_000 + sizeof nuke_000>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh
	BYTE 0ffh,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh,01ch,01ch,01ch,01ch,01ch,01ch,01ch,0ffh
	BYTE 01ch,01ch,01ch,01ch,01ch,01ch,01ch,0ffh,01ch,01ch,01ch,01ch,01ch,01ch,01ch,0ffh
	BYTE 0ffh,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	


fighter_002 EECS205BITMAP <41, 41, 255,, offset fighter_002 + sizeof fighter_002>

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,0b6h,049h,049h,024h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,049h,0ffh,0e0h,0e0h,080h,080h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,080h

	BYTE 080h,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,049h,091h,049h,013h,049h,00ah,024h,049h,024h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,049h

	BYTE 013h,0ffh,00ah,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,013h,013h,0ffh,00ah,00ah,049h,024h,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h

	BYTE 091h,013h,013h,013h,00ah,00ah,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,0b6h,013h,013h,013h,00ah,00ah,091h

	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 049h,091h,0b6h,049h,013h,013h,00ah,024h,091h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,091h,0b6h,049h,0ffh,024h

	BYTE 091h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,049h,049h,091h,091h,0b6h,091h,091h,049h,049h,024h,024h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,091h,091h,091h

	BYTE 049h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h

	BYTE 080h,0ffh,0ffh,0ffh,049h,091h,049h,049h,091h,049h,049h,024h,024h,049h,024h,0ffh

	BYTE 0ffh,0ffh,080h,080h,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0ffh,0e0h,0e0h,080h,080h,0ffh,049h,091h,091h,0b6h

	BYTE 091h,049h,049h,024h,049h,049h,049h,049h,024h,0ffh,0e0h,080h,080h,080h,080h,080h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,049h

	BYTE 049h,049h,024h,080h,0ffh,049h,091h,0b6h,0b6h,091h,091h,049h,049h,049h,049h,049h

	BYTE 049h,024h,0ffh,0e0h,024h,024h,024h,024h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,049h,091h,091h

	BYTE 0b6h,091h,091h,091h,049h,049h,049h,049h,049h,049h,049h,024h,091h,049h,049h,049h

	BYTE 024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0b6h,091h,091h,091h,049h,024h,0ffh,049h,0b6h,091h,091h,091h,091h,049h,049h,049h

	BYTE 049h,049h,049h,024h,0e0h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0e0h

	BYTE 0ffh,049h,049h,091h,091h,091h,049h,049h,049h,049h,024h,024h,0e0h,080h,091h,049h

	BYTE 049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0e0h,0e0h,049h,091h,049h,049h,049h,049h

	BYTE 024h,024h,024h,049h,024h,080h,080h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,049h,049h,049h,049h,024h

	BYTE 024h,0e0h,0e0h,0b6h,049h,0b6h,0b6h,091h,080h,049h,049h,049h,024h,049h,080h,080h

	BYTE 049h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0b6h,091h,091h,091h,091h,091h,049h,024h,0e0h,0b6h,049h,091h,0b6h

	BYTE 091h,080h,049h,049h,024h,024h,049h,080h,091h,049h,049h,049h,049h,049h,024h,024h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,0b6h,091h,091h,091h

	BYTE 091h,091h,049h,024h,0e0h,0b6h,049h,0b6h,091h,049h,080h,024h,024h,049h,024h,049h

	BYTE 080h,091h,049h,049h,049h,049h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,049h,049h,0b6h,091h,091h,000h,091h,091h,049h,024h,0e0h,0b6h,091h

	BYTE 049h,0b6h,091h,080h,049h,049h,024h,049h,049h,080h,091h,049h,049h,000h,049h,049h

	BYTE 024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,049h,0b6h,091h

	BYTE 000h,0fch,000h,091h,049h,024h,0e0h,0b6h,091h,049h,091h,091h,080h,049h,024h,024h

	BYTE 049h,049h,080h,091h,049h,000h,090h,000h,049h,024h,024h,024h,049h,024h,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,091h,0b6h,091h,049h,0b6h,000h,0fch,000h,0fch,000h,049h,024h,0e0h

	BYTE 0b6h,091h,049h,0b6h,049h,080h,024h,049h,024h,049h,049h,080h,091h,000h,090h,000h

	BYTE 090h,000h,024h,024h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,049h,0e0h

	BYTE 0b6h,000h,000h,000h,000h,000h,049h,024h,080h,0b6h,091h,091h,049h,091h,080h,049h

	BYTE 024h,049h,049h,049h,080h,091h,000h,000h,000h,000h,000h,024h,024h,024h,049h,049h

	BYTE 024h,0ffh,0ffh,0ffh,091h,091h,0e0h,0e0h,080h,0b6h,091h,091h,091h,091h,091h,049h

	BYTE 024h,080h,0b6h,091h,0b6h,091h,049h,080h,024h,049h,049h,049h,049h,080h,091h,049h

	BYTE 049h,049h,049h,049h,024h,024h,080h,080h,080h,049h,024h,0ffh,0ffh,0ffh,0e0h,080h

	BYTE 080h,0ffh,0ffh,049h,049h,049h,049h,049h,024h,0e3h,0b6h,0b6h,091h,091h,0b6h,091h

	BYTE 024h,049h,049h,049h,049h,049h,024h,0e3h,024h,024h,024h,024h,024h,024h,0ffh,0ffh

	BYTE 080h,080h,080h,080h,0ffh,0ffh,0e0h,080h,0ffh,0ffh,0ffh,0e0h,0ffh,0e0h,0e0h,0e0h

	BYTE 0e0h,080h,080h,0ffh,0b6h,049h,049h,049h,0b6h,091h,024h,024h,024h,024h,024h,0ffh

	BYTE 0e0h,0e0h,080h,080h,080h,080h,080h,080h,0ffh,0ffh,0ffh,080h,080h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,0e0h,080h,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,080h,080h,080h,080h,080h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh,00fh,00fh,00fh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh,00fh

	BYTE 00fh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh

	BYTE 017h,017h,017h,017h,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,017h,017h,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,0ffh,0ffh,017h,017h

	BYTE 00fh,0ffh,0ffh,0ffh,0ffh,0e0h,024h,080h,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh

	BYTE 0ffh,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 00fh,017h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,080h

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,017h,00fh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,0ffh,0ffh

	BYTE 017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h

	BYTE 017h,0ffh,0ffh,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,017h,017h,00fh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h

	BYTE 017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,00fh,017h,017h,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh,00fh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

	BYTE 0ffh
	
asteroid_001 EECS205BITMAP <32, 32, 255,, offset asteroid_001 + sizeof asteroid_001>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,049h,091h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,091h,091h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,091h,091h,049h,091h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 0b6h,091h,091h,091h,091h,049h,091h,049h,024h,049h,049h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 0b6h,091h,091h,091h,049h,024h,049h,091h,024h,024h,049h,049h,024h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 0b6h,091h,091h,091h,049h,024h,049h,091h,049h,024h,049h,049h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 091h,0b6h,0b6h,091h,049h,049h,024h,049h,024h,024h,049h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h
	BYTE 049h,091h,0b6h,091h,091h,049h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h
	BYTE 091h,049h,091h,091h,049h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h
	BYTE 091h,091h,091h,091h,049h,049h,024h,024h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,0b6h
	BYTE 0b6h,091h,091h,049h,049h,024h,024h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,0b6h,0b6h
	BYTE 091h,091h,049h,049h,049h,024h,024h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,091h,0b6h,0b6h,0b6h,091h,091h,0b6h,091h
	BYTE 091h,091h,049h,049h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h
	BYTE 091h,049h,049h,049h,049h,024h,024h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h
	BYTE 091h,049h,049h,049h,049h,024h,024h,091h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,049h
	BYTE 091h,049h,049h,049h,049h,024h,049h,091h,091h,049h,024h,024h,024h,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,0b6h,0b6h,091h,091h,091h,091h,049h,049h
	BYTE 049h,091h,049h,049h,024h,024h,049h,049h,091h,091h,049h,024h,024h,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,091h,091h,049h,091h,091h,0b6h,091h,091h,0b6h,091h,049h,049h
	BYTE 049h,049h,049h,024h,024h,049h,049h,049h,091h,091h,049h,024h,024h,024h,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,091h,091h,049h,049h,091h,0b6h,091h,091h,091h,091h,091h,049h
	BYTE 049h,049h,049h,024h,024h,049h,049h,049h,091h,091h,049h,024h,049h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,0b6h,0b6h,091h,091h,049h,049h,091h,091h,0b6h,091h,091h,091h,049h
	BYTE 049h,049h,049h,024h,024h,049h,049h,049h,091h,049h,049h,049h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,091h,091h,0b6h,091h,091h,091h,091h,091h
	BYTE 049h,049h,049h,049h,024h,024h,049h,091h,049h,049h,049h,091h,049h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,0b6h,091h,0b6h,0b6h,091h,091h,091h,091h
	BYTE 049h,049h,049h,049h,024h,024h,024h,049h,049h,049h,091h,049h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,091h,091h,0b6h,0b6h,091h,091h,049h
	BYTE 049h,049h,091h,049h,049h,049h,049h,049h,049h,091h,091h,049h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h,049h,049h
	BYTE 049h,024h,049h,091h,049h,049h,049h,049h,091h,091h,049h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,091h,091h,091h,091h,049h
	BYTE 049h,049h,024h,049h,091h,091h,091h,091h,091h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,091h,091h,091h
	BYTE 091h,091h,091h,091h,091h,049h,049h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,0b6h,091h
	BYTE 091h,049h,049h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,049h
	BYTE 049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	
asteroid_003 EECS205BITMAP <48, 42, 255,, offset asteroid_003 + sizeof asteroid_003>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,049h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,049h,024h
	BYTE 024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,091h,049h
	BYTE 049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,049h,091h,091h
	BYTE 049h,049h,049h,024h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,091h,049h,049h
	BYTE 049h,049h,049h,049h,024h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,091h,0b6h,0b6h,091h,091h,049h
	BYTE 049h,049h,024h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,091h,091h,091h,0b6h,091h,091h,049h,091h,0b6h,0b6h,091h,091h
	BYTE 049h,049h,049h,049h,049h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,049h,049h,091h,091h,0b6h,091h,091h
	BYTE 091h,049h,049h,049h,024h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,091h,091h,091h,091h,091h,049h,049h,049h,091h,091h,0b6h,091h
	BYTE 091h,091h,049h,049h,024h,024h,049h,049h,024h,024h,049h,049h,024h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,091h,091h,091h,091h,0b6h,091h,091h,049h,049h,049h,049h,0b6h,091h
	BYTE 091h,091h,049h,049h,049h,024h,049h,049h,024h,024h,049h,049h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,0b6h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,091h,049h,049h,091h,091h,091h
	BYTE 091h,091h,049h,049h,049h,024h,024h,049h,049h,024h,024h,049h,049h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,0b6h,091h,091h,091h,091h,091h,091h,0b6h,091h,091h,091h,091h,091h,091h,091h
	BYTE 091h,091h,049h,049h,049h,049h,049h,049h,049h,024h,024h,049h,049h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 0b6h,0b6h,091h,091h,091h,091h,091h,091h,091h,0b6h,091h,091h,091h,091h,091h,091h
	BYTE 091h,049h,049h,049h,049h,049h,049h,049h,049h,049h,024h,024h,049h,049h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h
	BYTE 0b6h,091h,091h,091h,091h,091h,091h,091h,091h,0b6h,091h,091h,0b6h,0b6h,091h,091h
	BYTE 049h,049h,091h,049h,049h,049h,049h,049h,049h,049h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h
	BYTE 0b6h,091h,091h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,0b6h,0b6h,091h,091h,049h
	BYTE 049h,091h,091h,049h,049h,049h,024h,049h,049h,049h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h
	BYTE 0b6h,091h,091h,091h,0b6h,0b6h,091h,091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,049h
	BYTE 091h,091h,091h,049h,049h,024h,024h,049h,049h,049h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h
	BYTE 091h,091h,091h,049h,091h,0b6h,091h,091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h
	BYTE 091h,091h,049h,049h,049h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h
	BYTE 091h,091h,091h,091h,049h,091h,091h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h
	BYTE 091h,091h,049h,049h,024h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h
	BYTE 091h,091h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,091h
	BYTE 091h,049h,049h,049h,024h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h
	BYTE 091h,091h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,091h
	BYTE 091h,049h,049h,024h,024h,024h,049h,049h,049h,049h,049h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,0b6h,0b6h
	BYTE 091h,091h,049h,091h,091h,091h,0b6h,091h,091h,091h,091h,091h,091h,091h,091h,091h
	BYTE 049h,049h,049h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,091h
	BYTE 091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,091h,049h,091h,091h,091h,091h
	BYTE 049h,049h,024h,024h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,0b6h,091h,091h,0b6h
	BYTE 0b6h,091h,091h,049h,091h,0b6h,091h,091h,091h,091h,091h,091h,091h,091h,091h,049h
	BYTE 049h,049h,049h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,0b6h,091h,049h,091h
	BYTE 0b6h,0b6h,091h,091h,091h,091h,091h,091h,049h,049h,091h,091h,091h,091h,049h,049h
	BYTE 049h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,049h,091h
	BYTE 091h,0b6h,091h,049h,091h,091h,091h,049h,049h,091h,091h,091h,049h,049h,049h,049h
	BYTE 049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,0b6h,0b6h,091h,049h,049h
	BYTE 091h,0b6h,091h,049h,091h,091h,091h,049h,091h,091h,049h,049h,049h,049h,024h,024h
	BYTE 049h,049h,049h,024h,024h,024h,024h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,091h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h,0b6h,0b6h,091h,049h
	BYTE 091h,0b6h,091h,049h,091h,091h,049h,049h,091h,049h,049h,091h,091h,049h,049h,024h
	BYTE 024h,049h,024h,024h,024h,024h,049h,049h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,091h,091h,0b6h,091h,049h
	BYTE 091h,0b6h,091h,049h,091h,049h,049h,091h,049h,049h,024h,049h,091h,091h,049h,024h
	BYTE 024h,049h,024h,024h,024h,024h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,0b6h,091h,091h,091h,0b6h,0b6h,091h,091h,091h,091h,091h,0b6h,091h
	BYTE 049h,091h,049h,091h,091h,049h,049h,091h,049h,024h,049h,049h,049h,091h,049h,024h
	BYTE 024h,024h,024h,024h,024h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,091h,091h,049h,091h,091h,0b6h,091h,091h,091h,091h,091h,091h
	BYTE 091h,091h,091h,091h,091h,049h,049h,091h,049h,024h,024h,049h,049h,091h,049h,049h
	BYTE 024h,024h,024h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,091h,091h,049h,049h,091h,0b6h,091h,091h,091h,091h,091h,091h
	BYTE 091h,091h,091h,091h,091h,049h,049h,091h,049h,049h,024h,024h,091h,049h,049h,049h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,0b6h,0b6h,091h,091h,049h,049h,091h,091h,091h,091h,091h,0b6h,091h
	BYTE 091h,091h,091h,091h,091h,091h,049h,049h,091h,049h,049h,049h,049h,049h,049h,049h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,091h,091h,091h,0b6h,091h,091h
	BYTE 091h,091h,049h,091h,091h,091h,049h,049h,049h,049h,049h,049h,049h,049h,049h,024h
	BYTE 024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,0b6h,091h,091h
	BYTE 091h,091h,049h,049h,049h,091h,049h,049h,049h,049h,049h,049h,049h,049h,024h,024h
	BYTE 024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,0b6h,0b6h,091h
	BYTE 091h,091h,049h,049h,091h,049h,049h,049h,049h,024h,024h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h
	BYTE 091h,091h,049h,024h,049h,091h,049h,049h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,0b6h,0b6h,0b6h
	BYTE 091h,091h,049h,024h,024h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h
	BYTE 091h,091h,091h,049h,049h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h
	BYTE 091h,091h,091h,049h,049h,049h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,091h,049h,049h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,091h,091h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	
asteroid_004 EECS205BITMAP <18, 26, 255,, offset asteroid_004 + sizeof asteroid_004>
	BYTE 0ffh,0ffh,091h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,091h,0b6h,091h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,049h,091h,049h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,024h,049h,091h,049h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h,049h,024h
	BYTE 024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h
	BYTE 049h,049h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,091h,049h,049h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,091h,049h,049h,024h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,091h,049h,049h,024h,024h,049h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,049h,049h,049h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,091h,049h,049h,024h
	BYTE 024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,091h,091h
	BYTE 049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h
	BYTE 091h,0b6h,091h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,0b6h,091h,091h,049h,024h,049h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 091h,0b6h,0b6h,0b6h,091h,091h,049h,024h,049h,049h,024h,024h,024h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,0b6h,0b6h,091h,091h,049h,024h,049h,049h,024h,049h,024h,024h,024h
	BYTE 024h,0ffh,0ffh,091h,0b6h,0b6h,0b6h,0b6h,091h,049h,049h,091h,049h,024h,024h,024h
	BYTE 049h,049h,024h,0ffh,0ffh,091h,0b6h,0b6h,049h,091h,0b6h,049h,049h,049h,049h,049h
	BYTE 024h,024h,024h,049h,049h,024h,0ffh,091h,0b6h,0b6h,091h,049h,091h,049h,091h,049h
	BYTE 049h,091h,049h,024h,024h,049h,049h,024h,0ffh,0ffh,091h,0b6h,091h,091h,049h,049h
	BYTE 091h,049h,024h,049h,091h,049h,024h,024h,049h,024h,0ffh,0ffh,091h,0b6h,0b6h,091h
	BYTE 049h,049h,049h,091h,049h,024h,024h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,0b6h,091h,049h,049h,091h,091h,049h,049h,049h,049h,024h,049h,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,0b6h,091h,091h,049h,091h,091h,091h,049h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,091h,091h,091h,049h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,049h,049h,049h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh

asteroid_005 EECS205BITMAP <21, 23, 255,, offset asteroid_005 + sizeof asteroid_005>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,049h,024h,024h,024h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h
	BYTE 049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,091h,049h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,091h,091h,049h,049h,024h,049h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,0b6h,091h,0b6h,0b6h
	BYTE 091h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h
	BYTE 0b6h,091h,049h,091h,0b6h,0b6h,091h,049h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,091h,091h,0b6h,0b6h,091h,049h,091h,091h,0b6h,091h,049h,024h,049h,049h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,091h,091h,049h,049h,091h,0b6h
	BYTE 091h,049h,024h,049h,049h,024h,0ffh,0ffh,091h,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h
	BYTE 091h,091h,049h,049h,091h,049h,049h,024h,024h,049h,024h,024h,091h,0b6h,0b6h,0b6h
	BYTE 0b6h,0b6h,091h,091h,0b6h,091h,091h,091h,049h,049h,024h,049h,049h,024h,024h,024h
	BYTE 024h,091h,0b6h,0b6h,091h,091h,0b6h,091h,049h,091h,0b6h,091h,049h,049h,024h,024h
	BYTE 024h,024h,049h,024h,024h,024h,091h,0b6h,091h,091h,0b6h,0b6h,091h,049h,049h,091h
	BYTE 091h,091h,049h,049h,049h,024h,024h,024h,024h,049h,024h,091h,0b6h,091h,091h,0b6h
	BYTE 091h,091h,091h,091h,091h,049h,049h,091h,091h,049h,049h,024h,024h,024h,024h,024h
	BYTE 091h,0b6h,091h,091h,091h,091h,049h,091h,091h,049h,049h,091h,049h,049h,091h,049h
	BYTE 024h,024h,024h,024h,0ffh,091h,0b6h,0b6h,091h,091h,0b6h,091h,091h,091h,091h,091h
	BYTE 0b6h,091h,091h,049h,024h,024h,024h,049h,024h,0ffh,0ffh,091h,0b6h,0b6h,091h,091h
	BYTE 091h,0b6h,0b6h,0b6h,0b6h,091h,091h,0b6h,091h,049h,024h,049h,091h,049h,0ffh,0ffh
	BYTE 0ffh,091h,0b6h,0b6h,0b6h,0b6h,0b6h,091h,091h,091h,0ffh,0ffh,091h,091h,049h,049h
	BYTE 091h,091h,049h,0ffh,0ffh,0ffh,0ffh,091h,091h,091h,091h,091h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,049h,091h,091h,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh

sadparrot EECS205BITMAP <35, 25, 255,, offset sadparrot + sizeof sadparrot>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,092h
	BYTE 092h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h
	BYTE 024h,024h,049h,049h,092h,092h,092h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 092h,024h,024h,092h,092h,092h,092h,092h,092h,092h,092h,092h,092h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,024h,024h,092h,092h,049h,024h,092h,092h,092h,092h,092h,092h,092h
	BYTE 049h,024h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,092h,092h,092h,024h,024h,092h,092h,024h,024h
	BYTE 024h,024h,024h,024h,024h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,024h,092h,092h,092h,09fh,09fh,024h,092h
	BYTE 024h,024h,092h,092h,092h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,049h,092h,092h,092h,09fh
	BYTE 09fh,092h,092h,049h,049h,092h,092h,092h,024h,049h,049h,024h,092h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,024h,049h,092h
	BYTE 092h,092h,09fh,09fh,092h,092h,024h,049h,092h,092h,092h,049h,049h,092h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h
	BYTE 049h,092h,092h,092h,092h,092h,092h,092h,092h,049h,049h,092h,092h,092h,024h,049h
	BYTE 092h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,024h,049h,092h,092h,092h,092h,092h,092h,092h,092h,024h,049h,092h,092h
	BYTE 092h,049h,049h,092h,092h,024h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,024h,092h,092h,092h,092h,092h,092h,092h,092h,092h,049h
	BYTE 049h,092h,092h,092h,024h,049h,092h,092h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,049h,092h,092h,092h,092h,092h,092h
	BYTE 092h,092h,092h,024h,092h,092h,049h,024h,092h,092h,092h,049h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,049h,092h,092h,092h
	BYTE 092h,092h,092h,092h,092h,092h,024h,024h,049h,024h,024h,092h,092h,092h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,024h,024h
	BYTE 049h,092h,092h,092h,092h,092h,092h,092h,092h,049h,024h,024h,024h,049h,092h,092h
	BYTE 092h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 024h,024h,092h,049h,049h,092h,092h,092h,092h,092h,092h,092h,092h,024h,024h,049h
	BYTE 092h,092h,092h,092h,024h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,092h,024h,049h,092h,049h,049h,049h,049h,092h,092h,092h,092h,092h,092h
	BYTE 092h,092h,092h,092h,092h,092h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,024h,049h,092h,092h,049h,049h,049h,049h,049h,049h,092h
	BYTE 092h,092h,092h,092h,092h,092h,092h,092h,092h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,092h,092h,092h,092h,092h,092h,049h
	BYTE 049h,049h,049h,049h,092h,092h,092h,092h,092h,092h,092h,092h,092h,024h,092h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,024h,024h,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh


	
beretparrot EECS205BITMAP <35, 35, 255,, offset beretparrot + sizeof beretparrot>
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0b6h,06dh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0ffh,000h,06dh,06dh,06dh
	BYTE 06dh,0b6h,0ffh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0ffh,091h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,06dh,0ffh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0ffh,0b6h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0ffh
	BYTE 049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,0ffh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,0ffh,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,0ffh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,0ffh,06dh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,0ffh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,0dbh,000h,000h,000h,000h,000h,065h,089h,0a9h,0f2h
	BYTE 0edh,089h,0a9h,0f2h,089h,000h,000h,06dh,0ffh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0ffh,024h,000h,000h,000h,065h,0f6h,0f6h
	BYTE 0f6h,0f6h,0a9h,000h,000h,000h,0a9h,0f6h,040h,000h,0ffh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0dbh,000h,049h,049h,000h
	BYTE 0f6h,0edh,000h,0a9h,0f6h,000h,024h,091h,049h,000h,065h,000h,000h,0ffh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0dbh,024h
	BYTE 0dbh,000h,0f2h,0f6h,0a9h,000h,0a9h,0f2h,000h,091h,091h,091h,024h,000h,000h,000h
	BYTE 0b6h,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,0ffh,0ffh,06dh,089h,0f6h,0f2h,0f2h,0a9h,0f2h,0edh,000h,091h,091h,091h,000h
	BYTE 065h,0f2h,089h,06dh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,0b6h,040h,0f6h,0f2h,0f2h,0f2h,0f6h,0f6h,0a9h,000h,091h
	BYTE 091h,091h,000h,089h,0ffh,0edh,000h,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,0ffh,000h,0edh,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h
	BYTE 0f2h,000h,06dh,091h,091h,000h,0a9h,0f6h,0f2h,000h,0dbh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,091h,040h,0f6h,0f2h,0f2h,0f2h
	BYTE 0f2h,0f2h,0f2h,0f2h,000h,049h,0b6h,06dh,000h,0edh,0f6h,0f6h,065h,0b6h,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,024h,089h,0f6h
	BYTE 0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f6h,040h,024h,0b6h,049h,000h,0f2h,0f2h,0f6h,089h
	BYTE 06dh,0ffh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0dbh
	BYTE 000h,0a9h,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f6h,0edh,000h,091h,024h,065h,0f6h
	BYTE 0f2h,0f6h,089h,06dh,0ffh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,06dh,000h,089h,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f6h,065h,000h
	BYTE 000h,0f2h,0f2h,0f2h,0f6h,065h,0b6h,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,0ffh,040h,065h,040h,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h
	BYTE 0f2h,0f6h,000h,065h,0f6h,0f2h,0f2h,0f2h,040h,0dbh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,06dh,065h,0f6h,000h,089h,0f6h,0f2h,0f2h,0f2h
	BYTE 0f2h,0f2h,0f2h,0f2h,0f6h,0edh,0edh,0f2h,0f2h,0f6h,0edh,000h,0ffh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,091h,000h,0f2h,0f6h,0a9h,000h,089h
	BYTE 0f6h,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f6h,0f2h,0f2h,0f2h,0f6h,0a9h,049h,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0ffh,049h,000h,0f2h,0f6h,0f2h
	BYTE 0f6h,0a9h,000h,040h,0edh,0f6h,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f6h
	BYTE 065h,06dh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0b6h,000h,065h,0f2h
	BYTE 0f6h,0f2h,0f2h,0f2h,0f6h,0f2h,040h,000h,000h,065h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h
	BYTE 0f2h,0f2h,0f6h,065h,06dh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,0ffh,024h,040h
	BYTE 0edh,0f6h,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h,0f6h,0f6h,0edh,065h,065h,0f2h,0f2h,0f2h
	BYTE 0f2h,0f2h,0f2h,0f2h,0f2h,0f6h,0a9h,049h,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 049h,065h,0f6h,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f6h,0f6h,0f6h
	BYTE 0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,000h,0ffh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,0b6h,040h,0f6h,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h
	BYTE 0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f6h,065h,091h,0ffh
	BYTE 04eh,04eh,04eh,04eh,04eh,06dh,089h,0f6h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h
	BYTE 0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h,0f2h
	BYTE 0a9h,024h,0b6h,04eh,04eh,04eh,04eh,04eh,024h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,06dh,04eh,04eh,04eh	

oldtimeyparrot EECS205BITMAP <35, 25, 255,, offset oldtimeyparrot + sizeof oldtimeyparrot>
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,0ffh,0ffh,0ffh,091h,0ffh,0ffh,091h,0ffh,0ffh,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,0ffh,0ffh,091h,024h,024h,024h,091h,048h,091h
	BYTE 0ffh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,091h,024h,024h,024h,024h,024h
	BYTE 024h,024h,024h,024h,091h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,024h,024h,048h,0b5h
	BYTE 0b5h,0b5h,0b5h,0b5h,0b5h,048h,024h,024h,0ffh,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,024h,024h
	BYTE 048h,024h,048h,0b5h,048h,024h,024h,024h,024h,048h,024h,091h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh
	BYTE 024h,024h,048h,048h,024h,048h,0b5h,024h,048h,091h,091h,024h,024h,024h,024h,0ffh
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,091h,024h,048h,0b5h,0b5h,024h,024h,0b5h,024h,091h,091h,091h,091h,024h
	BYTE 024h,024h,091h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,0ffh,024h,024h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,024h,091h,091h
	BYTE 091h,06ch,024h,0b5h,024h,024h,0ffh,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,048h,024h,048h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h
	BYTE 024h,091h,091h,091h,091h,024h,0b5h,0b5h,024h,091h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,024h,024h,0b5h,0b5h,0b5h,0b5h
	BYTE 0b5h,0b5h,0b5h,024h,091h,091h,091h,091h,024h,0b5h,0b5h,024h,024h,0ffh,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,024h,024h,0b5h
	BYTE 0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,024h,091h,091h,091h,048h,024h,0b5h,0b5h,048h,024h
	BYTE 0ffh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,024h
	BYTE 024h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,048h,048h,091h,091h,024h,0b5h,0b5h
	BYTE 0b5h,048h,024h,091h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,0ffh,024h,024h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,048h,024h,091h,048h
	BYTE 024h,048h,0b5h,0b5h,0b5h,024h,091h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,024h,024h,048h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,048h
	BYTE 024h,024h,024h,024h,0b5h,0b5h,0b5h,048h,024h,091h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,0ffh,024h,024h,048h,048h,0b5h,0b5h,0b5h,0b5h,0b5h
	BYTE 0b5h,0b5h,0b5h,048h,024h,024h,048h,0b5h,0b5h,0b5h,048h,024h,0ffh,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,0ffh,024h,024h,0b5h,0b5h,048h,0b5h,0b5h
	BYTE 0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,048h,048h,0b5h,0b5h,0b5h,0b5h,024h,024h,0ffh
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,024h,024h,048h,0b5h,0b5h
	BYTE 048h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h
	BYTE 024h,091h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,0ffh,024h,024h,0b5h
	BYTE 0b5h,0b5h,0b5h,048h,048h,048h,048h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h
	BYTE 0b5h,0b5h,048h,024h,0ffh,000h,000h,000h,000h,000h,000h,000h,000h,0ffh,091h,024h
	BYTE 024h,048h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,048h,048h,048h,048h,0b5h,0b5h,0b5h,0b5h
	BYTE 0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,024h,0ffh,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 091h,024h,048h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h
	BYTE 0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,048h,024h,0ffh,000h,000h,000h,000h,000h
	BYTE 000h,000h,0ffh,024h,024h,048h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h
	BYTE 0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,024h,0ffh,000h,000h
	BYTE 000h,000h,000h,000h,0ffh,024h,024h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h
	BYTE 0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,048h,024h
	BYTE 091h,000h,000h,000h,000h,000h,0ffh,091h,024h,048h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h
	BYTE 0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h,0b5h
	BYTE 0b5h,0b5h,024h,024h,000h,000h,000h,000h,000h,0ffh,091h,024h,024h,024h,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,024h,000h,000h,000h,000h
	
thumbsupparrot EECS205BITMAP <54, 25, 255,, offset thumbsupparrot + sizeof thumbsupparrot>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,071h,024h,024h,024h,024h,024h,024h,071h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,024h,024h,024h,028h,0fah,0fah,028h,0fah,028h,024h,024h,071h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,071h,024h,028h,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,028h,024h,028h,028h
	BYTE 024h,0fah,028h,024h,024h,024h,024h,028h,024h,024h,028h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,071h,024h,028h,0fah,028h,024h,028h,024h,028h,071h,071h,028h,024h,024h,024h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dah,000h,092h,0b6h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,0fah,0fah,028h,024h,0fah,024h,071h
	BYTE 071h,071h,071h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,06dh,06dh,06dh
	BYTE 024h,0dah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,0fah
	BYTE 0fah,0fah,0fah,0fah,024h,071h,071h,071h,071h,024h,0fah,0fah,028h,024h,071h,0ffh
	BYTE 0ffh,0ffh,0ffh,092h,06dh,0fah,08dh,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,071h,024h,0fah,0fah,0fah,0fah,0fah,0fah,024h,071h,071h,071h,071h,024h
	BYTE 0fah,0fah,0fah,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,000h,0d5h,0fah,024h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 024h,071h,071h,04ch,071h,024h,0fah,0fah,0fah,0fah,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 048h,0d5h,0fah,024h,0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,028h
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,024h,04ch,071h,071h,071h,024h,0fah,0fah,0fah,028h
	BYTE 024h,071h,0ffh,0ffh,0ffh,0ffh,024h,0d5h,0d5h,048h,0b6h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,071h,024h,028h,0fah,0fah,0fah,0fah,0fah,0fah,028h,024h,071h,071h
	BYTE 024h,028h,0fah,0fah,0fah,0fah,024h,071h,0ffh,0ffh,0ffh,0b6h,048h,0fah,0fah,024h
	BYTE 0b6h,0ffh,0ffh,0ffh,0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,071h,024h,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,028h,024h,028h,028h,024h,028h,0fah,0fah,0fah,028h,024h,071h,0ffh,0ffh
	BYTE 0ffh,092h,06dh,0fah,0fah,091h,024h,06dh,06dh,024h,048h,06dh,0b6h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,071h
	BYTE 024h,028h,0fah,0fah,0fah,0fah,0fah,0fah,0fah,024h,024h,024h,024h,0fah,0fah,0fah
	BYTE 0fah,0fah,024h,071h,0ffh,0ffh,0ffh,024h,0b1h,0fah,0fah,0fah,0d5h,091h,091h,0d5h
	BYTE 0b1h,06dh,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,071h,024h,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,028h
	BYTE 024h,024h,0fah,0fah,0fah,0fah,0fah,028h,024h,0ffh,0ffh,0ffh,0dbh,024h,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,0fah,08dh,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,071h,024h,024h,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,0fah,028h,0fah,0fah,0fah,0fah,0fah,0fah,024h,0ffh
	BYTE 0dbh,092h,024h,091h,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,06dh,049h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,024h,024h,028h,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,028h,024h,024h,024h,000h,091h,0fah,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,0b1h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,028h,028h,028h,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,048h,024h,024h,048h,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,06dh,092h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,071h,024h,024h,028h,0fah
	BYTE 0fah,028h,028h,028h,028h,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 048h,091h,06dh,048h,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,048h
	BYTE 06dh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,024h,024h,028h,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,024h,0b1h,06dh,024h,0d5h,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,06dh,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,071h,024h,024h,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,08dh,06dh,091h,024h
	BYTE 08dh,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0b1h,000h,0dbh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,028h,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0d5h,024h,0b1h,06dh,024h,0fah,0d5h,0d5h,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 08dh,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 071h,024h,028h,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,048h,048h,08dh,000h,000h,024h,049h
	BYTE 048h,0b1h,091h,08dh,08dh,049h,000h,06dh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,071h,028h,024h,028h,0fah,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0fah,0d5h
	BYTE 091h,000h,024h,0b6h,0dbh,0b6h,0b6h,004h,048h,049h,024h,06dh,0b6h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,06dh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,0dbh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

.CODE

;Clear object as it moves (Similar to RotateBlit but erases colors instead of drawing)
clearObject PROC USES  ebx ecx edx esi edi  lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
	LOCAL dstX:DWORD, dstY:DWORD, srcX:DWORD, srcY:DWORD, shiftX:DWORD, shiftY:DWORD, trans_color:BYTE, dstWidth:DWORD, dstHeight:DWORD

	invoke FixedCos, angle
	mov ecx, eax			;cosa = FixedCos(angle)
	invoke FixedSin, angle
	mov edi, eax			;sina = FixedSin(angle

	mov esi, lpBmp  ;esi = lpBitmap
	
	
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
	sub shiftX, eax			

	
	;shiftY Calc
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	imul ecx
	mov shiftY, eax
	sar shiftY, 1 ;Divide height by 2
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	imul edi
	sar eax, 1    ;Divide height by 2
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
	sar shiftY, 16		;convert shiftY and shiftX to integer
	sar shiftX, 16
	jmp x_cond		;First Loop

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
	cmp srcX, eax		;srcX < dwWidth
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
	
	
	invoke DrawPixel, ebx, edx, 0 ;DrawPixel(xcenter+dstX-shiftX, ycenter+dstY-shiftY, 0 (no color!!))
	
break:
	inc dstY ;dstY++

y_cond: ;Second loop condition 
	;dstY < dstHeight
	mov eax, dstY
	cmp eax, dstHeight
	jl yLoop
	inc dstX ;dstX++

x_cond: ;First Loop condition 
	;First Loop condition 
    mov eax, dstHeight
	neg eax
    mov dstY, eax
	mov eax, dstX
	cmp eax, dstWidth
	jl y_cond
	
	
	ret 			; Don't delete this line!!!
clearObject ENDP
	

;This will help me control my fighter with my keyboard
fighterControl PROC
	invoke clearObject, fighter, fighter_x, fighter_y, fighter_angle
	
	;Check if fighter is boosted
	cmp boosted, 0
	jne boost
	
	;Else just normal
    lea eax, fighter_000 ;Default Model
    mov fighter, eax
	jmp drawFighter
	
boost:
	mov fighterSpeed, 15 ;Boost the fighter
    lea eax, fighter_002 ;Set sprite for boosted fighter
    mov fighter, eax
	
drawFighter:
    invoke RotateBlit, fighter, fighter_x, fighter_y, fighter_angle ;Draw the fighter


;Key Controls 
Left:
	cmp KeyPress, 41h
	jne Right
	invoke clearObject, fighter, fighter_x, fighter_y,  fighter_angle
	mov fighter_angle, 308829
	mov eax,fighterSpeed
	sub fighter_x, eax
	invoke RotateBlit, fighter, fighter_x, fighter_y, fighter_angle

Right:
	cmp KeyPress, 44h
	jne Up
	invoke clearObject, fighter, fighter_x, fighter_y, fighter_angle
	mov fighter_angle, 102943
	mov eax, fighterSpeed
	add fighter_x, eax
	invoke RotateBlit, fighter, fighter_x, fighter_y, fighter_angle
	
Up:
	cmp KeyPress, 57h
	jne Down
	invoke clearObject, fighter, fighter_x, fighter_y, fighter_angle
	mov fighter_angle, 0
	mov eax, fighterSpeed
	sub fighter_y, eax
	invoke BasicBlit, fighter, fighter_x, fighter_y ;Original

Down:
	cmp KeyPress, 53h
	jne done
	invoke clearObject, fighter, fighter_x, fighter_y, fighter_angle
	mov fighter_angle, 205886
	mov eax, fighterSpeed
	add fighter_y, eax
	invoke RotateBlit, fighter, fighter_x, fighter_y, fighter_angle


done:
	ret
fighterControl ENDP


;Checks if sprites intersect
CheckIntersect PROC USES ebx ecx edx esi oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP
	
	
	xor eax, eax ;clear eax first
	
	
	;Checking the left border
	mov ecx, oneBitmap
	mov ebx, (EECS205BITMAP PTR [ecx]).dwWidth
	sar ebx, 1
	add ebx, oneX 

	mov edx, twoBitmap
	mov esi, (EECS205BITMAP PTR [edx]).dwWidth
	sar esi, 1
	mov eax, twoX
	sub eax, esi 

	;If they don't intersect skip
	cmp ebx, eax
	jle noint  ;If oneX border below left of B no intersect

	;Checking the right border
    mov ebx, (EECS205BITMAP PTR [ecx]).dwWidth
    sar ebx, 1
    mov eax, oneX
	sub eax, ebx

    mov esi, (EECS205BITMAP PTR [edx]).dwWidth
    sar esi, 1
    add esi, twoX

    cmp eax, esi
    jge noint ;If oneX right border exceeds that of B no intersect
	
	
	;Do similar but for vertical borders!
    mov ebx, (EECS205BITMAP PTR [ecx]).dwHeight
    sar ebx, 1
    add ebx, oneY

    mov esi, (EECS205BITMAP PTR [edx]).dwHeight
    sar esi, 1
    mov eax, twoY
    sub eax, esi

	cmp ebx, eax ;Check if oneY top is less than equal to twoY bottom
	jle noint

	mov ebx, (EECS205BITMAP PTR [ecx]).dwHeight
    sar ebx, 1
    mov eax, oneY
    sub eax, ebx

    mov esi, (EECS205BITMAP PTR [edx]).dwHeight
    sar esi, 1
    add esi, twoY

    cmp eax, esi ;Check if oneY bottom is greater than equal to twoY top
    jge noint

	;If passed all the checks, they do indeed intersect
	mov eax, 1
	jmp inter

	noint:
		mov eax, 0
	inter:
		ret
CheckIntersect ENDP



;;helper check collison
collisionCheck PROC

	starCol:
	cmp staron, 0 ;If star is dead
	je asteroidNuke1
	
	invoke CheckIntersect, fighter_x, fighter_y, fighter, star_x, star_y, star_bitmap
	cmp eax, 0
	je asteroidNuke1 ;if Didn't colide
	invoke clearObject, star_bitmap, star_x, star_y, star_angle
	
	mov boosted, 1 ;Fighter gets a boost if colided with star
	mov staron, 0
	
	
	asteroidNuke1:
	cmp asteroid1on, 0 ;Is asteroid 1 there?
	je asteroidNuke2 ;if not
	
	invoke CheckIntersect, nukex, nukey, nukeptr, asteroid1x, asteroid1y, asteroid1bitMap
	cmp eax, 0
	je asteroidNuke2
	
	invoke clearObject, nukeptr, nukex, nukey, nukeangle
	invoke clearObject, asteroid1bitMap, asteroid1x, asteroid1y, asteroid1angle
	mov nukeOn, 0 ;Nuke should be gone	
	mov asteroid1on, 0 ;The asteroid should be gone
	add timeMax, 50 ;Give 50 more points for destroying the rock
	
	
	;move it off the grid
	mov asteroid1x, 10000
	mov asteroid1y, 10000
	
	;Move the nuke off the grid
	mov nukex, 20000
	mov nukey, 20000
	
	
	
	asteroidNuke2:
	cmp asteroid2on, 0 ;Is asteroid 2 there?
	je asteroidNuke3 ;if not
	
	invoke CheckIntersect, nukex, nukey, nukeptr, asteroid2x, asteroid2y, asteroid2bitMap
	cmp eax, 0
	je asteroidNuke3
	
	invoke clearObject, nukeptr, nukex, nukey, nukeangle
	invoke clearObject, asteroid2bitMap, asteroid2x, asteroid2y, asteroid2angle
	mov nukeOn, 0 ;Nuke should be gone	
	mov asteroid2on, 0 ;The asteroid should be gone
	add timeMax, 50 ;Give 50 more points for destroying the rock
	
	;move it off the grid
	mov asteroid2x, 30000
	mov asteroid2y, 30000
	
	;Move the nuke off the grid
	mov nukex, 40000
	mov nukey, 40000
	
	asteroidNuke3:
	cmp asteroid3on, 0 ;Is asteroid 2 there?
	je asteroidNuke4 ;if not
	
	invoke CheckIntersect, nukex, nukey, nukeptr, asteroid3x, asteroid3y, asteroid3bitMap
	cmp eax, 0
	je asteroidNuke4
	
	invoke clearObject, nukeptr, nukex, nukey, nukeangle
	invoke clearObject, asteroid3bitMap, asteroid3x, asteroid3y, asteroid3angle
	mov nukeOn, 0 ;Nuke should be gone	
	mov asteroid3on, 0 ;The asteroid should be gone
	add timeMax, 50 ;Give 50 more points for destroying the rock
	
	;move it off the grid
	mov asteroid3x, 30000
	mov asteroid3y, 30000
	
	;Move the nuke off the grid
	mov nukex, 40000
	mov nukey, 40000
	
		;Move the nuke off the grid
	mov nukex, 40000
	mov nukey, 40000
	
	asteroidNuke4:
	cmp asteroid4on, 0 ;Is asteroid 2 there?
	je rockCol ;if not
	
	invoke CheckIntersect, nukex, nukey, nukeptr, asteroid4x, asteroid4y, asteroid4bitMap
	cmp eax, 0
	je rockCol
	
	invoke clearObject, nukeptr, nukex, nukey, nukeangle
	invoke clearObject, asteroid4bitMap, asteroid4x, asteroid4y, asteroid4angle
	mov nukeOn, 0 ;Nuke should be gone	
	mov asteroid4on, 0 ;The asteroid should be gone
	add timeMax, 50 ;Give 50 more points for destroying the rock
	
	;move it off the grid
	mov asteroid4x, 50000
	mov asteroid4y, 50000
	
	;Move the nuke off the grid
	mov nukex, 60000
	mov nukey, 60000
	
	
	rockCol: ;If you hit the asteroid u daed.
	invoke CheckIntersect, fighter_x, fighter_y, fighter, asteroid1x, asteroid1y, asteroid1bitMap
	cmp eax, 0
	je rockCol2
	mov gameOver, 1
	mov gothit, 1 ;Tell the game you got hit
	
	rockCol2: ;If you hit the asteroid u daed.
	invoke CheckIntersect, fighter_x, fighter_y, fighter, asteroid2x, asteroid2y, asteroid2bitMap
	cmp eax, 0
	je rockCol3
	mov gameOver, 1
	mov gothit, 1 ;Tell the game you got hit
	
	rockCol3: ;If you hit the asteroid u daed.
	invoke CheckIntersect, fighter_x, fighter_y, fighter, asteroid3x, asteroid3y, asteroid3bitMap
	cmp eax, 0
	je rockCol4
	mov gameOver, 1
	mov gothit, 1 ;Tell the game you got hit
	
	rockCol4: ;If you hit the asteroid u daed.
	invoke CheckIntersect, fighter_x, fighter_y, fighter, asteroid4x, asteroid4y, asteroid4bitMap
	cmp eax, 0
	je parrotCol1
	mov gameOver, 1
	mov gothit, 1 ;Tell the game you got hit
	
	
	parrotCol1: ;If you found a parrot.
	invoke CheckIntersect, fighter_x, fighter_y, fighter, parrot1x, parrot1y, parrot1bitMap
	cmp eax, 0
	je parrotCol2

	invoke clearObject, parrot1bitMap, parrot1x, parrot1y, parrot1angle
	
	mov parrot1x, 50000
	mov parrot1y, 50000
	mov parrot1on, 0
	dec parrotCount ;Decrease the number of parrot you have to save
	
	
	parrotCol2: ;If you found a parrot
	invoke CheckIntersect, fighter_x, fighter_y, fighter, parrot2x, parrot2y, parrot2bitMap
	cmp eax, 0
	je parrotCol3
	
	invoke clearObject, parrot2bitMap, parrot2x, parrot2y, parrot2angle
	
	mov parrot2x, 50000
	mov parrot2y, 50000
	mov parrot2on, 0
	dec parrotCount ;Decrease the number of parrot you have to save
	
	parrotCol3: ;If you found a parrot
	invoke CheckIntersect, fighter_x, fighter_y, fighter, parrot3x, parrot3y, parrot2bitMap
	cmp eax, 0
	je nocol
	
	invoke clearObject, parrot3bitMap, parrot3x, parrot3y, parrot3angle
	
	mov parrot3x, 50000
	mov parrot3y, 50000
	mov parrot3on, 0
	dec parrotCount ;Decrease the number of parrot you have to save
	
	
	
	
	nocol:
	ret
collisionCheck ENDP

;Helps the star move around
MovStar PROC
	
	;Setting up limits to the star
	cmp staron, 0
	je done
	
	cmp star_x, 630
	je changeDir
		
	cmp star_x, 10
	je changeDirRight
	
	jmp continue
	
	changeDirRight:
	mov left, 0 ;tell the star to move right
	jmp continue
	
	changeDir: 
	mov left, 1 ;tell the star to move left
	
	
	
	continue:
	
	cmp left, 1   ;check if you should move left or right
	je rightborder
	
	jmp leftborder
	
	
	rightborder:
	invoke clearObject, star_bitmap, star_x, star_y, star_angle
	mov star_angle, 308829 ;Rotates to left
	mov eax, 10
	sub star_x, eax
	invoke RotateBlit, star_bitmap, star_x, star_y, star_angle
	jmp done
	
	leftborder:
	invoke clearObject, star_bitmap, star_x, star_y, star_angle
	mov star_angle, 102943 ;Rotates to right
	mov eax, 10
	add star_x, eax
	invoke RotateBlit, star_bitmap, star_x, star_y, star_angle
	
	done:
	ret
MovStar ENDP

;Helps the star move around
ParrotUpdate PROC USES ebx ecx
	
	mov ecx, 0

	cmp parrot1on, 1 ;If asteroid 1 is on
	jne updateParrot2 ;Move on to the second rock
	
	
	updateParrot1:
	  invoke clearObject, parrot1bitMap, parrot1x, parrot1y, parrot1angle
	  
	  
		
	  cmp parrot1y, 350
	  je turn
	  cmp parrot1y, 10
	  je turn
	  jmp cont
	  
	  turn:
	  neg downp1
	  
	  
	  cont:
	  mov ebx, downp1
	  add parrot1y, ebx

	  invoke RotateBlit, parrot1bitMap, parrot1x, parrot1y, parrot1angle
	
	updateParrot2:
	  cmp parrot2on, 1
	  jne updateParrot3
	   
	  invoke RotateBlit, parrot2bitMap, parrot2x, parrot2y, parrot2angle
	
	updateParrot3:
	  cmp parrot3on, 1
	  jne done
	  
	  invoke clearObject, parrot3bitMap, parrot3x, parrot3y, parrot3angle
		
	  cmp parrot3x, 630
	  je away3
	  cmp parrot3x, 10
	  je away3
	  jmp cont3
	  
	  away3:
	  add parrot3angle, 308829 * 2
	  neg leftp3
	  
	  cont3:
	  mov ebx, leftp3
	  add parrot3x, ebx
	   
	  invoke RotateBlit, parrot3bitMap, parrot3x, parrot3y, parrot3angle
	  
	done:
	ret
ParrotUpdate ENDP

;Clears portion of the screen
clearScreen PROC USES ebx ecx y_:DWORD 
	LOCAL i:DWORD, j:DWORD

	mov i, 0
	mov j, 0
	
	x:
	y:
	invoke clearObject, star_bitmap, i, j, 0
	
	add j, 10
	cmp j, 500
	jl y
	
	mov j, 0 ;Reset j
	add i, 20
	cmp i, 640
	jl x
	

	
	
	ret
clearScreen ENDP

asteroidUpdate PROC USES ecx ebx

  
	mov ecx, 0

	cmp asteroid1on, 1 ;If asteroid 1 is on
	jne updateasteroid2 ;Move on to the second rock
	
	
	updateasteroid1:
	  invoke clearObject, asteroid1bitMap, asteroid1x, asteroid1y, asteroid1angle
	  
	  
		
	  mov ebx, 10
	  cmp asteroid1y, 350
	  je turn
	  cmp asteroid1y, 10
	  je turn
	  jmp cont
	  
	  turn:
	  neg down
	  
	  
	  cont:
	  mov ebx, down
	  add asteroid1y, ebx
	  cmp asteroid1y, 400
	  jl rotate0
	  inc ecx
	rotate0:
	  invoke RotateBlit, asteroid1bitMap, asteroid1x, asteroid1y, asteroid1angle
	  
	
	;Movement for asteroid2 
	updateasteroid2:
	  
	  cmp asteroid2on, 1 ;If asteroid 2 is on
	  jne updateasteroid3
	
	  invoke clearObject, asteroid2bitMap, asteroid2x, asteroid2y, asteroid2angle
	  
	  mov ebx, 10
	  cmp asteroid2y, 350
	  je turn2
	  cmp asteroid2y, 10
	  je turn2
	  jmp noturn ;If you dont have to switch vertically
	  
	  turn2:
	  neg down2
	  
	  noturn:
	  cmp asteroid2x, 600 ;If at the right end
	  je away2
	  cmp asteroid2x, 10 ;If at the left end
	  je away2
	  
	  jmp cont2 
	  
	  
	  away2:
	  neg up2 ;Switch the direction

	  
	  
	  cont2:
	  mov ebx, down2
	  
	  add asteroid2y, ebx
	  
	  mov ebx, up2
	  
	  add asteroid2x, ebx
	  
	 
	rotate2:
	  invoke RotateBlit, asteroid2bitMap, asteroid2x, asteroid2y, asteroid2angle  
	 
	
	;Movement for asteroid3
	updateasteroid3:
	  
	  cmp asteroid3on, 1 ;If asteroid 3 is on
	  jne updateasteroid4 
	
	  invoke clearObject, asteroid3bitMap, asteroid3x, asteroid3y, asteroid3angle
	  
	  
	  cmp asteroid3x, 600 ;If at the right end
	  je away3
	  cmp asteroid3x, 10 ;If at the left end
	  je away3
	  
	  jmp cont3 
	  
	  
	  away3:
	  neg right3 ;Switch the direction

	  
	  
	  cont3:
	  
	  mov ebx, right3
	  add asteroid3x, ebx
	  

	rotate3:
	  invoke RotateBlit, asteroid3bitMap, asteroid3x, asteroid3y, asteroid3angle
	  
	  
	;Movement for asteroid4
	updateasteroid4:
	  
	  cmp asteroid4on, 1 ;If asteroid 2 is on
	  jne check 
	
	  invoke clearObject, asteroid4bitMap, asteroid4x, asteroid4y, asteroid4angle
	  
	  
	  cmp asteroid4y, 350 ;If at the bottom end
	  je turn4
	  cmp asteroid4y, 10 ;If at the left end
	  je turn4
	  
	  jmp cont4 
	  
	  
	  turn4:
	  neg down4 ;Switch the direction

	  
	  
	  cont4:
	  
	  mov ebx, down4
	  add asteroid4y, ebx
	  

	rotate4:
	  invoke RotateBlit, asteroid4bitMap, asteroid4x, asteroid4y, asteroid4angle
	  


	check:

notover:
	ret
asteroidUpdate ENDP

FireNuke PROC USES ecx 	
	;is nuke launched?
	cmp nukeOn, 1
	je updateNuke

	;Make sure that you can't spam nukes
	mov eax, OFFSET MouseStatus
	mov eax, [eax + 8]
	cmp eax, MK_LBUTTON   ;;left mouse clicked
	jne nukeDONE
	mov ecx, fighter_x
	mov nukex, ecx
	mov ecx, fighter_y
	mov nukey, ecx
	mov ecx, fighter_angle
	mov nukeangle, ecx
	mov nukeOn, 1
	mov nukeLife, 20
	invoke RotateBlit, nukeptr, nukex, nukey, nukeangle
	jmp nukeDONE

	updateNuke:
	invoke clearObject, nukeptr, nukex, nukey, nukeangle
	cmp nukeangle, 0
	jne downNuke
	sub nukey, 10
	jmp renderNuke
	
	downNuke:
	cmp nukeangle, 205886
	jne leftNuke
	add nukey, 10
	jmp renderNuke
	
	leftNuke:
	cmp nukeangle, 308829
	jne rightNuke
	sub nukex, 10
	jmp renderNuke
	rightNuke:
	cmp nukeangle, 102943
	jne nukeDONE
	add nukex, 10
	jmp renderNuke
	
	renderNuke:
	invoke RotateBlit, nukeptr, nukex, nukey, nukeangle
	sub nukeLife, 1
	cmp nukeLife, 0
	jne nukeDONE
	mov nukeOn, 0
	invoke clearObject, nukeptr, nukex, nukey, nukeangle

	nukeDONE:
	ret
FireNuke ENDP


GameInit PROC

	cmp started, 0
	jne nosound
	invoke PlaySound, offset SndPath, 0, SND_FILENAME OR SND_ASYNC OR SND_LOOP
	
	nosound:
	mov started, 1
	

	invoke DrawStarField
	
	
	mov gothit, 0 ;Init gothit
	
	mov parrotCount, 3 ;Initial Parrot count
	

	
	
	;Initialize star
	lea ebx, StarBitmap
	mov star_x, 100
	mov star_y, 120
	mov star_bitmap, ebx
	mov left, 0
	mov staron, 1
	
	
	;load the nuke
	lea ecx, nuke_000
	mov nukeptr, ecx
	mov nukeOn, 0
	mov nukeLife, 20
	mov nukeangle, 0
	
	lea ebx, asteroid_001
	mov asteroid1x, 100
	mov asteroid1y, 120
	mov asteroid1bitMap, ebx
	mov asteroid1on, 1
	mov down, 10
	invoke BasicBlit, ebx, 100,120
	
	lea ebx, asteroid_003
	mov asteroid2x, 200
	mov asteroid2y, 120
	mov asteroid2bitMap, ebx
	mov asteroid2on, 1
	mov down2, 10
	mov up2, 10
	invoke BasicBlit, ebx, 200,120
	
	lea ebx, asteroid_004
	mov asteroid4x, 400
	mov asteroid4y, 120
	mov asteroid4bitMap, ebx
	mov asteroid4on, 1
	mov down4, 10
	invoke BasicBlit, ebx, 400,120
	
	lea ebx, asteroid_005
	mov asteroid3x, 400
	mov asteroid3y, 120
	mov asteroid3bitMap, ebx
	mov asteroid3on, 1
	mov right3, 10
	invoke BasicBlit, ebx, 400,120
	
	;Parrot 1
	lea ebx, thumbsupparrot
	mov parrot1x, 50
	mov parrot1y, 340
	mov parrot1bitMap, ebx
	mov parrot1on, 1
	mov downp1, 10
	
	;Parrot 2
	lea ebx, sadparrot
	mov parrot2x, 600
	mov parrot2y, 30
	mov parrot2bitMap, ebx
	mov parrot2on, 1
	
	;Parrot 3
	lea ebx, oldtimeyparrot
	mov parrot3x, 600
	mov parrot3y, 210
	mov parrot3bitMap, ebx
	mov parrot3on, 1
	mov leftp3, 10
		
		
	;load the fighter
	mov boosted, 0
	mov fighterSpeed, 10
	lea ebx, fighter_000
	mov fighter, ebx
	mov fighter_x, 320
	mov fighter_y, 400
	mov fighter_angle, 0
	invoke BasicBlit, ebx, 320, 400
	
	
	mov timeMax, 500
	
	ret         ;; Do not delete this line!!!
GameInit ENDP

GamePlay PROC
		cmp timeMax, -1
		jne continue
		mov gameOver, 1
		continue:
		
		cmp gameOver, 1
		je gameover

		cmp KeyPress, 20h ;;space
		jne checkResume
		mov pause, 1
		jmp checkPause
	checkResume:
		cmp KeyPress, 0dh ;;enter
		jne checkPause
		mov pause, 0
	checkPause:
		cmp pause, 1
		jne continueTheGame
		
		jmp done
	continueTheGame:
	
	
	cmp parrotCount, 0 ;Saved all the parrots?
	je win 
	

	invoke DrawStr, offset pauseStr, 10, 10, 0ffh
	invoke DrawStr, offset starZone, 250, 360, 0ffh
	invoke DrawStr, offset info1, 10, 420, 0ffh
	
	rdtsc
	invoke clearObject, asteroid1bitMap, 537, 10, 0
	push timeMax
    push offset fmtStr
    push offset outStr
    call wsprintf
    add esp, 12
    invoke DrawStr, offset outStr, 470, 10, 255
	dec timeMax
		
	
	invoke ParrotUpdate
	invoke DrawStarField
	invoke fighterControl
	invoke collisionCheck
	invoke MovStar
	invoke FireNuke
	invoke asteroidUpdate
	jmp done
	
	gameover:
	

	
	
	cmp gothit, 1 ;Did you get hit by an asteroid?
	jne timeranout ;time ran out instead!
	
	invoke DrawStr, offset asteroidStr, 130, 180, 0ffh
	jmp gameover2
	
	timeranout:
	invoke DrawStr, offset timeStr, 170, 180, 0ffh
	
	
	gameover2:
	invoke DrawStr, offset gameOverStr, 200, 200, 0ffh
	mov timeMax, 0 ;DNF
	jmp lose
	
	win:
	invoke DrawStr, offset winStr, 120, 200, 0ffh
	lose:
	
	push timeMax
    push offset fmtStrScore
	push offset outStrScore
    call wsprintf
    add esp, 12
    invoke DrawStr, offset outStrScore, 200, 230, 255
	
	
	cmp KeyPress, 52h ;R
	jne done
	
	
	invoke clearScreen, 200
	mov gameOver, 0
		
	invoke GameInit
	
	
	
	
	done:


	ret         ;; Do not delete this line!!!
GamePlay ENDP

END
