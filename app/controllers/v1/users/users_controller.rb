# frozen_string_literal: true

module V1
  module Users
    class UsersController < BaseController
      before_action :set_user, except: %i[index create]

      def index
        users_index = make_index(Indexes::User, User.all)
        render json: UserSerializer.new(
          users_index.filtered,
          users_index.options
        )
      end

      def show
        render json: UserSerializer.new(
          @user,
          include: Indexes::User::INCLUDES.dup
        )
      end

      def create
        new_user = ::Users::New.call(user_params).user

        authorize new_user

        ::Users::Save.call(user_params, current_user, new_user)

        render json: UserSerializer.new(
          new_user,
          params: { visibility_helper: SerializerVisibilityHelper.new(current_user) }
        ), status: :created
      end

      def update
        authorize @user

        ::Users::Update.call(user_params, current_user, @user)

        render json: UserSerializer.new(
          @user,
          params: { visibility_helper: SerializerVisibilityHelper.new(current_user) }
        )
      end

      def deactivate
        authorize @user, :deactivate_user?

        ::Users::Deactivate.call(@user)

        render json: UserSerializer.new(
          @user.reload,
          params: { visibility_helper: SerializerVisibilityHelper.new(current_user) }
        )
      end

      def resend_activation_email
        authorize @user, :resend_activation_email?

        ::Users::ResendActivationEmail.call(@user)

        head :ok
      end

      def send_reset_password_email
        authorize @user, :send_reset_password_email?

        ::Users::SendResetPasswordEmail.call(@user)

        head :ok
      end

      def set_user
        @user = ::Users::Show::WithDeactivation.call(params[:id]).user
      end

      def user_params
        params.permit(data: {}).to_h
      end
    end
  end
end

