#!/bin/bash

#ARQ_TEST="$0-test.txt"
ARQ_TEST="ipv4-test.txt"

OCTETO="((1[0-9]|[1-9])?[0-9]|2([0-4][0-9]|5[0-5]))"

IPV4="$OCTETO(\.$OCTETO){3}"

grep --color=always -E \"$IPV4\" $ARQ_TEST
echo -e "\n"
grep --color=always -Ev \"$IPV4\" $ARQ_TEST
