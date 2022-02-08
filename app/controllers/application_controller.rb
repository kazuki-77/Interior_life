class ApplicationController < ActionController::Base
  # devise機能を使う前にconfigure_permitted_parametersが実行される
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # sign_upの際に、nameのデータ操作が許可される
    devise_parameter_sanitizer.permit(:sign_up,keys: [:email])
  end
end
