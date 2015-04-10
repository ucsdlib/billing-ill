class User < ActiveRecord::Base

  def self.find_or_create_for_shibboleth(access_token)
    begin
      uid = access_token.uid
      email = access_token['info']['email'] || "#{uid}@ucsd.edu"
      provider = access_token.provider
      name = access_token['info']['name'] 
      
    rescue Exception => e
      logger.warn "shibboleth: #{e.to_s}"
    end
    
    u = User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider, :email => email, :full_name => name)
  end
end