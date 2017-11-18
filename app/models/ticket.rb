class Ticket
  include Mongoid::Document
  store_in collection: "tickets"

  field :ticket_id, type: String
  field :attendee_id, type: String
  field :event_id, type: String
  field :attending, type: Boolean
  field :is_active, type: Boolean

  validates :ticket_id, presence: true
  validates :attendee_id, presence: true
  validates :event_id, presence: true
  validates :attending, presence: true
  validates :is_active, presence: true
end
