Fabricator(:recharge) do 
  charge 4.5
  number_copies { Faker::Number.number(1)}
  status 'active'
  fund_id 1
  document_num 200
end