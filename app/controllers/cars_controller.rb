class CarsController < ApplicationController
  before_action :authenticate_user

  def index
    @cars = current_person.cars
  end

  def show
    @car = current_car
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "No such car!"
    redirect_to cars_path
  end

  def new
    @car = current_person.cars.new
  end

  def create
    @car = current_person.cars.new(car_params)
    if @car.save
      redirect_to cars_path, notice: 'Car created!'
    else
      render 'new'
    end
  end

  def edit
    @car = current_car
  end

  def update
    @car = current_car
    if @car.update_attributes(car_params)
      redirect_to car_path, notice: 'Car updated!'
    else
      render 'edit'
    end
  end

  def destroy
    current_car.destroy
    redirect_to cars_path, alert: 'Car destroyed!'
  end

  private

  def current_car
    @current_car ||= current_person.cars.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:model, :registration_number, :image)
  end
end
