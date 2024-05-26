#!/bin/bash

# Define colors for readability
GREEN="\033[0;32m"
RED="\033[0;31m"
LIGHT_BLUE="\033[1;34m"
NO_COLOR="\033[0m"

# Check if Touch ID is enabled at the beginning
if grep -qxF "auth       sufficient     pam_tid.so" /etc/pam.d/sudo; then
    # Set message for currently enabled Touch ID
    CURRENT_STATE="${GREEN}Touch ID for sudo is currently enabled.${NO_COLOR}"
else
    # Set message for currently disabled Touch ID
    CURRENT_STATE="${RED}Touch ID for sudo is currently disabled.${NO_COLOR}"
fi

# Print current state
printf "$CURRENT_STATE\n"

# Ask the user for confirmation to toggle Touch ID for sudo
printf "Do you want to toggle Touch ID for sudo? [Y/n] "
# Read user input
read -r REPLY
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    TOGGLE_MESSAGE=""

    # If Touch ID is configured, remove the line
    if grep -qxF "auth       sufficient     pam_tid.so" /etc/pam.d/sudo; then
        sudo sed -i "" "/auth       sufficient     pam_tid.so/d" /etc/pam.d/sudo
        TOGGLE_MESSAGE="${RED}Touch ID for sudo has been disabled.${NO_COLOR}"
    else
        # If Touch ID is not configured, add the line
        sudo sed -i "" "/auth       include        sudo_local/a\\
auth       sufficient     pam_tid.so
" /etc/pam.d/sudo
        TOGGLE_MESSAGE="${GREEN}Touch ID for sudo has been enabled.${NO_COLOR}"
    fi

    # Invalidate cached sudo credentials
    sudo -k

    # Print toggle message and verification command
    printf "\n$TOGGLE_MESSAGE\n\nRun this to verify:\n"
    printf "${LIGHT_BLUE}sudo -k; sudo echo \"OK\"${NO_COLOR}\n"
else
    # Print cancellation message
    printf "${RED}Operation canceled by the user.${NO_COLOR}\n"
fi

