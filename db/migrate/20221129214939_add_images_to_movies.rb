class AddImagesToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :poster_id, :integer
    add_column :movies, :backdrop_id, :integer
    add_column :movies, :logo_id, :integer
  end
end
