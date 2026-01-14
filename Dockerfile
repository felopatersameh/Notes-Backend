FROM dart:stable

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

# تثبيت dart_frog CLI
RUN dart pub global activate dart_frog_cli

# بناء المشروع
RUN dart pub global run dart_frog_cli:dart_frog build

WORKDIR /app/build

# Railway بيدي PORT
ENV PORT=8080
EXPOSE 8080

CMD ["dart", "run", "bin/server.dart"]