class PttController < ApplicationController
require "open-uri"
require "nokogiri"
require "uri"
require 'erb'
  
  def index


  end
  
  $name=""
  def search 
    @board=params[:search]
    @keyword = params[:keyword]
    if @board!=$name   #initial database
      Article.delete_all
      $name = @board
      OriginNumber.delete_all
      $originCount = 0
      $diff = 0
    end 
    @main = Nokogiri::HTML(open("https://www.ptt.cc/bbs/#{@board}/index.html"))
    @main.css(".r-ent").each do |m|
      if m.css('div.title a').map{ |link| link['href']}.join(",")==""
        next
      end
      if !m.at_css(".title > a").text.include? "#{@keyword}"
        next
      end
      hrefpart = m.css('div.title a').map{ |link| link['href']}.join(",")
      href = "https://www.ptt.cc"+ hrefpart
      if !Article.exists?(href:"#{href}")
        @articles = Article.create(:name => m.at_css(".title > a").text , :href => href )
      end
      

    end    
    $all = Article.all
      if OriginNumber.first.nil?
        OriginNumber.create(:number => $all.count)
        $originCount = OriginNumber.first.number
      end
      $diff = Article.count - $originCount


    respond_to do |format|
            format.js
    end  
  end
  
  def delete
    Article.delete_all
    OriginNumber.delete_all
  end


end
