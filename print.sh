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

function pshSpaceCharacter {

  local length=$1

  pshLoop " " "${length}"
}

function pshNewLine {

  echo -e ""
}

function pshText {

  local input=$1
  local alignment=$2

  if [[ ${alignment} == c* ]] ; then
    pshTextCenter "${input}"
  elif [[ ${alignment} == r* ]] ; then
    pshTextRight "${input}"
  else
    pshTextLeft "${input}"
  fi
}

function pshTextLeft {

  local input=$1

  # Exclude the left (* ) and right ( *) margins from the line width
  local line_width=$(( ${psh_line_width} - 4 ))
 
  # Remove the console color characters from the text
  local text_length=$(( $( echo "${input}" | sed "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | wc -c ) - 1 ))
  
  # Add the space for the left margin
  local space_left_length=1
  # Add the space for the right margin
  local space_right_length=$(( ${line_width} - ${text_length} + 1 ))

  pshPrimaryCharacter 1
  pshSpaceCharacter $space_left_length
  echo -n "${input}"
  pshSpaceCharacter $space_right_length
  pshPrimaryCharacter 1
  pshNewLine
}

function pshTextCenter {

  local input=$1

  # Exclude the left (* ) and right ( *) margins from the line width
  local line_width=$(( ${psh_line_width} - 4 ))

  # Remove the console color characters from the text
  local text_length=$(( $( echo "${input}" | sed "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | wc -c ) - 1 ))
  
  # Add the space for the left margin
  local space_left_length=$(( ( ${line_width} - ${text_length} ) / 2 + 1 ))
  # Add the space for the right margin
  local space_right_length=$(( ( ${line_width} - ${text_length} ) / 2 + 1 ))
  # Add the missing space if the total number of characters is not equal to the line width
  space_right_length=$(( $space_right_length + $line_width + 2 - $text_length - $space_left_length - $space_right_length ))

  pshPrimaryCharacter 1
  pshSpaceCharacter $space_left_length
  echo -n "${input}"
  pshSpaceCharacter $space_right_length
  pshPrimaryCharacter 1
  pshNewLine
}

function pshTextRight {

  local input=$1

  # Exclude the left (* ) and right ( *) margins from the line width
  local line_width=$(( ${psh_line_width} - 4 ))

  # Remove the console color characters from the text
  local text_length=$(( $( echo "${input}" | sed "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | wc -c ) - 1 ))

  # Add the space for the left margin
  local space_left_length=$(( ${line_width} - ${text_length} + 1 ))
  # Add the space for the right margin
  local space_right_length=1

  pshPrimaryCharacter 1
  pshSpaceCharacter $space_left_length
  echo -n "${input}"
  pshSpaceCharacter $space_right_length
  pshPrimaryCharacter 1
  pshNewLine
}

function pshStatus {

  local key=$1
  local value=$2
  local type=$3
  local indent=$4

  # Exclude the left (* ) and right ( *) margins from the line width
  local line_width=$(( ${psh_line_width} - 4 ))
 
  # Remove the console color characters from the text
  local key_length=$(( $( echo "${key}" | sed "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | wc -c ) - 1 ))
  local value_length=$(( $( echo "${value}" | sed "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | wc -c ) - 1 ))
  
  # Add the space for the left margin
  local space_left_length=$(( 1 + $indent * 2 ))
  # Add the space for the right margin
  local space_right_length=1

  local middle_separator_length=$(( $line_width - $key_length - $value_length - 4 - $indent * 2 ))

  pshPrimaryCharacter 1
  pshSpaceCharacter $space_left_length
  echo -n "${key}"
  pshSpaceCharacter 1
  pshSecondaryCharacter $middle_separator_length
  pshSpaceCharacter 1
  echo -n "[${value}]"
  pshSpaceCharacter $space_right_length
  pshPrimaryCharacter 1
  pshNewLine
}

function pshDebugVar {

  local variable=$1
  echo -n "[DEBUG] ${variable}: "
  eval "echo \"\$${variable}\""
}

pshConfig

