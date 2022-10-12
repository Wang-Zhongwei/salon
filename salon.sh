#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# display all services
SERVICE_ID_SELECTED=0
while [[ ! $SERVICE_ID_SELECTED =~ ^[1-6]$ ]]
do
  echo -e "\nWelcome to My Salon, how can I help you?\n"
  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) exit"
  read SERVICE_ID_SELECTED
done

SERVICE=''
case $SERVICE_ID_SELECTED in
  1) SERVICE='cut' ;;
  2) SERVICE='color' ;;
  3) SERVICE='perm' ;;
  4) SERVICE='style' ;;
  5) SERVICE='trim' ;;
  6) exit 0 ;;
esac

# get customer's phone number
echo -e "\nWhat's your phone number?\n"
read CUSTOMER_PHONE

# look up customer by phone number
CUSTOMER_LOOKUP_RESULT=$($PSQL "select customer_id, name from customers where phone='$CUSTOMER_PHONE'")
read CUSTOMER_ID BAR CUSTOMER_NAME <<< $(echo $CUSTOMER_LOOKUP_RESULT)

# if no record found 
if [[ -z $CUSTOMER_ID ]]
then
  # ask for more information
  echo -e "\nI don't have a record for that phone number, what's your name?\n"
  read CUSTOMER_NAME

  # save to customers databse while returning customer_id
  CUSTOMER_ID=$($PSQL "insert into customers values(default, '$CUSTOMER_NAME', '$CUSTOMER_PHONE') returning customer_id" | head -1)
fi

echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?\n"
read SERVICE_TIME

INSERT_RESULT=$($PSQL "insert into appointments values(default, $CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

echo -e "-nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."


