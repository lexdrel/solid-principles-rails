# Ruby on Rails Dev Container Template

This repository provides a **VS Code Dev Container** setup for rapid Ruby on Rails development using Docker Compose. It includes a ready-to-use Ruby/Rails environment and a PostgreSQL database, plus a modern shell experience with Zsh and plugins.

## Features

- **VS Code Dev Containers**: Seamless development with [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers).
- **Docker Compose**: Spins up both a Ruby/Rails development container and a PostgreSQL database container.
- **Zsh & Plugins**: Enjoy Zsh with [Oh My Zsh](https://ohmyz.sh/), syntax highlighting, and autosuggestions.
- **No Rails Project Included**: Start your Rails app from scratch, choosing only the tools you need.

## Rails Tools You Can Select When Creating a New App

When you run `rails new`, you can choose to include or skip various tools and frameworks, such as:

- **Tailwind CSS** (`--css tailwind`)
- **Bootstrap** (`--css bootstrap`)
- **Sass** (`--css sass`)
- **Stimulus** (`--javascript esbuild` or `--javascript importmap`)
- **Hotwire** (Turbo & Stimulus, enabled by default)
- **RSpec** (add manually or via template)
- **Minitest** (default)
- **Webpack** (legacy, not recommended for new apps)
- **Action Mailbox**
- **Action Text**
- **Active Storage**
- **System Tests**
- **API-only mode** (`--api`)
- **Skip Active Record** (`--skip-active-record`)
- **Skip Test** (`--skip-test`)
- **Skip Hotwire** (`--skip-hotwire`)

## Basic Rails CLI Commands

- `rails new <app_name> [options]` — Create a new Rails app
- `rails server` — Start the Rails development server
- `rails console` — Open the Rails console
- `rails db:create` — Create the database
- `rails db:migrate` — Run database migrations
- `rails generate <generator>` — Generate code (models, controllers, etc.)
- `rails test` or `rspec` — Run tests

## Recommended Command to Start a New Rails App (with PostgreSQL & Tailwind)

Inside the dev container terminal, run:

```sh
rails new . --database=postgresql --css=tailwind
```

This will:

- Create a new Rails app in the current directory
- Configure it to use PostgreSQL as the database
- Set up Tailwind CSS for styling

## Getting Started

1. **Open in VS Code**
   Use "Open Folder in Container" or the "Reopen in Container" prompt.

2. **Start Services**
   Docker Compose will automatically start both the Rails and PostgreSQL containers.

3. **Create Your Rails App**
   Open a terminal in VS Code and run the recommended `rails new` command above.

4. **Configure Database**
   Update your `config/database.yml` if needed to match the PostgreSQL service settings.

5. **Enjoy Zsh**
   The terminal uses Zsh with plugins for a modern shell experience.

## Setup the postgresDB after generate the rails app
1. Go to the config/database.yml file
2. in the default or any env, the credentiasl should looks like
```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV['ENV_USERNAME'] %>
  password: <%= ENV['ENV_PASSWORD'] %>
  host: <%= ENV['ENV_HOST'] %>
  port: 5432
```
3. create an .env file in root directory with this:
```yaml
ENV_USERNAME=postgres
ENV_PASSWORD=postgres
ENV_HOST=localhost
```
4. and to the gemfile the next lines:
```rb
# Load environment variables from .env files
gem "dotenv-rails", groups: [ :development, :test ]
```
5. in the console type the next:
```sh
rails db:setup
```
6. and that's it, you now have setuped up the db

---

**Tip:**
You can customize your Rails app with additional options as needed. See `rails new --help` for more.
