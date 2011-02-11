#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

$KCODE = "UTF-8"

require "rubygems"
require "net/http"
require "nokogiri"
require "cgi"
require "json"

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
          "appid=#{@app_id}&grade=#{@grade}&sentence=#{CGI.escape(@sentence)}"
        )
        @response = response
      }
    rescue => ex
      @response = "HTTP Error #{ex}"
    end
    return @response unless @response.nil?
  end

  def return_character_pair
    xml = get_furigana.body
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

  def remove_kanakana
    ary = return_character_pair.split("\n")
    result = []
    ary.each do |str|
      m_ary = str.scan %r|[\(（](.+?)[\)）]|
      u_ary = m_ary.uniq.flatten
      i = 0
      while i < u_ary.length
        str.sub!(/([\(（]#{u_ary[i]}[\)）]){2}/, "\\1")
        i += 1
      end
      result << str
    end
    result.join("\n")
  end
end

cgi = CGI.new
str = cgi.params['val'][0]
str = <<EOD unless cgi.params['val'][0]
データを入力してください
EOD
y = Furigana.new
y.grade = 3
y.sentence = str
cgi.out("application/json") {
  { 
    :text_output => y.remove_kanakana,
    :ruby_version => RUBY_VERSION
  }.to_json
}
