class UpdateForecast < ActiveRecord::Migration[7.1]
  def change
    change_table :forecasts, bulk: true do |t|
      t.float :sea_level
      t.float :grnd_level
    end
  end
end
