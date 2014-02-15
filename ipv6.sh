#!/bin/bash

# Versão inspirada em https://gist.github.com/syzdek/6086792
# Serão feitas algumas alterações para remover pequensa redundâncias,
# endereços deprecados e posteriormente adequado a RFC 5952.
 
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
RE_IPV4="${OCTETO}(\.${OCTETO}){3}"

# Define a expressão regular para IPv6
HEXADECATETO="[0-9a-fA-F]{1,4}"
                                                                   #       Mínimo::Máximo   Máximo::Máximo  Máximo::Mínimo
RE_IPV6="("
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){7}${HEXADECATETO}|"          # TEST: 1:2:3:4:5:6:7:8
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,7}:|"                      # TEST: 1::                              1:2:3:4:5:6:7::
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,6}:${HEXADECATETO}|"       # TEST: 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,5}(:${HEXADECATETO}){2}|"  # TEST: 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,4}(:${HEXADECATETO}){3}|"  # TEST: 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,3}(:${HEXADECATETO}){4}|"  # TEST: 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,2}(:${HEXADECATETO}){5}|"  # TEST: 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
RE_IPV6="${RE_IPV6}${HEXADECATETO}:(:${HEXADECATETO}){6}|"         # TEST: 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
RE_IPV6="${RE_IPV6}:((:${HEXADECATETO}){1,7}|:)|"                  # TEST: ::2:3:4:5:6:7:8                  ::8       :: 
# IPv4-mapped IPv6 addresses
RE_IPV6="${RE_IPV6}::ffff::${RE_IPV4}"                             # TEST: ::ffff:255.255.255.255
RE_IPV6="${RE_IPV6})"

################################################################################

# Executa a busca pelas expressões que combinam na base de teste
CORRETO1=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -E "\"${RE_IPV6}\"")
# Busca as linhas que devem estar corretas para verificar a corretude
CORRETO2=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -F "//Correto")

# Busca as linhas que não casam com a expressão regular
INCORRETO1=$(sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -Ev "\"${RE_IPV6}\"")
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
   sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -E "\"${RE_IPV6}\""
   echo ""
fi

# Se for passado o parâmetro --debug
# e a variável de erro INCORRETO_BOOL estiver ativa
# imprime o resultado do inverso da busca na base de teste
if test $# -eq 1 -a "$1" = "--debug" -a ${INCORRETO_BOOL} -eq 1
then
   sed -r '/^#|^$/d' ${ARQ_TEST} | grep --color=never -Ev "\"${RE_IPV6}\""
   echo ""
fi

################################################################################

# Imprime um resumo da busca indicando se houve falha ou não
echo -e "${CORRETUDE_MSG}"
