class AddLastUsedAtToParticipation < ActiveRecord::Migration[5.0]
  def change
    change_table :participations do |t|
      t.primary_key :id
      t.datetime :last_used_at
      t.timestamps default: '2017-02-27 20:54:00'
    end
  end
end
