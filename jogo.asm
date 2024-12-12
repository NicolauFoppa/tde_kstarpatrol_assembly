.MODEL SMALL

.STACK 100H

.DATA
    ; cores
    verde EQU 2h
    verde_claro EQU 0Ah
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
    cor_nave_principal db branco
    velocidade_nave_principal equ 1600 ; 5 linhas por vez (320 * 5)
    
    vidas db 1
          db 1
          db 1
          db 1
          db 1
          db 1
          db 1
          db 1
          
    posic_vidas dw 6400  ; todas coluna 0, comeca na linha 20 e incrementa 19 entre cada nave
                dw 12480
                dw 18560
                dw 24640
                dw 30720
                dw 36800
                dw 42880
                dw 48960
                
                    
    cor_vida db 4h
             db 5h
             db 7h
             db 0Eh
             db 0Dh
             db 0Ch
             db 0Ah
             db 9h
             
     naves_inimigas dw 20 dup(0) ; posicao de cada nave 
     naves_inimigas_restante_setor db ? ; comeca de naves_set1,2,3 quando existir 1 nave inimiga em tela, diminui 1, se matar ou morrer, volta 1
     inimigas_vivas_sector dw 0 ; usado para controlar a qtd de naves simultaneas em cada setor
     
     cor_nave_aliada db branco
     
     naves_set1 equ 10
     naves_set2 equ 15
     naves_set3 equ 20

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
           
   vencedor db " __   _____ _  _  __ ___ ___  ___ ___ _ "
            db " \ \ / / __| \| |/ _| __|   \/ _ | _ \ |"
            db "  \ V /| _||    | (_| _|| |)  (_)|   /_|"
            db "   \_/ |___|_|\_|\__|___|___/\___|_|_(_)"
            db "                                        "
         
         
  game_over db "          ___   _   __  __ ___          "
            db "         / __| /_\ |  \/  | __|         "
            db "        | (_ |/ _ \| |\/| | _|          "
            db "         \___/_/ \_\_|__|_|___|         "
            db "           _____   _________            "
            db "          / _ \ \ / / __| _ \           "
            db "         | (_) \ V /| _||   /           "
            db "          \___/ \_/ |___|_|_\           "
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
                 
     nave_inimiga db 0,0,0,0,0,0,0,0,0,9,9,9,9,9,9
                  db 0,0,0,0,0,0,0,0,0,9,9,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                  db 0,0,0,0,9,9,9,9,9,0,0,0,0,0,0
                  db 9,9,9,9,9,9,9,9,9,9,9,9,9,0,0
                  db 0,0,0,0,9,9,9,9,9,0,0,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,9,9,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,9,9,9,9,9,9
    
       cenario db 3 dup(06H), 18 dup(0H), 3 dup(06H), 16 dup(0H), 06H, 92 dup(0H), 06H, 56 dup(0H), 2 dup(06H), 36 dup(0H), 3 dup(06H), 94 dup(0H), 2 dup(06H), 21 dup(0H), 4 dup(06H), 38 dup(0H), 2 dup(06H), 35 dup(0H), 2 dup(06H), 28 dup(0H), 4 dup(06H), 18 dup(0H), 06H
                  db 4 dup(06H), 17 dup(09H), 3 dup(06H), 16 dup(0h), 2 dup(06H), 44 dup(0H), 2 dup(06H), 14 dup(0H), 9 dup(06H), 20 dup(0H), 4 dup(06H), 52 dup(0H), 7 dup(06H), 34 dup(0H), 3 dup(06H), 94 dup(0H), 2 dup(06H), 18 dup(0H),  7 dup(06H), 36 dup(0H), 5 dup(06H), 33 dup(0H), 3 dup(06H), 26 dup(0H), 7 dup(06H), 16 dup(0H), 2 dup(06H)
                  db 6 dup(06H), 14 dup(09H), 4 dup(06H), 15 dup(0H), 3 dup(06H), 42 dup(0H), 5 dup(06H), 11 dup(09H), 13 dup(06H), 16 dup (0H), 7 dup(06H), 51 dup(0H), 8 dup(06H), 32 dup(0H), 5 dup(06H), 93 dup(0H), 2 dup(06H), 17 dup(0H), 9 dup(06H), 34 dup(0H), 7 dup(06H), 30 dup(0H), 6 dup(06H), 22 dup(0H), 11 dup(06H), 14 dup(0H), 3 dup(06H)
                          db 7 dup(06H), 8 dup(09H), 8 dup(06H), 13 dup(09H), 6 dup(06H), 27 dup(09H), 4 dup(06H), 9 dup(0H), 6 dup(06H), 10 dup(09H), 15 dup(06H), 15 dup(0H), 9 dup(06H), 49 dup(0H), 11 dup(06H), 28 dup(0H), 7 dup(06H), 81 dup(0H), 5 dup(06H), 5 dup(0H), 4 dup(06H), 15 dup(0H), 11 dup(06H), 32 dup(0H), 10 dup(06H),  26 dup(0H), 9 dup(06H), 21 dup(0H), 13 dup(06H),  13 dup(0H), 3 dup(06H)
                          db 9 dup(06H), 7 dup(09H), 10 dup(06H), 10 dup(09H), 8 dup(06H), 26 dup(09H), 5 dup(06H), 7 dup(0H), 8 dup(06H), 8 dup(09H), 20 dup(06H), 10 dup(09H), 12 dup(06H), 46 dup(0H), 14 dup(06H),  21 dup(0H), 14 dup(06H), 77 dup(0H), 7 dup(06H), 5 dup(0H), 5 dup(06H), 13 dup(09H), 13 dup(06H), 30 dup(0H), 12 dup(06H), 24 dup(09H), 11 dup(06H), 20 dup(0H), 14 dup(06H), 11 dup(0H), 3 dup(06H)
                          db 26 dup(06H), 9 dup(09H), 9 dup(06H), 23 dup(09H), 9 dup(06H), 4 dup(0H), 10 dup(06H), 6 dup(09H), 23 dup(06H), 8 dup(09H), 22 dup(06H), 35 dup(0H), 16 dup(06H), 19 dup(0H), 17 dup(06H), 23 dup(0H), 10 dup(06H), 15 dup(0H), 4 dup(06H), 22 dup(0H), 8 dup(06H), 4 dup(0H), 7 dup(06H), 14 dup(09H), 11 dup(06H), 30 dup(0H), 12 dup(06H), 23 dup(09H), 11 dup(06H), 20 dup(09H), 15 dup(06H), 9 dup(0H), 6 dup(06H)
                          db 27 dup(06H), 8 dup(09H), 10 dup(06H), 22 dup(09H), 11 dup(06H), 3 dup(0H), 11 dup(06H), 3 dup(09H), 28 dup(06H), 4 dup(09H), 24 dup(06H), 7 dup(09H), 5 dup(06H), 21 dup(0H), 19 dup(06H), 16 dup(0H), 19 dup(06H), 22 dup(0H), 11 dup(06H), 11 dup(06H), 8 dup(06H), 21 dup(0H), 8 dup(06H), 4 dup(0H), 7 dup(06H), 14 dup(09H), 13 dup(06H), 27 dup(06H), 16 dup(06H), 21 dup(09H), 12 dup(06H), 19 dup(09H), 15 dup(06H), 8 dup(0H), 5 dup(06H)
                          db 30 dup(06H), 3 dup(09H), 14 dup(06H), 2 dup(09H), 6 dup(06H), 3 dup(09H), 6 dup(06H), 2 dup(09H), 98 dup(06H), 18 dup(0H), 22 dup(06H), 15 dup(09H), 22 dup(06H), 19 dup(0H), 12 dup(06H), 7 dup(09H), 12 dup(06H), 19 dup(0H), 8 dup(06H), 4 dup(0H), 9 dup(06H), 11 dup(09H), 15 dup(06H), 26 dup(0H), 18 dup(06H), 19 dup(09H), 14 dup(06H), 18 dup(09H), 16 dup(06H), 5 dup(0H), 7 dup(06H)
                          db 165 dup(06H), 14 dup(0H), 28 dup(06H), 13 dup(09H), 23 dup(06H), 17 dup(0H), 14 dup(06H), 5 dup(09H), 14 dup(06H), 16 dup(0H), 10 dup(06H), 3 dup(0H), 12 dup(06H), 5 dup(09H), 19 dup(06H), 22 dup(0H), 20 dup(06H), 17 dup(09H), 17 dup(06H), 18 dup(09H), 28 dup(06H)
                          db 166 dup(06H), 12 dup(09H), 33 dup(06H), 9 dup(09H), 24 dup(06H), 15 dup(0H), 18 dup(06H), 09H, 19 dup(06H), 11 dup(0H), 50 dup(06H), 6 dup(09H), 4 dup(06H), 9 dup(0H), 27 dup(06H), 11 dup(09H), 20 dup(06H), 7 dup(09H), 4 dup(06H), 7 dup(09H), 27 dup(06H)
                          db 168 dup(06H), 10 dup(09H), 34 dup(06H), 8 dup(09H), 26 dup(06H), 12 dup(0H), 41 dup(06H), 8 dup(0H), 53 dup(06H), 3 dup(09H), 8 dup(06H), 5 dup(0H), 29 dup(06H), 8 dup(09H), 23 dup(06H), 4 dup(09H), 8 dup(06H), 5 dup(09H), 27 dup(06H)
                          db 170 dup(06H), 6 dup(09H), 36 dup(06H), 8 dup(09H), 29 dup(06H), 8 dup(0H), 45 dup(06H), 4 dup(0H), 100 dup(06H), 7 dup(09H), 24 dup(06H), 2 dup(09H), 12 dup(06H), 2 dup(09H), 27 dup(06H)
                          db 172 dup(06H), 09H, 40 dup(06H), 6 dup(09H), 34 dup(06H), 3 dup(0H), 151 dup(06H), 2 dup(09H), 71 dup(06H)
                          db 216 dup(06H), 2 dup(09H), 262 dup(06H)
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
    pontuacao db "PONTUACAO: "
    pressione db "PRESSIONE QUALQUER TECLA PARA VOLTAR..."
    
    
    opc_selecionada db 0 ; utilizado no contexto do menu, 0 -> Jogar, 1 -> Sair
    tela_atual db 0 ; 0 -> menu, 1 -> setor 1, 2 -> setor 2, 3 -> setor 3, 4 -> fim
    
    frame_time equ 09C40h ; tempo entre alteracoes dos elementos (40ms em hexa)
    frame_time_test equ 25 ; alterar caso alterar frame time (deve ser = quantos 'frame_time' existem em 1s)
    
    sector_show_time dw 003Dh, 0900h ; tempo da escrita do setor (4s em micro seg)
    sector_temp_total equ 5 ; tempo em segundos de cada setor
    sector_temp_str db 2 dup (?)
    tam_sector_temp_str equ $ - sector_temp_str
    
    tiro_exist dw 0 ; caso seja 0 o nao existe nenhum tiro e pode atirar
    tiro_desl dw 0 ; controla o deslocamento do tiro
    
    contador_frames db 0
    cronometro_sector db ?
    desloc_cen dw 0
    
    pont_total dw 0
    pont_total_str db 6 dup (?)
    tam_pont_total_str equ $ - pont_total_str
    
    pont_sector dw 0
    inimigas_escaparam_sector db 0 ; usado para calcular reducao de pontuacao ao passar de setor
    
    venceu db 0 ; quando todas vidas acabarem, perdeu
    
    random_num_seed dw ? ; utilizado para armazenar a seed para LCG
    nave_ini_coluna dw ?
    nave_ini_linha dw ?
    
    vida_testando dw ?
    
    cor_troca db 0
    
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

