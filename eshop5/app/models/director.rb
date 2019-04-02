class Director < ApplicationRecord
  has_and_belongs_to_many :films
  validates_presence_of :first_name, :message => 'Debe introducir un nombre.'
  validates_presence_of :last_name, :message => 'Debe introducir un apellido.'

  def name
    "#{first_name} #{last_name}"
  end
end
