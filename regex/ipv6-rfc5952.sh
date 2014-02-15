#!/bin/bash

OCTETO="((1[0-9]|[1-9])?[0-9]|2([0-4][0-9]|5[0-5]))"
RE_IPV4="${OCTETO}(\.${OCTETO}){3}"

HEXADECATETO="[0-9a-f]{1,4}"

RE_IPV6="("
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){7}${HEXADECATETO}|"
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,7}:|"
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,6}:${HEXADECATETO}|"
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,5}(:${HEXADECATETO}){2}|"
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,4}(:${HEXADECATETO}){3}|"
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,3}(:${HEXADECATETO}){4}|"
RE_IPV6="${RE_IPV6}(${HEXADECATETO}:){1,2}(:${HEXADECATETO}){5}|"
RE_IPV6="${RE_IPV6}${HEXADECATETO}:(:${HEXADECATETO}){6}|"
RE_IPV6="${RE_IPV6}:((:${HEXADECATETO}){1,7}|:)|"
RE_IPV6="${RE_IPV6}::ffff:${RE_IPV4}"
RE_IPV6="${RE_IPV6})"

RE=${RE_IPV6}

# Forma didatica da expressão

#                                                                                  Mínimo           Máximo
# RE_IPV6="           ("
# RE_IPV6="${RE_IPV6} (${HEXADECATETO}:){7}    ${HEXADECATETO}         |"  # TEST: 1:2:3:4:5:6:7:8
# RE_IPV6="${RE_IPV6} (${HEXADECATETO}:){1,7} :                        |"  # TEST: 1::              1:2:3:4:5:6:7::
# RE_IPV6="${RE_IPV6} (${HEXADECATETO}:){1,6} :${HEXADECATETO}         |"  # TEST: 1::8             1:2:3:4:5:6::8
# RE_IPV6="${RE_IPV6} (${HEXADECATETO}:){1,5}(:${HEXADECATETO}){2}     |"  # TEST: 1::7:8           1:2:3:4:5::7:8
# RE_IPV6="${RE_IPV6} (${HEXADECATETO}:){1,4}(:${HEXADECATETO}){3}     |"  # TEST: 1::6:7:8         1:2:3:4::6:7:8
# RE_IPV6="${RE_IPV6} (${HEXADECATETO}:){1,3}(:${HEXADECATETO}){4}     |"  # TEST: 1::5:6:7:8       1:2:3::5:6:7:8
# RE_IPV6="${RE_IPV6} (${HEXADECATETO}:){1,2}(:${HEXADECATETO}){5}     |"  # TEST: 1::4:5:6:7:8     1:2::4:5:6:7:8
# RE_IPV6="${RE_IPV6}  ${HEXADECATETO}:      (:${HEXADECATETO}){6}     |"  # TEST: 1::3:4:5:6:7:8   1::3:4:5:6:7:8
# RE_IPV6="${RE_IPV6}                 :     ((:${HEXADECATETO}){1,7}|:)|"  # TEST: ::8              ::2:3:4:5:6:7:8   :: 
# RE_IPV6="${RE_IPV6} ::ffff:${RE_IPV4}"                                   # TEST: ::ffff:255.255.255.255 - IPv4-mapped IPv6 addresses
# RE_IPV6="${RE_IPV6} )"

# Diferenças
# ( ) Zeros a esquerda de um campo 16-bit devem ser suprimidos:
#        2001:0db8::0001 -> 2001:db8::1
# ( ) Ao usar :: aplique de forma integral e não parcial:
#        2001:db8:0:0:0:0:2:1  ->  2001:db8::1
#        2001:db8:0:0:0:0:2:1 -x-> 2001:db8::0:1
# ( ) Não deve-se usar o :: em apenas um campo 16-bit:
#        2001:db8:0:1:1:1:1:1 -x-> 2001:db8::1:1:1:1:1
# ( ) O :: deve ficar sempre onde proporcionará o menor endereço:
#        2001:0:0:1:0:0:0:1  ->  2001:0:0:1::1
#        2001:0:0:1:0:0:0:1 -x-> 2001::1:0:0:0:1
# ( ) Caso o tamanho do endereço seja o mesmo independende de onde aplicar a redução ::, use na primeira sequência:
#        2001:db8:0:0:1:0:0:1  ->  2001:db8::1:0:0:1
#        2001:db8:0:0:1:0:0:1 -x-> 2001:db8:0:0:1::1
# (X) Os caracteres "a", "b", "c", "d", "e", e "f" devem sempre ser representados em minúsculo:
#        2001:db8::1 -x-> 2011:DB8:1
