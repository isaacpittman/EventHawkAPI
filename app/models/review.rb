class Review
  include Mongoid::Document
  field :reviewer_id, type: String
  field :host_prep, type: Integer
  field :matched_desc, type: Integer
  field :would_ret, type: Boolean
end
