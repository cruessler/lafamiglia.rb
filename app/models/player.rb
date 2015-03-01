class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :villas

  has_many :reports
  has_many :message_statuses
  has_many :messages, through: :message_statuses

  validates_presence_of :name
  validates_uniqueness_of :name

  def recalc_points!
    update_attribute :points, villas.sum(:points)
  end

  def to_s
    name
  end
end
