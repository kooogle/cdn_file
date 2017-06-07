class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    query = params[:query]
    @users = User.recent
    @users = @users.where("email LIKE '%#{query}%' OR nick_name LIKE '%#{query}%'") if query.present?
    @users = @users.paginate(:page => params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = '用户信息更新成功！'
      redirect_to admin_users_path
    else
      flash[:warn] = '请完善填写表单内容'
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = '用户信息删除成功'
    redirect_to :back
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:role)
    end
end
