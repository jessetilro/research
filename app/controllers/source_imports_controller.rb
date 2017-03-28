class SourceImportsController < ApplicationController
  include ProjectScoped

  def create
    prms = source_import_params
    sources = []

    # Sources from BibTeX text input
    sources += Source.from_bibliography prms[:bibtex_text] if prms[:bibtex_text].present?

    # Sources from BibTeX file input
    if prms[:bibtex_file].present?
      file = prms[:bibtex_file]
      text = file.respond_to?(:read) ? file.read : File.read(file.path)
      sources += Source.from_bibliography text
    end

    # Either all Sources are imported, or none of them
    begin
      Source.transaction do
        sources.each do |src|
          src.user = current_user
          src.project = @project
          src.save!
        end
      end
    rescue
      flash[:danger] = "Failed to import at least one of the #{sources.size} sources, so transaction rolled back..."
      redirect_to project_sources_url(@project)
    else
      flash[:success] = "Succesfully imported #{sources.size} sources!"
      redirect_to project_sources_url(@project)
    end
  end

  protected
  def source_import_params
    params.require(:source_import).permit(
      :bibtex_text,
      :bibtex_file
    )
  end
end
