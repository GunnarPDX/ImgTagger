# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    # @products = Product.all
    @products = Product.search(params[:search])
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

      @image = @product.images.create(handle: h, url: filestack_url(h))
      @image.save
    end
  end

  def update_images(handlebundle)
    @images.each(&:destroy) # destroys all images belonging to product
    create_images(handlebundle) # rebuilds images ::: Make this only delete/replace images w/out tags?
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
