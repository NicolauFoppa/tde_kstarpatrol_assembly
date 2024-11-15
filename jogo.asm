.MODEL SMALL

.STACK 100H

.DATA
    ; cores
    verde EQU 2h
    vermelho EQU 4h
    vermelho_claro EQU 0Ch
    branco EQU 0Fh
    ciano_claro EQU 0Bh
    azul_claro EQU 9h
    azul EQU 1h
    magenta_claro EQU 0Dh
    magenta EQU 5h
    
    
    ; teclas
    arrow_down EQU 50h
    arrow_up EQU 48h
    enter EQU 0Dh
    espaco EQU 32h

    memoria_video equ 0A000h
    limite_inferior equ 48640 ; 
    limite_superior equ 6432 ; 320 * 20 + 32
    
    ;posicoes naves
    
    nave_principal dw ?
    velocidade_nave_principal equ 640 ; 2 linhas por vez
    
    vidas db 1
          db 1
          db 1
          db 1
          db 1
          db 1
          db 1
          db 1
                    
    cor_vida db 4h
             db 5h
             db 7h
             db 0Eh
             db 0Dh
             db 0Ch
             db 0Ah
             db 9h

; desenhos
    
    titulo db "       __ __     _____ __               " ; 40 x 10 = 400
           db "      / //_/    / ___// /_____ ______   "
           db "     / ,< ______\__ \/ __/ __ `/ ___/   "
           db "    / /| /_____/__/ / /_/ /_/ / /       "
           db "   /_/ |_|    /____/\__/\__,_/_/        "
           db "       ____        __             __    "
           db "      / __ \____ _/ /__________  / /    "
           db "     / /_/ / __ `/ __/ ___/ __ \/ /     "
           db "    / ____/ /_/ / /_/ /  / /_/ / /      "
           db "   /_/    \____/\__/_/   \____/_/       "
           
   setor_1 db "   _____ ________________  ____     ___ " ; 40 x 6 = 240
           db "  / ___// ____/_  __/ __ \/ __ \   <  / "
           db "  \__ \/ __/   / / / / / / /_/ /   / /  "
           db " ___/ / /___  / / / /_/ / _, _/   / /   "
           db "/____/_____/ /_/  \____/_/ |_|   /_/    "
           db "                                        "
           
   setor_2 db "   _____ ________________  ____    ___  "
           db "  / ___// ____/_  __/ __ \/ __ \  |__ \ "
           db "  \__ \/ __/   / / / / / / /_/ /  __/ / "
           db " ___/ / /___  / / / /_/ / _, _/  / __/  "
           db "/____/_____/ /_/  \____/_/ |_|  /____/  "
           db "                                        "
           
   setor_3 db "   _____ ________________  ____    _____"
           db "  / ___// ____/_  __/ __ \/ __ \  |__  /"
           db "  \__ \/ __/   / / / / / / /_/ /   /_ < "
           db " ___/ / /___  / / / /_/ / _, _/  ___/ / "
           db "/____/_____/ /_/  \____/_/ |_|  /____/  "
           db "                                        "

     nave_aliada db 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0,0
                 db 0,0,0Fh,0Fh,0,0,0,0,0,0,0,0,0,0,0
                 db 0,0,0Fh,0Fh,0,0,0,0,0,0,0,0,0,0,0
                 db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0,0,0
                 db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh
                 db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0,0,0
                 db 0,0,0Fh,0Fh,0,0,0,0,0,0,0,0,0,0,0
                 db 0,0,0Fh,0Fh,0,0,0,0,0,0,0,0,0,0,0
                 db 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0,0
                 
     tam_nave EQU $ - nave_aliada
                 
     nave_inimiga db 0,0,0,0,0,0,0,0,0,9,9,9,9,9,9
                  db 0,0,0,0,0,0,0,0,0,9,9,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                  db 0,0,0,0,9,9,9,9,9,0,0,0,0,0,0
                  db 9,9,9,9,9,9,9,9,9,9,9,9,9,0,0
                  db 0,0,0,0,9,9,9,9,9,0,0,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,9,9,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,9,9,9,9,9,9
    
    cenario db 39 dup(0H), 3 dup(06H), 26 dup(0H), 1 dup(06H), 17 dup(0H), 1 dup(06H), 188 dup(0H), 1 dup(06H), 11 dup(0H), 1 dup(06H), 8 dup(0H), 1 dup(06H), 23 dup(0H)  
            db 21 dup(0H), 1 dup(06H), 15 dup(0H), 7 dup(06H), 23 dup(0H), 2 dup(06H), 17 dup(0H), 2 dup(06H), 24 dup(0H), 3 dup(06H), 123 dup(0H), 1 dup(06H), 6 dup(0H), 2 dup(06H), 27 dup(0H), 3 dup(06H), 10 dup(0H), 1 dup(06H), 8 dup(0H), 2 dup(06H), 22 dup(0H)  
            db 20 dup(0H), 3 dup(06H), 11 dup(0H), 12 dup(06H), 19 dup(0H), 5 dup(06H), 10 dup(0H), 2 dup(06H), 3 dup(0H), 4 dup(06H), 20 dup(0H), 10 dup(06H), 20 dup(0H), 1 dup(06H), 2 dup(0H), 1 dup(06H), 19 dup(0H), 1 dup(06H), 73 dup(0H), 5 dup(06H), 3 dup(0H), 3 dup(06H), 20 dup(0H), 3 dup(06H), 3 dup(0H), 5 dup(06H), 8 dup(0H), 3 dup(06H), 6 dup(0H), 6 dup(06H), 19 dup(0bH)        
            db 18 dup(0bH), 6 dup(06H), 8 dup(0H), 16 dup(06H), 17 dup(0bH), 6 dup(06H), 6 dup(0H), 17 dup(06H), 11 dup(0H), 17 dup(06H), 12 dup(0H), 11 dup(06H), 16 dup(0bH), 3 dup(06H), 67 dup(0bH), 11 dup(06H), 1 dup(0H), 9 dup(06H), 11 dup(0bH), 28 dup(06H), 2 dup(0H), 11 dup(06H), 16 dup(0bH)      
            db 15 dup(0bH), 37 dup(06H), 10 dup(0bH), 83 dup(06H), 13 dup(0bH), 7 dup(06H), 64 dup(0bH), 24 dup(06H), 6 dup(0bH), 47 dup(06H), 14 dup(0bH)     
            db 54 dup(06H), 6 dup(0bH), 86 dup(06H), 11 dup(0bH), 11 dup(06H), 53 dup(0bH), 34 dup(06H), 4 dup(0bH), 61 dup(06H) 
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            db 320 dup(06H)
            
                 
    btn_jogar db "JOGAR  "
    btn_sair db "SAIR  "
    nave_atual db 0 ; 0 -> nave aliada, 1 -> nave inimiga
    
    score db "SCORE: "
    tempo db "TEMPO: "
    
    
    opc_selecionada db 0 ; utilizado no contexto do menu, 0 -> Jogar, 1 -> Sair
    tela_atual db 0 ; 0 -> menu, 1 -> setor 1, 2 -> setor 2, 3 -> setor 3, 4 -> fim

    qtd_px_mov_naves dw 5
    
    frame_time equ 16667 ; tempo entre alteracoes dos elementos
    sector_show_time dw 003Dh, 0900h ; tempo da escrita do setor (4s em micro seg)
    sector_temp_total equ 11
    
    contador_frames db 0
    cronometro_sector db ?
    
