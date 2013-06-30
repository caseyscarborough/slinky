require 'spec_helper'

describe "User Pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }
    it { should have_selector('h1', :text => 'Sign Up')}
    it { should have_title('Slinky | Signup')}
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1', :text => user.first_name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }
    let(:submit) { "Create account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    end    describe "with valid information" do
      before do
        fill_in "First name", with: "Test"
        fill_in "Last name", with: "User"
        fill_in "Email", with: "test@user.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

    end

end
