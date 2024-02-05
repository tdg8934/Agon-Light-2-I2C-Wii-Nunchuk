   10 REM SERIAL I2C EXAMPLE - WII NUNCHUK
   20 REM TIMOTHY GILMORE 2024 / ADAPTED UART CODE BY RICHARD TURNNIDGE 2023
   21 REM This version is for 16-bit basic but you could adapt
   22 REM Check if we are running in 24-bit BASIC
   24 :
   25 IF HIMEM > &FFFF PRINT "This code will only run on BBC BASIC for Z80": STOP
   30 REM
   31 REM ---------------------------------------------------------
   32 REM This is the i2c assembly code 
   33 REM ---------------------------------------------------------
   36 :
   38 REM allocate plenty of memory spaces for the three machine code commands, could be smaller
   39 :
   40 DIM openi2c% 64
   50 DIM closei2c% 64
   60 DIM writei2c% 64
   70 DIM readi2c% 64
   80 :
   90 REM This routine is for opening the i2c device
   91 :
  100 FOR I%=0 TO 3 STEP 3
  110   P%=openi2c%
  120   [
  130   OPT I%
  140   :
  150   LD c, 3                          ; Address code of the i2c frequency 100K
  160   ld a, &1F
  170   RST &08                         ; mos_i2c_open
  180   RET
  280   ]
  290 NEXT
 1000 :
 1010 REM This routine is to close the i2c device
 1011 :
 1080 FOR I%=0 TO 3 STEP 3
 1090   P%=closei2c%
 1100   [
 1110   OPT I%
 1120   :
 1210   ld a, &20
 1220   RST &08                         ; mos_i2c_close
 1330   RET
 1370   ]
 1480 NEXT
 1500 :
 2000 REM This routine is to write i2c data
 2001 :
 2010 FOR I%=0 TO 3 STEP 3
 2020   P%=writei2c%
 2030   [
 2040   OPT I%
 2050   :
 2060   ld c, &52                       ; i2c device address (wii nunchuk = 0x52)
 2070   ld b, 1                         ; # of bytes to write (max 32)
 2080   ld hl, write_buffer             ; HL Pointer-write_buffer to read bytes
 2090   ld a, &21
 2100   RST &08                         ; mos_i2c_write
 2105   ld hl, 0
 2110   RET
 2115   :
 2120   .write_buffer
 2130   DEFB 0                          ; 14th byte in writei2c%
 2140   ]
 2150 NEXT
 2180 :
 2190 :
 2300 REM This routine is to read i2c data
 2310 FOR I%=0 TO 3 STEP 3
 2320   P%=readi2c%
 2330   [
 2340   OPT I%
 2350   :
 2360   ld c, &52                       ; i2c device address (wii nunchuk = 0x52)
 2370   ld b, 6                         ; # of bytes to read (max 32)
 2380   ld hl, read_buffer              ; HL Pointer-read_buffer to write bytes
 2390   ld a, &22
 2400   RST &08                         ; mos_i2c_read
 2405   ld hl, 0
 2410   RET
 2420   .read_buffer
 2430   DEFB 0 : DEFB 0 : DEFB 0 : DEFB 0 : DEFB 0 : DEFB 0
 2440   ]
 2450 NEXT
 2601 :
 2999 :
 3000 REM ---------------------------------------------------------
 3001 REM This is the user Basic program
 3002 REM ---------------------------------------------------------
 3020 A = writei2c% +14 : REM Char to send to wii nunchuk
 3030 B0 = readi2c% +14 : REM Char 0 to receive from wii nunchuk
 3040 B1 = readi2c% +15 : REM Char 1 to receive from wii nunchuk
 3050 B2 = readi2c% +16 : REM Char 2 to receive from wii nunchuk
 3060 B3 = readi2c% +17 : REM Char 3 to receive from wii nunchuk
 3070 B4 = readi2c% +18 : REM Char 4 to receive from wii nunchuk
 3080 B5 = readi2c% +19 : REM Char 5 to receive from wii nunchuk
 3100 REM Initialize
 3110 CALL openi2c% : ?A = &40 : CALL writei2c% : ?A = &0 : CALL writei2c% : CALL closei2c%
 3115 REM
 3120 CALL openi2c% 
 3200 ?A = &0 : CALL writei2c% : CALL readi2c%
 3205 REM CALL closei2c% - not required unless there is more than 1 i2c device
 3210 PRINT ?B0;" ";?B1;" ";?B2;" ";?B3;" ";B4;" ";B5
 3220 GOTO 3200
