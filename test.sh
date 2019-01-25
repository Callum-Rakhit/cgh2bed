#!/usr/bin/env sh

main () {
  local var1="(NR>1) && ($3 > "$1" )"
  echo $var1
}

main "word"
