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

# Define a expressão regular para IPv4
OCTETO="((1[0-9]|[1-9])?[0-9]|2([0-4][0-9]|5[0-5]))"
IPV4="${OCTETO}(\.${OCTETO}){3}"

################################################################################

# Executa a busca pelas expressões que combinam na base de teste
CORRETO1=$(grep -E \"${IPV4}\" ${ARQ_TEST})
# Busca as linhas que devem estar corretas para verificar a corretude
CORRETO2=$(grep -F "//Correto" ${ARQ_TEST})

# Busca as linhas que não casam com a expressão regular
INCORRETO1=$(grep -Ev \"${IPV4}\" ${ARQ_TEST})
# Busca as linhas que devem estar incorretas para verificar a corretude
INCORRETO2=$(grep -F "//Incorreto" ${ARQ_TEST})

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
   grep -E \"${IPV4}\" ${ARQ_TEST}
   echo ""
fi

# Se for passado o parâmetro --debug
# e a variável de erro INCORRETO_BOOL estiver ativa
# imprime o resultado do inverso da busca na base de teste
if test $# -eq 1 -a "$1" = "--debug" -a ${INCORRETO_BOOL} -eq 1
then
   grep -Ev \"${IPV4}\" ${ARQ_TEST}
   echo ""
fi

################################################################################

# Imprime um resumo da busca indicando se houve falha ou não
echo -e "${CORRETUDE_MSG}"
