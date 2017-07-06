class StaticController < ApplicationController
  PAGES = [ :manual, :about, :privacy, :credits]
  PAGES.each do |page|
    define_method page do

    end
  end

  def mobile_app
    redirect_to 'https://play.google.com/store/apps/details?id=pl.ipepe.android.geowifi'
  end
end