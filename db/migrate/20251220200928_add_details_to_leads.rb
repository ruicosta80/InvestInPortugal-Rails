class AddDetailsToLeads < ActiveRecord::Migration[7.1]
  def change
    add_column :leads, :budget, :string
    add_column :leads, :timeline, :string
    add_column :leads, :ai_response, :text
  end
end
