class UsersController < ApplicationController
  before_action :logged_in_user,only: [:index,:edit,:update,:destroy]
  before_action :correct_user,only: [:edit,:update]
  before_action :admin_user,only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)    # 実装は終わっていないことに注意!
    if @user.save
      #helperのlog_inメソッドを使用
      log_in @user
      flash[:success] = "よくきたな！ Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:succes] = "プロフィールを更新したよ"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザー削除したよ"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # beforeアクション
    
    #ログイン済みユーザーかどうか確認
    def logged_in_user
      #unless=無い限り。 条件式が偽の場合の処理を記述する。
      #if !logged_in? でもいけるが、unlessの方が簡潔に記述できる。
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください!"
        redirect_to login_url
      end
    end
    
    #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      #後置unless,falseが帰ってきたらrootへリダイレクト
      redirect_to(root_url) unless current_user?(@user)
    end
    
    #管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
