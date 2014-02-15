#!/bin/bash

OCTETO="[0-9a-fA-F]{2}"
HEXADECATETO="[0-9a-fA-F]{4}"

RE_MAC="("
RE_MAC="${RE_MAC}${OCTETO}([:-])${OCTETO}(\2${OCTETO}){4}|"
RE_MAC="${RE_MAC}${HEXADECATETO}(\.${HEXADECATETO}){2}"
RE_MAC="${RE_MAC})"

RE=${RE_MAC}

# Forma didatica da expressão

# RE_MAC="          ("
# RE_MAC="${RE_MAC} ${OCTETO}([:-])${OCTETO}(\2${OCTETO}){4}|"  # TEST: AA:BB:CC:DD:EE:FF  AA-BB-CC-DD-EE-FF
# RE_MAC="${RE_MAC} ${HEXADECATETO}(\.${HEXADECATETO}){2}"      # TEST: AABB.CCDD.EEFF
# RE_MAC="${RE_MAC} )"
