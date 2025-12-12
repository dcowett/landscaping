class User < ApplicationRecord
  acts_as_tagger
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  has_many :pins
  has_many :stories
  has_many :votes
end