.code 

pinta_pixel proc
    push BX
    
    push DX
    push AX
    
    mov BX, 320
    mov AX, DX
    mul BX
    mov BX, AX
    
    pop AX
    pop DX
    
    add BX, CX
    mov SI, BX
    
    mov ES:[SI], AL
    
    pop BX
    ret
endp



MOVE_HORIZONTAL_ESQUERDA proc
    push ax
    push bx ;posicao na memoria do elemento
    push cx
    push si
    push di
    
    ;push bx
    
    ;; cmp bx, limite_esquerda nao usar (sera 0 e 320)
    ;;jbe FIM_MOVE_HORIZONTAL
    mov ax, memoria_video
    mov ds, ax
    
    mov dx, 10       ; N?mero de linhas para mover
    mov si, bx       
    mov di, bx       
    sub di, 2    ; Move x pixeis horizontalmente
    ;push di          ; Empilha poder salvar a nova posi??o da nave
    
MOVE_HORIZONTAL_ESQUERDA_LOOP:
    mov cx, 15       ; Largura
    rep movsb        
    dec dx           
    add di, 305      ; Pula para a linha anterior
    add si, 305     
    cmp dx, 0        
    jnz MOVE_HORIZONTAL_ESQUERDA_LOOP
      
    
    ; Limpar a area deixada para tras com pixel preto
    mov dx, 10       ; numero de linhas
    mov di, bx       ; Posicao inicial do desenho original
    add di, 13       ; (15 - pixeis movendo)
    xor al, al      ; pixel preto
    cld
