#!/bin/bash

ARQ_TEST=$(echo $0 | sed -r 's/(\.\/|\.sh$)//g')
ARQ_TEST="${ARQ_TEST}-test.txt"

if test ! -f ${ARQ_TEST}
then
   echo "Arquivo base de testes não encontrado."
   exit
fi

OCTETO="((1[0-9]|[1-9])?[0-9]|2([0-4][0-9]|5[0-5]))"
IPV4="${OCTETO}(\.${OCTETO}){3}"

grep --color=always -E \"${IPV4}\" ${ARQ_TEST}
CORRETO1=$(grep -E \"${IPV4}\" ${ARQ_TEST})
CORRETO2=$(grep -F "//Correto" ${ARQ_TEST})

echo ""

grep --color=always -Ev \"${IPV4}\" ${ARQ_TEST}
INCORRETO1=$(grep -Ev \"${IPV4}\" ${ARQ_TEST})
INCORRETO2=$(grep -F "//Incorreto" ${ARQ_TEST})

echo ""

echo -n "Corretude dos valores corretos:   "
if test "${CORRETO1}" = "${CORRETO2}"
then
   echo "Ok"
else
   echo "Fail"
fi

echo -n "Corretude dos valores incorretos: "
if test "${INCORRETO1}" = "${INCORRETO2}"
then
   echo "Ok"
else
   echo "Fail"
fi

echo ""
