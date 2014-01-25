class Api::BrokerEmailsController < ApplicationController
  skip_before_filter :cheap_authentication
  skip_before_filter :verify_authenticity_token

  def create
    @message = Message.new(message_body: request.body.read, received_at: Time.now.utc)
    @message.save # Shove it in the DB for later processing

    # Enqueue the worker for Resque then tell Postmark that everything's cool.
    Resque.enqueue(BrokerEmailWorker, @message.id)
    return render nothing: true, status: 200
  end
end
