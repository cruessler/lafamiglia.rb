require_dependency 'lafamiglia'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter :authenticate_player!
  before_action :clock, if: -> { player_signed_in? }
  before_filter :check_for_villa!, if: -> { player_signed_in? }

  helper_method :current_villa

  include Consul::Controller

  current_power do
    Power.new(current_player)
  end

  def notify_dispatcher time
    begin
      Socket.unix(Dir.home + "/tmp/lafamiglia.sock") do |socket|
        socket << time.to_s
      end
    rescue Exception => _
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def check_for_villa!
    if current_villa.nil?
      render 'common/no_villa_left'
    end
  end

  def clock
    LaFamiglia.clock
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
        villa.process_until! LaFamiglia.now
      end

      villa
    end
  end
end
