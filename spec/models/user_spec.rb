require "rails_helper"

RSpec.describe User, :type => :model do
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:username)}
  it { should validate_presence_of(:password_digest)}
  it { should validate_presence_of(:location)}

  describe "#can_accept?" do
    # Classicist Test
    it "should return true if the listing has the offer" do
      location = Location.create!(city: "New York", state: "NY")
      user = User.create!(email: "abc@gmail.com", username: "jb", location: location, password_digest: "OIUYH")
      listing = Listing.create!(name: "pen", description: "black one", user: user)

      expect(user.can_accept?(listing)).to eql true
    end

    # Mockist Test
    it "should return true if the listing has the offer" do
      user = User.new
      listings = double("listings")
      offer = double("offer")

      expect(user).to receive(:listings).and_return(listings)
      expect(listings).to receive(:include?).with(offer).and_return(true)
      expect(user.can_accept?(offer)).to eql true
   end
  end

  describe "#includes_myself" do
    # Classicist Test
    it "should return an array of my and my followers' user IDs" do
      location = Location.create!(city: "New York", state: "NY")
      user1 = User.create!(email: "abc@gmail.com", username: "jb", location: location, password_digest: "OIUYHZ")
      user2 = user1.followed_users.create!(email: "abz@gmail.com", username: "jbz", location: location, password_digest: "OIUYHZZ")

      expect(user1.includes_myself).to eql [user1.id, user2.id]
    end

    # Mockist Test
    it "should return an array of my and my followers' user IDs" do
      user = User.new

      expect(user).to receive(:id).and_return(1)
      expect(user).to receive(:followed_user_ids).and_return([2, 3])
      expect(user.includes_myself).to eql [1, 2, 3]
    end
  end

  describe "#followings?" do
    # Classicist Test
    it "should return true if the current user is following a user" do
      location = Location.create!(city: "New York", state: "NY")
      user1 = User.create!(email: "abc@gmail.com", username: "jb", location: location, password_digest: "OIUYHZ")
      user2 = user1.followers.create!(email: "abz@gmail.com", username: "jbz", location: location, password_digest: "OIUYHZZ")

      expect(user2.followings?(user1)).to eql true
    end

    # Mockist Test
    it "should return true if the current user is following a user" do
      follower = User.new
      followed_user = double("followed_user")
      expect(followed_user).to receive(:followers).and_return([follower])
      expect(follower.followings?(followed_user)).to eql true
    end
  end

  describe "#follow" do
    # Classicist Test
    it "should add user to followers array" do
      location = Location.create!(city: "New York", state: "NY")
      user1 = User.create!(email: "abc@gmail.com", username: "jb", location: location, password_digest: "OIUYHZ")
      user2 = User.create!(email: "abz@gmail.com", username: "jbz", location: location, password_digest: "OIUYHZZ")
      user1.follow(user2)

      expect(user1.followed_users).to include user2
    end

    # Mockist Test
    it "should add user to followers array" do
      user = User.new
      followed_user1 = double("followed_user1")
      followed_user2 = double("followed_user2")
      my_followed_users = [followed_user2]

      expect(user).to receive(:followed_users).and_return(my_followed_users)

      user.follow(followed_user2)
      expect(my_followed_users).to include followed_user2
    end
  end

  describe "#unfollow" do
    # Classicist Test
    it "should remove the user from the followed_users array" do
      location = Location.create!(city: "New York", state: "NY")
      user1 = User.create!(email: "abc@gmail.com", username: "jb", location: location, password_digest: "OIUYHZ")
      user2 = User.create!(email: "abz@gmail.com", username: "jbz", location: location, password_digest: "OIUYHZZ")
      user3 = User.create!(email: "ab@gmail.com", username: "ab", location: location, password_digest: "OIUYHZZZ")

      user1.follow(user2)
      user1.follow(user3)
      user1.unfollow(user2)

      expect(user1.followed_users).to_not include user2
      expect(user1.followed_users).to include user3

    end

    # Mockist Test
    it "should remove the user from the followed_users array" do
      user = User.new
      followed_user = double("followed_user")
      followed_users = double("followed_users")

      expect(user).to receive(:followed_users).and_return(followed_users)
      expect(followed_users).to receive(:destroy).with(followed_user)

      user.unfollow(followed_user)
    end

  end
end
