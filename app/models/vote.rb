class Vote
  include Mongoid::Document
  field :vote_id, type: String
  field :voter_id, type: String
  field :value, type: Integer
  field :event_id, type: String

  validates :vote_id, presence: true
  validates :voter_id, presence: true
  validates :value, presence: true
  validates :event_id, presence: true
end
