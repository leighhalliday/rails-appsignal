class SendRegisterEmailWorker
  include Sidekiq::Worker

  def perform(company_id, email)
    p [self.class.name, company_id, email]
    sleep(1)
  end
end
