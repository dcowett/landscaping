class NotesController < ApplicationController

  # GET /notes/
  def index
    @notes = Note.all.order("created_at DESC")

    respond_to do |format|
      format.html
      format.csv { send_data Note.to_csv, filename: "notes-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv" }
    end
  end

  private

     def set_property
      @property = Property.find(params[:property_id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.expect(note: [ :code, :notes, :property_id ])
    end
end
