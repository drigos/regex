#!/bin/bash

ARQ_TEST=$(echo $0 | sed -r 's/(\.\/|\.sh$)//g')
ARQ_TEST="${ARQ_TEST}-test.txt"

if test ! -f $ARQ_TEST
then
   echo "Arquivo base de testes não encontrado."
   exit
fi

OCTETO="((1[0-9]|[1-9])?[0-9]|2([0-4][0-9]|5[0-5]))"
IPV4="${OCTETO}(\.${OCTETO}){3}"

grep --color=always -E \"${IPV4}\" ${ARQ_TEST}
echo -e "\n"
grep --color=always -Ev \"${IPV4}\" ${ARQ_TEST}
