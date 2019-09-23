# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :image, optional: true
  belongs_to :product

  include PgSearch::Model # add :dmetaphone
  pg_search_scope :search, against: [:category, :transcription],
                           using: { tsearch: { dictionary: 'english' } },
                           associated_against: {product: :name}

  def self.search(search)
    if search
      rank = <<-RANK
        ts_rank(to_tsvector(category), plainto_tsquery(#{sanitize(search)}))
      RANK

      where("to_tsvector('english', category) @@ :q or to_tsvector('english', transcription) @@ :q", q: search).order("#{rank} desc")
    else
      all
    end
  end
end
