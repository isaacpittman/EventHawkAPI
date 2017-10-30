class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  
  field :user_id, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :rating, type: Float
  
  has_secure_password

  def to_token_payload
    hash = {
        "user_id" => self.user_id
    }
  end

  def self.from_token_payload payload
    self.where(user_id: payload["user_id"]);
  end
end
