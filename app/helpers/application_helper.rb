module ApplicationHelper
  class ::Object
    @@pry_me_debug = true
    def pry_me
      binding.pry if @@pry_me_debug
    end
  end
end
