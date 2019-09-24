# frozen_string_literal: true

class TagsController < ApplicationController
  require 'open-uri'
  require 'net/http'
  require 'uri'
  require 'json'

  before_action :set_tag, only: %i[edit update destroy]

  def index
    @tags = Tag.search(params[:search]).paginate(page: params[:page], per_page: 7)
  end

  def edit
    # @image = Image.find(@tag.image_id)
  end

  def create
    @product = Product.find(params[:product_id])
    @tag = @product.tags.create(tag_params)
    transcribe(@tag.fullUrl)

    respond_to do |format|
      if @tag.save!
        format.js
        format.html { redirect_to root_path, notice: 'Tag was successfully created.' }
      else
        error.js
        format.html { redirect_to root_path }
      end
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to tags_path, notice: 'Tag was successfully updated.' }
      else
        format.html { render :OLD_edit }
      end
    end
  end

  def destroy
    @tag.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to tags_path, notice: 'Tag was successfully destroyed.' }
    end
  end

  private

  def transcribe(img_url)
    uri = URI.parse('https://vision.googleapis.com/v1/images:annotate?key=' + 'API_KEY_GOES_HERE')
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = JSON.dump('requests' => [{ 'image' => { 'source' => { 'imageUri' => img_url } }, 'features' => [{ 'type' => 'TEXT_DETECTION', 'maxResults' => 1, 'model' => 'builtin/latest' }] }])

    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    data = JSON.parse(response.body)
    transcription = data['responses'][0]['textAnnotations'][0]['description']
    @tag.update(visionResult: transcription)

    # make it only save vision result, and then build helper in view to set transcription to vision result...
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:category, :handle, :fullUrl, :cropX, :cropY, :cropH, :cropW, :rotate, :isTranscribed, :transcription, :image_id, :isVisionTrue, :visionResult)
  end
end
