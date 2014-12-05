require 'spec_helper'

describe LanguagesController do

  describe "GET show" do
    it "sets the @language" do
      language = Fabricate(:language)
      get :show, id: language.id
      expect(assigns(:language)).to eq(language)
    end
  end

end