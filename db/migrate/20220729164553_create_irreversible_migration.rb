class CreateIrreversibleMigration < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :name, :text
  end
end
