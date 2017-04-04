class CreateS3FileCaches < ActiveRecord::Migration[5.0]
  def change
    create_table :s3_file_caches do |t|
      t.string :bucket_name, null: false
      t.string :s3_full_path, null: false, index: true

      t.timestamps null:false
    end
  end
end
