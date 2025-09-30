# app.rb
# Tiny file-based CMS: Markdown + front matter → HTML via one ERB layout.

require 'sinatra'
require 'yaml'
require 'kramdown'
require 'kramdown-parser-gfm'

set :public_folder, File.expand_path('static', __dir__) # /static/*

helpers do
  def render_markdown(md)
    Kramdown::Document.new(md, input: 'GFM').to_html
  end

  def parse_front_matter(raw)
    # ---\n(front)\n---\n(body)
    if raw =~ /\A---\s*\n(.*?)\n---\s*\n(.*)\z/m
      front = YAML.safe_load($1, permitted_classes: [], aliases: true) || {}
      body  = $2
    else
      front = {}
      body  = raw
    end
    [front, body]
  end
end

get '/*' do
  # Map /           -> content/index.md
  # Map /about      -> content/about.md
  # Map /nested/foo -> content/nested/foo.md
  path = params[:splat].first
  path = 'index' if path.nil? || path.empty?
  file = File.expand_path(File.join('content', "#{path}.md"), __dir__)

  halt 404, "Not found" unless File.file?(file)

  raw = File.read(file, mode: 'r:BOM|UTF-8')
  front, md = parse_front_matter(raw)

  @title   = front['title'] || path.split('/').last.gsub(/[-_]+/, ' ').split.map(&:capitalize).join(' ')
  @meta    = front
  @content = render_markdown(md)

  erb :layout
end