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
  validates :value, presence: true, allow_nil: false, numericality: { only_integer: true, greater_than_or_equal_to: -1, less_than_or_equal_to: 1 }
  validates :event_id, presence: true
  validate :check_event

  def check_event
    begin
      event = Event.find_by(event_id: self.event_id)
    rescue Mongoid::Errors::DocumentNotFound
      errors.add(:event_id, "Event ID must be a valid event")
    end
  end
end
