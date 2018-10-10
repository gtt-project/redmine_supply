class PopulateSupplyItemTimestamps < ActiveRecord::Migration
  def up
    SupplyItem.find_each do |i|
      journals = i.journals.order(:created_at)
      if i.created_at.nil?
        i.update_column :created_at, journals.first&.created_at||Time.now
      end
      if i.updated_at.nil?
        i.update_column :updated_at, journals.last&.created_at||Time.now
      end
    end
  end
end
