require "rails_helper"

describe "create comment process", type: :feature do
  it "sucessfully create a comment" do
    valid_sign_in
    click_on "Listings"
    create_comment("nice!")
  end
end
