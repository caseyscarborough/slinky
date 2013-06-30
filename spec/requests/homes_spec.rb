require 'spec_helper'

describe "Home Controller" do

  let(:base_title) { "Slinky" }

  describe "Index page" do

    it "should have the heading 'Welcome to Slinky!'" do
      visit '/home/index'
      page.should have_selector('h1', :text => 'Welcome to Slinky!')
    end

    it "should have the title 'Slinky | Welcome'" do
      visit '/home/index'
      page.should have_title('Slinky | Welcome')
    end

  end
end
