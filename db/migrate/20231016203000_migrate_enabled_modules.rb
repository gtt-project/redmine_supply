class MigrateEnabledModules < ActiveRecord::Migration[5.2]
  def self.up
    execute <<-SQL
      INSERT INTO enabled_modules (project_id, name)
      SELECT project_id, 'resource' AS name FROM enabled_modules
        WHERE name = 'supply' AND
              NOT EXISTS (SELECT * FROM enabled_modules WHERE name = 'resource')
    SQL
  end

  def self.down
    execute "DELETE FROM enabled_modules WHERE name = 'resource'"
  end
end
