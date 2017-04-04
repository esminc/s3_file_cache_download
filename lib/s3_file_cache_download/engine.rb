module S3FileCacheDownload
  class Engine < ::Rails::Engine
    isolate_namespace S3FileCacheDownload

    initializer :append_migrations do |app|
      return if app.root.to_s.match root.to_s

      config.paths['db/migrate'].expanded.each do |expanded_path|
        app.config.paths['db/migrate'] << expanded_path
      end
      ActiveRecord::Tasks::DatabaseTasks.migrations_paths = app.config.paths['db/migrate']
    end
  end
end
