require 'open-uri'
require 'pry'
require 'nokogiri'


class Scraper

   attr_accessor :name, :location, :profile_url


  def self.scrape_index_page(index_url)	  
    
      students = []
    
      doc = Nokogiri::HTML(open(index_url))

      doc.css("div.roster-cards-container").each do |item|
        item.css(".student-card a").each do |student_card|
          student_name = student_card.css(".student-name").text
          student_location = student_card.css(".student-location").text
          student_profile_url = "#{student_card.attr('href')}"
          students << {name: student_name, location: student_location, profile_url: student_profile_url}
        end
      end
    students
  end

  def self.scrape_profile_page(profile_url)

     student = {}
     
    doc = Nokogiri::HTML(open(profile_url))

     doc.css(".social-icon-container").each do |item|
        item.css("a").each do  |content|
        social_link = content.attr('href')
          if social_link.include?("twitter")
            student[:twitter] = social_link
          elsif social_link.include?("linkedin")
            student[:linkedin] = social_link
          elsif social_link.include?("github")
            student[:github] = social_link
          else
            student[:blog] = social_link      
        end
    
      end  

    student[:profile_quote] = doc.css(".profile-quote").text.gsub("\\","") if doc.css(".profile-quote").text
    student[:bio] = doc.css(".description-holder p").text if doc.css(".description-holder p").text

    return student
  end	
    
  end
    
end
