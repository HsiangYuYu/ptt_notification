class CreateOriginNumbers < ActiveRecord::Migration
  def change
    create_table :origin_numbers do |t|
      t.integer :number

      t.timestamps null: false
    end
  end
end
