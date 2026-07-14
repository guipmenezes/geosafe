## Copilot / AI Agent Instructions for GeoSafe

Purpose: help an AI coding agent become immediately productive in this Ruby on Rails repo.

- **Project type:** Ruby on Rails (Rails 7 style), PostgreSQL-backed web app.
- **Key start commands:** ensure Postgres (v14+) is available, then:
  - `rails db:create db:migrate`
  - `bin/dev` (starts app and Tailwind via `Procfile.dev`)

- **Where to look first:**
  - Routing & API surface: `config/routes.rb`
  - Controllers: `app/controllers/` (e.g. `sessions_controller.rb`, `registrations_controller.rb`)
  - Domain models: `app/models/` (`user.rb`, `session.rb`, `address.rb`, `plan.rb`, `plan_subscription.rb`)
  - UI components: `app/components/` (ViewComponent-based)
  - Frontend controllers: `app/javascript/controllers/` (Stimulus)
  - Tailwind config: `config/tailwind.config.js`
  - Dev process: `Procfile.dev`, `bin/dev`, `Dockerfile`

- **Tests & test commands:**
  - Tests live under `spec/` (unit, request, system, component specs).
  - Run all specs: `bundle exec rspec`
  - Run a single file: `bundle exec rspec spec/requests/sessions_spec.rb`
  - Run a single example by line: `bundle exec rspec spec/requests/sessions_spec.rb:12`
  - System tests use Capybara + Cuprite (see `spec/` for examples).

- **Linters / quality checks:**
  - RuboCop: `bundle exec rubocop` (auto-fix `-a`)
  - ERB Lint: `bundle exec erblint --lint-all` (auto-fix `-a`)

- **Frontend & assets:** Uses Tailwind + Importmaps. Typical commands:
  - `rails tailwindcss:build`
  - `rails tailwindcss:watch` (also triggered by `bin/dev`)
  - `rails assets:precompile` for production builds

- **Authentication & security notes (where logic lives):**
  - Authentication uses a custom session flow (see `app/models/session.rb`, controllers under `app/controllers/`), token-based email verification and password reset logic are present — be careful when changing token expiry or flows.
  - Password policy: strong requirements (see validations in `app/models/user.rb`). Sessions include IP and user-agent tracking.

- **View / component patterns to follow:**
  - UI is componentized using ViewComponent. Look at `app/components/*` for examples (buttons, inputs, icons).
  - Prefer adding new UI as ViewComponents rather than large partials.

- **Common developer workflows to automate/observe:**
  - DB migrations go to `db/migrate/` — new migrations must be runnable in CI.
  - Seed/reset in development: `rails db:reset db:seed`
  - Use `bin/dev` for local development to mirror Procfile.dev processes.

- **Integration points:**
  - Mailers: `app/mailers/` (email verification, password reset)
  - Background jobs: `app/jobs/`
  - Websockets: `app/channels/`
  - Docker: `Dockerfile` for container builds

- **Examples to reference when making changes:**
  - Add a controller endpoint similar to `app/controllers/sessions_controller.rb` and wire it in `config/routes.rb`.
  - Create components following `app/components/button/` and `app/components/input/` structure.
  - Frontend JS interactions should use Stimulus controllers in `app/javascript/controllers/` and importmap entries in `config/importmap.rb`.

- **What not to change lightly:**
  - Authentication/session/token code paths and token expiry logic.
  - Database column names used by existing migrations and fixtures.

If anything above is unclear or you need examples for a specific change (controller, component, or test), tell me which area and I will add a short, focused example patch.
