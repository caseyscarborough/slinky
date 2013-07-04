require "spec_helper"

describe UserMailer do

  describe "welcome email" do

    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.welcome_email(user) }

    it "renders the subject" do
      mail.subject.should == "Thanks for signing up for Slinky!"
    end

    it "renders the receiver's email" do
      mail.to.should == [user.email]
    end

    it "renders the sender's email" do
      mail.from.should == ['noreply@slnky.me']
    end

    it "includes the user's name in the email" do
      mail.body.encoded.should match(user.first_name)
    end

    it "should include the login link" do
      mail.body.encoded.should match('http://slnky.me/login')
    end

  end
end
