class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  # validates :email, uniqueness: true
  # GET /users
  def index
    @page = user_params["page"].present? ? user_params["page"].to_i : 1
    @limit = user_params["limit"].present? ? user_params["limit"].to_i : 10
    @keyword = user_params["keyword"].present? ? user_params["keyword"] : ''
  
    # Memuat semua user terlebih dahulu tanpa mempertimbangkan kata kunci
    users = User.all
    

    if @keyword.present?
      keyword_regex = /#{@keyword}/i
      # Jika kata kunci ada, filter berdasarkan kata kunci
      users = users.any_of(
        { nama: keyword_regex },
        { email: keyword_regex }
      )

      # users = users.any_of({ :nama => /.*#{@keyword}.*/i })
    end
  
    # Gunakan paging
    @users = users.page(@page).per(@limit)
  
    data_user = []
  
    @users.each do |user|
      data_array = {
        id: user._id.to_s,
        nama: user.nama,
        email: user.email,
        role: user.user_role.user_role,
        status: user.status
      }
      data_user.push(data_array)
    end
  
    meta = {
      next_page: @users.next_page,
      prev_page: @users.prev_page,
      current_page: @users.current_page,
      total_pages: @users.total_pages
    }
  
    result = {
      status: true,
      messages: 'Sukses',
      content: data_user,
      meta: meta
    }
  
    render json: result
  end
  
  
  def show_role
    user = User.find(params["id"])
    if user.present?
      data = {
        id: user._id.to_s,
        email:  user.email,
        role: user.user_role.user_role
      }
    end
    render json: data

  end
  def show
    if @user.present?
      data = {
        id: @user["_id"].to_s,
        email: @user['email'],
        nama: @user['nama'],
        password: @user['password'],
        user_role_id: @user['user_role_id'],
        user_role: @user.user_role['user_role']
      }
      render json: data
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: {
                    status: true,
                    massage: "Sign Up Berhasil",
                    content: @user
                }
    else
      render json: {
                    status: false,
                    massage: "Sign Up Tidak Berhasil",
                    errors: @user.errors.full_messages
                    # content: nil
                }
    end
  end

  # def create
  #   email = user_params[:email]
  
  #   existing_user = User.find_by(email: email)
  
  #   if existing_user
  #     render json: {
  #       status: false,
  #       message: "Email telah digunakan. Silakan gunakan email lain."
  #     }
  #   else
  #     @user = User.new(user_params)
  #     if @user.save
  #       render json: {
  #         status: true,
  #         message: "Sign Up Berhasil",
  #         content: @user
  #       }
  #     else
  #       render json: {
  #         status: false,
  #         message: "Sign Up Tidak Berhasil",
  #         errors: @user.errors.full_messages
  #       }
  #     end
  #   end
  # end
  

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json:{
        status: true,
        massage: "Update berhasil",
        content: @user
      }
    else
      render json: {
        status: false,
        massage: "Edit tidak berhasil",
        content: nil
      }
    end
  end

  # DELETE /users/1
  def destroy
    if @user.destroy(user_params)
      render json: {
        status: true,
        message: "Berhasil hapus",
        content: nil
        
      }
    else
      render json: {
          status: false,
          message: "Gagal hapus",
          content: nil
        }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:email, :password, :nama, :status, :user_role_id , :id, :page, :keyword, :limit)
    end
end

