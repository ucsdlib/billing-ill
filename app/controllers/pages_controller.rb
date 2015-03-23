class PagesController < ApplicationController

  def front
    flash[:alert] = ('You have been logged out of ILL BILLING. To logout of all Single Sign-On applications, close your browser or <a href="/Shibboleth.sso/Logout?return=https://a4.ucsd.edu/tritON/logout?target='+root_url+'">terminate your Shibboleth session</a>.').html_safe 
  end
end
