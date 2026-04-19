class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :category
      t.integer :credits
      t.string :status

      t.timestamps
    end
  end
end
