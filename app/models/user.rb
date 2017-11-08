class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  
  field :user_id, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password_digest, type: String

  validates :user_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  has_secure_password

  def to_token_payload
    hash = {
        "user_id" => self.user_id
    }
  end

  def self.from_token_payload payload
    self.where(user_id: payload["user_id"]);
  end

  def as_json(options = { })
    h = super(options)
    h.except!('password_digest')
    @events = Event.where(host_id: self.user_id)
    @reviews
    var_matched = 0
    var_prepped = 0
    var_ret = 0
    var_reviews = 0
    @events.each do |e|
      @reviews = Review.where(event_id: e.event_id)
      var_matched = var_matched + get_matched_desc
      var_prepped = var_prepped + get_host_prep
      var_ret = var_ret + get_would_ret
      var_reviews = @reviews.size
    end

    if var_reviews > 0
      h[:matched_desc] = (var_matched / var_reviews).round
      h[:host_prep] = (var_prepped / var_reviews).round
      h[:would_ret] = (var_ret / var_reviews * 100).round
    else
      h[:matched_desc] = nil
      h[:host_prep] = nil
      h[:would_ret] = nil
    end
    h
  end

  def get_matched_desc
    rating = 0
    @reviews.each do |v|
      rating = rating + v.matched_desc
    end
    rating
  end

  def get_host_prep
    rating = 0
    @reviews.each do |v|
      rating = rating + v.host_prep
    end
    rating
  end

  def get_would_ret
    rating = 0
    @reviews.each do |v|
      if v.would_ret
        rating = rating + 1
      end
    end
    rating
  end
end
