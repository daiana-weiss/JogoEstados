      $set sourceformat"free"

      *>Divisão de identificação do programa
       identification division.
       program-id. "lista16exe2_sequencial".
       author. "Daiana Weiss".
       installation. "PC".
       date-written. 23/07/2020.
       date-compiled. 23/07/2020.



      *>Divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>-----Declaração dos recursos externos
       input-output section.
       file-control.

           select arqEstados assign to "arqEstados.txt" *> associando arquivo logico
           organization is line sequential              *> forma de organizacao dos dados
           access mode is sequential                    *> forma de tratamento dos dados
           lock mode is automatic                       *> forma de tratamento dead lock (evita que duas pessoas mexam no arquivo ao mesmo tempo)
           file status is ws-fs-arqEstados.             *> file status (nessa variavel vai aparecer o codigo de status do arquivo. se for diferente de 0, eh erro.)


       i-o-control.

      *>Declaração de variáveis
       data division.

      *>----Variaveis de arquivos
       file section.
       fd arqEstados.
       01 fd-estados.
           05 fd-estado                            pic X(25).
           05 fd-capital                           pic X(25).


      *>----Variaveis de trabalho
       working-storage section.

       01  ws-estados occurs 26.
           05 ws-estado                            pic x(25).
           05 ws-capital                           pic x(25).

       01 ws-jogadores occurs 4.
          05 ws-nome-jog                           pic x(25).
          05 ws-pontos                             pic 9(02) value zero.

       01 ws-jogadores-aux.
          05 ws-nome-jog-aux                       pic x(25).
          05 ws-pontos-aux                         pic 9(02) value zero.


       01 ws-indices.
          05 ws-ind-est                            pic 9(02).
          05 ws-ind-jog                            pic 9(01).

       01 ws-tela-menu.
          05 ws-cadastro-jogadores                 pic x(01).
          05 ws-jogar                              pic x(01).


       01 ws-tela-jogo.
          05 ws-capital-jog                        pic x(25).
          05 ws-estado-sorteado                    pic x(25).
          05 ws-pontos-jogador                     pic 9(02).


       01 ws-uso-comum.
          05 ws-sair                               pic x(01).
          05 ws-msn                                pic x(50).
          05 ws-nome-jogador                       pic x(25).

       01 sorteio.
          05  semente                              pic  9(08).
          05  num_random                           pic  9(01)V9999999.


       01 controle                                 pic x(1).
          88  trocou                               value "1".
          88  nao_trocou                           value "5".


       77 ws-ind-arq                               pic 9(02).

       77 ws-fs-arqEstados                         pic 9(02).
       77 ws-msn-erro-ofsset                       pic 9(02).
       77 ws-msn-erro-cod                          pic 9(02).
       77 ws-msn-erro-text                         pic X(42).


      *>----Variaveis para comunicação entre programas
       linkage section.


      *>----Declaração de tela
       screen section.
       01  sc-tela-menu.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Tela Principal                                   ".
           05 line 03 col 01 value "      MENU                                                                       ".
           05 line 04 col 01 value "        [ ]Cadastro de Jogadores                                                 ".
           05 line 05 col 01 value "        [ ]Jogar                                                                 ".


           05 sc-sair-menu           line 01  col 71 pic x(01) using ws-sair               foreground-color 12.
           05 sc-cadastro-jogadores  line 04  col 10 pic x(01) using ws-cadastro-jogadores foreground-color 15.
           05 sc-jogar               line 05  col 10 pic x(01) using ws-jogar              foreground-color 15.

       01  sc-tela-cad-jogador.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Cadastro de Jogadores                            ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "      Jogador  :                                                                 ".
           05 line 22 col 01 value "              [__________________________________________________]               ".


           05 sc-sair-cad-jog      line 01  col 71 pic x(01) using ws-sair         foreground-color 12.
           05 sc-nome-jog-cad-jog  line 04  col 17 pic x(25) using ws-nome-jogador foreground-color 12.
           05 sc-msn-cad-jog       line 22  col 16 pic x(50) from  ws-msn          foreground-color 12.

       01  sc-tela-jogar.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                           Quiz Estados Brasileiros                              ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "      Jogador  :                                   Pontos Acumulados:            ".
           05 line 06 col 01 value "      Qual e a capital do estado:                                                ".
           05 line 07 col 01 value "      Resposta :                                                                 ".


           05 line 22 col 01 value "              [__________________________________________________]               ".


           05 sc-sair-jog             line 01  col 71 pic x(01) using ws-sair            foreground-color 12.
           05 sc-nome-jog             line 04  col 17 pic x(25) from  ws-nome-jogador    foreground-color 12.
           05 sc-pontos-jog           line 04  col 71 pic 9(02) from  ws-pontos-jogador  foreground-color 12.
           05 sc-estado-sorteado-jog  line 06  col 34 pic x(25) from  ws-estado-sorteado foreground-color 12.
           05 sc-resposta-jog         line 07  col 17 pic x(25) using ws-capital-jog     foreground-color 12.
           05 sc-msn-jog              line 22  col 16 pic x(50) from  ws-msn             foreground-color 12.


       01  sc-tela-relatorio.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Resultados finais                                ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "  Quarto colocado  :                                        Pontos:              ".
           05 line 05 col 01 value "  Terceiro colocado:                                        Pontos:              ".
           05 line 06 col 01 value "  Segundo colocado :                                        Pontos:              ".
           05 line 07 col 01 value "  Vencedor         :                                        Pontos:              ".
           05 line 22 col 01 value "              [__________________________________________________]               ".


           05 sc-sair-rel         line 01  col 71 pic x(01) using ws-sair        foreground-color 12.
           05 sc-nome-jog4-rel    line 04  col 21 pic x(25) from  ws-nome-jog(4) foreground-color 12.
           05 sc-pontos-jog4-rel  line 04  col 68 pic 9(02) from  ws-pontos(4)   foreground-color 12.
           05 sc-nome-jog3-rel    line 05  col 21 pic x(25) from  ws-nome-jog(3) foreground-color 12.
           05 sc-pontos-jog3-rel  line 05  col 68 pic 9(02) from  ws-pontos(3)   foreground-color 12.

           05 sc-nome-jog2-rel    line 06  col 21 pic x(25) from ws-nome-jog(2) foreground-color 12.
           05 sc-pontos-jog2-rel  line 06  col 68 pic 9(02) from ws-pontos(2)   foreground-color 12.
           05 sc-nome-jog1-rel    line 07  col 21 pic x(25) from ws-nome-jog(1) foreground-color 12.
           05 sc-pontos-jog1-rel  line 07  col 68 pic 9(02) from ws-pontos(1)   foreground-color 12.
           05 sc-msn-rel          line 22  col 16 pic x(50) from ws-msn         foreground-color 12.





      *>Declaração do corpo do programa
       procedure division.


           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>  Procedimentos de inicialização
      *>------------------------------------------------------------------------
       inicializa section.
      *>   abrindo o arquivo somente para leitura
           open input arqEstados

      *>   tratamento de file status
           if ws-fs-arqEstados  <> 00 then
               move 1                                    to ws-msn-erro-ofsset
               move ws-fs-arqEstados                    to ws-msn-erro-cod
               move "Erro ao abrir arquivo para leitura" to ws-msn-erro-text
               perform finaliza-anormal
           end-if


           perform varying ws-ind-est from 1 by 1 until ws-ind-est>26

               read arqEstados
      *>       tratamento de file status
               if ws-fs-arqEstados  <> 00 and ws-fs-arqEstados <> 10 then
                   move 2                                        to ws-msn-erro-ofsset
                   move ws-fs-arqEstados                        to ws-msn-erro-cod
                   move "Erro ao ler arquivo para inicializacao" to ws-msn-erro-text
                   perform finaliza-anormal
               end-if

               move fd-estados to ws-estados(ws-ind-est)

           end-perform
           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Processamento principal
      *>------------------------------------------------------------------------
       processamento section.

      *>    menu do sistema
           perform until ws-sair = "X"
                      or ws-sair = "x"

               move space  to ws-cadastro-jogadores
               move space  to ws-jogar
               move space  to ws-sair

               display sc-tela-menu
               accept sc-tela-menu

               if  ws-cadastro-jogadores  = "X"
               or  ws-cadastro-jogadores  = "x"  then
                    perform cadastrar-jogadores
               end-if

               if  ws-jogar = "X"
               or  ws-jogar = "x" then
                    perform jogar
               end-if

           end-perform
      *>   chamar impressao de relatorio
           move spaces to ws-sair
           perform relatorio-final


           .
       processamento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Cadastro de jogadores, sao admitidos até 4 jogadores
      *>------------------------------------------------------------------------
       cadastrar-jogadores section.

           perform until ws-sair = "V"
                      or ws-sair = "v"

               move space  to ws-nome-jogador

               display sc-tela-cad-jogador
               accept sc-tela-cad-jogador

               move space     to   ws-msn

               if ws-nome-jogador <> space then  *> Consistindo a digitação do User, nomes = spaces  são ignorados
                   perform descobrir-prox-ind-jog
                   if ws-ind-jog <= 4 then  *> Consistencia da quantidade de jogadores para evitar estouro de tabela

      *>               salvar jogador na tabela de jogadores
                       move ws-nome-jogador   to  ws-nome-jog(ws-ind-jog)
                   else
                       move "Quantidade de jogadores completa" to ws-msn
                   end-if
               end-if

           end-perform
           .
       cadastrar-jogadores-exit.
           exit.


      *>------------------------------------------------------------------------
      *>   Motor do jogo
      *>------------------------------------------------------------------------
       jogar section.

           perform until ws-sair = "V"
                      or ws-sair = "v"

               perform varying  ws-ind-jog  from 1 by 1 until ws-ind-jog > 4
                                                          or  ws-nome-jog(ws-ind-jog) = spaces
                                                          or  ws-sair = "V"
                                                          or  ws-sair = "v"
      *>           Jogador da rodada...
                   move ws-nome-jog(ws-ind-jog)   to   ws-nome-jogador
                   move ws-pontos(ws-ind-jog)     to   ws-pontos-jogador

                   perform sorteia-estado
                   move ws-estado(ws-ind-est)     to   ws-estado-sorteado

                   move space                     to   ws-capital-jog
                   move space                     to   ws-msn

                   display sc-tela-jogar
                   accept sc-tela-jogar


      *>           Testa se jogador acertou a resposta
                   if ws-capital-jog = ws-capital(ws-ind-est) then
                         add 1 to ws-pontos(ws-ind-jog)
                         move "Acertou!!!"  to ws-msn
                   else
                         move "Errou!!!"    to ws-msn
                   end-if

                   display sc-tela-jogar
                   accept sc-tela-jogar

               end-perform

           end-perform

           .
       jogar-exit.
           exit.


      *>------------------------------------------------------------------------
      *>   Descobrir a proxima posição livre dentro da tabela de jogadores
      *>------------------------------------------------------------------------
       descobrir-prox-ind-jog section.
           perform varying ws-ind-jog from 1 by 1 until ws-ind-jog > 4
                                                     or ws-nome-jog(ws-ind-jog) = space
               continue
           end-perform
           .
       descobrir-prox-ind-jog-exit.
           exit.

      *>------------------------------------------------------------------------
      *>   Sorteia o estado
      *>------------------------------------------------------------------------
       sorteia-estado section.
            move 1 to ws-ind-arq
            move zero   to   ws-ind-est
            perform until ws-ind-est <> 0
               accept semente from time

               compute num_random = function random(semente)

               multiply num_random by 26 giving ws-ind-est

      *>        perform until ws-ind-arq > ws-ind-est
      *>
      *>            read arqEstados
      *>            move fd-estados to ws-estados
      *>            add 1 to ws-ind-arq
      *>
      *>        end-perform
            end-perform
           .
       sorteia-estado-exit.
           exit.


      *>------------------------------------------------------------------------
      *>   Imprimindo relatório final
      *>------------------------------------------------------------------------
       relatorio-final section.

           perform until ws-sair = "X"
                      or ws-sair = "x"

               perform ordenar-jogadores

               move space to ws-msn
               move space to ws-sair

               display sc-tela-relatorio
               accept sc-tela-relatorio

           end-perform

           .
       relatorio-final-exit.
           exit.


      *>------------------------------------------------------------------------
      *>   Ordenação da tabela de jogadores
      *>------------------------------------------------------------------------
       ordenar-jogadores section.
           set trocou  to true

           perform until nao_trocou
               move 1           to     ws-ind-jog

               set nao_trocou   to true

               perform until ws-ind-jog = 4
                       or    ws-nome-jog(ws-ind-jog + 1) = space
      *>
                   if ws-pontos(ws-ind-jog) < ws-pontos(ws-ind-jog + 1) then  *> critério de ordenação é "pontos do jogador"
      *>                FAZ TROCA...
                       move ws-jogadores(ws-ind-jog + 1)  to  ws-jogadores-aux
                       move ws-jogadores(ws-ind-jog)      to  ws-jogadores(ws-ind-jog + 1)
                       move ws-jogadores-aux              to  ws-jogadores(ws-ind-jog)

                       set trocou         to  true

                   end-if
                   add  1   to ws-ind-jog
               end-perform
           end-perform

           .
       ordenar-jogadores-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Finalização  Anormal
      *>------------------------------------------------------------------------
       finaliza-anormal section.
           display erase
           display ws-msn-erro-ofsset
           display ws-msn-erro-cod
           display ws-msn-erro-text
           Stop run
           .
       finaliza-anormal-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Finalização
      *>------------------------------------------------------------------------
       finaliza section.
           close arqEstados

      *>   tratamento de file status
           if ws-fs-arqEstados  <> 00 then
               move 3                        to ws-msn-erro-ofsset
               move ws-fs-arqEstados        to ws-msn-erro-cod
               move "Erro ao fechar arquivo" to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           Stop run
           .
       finaliza-exit.
           exit.

