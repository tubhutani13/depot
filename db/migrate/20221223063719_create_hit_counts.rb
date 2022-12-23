class CreateHitCounts < ActiveRecord::Migration[7.0]
  def change
    create_table :hit_counts do |t|
      t.integer :count, default: 0
      t.references :user,null:true, foreign_key: true
      t.timestamps
    end
  end
end
