require 'pry'

def consolidate_cart(cart:[])
  return_cart = {}
    cart.each do |item|
      item.each do |name, value|
        if return_cart.keys.include?(name)
          return_cart[name][:count] +=1 
        else
        return_cart[name] = {:price => value[:price], :clearance => value[:clearance], :count => 1 }
        end
      end
    end
  return_cart
end

def apply_coupons(cart:[], coupons:[])
    apply_coupons_hash = {}
    cart.each do |item|
      item_hash = build_item_hash(item)
      matching_coupon_for_item = coupons.detect {|coupon| coupon[:item] == item_hash[:name]}
      if matching_coupon_for_item && can_apply_coupon?(item_hash, matching_coupon_for_item)
        quantity = (item_hash[:count] / matching_coupon_for_item[:num]) 
        apply_coupons_hash[item_hash[:name]] = {:price => item_hash[:price], :clearance => item_hash[:clearance], :count =>(item_hash[:count] - (matching_coupon_for_item[:num] * quantity))}
        apply_coupons_hash[item_hash[:name] + ' W/COUPON'] = {:price => matching_coupon_for_item[:cost], :clearance => item_hash[:clearance], :count => quantity}
      else 
        apply_coupons_hash[item_hash[:name]] = {:price => item_hash[:price], :clearance => item_hash[:clearance], :count => item_hash[:count]}
      end
    end
    apply_coupons_hash
end

# A. Coerce the data to the structure I want, forget the structure I have
    # 1. One item, one element
    # 2.  Represent single object either with an object, with a hash
      # ['Avocado', {price: 2, count: 4}] => {name: 'Avocado', price: 2, count: 4}
      # consider building ['Avocado' => {name: 'Avocado', count: }]
# B. Make sure we use the correct iterators
  # If I see an 'each' and then an 'if' => 'select' or 'detect'
      # select is when i want to return a list (array)
      # detect is if i want to just return the first, nil
    # Beware of sandwiches
       # arr = []
       # arr.each do ||
       # end 
       # arr
# C. Consider replacing comments with a method call
    # cut and paste code to the body of the new method
    # pass in the proper parameters
    # call the method in place of the old code

def can_apply_coupon?(item_hash, matching_coupon_for_item)
  (item_hash[:count] >= matching_coupon_for_item[:num])
end

def build_item_hash(item_array)
  item_hash = {}
  item_hash[:name] = item_array.first
  item_hash.merge!(item_array.last)
end

def apply_clearance(cart:[])
  cart.each do |item|
    if item[1][:clearance] == true
      item[1][:price] = (item[1][:price] * 0.8).round(1)
    end
  end
end

def checkout(cart: [], coupons: [])
  consol_cart = consolidate_cart(cart: cart)
  coupons_applied = apply_coupons(cart: consol_cart, coupons: coupons)
  clearance_applied = apply_clearance(cart: coupons_applied)
  total = []
  clearance_applied.each do |item, attributes|
    if attributes[:count] > 0 
      # binding.pry
    total << (attributes[:price] * attributes[:count])
    end
  end
  # binding.pry
  total_amount = total.inject(:+)
  if total_amount >= 100
    # binding.pry
    total_amount = total_amount * 0.9
  end
  total_amount
end

