# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile << /\.(?:png|gif|svg|eot|woff|ttf)\Z/

Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Minimum Sass number precision required by bootstrap-sass.
# See https://github.com/twbs/bootstrap-sass#bower-with-rails
::Sass::Script::Number.precision = [ 8, ::Sass::Script::Number.precision ].max
