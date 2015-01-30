Fabricator(:recharge) do 
  charge { Faker::Number.number(1)}
  number_copies { Faker::Number.number(1)}
  status 'active'
end