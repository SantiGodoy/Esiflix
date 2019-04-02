class AddCoverImageAttachmentToFilms < ActiveRecord::Migration[5.1]
  def up
    add_attachment :films, :cover_image
  end

  def down
    remove_attachment :films, :cover_image
  end
end
