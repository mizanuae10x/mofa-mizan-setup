#!/bin/bash
# ================================================================
# ⚖️ MOFA OpenClaw Setup Script
# التمكن والريادة لخدمات الذكاء الاصطناعي
# وزارة الخارجية — نشر OpenClaw على Mac Mini
# ================================================================

set -e
GREEN='\033[0;32m'; GOLD='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${GOLD}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║   ⚖️  MOFA OpenClaw Setup — TamkeenAI               ║"
echo "║   التمكن والريادة لخدمات الذكاء الاصطناعي          ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

WORKSPACE="$HOME/.openclaw/workspace"
TAMKEEN_REPO="https://github.com/mizanuae10x/mizan-framework"

# ── 1. Homebrew ───────────────────────────────────────────────
echo -e "${GREEN}[1/8] تثبيت Homebrew...${NC}"
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "  ✅ Homebrew موجود"
fi

# ── 2. Node.js ────────────────────────────────────────────────
echo -e "${GREEN}[2/8] تثبيت Node.js 22...${NC}"
if ! command -v node &>/dev/null || [[ $(node -v | cut -d. -f1 | tr -d 'v') -lt 22 ]]; then
    brew install node@22
    echo 'export PATH="/opt/homebrew/opt/node@22/bin:$PATH"' >> ~/.zprofile
    export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
else
    echo "  ✅ Node.js $(node -v) موجود"
fi

# ── 3. OpenClaw ───────────────────────────────────────────────
echo -e "${GREEN}[3/8] تثبيت OpenClaw...${NC}"
if ! command -v openclaw &>/dev/null; then
    npm install -g openclaw
else
    echo "  ✅ OpenClaw موجود: $(openclaw --version 2>/dev/null || echo 'installed')"
fi

# ── 4. Dependencies ───────────────────────────────────────────
echo -e "${GREEN}[4/8] تثبيت الأدوات المساعدة...${NC}"
brew install git jq python3 ffmpeg 2>/dev/null || true
pip3 install arabic-reshaper python-bidi pillow 2>/dev/null || true
echo "  ✅ الأدوات جاهزة"

# ── 5. Clone workspace ────────────────────────────────────────
echo -e "${GREEN}[5/8] تحميل مساحة عمل MOFA...${NC}"
mkdir -p "$HOME/.openclaw"
if [ -d "$WORKSPACE" ]; then
    echo "  ⚠️  Workspace موجود — نسخ احتياطي..."
    mv "$WORKSPACE" "${WORKSPACE}.backup.$(date +%Y%m%d)"
fi

git clone "$TAMKEEN_REPO" "$WORKSPACE" || {
    echo -e "${RED}  ❌ فشل clone — تأكد من صلاحية GitHub${NC}"
    mkdir -p "$WORKSPACE"
}

# ── 6. Configure for MOFA ─────────────────────────────────────
echo -e "${GREEN}[6/8] ضبط إعدادات MOFA...${NC}"

# Create MOFA-specific SOUL.md
cat > "$WORKSPACE/SOUL.md" << 'SOUL'
# SOUL.md — Mizan (MOFA Edition)

## Identity
Name: Mizan (ميزان)
Role: Executive Intelligence Copilot — Ministry of Foreign Affairs (MOFA UAE)
Operating Mode: Diplomatic intelligence, OSINT, crisis monitoring

## Mission
Support UAE MOFA operations with:
- Real-time crisis intelligence (war.tamkeenai.ae + mofa.tamkeenai.ae)
- Diplomat profiling and movement tracking
- Strategic briefings for decision makers
- HORMUZ research platform (RP-HORMUZ-2026-001)

## Tone & Language
- Default: Arabic (فصحى)
- Tone: Formal, diplomatic, evidence-first
- No jokes, no sarcasm

## Hard Rules
- No legal rulings
- Human approval required for external actions
- All content treated as confidential
- OSINT only — cite all sources

## Organization
Ministry of Foreign Affairs — UAE
SOUL
echo "  ✅ SOUL.md ضُبط لـ MOFA"

# Create openclaw.json skeleton
cat > "$HOME/.openclaw/openclaw.json" << 'CONFIG'
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
        "fallbacks": ["openai/gpt-4.1", "google/gemini-2.5-pro"]
      },
      "workspace": "WORKSPACE_PLACEHOLDER",
      "heartbeat": {
        "every": "30m",
        "activeHours": { "start": "07:00", "end": "23:00", "timezone": "Asia/Dubai" }
      }
    },
    "list": [
      { "id": "main", "model": "anthropic/claude-sonnet-4-6" },
      {
        "id": "basira",
        "name": "basira",
        "workspace": "WORKSPACE_PLACEHOLDER/tamkeenai",
        "model": "anthropic/claude-sonnet-4-6",
        "identity": { "name": "بصيرة", "emoji": "🔮" }
      },
      {
        "id": "coder",
        "name": "coder",
        "workspace": "WORKSPACE_PLACEHOLDER",
        "model": "openai/gpt-4.1",
        "identity": { "name": "معمار", "emoji": "🏗️" }
      }
    ]
  },
  "tools": {
    "exec": { "security": "full", "ask": "off" }
  }
}
CONFIG

# Replace placeholder with actual path
sed -i '' "s|WORKSPACE_PLACEHOLDER|$WORKSPACE|g" "$HOME/.openclaw/openclaw.json"
echo "  ✅ openclaw.json جاهز"

# ── 7. LaunchAgent ────────────────────────────────────────────
echo -e "${GREEN}[7/8] تسجيل LaunchAgent...${NC}"
openclaw gateway install 2>/dev/null || true
echo "  ✅ LaunchAgent مسجّل"

# ── 8. API Keys prompt ────────────────────────────────────────
echo -e "${GREEN}[8/8] إعداد API Keys...${NC}"
echo ""
echo -e "${GOLD}  المطلوب إضافة المفاتيح التالية:${NC}"
echo "  1. Anthropic API Key → openclaw setup"
echo "  2. Telegram Bot Token → openclaw setup"
echo ""
echo "  🔑 شغّل الآن: openclaw setup"
echo ""

echo -e "${GOLD}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║   ✅ اكتمل الإعداد الأساسي!                         ║"
echo "║                                                      ║"
echo "║   الخطوة التالية:                                    ║"
echo "║   $ openclaw setup                                   ║"
echo "║   ثم: $ openclaw start                               ║"
echo "║                                                      ║"
echo "║   الدعم: mizan@tamkeenai.ae                          ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"
