class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story

  def create
    emoji = params.dig(:reaction, :emoji).to_s

    if emoji.blank?
      flash.now[:alert] = "Pick an emoji first."
      return respond_reactions
    end

    existing = @story.reactions.find_by(user: current_user, emoji: emoji)

    if existing
      existing.destroy
      flash.now[:notice] = "Removed reaction #{emoji}"
    else
      reaction = @story.reactions.build(user: current_user, emoji: emoji)
      if reaction.save
        flash.now[:notice] = "Reacted with #{emoji}"
      else
        flash.now[:alert] = reaction.errors.full_messages.to_sentence
      end
    end

    respond_reactions
  end

  private

  def set_story
    @story = Story.find(params[:story_id])
  end

  def respond_reactions
    respond_to do |format|
      format.turbo_stream # renders create.turbo_stream.erb automatically
      format.html { redirect_to @story, notice: flash.now[:notice], alert: flash.now[:alert] }
    end
  end
end
