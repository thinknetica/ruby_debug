class CreateHelpRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :help_requests do |t|
      t.string :lonlat, null: true
      t.string :phone
      t.text :address
      t.integer :state, default: 0, null: true
      t.text :comment
      t.string :person
      t.boolean :mediated, default: false, null: false
      t.boolean :meds_preciption_required
      t.timestamps
    end
  end
end
