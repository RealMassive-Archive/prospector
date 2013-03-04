class Api::NuggetsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    # make sure the thing posting has rights to post here... maybe with
    # http basic auth or a super secret token

    n = Nugget.create_from_postmark(Postmark::Mitt.new(request.body.read))

    # do a bunch of stuff like send an email back if the user can't be
    # found, doesn't exist, etc.

    render :text => "Created a Postmark nugget", :status => :created
  end

  private
  def clean_field(str)
    str.gsub(/\n/,'') if str
  end
end
