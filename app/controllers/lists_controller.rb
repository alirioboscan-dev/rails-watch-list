class ListsController < ApplicationController
  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
    @bookmark = Bookmark.new
    @movies = Movie.all
    @review = Review.new
    @reviews = @list.reviews.order(created_at: :desc)
  end

  def new
    @list = List.new
  end

  def create
  @list = List.new(list_params)
  if @list.save
    if params[:movie_id].present?
      Bookmark.create(list: @list, movie_id: params[:movie_id], comment: "Added from Movies")
    end
    redirect_to list_path(@list), notice: "List created successfully!"
  else
    render :new, status: :unprocessable_entity
  end

  def search
  @lists = List.where("name ILIKE ?", "%#{params[:query]}%").limit(8)
  render json: @lists.map { |l| { id: l.id, name: l.name } }
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      redirect_to list_path(@list), notice: "List updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  end

  private

  def list_params
    params.require(:list).permit(:name, :image_url)
  end
end
