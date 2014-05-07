class Blogpost < ActiveRecord::Base

  attr_accessible :bild_id, :inhalt, :titel, :url_slug

  def to_param
    url_slug
  end

  belongs_to :user

  before_validation :create_slug

  validates :user_id, presence: true
  validates :titel, presence: true
  validates :url_slug, presence: true, uniqueness: true
  validates :inhalt, presence: true

  default_scope order: 'blogposts.created_at DESC'

  private

    def create_slug
      slug = self.titel.parameterize
      if Blogpost.find_by_url_slug(slug)
        slug = slug + "-0"
        slug = unique_slug(slug)
        self.url_slug = slug
      else
        self.url_slug = slug
      end
    end

    def unique_slug(slug)
      arr = slug.split("-")
      n = arr.pop.to_i + 1
      slug = arr.to_sentence.parameterize + "-" + n.to_s
      if Blogpost.find_by_url_slug(slug)
        unique_slug(slug)
      else
        return slug
      end
    end
end
