class Event
  include Mongoid::Document
  field :event_id, type: String
  field :name, type: String
  field :description, type: String
  field :time, type: DateTime
  field :location, type: String
  field :current_capacity, type: Integer
  field :total_capacity, type: Integer
  field :category, type: String
  field :host_id, type: String

  validates :event_id, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :time, presence: true
  validates :location, presence: true
  validates :current_capacity, presence: true
  validates :total_capacity, presence: true
  validates :category, presence: true
  validates :host_id, presence: true

  def as_json(options = { })
    h = super(options)
    h[:interest_rating] = get_interest_rating
    h
  end

  def get_interest_rating
    @votes = Vote.where(event_id: self.event_id)
    rating = 0
    @votes.each do |v|
      rating = rating + v.value
    end
    rating
  end
end
