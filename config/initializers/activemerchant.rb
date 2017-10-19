if Rails.env == "development"
    ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device = File.open(Rails.root.join("log","active_merchant.log"), "a+")
    ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device.sync = true
    ActiveMerchant::Billing::Base.mode = :test
end

GATEWAY = ActiveMerchant::Billing::FirstdataE4Gateway.new({
      login: Rails.configuration.gateway['login'],
      password: Rails.configuration.gateway['password']
})