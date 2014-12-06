require 'spec_helper'

describe Language do
  
  it { should validate_presence_of(:name) }
  it { should have_many(:skills).order(helped_total: :desc) }

  describe "#total_skills" do
    
    it "returns 0 when no skills are attached to language" do
      html          = Fabricate(:language)
      expect(html.total_skills).to be nil
    end

    it "returns int when # of skills are attached to language" do
      html          = Fabricate(:language)
      pds_to_html   = Fabricate(:skill, language: html)
      html_beginner = Fabricate(:skill, language: html)
      expect(html.total_skills).to eq(2)
    end

  end

end