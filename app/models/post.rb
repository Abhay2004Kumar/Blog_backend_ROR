class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :thumbnail


  validates :title, presence: true
  validates :content, presence: true
  validate :thumbnail_size_validation
  validate :thumbnail_type_validation

  def thumbnail_variant
    thumbnail.variant(
      resize_to_fill: [600, 400]
    )
  end

  private

  def thumbnail_size_validation
    return unless thumbnail.attached?   

    if thumbnail.byte_size > 5.megabytes
      errors.add(:thumbnail, "size should be less than 5MB")
    end
  end

  def thumbnail_type_validation
    return unless thumbnail.attached?

    unless thumbnail.content_type.in?(%w[image/jpeg image/png image/webp])
      errors.add(:thumbnail, "must be a JPEG, PNG, or WEBP")
    end
  end

end