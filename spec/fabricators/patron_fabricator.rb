Fabricator(:patron) do 
  email { Faker::Internet.email}
  name { Faker::Lorem.characters(6)}
  ar_code { Faker::Lorem.characters(9)}
  address1 { Faker::Lorem.characters(10)}
  city { Faker::Address.city)}
  state { Faker::Lorem.characters(2)}
  zip1 { Faker::Address.zip_code}
end