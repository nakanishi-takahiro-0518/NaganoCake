class Admins::GenresController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_all_genre, only: [:index, :create]
    before_action :set_genre, only: [:edit, :update]

    def index
        @genre = Genre.new
    end
    
    def create
        @genre = Genre.new(genre_params)
        @genre.save ? (redirect_to admins_genres_path) : (render :index)
    end
    
    def edit
    end
    
    def update
        if @genre.update(genre_params)
            if @genre.is_active == false
                @genre.items.update_all(is_active: false)
            end
            redirect_to admins_genres_path
        else
            render :edit
        end
    end
    
    private

    def genre_params
        params.require(:genre).permit(:name, :is_active)
    end
    
    def set_all_genre
        @genres = Genre.all
    end
    
    def set_genre
        @genre = Genre.find(params[:id])
    end
    
end
