🌐 _Read this in: **English** | [Bahasa Indonesia](README.id.md)_

# Rust Axum Authentication Service

A backend REST API built with Rust + Axum using Clean Architecture. This service provides authentication and user management with JWT-based authentication and role-based access control (RBAC).

## 🚀 Features

- ✅ User Registration & Login
- ✅ **Login with GitHub (OAuth 2.0)**
- ✅ **Login with Google (OAuth 2.0)**
- ✅ JWT Access Token + Refresh Token
- ✅ Role-Based Access Control (RBAC)
- ✅ User Management (Create, Update, Delete, Suspend)
- ✅ Password Hashing (Argon2)
- ✅ Clean Architecture
- ✅ PostgreSQL Database
- ✅ Input Validation
- ✅ Centralized Error Handling
- ✅ Hot Reload Development

## 📋 Prerequisites

- **Rust** (latest stable) - [Install](https://rustup.rs/)
- **PostgreSQL** 12+
- **cargo-watch** (optional, for hot reload)
- **GitHub OAuth App** (optional, for Login with GitHub)
- **Google OAuth Client** (optional, for Login with Google)

## 🛠️ Setup Instructions

### Linux/MacOS

#### 1. Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

#### 2. Install PostgreSQL

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib

# MacOS (with Homebrew)
brew install postgresql@15
brew services start postgresql@15
```

#### 3. Clone & Setup Project

```bash
git clone https://github.com/daffahaidar/rust-axum-boiller.git
cd rust-axum-boiller

# Copy environment file
cp .env.example .env
```

#### 4. Setup Database

```bash
# Create database
createdb dimentorin

# Edit .env with your database credentials
nano .env  # or vim/code
```

#### 5. Install Dependencies (Optional)

```bash
# For hot reload development
cargo install cargo-watch
```

#### 6. Run Project

```bash
# Development with hot reload
make dev

# Or production
make start

# Or manually
cargo run --release
```

---

### Windows

#### 1. Install Rust

Download and install from [rustup.rs](https://rustup.rs/)

Or via PowerShell:

```powershell
# Run as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://win.rustup.rs'))
```

#### 2. Install PostgreSQL

Download from [postgresql.org](https://www.postgresql.org/download/windows/)

Or via Chocolatey:

```powershell
choco install postgresql
```

#### 3. Clone & Setup Project

```powershell
git clone https://github.com/daffahaidar/rust-axum-boiller.git
cd rust-axum-boiller

# Copy environment file
copy .env.example .env
```

#### 4. Setup Database

Open **pgAdmin** or **psql**:

```sql
CREATE DATABASE dimentorin;
```

Edit `.env` with a text editor (Notepad/VS Code):

```env
DATABASE_URL=postgres://postgres:password@localhost:5432/dimentorin
JWT_SECRET=supersecretkeyShouldChangeInProduction
RUST_LOG=debug
```

#### 5. Install Dependencies (Optional)

```powershell
cargo install cargo-watch
```

#### 6. Run Project

```powershell
# Development with hot reload
cargo watch -c -x run

# Production
cargo run --release
```

**Note for Windows:** `make` is not available by default. Use cargo commands directly or install [make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm)

---

### Setup OAuth Providers (Optional)

To enable **Login with GitHub** and/or **Login with Google**, follow the steps below:

#### 🐙 Setup GitHub OAuth

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Click **"New OAuth App"**
3. Fill in the form:

   | Field                      | Value                                               |
   | -------------------------- | --------------------------------------------------- |
   | Application name           | `Your App Name`                                     |
   | Homepage URL               | `http://localhost:8000`                             |
   | Authorization callback URL | `http://localhost:8000/api/v1/auth/github/callback` |

4. Click **"Register application"**
5. Copy the **Client ID** and generate a **Client Secret**
6. Add to your `.env` file:

   ```env
   GITHUB_CLIENT_ID=your_github_client_id
   GITHUB_CLIENT_SECRET=your_github_client_secret
   GITHUB_REDIRECT_URI=http://localhost:8000/api/v1/auth/github/callback
   ```

> **💡 Tip:** For production, replace all `localhost:8000` with your production domain.

#### 🔵 Setup Google OAuth

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Navigate to **APIs & Services → Credentials**
4. Click **"+ CREATE CREDENTIALS" → "OAuth client ID"**
5. If not yet configured, set up the **OAuth consent screen** first:
   - User Type: **External**
   - Fill in the app name, support email, and developer email
   - Add scopes: `email`, `profile`, `openid`
   - Add test users (your email) if the status is still **Testing**
6. Return to **Credentials** and create an OAuth client ID:

   | Field                         | Value                                               |
   | ----------------------------- | --------------------------------------------------- |
   | Application type              | **Web application**                                 |
   | Name                          | `Your App Name`                                     |
   | Authorized JavaScript origins | `http://localhost:8000`                             |
   | Authorized redirect URIs      | `http://localhost:8000/api/v1/auth/google/callback` |

7. Click **"Create"** and copy the **Client ID** and **Client Secret**
8. Add to your `.env` file:

   ```env
   GOOGLE_CLIENT_ID=your_google_client_id
   GOOGLE_CLIENT_SECRET=your_google_client_secret
   GOOGLE_REDIRECT_URI=http://localhost:8000/api/v1/auth/google/callback
   ```

> **⚠️ IMPORTANT:** If the OAuth consent screen is still in **Testing** mode, only emails registered as test users can log in. To allow all users, publish the app to **Production** in the consent screen settings.

#### 🔗 Using with a Frontend Framework (e.g. Next.js + better-auth)

If you are integrating this backend with a **frontend application** (e.g. Next.js with better-auth), the OAuth callback URL must point to **your frontend**, not the Rust backend. The frontend will receive the authorization code, forward it to the Rust backend, set JWT cookies, and redirect the user.

**Update the callback URLs as follows:**

| Provider | Callback URL                                                    |
| -------- | --------------------------------------------------------------- |
| GitHub   | `http://localhost:3000/api/auth/oauth-callback?provider=github` |
| Google   | `http://localhost:3000/api/auth/oauth-callback?provider=google` |

Update your `.env`:

```diff
- GITHUB_REDIRECT_URI=http://localhost:8000/api/v1/auth/github/callback
+ GITHUB_REDIRECT_URI=http://localhost:3000/api/auth/oauth-callback?provider=github
- GOOGLE_REDIRECT_URI=http://localhost:8000/api/v1/auth/google/callback
+ GOOGLE_REDIRECT_URI=http://localhost:3000/api/auth/oauth-callback?provider=google
```

> **📝 Note:** Make sure to also update the callback URLs in the GitHub Developer Settings and Google Cloud Console to match.

---

## 🔧 Development Commands

### Using Make (Linux/MacOS)

```bash
make dev           # Development with hot reload
make start         # Production server
make build         # Build production binary
make test          # Run tests
make fmt           # Format code
make check         # Check code
make clean         # Clean build artifacts
make help          # Show all commands
```

### Without Make (All Platforms)

```bash
# Development with hot reload
cargo watch -c -x run

# Production
cargo run --release

# Build
cargo build --release

# Test
cargo test

# Format
cargo fmt

# Check
cargo check
```

## 🌐 Environment Variables

Edit the `.env` file:

```env
# Database
DATABASE_URL=postgres://username:password@localhost:5432/dimentorin

# JWT Secret (IMPORTANT: Change in production!)
JWT_SECRET=supersecretkeyShouldChangeInProduction

# Logging Level
RUST_LOG=debug

# GitHub OAuth (for Login with GitHub)
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
GITHUB_REDIRECT_URI=http://localhost:8000/api/v1/auth/github/callback

# Google OAuth (for Login with Google)
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
GOOGLE_REDIRECT_URI=http://localhost:8000/api/v1/auth/google/callback
```

**⚠️ SECURITY:** Do not commit the `.env` file to Git!

## 🔐 User Roles

| Role           | Description                                      |
| -------------- | ------------------------------------------------ |
| **User**       | Default role for new users                       |
| **Mentor**     | Mentor role                                      |
| **Admin**      | Can create users and suspend users               |
| **SuperAdmin** | Full access - can edit, delete, and manage users |

## 📡 API Documentation

Base URL: `http://localhost:8000/api/v1`

### Authentication Endpoints

#### 1. Register User

```bash
POST /auth/sign-up
Content-Type: application/json

{
  "name": "Daffa",
  "phone": "08123456789",
  "email": "daffa@email.com",
  "password": "password123"
}
```

#### 2. Login

```bash
POST /auth/sign-in
Content-Type: application/json

{
  "email": "daffa@email.com",
  "password": "password123"
}
```

#### 3. Refresh Token

```bash
POST /auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### GitHub OAuth Endpoints

#### 4. Login with GitHub

```bash
GET /auth/github
```

Redirect the user to this endpoint. The backend will redirect to GitHub's authorization page.

#### 5. GitHub Callback

```bash
GET /auth/github/callback?code={authorization_code}
```

Called automatically by GitHub after the user authorizes. Returns JWT tokens.

**Response:**

```json
{
  "meta": {
    "status": "success",
    "message": "GitHub login successful"
  },
  "results": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 900
  }
}
```

**OAuth Flow:**

```
User → GET /auth/github → Redirect to GitHub → User authorizes
→ GitHub redirects to /auth/github/callback?code=xxx
→ Backend exchanges code → Fetches user info → Creates/links user → Returns JWT
```

> **📝 Note:** If the GitHub email is already registered, the account will be automatically linked. OAuth users cannot log in via email/password.

### Google OAuth Endpoints

#### 6. Login with Google

```bash
GET /auth/google
```

Redirect the user to this endpoint. The backend will redirect to Google's login page.

#### 7. Google Callback

```bash
GET /auth/google/callback?code={authorization_code}
```

Called automatically by Google after the user authorizes. Returns JWT tokens.

**Response:**

```json
{
  "meta": {
    "status": "success",
    "message": "Google login successful"
  },
  "results": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 900
  }
}
```

**OAuth Flow:**

```
User → GET /auth/google → Redirect to Google → User logs in & authorizes
→ Google redirects to /auth/google/callback?code=xxx
→ Backend exchanges code → Fetches user info → Creates/links user → Returns JWT
```

> **📝 Note:** Same as GitHub, if the Google email is already registered, the account will be automatically linked.

### User Management Endpoints

> **⚠️ All endpoints below require an Authorization header**

#### 8. Get All Users (Admin, SuperAdmin)

```bash
GET /users
Authorization: Bearer {access_token}
```

#### 9. Create User (Admin, SuperAdmin)

```bash
POST /users
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "name": "John Doe",
  "phone": "08123456789",
  "email": "john@email.com",
  "password": "password123",
  "role": "User"
}
```

#### 10. Update User (SuperAdmin only)

```bash
PUT /users/{id}
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "name": "Jane Doe",
  "email": "jane@email.com",
  "role": "Admin"
}
```

#### 11. Delete User (SuperAdmin only)

```bash
DELETE /users/{id}
Authorization: Bearer {access_token}
```

**Note:** SuperAdmin cannot delete their own account.

#### 12. Suspend/Activate User (Admin, SuperAdmin)

```bash
PATCH /users/{id}/status
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "status": "Suspended"
}
```

Valid status: `Active`, `Suspended`

## 🧪 Testing Examples

### Register

```bash
curl -X POST http://localhost:8000/api/v1/auth/sign-up \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "phone": "08123456789",
    "email": "test@email.com",
    "password": "password123"
  }'
