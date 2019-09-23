class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :category
      t.string :handle
      t.string :parentId
      t.string :cropX
      t.string :cropY
      t.string :cropH
      t.string :cropW
      t.string :rotate

      t.boolean :transcribed, default: false
      t.string :transcription

      t.belongs_to :product, foreign_key: true

      t.timestamps
    end
  end
end
