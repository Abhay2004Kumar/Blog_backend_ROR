class PostSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :content, :created_at

  attribute :thumbnail_url do |post|
    if post.thumbnail.attached?
      Rails.application.routes.url_helpers.url_for(post.thumbnail_variant)
    end
  end

  attribute :author do |post|
    post.user.name
  end
end
