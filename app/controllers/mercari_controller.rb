class MercariController < ApplicationController
  include GetCategories
  before_action :get_root

  def index
  end
end
