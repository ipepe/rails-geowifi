class Api::V1::WifiObservationReceiversController < ApplicationController
  protect_from_forgery except: :create
  def create
    WifiObservationsReceiverService.import(params_for_create)
  end

  private

  def params_for_create
    params.require(:wifi_observation_receiver).permit!
  end
end