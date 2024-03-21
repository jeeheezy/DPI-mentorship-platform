class RemoveBannerImageColumnFromProgram < ActiveRecord::Migration[7.0]
  def change
    remove_column :programs, :banner_image
  end
end
