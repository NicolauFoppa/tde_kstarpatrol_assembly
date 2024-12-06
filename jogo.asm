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
    espaco EQU 20h

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
                 
      tiro db 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0,0
           db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
           db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
           db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
           db 0,0,0,0,0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh
           db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
           db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
           db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
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
    
       cenario db 55 dup(0H), 23 dup(06H), 46 dup(0H), 21 dup(06H), 37 dup(0H), 21 dup(06H), 112 dup(0H), 21 dup(06H), 31 dup(0H), 21 dup(06H), 28 dup(0H), 21 dup(06H), 43 dup(0H)  
            db 30 dup(0H), 9 dup(06H), 23 dup(0H), 15 dup(06H), 31 dup(0H), 10 dup(06H), 25 dup(0H), 10 dup(06H), 32 dup(0H), 11 dup(06H), 131 dup(0H), 9 dup(06H), 12 dup(0H), 10 dup(06H), 34 dup(0H), 10 dup(06H), 17 dup(0H), 8 dup(06H), 15 dup(0H), 9 dup(06H), 29 dup(0H)  
            db 27 dup(0H), 9 dup(06H), 17 dup(0H), 18 dup(06H), 25 dup(0H), 9 dup(06H), 15 dup(0H), 7 dup(06H), 8 dup(0H), 9 dup(06H), 25 dup(0H), 15 dup(06H), 25 dup(0H), 6 dup(06H),7 dup(0H), 6 dup(06H), 24 dup(0H), 6 dup(06H), 78 dup(0H), 10 dup(06H), 8 dup(0H), 8 dup(06H), 25 dup(0H), 8 dup(06H), 8 dup(0H), 10 dup(06H), 13 dup(0H), 8 dup(06H), 11 dup(0H), 11 dup(06H), 24 dup(0bH)        
            db 26 dup(0bH), 13 dup(06H), 16 dup(0H), 23 dup(06H), 24 dup(0bH), 13 dup(06H), 13 dup(0H), 24 dup(06H), 17 dup(0H), 23 dup(06H), 19 dup(0H), 17 dup(06H), 23 dup(0bH), 10 dup(06H), 74 dup(0bH), 18 dup(06H), 8 dup(0H), 16 dup(06H), 18 dup(0bH), 35 dup(06H), 9 dup(0H), 18 dup(06H), 23 dup(0bH)      
            db 31 dup(0bH), 52 dup(06H), 25 dup(0bH), 98 dup(06H), 28 dup(0bH), 21 dup(06H), 78 dup(0bH), 38 dup(06H), 20 dup(0bH), 61 dup(06H), 28 dup(0bH)     
            db 73 dup(06H), 24 dup(0bH), 104 dup(06H), 29 dup(0bH), 29 dup(06H), 71 dup(0bH), 51 dup(06H), 21 dup(0bH), 78 dup(06H) 
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)
            db 480 dup(06H)

            
    blank_space db 135 dup(0)
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
    sector_temp_total equ 5
    
    tiro_exist dw 0 ; caso seja 0 o nao existe nenhum tiro e pode atirar
    tiro_desl dw 0 ; controla o deslocamento do tiro
    
    contador_frames db 0
    cronometro_sector db ?
    desloc_cen dw 0
    
    pont_total dw 0
    pont_sector dw 0
    inimigas_vivas_sector db 0 ; usado para controlar a qtd de naves simultaneas em cada setor
    inimigas_escaparam_sector db 0 ; usado para calcular reducao de pontuacao ao passar de setor
    
    venceu db 0 ; quando todas vidas acabarem, perdeu
    
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

; parametros para mover a nave
;    mov SI, [pos_inicial_naves_menu] ; passa para SI a posicao inicial da nave
;    mov DI,SI
;    inc DI ; DI recebe a posicao incrementada para realizar a movimentacao
;    xor DX, DX ; zera DX (movimentacao para a direita)
;    call MOVE_HORIZONTAL ; rotina de movimenta??o

