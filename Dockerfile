# مرحلة البناء
FROM dart:stable AS build

WORKDIR /app

# نسخ ملفات المشروع
COPY pubspec.* ./
RUN dart pub get

COPY . .

# بناء المشروع
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# مرحلة التشغيل
FROM dart:stable

WORKDIR /app

# نسخ الملفات المبنية
COPY --from=build /app/build /app

# Railway بيحدد PORT تلقائي
ENV PORT=8080
EXPOSE 8080

# تشغيل السيرفر المبني
CMD ["dart", "run", "bin/server.dart"]