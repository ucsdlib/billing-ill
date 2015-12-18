# encoding: utf-8
#---
# @author hweng@ucsd.edu
#---

require 'spec_helper'

describe AppMailer do
  describe "send_recharge_email" do
    before(:each) do
      @user = Fabricate(:user)
      @email_date = Time.zone.now
      @file_name = Recharge.create_file
      @record_count = Recharge.search_all_pending_status.size + 2
    end
    
    let(:email) {AppMailer.send_recharge_email(@user, @email_date)}
    
    it 'renders the subject' do
      expect(email.subject).to eql("ILL Billing Recharge File")
    end
    
    it 'renders the receiver email' do
      expect(email.to).to eql(["#{@user.email}"])
    end
    
    it 'renders the sender email' do
      expect(email.from).to eql([@user.email])
    end
   
    it 'assigns email date' do
      expect(email.body.encoded).to match("#{@email_date}")
    end 

    it 'assigns Input File Name' do
      expect(email.body.encoded).to match("#{@file_name}")
    end  

    it 'assigns Record Count' do
      expect(email.body.encoded).to match("#{@record_count}")
    end 
  end        

  describe "send_invoice_email" do
    before(:each) do
      @user = Fabricate(:user)
      @email_date = Time.zone.now
      @charge_count = Invoice.search_all_pending_status.size + 2
      @charge_file = Invoice.charge_file_name
      @lcharge_file = Invoice.charge_lfile_name
    end
    
    let(:email) {AppMailer.send_invoice_email(@user, @email_date)}
    
    it 'renders the subject' do
      expect(email.subject).to eql("ILL Billing Invoice File")
    end
    
    it 'renders the receiver email' do
      expect(email.to).to eql(["#{@user.email}"])
    end
    
    it 'renders the sender email' do
      expect(email.from).to eql([@user.email])
    end
   
    it 'assigns email date' do
      expect(email.body.encoded).to match("#{@email_date}")
    end 

    it 'assigns charge_file name' do
      expect(email.body.encoded).to match("#{@charge_file}")
    end 

    it 'assigns lcharge_file name' do
      expect(email.body.encoded).to match("#{@lcharge_file}")
    end   

    it 'assigns charge count' do
      expect(email.body.encoded).to match("#{@charge_count}")
    end 
  end        
end
