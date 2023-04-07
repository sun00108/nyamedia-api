class Season < ApplicationRecord

  belongs_to :media

  validate :media_series

  private

  def media_series
    errors.add(:media, 'Media 必须是 Series') unless media&.series?
  end

end
