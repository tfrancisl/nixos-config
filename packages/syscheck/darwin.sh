host=$(hostname -s)
os_name=$(sw_vers --productName)
os_ver=$(sw_vers --productVersion)
header "$host" "$os_name $os_ver" "$(uname -m)"

# --- CPU ---
section "CPU"
cpu_model=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Apple Silicon")
cores=$(sysctl -n hw.ncpu)
load=$(sysctl -n vm.loadavg | tr -d '{}' | xargs)
kv "Model" "$cpu_model"
kv "Cores" "$cores"
kv "Load" "$load"

# --- Memory ---
section "Memory"
page_size=$(vm_stat | head -1 | awk '{ print $(NF-1) }')
mem_total=$(sysctl -n hw.memsize)
pages_active=$(vm_stat | awk '/Pages active/ { gsub(/\./,"",$NF); print $NF }')
pages_wired=$(vm_stat | awk '/Pages wired/ { gsub(/\./,"",$NF); print $NF }')
pages_compressed=$(vm_stat | awk '/occupied by compressor/ { gsub(/\./,"",$NF); print $NF }')
mem_used=$(( (pages_active + pages_wired + pages_compressed) * page_size ))
mem_pct=$(( mem_used * 100 / mem_total ))
mem_used_gib=$(echo "$mem_used" | to_gib)
mem_total_gib=$(echo "$mem_total" | to_gib)
kv "Used" "${mem_used_gib} / ${mem_total_gib} GiB  (${mem_pct}%)"

# --- GPU ---
section "GPU"
gpu_model=$(system_profiler SPDisplaysDataType 2>/dev/null \
  | awk -F: '/Chipset Model/ { gsub(/^ +/,"",$2); print $2; exit }') || true
kv "Model" "${gpu_model:-Integrated}"

# --- Disks ---
section "Disks"
df -h / /System/Volumes/Data 2>/dev/null | tail -n +2 | sort -u \
  | awk '{ printf "  %-18s %4s / %-6s (%s)\n", $NF, $4, $2, $5 }'

# --- Network ---
section "Network"
ifconfig 2>/dev/null | awk '
  /^[a-z]/ { iface=$1; gsub(/:$/,"",iface) }
  /inet / && iface != "lo0" { printf "  %-12s %s\n", iface, $2 }
'
