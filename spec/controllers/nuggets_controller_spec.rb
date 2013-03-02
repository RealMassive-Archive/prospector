require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe NuggetsController do

  # This should return the minimal set of attributes required to create a valid
  # Nugget. As you add validations to Nugget, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {  }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # NuggetsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all nuggets as @nuggets" do
      nugget = Nugget.create! valid_attributes
      get :index, {}, valid_session
      assigns(:nuggets).should eq([nugget])
    end
  end

  describe "GET show" do
    it "assigns the requested nugget as @nugget" do
      nugget = Nugget.create! valid_attributes
      get :show, {:id => nugget.to_param}, valid_session
      assigns(:nugget).should eq(nugget)
    end
  end

  describe "GET new" do
    it "assigns a new nugget as @nugget" do
      get :new, {}, valid_session
      assigns(:nugget).should be_a_new(Nugget)
    end
  end

  describe "GET edit" do
    it "assigns the requested nugget as @nugget" do
      nugget = Nugget.create! valid_attributes
      get :edit, {:id => nugget.to_param}, valid_session
      assigns(:nugget).should eq(nugget)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Nugget" do
        expect {
          post :create, {:nugget => valid_attributes}, valid_session
        }.to change(Nugget, :count).by(1)
      end

      it "assigns a newly created nugget as @nugget" do
        post :create, {:nugget => valid_attributes}, valid_session
        assigns(:nugget).should be_a(Nugget)
        assigns(:nugget).should be_persisted
      end

      it "redirects to the created nugget" do
        post :create, {:nugget => valid_attributes}, valid_session
        response.should redirect_to(Nugget.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved nugget as @nugget" do
        # Trigger the behavior that occurs when invalid params are submitted
        Nugget.any_instance.stub(:save).and_return(false)
        post :create, {:nugget => {  }}, valid_session
        assigns(:nugget).should be_a_new(Nugget)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Nugget.any_instance.stub(:save).and_return(false)
        post :create, {:nugget => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested nugget" do
        nugget = Nugget.create! valid_attributes
        # Assuming there are no other nuggets in the database, this
        # specifies that the Nugget created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Nugget.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => nugget.to_param, :nugget => { "these" => "params" }}, valid_session
      end

      it "assigns the requested nugget as @nugget" do
        nugget = Nugget.create! valid_attributes
        put :update, {:id => nugget.to_param, :nugget => valid_attributes}, valid_session
        assigns(:nugget).should eq(nugget)
      end

      it "redirects to the nugget" do
        nugget = Nugget.create! valid_attributes
        put :update, {:id => nugget.to_param, :nugget => valid_attributes}, valid_session
        response.should redirect_to(nugget)
      end
    end

    describe "with invalid params" do
      it "assigns the nugget as @nugget" do
        nugget = Nugget.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Nugget.any_instance.stub(:save).and_return(false)
        put :update, {:id => nugget.to_param, :nugget => {  }}, valid_session
        assigns(:nugget).should eq(nugget)
      end

      it "re-renders the 'edit' template" do
        nugget = Nugget.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Nugget.any_instance.stub(:save).and_return(false)
        put :update, {:id => nugget.to_param, :nugget => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested nugget" do
      nugget = Nugget.create! valid_attributes
      expect {
        delete :destroy, {:id => nugget.to_param}, valid_session
      }.to change(Nugget, :count).by(-1)
    end

    it "redirects to the nuggets list" do
      nugget = Nugget.create! valid_attributes
      delete :destroy, {:id => nugget.to_param}, valid_session
      response.should redirect_to(nuggets_url)
    end
  end

end
