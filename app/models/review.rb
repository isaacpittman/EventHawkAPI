class Review
  include Mongoid::Document
  field :review_id, type: String
  field :reviewer_id, type: String
  field :host_prep, type: Integer
  field :matched_desc, type: Integer
  field :would_ret, type: Boolean
  field :event_id, type: String

  validates :review_id, presence: true
  validates :reviewer_id, presence: true
  validates :host_prep, presence: true
  validates :matched_desc, presence: true
  validates :would_ret, presence: true
  validates :event_id, presence: true
end
