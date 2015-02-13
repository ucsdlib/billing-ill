Fabricator(:fund) do 
  program_code { Faker::Lorem.characters(6)}
  org_code { Faker::Lorem.characters(6)}
  index_code { Faker::Lorem.characters(10)}
  fund_code { Faker::Lorem.characters(6)}
end