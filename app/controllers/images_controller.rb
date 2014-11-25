class ImagesController < ApplicationController
  def index
    @images = Image.all
  end

  def new
    @image = Image.new
  end

  def show
    find_image
  end

  def create
    @image = current_user.images.build(image_params)
    if @image.save
      redirect_to @image
    else
      redirect_to :back
    end
  end

  def edit
    find_image
  end

  def update
    find_image
    if @image.update(image_params)
      redirect_to @image
    else
      redirect_to :back
    end
  end

  def destroy
    image = Image.find(params[:id])
    image.destroy
    redirect_to dashboard_path
  end

  private

  def find_image
    @image ||= Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(
      :name,
      :description,
      :url,
      :user_id
      )
  end
end
