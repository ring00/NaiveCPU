; // A digit consists 28 * 28 = 784 character
; // we will use 0x0100~1FA0 to store 10 digits
; // we will use 0x2000~3EA0 to strore the network weights
; short* ptr;
; short image_index;

; void linear() {
;     short predict = 0;
;     short max = 0;
;     short* weight_ptr = 0x2000;
;     for (int i = 0; i < 10; i++) {
;         short* image_ptr = ptr;
;         short result = 0;
;         for (int j = 0; j < 784; j++, image_ptr++, weight_ptr++) {
;             short pixel = *image_ptr;
;             if (pixel == 0) {
;                 continue;
;             }
;             result += *weight_ptr;
;         }
;         short diff = max - result;
;         if (diff < 0) {
;             max = result;
;             predict = i;
;         }
;     }
; }

; void prev() {
;     if (image_index == 0x0) {
;         return;
;     }
;     ptr -= 0x310;

;     image_index -= 1;
;     *(short*)0xBF04 = image_index;

;     linear();
; }

; void next() {
;     if (image_index == 0x9) {
;         return;
;     }
;     ptr += 0x310;

;     image_index += 1;
;     *(short*)0xBF04 = image_index;

;     linear();
; }

; void test_keyboard() {
; }

; void start() {
;     ptr = 0x0100;
;     image_index = 0x0;
;     linear();
;     while (1) {
;         test_keyboard();
;         short key = *(short*)0xBF02;
;         if (key == 'A') {
;             prev();
;         }
;         if (key == 'D') {
;             next();
;         }
;     }
; }

START:
    LI R0 0x1
    SLL R0 R0 0x0 ; R0 = 0x0100
    LI R1 0x0 ; R1 = 0x0
    B LINEAR
    NOP
LOOP:
    MFPC R7
    B TEST_KEYBOARD
    ADDIU R7 0x2
    LI R2 0xBF
    SLL R2 R2 0x0 ; R2 = 0xBF00
    LW R2 R3 0x2 ; R3 = *(short*)0xBF02
    ; Test 'A'
    LI R2 0x41
    CMP R2 R3
    BTEQZ PREV
    NOP
    ; Test 'D'
    LI R2 0x44
    CMP R2 R3
    BTEQZ NEXT
    NOP
    B LOOP
    NOP

TEST_KEYBOARD:
    LI R2 0xBF
    SLL R2 R2 0x0 ; R2 = 0xBF00
    LW R2 R3 0x3 ; R3 = *(short*)0xBF03
    LI R2 0x1
    AND R3 R2
    BEQZ R3 TEST_KEYBOARD
    NOP
    JR R7
    NOP

PREV:
    BEQZ R1 LOOP
    LI R2 0x3
    SLL R2 R2 0x0 ; R1 = 0x300
    ADDIU R2 0x10 ; R1 = 0x310
    SUBU R0 R2 R0 ; R0 -= 0x310
    ADDIU R1 0xFF ; R1 -= 1
    LI R2 0xBF
    SLL R2 R2 0x0 ; R2 = 0xBF00
    SW R2 R1 0x4 ; *(short*)0xBF04 = R1
    B LINEAR
    NOP

NEXT:
    LI R2 0x9 ; R2 = 0x9
    CMP R1 R2
    BTEQZ LOOP
    LI R2 0x3
    SLL R2 R2 0x0 ; R2 = 0x300
    ADDIU R2 0x10 ; R2 = 0x310
    ADDU R0 R2 R0 ; R0 += 0x310
    ADDIU R1 0x1 ; R1 += 1
    LI R2 0xBF
    SLL R2 R2 0x0 ; R2 = 0xBF00
    SW R2 R1 0x4 ; *(short*)0xBF04 = R1
    B LINEAR
    NOP

LINEAR:
    LI R2 0x40
    SLL R2 R2 0x0 ; R2 = 0x4000
    MTSP R2 ; SP = 0x4000
    SW_SP R0 0x0 ; *(short*)0x4000 = R0
    SW_SP R1 0x1 ; *(short*)0x4001 = R1

    LI R0 0x0 ; R0 : predict
    LI R1 0x0 ; R1 : max

    LI R2 0x20
    SLL R2 R2 0x0 ; R2 : weight_ptr

    LI R3 0xA ; R3 = 0xA
OUTER:
    LI R4 0x3
    SLL R4 R4 0x0 ; R4 = 0x300
    ADDIU R4 0x10 ; R4 = 0x310 = 784

    LW_SP R5 0x0 ; R5 : image_ptr
    LI R6 0x0 ; R6 : result
INNER:
    LW R5 R7 0x0
    BEQZ R7 AFTER_ADD
    NOP
    LW R2 R7 0x0
    ADDU R6 R7 R6
AFTER_ADD:
    ADDIU R2 0x1 ; weight_ptr += 1
    ADDIU R5 0x1 ; image_ptr += 1

    ADDIU R4 0xFF ; R4 = R4 - 1
    BNEZ R4 INNER
    NOP

    SUBU R1 R6 R7 ; R7 = max - result
    SLTI R7 0x0 ; T = (max - result < 0)

    BTEQZ AFTER_UPDATE
    NOP ; FUCK MY LIFE

    ADDIU3 R6 R1 0x0 ; max = result
    LI R0 0xA
    SUBU R0 R3 R0 ; predict = i
AFTER_UPDATE:

    ADDIU R3 0xFF ; R3 = R3 - 1
    BNEZ R3 OUTER
    NOP

    LI R1 0xBF
    SLL R1 R1 0x0 ; R1 = 0xBF00
    SW R1 R0 0x5 ; *(short*)0xBF05 = predict

    LW_SP R1 0x1 ; R1 = *(short*)0x4001
    LW_SP R0 0x0 ; R0 = *(short*)0x4000
    B LOOP
    NOP