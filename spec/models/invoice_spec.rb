#---
# @author hweng@ucsd.edu
#---

require 'spec_helper'

describe Invoice do 
  include MoneyRails::TestHelpers

  it {expect(monetize(:charge_cents)).to be_truthy}
  
  it {should belong_to(:patron)}
  it {should validate_presence_of(:comments)}
  it {should validate_presence_of(:number_prints)}
  it {should validate_presence_of(:invoice_type)}
  it {should validate_presence_of(:status)}
  it {should validate_presence_of(:patron_id)}
  it {should validate_numericality_of(:charge)}

  it {should validate_uniqueness_of(:invoice_num)}

  it {should delegate_method(:patron_name).to(:patron).as(:name)}
  it {should delegate_method(:patron_ar_code).to(:patron).as(:ar_code)}
  it {should delegate_method(:patron_address1).to(:patron).as(:address1)}
  it {should delegate_method(:patron_address2).to(:patron).as(:address2)}
  it {should delegate_method(:patron_address3).to(:patron).as(:address3)}
  it {should delegate_method(:patron_address4).to(:patron).as(:address4)}
  it {should delegate_method(:patron_city).to(:patron).as(:city)}
  it {should delegate_method(:patron_state).to(:patron).as(:state)}
  it {should delegate_method(:patron_zip1).to(:patron).as(:zip1)}
  it {should delegate_method(:patron_zip2).to(:patron).as(:zip2)}
  it {should delegate_method(:patron_country_code).to(:patron).as(:country_code)}
