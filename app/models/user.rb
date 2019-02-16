class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  has_many :items
  has_many :creditcards
  has_many :favorite_items, dependent: :destroy
  has_one :profile
  has_many :sns_credentials
  has_many :point_records, dependent: :destroy
  has_many :order_statuses
  validates :nickname,               presence: true, length: { maximum: 20 }
  validates :password,               length: { maximum: 128 }
  validates :email,                  format: { with: /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/,
                                              message: 'のフォーマットが不適切です' }
  validates :password_confirmation,  presence: true
  validates :last_name,              presence: true, length: { maximum: 35 }
  validates :first_name,             presence: true, length: { maximum: 35 }
  validates :last_name_kana,         presence: true, length: { maximum: 35 },
                                     format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカナ文字で入力してください' }
  validates :first_name_kana,        presence: true, length: { maximum: 35 },
                                     format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカナ文字で入力してください' }
  validates :birth_y,                presence: true
  validates :birth_m,                presence: true
  validates :birth_d,                presence: true

  def self.years
   years = []
   for year in 1900..2019 do
     years << year
   end
   return years
  end

  def self.months
   months = []
   for month in 1..12 do
     months << month
   end
   return months
  end

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.find_by(uid: uid, provider: provider)
    if snscredential.present?
      user = User.find_by(id: snscredential.user_id)
    else
      user = User.find_by(email: auth.info.email)
      if user.present?
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
          )
      else
        user_info = [
          {nickname: auth.info.name},
          {email:    auth.info.email},
          {password: Devise.friendly_token[0, 20]}
        ]
      end
    end
    return user
  end
end
