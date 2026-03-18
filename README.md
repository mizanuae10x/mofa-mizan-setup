# ⚖️ MOFA OpenClaw Setup

**التمكن والريادة لخدمات الذكاء الاصطناعي**
نشر OpenClaw على Mac Mini لوزارة الخارجية

---

## التثبيت — أمر واحد

```bash
curl -fsSL https://raw.githubusercontent.com/mizanuae10x/mofa-openclaw-setup/main/setup.sh | bash
```

## أو تحميل يدوي

```bash
git clone https://github.com/mizanuae10x/mofa-openclaw-setup
cd mofa-openclaw-setup
bash setup.sh
```

---

## بعد التثبيت — 3 خطوات فقط

### الخطوة 1: إضافة API Keys
```bash
openclaw setup
```
> إذا ظهر "command not found" → شغّل: `source ~/.zprofile`

### الخطوة 2: تشغيل البوابة
```bash
openclaw gateway start
```

### الخطوة 3: ربط Telegram
```bash
openclaw channels login --channel telegram
```

---

## ما يتضمنه الإعداد

| الخطوة | ما يتم |
|--------|--------|
| ✅ Homebrew | مدير الحزم لـ macOS |
| ✅ Node.js 22 | بيئة التشغيل |
| ✅ OpenClaw | المنصة الرئيسية |
| ✅ git, jq, python3, ffmpeg | أدوات مساعدة |
| ✅ SOUL.md | هوية MOFA |
| ✅ openclaw.json | إعدادات الوكلاء |

---

## المتطلبات

- Mac Mini M2/M4 (16GB+ RAM مُوصى)
- macOS Sonoma 14+
- اتصال إنترنت أثناء الإعداد

## API Keys المطلوبة

| المفتاح | الرابط |
|---------|--------|
| Anthropic | https://console.anthropic.com/settings/keys |
| Telegram Bot | https://t.me/BotFather |

---

## حل المشاكل الشائعة

### ❌ `openclaw: command not found`
```bash
source ~/.zprofile
# أو
export PATH="/opt/homebrew/opt/node@22/bin:$(npm config get prefix)/bin:$PATH"
```

### ❌ `permission denied`
```bash
chmod +x setup.sh
bash setup.sh
```

### ❌ Homebrew timeout
```bash
# شغّل مرة أخرى — يكمل من حيث توقف
bash setup.sh
```

---

## الدعم
mizan@tamkeenai.ae | www.tamkeenai.ae
