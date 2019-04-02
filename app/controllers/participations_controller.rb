class ParticipationsController < ApplicationController
  load_and_authorize_resource

  def destroy
    @participation.destroy

    if @participation.destroyed?
      redirect_to projects_url, notice: "Succesfully left project '#{@participation.project.name}'"
    else
      redirect_to projects_url, alert: "Unable to leave '#{@participation.project.name}'"
    end
  end
end
