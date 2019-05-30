class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @movies= Movie.all
    @sort_by= params[:sort_by] || session[:sort_by]
    @all_ratings= Movie.order(:rating).select(:rating).map(&:rating).uniq
    @ratings =params[:ratings]||session[:ratings]
    
    if(@ratings)
      session[:ratings]=@ratings
      @movies= Movie.where(rating: @ratings.keys)  
    end
    
    if(@sort_by)
      session[:sort_by]=@sort_by
      @movies= @movies.order(@sort_by)
    end
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  # add to movies_controller.rb, anywhere inside
  #  'class MoviesController < ApplicationController':
  
  def search_tmdb
    # hardwire to simulate failure
    flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
    redirect_to movies_path
  end

end
