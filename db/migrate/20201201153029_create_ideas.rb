class CreateIdeas < ActiveRecord::Migration[5.2]
  def change
    create_table :ideas do |t|
      t.references :category, foreign_key: true
      t.text :body, null: false
    end
  end
end
