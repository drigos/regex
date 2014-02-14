# Versão inspirada em https://gist.github.com/syzdek/6086792
# Serão feitas algumas alterações para remover pequensa redundâncias,
# endereços deprecados e posteriormente adequado a RFC 5952.

OCTETO="((1[0-9]|[1-9])?[0-9]|2([0-4][0-9]|5[0-5]))"
RE_IPV4="${OCTETO}(\.${OCTETO}){3}"
# Esse trecho de código foi retirado de https://gist.github.com/syzdek/6086792
SEG="[0-9a-fA-F]{1,4}"
 
RE_IPV6="([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|"                    # TEST: 1:2:3:4:5:6:7:8
RE_IPV6="${RE_IPV6}([0-9a-fA-F]{1,4}:){1,7}:|"                         # TEST: 1::                              1:2:3:4:5:6:7::
RE_IPV6="${RE_IPV6}([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|"         # TEST: 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
RE_IPV6="${RE_IPV6}([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|"  # TEST: 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
RE_IPV6="${RE_IPV6}([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|"  # TEST: 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
RE_IPV6="${RE_IPV6}([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|"  # TEST: 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
RE_IPV6="${RE_IPV6}([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|"  # TEST: 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
RE_IPV6="${RE_IPV6}[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|"       # TEST: 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
RE_IPV6="${RE_IPV6}:((:[0-9a-fA-F]{1,4}){1,7}|:)|"                     # TEST: ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::     
RE_IPV6="${RE_IPV6}fe08:(:[0-9a-fA-F]{1,4}){2,2}%[0-9a-zA-Z]{1,}|"     # TEST: fe08::7:8%eth0      fe08::7:8%1                                      (link-local IPv6 addresses with zone index)
RE_IPV6="${RE_IPV6}::(ffff(:0{1,4}){0,1}:){0,1}${RE_IPV4}|"            # TEST: ::255.255.255.255   ::ffff:255.255.255.255  ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
RE_IPV6="${RE_IPV6}([0-9a-fA-F]{1,4}:){1,4}:${RE_IPV4}"                # TEST: 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33                        (IPv4-Embedded IPv6 Address)
# Fim do código retirado de https://gist.github.com/syzdek/6086792

grep -v "^#" ipv6-test.txt | grep --color=always -E "\"(${RE_IPV6})\""