LIMPAR_DIREITA:
    mov cx, 2        ; Largura para apagar
    rep stosb        ; Preenche com o que esta em AL
    dec dx           
    add di, 318      ; (320 - pixeis movendo)  
    cmp dx, 0        
    jnz LIMPAR_DIREITA
    
    ;pop di           ; Desempilha a nova posi??o da nave
    ;mov bx, di       ; Atualiza BX com a nova posi??o da nave
    
    mov ax, @data
    mov ds, ax
    
    ;mov posicao_nave, bx

FIM_MOVE_HORIZONTAL_ESQUERDA:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
endp

MOVE_HORIZONTAL_DIREITA proc
    push ax
    push bx ; Posi??o na mem?ria do elemento
    push cx
    push si
    push di
    
    mov ax, memoria_video
    mov ds, ax
    
    mov dx, 10       ; N?mero de linhas para mover
    mov si, bx       
    mov di, bx       
    add di, 2        ; Move x pixels para a direita
    std              ; Define a dire??o decrescente para o movsb
MOVE_HORIZONTAL_DIREITA_LOOP:
    mov cx, 15       ; Largura do desenho
    rep movsb        
    dec dx           
    add di, 335      ; Pula para a pr?xima linha na tela
    add si, 335    
    cmp dx, 0        
    jnz MOVE_HORIZONTAL_DIREITA_LOOP

    ; Limpar a ?rea deixada para tr?s com pixels da cor de fundo
    mov dx, 10       ; N?mero de linhas para limpar
    mov di, bx       ; Posi??o inicial do desenho original
    sub di, 13       ; (15 - pixeis movendo)
    xor al, al       ; pixel preto
    std              ; Restaura para dire??o desc
LIMPAR_ESQUERDA:
    mov cx, 2        ; Largura para apagar
    rep stosb        ; Preenche a ?rea com a cor de fundo
    dec dx           
    add di, 322      ; Pula para a pr?xima linha na tela (320 + pixeis movendo)
    cmp dx, 0         
    jnz LIMPAR_ESQUERDA

    ; Restaura o segmento de dados original
    mov ax, @data
    mov ds, ax
    
FIM_MOVE_HORIZONTAL_DIREITA:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
endp
encerra proc
    mov ah, 1h      ;muda configuaracao e
    int 16h         ;verifica se ha tecla no buffer quando entra
    jz acaba        ;se nao houver, pode encerrar
limpeza:
    xor ah,ah       ;se houver tecla no buffer, muda a configuracao e
    int 16h         ;limpa o buffer
    mov ah, 1h      ;muda configuaracao e
    int 16h         ;verifica se ha mais uma tecla no buffer
    jz acaba        ;se nao houver, pode encerrar
    jmp limpeza     ;se houver, continua limpando o buffer

acaba:
    mov ah, 4ch     
    int 21h         ;interrupcao para encerrar o programa
    ret
endp 

POS_CURSOR proc
    push ax
    push bx
    mov ah, 02                   
    int 10h
    pop bx
    pop ax
    ret
endp

; Ler alguam tecla
; retorna em AL
LER_TECLA proc
    mov AH, 1
    int 16h
    JZ SAIR

LER_TECLA_BUFFER:
    mov AH, 0
    int 16h
    
SAIR:
    ret
endp


ESCREVE_STRING proc
    push ES
    push BX
    push BX
    
    mov BX, DS
    mov ES, BX
    
    mov AH, 13h
    mov AL, 01h
    pop BX
    xor BH, BH
    
    int 10h
    
    pop BX
    pop ES
    ret
endp

ESC_CHAR proc
    push AX
    mov AH, 02H
    int 21H
    pop AX
    ret    
             
endp

; escreve na tela o valor armazenado em AX
ESC_UINT16 proc
    push AX
    push BX
    push CX
    push DX
    
    mov BX, 10    
    xor CX, CX
    
    cmp AX, 10
    jnl LACO_DIGITO
    mov DL, '0'
    call ESC_CHAR
    
  LACO_DIGITO:    
    xor DX, DX         
    div BX
    
    push DX
       
    inc CX
    
    cmp AX, 0   
        
    jnz LACO_DIGITO
                          
     
  LACO_ESCRITA:                    
    pop DX
    add DL, '0'
    call ESC_CHAR
    dec CX
    cmp CX, 0
    jnz LACO_ESCRITA
          
          
    pop DX
    pop CX
    pop BX
    pop AX
       
    ret
