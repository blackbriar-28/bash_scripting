#!/bin/bash

echo "Hello there! What is your name?"
read NAME

echo "Hello $NAME, let's play a game!"
echo "I will think of a number between 1 and 100, and you will try to guess it."

NUMBER=$(( (RANDOM % 100) + 1))
COUNT=0

while true; do
    echo "Take a guess:"
    read GUESS
    # add validation in case user enters a non-integer value
    if ! [[ "$GUESS" =~ ^[0-9]+$ ]]; then
        echo "Please enter a valid number."
        continue
    fi

    let COUNT=COUNT+1

    if [ $GUESS -lt $NUMBER ]; then
        echo "Your guess is too low."
    elif [ $GUESS -gt $NUMBER ]; then
        echo "Your guess is too high."
    else
        echo "Good job, $NAME! You guessed my number in $COUNT tries."
        break
    fi
done

echo "$NAME,$COUNT,$(date +%m/%d/%Y) " >> /tmp/guess_number.log
