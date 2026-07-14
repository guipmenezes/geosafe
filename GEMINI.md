# GEMINI.md

## Project Overview

This is a Ruby on Rails project called GeoSafe. It's a web application that allows users to share and view real-time, location-based information about events happening in their city. The project uses a PostgreSQL database and the Hotwire stack (Turbo, Stimulus) for a modern, single-page application-like experience. User authentication is handled by the `authentication-zero` gem.

## Building and Running

To get the application running, you'll need to have Ruby, and PostgreSQL installed.

1.  **Install Dependencies:**
    ```bash
    bundle install
    ```

2.  **Database Setup:**
    Make sure you have a PostgreSQL server running. The application uses environment variables to configure the database connection. You can set the following environment variables:
    *   `DB_HOST`: The database host.
    *   `DB_USER`: The database user.
    *   `DB_PASSWORD`: The database password.

    Then, create the database and run the migrations:
    ```bash
    rails db:create
    rails db:migrate
    ```

3.  **Running the Application:**
    You can start the development server with the following command:
    ```bash
    bin/dev
    ```
    This will start the Rails server, and you can access the application at `http://localhost:3000`.

## Development Conventions

*   **Testing:** The project uses RSpec for testing. You can run the test suite with the following command:
    ```bash
    rspec
    ```
*   **Linting:** The project uses RuboCop for code style and ERB Lint for ERB templates. You can run the linters with the following commands:
    ```bash
    rubocop
    erblint --lint-all
    ```
*   **Authentication:** Authentication is handled by the `authentication-zero` gem. The `ApplicationController` has a `before_action` that calls the `authenticate` method, which means that most of the application requires the user to be authenticated.
*   **Styling:** The project uses Tailwind CSS for styling.
