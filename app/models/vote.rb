class Vote
  include Mongoid::Document
  field :voter_id, type: String
  field :value, type: Integer
end
