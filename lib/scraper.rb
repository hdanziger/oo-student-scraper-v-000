
require 'open-uri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url = "http://students.learn.co/")
    #binding.pry
    index_page = Nokogiri::HTML(open("http://students.learn.co/"))
    students = []
    index_page.css(".roster-cards-container").each do |card|
      card.css(".student-card").each do |student|
        student_name = student.css('.student-name').text
        student_location = student.css('.student-location').text
        student_profile_url = "students.learn.co/students/#{student.attr('href')}.html"
        students << {name: student_name, location: student_location, profile_url: student_profile_url}
    end
  end
  students
end

def self.scrape_profile_page(profile_url = "http://students.learn.co/students/laura-correa.html")
  student = {}
  profile_page = Nokogiri::HTML(open("http://students.learn.co/students/laura-correa.html"))
  links = profile_page.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
  links.each do |link|
    if link.include?("linkedin")
      student[:linkedin] = "https://www.linkedin.com/in/laura-correa-865680111"
      student[:github] = "https://github.com/lcorr8"
    elsif link.include?("twitter")
      student[:twitter] = "https://twitter.com/L_corr"
    else
      student[:blog] = link
    end
  end

  student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
  student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

  student
  end
end
