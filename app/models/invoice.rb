#---
# @author hweng@ucsd.edu
#---

class Invoice < ActiveRecord::Base
  belongs_to :patron

  monetize :charge_cents,  :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 1000000
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
  #delegate :entity_pending_status, to: :patron, prefix: :patron

  def self.search_by_patron_name(search_term)
    return [] if search_term.blank?

    if Patron.where(name: search_term).first != nil
      patron_id = Patron.where(name: search_term).first
      result = where("patron_id = ? ", patron_id).order("created_at DESC") 
    else
      result = []
    end
  end

  def self.search_by_invoice_num(search_term)
    return [] if search_term.blank?

    if where("invoice_num = ?", search_term).first != nil
      
      result = where("invoice_num = ?", search_term) 
    else
      result = []
    end
  end

  def self.search_all_pending_status
    result = where(status: "pending").order("created_at DESC")
  end

  def self.pending_status_count
    search_all_pending_status.count
  end

  def self.get_charge_output
    result_arr = search_all_pending_status

    # header rows
    h_column1_21 = "CHDR" + " " * 1 + "CLIBRARY.CHARGE" + " " * 1
    transaction_date = Time.now.strftime("%m%d%y")
    h_column28 = " " * 1
    h_column35_320 = " " * 1 + "000001" + " " * 279
    
    # detail_rows
    d_column1 = "A"
    d_column11_51 = " " * 35 + "LIBLPS"
    d_column63_68 = " " * 6
    d_column79_320 = " " * 240

    detail_rows = ""
    total_charge = 0
    result_arr.each_with_index do |invoice, index|
      charge = invoice.charge
      charge_amount = convert_invoice_charge(charge)
      document_num = convert_invoice_num(invoice.invoice_num)
      account_id = process_person_id(invoice)

      total_charge += charge

      detail_rows += "#{d_column1}#{account_id}#{d_column11_51}#{charge_amount}#{d_column63_68}#{document_num}#{d_column79_320}\n"
    end

    # trailer row
    t_column1_5 = "CTRL" + " " * 1
    t_column12 = " "
    t_column24_320 = " " * 297
    record_count = convert_record_count(result_arr.size + 2)
    total_amount = convert_invoice_charge(total_charge)

    header_row = "#{h_column1_21}#{transaction_date}#{h_column28}#{transaction_date}#{h_column35_320}\n"

    final_rows = "#{t_column1_5}#{record_count}#{t_column12}#{total_amount}#{t_column24_320}"
    content = "#{header_row}#{detail_rows}#{final_rows}"
  end

  
  def self.get_person_header_row
    h_column1_21 = "PHDR" + " " * 1 + "CLIBRARY.PERSON" + " " * 1
    transaction_date = Time.now.strftime("%m%d%y")
    h_column28 = " " * 1
    h_column35_320 = " " * 1 + "000001" + " " * 279

    header_row = "#{h_column1_21}#{transaction_date}#{h_column28}#{transaction_date}#{h_column35_320}\n"
  end
  
  def self.get_person_detail_rows
    result_arr = search_all_pending_status
    detail_rows = ""

    d_column1_10 = "C" + " " * 9
    d_column20_23 = " " * 4
    d_column114_119 = " " * 6
    
    result_arr.each_with_index do |invoice, index|
      if !is_entity?(invoice.patron_ar_code)
        person_id = process_person_id(invoice)
        name_key = process_name_key(invoice)
        full_name = process_full_name(invoice)

        detail_rows += "#{d_column1_10}#{person_id}#{d_column20_23}#{name_key}#{full_name}#{d_column114_119}"
        detail_rows += process_address(invoice)
      end
    end
    return detail_rows
  end

  def self.get_entity_header_row
    h_column1_21 = "EHDR" + " " * 1 + "CLIBRARY.ENTITY" + " " * 1
    transaction_date = Time.now.strftime("%m%d%y")
    h_column28 = " " * 1
    h_column35_320 = " " * 286

    header_rows = "#{h_column1_21}#{transaction_date}#{h_column28}#{transaction_date}#{h_column35_320}\n"
  end

  def self.get_entity_detail_rows
    result_arr = search_all_pending_status

    d_column1 = "C" 
    d_column2_9 = "PUBLPUBL" 
    d_column10_18 = " " * 9
    d_column118_119 = " " * 2

    detail_rows = ""

    result_arr.each_with_index do |invoice, index|
      if is_entity?(invoice.patron_ar_code)
        person_id = process_person_id(invoice)
        name_key = process_name_key(invoice)
        full_name = process_full_name(invoice)
       
        detail_rows += "#{d_column1}#{d_column2_9}#{d_column10_18}#{person_id}#{name_key}#{full_name}#{d_column118_119}"
        detail_rows += process_address(invoice)
      end
    end
    return detail_rows
  end

  def self.get_person_output
    content = "#{get_person_header_row}#{get_person_detail_rows}#{get_trailer_row("PTRL", get_person_count)}"
  end

  def self.get_entity_output
   entity_content = "#{get_entity_header_row}#{get_entity_detail_rows}#{get_trailer_row("ETRL", get_entity_count)}"
  end

  def self.get_trailer_row(col1,count)
    t_column1_5 = col1 + " " * 1
    t_column12_320 = " " * 309
    record_count = convert_record_count(count + 2)

    final_rows = "#{t_column1_5}#{record_count}#{t_column12_320}"
  end

  def self.get_path(file_name)
    path = "tmp/ftp/" + file_name
  end
  
  def self.create_entity_file
    file_name = Invoice.get_entity_file_name
    path = get_path(file_name)
    content = Invoice.get_entity_output
    
    write_file(path,content )

    return file_name
  end

  def self.create_person_file
    file_name = Invoice.get_person_file_name
    path = get_path(file_name)
    content = Invoice.get_person_output

    write_file(path,content )

    return file_name
  end

  def self.create_charge_file
    file_name = Invoice.get_charge_file_name
    path = get_path(file_name)
    content = Invoice.get_charge_output

    write_file(path,content )

    return file_name
  end

  def self.write_file(path,content )
    File.open(path, "w") do |f|
      f.write(content)
    end
  end

  def self.convert_invoice_charge(amount)
    s_amount = (10* amount).to_f.round.to_s  # 0.50 --> "50"
    output_amount = "0" *(10 - s_amount.length) + s_amount + "{"
  end

  def self.convert_invoice_num(invoice_num)
    str = invoice_num.to_s.rjust(10, " ") 
  end

  def self.convert_record_count(input)
    output = input.to_s.rjust(6, "0")
  end

  def self.process_person_id(invoice)
    person_id = invoice.patron_ar_code
  end
  
  def self.process_name_key(invoice)
    input = invoice.patron_name
    output = input + " " *(35 - input.length)
  end

  def self.process_full_name(invoice)
    input = invoice.patron_name
    output = input + " " *(55 - input.length)
  end

  def self.process_address(invoice)
      d_column291_320 = " " * 30
      address1 = convert_address(invoice.patron_address1)
      address2 = convert_address(invoice.patron_address2)
      address3 = convert_address(invoice.patron_address3)
      address4 = convert_address(invoice.patron_address4)
      city = convert_city(invoice.patron_city)
      state = invoice.patron_state
      zip1 = invoice.patron_zip1
      zip2 = convert_zip2(invoice.patron_zip2)
      country_code = convert_country(invoice.patron_country_code)

      detail_rows = "#{address1}#{address2}#{address3}#{address4}#{city}#{state}#{zip1}#{zip2}#{country_code}#{d_column291_320}\n"
  end

  def self.convert_address(input)
    output = input.blank? ? (" " * 35) : (input + " " *(35 - input.length) )
  end

  def self.convert_city(input)
    output = input + " " *(18 - input.length) 
  end

  def self.convert_zip2(input)
    output = input.blank? ? (" " * 4) : (input + " " *(4 - input.length))
  end

  def self.convert_country(input)
    output = input.blank? ? (" " * 2) : (input + " " *(2 - input.length))
  end

  def self.is_entity?(input)
    input[0,2] == "AA" ? true : false
  end

  def self.get_entity_count
    result_arr = search_all_pending_status
    count = 0

    result_arr.each do |invoice|
      if is_entity?(invoice.patron_ar_code)
        count+=1
      end
    end
    return count
  end

  def self.get_person_count
    result_arr = search_all_pending_status
    count = 0

    result_arr.each do |invoice|
      if !is_entity?(invoice.patron_ar_code)
        count+=1
      end
    end
    return count
  end

  def self.get_entity_lfile_name
    file_name = "ENTITY.D" + convert_to_julian_date + ".TXT"
  end

  def self.get_person_lfile_name
    file_name = "PERSON.D" + convert_to_julian_date + ".TXT"
  end

  def self.get_charge_lfile_name
    file_name = "CHARGE.D" + convert_to_julian_date + ".TXT"
  end

  def self.get_entity_file_name
    file_name = "SISP.ARD2501.LIBBUS.ENTITY.D" + convert_to_julian_date
  end

  def self.get_person_file_name
    file_name = "SISP.ARD2501.LIBBUS.PERSON.D" + convert_to_julian_date
  end

  def self.get_charge_file_name
    file_name = "SISP.ARD2501.LIBBUS.CHARGE.D" + convert_to_julian_date
  end

  def self.convert_to_julian_date
    output = Date.today.strftime("%y") + Date.today.yday.to_s
  end
end