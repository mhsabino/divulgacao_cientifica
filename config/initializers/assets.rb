# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w(
  admin.*
  ckeditor/config.js
  views/admin/educators/edit.js
  views/admin/educators/index.js
  views/admin/educators/new.js

  views/admin/disciplines/edit.js
  views/admin/disciplines/index.js
  views/admin/disciplines/new.js

  views/admin/students/edit.js
  views/admin/students/index.js
  views/admin/students/new.js

  views/admin/school_classes/edit.js
  views/admin/school_classes/index.js
  views/admin/school_classes/new.js
)
