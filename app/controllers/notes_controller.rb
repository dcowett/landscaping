class NotesController < ApplicationController
  # GET /notes/
  def index
    @notes = Note.all.order("updated_at DESC").page(params[:page]).per(100)

    respond_to do |format|
      format.html
      format.csv { send_data Note.to_csv, filename: "notes-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv" }
    end
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    @note.property = @property
    respond_to do |format|
      if @note.save
        format.html { redirect_to @notes, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  #  Import CSV file of notes
  def import
    import_file = params[:file]
    if import_file.present? && import_file.content_type == "text/csv"
      Note.import(import_file)
      redirect_to notes_path, notice: "Notes added succuessfully"
    else
      redirect_to new_note_path, notice: "CSV file required"
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def note_params
      params.expect(note: [ :code, :notes, :property_id ])
    end
end
