# encoding: utf-8
#---
# @author hweng@ucsd.edu
#---

class Recharge < ActiveRecord::Base
  belongs_to :fund

  monetize :charge_cents, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1_000_000
  }

  # validates :charge, presence: true, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }, numericality: {greater_than: 0, less_than: 1000000}

  validates :number_copies, presence: true
  validates :status, presence: true
  validates :fund_id, presence: true
  validates :document_num, presence: true

  delegate :org_code, to: :fund, prefix: :fund
  delegate :index_code, to: :fund, prefix: :fund
  delegate :fund_code, to: :fund, prefix: :fund
  delegate :program_code, to: :fund, prefix: :fund

  def self.search_by_index_code(search_term)
    return [] if search_term.blank?

    if !Fund.find_by(index_code: search_term).nil?
      fund_id = Fund.find_by(index_code: search_term)
      where('fund_id = ? ', fund_id).order('created_at DESC')
    else
      []
    end
  end

  # def self.search_by_ID(search_term)
  #   return [] if search_term.blank?

  #   where("fund_id = ? ", search_term).order("created_at DESC")
  # end

  def self.search_all_pending_status
    where(status: 'pending').order('created_at DESC')
  end

  def self.pending_status_count
    search_all_pending_status.count
  end

  def self.page_count; end

  ##
  # Handles mapping for RECHARGE output file
  #

  def self.total_charge
    result_arr = search_all_pending_status
    total_charge = 0

    result_arr.each_with_index do |v, _i|
      charge = v.charge
      total_charge += charge
    end
    total_charge
  end

  def self.process_output
    "#{header}#{detail}#{trailer}"
  end

  def self.header
    h_column1_19 = 'LIBRARY1' + '01' + document_column + '1'
    h_column20_54 = 'LIBRARY RECHARGES' + ' ' * 18
    transaction_date = convert_date_yyyymmdd(Time.zone.now)
    document_amount = convert_charge(total_charge * 2)
    h_column75_250 = 'N' + ' ' * 175

    "#{h_column1_19}#{h_column20_54}#{transaction_date}#{document_amount}#{h_column75_250}\n"
  end

  def self.detail
    result_arr = search_all_pending_status

    d_column1_19 = 'LIBRARY1' + '01' + document_column + '2'
    d_column24_27 = 'F510'
    d_column40_76 = 'LIBRARY-PHOTOCOPY SERVICE' + ' ' * 10 + 'D' + 'A'
    d_column89_94 = '636064'
    d_column101_112 = ' ' * 6 + ' ' * 6
    d_column123_209 = ' ' * 32 + '000000' + ' ' * 17 + '000000' + ' ' * 10 + '0000' + '0000' + ' ' * 8
    d_column220 = ' '
    detail_rows = ''

    result_arr.each_with_index do |recharge, index|
      sequence_num = convert_seq_num(index + 1)
      transaction_amount = convert_charge(recharge.charge)
      fund_code = recharge.fund_fund_code
      org_code = recharge.fund_org_code
      program_code = recharge.fund_program_code
      index_code = convert_index_code(recharge.fund_index_code)
      filler_var = convert_date_yyyymmdd(Time.zone.now) + ' ' * 2

      detail_rows += "#{d_column1_19}#{sequence_num}#{d_column24_27}#{transaction_amount}#{d_column40_76}#{fund_code}#{org_code}"
      detail_rows += "#{d_column89_94}#{program_code}#{d_column101_112}#{index_code}#{d_column123_209}#{filler_var}#{d_column220}\n"
    end
    detail_rows
  end

  def self.trailer
    f_column1_19 = 'LIBRARY1' + '01' + document_column + '2'
    f_sequence_num = convert_seq_num(pending_status_count + 1)
    f_column24_27 = 'F510'
    total_amount = convert_charge(total_charge)
    f_column40_76 = 'LIBRARY-PHOTOCOPY SERVICE' + ' ' * 10 + 'C' + 'A'
    f_column77_112 = ' ' * 12 + '693900' + ' ' * 18
    f_column113_122 = ' ' * 3 + 'LIBIL05'
    f_column123_154 = ' ' * 32
    f_column155_209 = '000000' + ' ' * 17 + '000000' + ' ' * 10 + '0000' + '0000' + ' ' * 8
    f_filler_var = convert_date_yyyymmdd(Time.zone.now) + ' ' * 2
    f_column220 = ' '

    "#{f_column1_19}#{f_sequence_num}#{f_column24_27}#{total_amount}#{f_column40_76}#{f_column77_112}#{f_column113_122}#{f_column123_154}#{f_column155_209}#{f_filler_var}#{f_column220}"
  end

  def self.document_column
    result_arr = search_all_pending_status
    document_num = ''
    result_arr.each do |recharge|
      document_num = recharge.document_num
    end

    'FRLBG' + convert_doc_num(document_num)
  end

  def self.create_file
    file_name = 'FISP.JVDATA.D' + convert_date_yymm(Time.zone.now) + '01.LIB'
    path = 'tmp/ftp/' + file_name
    content = process_output
    # puts Dir.pwd

    File.open(path, 'w') do |f|
      f.write(content)
    end

    file_name
  end

  def self.send_file
    file_name = create_file
    local_file_path = 'tmp/ftp/' + file_name
    remote_file_path = Rails.application.secrets.sftp_folder + '/' + file_name
    server_name = Rails.application.secrets.sftp_server_name
    user = Rails.application.secrets.sftp_user
    password = Rails.application.secrets.sftp_password

    Rails.logger.info('Creating SFTP connection')
    session = Net::SSH.start(server_name, user, password: password)
    sftp = Net::SFTP::Session.new(session).connect!
    Rails.logger.info('SFTP Connection created, uploading files.')
    sftp.upload!(local_file_path, remote_file_path)
    Rails.logger.info('File uploaded, Connection terminated.')
  end

  def self.convert_date_yymm(cdate)
    cdate.strftime('%y%m')
  end

  def self.convert_doc_num(doc_num)
    doc_num.to_s.rjust(3, '0') # 1 --> 001, 10 --> 010
  end

  def self.convert_seq_num(seq_num)
    seq_num.to_s.rjust(4, '0') # 1 --> 0001, 10 --> 0010
  end

  def self.convert_index_code(input)
    input.to_s.rjust(10, ' ') # 1 --> 0001, 10 --> 0010
  end

  def self.convert_charge(amount)
    s_amount = (100 * amount).to_f.round.to_s # 0.50 --> "50"
    '0' * (12 - s_amount.length) + s_amount
  end

  def self.convert_date_yyyymmdd(cdate)
    cdate.strftime('%Y%m%d')
  end
end
