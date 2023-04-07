class Video < ApplicationRecord

  belongs_to :media, optional: true
  belongs_to :season, optional: true

  has_many :subtitles, dependent: :destroy

  validate :belongs_to_media_or_season

  private

  def belongs_to_media_or_season
    if media_id.nil? && season_id.nil?
      errors.add(:base, "Video 必须属于 Media 或 Season")
    elsif media_id.present? && season_id.present?
      errors.add(:base, "Video 不能同时属于 Media 和 Season")
    end
  end

end
