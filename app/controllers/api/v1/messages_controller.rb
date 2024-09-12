require 'net/http'

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

      # Hit the external API after successfully saving the message
      emit_event_to_socket_server(@chatroom.id, messages)

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

  def set_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: 'Chatroom not found' }, status: :not_found
  end

  def message_params
    params.require(:message).permit(:content, :sender)
  end

  def emit_event_to_socket_server(chatroom_id, messages)
    uri = URI('http://13.250.107.199:4000/emit-event')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = { chatroom_id: chatroom_id, messages: messages }.to_json
    response = http.request(request)
    Rails.logger.info("Emit Event Response: #{response.body}")
  end
end