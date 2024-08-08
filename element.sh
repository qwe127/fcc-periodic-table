#!/bin/bash

#comment
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


PROMPT=$1
REG='^[0-9]+$'

QUERY(){
  SEARCH=$($PSQL "SELECT * FROM elements WHERE symbol='$PROMPT' OR name='$PROMPT'")
  
  
  if ! [[ $PROMPT =~ $REG ]]
  then
    ELEMENTS_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$PROMPT' OR name='$PROMPT'")
    ELEMENTS_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$PROMPT' OR name='$PROMPT'")
    ELEMENTS_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$PROMPT' OR name='$PROMPT'")
    
    PROPERTIES_MASS=$($PSQL "SELECT atomic_mass FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number WHERE symbol='$PROMPT' OR name='$PROMPT'")
    PROPERTIES_MP=$($PSQL "SELECT melting_point_celsius FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number WHERE symbol='$PROMPT' OR name='$PROMPT'")
    PROPERTIES_BP=$($PSQL "SELECT boiling_point_celsius FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number WHERE symbol='$PROMPT' OR name='$PROMPT'")
    
    PROPERTIES_TYPE=$($PSQL "SELECT type FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$PROMPT' OR name='$PROMPT'")
    

  elif [[ $PROMPT =~ $REG ]]
  then
    ELEMENTS_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$PROMPT")
    ELEMENTS_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$PROMPT")
    ELEMENTS_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$PROMPT")
    
    PROPERTIES_MASS=$($PSQL "SELECT atomic_mass FROM properties FULL JOIN elements USING(atomic_number) WHERE atomic_number=$PROMPT")
    PROPERTIES_MP=$($PSQL "SELECT melting_point_celsius FROM properties FULL JOIN elements USING(atomic_number) WHERE atomic_number=$PROMPT")
    PROPERTIES_BP=$($PSQL "SELECT boiling_point_celsius FROM properties FULL JOIN elements USING(atomic_number) WHERE atomic_number=$PROMPT")
    
    PROPERTIES_TYPE=$($PSQL "SELECT type FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$PROMPT")   
    
  fi
  
  if [[ -z $ELEMENTS_NAME ]]
  then
    echo 'I could not find that element in the database.'
  else
    echo "The element with atomic number $ELEMENTS_ATOMIC_NUMBER is $ELEMENTS_NAME ($ELEMENTS_SYMBOL). It's a $PROPERTIES_TYPE, with a mass of $PROPERTIES_MASS amu. $ELEMENTS_NAME has a melting point of $PROPERTIES_MP celsius and a boiling point of $PROPERTIES_BP celsius."
  fi
}


if [[ -z $PROMPT ]]
then
  echo 'Please provide an element as an argument.'
else
  QUERY
fi





