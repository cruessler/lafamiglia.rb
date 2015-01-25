class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :villas
  has_many :message_statuses
  has_many :messages, through: :message_statuses

  def to_s
    name || "player #{id}"
  end
end
