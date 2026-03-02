# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}-slim-bookworm AS base

WORKDIR /rails

# Install base packages for runtime
# jemalloc: memory optimization
# libvips: for Active Storage and image processing
# postgresql-client: for database interaction
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    tzdata \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set common environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2" \
    MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true"

# --- Build Stage (for Release) ---
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY . .

RUN bundle exec bootsnap precompile app/ lib/
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile && \
    rm -rf node_modules


# --- Devcontainer ---
FROM base AS devcontainer

ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="0" \
    BUNDLE_WITHOUT="" \
    PATH="/workspaces/rails-demo/bin:$PATH"

# Install dev tools
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    sudo \
    zsh \
    openssh-client \
    imagemagick \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

ARG DEVELOPER_UID=1000
ARG DEVELOPER_USERNAME=vscode

RUN groupadd --gid ${DEVELOPER_UID} ${DEVELOPER_USERNAME} \
    && useradd --uid ${DEVELOPER_UID} --gid ${DEVELOPER_UID} -m -s /bin/zsh ${DEVELOPER_USERNAME} \
    && echo "${DEVELOPER_USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${DEVELOPER_USERNAME} \
    && chmod 0440 /etc/sudoers.d/${DEVELOPER_USERNAME}

USER ${DEVELOPER_USERNAME}
# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN gem install rails
# --- Tests ---
FROM base AS tests

ENV RAILS_ENV="test" \
    BUNDLE_DEPLOYMENT="0" \
    BUNDLE_WITHOUT=""

# Install build dependencies + Chromium
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    git \
    libpq-dev \
    wget \
    libyaml-dev \
    pkg-config \
    libgbm1 \
    libu2f-udev \
    fonts-liberation \
    firefox-esr \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz && \
    tar -xzf geckodriver-v0.34.0-linux64.tar.gz && \
    mv geckodriver /usr/local/bin/ && \
    rm geckodriver-v0.34.0-linux64.tar.gz

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Run as non-root user for Chrome to work properly
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER 1000:1000

# --- Release ---
FROM base AS release

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run as non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 80
CMD ["./bin/thrust", "bundle", "exec", "puma", "-C", "config/puma.rb"]
