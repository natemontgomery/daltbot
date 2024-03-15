class Forecast < ApplicationRecord
  geocoded_by :address
end
