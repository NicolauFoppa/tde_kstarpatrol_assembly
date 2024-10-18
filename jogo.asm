.MODEL SMALL
.STACK 100H
.DATA

titulo db " __  __.        _____ __                "                
       db "|  |/ _|       / ___//  |______ _______ ";texto do titulo na tela de menu
       db "|    <   ______\_  \\   __\__  \\_  __ \";40 columns 12 rows
       db "|  |  \ /_____//    \|  |  / __ \|  | \/"
       db "|__|__ \      /___  /|__| (____  /__|   "
       db "      \/          \/           \/       "
       db "________         __                ._   "
       db "\____   \_____ _/  |________  ____ | |  "
       db " |   ___/\__  \\   __\_  __ \/  _ \| |  "
       db " |  |     / __ \|  |  |  | \(  <_> ) |_ "
       db " |__|    (____  /__|  |__|   \____/|___/"
       db "              \/                        "
  
voce db "      ____   ____                       " ;mensagens de resultado no final do jogo
     db "      \   \ /   /___   ____  ____       "
     db "       \   Y   /  _ \_/ ___\/ __ \      "  
     db "        \     (  <_> )  \__\  ___/      "  
     db "         \___/ \____/ \___  >___  >     "  
     db "                          \/    \/      "  

mensagem_derrota db "________                .___            "   
                 db "\____   \ __________  __| _/____  __ __ "
                 db " |   ___// __ \_ __ \/ __ |/ __ \|  |  |"
                 db " |  |    \  ___/| | / /_/ \  ___/|  |  |"
                 db " |__|     \___  >_| \____ |\_____>_____/"
                 db "               \/           \/    \/    "
     
mensagem_vitoria db "____   ____                             "
                 db "\   \ /   /___   ____  _____ ___  __ __ "   
                 db " \   Y   // __\ /    \/ ___ / __\|  |  |"
                 db "  \     /\  __/|   |  \ \__\  __/|  |  |"
                 db "   \___/  \___ >___|  /\___  >___>____ /"
                 db "              \/    \/     \/         \/" 

jogar db "            ?-----------?               " 
      db "            |   Jogar   |               " ;opcoes de jogo
      db "            ?-----------?               "

sair db "            ?-----------?               " 
     db "            |   Sair    |               " ;opcoes de jogo
     db "            ?-----------?               "

selected_option db 0;

tela_atual db 0;

frame_time dw 16667;

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

inicia_video proc
    xor AH, AH      ;zera AH
    mov AL, 13h     ;configura modo de video
    int 10h         ;chama modo de video do sistema
    ret
endp  

escreve_string proc
    push ES
    push BX
    
    mov BX, DS
    mov ES, BX
    
    mov AH, 13h
    mov AL, 01h
    pop BX
    xor BH, BH
    
    int 10h
    
    pop ES
    ret
endp

verifica_tecla_menu proc
    
    mov ah, 1h              ;configura interrupcao
    int 16h                 ;verifica tecla no buffer
    jz nao_pressionada      ;se nao tiver, ignora
    xor ah,ah               ;se houver, muda a configuracao e
    int 16h                 ;pega a tecla no buffer
    
    cmp ah, 50h             ;se for down arrow
    jne ignore              ;senao, verifica pra ver se e cima
    mov selected_option, 1  ;se sim, altera a opcao para 1 - sair
    jmp nao_pressionada     ;vai para o fim
   
ignore: 
    cmp ah, 48h             ;up arrow
    jne confirmacao         ;se nao for nem baixo nem cima, termina
    mov selected_option, 0  ;senao, altera a opcao para 0 - jogar
    jmp nao_pressionada     ;vai para o fim
       
confirmacao:
    cmp ah, 01Ch            ;enter
    jne nao_pressionada     ;se nao for enter, termina
    call troca_cena         ;se sim, chama proc para verificar qual opcao foi selecionada e trata-;a
    
nao_pressionada:
    
    ret
endp


