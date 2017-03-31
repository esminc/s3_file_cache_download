class FileCache < ApplicationRecord
  class << self
    def cleaning_directory_and_record
      limit = Time.zone.now - expire_seconds

      expired_files = where('created_at < ?', limit)
      expired_files.each do |expired_file|
        FileUtils.rm(expired_file.place)
        expired_file.destroy
      end
    end

    def expire_seconds
      S3FileCacheDownload.expire_seconds.seconds
    end

    def file_cache_directory
      S3FileCacheDownload.file_cache_directory
    end
  end

  def fetch!(bucket)
    unless File.exist?(place)
      s3_object = FileCache::S3Object.new(bucket_name, s3_full_path)

      File.open(place, 'w') do |file|
        s3_object.get do |chunk|
          file.write chunk
        end
      end
    end
  end

  def place
    "#{FileCache.file_cache_directory}/#{id}"
  end

  def filename
    File.basename(s3_full_path)
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
