class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|

      t.timestamps
    end
  end
end
