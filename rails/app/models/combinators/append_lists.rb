# = The AppendLists combinator
#
# Assumes each of the responses is a list and combines them into a single list.
class Combinators::AppendLists < Combinator

  def base_value
    []
  end

  def combine( previous_array, new_array )
    new_array.each do |elt|
      previous_array << elt
    end

    previous_array
  end

end