endp

POS_CURSOR proc
    push AX
    push BX
    mov AH, 02                   
    int 10h
    pop BX
    pop AX
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
    push DS
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
    pop DS
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

CALC_UINT16_STR proc
    push AX
    push BX
    push CX
    push DX
    
    mov BX, 10    
    xor CX, CX
    
    cmp AX, 10
    jnl LACO_DIGITO2
    
    cmp AX, 0
    je LACO_DIGITO2
    
    mov DL, '0'
    mov [DI], DL
    inc DI
    
  LACO_DIGITO2:    
    xor DX, DX         
    div BX
    
    push DX
       
    inc CX
    
    cmp AX, 0   
        
    jnz LACO_DIGITO2
                          
     
  LACO_ESCRITA2:                    
    pop DX
    add DL, '0'
    mov [DI], DL
    inc DI
    dec CX
    cmp CX, 0
    jnz LACO_ESCRITA2
          
          
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
    jle DESENHA_NAVE_ALIADA_
    jmp SAIR_MOVE_NAVES_MENU
    
CMP_NAVE_ALIADA:
    cmp bx, 35197
    jge DESENHA_NAVE_INIMIGA
    
    jmp SAIR_MOVE_NAVES_MENU
    
DESENHA_NAVE_ALIADA_:
    xor BX, BX
    mov CX, 2 ; coluna
    mov DX, 109 ; linha
    mov BL, branco
    mov SI, offset nave_aliada
    call DESENHA_ELEMENTO_15X9
    mov byte ptr nave_atual, 0
    mov bx, 34895 ; posicao do desenho na memoria de video aliada
    jmp SAIR_MOVE_NAVES_MENU
    
