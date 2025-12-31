class LeadsController < ApplicationController
  def index
    @leads = Lead.all.order(created_at: :desc)
  end
  # GET /leads/new (This action is technically not used anymore since the form is on the home page, but it's harmless)
  def new
    @lead = Lead.new
  end

  # POST /leads
  def create
    @lead = Lead.new(lead_params)

  #  if @lead.save
      #0.
      # --- NEW LINE: Trigger the Mailer ---
  #    LeadMailer.new_lead_notification(@lead).deliver_later
      # ------------------------------------
      # 2. Confirmation to User (New)
  #    LeadMailer.confirmation_email(@lead).deliver_later # <--- ADD THIS LINE

      # 1. Success: Redirect back to the homepage (root_path) with a success message.
  #    redirect_to root_path, notice: "Thank you for your interest! We will contact you shortly."
  #  else
      # 2. Failure: CRITICAL FIX.
      # We must render the 'home/index' view directly so that the @lead object (which now contains the errors) 
      # is passed to the homepage template, allowing the form to display error messages.
  #    render 'home/index', status: :unprocessable_entity 
  #  end
  #end
  if @lead.save
      # 1. Generate the AI response using our existing Mailer logic
      # We save it to the database so you can see it in your dashboard later
      ai_response = LeadMailer.new.send(:generate_ai_context, @lead.message)
      @lead.update(ai_response: ai_response)

      # 2. Send the confirmation email in the background
      LeadMailer.confirmation_email(@lead).deliver_later

      # 3. Respond with Turbo Stream for the "Instant" feel
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("ai-report-container", 
            partial: "leads/ai_report", 
            locals: { content: ai_response })
        end
        format.html { redirect_to root_path, notice: "Inquiry received!" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters: Essential security practice to allow only specific, safe fields to be mass-assigned.
  #def lead_params
    # Check if the :lead key exists. If so, use standard strong parameters.
  #  if params[:lead]
  #    params.require(:lead).permit(:name, :email, :country, :message)
  #  else
      # If :lead key is missing (a common issue with Turbo/JS form handling),
      # assume the parameters are at the top level and permit them directly.
  #    params.permit(:name, :email, :country, :message)
  #  end
  #end
  def lead_params
    # Permitting the new budget and timeline fields
    params.require(:lead).permit(:name, :email, :country, :message, :budget, :timeline)
  end
end
