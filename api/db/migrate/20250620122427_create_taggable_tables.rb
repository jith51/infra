class CreateTaggableTables < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name
    end
    create_table :tags_attachments, id: false  do |t|
      t.belongs_to :tag
      t.belongs_to :taggable, polymorphic: true
    end
  end
end
