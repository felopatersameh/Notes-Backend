FROM dart:stable

WORKDIR /app

# copy pubs pec
COPY pubspec.* ./
RUN dart pub get

# نسخ باقي المشروع
COPY . .

# Railway بيدي PORT
ENV PORT=8080

EXPOSE 8080

CMD ["dart", "run", "dart_frog", "dev", "--port", "8080"]
