require 's3_file_cache_download/engine'
require 'action_controller'
require 'active_support/configurable'
require 'aws-sdk'

module S3FileCacheDownload
  class FileCacheDirectoryNotFound < StandardError
    def initialize(cache_dir)
      @cache_dir = cache_dir
      super "`#{cache_dir}` is not found"
    end
  end

  include ActiveSupport::Configurable

  config_accessor :aws_access_key_id, instance_reader: false, instance_writer: false do
    ENV['AWS_ACCESS_KEY']
  end

  config_accessor :aws_secret_access_key, instance_reader: false, instance_writer: false do
    ENV['AWS_SECRET_ACCESS_KEY']
  end

  config_accessor :file_cache_directory, instance_reader: false, instance_writer: false do
    ENV['FILE_CACHE_DIRECTORY']
  end

  config_accessor :expire_seconds, instance_reader: false, instance_writer: false do
    ENV['EXPIRE_SECONDS']
  end

  class << self
    def configure
      yield config

      raise FileCacheDirectoryNotFound, config.file_cache_directory unless Dir.exist?(config.file_cache_directory)
    end
  end

  module Helper
    def send_s3_file(bucket_name, path, option = {})
      s3_file_cache = S3FileCache.find_s3_cache_file_or_create!(path, bucket_name)

      send_file s3_file_cache.place, { filename: s3_file_cache.filename }.merge(option)
    end
  end
end
