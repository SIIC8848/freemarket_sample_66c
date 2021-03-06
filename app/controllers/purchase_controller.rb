class PurchaseController < ApplicationController
  require 'payjp'

  def index
    @product = Product.find(params[:id])
    card = Card.where(user_id: current_user.id).first
    #Cardテーブルは前回記事で作成、テーブルからpayjpの顧客IDを検索
    if card.blank?
      #登録された情報がない場合にカード登録画面に移動
      redirect_to "/cards/new"
    else
      Payjp.api_key = Rails.application.credentials.payjp[:payjp_secret_key]
      #保管した顧客IDでpayjpから情報取得
      customer = Payjp::Customer.retrieve(card.customer_id)
      #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end

  def pay
    @product = Product.find(params[:id])
    if user_signed_in?
      if @product.buyer_id.blank?
        product = Product.find(params[:id])
        card = Card.where(user_id: current_user.id).first
        Payjp.api_key = Rails.application.credentials.payjp[:payjp_secret_key]
        Payjp::Charge.create(
        :amount => product.price, #支払金額を入力(productテーブルから引っ張ってくる)
        :customer => card.customer_id, #顧客ID
        :currency => 'jpy', #日本円
      )
        @product.update(buyer_id: current_user.id)
        redirect_to action: 'done' #完了画面に移動
      else
        redirect_to root_path
      end
    else
      redirect_to new_user_session_path
    end
  end

  def done
    @product = Product.find(params[:id])
  end
end