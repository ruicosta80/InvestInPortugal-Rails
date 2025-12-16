class LeadMailer < ApplicationMailer
  default from: 'investeeriportugali@gmail.com'
  require 'faraday'
  require 'json'
  
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
  # 1. Configuration
  api_key = ENV.fetch("GEMINI_API_KEY")
  # REVISED PROMPT: More flexible, allows specific answers but maintains professional tone
  prompt = "Based on this user inquiry: '#{message}', provide a short, one-paragraph, professional, and informative response. If the query is a simple factual question, answer it directly while maintaining a helpful tone related to investing or living in Portugal. If the query is complex, provide a positive summary. Start with 'Regarding your interest in...' and only output the paragraph."

  # 2. API Call (using a basic Faraday setup)
  conn = Faraday.new(
    url: 'https://generativelanguage.googleapis.com',
    headers: {
      'Content-Type' => 'application/json',
      'x-goog-api-key' => api_key
    }
  )

  payload = {
    contents: [{ parts: [{ text: prompt }] }],
    # CHANGE THIS KEY NAME
    generationConfig: { # <--- FIX: Renamed 'config' to 'generationConfig'
    temperature: 0.7,
    max_output_tokens: 500
    }
  }

  begin
    response = conn.post('/v1beta/models/gemini-2.5-flash:generateContent') do |req|
      req.body = payload.to_json
    end

    # 3. Process Response
    if response.success?
      data = JSON.parse(response.body)
      # Extract text from the nested structure
      return data.dig('candidates', 0, 'content', 'parts', 0, 'text') || "We received your inquiry and are preparing a detailed response."
    else
      Rails.logger.error "Gemini API Error: #{response.status} - #{response.body}"
      # Fallback if API fails
      return "We received your inquiry, but there was a minor issue generating the AI summary. Rest assured, we are preparing a detailed response."
    end
  rescue => e
    Rails.logger.error "Network error contacting Gemini: #{e.message}"
    return "We received your inquiry, but there was a network issue. Rest assured, we are preparing a detailed response."
  end
end
end
