# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Depot::Application.configure do
    config.action_mailer.delivery_method = :smtp

    config.action_mailer.smtp_setting = {
        address: "smtp.gmail.com",
        port: 587,
        domein: "smtp.gmail.com",
        authentication: "plain",
        user_name: "cafe.commune20@gmail.com",
        password: "yoshihiro88",
        enable_starttls_auto: true
    }
end