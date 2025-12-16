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
    mail(
         to: 'investeeriportugali@gmail.com', 
         subject: "NEW Lead Received for Invest in Portugal!"
        )
  end
  # --- NEW CONFIRMATION EMAIL METHOD ---
  def confirmation_email(lead)
    @lead = lead
    @ai_context = generate_ai_context(lead.message) # Get AI response here

    mail(
      to: @lead.email, # Send to the user's email
      subject: "Your Investment Inquiry Confirmation"
    )
  end
  private

  def generate_ai_context(message)
    # Convert message to lowercase for case-insensitive checking
    text = message.downcase

    # Define keywords and corresponding AI-generated context snippets
    context_data = {}

    if text.include?('tax') || text.include?('fiscal')
      # Context generated from search result 1.1, 1.2, 1.3
      context_data[:taxes] = "I see you're interested in the fiscal side of things. Tax residents in Portugal are generally taxed on worldwide income with progressive rates (13% to 48%), and capital gains on shares are often taxed at a flat 28%. While the former NHR scheme has ended for new applicants, new incentives exist for qualified professionals. We'll connect you with a specialist to discuss your specific tax situation and residency status."
    end

    if text.include?('weather') || text.include?('climate') || text.include?('sunshine')
      # Context generated from search result 2.1, 2.3, 2.4
      context_data[:weather] = "Portugal enjoys a mild Mediterranean climate, heavily influenced by the Atlantic. The south (Algarve) is the sunniest and warmest, averaging 16°C in winter, while the north (Porto) is cooler and wetter in the winter months. Regardless of the region, you can expect plentiful sunshine throughout the year. We can help you choose a region that best suits your climate preferences!"
    end

    # Default fallback message if no keyword is found
    if context_data.empty?
      return "I've noted your interest in **#{message.truncate(35)}**. We are preparing a personalized guide that addresses this request in detail."
    else
      # Combine multiple detected contexts into a single block
      intro = "I noticed you specifically asked about a few key topics. Here is some immediate information while we wait for your advisor to reach out:"
      return intro + "\n\n" + context_data.values.join("\n\n")
    end
  end
end
