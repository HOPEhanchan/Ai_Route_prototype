# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@ai-route-prototype.onrender.com'
  layout 'mailer'
end
