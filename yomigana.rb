#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

require "rubygems"
require "net/http"
require "nokogiri"
require "cgi"

class Yomigana
  attr_writer :sentence, :grade

  def initialize
    @app_id = "UiepUEKxg666SAyFxsBpxR_VE9A_qsPVG_yyUJ8R8RIBRhRt8nJ2buvmiEBiuP6sQoOQ6ks.DuPQozY-"
  end

  def get_yomigana
    begin
      Net::HTTP.start('jlp.yahooapis.jp', 80) { |http|
        response = http.post(
          "/FuriganaService/V1/furigana",
          "appid=#{@app_id}&grade=#{@grade}&sentence=#{@sentence}"
        )
        @response = response
      }
    rescue => ex
      @response = "HTTP Error #{ex}"
    end
    return @response unless @response.nil?
  end

  def return_character_pair
    xml = get_yomigana.body
    doc_xml = Nokogiri::XML(xml)
    result = []
    words = doc_xml.css("WordList Word")
    words.each do |word|
      if word.css("Furigana").text == ""
        phrase = word.css("Surface").first.text
      else
        phrase = word.css("Surface").first.text, "（",  word.css("Furigana").first.text, "）"
      end
      result << phrase
    end
    result.join('')
  end
end

str = ARGV[0]
str = <<EOD unless ARGV[0]
<html>
  <head>
    <title>ポケモンだいすきクラブ</title>
  </head>
  <body>
    <p class="pokemon">Pokemon大好き倶楽部</p>
  </body>
</html>
EOD

y = Yomigana.new
y.grade = 3
y.sentence = str
puts y.return_character_pair
