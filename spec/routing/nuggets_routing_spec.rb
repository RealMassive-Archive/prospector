require "spec_helper"

describe NuggetsController do
  describe "routing" do

    it "routes to #index" do
      get("/nuggets").should route_to("nuggets#index")
    end

    it "routes to #new" do
      get("/nuggets/new").should route_to("nuggets#new")
    end

    it "routes to #show" do
      get("/nuggets/1").should route_to("nuggets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/nuggets/1/edit").should route_to("nuggets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/nuggets").should route_to("nuggets#create")
    end

    it "routes to #update" do
      put("/nuggets/1").should route_to("nuggets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/nuggets/1").should route_to("nuggets#destroy", :id => "1")
    end

  end
end
