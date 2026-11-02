# CITESched

CITESched is an academic scheduling and faculty loading system. It consists of a Flutter web app, a Serverpod backend, and a PostgreSQL database.

## Run locally after cloning

These steps are for Windows PowerShell. You will need:

- Git
- Flutter 3.32 or newer (includes Dart 3.8 or newer)
- Docker Desktop, running
- Google Chrome

Check that the tools are installed:

```powershell
git --version
flutter --version
dart --version
docker --version
```

### 1. Clone the repository

Open PowerShell and run:

```powershell
git clone https://github.com/Ashhh02/citesched_project.git
cd citesched_project
```

### 2. Start the local PostgreSQL database

In the same PowerShell window:

```powershell
cd citesched_server
docker compose up -d postgres
```

This starts the PostgreSQL container on port `15432`, as configured in `citesched_server/config/development.yaml`. The local development configuration has Redis disabled, so you do not need to start it.

### 3. Configure the backend

Create your local passwords file from the provided example:

```powershell
Copy-Item config\passwords.yaml.example config\passwords.yaml
```

Open `config\passwords.yaml` in an editor. Under `development`, set `database` to the same value as `POSTGRES_PASSWORD` in `docker-compose.yaml`. Replace the `generate-a-long-random-string` placeholders with your own random values. SMTP, Google Sign-In, and Gemini credentials are optional for basic local startup; configure them only if you want to use those integrations.

`config\passwords.yaml` is ignored by Git. Keep your real credentials in that file and never commit it.

### 4. Start the backend

From the `citesched_server` directory, install dependencies and start Serverpod:

```powershell
dart pub get
dart run bin/main.dart --apply-migrations
```

Leave this window open. The local API listens on `http://localhost:8083/`; the first startup applies the database migrations.

### 5. Start the Flutter app

Open a second PowerShell window in the repository directory, then run:

```powershell
cd citesched_flutter
flutter pub get
flutter run -d chrome --dart-define=CITESCHED_SERVER_URL=http://localhost:8083/
```

Flutter will open the app in Chrome. Keep both the backend and Flutter terminal windows open while using it.

### 6. Stop the app

Stop Flutter and the backend with `Ctrl+C` in their respective terminal windows. Stop the database from the `citesched_server` directory:

```powershell
docker compose stop postgres
```

## Troubleshooting

- **Docker cannot connect:** Start Docker Desktop, wait until it is running, and repeat step 2.
- **Database authentication failed:** Check that `development.database` in `config\passwords.yaml` exactly matches `POSTGRES_PASSWORD` in `citesched_server\docker-compose.yaml`.
- **Port already in use:** Make sure ports `15432` (PostgreSQL) and `8083` (Serverpod API) are available.
- **Flutter cannot find Chrome:** Install Chrome, then run `flutter devices` to see the available targets.
- **App opens but has no schedules or accounts:** A fresh local database starts without your hosted data. You must add data to your local database; it is not copied from production.

## Repository structure

- `citesched_flutter/` - Flutter application
- `citesched_server/` - Serverpod backend, database configuration, and migrations
- `citesched_client/` - Shared/generated Serverpod client package
- `postman/` - Postman API collection
- `DEPLOYMENT.md` - Render deployment notes
