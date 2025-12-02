class StoriesController < ApplicationController
  # before_action :authenticate_user!, except: %i[ index ]
  before_action :authenticate_user!, only: %i[ new create ]
  before_action :set_story, only: %i[ show edit update destroy ]

  def index
    @stories = Story.all.order("RANDOM()")
  end

  def show
    @current_time = Time.now
    @story = Story.find(params[:id])
  end

  def new
    @story = current_user.stories.build
    # @story = Story.new
  end

  def create
    @story = current_user.stories.build(story_params)
    # @story = Story.new(story_params)

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
      params.expect(story: [ :name, :link ])
    end
end
