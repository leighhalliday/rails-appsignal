class CreateExchanges < ActiveRecord::Migration[6.0]
  def change
    create_table :exchanges do |t|
      t.string :name, null: false
      t.timestamps
      t.index :name
    end
  end
end
