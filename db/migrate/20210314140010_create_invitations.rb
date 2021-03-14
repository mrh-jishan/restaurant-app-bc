class CreateInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :invitations do |t|
      t.references :user
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
