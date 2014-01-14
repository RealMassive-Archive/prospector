class Api::NuggetsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :cheap_authentication

  # GET /api/nuggets/geofind.json
  def geofind
    #austin: 30.2669, -97.7428
    latitude = params['latitude']
    longitude = params['longitude']
    distance = params['distance']
    @nuggets = Nugget.near([latitude, longitude], distance)
    render json: @nuggets
  end


  # POST /api/nuggets
  def create
    @message = Message.new(message_body: request.body.read, received_at: Time.now.utc)
    @message.save # Shove it in the DB for later processing

    # Enqueue the worker for Resque then tell Postmark that everything's cool.
    Resque.enqueue(NuggetWorker, @message.id)
    return render nothing: true, status: 200
  end

private
  def clean_field(str)
    str.gsub(/\n/,'') if str
  end
end
