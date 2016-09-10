class ApplicationController < ActionController::Base

	before_filter :set_i18n_locale_from_params
	before_filter :authorize

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

 private

 	def set_i18n_locale_from_params
 		if params[:lovale]
 			if In18n.available_locales.include?(params[:locale].to_sym)
 				I18n.locale = params[:locale]
 			else
 				flash.now[:notice] = "#{params[:locale]} translation not available"
 				logger.error flash.now[:notice]
 			end
 		end
 	end
 	

 	def current_cart
 		Cart.find(session[:cart_id])
 	rescue ActiveRecord::RecordNotFound
 		cart = Cart.create
 		session[:cart_id] = cart.id
 		cart
 	end

 	def authorize
 		unless User.find_by_id(session[:user_id])
 			redirect_to login_url, notice: "ログインしてください"
 		end
 	end
end
