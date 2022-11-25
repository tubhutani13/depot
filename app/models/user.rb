class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  # Validates that the two passwords match in field
  has_secure_password

  ## Creating Transaction/Trigger that will rollback when last user deleted
  after_destroy :ensure_an_admin_remains
  before_destroy :ensure_not_admin
  before_update :ensure_not_admin
  after_create_commit :send_welcome_mail

  validates :email, uniqueness: true, format: { with: EMAIL_REGEX }

  private def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Cant't delete last user"
    end
  end

  def admin?
    email == ADMIN_EMAIL
  end

  private def ensure_not_admin
    if admin?
      errors.add(:base, 'Cannot update admin account')
      throw :abort
    end
  end

 private def send_welcome_mail
  UserMailer.welcome(self).deliver_now
 end
end
