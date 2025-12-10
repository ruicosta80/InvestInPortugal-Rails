class Lead < ApplicationRecord
  # Ensures that the name, email, and message fields are present (not blank).
  validates :name, presence: true
  validates :email, presence: true
  validates :message, presence: true

  # Ensures the email format is valid before saving.
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  # --- NEW CSV EXPORT METHOD ---
  def self.to_csv
    # Include necessary library
    require 'csv'

    # Define the header row for the CSV file
    attributes = %w[id name email country message created_at]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |lead|
        # Map the lead attributes to the CSV row, ensuring all fields are present
        csv << attributes.map { |attr| lead.send(attr) }
      end
    end
  end
  # -----------------------------
end
