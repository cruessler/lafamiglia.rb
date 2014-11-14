class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_player!
  before_filter :check_for_villa!, if: -> { player_signed_in? }

  helper_method :current_villa

  include Consul::Controller

  current_power do
    Power.new(current_player)
  end

  private

  def check_for_villa!
    if current_villa.nil?
      render 'common/no_villa_left'
    end
  end

  def current_villa
    @current_villa ||= begin
      villa = current_player.villas.where(id: session[:current_villa]).first

      if villa.nil?
        villa = current_player.villas.first

        if villa.nil?
          villa = Villa.create_for(current_player)
        end
      end

      unless villa.nil?
        session[:current_villa] = villa.id
      end

      villa
    end
  end
end
