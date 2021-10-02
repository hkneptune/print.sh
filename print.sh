#!/bin/bash

#
# print.sh
# https://github.com/hkneptune/print.sh
#

typeset psh_line_width=80
typeset psh_primary_character=#
typeset psh_secondary_character=.
typeset psh_regex_number='^[0-9]+$'

function pshConfig {

  if [ -n ${pintsh_line_width+x} ] \
    && [[ ${printsh_line_width} =~ ${psh_regex_number} ]] ; then

    psh_line_width=${printsh_line_width}
  fi

  if [ -n ${printsh_primary_character+x} ] ; then

    psh_primary_character=${printsh_primary_character}
  fi

  if [ -n ${printsh_secondary_character+x} ] ; then
    psh_secondary_character=${printsh_secondary_character}
  fi

  pshDebugVar "psh_line_width"
  pshDebugVar "psh_primary_character"
  pshDebugVar "psh_secondary_character"
}

function pshLoop {

  local character=$1
  local length=$2
  local rtn=0
  local i

  if [ -z ${length} ] ; then
    length="${psh_line_width}"
    rtn=1
  fi

  if [[ "${length}" -eq "0" ]] ; then
    return
  fi

  for i in $( seq 1 ${length} ) ; do

    echo -n "${character}"
  done

  if [[ "${rtn}" -eq "1" ]] ; then
    pshNewLine
  fi
}

function pshPrimaryCharacter {

  local length=$1

  pshLoop "${psh_primary_character}" "${length}"
}

function pshSecondaryCharacter {

  local length=$1

  pshLoop "${psh_secondary_character}" "${length}"
}

function pshNewLine {

  echo -e ""
}

function pshDebugVar {

  local variable=$1
  echo -n "[DEBUG] ${variable}: "
  eval "echo \"\$${variable}\""
}

pshConfig

