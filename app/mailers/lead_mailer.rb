class LeadMailer < ApplicationMailer
  default from: 'investeeriportugali@gmail.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.lead_mailer.new_lead_notification.subject
  #
  def new_lead_notification(lead)
    @lead = lead
    # The email address that will RECEIVE the notification
    mail(to: 'investeeriportugali@gmail.com', subject: "NEW Lead Received for Invest in Portugal!")
  end
end