MOVE_HORIZONTAL proc
    push AX
    push CX
    push DS ; guarda registradores
    
    mov AX, ES 
    mov DS, AX ; move inicio da memoria de video para DS
    mov CX, 9
    
    cmp DX, 0   ; verifica se a movimentacao eh para a esquerda (DX==0) ou para a direita (DX==1)
    jne ESQUERDA
    std ; DF=1 (movimentacao sera da esquerda para a diretia)
    
    MOVE_DIREITA:   ; laco que movimenta para a direita
    push CX         ; guarda CX
    mov CX, 16      ; ira repetir 16 vezes a instrucao seguinte (a nave tem 15 pixels de largura, e precisa ainda mover o pixel preto)
    rep movsb       ; realiza a movimentacao (copia [DS:SI] para [ES:DI])
    add SI, 336     
    add DI, 336     ; vao para a proxima linha
    pop CX          ; recupera CX (para descontar do loop MOVE_DIREITA)
    loop MOVE_DIREITA
    jmp CONTINUA_MOVE_HORIZONTAL    
   
    ESQUERDA: ; mesma funcionalidade do segmento anterior, porem, movimentacao eh da direita para a esquerda
    cld
    MOVE_ESQUERDA:
    push CX
    mov CX, 16
    rep movsb
    add SI, 304
    add DI, 304
    pop CX
    loop MOVE_ESQUERDA
    
    CONTINUA_MOVE_HORIZONTAL:
    
    pop DS
    pop CX
    pop AX ; recupera registradores
    ret
endp

DESENHA_ELEMENTO_15X9_TOTAL proc

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
    mov SI, BX
    mov DI, BX
    sub DI, 2
    mov DX, 1
    call MOVE_HORIZONTAL
    sub bx, 2
    xor cx, cx
    mov dx, frame_time
    call SLEEP
    jmp CHECA_NAVE
    
MOVER_NAVE_ALIADA:
    mov SI, BX
    mov DI, BX
    add DI, 2
    xor DX, DX
    call MOVE_HORIZONTAL
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
    mov DX, 109 ; linha
    mov BL, branco
    mov SI, offset nave_aliada
    call DESENHA_ELEMENTO_15X9
    mov byte ptr [nave_atual], 0
    mov bx, 34895 ; posicao do desenho na memoria de video aliada
    jmp SAIR_MOVE_NAVES_MENU
    
DESENHA_NAVE_INIMIGA:
    xor BX, BX
    mov CX, 304 ; coluna
    mov DX, 109 ; linha
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
    mov DX, 109 ; linha
    mov BL, branco
    mov SI, offset nave_aliada
    call DESENHA_ELEMENTO_15X9
    mov byte ptr [nave_atual], 0
    mov BX, 34895 ; posicao do desenho na memoria de video aliada

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
    call encerra
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
    
    mov AX, word ptr pont_sector

    call ESC_UINT16
    
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
    mov es, ax                  ; Aponta ES para o segmento de v?deo

    mov si, offset cenario      ; Aponta SI para o in?cio do vetor cenario
    add si, desloc_cen          ; Desloca o ponteiro para o valor correto do cen?rio

    cmp tela_atual, 1           ; Se tela_atual == 1, imprime o cen?rio original
    je PRINTA_CENARIO

    cmp tela_atual, 2           ; Se tela_atual == 2, altera a cor para um valor diferente
    je ALTERA_COR_CENARIO_2

    cmp tela_atual, 3           ; Se tela_atual == 3, altera a cor para outro valor
    je ALTERA_COR_CENARIO_3

PRINTA_CENARIO:
    mov di, 57920
    mov dx, 20
desenha_linha_ter:
    mov cx, 320
    rep movsb
    
    add si, 160
    dec dx
    jnz desenha_linha_ter
    ret
    
DRAW_LOOP:
    lodsb                       ; Carrega o pr?ximo byte de DS:SI (vetor 'cenario') no AL
    stosb                       ; Armazena o valor de AL diretamente em ES:DI (pixel na tela)
    loop DRAW_LOOP              ; Repete at? desenhar todos os pixels
    ret

ALTERA_COR_CENARIO_2:
    mov di, 57920               ; Offset na mem?ria de v?deo
    mov cx, 6400                ; N?mero de pixels
    mov bl, 04h                 ; Nova cor (exemplo: 04h - vermelho claro)

CHANGE_COLOR_LOOP_2:
    lodsb                       ; Carrega o pr?ximo byte de DS:SI
    cmp al, 06h                 ; Verifica se o pixel atual tem a cor 06h (por exemplo, cor do cen?rio)
    jne SKIP_COLOR_CHANGE_2     ; Se n?o for a cor 06h, pula a altera??o
    mov al, bl                  ; Altera a cor para 04h (vermelho claro)
SKIP_COLOR_CHANGE_2:
    stosb                       ; Escreve o valor atualizado (ou original) em ES:DI
    loop CHANGE_COLOR_LOOP_2    ; Repete o loop at? processar todos os pixels
    ret

