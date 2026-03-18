# ⚖️ الأوامر الصحيحة — Mizan Framework

## بعد التثبيت — هذا الترتيب بالضبط:

```bash
# 1. إعداد أولي (مرة واحدة)
openclaw setup

# 2. تشغيل البوابة
openclaw gateway start

# 3. ربط Telegram (في terminal جديد)
openclaw channels login --channel telegram

# 4. التحقق من الحالة
openclaw status
```

## ❌ أخطاء شائعة

| الخطأ | السبب | الحل |
|-------|-------|------|
| `unknown command 'start'` | الأمر ناقص | استخدم `openclaw gateway start` |
| `command not found: openclaw` | PATH غير محدّث | `source ~/.zprofile` |
| `gateway already running` | يعمل مسبقاً | `openclaw gateway status` |
