class Array

  def trailed_walk( include_empty: true )
    arr = []
    yield arr if include_empty

    self.each do |item|
      arr << item
      yield arr
    end
  end

end
