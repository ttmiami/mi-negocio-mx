class FormationStep < ActiveRecord::Base
    

        self.inheritance_column = nil

        belongs_to :municipio
    
        has_many :user_formation_step
        has_many :users, through: :user_formation_step

      scope :by_city, -> (city) { where(municipio: city) }


       def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["nombre", "descripcion","path","tipo","municipio_id"]#column_names
      all.each do |product|
        csv << [product.name,product.description, product.path, product.type == 'AF' ? 'Física' : 'Moral' , product.municipio.nombre] 
      end
    end
  end
end
