# frozen_string_literal: true

class TagsController < ApplicationController
  require 'open-uri'
  require 'net/http'
  require 'uri'
  require 'json'

  before_action :set_tag, only: %i[edit update destroy]

  def index
    @tags = Tag.where(isTranscribed: !true).search(params[:search]).paginate(page: params[:page], per_page: 4)
  end

  def transcribed_tags
    @tags = Tag.where(isTranscribed: true).search(params[:search]).paginate(page: params[:page], per_page: 4)
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
        format.html { render :edit }
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
    api_key = 'API_KEY_GOES_HERE' # put your API Key here when you want to use google vision
    # If you do not want vision results and or do not want your key uploaded onto github then put 'API_KEY_GOES_HERE' in place of it on the above line

    # Do not replace the 'API_KEY_GOES_HERE' below, this is a placeholder check to see if there is no key, put your api key in the above line
    return if api_key == 'API_KEY_GOES_HERE' # If there is not active api key then this will prevent the code below from running

    uri = URI.parse('https://vision.googleapis.com/v1/images:annotate?key=' + api_key)
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = JSON.dump('requests' => [{ 'image' => { 'source' => { 'imageUri' => img_url } }, 'features' => [{ 'type' => 'TEXT_DETECTION', 'maxResults' => 1, 'model' => 'builtin/latest' }] }])

    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    case response
      when Net::HTTPSuccess
        data = JSON.parse(response.body)
        transcription = data['responses'][0]['textAnnotations'][0]['description']
        @tag.update(visionResult: transcription, isVisionTrue: true)
      when Net::HTTPUnauthorized
        puts 'Add/Setup API Key'
        puts response.body
      when Net::HTTPServerError
        puts 'Server-side Error'
        puts response.body
      else
        puts 'Other Error'
        puts response
        puts response.body
    end
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:category, :handle, :fullUrl, :cropX, :cropY, :cropH, :cropW, :rotate, :isTranscribed, :transcription, :image_id, :isVisionTrue, :visionResult)
  end
end
