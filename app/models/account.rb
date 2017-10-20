class Account < ActiveRecord::Base
    # Non-persistent attributes
    attr_accessor :remember_token, :activation_token
    # Account validation context
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    before_create :create_activation_digest
    before_save { self.email = email.downcase }
    validates :first_name, :last_name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, 
        length: { maximum: 255 },
        uniqueness: { case_sensitive: false },
        format: { with: VALID_EMAIL_REGEX }
    validates :phone, presence: true, phone: {possible: true}
    validates :birthdate, presence: true
    validate :validate_age
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
    
    # Static methods
    class << self
      def digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end
      
      def new_token
        SecureRandom.urlsafe_base64
      end
    end
    
    def activate
      update_attribute(:activated, true)
      update_attribute(:activated_at, Time.zone.now)
    end
    
    def send_activation_email
      AccountMailer.registration_confirmation(self).deliver_now
    end
    
    def remember
      self.remember_token = Account.new_token
      update_attribute(:remember_digest, Account.digest(remember_token))
    end
    
    def forget
      update_attribute(:remember_digest, nil)
    end
    
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end
    
    private

    def validate_age
      if birthdate.present? && birthdate.to_date > 18.years.ago.to_date
          errors.add(:birthdate, 'You must be 18 or older')
      end
    end
    
    def create_activation_digest
      self.activation_token  = Account.new_token
      self.activation_digest = Account.digest(activation_token)
    end
    
end
