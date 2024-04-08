; Patch to SndWatch routine in the Macintosh Portable ROM, included in
; Portable Control Panel 1.3
;
; Changes the original ROM routine so sound power is always on.

PmgrVars        EQU     $D18
SwVBLTask       EQU     $90             ; SndWatch VBL offset
vblCount        EQU     $A              ; Location of VBL timer offset
PMGRrecv        EQU     $904014         ; Portable ROM address for PMGRrecv
PMGRsend        EQU     $904016         ; Portable ROM address for PMGRsend
soundRead       EQU     $98             ; Power Manager command, read sound state
soundSet        EQU     $90             ; Power Manager command, set sound state
sndOnclrLtch    EQU     $3              ; Clear sound latch, sound power on
sndOn           EQU     $1              ; Sound latch released, sound power on
sndOffclrLtch   EQU     $2              ; Clear sound latch, sound power off
sndOff          EQU     $0              ; Sound latch released, sound power off

    macro _IdleUpdate                   ; Macro for calling the _IdleUpdate Trap
        dc.w        $A285
    endm

SndWatchPatch:
    movea.l     PmgrVars,A2
    lea         (SwVBLTask,A2),A0       ; Get pointer to VBL task
    move.w      #600,(vblCount,A0)      ; Reset VBL timer 600/60 = 10s 
    subq.w      #4,SP                   ; Create stack frame
    movea.l     SP,A0
    move.w      #soundRead,D0           ; Load the command to 
    movea.l     #PMGRrecv,A3            ; Load address for PMGRrecv
    jsr         (A3)                    ; Jump to it
    move.b      (A0),D2                 ; Get sound state
    btst.l      #1,D2
    beq.b       .ClearLatch
    _IdleUpdate                         ; Update activity indicator
.ClearLatch:
    move.b      #sndOnclrLtch,(A0)      ; Turn on sound power and clear the latch
    moveq       #1,D1                   ; One byte to send
    move.w      #soundSet,D0            ; PMGR command, set sound state
    movea.l     #PMGRsend,A3            ; Load address for PMGRsend         
    jsr         (A3)                    ; Jump to it
.Exit:
    addq.w      #4,SP                   ; Release stack frame
    rts                                 ; Return
