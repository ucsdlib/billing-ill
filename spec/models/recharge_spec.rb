#---
# @author hweng@ucsd.edu
#---

require 'spec_helper'

describe Recharge do 
  include MoneyRails::TestHelpers
  
  #it {monetize(:charge_cents)}
  it {expect(monetize(:charge_cents)).to be_truthy}
  
  it {should belong_to(:fund)}
  it {should validate_presence_of(:number_copies)}
  it {should validate_presence_of(:status)}
  it {should validate_presence_of(:fund_id)}
  it {should validate_numericality_of(:charge)}

  it {should delegate_method(:fund_org_code).to(:fund).as(:org_code)}
  it {should delegate_method(:fund_index_code).to(:fund).as(:index_code)}
  it {should delegate_method(:fund_fund_code).to(:fund).as(:fund_code)}
  it {should delegate_method(:fund_program_code).to(:fund).as(:program_code)}

  # it do
  #   should allow_value('5', '5.0', '5.00', '0.5', '0.50').
  #     for(:charge)
  # end
end

  describe "search_by_index_code" do
    before do
        fund = Fabricate(:fund, id: 1, index_code: "ANSVAMC")
        @recharge1 = Fabricate(:recharge, fund_id: 1 )
        @recharge2 = Fabricate(:recharge, fund_id: 1)
    end
    
    it "returns an array of all matches ordered by created_at" do
      expect(Recharge.search_by_index_code("ANSVAMC")).to eq([@recharge2,@recharge1])
    end

    it "returns an empty array if there is no match" do
      expect(Recharge.search_by_index_code("BB")).to eq([])
    end

    it "returns an empty array for a search with an empty string" do
      expect(Recharge.search_by_index_code("")).to eq([])
    end
  end

  describe "search_all_pending_status" do
    it "returns an array of all matches ordered by created_at" do
      @recharge1 = Fabricate(:recharge, status: "pending")
      @recharge2 = Fabricate(:recharge, status: "pending")
      expect(Recharge.search_all_pending_status).to eq([@recharge2,@recharge1])
    end

    it "returns an empty array if there is no match" do
      expect(Recharge.search_all_pending_status).to eq([])
    end
  end

  describe "pending_status_count" do
    it "returns an count of total pending status" do
      @recharge1 = Fabricate(:recharge, status: "pending")
      @recharge2 = Fabricate(:recharge, status: "pending")
      expect(Recharge.pending_status_count).to eq(2)
    end
  end

  describe "process_output" do
    it "process the output file according to the rules" do
      fund = Fabricate(:fund, program_code: "400000", org_code: "414909", index_code: "ANSVAMCCCC", fund_code: "60200A")
      recharge = Fabricate(:recharge, status: "pending", charge: 3.50, fund: fund)
      
      header_row = "LIBRARY101FRLBG5511LIBRARY RECHARGES"+ " " * 18 + Time.zone.now.strftime("%Y%m%d")+"000000000700" + "N" + " " * 175
      detail_rows = "LIBRARY101FRLBG5512" + "0001F510" + "000000000350"+"LIBRARY-PHOTOCOPY SERVICE" + " " * 10 + "DA"+"60200A414909"
      detail_rows += "636064" + "400000" + " " * 12 + "ANSVAMCCCC" + " " * 32 + "000000" + " " * 17 + "000000" + " " * 10 + "00000000" + " " * 8
      detail_rows += Time.zone.now.strftime("%Y%m%d") + " " * 3 
      final_rows = "LIBRARY101FRLBG5512" + "0002F510" +"000000000350" + "LIBRARY-PHOTOCOPY SERVICE" + " " * 10 + "CA"
      final_rows += " " * 12 + "693900" + " " * 18 + "   LIBIL05" + " " * 32 + "000000" + " " * 17 + "000000" + " " * 10 + "00000000" + " " * 8
      final_rows += Time.zone.now.strftime("%Y%m%d") + " " * 2 + " "
      content = "#{header_row}\n#{detail_rows}\n#{final_rows}"

      expect(Recharge.process_output).to eq(content)
    end
  end

  describe "create_file" do
    it "returns file name" do
      file_name = "FISP.JVDATA.D" + Recharge.convert_date_yymmdd(Time.zone.now) + ".LIB"
      expect(Recharge.create_file).to eq(file_name)
    end
  end

  describe "convert_seq_num" do
    it "returns seq_num in required format" do
      expect(Recharge.convert_seq_num("1")).to eq("0001")
    end
  end

  describe "convert_charge" do
    it "returns charge in required format" do
      expect(Recharge.convert_charge(0.50)).to eq("000000000050")
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

      Recharge.send_file
    end 
  end
