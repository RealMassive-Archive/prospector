class NuggetsController < ApplicationController
  before_filter :authenticate_user!

  # GET /nuggets
  # GET /nuggets.json
  def index
    @nuggets = Nugget.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nuggets }
    end
  end

  # GET /nuggets/1
  # GET /nuggets/1.json
  def show
    @nugget = Nugget.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nugget }
    end
  end

  # GET /nuggets/new
  # GET /nuggets/new.json
  def new
    @nugget = Nugget.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nugget }
    end
  end

  # GET /nuggets/1/edit
  def edit
    @nugget = Nugget.find(params[:id])
  end

  # POST /nuggets
  # POST /nuggets.json
  def create
    @nugget = Nugget.new(params[:nugget])

    respond_to do |format|
      if @nugget.save
        format.html { redirect_to @nugget, notice: 'Nugget was successfully created.' }
        format.json { render json: @nugget, status: :created, location: @nugget }
      else
        format.html { render action: "new" }
        format.json { render json: @nugget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nuggets/1
  # PUT /nuggets/1.json
  def update
    @nugget = Nugget.find(params[:id])

    respond_to do |format|
      if @nugget.update_attributes(params[:nugget])
        format.html { redirect_to @nugget, notice: 'Nugget was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nugget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nuggets/1
  # DELETE /nuggets/1.json
  def destroy
    @nugget = Nugget.find(params[:id])
    @nugget.destroy

    respond_to do |format|
      format.html { redirect_to nuggets_url }
      format.json { head :no_content }
    end
  end

  def no_gps
    nugget = Nugget.find(params[:id])
    nugget.no_gps!

    respond_to do |format|
      format.html { redirect_to dashboard_url }
      format.json { head :no_content }
    end
  end

  def extract_metadata
  end

  def saved_to_cdn
  end

  def blurry
  end

  def inappropriate
  end

  def extract_phone
  end

  def broker_contacted
  end

end
