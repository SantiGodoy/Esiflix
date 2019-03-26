class Director < ApplicationRecord
  validates_presence_of :first_name, :last_name, :message => 'Debe introducir un nombre y un apellido.'

  def name
    "#{first_name} #{last_name}"
  end
end
