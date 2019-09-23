class ChangeTranscriptionsModel < ActiveRecord::Migration[5.0]
  def change
    change_table :tags do |t|
      t.rename :parentId, :fullUrl
      t.rename :transcribed, :isTranscribed
    end
  end
end
