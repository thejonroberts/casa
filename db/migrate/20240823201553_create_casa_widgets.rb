class CreateCasaWidgets < ActiveRecord::Migration[7.1]
  def change
    create_table :casa_widgets do |t|
      t.string :name
      t.text :body
      t.boolean :hidden
      t.decimal :amount
      t.integer :tracking_id
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    add_index :casa_widgets, :tracking_id, unique: true
    add_index :casa_widgets, :email, unique: true
  end
end
