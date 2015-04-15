#---
# @author hweng@ucsd.edu
#---
require 'net/ldap'

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

  def self.in_supergroup?(uid)
    #super_group = Rails.application.secrets.super_group
    #s = super_group.include?(token)
    lookup_group(uid) == "hweng" ? true : false
  end
  
  def self.lookup_group(search_param)
    result = ""
    ldap = Net::LDAP.new  :host => "ldap.ad.ucsd.edu", 
                          :port => "636", 
                          :encryption => :simple_tls,
                          :base => "OU=University Library,DC=AD,DC=UCSD,DC=EDU", 
                          :auth => {
                            :method => :simple,
                            :username => "lib-LDAP@ad.ucsd.edu", 
                            :password => "Roow1pee" #replace with the var from scerets.yml
                      }

    result_attrs = ["sAMAccountName"]
    
    search_param = "weng"  # to change "hweng" to parsing param
    search_filter = Net::LDAP::Filter.eq("sAMAccountName", search_param)
    category_filter = Net::LDAP::Filter.eq("objectcategory", "user")
    composite_filter = Net::LDAP::Filter.join(search_filter, category_filter)

    ldap.search(:filter => composite_filter, :attributes => result_attrs, :return_result => false) { |item| 
       result = item.sAMAccountName.first}

    get_ldap_response(ldap)

    return result
  end

  def self.get_ldap_response(ldap)
    msg = "Response Code: #{ ldap.get_operation_result.code }, Message: #{ ldap.get_operation_result.message }"
   
    raise msg unless ldap.get_operation_result.code == 0
  end
end