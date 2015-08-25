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
      coupon_items = [] # get coupon item names
        coupons.each do |item|
          coupon_items << item[:item]
        end
    cart.each do |item|
      name = item[0]
      attributes = item[1]
      num_of_coupon = 0 
      coupon_price = 0 
      coupons.each do |coupon_hash| #get num and cost of that particular item from coupons hash
        if coupon_hash[:item] == name
          num_of_coupon = coupon_hash[:num]
          coupon_price = coupon_hash[:cost]
        end
      end
      num_of_coupon #quantity of item required for coupon to work

      if ((coupon_items.include?(name)) && (attributes[:count] >= num_of_coupon))
      #for the current item, if the count is >= coupon quantity requirement
      #decrease the item count and add the coupon hash 
      quantity = (attributes[:count] / num_of_coupon) #item quantity/coupon quantity
        apply_coupons_hash[name] = {:price => attributes[:price], :clearance => attributes[:clearance], :count =>(attributes[:count] - (num_of_coupon * quantity))}
        apply_coupons_hash[name + ' W/COUPON'] = {:price => coupon_price, :clearance => attributes[:clearance], :count => quantity}
      else #if no coupon for this item, then just add the existing item hash to apply_coupons_hash
        apply_coupons_hash[name] = {:price => attributes[:price], :clearance => attributes[:clearance], :count => attributes[:count]}
      end
    end
    apply_coupons_hash
end
  # tried this but got erorr can't add a new key into hash during iteration
  # cart.each do |item|
  #    binding.pry
  #   if item[0].include?(coupons[0][:item])
  #     apply_coupons_hash << cart["AVOCADO W/COUPON"] = {:price => 5.0, :clearance => true, :count => 1}
  #   end
  # end
  # binding.pry
  # apply_coupons_hash

def apply_clearance(cart:[])
  # binding.pry
end

def checkout(cart: [], coupons: [])
  # code here
end