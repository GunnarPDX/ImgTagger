# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :image, optional: true
  belongs_to :product

  include PgSearch::Model # add :dmetaphone
  pg_search_scope :search, against: %i[category transcription],
                           using: {
                             tsearch: {
                               dictionary: 'english',
                               prefix: true,
                               any_word: true
                             },
                             trigram: {
                               threshold: 0.1
                             }
                           },
                           associated_against: { product: :name }

  def self.search(search)
    if search
      rank = <<-RANK
        ts_rank(to_tsvector(category), plainto_tsquery(#{sanitize(search)}))
      RANK

      where("to_tsvector('english', category) @@ plainto_tsquery(:q) or to_tsvector('english', transcription) @@ plainto_tsquery(:q)", q: search).order("#{rank} desc")
    else
      all
    end
  end
end
