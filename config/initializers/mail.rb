# Initializer for mail settings

ActionMailer::Base.default_url_options = { :host => Rails.configuration.settings["host"] }
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = Rails.configuration.mail