```

### Login

```bash
curl -X POST http://localhost:8000/api/v1/auth/sign-in \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@email.com",
    "password": "password123"
  }'
```

### Login with GitHub

```bash
# Open this URL in a browser (will redirect to GitHub)
curl -v http://localhost:8000/api/v1/auth/github

# Or open directly in a browser:
# http://localhost:8000/api/v1/auth/github
```

### Login with Google

```bash
# Open this URL in a browser (will redirect to Google)
curl -v http://localhost:8000/api/v1/auth/google

# Or open directly in a browser:
# http://localhost:8000/api/v1/auth/google
```

### Get All Users

```bash
curl -X GET http://localhost:8000/api/v1/users \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## 📊 Access Control Matrix

| Action          | User | Mentor | Admin | SuperAdmin |
| --------------- | ---- | ------ | ----- | ---------- |
| Register        | ✅   | ✅     | ✅    | ✅         |
| Login           | ✅   | ✅     | ✅    | ✅         |
| Login w/ GitHub | ✅   | ✅     | ✅    | ✅         |
| Login w/ Google | ✅   | ✅     | ✅    | ✅         |
| View All Users  | ❌   | ❌     | ✅    | ✅         |
| Create User     | ❌   | ❌     | ✅    | ✅         |
| Edit User       | ❌   | ❌     | ❌    | ✅         |
| Delete User     | ❌   | ❌     | ❌    | ✅\*       |
| Suspend User    | ❌   | ❌     | ✅    | ✅         |

