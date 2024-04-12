# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  bio                    :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  preferred_timezone     :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
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

  validates :first_name, presence: true 
  validates :last_name, presence: true
  validates :email, uniqueness: true, presence: true
  validates :bio, presence: true
  validates :preferred_timezone, presence: true 

  has_one_attached :profile_picture

  enum preferred_timezone: { EST:"EST", CST:"CST", MST:"MST", PST:"PST", AKST:"AKST", HST:"HST" }
  # for Eastern Standard Time, Central Standard Time, Mountain Standard Time, Pacific Standard Time, Alaska Standard Time, and Hawaii-Aleutian Standard Time
  has_many :owned_programs, class_name: "Program", foreign_key: "owner_id"
  has_many :participations, dependent: :destroy

  has_many :mentee_participations, -> { mentee }, foreign_key: :user_id, class_name: "Participation" 
  has_many :mentor_participations, -> { mentor }, foreign_key: :user_id, class_name: "Participation"
  has_many :admin_participations, -> { admin }, foreign_key: :user_id, class_name: "Participation"

  has_many :involved_programs, through: :participations, source: :program

  has_many :pairings_as_mentees, through: :mentee_participations
  has_many :pairings_as_mentors, through: :mentor_participations
  # scoped associations seems to have same effect as using just participations since it's naturally limited by the source

  has_many :rankings, through: :mentee_participations
  has_many :received_rankings, through: :mentor_participations
end
