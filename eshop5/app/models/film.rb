# coding: utf-8
class Film < ApplicationRecord
  has_and_belongs_to_many :directors
  belongs_to :producer

  has_many :cart_items
  has_many :carts, :through => :cart_items

  has_attached_file :cover_image
  validates_attachment :cover_image,
  :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }

  validates_length_of :title, :in => 1..255, :message => 'El título de la película no está dentro de los límites [1...255].'
  validates_presence_of :producer, :message => 'Debe seleccionar una productora.'
  validates_presence_of :directors, :message => 'Debe seleccionar uno o más directores.'
  validates_presence_of :produced_at, :message => 'Debe seleccionar una fecha de producción.'
  validates_numericality_of :duration, :only_integer => true, :message => 'La duración debe ser un número.'
  validates_numericality_of :price, :message => 'El precio debe ser un número.'
  validates_length_of :kind, :in => 1..15, :message => 'El formato de la película no se ajusta al tamaño [1...15].'

  def director_names
    self.directors.map{|director| director.name}.join(", ")
  end

  def self.latest(num)
    all.order("films.id desc").includes(:directors, :producer).limit(num)
  end
end
