source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Improves performance of booting the application
gem 'bootsnap', require: false
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.3.6'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '~> 3.7', '>= 3.7.1'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rvm'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# User authentication
gem 'devise'

# Bootstrap framework
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bootswatch-rails'

# Automatically add vendor prefixes to css
gem 'autoprefixer-rails'

# PDF generation based on HTML, for export.
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', group: :production

# Permission management
gem 'cancancan'

# Bibliography export/import and reference styling
gem 'citeproc-ruby'
gem 'bibtex-ruby'
gem 'csl-styles'

# Markdown parsing and rendering
gem 'redcarpet'

# Tag selection
gem 'selectize-rails'

# Color picker
gem 'jquery-minicolors-rails'

# Breadcrumbs
gem 'breadcrumbs_on_rails'

# Security testing
group :development do
  gem 'brakeman'
  gem 'bundler-audit'
end

# Image processing
gem 'mini_magick'

# PostgreSQL database adapter used both in development and production
gem 'pg', group: [:production, :development]

# Bulk insert statements
gem 'activerecord-import'

# Validations for ActiveStorage file attachments
gem 'file_validators'

# Dropzone for file uploads
gem 'dropzonejs-rails'

# Parsing references
gem 'anystyle'

# Integrate premailer with actionmailer to inline css
gem 'actionmailer_inline_css'

gem 'letter_opener', group: :development

# Transactional email API
gem 'mailgun-ruby'
