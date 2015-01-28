class Fund < ActiveRecord::Base
  has_many :recharges

  validates :program_code, presence: true, length: { is: 6 }
  validates :org_code, presence: true, length: { is: 6 }
  validates :index_code, presence: true, length: { is: 10 }
  validates :fund_code, presence: true, length: { is: 6 }
end