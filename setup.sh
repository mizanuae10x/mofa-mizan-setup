#!/bin/bash
# ================================================================
# ⚖️ MOFA OpenClaw Setup Script v2
# التمكن والريادة لخدمات الذكاء الاصطناعي
# وزارة الخارجية — نشر OpenClaw على Mac Mini
# ================================================================

set -e
GREEN='\033[0;32m'; GOLD='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${GOLD}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║   ⚖️  MOFA OpenClaw Setup v2 — TamkeenAI            ║"
echo "║   التمكن والريادة لخدمات الذكاء الاصطناعي          ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

WORKSPACE="$HOME/.openclaw/workspace"
TAMKEEN_REPO="https://github.com/mizanuae10x/mofa-diplomatic-council"

# ── 1. Homebrew ───────────────────────────────────────────────
echo -e "${GREEN}[1/8] تثبيت Homebrew...${NC}"
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add to PATH immediately for Apple Silicon and Intel
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    else
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    fi
else
    echo "  ✅ Homebrew موجود: $(brew --version | head -1)"
    # Ensure brew is in PATH
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# ── 2. Node.js ────────────────────────────────────────────────
echo -e "${GREEN}[2/8] تثبيت Node.js 22...${NC}"
if ! command -v node &>/dev/null || [[ $(node -v 2>/dev/null | cut -d. -f1 | tr -d 'v') -lt 22 ]]; then
    brew install node@22
    # Add node@22 to PATH immediately
    NODE_PATH="/opt/homebrew/opt/node@22/bin"
    [[ -d /usr/local/opt/node@22/bin ]] && NODE_PATH="/usr/local/opt/node@22/bin"
    export PATH="$NODE_PATH:$PATH"
    echo "export PATH=\"$NODE_PATH:\$PATH\"" >> ~/.zprofile
    echo "  ✅ Node.js $(node -v) مُثبَّت"
else
    echo "  ✅ Node.js $(node -v) موجود"
fi

# ── 3. OpenClaw ───────────────────────────────────────────────
echo -e "${GREEN}[3/8] تثبيت OpenClaw...${NC}"

NPM_BIN=$(npm config get prefix 2>/dev/null)/bin
export PATH="$NPM_BIN:$PATH"

if ! command -v openclaw &>/dev/null; then
    echo "  📦 تثبيت openclaw..."
    npm install -g openclaw
    # Reload PATH after npm global install
    export PATH="$(npm config get prefix)/bin:$PATH"
    hash -r 2>/dev/null || true
fi

# Verify openclaw is accessible
if command -v openclaw &>/dev/null; then
    echo "  ✅ OpenClaw $(openclaw --version 2>/dev/null | head -1)"
else
    echo -e "${RED}  ❌ openclaw لم يُثبَّت بشكل صحيح${NC}"
    echo "  📍 جرّب: source ~/.zprofile && openclaw --version"
    exit 1
fi

# ── 4. Dependencies ───────────────────────────────────────────
echo -e "${GREEN}[4/8] تثبيت الأدوات المساعدة...${NC}"
brew install git jq python3 ffmpeg 2>/dev/null || true
pip3 install arabic-reshaper python-bidi pillow 2>/dev/null || true
echo "  ✅ الأدوات جاهزة"

# ── 5. Workspace ──────────────────────────────────────────────
echo -e "${GREEN}[5/8] تجهيز مساحة العمل...${NC}"
mkdir -p "$WORKSPACE"

# ── 6. SOUL.md for MOFA ───────────────────────────────────────
echo -e "${GREEN}[6/8] ضبط هوية المنصة (MOFA)...${NC}"

cat > "$WORKSPACE/SOUL.md" << 'SOUL'
# SOUL.md — Mizan (MOFA Edition)

## Identity
Name: Mizan (ميزان)
Role: Executive Intelligence Copilot — Ministry of Foreign Affairs (MOFA UAE)
Operating Mode: Diplomatic intelligence, OSINT, crisis monitoring

## Mission
- Real-time crisis intelligence (war.tamkeenai.ae + mofa.tamkeenai.ae)
- Diplomat profiling and movement tracking
- Strategic briefings for decision makers
- Digital Diplomatic Council (port 3400)

## Tone
- Default: Arabic (فصحى)
- Formal, diplomatic, evidence-first
- OSINT only — cite all sources

## Organization
Ministry of Foreign Affairs — UAE

## Agents
1. ⚖️ Mizan (main) — Executive advisor
2. 🔮 Basira — Crisis intelligence
3. 🏗️ Moamar — Engineering
4. 🧭 Bousla (coming) — Diplomacy
5. 🌐 Raseef (coming) — International media
SOUL

echo "  ✅ SOUL.md جاهز"

# ── 7. openclaw.json ──────────────────────────────────────────
echo -e "${GREEN}[7/8] ضبط openclaw.json...${NC}"

mkdir -p "$HOME/.openclaw"
cat > "$HOME/.openclaw/openclaw.json" << CONFIG
{
  "ui": {
    "seamColor": "D4AF37",
    "assistant": {
      "name": "ميزان",
      "avatar": "⚖️"
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-sonnet-4-6",
        "fallbacks": ["openai/gpt-4.1"]
      },
      "workspace": "$WORKSPACE",
      "heartbeat": {
        "every": "30m",
        "activeHours": { "start": "07:00", "end": "23:00", "timezone": "Asia/Dubai" }
      }
    },
    "list": [
      { "id": "main", "model": "anthropic/claude-sonnet-4-6" }
    ]
  },
  "tools": {
    "exec": { "security": "full", "ask": "off" }
  }
}
CONFIG

echo "  ✅ openclaw.json جاهز"

# ── 8. Setup wizard ───────────────────────────────────────────
echo -e "${GREEN}[8/8] إعداد نهائي...${NC}"
echo ""
echo -e "${GOLD}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║   ✅ اكتمل الإعداد الأساسي!                         ║"
echo "║                                                      ║"
echo "║   الخطوات التالية (مرة واحدة فقط):                  ║"
echo "║                                                      ║"
echo "║   1) أضف API keys:                                   ║"
echo "║      openclaw setup                                  ║"
echo "║                                                      ║"
echo "║   2) شغّل البوابة:                                   ║"
echo "║      openclaw gateway start                          ║"
echo "║                                                      ║"
echo "║   3) ربط Telegram:                                   ║"
echo "║      openclaw channels login --channel telegram      ║"
echo "║                                                      ║"
echo "║   الدعم: mizan@tamkeenai.ae                          ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Reminder about PATH
echo -e "${GREEN}💡 تلميح: إذا لم يعمل 'openclaw' في terminal جديد:${NC}"
echo "   source ~/.zprofile"
echo ""
