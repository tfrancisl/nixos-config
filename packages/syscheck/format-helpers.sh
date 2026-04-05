BOLD='\033[1m'
CYAN='\033[36m'
GREEN='\033[32m'
RESET='\033[0m'

header() {
  printf " %b%bSYSCHECK%b  %s  %s  %s\n" "$BOLD" "$CYAN" "$RESET" "$1" "$2" "$3"
  printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
}

section() { printf "\n %b%b%s%b\n" "$BOLD" "$CYAN" "$1" "$RESET"; }
kv()      { printf "  %b%-12s%b %s\n" "$GREEN" "$1" "$RESET" "$2"; }

to_gib() { awk "BEGIN { printf \"%.1f\", $1 / 1073741824 }"; }
