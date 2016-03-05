---
layout: false
---
@articles ||= blog.articles[0..10]
xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = "https://blog.diacode.com"
  xml.title "Diacode's blog – #{@tagname}"
  xml.subtitle "posts tagged with #{@tagname}"
  xml.id site_url
  xml.link "href" => site_url
  xml.link "href" => site_url, "rel" => "self"
  xml.updated @articles.first.date.to_time.iso8601
  xml.author do
    xml.name "Diacode"
  end

  @articles.each do |article|
    url = URI.join(site_url, article.url.gsub('/blog', ''))

    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => url
      xml.id url
      # xml.published article.date.to_time.iso8601
      # xml.updated File.mtime(article.source_file).iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name article.data.author }
      # xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end
