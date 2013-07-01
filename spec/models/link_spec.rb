require 'spec_helper'

describe "Link" do

  let(:user) { FactoryGirl.create(:user) }
  before { @link = user.links.build(short_url: "short",
              long_url: "http://google.com",
              total_clicks: 0, last_visited:nil) }

  subject { @link }

  it { should respond_to(:short_url) }
  it { should respond_to(:long_url) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  it { should respond_to(:total_clicks) }
  it { should respond_to(:last_visited) }

  describe "when user_id is not present" do
    before { @link.user_id = nil }
    it { should_not be_valid }
  end

  describe "when short url is not present" do
    before { @link.short_url = nil }
    it { should_not be_valid }
  end

  describe "when long url is not present" do
    before { @link.long_url = nil }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Link.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when short url is too long" do
    before { @link.short_url = "a" * 21 }
    it { should_not be_valid }
  end

end
