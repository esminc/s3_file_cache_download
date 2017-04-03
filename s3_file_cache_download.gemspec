$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "s3_file_cache_download/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "s3_file_cache_download"
  s.version     = S3FileCacheDownload::VERSION
  s.authors     = ["wat-aro"]
  s.email       = ["kazutas1008@gmail.com"]
  s.homepage    = "https://github.com/esminc/s3_file_cache_download"
  s.summary     = "provide helper method that S3 file download use temporaly file"
  s.description = "provide helper method that S3 file download use temporaly file"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'actionpack'
  s.add_dependency 'activesupport'
  s.add_dependency 'aws-sdk'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end
