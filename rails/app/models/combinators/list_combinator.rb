# = The ListCombinator
#
# Combines each of the results into a single list.
class Combinators::ListCombinator < Combinator

  def base_value
    []
  end

  def combine( previous_array, new_element )
    previous_array << new_element
    previous_array
  end

end
