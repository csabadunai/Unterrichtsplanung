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
    @phase = Phase.new(position: params[:position])
    if params[:position]
      @phase.position = params[:position]
    end
  end

  # GET /phases/1/edit
  def edit
  end

  # POST /phases or /phases.json
  def create
    @phase = Phase.new(phase_params)

    if @phase.save
      # Redirect back to index with the editing flag
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
