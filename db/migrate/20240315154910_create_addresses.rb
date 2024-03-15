class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :raw_address, index: true

      t.timestamps
    end
  end
end
