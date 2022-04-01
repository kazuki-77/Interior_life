# frozen_string_literal: true

class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    # 相手のuser情報を取得
    @user = User.find(params[:id])
    # current_userのuser_roomにあるroom_idの値をpluckメソッドを使い配列で取得し、代入する。
    room_ids = current_user.user_rooms.pluck(:room_id)
    # user_roomモデルから、user_idが相手のidが一致するものと、room_idがroomsのどれかに一致するレコードをuser_roomsに代入
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: room_ids)
    # もしuser_roomでルームが存在していなかったら
    if user_rooms.nil?
      @room = Room.new
      @room.save
      # 作成したroomのidを使い、user_roomのレコードを2人分作る
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    else
      # user_roomsに紐づくroomsテーブルのレコードを@roomに格納
      @room = user_rooms.room
    end
    # roomに紐づくchatsテーブルのレコードを@chatsに格納
    @chats = @room.chats
    # form_withでチャットを送信する際に必要な空のインスタンス
    # room.idを@chatに代入しないとform_withで記述するroom_idに値が渡らない
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    # redirect_to request.referer
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
end
