class S3FileCache < ApplicationRecord
  class << self
    def cleaning_directory_and_record!
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

  def expire?
    created_at + S3FileCacheDownload.expire_seconds < Time.zone.now
  end

  def fetch!
    return if File.exist?(place)

    s3_object = S3FileCache::S3Object.new(bucket_name, s3_full_path)
    File.open(place, 'w') do |file|
      s3_object.get do |chunk|
        file.write chunk.read
      end
    end
  end

  def place
    "#{S3FileCache.file_cache_directory}/#{id}"
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
      body = @bucket.object(@path).get.body

      if block_given?
        yield body
      else
        body
      end
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
