class ParkingsController < ApplicationController
  def index
    @parkings = Parking.paginate(page: params[:page]).search(params)
  end

  def show
    @parking = current_parking
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "No such parking!"
    redirect_to parkings_path
  end

  def new
    @parking = Parking.new
    @parking.build_address
  end

  def create
    @parking = Parking.new(parking_params)
    if @parking.save
      redirect_to parkings_path, notice: 'Parking added!'
    else
      render 'new'
    end
  end

  def edit
    @parking = current_parking
  end

  def update
    @parking = current_parking
    if @parking.update_attributes(parking_params)
      redirect_to parking_path, notice: 'Parking updated!'
    else
      render 'edit'
    end
  end

  def destroy
    current_parking.destroy
    redirect_to parkings_path, alert: 'Parking destroyed!'
  end

  private

  def current_parking
    @current_parking ||= Parking.find(params[:id])
  end

  def parking_params
    params.require(:parking).permit(:places, :kind, :hour_price, :day_price, address_attributes: [:city, :street, :zip_code])
  end
end
