class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show

    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end



def create
  @user = User.new(user_params)

  respond_to do |format|
    if @user.save
      format.html { redirect_to @user, notice: 'User was successfully created.' }
      format.json { render :show, status: :created, location: @user }
    else
      format.html { render :new }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end

def update
  respond_to do |format|
    if @user.update(user_params)
      format.html { redirect_to @user, notice: 'User was successfully updated.' }
      format.json { render :show, status: :ok, location: @user }
    else
      format.html { render :edit }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end

# DELETE /users/1
# DELETE /users/1.json
def destroy
  @user.destroy
  respond_to do |format|
    format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    format.json { head :no_content }
  end
end


    def following
      @title = "Following"
      @title = "List of people I am following"
      @user  = User.find(params[:id])
      @users = @user.following.paginate(page: params[:page])
      render 'show_follow'
    end


  def followers
    @title = "Followers"
    @title = "List of people that are following me"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'

  end


  def following?(other_user)
    friendships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    friendships.create!(followed_id: other_user.id)
  end

  def unfollow
    other_user = User.find(params[:id])
    if other_user
      friendship = Friendship.find_by_followed_id(other_user.id)
      if friendship
        friendship.destroy
        flash[:notice] = "You have unfollowed #{other_user.username}."
      else
        flash[:notice] = "Nothing to do here. You are not following #{other_user.username}"
      end
    end

    redirect_to users_url
  end


private
# Use callbacks to share common setup or constraints between actions.
def set_user
  @user = User.find(params[:id])
end

# Never trust parameters from the scary internet, only allow the white list through.
def user_params
  params.require(:user).permit(:name, :password)
end

end

