class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.date :sent_date
      t.string :from
    end
  end
end
