# Notes API (Dart Frog)

REST API for notes with JWT authentication and MongoDB.

## Architecture (Folders)

- `routes/` HTTP endpoints (Dart Frog file-based routing).
  - `auth/` register, login
  - `users/` current user profile
  - `notes/` current user notes
  - `dashboard/` admin-only user management
- `lib/Model/` request/response models
- `lib/repositories/` MongoDB data access
- `lib/utils/` helpers (tokens, responses, env, validation)
- `lib/Enum/` shared enums and keys
- `.dart_frog/` generated server code

## Auth and Roles

- Send `Authorization: Bearer <token>` for protected routes.
- User ID is read from the token for `/users` and `/notes`.
- Admin-only routes live under `/dashboard` and use `<id>` for target user.
- Token revocation is supported.

## Routes (Base URL: `https://notes-backend-production-4b33.up.railway.app`)

Auth

- `POST /auth/register` body: `{ "name": "", "email": "", "password": "" }`
- `POST /auth/login` body: `{ "email": "", "password": "" }`

Users (auth required)

- `GET /users`
- `PUT /users` body: `{ "name": "", "email": "" }`
- `PUT /users/changepassword` body: `{ "password": "", "newPassword": "" }`
- `POST /users/logout`
- `DELETE /users/remove`

Notes (auth required)

- `GET /notes`
- `POST /notes` body: `{ "subject": "", "body": "" }`
- `PUT /notes/id/<id>` body: `{ "subject": "", "body": "" }`
- `DELETE /notes/id/<id>`
- `DELETE /notes/removeAll`

Dashboard (admin only)

- `GET /dashboard/users`
- `GET /dashboard/users/<id>/hashpassword`
- `DELETE /dashboard/users/<id>/delete`
- `PUT /dashboard/users/<id>/updaterole` body: `{ "role": "admin|user" }`

Notes

- Replace `<id>` with a note id or user id, depending on the route.

## Environment

Create `.env`:

```env
MONGO_URI=mongodb://localhost:27017/notes
SECRET_KEY_Token=your-secret-jwt-key-here
```

## Run

```bash
dart pub get
dart_frog dev
```

## Production

```bash
dart_frog build
dart run build/bin/server.dart
```
