# frozen_string_literal: true

# Base 64 images can be used in place of img URLs to reduce the number of filestack translations
# cropper.js includes some functions that allow base 64 strings to be saved for cropped images (tags)


class Tag < ApplicationRecord
  belongs_to :image, optional: true
  belongs_to :product

  include PgSearch
  include PgSearch::Model
  pg_search_scope :search, against: %i[category transcription],
                           using: {
                             tsearch: { dictionary: 'english' },
                             trigram: { threshold: 0.1 }
                           }

  def self.search(search)
    if search
      rank = <<-RANK
        ts_rank(to_tsvector(category), plainto_tsquery(#{sanitize(search)})) +
        ts_rank(to_tsvector(transcription), plainto_tsquery(#{sanitize(search)}))
      RANK

      where("to_tsvector('english', category) @@ plainto_tsquery(:q) or to_tsvector('english', transcription) @@ plainto_tsquery(:q)", q: search).order("#{rank} desc")
    else
      all
    end
  end

  def self.transcribe(img_url, tag)
    # Quota set on GCS dashboard: 800 transcriptions every 30 days, 20 per minute...
    # - https://cloud.google.com/apis/docs/capping-api-usage
    # make sure vision is activated along with key being activated and unrestricted
    api_key = 'API_KEY_GOES_HERE' # put your API Key here when you want to use google vision
    # If you do not want vision results and or do not want your key uploaded onto github then put 'API_KEY_GOES_HERE' in place of it on the above line

    # Do not replace the 'API_KEY_GOES_HERE' below, this is a placeholder check to see if there is no key, put your api key in the above line
    return if api_key == 'API_KEY_GOES_HERE' # If there is not an active api key then this will prevent the code below from running

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
      p response.body
      # transcription = data['responses'][0]['textAnnotations'][0]['description']
      # @tag.update(visionResult: transcription, isVisionTrue: true) # if run from controller
      # tag.update(visionResult: transcription, isVisionTrue: true)
    when Net::HTTPUnauthorized
      puts 'Add/Setup API Key'
      puts response.body
    when Net::HTTPForbidden
      puts 'Monthly Quota Reached'
      puts response.body
    when Net::HTTPServerError
      puts 'Server-side Error'
      puts response.body
    else
      puts 'Other Error - https://cloud.google.com/storage/docs/json_api/v1/status-codes'
      puts response
      puts response.body
    end
  end

end
