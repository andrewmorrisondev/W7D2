class User < ApplicationRecord
  validates :email, :session_token, presence: true
  validates :password_digest, presence: true

  validates :password, length: { minimum: 6 }, allow_nil: true
  
  before_validation :ensure_session_token
  
  attr_reader :password
  
  def generate_unique_session_token
    # debugger
    token = SecureRandom::urlsafe_base64
    while User.exists?(session_token: token)
      token = SecureRandom::urlsafe_base64
    end
    token
  end

  def reset_session_token!
    # debugger
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    # debugger
    self.session_token ||= generate_unique_session_token
  end

  def password=(password)
    # debugger
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def is_password?(password)
    # debugger
    bcrypt_obj = BCrypt::Password.new(self.password_digest)
    bcrypt_obj.is_password?(password)
  end

  def self.find_by_credentials(email, password)
    # debugger
    user = User.find_by(email: email)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end

end
