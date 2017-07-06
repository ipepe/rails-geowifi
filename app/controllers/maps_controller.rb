class MapsController < ApplicationController
  def observations
    @without_container = true
  end

  def all_observations
    @without_container = true
  end
end
