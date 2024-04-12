Amber::Server.configure do
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    # plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
  end

  pipeline :api do
    # plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CORS.new(
      methods: %w(GET POST PUT PATCH DELETE OPTIONS),
    )
  end

  # All static content will run these transformations
  pipeline :static do
    # plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
  end

  routes :web do
    websocket "/devices", DevicesSocket
  end

  routes :api, "/api" do
    get "/", Api::HomeController, :index

    resources "/devices", Api::DevicesController, except: [:new, :edit]
    resources "/devices/:device_id/switches", Api::SwitchesController, except: [:new, :edit]

    get "/profile", Api::UsersController, :show
    patch "/profile", Api::UsersController, :update
    delete "/profile", Api::UsersController, :destroy

    get "/devices/:device_id/api_key", Api::KeysController, :show
    post "/devices/:device_id/api_key", Api::KeysController, :create
    delete "/devices/:device_id/api_key", Api::KeysController, :destroy
    post "/devices/:device_id/restart", Api::DevicesController, :restart

    get "/sessions/detail", Api::SessionsController, :detail
    get "/sessions/validation", Api::SessionsController, :validation
    post "/sessions/register", Api::SessionsController, :register
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", Amber::Controller::Static, :index
  end
end
