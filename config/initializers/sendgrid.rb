# config/initializers/sendgrid.rb

ActionMailer::Base.sendgrid_settings = {
  api_key: ENV.fetch("SENDGRID_API_KEY")
}
