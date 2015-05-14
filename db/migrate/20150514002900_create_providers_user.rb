class CreateProvidersUser < ActiveRecord::Migration
  def change
    create_table :providers_users do |t|
      t.integer :provider_id
      t.integer :user_id
      t.boolean :contact
    end
  end
end
