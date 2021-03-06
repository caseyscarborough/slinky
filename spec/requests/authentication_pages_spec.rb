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

      it { should have_title("Slinky | Dashboard") }
      it { should have_css('#nav-logout') }
      it { should_not have_css('#nav-login') }

      describe "followed by signout" do
        before { find("#nav-logout > a").click }
        it { should have_css('.icon-signin') }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit profile_path }
          it { should have_title('Slinky | Login') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(login_path) }
        end

        describe "when attempting to visit a protected page" do
          before do
            visit profile_path
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do
            it { should have_title('Slinky | Dashboard') }
          end
        end

      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@user.com') }
      before do
        sign_in user
      end

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title("Slinky | Edit User") }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to root_path }
      end

    end

  end

end

