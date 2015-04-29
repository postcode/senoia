# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( ie8.css )
Rails.application.config.assets.precompile += %w( ie9.css )

Rails.application.config.assets.precompile += %w( ie9.js )
Rails.application.config.assets.precompile += %w( ie8.js )
Rails.application.config.assets.precompile += %w( ie/foundation4/foundation.min.js )
Rails.application.config.assets.precompile += %w( ie/foundation3/foundation.min.js )
Rails.application.config.assets.precompile += %w( ie9.css )
Rails.application.config.assets.precompile += %w( ie8.css )
Rails.application.config.assets.precompile += %w( ie/css/foundation4/foundation.min.css )
Rails.application.config.assets.precompile += %w( ie/css/foundation4/normalize.css )
