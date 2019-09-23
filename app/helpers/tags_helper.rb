# frozen_string_literal: true

module TagsHelper

  require 'open-uri'
  require 'net/http'
  require 'uri'
  require 'json'

  def transcribe(img_url)

    uri = URI.parse('https://vision.googleapis.com/v1/images:annotate?key=' + 'API_KEY_GOES_HERE')
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = JSON.dump(
      'requests' => [
        {
          'image' => {
            'source' => {
              'imageUri' => img_url
            }
          },
          'features' => [
            {
              'type' => 'TEXT_DETECTION',
              'maxResults' => 1,
              'model' => 'builtin/latest'
            }
          ]
        }
      ]
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    # p response
    # p response.code

    # p response.body

    data = JSON.parse(response.body)
    # p data

    transcription = data['responses'][0]['textAnnotations'][0]['description']
    p transcription
  end
end
