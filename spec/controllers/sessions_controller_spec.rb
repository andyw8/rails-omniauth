describe SessionsController, :omniauth do

  before do
    request.env['omniauth.auth'] = auth_mock
  end

  describe "#create" do

    it "creates a user" do
      expect {post :create, provider: :twitter}.to change{ User.count }.by(1)
    end

    it "creates a session" do
      expect(session[:user_id]).to be_nil
      post :create, provider: :twitter
      expect(session[:user_id]).to_not be_nil
    end

    it "redirects the user to the user profile" do
      post :create, provider: :twitter
      expect(response).to redirect_to edit_user_path(1)
    end

  end

  describe "#destroy" do

    before do
      post :create, provider: :twitter
    end

    it "resets the session" do
      session[:user_id].should_not be_nil
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the home page" do
      delete :destroy
      expect(response).to redirect_to root_url
    end

  end

end
