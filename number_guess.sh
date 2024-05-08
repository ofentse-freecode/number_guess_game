#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~~Guessing Game~~~~~"
echo "Enter your username:"
read USERNAME 

USERNAME_AVAIL=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
if [[ -z $USERNAME_AVAIL ]]
then
INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else 
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT num_games FROM users WHERE username='$USERNAME'")
echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi 

RAN_NUM=$(( RANDOM % 1000 + 1 )) 
echo $RAN_NUM
NUMBER_GUESS=1
echo "Guess the secret number between 1 and 1000:"

while read GUESS
  do 
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then 
    echo "That is not an integer, guess again:"
    else
    if [[ $GUESS -eq $RAN_NUM ]]
      then
      break
    else
      if [[ $RAN_NUM -gt $GUESS ]]
      then
      echo "It's higher than that, guess again:"
    else
    if [[ $RAN_NUM -lt $GUESS  ]]
      then
      echo "It's lower than that, guess again:"
      fi
    fi
  fi
  fi
 NUMBER_GUESS=$(( $NUMBER_GUESS +  1 )) 
done



echo "You guessed it in $NUMBER_GUESS tries. The secret number was $GUESS. Nice job!"
 
 


GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))
ADD_GAME=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username =  '$USERNAME'")

if [[ $NUMBER_GUESS -gt $BEST_GAME ]]
then
UPDATE_USER=$($PSQL "UPDATE users SET num_games = $NUMBER_GUESS WHERE username =  '$USERNAME'")
fi
