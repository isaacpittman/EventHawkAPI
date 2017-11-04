class Vote
  include Mongoid::Document
  field :vote_id, type: String
  field :voter_id, type: String
  field :value, type: Integer

  validates :vote_id, presence: true
  validates :voter_id, presence: true
  validates :value, presence: true
end
