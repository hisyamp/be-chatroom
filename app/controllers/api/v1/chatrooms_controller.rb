module Api
    module V1
      class ChatroomsController < ApplicationController
        # GET /api/v1/chatrooms
        def index
          chatrooms = Chatroom.all
          render json: chatrooms
        end
  
        # GET /api/v1/chatrooms/:id
        def show
          chatroom = Chatroom.find(params[:id])
          render json: chatroom
        end
  
        # POST /api/v1/chatrooms
        def create
          chatroom = Chatroom.new(chatroom_params)
          if chatroom.save
            render json: chatroom, status: :created
          else
            render json: chatroom.errors, status: :unprocessable_entity
          end
        end
  
        # PATCH/PUT /api/v1/chatrooms/:id
        def update
          chatroom = Chatroom.find(params[:id])
          if chatroom.update(chatroom_params)
            render json: chatroom
          else
            render json: chatroom.errors, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/chatrooms/:id
        def destroy
          chatroom = Chatroom.find(params[:id])
          chatroom.destroy
          head :no_content
        end
  
        private
  
        def chatroom_params
          params.require(:chatroom).permit(:name, :description)
        end
      end
    end
  end
  