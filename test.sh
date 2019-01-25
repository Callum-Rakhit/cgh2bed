#!/usr/bin/env sh

main () {
  local var1='(NR>1) && ($3>'$1')'
  echo $var1
  echo 'summary_over_'$var1'_as_bed.bed'
}

main 100
