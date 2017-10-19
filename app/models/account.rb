class Account < ActiveRecord::Base
    # Non-persistent attributes
    attr_accessor :remember_token
    # Account validation context
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    before_create :confirmation_token
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
    end
    
    def activate
      self.confirmed = true
      self.token = nil
      save!(:validate => false)
    end
    
    def remember
      self.remember_token = SecureRandom.urlsafe_base64
      update_attribute(:remember_digest, Account.digest(remember_token))
    end
    
    def forget
      update_attribute(:remember_digest, nil)
    end
    
    def authenticated?(remember_token)
      return false if remember_digest.nil?
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    private

    def validate_age
      if birthdate.present? && birthdate.to_date > 18.years.ago.to_date
          errors.add(:birthdate, 'You must be 18 or older')
      end
    end
    
    def confirmation_token
      if self.token.blank?
          self.token = SecureRandom.urlsafe_base64.to_s
      end
    end
    
end
