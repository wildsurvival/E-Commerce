module SessionHelper
    def log_in(account)
        session[:account_id] = account.id
    end
    
    def log_out
        current_account.forget
        cookies.delete(:remember_token)
        cookies.delete(:account_id)
        session.delete(:account_id)
        @current_account = nil
    end
    
    def current_account
        if (account_id = session[:account_id])
          @current_account ||= Account.find_by_id(account_id)
        elsif (account_id = cookies.signed[:account_id])
          account = Account.find_by(id: account_id)
          if account && account.authenticated?(cookies[:remember_token])
            log_in account
            @current_account = account
          end
        end
    end
    
    def logged_in?
        !current_account.nil?
    end
    
    def remember(account)
        account.remember
        cookies.permanent.signed[:account_id] = account.id
        cookies.permanent[:remember_token] = account.remember_token
      end
end
