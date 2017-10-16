class CreateVids < ActiveRecord::Migration
  def change
    create_table :vids do |t|
      t.string :name
      t.string :address
      t.text :description

      t.timestamps null: false
    end
  end
end
