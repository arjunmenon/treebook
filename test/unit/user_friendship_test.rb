require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
	should belong_to(:user)
	should belong_to(:friend)

	test "that creating a friendship works without raising an assertion" do
		assert_nothing_raised do
			UserFriendship.create user: users(:arjun), friend: users(:anirudh)
		end
	end

	test "that creating a friendship based on user id and friend id works" do
		UserFriendship.create user_id: users(:arjun).id, friend_id: users(:anirudh).id
		assert users(:arjun).friends.include?(users(:anirudh))
	end

end
