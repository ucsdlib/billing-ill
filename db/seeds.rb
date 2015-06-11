# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


  Fund.create(program_code: "400000", org_code: "414909", index_code: "ANSVAMC", fund_code: "60200A")
  Fund.create(program_code: "400001", org_code: "414910", index_code: "BNSVAMC", fund_code: "70200A")
  Fund.create(program_code: "400002", org_code: "414911", index_code: "CNSVAMC", fund_code: "80200A")
  Fund.create(program_code: "400003", org_code: "414912", index_code: "DNSVAMC", fund_code: "90200A")
  Fund.create(program_code: "400004", org_code: "414913", index_code: "ENSVAMC", fund_code: "60200B")
  Fund.create(program_code: "400005", org_code: "414914", index_code: "FNSVAMC", fund_code: "60200C")
  Fund.create(program_code: "400006", org_code: "414915", index_code: "GNSVAMC", fund_code: "60200D")
  
10.times do
  Recharge.create(charge: "2.35", number_copies: "2", status: "pending", notes: "recharge notes.", fund_id: 1)
end

5.times do
  Recharge.create(charge: "1.00", number_copies: "2", status: "active", notes: "recharge notes.", fund_id: 2)
end

5.times do
  Recharge.create(charge: "100.00", number_copies: "2", status: "submitted", notes: "recharge notes.", submitted_at: Time.now, fund_id: 3)
end

Patron.create(email_address: "doe@xxx.com", name: "Joe Doe", ar_code: "123456789", address1: "12345 abc street", city: "sun city",  state: "CA", zip1: "12345")

Invoice.create(invoice_num: "5001", invoice_type: "e-copy", charge: "5.88", number_prints: "2", status: "pending", comments: "12345,34567", ill_number: "various", patron_id: 1)

