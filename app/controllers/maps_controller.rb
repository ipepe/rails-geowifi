class MapsController < ApplicationController
  def observations
    @without_container = true
  end

  def heat; end
end
