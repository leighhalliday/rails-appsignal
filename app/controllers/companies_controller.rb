class CompaniesController < ApplicationController
  def index
    begin
      raise "Please don't search this" if params[:q] == 'error'
    rescue RuntimeError => exception
      Appsignal.set_error(exception)
    end

    if params[:q].present?
      company = Company.find_by(symbol: params[:q].upcase)
      company ||= Company.name_imatch(params[:q]).first
      if company.present?
        return(
          redirect_to(
            company_url(exchange: company.exchange.name, symbol: company.symbol)
          )
        )
      end
    end

    Appsignal.instrument('fetch.companies') do
      @companies =
        if params[:q].present?
          Rails.cache.fetch(
            "/v2/companies/search/#{params[:q]}",
            expires_in: 15.minutes
          ) { Company.search(params[:q]).includes(:exchange).limit(20).to_a }
        else
          Company.none
        end
    end
  end

  def show
    @exchange = Exchange.find_by!(name: params[:exchange].upcase)
    @company = @exchange.companies.find_by(symbol: params[:symbol].upcase)
  end

  def register
    company = Company.find(params[:id])

    if params[:email].present?
      SendRegisterEmailWorker.perform_async(company.id, params[:email])
    end

    redirect_to(
      company_url(exchange: company.exchange.name, symbol: company.symbol)
    )
  end
end
