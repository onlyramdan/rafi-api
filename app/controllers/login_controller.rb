class LoginController < ApplicationController
    def index
        str =  "**********************************************\n"
        str += "**********************************************\n"
        str += "***          API IoT MongoDB Server        ***\n"
        str += "***          (c)2023 iNTERN MTM            ***\n"
        str += "***           Tugas Akhir TEK 57           ***\n"
        str += "**********************************************\n"
        str += "**********************************************"
        render plain: str

    end

    def login
        begin
            res_user = User.find_by(email: params[:email], password: params[:password])
            
            if res_user
                data = {
                    id: res_user["_id"].to_s,
                    email: res_user['email'],
                    nama: res_user['nama'],
                    password: res_user['password'],
                    user_role: res_user.user_role['user_role']
                }
                if res_user['status'].to_s != "1"
                    render json: {
                        status: false,
                        message: "User tidak aktif!, Silahkan hubungi administrator",
                        content: nil
                    } 
                else
                    render json: {
                        status: true,
                        message: "Berhasil Login",
                        content: data
                    }
                end
            else
                render json: {
                        status: false,
                        message: "Email atau Password Salah",
                        content: nil
                    } , status: :not_found
            end
        rescue Mongoid::Errors::DocumentNotFound
            render json: {
            status: false,
            message: "Email atau Password Salah",
            content: nil
            }, status: :not_found
        end
    end

    # def login
    #     # Mengambil nilai hashed_password dari params
    #     hashed_password = params[:hashed_password]
        
    #     user = User.find_by(email: login_params[:email])
      
    #     if user && user.password == hashed_password
    #       # Berhasil masuk
    #       render json: {
    #         status: true,
    #         message: "Berhasil Login",
    #         content: user
    #       }
    #     else
    #       render json: {
    #         status: false,
    #         message: "Email atau Password Salah",
    #         content: nil
    #       }, status: :unauthorized
    #     end
    # end
      
    
    # def login_params
    #     params.require(:user).permit(:email, :hashed_password)
    # end
      
    def login_params
        params.permit(:email, :password)
    end
end
