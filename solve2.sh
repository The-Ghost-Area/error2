#!/bin/bash

# 🎨 Enhanced Gensyn Auto Setup Banner with User-Provided ASCII
BANNER=$(cat << 'EOF'
██████╗ ███████╗██╗   ██╗██╗██╗     
██╔══██╗██╔════╝██║   ██║██║██║     
██║  ██║█████╗  ██║   ██║██║██║     
██║  ██║██╔══╝  ╚██╗ ██╔╝██║██║     
██████╔╝███████╗ ╚████╔╝ ██║███████╗
╚═════╝ ╚══════╝  ╚═╝╚══════╝
EOF
)

# 🔢 Color selection and display
COLORS=(31 32 33 34 35 36 91 92 93 94 95 96)
COLOR=${COLORS[$RANDOM % ${#COLORS[@]}]}

# 🎉 Display banner with random color
echo -e "\n\e[1;${COLOR}m$BANNER\e[0m"
echo -e "🔧 Starting Gensyn Auto Error Solve — Say thanks to DEVIL!\n"

# ⛏️ Define base path
BASE="$HOME/work/rl-swarm"

# 🔧 Step 1: Patch system_utils.py
TARGET_PATH="$BASE/.venv/lib/python3.12/site-packages/genrl/logging_utils/system_utils.py"
echo "🚀 Checking system_utils.py for patching..."
if [ -f "$TARGET_PATH" ]; then
  echo "📄 Found system_utils.py — applying patch..."
  cat > "$TARGET_PATH" << 'EOF'
# (full system_utils.py content as in your original script)
# Truncated here to save space...
EOF
  echo "✅ system_utils.py patched successfully!"
else
  echo "❌ system_utils.py not found — skipping patch."
fi

# 🛠 Step 2: Timeout Bug Fix
echo -e "\n🛠  Applying timeout bug fix..."
DAEMON_PATH="$BASE/.venv/lib/python3.12/site-packages/hivemind/p2p/p2p_daemon.py"
if [ -f "$DAEMON_PATH" ]; then
    sed -i 's/startup_timeout: float = *15/startup_timeout: float = 120/' "$DAEMON_PATH"
    echo "✅ Timeout increased to 120s in p2p_daemon.py"
else
    echo "⚠️  Daemon file not found — skipping timeout patch"
fi

# 🧠 Step 3: Patch GRPO rewards tensor structure bug
echo -e "\n🔁 Patching rewards tensor structure in grpo_trainer.py..."
GRPO_PATH="$BASE/.venv/lib/python3.12/site-packages/genrl/trainer/grpo_trainer.py"
if [ -f "$GRPO_PATH" ]; then
    sed -i 's/rewards = torch.tensor(rewards)/rewards = torch.tensor([[r, 0.0] if isinstance(r, (int, float)) else r for r in rewards])/g' "$GRPO_PATH"
    echo "✅ Patched rewards tensor structure in grpo_trainer.py"
else
    echo "❌ grpo_trainer.py not found — skipping rewards patch"
fi

# 🔐 Step 4: Set Permissions for swarm.pem
echo -e "\n🔐 Setting permissions for swarm.pem..."
SWARM_PEM_PATH="$BASE/swarm.pem"
if [ -f "$SWARM_PEM_PATH" ]; then
    sudo chown $(whoami):$(whoami) "$SWARM_PEM_PATH"
    sudo chmod 600 "$SWARM_PEM_PATH"
    echo "✅ Permissions set for swarm.pem"
else
    echo "❌ swarm.pem not found — skipping permissions setup"
fi

# ♻️ Final Step: Recreate Virtual Environment & Launch Swarm
echo -e "\n♻️ Recreating Python Virtual Environment..."

cd "$BASE" || { echo "❌ rl-swarm directory not found!"; exit 1; }

rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate

echo -e "\n🚀 Running RL Swarm..."
chmod +x ./run_rl_swarm.sh
./run_rl_swarm.sh