DESENHA_NAVE_INIMIGA:
    xor BX, BX
    mov CX, 304 ; coluna
    mov DX, 109 ; linha
    mov BL, -1
    mov SI, offset nave_inimiga
    call DESENHA_ELEMENTO_15X9
    mov byte ptr nave_atual, 1
    mov bx, 35185 ; posicao do desenho na memoria de video inimiga
    
SAIR_MOVE_NAVES_MENU:
    ret
endp

SEED_CPU proc

    mov AH, 00h   ; interrup??o que pega o timer do sistema em CX:DX 
    int 1Ah
    mov random_num_seed, dx

    ret
endp

DESENHA_MENU proc
    call LIMPAR_TELA
    call SEED_CPU
    
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
    mov byte ptr nave_atual, 0
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
    ret
endp

ZERAR_VARIAVEIS_SETOR proc

    push CX
    push DI
    
    mov CX, naves_set3
    mov DI, offset naves_inimigas
loop_checa_posic_zerar:  
    mov [DI], 0   
    add DI, 2
    loop loop_checa_posic_zerar

    
    pop DI
    pop CX
    
    ret
endp

ZERAR_VARIAVEIS_JOGO proc
    push AX
    push CX
    
    mov contador_frames, 0
    mov pont_total, 0
    mov cor_nave_aliada, branco

    mov CX, 6
    mov DI, OFFSET pont_total_str
loop_zera_str:
    mov [DI], ' '
    inc DI
    loop loop_zera_str
    
    mov CX, 8
    mov DI, offset vidas
    
loop_volta_vidas:
    mov [DI], 1
    inc DI
    loop loop_volta_vidas

    pop CX
    pop AX
    
    ret
endp

LIMPAR_TELA proc
    push AX
    push ES
    push DI
    push CX

    mov AX, memoria_video
    mov ES, AX
    mov DI, 0
    
    mov AL, 0h
    mov CX, 64000
    
    rep stosb
    
    pop CX       
    pop DI      
    pop ES      
    pop AX   
    
    ret
endp

DESENHA_HEADER proc
    mov BP, OFFSET score
    mov DH, 0
    mov DL, 0
    mov CX, 7
    mov BL, branco
    call ESCREVE_STRING
    
    mov AX, pont_total
    mov DI, OFFSET pont_total_str
    call CALC_UINT16_STR
    
    mov BP, OFFSET pont_total_str
    mov DH, 0
    mov DL, 6
    mov CX, tam_pont_total_str
    mov BL, verde_claro
    call ESCREVE_STRING
    
    mov BP, OFFSET tempo
    mov DH, 0
    mov DL, 30
    mov CX, 7
    mov BL, branco
    call ESCREVE_STRING
    
    xor AX,AX
    mov AL, cronometro_sector
    mov DI, OFFSET sector_temp_str
    call CALC_UINT16_STR
    
    mov BP, OFFSET sector_temp_str
    mov DH, 0
    mov DL, 36
    mov CX, tam_sector_temp_str
    mov BL, verde_claro
    call ESCREVE_STRING
    
    ret
endp

DESENHA_VIDAS proc
    push BX
    push CX
    push DX
    push SI
    push AX
              
    mov CX, 8           ; 8 elementos no array "vidas"
    xor DI, DI
    xor AX, AX
    mov AX, 20 ; posicao (linha) da primeira nave 

loop_vidas:
    xor SI, SI          ; Zera SI, necess?rio para a fun??o de desenho
    xor BX, BX          ; Zera BX, que ser? usado para a cor
              
    mov DX, AX      ; DX recebe a linha onde a nave sera desenhada

    push CX
    xor CX, CX          ; Coluna 0 para todas as naves
    
    ; caso a nave ja river sido destruida, nao desenha a mesma
    mov BL, [vidas + DI]
    cmp BL, 0
    je PULA_LOOP_VIDAS

    ; Carrega a cor correspondente da nave em "cor_vida" no ?ndice DI
    mov BL, [cor_vida + DI]  ; BL recebe a cor da nave
    
    mov SI, offset nave_aliada   
    call DESENHA_ELEMENTO_15X9   ; Chama a funcao para desenhar a nave
    jmp PULA_LOOP_VIDAS
    
