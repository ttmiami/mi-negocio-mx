class UsersController < ApplicationController
  before_filter :set_user
  layout 'session'

  def new
     @user = current_user
  end

  def create
  end

  def edit
    redirect_to root_path if current_user.nil?
    @user = current_user
  end


def update
 if current_user .admin?
        @user.update_attributes(update_attributes_admin)
         redirect_to dashboard_path, notice: t('flash.users.updated')
    else
    if @user.update_attributes(user_params)
       redirect_to edit_user_path, notice: t('flash.users.updated')
    else
      render :edit
    end
  end


  end


  def create
      @user = User.create(email: :email, password: :password, municipio_id: current_user.municipio, admin: true)
      if @user.save? 
        redirect_to edit_user_path, notice: t('flash.users.updated')
      else
         redirect_to edit_user_path, notice: t('FALLA')
      end

    end


   def destroy
      authorize User.find(params[:id])

      User.find(params[:id]).destroy
      respond_to do |format|
        format.html { redirect_to dashboard_dependencies_path notice: 'La dependencia fue borrada satisfactoriamente.' }
        format.json { head :no_content }
      end
       redirect_to edit_user_path, notice: t('flash.users.updated')
    end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :business_name,
      :address,
      :operation_license,
      :operation_license_file,
      :land_permission_file
    )
  end



  def update_attributes_admin
  params.require(:user).permit(
    :email,
    :password
    )
end


  def set_user
    @user ||= current_user
  end
end
