#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

require "rubygems"
require "net/http"
require "nokogiri"

class Furigana
  def initialize(sentence=nil, grade=nil)
    @sentence = sentence
    @app_id = "UiepUEKxg666SAyFxsBpxR_VE9A_qsPVG_yyUJ8R8RIBRhRt8nJ2buvmiEBiuP6sQoOQ6ks.DuPQozY-"
    @grade = grade
    @grade = "3" unless grade
    @xml = ""
  end

  def get_furigana
    begin
      Net::HTTP.start('jlp.yahooapis.jp', 80) { |http|
        response = http.post(
          "/FuriganaService/V1/furigana",
          "appid=#{@app_id}&grade=#{@grade}&sentence=#{@sentence}"
        )
        response
      }
    rescue Net::HTTPBadRequest
      return "HTTP Error"
    end
    return response
  end

  def return_instance_var
    instance_vars = {
      "sentence" => @sentence,
      "grade" => @grade,
      "app_id" => @app_id
    }
  end

  def return_xml
    get_furigana
    doc_xml = Nokogiri::XML(@xml)
    words = doc_xml.css("Word")
    words.each do |word|
      unless word.css("Furigana").nil?
        puts word
      end
    end
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
f.get_furigana.body