PULA_LOOP_VIDAS:
    add AX, 19 ; 10 de espaco entre naves + 9 da altura da mesma
    pop CX        
    inc DI
    loop loop_vidas

    pop AX
    pop SI
    pop DX
    pop CX
    pop BX
    ret
endp

DESENHA_CENARIO proc
    push ax
    push cx
    push dx
    push si
    push di

    mov ax, memoria_video       ; Segmento de mem?ria de v?deo (modo gr?fico 13h)
    mov es, ax                  ; Aponta ES para o segmento de v?deo

    mov si, offset cenario      ; Aponta SI para o in?cio do vetor `cenario`
    add si, desloc_cen          ; Aplica o deslocamento para o cen?rio

PRINTA_CENARIO:
    mov di, 57920               ; Offset inicial na mem?ria de v?deo
    mov dx, 20                  ; N?mero de linhas a desenhar
desenha_linha_ter:
    mov cx, 320                 ; N?mero de pixels por linha
    rep movsb                   ; Copia a linha do cen?rio para a tela

    add si, 160                 ; Avan?a o ponteiro no cen?rio para a pr?xima linha
    dec dx                      ; Decrementa o contador de linhas
    jnz desenha_linha_ter       ; Continua enquanto houver linhas a desenhar

END_PROC:
    pop di
    pop si
    pop dx
    pop cx
    pop ax
    ret
ENDP


MOVIMENTA_CENARIO proc
    push AX
    push SI

    xor AX, AX
    add desloc_cen, 3           ; Incrementa o deslocamento em 2 (movimento horizontal)

    cmp desloc_cen, 480         ; Se desloc_cen >= 320, reseta o cen?rio
    jl continua_movimento       ; Se desloc_cen < 320, continua o movimento

    mov desloc_cen, 0           ; Reseta o deslocamento ao ultrapassar o limite

continua_movimento:
    call DESENHA_CENARIO        ; Chama a fun??o para desenhar o cen?rio atualizado
    pop si
    pop ax
    ret
ENDP

MUDA_COR_CENARIO proc
    push AX
    push BX
    push CX
    push SI
    push DS

    mov AX, @data
    mov DS, AX
                
   ;posicao do sprite em si
   mov CX, 480*20

subs_cor_cenario:
    lodsb              
    cmp AL, cor_troca          ; Compara o byte atual com a cor que precisa ser alterada
    jnz proximo_byte_cenario    ; Se o byte for 0, pula para o pr??ximo

    ; Substitui o byte por corObjetoTela se for maior que 0
    mov [SI-1], BL
    
    proximo_byte_cenario:
    loop subs_cor_cenario

    ; Restaurar DS original
    pop DS
    pop SI
    pop CX
    pop BX
    pop AX
    ret
endp

; testar e mostrar se venceu ou perdeu. 
; deixar o usuario escolher se joga de novo ou sai
VENCEU_PERDEU proc

    call LIMPAR_TELA
    
    xor BX, BX
    mov BL, 06H
    mov SI, OFFSET cenario
    call MUDA_COR_CENARIO
    
    
    cmp venceu, 1
    jne GAME_OVER_
    
    ; venceu
    mov BP, OFFSET vencedor
    mov BL, verde
                       ; Centralizar o texto
    mov DH, 8          ; Linha inicial = 8 
    mov DL, 0          ; Coluna inicial = 0 (texto tem 39 caracteres de largura)
    mov CX, 200        ; N?mero de caracteres a escrever (40 x 6)
    
    call ESCREVE_STRING
    
    mov BP, OFFSET pontuacao
    mov DH, 15
    mov DL, 1
    mov CX, 11
    mov BL, branco
    call ESCREVE_STRING
    
    mov AX, pont_total
    mov DI, OFFSET pont_total_str
    call CALC_UINT16_STR
    
    mov BP, OFFSET pont_total_str
    mov DH, 15
    mov DL, 11
    mov CX, tam_pont_total_str
    mov BL, verde_claro
    call ESCREVE_STRING
    
    jmp ESPERA_TECLA
    
GAME_OVER_:
    
    mov BP, OFFSET game_over
    mov BL, vermelho
    ; Centralizar o texto
    mov DH, 9          ; Linha inicial = 9 (meio vertical da tela para altura de 9 linhas)
    mov DL, 0          ; Coluna inicial = 0 (texto tem 40 caracteres de largura)
    mov CX, 360        ; N?mero de caracteres a escrever (40 x 9)
    
    call ESCREVE_STRING
    
ESPERA_TECLA:
    
    mov BP, OFFSET pressione
    mov DH, 20
    mov DL, 1
    mov CX, 39
    mov BL, branco
    call ESCREVE_STRING
    
    mov AH, 0
    int 16h
    
    call DESENHA_MENU
    
    ret
endp

;recebe em AX o valor do bonus
;recebe em BX o valor da penalidade por nave escapar
CALCULA_BONUS_SETOR proc

    cmp AX, 0
    je CALC_PENALIDADE

    mov CX, 8 ; qtd de vidas totais

loop_bonus_setor:
    mov DI, CX          
    dec DI
    
    push BX    
    
    mov BL, [vidas + DI]
    cmp BL, 0
    pop BX
    je PULA_LOOP_BONUS
    
    add pont_total, AX
    
PULA_LOOP_BONUS:
    loop loop_bonus_setor
    
CALC_PENALIDADE:
    xor AX, AX
    mov AL, inimigas_escaparam_sector
    mul BX
    mov CX, pont_total
    sub pont_total, AX
    mov CX, pont_total
    
    ; soma da pontuacao do setor na pont total
    mov CX, pont_sector
    add pont_total, CX
    
    ret

endp

