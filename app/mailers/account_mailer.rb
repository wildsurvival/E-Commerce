class AccountMailer < ActionMailer::Base
    default :from => "achoate@capital.edu"

    def registration_confirmation(account)
        @account = account
        mail(:to => account.email, :subject => "E-Commerce - Confirm your account")
    end
end