class StoriesController < ApplicationController
  # before_action :authenticate_user!, only: %i[ new create ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_story, only: %i[ show edit update destroy ]

  def like
    @story = Story.find(params[:id])
    @like = current_user.likes.find_or_create_by(reference: @story) do |l|
      l.value = 1
    end
    redirect_to story_path(@story)
  end

  def index
    if !params[:stories_search].nil?
      search = params[:stories_search].to_s.strip
      @stories = Story.where("name ILIKE ?", "%#{search}%").page(params[:page]).per(50)
    else
      @stories = Story.all.order("updated_at DESC").page(params[:page]).per(50)
    end

    respond_to do |format|
      format.html
      format.csv { send_data Story.to_csv, filename: "stories-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv" }
    end
  end

  def show
    @current_time = Time.now
    @story = Story.find(params[:id])
  end

  def new
    @story = current_user.stories.build
  end

  def create
    @story = current_user.stories.build(story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: "Story was successfully created." }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /stories/1/edit
  def edit
  end

  # PATCH/PUT /stories/1 or /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to @story, notice: "Story was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1 or /stories/1.json
  def destroy
    @story.destroy!

    respond_to do |format|
      format.html { redirect_to stories_path, notice: "Story was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  #  Import CSV file of stories
  def import
    import_file = params[:file]
    if import_file.present? && import_file.content_type == "text/csv"
      Story.import(import_file)
      redirect_to stories_path, notice: "Stories added succuessfully"
    else
      redirect_to new_story_path, notice: "CSV file required"
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
      #  redirect_to '/404'
      flash[:error] = e
      redirect_to stories_path
    end

    # Only allow a list of trusted parameters through.
    def story_params
      params.require(:story).permit(:name, :link, :description, :tag_list)
    end

    def like_params
      params.require(:like).permit(:value, :user_id, :reference_id, :reference_type)
    end
end