; setar qual tela esta (1,2,3)
MOSTRA_SETOR proc

    mov inimigas_vivas_sector, 0
    mov tiro_exist, 0
    mov tiro_desl, 0
    
    call ZERAR_VARIAVEIS_SETOR

    cmp tela_atual, 1
    je PRINTA_SET_1

    cmp tela_atual, 2
    je PRINTA_SET_2
    
    cmp tela_atual, 3
    je PRINTA_SET_3
    
    xor AX, AX
    mov BX, 30
    call CALCULA_BONUS_SETOR
    
    mov venceu, 1
    call VENCEU_PERDEU

PRINTA_SET_1: 
    
    mov naves_inimigas_restante_setor, naves_set1 
    
    mov BP, OFFSET setor_1
    mov BL, ciano_claro
    jmp PRINTA_E_SAI
    
PRINTA_SET_2:
    
    
    mov naves_inimigas_restante_setor, naves_set2 
    
     mov AX, 1000
    mov BX, 10
    call CALCULA_BONUS_SETOR
    
    mov [cor_troca], 06H
    xor BX, BX
    mov BL, vermelho
    mov SI, OFFSET cenario
    call MUDA_COR_CENARIO
    mov [cor_troca], vermelho
    
    mov BP, OFFSET setor_2
    mov BL, azul_claro
    jmp PRINTA_E_SAI
    
PRINTA_SET_3:
    
    mov naves_inimigas_restante_setor, naves_set3
    
    mov [cor_troca], vermelho
   
    
    mov AX, 2000
    mov BX, 20
    call CALCULA_BONUS_SETOR
    
   
    xor BX, BX
    mov BL, branco
    mov SI, offset cenario
    call MUDA_COR_CENARIO
    mov [cor_troca], branco
    
    mov BP, OFFSET setor_3
    mov BL, magenta_claro
    
PRINTA_E_SAI:
    call LIMPAR_TELA
    mov inimigas_escaparam_sector, 0
    
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

APAGA_TIRO proc
    push AX
    push SI

    mov BX, tiro_exist

    mov DX, offset blank_space
    mov BX, tiro_exist
    call DESENHA_TIRO

    pop SI
    pop AX
    ret
endp 

MOVE_NAVE_BAIXO proc
    push AX
    push BX
    push CX
    push SI
    push DI
    
    mov BX, nave_principal
    
    cmp BX, limite_inferior  ; Verifica se a nave atingiu o limite inferior
    jae FIM_MOVE_NAVE_BAIXO  ; Se j? atingiu o limite inferior, n?o move a nave

    mov AX, memoria_video
    mov DS, AX
    
    mov DX, 15         ; N?mero de linhas para mover
    mov SI, BX         
    mov DI, BX    
    add DI, velocidade_nave_principal       ; Move 5 linha para baixo
    push DI            ; Empilha para salvar a nova posi??o da nave
    
    add DI, 2880       ; inicio da ultima linha da nave
    add SI, 2880
MOVE_NAVE_BAIXO_LOOP:
    mov CX, 15         ; Largura
    rep movsb          
    dec DX             
    sub DI, 335        ; Proxima linha
    sub SI, 335        
    cmp DX, 0         
    jnz MOVE_NAVE_BAIXO_LOOP

    pop DI            
    mov BX, DI         
    
    mov AX, @data
    mov DS, AX
    
    mov nave_principal, BX 

FIM_MOVE_NAVE_BAIXO:
    pop DI
    pop SI
    pop CX
    pop BX
    pop AX
    ret
endp

MOVE_NAVE_CIMA proc
    push AX
    push BX
    push CX
    push SI
    push DI
    
    mov BX, nave_principal
    
    cmp BX, limite_superior
    jbe FIM_MOVE_NAVE_CIMA
    
    mov AX, memoria_video
    mov DS, AX
    
    mov DX, 15       ; Numero de linhas para mover
    mov SI, BX       
    mov DI, BX   
    ;mov ax, velocidade_nave_principal
    sub DI, velocidade_nave_principal     ; Move x linhas para cima
    push DI          ; Empilha poder salvar a nova posi??o da nave
    
MOVE_NAVE_CIMA_LOOP:
    mov CX, 15       ; Largura
    rep movsb        
    dec DX           
    add DI, 305      ; Pula para a linha anterior
    add SI, 305     
    cmp DX, 0        
    jnz MOVE_NAVE_CIMA_LOOP
    
    pop DI           ; Desempilha a nova posi??o da nave
    mov BX, DI       ; Atualiza BX com a nova posi??o da nave
    
    mov AX, @data
    mov DS, AX
    
    mov nave_principal, BX

FIM_MOVE_NAVE_CIMA:
    pop DI
    pop SI
    pop CX
    pop BX
    pop AX
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
    
    ; Agora chamamos DESENHA_TIRO para desenhar o tiro na tela
    call DESENHA_TIRO          ; Desenha o tiro

retorna:
    pop SI
    pop AX
    ret
endp

DESENHA_TIRO proc
    push AX
    push BX
    push CX
    push DX
    push DI
    push ES
    push DS
    
   
    mov DI, BX               
    mov SI, DX       
    mov DX, 9          

desenha_linha:
    mov CX, 15
    rep movsb
    add DI, 305
    dec DX
    jnz desenha_linha

    ; Restaurar DS original
    pop DS  
    pop ES
    pop DI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
endp

MOVIMENTA_TIRO proc
    push AX 
            
    xor AX, AX
    mov AX, tiro_exist
    cmp AX, 0
    je semTiro

    xor BX, BX
    call APAGA_TIRO
    xor AX,AX
    mov AX, tiro_desl
    cmp AX, 240
    jge CHEGOU_FINAL          
    xor ax,ax
    mov ax, tiro_exist
    add ax, 8
    mov tiro_exist, ax 
    mov DX, offset tiro
    mov BX, tiro_exist
    call DESENHA_TIRO
    xor AX,AX
    mov AX, tiro_desl
    add AX, 8
    mov tiro_desl, AX
    call CHECA_COLISAO_TIRO    
            
    jmp semTiro
            