endp

INICIA_VIDEO proc
    push AX
    
    xor AH, AH      ;zera AH
    mov AL, 13h     ;configura modo de video
    
    int 10h         ;chama modo de video do sistema
    
    pop AX
    ret
endp  

;Desenha quadrado
; BL cor
; DH linha inicial
; DL coluna inicial
; Largura CX  
DESENHA_BOTAO_MENU proc

    ; escreve o texto do botao
    call ESCREVE_STRING
    
    push AX    
    push BX
    push DX
    push CX
    
    mov CX, 7   ;Largura do botao
    dec DH      ; linha (com dec acaba 'subindo' uma linha)
    sub DL, 2   ; coluna
    
    xor BH, BH
    
    ;Canto superior/esquerdo
    call POS_CURSOR
    mov AL, 218     
    mov CX, 1
    mov AH, 0AH
    int 10h
    ;FIM
    
    inc DL
    
    ;reta Horizontal Superior CX vezes
    call POS_CURSOR
    mov AL, 196
    
    pop CX
    push CX
    
    mov AH, 0AH
    int 10h
    ;FIM
    
    add DL, CL
    
    ;Canto superior/direito
    call POS_CURSOR
    mov AL, 191 
    mov CX, 1
    mov AH, 0AH
    int 10h
    ;FIM
    
    inc DH
    
    ;Barra direita
    call POS_CURSOR
    mov AL, 179 
    mov CX, 1
    mov AH, 0AH
    int 10h
    ;FIM
    
    inc DH
    
    ;Canto inferior direito
    call POS_CURSOR
    mov AL, 217 ;reta
    mov CX, 1
    mov AH, 0AH
    int 10h
    ;FIM
    
    pop CX
    push CX
    
    inc CX
    
    ;Reta Inferior
    sub DL, CL
    
    call POS_CURSOR
    mov AL, 196  
    mov AH, 0AH
    int 10h
    
    mov CX, 1
    mov AL, 192  
    mov AH, 0AH
    int 10h
    
    dec DH
    call POS_CURSOR
    mov CX, 1
    mov AL, 179  
    mov AH, 0AH
    int 10h
     
    pop CX
    pop DX
    pop BX
    pop AX
    ret
endp

DESENHA_BOTOES_MENU proc

    push BX
    push CX
    push DX

    cmp opc_selecionada, 0
    je JOGAR_SELEC
    
    mov DH, 17
    mov DL, 18
    mov CX, 7
    mov BL, branco
    mov BP, OFFSET btn_jogar
    call DESENHA_BOTAO_MENU
    
    mov DH, 20
    mov CX, 7
    mov BL, vermelho_claro
    mov BP, OFFSET btn_sair
    call DESENHA_BOTAO_MENU
    jmp FIM
    
JOGAR_SELEC:
    mov DH, 17
    mov DL, 18
    mov CX, 7
    mov BL, vermelho_claro
    mov BP, OFFSET btn_jogar
    call DESENHA_BOTAO_MENU
    
    mov DH, 20
    mov CX, 7
    mov BL, branco
    mov BP, OFFSET btn_sair
    call DESENHA_BOTAO_MENU
    
FIM:
    
    pop DX
    pop CX
    pop BX

    ret
endp


; recebe em CX:DX o tempo de espera
SLEEP proc 
    push CX                 ;salva contexto
    push DX             
    push AX             
      
    ;xor CX, CX              ;zera CX, pois o tempo e definido por CX:DX
    ;mov DX, frame_time      ;espera 16667 microsegundos, assim ha 60 frames por segundo
    mov AH, 86h             ;configura o modo de espera
    int 15h                 ;chama a espera no sistema
    
    pop AX
    pop DX
    pop CX
    ret
endp

MOVE_NAVES_MENU proc 
    cmp nave_atual, 0
    je MOVER_NAVE_ALIADA
    
MOVER_NAVE_INIMIGA:
    call MOVE_HORIZONTAL_ESQUERDA
    sub bx, 2
    xor cx, cx
    mov dx, frame_time
    call SLEEP
    jmp CHECA_NAVE
    
