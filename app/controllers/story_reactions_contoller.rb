class StoryReactionsController < ApplicationController
  before_action :authenticate_user!

def create
  @story = Story.find(params[:story_id])
  @reaction = @story.reactions.create!(reaction_params.merge(user: current_user))

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to @story }
  end
end

private

def reaction_params
  params.require(:reaction).permit(:emoji)
end
