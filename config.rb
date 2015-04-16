###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes
activate :directory_indexes

# Methods defined in the helpers block are available in templates
helpers do
  def gravatar_for(email, size=120)
    hash = Digest::MD5.hexdigest(email.chomp.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}"
  end

  def nav_active(page)
    'active' if current_page.data.body_class == page
  end

  def tag_list(tags)
    if tags.count
      tags.map{ |tag| link_to(tag, blog_url_for(tag_path(tag))) }.join(', ')
    else
      "Post not tagged"
    end
  end

  def web_url_for(url)
    if environment == :build
      "#{web_url}#{url}"
    else
      url
    end
  end

  def blog_url_for(url)
    if environment == :build
      url.sub(/^\/blog/, blog_url)
    else
      url
    end
  end
end

# Use LiveReload
activate :livereload

# Sass base
activate :bourbon
activate :neat

# Compass configuration
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

set :markdown_engine, :redcarpet
set :markdown,  tables: true, autolink: true, gh_blockcode: false, fenced_code_blocks: true, with_toc_data: false, disable_indented_code_blocks: false
set :haml, format: :html5, ugly: true

# Production settings
set :web_url, 'https://diacode.com'
set :blog_url, 'https://blog.diacode.com'

###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  blog.prefix = "blog"
  # blog.permalink = ":year/:month/:day/:title.html"
  blog.permalink = ":title"
  # blog.sources = ":year-:month-:day-:title.html"
  blog.taglink = "tags/:tag.html"
  blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ":year.html"
  # blog.month_link = ":year/:month.html"
  # blog.day_link = ":year/:month/:day.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "/blog/tag.html"
  # blog.calendar_template = "calendar.html"

  blog.paginate = true
  blog.per_page = 5
  # blog.page_link = "page/:num"

  # Custom summary generator. First it checks the excerpt and if it isn't present
  # it summarize the content by getting the first paragraph
  require 'middleman-blog/truncate_html'

  blog.summary_generator = Proc.new do |article| 
    if article.data.excerpt
      article.data.excerpt
    else
      doc = Nokogiri::HTML(article.body)
      paragraphs = doc.xpath('//p')
      first_paragrah = paragraphs.first
      TruncateHTML.truncate_html(first_paragrah.content, 140, " ...")
    end
  end
end

page '/blog/*', layout: 'blog'

page "/feed.xml", layout: false

# Build-specific configuration
configure :build do
  ignore 'images/*.psd'
  ignore 'stylesheets/lib/*'
  ignore 'stylesheets/vendor/*'
  ignore 'javascripts/lib/*'
  ignore 'javascripts/vendor/*'

  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :cache_buster

  # Use relative URLs
  activate :relative_assets

  # activate :minify_html

  # Compress PNGs after build
  # First: gem install middleman-smusher
  require "middleman-smusher"
  activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method       = :rsync
  deploy.host         = 'diacode.com'
  deploy.path         = '/var/www/diacode.com'
  deploy.build_before = true
  deploy.clean        = true # remove orphaned files on remote host, default: false
  deploy.user         = 'deployer'
  deploy.flags        = '-avz --chmod=Du=rwx,Dg=rxs,Fu=rw,Fg=r'
end
