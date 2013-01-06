class V1::UsersController < ApplicationController
  before_filter :authenticate, except: :create

  def index
    #logs the user in using `before_filter`
    render json: {status: 200, message: 'successfully authenticated', user: current_user}, callback: params[:callback]
  end

  def create
    user = User.new(params[:user])
    begin user.save!
      #TODO: log user in if possible, maybe set session[:user_id] manually
      @response = {status: 201, message: 'successfully created user', user: user}
    rescue ActiveRecord::RecordInvalid
      @response = {status: 400, message: $!.to_s, user: user}
    else
      @response = {status: 400, message: $!.to_s}
    ensure
      render json: @response, callback: params[:callback]
    end
  end

end
