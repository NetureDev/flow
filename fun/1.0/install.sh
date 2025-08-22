# bash -c "$(curl -fsSL https://raw.githubusercontent.com/NetureDev/flow/refs/heads/main/fun/1.0/install.sh)"
#!/bin/bash
read -p "Start Matrix rain? (y/n): " confirm
clear
if [[ $confirm == "y" || $confirm == "Y" ]]; then
    echo -e "\033[32mInitializing...\033[0m"
    sleep 0.2
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
    drops[i]=$((RANDOM % ROWS))
done

tput civis
clear

cleanup() {
    tput cnorm
    clear
    exit 0
}
trap cleanup SIGINT SIGTERM

while true; do
    for ((col=0; col<COLS; col++)); do
        row=${drops[col]}
        tput cup $row $col
        echo -ne "${BRIGHT_GREEN}${CHARS:$((RANDOM % ${#CHARS})):1}${RESET}"

        if (( row > 0 )); then
            tput cup $((row - 1)) $col
            echo -ne "${GREEN}${CHARS:$((RANDOM % ${#CHARS})):1}${RESET}"
        fi

        if (( row > 1 )); then
            tput cup $((row - 2)) $col
            echo -ne "${DIM_GREEN}${CHARS:$((RANDOM % ${#CHARS})):1}${RESET}"
        fi

        drops[col]=$((row + 1))
        if (( drops[col] >= ROWS )); then
            drops[col]=0
        fi
    done
    sleep 0.05
done
