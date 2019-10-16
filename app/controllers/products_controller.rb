# frozen_string_literal: true

class ProductsController < ApplicationController
  require 'open-uri'
  require 'net/http'
  require 'uri'
  require 'json'

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    # @products = Product.all
    @products = Product.all.paginate(page: params[:page], per_page: 6) # .search(params[:search]).paginate(page: params[:page], per_page: 3)
  end

  def show
    # @tag = Tag.new
    @tags = @product.tags
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        create_images(@product.handleBundle)

        format.html { redirect_to products_path, notice: 'Product was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        update_images(@product.handleBundle)

        format.html { redirect_to @product, notice: 'Product was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.'}
    end
  end

  private

  def create_images(handlebundle)
    handlebundle.split(',').each do |h|
      next if h.nil?

      if remote_file_exists?(filestack_url(h))
        @image = @product.images.create(handle: h, url: filestack_url(h))
        @image.save
      end

    end
  end

  def remote_file_exists?(url)
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")

    http.start do |http|
      return http.head(url.request_uri)['Content-Type'].start_with? 'image'
    end
  end

  def update_images(handlebundle)
    @images.each(&:destroy) # destroys all images belonging to product
    create_images(handlebundle) # rebuilds images ::: Make these only delete/replace images w/out tags?
  end

  def filestack_url(handle)
    'https://cdn.filestackcontent.com/' + handle
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :handleBundle)
  end

  def image_params
    params.permit(:handle, :url)
  end
end
