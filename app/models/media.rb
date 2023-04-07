class Media < ApplicationRecord

  has_many :seasons
  has_many :videos
  has_many :images

  has_one :metadata, dependent: :destroy

  enum type: { series: 0, movie: 1 }
  enum metadata_source: { tmdb: 0, bgmtv: 1 }

  validates :name, presence: true
  validates :metadata_presence

  private

  def metadata_presence
    if metadata_source.present? ^ metadata_id.present?
      errors.add(:base, 'metadata_source 和 metadata_id 必须同时出现。')
    end
  end

end
