class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_or_errors
    return if user_signed_in?
    user_params = if params[:user].present? then user_strong_params else {email: ''} end
    u = User.find_by(email: user_params[:email].downcase)
    if u.blank?
      u = User.new(user_params)
      return u.errors unless u.save
    else
      unless u.valid_password? user_params[:password]
        u.errors[:password] << "is incorrect"
        return u.errors
      end
    end
    sign_in u
    return u.errors
  end

  def merge_errors target, errors, prefix=nil
    target.valid?
    errors.each do |attribute, message|
      key = prefix.present? ? "#{prefix}.#{attribute}" : attribute
      target.errors[key] << message
    end
  end


  def user_strong_params
    params.require(:user).permit(:email, :password)
  end

end
