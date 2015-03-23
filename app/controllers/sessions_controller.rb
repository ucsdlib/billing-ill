class SessionsController < ApplicationController
  def create
    #raise request.env["omniauth.auth"].to_yaml

    auth = request.env["omniauth.auth"]
    user = User.find_or_create_for_shibboleth(auth)
    session[:user_name] = user.full_name
    session[:user_id] = user.uid
    
    redirect_to root_url, :notice => "You have successfully authenticated from Shibboleth account!" if user
  end

  def destroy
    session[:user_id] = nil
    session[:user_name] = nil
    flash[:alert] = ('You have been logged out of ILL BILLING. To logout of all Single Sign-On applications, close your browser or <a href="/Shibboleth.sso/Logout?return=https://a4.ucsd.edu/tritON/logout?target='+root_url+'">terminate your Shibboleth session</a>.').html_safe 

    redirect_to root_url
  end
end