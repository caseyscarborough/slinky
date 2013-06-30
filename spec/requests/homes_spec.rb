require 'spec_helper'

describe "Home Controller" do

  let(:base_title) { "Slinky" }

  describe "Index page" do
    subject { page }
    before { visit root_path }
    it "should have proper h1 and title" do
      page.should have_selector('h1', :text => 'Welcome to Slinky!')
      page.should have_title('Slinky | Welcome')
    end
  end
end
