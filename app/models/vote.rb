class Vote
  include Mongoid::Document
  field :vote_id, type: String
  field :voter_id, type: String
  field :value, type: Integer
end
