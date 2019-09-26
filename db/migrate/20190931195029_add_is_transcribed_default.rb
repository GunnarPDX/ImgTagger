class AddIsTranscribedDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :tags, :isTranscribed, :boolean, default: false
  end
end