CHEGOU_FINAL:
    mov tiro_exist, 0
    mov tiro_desl, 0

    semTiro:
    pop AX
    ret
endp
        
DESENHA_NAVE_ALIADA proc
    
    push AX
    push CX
    push DX
    push BX
    push DS
    push SI
    
    
    ; obtem coluna e linha da nave inimiga
    mov AX, nave_principal
    call OBTER_COLUNA_ELEMENTO
    mov CX, AX ; CX coluna inicial
    
    mov AX, nave_principal
    call OBTER_LINHA_ELEMENTO
    mov DX, AX   ; DX linha inicial
   
    mov BL, cor_nave_aliada
    mov SI, offset nave_aliada
    call DESENHA_ELEMENTO_15X9

    pop SI
    pop DS
    pop BX
    pop DX
    pop CX
    pop AX
    
    ret
endp

INICIO_JOGO proc
    mov tela_atual, 0
    call ZERAR_VARIAVEIS_JOGO
    
PROXIMO_SETOR:
    inc tela_atual
    call MOSTRA_SETOR
    mov pont_sector, 0
    mov cronometro_sector, sector_temp_total
    
    mov nave_principal, 30447 ; posicao do desenho na memoria de video aliada
    
LOOP_JOGO:
    call DESENHA_HEADER
    call DESENHA_VIDAS
    call DESENHA_CENARIO
    call DESENHA_NAVE_ALIADA
    
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
    xor CX, CX
    mov DX, frame_time
    call SLEEP
    
    inc contador_frames
    call MOVE_ELEMENTOS
    cmp contador_frames, frame_time_test
    jne JMP_JOGO

    mov contador_frames, 0
    dec cronometro_sector
    cmp cronometro_sector, 0
    je PROXIMO_SETOR
    
    ;call CHECA_COLISAO_TIRO
    ;call CHECA_COLISAO_NAVE_PRIN
    ;call CHECA_COLISAO_VIDAS
    call GERAR_INIMIGO
    ;call MOVE_ELEMENTOS
   
JMP_JOGO: 
    
    jmp LOOP_JOGO
    ret
endp

MOVE_ELEMENTOS proc
    push AX
    push DX
    push CX
    
    call MOVIMENTA_CENARIO
    call MOVIMENTA_TIRO
    call MOVIMENTA_INIMIGOS
    call MOVIMENTA_INIMIGOS
    
SAIR_MOVE_ELEMENTOS:

    pop CX
    pop DX
    pop AX

    ret

endp

; recebe em AX a posic
; devolve em AX a coluna
OBTER_COLUNA_ELEMENTO proc

    push DX
    push BX  
    push CX
    
    mov CX, AX

    xor DX, DX
    mov BX, 320
    div BX      
    mul BX
    mov DX, AX
    mov AX, CX
    sub AX, DX
           
    pop CX       
    pop BX
    pop DX

    ret

endp
; recebe em AX a posic
; devolve em AX a coluna
OBTER_LINHA_ELEMENTO proc

    push DX
    push BX 
    push CX 
    
    mov CX, AX

    xor DX, DX
    mov BX, 320
    div BX
           
    pop CX 
    pop BX
    pop DX

    ret

endp

MOVIMENTA_INIMIGOS proc
    
    push CX
    push DI
    push DX
    push SI

    mov CX, inimigas_vivas_sector
    cmp CX, 0
    je sair_mover_ini
    
    mov DI, offset naves_inimigas
    
loop_movimenta_ini:
    mov AX, DI
    mov BX, [DI]
    cmp BX, 0
    jne mover_inimigo
    add DI, 2
    jmp loop_movimenta_ini
    
mover_inimigo:
    mov SI, BX
    mov DI, SI
    sub DI, 1 ; quanto vai movimentar
    mov DX, 1
    call MOVE_HORIZONTAL
    mov DI, AX
    sub word ptr [DI], 1
    
    ; testa a coluna da nave
    mov AX, BX 
    xor DX, DX
    call OBTER_COLUNA_ELEMENTO
    cmp AX, 1
    jg prox_inimigo
    
    ; limpa a nave
    push CX
    
    xor DX, DX
    mov CX, AX ; CX coluna inicial
    dec CX
    
    mov AX, BX
    call OBTER_LINHA_ELEMENTO
    mov DX, AX   ; DX linha inicial
    
    mov BL, -1
    mov SI, offset blank_space   
    call DESENHA_ELEMENTO_15X9   ; Chama a funcao para desenhar a nave
    
    mov [DI], 0
    dec inimigas_vivas_sector
    inc naves_inimigas_restante_setor
    inc inimigas_escaparam_sector
    
    
    pop CX
    
prox_inimigo:
    add DI, 2
    loop loop_movimenta_ini
    
    call CHECA_COLISAO_NAVE_PRIN
    call CHECA_COLISAO_VIDAS
    
sair_mover_ini:
    pop SI
    pop DX
    pop DI
    pop CX
    
    ret
    
endp

CHECA_COLISAO_TIRO proc
    push BX
    push CX
    push DX
    push SI
    push AX

    mov CX, inimigas_vivas_sector
    cmp CX, 0
    je SAIR_COLISAO_TIRO

    ; Verifica se existe tiro
    mov AX, tiro_exist
    cmp AX, 0
    je SAIR_COLISAO_TIRO

    mov DI, offset naves_inimigas

