class Service::ShunfengController < Service::BaseServiceController
  before_action :authorize!

  def index
    @monitorings = Shunfeng::Monitoring.includes('product').where(user: current_user)
    if params[:partial]
      render partial: 'product' and return
    end
  end

  def edit
    @monitoring = Shunfeng::Monitoring.includes(:product).find(params[:id])
    @product = @monitoring.product
    @price = @monitoring.threshold
    render partial: 'modal'
  end

  def search
    @product = Shunfeng::Product.fetch(params[:id])
    if @product
      @price = @product.price.to_i - 1
      render partial: 'modal' and return
    else
      render json: {error: {message: '没有找到该商品'} }, status:404
    end
  end

  def create
    @product = Shunfeng::Product.find(params[:product_id])
    threshold = params[:threshold].to_f
    @monitoring = Shunfeng::Monitoring.find_or_initialize_by(user: current_user, product: @product)
    @monitoring.threshold = threshold
    @monitoring.disabled = (threshold >= @product.price)? true: false
    @monitoring.save
  end

  def destroy
    Shunfeng::Monitoring.where(id: params[:id], user: current_user).destroy_all
    render nothing: true
  end

end
