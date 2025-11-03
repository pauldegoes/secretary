# Secretary

A simple, insightful project management application

## Bugs

- **Photo Upload**: Profile photo upload functionality is not working.  Resizing may not be taking place.
- **Login Audit**: Login history missing SSO provider information
- **Navigation UI**: Left sidebar expansion arrow is cut off
- **Project Navigation**: Left Sidebar doesn't show projects section outside dashboard view

## Features for Development
- **Allow users to add comments to each project**
- **Add project statuses**


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

### Known Issues & Workarounds

**Photo Upload Not Working:**
- Profile photo upload is currently broken
- SSO photos work correctly
- Workaround: Use SSO provider photos only

**Navigation Issues:**
- Sidebar expansion arrow may be cut off
- Projects section only visible on dashboard
- Workaround: Navigate via dashboard to access projects

**Login History Missing Provider:**
- Login audit doesn't show which SSO provider was used
- All logins show as generic authentication
- Workaround: Check user's provider field in database

## Roadmap

### Planned Features

- **Multi-User Projects**: Allow multiple users to access and collaborate on project dashboards
- **Project Comments**: Add commenting system to projects for team collaboration
- **Enhanced Navigation**: Fix sidebar issues and improve project navigation
- **Photo Upload**: Resolve profile photo upload functionality
- **Login Audit Enhancement**: Add SSO provider information to login history

### Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/name`
3. Make changes and add tests
4. Ensure tests pass: `bundle exec rspec`
5. Commit: `git commit -m 'Add feature'`
6. Push: `git push origin feature/name`
7. Open Pull Request



## License

All rights reserved