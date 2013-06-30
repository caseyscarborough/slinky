require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1', :text => "Login") }
    it { should have_title('Slinky | Login') }

    describe "with invalid information" do
      before { click_button "Sign in" }
      it { should have_title('Slinky | Login') }
      it { should have_selector('div.alert.alert-error', :text => "could not be found")}
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email.downcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link('Logout', href: logout_path) }
      it { should_not have_link('Login', href: login_path) }

      describe "followed by signout" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end
  end

end

