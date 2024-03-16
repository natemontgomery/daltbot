class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|
      t.references :address

      t.timestamp :dt

      t.string :weather_description

      t.float :temp
      t.float :feels_like
      t.float :temp_max
      t.float :temp_min
      t.float :humidity
      t.float :pressure

      t.timestamps
    end
  end
end
