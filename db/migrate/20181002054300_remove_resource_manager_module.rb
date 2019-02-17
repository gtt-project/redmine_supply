class RemoveResourceManagerModule < ActiveRecord::Migration[5.2]
  def up
    EnabledModule.where(name: 'resource_manager').each do |m|
      if m.project.enabled_modules.where(name: 'supply').any?
        m.delete
      else
        m.update_column :name, 'supply'
      end
    end
  end

  def down
    # nothing we can do.
  end
end
