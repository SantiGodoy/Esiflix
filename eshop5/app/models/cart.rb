class Cart < ApplicationRecord
  has_many :cart_items
  has_many :films, :through => :cart_items

  def add(film_id)
    items = cart_items.where(film_id: film_id)
    film = Film.find film_id
    if items.size < 1
      ci = cart_items.create :film_id => film_id, :amount => 1, :price => film.price
    else
      ci = items.first
      ci.update_attribute :amount, ci.amount + 1
    end
    ci
  end

  def remove(film_id)
    ci = cart_items.where(film_id: film_id).first
    if ci.amount > 1
      ci.update_attribute :amount, ci.amount - 1
    else
      CartItem.destroy ci.id
    end
    ci
  end

  def total
    sum = 0
    cart_items.each do |item| sum += item.price * item.amount end
    sum
  end
end
