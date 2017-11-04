class Event
  include Mongoid::Document
  field :event_id, type: String
  field :name, type: String
  field :description, type: String
  field :time, type: DateTime
  field :location, type: String
  field :current_capacity, type: Integer
  field :total_capacity, type: Integer
  field :interest_rating, type: Integer
  field :category, type: String
  field :host_id, type: Integer
  field :review_host_prep, type: Float
  field :review_matched_desc, type: Float
  field :review_would_ret, type: Float

  validates :event_id, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :time, presence: true
  validates :location, presence: true
  validates :current_capacity, presence: true
  validates :total_capacity, presence: true
  validates :interest_rating, presence: true
  validates :category, presence: true
  validates :host_id, presence: true
end
