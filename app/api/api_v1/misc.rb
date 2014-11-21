module APIv1
  class Misc < Grape::API
    desc 'Check for updates'

    params do
      optional :platform, type: String, default: 'ios'
      optional :version, type: String, regexp: /^(\d+)\.(\d+)\.(\d+)$/
    end
    get '/updates' do
      version_key = "version.#{params[:platform]}"
      url_key = "update_url.#{params[:platform]}"
      version = Settings[version_key]
      if !version or Gem::Version.new(version) <= Gem::Version.new(params[:version])
        return {}
      else
        url = Settings[url_key]
        return {
            version: version,
            update_url: url
        }
      end
    end

    desc 'Leave a feedback'
    params do
      requires :content, type: String
    end

    post '/feedbacks' do
      status 204
      current_user.feedbacks.create(content: params[:content])
    end

  end
end