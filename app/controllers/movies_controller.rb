class MoviesController < ApplicationController
  def index
    @movies = Movie.order(:title)
    @lists = List.all
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to movies_path, notice: "Movie added successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @movies = Movie.where("title ILIKE ?", "%#{params[:query]}%").limit(8)
    render json: @movies.map { |m|
      { id: m.id, title: m.title, poster_url: m.poster_url, rating: m.rating }
    }
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :poster_url, :rating)
  end
end
