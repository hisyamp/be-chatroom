class Chatroom
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :code, type: String
  field :description, type: String
  field :created_by, type: String

  embeds_many :messages

  validates :name, presence: true
end
