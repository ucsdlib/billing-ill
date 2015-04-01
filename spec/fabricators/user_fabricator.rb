Fabricator(:user) do 
  uid 1
  full_name {Faker::Name.name}
  email {Faker::Internet.email } 
end