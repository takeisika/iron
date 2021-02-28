class UsersController < ApplicationController
  before_action:ensure,{only:[:new,:create,:login_form,:login]}
  before_action:ensuring,{only:[:index,:show,:update,:edit]}
  before_action:ensured,{only:[:edit,:update]}

  def index
    @users=User.all
  end

  def new
    @user=User.new
  end


  def show
    @user=User.find_by(id: params[:id])
    @tasks=Task.where(user_id: params[:id])
  end

  def create
    @user=User.new(name: params[:username],email: params[:email],password: params[:password])
    if @user.save
    session[:user_id]= @user.id
    redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
  end


  def edit
    @user=User.find_by(id:params[:id])
  end

  def update
    @user=User.find_by(id:params[:id])
    
    if @user.update(user_params)
    flash[:notice]="編集しました"
    redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def login_form
  end

  def login
    @user=User.find_by(name: params[:username],email: params[:email],password: params[:password])
    if @user
      session[:user_id] =@user.id
      redirect_to("/")
      flash[:notice]="ログインしました。"
    else
      @error_message="ユーザー名またはパスワードが間違っています"
      @username=params[:username]
      @email=params[:email]
      @password=params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id]=nil
    redirect_to("/users/login_form")
  end

  private
  def user_params
    params[:user].permit(:name,:avator)
  end

  
end
