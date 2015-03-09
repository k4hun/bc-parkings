class PlaceRentsController < ApplicationController
  before_action :authenticate_user

  def index
    @rents = PlaceRent.all
  end

  def show
    @rent = PlaceRent.find_by!(identifier: params[:id])
  end

  def new
    @rent = parking.place_rents.new
  end

  def create
    @rent = parking.place_rents.new(place_rent_params)
    @rent.car = current_person.cars.find(place_rent_params[:car_id])
    if @rent.save
      redirect_to parkings_path, notice: "Place rented!"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  private

  def parking
    @parking ||= Parking.find(params[:parking_id])
  end

  def place_rent_params
    params.require(:place_rent).permit(:starts_at, :ends_at, :car_id)
  end
end
