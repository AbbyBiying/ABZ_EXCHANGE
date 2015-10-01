require "rails_helper"

RSpec.describe FollowsController, type: :controller do
  describe "POST #create" do
    it "current user follows another user" do
      follower = create(:user)
      followed_user = create(:user)
      sign_in(follower)
      p "Test 1: #{follower.id}"

      post :create, id: followed_user.id

      expect(response).to redirect_to followed_user
    end
  end

  describe "DELETE #destroy" do
    it "current unfollow another user" do
      follower = create(:user)
      followed_user = create(:user)
      sign_in(follower)
      followed_user.followers << follower
      p "Test 2: #{follower.id}"

      delete :destroy, id: followed_user.id

      expect(response).to redirect_to followed_user
    end
  end
end
