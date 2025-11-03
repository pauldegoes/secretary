# Secretary

A dummy app for a live coding challenge.

## Coding challenge

If you're here, you're probably planning on interviewing. That's great.  Familiarize yourself with the repo and prepare to show what you know by tackling some of the bugs and/or features below.  Our objective is to get to know how you think and solve problems as you work through:

- Pulling down this repo
- Setting up this appand your environment 
- Analyzing and understanding the bugs and requested features
- Adapting this code base in an intelligent, performant way

## Bugs

- **Photo Upload**: Profile photo upload functionality is not working.  Resizing may not be taking place.
- **Login Audit**: Login history missing SSO provider information
- **Navigation UI**: Left sidebar expansion arrow is cut off
- **Project Navigation**: Left Sidebar doesn't show projects section outside dashboard view

### Planned Features

- **Project Comments**: Add commenting system to projects for team collaboration
- **Enhanced Navigation**: Fix sidebar issues and improve project navigation
- **Photo Upload**: Resolve profile photo upload functionality
- **Login Audit Enhancement**: Add SSO provider information to login history


## Prerequisites

- Ruby 3.4.7 (rbenv recommended)
- PostgreSQL 15
- Node.js and Yarn
- Git
- rbenv

## Quick Start

### 1. Clone and Install

```bash
git clone <repository-url>
cd secretary
bundle install
yarn install
```

### 2. Database Setup

```bash
# Start PostgreSQL
brew services start postgresql@15

# Create and migrate database
bundle exec rails db:create
bundle exec rails db:migrate
```

### 3. Environment Configuration

Create `.env` file with OAuth credentials:

```env
# Google OAuth2
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

# GitHub OAuth
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
```

### 4. OAuth Setup

**Google OAuth2:**
1. [Google Cloud Console](https://console.cloud.google.com/) → Create OAuth 2.0 credentials
2. Add redirect URI: `http://localhost:3000/auth/google_oauth2/callback`

**GitHub OAuth:**
1. GitHub Settings → Developer settings → OAuth Apps
2. Add callback URL: `http://localhost:3000/auth/github/callback`

### 5. Start Application

```bash
bundle exec rails server
```

Visit `http://localhost:3000` and sign in with Google or GitHub.

## Testing

### Run Test Suite

```bash
# Run all tests with coverage
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/
```

### Test Coverage

- **81.67% line coverage** (exceeds 80% threshold)
- **69 examples, 0 failures**
- Coverage report: `coverage/index.html`

### Test Structure

```
spec/
├── models/           # Model tests (User, Project, Tag, etc.)
├── controllers/      # Controller tests (Auth, Projects, etc.)
└── spec_helper.rb    # RSpec configuration with SimpleCov
```

## Development

### Database Management

```bash
# Reset database
bundle exec rails db:reset

# Run migrations
bundle exec rails db:migrate

# Rollback
bundle exec rails db:rollback
```

### Asset Compilation

```bash
# Build CSS (production)
yarn build:css

# Build CSS (development)
yarn build:css:dev

# Compile all assets
yarn build:assets

# Watch for changes (development)
yarn build:css:dev --watch

# Manual asset compilation
./bin/compile-assets
```

**Production Deployment:**
- Assets are automatically compiled before Rails server startup
- Use `Procfile` for Heroku/deployment platforms
- Docker containers compile assets via `docker-entrypoint`

### Code Quality

```bash
# Security scan
bundle exec brakeman

# Code coverage
bundle exec rspec
open coverage/index.html
```

## Project Structure

```
app/
├── controllers/      # Auth, Projects, Dashboard, Profile, Sessions
├── models/          # User, Project, Tag, UserLogin, ProjectTag
├── views/           # ERB templates with Tailwind CSS
└── assets/          # CSS and JavaScript

config/
├── routes.rb        # Application routes
├── database.yml     # Database configuration
└── master.key       # Rails credentials key (not in Git)

db/
├── migrate/         # Database migrations
└── schema.rb        # Current database schema
```

## Key Models

- **User**: OAuth integration, profile management, login tracking
- **Project**: Project management with tags and groups
- **Tag**: Flexible tagging system for project organization
- **UserLogin**: Security logging of user sessions

## Security Features

- ✅ Master key properly excluded from Git history
- ✅ OAuth integration with secure callback handling
- ✅ Login tracking with IP addresses and user agents
- ✅ CSRF protection enabled
- ✅ Secure session management

## Troubleshooting

### Common Issues

**OAuth 404 Errors:**
- Verify OAuth app configuration
- Check redirect URIs match exactly
- Ensure OAuth apps are published/enabled

**Database Connection:**
- Ensure PostgreSQL is running: `brew services start postgresql@15`
- Check database credentials in `config/database.yml`

**Asset Compilation:**
- Install dependencies: `yarn install`
- Build assets: `yarn build:css`
- Check CSS file exists: `ls -la app/assets/builds/application.css`
- Force recompilation: `rm app/assets/builds/application.css && ./bin/compile-assets`

**Test Failures:**
- Reset test database: `RAILS_ENV=test bundle exec rails db:reset`
- Check environment variables are set

## License

All rights reserved