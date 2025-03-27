class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Role validation
  ROLES = %w[sales manager superadmin].freeze
  validates :role, inclusion: { in: ROLES }

  # Association
  has_many :leads

  # Define role methods
  def sales?
    role == 'sales'
  end

  def manager?
    role == 'manager'
  end

  def superadmin?
    role == 'superadmin'
  end

  # Redirect after sign in (customize redirection path)
  def after_sign_in_path_for(resource)
    dashboard_path  # Redirect to dashboard after login
  end
end