MOVER_NAVE_ALIADA:
    call MOVE_HORIZONTAL_DIREITA
    add bx, 2
    xor cx, cx
    mov dx, frame_time
    call SLEEP
    
CHECA_NAVE:
    cmp nave_atual, 0
    je CMP_NAVE_ALIADA
   
    cmp bx, 34886
    jle DESENHA_NAVE_ALIADA
    jmp SAIR_MOVE_NAVES_MENU
    
CMP_NAVE_ALIADA:
    cmp bx, 35197
    jge DESENHA_NAVE_INIMIGA
    
    jmp SAIR_MOVE_NAVES_MENU
    
DESENHA_NAVE_ALIADA:
    xor BX, BX
    mov CX, 2 ; coluna
    mov DX, 110 ; linha
    mov BL, branco
    mov SI, offset nave_aliada
    call DESENHA_ELEMENTO_15X9
    mov byte ptr [nave_atual], 0
    mov bx, 34896 ; posicao do desenho na memoria de video aliada
    jmp SAIR_MOVE_NAVES_MENU
    
DESENHA_NAVE_INIMIGA:
    xor BX, BX
    mov CX, 304 ; coluna
    mov DX, 110 ; linha
    mov BL, -1
    mov SI, offset nave_inimiga
    call DESENHA_ELEMENTO_15X9
    mov byte ptr [nave_atual], 1
    mov bx, 35185 ; posicao do desenho na memoria de video inimiga
    
SAIR_MOVE_NAVES_MENU:
    ret
endp

DESENHA_MENU proc
    mov DH, 0
    mov DL, 0
    mov CX, 400
    mov BL, verde
    mov BP, OFFSET titulo
    call ESCREVE_STRING
    
    call DESENHA_BOTOES_MENU
    ;jmp DESENHA_NAVE_ALIADA
    
    mov CX, 2 ; coluna
    mov DX, 110 ; linha
    mov BL, branco
    mov SI, offset nave_aliada
    call DESENHA_ELEMENTO_15X9
    mov byte ptr [nave_atual], 0
    mov BX, 34896 ; posicao do desenho na memoria de video aliada

MENU:
    call MOVE_NAVES_MENU
    call LER_TECLA
    cmp AH, arrow_down
    je MUDA_PARA_SAIR
    cmp AH, arrow_up
    je MUDA_PARA_JOGAR
    cmp AL, enter
    je APERTA_BOTAO
    
    jmp MENU
    
MUDA_PARA_SAIR:
    cmp opc_selecionada, 1
    je MENU
    mov opc_selecionada, 1
    call DESENHA_BOTOES_MENU
    jmp MENU
    
MUDA_PARA_JOGAR:
    cmp opc_selecionada, 0
    je MENU
    mov opc_selecionada, 0
    call DESENHA_BOTOES_MENU
    jmp MENU
    
APERTA_BOTAO:
    cmp opc_selecionada, 0
    jne FIM_DESENHA_MENU
    
    call INICIO_JOGO
    
FIM_DESENHA_MENU:
    ret
endp

LIMPAR_TELA proc
    mov AX, memoria_video
    mov ES, AX
    mov DI, 0
    
    mov AL, 0h
    mov CX, 64000
    
    rep stosb
    
    ret
endp

DESENHA_HEADER proc
    mov BP, OFFSET score
    mov DH, 0
    mov DL, 0
    mov CX, 7
    mov BL, branco
    call ESCREVE_STRING
    
    mov BP, OFFSET tempo
    mov DH, 0
    mov DL, 31
    mov CX, 7
    mov BL, branco
    call ESCREVE_STRING

    mov AX, word ptr cronometro_sector

    call ESC_UINT16
    
    ret
endp

DESENHA_VIDAS proc
    push BX
    push CX
    push DX
    push SI
    push AX
              
    mov CX, 8           ; 8 elementos no array "vidas"
    xor AX, AX
    mov AX, 20 ; posicao (linha) da primeira nave 

