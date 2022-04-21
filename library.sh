function validint
{
  number="$1"
  min="$2"
  max="$3"
  
  if [ -z $number ]
  then
    echo "You didn't provide anything, please provide a number [min] [max]" >&2
    return 1
  fi
  
  if [ $(echo "$number" | cut -c1) = '-' ]
  then
    testnumber="$(echo "$number" | cut -c2-)"
  else
    testnumber="$number"
  fi
  
  if [ ! -z $(echo "$testnumber" | sed 's/[[:digit:]]//g') ]
  then
    echo "Usage $0: Not a valid number, only digits allowed" >&2
    return 1
  fi
  
  if [ ! -z "$min" ]
  then
    if [ "$number" -lt "$min" ]
    then
      echo "The number provided is too short, min value allowed is: $min" >&2
      return 1
    fi
  fi
  
  if [ ! -z "$max" ]
  then
    if [ "$number" -gt "$max" ]
    then
      echo "The number provided is too big, max value allowed is: $max" >&2
      return 1
    fi
  fi
  
  return 0
}

function validFloat
{
	float="$1"
	if [ ! -z $(echo $float |  sed 's/[^.]//g' ) ]
	then
		decimal="$(echo $float | cut -d. -f1)"
		fractional="$(echo $float | cut -d. -f2)"
		
		if [ ! -z "$decimal" ]
		then
			if ! validint "$decimal" "" ""
			then
				return 1
			fi
		fi

		if [ ! -z "$fractional" ]
		then
			if [ $(echo $fractional | cut -c1) = "-" ]
			then
				return 1
			else
				if ! validint "$fractional" "" "" 
				then
					return 1
				fi
			fi
		else
			return 1
		fi
	else
		if [ "$float"	= "-" ]
		then
			return 1
		else
			if ! validint "$float" "" ""
			then
				return 1
			fi
		fi
	fi
	return 0
}

function isLeapYear
{
  #return 0 if it is a leap year
  # 1 otherwise
  year=$1
  if [ $((year%4)) -ne 0 ]; then
    return 1
  elif [ $((year%400)) -eq 0 ]; then
    return 0
  elif [ $((year%100)) -eq 0 ];then
    return 1
  else
    return 0
  fi
}

function in_path()
{
  cmd=$1
  ourpath=$2
  result=1
  oldIFS=$IFS
  IFS=":"
  
  for directory in $ourpath
  do
    if [ -x $directory/$cmd ]
    then
      result=0
    fi
  done

  IFS=$oldIFS
  return $result
}

function checkForCmdInPath()
{
  var="$1"
  if [ "$var" != "" ]
  then
    if [ "${var:0:1}" = "/" ]
    then
      if [ ! -x $var ]
      then
        return 1
      fi
    elif ! in_path $var "$PATH"
    then
      return 2
    fi
  fi
}

name="Aldo Aranda"
