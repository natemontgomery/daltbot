class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :raw_address, index: true

      # Using address attributes from Photon data.
      t.string :street
      t.string :housenumber
      t.string :locality
      t.string :district

      t.string :city
      t.string :state
      t.string :country
      t.string :postcode

      t.string :name

      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
