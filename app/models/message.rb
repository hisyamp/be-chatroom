class Message
    include Mongoid::Document
  
    field :content, type: String
    field :sender, type: String
    field :created_at, type: DateTime, default: -> { Time.now }
  
    embedded_in :chatroom
  
    validates :content, presence: true
  end
  