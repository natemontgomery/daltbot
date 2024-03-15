class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|
      t.references :address

      t.string :forecast_type, index: true

      t.timestamp :dt

      t.float :temp
      t.float :feels_like
      t.float :high
      t.float :low
      t.float :humidity
      t.float :pressure

      t.timestamps
    end
  end
end
