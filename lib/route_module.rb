module Route
  def links
    res = []
    @page_data.search('a').map {|link| res << link['href'] }
    return res.uniq.compact
  end

  def return_rating
    if page_data.search('span.rateYDS').xpath('text()').empty?
      ratings = page_data.search('span.rateHueco').xpath('text()').to_a.delete_if { |node| node.blank? }
      return ratings[0].text
    end
    page_data.search('span.rateYDS').xpath('text()').empty?
    ratings = page_data.search('span.rateYDS').xpath('text()').to_a.delete_if { |node| node.blank? }
    return ratings[0].text
  end

  def return_route_name
    page_data.search('h1.dkorange').text
  end

  def return_route_type
    page_data.search('div.rspCol table tr').first_element_child.text
  end
end
