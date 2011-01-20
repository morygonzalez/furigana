#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

require "rubygems"
require "net/http"
require "nokogiri"

class Yomigana
  attr_writer :sentence, :grade

  def initialize
    @app_id = "UiepUEKxg666SAyFxsBpxR_VE9A_qsPVG_yyUJ8R8RIBRhRt8nJ2buvmiEBiuP6sQoOQ6ks.DuPQozY-"
  end

  def get_Yomigana
    begin
      Net::HTTP.start('jlp.yahooapis.jp', 80) { |http|
        response = http.post(
          "/YomiganaService/V1/Yomigana",
          "appid=#{@app_id}&grade=#{@grade}&sentence=#{@sentence}"
        )
        @response = response
      }
    rescue Net::HTTPBadRequest
      return "HTTP Error"
    end
    return @response unless @response.nil?
  end

  def return_charactar_pair
    xml = get_Yomigana.body
    doc_xml = Nokogiri::XML(xml)
    result = []
    words = doc_xml.css("Word")
    words.each do |word|
      phrase = Hash.new
      phrase["#{word.css("Surface").text}"] = word.css("Yomigana").text
      result << phrase
    end
    result
  end
end

str = <<EOD
<html>
  <head>
    <title>ポケモンだいすきクラブ</title>
  </head>
  <body>
    <p>Pokemon大好き倶楽部</p>
  </body>
</html>
EOD

y = Yomigana.new
y.grade = 3
y.sentence = str
y.return_charactar_pair.each do |r|
  if r.values[0] != ""
    puts "#{r.keys[0]}(#{r.values[0]})"
  else
    puts r.keys[0].class.name
  end
end
