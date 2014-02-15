#!/bin/bash

# Define o nome do arquivo de base de teste
# este é composto pelo nome do próprio script concatenado com "-test.txt"
ARQ_TEST=$(echo $0 | sed -r 's/(\.\/|\.sh$)//g')
ARQ_TEST="${ARQ_TEST}-test.txt"

# Verifica a existência do arquivo de base de teste
if test ! -f ${ARQ_TEST}
then
   echo "Arquivo base de testes não encontrado."
   exit
fi

################################################################################

# Define a expressão regular para MAC Address
OCTETO="[0-9a-fA-F]{2}"
HEXADECATETO="[0-9a-fA-F]{4}"

RE_MAC="("
RE_MAC="${RE_MAC}${OCTETO}([:-])${OCTETO}(\2${OCTETO}){4}|"  # TEST: AA:BB:CC:DD:EE:FF  AA-BB-CC-DD-EE-FF
RE_MAC="${RE_MAC}${HEXADECATETO}(\.${HEXADECATETO}){2}"      # TEST: AABB.CCDD.EEFF
RE_MAC="${RE_MAC})"

################################################################################

if test $# -eq 1 -a "$1" = "--regex-print"
then
   echo "${RE_MAC}"
   exit
fi

################################################################################

# Executa a busca pelas expressões que combinam na base de teste
CORRETO1=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -E "\"${RE_MAC}\"")
# Busca as linhas que devem estar corretas para verificar a corretude
CORRETO2=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -F "//Correto")

# Busca as linhas que não casam com a expressão regular
INCORRETO1=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -Ev "\"${RE_MAC}\"")
# Busca as linhas que devem estar incorretas para verificar a corretude
INCORRETO2=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -F "//Incorreto")

################################################################################

# Verifica se todos os valores corretos foram encontrados
# se não ativa a flag CORRETO_BOOL indicando erro
CORRETUDE_MSG="Corretude dos valores corretos:   "
if test "${CORRETO1}" = "${CORRETO2}"
then
   CORRETUDE_MSG="${CORRETUDE_MSG}Ok\n"
   CORRETO_BOOL=0
else
   CORRETUDE_MSG="${CORRETUDE_MSG}Fail\n"
   CORRETO_BOOL=1
fi

### Essa verificação é redudante devido a presença da anterior ###
# Verifica se nenhum dos valores incorretos casou com a expressão
# se não ativa a flag INCORRETO_BOOL indicando erro
CORRETUDE_MSG="${CORRETUDE_MSG}Corretude dos valores incorretos: "
if test "${INCORRETO1}" = "${INCORRETO2}"
then
   CORRETUDE_MSG="${CORRETUDE_MSG}Ok\n"
   INCORRETO_BOOL=0
else
   CORRETUDE_MSG="${CORRETUDE_MSG}Fail\n"
   INCORRETO_BOOL=1
fi

################################################################################

echo ""

# Se for passado o parâmetro --debug
# e a variável de erro CORRETO_BOOL estiver ativa
# imprime o resultado da busca na base de teste
if test $# -eq 1 -a "$1" = "--debug" -a ${CORRETO_BOOL} -eq 1
then
   sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -E "\"${RE_MAC}\""
   echo ""
fi

# Se for passado o parâmetro --debug
# e a variável de erro INCORRETO_BOOL estiver ativa
# imprime o resultado do inverso da busca na base de teste
if test $# -eq 1 -a "$1" = "--debug" -a ${INCORRETO_BOOL} -eq 1
then
   sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -Ev "\"${RE_MAC}\""
   echo ""
fi

################################################################################

# Imprime um resumo da busca indicando se houve falha ou não
echo -e "${CORRETUDE_MSG}"
