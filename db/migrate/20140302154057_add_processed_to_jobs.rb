class AddProcessedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :processed, :boolean
  end
end
