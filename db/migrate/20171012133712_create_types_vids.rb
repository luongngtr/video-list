class CreateTypesVids < ActiveRecord::Migration
  def change
    create_table :types_vids, id: false do |t|
      t.belongs_to :type
      t.belongs_to :vid
    end
  end
end
