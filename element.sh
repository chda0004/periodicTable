#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ATOMIC_NUMBER_FOUND() {
# a function has find the atomic number. create the end

NAME=$($PSQL "SELECT name from elements WHERE atomic_number =$1")
SYMBOL=$($PSQL "SELECT symbol from elements WHERE atomic_number =$1")
MASS=$($PSQL "SELECT atomic_mass from properties WHERE atomic_number =$1")
MELTING=$($PSQL "SELECT melting_point_celsius from properties WHERE atomic_number =$1")
BOILING=$($PSQL "SELECT boiling_point_celsius from properties WHERE atomic_number =$1")
TYPE=$($PSQL "SELECT type FROM properties LEFT JOIN types USING (type_id) WHERE properties.atomic_number=$1")
echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
STATE="DONE"
}

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  #Valid argument
  if [[ $1 =~ ^[0-9+$] ]]
  then
    #check if the arguemnt was a atomic_number
    RETURN_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements WHERE atomic_number =$1")
    if [[ -n $RETURN_ATOMIC_NUMBER ]]
    then
      ATOMIC_NUMBER_FOUND $RETURN_ATOMIC_NUMBER
    fi
  fi
  #check if the arguemnt was a name
  RETURN_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements WHERE name ='$1'")
  if [[ -n $RETURN_ATOMIC_NUMBER ]]
  then
    ATOMIC_NUMBER_FOUND $RETURN_ATOMIC_NUMBER
  fi

#check if the arguemnt was a symbol
  RETURN_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements WHERE symbol ='$1'")
  if [[ -n $RETURN_ATOMIC_NUMBER ]]
  then
    ATOMIC_NUMBER_FOUND $RETURN_ATOMIC_NUMBER
  fi
#Element not found
  if [[ $STATE != "DONE"  ]]
  then
    echo I could not find that element in the database.
  fi

fi