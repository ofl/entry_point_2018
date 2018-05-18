class ArticlesController < ApplicationController
  layout 'plain'
  before_action :authenticate_user!

  def index
    @articles = current_user.articles.order(created_at: :desc).page(params[:page])
  end

  def show
    @article = current_user.articles.find(params[:id])
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to authenticated_root_path, notice: t('.success')
    else
      render 'edit'
    end
  end

  def edit
    @article = current_user.articles.find(params[:id])
  end

  def update
    @article = current_user.articles.find(params[:id])

    if @article.update(article_params)
      redirect_to authenticated_root_path, notice: t('.success')
    else
      render 'edit'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
