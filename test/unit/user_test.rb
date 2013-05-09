require 'test_helper'

class UserTest < ActiveSupport::TestCase

should have_many(:user_friendships)
should have_many(:friends)

test "a user should enter a first name" do
	user=User.new
	assert !user.save
	assert !user.errors[:first_name].empty?
end

test "a user should enter a last name" do
	user=User.new
	assert !user.save
	assert !user.errors[:last_name].empty?
end

test "a user should enter a profile name" do
	user=User.new
	assert !user.save
	assert !user.errors[:profile_name].empty?
end

test "a user should should have a unique profile name" do
	user=User.new
	assert !user.save
	assert !user.errors[:profile_name].empty?
end

test "a user should have a profile name without any space" do
	user=User.new(first_name: 'Arjun', last_name: 'Menon', email: 'arjunmenon09@gmail.com')
	user.password=user.password_confirmation='asdfghasd'
	
	user.profile_name="my profile with spaces"
	assert !user.save
	assert !user.errors[:profile_name].empty?
	assert user.errors[:profile_name].include?("Must be formatted correctly.")
end

test "a user can have a correctly formatted profile name" do
	user=User.new(first_name: 'Arjun', last_name: 'Menon', email: 'arjunmenon09@gmail.com')
	user.password=user.password_confirmation='asdfghasd'

	user.profile_name='arjunmenon_009'
	assert user.valid?
end

test "no error is raised when trying to access a friend list" do
	assert_nothing_raised do
		users(:arjun).friends
	end
end

test "creating friendship on a user works" do
	users(:arjun).friends << users(:anirudh)
	users(:arjun).friends.reload
	assert users(:arjun).friends.include?(users(:anirudh))
end

test "that calling to_params on a user returns the profile_name" do
	assert_equal "arjunmenon", users(:arjun).to_param
end

end
