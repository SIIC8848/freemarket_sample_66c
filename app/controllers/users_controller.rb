class UsersController < ApplicationController

  def index
    @products = Product.all
    @product = Product.new
    @users = User.all
    @user = User.new
  end

  def show
    @products = Product.all
    @product = Product.new
    @user = User.find(params[:id])
  end

  def edit
    @products = Product.all
    @product = Product.new
    @users = User.all
    @user = User.new
  end
  
end