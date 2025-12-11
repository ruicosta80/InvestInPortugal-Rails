class Admin::LeadsController < ApplicationController
  # CRITICAL: Forces the user to log in before accessing any action in this controller.
 layout 'admin' # <--- NEW LINE 
 before_action :authenticate_admin_user!
 before_action :set_cache_headers # <--- NEW LINE

  def index
    # Use Kaminari to paginate the leads: 10 leads per page
    @leads = Lead.all.order(created_at: :desc).page(params[:page]).per(10)
  end
  # GET /admin/leads/:id
  def show
    @lead = Lead.find(params[:id])
  end
  # GET /admin/leads/export
  def export
    # Call the CSV method on the Lead model
    @leads = Lead.to_csv

    # Set headers to force the browser to download the data as a CSV file
    send_data @leads, 
              filename: "leads-export-#{Date.today}.csv", 
              type: 'text/csv; charset=utf-8'
  end
  # DELETE /admin/leads/:id
  def destroy
    @lead = Lead.find(params[:id])
    @lead.destroy
    redirect_to admin_root_path, notice: "Lead ID #{@lead.id} was successfully deleted."
  end

  private # <--- THIS IS REQUIRED!

  # --- NEW METHOD ---
  def set_cache_headers
    # Prevent caching of the admin pages
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  # ------------------
end
