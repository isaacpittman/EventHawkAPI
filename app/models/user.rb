class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  store_in collection: "users"

  field :user_id, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :is_active, type: Boolean

  validates :user_id, presence: true
  validates :first_name, presence: true, allow_blank: false, length: { in: 1..30 }
  validates :last_name, presence: true, allow_blank: false, length: { in: 1..30 }
  validates :email, presence: true
  validates_format_of :first_name, :last_name, :with => /\A[a-z]+\z/i

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
  end
end