loop_vidas:
    xor SI, SI          ; Zera SI, necess?rio para a fun??o de desenho
    xor BX, BX          ; Zera BX, que ser? usado para a cor
    mov DI, CX          
    dec DI
              
    mov DX, AX      ; DX recebe a linha onde a nave sera desenhada
    
    ; caso a nave ja river sido destruida, nao desenha a mesma
    mov BL, [vidas + DI]
    cmp BL, 0
    je PULA_LOOP_VIDAS
    
    ; Carrega a cor correspondente da nave em "cor_vida" no ?ndice DI
    mov BL, [cor_vida + DI]  ; BL recebe a cor da nave

    push CX
    mov CX, 0          ; Coluna 0 para todas as naves

    mov SI, offset nave_aliada   
    call DESENHA_ELEMENTO_15X9   ; Chama a funcao para desenhar a nave
    pop CX
    
PULA_LOOP_VIDAS:
    add AX, 19 ; 10 de espaco entre naves + 9 da altura da mesma
    loop loop_vidas

    pop AX
    pop SI
    pop DX
    pop CX
    pop BX
    ret
endp

DESENHA_CENARIO proc
    mov ax, memoria_video       ; Segmento de mem?ria de v?deo (modo gr?fico 13h)
    mov es, ax           ; Aponta ES para o segmento de v?deo

    mov si, offset cenario ; Aponta SI para o in?cio do vetor cenario
    mov di, 57600            ; Offset na mem?ria de v?deo (in?cio de A000:0000)

    mov cx, 6400         ; 9600 pixels (correspondente ao tamanho total de seu vetor, supondo que s?o pixels)

    draw_loop:
        lodsb            ; Carrega o pr?ximo byte de DS:SI (vetor 'cenario') no AL
        stosb            ; Armazena o valor de AL diretamente em ES:DI (pixel na tela)
        loop draw_loop   ; Repetir at? escrever todos os pixels

ret
    

    ret
endp

; testar e mostrar se venceu ou perdeu. 
; deixar o usuario escolher se joga de novo ou sai
VENCEU_PERDEU proc

    call LIMPAR_TELA

    mov AH, 4Ch
    int 21h
    ret
endp

; setar qual tela esta (1,2,3)
MOSTRA_SETOR proc

    cmp tela_atual, 1
    je PRINTA_SET_1

    cmp tela_atual, 2
    je PRINTA_SET_2
    
    cmp tela_atual, 3
    je PRINTA_SET_3
    
    call VENCEU_PERDEU

PRINTA_SET_1: 
    mov BP, OFFSET setor_1
    mov BL, ciano_claro
    jmp PRINTA_E_SAI
    
PRINTA_SET_2:
    mov BP, OFFSET setor_2
    mov BL, azul_claro
    jmp PRINTA_E_SAI
    
PRINTA_SET_3:
    mov BP, OFFSET setor_3
    mov BL, magenta_claro
    
PRINTA_E_SAI:
    call LIMPAR_TELA
    
    ; Centralizar o texto
    mov DH, 9          ; Linha inicial = 9 (meio vertical da tela para altura de 6 linhas)
    mov DL, 0          ; Coluna inicial = 0 (texto tem 40 caracteres de largura)
    mov CX, 240        ; N?mero de caracteres a escrever (40 x 6)
    
    call ESCREVE_STRING
    
    mov CX, [sector_show_time]
    mov DX, [sector_show_time + 2]
    call SLEEP
    
    call LIMPAR_TELA
    ret
endp

MOVE_NAVE_BAIXO proc
    push ax
    push bx
    push cx
    push si
    push di
    
    mov bx, nave_principal
    
    cmp bx, limite_inferior  ; Verifica se a nave atingiu o limite inferior
    jae FIM_MOVE_NAVE_BAIXO  ; Se j? atingiu o limite inferior, n?o move a nave

    mov ax, memoria_video
    mov ds, ax
    
    mov dx, 15         ; N?mero de linhas para mover
    mov si, bx         
    mov di, bx    
    add di, velocidade_nave_principal       ; Move 5 linha para baixo
    push di            ; Empilha para salvar a nova posi??o da nave
    
    add di, 2880       ; inicio da ultima linha da nave
    add si, 2880
MOVE_NAVE_BAIXO_LOOP:
    mov cx, 15         ; Largura
    rep movsb          
    dec dx             
    sub di, 335        ; Proxima linha
    sub si, 335        
    cmp dx, 0         
    jnz MOVE_NAVE_BAIXO_LOOP

    pop di            
    mov bx, di         
    
    mov ax, @data
    mov ds, ax
    
    mov nave_principal, bx 

FIM_MOVE_NAVE_BAIXO:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
endp

