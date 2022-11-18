require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Depot
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Fix for Conductor throwing undefined method error
    config.to_prepare do 
      Rails::Conductor::ActionMailbox::InboundEmailsController.class_eval do
        private
        def new_mail
          Mail.new(mail_params.except(:attachments).to_h).tap do |mail|
            mail[:bcc]&.include_in_headers = true
            mail_params[:attachments].to_a.compact_blank.each do |attachment|
              mail.add_file(filename: attachment.original_filename, content: attachment.read)
            end
          end
        end
      end    
    end
  end
end
