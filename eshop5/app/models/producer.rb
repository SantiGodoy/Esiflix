# coding: utf-8
class Producer < ApplicationRecord
  validates_presence_of :name, :message => 'Debe introducir un nombre para la productora.'
  validates_uniqueness_of :name, :message => 'El nombre de la productora ya existe.'
  validates_length_of :name, :in => 2..255, :message => 'El nombre de la productora no se ajusta al tamaño límite (2...255).'
end
