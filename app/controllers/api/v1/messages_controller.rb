class Api::V1::MessagesController < ApplicationController
  before_action :set_chatroom

  # GET /api/v1/chatrooms/:chatroom_id/messages
  def index
    messages = @chatroom.messages
    render json: messages
  end

  # POST /api/v1/chatrooms/:chatroom_id/messages
  def create
    message = @chatroom.messages.new(message_params)

    if message.save
      # Fetch all messages in the chatroom after a successful message save
      messages = @chatroom.messages
      # Optionally, you can send the messages to a WebSocket or Socket.IO server here

      # Return all messages related to the chatroom
      render json: { chatroom_id: @chatroom.id, messages: messages }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/chatrooms/:chatroom_id/messages/:id
  def show
    message = @chatroom.messages.find(params[:id])
    render json: message
  end

  # PATCH/PUT /api/v1/chatrooms/:chatroom_id/messages/:id
  def update
    message = @chatroom.messages.find(params[:id])

    if message.update(message_params)
      render json: message
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/chatrooms/:chatroom_id/messages/:id
  def destroy
    message = @chatroom.messages.find(params[:id])
    message.destroy
    head :no_content
  end

  private

  # Find the chatroom based on chatroom_id
  def set_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: 'Chatroom not found' }, status: :not_found
  end

  # Strong parameters for message creation and update
  def message_params
    params.require(:message).permit(:content, :sender)
  end
end
