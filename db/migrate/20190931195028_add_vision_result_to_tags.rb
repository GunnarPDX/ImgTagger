class AddVisionResultToTags < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :visionResult, :string
    add_column :tags, :isVisionTrue, :boolean
  end
end
