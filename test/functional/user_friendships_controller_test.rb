require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
	context "#new" do
		context "when not logged in" do
			should "redirect to the login page" do
				get :new
				assert_response :redirect
			end
		end

		context "when logged in" do
			setup do
				sign_in users(:arjun)
			end

			should "get new and return success" do
				get :new
				assert_response :success
			end	

			should "set a flash error if friend_id params is missing" do
				get :new, {}
				assert_equal "Friend required", flash[:error]
			end

			should "display the friends name" do
				get :new, friend_id: users(:arunima)
				assert_match /#{users(:arunima).full_name}/, response.body
			end

			should "assign a new user friendship" do
				get :new, friend_id: users(:arunima)
				assert assigns(:user_friendship)
			end

			should "assign a new user friendship to the correct friend" do
				get :new, friend_id: users(:arunima)
				assert_equal users(:arunima), assigns(:user_friendship).friend
			end

			should "assign a new user friendship to the correctly logged in user" do
				get :new, friend_id: users(:arunima)
				assert_equal users(:arjun), assigns(:user_friendship).user
			end

			should "returns a 404 status if no friend is found"	do
				get :new, friend_id: 'invalid'
				assert_response :not_found
			end

			should "ask if u really want to friend the user" do
				get :new, friend_id: users(:arunima)
				assert_match /Do you really want to friend #{users(:arunima).full_name}?/, response.body
			end
		end
	end

	context "#create" do
		context "when not logged in" do
			should "redirect to the login page" do
				get :new
				assert_response :redirect
				assert_redirected_to login_path
			end
		end

		context "when logged in" do
			setup do
				sign_in users(:arjun)
			end
		
			context "when no friend_id" do
				setup do
					post :create
				end

				should "set the flash error message" do
					assert !flash[:error].empty?
				end

				should "redirected to the site root path" do
					assert_redirected_to root_path
				end
			end

			context "with a valid friend_id" do
				setup do
					post :create, user_friendship: { friend_id: users(:anirudh) }
				end

				should "assign a friend object" do
					assert assigns(:friend)
					assert_equal users(:anirudh), assigns(:friend)
				end

				should "assign a user_friendship object" do
					assert assigns(:user_friendship)
					assert_equal users(:arjun), assigns(:user_friendship).user
					assert_equal users(:anirudh), assigns(:user_friendship).friend
				end

				should "create a friendship" do
					assert users(:arjun).friends.include?(users(:anirudh))
				end

				should "redirect to profile page of friend" do
					assert_response :redirect
					assert_redirected_to profile_path(users(:anirudh))
				end

				should "set the flash success message" do
					assert flash[:success]
					assert_equal "You are now friends with #{users(:anirudh).full_name}", flash[:success]
				end
			end
		end
	end
end