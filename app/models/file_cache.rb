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

  def place
    "#{FileCache.file_cache_directory}/#{id}"
  end
end
