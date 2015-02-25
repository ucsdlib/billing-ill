Fabricator(:recharge) do 
  charge { Faker::Number.number(2)}
  number_copies { Faker::Number.number(1)}
  status 'active'
  fund_id 1
end