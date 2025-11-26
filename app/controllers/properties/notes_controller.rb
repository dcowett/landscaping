class Properties::NotesController < ApplicationController
  before_action :set_property
  before_action :set_note, except: [ :new, :create ]

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    @note.property = @property

    respond_to do |format|
      if @note.save
        format.html { redirect_to @property, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @property, notice: "Note was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
     @note = Note.find(params[:id])
     title = @note.id
     @note.destroy!

    respond_to do |format|
      format.html { redirect_to @property, notice: "Note_id: \"#{title}\" was successfully deleted.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params.expect(:id))
      rescue ActiveRecord::RecordNotFound => e
      #  redirect_to '/404'
      flash[:error] = e
      redirect_to properties_path
    end

     def set_property
      @property = Property.find(params[:property_id])
      rescue ActiveRecord::RecordNotFound => e
      #  redirect_to '/404'
      flash[:error] = e
      redirect_to properties_path
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.expect(note: [ :code, :notes, :property_id ])
    end
end
