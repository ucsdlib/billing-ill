# encoding: utf-8
#---
# @author hweng@ucsd.edu
#---

class Invoice < ActiveRecord::Base
  belongs_to :patron

  monetize :charge_cents, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1_000_000
  }

  validates :invoice_num, presence: true, uniqueness: true
  validates :number_prints, presence: true
  validates :invoice_type, presence: true
  validates :status, presence: true
  validates :comments, presence: true
  validates :patron_id, presence: true

  delegate :name, to: :patron, prefix: :patron
  delegate :email_address, to: :patron, prefix: :patron
  delegate :ar_code, to: :patron, prefix: :patron
  delegate :address1, to: :patron, prefix: :patron
  delegate :address2, to: :patron, prefix: :patron
  delegate :address3, to: :patron, prefix: :patron
  delegate :address4, to: :patron, prefix: :patron
  delegate :city, to: :patron, prefix: :patron
  delegate :state, to: :patron, prefix: :patron
  delegate :zip1, to: :patron, prefix: :patron
  delegate :zip2, to: :patron, prefix: :patron
  delegate :country_code, to: :patron, prefix: :patron
  # delegate :entity_pending_status, to: :patron, prefix: :patron

  def self.search_by_patron_name(search_term)
    blank_term(search_term)

    if !Patron.find_by(name: search_term).nil?
      patron_id = Patron.find_by(name: search_term)
      where('patron_id = ? ', patron_id).order('created_at DESC')
    else
      []
    end
  end

  def self.search_by_invoice_num(search_term)
    blank_term(search_term)

    if !find_by('invoice_num = ?', search_term).nil?

      where('invoice_num = ?', search_term)
    else
      []
    end
  end

  def self.blank_term(search_term)
    return [] if search_term.blank?
  end

  def self.search_all_pending_status
    where(status: 'pending').order('created_at DESC')
  end

  def self.pending_status_count
    search_all_pending_status.count
  end

  ##
  # Handles mapping for PERSON ENTITY and CHARGE output files
  #

  def self.person_output
    h_column1_21 = 'PHDR' + ' ' * 1 + 'CLIBRARY.PERSON' + ' ' * 1
    h_column35_320 = ' ' * 1 + '000001' + ' ' * 279

    output = "#{header_row(h_column1_21, h_column35_320)}#{person_detail_rows}#{trailer_row('PTRL', person_count)}"
  end

  def self.entity_output
    h_column1_21 = 'EHDR' + ' ' * 1 + 'CLIBRARY.ENTITY' + ' ' * 1
    h_column35_320 = ' ' * 286

    "#{header_row(h_column1_21, h_column35_320)}#{entity_detail_rows}#{trailer_row('ETRL', entity_count)}"
  end

  def self.charge_output
    h_column1_21 = 'CHDR' + ' ' * 1 + 'CLIBRARY.CHARGE' + ' ' * 1
    h_column35_320 = ' ' * 1 + '000001' + ' ' * 279

    "#{header_row(h_column1_21, h_column35_320)}#{charge_detail_rows}#{charge_trailer_row}"
  end

  def self.header_row(h_column1_21, h_column35_320)
    transaction_date = Time.zone.now.strftime('%m%d%y')
    h_column28 = ' ' * 1

    "#{h_column1_21}#{transaction_date}#{h_column28}#{transaction_date}#{h_column35_320}\n"
  end

  def self.trailer_row(col1, count)
    t_column1_5 = col1 + ' ' * 1
    t_column12_320 = ' ' * 309
    record_count = convert_record_count(count + 2)

    "#{t_column1_5}#{record_count}#{t_column12_320}"
  end

  def self.charge_trailer_row
    t_column1_5 = 'CTRL' + ' ' * 1
    t_column12 = ' '
    t_column24_320 = ' ' * 297
    record_count = convert_record_count(pending_status_count + 2)
    total_amount = convert_invoice_charge(total_charge)

    "#{t_column1_5}#{record_count}#{t_column12}#{total_amount}#{t_column24_320}"
  end

  def self.charge_detail_rows
    result_arr = search_all_pending_status

    d_column1 = 'A'
    d_column11_51 = ' ' * 35 + 'LIBLPS'
    d_column63_68 = ' ' * 6
    d_column79_320 = ' ' * 240

    charge_detail = ''

    result_arr.each_with_index do |invoice, _index|
      charge_amount = convert_invoice_charge(invoice.charge)
      document_num = convert_invoice_num(invoice.invoice_num)
      account_id = process_person_id(invoice)

      charge_detail += "#{d_column1}#{account_id}#{d_column11_51}#{charge_amount}#{d_column63_68}#{document_num}#{d_column79_320}\n"
    end
    charge_detail
  end

  def self.person_detail_rows
    result_arr = search_all_pending_status
    person_detail_rows = ''

    d_column1_10 = 'C' + ' ' * 9
    d_column20_23 = ' ' * 4
    d_column114_119 = ' ' * 6

    result_arr.each_with_index do |invoice, _index|
      unless entity?(invoice.patron_ar_code)
        person_id = process_person_id(invoice)
        name_key = process_name_key(invoice)
        full_name = process_full_name(invoice)

        person_detail_rows += "#{d_column1_10}#{person_id}#{d_column20_23}#{name_key}#{full_name}#{d_column114_119}"
        person_detail_rows += process_address(invoice)
      end
    end
    person_detail_rows
  end

  def self.entity_detail_rows
    result_arr = search_all_pending_status

    d_column1 = 'C'
    d_column2_9 = 'PUBLPUBL'
    d_column10_18 = ' ' * 9
    d_column118_119 = ' ' * 2

    entity_detail = ''

    result_arr.each_with_index do |invoice, _index|
      if entity?(invoice.patron_ar_code)
        person_id = process_person_id(invoice)
        name_key = process_name_key(invoice)
        full_name = process_full_name(invoice)

        entity_detail += "#{d_column1}#{d_column2_9}#{d_column10_18}#{person_id}#{name_key}#{full_name}#{d_column118_119}"
        entity_detail += process_address(invoice)
      end
    end
    entity_detail
  end

  def self.convert_invoice_charge(amount)
    s_amount = (10 * amount).to_f.round.to_s # 0.50 --> "50"
    '0' * (10 - s_amount.length) + s_amount + '{'
  end

  def self.convert_invoice_num(invoice_num)
    invoice_num.to_s.rjust(10, ' ')
  end

  def self.convert_record_count(input)
    input.to_s.rjust(6, '0')
  end

  def self.process_person_id(invoice)
    invoice.patron_ar_code
  end

  def self.process_name_key(invoice)
    input = invoice.patron_name
    input + ' ' * (35 - input.length)
  end

  def self.process_full_name(invoice)
    input = invoice.patron_name
    input + ' ' * (55 - input.length)
  end

  def self.process_address(invoice)
    d_column291_320 = ' ' * 30
    address1 = convert_address(invoice.patron_address1)
    address2 = convert_address(invoice.patron_address2)
    address3 = convert_address(invoice.patron_address3)
    address4 = convert_address(invoice.patron_address4)
    city = convert_city(invoice.patron_city)
    state = invoice.patron_state
    zip1 = invoice.patron_zip1
    zip2 = convert_zip2(invoice.patron_zip2)
    country_code = convert_country(invoice.patron_country_code)

    "#{address1}#{address2}#{address3}#{address4}#{city}#{state}#{zip1}#{zip2}#{country_code}#{d_column291_320}\n"
  end

  def self.convert_address(input)
    convert_format(35, input)
  end

  def self.convert_zip2(input)
    convert_format(4, input)
  end

  def self.convert_country(input)
    convert_format(2, input)
  end

  def self.convert_city(input)
    input + ' ' * (18 - input.length)
  end

  def self.convert_format(num, input)
    input.blank? ? (' ' * num) : (input + ' ' * (num - input.length))
  end

  def self.entity?(input)
    input[0, 2] == 'AA' ? true : false
  end

  def self.entity_count
    result_arr = search_all_pending_status
    count = 0

    result_arr.each do |invoice|
      count += 1 if entity?(invoice.patron_ar_code)
    end
    count
  end

  def self.person_count
    result_arr = search_all_pending_status
    count = 0

    result_arr.each do |invoice|
      count += 1 unless entity?(invoice.patron_ar_code)
    end
    count
  end

  def self.total_charge
    result_arr = search_all_pending_status
    total_charge = 0

    result_arr.each_with_index do |invoice, _index|
      charge = invoice.charge
      total_charge += charge
    end
    total_charge
  end

  ##
  # Handles PERSON ENTITY and CHARGE file creation
  #

  def self.get_path(file_name)
    'tmp/ftp/' + file_name
  end

  def self.create_entity_file
    file_name = Invoice.entity_file_name
    path = get_path(file_name)
    content = Invoice.entity_output

    write_file(path, content)

    file_name
  end

  def self.create_person_file
    file_name = Invoice.person_file_name
    path = get_path(file_name)
    content = Invoice.person_output

    write_file(path, content)

    file_name
  end

  def self.create_charge_file
    file_name = Invoice.charge_file_name
    path = get_path(file_name)
    content = Invoice.charge_output

    write_file(path, content)

    file_name
  end

  def self.write_file(path, content)
    File.open(path, 'w') do |f|
      f.write(content)
    end
  end

  ##
  # Handles file name convention used in ftp and emails.
  #

  def self.entity_lfile_name
    'ENTITY.D' + convert_to_julian_date + '.TXT'
  end

  def self.person_lfile_name
    'PERSON.D' + convert_to_julian_date + '.TXT'
  end

  def self.charge_lfile_name
    'CHARGE.D' + convert_to_julian_date + '.TXT'
  end

  def self.entity_file_name
    'SISP.ARD2501.LIBBUS.ENTITY.D' + convert_to_julian_date
  end

  def self.person_file_name
    'SISP.ARD2501.LIBBUS.PERSON.D' + convert_to_julian_date
  end

  def self.charge_file_name
    'SISP.ARD2501.LIBBUS.CHARGE.D' + convert_to_julian_date
  end

  def self.convert_to_julian_date
    Time.zone.today.strftime('%y') + Time.zone.today.yday.to_s
  end

  def self.send_file
    tmp_dir = 'tmp/ftp/'
    remote_dir = Rails.application.secrets.sftp_folder + '/'

    local_charge_file_path = tmp_dir + create_charge_file
    remote_charge_file_path = remote_dir + create_charge_file
    local_entity_file_path = tmp_dir + create_entity_file
    remote_entity_file_path = remote_dir + create_entity_file
    local_person_file_path = tmp_dir + create_person_file
    remote_person_file_path = remote_dir + create_person_file

    server_name = Rails.application.secrets.sftp_server_name
    user = Rails.application.secrets.sftp_user
    password = Rails.application.secrets.sftp_password

    Rails.logger.info('Creating SFTP connection')
    session = Net::SSH.start(server_name, user, password: password)
    sftp = Net::SFTP::Session.new(session).connect!
    Rails.logger.info('SFTP Connection created, uploading files.')
    sftp.upload!(local_charge_file_path, remote_charge_file_path)
    sftp.upload!(local_entity_file_path, remote_entity_file_path)
    sftp.upload!(local_person_file_path, remote_person_file_path)
    Rails.logger.info('File uploaded, Connection terminated.')
  end
end
