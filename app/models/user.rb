class User < ActiveRecord::Base
  validates_presence_of :name, :message => 'Debes escribir tu nombre.'
  validates_length_of :name, :minimum => 3, :message => 'Tu nombre debe tener por lo menos 3 caracteres.'
  validates_format_of :name, :with => /\A[a-zA-Z áéíóúÁÉÍÓÚñÑ]+\z/, :message => "El nombre solo debe tener letras."

  validates_presence_of :email, :message => 'Debes escribir tu correo.'
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "El correo debe tener un formato válido."

  validates_presence_of :business_name, :message => 'Debes escribir el nombre de tu negocio.'
  validates_length_of :business_name, :minimum => 3, :message => 'El nombre debe tener por lo menos 3 caracteres.'

  validates_presence_of :address, :message => 'Debes escribir la dirección de tu negocio (puede ser solo la colonia).'
  validates_length_of :address, :minimum => 10, :message => 'la dirección debe tener por lo menos 10 caracteres.'

  validates_presence_of :operation_license, :message => "La licencia de operación no puede estar en blanco."
   validates_format_of :operation_license, :with => /\A[a-zA-Z0-9]+\z/, :message => "La licencia de operación solo debe tener letras, número y guiones."

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,:omniauthable, :omniauth_providers => [:facebook, :linkedin]

  validates :city_id, presence: true
  belongs_to :city

  has_many :user_formation_step
  has_many :formation_steps, through: :user_formation_step
  has_many :complaints

  mount_uploader :operation_license_file, PdfUploader
  mount_uploader :land_permission_file, PdfUploader


  def business?
    !self.admin?
  end

  def profile_complete?
    self.address.present? &&
    self.operation_license_file.present? &&
    self.land_permission_file.present? &&
    self.operation_license.present?
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name:auth.extra.raw_info.name,
          provider:auth.provider,
          uid:auth.uid,
          email:auth.info.email,
          password:Devise.friendly_token[0,20],
          city_id: '1',
          operation_license: '0000000000',
          address: 'Domicilio de la empresa',
          business_name: 'Nombre de la empresa'
          )
      end
    end
  end

  def self.connect_to_linkedin(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else

        user = User.create(name:auth.info.first_name,
          provider:auth.provider,
          uid:auth.uid,
          email:auth.info.email,
          password:Devise.friendly_token[0,20],
          city_id: '1',
          operation_license: '0000000000',
          address: 'Domicilio de la empresa',
          business_name: 'Nombre de la empresa'
          )
      end

    end
  end

end
