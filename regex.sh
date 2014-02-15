#!/bin/bash

# Verifica se o número de argumentos passado está correto
if test $# -lt 1 -o $# -gt 2
then
   echo "Número de parâmetros incorreto"
   exit
fi

# Verifica se o arquivo com a regex existe e se a extensão é .re
if test -f $1 -a "re" = $(echo $1 | awk -F"." '{print $NF}')
then
   ARQ_REGEX=$1
else
   echo -e "Arquivo de expressão regular '$1' inválido.\nVerifique se a extensão do arquivo está correta, deve ser .re."
   exit
fi

# Define o nome do arquivo de base de teste
# este é composto pelo nome do arquivo da regex concatenado com "-test.txt"
# e está incluido no diretório "base"
ARQ_TEST=$(echo ${ARQ_REGEX} | awk -F"/" '{print $NF}' | sed -r 's/\.re$//g')
ARQ_TEST="base/${ARQ_TEST}-test.txt"

# Verifica a existência do arquivo de base de teste
if test ! -f ${ARQ_TEST}
then
   echo "Arquivo base de testes '${ARQ_TEST}' inválido."
   exit
fi

################################################################################

# Define a expressão regular que será usada
RE=$(sed -r '/^#|^$/d' ${ARQ_REGEX})

################################################################################

# Caso atenda as restrições, o programa irá imprimir a regex e então finalizar
if test $# -eq 2 -a "$2" = "--regex-print"
then
   echo "${RE}"
   exit
fi

################################################################################

# Executa a busca pelas expressões que combinam na base de teste
CORRETO1=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -E "\"${RE}\"")
# Busca as linhas que devem estar corretas para verificar a corretude
CORRETO2=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -F "//Correto")

# Busca as linhas que não casam com a expressão regular
INCORRETO1=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -Ev "\"${RE}\"")
# Busca as linhas que devem estar incorretas para verificar a corretude
INCORRETO2=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -F "//Incorreto")

################################################################################

# Verifica se todos os valores corretos foram encontrados
# se não ativa a flag CORRETO_BOOL indicando erro
CORRETUDE_MSG="Corretude dos valores corretos:   "
if test "${CORRETO1}" = "${CORRETO2}"
then
   CORRETUDE_MSG="${CORRETUDE_MSG}Ok\n"
   CORRETO_BOOL=1
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
   INCORRETO_BOOL=1
else
   CORRETUDE_MSG="${CORRETUDE_MSG}Fail\n"
   INCORRETO_BOOL=1
fi

################################################################################

echo ""

# Se for passado o parâmetro --debug
# e a variável de erro CORRETO_BOOL estiver ativa
# imprime o resultado da busca na base de teste
if test $# -eq 2 -a "$2" = "--debug" -a ${CORRETO_BOOL} -eq 1
then
   sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -E "\"${RE}\""
   echo ""
fi

# Se for passado o parâmetro --debug
# e a variável de erro INCORRETO_BOOL estiver ativa
# imprime o resultado do inverso da busca na base de teste
if test $# -eq 2 -a "$2" = "--debug" -a ${INCORRETO_BOOL} -eq 1
then
   sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -Ev "\"${RE}\""
   echo ""
fi

################################################################################

# Imprime um resumo da busca indicando se houve falha ou não
echo -e "${CORRETUDE_MSG}"
