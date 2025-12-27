class Api::V1::PostsController < ApplicationController

  before_action :authenticate_request, except: [:index, :show]
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  def index
    # posts = Post.page(params[:page]).per(5)
     posts = Post.includes(:user)
              .page(params[:page])
              .per(params[:per_page] || 5)

      render json: {
        data: PostSerializer.new(posts).serializable_hash[:data],
        meta: pagination_meta(posts)
      }
  end

  def show
    post = Post.find(params[:id])
    render json: PostSerializer.new(@post).serializable_hash
  end

  def create
    post = @current_user.posts.new(post_params)

    if post.save
      render json: {
        success: true,
        message: "Post created successfully",
        data: PostSerializer.new(post).serializable_hash[:data]
      }, status: :created
    else
      render json: {
        success: false,
        errors: post.errors
      }, status: :unprocessable_entity
    end
  end

  def update
    post = Post.find(params[:id])

    if post.update(post_params)
      render json: post
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :thumbnail)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user_id == @current_user.id
      render json: {
        success: false,
        error: "You are not authorized to perform this action"
      }, status: :forbidden
    end
  end


  def pagination_meta(collection)
  {
    page: collection.current_page,
    per_page: collection.limit_value,
    total_pages: collection.total_pages,
    total_count: collection.total_count
  }
  end

end
