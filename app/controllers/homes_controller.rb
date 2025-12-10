class HomesController < ApplicationController
  def index
	@lead = Lead.new 
  end
end
