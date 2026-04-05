host=$(hostname)
header "$host" "NixOS" "$(uname -m)"

# --- CPU ---
section "CPU"
cpu_model=$(awk -F: '/model name/ { gsub(/^ +/,"",$2); print $2; exit }' /proc/cpuinfo)
cores=$(nproc)
load=$(awk '{ print $1, $2, $3 }' /proc/loadavg)
kv "Model" "$cpu_model"
kv "Cores" "$cores"
kv "Load" "$load"

if command -v sensors >/dev/null 2>&1; then
  cpu_temp=$(sensors 2>/dev/null \
    | awk '/Tctl|Tdie/ { gsub(/[^0-9.]/,"",$2); print $2"°C"; exit }') || true
  if [ -n "$cpu_temp" ]; then
    kv "Temp" "$cpu_temp"
  fi
fi

# --- Memory ---
section "Memory"
mem_line=$(free -b | awk '/Mem:/ { printf "%.1f / %.1f GiB  (%d%%)", $3/1073741824, $2/1073741824, $3*100/$2 }')
kv "Used" "$mem_line"

# --- GPU (nvidia) ---
if command -v nvidia-smi >/dev/null 2>&1; then
  section "GPU"
  gpu_csv=$(nvidia-smi --query-gpu=name,temperature.gpu,memory.used,memory.total,utilization.gpu --format=csv,noheader,nounits 2>/dev/null) || true
  if [ -n "$gpu_csv" ]; then
    gpu_name=$(echo "$gpu_csv" | awk -F', ' '{ print $1 }')
    gpu_temp=$(echo "$gpu_csv" | awk -F', ' '{ print $2 }')
    gpu_vram_used=$(echo "$gpu_csv" | awk -F', ' '{ print $3 }')
    gpu_vram_total=$(echo "$gpu_csv" | awk -F', ' '{ print $4 }')
    gpu_util=$(echo "$gpu_csv" | awk -F', ' '{ print $5 }')
    kv "Model" "$gpu_name"
    kv "Temp" "${gpu_temp}°C"
    kv "VRAM" "${gpu_vram_used} / ${gpu_vram_total} MiB"
    kv "Util" "${gpu_util}%"
  fi
fi

# --- Disks ---
section "Disks"
df -hT -x tmpfs -x devtmpfs -x efivarfs 2>/dev/null | tail -n +2 \
  | awk '{ printf "  %-18s %4s / %-6s (%s)  %s\n", $7, $4, $3, $6, $2 }'

# --- Network ---
section "Network"
ip -4 addr show 2>/dev/null | awk '
  /^[0-9]+:/ { iface=$2; gsub(/:$/,"",iface) }
  /inet / && iface != "lo" { split($2,a,"/"); printf "  %-12s %s\n", iface, a[1] }
'
