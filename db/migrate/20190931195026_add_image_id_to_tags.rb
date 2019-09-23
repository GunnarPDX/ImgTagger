class AddImageIdToTags < ActiveRecord::Migration[5.0]
  def up
    add_column :tags, :image_id, :integer

    Tag.reset_column_information

    Tag.all.each do |t|
      i = Image.find_by_handle(t.handle)
      if i
        t.image_id = i.id
        t.save
      end
    end
  end

  def down
    remove_column :tags, :image_id

  end
end
