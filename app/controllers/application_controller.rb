class ApplicationController < ActionController::Base
  # Apply cache headers ONLY if an AdminUser is currently signed in.
  # This fixes the session persistence after sign out.
  before_action :set_cache_headers, if: :admin_user_signed_in?

  private

  def set_cache_headers
    # Prevent caching of the admin pages
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
