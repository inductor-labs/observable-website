set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
  set :http_prefix, '/observable-website'
  activate :minify_css
  activate :minify_javascript
end
