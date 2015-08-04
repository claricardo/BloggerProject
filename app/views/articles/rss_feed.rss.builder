xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Blogger"
	xml.author "Ricardo Villegas"
    xml.description "A simple Ruby on Rails Blog application"
    xml.link articles_url

    for article in @articles
      xml.item do
        if article.title
          xml.title article.title
        else
          xml.title ""
        end
		if article.author != nil
          xml.author article.author.username
        else
          xml.author ""
        end
		
		text = article.body.slice(0, 50) << "..."	
		xml.description text
        xml.pubDate article.created_at.to_s(:rfc822) 	#.strftime('%F')
		xml.link article_url(article)
		xml.guid article.id
      end
    end
  end
end

      
		
		
        
		
		
        
        