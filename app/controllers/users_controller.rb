class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :update

  def new
    redirect_to join_path if user_exists?
  end

  def show
    redirect_to new_user_path unless user_exists?

    @user = User.find_by name: session[:user_name]
  end

  def create
    name = generate_name
    name = generate_name while User.exists? name: name

    User.create! name: name
    session[:user_name] = name
    redirect_to join_path
  end

  private

  def generate_name
    "#{Faker::Hacker.adjective}#{Faker::Food.ingredient}".delete(' ')
  end

  def user_exists?
    User.exists? name: session[:user_name]
  end
end
