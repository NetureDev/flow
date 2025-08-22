# bash -c "$(curl -fsSL https://raw.githubusercontent.com/NetureDev/flow/refs/heads/main/fun/1.0/install.sh)"

#!/bin/bash

read -p "Start Matrix rain? (y/n): " confirm
clear

if [[ $confirm == "y" || $confirm == "Y" ]]; then
    echo -e "\033[32mInitializing...\033[0m"
    sleep 1
else
    echo -e "\033[31mAborted.\033[0m"
    exit 0
fi

GREEN='\033[32m'
BRIGHT_GREEN='\033[1;32m'
DIM_GREEN='\033[2;32m'
RESET='\033[0m'

CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|\\:;\"'<>,.?/~\`"

COLS=$(tput cols)
ROWS=$(tput lines)

declare -a drops
declare -a speeds
declare -a trail_lengths

for ((i=0; i<COLS; i++)); do
    drops[i]=$((RANDOM % ROWS))
    speeds[i]=$((RANDOM % 4 + 1))
    trail_lengths[i]=$((RANDOM % 15 + 8))
done

tput civis
clear

cleanup() {
    tput cnorm
    clear
    exit 0
}
trap cleanup SIGINT SIGTERM

echo -e "${GREEN}Matrix activated...${RESET}"
sleep 1
clear

while true; do
    for ((col=0; col<COLS; col++)); do
        if (( RANDOM % speeds[col] == 0 )); then
            current_row=${drops[col]}
            
            for ((i=0; i<trail_lengths[col]; i++)); do
                trail_row=$((current_row - i))
                
                if [[ $trail_row -ge 0 && $trail_row -lt $ROWS ]]; then
                    tput cup $trail_row $col
                    
                    if [[ $i -eq 0 ]]; then
                        echo -ne "${BRIGHT_GREEN}$(echo -n "${CHARS}" | cut -c$((RANDOM % ${#CHARS} + 1)))${RESET}"
                    elif [[ $i -lt 3 ]]; then
                        echo -ne "${GREEN}$(echo -n "${CHARS}" | cut -c$((RANDOM % ${#CHARS} + 1)))${RESET}"
                    elif [[ $i -lt 8 ]]; then
                        echo -ne "${GREEN}$(echo -n "${CHARS}" | cut -c$((RANDOM % ${#CHARS} + 1)))${RESET}"
                    else
                        echo -ne "${DIM_GREEN}$(echo -n "${CHARS}" | cut -c$((RANDOM % ${#CHARS} + 1)))${RESET}"
                    fi
                fi
            done
            
            clear_row=$((current_row - trail_lengths[col]))
            if [[ $clear_row -ge 0 && $clear_row -lt $ROWS ]]; then
                tput cup $clear_row $col
                echo -n " "
            fi
            
            drops[col]=$((current_row + 1))
            
            if [[ ${drops[col]} -gt $((ROWS + trail_lengths[col])) ]]; then
                drops[col]=$((-(RANDOM % 20)))
                speeds[col]=$((RANDOM % 4 + 1))
                trail_lengths[col]=$((RANDOM % 15 + 8))
            fi
        fi
    done
    
    sleep 0.05
done
