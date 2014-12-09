# activeadmin-dragonfly

### :warning: Unmaintained :warning:

Sorry, but I no longer work on ActiveAdmin often enough to justify mantaining this gem. Take it as it is. If you are interested to update and maintain the gem, please let me know! :heart:

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
