class Hash

  def empty_merge!( hash )
    hash.each do |k , v|
      self[k] = v unless v.respond_to?( :empty? ) and v.empty?
    end
  end

end
