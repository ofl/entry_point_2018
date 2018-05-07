class HomeController < ApplicationController
  def index
    @users = User.eager_load(:positive_points, :latest_article).all
    # @users = User.eager_load(:points, :latest_article).all
    # @users = User.eager_load(:latest_article).merge(Article.order('articles.created_at DESC')).order(:id).all
    # @users = User.eager_load(:latest_article).merge(Article.order('articles.created_at DESC')).all
    # @users = User.preload(:latest_article).all
    # # @users = User.eager_load(:latest_article)
    # @users = User.with_articles.eager_load(:latest_article).all
    # @users = User.eager_load(:latest_article)
    #              .select(
    #                :username,
    #                Article.arel_table[:title].as('as_article_title')
    #              )
    #              .merge(Article.order("articles.created_at DESC"))
    #              .all
  end
end
