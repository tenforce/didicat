# = The SmartListCombinator
#
# Concatenates list responses and appends object responses.
class Combinators::SmartListCombinator < Combinator

  def base_value
    []
  end

  def combine( previous_array, new_value )
    if new_value.class == Array
      new_value.each do |elt|
        previous_array << elt
      end
    else
      previous_array << new_value
    end

    previous_array
  end

end
