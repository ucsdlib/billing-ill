Fabricator(:patron) do 
  email_address { Faker::Internet.email}
  name { Faker::Lorem.characters(6)}
  ar_code 'a12345678'
  address1 { Faker::Lorem.characters(10)}
  city 'San Diego'
  state { Faker::Lorem.characters(2)}
  zip1 '12345'
end