\*SuperAdmin cannot delete their own account

## 🏗️ Project Structure

```
rust-axum/
├── src/
│   ├── domain/           # Business logic & entities
│   │   ├── entities/     # User, Role, UserStatus
│   │   ├── repositories/ # Repository traits
│   │   └── dtos/         # Data Transfer Objects
│   ├── usecases/         # Application logic
│   ├── handlers/         # HTTP handlers
│   ├── infrastructure/   # External dependencies
│   │   ├── database/
│   │   ├── repositories/
│   │   ├── auth/         # JWT, Password, GitHub & Google OAuth
│   │   └── errors/
│   ├── routes/           # Route configuration
│   ├── utils/            # Helpers
│   └── main.rs
├── migrations/           # Database migrations
├── Cargo.toml           # Dependencies
├── Makefile             # Development scripts
└── .env.example         # Environment template
```

## 🚨 Troubleshooting

### Port Already in Use

```bash
# Find process using port 8000
lsof -i :8000

# Kill process
pkill -f rust-axum
```

### Database Connection Error

```bash
# Make sure PostgreSQL is running
# MacOS
brew services list

# Linux
sudo systemctl status postgresql

# Windows
# Check in Services or pgAdmin
```

### cargo-watch Not Found

```bash
cargo install cargo-watch
```

## 🔒 Security Features

1. ✅ Password Hashing - Argon2
2. ✅ JWT Authentication - HS256
3. ✅ GitHub OAuth 2.0 - Secure third-party login
4. ✅ Google OAuth 2.0 - Secure third-party login
5. ✅ Email Uniqueness - Database constraint
6. ✅ RBAC - Endpoint-level authorization
7. ✅ Input Validation - Request validation
8. ✅ Self-Deletion Prevention
9. ✅ Centralized Error Handling
10. ✅ Account Linking - OAuth ↔ Email

## 📝 License

MIT License

---

**Made with ❤️ using Rust + Axum**
