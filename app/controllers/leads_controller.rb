class LeadsController < ApplicationController
  # GET /leads/new (This action is technically not used anymore since the form is on the home page, but it's harmless)
  def new
    @lead = Lead.new
  end

  # POST /leads
  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      # 1. Success: Redirect back to the homepage (root_path) with a success message.
      redirect_to root_path, notice: "Thank you for your interest! We will contact you shortly."
    else
      # 2. Failure: CRITICAL FIX.
      # We must render the 'home/index' view directly so that the @lead object (which now contains the errors) 
      # is passed to the homepage template, allowing the form to display error messages.
      render 'home/index', status: :unprocessable_entity 
    end
  end

  private

  # Strong parameters: Essential security practice to allow only specific, safe fields to be mass-assigned.
  def lead_params
    # Check if the :lead key exists. If so, use standard strong parameters.
    if params[:lead]
      params.require(:lead).permit(:name, :email, :country, :message)
    else
      # If :lead key is missing (a common issue with Turbo/JS form handling),
      # assume the parameters are at the top level and permit them directly.
      params.permit(:name, :email, :country, :message)
    end
  end
end
