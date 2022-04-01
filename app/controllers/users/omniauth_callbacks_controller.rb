# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
  def twitter
    authorization
  end

  def google_oauth2
    callback_for(:google)
  end

  def callback_for(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navgational_format?
  end

  def failure
    redirect_to root_path
  end

  private

  def authorization
    sns_info = User.from_omniauth(request.env["omniauth.auth"])
    # byebug
    # @user と @sns_id を追加
    @user = sns_info[:user]

    if @user.persisted? #ユーザー情報が登録済みなので、新規登録ではなくログイン処理を行う
      sign_in_and_redirect @user, event: :authentication
    else #ユーザー情報が未登録なので、新規登録画面へ遷移する
      # @sns_id = sns_info[:sns].id
      # render template: 'devise/registrations/new'
      access_token = request.env["omniauth.auth"]["extra"]["access_token"]
      # twitterのidを取ってきて、ユーザーネームに格納する
      @user.name = access_token.params[:screen_name]
      # ダミーのemailを作成し、ユーザーのemailに格納する
      @user.email = "#{access_token.params[:user_id]}-#{request.env["omniauth.auth"].provider}@example.com"
      # 20桁のランダムな数字を生成し、ユーザーのパスワードに格納する
      @user.password = Devise.friendly_token[0, 20]
      @user.save!
      sign_in_and_redirect @user, event: :authentication
    end
  end
end
