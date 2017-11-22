class Ticket
  include Mongoid::Document
  store_in collection: "tickets"

  field :ticket_id, type: String
  field :attendee_id, type: String
  field :event_id, type: String
  field :is_active, type: Boolean

  validates :ticket_id, presence: true
  validates :attendee_id, presence: true
  validates :event_id, presence: true
  validates :is_active, presence: true
  validate :check_event
  validate :check_capacity

  def check_event
    begin
      @event = Event.find_by(event_id: self.event_id)
    rescue Mongoid::Errors::DocumentNotFound
      errors.add(:event_id, "Event ID must be a valid event")
    end
  end

  def check_capacity
    if !@event.nil?
      tickets = Ticket.where(event_id: self.event_id)
      if tickets.count >= @event.total_capacity
        errors.add(:event_id, "Event is already at capacity")
      end
    end
  end
end
