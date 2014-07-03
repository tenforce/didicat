# Extracts the title of the page from a text/html response
class InformationExtractors::TitleExtractor < InformationExtractor

  def extract( response )
    title = Nokogiri.parse(response).css("title").first
    title.text if title
  end

end
