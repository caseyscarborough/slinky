require 'spec_helper'

describe "Link Pages" do

  describe "new link page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"
      visit new_link_path
    end

    subject { page }

    it { should have_title('Slinky | New Link') }
    it { should have_selector('h1', :text => 'New Link' ) }

    describe "with invalid information" do

      before { click_button "Create Link" }
      it { should have_selector('div#error') }

    end

    describe "with valid information" do
      before do
        fill_in "Short url", with: "short-url"
        fill_in "Long url", with: "www.google.com"
      end

      it "should create a new short link" do
        expect { click_button "Create Link" }.to change(Link, :count).by(1)
      end
    end
  end

end
