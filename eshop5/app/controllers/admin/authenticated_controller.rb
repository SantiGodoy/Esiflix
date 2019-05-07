class Admin::AuthenticatedController < ApplicationController
  before_action :require_user
end