ALTERA_COR_CENARIO_3:
    mov di, 57920               ; Offset na mem?ria de v?deo
    mov cx, 6400                ; N?mero de pixels
    mov bl, 0Ah                 ; Nova cor (exemplo: 0Ah - verde claro)

CHANGE_COLOR_LOOP_3:
    lodsb                       ; Carrega o pr?ximo byte de DS:SI
    cmp al, 06h                 ; Verifica se o pixel atual tem a cor 06h
    jne SKIP_COLOR_CHANGE_3     ; Se n?o for a cor 06h, pula a altera??o
    mov al, bl                  ; Altera a cor para 0Ah (verde claro)
SKIP_COLOR_CHANGE_3:
    stosb                       ; Escreve o valor atualizado (ou original) em ES:DI
    loop CHANGE_COLOR_LOOP_3    ; Repete o loop at? processar todos os pixels
    ret

ENDP

MOVIMENTA_CENARIO proc
    push AX
    push SI

    xor AX, AX
    add desloc_cen, 3           ; Incrementa o deslocamento em 2 (movimento horizontal)

    cmp desloc_cen, 320         ; Se desloc_cen >= 320, reseta o cen?rio
    jl continua_movimento       ; Se desloc_cen < 320, continua o movimento

    mov desloc_cen, 0           ; Reseta o deslocamento ao ultrapassar o limite

continua_movimento:
    call DESENHA_CENARIO        ; Chama a fun??o para desenhar o cen?rio atualizado
    pop si
    pop ax
    ret
ENDP

; testar e mostrar se venceu ou perdeu. 
; deixar o usuario escolher se joga de novo ou sai
VENCEU_PERDEU proc

    call LIMPAR_TELA
    
    cmp [venceu], 1
    jne GAME_OVER
    
    mov AX, [pont_total]
    call ESC_UINT16
    
    ; venceu
    
    jmp ESPERA_TECLA
    
GAME_OVER:
    
ESPERA_TECLA:
    
    mov AH, 0
    int 16h
    
    call DESENHA_MENU
    
    ret
endp

;recebe em AX o valor do bonus
;recebe em DX o valor da penalidade por nave escapar
CALCULA_BONUS_SETOR proc

    cmp AX, 0
    je CALC_PENALIDADE

    mov CX, 8 ; qtd de vidas totais

loop_bonus_setor:
    mov DI, CX          
    dec DI
             
    mov BL, [vidas + DI]
    cmp BL, 0
    je PULA_LOOP_BONUS
    
    add [pont_total], AX
    
PULA_LOOP_BONUS:
    loop loop_bonus_setor
    
CALC_PENALIDADE:
    mov AX, word ptr [inimigas_escaparam_sector]
    mul DX
    sub [pont_total], AX
    
    ; soma da pontuacao do setor na pont total
    mov CX, [pont_sector]
    add [pont_total], CX
    
    ret

endp

; setar qual tela esta (1,2,3)
MOSTRA_SETOR proc

    mov [tiro_exist], 0
    mov [tiro_desl], 0

    cmp tela_atual, 1
    je PRINTA_SET_1

    cmp tela_atual, 2
    je PRINTA_SET_2
    
    cmp tela_atual, 3
    je PRINTA_SET_3
    
    xor AX, AX
    mov DX, 30
    call CALCULA_BONUS_SETOR
    
    mov [venceu], 1
    call VENCEU_PERDEU

PRINTA_SET_1: 
    mov BP, OFFSET setor_1
    mov BL, ciano_claro
    jmp PRINTA_E_SAI
    
PRINTA_SET_2:
    mov AX, 1000
    mov DX, 10
    call CALCULA_BONUS_SETOR
    
    mov BP, OFFSET setor_2
    mov BL, azul_claro
    jmp PRINTA_E_SAI
    
PRINTA_SET_3:
    mov AX, 2000
    mov DX, 20
    call CALCULA_BONUS_SETOR
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

     apaga_tiro proc
            push ax
            push si

            mov BX, tiro_exist

            mov DX, offset blank_space
            mov BX, tiro_exist
            call DESENHA_TIRO

            pop si
            pop ax
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
ATIRAR proc
    push AX
    push SI
    
    mov BX, tiro_exist         ; A posi??o do tiro ser? armazenada em BX
    cmp BX, 0                  ; Verifica se o tiro deve ser disparado
    jne retorna                 ; Se al == 0, n?o faz nada

    mov AX, nave_principal     ; Carrega a posi??o da nave
    add AX, 15                 ; Ajusta para a posi??o de disparo (acima da nave)
    mov tiro_exist, AX
    mov BX, tiro_exist         ; Armazena a posi??o do tiro
    mov DX, offset tiro
    
    ; Defina a posi??o inicial do tiro no gr?fico (BX ? a posi??o na tela)
    ; Aqui voc? pode ajustar a posi??o horizontal (ex: nave no meio da tela)
  

    ; Agora chamamos DESENHA_TIRO para desenhar o tiro na tela
    call DESENHA_TIRO          ; Desenha o tiro

