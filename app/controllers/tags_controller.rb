class TagsController < ApplicationController
  include ProjectScoped
  
  before_action :load_tags

  def index
    @tag = Tag.new
  end

  def create
    @tag = Tag.new tag_params
    if @tag.save
      flash[:success] = "Succesfully created the '#{@tag.name}' tag!"
      redirect_to project_tags_url(@project)
    else
      flash[:danger] = 'Failed to create the new tag...'
      render 'index'
    end
  end

  def update
    @tag = Tag.new
    tag = @tags.find params[:id]
    if tag.update(tag_params)
      flash[:success] = "Succesfully saved changes to the '#{tag.name}' tag!"
      redirect_to project_tags_url(@project)
    else
      @tags = @tags.to_a.map! { |t| t.id == tag.id ? tag : t }
      flash[:danger] = "Failed to save changes to the '#{tag.name}' tag..."
      render 'index'
    end
  end

  def destroy
    tag = @tags.find params[:id]
    if tag.destroy
      flash[:success] = "Succesfully deleted the '#{tag.name}' tag!"
    else
      flash[:danger] = "Failed to delete the '#{tag.name}' tag..."
    end
    redirect_to project_tags_url(@project)
  end

  protected
  def tag_params
    params.require(:tag).permit(:name, :description, :color)
  end

  def load_tags
    @tags = Tag.all
  end

end
