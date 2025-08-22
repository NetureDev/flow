# bash -c "$(curl -fsSL https://raw.githubusercontent.com/NetureDev/flow/refs/heads/main/fun/1.0/install.sh)"

#!/bin/bash
read -p "Start Matrix rain? (y/n): " confirm
clear
if [[ $confirm == "y" || $confirm == "Y" ]]; then
    echo -e "\033[32mInitializing...\033[0m"
    sleep 0.5
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
    speeds[i]=1
    trail_lengths[i]=$((RANDOM % 8 + 4))
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
sleep 0.3
clear
while true; do
    for ((col=0; col<COLS; col++)); do
        current_row=${drops[col]}
        
        for ((i=0; i<trail_lengths[col]; i++)); do
            trail_row=$((current_row - i))
            
            if [[ $trail_row -ge 0 && $trail_row -lt $ROWS ]]; then
                tput cup $trail_row $col
                
                if [[ $i -eq 0 ]]; then
                    echo -ne "${BRIGHT_GREEN}${CHARS:$((RANDOM % ${#CHARS})):1}${RESET}"
                elif [[ $i -lt 2 ]]; then
                    echo -ne "${GREEN}${CHARS:$((RANDOM % ${#CHARS})):1}${RESET}"
                else
                    echo -ne "${DIM_GREEN}${CHARS:$((RANDOM % ${#CHARS})):1}${RESET}"
                fi
            fi
        done
        
        clear_row=$((current_row - trail_lengths[col]))
        if [[ $clear_row -ge 0 && $clear_row -lt $ROWS ]]; then
            tput cup $clear_row $col
            echo -n " "
        fi
        
        drops[col]=$((current_row + 2))
        
        if [[ ${drops[col]} -gt $((ROWS + trail_lengths[col])) ]]; then
            drops[col]=$((-(RANDOM % 5)))
            trail_lengths[col]=$((RANDOM % 8 + 4))
        fi
    done
    
    sleep 0.01
done
