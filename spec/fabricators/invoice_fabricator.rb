Fabricator(:invoice) do 
  charge 4.5
  number_prints { Faker::Number.number(1)}
  invoice_type 'e-copy'
  status 'active'
  ill_numbers '123456'
  patron_id 1
end