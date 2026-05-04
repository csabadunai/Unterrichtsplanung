class PhasesController < ApplicationController
  before_action :set_phase, only: %i[ show edit update destroy move_lower move_higher ]

  # GET /phases or /phases.json
  def index
    @phases = Phase.order(:position)
  end

  # GET /phases/1 or /phases/1.json
  def show
  end

  # GET /phases/new
  def new
    # If no position is passed, put it at the end of the list
    new_position = params[:position] || (Phase.maximum(:position).to_i + 1)
    @phase = Phase.new(position: new_position)
  end

  # GET /phases/1/edit
  def edit
  end

  # POST /phases or /phases.json
  def create
    # Extract the attributes regardless of whether params[:phases] is an Array or Hash
    bulk_params = params[:phases]

    attributes = if bulk_params.is_a?(Array)
                   # Case 1: Array (happens on the 'new' page)
                   bulk_params.first
                 elsif bulk_params.is_a?(Hash)
                   # Case 2: Hash (happens if IDs are present)
                   bulk_params.values.first
                 end

    # Permit the data if we found it, otherwise fall back to standard phase_params
    safe_attributes = attributes ? attributes.permit(:duration, :social, :description, :differentiation, :materials, :position) : phase_params

    @phase = Phase.new(safe_attributes)

    if @phase.save
      redirect_to phases_path(editing: true), notice: "Phase inserted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /phases/1 or /phases/1.json
  def update
    respond_to do |format|
      if @phase.update(phase_params)
        # Redirect to index instead of show, keeping the edit mode if it was active
        format.html { redirect_to phases_path(editing: params[:editing]), notice: "Phase was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phases/1 or /phases/1.json
  def destroy
    @phase.destroy!

    respond_to do |format|
      format.html { redirect_to phases_path, notice: "Phase was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def bulk_update
    params[:phases].each do |id, attributes|
      phase = Phase.find(id)
      safe_attributes = attributes.permit(:duration, :social, :description, :differentiation, :materials, :position)
      phase.update(safe_attributes)
    end

    # Redirect back to the clean index (Display Mode)
    redirect_to phases_path, notice: "All phases updated successfully."
  end

  def move_higher
    if @phase.move_higher
    else
      flash[:alert] = "Could not move phase"
    end

    redirect_to phases_path(editing: params[:editing])
  end

  def move_lower
    if @phase.move_lower
    else
      flash[:alert] = "Could not move phase"
    end

    redirect_to phases_path(editing: params[:editing])
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_phase
    @phase = Phase.find(params.expect(:id))
  end

    # Only allow a list of trusted parameters through.
    def phase_params
      params.expect(phase: [ :duration, :social, :description, :differentiation, :materials, :position ])
    end
end
