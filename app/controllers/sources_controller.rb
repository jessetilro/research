class SourcesController < ApplicationController

  def index
    @sources = Source.all
  end

end
