class ApplicationMailbox < ActionMailbox::Base
  # Telling Rails that any email to support@example.com should be handled by class SupportMailbox
  routing "support@example.com" => :support
end
