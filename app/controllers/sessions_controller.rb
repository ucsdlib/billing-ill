#---
# @author hweng@ucsd.edu
#---

class SessionsController < ApplicationController
  def new
    if Rails.configuration.shibboleth
      redirect_to shibboleth_path
    else
      redirect_to developer_path
    end
  end

  def developer
    find_or_create_user('developer')
  end
  
  def shibboleth
    find_or_create_user('shibboleth')
  end

  def find_or_create_user(auth_type)
    if auth_type == 'shibboleth' 
      auth = request.env["omniauth.auth"]
      #raise request.env["omniauth.auth"].to_yaml

      if User.in_supergroup?(auth.uid)
        user = User.find_or_create_for_shibboleth(auth)
        create_user_session(user, auth_type)
      else
        render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
      end 
    elsif auth_type == 'developer'
      user = User.find_or_create_for_developer
      create_user_session(user, auth_type)
    end
  end

  def create_user_session(user, auth_type)
     session[:user_name] = user.full_name
     session[:user_id] = user.uid
      
     redirect_to root_url, notice: "You have successfully authenticated from #{auth_type} account!" if user
  end

  def destroy
    session[:user_id] = nil
    session[:user_name] = nil
    if Rails.configuration.shibboleth
      flash[:alert] = ('You have been logged out of ILL BILLING. To logout of all Single Sign-On applications, close your browser or <a href="/Shibboleth.sso/Logout?return=https://a4.ucsd.edu/tritON/logout?target='+root_url+'">terminate your Shibboleth session</a>.').html_safe 
    end

    redirect_to root_url
  end
end