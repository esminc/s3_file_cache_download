require 's3_file_cache_download/engine'
require 'action_controller'
require 'active_support/configurable'
require 'aws-sdk'

module S3FileCacheDownload
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

  module Helper
    def send_s3_file(bucket_name, path)
      s3_file_cache = S3FileCache.find_or_create_by(s3_full_path: path, bucket_name: bucket_name)
      s3_file_cache.fetch!

      send_file s3_file_cache.place, file_name: s3_file_cache.filename
    end
  end
end
