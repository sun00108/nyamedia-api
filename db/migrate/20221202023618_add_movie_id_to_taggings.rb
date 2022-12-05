class AddMovieIdToTaggings < ActiveRecord::Migration[6.1]
  def change
    add_column :taggings, :movie_id, :integer
  end
end
