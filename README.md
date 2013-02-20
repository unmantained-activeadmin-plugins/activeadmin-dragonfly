### Gemfile

```ruby
gem 'activeadmin-dragonfly', github: 'stefanoverna/activeadmin-dragonfly'
```

### Model

```ruby
class BlogPost < ActiveRecord::Base
  attr_accessible :image, :retained_image, :remove_image
  image_accessor :image
end
```

### Editor

```ruby
ActiveAdmin.register BlogPost do
  form do |f|
    # ...
    f.input :image, as: :dragonfly
    f.input :image, as: :dragonfly, input_html: { components: [:preview, :upload, :url, :remove ] }
    # ...
  end
end
```
