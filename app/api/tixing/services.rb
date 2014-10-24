module Tixing
  class Services < Grape::API
    namespace :services do
      before do
        authenticate!
      end

      desc 'List all installed services for the current user'
      get '/' do

        installed = current_user.services
        uninstalled = Service.all.where.not(id: installed.map{|r| r.id})

        present :installed, installed, with:Tixing::Entities::Service
        present :uninstalled, uninstalled, with:Tixing::Entities::Service
      end

      desc 'List all services'
      get '/public' do
        present Service.all, with:Tixing::Entities::Service
      end


      desc 'Retrieve a single service'
      get '/:id' do
        service = Service.find(params[:id])
        present service, with:Tixing::Entities::Service
      end


      desc 'Install a service'
      put '/:id/installation' do
        status 204
        service = Service.find(params[:id])
        installation = current_user.installations.find_or_initialize_by(service: service)
        installation.save if installation.new_record?
      end

      desc 'Uninstall a service'
      delete '/:id/installation' do
        status 204
        service = Service.find(params[:id])
        current_user.services.delete(service)
      end

    end
  end
end