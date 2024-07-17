class User
  # has_secure_password
  include Mongoid::Document
  include Mongoid::Timestamps
  field :email, type: String
  field :password, type: String
  field :nama, type: String
  field :status, type: String
  validates :email, presence: true, uniqueness: true
  belongs_to :user_role, class_name: 'UserRole', foreign_key: 'user_role_id'
end