loop_tiro_inimigas:

    mov AX, [DI] ; Posi??o da nave inimiga
    cmp AX, 0    ; Nave j? destru?da?
    je PROXIMA_INIMIGA

    ; Comparar posi??o da nave com a posi??o do tiro
    mov SI, tiro_exist ; Carregar posi??o do tiro
    
     ; testar coluna da nave inimiga (em AX)
    call OBTER_COLUNA_ELEMENTO
    mov BX, AX ; coluna NAVE INIMIGA
    mov AX, SI
    call OBTER_COLUNA_ELEMENTO ; coluna TIRO
    add AX, 15 
    cmp BX, AX ; BX = coluna NAVE INIMIGA, AX = coluna TIRO + 15
    jg PROXIMA_INIMIGA 
    sub AX, 30 
    cmp BX, AX ; (coluna TIRO + 15) - 30
    jl PROXIMA_INIMIGA 
    
    mov AX, [DI] ; posic da nave inimiga
    mov DX, SI ; posic do tiro
    add DX, 2895
    cmp AX, DX          ; Se ponto superior esquerdo da inimiga > inferior direito da vida
    ja PROXIMA_INIMIGA  ; sem colisao

    mov AX, [DI] ; posic da nave inimiga
    mov DX, SI ; posic do tiro
    add AX, 2880
    cmp AX, DX          ; Se ponto inferior esquerdo da inimiga > superior esquerdo da vida
    jb PROXIMA_INIMIGA  ; sem colisao

    ; Colidiu
    call APAGA_TIRO
    mov tiro_exist, 0
    add pont_total, 100
    mov BX, inimigas_vivas_sector
    call LIMPAR_NAVE_INIMIGA

    jmp SAIR_COLISAO_TIRO

PROXIMA_INIMIGA:
    add DI, 2 ; Pr?xima nave inimiga
    loop loop_tiro_inimigas

SAIR_COLISAO_TIRO:

    pop AX
    pop SI
    pop DX
    pop CX
    pop BX
    ret

endp

; [DI] o offset da nave_inimiga
LIMPAR_NAVE_INIMIGA proc

    push AX
    push DX
    push CX
    push BX
    push SI
    push DI

; obtem coluna e linha da nave inimiga
    mov AX, [DI] 
    xor DX, DX
    call OBTER_COLUNA_ELEMENTO
    mov CX, AX ; CX coluna inicial
    
    mov AX, [DI]
    xor DX, DX
    call OBTER_LINHA_ELEMENTO
    mov DX, AX   ; DX linha inicial
    xor BX,BX
    mov BL, -1
    mov SI, offset blank_space
    call DESENHA_ELEMENTO_15X9
    
    mov [DI], 0
    dec inimigas_vivas_sector
    inc naves_inimigas_restante_setor

    
    pop DI
    pop AX
    pop DX
    pop CX
    pop BX
    pop SI
    
    ret
endp 

CHECA_COLISAO_NAVE_PRIN proc

    push BX
    push CX
    push DX
    push SI
    push AX
    push DI
    
    mov CX, inimigas_vivas_sector 
    cmp CX, 0
    jg CONTINUA
    
    pop DI
    pop AX
    pop SI
    pop DX
    pop CX
    pop BX
    
    ret
    
CONTINUA:
    
    mov DI, offset naves_inimigas
    
loop_nave_ini_nave_prin:
    
    ; testar coluna da nave inimiga
    mov AX, [DI]
    cmp AX, 0
    je SEM_COLISAO_NAVE_PRIN
    call OBTER_COLUNA_ELEMENTO
    cmp AX, 62 ; 47 + 15
    jg SEM_COLISAO_NAVE_PRIN 
    cmp AX, 32 ; 47 - 15
    jl SEM_COLISAO_NAVE_PRIN 
    
    mov AX, [DI] ; posic da nave inimiga
    mov DX, nave_principal ; posic da vida aliada
    add DX, 2895
    cmp AX, DX          ; Se ponto superior esquerdo da inimiga > inferior direito da vida
    ja SEM_COLISAO_NAVE_PRIN  ; sem colisao

    mov AX, [DI] ; posic da nave inimiga
    mov DX, nave_principal ; posic da vida aliada
    add AX, 2880
    cmp AX, DX          ; Se ponto inferior esquerdo da inimiga > superior esquerdo da vida
    jb SEM_COLISAO_NAVE_PRIN  ; sem colisao
    
    mov BX, inimigas_vivas_sector
    call LIMPAR_NAVE_INIMIGA
    
    mov BX, inimigas_vivas_sector
    ; colidiu -> buscar vida 
    xor DI, DI
    mov CX, 8
    xor BX, BX

loop_busca_vida:
    ; caso a nave ja river sido destruida, nao serve
    mov BL, [vidas + DI]
    cmp BL, 0
    je PULA_LOOP_BUSCA_VIDA
    
    mov [vidas + DI], 0

    ; Carrega nova cor da nave principal
    mov BL, [cor_vida + DI]  ; BL recebe a cor da nave
    mov cor_nave_aliada, BL
    
    ;inc DI
    jmp SAIR_COLISAO_NAVE_PRIN
     
PULA_LOOP_BUSCA_VIDA:
    inc DI
    loop loop_busca_vida
    
    ; se nao achar nenhuma vida restante, game over
    mov venceu, 0
    call VENCEU_PERDEU
    
SEM_COLISAO_NAVE_PRIN:
    add DI, 2
    loop loop_nave_ini_nave_prin
    jmp SAIR_SEM_COLDIIR
    
SAIR_COLISAO_NAVE_PRIN:
    
    ; obtem coluna e linha da vida
    xor AX, AX
    
    mov AX, DI
    mov BX, 2
    mul BX
    mov DI, AX
    mov AX, [posic_vidas + DI] 
    mov BX, AX
    xor DX, DX
    call OBTER_COLUNA_ELEMENTO
    mov CX, AX ; CX coluna inicial
    
    mov AX, BX
    xor DX, DX
    call OBTER_LINHA_ELEMENTO
    mov DX, AX   ; DX linha inicial
    xor BX, BX
    mov BL, -1
    mov SI, offset blank_space   
    call DESENHA_ELEMENTO_15X9
    
SAIR_SEM_COLDIIR:
    pop DI
    pop AX
    pop SI
    pop DX
    pop CX
    pop BX
    
    ret
endp

CHECA_COLISAO_VIDAS proc

    push BX
    push CX
    push DX
    push SI
    push AX
              
    mov CX, inimigas_vivas_sector
    cmp CX, 0
    je SAIR_COLISAO_VIDAS
    
    mov DI, offset naves_inimigas

    
