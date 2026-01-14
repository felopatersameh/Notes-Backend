FROM dart:stable

WORKDIR /app

# نسخ dependencies
COPY pubspec.* ./
RUN dart pub get

# نسخ كل الملفات
COPY . .

# تثبيت dart_frog CLI
RUN dart pub global activate dart_frog_cli

# بناء المشروع
RUN dart pub global run dart_frog_cli:dart_frog build

# الانتقال لمجلد البناء
WORKDIR /app/build

# Railway environment
ENV PORT=8080

EXPOSE 8080

# تشغيل السيرفر
CMD ["dart", "run", "bin/server.dart"]