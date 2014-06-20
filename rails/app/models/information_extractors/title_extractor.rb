class InformationExtractors::TitleExtractor < InformationExtractor

  def extract( response , body )
    parsed = Nokogiri.parse body
    parsed.css("title").first.text
  end

end
