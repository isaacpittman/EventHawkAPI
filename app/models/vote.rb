class Vote
  include Mongoid::Document
  store_in collection: "votes"

  field :vote_id, type: String
  field :voter_id, type: String
  field :value, type: Integer
  field :event_id, type: String
  field :is_active, type: Boolean

  validates :vote_id, presence: true
  validates :voter_id, presence: true
  validates :value, presence: true
  validates :event_id, presence: true
end
