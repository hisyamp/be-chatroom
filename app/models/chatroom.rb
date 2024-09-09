class Chatroom
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields for chatroom details
  field :name, type: String
  field :description, type: String

  embeds_many :messages

  validates :name, presence: true
end
