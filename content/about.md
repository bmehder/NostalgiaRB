---
title: About
---

# About?

This version is ~30 lines of Ruby plus a layout.

```ruby
get '/*' do
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
```

[Github Repo](https://github.com/bmehder/NostalgiaRB)