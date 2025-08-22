# bash -c "$(curl -fsSL https://raw.githubusercontent.com/NetureDev/flow/refs/heads/main/fun/1.0/install.sh)"
#!/bin/bash
read -p "Start Matrix rain? (y/n): " confirm
clear
if [[ $confirm == "y" || $confirm == "Y" ]]; then
    echo -e "\033[32mInitializing...\033[0m"
    sleep 0.1
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
for ((i=0; i<COLS; i++)); do
    drops[i]=$((RANDOM % ROWS - 20))
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
sleep 0.1
clear
while true; do
    for ((rep=0; rep<10; rep++)); do
        for ((col=0; col<COLS; col++)); do
            current_row=${drops[col]}
            
            if [[ $current_row -ge 0 && $current_row -lt $ROWS ]]; then
                tput cup $current_row $col
                echo -ne "${BRIGHT_GREEN}${CHARS:$((RANDOM % ${#CHARS})):1}${RESET}"
            fi
            
            next_row=$((current_row + 1))
            if [[ $next_row -ge 0 && $next_row -lt $ROWS ]]; then
                tput cup $next_row $col
                echo -ne "${GREEN}${CHARS:$((RANDOM % ${#CHARS})):1}${RESET}"
            fi
            
            next_row2=$((current_row + 2))
            if [[ $next_row2 -ge 0 && $next_row2 -lt $ROWS ]]; then
                tput cup $next_row2 $col
                echo -ne "${DIM_GREEN}${CHARS:$((RANDOM % ${#CHARS})):1}${RESET}"
            fi
            
            drops[col]=$((current_row + 10))
            
            if [[ ${drops[col]} -gt $((ROWS + 3)) ]]; then
                drops[col]=$((RANDOM % 30 - 30))
            fi
        done
    done
done
