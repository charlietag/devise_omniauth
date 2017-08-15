class Article < ApplicationRecord
  belongs_to :user

  resourcify
  extend FriendlyId
  # comment the following out to user finders (rails 5.1)
  #friendly_id :title, use: :slugged
  #friendly_id :title, use: :finders
  
  friendly_id :title, use: [:slugged, :finders]

end
