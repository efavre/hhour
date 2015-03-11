source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.2.0'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise'
gem 'aws-sdk', '< 2.0'
gem 'activeadmin', github: 'activeadmin'
gem 'turbolinks'
gem 'houston'
gem 'acts_as_commentable'

# DEVELOPMENT

group :test, :development do
  gem 'byebug'
	gem 'sqlite3'
	gem 'spring'
  gem 'rspec-rails'
  gem "factory_girl_rails", "~> 4.0"
  gem 'simplecov', :require => false
end

# PRODUCTION

group :production do
	gem 'rails_12factor'
	gem 'unicorn'
	gem 'pg'
end
