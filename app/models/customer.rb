class Customer < ApplicationRecord
    belongs_to :product, optional: true
end