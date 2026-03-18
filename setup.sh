#!/bin/bash
# ================================================================
# ⚖️ MOFA Mizan Framework Setup Script v3
# التمكن والريادة لخدمات الذكاء الاصطناعي
# نشر إطار عمل ميزان على Mac Mini
# ================================================================

set -e
GREEN='\033[0;32m'; GOLD='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${GOLD}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║   ⚖️  Mizan Framework Setup v3 — TamkeenAI          ║"
echo "║   التمكن والريادة لخدمات الذكاء الاصطناعي          ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

WORKSPACE="$HOME/.openclaw/workspace"
FRAMEWORK_REPO="https://github.com/mizanuae10x/mizan-framework"

# ── 1. Homebrew ───────────────────────────────────────────────
echo -e "${GREEN}[1/8] تثبيت Homebrew...${NC}"
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    else
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    fi
else
    echo "  ✅ Homebrew موجود: $(brew --version | head -1)"
    if [[ -f /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
fi

# ── 2. Node.js ────────────────────────────────────────────────
echo -e "${GREEN}[2/8] تثبيت Node.js 22...${NC}"
if ! command -v node &>/dev/null || [[ $(node -v 2>/dev/null | cut -d. -f1 | tr -d 'v') -lt 22 ]]; then
    brew install node@22
    NODE_PATH="/opt/homebrew/opt/node@22/bin"
    [[ -d /usr/local/opt/node@22/bin ]] && NODE_PATH="/usr/local/opt/node@22/bin"
    export PATH="$NODE_PATH:$PATH"
    echo "export PATH=\"$NODE_PATH:\$PATH\"" >> ~/.zprofile
    echo "  ✅ Node.js $(node -v) مُثبَّت"
else
    echo "  ✅ Node.js $(node -v) موجود"
fi

# ── 3. OpenClaw ───────────────────────────────────────────────
echo -e "${GREEN}[3/8] تثبيت Mizan Framework (OpenClaw)...${NC}"

NPM_BIN=$(npm config get prefix 2>/dev/null)/bin
export PATH="$NPM_BIN:$PATH"

if ! command -v openclaw &>/dev/null; then
    echo "  📦 تثبيت openclaw..."
    npm install -g openclaw
    export PATH="$(npm config get prefix)/bin:$PATH"
    hash -r 2>/dev/null || true
fi

if command -v openclaw &>/dev/null; then
    echo "  ✅ Mizan Framework: $(openclaw --version 2>/dev/null | head -1)"
else
    echo -e "${RED}  ❌ فشل التثبيت — جرّب: source ~/.zprofile${NC}"
    exit 1
fi

# ── 4. Dependencies ───────────────────────────────────────────
echo -e "${GREEN}[4/8] تثبيت الأدوات المساعدة...${NC}"
brew install git jq python3 ffmpeg 2>/dev/null || true
pip3 install arabic-reshaper python-bidi pillow 2>/dev/null || true
echo "  ✅ الأدوات جاهزة"

# ── 5. Clone Mizan Framework ─────────────────────────────────
echo -e "${GREEN}[5/8] تحميل Mizan Framework من GitHub...${NC}"

if [ -d "$WORKSPACE" ]; then
    echo "  ⚠️  Workspace موجود — نسخ احتياطي..."
    mv "$WORKSPACE" "${WORKSPACE}.backup.$(date +%Y%m%d-%H%M%S)"
fi

git clone "$FRAMEWORK_REPO" "$WORKSPACE" && \
    echo "  ✅ Framework محمّل بنجاح" || {
    echo -e "${RED}  ❌ فشل clone${NC}"
    mkdir -p "$WORKSPACE"
    exit 1
}

# ── 6. Customize identity ─────────────────────────────────────
echo -e "${GREEN}[6/8] تخصيص الهوية...${NC}"
echo ""
echo -e "${GOLD}  ما هي الجهة؟ (مثال: MOFA، MOJ، MBZUAI — أو اضغط Enter للتخطّي)${NC}"
read -r ORG_NAME

if [ -n "$ORG_NAME" ]; then
    # Update SOUL.md with org name
    sed -i.bak "s/\[الجهة — مثال: وزارة الخارجية، وزارة العدل\.\.\.\]/$ORG_NAME/g" "$WORKSPACE/SOUL.md" 2>/dev/null || true
    sed -i.bak "s/\[اسم الجهة\]/$ORG_NAME/g" "$WORKSPACE/IDENTITY.md" 2>/dev/null || true
    rm -f "$WORKSPACE/SOUL.md.bak" "$WORKSPACE/IDENTITY.md.bak" 2>/dev/null
    echo "  ✅ الهوية: $ORG_NAME"
else
    echo "  ⚠️  تخطّي — عدّل ~/.openclaw/workspace/SOUL.md لاحقاً"
fi

# Install Mission Control dependencies
if [ -f "$WORKSPACE/tools/basira-mission-control/package.json" ]; then
    echo "  📦 تثبيت مكتبات بصيرة..."
    cd "$WORKSPACE/tools/basira-mission-control"
    npm install --silent 2>/dev/null || true
    cp .env.example .env 2>/dev/null || true
    cd - > /dev/null
fi

# ── 7. openclaw.json ──────────────────────────────────────────
echo -e "${GREEN}[7/8] ضبط openclaw.json...${NC}"
mkdir -p "$HOME/.openclaw"
cat > "$HOME/.openclaw/openclaw.json" << CONFIG
{
  "ui": {
    "seamColor": "D4AF37",
    "assistant": { "name": "ميزان", "avatar": "⚖️" }
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
  "tools": { "exec": { "security": "full", "ask": "off" } }
}
CONFIG
echo "  ✅ openclaw.json جاهز"

# ── 8. Final instructions ─────────────────────────────────────
echo -e "${GREEN}[8/8] اكتمل الإعداد!${NC}"
echo ""
echo -e "${GOLD}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║   ✅ Mizan Framework جاهز!                           ║"
echo "║                                                      ║"
echo "║   الخطوات التالية:                                   ║"
echo "║                                                      ║"
echo "║   1) إعداد API keys:                                 ║"
echo "║      openclaw setup                                  ║"
echo "║                                                      ║"
echo "║   2) تثبيت + تشغيل البوابة:                         ║"
echo "║      openclaw gateway install                        ║"
echo "║      openclaw gateway start                          ║"
echo "║                                                      ║"
echo "║   3) ربط Telegram:                                   ║"
echo "║      openclaw channels login --channel telegram      ║"
echo "║                                                      ║"
echo "║   4) Mission Control Dashboard:                      ║"
echo "║      cd ~/.openclaw/workspace/tools/mission-control  ║"
echo "║      node server.js → http://localhost:3457          ║"
echo "║                                                      ║"
echo "║   5) بصيرة Chat (AI):                               ║"
echo "║      cd ~/.openclaw/workspace/tools/basira-mission-control ║"
echo "║      nano .env  (أضف API key)                        ║"
echo "║      node server.js → http://localhost:8521          ║"
echo "║                                                      ║"
echo "║   الدعم: mizan@tamkeenai.ae | tamkeenai.ae           ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${GREEN}💡 إذا لم يعمل 'openclaw' في terminal جديد:${NC}"
echo "   source ~/.zprofile"
echo ""
