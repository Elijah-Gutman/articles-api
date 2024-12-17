class ArticlesController < ApplicationController
  def index
    response = HTTP
      .headers("Authorization" => "Bearer #{ENV["NEWS_API_KEY"]}")
      .get("https://newsapi.org/v2/everything?q=#{params[:search_terms]}")
    data = response.parse
    articles = data["articles"]
    render json: articles.uniq { |article| article["url"] }.map { |article| article.merge("id" => article["url"]) }
  end
end
