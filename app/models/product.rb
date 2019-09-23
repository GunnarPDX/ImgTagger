# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :tags, through: :images
  has_many :tags, dependent: :destroy

  include PgSearch::Model # add :dmetaphone
  pg_search_scope :search, against: [:name],
                           using: { tsearch: { dictionary: 'english' } }

  def self.search(search)
    if search
      rank = <<-RANK
        ts_rank(to_tsvector(name), plainto_tsquery(#{sanitize(search)}))
      RANK

      where("to_tsvector('english', name) @@ :q", q: search).order("#{rank} desc")
      # where(["name @@ ?", "%#{search}%"])
    else
      all
    end
  end
end