retorna:
    pop SI
    pop AX
    ret
endp

DESENHA_TIRO proc
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    push ds
    
    ; Carrega o segmento de dados
    mov ax, @data
    mov ds, ax

    ; Carrega o segmento de mem?ria de v?deo (modo gr?fico 320x200)
    mov ax, 0A000h
    mov es, ax

    ; BX cont?m a posi??o do tiro
    mov di, BX               ; DI = Posi??o na tela (mem?ria de v?deo)

    ; SI cont?m o endere?o da sprite do tiro
    mov si, DX       ; SI aponta para a sprite do tiro (vetor de 15x9 pixels)

    ; N?mero de linhas da sprite (altura da sprite)
    mov dx, 9                 ; A sprite tem 9 linhas

desenha_linha:
    ; Define quantos bytes mover por linha (15 bytes por linha)
    mov cx, 15

    ; Copiar 15 bytes da sprite para a mem?ria de v?deo
    rep movsb

    ; Ajustar o ponteiro de destino para a pr?xima linha (avan?a 320 bytes)
    ; Isso ? feito somando 320 - 15 bytes (para corrigir a largura da tela)
    add di, 320 - 15

    ; Diminuir o contador de linhas e repetir
    dec dx
    jnz desenha_linha

    ; Restaurar DS original
    pop ds  
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

   MOVIMENTA_TIRO proc
            push ax 
            xor ax,ax
            mov ax, tiro_exist
            cmp ax, 0
            je semTiro

                xor bx,bx
                call apaga_tiro
                xor ax,ax
                mov ax, tiro_desl
                cmp ax, 240
                jge parede1          
                xor ax,ax
                mov ax, tiro_exist
                add ax, 8
                mov tiro_exist, ax 
                mov DX, offset tiro
                mov BX, tiro_exist
                call DESENHA_TIRO
                xor ax,ax
                mov ax, tiro_desl
                add ax, 8
                mov tiro_desl, ax        
            
            jmp semTiro
            
            parede1:
            mov tiro_exist, 0
                mov tiro_desl, 0

            semTiro:
            pop ax
        ret
        endp

INICIO_JOGO proc
    mov [tela_atual], 0
    mov [contador_frames], 0
    mov [pont_total], 0
    
PROXIMO_SETOR:
    inc [tela_atual]
    call MOSTRA_SETOR
    mov [pont_sector], 0
    mov [cronometro_sector], sector_temp_total
    
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
    cmp AL, espaco
    je APERTOU_ESPACO
    jmp REPE_JOGO

APERTOU_BAIXO:
    call MOVE_NAVE_BAIXO
    jmp REPE_JOGO

APERTOU_CIMA:
    call MOVE_NAVE_CIMA
    jmp REPE_JOGO

APERTOU_ESPACO:
    call ATIRAR
    
REPE_JOGO:
    xor cx, cx
    mov dx, frame_time
    call SLEEP
    
    inc [contador_frames]
    call MOVE_ELEMENTOS
    cmp [contador_frames], 40
    jne JMP_JOGO
    
    mov [contador_frames], 0
    dec [cronometro_sector]
    cmp [cronometro_sector], 0
    je PROXIMO_SETOR
    
    call MOVE_ELEMENTOS
    
JMP_JOGO: 
    
    jmp LOOP_JOGO
    ret
endp

MOVE_ELEMENTOS proc
    push ax
    push dx
    push cx

    mov ax, word ptr [contador_frames] ; Carrega contador_frames em AX
    xor dx, dx                 ; Zera DX para evitar resto sujo
    mov cx, 10                ; Divisor é 10
    div cx                    ; AX / CX; Resto em DX
    cmp dx, 0                 ; Verifica se o resto é 0
    jne SAIR_MOVE_ELEMENTOS

    
    call MOVIMENTA_TIRO
    ; call MOVIMENTA_CENARIO

    
SAIR_MOVE_ELEMENTOS:

    pop cx
    pop dx
    pop ax

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
