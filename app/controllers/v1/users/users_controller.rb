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
        new_user = User.new(user_params)
        new_user.save!

        render json: UserSerializer.new(
          new_user
        ), status: :created
      end

      def update
        user = User.find(params[:id])

        attributes = params.require(:data)
                           .require(:attributes)

        return head 400 unless attributes.key?(:first_name) ||
          attributes.key?(:last_name) ||
          attributes.key?(:email) ||
          attributes.key?(:password)

        raise Exceptions::UserNotAuthorizedToPerformThisAction if attempting_self_update(user)

        user.update!(attributes.permit(:first_name, :last_name, :email, :password).to_h.compact)

        render json: UserSerializer.new(user)
      end

      def destroy
        user = User.find(params[:id])
        user.destroy!
        head 204
      end

      private

      def attempting_self_update(user)
        user == current_user
      end

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:data).require(:attributes).permit(:first_name, :last_name, :email, :password)
      end
    end
  end
end

