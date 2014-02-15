([0-9a-fA-F]{2}([:-])[0-9a-fA-F]{2}(\2[0-9a-fA-F]{2}){4}|[0-9a-fA-F]{4}(\.[0-9a-fA-F]{4}){2})

# Forma didatica da expressão

# OCTETO="[0-9a-fA-F]{2}"
# HEXADECATETO="[0-9a-fA-F]{4}"

# RE_MAC="          ("
# RE_MAC="${RE_MAC} ${OCTETO}([:-])${OCTETO}(\2${OCTETO}){4}|"  # TEST: AA:BB:CC:DD:EE:FF  AA-BB-CC-DD-EE-FF
# RE_MAC="${RE_MAC} ${HEXADECATETO}(\.${HEXADECATETO}){2}"      # TEST: AABB.CCDD.EEFF
# RE_MAC="${RE_MAC} )"