MOVE_NAVE_CIMA proc
    push ax
    push bx
    push cx
    push si
    push di
    
    mov bx, nave_principal
    
    cmp bx, limite_superior
    jbe FIM_MOVE_NAVE_CIMA
    
    mov ax, memoria_video
    mov ds, ax
    
    mov dx, 15       ; Numero de linhas para mover
    mov si, bx       
    mov di, bx   
    ;mov ax, velocidade_nave_principal
    sub di, velocidade_nave_principal     ; Move x linhas para cima
    push di          ; Empilha poder salvar a nova posi??o da nave
    
MOVE_NAVE_CIMA_LOOP:
    mov cx, 15       ; Largura
    rep movsb        
    dec dx           
    add di, 305      ; Pula para a linha anterior
    add si, 305     
    cmp dx, 0        
    jnz MOVE_NAVE_CIMA_LOOP
    
    pop di           ; Desempilha a nova posi??o da nave
    mov bx, di       ; Atualiza BX com a nova posi??o da nave
    
    mov ax, @data
    mov ds, ax
    
    mov nave_principal, bx

FIM_MOVE_NAVE_CIMA:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
endp

INICIO_JOGO proc
    mov [tela_atual], 0
    
PROXIMO_SETOR:
    inc [tela_atual]
    call MOSTRA_SETOR
    mov [cronometro_sector], sector_temp_total
    mov [contador_frames], 0
    
    mov CX, 47 ; coluna
    mov DX, 95 ; linha
    mov BL, branco
    mov SI, offset nave_aliada
    call DESENHA_ELEMENTO_15X9
    mov [nave_principal], 30447 ; posicao do desenho na memoria de video aliada
    
LOOP_JOGO:
    call DESENHA_HEADER
    call DESENHA_VIDAS
    call DESENHA_CENARIO
    
    call LER_TECLA
    cmp AH, arrow_down
    je APERTOU_BAIXO
    cmp AH, arrow_up
    je APERTOU_CIMA
    cmp AH, espaco
    je APERTOU_ESPACO
    jmp REPE_JOGO

APERTOU_BAIXO:
    call MOVE_NAVE_BAIXO
    jmp REPE_JOGO

APERTOU_CIMA:
    call MOVE_NAVE_CIMA
    jmp REPE_JOGO

APERTOU_ESPACO:
    ;call ATIRAR
    
    
REPE_JOGO:
    xor cx, cx
    mov dx, frame_time
    call SLEEP
    
    inc [contador_frames]
    cmp [contador_frames], 40
    jne JMP_JOGO
    
    mov [contador_frames], 0
    dec [cronometro_sector]
    cmp [cronometro_sector], 0
    je PROXIMO_SETOR
    
JMP_JOGO: 
    jmp LOOP_JOGO
    ret
endp


; Funcao generica para desenhar objetos
; SI: Posicao desenho na memoria
; DI: Posicao do primeiro pixel do desenho no video
; CX coluna inicial
; DX linha inicial
; BL cor
DESENHA_ELEMENTO_15X9 proc
    push DX
    push AX
    push DI
    push SI
    push BX
    push CX
    
    cmp BL,0
    jl DESENHA_COM_COR
    
    push SI
    mov CX, 135 ;Tamanho total do vetor(15*9 = 135)
    
MUDA_COR_LOOP:
    lodsb
    cmp AL, 0
    je PULA_BYTE
    mov [SI - 1], BL
    
PULA_BYTE:
    loop MUDA_COR_LOOP
    
    pop SI
    
DESENHA_COM_COR:
    pop CX
    mov AX, memoria_video
    mov ES, AX

    mov AX, DX                
    mov BX, 320               
    mul BX                    
    add AX, CX                
    mov DI, AX                

    mov BX, 15                
    mov DX, 9                 
              
    cld
              
DESENHA_ELEMENTO_LOOP:
    mov CX, BX                
    rep movsb                 
    add DI, 320 - 15          ; move DI para o in?cio da pr?xima linha (offset de 320 menos 15 pixels desenhados)
    dec DX                    
    jnz DESENHA_ELEMENTO_LOOP 

    pop BX
    pop SI
    pop DI 
    pop AX
    pop DX
    ret
endp

INICIO:
    mov AX, @data
    mov DS, AX
    mov ES, AX
    
    call INICIA_VIDEO
    mov [tela_atual], 0  
    call DESENHA_MENU
    
    mov AH, 4Ch
    int 21h
    
        
end INICIO
