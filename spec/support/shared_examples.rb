shared_examples "requires sign in" do
  it "redirects to the sign in path" do
    session[:user_id] = nil
    session[:user_name] = nil
    action
    expect(response).to redirect_to signin_path  
  end
end