#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

require "rubygems"
require "net/http"
require "nokogiri"

class Furigana
  attr_writer :sentence, :grade

  def initialize
    @app_id = "UiepUEKxg666SAyFxsBpxR_VE9A_qsPVG_yyUJ8R8RIBRhRt8nJ2buvmiEBiuP6sQoOQ6ks.DuPQozY-"
  end

  def get_furigana
    begin
      Net::HTTP.start('jlp.yahooapis.jp', 80) { |http|
        response = http.post(
          "/FuriganaService/V1/furigana",
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
    xml = get_furigana.body
    doc_xml = Nokogiri::XML(xml)
    result = []
    words = doc_xml.css("Word")
    words.each do |word|
      phrase = Hash.new
      phrase["#{word.css("Surface").text}"] = word.css("Furigana").text
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

f = Furigana.new
f.grade = 3
f.sentence = str
f.return_charactar_pair.each do |r|
  if r.values[0] != ""
    puts "#{r.keys[0]}(#{r.values[0]})"
  else
    puts r.keys[0].class.name
  end
end
