# ⚖️ MOFA OpenClaw Setup

**التمكن والريادة لخدمات الذكاء الاصطناعي**
نشر OpenClaw على Mac Mini لوزارة الخارجية

## التثبيت بأمر واحد

```bash
curl -fsSL https://raw.githubusercontent.com/mizanuae10x/mofa-openclaw-setup/main/setup.sh | bash
```

## أو تحميل يدوي

```bash
git clone https://github.com/mizanuae10x/mofa-openclaw-setup
cd mofa-openclaw-setup
bash setup.sh
```

## بعد التثبيت

```bash
openclaw setup     # إضافة API keys
openclaw start     # تشغيل الـ gateway
```

## ما يتضمنه الإعداد

- ✅ Homebrew + Node.js 22
- ✅ OpenClaw (آخر إصدار)
- ✅ أدوات: git, jq, python3, ffmpeg
- ✅ SOUL.md مضبوط لـ MOFA
- ✅ وكلاء: ميزان + بصيرة + معمار
- ✅ LaunchAgent للتشغيل التلقائي

## المتطلبات

- Mac Mini M2/M4 (16GB+ RAM)
- macOS Sonoma 14+
- اتصال إنترنت أثناء الإعداد
- API Keys: Anthropic + Telegram

## الدعم

mizan@tamkeenai.ae | www.tamkeenai.ae
