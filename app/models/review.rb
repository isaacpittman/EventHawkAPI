class Review
  include Mongoid::Document
  store_in collection: "reviews"

  field :review_id, type: String
  field :reviewer_id, type: String
  field :host_prep, type: Integer
  field :matched_desc, type: Integer
  field :would_ret, type: Boolean
  field :event_id, type: String
  field :is_active, type: Boolean

  validates :review_id, presence: true
  validates :reviewer_id, presence: true
  validates :host_prep, presence: true, allow_nil: false, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :matched_desc, presence: true, allow_nil: false, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :would_ret, presence: true, allow_nil: false
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
