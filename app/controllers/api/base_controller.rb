module Api
  class BaseController < ApplicationController
    before_action :authenticate_api_user!
  end
end
