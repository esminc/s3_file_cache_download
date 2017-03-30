class FileCache < ApplicationRecord
  EXPIRE_TIME        = S3FileCacheDownload.expire_time
  DOWNLOAD_DIRECTORY = S3FileCacheDownload.download_directory

  class << self
    def cleaning_directory_and_record
      limit = Time.zone.now - EXPIRE_TIME

      expired_files = where('created_at < ?', limit)
      expired_files.each do |expired_file|
        FileUtils.rm(expired_file.place)
        expired_file.destroy
      end
    end
  end

  def place
    "#{download_directory}/#{id}"
  end
end
