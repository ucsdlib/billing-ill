# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do
  Fund.create(program_code: "400000", org_code: "414909", index_code: "ANSVAMC000", fund_code: "60200A")
end

10.times do
  Recharge.create(charge: "23.5", number_copies: "2", status: "Pending", notes: "recharge notes.", submitted_at: Time.now)
end