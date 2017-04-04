class AddIndexToS3FileCache < ActiveRecord::Migration[5.0]
  def change
    add_index :s3_file_caches, :s3_full_path
  end
end
