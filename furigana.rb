#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

require "rubygems"
require "net/http"
require "uri"
require "nokogiri"
require "json"

class Furigana
  def initialize(sentence=nil, grade=nil)
    @sentence = sentence
    @sentence = URI.escape("魑魅魍魎") unless sentence
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
        @xml = response.body
      }
    rescue Net::HTTPBadRequest
      return "HTTP Error"
    end
  end

  def return_instance_var
    instance_vars = {
      "sentence" => @sentence,
      "grade" => @grade,
      "app_id" => @app_id
    }
  end

  def return_xml
    doc_xml = Nokogiri::XML(@xml)
    doc_xml.css('Word').each do |x|
      p x.inner_html
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

f = Furigana.new(str, 3)
f.return_xml
