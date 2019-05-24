class ForumPost < ApplicationRecord
  validates_length_of :name, :within => 2..50, :message => "El nombre debe tener entre 2 y 50 caracteres."
  validates_length_of :subject, :within => 5..255, :message => "El asunto debe contener entre 5 y 255 caracteres."
  validates_length_of :body, :within => 5..5000, :message => "El cuerpo del post debe estar entre 5 y 5000 caracteres."
end
