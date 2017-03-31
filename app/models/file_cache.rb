class FileCache < ApplicationRecord
  EXPIRE_SECONDS       = S3FileCacheDownload.expire_seconds
  FILE_CACHE_DIRECTORY = S3FileCacheDownload.file_cache_directory

  class << self
    def cleaning_directory_and_record
      limit = Time.zone.now - EXPIRE_SECONDS

      expired_files = where('created_at < ?', limit)
      expired_files.each do |expired_file|
        FileUtils.rm(expired_file.place)
        expired_file.destroy
      end
    end
  end

  def place
    "#{FILE_CACHE_DIRECTORY}/#{id}"
  end
end
