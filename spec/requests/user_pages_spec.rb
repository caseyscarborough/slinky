require 'spec_helper'

describe "User Pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }
    let(:submit) { "Create account" }

    it { should have_selector('h1', :text => 'Sign Up')}
    it { should have_title('Slinky | Signup')}

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
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

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:link1) { FactoryGirl.create(:link, user: user, short_url: "asdf") }
    let!(:link2) { FactoryGirl.create(:link, user: user, short_url: "qwer") }

    before do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"
    end

    it { should have_content(user.name) }
    it { should have_title("Slinky | Dashboard") }

    describe "links" do
      it { should have_link(link1.short_url) }
      it { should have_link(link2.short_url) }
      it { should have_content(user.links.count) }
    end

  end

  describe "edit page" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_title('Slinky | Edit User') }
      it { should have_link('Change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      before do
        fill_in "First name", with: "New"
        fill_in "Last name", with: "Name"
        fill_in "Email", with: "new@email.com"
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_title("Slinky | Dashboard") }
      it { should have_link('Logout') }
      it { should have_selector('div.alert.alert-success') }
      specify { user.reload.name.should == "New Name" }
      specify { user.reload.email.should == "new@email.com" }
    end

  end
end
