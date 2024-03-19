# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  bio                    :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  pic                    :string
#  preferred_timezone     :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, uniqueness: true, presence: true 
  validates :email, uniqueness: true, presence: true
  validates :bio, presence: true

  enum preferred_timezone: { est:"EST", cst:"CST", mst:"MST", pst:"PST", akst:"AKST", hst:"HST" }
  # for Eastern Standard Time, Central Standard Time, Mountain Standard Time, Pacific Standard Time, Alaska Standard Time, and Hawaii-Aleutian Standard Time
  has_many :owned_programs, class_name: "Program", foreign_key: "owner_id"
  has_many :participations

  has_many :mentee_participations, -> { mentee }, foreign_key: :user_id, class_name: "Participation" 
  has_many :mentor_participations, -> { mentor }, foreign_key: :user_id, class_name: "Participation"
  has_many :admin_participations, -> { admin }, foreign_key: :user_id, class_name: "Participation"

  has_many :involved_programs, through: :participations, source: :program
end
