class CropperController < ApplicationController
  before_action :set_data, only: [:new_tags]

  def new_tags
    @tag = Tag.new
  end

  private

  def set_data
    @product = Product.find(params[:product_id])
    @images = @product.images
    @tags = @product.tags
    # @product.tags.build
  end

  def tag_params
    params.require(:tag).permit(:category, :handle, :parentId, :cropX, :cropY, :cropH, :cropW, :rotate, :transcribed, :transcription)
  end

end
