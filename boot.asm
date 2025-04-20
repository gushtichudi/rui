org 0x7C00  ; BIOS (Legacy) boots from address 0x7C00.
bits 16     ; What mode to run on.

;; nasm macro for newline
%define BRK 0x0D, 0x0A

;; entry point
start:
        jmp main

write:                          ; ---- write to the screen ----
        ;; registers used to in the stack (si, ax)
        push si
        push ax

.loop:
        lodsb           ; load next character in AL
        or al, al       ; check if character is NULL
        jz .end

        mov ah, 0x0e    ; call bios interrupt
        mov bh, 0       ; set page number
        int 0x10

        jmp .loop       ; jump to this so the code loops

.end:                   ; -- end --
        ;; pop pushed registers in reverse order
        pop ax
        pop si
        ret

clrscr:                         ; ---- clear screen ----
        mov ah, 0x00
        mov al, 0x03
        int 0x10
        ret

main:                           ; ---- main entry -----
        ;; data segments
        mov ax, 0               ; can't write directly to ds/es
        mov ds, ax
        mov es, ax

        ;; setup the stack
        mov ss, ax
        mov sp, 0x7C00          ; grow stack downwards from start of memory

        ;; clear screen
        call clrscr

        mov si, copyright
        call write

        mov si, splash
        call write

        hlt

.hlt:                   ; -- halt CPU --
        cli
        hlt


copyright:      db 'Copyright (c) Morphine 2025. All rights reserved.', BRK, 0
splash:         db 'rui 0.0.0 bootloader', BRK, 0

times 510-($-$$) db 0
dw 0xAA55
