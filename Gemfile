source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.2"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 7.2"

# Alpine requires these to build the assets
gem "tzinfo"
gem "tzinfo-data"

# For compiling our frontend assets
gem "vite_rails", "~> 3.0"

# For structured logging
gem "lograge", "~> 0.14"

gem "config"

# Use Sentry (https://sentry.io/for/ruby/?platform=sentry.ruby.rails#)
gem "sentry-rails", "~> 6"
gem "sentry-ruby", "~> 6"

# For markdown rendering
gem "govuk_markdown", "~> 2.0"
gem "markdown-rails", "~> 2.1"

# For GOV.UK branding
gem "govuk-components", "~> 6"
gem "govuk_design_system_formbuilder", "~> 6"

# For pausing pipelines
gem "aws-sdk-codepipeline", "~> 1.112"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  gem "rspec-rails", "~> 8.0.4"
  gem "rubocop-govuk", require: false

  # For security auditing gem vulnerabilities. RUN IN CI
  gem "bundler-audit", "~> 0.9.3"

  # For detecting security vulnerabilities in Ruby on Rails applications via static analysis.
  gem "brakeman", "~> 8.0.4"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  gem "webmock"

  # Code coverage reporter
  gem "simplecov", "~> 0.22.0", require: false

  # For validating the JSON schema for form submissions
  gem "json_schemer"
end
