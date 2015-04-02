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

  # dummy auth for developer environment
  def self.find_or_create_for_developer
     uid = 1
     email = "developer@ucsd.edu"
     provider = "developer"
     name = "DEVELOPER"
    
    u = User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider, :email => email, :full_name => name)
  end

  def self.in_supergroup?(token)
    super_group = Rails.application.secrets.super_group
    s = super_group.include?(token)
  end
end