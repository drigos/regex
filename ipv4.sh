#!/bin/bash

ARQ_TEST=$(echo $0 | sed -r 's/(\.\/|\.sh$)//g')
ARQ_TEST="${ARQ_TEST}-test.txt"

if test ! -f ${ARQ_TEST}
then
   echo "Arquivo base de testes não encontrado."
   exit
fi

#############

OCTETO="((1[0-9]|[1-9])?[0-9]|2([0-4][0-9]|5[0-5]))"
IPV4="${OCTETO}(\.${OCTETO}){3}"

#############

CORRETO1=$(grep -E \"${IPV4}\" ${ARQ_TEST})
CORRETO2=$(grep -F "//Correto" ${ARQ_TEST})

INCORRETO1=$(grep -Ev \"${IPV4}\" ${ARQ_TEST})
INCORRETO2=$(grep -F "//Incorreto" ${ARQ_TEST})

#############

CORRETUDE_MSG="Corretude dos valores corretos:   "
if test "${CORRETO1}" = "${CORRETO2}"
then
   CORRETUDE_MSG="${CORRETUDE_MSG}Ok\n"
   CORRETO_BOOL=0
else
   CORRETUDE_MSG="${CORRETUDE_MSG}Fail\n"
   CORRETO_BOOL=1
fi

CORRETUDE_MSG="${CORRETUDE_MSG}Corretude dos valores incorretos: "
if test "${INCORRETO1}" = "${INCORRETO2}"
then
   CORRETUDE_MSG="${CORRETUDE_MSG}Ok\n"
   INCORRETO_BOOL=0
else
   CORRETUDE_MSG="${CORRETUDE_MSG}Fail\n"
   INCORRETO_BOOL=1
fi

#############

echo ""

if test $# -eq 1 -a "$1" = "--debug" -a ${CORRETO_BOOL} -eq 1
then
   grep -E \"${IPV4}\" ${ARQ_TEST}
   echo ""
fi

if test $# -eq 1 -a "$1" = "--debug" -a ${INCORRETO_BOOL} -eq 1
then
   grep -Ev \"${IPV4}\" ${ARQ_TEST}
   echo ""
fi

#############

echo -e "${CORRETUDE_MSG}"