end

  describe "search_by_patron_name" do
    before do
        patron = Fabricate(:patron, id: 1, name: "Joe Doe")
        @invoice1 = Fabricate(:invoice, patron_id: 1, invoice_num: "50002" )
        @invoice2 = Fabricate(:invoice, patron_id: 1, invoice_num: "50003")
    end
    
    it "returns an array of all matches ordered by created_at" do
      expect(Invoice.search_by_patron_name("Joe Doe")).to eq([@invoice2,@invoice1])
    end

    it "returns an empty array if there is no match" do
      expect(Invoice.search_by_patron_name("alice")).to eq([])
    end

    it "returns an empty array for a search with an empty string" do
      expect(Invoice.search_by_patron_name("")).to eq([])
    end
  end

  describe "search_by_invoice_num" do
    before do
        @invoice = Fabricate(:invoice, invoice_num: "50002")
    end
    
    it "returns an array of all matches" do
      expect(Invoice.search_by_invoice_num("50002")).to eq([@invoice])
    end

    it "returns an empty array if there is no match" do
      expect(Invoice.search_by_invoice_num("50000")).to eq([])
    end

    it "returns an empty array for a search with an empty string" do
      expect(Invoice.search_by_invoice_num("")).to eq([])
    end
  end

  describe "convert_to_julian_date" do
    it "returns a julian day format for today's date" do
      j_today = Date.today.strftime("%y") + Date.today.yday.to_s
      expect(Invoice.convert_to_julian_date).to eq(j_today)
    end
  end

  describe "charge_file_name" do
    it "returns required charge file name convention" do
      file_name = "SISP.ARD2501.LIBBUS.CHARGE.D" + Invoice.convert_to_julian_date
      expect(Invoice.charge_file_name).to eq(file_name)
    end
  end

  describe "entity_file_name" do
    it "returns required entity file name convention" do
      file_name = "SISP.ARD2501.LIBBUS.ENTITY.D" + Invoice.convert_to_julian_date
      expect(Invoice.entity_file_name).to eq(file_name)
    end
  end

  describe "person_file_name" do
    it "returns required person file name convention" do
      file_name = "SISP.ARD2501.LIBBUS.PERSON.D" + Invoice.convert_to_julian_date
      expect(Invoice.person_file_name).to eq(file_name)
    end
  end

  describe "charge_lfile_name" do
    it "returns required local charge file name convention" do
      file_name = "CHARGE.D" + Invoice.convert_to_julian_date + ".TXT"
      expect(Invoice.charge_lfile_name).to eq(file_name)
    end
  end

  describe "entity_lfile_name" do
    it "returns required local entity file name convention" do
      file_name = "ENTITY.D" + Invoice.convert_to_julian_date + ".TXT"
      expect(Invoice.entity_lfile_name).to eq(file_name)
    end
  end

  describe "person_lfile_name" do
    it "returns required local person file name convention" do
      file_name = "PERSON.D" + Invoice.convert_to_julian_date + ".TXT"
      expect(Invoice.person_lfile_name).to eq(file_name)
    end
  end

  describe "charge_output" do
    it "gets charge output" do
      patron = Fabricate(:patron, ar_code: "A23456789")
      invoice = Fabricate(:invoice, status: "pending", charge: 4.00, invoice_num: "50001", patron: patron)
      t_date = Time.now.strftime("%m%d%y")

      header_row = "CHDR CLIBRARY.CHARGE " + t_date + " " + t_date + " 000001" + " " * 279
      detail_rows = "A" + patron.ar_code + " " * 35 + "LIBLPS" + "0000000040{" + " " * 6
      detail_rows += "     50001" + " " * 240
      final_rows = "CTRL " + "000003" + " " + "0000000040{" + " " * 297
      
      content = "#{header_row}\n#{detail_rows}\n#{final_rows}"

      expect(Invoice.charge_output).to eq(content)
    end
  end

  describe "person_output" do
    it "gets person output" do
      patron = Fabricate(:patron, ar_code: "A23456789", name: "john", address1: "ABC Street", city:"Dream", state: "CA", zip1: "12345" )
      invoice = Fabricate(:invoice, status: "pending", charge: 4.00, invoice_num: "50001", patron: patron)
      t_date = Time.now.strftime("%m%d%y")
      address = "ABC Street" + " " * 25 +  " " * 105 + "Dream" + " " * 13 + "CA" + "12345" + " " * 4 + " " * 2 + " " * 30

      header_row = "PHDR CLIBRARY.PERSON "+ t_date + " " + t_date + " 000001" + " " * 279
      detail_rows = "C" + " " * 9 + patron.ar_code + " " * 4 + "john" + " " * 31 + "john" + " " * 51 + " " * 6
      detail_rows += address
      final_rows = "PTRL " + "000003" + " " * 309
      
      content = "#{header_row}\n#{detail_rows}\n#{final_rows}"

      expect(Invoice.person_output).to eq(content)
    end
  end

  describe "entity_output" do
    it "gets entity output" do
      patron = Fabricate(:patron, ar_code: "AA3456789", name: "Excl", address1: "ABC Street", city:"Dream", state: "CA", zip1: "12345" )
      invoice = Fabricate(:invoice, status: "pending", charge: 4.00, invoice_num: "50001", patron: patron)
      t_date = Time.now.strftime("%m%d%y")
      address = "ABC Street" + " " * 25 +  " " * 105 + "Dream" + " " * 13 + "CA" + "12345" + " " * 4 + " " * 2 + " " * 30

      header_row = "EHDR CLIBRARY.ENTITY " + t_date + " " + t_date + " " * 286
      detail_rows = "C" + "PUBLPUBL" + " " * 9 + patron.ar_code + "Excl" + " " * 31 + "Excl" + " " * 51 + " " * 2
      detail_rows += address
      final_rows = "ETRL " + "000003" + " " * 309
      
      content = "#{header_row}\n#{detail_rows}\n#{final_rows}"

      expect(Invoice.entity_output).to eq(content)
    end
  end

  describe "create_entity_file" do
     it "returns entity file name" do
      file_name = "SISP.ARD2501.LIBBUS.ENTITY.D" + Invoice.convert_to_julian_date
      expect(Invoice.create_entity_file).to eq(file_name)
    end
  end

  describe "create_person_file" do
     it "returns person file name" do
      file_name = "SISP.ARD2501.LIBBUS.PERSON.D" + Invoice.convert_to_julian_date
      expect(Invoice.create_person_file).to eq(file_name)
    end
  end

  describe "create_charge_file" do
     it "returns charge file name" do
      file_name = "SISP.ARD2501.LIBBUS.CHARGE.D" + Invoice.convert_to_julian_date
      expect(Invoice.create_charge_file).to eq(file_name)
    end
  end

  describe "send_file" do
    it "successfully sends file" do

      session_mock = double("a new session")
      connect_mock = double("sftp connection")
      upload_mock = double("sftp upload")
      
      expect(Rails.application.secrets).to receive(:sftp_folder).and_return("sftp_folder")
      expect(Rails.application.secrets).to receive(:sftp_server_name).and_return("sftp_server_name")
      expect(Rails.application.secrets).to receive(:sftp_user).and_return("sftp_user")
      expect(Rails.application.secrets).to receive(:sftp_password).and_return("sftp_password")
      expect(Net::SSH).to receive(:start).with("sftp_server_name", "sftp_user", :password=> "sftp_password").and_return(session_mock)
      expect(Net::SFTP::Session).to receive(:new).with(session_mock).and_return(connect_mock)
      expect(connect_mock).to receive(:connect!).and_return(upload_mock)
      expect(upload_mock).to receive(:upload!)
      expect(upload_mock).to receive(:upload!)
      expect(upload_mock).to receive(:upload!)

      Invoice.send_file
    end 
  end

  