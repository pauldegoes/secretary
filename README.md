# Secretary

A modern Ruby on Rails project management application with SSO authentication, built with clean code principles and a responsive UI.

## Features

### Authentication
- **SSO Integration**: Sign in with Google and GitHub
- **User Management**: Automatic user creation and profile management
- **Security**: Login tracking with IP addresses and user agents
- **Profile Photos**: Automatic photo download and resizing (300x300px max)

### Project Management
- **Project Creation**: Create projects with name, target date, owner, and project groups
- **Project Groups**: Tag-based grouping system (similar to Jira labels)
- **Dashboard**: Overview of all projects with statistics
- **Project Details**: Detailed project view with editing capabilities

### User Interface
- **Responsive Design**: Built with Tailwind CSS for mobile-first design
- **Modern Layout**: Clean header with user dropdown and dynamic sidebar
- **Intuitive Navigation**: Easy project organization and access

## Technology Stack

- **Backend**: Ruby on Rails 7.1.5
- **Database**: PostgreSQL 15
- **Frontend**: Tailwind CSS with responsive design
- **Authentication**: OmniAuth with Google OAuth2 and GitHub
- **Image Processing**: MiniMagick for photo resizing
- **Ruby Version**: 3.4.7

## Prerequisites

- Ruby 3.4.7 (managed with rbenv)
- PostgreSQL 15
- Node.js and Yarn (for asset compilation)
- Git

## Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd secretary
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Install Node.js dependencies
yarn install
```

### 3. Database Setup

```bash
# Start PostgreSQL (if not already running)
brew services start postgresql@15

# Create and setup the database
bundle exec rails db:create
bundle exec rails db:migrate
```

### 4. Environment Configuration

Create a `.env` file in the root directory with the following variables:

```env
# Google OAuth2 Configuration
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

# GitHub OAuth Configuration
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret

# Database Configuration (if needed)
DATABASE_URL=postgresql://username:password@localhost/secretary_development
```

### 5. OAuth Setup

#### Google OAuth2 Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URIs:
   - `http://localhost:3000/auth/google_oauth2/callback` (development)
   - `https://yourdomain.com/auth/google_oauth2/callback` (production)

#### GitHub OAuth Setup
1. Go to GitHub Settings > Developer settings > OAuth Apps
2. Create a new OAuth App
3. Set Authorization callback URL:
   - `http://localhost:3000/auth/github/callback` (development)
   - `https://yourdomain.com/auth/github/callback` (production)

### 6. Start the Application

```bash
# Start the Rails server
bundle exec rails server

# Or use the development script (includes asset compilation)
bin/dev
```

The application will be available at `http://localhost:3000`

## Usage

### First Time Setup
1. Visit `http://localhost:3000`
2. Click "Continue with Google" or "Continue with GitHub"
3. Authorize the application
4. You'll be redirected to the dashboard

### Creating Projects
1. Click "New Project" in the sidebar
2. Fill in project details:
   - **Project Name**: Required
   - **Owner**: Required
   - **Target Date**: Optional
   - **Project Group**: Type to search existing groups or create new ones
3. Click "Create Project"

### Managing Projects
- **View Projects**: Click on any project name to view details
- **Edit Projects**: Use the edit button on project cards or detail pages
- **Delete Projects**: Use the delete button (with confirmation)
- **Organize by Groups**: Projects are automatically grouped by tags

### Profile Management
- **View Profile**: Click on your email in the header dropdown
- **Update Photo**: Upload a new profile photo (will replace SSO photo)
- **View Login History**: See recent login attempts with IP addresses

## Development

### Running Tests
```bash
bundle exec rails test
```

### Code Quality
```bash
# Run Brakeman security scanner
bundle exec brakeman

# Run RuboCop (if configured)
bundle exec rubocop
```

### Database Management
```bash
# Reset database
bundle exec rails db:reset

# Run migrations
bundle exec rails db:migrate

# Rollback migrations
bundle exec rails db:rollback
```

### Asset Compilation
```bash
# Compile CSS
yarn build:css

# Watch for changes
yarn build:css --watch
```

## Project Structure

```
secretary/
├── app/
│   ├── controllers/          # Application controllers
│   ├── models/              # ActiveRecord models
│   ├── views/               # ERB templates
│   └── assets/              # CSS and JavaScript assets
├── config/                  # Application configuration
├── db/                      # Database migrations and schema
├── lib/                     # Custom libraries
├── public/                  # Static assets
└── test/                    # Test files
```

## Database Schema

### Users
- `username`: Unique username
- `email`: Unique email address
- `first_name`, `last_name`: User's name
- `provider`, `uid`: OAuth provider information
- `photo`: ActiveStorage attachment for profile photo

### Projects
- `name`: Project name
- `target_date`: Project deadline
- `owner`: Project owner
- `user_id`: Foreign key to users

### Tags
- `name`: Tag name
- `namespace`: Tag category (e.g., 'project_group')

### ProjectTags
- `project_id`, `tag_id`: Many-to-many relationship

### UserLogins
- `user_id`: Foreign key to users
- `ip_address`: Login IP address
- `user_agent`: Browser information
- `signed_in_at`: Login timestamp

## Deployment

### Production Environment Variables
```env
RAILS_ENV=production
SECRET_KEY_BASE=your_secret_key_base
SECRETARY_DATABASE_PASSWORD=your_db_password
GOOGLE_CLIENT_ID=your_production_google_client_id
GOOGLE_CLIENT_SECRET=your_production_google_client_secret
GITHUB_CLIENT_ID=your_production_github_client_id
GITHUB_CLIENT_SECRET=your_production_github_client_secret
```

### Deployment Checklist
- [ ] Set up production database
- [ ] Configure OAuth redirect URIs for production domain
- [ ] Set environment variables
- [ ] Run database migrations
- [ ] Compile assets
- [ ] Configure web server (Nginx/Apache)
- [ ] Set up SSL certificates

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository.