; // A slide consists 80 * 30 = 2400 character
; // we will use 0x0100~0xBC7F to store at most 20 slides
; short* ptr;

; void print_to_screen() {
;   short* current_ptr = ptr;
;   short* current_mem = 0xF000;
;   for (int i = 0; i < 0x1E; i++) { // 0x1E = 30
;       for (int j = 0; j < 0x50; j++) { // 0x50 = 80
;           short character = *current_ptr;
;           *current_mem = character;
;           current_ptr++;
;           current_mem++;
;       }
;       current_mem += 0x30; // 0x30 = 48 = 128 - 80
;   }
; }

; void prev() {
;   if (ptr == 0x0100) {
;       return;
;   }
;   ptr -= 0x960;
;   print_to_screen();
; }

; void next() {
;   if (ptr == 0xB320) { // 0x0100 + 19 * 2400 = 0xB320
;       return;
;   }
;   ptr += 0x960;
;   print_to_screen();
; }

; void test_keyboard() {

; }

; void start() {
;   ptr = 0x0100;
;   print_to_screen();
;   while (1) {
;       test_keyboard();
;       short key = *(short*)0xBF02;
;       if (key == 'a') {
;           prev();
;       }
;       if (key == 'd') {
;           next();
;       }
;   }
; }

START:
    LI R0 0x1
    SLL R0 R0 0x0 ; R0 = 0x0100
    B PRINT_TO_SCREEN
    NOP
LOOP:
    MFPC R7
    B TEST_KEYBOARD
    ADDIU R7 0x2
    LI R1 0xBF
    SLL R1 R1 0x0 ; R1 = 0xBF00
    LW R1 R2 0x2 ; R2 = *(short*)0xBF02
    ; Test 'A'
    LI R1 0x41
    CMP R1 R2
    BTEQZ PREV
    NOP
    ; Test 'D'
    LI R1 0x44
    CMP R1 R2
    BTEQZ NEXT
    NOP
    B LOOP
    NOP

TEST_KEYBOARD:
    LI R1 0xBF
    SLL R1 R1 0x0
    LW R1 R2 0x3 ; R2 = *(short*)0xBF03
    LI R1 0x1
    AND R2 R1
    BEQZ R2 TEST_KEYBOARD
    NOP
    JR R7
    NOP

PREV:
    LI R1 0x1
    SLL R1 R1 0x0 ; R1 = 0x0100
    CMP R0 R1
    BTEQZ LOOP
    LI R1 0x9
    SLL R1 R1 0x0 ; R1 = 0x0900
    ADDIU R1 0x60 ; R1 = 0x0960
    SUBU R0 R1 R0 ; R0 -= 0x0960
    B PRINT_TO_SCREEN
    NOP

NEXT:
    LI R1 0xB3
    SLL R1 R1 0x0 ; R1 = 0xB300
    ADDIU R1 0x20 ; R1 = 0xB320
    CMP R0 R1
    BTEQZ LOOP
    LI R1 0x9
    SLL R1 R1 0x0 ; R1 = 0x0900
    ADDIU R1 0x60 ; R1 = 0x0960
    ADDU R0 R1 R0 ; R0 += 0x960
    B PRINT_TO_SCREEN
    NOP

PRINT_TO_SCREEN:
    ADDIU3 R0 R1 0x0 ; R1 = R0
    LI R2 0xF0
    SLL R2 R2 0x0 ; R2 = 0xF000
    LI R3 0x1E ; R3 = 0x1E
OUTER:
    LI R4 0x50 ; R4 = 0x50
INNER:
    LW R1 R5 0x0
    SW R2 R5 0x0
    ADDIU R1 0x1
    ADDIU R2 0x1

    ADDIU R4 0xFF ; R4 = R4 - 1
    BNEZ R4 INNER
    NOP

    ADDIU R2 0x30

    ADDIU R3 0xFF ; R3 = R3 - 1
    BNEZ R3 OUTER
    NOP
    B LOOP
    NOP
