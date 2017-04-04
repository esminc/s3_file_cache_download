# S3FileCacheDownload

Provide helper method that S3 file download use temporaly file

## Usage

First, execute `bin/rails s3_file_cache_download_engine:install:migrations`.

Second, include `S3FileCacheDownload::Helper` module to your controller.

```ruby
  class YourController
    include S3FileCacheDownload::Helper
  end
```

Call `send_s3_file` method.

```ruby
  class YourController
    include S3FileCacheDownload

    def show
      send_s3_file :your_bucket_name, :your_file_key
    end
  end
```

If you want to use option, you can pass option.

```ruby
  class YourController
    include S3FileCacheDownload

    def show
      send_s3_file :your_bucket_name, :your_file_key, disposition: 'inline'
    end
  end
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 's3_file_cache_download'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install s3_file_cache_download
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