troca_cena proc
    
    cmp selected_option, 1  ;verifica se a opcao selecionada e sair
    jne comeca_jogo         ;senao, a opcao selecionada e jogar, e portanto comeca o jogo
    call encerra            ;se sim, chama funcao para encerrar o jogo
    
comeca_jogo:
    mov tela_atual, 1       ;se o jogo comeca, altera a tela
    mov pontuacao, 0        ;zera o tempo da fase
    call mudar_tela         ;chama funcao para pintar de preto informacoes do menu que nao estarao no jogo
    call escreve_barra      ;chama funcao para pintar barra laranja/marrom no limite da tela
    mov CX, nave_pos        ;passa a posicao x da nave para cx
    mov DX, [nave_pos+2]    ;passa a posicao y da nave para dx                  
    mov BX, offset nave     ;passa deseho da nave para bx
    call pinta_10X10        ;desenha a nave na tela na posicao indicada
    
    ret
endp

altera_opcao proc
    push DI                     ;salva contextos
    push SI
    
    mov DI, offset jogar        ;passa para DI escrita do jogar
    mov SI, offset sair         ;passa para SI a escrita do sair
        
    cmp selected_option, 0      ;se a opcao escolhida for jogar
    jne op_1                    ;senao, verifica se a opcao e 1sair
    add DI, 16                  ;escreve colchetes de selecao no jogar e apaga colchetes do sair
    mov BYTE PTR [DI], '['
    add DI, 8
    mov BYTE PTR [DI], ']'
    add SI, 16
    mov BYTE PTR [SI], ' '
    add SI, 8
    mov BYTE PTR [SI], ' '
    jmp atualiza_string         ;vai para o fim

op_1:
    cmp selected_option, 1      ;se a opcao escolhida for sair
    jne atualiza_string         ;senao, vai para o fim
    add DI, 16                  ;apagacolchetes de selecao no jogar e os escreve no do sair
    mov BYTE PTR [DI], ' '
    add DI, 8
    mov BYTE PTR [DI], ' '
    add SI, 16
    mov BYTE PTR [SI], '['
    add SI, 8
    mov BYTE PTR [SI], ']'
    
    
atualiza_string:
    mov dh,15                   ;configura linha para escrever a string
    mov dl,0                    ;coluna da string
    mov cx, 40                  ;tamanho da string
    mov bl, 0Fh                 ;cor da string
    mov bp,OFFSET jogar         ;posicao na memoria da string
    call escreve_string         ;chama proc para escrever jogar

    mov dh,17                   ;muda a lnha da string
    mov bp,OFFSET sair          ;escreve sair
    call escreve_string         ;chama proc para escrever sair

    pop SI                      ;recupera contexto
    pop DI
    ret
endp


wait_frame proc 
    push CX                 ;salva contexto
    push DX             
    push AX             
      
    xor CX, CX              ;zera CX, pois o tempo e definido por CX:DX
    mov DX, frame_time      ;espera 16667 microsegundos, assim ha 60 frames por segundo
    mov AH, 86h             ;configura o modo de espera
    int 15h                 ;chama a espera no sistema
    
    pop DX
    pop CX
    ret
endp

INICIO:
    mov AX, @data
    mov DS, AX
    mov AX, 0A000h
    mov ES, AX
    
    call inicia_video
    
    mov DH, 0
    mov DL, 0
    mov CX, 480
    mov BL, 2
    mov BP, OFFSET titulo
    call escreve_string
    
    mov DH, 15
    mov CX, 120
    mov BL, 0fh
    mov bp, OFFSET jogar
    call escreve_string
    
    mov DH, 19
    mov bp, OFFSET sair
    call escreve_string
    
menu:
    call wait_frame
    call verifica_tecla_menu
    cmp tela_atual, 0
    jne jogo
    call altera_opcao
    jmp menu
    
jogo:
    mov DX, 4               
    mov bp,OFFSET mensagem_derrota          
    xor CX, CX              
    jmp espera 
    
espera:
    call wait_frame         ;espera 300 frames antes de encerrar o jogo
    inc CX
    cmp CX, 300
    jb espera
        
end INICIO