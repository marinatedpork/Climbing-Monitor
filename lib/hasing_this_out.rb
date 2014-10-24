# gets the space class

s = Scraper.new('http://mountainproject.com/v/soft-n-pretty/106079464', 'span.rateYDS').page_data.xpath('text()')



s = Scraper.new('http://mountainproject.com/v/paper-or-plastic/106960952', 'span.rateYDS').page_data.xpath('text()')

def return_rating(nodes)
  if page_data.search('span.rateYDS').xpath('text()').empty?
    ratings = page_data.search('span.rateHueco').xpath('text()').delete_if? { |node| node.blank?}
    return ratings[0]
  end
  page_data.search('span.rateYDS').xpath('text()').empty?
  ratings = page_data.search('span.rateHueco').xpath('text()').delete_if? { |node| node.blank?}
  return ratings[0]
end
