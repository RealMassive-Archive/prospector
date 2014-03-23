class ApiRequestsController < ApplicationController

  def index
    @api_requests = ApiRequest.all # TODO: Pagination
  end

  def show
    @req = ApiRequest.find(params[:id])
    render json: Yajl::Encoder.encode(@req)
  end

  def create
    @req = ApiRequest.new(params[:api_request])
    @req.status = "new"
    if @req.save
      render json: Yajl::Encoder.encode(@req)
    else
      render json: Yajl::Encoder.encode(
        {status: "failed", message: "api_request object failed to save"}
      )
    end
  end

end
