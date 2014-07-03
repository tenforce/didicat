# Extracts the title of the page from a text/html response
class InformationExtractors::TitleExtractor < InformationExtractor

  def extract( response )
    Nogokiri.parse(response).css("title").first.text
  end

end
