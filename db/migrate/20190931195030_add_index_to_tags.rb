class AddIndexToTags < ActiveRecord::Migration[5.0]
  def up
    execute "create index tags_category on tags using gin(to_tsvector('english', category))"
    execute "create index tags_transcription on tags using gin(to_tsvector('english', transcription))"
  end

  def down
    execute "drop index tags_category"
    execute "drop index tags_transcription"
  end
end
