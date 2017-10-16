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
end
