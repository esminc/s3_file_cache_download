require 's3_file_cache_download/engine'
require 'action_controller'
require 'active_support/configuable'
require 'aws-sdk'

module S3FileCacheDownload
  include ActiveSupport::Configuable

  config_accessor :aws_access_key_id, instance_reader: false, instance_writer: false do
    ENV['AWS_ACCESS_KEY']
  end

  config_accessor :aws_secret_access_key, instance_reader: false, instance_writer: false do
    ENV['AWS_SECRET_ACCESS_KEY']
  end

  config_accessor :file_cache_directory, instance_reader: false, instance_writer: false do
    ENV['FILE_CACHE_DIRECTORY']
  end

  config_accessor :expire_hour, instance_reader: false, instance_writer: false do
    ENV['EXPIRE_SECONDS']
  end

  module Helper
    def send_s3_file(bucket_name, path)
      s3_object = S3FileCacheDownload::S3Object.new(bucket_name, path)
      s3_file_cache = S3FileCache.find_by(s3_full_path: path)

      unless s3_file_cache
        s3_file_cache = S3FileCache.create(s3_full_path: path)
        File.open(s3_file_cache.place, 'w') do |file|
          s3_object.get do |chunk|
            file.write chunk
          end
        end
      end

      send_file s3_file_cache.place, file_name: s3_file_cache.filename
    end

    private

    def download_directory
      S3FileCacheDownload.file_cache_directory
    end
  end

  class S3Object
    def initialize(bucket_name, path)
      @bucket = Aws::S3::Resource.new(client: client).bucket(bucket_name)
      @path   = path
    end

    def get
      @bucket.get(@path).body
    end

    private

    def client
      @client ||= Aws::S3::Client.new(
        access_key_id: S3FileCacheDownload.aws_access_key_id,
        secret_access_key: S3FileCacheDownload.aws_secret_access_key
      )
    end
  end
end
