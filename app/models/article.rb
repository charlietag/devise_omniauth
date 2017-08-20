class Article < ApplicationRecord
  belongs_to :user

  # Role using rolify
  resourcify

  # Pretty URL using friendly_id
  extend FriendlyId
  # comment the following out to user finders (rails 5.1)
  #friendly_id :title, use: :slugged
  #friendly_id :title, use: :finders
  
  #friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  def should_generate_new_friendly_id?
    slug.blank? || title_changed?

    # Used to regenerate slug using senario defined here
    # set to true , means always generate_new_friendly_id
    #true

    # after setting to true
    # do the following at rails console
    # articles = Article.all
    # articles.each do |a|
    #   a.save
    # end
  end

  def slug_candidates
    [
      #:title,
      [:title, DateTime.now.strftime("%Y-%m-%d") ],
      [:title, DateTime.now.strftime("%Y-%m-%d"), DateTime.now.to_i ]

      # Maybe for good SEO
      # [ :title, DateTime.now.to_i ]
    ]
  end

  def normalize_friendly_id(text)
    text.to_s.to_slug.normalize.to_s
    #text.to_s.to_slug.normalize!
  end

end