loop_vidas_inimigas:
    
    push CX ; salvar passe do loop das naves inimigas
    
    mov CX, 8 ; 8 elementos no array "posic_vidas"
    
    mov SI, offset posic_vidas
    mov vida_testando, 0
    
    mov AX, [DI]
    cmp AX, 0
    je PROX_INIMIGA
    
loop_vidas_testar:
    push SI
    mov SI, vida_testando
    ; caso a nave ja river sido destruida, nao testa mais 
    mov BL, [vidas + SI]
    pop SI
    cmp BL, 0       
    je PULA_VIDA_ATUAL
    
    ; testa a coluna
    mov AX, [DI] ; posic da nave inimiga    
    call OBTER_COLUNA_ELEMENTO
    cmp AX, 15
    jg PULA_VIDA_ATUAL
   
    mov AX, [DI] ; posic da nave inimiga
    mov DX, [SI] ; posic da vida aliada
    add DX, 2895
    cmp AX, DX          ; Se ponto superior esquerdo da inimiga > inferior direito da vida
    ja PULA_VIDA_ATUAL  ; sem colisao

    mov AX, [DI] ; posic da nave inimiga
    mov DX, [SI] ; posic da vida aliada
    add AX, 2880
    cmp AX, DX          ; Se ponto inferior esquerdo da inimiga > superior esquerdo da vida
    jb PULA_VIDA_ATUAL  ; sem colisao
    
    ;colidiu
    call VIDA_COLISAO
    pop CX
    jmp SAIR_COLISAO_VIDAS
    
PULA_VIDA_ATUAL:
    add SI, 2
    inc vida_testando
    loop loop_vidas_testar
    
PROX_INIMIGA:
    pop CX
    add DI, 2
    loop loop_vidas_inimigas

SAIR_COLISAO_VIDAS:
    
    pop AX
    pop SI
    pop DX
    pop CX
    pop BX
    ret

endp

;[DI] posic nave inimiga
;[SI] posic nave aliada
VIDA_COLISAO proc

    ; obtem coluna e linha da nave aliada
    xor CX, CX ; CX coluna inicial (sempre 0 para nave aliada - vida)
    
    mov AX, [SI]
    xor DX, DX
    call OBTER_LINHA_ELEMENTO
    mov DX, AX   ; DX linha inicial
    
    mov BL, -1
    mov SI, offset blank_space   
    call DESENHA_ELEMENTO_15X9

    
    mov SI, vida_testando
    mov [vidas + SI], 0 ; zera vida
    
    
    call LIMPAR_NAVE_INIMIGA
    
    ret

endp

GERAR_INIMIGO proc
    push CX
    push SI
    push DI
    push DX
    push AX
    push BX
    
    cmp naves_inimigas_restante_setor, 0
    je SAIR_GERAR_INI
    
    mov CX, naves_set3
    mov DI, offset naves_inimigas
    
loop_checa_posic: 
    
    mov BX, [DI] ; checa se pode salvar na posicao DI no vetor naves_inimigas
    cmp BX, 0 
    je SAIR_LOOP_CHECA_POSIC
    add DI, 2
    loop loop_checa_posic
    jmp SAIR_GERAR_INI
    
    
SAIR_LOOP_CHECA_POSIC:
    
    ; gerar num aleatorio para a coluna
    mov BX, 161
    mov CX, 300
    call GERAR_NUM_ALEATORIO
    mov nave_ini_coluna, AX ; coluna da nova nave inimiga
    
    ; gerar num aleatorio para a coluna
    mov BX, 20
    mov CX, 150
    call GERAR_NUM_ALEATORIO
    mov nave_ini_linha, AX ; linha onde a nave sera desenhada
    
    mov CX, nave_ini_coluna
    mov DX, nave_ini_linha
    mov AX, DX
    mov BX, 320
    mul BX
    add AX, CX
    
    mov [DI], AX
    
    xor SI, SI          ; Zera SI, necess?rio para a fun??o de desenho
    xor BX, BX          ; Zera BX, que ser? usado para a cor
    mov CX, nave_ini_coluna
    mov DX, nave_ini_linha
    mov BL, -1      ; BL nao muda cor da nave inimiga
    mov SI, offset nave_inimiga   
    call DESENHA_ELEMENTO_15X9   ; Chama a funcao para desenhar a nave
    dec naves_inimigas_restante_setor
    inc inimigas_vivas_sector

SAIR_GERAR_INI:
    pop BX
    pop AX
    pop DX
    pop DI
    pop SI
    pop CX
    
    ret
endp

; gerador de pseudo-random number
; range de numeros entre [BX, CX]
; algoritmo LCG (Linear congruential generator)
; retorna em AX
GERAR_NUM_ALEATORIO proc
    push BX
    push CX
    push DX

    mov AX, 25173          ; LCG Multiplicador
    mul word ptr random_num_seed     ; DX:AX = LCG Multiplicador * seed
    add AX, 13849          ; Adiciona incremento LCG 
    ; Modulo 65536, AX = (multiplicador*seed+incremento) mod 65536
    mov random_num_seed, AX          ; Atualiza seed = return value
    
    ; Mapeia AX no range desejado [min, max]
    sub CX, BX             ; CX = max - min
    inc CX                  ; CX = tamanho range

    xor DX, DX              ; Limpa DX para DIV
    div CX                  ; AX = AX / range, DX = AX % range
    mov AX, DX              ; AX = resto

    add AX, BX             ; Ajusta o valor minimo [min, max]

    pop DX
    pop CX
    pop BX
    
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
    add DI, 305          ; move DI para o in?cio da pr?xima linha (offset de 320 menos 15 pixels desenhados)
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
    call DESENHA_MENU 
    
    mov AH, 4Ch
    int 21h
    
        
end INICIO
