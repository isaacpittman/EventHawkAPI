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
  validates :host_prep, presence: true
  validates :matched_desc, presence: true
  validates :would_ret, presence: true
  validates :event_id, presence: true
  validate :check_reviewer
  validate :check_event

  def check_reviewer
    begin
      user = User.find_by(user_id: self.reviewer_id)
    rescue Mongoid::Errors::DocumentNotFound
      errors.add(:reviewer_id, "Reviewer ID must be a valid user")
    end
  end

  def check_event
    begin
      event = Event.find_by(event_id: self.event_id)
    rescue Mongoid::Errors::DocumentNotFound
      errors.add(:event_id, "Event ID must be a valid event")
    end
  end
end
