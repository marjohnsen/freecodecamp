#!/bin/bash

# Database setup
DB_NAME="salon"
DB_USER="freecodecamp"

PSQL="psql --username=$DB_USER --dbname=$DB_NAME -t -c"

echo "~~~~~ MY SALON ~~~~~"
echo "Welcome to My Salon, how can I help you?"

# Function to display services
display_services() {
    echo "Please select a service:"
    echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
}

# Main menu
while true; do
    display_services
    read SERVICE_ID_SELECTED

    # Check if service exists
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_NAME ]]; then
        echo "I could not find that service. What would you like today?"
        continue
    fi

    echo "What's your phone number?"
    read CUSTOMER_PHONE

    # Check if customer exists
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_ID ]]; then
        echo "I don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        # Insert new customer
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    else
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi

    # Prompt for appointment time
    echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    # Insert appointment
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    # Confirm appointment
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

    # Exit after booking
    break
done
