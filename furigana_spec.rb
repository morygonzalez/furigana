#-*- coding: utf-8 -*-
require "rspec"
require "./furigana"

describe Furigana do
  before(:all) do
    @furigana = Furigana.new
    @furigana.sentence = "魑魅魍魎"
  end

  describe "#get_furigana" do
    it "HTTPステータスが200であること" do
      @furigana.get_furigana.code.should == "200"
    end

    it "レスポンスのエンティティボディがXMLであること" do
      @furigana.get_furigana.body.should match(/<?xml/)
    end
  end

  describe "#return_character_pair" do
    subject { @furigana.return_character_pair }
    
    it "返り値はStringであること" do
      subject.should be_instance_of(String)
    end

    it "スペースが無視されていないこと" do
      blank_str = " "
      subject.should have_at_least(1).blank_str
    end

    it "改行文字を含むこと" do
      br_word = "\n"
      subject.should have_at_least(1).br_word
    end
  end
end
