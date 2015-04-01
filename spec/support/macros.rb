def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).uid
end

def sign_out
  visit signout_path
end