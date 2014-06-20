# Accepts all Friend and Kitten objects.
class NodeFilters::All < NodeFilter

  # Accept all Friend objects.
  def contact_friend?( request, friend )
    return true
  end

  # Accept all Kitten objects.
  def contact_kitten?( request, kitten )
    return true
  end

end
