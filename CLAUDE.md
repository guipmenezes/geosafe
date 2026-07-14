# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GeoSafe is a Ruby on Rails application that provides real-time, location-based information sharing for communities. Users can create and classify alerts about local events, helping others stay informed about what's happening in their area without relying on traditional news sources.

## Development Environment Setup

### Database Setup
- Uses PostgreSQL (version 14+) - ensure it's running locally or in a Docker container
- Run database setup with: `rails db:create db:migrate`
- Default development port: 3000

### Starting the Application
```bash
# Install dependencies
bundle install
npm install

# Start development server (runs Rails server and Tailwind CSS watch)
bin/dev
```

The `bin/dev` script uses Foreman to manage processes defined in `Procfile.dev`:
- Web server: `bin/rails server`
- CSS compilation: `bin/rails tailwindcss:watch`

## Common Development Commands

### Testing
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/requests/sessions_spec.rb

# Run tests with specific pattern
bundle exec rspec spec/system/

# Run single test by line number
bundle exec rspec spec/requests/sessions_spec.rb:12
```

### Code Quality
```bash
# Run RuboCop linting
bundle exec rubocop

# Auto-fix RuboCop issues
bundle exec rubocop -a

# Run ERB linting
bundle exec erblint --lint-all

# Auto-fix ERB issues
bundle exec erblint --lint-all -a
```

### Database Operations
```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Rollback migration
rails db:rollback

# Reset database (drop, create, migrate)
rails db:reset db:seed
```

### Asset Management
```bash
# Compile Tailwind CSS
rails tailwindcss:build

# Watch for CSS changes and auto-compile
rails tailwindcss:watch

# Precompile assets for production
rails assets:precompile
```

## Architecture Overview

### Authentication & User Management
- Uses `authentication-zero` gem with custom session management
- Token-based email verification (2-day expiry)
- Token-based password reset (20-minute expiry)
- Strong password requirements (12+ chars with complexity)
- Session invalidation on password change

### Core Models
- **User**: Authentication, profiles, plan subscriptions
- **Session**: User sessions with IP/user agent tracking
- **Address**: User location information
- **Plan/PlanSubscription**: Subscription management system

### View Components
Uses ViewComponent for reusable UI elements:
- `Button::ButtonComponent`: Styled buttons with variants (primary/secondary)
- `Icon::IconComponent`: Icon rendering
- `Logo::LogoComponent`: Application logo
- `Input::InputComponent`: Form inputs

### Frontend Stack
- **Tailwind CSS**: Utility-first CSS framework
- **Hotwire (Turbo + Stimulus)**: Modern SPA-like interactions
- **Import Maps**: JavaScript dependency management
- **ViewComponent**: Component-based view architecture

### Testing Strategy
- **RSpec**: Unit and integration tests
- **Capybara + Cuprite**: System/end-to-end testing
- **Request Specs**: API endpoint testing
- **Component Specs**: View component testing

### Key Configuration Files
- `config/routes.rb`: RESTful routes with authentication endpoints
- `Procfile.dev`: Development process management
- `tailwind.config.js`: Tailwind CSS configuration
- Import maps for JavaScript dependencies

### Application Structure
```
app/
├── components/          # ViewComponent UI components
├── controllers/         # MVC controllers
├── models/             # ActiveRecord models
├── views/              # ERB templates
├── helpers/            # View helpers
├── mailers/            # Action Mailer
├── jobs/               # Active Job
└── channels/           # Action Cable
```

## Development Notes

### Code Quality Standards
- RuboCop for Ruby code style enforcement
- ERB Lint for template validation
- Portuguese error messages for user-facing validation
- Consistent naming conventions (snake_case for Ruby, kebab-case for CSS)

### Security Features
- Secure password hashing with bcrypt
- Session-based authentication with signed cookies
- Email verification workflow
- Password reset with time-limited tokens
- CSRF protection
- IP and user agent tracking for sessions