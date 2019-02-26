class SourceDropsController < ApplicationController
  include ProjectScoped

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

    if prms[:document].present?
      source.document = prms[:document]
    elsif prms[:document_url].present?
      filename = File.basename(prms[:document_url])
      file = open(prms[:document_url])
      source.document.attach(io: file, filename: filename)
    end

    source.title ||= 'Untitled source'

    if source.save
      flash[:success] = "Succesfully added the source!"
      redirect_to project_sources_url(@project)
    else
      flash[:danger] = "Failed to add the source, so transaction rolled back..."
      redirect_to project_sources_url(@project)
    end
  end

  protected
  def source_drop_params
    params.require(:source_drop).permit(
      :id,
      :bibtex_text,
      :bibtex_url,
      :document,
      :document_url,
      :title
    )
  end
end
