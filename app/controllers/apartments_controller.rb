class ApartmentsController < ApplicationController
  # before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    apartments = Apartment.all
    render json: apartments
  end

  def create
    # create a new apartment
    apartment = Apartment.create(apartment_params)
    if apartment.valid?
      # respond with new apartment
      render json: apartment
    else
      render json: apartment.errors, status: unprocessable_entity
    end
  end

  def show
    apartment = Apartment.find_by(id: params[:id])
    render json: apartment
  end

  def update
    apartment = Apartment.update(apartment_params)
    render json: apartment
  end

  def destroy
    apartment = Apartment.find_by(id: params[:id]).destroy
    render json: apartment
  end

  def apartment_params
    params.require(:apartment).permit(:street_1, :street_2, :city, :postal_code, :state, :country, :building_manager_name, :building_manager_phone, :building_manager_hours)
  end

end
