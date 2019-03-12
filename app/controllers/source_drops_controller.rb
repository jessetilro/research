class SourceDropsController < ApplicationController
  include ProjectScoped

  def show
    @sources = Source.by_project(@project)
  end

  def create
    prms = source_drop_params

    if prms[:id].present?
      source = Source.find(prms[:id])
    else
      source = Source.new(
        user: current_user,
        project: @project
      )
    end

    source.title = prms[:title] if prms[:title].present?

    source.assign_bibtex(prms[:bibtex_text]) if prms[:bibtex_text].present?
    source.assign_reference(prms[:reference_text]) if prms[:reference_text].present?

    if prms[:document].present?
      source.document = prms[:document]
    elsif prms[:document_url].present?
      source.document_url = prms[:document_url]
    end

    source.title ||= 'Untitled source'

    if source.save
      flash[:success] = "Succesfully added the source!"
      redirect_to project_source_drops_url(@project)
    else
      flash[:danger] = "Failed to add the source, so transaction rolled back..."
      redirect_to project_source_drops_url(@project)
    end
  end

  protected
  def source_drop_params
    params.require(:source_drop).permit(
      :id,
      :bibtex_text,
      :reference_text,
      :document,
      :document_url,
      :title
    )
  end
end
